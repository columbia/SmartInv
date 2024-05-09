1 pragma solidity ^0.4.19;
2 
3 library BdpContracts {
4 
5 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
6 		return _contracts[0];
7 	}
8 
9 	function getBdpController(address[16] _contracts) pure internal returns (address) {
10 		return _contracts[1];
11 	}
12 
13 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
14 		return _contracts[3];
15 	}
16 
17 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
18 		return _contracts[4];
19 	}
20 
21 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
22 		return _contracts[5];
23 	}
24 
25 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
26 		return _contracts[6];
27 	}
28 
29 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
30 		return _contracts[7];
31 	}
32 
33 }
34 
35 contract BdpBaseData {
36 
37 	address public ownerAddress;
38 
39 	address public managerAddress;
40 
41 	address[16] public contracts;
42 
43 	bool public paused = false;
44 
45 	bool public setupComplete = false;
46 
47 	bytes8 public version;
48 
49 }
50 
51 contract BdpBase is BdpBaseData {
52 
53 	modifier onlyOwner() {
54 		require(msg.sender == ownerAddress);
55 		_;
56 	}
57 
58 	modifier onlyAuthorized() {
59 		require(msg.sender == ownerAddress || msg.sender == managerAddress);
60 		_;
61 	}
62 
63 	modifier whenContractActive() {
64 		require(!paused && setupComplete);
65 		_;
66 	}
67 
68 	modifier storageAccessControl() {
69 		require(
70 			(! setupComplete && (msg.sender == ownerAddress || msg.sender == managerAddress))
71 			|| (setupComplete && !paused && (msg.sender == BdpContracts.getBdpEntryPoint(contracts)))
72 		);
73 		_;
74 	}
75 
76 	function setOwner(address _newOwner) external onlyOwner {
77 		require(_newOwner != address(0));
78 		ownerAddress = _newOwner;
79 	}
80 
81 	function setManager(address _newManager) external onlyOwner {
82 		require(_newManager != address(0));
83 		managerAddress = _newManager;
84 	}
85 
86 	function setContracts(address[16] _contracts) external onlyOwner {
87 		contracts = _contracts;
88 	}
89 
90 	function pause() external onlyAuthorized {
91 		paused = true;
92 	}
93 
94 	function unpause() external onlyOwner {
95 		paused = false;
96 	}
97 
98 	function setSetupComplete() external onlyOwner {
99 		setupComplete = true;
100 	}
101 
102 	function kill() public onlyOwner {
103 		selfdestruct(ownerAddress);
104 	}
105 
106 }
107 
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that throw on error
111  */
112 library SafeMath {
113 
114   /**
115   * @dev Multiplies two numbers, throws on overflow.
116   */
117   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118     if (a == 0) {
119       return 0;
120     }
121     uint256 c = a * b;
122     assert(c / a == b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return c;
134   }
135 
136   /**
137   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     assert(c >= a);
150     return c;
151   }
152 }
153 
154 contract BdpDataStorage is BdpBase {
155 
156 	using SafeMath for uint256;
157 
158 	struct Region {
159 		uint256 x1;
160 		uint256 y1;
161 		uint256 x2;
162 		uint256 y2;
163 		uint256 currentImageId;
164 		uint256 nextImageId;
165 		uint8[128] url;
166 		uint256 currentPixelPrice;
167 		uint256 blockUpdatedAt;
168 		uint256 updatedAt;
169 		uint256 purchasedAt;
170 		uint256 purchasedPixelPrice;
171 	}
172 
173 	uint256 public lastRegionId = 0;
174 
175 	mapping (uint256 => Region) public data;
176 
177 
178 	function getLastRegionId() view public returns (uint256) {
179 		return lastRegionId;
180 	}
181 
182 	function getNextRegionId() public storageAccessControl returns (uint256) {
183 		lastRegionId = lastRegionId.add(1);
184 		return lastRegionId;
185 	}
186 
187 	function deleteRegionData(uint256 _id) public storageAccessControl {
188 		delete data[_id];
189 	}
190 
191 	function getRegionCoordinates(uint256 _id) view public returns (uint256, uint256, uint256, uint256) {
192 		return (data[_id].x1, data[_id].y1, data[_id].x2, data[_id].y2);
193 	}
194 
195 	function setRegionCoordinates(uint256 _id, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public storageAccessControl {
196 		data[_id].x1 = _x1;
197 		data[_id].y1 = _y1;
198 		data[_id].x2 = _x2;
199 		data[_id].y2 = _y2;
200 	}
201 
202 	function getRegionCurrentImageId(uint256 _id) view public returns (uint256) {
203 		return data[_id].currentImageId;
204 	}
205 
206 	function setRegionCurrentImageId(uint256 _id, uint256 _currentImageId) public storageAccessControl {
207 		data[_id].currentImageId = _currentImageId;
208 	}
209 
210 	function getRegionNextImageId(uint256 _id) view public returns (uint256) {
211 		return data[_id].nextImageId;
212 	}
213 
214 	function setRegionNextImageId(uint256 _id, uint256 _nextImageId) public storageAccessControl {
215 		data[_id].nextImageId = _nextImageId;
216 	}
217 
218 	function getRegionUrl(uint256 _id) view public returns (uint8[128]) {
219 		return data[_id].url;
220 	}
221 
222 	function setRegionUrl(uint256 _id, uint8[128] _url) public storageAccessControl {
223 		data[_id].url = _url;
224 	}
225 
226 	function getRegionCurrentPixelPrice(uint256 _id) view public returns (uint256) {
227 		return data[_id].currentPixelPrice;
228 	}
229 
230 	function setRegionCurrentPixelPrice(uint256 _id, uint256 _currentPixelPrice) public storageAccessControl {
231 		data[_id].currentPixelPrice = _currentPixelPrice;
232 	}
233 
234 	function getRegionBlockUpdatedAt(uint256 _id) view public returns (uint256) {
235 		return data[_id].blockUpdatedAt;
236 	}
237 
238 	function setRegionBlockUpdatedAt(uint256 _id, uint256 _blockUpdatedAt) public storageAccessControl {
239 		data[_id].blockUpdatedAt = _blockUpdatedAt;
240 	}
241 
242 	function getRegionUpdatedAt(uint256 _id) view public returns (uint256) {
243 		return data[_id].updatedAt;
244 	}
245 
246 	function setRegionUpdatedAt(uint256 _id, uint256 _updatedAt) public storageAccessControl {
247 		data[_id].updatedAt = _updatedAt;
248 	}
249 
250 	function getRegionPurchasedAt(uint256 _id) view public returns (uint256) {
251 		return data[_id].purchasedAt;
252 	}
253 
254 	function setRegionPurchasedAt(uint256 _id, uint256 _purchasedAt) public storageAccessControl {
255 		data[_id].purchasedAt = _purchasedAt;
256 	}
257 
258 	function getRegionUpdatedAtPurchasedAt(uint256 _id) view public returns (uint256 _updatedAt, uint256 _purchasedAt) {
259 		return (data[_id].updatedAt, data[_id].purchasedAt);
260 	}
261 
262 	function getRegionPurchasePixelPrice(uint256 _id) view public returns (uint256) {
263 		return data[_id].purchasedPixelPrice;
264 	}
265 
266 	function setRegionPurchasedPixelPrice(uint256 _id, uint256 _purchasedPixelPrice) public storageAccessControl {
267 		data[_id].purchasedPixelPrice = _purchasedPixelPrice;
268 	}
269 
270 	function BdpDataStorage(bytes8 _version) public {
271 		ownerAddress = msg.sender;
272 		managerAddress = msg.sender;
273 		version = _version;
274 	}
275 
276 }
277 
278 contract BdpImageStorage is BdpBase {
279 
280 	using SafeMath for uint256;
281 
282 	struct Image {
283 		address owner;
284 		uint256 regionId;
285 		uint256 currentRegionId;
286 		mapping(uint16 => uint256[1000]) data;
287 		mapping(uint16 => uint16) dataLength;
288 		uint16 partsCount;
289 		uint16 width;
290 		uint16 height;
291 		uint16 imageDescriptor;
292 		uint256 blurredAt;
293 	}
294 
295 	uint256 public lastImageId = 0;
296 
297 	mapping(uint256 => Image) public images;
298 
299 
300 	function getLastImageId() view public returns (uint256) {
301 		return lastImageId;
302 	}
303 
304 	function getNextImageId() public storageAccessControl returns (uint256) {
305 		lastImageId = lastImageId.add(1);
306 		return lastImageId;
307 	}
308 
309 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
310 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
311 		uint256 id = getNextImageId();
312 		images[id].owner = _owner;
313 		images[id].regionId = _regionId;
314 		images[id].width = _width;
315 		images[id].height = _height;
316 		images[id].partsCount = _partsCount;
317 		images[id].imageDescriptor = _imageDescriptor;
318 		return id;
319 	}
320 
321 	function imageExists(uint256 _imageId) view public returns (bool) {
322 		return _imageId > 0 && images[_imageId].owner != address(0);
323 	}
324 
325 	function deleteImage(uint256 _imageId) public storageAccessControl {
326 		require(imageExists(_imageId));
327 		delete images[_imageId];
328 	}
329 
330 	function getImageOwner(uint256 _imageId) public view returns (address) {
331 		require(imageExists(_imageId));
332 		return images[_imageId].owner;
333 	}
334 
335 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
336 		require(imageExists(_imageId));
337 		images[_imageId].owner = _owner;
338 	}
339 
340 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
341 		require(imageExists(_imageId));
342 		return images[_imageId].regionId;
343 	}
344 
345 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
346 		require(imageExists(_imageId));
347 		images[_imageId].regionId = _regionId;
348 	}
349 
350 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
351 		require(imageExists(_imageId));
352 		return images[_imageId].currentRegionId;
353 	}
354 
355 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
356 		require(imageExists(_imageId));
357 		images[_imageId].currentRegionId = _currentRegionId;
358 	}
359 
360 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
361 		require(imageExists(_imageId));
362 		return images[_imageId].data[_part];
363 	}
364 
365 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
366 		require(imageExists(_imageId));
367 		images[_imageId].dataLength[_part] = uint16(_data.length);
368 		for (uint256 i = 0; i < _data.length; i++) {
369 			images[_imageId].data[_part][i] = _data[i];
370 		}
371 	}
372 
373 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
374 		require(imageExists(_imageId));
375 		return images[_imageId].dataLength[_part];
376 	}
377 
378 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
379 		require(imageExists(_imageId));
380 		images[_imageId].dataLength[_part] = _dataLength;
381 	}
382 
383 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
384 		require(imageExists(_imageId));
385 		return images[_imageId].partsCount;
386 	}
387 
388 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
389 		require(imageExists(_imageId));
390 		images[_imageId].partsCount = _partsCount;
391 	}
392 
393 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
394 		require(imageExists(_imageId));
395 		return images[_imageId].width;
396 	}
397 
398 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
399 		require(imageExists(_imageId));
400 		images[_imageId].width = _width;
401 	}
402 
403 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
404 		require(imageExists(_imageId));
405 		return images[_imageId].height;
406 	}
407 
408 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
409 		require(imageExists(_imageId));
410 		images[_imageId].height = _height;
411 	}
412 
413 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
414 		require(imageExists(_imageId));
415 		return images[_imageId].imageDescriptor;
416 	}
417 
418 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
419 		require(imageExists(_imageId));
420 		images[_imageId].imageDescriptor = _imageDescriptor;
421 	}
422 
423 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
424 		return images[_imageId].blurredAt;
425 	}
426 
427 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
428 		images[_imageId].blurredAt = _blurredAt;
429 	}
430 
431 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
432 		require(imageExists(_imageId));
433 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
434 			if(images[_imageId].data[i].length == 0) {
435 				return false;
436 			}
437 		}
438 		return true;
439 	}
440 
441 	function BdpImageStorage(bytes8 _version) public {
442 		ownerAddress = msg.sender;
443 		managerAddress = msg.sender;
444 		version = _version;
445 	}
446 
447 }
448 
449 contract BdpOwnershipStorage is BdpBase {
450 
451 	using SafeMath for uint256;
452 
453 	// Mapping from token ID to owner
454 	mapping (uint256 => address) public tokenOwner;
455 
456 	// Mapping from token ID to approved address
457 	mapping (uint256 => address) public tokenApprovals;
458 
459 	// Mapping from owner to the sum of owned area
460 	mapping (address => uint256) public ownedArea;
461 
462 	// Mapping from owner to list of owned token IDs
463 	mapping (address => uint256[]) public ownedTokens;
464 
465 	// Mapping from token ID to index of the owner tokens list
466 	mapping(uint256 => uint256) public ownedTokensIndex;
467 
468 	// All tokens list tokens ids
469 	uint256[] public tokenIds;
470 
471 	// Mapping from tokenId to index of the tokens list
472 	mapping (uint256 => uint256) public tokenIdsIndex;
473 
474 
475 	function getTokenOwner(uint256 _tokenId) view public returns (address) {
476 		return tokenOwner[_tokenId];
477 	}
478 
479 	function setTokenOwner(uint256 _tokenId, address _owner) public storageAccessControl {
480 		tokenOwner[_tokenId] = _owner;
481 	}
482 
483 	function getTokenApproval(uint256 _tokenId) view public returns (address) {
484 		return tokenApprovals[_tokenId];
485 	}
486 
487 	function setTokenApproval(uint256 _tokenId, address _to) public storageAccessControl {
488 		tokenApprovals[_tokenId] = _to;
489 	}
490 
491 	function getOwnedArea(address _owner) view public returns (uint256) {
492 		return ownedArea[_owner];
493 	}
494 
495 	function setOwnedArea(address _owner, uint256 _area) public storageAccessControl {
496 		ownedArea[_owner] = _area;
497 	}
498 
499 	function incrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
500 		ownedArea[_owner] = ownedArea[_owner].add(_area);
501 		return ownedArea[_owner];
502 	}
503 
504 	function decrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
505 		ownedArea[_owner] = ownedArea[_owner].sub(_area);
506 		return ownedArea[_owner];
507 	}
508 
509 	function getOwnedTokensLength(address _owner) view public returns (uint256) {
510 		return ownedTokens[_owner].length;
511 	}
512 
513 	function getOwnedToken(address _owner, uint256 _index) view public returns (uint256) {
514 		return ownedTokens[_owner][_index];
515 	}
516 
517 	function setOwnedToken(address _owner, uint256 _index, uint256 _tokenId) public storageAccessControl {
518 		ownedTokens[_owner][_index] = _tokenId;
519 	}
520 
521 	function pushOwnedToken(address _owner, uint256 _tokenId) public storageAccessControl returns (uint256) {
522 		ownedTokens[_owner].push(_tokenId);
523 		return ownedTokens[_owner].length;
524 	}
525 
526 	function decrementOwnedTokensLength(address _owner) public storageAccessControl {
527 		ownedTokens[_owner].length--;
528 	}
529 
530 	function getOwnedTokensIndex(uint256 _tokenId) view public returns (uint256) {
531 		return ownedTokensIndex[_tokenId];
532 	}
533 
534 	function setOwnedTokensIndex(uint256 _tokenId, uint256 _tokenIndex) public storageAccessControl {
535 		ownedTokensIndex[_tokenId] = _tokenIndex;
536 	}
537 
538 	function getTokenIdsLength() view public returns (uint256) {
539 		return tokenIds.length;
540 	}
541 
542 	function getTokenIdByIndex(uint256 _index) view public returns (uint256) {
543 		return tokenIds[_index];
544 	}
545 
546 	function setTokenIdByIndex(uint256 _index, uint256 _tokenId) public storageAccessControl {
547 		tokenIds[_index] = _tokenId;
548 	}
549 
550 	function pushTokenId(uint256 _tokenId) public storageAccessControl returns (uint256) {
551 		tokenIds.push(_tokenId);
552 		return tokenIds.length;
553 	}
554 
555 	function decrementTokenIdsLength() public storageAccessControl {
556 		tokenIds.length--;
557 	}
558 
559 	function getTokenIdsIndex(uint256 _tokenId) view public returns (uint256) {
560 		return tokenIdsIndex[_tokenId];
561 	}
562 
563 	function setTokenIdsIndex(uint256 _tokenId, uint256 _tokenIdIndex) public storageAccessControl {
564 		tokenIdsIndex[_tokenId] = _tokenIdIndex;
565 	}
566 
567 	function BdpOwnershipStorage(bytes8 _version) public {
568 		ownerAddress = msg.sender;
569 		managerAddress = msg.sender;
570 		version = _version;
571 	}
572 
573 }
574 
575 contract BdpPriceStorage is BdpBase {
576 
577 	uint64[1001] public pricePoints;
578 
579 	uint256 public pricePointsLength = 0;
580 
581 	address public forwardPurchaseFeesTo = address(0);
582 
583 	address public forwardUpdateFeesTo = address(0);
584 
585 
586 	function getPricePointsLength() view public returns (uint256) {
587 		return pricePointsLength;
588 	}
589 
590 	function getPricePoint(uint256 _i) view public returns (uint256) {
591 		return pricePoints[_i];
592 	}
593 
594 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
595 		pricePointsLength = 0;
596 		appendPricePoints(_pricePoints);
597 	}
598 
599 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
600 		for (uint i = 0; i < _pricePoints.length; i++) {
601 			pricePoints[pricePointsLength++] = _pricePoints[i];
602 		}
603 	}
604 
605 	function getForwardPurchaseFeesTo() view public returns (address) {
606 		return forwardPurchaseFeesTo;
607 	}
608 
609 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
610 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
611 	}
612 
613 	function getForwardUpdateFeesTo() view public returns (address) {
614 		return forwardUpdateFeesTo;
615 	}
616 
617 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
618 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
619 	}
620 
621 	function BdpPriceStorage(bytes8 _version) public {
622 		ownerAddress = msg.sender;
623 		managerAddress = msg.sender;
624 		version = _version;
625 	}
626 
627 }
628 
629 library BdpCalculator {
630 
631 	using SafeMath for uint256;
632 
633 	function calculateArea(address[16] _contracts, uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
634 		var (x1, y1, x2, y2) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCoordinates(_regionId);
635 		_width = x2 - x1 + 1;
636 		_height = y2 - y1 + 1;
637 		_area = _width * _height;
638 	}
639 
640 	function countPurchasedPixels(address[16] _contracts) view public returns (uint256 _count) {
641 		var lastRegionId = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getLastRegionId();
642 		for (uint256 i = 0; i <= lastRegionId; i++) {
643 			if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionPurchasedAt(i) > 0) { // region is purchased
644 				var (area,,) = calculateArea(_contracts, i);
645 				_count += area;
646 			}
647 		}
648 	}
649 
650 	function calculateCurrentMarketPixelPrice(address[16] _contracts) view public returns(uint) {
651 		return calculateMarketPixelPrice(_contracts, countPurchasedPixels(_contracts));
652 	}
653 
654 	function calculateMarketPixelPrice(address[16] _contracts, uint _pixelsSold) view public returns(uint) {
655 		var pricePointsLength = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePointsLength();
656 		uint mod = _pixelsSold % (1000000 / (pricePointsLength - 1));
657 		uint div = _pixelsSold * (pricePointsLength - 1) / 1000000;
658 		var divPoint = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div);
659 		if(mod == 0) return divPoint;
660 		return divPoint + mod * (BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div+1) - divPoint) * (pricePointsLength - 1) / 1000000;
661 	}
662 
663 	function calculateAveragePixelPrice(address[16] _contracts, uint _a, uint _b) view public returns (uint _price) {
664 		_price = (calculateMarketPixelPrice(_contracts, _a) + calculateMarketPixelPrice(_contracts, _b)) / 2;
665 	}
666 
667 	/** Current market price per pixel for this region if it is the first sale of this region
668 	  */
669 	function calculateRegionInitialSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
670 		require(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAt(_regionId) > 0); // region exists
671 		var purchasedPixels = countPurchasedPixels(_contracts);
672 		var (area,,) = calculateArea(_contracts, _regionId);
673 		return calculateAveragePixelPrice(_contracts, purchasedPixels, purchasedPixels + area);
674 	}
675 
676 	/** Current market price or (Current market price)*3 if the region was sold
677 	  */
678 	function calculateRegionSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
679 		var pixelPrice = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId);
680 		if(pixelPrice > 0) {
681 			return pixelPrice * 3;
682 		} else {
683 			return calculateRegionInitialSalePixelPrice(_contracts, _regionId);
684 		}
685 	}
686 
687 	/** Setup is allowed one whithin one day after purchase
688 	  */
689 	function calculateSetupAllowedUntil(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
690 		var (updatedAt, purchasedAt) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAtPurchasedAt(_regionId);
691 		if(updatedAt != purchasedAt) {
692 			return 0;
693 		} else {
694 			return purchasedAt + 1 days;
695 		}
696 	}
697 
698 }
699 
700 library BdpImage {
701 
702 	function checkImageInput(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
703 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
704 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
705 
706 		require( (_imageId == 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // Only one way to change image can be specified
707 			|| (_imageId != 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // If image has to be changed
708 			|| (_imageId == 0 && _imageData.length != 0 && !_swapImages && !_clearImage)
709 			|| (_imageId == 0 && _imageData.length == 0 && _swapImages && !_clearImage)
710 			|| (_imageId == 0 && _imageData.length == 0 && !_swapImages && _clearImage) );
711 
712 		require(_imageId == 0 || // Can use only own images not used by other regions
713 			( (msg.sender == imageStorage.getImageOwner(_imageId)) && (imageStorage.getImageCurrentRegionId(_imageId) == 0) ) );
714 
715 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
716 		require(!_swapImages || imageStorage.imageUploadComplete(nextImageId)); // Can swap images if next image upload is complete
717 	}
718 
719 	function setNextImagePart(address[16] _contracts, uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) public {
720 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
721 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
722 
723 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
724 		require(_imageData.length != 0);
725 		require(_part > 0);
726 		require(_part <= _partsCount);
727 
728 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
729 		if(nextImageId == 0 || _imageDescriptor != imageStorage.getImageDescriptor(nextImageId)) {
730 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
731 			nextImageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), _partsCount, _imageDescriptor);
732 			dataStorage.setRegionNextImageId(_regionId, nextImageId);
733 		}
734 
735 		imageStorage.setImageData(nextImageId, _part, _imageData);
736 	}
737 
738 	function setImageOwner(address[16] _contracts, uint256 _imageId, address _owner) public {
739 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
740 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
741 		require(_owner != address(0));
742 
743 		imageStorage.setImageOwner(_imageId, _owner);
744 	}
745 
746 	function setImageData(address[16] _contracts, uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
747 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
748 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
749 		require(imageStorage.getImageCurrentRegionId(_imageId) == 0);
750 		require(_imageData.length != 0);
751 		require(_part > 0);
752 		require(_part <= imageStorage.getImagePartsCount(_imageId));
753 
754 		imageStorage.setImageData(_imageId, _part, _imageData);
755 	}
756 
757 }
758 
759 library BdpOwnership {
760 
761 	using SafeMath for uint256;
762 
763 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
764 
765 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
766 
767 	function ownerOf(address[16] _contracts, uint256 _tokenId) public view returns (address) {
768 		var owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
769 		require(owner != address(0));
770 		return owner;
771 	}
772 
773 	function balanceOf(address[16] _contracts, address _owner) public view returns (uint256) {
774 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getOwnedTokensLength(_owner);
775 	}
776 
777 	function approve(address[16] _contracts, address _to, uint256 _tokenId) public {
778 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
779 
780 		address owner = ownerOf(_contracts, _tokenId);
781 		require(_to != owner);
782 		if (ownStorage.getTokenApproval(_tokenId) != 0 || _to != 0) {
783 			ownStorage.setTokenApproval(_tokenId, _to);
784 			Approval(owner, _to, _tokenId);
785 		}
786 	}
787 
788 	/**
789 	 * @dev Clear current approval of a given token ID
790 	 * @param _tokenId uint256 ID of the token to be transferred
791 	 */
792 	function clearApproval(address[16] _contracts, address _owner, uint256 _tokenId) public {
793 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
794 
795 		require(ownerOf(_contracts, _tokenId) == _owner);
796 		if (ownStorage.getTokenApproval(_tokenId) != 0) {
797 			BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).setTokenApproval(_tokenId, 0);
798 			Approval(_owner, 0, _tokenId);
799 		}
800 	}
801 
802 	/**
803 	 * @dev Clear current approval and transfer the ownership of a given token ID
804 	 * @param _from address which you want to send tokens from
805 	 * @param _to address which you want to transfer the token to
806 	 * @param _tokenId uint256 ID of the token to be transferred
807 	 */
808 	function clearApprovalAndTransfer(address[16] _contracts, address _from, address _to, uint256 _tokenId) public {
809 		require(_to != address(0));
810 		require(_to != ownerOf(_contracts, _tokenId));
811 		require(ownerOf(_contracts, _tokenId) == _from);
812 
813 		clearApproval(_contracts, _from, _tokenId);
814 		removeToken(_contracts, _from, _tokenId);
815 		addToken(_contracts, _to, _tokenId);
816 		Transfer(_from, _to, _tokenId);
817 	}
818 
819 	/**
820 	 * @dev Internal function to add a token ID to the list of a given address
821 	 * @param _to address representing the new owner of the given token ID
822 	 * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
823 	 */
824 	function addToken(address[16] _contracts, address _to, uint256 _tokenId) private {
825 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
826 
827 		require(ownStorage.getTokenOwner(_tokenId) == address(0));
828 
829 		// Set token owner
830 		ownStorage.setTokenOwner(_tokenId, _to);
831 
832 		// Add token to tokenIds list
833 		var tokenIdsLength = ownStorage.pushTokenId(_tokenId);
834 		ownStorage.setTokenIdsIndex(_tokenId, tokenIdsLength.sub(1));
835 
836 		uint256 ownedTokensLength = ownStorage.getOwnedTokensLength(_to);
837 
838 		// Add token to ownedTokens list
839 		ownStorage.pushOwnedToken(_to, _tokenId);
840 		ownStorage.setOwnedTokensIndex(_tokenId, ownedTokensLength);
841 
842 		// Increment total owned area
843 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
844 		ownStorage.incrementOwnedArea(_to, area);
845 	}
846 
847 	/**
848 	 * @dev Internal function to remove a token ID from the list of a given address
849 	 * @param _from address representing the previous owner of the given token ID
850 	 * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
851 	 */
852 	function removeToken(address[16] _contracts, address _from, uint256 _tokenId) private {
853 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
854 
855 		require(ownerOf(_contracts, _tokenId) == _from);
856 
857 		// Clear token owner
858 		ownStorage.setTokenOwner(_tokenId, 0);
859 
860 		removeFromTokenIds(ownStorage, _tokenId);
861 		removeFromOwnedToken(ownStorage, _from, _tokenId);
862 
863 		// Decrement total owned area
864 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
865 		ownStorage.decrementOwnedArea(_from, area);
866 	}
867 
868 	/**
869 	 * @dev Remove token from ownedTokens list
870 	 * Note that this will handle single-element arrays. In that case, both ownedTokenIndex and lastOwnedTokenIndex are going to
871 	 * be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
872 	 * the lastOwnedToken to the first position, and then dropping the element placed in the last position of the list
873 	 */
874 	function removeFromOwnedToken(BdpOwnershipStorage _ownStorage, address _from, uint256 _tokenId) private {
875 		var ownedTokenIndex = _ownStorage.getOwnedTokensIndex(_tokenId);
876 		var lastOwnedTokenIndex = _ownStorage.getOwnedTokensLength(_from).sub(1);
877 		var lastOwnedToken = _ownStorage.getOwnedToken(_from, lastOwnedTokenIndex);
878 		_ownStorage.setOwnedToken(_from, ownedTokenIndex, lastOwnedToken);
879 		_ownStorage.setOwnedToken(_from, lastOwnedTokenIndex, 0);
880 		_ownStorage.decrementOwnedTokensLength(_from);
881 		_ownStorage.setOwnedTokensIndex(_tokenId, 0);
882 		_ownStorage.setOwnedTokensIndex(lastOwnedToken, ownedTokenIndex);
883 	}
884 
885 	/**
886 	 * @dev Remove token from tokenIds list
887 	 */
888 	function removeFromTokenIds(BdpOwnershipStorage _ownStorage, uint256 _tokenId) private {
889 		var tokenIndex = _ownStorage.getTokenIdsIndex(_tokenId);
890 		var lastTokenIdIndex = _ownStorage.getTokenIdsLength().sub(1);
891 		var lastTokenId = _ownStorage.getTokenIdByIndex(lastTokenIdIndex);
892 		_ownStorage.setTokenIdByIndex(tokenIndex, lastTokenId);
893 		_ownStorage.setTokenIdByIndex(lastTokenIdIndex, 0);
894 		_ownStorage.decrementTokenIdsLength();
895 		_ownStorage.setTokenIdsIndex(_tokenId, 0);
896 		_ownStorage.setTokenIdsIndex(lastTokenId, tokenIndex);
897 	}
898 
899 	/**
900 	 * @dev Mint token function
901 	 * @param _to The address that will own the minted token
902 	 * @param _tokenId uint256 ID of the token to be minted by the msg.sender
903 	 */
904 	function mint(address[16] _contracts, address _to, uint256 _tokenId) public {
905 		require(_to != address(0));
906 		addToken(_contracts, _to, _tokenId);
907 		Transfer(address(0), _to, _tokenId);
908 	}
909 
910 	/**
911 	 * @dev Burns a specific token
912 	 * @param _tokenId uint256 ID of the token being burned
913 	 */
914 	function burn(address[16] _contracts, uint256 _tokenId) public {
915 		address owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
916 		clearApproval(_contracts, owner, _tokenId);
917 		removeToken(_contracts, owner, _tokenId);
918 		Transfer(owner, address(0), _tokenId);
919 	}
920 
921 }
922 
923 library BdpCrud {
924 
925 	function createRegion(address[16] _contracts, address _to, uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public returns (uint256) {
926 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
927 		require(_x2 < 1000 && _x1 <= _x2);
928 		require(_y2 < 1000 && _y1 <= _y2);
929 
930 		var regionId = dataStorage.getNextRegionId();
931 		dataStorage.setRegionCoordinates(regionId, _x1, _y1, _x2, _y2);
932 		dataStorage.setRegionBlockUpdatedAt(regionId, block.number);
933 		dataStorage.setRegionUpdatedAt(regionId, block.timestamp);
934 
935 		BdpOwnership.mint(_contracts, _to, regionId);
936 
937 		return regionId;
938 	}
939 
940 	function deleteRegion(address[16] _contracts, uint256 _regionId) public {
941 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
942 		var regionPurchasePixelPrice = dataStorage.getRegionPurchasePixelPrice(_regionId);
943 		require(regionPurchasePixelPrice == 0);
944 		BdpOwnership.burn(_contracts, _regionId);
945 		dataStorage.deleteRegionData(_regionId);
946 	}
947 
948 	function setupRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) public {
949 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
950 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
951 		require(_imageId != 0 || _imageData.length != 0 || _swapImages || _url.length != 0); // Only if image or url is specified
952 		require(block.timestamp < BdpCalculator.calculateSetupAllowedUntil(_contracts, _regionId)); // Can only execute if setup is allowed
953 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, false);
954 
955 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, false);
956 		_updateRegionUrl(dataStorage, _regionId, _url, false);
957 
958 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
959 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
960 	}
961 
962 	function updateRegion(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) public {
963 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
964 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
965 		BdpImage.checkImageInput(_contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
966 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
967 		require(regionCurrentPixelPrice != 0); // region was purchased
968 
969 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
970 
971 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
972 		_processUpdateFee(_contracts, marketPixelPrice * area / 20);
973 
974 		_updateRegionImage(_contracts, dataStorage, _regionId, _imageId, _imageData, _swapImages, _clearImage);
975 		_updateRegionUrl(dataStorage, _regionId, _url, _deleteUrl);
976 		_updateRegionOwner(_contracts, _regionId, _newOwner);
977 		if(marketPixelPrice > regionCurrentPixelPrice) {
978 			dataStorage.setRegionCurrentPixelPrice(_regionId, marketPixelPrice);
979 		}
980 		dataStorage.setRegionBlockUpdatedAt(_regionId, block.number);
981 		dataStorage.setRegionUpdatedAt(_regionId, block.timestamp);
982 	}
983 
984 	function updateRegionPixelPrice(address[16] _contracts, uint256 _regionId, uint256 _pixelPrice) public {
985 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
986 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
987 		var regionCurrentPixelPrice = dataStorage.getRegionCurrentPixelPrice(_regionId);
988 		require(regionCurrentPixelPrice != 0); // region was purchased
989 
990 		var marketPixelPrice = BdpCalculator.calculateCurrentMarketPixelPrice(_contracts);
991 		require(_pixelPrice >= marketPixelPrice);
992 
993 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
994 		_processUpdateFee(_contracts, _pixelPrice * area / 20);
995 
996 		dataStorage.setRegionCurrentPixelPrice(_regionId, _pixelPrice);
997 	}
998 
999 	function _processUpdateFee(address[16] _contracts, uint256 _updateFee) internal {
1000 		require(msg.value >= _updateFee);
1001 
1002 		if(msg.value > _updateFee) {
1003 			var change = msg.value - _updateFee;
1004 			msg.sender.transfer(change);
1005 		}
1006 
1007 		var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1008 		if(forwardUpdateFeesTo != address(0)) {
1009 			forwardUpdateFeesTo.transfer(_updateFee);
1010 		}
1011 	}
1012 
1013 	function _updateRegionImage(address[16] _contracts, BdpDataStorage _dataStorage, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) internal {
1014 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
1015 		var currentImageId = _dataStorage.getRegionCurrentImageId(_regionId);
1016 		if(_imageId != 0) {
1017 			if(currentImageId != 0) {
1018 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1019 			}
1020 			_dataStorage.setRegionCurrentImageId(_regionId, _imageId);
1021 			imageStorage.setImageCurrentRegionId(_imageId, _regionId);
1022 		}
1023 
1024 		if(_imageData.length > 0) {
1025 			if(currentImageId != 0) {
1026 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1027 			}
1028 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
1029 			var imageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), 1, 1);
1030 			imageStorage.setImageData(imageId, 1, _imageData);
1031 			_dataStorage.setRegionCurrentImageId(_regionId, imageId);
1032 			imageStorage.setImageCurrentRegionId(imageId, _regionId);
1033 		}
1034 
1035 		if(_swapImages) {
1036 			if(currentImageId != 0) {
1037 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1038 			}
1039 			var nextImageId = _dataStorage.getRegionNextImageId(_regionId);
1040 			_dataStorage.setRegionCurrentImageId(_regionId, nextImageId);
1041 			imageStorage.setImageCurrentRegionId(nextImageId, _regionId);
1042 			_dataStorage.setRegionNextImageId(_regionId, 0);
1043 		}
1044 
1045 		if(_clearImage) {
1046 			if(currentImageId != 0) {
1047 				imageStorage.setImageCurrentRegionId(currentImageId, 0);
1048 			}
1049 			_dataStorage.setRegionCurrentImageId(_regionId, 0);
1050 		}
1051 	}
1052 
1053 	function _updateRegionUrl(BdpDataStorage _dataStorage, uint256 _regionId, uint8[128] _url, bool _deleteUrl) internal {
1054 		if(_url[0] != 0) {
1055 			_dataStorage.setRegionUrl(_regionId, _url);
1056 		}
1057 		if(_deleteUrl) {
1058 			uint8[128] memory emptyUrl;
1059 			_dataStorage.setRegionUrl(_regionId, emptyUrl);
1060 		}
1061 	}
1062 
1063 	function _updateRegionOwner(address[16] _contracts, uint256 _regionId, address _newOwner) internal {
1064 		if(_newOwner != address(0)) {
1065 			BdpOwnership.clearApprovalAndTransfer(_contracts, msg.sender, _newOwner, _regionId);
1066 		}
1067 	}
1068 
1069 }
1070 
1071 library BdpTransfer {
1072 
1073 	using SafeMath for uint256;
1074 
1075 	function approve(address[16] _contracts, address _to, uint256 _regionId) public {
1076 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
1077 		BdpOwnership.approve(_contracts, _to, _regionId);
1078 	}
1079 
1080 	function purchase(address[16] _contracts, uint256 _regionId) public {
1081 		uint256 pixelPrice = BdpCalculator.calculateRegionSalePixelPrice(_contracts, _regionId);
1082 		var (area,,) = BdpCalculator.calculateArea(_contracts, _regionId);
1083 		uint256 regionPrice = pixelPrice * area;
1084 
1085 		require(msg.value >= regionPrice );
1086 
1087 		if(msg.value > regionPrice) {
1088 			uint256 change = msg.value - regionPrice;
1089 			msg.sender.transfer(change);
1090 		}
1091 
1092 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionCurrentPixelPrice(_regionId, pixelPrice);
1093 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionBlockUpdatedAt(_regionId, block.number);
1094 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionUpdatedAt(_regionId, block.timestamp);
1095 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedAt(_regionId, block.timestamp);
1096 		BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).setRegionPurchasedPixelPrice(_regionId, pixelPrice);
1097 
1098 		BdpOwnership.clearApprovalAndTransfer(_contracts, BdpOwnership.ownerOf(_contracts, _regionId), msg.sender, _regionId);
1099 
1100 		if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId) > 0) { // send 95% ether to ownerOf(_regionId)
1101 			uint256 etherToPreviousOwner = regionPrice * 19 / 20;
1102 			BdpOwnership.ownerOf(_contracts, _regionId).transfer(etherToPreviousOwner);
1103 			var forwardUpdateFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardUpdateFeesTo();
1104 			if(forwardUpdateFeesTo != address(0)) {
1105 				forwardUpdateFeesTo.transfer(regionPrice - etherToPreviousOwner);
1106 			}
1107 		} else {
1108 			var forwardPurchaseFeesTo = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getForwardPurchaseFeesTo();
1109 			if(forwardPurchaseFeesTo != address(0)) {
1110 				forwardPurchaseFeesTo.transfer(regionPrice);
1111 			}
1112 		}
1113 	}
1114 
1115 }
1116 
1117 contract BdpController is BdpBase {
1118 
1119 	function name() external pure returns (string) {
1120 		return "The Billion Dollar Picture";
1121 	}
1122 
1123 	function symbol() external pure returns (string) {
1124 		return "BDP";
1125 	}
1126 
1127 	function tokenURI(uint256 _tokenId) external view returns (string _tokenURI) {
1128 		_tokenURI = "https://www.billiondollarpicture.com/#0000000";
1129 		bytes memory tokenURIBytes = bytes(_tokenURI);
1130 		tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
1131 		tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
1132 		tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
1133 		tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
1134 		tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
1135 		tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
1136 		tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
1137 	}
1138 
1139 
1140 	// BdpCrud
1141 
1142 	function createRegion(uint256 _x1, uint256 _y1, uint256 _x2, uint256 _y2) public onlyAuthorized returns (uint256) {
1143 		BdpCrud.createRegion(contracts, msg.sender, _x1, _y1, _x2, _y2);
1144 	}
1145 
1146 	function deleteRegion(uint256 _regionId) public onlyAuthorized returns (uint256) {
1147 		BdpCrud.deleteRegion(contracts, _regionId);
1148 	}
1149 
1150 	function setupRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, uint8[128] _url) whenContractActive public {
1151 		BdpCrud.setupRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _url);
1152 	}
1153 
1154 	function updateRegion(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage, uint8[128] _url, bool _deleteUrl, address _newOwner) whenContractActive public payable {
1155 		BdpCrud.updateRegion(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage, _url, _deleteUrl, _newOwner);
1156 	}
1157 
1158 	function updateRegionPixelPrice(uint256 _regionId, uint256 _pixelPrice) whenContractActive public payable {
1159 		BdpCrud.updateRegionPixelPrice(contracts, _regionId, _pixelPrice);
1160 	}
1161 
1162 
1163 	// BdpImage
1164 
1165 	function checkImageInput(uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
1166 		BdpImage.checkImageInput(contracts, _regionId, _imageId, _imageData, _swapImages, _clearImage);
1167 	}
1168 
1169 	function setNextImagePart(uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) whenContractActive public {
1170 		BdpImage.setNextImagePart(contracts, _regionId, _part, _partsCount, _imageDescriptor, _imageData);
1171 	}
1172 
1173 
1174 	// BdpOwnership
1175 
1176 	function ownerOf(uint256 _tokenId) external view returns (address _owner) {
1177 		return BdpOwnership.ownerOf(contracts, _tokenId);
1178 	}
1179 
1180 	function totalSupply() external view returns (uint256 _count) {
1181 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdsLength();
1182 	}
1183 
1184 	function balanceOf(address _owner) external view returns (uint256 _count) {
1185 		return BdpOwnership.balanceOf(contracts, _owner);
1186 	}
1187 
1188 	function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
1189 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedToken(_owner, _index);
1190 	}
1191 
1192 	function tokenByIndex(uint256 _index) external view returns (uint256) {
1193 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getTokenIdByIndex(_index);
1194 	}
1195 
1196 	function getOwnedArea(address _owner) public view returns (uint256) {
1197 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(contracts)).getOwnedArea(_owner);
1198 	}
1199 
1200 
1201 	// BdpTransfer
1202 
1203 	function purchase(uint256 _regionId) whenContractActive external payable {
1204 		BdpTransfer.purchase(contracts, _regionId);
1205 	}
1206 
1207 
1208 	// Withdraw
1209 
1210 	function withdrawBalance() external onlyOwner {
1211 		ownerAddress.transfer(this.balance);
1212 	}
1213 
1214 
1215 	// BdpControllerHelper
1216 
1217 	function () public {
1218 		address _impl = BdpContracts.getBdpControllerHelper(contracts);
1219 		require(_impl != address(0));
1220 		bytes memory data = msg.data;
1221 
1222 		assembly {
1223 			let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
1224 			let size := returndatasize
1225 			let ptr := mload(0x40)
1226 			returndatacopy(ptr, 0, size)
1227 			switch result
1228 			case 0 { revert(ptr, size) }
1229 			default { return(ptr, size) }
1230 		}
1231 	}
1232 
1233 	function BdpController(bytes8 _version) public {
1234 		ownerAddress = msg.sender;
1235 		managerAddress = msg.sender;
1236 		version = _version;
1237 	}
1238 
1239 }