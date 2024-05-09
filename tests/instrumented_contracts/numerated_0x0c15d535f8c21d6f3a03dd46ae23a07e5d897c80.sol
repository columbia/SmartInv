1 pragma solidity ^0.4.25;
2 
3 	/* 
4 		************
5 		- dAppCaps -
6 		************
7 		v1.77
8 		
9 		Daniel Pittman - Qwoyn.io
10 		
11 		*Note:
12 		*
13 		*Compatible with OpenSea
14 		************************
15 	*/
16 
17 	/**
18 	 * @title SafeMath
19 	 * @dev Math operations with safety checks that throw on error
20 	 */
21 	library SafeMath {
22 
23 	  /**
24 	  * @dev Multiplies two numbers, throws on overflow.
25 	  */
26 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28 		// benefit is lost if 'b' is also tested.
29 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30 		if (a == 0) {
31 		  return 0;
32 		}
33 
34 		c = a * b;
35 		assert(c / a == b);
36 		return c;
37 	  }
38 
39 	  /**
40 	  * @dev Integer division of two numbers, truncating the quotient.
41 	  */
42 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
43 		// assert(b > 0); // Solidity automatically throws when dividing by 0
44 		// uint256 c = a / b;
45 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 		return a / b;
47 	  }
48 
49 	  /**
50 	  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51 	  */
52 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53 		assert(b <= a);
54 		return a - b;
55 	  }
56 
57 	  /**
58 	  * @dev Adds two numbers, throws on overflow.
59 	  */
60 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61 		c = a + b;
62 		assert(c >= a);
63 		return c;
64 	  }
65 	}
66 	
67 	/**
68 	* @title Helps contracts guard against reentrancy attacks.
69 	* @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
70 	* @dev If you mark a function `nonReentrant`, you should also
71 	* mark it `external`.
72 	*/
73 	contract ReentrancyGuard {
74 
75 	/// @dev counter to allow mutex lock with only one SSTORE operation
76 	uint256 private guardCounter = 1;
77 
78 	/**
79 	* @dev Prevents a contract from calling itself, directly or indirectly.
80 	* If you mark a function `nonReentrant`, you should also
81 	* mark it `external`. Calling one `nonReentrant` function from
82 	* another is not supported. Instead, you can implement a
83 	* `private` function doing the actual work, and an `external`
84 	* wrapper marked as `nonReentrant`.
85 	*/
86 		modifier nonReentrant() {
87 			guardCounter += 1;
88 			uint256 localCounter = guardCounter;
89 			_;
90 			require(localCounter == guardCounter);
91 		}
92 	}
93 	
94 	/**
95 	 * @title ERC165
96 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
97 	 */
98 	interface ERC165 {
99 
100 	  /**
101 	   * @notice Query if a contract implements an interface
102 	   * @param _interfaceId The interface identifier, as specified in ERC-165
103 	   * @dev Interface identification is specified in ERC-165. This function
104 	   * uses less than 30,000 gas.
105 	   */
106 	  function supportsInterface(bytes4 _interfaceId)
107 		external
108 		view
109 		returns (bool);
110 	}
111 
112 	/**
113 	 * @title ERC721 token receiver interface
114 	 * @dev Interface for any contract that wants to support safeTransfers
115 	 * from ERC721 asset contracts.
116 	 */
117 	contract ERC721Receiver {
118 	  /**
119 	   * @dev Magic value to be returned upon successful reception of an NFT
120 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
121 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
122 	   */
123 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
124 
125 	  /**
126 	   * @notice Handle the receipt of an NFT
127 	   * @dev The ERC721 smart contract calls this function on the recipient
128 	   * after a `safetransfer`. This function MAY throw to revert and reject the
129 	   * transfer. Return of other than the magic value MUST result in the 
130 	   * transaction being reverted.
131 	   * Note: the contract address is always the message sender.
132 	   * @param _operator The address which called `safeTransferFrom` function
133 	   * @param _from The address which previously owned the token
134 	   * @param _tokenId The NFT identifier which is being transfered
135 	   * @param _data Additional data with no specified format
136 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
137 	   */
138 	  function onERC721Received(
139 		address _operator,
140 		address _from,
141 		uint256 _tokenId,
142 		bytes _data
143 	  )
144 		public
145 		returns(bytes4);
146 	}
147 
148 	/**
149 	 * Utility library of inline functions on addresses
150 	 */
151 	library AddressUtils {
152 
153 	  /**
154 	   * Returns whether the target address is a contract
155 	   * @dev This function will return false if invoked during the constructor of a contract,
156 	   * as the code is not actually created until after the constructor finishes.
157 	   * @param addr address to check
158 	   * @return whether the target address is a contract
159 	   */
160 	  function isContract(address addr) internal view returns (bool) {
161 		uint256 size;
162 		// XXX Currently there is no better way to check if there is a contract in an address
163 		// than to check the size of the code at that address.
164 		// See https://ethereum.stackexchange.com/a/14016/36603
165 		// for more details about how this works.
166 		// TODO Check this again before the Serenity release, because all addresses will be
167 		// contracts then.
168 		// solium-disable-next-line security/no-inline-assembly
169 		assembly { size := extcodesize(addr) }
170 		return size > 0;
171 	  }
172 
173 	}
174 
175 	/**
176 	 * @title Ownable
177 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
178 	 * functions, this simplifies the implementation of "user permissions". 
179 	 */
180 	contract Ownable {
181 	  address public owner;
182 
183 
184 	  event OwnershipRenounced(address indexed previousOwner);
185 	  event OwnershipTransferred(
186 		address indexed previousOwner,
187 		address indexed newOwner
188 	  );
189 
190 
191 	  /**
192 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193 	   * account.
194 	   */
195 	  constructor() public {
196 		owner = msg.sender;
197 	  }
198 
199 	  /**
200 	   * @dev Throws if called by any account other than the owner.
201 	   */
202 	  modifier onlyOwner() {
203 		require(msg.sender == owner);
204 		_;
205 	  }
206 
207 	  /**
208 	   * @dev Allows the current owner to relinquish control of the contract.
209 	   * @notice Renouncing to ownership will leave the contract without an owner.
210 	   * It will not be possible to call the functions with the `onlyOwner`
211 	   * modifier anymore.
212 	   */
213 	  function renounceOwnership() public onlyOwner {
214 		emit OwnershipRenounced(owner);
215 		owner = address(0);
216 	  }
217 
218 	  /**
219 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
220 	   * @param _newOwner The address to transfer ownership to.
221 	   */
222 	  function transferOwnership(address _newOwner) public onlyOwner {
223 		_transferOwnership(_newOwner);
224 	  }
225 
226 	  /**
227 	   * @dev Transfers control of the contract to a newOwner.
228 	   * @param _newOwner The address to transfer ownership to.
229 	   */
230 	  function _transferOwnership(address _newOwner) internal onlyOwner {
231 		require(_newOwner != address(0));
232 		emit OwnershipTransferred(owner, _newOwner);
233 		owner = _newOwner;
234 	  }
235 	}
236 	
237 	contract Fallback is Ownable {
238 
239 	  function withdraw() public onlyOwner {
240         owner.transfer(address(this).balance);
241       }
242 	}
243 	
244 	/**
245 	 * @title SupportsInterfaceWithLookup
246 	 * @author Matt Condon (@shrugs)
247 	 * @dev Implements ERC165 using a lookup table.
248 	 */
249 	contract SupportsInterfaceWithLookup is ERC165 {
250 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
251 	  /**
252 	   * 0x01ffc9a7 ===
253 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
254 	   */
255 
256 	  /**
257 	   * @dev a mapping of interface id to whether or not it's supported
258 	   */
259 	  mapping(bytes4 => bool) internal supportedInterfaces;
260 
261 	  /**
262 	   * @dev A contract implementing SupportsInterfaceWithLookup
263 	   * implement ERC165 itself
264 	   */
265 	  constructor()
266 		public
267 	  {
268 		_registerInterface(InterfaceId_ERC165);
269 	  }
270 
271 	  /**
272 	   * @dev implement supportsInterface(bytes4) using a lookup table
273 	   */
274 	  function supportsInterface(bytes4 _interfaceId)
275 		external
276 		view
277 		returns (bool)
278 	  {
279 		return supportedInterfaces[_interfaceId];
280 	  }
281 
282 	  /**
283 	   * @dev private method for registering an interface
284 	   */
285 	  function _registerInterface(bytes4 _interfaceId)
286 		internal
287 	  {
288 		require(_interfaceId != 0xffffffff);
289 		supportedInterfaces[_interfaceId] = true;
290 	  }
291 	}
292 
293 	/**
294 	 * @title ERC721 Non-Fungible Token Standard basic interface
295 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
296 	 */
297 	contract ERC721Basic is ERC165 {
298 	  event Transfer(
299 		address indexed _from,
300 		address indexed _to,
301 		uint256 indexed _tokenId
302 	  );
303 	  event Approval(
304 		address indexed _owner,
305 		address indexed _approved,
306 		uint256 indexed _tokenId
307 	  );
308 	  event ApprovalForAll(
309 		address indexed _owner,
310 		address indexed _operator,
311 		bool _approved
312 	  );
313 
314 	  function balanceOf(address _owner) public view returns (uint256 _balance);
315 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
316 	  function exists(uint256 _tokenId) public view returns (bool _exists);
317 
318 	  function approve(address _to, uint256 _tokenId) public;
319 	  function getApproved(uint256 _tokenId)
320 		public view returns (address _operator);
321 
322 	  function setApprovalForAll(address _operator, bool _approved) public;
323 	  function isApprovedForAll(address _owner, address _operator)
324 		public view returns (bool);
325 
326 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
327 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
328 		public;
329 
330 	  function safeTransferFrom(
331 		address _from,
332 		address _to,
333 		uint256 _tokenId,
334 		bytes _data
335 	  )
336 		public;
337 	}
338 
339 	/**
340 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
341 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
342 	 */
343 	contract ERC721Enumerable is ERC721Basic {
344 	  function totalSupply() public view returns (uint256);
345 	  function tokenOfOwnerByIndex(
346 		address _owner,
347 		uint256 _index
348 	  )
349 		public
350 		view
351 		returns (uint256 _tokenId);
352 
353 	  function tokenByIndex(uint256 _index) public view returns (uint256);
354 	}
355 
356 
357 	/**
358 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
359 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
360 	 */
361 	contract ERC721Metadata is ERC721Basic {
362 	  function name() external view returns (string _name);
363 	  function symbol() external view returns (string _symbol);
364 	  function tokenURI(uint256 _tokenId) public view returns (string);
365 	}
366 
367 
368 	/**
369 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
370 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
371 	 */
372 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
373 	}
374 
375 	/**
376 	 * @title ERC721 Non-Fungible Token Standard basic implementation
377 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
378 	 */
379 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
380 
381 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
382 	  /*
383 	   * 0x80ac58cd ===
384 	   *   bytes4(keccak256('balanceOf(address)')) ^
385 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
386 	   *   bytes4(keccak256('approve(address,uint256)')) ^
387 	   *   bytes4(keccak256('getApproved(uint256)')) ^
388 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
389 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
390 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
391 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
392 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
393 	   */
394 
395 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
396 	  /*
397 	   * 0x4f558e79 ===
398 	   *   bytes4(keccak256('exists(uint256)'))
399 	   */
400 
401 	  using SafeMath for uint256;
402 	  using AddressUtils for address;
403 
404 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
405 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
406 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
407 
408 	  // Mapping from token ID to owner
409 	  mapping (uint256 => address) internal tokenOwner;
410 
411 	  // Mapping from token ID to approved address
412 	  mapping (uint256 => address) internal tokenApprovals;
413 
414 	  // Mapping from owner to number of owned token
415 	  mapping (address => uint256) internal ownedTokensCount;
416 
417 	  // Mapping from owner to operator approvals
418 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
419 
420 	  /**
421 	   * @dev Guarantees msg.sender is owner of the given token
422 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
423 	   */
424 	  modifier onlyOwnerOf(uint256 _tokenId) {
425 		require(ownerOf(_tokenId) == msg.sender);
426 		_;
427 	  }
428 
429 	  /**
430 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
431 	   * @param _tokenId uint256 ID of the token to validate
432 	   */
433 	  modifier canTransfer(uint256 _tokenId) {
434 		require(isApprovedOrOwner(msg.sender, _tokenId));
435 		_;
436 	  }
437 
438 	  constructor()
439 		public
440 	  {
441 		// register the supported interfaces to conform to ERC721 via ERC165
442 		_registerInterface(InterfaceId_ERC721);
443 		_registerInterface(InterfaceId_ERC721Exists);
444 	  }
445 
446 	  /**
447 	   * @dev Gets the balance of the specified address
448 	   * @param _owner address to query the balance of
449 	   * @return uint256 representing the amount owned by the passed address
450 	   */
451 	  function balanceOf(address _owner) public view returns (uint256) {
452 		require(_owner != address(0));
453 		return ownedTokensCount[_owner];
454 	  }
455 
456 	  /**
457 	   * @dev Gets the owner of the specified token ID
458 	   * @param _tokenId uint256 ID of the token to query the owner of
459 	   * @return owner address currently marked as the owner of the given token ID
460 	   */
461 	  function ownerOf(uint256 _tokenId) public view returns (address) {
462 		address owner = tokenOwner[_tokenId];
463 		require(owner != address(0));
464 		return owner;
465 	  }
466 
467 	  /**
468 	   * @dev Returns whether the specified token exists
469 	   * @param _tokenId uint256 ID of the token to query the existence of
470 	   * @return whether the token exists
471 	   */
472 	  function exists(uint256 _tokenId) public view returns (bool) {
473 		address owner = tokenOwner[_tokenId];
474 		return owner != address(0);
475 	  }
476 
477 	  /**
478 	   * @dev Approves another address to transfer the given token ID
479 	   * The zero address indicates there is no approved address.
480 	   * There can only be one approved address per token at a given time.
481 	   * Can only be called by the token owner or an approved operator.
482 	   * @param _to address to be approved for the given token ID
483 	   * @param _tokenId uint256 ID of the token to be approved
484 	   */
485 	  function approve(address _to, uint256 _tokenId) public {
486 		address owner = ownerOf(_tokenId);
487 		require(_to != owner);
488 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
489 
490 		tokenApprovals[_tokenId] = _to;
491 		emit Approval(owner, _to, _tokenId);
492 	  }
493 
494 	  /**
495 	   * @dev Gets the approved address for a token ID, or zero if no address set
496 	   * @param _tokenId uint256 ID of the token to query the approval of
497 	   * @return address currently approved for the given token ID
498 	   */
499 	  function getApproved(uint256 _tokenId) public view returns (address) {
500 		return tokenApprovals[_tokenId];
501 	  }
502 
503 	  /**
504 	   * @dev Sets or unsets the approval of a given operator
505 	   * An operator is allowed to transfer all tokens of the sender on their behalf
506 	   * @param _to operator address to set the approval
507 	   * @param _approved representing the status of the approval to be set
508 	   */
509 	  function setApprovalForAll(address _to, bool _approved) public {
510 		require(_to != msg.sender);
511 		operatorApprovals[msg.sender][_to] = _approved;
512 		emit ApprovalForAll(msg.sender, _to, _approved);
513 	  }
514 
515 	  /**
516 	   * @dev Tells whether an operator is approved by a given owner
517 	   * @param _owner owner address which you want to query the approval of
518 	   * @param _operator operator address which you want to query the approval of
519 	   * @return bool whether the given operator is approved by the given owner
520 	   */
521 	  function isApprovedForAll(
522 		address _owner,
523 		address _operator
524 	  )
525 		public
526 		view
527 		returns (bool)
528 	  {
529 		return operatorApprovals[_owner][_operator];
530 	  }
531 
532 	  /**
533 	   * @dev Transfers the ownership of a given token ID to another address
534 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
535 	   * Requires the msg sender to be the owner, approved, or operator
536 	   * @param _from current owner of the token
537 	   * @param _to address to receive the ownership of the given token ID
538 	   * @param _tokenId uint256 ID of the token to be transferred
539 	  */
540 	  function transferFrom(
541 		address _from,
542 		address _to,
543 		uint256 _tokenId
544 	  )
545 		public
546 		canTransfer(_tokenId)
547 	  {
548 		require(_from != address(0));
549 		require(_to != address(0));
550 
551 		clearApproval(_from, _tokenId);
552 		removeTokenFrom(_from, _tokenId);
553 		addTokenTo(_to, _tokenId);
554 
555 		emit Transfer(_from, _to, _tokenId);
556 	  }
557 
558 	  /**
559 	   * @dev Safely transfers the ownership of a given token ID to another address
560 	   * If the target address is a contract, it must implement `onERC721Received`,
561 	   * which is called upon a safe transfer, and return the magic value
562 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
563 	   * the transfer is reverted.
564 	   *
565 	   * Requires the msg sender to be the owner, approved, or operator
566 	   * @param _from current owner of the token
567 	   * @param _to address to receive the ownership of the given token ID
568 	   * @param _tokenId uint256 ID of the token to be transferred
569 	  */
570 	  function safeTransferFrom(
571 		address _from,
572 		address _to,
573 		uint256 _tokenId
574 	  )
575 		public
576 		canTransfer(_tokenId)
577 	  {
578 		// solium-disable-next-line arg-overflow
579 		safeTransferFrom(_from, _to, _tokenId, "");
580 	  }
581 
582 	  /**
583 	   * @dev Safely transfers the ownership of a given token ID to another address
584 	   * If the target address is a contract, it must implement `onERC721Received`,
585 	   * which is called upon a safe transfer, and return the magic value
586 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
587 	   * the transfer is reverted.
588 	   * Requires the msg sender to be the owner, approved, or operator
589 	   * @param _from current owner of the token
590 	   * @param _to address to receive the ownership of the given token ID
591 	   * @param _tokenId uint256 ID of the token to be transferred
592 	   * @param _data bytes data to send along with a safe transfer check
593 	   */
594 	  function safeTransferFrom(
595 		address _from,
596 		address _to,
597 		uint256 _tokenId,
598 		bytes _data
599 	  )
600 		public
601 		canTransfer(_tokenId)
602 	  {
603 		transferFrom(_from, _to, _tokenId);
604 		// solium-disable-next-line arg-overflow
605 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
606 	  }
607 
608 	  /**
609 	   * @dev Returns whether the given spender can transfer a given token ID
610 	   * @param _spender address of the spender to query
611 	   * @param _tokenId uint256 ID of the token to be transferred
612 	   * @return bool whether the msg.sender is approved for the given token ID,
613 	   *  is an operator of the owner, or is the owner of the token
614 	   */
615 	  function isApprovedOrOwner(
616 		address _spender,
617 		uint256 _tokenId
618 	  )
619 		internal
620 		view
621 		returns (bool)
622 	  {
623 		address owner = ownerOf(_tokenId);
624 		// Disable solium check because of
625 		// https://github.com/duaraghav8/Solium/issues/175
626 		// solium-disable-next-line operator-whitespace
627 		return (
628 		  _spender == owner ||
629 		  getApproved(_tokenId) == _spender ||
630 		  isApprovedForAll(owner, _spender)
631 		);
632 	  }
633 
634 	  /**
635 	   * @dev Internal function to mint a new token
636 	   * Reverts if the given token ID already exists
637 	   * @param _to The address that will own the minted token
638 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
639 	   */
640 	  function _mint(address _to, uint256 _tokenId) internal {
641 		require(_to != address(0));
642 		addTokenTo(_to, _tokenId);
643 		emit Transfer(address(0), _to, _tokenId);
644 	  }
645 
646 	  /**
647 	   * @dev Internal function to clear current approval of a given token ID
648 	   * Reverts if the given address is not indeed the owner of the token
649 	   * @param _owner owner of the token
650 	   * @param _tokenId uint256 ID of the token to be transferred
651 	   */
652 	  function clearApproval(address _owner, uint256 _tokenId) internal {
653 		require(ownerOf(_tokenId) == _owner);
654 		if (tokenApprovals[_tokenId] != address(0)) {
655 		  tokenApprovals[_tokenId] = address(0);
656 		}
657 	  }
658 
659 	  /**
660 	   * @dev Internal function to add a token ID to the list of a given address
661 	   * @param _to address representing the new owner of the given token ID
662 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
663 	   */
664 	  function addTokenTo(address _to, uint256 _tokenId) internal {
665 		require(tokenOwner[_tokenId] == address(0));
666 		tokenOwner[_tokenId] = _to;
667 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
668 	  }
669 
670 	  /**
671 	   * @dev Internal function to remove a token ID from the list of a given address
672 	   * @param _from address representing the previous owner of the given token ID
673 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
674 	   */
675 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
676 		require(ownerOf(_tokenId) == _from);
677 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
678 		tokenOwner[_tokenId] = address(0);
679 	  }
680 
681 	  /**
682 	   * @dev Internal function to invoke `onERC721Received` on a target address
683 	   * The call is not executed if the target address is not a contract
684 	   * @param _from address representing the previous owner of the given token ID
685 	   * @param _to target address that will receive the tokens
686 	   * @param _tokenId uint256 ID of the token to be transferred
687 	   * @param _data bytes optional data to send along with the call
688 	   * @return whether the call correctly returned the expected magic value
689 	   */
690 	  function checkAndCallSafeTransfer(
691 		address _from,
692 		address _to,
693 		uint256 _tokenId,
694 		bytes _data
695 	  )
696 		internal
697 		returns (bool)
698 	  {
699 		if (!_to.isContract()) {
700 		  return true;
701 		}
702 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
703 		  msg.sender, _from, _tokenId, _data);
704 		return (retval == ERC721_RECEIVED);
705 	  }
706 	}
707 
708 	/**
709 	 * @title Full ERC721 Token
710 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
711 	 * Moreover, it includes approve all functionality using operator terminology
712 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
713 	 */
714 	contract ERC721dAppCaps is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721, Ownable, Fallback {
715 
716 	  /*** EVENTS ***/
717 	  /// The event emitted (useable by web3) when a token is purchased
718 	  event BoughtToken(address indexed buyer, uint256 tokenId);
719 
720 	  /*** CONSTANTS ***/
721       string public constant company = "Qwoyn, LLC ";
722       string public constant contact = "https://qwoyn.io";
723       string public constant author  = "Daniel Pittman";
724 
725 	  
726 	  uint8 constant TITLE_MAX_LENGTH = 64;
727 	  uint256 constant DESCRIPTION_MAX_LENGTH = 100000;
728 
729 	  /*** DATA TYPES ***/
730 
731 	  /// Price set by contract owner for each token in Wei
732 	  /// @dev If you'd like a different price for each token type, you will
733 	  ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
734 	  uint256 currentPrice = 0;
735 	  
736 	  mapping(uint256 => uint256) tokenTypes;
737 	  mapping(uint256 => string)  tokenTitles;	  
738 	  mapping(uint256 => string)  tokenDescriptions;
739 	  mapping(uint256 => string)  specialQualities;	  	  
740 	  mapping(uint256 => string)  tokenClasses;
741 	  mapping(uint256 => string)  iptcKeywords;
742 	  
743 
744 	  constructor(string _name, string _symbol) public {
745 		name_ = _name;
746 		symbol_ = _symbol;
747 
748 		// register the supported interfaces to conform to ERC721 via ERC165
749 		_registerInterface(InterfaceId_ERC721Enumerable);
750 		_registerInterface(InterfaceId_ERC721Metadata);
751 	  }
752 
753 	  /// Requires the amount of Ether be at least or more of the currentPrice
754 	  /// @dev Creates an instance of an token and mints it to the purchaser
755 	  /// @param _type The token type as an integer, dappCap and slammers noted here.
756 	  /// @param _title The short title of the token
757 	  /// @param _description Description of the token
758 	  function buyToken (
759 		uint256 _type,
760 		string  _title,
761 		string  _description,
762 		string  _specialQuality,
763 		string  _iptcKeyword,
764 		string  _tokenClass
765 	  ) public onlyOwner {
766 		bytes memory _titleBytes = bytes(_title);
767 		require(_titleBytes.length <= TITLE_MAX_LENGTH, "Desription is too long");
768 		
769 		bytes memory _descriptionBytes = bytes(_description);
770 		require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
771 		require(msg.value >= currentPrice, "Amount of Ether sent too small");
772 
773 		uint256 index = allTokens.length + 1;
774 
775 		_mint(msg.sender, index);
776 
777 		tokenTypes[index]        = _type;
778 		tokenTitles[index]       = _title;
779 		tokenDescriptions[index] = _description;
780 		specialQualities[index]  = _specialQuality;
781 		iptcKeywords[index]      = _iptcKeyword;
782 		tokenClasses[index]      = _tokenClass;
783 
784 		emit BoughtToken(msg.sender, index);
785 	  }
786 
787 	  /**
788 	   * @dev Returns all of the tokens that the user owns
789 	   * @return An array of token indices
790 	   */
791 	  function myTokens()
792 		external
793 		view
794 		returns (
795 		  uint256[]
796 		)
797 	  {
798 		return ownedTokens[msg.sender];
799 	  }
800 
801 	  /// @notice Returns all the relevant information about a specific token
802 	  /// @param _tokenId The ID of the token of interest
803 	  function viewTokenMeta(uint256 _tokenId)
804 		external
805 		view
806 		returns (
807 		  uint256 tokenType_,
808 		  string  specialQuality_,
809 		  string  tokenTitle_,
810 		  string  tokenDescription_,
811 		  string  iptcKeyword_,
812 		  string  tokenClass_
813 	  ) {
814 		  tokenType_        = tokenTypes[_tokenId];
815 		  tokenTitle_       = tokenTitles[_tokenId];
816 		  tokenDescription_ = tokenDescriptions[_tokenId];
817 		  specialQuality_   = specialQualities[_tokenId];
818 		  iptcKeyword_      = iptcKeywords[_tokenId];
819 		  tokenClass_       = tokenClasses[_tokenId];
820 	  }
821 
822 	  /// @notice Allows the owner of this contract to set the currentPrice for each token
823 	  function setCurrentPrice(uint256 newPrice)
824 		public
825 		onlyOwner
826 	  {
827 		  currentPrice = newPrice;
828 	  }
829 
830 	  /// @notice Returns the currentPrice for each token
831 	  function getCurrentPrice()
832 		external
833 		view
834 		returns (
835 		uint256 price
836 	  ) {
837 		  price = currentPrice;
838 	  }
839 	  
840 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
841 	  /**
842 	   * 0x780e9d63 ===
843 	   *   bytes4(keccak256('totalSupply()')) ^
844 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
845 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
846 	   */
847 
848 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
849 	  /**
850 	   * 0x5b5e139f ===
851 	   *   bytes4(keccak256('name()')) ^
852 	   *   bytes4(keccak256('symbol()')) ^
853 	   *   bytes4(keccak256('tokenURI(uint256)'))
854 	   */
855 
856 	  // Token name
857 	  string internal name_;
858 
859 	  // Token symbol
860 	  string internal symbol_;
861 
862 	  // Mapping from owner to list of owned token IDs
863 	  mapping(address => uint256[]) internal ownedTokens;
864 
865 	  // Mapping from token ID to index of the owner tokens list
866 	  mapping(uint256 => uint256) internal ownedTokensIndex;
867 
868 	  // Array with all token ids, used for enumeration
869 	  uint256[] internal allTokens;
870 
871 	  // Mapping from token id to position in the allTokens array
872 	  mapping(uint256 => uint256) internal allTokensIndex;
873 
874 	  // Optional mapping for token URIs
875 	  mapping(uint256 => string) internal tokenURIs;
876 
877 	  /**
878 	   * @dev Gets the token name
879 	   * @return string representing the token name
880 	   */
881 	  function name() external view returns (string) {
882 		return name_;
883 	  }
884 
885 	  /**
886 	   * @dev Gets the token symbol
887 	   * @return string representing the token symbol
888 	   */
889 	  function symbol() external view returns (string) {
890 		return symbol_;
891 	  }
892 
893 	  /**
894 	   * @dev Returns an URI for a given token ID
895 	   * Throws if the token ID does not exist. May return an empty string.
896 	   * @param _tokenId uint256 ID of the token to query
897 	   */
898 	  function tokenURI(uint256 _tokenId) public view returns (string) {
899 		require(exists(_tokenId));
900 		return tokenURIs[_tokenId];
901 	  }
902 
903 	  /**
904 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
905 	   * @param _owner address owning the tokens list to be accessed
906 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
907 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
908 	   */
909 	  function tokenOfOwnerByIndex(
910 		address _owner,
911 		uint256 _index
912 	  )
913 		public
914 		view
915 		returns (uint256)
916 	  {
917 		require(_index < balanceOf(_owner));
918 		return ownedTokens[_owner][_index];
919 	  }
920 
921 	  /**
922 	   * @dev Gets the total amount of tokens stored by the contract
923 	   * @return uint256 representing the total amount of tokens
924 	   */
925 	  function totalSupply() public view returns (uint256) {
926 		return allTokens.length;
927 	  }
928 
929 	  /**
930 	   * @dev Gets the token ID at a given index of all the tokens in this contract
931 	   * Reverts if the index is greater or equal to the total number of tokens
932 	   * @param _index uint256 representing the index to be accessed of the tokens list
933 	   * @return uint256 token ID at the given index of the tokens list
934 	   */
935 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
936 		require(_index < totalSupply());
937 		return allTokens[_index];
938 	  }
939 
940 	  /**
941 	   * @dev Internal function to set the token URI for a given token
942 	   * Reverts if the token ID does not exist
943 	   * @param _tokenId uint256 ID of the token to set its URI
944 	   * @param _uri string URI to assign
945 	   */
946 	  function _setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
947 		require(exists(_tokenId));
948 		tokenURIs[_tokenId] = _uri;
949 	  }
950 
951 	  /**
952 	   * @dev Internal function to add a token ID to the list of a given address
953 	   * @param _to address representing the new owner of the given token ID
954 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
955 	   */
956 	  function addTokenTo(address _to, uint256 _tokenId) internal {
957 		super.addTokenTo(_to, _tokenId);
958 		uint256 length = ownedTokens[_to].length;
959 		ownedTokens[_to].push(_tokenId);
960 		ownedTokensIndex[_tokenId] = length;
961 	  }
962 
963 	  /**
964 	   * @dev Internal function to remove a token ID from the list of a given address
965 	   * @param _from address representing the previous owner of the given token ID
966 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
967 	   */
968 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
969 		super.removeTokenFrom(_from, _tokenId);
970 
971 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
972 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
973 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
974 
975 		ownedTokens[_from][tokenIndex] = lastToken;
976 		ownedTokens[_from][lastTokenIndex] = 0;
977 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
978 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
979 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
980 
981 		ownedTokens[_from].length--;
982 		ownedTokensIndex[_tokenId] = 0;
983 		ownedTokensIndex[lastToken] = tokenIndex;
984 	  }
985 
986 	  /**
987 	   * @dev Internal function to mint a new token
988 	   * Reverts if the given token ID already exists
989 	   * @param _to address the beneficiary that will own the minted token
990 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
991 	   */
992 	  function _mint(address _to, uint256 _tokenId) internal {
993 		super._mint(_to, _tokenId);
994 
995 		allTokensIndex[_tokenId] = allTokens.length;
996 		allTokens.push(_tokenId);
997 	  }
998 	}