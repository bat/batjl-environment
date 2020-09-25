# This software is licensed under the MIT License (MIT).

import Pkg

replace_default_sysimg = "--replace-default" in ARGS

srcdir = @__DIR__

if replace_default_sysimg
    juliadir = dirname(Sys.BINDIR)

    # Store packages in system location, typically "/path/to/julia/local/share/julia":
    if any(s -> startswith(s, juliadir), DEPOT_PATH)
        filter!(s -> startswith(s, juliadir), DEPOT_PATH)
    end

    # Restrict load path to stdlib and current project:
    if any(s -> s == "@stdlib", LOAD_PATH)
        filter!(s -> s == "@stdlib", LOAD_PATH)
        pushfirst!(LOAD_PATH, "@")
    end

    sysprjdir = joinpath(first(DEPOT_PATH), "environments", "v$(VERSION.major).$(VERSION.minor)")
    mkpath(sysprjdir)
    cp(joinpath(srcdir, "Project.toml"), joinpath(sysprjdir, "Project.toml"), force = true)
    if ispath(joinpath(srcdir, "Manifest.toml"))
        cp(joinpath(srcdir, "Manifest.toml"), joinpath(sysprjdir, "Manifest.toml"), force = true)
    end

    Pkg.activate(sysprjdir)

    # IJulia should always be part of custom default system image
    Pkg.add("IJulia", preserve = Pkg.PRESERVE_ALL)

    # Need to have PackageCompiler installed
    Pkg.add("PackageCompiler", preserve = Pkg.PRESERVE_ALL)
else
    Pkg.activate(srcdir)
end

prj_file = Pkg.project().path
prj_dir = dirname(prj_file)

@info("Building custom system image in project \"$prj_dir\".")

@info("Instantiating project.")
Pkg.instantiate()

@info("Precompiling packages.")
Pkg.precompile()


prj_sysimage = get(Pkg.TOML.parsefile(prj_file), "sysimage", Dict{String,Any}())
sysimg_pkgs = sort(collect(keys(filter(x -> Bool(x[2]), prj_sysimage))))
@info("Package to include in system image: $(join(sysimg_pkgs, " "))")

@info("Building system image.")

import PackageCompiler, Libdl

sysimage_path = replace_default_sysimg ? nothing : joinpath(srcdir, "JuliaSysimage." * Libdl.dlext)

PackageCompiler.create_sysimage(
    Symbol.(sysimg_pkgs),
    sysimage_path = sysimage_path,
    precompile_execution_file = joinpath(srcdir, "precompile_exec.jl"),
    cpu_target = PackageCompiler.default_app_cpu_target(),
    replace_default = replace_default_sysimg
)

if replace_default_sysimg
    @info("Replaced default Julia system image.")
else
    @info("Created custom Julia system image \"$sysimage_path\".")
end
