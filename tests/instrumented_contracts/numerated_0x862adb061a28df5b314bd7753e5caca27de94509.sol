1 pragma solidity ^0.4.24;
2 
3 	/* 
4 		Big Thanks from the Document crew to chuckbergeron for providing 
5 		this template and Andrew Parker for creating the tutorial on building 
6 		NFT's. Also, thanks to the ethereum team for providing the ERC721 standard. 
7 		Code is Law! 
8 	*/
9 
10 	/**
11 	 * @title SafeMath
12 	 * @dev Math operations with safety checks that throw on error
13 	 */
14 	library SafeMath {
15 
16 	  /**
17 	  * @dev Multiplies two numbers, throws on overflow.
18 	  */
19 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21 		// benefit is lost if 'b' is also tested.
22 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23 		if (a == 0) {
24 		  return 0;
25 		}
26 
27 		c = a * b;
28 		assert(c / a == b);
29 		return c;
30 	  }
31 
32 	  /**
33 	  * @dev Integer division of two numbers, truncating the quotient.
34 	  */
35 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
36 		// assert(b > 0); // Solidity automatically throws when dividing by 0
37 		// uint256 c = a / b;
38 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 		return a / b;
40 	  }
41 
42 	  /**
43 	  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44 	  */
45 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46 		assert(b <= a);
47 		return a - b;
48 	  }
49 
50 	  /**
51 	  * @dev Adds two numbers, throws on overflow.
52 	  */
53 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54 		c = a + b;
55 		assert(c >= a);
56 		return c;
57 	  }
58 	}
59 
60 	/**
61 	 * @title ERC165
62 	 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
63 	 */
64 	interface ERC165 {
65 
66 	  /**
67 	   * @notice Query if a contract implements an interface
68 	   * @param _interfaceId The interface identifier, as specified in ERC-165
69 	   * @dev Interface identification is specified in ERC-165. This function
70 	   * uses less than 30,000 gas.
71 	   */
72 	  function supportsInterface(bytes4 _interfaceId)
73 		external
74 		view
75 		returns (bool);
76 	}
77 
78 	/**
79 	 * @title ERC721 token receiver interface
80 	 * @dev Interface for any contract that wants to support safeTransfers
81 	 * from ERC721 asset contracts.
82 	 */
83 	contract ERC721Receiver {
84 	  /**
85 	   * @dev Magic value to be returned upon successful reception of an NFT
86 	   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
87 	   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
88 	   */
89 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
90 
91 	  /**
92 	   * @notice Handle the receipt of an NFT
93 	   * @dev The ERC721 smart contract calls this function on the recipient
94 	   * after a `safetransfer`. This function MAY throw to revert and reject the
95 	   * transfer. Return of other than the magic value MUST result in the 
96 	   * transaction being reverted.
97 	   * Note: the contract address is always the message sender.
98 	   * @param _operator The address which called `safeTransferFrom` function
99 	   * @param _from The address which previously owned the token
100 	   * @param _tokenId The NFT identifier which is being transfered
101 	   * @param _data Additional data with no specified format
102 	   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
103 	   */
104 	  function onERC721Received(
105 		address _operator,
106 		address _from,
107 		uint256 _tokenId,
108 		bytes _data
109 	  )
110 		public
111 		returns(bytes4);
112 	}
113 
114 	/**
115 	 * Utility library of inline functions on addresses
116 	 */
117 	library AddressUtils {
118 
119 	  /**
120 	   * Returns whether the target address is a contract
121 	   * @dev This function will return false if invoked during the constructor of a contract,
122 	   * as the code is not actually created until after the constructor finishes.
123 	   * @param addr address to check
124 	   * @return whether the target address is a contract
125 	   */
126 	  function isContract(address addr) internal view returns (bool) {
127 		uint256 size;
128 		// XXX Currently there is no better way to check if there is a contract in an address
129 		// than to check the size of the code at that address.
130 		// See https://ethereum.stackexchange.com/a/14016/36603
131 		// for more details about how this works.
132 		// TODO Check this again before the Serenity release, because all addresses will be
133 		// contracts then.
134 		// solium-disable-next-line security/no-inline-assembly
135 		assembly { size := extcodesize(addr) }
136 		return size > 0;
137 	  }
138 
139 	}
140 
141 	/**
142 	 * @title Ownable
143 	 * @dev The Ownable contract has an owner address, and provides basic authorization control
144 	 * functions, this simplifies the implementation of "user permissions".
145 	 */
146 	contract Ownable {
147 	  address public owner;
148 
149 
150 	  event OwnershipRenounced(address indexed previousOwner);
151 	  event OwnershipTransferred(
152 		address indexed previousOwner,
153 		address indexed newOwner
154 	  );
155 
156 
157 	  /**
158 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
159 	   * account.
160 	   */
161 	  constructor() public {
162 		owner = msg.sender;
163 	  }
164 
165 	  /**
166 	   * @dev Throws if called by any account other than the owner.
167 	   */
168 	  modifier onlyOwner() {
169 		require(msg.sender == owner);
170 		_;
171 	  }
172 
173 	  /**
174 	   * @dev Allows the current owner to relinquish control of the contract.
175 	   * @notice Renouncing to ownership will leave the contract without an owner.
176 	   * It will not be possible to call the functions with the `onlyOwner`
177 	   * modifier anymore.
178 	   */
179 	  function renounceOwnership() public onlyOwner {
180 		emit OwnershipRenounced(owner);
181 		owner = address(0);
182 	  }
183 
184 	  /**
185 	   * @dev Allows the current owner to transfer control of the contract to a newOwner.
186 	   * @param _newOwner The address to transfer ownership to.
187 	   */
188 	  function transferOwnership(address _newOwner) public onlyOwner {
189 		_transferOwnership(_newOwner);
190 	  }
191 
192 	  /**
193 	   * @dev Transfers control of the contract to a newOwner.
194 	   * @param _newOwner The address to transfer ownership to.
195 	   */
196 	  function _transferOwnership(address _newOwner) internal {
197 		require(_newOwner != address(0));
198 		emit OwnershipTransferred(owner, _newOwner);
199 		owner = _newOwner;
200 	  }
201 	}
202 
203 	/**
204 	 * @title SupportsInterfaceWithLookup
205 	 * @author Matt Condon (@shrugs)
206 	 * @dev Implements ERC165 using a lookup table.
207 	 */
208 	contract SupportsInterfaceWithLookup is ERC165 {
209 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
210 	  /**
211 	   * 0x01ffc9a7 ===
212 	   *   bytes4(keccak256('supportsInterface(bytes4)'))
213 	   */
214 
215 	  /**
216 	   * @dev a mapping of interface id to whether or not it's supported
217 	   */
218 	  mapping(bytes4 => bool) internal supportedInterfaces;
219 
220 	  /**
221 	   * @dev A contract implementing SupportsInterfaceWithLookup
222 	   * implement ERC165 itself
223 	   */
224 	  constructor()
225 		public
226 	  {
227 		_registerInterface(InterfaceId_ERC165);
228 	  }
229 
230 	  /**
231 	   * @dev implement supportsInterface(bytes4) using a lookup table
232 	   */
233 	  function supportsInterface(bytes4 _interfaceId)
234 		external
235 		view
236 		returns (bool)
237 	  {
238 		return supportedInterfaces[_interfaceId];
239 	  }
240 
241 	  /**
242 	   * @dev private method for registering an interface
243 	   */
244 	  function _registerInterface(bytes4 _interfaceId)
245 		internal
246 	  {
247 		require(_interfaceId != 0xffffffff);
248 		supportedInterfaces[_interfaceId] = true;
249 	  }
250 	}
251 
252 	/**
253 	 * @title ERC721 Non-Fungible Token Standard basic interface
254 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
255 	 */
256 	contract ERC721Basic is ERC165 {
257 	  event Transfer(
258 		address indexed _from,
259 		address indexed _to,
260 		uint256 indexed _tokenId
261 	  );
262 	  event Approval(
263 		address indexed _owner,
264 		address indexed _approved,
265 		uint256 indexed _tokenId
266 	  );
267 	  event ApprovalForAll(
268 		address indexed _owner,
269 		address indexed _operator,
270 		bool _approved
271 	  );
272 
273 	  function balanceOf(address _owner) public view returns (uint256 _balance);
274 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
275 	  function exists(uint256 _tokenId) public view returns (bool _exists);
276 
277 	  function approve(address _to, uint256 _tokenId) public;
278 	  function getApproved(uint256 _tokenId)
279 		public view returns (address _operator);
280 
281 	  function setApprovalForAll(address _operator, bool _approved) public;
282 	  function isApprovedForAll(address _owner, address _operator)
283 		public view returns (bool);
284 
285 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
286 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
287 		public;
288 
289 	  function safeTransferFrom(
290 		address _from,
291 		address _to,
292 		uint256 _tokenId,
293 		bytes _data
294 	  )
295 		public;
296 	}
297 
298 	/**
299 	 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
300 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
301 	 */
302 	contract ERC721Enumerable is ERC721Basic {
303 	  function totalSupply() public view returns (uint256);
304 	  function tokenOfOwnerByIndex(
305 		address _owner,
306 		uint256 _index
307 	  )
308 		public
309 		view
310 		returns (uint256 _tokenId);
311 
312 	  function tokenByIndex(uint256 _index) public view returns (uint256);
313 	}
314 
315 
316 	/**
317 	 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
318 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
319 	 */
320 	contract ERC721Metadata is ERC721Basic {
321 	  function name() external view returns (string _name);
322 	  function symbol() external view returns (string _symbol);
323 	  function tokenURI(uint256 _tokenId) public view returns (string);
324 	}
325 
326 
327 	/**
328 	 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
329 	 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
330 	 */
331 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
332 	}
333 
334 	/**
335 	 * @title ERC721 Non-Fungible Token Standard basic implementation
336 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
337 	 */
338 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
339 
340 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
341 	  /*
342 	   * 0x80ac58cd ===
343 	   *   bytes4(keccak256('balanceOf(address)')) ^
344 	   *   bytes4(keccak256('ownerOf(uint256)')) ^
345 	   *   bytes4(keccak256('approve(address,uint256)')) ^
346 	   *   bytes4(keccak256('getApproved(uint256)')) ^
347 	   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
348 	   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
349 	   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
350 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
351 	   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
352 	   */
353 
354 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
355 	  /*
356 	   * 0x4f558e79 ===
357 	   *   bytes4(keccak256('exists(uint256)'))
358 	   */
359 
360 	  using SafeMath for uint256;
361 	  using AddressUtils for address;
362 
363 	  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
364 	  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
365 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
366 
367 	  // Mapping from token ID to owner
368 	  mapping (uint256 => address) internal tokenOwner;
369 
370 	  // Mapping from token ID to approved address
371 	  mapping (uint256 => address) internal tokenApprovals;
372 
373 	  // Mapping from owner to number of owned token
374 	  mapping (address => uint256) internal ownedTokensCount;
375 
376 	  // Mapping from owner to operator approvals
377 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
378 
379 	  /**
380 	   * @dev Guarantees msg.sender is owner of the given token
381 	   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
382 	   */
383 	  modifier onlyOwnerOf(uint256 _tokenId) {
384 		require(ownerOf(_tokenId) == msg.sender);
385 		_;
386 	  }
387 
388 	  /**
389 	   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
390 	   * @param _tokenId uint256 ID of the token to validate
391 	   */
392 	  modifier canTransfer(uint256 _tokenId) {
393 		require(isApprovedOrOwner(msg.sender, _tokenId));
394 		_;
395 	  }
396 
397 	  constructor()
398 		public
399 	  {
400 		// register the supported interfaces to conform to ERC721 via ERC165
401 		_registerInterface(InterfaceId_ERC721);
402 		_registerInterface(InterfaceId_ERC721Exists);
403 	  }
404 
405 	  /**
406 	   * @dev Gets the balance of the specified address
407 	   * @param _owner address to query the balance of
408 	   * @return uint256 representing the amount owned by the passed address
409 	   */
410 	  function balanceOf(address _owner) public view returns (uint256) {
411 		require(_owner != address(0));
412 		return ownedTokensCount[_owner];
413 	  }
414 
415 	  /**
416 	   * @dev Gets the owner of the specified token ID
417 	   * @param _tokenId uint256 ID of the token to query the owner of
418 	   * @return owner address currently marked as the owner of the given token ID
419 	   */
420 	  function ownerOf(uint256 _tokenId) public view returns (address) {
421 		address owner = tokenOwner[_tokenId];
422 		require(owner != address(0));
423 		return owner;
424 	  }
425 
426 	  /**
427 	   * @dev Returns whether the specified token exists
428 	   * @param _tokenId uint256 ID of the token to query the existence of
429 	   * @return whether the token exists
430 	   */
431 	  function exists(uint256 _tokenId) public view returns (bool) {
432 		address owner = tokenOwner[_tokenId];
433 		return owner != address(0);
434 	  }
435 
436 	  /**
437 	   * @dev Approves another address to transfer the given token ID
438 	   * The zero address indicates there is no approved address.
439 	   * There can only be one approved address per token at a given time.
440 	   * Can only be called by the token owner or an approved operator.
441 	   * @param _to address to be approved for the given token ID
442 	   * @param _tokenId uint256 ID of the token to be approved
443 	   */
444 	  function approve(address _to, uint256 _tokenId) public {
445 		address owner = ownerOf(_tokenId);
446 		require(_to != owner);
447 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
448 
449 		tokenApprovals[_tokenId] = _to;
450 		emit Approval(owner, _to, _tokenId);
451 	  }
452 
453 	  /**
454 	   * @dev Gets the approved address for a token ID, or zero if no address set
455 	   * @param _tokenId uint256 ID of the token to query the approval of
456 	   * @return address currently approved for the given token ID
457 	   */
458 	  function getApproved(uint256 _tokenId) public view returns (address) {
459 		return tokenApprovals[_tokenId];
460 	  }
461 
462 	  /**
463 	   * @dev Sets or unsets the approval of a given operator
464 	   * An operator is allowed to transfer all tokens of the sender on their behalf
465 	   * @param _to operator address to set the approval
466 	   * @param _approved representing the status of the approval to be set
467 	   */
468 	  function setApprovalForAll(address _to, bool _approved) public {
469 		require(_to != msg.sender);
470 		operatorApprovals[msg.sender][_to] = _approved;
471 		emit ApprovalForAll(msg.sender, _to, _approved);
472 	  }
473 
474 	  /**
475 	   * @dev Tells whether an operator is approved by a given owner
476 	   * @param _owner owner address which you want to query the approval of
477 	   * @param _operator operator address which you want to query the approval of
478 	   * @return bool whether the given operator is approved by the given owner
479 	   */
480 	  function isApprovedForAll(
481 		address _owner,
482 		address _operator
483 	  )
484 		public
485 		view
486 		returns (bool)
487 	  {
488 		return operatorApprovals[_owner][_operator];
489 	  }
490 
491 	  /**
492 	   * @dev Transfers the ownership of a given token ID to another address
493 	   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
494 	   * Requires the msg sender to be the owner, approved, or operator
495 	   * @param _from current owner of the token
496 	   * @param _to address to receive the ownership of the given token ID
497 	   * @param _tokenId uint256 ID of the token to be transferred
498 	  */
499 	  function transferFrom(
500 		address _from,
501 		address _to,
502 		uint256 _tokenId
503 	  )
504 		public
505 		canTransfer(_tokenId)
506 	  {
507 		require(_from != address(0));
508 		require(_to != address(0));
509 
510 		clearApproval(_from, _tokenId);
511 		removeTokenFrom(_from, _tokenId);
512 		addTokenTo(_to, _tokenId);
513 
514 		emit Transfer(_from, _to, _tokenId);
515 	  }
516 
517 	  /**
518 	   * @dev Safely transfers the ownership of a given token ID to another address
519 	   * If the target address is a contract, it must implement `onERC721Received`,
520 	   * which is called upon a safe transfer, and return the magic value
521 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
522 	   * the transfer is reverted.
523 	   *
524 	   * Requires the msg sender to be the owner, approved, or operator
525 	   * @param _from current owner of the token
526 	   * @param _to address to receive the ownership of the given token ID
527 	   * @param _tokenId uint256 ID of the token to be transferred
528 	  */
529 	  function safeTransferFrom(
530 		address _from,
531 		address _to,
532 		uint256 _tokenId
533 	  )
534 		public
535 		canTransfer(_tokenId)
536 	  {
537 		// solium-disable-next-line arg-overflow
538 		safeTransferFrom(_from, _to, _tokenId, "");
539 	  }
540 
541 	  /**
542 	   * @dev Safely transfers the ownership of a given token ID to another address
543 	   * If the target address is a contract, it must implement `onERC721Received`,
544 	   * which is called upon a safe transfer, and return the magic value
545 	   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
546 	   * the transfer is reverted.
547 	   * Requires the msg sender to be the owner, approved, or operator
548 	   * @param _from current owner of the token
549 	   * @param _to address to receive the ownership of the given token ID
550 	   * @param _tokenId uint256 ID of the token to be transferred
551 	   * @param _data bytes data to send along with a safe transfer check
552 	   */
553 	  function safeTransferFrom(
554 		address _from,
555 		address _to,
556 		uint256 _tokenId,
557 		bytes _data
558 	  )
559 		public
560 		canTransfer(_tokenId)
561 	  {
562 		transferFrom(_from, _to, _tokenId);
563 		// solium-disable-next-line arg-overflow
564 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
565 	  }
566 
567 	  /**
568 	   * @dev Returns whether the given spender can transfer a given token ID
569 	   * @param _spender address of the spender to query
570 	   * @param _tokenId uint256 ID of the token to be transferred
571 	   * @return bool whether the msg.sender is approved for the given token ID,
572 	   *  is an operator of the owner, or is the owner of the token
573 	   */
574 	  function isApprovedOrOwner(
575 		address _spender,
576 		uint256 _tokenId
577 	  )
578 		internal
579 		view
580 		returns (bool)
581 	  {
582 		address owner = ownerOf(_tokenId);
583 		// Disable solium check because of
584 		// https://github.com/duaraghav8/Solium/issues/175
585 		// solium-disable-next-line operator-whitespace
586 		return (
587 		  _spender == owner ||
588 		  getApproved(_tokenId) == _spender ||
589 		  isApprovedForAll(owner, _spender)
590 		);
591 	  }
592 
593 	  /**
594 	   * @dev Internal function to mint a new token
595 	   * Reverts if the given token ID already exists
596 	   * @param _to The address that will own the minted token
597 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
598 	   */
599 	  function _mint(address _to, uint256 _tokenId) internal {
600 		require(_to != address(0));
601 		addTokenTo(_to, _tokenId);
602 		emit Transfer(address(0), _to, _tokenId);
603 	  }
604 
605 	  /**
606 	   * @dev Internal function to burn a specific token
607 	   * Reverts if the token does not exist
608 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
609 	   */
610 	  function _burn(address _owner, uint256 _tokenId) internal {
611 		clearApproval(_owner, _tokenId);
612 		removeTokenFrom(_owner, _tokenId);
613 		emit Transfer(_owner, address(0), _tokenId);
614 	  }
615 
616 	  /**
617 	   * @dev Internal function to clear current approval of a given token ID
618 	   * Reverts if the given address is not indeed the owner of the token
619 	   * @param _owner owner of the token
620 	   * @param _tokenId uint256 ID of the token to be transferred
621 	   */
622 	  function clearApproval(address _owner, uint256 _tokenId) internal {
623 		require(ownerOf(_tokenId) == _owner);
624 		if (tokenApprovals[_tokenId] != address(0)) {
625 		  tokenApprovals[_tokenId] = address(0);
626 		}
627 	  }
628 
629 	  /**
630 	   * @dev Internal function to add a token ID to the list of a given address
631 	   * @param _to address representing the new owner of the given token ID
632 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
633 	   */
634 	  function addTokenTo(address _to, uint256 _tokenId) internal {
635 		require(tokenOwner[_tokenId] == address(0));
636 		tokenOwner[_tokenId] = _to;
637 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
638 	  }
639 
640 	  /**
641 	   * @dev Internal function to remove a token ID from the list of a given address
642 	   * @param _from address representing the previous owner of the given token ID
643 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
644 	   */
645 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
646 		require(ownerOf(_tokenId) == _from);
647 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
648 		tokenOwner[_tokenId] = address(0);
649 	  }
650 
651 	  /**
652 	   * @dev Internal function to invoke `onERC721Received` on a target address
653 	   * The call is not executed if the target address is not a contract
654 	   * @param _from address representing the previous owner of the given token ID
655 	   * @param _to target address that will receive the tokens
656 	   * @param _tokenId uint256 ID of the token to be transferred
657 	   * @param _data bytes optional data to send along with the call
658 	   * @return whether the call correctly returned the expected magic value
659 	   */
660 	  function checkAndCallSafeTransfer(
661 		address _from,
662 		address _to,
663 		uint256 _tokenId,
664 		bytes _data
665 	  )
666 		internal
667 		returns (bool)
668 	  {
669 		if (!_to.isContract()) {
670 		  return true;
671 		}
672 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
673 		  msg.sender, _from, _tokenId, _data);
674 		return (retval == ERC721_RECEIVED);
675 	  }
676 	}
677 
678 	/**
679 	 * @title Full ERC721 Token
680 	 * This implementation includes all the required and some optional functionality of the ERC721 standard
681 	 * Moreover, it includes approve all functionality using operator terminology
682 	 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
683 	 */
684 	contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
685 
686 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
687 	  /**
688 	   * 0x780e9d63 ===
689 	   *   bytes4(keccak256('totalSupply()')) ^
690 	   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
691 	   *   bytes4(keccak256('tokenByIndex(uint256)'))
692 	   */
693 
694 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
695 	  /**
696 	   * 0x5b5e139f ===
697 	   *   bytes4(keccak256('name()')) ^
698 	   *   bytes4(keccak256('symbol()')) ^
699 	   *   bytes4(keccak256('tokenURI(uint256)'))
700 	   */
701 
702 	  // Token name
703 	  string internal name_;
704 
705 	  // Token symbol
706 	  string internal symbol_;
707 
708 	  // Mapping from owner to list of owned token IDs
709 	  mapping(address => uint256[]) internal ownedTokens;
710 
711 	  // Mapping from token ID to index of the owner tokens list
712 	  mapping(uint256 => uint256) internal ownedTokensIndex;
713 
714 	  // Array with all token ids, used for enumeration
715 	  uint256[] internal allTokens;
716 
717 	  // Mapping from token id to position in the allTokens array
718 	  mapping(uint256 => uint256) internal allTokensIndex;
719 
720 	  // Optional mapping for token URIs
721 	  mapping(uint256 => string) internal tokenURIs;
722 
723 	  /**
724 	   * @dev Constructor function
725 	   */
726 	  constructor(string _name, string _symbol) public {
727 		name_ = _name;
728 		symbol_ = _symbol;
729 
730 		// register the supported interfaces to conform to ERC721 via ERC165
731 		_registerInterface(InterfaceId_ERC721Enumerable);
732 		_registerInterface(InterfaceId_ERC721Metadata);
733 	  }
734 
735 	  /**
736 	   * @dev Gets the token name
737 	   * @return string representing the token name
738 	   */
739 	  function name() external view returns (string) {
740 		return name_;
741 	  }
742 
743 	  /**
744 	   * @dev Gets the token symbol
745 	   * @return string representing the token symbol
746 	   */
747 	  function symbol() external view returns (string) {
748 		return symbol_;
749 	  }
750 
751 	  /**
752 	   * @dev Returns an URI for a given token ID
753 	   * Throws if the token ID does not exist. May return an empty string.
754 	   * @param _tokenId uint256 ID of the token to query
755 	   */
756 	  function tokenURI(uint256 _tokenId) public view returns (string) {
757 		require(exists(_tokenId));
758 		return tokenURIs[_tokenId];
759 	  }
760 
761 	  /**
762 	   * @dev Gets the token ID at a given index of the tokens list of the requested owner
763 	   * @param _owner address owning the tokens list to be accessed
764 	   * @param _index uint256 representing the index to be accessed of the requested tokens list
765 	   * @return uint256 token ID at the given index of the tokens list owned by the requested address
766 	   */
767 	  function tokenOfOwnerByIndex(
768 		address _owner,
769 		uint256 _index
770 	  )
771 		public
772 		view
773 		returns (uint256)
774 	  {
775 		require(_index < balanceOf(_owner));
776 		return ownedTokens[_owner][_index];
777 	  }
778 
779 	  /**
780 	   * @dev Gets the total amount of tokens stored by the contract
781 	   * @return uint256 representing the total amount of tokens
782 	   */
783 	  function totalSupply() public view returns (uint256) {
784 		return allTokens.length;
785 	  }
786 
787 	  /**
788 	   * @dev Gets the token ID at a given index of all the tokens in this contract
789 	   * Reverts if the index is greater or equal to the total number of tokens
790 	   * @param _index uint256 representing the index to be accessed of the tokens list
791 	   * @return uint256 token ID at the given index of the tokens list
792 	   */
793 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
794 		require(_index < totalSupply());
795 		return allTokens[_index];
796 	  }
797 
798 	  /**
799 	   * @dev Internal function to set the token URI for a given token
800 	   * Reverts if the token ID does not exist
801 	   * @param _tokenId uint256 ID of the token to set its URI
802 	   * @param _uri string URI to assign
803 	   */
804 	  function _setTokenURI(uint256 _tokenId, string _uri) internal {
805 		require(exists(_tokenId));
806 		tokenURIs[_tokenId] = _uri;
807 	  }
808 
809 	  /**
810 	   * @dev Internal function to add a token ID to the list of a given address
811 	   * @param _to address representing the new owner of the given token ID
812 	   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
813 	   */
814 	  function addTokenTo(address _to, uint256 _tokenId) internal {
815 		super.addTokenTo(_to, _tokenId);
816 		uint256 length = ownedTokens[_to].length;
817 		ownedTokens[_to].push(_tokenId);
818 		ownedTokensIndex[_tokenId] = length;
819 	  }
820 
821 	  /**
822 	   * @dev Internal function to remove a token ID from the list of a given address
823 	   * @param _from address representing the previous owner of the given token ID
824 	   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
825 	   */
826 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
827 		super.removeTokenFrom(_from, _tokenId);
828 
829 		uint256 tokenIndex = ownedTokensIndex[_tokenId];
830 		uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
831 		uint256 lastToken = ownedTokens[_from][lastTokenIndex];
832 
833 		ownedTokens[_from][tokenIndex] = lastToken;
834 		ownedTokens[_from][lastTokenIndex] = 0;
835 		// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
836 		// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
837 		// the lastToken to the first position, and then dropping the element placed in the last position of the list
838 
839 		ownedTokens[_from].length--;
840 		ownedTokensIndex[_tokenId] = 0;
841 		ownedTokensIndex[lastToken] = tokenIndex;
842 	  }
843 
844 	  /**
845 	   * @dev Internal function to mint a new token
846 	   * Reverts if the given token ID already exists
847 	   * @param _to address the beneficiary that will own the minted token
848 	   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
849 	   */
850 	  function _mint(address _to, uint256 _tokenId) internal {
851 		super._mint(_to, _tokenId);
852 
853 		allTokensIndex[_tokenId] = allTokens.length;
854 		allTokens.push(_tokenId);
855 	  }
856 
857 	  /**
858 	   * @dev Internal function to burn a specific token
859 	   * Reverts if the token does not exist
860 	   * @param _owner owner of the token to burn
861 	   * @param _tokenId uint256 ID of the token being burned by the msg.sender
862 	   */
863 	  function _burn(address _owner, uint256 _tokenId) internal {
864 		super._burn(_owner, _tokenId);
865 
866 		// Clear metadata (if any)
867 		if (bytes(tokenURIs[_tokenId]).length != 0) {
868 		  delete tokenURIs[_tokenId];
869 		}
870 
871 		// Reorg all tokens array
872 		uint256 tokenIndex = allTokensIndex[_tokenId];
873 		uint256 lastTokenIndex = allTokens.length.sub(1);
874 		uint256 lastToken = allTokens[lastTokenIndex];
875 
876 		allTokens[tokenIndex] = lastToken;
877 		allTokens[lastTokenIndex] = 0;
878 
879 		allTokens.length--;
880 		allTokensIndex[_tokenId] = 0;
881 		allTokensIndex[lastToken] = tokenIndex;
882 	  }
883 
884 	}
885 
886 	contract Document is ERC721Token, Ownable {
887 
888 	  /*** EVENTS ***/
889 	  /// The event emitted (useable by web3) when a token is purchased
890 	  event BoughtToken(address indexed buyer, uint256 tokenId);
891 
892 	  /*** CONSTANTS ***/
893 	  uint8 constant TITLE_MIN_LENGTH = 1;
894 	  uint8 constant TITLE_MAX_LENGTH = 64;
895 	  uint256 constant DESCRIPTION_MIN_LENGTH = 1;
896 	  uint256 constant DESCRIPTION_MAX_LENGTH = 10000;
897 
898 	  /*** DATA TYPES ***/
899 
900 	  /// Price set by contract owner for each token in Wei.
901 	  /// @dev If you'd like a different price for each token type, you will
902 	  ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
903 	  uint256 currentPrice = 0;
904 
905 	  /// The token type (1 for idea, 2 for belonging, etc)
906 	  mapping(uint256 => uint256) tokenTypes;
907 
908 	  /// The title of the token
909 	  mapping(uint256 => string) tokenTitles;
910 	  
911 	  /// The description of the token
912 	  mapping(uint256 => string) tokenDescription;
913 
914 	  constructor() ERC721Token("Document", "DQMT") public {
915 		// any init code when you deploy the contract would run here
916 	  }
917 
918 	  /// Requires the amount of Ether be at least or more of the currentPrice
919 	  /// @dev Creates an instance of an token and mints it to the purchaser
920 	  /// @param _type The token type as an integer
921 	  /// @param _title The short title of the token
922 	  /// @param _description Description of the token
923 	  function buyToken (
924 		uint256 _type,
925 		string _title,
926 		string _description
927 	  ) external payable {
928 		bytes memory _titleBytes = bytes(_title);
929 		require(_titleBytes.length >= TITLE_MIN_LENGTH, "Title is too short");
930 		require(_titleBytes.length <= TITLE_MAX_LENGTH, "Title is too long");
931 		
932 		bytes memory _descriptionBytes = bytes(_description);
933 		require(_descriptionBytes.length >= DESCRIPTION_MIN_LENGTH, "Description is too short");
934 		require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
935 		require(msg.value >= currentPrice, "Amount of Ether sent too small");
936 
937 		uint256 index = allTokens.length + 1;
938 
939 		_mint(msg.sender, index);
940 
941 		tokenTypes[index] = _type;
942 		tokenTitles[index] = _title;
943 		tokenDescription[index] = _description;
944 
945 		emit BoughtToken(msg.sender, index);
946 	  }
947 
948 	  /**
949 	   * @dev Returns all of the tokens that the user owns
950 	   * @return An array of token indices
951 	   */
952 	  function myTokens()
953 		external
954 		view
955 		returns (
956 		  uint256[]
957 		)
958 	  {
959 		return ownedTokens[msg.sender];
960 	  }
961 
962 	  /// @notice Returns all the relevant information about a specific token
963 	  /// @param _tokenId The ID of the token of interest
964 	  function viewToken(uint256 _tokenId)
965 		external
966 		view
967 		returns (
968 		  uint256 tokenType_,
969 		  string tokenTitle_,
970 		  string tokenDescription_
971 	  ) {
972 		  tokenType_ = tokenTypes[_tokenId];
973 		  tokenTitle_ = tokenTitles[_tokenId];
974 		  tokenDescription_ = tokenDescription[_tokenId];
975 	  }
976 
977 	  /// @notice Allows the owner of this contract to set the currentPrice for each token
978 	  function setCurrentPrice(uint256 newPrice)
979 		public
980 		onlyOwner
981 	  {
982 		  currentPrice = newPrice;
983 	  }
984 
985 	  /// @notice Returns the currentPrice for each token
986 	  function getCurrentPrice()
987 		external
988 		view
989 		returns (
990 		uint256 price
991 	  ) {
992 		  price = currentPrice;
993 	  }
994 	  /// @notice allows the owner of this contract to destroy the contract
995 	   function kill() public {
996 		  if(msg.sender == owner) selfdestruct(owner);
997 	   }  
998 	}