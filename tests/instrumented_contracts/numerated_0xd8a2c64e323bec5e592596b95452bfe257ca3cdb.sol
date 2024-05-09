1 pragma solidity ^0.4.0;
2 contract onchain{
3     string onChainData;
4     function set (string x) public{
5         onChainData = x;
6     }
7     
8     function get() public constant returns (string){
9         return onChainData;
10     }
11 }