1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
34 ///  later changed
35 contract Owned {
36 
37     /// @dev `owner` is the only address that can call a function with this
38     /// modifier
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     address public owner;
45 
46     /// @notice The Constructor assigns the message sender to be `owner`
47     function Owned() public {owner = msg.sender;}
48 
49     /// @notice `owner` can step down and assign some other address to this role
50     /// @param _newOwner The address of the new owner. 0x0 can be used to create
51     ///  an unowned neutral vault, however that cannot be undone
52     function changeOwner(address _newOwner) public onlyOwner {
53         owner = _newOwner;
54     }
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
159 /*
160  * Database Contract
161  * Davy Van Roy
162  * Quinten De Swaef
163  */
164 contract FundRepository is Callable {
165 
166     using SafeMath for uint256;
167 
168     EternalStorage public db;
169 
170     //platform -> platformId => _funding
171     mapping(bytes32 => mapping(string => Funding)) funds;
172 
173     struct Funding {
174         address[] funders; //funders that funded tokens
175         address[] tokens; //tokens that were funded
176         mapping(address => TokenFunding) tokenFunding;
177     }
178 
179     struct TokenFunding {
180         mapping(address => uint256) balance;
181         uint256 totalTokenBalance;
182     }
183 
184     constructor(address _eternalStorage) public {
185         db = EternalStorage(_eternalStorage);
186     }
187 
188     function updateFunders(address _from, bytes32 _platform, string _platformId) public onlyCaller {
189         bool existing = db.getBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)));
190         if (!existing) {
191             uint funderCount = getFunderCount(_platform, _platformId);
192             db.setAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, funderCount)), _from);
193             db.setUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)), funderCount.add(1));
194         }
195     }
196 
197     function updateBalances(address _from, bytes32 _platform, string _platformId, address _token, uint256 _value) public onlyCaller {
198         if (db.getBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token))) == false) {
199             db.setBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token)), true);
200             //add to the list of tokens for this platformId
201             uint tokenCount = getFundedTokenCount(_platform, _platformId);
202             db.setAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, tokenCount)), _token);
203             db.setUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)), tokenCount.add(1));
204         }
205 
206         //add to the balance of this platformId for this token
207         db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), balance(_platform, _platformId, _token).add(_value));
208 
209         //add to the balance the user has funded for the request
210         db.setUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _from, _token)), amountFunded(_platform, _platformId, _from, _token).add(_value));
211 
212         //add the fact that the user has now funded this platformId
213         db.setBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)), true);
214     }
215 
216     function claimToken(bytes32 platform, string platformId, address _token) public onlyCaller returns (uint256) {
217         require(!issueResolved(platform, platformId), "Can't claim token, issue is already resolved.");
218         uint256 totalTokenBalance = balance(platform, platformId, _token);
219         db.deleteUint(keccak256(abi.encodePacked("funds.tokenBalance", platform, platformId, _token)));
220         return totalTokenBalance;
221     }
222 
223     function refundToken(bytes32 _platform, string _platformId, address _owner, address _token) public onlyCaller returns (uint256) {
224         require(!issueResolved(_platform, _platformId), "Can't refund token, issue is already resolved.");
225 
226         //delete amount from user, so he can't refund again
227         uint256 userTokenBalance = amountFunded(_platform, _platformId, _owner, _token);
228         db.deleteUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _owner, _token)));
229 
230 
231         uint256 oldBalance = balance(_platform, _platformId, _token);
232         uint256 newBalance = oldBalance.sub(userTokenBalance);
233 
234         require(newBalance <= oldBalance);
235 
236         //subtract amount from tokenBalance
237         db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), newBalance);
238 
239         return userTokenBalance;
240     }
241 
242     function finishResolveFund(bytes32 platform, string platformId) public onlyCaller returns (bool) {
243         db.setBool(keccak256(abi.encodePacked("funds.issueResolved", platform, platformId)), true);
244         db.deleteUint(keccak256(abi.encodePacked("funds.funderCount", platform, platformId)));
245         return true;
246     }
247 
248     //constants
249     function getFundInfo(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256, uint256, uint256) {
250         return (
251         getFunderCount(_platform, _platformId),
252         balance(_platform, _platformId, _token),
253         amountFunded(_platform, _platformId, _funder, _token)
254         );
255     }
256 
257     function issueResolved(bytes32 _platform, string _platformId) public view returns (bool) {
258         return db.getBool(keccak256(abi.encodePacked("funds.issueResolved", _platform, _platformId)));
259     }
260 
261     function getFundedTokenCount(bytes32 _platform, string _platformId) public view returns (uint256) {
262         return db.getUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)));
263     }
264 
265     function getFundedTokensByIndex(bytes32 _platform, string _platformId, uint _index) public view returns (address) {
266         return db.getAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _index)));
267     }
268 
269     function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint) {
270         return db.getUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)));
271     }
272 
273     function getFunderByIndex(bytes32 _platform, string _platformId, uint index) external view returns (address) {
274         return db.getAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, index)));
275     }
276 
277     function amountFunded(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256) {
278         return db.getUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _funder, _token)));
279     }
280 
281     function balance(bytes32 _platform, string _platformId, address _token) view public returns (uint256) {
282         return db.getUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)));
283     }
284 }