1 pragma solidity 0.4.23;
2 
3 contract debug {
4     function () public  payable{
5         revert("GET OUT!");
6     }
7 }