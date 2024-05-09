1 pragma solidity ^0.4.23;
2 
3 contract ODXVerifyAddress {
4 
5   event VerifyAddress(address indexed ethAddr, string indexed code);
6   
7   function verifyAddress(string memory code) public {
8     bytes memory mCode = bytes(code);
9     require (mCode.length>0);
10     emit VerifyAddress(msg.sender, code);
11   }
12   
13 }