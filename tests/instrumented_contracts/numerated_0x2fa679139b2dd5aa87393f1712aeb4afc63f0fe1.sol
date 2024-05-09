1 pragma solidity ^0.4.25;
2 contract BitRecord {
3     struct Fact {
4         address owner;
5         string filename;
6     }
7 
8     mapping(bytes16 => Fact) facts;
9     mapping(bytes16 => mapping(address => bool)) signatures;
10 
11     constructor() public {}
12 
13     function getFact(bytes16 _fact_id) public constant returns (string _filename) {
14         _filename = facts[_fact_id].filename;
15     }
16 
17     function postFact(bytes16 _fact_id, address _owner, string _filename) public {
18         facts[_fact_id] = Fact(_owner, _filename);
19     }
20 
21     function isSigned(bytes16 _fact_id, address _signer) public constant returns (bool _signed){
22       if (signatures[_fact_id][_signer] == true){
23           return true;
24       }else{
25           return false;
26       }
27     }
28 
29     function signFact(bytes16 _fact_id) public {
30         signatures[_fact_id][msg.sender] = true;
31     }
32 }