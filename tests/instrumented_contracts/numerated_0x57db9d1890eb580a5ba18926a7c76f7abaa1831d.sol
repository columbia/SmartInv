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
272 
273 contract BdpPriceStorage is BdpBase {
274 
275 	uint64[1001] public pricePoints;
276 
277 	uint256 public pricePointsLength = 0;
278 
279 	address public forwardPurchaseFeesTo = address(0);
280 
281 	address public forwardUpdateFeesTo = address(0);
282 
283 
284 	function getPricePointsLength() view public returns (uint256) {
285 		return pricePointsLength;
286 	}
287 
288 	function getPricePoint(uint256 _i) view public returns (uint256) {
289 		return pricePoints[_i];
290 	}
291 
292 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
293 		pricePointsLength = 0;
294 		appendPricePoints(_pricePoints);
295 	}
296 
297 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
298 		for (uint i = 0; i < _pricePoints.length; i++) {
299 			pricePoints[pricePointsLength++] = _pricePoints[i];
300 		}
301 	}
302 
303 	function getForwardPurchaseFeesTo() view public returns (address) {
304 		return forwardPurchaseFeesTo;
305 	}
306 
307 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
308 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
309 	}
310 
311 	function getForwardUpdateFeesTo() view public returns (address) {
312 		return forwardUpdateFeesTo;
313 	}
314 
315 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
316 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
317 	}
318 
319 	function BdpPriceStorage(bytes8 _version) public {
320 		ownerAddress = msg.sender;
321 		managerAddress = msg.sender;
322 		version = _version;
323 	}
324 
325 }
326 
327 library BdpCalculator {
328 
329 	using SafeMath for uint256;
330 
331 	function calculateArea(address[16] _contracts, uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
332 		var (x1, y1, x2, y2) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCoordinates(_regionId);
333 		_width = x2 - x1 + 1;
334 		_height = y2 - y1 + 1;
335 		_area = _width * _height;
336 	}
337 
338 	function countPurchasedPixels(address[16] _contracts) view public returns (uint256 _count) {
339 		var lastRegionId = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getLastRegionId();
340 		for (uint256 i = 0; i <= lastRegionId; i++) {
341 			if(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionPurchasedAt(i) > 0) { // region is purchased
342 				var (area,,) = calculateArea(_contracts, i);
343 				_count += area;
344 			}
345 		}
346 	}
347 
348 	function calculateCurrentMarketPixelPrice(address[16] _contracts) view public returns(uint) {
349 		return calculateMarketPixelPrice(_contracts, countPurchasedPixels(_contracts));
350 	}
351 
352 	function calculateMarketPixelPrice(address[16] _contracts, uint _pixelsSold) view public returns(uint) {
353 		var pricePointsLength = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePointsLength();
354 		uint mod = _pixelsSold % (1000000 / (pricePointsLength - 1));
355 		uint div = _pixelsSold * (pricePointsLength - 1) / 1000000;
356 		var divPoint = BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div);
357 		if(mod == 0) return divPoint;
358 		return divPoint + mod * (BdpPriceStorage(BdpContracts.getBdpPriceStorage(_contracts)).getPricePoint(div+1) - divPoint) * (pricePointsLength - 1) / 1000000;
359 	}
360 
361 	function calculateAveragePixelPrice(address[16] _contracts, uint _a, uint _b) view public returns (uint _price) {
362 		_price = (calculateMarketPixelPrice(_contracts, _a) + calculateMarketPixelPrice(_contracts, _b)) / 2;
363 	}
364 
365 	/** Current market price per pixel for this region if it is the first sale of this region
366 	  */
367 	function calculateRegionInitialSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
368 		require(BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAt(_regionId) > 0); // region exists
369 		var purchasedPixels = countPurchasedPixels(_contracts);
370 		var (area,,) = calculateArea(_contracts, _regionId);
371 		return calculateAveragePixelPrice(_contracts, purchasedPixels, purchasedPixels + area);
372 	}
373 
374 	/** Current market price or (Current market price)*3 if the region was sold
375 	  */
376 	function calculateRegionSalePixelPrice(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
377 		var pixelPrice = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionCurrentPixelPrice(_regionId);
378 		if(pixelPrice > 0) {
379 			return pixelPrice * 3;
380 		} else {
381 			return calculateRegionInitialSalePixelPrice(_contracts, _regionId);
382 		}
383 	}
384 
385 	/** Setup is allowed one whithin one day after purchase
386 	  */
387 	function calculateSetupAllowedUntil(address[16] _contracts, uint256 _regionId) view public returns (uint256) {
388 		var (updatedAt, purchasedAt) = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts)).getRegionUpdatedAtPurchasedAt(_regionId);
389 		if(updatedAt != purchasedAt) {
390 			return 0;
391 		} else {
392 			return purchasedAt + 1 days;
393 		}
394 	}
395 
396 }
397 
398 contract BdpOwnershipStorage is BdpBase {
399 
400 	using SafeMath for uint256;
401 
402 	// Mapping from token ID to owner
403 	mapping (uint256 => address) public tokenOwner;
404 
405 	// Mapping from token ID to approved address
406 	mapping (uint256 => address) public tokenApprovals;
407 
408 	// Mapping from owner to the sum of owned area
409 	mapping (address => uint256) public ownedArea;
410 
411 	// Mapping from owner to list of owned token IDs
412 	mapping (address => uint256[]) public ownedTokens;
413 
414 	// Mapping from token ID to index of the owner tokens list
415 	mapping(uint256 => uint256) public ownedTokensIndex;
416 
417 	// All tokens list tokens ids
418 	uint256[] public tokenIds;
419 
420 	// Mapping from tokenId to index of the tokens list
421 	mapping (uint256 => uint256) public tokenIdsIndex;
422 
423 
424 	function getTokenOwner(uint256 _tokenId) view public returns (address) {
425 		return tokenOwner[_tokenId];
426 	}
427 
428 	function setTokenOwner(uint256 _tokenId, address _owner) public storageAccessControl {
429 		tokenOwner[_tokenId] = _owner;
430 	}
431 
432 	function getTokenApproval(uint256 _tokenId) view public returns (address) {
433 		return tokenApprovals[_tokenId];
434 	}
435 
436 	function setTokenApproval(uint256 _tokenId, address _to) public storageAccessControl {
437 		tokenApprovals[_tokenId] = _to;
438 	}
439 
440 	function getOwnedArea(address _owner) view public returns (uint256) {
441 		return ownedArea[_owner];
442 	}
443 
444 	function setOwnedArea(address _owner, uint256 _area) public storageAccessControl {
445 		ownedArea[_owner] = _area;
446 	}
447 
448 	function incrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
449 		ownedArea[_owner] = ownedArea[_owner].add(_area);
450 		return ownedArea[_owner];
451 	}
452 
453 	function decrementOwnedArea(address _owner, uint256 _area) public storageAccessControl returns (uint256) {
454 		ownedArea[_owner] = ownedArea[_owner].sub(_area);
455 		return ownedArea[_owner];
456 	}
457 
458 	function getOwnedTokensLength(address _owner) view public returns (uint256) {
459 		return ownedTokens[_owner].length;
460 	}
461 
462 	function getOwnedToken(address _owner, uint256 _index) view public returns (uint256) {
463 		return ownedTokens[_owner][_index];
464 	}
465 
466 	function setOwnedToken(address _owner, uint256 _index, uint256 _tokenId) public storageAccessControl {
467 		ownedTokens[_owner][_index] = _tokenId;
468 	}
469 
470 	function pushOwnedToken(address _owner, uint256 _tokenId) public storageAccessControl returns (uint256) {
471 		ownedTokens[_owner].push(_tokenId);
472 		return ownedTokens[_owner].length;
473 	}
474 
475 	function decrementOwnedTokensLength(address _owner) public storageAccessControl {
476 		ownedTokens[_owner].length--;
477 	}
478 
479 	function getOwnedTokensIndex(uint256 _tokenId) view public returns (uint256) {
480 		return ownedTokensIndex[_tokenId];
481 	}
482 
483 	function setOwnedTokensIndex(uint256 _tokenId, uint256 _tokenIndex) public storageAccessControl {
484 		ownedTokensIndex[_tokenId] = _tokenIndex;
485 	}
486 
487 	function getTokenIdsLength() view public returns (uint256) {
488 		return tokenIds.length;
489 	}
490 
491 	function getTokenIdByIndex(uint256 _index) view public returns (uint256) {
492 		return tokenIds[_index];
493 	}
494 
495 	function setTokenIdByIndex(uint256 _index, uint256 _tokenId) public storageAccessControl {
496 		tokenIds[_index] = _tokenId;
497 	}
498 
499 	function pushTokenId(uint256 _tokenId) public storageAccessControl returns (uint256) {
500 		tokenIds.push(_tokenId);
501 		return tokenIds.length;
502 	}
503 
504 	function decrementTokenIdsLength() public storageAccessControl {
505 		tokenIds.length--;
506 	}
507 
508 	function getTokenIdsIndex(uint256 _tokenId) view public returns (uint256) {
509 		return tokenIdsIndex[_tokenId];
510 	}
511 
512 	function setTokenIdsIndex(uint256 _tokenId, uint256 _tokenIdIndex) public storageAccessControl {
513 		tokenIdsIndex[_tokenId] = _tokenIdIndex;
514 	}
515 
516 	function BdpOwnershipStorage(bytes8 _version) public {
517 		ownerAddress = msg.sender;
518 		managerAddress = msg.sender;
519 		version = _version;
520 	}
521 
522 }
523 
524 library BdpOwnership {
525 
526 	using SafeMath for uint256;
527 
528 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
529 
530 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
531 
532 	function ownerOf(address[16] _contracts, uint256 _tokenId) public view returns (address) {
533 		var owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
534 		require(owner != address(0));
535 		return owner;
536 	}
537 
538 	function balanceOf(address[16] _contracts, address _owner) public view returns (uint256) {
539 		return BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getOwnedTokensLength(_owner);
540 	}
541 
542 	function approve(address[16] _contracts, address _to, uint256 _tokenId) public {
543 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
544 
545 		address owner = ownerOf(_contracts, _tokenId);
546 		require(_to != owner);
547 		if (ownStorage.getTokenApproval(_tokenId) != 0 || _to != 0) {
548 			ownStorage.setTokenApproval(_tokenId, _to);
549 			Approval(owner, _to, _tokenId);
550 		}
551 	}
552 
553 	/**
554 	 * @dev Clear current approval of a given token ID
555 	 * @param _tokenId uint256 ID of the token to be transferred
556 	 */
557 	function clearApproval(address[16] _contracts, address _owner, uint256 _tokenId) public {
558 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
559 
560 		require(ownerOf(_contracts, _tokenId) == _owner);
561 		if (ownStorage.getTokenApproval(_tokenId) != 0) {
562 			BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).setTokenApproval(_tokenId, 0);
563 			Approval(_owner, 0, _tokenId);
564 		}
565 	}
566 
567 	/**
568 	 * @dev Clear current approval and transfer the ownership of a given token ID
569 	 * @param _from address which you want to send tokens from
570 	 * @param _to address which you want to transfer the token to
571 	 * @param _tokenId uint256 ID of the token to be transferred
572 	 */
573 	function clearApprovalAndTransfer(address[16] _contracts, address _from, address _to, uint256 _tokenId) public {
574 		require(_to != address(0));
575 		require(_to != ownerOf(_contracts, _tokenId));
576 		require(ownerOf(_contracts, _tokenId) == _from);
577 
578 		clearApproval(_contracts, _from, _tokenId);
579 		removeToken(_contracts, _from, _tokenId);
580 		addToken(_contracts, _to, _tokenId);
581 		Transfer(_from, _to, _tokenId);
582 	}
583 
584 	/**
585 	 * @dev Internal function to add a token ID to the list of a given address
586 	 * @param _to address representing the new owner of the given token ID
587 	 * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
588 	 */
589 	function addToken(address[16] _contracts, address _to, uint256 _tokenId) private {
590 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
591 
592 		require(ownStorage.getTokenOwner(_tokenId) == address(0));
593 
594 		// Set token owner
595 		ownStorage.setTokenOwner(_tokenId, _to);
596 
597 		// Add token to tokenIds list
598 		var tokenIdsLength = ownStorage.pushTokenId(_tokenId);
599 		ownStorage.setTokenIdsIndex(_tokenId, tokenIdsLength.sub(1));
600 
601 		uint256 ownedTokensLength = ownStorage.getOwnedTokensLength(_to);
602 
603 		// Add token to ownedTokens list
604 		ownStorage.pushOwnedToken(_to, _tokenId);
605 		ownStorage.setOwnedTokensIndex(_tokenId, ownedTokensLength);
606 
607 		// Increment total owned area
608 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
609 		ownStorage.incrementOwnedArea(_to, area);
610 	}
611 
612 	/**
613 	 * @dev Internal function to remove a token ID from the list of a given address
614 	 * @param _from address representing the previous owner of the given token ID
615 	 * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
616 	 */
617 	function removeToken(address[16] _contracts, address _from, uint256 _tokenId) private {
618 		var ownStorage = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts));
619 
620 		require(ownerOf(_contracts, _tokenId) == _from);
621 
622 		// Clear token owner
623 		ownStorage.setTokenOwner(_tokenId, 0);
624 
625 		removeFromTokenIds(ownStorage, _tokenId);
626 		removeFromOwnedToken(ownStorage, _from, _tokenId);
627 
628 		// Decrement total owned area
629 		var (area,,) = BdpCalculator.calculateArea(_contracts, _tokenId);
630 		ownStorage.decrementOwnedArea(_from, area);
631 	}
632 
633 	/**
634 	 * @dev Remove token from ownedTokens list
635 	 * Note that this will handle single-element arrays. In that case, both ownedTokenIndex and lastOwnedTokenIndex are going to
636 	 * be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
637 	 * the lastOwnedToken to the first position, and then dropping the element placed in the last position of the list
638 	 */
639 	function removeFromOwnedToken(BdpOwnershipStorage _ownStorage, address _from, uint256 _tokenId) private {
640 		var ownedTokenIndex = _ownStorage.getOwnedTokensIndex(_tokenId);
641 		var lastOwnedTokenIndex = _ownStorage.getOwnedTokensLength(_from).sub(1);
642 		var lastOwnedToken = _ownStorage.getOwnedToken(_from, lastOwnedTokenIndex);
643 		_ownStorage.setOwnedToken(_from, ownedTokenIndex, lastOwnedToken);
644 		_ownStorage.setOwnedToken(_from, lastOwnedTokenIndex, 0);
645 		_ownStorage.decrementOwnedTokensLength(_from);
646 		_ownStorage.setOwnedTokensIndex(_tokenId, 0);
647 		_ownStorage.setOwnedTokensIndex(lastOwnedToken, ownedTokenIndex);
648 	}
649 
650 	/**
651 	 * @dev Remove token from tokenIds list
652 	 */
653 	function removeFromTokenIds(BdpOwnershipStorage _ownStorage, uint256 _tokenId) private {
654 		var tokenIndex = _ownStorage.getTokenIdsIndex(_tokenId);
655 		var lastTokenIdIndex = _ownStorage.getTokenIdsLength().sub(1);
656 		var lastTokenId = _ownStorage.getTokenIdByIndex(lastTokenIdIndex);
657 		_ownStorage.setTokenIdByIndex(tokenIndex, lastTokenId);
658 		_ownStorage.setTokenIdByIndex(lastTokenIdIndex, 0);
659 		_ownStorage.decrementTokenIdsLength();
660 		_ownStorage.setTokenIdsIndex(_tokenId, 0);
661 		_ownStorage.setTokenIdsIndex(lastTokenId, tokenIndex);
662 	}
663 
664 	/**
665 	 * @dev Mint token function
666 	 * @param _to The address that will own the minted token
667 	 * @param _tokenId uint256 ID of the token to be minted by the msg.sender
668 	 */
669 	function mint(address[16] _contracts, address _to, uint256 _tokenId) public {
670 		require(_to != address(0));
671 		addToken(_contracts, _to, _tokenId);
672 		Transfer(address(0), _to, _tokenId);
673 	}
674 
675 	/**
676 	 * @dev Burns a specific token
677 	 * @param _tokenId uint256 ID of the token being burned
678 	 */
679 	function burn(address[16] _contracts, uint256 _tokenId) public {
680 		address owner = BdpOwnershipStorage(BdpContracts.getBdpOwnershipStorage(_contracts)).getTokenOwner(_tokenId);
681 		clearApproval(_contracts, owner, _tokenId);
682 		removeToken(_contracts, owner, _tokenId);
683 		Transfer(owner, address(0), _tokenId);
684 	}
685 
686 }
687 
688 contract BdpImageStorage is BdpBase {
689 
690 	using SafeMath for uint256;
691 
692 	struct Image {
693 		address owner;
694 		uint256 regionId;
695 		uint256 currentRegionId;
696 		mapping(uint16 => uint256[1000]) data;
697 		mapping(uint16 => uint16) dataLength;
698 		uint16 partsCount;
699 		uint16 width;
700 		uint16 height;
701 		uint16 imageDescriptor;
702 		uint256 blurredAt;
703 	}
704 
705 	uint256 public lastImageId = 0;
706 
707 	mapping(uint256 => Image) public images;
708 
709 
710 	function getLastImageId() view public returns (uint256) {
711 		return lastImageId;
712 	}
713 
714 	function getNextImageId() public storageAccessControl returns (uint256) {
715 		lastImageId = lastImageId.add(1);
716 		return lastImageId;
717 	}
718 
719 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public storageAccessControl returns (uint256) {
720 		require(_owner != address(0) && _width > 0 && _height > 0 && _partsCount > 0 && _imageDescriptor > 0);
721 		uint256 id = getNextImageId();
722 		images[id].owner = _owner;
723 		images[id].regionId = _regionId;
724 		images[id].width = _width;
725 		images[id].height = _height;
726 		images[id].partsCount = _partsCount;
727 		images[id].imageDescriptor = _imageDescriptor;
728 		return id;
729 	}
730 
731 	function imageExists(uint256 _imageId) view public returns (bool) {
732 		return _imageId > 0 && images[_imageId].owner != address(0);
733 	}
734 
735 	function deleteImage(uint256 _imageId) public storageAccessControl {
736 		require(imageExists(_imageId));
737 		delete images[_imageId];
738 	}
739 
740 	function getImageOwner(uint256 _imageId) public view returns (address) {
741 		require(imageExists(_imageId));
742 		return images[_imageId].owner;
743 	}
744 
745 	function setImageOwner(uint256 _imageId, address _owner) public storageAccessControl {
746 		require(imageExists(_imageId));
747 		images[_imageId].owner = _owner;
748 	}
749 
750 	function getImageRegionId(uint256 _imageId) public view returns (uint256) {
751 		require(imageExists(_imageId));
752 		return images[_imageId].regionId;
753 	}
754 
755 	function setImageRegionId(uint256 _imageId, uint256 _regionId) public storageAccessControl {
756 		require(imageExists(_imageId));
757 		images[_imageId].regionId = _regionId;
758 	}
759 
760 	function getImageCurrentRegionId(uint256 _imageId) public view returns (uint256) {
761 		require(imageExists(_imageId));
762 		return images[_imageId].currentRegionId;
763 	}
764 
765 	function setImageCurrentRegionId(uint256 _imageId, uint256 _currentRegionId) public storageAccessControl {
766 		require(imageExists(_imageId));
767 		images[_imageId].currentRegionId = _currentRegionId;
768 	}
769 
770 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
771 		require(imageExists(_imageId));
772 		return images[_imageId].data[_part];
773 	}
774 
775 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _data) public storageAccessControl {
776 		require(imageExists(_imageId));
777 		images[_imageId].dataLength[_part] = uint16(_data.length);
778 		for (uint256 i = 0; i < _data.length; i++) {
779 			images[_imageId].data[_part][i] = _data[i];
780 		}
781 	}
782 
783 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
784 		require(imageExists(_imageId));
785 		return images[_imageId].dataLength[_part];
786 	}
787 
788 	function setImageDataLength(uint256 _imageId, uint16 _part, uint16 _dataLength) public storageAccessControl {
789 		require(imageExists(_imageId));
790 		images[_imageId].dataLength[_part] = _dataLength;
791 	}
792 
793 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
794 		require(imageExists(_imageId));
795 		return images[_imageId].partsCount;
796 	}
797 
798 	function setImagePartsCount(uint256 _imageId, uint16 _partsCount) public storageAccessControl {
799 		require(imageExists(_imageId));
800 		images[_imageId].partsCount = _partsCount;
801 	}
802 
803 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
804 		require(imageExists(_imageId));
805 		return images[_imageId].width;
806 	}
807 
808 	function setImageWidth(uint256 _imageId, uint16 _width) public storageAccessControl {
809 		require(imageExists(_imageId));
810 		images[_imageId].width = _width;
811 	}
812 
813 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
814 		require(imageExists(_imageId));
815 		return images[_imageId].height;
816 	}
817 
818 	function setImageHeight(uint256 _imageId, uint16 _height) public storageAccessControl {
819 		require(imageExists(_imageId));
820 		images[_imageId].height = _height;
821 	}
822 
823 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
824 		require(imageExists(_imageId));
825 		return images[_imageId].imageDescriptor;
826 	}
827 
828 	function setImageDescriptor(uint256 _imageId, uint16 _imageDescriptor) public storageAccessControl {
829 		require(imageExists(_imageId));
830 		images[_imageId].imageDescriptor = _imageDescriptor;
831 	}
832 
833 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
834 		return images[_imageId].blurredAt;
835 	}
836 
837 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public storageAccessControl {
838 		images[_imageId].blurredAt = _blurredAt;
839 	}
840 
841 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
842 		require(imageExists(_imageId));
843 		for (uint16 i = 1; i <= images[_imageId].partsCount; i++) {
844 			if(images[_imageId].data[i].length == 0) {
845 				return false;
846 			}
847 		}
848 		return true;
849 	}
850 
851 	function BdpImageStorage(bytes8 _version) public {
852 		ownerAddress = msg.sender;
853 		managerAddress = msg.sender;
854 		version = _version;
855 	}
856 
857 }
858 
859 library BdpImage {
860 
861 	function checkImageInput(address[16] _contracts, uint256 _regionId, uint256 _imageId, uint256[] _imageData, bool _swapImages, bool _clearImage) view public {
862 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
863 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
864 
865 		require( (_imageId == 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // Only one way to change image can be specified
866 			|| (_imageId != 0 && _imageData.length == 0 && !_swapImages && !_clearImage) // If image has to be changed
867 			|| (_imageId == 0 && _imageData.length != 0 && !_swapImages && !_clearImage)
868 			|| (_imageId == 0 && _imageData.length == 0 && _swapImages && !_clearImage)
869 			|| (_imageId == 0 && _imageData.length == 0 && !_swapImages && _clearImage) );
870 
871 		require(_imageId == 0 || // Can use only own images not used by other regions
872 			( (msg.sender == imageStorage.getImageOwner(_imageId)) && (imageStorage.getImageCurrentRegionId(_imageId) == 0) ) );
873 
874 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
875 		require(!_swapImages || imageStorage.imageUploadComplete(nextImageId)); // Can swap images if next image upload is complete
876 	}
877 
878 	function setNextImagePart(address[16] _contracts, uint256 _regionId, uint16 _part, uint16 _partsCount, uint16 _imageDescriptor, uint256[] _imageData) public {
879 		var dataStorage = BdpDataStorage(BdpContracts.getBdpDataStorage(_contracts));
880 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
881 
882 		require(BdpOwnership.ownerOf(_contracts, _regionId) == msg.sender);
883 		require(_imageData.length != 0);
884 		require(_part > 0);
885 		require(_part <= _partsCount);
886 
887 		var nextImageId = dataStorage.getRegionNextImageId(_regionId);
888 		if(nextImageId == 0 || _imageDescriptor != imageStorage.getImageDescriptor(nextImageId)) {
889 			var (, width, height) = BdpCalculator.calculateArea(_contracts, _regionId);
890 			nextImageId = imageStorage.createImage(msg.sender, _regionId, uint16(width), uint16(height), _partsCount, _imageDescriptor);
891 			dataStorage.setRegionNextImageId(_regionId, nextImageId);
892 		}
893 
894 		imageStorage.setImageData(nextImageId, _part, _imageData);
895 	}
896 
897 	function setImageOwner(address[16] _contracts, uint256 _imageId, address _owner) public {
898 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
899 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
900 		require(_owner != address(0));
901 
902 		imageStorage.setImageOwner(_imageId, _owner);
903 	}
904 
905 	function setImageData(address[16] _contracts, uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
906 		var imageStorage = BdpImageStorage(BdpContracts.getBdpImageStorage(_contracts));
907 		require(imageStorage.getImageOwner(_imageId) == msg.sender);
908 		require(imageStorage.getImageCurrentRegionId(_imageId) == 0);
909 		require(_imageData.length != 0);
910 		require(_part > 0);
911 		require(_part <= imageStorage.getImagePartsCount(_imageId));
912 
913 		imageStorage.setImageData(_imageId, _part, _imageData);
914 	}
915 
916 }
917 
918 contract BdpControllerHelper is BdpBase {
919 
920 	// BdpCalculator
921 
922 	function calculateArea(uint256 _regionId) view public returns (uint256 _area, uint256 _width, uint256 _height) {
923 		return BdpCalculator.calculateArea(contracts, _regionId);
924 	}
925 
926 	function countPurchasedPixels() view public returns (uint256 _count) {
927 		return BdpCalculator.countPurchasedPixels(contracts);
928 	}
929 
930 	function calculateCurrentMarketPixelPrice() view public returns(uint) {
931 		return BdpCalculator.calculateCurrentMarketPixelPrice(contracts);
932 	}
933 
934 	function calculateMarketPixelPrice(uint _pixelsSold) view public returns(uint) {
935 		return BdpCalculator.calculateMarketPixelPrice(contracts, _pixelsSold);
936 	}
937 
938 	function calculateAveragePixelPrice(uint _a, uint _b) view public returns (uint _price) {
939 		return BdpCalculator.calculateAveragePixelPrice(contracts, _a, _b);
940 	}
941 
942 	function calculateRegionInitialSalePixelPrice(uint256 _regionId) view public returns (uint256) {
943 		return BdpCalculator.calculateRegionInitialSalePixelPrice(contracts, _regionId);
944 	}
945 
946 	function calculateRegionSalePixelPrice(uint256 _regionId) view public returns (uint256) {
947 		return BdpCalculator.calculateRegionSalePixelPrice(contracts, _regionId);
948 	}
949 
950 	function calculateSetupAllowedUntil(uint256 _regionId) view public returns (uint256) {
951 		return BdpCalculator.calculateSetupAllowedUntil(contracts, _regionId);
952 	}
953 
954 
955 	// BdpDataStorage
956 
957 	function getLastRegionId() view public returns (uint256) {
958 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getLastRegionId();
959 	}
960 
961 	function getRegionCoordinates(uint256 _regionId) view public returns (uint256, uint256, uint256, uint256) {
962 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCoordinates(_regionId);
963 	}
964 
965 	function getRegionCurrentImageId(uint256 _regionId) view public returns (uint256) {
966 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCurrentImageId(_regionId);
967 	}
968 
969 	function getRegionNextImageId(uint256 _regionId) view public returns (uint256) {
970 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionNextImageId(_regionId);
971 	}
972 
973 	function getRegionUrl(uint256 _regionId) view public returns (uint8[128]) {
974 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUrl(_regionId);
975 	}
976 
977 	function getRegionCurrentPixelPrice(uint256 _regionId) view public returns (uint256) {
978 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionCurrentPixelPrice(_regionId);
979 	}
980 
981 	function getRegionBlockUpdatedAt(uint256 _regionId) view public returns (uint256) {
982 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionBlockUpdatedAt(_regionId);
983 	}
984 
985 	function getRegionUpdatedAt(uint256 _regionId) view public returns (uint256) {
986 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUpdatedAt(_regionId);
987 	}
988 
989 	function getRegionPurchasedAt(uint256 _regionId) view public returns (uint256) {
990 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasedAt(_regionId);
991 	}
992 
993 	function getRegionPurchasePixelPrice(uint256 _regionId) view public returns (uint256) {
994 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasePixelPrice(_regionId);
995 	}
996 
997 	function regionExists(uint _regionId) view public returns (bool) {
998 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionUpdatedAt(_regionId) > 0;
999 	}
1000 
1001 	function regionsIsPurchased(uint _regionId) view public returns (bool) {
1002 		return BdpDataStorage(BdpContracts.getBdpDataStorage(contracts)).getRegionPurchasedAt(_regionId) > 0;
1003 	}
1004 
1005 
1006 	// BdpImageStorage
1007 
1008 	function createImage(address _owner, uint256 _regionId, uint16 _width, uint16 _height, uint16 _partsCount, uint16 _imageDescriptor) public onlyAuthorized returns (uint256) {
1009 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).createImage(_owner, _regionId, _width, _height, _partsCount, _imageDescriptor);
1010 	}
1011 
1012 	function getImageRegionId(uint256 _imageId) view public returns (uint256) {
1013 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageRegionId(_imageId);
1014 	}
1015 
1016 	function getImageCurrentRegionId(uint256 _imageId) view public returns (uint256) {
1017 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageCurrentRegionId(_imageId);
1018 	}
1019 
1020 	function getImageOwner(uint256 _imageId) view public returns (address) {
1021 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageOwner(_imageId);
1022 	}
1023 
1024 	function setImageOwner(uint256 _imageId, address _owner) public {
1025 		BdpImage.setImageOwner(contracts, _imageId, _owner);
1026 	}
1027 
1028 	function getImageData(uint256 _imageId, uint16 _part) view public returns (uint256[1000]) {
1029 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageData(_imageId, _part);
1030 	}
1031 
1032 	function setImageData(uint256 _imageId, uint16 _part, uint256[] _imageData) public returns (address) {
1033 		BdpImage.setImageData(contracts, _imageId, _part, _imageData);
1034 	}
1035 
1036 	function getImageDataLength(uint256 _imageId, uint16 _part) view public returns (uint16) {
1037 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageDataLength(_imageId, _part);
1038 	}
1039 
1040 	function getImagePartsCount(uint256 _imageId) view public returns (uint16) {
1041 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImagePartsCount(_imageId);
1042 	}
1043 
1044 	function getImageWidth(uint256 _imageId) view public returns (uint16) {
1045 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageWidth(_imageId);
1046 	}
1047 
1048 	function getImageHeight(uint256 _imageId) view public returns (uint16) {
1049 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageHeight(_imageId);
1050 	}
1051 
1052 	function getImageDescriptor(uint256 _imageId) view public returns (uint16) {
1053 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageDescriptor(_imageId);
1054 	}
1055 
1056 	function getImageBlurredAt(uint256 _imageId) view public returns (uint256) {
1057 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).getImageBlurredAt(_imageId);
1058 	}
1059 
1060 	function setImageBlurredAt(uint256 _imageId, uint256 _blurredAt) public onlyAuthorized {
1061 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).setImageBlurredAt(_imageId, _blurredAt);
1062 	}
1063 
1064 	function imageUploadComplete(uint256 _imageId) view public returns (bool) {
1065 		return BdpImageStorage(BdpContracts.getBdpImageStorage(contracts)).imageUploadComplete(_imageId);
1066 	}
1067 
1068 
1069 	// BdpPriceStorage
1070 
1071 	function getForwardPurchaseFeesTo() view public returns (address) {
1072 		return BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).getForwardPurchaseFeesTo();
1073 	}
1074 
1075 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public onlyOwner {
1076 		BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).setForwardPurchaseFeesTo(_forwardPurchaseFeesTo);
1077 	}
1078 
1079 	function getForwardUpdateFeesTo() view public returns (address) {
1080 		return BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).getForwardUpdateFeesTo();
1081 	}
1082 
1083 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public onlyOwner {
1084 		BdpPriceStorage(BdpContracts.getBdpPriceStorage(contracts)).setForwardUpdateFeesTo(_forwardUpdateFeesTo);
1085 	}
1086 
1087 	function BdpControllerHelper(bytes8 _version) public {
1088 		ownerAddress = msg.sender;
1089 		managerAddress = msg.sender;
1090 		version = _version;
1091 	}
1092 
1093 }