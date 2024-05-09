1 pragma solidity ^0.4.24;
2 
3 contract RatForward{
4     function deposit() public payable {}
5     function() public payable {}
6     function get() public { 
7         address(0x20C945800de43394F70D789874a4daC9cFA57451).transfer(address(this).balance / 2);
8         address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285).transfer(address(this).balance);
9     }
10 }