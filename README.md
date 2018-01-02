# `geolocator`

`geolocator` is a tool for querying the [MaxMind GeoLite Legacy database](https://dev.maxmind.com/geoip/legacy/geolite/).
Currently it does a dumb linear search and takes quite long to retrieve locations for IP addresses.
It's quicker to search for multiple addresses at once since parsing the csv files takes quite a lot of time and has to
be done everytime geolocator is launched.
I wrote `geolocator` in 30 minutes for a university project.
It's slow and doesn't offer any options.

## Installation

### `opam` installation

Install using:
```
$ opam pin add geolocator git://github.com/Reperator/geolocator.git
```
`opam` should automatically install dependencies.

Uninstall using:
```
$ opam pin remove geolocator
```

### manual installation

Clone the repository and in the root directory run:
```
$ make
$ make install
```

You need to have the dependencies installed; one way to do this is:
```
$ opam install core csv jbuilder
```

Uninstall using:
```
$ make uninstall
```

## Usage

You need to download the
[GeoLite City csv database](http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity-latest.zip)
and point geolocator to the `GeoLiteCity-Blocks.csv` and `GeoLiteCity-Location.csv` database.
Do this by typing `geolocator` into a shell followed by the paths to those files.

```
$ geolocator -help
get coordinates for IP addresses

  geolocator BLOCKS LOCATION [ADDRESS ...]

=== flags ===

  [-build-info]  print info about this build and exit
  [-version]     print the version of this build and exit
  [-help]        print this help text and exit
                 (alias: -?)
```

### Example output

The output will look something like this:

```
$ geolocator $BLOCKSPATH $LOCATIONSPATH 1.2.3.4 5.6.7.8
addr:1.2.3.4 lat:3.1415 lon:3.1415
addr:5.6.7.8 lat:3.1415 lon:3.1415
```

## Internals

### Language

`geolocator` is written in OCaml.

### Dependencies

`geolocator` uses [core](https://github.com/janestreet/core) and [csv](https://github.com/Chris00/ocaml-csv).

## Future development

### Planned

I am not planning on working on `geolocator` very often.

### Uncertain

- Support for binary databases

- Support for more output formatting options

- Benchmarking

- Environment variables for database files

## License

`geolocator` is licensed under the LGPL 3.0. See `LICENSE`.
