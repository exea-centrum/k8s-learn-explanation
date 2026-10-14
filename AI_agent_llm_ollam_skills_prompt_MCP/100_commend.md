Oto kompletny katalog 100 taktycznych komend (slash-commands) dla inżynierów, architektów i liderów technicznych. Zestaw ten obejmuje pełen cykl życia oprogramowania: od myślenia produktowego, przez kodowanie, automatyzację, architekturę, aż po zarządzanie kryzysowe i pracę z AI.
------------------------------
## 🛠️ CYKL 1: ARCHITEKTURA I DECISION-MAKING## /plan – Jak nie oddać AI kluczowych decyzji o produkcie

* Rola AI: Traktuj model jak wykonawcę, nie architekta.
* Granice autonomii: Samodzielnie definiuj logikę biznesową i architekturę.
* Promptowanie: Narzucaj sztywne ramy techniczne przed generowaniem kodu.
* Weryfikacja: Kwestionuj i sprawdzaj każdą decyzję projektową AI.

## /spike – Badanie technologii bez brudzenia projektu

* Limit czasowy: Ustaw sztywny czas (np. 4 godziny) na badanie.
* Kod-śmieć: Pisz szybko – ten kod ma jedynie dowieść koncepcji.
* Cel: Odpowiedz na pytanie „czy to zadziała”, nie „jak wdrożyć”.
* Wnioski: Zakończ proces krótką notatką z rekomendacjami dla zespołu.

## /adr – Architektura udokumentowana (Architecture Decision Record)

* Krótki format: Dokumentuj decyzje na jednej stronie pliku Markdown.
* Kontekst: Opisuj problem i czynniki, które wpłynęły na wybór.
* Konsekwencje: Wypunktuj kompromisy (trade-offs) i minusy wybranego rozwiązania.
* Wersjonowanie: Trzymaj pliki ADR w repozytorium razem z kodem.

## /rfc – Request for Comments przed napisaniem kodu

* Konsultacje: Opisz dużą zmianę w dokumencie przed jej implementacją.
* Demokracja: Daj zespołowi 48 godzin na zgłoszenie uwag i poprawek.
* Wyrównanie: Unikaj sytuacji, w której ktoś kwestionuje architekturę podczas Code Review.
* Ślad: RFC stanowi świetne źródło wiedzy dla nowych pracowników.

## /lock-in – Unikanie pułapki jednego dostawcy (Vendor Lock-in)

* Abstrakcja: Ukrywaj zewnętrzne API za własnymi interfejsami (porty i adaptery).
* Wymienność: Projektuj kod tak, by zmiana bazy danych była tania.
* Standardy: Wybieraj otwartoźródłowe technologie z dużą społecznością.
* Koszt wyjścia: Raz w roku szacuj budżet potrzebny na zmianę dostawcy chmury.

## /trade-off – Świadome godzenie się na kompromisy

* Brak ideałów: Zaakceptuj, że każda decyzja architektoniczna ma wady.
* Macierz: Porównuj rozwiązania pod kątem ceny, czasu i wydajności.
* Dokumentacja: Zapisz, dlaczego wybrałeś gorszą jakość kosztem szybkości.
* Przegląd: Wracaj do tych kompromisów przy każdym długu technicznym.

## /monolith-first – Kiedy mikroserwisy to błąd

* Prostota: Zaczynaj projekty od modularnego monolitu (modular monolith).
* Granice domeny: Poznaj biznes, zanim potniesz system na osobne bazy.
* Koszty: Unikaj narzutu sieciowego i rozproszonych transakcji na starcie.
* Moment podziału: Wydzielaj mikroserwisy dopiero, gdy zespół lub ruch drastycznie urośnie.

## /bounded-context – Czyste granice w Domain-Driven Design

* Jeden język: Definiuj pojęcia (np. "Klient") per konkretny moduł.
* Izolacja: Nie współdziel modeli bazodanowych między różnymi domenami.
* Komunikacja: Używaj jawnych mapowań (Context Map) przy przesyłaniu danych.
* Autonomia: Pozwól zespołom pracować na własnych kontekstach bez blokowania się.

## /strangler – Bezpieczna wymiana starego systemu (Strangler Fig Pattern)

* Stopniowo: Zastępuj stary system krok po kroku, funkcja po funkcji.
* Fasada: Postaw proxy (np. API Gateway) przed starym i nowym kodem.
* Przekierowanie: Przełączaj ruch na nowy system dla pojedynczych endpointów.
* Uśmiercenie: Wyłącz stary serwer dopiero, gdy ruch spadnie do zera.

## /cqrs – Rozdzielenie zapisu od odczytu danych

* Osobne ścieżki: Używaj innych modeli do modyfikacji danych, innych do wyświetlania.
* Wydajność: Optymalizuj odczyty pod kątem UI (np. widoki zmaterializowane).
* Skalowanie: Skaluj niezależnie serwery bazodanowe dla zapisu i odczytu.
* Złożoność: Wprowadzaj CQRS tylko tam, gdzie logika biznesowa jest skomplikowana.

------------------------------
## 🪵 CYKL 2: KONTROLA WERSJI I GIT (GIT MASTERY)## /fork – Dwa niezależne tory pracy bez mieszania kontekstu

* Izolacja: Twórz osobne gałęzie (branches) dla różnych funkcji.
* Czysty start: Zawsze rozgałęziaj się od stabilnej wersji głównej (main).
* Brak konfliktów: Nie łącz niedokończonych zadań w jednym miejscu.
* Zarządzanie: Łatwiej porzucisz lub przebudujesz odizolowany pomysł.

## /worktree – Osobny folder projektu dla drugiego taska

* Równoległość: Użyj git worktree add, by pilnie naprawić błąd podczas pisania funkcji.
* Koniec ze stash: Unikasz ciągłego chowania i przywracania zmian Git.
* Długie procesy: Przydatne, gdy jeden folder kompiluje kod lub uruchamia testy.
* Niezależność: Masz otwarte dwa różne stany projektu jednocześnie w IDE.

## /compact – Skracanie historii historii zadania (Squashing)

* Porządek: Używaj git rebase -i, aby połączyć drobne commity.
* Usuwanie szumu: Scalaj poprawki typu "fix typo" w jedno duże zadanie.
* Jasne komunikaty: Zachowaj opisy wyjaśniające dlaczego podjąłeś decyzję.
* Czysty log: Pozostaw czytelną historię zmian dla reszty zespołu.

## /bisect – Szukanie błędu metodą przeszukiwania binarnego

* Automatyzacja: Użyj git bisect, gdy nie wiesz, który commit popsuł kod.
* Stan dobry/zły: Wskaż ostatni działający commit i obecny wadliwy.
* Testowanie: Git sam przełącza commity po kolei w połowie stawki.
* Skrypt: Możesz podpiąć test automatyczny (git bisect run pytest), by sam znalazł winnego.

## /cherry-pick – Przenoszenie pojedynczej zmiany między gałęziami

* Precyzja: Skopiuj dokładnie jeden commit z innej gałęzi za pomocą ID.
* Gorąca poprawka: Przydatne, gdy fix z gałęzi testowej potrzebny jest na gwałt na main.
* Bez balastu: Przenosisz zmianę bez konieczności mergowania całego brancha.
* Uwaga: Monitoruj konflikty, jeśli kod dookoła różni się w obu miejscach.

## /reflog – Gitowa czarna skrzynka i ratowanie usuniętego kodu

* Historia lokalna: git reflog rejestruje każdy Twój ruch, nawet usunięte gałęzie.
* Wehikuł czasu: Znajdź ID commita, który przed chwilą skasowałeś przez git reset --hard.
* Przywracanie: Użyj git checkout <commit_id>, aby odzyskać rzekomo stracony kod.
* Spokój ducha: Pamiętaj, że w Git nieskommitowane rzeczy giną, skommitowane prawie nigdy.

