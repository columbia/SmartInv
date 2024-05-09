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
162 // File: contracts/storage/BdpImageStorage.sol
163 
164 contract BdpImageStorage is BdpBase {
165 
166 	using SafeMath for uint256;
167 
168 	struct Image {
169 		address owner;
170 		uint256 regionId;
171 		uint256 currentRegionId;
172 		mapping(uint16 => uint256[1000]) data;
173 		mapping(uint16 => uint16) dataLength;
174 		uint16 partsCount;
175 		uint16 width;
176 		uint16 height;
177 		uint16 imageDescriptor;
178 		uint256 blurredAt;
179 	}
180 
181 	uint256 public lastImageId = 0;
182 
183 	mapping(uint256 => Image) public images;
184 
185 
186 	function getLastImageId() view public returns (uint256) {
187 		return lastImageId;
188 	}
189 
190 	function getNextImageId() public storageAccessControl returns (uint256) {
191 		lastImageId = lastImageId.add(1);
192 		return lastImageId;
193 	}
194 
195 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
196 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
197 		uint256 id = getNextImageId();
198 		images[id].owner = _owner;
199 		images[id].regionId = _regionId;
200 		images[id].width = _width;
201 		images[id].height = _height;
202 		images[id].partsCount = _partsCount;
203 		images[id].imageDescriptor = _imageDescriptor;
204 		return id;
205 	}
206 
207 	function imageExists(uint256 _imageId) view public returns (bool) {
208 		return _imageId > 0 && images[_imageId].owner != address(0);
209 	}
210 
211 	function deleteImage(uint256 _imageId) public storageAccessControl {
212 		require(imageExists(_imageId));
213 		delete images[_imageId];
214 	}
215 
216 	function getImageOwner(uint256 _imageId) public view returns (address) {
217 		require(imageExists(_imageId));
218 		return images[_imageId].owner;
219 	}
220 
221 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
222 		require(imageExists(_imageId));
223 		images[_imageId].owner = _owner;
224 	}
225 
226 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
227 		require(imageExists(_imageId));
228 		return images[_imageId].regionId;
229 	}
230 
231 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
232 		require(imageExists(_imageId));
233 		images[_imageId].regionId = _regionId;
234 	}
235 
236 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
237 		require(imageExists(_imageId));
238 		return images[_imageId].currentRegionId;
239 	}
240 
241 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
242 		require(imageExists(_imageId));
243 		images[_imageId].currentRegionId = _currentRegionId;
244 	}
245 
246 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
247 		require(imageExists(_imageId));
248 		return images[_imageId].data[_part];
249 	}
250 
251 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
252 		require(imageExists(_imageId));
253 		images[_imageId].dataLength[_part] = uint16(_data.length);
254 		for (uint256 i = 0; i < _data.length; i++) {
255 			images[_imageId].data[_part][i] = _data[i];
256 		}
257 	}
258 
259 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
260 		require(imageExists(_imageId));
261 		return images[_imageId].dataLength[_part];
262 	}
263 
264 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
265 		require(imageExists(_imageId));
266 		images[_imageId].dataLength[_part] = _dataLength;
267 	}
268 
269 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
270 		require(imageExists(_imageId));
271 		return images[_imageId].partsCount;
272 	}
273 
274 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
275 		require(imageExists(_imageId));
276 		images[_imageId].partsCount = _partsCount;
277 	}
278 
279 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
280 		require(imageExists(_imageId));
281 		return images[_imageId].width;
282 	}
283 
284 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
285 		require(imageExists(_imageId));
286 		images[_imageId].width = _width;
287 	}
288 
289 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
290 		require(imageExists(_imageId));
291 		return images[_imageId].height;
292 	}
293 
294 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
295 		require(imageExists(_imageId));
296 		images[_imageId].height = _height;
297 	}
298 
299 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
300 		require(imageExists(_imageId));
301 		return images[_imageId].imageDescriptor;
302 	}
303 
304 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
305 		require(imageExists(_imageId));
306 		images[_imageId].imageDescriptor = _imageDescriptor;
307 	}
308 
309 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
310 		return images[_imageId].blurredAt;
311 	}
312 
313 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
314 		images[_imageId].blurredAt = _blurredAt;
315 	}
316 
317 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
318 		require(imageExists(_imageId));
319 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
320 			if(images[_imageId].data[i].length == 0) {
321 				return false;
322 			}
323 		}
324 		return true;
325 	}
326 
327 	function BdpImageStorage(bytes8 _version) public {
328 		ownerAddress = msg.sender;
329 		managerAddress = msg.sender;
330 		version = _version;
331 	}
332 
333 }