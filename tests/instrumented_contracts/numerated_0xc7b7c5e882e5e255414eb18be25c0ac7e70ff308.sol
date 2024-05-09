1 pragma solidity ^0.4.15;
2 
3 contract DocumentSigner {
4     mapping(string => address[]) signatureMap;
5     
6     function sign(string _documentHash) public {
7         signatureMap[_documentHash].push(msg.sender);
8     }
9 
10     function getSignatureAtIndex(string _documentHash, uint _index) public constant returns (address) {
11     	return signatureMap[_documentHash][_index];
12     }
13 
14     function getSignatures(string _documentHash) public constant returns (address[]) {
15     	return signatureMap[_documentHash];
16     }
17 }