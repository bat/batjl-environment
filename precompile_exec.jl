@info "Starting precompile exec."

using BAT, Distributions, ValueShapes, LinearAlgebra, TypedTables, ForwardDiff, Zygote

bat_sample(MvNormal(float(I(4))), (10^4, 4), AHMC())

prior = NamedTupleDist(
    a = Normal(),
    b = Exponential(),
    c = Uniform(),
    d = MvNormal(float(I(2))),
)

likelihood = MvNormal(float(I(totalndof(varshape(prior)))))

ForwardDiff.gradient(x -> logpdf(likelihood, x), rand(likelihood))
Zygote.gradient(x -> logpdf(likelihood, x), rand(likelihood))

posterior = PosteriorDensity(likelihood, prior)

samples = bat_sample(posterior, (10^4, 4), MetropolisHastings()).result

bat_findmode(posterior, MaxDensityNelderMead())
bat_findmode(posterior, MaxDensityLBFGS())
bat_integrate(samples)

SampledDensity(posterior, samples)
Table(samples)

@info "Precompile exec finished."
