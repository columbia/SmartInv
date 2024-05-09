1 pragma solidity^0.4.24;
2 
3 /**
4 *    /// A completely standalone nickname registrar
5 *    /// https://mobius.red/
6 *    !!!!!!!!!!!!!!
7 */
8 
9 contract DSAuthority {
10     function canCall(
11         address src, address dst, bytes4 sig
12     ) public view returns (bool);
13 }
14 
15 contract DSAuthEvents {
16     event LogSetAuthority (address indexed authority);
17     event LogSetOwner     (address indexed owner);
18 }
19 
20 contract DSAuth is DSAuthEvents {
21     DSAuthority  public  authority;
22     address      public  owner;
23 
24     constructor() public {
25         owner = msg.sender;
26         emit LogSetOwner(msg.sender);
27     }
28 
29     function setOwner(address owner_)
30         public
31         auth
32     {
33         owner = owner_;
34         emit LogSetOwner(owner);
35     }
36 
37     function setAuthority(DSAuthority authority_)
38         public
39         auth
40     {
41         authority = authority_;
42         emit LogSetAuthority(authority);
43     }
44 
45     modifier auth {
46         require(isAuthorized(msg.sender, msg.sig));
47         _;
48     }
49 
50     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
51         if (src == address(this)) {
52             return true;
53         } else if (src == owner) {
54             return true;
55         } else if (authority == DSAuthority(0)) {
56             return false;
57         } else {
58             return authority.canCall(src, this, sig);
59         }
60     }
61 }
62 
63 contract NicknameRegistrar is DSAuth {
64     uint public namePrice = 10 finney;
65 
66     mapping (address => string) public names;
67     mapping (bytes32 => address) internal _addresses;
68     mapping (address => string) public pendingNameTransfers;
69     mapping (bytes32 => bool) internal _inTransfer;
70 
71     modifier onlyUniqueName(string name) {
72         require(!nameTaken(name), "Name taken!");
73         _;
74     }
75 
76     modifier onlyPaid() {
77         require(msg.value >= namePrice, "Not enough value sent!");
78         _;
79     }
80 
81     modifier limitedLength(string s) {
82         require(bytes(s).length <= 32, "Name too long!");
83         require(bytes(s).length >= 1, "Name too short!");
84         _;
85     }
86 
87     event NameSet(address addr, string name);
88     event NameUnset(address addr);
89     event NameTransferRequested(address from, address to, string name);
90     event NameTransferAccepted(address by, string name);
91 
92     function nameTaken(string name) public view returns(bool) {
93         return _addresses[stringToBytes32(name)] != address(0x0) ||
94         _inTransfer[stringToBytes32(name)];
95     }
96 
97     function hasName(address addr) public view returns(bool) {
98         return bytes(names[addr]).length > 0;
99     }
100 
101     function addresses(string name) public view returns(address) {
102         return _addresses[stringToBytes32(name)];
103     }
104     
105     function setMyName(string newName) public payable
106     onlyUniqueName(newName)
107     limitedLength(newName) 
108     onlyPaid
109     {
110         names[msg.sender] = newName;
111         _addresses[stringToBytes32(newName)] = msg.sender;
112         emit NameSet(msg.sender, newName);
113     }
114 
115     function unsetMyName() public {
116         _addresses[stringToBytes32(names[msg.sender])] = address(0x0);
117         names[msg.sender] = "";      
118         emit NameUnset(msg.sender);  
119     }
120 
121     function transferMyName(address to) public payable onlyPaid {
122         require(hasName(msg.sender), "You don't have a name to transfer!");
123         pendingNameTransfers[to] = names[msg.sender];
124         _inTransfer[stringToBytes32(names[msg.sender])] = true;
125         
126         emit NameTransferRequested(msg.sender, to, names[msg.sender]);
127         names[msg.sender] = "";
128     }
129 
130     function acceptNameTranfer() public
131     limitedLength(pendingNameTransfers[msg.sender]) {
132         names[msg.sender] = pendingNameTransfers[msg.sender];
133         _addresses[stringToBytes32(pendingNameTransfers[msg.sender])] = msg.sender;
134         
135         _inTransfer[stringToBytes32(pendingNameTransfers[msg.sender])] = false;
136         pendingNameTransfers[msg.sender] = "";
137         emit NameTransferAccepted(msg.sender, names[msg.sender]);
138     }
139 
140     function getMoney() public auth {
141         owner.transfer(address(this).balance);
142     }
143 
144     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
145         bytes memory tempEmptyStringTest = bytes(source);
146         if (tempEmptyStringTest.length == 0) {
147             return 0x0;
148         }
149         // solium-disable security/no-inline-assembly
150         assembly {
151             result := mload(add(source, 32))
152         }
153     }
154 }