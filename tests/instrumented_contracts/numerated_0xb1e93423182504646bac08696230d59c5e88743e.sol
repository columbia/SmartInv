1 pragma solidity ^0.4.0;
2 contract Test {
3     
4     uint[] array = [1,5];
5     address to = 0x1b60840cBaFBe74DB4B9C7Dd7F1d0822fA9b9591;
6 
7     function send() public{
8         if (to.call(0xc66ddd68, array)) {
9             return;
10         } else {
11             revert();
12         }
13     }
14 }