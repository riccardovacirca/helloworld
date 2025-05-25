#include <podofo/podofo.h>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace PoDoFo;

// Struttura per memorizzare informazioni sul testo trovato
struct TextInfo {
    std::string text;
    int pageNum;
    double x, y;
};

// Funzione per normalizzare il testo (rimuove spazi extra, converte in lowercase)
std::string normalizeText(const std::string& text) {
    std::string normalized = text;
    // Rimuovi spazi multipli
    std::string::iterator new_end = std::unique(normalized.begin(), normalized.end(),
        [](char lhs, char rhs) { return (lhs == rhs) && (lhs == ' '); });
    normalized.erase(new_end, normalized.end());
    
    // Trim spazi iniziali e finali
    normalized.erase(0, normalized.find_first_not_of(" \t\n\r"));
    normalized.erase(normalized.find_last_not_of(" \t\n\r") + 1);
    
    // Converti in lowercase per ricerca case-insensitive
    std::transform(normalized.begin(), normalized.end(), normalized.begin(), ::tolower);
    
    return normalized;
}

// Funzione per cercare testo in modo più robusto
bool searchTextInPage(PdfPage* page, int pageNum, const std::string& searchString, 
                     std::vector<TextInfo>& foundTexts, bool debugMode = false) {
    
    std::vector<std::string> pageTexts;
    std::string concatenatedText;
    bool found = false;
    
    try {
        PdfContentsTokenizer tokenizer(page);
        const char* pszKeyword = nullptr;
        PdfVariant var;
        EPdfContentsType type;
        
        double currentX = 0, currentY = 0;
        
        if (debugMode) {
            std::cout << "\n=== Debug Pagina " << pageNum + 1 << " ===" << std::endl;
        }
        
        int textCount = 0;
        int keywordCount = 0;
        int otherCount = 0;
        
        while (tokenizer.ReadNext(type, pszKeyword, var)) {
            // Debug completo di tutti i tipi di contenuto
            if (debugMode) {
                switch(type) {
                    case ePdfContentsType_Keyword:
                        keywordCount++;
                        if (pszKeyword) {
                            std::string keyword(pszKeyword);
                            // Mostra solo alcuni keyword interessanti
                            if (keyword == "Tj" || keyword == "TJ" || keyword == "'" || keyword == "\"" ||
                                keyword == "Td" || keyword == "TD" || keyword == "Tm") {
                                std::cout << "Keyword: " << keyword << std::endl;
                            }
                        }
                        break;
                    case ePdfContentsType_Variant:
                        if (var.IsString()) {
                            textCount++;
                            std::string text = var.GetString().GetString();
                            std::cout << "TESTO[" << textCount << "]: '" << text << "' (len=" << text.length() << ")" << std::endl;
                        } else if (var.IsNumber()) {
                            // Non stampare tutti i numeri, sono troppi
                        } else if (var.IsArray()) {
                            std::cout << "Array con " << var.GetArray().size() << " elementi" << std::endl;
                        } else {
                            otherCount++;
                            std::cout << "Altro tipo variant" << std::endl;
                        }
                        break;
                    default:
                        otherCount++;
                        break;
                }
            }
            
            // Cerca stringhe di testo
            if (type == ePdfContentsType_Variant && var.IsString()) {
                std::string text = var.GetString().GetString();
                
                if (!text.empty()) {
                    pageTexts.push_back(text);
                    concatenatedText += text + " ";
                    
                    // Ricerca case-insensitive sulla stringa singola
                    std::string normalizedText = normalizeText(text);
                    std::string normalizedSearch = normalizeText(searchString);
                    
                    if (normalizedText.find(normalizedSearch) != std::string::npos) {
                        TextInfo info;
                        info.text = text;
                        info.pageNum = pageNum;
                        info.x = currentX;
                        info.y = currentY;
                        foundTexts.push_back(info);
                        found = true;
                        
                        if (debugMode) {
                            std::cout << "*** MATCH TROVATO: '" << text << "' ***" << std::endl;
                        }
                    }
                }
            }
            
            // Gestisci anche array che potrebbero contenere testo (come TJ)
            if (type == ePdfContentsType_Variant && var.IsArray()) {
                PdfArray textArray = var.GetArray();
                std::string arrayText = "";
                
                for (size_t i = 0; i < textArray.size(); i++) {
                    if (textArray[i].IsString()) {
                        arrayText += textArray[i].GetString().GetString();
                    }
                }
                
                if (!arrayText.empty()) {
                    pageTexts.push_back(arrayText);
                    concatenatedText += arrayText + " ";
                    
                    if (debugMode) {
                        std::cout << "TESTO da Array: '" << arrayText << "'" << std::endl;
                    }
                    
                    std::string normalizedText = normalizeText(arrayText);
                    std::string normalizedSearch = normalizeText(searchString);
                    
                    if (normalizedText.find(normalizedSearch) != std::string::npos) {
                        TextInfo info;
                        info.text = arrayText;
                        info.pageNum = pageNum;
                        info.x = currentX;
                        info.y = currentY;
                        foundTexts.push_back(info);
                        found = true;
                        
                        if (debugMode) {
                            std::cout << "*** MATCH TROVATO in Array: '" << arrayText << "' ***" << std::endl;
                        }
                    }
                }
            }
        }
        
        // Ricerca anche nel testo concatenato (per stringhe che attraversano più elementi)
        std::string normalizedConcatenated = normalizeText(concatenatedText);
        std::string normalizedSearch = normalizeText(searchString);
        
        if (!found && normalizedConcatenated.find(normalizedSearch) != std::string::npos) {
            TextInfo info;
            info.text = concatenatedText;
            info.pageNum = pageNum;
            info.x = 0;
            info.y = 0;
            foundTexts.push_back(info);
            found = true;
            
            if (debugMode) {
                std::cout << "*** MATCH nel testo concatenato ***" << std::endl;
            }
        }
        
        if (debugMode) {
            std::cout << "=== STATISTICHE PAGINA " << pageNum + 1 << " ===" << std::endl;
            std::cout << "Keywords trovate: " << keywordCount << std::endl;
            std::cout << "Stringhe di testo trovate: " << textCount << std::endl;
            std::cout << "Altri elementi: " << otherCount << std::endl;
            std::cout << "Testo concatenato: '" << concatenatedText << "'" << std::endl;
            std::cout << "Testo normalizzato: '" << normalizedConcatenated << "'" << std::endl;
            std::cout << "Ricerca normalizzata: '" << normalizedSearch << "'" << std::endl;
            std::cout << "Numero elementi di testo: " << pageTexts.size() << std::endl;
            
            if (textCount == 0) {
                std::cout << "⚠️  ATTENZIONE: Nessun testo trovato in questa pagina!" << std::endl;
                std::cout << "   Possibili cause:" << std::endl;
                std::cout << "   - Il testo è convertito in immagini" << std::endl;
                std::cout << "   - Il PDF usa font incorporati non standard" << std::endl;
                std::cout << "   - Il testo è codificato in modo particolare" << std::endl;
            }
        }
        
    } catch (const PdfError& e) {
        if (debugMode) {
            std::cerr << "Errore durante il parsing della pagina " << pageNum + 1 
                      << ": " << e.what() << std::endl;
        }
    }
    
    return found;
}

