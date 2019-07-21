/* -*- Mode:C; Coding:us-ascii-unix; fill-column:132 -*- */
/* ****************************************************************************************************************************** */
/**
   @file      c_dgesv.c
   @author    based on https://www.mitchr.me/SS/exampleCode/blas/slvSysC.c.html
   @brief     Wrapper of LAPACK's sgesv functions.@EOL

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

int main(int argc, char **argv) {
  return 0;

} /* end func main */

CLPKinteger * c_dgesv(CLPKdoublereal *matrix4x4, CLPKdoublereal *vector) {
  CLPKinteger *pivs = malloc(4);
    if(!pivs)
        return NULL;
  CLPKinteger inf;
  CLPKinteger n=4, lda=4, nrhs=1, ldb=4;
  char tbuf[1024];
  int i;

  dgesv_(&n, &nrhs, matrix4x4, &lda, pivs, vector, &ldb, &inf);

  if(inf == 0) {
    printf("Successful Solution\n");
  } else if(inf < 0) {
    printf("Illegal value at: %d\n", -(int)inf);
    exit(1);
  } else if(inf > 0) {
    printf("Matrix was singular\n");
    exit(1);
  } else {
    printf("Unknown Result (Can't happen!)\n");
    exit(1);
  } /* end if/else */

  printf("PIV=");
  for(i=0;i<4;i++)
    printf("%4d ", (int)(pivs[i]));
  printf("\n");

  // *  IPIV    (output) INTEGER array, dimension (N)
  // *          The pivot indices that define the permutation matrix P;
  // *          row i of the matrix was interchanged with row IPIV(i).
  // *

  return pivs;
}
