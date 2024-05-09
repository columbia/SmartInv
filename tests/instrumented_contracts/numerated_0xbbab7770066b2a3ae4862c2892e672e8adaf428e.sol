1 pragma solidity ^0.4.18;
2 	
3 	/*
4 	ERC721 asset for world of blockchain game
5 	*/
6 
7 	/**
8 	 * @title SafeMath
9 	 * @dev Math operations with safety checks that throw on error
10 	 */
11     library SafeMath {
12 
13 	  /**
14 	  * @dev Multiplies two numbers, throws on overflow.
15 	  */
16 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18 		// benefit is lost if 'b' is also tested.
19 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20 		if (a == 0) {
21 		  return 0;
22 		}
23 
24 		c = a * b;
25 		assert(c / a == b);
26 		return c;
27 	  }
28 
29 	  /**
30 	  * @dev Integer division of two numbers, truncating the quotient.
31 	  */
32 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
33 		// assert(b > 0); // Solidity automatically throws when dividing by 0
34 		// uint256 c = a / b;
35 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 		return a / b;
37 	  }
38 
39 	  /**
40 	  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41 	  */
42 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43 		assert(b <= a);
44 		return a - b;
45 	  }
46 
47 	  /**
48 	  * @dev Adds two numbers, throws on overflow.
49 	  */
50 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51 		c = a + b;
52 		assert(c >= a);
53 		return c;
54 	  }
55     }
56 
57 	/**
58 	 * @title ERC165
59 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
60 	 */
61     interface ERC165 {
62 
63 	  /**
64 	   * @notice Query if a contract implements an interface
65 	   * @param _interfaceId The interface identifier, as specified in ERC-165
66 	   * @dev Interface identification is specified in ERC-165. This function
67 	   * uses less than 30,000 gas.
68 	   */
69 	  function supportsInterface(bytes4 _interfaceId)
70 		external
71 		view
72 		returns (bool);
73     }
74 
75 	/**
76 	 * @title ERC721 token receiver interface
77 	 * @dev Interface for any contract that wants to support safeTransfers
78 	 * from ERC721 asset contracts.
79 	 */
80     contract ERC721Receiver {
81 	  /**
82 	   * @dev Magic value to be returned upon successful reception of an NFT
83 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
84 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
85 	   */
86 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
87 
88 	  /**
89 	   * @notice Handle the receipt of an NFT
90 	   * @dev The ERC721 smart contract calls this function on the recipient
91 	   * after a `safetransfer`. This function MAY throw to revert and reject the
92 	   * transfer. Return of other than the magic value MUST result in the 
93 	   * transaction being reverted.
94 	   * Note: the contract address is always the message sender.
95 	   * @param _operator The address which called `safeTransferFrom` function
96 	   * @param _from The address which previously owned the token
97 	   * @param _tokenId The NFT identifier which is being transfered
98 	   * @param _data Additional data with no specified format
99 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
100 	   */
101 	  function onERC721Received(
102 		address _operator,
103 		address _from,
104 		uint256 _tokenId,
105 		bytes _data
106 	  )
107 		public
108 		returns(bytes4);
109 	}
110 
111 	/**
112 	 * Utility library of inline functions on addresses
113 	 */
114 	library AddressUtils {
115 
116 	  /**
117 	   * Returns whether the target address is a contract
118 	   * @dev This function will return false if invoked during the constructor of a contract,
119 	   * as the code is not actually created until after the constructor finishes.
120 	   * @param addr address to check
121 	   * @return whether the target address is a contract
122 	   */
123 	  function isContract(address addr) internal view returns (bool) {
124 		uint256 size;
125 		// XXX Currently there is no better way to check if there is a contract in an address
126 		// than to check the size of the code at that address.
127 		// See https://ethereum.stackexchange.com/a/14016/36603
128 		// for more details about how this works.
129 		// TODO Check this again before the Serenity release, because all addresses will be
130 		// contracts then.
131 		// solium-disable-next-line security/no-inline-assembly
132 		assembly { size := extcodesize(addr) }
133 		return size > 0;
134 	  }
135 
136 	}
137 
138 	/**
139 	 * @title Ownable
140 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
141 	 * functions, this simplifies the implementation of "user permissions".
142 	 */
143 	contract Ownable {
144 	  address public owner;
145 
146 	  event OwnershipRenounced(address indexed previousOwner);
147 	  event OwnershipTransferred(
148 		address indexed previousOwner,
149 		address indexed newOwner
150 	  );
151 
152 
153 	  /**
154 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155 	   * account.
156 	   */
157 	  constructor() public {
158 		owner = msg.sender;
159 	  }
160 
161 	  /**
162 	   * @dev Throws if called by any account other than the owner.
163 	   */
164 	  modifier onlyOwner() {
165 		require(msg.sender == owner);
166 		_;
167 	  }
168 
169 	  /**
170 	   * @dev Allows the current owner to relinquish control of the contract.
171 	   * @notice Renouncing to ownership will leave the contract without an owner.
172 	   * It will not be possible to call the functions with the `onlyOwner`
173 	   * modifier anymore.
174 	   */
175 	  function renounceOwnership() public onlyOwner {
176 		emit OwnershipRenounced(owner);
177 		owner = address(0);
178 	  }
179 
180 	  /**
181 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
182 	   * @param _newOwner The address to transfer ownership to.
183 	   */
184 	  function transferOwnership(address _newOwner) public onlyOwner {
185 		_transferOwnership(_newOwner);
186 	  }
187 
188 	  /**
189 	   * @dev Transfers control of the contract to a newOwner.
190 	   * @param _newOwner The address to transfer ownership to.
191 	   */
192 	  function _transferOwnership(address _newOwner) internal {
193 		require(_newOwner != address(0));
194 		emit OwnershipTransferred(owner, _newOwner);
195 		owner = _newOwner;
196 	  }
197 	}
198 
199 	/**
200 	 * @title SupportsInterfaceWithLookup
201 	 * @author Matt Condon (@shrugs)
202 	 * @dev Implements ERC165 using a lookup table.
203 	 */
204 	contract SupportsInterfaceWithLookup is ERC165 {
205 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
206 	  /**
207 	   * 0x01ffc9a7 ===
208 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
209 	   */
210 
211 	  /**
212 	   * @dev a mapping of interface id to whether or not it's supported
213 	   */
214 	  mapping(bytes4 => bool) internal supportedInterfaces;
215 
216 	  /**
217 	   * @dev A contract implementing SupportsInterfaceWithLookup
218 	   * implement ERC165 itself
219 	   */
220 	  constructor()
221 		public
222 	  {
223 		_registerInterface(InterfaceId_ERC165);
224 	  }
225 
226 	  /**
227 	   * @dev implement supportsInterface(bytes4) using a lookup table
228 	   */
229 	  function supportsInterface(bytes4 _interfaceId)
230 		external
231 		view
232 		returns (bool)
233 	  {
234 		return supportedInterfaces[_interfaceId];
235 	  }
236 
237 	  /**
238 	   * @dev private method for registering an interface
239 	   */
240 	  function _registerInterface(bytes4 _interfaceId)
241 		internal
242 	  {
243 		require(_interfaceId != 0xffffffff);
244 		supportedInterfaces[_interfaceId] = true;
245 	  }
246 	}
247 
248 	/**
249 	 * @title ERC721 Non-Fungible Token Standard basic interface
250 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
251 	 */
252 	contract ERC721Basic is ERC165 {
253 	  event Transfer(
254 		address indexed _from,
255 		address indexed _to,
256 		uint256 indexed _tokenId
257 	  );
258 	  event Approval(
259 		address indexed _owner,
260 		address indexed _approved,
261 		uint256 indexed _tokenId
262 	  );
263 	  event ApprovalForAll(
264 		address indexed _owner,
265 		address indexed _operator,
266 		bool _approved
267 	  );
268 
269 	  function balanceOf(address _owner) public view returns (uint256 _balance);
270 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
271 	  function exists(uint256 _tokenId) public view returns (bool _exists);
272 
273 	  function approve(address _to, uint256 _tokenId) public;
274 	  function getApproved(uint256 _tokenId)
275 		public view returns (address _operator);
276 
277 	  function setApprovalForAll(address _operator, bool _approved) public;
278 	  function isApprovedForAll(address _owner, address _operator)
279 		public view returns (bool);
280 
281 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
282 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
283 		public;
284 
285 	  function safeTransferFrom(
286 		address _from,
287 		address _to,
288 		uint256 _tokenId,
289 		bytes _data
290 	  )
291 		public;
292 	}
293 
294 	/**
295 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
296 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297 	 */
298 	contract ERC721Enumerable is ERC721Basic {
299 	  function totalSupply() public view returns (uint256);
300 	  function tokenOfOwnerByIndex(
301 		address _owner,
302 		uint256 _index
303 	  )
304 		public
305 		view
306 		returns (uint256 _tokenId);
307 
308 	  function tokenByIndex(uint256 _index) public view returns (uint256);
309 	}
310 
311 
312 	/**
313 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
314 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
315 	 */
316 	contract ERC721Metadata is ERC721Basic {
317 	  function name() external view returns (string _name);
318 	  function symbol() external view returns (string _symbol);
319 	  function tokenURI(uint256 _tokenId) public view returns (string);
320 	}
321 
322 
323 	/**
324 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
325 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
326 	 */
327 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
328 	}
329 
330 	/**
331 	 * @title ERC721 Non-Fungible Token Standard basic implementation
332 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
333 	 */
334 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
335 
336 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
337 	  /*
338 	   * 0x80ac58cd ===
339 	   *   bytes4(keccak256('balanceOf(address)')) ^
340 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
341 	   *   bytes4(keccak256('approve(address,uint256)')) ^
342 	   *   bytes4(keccak256('getApproved(uint256)')) ^
343 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
344 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
345 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
346 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
347 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
348 	   */
349 
350 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
351 	  /*
352 	   * 0x4f558e79 ===
353 	   *   bytes4(keccak256('exists(uint256)'))
354 	   */
355 
356 	  using SafeMath for uint256;
357 	  using AddressUtils for address;
358 
359 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
360 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
361 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
362 
363 	  // Mapping from token ID to owner
364 	  mapping (uint256 => address) internal tokenOwner;
365 
366 	  // Mapping from token ID to approved address
367 	  mapping (uint256 => address) internal tokenApprovals;
368 
369 	  // Mapping from owner to number of owned token
370 	  mapping (address => uint256) internal ownedTokensCount;
371 
372 	  // Mapping from owner to operator approvals
373 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
374 
375 	  /**
376 	   * @dev Guarantees msg.sender is owner of the given token
377 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
378 	   */
379 	  modifier onlyOwnerOf(uint256 _tokenId) {
380 		require(ownerOf(_tokenId) == msg.sender);
381 		_;
382 	  }
383 
384 	  /**
385 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
386 	   * @param _tokenId uint256 ID of the token to validate
387 	   */
388 	  modifier canTransfer(uint256 _tokenId) {
389 		require(isApprovedOrOwner(msg.sender, _tokenId));
390 		_;
391 	  }
392 
393 	  constructor()
394 		public
395 	  {
396 		// register the supported interfaces to conform to ERC721 via ERC165
397 		_registerInterface(InterfaceId_ERC721);
398 		_registerInterface(InterfaceId_ERC721Exists);
399 	  }
400 
401 	  /**
402 	   * @dev Gets the balance of the specified address
403 	   * @param _owner address to query the balance of
404 	   * @return uint256 representing the amount owned by the passed address
405 	   */
406 	  function balanceOf(address _owner) public view returns (uint256) {
407 		require(_owner != address(0));
408 		return ownedTokensCount[_owner];
409 	  }
410 
411 	  /**
412 	   * @dev Gets the owner of the specified token ID
413 	   * @param _tokenId uint256 ID of the token to query the owner of
414 	   * @return owner address currently marked as the owner of the given token ID
415 	   */
416 	  function ownerOf(uint256 _tokenId) public view returns (address) {
417 		address owner = tokenOwner[_tokenId];
418 		require(owner != address(0));
419 		return owner;
420 	  }
421 
422 	  /**
423 	   * @dev Returns whether the specified token exists
424 	   * @param _tokenId uint256 ID of the token to query the existence of
425 	   * @return whether the token exists
426 	   */
427 	  function exists(uint256 _tokenId) public view returns (bool) {
428 		address owner = tokenOwner[_tokenId];
429 		return owner != address(0);
430 	  }
431 
432 	  /**
433 	   * @dev Approves another address to transfer the given token ID
434 	   * The zero address indicates there is no approved address.
435 	   * There can only be one approved address per token at a given time.
436 	   * Can only be called by the token owner or an approved operator.
437 	   * @param _to address to be approved for the given token ID
438 	   * @param _tokenId uint256 ID of the token to be approved
439 	   */
440 	  function approve(address _to, uint256 _tokenId) public {
441 		address owner = ownerOf(_tokenId);
442 		require(_to != owner);
443 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
444 
445 		tokenApprovals[_tokenId] = _to;
446 		emit Approval(owner, _to, _tokenId);
447 	  }
448 
449 	  /**
450 	   * @dev Gets the approved address for a token ID, or zero if no address set
451 	   * @param _tokenId uint256 ID of the token to query the approval of
452 	   * @return address currently approved for the given token ID
453 	   */
454 	  function getApproved(uint256 _tokenId) public view returns (address) {
455 		return tokenApprovals[_tokenId];
456 	  }
457 
458 	  /**
459 	   * @dev Sets or unsets the approval of a given operator
460 	   * An operator is allowed to transfer all tokens of the sender on their behalf
461 	   * @param _to operator address to set the approval
462 	   * @param _approved representing the status of the approval to be set
463 	   */
464 	  function setApprovalForAll(address _to, bool _approved) public {
465 		require(_to != msg.sender);
466 		operatorApprovals[msg.sender][_to] = _approved;
467 		emit ApprovalForAll(msg.sender, _to, _approved);
468 	  }
469 
470 	  /**
471 	   * @dev Tells whether an operator is approved by a given owner
472 	   * @param _owner owner address which you want to query the approval of
473 	   * @param _operator operator address which you want to query the approval of
474 	   * @return bool whether the given operator is approved by the given owner
475 	   */
476 	  function isApprovedForAll(
477 		address _owner,
478 		address _operator
479 	  )
480 		public
481 		view
482 		returns (bool)
483 	  {
484 		return operatorApprovals[_owner][_operator];
485 	  }
486 
487 	  /**
488 	   * @dev Transfers the ownership of a given token ID to another address
489 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
490 	   * Requires the msg sender to be the owner, approved, or operator
491 	   * @param _from current owner of the token
492 	   * @param _to address to receive the ownership of the given token ID
493 	   * @param _tokenId uint256 ID of the token to be transferred
494 	  */
495 	  function transferFrom(
496 		address _from,
497 		address _to,
498 		uint256 _tokenId
499 	  )
500 		public
501 		canTransfer(_tokenId)
502 	  {
503 		require(_from != address(0));
504 		require(_to != address(0));
505 
506 		clearApproval(_from, _tokenId);
507 		removeTokenFrom(_from, _tokenId);
508 		addTokenTo(_to, _tokenId);
509 
510 		emit Transfer(_from, _to, _tokenId);
511 	  }
512 
513 	  /**
514 	   * @dev Safely transfers the ownership of a given token ID to another address
515 	   * If the target address is a contract, it must implement `onERC721Received`,
516 	   * which is called upon a safe transfer, and return the magic value
517 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
518 	   * the transfer is reverted.
519 	   *
520 	   * Requires the msg sender to be the owner, approved, or operator
521 	   * @param _from current owner of the token
522 	   * @param _to address to receive the ownership of the given token ID
523 	   * @param _tokenId uint256 ID of the token to be transferred
524 	  */
525 	  function safeTransferFrom(
526 		address _from,
527 		address _to,
528 		uint256 _tokenId
529 	  )
530 		public
531 		canTransfer(_tokenId)
532 	  {
533 		// solium-disable-next-line arg-overflow
534 		safeTransferFrom(_from, _to, _tokenId, "");
535 	  }
536 
537 	  /**
538 	   * @dev Safely transfers the ownership of a given token ID to another address
539 	   * If the target address is a contract, it must implement `onERC721Received`,
540 	   * which is called upon a safe transfer, and return the magic value
541 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
542 	   * the transfer is reverted.
543 	   * Requires the msg sender to be the owner, approved, or operator
544 	   * @param _from current owner of the token
545 	   * @param _to address to receive the ownership of the given token ID
546 	   * @param _tokenId uint256 ID of the token to be transferred
547 	   * @param _data bytes data to send along with a safe transfer check
548 	   */
549 	  function safeTransferFrom(
550 		address _from,
551 		address _to,
552 		uint256 _tokenId,
553 		bytes _data
554 	  )
555 		public
556 		canTransfer(_tokenId)
557 	  {
558 		transferFrom(_from, _to, _tokenId);
559 		// solium-disable-next-line arg-overflow
560 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
561 	  }
562 
563 	  /**
564 	   * @dev Returns whether the given spender can transfer a given token ID
565 	   * @param _spender address of the spender to query
566 	   * @param _tokenId uint256 ID of the token to be transferred
567 	   * @return bool whether the msg.sender is approved for the given token ID,
568 	   *  is an operator of the owner, or is the owner of the token
569 	   */
570 	  function isApprovedOrOwner(
571 		address _spender,
572 		uint256 _tokenId
573 	  )
574 		internal
575 		view
576 		returns (bool)
577 	  {
578 		address owner = ownerOf(_tokenId);
579 		// Disable solium check because of
580 		// https://github.com/duaraghav8/Solium/issues/175
581 		// solium-disable-next-line operator-whitespace
582 		return (
583 		  _spender == owner ||
584 		  getApproved(_tokenId) == _spender ||
585 		  isApprovedForAll(owner, _spender)
586 		);
587 	  }
588 
589 	  /**
590 	   * @dev Internal function to mint a new token
591 	   * Reverts if the given token ID already exists
592 	   * @param _to The address that will own the minted token
593 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
594 	   */
595 	  function _mint(address _to, uint256 _tokenId) internal {
596 		require(_to != address(0));
597 		addTokenTo(_to, _tokenId);
598 		emit Transfer(address(0), _to, _tokenId);
599 	  }
600 
601 	  /**
602 	   * @dev Internal function to burn a specific token
603 	   * Reverts if the token does not exist
604 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
605 	   */
606 	  function _burn(address _owner, uint256 _tokenId) internal {
607 		clearApproval(_owner, _tokenId);
608 		removeTokenFrom(_owner, _tokenId);
609 		emit Transfer(_owner, address(0), _tokenId);
610 	  }
611 
612 	  /**
613 	   * @dev Internal function to clear current approval of a given token ID
614 	   * Reverts if the given address is not indeed the owner of the token
615 	   * @param _owner owner of the token
616 	   * @param _tokenId uint256 ID of the token to be transferred
617 	   */
618 	  function clearApproval(address _owner, uint256 _tokenId) internal {
619 		require(ownerOf(_tokenId) == _owner);
620 		if (tokenApprovals[_tokenId] != address(0)) {
621 		  tokenApprovals[_tokenId] = address(0);
622 		}
623 	  }
624 
625 	  /**
626 	   * @dev Internal function to add a token ID to the list of a given address
627 	   * @param _to address representing the new owner of the given token ID
628 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
629 	   */
630 	  function addTokenTo(address _to, uint256 _tokenId) internal {
631 		require(tokenOwner[_tokenId] == address(0));
632 		tokenOwner[_tokenId] = _to;
633 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
634 	  }
635 
636 	  /**
637 	   * @dev Internal function to remove a token ID from the list of a given address
638 	   * @param _from address representing the previous owner of the given token ID
639 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
640 	   */
641 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
642 		require(ownerOf(_tokenId) == _from);
643 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
644 		tokenOwner[_tokenId] = address(0);
645 	  }
646 
647 	  /**
648 	   * @dev Internal function to invoke `onERC721Received` on a target address
649 	   * The call is not executed if the target address is not a contract
650 	   * @param _from address representing the previous owner of the given token ID
651 	   * @param _to target address that will receive the tokens
652 	   * @param _tokenId uint256 ID of the token to be transferred
653 	   * @param _data bytes optional data to send along with the call
654 	   * @return whether the call correctly returned the expected magic value
655 	   */
656 	  function checkAndCallSafeTransfer(
657 		address _from,
658 		address _to,
659 		uint256 _tokenId,
660 		bytes _data
661 	  )
662 		internal
663 		returns (bool)
664 	  {
665 		if (!_to.isContract()) {
666 		  return true;
667 		}
668 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
669 		  msg.sender, _from, _tokenId, _data);
670 		return (retval == ERC721_RECEIVED);
671 	  }
672 	}
673 
674 	/**
675 	 * @title Full ERC721 Token
676 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
677 	 * Moreover, it includes approve all functionality using operator terminology
678 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
679 	 */
680 	contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
681 
682 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
683 	  /**
684 	   * 0x780e9d63 ===
685 	   *   bytes4(keccak256('totalSupply()')) ^
686 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
687 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
688 	   */
689 
690 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
691 	  /**
692 	   * 0x5b5e139f ===
693 	   *   bytes4(keccak256('name()')) ^
694 	   *   bytes4(keccak256('symbol()')) ^
695 	   *   bytes4(keccak256('tokenURI(uint256)'))
696 	   */
697 
698 	  // Token name
699 	  string internal name_;
700 
701 	  // Token symbol
702 	  string internal symbol_;
703 	  
704       //asset attribute
705 	  struct NFTtoken {
706             string attribute;
707             uint256 birthTime;
708       }
709       
710       NFTtoken[] allNFTtokens;
711       
712       //check whether asset can update attribute 
713       mapping (uint256 => bool) internal isNFTAlive;
714       
715       //Mapping from token ID to Index of asset
716       mapping (uint256 => uint256) internal tokdenIdToNFTindex;      
717 
718 	  // Mapping from owner to list of owned token IDs
719 	  mapping(address => uint256[]) internal ownedTokens;
720 
721 	  // Mapping from token ID to index of the owner tokens list
722 	  mapping(uint256 => uint256) internal ownedTokensIndex;
723 
724 	  // Array with all token ids, used for enumeration
725 	  uint256[] internal allTokens;
726 
727 	  // Mapping from token id to position in the allTokens array
728 	  mapping(uint256 => uint256) internal allTokensIndex;
729 
730 	  // Optional mapping for token URIs
731 	  mapping(uint256 => string) internal tokenURIs;
732 
733 	  /**
734 	   * @dev Constructor function
735 	   */
736 	  constructor(string _name, string _symbol) public {
737 		name_ = _name;
738 		symbol_ = _symbol;
739 
740 		// register the supported interfaces to conform to ERC721 via ERC165
741 		_registerInterface(InterfaceId_ERC721Enumerable);
742 		_registerInterface(InterfaceId_ERC721Metadata);
743 	  }
744 
745 	  /**
746 	   * @dev Gets the token name
747 	   * @return string representing the token name
748 	   */
749 	  function name() external view returns (string) {
750 		return name_;
751 	  }
752 
753 	  /**
754 	   * @dev Gets the token symbol
755 	   * @return string representing the token symbol
756 	   */
757 	  function symbol() external view returns (string) {
758 		return symbol_;
759 	  }
760 
761 	  /**
762 	   * @dev Returns an URI for a given token ID
763 	   * Throws if the token ID does not exist. May return an empty string.
764 	   * @param _tokenId uint256 ID of the token to query
765 	   */
766 	  function tokenURI(uint256 _tokenId) public view returns (string) {
767 		require(exists(_tokenId));
768 		return tokenURIs[_tokenId];
769 	  }
770 
771 	  /**
772 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
773 	   * @param _owner address owning the tokens list to be accessed
774 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
775 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
776 	   */
777 	  function tokenOfOwnerByIndex(
778 		address _owner,
779 		uint256 _index
780 	  )
781 		public
782 		view
783 		returns (uint256)
784 	  {
785 		require(_index < balanceOf(_owner));
786 		return ownedTokens[_owner][_index];
787 	  }
788 
789 	  /**
790 	   * @dev Gets the total amount of tokens stored by the contract
791 	   * @return uint256 representing the total amount of tokens
792 	   */
793 	  function totalSupply() public view returns (uint256) {
794 		return allTokens.length;
795 	  }
796 
797 	  /**
798 	   * @dev Gets the token ID at a given index of all the tokens in this contract
799 	   * Reverts if the index is greater or equal to the total number of tokens
800 	   * @param _index uint256 representing the index to be accessed of the tokens list
801 	   * @return uint256 token ID at the given index of the tokens list
802 	   */
803 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
804 		require(_index < totalSupply());
805 		return allTokens[_index];
806 	  }
807 
808 	  /**
809 	   * @dev Internal function to set the token URI for a given token
810 	   * Reverts if the token ID does not exist
811 	   * @param _tokenId uint256 ID of the token to set its URI
812 	   * @param _uri string URI to assign
813 	   */
814 	  function _setTokenURI(uint256 _tokenId, string _uri) internal {
815 		require(exists(_tokenId));
816 		tokenURIs[_tokenId] = _uri;
817 	  }
818 
819 	  /**
820 	   * @dev Internal function to add a token ID to the list of a given address
821 	   * @param _to address representing the new owner of the given token ID
822 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
823 	   */
824 	  function addTokenTo(address _to, uint256 _tokenId) internal {
825 		super.addTokenTo(_to, _tokenId);
826 		uint256 length = ownedTokens[_to].length;
827 		ownedTokens[_to].push(_tokenId);
828 		ownedTokensIndex[_tokenId] = length;
829 	  }
830 
831 	  /**
832 	   * @dev Internal function to remove a token ID from the list of a given address
833 	   * @param _from address representing the previous owner of the given token ID
834 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
835 	   */
836 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
837 		super.removeTokenFrom(_from, _tokenId);
838 
839 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
840 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
841 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
842 
843 		ownedTokens[_from][tokenIndex] = lastToken;
844 		ownedTokens[_from][lastTokenIndex] = 0;
845 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
846 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
847 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
848 
849 		ownedTokens[_from].length--;
850 		ownedTokensIndex[_tokenId] = 0;
851 		ownedTokensIndex[lastToken] = tokenIndex;
852 	  }
853 
854 	  /**
855 	   * @dev Internal function to mint a new token
856 	   * Reverts if the given token ID already exists
857 	   * @param _to address the beneficiary that will own the minted token
858 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
859 	   */
860 	  function _mint(address _to, uint256 _tokenId) internal {
861 		super._mint(_to, _tokenId);
862 
863 		allTokensIndex[_tokenId] = allTokens.length;
864 		allTokens.push(_tokenId);
865 	  }
866 
867 	  /**
868 	   * @dev Internal function to burn a specific token
869 	   * Reverts if the token does not exist
870 	   * @param _owner owner of the token to burn
871 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
872 	   */
873 	  function _burn(address _owner, uint256 _tokenId) internal {
874 		super._burn(_owner, _tokenId);
875 
876 		// Clear metadata (if any)
877 		if (bytes(tokenURIs[_tokenId]).length != 0) {
878 		  delete tokenURIs[_tokenId];
879 		}
880 
881 		// Reorg all tokens array
882 		uint256 tokenIndex = allTokensIndex[_tokenId];
883 		uint256 lastTokenIndex = allTokens.length.sub(1);
884 		uint256 lastToken = allTokens[lastTokenIndex];
885 
886 		allTokens[tokenIndex] = lastToken;
887 		allTokens[lastTokenIndex] = 0;
888 
889 		allTokens.length--;
890 		allTokensIndex[_tokenId] = 0;
891 		allTokensIndex[lastToken] = tokenIndex;
892 	  }
893 	}
894 
895 	contract WOBCore is ERC721Token, Ownable {
896 
897 	  /*** EVENTS ***/
898 	  /// The event emitted (useable by web3) when a token is purchased
899 	  event BoughtToken(address indexed buyer, uint256 tokenId);
900 	  event SetNFTbyTokenId(uint256 tokenId, bool result);
901 
902 	  constructor() ERC721Token("WBA", "WBA") public {
903 		// any init code when you deploy the contract would run here
904 	  }
905 
906 	  /// Requires the amount of Ether be at least or more of the currentPrice
907 	  /// @dev Creates an instance of an token and mints it to the purchaser
908 	  /// @param _tokenIdList The token identification as an integer
909 	  /// @param _tokenOwner owner of the token
910 	  function createToken (uint256[] _tokenIdList, address _tokenOwner) external payable onlyOwner{
911 	    
912 	    uint256 _tokenId;
913         
914         for (uint8 tokenNum=0; tokenNum < _tokenIdList.length; tokenNum++){
915             _tokenId = _tokenIdList[tokenNum];
916             
917             NFTtoken memory _NFTtoken = NFTtoken({
918                 attribute: "",
919                 birthTime: uint64(now)
920             });
921             
922             isNFTAlive[_tokenId] = true;
923     
924             tokdenIdToNFTindex[_tokenId] = allNFTtokens.length;
925             allNFTtokens.push(_NFTtoken);
926             
927 		    _mint(_tokenOwner, _tokenId);
928 		    emit BoughtToken(_tokenOwner, _tokenId);
929         }
930 	  }
931 	  
932     function getNFTbyTokenId(uint256 _tokenId) external view returns(string attribute, uint256 birthTime, bool status){
933 
934         require(exists(_tokenId));
935         uint256 _tokenIndex = tokdenIdToNFTindex[_tokenId];
936         
937         NFTtoken memory _NFTtoken = allNFTtokens[_tokenIndex];
938         
939         attribute = _NFTtoken.attribute;
940         birthTime = _NFTtoken.birthTime;
941         status = isNFTAlive[_tokenId];
942     }
943         
944     function setNFTbyTokenId(uint256 _tokenId, string attribute, bool status)external onlyOwner{
945         
946         require(exists(_tokenId));
947         require(isNFTAlive[_tokenId] == true);    
948         uint256 _tokenIndex = tokdenIdToNFTindex[_tokenId];
949         
950         NFTtoken storage _NFTtoken = allNFTtokens[_tokenIndex];
951 
952         _NFTtoken.attribute = attribute;
953         isNFTAlive[_tokenId] = status;
954         
955         emit SetNFTbyTokenId(_tokenId, status);
956     }
957 
958 	function myTokens(address _owner)
959 		external
960 		view
961 		returns (
962 		  uint256[]
963 		)
964 	  {
965 		return ownedTokens[_owner];
966 	  }
967 	  
968 	function setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
969 		super._setTokenURI(_tokenId, _uri);
970 	  }
971 }