int main(int argc, char* argv[]) {
    if (argc < 4 || argc > 5) {
        std::cerr << "Uso: " << argv[0] << " <file_pdf> <stringa_da_cercare> <nome_campo_firma> [debug]" << std::endl;
        std::cerr << "Aggiungi 'debug' come quarto parametro per informazioni dettagliate" << std::endl;
        return 1;
    }

    std::string inputFile = argv[1];
    std::string searchString = argv[2];
    std::string fieldName = argv[3];
    bool debugMode = (argc == 5 && std::string(argv[4]) == "debug");
    std::string outputFile = inputFile.substr(0, inputFile.find_last_of('.')) + "_signed.pdf";

    std::cout << "Apertura file: " << inputFile << std::endl;
    std::cout << "Ricerca stringa: '" << searchString << "'" << std::endl;
    std::cout << "Nome campo firma: " << fieldName << std::endl;
    if (debugMode) {
        std::cout << "Modalità debug attiva" << std::endl;
    }

    try {
        // Apri il documento PDF
        PdfMemDocument document;
        document.Load(inputFile.c_str());
        
        std::cout << "PDF caricato. Numero di pagine: " << document.GetPageCount() << std::endl;

        // Ottieni o crea l'AcroForm
        PdfAcroForm* acroForm = document.GetAcroForm(true, ePdfAcroFormDefaultAppearance_BlackText12pt);

        std::vector<TextInfo> foundTexts;
        PdfPage* targetPage = nullptr;
        int targetPageNum = -1;

        // Scorri tutte le pagine
        for (int pageNum = 0; pageNum < document.GetPageCount(); ++pageNum) {
            PdfPage* page = document.GetPage(pageNum);
            
            if (debugMode) {
                PdfRect pageSize = page->GetPageSize();
                std::cout << "\nPagina " << pageNum + 1 << " - Dimensioni: " 
                          << pageSize.GetWidth() << "x" << pageSize.GetHeight() << std::endl;
            }
            
            if (searchTextInPage(page, pageNum, searchString, foundTexts, debugMode)) {
                if (targetPageNum == -1) {
                    targetPage = page;
                    targetPageNum = pageNum;
                }
            }
        }

        if (foundTexts.empty()) {
            std::cout << "\nStringa '" << searchString << "' non trovata nel documento." << std::endl;
            std::cout << "Suggerimenti:" << std::endl;
            std::cout << "1. Verifica che la stringa sia scritta esattamente come nel PDF" << std::endl;
            std::cout << "2. Prova con una parola singola" << std::endl;
            std::cout << "3. Usa il parametro 'debug' per vedere tutto il testo estratto" << std::endl;
            return 1;
        }

        std::cout << "\n=== RISULTATI RICERCA ===" << std::endl;
        std::cout << "Trovate " << foundTexts.size() << " occorrenze:" << std::endl;
        for (size_t i = 0; i < foundTexts.size(); ++i) {
            std::cout << i + 1 << ". Pagina " << foundTexts[i].pageNum + 1 
                      << ": '" << foundTexts[i].text << "'" << std::endl;
        }

        // Usa la prima occorrenza trovata
        std::cout << "\nCreazione campo di firma sulla pagina " << targetPageNum + 1 << std::endl;

        // Calcola posizione del campo (più intelligente)
        PdfRect pageRect = targetPage->GetPageSize();
        double fieldWidth = 150;
        double fieldHeight = 40;
        
        // Posiziona il campo in basso a destra per default
        double fieldX = pageRect.GetWidth() - fieldWidth - 50;
        double fieldY = 50; // Dal basso
        
        PdfRect fieldRect(fieldX, fieldY, fieldWidth, fieldHeight);
        
        std::cout << "Posizione campo: x=" << fieldX << ", y=" << fieldY 
                  << ", w=" << fieldWidth << ", h=" << fieldHeight << std::endl;

        // Crea il campo di firma
        PdfPushButton* signatureField = new PdfPushButton(targetPage, fieldRect, &document);
        
        // Configura il campo come campo di firma
        PdfObject* fieldObj = signatureField->GetFieldObject();
        fieldObj->GetDictionary().AddKey("FT", PdfName("Sig"));
        fieldObj->GetDictionary().AddKey("T", PdfString(fieldName));
        
        // Aggiungi il campo all'AcroForm
        PdfArray fieldsArray;
        if (acroForm->GetObject()->GetDictionary().HasKey("Fields")) {
            fieldsArray = acroForm->GetObject()->GetDictionary().GetKey("Fields")->GetArray();
        }
        fieldsArray.push_back(fieldObj->Reference());
        acroForm->GetObject()->GetDictionary().AddKey("Fields", fieldsArray);

        // Configura l'aspetto del campo
        PdfAnnotation* annotation = signatureField->GetWidgetAnnotation();
        if (annotation) {
            // Bordo del campo
            PdfArray borderArray;
            borderArray.push_back(PdfVariant(static_cast<pdf_int64>(0)));
            borderArray.push_back(PdfVariant(static_cast<pdf_int64>(0)));
            borderArray.push_back(PdfVariant(static_cast<pdf_int64>(1)));
            annotation->GetObject()->GetDictionary().AddKey("Border", borderArray);
            
            // Imposta il tipo di annotazione
            annotation->GetObject()->GetDictionary().AddKey("Subtype", PdfName("Widget"));
            
            // Aggiungi testo di placeholder
            annotation->GetObject()->GetDictionary().AddKey("DA", PdfString("/Helv 12 Tf 0 g"));
            annotation->GetObject()->GetDictionary().AddKey("AP", PdfString("Clicca per firmare"));
        }

        // Salva il documento modificato
        PdfOutputDevice outputDevice(outputFile.c_str());
        document.Write(&outputDevice);
        
        std::cout << "\n=== COMPLETATO ===" << std::endl;
        std::cout << "Campo di firma '" << fieldName << "' aggiunto con successo!" << std::endl;
        std::cout << "File salvato come: " << outputFile << std::endl;
        std::cout << "Il campo si trova nella pagina " << targetPageNum + 1 
                  << " in basso a destra." << std::endl;

    } catch (const PdfError& error) {
        std::cerr << "Errore libpodofo: " << error.GetError() << " - " << error.what() << std::endl;
        return 1;
    } catch (const std::exception& ex) {
        std::cerr << "Errore: " << ex.what() << std::endl;
        return 1;
    }

    return 0;
}

// Makefile per PoDoFo 0.9.8:
/*
CXX = g++
CXXFLAGS = -std=c++11 -Wall -O2
LIBS = -lpodofo

pdf_signature: testpdf.cpp
	$(CXX) $(CXXFLAGS) -o pdf_signature testpdf.cpp $(LIBS)

clean:
	rm -f pdf_signature

.PHONY: clean
*/