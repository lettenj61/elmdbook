# elmdbook

A [mdBook][mdbook] theme with:

* [Bulma][bulma] for styles.
* [Elm][elm] for widgets.


## Development

### Prerequisite

1.  Install [Node.js][nodejs] (I use `v14.2.0`)
2.  Install [Yarn][yarnpkg] (I use `v1.22.4`)
3.  Install [mdBook][mdbook] to start development server

### Build

Clone this repository:

```sh
$ git clone https://github.com/lettenj61/elmdbook.git
```

Install dependencies:

```sh
$ yarn
```

Build assets:

```sh
$ yarn build
```

Start development server:

```sh
# Make sure you have built assets, then
$ cd <your-path-to-repo>/example
$ mdbook serve
```


## License

MIT.

See [LICENSE](./LICENSE)




[mdbook]: https://github.com/rust-lang/mdBook
[bulma]: https://bulma.io/
[elm]: https://elm-lang.org/
[nodejs]: https://nodejs.org/
[yarnpkg]: https://yarnpkg.com/