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
201 
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
206  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
207  */
208 contract ERC721Enumerable is ERC721Basic {
209   function totalSupply() public view returns (uint256);
210   function tokenOfOwnerByIndex(
211     address _owner,
212     uint256 _index
213   )
214     public
215     view
216     returns (uint256 _tokenId);
217 
218   function tokenByIndex(uint256 _index) public view returns (uint256);
219 }
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
224  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
225  */
226 contract ERC721Metadata is ERC721Basic {
227   function name() external view returns (string _name);
228   function symbol() external view returns (string _symbol);
229   function tokenURI(uint256 _tokenId) public view returns (string);
230 }
231 
232 
233 /**
234  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
235  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
236  */
237 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
238 }
239 
240 
241 
242 
243 
244 
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 contract ERC721Receiver {
252   /**
253    * @dev Magic value to be returned upon successful reception of an NFT
254    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
255    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
256    */
257   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
258 
259   /**
260    * @notice Handle the receipt of an NFT
261    * @dev The ERC721 smart contract calls this function on the recipient
262    * after a `safetransfer`. This function MAY throw to revert and reject the
263    * transfer. Return of other than the magic value MUST result in the
264    * transaction being reverted.
265    * Note: the contract address is always the message sender.
266    * @param _operator The address which called `safeTransferFrom` function
267    * @param _from The address which previously owned the token
268    * @param _tokenId The NFT identifier which is being transferred
269    * @param _data Additional data with no specified format
270    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
271    */
272   function onERC721Received(
273     address _operator,
274     address _from,
275     uint256 _tokenId,
276     bytes _data
277   )
278     public
279     returns(bytes4);
280 }
281 
282 
283 
284 
285 /**
286  * @title SafeMath
287  * @dev Math operations with safety checks that throw on error
288  */
289 library SafeMath {
290 
291   /**
292   * @dev Multiplies two numbers, throws on overflow.
293   */
294   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
295     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
296     // benefit is lost if 'b' is also tested.
297     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
298     if (_a == 0) {
299       return 0;
300     }
301 
302     c = _a * _b;
303     assert(c / _a == _b);
304     return c;
305   }
306 
307   /**
308   * @dev Integer division of two numbers, truncating the quotient.
309   */
310   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
311     // assert(_b > 0); // Solidity automatically throws when dividing by 0
312     // uint256 c = _a / _b;
313     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
314     return _a / _b;
315   }
316 
317   /**
318   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
319   */
320   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
321     assert(_b <= _a);
322     return _a - _b;
323   }
324 
325   /**
326   * @dev Adds two numbers, throws on overflow.
327   */
328   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
329     c = _a + _b;
330     assert(c >= _a);
331     return c;
332   }
333 }
334 
335 
336 
337 
338 /**
339  * Utility library of inline functions on addresses
340  */
341 library AddressUtils {
342 
343   /**
344    * Returns whether the target address is a contract
345    * @dev This function will return false if invoked during the constructor of a contract,
346    * as the code is not actually created until after the constructor finishes.
347    * @param _addr address to check
348    * @return whether the target address is a contract
349    */
350   function isContract(address _addr) internal view returns (bool) {
351     uint256 size;
352     // XXX Currently there is no better way to check if there is a contract in an address
353     // than to check the size of the code at that address.
354     // See https://ethereum.stackexchange.com/a/14016/36603
355     // for more details about how this works.
356     // TODO Check this again before the Serenity release, because all addresses will be
357     // contracts then.
358     // solium-disable-next-line security/no-inline-assembly
359     assembly { size := extcodesize(_addr) }
360     return size > 0;
361   }
362 
363 }
364 
365 
366 
367 
368 
369 
370 
371 
372 
373 
374 /**
375  * @title SupportsInterfaceWithLookup
376  * @author Matt Condon (@shrugs)
377  * @dev Implements ERC165 using a lookup table.
378  */
379 contract SupportsInterfaceWithLookup is ERC165 {
380 
381   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
382   /**
383    * 0x01ffc9a7 ===
384    *   bytes4(keccak256('supportsInterface(bytes4)'))
385    */
386 
387   /**
388    * @dev a mapping of interface id to whether or not it's supported
389    */
390   mapping(bytes4 => bool) internal supportedInterfaces;
391 
392   /**
393    * @dev A contract implementing SupportsInterfaceWithLookup
394    * implement ERC165 itself
395    */
396   constructor()
397     public
398   {
399     _registerInterface(InterfaceId_ERC165);
400   }
401 
402   /**
403    * @dev implement supportsInterface(bytes4) using a lookup table
404    */
405   function supportsInterface(bytes4 _interfaceId)
406     external
407     view
408     returns (bool)
409   {
410     return supportedInterfaces[_interfaceId];
411   }
412 
413   /**
414    * @dev private method for registering an interface
415    */
416   function _registerInterface(bytes4 _interfaceId)
417     internal
418   {
419     require(_interfaceId != 0xffffffff);
420     supportedInterfaces[_interfaceId] = true;
421   }
422 }
423 
424 
425 
426 /**
427  * @title ERC721 Non-Fungible Token Standard basic implementation
428  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
429  */
430 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
431 
432   using SafeMath for uint256;
433   using AddressUtils for address;
434 
435   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
436   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
437   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
438 
439   // Mapping from token ID to owner
440   mapping (uint256 => address) internal tokenOwner;
441 
442   // Mapping from token ID to approved address
443   mapping (uint256 => address) internal tokenApprovals;
444 
445   // Mapping from owner to number of owned token
446   mapping (address => uint256) internal ownedTokensCount;
447 
448   // Mapping from owner to operator approvals
449   mapping (address => mapping (address => bool)) internal operatorApprovals;
450 
451   constructor()
452     public
453   {
454     // register the supported interfaces to conform to ERC721 via ERC165
455     _registerInterface(InterfaceId_ERC721);
456     _registerInterface(InterfaceId_ERC721Exists);
457   }
458 
459   /**
460    * @dev Gets the balance of the specified address
461    * @param _owner address to query the balance of
462    * @return uint256 representing the amount owned by the passed address
463    */
464   function balanceOf(address _owner) public view returns (uint256) {
465     require(_owner != address(0));
466     return ownedTokensCount[_owner];
467   }
468 
469   /**
470    * @dev Gets the owner of the specified token ID
471    * @param _tokenId uint256 ID of the token to query the owner of
472    * @return owner address currently marked as the owner of the given token ID
473    */
474   function ownerOf(uint256 _tokenId) public view returns (address) {
475     address owner = tokenOwner[_tokenId];
476     require(owner != address(0));
477     return owner;
478   }
479 
480   /**
481    * @dev Returns whether the specified token exists
482    * @param _tokenId uint256 ID of the token to query the existence of
483    * @return whether the token exists
484    */
485   function exists(uint256 _tokenId) public view returns (bool) {
486     address owner = tokenOwner[_tokenId];
487     return owner != address(0);
488   }
489 
490   /**
491    * @dev Approves another address to transfer the given token ID
492    * The zero address indicates there is no approved address.
493    * There can only be one approved address per token at a given time.
494    * Can only be called by the token owner or an approved operator.
495    * @param _to address to be approved for the given token ID
496    * @param _tokenId uint256 ID of the token to be approved
497    */
498   function approve(address _to, uint256 _tokenId) public {
499     address owner = ownerOf(_tokenId);
500     require(_to != owner);
501     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
502 
503     tokenApprovals[_tokenId] = _to;
504     emit Approval(owner, _to, _tokenId);
505   }
506 
507   /**
508    * @dev Gets the approved address for a token ID, or zero if no address set
509    * @param _tokenId uint256 ID of the token to query the approval of
510    * @return address currently approved for the given token ID
511    */
512   function getApproved(uint256 _tokenId) public view returns (address) {
513     return tokenApprovals[_tokenId];
514   }
515 
516   /**
517    * @dev Sets or unsets the approval of a given operator
518    * An operator is allowed to transfer all tokens of the sender on their behalf
519    * @param _to operator address to set the approval
520    * @param _approved representing the status of the approval to be set
521    */
522   function setApprovalForAll(address _to, bool _approved) public {
523     require(_to != msg.sender);
524     operatorApprovals[msg.sender][_to] = _approved;
525     emit ApprovalForAll(msg.sender, _to, _approved);
526   }
527 
528   /**
529    * @dev Tells whether an operator is approved by a given owner
530    * @param _owner owner address which you want to query the approval of
531    * @param _operator operator address which you want to query the approval of
532    * @return bool whether the given operator is approved by the given owner
533    */
534   function isApprovedForAll(
535     address _owner,
536     address _operator
537   )
538     public
539     view
540     returns (bool)
541   {
542     return operatorApprovals[_owner][_operator];
543   }
544 
545   /**
546    * @dev Transfers the ownership of a given token ID to another address
547    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
548    * Requires the msg sender to be the owner, approved, or operator
549    * @param _from current owner of the token
550    * @param _to address to receive the ownership of the given token ID
551    * @param _tokenId uint256 ID of the token to be transferred
552   */
553   function transferFrom(
554     address _from,
555     address _to,
556     uint256 _tokenId
557   )
558     public
559   {
560     require(isApprovedOrOwner(msg.sender, _tokenId));
561     require(_from != address(0));
562     require(_to != address(0));
563 
564     clearApproval(_from, _tokenId);
565     removeTokenFrom(_from, _tokenId);
566     addTokenTo(_to, _tokenId);
567 
568     emit Transfer(_from, _to, _tokenId);
569   }
570 
571   /**
572    * @dev Safely transfers the ownership of a given token ID to another address
573    * If the target address is a contract, it must implement `onERC721Received`,
574    * which is called upon a safe transfer, and return the magic value
575    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
576    * the transfer is reverted.
577    *
578    * Requires the msg sender to be the owner, approved, or operator
579    * @param _from current owner of the token
580    * @param _to address to receive the ownership of the given token ID
581    * @param _tokenId uint256 ID of the token to be transferred
582   */
583   function safeTransferFrom(
584     address _from,
585     address _to,
586     uint256 _tokenId
587   )
588     public
589   {
590     // solium-disable-next-line arg-overflow
591     safeTransferFrom(_from, _to, _tokenId, "");
592   }
593 
594   /**
595    * @dev Safely transfers the ownership of a given token ID to another address
596    * If the target address is a contract, it must implement `onERC721Received`,
597    * which is called upon a safe transfer, and return the magic value
598    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
599    * the transfer is reverted.
600    * Requires the msg sender to be the owner, approved, or operator
601    * @param _from current owner of the token
602    * @param _to address to receive the ownership of the given token ID
603    * @param _tokenId uint256 ID of the token to be transferred
604    * @param _data bytes data to send along with a safe transfer check
605    */
606   function safeTransferFrom(
607     address _from,
608     address _to,
609     uint256 _tokenId,
610     bytes _data
611   )
612     public
613   {
614     transferFrom(_from, _to, _tokenId);
615     // solium-disable-next-line arg-overflow
616     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
617   }
618 
619   /**
620    * @dev Returns whether the given spender can transfer a given token ID
621    * @param _spender address of the spender to query
622    * @param _tokenId uint256 ID of the token to be transferred
623    * @return bool whether the msg.sender is approved for the given token ID,
624    *  is an operator of the owner, or is the owner of the token
625    */
626   function isApprovedOrOwner(
627     address _spender,
628     uint256 _tokenId
629   )
630     internal
631     view
632     returns (bool)
633   {
634     address owner = ownerOf(_tokenId);
635     // Disable solium check because of
636     // https://github.com/duaraghav8/Solium/issues/175
637     // solium-disable-next-line operator-whitespace
638     return (
639       _spender == owner ||
640       getApproved(_tokenId) == _spender ||
641       isApprovedForAll(owner, _spender)
642     );
643   }
644 
645   /**
646    * @dev Internal function to mint a new token
647    * Reverts if the given token ID already exists
648    * @param _to The address that will own the minted token
649    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
650    */
651   function _mint(address _to, uint256 _tokenId) internal {
652     require(_to != address(0));
653     addTokenTo(_to, _tokenId);
654     emit Transfer(address(0), _to, _tokenId);
655   }
656 
657   /**
658    * @dev Internal function to burn a specific token
659    * Reverts if the token does not exist
660    * @param _tokenId uint256 ID of the token being burned by the msg.sender
661    */
662   function _burn(address _owner, uint256 _tokenId) internal {
663     clearApproval(_owner, _tokenId);
664     removeTokenFrom(_owner, _tokenId);
665     emit Transfer(_owner, address(0), _tokenId);
666   }
667 
668   /**
669    * @dev Internal function to clear current approval of a given token ID
670    * Reverts if the given address is not indeed the owner of the token
671    * @param _owner owner of the token
672    * @param _tokenId uint256 ID of the token to be transferred
673    */
674   function clearApproval(address _owner, uint256 _tokenId) internal {
675     require(ownerOf(_tokenId) == _owner);
676     if (tokenApprovals[_tokenId] != address(0)) {
677       tokenApprovals[_tokenId] = address(0);
678     }
679   }
680 
681   /**
682    * @dev Internal function to add a token ID to the list of a given address
683    * @param _to address representing the new owner of the given token ID
684    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
685    */
686   function addTokenTo(address _to, uint256 _tokenId) internal {
687     require(tokenOwner[_tokenId] == address(0));
688     tokenOwner[_tokenId] = _to;
689     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
690   }
691 
692   /**
693    * @dev Internal function to remove a token ID from the list of a given address
694    * @param _from address representing the previous owner of the given token ID
695    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
696    */
697   function removeTokenFrom(address _from, uint256 _tokenId) internal {
698     require(ownerOf(_tokenId) == _from);
699     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
700     tokenOwner[_tokenId] = address(0);
701   }
702 
703   /**
704    * @dev Internal function to invoke `onERC721Received` on a target address
705    * The call is not executed if the target address is not a contract
706    * @param _from address representing the previous owner of the given token ID
707    * @param _to target address that will receive the tokens
708    * @param _tokenId uint256 ID of the token to be transferred
709    * @param _data bytes optional data to send along with the call
710    * @return whether the call correctly returned the expected magic value
711    */
712   function checkAndCallSafeTransfer(
713     address _from,
714     address _to,
715     uint256 _tokenId,
716     bytes _data
717   )
718     internal
719     returns (bool)
720   {
721     if (!_to.isContract()) {
722       return true;
723     }
724     bytes4 retval = ERC721Receiver(_to).onERC721Received(
725       msg.sender, _from, _tokenId, _data);
726     return (retval == ERC721_RECEIVED);
727   }
728 }
729 
730 
731 
732 
733 /**
734  * @title Full ERC721 Token
735  * This implementation includes all the required and some optional functionality of the ERC721 standard
736  * Moreover, it includes approve all functionality using operator terminology
737  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
738  */
739 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
740 
741   // Token name
742   string internal name_;
743 
744   // Token symbol
745   string internal symbol_;
746 
747   // Mapping from owner to list of owned token IDs
748   mapping(address => uint256[]) internal ownedTokens;
749 
750   // Mapping from token ID to index of the owner tokens list
751   mapping(uint256 => uint256) internal ownedTokensIndex;
752 
753   // Array with all token ids, used for enumeration
754   uint256[] internal allTokens;
755 
756   // Mapping from token id to position in the allTokens array
757   mapping(uint256 => uint256) internal allTokensIndex;
758 
759   // Optional mapping for token URIs
760   mapping(uint256 => string) internal tokenURIs;
761 
762   /**
763    * @dev Constructor function
764    */
765   constructor(string _name, string _symbol) public {
766     name_ = _name;
767     symbol_ = _symbol;
768 
769     // register the supported interfaces to conform to ERC721 via ERC165
770     _registerInterface(InterfaceId_ERC721Enumerable);
771     _registerInterface(InterfaceId_ERC721Metadata);
772   }
773 
774   /**
775    * @dev Gets the token name
776    * @return string representing the token name
777    */
778   function name() external view returns (string) {
779     return name_;
780   }
781 
782   /**
783    * @dev Gets the token symbol
784    * @return string representing the token symbol
785    */
786   function symbol() external view returns (string) {
787     return symbol_;
788   }
789 
790   /**
791    * @dev Returns an URI for a given token ID
792    * Throws if the token ID does not exist. May return an empty string.
793    * @param _tokenId uint256 ID of the token to query
794    */
795   function tokenURI(uint256 _tokenId) public view returns (string) {
796     require(exists(_tokenId));
797     return tokenURIs[_tokenId];
798   }
799 
800   /**
801    * @dev Gets the token ID at a given index of the tokens list of the requested owner
802    * @param _owner address owning the tokens list to be accessed
803    * @param _index uint256 representing the index to be accessed of the requested tokens list
804    * @return uint256 token ID at the given index of the tokens list owned by the requested address
805    */
806   function tokenOfOwnerByIndex(
807     address _owner,
808     uint256 _index
809   )
810     public
811     view
812     returns (uint256)
813   {
814     require(_index < balanceOf(_owner));
815     return ownedTokens[_owner][_index];
816   }
817 
818   /**
819    * @dev Gets the total amount of tokens stored by the contract
820    * @return uint256 representing the total amount of tokens
821    */
822   function totalSupply() public view returns (uint256) {
823     return allTokens.length;
824   }
825 
826   /**
827    * @dev Gets the token ID at a given index of all the tokens in this contract
828    * Reverts if the index is greater or equal to the total number of tokens
829    * @param _index uint256 representing the index to be accessed of the tokens list
830    * @return uint256 token ID at the given index of the tokens list
831    */
832   function tokenByIndex(uint256 _index) public view returns (uint256) {
833     require(_index < totalSupply());
834     return allTokens[_index];
835   }
836 
837   /**
838    * @dev Internal function to set the token URI for a given token
839    * Reverts if the token ID does not exist
840    * @param _tokenId uint256 ID of the token to set its URI
841    * @param _uri string URI to assign
842    */
843   function _setTokenURI(uint256 _tokenId, string _uri) internal {
844     require(exists(_tokenId));
845     tokenURIs[_tokenId] = _uri;
846   }
847 
848   /**
849    * @dev Internal function to add a token ID to the list of a given address
850    * @param _to address representing the new owner of the given token ID
851    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
852    */
853   function addTokenTo(address _to, uint256 _tokenId) internal {
854     super.addTokenTo(_to, _tokenId);
855     uint256 length = ownedTokens[_to].length;
856     ownedTokens[_to].push(_tokenId);
857     ownedTokensIndex[_tokenId] = length;
858   }
859 
860   /**
861    * @dev Internal function to remove a token ID from the list of a given address
862    * @param _from address representing the previous owner of the given token ID
863    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
864    */
865   function removeTokenFrom(address _from, uint256 _tokenId) internal {
866     super.removeTokenFrom(_from, _tokenId);
867 
868     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
869     // then delete the last slot.
870     uint256 tokenIndex = ownedTokensIndex[_tokenId];
871     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
872     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
873 
874     ownedTokens[_from][tokenIndex] = lastToken;
875     // This also deletes the contents at the last position of the array
876     ownedTokens[_from].length--;
877 
878     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
879     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
880     // the lastToken to the first position, and then dropping the element placed in the last position of the list
881 
882     ownedTokensIndex[_tokenId] = 0;
883     ownedTokensIndex[lastToken] = tokenIndex;
884   }
885 
886   /**
887    * @dev Internal function to mint a new token
888    * Reverts if the given token ID already exists
889    * @param _to address the beneficiary that will own the minted token
890    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
891    */
892   function _mint(address _to, uint256 _tokenId) internal {
893     super._mint(_to, _tokenId);
894 
895     allTokensIndex[_tokenId] = allTokens.length;
896     allTokens.push(_tokenId);
897   }
898 
899   /**
900    * @dev Internal function to burn a specific token
901    * Reverts if the token does not exist
902    * @param _owner owner of the token to burn
903    * @param _tokenId uint256 ID of the token being burned by the msg.sender
904    */
905   function _burn(address _owner, uint256 _tokenId) internal {
906     super._burn(_owner, _tokenId);
907 
908     // Clear metadata (if any)
909     if (bytes(tokenURIs[_tokenId]).length != 0) {
910       delete tokenURIs[_tokenId];
911     }
912 
913     // Reorg all tokens array
914     uint256 tokenIndex = allTokensIndex[_tokenId];
915     uint256 lastTokenIndex = allTokens.length.sub(1);
916     uint256 lastToken = allTokens[lastTokenIndex];
917 
918     allTokens[tokenIndex] = lastToken;
919     allTokens[lastTokenIndex] = 0;
920 
921     allTokens.length--;
922     allTokensIndex[_tokenId] = 0;
923     allTokensIndex[lastToken] = tokenIndex;
924   }
925 
926 }
927 
928 
929 
930 
931 
932 contract Functions {
933 
934     bytes32[] public randomHashes;
935 
936     function fillWithHashes() public {
937         require(randomHashes.length == 0);
938 
939         for (uint i = block.number - 100; i < block.number; i++) {
940             randomHashes.push(blockhash(i));
941         }
942     }
943 
944     /// @notice Function to calculate initial random seed based on our hashes
945     /// @param _randomHashIds are ids in our array of hashes
946     /// @param _timestamp is timestamp for that hash
947     /// @return uint representation of random seed
948     function calculateSeed(uint[] _randomHashIds, uint _timestamp) public view returns (uint) {
949         require(_timestamp != 0);
950         require(_randomHashIds.length == 10);
951 
952         bytes32 randomSeed = keccak256(
953             abi.encodePacked(
954             randomHashes[_randomHashIds[0]], randomHashes[_randomHashIds[1]],
955             randomHashes[_randomHashIds[2]], randomHashes[_randomHashIds[3]],
956             randomHashes[_randomHashIds[4]], randomHashes[_randomHashIds[5]],
957             randomHashes[_randomHashIds[6]], randomHashes[_randomHashIds[7]],
958             randomHashes[_randomHashIds[8]], randomHashes[_randomHashIds[9]],
959             _timestamp
960             )
961         );
962 
963         return uint(randomSeed);
964     }
965 
966     function getRandomHashesLength() public view returns(uint) {
967         return randomHashes.length;
968     }
969 
970     /// @notice Function which decodes bytes32 to array of integers
971     /// @param _potentialAssets are potential assets user would like to have
972     /// @return array of assetIds
973     function decodeAssets(bytes32[] _potentialAssets) public pure returns (uint[] assets) {
974         require(_potentialAssets.length > 0);
975 
976         uint[] memory assetsCopy = new uint[](_potentialAssets.length*10);
977         uint numberOfAssets = 0;
978 
979         for (uint j = 0; j < _potentialAssets.length; j++) {
980             uint input;
981             bytes32 pot = _potentialAssets[j];
982 
983             assembly {
984                 input := pot
985             }
986 
987             for (uint i = 10; i > 0; i--) {
988                 uint mask = (2 << ((i-1) * 24)) / 2;
989                 uint b = (input & (mask * 16777215)) / mask;
990 
991                 if (b != 0) {
992                     assetsCopy[numberOfAssets] = b;
993                     numberOfAssets++;
994                 }
995             }
996         }
997 
998         assets = new uint[](numberOfAssets);
999         for (i = 0; i < numberOfAssets; i++) {
1000             assets[i] = assetsCopy[i];
1001         }
1002     }
1003 
1004     /// @notice Function to pick random assets from potentialAssets array
1005     /// @param _finalSeed is final random seed
1006     /// @param _potentialAssets is bytes32[] array of potential assets
1007     /// @return uint[] array of randomly picked assets
1008     function pickRandomAssets(uint _finalSeed, bytes32[] _potentialAssets) public pure returns(uint[] finalPicked) {
1009         require(_finalSeed != 0);
1010         require(_potentialAssets.length > 0);
1011 
1012         uint[] memory assetIds = decodeAssets(_potentialAssets);
1013         uint[] memory pickedIds = new uint[](assetIds.length);
1014 
1015         uint finalSeedCopy = _finalSeed;
1016         uint index = 0;
1017 
1018         for (uint i = 0; i < assetIds.length; i++) {
1019             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
1020             if (finalSeedCopy % 2 == 0) {
1021                 pickedIds[index] = assetIds[i];
1022                 index++;
1023             }
1024         }
1025 
1026         finalPicked = new uint[](index);
1027         for (i = 0; i < index; i++) {
1028             finalPicked[i] = pickedIds[i];
1029         }
1030     }
1031 
1032     /// @notice Function to pick random assets from potentialAssets array
1033     /// @param _finalSeed is final random seed
1034     /// @param _potentialAssets is bytes32[] array of potential assets
1035     /// @param _width of canvas
1036     /// @param _height of canvas
1037     /// @return arrays of randomly picked assets defining ids, coordinates, zoom, rotation and layers
1038     function getImage(uint _finalSeed, bytes32[] _potentialAssets, uint _width, uint _height) public pure 
1039     returns(uint[] finalPicked, uint[] x, uint[] y, uint[] zoom, uint[] rotation, uint[] layers) {
1040         require(_finalSeed != 0);
1041         require(_potentialAssets.length > 0);
1042 
1043         uint[] memory assetIds = decodeAssets(_potentialAssets);
1044         uint[] memory pickedIds = new uint[](assetIds.length);
1045         x = new uint[](assetIds.length);
1046         y = new uint[](assetIds.length);
1047         zoom = new uint[](assetIds.length);
1048         rotation = new uint[](assetIds.length);
1049         layers = new uint[](assetIds.length);
1050 
1051         uint finalSeedCopy = _finalSeed;
1052         uint index = 0;
1053 
1054         for (uint i = 0; i < assetIds.length; i++) {
1055             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
1056             if (finalSeedCopy % 2 == 0) {
1057                 pickedIds[index] = assetIds[i];
1058                 (x[index], y[index], zoom[index], rotation[index], layers[index]) = pickRandomAssetPosition(finalSeedCopy, _width, _height);
1059                 index++;
1060             }
1061         }
1062 
1063         finalPicked = new uint[](index);
1064         for (i = 0; i < index; i++) {
1065             finalPicked[i] = pickedIds[i];
1066         }
1067     }
1068 
1069     /// @notice Function to pick random position for an asset
1070     /// @param _randomSeed is random seed for that image
1071     /// @param _width of canvas
1072     /// @param _height of canvas
1073     /// @return tuple of uints representing x,y,zoom,and rotation
1074     function pickRandomAssetPosition(uint _randomSeed, uint _width, uint _height) public pure 
1075     returns (uint x, uint y, uint zoom, uint rotation, uint layer) {
1076         
1077         x = _randomSeed % _width;
1078         y = _randomSeed % _height;
1079         zoom = _randomSeed % 200 + 800;
1080         rotation = _randomSeed % 360;
1081         // using random number for now
1082         // if two layers are same, sort by (keccak256(layer, assetId))
1083         layer = _randomSeed % 1234567; 
1084     }
1085 
1086     /// @notice Function to calculate final random seed for user
1087     /// @param _randomSeed is initially given random seed
1088     /// @param _iterations is number of iterations
1089     /// @return final seed for user as uint
1090     function getFinalSeed(uint _randomSeed, uint _iterations) public pure returns (bytes32) {
1091         require(_randomSeed != 0);
1092         require(_iterations != 0);
1093         bytes32 finalSeed = bytes32(_randomSeed);
1094 
1095         finalSeed = keccak256(abi.encodePacked(_randomSeed, _iterations));
1096         for (uint i = 0; i < _iterations; i++) {
1097             finalSeed = keccak256(abi.encodePacked(finalSeed, i));
1098         }
1099 
1100         return finalSeed;
1101     }
1102 
1103     function toHex(uint _randomSeed) public pure returns (bytes32) {
1104         return bytes32(_randomSeed);
1105     }
1106 }
1107 
1108 
1109 
1110 
1111 
1112 contract UserManager {
1113 
1114     struct User {
1115         string username;
1116         bytes32 hashToProfilePicture;
1117         bool exists;
1118     }
1119 
1120     uint public numberOfUsers;
1121 
1122     mapping(string => bool) internal usernameExists;
1123     mapping(address => User) public addressToUser;
1124 
1125     mapping(bytes32 => bool) public profilePictureExists;
1126     mapping(string => address) internal usernameToAddress;
1127 
1128     event NewUser(address indexed user, string username, bytes32 profilePicture);
1129 
1130     function register(string _username, bytes32 _hashToProfilePicture) public {
1131         require(usernameExists[_username] == false || 
1132                 keccak256(abi.encodePacked(getUsername(msg.sender))) == keccak256(abi.encodePacked(_username))
1133         );
1134 
1135         if (usernameExists[getUsername(msg.sender)]) {
1136             // if he already had username, that username is free now
1137             usernameExists[getUsername(msg.sender)] = false;
1138         } else {
1139             numberOfUsers++;
1140             emit NewUser(msg.sender, _username, _hashToProfilePicture);
1141         }
1142 
1143         addressToUser[msg.sender] = User({
1144             username: _username,
1145             hashToProfilePicture: _hashToProfilePicture,
1146             exists: true
1147         });
1148 
1149         usernameExists[_username] = true;
1150         profilePictureExists[_hashToProfilePicture] = true;
1151         usernameToAddress[_username] = msg.sender;
1152     }
1153 
1154     function changeProfilePicture(bytes32 _hashToProfilePicture) public {
1155         require(addressToUser[msg.sender].exists, "User doesn't exists");
1156 
1157         addressToUser[msg.sender].hashToProfilePicture = _hashToProfilePicture;
1158     }
1159 
1160     function getUserInfo(address _address) public view returns(string, bytes32) {
1161         User memory user = addressToUser[_address];
1162         return (user.username, user.hashToProfilePicture);
1163     }
1164 
1165     function getUsername(address _address) public view returns(string) {
1166         return addressToUser[_address].username;
1167     } 
1168 
1169     function getProfilePicture(address _address) public view returns(bytes32) {
1170         return addressToUser[_address].hashToProfilePicture;
1171     }
1172 
1173     function isUsernameExists(string _username) public view returns(bool) {
1174         return usernameExists[_username];
1175     }
1176 
1177 }
1178 
1179 
1180 contract DigitalPrintImage is ERC721Token("DigitalPrintImage", "DPM"), UserManager, Ownable {
1181 
1182     struct ImageMetadata {
1183         uint finalSeed;
1184         bytes32[] potentialAssets;
1185         uint timestamp;
1186         address creator;
1187         string ipfsHash;
1188         string extraData;
1189     }
1190 
1191     mapping(uint => bool) public seedExists;
1192     mapping(uint => ImageMetadata) public imageMetadata;
1193     mapping(uint => string) public idToIpfsHash;
1194 
1195     address public marketplaceContract;
1196     IAssetManager public assetManager;
1197     Functions public functions;
1198 
1199     modifier onlyMarketplaceContract() {
1200         require(msg.sender == address(marketplaceContract));
1201         _;
1202     }
1203 
1204     event ImageCreated(uint indexed imageId, address indexed owner);
1205     /// @dev only for testing purposes
1206     // function createImageTest() public {
1207     //     _mint(msg.sender, totalSupply());
1208     // }
1209 
1210     /// @notice Function will create new image
1211     /// @param _randomHashIds is array of random hashes from our array
1212     /// @param _timestamp is timestamp when image is created
1213     /// @param _iterations is number of how many times he generated random asset positions until he liked what he got
1214     /// @param _potentialAssets is set of all potential assets user selected for an image
1215     /// @param _author is nickname of image owner
1216     /// @param _ipfsHash is ipfsHash of the image .png
1217     /// @param _extraData string containing ipfsHash that contains (frame,width,height,title,description)
1218     /// @return returns id of created image
1219     function createImage(
1220         uint[] _randomHashIds,
1221         uint _timestamp,
1222         uint _iterations,
1223         bytes32[] _potentialAssets,
1224         string _author,
1225         string _ipfsHash,
1226         string _extraData) public payable {
1227         require(_potentialAssets.length <= 5);
1228         // if user exists send his username, if it doesn't check for some username that doesn't exists
1229         require(msg.sender == usernameToAddress[_author] || !usernameExists[_author]);
1230 
1231         // if user doesn't exists create that user with no profile picture
1232         if (!usernameExists[_author]) {
1233             register(_author, bytes32(0));
1234         }
1235 
1236         uint[] memory pickedAssets;
1237         uint finalSeed;
1238        
1239         (pickedAssets, finalSeed) = getPickedAssetsAndFinalSeed(_potentialAssets, _randomHashIds, _timestamp, _iterations); 
1240         uint[] memory pickedAssetPacks = assetManager.pickUniquePacks(pickedAssets);
1241         uint finalPrice = 0;
1242 
1243         for (uint i = 0; i < pickedAssetPacks.length; i++) {
1244             if (assetManager.checkHasPermissionForPack(msg.sender, pickedAssetPacks[i]) == false) {
1245                 finalPrice += assetManager.getAssetPackPrice(pickedAssetPacks[i]);
1246 
1247                 assetManager.buyAssetPack.value(assetManager.getAssetPackPrice(pickedAssetPacks[i]))(msg.sender, pickedAssetPacks[i]);
1248             }
1249         }
1250         
1251         require(msg.value >= finalPrice);
1252 
1253         uint id = totalSupply();
1254         _mint(msg.sender, id);
1255 
1256         imageMetadata[id] = ImageMetadata({
1257             finalSeed: finalSeed,
1258             potentialAssets: _potentialAssets,
1259             timestamp: _timestamp,
1260             creator: msg.sender,
1261             ipfsHash: _ipfsHash,
1262             extraData: _extraData
1263         });
1264 
1265         idToIpfsHash[id] = _ipfsHash;
1266         seedExists[finalSeed] = true;
1267 
1268         emit ImageCreated(id, msg.sender);
1269     }
1270 
1271     /// @notice approving image to be taken from specific address
1272     /// @param _from address from which we transfer image
1273     /// @param _to address that we give permission to take image
1274     /// @param _imageId we are willing to give
1275     function transferFromMarketplace(address _from, address _to, uint256 _imageId) public onlyMarketplaceContract {
1276         require(isApprovedOrOwner(_from, _imageId));
1277 
1278         clearApproval(_from, _imageId);
1279         removeTokenFrom(_from, _imageId);
1280         addTokenTo(_to, _imageId);
1281 
1282         emit Transfer(_from, _to, _imageId);
1283     }
1284 
1285     /// @notice adds marketplace address to contract only if it doesn't already exist
1286     /// @param _marketplaceContract address of marketplace contract
1287     function addMarketplaceContract(address _marketplaceContract) public onlyOwner {
1288         require(address(marketplaceContract) == 0x0);
1289         
1290         marketplaceContract = _marketplaceContract;
1291     }
1292 
1293     /// @notice Function to add assetManager
1294     /// @param _assetManager is address of assetManager contract
1295     function addAssetManager(address _assetManager) public onlyOwner {
1296         require(address(assetManager) == 0x0);
1297 
1298         assetManager = IAssetManager(_assetManager);
1299     }
1300 
1301     /// @notice Function to add functions contract
1302     /// @param _functions is address of functions contract
1303     function addFunctions(address _functions) public onlyOwner {
1304         require(address(functions) == 0x0);
1305 
1306         functions = Functions(_functions);
1307     }
1308 
1309     /// @notice Function to calculate final price for an image based on selected assets
1310     /// @param _pickedAssets is array of picked packs
1311     /// @param _owner is address of image owner
1312     /// @return finalPrice for the image
1313     function calculatePrice(uint[] _pickedAssets, address _owner) public view returns (uint) {
1314         if (_pickedAssets.length == 0) {
1315             return 0;
1316         }
1317 
1318         uint[] memory pickedAssetPacks = assetManager.pickUniquePacks(_pickedAssets);
1319         uint finalPrice = 0;
1320         for (uint i = 0; i < pickedAssetPacks.length; i++) {
1321             if (assetManager.checkHasPermissionForPack(_owner, pickedAssetPacks[i]) == false) {
1322                 finalPrice += assetManager.getAssetPackPrice(pickedAssetPacks[i]);
1323             }
1324         }
1325 
1326         return finalPrice;
1327     }
1328 
1329     /// @notice Method returning informations needed for gallery page
1330     /// @param _imageId id of image 
1331     function getGalleryData(uint _imageId) public view 
1332     returns(address, address, string, bytes32, string, string) {
1333         require(_imageId < totalSupply());
1334 
1335         return(
1336             imageMetadata[_imageId].creator,
1337             ownerOf(_imageId),
1338             addressToUser[ownerOf(_imageId)].username,
1339             addressToUser[ownerOf(_imageId)].hashToProfilePicture,
1340             imageMetadata[_imageId].ipfsHash,
1341             imageMetadata[_imageId].extraData
1342         );
1343 
1344     }
1345 
1346     /// @notice returns metadata of image
1347     /// @dev not possible to use public mapping because of array of bytes32
1348     /// @param _imageId id of image
1349     function getImageMetadata(uint _imageId) public view
1350     returns(address, string, uint, string, uint, bytes32[]) {
1351         ImageMetadata memory metadata = imageMetadata[_imageId];
1352 
1353         return(
1354             metadata.creator,
1355             metadata.extraData,
1356             metadata.finalSeed,
1357             metadata.ipfsHash,
1358             metadata.timestamp,
1359             metadata.potentialAssets
1360         );
1361     }
1362 
1363     /// @notice returns all images owned by _user
1364     /// @param _user address of user
1365     function getUserImages(address _user) public view returns(uint[]) {
1366         return ownedTokens[_user];
1367     }
1368 
1369     /// @notice returns picked assets from potential assets and final seed
1370     /// @param _potentialAssets array of all potential assets encoded in bytes32
1371     /// @param _randomHashIds selected random hash ids from our contract
1372     /// @param _timestamp timestamp of image creation
1373     /// @param _iterations number of iterations to get to final seed
1374     function getPickedAssetsAndFinalSeed(bytes32[] _potentialAssets, uint[] _randomHashIds, uint _timestamp, uint _iterations) internal view returns(uint[], uint) {
1375         uint finalSeed = uint(functions.getFinalSeed(functions.calculateSeed(_randomHashIds, _timestamp), _iterations));
1376 
1377         require(!seedExists[finalSeed]);
1378 
1379         return (functions.pickRandomAssets(finalSeed, _potentialAssets), finalSeed);
1380     }
1381 
1382 }
1383 
1384 
1385 
1386 contract Marketplace is Ownable {
1387 
1388     struct Ad {
1389         uint price;
1390         address exchanger;
1391         bool exists;
1392         bool active;
1393     }
1394 
1395     DigitalPrintImage public digitalPrintImageContract;
1396 
1397     uint public creatorPercentage = 3; // 3 percentage
1398     uint public marketplacePercentage = 2; // 2 percentage
1399     uint public numberOfAds;
1400     uint[] public allAds;
1401     //image id to Ad
1402     mapping(uint => Ad) public sellAds;
1403     mapping(address => uint) public balances;
1404 
1405     constructor(address _digitalPrintImageContract) public {
1406         digitalPrintImageContract = DigitalPrintImage(_digitalPrintImageContract);
1407         numberOfAds = 0;
1408     }
1409 
1410     event SellingImage(uint indexed imageId, uint price);
1411     event ImageBought(uint indexed imageId, address indexed newOwner, uint price);
1412 
1413     /// @notice Function to add image on marketplace
1414     /// @dev only image owner can add image to marketplace
1415     /// @param _imageId is id of image
1416     /// @param _price is price for which we are going to sell image
1417     function sell(uint _imageId, uint _price) public {
1418         require(digitalPrintImageContract.ownerOf(_imageId) == msg.sender);
1419 
1420         bool exists = sellAds[_imageId].exists;
1421 
1422         sellAds[_imageId] = Ad({
1423             price: _price,
1424             exchanger: msg.sender,
1425             exists: true,
1426             active: true
1427         });
1428 
1429         if (!exists) {
1430             numberOfAds++;
1431             allAds.push(_imageId);
1432         }
1433 
1434         emit SellingImage(_imageId, _price);
1435     }
1436     
1437     function getActiveAds() public view returns (uint[], uint[]) {
1438         uint count;
1439         for (uint i = 0; i < numberOfAds; i++) {
1440             // active on sale are only those that exists and its still the same owner
1441             if (isImageOnSale(allAds[i])) {
1442                 count++;
1443             }
1444         }
1445 
1446         uint[] memory imageIds = new uint[](count);
1447         uint[] memory prices = new uint[](count);
1448         count = 0;
1449         for (i = 0; i < numberOfAds; i++) {
1450             Ad memory ad = sellAds[allAds[i]];
1451             // active on sale are only those that exists and its still the same owner
1452             if (isImageOnSale(allAds[i])) {
1453                 imageIds[count] = allAds[i];
1454                 prices[count] = ad.price;
1455                 count++;
1456             }
1457         }
1458 
1459         return (imageIds, prices);
1460     }
1461 
1462     function isImageOnSale(uint _imageId) public view returns(bool) {
1463         Ad memory ad = sellAds[_imageId];
1464 
1465         return ad.exists && ad.active && (ad.exchanger == digitalPrintImageContract.ownerOf(_imageId));
1466     }
1467 
1468     /// @notice Function to buy image from Marketplace
1469     /// @param _imageId is Id of image we are going to buy
1470     function buy(uint _imageId) public payable {
1471         require(isImageOnSale(_imageId));
1472         require(msg.value >= sellAds[_imageId].price);
1473 
1474         removeOrder(_imageId);
1475 
1476         address _creator;
1477         address _imageOwner = digitalPrintImageContract.ownerOf(_imageId);
1478         (, , _creator, ,) = digitalPrintImageContract.imageMetadata(_imageId);
1479 
1480         balances[_creator] += msg.value * 2 / 100;
1481         balances[owner] += msg.value * 3 / 100;
1482         balances[_imageOwner] += msg.value * 95 / 100;
1483 
1484         digitalPrintImageContract.transferFromMarketplace(sellAds[_imageId].exchanger, msg.sender, _imageId);
1485 
1486         emit ImageBought(_imageId, msg.sender, msg.value);
1487     }
1488 
1489     /// @notice Function to remove image from Marketplace
1490     /// @dev image can be withdrawed only by its owner
1491     /// @param _imageId is id of image we would like to get back
1492     function cancel(uint _imageId) public {
1493         require(sellAds[_imageId].exists == true);
1494         require(sellAds[_imageId].exchanger == msg.sender);
1495         require(sellAds[_imageId].active == true);
1496 
1497         removeOrder(_imageId);
1498     }
1499 
1500     function withdraw() public {
1501         
1502         uint amount = balances[msg.sender];
1503         balances[msg.sender] = 0;
1504 
1505         msg.sender.transfer(amount);
1506     }
1507 
1508     /// @notice Removes image from imgagesOnSale list
1509     /// @param _imageId is id of image we want to remove
1510     function removeOrder(uint _imageId) private {
1511         sellAds[_imageId].active = false;
1512     }
1513 }