1 pragma solidity ^0.4.16;
2 
3 contract Storage {
4 
5    address owner = 0xb697a802a93c9ef958ec93ddf4d5800c5a01f7d4; // <= define the address you control (have the private key to)
6 
7    bytes32[] storageContainer;
8 
9    function pushByte(bytes32 b) {
10       storageContainer.push(b);
11    }
12 
13 }