## /rebase – Utrzymywanie płaskiej historii projektu

* Alternatywa: Użyj git rebase main zamiast git merge main na swoim branchu.
* Efekt: Twój kod aplikuje się na samą górę najnowszych zmian z maina.
* Brak merge-commitów: Historia wygląda jak linia prosta, a nie pajęczyna.
* Zasada: Nigdy nie rób rebase na publicznych gałęziach, z których korzystają inni.

## /rerere – Automatyczne rozwiązywanie tych samych konfliktów

* Skrót: Reuse Recorded Resolution (git config --global rerere.enabled true).
* Pamięć: Git zapamiętuje, jak rozwiązałeś dany konflikt podczas merge/rebase.
* Automatyzacja: Przy kolejnym takim samym konflikcie Git rozwiąże go za Ciebie.
* Zastosowanie: Nieocenione przy długo żyjących gałęziach i częstych rebase'ach.

## /hooks – Automatyzacja zadań przed commitem (Git Hooks)

* Lokalny strażnik: Skrypty w .git/hooks/ uruchamiają się przy akcjach gita.
* Pre-commit: Zablokuj zatwierdzenie kodu, jeśli linter zgłasza błędy stylistyczne.
* Pre-push: Uruchom szybkie testy jednostkowe przed wysłaniem kodu na serwer.
* Narzędzia: Używaj frameworków typu husky lub pre-commit, by łatwo dzielić hooks z zespołem.

## /blame – Dochodzenie autorstwa kodu bez szukania winnych

* Kontekst: Sprawdź, kto i kiedy dodał daną linię kodu (git blame plik.js).
* Cel: Dowiedz się, jaka intencja stała za nietypowym rozwiązaniem.
* Integracja: Używaj rozszerzeń do IDE (np. GitLens), by widzieć historię w tle linii.
* Kultura: Używaj blame do nauki i szukania mentorów, nie do wytykania palcami.

------------------------------
## 🎯 CYKL 3: METODOLOGIA I ORGANIZACJA PRACY## /goal – Definiowanie „gotowe” w długim zadaniu (Definition of Done)

* Kryteria: Rozbij cel główny na mierzalne podpunkty (checklistę).
* Standard: Określ wymagania techniczne (testy, dokumentacja, code review).
* MVP: Twórz mniejsze, samodzielnie działające etapy zadania.
* Wizualizacja: Trzymaj DoD w widocznym miejscu na tablicy zadań (np. Jira).

## /scout – Zasada skauta w codziennej pracy z repozytorium

* Zostaw czystsze: Popraw napotkany drobny błąd lub formatowanie w edytowanym pliku.
* Zasięg: Nie naprawiaj całego modułu, jeśli pracujesz nad jedną funkcją.
* Procent składany: Małe, codzienne poprawki zespołu zapobiegają długowi technicznemu.
* Osobny commit: Zmiany kosmetyczne commituj oddzielnie od logiki biznesowej.

## /timebox – Sztywne ramy czasowe dla trudnych problemów

* Blokada: Daj sobie maksymalnie 60 minut na samodzielne rozwiązanie problemu.
* Eskalacja: Jeśli czas minie, a Ty stoisz w miejscu – poproś zespół o pomoc.
* Ochrona: Zapobiega wpadaniu w "króliczą norę" i marnowaniu dni na jeden bug.
* Skupienie: Pracuj w tym czasie bez rozpraszaczy (Slack, telefon).

## /wip-limit – Ograniczenie zadań w toku (Work in Progress)

* Skupienie: Ustal limit otwartych zadań na osobę (maksymalnie 1-2).
* Domykanie: Lepiej skończyć jedno zadanie niż zacząć trzy nowe.
* Wąskie gardła: Łatwiej zauważyć bloki i przestoje w zespole.
* Przełączanie kontekstu: Mniejszy WIP to mniejsze zmęczenie mózgu.

## /backlog-grooming – Regularne czyszczenie listy zadań

* Usuwanie śmieci: Kasuj zadania, które wiszą dłużej niż 6 miesięcy i straciły sens.
* Estymacja: Doprecyzuj opisy zadań na najbliższe 2 tygodnie pracy.
* Priorytetyzacja: Przesuwaj najważniejsze cele biznesowe na samą górę listy.
* Uczestnicy: Rób to wspólnie z Product Ownerem i liderem technicznym.

## /post-mortem – Analiza awarii bez szukania kozła ofiarnego

* Kultura bezpieczeństwa: Skup się na tym, co zawiodło w procesie, a nie kto zawinił.
* 5 Whys: Pytaj pięć razy "dlaczego", aby dojść do źródłowej przyczyny problemu.
* Akcje naprawcze: Każde spotkanie musi skończyć się listą zadań zapobiegawczych.
* Transparentność: Publikuj raporty post-mortem dla całej firmy, by uczyć się na błędach.

## /technical-debt – Zarządzanie długiem technicznym

* Rejestr: Zapisuj miejsca w kodzie, które wymagają poprawy (np. jako tickety z tagiem tech-debt).
* Spłata: Przeznaczaj stały procent czasu w każdym sprincie (np. 15%) na refaktor.
* Świadomość: Informuj biznes o kosztach ignorowania długu (wolniejsze dostarczanie funkcji).
* Klasyfikacja: Rozróżniaj dług świadomy (szybkie MVP) od nieświadomego (zły kod).

## /bus-factor – Zwiększanie odporności zespołu na rotację

* Definicja: Ile osób musi potrącić autobus, by projekt upadł? (Cel: > 3).
* Rotacja zadań: Nie przypisuj trudnych modułów zawsze tej samej osobie.
* Pair programming: Piszcie kluczowe elementy systemu w parach.
* Wiedza: Dbaj o aktualność dokumentacji architektury i wdrożeń.

## /no-estimates – Praca bez tradycyjnych estymacji czasowych

* Podejście: Zamiast zgadywać godziny, dziel zadania na równe, małe kawałki.
* Metryki: Mierz średni czas domykania ticketu (Cycle Time) i przewiduj na podstawie danych.
* Oszczędność: Przestań marnować godziny na długie spotkania estymacyjne.
* Skupienie: Przenieś uwagę zespołu z "ile to zajmie" na "jak to uprościć".

## /rubber-duck – Metoda gumowej kaczuszki na sterydach

* Algorytm: Wyjaśnij swój problem linijka po linijce przedmiotowi (lub AI).
* Mózg: Podczas mówienia na głos aktywujesz inne obszary mózgu, co często rodzi rozwiązanie.
* Zasada: Zanim zawołasz seniora, opisz kaczce, co już sprawdziłeś.
* Oszczędność czasu: Połowa pytań do zespołu znika w trakcie ich pisania/mówienia.

------------------------------
## 🕵️ CYKL 4: JAKOŚĆ KODU I REWIZJA (CODE QUALITY & REVIEW)## /review – Dlaczego zielone testy to za mało

* Granice testów: Testy automatyczne sprawdzają tylko zaprogramowane scenariusze.
* Luki logiczne: Zielony status ignoruje błędy biznesowe i złe założenia projektowe.
* Brzegowe przypadki: Kod może działać dla idealnych danych, ale wyłożyć się na pustych.
* Bezpieczeństwo: Testy rzadko wykrywają podatności i wycieki pamięci.

## /refactor – Bezpieczne sprzątanie kodu źródłowego

* Zasada: Nigdy nie łącz refaktoryzacji z dodawaniem nowych funkcjonalności.
* Baza: Uruchom testy przed wprowadzeniem jakichkolwiek modyfikacji.
* Kroki: Zmieniaj po jednym elemencie i od razu sprawdzaj stabilność.
* Zachowanie: Wynik działania programu dla użytkownika końcowego musi być identyczny.

