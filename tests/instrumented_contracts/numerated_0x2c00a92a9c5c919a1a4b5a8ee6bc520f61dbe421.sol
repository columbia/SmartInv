1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: contracts/ERC721/ERC721Basic.sol
31 
32 /**
33  * @title ERC721 Non-Fungible Token Standard basic interface
34  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
35  */
36 contract ERC721Basic {
37   // bytes4(keccak256('balanceOf(address)')) ^
38   // bytes4(keccak256('ownerOf(uint256)')) ^
39   // bytes4(keccak256('approve(address,uint256)')) ^
40   // bytes4(keccak256('getApproved(uint256)')) ^
41   // bytes4(keccak256('setApprovalForAll(address,bool)')) ^
42   // bytes4(keccak256('isApprovedForAll(address,address)')) ^
43   // bytes4(keccak256('transferFrom(address,address,uint256)')) ^
44   // bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
45   // bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
46   bytes4 constant INTERFACE_ERC721 = 0x80ac58cd;
47 
48   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
49   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
50   event ApprovalForAll(address indexed _owner, address indexed _operator, bool indexed _approved);
51 
52   function balanceOf(address _owner) public view returns (uint256 _balance);
53   function ownerOf(uint256 _tokenId) public view returns (address _owner);
54 
55   // Note: This is not in the official ERC-721 standard so it's not included in the interface hash
56   function exists(uint256 _tokenId) public view returns (bool _exists);
57 
58   function approve(address _to, uint256 _tokenId) public;
59   function getApproved(uint256 _tokenId) public view returns (address _operator);
60 
61   function setApprovalForAll(address _operator, bool _approved) public;
62   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
63 
64   function transferFrom(
65     address _from,
66     address _to,
67     uint256 _tokenId) public;
68 
69   function safeTransferFrom(
70     address _from,
71     address _to,
72     uint256 _tokenId) public;
73 
74   function safeTransferFrom(
75     address _from,
76     address _to,
77     uint256 _tokenId,
78     bytes _data) public;
79 }
80 
81 // File: contracts/ERC721/ERC721.sol
82 
83 /**
84  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
85  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
86  */
87 contract ERC721Enumerable is ERC721Basic {
88   // bytes4(keccak256('totalSupply()')) ^
89   // bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
90   // bytes4(keccak256('tokenByIndex(uint256)'));
91   bytes4 constant INTERFACE_ERC721_ENUMERABLE = 0x780e9d63;
92 
93   function totalSupply() public view returns (uint256);
94   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
95   function tokenByIndex(uint256 _index) public view returns (uint256);
96 }
97 
98 
99 /**
100  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
101  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
102  */
103 contract ERC721Metadata is ERC721Basic {
104   // bytes4(keccak256('name()')) ^
105   // bytes4(keccak256('symbol()')) ^
106   // bytes4(keccak256('tokenURI(uint256)'));
107   bytes4 constant INTERFACE_ERC721_METADATA = 0x5b5e139f;
108 
109   function name() public view returns (string _name);
110   function symbol() public view returns (string _symbol);
111   function tokenURI(uint256 _tokenId) public view returns (string);
112 }
113 
114 
115 /**
116  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
117  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
118  */
119 /* solium-disable-next-line no-empty-blocks */
120 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
121 }
122 
123 // File: contracts/ERC165/ERC165.sol
124 
125 /**
126  * @dev A standard for detecting smart contract interfaces.
127  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
128  */
129 contract ERC165 {
130 
131   // bytes4(keccak256('supportsInterface(bytes4)'));
132   bytes4 constant INTERFACE_ERC165 = 0x01ffc9a7;
133 
134   /**
135    * @dev Checks if the smart contract includes a specific interface.
136    * @param _interfaceID The interface identifier, as specified in ERC-165.
137    */
138   function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
139     return _interfaceID == INTERFACE_ERC165;
140   }
141 }
142 
143 // File: contracts/library/AddressUtils.sol
144 
145 /**
146  * @title Utility library of inline functions on addresses
147  */
148 library AddressUtils {
149 
150   /**
151    * @notice Returns whether there is code in the target address
152    * @dev This function will return false if invoked during the constructor of a contract,
153    *  as the code is not actually created until after the constructor finishes.
154    * @param addr address address to check
155    * @return whether there is code in the target address
156    */
157   function isContract(address addr) internal view returns (bool) {
158     uint256 size;
159 
160     // solium-disable-next-line security/no-inline-assembly
161     assembly { size := extcodesize(addr) }
162 
163     return size > 0;
164   }
165 }
166 
167 // File: contracts/library/SafeMath.sol
168 
169 /**
170  * @title SafeMath
171  * @dev Math operations with safety checks that throw on error
172  */
173 library SafeMath {
174 
175   /**
176   * @dev Multiplies two numbers, throws on overflow.
177   */
178   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
180     // benefit is lost if 'b' is also tested.
181     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
182     if (a == 0) {
183       return 0;
184     }
185 
186     c = a * b;
187     assert(c / a == b);
188     return c;
189   }
190 
191   /**
192   * @dev Integer division of two numbers, truncating the quotient.
193   */
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     // assert(b > 0); // Solidity automatically throws when dividing by 0
196     // uint256 c = a / b;
197     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198     return a / b;
199   }
200 
201   /**
202   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
203   */
204   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205     assert(b <= a);
206     return a - b;
207   }
208 
209   /**
210   * @dev Adds two numbers, throws on overflow.
211   */
212   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
213     c = a + b;
214     assert(c >= a);
215     return c;
216   }
217 }
218 
219 // File: contracts/ERC721/ERC721Receiver.sol
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  *  from ERC721 asset contracts.
225  */
226 contract ERC721Receiver {
227   /**
228    * @dev Magic value to be returned upon successful reception of an NFT
229    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
230    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
231    */
232   bytes4 constant ERC721_RECEIVED = 0x150b7a02;
233 
234   /**
235    * @notice Handle the receipt of an NFT
236    * @dev The ERC721 smart contract calls this function on the recipient
237    *  after a `safetransfer`. This function MAY throw to revert and reject the
238    *  transfer. Returns other than the magic value MUST result in the
239    *  transaction being reverted.
240    *  Note: the contract address is always the message sender.
241    * @param _from The sending address
242    * @param _tokenId The NFT identifier which is being transfered
243    * @param _data Additional data with no specified format
244    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
245    */
246   function onERC721Received(
247     address _operator,
248     address _from,
249     uint256 _tokenId,
250     bytes _data)
251     public
252     returns(bytes4);
253 }
254 
255 // File: contracts/ERC721/ERC721BasicToken.sol
256 
257 /**
258  * @title ERC721 Non-Fungible Token Standard basic implementation
259  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
260  */
261 contract ERC721BasicToken is ERC721Basic, ERC165 {
262   using SafeMath for uint256;
263   using AddressUtils for address;
264 
265   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
266   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
267   bytes4 constant ERC721_RECEIVED = 0x150b7a02;
268 
269   // Mapping from token ID to owner
270   mapping (uint256 => address) internal tokenOwner;
271 
272   // Mapping from token ID to approved address
273   mapping (uint256 => address) internal tokenApprovals;
274 
275   // Mapping from owner to number of owned token
276   mapping (address => uint256) internal ownedTokensCount;
277 
278   // Mapping from owner to operator approvals
279   mapping (address => mapping (address => bool)) internal operatorApprovals;
280 
281   /**
282    * @dev Guarantees msg.sender is owner of the given token
283    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
284    */
285   modifier onlyOwnerOf(uint256 _tokenId) {
286     require(ownerOf(_tokenId) == msg.sender);
287     _;
288   }
289 
290   /**
291    * @dev Checks if the smart contract includes a specific interface.
292    * @param _interfaceID The interface identifier, as specified in ERC-165.
293    */
294   function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
295     return super.supportsInterface(_interfaceID) || _interfaceID == INTERFACE_ERC721;
296   }
297 
298   /**
299   * @dev Gets the balance of the specified address
300   * @param _owner address to query the balance of
301   * @return uint256 representing the amount owned by the passed address
302   */
303   function balanceOf(address _owner) public view returns (uint256) {
304     require(_owner != address(0));
305     return ownedTokensCount[_owner];
306   }
307 
308   /**
309    * @dev Gets the owner of the specified token ID
310    * @param _tokenId uint256 ID of the token to query the owner of
311    * @return owner address currently marked as the owner of the given token ID
312    */
313   function ownerOf(uint256 _tokenId) public view returns (address) {
314     address owner = tokenOwner[_tokenId];
315     require(owner != address(0));
316     return owner;
317   }
318 
319   /**
320    * @dev Returns whether the specified token exists
321    * @param _tokenId uint256 ID of the token to query the existance of
322    * @return whether the token exists
323    */
324   function exists(uint256 _tokenId) public view returns (bool) {
325     address owner = tokenOwner[_tokenId];
326     return owner != address(0);
327   }
328 
329   /**
330    * @dev Approves another address to transfer the given token ID
331    * @dev The zero address indicates there is no approved address.
332    * @dev There can only be one approved address per token at a given time.
333    * @dev Can only be called by the token owner or an approved operator.
334    * @param _to address to be approved for the given token ID
335    * @param _tokenId uint256 ID of the token to be approved
336    */
337   function approve(address _to, uint256 _tokenId) public {
338     address owner = ownerOf(_tokenId);
339     require(_to != owner);
340     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
341 
342     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
343       tokenApprovals[_tokenId] = _to;
344       emit Approval(owner, _to, _tokenId);
345     }
346   }
347 
348   /**
349    * @dev Gets the approved address for a token ID, or zero if no address set
350    * @param _tokenId uint256 ID of the token to query the approval of
351    * @return address currently approved for a the given token ID
352    */
353   function getApproved(uint256 _tokenId) public view returns (address) {
354     return tokenApprovals[_tokenId];
355   }
356 
357   /**
358    * @dev Sets or unsets the approval of a given operator
359    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
360    * @param _to operator address to set the approval
361    * @param _approved representing the status of the approval to be set
362    */
363   function setApprovalForAll(address _to, bool _approved) public {
364     require(_to != msg.sender);
365     operatorApprovals[msg.sender][_to] = _approved;
366     emit ApprovalForAll(msg.sender, _to, _approved);
367   }
368 
369   /**
370    * @dev Tells whether an operator is approved by a given owner
371    * @param _owner owner address which you want to query the approval of
372    * @param _operator operator address which you want to query the approval of
373    * @return bool whether the given operator is approved by the given owner
374    */
375   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
376     return operatorApprovals[_owner][_operator];
377   }
378 
379   /**
380    * @dev Transfers the ownership of a given token ID to another address
381    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
382    * @dev Requires the msg sender to be the owner, approved, or operator
383    * @param _from current owner of the token
384    * @param _to address to receive the ownership of the given token ID
385    * @param _tokenId uint256 ID of the token to be transferred
386    */
387   function transferFrom(
388     address _from,
389     address _to,
390     uint256 _tokenId
391   )
392     public
393   {
394     internalTransferFrom(
395       _from,
396       _to,
397       _tokenId);
398   }
399 
400   /**
401    * @dev Safely transfers the ownership of a given token ID to another address
402    * @dev If the target address is a contract, it must implement `onERC721Received`,
403    *  which is called upon a safe transfer, and return the magic value
404    *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
405    *  the transfer is reverted.
406    * @dev Requires the msg sender to be the owner, approved, or operator
407    * @param _from current owner of the token
408    * @param _to address to receive the ownership of the given token ID
409    * @param _tokenId uint256 ID of the token to be transferred
410    */
411   function safeTransferFrom(
412     address _from,
413     address _to,
414     uint256 _tokenId
415   )
416     public
417   {
418     internalSafeTransferFrom(
419       _from,
420       _to,
421       _tokenId,
422       "");
423   }
424 
425   /**
426    * @dev Safely transfers the ownership of a given token ID to another address
427    * @dev If the target address is a contract, it must implement `onERC721Received`,
428    *  which is called upon a safe transfer, and return the magic value
429    *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
430    *  the transfer is reverted.
431    * @dev Requires the msg sender to be the owner, approved, or operator
432    * @param _from current owner of the token
433    * @param _to address to receive the ownership of the given token ID
434    * @param _tokenId uint256 ID of the token to be transferred
435    * @param _data bytes data to send along with a safe transfer check
436    */
437   function safeTransferFrom(
438     address _from,
439     address _to,
440     uint256 _tokenId,
441     bytes _data
442   )
443     public
444   {
445     internalSafeTransferFrom(
446       _from,
447       _to,
448       _tokenId,
449       _data);
450   }
451 
452   function internalTransferFrom(
453     address _from,
454     address _to,
455     uint256 _tokenId
456   )
457     internal
458   {
459     address owner = ownerOf(_tokenId);
460     require(_from == owner);
461     require(_to != address(0));
462 
463     address sender = msg.sender;
464 
465     require(
466       sender == owner || isApprovedForAll(owner, sender) || getApproved(_tokenId) == sender,
467       "Not authorized to transfer"
468     );
469 
470     // Resetting the approved address if it's set
471     if (tokenApprovals[_tokenId] != address(0)) {
472       tokenApprovals[_tokenId] = address(0);
473     }
474 
475     tokenOwner[_tokenId] = _to;
476     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
477     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
478 
479     emit Transfer(_from, _to, _tokenId);
480   }
481 
482   function internalSafeTransferFrom(
483     address _from,
484     address _to,
485     uint256 _tokenId,
486     bytes _data
487   )
488     internal
489   {
490     internalTransferFrom(_from, _to, _tokenId);
491 
492     require(
493       checkAndCallSafeTransfer(
494         _from,
495         _to,
496         _tokenId,
497         _data)
498     );
499   }
500 
501   /**
502    * @dev Internal function to invoke `onERC721Received` on a target address
503    * @dev The call is not executed if the target address is not a contract
504    * @param _from address representing the previous owner of the given token ID
505    * @param _to target address that will receive the tokens
506    * @param _tokenId uint256 ID of the token to be transferred
507    * @param _data bytes optional data to send along with the call
508    * @return whether the call correctly returned the expected magic value
509    */
510   function checkAndCallSafeTransfer(
511     address _from,
512     address _to,
513     uint256 _tokenId,
514     bytes _data
515   )
516     internal
517     returns (bool)
518   {
519     if (!_to.isContract()) {
520       return true;
521     }
522 
523     bytes4 retval = ERC721Receiver(_to)
524       .onERC721Received(
525         msg.sender,
526         _from,
527         _tokenId,
528         _data
529       );
530 
531     return (retval == ERC721_RECEIVED);
532   }
533 }
534 
535 // File: contracts/ERC721/ERC721Token.sol
536 
537 /**
538  * @title Full ERC721 Token
539  * This implementation includes all the required and some optional functionality of the ERC721 standard
540  * Moreover, it includes approve all functionality using operator terminology
541  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
542  */
543 contract ERC721Token is ERC721, ERC721BasicToken {
544   // Token name
545   string internal name_;
546 
547   // Token symbol
548   string internal symbol_;
549 
550   // Mapping from owner to list of owned token IDs
551   mapping (address => uint256[]) internal ownedTokens;
552 
553   // Mapping from token ID to index of the owner tokens list
554   mapping(uint256 => uint256) internal ownedTokensIndex;
555 
556   // Array with all token ids, used for enumeration
557   uint256[] internal allTokens;
558 
559   // Optional mapping for token URIs
560   mapping(uint256 => string) internal tokenURIs;
561 
562   /**
563   * @dev Constructor function
564   */
565   constructor(string _name, string _symbol) public {
566     name_ = _name;
567     symbol_ = _symbol;
568   }
569 
570   /**
571     * @dev Checks if the smart contract includes a specific interface.
572     * @param _interfaceID The interface identifier, as specified in ERC-165.
573     */
574   function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
575     return super.supportsInterface(_interfaceID) || _interfaceID == INTERFACE_ERC721_ENUMERABLE || _interfaceID == INTERFACE_ERC721_METADATA;
576   }
577 
578   /**
579    * @dev Gets the token name
580    * @return string representing the token name
581    */
582   function name() public view returns (string) {
583     return name_;
584   }
585 
586   /**
587    * @dev Gets the token symbol
588    * @return string representing the token symbol
589    */
590   function symbol() public view returns (string) {
591     return symbol_;
592   }
593 
594   /**
595    * @dev Returns an URI for a given token ID
596    * @dev Throws if the token ID does not exist. May return an empty string.
597    * @param _tokenId uint256 ID of the token to query
598    */
599   function tokenURI(uint256 _tokenId) public view returns (string) {
600     require(exists(_tokenId));
601     return tokenURIs[_tokenId];
602   }
603 
604   /**
605    * @dev Gets the token ID at a given index of the tokens list of the requested owner
606    * @param _owner address owning the tokens list to be accessed
607    * @param _index uint256 representing the index to be accessed of the requested tokens list
608    * @return uint256 token ID at the given index of the tokens list owned by the requested address
609    */
610   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
611     require(_index < balanceOf(_owner));
612     return ownedTokens[_owner][_index];
613   }
614 
615   /**
616    * @dev Gets the total amount of tokens stored by the contract
617    * @return uint256 representing the total amount of tokens
618    */
619   function totalSupply() public view returns (uint256) {
620     return allTokens.length;
621   }
622 
623   /**
624    * @dev Gets the token ID at a given index of all the tokens in this contract
625    * @dev Reverts if the index is greater or equal to the total number of tokens
626    * @param _index uint256 representing the index to be accessed of the tokens list
627    * @return uint256 token ID at the given index of the tokens list
628    */
629   function tokenByIndex(uint256 _index) public view returns (uint256) {
630     require(_index < totalSupply());
631     return allTokens[_index];
632   }
633 
634   function internalTransferFrom(
635     address _from,
636     address _to,
637     uint256 _tokenId
638   )
639     internal
640   {
641     super.internalTransferFrom(_from, _to, _tokenId);
642 
643     uint256 removeTokenIndex = ownedTokensIndex[_tokenId];
644     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
645     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
646 
647     ownedTokens[_from][removeTokenIndex] = lastToken;
648     ownedTokens[_from].length--;
649     ownedTokensIndex[lastToken] = removeTokenIndex;
650 
651     ownedTokens[_to].push(_tokenId);
652     ownedTokensIndex[_tokenId] = ownedTokens[_to].length - 1;
653   }
654 
655   /**
656    * @dev Internal function to set the token URI for a given token
657    * @dev Reverts if the token ID does not exist
658    * @param _tokenId uint256 ID of the token to set its URI
659    * @param _uri string URI to assign
660    */
661   function _setTokenURI(uint256 _tokenId, string _uri) internal {
662     require(exists(_tokenId));
663     tokenURIs[_tokenId] = _uri;
664   }
665 }
666 
667 // File: contracts/CodexRecordMetadata.sol
668 
669 /**
670  * @title CodexRecordMetadata
671  * @dev Storage, mutators, and modifiers for CodexRecord metadata.
672  */
673 contract CodexRecordMetadata is ERC721Token {
674   struct CodexRecordData {
675     bytes32 nameHash;
676     bytes32 descriptionHash;
677     bytes32[] fileHashes;
678   }
679 
680   event Modified(
681     address indexed _from,
682     uint256 _tokenId,
683     bytes32 _newNameHash,
684     bytes32 _newDescriptionHash,
685     bytes32[] _newFileHashes,
686     bytes _data
687   );
688 
689   // Mapping from token ID to token data
690   mapping(uint256 => CodexRecordData) internal tokenData;
691 
692   // Global tokenURIPrefix prefix. The token ID will be appended to the uri when accessed
693   //  via the tokenURI method
694   string public tokenURIPrefix;
695 
696   /**
697    * @dev Updates token metadata hashes to whatever is passed in
698    * @param _tokenId uint256 The token ID
699    * @param _newNameHash bytes32 The new sha3 hash of the name
700    * @param _newDescriptionHash bytes32 The new sha3 hash of the description
701    * @param _newFileHashes bytes32[] The new sha3 hashes of the files associated with the token
702    * @param _data (optional) bytes Additional data that will be emitted with the Modified event
703    */
704   function modifyMetadataHashes(
705     uint256 _tokenId,
706     bytes32 _newNameHash,
707     bytes32 _newDescriptionHash,
708     bytes32[] _newFileHashes,
709     bytes _data
710   )
711     public
712     onlyOwnerOf(_tokenId)
713   {
714     // nameHash is only overridden if it's not a blank string, since name is a
715     //  required value. Emptiness is determined if the first element is the null-byte
716     if (!bytes32IsEmpty(_newNameHash)) {
717       tokenData[_tokenId].nameHash = _newNameHash;
718     }
719 
720     // descriptionHash can always be overridden since it's an optional value
721     //  (e.g. you can "remove" a description by setting it to a blank string)
722     tokenData[_tokenId].descriptionHash = _newDescriptionHash;
723 
724     // fileHashes is only overridden if it has one or more value, since at
725     //  least one file (i.e. mainImage) is required
726     bool containsNullHash = false;
727     for (uint i = 0; i < _newFileHashes.length; i++) {
728       if (bytes32IsEmpty(_newFileHashes[i])) {
729         containsNullHash = true;
730         break;
731       }
732     }
733     if (_newFileHashes.length > 0 && !containsNullHash) {
734       tokenData[_tokenId].fileHashes = _newFileHashes;
735     }
736 
737     emit Modified(
738       msg.sender,
739       _tokenId,
740       tokenData[_tokenId].nameHash,
741       tokenData[_tokenId].descriptionHash,
742       tokenData[_tokenId].fileHashes,
743       _data
744     );
745   }
746 
747   /**
748    * @dev Gets the token given a token ID.
749    * @param _tokenId token ID
750    * @return CodexRecordData token data for the given token ID
751    */
752   function getTokenById(
753     uint256 _tokenId
754   )
755     public
756     view
757     returns (bytes32 nameHash, bytes32 descriptionHash, bytes32[] fileHashes)
758   {
759     return (
760       tokenData[_tokenId].nameHash,
761       tokenData[_tokenId].descriptionHash,
762       tokenData[_tokenId].fileHashes
763     );
764   }
765 
766   /**
767    * @dev Returns an URI for a given token ID
768    * @dev Throws if the token ID does not exist.
769    *
770    * @dev To save on gas, we will host a standard metadata endpoint for each token.
771    *  For Collector privacy, specific token metadata is stored off chain, which means
772    *  the metadata returned by this endpoint cannot include specific details about
773    *  the physical asset the token represents unless the Collector has made it public.
774    *
775    * @dev This metadata will be a JSON blob that includes:
776    *  name - Codex Record
777    *  description - Information about the Provider that is hosting the off-chain metadata
778    *  imageUri - A generic Codex Record image
779    *
780    * @param _tokenId uint256 ID of the token to query
781    */
782   function tokenURI(
783     uint256 _tokenId
784   )
785     public
786     view
787     returns (string)
788   {
789     bytes memory prefix = bytes(tokenURIPrefix);
790     if (prefix.length == 0) {
791       return "";
792     }
793 
794     // Rather than store a string representation of _tokenId, we just convert it on the fly
795     // since this is just a 'view' function (i.e., there's no gas cost if called off chain)
796     bytes memory tokenId = uint2bytes(_tokenId);
797     bytes memory output = new bytes(prefix.length + tokenId.length);
798 
799     // Index counters
800     uint256 i;
801     uint256 outputIndex = 0;
802 
803     // Copy over the prefix into the new bytes array
804     for (i = 0; i < prefix.length; i++) {
805       output[outputIndex++] = prefix[i];
806     }
807 
808     // Copy over the tokenId into the new bytes array
809     for (i = 0; i < tokenId.length; i++) {
810       output[outputIndex++] = tokenId[i];
811     }
812 
813     return string(output);
814   }
815 
816   /**
817    * @dev Based on MIT licensed code @ https://github.com/oraclize/ethereum-api
818    * @dev Converts an incoming uint256 to a dynamic byte array
819    */
820   function uint2bytes(uint256 i) internal pure returns (bytes) {
821     if (i == 0) {
822       return "0";
823     }
824 
825     uint256 j = i;
826     uint256 length;
827     while (j != 0) {
828       length++;
829       j /= 10;
830     }
831 
832     bytes memory bstr = new bytes(length);
833     uint256 k = length - 1;
834     j = i;
835     while (j != 0) {
836       bstr[k--] = byte(48 + j % 10);
837       j /= 10;
838     }
839 
840     return bstr;
841   }
842 
843   /**
844    * @dev Returns whether or not a bytes32 array is empty (all null-bytes)
845    * @param _data bytes32 The array to check
846    * @return bool Whether or not the array is empty
847    */
848   function bytes32IsEmpty(bytes32 _data) internal pure returns (bool) {
849     for (uint256 i = 0; i < 32; i++) {
850       if (_data[i] != 0x0) {
851         return false;
852       }
853     }
854 
855     return true;
856   }
857 }
858 
859 // File: contracts/ERC900/ERC900.sol
860 
861 /**
862  * @title ERC900 Simple Staking Interface
863  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
864  */
865 contract ERC900 {
866   event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
867   event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
868 
869   function stake(uint256 amount, bytes data) public;
870   function stakeFor(address user, uint256 amount, bytes data) public;
871   function unstake(uint256 amount, bytes data) public;
872   function totalStakedFor(address addr) public view returns (uint256);
873   function totalStaked() public view returns (uint256);
874   function token() public view returns (address);
875   function supportsHistory() public pure returns (bool);
876 
877   // NOTE: Not implementing the optional functions
878   // function lastStakedFor(address addr) public view returns (uint256);
879   // function totalStakedForAt(address addr, uint256 blockNumber) public view returns (uint256);
880   // function totalStakedAt(uint256 blockNumber) public view returns (uint256);
881 }
882 
883 // File: contracts/CodexStakeContractInterface.sol
884 
885 contract CodexStakeContractInterface is ERC900 {
886 
887   function stakeForDuration(
888     address user,
889     uint256 amount,
890     uint256 lockInDuration,
891     bytes data)
892     public;
893 
894   function spendCredits(
895     address user,
896     uint256 amount)
897     public;
898 
899   function creditBalanceOf(
900     address user)
901     public
902     view
903     returns (uint256);
904 }
905 
906 // File: contracts/library/DelayedOwnable.sol
907 
908 /**
909  * @title DelayedOwnable
910  * @dev The DelayedOwnable contract has an owner address, and provides basic authorization control
911  *  functions, this simplifies the implementation of "user permissions".
912  * @dev This is different than the original Ownable contract because intializeOwnable
913  *  must be specifically called after creation to create an owner.
914  */
915 contract DelayedOwnable {
916   address public owner;
917   bool public isInitialized = false;
918 
919   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
920 
921   /**
922    * @dev Throws if called by any account other than the owner.
923    */
924   modifier onlyOwner() {
925     require(msg.sender == owner);
926     _;
927   }
928 
929   function initializeOwnable(address _owner) external {
930     require(
931       !isInitialized,
932       "The owner has already been set");
933 
934     isInitialized = true;
935     owner = _owner;
936   }
937 
938   /**
939    * @dev Allows the current owner to transfer control of the contract to a newOwner.
940    * @param _newOwner The address to transfer ownership to.
941    */
942   function transferOwnership(address _newOwner) public onlyOwner {
943     require(_newOwner != address(0));
944 
945     emit OwnershipTransferred(owner, _newOwner);
946 
947     owner = _newOwner;
948   }
949 }
950 
951 // File: contracts/library/DelayedPausable.sol
952 
953 /**
954  * @title Pausable
955  * @dev Base contract which allows children to implement an emergency stop mechanism.
956  */
957 contract DelayedPausable is DelayedOwnable {
958   event Pause();
959   event Unpause();
960 
961   bool public paused = false;
962 
963 
964   /**
965    * @dev Modifier to make a function callable only when the contract is not paused.
966    */
967   modifier whenNotPaused() {
968     require(!paused);
969     _;
970   }
971 
972   /**
973    * @dev Modifier to make a function callable only when the contract is paused.
974    */
975   modifier whenPaused() {
976     require(paused);
977     _;
978   }
979 
980   /**
981    * @dev called by the owner to pause, triggers stopped state
982    */
983   function pause() onlyOwner whenNotPaused public {
984     paused = true;
985     emit Pause();
986   }
987 
988   /**
989    * @dev called by the owner to unpause, returns to normal state
990    */
991   function unpause() onlyOwner whenPaused public {
992     paused = false;
993     emit Unpause();
994   }
995 }
996 
997 // File: contracts/CodexRecordFees.sol
998 
999 /**
1000  * @title CodexRecordFees
1001  * @dev Storage, mutators, and modifiers for fees when using the token.
1002  *  This also includes the DelayedPausable contract for the onlyOwner modifier.
1003  */
1004 contract CodexRecordFees is CodexRecordMetadata, DelayedPausable {
1005 
1006   // Implementation of the ERC20 Codex Protocol Token, used for fees in the contract
1007   ERC20 public codexCoin;
1008 
1009   // Implementation of the ERC900 Codex Protocol Stake Container,
1010   //  used to calculate discounts on fees
1011   CodexStakeContractInterface public codexStakeContract;
1012 
1013   // Address where all contract fees are sent, i.e., the Community Fund
1014   address public feeRecipient;
1015 
1016   // Fee to create new tokens. 10^18 = 1 token
1017   uint256 public creationFee = 0;
1018 
1019   // Fee to transfer tokens. 10^18 = 1 token
1020   uint256 public transferFee = 0;
1021 
1022   // Fee to modify tokens. 10^18 = 1 token
1023   uint256 public modificationFee = 0;
1024 
1025   modifier canPayFees(uint256 _baseFee) {
1026     if (feeRecipient != address(0) && _baseFee > 0) {
1027       bool feePaid = false;
1028 
1029       if (codexStakeContract != address(0)) {
1030         uint256 discountCredits = codexStakeContract.creditBalanceOf(msg.sender);
1031 
1032         // Regardless of what the baseFee is, all transactions can be paid by using exactly one credit
1033         if (discountCredits > 0) {
1034           codexStakeContract.spendCredits(msg.sender, 1);
1035           feePaid = true;
1036         }
1037       }
1038 
1039       if (!feePaid) {
1040         require(
1041           codexCoin.transferFrom(msg.sender, feeRecipient, _baseFee),
1042           "Insufficient funds");
1043       }
1044     }
1045 
1046     _;
1047   }
1048 
1049   /**
1050    * @dev Sets the address of the ERC20 token used for fees in the contract.
1051    *  Fees are in the smallest denomination, e.g., 10^18 is 1 token.
1052    * @param _codexCoin ERC20 The address of the ERC20 Codex Protocol Token
1053    * @param _feeRecipient address The address where the fees are sent
1054    * @param _creationFee uint256 The new creation fee.
1055    * @param _transferFee uint256 The new transfer fee.
1056    * @param _modificationFee uint256 The new modification fee.
1057    */
1058   function setFees(
1059     ERC20 _codexCoin,
1060     address _feeRecipient,
1061     uint256 _creationFee,
1062     uint256 _transferFee,
1063     uint256 _modificationFee
1064   )
1065     external
1066     onlyOwner
1067   {
1068     codexCoin = _codexCoin;
1069     feeRecipient = _feeRecipient;
1070     creationFee = _creationFee;
1071     transferFee = _transferFee;
1072     modificationFee = _modificationFee;
1073   }
1074 
1075   function setStakeContract(CodexStakeContractInterface _codexStakeContract) external onlyOwner {
1076     codexStakeContract = _codexStakeContract;
1077   }
1078 }
1079 
1080 // File: contracts/CodexRecordCore.sol
1081 
1082 /**
1083  * @title CodexRecordCore
1084  * @dev Core functionality of the token, namely minting.
1085  */
1086 contract CodexRecordCore is CodexRecordFees {
1087 
1088   /**
1089    * @dev This event is emitted when a new token is minted and allows providers
1090    *  to discern which Minted events came from transactions they submitted vs
1091    *  transactions submitted by other platforms, as well as providing information
1092    *  about what metadata record the newly minted token should be associated with.
1093    */
1094   event Minted(uint256 _tokenId, bytes _data);
1095 
1096   /**
1097    * @dev Sets the global tokenURIPrefix for use when returning token metadata.
1098    *  Only callable by the owner.
1099    * @param _tokenURIPrefix string The new tokenURIPrefix
1100    */
1101   function setTokenURIPrefix(string _tokenURIPrefix) external onlyOwner {
1102     tokenURIPrefix = _tokenURIPrefix;
1103   }
1104 
1105   /**
1106    * @dev Creates a new token
1107    * @param _to address The address the token will get transferred to after minting
1108    * @param _nameHash bytes32 The sha3 hash of the name
1109    * @param _descriptionHash bytes32 The sha3 hash of the description
1110    * @param _data (optional) bytes Additional data that will be emitted with the Minted event
1111    */
1112   function mint(
1113     address _to,
1114     bytes32 _nameHash,
1115     bytes32 _descriptionHash,
1116     bytes32[] _fileHashes,
1117     bytes _data
1118   )
1119     public
1120   {
1121     // All new tokens will be the last entry in the array
1122     uint256 newTokenId = allTokens.length;
1123     internalMint(_to, newTokenId);
1124 
1125     // Add metadata to the newly created token
1126     tokenData[newTokenId] = CodexRecordData({
1127       nameHash: _nameHash,
1128       descriptionHash: _descriptionHash,
1129       fileHashes: _fileHashes
1130     });
1131 
1132     emit Minted(newTokenId, _data);
1133   }
1134 
1135   function internalMint(address _to, uint256 _tokenId) internal {
1136     require(_to != address(0));
1137 
1138     tokenOwner[_tokenId] = _to;
1139     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1140 
1141     ownedTokensIndex[_tokenId] = ownedTokens[_to].length;
1142     ownedTokens[_to].push(_tokenId);
1143 
1144     allTokens.push(_tokenId);
1145 
1146     emit Transfer(address(0), _to, _tokenId);
1147   }
1148 }
1149 
1150 // File: contracts/CodexRecordAccess.sol
1151 
1152 /**
1153  * @title CodexRecordAccess
1154  * @dev Override contract functions
1155  */
1156 contract CodexRecordAccess is CodexRecordCore {
1157 
1158   /**
1159    * @dev Make mint() pausable
1160    */
1161   function mint(
1162     address _to,
1163     bytes32 _nameHash,
1164     bytes32 _descriptionHash,
1165     bytes32[] _fileHashes,
1166     bytes _data
1167   )
1168     public
1169     whenNotPaused
1170     canPayFees(creationFee)
1171   {
1172     return super.mint(
1173       _to,
1174       _nameHash,
1175       _descriptionHash,
1176       _fileHashes,
1177       _data);
1178   }
1179 
1180   /**
1181    * @dev Make trasferFrom() pausable
1182    */
1183   function transferFrom(
1184     address _from,
1185     address _to,
1186     uint256 _tokenId
1187   )
1188     public
1189     whenNotPaused
1190     canPayFees(transferFee)
1191   {
1192     return super.transferFrom(
1193       _from,
1194       _to,
1195       _tokenId);
1196   }
1197 
1198   /**
1199    * @dev Make safeTrasferFrom() pausable
1200    */
1201   function safeTransferFrom(
1202     address _from,
1203     address _to,
1204     uint256 _tokenId
1205   )
1206     public
1207     whenNotPaused
1208     canPayFees(transferFee)
1209   {
1210     return super.safeTransferFrom(
1211       _from,
1212       _to,
1213       _tokenId);
1214   }
1215 
1216   /**
1217    * @dev Make safeTrasferFrom() pausable
1218    */
1219   function safeTransferFrom(
1220     address _from,
1221     address _to,
1222     uint256 _tokenId,
1223     bytes _data
1224   )
1225     public
1226     whenNotPaused
1227     canPayFees(transferFee)
1228   {
1229     return super.safeTransferFrom(
1230       _from,
1231       _to,
1232       _tokenId,
1233       _data
1234     );
1235   }
1236 
1237   /**
1238    * @dev Make modifyMetadataHashes() pausable
1239    */
1240   function modifyMetadataHashes(
1241     uint256 _tokenId,
1242     bytes32 _newNameHash,
1243     bytes32 _newDescriptionHash,
1244     bytes32[] _newFileHashes,
1245     bytes _data
1246   )
1247     public
1248     whenNotPaused
1249     canPayFees(modificationFee)
1250   {
1251     return super.modifyMetadataHashes(
1252       _tokenId,
1253       _newNameHash,
1254       _newDescriptionHash,
1255       _newFileHashes,
1256       _data);
1257   }
1258 }
1259 
1260 // File: contracts/CodexRecord.sol
1261 
1262 /**
1263  * @title CodexRecord, an ERC721 token for arts & collectables
1264  * @dev Developers should never interact with this smart contract directly!
1265  *  All transactions/calls should be made through CodexRecordProxy. Storage will be maintained
1266  *  in that smart contract so that the governing body has the ability
1267  *  to upgrade the contract in the future in the event of an emergency or new functionality.
1268  */
1269 contract CodexRecord is CodexRecordAccess {
1270   /**
1271    * @dev Constructor function
1272    */
1273   constructor() public ERC721Token("Codex Record", "CR") { }
1274 
1275   /**
1276    * @dev Reclaim all ERC20Basic compatible tokens
1277    * @param token ERC20Basic The address of the token contract
1278    */
1279   function reclaimToken(ERC20Basic token) external onlyOwner {
1280     uint256 balance = token.balanceOf(this);
1281     token.transfer(owner, balance);
1282   }
1283 }