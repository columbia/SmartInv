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
149 contract BdpDataStorage is BdpBase {
150 
151 	using SafeMath for uint256;
152 
153 	struct Region {
154 		uint256 x1;
155 		uint256 y1;
156 		uint256 x2;
157 		uint256 y2;
158 		uint256 currentImageId;
159 		uint256 nextImageId;
160 		uint8[128] url;
161 		uint256 currentPixelPrice;
162 		uint256 blockUpdatedAt;
163 		uint256 updatedAt;
164 		uint256 purchasedAt;
165 		uint256 purchasedPixelPrice;
166 	}
167 
168 	uint256 public lastRegionId = 0;
169 
170 	mapping (uint256 => Region) public data;
171 
172 
173 	function getLastRegionId() view public returns (uint256) {
174 		return lastRegionId;
175 	}
176 
177 	function getNextRegionId() public storageAccessControl returns (uint256) {
178 		lastRegionId = lastRegionId.add(1);
179 		return lastRegionId;
180 	}
181 
182 	function deleteRegionData(uint256 _id) public storageAccessControl {
183 		delete data[_id];
184 	}
185 
186 	function getRegionCoordinates(uint256 _id) view public returns (uint256, uint256, uint256, uint256) {
187 		return (data[_id].x1, data[_id].y1, data[_id].x2, data[_id].y2);
188 	}
189 
190 	function setRegionCoordinates(uint256 _id, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public storageAccessControl {
191 		data[_id].x1 = _x1;
192 		data[_id].y1 = _y1;
193 		data[_id].x2 = _x2;
194 		data[_id].y2 = _y2;
195 	}
196 
197 	function getRegionCurrentImageId(uint256 _id) view public returns (uint256) {
198 		return data[_id].currentImageId;
199 	}
200 
201 	function setRegionCurrentImageId(uint256 _id, uint256 _currentImageId) public storageAccessControl {
202 		data[_id].currentImageId = _currentImageId;
203 	}
204 
205 	function getRegionNextImageId(uint256 _id) view public returns (uint256) {
206 		return data[_id].nextImageId;
207 	}
208 
209 	function setRegionNextImageId(uint256 _id, uint256 _nextImageId) public storageAccessControl {
210 		data[_id].nextImageId = _nextImageId;
211 	}
212 
213 	function getRegionUrl(uint256 _id) view public returns (uint8[128]) {
214 		return data[_id].url;
215 	}
216 
217 	function setRegionUrl(uint256 _id, uint8[128] _url) public storageAccessControl {
218 		data[_id].url = _url;
219 	}
220 
221 	function getRegionCurrentPixelPrice(uint256 _id) view public returns (uint256) {
222 		return data[_id].currentPixelPrice;
223 	}
224 
225 	function setRegionCurrentPixelPrice(uint256 _id, uint256 _currentPixelPrice) public storageAccessControl {
226 		data[_id].currentPixelPrice = _currentPixelPrice;
227 	}
228 
229 	function getRegionBlockUpdatedAt(uint256 _id) view public returns (uint256) {
230 		return data[_id].blockUpdatedAt;
231 	}
232 
233 	function setRegionBlockUpdatedAt(uint256 _id, uint256 _blockUpdatedAt) public storageAccessControl {
234 		data[_id].blockUpdatedAt = _blockUpdatedAt;
235 	}
236 
237 	function getRegionUpdatedAt(uint256 _id) view public returns (uint256) {
238 		return data[_id].updatedAt;
239 	}
240 
241 	function setRegionUpdatedAt(uint256 _id, uint256 _updatedAt) public storageAccessControl {
242 		data[_id].updatedAt = _updatedAt;
243 	}
244 
245 	function getRegionPurchasedAt(uint256 _id) view public returns (uint256) {
246 		return data[_id].purchasedAt;
247 	}
248 
249 	function setRegionPurchasedAt(uint256 _id, uint256 _purchasedAt) public storageAccessControl {
250 		data[_id].purchasedAt = _purchasedAt;
251 	}
252 
253 	function getRegionUpdatedAtPurchasedAt(uint256 _id) view public returns (uint256 _updatedAt, uint256 _purchasedAt) {
254 		return (data[_id].updatedAt, data[_id].purchasedAt);
255 	}
256 
257 	function getRegionPurchasePixelPrice(uint256 _id) view public returns (uint256) {
258 		return data[_id].purchasedPixelPrice;
259 	}
260 
261 	function setRegionPurchasedPixelPrice(uint256 _id, uint256 _purchasedPixelPrice) public storageAccessControl {
262 		data[_id].purchasedPixelPrice = _purchasedPixelPrice;
263 	}
264 
265 	function BdpDataStorage(bytes8 _version) public {
266 		ownerAddress = msg.sender;
267 		managerAddress = msg.sender;
268 		version = _version;
269 	}
270 
271 }