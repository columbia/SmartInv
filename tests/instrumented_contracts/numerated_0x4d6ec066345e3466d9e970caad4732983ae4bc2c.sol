1 pragma solidity^0.4.24;
2 
3 /// A completely standalone nickname registrar
4 /// https://M2D.win
5 /// Laughing Man
6 
7 contract DSAuthority {
8     function canCall(
9         address src, address dst, bytes4 sig
10     ) public view returns (bool);
11 }
12 
13 contract DSAuthEvents {
14     event LogSetAuthority (address indexed authority);
15     event LogSetOwner     (address indexed owner);
16 }
17 
18 contract DSAuth is DSAuthEvents {
19     DSAuthority  public  authority;
20     address      public  owner;
21 
22     constructor() public {
23         owner = msg.sender;
24         emit LogSetOwner(msg.sender);
25     }
26 
27     function setOwner(address owner_)
28         public
29         auth
30     {
31         owner = owner_;
32         emit LogSetOwner(owner);
33     }
34 
35     function setAuthority(DSAuthority authority_)
36         public
37         auth
38     {
39         authority = authority_;
40         emit LogSetAuthority(authority);
41     }
42 
43     modifier auth {
44         require(isAuthorized(msg.sender, msg.sig));
45         _;
46     }
47 
48     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
49         if (src == address(this)) {
50             return true;
51         } else if (src == owner) {
52             return true;
53         } else if (authority == DSAuthority(0)) {
54             return false;
55         } else {
56             return authority.canCall(src, this, sig);
57         }
58     }
59 }
60 
61 contract NicknameRegistrar is DSAuth {
62     uint public namePrice = 10 finney;
63 
64     mapping (address => string) public names;
65     mapping (bytes32 => address) internal _addresses;
66     mapping (address => string) public pendingNameTransfers;
67     mapping (bytes32 => bool) internal _inTransfer;
68 
69     modifier onlyUniqueName(string name) {
70         require(!nameTaken(name), "Name taken!");
71         _;
72     }
73 
74     modifier onlyPaid() {
75         require(msg.value >= namePrice, "Not enough value sent!");
76         _;
77     }
78 
79     modifier limitedLength(string s) {
80         require(bytes(s).length <= 32, "Name too long!");
81         require(bytes(s).length >= 1, "Name too short!");
82         _;
83     }
84 
85     event NameSet(address addr, string name);
86     event NameUnset(address addr);
87     event NameTransferRequested(address from, address to, string name);
88     event NameTransferAccepted(address by, string name);
89 
90     function nameTaken(string name) public view returns(bool) {
91         return _addresses[stringToBytes32(name)] != address(0x0) ||
92         _inTransfer[stringToBytes32(name)];
93     }
94 
95     function hasName(address addr) public view returns(bool) {
96         return bytes(names[addr]).length > 0;
97     }
98 
99     function addresses(string name) public view returns(address) {
100         return _addresses[stringToBytes32(name)];
101     }
102     
103     function setMyName(string newName) public payable
104     onlyUniqueName(newName)
105     limitedLength(newName) 
106     onlyPaid
107     {
108         names[msg.sender] = newName;
109         _addresses[stringToBytes32(newName)] = msg.sender;
110         emit NameSet(msg.sender, newName);
111     }
112 
113     function unsetMyName() public {
114         _addresses[stringToBytes32(names[msg.sender])] = address(0x0);
115         names[msg.sender] = "";      
116         emit NameUnset(msg.sender);  
117     }
118 
119     function transferMyName(address to) public payable onlyPaid {
120         require(hasName(msg.sender), "You don't have a name to transfer!");
121         pendingNameTransfers[to] = names[msg.sender];
122         _inTransfer[stringToBytes32(names[msg.sender])] = true;
123         
124         emit NameTransferRequested(msg.sender, to, names[msg.sender]);
125         names[msg.sender] = "";
126     }
127 
128     function acceptNameTranfer() public
129     limitedLength(pendingNameTransfers[msg.sender]) {
130         names[msg.sender] = pendingNameTransfers[msg.sender];
131         _addresses[stringToBytes32(pendingNameTransfers[msg.sender])] = msg.sender;
132         
133         _inTransfer[stringToBytes32(pendingNameTransfers[msg.sender])] = false;
134         pendingNameTransfers[msg.sender] = "";
135         emit NameTransferAccepted(msg.sender, names[msg.sender]);
136     }
137 
138     function getMoney() public auth {
139         owner.transfer(address(this).balance);
140     }
141 
142     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
143         bytes memory tempEmptyStringTest = bytes(source);
144         if (tempEmptyStringTest.length == 0) {
145             return 0x0;
146         }
147         // solium-disable security/no-inline-assembly
148         assembly {
149             result := mload(add(source, 32))
150         }
151     }
152 }