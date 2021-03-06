# distutils: language = c++
# distutils: sources = actions.cpp

cimport cython
cimport numpy as np

import numpy as np
import sys

#===============================================================================
# Adjust step size
#===============================================================================
        
cdef class _Cdef_AdjustStep(_Cdef_Action):
    """This class is the python interface for the c++ pele::AdjustStep action class implementation
    """
    cdef cppAdjustStep* newptr
    def __cinit__(self, target, factor, niter, navg):
        self.thisptr = shared_ptr[cppAction](<cppAction*> new cppAdjustStep(target, factor, niter, navg))
        self.newptr = <cppAdjustStep*> self.thisptr.get()
        
class AdjustStep(_Cdef_AdjustStep):
    """This class is the python interface for the c++ AdjustStep implementation.
    """

#===============================================================================
# Record Energy Histogram
#===============================================================================        

cdef class _Cdef_RecordEnergyHistogram(_Cdef_Action):
    """This class is the python interface for the c++ pele::RecordEnergyHistogram acceptance test class implementation
    """
    cdef cppRecordEnergyHistogram* newptr
    def __cinit__(self, min, max, bin, eqsteps):
        self.thisptr = shared_ptr[cppAction](<cppAction*> new cppRecordEnergyHistogram(min, max, bin, eqsteps))
        self.newptr = <cppRecordEnergyHistogram*> self.thisptr.get()
    
    @cython.boundscheck(False)
    @cython.wraparound(False)
    def get_histogram(self):
        """return a histogram array"""
        cdef _pele.Array[double] histi = self.newptr.get_histogram()
        cdef double *histdata = histi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] hist = np.zeros(histi.size())
        cdef size_t i
        for i in xrange(histi.size()):
            hist[i] = histdata[i]
              
        return hist
        
    def print_terminal(self, ntot):
        self.newptr.print_terminal(ntot)
    
    def get_bounds_val(self):
        Emin = self.newptr.get_min()
        Emax = self.newptr.get_max()
        return Emin, Emax
    
    def get_mean_variance(self):
        mean = self.newptr.get_mean()
        variance = self.newptr.get_variance()
        return mean, variance
        
class RecordEnergyHistogram(_Cdef_RecordEnergyHistogram):
    """This class is the python interface for the c++ RecordEnergyHistogram implementation.
    """

#===============================================================================
# Record Pair Distances Histogram
#===============================================================================
cdef class  _Cdef_RecordPairDistHistogram(_Cdef_Action):
    """This class is the python interface for the c++ mcpele::RecordPairDistHistogram implementation
    """
    cdef cppRecordPairDistHistogram[INT2]* newptr2
    cdef cppRecordPairDistHistogram[INT3]* newptr3
    def __cinit__(self, boxvec, nr_bins, eqsteps, record_every):
        ndim = len(boxvec)
        assert(ndim == 2 or ndim == 3)
        assert(len(boxvec)==ndim)
        cdef np.ndarray[double, ndim=1] bv
        if ndim == 2:
            bv = np.array(boxvec, dtype=float)
            self.thisptr = shared_ptr[cppAction](<cppAction*> new cppRecordPairDistHistogram[INT2](_pele.Array[double](<double*> bv.data, bv.size), nr_bins, eqsteps, record_every))
            self.newptr2 = <cppRecordPairDistHistogram[INT2]*> self.thisptr.get()
        else:
            bv = np.array(boxvec, dtype=float)
            self.thisptr = shared_ptr[cppAction](<cppAction*> new cppRecordPairDistHistogram[INT3](_pele.Array[double](<double*> bv.data, bv.size), nr_bins, eqsteps, record_every))
            self.newptr3 = <cppRecordPairDistHistogram[INT3]*> self.thisptr.get()
        self.ndim = ndim
    def get_hist_r(self):
        """return array of r values for g(r) measurement"""
        cdef _pele.Array[double] histi
        if self.ndim == 2:
            histi = self.newptr2.get_hist_r()
        elif self.ndim == 3:
            histi = self.newptr3.get_hist_r()        
        cdef double *histdata = histi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] hist = np.zeros(histi.size())
        cdef size_t i
        for i in xrange(histi.size()):
            hist[i] = histdata[i]      
        return hist
    def get_hist_gr(self, number_density, nr_particles):
        """return array of g(r) values for g(r) measurement"""
        cdef _pele.Array[double] histi
        if self.ndim == 2:
            histi = self.newptr2.get_hist_gr(number_density, nr_particles)
        elif self.ndim == 3:
            histi = self.newptr3.get_hist_gr(number_density, nr_particles)        
        cdef double *histdata = histi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] hist = np.zeros(histi.size())
        cdef size_t i
        for i in xrange(histi.size()):
            hist[i] = histdata[i]      
        return hist
    def get_eqsteps(self):
        if self.ndim == 2:
            return self.newptr2.get_eqsteps()
        elif self.ndim == 3:
            return self.newptr3.get_eqsteps()
        else:
            raise Exception("_Cdef_RecordPairDistHistogram: boxdim fail")

