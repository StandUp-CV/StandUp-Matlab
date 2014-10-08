//
// MATLAB Compiler: 4.18 (R2012b)
// Date: Sun Nov 25 17:08:45 2012
// Arguments: "-B" "macro_default" "-W" "cpplib:StandupDetector" "-T"
// "link:lib" "-d"
// "H:\Projekte\Git\standup_cv.2\matlab_project\StandupDetector\src" "-w"
// "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w"
// "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w"
// "enable:demo_license" "-g" "-G" "-v"
// "H:\Projekte\Git\standup_cv.2\matlab_project\@StandupDetector\StandupDetector
// .m" 
//

#ifndef __StandupDetector_h
#define __StandupDetector_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_StandupDetector
#define PUBLIC_StandupDetector_C_API __global
#else
#define PUBLIC_StandupDetector_C_API /* No import statement needed. */
#endif

#define LIB_StandupDetector_C_API PUBLIC_StandupDetector_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_StandupDetector
#define PUBLIC_StandupDetector_C_API __declspec(dllexport)
#else
#define PUBLIC_StandupDetector_C_API __declspec(dllimport)
#endif

#define LIB_StandupDetector_C_API PUBLIC_StandupDetector_C_API


#else

#define LIB_StandupDetector_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_StandupDetector_C_API 
#define LIB_StandupDetector_C_API /* No special import/export declaration */
#endif

extern LIB_StandupDetector_C_API 
bool MW_CALL_CONV StandupDetectorInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_StandupDetector_C_API 
bool MW_CALL_CONV StandupDetectorInitialize(void);

extern LIB_StandupDetector_C_API 
void MW_CALL_CONV StandupDetectorTerminate(void);



extern LIB_StandupDetector_C_API 
void MW_CALL_CONV StandupDetectorPrintStackTrace(void);

extern LIB_StandupDetector_C_API 
bool MW_CALL_CONV mlxStandupDetector(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_StandupDetector
#define PUBLIC_StandupDetector_CPP_API __declspec(dllexport)
#else
#define PUBLIC_StandupDetector_CPP_API __declspec(dllimport)
#endif

#define LIB_StandupDetector_CPP_API PUBLIC_StandupDetector_CPP_API

#else

#if !defined(LIB_StandupDetector_CPP_API)
#if defined(LIB_StandupDetector_C_API)
#define LIB_StandupDetector_CPP_API LIB_StandupDetector_C_API
#else
#define LIB_StandupDetector_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_StandupDetector_CPP_API void MW_CALL_CONV StandupDetector(int nargout, mwArray& varargout, const mwArray& varargin);

extern LIB_StandupDetector_CPP_API void MW_CALL_CONV StandupDetector(int nargout, mwArray& varargout);

extern LIB_StandupDetector_CPP_API void MW_CALL_CONV StandupDetector(const mwArray& varargin);

extern LIB_StandupDetector_CPP_API void MW_CALL_CONV StandupDetector();

#endif
#endif
