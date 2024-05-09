1 pragma solidity 0.4.24;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() public {owner = msg.sender;}
18 
19     /// @notice `owner` can step down and assign some other address to this role
20     /// @param _newOwner The address of the new owner. 0x0 can be used to create
21     ///  an unowned neutral vault, however that cannot be undone
22     function changeOwner(address _newOwner) public onlyOwner {
23         owner = _newOwner;
24     }
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract Callable is Owned {
58 
59     //sender => _allowed
60     mapping(address => bool) public callers;
61 
62     //modifiers
63     modifier onlyCaller {
64         require(callers[msg.sender]);
65         _;
66     }
67 
68     //management of the repositories
69     function updateCaller(address _caller, bool allowed) public onlyOwner {
70         callers[_caller] = allowed;
71     }
72 }
73 
74 contract EternalStorage is Callable {
75 
76     mapping(bytes32 => uint) uIntStorage;
77     mapping(bytes32 => string) stringStorage;
78     mapping(bytes32 => address) addressStorage;
79     mapping(bytes32 => bytes) bytesStorage;
80     mapping(bytes32 => bool) boolStorage;
81     mapping(bytes32 => int) intStorage;
82 
83     // *** Getter Methods ***
84     function getUint(bytes32 _key) external view returns (uint) {
85         return uIntStorage[_key];
86     }
87 
88     function getString(bytes32 _key) external view returns (string) {
89         return stringStorage[_key];
90     }
91 
92     function getAddress(bytes32 _key) external view returns (address) {
93         return addressStorage[_key];
94     }
95 
96     function getBytes(bytes32 _key) external view returns (bytes) {
97         return bytesStorage[_key];
98     }
99 
100     function getBool(bytes32 _key) external view returns (bool) {
101         return boolStorage[_key];
102     }
103 
104     function getInt(bytes32 _key) external view returns (int) {
105         return intStorage[_key];
106     }
107 
108     // *** Setter Methods ***
109     function setUint(bytes32 _key, uint _value) onlyCaller external {
110         uIntStorage[_key] = _value;
111     }
112 
113     function setString(bytes32 _key, string _value) onlyCaller external {
114         stringStorage[_key] = _value;
115     }
116 
117     function setAddress(bytes32 _key, address _value) onlyCaller external {
118         addressStorage[_key] = _value;
119     }
120 
121     function setBytes(bytes32 _key, bytes _value) onlyCaller external {
122         bytesStorage[_key] = _value;
123     }
124 
125     function setBool(bytes32 _key, bool _value) onlyCaller external {
126         boolStorage[_key] = _value;
127     }
128 
129     function setInt(bytes32 _key, int _value) onlyCaller external {
130         intStorage[_key] = _value;
131     }
132 
133     // *** Delete Methods ***
134     function deleteUint(bytes32 _key) onlyCaller external {
135         delete uIntStorage[_key];
136     }
137 
138     function deleteString(bytes32 _key) onlyCaller external {
139         delete stringStorage[_key];
140     }
141 
142     function deleteAddress(bytes32 _key) onlyCaller external {
143         delete addressStorage[_key];
144     }
145 
146     function deleteBytes(bytes32 _key) onlyCaller external {
147         delete bytesStorage[_key];
148     }
149 
150     function deleteBool(bytes32 _key) onlyCaller external {
151         delete boolStorage[_key];
152     }
153 
154     function deleteInt(bytes32 _key) onlyCaller external {
155         delete intStorage[_key];
156     }
157 }
158 
159 contract ClaimRepository is Callable {
160     using SafeMath for uint256;
161 
162     EternalStorage public db;
163 
164     constructor(address _eternalStorage) public {
165         //constructor
166         require(_eternalStorage != address(0), "Eternal storage cannot be 0x0");
167         db = EternalStorage(_eternalStorage);
168     }
169 
170     function addClaim(address _solverAddress, bytes32 _platform, string _platformId, string _solver, address _token, uint256 _requestBalance) public onlyCaller returns (bool) {
171         if (db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0)) {
172             require(db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) == _solverAddress, "Adding a claim needs to happen with the same claimer as before");
173         } else {
174             db.setString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)), _solver);
175             db.setAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)), _solverAddress);
176         }
177 
178         uint tokenCount = db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
179         db.setUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)), tokenCount.add(1));
180         db.setUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)), _requestBalance);
181         db.setAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, tokenCount)), _token);
182         return true;
183     }
184 
185     function isClaimed(bytes32 _platform, string _platformId) view external returns (bool claimed) {
186         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0);
187     }
188 
189     function getSolverAddress(bytes32 _platform, string _platformId) view external returns (address solverAddress) {
190         return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)));
191     }
192 
193     function getSolver(bytes32 _platform, string _platformId) view external returns (string){
194         return db.getString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)));
195     }
196 
197     function getTokenCount(bytes32 _platform, string _platformId) view external returns (uint count) {
198         return db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));
199     }
200 
201     function getTokenByIndex(bytes32 _platform, string _platformId, uint _index) view external returns (address token) {
202         return db.getAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, _index)));
203     }
204 
205     function getAmountByToken(bytes32 _platform, string _platformId, address _token) view external returns (uint token) {
206         return db.getUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)));
207     }
208 }