1 pragma solidity ^0.4.16;
2 
3 contract AKValueTest
4 {
5     uint256 public someValue;
6     
7     function setSomeValue(uint256 newValue)
8     {
9         someValue = newValue;
10     }
11 }