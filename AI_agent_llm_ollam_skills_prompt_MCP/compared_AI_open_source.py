import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

# Raw input text from the prompt
raw_data = [
    (1, "OmniRoute", "https://github.com/cheaper-inference/omniroute", "Go / TypeScript", "Apache 2.0", "Agregator ponad 350 dostawców LLM, automatyczny fallback, inteligentna kompresja tokenów.", "Podpięcie adresu instancji i klucza do wtyczki Continue jako niestandardowe OpenAI proxy.", "docker run cheaper-inference/omniroute"),
    (2, "LiteLLM", "https://github.com/BerriAI/litellm", "Python / Rust", "MIT", "Najpopularniejsze proxy LLM, obsługuje śledzenie kosztów i limity (rate limiting) użytkowników.", "Natywne wsparcie w edytorze przez Continue, Cline czy Tabby.", "pip install litellm"),
    (3, "Portkey Gateway", "https://github.com/Portkey-AI/gateway", "TypeScript", "Apache 2.0", "Superszybkie routowanie, obsługa fallbacków i ponad 45 providerów.", "Konfiguracja bazowego adresu URL (Base URL) we wtyczkach VS Code.", "npm install -g portkey-ai"),
    (4, "Bifrost", "https://github.com/maximhq/bifrost", "Go", "Apache 2.0", "Ekstremalnie niska latencja (sub-milisekundowa), buforowanie semantyczne.", "Endpoint kompatybilny z OpenAI w pliku konfiguracji wtyczek VS Code.", "docker run maximhq/bifrost"),
    (5, "RouteLLM", "https://github.com/lm-sys/RouteLLM", "Python", "Apache 2.0", "Inteligentne przekierowywanie promptów (np. proste zapytania idą do tańszego modelu).", "Uruchomienie lokalnego serwera przekazującego ruch z rozszerzeń programistycznych.", "pip install routellm"),
    (6, "One-API", "https://github.com/songquanpeng/one-api", "Go / React", "MIT", "Uniwersalne zarządzanie kluczami i wieloma dostawcami z poziomu estetycznego Web UI.", "Dodanie wygenerowanego tokenu w ustawieniach rozszerzenia VS Code.", "docker run -d -p 3000:3000"),
    (7, "New-API", "https://github.com/Calcium-Ion/new-api", "Go", "MIT", "Zoptymalizowany fork One-API z lepszą wydajnością i zaawansowanym systemem pod-kluczy.", "Podpięcie pod wtyczki kodu (np. Tabby, Continue) jako niestandardowy endpoint.", "docker run -d --name new-api"),
    (8, "Envoy AI Gateway", "https://github.com/envoyproxy/ai-gateway", "C++ / Go", "Apache 2.0", "Chmuro-natywna bramka stworzona dla Kubernetes, idealna do wdrożeń enterprise.", "Wystawienie lokalnego portu ingress dla środowiska programistycznego VS Code.", "helm install envoy-ai-gateway"),
    (9, "Apache APISIX AI", "https://github.com/apache/apisix", "Lua / Nginx", "Apache 2.0", "Tradycyjny, potężny API Gateway wzbogacony o dedykowane pluginy proxy dla LLM.", "Kierowanie ruchu z rozszerzeń VS Code przez zdefiniowaną trasę APISIX upstream.", "apisix start"),
    (10, "Kong AI Gateway", "https://github.com/Kong/kong", "Lua", "Apache 2.0", "Stabilna platforma API z oficjalną wtyczką ai-proxy do integracji z LLM.", "Podmiana parametru openai.api_base we wtyczkach VS Code na lokalny adres Konga.", "kong start"),
    (11, "Ollama", "https://github.com/ollama/ollama", "Go / C++", "MIT", "Narzędzie do lokalnego uruchamiania modeli, pełniące funkcję bramki dla lokalnego kodu.", "Natywnie wspierana przez niemal każdą wtyczkę AI w VS Code (np. Continue, Llama Coder).", "curl -fsSL https://ollama.com"),
    (12, "LocalAI", "https://github.com/mudler/LocalAI", "Go / C++", "MIT", "Pełny zamiennik OpenAI dla lokalnego CPU/GPU (tekst, audio, obrazy).", "Podłączenie identyczne jak oficjalne OpenAI (zmiana adresu IP/portu w konfiguracji).", "docker run localai/localai"),
    (13, "Langfuse", "https://github.com/langfuse/langfuse", "TypeScript", "MIT", "Narzędzie do obserwowalności (observability) działające jako proxy logujące ruch.", "Wpięcie SDK Langfuse do skryptów lub wtyczek wywoływanych z VS Code.", "docker-compose up -d langfuse"),
    (14, "LLMRouter (UIUC)", "https://github.com/yzzhang/LLMRouter", "Python", "Apache 2.0", "Akademicki projekt optymalizacji kosztów na podstawie złożoności zapytania.", "Uruchomienie serwera proxy zgodnego z OpenAI i wpięcie do edytora.", "pip install llm-router-cli"),
    (15, "BricksLLM", "https://github.com/bricks-cloud/bricksllm", "Go", "MIT", "Skupiony na nakładaniu zaawansowanych limitów (rate-limiting) na użytkowników w firmie.", "Użycie wygenerowanego \"klucza wirtualnego\" wewnątrz profilu wtyczki edytora.", "docker run bricks-cloud/bricksllm"),
    (16, "llm-gateway (OpenZiti)", "https://github.com/openziti/llm-gateway", "Go", "Apache 2.0", "Bezpieczna bramka oparta na architekturze Zero-Trust Network Access.", "Wymaga klienta Ziti na maszynie dewelopera z VS Code dla bezpiecznego tunelowania.", "go install ./cmd/llm-gateway"),
    (17, "Aibrix (vLLM)", "https://github.com/vllm-project/aibrix", "Go / Python", "Apache 2.0", "System routingu i load-balancingu dla klastrów vLLM w chmurze.", "Ustawienie adresu klastra aibrix jako głównego endpointu LLM w projekcie VS Code.", "kubectl apply -f aibrix/"),
    (18, "ClawRouter", "https://github.com/clawrouter/clawrouter", "Go", "MIT", "Lekki, minimalistyczny router stworzony do natychmiastowej obsługi awarii (failover).", "Prosta rekonfiguracja parametrów połączenia w plikach .env wtyczek AI.", "go build -o clawrouter"),
    (19, "Glm-router", "https://github.com/glm-router/glm-router", "TypeScript", "MIT", "Specjalistyczny router dedykowany do optymalizacji agentów autonomicznie piszących kod.", "Bezpośrednia współpraca z CLI wywoływanym z terminala VS Code.", "npm install glm-router"),
    (20, "GoModel", "https://github.com/enterpilot/gomodel", "Go", "Apache 2.0", "Prosta bramka unifikująca formaty wejściowe z Anthropic/Mistral do standardu OpenAI.", "Wskazanie adresu serwera w dowolnej wtyczce wspierającej \"Custom OpenAI\".", "docker run enterpilot/gomodel"),
    (21, "Chroma AI Gateway", "https://github.com/chroma-core/chroma", "Python", "Apache 2.0", "Dodatek do bazy wektorowej unifikujący pobieranie danych (RAG) z modelami.", "Wykorzystanie przez rozszerzenia RAG dla VS Code do kontekstowego przeszukiwania kodu.", "pip install chromadb"),
    (22, "OpenRouter Runner", "https://github.com/OpenRouterTeam/openrouter-runner", "TypeScript", "MIT", "Otwartoźródłowy silnik napędzający popularną platformę OpenRouter, możliwy do wdrożenia solo.", "Podpięcie adresu swojej instancji do VS Code zamiast oficjalnego OpenRouter.", "npm install && npm run dev"),
    (23, "LLM-Proxy (Traceloop)", "https://github.com/traceloop/llm-proxy", "Go", "Apache 2.0", "Proxy nastawione na standaryzację OpenTelemetry i monitorowanie promptów.", "Konfiguracja jako upstream w narzędziach deweloperskich VS Code.", "docker run traceloop/llm-proxy"),
    (24, "Anoop (AI Gateway)", "https://github.com/anoop-ai/gateway", "Go", "MIT", "Ultralekka bramka z wbudowanym buforowaniem (caching) odpowiedzi w pamięci Redis.", "Wskazanie adresu jako apiBase w pliku config.json wtyczki Continue.", "docker run anoop-ai/gateway"),
    (25, "Genai-Gateway", "https://github.com/genai-gateway/genai-gateway", "Python", "GPL-3.0", "Bramka upraszczająca i zabezpieczająca korporacyjny dostęp do modeli on-premise.", "Wpięcie przez rozszerzenia proxy w VS Code z uwierzytelnieniem OAuth2.", "pip install genai-gateway"),
    (26, "GrtGenAI Gateway", "https://github.com/grt-genai/gateway", "Go", "Apache 2.0", "Bramka nastawiona na wysoką dostępność i dynamiczny load balancing pomiędzy wieloma chmurami.", "Konfiguracja adresu klastra jako domyślnego dostawcy AI w środowisku IDE.", "docker run grt-genai-gateway"),
    (27, "LlamaEdge", "https://github.com/LlamaEdge/LlamaEdge", "Rust / Wasm", "Apache 2.0", "Serwer i router dla modeli uruchamianych w lekkich kontenerach WebAssembly (WasmEdge).", "Wskazanie lokalnego portu Wasm w konfiguracji rozszerzenia LLM w edytorze.", "wasmedge --dir . llamaedge.wasm"),
    (28, "FastChat", "https://github.com/lm-sys/FastChat", "Python", "Apache 2.0", "Otwarta platforma do trenowania, serwowania i oceniania chatbotów, zawiera serwer API.", "Działa jako idealny, lokalny serwer zgodny z formatem REST API OpenAI.", "python3 -m fastchat.serve.controller"),
    (29, "Tabby", "https://github.com/tabbyml/tabby", "Rust", "Apache 2.0", "Samodzielny serwer i bramka AI dedykowana wyłącznie do autouzupełniania kodu.", "Posiada dedykowaną, oficjalną wtyczkę Tabby w VS Code Marketplace.", "docker run -p 8080:8080 tabbyml/tabby"),
    (30, "Text Generation Inference", "https://github.com/huggingface/text-generation-inference", "Rust / Python", "Apache 2.0", "Stworzony przez Hugging Face potężny ruter i silnik do wdrażania modeli produkcyjnych.", "Wskazanie endpointu TGI jako Custom OpenAI / HuggingFace Provider w VS Code.", "docker run --gpus all ghcr.io/huggingface/text-generation-inference")
]

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "Bramki LLM AI"

