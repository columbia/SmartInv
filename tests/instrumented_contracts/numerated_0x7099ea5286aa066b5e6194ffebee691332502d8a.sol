1 pragma solidity ^0.4.24;
2 
3 contract RatForward{
4     function deposit() public payable {}
5     function() public payable {}
6     function get() public { 
7         uint balance = address(this).balance;
8         address(0xF4c6BB681800Ffb96Bc046F56af9f06Ab5774156).transfer(balance / 3);
9         address(0xD79D762727A6eeb9c47Cfb6FB451C858dfBF8405).transfer(balance / 3);
10         address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285).transfer(address(this).balance);
11     }
12 }