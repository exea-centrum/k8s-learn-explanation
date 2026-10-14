#
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

# Comprehensive 34-tool dataset combining LLM tools, gateways, and AI coding extensions with requested columns
tools_data = [
    (1, "GitHub Copilot", "Subskrypcja", "~25M+", "2000 uzupełnień + 50 czatów/mies.", "Zależny od modelu", "Nie", "https://github.com/features/copilot", "TypeScript / C#", "Komercyjna", "Najpopularniejsze autouzupełnianie kodu i chat AI", "Oficjalna wtyczka GitHub Copilot w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (2, "Codeium / Windsurf", "Subskrypcja", "~2.8M+", "Uzupełnianie bez limitu; agent 25 kredytów", "Nieujawnione", "Nie", "https://codeium.com", "C++ / TypeScript", "Freemium", "Nielimitowane autouzupełnianie i agent Cascade", "Oficjalna wtyczka Codeium / Windsurf w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (3, "Tabnine", "Subskrypcja", "~6.5M+", "Bardzo ograniczony plan podstawowy", "Nieujawnione", "Nie", "https://www.tabnine.com", "Java / Rust", "Komercyjna", "Prywatne autouzupełnianie dla przedsiębiorstw i enterprise", "Oficjalna wtyczka Tabnine w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (4, "AWS Q Developer", "Subskrypcja", "~2.1M+", "50 zapytań agenta/mies. + uzupełnienia", "Zależny od modelu", "Nie", "https://aws.amazon.com/q/developer/", "Java / TypeScript", "Freemium", "Integracja z ekosystemem AWS i autouzupełnianie kodu", "Oficjalna wtyczka AWS Toolkit / Amazon Q w VS Code", "Wtyczka VS Code (Marketplace)"),
    (5, "Gemini Code Assist", "Subskrypcja", "~1.2M+", "180 000 uzupełnień/mies.", "Modele Gemini (1M+)", "Nie", "https://cloud.google.com/products/gemini/code-assist", "TypeScript / Go", "Freemium", "Ogromny darmowy limit uzupełnień i głęboka integracja z GCP", "Oficjalna wtyczka Google Cloud Code / Gemini w VS Code", "Wtyczka VS Code (Marketplace)"),
    (6, "Cline", "BYOK / agent", "~1.1M+", "Narzędzie darmowe, płacisz za API", "Zależny od modelu", "Tak (BYOK)", "https://github.com/cline/cline", "TypeScript", "Apache 2.0", "Autonomiczny agent wykonujący komendy w terminalu i edytujący pliki", "Instalacja rozszerzenia Cline z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (7, "Continue", "BYOK / open-source", "~950K+", "Narzędzie darmowe (Add-on: 50 czatów)", "Zależny od modelu / lokalny", "Tak (lub Add-on)", "https://github.com/continuedev/continue", "TypeScript / Python", "Apache 2.0", "Otwarty klient AI pozwalający podłączyć Ollama, LocalAI, OpenRouter", "Instalacja rozszerzenia Continue z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (8, "CodeGPT", "Agent / BYOK", "~1.4M+", "10 interakcji/dzień (Economy) + $1 kredyt", "Zależny od modelu", "Nie (lub BYOK)", "https://codegpt.co", "TypeScript", "Freemium", "Gotowe środowisko agenckie z wyborem dostawców i modeli", "Oficjalna wtyczka CodeGPT w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (9, "Bito AI", "Recenzja / Chat", "~1.0M+", "20 czatów AI dziennie", "Nieujawnione", "Nie", "https://bito.ai", "TypeScript / Go", "Freemium", "Szybki chat AI, recenzja kodu (code review) i generowanie testów", "Oficjalna wtyczka Bito AI w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (10, "CodeGeeX", "Uzupełnianie", "~850K+", "Uzupełnianie bez limitu, podstawowe funkcje", "32K tokenów", "Nie", "https://github.com/THUDM/CodeGeeX", "Python / C++", "Apache 2.0", "Darmowe autouzupełnianie wierszowe i wielojęzyczne objaśnienia kodu", "Oficjalna wtyczka CodeGeeX w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (11, "Supermaven Free", "Uzupełnianie", "~600K+", "Nielimitowane szybkie uzupełnianie", "Domyślny kontekst", "Nie", "https://supermaven.com", "Rust / TypeScript", "Freemium", "Najszybszy silnik autouzupełniania kodu na rynku", "Oficjalna wtyczka Supermaven w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (12, "Kilo Code", "BYOK / agent", "~350K+", "Narzędzie darmowe, płacisz za API", "Zależny od modelu", "Tak (BYOK)", "https://github.com/kilo-ai/kilo", "TypeScript", "MIT", "Wielotrybowy agent wspierający ponad 500 modeli API", "Wtyczka Kilo Code z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (13, "Tongyi Lingma", "Subskrypcja", "~300K+", "Uzupełnianie wierszowe bez limitu + 100 pkt", "Kontekst jednoplikowy", "Nie", "https://lingma.aliyun.com", "Java / TypeScript", "Freemium", "Ekosystem Alibaba / Qwen z bezpłatnym uzupełnianiem wierszowym", "Wtyczka Tongyi Lingma w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (14, "Sixth", "Agent", "~120K+", "50 zapytań + 2000 uzupełnień/mies.", "GPT-5.4-mini (1M kontekstu)", "Nie", "https://github.com/sixth-ai/sixth", "TypeScript", "MIT", "Darmowy agent w VS Code z dostępem do modeli Claude i Gemini", "Wtyczka Sixth z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (15, "Augment Code", "Subskrypcja", "~150K+", "30 000 darmowych tokenów na start", "Duży kontekst repozytorium", "Nie", "https://www.augmentcode.com", "TypeScript / Python", "Komercyjna", "Błyskawiczne indeksowanie i rozumienie wielkich repozytoriów", "Wtyczka Augment Code z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (16, "Twinny", "Open-source", "~180K+", "100% darmowy klient + modele", "Model lokalny", "Nie", "https://github.com/twinnydotdev/twinny", "TypeScript", "MIT", "Prywatne, w 100% lokalne autouzupełnianie i czat bez wysyłania danych", "Instalacja rozszerzenia Twinny z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (17, "CodePilot", "Multi-agent", "~80K+", "Darmowe modele przez OpenRouter", "Przez OpenRouter", "Nie (lub BYOK)", "https://github.com/codepilot-ai/codepilot", "TypeScript", "MIT", "Orkiestracja wielu agentów z dostępem do darmowych modeli", "Wtyczka CodePilot z VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (18, "Cognify AI", "BYOK / agent", "~45K+", "Darmowe modele w zestawie", "Zależny od modelu", "Tak", "https://github.com/cognify-ai/cognify", "TypeScript / Python", "MIT", "Multi-agent z wbudowaną wyszukiwarką kontekstową", "Wtyczka Cognify AI w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (19, "KISS Sorcar", "BYOK", "~30K+", "Bez limitów (klient open-source)", "Zależny od modelu", "Tak", "https://github.com/sorcar-ai/sorcar", "TypeScript", "MIT", "Lekki i prosty klient agenta bez zewnętrznych serwerów pośredniczących", "Wtyczka KISS Sorcar w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (20, "Andromity", "BYOK", "~25K+", "Bez limitów (klient open-source)", "Zależny od modelu", "Tak", "https://github.com/andromity/andromity", "TypeScript", "MIT", "Rozszerzenie do komunikacji z ponad 300 modelami zewnętrznymi", "Wtyczka Andromity w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (21, "Free Repo Agent", "BYOK", "~20K+", "Darmowy interfejs bez subskrypcji", "DeepSeek V4 / Qwen", "Tak", "https://github.com/free-repo-agent/fra", "TypeScript", "MIT", "Darmowy interfejs do analizy i objaśniania struktur całości repozytorium", "Wtyczka Free Repo Agent w VS Code Marketplace", "Wtyczka VS Code (Marketplace)"),
    (22, "Tabby", "Self-hosted", "~110K+", "Darmowy (do 5 użytkowników)", "Model lokalny", "Nie", "https://github.com/tabbyml/tabby", "Rust / TypeScript", "Apache 2.0", "Samodzielny serwer i wtyczka dedykowana do autouzupełniania kodu", "Oficjalna wtyczka Tabby w VS Code Marketplace + własny serwer", "docker run -p 8080:8080 tabbyml/tabby"),
    (23, "LiteLLM", "Proxy / Gateway", "Brak (Serwer)", "Darmowe proxy (open-source)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/BerriAI/litellm", "Python / Rust", "MIT", "Najpopularniejsze proxy LLM, routowanie, limity i śledzenie kosztów", "Podpięcie adresu proxy jako Base URL w Continue / Cline / Tabby", "pip install litellm"),
    (24, "OmniRoute", "Proxy / Gateway", "Brak (Serwer)", "Darmowy agregator (open-source)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/cheaper-inference/omniroute", "Go / TypeScript", "Apache 2.0", "Agregator 350+ dostawców, automatyczny fallback i kompresja tokenów", "Podpięcie adresu instancji w konfiguracji wtyczki Continue", "docker run cheaper-inference/omniroute"),
    (25, "Portkey Gateway", "Proxy / Gateway", "Brak (Serwer)", "Darmowa bramka (open-source)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/Portkey-AI/gateway", "TypeScript", "Apache 2.0", "Szybki routing, obsługa fallbacków i ponad 45 providerów AI", "Konfiguracja bazowego adresu URL (Base URL) we wtyczkach VS Code", "npm install -g portkey-ai"),
    (26, "Bifrost", "Proxy / Gateway", "Brak (Serwer)", "Darmowe proxy (open-source)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/maximhq/bifrost", "Go", "Apache 2.0", "Ekstremalnie niska latencja (sub-milisekundowa) i buforowanie semantyczne", "Endpoint kompatybilny z OpenAI wpisany we wtyczce VS Code", "docker run maximhq/bifrost"),
    (27, "One-API", "Proxy / Gateway", "Brak (Serwer)", "Darmowy panel (open-source)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/songquanpeng/one-api", "Go / React", "MIT", "Zarządzanie kluczami i dostawcami z poziomu estetycznego Web UI", "Dodanie wygenerowanego tokenu w ustawieniach rozszerzenia VS Code", "docker run -d -p 3000:3000"),
    (28, "Ollama", "Local Runtime", "Brak (Desktop)", "100% darmowy (lokalny)", "Zależny od VRAM/RAM", "Nie", "https://github.com/ollama/ollama", "Go / C++", "MIT", "Narzędzie do lokalnego uruchamiania modeli (Llama, DeepSeek, Qwen)", "Natywnie wykrywana przez wtyczki Continue, Twinny, Llama Coder", "curl -fsSL https://ollama.com"),
    (29, "LocalAI", "Local Runtime", "Brak (Docker)", "100% darmowy (lokalny)", "Zależny od VRAM/RAM", "Nie", "https://github.com/mudler/LocalAI", "Go / C++", "MIT", "Pełny zamiennik OpenAI API dla lokalnego CPU/GPU", "Podłączenie jako niestandardowe OpenAI API w ustawieniach wtyczek", "docker run localai/localai"),
    (30, "Qwen Coder (OpenRouter)", "Darmowy model", "Brak (Model)", "50 zapytań/dzień (20 RPM)", "480B, 1M kontekstu", "Tak (klucz OpenRouter)", "https://openrouter.ai", "Model API", "Open-Weights", "Potężny, bezpłatny model open-weights do podłączenia pod agenta", "Wpisanie API Key z OpenRouter w Cline, Continue lub Kilo Code", "Brak (Dostęp przez API)"),
    (31, "Cursor", "Dedykowane IDE", "Brak (Aplikacja)", "50 zapytań Premium / mies.", "Modele premium / Auto", "Nie", "https://cursor.com", "TypeScript / C++", "Komercyjna", "Najpopularniejszy dedykowany edytor AI-first (fork VS Code)", "Osobna aplikacja desktopowa (wbudowana integracja AI)", "Pobranie ze strony cursor.com"),
    (32, "Void", "Dedykowane IDE", "Brak (Aplikacja)", "100% darmowy / open-source", "Zależny od modelu", "Tak (BYOK)", "https://github.com/voideditor/void", "TypeScript", "Apache 2.0", "Open-source'owa, prywatna alternatywa dla edytora Cursor", "Osobna aplikacja desktopowa (wbudowana obsługa BYOK)", "Pobranie ze strony voideditor.com"),
    (33, "Aider", "CLI / BYOK", "Brak (CLI)", "Darmowy CLI", "Zależny od modelu", "Tak (BYOK)", "https://github.com/paul-gauthier/aider", "Python", "Apache 2.0", "Pair programming z terminala z głęboką integracją z Git", "Uruchamianie z wbudowanego terminala w VS Code", "pip install aider-chat"),
    (34, "OpenHands", "BYOK / R&D", "Brak (Docker)", "Darmowy (MIT)", "Zależny od modelu", "Tak (BYOK)", "https://github.com/All-Hands-AI/OpenHands", "Python / TypeScript", "MIT", "Autonomiczne środowisko agenckie do wykonywania złożonych zadań", "Interfejs Web UI lub wywołania z terminala VS Code", "docker run -it openhands")
]

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "Narzędzia AI dla VS Code"

ws.views.sheetView[0].showGridLines = True

headers = [
    "Lp.",
    "Nazwa Narzędzia",
    "Typ",
    "Pobrania w VS Code",
    "Darmowy limit",
    "Limit tokenów / kontekstu",
    "Wymaga własnego klucza?",
    "Link",
    "Język / Technologia",
    "Licencja",
    "Główne zadanie / wyróżnik",
    "Metoda podłączenia do VS Code",
    "Podstawowa komenda instalacji"
]

header_fill = PatternFill(start_color="1E293B", end_color="1E293B", fill_type="solid") # Dark slate
header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")

row_even_fill = PatternFill(start_color="F8FAFC", end_color="F8FAFC", fill_type="solid")
row_odd_fill = PatternFill(start_color="FFFFFF", end_color="FFFFFF", fill_type="solid")

thin_border = Border(
    left=Side(style='thin', color='E2E8F0'),
    right=Side(style='thin', color='E2E8F0'),
    top=Side(style='thin', color='E2E8F0'),
    bottom=Side(style='thin', color='E2E8F0')
)

font_regular = Font(name="Calibri", size=10, color="0F172A")
font_bold = Font(name="Calibri", size=10, bold=True, color="0F172A")
font_code = Font(name="Consolas", size=9, color="0F172A")
font_link = Font(name="Calibri", size=10, color="2563EB", underline="single")

ws.append(headers)

for col_num in range(1, len(headers) + 1):
    cell = ws.cell(row=1, column=col_num)
    cell.fill = header_fill
    cell.font = header_font
    cell.alignment = Alignment(horizontal="center" if col_num in [1, 3, 4, 7, 9, 10] else "left", vertical="center", wrap_text=True)

ws.row_dimensions[1].height = 32

for row_idx, item in enumerate(tools_data, start=2):
    (lp, name, tool_type, downloads, free_limit, token_limit, req_key, link, lang, license_type, desc, vs_connect, install_cmd) = item
    
    ws.cell(row=row_idx, column=1, value=lp)
    ws.cell(row=row_idx, column=2, value=name)
    ws.cell(row=row_idx, column=3, value=tool_type)
    ws.cell(row=row_idx, column=4, value=downloads)
    ws.cell(row=row_idx, column=5, value=free_limit)
    ws.cell(row=row_idx, column=6, value=token_limit)
    ws.cell(row=row_idx, column=7, value=req_key)
    
    link_cell = ws.cell(row=row_idx, column=8, value="Link")
    link_cell.hyperlink = link
    link_cell.font = font_link
    
    ws.cell(row=row_idx, column=9, value=lang)
    ws.cell(row=row_idx, column=10, value=license_type)
    ws.cell(row=row_idx, column=11, value=desc)
    ws.cell(row=row_idx, column=12, value=vs_connect)
    ws.cell(row=row_idx, column=13, value=install_cmd)

    fill = row_even_fill if row_idx % 2 == 0 else row_odd_fill
    
    for col_idx in range(1, len(headers) + 1):
        cell = ws.cell(row=row_idx, column=col_idx)
        cell.fill = fill
        cell.border = thin_border
        
        if col_idx == 1:
            cell.font = font_bold
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 2:
            cell.font = font_bold
            cell.alignment = Alignment(horizontal="left", vertical="center")
        elif col_idx in [3, 4, 7, 9, 10]:
            cell.font = font_regular
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 8:
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 13:
            cell.font = font_code
            cell.alignment = Alignment(horizontal="left", vertical="center")
        else:
            cell.font = font_regular
            cell.alignment = Alignment(horizontal="left", vertical="center", wrap_text=True)

    ws.row_dimensions[row_idx].height = 42

col_widths = {
    1: 6,   # Lp.
    2: 24,  # Nazwa Narzędzia
    3: 18,  # Typ
    4: 20,  # Pobrania w VS Code
    5: 32,  # Darmowy limit
    6: 28,  # Limit tokenów / kontekstu
    7: 22,  # Wymaga własnego klucza?
    8: 10,  # Link
    9: 18,  # Język / Technologia
    10: 16, # Licencja
    11: 42, # Główne zadanie / wyróżnik
    12: 40, # Metoda podłączenia do VS Code
    13: 38  # Podstawowa komenda instalacji
}

for col_idx, width in col_widths.items():
    col_letter = get_column_letter(col_idx)
    ws.column_dimensions[col_letter].width = width

ws.freeze_panes = "A2"

file_path = "Pelna_Analiza_Narzedzi_AI_VS_Code.xlsx"
wb.save(file_path)
print(f"File successfully created: {file_path}")