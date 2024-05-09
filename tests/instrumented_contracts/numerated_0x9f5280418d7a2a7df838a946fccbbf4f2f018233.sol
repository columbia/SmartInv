1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
114 
115 /**
116  * @title Contracts that should not own Ether
117  * @author Remco Bloemen <remco@2π.com>
118  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
119  * in the contract, it will allow the owner to reclaim this Ether.
120  * @notice Ether can still be sent to this contract by:
121  * calling functions labeled `payable`
122  * `selfdestruct(contract_address)`
123  * mining directly to the contract address
124  */
125 contract HasNoEther is Ownable {
126 
127   /**
128   * @dev Constructor that rejects incoming Ether
129   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
130   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
131   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
132   * we could use assembly to access msg.value.
133   */
134   constructor() public payable {
135     require(msg.value == 0);
136   }
137 
138   /**
139    * @dev Disallows direct send by setting a default function without the `payable` flag.
140    */
141   function() external {
142   }
143 
144   /**
145    * @dev Transfer all Ether held by the contract to the owner.
146    */
147   function reclaimEther() external onlyOwner {
148     owner.transfer(address(this).balance);
149   }
150 }
151 
152 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
153 
154 /**
155  * @title Destructible
156  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
157  */
158 contract Destructible is Ownable {
159   /**
160    * @dev Transfers the current balance to the owner and terminates the contract.
161    */
162   function destroy() public onlyOwner {
163     selfdestruct(owner);
164   }
165 
166   function destroyAndSend(address _recipient) public onlyOwner {
167     selfdestruct(_recipient);
168   }
169 }
170 
171 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178 
179   /**
180   * @dev Multiplies two numbers, throws on overflow.
181   */
182   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
183     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
184     // benefit is lost if 'b' is also tested.
185     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
186     if (_a == 0) {
187       return 0;
188     }
189 
190     c = _a * _b;
191     assert(c / _a == _b);
192     return c;
193   }
194 
195   /**
196   * @dev Integer division of two numbers, truncating the quotient.
197   */
198   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
199     // assert(_b > 0); // Solidity automatically throws when dividing by 0
200     // uint256 c = _a / _b;
201     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
202     return _a / _b;
203   }
204 
205   /**
206   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
207   */
208   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
209     assert(_b <= _a);
210     return _a - _b;
211   }
212 
213   /**
214   * @dev Adds two numbers, throws on overflow.
215   */
216   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
217     c = _a + _b;
218     assert(c >= _a);
219     return c;
220   }
221 }
222 
223 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
224 
225 /**
226  * @title ERC165
227  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
228  */
229 interface ERC165 {
230 
231   /**
232    * @notice Query if a contract implements an interface
233    * @param _interfaceId The interface identifier, as specified in ERC-165
234    * @dev Interface identification is specified in ERC-165. This function
235    * uses less than 30,000 gas.
236    */
237   function supportsInterface(bytes4 _interfaceId)
238     external
239     view
240     returns (bool);
241 }
242 
243 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
244 
245 /**
246  * @title ERC721 Non-Fungible Token Standard basic interface
247  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
248  */
249 contract ERC721Basic is ERC165 {
250 
251   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
252   /*
253    * 0x80ac58cd ===
254    *   bytes4(keccak256('balanceOf(address)')) ^
255    *   bytes4(keccak256('ownerOf(uint256)')) ^
256    *   bytes4(keccak256('approve(address,uint256)')) ^
257    *   bytes4(keccak256('getApproved(uint256)')) ^
258    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
259    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
260    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
261    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
262    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
263    */
264 
265   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
266   /*
267    * 0x4f558e79 ===
268    *   bytes4(keccak256('exists(uint256)'))
269    */
270 
271   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
272   /**
273    * 0x780e9d63 ===
274    *   bytes4(keccak256('totalSupply()')) ^
275    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
276    *   bytes4(keccak256('tokenByIndex(uint256)'))
277    */
278 
279   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
280   /**
281    * 0x5b5e139f ===
282    *   bytes4(keccak256('name()')) ^
283    *   bytes4(keccak256('symbol()')) ^
284    *   bytes4(keccak256('tokenURI(uint256)'))
285    */
286 
287   event Transfer(
288     address indexed _from,
289     address indexed _to,
290     uint256 indexed _tokenId
291   );
292   event Approval(
293     address indexed _owner,
294     address indexed _approved,
295     uint256 indexed _tokenId
296   );
297   event ApprovalForAll(
298     address indexed _owner,
299     address indexed _operator,
300     bool _approved
301   );
302 
303   function balanceOf(address _owner) public view returns (uint256 _balance);
304   function ownerOf(uint256 _tokenId) public view returns (address _owner);
305   function exists(uint256 _tokenId) public view returns (bool _exists);
306 
307   function approve(address _to, uint256 _tokenId) public;
308   function getApproved(uint256 _tokenId)
309     public view returns (address _operator);
310 
311   function setApprovalForAll(address _operator, bool _approved) public;
312   function isApprovedForAll(address _owner, address _operator)
313     public view returns (bool);
314 
315   function transferFrom(address _from, address _to, uint256 _tokenId) public;
316   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
317     public;
318 
319   function safeTransferFrom(
320     address _from,
321     address _to,
322     uint256 _tokenId,
323     bytes _data
324   )
325     public;
326 }
327 
328 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
329 
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
332  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
333  */
334 contract ERC721Enumerable is ERC721Basic {
335   function totalSupply() public view returns (uint256);
336   function tokenOfOwnerByIndex(
337     address _owner,
338     uint256 _index
339   )
340     public
341     view
342     returns (uint256 _tokenId);
343 
344   function tokenByIndex(uint256 _index) public view returns (uint256);
345 }
346 
347 
348 /**
349  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
350  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
351  */
352 contract ERC721Metadata is ERC721Basic {
353   function name() external view returns (string _name);
354   function symbol() external view returns (string _symbol);
355   function tokenURI(uint256 _tokenId) public view returns (string);
356 }
357 
358 
359 /**
360  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
361  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
362  */
363 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
364 }
365 
366 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
367 
368 /**
369  * @title ERC721 token receiver interface
370  * @dev Interface for any contract that wants to support safeTransfers
371  * from ERC721 asset contracts.
372  */
373 contract ERC721Receiver {
374   /**
375    * @dev Magic value to be returned upon successful reception of an NFT
376    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
377    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
378    */
379   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
380 
381   /**
382    * @notice Handle the receipt of an NFT
383    * @dev The ERC721 smart contract calls this function on the recipient
384    * after a `safetransfer`. This function MAY throw to revert and reject the
385    * transfer. Return of other than the magic value MUST result in the
386    * transaction being reverted.
387    * Note: the contract address is always the message sender.
388    * @param _operator The address which called `safeTransferFrom` function
389    * @param _from The address which previously owned the token
390    * @param _tokenId The NFT identifier which is being transferred
391    * @param _data Additional data with no specified format
392    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
393    */
394   function onERC721Received(
395     address _operator,
396     address _from,
397     uint256 _tokenId,
398     bytes _data
399   )
400     public
401     returns(bytes4);
402 }
403 
404 // File: openzeppelin-solidity/contracts/AddressUtils.sol
405 
406 /**
407  * Utility library of inline functions on addresses
408  */
409 library AddressUtils {
410 
411   /**
412    * Returns whether the target address is a contract
413    * @dev This function will return false if invoked during the constructor of a contract,
414    * as the code is not actually created until after the constructor finishes.
415    * @param _addr address to check
416    * @return whether the target address is a contract
417    */
418   function isContract(address _addr) internal view returns (bool) {
419     uint256 size;
420     // XXX Currently there is no better way to check if there is a contract in an address
421     // than to check the size of the code at that address.
422     // See https://ethereum.stackexchange.com/a/14016/36603
423     // for more details about how this works.
424     // TODO Check this again before the Serenity release, because all addresses will be
425     // contracts then.
426     // solium-disable-next-line security/no-inline-assembly
427     assembly { size := extcodesize(_addr) }
428     return size > 0;
429   }
430 
431 }
432 
433 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
434 
435 /**
436  * @title SupportsInterfaceWithLookup
437  * @author Matt Condon (@shrugs)
438  * @dev Implements ERC165 using a lookup table.
439  */
440 contract SupportsInterfaceWithLookup is ERC165 {
441 
442   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
443   /**
444    * 0x01ffc9a7 ===
445    *   bytes4(keccak256('supportsInterface(bytes4)'))
446    */
447 
448   /**
449    * @dev a mapping of interface id to whether or not it's supported
450    */
451   mapping(bytes4 => bool) internal supportedInterfaces;
452 
453   /**
454    * @dev A contract implementing SupportsInterfaceWithLookup
455    * implement ERC165 itself
456    */
457   constructor()
458     public
459   {
460     _registerInterface(InterfaceId_ERC165);
461   }
462 
463   /**
464    * @dev implement supportsInterface(bytes4) using a lookup table
465    */
466   function supportsInterface(bytes4 _interfaceId)
467     external
468     view
469     returns (bool)
470   {
471     return supportedInterfaces[_interfaceId];
472   }
473 
474   /**
475    * @dev private method for registering an interface
476    */
477   function _registerInterface(bytes4 _interfaceId)
478     internal
479   {
480     require(_interfaceId != 0xffffffff);
481     supportedInterfaces[_interfaceId] = true;
482   }
483 }
484 
485 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
486 
487 /**
488  * @title ERC721 Non-Fungible Token Standard basic implementation
489  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
490  */
491 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
492 
493   using SafeMath for uint256;
494   using AddressUtils for address;
495 
496   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
497   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
498   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
499 
500   // Mapping from token ID to owner
501   mapping (uint256 => address) internal tokenOwner;
502 
503   // Mapping from token ID to approved address
504   mapping (uint256 => address) internal tokenApprovals;
505 
506   // Mapping from owner to number of owned token
507   mapping (address => uint256) internal ownedTokensCount;
508 
509   // Mapping from owner to operator approvals
510   mapping (address => mapping (address => bool)) internal operatorApprovals;
511 
512   constructor()
513     public
514   {
515     // register the supported interfaces to conform to ERC721 via ERC165
516     _registerInterface(InterfaceId_ERC721);
517     _registerInterface(InterfaceId_ERC721Exists);
518   }
519 
520   /**
521    * @dev Gets the balance of the specified address
522    * @param _owner address to query the balance of
523    * @return uint256 representing the amount owned by the passed address
524    */
525   function balanceOf(address _owner) public view returns (uint256) {
526     require(_owner != address(0));
527     return ownedTokensCount[_owner];
528   }
529 
530   /**
531    * @dev Gets the owner of the specified token ID
532    * @param _tokenId uint256 ID of the token to query the owner of
533    * @return owner address currently marked as the owner of the given token ID
534    */
535   function ownerOf(uint256 _tokenId) public view returns (address) {
536     address owner = tokenOwner[_tokenId];
537     require(owner != address(0));
538     return owner;
539   }
540 
541   /**
542    * @dev Returns whether the specified token exists
543    * @param _tokenId uint256 ID of the token to query the existence of
544    * @return whether the token exists
545    */
546   function exists(uint256 _tokenId) public view returns (bool) {
547     address owner = tokenOwner[_tokenId];
548     return owner != address(0);
549   }
550 
551   /**
552    * @dev Approves another address to transfer the given token ID
553    * The zero address indicates there is no approved address.
554    * There can only be one approved address per token at a given time.
555    * Can only be called by the token owner or an approved operator.
556    * @param _to address to be approved for the given token ID
557    * @param _tokenId uint256 ID of the token to be approved
558    */
559   function approve(address _to, uint256 _tokenId) public {
560     address owner = ownerOf(_tokenId);
561     require(_to != owner);
562     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
563 
564     tokenApprovals[_tokenId] = _to;
565     emit Approval(owner, _to, _tokenId);
566   }
567 
568   /**
569    * @dev Gets the approved address for a token ID, or zero if no address set
570    * @param _tokenId uint256 ID of the token to query the approval of
571    * @return address currently approved for the given token ID
572    */
573   function getApproved(uint256 _tokenId) public view returns (address) {
574     return tokenApprovals[_tokenId];
575   }
576 
577   /**
578    * @dev Sets or unsets the approval of a given operator
579    * An operator is allowed to transfer all tokens of the sender on their behalf
580    * @param _to operator address to set the approval
581    * @param _approved representing the status of the approval to be set
582    */
583   function setApprovalForAll(address _to, bool _approved) public {
584     require(_to != msg.sender);
585     operatorApprovals[msg.sender][_to] = _approved;
586     emit ApprovalForAll(msg.sender, _to, _approved);
587   }
588 
589   /**
590    * @dev Tells whether an operator is approved by a given owner
591    * @param _owner owner address which you want to query the approval of
592    * @param _operator operator address which you want to query the approval of
593    * @return bool whether the given operator is approved by the given owner
594    */
595   function isApprovedForAll(
596     address _owner,
597     address _operator
598   )
599     public
600     view
601     returns (bool)
602   {
603     return operatorApprovals[_owner][_operator];
604   }
605 
606   /**
607    * @dev Transfers the ownership of a given token ID to another address
608    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
609    * Requires the msg sender to be the owner, approved, or operator
610    * @param _from current owner of the token
611    * @param _to address to receive the ownership of the given token ID
612    * @param _tokenId uint256 ID of the token to be transferred
613   */
614   function transferFrom(
615     address _from,
616     address _to,
617     uint256 _tokenId
618   )
619     public
620   {
621     require(isApprovedOrOwner(msg.sender, _tokenId));
622     require(_from != address(0));
623     require(_to != address(0));
624 
625     clearApproval(_from, _tokenId);
626     removeTokenFrom(_from, _tokenId);
627     addTokenTo(_to, _tokenId);
628 
629     emit Transfer(_from, _to, _tokenId);
630   }
631 
632   /**
633    * @dev Safely transfers the ownership of a given token ID to another address
634    * If the target address is a contract, it must implement `onERC721Received`,
635    * which is called upon a safe transfer, and return the magic value
636    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
637    * the transfer is reverted.
638    *
639    * Requires the msg sender to be the owner, approved, or operator
640    * @param _from current owner of the token
641    * @param _to address to receive the ownership of the given token ID
642    * @param _tokenId uint256 ID of the token to be transferred
643   */
644   function safeTransferFrom(
645     address _from,
646     address _to,
647     uint256 _tokenId
648   )
649     public
650   {
651     // solium-disable-next-line arg-overflow
652     safeTransferFrom(_from, _to, _tokenId, "");
653   }
654 
655   /**
656    * @dev Safely transfers the ownership of a given token ID to another address
657    * If the target address is a contract, it must implement `onERC721Received`,
658    * which is called upon a safe transfer, and return the magic value
659    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
660    * the transfer is reverted.
661    * Requires the msg sender to be the owner, approved, or operator
662    * @param _from current owner of the token
663    * @param _to address to receive the ownership of the given token ID
664    * @param _tokenId uint256 ID of the token to be transferred
665    * @param _data bytes data to send along with a safe transfer check
666    */
667   function safeTransferFrom(
668     address _from,
669     address _to,
670     uint256 _tokenId,
671     bytes _data
672   )
673     public
674   {
675     transferFrom(_from, _to, _tokenId);
676     // solium-disable-next-line arg-overflow
677     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
678   }
679 
680   /**
681    * @dev Returns whether the given spender can transfer a given token ID
682    * @param _spender address of the spender to query
683    * @param _tokenId uint256 ID of the token to be transferred
684    * @return bool whether the msg.sender is approved for the given token ID,
685    *  is an operator of the owner, or is the owner of the token
686    */
687   function isApprovedOrOwner(
688     address _spender,
689     uint256 _tokenId
690   )
691     internal
692     view
693     returns (bool)
694   {
695     address owner = ownerOf(_tokenId);
696     // Disable solium check because of
697     // https://github.com/duaraghav8/Solium/issues/175
698     // solium-disable-next-line operator-whitespace
699     return (
700       _spender == owner ||
701       getApproved(_tokenId) == _spender ||
702       isApprovedForAll(owner, _spender)
703     );
704   }
705 
706   /**
707    * @dev Internal function to mint a new token
708    * Reverts if the given token ID already exists
709    * @param _to The address that will own the minted token
710    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
711    */
712   function _mint(address _to, uint256 _tokenId) internal {
713     require(_to != address(0));
714     addTokenTo(_to, _tokenId);
715     emit Transfer(address(0), _to, _tokenId);
716   }
717 
718   /**
719    * @dev Internal function to burn a specific token
720    * Reverts if the token does not exist
721    * @param _tokenId uint256 ID of the token being burned by the msg.sender
722    */
723   function _burn(address _owner, uint256 _tokenId) internal {
724     clearApproval(_owner, _tokenId);
725     removeTokenFrom(_owner, _tokenId);
726     emit Transfer(_owner, address(0), _tokenId);
727   }
728 
729   /**
730    * @dev Internal function to clear current approval of a given token ID
731    * Reverts if the given address is not indeed the owner of the token
732    * @param _owner owner of the token
733    * @param _tokenId uint256 ID of the token to be transferred
734    */
735   function clearApproval(address _owner, uint256 _tokenId) internal {
736     require(ownerOf(_tokenId) == _owner);
737     if (tokenApprovals[_tokenId] != address(0)) {
738       tokenApprovals[_tokenId] = address(0);
739     }
740   }
741 
742   /**
743    * @dev Internal function to add a token ID to the list of a given address
744    * @param _to address representing the new owner of the given token ID
745    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
746    */
747   function addTokenTo(address _to, uint256 _tokenId) internal {
748     require(tokenOwner[_tokenId] == address(0));
749     tokenOwner[_tokenId] = _to;
750     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
751   }
752 
753   /**
754    * @dev Internal function to remove a token ID from the list of a given address
755    * @param _from address representing the previous owner of the given token ID
756    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
757    */
758   function removeTokenFrom(address _from, uint256 _tokenId) internal {
759     require(ownerOf(_tokenId) == _from);
760     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
761     tokenOwner[_tokenId] = address(0);
762   }
763 
764   /**
765    * @dev Internal function to invoke `onERC721Received` on a target address
766    * The call is not executed if the target address is not a contract
767    * @param _from address representing the previous owner of the given token ID
768    * @param _to target address that will receive the tokens
769    * @param _tokenId uint256 ID of the token to be transferred
770    * @param _data bytes optional data to send along with the call
771    * @return whether the call correctly returned the expected magic value
772    */
773   function checkAndCallSafeTransfer(
774     address _from,
775     address _to,
776     uint256 _tokenId,
777     bytes _data
778   )
779     internal
780     returns (bool)
781   {
782     if (!_to.isContract()) {
783       return true;
784     }
785     bytes4 retval = ERC721Receiver(_to).onERC721Received(
786       msg.sender, _from, _tokenId, _data);
787     return (retval == ERC721_RECEIVED);
788   }
789 }
790 
791 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
792 
793 /**
794  * @title Full ERC721 Token
795  * This implementation includes all the required and some optional functionality of the ERC721 standard
796  * Moreover, it includes approve all functionality using operator terminology
797  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
798  */
799 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
800 
801   // Token name
802   string internal name_;
803 
804   // Token symbol
805   string internal symbol_;
806 
807   // Mapping from owner to list of owned token IDs
808   mapping(address => uint256[]) internal ownedTokens;
809 
810   // Mapping from token ID to index of the owner tokens list
811   mapping(uint256 => uint256) internal ownedTokensIndex;
812 
813   // Array with all token ids, used for enumeration
814   uint256[] internal allTokens;
815 
816   // Mapping from token id to position in the allTokens array
817   mapping(uint256 => uint256) internal allTokensIndex;
818 
819   // Optional mapping for token URIs
820   mapping(uint256 => string) internal tokenURIs;
821 
822   /**
823    * @dev Constructor function
824    */
825   constructor(string _name, string _symbol) public {
826     name_ = _name;
827     symbol_ = _symbol;
828 
829     // register the supported interfaces to conform to ERC721 via ERC165
830     _registerInterface(InterfaceId_ERC721Enumerable);
831     _registerInterface(InterfaceId_ERC721Metadata);
832   }
833 
834   /**
835    * @dev Gets the token name
836    * @return string representing the token name
837    */
838   function name() external view returns (string) {
839     return name_;
840   }
841 
842   /**
843    * @dev Gets the token symbol
844    * @return string representing the token symbol
845    */
846   function symbol() external view returns (string) {
847     return symbol_;
848   }
849 
850   /**
851    * @dev Returns an URI for a given token ID
852    * Throws if the token ID does not exist. May return an empty string.
853    * @param _tokenId uint256 ID of the token to query
854    */
855   function tokenURI(uint256 _tokenId) public view returns (string) {
856     require(exists(_tokenId));
857     return tokenURIs[_tokenId];
858   }
859 
860   /**
861    * @dev Gets the token ID at a given index of the tokens list of the requested owner
862    * @param _owner address owning the tokens list to be accessed
863    * @param _index uint256 representing the index to be accessed of the requested tokens list
864    * @return uint256 token ID at the given index of the tokens list owned by the requested address
865    */
866   function tokenOfOwnerByIndex(
867     address _owner,
868     uint256 _index
869   )
870     public
871     view
872     returns (uint256)
873   {
874     require(_index < balanceOf(_owner));
875     return ownedTokens[_owner][_index];
876   }
877 
878   /**
879    * @dev Gets the total amount of tokens stored by the contract
880    * @return uint256 representing the total amount of tokens
881    */
882   function totalSupply() public view returns (uint256) {
883     return allTokens.length;
884   }
885 
886   /**
887    * @dev Gets the token ID at a given index of all the tokens in this contract
888    * Reverts if the index is greater or equal to the total number of tokens
889    * @param _index uint256 representing the index to be accessed of the tokens list
890    * @return uint256 token ID at the given index of the tokens list
891    */
892   function tokenByIndex(uint256 _index) public view returns (uint256) {
893     require(_index < totalSupply());
894     return allTokens[_index];
895   }
896 
897   /**
898    * @dev Internal function to set the token URI for a given token
899    * Reverts if the token ID does not exist
900    * @param _tokenId uint256 ID of the token to set its URI
901    * @param _uri string URI to assign
902    */
903   function _setTokenURI(uint256 _tokenId, string _uri) internal {
904     require(exists(_tokenId));
905     tokenURIs[_tokenId] = _uri;
906   }
907 
908   /**
909    * @dev Internal function to add a token ID to the list of a given address
910    * @param _to address representing the new owner of the given token ID
911    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
912    */
913   function addTokenTo(address _to, uint256 _tokenId) internal {
914     super.addTokenTo(_to, _tokenId);
915     uint256 length = ownedTokens[_to].length;
916     ownedTokens[_to].push(_tokenId);
917     ownedTokensIndex[_tokenId] = length;
918   }
919 
920   /**
921    * @dev Internal function to remove a token ID from the list of a given address
922    * @param _from address representing the previous owner of the given token ID
923    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
924    */
925   function removeTokenFrom(address _from, uint256 _tokenId) internal {
926     super.removeTokenFrom(_from, _tokenId);
927 
928     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
929     // then delete the last slot.
930     uint256 tokenIndex = ownedTokensIndex[_tokenId];
931     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
932     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
933 
934     ownedTokens[_from][tokenIndex] = lastToken;
935     // This also deletes the contents at the last position of the array
936     ownedTokens[_from].length--;
937 
938     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
939     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
940     // the lastToken to the first position, and then dropping the element placed in the last position of the list
941 
942     ownedTokensIndex[_tokenId] = 0;
943     ownedTokensIndex[lastToken] = tokenIndex;
944   }
945 
946   /**
947    * @dev Internal function to mint a new token
948    * Reverts if the given token ID already exists
949    * @param _to address the beneficiary that will own the minted token
950    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
951    */
952   function _mint(address _to, uint256 _tokenId) internal {
953     super._mint(_to, _tokenId);
954 
955     allTokensIndex[_tokenId] = allTokens.length;
956     allTokens.push(_tokenId);
957   }
958 
959   /**
960    * @dev Internal function to burn a specific token
961    * Reverts if the token does not exist
962    * @param _owner owner of the token to burn
963    * @param _tokenId uint256 ID of the token being burned by the msg.sender
964    */
965   function _burn(address _owner, uint256 _tokenId) internal {
966     super._burn(_owner, _tokenId);
967 
968     // Clear metadata (if any)
969     if (bytes(tokenURIs[_tokenId]).length != 0) {
970       delete tokenURIs[_tokenId];
971     }
972 
973     // Reorg all tokens array
974     uint256 tokenIndex = allTokensIndex[_tokenId];
975     uint256 lastTokenIndex = allTokens.length.sub(1);
976     uint256 lastToken = allTokens[lastTokenIndex];
977 
978     allTokens[tokenIndex] = lastToken;
979     allTokens[lastTokenIndex] = 0;
980 
981     allTokens.length--;
982     allTokensIndex[_tokenId] = 0;
983     allTokensIndex[lastToken] = tokenIndex;
984   }
985 
986 }
987 
988 // File: contracts/MEHAccessControl.sol
989 
990 contract MarketInerface {
991     function buyBlocks(address, uint16[]) external returns (uint) {}
992     function sellBlocks(address, uint, uint16[]) external returns (uint) {}
993     function isMarket() public view returns (bool) {}
994     function isOnSale(uint16) public view returns (bool) {}
995     function areaPrice(uint16[]) public view returns (uint) {}
996     function importOldMEBlock(uint8, uint8) external returns (uint, address) {}
997 }
998 
999 contract RentalsInterface {
1000     function rentOutBlocks(address, uint, uint16[]) external returns (uint) {}
1001     function rentBlocks(address, uint, uint16[]) external returns (uint) {}
1002     function blocksRentPrice(uint, uint16[]) external view returns (uint) {}
1003     function isRentals() public view returns (bool) {}
1004     function isRented(uint16) public view returns (bool) {}
1005     function renterOf(uint16) public view returns (address) {}
1006 }
1007 
1008 contract AdsInterface {
1009     function advertiseOnBlocks(address, uint16[], string, string, string) external returns (uint) {}
1010     function canAdvertiseOnBlocks(address, uint16[]) public view returns (bool) {}
1011     function isAds() public view returns (bool) {}
1012 }
1013 
1014 /// @title MEHAccessControl: Part of MEH contract responsible for communication with external modules:
1015 ///  Market, Rentals, Ads contracts. Provides authorization and upgradability methods.
1016 contract MEHAccessControl is Pausable {
1017 
1018     // Allows a module being plugged in to verify it is MEH contract. 
1019     bool public isMEH = true;
1020 
1021     // Modules
1022     MarketInerface public market;
1023     RentalsInterface public rentals;
1024     AdsInterface public ads;
1025 
1026     // Emitted when a module is plugged.
1027     event LogModuleUpgrade(address newAddress, string moduleName);
1028     
1029 // GUARDS
1030     
1031     /// @dev Functions allowed to market module only. 
1032     modifier onlyMarket() {
1033         require(msg.sender == address(market));
1034         _;
1035     }
1036 
1037     /// @dev Functions allowed to balance operators only (market and rentals contracts are the 
1038     ///  only balance operators)
1039     modifier onlyBalanceOperators() {
1040         require(msg.sender == address(market) || msg.sender == address(rentals));
1041         _;
1042     }
1043 
1044 // ** Admin set Access ** //
1045     /// @dev Allows admin to plug a new Market contract in.
1046     // credits to cryptokittes! - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1047     // NOTE: verify that a contract is what we expect
1048     function adminSetMarket(address _address) external onlyOwner {
1049         MarketInerface candidateContract = MarketInerface(_address);
1050         require(candidateContract.isMarket());
1051         market = candidateContract;
1052         emit LogModuleUpgrade(_address, "Market");
1053     }
1054 
1055     /// @dev Allows admin to plug a new Rentals contract in.
1056     function adminSetRentals(address _address) external onlyOwner {
1057         RentalsInterface candidateContract = RentalsInterface(_address);
1058         require(candidateContract.isRentals());
1059         rentals = candidateContract;
1060         emit LogModuleUpgrade(_address, "Rentals");
1061     }
1062 
1063     /// @dev Allows admin to plug a new Ads contract in.
1064     function adminSetAds(address _address) external onlyOwner {
1065         AdsInterface candidateContract = AdsInterface(_address);
1066         require(candidateContract.isAds());
1067         ads = candidateContract;
1068         emit LogModuleUpgrade(_address, "Ads");
1069     }
1070 }
1071 
1072 // File: contracts/MehERC721.sol
1073 
1074 // ERC721 
1075 
1076 
1077 
1078 /// @title MehERC721: Part of MEH contract responsible for ERC721 token management. Openzeppelin's
1079 ///  ERC721 implementation modified for the Million Ether Homepage. 
1080 contract MehERC721 is ERC721Token("MillionEtherHomePage","MEH"), MEHAccessControl {
1081 
1082     /// @dev Checks rights to transfer block ownership. Locks tokens on sale.
1083     ///  Overrides OpenZEppelin's isApprovedOrOwner function - so that tokens marked for sale can 
1084     ///  be transferred by Market contract only.
1085     function isApprovedOrOwner(
1086         address _spender,
1087         uint256 _tokenId
1088     )
1089         internal
1090         view
1091         returns (bool)
1092     {   
1093         bool onSale = market.isOnSale(uint16(_tokenId));
1094 
1095         address owner = ownerOf(_tokenId);
1096         bool spenderIsApprovedOrOwner =
1097             _spender == owner ||
1098             getApproved(_tokenId) == _spender ||
1099             isApprovedForAll(owner, _spender);
1100 
1101         return (
1102             (onSale && _spender == address(market)) ||
1103             (!(onSale) && spenderIsApprovedOrOwner)
1104         );
1105     }
1106 
1107     /// @dev mints a new block.
1108     ///  overrides _mint function to add pause/unpause functionality, onlyMarket access,
1109     ///  restricts totalSupply of blocks to 10000 (as there is only a 100x100 blocks field).
1110     function _mintCrowdsaleBlock(address _to, uint16 _blockId) external onlyMarket whenNotPaused {
1111         if (totalSupply() <= 9999) {
1112         _mint(_to, uint256(_blockId));
1113         }
1114     }
1115 
1116     /// @dev overrides approve function to add pause/unpause functionality
1117     function approve(address _to, uint256 _tokenId) public whenNotPaused {
1118         super.approve(_to, _tokenId);
1119     }
1120  
1121     /// @dev overrides setApprovalForAll function to add pause/unpause functionality
1122     function setApprovalForAll(address _to, bool _approved) public whenNotPaused {
1123         super.setApprovalForAll(_to, _approved);
1124     }    
1125 
1126     /// @dev overrides transferFrom function to add pause/unpause functionality
1127     ///  affects safeTransferFrom functions as well
1128     function transferFrom(
1129         address _from,
1130         address _to,
1131         uint256 _tokenId
1132     )
1133         public
1134         whenNotPaused
1135     {
1136         super.transferFrom(_from, _to, _tokenId);
1137     }
1138 }
1139 
1140 // File: contracts/Accounting.sol
1141 
1142 // import "../installed_contracts/math.sol";
1143 
1144 
1145 
1146 // @title Accounting: Part of MEH contract responsible for eth accounting.
1147 contract Accounting is MEHAccessControl {
1148     using SafeMath for uint256;
1149 
1150     // Balances of users, admin, charity
1151     mapping(address => uint256) public balances;
1152 
1153     // Emitted when a user deposits or withdraws funds from the contract
1154     event LogContractBalance(address payerOrPayee, int balanceChange);
1155 
1156 // ** PAYMENT PROCESSING ** //
1157     
1158     /// @dev Withdraws users available balance.
1159     function withdraw() external whenNotPaused {
1160         address payee = msg.sender;
1161         uint256 payment = balances[payee];
1162 
1163         require(payment != 0);
1164         assert(address(this).balance >= payment);
1165 
1166         balances[payee] = 0;
1167 
1168         // reentrancy safe
1169         payee.transfer(payment);
1170         emit LogContractBalance(payee, int256(-payment));
1171     }
1172 
1173     /// @dev Lets external authorized contract (operators) to transfer balances within MEH contract.
1174     ///  MEH contract doesn't transfer funds on its own. Instead Market and Rentals contracts
1175     ///  are granted operator access.
1176     function operatorTransferFunds(
1177         address _payer, 
1178         address _recipient, 
1179         uint _amount) 
1180     external 
1181     onlyBalanceOperators
1182     whenNotPaused
1183     {
1184         require(balances[_payer] >= _amount);
1185         _deductFrom(_payer, _amount);
1186         _depositTo(_recipient, _amount);
1187     }
1188 
1189     /// @dev Deposits eth to msg.sender balance.
1190     function depositFunds() internal whenNotPaused {
1191         _depositTo(msg.sender, msg.value);
1192         emit LogContractBalance(msg.sender, int256(msg.value));
1193     }
1194 
1195     /// @dev Increases recipients internal balance.
1196     function _depositTo(address _recipient, uint _amount) internal {
1197         balances[_recipient] = balances[_recipient].add(_amount);
1198     }
1199 
1200     /// @dev Increases payers internal balance.
1201     function _deductFrom(address _payer, uint _amount) internal {
1202         balances[_payer] = balances[_payer].sub(_amount);
1203     }
1204 
1205 // ** ADMIN ** //
1206 
1207     /// @notice Allows admin to withdraw contract balance in emergency. And distribute manualy
1208     ///  aftrewards.
1209     /// @dev As the contract is not designed to keep users funds (users can withdraw
1210     ///  at anytime) it should be relatively easy to manualy transfer unclaimed funds to 
1211     ///  their owners. This is an alternatinve to selfdestruct allowing blocks ledger (ERC721 tokens)
1212     ///  to be immutable.
1213     function adminRescueFunds() external onlyOwner whenPaused {
1214         address payee = owner;
1215         uint256 payment = address(this).balance;
1216         payee.transfer(payment);
1217     }
1218 
1219     /// @dev Checks if a msg.sender has enough balance to pay the price _needed.
1220     function canPay(uint _needed) internal view returns (bool) {
1221         return (msg.value.add(balances[msg.sender]) >= _needed);
1222     }
1223 }
1224 
1225 // File: contracts/MEH.sol
1226 
1227 /*
1228 MillionEther smart contract - decentralized advertising platform.
1229 
1230 This program is free software: you can redistribute it and/or modifromY
1231 it under the terms of the GNU General Public License as published by
1232 the Free Software Foundation, either version 3 of the License, or
1233 (at your option) any later version.
1234 
1235 This program is distributed in the hope that it will be useful,
1236 but WITHOUT ANY WARRANTY; without even the implied warranty of
1237 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1238 GNU General Public License for more details.
1239 
1240 You should have received a copy of the GNU General Public License
1241 along with this program.  If not, see <http://www.gnu.org/licenses/>.
1242 */
1243 
1244 /*
1245 * A 1000x1000 pixel field is displayed at TheMillionEtherHomepage.com. 
1246 * This smart contract lets anyone buy 10x10 pixel blocks and place ads there.
1247 * It also allows to sell blocks and rent them out to other advertisers. 
1248 *
1249 * 10x10 pixels blocks are addressed by xy coordinates. So 1000x1000 pixel field is 100 by 100 blocks.
1250 * Making up 10 000 blocks in total. Each block is an ERC721 (non fungible token) token. 
1251 *
1252 * At the initial sale the price for each block is $1 (price is feeded by an oracle). After
1253 * every 1000 blocks sold (every 10%) the price doubles. Owners can sell and rent out blocks at any
1254 * price they want. Owners and renters can place and replace ads to their blocks as many times they 
1255 * want.
1256 *
1257 * All heavy logic is delegated to external upgradable contracts. There are 4 main modules (contracts):
1258 *     - MEH: Million Ether Homepage (MEH) contract. Provides user interface and accounting 
1259 *         functionality. It is immutable and it keeps Non fungible ERC721 tokens (10x10 pixel blocks) 
1260 *         ledger and eth balances. 
1261 *     - Market: Plugable. Provides methods for buy-sell functionality, keeps buy-sell ledger, 
1262 *         querries oracle for a ETH-USD price, 
1263 *     - Rentals: Plugable. Provides methods for rentout-rent functionality, keeps rentout-rent ledger.
1264 *     - Ads: Plugable. Provides methods for image placement functionality.
1265 * 
1266 */
1267 
1268 /// @title MEH: Million Ether Homepage. Buy, sell, rent out pixels and place ads.
1269 /// @author Peter Porobov (https://keybase.io/peterporobov)
1270 /// @notice The main contract, accounting and user interface. Immutable.
1271 contract MEH is MehERC721, Accounting {
1272 
1273     /// @notice emited when an area blocks is bought
1274     event LogBuys(
1275         uint ID,
1276         uint8 fromX,
1277         uint8 fromY,
1278         uint8 toX,
1279         uint8 toY,
1280         address newLandlord
1281     );
1282 
1283     /// @notice emited when an area blocks is marked for sale
1284     event LogSells(
1285         uint ID,
1286         uint8 fromX,
1287         uint8 fromY,
1288         uint8 toX,
1289         uint8 toY,
1290         uint sellPrice
1291     );
1292 
1293     /// @notice emited when an area blocks is marked for rent
1294     event LogRentsOut(
1295         uint ID,
1296         uint8 fromX,
1297         uint8 fromY,
1298         uint8 toX,
1299         uint8 toY,
1300         uint rentPricePerPeriodWei
1301     );
1302 
1303     /// @notice emited when an area blocks is rented
1304     event LogRents(
1305         uint ID,
1306         uint8 fromX,
1307         uint8 fromY,
1308         uint8 toX,
1309         uint8 toY,
1310         uint numberOfPeriods,
1311         uint rentedFrom
1312     );
1313 
1314     /// @notice emited when an ad is placed to an area
1315     event LogAds(
1316         uint ID, 
1317         uint8 fromX,
1318         uint8 fromY,
1319         uint8 toX,
1320         uint8 toY,
1321         string imageSourceUrl,
1322         string adUrl,
1323         string adText,
1324         address indexed advertiser);
1325 
1326 // ** BUY AND SELL BLOCKS ** //
1327     
1328     /// @notice lets a message sender to buy blocks within area
1329     /// @dev if using a contract to buy an area make sure to implement ERC721 functionality 
1330     ///  as tokens are transfered using "transferFrom" function and not "safeTransferFrom"
1331     ///  in order to avoid external calls.
1332     function buyArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) 
1333         external
1334         whenNotPaused
1335         payable
1336     {   
1337         // check input parameters and eth deposited
1338         require(isLegalCoordinates(fromX, fromY, toX, toY));
1339         require(canPay(areaPrice(fromX, fromY, toX, toY)));
1340         depositFunds();
1341 
1342         // try to buy blocks through market contract
1343         // will get an id of buy-sell operation if succeeds (if all blocks available)
1344         uint id = market.buyBlocks(msg.sender, blocksList(fromX, fromY, toX, toY));
1345         emit LogBuys(id, fromX, fromY, toX, toY, msg.sender);
1346     }
1347 
1348     /// @notice lets a message sender to mark blocks for sale at price set for each block in wei
1349     /// @dev (priceForEachBlockCents = 0 - not for sale)
1350     function sellArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint priceForEachBlockWei)
1351         external 
1352         whenNotPaused
1353     {   
1354         // check input parameters
1355         require(isLegalCoordinates(fromX, fromY, toX, toY));
1356 
1357         // try to mark blocks for sale through market contract
1358         // will get an id of buy-sell operation if succeeds (if owns all blocks)
1359         uint id = market.sellBlocks(
1360             msg.sender, 
1361             priceForEachBlockWei, 
1362             blocksList(fromX, fromY, toX, toY)
1363         );
1364         emit LogSells(id, fromX, fromY, toX, toY, priceForEachBlockWei);
1365     }
1366 
1367     /// @notice get area price in wei
1368     function areaPrice(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) 
1369         public 
1370         view 
1371         returns (uint) 
1372     {   
1373         // check input
1374         require(isLegalCoordinates(fromX, fromY, toX, toY));
1375 
1376         // querry areaPrice in wei at market contract
1377         return market.areaPrice(blocksList(fromX, fromY, toX, toY));
1378     }
1379 
1380 // ** RENT OUT AND RENT BLOCKS ** //
1381         
1382     /// @notice Rent out an area of blocks at coordinates [fromX, fromY, toX, toY] at a price for 
1383     ///  each block in wei
1384     /// @dev if rentPricePerPeriodWei = 0 then makes area not available for rent
1385     function rentOutArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint rentPricePerPeriodWei)
1386         external
1387         whenNotPaused
1388     {   
1389         // check input
1390         require(isLegalCoordinates(fromX, fromY, toX, toY));
1391 
1392         // try to mark blocks as rented out through rentals contract
1393         // will get an id of rent-rentout operation if succeeds (if message sender owns blocks)
1394         uint id = rentals.rentOutBlocks(
1395             msg.sender, 
1396             rentPricePerPeriodWei, 
1397             blocksList(fromX, fromY, toX, toY)
1398         );
1399         emit LogRentsOut(id, fromX, fromY, toX, toY, rentPricePerPeriodWei);
1400     }
1401     
1402     /// @notice Rent an area of blocks at coordinates [fromX, fromY, toX, toY] for a number of 
1403     ///  periods specified
1404     ///  (period length is specified in rentals contract)
1405     function rentArea(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint numberOfPeriods)
1406         external
1407         payable
1408         whenNotPaused
1409     {   
1410         // check input parameters and eth deposited
1411         // checks number of periods > 0 in rentals contract
1412         require(isLegalCoordinates(fromX, fromY, toX, toY));
1413         require(canPay(areaRentPrice(fromX, fromY, toX, toY, numberOfPeriods)));
1414         depositFunds();
1415 
1416         // try to rent blocks through rentals contract
1417         // will get an id of rent-rentout operation if succeeds (if all blocks available for rent)
1418         uint id = rentals.rentBlocks(
1419             msg.sender, 
1420             numberOfPeriods, 
1421             blocksList(fromX, fromY, toX, toY)
1422         );
1423         emit LogRents(id, fromX, fromY, toX, toY, numberOfPeriods, 0);
1424     }
1425 
1426     /// @notice get area rent price in wei for number of periods specified 
1427     ///  (period length is specified in rentals contract) 
1428     function areaRentPrice(uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint numberOfPeriods)
1429         public 
1430         view 
1431         returns (uint) 
1432     {   
1433         // check input 
1434         require(isLegalCoordinates(fromX, fromY, toX, toY));
1435 
1436         // querry areaPrice in wei at rentals contract
1437         return rentals.blocksRentPrice (numberOfPeriods, blocksList(fromX, fromY, toX, toY));
1438     }
1439 
1440 // ** PLACE ADS ** //
1441     
1442     /// @notice places ads (image, caption and link to a website) into desired coordinates
1443     /// @dev nothing is stored in any of the contracts except an image id. All other data is 
1444     ///  only emitted in event. Basicaly this function just verifies if an event is allowed 
1445     ///  to be emitted.
1446     function placeAds( 
1447         uint8 fromX, 
1448         uint8 fromY, 
1449         uint8 toX, 
1450         uint8 toY, 
1451         string imageSource, 
1452         string link, 
1453         string text
1454     ) 
1455         external
1456         whenNotPaused
1457     {   
1458         // check input
1459         require(isLegalCoordinates(fromX, fromY, toX, toY));
1460 
1461         // try to place ads through ads contract
1462         // will get an image id if succeeds (if advertiser owns or rents all blocks within area)
1463         uint AdsId = ads.advertiseOnBlocks(
1464             msg.sender, 
1465             blocksList(fromX, fromY, toX, toY), 
1466             imageSource, 
1467             link, 
1468             text
1469         );
1470         emit LogAds(AdsId, fromX, fromY, toX, toY, imageSource, link, text, msg.sender);
1471     }
1472 
1473     /// @notice check if an advertiser is allowed to put ads within area (i.e. owns or rents all 
1474     ///  blocks)
1475     function canAdvertise(
1476         address advertiser,
1477         uint8 fromX, 
1478         uint8 fromY, 
1479         uint8 toX, 
1480         uint8 toY
1481     ) 
1482         external
1483         view
1484         returns (bool)
1485     {   
1486         // check user input
1487         require(isLegalCoordinates(fromX, fromY, toX, toY));
1488 
1489         // querry permission at ads contract
1490         return ads.canAdvertiseOnBlocks(advertiser, blocksList(fromX, fromY, toX, toY));
1491     }
1492 
1493 // ** IMPORT BLOCKS ** //
1494 
1495     /// @notice import blocks from previous version Million Ether Homepage
1496     function adminImportOldMEBlock(uint8 x, uint8 y) external onlyOwner {
1497         (uint id, address newLandlord) = market.importOldMEBlock(x, y);
1498         emit LogBuys(id, x, y, x, y, newLandlord);
1499     }
1500 
1501 // ** INFO GETTERS ** //
1502     
1503     /// @notice get an owner(address) of block at a specified coordinates
1504     function getBlockOwner(uint8 x, uint8 y) external view returns (address) {
1505         return ownerOf(blockID(x, y));
1506     }
1507 
1508 // ** UTILS ** //
1509     
1510     /// @notice get ERC721 token id corresponding to xy coordinates
1511     function blockID(uint8 x, uint8 y) public pure returns (uint16) {
1512         return (uint16(y) - 1) * 100 + uint16(x);
1513     }
1514 
1515     /// @notice get a number of blocks within area
1516     function countBlocks(
1517         uint8 fromX, 
1518         uint8 fromY, 
1519         uint8 toX, 
1520         uint8 toY
1521     ) 
1522         internal 
1523         pure 
1524         returns (uint16)
1525     {
1526         return (toX - fromX + 1) * (toY - fromY + 1);
1527     }
1528 
1529     /// @notice get an array of all block ids (i.e. ERC721 token ids) within area
1530     function blocksList(
1531         uint8 fromX, 
1532         uint8 fromY, 
1533         uint8 toX, 
1534         uint8 toY
1535     ) 
1536         internal 
1537         pure 
1538         returns (uint16[] memory r) 
1539     {
1540         uint i = 0;
1541         r = new uint16[](countBlocks(fromX, fromY, toX, toY));
1542         for (uint8 ix=fromX; ix<=toX; ix++) {
1543             for (uint8 iy=fromY; iy<=toY; iy++) {
1544                 r[i] = blockID(ix, iy);
1545                 i++;
1546             }
1547         }
1548     }
1549     
1550     /// @notice insures that area coordinates are within 100x100 field and 
1551     ///  from-coordinates >= to-coordinates
1552     /// @dev function is used instead of modifier as modifier 
1553     ///  required too much stack for placeImage and rentBlocks
1554     function isLegalCoordinates(
1555         uint8 _fromX, 
1556         uint8 _fromY, 
1557         uint8 _toX, 
1558         uint8 _toY
1559     )    
1560         private 
1561         pure 
1562         returns (bool) 
1563     {
1564         return ((_fromX >= 1) && (_fromY >=1)  && (_toX <= 100) && (_toY <= 100) 
1565             && (_fromX <= _toX) && (_fromY <= _toY));
1566     }
1567 }
1568 
1569 // File: contracts/MehModule.sol
1570 
1571 /// @title MehModule: Base contract for MEH modules (Market, Rentals and Ads contracts). Provides
1572 ///  communication with MEH contract. 
1573 contract MehModule is Ownable, Pausable, Destructible, HasNoEther {
1574     using SafeMath for uint256;
1575 
1576     // Main MEH contract
1577     MEH public meh;
1578 
1579     /// @dev Initializes a module, pairs with MEH contract.
1580     /// @param _mehAddress address of the main Million Ether Homepage contract
1581     constructor(address _mehAddress) public {
1582         adminSetMeh(_mehAddress);
1583     }
1584     
1585     /// @dev Throws if called by any address other than the MEH contract.
1586     modifier onlyMeh() {
1587         require(msg.sender == address(meh));
1588         _;
1589     }
1590 
1591     /// @dev Pairs a module with MEH main contract.
1592     function adminSetMeh(address _address) internal onlyOwner {
1593         MEH candidateContract = MEH(_address);
1594         require(candidateContract.isMEH());
1595         meh = candidateContract;
1596     }
1597 
1598     /// @dev Makes an internal transaction in the MEH contract.
1599     function transferFunds(address _payer, address _recipient, uint _amount) internal {
1600         return meh.operatorTransferFunds(_payer, _recipient, _amount);
1601     }
1602 
1603     /// @dev Check if a token exists.
1604     function exists(uint16 _blockId) internal view  returns (bool) {
1605         return meh.exists(_blockId);
1606     }
1607 
1608     /// @dev Querries an owner of a block id (ERC721 token).
1609     function ownerOf(uint16 _blockId) internal view returns (address) {
1610         return meh.ownerOf(_blockId);
1611     }
1612 }
1613 
1614 // File: contracts/Rentals.sol
1615 
1616 // @title Rentals: Pluggable module for MEH contract responsible for rentout-rent operations.
1617 // @dev this contract is unaware of xy block coordinates - ids only (ids are ERC721 tokens)
1618 contract Rentals is MehModule {
1619     
1620     // For MEH contract to be sure it plugged the right module in
1621     bool public isRentals = true;
1622 
1623     // Minimum rent period and a unit to measure rent lenght
1624     uint public rentPeriod = 1 days;
1625     // Maximum rent period (can be adjusted by admin)
1626     uint public maxRentPeriod = 90;  // can be changed in settings 
1627 
1628     // Rent deal struct. A 10x10 pixel block can have only one rent deal.
1629     struct RentDeal {
1630         address renter;  // block renter
1631         uint rentedFrom;  // time when rent started
1632         uint numberOfPeriods;  //periods available
1633     }
1634     mapping(uint16 => RentDeal) public blockIdToRentDeal;
1635 
1636     // Rent is allowed if price is > 0
1637     mapping(uint16 => uint) public blockIdToRentPrice;
1638 
1639     // Keeps track of rentout-rent operations
1640     uint public numRentStatuses = 0;
1641 
1642 // ** INITIALIZE ** //
1643 
1644     /// @dev Initialize Rentals contract.
1645     /// @param _mehAddress address of the main Million Ether Homepage contract
1646     constructor(address _mehAddress) MehModule(_mehAddress) public {}
1647 
1648 // ** RENT AOUT BLOCKS ** //
1649     
1650     /// @dev Rent out a list of blocks referenced by block ids. Set rent price per period in wei.
1651     function rentOutBlocks(address _landlord, uint _rentPricePerPeriodWei, uint16[] _blockList) 
1652         external
1653         onlyMeh
1654         whenNotPaused
1655         returns (uint)
1656     {   
1657         for (uint i = 0; i < _blockList.length; i++) {
1658             require(_landlord == ownerOf(_blockList[i]));
1659             rentOutBlock(_blockList[i], _rentPricePerPeriodWei);
1660         }
1661         numRentStatuses++;
1662         return numRentStatuses;
1663     }
1664 
1665     /// @dev Set rent price for a block. Independent on rent deal. Does not affect current 
1666     ///  rent deal.
1667     function rentOutBlock(uint16 _blockId, uint _rentPricePerPeriodWei) 
1668         internal
1669     {   
1670         blockIdToRentPrice[_blockId] = _rentPricePerPeriodWei;
1671     }
1672 
1673 // ** RENT BLOCKS ** //
1674     
1675     /// @dev Rent a list of blocks referenced by block ids for a number of periods.
1676     function rentBlocks(address _renter, uint _numberOfPeriods, uint16[] _blockList) 
1677         external
1678         onlyMeh
1679         whenNotPaused
1680         returns (uint)
1681     {   
1682         /// check user input (not in the MEH contract to add future flexibility)
1683         require(_numberOfPeriods > 0);
1684 
1685         for (uint i = 0; i < _blockList.length; i++) {
1686             rentBlock(_renter, _blockList[i], _numberOfPeriods);
1687         }
1688         numRentStatuses++;
1689         return numRentStatuses;
1690     }
1691 
1692     /// @dev Rent a block by id for a number of periods. 
1693     function rentBlock (address _renter, uint16 _blockId, uint _numberOfPeriods)
1694         internal
1695     {   
1696         // check input
1697         require(maxRentPeriod >= _numberOfPeriods);
1698         address landlord = ownerOf(_blockId);
1699         require(_renter != landlord);
1700 
1701         // throws if not for rent (if rent price == 0)
1702         require(isForRent(_blockId));
1703         // get price
1704         uint totalRent = getRentPrice(_blockId).mul(_numberOfPeriods);  // overflow safe
1705         
1706         transferFunds(_renter, landlord, totalRent);
1707         createRentDeal(_blockId, _renter, now, _numberOfPeriods);
1708     }
1709 
1710     /// @dev Checks if block is for rent.
1711     function isForRent(uint16 _blockId) public view returns (bool) {
1712         return (blockIdToRentPrice[_blockId] > 0);
1713     }
1714 
1715     /// @dev Checks if block rented and the rent hasn't expired.
1716     function isRented(uint16 _blockId) public view returns (bool) {
1717         RentDeal memory deal = blockIdToRentDeal[_blockId];
1718         // prevents overflow if unlimited num of periods is set 
1719         uint rentedTill = 
1720             deal.numberOfPeriods.mul(rentPeriod).add(deal.rentedFrom);
1721         return (rentedTill > now);
1722     }
1723 
1724     /// @dev Gets rent price for block. Throws if not for rent or if 
1725     ///  current rent is active.
1726     function getRentPrice(uint16 _blockId) internal view returns (uint) {
1727         require(!(isRented(_blockId)));
1728         return blockIdToRentPrice[_blockId];
1729     }
1730 
1731     /// @dev Gets renter of a block. Throws if not rented.
1732     function renterOf(uint16 _blockId) public view returns (address) {
1733         require(isRented(_blockId));
1734         return blockIdToRentDeal[_blockId].renter;
1735     }
1736 
1737     /// @dev Creates new rent deal.
1738     function createRentDeal(
1739         uint16 _blockId, 
1740         address _renter, 
1741         uint _rentedFrom, 
1742         uint _numberOfPeriods
1743     ) 
1744         private 
1745     {
1746         blockIdToRentDeal[_blockId].renter = _renter;
1747         blockIdToRentDeal[_blockId].rentedFrom = _rentedFrom;
1748         blockIdToRentDeal[_blockId].numberOfPeriods = _numberOfPeriods;
1749     }
1750 
1751 // ** RENT PRICE ** //
1752     
1753     /// @dev Calculates rent price for a list of blocks. Throws if at least one block
1754     ///  is not available for rent.
1755     function blocksRentPrice(uint _numberOfPeriods, uint16[] _blockList) 
1756         external
1757         view
1758         returns (uint)
1759     {   
1760         uint totalPrice = 0;
1761         for (uint i = 0; i < _blockList.length; i++) {
1762             // overflow safe (rentPrice is arbitary)
1763             totalPrice = getRentPrice(_blockList[i]).mul(_numberOfPeriods).add(totalPrice);
1764         }
1765         return totalPrice;
1766     }
1767 
1768 // ** ADMIN ** //
1769     
1770     /// @dev Adjusts max rent period (only contract owner)
1771     function adminSetMaxRentPeriod(uint newMaxRentPeriod) external onlyOwner {
1772         require (newMaxRentPeriod > 0);
1773         maxRentPeriod = newMaxRentPeriod;
1774     }
1775 }