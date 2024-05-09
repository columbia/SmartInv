1 pragma solidity ^0.4.0;
2 
3 /// @title Andxor hash logger
4 /// @author Andxor Soluzioni Informatiche srl <http://www.andxor.it/>
5 contract AndxorLogger {
6     event LogHash(uint256 hash);
7 
8     function AndxorLogger() {
9     }
10 
11     /// logs an hash value into the blockchain
12     function logHash(uint256 value) {
13         LogHash(value);
14     }
15 }