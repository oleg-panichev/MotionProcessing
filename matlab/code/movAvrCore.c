/*
 * This function performs moving average operation.
 *
 * Function call:
 * [outData,dLine,accSum,idxOld]=movAvrCore(inData,dLine,accSum,idxOld);
 *
 */
#include <stdio.h>
#include <string.h>
#include "mex.h"


/* Inputs */
#define IN_DATA      (prhs[0])
#define IN_DLINE     (prhs[1])
#define IN_ACC_SUM   (prhs[2])
#define IN_IDX_OLD   (prhs[3])

/* Outputs */
#define OUT_DATA     (plhs[0])
#define OUT_DLINE    (plhs[1])
#define OUT_ACC_SUM  (plhs[2])
#define OUT_IDX_OLD  (plhs[3])


/* Core function */
static void movAvr(double *pInData, double *pOutData, unsigned int lenInData, 
    double *pDLine, unsigned int lenDLine, double *pAccSum, double *pIdxOld)
{
  unsigned int i;
  unsigned int idxOld = (unsigned int)(*pIdxOld - 1.0);
  double devider = (double)lenDLine;

  for (i = 0; i < lenInData; i++)
  {
    /* Add new */
    *pAccSum += pInData[i];

    /* Subtract oldest */
    *pAccSum -= pDLine[idxOld];

    /* Shift delay line */
    pDLine[idxOld] = pInData[i];
    if ((++idxOld) >= lenDLine) {
      idxOld = 0;
    }

    /* Return average */
    pOutData[i] = *pAccSum / devider;
  }

  /* Save old index back */
  *pIdxOld = (double)(idxOld + 1);
}


/* Mex wrapper */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  double *pAccSum, *pIdxOld;
  double *pInData, *pOutData, *pDLine;
  unsigned int lenInData, lenDLine;


  /* Check number of inputs and outputs */
  if (nlhs != 4) {
    mexErrMsgTxt("movAvrCore: Function has wrong number output parameters;\n");
  }

  if (nrhs != 4) {
    mexErrMsgTxt("movAvrCore: Function has wrong number input parameters;\n");
  }

  /* Check 'inData' type */
  if (!mxIsDouble(IN_DATA)) {
    mexErrMsgTxt("movAvrCore: Input data isn't double array;");
  }


  /* Input parameters */
  pInData = mxGetPr(IN_DATA);
  lenInData = mxGetNumberOfElements(IN_DATA);


  /* Output parameters */
  OUT_DATA = mxDuplicateArray(IN_DATA);
  pOutData = mxGetPr(OUT_DATA);

  OUT_DLINE = mxDuplicateArray(IN_DLINE);
  pDLine = mxGetPr(OUT_DLINE);
  lenDLine = mxGetNumberOfElements(OUT_DLINE);

  OUT_ACC_SUM = mxDuplicateArray(IN_ACC_SUM);
  pAccSum = mxGetPr(OUT_ACC_SUM);

  OUT_IDX_OLD = mxDuplicateArray(IN_IDX_OLD);
  pIdxOld = mxGetPr(OUT_IDX_OLD);

  /* Process */
  movAvr(pInData, pOutData, lenInData, pDLine, lenDLine, pAccSum, pIdxOld);

  return;
}