class RecordPairDistHistogram(_Cdef_RecordPairDistHistogram):
    """This class is the python interface for the c++ RecordPairDistHistogram implementation.
    """
    
#===============================================================================
# RecordEnergyTimeseries
#===============================================================================
        
cdef class _Cdef_RecordEnergyTimeseries(_Cdef_Action):
    """This class is the python interface for the c++ bv::RecordEnergyTimeseries action class implementation
    """
    cdef cppRecordEnergyTimeseries* newptr
    def __cinit__(self, niter, record_every):
        self.thisptr = shared_ptr[cppAction](<cppAction*> new cppRecordEnergyTimeseries(niter, record_every))
        self.newptr = <cppRecordEnergyTimeseries*> self.thisptr.get()
        
    @cython.boundscheck(False)
    @cython.wraparound(False)
    def get_time_series(self):
        """return a energy time series array"""
        cdef _pele.Array[double] seriesi = self.newptr.get_time_series()
        cdef double *seriesdata = seriesi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] series = np.zeros(seriesi.size())
        cdef size_t i
        for i in xrange(seriesi.size()):
            series[i] = seriesdata[i]
              
        return series
    
    def clear(self):
        """clears time series"""
        self.newptr.clear()
    
class RecordEnergyTimeseries(_Cdef_RecordEnergyTimeseries):
    """This class is the python interface for the c++ RecordEnergyTimeseries implementation.
    """
    
#===============================================================================
# RecordLowestEValueTimeseries
#===============================================================================
        
cdef class _Cdef_RecordLowestEValueTimeseries(_Cdef_Action):
    """This class is the python interface for the c++ RecordLowestEValueTimeseries action class implementation
    """
    cdef cppRecordLowestEValueTimeseries* newptr
    cdef ranvec
    def __cinit__(self, niter, record_every, _pele.BasePotential landscape_potential, boxdimension,
                  ranvec, lbfgsniter):
        cdef np.ndarray[double, ndim=1] ranvecc = ranvec
        self.thisptr = shared_ptr[cppAction](<cppAction*> new 
                 cppRecordLowestEValueTimeseries(niter, record_every,
                                                     landscape_potential.thisptr, boxdimension,
                                                     _pele.Array[double](<double*> ranvecc.data, ranvecc.size), lbfgsniter))
        self.newptr = <cppRecordLowestEValueTimeseries*> self.thisptr.get()
        
    @cython.boundscheck(False)
    @cython.wraparound(False)
    def get_time_series(self):
        """return a lowest eigenvalue time series array"""
        cdef _pele.Array[double] seriesi = self.newptr.get_time_series()
        cdef double *seriesdata = seriesi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] series = np.zeros(seriesi.size())
        cdef size_t i
        for i in xrange(seriesi.size()):
            series[i] = seriesdata[i]
              
        return series
    
    def clear(self):
        """clears time series"""
        self.newptr.clear()
    
class RecordLowestEValueTimeseries(_Cdef_RecordLowestEValueTimeseries):
    """This class is the python interface for the c++ RecordLowestEValueTimeseries implementation.
    """
    
#===============================================================================
# RecordDisplacementPerParticleTimeseries
#===============================================================================
        
cdef class _Cdef_RecordDisplacementPerParticleTimeseries(_Cdef_Action):
    """This class is the python interface for the c++ RecordDisplacementPerParticleTimeseries action class implementation
    """
    cdef cppRecordDisplacementPerParticleTimeseries* newptr
    cdef initial
    def __cinit__(self, niter, record_every, initial, boxdimension):
        cdef np.ndarray[double, ndim=1] initialc = initial
        self.thisptr = shared_ptr[cppAction](<cppAction*> new 
                 cppRecordDisplacementPerParticleTimeseries(niter, record_every,
                                                            _pele.Array[double](<double*> initialc.data, initialc.size), 
                                                            boxdimension))
        self.newptr = <cppRecordDisplacementPerParticleTimeseries*> self.thisptr.get()
        
    @cython.boundscheck(False)
    @cython.wraparound(False)
    def get_time_series(self):
        """return a mean rsm time series array"""
        cdef _pele.Array[double] seriesi = self.newptr.get_time_series()
        cdef double *seriesdata = seriesi.data()
        cdef np.ndarray[double, ndim=1, mode="c"] series = np.zeros(seriesi.size())
        cdef size_t i
        for i in xrange(seriesi.size()):
            series[i] = seriesdata[i]
              
        return series
    
    def clear(self):
        """clears time series"""
        self.newptr.clear()
    
class RecordDisplacementPerParticleTimeseries(_Cdef_RecordDisplacementPerParticleTimeseries):
    """This class is the python interface for the c++ RecordDisplacementPerParticleTimeseries implementation.
    """
