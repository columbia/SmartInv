1 pragma solidity ^0.4.10;
2 
3 contract Caller {
4     function callAddress(address a) {
5         a.call();
6     }
7 }