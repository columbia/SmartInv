1 pragma solidity ^0.4.20;
2 
3 contract Pointer {
4     uint256 public pointer;
5 
6     function bumpPointer() internal returns (uint256 p) {
7         return pointer++;
8     }
9 }
10 
11 contract DistributedTrust is Pointer {
12 
13     mapping(uint256 => Fact) public facts;
14     mapping(uint256 => mapping(address => bool)) public validations;
15 
16     event NewFact(uint256 factIndex, address indexed reportedBy, string description, string meta);
17     event AttestedFact(uint256 indexed factIndex, address validator);
18 
19     struct Fact {
20         address reportedBy;
21         string description;
22         string meta;
23         uint validationCount;
24     }
25 
26     modifier factExist(uint256 factIndex) {
27         assert(facts[factIndex].reportedBy != 0);
28         _;
29     }
30 
31     modifier notAttestedYetBySigner(uint256 factIndex) {
32         assert(validations[factIndex][msg.sender] != true);
33         _;
34     }
35 
36     // "Olivia Marie Fraga Rolim. Born at 2018-04-03 20:54:00 BRT, in the city of Rio de Janeiro, Brazil", 
37     // "ipfs://QmfD5tpeF8UpHZMnSVq3qNPVNwd8JNfF4g8L3UFVUfkiRK"
38     function newFact(string description, string meta) public {
39         uint256 factIndex = bumpPointer();
40      
41         facts[factIndex] = Fact(msg.sender, description, meta, 0);
42         attest(factIndex);
43         
44         NewFact(factIndex, msg.sender, description, meta);
45     }
46 
47     function attest(uint256 factIndex) factExist(factIndex) notAttestedYetBySigner(factIndex) public returns (bool) {
48         validations[factIndex][msg.sender] = true;
49         facts[factIndex].validationCount++;
50         
51         AttestedFact(factIndex, msg.sender);
52         return true;
53     }
54     
55     function isTrustedBy(uint256 factIndex, address validator) factExist(factIndex) view public returns (bool isTrusted) {
56         return validations[factIndex][validator];
57     }
58 
59 }