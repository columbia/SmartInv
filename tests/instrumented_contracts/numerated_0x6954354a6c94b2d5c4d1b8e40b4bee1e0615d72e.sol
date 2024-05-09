1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC721 interface
5  * @dev see https://github.com/ethereum/eips/issues/721
6  */
7 
8 /* solium-disable zeppelin/missing-natspec-comments */
9 contract ERC721 {
10   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
11   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
12   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
13 
14   function balanceOf(address _owner) public view returns (uint256 _balance);
15   function ownerOf(uint256 _tokenId) public view returns (address _owner);
16   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
17   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
18   function transfer(address _to, uint256 _tokenId) external;
19   function transferFrom(address _from, address _to, uint256 _tokenId) public;
20   function approve(address _to, uint256 _tokenId) external;
21   function setApprovalForAll(address _to, bool _approved) external;
22   function getApproved(uint256 _tokenId) public view returns (address);
23   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
24 }
25 
26 interface ERC165 {
27     /// @notice Query if a contract implements an interface
28     /// @param interfaceID The interface identifier, as specified in ERC-165
29     /// @dev Interface identification is specified in ERC-165. This function
30     ///  uses less than 30,000 gas.
31     /// @return `true` if the contract implements `interfaceID` and
32     ///  `interfaceID` is not 0xffffffff, `false` otherwise
33     function supportsInterface(bytes4 interfaceID) external view returns (bool);
34 }
35 
36 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
37 interface ERC721TokenReceiver {
38     /// @notice Handle the receipt of an NFT
39     /// @dev The ERC721 smart contract calls this function on the recipient
40     ///  after a `transfer`. This function MAY throw to revert and reject the
41     ///  transfer. This function MUST use 50,000 gas or less. Return of other
42     ///  than the magic value MUST result in the transaction being reverted.
43     ///  Note: the contract address is always the message sender.
44     /// @param _from The sending address
45     /// @param _tokenId The NFT identifier which is being transfered
46     /// @param _data Additional data with no specified format
47     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
48     ///  unless throwing
49   function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     if (a == 0) {
63       return 0;
64     }
65     uint256 c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   /**
81   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) public onlyOwner {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140   /**
141    * @dev Allows the current owner to relinquish control of the contract.
142    */
143   function renounceOwnership() public onlyOwner {
144     emit OwnershipRenounced(owner);
145     owner = address(0);
146   }
147 }
148 library Strings {
149   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
150   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
151       bytes memory _ba = bytes(_a);
152       bytes memory _bb = bytes(_b);
153       bytes memory _bc = bytes(_c);
154       bytes memory _bd = bytes(_d);
155       bytes memory _be = bytes(_e);
156       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
157       bytes memory babcde = bytes(abcde);
158       uint k = 0;
159       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
160       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
161       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
162       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
163       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
164       return string(babcde);
165     }
166 
167     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
168         return strConcat(_a, _b, _c, _d, "");
169     }
170 
171     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
172         return strConcat(_a, _b, _c, "", "");
173     }
174 
175     function strConcat(string _a, string _b) internal pure returns (string) {
176         return strConcat(_a, _b, "", "", "");
177     }
178 
179     function uint2str(uint i) internal pure returns (string) {
180         if (i == 0) return "0";
181         uint j = i;
182         uint len;
183         while (j != 0){
184             len++;
185             j /= 10;
186         }
187         bytes memory bstr = new bytes(len);
188         uint k = len - 1;
189         while (i != 0){
190             bstr[k--] = byte(48 + i % 10);
191             i /= 10;
192         }
193         return string(bstr);
194     }
195 }
196 
197 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
199 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
200 interface ERC721Metadata /* is ERC721 */ {
201     /// @notice A descriptive name for a collection of NFTs in this contract
202     function name() external pure returns (string _name);
203 
204     /// @notice An abbreviated name for NFTs in this contract
205     function symbol() external pure returns (string _symbol);
206 
207     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
208     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
209     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
210     ///  Metadata JSON Schema".
211     function tokenURI(uint256 _tokenId) external view returns (string);
212 }
213 contract ERC721SlimToken is Ownable, ERC721, ERC165, ERC721Metadata {
214   using SafeMath for uint256;
215 
216   string public constant NAME = "EtherLoot";
217   string public constant SYMBOL = "ETLT";
218   string public tokenMetadataBaseURI = "http://api.etherloot.moonshadowgames.com/tokenmetadata/";
219 
220   struct AddressAndTokenIndex {
221     address owner;
222     uint32 tokenIndex;
223   }
224 
225   mapping (uint256 => AddressAndTokenIndex) private tokenOwnerAndTokensIndex;
226 
227   mapping (address => uint256[]) private ownedTokens;
228 
229   mapping (uint256 => address) private tokenApprovals;
230 
231   mapping (address => mapping (address => bool)) private operatorApprovals;
232 
233   mapping (address => bool) private approvedContractAddresses;
234 
235   bool approvedContractsFinalized = false;
236 
237   function implementsERC721() external pure returns (bool) {
238     return true;
239   }
240 
241 
242 
243   function supportsInterface(
244     bytes4 interfaceID)
245     external view returns (bool)
246   {
247     return
248       interfaceID == this.supportsInterface.selector || // ERC165
249       interfaceID == 0x5b5e139f || // ERC721Metadata
250       interfaceID == 0x6466353c; // ERC-721
251   }
252 
253   function name() external pure returns (string) {
254     return NAME;
255   }
256 
257   function symbol() external pure returns (string) {
258     return SYMBOL;
259   }
260 
261   function setTokenMetadataBaseURI(string _tokenMetadataBaseURI) external onlyOwner {
262     tokenMetadataBaseURI = _tokenMetadataBaseURI;
263   }
264 
265   function tokenURI(uint256 tokenId)
266     external
267     view
268     returns (string infoUrl)
269   {
270     return Strings.strConcat(
271       tokenMetadataBaseURI,
272       Strings.uint2str(tokenId));
273   }
274 
275   /**
276   * @notice Guarantees msg.sender is owner of the given token
277   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
278   */
279   modifier onlyOwnerOf(uint256 _tokenId) {
280     require(ownerOf(_tokenId) == msg.sender, "not owner");
281     _;
282   }
283 
284   /**
285   * @notice Gets the balance of the specified address
286   * @param _owner address to query the balance of
287   * @return uint256 representing the amount owned by the passed address
288   */
289   function balanceOf(address _owner) public view returns (uint256) {
290     require(_owner != address(0), "null owner");
291     return ownedTokens[_owner].length;
292   }
293 
294   /**
295   * @notice Gets the list of tokens owned by a given address
296   * @param _owner address to query the tokens of
297   * @return uint256[] representing the list of tokens owned by the passed address
298   */
299   function tokensOf(address _owner) public view returns (uint256[]) {
300     return ownedTokens[_owner];
301   }
302 
303   /**
304   * @notice Enumerate NFTs assigned to an owner
305   * @dev Throws if `_index` >= `balanceOf(_owner)` or if
306   *  `_owner` is the zero address, representing invalid NFTs.
307   * @param _owner An address where we are interested in NFTs owned by them
308   * @param _index A counter less than `balanceOf(_owner)`
309   * @return The token identifier for the `_index`th NFT assigned to `_owner`,
310   */
311   function tokenOfOwnerByIndex(address _owner, uint256 _index)
312     external
313     view
314     returns (uint256 _tokenId)
315   {
316     require(_index < balanceOf(_owner), "invalid index");
317     return ownedTokens[_owner][_index];
318   }
319 
320   /**
321   * @notice Gets the owner of the specified token ID
322   * @param _tokenId uint256 ID of the token to query the owner of
323   * @return owner address currently marked as the owner of the given token ID
324   */
325   function ownerOf(uint256 _tokenId) public view returns (address) {
326     address _owner = tokenOwnerAndTokensIndex[_tokenId].owner;
327     require(_owner != address(0), "invalid owner");
328     return _owner;
329   }
330 
331   function exists(uint256 _tokenId) public view returns (bool) {
332     address _owner = tokenOwnerAndTokensIndex[_tokenId].owner;
333     return (_owner != address(0));
334   }
335 
336   /**
337    * @notice Gets the approved address to take ownership of a given token ID
338    * @param _tokenId uint256 ID of the token to query the approval of
339    * @return address currently approved to take ownership of the given token ID
340    */
341   function getApproved(uint256 _tokenId) public view returns (address) {
342     return tokenApprovals[_tokenId];
343   }
344 
345   /**
346    * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
347    * Checks both for specific approval and operator approval
348    * @param _tokenId uint256 ID of the token to query the approval of
349    * @return bool whether transfer by msg.sender is approved for the given token ID or not
350    */
351   function isSenderApprovedFor(uint256 _tokenId) internal view returns (bool) {
352     return
353       ownerOf(_tokenId) == msg.sender ||
354       isSpecificallyApprovedFor(msg.sender, _tokenId) ||
355       isApprovedForAll(ownerOf(_tokenId), msg.sender);
356   }
357 
358   /**
359    * @notice Tells whether the msg.sender is approved for the given token ID or not
360    * @param _asker address of asking for approval
361    * @param _tokenId uint256 ID of the token to query the approval of
362    * @return bool whether the msg.sender is approved for the given token ID or not
363    */
364   function isSpecificallyApprovedFor(address _asker, uint256 _tokenId) internal view returns (bool) {
365     return getApproved(_tokenId) == _asker;
366   }
367 
368   /**
369    * @notice Tells whether an operator is approved by a given owner
370    * @param _owner owner address which you want to query the approval of
371    * @param _operator operator address which you want to query the approval of
372    * @return bool whether the given operator is approved by the given owner
373    */
374   function isApprovedForAll(address _owner, address _operator) public view returns (bool)
375   {
376     return operatorApprovals[_owner][_operator];
377   }
378 
379   /**
380   * @notice Transfers the ownership of a given token ID to another address
381   * @param _to address to receive the ownership of the given token ID
382   * @param _tokenId uint256 ID of the token to be transferred
383   */
384   function transfer(address _to, uint256 _tokenId)
385     external
386     onlyOwnerOf(_tokenId)
387   {
388     _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
389   }
390 
391   /**
392   * @notice Approves another address to claim for the ownership of the given token ID
393   * @param _to address to be approved for the given token ID
394   * @param _tokenId uint256 ID of the token to be approved
395   */
396   function approve(address _to, uint256 _tokenId)
397     external
398     onlyOwnerOf(_tokenId)
399   {
400     address _owner = ownerOf(_tokenId);
401     require(_to != _owner, "already owns");
402     if (getApproved(_tokenId) != 0 || _to != 0) {
403       tokenApprovals[_tokenId] = _to;
404       emit Approval(_owner, _to, _tokenId);
405     }
406   }
407 
408   /**
409   * @notice Enable or disable approval for a third party ("operator") to manage all your assets
410   * @dev Emits the ApprovalForAll event
411   * @param _to Address to add to the set of authorized operators.
412   * @param _approved True if the operators is approved, false to revoke approval
413   */
414   function setApprovalForAll(address _to, bool _approved)
415     external
416   {
417     if(_approved) {
418       approveAll(_to);
419     } else {
420       disapproveAll(_to);
421     }
422   }
423 
424   /**
425   * @notice Approves another address to claim for the ownership of any tokens owned by this account
426   * @param _to address to be approved for the given token ID
427   */
428   function approveAll(address _to)
429     public
430   {
431     require(_to != msg.sender, "cant approve yourself");
432     require(_to != address(0), "invalid owner");
433     operatorApprovals[msg.sender][_to] = true;
434     emit ApprovalForAll(msg.sender, _to, true);
435   }
436 
437   /**
438   * @notice Removes approval for another address to claim for the ownership of any
439   *  tokens owned by this account.
440   * @dev Note that this only removes the operator approval and
441   *  does not clear any independent, specific approvals of token transfers to this address
442   * @param _to address to be disapproved for the given token ID
443   */
444   function disapproveAll(address _to)
445     public
446   {
447     require(_to != msg.sender, "cant unapprove yourself");
448     delete operatorApprovals[msg.sender][_to];
449     emit ApprovalForAll(msg.sender, _to, false);
450   }
451 
452   /**
453   * @notice Claims the ownership of a given token ID
454   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
455   */
456   function takeOwnership(uint256 _tokenId)
457    external
458   {
459     require(isSenderApprovedFor(_tokenId), "not approved");
460     _clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
461   }
462 
463   /**
464   * @notice Transfer a token owned by another address, for which the calling address has
465   *  previously been granted transfer approval by the owner.
466   * @param _from The address that owns the token
467   * @param _to The address that will take ownership of the token. Can be any address, including the caller
468   * @param _tokenId The ID of the token to be transferred
469   */
470   function transferFrom(
471     address _from,
472     address _to,
473     uint256 _tokenId
474   )
475     public
476   {
477     address tokenOwner = ownerOf(_tokenId);
478     require(isSenderApprovedFor(_tokenId) || 
479       (approvedContractAddresses[msg.sender] && tokenOwner == tx.origin), "not an approved sender");
480     require(tokenOwner == _from, "wrong owner");
481     _clearApprovalAndTransfer(ownerOf(_tokenId), _to, _tokenId);
482   }
483 
484   /**
485   * @notice Transfers the ownership of an NFT from one address to another address
486   * @dev Throws unless `msg.sender` is the current owner, an authorized
487   * operator, or the approved address for this NFT. Throws if `_from` is
488   * not the current owner. Throws if `_to` is the zero address. Throws if
489   * `_tokenId` is not a valid NFT. When transfer is complete, this function
490   * checks if `_to` is a smart contract (code size > 0). If so, it calls
491   * `onERC721Received` on `_to` and throws if the return value is not
492   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
493   * @param _from The current owner of the NFT
494   * @param _to The new owner
495   * @param _tokenId The NFT to transfer
496   * @param _data Additional data with no specified format, sent in call to `_to`
497   */
498   function safeTransferFrom(
499     address _from,
500     address _to,
501     uint256 _tokenId,
502     bytes _data
503   )
504     public
505   {
506     require(_to != address(0), "invalid target address");
507     transferFrom(_from, _to, _tokenId);
508     if (_isContract(_to)) {
509       bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
510         _from, _tokenId, _data
511       );
512       require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")), "invalid receiver respononse");
513     }
514   }
515 
516   /*
517    * @notice Transfers the ownership of an NFT from one address to another address
518    * @dev This works identically to the other function with an extra data parameter,
519    *  except this function just sets data to ""
520    * @param _from The current owner of the NFT
521    * @param _to The new owner
522    * @param _tokenId The NFT to transfer
523   */
524   function safeTransferFrom(
525     address _from,
526     address _to,
527     uint256 _tokenId
528   )
529     external
530   {
531     safeTransferFrom(_from, _to, _tokenId, "");
532   }
533 
534   /**
535   * @notice Approve a contract address for minting tokens and transferring tokens, when approved by the owner
536   * @param contractAddress The address that will be approved
537   */
538   function addApprovedContractAddress(address contractAddress) public onlyOwner
539   {
540     require(!approvedContractsFinalized);
541     approvedContractAddresses[contractAddress] = true;
542   }
543 
544   /**
545   * @notice Unapprove a contract address for minting tokens and transferring tokens
546   * @param contractAddress The address that will be unapproved
547   */
548   function removeApprovedContractAddress(address contractAddress) public onlyOwner
549   {
550     require(!approvedContractsFinalized);
551     approvedContractAddresses[contractAddress] = false;
552   }
553 
554   /**
555   * @notice Finalize the contract so it will be forever impossible to change the approved contracts list
556   */
557   function finalizeApprovedContracts() public onlyOwner {
558     approvedContractsFinalized = true;
559   }
560 
561   /**
562   * @notice Mint token function
563   * @param _to The address that will own the minted token
564   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
565   */
566   function mint(address _to, uint256 _tokenId) public {
567     require(
568       approvedContractAddresses[msg.sender] ||
569       msg.sender == owner, "minter not approved"
570     );
571     _mint(_to, _tokenId);
572   }
573 
574   /**
575   * @notice Mint token function
576   * @param _to The address that will own the minted token
577   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
578   */
579   function _mint(address _to, uint256 _tokenId) internal {
580     require(_to != address(0), "invalid target address");
581     require(tokenOwnerAndTokensIndex[_tokenId].owner == address(0), "token already exists");
582     _addToken(_to, _tokenId);
583     emit Transfer(0x0, _to, _tokenId);
584   }
585 
586   /**
587   * @notice Internal function to clear current approval and transfer the ownership of a given token ID
588   * @param _from address which you want to send tokens from
589   * @param _to address which you want to transfer the token to
590   * @param _tokenId uint256 ID of the token to be transferred
591   */
592   function _clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
593     require(_to != address(0), "invalid target address");
594     require(_to != ownerOf(_tokenId), "already owns");
595     require(ownerOf(_tokenId) == _from, "wrong owner");
596 
597     _clearApproval(_from, _tokenId);
598     _removeToken(_from, _tokenId);
599     _addToken(_to, _tokenId);
600     emit Transfer(_from, _to, _tokenId);
601   }
602 
603   /**
604   * @notice Internal function to clear current approval of a given token ID
605   * @param _tokenId uint256 ID of the token to be transferred
606   */
607   function _clearApproval(address _owner, uint256 _tokenId) private {
608     require(ownerOf(_tokenId) == _owner, "wrong owner");
609     if (tokenApprovals[_tokenId] != 0) {
610       tokenApprovals[_tokenId] = 0;
611       emit Approval(_owner, 0, _tokenId);
612     }
613   }
614 
615   /**
616   * @notice Internal function to add a token ID to the list of a given address
617   * @param _to address representing the new owner of the given token ID
618   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
619   */
620   function _addToken(address _to, uint256 _tokenId) private {
621     uint256 newTokenIndex = ownedTokens[_to].length;
622     ownedTokens[_to].push(_tokenId);
623 
624     // I don't expect anyone to own 4 billion tokens, but just in case...
625     require(newTokenIndex == uint256(uint32(newTokenIndex)), "overflow");
626 
627     tokenOwnerAndTokensIndex[_tokenId] = AddressAndTokenIndex({owner: _to, tokenIndex: uint32(newTokenIndex)});
628   }
629 
630   /**
631   * @notice Internal function to remove a token ID from the list of a given address
632   * @param _from address representing the previous owner of the given token ID
633   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
634   */
635   function _removeToken(address _from, uint256 _tokenId) private {
636     require(ownerOf(_tokenId) == _from, "wrong owner");
637 
638     uint256 tokenIndex = tokenOwnerAndTokensIndex[_tokenId].tokenIndex;
639     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
640     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
641 
642     ownedTokens[_from][tokenIndex] = lastToken;
643 
644     ownedTokens[_from].length--;
645     tokenOwnerAndTokensIndex[lastToken] = AddressAndTokenIndex({owner: _from, tokenIndex: uint32(tokenIndex)});
646   }
647 
648   function _isContract(address addr) internal view returns (bool) {
649     uint size;
650     assembly { size := extcodesize(addr) }
651     return size > 0;
652   }
653 }
654 /**
655  * @title Math
656  * @dev Assorted math operations
657  */
658 library Math {
659   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
660     return a >= b ? a : b;
661   }
662 
663   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
664     return a < b ? a : b;
665   }
666 
667   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
668     return a >= b ? a : b;
669   }
670 
671   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
672     return a < b ? a : b;
673   }
674 
675   function smax256(int256 a, int256 b) internal pure returns (int256) {
676     return a >= b ? a : b;
677   }
678 }
679 
680 contract ContractAccessControl {
681 
682   event ContractUpgrade(address newContract);
683   event Paused();
684   event Unpaused();
685 
686   address public ceoAddress;
687 
688   address public cfoAddress;
689 
690   address public cooAddress;
691 
692   address public withdrawalAddress;
693 
694   bool public paused = false;
695 
696   modifier onlyCEO() {
697     require(msg.sender == ceoAddress);
698     _;
699   }
700 
701   modifier onlyCFO() {
702     require(msg.sender == cfoAddress);
703     _;
704   }
705 
706   modifier onlyCOO() {
707     require(msg.sender == cooAddress);
708     _;
709   }
710 
711   modifier onlyCLevel() {
712     require(
713       msg.sender == cooAddress ||
714       msg.sender == ceoAddress ||
715       msg.sender == cfoAddress
716     );
717     _;
718   }
719 
720   modifier onlyCEOOrCFO() {
721     require(
722       msg.sender == cfoAddress ||
723       msg.sender == ceoAddress
724     );
725     _;
726   }
727 
728   modifier onlyCEOOrCOO() {
729     require(
730       msg.sender == cooAddress ||
731       msg.sender == ceoAddress
732     );
733     _;
734   }
735 
736   function setCEO(address _newCEO) external onlyCEO {
737     require(_newCEO != address(0));
738     ceoAddress = _newCEO;
739   }
740 
741   function setCFO(address _newCFO) external onlyCEO {
742     require(_newCFO != address(0));
743     cfoAddress = _newCFO;
744   }
745 
746   function setCOO(address _newCOO) external onlyCEO {
747     require(_newCOO != address(0));
748     cooAddress = _newCOO;
749   }
750 
751   function setWithdrawalAddress(address _newWithdrawalAddress) external onlyCEO {
752     require(_newWithdrawalAddress != address(0));
753     withdrawalAddress = _newWithdrawalAddress;
754   }
755 
756   function withdrawBalance() external onlyCEOOrCFO {
757     require(withdrawalAddress != address(0));
758     withdrawalAddress.transfer(this.balance);
759   }
760 
761   modifier whenNotPaused() {
762     require(!paused);
763     _;
764   }
765 
766   modifier whenPaused() {
767     require(paused);
768     _;
769   }
770 
771   function pause() public onlyCLevel whenNotPaused {
772     paused = true;
773     emit Paused();
774   }
775 
776   function unpause() public onlyCEO whenPaused {
777     paused = false;
778     emit Unpaused();
779   }
780 }
781 
782 contract CryptoBoss is ContractAccessControl {
783 
784   address constant tokenContractAddress = 0xe1015a79a7d488f8fecf073b187d38c6f1a77368;
785   ERC721SlimToken constant tokenContract = ERC721SlimToken(tokenContractAddress);
786 
787   event Participating(address indexed player, uint encounterId);
788   event LootClaimed(address indexed player, uint encounterId);
789   event DailyLootClaimed(uint day);
790 
791   struct ParticipantData {
792     uint32 damage;
793     uint64 cumulativeDamage;
794     uint8 forgeWeaponRarity;
795     uint8 forgeWeaponDamagePure;
796     bool lootClaimed;
797     bool consolationPrizeClaimed;
798   }
799 
800   struct Encounter {
801     mapping (address => ParticipantData) participantData;
802     address[] participants;
803   }
804 
805   //encounterId is the starting block number / encounterBlockDuration
806   mapping (uint => Encounter) encountersById;
807 
808   mapping (uint => address) winnerPerDay;
809   mapping (uint => mapping (address => uint)) dayToAddressToScore;
810   mapping (uint => bool) dailyLootClaimedPerDay;
811 
812    uint constant encounterBlockDuration = 80;
813    uint constant blocksInADay = 5760;
814 
815 //   uint constant encounterBlockDuration = 20;
816 //   uint constant blocksInADay = 60;    // must be a multiple of encounterBlockDuration
817 
818   uint256 gasRefundForClaimLoot = 279032000000000;
819   uint256 gasRefundForClaimConsolationPrizeLoot = 279032000000000;
820   uint256 gasRefundForClaimLootWithConsolationPrize = 279032000000000;
821 
822   uint participateFee = 0.002 ether;
823   uint participateDailyLootContribution = 0.001 ether;
824 
825   constructor() public {
826 
827     paused = false;
828 
829     ceoAddress = msg.sender;
830     cooAddress = msg.sender;
831     cfoAddress = msg.sender;
832     withdrawalAddress = msg.sender;
833   }
834   
835   function setGasRefundForClaimLoot(uint256 _gasRefundForClaimLoot) external onlyCEO {
836       gasRefundForClaimLoot = _gasRefundForClaimLoot;
837   }
838 
839   function setGasRefundForClaimConsolationPrizeLoot(uint256 _gasRefundForClaimConsolationPrizeLoot) external onlyCEO {
840       gasRefundForClaimConsolationPrizeLoot = _gasRefundForClaimConsolationPrizeLoot;
841   }
842 
843   function setGasRefundForClaimLootWithConsolationPrize(uint256 _gasRefundForClaimLootWithConsolationPrize) external onlyCEO {
844       gasRefundForClaimLootWithConsolationPrize = _gasRefundForClaimLootWithConsolationPrize;
845   }
846 
847   function setParticipateFee(uint _participateFee) public onlyCLevel {
848     participateFee = _participateFee;
849   }
850 
851   function setParticipateDailyLootContribution(uint _participateDailyLootContribution) public onlyCLevel {
852     participateDailyLootContribution = _participateDailyLootContribution;
853   }
854 
855   function getFirstEncounterIdFromDay(uint day) internal pure returns (uint) {
856     return (day * blocksInADay) / encounterBlockDuration;
857   }
858 
859   function leaderboardEntries(uint day) public view returns
860     (uint etherPot, bool dailyLootClaimed, uint blockDeadline, address[] memory entryAddresses, uint[] memory entryDamages) {    
861 
862     dailyLootClaimed = dailyLootClaimedPerDay[day];
863     blockDeadline = (((day+1) * blocksInADay) / encounterBlockDuration) * encounterBlockDuration;
864 
865     uint participantCount = 0;
866     etherPot = 0;
867 
868     for (uint encounterId = getFirstEncounterIdFromDay(day); encounterId < getFirstEncounterIdFromDay(day+1); encounterId++)
869     {
870       address[] storage participants = encountersById[encounterId].participants;
871       participantCount += participants.length;
872       etherPot += participateDailyLootContribution * participants.length;
873     }
874 
875     entryAddresses = new address[](participantCount);
876     entryDamages = new uint[](participantCount);
877 
878     participantCount = 0;
879 
880     for (encounterId = getFirstEncounterIdFromDay(day); encounterId < getFirstEncounterIdFromDay(day+1); encounterId++)
881     {
882       participants = encountersById[encounterId].participants;
883       mapping (address => ParticipantData) participantData = encountersById[encounterId].participantData;
884       for (uint i = 0; i < participants.length; i++)
885       {
886         address participant = participants[i];
887         entryAddresses[participantCount] = participant;
888         entryDamages[participantCount] = participantData[participant].damage;
889         participantCount++;
890       }
891     }
892   }
893 
894   function claimDailyLoot(uint day) public {
895     require(!dailyLootClaimedPerDay[day]);
896     require(winnerPerDay[day] == msg.sender);
897 
898     uint firstEncounterId = day * blocksInADay / encounterBlockDuration;
899     uint firstEncounterIdTomorrow = ((day+1) * blocksInADay / encounterBlockDuration);
900     uint etherPot = 0;
901     for (uint encounterId = firstEncounterId; encounterId < firstEncounterIdTomorrow; encounterId++)
902     {
903       etherPot += participateDailyLootContribution * encountersById[encounterId].participants.length;
904     }
905 
906     dailyLootClaimedPerDay[day] = true;
907 
908     msg.sender.transfer(etherPot);
909 
910     emit DailyLootClaimed(day);
911   }
912 
913   function blockBeforeEncounter(uint encounterId) private pure returns (uint) {
914     return encounterId*encounterBlockDuration - 1;
915   }
916 
917   function getEncounterDetails() public view
918     returns (uint encounterId, uint encounterFinishedBlockNumber, bool isParticipating, uint day, uint monsterDna) {
919     encounterId = block.number / encounterBlockDuration;
920     encounterFinishedBlockNumber = (encounterId+1) * encounterBlockDuration;
921     Encounter storage encounter = encountersById[encounterId];
922     isParticipating = (encounter.participantData[msg.sender].damage != 0);
923     day = (encounterId * encounterBlockDuration) / blocksInADay;
924     monsterDna = uint(blockhash(blockBeforeEncounter(encounterId)));
925   }
926 
927   function getParticipants(uint encounterId) public view returns (address[]) {
928 
929     Encounter storage encounter = encountersById[encounterId];
930     return encounter.participants;
931   }
932 
933   function calculateWinner(uint numParticipants, Encounter storage encounter, uint blockToHash) internal view returns
934     (address winnerAddress, uint rand, uint totalDamageDealt) {
935 
936     if (numParticipants == 0) {
937       return;
938     }
939 
940     totalDamageDealt = encounter.participantData[encounter.participants[numParticipants-1]].cumulativeDamage;
941 
942     rand = uint(keccak256(blockhash(blockToHash)));
943     uint winnerDamageValue = rand % totalDamageDealt;
944 
945     uint winnerIndex = numParticipants;
946 
947     // binary search for a value winnerIndex where
948     // winnerDamageValue < cumulativeDamage[winnerIndex] and 
949     // winnerDamageValue >= cumulativeDamage[winnerIndex-1]
950 
951     uint min = 0;
952     uint max = numParticipants - 1;
953     while(max >= min) {
954       uint guess = (min+max)/2;
955       if (guess > 0 && winnerDamageValue < encounter.participantData[encounter.participants[guess-1]].cumulativeDamage) {
956         max = guess-1;
957       }
958       else if (winnerDamageValue >= encounter.participantData[encounter.participants[guess]].cumulativeDamage) {
959         min = guess+1;
960       } else {
961         winnerIndex = guess;
962         break;
963       }
964 
965     }
966 
967     require(winnerIndex < numParticipants, "error in binary search");
968 
969     winnerAddress = encounter.participants[winnerIndex];
970   }
971 
972   function getBlockToHashForResults(uint encounterId) public view returns (uint) {
973       
974     uint blockToHash = (encounterId+1)*encounterBlockDuration - 1;
975     
976     require(block.number > blockToHash);
977     
978     uint diff = block.number - (blockToHash+1);
979     if (diff > 255) {
980         blockToHash += (diff/256)*256;
981     }
982     
983     return blockToHash;
984   }
985   
986   function getEncounterResults(uint encounterId, address player) public view returns (
987     address winnerAddress, uint lootTokenId, uint consolationPrizeTokenId,
988     bool lootClaimed, uint damageDealt, uint totalDamageDealt) {
989 
990     uint blockToHash = getBlockToHashForResults(encounterId);
991 
992     Encounter storage encounter = encountersById[encounterId];
993     uint numParticipants = encounter.participants.length;
994     if (numParticipants == 0) {
995       return (address(0), 0, 0, false, 0, 0);
996     }
997 
998     damageDealt = encounter.participantData[player].damage;
999 
1000     uint rand;
1001     (winnerAddress, rand, totalDamageDealt) = calculateWinner(numParticipants, encounter, blockToHash);
1002 
1003     lootTokenId = constructWeaponTokenIdForWinner(rand, numParticipants);
1004 
1005     lootClaimed = true;
1006     consolationPrizeTokenId = getConsolationPrizeTokenId(encounterId, player);
1007 
1008     if (consolationPrizeTokenId != 0) {
1009         lootClaimed = encounter.participantData[player].consolationPrizeClaimed;
1010         
1011         // This way has problems:
1012     //   lootClaimed = tokenContract.exists(consolationPrizeTokenId);
1013     }
1014   }
1015   
1016     function getLootClaimed(uint encounterId, address player) external view returns (bool, bool) {
1017         ParticipantData memory participantData = encountersById[encounterId].participantData[player];
1018         return (
1019             participantData.lootClaimed,
1020             participantData.consolationPrizeClaimed
1021         );
1022     }
1023 
1024   function constructWeaponTokenIdForWinner(uint rand, uint numParticipants) pure internal returns (uint) {
1025 
1026     uint rarity = 0;
1027     if (numParticipants > 1) rarity = 1;
1028     if (numParticipants > 10) rarity = 2;
1029 
1030     return constructWeaponTokenId(rand, rarity, 0);
1031   }
1032 
1033   function getWeaponRarityFromTokenId(uint tokenId) pure internal returns (uint) {
1034     return tokenId & 0xff;
1035   }  
1036 
1037   // damageType: 0=physical 1=magic 2=water 3=earth 4=fire
1038   function getWeaponDamageFromTokenId(uint tokenId, uint damageType) pure internal returns (uint) {
1039     return ((tokenId >> (64 + damageType*8)) & 0xff);
1040   }  
1041 
1042   function getPureWeaponDamageFromTokenId(uint tokenId) pure internal returns (uint) {
1043     return ((tokenId >> (56)) & 0xff);
1044   }  
1045 
1046   function getMonsterDefenseFromDna(uint monsterDna, uint damageType) pure internal returns (uint) {
1047     return ((monsterDna >> (64 + damageType*8)) & 0xff);
1048   }
1049 
1050 
1051   // constant lookup table
1052 
1053   bytes10 constant elementsAvailableForCommon =     hex"01020408100102040810";   // Each byte has 1 bit set
1054   bytes10 constant elementsAvailableForRare =       hex"030506090A0C11121418";   // Each byte has 2 bits set
1055   bytes10 constant elementsAvailableForEpic =       hex"070B0D0E131516191A1C";   // 3 bits
1056   bytes10 constant elementsAvailableForLegendary =  hex"0F171B1D1E0F171B1D1E";   // 4 bits
1057 
1058   // rarity 0: common (1 element)
1059   // rarity 1: rare (2 elements)
1060   // rarity 2: epic (3 elements)
1061   // rarity 3: legendary (4 elements)
1062   // rarity 4: ultimate (all 5 elements)
1063   function constructWeaponTokenId(uint rand, uint rarity, uint pureDamage) pure internal returns (uint) {
1064     uint lootTokenId = (rand & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000) + rarity;
1065 
1066     bytes10[4] memory elementsAvailablePerRarity = [
1067       elementsAvailableForCommon,
1068       elementsAvailableForRare,
1069       elementsAvailableForEpic,
1070       elementsAvailableForLegendary
1071       ];
1072 
1073     bytes10 elementsAvailable = elementsAvailablePerRarity[rarity];
1074     // Select a random byte in elementsAvailable
1075     uint8 elementsUsed = uint8(elementsAvailable[((rand >> 104) & 0xffff) % 10]);
1076     // The bits of elementsUsed represent which elements we will allow this weapon to deal damage for
1077     // Zero out the other element damages
1078     for (uint i = 0; i < 5; i++) {
1079       if ((elementsUsed & (1 << i)) == 0) {
1080         lootTokenId = lootTokenId & ~(0xff << (64 + i*8));
1081       }
1082     }
1083 
1084     pureDamage = Math.min256(100, pureDamage);
1085 
1086     lootTokenId = lootTokenId | (pureDamage << 56);
1087 
1088     return lootTokenId;
1089   }
1090 
1091   function weaponTokenIdToDamageForEncounter(uint weaponTokenId, uint encounterId) view internal returns (uint) {
1092     uint monsterDna = uint(blockhash(encounterId*encounterBlockDuration - 1));
1093 
1094     uint physicalDamage = uint(Math.smax256(0, int(getWeaponDamageFromTokenId(weaponTokenId, 0)) - int(getMonsterDefenseFromDna(monsterDna, 0))));
1095     uint fireDamage = uint(Math.smax256(0, int(getWeaponDamageFromTokenId(weaponTokenId, 4)) - int(getMonsterDefenseFromDna(monsterDna, 4))));
1096     uint earthDamage = uint(Math.smax256(0, int(getWeaponDamageFromTokenId(weaponTokenId, 3)) - int(getMonsterDefenseFromDna(monsterDna, 3))));
1097     uint waterDamage = uint(Math.smax256(0, int(getWeaponDamageFromTokenId(weaponTokenId, 2)) - int(getMonsterDefenseFromDna(monsterDna, 2))));
1098     uint magicDamage = uint(Math.smax256(0, int(getWeaponDamageFromTokenId(weaponTokenId, 1)) - int(getMonsterDefenseFromDna(monsterDna, 1))));
1099     uint pureDamage = getPureWeaponDamageFromTokenId(weaponTokenId);
1100 
1101     uint damage = physicalDamage + fireDamage + earthDamage + waterDamage + magicDamage + pureDamage;
1102     damage = Math.max256(1, damage);
1103 
1104     return damage;
1105   }
1106 
1107   function forgeWeaponPureDamage(uint sacrificeTokenId1, uint sacrificeTokenId2, uint sacrificeTokenId3, uint sacrificeTokenId4)
1108     internal pure returns (uint8) {
1109     if (sacrificeTokenId1 == 0) {
1110       return 0;
1111     }
1112     return uint8(Math.min256(255,
1113         getPureWeaponDamageFromTokenId(sacrificeTokenId1) +
1114         getPureWeaponDamageFromTokenId(sacrificeTokenId2) +
1115         getPureWeaponDamageFromTokenId(sacrificeTokenId3) +
1116         getPureWeaponDamageFromTokenId(sacrificeTokenId4)));
1117   }
1118 
1119   function forgeWeaponRarity(uint sacrificeTokenId1, uint sacrificeTokenId2, uint sacrificeTokenId3, uint sacrificeTokenId4)
1120     internal pure returns (uint8) {
1121     if (sacrificeTokenId1 == 0) {
1122       return 0;
1123     }
1124     uint rarity = getWeaponRarityFromTokenId(sacrificeTokenId1);
1125     rarity = Math.min256(rarity, getWeaponRarityFromTokenId(sacrificeTokenId2));
1126     rarity = Math.min256(rarity, getWeaponRarityFromTokenId(sacrificeTokenId3));
1127     rarity = Math.min256(rarity, getWeaponRarityFromTokenId(sacrificeTokenId4)) + 1;
1128     require(rarity < 5, "cant forge an ultimate weapon");
1129     return uint8(rarity);
1130   }
1131 
1132   function participate(uint encounterId, uint weaponTokenId,
1133     uint sacrificeTokenId1, uint sacrificeTokenId2, uint sacrificeTokenId3, uint sacrificeTokenId4) public whenNotPaused payable {
1134     require(msg.value >= participateFee);  // half goes to dev, half goes to ether pot
1135 
1136     require(encounterId == block.number / encounterBlockDuration, "a new encounter is available");
1137 
1138     Encounter storage encounter = encountersById[encounterId];
1139 
1140     require(encounter.participantData[msg.sender].damage == 0, "you are already participating");
1141 
1142     uint damage = 1;
1143     // weaponTokenId of zero means they are using their fists
1144     if (weaponTokenId != 0) {
1145       require(tokenContract.ownerOf(weaponTokenId) == msg.sender, "you dont own that weapon");
1146       damage = weaponTokenIdToDamageForEncounter(weaponTokenId, encounterId);
1147     }
1148 
1149     uint day = (encounterId * encounterBlockDuration) / blocksInADay;
1150     uint newScore = dayToAddressToScore[day][msg.sender] + damage;
1151     dayToAddressToScore[day][msg.sender] = newScore;
1152 
1153     if (newScore > dayToAddressToScore[day][winnerPerDay[day]] &&
1154       winnerPerDay[day] != msg.sender) {
1155       winnerPerDay[day] = msg.sender;
1156     }
1157 
1158     uint cumulativeDamage = damage;
1159     if (encounter.participants.length > 0) {
1160       cumulativeDamage = cumulativeDamage + encounter.participantData[encounter.participants[encounter.participants.length-1]].cumulativeDamage;
1161     }
1162 
1163     if (sacrificeTokenId1 != 0) {
1164 
1165       // the requires in the transfer functions here will verify
1166       // that msg.sender owns all of these tokens and they are unique
1167 
1168       // burn all four input tokens
1169 
1170       tokenContract.transferFrom(msg.sender, 1, sacrificeTokenId1);
1171       tokenContract.transferFrom(msg.sender, 1, sacrificeTokenId2);
1172       tokenContract.transferFrom(msg.sender, 1, sacrificeTokenId3);
1173       tokenContract.transferFrom(msg.sender, 1, sacrificeTokenId4);
1174     }
1175 
1176     encounter.participantData[msg.sender] = ParticipantData(uint32(damage), uint64(cumulativeDamage), 
1177       forgeWeaponRarity(sacrificeTokenId1, sacrificeTokenId2, sacrificeTokenId3, sacrificeTokenId4),
1178       forgeWeaponPureDamage(sacrificeTokenId1, sacrificeTokenId2, sacrificeTokenId3, sacrificeTokenId4),
1179       false, false);
1180     encounter.participants.push(msg.sender);
1181 
1182     emit Participating(msg.sender, encounterId);
1183   }
1184 
1185   function claimLoot(uint encounterId, address player) public whenNotPaused {
1186     address winnerAddress;
1187     uint lootTokenId;
1188     uint consolationPrizeTokenId;
1189     (winnerAddress, lootTokenId, consolationPrizeTokenId, , ,,) = getEncounterResults(encounterId, player);
1190     require(winnerAddress == player, "player is not the winner");
1191 
1192     ParticipantData storage participantData = encountersById[encounterId].participantData[player];
1193 
1194     require(!participantData.lootClaimed, "loot already claimed");
1195 
1196     participantData.lootClaimed = true;
1197     tokenContract.mint(player, lootTokenId);
1198 
1199     // The winner also gets a consolation prize
1200     // It's possible he called claimConsolationPrizeLoot first, so allow that
1201 
1202     require(consolationPrizeTokenId != 0, "consolation prize invalid");
1203 
1204     if (!participantData.consolationPrizeClaimed) {
1205         participantData.consolationPrizeClaimed = true;
1206         // this will throw if the token already exists
1207         tokenContract.mint(player, consolationPrizeTokenId);
1208 
1209         // refund gas
1210         msg.sender.transfer(gasRefundForClaimLootWithConsolationPrize);
1211     } else {
1212         
1213         // refund gas
1214         msg.sender.transfer(gasRefundForClaimLoot);
1215     }
1216 
1217     emit LootClaimed(player, encounterId);
1218   }
1219 
1220   function getConsolationPrizeTokenId(uint encounterId, address player) internal view returns (uint) {
1221 
1222     ParticipantData memory participantData = encountersById[encounterId].participantData[player];
1223     if (participantData.damage == 0) {
1224       return 0;
1225     }
1226 
1227     uint blockToHash = getBlockToHashForResults(encounterId);
1228 
1229     uint rand = uint(keccak256(uint(blockhash(blockToHash)) ^ uint(player)));
1230 
1231     if (participantData.forgeWeaponRarity != 0) {
1232       return constructWeaponTokenId(rand, participantData.forgeWeaponRarity, participantData.forgeWeaponDamagePure);
1233     }
1234 
1235     return constructWeaponTokenId(rand, 0, 0);
1236   }
1237 
1238   function claimConsolationPrizeLoot(uint encounterId, address player) public whenNotPaused {
1239     uint lootTokenId = getConsolationPrizeTokenId(encounterId, player);
1240     require(lootTokenId != 0, "player didnt participate");
1241 
1242     ParticipantData storage participantData = encountersById[encounterId].participantData[player];
1243     require(!participantData.consolationPrizeClaimed, "consolation prize already claimed");
1244 
1245     participantData.consolationPrizeClaimed = true;
1246     tokenContract.mint(player, lootTokenId);
1247 
1248     msg.sender.transfer(gasRefundForClaimConsolationPrizeLoot);
1249 
1250     emit LootClaimed(player, encounterId);
1251   }
1252 
1253   function balanceOf(address _owner) public view returns (uint256) {
1254     return tokenContract.balanceOf(_owner);
1255   }
1256 
1257   function tokensOf(address _owner) public view returns (uint256[]) {
1258     return tokenContract.tokensOf(_owner);
1259   }
1260 
1261   function tokenOfOwnerByIndex(address _owner, uint256 _index)
1262     external
1263     view
1264     returns (uint256 _tokenId)
1265   {
1266     return tokenContract.tokenOfOwnerByIndex(_owner, _index);
1267   }
1268 }