## /lint – Automatyczna kontrola stylu kodu (Linting)

* Zero dyskusji: Przenieść spory o formatowanie (spacje vs taby) na narzędzia (np. Prettier, ESLint).
* CI/CD: Blokuj buildy, które nie spełniają standardów stylistycznych projektu.
* Automatyzacja: Skonfiguruj IDE tak, by naprawiało styl przy każdym zapisie pliku.
* Skupienie: Na Code Review rozmawiaj o architekturze, nie o średnikach.

## /pair-programming – Programowanie w parach na trudne odcinki

* Role: Jedna osoba pisze kod (Driver), druga patrzy szerzej i planuje (Navigator).
* Wymiana: Zamieniajcie się rolami co 20-30 minut, by utrzymać wysokie skupienie.
* Zastosowanie: Stosuj przy wdrażaniu nowych osób lub pisaniu krytycznych modułów.
* Efekt: Kod opuszczający parę jest już po Code Review i ma niski wskaźnik błędów.

## /mutation-testing – Testowanie jakości samych testów

* Zasada: Narzędzie (np. Stryker) celowo wprowadza błędy do Twojego kodu (mutuje go).
* Weryfikacja: Jeśli Twoje testy nadal są zielone po zepsuciu kodu – testy są słabe.
* Przeżywalność: Celem jest "zabicie" wszystkich mutantów poprzez dobre asercje.
* Głębia: Pokazuje realną wartość testów, a nie tylko suche pokrycie linii (Code Coverage).

## /cognitive-complexity – Walka ze złożonością poznawczą

* Definicja: Miernik mówiący o tym, jak trudno człowiekowi zrozumieć dany kod.
* Wrogowie: Zagnieżdżone pętle, warunki if-else na 4 poziomy, wielkie funkcje.
* Refaktor: Rozbijaj skomplikowane bloki logiczne na małe, dobrze nazwane metody.
* Limit: Ustal w linterze maksymalną złożoność poznawczą (np. do 10-15 punktów).

## /code-ownership – Odpowiedzialność za fragmenty systemu

* Wspólna własność: Cały zespół powinien rozumieć i móc edytować każdą część kodu.
* CODEOWNERS: Użyj pliku w Git, by automatycznie przypisywać ekspertów domenowych do review.
* Silosy: Unikaj sytuacji, gdzie tylko "Janek" potrafi naprawić moduł płatności.
* Rotacja: Celowo wysyłaj zadania z danej domeny osobom, które jej słabo znają.

## /defensive-programming – Programowanie obronne

* Nie ufaj: Nigdy nie ufaj danym wejściowym od użytkownika lub zewnętrznego API.
* Walidacja: Sprawdzaj typy, zakresy i poprawność danych na samym wejściu do systemu.
* Fail-fast: Rzucaj błędami natychmiast, gdy wykryjesz nieprawidłowość, nie idź dalej.
* Wyjątki: Obsługuj błędy w sposób kontrolowany, nie pozwól aplikacji "wywalić się" całkowicie.

## /clean-code-myth – Zdrowy rozsądek ponad dogmatami

* Umiar: Czytelny kod jest ważny, ale działający i dostarczony na czas produkt jest ważniejszy.
* YAGNI: You Aren't Gonna Need It – nie pisz abstrakcji na zapas dla funkcji, które mogą nie powstać.
* Przesada: Unikaj tworzenia klas z jedną linią kodu i piętnastu poziomów interfejsów.
* Kontekst: Czasami prosty, lekko powtórzony kod (DRY) jest lepszy niż skomplikowana abstrakcja.

## /pull-request-size – Małe paczki zmian to szybsze wdrożenia

* Limit: Idealny Pull Request powinien zawierać mniej niż 200-300 linii kodu.
* Szybkość: Małe PR są sprawdzane w 15 minut, duże wiszą dniami i generują konflikty.
* Jakość: Im większy PR, tym mniej uważnie reviewer na niego patrzy (efekt "wygląda OK").
* Dzielenie: Rozbijaj duże zadania na mniejsze, niezależne PR (np. najpierw baza, potem logika).

------------------------------
## 🚀 CYKL 5: WDROŻENIA I DEPLOYMENT (CI/CD)## /rollback – Bezpieczne wycofywanie zmian na produkcji

* Rozłączność: Rozdziel proces wdrożenia kodu (deploy) od aktywacji funkcji (release).
* Feature flags: Wyłączaj wadliwe funkcje jednym kliknięciem w panelu, bez przebudowy aplikacji.
* Migracje bazy: Projektuj zmiany w bazie tak, by stary kod obsługiwał nową strukturę (i odwrotnie).
* Skrypt: Przygotuj i przetestuj procedurę powrotu do poprzedniej wersji zanim klikniesz deploy.

## /shadow – Testowanie kodu na żywym ruchu (Shadow Deploy)

* Klonowanie ruchu: Duplikuj zapytania realnych użytkowników i wysyłaj je na nowy system.
* Ignorowanie: Wyniki z nowego kodu są zapisywane do analizy, ale nie trafiają do klienta.
* Wydajność: Sprawdź, jak nowa wersja radzi sobie z realnym obciążeniem i danymi.
* Bezpieczeństwo: Błędy i crashe w nowym kodzie mają zerowy wpływ na obecną produkcję.

## /freeze – Kiedy i jak zamrozić kod przed ważnym wydaniem

* Blokada: Zabroń dodawania nowych funkcji (feature freeze) na określony czas przed dużym eventem.
* Wyjątki: Pozwalaj wyłącznie na poprawki błędów blokujących wdrożenie (critical bugfixes).
* Stabilizacja: Wykorzystaj ten czas na intensywne testy manualne, regresyjne i dokumentację.
* Komunikacja: Jasno określ ramy czasowe zamrożenia, aby programiści nie gromadzili kodu lokalnie.

## /blue-green – Wdrożenia bez przestojów (Zero Downtime Deploy)

* Dwa środowiska: Utrzymuj dwa identyczne środowiska produkcyjne: Blue (obecne) i Green (nowe).
* Ruch: Cały ruch użytkowników idzie na środowisko Blue.
* Wdrożenie: Wgraj nową wersję aplikacji na środowisko Green i przetestuj je tam na spokojnie.
* Przełączenie: Przepnij router/load balancer na Green. Jeśli coś pójdzie nie tak, wracasz na Blue w sekundę.

## /canary – Stopniowe wypuszczanie funkcji dla użytkowników

* Procenty: Wdróż nową wersję systemu tylko dla małego ułamka użytkowników (np. 1-2%).
* Monitoring: Monitoruj logi i wykresy błędów dla tej małej grupy (tzw. kanarka).
* Skalowanie: Jeśli system jest stabilny, stopniowo zwiększaj ruch (10%, 50%, 100%).
* Ograniczenie szkód: Jeśli nowa wersja ma krytyczny błąd, dotknie on tylko ułamka klientów.

## /feature-flags – Sterowanie funkcjami systemu w czasie rzeczywistym

* Decoupling: Oddziel wdrożenie techniczne od decyzji biznesowej o uruchomieniu opcji.
* Zdalna kontrola: Włączaj i wyłączaj sekcje aplikacji bez konieczności ponownego deployu.
* Testy A/B: Używaj flag do pokazywania różnych wersji strony wybranym grupom docelowym.
* Higiena: Usuwaj flagi z kodu natychmiast po tym, jak funkcja zostanie w pełni zaakceptowana.

## /ci-optimization – Przyspieszanie pipeline'ów budujących

* Cache: Agresywnie cachuj zależności (node_modules, biblioteki) między uruchomieniami CI.
* Paralelizacja: Uruchamiaj testy jednostkowe, integracyjne i lintery równolegle w osobnych kontenerach.
* Testy selektywne: Konfiguruj CI tak, by uruchamiało testy tylko dla zmodyfikowanych modułów aplikacji.
* Szybka informacja: Pipeline musi dawać informację zwrotną programiście w czasie krótszym niż 5-10 minut.

