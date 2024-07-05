
# include "addd_func.h"

int main(){
    int i;
    int gauss;
    int j,k;
    gauss = 0;
    // add from 1 to 100
    for(i=0; i<=100; i++){
        gauss+=i;
    }
    // gauss = 5050.
    j = 10;
    k = 20;
    i = addd_func(j,k);
    return gauss;
}
