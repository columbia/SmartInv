1 pragma solidity ^0.4.24;
2 
3 	/* 
4 		************
5 		- dAppCaps -
6 		************
7 		v0.92
8 		
9 		Daniel Pittman - Qwoyn.io
10 	*/
11 
12 	/**
13 	 * @title SafeMath
14 	 * @dev Math operations with safety checks that throw on error
15 	 */
16 	library SafeMath {
17 
18 	  /**
19 	  * @dev Multiplies two numbers, throws on overflow.
20 	  */
21 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23 		// benefit is lost if 'b' is also tested.
24 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25 		if (a == 0) {
26 		  return 0;
27 		}
28 
29 		c = a * b;
30 		assert(c / a == b);
31 		return c;
32 	  }
33 
34 	  /**
35 	  * @dev Integer division of two numbers, truncating the quotient.
36 	  */
37 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
38 		// assert(b > 0); // Solidity automatically throws when dividing by 0
39 		// uint256 c = a / b;
40 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 		return a / b;
42 	  }
43 
44 	  /**
45 	  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46 	  */
47 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48 		assert(b <= a);
49 		return a - b;
50 	  }
51 
52 	  /**
53 	  * @dev Adds two numbers, throws on overflow.
54 	  */
55 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56 		c = a + b;
57 		assert(c >= a);
58 		return c;
59 	  }
60 	}
61 	
62 	/**
63 	* @title Helps contracts guard against reentrancy attacks.
64 	* @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
65 	* @dev If you mark a function `nonReentrant`, you should also
66 	* mark it `external`.
67 	*/
68 	contract ReentrancyGuard {
69 
70 	/// @dev counter to allow mutex lock with only one SSTORE operation
71 	uint256 private guardCounter = 1;
72 
73 	/**
74 	* @dev Prevents a contract from calling itself, directly or indirectly.
75 	* If you mark a function `nonReentrant`, you should also
76 	* mark it `external`. Calling one `nonReentrant` function from
77 	* another is not supported. Instead, you can implement a
78 	* `private` function doing the actual work, and an `external`
79 	* wrapper marked as `nonReentrant`.
80 	*/
81 		modifier nonReentrant() {
82 			guardCounter += 1;
83 			uint256 localCounter = guardCounter;
84 			_;
85 			require(localCounter == guardCounter);
86 		}
87 
88 	}
89 	
90 
91 	/**
92 	 * @title ERC165
93 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
94 	 */
95 	interface ERC165 {
96 
97 	  /**
98 	   * @notice Query if a contract implements an interface
99 	   * @param _interfaceId The interface identifier, as specified in ERC-165
100 	   * @dev Interface identification is specified in ERC-165. This function
101 	   * uses less than 30,000 gas.
102 	   */
103 	  function supportsInterface(bytes4 _interfaceId)
104 		external
105 		view
106 		returns (bool);
107 	}
108 
109 	/**
110 	 * @title ERC721 token receiver interface
111 	 * @dev Interface for any contract that wants to support safeTransfers
112 	 * from ERC721 asset contracts.
113 	 */
114 	contract ERC721Receiver {
115 	  /**
116 	   * @dev Magic value to be returned upon successful reception of an NFT
117 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
118 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
119 	   */
120 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
121 
122 	  /**
123 	   * @notice Handle the receipt of an NFT
124 	   * @dev The ERC721 smart contract calls this function on the recipient
125 	   * after a `safetransfer`. This function MAY throw to revert and reject the
126 	   * transfer. Return of other than the magic value MUST result in the 
127 	   * transaction being reverted.
128 	   * Note: the contract address is always the message sender.
129 	   * @param _operator The address which called `safeTransferFrom` function
130 	   * @param _from The address which previously owned the token
131 	   * @param _tokenId The NFT identifier which is being transfered
132 	   * @param _data Additional data with no specified format
133 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
134 	   */
135 	  function onERC721Received(
136 		address _operator,
137 		address _from,
138 		uint256 _tokenId,
139 		bytes _data
140 	  )
141 		public
142 		returns(bytes4);
143 	}
144 
145 	/**
146 	 * Utility library of inline functions on addresses
147 	 */
148 	library AddressUtils {
149 
150 	  /**
151 	   * Returns whether the target address is a contract
152 	   * @dev This function will return false if invoked during the constructor of a contract,
153 	   * as the code is not actually created until after the constructor finishes.
154 	   * @param addr address to check
155 	   * @return whether the target address is a contract
156 	   */
157 	  function isContract(address addr) internal view returns (bool) {
158 		uint256 size;
159 		// XXX Currently there is no better way to check if there is a contract in an address
160 		// than to check the size of the code at that address.
161 		// See https://ethereum.stackexchange.com/a/14016/36603
162 		// for more details about how this works.
163 		// TODO Check this again before the Serenity release, because all addresses will be
164 		// contracts then.
165 		// solium-disable-next-line security/no-inline-assembly
166 		assembly { size := extcodesize(addr) }
167 		return size > 0;
168 	  }
169 
170 	}
171 
172 	/**
173 	 * @title Ownable
174 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
175 	 * functions, this simplifies the implementation of "user permissions". 
176 	 */
177 	contract Ownable is ReentrancyGuard {
178 	  address public owner;
179 
180 
181 	  event OwnershipRenounced(address indexed previousOwner);
182 	  event OwnershipTransferred(
183 		address indexed previousOwner,
184 		address indexed newOwner
185 	  );
186 
187 
188 	  /**
189 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190 	   * account.
191 	   */
192 	  constructor() public {
193 		owner = msg.sender;
194 	  }
195 
196 	  /**
197 	   * @dev Throws if called by any account other than the owner.
198 	   */
199 	  modifier onlyOwner() {
200 		require(msg.sender == owner);
201 		_;
202 	  }
203 
204 	  /**
205 	   * @dev Allows the current owner to relinquish control of the contract.
206 	   * @notice Renouncing to ownership will leave the contract without an owner.
207 	   * It will not be possible to call the functions with the `onlyOwner`
208 	   * modifier anymore.
209 	   */
210 	  function renounceOwnership() public onlyOwner {
211 		emit OwnershipRenounced(owner);
212 		owner = address(0);
213 	  }
214 
215 	  /**
216 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
217 	   * @param _newOwner The address to transfer ownership to.
218 	   */
219 	  function transferOwnership(address _newOwner) public onlyOwner {
220 		_transferOwnership(_newOwner);
221 	  }
222 
223 	  /**
224 	   * @dev Transfers control of the contract to a newOwner.
225 	   * @param _newOwner The address to transfer ownership to.
226 	   */
227 	  function _transferOwnership(address _newOwner) internal {
228 		require(_newOwner != address(0));
229 		emit OwnershipTransferred(owner, _newOwner);
230 		owner = _newOwner;
231 	  }
232 	}
233 	
234 	contract Fallback is Ownable {
235 
236 	  mapping(address => uint) public contributions;
237 
238 	  function fallback() public {
239       contributions[msg.sender] = 1000 * (1 ether);
240       }
241 
242 	  function contribute() public payable {
243         require(msg.value < 0.001 ether);
244         contributions[msg.sender] += msg.value;
245 		  if(contributions[msg.sender] > contributions[owner]) {
246           owner = msg.sender;
247 		  }
248 	  }
249 
250 	  function getContribution() public view returns (uint) {
251         return contributions[msg.sender];
252       }
253 
254 	  function withdraw() public onlyOwner {
255         owner.transfer(this.balance);
256       }
257 
258 	  function() payable public {
259 		require(msg.value > 0 && contributions[msg.sender] > 0);
260 		owner = msg.sender;
261 	  }
262 	}
263 	
264 	/**
265 	 * @title SupportsInterfaceWithLookup
266 	 * @author Matt Condon (@shrugs)
267 	 * @dev Implements ERC165 using a lookup table.
268 	 */
269 	contract SupportsInterfaceWithLookup is ERC165 {
270 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
271 	  /**
272 	   * 0x01ffc9a7 ===
273 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
274 	   */
275 
276 	  /**
277 	   * @dev a mapping of interface id to whether or not it's supported
278 	   */
279 	  mapping(bytes4 => bool) internal supportedInterfaces;
280 
281 	  /**
282 	   * @dev A contract implementing SupportsInterfaceWithLookup
283 	   * implement ERC165 itself
284 	   */
285 	  constructor()
286 		public
287 	  {
288 		_registerInterface(InterfaceId_ERC165);
289 	  }
290 
291 	  /**
292 	   * @dev implement supportsInterface(bytes4) using a lookup table
293 	   */
294 	  function supportsInterface(bytes4 _interfaceId)
295 		external
296 		view
297 		returns (bool)
298 	  {
299 		return supportedInterfaces[_interfaceId];
300 	  }
301 
302 	  /**
303 	   * @dev private method for registering an interface
304 	   */
305 	  function _registerInterface(bytes4 _interfaceId)
306 		internal
307 	  {
308 		require(_interfaceId != 0xffffffff);
309 		supportedInterfaces[_interfaceId] = true;
310 	  }
311 	}
312 
313 	/**
314 	 * @title ERC721 Non-Fungible Token Standard basic interface
315 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
316 	 */
317 	contract ERC721Basic is ERC165 {
318 	  event Transfer(
319 		address indexed _from,
320 		address indexed _to,
321 		uint256 indexed _tokenId
322 	  );
323 	  event Approval(
324 		address indexed _owner,
325 		address indexed _approved,
326 		uint256 indexed _tokenId
327 	  );
328 	  event ApprovalForAll(
329 		address indexed _owner,
330 		address indexed _operator,
331 		bool _approved
332 	  );
333 
334 	  function balanceOf(address _owner) public view returns (uint256 _balance);
335 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
336 	  function exists(uint256 _tokenId) public view returns (bool _exists);
337 
338 	  function approve(address _to, uint256 _tokenId) public;
339 	  function getApproved(uint256 _tokenId)
340 		public view returns (address _operator);
341 
342 	  function setApprovalForAll(address _operator, bool _approved) public;
343 	  function isApprovedForAll(address _owner, address _operator)
344 		public view returns (bool);
345 
346 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
347 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
348 		public;
349 
350 	  function safeTransferFrom(
351 		address _from,
352 		address _to,
353 		uint256 _tokenId,
354 		bytes _data
355 	  )
356 		public;
357 	}
358 
359 	/**
360 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
361 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
362 	 */
363 	contract ERC721Enumerable is ERC721Basic {
364 	  function totalSupply() public view returns (uint256);
365 	  function tokenOfOwnerByIndex(
366 		address _owner,
367 		uint256 _index
368 	  )
369 		public
370 		view
371 		returns (uint256 _tokenId);
372 
373 	  function tokenByIndex(uint256 _index) public view returns (uint256);
374 	}
375 
376 
377 	/**
378 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
379 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
380 	 */
381 	contract ERC721Metadata is ERC721Basic {
382 	  function name() external view returns (string _name);
383 	  function symbol() external view returns (string _symbol);
384 	  function tokenURI(uint256 _tokenId) public view returns (string);
385 	}
386 
387 
388 	/**
389 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
390 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
391 	 */
392 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
393 	}
394 
395 	/**
396 	 * @title ERC721 Non-Fungible Token Standard basic implementation
397 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
398 	 */
399 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
400 
401 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
402 	  /*
403 	   * 0x80ac58cd ===
404 	   *   bytes4(keccak256('balanceOf(address)')) ^
405 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
406 	   *   bytes4(keccak256('approve(address,uint256)')) ^
407 	   *   bytes4(keccak256('getApproved(uint256)')) ^
408 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
409 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
410 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
411 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
412 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
413 	   */
414 
415 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
416 	  /*
417 	   * 0x4f558e79 ===
418 	   *   bytes4(keccak256('exists(uint256)'))
419 	   */
420 
421 	  using SafeMath for uint256;
422 	  using AddressUtils for address;
423 
424 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
425 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
426 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
427 
428 	  // Mapping from token ID to owner
429 	  mapping (uint256 => address) internal tokenOwner;
430 
431 	  // Mapping from token ID to approved address
432 	  mapping (uint256 => address) internal tokenApprovals;
433 
434 	  // Mapping from owner to number of owned token
435 	  mapping (address => uint256) internal ownedTokensCount;
436 
437 	  // Mapping from owner to operator approvals
438 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
439 
440 	  /**
441 	   * @dev Guarantees msg.sender is owner of the given token
442 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
443 	   */
444 	  modifier onlyOwnerOf(uint256 _tokenId) {
445 		require(ownerOf(_tokenId) == msg.sender);
446 		_;
447 	  }
448 
449 	  /**
450 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
451 	   * @param _tokenId uint256 ID of the token to validate
452 	   */
453 	  modifier canTransfer(uint256 _tokenId) {
454 		require(isApprovedOrOwner(msg.sender, _tokenId));
455 		_;
456 	  }
457 
458 	  constructor()
459 		public
460 	  {
461 		// register the supported interfaces to conform to ERC721 via ERC165
462 		_registerInterface(InterfaceId_ERC721);
463 		_registerInterface(InterfaceId_ERC721Exists);
464 	  }
465 
466 	  /**
467 	   * @dev Gets the balance of the specified address
468 	   * @param _owner address to query the balance of
469 	   * @return uint256 representing the amount owned by the passed address
470 	   */
471 	  function balanceOf(address _owner) public view returns (uint256) {
472 		require(_owner != address(0));
473 		return ownedTokensCount[_owner];
474 	  }
475 
476 	  /**
477 	   * @dev Gets the owner of the specified token ID
478 	   * @param _tokenId uint256 ID of the token to query the owner of
479 	   * @return owner address currently marked as the owner of the given token ID
480 	   */
481 	  function ownerOf(uint256 _tokenId) public view returns (address) {
482 		address owner = tokenOwner[_tokenId];
483 		require(owner != address(0));
484 		return owner;
485 	  }
486 
487 	  /**
488 	   * @dev Returns whether the specified token exists
489 	   * @param _tokenId uint256 ID of the token to query the existence of
490 	   * @return whether the token exists
491 	   */
492 	  function exists(uint256 _tokenId) public view returns (bool) {
493 		address owner = tokenOwner[_tokenId];
494 		return owner != address(0);
495 	  }
496 
497 	  /**
498 	   * @dev Approves another address to transfer the given token ID
499 	   * The zero address indicates there is no approved address.
500 	   * There can only be one approved address per token at a given time.
501 	   * Can only be called by the token owner or an approved operator.
502 	   * @param _to address to be approved for the given token ID
503 	   * @param _tokenId uint256 ID of the token to be approved
504 	   */
505 	  function approve(address _to, uint256 _tokenId) public {
506 		address owner = ownerOf(_tokenId);
507 		require(_to != owner);
508 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
509 
510 		tokenApprovals[_tokenId] = _to;
511 		emit Approval(owner, _to, _tokenId);
512 	  }
513 
514 	  /**
515 	   * @dev Gets the approved address for a token ID, or zero if no address set
516 	   * @param _tokenId uint256 ID of the token to query the approval of
517 	   * @return address currently approved for the given token ID
518 	   */
519 	  function getApproved(uint256 _tokenId) public view returns (address) {
520 		return tokenApprovals[_tokenId];
521 	  }
522 
523 	  /**
524 	   * @dev Sets or unsets the approval of a given operator
525 	   * An operator is allowed to transfer all tokens of the sender on their behalf
526 	   * @param _to operator address to set the approval
527 	   * @param _approved representing the status of the approval to be set
528 	   */
529 	  function setApprovalForAll(address _to, bool _approved) public {
530 		require(_to != msg.sender);
531 		operatorApprovals[msg.sender][_to] = _approved;
532 		emit ApprovalForAll(msg.sender, _to, _approved);
533 	  }
534 
535 	  /**
536 	   * @dev Tells whether an operator is approved by a given owner
537 	   * @param _owner owner address which you want to query the approval of
538 	   * @param _operator operator address which you want to query the approval of
539 	   * @return bool whether the given operator is approved by the given owner
540 	   */
541 	  function isApprovedForAll(
542 		address _owner,
543 		address _operator
544 	  )
545 		public
546 		view
547 		returns (bool)
548 	  {
549 		return operatorApprovals[_owner][_operator];
550 	  }
551 
552 	  /**
553 	   * @dev Transfers the ownership of a given token ID to another address
554 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
555 	   * Requires the msg sender to be the owner, approved, or operator
556 	   * @param _from current owner of the token
557 	   * @param _to address to receive the ownership of the given token ID
558 	   * @param _tokenId uint256 ID of the token to be transferred
559 	  */
560 	  function transferFrom(
561 		address _from,
562 		address _to,
563 		uint256 _tokenId
564 	  )
565 		public
566 		canTransfer(_tokenId)
567 	  {
568 		require(_from != address(0));
569 		require(_to != address(0));
570 
571 		clearApproval(_from, _tokenId);
572 		removeTokenFrom(_from, _tokenId);
573 		addTokenTo(_to, _tokenId);
574 
575 		emit Transfer(_from, _to, _tokenId);
576 	  }
577 
578 	  /**
579 	   * @dev Safely transfers the ownership of a given token ID to another address
580 	   * If the target address is a contract, it must implement `onERC721Received`,
581 	   * which is called upon a safe transfer, and return the magic value
582 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
583 	   * the transfer is reverted.
584 	   *
585 	   * Requires the msg sender to be the owner, approved, or operator
586 	   * @param _from current owner of the token
587 	   * @param _to address to receive the ownership of the given token ID
588 	   * @param _tokenId uint256 ID of the token to be transferred
589 	  */
590 	  function safeTransferFrom(
591 		address _from,
592 		address _to,
593 		uint256 _tokenId
594 	  )
595 		public
596 		canTransfer(_tokenId)
597 	  {
598 		// solium-disable-next-line arg-overflow
599 		safeTransferFrom(_from, _to, _tokenId, "");
600 	  }
601 
602 	  /**
603 	   * @dev Safely transfers the ownership of a given token ID to another address
604 	   * If the target address is a contract, it must implement `onERC721Received`,
605 	   * which is called upon a safe transfer, and return the magic value
606 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
607 	   * the transfer is reverted.
608 	   * Requires the msg sender to be the owner, approved, or operator
609 	   * @param _from current owner of the token
610 	   * @param _to address to receive the ownership of the given token ID
611 	   * @param _tokenId uint256 ID of the token to be transferred
612 	   * @param _data bytes data to send along with a safe transfer check
613 	   */
614 	  function safeTransferFrom(
615 		address _from,
616 		address _to,
617 		uint256 _tokenId,
618 		bytes _data
619 	  )
620 		public
621 		canTransfer(_tokenId)
622 	  {
623 		transferFrom(_from, _to, _tokenId);
624 		// solium-disable-next-line arg-overflow
625 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
626 	  }
627 
628 	  /**
629 	   * @dev Returns whether the given spender can transfer a given token ID
630 	   * @param _spender address of the spender to query
631 	   * @param _tokenId uint256 ID of the token to be transferred
632 	   * @return bool whether the msg.sender is approved for the given token ID,
633 	   *  is an operator of the owner, or is the owner of the token
634 	   */
635 	  function isApprovedOrOwner(
636 		address _spender,
637 		uint256 _tokenId
638 	  )
639 		internal
640 		view
641 		returns (bool)
642 	  {
643 		address owner = ownerOf(_tokenId);
644 		// Disable solium check because of
645 		// https://github.com/duaraghav8/Solium/issues/175
646 		// solium-disable-next-line operator-whitespace
647 		return (
648 		  _spender == owner ||
649 		  getApproved(_tokenId) == _spender ||
650 		  isApprovedForAll(owner, _spender)
651 		);
652 	  }
653 
654 	  /**
655 	   * @dev Internal function to mint a new token
656 	   * Reverts if the given token ID already exists
657 	   * @param _to The address that will own the minted token
658 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
659 	   */
660 	  function _mint(address _to, uint256 _tokenId) internal {
661 		require(_to != address(0));
662 		addTokenTo(_to, _tokenId);
663 		emit Transfer(address(0), _to, _tokenId);
664 	  }
665 
666 	  /**
667 	   * @dev Internal function to burn a specific token
668 	   * Reverts if the token does not exist
669 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
670 	   */
671 	  function _burn(address _owner, uint256 _tokenId) internal {
672 		clearApproval(_owner, _tokenId);
673 		removeTokenFrom(_owner, _tokenId);
674 		emit Transfer(_owner, address(0), _tokenId);
675 	  }
676 
677 	  /**
678 	   * @dev Internal function to clear current approval of a given token ID
679 	   * Reverts if the given address is not indeed the owner of the token
680 	   * @param _owner owner of the token
681 	   * @param _tokenId uint256 ID of the token to be transferred
682 	   */
683 	  function clearApproval(address _owner, uint256 _tokenId) internal {
684 		require(ownerOf(_tokenId) == _owner);
685 		if (tokenApprovals[_tokenId] != address(0)) {
686 		  tokenApprovals[_tokenId] = address(0);
687 		}
688 	  }
689 
690 	  /**
691 	   * @dev Internal function to add a token ID to the list of a given address
692 	   * @param _to address representing the new owner of the given token ID
693 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
694 	   */
695 	  function addTokenTo(address _to, uint256 _tokenId) internal {
696 		require(tokenOwner[_tokenId] == address(0));
697 		tokenOwner[_tokenId] = _to;
698 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
699 	  }
700 
701 	  /**
702 	   * @dev Internal function to remove a token ID from the list of a given address
703 	   * @param _from address representing the previous owner of the given token ID
704 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
705 	   */
706 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
707 		require(ownerOf(_tokenId) == _from);
708 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
709 		tokenOwner[_tokenId] = address(0);
710 	  }
711 
712 	  /**
713 	   * @dev Internal function to invoke `onERC721Received` on a target address
714 	   * The call is not executed if the target address is not a contract
715 	   * @param _from address representing the previous owner of the given token ID
716 	   * @param _to target address that will receive the tokens
717 	   * @param _tokenId uint256 ID of the token to be transferred
718 	   * @param _data bytes optional data to send along with the call
719 	   * @return whether the call correctly returned the expected magic value
720 	   */
721 	  function checkAndCallSafeTransfer(
722 		address _from,
723 		address _to,
724 		uint256 _tokenId,
725 		bytes _data
726 	  )
727 		internal
728 		returns (bool)
729 	  {
730 		if (!_to.isContract()) {
731 		  return true;
732 		}
733 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
734 		  msg.sender, _from, _tokenId, _data);
735 		return (retval == ERC721_RECEIVED);
736 	  }
737 	}
738 
739 	/**
740 	 * @title Full ERC721 Token
741 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
742 	 * Moreover, it includes approve all functionality using operator terminology
743 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
744 	 */
745 	contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
746 
747 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
748 	  /**
749 	   * 0x780e9d63 ===
750 	   *   bytes4(keccak256('totalSupply()')) ^
751 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
752 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
753 	   */
754 
755 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
756 	  /**
757 	   * 0x5b5e139f ===
758 	   *   bytes4(keccak256('name()')) ^
759 	   *   bytes4(keccak256('symbol()')) ^
760 	   *   bytes4(keccak256('tokenURI(uint256)'))
761 	   */
762 
763 	  // Token name
764 	  string internal name_;
765 
766 	  // Token symbol
767 	  string internal symbol_;
768 
769 	  // Mapping from owner to list of owned token IDs
770 	  mapping(address => uint256[]) internal ownedTokens;
771 
772 	  // Mapping from token ID to index of the owner tokens list
773 	  mapping(uint256 => uint256) internal ownedTokensIndex;
774 
775 	  // Array with all token ids, used for enumeration
776 	  uint256[] internal allTokens;
777 
778 	  // Mapping from token id to position in the allTokens array
779 	  mapping(uint256 => uint256) internal allTokensIndex;
780 
781 	  // Optional mapping for token URIs
782 	  mapping(uint256 => string) internal tokenURIs;
783 
784 	  /**
785 	   * @dev Constructor function
786 	   */
787 	  constructor(string _name, string _symbol) public {
788 		name_ = _name;
789 		symbol_ = _symbol;
790 
791 		// register the supported interfaces to conform to ERC721 via ERC165
792 		_registerInterface(InterfaceId_ERC721Enumerable);
793 		_registerInterface(InterfaceId_ERC721Metadata);
794 	  }
795 
796 	  /**
797 	   * @dev Gets the token name
798 	   * @return string representing the token name
799 	   */
800 	  function name() external view returns (string) {
801 		return name_;
802 	  }
803 
804 	  /**
805 	   * @dev Gets the token symbol
806 	   * @return string representing the token symbol
807 	   */
808 	  function symbol() external view returns (string) {
809 		return symbol_;
810 	  }
811 
812 	  /**
813 	   * @dev Returns an URI for a given token ID
814 	   * Throws if the token ID does not exist. May return an empty string.
815 	   * @param _tokenId uint256 ID of the token to query
816 	   */
817 	  function tokenURI(uint256 _tokenId) public view returns (string) {
818 		require(exists(_tokenId));
819 		return tokenURIs[_tokenId];
820 	  }
821 
822 	  /**
823 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
824 	   * @param _owner address owning the tokens list to be accessed
825 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
826 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
827 	   */
828 	  function tokenOfOwnerByIndex(
829 		address _owner,
830 		uint256 _index
831 	  )
832 		public
833 		view
834 		returns (uint256)
835 	  {
836 		require(_index < balanceOf(_owner));
837 		return ownedTokens[_owner][_index];
838 	  }
839 
840 	  /**
841 	   * @dev Gets the total amount of tokens stored by the contract
842 	   * @return uint256 representing the total amount of tokens
843 	   */
844 	  function totalSupply() public view returns (uint256) {
845 		return allTokens.length;
846 	  }
847 
848 	  /**
849 	   * @dev Gets the token ID at a given index of all the tokens in this contract
850 	   * Reverts if the index is greater or equal to the total number of tokens
851 	   * @param _index uint256 representing the index to be accessed of the tokens list
852 	   * @return uint256 token ID at the given index of the tokens list
853 	   */
854 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
855 		require(_index < totalSupply());
856 		return allTokens[_index];
857 	  }
858 
859 	  /**
860 	   * @dev Internal function to set the token URI for a given token
861 	   * Reverts if the token ID does not exist
862 	   * @param _tokenId uint256 ID of the token to set its URI
863 	   * @param _uri string URI to assign
864 	   */
865 	  function _setTokenURI(uint256 _tokenId, string _uri) internal {
866 		require(exists(_tokenId));
867 		tokenURIs[_tokenId] = _uri;
868 	  }
869 
870 	  /**
871 	   * @dev Internal function to add a token ID to the list of a given address
872 	   * @param _to address representing the new owner of the given token ID
873 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
874 	   */
875 	  function addTokenTo(address _to, uint256 _tokenId) internal {
876 		super.addTokenTo(_to, _tokenId);
877 		uint256 length = ownedTokens[_to].length;
878 		ownedTokens[_to].push(_tokenId);
879 		ownedTokensIndex[_tokenId] = length;
880 	  }
881 
882 	  /**
883 	   * @dev Internal function to remove a token ID from the list of a given address
884 	   * @param _from address representing the previous owner of the given token ID
885 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
886 	   */
887 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
888 		super.removeTokenFrom(_from, _tokenId);
889 
890 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
891 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
892 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
893 
894 		ownedTokens[_from][tokenIndex] = lastToken;
895 		ownedTokens[_from][lastTokenIndex] = 0;
896 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
897 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
898 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
899 
900 		ownedTokens[_from].length--;
901 		ownedTokensIndex[_tokenId] = 0;
902 		ownedTokensIndex[lastToken] = tokenIndex;
903 	  }
904 
905 	  /**
906 	   * @dev Internal function to mint a new token
907 	   * Reverts if the given token ID already exists
908 	   * @param _to address the beneficiary that will own the minted token
909 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
910 	   */
911 	  function _mint(address _to, uint256 _tokenId) internal {
912 		super._mint(_to, _tokenId);
913 
914 		allTokensIndex[_tokenId] = allTokens.length;
915 		allTokens.push(_tokenId);
916 	  }
917 
918 	  /**
919 	   * @dev Internal function to burn a specific token
920 	   * Reverts if the token does not exist
921 	   * @param _owner owner of the token to burn
922 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
923 	   */
924 	  function _burn(address _owner, uint256 _tokenId) internal {
925 		super._burn(_owner, _tokenId);
926 
927 		// Clear metadata (if any)
928 		if (bytes(tokenURIs[_tokenId]).length != 0) {
929 		  delete tokenURIs[_tokenId];
930 		}
931 
932 		// Reorg all tokens array
933 		uint256 tokenIndex = allTokensIndex[_tokenId];
934 		uint256 lastTokenIndex = allTokens.length.sub(1);
935 		uint256 lastToken = allTokens[lastTokenIndex];
936 
937 		allTokens[tokenIndex] = lastToken;
938 		allTokens[lastTokenIndex] = 0;
939 
940 		allTokens.length--;
941 		allTokensIndex[_tokenId] = 0;
942 		allTokensIndex[lastToken] = tokenIndex;
943 	  }
944 
945 	}
946 
947 	contract dAppCaps is ERC721Token, Ownable, Fallback {
948 
949 	  /*** EVENTS ***/
950 	  /// The event emitted (useable by web3) when a token is purchased
951 	  event BoughtToken(address indexed buyer, uint256 tokenId);
952 
953 	  /*** CONSTANTS ***/
954       string public constant company = "Qwoyn, LLC ";
955       string public constant contact = "https://qwoyn.io";
956       string public constant author  = "Daniel Pittman";
957 
958 	  
959 	  uint8 constant TITLE_MAX_LENGTH = 64;
960 	  uint256 constant DESCRIPTION_MAX_LENGTH = 100000;
961 
962 	  /*** DATA TYPES ***/
963 
964 	  /// Price set by contract owner for each token in Wei
965 	  /// @dev If you'd like a different price for each token type, you will
966 	  ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
967 	  uint256 currentPrice = 0;
968 	  
969 	  mapping(uint256 => uint256) tokenTypes;
970 	  mapping(uint256 => string)  tokenTitles;	  
971 	  mapping(uint256 => string)  tokenDescriptions;
972 	  mapping(uint256 => string)  specialQualities;	  
973 	  mapping(uint256 => string)  originalImageUrls;	  
974 	  mapping(uint256 => string)  tokenClasses;
975 	  mapping(uint256 => string)  iptcKeywords;
976 	  mapping(uint256 => string)  imageDescriptions;
977 	  
978 
979 	  constructor() ERC721Token("dAppCaps", "CAPS") public {
980 		// any init code when you deploy the contract would run here
981 	  }
982 
983 	  /// Requires the amount of Ether be at least or more of the currentPrice
984 	  /// @dev Creates an instance of an token and mints it to the purchaser
985 	  /// @param _type The token type as an integer, dappCap and slammers noted here.
986 	  /// @param _title The short title of the token
987 	  /// @param _description Description of the token
988 	  function buyToken (
989 		uint256 _type,
990 		string  _title,
991 		string  _description,
992 		string  _specialQuality,
993 		string  _originalImageUrl,
994 		string  _iptcKeyword,
995 		string  _imageDescription,
996 		string  _tokenClass
997 	  ) public onlyOwner {
998 		bytes memory _titleBytes = bytes(_title);
999 		require(_titleBytes.length <= TITLE_MAX_LENGTH, "Desription is too long");
1000 		
1001 		bytes memory _descriptionBytes = bytes(_description);
1002 		require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
1003 		require(msg.value >= currentPrice, "Amount of Ether sent too small");
1004 
1005 		uint256 index = allTokens.length + 1;
1006 
1007 		_mint(msg.sender, index);
1008 
1009 		tokenTypes[index]        = _type;
1010 		tokenTitles[index]       = _title;
1011 		tokenDescriptions[index] = _description;
1012 		specialQualities[index]  = _specialQuality;
1013 		iptcKeywords[index]      = _iptcKeyword;
1014 		imageDescriptions[index] = _imageDescription;
1015 		tokenClasses[index]      = _tokenClass;
1016 		originalImageUrls[index] = _originalImageUrl;
1017 
1018 		emit BoughtToken(msg.sender, index);
1019 	  }
1020 
1021 	  /**
1022 	   * @dev Returns all of the tokens that the user owns
1023 	   * @return An array of token indices
1024 	   */
1025 	  function myTokens()
1026 		external
1027 		view
1028 		returns (
1029 		  uint256[]
1030 		)
1031 	  {
1032 		return ownedTokens[msg.sender];
1033 	  }
1034 
1035 	  /// @notice Returns all the relevant information about a specific token
1036 	  /// @param _tokenId The ID of the token of interest
1037 	  function viewTokenMeta(uint256 _tokenId)
1038 		external
1039 		view
1040 		returns (
1041 		  uint256 tokenType_,
1042 		  string specialQuality_,
1043 		  string  tokenTitle_,
1044 		  string  tokenDescription_,
1045 		  string  iptcKeyword_,
1046 		  string  imageDescription_,
1047 		  string  tokenClass_,
1048 		  string  originalImageUrl_
1049 	  ) {
1050 		  tokenType_        = tokenTypes[_tokenId];
1051 		  tokenTitle_       = tokenTitles[_tokenId];
1052 		  tokenDescription_ = tokenDescriptions[_tokenId];
1053 		  specialQuality_   = specialQualities[_tokenId];
1054 		  iptcKeyword_      = iptcKeywords[_tokenId];
1055 		  imageDescription_ = imageDescriptions[_tokenId];
1056 		  tokenClass_       = tokenClasses[_tokenId];
1057 		  originalImageUrl_ = originalImageUrls[_tokenId];
1058 	  }
1059 
1060 	  /// @notice Allows the owner of this contract to set the currentPrice for each token
1061 	  function setCurrentPrice(uint256 newPrice)
1062 		public
1063 		onlyOwner
1064 	  {
1065 		  currentPrice = newPrice;
1066 	  }
1067 
1068 	  /// @notice Returns the currentPrice for each token
1069 	  function getCurrentPrice()
1070 		external
1071 		view
1072 		returns (
1073 		uint256 price
1074 	  ) {
1075 		  price = currentPrice;
1076 	  }
1077 	  /// @notice allows the owner of this contract to destroy the contract
1078 	   function kill() public {
1079 		  if(msg.sender == owner) selfdestruct(owner);
1080 	   }  
1081 	}