#cython: boundscheck=False
#cython: wraparound=False
##aaacython: noncheck=True

cimport pele.potentials._pele as _pele
from libcpp cimport bool as cbool

#===============================================================================
# shared pointer
#===============================================================================
cdef extern from "<memory>" namespace "std":
    cdef cppclass shared_ptr[T]:
        shared_ptr(T*)
        # Note: operator->, operator= are not supported

#===============================================================================
# mcpele::TakeStep
#===============================================================================

cdef extern from "mcpele/mc.h" namespace "mcpele":
    cdef cppclass cppTakeStep "mcpele::TakeStep"

cdef class _Cdef_TakeStep(object):
    """This class is the python interface for the c++ mcpele::TakeStep base class implementation
    """
    cdef cppTakeStep *thisptr
    
#===============================================================================
# mcpele::AcceptTest
#===============================================================================

cdef extern from "mcpele/mc.h" namespace "mcpele":
    cdef cppclass cppAcceptTest "mcpele::AcceptTest"
        
cdef class _Cdef_AcceptTest(object):
    """This class is the python interface for the c++ mcpele::AcceptTest base class implementation
    """
    cdef cppAcceptTest *thisptr
        
#===============================================================================
# mcpele::ConfTest
#===============================================================================

cdef extern from "mcpele/mc.h" namespace "mcpele":
    cdef cppclass cppConfTest "mcpele::ConfTest"

cdef class _Cdef_ConfTest(object):
    """This class is the python interface for the c++ mcpele::ConfTest base class implementation
    """
    cdef cppConfTest *thisptr

#===============================================================================
# mcpele::Action
#===============================================================================

cdef extern from "mcpele/mc.h" namespace "mcpele":
    cdef cppclass cppAction "mcpele::Action"
        
cdef class _Cdef_Action(object):
    """This class is the python interface for the c++ mcpele::Action base class implementation
    """
    cdef cppAction *thisptr

#===============================================================================
# mcpele::MC
#===============================================================================

cdef extern from "mcpele/mc.h" namespace "mcpele":
    cdef cppclass cppMC "mcpele::MC":
        cppMC(_pele.cBasePotential *, _pele.Array[double]&, double, double) except +
        void one_iteration() except +
        void run(size_t) except +
        void set_temperature(double) except +
        void set_stepsize(double) except +
        void add_action(shared_ptr[cppAction]) except +
        void add_accept_test( shared_ptr[cppAcceptTest]) except +
        void add_conf_test( shared_ptr[cppConfTest]) except +
        void set_takestep( shared_ptr[cppTakeStep]) except +
        void set_coordinates(_pele.Array[double]&, double) except +
        double get_energy() except +
        _pele.Array[double] get_coords() except +
        double get_accepted_fraction() except +
        size_t get_iterations_count() except +
        double get_conf_rejection_fraction() except +
        size_t get_neval() except +
        double get_stepsize() except +

cdef class _Cdef_BaseMC(object):
    """This class is the python interface for the c++ mcpele::MC base class implementation
    """
    cdef cppMC* thisptr 