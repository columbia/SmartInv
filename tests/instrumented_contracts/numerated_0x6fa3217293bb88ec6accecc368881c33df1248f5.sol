1 pragma solidity ^0.4.19;
2 
3 // File: contracts/BdpBaseData.sol
4 
5 contract BdpBaseData {
6 
7 	address public ownerAddress;
8 
9 	address public managerAddress;
10 
11 	address[16] public contracts;
12 
13 	bool public paused = false;
14 
15 	bool public setupCompleted = false;
16 
17 	bytes8 public version;
18 
19 }
20 
21 // File: contracts/libraries/BdpContracts.sol
22 
23 library BdpContracts {
24 
25 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
26 		return _contracts[0];
27 	}
28 
29 	function getBdpController(address[16] _contracts) pure internal returns (address) {
30 		return _contracts[1];
31 	}
32 
33 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
34 		return _contracts[3];
35 	}
36 
37 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
38 		return _contracts[4];
39 	}
40 
41 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
42 		return _contracts[5];
43 	}
44 
45 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
46 		return _contracts[6];
47 	}
48 
49 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
50 		return _contracts[7];
51 	}
52 
53 }
54 
55 // File: contracts/BdpBase.sol
56 
57 contract BdpBase is BdpBaseData {
58 
59 	modifier onlyOwner() {
60 		require(msg.sender == ownerAddress);
61 		_;
62 	}
63 
64 	modifier onlyAuthorized() {
65 		require(msg.sender == ownerAddress || msg.sender == managerAddress);
66 		_;
67 	}
68 
69 	modifier whileContractIsActive() {
70 		require(!paused && setupCompleted);
71 		_;
72 	}
73 
74 	modifier storageAccessControl() {
75 		require(
76 			(! setupCompleted && (msg.sender == ownerAddress || msg.sender == managerAddress))
77 			|| (setupCompleted && !paused && (msg.sender == BdpContracts.getBdpEntryPoint(contracts)))
78 		);
79 		_;
80 	}
81 
82 	function setOwner(address _newOwner) external onlyOwner {
83 		require(_newOwner != address(0));
84 		ownerAddress = _newOwner;
85 	}
86 
87 	function setManager(address _newManager) external onlyOwner {
88 		require(_newManager != address(0));
89 		managerAddress = _newManager;
90 	}
91 
92 	function setContracts(address[16] _contracts) external onlyOwner {
93 		contracts = _contracts;
94 	}
95 
96 	function pause() external onlyAuthorized {
97 		paused = true;
98 	}
99 
100 	function unpause() external onlyOwner {
101 		paused = false;
102 	}
103 
104 	function setSetupCompleted() external onlyOwner {
105 		setupCompleted = true;
106 	}
107 
108 	function kill() public onlyOwner {
109 		selfdestruct(ownerAddress);
110 	}
111 
112 }
113 
114 // File: contracts/libraries/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122 	/**
123 	* @dev Multiplies two numbers, throws on overflow.
124 	*/
125 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126 		if (a == 0) {
127 			return 0;
128 		}
129 		uint256 c = a * b;
130 		assert(c / a == b);
131 		return c;
132 	}
133 
134 	/**
135 	* @dev Integer division of two numbers, truncating the quotient.
136 	*/
137 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
138 		// assert(b > 0); // Solidity automatically throws when dividing by 0
139 		uint256 c = a / b;
140 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 		return c;
142 	}
143 
144 	/**
145 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146 	*/
147 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148 		assert(b <= a);
149 		return a - b;
150 	}
151 
152 	/**
153 	* @dev Adds two numbers, throws on overflow.
154 	*/
155 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
156 		uint256 c = a + b;
157 		assert(c >= a);
158 		return c;
159 	}
160 }
161 
162 // File: contracts/storage/BdpOwnershipStorage.sol
163 
164 contract BdpOwnershipStorage is BdpBase {
165 
166 	using SafeMath for uint256;
167 
168 	// Mapping from token ID to owner
169 	mapping (uint256 => address) public tokenOwner;
170 
171 	// Mapping from token ID to approved address
172 	mapping (uint256 => address) public tokenApprovals;
173 
174 	// Mapping from owner to the sum of owned area
175 	mapping (address => uint256) public ownedArea;
176 
177 	// Mapping from owner to list of owned token IDs
178 	mapping (address => uint256[]) public ownedTokens;
179 
180 	// Mapping from token ID to index of the owner tokens list
181 	mapping(uint256 => uint256) public ownedTokensIndex;
182 
183 	// All tokens list tokens ids
184 	uint256[] public tokenIds;
185 
186 	// Mapping from tokenId to index of the tokens list
187 	mapping (uint256 => uint256) public tokenIdsIndex;
188 
189 
190 	function getTokenOwner(uint256 _tokenId) view public returns (address) {
191 		return tokenOwner[_tokenId];
192 	}
193 
194 	function setTokenOwner(uint256 _tokenId, address _owner) public storageAccessControl {
195 		tokenOwner[_tokenId] = _owner;
196 	}
197 
198 	function getTokenApproval(uint256 _tokenId) view public returns (address) {
199 		return tokenApprovals[_tokenId];
200 	}
201 
202 	function setTokenApproval(uint256 _tokenId, address _to) public storageAccessControl {
203 		tokenApprovals[_tokenId] = _to;
204 	}
205 
206 	function getOwnedArea(address _owner) view public returns (uint256) {
207 		return ownedArea[_owner];
208 	}
209 
210 	function setOwnedArea(address _owner, uint256 _area) public storageAccessControl {
211 		ownedArea[_owner] = _area;
212 	}
213 
214 	function incrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
215 		ownedArea[_owner] = ownedArea[_owner].add(_area);
216 		return ownedArea[_owner];
217 	}
218 
219 	function decrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
220 		ownedArea[_owner] = ownedArea[_owner].sub(_area);
221 		return ownedArea[_owner];
222 	}
223 
224 	function getOwnedTokensLength(address _owner) view public returns (uint256) {
225 		return ownedTokens[_owner].length;
226 	}
227 
228 	function getOwnedToken(address _owner, uint256 _index) view public returns (uint256) {
229 		return ownedTokens[_owner][_index];
230 	}
231 
232 	function setOwnedToken(address _owner, uint256 _index, uint256 _tokenId) public storageAccessControl {
233 		ownedTokens[_owner][_index] = _tokenId;
234 	}
235 
236 	function pushOwnedToken(address _owner, uint256 _tokenId) public storageAccessControl returns (uint256) {
237 		ownedTokens[_owner].push(_tokenId);
238 		return ownedTokens[_owner].length;
239 	}
240 
241 	function decrementOwnedTokensLength(address _owner) public storageAccessControl {
242 		ownedTokens[_owner].length--;
243 	}
244 
245 	function getOwnedTokensIndex(uint256 _tokenId) view public returns (uint256) {
246 		return ownedTokensIndex[_tokenId];
247 	}
248 
249 	function setOwnedTokensIndex(uint256 _tokenId, uint256 _tokenIndex) public storageAccessControl {
250 		ownedTokensIndex[_tokenId] = _tokenIndex;
251 	}
252 
253 	function getTokenIdsLength() view public returns (uint256) {
254 		return tokenIds.length;
255 	}
256 
257 	function getTokenIdByIndex(uint256 _index) view public returns (uint256) {
258 		return tokenIds[_index];
259 	}
260 
261 	function setTokenIdByIndex(uint256 _index, uint256 _tokenId) public storageAccessControl {
262 		tokenIds[_index] = _tokenId;
263 	}
264 
265 	function pushTokenId(uint256 _tokenId) public storageAccessControl returns (uint256) {
266 		tokenIds.push(_tokenId);
267 		return tokenIds.length;
268 	}
269 
270 	function decrementTokenIdsLength() public storageAccessControl {
271 		tokenIds.length--;
272 	}
273 
274 	function getTokenIdsIndex(uint256 _tokenId) view public returns (uint256) {
275 		return tokenIdsIndex[_tokenId];
276 	}
277 
278 	function setTokenIdsIndex(uint256 _tokenId, uint256 _tokenIdIndex) public storageAccessControl {
279 		tokenIdsIndex[_tokenId] = _tokenIdIndex;
280 	}
281 
282 	function BdpOwnershipStorage(bytes8 _version) public {
283 		ownerAddress = msg.sender;
284 		managerAddress = msg.sender;
285 		version = _version;
286 	}
287 
288 }