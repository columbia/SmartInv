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
67 // File: contracts/Factory.sol
68 
69 /**
70  * This is a generic factory contract that can be used to mint tokens. The configuration
71  * for minting is specified by an _optionId, which can be used to delineate various 
72  * ways of minting.
73  */
74 interface Factory {
75   /**
76    * Returns the name of this factory.
77    */
78   function name() external view returns (string);
79 
80   /**
81    * Returns the symbol for this factory.
82    */
83   function symbol() external view returns (string);
84 
85   /**
86    * Number of options the factory supports.
87    */
88   function numOptions() public view returns (uint256);
89 
90   /**
91    * @dev Returns whether the option ID can be minted. Can return false if the developer wishes to
92    * restrict a total supply per option ID (or overall).
93    */
94   function canMint(uint256 _optionId) public view returns (bool);
95 
96   /**
97    * @dev Returns a URL specifying some metadata about the option. This metadata can be of the
98    * same structure as the ERC721 metadata.
99    */
100   function tokenURI(uint256 _optionId) public view returns (string);
101 
102   /**
103    * Indicates that this is a factory contract. Ideally would use EIP 165 supportsInterface()
104    */
105   function supportsFactoryInterface() public view returns (bool);
106 
107   /**
108     * @dev Mints asset(s) in accordance to a specific address with a particular "option". This should be 
109     * callable only by the contract owner or the owner's Wyvern Proxy (later universal login will solve this).
110     * Options should also be delineated 0 - (numOptions() - 1) for convenient indexing.
111     * @param _optionId the option id
112     * @param _toAddress address of the future owner of the asset(s)
113     */
114   function mint(uint256 _optionId, address _toAddress) external;
115 }
116 
117 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
118 
119 /**
120  * @title ERC165
121  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
122  */
123 interface ERC165 {
124 
125   /**
126    * @notice Query if a contract implements an interface
127    * @param _interfaceId The interface identifier, as specified in ERC-165
128    * @dev Interface identification is specified in ERC-165. This function
129    * uses less than 30,000 gas.
130    */
131   function supportsInterface(bytes4 _interfaceId)
132     external
133     view
134     returns (bool);
135 }
136 
137 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
138 
139 /**
140  * @title ERC721 Non-Fungible Token Standard basic interface
141  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721Basic is ERC165 {
144 
145   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
146   /*
147    * 0x80ac58cd ===
148    *   bytes4(keccak256('balanceOf(address)')) ^
149    *   bytes4(keccak256('ownerOf(uint256)')) ^
150    *   bytes4(keccak256('approve(address,uint256)')) ^
151    *   bytes4(keccak256('getApproved(uint256)')) ^
152    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
153    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
154    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
155    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
156    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
157    */
158 
159   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
160   /*
161    * 0x4f558e79 ===
162    *   bytes4(keccak256('exists(uint256)'))
163    */
164 
165   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
166   /**
167    * 0x780e9d63 ===
168    *   bytes4(keccak256('totalSupply()')) ^
169    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
170    *   bytes4(keccak256('tokenByIndex(uint256)'))
171    */
172 
173   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
174   /**
175    * 0x5b5e139f ===
176    *   bytes4(keccak256('name()')) ^
177    *   bytes4(keccak256('symbol()')) ^
178    *   bytes4(keccak256('tokenURI(uint256)'))
179    */
180 
181   event Transfer(
182     address indexed _from,
183     address indexed _to,
184     uint256 indexed _tokenId
185   );
186   event Approval(
187     address indexed _owner,
188     address indexed _approved,
189     uint256 indexed _tokenId
190   );
191   event ApprovalForAll(
192     address indexed _owner,
193     address indexed _operator,
194     bool _approved
195   );
196 
197   function balanceOf(address _owner) public view returns (uint256 _balance);
198   function ownerOf(uint256 _tokenId) public view returns (address _owner);
199   function exists(uint256 _tokenId) public view returns (bool _exists);
200 
201   function approve(address _to, uint256 _tokenId) public;
202   function getApproved(uint256 _tokenId)
203     public view returns (address _operator);
204 
205   function setApprovalForAll(address _operator, bool _approved) public;
206   function isApprovedForAll(address _owner, address _operator)
207     public view returns (bool);
208 
209   function transferFrom(address _from, address _to, uint256 _tokenId) public;
210   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
211     public;
212 
213   function safeTransferFrom(
214     address _from,
215     address _to,
216     uint256 _tokenId,
217     bytes _data
218   )
219     public;
220 }
221 
222 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
226  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
227  */
228 contract ERC721Enumerable is ERC721Basic {
229   function totalSupply() public view returns (uint256);
230   function tokenOfOwnerByIndex(
231     address _owner,
232     uint256 _index
233   )
234     public
235     view
236     returns (uint256 _tokenId);
237 
238   function tokenByIndex(uint256 _index) public view returns (uint256);
239 }
240 
241 
242 /**
243  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
244  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
245  */
246 contract ERC721Metadata is ERC721Basic {
247   function name() external view returns (string _name);
248   function symbol() external view returns (string _symbol);
249   function tokenURI(uint256 _tokenId) public view returns (string);
250 }
251 
252 
253 /**
254  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
255  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
256  */
257 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
258 }
259 
260 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 contract ERC721Receiver {
268   /**
269    * @dev Magic value to be returned upon successful reception of an NFT
270    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
271    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
272    */
273   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
274 
275   /**
276    * @notice Handle the receipt of an NFT
277    * @dev The ERC721 smart contract calls this function on the recipient
278    * after a `safetransfer`. This function MAY throw to revert and reject the
279    * transfer. Return of other than the magic value MUST result in the
280    * transaction being reverted.
281    * Note: the contract address is always the message sender.
282    * @param _operator The address which called `safeTransferFrom` function
283    * @param _from The address which previously owned the token
284    * @param _tokenId The NFT identifier which is being transferred
285    * @param _data Additional data with no specified format
286    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
287    */
288   function onERC721Received(
289     address _operator,
290     address _from,
291     uint256 _tokenId,
292     bytes _data
293   )
294     public
295     returns(bytes4);
296 }
297 
298 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
299 
300 /**
301  * @title SafeMath
302  * @dev Math operations with safety checks that throw on error
303  */
304 library SafeMath {
305 
306   /**
307   * @dev Multiplies two numbers, throws on overflow.
308   */
309   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
310     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
311     // benefit is lost if 'b' is also tested.
312     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
313     if (_a == 0) {
314       return 0;
315     }
316 
317     c = _a * _b;
318     assert(c / _a == _b);
319     return c;
320   }
321 
322   /**
323   * @dev Integer division of two numbers, truncating the quotient.
324   */
325   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
326     // assert(_b > 0); // Solidity automatically throws when dividing by 0
327     // uint256 c = _a / _b;
328     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
329     return _a / _b;
330   }
331 
332   /**
333   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
334   */
335   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
336     assert(_b <= _a);
337     return _a - _b;
338   }
339 
340   /**
341   * @dev Adds two numbers, throws on overflow.
342   */
343   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
344     c = _a + _b;
345     assert(c >= _a);
346     return c;
347   }
348 }
349 
350 // File: openzeppelin-solidity/contracts/AddressUtils.sol
351 
352 /**
353  * Utility library of inline functions on addresses
354  */
355 library AddressUtils {
356 
357   /**
358    * Returns whether the target address is a contract
359    * @dev This function will return false if invoked during the constructor of a contract,
360    * as the code is not actually created until after the constructor finishes.
361    * @param _addr address to check
362    * @return whether the target address is a contract
363    */
364   function isContract(address _addr) internal view returns (bool) {
365     uint256 size;
366     // XXX Currently there is no better way to check if there is a contract in an address
367     // than to check the size of the code at that address.
368     // See https://ethereum.stackexchange.com/a/14016/36603
369     // for more details about how this works.
370     // TODO Check this again before the Serenity release, because all addresses will be
371     // contracts then.
372     // solium-disable-next-line security/no-inline-assembly
373     assembly { size := extcodesize(_addr) }
374     return size > 0;
375   }
376 
377 }
378 
379 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
380 
381 /**
382  * @title SupportsInterfaceWithLookup
383  * @author Matt Condon (@shrugs)
384  * @dev Implements ERC165 using a lookup table.
385  */
386 contract SupportsInterfaceWithLookup is ERC165 {
387 
388   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
389   /**
390    * 0x01ffc9a7 ===
391    *   bytes4(keccak256('supportsInterface(bytes4)'))
392    */
393 
394   /**
395    * @dev a mapping of interface id to whether or not it's supported
396    */
397   mapping(bytes4 => bool) internal supportedInterfaces;
398 
399   /**
400    * @dev A contract implementing SupportsInterfaceWithLookup
401    * implement ERC165 itself
402    */
403   constructor()
404     public
405   {
406     _registerInterface(InterfaceId_ERC165);
407   }
408 
409   /**
410    * @dev implement supportsInterface(bytes4) using a lookup table
411    */
412   function supportsInterface(bytes4 _interfaceId)
413     external
414     view
415     returns (bool)
416   {
417     return supportedInterfaces[_interfaceId];
418   }
419 
420   /**
421    * @dev private method for registering an interface
422    */
423   function _registerInterface(bytes4 _interfaceId)
424     internal
425   {
426     require(_interfaceId != 0xffffffff);
427     supportedInterfaces[_interfaceId] = true;
428   }
429 }
430 
431 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
432 
433 /**
434  * @title ERC721 Non-Fungible Token Standard basic implementation
435  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
436  */
437 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
438 
439   using SafeMath for uint256;
440   using AddressUtils for address;
441 
442   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
443   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
444   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
445 
446   // Mapping from token ID to owner
447   mapping (uint256 => address) internal tokenOwner;
448 
449   // Mapping from token ID to approved address
450   mapping (uint256 => address) internal tokenApprovals;
451 
452   // Mapping from owner to number of owned token
453   mapping (address => uint256) internal ownedTokensCount;
454 
455   // Mapping from owner to operator approvals
456   mapping (address => mapping (address => bool)) internal operatorApprovals;
457 
458   constructor()
459     public
460   {
461     // register the supported interfaces to conform to ERC721 via ERC165
462     _registerInterface(InterfaceId_ERC721);
463     _registerInterface(InterfaceId_ERC721Exists);
464   }
465 
466   /**
467    * @dev Gets the balance of the specified address
468    * @param _owner address to query the balance of
469    * @return uint256 representing the amount owned by the passed address
470    */
471   function balanceOf(address _owner) public view returns (uint256) {
472     require(_owner != address(0));
473     return ownedTokensCount[_owner];
474   }
475 
476   /**
477    * @dev Gets the owner of the specified token ID
478    * @param _tokenId uint256 ID of the token to query the owner of
479    * @return owner address currently marked as the owner of the given token ID
480    */
481   function ownerOf(uint256 _tokenId) public view returns (address) {
482     address owner = tokenOwner[_tokenId];
483     require(owner != address(0));
484     return owner;
485   }
486 
487   /**
488    * @dev Returns whether the specified token exists
489    * @param _tokenId uint256 ID of the token to query the existence of
490    * @return whether the token exists
491    */
492   function exists(uint256 _tokenId) public view returns (bool) {
493     address owner = tokenOwner[_tokenId];
494     return owner != address(0);
495   }
496 
497   /**
498    * @dev Approves another address to transfer the given token ID
499    * The zero address indicates there is no approved address.
500    * There can only be one approved address per token at a given time.
501    * Can only be called by the token owner or an approved operator.
502    * @param _to address to be approved for the given token ID
503    * @param _tokenId uint256 ID of the token to be approved
504    */
505   function approve(address _to, uint256 _tokenId) public {
506     address owner = ownerOf(_tokenId);
507     require(_to != owner);
508     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
509 
510     tokenApprovals[_tokenId] = _to;
511     emit Approval(owner, _to, _tokenId);
512   }
513 
514   /**
515    * @dev Gets the approved address for a token ID, or zero if no address set
516    * @param _tokenId uint256 ID of the token to query the approval of
517    * @return address currently approved for the given token ID
518    */
519   function getApproved(uint256 _tokenId) public view returns (address) {
520     return tokenApprovals[_tokenId];
521   }
522 
523   /**
524    * @dev Sets or unsets the approval of a given operator
525    * An operator is allowed to transfer all tokens of the sender on their behalf
526    * @param _to operator address to set the approval
527    * @param _approved representing the status of the approval to be set
528    */
529   function setApprovalForAll(address _to, bool _approved) public {
530     require(_to != msg.sender);
531     operatorApprovals[msg.sender][_to] = _approved;
532     emit ApprovalForAll(msg.sender, _to, _approved);
533   }
534 
535   /**
536    * @dev Tells whether an operator is approved by a given owner
537    * @param _owner owner address which you want to query the approval of
538    * @param _operator operator address which you want to query the approval of
539    * @return bool whether the given operator is approved by the given owner
540    */
541   function isApprovedForAll(
542     address _owner,
543     address _operator
544   )
545     public
546     view
547     returns (bool)
548   {
549     return operatorApprovals[_owner][_operator];
550   }
551 
552   /**
553    * @dev Transfers the ownership of a given token ID to another address
554    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
555    * Requires the msg sender to be the owner, approved, or operator
556    * @param _from current owner of the token
557    * @param _to address to receive the ownership of the given token ID
558    * @param _tokenId uint256 ID of the token to be transferred
559   */
560   function transferFrom(
561     address _from,
562     address _to,
563     uint256 _tokenId
564   )
565     public
566   {
567     require(isApprovedOrOwner(msg.sender, _tokenId));
568     require(_from != address(0));
569     require(_to != address(0));
570 
571     clearApproval(_from, _tokenId);
572     removeTokenFrom(_from, _tokenId);
573     addTokenTo(_to, _tokenId);
574 
575     emit Transfer(_from, _to, _tokenId);
576   }
577 
578   /**
579    * @dev Safely transfers the ownership of a given token ID to another address
580    * If the target address is a contract, it must implement `onERC721Received`,
581    * which is called upon a safe transfer, and return the magic value
582    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
583    * the transfer is reverted.
584    *
585    * Requires the msg sender to be the owner, approved, or operator
586    * @param _from current owner of the token
587    * @param _to address to receive the ownership of the given token ID
588    * @param _tokenId uint256 ID of the token to be transferred
589   */
590   function safeTransferFrom(
591     address _from,
592     address _to,
593     uint256 _tokenId
594   )
595     public
596   {
597     // solium-disable-next-line arg-overflow
598     safeTransferFrom(_from, _to, _tokenId, "");
599   }
600 
601   /**
602    * @dev Safely transfers the ownership of a given token ID to another address
603    * If the target address is a contract, it must implement `onERC721Received`,
604    * which is called upon a safe transfer, and return the magic value
605    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
606    * the transfer is reverted.
607    * Requires the msg sender to be the owner, approved, or operator
608    * @param _from current owner of the token
609    * @param _to address to receive the ownership of the given token ID
610    * @param _tokenId uint256 ID of the token to be transferred
611    * @param _data bytes data to send along with a safe transfer check
612    */
613   function safeTransferFrom(
614     address _from,
615     address _to,
616     uint256 _tokenId,
617     bytes _data
618   )
619     public
620   {
621     transferFrom(_from, _to, _tokenId);
622     // solium-disable-next-line arg-overflow
623     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
624   }
625 
626   /**
627    * @dev Returns whether the given spender can transfer a given token ID
628    * @param _spender address of the spender to query
629    * @param _tokenId uint256 ID of the token to be transferred
630    * @return bool whether the msg.sender is approved for the given token ID,
631    *  is an operator of the owner, or is the owner of the token
632    */
633   function isApprovedOrOwner(
634     address _spender,
635     uint256 _tokenId
636   )
637     internal
638     view
639     returns (bool)
640   {
641     address owner = ownerOf(_tokenId);
642     // Disable solium check because of
643     // https://github.com/duaraghav8/Solium/issues/175
644     // solium-disable-next-line operator-whitespace
645     return (
646       _spender == owner ||
647       getApproved(_tokenId) == _spender ||
648       isApprovedForAll(owner, _spender)
649     );
650   }
651 
652   /**
653    * @dev Internal function to mint a new token
654    * Reverts if the given token ID already exists
655    * @param _to The address that will own the minted token
656    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
657    */
658   function _mint(address _to, uint256 _tokenId) internal {
659     require(_to != address(0));
660     addTokenTo(_to, _tokenId);
661     emit Transfer(address(0), _to, _tokenId);
662   }
663 
664   /**
665    * @dev Internal function to burn a specific token
666    * Reverts if the token does not exist
667    * @param _tokenId uint256 ID of the token being burned by the msg.sender
668    */
669   function _burn(address _owner, uint256 _tokenId) internal {
670     clearApproval(_owner, _tokenId);
671     removeTokenFrom(_owner, _tokenId);
672     emit Transfer(_owner, address(0), _tokenId);
673   }
674 
675   /**
676    * @dev Internal function to clear current approval of a given token ID
677    * Reverts if the given address is not indeed the owner of the token
678    * @param _owner owner of the token
679    * @param _tokenId uint256 ID of the token to be transferred
680    */
681   function clearApproval(address _owner, uint256 _tokenId) internal {
682     require(ownerOf(_tokenId) == _owner);
683     if (tokenApprovals[_tokenId] != address(0)) {
684       tokenApprovals[_tokenId] = address(0);
685     }
686   }
687 
688   /**
689    * @dev Internal function to add a token ID to the list of a given address
690    * @param _to address representing the new owner of the given token ID
691    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
692    */
693   function addTokenTo(address _to, uint256 _tokenId) internal {
694     require(tokenOwner[_tokenId] == address(0));
695     tokenOwner[_tokenId] = _to;
696     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
697   }
698 
699   /**
700    * @dev Internal function to remove a token ID from the list of a given address
701    * @param _from address representing the previous owner of the given token ID
702    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
703    */
704   function removeTokenFrom(address _from, uint256 _tokenId) internal {
705     require(ownerOf(_tokenId) == _from);
706     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
707     tokenOwner[_tokenId] = address(0);
708   }
709 
710   /**
711    * @dev Internal function to invoke `onERC721Received` on a target address
712    * The call is not executed if the target address is not a contract
713    * @param _from address representing the previous owner of the given token ID
714    * @param _to target address that will receive the tokens
715    * @param _tokenId uint256 ID of the token to be transferred
716    * @param _data bytes optional data to send along with the call
717    * @return whether the call correctly returned the expected magic value
718    */
719   function checkAndCallSafeTransfer(
720     address _from,
721     address _to,
722     uint256 _tokenId,
723     bytes _data
724   )
725     internal
726     returns (bool)
727   {
728     if (!_to.isContract()) {
729       return true;
730     }
731     bytes4 retval = ERC721Receiver(_to).onERC721Received(
732       msg.sender, _from, _tokenId, _data);
733     return (retval == ERC721_RECEIVED);
734   }
735 }
736 
737 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
738 
739 /**
740  * @title Full ERC721 Token
741  * This implementation includes all the required and some optional functionality of the ERC721 standard
742  * Moreover, it includes approve all functionality using operator terminology
743  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
744  */
745 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
746 
747   // Token name
748   string internal name_;
749 
750   // Token symbol
751   string internal symbol_;
752 
753   // Mapping from owner to list of owned token IDs
754   mapping(address => uint256[]) internal ownedTokens;
755 
756   // Mapping from token ID to index of the owner tokens list
757   mapping(uint256 => uint256) internal ownedTokensIndex;
758 
759   // Array with all token ids, used for enumeration
760   uint256[] internal allTokens;
761 
762   // Mapping from token id to position in the allTokens array
763   mapping(uint256 => uint256) internal allTokensIndex;
764 
765   // Optional mapping for token URIs
766   mapping(uint256 => string) internal tokenURIs;
767 
768   /**
769    * @dev Constructor function
770    */
771   constructor(string _name, string _symbol) public {
772     name_ = _name;
773     symbol_ = _symbol;
774 
775     // register the supported interfaces to conform to ERC721 via ERC165
776     _registerInterface(InterfaceId_ERC721Enumerable);
777     _registerInterface(InterfaceId_ERC721Metadata);
778   }
779 
780   /**
781    * @dev Gets the token name
782    * @return string representing the token name
783    */
784   function name() external view returns (string) {
785     return name_;
786   }
787 
788   /**
789    * @dev Gets the token symbol
790    * @return string representing the token symbol
791    */
792   function symbol() external view returns (string) {
793     return symbol_;
794   }
795 
796   /**
797    * @dev Returns an URI for a given token ID
798    * Throws if the token ID does not exist. May return an empty string.
799    * @param _tokenId uint256 ID of the token to query
800    */
801   function tokenURI(uint256 _tokenId) public view returns (string) {
802     require(exists(_tokenId));
803     return tokenURIs[_tokenId];
804   }
805 
806   /**
807    * @dev Gets the token ID at a given index of the tokens list of the requested owner
808    * @param _owner address owning the tokens list to be accessed
809    * @param _index uint256 representing the index to be accessed of the requested tokens list
810    * @return uint256 token ID at the given index of the tokens list owned by the requested address
811    */
812   function tokenOfOwnerByIndex(
813     address _owner,
814     uint256 _index
815   )
816     public
817     view
818     returns (uint256)
819   {
820     require(_index < balanceOf(_owner));
821     return ownedTokens[_owner][_index];
822   }
823 
824   /**
825    * @dev Gets the total amount of tokens stored by the contract
826    * @return uint256 representing the total amount of tokens
827    */
828   function totalSupply() public view returns (uint256) {
829     return allTokens.length;
830   }
831 
832   /**
833    * @dev Gets the token ID at a given index of all the tokens in this contract
834    * Reverts if the index is greater or equal to the total number of tokens
835    * @param _index uint256 representing the index to be accessed of the tokens list
836    * @return uint256 token ID at the given index of the tokens list
837    */
838   function tokenByIndex(uint256 _index) public view returns (uint256) {
839     require(_index < totalSupply());
840     return allTokens[_index];
841   }
842 
843   /**
844    * @dev Internal function to set the token URI for a given token
845    * Reverts if the token ID does not exist
846    * @param _tokenId uint256 ID of the token to set its URI
847    * @param _uri string URI to assign
848    */
849   function _setTokenURI(uint256 _tokenId, string _uri) internal {
850     require(exists(_tokenId));
851     tokenURIs[_tokenId] = _uri;
852   }
853 
854   /**
855    * @dev Internal function to add a token ID to the list of a given address
856    * @param _to address representing the new owner of the given token ID
857    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
858    */
859   function addTokenTo(address _to, uint256 _tokenId) internal {
860     super.addTokenTo(_to, _tokenId);
861     uint256 length = ownedTokens[_to].length;
862     ownedTokens[_to].push(_tokenId);
863     ownedTokensIndex[_tokenId] = length;
864   }
865 
866   /**
867    * @dev Internal function to remove a token ID from the list of a given address
868    * @param _from address representing the previous owner of the given token ID
869    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
870    */
871   function removeTokenFrom(address _from, uint256 _tokenId) internal {
872     super.removeTokenFrom(_from, _tokenId);
873 
874     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
875     // then delete the last slot.
876     uint256 tokenIndex = ownedTokensIndex[_tokenId];
877     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
878     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
879 
880     ownedTokens[_from][tokenIndex] = lastToken;
881     // This also deletes the contents at the last position of the array
882     ownedTokens[_from].length--;
883 
884     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
885     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
886     // the lastToken to the first position, and then dropping the element placed in the last position of the list
887 
888     ownedTokensIndex[_tokenId] = 0;
889     ownedTokensIndex[lastToken] = tokenIndex;
890   }
891 
892   /**
893    * @dev Internal function to mint a new token
894    * Reverts if the given token ID already exists
895    * @param _to address the beneficiary that will own the minted token
896    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
897    */
898   function _mint(address _to, uint256 _tokenId) internal {
899     super._mint(_to, _tokenId);
900 
901     allTokensIndex[_tokenId] = allTokens.length;
902     allTokens.push(_tokenId);
903   }
904 
905   /**
906    * @dev Internal function to burn a specific token
907    * Reverts if the token does not exist
908    * @param _owner owner of the token to burn
909    * @param _tokenId uint256 ID of the token being burned by the msg.sender
910    */
911   function _burn(address _owner, uint256 _tokenId) internal {
912     super._burn(_owner, _tokenId);
913 
914     // Clear metadata (if any)
915     if (bytes(tokenURIs[_tokenId]).length != 0) {
916       delete tokenURIs[_tokenId];
917     }
918 
919     // Reorg all tokens array
920     uint256 tokenIndex = allTokensIndex[_tokenId];
921     uint256 lastTokenIndex = allTokens.length.sub(1);
922     uint256 lastToken = allTokens[lastTokenIndex];
923 
924     allTokens[tokenIndex] = lastToken;
925     allTokens[lastTokenIndex] = 0;
926 
927     allTokens.length--;
928     allTokensIndex[_tokenId] = 0;
929     allTokensIndex[lastToken] = tokenIndex;
930   }
931 
932 }
933 
934 // File: contracts/Strings.sol
935 
936 library Strings {
937   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
938   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
939       bytes memory _ba = bytes(_a);
940       bytes memory _bb = bytes(_b);
941       bytes memory _bc = bytes(_c);
942       bytes memory _bd = bytes(_d);
943       bytes memory _be = bytes(_e);
944       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
945       bytes memory babcde = bytes(abcde);
946       uint k = 0;
947       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
948       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
949       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
950       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
951       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
952       return string(babcde);
953     }
954 
955     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
956         return strConcat(_a, _b, _c, _d, "");
957     }
958 
959     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
960         return strConcat(_a, _b, _c, "", "");
961     }
962 
963     function strConcat(string _a, string _b) internal pure returns (string) {
964         return strConcat(_a, _b, "", "", "");
965     }
966 
967     function uint2str(uint i) internal pure returns (string) {
968         if (i == 0) return "0";
969         uint j = i;
970         uint len;
971         while (j != 0){
972             len++;
973             j /= 10;
974         }
975         bytes memory bstr = new bytes(len);
976         uint k = len - 1;
977         while (i != 0){
978             bstr[k--] = byte(48 + i % 10);
979             i /= 10;
980         }
981         return string(bstr);
982     }
983 }
984 
985 // File: contracts/TradeableERC721Token.sol
986 
987 contract OwnableDelegateProxy { }
988 
989 contract ProxyRegistry {
990     mapping(address => OwnableDelegateProxy) public proxies;
991 }
992 
993 /**
994  * @title TradeableERC721Token
995  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
996  */
997 contract TradeableERC721Token is ERC721Token, Ownable {
998   using Strings for string;
999 
1000   address proxyRegistryAddress;
1001   
1002   // Mapping from token ID to item type.
1003   mapping (uint256 => uint256) public itemTypes;
1004 
1005   constructor(string _name, string _symbol, address _proxyRegistryAddress) ERC721Token(_name, _symbol) public {
1006     proxyRegistryAddress = _proxyRegistryAddress;
1007   }
1008 
1009   /**
1010     * @dev Mints a token to an address with a tokenURI.
1011     * @param _to address of the future owner of the token
1012     */
1013   function mintTo(address _to, uint256 _itemType) public onlyOwner {
1014     uint256 newTokenId = _getNextTokenId();
1015     _mint(_to, newTokenId);
1016     itemTypes[newTokenId] = _itemType;
1017   }
1018 
1019   /**
1020     * @dev calculates the next token ID based on totalSupply
1021     * @return uint256 for the next token ID
1022     */
1023   function _getNextTokenId() private view returns (uint256) {
1024     return totalSupply().add(1);
1025   }
1026 
1027   function baseTokenURI() public view returns (string) {
1028     return "";
1029   }
1030 
1031   function tokenURI(uint256 _tokenId) public view returns (string) {
1032     return Strings.strConcat(
1033         baseTokenURI(),
1034         Strings.uint2str(itemTypes[_tokenId]),
1035         "/",
1036         Strings.uint2str(_tokenId)
1037     );
1038   }
1039 
1040   /**
1041    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1042    */
1043   function isApprovedForAll(
1044     address owner,
1045     address operator
1046   )
1047     public
1048     view
1049     returns (bool)
1050   {
1051     // Whitelist OpenSea proxy contract for easy trading.
1052     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1053     if (proxyRegistry.proxies(owner) == operator) {
1054         return true;
1055     }
1056 
1057     return super.isApprovedForAll(owner, operator);
1058   }
1059 }
1060 
1061 // File: contracts/Item.sol
1062 
1063 /**
1064  * @title Item
1065  * Item - a contract for my non-fungible items.
1066  */
1067 contract Item is TradeableERC721Token {
1068   constructor(address _proxyRegistryAddress) TradeableERC721Token("Item", "ITM", _proxyRegistryAddress) public {  }
1069 
1070   function baseTokenURI() public view returns (string) {
1071     return "https://cadaf-metadata.herokuapp.com/api/item/";
1072   }
1073 }
1074 
1075 // File: contracts/ItemFactory.sol
1076 
1077 contract ItemFactory is Factory, Ownable {
1078   using Strings for string;
1079 
1080   address public proxyRegistryAddress;
1081   address public nftAddress;
1082   address public lootBoxNftAddress;
1083   string public baseURI = "https://cadaf-metadata.herokuapp.com/api/factory/";
1084   
1085   uint256 NUM_OPTIONS = 0;
1086 
1087   constructor(address _proxyRegistryAddress, address _nftAddress) public {
1088     proxyRegistryAddress = _proxyRegistryAddress;
1089     nftAddress = _nftAddress;
1090   }
1091 
1092   function name() external view returns (string) {
1093     return "Item Sale";
1094   }
1095 
1096   function symbol() external view returns (string) {
1097     return "ISL";
1098   }
1099 
1100   function supportsFactoryInterface() public view returns (bool) {
1101     return true;
1102   }
1103 
1104   function numOptions() public view returns (uint256) {
1105     return NUM_OPTIONS;
1106   }
1107 
1108   function setNumOptions(uint256 numOptions) public onlyOwner {
1109     NUM_OPTIONS = numOptions;
1110   }
1111   
1112   function mint(uint256 _optionId, address _toAddress) public {
1113     // Must be sent from the owner proxy or owner.
1114     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1115     assert(proxyRegistry.proxies(owner) == msg.sender || owner == msg.sender || msg.sender == lootBoxNftAddress);
1116     require(canMint(_optionId));
1117 
1118     Item itemContract = Item(nftAddress);
1119     itemContract.mintTo(_toAddress, _optionId);
1120   }
1121 
1122   function canMint(uint256 _optionId) public view returns (bool) {
1123     return (_optionId < numOptions());
1124   }
1125   
1126   function tokenURI(uint256 _optionId) public view returns (string) {
1127     return Strings.strConcat(
1128         baseURI,
1129         Strings.uint2str(_optionId)
1130     );
1131   }
1132 
1133   /**
1134    * Hack to get things to work automatically on OpenSea.
1135    * Use transferFrom so the frontend doesn't have to worry about different method names.
1136    */
1137   function transferFrom(address _from, address _to, uint256 _tokenId) public {
1138     mint(_tokenId, _to);
1139   }
1140 
1141   /**
1142    * Hack to get things to work automatically on OpenSea.
1143    * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
1144    */
1145   function isApprovedForAll(
1146     address _owner,
1147     address _operator
1148   )
1149     public
1150     view
1151     returns (bool)
1152   {
1153     if (owner == _owner && _owner == _operator) {
1154       return true;
1155     }
1156 
1157     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1158     if (owner == _owner && proxyRegistry.proxies(_owner) == _operator) {
1159       return true;
1160     }
1161 
1162     return false;
1163   }
1164 
1165   /**
1166    * Hack to get things to work automatically on OpenSea.
1167    * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
1168    */
1169   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
1170     return owner;
1171   }
1172 }