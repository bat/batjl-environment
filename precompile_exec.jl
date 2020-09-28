@info "Starting precompile exec."

using BAT, Distributions, LinearAlgebra

bat_sample(MvNormal(float(I(4))), (10^4, 4), MetropolisHastings())

@info "Precompile exec finished."