## /infrastructure-as-code – Infrastruktura jako kod (IaC)

* Zasada: Definiuj serwery, sieci i bazy danych za pomocą kodu (np. Terraform, CloudFormation).
* Powtarzalność: Twórz nowe środowiska (testowe, deweloperskie) w kilka minut za pomocą jednego skryptu.
* Wersjonowanie: Trzymaj konfigurację chmury w Git – każda zmiana w infrastrukturze wymaga Pull Requesta.
* Brak klikania: Zablokuj zespołowi możliwość ręcznego zmieniania opcji w panelu AWS/Azure (tzw. click-ops).

## /smoke-tests – Szybkie testy weryfikacyjne po wdrożeniu

* Zasięg: Zestaw kilku kluczowych testów sprawdzających, czy aplikacja w ogóle wstała na produkcji.
* Przykład: Sprawdź, czy strona główna zwraca kod 200 i czy działa endpoint logowania.
* Automatyzacja: Uruchamiaj smoke testy automatycznie sekundy po zakończeniu deploymentu.
* Szybki alarm: Pozwala wykryć najgłupsze błędy konfiguracji zanim zauważą je pierwsi użytkownicy.

## /immutable-infrastructure – Niezmienna infrastruktura

* Brak zmian na żywo: Nigdy nie konfiguruj i nie naprawiaj działających serwerów produkcyjnych przez SSH.
* Zasada: Jeśli potrzebujesz zmiany, stwórz nowy obraz serwera (np. Docker) i zastąp nim stary.
* Stabilność: Eliminuje problem "u mnie działa" oraz rozjeżdżanie się konfiguracji serwerów w czasie.
* Bezpieczeństwo: Serwery bez dostępu SSH i możliwości modyfikacji plików są trudniejsze do skompromitowania.

------------------------------
## 📈 CYKL 6: MONITORING, OBSERVABILITY I WYDAJNOŚĆ## /observability – Trzy filary pełnego wglądu w system

* Metryki: Zbieraj dane liczbowe w czasie (zużycie CPU, RAM, liczba zapytań/sekundę).
* Logi: Zapisuj strukturyzowane zdarzenia (JSON) z kontekstem, by móc odtworzyć bieg awarii.
* Traces: Śledź drogę pojedynczego żądania przechodzącego przez wiele mikroserwisów (Distributed Tracing).
* Cel: Dowiedz się nie tylko że system nie działa, ale dokładnie dlaczego i gdzie leży problem.

## /sla-sli-slo – Definiowanie poziomów dostępności usług

* SLI (Indicator): Dokładna metryka, np. czas odpowiedzi 95% zapytania poniżej 200ms.
* SLO (Objective): Cel, jaki chcemy osiągnąć, np. SLI musi być spełnione przez 99.9% czasu w miesiącu.
* SLA (Agreement): Umowa prawna z klientem – co mu zapłacimy, jeśli nie dowieziemy SLO.
* Zastosowanie: Kieruj się SLO przy podejmowaniu decyzji, czy robić nowe funkcje, czy stabilizować system.

## /error-budget – Budżet błędów jako regulator pracy

* Definicja: Margines błędu wynikający z Twojego SLO (np. dopuszczalne 43 minuty przestoju w miesiącu).
* Zużycie: Każda awaria lub spowolnienie systemu "zjada" Twój budżet błędów.
* Stop-funkcje: Jeśli budżet błędów na dany miesiąc się skończy, zespół zamraża nowe funkcje i naprawia system.
* Równowaga: Godzi potrzebę biznesu (szybkie wdrażanie) z potrzebą IT (stabilność).

## /alert-fatigue – Walka ze zbyt dużą liczbą powiadomień

* Problem: Zespół ignoruje alerty na Slacku, jeśli jest ich za dużo i większość nie wymaga akcji.
* Zasada: Alertuj tylko o rzeczach, które realnie bolą użytkownika (np. wzrost błędów 5xx), a nie o skokach CPU.
* Akcja: Każdy alert docierający do programisty na dyżurze musi mieć jasną procedurę naprawy (Runbook).
* Czyszczenie: Raz w miesiącu przeglądaj i usuwaj alerty, które nie doprowadziły do żadnej akcji.

## /runbook – Instrukcje operacyjne na wypadek awarii

* Lokalizacja: Trzymaj instrukcje w łatwo dostępnym wiki lub repozytorium projektu.
* Zawartość: Krok po kroku co zrobić, gdy padnie baza, skończy się dysk lub wzrosną opóźnienia.
* Prostota: Pisz instrukcje tak, by zmęczony programista o 3 nad ranem potrafił je wykonać bez myślenia.
* Aktualizacja: Testuj poprawność runbooków podczas planowanych ćwiczeń z awarii.

## /chaos-engineering – Kontrolowane psucie produkcji

* Zasada: Celowo wstrzykuj awarie do środowiska produkcyjnego (np. wyłączaj serwery za pomocą Chaos Monkey).
* Cel: Sprawdź, czy system potrafi sam wyleczyć się z problemów (self-healing) bez udziału człowieka.
* Warunki: Rób to w ciągu dnia, przy pełnej gotowości zespołu i dobrym monitoringu.
* Efekt: Znajdujesz słabe punkty architektury zanim zrobi to losowa awaria w środku nocy.

## /rate-limiting – Ochrona zasobów przed przeciążeniem

* Limit: Ustal maksymalną liczbę żądań, jaką dany użytkownik/IP może wykonać w ciągu minuty.
* Odmowa: Zwracaj kod błędu 429 (Too Many Requests), gdy ktoś przekroczy limit.
* Ochrona: Zabezpiecza aplikację przed atakami DDoS, złośliwymi botami i błędami w pętlach u klientów.
* Poziomy: Stosuj restrykcyjne limity na ciężkich endpointach (np. wyszukiwarka, generowanie PDF).

## /circuit-breaker – Bezpiecznik w systemach rozproszonych

* Problem: Gdy usługa zewnętrzna (np. bramka płatności) działa wolno, blokuje wątki Twojej aplikacji.
* Rozwiązanie: Po przekroczeniu progu błędów bezpiecznik się otwiera i natychmiast odrzuca żądania do tej usługi.
* Fallback: Zwróć użytkownikowi dane z cache lub czytelny komunikat, zamiast kazać mu czekać na timeout.
* Powrót: Co jakiś czas bezpiecznik przepuszcza jedno zapytanie, by sprawdzić, czy usługa zewnętrzna wstała.

## /caching-strategies – Mądre strategie buforowania danych

* Zasada: Nie pytaj bazy danych o rzeczy, które rzadko się zmieniają (np. konfiguracja, lista krajów).
* Inwalidacja: Najtrudniejszy element – określ dokładnie, kiedy cache traci ważność (TTL, event-driven).
* Warstwy: Stosuj cache na poziomie przeglądarki (HTTP headers), CDN, aplikacji (w pamięci RAM) i bazy.
* Zagrożenie: Pamiętaj o ryzyku zaserwowania użytkownikowi nieaktualnych lub cudzych danych danych.

## /database-indexing – Optymalizacja zapytań u źródła

* Analiza: Używaj komendy EXPLAIN ANALYZE przed wolnymi zapytaniami SQL, by zobaczyć, jak baza szuka danych.
* Indeksy: Twórz indeksy na kolumnach, po których często filtrujesz (WHERE) lub łączysz tabele (JOIN).
* Koszty: Pamiętaj, że każdy indeks przyspiesza odczyt, ale spowalnia zapis (INSERT/UPDATE).
* Indeksy złożone: Kolejność kolumn w indeksie wielokolumnowym ma kluczowe znaczenie dla optymalizatora bazy.

