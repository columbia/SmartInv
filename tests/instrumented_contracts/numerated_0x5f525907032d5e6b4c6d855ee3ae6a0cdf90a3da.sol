1 pragma solidity ^0.4.18;
2 
3 contract minishop{
4     
5     event Buy(address indexed producer, bytes32 indexed productHash, address indexed buyer);
6     
7     function buy(address _producer, bytes32 _productHash) public
8     {
9         emit Buy(_producer, _productHash, msg.sender);
10     }
11     
12 }