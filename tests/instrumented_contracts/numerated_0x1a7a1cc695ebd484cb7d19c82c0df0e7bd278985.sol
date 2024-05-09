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
29 contract Integrity is Owned {
30     uint256 public fee;
31 
32     event Engraved(address indexed _from, string _namespace, string _name, bytes32 _hash);
33 
34     struct FileInfo {
35         string name;
36         bool isValid;
37     }
38 
39     struct Namespace {
40         mapping(bytes32 => FileInfo) files;
41         mapping(address => bool) permissions;
42         address owner;
43         bool isValid;
44     }
45 
46     mapping(string => Namespace) registry;
47 
48     modifier onlyNamespaceOwner(string _namespace) {
49         require(msg.sender == registry[_namespace].owner);
50         _;
51     }
52 
53     modifier onlyNamespaceMember(string _namespace) {
54         require(registry[_namespace].permissions[msg.sender]);
55         _;
56     }
57 
58     // Constructor
59     function Integrity(uint256 _fee) public {
60         owner = msg.sender;
61         beneficiary = Beneficiary(msg.sender);
62 
63         fee = _fee;
64 
65         Namespace memory namespace = Namespace({
66             owner: 0x0,
67             isValid: true
68         });
69 
70         registry["default"] = namespace;
71     }
72 
73     function updateFee(uint256 _fee) public onlyOwner {
74         fee = _fee;
75     }
76 
77     function createNamespace(string _namespace) public payable {
78         require(!registry[_namespace].isValid);
79         require(msg.value >= fee * 10);
80 
81         Namespace memory namespace = Namespace({
82             owner: msg.sender,
83             isValid: true
84         });
85 
86         registry[_namespace] = namespace;
87         registry[_namespace].permissions[msg.sender] = true;
88 
89         beneficiary.payFee.value(msg.value)();
90     }
91 
92     function changeNamespaceOwner(string _namespace, address _newOwner)
93     public onlyNamespaceOwner(_namespace) {
94         require(registry[_namespace].isValid);
95 
96         registry[_namespace].owner = _newOwner;
97     }
98 
99     function addNamespaceMember(string _namespace, address _newMember)
100     public onlyNamespaceOwner(_namespace) {
101         require(registry[_namespace].isValid);
102 
103         registry[_namespace].permissions[_newMember] = true;
104     }
105 
106     function removeNamespaceMember(string _namespace, address _member)
107     public onlyNamespaceOwner(_namespace) {
108         require(registry[_namespace].isValid);
109         require(registry[_namespace].permissions[_member]);
110 
111         registry[_namespace].permissions[_member] = false;
112     }
113 
114     function engraveNamespace(string _namespace, string _name, bytes32 _hash)
115     public onlyNamespaceMember(_namespace) payable {
116         require(registry[_namespace].isValid);
117         require(!registry[_namespace].files[_hash].isValid);
118         require(msg.value >= fee);
119 
120         FileInfo memory info = FileInfo({
121             name: _name,
122             isValid: true
123         });
124 
125         registry[_namespace].files[_hash] = info;
126 
127         beneficiary.payFee.value(msg.value)();
128 
129         Engraved(msg.sender, _namespace, _name, _hash);
130     }
131 
132     function engrave(string _name, bytes32 _hash) public payable {
133         require(registry["default"].isValid);
134         require(!registry["default"].files[_hash].isValid);
135         require(msg.value >= fee);
136 
137         FileInfo memory info = FileInfo({
138             name: _name,
139             isValid: true
140         });
141 
142         registry["default"].files[_hash] = info;
143 
144         beneficiary.payFee.value(msg.value)();
145 
146         Engraved(msg.sender, "default", _name, _hash);
147     }
148 
149     function checkFileNamespace(string _namespace, bytes32 _hash)
150     public constant returns (string name) {
151         return registry[_namespace].files[_hash].name;
152     }
153 
154     function checkFile(bytes32 _hash)
155     public constant returns (string name) {
156         return registry["default"].files[_hash].name;
157     }
158 
159     function getHash(string _input) public pure returns (bytes32 hash) {
160         return keccak256(_input);
161     }
162 
163 }