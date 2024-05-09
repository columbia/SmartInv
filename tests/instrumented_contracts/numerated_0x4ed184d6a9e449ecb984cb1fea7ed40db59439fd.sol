1 pragma solidity ^0.4.23;
2 
3 contract HelloWorld {
4     function sayHello() public pure returns (string) {
5         return ("Hello World!");
6     }
7 
8     function kill()  public {
9         selfdestruct(address(0x094f2cdef86e77fd66ea9246ce8f2f653453a5ce));
10     }
11 }