# Enable grid lines
ws.views.sheetView[0].showGridLines = True

# Headers matching the user's requested layout
headers = [
    "Lp.",
    "Nazwa Bramki",
    "Link",
    "Język / Technologia",
    "Licencja",
    "Główne zadanie / wyróżnik",
    "Metoda podłączenia do VS Code",
    "Podstawowa komenda instalacji"
]

# Styling definitions
header_fill = PatternFill(start_color="1E293B", end_color="1E293B", fill_type="solid") # Dark slate
header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")

row_even_fill = PatternFill(start_color="F8FAFC", end_color="F8FAFC", fill_type="solid") # Very light slate/grey
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

# Add Headers
ws.append(headers)

for col_num in range(1, len(headers) + 1):
    cell = ws.cell(row=1, column=col_num)
    cell.fill = header_fill
    cell.font = header_font
    cell.alignment = Alignment(horizontal="center" if col_num in [1, 5] else "left", vertical="center", wrap_text=True)

ws.row_dimensions[1].height = 28

# Add Rows
for row_idx, item in enumerate(raw_data, start=2):
    lp, name, link, lang, license_type, desc, vs_connect, install_cmd = item
    
    ws.cell(row=row_idx, column=1, value=lp)
    ws.cell(row=row_idx, column=2, value=name)
    
    # Link as clickable formula or text with hyperlink
    link_cell = ws.cell(row=row_idx, column=3, value="Link")
    link_cell.hyperlink = link
    link_cell.font = font_link
    
    ws.cell(row=row_idx, column=4, value=lang)
    ws.cell(row=row_idx, column=5, value=license_type)
    ws.cell(row=row_idx, column=6, value=desc)
    ws.cell(row=row_idx, column=7, value=vs_connect)
    ws.cell(row=row_idx, column=8, value=install_cmd)

    fill = row_even_fill if row_idx % 2 == 0 else row_odd_fill
    
    for col_idx in range(1, len(headers) + 1):
        cell = ws.cell(row=row_idx, column=col_idx)
        cell.fill = fill
        cell.border = thin_border
        
        # Fonts and alignments
        if col_idx == 1:
            cell.font = font_bold
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 2:
            cell.font = font_bold
            cell.alignment = Alignment(horizontal="left", vertical="center")
        elif col_idx == 3:
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 5:
            cell.font = font_regular
            cell.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 8:
            cell.font = font_code
            cell.alignment = Alignment(horizontal="left", vertical="center")
        else:
            cell.font = font_regular
            cell.alignment = Alignment(horizontal="left", vertical="center", wrap_text=True)

    ws.row_dimensions[row_idx].height = 36

# Set Column Widths
col_widths = {
    1: 6,   # Lp.
    2: 24,  # Nazwa Bramki
    3: 10,  # Link
    4: 18,  # Język / Technologia
    5: 14,  # Licencja
    6: 45,  # Główne zadanie / wyróżnik
    7: 42,  # Metoda podłączenia do VS Code
    8: 38   # Podstawowa komenda instalacji
}

for col_idx, width in col_widths.items():
    col_letter = get_column_letter(col_idx)
    ws.column_dimensions[col_letter].width = width

# Freeze Header Row
ws.freeze_panes = "A2"

file_path = "Bramki_LLM_AI_VS_Code.xlsx"
wb.save(file_path)
print(f"File successfully created: {file_path}")



