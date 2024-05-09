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
720 /**
721  * Ownership manager
722  * Does not check if the caller is allowed to call functions
723  * State changing methods are not intended to be called from controller
724  */
725 library BdpOwnership {
726 
727 	using SafeMath for uint256;
728 
729 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
730 
731 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
732 
733 	function ownerOf(address[16] _contracts, uint256 _tokenId) public view returns (address) {
734 		var owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
735 		require(owner != address(0));
736 		return owner;
737 	}
738 
739 	function balanceOf(address[16] _contracts, address _owner) public view returns (uint256) {
740 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getOwnedTokensLength(_owner);
741 	}
742 
743 	function approve(address[16] _contracts, address _to, uint256 _tokenId) public {
744 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
745 
746 		address owner = ownerOf(_contracts, _tokenId);
747 		require(_to != owner);
748 		if (ownStorage.getTokenApproval(_tokenId) != 0 || _to != 0) {
749 			ownStorage.setTokenApproval(_tokenId, _to);
750 			Approval(owner, _to, _tokenId);
751 		}
752 	}
753 
754 	/**
755 	 * @dev Clear current approval of a given token ID
756 	 * @param _tokenId uint256 ID of the token to be transferred
757 	 */
758 	function clearApproval(address[16] _contracts, address _owner, uint256 _tokenId) public {
759 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
760 
761 		require(ownerOf(_contracts, _tokenId) == _owner);
762 		if (ownStorage.getTokenApproval(_tokenId) != 0) {
763 			BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).setTokenApproval(_tokenId, 0);
764 			Approval(_owner, 0, _tokenId);
765 		}
766 	}
767 
768 	/**
769 	 * @dev Clear current approval and transfer the ownership of a given token ID
770 	 * @param _from address which you want to send tokens from
771 	 * @param _to address which you want to transfer the token to
772 	 * @param _tokenId uint256 ID of the token to be transferred
773 	 */
774 	function clearApprovalAndTransfer(address[16] _contracts, address _from, address _to, uint256 _tokenId) public {
775 		require(_to != address(0));
776 		require(_to != ownerOf(_contracts, _tokenId));
777 		require(ownerOf(_contracts, _tokenId) == _from);
778 
779 		clearApproval(_contracts, _from, _tokenId);
780 		removeToken(_contracts, _from, _tokenId);
781 		addToken(_contracts, _to, _tokenId);
782 		Transfer(_from, _to, _tokenId);
783 	}
784 
785 	/**
786 	 * @dev Internal function to add a token ID to the list of a given address
787 	 * @param _to address representing the new owner of the given token ID
788 	 * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
789 	 */
790 	function addToken(address[16] _contracts, address _to, uint256 _tokenId) private {
791 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
792 
793 		require(ownStorage.getTokenOwner(_tokenId) == address(0));
794 
795 		// Set token owner
796 		ownStorage.setTokenOwner(_tokenId, _to);
797 
798 		// Add token to tokenIds list
799 		var tokenIdsLength = ownStorage.pushTokenId(_tokenId);
800 		ownStorage.setTokenIdsIndex(_tokenId, tokenIdsLength.sub(1));
801 
802 		uint256 ownedTokensLength = ownStorage.getOwnedTokensLength(_to);
803 
804 		// Add token to ownedTokens list
805 		ownStorage.pushOwnedToken(_to, _tokenId);
806 		ownStorage.setOwnedTokensIndex(_tokenId, ownedTokensLength);
807 
808 		// Increment total owned area
809 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
810 		ownStorage.incrementOwnedArea(_to, area);
811 	}
812 
813 	/**
814 	 * @dev Internal function to remove a token ID from the list of a given address
815 	 * @param _from address representing the previous owner of the given token ID
816 	 * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
817 	 */
818 	function removeToken(address[16] _contracts, address _from, uint256 _tokenId) private {
819 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
820 
821 		require(ownerOf(_contracts, _tokenId) == _from);
822 
823 		// Clear token owner
824 		ownStorage.setTokenOwner(_tokenId, 0);
825 
826 		removeFromTokenIds(ownStorage, _tokenId);
827 		removeFromOwnedToken(ownStorage, _from, _tokenId);
828 
829 		// Decrement total owned area
830 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
831 		ownStorage.decrementOwnedArea(_from, area);
832 	}
833 
834 	/**
835 	 * @dev Remove token from ownedTokens list
836 	 * Note that this will handle single-element arrays. In that case, both ownedTokenIndex and lastOwnedTokenIndex are going to
837 	 * be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
838 	 * the lastOwnedToken to the first position, and then dropping the element placed in the last position of the list
839 	 */
840 	function removeFromOwnedToken(BdpOwnershipStorage _ownStorage, address _from, uint256 _tokenId) private {
841 		var ownedTokenIndex = _ownStorage.getOwnedTokensIndex(_tokenId);
842 		var lastOwnedTokenIndex = _ownStorage.getOwnedTokensLength(_from).sub(1);
843 		var lastOwnedToken = _ownStorage.getOwnedToken(_from, lastOwnedTokenIndex);
844 		_ownStorage.setOwnedToken(_from, ownedTokenIndex, lastOwnedToken);
845 		_ownStorage.setOwnedToken(_from, lastOwnedTokenIndex, 0);
846 		_ownStorage.decrementOwnedTokensLength(_from);
847 		_ownStorage.setOwnedTokensIndex(_tokenId, 0);
848 		_ownStorage.setOwnedTokensIndex(lastOwnedToken, ownedTokenIndex);
849 	}
850 
851 	/**
852 	 * @dev Remove token from tokenIds list
853 	 */
854 	function removeFromTokenIds(BdpOwnershipStorage _ownStorage, uint256 _tokenId) private {
855 		var tokenIndex = _ownStorage.getTokenIdsIndex(_tokenId);
856 		var lastTokenIdIndex = _ownStorage.getTokenIdsLength().sub(1);
857 		var lastTokenId = _ownStorage.getTokenIdByIndex(lastTokenIdIndex);
858 		_ownStorage.setTokenIdByIndex(tokenIndex, lastTokenId);
859 		_ownStorage.setTokenIdByIndex(lastTokenIdIndex, 0);
860 		_ownStorage.decrementTokenIdsLength();
861 		_ownStorage.setTokenIdsIndex(_tokenId, 0);
862 		_ownStorage.setTokenIdsIndex(lastTokenId, tokenIndex);
863 	}
864 
865 	/**
866 	 * @dev Mint token function
867 	 * @param _to The address that will own the minted token
868 	 * @param _tokenId uint256 ID of the token to be minted by the msg.sender
869 	 */
870 	function mint(address[16] _contracts, address _to, uint256 _tokenId) public {
871 		require(_to != address(0));
872 		addToken(_contracts, _to, _tokenId);
873 		Transfer(address(0), _to, _tokenId);
874 	}
875 
876 	/**
877 	 * @dev Burns a specific token
878 	 * @param _tokenId uint256 ID of the token being burned
879 	 */
880 	function burn(address[16] _contracts, uint256 _tokenId) public {
881 		address owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
882 		clearApproval(_contracts, owner, _tokenId);
883 		removeToken(_contracts, owner, _tokenId);
884 		Transfer(owner, address(0), _tokenId);
885 	}
886 
887 }
888 
889 // File: contracts/libraries/BdpImage.sol
890 
891 library BdpImage {
892 
893 	function checkImageInput(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
894 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
895 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
896 
897 		require( (_imageId == 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // Only one way to change image can be specified
898 			|| (_imageId != 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // If image has to be changed
899 			|| (_imageId == 0 && _imageData.length != 0 && !_swapImages && !_clearImage)
900 			|| (_imageId == 0 && _imageData.length == 0 && _swapImages && !_clearImage)
901 			|| (_imageId == 0 && _imageData.length == 0 && !_swapImages && _clearImage) );
902 
903 		require(_imageId == 0 || // Can use only own images not used by other regions
904 			( (msg.sender == imageStorage.getImageOwner(_imageId)) && (imageStorage.getImageCurrentRegionId(_imageId) == 0) ) );
905 
906 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
907 		require(!_swapImages || imageUploadComplete(_contracts, nextImageId)); // Can swap images if next image upload is complete
908 	}
909 
910 	function setNextImagePart(address[16] _contracts, uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) public {
911 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
912 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
913 
914 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
915 		require(_imageData.length != 0);
916 		require(_part > 0);
917 		require(_part <= _partsCount);
918 
919 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
920 		if(nextImageId == 0 || _imageDescriptor != imageStorage.getImageDescriptor(nextImageId)) {
921 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
922 			nextImageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), _partsCount, _imageDescriptor);
923 			dataStorage.setRegionNextImageId(_regionId, nextImageId);
924 		}
925 
926 		imageStorage.setImageData(nextImageId, _part, _imageData);
927 	}
928 
929 	function setImageOwner(address[16] _contracts, uint256 _imageId, address _owner) public {
930 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
931 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
932 		require(_owner != address(0));
933 
934 		imageStorage.setImageOwner(_imageId, _owner);
935 	}
936 
937 	function setImageData(address[16] _contracts, uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
938 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
939 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
940 		require(imageStorage.getImageCurrentRegionId(_imageId) == 0);
941 		require(_imageData.length != 0);
942 		require(_part > 0);
943 		require(_part <= imageStorage.getImagePartsCount(_imageId));
944 
945 		imageStorage.setImageData(_imageId, _part, _imageData);
946 	}
947 
948 	function imageUploadComplete(address[16] _contracts, uint256 _imageId) view public returns (bool) {
949 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
950 		var partsCount = imageStorage.getImagePartsCount(_imageId);
951 		for (uint16 i = 1; i <= partsCount; i++) {
952 			if(imageStorage.getImageDataLength(_imageId, i) == 0) {
953 				return false;
954 			}
955 		}
956 		return true;
957 	}
958 
959 }
960 
961 // File: contracts/libraries/BdpCrud.sol
962 
963 library BdpCrud {
964 
965 	function createRegion(address[16] _contracts, address _to, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public returns (uint256) {
966 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
967 		require(_x2 < 1000 && _x1 <= _x2);
968 		require(_y2 < 1000 && _y1 <= _y2);
969 
970 		var regionId = dataStorage.getNextRegionId();
971 		dataStorage.setRegionCoordinates(regionId, _x1, _y1, _x2, _y2);
972 		dataStorage.setRegionBlockUpdatedAt(regionId, block.number);
973 		dataStorage.setRegionUpdatedAt(regionId, block.timestamp);
974 
975 		BdpOwnership.mint(_contracts, _to, regionId);
976 
977 		return regionId;
978 	}
979 
980 	function deleteRegion(address[16] _contracts, uint256 _regionId) public {
981 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
982 		var regionPurchasePixelPrice = dataStorage.getRegionPurchasePixelPrice(_regionId);
983 		require(regionPurchasePixelPrice == 0);
984 		BdpOwnership.burn(_contracts, _regionId);
985 		dataStorage.deleteRegionData(_regionId);
986 	}
987 
988 	function setupRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) public {
989 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
990 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
991 		require(_imageId != 0 || _imageData.length != 0 || _swapImages || _url.length != 0); // Only if image or url is specified
992 		require(block.timestamp < BdpCalculator.calculateSetupAllowedUntil(_contracts, _regionId)); // Can only execute if setup is allowed
993 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, false);
994 
995 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, false);
996 		_updateRegionUrl(dataStorage, _regionId, _url, false);
997 
998 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
999 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
1000 	}
1001 
1002 	function updateRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) public {
1003 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
1004 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1005 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
1006 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
1007 		require(regionCurrentPixelPrice != 0); // region was purchased
1008 
1009 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
1010 
1011 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1012 		_processUpdateFee(_contracts, marketPixelPrice * area / 20);
1013 
1014 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, _clearImage);
1015 		_updateRegionUrl(dataStorage, _regionId, _url, _deleteUrl);
1016 		_updateRegionOwner(_contracts, _regionId, _newOwner);
1017 		if(marketPixelPrice > regionCurrentPixelPrice) {
1018 			dataStorage.setRegionCurrentPixelPrice(_regionId, marketPixelPrice);
1019 		}
1020 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
1021 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
1022 	}
1023 
1024 	function updateRegionPixelPrice(address[16] _contracts, uint256 _regionId, uint256 _pixelPrice) public {
1025 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
1026 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1027 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
1028 		require(regionCurrentPixelPrice != 0); // region was purchased
1029 
1030 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
1031 		require(_pixelPrice >= marketPixelPrice);
1032 
1033 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1034 		_processUpdateFee(_contracts, _pixelPrice * area / 20);
1035 
1036 		dataStorage.setRegionCurrentPixelPrice(_regionId, _pixelPrice);
1037 	}
1038 
1039 	function _processUpdateFee(address[16] _contracts, uint256 _updateFee) internal {
1040 		require(msg.value >= _updateFee);
1041 
1042 		if(msg.value > _updateFee) {
1043 			var change = msg.value - _updateFee;
1044 			msg.sender.transfer(change);
1045 		}
1046 
1047 		var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1048 		if(forwardUpdateFeesTo != address(0)) {
1049 			forwardUpdateFeesTo.transfer(_updateFee);
1050 		}
1051 	}
1052 
1053 	function _updateRegionImage(address[16] _contracts, BdpDataStorage _dataStorage, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) internal {
1054 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
1055 		var currentImageId = _dataStorage.getRegionCurrentImageId(_regionId);
1056 		if(_imageId != 0) {
1057 			if(currentImageId != 0) {
1058 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1059 			}
1060 			_dataStorage.setRegionCurrentImageId(_regionId, _imageId);
1061 			imageStorage.setImageCurrentRegionId(_imageId, _regionId);
1062 		}
1063 
1064 		if(_imageData.length > 0) {
1065 			if(currentImageId != 0) {
1066 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1067 			}
1068 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
1069 			var imageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), 1, 1);
1070 			imageStorage.setImageData(imageId, 1, _imageData);
1071 			_dataStorage.setRegionCurrentImageId(_regionId, imageId);
1072 			imageStorage.setImageCurrentRegionId(imageId, _regionId);
1073 		}
1074 
1075 		if(_swapImages) {
1076 			if(currentImageId != 0) {
1077 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1078 			}
1079 			var nextImageId = _dataStorage.getRegionNextImageId(_regionId);
1080 			_dataStorage.setRegionCurrentImageId(_regionId, nextImageId);
1081 			imageStorage.setImageCurrentRegionId(nextImageId, _regionId);
1082 			_dataStorage.setRegionNextImageId(_regionId, 0);
1083 		}
1084 
1085 		if(_clearImage) {
1086 			if(currentImageId != 0) {
1087 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1088 			}
1089 			_dataStorage.setRegionCurrentImageId(_regionId, 0);
1090 		}
1091 	}
1092 
1093 	function _updateRegionUrl(BdpDataStorage _dataStorage, uint256 _regionId, uint8[128] _url, bool _deleteUrl) internal {
1094 		if(_url[0] != 0) {
1095 			_dataStorage.setRegionUrl(_regionId, _url);
1096 		}
1097 		if(_deleteUrl) {
1098 			uint8[128] memory emptyUrl;
1099 			_dataStorage.setRegionUrl(_regionId, emptyUrl);
1100 		}
1101 	}
1102 
1103 	function _updateRegionOwner(address[16] _contracts, uint256 _regionId, address _newOwner) internal {
1104 		if(_newOwner != address(0)) {
1105 			BdpOwnership.clearApprovalAndTransfer(_contracts, msg.sender, _newOwner, _regionId);
1106 		}
1107 	}
1108 
1109 }
1110 
1111 // File: contracts/libraries/BdpTransfer.sol
1112 
1113 library BdpTransfer {
1114 
1115 	using SafeMath for uint256;
1116 
1117 	function approve(address[16] _contracts, address _to, uint256 _regionId) public {
1118 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1119 		BdpOwnership.approve(_contracts, _to, _regionId);
1120 	}
1121 
1122 	function purchase(address[16] _contracts, uint256 _regionId) public {
1123 		uint256 pixelPrice = BdpCalculator.calculateRegionSalePixelPrice(_contracts, _regionId);
1124 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1125 		uint256 regionPrice = pixelPrice * area;
1126 
1127 		require(msg.value >= regionPrice );
1128 
1129 		if(msg.value > regionPrice) {
1130 			uint256 change = msg.value - regionPrice;
1131 			msg.sender.transfer(change);
1132 		}
1133 
1134 		if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId) > 0) { // send 95% ether to ownerOf(_regionId)
1135 			uint256 etherToPreviousOwner = regionPrice * 19 / 20;
1136 			BdpOwnership.ownerOf(_contracts, _regionId).transfer(etherToPreviousOwner);
1137 			var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1138 			if(forwardUpdateFeesTo != address(0)) {
1139 				forwardUpdateFeesTo.transfer(regionPrice - etherToPreviousOwner);
1140 			}
1141 		} else {
1142 			var forwardPurchaseFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardPurchaseFeesTo();
1143 			if(forwardPurchaseFeesTo != address(0)) {
1144 				forwardPurchaseFeesTo.transfer(regionPrice);
1145 			}
1146 		}
1147 
1148 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionCurrentPixelPrice(_regionId, pixelPrice);
1149 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionBlockUpdatedAt(_regionId, block.number);
1150 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionUpdatedAt(_regionId, block.timestamp);
1151 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedAt(_regionId, block.timestamp);
1152 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedPixelPrice(_regionId, pixelPrice);
1153 
1154 		BdpOwnership.clearApprovalAndTransfer(_contracts, BdpOwnership.ownerOf(_contracts, _regionId), msg.sender, _regionId);
1155 	}
1156 
1157 }
1158 
1159 // File: contracts/controller/BdpController.sol
1160 
1161 contract BdpController is BdpBase {
1162 
1163 	function name() external pure returns (string) {
1164 		return "The Billion Dollar Picture";
1165 	}
1166 
1167 	function symbol() external pure returns (string) {
1168 		return "BDP";
1169 	}
1170 
1171 	function tokenURI(uint256 _tokenId) external view returns (string _tokenURI) {
1172 		_tokenURI = "https://www.billiondollarpicture.com/#0000000";
1173 		bytes memory tokenURIBytes = bytes(_tokenURI);
1174 		tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
1175 		tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
1176 		tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
1177 		tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
1178 		tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
1179 		tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
1180 		tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
1181 	}
1182 
1183 
1184 	// BdpCrud
1185 
1186 	function createRegion(uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public onlyAuthorized returns (uint256) {
1187 		BdpCrud.createRegion(contracts, ownerAddress, _x1, _y1, _x2, _y2);
1188 	}
1189 
1190 	function deleteRegion(uint256 _regionId) public onlyAuthorized returns (uint256) {
1191 		BdpCrud.deleteRegion(contracts, _regionId);
1192 	}
1193 
1194 	function setupRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) whileContractIsActive public {
1195 		BdpCrud.setupRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _url);
1196 	}
1197 
1198 	function updateRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) whileContractIsActive public payable {
1199 		BdpCrud.updateRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage, _url, _deleteUrl, _newOwner);
1200 	}
1201 
1202 	function updateRegionPixelPrice(uint256 _regionId, uint256 _pixelPrice) whileContractIsActive public payable {
1203 		BdpCrud.updateRegionPixelPrice(contracts, _regionId, _pixelPrice);
1204 	}
1205 
1206 
1207 	// BdpImage
1208 
1209 	function checkImageInput(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
1210 		BdpImage.checkImageInput(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
1211 	}
1212 
1213 	function setNextImagePart(uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) whileContractIsActive public {
1214 		BdpImage.setNextImagePart(contracts, _regionId, _part, _partsCount, _imageDescriptor, _imageData);
1215 	}
1216 
1217 
1218 	// BdpOwnership
1219 
1220 	function ownerOf(uint256 _tokenId) external view returns (address _owner) {
1221 		return BdpOwnership.ownerOf(contracts, _tokenId);
1222 	}
1223 
1224 	function totalSupply() external view returns (uint256 _count) {
1225 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdsLength();
1226 	}
1227 
1228 	function balanceOf(address _owner) external view returns (uint256 _count) {
1229 		return BdpOwnership.balanceOf(contracts, _owner);
1230 	}
1231 
1232 	function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
1233 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedToken(_owner, _index);
1234 	}
1235 
1236 	function tokenByIndex(uint256 _index) external view returns (uint256) {
1237 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdByIndex(_index);
1238 	}
1239 
1240 	function getOwnedArea(address _owner) public view returns (uint256) {
1241 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedArea(_owner);
1242 	}
1243 
1244 
1245 	// BdpTransfer
1246 
1247 	function purchase(uint256 _regionId) whileContractIsActive external payable {
1248 		BdpTransfer.purchase(contracts, _regionId);
1249 	}
1250 
1251 
1252 	// Withdraw
1253 
1254 	function withdrawBalance() external onlyOwner {
1255 		ownerAddress.transfer(this.balance);
1256 	}
1257 
1258 
1259 	// BdpControllerHelper
1260 
1261 	function () public {
1262 		address _impl = BdpContracts.getBdpControllerHelper(contracts);
1263 		require(_impl != address(0));
1264 		bytes memory data = msg.data;
1265 
1266 		assembly {
1267 			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
1268 			let size := returndatasize
1269 			let ptr := mload(0x40)
1270 			returndatacopy(ptr, 0, size)
1271 			switch result
1272 			case 0 { revert(ptr, size) }
1273 			default { return(ptr, size) }
1274 		}
1275 	}
1276 
1277 	function BdpController(bytes8 _version) public {
1278 		ownerAddress = msg.sender;
1279 		managerAddress = msg.sender;
1280 		version = _version;
1281 	}
1282 
1283 }