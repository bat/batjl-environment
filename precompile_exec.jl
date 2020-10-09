@info "Starting precompile exec."

using BAT, Distributions, LinearAlgebra

bat_sample(MvNormal(float(I(4))), 10^4, MCMCSampling(sampler = MetropolisHastings()))

@info "Precompile exec finished."
