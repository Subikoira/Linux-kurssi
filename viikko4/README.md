
# Viikko 4: Palvelimen kloonaus, varmuuskopiot ja tietokannan replikointi

Server A (primary): http://195.148.21.71/viikko2/
Server B (replica, vain luku): http://128.214.254.158/viikko4/

## Tiedostot

- `crontab_B.txt`: Server B:n rootin cron-rivi. Hakee A:n `/var/www/html` tunnin välein rsyncillä aikaleimattuun kansioon `/var/backups/viikko4/`. `flock` estää päällekkäiset ajot.
- `60-replication_B.cnf`: B:n MariaDB-replikaasetukset (`server_id = 2`, `read_only = ON`).
- `../app.py`: sisältää vain lukevan reitin `/viikko4/`, joka ei kasvata laskuria.
- `../templates/viikko4.html`: B:n sivu ja dokumentaatio.

## Toteutus lyhyesti

1. B luotiin cPoudan snapshotista A:sta ja sille liitettiin oma Floating IP.
2. A on MariaDB:n primary (`server_id = 1`, binlog, ROW). B on replica ja lukee A:n muutokset sisäverkon kautta.
3. Tiedostot kopioidaan A:lta B:lle rsyncillä SSH:n yli (pull-malli) omalla synkronointiavaimella.
4. Varmuuskopiot ovat B:llä kansiossa, johon vain root pääsee, ei web-kansiossa.

## Ei repossa

Salasanat, yksityiset avaimet, SQL-dumpit ja varmuuskopioarkistot on tarkoituksella jätetty pois.