------------------------------
## 🔒 CYKL 7: BEZPIECZEŃSTWO I SEKRETY (SECURITY FIRST)## /secrets-management – Przechowywanie haseł i kluczy API

* Zakaz: Nigdy, pod żadnym pozorem, nie wrzucaj haseł, kluczy API ani certyfikatów do repozytorium Git.
* Zmienne: Używaj zmiennych środowiskowych (.env) ładowanych w czasie uruchamiania aplikacji.
* Sejfy: W produkcji korzystaj z dedykowanych rozwiązań: AWS Secrets Manager, HashiCorp Vault, Doppler.
* Audyt: Używaj narzędzi (np. GitGuardian), które skanują historię Git w poszukiwaniu przypadkowych wycieków.

## /least-privilege – Zasada minimalnych uprawnień

* Dostęp: Dawaj systemom i ludziom tylko takie uprawnienia, jakich absolutnie potrzebują do wykonania pracy.
* Bazy danych: Aplikacja nie powinna łączyć się z bazą jako użytkownik root / admin.
* CI/CD: Skrypty wdrożeniowe powinny mieć uprawnienia tylko do modyfikacji danej usługi, nie całej chmury.
* Przegląd: Regularnie (np. raz na kwartał) odbieraj nieaktywne uprawnienia i dostępy byłym pracownikom.

## /owasp-top-10 – Regularna weryfikacja pod kątem głównych zagrożeń

* Standard: Edukuj zespół w oparciu o listę OWASP Top 10 (najczęstsze podatności aplikacji webowych).
* SQL Injection: Zawsze używaj sparametryzowanych zapytań (ORM), nigdy nie łącz stringów z danymi od użytkownika.
* XSS: Filtruj i koduj wszystko, co użytkownik wprowadza i co potem wyświetlasz na stronie.
* Automatyzacja: Używaj skanerów podatności wbudowanych w GitHub/GitLab (Dependabot) do wykrywania dziur w paczkach.

## /dependency-hell – Zarządzanie zewnętrznymi bibliotekami

* Minimalizm: Zanim dodasz nową paczkę npm/pip/nuget, zastanów się, czy nie potrafisz napisać tego w 5 liniach kodu.
* Lockfile: Zawsze commituj pliki typu package-lock.json lub poetry.lock, aby zapewnić identyczne wersje u wszystkich.
* Aktualizacje: Nie czekaj latami z aktualizacją frameworków – rób to mniejszymi krokami raz w miesiącu.
* Licencje: Skanuj biblioteki pod kątem licencji (np. unikaj GPL w projektach komercyjnych bez analizy prawnej).

## /rbac-abac – Nowoczesna kontrola dostępu w aplikacji

* RBAC: Kontrola oparta na rolach (Role-Based) – sprawdzasz, czy użytkownik to Admin, czy User.
* ABAC: Kontrola oparta na atrybutach (Attribute-Based) – bardziej precyzyjna, np. "czy użytkownik jest właścicielem tego dokumentu".
* Centralizacja: Logikę uprawnień trzymaj w jednym dedykowanym module, nie rozrzucaj jej po kontrolerach.
* Testy: Pisz dedykowane testy sprawdzające, czy nieautoryzowany użytkownik dostanie błąd 403 przy próbie dostępu.

## /data-anonymization – Ochrona danych osobowych (RODO/GDPR)

* Środowiska lokalne: Nigdy nie kopiuj bazy produkcyjnej z realnymi danymi klientów na swój lokalny komputer.
* Anonimizacja: Przygotuj skrypty, które zastępują prawdziwe nazwiska, maile i telefony losowymi danymi (faker).
* Logi: Filtruj logi aplikacji tak, by nie zapisywały haseł, numerów kart kredytowych ani PESEL-i.
* Usuwanie: Implementuj mechanizm "prawo do bycia zapomnianym" tak, by realnie usuwać lub nieodwracalnie anonimizować dane.

## /cors-policy – Bezpieczna polityka współdzielenia zasobów

* Restrykcje: Nie ustawiaj nagłówka Access-Control-Allow-Origin: * na produkcji.
* White-list: Dokładnie zdefiniuj domeny, które mogą pytać Twoje API o dane.
* Bezpieczeństwo: CORS chroni użytkowników Twojej aplikacji przed atakami z poziomu innych, złośliwych stron internetowych.
* Metody: Kontroluj nie tylko domeny, ale też dozwolone metody HTTP (np. zablokuj PUT/DELETE dla zewnętrznych domen).

## /encryption-at-rest-in-transit – Szyfrowanie na każdym etapie

* In transit: Cały ruch sieciowy musi iść przez HTTPS/TLS. Zapomnij o czystym HTTP nawet w sieci wewnętrznej.
* At rest: Włącz szyfrowanie dysków w chmurskich bazach danych (AWS RDS, S3) jednym kliknięciem.
* Hasła: Hasła użytkowników zapisuj wyłącznie przy użyciu silnych funkcji skrótu z solą (np. bcrypt, Argon2).
* Klucze: Dbaj o rotację kluczy szyfrujących zgodnie z polityką bezpieczeństwa firmy.

## /security-headers – Nagłówki HTTP podkręcające bezpieczeństwo

* Konfiguracja: Skonfiguruj serwer (Nginx, Cloudflare) tak, by zwracał nagłówki zwiększające bezpieczeństwo przeglądarki.
* Content Security Policy (CSP): Określ, z jakich źródeł przeglądarka może ładować skrypty i style (blokada XSS).
* HSTS: Wymuszaj na przeglądarkach łączenie się wyłącznie przez bezpieczny protokół HTTPS.
* Inne: Używaj X-Frame-Options: DENY, aby zabezpieczyć stronę przed atakami typu Clickjacking.

## /audit-log – Niezmienny rejestr zdarzeń bezpieczeństwa

* Cel: Zapisuj każdą istotną akcję w systemie (zmiana uprawnień, eksport danych, logowanie admina).
* Kontekst: Kto, kiedy, z jakiego IP i co dokładnie zrobił (wartość przed i po zmianie).
* Niezmienność: Logi audytowe powinny być zapisywane do bazy typu append-only, gdzie nikt (nawet admin) nie może ich edytować.
* Analiza: Skonfiguruj alerty na nietypowe zachowania, np. eksport 10 000 klientów do CSV w ciągu 5 sekund.

------------------------------
## 🤖 CYKL 8: PRACA Z AI I GENERATIVE AI (AI COLLABORATION)## /ai-context-window – Zarządzanie kontekstem w rozmowie z modelem

* Higiena: Nie wklejaj całego projektu do chatu – podawaj tylko pliki kluczowe dla danego problemu.
* Czyszczenie: Regularnie otwieraj nowe okna chatu, gdy zmieniasz temat, by stary kontekst nie mylił AI.
* Struktura: Podawaj dane w jasnej strukturze (np. używając tagów XML: <kod>...</kod>).
* Tokeny: Pamiętaj, że im większy kontekst, tym model staje się droższy i częściej gubi szczegóły (needle in a haystack).

## /prompt-engineering-system – Rola promptów systemowych

* Definicja: Używaj ukrytych promptów systemowych (System Prompts) do zdefiniowania sztywnych reguł gry dla AI.
* Format: Narzuć modelowi rolę (np. "Jesteś rygorystycznym seniorem architektem z 10-letnim doświadczeniem w Rust").
* Ograniczenia: Zabroń modelowi używania deprecated bibliotek lub pisania komentarzy w kodzie.
* Powtarzalność: Dobrze napisany prompt systemowy gwarantuje, że AI zachowa ten sam styl odpowiedzi w całym zespole.

## /ai-hallucination-defense – Obrona przed halucynacjami modeli

