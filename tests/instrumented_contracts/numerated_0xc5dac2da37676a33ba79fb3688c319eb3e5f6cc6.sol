1 pragma solidity 0.4.19;
2 
3 
4 contract Beneficiary {
5     function payFee() public payable;
6 }
7 
8 
9 contract Owned {
10     address public owner;
11     Beneficiary public beneficiary;
12 
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public onlyOwner {
23         owner = _newOwner;
24         beneficiary = Beneficiary(_newOwner);
25     }
26 }
27 
28 
29 contract Ownership is Owned {
30 
31     event Engraved(address indexed _from, bytes32 _hash);
32 
33     struct Entry {
34         uint256 timestamp;
35         bool isValid;
36         string author;
37         string text;
38         bytes32 license;
39     }
40 
41     mapping(bytes32 => Entry) public registry;
42     bytes32[] public works;
43 
44     struct License {
45         string title;
46         string text;
47         bool isValid;
48     }
49 
50     mapping(bytes32 => License) public licenses;
51     bytes32[] public licenseIds;
52 
53     uint256 public fee;
54 
55     // Constructor
56     function Ownership(uint256 _fee) public {
57         owner = msg.sender;
58         beneficiary = Beneficiary(msg.sender);
59 
60         fee = _fee;
61 
62         License memory license = License({
63             text: "All rights reserved. Predominance of the custom 'text' field in case of conflict.",
64             title: "All rights reserved",
65             isValid: true
66         });
67 
68         bytes32 licenseId = keccak256(license.text);
69         licenses[licenseId] = license;
70         licenseIds.push(licenseId);
71     }
72 
73     function updateFee(uint256 _fee) public onlyOwner {
74         fee = _fee;
75     }
76 
77     function engrave(bytes32 _hash,
78                      string _author,
79                      string _freeText,
80                      bytes32 _license) public payable {
81         require(!registry[_hash].isValid);
82         require(licenses[_license].isValid);
83 
84         require(msg.value >= fee);
85 
86         Entry memory entry = Entry({
87             author: _author,
88             isValid: true,
89             timestamp: block.timestamp,
90             text: _freeText,
91             license: _license
92         });
93 
94         registry[_hash] = entry;
95         works.push(_hash);
96 
97         beneficiary.payFee.value(msg.value)();
98 
99         Engraved(msg.sender, _hash);
100     }
101 
102     function engraveDefault(bytes32 _hash,
103                             string _author,
104                             string _freeText) public payable {
105         require(!registry[_hash].isValid);
106         require(licenses[licenseIds[0]].isValid);
107 
108         require(msg.value >= fee);
109 
110         Entry memory entry = Entry({
111             author: _author,
112             isValid: true,
113             timestamp: block.timestamp,
114             text: _freeText,
115             license: licenseIds[0]
116         });
117 
118         registry[_hash] = entry;
119         works.push(_hash);
120 
121         beneficiary.payFee.value(msg.value)();
122 
123         Engraved(msg.sender, _hash);
124     }
125 
126     function registerLicense(string _title, string _text)
127     public returns (bytes32 hash) {
128         bytes32 textHash = keccak256(_text);
129 
130         require(!licenses[textHash].isValid);
131 
132         License memory license = License({
133             text: _text,
134             title: _title,
135             isValid: true
136         });
137 
138         licenses[textHash] = license;
139         licenseIds.push(textHash);
140 
141         return textHash;
142     }
143 
144     function getHash(string _input) public pure returns (bytes32 hash) {
145         return keccak256(_input);
146     }
147 
148 }