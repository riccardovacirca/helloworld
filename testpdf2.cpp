#include <podofo/podofo.h>
#include <iostream>
#include <string>
#include <algorithm>

using namespace PoDoFo;

// Normalizza il testo per ricerche robuste
std::string normalize(const std::string& text) {
    std::string result = text;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    
    // Rimuovi spazi multipli e trim
    auto new_end = std::unique(result.begin(), result.end(),
        [](char a, char b) { return a == ' ' && b == ' '; });
    result.erase(new_end, result.end());
    
    size_t start = result.find_first_not_of(" \t\n\r");
    if (start == std::string::npos) return "";
    size_t end = result.find_last_not_of(" \t\n\r");
    return result.substr(start, end - start + 1);
}

// Cerca testo in una pagina e ritorna true se trovato
bool findTextInPage(PdfPage* page, const std::string& searchText) {
    try {
        PdfContentsTokenizer tokenizer(page);
        std::string pageText = "";
        
        const char* keyword = nullptr;
        PdfVariant variant;
        EPdfContentsType type;
        
        // Estrai tutto il testo dalla pagina
        while (tokenizer.ReadNext(type, keyword, variant)) {
            if (type == ePdfContentsType_Variant) {
                if (variant.IsString()) {
                    pageText += variant.GetString().GetString();
                    pageText += " ";
                } else if (variant.IsArray()) {
                    // Gestisci array di testo (operatore TJ)
                    PdfArray arr = variant.GetArray();
                    for (size_t i = 0; i < arr.size(); i++) {
                        if (arr[i].IsString()) {
                            pageText += arr[i].GetString().GetString();
                        }
                    }
                    pageText += " ";
                }
            }
        }
        
        // Ricerca case-insensitive
        return normalize(pageText).find(normalize(searchText)) != std::string::npos;
        
    } catch (const PdfError&) {
        return false;
    }
}

// Aggiunge campo firma alla pagina
void addSignatureField(PdfPage* page, PdfMemDocument* doc, const std::string& fieldName) {
    // Posizione in basso a destra
    PdfRect pageSize = page->GetPageSize();
    PdfRect fieldRect(pageSize.GetWidth() - 200, 50, 150, 40);
    
    // Crea campo firma
    PdfPushButton* field = new PdfPushButton(page, fieldRect, doc);
    PdfObject* fieldObj = field->GetFieldObject();
    
    // Configura come campo firma
    fieldObj->GetDictionary().AddKey("FT", PdfName("Sig"));
    fieldObj->GetDictionary().AddKey("T", PdfString(fieldName));
    
    // Aggiungi all'AcroForm
    PdfAcroForm* acroForm = doc->GetAcroForm(true);
    PdfArray fields;
    if (acroForm->GetObject()->GetDictionary().HasKey("Fields")) {
        fields = acroForm->GetObject()->GetDictionary().GetKey("Fields")->GetArray();
    }
    fields.push_back(fieldObj->Reference());
    acroForm->GetObject()->GetDictionary().AddKey("Fields", fields);
    
    // Aspetto visivo
    PdfAnnotation* annotation = field->GetWidgetAnnotation();
    if (annotation) {
        PdfArray border;
        border.push_back(PdfVariant(static_cast<pdf_int64>(0)));
        border.push_back(PdfVariant(static_cast<pdf_int64>(0)));
        border.push_back(PdfVariant(static_cast<pdf_int64>(1)));
        annotation->GetObject()->GetDictionary().AddKey("Border", border);
    }
}

int main(int argc, char* argv[]) {
    // Controllo parametri
    if (argc != 4) {
        std::cout << "Uso: " << argv[0] << " <pdf_file> <search_text> <field_name>\n";
        return 1;
    }
    
    std::string inputFile = argv[1];
    std::string searchText = argv[2];
    std::string fieldName = argv[3];
    std::string outputFile = inputFile.substr(0, inputFile.find_last_of('.')) + "_signed.pdf";
    
    try {
        // Carica PDF
        PdfMemDocument doc;
        doc.Load(inputFile.c_str());
        
        std::cout << "Cercando '" << searchText << "' in " << doc.GetPageCount() << " pagine...\n";
        
        // Cerca testo e aggiungi campo alla prima pagina che lo contiene
        bool found = false;
        for (int i = 0; i < doc.GetPageCount() && !found; i++) {
            PdfPage* page = doc.GetPage(i);
            if (findTextInPage(page, searchText)) {
                std::cout << "Testo trovato a pagina " << i + 1 << ". Aggiungendo campo firma...\n";
                addSignatureField(page, &doc, fieldName);
                found = true;
            }
        }
        
        if (!found) {
            std::cout << "Testo '" << searchText << "' non trovato nel documento.\n";
            return 1;
        }
        
        // Salva PDF modificato
        PdfOutputDevice output(outputFile.c_str());
        doc.Write(&output);
        
        std::cout << "Campo firma '" << fieldName << "' aggiunto con successo!\n";
        std::cout << "File salvato come: " << outputFile << "\n";
        
    } catch (const PdfError& e) {
        std::cerr << "Errore PDF: " << e.what() << "\n";
        return 1;
    } catch (const std::exception& e) {
        std::cerr << "Errore: " << e.what() << "\n";
        return 1;
    }
    
    return 0;
}