# Ready-to-run Julia environment with BAT.jl

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/bat/batjl-environment/master)

This is a ready-made environment for [BAT.jl](https://github.com/bat/BAT.jl),
a  Bayesian analysis toolkit
in Julia. To learn more about BAT, see it's [documentation](https://bat.github.io/BAT.jl/dev/).

This repository defines a [Julia environment](https://docs.julialang.org/en/v1/manual/code-loading/#Project-environments-1) via a [Project.toml and Manifest.toml]((https://julialang.github.io/Pkg.jl/v1/toml-files/)) file.
The environment includes BAT.jl, as well as a set of Julia packages often used
in conjunction with BAT.

The environment defined here currently provides a BAT v2.0.0-DEV pre-release
version.

Also included are the necessary configuration to make the environment available on [Binder](https://mybinder.readthedocs.io/en/latest/), see below.


## Running on Binder

To run the environment defined in this repository on Binder, simply point your web browser to
https://mybinder.org/v2/gh/bat/batjl-environment/master.

Binder [generates and caches](https://mybinder.readthedocs.io/en/latest/faq.html#what-factors-influence-how-long-it-takes-a-binder-session-to-start)
a Docker image for each repository it is used with. Installing and
pre-compiling all Julia packages in this environment, and generating a custom
Julia system image to ensure a rapid start afterwards, takes quite a long
time. Often, someone else will have run this repository on Binder already,
so everything will start quickly. However, if you're the first one opening
this repository on Binder since the last commit, don't be surprised if
startup takes a *very* long time.

After the Binder Jupyter instance is running, just open the tutorial notebook
"bat_tutorial.ipynb", or create your own Julia/BAT notebooks.

To run the tutorial, you can also head to
https://mybinder.org/v2/gh/bat/batjl-environment/master?filepath=bat_tutorial.ipynb directly.


## Local usage

You can also use this repository as a
[Julia environment](https://docs.julialang.org/en/v1/manual/code-loading/#Project-environments-1) on your local system (provided
[Julia is installed](https://julialang.org/downloads/)).

Run

```shell
julia \
    --project="/path/to/this/batjl-environment" \
    -e 'using Pkg; pkg"instantiate; precompile"'
```

https://docs.julialang.org/en/v1/manual/code-loading/#Project-environments-1

to instantiate the [Julia project environment](https://docs.julialang.org/en/v1/manual/code-loading/#Project-environments-1)
defined by the files "Project.toml" and "Manifest.toml". Afterwards, run

```shell
julia --project="/path/to/this/batjl-environment"
```

any time you want to use the environment.


### Custom Julia system image

BAT.jl and it's dependencies constitute a large code base, so using BAT for
the first time in a new Julia session takes a while. To reduce this startup
latency (due to package loading and code-generation time), you can build a
custom Julia system image via
[PackageCompiler.jl](https://julialang.github.io/PackageCompiler.jl/dev/).
Run

```shell
julia /path/to/batjl-environment/build_sysimage.jl
```

to build the system image and

```shell
julia --project="/path/to/this/batjl-environment" --sysimage="/path/to/batjl-environment/JuliaSysimage.so"
```

to use it. Note: The file name of the system image file is OS-dependent:
on Linux it is "JuliaSysimage.so", on OS-X it is "JuliaSysimage.dylib",
and on Windows it is "JuliaSysimage.dll".

If you activate this project/environment in the
[Julia plugin for Visual Studio Code](https://www.julia-vscode.org/),
you may want to enable the `"julia.useCustomSysimage"` option to
[use the custom system image automatically](https://www.julia-vscode.org/docs/stable/userguide/compilesysimage/).

On Binder, the custom system image will be generated automatically, and the
project environment and system image will automatically be active in Binder
Jupyter notebooks (though not if you start Julia on the command line in a
Jupyter shell).


## Generating the BAT example/tutorial files

Run

    julia --project="." --sysimage=JuliaSysimage.so make_examples.jl

to generate the BAT tutorial as a Jupyter notebook and Julia script. If you're
on Binder, the tutorial files will already be present.
