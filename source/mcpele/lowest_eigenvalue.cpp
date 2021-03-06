#include <cmath>

#include "lowest_eigenvalue.h"

namespace mcpele{


FindLowestEigenvalue::FindLowestEigenvalue(std::shared_ptr<pele::BasePotential> landscape_potential, const size_t boxdimension,
        const pele::Array<double> ranvec, const size_t lbfgsniter)
    : _lowesteigpot(std::make_shared<pele::LowestEigPotential>(landscape_potential, ranvec.copy(), boxdimension)),
      _ranvec((ranvec.copy() /= norm(ranvec))),
      _lbfgs(_lowesteigpot, _ranvec.copy())
{
    if (isinf(double(1) / norm(ranvec))) {
        throw std::runtime_error("FindLowestEigenvalue: 1/norm(ranvec) is isinf");
    }
    _lbfgs.set_max_iter(lbfgsniter);
}

double FindLowestEigenvalue::compute_lowest_eigenvalue(pele::Array<double> coords)
{
    _lowesteigpot->reset_coords(coords);
    _lbfgs.reset(_ranvec);
    _lbfgs.set_use_relative_f(1);
    _lbfgs.run();
    const double lowesteig = _lbfgs.get_f();
    return lowesteig;
}


}//namespace mcpele
