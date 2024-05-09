1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC721 token receiver interface
6  * @dev Interface for any contract that wants to support safeTransfers from ERC721 asset contracts.
7  * See (https://github.com/OpenZeppelin/openzeppelin-solidity)
8  */
9 contract ERC721Receiver {
10 
11 	/**
12 	 * @dev Magic value to be returned upon successful reception of an NFT.
13 	 * Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
14 	 * which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
15 	 */
16 	bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
17 
18 	/**
19 	 * @notice Handle the receipt of an NFT
20 	 * @dev The ERC721 smart contract calls this function on the recipient
21 	 * after a `safetransfer`. This function MAY throw to revert and reject the
22 	 * transfer. Return of other than the magic value MUST result in the
23 	 * transaction being reverted.
24 	 * Note: the contract address is always the message sender.
25 	 * @param _operator The address which called `safeTransferFrom` function
26 	 * @param _from The address which previously owned the token
27 	 * @param _tokenId The NFT identifier which is being transferred
28 	 * @param _data Additional data with no specified format
29 	 * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
30 	 */
31 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
32 }
33 
34 
35 /**
36  * @title PixelCon Market
37  * @notice This is the main market contract for buying and selling PixelCons. Listings are created by transferring PixelCons to this contract through
38  * the PixelCons contract. Listings can be removed from the market at any time. An admin user has the ability to change market parameters such as min 
39  * and max acceptable values, as well as the ability to lock the market from any new listings and/or purchases. The admin cannot prevent users from
40  * removing their listings at any time.
41  * @author PixelCons
42  */
43 contract PixelConMarket is ERC721Receiver {
44 
45 	/** @dev Different contract lock states */
46 	uint8 private constant LOCK_NONE = 0;
47 	uint8 private constant LOCK_NO_LISTING = 1;
48 	uint8 private constant LOCK_REMOVE_ONLY = 2;
49 
50 	/** @dev Math constants */
51 	uint256 private constant WEI_PER_GWEI = 1000000000;
52 	uint256 private constant FEE_RATIO = 100000;
53 
54 
55 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
56 	///////////////////////////////////////////////////////////// Structs ///////////////////////////////////////////////////////////////////////
57 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
58 
59 	/** @dev Market listing data */
60 	struct Listing {
61 		uint64 startAmount; //gwei
62 		uint64 endAmount; //gwei
63 		uint64 startDate;
64 		uint64 duration;
65 		//// ^256bits ////
66 		address seller;
67 		uint32 sellerIndex;
68 		uint64 forSaleIndex;
69 	}
70 
71 
72 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
73 	///////////////////////////////////////////////////////////// Storage ///////////////////////////////////////////////////////////////////////
74 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
75 
76 	/** @dev Market modifiable parameters */
77 	uint32 internal devFee; //percent*100000
78 	uint32 internal priceUpdateInterval; //seconds
79 	uint32 internal startDateRoundValue; //seconds
80 	uint32 internal durationRoundValue; //seconds
81 	uint64 internal maxDuration; //seconds
82 	uint64 internal minDuration; //seconds
83 	uint256 internal maxPrice; //wei
84 	uint256 internal minPrice; //wei
85 
86 	/** @dev Admin data */
87 	PixelCons internal pixelconsContract;
88 	address internal admin;
89 	uint8 internal systemLock;
90 
91 	////////////////// Listings //////////////////
92 
93 	/** @dev Links a seller to the PixelCon indexes he/she has for sale */
94 	mapping(address => uint64[]) internal sellerPixelconIndexes;
95 
96 	/** @dev Links a PixelCon index to market listing */
97 	mapping(uint64 => Listing) internal marketPixelconListings;
98 
99 	/** @dev Keeps track of all PixelCons for sale by index */
100 	uint64[] internal forSalePixelconIndexes;
101 
102 
103 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
104 	///////////////////////////////////////////////////////////// Events ////////////////////////////////////////////////////////////////////////
105 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
106 
107 	/** @dev Market listing events */
108 	event Create(uint64 indexed _tokenIndex, address indexed _seller, uint256 _startPrice, uint256 _endPrice, uint64 _duration);
109 	event Purchase(uint64 indexed _tokenIndex, address indexed _buyer, uint256 _price);
110 	event Remove(uint64 indexed _tokenIndex, address indexed _operator);
111 
112 
113 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
114 	/////////////////////////////////////////////////////////// Modifiers ///////////////////////////////////////////////////////////////////////
115 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
116 
117 	/**  @dev Requires sender be the designated admin */
118 	modifier onlyAdmin {
119 		require(msg.sender == admin, "Only the admin can call this function");
120 		_;
121 	}
122 
123 	/** @dev Small validators for quick validation of function parameters */
124 	modifier validAddress(address _address) {
125 		require(_address != address(0), "Invalid address");
126 		_;
127 	}
128 
129 
130 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
131 	//////////////////////////////////////////////////////////// Market Admin ///////////////////////////////////////////////////////////////////
132 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
133 
134 	/**
135 	 * @notice Contract constructor
136 	 * @param _admin Admin address
137 	 * @param _pixelconContract PixelCon contract address
138 	 */
139 	constructor(address _admin, address _pixelconContract) public 
140 	{
141 		require(_admin != address(0), "Invalid address");
142 		require(_pixelconContract != address(0), "Invalid address");
143 		admin = _admin;
144 		pixelconsContract = PixelCons(_pixelconContract);
145 		systemLock = LOCK_REMOVE_ONLY;
146 
147 		//default values
148 		devFee = 1000;
149 		priceUpdateInterval = 1 * 60 * 60;
150 		startDateRoundValue = 5 * 60;
151 		durationRoundValue = 5 * 60;
152 		maxDuration = 30 * 24 * 60 * 60;
153 		minDuration = 1 * 24 * 60 * 60;
154 		maxPrice = 100000000000000000000;
155 		minPrice = 1000000000000000;
156 	}
157 
158 	/**
159 	 * @notice Change the market admin
160 	 * @dev Only the market admin can access this function
161 	 * @param _newAdmin The new admin address
162 	 */
163 	function adminChange(address _newAdmin) public onlyAdmin validAddress(_newAdmin) 
164 	{
165 		admin = _newAdmin;
166 	}
167 
168 	/**
169 	 * @notice Set the lock state of the market
170 	 * @dev Only the market admin can access this function
171 	 * @param _lock Flag for locking the market
172 	 * @param _allowPurchase Flag for allowing purchases while locked
173 	 */
174 	function adminSetLock(bool _lock, bool _allowPurchase) public onlyAdmin 
175 	{
176 		if (_lock) {
177 			if (_allowPurchase) systemLock = LOCK_NO_LISTING;
178 			else systemLock = LOCK_REMOVE_ONLY;
179 		} else {
180 			systemLock = LOCK_NONE;
181 		}
182 	}
183 
184 	/**
185 	 * @notice Set the market parameters
186 	 * @dev Only the market admin can access this function
187 	 * @param _devFee Developer fee required to purchase market listing (percent*100000)
188 	 * @param _priceUpdateInterval Amount of time before prices update (seconds)
189 	 * @param _startDateRoundValue Value to round market listing start dates to (seconds)
190 	 * @param _durationRoundValue Value to round market listing durations to (seconds)
191 	 * @param _maxDuration Maximum market listing duration (seconds)
192 	 * @param _minDuration Minimum market listing duration (seconds)
193 	 * @param _maxPrice Maximum market listing price (wei)
194 	 * @param _minPrice Minimum market listing price (wei)
195 	 */
196 	function adminSetDetails(uint32 _devFee, uint32 _priceUpdateInterval, uint32 _startDateRoundValue, uint32 _durationRoundValue,
197 		uint64 _maxDuration, uint64 _minDuration, uint256 _maxPrice, uint256 _minPrice) public onlyAdmin 
198 	{
199 		devFee = _devFee;
200 		priceUpdateInterval = _priceUpdateInterval;
201 		startDateRoundValue = _startDateRoundValue;
202 		durationRoundValue = _durationRoundValue;
203 		maxDuration = _maxDuration;
204 		minDuration = _minDuration;
205 		maxPrice = _maxPrice;
206 		minPrice = _minPrice;
207 	}
208 
209 	/**
210 	 * @notice Withdraw all contract funds to `(_to)`
211 	 * @dev Only the market admin can access this function
212 	 * @param _to Address to withdraw the funds to
213 	 */
214 	function adminWithdraw(address _to) public onlyAdmin validAddress(_to) 
215 	{
216 		_to.transfer(address(this).balance);
217 	}
218 
219 	/**
220 	 * @notice Close and destroy the market
221 	 * @dev Only the market admin can access this function
222 	 * @param _to Address to withdraw the funds to
223 	 */
224 	function adminClose(address _to) public onlyAdmin validAddress(_to) 
225 	{
226 		require(forSalePixelconIndexes.length == uint256(0), "Cannot close with active listings");
227 		selfdestruct(_to);
228 	}
229 
230 
231 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
232 	//////////////////////////////////////////////////////////// Market Core ////////////////////////////////////////////////////////////////////
233 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
234 
235 	/**
236 	 * @notice Get all market parameters
237 	 * @return All market parameters
238 	 */
239 	function getMarketDetails() public view returns(uint32, uint32, uint32, uint32, uint64, uint64, uint256, uint256) 
240 	{
241 		return (devFee, priceUpdateInterval, startDateRoundValue, durationRoundValue, maxDuration, minDuration, maxPrice, minPrice);
242 	}
243 
244 	////////////////// Listings //////////////////
245 
246 	/**
247 	 * @notice Create market listing
248 	 * @dev This is an internal function called by the ERC721 receiver function during the safe transfer of a PixelCon
249 	 * @param _seller Address of the seller
250 	 * @param _tokenId TokenId of the PixelCon
251 	 * @param _startPrice Start price of the listing (wei)
252 	 * @param _endPrice End price of the listing (wei)
253 	 * @param _duration Duration of the listing (seconds)
254 	 */
255 	function makeListing(address _seller, uint256 _tokenId, uint256 _startPrice, uint256 _endPrice, uint256 _duration) internal 
256 	{
257 		require(_startPrice <= maxPrice, "Start price is higher than the max allowed");
258 		require(_startPrice >= minPrice, "Start price is lower than the min allowed");
259 		require(_endPrice <= maxPrice, "End price is higher than the max allowed");
260 		require(_endPrice >= minPrice, "End price is lower than the min allowed");
261 
262 		//convert price units from Wei to Gwei
263 		_startPrice = _startPrice / WEI_PER_GWEI;
264 		_endPrice = _endPrice / WEI_PER_GWEI;
265 		require(_endPrice > uint256(0), "End price cannot be zero (gwei)");
266 		require(_startPrice >= _endPrice, "Start price is lower than the end price");
267 		require(_startPrice < uint256(2 ** 64), "Start price is out of bounds");
268 		require(_endPrice < uint256(2 ** 64), "End price is out of bounds");
269 
270 		//calculate the start date
271 		uint256 startDate = (now / uint256(startDateRoundValue)) * uint256(startDateRoundValue);
272 		require(startDate < uint256(2 ** 64), "Start date is out of bounds");
273 
274 		//round the duration value
275 		_duration = (_duration / uint256(durationRoundValue)) * uint256(durationRoundValue);
276 		require(_duration > uint256(0), "Duration cannot be zero");
277 		require(_duration <= uint256(maxDuration), "Duration is higher than the max allowed");
278 		require(_duration >= uint256(minDuration), "Duration is lower than the min allowed");
279 
280 		//get pixelcon index
281 		uint64 pixelconIndex = pixelconsContract.getTokenIndex(_tokenId);
282 
283 		//create the listing object
284 		Listing storage listing = marketPixelconListings[pixelconIndex];
285 		listing.startAmount = uint64(_startPrice);
286 		listing.endAmount = uint64(_endPrice);
287 		listing.startDate = uint64(startDate);
288 		listing.duration = uint64(_duration);
289 		listing.seller = _seller;
290 
291 		//store references
292 		uint64[] storage sellerTokens = sellerPixelconIndexes[_seller];
293 		uint sellerTokensIndex = sellerTokens.length;
294 		uint forSaleIndex = forSalePixelconIndexes.length;
295 		require(sellerTokensIndex < uint256(2 ** 32 - 1), "Max number of market listings has been exceeded for seller");
296 		require(forSaleIndex < uint256(2 ** 64 - 1), "Max number of market listings has been exceeded");
297 		listing.sellerIndex = uint32(sellerTokensIndex);
298 		listing.forSaleIndex = uint64(forSaleIndex);
299 		sellerTokens.length++;
300 		sellerTokens[sellerTokensIndex] = pixelconIndex;
301 		forSalePixelconIndexes.length++;
302 		forSalePixelconIndexes[forSaleIndex] = pixelconIndex;
303 		emit Create(pixelconIndex, _seller, _startPrice, _endPrice, uint64(_duration));
304 	}
305 
306 	/**
307 	 * @notice Check if a market listing exists for PixelCon #`(_pixelconIndex)`
308 	 * @param _pixelconIndex Index of the PixelCon to check
309 	 * @return True if market listing exists
310 	 */
311 	function exists(uint64 _pixelconIndex) public view returns(bool) 
312 	{
313 		return (marketPixelconListings[_pixelconIndex].seller != address(0));
314 	}
315 
316 	/**
317 	 * @notice Get the current total number of market listings
318 	 * @return Number of current market listings
319 	 */
320 	function totalListings() public view returns(uint256) 
321 	{
322 		return forSalePixelconIndexes.length;
323 	}
324 
325 	/**
326 	 * @notice Get the details of the market listings for PixelCon #`(_pixelconIndex)`
327 	 * @dev Throws if market listing does not exist
328 	 * @param _pixelconIndex Index of the PixelCon to get details for
329 	 * @return All market listing data
330 	 */
331 	function getListing(uint64 _pixelconIndex) public view returns(address _seller, uint256 _startPrice, uint256 _endPrice, uint256 _currPrice,
332 		uint64 _startDate, uint64 _duration, uint64 _timeLeft) 
333 	{
334 		Listing storage listing = marketPixelconListings[_pixelconIndex];
335 		require(listing.seller != address(0), "Market listing does not exist");
336 
337 		//return all data
338 		_seller = listing.seller;
339 		_startPrice = uint256(listing.startAmount) * WEI_PER_GWEI;
340 		_endPrice = uint256(listing.endAmount) * WEI_PER_GWEI;
341 		_currPrice = calcCurrentPrice(uint256(listing.startAmount), uint256(listing.endAmount), uint256(listing.startDate), uint256(listing.duration));
342 		_startDate = listing.startDate;
343 		_duration = listing.duration;
344 		_timeLeft = calcTimeLeft(uint256(listing.startDate), uint256(listing.duration));
345 	}
346 
347 	/**
348 	 * @notice Remove the PixelCon #`(_pixelconIndex)` listing from the market
349 	 * @dev Throws if market listing does not exist or if the sender is not the seller/admin
350 	 * @param _pixelconIndex Index of the PixelCon to remove listing for
351 	 */
352 	function removeListing(uint64 _pixelconIndex) public 
353 	{
354 		Listing storage listing = marketPixelconListings[_pixelconIndex];
355 		require(listing.seller != address(0), "Market listing does not exist");
356 		require(msg.sender == listing.seller || msg.sender == admin, "Insufficient permissions");
357 
358 		//get data
359 		uint256 tokenId = pixelconsContract.tokenByIndex(_pixelconIndex);
360 		address seller = listing.seller;
361 
362 		//clear the listing from storage
363 		clearListingData(seller, _pixelconIndex);
364 
365 		//transfer pixelcon back to seller
366 		pixelconsContract.transferFrom(address(this), seller, tokenId);
367 		emit Remove(_pixelconIndex, msg.sender);
368 	}
369 
370 	/**
371 	 * @notice Purchase PixelCon #`(_pixelconIndex)` to address `(_to)`
372 	 * @dev Throws if market listing does not exist or if the market is locked
373 	 * @param _to Address to send the PixelCon to
374 	 * @param _pixelconIndex Index of the PixelCon to purchase
375 	 */
376 	function purchase(address _to, uint64 _pixelconIndex) public payable validAddress(_to) 
377 	{
378 		Listing storage listing = marketPixelconListings[_pixelconIndex];
379 		require(systemLock != LOCK_REMOVE_ONLY, "Market is currently locked");
380 		require(listing.seller != address(0), "Market listing does not exist");
381 		require(listing.seller != msg.sender, "Seller cannot purchase their own listing");
382 
383 		//calculate current price based on the time
384 		uint256 currPrice = calcCurrentPrice(uint256(listing.startAmount), uint256(listing.endAmount), uint256(listing.startDate), uint256(listing.duration));
385 		require(currPrice != uint256(0), "Market listing has expired");
386 		require(msg.value >= currPrice + (currPrice * uint256(devFee)) / FEE_RATIO, "Insufficient value sent");
387 
388 		//get data
389 		uint256 tokenId = pixelconsContract.tokenByIndex(_pixelconIndex);
390 		address seller = listing.seller;
391 
392 		//clear the listing from storage
393 		clearListingData(seller, _pixelconIndex);
394 
395 		//transfer pixelcon to buyer and value to seller
396 		pixelconsContract.transferFrom(address(this), _to, tokenId);
397 		seller.transfer(currPrice);
398 		emit Purchase(_pixelconIndex, msg.sender, currPrice);
399 	}
400 
401 	////////////////// Web3 Only //////////////////
402 
403 	/**
404 	 * @notice Get market listing data for the given indexes
405 	 * @dev This function is for web3 calls only, as it returns a dynamic array
406 	 * @param _indexes PixelCon indexes to get market listing details for
407 	 * @return Market listing data for the given indexes
408 	 */
409 	function getBasicData(uint64[] _indexes) public view returns(uint64[], address[], uint256[], uint64[]) 
410 	{
411 		uint64[] memory tokenIndexes = new uint64[](_indexes.length);
412 		address[] memory sellers = new address[](_indexes.length);
413 		uint256[] memory currPrices = new uint256[](_indexes.length);
414 		uint64[] memory timeLeft = new uint64[](_indexes.length);
415 
416 		for (uint i = 0; i < _indexes.length; i++) {
417 			Listing storage listing = marketPixelconListings[_indexes[i]];
418 			if (listing.seller != address(0)) {
419 				//listing exists
420 				tokenIndexes[i] = _indexes[i];
421 				sellers[i] = listing.seller;
422 				currPrices[i] = calcCurrentPrice(uint256(listing.startAmount), uint256(listing.endAmount), uint256(listing.startDate), uint256(listing.duration));
423 				timeLeft[i] = calcTimeLeft(uint256(listing.startDate), uint256(listing.duration));
424 			} else {
425 				//listing does not exist
426 				tokenIndexes[i] = 0;
427 				sellers[i] = 0;
428 				currPrices[i] = 0;
429 				timeLeft[i] = 0;
430 			}
431 		}
432 		return (tokenIndexes, sellers, currPrices, timeLeft);
433 	}
434 
435 	/**
436 	 * @notice Get all PixelCon indexes being sold by `(_seller)`
437 	 * @dev This function is for web3 calls only, as it returns a dynamic array
438 	 * @param _seller Address of seller to get selling PixelCon indexes for
439 	 * @return All PixelCon indexes being sold by the given seller
440 	 */
441 	function getForSeller(address _seller) public view validAddress(_seller) returns(uint64[]) 
442 	{
443 		return sellerPixelconIndexes[_seller];
444 	}
445 
446 	/**
447 	 * @notice Get all PixelCon indexes being sold on the market
448 	 * @dev This function is for web3 calls only, as it returns a dynamic array
449 	 * @return All PixelCon indexes being sold on the market
450 	 */
451 	function getAllListings() public view returns(uint64[]) 
452 	{
453 		return forSalePixelconIndexes;
454 	}
455 
456 	/**
457 	 * @notice Get the PixelCon indexes being sold from listing index `(_startIndex)` to `(_endIndex)`
458 	 * @dev This function is for web3 calls only, as it returns a dynamic array
459 	 * @return The PixelCon indexes being sold in the given range
460 	 */
461 	function getListingsInRange(uint64 _startIndex, uint64 _endIndex) public view returns(uint64[])
462 	{
463 		require(_startIndex <= totalListings(), "Start index is out of bounds");
464 		require(_endIndex <= totalListings(), "End index is out of bounds");
465 		require(_startIndex <= _endIndex, "End index is less than the start index");
466 
467 		uint64 length = _endIndex - _startIndex;
468 		uint64[] memory indexes = new uint64[](length);
469 		for (uint i = 0; i < length; i++)	{
470 			indexes[i] = forSalePixelconIndexes[_startIndex + i];
471 		}
472 		return indexes;
473 	}
474 
475 
476 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
477 	////////////////////////////////////////////////// ERC-721 Receiver Implementation //////////////////////////////////////////////////////////
478 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
479 
480 	/**
481 	 * @notice Handle ERC721 token transfers
482 	 * @dev This function only accepts tokens from the PixelCons contracts and expects parameter data stuffed into the bytes
483 	 * @param _operator Address of who is doing the transfer
484 	 * @param _from Address of the last owner
485 	 * @param _tokenId Id of the token being received
486 	 * @param _data Miscellaneous data related to the transfer
487 	 * @return The ERC721 safe transfer receive confirmation
488 	 */
489 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4) 
490 	{
491 		//only receive tokens from the PixelCons contract
492 		require(systemLock == LOCK_NONE, "Market is currently locked");
493 		require(msg.sender == address(pixelconsContract), "Market only accepts transfers from the PixelCons contract");
494 		require(_tokenId != uint256(0), "Invalid token ID");
495 		require(_operator != address(0), "Invalid operator address");
496 		require(_from != address(0), "Invalid from address");
497 
498 		//extract parameters from byte array
499 		require(_data.length == 32 * 3, "Incorrectly formatted data");
500 		uint256 startPrice;
501 		uint256 endPrice;
502 		uint256 duration;
503 		assembly {
504 			startPrice := mload(add(_data, 0x20))
505 			endPrice := mload(add(_data, 0x40))
506 			duration := mload(add(_data, 0x60))
507 		}
508 
509 		//add listing for the received token
510 		makeListing(_from, _tokenId, startPrice, endPrice, duration);
511 
512 		//all good
513 		return ERC721_RECEIVED;
514 	}
515 
516 
517 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
518 	////////////////////////////////////////////////////////////// Utils ////////////////////////////////////////////////////////////////////////
519 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
520 
521 	/**
522 	 * @dev Clears the listing data for the given PixelCon index and seller address
523 	 * @param _seller Address of the seller to clear listing data for
524 	 * @param _pixelconIndex Index of the PixelCon to clear listing data for
525 	 */
526 	function clearListingData(address _seller, uint64 _pixelconIndex) internal 
527 	{
528 		Listing storage listing = marketPixelconListings[_pixelconIndex];
529 
530 		//clear sellerPixelconIndexes reference
531 		uint64[] storage sellerTokens = sellerPixelconIndexes[_seller];
532 		uint64 replacementSellerTokenIndex = sellerTokens[sellerTokens.length - 1];
533 		delete sellerTokens[sellerTokens.length - 1];
534 		sellerTokens.length--;
535 		if (listing.sellerIndex < sellerTokens.length) {
536 			//we just removed the last token index in the array, but if this wasn't the one to remove, then swap it with the one to remove 
537 			sellerTokens[listing.sellerIndex] = replacementSellerTokenIndex;
538 			marketPixelconListings[replacementSellerTokenIndex].sellerIndex = listing.sellerIndex;
539 		}
540 
541 		//clear forSalePixelconIndexes reference
542 		uint64 replacementForSaleTokenIndex = forSalePixelconIndexes[forSalePixelconIndexes.length - 1];
543 		delete forSalePixelconIndexes[forSalePixelconIndexes.length - 1];
544 		forSalePixelconIndexes.length--;
545 		if (listing.forSaleIndex < forSalePixelconIndexes.length) {
546 			//we just removed the last token index in the array, but if this wasn't the one to remove, then swap it with the one to remove 
547 			forSalePixelconIndexes[listing.forSaleIndex] = replacementForSaleTokenIndex;
548 			marketPixelconListings[replacementForSaleTokenIndex].forSaleIndex = listing.forSaleIndex;
549 		}
550 
551 		//clear the listing object 
552 		delete marketPixelconListings[_pixelconIndex];
553 	}
554 
555 	/**
556 	 * @dev Calculates the current price of a listing given all its details
557 	 * @param _startAmount Market listing start price amount (gwei)
558 	 * @param _endAmount Market listing end price amount (gwei)
559 	 * @param _startDate Market listing start date (seconds)
560 	 * @param _duration Market listing duration (seconds)
561 	 * @return The current listing price (wei)
562 	 */
563 	function calcCurrentPrice(uint256 _startAmount, uint256 _endAmount, uint256 _startDate, uint256 _duration) internal view returns(uint256) 
564 	{
565 		uint256 timeDelta = now - _startDate;
566 		if (timeDelta > _duration) return uint256(0);
567 
568 		timeDelta = timeDelta / uint256(priceUpdateInterval);
569 		uint256 durationTotal = _duration / uint256(priceUpdateInterval);
570 		return (_startAmount - ((_startAmount - _endAmount) * timeDelta) / durationTotal) * WEI_PER_GWEI;
571 	}
572 
573 	/**
574 	 * @dev Calculates the total time left for a listing given its details
575 	 * @param _startDate Market listing start date (seconds)
576 	 * @param _duration Market listing duration (seconds)
577 	 * @return Time left before market listing ends (seconds)
578 	 */
579 	function calcTimeLeft(uint256 _startDate, uint256 _duration) internal view returns(uint64) 
580 	{
581 		uint256 timeDelta = now - _startDate;
582 		if (timeDelta > _duration) return uint64(0);
583 
584 		return uint64(_duration - timeDelta);
585 	}
586 }
587 
588 
589 /**
590  * @title PixelCons (Sub-set interface)
591  * @notice ERC721 token contract
592  * @dev This is a subset of the PixelCon Core contract
593  * @author PixelCons
594  */
595 contract PixelCons {
596 
597 	/**
598 	 * @notice Transfer the ownership of PixelCon `(_tokenId)` to `(_to)`
599 	 * @dev Throws if the sender is not the owner, approved, or operator
600 	 * @param _from Current owner
601 	 * @param _to Address to receive the PixelCon
602 	 * @param _tokenId ID of the PixelCon to be transferred
603 	 */
604 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
605 	
606 	/**
607 	 * @notice Get the index of PixelCon `(_tokenId)`
608 	 * @dev Throws if PixelCon does not exist
609 	 * @param _tokenId ID of the PixelCon to query the index of
610 	 * @return Index of the given PixelCon ID
611 	 */
612 	function getTokenIndex(uint256 _tokenId) public view returns(uint64);
613 
614 	/**
615 	 * @notice Get the ID of PixelCon #`(_tokenIndex)`
616 	 * @dev Throws if index is out of bounds
617 	 * @param _tokenIndex Counter less than `totalSupply()`
618 	 * @return `_tokenIndex`th PixelCon ID
619 	 */
620 	function tokenByIndex(uint256 _tokenIndex) public view returns(uint256);
621 }