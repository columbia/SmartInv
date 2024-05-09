1 pragma solidity ^0.4.24;
2 
3 // (c) copyright SecureVote 2018
4 // github.com/secure-vote/sv-light-smart-contracts
5 
6 contract owned {
7     address public owner;
8 
9     event OwnerChanged(address newOwner);
10 
11     modifier only_owner() {
12         require(msg.sender == owner, "only_owner: forbidden");
13         _;
14     }
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     function setOwner(address newOwner) only_owner() external {
21         owner = newOwner;
22         emit OwnerChanged(newOwner);
23     }
24 }
25 
26 contract hasAdmins is owned {
27     mapping (uint => mapping (address => bool)) admins;
28     uint public currAdminEpoch = 0;
29     bool public adminsDisabledForever = false;
30     address[] adminLog;
31 
32     event AdminAdded(address indexed newAdmin);
33     event AdminRemoved(address indexed oldAdmin);
34     event AdminEpochInc();
35     event AdminDisabledForever();
36 
37     modifier only_admin() {
38         require(adminsDisabledForever == false, "admins must not be disabled");
39         require(isAdmin(msg.sender), "only_admin: forbidden");
40         _;
41     }
42 
43     constructor() public {
44         _setAdmin(msg.sender, true);
45     }
46 
47     function isAdmin(address a) view public returns (bool) {
48         return admins[currAdminEpoch][a];
49     }
50 
51     function getAdminLogN() view external returns (uint) {
52         return adminLog.length;
53     }
54 
55     function getAdminLog(uint n) view external returns (address) {
56         return adminLog[n];
57     }
58 
59     function upgradeMeAdmin(address newAdmin) only_admin() external {
60         // note: already checked msg.sender has admin with `only_admin` modifier
61         require(msg.sender != owner, "owner cannot upgrade self");
62         _setAdmin(msg.sender, false);
63         _setAdmin(newAdmin, true);
64     }
65 
66     function setAdmin(address a, bool _givePerms) only_admin() external {
67         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
68         _setAdmin(a, _givePerms);
69     }
70 
71     function _setAdmin(address a, bool _givePerms) internal {
72         admins[currAdminEpoch][a] = _givePerms;
73         if (_givePerms) {
74             emit AdminAdded(a);
75             adminLog.push(a);
76         } else {
77             emit AdminRemoved(a);
78         }
79     }
80 
81     // safety feature if admins go bad or something
82     function incAdminEpoch() only_owner() external {
83         currAdminEpoch++;
84         admins[currAdminEpoch][msg.sender] = true;
85         emit AdminEpochInc();
86     }
87 
88     // this is internal so contracts can all it, but not exposed anywhere in this
89     // contract.
90     function disableAdminForever() internal {
91         currAdminEpoch++;
92         adminsDisabledForever = true;
93         emit AdminDisabledForever();
94     }
95 }
96 
97 contract TokenAbbreviationLookup is hasAdmins {
98 
99     event RecordAdded(bytes32 abbreviation, bytes32 democHash, bool hidden);
100 
101     struct Record {
102         bytes32 democHash;
103         bool hidden;
104     }
105 
106     struct EditRec {
107         bytes32 abbreviation;
108         uint timestamp;
109     }
110 
111     mapping (bytes32 => Record) public lookup;
112 
113     EditRec[] public edits;
114 
115     function nEdits() external view returns (uint) {
116         return edits.length;
117     }
118 
119     function lookupAllSince(uint pastTs) external view returns (bytes32[] memory abrvs, bytes32[] memory democHashes, bool[] memory hiddens) {
120         bytes32 abrv;
121         for (uint i = 0; i < edits.length; i++) {
122             if (edits[i].timestamp >= pastTs) {
123                 abrv = edits[i].abbreviation;
124                 Record storage r = lookup[abrv];
125                 abrvs = MemArrApp.appendBytes32(abrvs, abrv);
126                 democHashes = MemArrApp.appendBytes32(democHashes, r.democHash);
127                 hiddens = MemArrApp.appendBool(hiddens, r.hidden);
128             }
129         }
130     }
131 
132     function addRecord(bytes32 abrv, bytes32 democHash, bool hidden) only_admin() external {
133         lookup[abrv] = Record(democHash, hidden);
134         edits.push(EditRec(abrv, now));
135         emit RecordAdded(abrv, democHash, hidden);
136     }
137 
138 }
139 
140 library MemArrApp {
141 
142     // A simple library to allow appending to memory arrays.
143 
144     function appendUint256(uint256[] memory arr, uint256 val) internal pure returns (uint256[] memory toRet) {
145         toRet = new uint256[](arr.length + 1);
146 
147         for (uint256 i = 0; i < arr.length; i++) {
148             toRet[i] = arr[i];
149         }
150 
151         toRet[arr.length] = val;
152     }
153 
154     function appendUint128(uint128[] memory arr, uint128 val) internal pure returns (uint128[] memory toRet) {
155         toRet = new uint128[](arr.length + 1);
156 
157         for (uint256 i = 0; i < arr.length; i++) {
158             toRet[i] = arr[i];
159         }
160 
161         toRet[arr.length] = val;
162     }
163 
164     function appendUint64(uint64[] memory arr, uint64 val) internal pure returns (uint64[] memory toRet) {
165         toRet = new uint64[](arr.length + 1);
166 
167         for (uint256 i = 0; i < arr.length; i++) {
168             toRet[i] = arr[i];
169         }
170 
171         toRet[arr.length] = val;
172     }
173 
174     function appendUint32(uint32[] memory arr, uint32 val) internal pure returns (uint32[] memory toRet) {
175         toRet = new uint32[](arr.length + 1);
176 
177         for (uint256 i = 0; i < arr.length; i++) {
178             toRet[i] = arr[i];
179         }
180 
181         toRet[arr.length] = val;
182     }
183 
184     function appendUint16(uint16[] memory arr, uint16 val) internal pure returns (uint16[] memory toRet) {
185         toRet = new uint16[](arr.length + 1);
186 
187         for (uint256 i = 0; i < arr.length; i++) {
188             toRet[i] = arr[i];
189         }
190 
191         toRet[arr.length] = val;
192     }
193 
194     function appendBool(bool[] memory arr, bool val) internal pure returns (bool[] memory toRet) {
195         toRet = new bool[](arr.length + 1);
196 
197         for (uint256 i = 0; i < arr.length; i++) {
198             toRet[i] = arr[i];
199         }
200 
201         toRet[arr.length] = val;
202     }
203 
204     function appendBytes32(bytes32[] memory arr, bytes32 val) internal pure returns (bytes32[] memory toRet) {
205         toRet = new bytes32[](arr.length + 1);
206 
207         for (uint256 i = 0; i < arr.length; i++) {
208             toRet[i] = arr[i];
209         }
210 
211         toRet[arr.length] = val;
212     }
213 
214     function appendBytes32Pair(bytes32[2][] memory arr, bytes32[2] val) internal pure returns (bytes32[2][] memory toRet) {
215         toRet = new bytes32[2][](arr.length + 1);
216 
217         for (uint256 i = 0; i < arr.length; i++) {
218             toRet[i] = arr[i];
219         }
220 
221         toRet[arr.length] = val;
222     }
223 
224     function appendBytes(bytes[] memory arr, bytes val) internal pure returns (bytes[] memory toRet) {
225         toRet = new bytes[](arr.length + 1);
226 
227         for (uint256 i = 0; i < arr.length; i++) {
228             toRet[i] = arr[i];
229         }
230 
231         toRet[arr.length] = val;
232     }
233 
234     function appendAddress(address[] memory arr, address val) internal pure returns (address[] memory toRet) {
235         toRet = new address[](arr.length + 1);
236 
237         for (uint256 i = 0; i < arr.length; i++) {
238             toRet[i] = arr[i];
239         }
240 
241         toRet[arr.length] = val;
242     }
243 
244 }