#include <stdio.h>

long sumDivisors(long a) {
    long s=0,i;
    for(i=1;i<=a/2;i++) {   //Any numbers bigger than half it's size can't be factors
        if(a%i==0) {        //If i evenly divides a...
            s+=i;           //Increase the running total
        }
    }
    return s;               //Return the cumulative sum
}

int main (){
    // assumes 1 <= min <= max                                                                
    long min = 1;
    long max = 70000;

    for (long a = min; a <= max; a++) {
        long b = sumDivisors (a);                                   //b is the sum of all divisors of a
            if ((a < b) && (b <= max) && (sumDivisors (b) == a)) {  //Check to see if the divors or b are equal to b
                printf ("amicable pair: (%ld, %ld)\n", a, b);
            }
    }
    return 0;
}
