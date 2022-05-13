# advtr-clr(1)

> Please note this is a `proof of concept` for turning the tidy themes into `.clr` files for use in Sketch, Keynote, e.t.c.

### SYNOPSIS

```shell
    $ advtr-clr --file <filePath> --output <output>
```

### DESCRIPTION

Create a new [`NSColorList`](https://developer.apple.com/documentation/appkit/nscolorlist?language=objc) from a JSON fie that
conforms to a theme scheme.

#### Note

Currently, there is no protection/sanitisation of the arguments, so if invalid options are passed the program may still
run, just not w/ the desired effect. Changes could be major, so make sure if this is being used, versions are set properly

### Building

> Please note that the empty `./bin` dir is the desired output for the executable, so passing a `--build` argument
> is required, or the executable will be in the wrong place 
> 
> - Fix the implementation of this

```shell
    $ cmake --build <build-dir>
```