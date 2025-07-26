# cn-crud-app

`cn-crud-app` è un progetto didattico ma pensato per un impiego production-ready. L'obiettivo principale è mostrare come realizzare un'applicazione **Cloud Native** che implementa le classiche logiche CRUD mantenendo un design aderente ai principi **Microservices**, **Domain-Driven Design** (DDD) e **GRASP**.

## Obiettivi del progetto
- Esemplificare la creazione di servizi CRUD con un'architettura a microservizi
- Evidenziare come i pattern DDD e GRASP possono guidare la progettazione
- Fornire un punto di partenza per approfondimenti su applicazioni Cloud Native

## Struttura
La base di partenza del progetto è suddivisa in più servizi (o bounded context) che rappresentano domini distinti. Ogni servizio espone API RESTful per la gestione dei dati e può essere avviato in container Docker. È possibile estendere l'architettura aggiungendo nuovi contesti in maniera modulare.

## Prerequisiti
Assicurarsi di avere installato:
- [Docker](https://www.docker.com/) per il contenimento dei servizi
- [Docker Compose](https://docs.docker.com/compose/) per orchestrare i container
- Un moderno JDK (ad esempio [OpenJDK](https://openjdk.org/)) se si sviluppano microservizi in Java

## Avvio rapido
Di seguito un esempio generico dei passi necessari per avviare l'ambiente:

```bash
# Clonazione del repository
$ git clone <url-del-repository>
$ cd cn-crud-app

# Costruzione delle immagini e avvio dei container
$ docker compose up --build
```

Una volta avviati i servizi sarà possibile interagire con le relative API CRUD tramite HTTP.

## Contribuire
Ogni contributo è ben accetto! Per proposte di miglioramento o segnalazioni di bug è possibile aprire una issue o inviare una pull request.

## Licenza
Il progetto è distribuito con licenza [MIT](LICENSE).
