1 pragma solidity ^0.4.25;
2 
3 /* 
4 	********************
5 	- HashKings Planet -
6 	********************
7 	v1.0
8 	
9 	Daniel Pittman - Qwoyn.io
10 	
11 	*Note:
12 	*
13 	*Holds all the plots from HashKings
14 	***********************************
15 	
16 */
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28 	// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29 	// benefit is lost if 'b' is also tested.
30 	// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31 	if (a == 0) {
32 	  return 0;
33 	}
34 
35 	c = a * b;
36 	assert(c / a == b);
37 	return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44 	// assert(b > 0); // Solidity automatically throws when dividing by 0
45 	// uint256 c = a / b;
46 	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 	return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54 	assert(b <= a);
55 	return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62 	c = a + b;
63 	assert(c >= a);
64 	return c;
65   }
66 }
67 
68 /**
69 * @title Helps contracts guard against reentrancy attacks.
70 * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
71 * @dev If you mark a function `nonReentrant`, you should also
72 * mark it `external`.
73 */
74 contract ReentrancyGuard {
75 
76 /// @dev counter to allow mutex lock with only one SSTORE operation
77 uint256 private guardCounter = 1;
78 
79 /**
80 * @dev Prevents a contract from calling itself, directly or indirectly.
81 * If you mark a function `nonReentrant`, you should also
82 * mark it `external`. Calling one `nonReentrant` function from
83 * another is not supported. Instead, you can implement a
84 * `private` function doing the actual work, and an `external`
85 * wrapper marked as `nonReentrant`.
86 */
87 	modifier nonReentrant() {
88 		guardCounter += 1;
89 		uint256 localCounter = guardCounter;
90 		_;
91 		require(localCounter == guardCounter);
92 	}
93 }
94 
95 /**
96  * @title ERC165
97  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
98  */
99 interface ERC165 {
100 
101   /**
102    * @notice Query if a contract implements an interface
103    * @param _interfaceId The interface identifier, as specified in ERC-165
104    * @dev Interface identification is specified in ERC-165. This function
105    * uses less than 30,000 gas.
106    */
107   function supportsInterface(bytes4 _interfaceId)
108 	external
109 	view
110 	returns (bool);
111 }
112 
113 /**
114  * @title ERC721 token receiver interface
115  * @dev Interface for any contract that wants to support safeTransfers
116  * from ERC721 asset contracts.
117  */
118 contract ERC721Receiver {
119   /**
120    * @dev Magic value to be returned upon successful reception of an NFT
121    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
122    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
123    */
124   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
125 
126   /**
127    * @notice Handle the receipt of an NFT
128    * @dev The ERC721 smart contract calls this function on the recipient
129    * after a `safetransfer`. This function MAY throw to revert and reject the
130    * transfer. Return of other than the magic value MUST result in the 
131    * transaction being reverted.
132    * Note: the contract address is always the message sender.
133    * @param _operator The address which called `safeTransferFrom` function
134    * @param _from The address which previously owned the token
135    * @param _tokenId The NFT identifier which is being transfered
136    * @param _data Additional data with no specified format
137    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
138    */
139   function onERC721Received(
140 	address _operator,
141 	address _from,
142 	uint256 _tokenId,
143 	bytes _data
144   )
145 	public
146 	returns(bytes4);
147 }
148 
149 /**
150  * Utility library of inline functions on addresses
151  */
152 library AddressUtils {
153 
154   /**
155    * Returns whether the target address is a contract
156    * @dev This function will return false if invoked during the constructor of a contract,
157    * as the code is not actually created until after the constructor finishes.
158    * @param addr address to check
159    * @return whether the target address is a contract
160    */
161   function isContract(address addr) internal view returns (bool) {
162 	uint256 size;
163 	// XXX Currently there is no better way to check if there is a contract in an address
164 	// than to check the size of the code at that address.
165 	// See https://ethereum.stackexchange.com/a/14016/36603
166 	// for more details about how this works.
167 	// TODO Check this again before the Serenity release, because all addresses will be
168 	// contracts then.
169 	// solium-disable-next-line security/no-inline-assembly
170 	assembly { size := extcodesize(addr) }
171 	return size > 0;
172   }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions". 
180  */
181 contract Ownable {
182   address public owner;
183 
184 
185   event OwnershipRenounced(address indexed previousOwner);
186   event OwnershipTransferred(
187 	address indexed previousOwner,
188 	address indexed newOwner
189   );
190 
191 
192   /**
193    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194    * account.
195    */
196   constructor() public {
197 	owner = msg.sender;
198   }
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204 	require(msg.sender == owner);
205 	_;
206   }
207 
208   /**
209    * @dev Allows the current owner to relinquish control of the contract.
210    * @notice Renouncing to ownership will leave the contract without an owner.
211    * It will not be possible to call the functions with the `onlyOwner`
212    * modifier anymore.
213    */
214   function renounceOwnership() public onlyOwner {
215 	emit OwnershipRenounced(owner);
216 	owner = address(0);
217   }
218 
219   /**
220    * @dev Allows the current owner to transfer control of the contract to a newOwner.
221    * @param _newOwner The address to transfer ownership to.
222    */
223   function transferOwnership(address _newOwner) public onlyOwner {
224 	_transferOwnership(_newOwner);
225   }
226 
227   /**
228    * @dev Transfers control of the contract to a newOwner.
229    * @param _newOwner The address to transfer ownership to.
230    */
231   function _transferOwnership(address _newOwner) internal onlyOwner {
232 	require(_newOwner != address(0));
233 	emit OwnershipTransferred(owner, _newOwner);
234 	owner = _newOwner;
235   }
236 }
237 
238 contract Fallback is Ownable {
239 
240   function withdraw() public onlyOwner {
241 	owner.transfer(address(this).balance);
242   }
243 }
244 
245 /**
246  * @title SupportsInterfaceWithLookup
247  * @author Matt Condon (@shrugs)
248  * @dev Implements ERC165 using a lookup table.
249  */
250 contract SupportsInterfaceWithLookup is ERC165 {
251   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
252   /**
253    * 0x01ffc9a7 ===
254    *   bytes4(keccak256('supportsInterface(bytes4)'))
255    */
256 
257   /**
258    * @dev a mapping of interface id to whether or not it's supported
259    */
260   mapping(bytes4 => bool) internal supportedInterfaces;
261 
262   /**
263    * @dev A contract implementing SupportsInterfaceWithLookup
264    * implement ERC165 itself
265    */
266   constructor()
267 	public
268   {
269 	_registerInterface(InterfaceId_ERC165);
270   }
271 
272   /**
273    * @dev implement supportsInterface(bytes4) using a lookup table
274    */
275   function supportsInterface(bytes4 _interfaceId)
276 	external
277 	view
278 	returns (bool)
279   {
280 	return supportedInterfaces[_interfaceId];
281   }
282 
283   /**
284    * @dev private method for registering an interface
285    */
286   function _registerInterface(bytes4 _interfaceId)
287 	internal
288   {
289 	require(_interfaceId != 0xffffffff);
290 	supportedInterfaces[_interfaceId] = true;
291   }
292 }
293 
294 /**
295  * @title ERC721 Non-Fungible Token Standard basic interface
296  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297  */
298 contract ERC721Basic is ERC165 {
299   event Transfer(
300 	address indexed _from,
301 	address indexed _to,
302 	uint256 indexed _tokenId
303   );
304   event Approval(
305 	address indexed _owner,
306 	address indexed _approved,
307 	uint256 indexed _tokenId
308   );
309   event ApprovalForAll(
310 	address indexed _owner,
311 	address indexed _operator,
312 	bool _approved
313   );
314 
315   function balanceOf(address _owner) public view returns (uint256 _balance);
316   function ownerOf(uint256 _tokenId) public view returns (address _owner);
317   function exists(uint256 _tokenId) public view returns (bool _exists);
318 
319   function approve(address _to, uint256 _tokenId) public;
320   function getApproved(uint256 _tokenId)
321 	public view returns (address _operator);
322 
323   function setApprovalForAll(address _operator, bool _approved) public;
324   function isApprovedForAll(address _owner, address _operator)
325 	public view returns (bool);
326 
327   function transferFrom(address _from, address _to, uint256 _tokenId) public;
328   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
329 	public;
330 
331   function safeTransferFrom(
332 	address _from,
333 	address _to,
334 	uint256 _tokenId,
335 	bytes _data
336   )
337 	public;
338 }
339 
340 /**
341  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
342  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
343  */
344 contract ERC721Enumerable is ERC721Basic {
345   function totalSupply() public view returns (uint256);
346   function tokenOfOwnerByIndex(
347 	address _owner,
348 	uint256 _index
349   )
350 	public
351 	view
352 	returns (uint256 _tokenId);
353 
354   function tokenByIndex(uint256 _index) public view returns (uint256);
355 }
356 
357 
358 /**
359  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
360  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
361  */
362 contract ERC721Metadata is ERC721Basic {
363   function name() external view returns (string _name);
364   function symbol() external view returns (string _symbol);
365   function tokenURI(uint256 _tokenId) public view returns (string);
366 }
367 
368 
369 /**
370  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
371  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
372  */
373 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
374 }
375 
376 /**
377  * @title ERC721 Non-Fungible Token Standard basic implementation
378  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
379  */
380 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
381 
382   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
383   /*
384    * 0x80ac58cd ===
385    *   bytes4(keccak256('balanceOf(address)')) ^
386    *   bytes4(keccak256('ownerOf(uint256)')) ^
387    *   bytes4(keccak256('approve(address,uint256)')) ^
388    *   bytes4(keccak256('getApproved(uint256)')) ^
389    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
390    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
391    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
392    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
393    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
394    */
395 
396   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
397   /*
398    * 0x4f558e79 ===
399    *   bytes4(keccak256('exists(uint256)'))
400    */
401 
402   using SafeMath for uint256;
403   using AddressUtils for address;
404 
405   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
406   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
407   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
408 
409   // Mapping from token ID to owner
410   mapping (uint256 => address) internal tokenOwner;
411 
412   // Mapping from token ID to approved address
413   mapping (uint256 => address) internal tokenApprovals;
414 
415   // Mapping from owner to number of owned token
416   mapping (address => uint256) internal ownedTokensCount;
417 
418   // Mapping from owner to operator approvals
419   mapping (address => mapping (address => bool)) internal operatorApprovals;
420 
421   /**
422    * @dev Guarantees msg.sender is owner of the given token
423    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
424    */
425   modifier onlyOwnerOf(uint256 _tokenId) {
426 	require(ownerOf(_tokenId) == msg.sender);
427 	_;
428   }
429 
430   /**
431    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
432    * @param _tokenId uint256 ID of the token to validate
433    */
434   modifier canTransfer(uint256 _tokenId) {
435 	require(isApprovedOrOwner(msg.sender, _tokenId));
436 	_;
437   }
438 
439   constructor()
440 	public
441   {
442 	// register the supported interfaces to conform to ERC721 via ERC165
443 	_registerInterface(InterfaceId_ERC721);
444 	_registerInterface(InterfaceId_ERC721Exists);
445   }
446 
447   /**
448    * @dev Gets the balance of the specified address
449    * @param _owner address to query the balance of
450    * @return uint256 representing the amount owned by the passed address
451    */
452   function balanceOf(address _owner) public view returns (uint256) {
453 	require(_owner != address(0));
454 	return ownedTokensCount[_owner];
455   }
456 
457   /**
458    * @dev Gets the owner of the specified token ID
459    * @param _tokenId uint256 ID of the token to query the owner of
460    * @return owner address currently marked as the owner of the given token ID
461    */
462   function ownerOf(uint256 _tokenId) public view returns (address) {
463 	address owner = tokenOwner[_tokenId];
464 	require(owner != address(0));
465 	return owner;
466   }
467 
468   /**
469    * @dev Returns whether the specified token exists
470    * @param _tokenId uint256 ID of the token to query the existence of
471    * @return whether the token exists
472    */
473   function exists(uint256 _tokenId) public view returns (bool) {
474 	address owner = tokenOwner[_tokenId];
475 	return owner != address(0);
476   }
477 
478   /**
479    * @dev Approves another address to transfer the given token ID
480    * The zero address indicates there is no approved address.
481    * There can only be one approved address per token at a given time.
482    * Can only be called by the token owner or an approved operator.
483    * @param _to address to be approved for the given token ID
484    * @param _tokenId uint256 ID of the token to be approved
485    */
486   function approve(address _to, uint256 _tokenId) public {
487 	address owner = ownerOf(_tokenId);
488 	require(_to != owner);
489 	require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
490 
491 	tokenApprovals[_tokenId] = _to;
492 	emit Approval(owner, _to, _tokenId);
493   }
494 
495   /**
496    * @dev Gets the approved address for a token ID, or zero if no address set
497    * @param _tokenId uint256 ID of the token to query the approval of
498    * @return address currently approved for the given token ID
499    */
500   function getApproved(uint256 _tokenId) public view returns (address) {
501 	return tokenApprovals[_tokenId];
502   }
503 
504   /**
505    * @dev Sets or unsets the approval of a given operator
506    * An operator is allowed to transfer all tokens of the sender on their behalf
507    * @param _to operator address to set the approval
508    * @param _approved representing the status of the approval to be set
509    */
510   function setApprovalForAll(address _to, bool _approved) public {
511 	require(_to != msg.sender);
512 	operatorApprovals[msg.sender][_to] = _approved;
513 	emit ApprovalForAll(msg.sender, _to, _approved);
514   }
515 
516   /**
517    * @dev Tells whether an operator is approved by a given owner
518    * @param _owner owner address which you want to query the approval of
519    * @param _operator operator address which you want to query the approval of
520    * @return bool whether the given operator is approved by the given owner
521    */
522   function isApprovedForAll(
523 	address _owner,
524 	address _operator
525   )
526 	public
527 	view
528 	returns (bool)
529   {
530 	return operatorApprovals[_owner][_operator];
531   }
532 
533   /**
534    * @dev Transfers the ownership of a given token ID to another address
535    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
536    * Requires the msg sender to be the owner, approved, or operator
537    * @param _from current owner of the token
538    * @param _to address to receive the ownership of the given token ID
539    * @param _tokenId uint256 ID of the token to be transferred
540   */
541   function transferFrom(
542 	address _from,
543 	address _to,
544 	uint256 _tokenId
545   )
546 	public
547 	canTransfer(_tokenId)
548   {
549 	require(_from != address(0));
550 	require(_to != address(0));
551 
552 	clearApproval(_from, _tokenId);
553 	removeTokenFrom(_from, _tokenId);
554 	addTokenTo(_to, _tokenId);
555 
556 	emit Transfer(_from, _to, _tokenId);
557   }
558 
559   /**
560    * @dev Safely transfers the ownership of a given token ID to another address
561    * If the target address is a contract, it must implement `onERC721Received`,
562    * which is called upon a safe transfer, and return the magic value
563    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
564    * the transfer is reverted.
565    *
566    * Requires the msg sender to be the owner, approved, or operator
567    * @param _from current owner of the token
568    * @param _to address to receive the ownership of the given token ID
569    * @param _tokenId uint256 ID of the token to be transferred
570   */
571   function safeTransferFrom(
572 	address _from,
573 	address _to,
574 	uint256 _tokenId
575   )
576 	public
577 	canTransfer(_tokenId)
578   {
579 	// solium-disable-next-line arg-overflow
580 	safeTransferFrom(_from, _to, _tokenId, "");
581   }
582 
583   /**
584    * @dev Safely transfers the ownership of a given token ID to another address
585    * If the target address is a contract, it must implement `onERC721Received`,
586    * which is called upon a safe transfer, and return the magic value
587    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
588    * the transfer is reverted.
589    * Requires the msg sender to be the owner, approved, or operator
590    * @param _from current owner of the token
591    * @param _to address to receive the ownership of the given token ID
592    * @param _tokenId uint256 ID of the token to be transferred
593    * @param _data bytes data to send along with a safe transfer check
594    */
595   function safeTransferFrom(
596 	address _from,
597 	address _to,
598 	uint256 _tokenId,
599 	bytes _data
600   )
601 	public
602 	canTransfer(_tokenId)
603   {
604 	transferFrom(_from, _to, _tokenId);
605 	// solium-disable-next-line arg-overflow
606 	require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
607   }
608 
609   /**
610    * @dev Returns whether the given spender can transfer a given token ID
611    * @param _spender address of the spender to query
612    * @param _tokenId uint256 ID of the token to be transferred
613    * @return bool whether the msg.sender is approved for the given token ID,
614    *  is an operator of the owner, or is the owner of the token
615    */
616   function isApprovedOrOwner(
617 	address _spender,
618 	uint256 _tokenId
619   )
620 	internal
621 	view
622 	returns (bool)
623   {
624 	address owner = ownerOf(_tokenId);
625 	// Disable solium check because of
626 	// https://github.com/duaraghav8/Solium/issues/175
627 	// solium-disable-next-line operator-whitespace
628 	return (
629 	  _spender == owner ||
630 	  getApproved(_tokenId) == _spender ||
631 	  isApprovedForAll(owner, _spender)
632 	);
633   }
634 
635   /**
636    * @dev Internal function to mint a new token
637    * Reverts if the given token ID already exists
638    * @param _to The address that will own the minted token
639    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
640    */
641   function _mint(address _to, uint256 _tokenId) internal {
642 	require(_to != address(0));
643 	addTokenTo(_to, _tokenId);
644 	emit Transfer(address(0), _to, _tokenId);
645   }
646 
647   /**
648    * @dev Internal function to clear current approval of a given token ID
649    * Reverts if the given address is not indeed the owner of the token
650    * @param _owner owner of the token
651    * @param _tokenId uint256 ID of the token to be transferred
652    */
653   function clearApproval(address _owner, uint256 _tokenId) internal {
654 	require(ownerOf(_tokenId) == _owner);
655 	if (tokenApprovals[_tokenId] != address(0)) {
656 	  tokenApprovals[_tokenId] = address(0);
657 	}
658   }
659 
660   /**
661    * @dev Internal function to add a token ID to the list of a given address
662    * @param _to address representing the new owner of the given token ID
663    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
664    */
665   function addTokenTo(address _to, uint256 _tokenId) internal {
666 	require(tokenOwner[_tokenId] == address(0));
667 	tokenOwner[_tokenId] = _to;
668 	ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
669   }
670 
671   /**
672    * @dev Internal function to remove a token ID from the list of a given address
673    * @param _from address representing the previous owner of the given token ID
674    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
675    */
676   function removeTokenFrom(address _from, uint256 _tokenId) internal {
677 	require(ownerOf(_tokenId) == _from);
678 	ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
679 	tokenOwner[_tokenId] = address(0);
680   }
681 
682   /**
683    * @dev Internal function to invoke `onERC721Received` on a target address
684    * The call is not executed if the target address is not a contract
685    * @param _from address representing the previous owner of the given token ID
686    * @param _to target address that will receive the tokens
687    * @param _tokenId uint256 ID of the token to be transferred
688    * @param _data bytes optional data to send along with the call
689    * @return whether the call correctly returned the expected magic value
690    */
691   function checkAndCallSafeTransfer(
692 	address _from,
693 	address _to,
694 	uint256 _tokenId,
695 	bytes _data
696   )
697 	internal
698 	returns (bool)
699   {
700 	if (!_to.isContract()) {
701 	  return true;
702 	}
703 	bytes4 retval = ERC721Receiver(_to).onERC721Received(
704 	  msg.sender, _from, _tokenId, _data);
705 	return (retval == ERC721_RECEIVED);
706   }
707 }
708 
709 /**
710  * @title Full ERC721 Token
711  * This implementation includes all the required and some optional functionality of the ERC721 standard
712  * Moreover, it includes approve all functionality using operator terminology
713  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
714  */
715 contract HashKingsPlanet is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721, Ownable, Fallback {
716 
717   /*** EVENTS ***/
718   /// The event emitted (useable by web3) when a token is purchased
719   event BoughtToken(address indexed buyer, uint256 tokenId);
720 
721   /*** CONSTANTS ***/
722   string public constant company = "Qwoyn, LLC ";
723   string public constant contact = "https://qwoyn.io";
724   string public constant author  = "Daniel Pittman";
725 
726   
727   uint8 constant TITLE_MAX_LENGTH = 64;
728   uint256 constant DESCRIPTION_MAX_LENGTH = 100000;
729 
730   /*** DATA TYPES ***/
731 
732   /// Price set by contract owner for each token in Wei
733   /// @dev If you'd like a different price for each token type, you will
734   ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
735   uint256 currentPrice = 0;
736   
737   mapping(uint256 => string)  tokenTitles;	  
738   mapping(uint256 => string)  tokenDescriptions;
739   
740 
741   constructor(string _name, string _symbol) public {
742 	name_ = _name;
743 	symbol_ = _symbol;
744 
745 	// register the supported interfaces to conform to ERC721 via ERC165
746 	_registerInterface(InterfaceId_ERC721Enumerable);
747 	_registerInterface(InterfaceId_ERC721Metadata);
748   }
749 
750   /// Requires the amount of Ether be at least or more of the currentPrice
751   /// @dev Creates an instance of an token and mints it to the purchaser
752   /// @param _type The token type as an integer, dappCap and slammers noted here.
753   /// @param _title The short title of the token
754   /// @param _description Description of the token
755   function buyToken (
756 	string  _title,
757 	string  _description
758   ) public onlyOwner {
759 	bytes memory _titleBytes = bytes(_title);
760 	require(_titleBytes.length <= TITLE_MAX_LENGTH, "Desription is too long");
761 	
762 	bytes memory _descriptionBytes = bytes(_description);
763 	require(_descriptionBytes.length <= DESCRIPTION_MAX_LENGTH, "Description is too long");
764 	require(msg.value >= currentPrice, "Amount of Ether sent too small");
765 
766 	uint256 index = allTokens.length + 1;
767 
768 	_mint(msg.sender, index);
769 
770 	tokenTitles[index]       = _title;
771 	tokenDescriptions[index] = _description;
772 
773 	emit BoughtToken(msg.sender, index);
774   }
775 
776   /**
777    * @dev Returns all of the tokens that the user owns
778    * @return An array of token indices
779    */
780   function myTokens()
781 	external
782 	view
783 	returns (
784 	  uint256[]
785 	)
786   {
787 	return ownedTokens[msg.sender];
788   }
789 
790   /// @notice Returns all the relevant information about a specific token
791   /// @param _tokenId The ID of the token of interest
792   function viewTokenMeta(uint256 _tokenId)
793 	external
794 	view
795 	returns (
796 	  string  tokenTitle_,
797 	  string  tokenDescription_
798   ) {
799 	  tokenTitle_       = tokenTitles[_tokenId];
800 	  tokenDescription_ = tokenDescriptions[_tokenId];
801   }
802 
803   /// @notice Allows the owner of this contract to set the currentPrice for each token
804   function setCurrentPrice(uint256 newPrice)
805 	public
806 	onlyOwner
807   {
808 	  currentPrice = newPrice;
809   }
810 
811   /// @notice Returns the currentPrice for each token
812   function getCurrentPrice()
813 	external
814 	view
815 	returns (
816 	uint256 price
817   ) {
818 	  price = currentPrice;
819   }
820   
821   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
822   /**
823    * 0x780e9d63 ===
824    *   bytes4(keccak256('totalSupply()')) ^
825    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
826    *   bytes4(keccak256('tokenByIndex(uint256)'))
827    */
828 
829   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
830   /**
831    * 0x5b5e139f ===
832    *   bytes4(keccak256('name()')) ^
833    *   bytes4(keccak256('symbol()')) ^
834    *   bytes4(keccak256('tokenURI(uint256)'))
835    */
836 
837   // Token name
838   string internal name_;
839 
840   // Token symbol
841   string internal symbol_;
842 
843   // Mapping from owner to list of owned token IDs
844   mapping(address => uint256[]) internal ownedTokens;
845 
846   // Mapping from token ID to index of the owner tokens list
847   mapping(uint256 => uint256) internal ownedTokensIndex;
848 
849   // Array with all token ids, used for enumeration
850   uint256[] internal allTokens;
851 
852   // Mapping from token id to position in the allTokens array
853   mapping(uint256 => uint256) internal allTokensIndex;
854 
855   // Optional mapping for token URIs
856   mapping(uint256 => string) internal tokenURIs;
857 
858   /**
859    * @dev Gets the token name
860    * @return string representing the token name
861    */
862   function name() external view returns (string) {
863 	return name_;
864   }
865 
866   /**
867    * @dev Gets the token symbol
868    * @return string representing the token symbol
869    */
870   function symbol() external view returns (string) {
871 	return symbol_;
872   }
873 
874   /**
875    * @dev Returns an URI for a given token ID
876    * Throws if the token ID does not exist. May return an empty string.
877    * @param _tokenId uint256 ID of the token to query
878    */
879   function tokenURI(uint256 _tokenId) public view returns (string) {
880 	require(exists(_tokenId));
881 	return tokenURIs[_tokenId];
882   }
883 
884   /**
885    * @dev Gets the token ID at a given index of the tokens list of the requested owner
886    * @param _owner address owning the tokens list to be accessed
887    * @param _index uint256 representing the index to be accessed of the requested tokens list
888    * @return uint256 token ID at the given index of the tokens list owned by the requested address
889    */
890   function tokenOfOwnerByIndex(
891 	address _owner,
892 	uint256 _index
893   )
894 	public
895 	view
896 	returns (uint256)
897   {
898 	require(_index < balanceOf(_owner));
899 	return ownedTokens[_owner][_index];
900   }
901 
902   /**
903    * @dev Gets the total amount of tokens stored by the contract
904    * @return uint256 representing the total amount of tokens
905    */
906   function totalSupply() public view returns (uint256) {
907 	return allTokens.length;
908   }
909 
910   /**
911    * @dev Gets the token ID at a given index of all the tokens in this contract
912    * Reverts if the index is greater or equal to the total number of tokens
913    * @param _index uint256 representing the index to be accessed of the tokens list
914    * @return uint256 token ID at the given index of the tokens list
915    */
916   function tokenByIndex(uint256 _index) public view returns (uint256) {
917 	require(_index < totalSupply());
918 	return allTokens[_index];
919   }
920 
921   /**
922    * @dev Internal function to set the token URI for a given token
923    * Reverts if the token ID does not exist
924    * @param _tokenId uint256 ID of the token to set its URI
925    * @param _uri string URI to assign
926    */
927   function _setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
928 	require(exists(_tokenId));
929 	tokenURIs[_tokenId] = _uri;
930   }
931 
932   /**
933    * @dev Internal function to add a token ID to the list of a given address
934    * @param _to address representing the new owner of the given token ID
935    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
936    */
937   function addTokenTo(address _to, uint256 _tokenId) internal {
938 	super.addTokenTo(_to, _tokenId);
939 	uint256 length = ownedTokens[_to].length;
940 	ownedTokens[_to].push(_tokenId);
941 	ownedTokensIndex[_tokenId] = length;
942   }
943 
944   /**
945    * @dev Internal function to remove a token ID from the list of a given address
946    * @param _from address representing the previous owner of the given token ID
947    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
948    */
949   function removeTokenFrom(address _from, uint256 _tokenId) internal {
950 	super.removeTokenFrom(_from, _tokenId);
951 
952 	uint256 tokenIndex = ownedTokensIndex[_tokenId];
953 	uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
954 	uint256 lastToken = ownedTokens[_from][lastTokenIndex];
955 
956 	ownedTokens[_from][tokenIndex] = lastToken;
957 	ownedTokens[_from][lastTokenIndex] = 0;
958 	// Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
959 	// be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
960 	// the lastToken to the first position, and then dropping the element placed in the last position of the list
961 
962 	ownedTokens[_from].length--;
963 	ownedTokensIndex[_tokenId] = 0;
964 	ownedTokensIndex[lastToken] = tokenIndex;
965   }
966 
967   /**
968    * @dev Internal function to mint a new token
969    * Reverts if the given token ID already exists
970    * @param _to address the beneficiary that will own the minted token
971    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
972    */
973   function _mint(address _to, uint256 _tokenId) internal {
974 	super._mint(_to, _tokenId);
975 
976 	allTokensIndex[_tokenId] = allTokens.length;
977 	allTokens.push(_tokenId);
978   }
979 }