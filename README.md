Trinkwasser Analyse (tiptap: https://atiptap.org/)
================

# License
Code (from CorrelAid e.V.), data and map data (from OpenStreetMap) are licensed differently for this project. See `LICENSE` for details.

# Outputs

1. [Analysis of Open Street Maps (OSM) data](https://correlaid.github.io/trinkbrunnen-analyse/analysis-fountains-germany.html) regarding drinking fountains in Germany.

* For cities get the number of listed drinking points per 1000 inhabitants
* Some cities provided official numbers of drinking fountains which can be compared
to listed data in OSM
* Analyse quality of meta data of the received points by comparing it with 
defined mandatory information
[![Screenshot 2023-07-03 at 17 11 13](https://github.com/CorrelAid/trinkbrunnen-analyse/assets/13187448/8e2c69a7-5326-4325-966f-10781ae291f1)](https://correlaid.github.io/trinkbrunnen-analyse/analysis-fountains-germany.html)

2. [Map of drinking fountains in Germany](https://correlaid.github.io/trinkbrunnen-analyse/map-deutschland-drinking-water.html)

[![Screenshot 2023-07-03 at 17 11 30](https://github.com/CorrelAid/trinkbrunnen-analyse/assets/13187448/0bbf1ba3-2d8c-4088-aa3e-f63d5c4b450b)](https://correlaid.github.io/trinkbrunnen-analyse/map-deutschland-drinking-water.html)


# Quality of Meta Data (German)

Generelle beobachtbare Eigenschaften
[https://wiki.openstreetmap.org/wiki/Tag:amenity%3Ddrinking_water](https://wiki.openstreetmap.org/wiki/Tag:amenity%3Ddrinking_water) 

* Brunnentyp
	* [fountain=bubbler](https://wiki.openstreetmap.org/wiki/Tag:fountain%3Dbubbler) (Trinkbrunnen, die einen bogenförmigen Strahl ausstoßen)
	* [fountain=drinking](https://wiki.openstreetmap.org/wiki/Tag:fountain%3Ddrinking)  (allgemeiner Trinkwasserbrunnen)
	* [man_made=water_tap](https://wiki.openstreetmap.org/wiki/Tag:man_made%3Dwater_tap) (Wasserhahn mit Trinkwasser)
	* zusätzlich ist praktisch zu vermerken ob das Wasser nur über einen Brunnen läuft: [button_operated=yes/no](https://wiki.openstreetmap.org/wiki/Key:button_operated)
* Flasche auffüllbar: [bottle=(yes/no/limited)](https://wiki.openstreetmap.org/wiki/Key:bottle
* Barrierefreiheit: [wheelchair=(yes/no/limited)](https://wiki.openstreetmap.org/wiki/Key:wheelchair)
* Frei Zugänglich (also auf öffentlichen Gelände?): [access=(yes/no/private…)](https://wiki.openstreetmap.org/wiki/Key:access)
* Beschreibung oder Name -hier ist es sehr hilfreich wenn entweder in einer Beschreibung oder im Namen die Art des Trinkortes genannt wird (z.B. Trinkbrunnen).  Beschreibungen können unter verschiedenen Tags geführt sein. Namen sollen jedoch in der Regel nur vergeben werden, wenn das Objekt wirklich eine offizielle Bezeichnung hat - z.B. Löwenbrunnen 
	* [description=*](https://wiki.openstreetmap.org/wiki/Key:description)
		* description:[de](https://wiki.openstreetmap.org/w/index.php?title=Key:de&action=edit&redlink=1)=* (de=Deutsch)
		* description:[en](https://wiki.openstreetmap.org/w/index.php?title=Key:en&action=edit&redlink=1)=* (en=Englisch)
		* auch genutzte Tags, aber nicht ideal: comment
	* [name=*](https://wiki.openstreetmap.org/wiki/Key:name)
		* name:en
		* name:de

Sinnvolle Infos, die jedoch zusätzliches Wissen benötigen

* Betriebszeit (wann ist der brunnen in betrieb)
	* [seasonal=(yes/no/spring/summer…)](https://wiki.openstreetmap.org/wiki/Key:seasonal): drinking_water:seasonal=(yes/no/summer…)
	* [opening_hours](https://wiki.openstreetmap.org/wiki/Key:opening_hours)
	* [access:conditional=*](https://wiki.openstreetmap.org/wiki/Conditional_restrictions)
	* Betreiber: [operator](https://wiki.openstreetmap.org/wiki/Key:operator)=*
    
Weiter mögliche (nicht schlechte) Tags

* [fee=yes/no](https://wiki.openstreetmap.org/wiki/Key:fee)
* [drinking_water=yes/no](https://wiki.openstreetmap.org/wiki/Key:drinking_water) (zur zusätzlichen Versicherung ob es sich um Trinkwasser handelt bzw. als Anfügung zu z.B. Toiletten, wo es trinkwasser gibt, die ertse Funktion jedoch nicht Trinkwasser abzapfen ist)
* [check_ date](https://wiki.openstreetmap.org/wiki/Key:check_date) (wann wurde der Punkt zuletzt überprüft)
* indoor=yes/no

# Setup

## Package dependencies
### Set up R `renv`: Installing R Packages

`renv` brings project-local R dependency management to our project.
`renv` uses a lockfile (`renv.lock`) to capture the state of your
library at some point in time. Based on `renv.lock`, RStudio should
automatically recognize that it’s being needed, thereby downloading and
installing the appropriate version of `renv` into the project library.
After this has completed, you can then use `renv::restore()` to restore
the project library locally on your machine. When new packages are used,
`install.packages()` does not install packages globally, it does in an
environment only used for our project. You can find this library in
`renv/library` (but it should not be necessary to look at it). If `renv`
fails, you will be presented something in the like of when you first
start R after cloning the repo:

```
renv::restore()
    This project has not yet been activated. Activating this project will ensure the project library is used during restore. Please see ?renv::activate for more details. Would you like to activate this project before restore? [Y/n]:
```

Follow along with `Y` and `renv::restore()` will do its work downloading
and installing all dependencies. `renv` uses a local `.Rprofile` and
`renv/activate.R` script to handle our project dependencies.

#### Adding a new package

If you need to add a new package, you can install it as usual
(`install.packages` etc.). Then, to add your package to the `renv.lock`:

    renv::snapshot()

and commit and push your `renv.lock`.

Other team members can then run `renv::restore()` to install the added
package(s) on their laptop.

### Set up Python environment 

Python dependencies are managed in a virtualenv. You need to install [virtualenv](https://virtualenv.pypa.io/en/latest/installation.html) (it might also work with the built-in [`venv` subset](https://docs.python.org/3/library/venv.html)).

activate the virtual environment in the Terminal. 

```
source venv/bin/activate
```

install the packages in `rmd/map-fountains-germany.ipynb`  by:

```
pip3 install -r requirements.txt
```

## Data

### Helper data

You need the following data files in order to run this project:

```
data/raw
├── anzahl_brunnen.xlsx
└── staedte.xlsx
```

They are part of the repository.

## Data from OSM 

Data from OSM are under `data/processed`. They can be regenerated/updated by running `R/get_osm_data.R`.

# Generate outputs

Outputs are saved in the `docs` folder so that they can be accessible via GitHub Pages.

## Analysis
for the R Markdown analysis (`docs/deutschland-drinking-water.html` / [online analysis](https://correlaid.github.io/trinkbrunnen-analyse/analysis-fountains-germany.html)), run the following in the R console:

```
rmarkdown::render(here::here("rmd/analysis-fountains-germany.Rmd"), output_file = here::here("docs/analysis-fountains-germany.html"))
```

## Map
For the map (`docs/deutschland-drinking-water.html` / [online map](https://correlaid.github.io/trinkbrunnen-analyse/map-deutschland-drinking-water.html)), activate your Python environment (see above) and run in your terminal:

```
jupyter execute rmd/map-fountains-germany.ipynb
```

# Limitations

This was an adhoc one-off analysis for [atiptap e.V.](https://atiptap.org). Hence, styling was not the priority for this project. 
