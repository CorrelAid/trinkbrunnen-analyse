Trinkwasser Analyse (tiptap: https://atiptap.org/)
================

# What is this project about?

## General

Analysis of Open Street Maps (OSM) data regarding drinking fountains in Germany.

* For cities get the number of listed drinking points per 1000 inhabitants
* Some cities provided official numbers of drinking fountains which can be compared
to listed data in OSM
* Analyse quality of meta data of the received points by comparing it with 
defined mandatory information

## Quality of Meta Data (German)

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

## `renv`: Installing Packages

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

    renv::restore()
    This project has not yet been activated. Activating this project will ensure the project library is used during restore. Please see ?renv::activate for more details. Would you like to activate this project before restore? [Y/n]:

Follow along with `Y` and `renv::restore()` will do its work downloading
and installing all dependencies. `renv` uses a local `.Rprofile` and
`renv/activate.R` script to handle our project dependencies.

### Adding a new package

If you need to add a new package, you can install it as usual
(`install.packages` etc.). Then, to add your package to the `renv.lock`:

    renv::snapshot()

and commit and push your `renv.lock`.

Other team members can then run `renv::restore()` to install the added
package(s) on their laptop.

## Data

You need the following data files in order to run this project:

``` r
system2("tree", c("data/raw")) # works on mac and potentially linux. 
```

# Developer information

\[the following can also be moved to the wiki if you decide to have
one\]

## Definition of Done

Default Definition of Done can be found
[here](https://github.com/CorrelAid/definition-of-done). Adapt if
needed.

## Code styling

# How to operate this project?

\[the following can also be moved to the wiki if you decide to have
one\]

explain how the output(s) of this project can be handled/operated, for
example:

-   how to knit the report(s)
-   where to create/find the data visualizations
-   how to update data
-   what would need to be updated if someone wanted to re-run your
    analysis with different data

# Limitations

be honest about the limitations of your project, e.g.:

-   methodological: maybe another model would be more suitable?
-   reproducibility: what are limits of reproducibility? is there
    something hard-coded/specific to the data that you used?
-   best practices: maybe some code is particularly messy and people
    working on it in the future should know about it in advance?
