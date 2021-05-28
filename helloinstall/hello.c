#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    printf("Hello, %s!\n", getenv("USER"));
    return 0;
}
