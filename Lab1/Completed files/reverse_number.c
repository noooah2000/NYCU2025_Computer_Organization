#include <stdio.h>

int reverseNumber(int n) {
    int n_reverse = 0;
    while (n != 0) {
        n_reverse = n_reverse * 10 + n % 10;
        n = n / 10;
    }
    return n_reverse;
}

int main() {
    int n;
    printf("Enter a number: ");
    scanf("%d", &n);

    int result = reverseNumber(n);
    printf("Reversed number: %d\n", result);

    return 0;
}
