1 pragma solidity ^0.4.24;
2 	
3 	/*
4 	
5 	Created By Daniel Pittman
6 	Qwoyn.io
7 	2018
8 	
9 	CryptoCaps A smartcontract that mints unique bottle caps and 
10 	slammers in order to play the infamous game Pogs on the blockchain!
11 	
12 	ERC721
13 	
14 	*/
15 	
16 	
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
69 	 * @title ERC165
70 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
71 	 */
72 	interface ERC165 {
73 
74 	  /**
75 	   * @notice Query if a contract implements an interface
76 	   * @param _interfaceId The interface identifier, as specified in ERC-165
77 	   * @dev Interface identification is specified in ERC-165. This function
78 	   * uses less than 30,000 gas.
79 	   */
80 	  function supportsInterface(bytes4 _interfaceId)
81 		external
82 		view
83 		returns (bool);
84 	}
85 
86 	/**
87 	 * @title ERC721 token receiver interface
88 	 * @dev Interface for any contract that wants to support safeTransfers
89 	 * from ERC721 asset contracts.
90 	 */
91 	contract ERC721Receiver {
92 	  /**
93 	   * @dev Magic value to be returned upon successful reception of an NFT
94 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
95 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
96 	   */
97 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
98 
99 	  /**
100 	   * @notice Handle the receipt of an NFT
101 	   * @dev The ERC721 smart contract calls this function on the recipient
102 	   * after a `safetransfer`. This function MAY throw to revert and reject the
103 	   * transfer. Return of other than the magic value MUST result in the 
104 	   * transaction being reverted.
105 	   * Note: the contract address is always the message sender.
106 	   * @param _operator The address which called `safeTransferFrom` function
107 	   * @param _from The address which previously owned the token
108 	   * @param _tokenId The NFT identifier which is being transfered
109 	   * @param _data Additional data with no specified format
110 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
111 	   */
112 	  function onERC721Received(
113 		address _operator,
114 		address _from,
115 		uint256 _tokenId,
116 		bytes _data
117 	  )
118 		public
119 		returns(bytes4);
120 	}
121 
122 	/**
123 	 * Utility library of inline functions on addresses
124 	 */
125 	library AddressUtils {
126 
127 	  /**
128 	   * Returns whether the target address is a contract
129 	   * @dev This function will return false if invoked during the constructor of a contract,
130 	   * as the code is not actually created until after the constructor finishes.
131 	   * @param addr address to check
132 	   * @return whether the target address is a contract
133 	   */
134 	  function isContract(address addr) internal view returns (bool) {
135 		uint256 size;
136 		// XXX Currently there is no better way to check if there is a contract in an address
137 		// than to check the size of the code at that address.
138 		// See https://ethereum.stackexchange.com/a/14016/36603
139 		// for more details about how this works.
140 		// TODO Check this again before the Serenity release, because all addresses will be
141 		// contracts then.
142 		// solium-disable-next-line security/no-inline-assembly
143 		assembly { size := extcodesize(addr) }
144 		return size > 0;
145 	  }
146 
147 	}
148 
149 	/**
150 	 * @title Ownable
151 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
152 	 * functions, this simplifies the implementation of "user permissions".
153 	 */
154 	contract Ownable {
155 	  address public owner;
156 
157 
158 	  event OwnershipRenounced(address indexed previousOwner);
159 	  event OwnershipTransferred(
160 		address indexed previousOwner,
161 		address indexed newOwner
162 	  );
163 
164 
165 	  /**
166 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167 	   * account.
168 	   */
169 	  constructor() public {
170 		owner = msg.sender;
171 	  }
172 
173 	  /**
174 	   * @dev Throws if called by any account other than the owner.
175 	   */
176 	  modifier onlyOwner() {
177 		require(msg.sender == owner);
178 		_;
179 	  }
180 
181 	  /**
182 	   * @dev Allows the current owner to relinquish control of the contract.
183 	   * @notice Renouncing to ownership will leave the contract without an owner.
184 	   * It will not be possible to call the functions with the `onlyOwner`
185 	   * modifier anymore.
186 	   */
187 	  function renounceOwnership() public onlyOwner {
188 		emit OwnershipRenounced(owner);
189 		owner = address(0);
190 	  }
191 
192 	  /**
193 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
194 	   * @param _newOwner The address to transfer ownership to.
195 	   */
196 	  function transferOwnership(address _newOwner) public onlyOwner {
197 		_transferOwnership(_newOwner);
198 	  }
199 
200 	  /**
201 	   * @dev Transfers control of the contract to a newOwner.
202 	   * @param _newOwner The address to transfer ownership to.
203 	   */
204 	  function _transferOwnership(address _newOwner) internal {
205 		require(_newOwner != address(0));
206 		emit OwnershipTransferred(owner, _newOwner);
207 		owner = _newOwner;
208 	  }
209 	}
210 
211 	/**
212 	 * @title SupportsInterfaceWithLookup
213 	 * @author Matt Condon (@shrugs)
214 	 * @dev Implements ERC165 using a lookup table.
215 	 */
216 	contract SupportsInterfaceWithLookup is ERC165 {
217 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
218 	  /**
219 	   * 0x01ffc9a7 ===
220 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
221 	   */
222 
223 	  /**
224 	   * @dev a mapping of interface id to whether or not it's supported
225 	   */
226 	  mapping(bytes4 => bool) internal supportedInterfaces;
227 
228 	  /**
229 	   * @dev A contract implementing SupportsInterfaceWithLookup
230 	   * implement ERC165 itself
231 	   */
232 	  constructor()
233 		public
234 	  {
235 		_registerInterface(InterfaceId_ERC165);
236 	  }
237 
238 	  /**
239 	   * @dev implement supportsInterface(bytes4) using a lookup table
240 	   */
241 	  function supportsInterface(bytes4 _interfaceId)
242 		external
243 		view
244 		returns (bool)
245 	  {
246 		return supportedInterfaces[_interfaceId];
247 	  }
248 
249 	  /**
250 	   * @dev private method for registering an interface
251 	   */
252 	  function _registerInterface(bytes4 _interfaceId)
253 		internal
254 	  {
255 		require(_interfaceId != 0xffffffff);
256 		supportedInterfaces[_interfaceId] = true;
257 	  }
258 	}
259 
260 	/**
261 	 * @title ERC721 Non-Fungible Token Standard basic interface
262 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
263 	 */
264 	contract ERC721Basic is ERC165 {
265 	  event Transfer(
266 		address indexed _from,
267 		address indexed _to,
268 		uint256 indexed _tokenId
269 	  );
270 	  event Approval(
271 		address indexed _owner,
272 		address indexed _approved,
273 		uint256 indexed _tokenId
274 	  );
275 	  event ApprovalForAll(
276 		address indexed _owner,
277 		address indexed _operator,
278 		bool _approved
279 	  );
280 
281 	  function balanceOf(address _owner) public view returns (uint256 _balance);
282 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
283 	  function exists(uint256 _tokenId) public view returns (bool _exists);
284 
285 	  function approve(address _to, uint256 _tokenId) public;
286 	  function getApproved(uint256 _tokenId)
287 		public view returns (address _operator);
288 
289 	  function setApprovalForAll(address _operator, bool _approved) public;
290 	  function isApprovedForAll(address _owner, address _operator)
291 		public view returns (bool);
292 
293 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
294 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
295 		public;
296 
297 	  function safeTransferFrom(
298 		address _from,
299 		address _to,
300 		uint256 _tokenId,
301 		bytes _data
302 	  )
303 		public;
304 	}
305 
306 	/**
307 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
308 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
309 	 */
310 	contract ERC721Enumerable is ERC721Basic {
311 	  function totalSupply() public view returns (uint256);
312 	  function tokenOfOwnerByIndex(
313 		address _owner,
314 		uint256 _index
315 	  )
316 		public
317 		view
318 		returns (uint256 _tokenId);
319 
320 	  function tokenByIndex(uint256 _index) public view returns (uint256);
321 	}
322 
323 
324 	/**
325 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
326 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
327 	 */
328 	contract ERC721Metadata is ERC721Basic {
329 	  function name() external view returns (string _name);
330 	  function symbol() external view returns (string _symbol);
331 	  function tokenURI(uint256 _tokenId) public view returns (string);
332 	}
333 
334 
335 	/**
336 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
337 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
338 	 */
339 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
340 	}
341 
342 	/**
343 	 * @title ERC721 Non-Fungible Token Standard basic implementation
344 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
345 	 */
346 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
347 
348 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
349 	  /*
350 	   * 0x80ac58cd ===
351 	   *   bytes4(keccak256('balanceOf(address)')) ^
352 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
353 	   *   bytes4(keccak256('approve(address,uint256)')) ^
354 	   *   bytes4(keccak256('getApproved(uint256)')) ^
355 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
356 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
357 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
358 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
359 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
360 	   */
361 
362 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
363 	  /*
364 	   * 0x4f558e79 ===
365 	   *   bytes4(keccak256('exists(uint256)'))
366 	   */
367 
368 	  using SafeMath for uint256;
369 	  using AddressUtils for address;
370 
371 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
372 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
373 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
374 
375 	  // Mapping from token ID to owner
376 	  mapping (uint256 => address) internal tokenOwner;
377 
378 	  // Mapping from token ID to approved address
379 	  mapping (uint256 => address) internal tokenApprovals;
380 
381 	  // Mapping from owner to number of owned token
382 	  mapping (address => uint256) internal ownedTokensCount;
383 
384 	  // Mapping from owner to operator approvals
385 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
386 
387 	  /**
388 	   * @dev Guarantees msg.sender is owner of the given token
389 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
390 	   */
391 	  modifier onlyOwnerOf(uint256 _tokenId) {
392 		require(ownerOf(_tokenId) == msg.sender);
393 		_;
394 	  }
395 
396 	  /**
397 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
398 	   * @param _tokenId uint256 ID of the token to validate
399 	   */
400 	  modifier canTransfer(uint256 _tokenId) {
401 		require(isApprovedOrOwner(msg.sender, _tokenId));
402 		_;
403 	  }
404 
405 	  constructor()
406 		public
407 	  {
408 		// register the supported interfaces to conform to ERC721 via ERC165
409 		_registerInterface(InterfaceId_ERC721);
410 		_registerInterface(InterfaceId_ERC721Exists);
411 	  }
412 
413 	  /**
414 	   * @dev Gets the balance of the specified address
415 	   * @param _owner address to query the balance of
416 	   * @return uint256 representing the amount owned by the passed address
417 	   */
418 	  function balanceOf(address _owner) public view returns (uint256) {
419 		require(_owner != address(0));
420 		return ownedTokensCount[_owner];
421 	  }
422 
423 	  /**
424 	   * @dev Gets the owner of the specified token ID
425 	   * @param _tokenId uint256 ID of the token to query the owner of
426 	   * @return owner address currently marked as the owner of the given token ID
427 	   */
428 	  function ownerOf(uint256 _tokenId) public view returns (address) {
429 		address owner = tokenOwner[_tokenId];
430 		require(owner != address(0));
431 		return owner;
432 	  }
433 
434 	  /**
435 	   * @dev Returns whether the specified token exists
436 	   * @param _tokenId uint256 ID of the token to query the existence of
437 	   * @return whether the token exists
438 	   */
439 	  function exists(uint256 _tokenId) public view returns (bool) {
440 		address owner = tokenOwner[_tokenId];
441 		return owner != address(0);
442 	  }
443 
444 	  /**
445 	   * @dev Approves another address to transfer the given token ID
446 	   * The zero address indicates there is no approved address.
447 	   * There can only be one approved address per token at a given time.
448 	   * Can only be called by the token owner or an approved operator.
449 	   * @param _to address to be approved for the given token ID
450 	   * @param _tokenId uint256 ID of the token to be approved
451 	   */
452 	  function approve(address _to, uint256 _tokenId) public {
453 		address owner = ownerOf(_tokenId);
454 		require(_to != owner);
455 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
456 
457 		tokenApprovals[_tokenId] = _to;
458 		emit Approval(owner, _to, _tokenId);
459 	  }
460 
461 	  /**
462 	   * @dev Gets the approved address for a token ID, or zero if no address set
463 	   * @param _tokenId uint256 ID of the token to query the approval of
464 	   * @return address currently approved for the given token ID
465 	   */
466 	  function getApproved(uint256 _tokenId) public view returns (address) {
467 		return tokenApprovals[_tokenId];
468 	  }
469 
470 	  /**
471 	   * @dev Sets or unsets the approval of a given operator
472 	   * An operator is allowed to transfer all tokens of the sender on their behalf
473 	   * @param _to operator address to set the approval
474 	   * @param _approved representing the status of the approval to be set
475 	   */
476 	  function setApprovalForAll(address _to, bool _approved) public {
477 		require(_to != msg.sender);
478 		operatorApprovals[msg.sender][_to] = _approved;
479 		emit ApprovalForAll(msg.sender, _to, _approved);
480 	  }
481 
482 	  /**
483 	   * @dev Tells whether an operator is approved by a given owner
484 	   * @param _owner owner address which you want to query the approval of
485 	   * @param _operator operator address which you want to query the approval of
486 	   * @return bool whether the given operator is approved by the given owner
487 	   */
488 	  function isApprovedForAll(
489 		address _owner,
490 		address _operator
491 	  )
492 		public
493 		view
494 		returns (bool)
495 	  {
496 		return operatorApprovals[_owner][_operator];
497 	  }
498 
499 	  /**
500 	   * @dev Transfers the ownership of a given token ID to another address
501 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
502 	   * Requires the msg sender to be the owner, approved, or operator
503 	   * @param _from current owner of the token
504 	   * @param _to address to receive the ownership of the given token ID
505 	   * @param _tokenId uint256 ID of the token to be transferred
506 	  */
507 	  function transferFrom(
508 		address _from,
509 		address _to,
510 		uint256 _tokenId
511 	  )
512 		public
513 		canTransfer(_tokenId)
514 	  {
515 		require(_from != address(0));
516 		require(_to != address(0));
517 
518 		clearApproval(_from, _tokenId);
519 		removeTokenFrom(_from, _tokenId);
520 		addTokenTo(_to, _tokenId);
521 
522 		emit Transfer(_from, _to, _tokenId);
523 	  }
524 
525 	  /**
526 	   * @dev Safely transfers the ownership of a given token ID to another address
527 	   * If the target address is a contract, it must implement `onERC721Received`,
528 	   * which is called upon a safe transfer, and return the magic value
529 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
530 	   * the transfer is reverted.
531 	   *
532 	   * Requires the msg sender to be the owner, approved, or operator
533 	   * @param _from current owner of the token
534 	   * @param _to address to receive the ownership of the given token ID
535 	   * @param _tokenId uint256 ID of the token to be transferred
536 	  */
537 	  function safeTransferFrom(
538 		address _from,
539 		address _to,
540 		uint256 _tokenId
541 	  )
542 		public
543 		canTransfer(_tokenId)
544 	  {
545 		// solium-disable-next-line arg-overflow
546 		safeTransferFrom(_from, _to, _tokenId, "");
547 	  }
548 
549 	  /**
550 	   * @dev Safely transfers the ownership of a given token ID to another address
551 	   * If the target address is a contract, it must implement `onERC721Received`,
552 	   * which is called upon a safe transfer, and return the magic value
553 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
554 	   * the transfer is reverted.
555 	   * Requires the msg sender to be the owner, approved, or operator
556 	   * @param _from current owner of the token
557 	   * @param _to address to receive the ownership of the given token ID
558 	   * @param _tokenId uint256 ID of the token to be transferred
559 	   * @param _data bytes data to send along with a safe transfer check
560 	   */
561 	  function safeTransferFrom(
562 		address _from,
563 		address _to,
564 		uint256 _tokenId,
565 		bytes _data
566 	  )
567 		public
568 		canTransfer(_tokenId)
569 	  {
570 		transferFrom(_from, _to, _tokenId);
571 		// solium-disable-next-line arg-overflow
572 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
573 	  }
574 
575 	  /**
576 	   * @dev Returns whether the given spender can transfer a given token ID
577 	   * @param _spender address of the spender to query
578 	   * @param _tokenId uint256 ID of the token to be transferred
579 	   * @return bool whether the msg.sender is approved for the given token ID,
580 	   *  is an operator of the owner, or is the owner of the token
581 	   */
582 	  function isApprovedOrOwner(
583 		address _spender,
584 		uint256 _tokenId
585 	  )
586 		internal
587 		view
588 		returns (bool)
589 	  {
590 		address owner = ownerOf(_tokenId);
591 		// Disable solium check because of
592 		// https://github.com/duaraghav8/Solium/issues/175
593 		// solium-disable-next-line operator-whitespace
594 		return (
595 		  _spender == owner ||
596 		  getApproved(_tokenId) == _spender ||
597 		  isApprovedForAll(owner, _spender)
598 		);
599 	  }
600 
601 	  /**
602 	   * @dev Internal function to mint a new token
603 	   * Reverts if the given token ID already exists
604 	   * @param _to The address that will own the minted token
605 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
606 	   */
607 	  function _mint(address _to, uint256 _tokenId) internal {
608 		require(_to != address(0));
609 		addTokenTo(_to, _tokenId);
610 		emit Transfer(address(0), _to, _tokenId);
611 	  }
612 
613 	  /**
614 	   * @dev Internal function to burn a specific token
615 	   * Reverts if the token does not exist
616 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
617 	   */
618 	  function _burn(address _owner, uint256 _tokenId) internal {
619 		clearApproval(_owner, _tokenId);
620 		removeTokenFrom(_owner, _tokenId);
621 		emit Transfer(_owner, address(0), _tokenId);
622 	  }
623 
624 	  /**
625 	   * @dev Internal function to clear current approval of a given token ID
626 	   * Reverts if the given address is not indeed the owner of the token
627 	   * @param _owner owner of the token
628 	   * @param _tokenId uint256 ID of the token to be transferred
629 	   */
630 	  function clearApproval(address _owner, uint256 _tokenId) internal {
631 		require(ownerOf(_tokenId) == _owner);
632 		if (tokenApprovals[_tokenId] != address(0)) {
633 		  tokenApprovals[_tokenId] = address(0);
634 		}
635 	  }
636 
637 	  /**
638 	   * @dev Internal function to add a token ID to the list of a given address
639 	   * @param _to address representing the new owner of the given token ID
640 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
641 	   */
642 	  function addTokenTo(address _to, uint256 _tokenId) internal {
643 		require(tokenOwner[_tokenId] == address(0));
644 		tokenOwner[_tokenId] = _to;
645 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
646 	  }
647 
648 	  /**
649 	   * @dev Internal function to remove a token ID from the list of a given address
650 	   * @param _from address representing the previous owner of the given token ID
651 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
652 	   */
653 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
654 		require(ownerOf(_tokenId) == _from);
655 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
656 		tokenOwner[_tokenId] = address(0);
657 	  }
658 
659 	  /**
660 	   * @dev Internal function to invoke `onERC721Received` on a target address
661 	   * The call is not executed if the target address is not a contract
662 	   * @param _from address representing the previous owner of the given token ID
663 	   * @param _to target address that will receive the tokens
664 	   * @param _tokenId uint256 ID of the token to be transferred
665 	   * @param _data bytes optional data to send along with the call
666 	   * @return whether the call correctly returned the expected magic value
667 	   */
668 	  function checkAndCallSafeTransfer(
669 		address _from,
670 		address _to,
671 		uint256 _tokenId,
672 		bytes _data
673 	  )
674 		internal
675 		returns (bool)
676 	  {
677 		if (!_to.isContract()) {
678 		  return true;
679 		}
680 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
681 		  msg.sender, _from, _tokenId, _data);
682 		return (retval == ERC721_RECEIVED);
683 	  }
684 	}
685 
686 	/**
687 	 * @title Full ERC721 Token
688 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
689 	 * Moreover, it includes approve all functionality using operator terminology
690 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
691 	 */
692 	contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
693 
694 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
695 	  /**
696 	   * 0x780e9d63 ===
697 	   *   bytes4(keccak256('totalSupply()')) ^
698 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
699 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
700 	   */
701 
702 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
703 	  /**
704 	   * 0x5b5e139f ===
705 	   *   bytes4(keccak256('name()')) ^
706 	   *   bytes4(keccak256('symbol()')) ^
707 	   *   bytes4(keccak256('tokenURI(uint256)'))
708 	   */
709 
710 	  // Token name
711 	  string internal name_;
712 
713 	  // Token symbol
714 	  string internal symbol_;
715 
716 	  // Mapping from owner to list of owned token IDs
717 	  mapping(address => uint256[]) internal ownedTokens;
718 
719 	  // Mapping from token ID to index of the owner tokens list
720 	  mapping(uint256 => uint256) internal ownedTokensIndex;
721 
722 	  // Array with all token ids, used for enumeration
723 	  uint256[] internal allTokens;
724 
725 	  // Mapping from token id to position in the allTokens array
726 	  mapping(uint256 => uint256) internal allTokensIndex;
727 
728 	  // Optional mapping for token URIs
729 	  mapping(uint256 => string) internal tokenURIs;
730 
731 	  /**
732 	   * @dev Constructor function
733 	   */
734 	  constructor(string _name, string _symbol) public {
735 		name_ = _name;
736 		symbol_ = _symbol;
737 
738 		// register the supported interfaces to conform to ERC721 via ERC165
739 		_registerInterface(InterfaceId_ERC721Enumerable);
740 		_registerInterface(InterfaceId_ERC721Metadata);
741 	  }
742 
743 	  /**
744 	   * @dev Gets the token name
745 	   * @return string representing the token name
746 	   */
747 	  function name() external view returns (string) {
748 		return name_;
749 	  }
750 
751 	  /**
752 	   * @dev Gets the token symbol
753 	   * @return string representing the token symbol
754 	   */
755 	  function symbol() external view returns (string) {
756 		return symbol_;
757 	  }
758 
759 	  /**
760 	   * @dev Returns an URI for a given token ID
761 	   * Throws if the token ID does not exist. May return an empty string.
762 	   * @param _tokenId uint256 ID of the token to query
763 	   */
764 	  function tokenURI(uint256 _tokenId) public view returns (string) {
765 		require(exists(_tokenId));
766 		return tokenURIs[_tokenId];
767 	  }
768 
769 	  /**
770 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
771 	   * @param _owner address owning the tokens list to be accessed
772 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
773 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
774 	   */
775 	  function tokenOfOwnerByIndex(
776 		address _owner,
777 		uint256 _index
778 	  )
779 		public
780 		view
781 		returns (uint256)
782 	  {
783 		require(_index < balanceOf(_owner));
784 		return ownedTokens[_owner][_index];
785 	  }
786 
787 	  /**
788 	   * @dev Gets the total amount of tokens stored by the contract
789 	   * @return uint256 representing the total amount of tokens
790 	   */
791 	  function totalSupply() public view returns (uint256) {
792 		return allTokens.length;
793 	  }
794 
795 	  /**
796 	   * @dev Gets the token ID at a given index of all the tokens in this contract
797 	   * Reverts if the index is greater or equal to the total number of tokens
798 	   * @param _index uint256 representing the index to be accessed of the tokens list
799 	   * @return uint256 token ID at the given index of the tokens list
800 	   */
801 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
802 		require(_index < totalSupply());
803 		return allTokens[_index];
804 	  }
805 
806 	  /**
807 	   * @dev Internal function to set the token URI for a given token
808 	   * Reverts if the token ID does not exist
809 	   * @param _tokenId uint256 ID of the token to set its URI
810 	   * @param _uri string URI to assign
811 	   */
812 	  function _setTokenURI(uint256 _tokenId, string _uri) internal {
813 		require(exists(_tokenId));
814 		tokenURIs[_tokenId] = _uri;
815 	  }
816 
817 	  /**
818 	   * @dev Internal function to add a token ID to the list of a given address
819 	   * @param _to address representing the new owner of the given token ID
820 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
821 	   */
822 	  function addTokenTo(address _to, uint256 _tokenId) internal {
823 		super.addTokenTo(_to, _tokenId);
824 		uint256 length = ownedTokens[_to].length;
825 		ownedTokens[_to].push(_tokenId);
826 		ownedTokensIndex[_tokenId] = length;
827 	  }
828 
829 	  /**
830 	   * @dev Internal function to remove a token ID from the list of a given address
831 	   * @param _from address representing the previous owner of the given token ID
832 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
833 	   */
834 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
835 		super.removeTokenFrom(_from, _tokenId);
836 
837 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
838 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
839 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
840 
841 		ownedTokens[_from][tokenIndex] = lastToken;
842 		ownedTokens[_from][lastTokenIndex] = 0;
843 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
844 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
845 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
846 
847 		ownedTokens[_from].length--;
848 		ownedTokensIndex[_tokenId] = 0;
849 		ownedTokensIndex[lastToken] = tokenIndex;
850 	  }
851 
852 	  /**
853 	   * @dev Internal function to mint a new token
854 	   * Reverts if the given token ID already exists
855 	   * @param _to address the beneficiary that will own the minted token
856 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
857 	   */
858 	  function _mint(address _to, uint256 _tokenId) internal {
859 		super._mint(_to, _tokenId);
860 
861 		allTokensIndex[_tokenId] = allTokens.length;
862 		allTokens.push(_tokenId);
863 	  }
864 
865 	  /**
866 	   * @dev Internal function to burn a specific token
867 	   * Reverts if the token does not exist
868 	   * @param _owner owner of the token to burn
869 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
870 	   */
871 	  function _burn(address _owner, uint256 _tokenId) internal {
872 		super._burn(_owner, _tokenId);
873 
874 		// Clear metadata (if any)
875 		if (bytes(tokenURIs[_tokenId]).length != 0) {
876 		  delete tokenURIs[_tokenId];
877 		}
878 
879 		// Reorg all tokens array
880 		uint256 tokenIndex = allTokensIndex[_tokenId];
881 		uint256 lastTokenIndex = allTokens.length.sub(1);
882 		uint256 lastToken = allTokens[lastTokenIndex];
883 
884 		allTokens[tokenIndex] = lastToken;
885 		allTokens[lastTokenIndex] = 0;
886 
887 		allTokens.length--;
888 		allTokensIndex[_tokenId] = 0;
889 		allTokensIndex[lastToken] = tokenIndex;
890 	  }
891 
892 	}
893 
894 	contract CryptoCaps is ERC721Token, Ownable {
895 
896 	  /*** EVENTS ***/
897 	  /// The event emitted (useable by web3) when a token is purchased
898 	  event BoughtToken(address indexed buyer, uint256 tokenId);
899 
900 	  /*** CONSTANTS ***/
901 	  uint8 constant TITLE_MIN_LENGTH = 1;
902 	  uint8 constant TITLE_MAX_LENGTH = 64;
903 	  uint256 constant DESCRIPTION_MIN_LENGTH = 1;
904 	  uint256 constant DESCRIPTION_MAX_LENGTH = 10000;
905 
906 	  /*** DATA TYPES ***/
907 
908 	  /// Price set by contract owner for each token in Wei.
909 	  /// @dev If you'd like a different price for each token type, you will
910 	  ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
911 	  uint256 currentPrice = 0;
912 
913 	  /// The token type (1 for idea, 2 for belonging, etc)
914 	  mapping(uint256 => uint256) tokenTypes;
915 
916 	  /// The title of the token
917 	  mapping(uint256 => string) tokenTitles;
918 	  
919 	  /// The description of the token
920 	  mapping(uint256 => string) tokenDescription;
921 
922 	  constructor() ERC721Token("CryptoCaps", "QCC") public {
923 		// any init code when you deploy the contract would run here
924 	  }
925 
926 	  /// Requires the amount of Ether be at least or more of the currentPrice
927 	  /// @dev Creates an instance of an token and mints it to the purchaser
928 	  /// @param _type The token type as an integer
929 	  /// @param _title The short title of the token
930 	  /// @param _description Description of the token
931 	  function buyToken (
932 		uint256 _type,
933 		string _title,
934 		string _description
935 	  ) external payable {
936 		bytes memory _titleBytes = bytes(_title);
937 		require(_titleBytes.length >= TITLE_MIN_LENGTH, "Title is too short");
938 		require(_titleBytes.length <= TITLE_MAX_LENGTH, "Title is too long");
939 		
940 		bytes memory _descriptionBytes = bytes(_description);
941 		require(_descriptionBytes.length >= DESCRIPTION_MIN_LENGTH, "Description is too short");
942 		require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
943 		require(msg.value >= currentPrice, "Amount of Ether sent too small");
944 
945 		uint256 index = allTokens.length + 1;
946 
947 		_mint(msg.sender, index);
948 
949 		tokenTypes[index] = _type;
950 		tokenTitles[index] = _title;
951 		tokenDescription[index] = _description;
952 
953 		emit BoughtToken(msg.sender, index);
954 	  }
955 
956 	  /**
957 	   * @dev Returns all of the tokens that the user owns
958 	   * @return An array of token indices
959 	   */
960 	  function myTokens()
961 		external
962 		view
963 		returns (
964 		  uint256[]
965 		)
966 	  {
967 		return ownedTokens[msg.sender];
968 	  }
969 
970 	  /// @notice Returns all the relevant information about a specific token
971 	  /// @param _tokenId The ID of the token of interest
972 	  function viewToken(uint256 _tokenId)
973 		external
974 		view
975 		returns (
976 		  uint256 tokenType_,
977 		  string tokenTitle_,
978 		  string tokenDescription_
979 	  ) {
980 		  tokenType_ = tokenTypes[_tokenId];
981 		  tokenTitle_ = tokenTitles[_tokenId];
982 		  tokenDescription_ = tokenDescription[_tokenId];
983 	  }
984 
985 	  /// @notice Allows the owner of this contract to set the currentPrice for each token
986 	  function setCurrentPrice(uint256 newPrice)
987 		public
988 		onlyOwner
989 	  {
990 		  currentPrice = newPrice;
991 	  }
992 
993 	  /// @notice Returns the currentPrice for each token
994 	  function getCurrentPrice()
995 		external
996 		view
997 		returns (
998 		uint256 price
999 	  ) {
1000 		  price = currentPrice;
1001 	  }
1002 	  /// @notice allows the owner of this contract to destroy the contract
1003 	   function kill() public {
1004 		  if(msg.sender == owner) selfdestruct(owner);
1005 	   }  
1006 	}