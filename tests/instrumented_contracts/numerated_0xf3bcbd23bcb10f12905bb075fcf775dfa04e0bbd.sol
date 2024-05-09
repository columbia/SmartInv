1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 9, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Thursday, March 14, 2019
7  (UTC) */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title ERC165
13  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
14  */
15 interface ERC165 {
16 
17   /**
18    * @notice Query if a contract implements an interface
19    * @param _interfaceId The interface identifier, as specified in ERC-165
20    * @dev Interface identification is specified in ERC-165. This function
21    * uses less than 30,000 gas.
22    */
23   function supportsInterface(bytes4 _interfaceId)
24     external
25     view
26     returns (bool);
27 }
28 
29 /**
30  * @title ERC721 Non-Fungible Token Standard basic interface
31  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
32  */
33 contract ERC721Basic is ERC165 {
34 
35   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
36   /*
37    * 0x80ac58cd ===
38    *   bytes4(keccak256('balanceOf(address)')) ^
39    *   bytes4(keccak256('ownerOf(uint256)')) ^
40    *   bytes4(keccak256('approve(address,uint256)')) ^
41    *   bytes4(keccak256('getApproved(uint256)')) ^
42    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
43    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
44    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
45    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
46    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
47    */
48 
49   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
50   /*
51    * 0x4f558e79 ===
52    *   bytes4(keccak256('exists(uint256)'))
53    */
54 
55   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
56   /**
57    * 0x780e9d63 ===
58    *   bytes4(keccak256('totalSupply()')) ^
59    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
60    *   bytes4(keccak256('tokenByIndex(uint256)'))
61    */
62 
63   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
64   /**
65    * 0x5b5e139f ===
66    *   bytes4(keccak256('name()')) ^
67    *   bytes4(keccak256('symbol()')) ^
68    *   bytes4(keccak256('tokenURI(uint256)'))
69    */
70 
71   event Transfer(
72     address indexed _from,
73     address indexed _to,
74     uint256 indexed _tokenId
75   );
76   event Approval(
77     address indexed _owner,
78     address indexed _approved,
79     uint256 indexed _tokenId
80   );
81   event ApprovalForAll(
82     address indexed _owner,
83     address indexed _operator,
84     bool _approved
85   );
86 
87   function balanceOf(address _owner) public view returns (uint256 _balance);
88   function ownerOf(uint256 _tokenId) public view returns (address _owner);
89   function exists(uint256 _tokenId) public view returns (bool _exists);
90 
91   function approve(address _to, uint256 _tokenId) public;
92   function getApproved(uint256 _tokenId)
93     public view returns (address _operator);
94 
95   function setApprovalForAll(address _operator, bool _approved) public;
96   function isApprovedForAll(address _owner, address _operator)
97     public view returns (bool);
98 
99   function transferFrom(address _from, address _to, uint256 _tokenId) public;
100   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
101     public;
102 
103   function safeTransferFrom(
104     address _from,
105     address _to,
106     uint256 _tokenId,
107     bytes _data
108   )
109     public;
110 }
111 
112 /**
113  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
114  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
115  */
116 contract ERC721Enumerable is ERC721Basic {
117   function totalSupply() public view returns (uint256);
118   function tokenOfOwnerByIndex(
119     address _owner,
120     uint256 _index
121   )
122     public
123     view
124     returns (uint256 _tokenId);
125 
126   function tokenByIndex(uint256 _index) public view returns (uint256);
127 }
128 
129 
130 /**
131  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
132  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
133  */
134 contract ERC721Metadata is ERC721Basic {
135   function name() external view returns (string _name);
136   function symbol() external view returns (string _symbol);
137   function tokenURI(uint256 _tokenId) public view returns (string);
138 }
139 
140 
141 /**
142  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
143  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
144  */
145 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
146 }
147 
148 /**
149  * @title ERC721 token receiver interface
150  * @dev Interface for any contract that wants to support safeTransfers
151  * from ERC721 asset contracts.
152  */
153 contract ERC721Receiver {
154   /**
155    * @dev Magic value to be returned upon successful reception of an NFT
156    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
157    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
158    */
159   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
160 
161   /**
162    * @notice Handle the receipt of an NFT
163    * @dev The ERC721 smart contract calls this function on the recipient
164    * after a `safetransfer`. This function MAY throw to revert and reject the
165    * transfer. Return of other than the magic value MUST result in the
166    * transaction being reverted.
167    * Note: the contract address is always the message sender.
168    * @param _operator The address which called `safeTransferFrom` function
169    * @param _from The address which previously owned the token
170    * @param _tokenId The NFT identifier which is being transferred
171    * @param _data Additional data with no specified format
172    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173    */
174   function onERC721Received(
175     address _operator,
176     address _from,
177     uint256 _tokenId,
178     bytes _data
179   )
180     public
181     returns(bytes4);
182 }
183 
184 /**
185  * @title SafeMath
186  * @dev Math operations with safety checks that throw on error
187  */
188 library SafeMath {
189 
190   /**
191   * @dev Multiplies two numbers, throws on overflow.
192   */
193   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
194     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
195     // benefit is lost if 'b' is also tested.
196     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
197     if (_a == 0) {
198       return 0;
199     }
200 
201     c = _a * _b;
202     assert(c / _a == _b);
203     return c;
204   }
205 
206   /**
207   * @dev Integer division of two numbers, truncating the quotient.
208   */
209   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
210     // assert(_b > 0); // Solidity automatically throws when dividing by 0
211     // uint256 c = _a / _b;
212     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
213     return _a / _b;
214   }
215 
216   /**
217   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
218   */
219   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
220     assert(_b <= _a);
221     return _a - _b;
222   }
223 
224   /**
225   * @dev Adds two numbers, throws on overflow.
226   */
227   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
228     c = _a + _b;
229     assert(c >= _a);
230     return c;
231   }
232 }
233 
234 /**
235  * Utility library of inline functions on addresses
236  */
237 library AddressUtils {
238 
239   /**
240    * Returns whether the target address is a contract
241    * @dev This function will return false if invoked during the constructor of a contract,
242    * as the code is not actually created until after the constructor finishes.
243    * @param _addr address to check
244    * @return whether the target address is a contract
245    */
246   function isContract(address _addr) internal view returns (bool) {
247     uint256 size;
248     // XXX Currently there is no better way to check if there is a contract in an address
249     // than to check the size of the code at that address.
250     // See https://ethereum.stackexchange.com/a/14016/36603
251     // for more details about how this works.
252     // TODO Check this again before the Serenity release, because all addresses will be
253     // contracts then.
254     // solium-disable-next-line security/no-inline-assembly
255     assembly { size := extcodesize(_addr) }
256     return size > 0;
257   }
258 
259 }
260 
261 /**
262  * @title SupportsInterfaceWithLookup
263  * @author Matt Condon (@shrugs)
264  * @dev Implements ERC165 using a lookup table.
265  */
266 contract SupportsInterfaceWithLookup is ERC165 {
267 
268   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
269   /**
270    * 0x01ffc9a7 ===
271    *   bytes4(keccak256('supportsInterface(bytes4)'))
272    */
273 
274   /**
275    * @dev a mapping of interface id to whether or not it's supported
276    */
277   mapping(bytes4 => bool) internal supportedInterfaces;
278 
279   /**
280    * @dev A contract implementing SupportsInterfaceWithLookup
281    * implement ERC165 itself
282    */
283   constructor()
284     public
285   {
286     _registerInterface(InterfaceId_ERC165);
287   }
288 
289   /**
290    * @dev implement supportsInterface(bytes4) using a lookup table
291    */
292   function supportsInterface(bytes4 _interfaceId)
293     external
294     view
295     returns (bool)
296   {
297     return supportedInterfaces[_interfaceId];
298   }
299 
300   /**
301    * @dev private method for registering an interface
302    */
303   function _registerInterface(bytes4 _interfaceId)
304     internal
305   {
306     require(_interfaceId != 0xffffffff);
307     supportedInterfaces[_interfaceId] = true;
308   }
309 }
310 
311 /**
312  * @title ERC721 Non-Fungible Token Standard basic implementation
313  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
314  */
315 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
316 
317   using SafeMath for uint256;
318   using AddressUtils for address;
319 
320   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
321   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
322   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
323 
324   // Mapping from token ID to owner
325   mapping (uint256 => address) internal tokenOwner;
326 
327   // Mapping from token ID to approved address
328   mapping (uint256 => address) internal tokenApprovals;
329 
330   // Mapping from owner to number of owned token
331   mapping (address => uint256) internal ownedTokensCount;
332 
333   // Mapping from owner to operator approvals
334   mapping (address => mapping (address => bool)) internal operatorApprovals;
335 
336   constructor()
337     public
338   {
339     // register the supported interfaces to conform to ERC721 via ERC165
340     _registerInterface(InterfaceId_ERC721);
341     _registerInterface(InterfaceId_ERC721Exists);
342   }
343 
344   /**
345    * @dev Gets the balance of the specified address
346    * @param _owner address to query the balance of
347    * @return uint256 representing the amount owned by the passed address
348    */
349   function balanceOf(address _owner) public view returns (uint256) {
350     require(_owner != address(0));
351     return ownedTokensCount[_owner];
352   }
353 
354   /**
355    * @dev Gets the owner of the specified token ID
356    * @param _tokenId uint256 ID of the token to query the owner of
357    * @return owner address currently marked as the owner of the given token ID
358    */
359   function ownerOf(uint256 _tokenId) public view returns (address) {
360     address owner = tokenOwner[_tokenId];
361     require(owner != address(0));
362     return owner;
363   }
364 
365   /**
366    * @dev Returns whether the specified token exists
367    * @param _tokenId uint256 ID of the token to query the existence of
368    * @return whether the token exists
369    */
370   function exists(uint256 _tokenId) public view returns (bool) {
371     address owner = tokenOwner[_tokenId];
372     return owner != address(0);
373   }
374 
375   /**
376    * @dev Approves another address to transfer the given token ID
377    * The zero address indicates there is no approved address.
378    * There can only be one approved address per token at a given time.
379    * Can only be called by the token owner or an approved operator.
380    * @param _to address to be approved for the given token ID
381    * @param _tokenId uint256 ID of the token to be approved
382    */
383   function approve(address _to, uint256 _tokenId) public {
384     address owner = ownerOf(_tokenId);
385     require(_to != owner);
386     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
387 
388     tokenApprovals[_tokenId] = _to;
389     emit Approval(owner, _to, _tokenId);
390   }
391 
392   /**
393    * @dev Gets the approved address for a token ID, or zero if no address set
394    * @param _tokenId uint256 ID of the token to query the approval of
395    * @return address currently approved for the given token ID
396    */
397   function getApproved(uint256 _tokenId) public view returns (address) {
398     return tokenApprovals[_tokenId];
399   }
400 
401   /**
402    * @dev Sets or unsets the approval of a given operator
403    * An operator is allowed to transfer all tokens of the sender on their behalf
404    * @param _to operator address to set the approval
405    * @param _approved representing the status of the approval to be set
406    */
407   function setApprovalForAll(address _to, bool _approved) public {
408     require(_to != msg.sender);
409     operatorApprovals[msg.sender][_to] = _approved;
410     emit ApprovalForAll(msg.sender, _to, _approved);
411   }
412 
413   /**
414    * @dev Tells whether an operator is approved by a given owner
415    * @param _owner owner address which you want to query the approval of
416    * @param _operator operator address which you want to query the approval of
417    * @return bool whether the given operator is approved by the given owner
418    */
419   function isApprovedForAll(
420     address _owner,
421     address _operator
422   )
423     public
424     view
425     returns (bool)
426   {
427     return operatorApprovals[_owner][_operator];
428   }
429 
430   /**
431    * @dev Transfers the ownership of a given token ID to another address
432    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
433    * Requires the msg sender to be the owner, approved, or operator
434    * @param _from current owner of the token
435    * @param _to address to receive the ownership of the given token ID
436    * @param _tokenId uint256 ID of the token to be transferred
437   */
438   function transferFrom(
439     address _from,
440     address _to,
441     uint256 _tokenId
442   )
443     public
444   {
445     require(isApprovedOrOwner(msg.sender, _tokenId));
446     require(_from != address(0));
447     require(_to != address(0));
448 
449     clearApproval(_from, _tokenId);
450     removeTokenFrom(_from, _tokenId);
451     addTokenTo(_to, _tokenId);
452 
453     emit Transfer(_from, _to, _tokenId);
454   }
455 
456   /**
457    * @dev Safely transfers the ownership of a given token ID to another address
458    * If the target address is a contract, it must implement `onERC721Received`,
459    * which is called upon a safe transfer, and return the magic value
460    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
461    * the transfer is reverted.
462    *
463    * Requires the msg sender to be the owner, approved, or operator
464    * @param _from current owner of the token
465    * @param _to address to receive the ownership of the given token ID
466    * @param _tokenId uint256 ID of the token to be transferred
467   */
468   function safeTransferFrom(
469     address _from,
470     address _to,
471     uint256 _tokenId
472   )
473     public
474   {
475     // solium-disable-next-line arg-overflow
476     safeTransferFrom(_from, _to, _tokenId, "");
477   }
478 
479   /**
480    * @dev Safely transfers the ownership of a given token ID to another address
481    * If the target address is a contract, it must implement `onERC721Received`,
482    * which is called upon a safe transfer, and return the magic value
483    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
484    * the transfer is reverted.
485    * Requires the msg sender to be the owner, approved, or operator
486    * @param _from current owner of the token
487    * @param _to address to receive the ownership of the given token ID
488    * @param _tokenId uint256 ID of the token to be transferred
489    * @param _data bytes data to send along with a safe transfer check
490    */
491   function safeTransferFrom(
492     address _from,
493     address _to,
494     uint256 _tokenId,
495     bytes _data
496   )
497     public
498   {
499     transferFrom(_from, _to, _tokenId);
500     // solium-disable-next-line arg-overflow
501     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
502   }
503 
504   /**
505    * @dev Returns whether the given spender can transfer a given token ID
506    * @param _spender address of the spender to query
507    * @param _tokenId uint256 ID of the token to be transferred
508    * @return bool whether the msg.sender is approved for the given token ID,
509    *  is an operator of the owner, or is the owner of the token
510    */
511   function isApprovedOrOwner(
512     address _spender,
513     uint256 _tokenId
514   )
515     internal
516     view
517     returns (bool)
518   {
519     address owner = ownerOf(_tokenId);
520     // Disable solium check because of
521     // https://github.com/duaraghav8/Solium/issues/175
522     // solium-disable-next-line operator-whitespace
523     return (
524       _spender == owner ||
525       getApproved(_tokenId) == _spender ||
526       isApprovedForAll(owner, _spender)
527     );
528   }
529 
530   /**
531    * @dev Internal function to mint a new token
532    * Reverts if the given token ID already exists
533    * @param _to The address that will own the minted token
534    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
535    */
536   function _mint(address _to, uint256 _tokenId) internal {
537     require(_to != address(0));
538     addTokenTo(_to, _tokenId);
539     emit Transfer(address(0), _to, _tokenId);
540   }
541 
542   /**
543    * @dev Internal function to burn a specific token
544    * Reverts if the token does not exist
545    * @param _tokenId uint256 ID of the token being burned by the msg.sender
546    */
547   function _burn(address _owner, uint256 _tokenId) internal {
548     clearApproval(_owner, _tokenId);
549     removeTokenFrom(_owner, _tokenId);
550     emit Transfer(_owner, address(0), _tokenId);
551   }
552 
553   /**
554    * @dev Internal function to clear current approval of a given token ID
555    * Reverts if the given address is not indeed the owner of the token
556    * @param _owner owner of the token
557    * @param _tokenId uint256 ID of the token to be transferred
558    */
559   function clearApproval(address _owner, uint256 _tokenId) internal {
560     require(ownerOf(_tokenId) == _owner);
561     if (tokenApprovals[_tokenId] != address(0)) {
562       tokenApprovals[_tokenId] = address(0);
563     }
564   }
565 
566   /**
567    * @dev Internal function to add a token ID to the list of a given address
568    * @param _to address representing the new owner of the given token ID
569    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
570    */
571   function addTokenTo(address _to, uint256 _tokenId) internal {
572     require(tokenOwner[_tokenId] == address(0));
573     tokenOwner[_tokenId] = _to;
574     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
575   }
576 
577   /**
578    * @dev Internal function to remove a token ID from the list of a given address
579    * @param _from address representing the previous owner of the given token ID
580    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
581    */
582   function removeTokenFrom(address _from, uint256 _tokenId) internal {
583     require(ownerOf(_tokenId) == _from);
584     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
585     tokenOwner[_tokenId] = address(0);
586   }
587 
588   /**
589    * @dev Internal function to invoke `onERC721Received` on a target address
590    * The call is not executed if the target address is not a contract
591    * @param _from address representing the previous owner of the given token ID
592    * @param _to target address that will receive the tokens
593    * @param _tokenId uint256 ID of the token to be transferred
594    * @param _data bytes optional data to send along with the call
595    * @return whether the call correctly returned the expected magic value
596    */
597   function checkAndCallSafeTransfer(
598     address _from,
599     address _to,
600     uint256 _tokenId,
601     bytes _data
602   )
603     internal
604     returns (bool)
605   {
606     if (!_to.isContract()) {
607       return true;
608     }
609     bytes4 retval = ERC721Receiver(_to).onERC721Received(
610       msg.sender, _from, _tokenId, _data);
611     return (retval == ERC721_RECEIVED);
612   }
613 }
614 
615 /**
616  * @title Full ERC721 Token
617  * This implementation includes all the required and some optional functionality of the ERC721 standard
618  * Moreover, it includes approve all functionality using operator terminology
619  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
620  */
621 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
622 
623   // Token name
624   string internal name_;
625 
626   // Token symbol
627   string internal symbol_;
628 
629   // Mapping from owner to list of owned token IDs
630   mapping(address => uint256[]) internal ownedTokens;
631 
632   // Mapping from token ID to index of the owner tokens list
633   mapping(uint256 => uint256) internal ownedTokensIndex;
634 
635   // Array with all token ids, used for enumeration
636   uint256[] internal allTokens;
637 
638   // Mapping from token id to position in the allTokens array
639   mapping(uint256 => uint256) internal allTokensIndex;
640 
641   // Optional mapping for token URIs
642   mapping(uint256 => string) internal tokenURIs;
643 
644   /**
645    * @dev Constructor function
646    */
647   constructor(string _name, string _symbol) public {
648     name_ = _name;
649     symbol_ = _symbol;
650 
651     // register the supported interfaces to conform to ERC721 via ERC165
652     _registerInterface(InterfaceId_ERC721Enumerable);
653     _registerInterface(InterfaceId_ERC721Metadata);
654   }
655 
656   /**
657    * @dev Gets the token name
658    * @return string representing the token name
659    */
660   function name() external view returns (string) {
661     return name_;
662   }
663 
664   /**
665    * @dev Gets the token symbol
666    * @return string representing the token symbol
667    */
668   function symbol() external view returns (string) {
669     return symbol_;
670   }
671 
672   /**
673    * @dev Returns an URI for a given token ID
674    * Throws if the token ID does not exist. May return an empty string.
675    * @param _tokenId uint256 ID of the token to query
676    */
677   function tokenURI(uint256 _tokenId) public view returns (string) {
678     require(exists(_tokenId));
679     return tokenURIs[_tokenId];
680   }
681 
682   /**
683    * @dev Gets the token ID at a given index of the tokens list of the requested owner
684    * @param _owner address owning the tokens list to be accessed
685    * @param _index uint256 representing the index to be accessed of the requested tokens list
686    * @return uint256 token ID at the given index of the tokens list owned by the requested address
687    */
688   function tokenOfOwnerByIndex(
689     address _owner,
690     uint256 _index
691   )
692     public
693     view
694     returns (uint256)
695   {
696     require(_index < balanceOf(_owner));
697     return ownedTokens[_owner][_index];
698   }
699 
700   /**
701    * @dev Gets the total amount of tokens stored by the contract
702    * @return uint256 representing the total amount of tokens
703    */
704   function totalSupply() public view returns (uint256) {
705     return allTokens.length;
706   }
707 
708   /**
709    * @dev Gets the token ID at a given index of all the tokens in this contract
710    * Reverts if the index is greater or equal to the total number of tokens
711    * @param _index uint256 representing the index to be accessed of the tokens list
712    * @return uint256 token ID at the given index of the tokens list
713    */
714   function tokenByIndex(uint256 _index) public view returns (uint256) {
715     require(_index < totalSupply());
716     return allTokens[_index];
717   }
718 
719   /**
720    * @dev Internal function to set the token URI for a given token
721    * Reverts if the token ID does not exist
722    * @param _tokenId uint256 ID of the token to set its URI
723    * @param _uri string URI to assign
724    */
725   function _setTokenURI(uint256 _tokenId, string _uri) internal {
726     require(exists(_tokenId));
727     tokenURIs[_tokenId] = _uri;
728   }
729 
730   /**
731    * @dev Internal function to add a token ID to the list of a given address
732    * @param _to address representing the new owner of the given token ID
733    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
734    */
735   function addTokenTo(address _to, uint256 _tokenId) internal {
736     super.addTokenTo(_to, _tokenId);
737     uint256 length = ownedTokens[_to].length;
738     ownedTokens[_to].push(_tokenId);
739     ownedTokensIndex[_tokenId] = length;
740   }
741 
742   /**
743    * @dev Internal function to remove a token ID from the list of a given address
744    * @param _from address representing the previous owner of the given token ID
745    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
746    */
747   function removeTokenFrom(address _from, uint256 _tokenId) internal {
748     super.removeTokenFrom(_from, _tokenId);
749 
750     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
751     // then delete the last slot.
752     uint256 tokenIndex = ownedTokensIndex[_tokenId];
753     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
754     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
755 
756     ownedTokens[_from][tokenIndex] = lastToken;
757     // This also deletes the contents at the last position of the array
758     ownedTokens[_from].length--;
759 
760     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
761     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
762     // the lastToken to the first position, and then dropping the element placed in the last position of the list
763 
764     ownedTokensIndex[_tokenId] = 0;
765     ownedTokensIndex[lastToken] = tokenIndex;
766   }
767 
768   /**
769    * @dev Internal function to mint a new token
770    * Reverts if the given token ID already exists
771    * @param _to address the beneficiary that will own the minted token
772    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
773    */
774   function _mint(address _to, uint256 _tokenId) internal {
775     super._mint(_to, _tokenId);
776 
777     allTokensIndex[_tokenId] = allTokens.length;
778     allTokens.push(_tokenId);
779   }
780 
781   /**
782    * @dev Internal function to burn a specific token
783    * Reverts if the token does not exist
784    * @param _owner owner of the token to burn
785    * @param _tokenId uint256 ID of the token being burned by the msg.sender
786    */
787   function _burn(address _owner, uint256 _tokenId) internal {
788     super._burn(_owner, _tokenId);
789 
790     // Clear metadata (if any)
791     if (bytes(tokenURIs[_tokenId]).length != 0) {
792       delete tokenURIs[_tokenId];
793     }
794 
795     // Reorg all tokens array
796     uint256 tokenIndex = allTokensIndex[_tokenId];
797     uint256 lastTokenIndex = allTokens.length.sub(1);
798     uint256 lastToken = allTokens[lastTokenIndex];
799 
800     allTokens[tokenIndex] = lastToken;
801     allTokens[lastTokenIndex] = 0;
802 
803     allTokens.length--;
804     allTokensIndex[_tokenId] = 0;
805     allTokensIndex[lastToken] = tokenIndex;
806   }
807 
808 }
809 
810 contract AuctionityEventToken is ERC721Token {
811 
812     address mintMaster;
813 
814     modifier mintMasterOnly() {
815         require (msg.sender == mintMaster, "You must be mint master");
816         _;
817     }
818 
819     event Claim(
820         address indexed _from,
821         uint256 indexed _tokenId
822     );
823 
824     constructor () public
825         ERC721Token("AuctionityEventToken", "AET")        
826     {
827         mintMaster = msg.sender;
828     }
829 
830     function mint(
831         address _to,
832         uint256 _tokenId
833     ) public mintMasterOnly
834     {
835         super._mint(_to, _tokenId);
836     }
837 
838     function mintAndDeposit(
839         address _to,
840         uint256 _tokenId,
841         address _ayDeposit
842     ) public mintMasterOnly
843     {
844         mint(_to, _tokenId);
845         transferFrom(_to, _ayDeposit, _tokenId);
846     }
847 
848     function updateMintMaster(
849         address _newMintMaster
850     ) public mintMasterOnly
851     {
852         mintMaster = _newMintMaster;
853     }
854 
855     function claim(
856         uint256 _tokenId
857     ) public
858     {
859         address _owner = ownerOf(_tokenId);
860         require(msg.sender == _owner, "You cannot claim someone else's token");
861 
862         transferFrom(_owner, address(0), _tokenId);
863 
864         emit Claim(_owner, _tokenId);
865     }
866 }