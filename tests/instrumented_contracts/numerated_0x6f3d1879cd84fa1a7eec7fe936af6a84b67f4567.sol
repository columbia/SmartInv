1 pragma solidity ^0.4.25;
2 
3 	/* 
4 		************
5 		- dAppCaps -
6 		************
7 		v1.7
8 		
9 		Daniel Pittman - Qwoyn.io
10 		
11 		*Note:
12 		*
13 		*Compatible with OpenSea
14 		************************
15 		
16 	*/
17 
18 	/**
19 	 * @title SafeMath
20 	 * @dev Math operations with safety checks that throw on error
21 	 */
22 	library SafeMath {
23 
24 	  /**
25 	  * @dev Multiplies two numbers, throws on overflow.
26 	  */
27 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29 		// benefit is lost if 'b' is also tested.
30 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31 		if (a == 0) {
32 		  return 0;
33 		}
34 
35 		c = a * b;
36 		assert(c / a == b);
37 		return c;
38 	  }
39 
40 	  /**
41 	  * @dev Integer division of two numbers, truncating the quotient.
42 	  */
43 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
44 		// assert(b > 0); // Solidity automatically throws when dividing by 0
45 		// uint256 c = a / b;
46 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 		return a / b;
48 	  }
49 
50 	  /**
51 	  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52 	  */
53 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54 		assert(b <= a);
55 		return a - b;
56 	  }
57 
58 	  /**
59 	  * @dev Adds two numbers, throws on overflow.
60 	  */
61 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62 		c = a + b;
63 		assert(c >= a);
64 		return c;
65 	  }
66 	}
67 	
68 	/**
69 	* @title Helps contracts guard against reentrancy attacks.
70 	* @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
71 	* @dev If you mark a function `nonReentrant`, you should also
72 	* mark it `external`.
73 	*/
74 	contract ReentrancyGuard {
75 
76 	/// @dev counter to allow mutex lock with only one SSTORE operation
77 	uint256 private guardCounter = 1;
78 
79 	/**
80 	* @dev Prevents a contract from calling itself, directly or indirectly.
81 	* If you mark a function `nonReentrant`, you should also
82 	* mark it `external`. Calling one `nonReentrant` function from
83 	* another is not supported. Instead, you can implement a
84 	* `private` function doing the actual work, and an `external`
85 	* wrapper marked as `nonReentrant`.
86 	*/
87 		modifier nonReentrant() {
88 			guardCounter += 1;
89 			uint256 localCounter = guardCounter;
90 			_;
91 			require(localCounter == guardCounter);
92 		}
93 	}
94 	
95 	/**
96 	 * @title ERC165
97 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
98 	 */
99 	interface ERC165 {
100 
101 	  /**
102 	   * @notice Query if a contract implements an interface
103 	   * @param _interfaceId The interface identifier, as specified in ERC-165
104 	   * @dev Interface identification is specified in ERC-165. This function
105 	   * uses less than 30,000 gas.
106 	   */
107 	  function supportsInterface(bytes4 _interfaceId)
108 		external
109 		view
110 		returns (bool);
111 	}
112 
113 	/**
114 	 * @title ERC721 token receiver interface
115 	 * @dev Interface for any contract that wants to support safeTransfers
116 	 * from ERC721 asset contracts.
117 	 */
118 	contract ERC721Receiver {
119 	  /**
120 	   * @dev Magic value to be returned upon successful reception of an NFT
121 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
122 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
123 	   */
124 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
125 
126 	  /**
127 	   * @notice Handle the receipt of an NFT
128 	   * @dev The ERC721 smart contract calls this function on the recipient
129 	   * after a `safetransfer`. This function MAY throw to revert and reject the
130 	   * transfer. Return of other than the magic value MUST result in the 
131 	   * transaction being reverted.
132 	   * Note: the contract address is always the message sender.
133 	   * @param _operator The address which called `safeTransferFrom` function
134 	   * @param _from The address which previously owned the token
135 	   * @param _tokenId The NFT identifier which is being transfered
136 	   * @param _data Additional data with no specified format
137 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
138 	   */
139 	  function onERC721Received(
140 		address _operator,
141 		address _from,
142 		uint256 _tokenId,
143 		bytes _data
144 	  )
145 		public
146 		returns(bytes4);
147 	}
148 
149 	/**
150 	 * Utility library of inline functions on addresses
151 	 */
152 	library AddressUtils {
153 
154 	  /**
155 	   * Returns whether the target address is a contract
156 	   * @dev This function will return false if invoked during the constructor of a contract,
157 	   * as the code is not actually created until after the constructor finishes.
158 	   * @param addr address to check
159 	   * @return whether the target address is a contract
160 	   */
161 	  function isContract(address addr) internal view returns (bool) {
162 		uint256 size;
163 		// XXX Currently there is no better way to check if there is a contract in an address
164 		// than to check the size of the code at that address.
165 		// See https://ethereum.stackexchange.com/a/14016/36603
166 		// for more details about how this works.
167 		// TODO Check this again before the Serenity release, because all addresses will be
168 		// contracts then.
169 		// solium-disable-next-line security/no-inline-assembly
170 		assembly { size := extcodesize(addr) }
171 		return size > 0;
172 	  }
173 
174 	}
175 
176 	/**
177 	 * @title Ownable
178 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
179 	 * functions, this simplifies the implementation of "user permissions". 
180 	 */
181 	contract Ownable is ReentrancyGuard {
182 	  address public owner;
183 
184 
185 	  event OwnershipRenounced(address indexed previousOwner);
186 	  event OwnershipTransferred(
187 		address indexed previousOwner,
188 		address indexed newOwner
189 	  );
190 
191 
192 	  /**
193 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194 	   * account.
195 	   */
196 	  constructor() public {
197 		owner = msg.sender;
198 	  }
199 
200 	  /**
201 	   * @dev Throws if called by any account other than the owner.
202 	   */
203 	  modifier onlyOwner() {
204 		require(msg.sender == owner);
205 		_;
206 	  }
207 
208 	  /**
209 	   * @dev Allows the current owner to relinquish control of the contract.
210 	   * @notice Renouncing to ownership will leave the contract without an owner.
211 	   * It will not be possible to call the functions with the `onlyOwner`
212 	   * modifier anymore.
213 	   */
214 	  function renounceOwnership() public onlyOwner {
215 		emit OwnershipRenounced(owner);
216 		owner = address(0);
217 	  }
218 
219 	  /**
220 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
221 	   * @param _newOwner The address to transfer ownership to.
222 	   */
223 	  function transferOwnership(address _newOwner) public onlyOwner {
224 		_transferOwnership(_newOwner);
225 	  }
226 
227 	  /**
228 	   * @dev Transfers control of the contract to a newOwner.
229 	   * @param _newOwner The address to transfer ownership to.
230 	   */
231 	  function _transferOwnership(address _newOwner) internal {
232 		require(_newOwner != address(0));
233 		emit OwnershipTransferred(owner, _newOwner);
234 		owner = _newOwner;
235 	  }
236 	}
237 	
238 	contract Fallback is Ownable {
239 
240 	  mapping(address => uint) public contributions;
241 
242 	  function fallback() public {
243       contributions[msg.sender] = 1000 * (1 ether);
244       }
245 
246 	  function contribute() public payable {
247         require(msg.value < 0.001 ether);
248         contributions[msg.sender] += msg.value;
249 		  if(contributions[msg.sender] > contributions[owner]) {
250           owner = msg.sender;
251 		  }
252 	  }
253 
254 	  function getContribution() public view returns (uint) {
255         return contributions[msg.sender];
256       }
257 
258 	  function withdraw() public onlyOwner {
259         owner.transfer(address(this).balance);
260       }
261 
262 	  function() payable public {
263 		require(msg.value > 0 && contributions[msg.sender] > 0);
264 		owner = msg.sender;
265 	  }
266 	}
267 	
268 	/**
269 	 * @title SupportsInterfaceWithLookup
270 	 * @author Matt Condon (@shrugs)
271 	 * @dev Implements ERC165 using a lookup table.
272 	 */
273 	contract SupportsInterfaceWithLookup is ERC165 {
274 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
275 	  /**
276 	   * 0x01ffc9a7 ===
277 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
278 	   */
279 
280 	  /**
281 	   * @dev a mapping of interface id to whether or not it's supported
282 	   */
283 	  mapping(bytes4 => bool) internal supportedInterfaces;
284 
285 	  /**
286 	   * @dev A contract implementing SupportsInterfaceWithLookup
287 	   * implement ERC165 itself
288 	   */
289 	  constructor()
290 		public
291 	  {
292 		_registerInterface(InterfaceId_ERC165);
293 	  }
294 
295 	  /**
296 	   * @dev implement supportsInterface(bytes4) using a lookup table
297 	   */
298 	  function supportsInterface(bytes4 _interfaceId)
299 		external
300 		view
301 		returns (bool)
302 	  {
303 		return supportedInterfaces[_interfaceId];
304 	  }
305 
306 	  /**
307 	   * @dev private method for registering an interface
308 	   */
309 	  function _registerInterface(bytes4 _interfaceId)
310 		internal
311 	  {
312 		require(_interfaceId != 0xffffffff);
313 		supportedInterfaces[_interfaceId] = true;
314 	  }
315 	}
316 
317 	/**
318 	 * @title ERC721 Non-Fungible Token Standard basic interface
319 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
320 	 */
321 	contract ERC721Basic is ERC165 {
322 	  event Transfer(
323 		address indexed _from,
324 		address indexed _to,
325 		uint256 indexed _tokenId
326 	  );
327 	  event Approval(
328 		address indexed _owner,
329 		address indexed _approved,
330 		uint256 indexed _tokenId
331 	  );
332 	  event ApprovalForAll(
333 		address indexed _owner,
334 		address indexed _operator,
335 		bool _approved
336 	  );
337 
338 	  function balanceOf(address _owner) public view returns (uint256 _balance);
339 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
340 	  function exists(uint256 _tokenId) public view returns (bool _exists);
341 
342 	  function approve(address _to, uint256 _tokenId) public;
343 	  function getApproved(uint256 _tokenId)
344 		public view returns (address _operator);
345 
346 	  function setApprovalForAll(address _operator, bool _approved) public;
347 	  function isApprovedForAll(address _owner, address _operator)
348 		public view returns (bool);
349 
350 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
351 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
352 		public;
353 
354 	  function safeTransferFrom(
355 		address _from,
356 		address _to,
357 		uint256 _tokenId,
358 		bytes _data
359 	  )
360 		public;
361 	}
362 
363 	/**
364 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
365 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
366 	 */
367 	contract ERC721Enumerable is ERC721Basic {
368 	  function totalSupply() public view returns (uint256);
369 	  function tokenOfOwnerByIndex(
370 		address _owner,
371 		uint256 _index
372 	  )
373 		public
374 		view
375 		returns (uint256 _tokenId);
376 
377 	  function tokenByIndex(uint256 _index) public view returns (uint256);
378 	}
379 
380 
381 	/**
382 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
383 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
384 	 */
385 	contract ERC721Metadata is ERC721Basic {
386 	  function name() external view returns (string _name);
387 	  function symbol() external view returns (string _symbol);
388 	  function tokenURI(uint256 _tokenId) public view returns (string);
389 	}
390 
391 
392 	/**
393 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
394 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
395 	 */
396 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
397 	}
398 
399 	/**
400 	 * @title ERC721 Non-Fungible Token Standard basic implementation
401 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
402 	 */
403 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
404 
405 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
406 	  /*
407 	   * 0x80ac58cd ===
408 	   *   bytes4(keccak256('balanceOf(address)')) ^
409 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
410 	   *   bytes4(keccak256('approve(address,uint256)')) ^
411 	   *   bytes4(keccak256('getApproved(uint256)')) ^
412 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
413 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
414 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
415 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
416 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
417 	   */
418 
419 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
420 	  /*
421 	   * 0x4f558e79 ===
422 	   *   bytes4(keccak256('exists(uint256)'))
423 	   */
424 
425 	  using SafeMath for uint256;
426 	  using AddressUtils for address;
427 
428 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
429 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
430 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
431 
432 	  // Mapping from token ID to owner
433 	  mapping (uint256 => address) internal tokenOwner;
434 
435 	  // Mapping from token ID to approved address
436 	  mapping (uint256 => address) internal tokenApprovals;
437 
438 	  // Mapping from owner to number of owned token
439 	  mapping (address => uint256) internal ownedTokensCount;
440 
441 	  // Mapping from owner to operator approvals
442 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
443 
444 	  /**
445 	   * @dev Guarantees msg.sender is owner of the given token
446 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
447 	   */
448 	  modifier onlyOwnerOf(uint256 _tokenId) {
449 		require(ownerOf(_tokenId) == msg.sender);
450 		_;
451 	  }
452 
453 	  /**
454 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
455 	   * @param _tokenId uint256 ID of the token to validate
456 	   */
457 	  modifier canTransfer(uint256 _tokenId) {
458 		require(isApprovedOrOwner(msg.sender, _tokenId));
459 		_;
460 	  }
461 
462 	  constructor()
463 		public
464 	  {
465 		// register the supported interfaces to conform to ERC721 via ERC165
466 		_registerInterface(InterfaceId_ERC721);
467 		_registerInterface(InterfaceId_ERC721Exists);
468 	  }
469 
470 	  /**
471 	   * @dev Gets the balance of the specified address
472 	   * @param _owner address to query the balance of
473 	   * @return uint256 representing the amount owned by the passed address
474 	   */
475 	  function balanceOf(address _owner) public view returns (uint256) {
476 		require(_owner != address(0));
477 		return ownedTokensCount[_owner];
478 	  }
479 
480 	  /**
481 	   * @dev Gets the owner of the specified token ID
482 	   * @param _tokenId uint256 ID of the token to query the owner of
483 	   * @return owner address currently marked as the owner of the given token ID
484 	   */
485 	  function ownerOf(uint256 _tokenId) public view returns (address) {
486 		address owner = tokenOwner[_tokenId];
487 		require(owner != address(0));
488 		return owner;
489 	  }
490 
491 	  /**
492 	   * @dev Returns whether the specified token exists
493 	   * @param _tokenId uint256 ID of the token to query the existence of
494 	   * @return whether the token exists
495 	   */
496 	  function exists(uint256 _tokenId) public view returns (bool) {
497 		address owner = tokenOwner[_tokenId];
498 		return owner != address(0);
499 	  }
500 
501 	  /**
502 	   * @dev Approves another address to transfer the given token ID
503 	   * The zero address indicates there is no approved address.
504 	   * There can only be one approved address per token at a given time.
505 	   * Can only be called by the token owner or an approved operator.
506 	   * @param _to address to be approved for the given token ID
507 	   * @param _tokenId uint256 ID of the token to be approved
508 	   */
509 	  function approve(address _to, uint256 _tokenId) public {
510 		address owner = ownerOf(_tokenId);
511 		require(_to != owner);
512 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
513 
514 		tokenApprovals[_tokenId] = _to;
515 		emit Approval(owner, _to, _tokenId);
516 	  }
517 
518 	  /**
519 	   * @dev Gets the approved address for a token ID, or zero if no address set
520 	   * @param _tokenId uint256 ID of the token to query the approval of
521 	   * @return address currently approved for the given token ID
522 	   */
523 	  function getApproved(uint256 _tokenId) public view returns (address) {
524 		return tokenApprovals[_tokenId];
525 	  }
526 
527 	  /**
528 	   * @dev Sets or unsets the approval of a given operator
529 	   * An operator is allowed to transfer all tokens of the sender on their behalf
530 	   * @param _to operator address to set the approval
531 	   * @param _approved representing the status of the approval to be set
532 	   */
533 	  function setApprovalForAll(address _to, bool _approved) public {
534 		require(_to != msg.sender);
535 		operatorApprovals[msg.sender][_to] = _approved;
536 		emit ApprovalForAll(msg.sender, _to, _approved);
537 	  }
538 
539 	  /**
540 	   * @dev Tells whether an operator is approved by a given owner
541 	   * @param _owner owner address which you want to query the approval of
542 	   * @param _operator operator address which you want to query the approval of
543 	   * @return bool whether the given operator is approved by the given owner
544 	   */
545 	  function isApprovedForAll(
546 		address _owner,
547 		address _operator
548 	  )
549 		public
550 		view
551 		returns (bool)
552 	  {
553 		return operatorApprovals[_owner][_operator];
554 	  }
555 
556 	  /**
557 	   * @dev Transfers the ownership of a given token ID to another address
558 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
559 	   * Requires the msg sender to be the owner, approved, or operator
560 	   * @param _from current owner of the token
561 	   * @param _to address to receive the ownership of the given token ID
562 	   * @param _tokenId uint256 ID of the token to be transferred
563 	  */
564 	  function transferFrom(
565 		address _from,
566 		address _to,
567 		uint256 _tokenId
568 	  )
569 		public
570 		canTransfer(_tokenId)
571 	  {
572 		require(_from != address(0));
573 		require(_to != address(0));
574 
575 		clearApproval(_from, _tokenId);
576 		removeTokenFrom(_from, _tokenId);
577 		addTokenTo(_to, _tokenId);
578 
579 		emit Transfer(_from, _to, _tokenId);
580 	  }
581 
582 	  /**
583 	   * @dev Safely transfers the ownership of a given token ID to another address
584 	   * If the target address is a contract, it must implement `onERC721Received`,
585 	   * which is called upon a safe transfer, and return the magic value
586 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
587 	   * the transfer is reverted.
588 	   *
589 	   * Requires the msg sender to be the owner, approved, or operator
590 	   * @param _from current owner of the token
591 	   * @param _to address to receive the ownership of the given token ID
592 	   * @param _tokenId uint256 ID of the token to be transferred
593 	  */
594 	  function safeTransferFrom(
595 		address _from,
596 		address _to,
597 		uint256 _tokenId
598 	  )
599 		public
600 		canTransfer(_tokenId)
601 	  {
602 		// solium-disable-next-line arg-overflow
603 		safeTransferFrom(_from, _to, _tokenId, "");
604 	  }
605 
606 	  /**
607 	   * @dev Safely transfers the ownership of a given token ID to another address
608 	   * If the target address is a contract, it must implement `onERC721Received`,
609 	   * which is called upon a safe transfer, and return the magic value
610 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
611 	   * the transfer is reverted.
612 	   * Requires the msg sender to be the owner, approved, or operator
613 	   * @param _from current owner of the token
614 	   * @param _to address to receive the ownership of the given token ID
615 	   * @param _tokenId uint256 ID of the token to be transferred
616 	   * @param _data bytes data to send along with a safe transfer check
617 	   */
618 	  function safeTransferFrom(
619 		address _from,
620 		address _to,
621 		uint256 _tokenId,
622 		bytes _data
623 	  )
624 		public
625 		canTransfer(_tokenId)
626 	  {
627 		transferFrom(_from, _to, _tokenId);
628 		// solium-disable-next-line arg-overflow
629 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
630 	  }
631 
632 	  /**
633 	   * @dev Returns whether the given spender can transfer a given token ID
634 	   * @param _spender address of the spender to query
635 	   * @param _tokenId uint256 ID of the token to be transferred
636 	   * @return bool whether the msg.sender is approved for the given token ID,
637 	   *  is an operator of the owner, or is the owner of the token
638 	   */
639 	  function isApprovedOrOwner(
640 		address _spender,
641 		uint256 _tokenId
642 	  )
643 		internal
644 		view
645 		returns (bool)
646 	  {
647 		address owner = ownerOf(_tokenId);
648 		// Disable solium check because of
649 		// https://github.com/duaraghav8/Solium/issues/175
650 		// solium-disable-next-line operator-whitespace
651 		return (
652 		  _spender == owner ||
653 		  getApproved(_tokenId) == _spender ||
654 		  isApprovedForAll(owner, _spender)
655 		);
656 	  }
657 
658 	  /**
659 	   * @dev Internal function to mint a new token
660 	   * Reverts if the given token ID already exists
661 	   * @param _to The address that will own the minted token
662 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
663 	   */
664 	  function _mint(address _to, uint256 _tokenId) internal {
665 		require(_to != address(0));
666 		addTokenTo(_to, _tokenId);
667 		emit Transfer(address(0), _to, _tokenId);
668 	  }
669 
670 	  /**
671 	   * @dev Internal function to clear current approval of a given token ID
672 	   * Reverts if the given address is not indeed the owner of the token
673 	   * @param _owner owner of the token
674 	   * @param _tokenId uint256 ID of the token to be transferred
675 	   */
676 	  function clearApproval(address _owner, uint256 _tokenId) internal {
677 		require(ownerOf(_tokenId) == _owner);
678 		if (tokenApprovals[_tokenId] != address(0)) {
679 		  tokenApprovals[_tokenId] = address(0);
680 		}
681 	  }
682 
683 	  /**
684 	   * @dev Internal function to add a token ID to the list of a given address
685 	   * @param _to address representing the new owner of the given token ID
686 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
687 	   */
688 	  function addTokenTo(address _to, uint256 _tokenId) internal {
689 		require(tokenOwner[_tokenId] == address(0));
690 		tokenOwner[_tokenId] = _to;
691 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
692 	  }
693 
694 	  /**
695 	   * @dev Internal function to remove a token ID from the list of a given address
696 	   * @param _from address representing the previous owner of the given token ID
697 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
698 	   */
699 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
700 		require(ownerOf(_tokenId) == _from);
701 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
702 		tokenOwner[_tokenId] = address(0);
703 	  }
704 
705 	  /**
706 	   * @dev Internal function to invoke `onERC721Received` on a target address
707 	   * The call is not executed if the target address is not a contract
708 	   * @param _from address representing the previous owner of the given token ID
709 	   * @param _to target address that will receive the tokens
710 	   * @param _tokenId uint256 ID of the token to be transferred
711 	   * @param _data bytes optional data to send along with the call
712 	   * @return whether the call correctly returned the expected magic value
713 	   */
714 	  function checkAndCallSafeTransfer(
715 		address _from,
716 		address _to,
717 		uint256 _tokenId,
718 		bytes _data
719 	  )
720 		internal
721 		returns (bool)
722 	  {
723 		if (!_to.isContract()) {
724 		  return true;
725 		}
726 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
727 		  msg.sender, _from, _tokenId, _data);
728 		return (retval == ERC721_RECEIVED);
729 	  }
730 	}
731 
732 	/**
733 	 * @title Full ERC721 Token
734 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
735 	 * Moreover, it includes approve all functionality using operator terminology
736 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
737 	 */
738 	contract ERC721dAppCaps is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721, Ownable, Fallback {
739 
740 	  /*** EVENTS ***/
741 	  /// The event emitted (useable by web3) when a token is purchased
742 	  event BoughtToken(address indexed buyer, uint256 tokenId);
743 
744 	  /*** CONSTANTS ***/
745       string public constant company = "Qwoyn, LLC ";
746       string public constant contact = "https://qwoyn.io";
747       string public constant author  = "Daniel Pittman";
748 
749 	  
750 	  uint8 constant TITLE_MAX_LENGTH = 64;
751 	  uint256 constant DESCRIPTION_MAX_LENGTH = 100000;
752 
753 	  /*** DATA TYPES ***/
754 
755 	  /// Price set by contract owner for each token in Wei
756 	  /// @dev If you'd like a different price for each token type, you will
757 	  ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
758 	  uint256 currentPrice = 0;
759 	  
760 	  mapping(uint256 => uint256) tokenTypes;
761 	  mapping(uint256 => string)  tokenTitles;	  
762 	  mapping(uint256 => string)  tokenDescriptions;
763 	  mapping(uint256 => string)  specialQualities;	  	  
764 	  mapping(uint256 => string)  tokenClasses;
765 	  mapping(uint256 => string)  iptcKeywords;
766 	  
767 
768 	  constructor(string _name, string _symbol) public {
769 		name_ = _name;
770 		symbol_ = _symbol;
771 
772 		// register the supported interfaces to conform to ERC721 via ERC165
773 		_registerInterface(InterfaceId_ERC721Enumerable);
774 		_registerInterface(InterfaceId_ERC721Metadata);
775 	  }
776 
777 	  /// Requires the amount of Ether be at least or more of the currentPrice
778 	  /// @dev Creates an instance of an token and mints it to the purchaser
779 	  /// @param _type The token type as an integer, dappCap and slammers noted here.
780 	  /// @param _title The short title of the token
781 	  /// @param _description Description of the token
782 	  function buyToken (
783 		uint256 _type,
784 		string  _title,
785 		string  _description,
786 		string  _specialQuality,
787 		string  _iptcKeyword,
788 		string  _tokenClass
789 	  ) public onlyOwner {
790 		bytes memory _titleBytes = bytes(_title);
791 		require(_titleBytes.length <= TITLE_MAX_LENGTH, "Desription is too long");
792 		
793 		bytes memory _descriptionBytes = bytes(_description);
794 		require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
795 		require(msg.value >= currentPrice, "Amount of Ether sent too small");
796 
797 		uint256 index = allTokens.length + 1;
798 
799 		_mint(msg.sender, index);
800 
801 		tokenTypes[index]        = _type;
802 		tokenTitles[index]       = _title;
803 		tokenDescriptions[index] = _description;
804 		specialQualities[index]  = _specialQuality;
805 		iptcKeywords[index]      = _iptcKeyword;
806 		tokenClasses[index]      = _tokenClass;
807 
808 		emit BoughtToken(msg.sender, index);
809 	  }
810 
811 	  /**
812 	   * @dev Returns all of the tokens that the user owns
813 	   * @return An array of token indices
814 	   */
815 	  function myTokens()
816 		external
817 		view
818 		returns (
819 		  uint256[]
820 		)
821 	  {
822 		return ownedTokens[msg.sender];
823 	  }
824 
825 	  /// @notice Returns all the relevant information about a specific token
826 	  /// @param _tokenId The ID of the token of interest
827 	  function viewTokenMeta(uint256 _tokenId)
828 		external
829 		view
830 		returns (
831 		  uint256 tokenType_,
832 		  string  specialQuality_,
833 		  string  tokenTitle_,
834 		  string  tokenDescription_,
835 		  string  iptcKeyword_,
836 		  string  tokenClass_
837 	  ) {
838 		  tokenType_        = tokenTypes[_tokenId];
839 		  tokenTitle_       = tokenTitles[_tokenId];
840 		  tokenDescription_ = tokenDescriptions[_tokenId];
841 		  specialQuality_   = specialQualities[_tokenId];
842 		  iptcKeyword_      = iptcKeywords[_tokenId];
843 		  tokenClass_       = tokenClasses[_tokenId];
844 	  }
845 
846 	  /// @notice Allows the owner of this contract to set the currentPrice for each token
847 	  function setCurrentPrice(uint256 newPrice)
848 		public
849 		onlyOwner
850 	  {
851 		  currentPrice = newPrice;
852 	  }
853 
854 	  /// @notice Returns the currentPrice for each token
855 	  function getCurrentPrice()
856 		external
857 		view
858 		returns (
859 		uint256 price
860 	  ) {
861 		  price = currentPrice;
862 	  }
863 	  /// @notice allows the owner of this contract to destroy the contract
864 	   function kill() public {
865 		  if(msg.sender == owner) selfdestruct(owner);
866 	   }  
867 	  
868 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
869 	  /**
870 	   * 0x780e9d63 ===
871 	   *   bytes4(keccak256('totalSupply()')) ^
872 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
873 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
874 	   */
875 
876 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
877 	  /**
878 	   * 0x5b5e139f ===
879 	   *   bytes4(keccak256('name()')) ^
880 	   *   bytes4(keccak256('symbol()')) ^
881 	   *   bytes4(keccak256('tokenURI(uint256)'))
882 	   */
883 
884 	  // Token name
885 	  string internal name_;
886 
887 	  // Token symbol
888 	  string internal symbol_;
889 
890 	  // Mapping from owner to list of owned token IDs
891 	  mapping(address => uint256[]) internal ownedTokens;
892 
893 	  // Mapping from token ID to index of the owner tokens list
894 	  mapping(uint256 => uint256) internal ownedTokensIndex;
895 
896 	  // Array with all token ids, used for enumeration
897 	  uint256[] internal allTokens;
898 
899 	  // Mapping from token id to position in the allTokens array
900 	  mapping(uint256 => uint256) internal allTokensIndex;
901 
902 	  // Optional mapping for token URIs
903 	  mapping(uint256 => string) internal tokenURIs;
904 
905 	  /**
906 	   * @dev Gets the token name
907 	   * @return string representing the token name
908 	   */
909 	  function name() external view returns (string) {
910 		return name_;
911 	  }
912 
913 	  /**
914 	   * @dev Gets the token symbol
915 	   * @return string representing the token symbol
916 	   */
917 	  function symbol() external view returns (string) {
918 		return symbol_;
919 	  }
920 
921 	  /**
922 	   * @dev Returns an URI for a given token ID
923 	   * Throws if the token ID does not exist. May return an empty string.
924 	   * @param _tokenId uint256 ID of the token to query
925 	   */
926 	  function tokenURI(uint256 _tokenId) public view returns (string) {
927 		require(exists(_tokenId));
928 		return tokenURIs[_tokenId];
929 	  }
930 
931 	  /**
932 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
933 	   * @param _owner address owning the tokens list to be accessed
934 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
935 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
936 	   */
937 	  function tokenOfOwnerByIndex(
938 		address _owner,
939 		uint256 _index
940 	  )
941 		public
942 		view
943 		returns (uint256)
944 	  {
945 		require(_index < balanceOf(_owner));
946 		return ownedTokens[_owner][_index];
947 	  }
948 
949 	  /**
950 	   * @dev Gets the total amount of tokens stored by the contract
951 	   * @return uint256 representing the total amount of tokens
952 	   */
953 	  function totalSupply() public view returns (uint256) {
954 		return allTokens.length;
955 	  }
956 
957 	  /**
958 	   * @dev Gets the token ID at a given index of all the tokens in this contract
959 	   * Reverts if the index is greater or equal to the total number of tokens
960 	   * @param _index uint256 representing the index to be accessed of the tokens list
961 	   * @return uint256 token ID at the given index of the tokens list
962 	   */
963 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
964 		require(_index < totalSupply());
965 		return allTokens[_index];
966 	  }
967 
968 	  /**
969 	   * @dev Internal function to set the token URI for a given token
970 	   * Reverts if the token ID does not exist
971 	   * @param _tokenId uint256 ID of the token to set its URI
972 	   * @param _uri string URI to assign
973 	   */
974 	  function _setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
975 		require(exists(_tokenId));
976 		tokenURIs[_tokenId] = _uri;
977 	  }
978 
979 	  /**
980 	   * @dev Internal function to add a token ID to the list of a given address
981 	   * @param _to address representing the new owner of the given token ID
982 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
983 	   */
984 	  function addTokenTo(address _to, uint256 _tokenId) internal {
985 		super.addTokenTo(_to, _tokenId);
986 		uint256 length = ownedTokens[_to].length;
987 		ownedTokens[_to].push(_tokenId);
988 		ownedTokensIndex[_tokenId] = length;
989 	  }
990 
991 	  /**
992 	   * @dev Internal function to remove a token ID from the list of a given address
993 	   * @param _from address representing the previous owner of the given token ID
994 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
995 	   */
996 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
997 		super.removeTokenFrom(_from, _tokenId);
998 
999 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
1000 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1001 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1002 
1003 		ownedTokens[_from][tokenIndex] = lastToken;
1004 		ownedTokens[_from][lastTokenIndex] = 0;
1005 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1006 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1007 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
1008 
1009 		ownedTokens[_from].length--;
1010 		ownedTokensIndex[_tokenId] = 0;
1011 		ownedTokensIndex[lastToken] = tokenIndex;
1012 	  }
1013 
1014 	  /**
1015 	   * @dev Internal function to mint a new token
1016 	   * Reverts if the given token ID already exists
1017 	   * @param _to address the beneficiary that will own the minted token
1018 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1019 	   */
1020 	  function _mint(address _to, uint256 _tokenId) internal {
1021 		super._mint(_to, _tokenId);
1022 
1023 		allTokensIndex[_tokenId] = allTokens.length;
1024 		allTokens.push(_tokenId);
1025 	  }
1026 	}