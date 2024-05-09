1 pragma solidity 0.4.19;
2 
3 contract DocumentStore {
4 
5     event Store(bytes32 indexed document, bytes32 indexed party1, bytes32 indexed party2);
6 
7     function store(bytes32 document, bytes32 party1, bytes32 party2) public {
8         Store(document, party1, party2);
9     }
10 }