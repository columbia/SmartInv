1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface ERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param _interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 _interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 
22 /**
23  * @title ERC721 Non-Fungible Token Standard basic interface
24  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
25  */
26 contract ERC721Basic is ERC165 {
27 
28   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
29   /*
30    * 0x80ac58cd ===
31    *   bytes4(keccak256('balanceOf(address)')) ^
32    *   bytes4(keccak256('ownerOf(uint256)')) ^
33    *   bytes4(keccak256('approve(address,uint256)')) ^
34    *   bytes4(keccak256('getApproved(uint256)')) ^
35    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
36    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
37    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
38    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
39    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
40    */
41 
42   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
43   /*
44    * 0x4f558e79 ===
45    *   bytes4(keccak256('exists(uint256)'))
46    */
47 
48   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
49   /**
50    * 0x780e9d63 ===
51    *   bytes4(keccak256('totalSupply()')) ^
52    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
53    *   bytes4(keccak256('tokenByIndex(uint256)'))
54    */
55 
56   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
57   /**
58    * 0x5b5e139f ===
59    *   bytes4(keccak256('name()')) ^
60    *   bytes4(keccak256('symbol()')) ^
61    *   bytes4(keccak256('tokenURI(uint256)'))
62    */
63 
64   event Transfer(
65     address indexed _from,
66     address indexed _to,
67     uint256 indexed _tokenId
68   );
69   event Approval(
70     address indexed _owner,
71     address indexed _approved,
72     uint256 indexed _tokenId
73   );
74   event ApprovalForAll(
75     address indexed _owner,
76     address indexed _operator,
77     bool _approved
78   );
79 
80   function balanceOf(address _owner) public view returns (uint256 _balance);
81   function ownerOf(uint256 _tokenId) public view returns (address _owner);
82   function exists(uint256 _tokenId) public view returns (bool _exists);
83 
84   function approve(address _to, uint256 _tokenId) public;
85   function getApproved(uint256 _tokenId)
86     public view returns (address _operator);
87 
88   function setApprovalForAll(address _operator, bool _approved) public;
89   function isApprovedForAll(address _owner, address _operator)
90     public view returns (bool);
91 
92   function transferFrom(address _from, address _to, uint256 _tokenId) public;
93   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
94     public;
95 
96   function safeTransferFrom(
97     address _from,
98     address _to,
99     uint256 _tokenId,
100     bytes _data
101   )
102     public;
103 }
104 
105 
106 contract IAssetManager {
107     function createAssetPack(bytes32 _packCover, string _name, uint[] _attributes, bytes32[] _ipfsHashes, uint _packPrice) public;
108     function createAsset(uint _attributes, bytes32 _ipfsHash, uint _packId) public;
109     function buyAssetPack(address _to, uint _assetPackId) public payable;
110     function getNumberOfAssets() public view returns (uint);
111     function getNumberOfAssetPacks() public view returns(uint);
112     function checkHasPermissionForPack(address _address, uint _packId) public view returns (bool);
113     function checkHashExists(bytes32 _ipfsHash) public view returns (bool);
114     function givePermission(address _address, uint _packId) public;
115     function pickUniquePacks(uint [] assetIds) public view returns (uint[]);
116     function getAssetInfo(uint id) public view returns (uint, uint, bytes32);
117     function getAssetPacksUserCreated(address _address) public view returns(uint[]);
118     function getAssetIpfs(uint _id) public view returns (bytes32);
119     function getAssetAttributes(uint _id) public view returns (uint);
120     function getIpfsForAssets(uint [] _ids) public view returns (bytes32[]);
121     function getAttributesForAssets(uint [] _ids) public view returns(uint[]);
122     function withdraw() public;
123     function getAssetPackData(uint _assetPackId) public view returns(string, uint[], uint[], bytes32[]);
124     function getAssetPackName(uint _assetPackId) public view returns (string);
125     function getAssetPackPrice(uint _assetPackId) public view returns (uint);
126     function getCoversForPacks(uint [] _packIds) public view returns (bytes32[]);
127 }
128 
129 
130 
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138 
139 
140   event OwnershipRenounced(address indexed previousOwner);
141   event OwnershipTransferred(
142     address indexed previousOwner,
143     address indexed newOwner
144   );
145 
146 
147   /**
148    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
149    * account.
150    */
151   constructor() public {
152     owner = msg.sender;
153   }
154 
155   /**
156    * @dev Throws if called by any account other than the owner.
157    */
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162 
163   /**
164    * @dev Allows the current owner to relinquish control of the contract.
165    * @notice Renouncing to ownership will leave the contract without an owner.
166    * It will not be possible to call the functions with the `onlyOwner`
167    * modifier anymore.
168    */
169   function renounceOwnership() public onlyOwner {
170     emit OwnershipRenounced(owner);
171     owner = address(0);
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param _newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address _newOwner) public onlyOwner {
179     _transferOwnership(_newOwner);
180   }
181 
182   /**
183    * @dev Transfers control of the contract to a newOwner.
184    * @param _newOwner The address to transfer ownership to.
185    */
186   function _transferOwnership(address _newOwner) internal {
187     require(_newOwner != address(0));
188     emit OwnershipTransferred(owner, _newOwner);
189     owner = _newOwner;
190   }
191 }
192 
193 
194 
195 
196 
197 
198 
199 
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
203  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
204  */
205 contract ERC721Enumerable is ERC721Basic {
206   function totalSupply() public view returns (uint256);
207   function tokenOfOwnerByIndex(
208     address _owner,
209     uint256 _index
210   )
211     public
212     view
213     returns (uint256 _tokenId);
214 
215   function tokenByIndex(uint256 _index) public view returns (uint256);
216 }
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
222  */
223 contract ERC721Metadata is ERC721Basic {
224   function name() external view returns (string _name);
225   function symbol() external view returns (string _symbol);
226   function tokenURI(uint256 _tokenId) public view returns (string);
227 }
228 
229 
230 /**
231  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
232  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
233  */
234 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
235 }
236 
237 
238 
239 
240 
241 
242 
243 /**
244  * @title ERC721 token receiver interface
245  * @dev Interface for any contract that wants to support safeTransfers
246  * from ERC721 asset contracts.
247  */
248 contract ERC721Receiver {
249   /**
250    * @dev Magic value to be returned upon successful reception of an NFT
251    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
252    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
253    */
254   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
255 
256   /**
257    * @notice Handle the receipt of an NFT
258    * @dev The ERC721 smart contract calls this function on the recipient
259    * after a `safetransfer`. This function MAY throw to revert and reject the
260    * transfer. Return of other than the magic value MUST result in the
261    * transaction being reverted.
262    * Note: the contract address is always the message sender.
263    * @param _operator The address which called `safeTransferFrom` function
264    * @param _from The address which previously owned the token
265    * @param _tokenId The NFT identifier which is being transferred
266    * @param _data Additional data with no specified format
267    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
268    */
269   function onERC721Received(
270     address _operator,
271     address _from,
272     uint256 _tokenId,
273     bytes _data
274   )
275     public
276     returns(bytes4);
277 }
278 
279 
280 
281 
282 /**
283  * @title SafeMath
284  * @dev Math operations with safety checks that throw on error
285  */
286 library SafeMath {
287 
288   /**
289   * @dev Multiplies two numbers, throws on overflow.
290   */
291   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
292     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
293     // benefit is lost if 'b' is also tested.
294     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
295     if (_a == 0) {
296       return 0;
297     }
298 
299     c = _a * _b;
300     assert(c / _a == _b);
301     return c;
302   }
303 
304   /**
305   * @dev Integer division of two numbers, truncating the quotient.
306   */
307   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
308     // assert(_b > 0); // Solidity automatically throws when dividing by 0
309     // uint256 c = _a / _b;
310     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
311     return _a / _b;
312   }
313 
314   /**
315   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
316   */
317   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
318     assert(_b <= _a);
319     return _a - _b;
320   }
321 
322   /**
323   * @dev Adds two numbers, throws on overflow.
324   */
325   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
326     c = _a + _b;
327     assert(c >= _a);
328     return c;
329   }
330 }
331 
332 
333 
334 
335 /**
336  * Utility library of inline functions on addresses
337  */
338 library AddressUtils {
339 
340   /**
341    * Returns whether the target address is a contract
342    * @dev This function will return false if invoked during the constructor of a contract,
343    * as the code is not actually created until after the constructor finishes.
344    * @param _addr address to check
345    * @return whether the target address is a contract
346    */
347   function isContract(address _addr) internal view returns (bool) {
348     uint256 size;
349     // XXX Currently there is no better way to check if there is a contract in an address
350     // than to check the size of the code at that address.
351     // See https://ethereum.stackexchange.com/a/14016/36603
352     // for more details about how this works.
353     // TODO Check this again before the Serenity release, because all addresses will be
354     // contracts then.
355     // solium-disable-next-line security/no-inline-assembly
356     assembly { size := extcodesize(_addr) }
357     return size > 0;
358   }
359 
360 }
361 
362 
363 
364 
365 
366 
367 
368 
369 
370 
371 /**
372  * @title SupportsInterfaceWithLookup
373  * @author Matt Condon (@shrugs)
374  * @dev Implements ERC165 using a lookup table.
375  */
376 contract SupportsInterfaceWithLookup is ERC165 {
377 
378   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
379   /**
380    * 0x01ffc9a7 ===
381    *   bytes4(keccak256('supportsInterface(bytes4)'))
382    */
383 
384   /**
385    * @dev a mapping of interface id to whether or not it's supported
386    */
387   mapping(bytes4 => bool) internal supportedInterfaces;
388 
389   /**
390    * @dev A contract implementing SupportsInterfaceWithLookup
391    * implement ERC165 itself
392    */
393   constructor()
394     public
395   {
396     _registerInterface(InterfaceId_ERC165);
397   }
398 
399   /**
400    * @dev implement supportsInterface(bytes4) using a lookup table
401    */
402   function supportsInterface(bytes4 _interfaceId)
403     external
404     view
405     returns (bool)
406   {
407     return supportedInterfaces[_interfaceId];
408   }
409 
410   /**
411    * @dev private method for registering an interface
412    */
413   function _registerInterface(bytes4 _interfaceId)
414     internal
415   {
416     require(_interfaceId != 0xffffffff);
417     supportedInterfaces[_interfaceId] = true;
418   }
419 }
420 
421 
422 
423 /**
424  * @title ERC721 Non-Fungible Token Standard basic implementation
425  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
426  */
427 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
428 
429   using SafeMath for uint256;
430   using AddressUtils for address;
431 
432   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
433   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
434   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
435 
436   // Mapping from token ID to owner
437   mapping (uint256 => address) internal tokenOwner;
438 
439   // Mapping from token ID to approved address
440   mapping (uint256 => address) internal tokenApprovals;
441 
442   // Mapping from owner to number of owned token
443   mapping (address => uint256) internal ownedTokensCount;
444 
445   // Mapping from owner to operator approvals
446   mapping (address => mapping (address => bool)) internal operatorApprovals;
447 
448   constructor()
449     public
450   {
451     // register the supported interfaces to conform to ERC721 via ERC165
452     _registerInterface(InterfaceId_ERC721);
453     _registerInterface(InterfaceId_ERC721Exists);
454   }
455 
456   /**
457    * @dev Gets the balance of the specified address
458    * @param _owner address to query the balance of
459    * @return uint256 representing the amount owned by the passed address
460    */
461   function balanceOf(address _owner) public view returns (uint256) {
462     require(_owner != address(0));
463     return ownedTokensCount[_owner];
464   }
465 
466   /**
467    * @dev Gets the owner of the specified token ID
468    * @param _tokenId uint256 ID of the token to query the owner of
469    * @return owner address currently marked as the owner of the given token ID
470    */
471   function ownerOf(uint256 _tokenId) public view returns (address) {
472     address owner = tokenOwner[_tokenId];
473     require(owner != address(0));
474     return owner;
475   }
476 
477   /**
478    * @dev Returns whether the specified token exists
479    * @param _tokenId uint256 ID of the token to query the existence of
480    * @return whether the token exists
481    */
482   function exists(uint256 _tokenId) public view returns (bool) {
483     address owner = tokenOwner[_tokenId];
484     return owner != address(0);
485   }
486 
487   /**
488    * @dev Approves another address to transfer the given token ID
489    * The zero address indicates there is no approved address.
490    * There can only be one approved address per token at a given time.
491    * Can only be called by the token owner or an approved operator.
492    * @param _to address to be approved for the given token ID
493    * @param _tokenId uint256 ID of the token to be approved
494    */
495   function approve(address _to, uint256 _tokenId) public {
496     address owner = ownerOf(_tokenId);
497     require(_to != owner);
498     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
499 
500     tokenApprovals[_tokenId] = _to;
501     emit Approval(owner, _to, _tokenId);
502   }
503 
504   /**
505    * @dev Gets the approved address for a token ID, or zero if no address set
506    * @param _tokenId uint256 ID of the token to query the approval of
507    * @return address currently approved for the given token ID
508    */
509   function getApproved(uint256 _tokenId) public view returns (address) {
510     return tokenApprovals[_tokenId];
511   }
512 
513   /**
514    * @dev Sets or unsets the approval of a given operator
515    * An operator is allowed to transfer all tokens of the sender on their behalf
516    * @param _to operator address to set the approval
517    * @param _approved representing the status of the approval to be set
518    */
519   function setApprovalForAll(address _to, bool _approved) public {
520     require(_to != msg.sender);
521     operatorApprovals[msg.sender][_to] = _approved;
522     emit ApprovalForAll(msg.sender, _to, _approved);
523   }
524 
525   /**
526    * @dev Tells whether an operator is approved by a given owner
527    * @param _owner owner address which you want to query the approval of
528    * @param _operator operator address which you want to query the approval of
529    * @return bool whether the given operator is approved by the given owner
530    */
531   function isApprovedForAll(
532     address _owner,
533     address _operator
534   )
535     public
536     view
537     returns (bool)
538   {
539     return operatorApprovals[_owner][_operator];
540   }
541 
542   /**
543    * @dev Transfers the ownership of a given token ID to another address
544    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
545    * Requires the msg sender to be the owner, approved, or operator
546    * @param _from current owner of the token
547    * @param _to address to receive the ownership of the given token ID
548    * @param _tokenId uint256 ID of the token to be transferred
549   */
550   function transferFrom(
551     address _from,
552     address _to,
553     uint256 _tokenId
554   )
555     public
556   {
557     require(isApprovedOrOwner(msg.sender, _tokenId));
558     require(_from != address(0));
559     require(_to != address(0));
560 
561     clearApproval(_from, _tokenId);
562     removeTokenFrom(_from, _tokenId);
563     addTokenTo(_to, _tokenId);
564 
565     emit Transfer(_from, _to, _tokenId);
566   }
567 
568   /**
569    * @dev Safely transfers the ownership of a given token ID to another address
570    * If the target address is a contract, it must implement `onERC721Received`,
571    * which is called upon a safe transfer, and return the magic value
572    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
573    * the transfer is reverted.
574    *
575    * Requires the msg sender to be the owner, approved, or operator
576    * @param _from current owner of the token
577    * @param _to address to receive the ownership of the given token ID
578    * @param _tokenId uint256 ID of the token to be transferred
579   */
580   function safeTransferFrom(
581     address _from,
582     address _to,
583     uint256 _tokenId
584   )
585     public
586   {
587     // solium-disable-next-line arg-overflow
588     safeTransferFrom(_from, _to, _tokenId, "");
589   }
590 
591   /**
592    * @dev Safely transfers the ownership of a given token ID to another address
593    * If the target address is a contract, it must implement `onERC721Received`,
594    * which is called upon a safe transfer, and return the magic value
595    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
596    * the transfer is reverted.
597    * Requires the msg sender to be the owner, approved, or operator
598    * @param _from current owner of the token
599    * @param _to address to receive the ownership of the given token ID
600    * @param _tokenId uint256 ID of the token to be transferred
601    * @param _data bytes data to send along with a safe transfer check
602    */
603   function safeTransferFrom(
604     address _from,
605     address _to,
606     uint256 _tokenId,
607     bytes _data
608   )
609     public
610   {
611     transferFrom(_from, _to, _tokenId);
612     // solium-disable-next-line arg-overflow
613     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
614   }
615 
616   /**
617    * @dev Returns whether the given spender can transfer a given token ID
618    * @param _spender address of the spender to query
619    * @param _tokenId uint256 ID of the token to be transferred
620    * @return bool whether the msg.sender is approved for the given token ID,
621    *  is an operator of the owner, or is the owner of the token
622    */
623   function isApprovedOrOwner(
624     address _spender,
625     uint256 _tokenId
626   )
627     internal
628     view
629     returns (bool)
630   {
631     address owner = ownerOf(_tokenId);
632     // Disable solium check because of
633     // https://github.com/duaraghav8/Solium/issues/175
634     // solium-disable-next-line operator-whitespace
635     return (
636       _spender == owner ||
637       getApproved(_tokenId) == _spender ||
638       isApprovedForAll(owner, _spender)
639     );
640   }
641 
642   /**
643    * @dev Internal function to mint a new token
644    * Reverts if the given token ID already exists
645    * @param _to The address that will own the minted token
646    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
647    */
648   function _mint(address _to, uint256 _tokenId) internal {
649     require(_to != address(0));
650     addTokenTo(_to, _tokenId);
651     emit Transfer(address(0), _to, _tokenId);
652   }
653 
654   /**
655    * @dev Internal function to burn a specific token
656    * Reverts if the token does not exist
657    * @param _tokenId uint256 ID of the token being burned by the msg.sender
658    */
659   function _burn(address _owner, uint256 _tokenId) internal {
660     clearApproval(_owner, _tokenId);
661     removeTokenFrom(_owner, _tokenId);
662     emit Transfer(_owner, address(0), _tokenId);
663   }
664 
665   /**
666    * @dev Internal function to clear current approval of a given token ID
667    * Reverts if the given address is not indeed the owner of the token
668    * @param _owner owner of the token
669    * @param _tokenId uint256 ID of the token to be transferred
670    */
671   function clearApproval(address _owner, uint256 _tokenId) internal {
672     require(ownerOf(_tokenId) == _owner);
673     if (tokenApprovals[_tokenId] != address(0)) {
674       tokenApprovals[_tokenId] = address(0);
675     }
676   }
677 
678   /**
679    * @dev Internal function to add a token ID to the list of a given address
680    * @param _to address representing the new owner of the given token ID
681    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
682    */
683   function addTokenTo(address _to, uint256 _tokenId) internal {
684     require(tokenOwner[_tokenId] == address(0));
685     tokenOwner[_tokenId] = _to;
686     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
687   }
688 
689   /**
690    * @dev Internal function to remove a token ID from the list of a given address
691    * @param _from address representing the previous owner of the given token ID
692    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
693    */
694   function removeTokenFrom(address _from, uint256 _tokenId) internal {
695     require(ownerOf(_tokenId) == _from);
696     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
697     tokenOwner[_tokenId] = address(0);
698   }
699 
700   /**
701    * @dev Internal function to invoke `onERC721Received` on a target address
702    * The call is not executed if the target address is not a contract
703    * @param _from address representing the previous owner of the given token ID
704    * @param _to target address that will receive the tokens
705    * @param _tokenId uint256 ID of the token to be transferred
706    * @param _data bytes optional data to send along with the call
707    * @return whether the call correctly returned the expected magic value
708    */
709   function checkAndCallSafeTransfer(
710     address _from,
711     address _to,
712     uint256 _tokenId,
713     bytes _data
714   )
715     internal
716     returns (bool)
717   {
718     if (!_to.isContract()) {
719       return true;
720     }
721     bytes4 retval = ERC721Receiver(_to).onERC721Received(
722       msg.sender, _from, _tokenId, _data);
723     return (retval == ERC721_RECEIVED);
724   }
725 }
726 
727 
728 
729 
730 /**
731  * @title Full ERC721 Token
732  * This implementation includes all the required and some optional functionality of the ERC721 standard
733  * Moreover, it includes approve all functionality using operator terminology
734  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
735  */
736 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
737 
738   // Token name
739   string internal name_;
740 
741   // Token symbol
742   string internal symbol_;
743 
744   // Mapping from owner to list of owned token IDs
745   mapping(address => uint256[]) internal ownedTokens;
746 
747   // Mapping from token ID to index of the owner tokens list
748   mapping(uint256 => uint256) internal ownedTokensIndex;
749 
750   // Array with all token ids, used for enumeration
751   uint256[] internal allTokens;
752 
753   // Mapping from token id to position in the allTokens array
754   mapping(uint256 => uint256) internal allTokensIndex;
755 
756   // Optional mapping for token URIs
757   mapping(uint256 => string) internal tokenURIs;
758 
759   /**
760    * @dev Constructor function
761    */
762   constructor(string _name, string _symbol) public {
763     name_ = _name;
764     symbol_ = _symbol;
765 
766     // register the supported interfaces to conform to ERC721 via ERC165
767     _registerInterface(InterfaceId_ERC721Enumerable);
768     _registerInterface(InterfaceId_ERC721Metadata);
769   }
770 
771   /**
772    * @dev Gets the token name
773    * @return string representing the token name
774    */
775   function name() external view returns (string) {
776     return name_;
777   }
778 
779   /**
780    * @dev Gets the token symbol
781    * @return string representing the token symbol
782    */
783   function symbol() external view returns (string) {
784     return symbol_;
785   }
786 
787   /**
788    * @dev Returns an URI for a given token ID
789    * Throws if the token ID does not exist. May return an empty string.
790    * @param _tokenId uint256 ID of the token to query
791    */
792   function tokenURI(uint256 _tokenId) public view returns (string) {
793     require(exists(_tokenId));
794     return tokenURIs[_tokenId];
795   }
796 
797   /**
798    * @dev Gets the token ID at a given index of the tokens list of the requested owner
799    * @param _owner address owning the tokens list to be accessed
800    * @param _index uint256 representing the index to be accessed of the requested tokens list
801    * @return uint256 token ID at the given index of the tokens list owned by the requested address
802    */
803   function tokenOfOwnerByIndex(
804     address _owner,
805     uint256 _index
806   )
807     public
808     view
809     returns (uint256)
810   {
811     require(_index < balanceOf(_owner));
812     return ownedTokens[_owner][_index];
813   }
814 
815   /**
816    * @dev Gets the total amount of tokens stored by the contract
817    * @return uint256 representing the total amount of tokens
818    */
819   function totalSupply() public view returns (uint256) {
820     return allTokens.length;
821   }
822 
823   /**
824    * @dev Gets the token ID at a given index of all the tokens in this contract
825    * Reverts if the index is greater or equal to the total number of tokens
826    * @param _index uint256 representing the index to be accessed of the tokens list
827    * @return uint256 token ID at the given index of the tokens list
828    */
829   function tokenByIndex(uint256 _index) public view returns (uint256) {
830     require(_index < totalSupply());
831     return allTokens[_index];
832   }
833 
834   /**
835    * @dev Internal function to set the token URI for a given token
836    * Reverts if the token ID does not exist
837    * @param _tokenId uint256 ID of the token to set its URI
838    * @param _uri string URI to assign
839    */
840   function _setTokenURI(uint256 _tokenId, string _uri) internal {
841     require(exists(_tokenId));
842     tokenURIs[_tokenId] = _uri;
843   }
844 
845   /**
846    * @dev Internal function to add a token ID to the list of a given address
847    * @param _to address representing the new owner of the given token ID
848    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
849    */
850   function addTokenTo(address _to, uint256 _tokenId) internal {
851     super.addTokenTo(_to, _tokenId);
852     uint256 length = ownedTokens[_to].length;
853     ownedTokens[_to].push(_tokenId);
854     ownedTokensIndex[_tokenId] = length;
855   }
856 
857   /**
858    * @dev Internal function to remove a token ID from the list of a given address
859    * @param _from address representing the previous owner of the given token ID
860    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
861    */
862   function removeTokenFrom(address _from, uint256 _tokenId) internal {
863     super.removeTokenFrom(_from, _tokenId);
864 
865     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
866     // then delete the last slot.
867     uint256 tokenIndex = ownedTokensIndex[_tokenId];
868     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
869     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
870 
871     ownedTokens[_from][tokenIndex] = lastToken;
872     // This also deletes the contents at the last position of the array
873     ownedTokens[_from].length--;
874 
875     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
876     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
877     // the lastToken to the first position, and then dropping the element placed in the last position of the list
878 
879     ownedTokensIndex[_tokenId] = 0;
880     ownedTokensIndex[lastToken] = tokenIndex;
881   }
882 
883   /**
884    * @dev Internal function to mint a new token
885    * Reverts if the given token ID already exists
886    * @param _to address the beneficiary that will own the minted token
887    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
888    */
889   function _mint(address _to, uint256 _tokenId) internal {
890     super._mint(_to, _tokenId);
891 
892     allTokensIndex[_tokenId] = allTokens.length;
893     allTokens.push(_tokenId);
894   }
895 
896   /**
897    * @dev Internal function to burn a specific token
898    * Reverts if the token does not exist
899    * @param _owner owner of the token to burn
900    * @param _tokenId uint256 ID of the token being burned by the msg.sender
901    */
902   function _burn(address _owner, uint256 _tokenId) internal {
903     super._burn(_owner, _tokenId);
904 
905     // Clear metadata (if any)
906     if (bytes(tokenURIs[_tokenId]).length != 0) {
907       delete tokenURIs[_tokenId];
908     }
909 
910     // Reorg all tokens array
911     uint256 tokenIndex = allTokensIndex[_tokenId];
912     uint256 lastTokenIndex = allTokens.length.sub(1);
913     uint256 lastToken = allTokens[lastTokenIndex];
914 
915     allTokens[tokenIndex] = lastToken;
916     allTokens[lastTokenIndex] = 0;
917 
918     allTokens.length--;
919     allTokensIndex[_tokenId] = 0;
920     allTokensIndex[lastToken] = tokenIndex;
921   }
922 
923 }
924 
925 
926 
927 
928 
929 contract Functions {
930 
931     bytes32[] public randomHashes;
932 
933     function fillWithHashes() public {
934         require(randomHashes.length == 0);
935 
936         for (uint i = block.number - 100; i < block.number; i++) {
937             randomHashes.push(blockhash(i));
938         }
939     }
940 
941     /// @notice Function to calculate initial random seed based on our hashes
942     /// @param _randomHashIds are ids in our array of hashes
943     /// @param _timestamp is timestamp for that hash
944     /// @return uint representation of random seed
945     function calculateSeed(uint[] _randomHashIds, uint _timestamp) public view returns (uint) {
946         require(_timestamp != 0);
947         require(_randomHashIds.length == 10);
948 
949         bytes32 randomSeed = keccak256(
950             abi.encodePacked(
951             randomHashes[_randomHashIds[0]], randomHashes[_randomHashIds[1]],
952             randomHashes[_randomHashIds[2]], randomHashes[_randomHashIds[3]],
953             randomHashes[_randomHashIds[4]], randomHashes[_randomHashIds[5]],
954             randomHashes[_randomHashIds[6]], randomHashes[_randomHashIds[7]],
955             randomHashes[_randomHashIds[8]], randomHashes[_randomHashIds[9]],
956             _timestamp
957             )
958         );
959 
960         return uint(randomSeed);
961     }
962 
963     function getRandomHashesLength() public view returns(uint) {
964         return randomHashes.length;
965     }
966 
967     /// @notice Function which decodes bytes32 to array of integers
968     /// @param _potentialAssets are potential assets user would like to have
969     /// @return array of assetIds
970     function decodeAssets(bytes32[] _potentialAssets) public pure returns (uint[] assets) {
971         require(_potentialAssets.length > 0);
972 
973         uint[] memory assetsCopy = new uint[](_potentialAssets.length*10);
974         uint numberOfAssets = 0;
975 
976         for (uint j = 0; j < _potentialAssets.length; j++) {
977             uint input;
978             bytes32 pot = _potentialAssets[j];
979 
980             assembly {
981                 input := pot
982             }
983 
984             for (uint i = 10; i > 0; i--) {
985                 uint mask = (2 << ((i-1) * 24)) / 2;
986                 uint b = (input & (mask * 16777215)) / mask;
987 
988                 if (b != 0) {
989                     assetsCopy[numberOfAssets] = b;
990                     numberOfAssets++;
991                 }
992             }
993         }
994 
995         assets = new uint[](numberOfAssets);
996         for (i = 0; i < numberOfAssets; i++) {
997             assets[i] = assetsCopy[i];
998         }
999     }
1000 
1001     /// @notice Function to pick random assets from potentialAssets array
1002     /// @param _finalSeed is final random seed
1003     /// @param _potentialAssets is bytes32[] array of potential assets
1004     /// @return uint[] array of randomly picked assets
1005     function pickRandomAssets(uint _finalSeed, bytes32[] _potentialAssets) public pure returns(uint[] finalPicked) {
1006         require(_finalSeed != 0);
1007         require(_potentialAssets.length > 0);
1008 
1009         uint[] memory assetIds = decodeAssets(_potentialAssets);
1010         uint[] memory pickedIds = new uint[](assetIds.length);
1011 
1012         uint finalSeedCopy = _finalSeed;
1013         uint index = 0;
1014 
1015         for (uint i = 0; i < assetIds.length; i++) {
1016             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
1017             if (finalSeedCopy % 2 == 0) {
1018                 pickedIds[index] = assetIds[i];
1019                 index++;
1020             }
1021         }
1022 
1023         finalPicked = new uint[](index);
1024         for (i = 0; i < index; i++) {
1025             finalPicked[i] = pickedIds[i];
1026         }
1027     }
1028 
1029     /// @notice Function to pick random assets from potentialAssets array
1030     /// @param _finalSeed is final random seed
1031     /// @param _potentialAssets is bytes32[] array of potential assets
1032     /// @param _width of canvas
1033     /// @param _height of canvas
1034     /// @return arrays of randomly picked assets defining ids, coordinates, zoom, rotation and layers
1035     function getImage(uint _finalSeed, bytes32[] _potentialAssets, uint _width, uint _height) public pure 
1036     returns(uint[] finalPicked, uint[] x, uint[] y, uint[] zoom, uint[] rotation, uint[] layers) {
1037         require(_finalSeed != 0);
1038         require(_potentialAssets.length > 0);
1039 
1040         uint[] memory assetIds = decodeAssets(_potentialAssets);
1041         uint[] memory pickedIds = new uint[](assetIds.length);
1042         x = new uint[](assetIds.length);
1043         y = new uint[](assetIds.length);
1044         zoom = new uint[](assetIds.length);
1045         rotation = new uint[](assetIds.length);
1046         layers = new uint[](assetIds.length);
1047 
1048         uint finalSeedCopy = _finalSeed;
1049         uint index = 0;
1050 
1051         for (uint i = 0; i < assetIds.length; i++) {
1052             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
1053             if (finalSeedCopy % 2 == 0) {
1054                 pickedIds[index] = assetIds[i];
1055                 (x[index], y[index], zoom[index], rotation[index], layers[index]) = pickRandomAssetPosition(finalSeedCopy, _width, _height);
1056                 index++;
1057             }
1058         }
1059 
1060         finalPicked = new uint[](index);
1061         for (i = 0; i < index; i++) {
1062             finalPicked[i] = pickedIds[i];
1063         }
1064     }
1065 
1066     /// @notice Function to pick random position for an asset
1067     /// @param _randomSeed is random seed for that image
1068     /// @param _width of canvas
1069     /// @param _height of canvas
1070     /// @return tuple of uints representing x,y,zoom,and rotation
1071     function pickRandomAssetPosition(uint _randomSeed, uint _width, uint _height) public pure 
1072     returns (uint x, uint y, uint zoom, uint rotation, uint layer) {
1073         
1074         x = _randomSeed % _width;
1075         y = _randomSeed % _height;
1076         zoom = _randomSeed % 200 + 800;
1077         rotation = _randomSeed % 360;
1078         // using random number for now
1079         // if two layers are same, sort by (keccak256(layer, assetId))
1080         layer = _randomSeed % 1234567; 
1081     }
1082 
1083     /// @notice Function to calculate final random seed for user
1084     /// @param _randomSeed is initially given random seed
1085     /// @param _iterations is number of iterations
1086     /// @return final seed for user as uint
1087     function getFinalSeed(uint _randomSeed, uint _iterations) public pure returns (bytes32) {
1088         require(_randomSeed != 0);
1089         require(_iterations != 0);
1090         bytes32 finalSeed = bytes32(_randomSeed);
1091 
1092         finalSeed = keccak256(abi.encodePacked(_randomSeed, _iterations));
1093         for (uint i = 0; i < _iterations; i++) {
1094             finalSeed = keccak256(abi.encodePacked(finalSeed, i));
1095         }
1096 
1097         return finalSeed;
1098     }
1099 
1100     function toHex(uint _randomSeed) public pure returns (bytes32) {
1101         return bytes32(_randomSeed);
1102     }
1103 }
1104 
1105 
1106 
1107 
1108 
1109 contract UserManager {
1110 
1111     struct User {
1112         string username;
1113         bytes32 hashToProfilePicture;
1114         bool exists;
1115     }
1116 
1117     uint public numberOfUsers;
1118 
1119     mapping(string => bool) internal usernameExists;
1120     mapping(address => User) public addressToUser;
1121 
1122     mapping(bytes32 => bool) public profilePictureExists;
1123     mapping(string => address) internal usernameToAddress;
1124 
1125     event NewUser(address indexed user, string username, bytes32 profilePicture);
1126 
1127     function register(string _username, bytes32 _hashToProfilePicture) public {
1128         require(usernameExists[_username] == false || 
1129                 keccak256(abi.encodePacked(getUsername(msg.sender))) == keccak256(abi.encodePacked(_username))
1130         );
1131 
1132         if (usernameExists[getUsername(msg.sender)]) {
1133             // if he already had username, that username is free now
1134             usernameExists[getUsername(msg.sender)] = false;
1135         } else {
1136             numberOfUsers++;
1137             emit NewUser(msg.sender, _username, _hashToProfilePicture);
1138         }
1139 
1140         addressToUser[msg.sender] = User({
1141             username: _username,
1142             hashToProfilePicture: _hashToProfilePicture,
1143             exists: true
1144         });
1145 
1146         usernameExists[_username] = true;
1147         profilePictureExists[_hashToProfilePicture] = true;
1148         usernameToAddress[_username] = msg.sender;
1149     }
1150 
1151     function changeProfilePicture(bytes32 _hashToProfilePicture) public {
1152         require(addressToUser[msg.sender].exists, "User doesn't exists");
1153 
1154         addressToUser[msg.sender].hashToProfilePicture = _hashToProfilePicture;
1155     }
1156 
1157     function getUserInfo(address _address) public view returns(string, bytes32) {
1158         User memory user = addressToUser[_address];
1159         return (user.username, user.hashToProfilePicture);
1160     }
1161 
1162     function getUsername(address _address) public view returns(string) {
1163         return addressToUser[_address].username;
1164     } 
1165 
1166     function getProfilePicture(address _address) public view returns(bytes32) {
1167         return addressToUser[_address].hashToProfilePicture;
1168     }
1169 
1170     function isUsernameExists(string _username) public view returns(bool) {
1171         return usernameExists[_username];
1172     }
1173 
1174 }
1175 
1176 
1177 contract DigitalPrintImage is ERC721Token("DigitalPrintImage", "DPM"), UserManager, Ownable {
1178 
1179     struct ImageMetadata {
1180         uint finalSeed;
1181         bytes32[] potentialAssets;
1182         uint timestamp;
1183         address creator;
1184         string ipfsHash;
1185         string extraData;
1186     }
1187 
1188     mapping(uint => bool) public seedExists;
1189     mapping(uint => ImageMetadata) public imageMetadata;
1190     mapping(uint => string) public idToIpfsHash;
1191 
1192     address public marketplaceContract;
1193     IAssetManager public assetManager;
1194     Functions public functions;
1195 
1196     modifier onlyMarketplaceContract() {
1197         require(msg.sender == address(marketplaceContract));
1198         _;
1199     }
1200 
1201     event ImageCreated(uint indexed imageId, address indexed owner);
1202     /// @dev only for testing purposes
1203     // function createImageTest() public {
1204     //     _mint(msg.sender, totalSupply());
1205     // }
1206 
1207     /// @notice Function will create new image
1208     /// @param _randomHashIds is array of random hashes from our array
1209     /// @param _timestamp is timestamp when image is created
1210     /// @param _iterations is number of how many times he generated random asset positions until he liked what he got
1211     /// @param _potentialAssets is set of all potential assets user selected for an image
1212     /// @param _author is nickname of image owner
1213     /// @param _ipfsHash is ipfsHash of the image .png
1214     /// @param _extraData string containing ipfsHash that contains (frame,width,height,title,description)
1215     /// @return returns id of created image
1216     function createImage(
1217         uint[] _randomHashIds,
1218         uint _timestamp,
1219         uint _iterations,
1220         bytes32[] _potentialAssets,
1221         string _author,
1222         string _ipfsHash,
1223         string _extraData) public payable {
1224         require(_potentialAssets.length <= 5);
1225         // if user exists send his username, if it doesn't check for some username that doesn't exists
1226         require(msg.sender == usernameToAddress[_author] || !usernameExists[_author]);
1227 
1228         // if user doesn't exists create that user with no profile picture
1229         if (!usernameExists[_author]) {
1230             register(_author, bytes32(0));
1231         }
1232 
1233         uint[] memory pickedAssets;
1234         uint finalSeed;
1235        
1236         (pickedAssets, finalSeed) = getPickedAssetsAndFinalSeed(_potentialAssets, _randomHashIds, _timestamp, _iterations); 
1237         uint[] memory pickedAssetPacks = assetManager.pickUniquePacks(pickedAssets);
1238         uint finalPrice = 0;
1239 
1240         for (uint i = 0; i < pickedAssetPacks.length; i++) {
1241             if (assetManager.checkHasPermissionForPack(msg.sender, pickedAssetPacks[i]) == false) {
1242                 finalPrice += assetManager.getAssetPackPrice(pickedAssetPacks[i]);
1243 
1244                 assetManager.buyAssetPack.value(assetManager.getAssetPackPrice(pickedAssetPacks[i]))(msg.sender, pickedAssetPacks[i]);
1245             }
1246         }
1247         
1248         require(msg.value >= finalPrice);
1249 
1250         uint id = totalSupply();
1251         _mint(msg.sender, id);
1252 
1253         imageMetadata[id] = ImageMetadata({
1254             finalSeed: finalSeed,
1255             potentialAssets: _potentialAssets,
1256             timestamp: _timestamp,
1257             creator: msg.sender,
1258             ipfsHash: _ipfsHash,
1259             extraData: _extraData
1260         });
1261 
1262         idToIpfsHash[id] = _ipfsHash;
1263         seedExists[finalSeed] = true;
1264 
1265         emit ImageCreated(id, msg.sender);
1266     }
1267 
1268     /// @notice approving image to be taken from specific address
1269     /// @param _from address from which we transfer image
1270     /// @param _to address that we give permission to take image
1271     /// @param _imageId we are willing to give
1272     function transferFromMarketplace(address _from, address _to, uint256 _imageId) public onlyMarketplaceContract {
1273         require(isApprovedOrOwner(_from, _imageId));
1274 
1275         clearApproval(_from, _imageId);
1276         removeTokenFrom(_from, _imageId);
1277         addTokenTo(_to, _imageId);
1278 
1279         emit Transfer(_from, _to, _imageId);
1280     }
1281 
1282     /// @notice adds marketplace address to contract only if it doesn't already exist
1283     /// @param _marketplaceContract address of marketplace contract
1284     function addMarketplaceContract(address _marketplaceContract) public onlyOwner {
1285         require(address(marketplaceContract) == 0x0);
1286         
1287         marketplaceContract = _marketplaceContract;
1288     }
1289 
1290     /// @notice Function to add assetManager
1291     /// @param _assetManager is address of assetManager contract
1292     function addAssetManager(address _assetManager) public onlyOwner {
1293         require(address(assetManager) == 0x0);
1294 
1295         assetManager = IAssetManager(_assetManager);
1296     }
1297 
1298     /// @notice Function to add functions contract
1299     /// @param _functions is address of functions contract
1300     function addFunctions(address _functions) public onlyOwner {
1301         require(address(functions) == 0x0);
1302 
1303         functions = Functions(_functions);
1304     }
1305 
1306     /// @notice Function to calculate final price for an image based on selected assets
1307     /// @param _pickedAssets is array of picked packs
1308     /// @param _owner is address of image owner
1309     /// @return finalPrice for the image
1310     function calculatePrice(uint[] _pickedAssets, address _owner) public view returns (uint) {
1311         if (_pickedAssets.length == 0) {
1312             return 0;
1313         }
1314 
1315         uint[] memory pickedAssetPacks = assetManager.pickUniquePacks(_pickedAssets);
1316         uint finalPrice = 0;
1317         for (uint i = 0; i < pickedAssetPacks.length; i++) {
1318             if (assetManager.checkHasPermissionForPack(_owner, pickedAssetPacks[i]) == false) {
1319                 finalPrice += assetManager.getAssetPackPrice(pickedAssetPacks[i]);
1320             }
1321         }
1322 
1323         return finalPrice;
1324     }
1325 
1326     /// @notice Method returning informations needed for gallery page
1327     /// @param _imageId id of image 
1328     function getGalleryData(uint _imageId) public view 
1329     returns(address, address, string, bytes32, string, string) {
1330         require(_imageId < totalSupply());
1331 
1332         return(
1333             imageMetadata[_imageId].creator,
1334             ownerOf(_imageId),
1335             addressToUser[ownerOf(_imageId)].username,
1336             addressToUser[ownerOf(_imageId)].hashToProfilePicture,
1337             imageMetadata[_imageId].ipfsHash,
1338             imageMetadata[_imageId].extraData
1339         );
1340 
1341     }
1342 
1343     /// @notice returns metadata of image
1344     /// @dev not possible to use public mapping because of array of bytes32
1345     /// @param _imageId id of image
1346     function getImageMetadata(uint _imageId) public view
1347     returns(address, string, uint, string, uint, bytes32[]) {
1348         ImageMetadata memory metadata = imageMetadata[_imageId];
1349 
1350         return(
1351             metadata.creator,
1352             metadata.extraData,
1353             metadata.finalSeed,
1354             metadata.ipfsHash,
1355             metadata.timestamp,
1356             metadata.potentialAssets
1357         );
1358     }
1359 
1360     /// @notice returns all images owned by _user
1361     /// @param _user address of user
1362     function getUserImages(address _user) public view returns(uint[]) {
1363         return ownedTokens[_user];
1364     }
1365 
1366     /// @notice returns picked assets from potential assets and final seed
1367     /// @param _potentialAssets array of all potential assets encoded in bytes32
1368     /// @param _randomHashIds selected random hash ids from our contract
1369     /// @param _timestamp timestamp of image creation
1370     /// @param _iterations number of iterations to get to final seed
1371     function getPickedAssetsAndFinalSeed(bytes32[] _potentialAssets, uint[] _randomHashIds, uint _timestamp, uint _iterations) internal view returns(uint[], uint) {
1372         uint finalSeed = uint(functions.getFinalSeed(functions.calculateSeed(_randomHashIds, _timestamp), _iterations));
1373 
1374         require(!seedExists[finalSeed]);
1375 
1376         return (functions.pickRandomAssets(finalSeed, _potentialAssets), finalSeed);
1377     }
1378 
1379 }