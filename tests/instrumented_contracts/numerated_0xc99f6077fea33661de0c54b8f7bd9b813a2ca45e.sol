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
287 
288 // File: contracts/storage/BdpImageStorage.sol
289 
290 contract BdpImageStorage is BdpBase {
291 
292 	using SafeMath for uint256;
293 
294 	struct Image {
295 		address owner;
296 		uint256 regionId;
297 		uint256 currentRegionId;
298 		mapping(uint16 => uint256[1000]) data;
299 		mapping(uint16 => uint16) dataLength;
300 		uint16 partsCount;
301 		uint16 width;
302 		uint16 height;
303 		uint16 imageDescriptor;
304 		uint256 blurredAt;
305 	}
306 
307 	uint256 public lastImageId = 0;
308 
309 	mapping(uint256 => Image) public images;
310 
311 
312 	function getLastImageId() view public returns (uint256) {
313 		return lastImageId;
314 	}
315 
316 	function getNextImageId() public storageAccessControl returns (uint256) {
317 		lastImageId = lastImageId.add(1);
318 		return lastImageId;
319 	}
320 
321 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
322 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
323 		uint256 id = getNextImageId();
324 		images[id].owner = _owner;
325 		images[id].regionId = _regionId;
326 		images[id].width = _width;
327 		images[id].height = _height;
328 		images[id].partsCount = _partsCount;
329 		images[id].imageDescriptor = _imageDescriptor;
330 		return id;
331 	}
332 
333 	function imageExists(uint256 _imageId) view public returns (bool) {
334 		return _imageId > 0 && images[_imageId].owner != address(0);
335 	}
336 
337 	function deleteImage(uint256 _imageId) public storageAccessControl {
338 		require(imageExists(_imageId));
339 		delete images[_imageId];
340 	}
341 
342 	function getImageOwner(uint256 _imageId) public view returns (address) {
343 		require(imageExists(_imageId));
344 		return images[_imageId].owner;
345 	}
346 
347 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
348 		require(imageExists(_imageId));
349 		images[_imageId].owner = _owner;
350 	}
351 
352 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
353 		require(imageExists(_imageId));
354 		return images[_imageId].regionId;
355 	}
356 
357 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
358 		require(imageExists(_imageId));
359 		images[_imageId].regionId = _regionId;
360 	}
361 
362 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
363 		require(imageExists(_imageId));
364 		return images[_imageId].currentRegionId;
365 	}
366 
367 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
368 		require(imageExists(_imageId));
369 		images[_imageId].currentRegionId = _currentRegionId;
370 	}
371 
372 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
373 		require(imageExists(_imageId));
374 		return images[_imageId].data[_part];
375 	}
376 
377 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
378 		require(imageExists(_imageId));
379 		images[_imageId].dataLength[_part] = uint16(_data.length);
380 		for (uint256 i = 0; i < _data.length; i++) {
381 			images[_imageId].data[_part][i] = _data[i];
382 		}
383 	}
384 
385 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
386 		require(imageExists(_imageId));
387 		return images[_imageId].dataLength[_part];
388 	}
389 
390 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
391 		require(imageExists(_imageId));
392 		images[_imageId].dataLength[_part] = _dataLength;
393 	}
394 
395 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
396 		require(imageExists(_imageId));
397 		return images[_imageId].partsCount;
398 	}
399 
400 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
401 		require(imageExists(_imageId));
402 		images[_imageId].partsCount = _partsCount;
403 	}
404 
405 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
406 		require(imageExists(_imageId));
407 		return images[_imageId].width;
408 	}
409 
410 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
411 		require(imageExists(_imageId));
412 		images[_imageId].width = _width;
413 	}
414 
415 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
416 		require(imageExists(_imageId));
417 		return images[_imageId].height;
418 	}
419 
420 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
421 		require(imageExists(_imageId));
422 		images[_imageId].height = _height;
423 	}
424 
425 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
426 		require(imageExists(_imageId));
427 		return images[_imageId].imageDescriptor;
428 	}
429 
430 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
431 		require(imageExists(_imageId));
432 		images[_imageId].imageDescriptor = _imageDescriptor;
433 	}
434 
435 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
436 		return images[_imageId].blurredAt;
437 	}
438 
439 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
440 		images[_imageId].blurredAt = _blurredAt;
441 	}
442 
443 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
444 		require(imageExists(_imageId));
445 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
446 			if(images[_imageId].data[i].length == 0) {
447 				return false;
448 			}
449 		}
450 		return true;
451 	}
452 
453 	function BdpImageStorage(bytes8 _version) public {
454 		ownerAddress = msg.sender;
455 		managerAddress = msg.sender;
456 		version = _version;
457 	}
458 
459 }
460 
461 // File: contracts/storage/BdpPriceStorage.sol
462 
463 contract BdpPriceStorage is BdpBase {
464 
465 	uint64[1001] public pricePoints;
466 
467 	uint256 public pricePointsLength = 0;
468 
469 	address public forwardPurchaseFeesTo = address(0);
470 
471 	address public forwardUpdateFeesTo = address(0);
472 
473 
474 	function getPricePointsLength() view public returns (uint256) {
475 		return pricePointsLength;
476 	}
477 
478 	function getPricePoint(uint256 _i) view public returns (uint256) {
479 		return pricePoints[_i];
480 	}
481 
482 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
483 		pricePointsLength = 0;
484 		appendPricePoints(_pricePoints);
485 	}
486 
487 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
488 		for (uint i = 0; i < _pricePoints.length; i++) {
489 			pricePoints[pricePointsLength++] = _pricePoints[i];
490 		}
491 	}
492 
493 	function getForwardPurchaseFeesTo() view public returns (address) {
494 		return forwardPurchaseFeesTo;
495 	}
496 
497 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
498 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
499 	}
500 
501 	function getForwardUpdateFeesTo() view public returns (address) {
502 		return forwardUpdateFeesTo;
503 	}
504 
505 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
506 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
507 	}
508 
509 	function BdpPriceStorage(bytes8 _version) public {
510 		ownerAddress = msg.sender;
511 		managerAddress = msg.sender;
512 		version = _version;
513 	}
514 
515 }
516 
517 // File: contracts/libraries/BdpCalculator.sol
518 
519 library BdpCalculator {
520 
521 	using SafeMath for uint256;
522 
523 	function calculateArea(address[16] _contracts, uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
524 		var (x1, y1, x2, y2) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCoordinates(_regionId);
525 		_width = x2 - x1 + 1;
526 		_height = y2 - y1 + 1;
527 		_area = _width * _height;
528 	}
529 
530 	function countPurchasedPixels(address[16] _contracts) view public returns (uint256 _count) {
531 		var lastRegionId = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getLastRegionId();
532 		for (uint256 i = 0; i <= lastRegionId; i++) {
533 			if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionPurchasedAt(i) > 0) { // region is purchased
534 				var (area,,) = calculateArea(_contracts, i);
535 				_count += area;
536 			}
537 		}
538 	}
539 
540 	function calculateCurrentMarketPixelPrice(address[16] _contracts) view public returns(uint) {
541 		return calculateMarketPixelPrice(_contracts, countPurchasedPixels(_contracts));
542 	}
543 
544 	function calculateMarketPixelPrice(address[16] _contracts, uint _pixelsSold) view public returns(uint) {
545 		var pricePointsLength = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePointsLength();
546 		uint mod = _pixelsSold % (1000000 / (pricePointsLength - 1));
547 		uint div = _pixelsSold * (pricePointsLength - 1) / 1000000;
548 		var divPoint = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div);
549 		if(mod == 0) return divPoint;
550 		return divPoint + mod * (BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div+1) - divPoint) * (pricePointsLength - 1) / 1000000;
551 	}
552 
553 	function calculateAveragePixelPrice(address[16] _contracts, uint _a, uint _b) view public returns (uint _price) {
554 		_price = (calculateMarketPixelPrice(_contracts, _a) + calculateMarketPixelPrice(_contracts, _b)) / 2;
555 	}
556 
557 	/** Current market price per pixel for this region if it is the first sale of this region
558 	  */
559 	function calculateRegionInitialSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
560 		require(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAt(_regionId) > 0); // region exists
561 		var purchasedPixels = countPurchasedPixels(_contracts);
562 		var (area,,) = calculateArea(_contracts, _regionId);
563 		return calculateAveragePixelPrice(_contracts, purchasedPixels, purchasedPixels + area);
564 	}
565 
566 	/** Current market price or (Current market price)*3 if the region was sold
567 	  */
568 	function calculateRegionSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
569 		var pixelPrice = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId);
570 		if(pixelPrice > 0) {
571 			return pixelPrice * 3;
572 		} else {
573 			return calculateRegionInitialSalePixelPrice(_contracts, _regionId);
574 		}
575 	}
576 
577 	/** Setup is allowed one whithin one day after purchase
578 	  */
579 	function calculateSetupAllowedUntil(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
580 		var (updatedAt, purchasedAt) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAtPurchasedAt(_regionId);
581 		if(updatedAt != purchasedAt) {
582 			return 0;
583 		} else {
584 			return purchasedAt + 1 days;
585 		}
586 	}
587 
588 }
589 
590 // File: contracts/storage/BdpOwnershipStorage.sol
591 
592 contract BdpOwnershipStorage is BdpBase {
593 
594 	using SafeMath for uint256;
595 
596 	// Mapping from token ID to owner
597 	mapping (uint256 => address) public tokenOwner;
598 
599 	// Mapping from token ID to approved address
600 	mapping (uint256 => address) public tokenApprovals;
601 
602 	// Mapping from owner to the sum of owned area
603 	mapping (address => uint256) public ownedArea;
604 
605 	// Mapping from owner to list of owned token IDs
606 	mapping (address => uint256[]) public ownedTokens;
607 
608 	// Mapping from token ID to index of the owner tokens list
609 	mapping(uint256 => uint256) public ownedTokensIndex;
610 
611 	// All tokens list tokens ids
612 	uint256[] public tokenIds;
613 
614 	// Mapping from tokenId to index of the tokens list
615 	mapping (uint256 => uint256) public tokenIdsIndex;
616 
617 
618 	function getTokenOwner(uint256 _tokenId) view public returns (address) {
619 		return tokenOwner[_tokenId];
620 	}
621 
622 	function setTokenOwner(uint256 _tokenId, address _owner) public storageAccessControl {
623 		tokenOwner[_tokenId] = _owner;
624 	}
625 
626 	function getTokenApproval(uint256 _tokenId) view public returns (address) {
627 		return tokenApprovals[_tokenId];
628 	}
629 
630 	function setTokenApproval(uint256 _tokenId, address _to) public storageAccessControl {
631 		tokenApprovals[_tokenId] = _to;
632 	}
633 
634 	function getOwnedArea(address _owner) view public returns (uint256) {
635 		return ownedArea[_owner];
636 	}
637 
638 	function setOwnedArea(address _owner, uint256 _area) public storageAccessControl {
639 		ownedArea[_owner] = _area;
640 	}
641 
642 	function incrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
643 		ownedArea[_owner] = ownedArea[_owner].add(_area);
644 		return ownedArea[_owner];
645 	}
646 
647 	function decrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
648 		ownedArea[_owner] = ownedArea[_owner].sub(_area);
649 		return ownedArea[_owner];
650 	}
651 
652 	function getOwnedTokensLength(address _owner) view public returns (uint256) {
653 		return ownedTokens[_owner].length;
654 	}
655 
656 	function getOwnedToken(address _owner, uint256 _index) view public returns (uint256) {
657 		return ownedTokens[_owner][_index];
658 	}
659 
660 	function setOwnedToken(address _owner, uint256 _index, uint256 _tokenId) public storageAccessControl {
661 		ownedTokens[_owner][_index] = _tokenId;
662 	}
663 
664 	function pushOwnedToken(address _owner, uint256 _tokenId) public storageAccessControl returns (uint256) {
665 		ownedTokens[_owner].push(_tokenId);
666 		return ownedTokens[_owner].length;
667 	}
668 
669 	function decrementOwnedTokensLength(address _owner) public storageAccessControl {
670 		ownedTokens[_owner].length--;
671 	}
672 
673 	function getOwnedTokensIndex(uint256 _tokenId) view public returns (uint256) {
674 		return ownedTokensIndex[_tokenId];
675 	}
676 
677 	function setOwnedTokensIndex(uint256 _tokenId, uint256 _tokenIndex) public storageAccessControl {
678 		ownedTokensIndex[_tokenId] = _tokenIndex;
679 	}
680 
681 	function getTokenIdsLength() view public returns (uint256) {
682 		return tokenIds.length;
683 	}
684 
685 	function getTokenIdByIndex(uint256 _index) view public returns (uint256) {
686 		return tokenIds[_index];
687 	}
688 
689 	function setTokenIdByIndex(uint256 _index, uint256 _tokenId) public storageAccessControl {
690 		tokenIds[_index] = _tokenId;
691 	}
692 
693 	function pushTokenId(uint256 _tokenId) public storageAccessControl returns (uint256) {
694 		tokenIds.push(_tokenId);
695 		return tokenIds.length;
696 	}
697 
698 	function decrementTokenIdsLength() public storageAccessControl {
699 		tokenIds.length--;
700 	}
701 
702 	function getTokenIdsIndex(uint256 _tokenId) view public returns (uint256) {
703 		return tokenIdsIndex[_tokenId];
704 	}
705 
706 	function setTokenIdsIndex(uint256 _tokenId, uint256 _tokenIdIndex) public storageAccessControl {
707 		tokenIdsIndex[_tokenId] = _tokenIdIndex;
708 	}
709 
710 	function BdpOwnershipStorage(bytes8 _version) public {
711 		ownerAddress = msg.sender;
712 		managerAddress = msg.sender;
713 		version = _version;
714 	}
715 
716 }
717 
718 // File: contracts/libraries/BdpOwnership.sol
719 
720 library BdpOwnership {
721 
722 	using SafeMath for uint256;
723 
724 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
725 
726 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
727 
728 	function ownerOf(address[16] _contracts, uint256 _tokenId) public view returns (address) {
729 		var owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
730 		require(owner != address(0));
731 		return owner;
732 	}
733 
734 	function balanceOf(address[16] _contracts, address _owner) public view returns (uint256) {
735 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getOwnedTokensLength(_owner);
736 	}
737 
738 	function approve(address[16] _contracts, address _to, uint256 _tokenId) public {
739 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
740 
741 		address owner = ownerOf(_contracts, _tokenId);
742 		require(_to != owner);
743 		if (ownStorage.getTokenApproval(_tokenId) != 0 || _to != 0) {
744 			ownStorage.setTokenApproval(_tokenId, _to);
745 			Approval(owner, _to, _tokenId);
746 		}
747 	}
748 
749 	/**
750 	 * @dev Clear current approval of a given token ID
751 	 * @param _tokenId uint256 ID of the token to be transferred
752 	 */
753 	function clearApproval(address[16] _contracts, address _owner, uint256 _tokenId) public {
754 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
755 
756 		require(ownerOf(_contracts, _tokenId) == _owner);
757 		if (ownStorage.getTokenApproval(_tokenId) != 0) {
758 			BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).setTokenApproval(_tokenId, 0);
759 			Approval(_owner, 0, _tokenId);
760 		}
761 	}
762 
763 	/**
764 	 * @dev Clear current approval and transfer the ownership of a given token ID
765 	 * @param _from address which you want to send tokens from
766 	 * @param _to address which you want to transfer the token to
767 	 * @param _tokenId uint256 ID of the token to be transferred
768 	 */
769 	function clearApprovalAndTransfer(address[16] _contracts, address _from, address _to, uint256 _tokenId) public {
770 		require(_to != address(0));
771 		require(_to != ownerOf(_contracts, _tokenId));
772 		require(ownerOf(_contracts, _tokenId) == _from);
773 
774 		clearApproval(_contracts, _from, _tokenId);
775 		removeToken(_contracts, _from, _tokenId);
776 		addToken(_contracts, _to, _tokenId);
777 		Transfer(_from, _to, _tokenId);
778 	}
779 
780 	/**
781 	 * @dev Internal function to add a token ID to the list of a given address
782 	 * @param _to address representing the new owner of the given token ID
783 	 * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
784 	 */
785 	function addToken(address[16] _contracts, address _to, uint256 _tokenId) private {
786 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
787 
788 		require(ownStorage.getTokenOwner(_tokenId) == address(0));
789 
790 		// Set token owner
791 		ownStorage.setTokenOwner(_tokenId, _to);
792 
793 		// Add token to tokenIds list
794 		var tokenIdsLength = ownStorage.pushTokenId(_tokenId);
795 		ownStorage.setTokenIdsIndex(_tokenId, tokenIdsLength.sub(1));
796 
797 		uint256 ownedTokensLength = ownStorage.getOwnedTokensLength(_to);
798 
799 		// Add token to ownedTokens list
800 		ownStorage.pushOwnedToken(_to, _tokenId);
801 		ownStorage.setOwnedTokensIndex(_tokenId, ownedTokensLength);
802 
803 		// Increment total owned area
804 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
805 		ownStorage.incrementOwnedArea(_to, area);
806 	}
807 
808 	/**
809 	 * @dev Internal function to remove a token ID from the list of a given address
810 	 * @param _from address representing the previous owner of the given token ID
811 	 * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
812 	 */
813 	function removeToken(address[16] _contracts, address _from, uint256 _tokenId) private {
814 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
815 
816 		require(ownerOf(_contracts, _tokenId) == _from);
817 
818 		// Clear token owner
819 		ownStorage.setTokenOwner(_tokenId, 0);
820 
821 		removeFromTokenIds(ownStorage, _tokenId);
822 		removeFromOwnedToken(ownStorage, _from, _tokenId);
823 
824 		// Decrement total owned area
825 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
826 		ownStorage.decrementOwnedArea(_from, area);
827 	}
828 
829 	/**
830 	 * @dev Remove token from ownedTokens list
831 	 * Note that this will handle single-element arrays. In that case, both ownedTokenIndex and lastOwnedTokenIndex are going to
832 	 * be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
833 	 * the lastOwnedToken to the first position, and then dropping the element placed in the last position of the list
834 	 */
835 	function removeFromOwnedToken(BdpOwnershipStorage _ownStorage, address _from, uint256 _tokenId) private {
836 		var ownedTokenIndex = _ownStorage.getOwnedTokensIndex(_tokenId);
837 		var lastOwnedTokenIndex = _ownStorage.getOwnedTokensLength(_from).sub(1);
838 		var lastOwnedToken = _ownStorage.getOwnedToken(_from, lastOwnedTokenIndex);
839 		_ownStorage.setOwnedToken(_from, ownedTokenIndex, lastOwnedToken);
840 		_ownStorage.setOwnedToken(_from, lastOwnedTokenIndex, 0);
841 		_ownStorage.decrementOwnedTokensLength(_from);
842 		_ownStorage.setOwnedTokensIndex(_tokenId, 0);
843 		_ownStorage.setOwnedTokensIndex(lastOwnedToken, ownedTokenIndex);
844 	}
845 
846 	/**
847 	 * @dev Remove token from tokenIds list
848 	 */
849 	function removeFromTokenIds(BdpOwnershipStorage _ownStorage, uint256 _tokenId) private {
850 		var tokenIndex = _ownStorage.getTokenIdsIndex(_tokenId);
851 		var lastTokenIdIndex = _ownStorage.getTokenIdsLength().sub(1);
852 		var lastTokenId = _ownStorage.getTokenIdByIndex(lastTokenIdIndex);
853 		_ownStorage.setTokenIdByIndex(tokenIndex, lastTokenId);
854 		_ownStorage.setTokenIdByIndex(lastTokenIdIndex, 0);
855 		_ownStorage.decrementTokenIdsLength();
856 		_ownStorage.setTokenIdsIndex(_tokenId, 0);
857 		_ownStorage.setTokenIdsIndex(lastTokenId, tokenIndex);
858 	}
859 
860 	/**
861 	 * @dev Mint token function
862 	 * @param _to The address that will own the minted token
863 	 * @param _tokenId uint256 ID of the token to be minted by the msg.sender
864 	 */
865 	function mint(address[16] _contracts, address _to, uint256 _tokenId) public {
866 		require(_to != address(0));
867 		addToken(_contracts, _to, _tokenId);
868 		Transfer(address(0), _to, _tokenId);
869 	}
870 
871 	/**
872 	 * @dev Burns a specific token
873 	 * @param _tokenId uint256 ID of the token being burned
874 	 */
875 	function burn(address[16] _contracts, uint256 _tokenId) public {
876 		address owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
877 		clearApproval(_contracts, owner, _tokenId);
878 		removeToken(_contracts, owner, _tokenId);
879 		Transfer(owner, address(0), _tokenId);
880 	}
881 
882 }
883 
884 // File: contracts/libraries/BdpImage.sol
885 
886 library BdpImage {
887 
888 	function checkImageInput(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
889 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
890 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
891 
892 		require( (_imageId == 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // Only one way to change image can be specified
893 			|| (_imageId != 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // If image has to be changed
894 			|| (_imageId == 0 && _imageData.length != 0 && !_swapImages && !_clearImage)
895 			|| (_imageId == 0 && _imageData.length == 0 && _swapImages && !_clearImage)
896 			|| (_imageId == 0 && _imageData.length == 0 && !_swapImages && _clearImage) );
897 
898 		require(_imageId == 0 || // Can use only own images not used by other regions
899 			( (msg.sender == imageStorage.getImageOwner(_imageId)) && (imageStorage.getImageCurrentRegionId(_imageId) == 0) ) );
900 
901 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
902 		require(!_swapImages || imageStorage.imageUploadComplete(nextImageId)); // Can swap images if next image upload is complete
903 	}
904 
905 	function setNextImagePart(address[16] _contracts, uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) public {
906 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
907 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
908 
909 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
910 		require(_imageData.length != 0);
911 		require(_part > 0);
912 		require(_part <= _partsCount);
913 
914 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
915 		if(nextImageId == 0 || _imageDescriptor != imageStorage.getImageDescriptor(nextImageId)) {
916 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
917 			nextImageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), _partsCount, _imageDescriptor);
918 			dataStorage.setRegionNextImageId(_regionId, nextImageId);
919 		}
920 
921 		imageStorage.setImageData(nextImageId, _part, _imageData);
922 	}
923 
924 	function setImageOwner(address[16] _contracts, uint256 _imageId, address _owner) public {
925 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
926 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
927 		require(_owner != address(0));
928 
929 		imageStorage.setImageOwner(_imageId, _owner);
930 	}
931 
932 	function setImageData(address[16] _contracts, uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
933 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
934 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
935 		require(imageStorage.getImageCurrentRegionId(_imageId) == 0);
936 		require(_imageData.length != 0);
937 		require(_part > 0);
938 		require(_part <= imageStorage.getImagePartsCount(_imageId));
939 
940 		imageStorage.setImageData(_imageId, _part, _imageData);
941 	}
942 
943 }
944 
945 // File: contracts/libraries/BdpCrud.sol
946 
947 library BdpCrud {
948 
949 	function createRegion(address[16] _contracts, address _to, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public returns (uint256) {
950 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
951 		require(_x2 < 1000 && _x1 <= _x2);
952 		require(_y2 < 1000 && _y1 <= _y2);
953 
954 		var regionId = dataStorage.getNextRegionId();
955 		dataStorage.setRegionCoordinates(regionId, _x1, _y1, _x2, _y2);
956 		dataStorage.setRegionBlockUpdatedAt(regionId, block.number);
957 		dataStorage.setRegionUpdatedAt(regionId, block.timestamp);
958 
959 		BdpOwnership.mint(_contracts, _to, regionId);
960 
961 		return regionId;
962 	}
963 
964 	function deleteRegion(address[16] _contracts, uint256 _regionId) public {
965 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
966 		var regionPurchasePixelPrice = dataStorage.getRegionPurchasePixelPrice(_regionId);
967 		require(regionPurchasePixelPrice == 0);
968 		BdpOwnership.burn(_contracts, _regionId);
969 		dataStorage.deleteRegionData(_regionId);
970 	}
971 
972 	function setupRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) public {
973 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
974 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
975 		require(_imageId != 0 || _imageData.length != 0 || _swapImages || _url.length != 0); // Only if image or url is specified
976 		require(block.timestamp < BdpCalculator.calculateSetupAllowedUntil(_contracts, _regionId)); // Can only execute if setup is allowed
977 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, false);
978 
979 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, false);
980 		_updateRegionUrl(dataStorage, _regionId, _url, false);
981 
982 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
983 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
984 	}
985 
986 	function updateRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) public {
987 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
988 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
989 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
990 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
991 		require(regionCurrentPixelPrice != 0); // region was purchased
992 
993 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
994 
995 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
996 		_processUpdateFee(_contracts, marketPixelPrice * area / 20);
997 
998 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, _clearImage);
999 		_updateRegionUrl(dataStorage, _regionId, _url, _deleteUrl);
1000 		_updateRegionOwner(_contracts, _regionId, _newOwner);
1001 		if(marketPixelPrice > regionCurrentPixelPrice) {
1002 			dataStorage.setRegionCurrentPixelPrice(_regionId, marketPixelPrice);
1003 		}
1004 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
1005 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
1006 	}
1007 
1008 	function updateRegionPixelPrice(address[16] _contracts, uint256 _regionId, uint256 _pixelPrice) public {
1009 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
1010 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1011 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
1012 		require(regionCurrentPixelPrice != 0); // region was purchased
1013 
1014 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
1015 		require(_pixelPrice >= marketPixelPrice);
1016 
1017 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1018 		_processUpdateFee(_contracts, _pixelPrice * area / 20);
1019 
1020 		dataStorage.setRegionCurrentPixelPrice(_regionId, _pixelPrice);
1021 	}
1022 
1023 	function _processUpdateFee(address[16] _contracts, uint256 _updateFee) internal {
1024 		require(msg.value >= _updateFee);
1025 
1026 		if(msg.value > _updateFee) {
1027 			var change = msg.value - _updateFee;
1028 			msg.sender.transfer(change);
1029 		}
1030 
1031 		var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1032 		if(forwardUpdateFeesTo != address(0)) {
1033 			forwardUpdateFeesTo.transfer(_updateFee);
1034 		}
1035 	}
1036 
1037 	function _updateRegionImage(address[16] _contracts, BdpDataStorage _dataStorage, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) internal {
1038 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
1039 		var currentImageId = _dataStorage.getRegionCurrentImageId(_regionId);
1040 		if(_imageId != 0) {
1041 			if(currentImageId != 0) {
1042 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1043 			}
1044 			_dataStorage.setRegionCurrentImageId(_regionId, _imageId);
1045 			imageStorage.setImageCurrentRegionId(_imageId, _regionId);
1046 		}
1047 
1048 		if(_imageData.length > 0) {
1049 			if(currentImageId != 0) {
1050 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1051 			}
1052 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
1053 			var imageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), 1, 1);
1054 			imageStorage.setImageData(imageId, 1, _imageData);
1055 			_dataStorage.setRegionCurrentImageId(_regionId, imageId);
1056 			imageStorage.setImageCurrentRegionId(imageId, _regionId);
1057 		}
1058 
1059 		if(_swapImages) {
1060 			if(currentImageId != 0) {
1061 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1062 			}
1063 			var nextImageId = _dataStorage.getRegionNextImageId(_regionId);
1064 			_dataStorage.setRegionCurrentImageId(_regionId, nextImageId);
1065 			imageStorage.setImageCurrentRegionId(nextImageId, _regionId);
1066 			_dataStorage.setRegionNextImageId(_regionId, 0);
1067 		}
1068 
1069 		if(_clearImage) {
1070 			if(currentImageId != 0) {
1071 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1072 			}
1073 			_dataStorage.setRegionCurrentImageId(_regionId, 0);
1074 		}
1075 	}
1076 
1077 	function _updateRegionUrl(BdpDataStorage _dataStorage, uint256 _regionId, uint8[128] _url, bool _deleteUrl) internal {
1078 		if(_url[0] != 0) {
1079 			_dataStorage.setRegionUrl(_regionId, _url);
1080 		}
1081 		if(_deleteUrl) {
1082 			uint8[128] memory emptyUrl;
1083 			_dataStorage.setRegionUrl(_regionId, emptyUrl);
1084 		}
1085 	}
1086 
1087 	function _updateRegionOwner(address[16] _contracts, uint256 _regionId, address _newOwner) internal {
1088 		if(_newOwner != address(0)) {
1089 			BdpOwnership.clearApprovalAndTransfer(_contracts, msg.sender, _newOwner, _regionId);
1090 		}
1091 	}
1092 
1093 }
1094 
1095 // File: contracts/libraries/BdpTransfer.sol
1096 
1097 library BdpTransfer {
1098 
1099 	using SafeMath for uint256;
1100 
1101 	function approve(address[16] _contracts, address _to, uint256 _regionId) public {
1102 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1103 		BdpOwnership.approve(_contracts, _to, _regionId);
1104 	}
1105 
1106 	function purchase(address[16] _contracts, uint256 _regionId) public {
1107 		uint256 pixelPrice = BdpCalculator.calculateRegionSalePixelPrice(_contracts, _regionId);
1108 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1109 		uint256 regionPrice = pixelPrice * area;
1110 
1111 		require(msg.value >= regionPrice );
1112 
1113 		if(msg.value > regionPrice) {
1114 			uint256 change = msg.value - regionPrice;
1115 			msg.sender.transfer(change);
1116 		}
1117 
1118 		if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId) > 0) { // send 95% ether to ownerOf(_regionId)
1119 			uint256 etherToPreviousOwner = regionPrice * 19 / 20;
1120 			BdpOwnership.ownerOf(_contracts, _regionId).transfer(etherToPreviousOwner);
1121 			var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1122 			if(forwardUpdateFeesTo != address(0)) {
1123 				forwardUpdateFeesTo.transfer(regionPrice - etherToPreviousOwner);
1124 			}
1125 		} else {
1126 			var forwardPurchaseFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardPurchaseFeesTo();
1127 			if(forwardPurchaseFeesTo != address(0)) {
1128 				forwardPurchaseFeesTo.transfer(regionPrice);
1129 			}
1130 		}
1131 
1132 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionCurrentPixelPrice(_regionId, pixelPrice);
1133 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionBlockUpdatedAt(_regionId, block.number);
1134 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionUpdatedAt(_regionId, block.timestamp);
1135 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedAt(_regionId, block.timestamp);
1136 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedPixelPrice(_regionId, pixelPrice);
1137 
1138 		BdpOwnership.clearApprovalAndTransfer(_contracts, BdpOwnership.ownerOf(_contracts, _regionId), msg.sender, _regionId);
1139 	}
1140 
1141 }
1142 
1143 // File: contracts/controller/BdpController.sol
1144 
1145 contract BdpController is BdpBase {
1146 
1147 	function name() external pure returns (string) {
1148 		return "The Billion Dollar Picture";
1149 	}
1150 
1151 	function symbol() external pure returns (string) {
1152 		return "BDP";
1153 	}
1154 
1155 	function tokenURI(uint256 _tokenId) external view returns (string _tokenURI) {
1156 		_tokenURI = "https://www.billiondollarpicture.com/#0000000";
1157 		bytes memory tokenURIBytes = bytes(_tokenURI);
1158 		tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
1159 		tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
1160 		tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
1161 		tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
1162 		tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
1163 		tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
1164 		tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
1165 	}
1166 
1167 
1168 	// BdpCrud
1169 
1170 	function createRegion(uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public onlyAuthorized returns (uint256) {
1171 		BdpCrud.createRegion(contracts, ownerAddress, _x1, _y1, _x2, _y2);
1172 	}
1173 
1174 	function deleteRegion(uint256 _regionId) public onlyAuthorized returns (uint256) {
1175 		BdpCrud.deleteRegion(contracts, _regionId);
1176 	}
1177 
1178 	function setupRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) whileContractIsActive public {
1179 		BdpCrud.setupRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _url);
1180 	}
1181 
1182 	function updateRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) whileContractIsActive public payable {
1183 		BdpCrud.updateRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage, _url, _deleteUrl, _newOwner);
1184 	}
1185 
1186 	function updateRegionPixelPrice(uint256 _regionId, uint256 _pixelPrice) whileContractIsActive public payable {
1187 		BdpCrud.updateRegionPixelPrice(contracts, _regionId, _pixelPrice);
1188 	}
1189 
1190 
1191 	// BdpImage
1192 
1193 	function checkImageInput(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
1194 		BdpImage.checkImageInput(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
1195 	}
1196 
1197 	function setNextImagePart(uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) whileContractIsActive public {
1198 		BdpImage.setNextImagePart(contracts, _regionId, _part, _partsCount, _imageDescriptor, _imageData);
1199 	}
1200 
1201 
1202 	// BdpOwnership
1203 
1204 	function ownerOf(uint256 _tokenId) external view returns (address _owner) {
1205 		return BdpOwnership.ownerOf(contracts, _tokenId);
1206 	}
1207 
1208 	function totalSupply() external view returns (uint256 _count) {
1209 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdsLength();
1210 	}
1211 
1212 	function balanceOf(address _owner) external view returns (uint256 _count) {
1213 		return BdpOwnership.balanceOf(contracts, _owner);
1214 	}
1215 
1216 	function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
1217 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedToken(_owner, _index);
1218 	}
1219 
1220 	function tokenByIndex(uint256 _index) external view returns (uint256) {
1221 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdByIndex(_index);
1222 	}
1223 
1224 	function getOwnedArea(address _owner) public view returns (uint256) {
1225 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedArea(_owner);
1226 	}
1227 
1228 
1229 	// BdpTransfer
1230 
1231 	function purchase(uint256 _regionId) whileContractIsActive external payable {
1232 		BdpTransfer.purchase(contracts, _regionId);
1233 	}
1234 
1235 
1236 	// Withdraw
1237 
1238 	function withdrawBalance() external onlyOwner {
1239 		ownerAddress.transfer(this.balance);
1240 	}
1241 
1242 
1243 	// BdpControllerHelper
1244 
1245 	function () public {
1246 		address _impl = BdpContracts.getBdpControllerHelper(contracts);
1247 		require(_impl != address(0));
1248 		bytes memory data = msg.data;
1249 
1250 		assembly {
1251 			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
1252 			let size := returndatasize
1253 			let ptr := mload(0x40)
1254 			returndatacopy(ptr, 0, size)
1255 			switch result
1256 			case 0 { revert(ptr, size) }
1257 			default { return(ptr, size) }
1258 		}
1259 	}
1260 
1261 	function BdpController(bytes8 _version) public {
1262 		ownerAddress = msg.sender;
1263 		managerAddress = msg.sender;
1264 		version = _version;
1265 	}
1266 
1267 }