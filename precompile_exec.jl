@info "Starting precompile exec."

using BAT, ValueShapes, Distributions, LinearAlgebra, Plots
import Cuba

primary_dist = NamedTupleDist(a = Normal(), b = Weibull(), c = 5)
f_secondary = x -> NamedTupleDist(y = Normal(x.a, x.b), z = MvNormal([1.3 0.5; 0.5 2.2]))
density = PosteriorDensity(MvNormal(Diagonal(fill(1.0, 5))), HierarchicalDistribution(f_secondary, primary_dist))

samples_mh = bat_sample(density, MCMCSampling(mcalg = MetropolisHastings(), nchains = 4, nsteps = 10^4, strict = false)).result

samples_hmc = bat_sample(density, MCMCSampling(mcalg = HamiltonianMC(), nchains = 4, nsteps = 10^4, strict = false)).result
@show sd = SampledDensity(density, samples_hmc)
@show ess = bat_eff_sample_size(samples_hmc)

integral_ahmi = bat_integrate(samples_hmc, AHMIntegration()).result
integral_vegas = bat_integrate(density, VEGASIntegration(strict = false)).result

@info "Precompile exec finished."
