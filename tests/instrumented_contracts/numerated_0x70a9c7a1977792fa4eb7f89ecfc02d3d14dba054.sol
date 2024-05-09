1 pragma solidity ^0.4.18;
2 
3 contract DAppTest {
4 
5   bool public _is;
6 
7   function changeBoolean() public returns (bool success) {
8     _is = !_is;
9     return true;
10   }
11 
12 }