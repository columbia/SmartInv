1 pragma solidity 0.4.24;
2 
3 contract DocSignature {
4 
5   struct SignProcess {
6     bytes16 id;
7     bytes16[] participants;
8   }
9 
10   address controller;
11   mapping(address => bool) isOwner;
12   mapping(bytes => SignProcess[]) documents;
13   address[] public owners;
14 
15   constructor(address _controller, address _owner) public {
16     controller = _controller;
17     isOwner[_owner] = true;
18     owners.push(_owner);
19   }
20 
21   modifier notNull(address _address) {
22     require(_address != 0);
23     _;
24   }
25 
26   function addOwner(address _owner) public notNull(_owner) returns (bool) {
27     require(isOwner[msg.sender]);
28     isOwner[_owner] = true;
29     owners.push(_owner);
30     return true;
31   }
32 
33   function removeOwner(address _owner) public notNull(_owner) returns (bool) {
34     require(msg.sender != _owner && isOwner[msg.sender]);
35     isOwner[_owner] = false;
36     for (uint i=0; i<owners.length - 1; i++)
37       if (owners[i] == _owner) {
38         owners[i] = owners[owners.length - 1];
39         break;
40       }
41     owners.length -= 1;
42     return true;
43   }
44 
45   function getOwners() public constant returns (address[]) {
46     return owners;
47   }
48 
49   function setController(address _controller) public notNull(_controller) returns (bool) {
50     require(isOwner[msg.sender]);
51     controller = _controller;
52     return true;
53   }
54 
55   function signDocument(bytes _documentHash, bytes16 _signProcessId, bytes16[] _participants) public returns (bool) {
56     require(msg.sender == controller);
57     documents[_documentHash].push(SignProcess(_signProcessId, _participants));
58     return true;
59   }
60 
61   function getDocumentSignatures(bytes _documentHash) public view returns (bytes16[], bytes16[]) {
62     uint _signaturesCount = 0;
63     for (uint o = 0; o < documents[_documentHash].length; o++) {
64       _signaturesCount += documents[_documentHash][o].participants.length;
65     }
66 
67     bytes16[] memory _ids = new bytes16[](_signaturesCount);
68     bytes16[] memory _participants = new bytes16[](_signaturesCount);
69 
70     uint _index = 0;
71     for (uint i = 0; i < documents[_documentHash].length; i++) {
72       for (uint j = 0; j < documents[_documentHash][i].participants.length; j++) {
73         _ids[_index] =  documents[_documentHash][i].id;
74         _participants[_index] = documents[_documentHash][i].participants[j];
75         _index++;
76       }
77     }
78 
79     return (_ids, _participants);
80   }
81 
82   function getDocumentProcesses(bytes _documentHash) public view returns (bytes16[]) {
83     bytes16[] memory _ids = new bytes16[](documents[_documentHash].length);
84 
85     for (uint i = 0; i < documents[_documentHash].length; i++) {
86       _ids[i] =  documents[_documentHash][i].id;
87     }
88 
89     return (_ids);
90   }
91 
92   function getProcessParties(bytes _documentHash, bytes16 _processId) public view returns (bytes16[]) {
93     for (uint i = 0; i < documents[_documentHash].length; i++) {
94       if (documents[_documentHash][i].id == _processId)
95         return (documents[_documentHash][i].participants);
96     }
97     return (new bytes16[](0));
98   }
99 }