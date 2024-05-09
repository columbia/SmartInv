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
149 contract BdpImageStorage is BdpBase {
150 
151 	using SafeMath for uint256;
152 
153 	struct Image {
154 		address owner;
155 		uint256 regionId;
156 		uint256 currentRegionId;
157 		mapping(uint16 => uint256[1000]) data;
158 		mapping(uint16 => uint16) dataLength;
159 		uint16 partsCount;
160 		uint16 width;
161 		uint16 height;
162 		uint16 imageDescriptor;
163 		uint256 blurredAt;
164 	}
165 
166 	uint256 public lastImageId = 0;
167 
168 	mapping(uint256 => Image) public images;
169 
170 
171 	function getLastImageId() view public returns (uint256) {
172 		return lastImageId;
173 	}
174 
175 	function getNextImageId() public storageAccessControl returns (uint256) {
176 		lastImageId = lastImageId.add(1);
177 		return lastImageId;
178 	}
179 
180 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
181 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
182 		uint256 id = getNextImageId();
183 		images[id].owner = _owner;
184 		images[id].regionId = _regionId;
185 		images[id].width = _width;
186 		images[id].height = _height;
187 		images[id].partsCount = _partsCount;
188 		images[id].imageDescriptor = _imageDescriptor;
189 		return id;
190 	}
191 
192 	function imageExists(uint256 _imageId) view public returns (bool) {
193 		return _imageId > 0 && images[_imageId].owner != address(0);
194 	}
195 
196 	function deleteImage(uint256 _imageId) public storageAccessControl {
197 		require(imageExists(_imageId));
198 		delete images[_imageId];
199 	}
200 
201 	function getImageOwner(uint256 _imageId) public view returns (address) {
202 		require(imageExists(_imageId));
203 		return images[_imageId].owner;
204 	}
205 
206 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
207 		require(imageExists(_imageId));
208 		images[_imageId].owner = _owner;
209 	}
210 
211 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
212 		require(imageExists(_imageId));
213 		return images[_imageId].regionId;
214 	}
215 
216 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
217 		require(imageExists(_imageId));
218 		images[_imageId].regionId = _regionId;
219 	}
220 
221 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
222 		require(imageExists(_imageId));
223 		return images[_imageId].currentRegionId;
224 	}
225 
226 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
227 		require(imageExists(_imageId));
228 		images[_imageId].currentRegionId = _currentRegionId;
229 	}
230 
231 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
232 		require(imageExists(_imageId));
233 		return images[_imageId].data[_part];
234 	}
235 
236 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
237 		require(imageExists(_imageId));
238 		images[_imageId].dataLength[_part] = uint16(_data.length);
239 		for (uint256 i = 0; i < _data.length; i++) {
240 			images[_imageId].data[_part][i] = _data[i];
241 		}
242 	}
243 
244 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
245 		require(imageExists(_imageId));
246 		return images[_imageId].dataLength[_part];
247 	}
248 
249 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
250 		require(imageExists(_imageId));
251 		images[_imageId].dataLength[_part] = _dataLength;
252 	}
253 
254 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
255 		require(imageExists(_imageId));
256 		return images[_imageId].partsCount;
257 	}
258 
259 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
260 		require(imageExists(_imageId));
261 		images[_imageId].partsCount = _partsCount;
262 	}
263 
264 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
265 		require(imageExists(_imageId));
266 		return images[_imageId].width;
267 	}
268 
269 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
270 		require(imageExists(_imageId));
271 		images[_imageId].width = _width;
272 	}
273 
274 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
275 		require(imageExists(_imageId));
276 		return images[_imageId].height;
277 	}
278 
279 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
280 		require(imageExists(_imageId));
281 		images[_imageId].height = _height;
282 	}
283 
284 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
285 		require(imageExists(_imageId));
286 		return images[_imageId].imageDescriptor;
287 	}
288 
289 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
290 		require(imageExists(_imageId));
291 		images[_imageId].imageDescriptor = _imageDescriptor;
292 	}
293 
294 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
295 		return images[_imageId].blurredAt;
296 	}
297 
298 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
299 		images[_imageId].blurredAt = _blurredAt;
300 	}
301 
302 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
303 		require(imageExists(_imageId));
304 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
305 			if(images[_imageId].data[i].length == 0) {
306 				return false;
307 			}
308 		}
309 		return true;
310 	}
311 
312 	function BdpImageStorage(bytes8 _version) public {
313 		ownerAddress = msg.sender;
314 		managerAddress = msg.sender;
315 		version = _version;
316 	}
317 
318 }