* Zaufanie: Załóż, że każda linijka kodu wygenerowana przez AI może zawierać subtelny, trudny do zauważenia błąd.
* Weryfikacja: Zawsze kompiluj i uruchamiaj testy dla kodu dostarczonego przez model.
* Biblioteki: Sprawdzaj, czy biblioteki i funkcje, które poleca AI, realnie istnieją (AI lubi zmyślać pakiety npm).
* Pytania pomocnicze: Zapytaj model: "Jakie są słabe punkty rozwiązania, które przed chwilą zaproponowałeś?".

## /few-shot-prompting – Uczenie modelu przez przykłady

* Zasada: Zamiast opisywać słowami, jaki kod chcesz dostać, daj modelowi 2-3 przykłady wejścia i idealnego wyjścia.
* Skuteczność: To drastycznie podnosi jakość generowanego kodu, zwłaszcza przy trudnych transformacjach danych.
* Szablon: Trzymaj gotowe zestawy przykładów (tzw. "few-shot exemplars") w plikach konfiguracyjnych dla zespołu.
* Zastosowanie: Idealne do pisania parserów, testów jednostkowych lub generowania dokumentacji w określonym formacie.

## /ai-assisted-refactoring – Refaktoryzacja z pomocą sztucznej inteligencji

* Zakres: Dawaj AI do poprawy małe funkcje (do 50 linii kodu), pytając o czytelność i wydajność.
* Instrukcja: Używaj promptu: "Zoptymalizuj ten kod pod kątem złożoności obliczeniowej, zachowując jego publiczne API".
* Kontrola: Przed akceptacją zmian wygenerowanych przez AI zrób dokładne code review (diff) linijka po linijce.
* Balans: AI świetnie radzi sobie z upraszczaniem pętli, ale może popsuć architekturę całego modułu.

## /ai-test-generation – Automatyczne pisanie testów przez model

* Szybkość: Używaj AI do pisania powtarzalnych testów jednostkowych dla czystych funkcji logicznych.
* Brzegowe przypadki: Poproś model: "Wygeneruj przypadki testowe dla wartości pustych, ekstremalnych i błędnych danych wejściowych".
* Weryfikacja: Upewnij się, czy testy napisane przez AI realnie coś sprawdzają, czy tylko dążą do zielonego koloru (patrz /review).
* Oszczędność: Pozwala zaoszczędzić mnóstwo czasu na pisaniu tzw. boilerplate code w testach.

## /ai-documentation-agent – Tworzenie dokumentacji z kodu

* Automatyzacja: Przekaż AI poprawnie działający kod i poproś o wygenerowanie komentarzy JSDoc/Docstring.
* README: AI potrafi świetnie napisać instrukcję instalacji projektu na podstawie plików konfiguracyjnych (np. package.json).
* Utrzymanie: Generuj dokumentację na bieżąco, by nie odkładać tego nudnego zadania na koniec projektu.
* Format: Wymuszaj format Markdown z czytelnymi tabelami i listami.

## /rag-architecture – Budowa wewnętrznej bazy wiedzy dla AI (RAG)

* Definicja: Retrieval-Augmented Generation – podpinanie prywatnych dokumentów firmy pod modele językowe.
* Zastosowanie: Pozwól nowym pracownikom pytać bocznego bota o wewnętrzne procedury, architekturę i polityki firmy.
* Aktualność: Dbaj o to, by pliki zasilające bazę wektorową RAG były na bieżąco aktualizowane przy zmianach w projektach.
* Prywatność: Upewnij się, że dane przesyłane do systemu RAG nie są wykorzystywane do trenowania publicznych modeli.

## /agentic-workflows – Autonomiczne agenty w pracy dewelopera

* Ewolucja: Przejdź od prostego chatu do agentów AI, które potrafią same planować pracę, pisać kod i go testować.
* Pętla: Agent pisze kod -> uruchamia testy -> czyta błędy -> poprawia kod aż do skutku.
* Nadzór: Określaj jasne punkty kontrolne, w których człowiek musi zatwierdzić kolejny krok agenta.
* Zastosowanie: Idealne do automatycznego fixowania prostych bugów zgłaszanych przez systemy monitoringu.

## /ai-governance – Zasady korzystania z AI w zespole inżynierskim

* Polityka: Ustal jasne zasady, z jakich narzędzi AI (Copilot, ChatGPT, Claude) zespół może korzystać.
* Własność intelektualna: Upewnij się, że licencje narzędzi gwarantują, iż Twój kod biznesowy nie wycieknie do sieci.
* Odpowiedzialność: Za każdy błąd na produkcji odpowiada człowiek, który zaakceptował kod, a nie model AI, który go napisał.
* Szkolenia: Regularnie dzielcie się w zespole trikami i promptami, które realnie przyspieszają codzienną pracę.

------------------------------
## 🛠️ CYKL 9: EKOSYSTEM I NARZĘDZIA (TOOLING & INFRASTRUCTURE)## /docker-optimization – Odchudzanie i przyspieszanie kontenerów

* Multi-stage builds: Rozdziel etap budowania (kompilacji) od obrazu uruchomieniowego.
* Waga: Zmniejszaj wagę obrazów produkcyjnych przechodząc na dystrybucje typu Alpine lub Distroless.
* Warstwy: Układaj instrukcje w Dockerfile od najrzadziej zmieniających się (np. instalacja OS) do najczęstszych (kod).
* Bezpieczeństwo: Nigdy nie uruchamiaj procesów wewnątrz kontenera jako użytkownik root.

## /kubernetes-health – Kontrola kondycji aplikacji w klastrze

* Liveness Probe: Konfiguruj testy sprawdzające, czy aplikacja żyje. Jeśli padnie, K8s zrestartuje kontener.
* Readiness Probe: Sprawdzaj, czy aplikacja jest gotowa na przyjmowanie ruchu (np. czy połączyła się z bazą).
* Startup Probe: Używaj dla wolno wstających aplikacji, by K8s nie ubił ich w trakcie bootowania.
* Zasoby: Zawsze definiuj limity i żądania (requests/limits) dla procesora i pamięci RAM.

## /cdn-acceleration – Przerzucenie statyków bliżej użytkownika

* Odciążenie: Serwuj obrazki, skrypty JS i style CSS przez sieć CDN (np. Cloudflare, CloudFront), a nie z serwera aplikacji.
* Geografia: CDN przechowuje pliki na serwerach zlokalizowanych fizycznie blisko Twoich użytkowników.
* Koszty: Zmniejszasz zużycie transferu z głównego serwera, co drastycznie obniża rachunki za chmurę.
* Inwalidacja: Konfiguruj automatyczne czyszczenie cache CDN podczas każdego nowego wdrożenia aplikacji.

## /monorepo-vs-polyrepo – Strategia podziału repozytoriów

* Monorepo: Trzymaj wiele projektów/mikroserwisów w jednym repozytorium (używaj narzędzi typu Turborepo, Nx).
* Zalety: Łatwe współdzielenie kodu, jeden Pull Request dla zmian dotykających frontu i backu jednocześnie.
* Polyrepo: Osobne repozytorium dla każdej usługi – daje pełną autonomię zespołom, ale utrudnia refaktoryzację.
* Wybór: Wybieraj Monorepo, jeśli usługi są ze sobą mocno powiązane i rozwijane przez jeden produkt.

## /semantic-versioning – Automatyczne zarządzanie wersjami (SemVer)

* Format: Stosuj standard wersji MAJOR.MINOR.PATCH (np. 2.4.1).
* Reguły: MAJOR = breaking changes, MINOR = nowe funkcje kompatybilne wstecz, PATCH = bugfixy.
* Conventional Commits: Pisz wiadomości commitów według schematu (np. feat:, fix:).
* Automatyzacja: Używaj narzędzi (np. semantic-release) do automatycznego podbijania wersji i tworzenia changelogów na CI.

## /dependency-injection – Luźne powiązania w kodzie (DI)

