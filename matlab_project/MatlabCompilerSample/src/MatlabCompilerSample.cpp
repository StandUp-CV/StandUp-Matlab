//
// MATLAB Compiler: 4.18 (R2012b)
// Date: Tue Nov 27 10:54:04 2012
// Arguments: "-B" "macro_default" "-W" "cpplib:MatlabCompilerSample" "-T"
// "link:lib" "-d"
// "H:\Projekte\Git\standup_cv.2\matlab_project\MatlabCompilerSample\src" "-N"
// "-p" "vision" "-p" "imaq" "-p" "images" "-w"
// "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w"
// "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w"
// "enable:demo_license" "-g" "-G" "-v"
// "H:\Projekte\Git\standup_cv.2\matlab_project\WebcamSample2.m" 
//

#include <stdio.h>
#define EXPORTING_MatlabCompilerSample 1
#include "MatlabCompilerSample.h"

static HMCRINSTANCE _mcr_inst = NULL;


#if defined( _MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__) || defined(__LCC__)
#ifdef __LCC__
#undef EXTERN_C
#endif
#include <windows.h>

static char path_to_dll[_MAX_PATH];

BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, void *pv)
{
    if (dwReason == DLL_PROCESS_ATTACH)
    {
        if (GetModuleFileName(hInstance, path_to_dll, _MAX_PATH) == 0)
            return FALSE;
    }
    else if (dwReason == DLL_PROCESS_DETACH)
    {
    }
    return TRUE;
}
#endif
#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_MatlabCompilerSample_C_API
#define LIB_MatlabCompilerSample_C_API /* No special import/export declaration */
#endif

LIB_MatlabCompilerSample_C_API 
bool MW_CALL_CONV MatlabCompilerSampleInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!GetModuleFileName(GetModuleHandle("MatlabCompilerSample"), path_to_dll, _MAX_PATH))
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream(path_to_dll);
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_MatlabCompilerSample_C_API 
bool MW_CALL_CONV MatlabCompilerSampleInitialize(void)
{
  return MatlabCompilerSampleInitializeWithHandlers(mclDefaultErrorHandler, 
                                                    mclDefaultPrintHandler);
}

LIB_MatlabCompilerSample_C_API 
void MW_CALL_CONV MatlabCompilerSampleTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_MatlabCompilerSample_C_API 
void MW_CALL_CONV MatlabCompilerSamplePrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_MatlabCompilerSample_C_API 
bool MW_CALL_CONV mlxWebcamSample2(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "WebcamSample2", nlhs, plhs, nrhs, prhs);
}

LIB_MatlabCompilerSample_CPP_API 
void MW_CALL_CONV WebcamSample2(const mwArray& frameCount)
{
  mclcppMlfFeval(_mcr_inst, "WebcamSample2", 0, 0, 1, &frameCount);
}

