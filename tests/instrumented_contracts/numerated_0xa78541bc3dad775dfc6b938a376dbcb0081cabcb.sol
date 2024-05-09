1 pragma solidity ^0.4.2;
2 // Stampd.io Contract v1.00
3 contract StampdPostHash {
4   mapping (string => bool) private stampdLedger;
5   function _storeProof(string hashResult) {
6     stampdLedger[hashResult] = true;
7   }
8   function _checkLedger(string hashResult) constant returns (bool) {
9     return stampdLedger[hashResult];
10   }
11   function postProof(string hashResult) {
12     _storeProof(hashResult);
13   }
14   function proofExists(string hashResult) constant returns(bool) {
15     return _checkLedger(hashResult);
16   }
17 }