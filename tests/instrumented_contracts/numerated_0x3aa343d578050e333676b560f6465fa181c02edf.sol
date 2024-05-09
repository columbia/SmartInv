1 pragma solidity ^0.4.19;
2 
3 contract BdpBaseData {
4 
5 	address public ownerAddress;
6 
7 	address public managerAddress;
8 
9 	address[16] public contracts;
10 
11 	bool public paused = false;
12 
13 	bool public setupComplete = false;
14 
15 	bytes8 public version;
16 
17 }
18 library BdpContracts {
19 
20 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
21 		return _contracts[0];
22 	}
23 
24 	function getBdpController(address[16] _contracts) pure internal returns (address) {
25 		return _contracts[1];
26 	}
27 
28 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
29 		return _contracts[3];
30 	}
31 
32 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
33 		return _contracts[4];
34 	}
35 
36 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
37 		return _contracts[5];
38 	}
39 
40 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
41 		return _contracts[6];
42 	}
43 
44 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
45 		return _contracts[7];
46 	}
47 
48 }
49 
50 contract BdpBase is BdpBaseData {
51 
52 	modifier onlyOwner() {
53 		require(msg.sender == ownerAddress);
54 		_;
55 	}
56 
57 	modifier onlyAuthorized() {
58 		require(msg.sender == ownerAddress || msg.sender == managerAddress);
59 		_;
60 	}
61 
62 	modifier whenContractActive() {
63 		require(!paused && setupComplete);
64 		_;
65 	}
66 
67 	modifier storageAccessControl() {
68 		require(
69 			(! setupComplete && (msg.sender == ownerAddress || msg.sender == managerAddress))
70 			|| (setupComplete && !paused && (msg.sender == BdpContracts.getBdpEntryPoint(contracts)))
71 		);
72 		_;
73 	}
74 
75 	function setOwner(address _newOwner) external onlyOwner {
76 		require(_newOwner != address(0));
77 		ownerAddress = _newOwner;
78 	}
79 
80 	function setManager(address _newManager) external onlyOwner {
81 		require(_newManager != address(0));
82 		managerAddress = _newManager;
83 	}
84 
85 	function setContracts(address[16] _contracts) external onlyOwner {
86 		contracts = _contracts;
87 	}
88 
89 	function pause() external onlyAuthorized {
90 		paused = true;
91 	}
92 
93 	function unpause() external onlyOwner {
94 		paused = false;
95 	}
96 
97 	function setSetupComplete() external onlyOwner {
98 		setupComplete = true;
99 	}
100 
101 	function kill() public onlyOwner {
102 		selfdestruct(ownerAddress);
103 	}
104 
105 }
106 
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 
150 contract BdpOwnershipStorage is BdpBase {
151 
152 	using SafeMath for uint256;
153 
154 	// Mapping from token ID to owner
155 	mapping (uint256 => address) public tokenOwner;
156 
157 	// Mapping from token ID to approved address
158 	mapping (uint256 => address) public tokenApprovals;
159 
160 	// Mapping from owner to the sum of owned area
161 	mapping (address => uint256) public ownedArea;
162 
163 	// Mapping from owner to list of owned token IDs
164 	mapping (address => uint256[]) public ownedTokens;
165 
166 	// Mapping from token ID to index of the owner tokens list
167 	mapping(uint256 => uint256) public ownedTokensIndex;
168 
169 	// All tokens list tokens ids
170 	uint256[] public tokenIds;
171 
172 	// Mapping from tokenId to index of the tokens list
173 	mapping (uint256 => uint256) public tokenIdsIndex;
174 
175 
176 	function getTokenOwner(uint256 _tokenId) view public returns (address) {
177 		return tokenOwner[_tokenId];
178 	}
179 
180 	function setTokenOwner(uint256 _tokenId, address _owner) public storageAccessControl {
181 		tokenOwner[_tokenId] = _owner;
182 	}
183 
184 	function getTokenApproval(uint256 _tokenId) view public returns (address) {
185 		return tokenApprovals[_tokenId];
186 	}
187 
188 	function setTokenApproval(uint256 _tokenId, address _to) public storageAccessControl {
189 		tokenApprovals[_tokenId] = _to;
190 	}
191 
192 	function getOwnedArea(address _owner) view public returns (uint256) {
193 		return ownedArea[_owner];
194 	}
195 
196 	function setOwnedArea(address _owner, uint256 _area) public storageAccessControl {
197 		ownedArea[_owner] = _area;
198 	}
199 
200 	function incrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
201 		ownedArea[_owner] = ownedArea[_owner].add(_area);
202 		return ownedArea[_owner];
203 	}
204 
205 	function decrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
206 		ownedArea[_owner] = ownedArea[_owner].sub(_area);
207 		return ownedArea[_owner];
208 	}
209 
210 	function getOwnedTokensLength(address _owner) view public returns (uint256) {
211 		return ownedTokens[_owner].length;
212 	}
213 
214 	function getOwnedToken(address _owner, uint256 _index) view public returns (uint256) {
215 		return ownedTokens[_owner][_index];
216 	}
217 
218 	function setOwnedToken(address _owner, uint256 _index, uint256 _tokenId) public storageAccessControl {
219 		ownedTokens[_owner][_index] = _tokenId;
220 	}
221 
222 	function pushOwnedToken(address _owner, uint256 _tokenId) public storageAccessControl returns (uint256) {
223 		ownedTokens[_owner].push(_tokenId);
224 		return ownedTokens[_owner].length;
225 	}
226 
227 	function decrementOwnedTokensLength(address _owner) public storageAccessControl {
228 		ownedTokens[_owner].length--;
229 	}
230 
231 	function getOwnedTokensIndex(uint256 _tokenId) view public returns (uint256) {
232 		return ownedTokensIndex[_tokenId];
233 	}
234 
235 	function setOwnedTokensIndex(uint256 _tokenId, uint256 _tokenIndex) public storageAccessControl {
236 		ownedTokensIndex[_tokenId] = _tokenIndex;
237 	}
238 
239 	function getTokenIdsLength() view public returns (uint256) {
240 		return tokenIds.length;
241 	}
242 
243 	function getTokenIdByIndex(uint256 _index) view public returns (uint256) {
244 		return tokenIds[_index];
245 	}
246 
247 	function setTokenIdByIndex(uint256 _index, uint256 _tokenId) public storageAccessControl {
248 		tokenIds[_index] = _tokenId;
249 	}
250 
251 	function pushTokenId(uint256 _tokenId) public storageAccessControl returns (uint256) {
252 		tokenIds.push(_tokenId);
253 		return tokenIds.length;
254 	}
255 
256 	function decrementTokenIdsLength() public storageAccessControl {
257 		tokenIds.length--;
258 	}
259 
260 	function getTokenIdsIndex(uint256 _tokenId) view public returns (uint256) {
261 		return tokenIdsIndex[_tokenId];
262 	}
263 
264 	function setTokenIdsIndex(uint256 _tokenId, uint256 _tokenIdIndex) public storageAccessControl {
265 		tokenIdsIndex[_tokenId] = _tokenIdIndex;
266 	}
267 
268 	function BdpOwnershipStorage(bytes8 _version) public {
269 		ownerAddress = msg.sender;
270 		managerAddress = msg.sender;
271 		version = _version;
272 	}
273 
274 }