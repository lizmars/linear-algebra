/* -*- Mode:C; Coding:us-ascii-unix; fill-column:132 -*- */
/* ****************************************************************************************************************************** */
/**
   @file      c_dgesv.h
   @author    based on https://www.mitchr.me/SS/exampleCode/blas/slvSysC.c.html
   @brief    Header file of c_dgesv.c .@EOL

*/

/* ------------------------------------------------------------------------------------------------------------------------------ */

#include <stdio.h>              /* I/O lib         ISOC  */
#include <stdlib.h>             /* Standard Lib    ISOC  */
#ifdef __APPLE__
#include <Accelerate/Accelerate.h>    /* The MacOS X blas/lapack stuff */
typedef __CLPK_integer       CLPKinteger;
typedef __CLPK_doublereal    CLPKdoublereal;
#else
#include <clapack.h>    	/* C LAPACK         */
typedef int       CLPKinteger;
typedef double    CLPKdoublereal;
#endif


/* computes the solution to system of linear equations A * X = B for GE matrices (simple driver) */
CLPKinteger * c_dgesv(CLPKdoublereal *matrix4x4, CLPKdoublereal *vector)