* Zasada: Klasy nie powinny same tworzyć swoich zależności (np. new Database()).
* Wstrzykiwanie: Przekazuj zależności przez konstruktor lub argumenty funkcji.
* Testowalność: Dzięki DI możesz w łatwy sposób podmienić realną bazę danych na atrapę (Mock) w testach.
* Kontenery DI: W dużych projektach używaj gotowych frameworków zarządzających cyklem życia obiektów.

## /event-driven – Architektura oparta na zdarzeniach

* Asynchroniczność: Zamiast pytać inne usługi przez HTTP, wysyłaj zdarzenia do brokera wiadomości (Kafka, RabbitMQ).
* Luźne powiązanie: Usługa A informuje świat: "Zamówienie zostało złożone". Nie interesuje jej, kto na to odpowie.
* Skalowalność: Łatwo dodasz nowych konsumentów zdarzeń (np. moduł statystyk) bez modyfikacji głównego kodu.
* Gwarancje: Pamiętaj o obsłudze problemów sieciowych: przetwarzanie komunikatów przynajmniej raz (at-least-once).

## /idempotency – Zapewnienie jednokrotnego wykonania akcji

* Problem: Klient klika przycisk "Kup" dwa razy z powodu lagów sieciowych. Zapłaci podwójnie?
* Rozwiązanie: Generuj unikalny klucz idempotencji (UUID) na froncie i przesyłaj go w nagłówku żądania.
* Baza: Serwer zapisuje klucz i przy drugiej próbie z tym samym kluczem zwraca gotowy wynik z pierwszej transakcji.
* Zastosowanie: Krytyczne dla systemów płatności, wysyłki maili i operacji modyfikacji danych.

## /database-sharding – Horyzontalne dzielenie baz danych

* Problem: Jedna baza danych nie mieści się na największym dostępnym serwerze w chmurze.
* Rozwiązanie: Podziel dane na mniejsze części (shardy) i rozrzuć je na osobne serwery bazodanowe.
* Klucz: Wybierz mądry klucz podziału (Sharding Key), np. podział użytkowników według kraju lub ID klienta.
* Złożoność: Wprowadzaj sharding tylko w ostateczności – drastycznie utrudnia on robienie joinów i raportów.

## /serverless-runtime – Kiedy warto iść w funkcje bez serwerów

* Zalety: Płać tylko za realny czas wykonania kodu (co do milisekundy), zero kosztów utrzymania maszyn w idle.
* Skalowanie: Skaluje się automatycznie od zera do tysięcy zapytań na sekundę w kilka chwil.
* Cold start: Pamiętaj o problemie zimnego startu – pierwsze zapytanie po dłuższej przerwie może działać zauważalnie wolniej.
* Zastosowanie: Idealne do zadań uruchamianych rzadko lub nieregularnie: przetwarzanie obrazków, webhooks, cron-jobs.

------------------------------
## 🚨 CYKL 10: AWARYJNE I ZARZĄDZANIE KRYZYSOWE (INCIDENT MANAGEMENT)## /incident-commander – Jednoosobowe dowodzenie podczas awarii

* Rola: Wyznacz jedną osobę (Incident Commander), która zarządza gaszeniem pożaru.
* Zadanie: Ta osoba nie naprawia kodu – ona koordynuje pracę, deleguje zadania i zbiera informacje.
* Komunikacja: IC dba o to, by reszta firmy i klienci dostawali regularne aktualizacje o statusie.
* Autorytet: Decyzje IC podczas awarii są ostateczne i nie podlegają dyskusji.

## /isolate-incident – Odcinanie uszkodzonego modułu

* Triage: Zamiast wyłączać całą aplikację, zlokalizuj i odizoluj wadliwy element (np. mikroserwis rekomendacji).
* Graceful degradation: Wyłącz uszkodzoną funkcję i pozwól użytkownikom korzystać z reszty systemu.
* Błąd: Lepiej pokazać komunikat "Moduł chwilowo niedostępny" niż doprowadzić do crashu całego portalu.
* Ruch: Przepnij ruch sieciowy omijając uszkodzoną infrastrukturę.

## /status-page – Transparentna komunikacja z klientami

* Zaufanie: Prowadź niezależną stronę statusu (np. Statuspage.io) informującą o dostępności usług.
* Szczerość: Informuj o awariach zanim klienci zaczną masowo pisać do supportu.
* Automatyzacja: Podepnij pod stronę statusu kluczowe metryki monitoringu (np. uptime ping).
* Uczciwość: Po usunięciu awarii opublikuj krótkie podsumowanie z przeprosinami i planem naprawczym.

## /on-call-rotation – Zdrowe dyżury programistów

* Sprawiedliwość: Rotuj dyżury on-call (wsparcie po godzinach) wewnątrz całego zespołu technicznego.
* Wynagrodzenie: Dyżury muszą być dodatkowo płatne – szanuj prywatny czas swoich ludzi.
* Narzędzia: Używaj systemów rotacji i eskalacji (PagerDuty, Opsgenie), by budzić właściwe osoby.
* Odpoczynek: Osoba po ciężkiej nocy na dyżurze powinna mieć prawo do wolnego lub lżejszej pracy w ciągu dnia.

## /data-recovery-drill – Regularne ćwiczenia z odzyskiwania danych

* Teoria: Backup, którego nie próbowałeś przywrócić, traktuj tak, jakby nie istniał.
* Ćwiczenia: Raz na kwartał przeprowadź symulację: usuń testową bazę i spróbuj przywrócić ją z kopii zapasowej.
* Czas (RTO): Mierz, ile dokładnie minut zajmuje zespołowi pełne odzyskanie sprawności systemu.
* Utrata (RPO): Sprawdzaj, ile maksymalnie danych (z ilu minut/godzin) tracisz przy powrocie do backupu.

## /graceful-shutdown – Kulturalne wyłączanie aplikacji

* Zasada: Gdy serwer dostaje sygnał zamknięcia (SIGTERM), nie ubijaj go natychmiast.
* Dokończenie: Pozwól aplikacji dokończyć przetwarzanie trwających zapytań HTTP i transakcji bazodanowych.
* Blokada: Przestań przyjmować nowe zapytania, informując load balancer, że serwer schodzi z linii.
* Limit: Ustal maksymalny czas na kulturalne zamknięcie (np. 30 sekund), po czym zamknij proces (SIGKILL).

## /dead-letter-queue – Magazyn dla nieprzetworzonych wiadomości (DLQ)

* Zasada: Jeśli wiadomość z kolejki (np. RabbitMQ/Kafka) powoduje błąd, nie próbuj jej przetwarzać w nieskończoność.
* Przeniesienie: Po kilku nieudanych próbach przerzuć wadliwą wiadomość do specjalnej kolejki DLQ.
* Odblokowanie: Dzięki temu reszta poprawnych wiadomości płynie dalej bez przestojów.
* Analiza: Deweloper może na spokojnie przejrzeć wiadomości w DLQ, naprawić buga w kodzie i puścić je ponownie.

## /log-levels – Odpowiednie logowanie zdarzeń

* DEBUG: Szczegółowe informacje techniczne przydatne tylko podczas lokalnego programowania.
* INFO: Standardowe zdarzenia z życia aplikacji (np. "Użytkownik X założył konto").
* WARN: Nietypowa sytuacja, która nie psuje działania aplikacji, ale wymaga uwagi (np. wolne zapytanie).
* ERROR: Błąd, który przerwał wykonanie danej operacji (np. padło zewnętrzne API).
* FATAL: Krytyczna awaria ubijająca cały proces aplikacji (np. brak połączenia z główną bazą).

## /security-incident-response – Procedura na wypadek wycieku danych

