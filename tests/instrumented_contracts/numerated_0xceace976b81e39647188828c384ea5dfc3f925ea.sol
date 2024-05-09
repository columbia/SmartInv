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
162 // File: contracts/storage/BdpDataStorage.sol
163 
164 contract BdpDataStorage is BdpBase {
165 
166 	using SafeMath for uint256;
167 
168 	struct Region {
169 		uint256 x1;
170 		uint256 y1;
171 		uint256 x2;
172 		uint256 y2;
173 		uint256 currentImageId;
174 		uint256 nextImageId;
175 		uint8[128] url;
176 		uint256 currentPixelPrice;
177 		uint256 blockUpdatedAt;
178 		uint256 updatedAt;
179 		uint256 purchasedAt;
180 		uint256 purchasedPixelPrice;
181 	}
182 
183 	uint256 public lastRegionId = 0;
184 
185 	mapping (uint256 => Region) public data;
186 
187 
188 	function getLastRegionId() view public returns (uint256) {
189 		return lastRegionId;
190 	}
191 
192 	function getNextRegionId() public storageAccessControl returns (uint256) {
193 		lastRegionId = lastRegionId.add(1);
194 		return lastRegionId;
195 	}
196 
197 	function deleteRegionData(uint256 _id) public storageAccessControl {
198 		delete data[_id];
199 	}
200 
201 	function getRegionCoordinates(uint256 _id) view public returns (uint256, uint256, uint256, uint256) {
202 		return (data[_id].x1, data[_id].y1, data[_id].x2, data[_id].y2);
203 	}
204 
205 	function setRegionCoordinates(uint256 _id, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public storageAccessControl {
206 		data[_id].x1 = _x1;
207 		data[_id].y1 = _y1;
208 		data[_id].x2 = _x2;
209 		data[_id].y2 = _y2;
210 	}
211 
212 	function getRegionCurrentImageId(uint256 _id) view public returns (uint256) {
213 		return data[_id].currentImageId;
214 	}
215 
216 	function setRegionCurrentImageId(uint256 _id, uint256 _currentImageId) public storageAccessControl {
217 		data[_id].currentImageId = _currentImageId;
218 	}
219 
220 	function getRegionNextImageId(uint256 _id) view public returns (uint256) {
221 		return data[_id].nextImageId;
222 	}
223 
224 	function setRegionNextImageId(uint256 _id, uint256 _nextImageId) public storageAccessControl {
225 		data[_id].nextImageId = _nextImageId;
226 	}
227 
228 	function getRegionUrl(uint256 _id) view public returns (uint8[128]) {
229 		return data[_id].url;
230 	}
231 
232 	function setRegionUrl(uint256 _id, uint8[128] _url) public storageAccessControl {
233 		data[_id].url = _url;
234 	}
235 
236 	function getRegionCurrentPixelPrice(uint256 _id) view public returns (uint256) {
237 		return data[_id].currentPixelPrice;
238 	}
239 
240 	function setRegionCurrentPixelPrice(uint256 _id, uint256 _currentPixelPrice) public storageAccessControl {
241 		data[_id].currentPixelPrice = _currentPixelPrice;
242 	}
243 
244 	function getRegionBlockUpdatedAt(uint256 _id) view public returns (uint256) {
245 		return data[_id].blockUpdatedAt;
246 	}
247 
248 	function setRegionBlockUpdatedAt(uint256 _id, uint256 _blockUpdatedAt) public storageAccessControl {
249 		data[_id].blockUpdatedAt = _blockUpdatedAt;
250 	}
251 
252 	function getRegionUpdatedAt(uint256 _id) view public returns (uint256) {
253 		return data[_id].updatedAt;
254 	}
255 
256 	function setRegionUpdatedAt(uint256 _id, uint256 _updatedAt) public storageAccessControl {
257 		data[_id].updatedAt = _updatedAt;
258 	}
259 
260 	function getRegionPurchasedAt(uint256 _id) view public returns (uint256) {
261 		return data[_id].purchasedAt;
262 	}
263 
264 	function setRegionPurchasedAt(uint256 _id, uint256 _purchasedAt) public storageAccessControl {
265 		data[_id].purchasedAt = _purchasedAt;
266 	}
267 
268 	function getRegionUpdatedAtPurchasedAt(uint256 _id) view public returns (uint256 _updatedAt, uint256 _purchasedAt) {
269 		return (data[_id].updatedAt, data[_id].purchasedAt);
270 	}
271 
272 	function getRegionPurchasePixelPrice(uint256 _id) view public returns (uint256) {
273 		return data[_id].purchasedPixelPrice;
274 	}
275 
276 	function setRegionPurchasedPixelPrice(uint256 _id, uint256 _purchasedPixelPrice) public storageAccessControl {
277 		data[_id].purchasedPixelPrice = _purchasedPixelPrice;
278 	}
279 
280 	function BdpDataStorage(bytes8 _version) public {
281 		ownerAddress = msg.sender;
282 		managerAddress = msg.sender;
283 		version = _version;
284 	}
285 
286 }