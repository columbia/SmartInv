1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 pragma solidity >=0.6.2 <0.8.0;
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(address from, address to, uint256 tokenId) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address from, address to, uint256 tokenId) external;
92 
93     /**
94      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
95      * The approval is cleared when the token is transferred.
96      *
97      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
98      *
99      * Requirements:
100      *
101      * - The caller must own the token or be an approved operator.
102      * - `tokenId` must exist.
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address to, uint256 tokenId) external;
107 
108     /**
109      * @dev Returns the account approved for `tokenId` token.
110      *
111      * Requirements:
112      *
113      * - `tokenId` must exist.
114      */
115     function getApproved(uint256 tokenId) external view returns (address operator);
116 
117     /**
118      * @dev Approve or remove `operator` as an operator for the caller.
119      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
120      *
121      * Requirements:
122      *
123      * - The `operator` cannot be the caller.
124      *
125      * Emits an {ApprovalForAll} event.
126      */
127     function setApprovalForAll(address operator, bool _approved) external;
128 
129     /**
130      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
131      *
132      * See {setApprovalForAll}
133      */
134     function isApprovedForAll(address owner, address operator) external view returns (bool);
135 
136     /**
137       * @dev Safely transfers `tokenId` token from `from` to `to`.
138       *
139       * Requirements:
140       *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143       * - `tokenId` token must exist and be owned by `from`.
144       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146       *
147       * Emits a {Transfer} event.
148       */
149     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
150 }
151 
152 pragma solidity >=0.6.0 <0.8.0;
153 
154 /**
155  * @dev Interface of the ERC20 standard as defined in the EIP.
156  */
157 interface IERC20 {
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `recipient`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender) external view returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `sender` to `recipient` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Emitted when `value` tokens are moved from one account (`from`) to
215      * another (`to`).
216      *
217      * Note that `value` may be zero.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /**
222      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
223      * a call to {approve}. `value` is the new allowance.
224      */
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 pragma solidity 0.7.4;
229 
230 interface IERC1155 {
231 
232   /****************************************|
233   |                 Events                 |
234   |_______________________________________*/
235 
236   /**
237    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
238    *   Operator MUST be msg.sender
239    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
240    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
241    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
242    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
243    */
244   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
245 
246   /**
247    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
248    *   Operator MUST be msg.sender
249    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
250    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
251    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
252    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
253    */
254   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
255 
256   /**
257    * @dev MUST emit when an approval is updated
258    */
259   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
260 
261 
262   /****************************************|
263   |                Functions               |
264   |_______________________________________*/
265 
266   /**
267     * @notice Transfers amount of an _id from the _from address to the _to address specified
268     * @dev MUST emit TransferSingle event on success
269     * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
270     * MUST throw if `_to` is the zero address
271     * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
272     * MUST throw on any other error
273     * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
274     * @param _from    Source address
275     * @param _to      Target address
276     * @param _id      ID of the token type
277     * @param _amount  Transfered amount
278     * @param _data    Additional data with no specified format, sent in call to `_to`
279     */
280   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
281 
282   /**
283     * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
284     * @dev MUST emit TransferBatch event on success
285     * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
286     * MUST throw if `_to` is the zero address
287     * MUST throw if length of `_ids` is not the same as length of `_amounts`
288     * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
289     * MUST throw on any other error
290     * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
291     * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
292     * @param _from     Source addresses
293     * @param _to       Target addresses
294     * @param _ids      IDs of each token type
295     * @param _amounts  Transfer amounts per token type
296     * @param _data     Additional data with no specified format, sent in call to `_to`
297   */
298   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
299 
300   /**
301    * @notice Get the balance of an account's Tokens
302    * @param _owner  The address of the token holder
303    * @param _id     ID of the Token
304    * @return        The _owner's balance of the Token type requested
305    */
306   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
307 
308   /**
309    * @notice Get the balance of multiple account/token pairs
310    * @param _owners The addresses of the token holders
311    * @param _ids    ID of the Tokens
312    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
313    */
314   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
315 
316   /**
317    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
318    * @dev MUST emit the ApprovalForAll event on success
319    * @param _operator  Address to add to the set of authorized operators
320    * @param _approved  True if the operator is approved, false to revoke approval
321    */
322   function setApprovalForAll(address _operator, bool _approved) external;
323 
324   /**
325    * @notice Queries the approval status of an operator for a given owner
326    * @param _owner     The owner of the Tokens
327    * @param _operator  Address of authorized operator
328    * @return isOperator True if the operator is approved, false if not
329    */
330   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
331 }
332 
333 pragma solidity 0.7.4;
334 
335 contract PortionExchangeV2 {
336 	struct ERC1155Offer {
337 		uint tokenId;
338 		uint quantity;
339 		uint price;
340 		address seller;
341 	}
342 
343 	event TokenPriceListed (uint indexed _tokenId, address indexed _owner, uint _price);
344 	event TokenPriceDeleted (uint indexed _tokenId);
345 	event TokenSold (uint indexed _tokenId, uint _price, bool _soldForPRT);
346 	event TokenOwned (uint indexed _tokenId, address indexed _previousOwner, address indexed _newOwner);
347 	event Token1155OfferListed (uint indexed _tokenId, uint indexed _offerId, address indexed _owner, uint _quantity, uint _price);
348 	event Token1155OfferDeleted (uint indexed _tokenId, uint indexed _offerId);
349 	event Token1155Sold(uint indexed _tokenId, uint indexed _offerId, uint _quantity, uint _price, bool _soldForPRT);
350 	event Token1155Owned (uint indexed _tokenId, address indexed _previousOwner, address indexed _newOwner, uint _quantity);
351 
352 	address public signerAddress;
353 	address owner;
354 
355 	bytes32 public name = "PortionExchangeV2";
356 
357 	uint public offerIdCounter;
358 	uint public safeVolatilityPeriod;
359 
360 	IERC20 public portionTokenContract;
361 	IERC721 public artTokenContract;
362 	IERC1155 public artToken1155Contract;
363 
364 	mapping(address => uint) public nonces;
365 	mapping(uint => uint) public ERC721Prices;
366 	mapping(uint => ERC1155Offer) public ERC1155Offers;
367 	mapping(address => mapping(uint => uint)) public tokensListed;
368 
369 	constructor (
370 		address _signerAddress,
371 		address _artTokenAddress,
372 		address _artToken1155Address,
373 		address _portionTokenAddress
374 	)
375 	{
376 		require (_signerAddress != address(0));
377 		require (_artTokenAddress != address(0));
378 		require (_artToken1155Address != address(0));
379 		require (_portionTokenAddress != address(0));
380 
381 		owner = msg.sender;
382 		signerAddress = _signerAddress;
383 		artTokenContract = IERC721(_artTokenAddress);
384 		artToken1155Contract = IERC1155(_artToken1155Address);
385 		portionTokenContract = IERC20(_portionTokenAddress);
386 
387 		safeVolatilityPeriod = 4 hours;
388 	}
389 
390 	function listToken(
391 		uint _tokenId,
392 		uint _price
393 	)
394 	external
395 	{
396 		require(_price > 0);
397 		require(artTokenContract.ownerOf(_tokenId) == msg.sender);
398 		require(ERC721Prices[_tokenId] == 0);
399 		ERC721Prices[_tokenId] = _price;
400 		emit TokenPriceListed(_tokenId, msg.sender, _price);
401 	}
402 
403 	function listToken1155(
404 		uint _tokenId,
405 		uint _quantity,
406 		uint _price
407 	)
408 	external
409 	{
410 		require(_price > 0);
411 		require(artToken1155Contract.balanceOf(msg.sender, _tokenId) >= tokensListed[msg.sender][_tokenId] + _quantity);
412 
413 		uint offerId = offerIdCounter++;
414 		ERC1155Offers[offerId] = ERC1155Offer({
415 			tokenId: _tokenId,
416 			quantity: _quantity,
417 			price: _price,
418 			seller: msg.sender
419 		});
420 
421 		tokensListed[msg.sender][_tokenId] += _quantity;
422 		emit Token1155OfferListed(_tokenId, offerId, msg.sender, _quantity, _price);
423 	}
424 
425 	function removeListToken(
426 		uint _tokenId
427 	)
428 	external
429 	{
430 		require(artTokenContract.ownerOf(_tokenId) == msg.sender);
431 		deleteTokenPrice(_tokenId);
432 	}
433 
434 	function removeListToken1155(
435 		uint _offerId
436 	)
437 	external
438 	{
439 		require(ERC1155Offers[_offerId].seller == msg.sender);
440 		deleteToken1155Offer(_offerId);
441 	}
442 
443 	function deleteTokenPrice(
444 		uint _tokenId
445 	)
446 	internal
447 	{
448 		delete ERC721Prices[_tokenId];
449 		emit TokenPriceDeleted(_tokenId);
450 	}
451 
452 	function deleteToken1155Offer(
453 		uint _offerId
454 	)
455 	internal
456 	{
457 		ERC1155Offer memory offer = ERC1155Offers[_offerId];
458 		tokensListed[offer.seller][offer.tokenId] -= offer.quantity;
459 
460 		delete ERC1155Offers[_offerId];
461 		emit Token1155OfferDeleted(offer.tokenId, _offerId);
462 	}
463 
464 	function buyToken(
465 		uint _tokenId
466 	)
467 	external
468 	payable
469 	{
470 		require(ERC721Prices[_tokenId] > 0, "token is not for sale");
471 		require(ERC721Prices[_tokenId] <= msg.value);
472 
473 		address tokenOwner = artTokenContract.ownerOf(_tokenId);
474 
475 		address payable payableTokenOwner = payable(tokenOwner);
476 		(bool sent, ) = payableTokenOwner.call{value: msg.value}("");
477 		require(sent);
478 
479 		artTokenContract.safeTransferFrom(tokenOwner, msg.sender, _tokenId);
480 
481 		emit TokenSold(_tokenId, msg.value, false);
482 		emit TokenOwned(_tokenId, tokenOwner, msg.sender);
483 
484 		deleteTokenPrice(_tokenId);
485 	}
486 
487 	function buyToken1155(
488 		uint _offerId,
489 		uint _quantity
490 	)
491 	external
492 	payable
493 	{
494 		ERC1155Offer memory offer = ERC1155Offers[_offerId];
495 
496 		require(offer.price > 0, "offer does not exist");
497 		require(offer.quantity >= _quantity);
498 		require(offer.price * _quantity <= msg.value);
499 
500 		address payable payableSeller = payable(offer.seller);
501 		(bool sent, ) = payableSeller.call{value: msg.value}("");
502 		require(sent);
503 
504 		artToken1155Contract.safeTransferFrom(offer.seller, msg.sender, offer.tokenId, _quantity, "");
505 
506 		emit Token1155Sold(offer.tokenId, _offerId, _quantity, offer.price, false);
507 		emit Token1155Owned(offer.tokenId, offer.seller, msg.sender, _quantity);
508 
509 		if (offer.quantity == _quantity) {
510 			deleteToken1155Offer(_offerId);
511 		} else {
512 			ERC1155Offers[_offerId].quantity -= _quantity;
513 		}
514 	}
515 
516 	function buyTokenForPRT(
517 		uint _tokenId,
518 		uint _priceInPRT,
519 		uint _nonce,
520 		bytes calldata _signature,
521 		uint _timestamp
522 	)
523 	external
524 	{
525 		bytes32 hash = keccak256(abi.encodePacked(_tokenId, _priceInPRT, _nonce, _timestamp));
526 		bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
527 		require(recoverSignerAddress(ethSignedMessageHash, _signature) == signerAddress, "invalid secret signer");
528 
529 		require(nonces[msg.sender] < _nonce, "invalid nonce");
530 		if (safeVolatilityPeriod > 0) {
531 			require(_timestamp + safeVolatilityPeriod >= block.timestamp, "safe volatility period exceeded");
532 		}
533 		require(ERC721Prices[_tokenId] > 0, "token is not for sale");
534 
535 		nonces[msg.sender] = _nonce;
536 
537 		address tokenOwner = artTokenContract.ownerOf(_tokenId);
538 
539 		bool sent = portionTokenContract.transferFrom(msg.sender, tokenOwner, _priceInPRT);
540 		require(sent);
541 
542 		artTokenContract.safeTransferFrom(tokenOwner, msg.sender, _tokenId);
543 
544 		emit TokenSold(_tokenId, _priceInPRT, true);
545 		emit TokenOwned(_tokenId, tokenOwner, msg.sender);
546 
547 		deleteTokenPrice(_tokenId);
548 	}
549 
550 	function buyToken1155ForPRT(
551 		uint _offerId,
552 		uint _quantity,
553 		uint _priceInPRT,
554 		uint _nonce,
555 		bytes calldata _signature,
556 		uint _timestamp
557 	)
558 	external
559 	{
560 		bytes32 hash = keccak256(abi.encodePacked(_offerId, _quantity, _priceInPRT, _nonce, _timestamp));
561 		bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
562 		require(recoverSignerAddress(ethSignedMessageHash, _signature) == signerAddress, "invalid secret signer");
563 
564 		ERC1155Offer memory offer = ERC1155Offers[_offerId];
565 
566 		require(nonces[msg.sender] < _nonce, "invalid nonce");
567 		if (safeVolatilityPeriod > 0) {
568 			require(_timestamp + safeVolatilityPeriod >= block.timestamp, "safe volatility period exceeded");
569 		}
570 		require(offer.price > 0, "offer does not exist");
571 		require(offer.quantity >= _quantity);
572 
573 		nonces[msg.sender] = _nonce;
574 
575 		portionTokenContract.transferFrom(msg.sender, offer.seller, _priceInPRT * _quantity);
576 		artToken1155Contract.safeTransferFrom(offer.seller, msg.sender, offer.tokenId, _quantity, "");
577 
578 		emit Token1155Sold(offer.tokenId, _offerId, _quantity, _priceInPRT, true);
579 		emit Token1155Owned(offer.tokenId, offer.seller, msg.sender, _quantity);
580 
581 		if (offer.quantity == _quantity) {
582 			deleteToken1155Offer(_offerId);
583 		} else {
584 			ERC1155Offers[_offerId].quantity -= _quantity;
585 		}
586 	}
587 
588 	function setSigner(
589 		address _newSignerAddress
590 	)
591 	external
592 	{
593 		require(msg.sender == owner);
594 		signerAddress = _newSignerAddress;
595 	}
596 
597 	function setSafeVolatilityPeriod(
598 		uint _newSafeVolatilityPeriod
599 	)
600 	external
601 	{
602 		require(msg.sender == owner);
603 		safeVolatilityPeriod = _newSafeVolatilityPeriod;
604 	}
605 
606 	function recoverSignerAddress(
607 		bytes32 _hash,
608 		bytes memory _signature
609 	)
610 	internal
611 	pure
612 	returns (address)
613 	{
614 		require(_signature.length == 65, "invalid signature length");
615 
616 		bytes32 r;
617 		bytes32 s;
618 		uint8 v;
619 
620 		assembly {
621 			r := mload(add(_signature, 32))
622 			s := mload(add(_signature, 64))
623 			v := and(mload(add(_signature, 65)), 255)
624 		}
625 
626 		if (v < 27) {
627 			v += 27;
628 		}
629 
630 		if (v != 27 && v != 28) {
631 			return address(0);
632 		}
633 
634 		return ecrecover(_hash, v, r, s);
635 	}
636 }