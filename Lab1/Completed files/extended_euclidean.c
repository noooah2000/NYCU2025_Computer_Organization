#include <stdio.h>

int mod_inverse(int a, int b) {
    int old_r = a, r = b;
    int old_s = 1, s = 0; 
    int q, temp;
    while (r != 0) {
        q = old_r / r;

        temp = old_r;
        old_r = r;
        r = temp - (q * r);

        temp = old_s;
        old_s = s;
        s = temp - (q * s);
    }
    if (old_r != 1) {
        return -1;
    }
    return (old_s + b) % b;
}

int main() {
    int a, b;
    printf("Enter the number: ");
    scanf("%d", &a);
    printf("Enter the modulo: ");
    scanf("%d", &b);

    int inv = mod_inverse(a, b);
    if (inv == -1) {
        printf("Inverse not exist.\n");
    } else {
        printf("Result: %d\n", inv);
    }

    return 0;
}
