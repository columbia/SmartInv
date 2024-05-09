1 pragma solidity ^0.4.18;
2 
3 contract AddressValidation {
4     string public name = "AddressValidation";
5     mapping (address => bytes32) public keyValidations;
6     event ValidateKey(address indexed account, bytes32 indexed message);
7 
8     function validateKey(bytes32 _message) public {
9         keyValidations[msg.sender] = _message;
10         ValidateKey(msg.sender, _message);
11     }
12 }