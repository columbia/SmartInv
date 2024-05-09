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
288 // File: contracts/storage/BdpPriceStorage.sol
289 
290 contract BdpPriceStorage is BdpBase {
291 
292 	uint64[1001] public pricePoints;
293 
294 	uint256 public pricePointsLength = 0;
295 
296 	address public forwardPurchaseFeesTo = address(0);
297 
298 	address public forwardUpdateFeesTo = address(0);
299 
300 
301 	function getPricePointsLength() view public returns (uint256) {
302 		return pricePointsLength;
303 	}
304 
305 	function getPricePoint(uint256 _i) view public returns (uint256) {
306 		return pricePoints[_i];
307 	}
308 
309 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
310 		pricePointsLength = 0;
311 		appendPricePoints(_pricePoints);
312 	}
313 
314 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
315 		for (uint i = 0; i < _pricePoints.length; i++) {
316 			pricePoints[pricePointsLength++] = _pricePoints[i];
317 		}
318 	}
319 
320 	function getForwardPurchaseFeesTo() view public returns (address) {
321 		return forwardPurchaseFeesTo;
322 	}
323 
324 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
325 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
326 	}
327 
328 	function getForwardUpdateFeesTo() view public returns (address) {
329 		return forwardUpdateFeesTo;
330 	}
331 
332 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
333 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
334 	}
335 
336 	function BdpPriceStorage(bytes8 _version) public {
337 		ownerAddress = msg.sender;
338 		managerAddress = msg.sender;
339 		version = _version;
340 	}
341 
342 }
343 
344 // File: contracts/libraries/BdpCalculator.sol
345 
346 library BdpCalculator {
347 
348 	using SafeMath for uint256;
349 
350 	function calculateArea(address[16] _contracts, uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
351 		var (x1, y1, x2, y2) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCoordinates(_regionId);
352 		_width = x2 - x1 + 1;
353 		_height = y2 - y1 + 1;
354 		_area = _width * _height;
355 	}
356 
357 	function countPurchasedPixels(address[16] _contracts) view public returns (uint256 _count) {
358 		var lastRegionId = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getLastRegionId();
359 		for (uint256 i = 0; i <= lastRegionId; i++) {
360 			if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionPurchasedAt(i) > 0) { // region is purchased
361 				var (area,,) = calculateArea(_contracts, i);
362 				_count += area;
363 			}
364 		}
365 	}
366 
367 	function calculateCurrentMarketPixelPrice(address[16] _contracts) view public returns(uint) {
368 		return calculateMarketPixelPrice(_contracts, countPurchasedPixels(_contracts));
369 	}
370 
371 	function calculateMarketPixelPrice(address[16] _contracts, uint _pixelsSold) view public returns(uint) {
372 		var pricePointsLength = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePointsLength();
373 		uint mod = _pixelsSold % (1000000 / (pricePointsLength - 1));
374 		uint div = _pixelsSold * (pricePointsLength - 1) / 1000000;
375 		var divPoint = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div);
376 		if(mod == 0) return divPoint;
377 		return divPoint + mod * (BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div+1) - divPoint) * (pricePointsLength - 1) / 1000000;
378 	}
379 
380 	function calculateAveragePixelPrice(address[16] _contracts, uint _a, uint _b) view public returns (uint _price) {
381 		_price = (calculateMarketPixelPrice(_contracts, _a) + calculateMarketPixelPrice(_contracts, _b)) / 2;
382 	}
383 
384 	/** Current market price per pixel for this region if it is the first sale of this region
385 	  */
386 	function calculateRegionInitialSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
387 		require(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAt(_regionId) > 0); // region exists
388 		var purchasedPixels = countPurchasedPixels(_contracts);
389 		var (area,,) = calculateArea(_contracts, _regionId);
390 		return calculateAveragePixelPrice(_contracts, purchasedPixels, purchasedPixels + area);
391 	}
392 
393 	/** Current market price or (Current market price)*3 if the region was sold
394 	  */
395 	function calculateRegionSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
396 		var pixelPrice = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId);
397 		if(pixelPrice > 0) {
398 			return pixelPrice * 3;
399 		} else {
400 			return calculateRegionInitialSalePixelPrice(_contracts, _regionId);
401 		}
402 	}
403 
404 	/** Setup is allowed one whithin one day after purchase
405 	  */
406 	function calculateSetupAllowedUntil(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
407 		var (updatedAt, purchasedAt) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAtPurchasedAt(_regionId);
408 		if(updatedAt != purchasedAt) {
409 			return 0;
410 		} else {
411 			return purchasedAt + 1 days;
412 		}
413 	}
414 
415 }
416 
417 // File: contracts/storage/BdpImageStorage.sol
418 
419 contract BdpImageStorage is BdpBase {
420 
421 	using SafeMath for uint256;
422 
423 	struct Image {
424 		address owner;
425 		uint256 regionId;
426 		uint256 currentRegionId;
427 		mapping(uint16 => uint256[1000]) data;
428 		mapping(uint16 => uint16) dataLength;
429 		uint16 partsCount;
430 		uint16 width;
431 		uint16 height;
432 		uint16 imageDescriptor;
433 		uint256 blurredAt;
434 	}
435 
436 	uint256 public lastImageId = 0;
437 
438 	mapping(uint256 => Image) public images;
439 
440 
441 	function getLastImageId() view public returns (uint256) {
442 		return lastImageId;
443 	}
444 
445 	function getNextImageId() public storageAccessControl returns (uint256) {
446 		lastImageId = lastImageId.add(1);
447 		return lastImageId;
448 	}
449 
450 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
451 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
452 		uint256 id = getNextImageId();
453 		images[id].owner = _owner;
454 		images[id].regionId = _regionId;
455 		images[id].width = _width;
456 		images[id].height = _height;
457 		images[id].partsCount = _partsCount;
458 		images[id].imageDescriptor = _imageDescriptor;
459 		return id;
460 	}
461 
462 	function imageExists(uint256 _imageId) view public returns (bool) {
463 		return _imageId > 0 && images[_imageId].owner != address(0);
464 	}
465 
466 	function deleteImage(uint256 _imageId) public storageAccessControl {
467 		require(imageExists(_imageId));
468 		delete images[_imageId];
469 	}
470 
471 	function getImageOwner(uint256 _imageId) public view returns (address) {
472 		require(imageExists(_imageId));
473 		return images[_imageId].owner;
474 	}
475 
476 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
477 		require(imageExists(_imageId));
478 		images[_imageId].owner = _owner;
479 	}
480 
481 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
482 		require(imageExists(_imageId));
483 		return images[_imageId].regionId;
484 	}
485 
486 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
487 		require(imageExists(_imageId));
488 		images[_imageId].regionId = _regionId;
489 	}
490 
491 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
492 		require(imageExists(_imageId));
493 		return images[_imageId].currentRegionId;
494 	}
495 
496 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
497 		require(imageExists(_imageId));
498 		images[_imageId].currentRegionId = _currentRegionId;
499 	}
500 
501 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
502 		require(imageExists(_imageId));
503 		return images[_imageId].data[_part];
504 	}
505 
506 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
507 		require(imageExists(_imageId));
508 		images[_imageId].dataLength[_part] = uint16(_data.length);
509 		for (uint256 i = 0; i < _data.length; i++) {
510 			images[_imageId].data[_part][i] = _data[i];
511 		}
512 	}
513 
514 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
515 		require(imageExists(_imageId));
516 		return images[_imageId].dataLength[_part];
517 	}
518 
519 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
520 		require(imageExists(_imageId));
521 		images[_imageId].dataLength[_part] = _dataLength;
522 	}
523 
524 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
525 		require(imageExists(_imageId));
526 		return images[_imageId].partsCount;
527 	}
528 
529 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
530 		require(imageExists(_imageId));
531 		images[_imageId].partsCount = _partsCount;
532 	}
533 
534 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
535 		require(imageExists(_imageId));
536 		return images[_imageId].width;
537 	}
538 
539 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
540 		require(imageExists(_imageId));
541 		images[_imageId].width = _width;
542 	}
543 
544 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
545 		require(imageExists(_imageId));
546 		return images[_imageId].height;
547 	}
548 
549 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
550 		require(imageExists(_imageId));
551 		images[_imageId].height = _height;
552 	}
553 
554 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
555 		require(imageExists(_imageId));
556 		return images[_imageId].imageDescriptor;
557 	}
558 
559 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
560 		require(imageExists(_imageId));
561 		images[_imageId].imageDescriptor = _imageDescriptor;
562 	}
563 
564 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
565 		return images[_imageId].blurredAt;
566 	}
567 
568 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
569 		images[_imageId].blurredAt = _blurredAt;
570 	}
571 
572 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
573 		require(imageExists(_imageId));
574 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
575 			if(images[_imageId].data[i].length == 0) {
576 				return false;
577 			}
578 		}
579 		return true;
580 	}
581 
582 	function BdpImageStorage(bytes8 _version) public {
583 		ownerAddress = msg.sender;
584 		managerAddress = msg.sender;
585 		version = _version;
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
945 // File: contracts/controller/BdpControllerHelper.sol
946 
947 contract BdpControllerHelper is BdpBase {
948 
949 	// BdpCalculator
950 
951 	function calculateArea(uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
952 		return BdpCalculator.calculateArea(contracts, _regionId);
953 	}
954 
955 	function countPurchasedPixels() view public returns (uint256 _count) {
956 		return BdpCalculator.countPurchasedPixels(contracts);
957 	}
958 
959 	function calculateCurrentMarketPixelPrice() view public returns(uint) {
960 		return BdpCalculator.calculateCurrentMarketPixelPrice(contracts);
961 	}
962 
963 	function calculateMarketPixelPrice(uint _pixelsSold) view public returns(uint) {
964 		return BdpCalculator.calculateMarketPixelPrice(contracts, _pixelsSold);
965 	}
966 
967 	function calculateAveragePixelPrice(uint _a, uint _b) view public returns (uint _price) {
968 		return BdpCalculator.calculateAveragePixelPrice(contracts, _a, _b);
969 	}
970 
971 	function calculateRegionInitialSalePixelPrice(uint256 _regionId) view public returns (uint256) {
972 		return BdpCalculator.calculateRegionInitialSalePixelPrice(contracts, _regionId);
973 	}
974 
975 	function calculateRegionSalePixelPrice(uint256 _regionId) view public returns (uint256) {
976 		return BdpCalculator.calculateRegionSalePixelPrice(contracts, _regionId);
977 	}
978 
979 	function calculateSetupAllowedUntil(uint256 _regionId) view public returns (uint256) {
980 		return BdpCalculator.calculateSetupAllowedUntil(contracts, _regionId);
981 	}
982 
983 
984 	// BdpDataStorage
985 
986 	function getLastRegionId() view public returns (uint256) {
987 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getLastRegionId();
988 	}
989 
990 	function getRegionCoordinates(uint256 _regionId) view public returns (uint256, uint256, uint256, uint256) {
991 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCoordinates(_regionId);
992 	}
993 
994 	function getRegionCurrentImageId(uint256 _regionId) view public returns (uint256) {
995 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCurrentImageId(_regionId);
996 	}
997 
998 	function getRegionNextImageId(uint256 _regionId) view public returns (uint256) {
999 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionNextImageId(_regionId);
1000 	}
1001 
1002 	function getRegionUrl(uint256 _regionId) view public returns (uint8[128]) {
1003 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUrl(_regionId);
1004 	}
1005 
1006 	function getRegionCurrentPixelPrice(uint256 _regionId) view public returns (uint256) {
1007 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCurrentPixelPrice(_regionId);
1008 	}
1009 
1010 	function getRegionBlockUpdatedAt(uint256 _regionId) view public returns (uint256) {
1011 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionBlockUpdatedAt(_regionId);
1012 	}
1013 
1014 	function getRegionUpdatedAt(uint256 _regionId) view public returns (uint256) {
1015 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUpdatedAt(_regionId);
1016 	}
1017 
1018 	function getRegionPurchasedAt(uint256 _regionId) view public returns (uint256) {
1019 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasedAt(_regionId);
1020 	}
1021 
1022 	function getRegionPurchasePixelPrice(uint256 _regionId) view public returns (uint256) {
1023 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasePixelPrice(_regionId);
1024 	}
1025 
1026 	function regionExists(uint _regionId) view public returns (bool) {
1027 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUpdatedAt(_regionId) > 0;
1028 	}
1029 
1030 	function regionsIsPurchased(uint _regionId) view public returns (bool) {
1031 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasedAt(_regionId) > 0;
1032 	}
1033 
1034 
1035 	// BdpImageStorage
1036 
1037 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public onlyAuthorized returns (uint256) {
1038 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).createImage(_owner, _regionId, _width, _height, _partsCount, _imageDescriptor);
1039 	}
1040 
1041 	function getImageRegionId(uint256 _imageId) view public returns (uint256) {
1042 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageRegionId(_imageId);
1043 	}
1044 
1045 	function getImageCurrentRegionId(uint256 _imageId) view public returns (uint256) {
1046 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageCurrentRegionId(_imageId);
1047 	}
1048 
1049 	function getImageOwner(uint256 _imageId) view public returns (address) {
1050 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageOwner(_imageId);
1051 	}
1052 
1053 	function setImageOwner(uint256 _imageId, address _owner) public {
1054 		BdpImage.setImageOwner(contracts, _imageId, _owner);
1055 	}
1056 
1057 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
1058 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageData(_imageId, _part);
1059 	}
1060 
1061 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
1062 		BdpImage.setImageData(contracts, _imageId, _part, _imageData);
1063 	}
1064 
1065 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
1066 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageDataLength(_imageId, _part);
1067 	}
1068 
1069 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
1070 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImagePartsCount(_imageId);
1071 	}
1072 
1073 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
1074 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageWidth(_imageId);
1075 	}
1076 
1077 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
1078 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageHeight(_imageId);
1079 	}
1080 
1081 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
1082 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageDescriptor(_imageId);
1083 	}
1084 
1085 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
1086 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageBlurredAt(_imageId);
1087 	}
1088 
1089 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public onlyAuthorized {
1090 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).setImageBlurredAt(_imageId, _blurredAt);
1091 	}
1092 
1093 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
1094 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).imageUploadComplete(_imageId);
1095 	}
1096 
1097 
1098 	// BdpPriceStorage
1099 
1100 	function getForwardPurchaseFeesTo() view public returns (address) {
1101 		return BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).getForwardPurchaseFeesTo();
1102 	}
1103 
1104 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public onlyOwner {
1105 		BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).setForwardPurchaseFeesTo(_forwardPurchaseFeesTo);
1106 	}
1107 
1108 	function getForwardUpdateFeesTo() view public returns (address) {
1109 		return BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).getForwardUpdateFeesTo();
1110 	}
1111 
1112 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public onlyOwner {
1113 		BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).setForwardUpdateFeesTo(_forwardUpdateFeesTo);
1114 	}
1115 
1116 	function BdpControllerHelper(bytes8 _version) public {
1117 		ownerAddress = msg.sender;
1118 		managerAddress = msg.sender;
1119 		version = _version;
1120 	}
1121 
1122 }