* Plan: Przygotuj sztywny, zatwierdzony prawnie plan działań na wypadek włamania lub wycieku.
* Izolacja: Natychmiast zablokuj skompromitowane klucze, konta i odetnij zaatakowane serwery od sieci.
* Prawo: Pamiętaj o prawnym obowiązku zgłoszenia wycieku danych osobowych do urzędu (np. UODO) w ciągu 72h.
* Analiza śledcza: Zachuj logi i obrazy dysków do analizy, zanim zaczniesz instalować systemy od nowa.

## /redundancy-strategy – Strategia pełnej nadmiarowości

* No SPOF: Wyeliminuj Single Point of Failure – żaden pojedynczy element nie może położyć całego systemu.
* Multizone: Uruchamiaj aplikacje w co najmniej dwóch różnych strefach dostępności chmury (Availability Zones).
* Bazy danych: Utrzymuj repliki baz danych w trybie Hot-Standby gotowe do natychmiastowego przejęcia ruchu.
* Dostawcy: Dla absolutnie krytycznych systemów rozważ architekturę Multi-Cloud (np. AWS + Google Cloud).

------------------------------
## 👥 CYKL 11: LUDZIE, REKRUTACJA I PRZYWÓDZTWO (LEADERSHIP)## /onboarding-path – Efektywne wdrażanie nowego programisty

* Dzień 1: Nowa osoba musi pierwszego dnia uruchomić projekt lokalnie i zrobić mały deploy na produkcję (choćby zmianę tekstu).
* Buddy: Przypisz do nowego pracownika dedykowanego opiekuna (Buddy), który odpowiada na każde pytanie.
* Dokumentacja: Używaj procesu onboardingowego jako testu dla dokumentacji – niech nowy pracownik poprawia błędy w instrukcjach instalacji.
* Stopniowanie: Zaczynaj od prostych bugów, przechodząc stopniowo do dużych zadań architektonicznych.

## /1-on-1-meeting – Regularne rozmowy indywidualne

* Częstotliwość: Spotykaj się ze swoimi ludźmi sam na sam co dwa tygodnie na 30-45 minut.
* Temat: To nie jest status zadań z Jiry! Rozmawiaj o samopoczuciu, rozwoju kariery i problemach w zespole.
* Słuchanie: Menadżer na tym spotkaniu powinien mówić przez 20% czasu, a przez 80% słuchać.
* Notatki: Zapisuj ustalenia i wracaj do nich na kolejnym spotkaniu, by pokazać, że traktujesz pracownika poważnie.

## /psychological-safety – Bezpieczeństwo psychologiczne w zespole

* Definicja: Stan, w którym członkowie zespołu nie boją się przyznać do błędu, zadać "głupiego" pytania czy zgłosić ryzyka.
* Rola lidera: Przyznawaj się głośno do własnych pomyłek – to daje innym przyzwolenie na bycie ludźmi.
* Karalność: Całkowicie zakaż publicznego wyśmiewania lub szukania winnych awarii (patrz /post-mortem).
* Efekt: Zespoły o wysokim bezpieczeństwie psychologicznym dostarczają kod szybciej i robią mniej błędów.

## /career-ladder – Jasna ścieżka kariery w IT

* Transparentność: Stwórz matrycę kompetencji jasno opisującą wymagania na poziomy Junior, Mid, Senior, Staff.
* Dwie drogi: Daj ludziom wybór – awans na ścieżkę menadżerską (Lead/Manager) lub techniczną (Architekt/Staff).
* Konkret: Unikaj ogólników. Zamiast "musi pisać dobry kod" napisz "wdraża samodzielnie skomplikowane systemy rozproszone".
* Przegląd: Rób ewaluację celów i podwyżek regularnie raz lub dwa razy w roku, bez czekania aż pracownik sam poprosi.

## /code-review-culture – Zdrowa kultura sprawdzania kodu

* Empatia: Pamiętaj, że oceniasz kod, a nie człowieka. Używaj zwrotów "kod ma błąd", a nie "Ty zrobiłeś błąd".
* Komentarze: Zawsze tłumacz dlaczego sugerujesz zmianę, podpierając się standardami lub wydajnością.
* Pytania: Zamiast rozkazywać ("Zmień to na pętlę for"), zadawaj pytania ("Czy pętla for nie byłaby tu bardziej wydajna?").
* Chwalenie: Code review to świetne miejsce na pochwalenie kolegi za sprytne i eleganckie rozwiązanie problemu.

## /feedback-loop – Konstruktywne udzielanie informacji zwrotnej

* Na bieżąco: Nie czekaj z negatywnym feedbackiem do oceny rocznej – przekaż go od razu, najlepiej na najbliższym 1-on-1.
* Konkret: Używaj modelu SBI (Situation-Behavior-Impact). Opisz sytuację, zachowanie i jego wpływ na zespół.
* Prywatnie: Krytykuj zawsze w cztery oczy, chwal zawsze publicznie na forum zespołu.
* Dwustronność: Jako lider regularnie pytaj swój zespół: "Co mogę zrobić lepiej, żeby ułatwić Wam pracę?".

## /technical-interview – Nowoczesna rekrutacja bez akademickich bzdur

* Realizm: Zrezygnuj z kazania kandydatom odwracania drzew binarnych na tablicy (chyba że piszesz silnik bazy danych).
* Zadania: Skup się na rzeczach bliskich codziennej pracy – code review przygotowanego kodu, projektowanie systemu, luźna rozmowa techniczna.
* Komfort: Zadbaj o bezstresową atmosferę. Chcesz zobaczyć, jak kandydat pracuje na co dzień, a nie jak radzi sobie z paniką.
* Feedback: Wyślij każdemu odrzuconemu kandydatowi merytoryczne, konstruktywne uzasadnienie decyzji.

## /knowledge-sharing – Kultura dzielenia się wiedzą

* Tech-talks: Organizuj regularne (np. raz w miesiącu) wewnętrzne minikonferencje, gdzie programiści opowiadają o nowych technologiach.
* Dokumentacja: Nagradzaj pisanie dobrych artykułów w wewnętrznym wiki tak samo mocno, jak pisanie kodu.
* Warsztaty: Rób sesje wspólnego refaktoryzacji lub projektowania trudnych modułów dla całego zespołu.
* Zysk: Zapobiega powstawaniu silosów wiedzy i drastycznie przyspiesza rozwój młodszych stażem pracowników.

## /burnout-defense – Ochrona zespołu przed wypaleniem zawodowym

* Nadgodziny: Monitoruj czas pracy. Regularne nadgodziny to znak, że planowanie kuleje lub zespół jest za mały.
* Zmiana: Nie pozwól, by jeden programista siedział latami w tym samym nudnym module utrzymaniowym.
* Sygnały: Reaguj na nagłe zmiany zachowania – spadek zaangażowania, cynizm, drażliwość to pierwsze objawy wypalenia.
* Odłączenie: Zachęcaj do brania urlopów i całkowitego odcinania się od komunikatorów firmowych w dni wolne.

## /team-autonomy – Budowanie autonomicznych zespołów

* Cel: Dawaj zespołom wyzwania biznesowe i cele (np. OKR), a nie gotowe listy technicznych zadań do bezmyślnego przeklikania.
* Zaufanie: Pozwól zespołowi samemu wybrać narzędzia, architekturę i sposób implementacji rozwiązania.
* Odpowiedzialność: Autonomia wiąże się z odpowiedzialnością – zespół, który projektuje system, dba również o jego stabilność na produkcji.
* Mikrozarządzanie: Jako lider wyznaczaj kierunek i usuwaj przeszkody, ale trzymaj ręce z dala od codziennych mikrodecyzji.

------------------------------
Którą z tych komend lub taktyk wdrożysz w swoim zespole jako pierwszą? Możemy wygenerować konkretny szablon wdrożeniowy (np. wzór dokumentu ADR, konfigurację Git Hooks czy skrypt do anonimizacji danych).




