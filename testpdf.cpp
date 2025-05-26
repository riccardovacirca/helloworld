#include <podofo/podofo.h>
#include <iostream>
#include <string>
#include <sstream>
#include <cctype>

/**
 * Normalizza una stringa applicando le seguenti trasformazioni:
 * 1. Converti tutto in minuscolo
 * 2. Sostituisci sequenze di whitespace con un singolo spazio
 * 3. Trim degli spazi all'inizio e alla fine
 * 
 * @param text La stringa da normalizzare (passata per riferimento const)
 * @return La stringa normalizzata, o stringa vuota se composta solo da spazi
 */
std::string normalize(const std::string& text) {
  std::string result;  // Buffer per il risultato
  bool space = false;  // Flag per tracciare spazi consecutivi
  // Itera su ogni carattere della stringa input
  for (std::size_t i = 0; i < text.size(); ++i) {
    // Converti il carattere in minuscolo (sicuro per UTF-8 con cast)
    char c = static_cast<char>(std::tolower(text[i]));
    // Gestione whitespace:
    if (std::isspace(static_cast<unsigned char>(c))) {
      // Aggiungi solo uno spazio se non è preceduto da un altro spazio
      if (!space) {
        result += ' ';
        space = true;  // Segnala che abbiamo aggiunto uno spazio
      }
    } else {
      // Aggiungi il carattere non-whitespace e resetta il flag
      result += c;
      space = false;
    }
  }
  // Trim degli spazi iniziali/finali:
  std::size_t start = result.find_first_not_of(' ');  // Primo non-spazio
  std::size_t end = result.find_last_not_of(' ');     // Ultimo non-spazio
  // Se la stringa è tutta spazi, ritorna stringa vuota
  if (start == std::string::npos) return "";
  // Estrai la sottostringa senza spazi estremi
  return result.substr(start, end - start + 1);
}

/**
 * Cerca un testo specifico all'interno dei contenuti testuali di una pagina PDF.
 * 
 * @param page Puntatore alla pagina PDF da analizzare
 * @param searchText Testo da cercare (case-insensitive e con normalizzazione spazi)
 * @return true se il testo viene trovato, false altrimenti o in caso di errore
 */
bool findTextInPage(PoDoFo::PdfPage* page, const std::string& searchText) {
  try {
    // 1. Inizializzazione tokenizer per analizzare i contenuti della pagina
    PoDoFo::PdfContentsTokenizer tokenizer(page);
    std::ostringstream oss;  // Buffer per accumulare il testo estratto
    // Variabili per l'iterazione sui token
    const char* keyword = 0;  // Puntatore a keyword PDF (non usato in questo caso)
    PoDoFo::PdfVariant variant;  // Variante PDF (contiene i dati effettivi)
    PoDoFo::EPdfContentsType type;  // Tipo di token corrente
    // 2. Estrazione iterativa dei contenuti
    while (tokenizer.ReadNext(type, keyword, variant)) {
      if (type == PoDoFo::ePdfContentsType_Variant) {
        // Gestione stringhe dirette
        if (variant.IsString()) {
          oss << variant.GetString().GetString() << " ";
        } 
        // Gestione array (può contenere stringhe o altri elementi)
        else if (variant.IsArray()) {
          PoDoFo::PdfArray arr = variant.GetArray();
          for (std::size_t i = 0; i < arr.size(); ++i) {
            if (arr[i].IsString()) {
              oss << arr[i].GetString().GetString();
            }
          }
          oss << " ";  // Aggiunge spazio dopo l'array
        }
      }
      // Nota: I token di tipo keyword (ePdfContentsType_Keyword) vengono ignorati
    }
    // 3. Normalizzazione e ricerca del testo
    // - Normalizza sia il testo estratto che la search string
    // - Confronto case-insensitive e con spazi uniformati
    return normalize(oss.str()).find(normalize(searchText)) != std::string::npos;
  } catch (const PoDoFo::PdfError&) {
    // Gestione silenziosa degli errori (pagine senza contenuti o corrotte)
    return false;
  }
}

void addSignatureField(PoDoFo::PdfPage* page, PoDoFo::PdfMemDocument* doc, const std::string& fieldName) {
  PoDoFo::PdfRect pageSize = page->GetPageSize();
  PoDoFo::PdfRect fieldRect(pageSize.GetWidth() - 200, 50, 150, 40);
  PoDoFo::PdfPushButton* field = new PoDoFo::PdfPushButton(page, fieldRect, doc);
  PoDoFo::PdfObject* fieldObj = field->GetFieldObject();
  fieldObj->GetDictionary().AddKey("FT", PoDoFo::PdfName("Sig"));
  fieldObj->GetDictionary().AddKey("T", PoDoFo::PdfString(fieldName));
  PoDoFo::PdfAcroForm* acroForm = doc->GetAcroForm(true);
  PoDoFo::PdfArray fields;
  if (acroForm->GetObject()->GetDictionary().HasKey("Fields")) {
    fields = acroForm->GetObject()->GetDictionary().GetKey("Fields")->GetArray();
  }
  fields.push_back(fieldObj->Reference());
  acroForm->GetObject()->GetDictionary().AddKey("Fields", fields);
  PoDoFo::PdfAnnotation* annotation = field->GetWidgetAnnotation();
  if (annotation) {
    PoDoFo::PdfArray border;
    border.push_back(PoDoFo::PdfVariant(0L));
    border.push_back(PoDoFo::PdfVariant(0L));
    border.push_back(PoDoFo::PdfVariant(1L));
    annotation->GetObject()->GetDictionary().AddKey("Border", border);
  }
}

int main(int argc, char* argv[]) {
  if (argc != 4) {
    std::cout << "Uso: " << argv[0] << " <pdf_file> <search_text> <field_name>\n";
    return 1;
  }
  std::string inputFile = argv[1];
  std::string searchText = argv[2];
  std::string fieldName = argv[3];
  std::string::size_type dot = inputFile.find_last_of('.');
  std::string outputFile = (dot == std::string::npos)
    ? inputFile + "_signed.pdf"
    : inputFile.substr(0, dot) + "_signed.pdf";
  try {
    PoDoFo::PdfMemDocument doc;
    doc.Load(inputFile.c_str());
    std::cout << "Cercando '" << searchText << "' in " << doc.GetPageCount() << " pagine...\n";
    bool found = false;
    for (int i = 0; i < doc.GetPageCount() && !found; ++i) {
      PoDoFo::PdfPage* page = doc.GetPage(i);
      if (findTextInPage(page, searchText)) {
        std::cout << "Testo trovato a pagina " << (i + 1) << ". Aggiungendo campo firma...\n";
        addSignatureField(page, &doc, fieldName);
        found = true;
      }
    }
    if (!found) {
      std::cout << "Testo '" << searchText << "' non trovato nel documento.\n";
      return 1;
    }
    PoDoFo::PdfOutputDevice output(outputFile.c_str());
    doc.Write(&output);
    std::cout << "Campo firma '" << fieldName << "' aggiunto con successo!\n";
    std::cout << "File salvato come: " << outputFile << "\n";
  } catch (const PoDoFo::PdfError& e) {
    std::cerr << "Errore PDF: " << e.what() << "\n";
    return 1;
  } catch (const std::exception& e) {
    std::cerr << "Errore: " << e.what() << "\n";
    return 1;
  }
  return 0;
}
