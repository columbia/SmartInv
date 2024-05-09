1 // File: contracts\Common\ERC165.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 /**
7  * @title ERC165
8  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
9  */
10 interface ERC165 {
11 
12   /**
13    * @notice Query if a contract implements an interface
14    * @param _interfaceId The interface identifier, as specified in ERC-165
15    * @dev Interface identification is specified in ERC-165. This function
16    * uses less than 30,000 gas.
17    */
18   function supportsInterface(bytes4 _interfaceId)
19     external
20     view
21     returns (bool);
22 }
23 
24 // File: contracts\ERC721\ERC721Basic.sol
25 
26 pragma solidity ^0.5.0;
27 
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
107     bytes memory _data 
108   )
109     public;
110 }
111 
112 // File: contracts\ERC721\ERC721.sol
113 
114 pragma solidity ^0.5.0;
115 
116 
117 
118 /**
119  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
120  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
121  */
122 contract ERC721Enumerable is ERC721Basic {
123   function totalSupply() public view returns (uint256);
124   function tokenOfOwnerByIndex(
125     address _owner,
126     uint256 _index
127   )
128     public
129     view
130     returns (uint256 _tokenId);
131 
132   function tokenByIndex(uint256 _index) public view returns (uint256);
133 }
134 
135 
136 /**
137  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
138  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
139  */
140 contract ERC721Metadata is ERC721Basic {
141   function name() external view returns (string memory _name);
142   function symbol() external view returns (string memory _symbol);
143   function tokenURI(uint256 _tokenId) public view returns (string memory);
144 }
145 
146 
147 /**
148  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
149  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
150  */
151 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
152 }
153 
154 // File: contracts\ERC721\ERC721Receiver.sol
155 
156 pragma solidity ^0.5.0;
157 
158 
159 /**
160  * @title ERC721 token receiver interface
161  * @dev Interface for any contract that wants to support safeTransfers
162  * from ERC721 asset contracts.
163  */
164 contract ERC721Receiver {
165   /**
166    * @dev Magic value to be returned upon successful reception of an NFT
167    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
168    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
169    */
170   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
171 
172   /**
173    * @notice Handle the receipt of an NFT
174    * @dev The ERC721 smart contract calls this function on the recipient
175    * after a `safetransfer`. This function MAY throw to revert and reject the
176    * transfer. Return of other than the magic value MUST result in the
177    * transaction being reverted.
178    * Note: the contract address is always the message sender.
179    * @param _operator The address which called `safeTransferFrom` function
180    * @param _from The address which previously owned the token
181    * @param _tokenId The NFT identifier which is being transferred
182    * @param _data Additional data with no specified format
183    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
184    */
185   function onERC721Received(
186     address _operator,
187     address _from,
188     uint256 _tokenId,
189     bytes memory _data 
190   )
191     public
192     returns(bytes4);
193 }
194 
195 // File: contracts\Common\SafeMath.sol
196 
197 pragma solidity ^0.5.0;
198 
199 
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205 
206   /**
207   * @dev Multiplies two numbers, throws on overflow.
208   */
209   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
210     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
211     // benefit is lost if 'b' is also tested.
212     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
213     if (_a == 0) {
214       return 0;
215     }
216 
217     c = _a * _b;
218     assert(c / _a == _b);
219     return c;
220   }
221 
222   /**
223   * @dev Integer division of two numbers, truncating the quotient.
224   */
225   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
226     // assert(_b > 0); // Solidity automatically throws when dividing by 0
227     // uint256 c = _a / _b;
228     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
229     return _a / _b;
230   }
231 
232   /**
233   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
234   */
235   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
236     assert(_b <= _a);
237     return _a - _b;
238   }
239 
240   /**
241   * @dev Adds two numbers, throws on overflow.
242   */
243   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
244     c = _a + _b;
245     assert(c >= _a);
246     return c;
247   }
248 }
249 
250 // File: contracts\Common\AddressUtils.sol
251 
252 pragma solidity ^0.5.0;
253 
254 
255 /**
256  * Utility library of inline functions on addresses
257  */
258 library AddressUtils {
259 
260   /**
261    * Returns whether the target address is a contract
262    * @dev This function will return false if invoked during the constructor of a contract,
263    * as the code is not actually created until after the constructor finishes.
264    * @param _addr address to check
265    * @return whether the target address is a contract
266    */
267   function isContract(address _addr) internal view returns (bool) {
268     uint256 size;
269     // XXX Currently there is no better way to check if there is a contract in an address
270     // than to check the size of the code at that address.
271     // See https://ethereum.stackexchange.com/a/14016/36603
272     // for more details about how this works.
273     // TODO Check this again before the Serenity release, because all addresses will be
274     // contracts then.
275     // solium-disable-next-line security/no-inline-assembly
276     assembly { size := extcodesize(_addr) }
277     return size > 0;
278   }
279 
280 }
281 
282 // File: contracts\Common\SupportsInterfaceWithLookup.sol
283 
284 pragma solidity ^0.5.0;
285 
286 
287 
288 /**
289  * @title SupportsInterfaceWithLookup
290  * @author Matt Condon (@shrugs)
291  * @dev Implements ERC165 using a lookup table.
292  */
293 contract SupportsInterfaceWithLookup is ERC165 {
294 
295   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
296   /**
297    * 0x01ffc9a7 ===
298    *   bytes4(keccak256('supportsInterface(bytes4)'))
299    */
300 
301   /**
302    * @dev a mapping of interface id to whether or not it's supported
303    */
304   mapping(bytes4 => bool) internal supportedInterfaces;
305 
306   /**
307    * @dev A contract implementing SupportsInterfaceWithLookup
308    * implement ERC165 itself
309    */
310   constructor()
311     public
312   {
313     _registerInterface(InterfaceId_ERC165);
314   }
315 
316   /**
317    * @dev implement supportsInterface(bytes4) using a lookup table
318    */
319   function supportsInterface(bytes4 _interfaceId)
320     external
321     view
322     returns (bool)
323   {
324     return supportedInterfaces[_interfaceId];
325   }
326 
327   /**
328    * @dev private method for registering an interface
329    */
330   function _registerInterface(bytes4 _interfaceId)
331     internal
332   {
333     require(_interfaceId != 0xffffffff);
334     supportedInterfaces[_interfaceId] = true;
335   }
336 }
337 
338 // File: contracts\ERC721\ERC721BasicToken.sol
339 
340 pragma solidity ^0.5.0;
341 
342 
343 
344 
345 
346 
347 
348 /**
349  * @title ERC721 Non-Fungible Token Standard basic implementation
350  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
351  */
352 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
353 
354   using SafeMath for uint256;
355   using AddressUtils for address;
356 
357   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
358   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
359   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
360 
361   // Mapping from token ID to owner
362   mapping (uint256 => address) internal tokenOwner;
363 
364   // Mapping from token ID to approved address
365   mapping (uint256 => address) internal tokenApprovals;
366 
367   // Mapping from owner to number of owned token
368   mapping (address => uint256) internal ownedTokensCount;
369 
370   // Mapping from owner to operator approvals
371   mapping (address => mapping (address => bool)) internal operatorApprovals;
372 
373   constructor()
374     public
375   {
376     // register the supported interfaces to conform to ERC721 via ERC165
377     _registerInterface(InterfaceId_ERC721);
378     _registerInterface(InterfaceId_ERC721Exists);
379   }
380 
381   /**
382    * @dev Gets the balance of the specified address
383    * @param _owner address to query the balance of
384    * @return uint256 representing the amount owned by the passed address
385    */
386   function balanceOf(address _owner) public view returns (uint256) {
387     require(_owner != address(0));
388     return ownedTokensCount[_owner];
389   }
390 
391   /**
392    * @dev Gets the owner of the specified token ID
393    * @param _tokenId uint256 ID of the token to query the owner of
394    * @return owner address currently marked as the owner of the given token ID
395    */
396   function ownerOf(uint256 _tokenId) public view returns (address) {
397     address owner = tokenOwner[_tokenId];
398     require(owner != address(0));
399     return owner;
400   }
401 
402   /**
403    * @dev Returns whether the specified token exists
404    * @param _tokenId uint256 ID of the token to query the existence of
405    * @return whether the token exists
406    */
407   function exists(uint256 _tokenId) public view returns (bool) {
408     address owner = tokenOwner[_tokenId];
409     return owner != address(0);
410   }
411 
412   /**
413    * @dev Approves another address to transfer the given token ID
414    * The zero address indicates there is no approved address.
415    * There can only be one approved address per token at a given time.
416    * Can only be called by the token owner or an approved operator.
417    * @param _to address to be approved for the given token ID
418    * @param _tokenId uint256 ID of the token to be approved
419    */
420   function approve(address _to, uint256 _tokenId) public {
421     address owner = ownerOf(_tokenId);
422     require(_to != owner);
423     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
424 
425     tokenApprovals[_tokenId] = _to;
426     emit Approval(owner, _to, _tokenId);
427   }
428 
429   /**
430    * @dev Gets the approved address for a token ID, or zero if no address set
431    * @param _tokenId uint256 ID of the token to query the approval of
432    * @return address currently approved for the given token ID
433    */
434   function getApproved(uint256 _tokenId) public view returns (address) {
435     return tokenApprovals[_tokenId];
436   }
437 
438   /**
439    * @dev Sets or unsets the approval of a given operator
440    * An operator is allowed to transfer all tokens of the sender on their behalf
441    * @param _to operator address to set the approval
442    * @param _approved representing the status of the approval to be set
443    */
444   function setApprovalForAll(address _to, bool _approved) public {
445     require(_to != msg.sender);
446     operatorApprovals[msg.sender][_to] = _approved;
447     emit ApprovalForAll(msg.sender, _to, _approved);
448   }
449 
450   /**
451    * @dev Tells whether an operator is approved by a given owner
452    * @param _owner owner address which you want to query the approval of
453    * @param _operator operator address which you want to query the approval of
454    * @return bool whether the given operator is approved by the given owner
455    */
456   function isApprovedForAll(
457     address _owner,
458     address _operator
459   )
460     public
461     view
462     returns (bool)
463   {
464     return operatorApprovals[_owner][_operator];
465   }
466 
467   /**
468    * @dev Transfers the ownership of a given token ID to another address
469    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
470    * Requires the msg sender to be the owner, approved, or operator
471    * @param _from current owner of the token
472    * @param _to address to receive the ownership of the given token ID
473    * @param _tokenId uint256 ID of the token to be transferred
474   */
475   function transferFrom(
476     address _from,
477     address _to,
478     uint256 _tokenId
479   )
480     public
481   {
482     require(isApprovedOrOwner(msg.sender, _tokenId));
483     require(_from != address(0));
484     require(_to != address(0));
485 
486     clearApproval(_from, _tokenId);
487     removeTokenFrom(_from, _tokenId);
488     addTokenTo(_to, _tokenId);
489 
490     emit Transfer(_from, _to, _tokenId);
491   }
492 
493   /**
494    * @dev Safely transfers the ownership of a given token ID to another address
495    * If the target address is a contract, it must implement `onERC721Received`,
496    * which is called upon a safe transfer, and return the magic value
497    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
498    * the transfer is reverted.
499    *
500    * Requires the msg sender to be the owner, approved, or operator
501    * @param _from current owner of the token
502    * @param _to address to receive the ownership of the given token ID
503    * @param _tokenId uint256 ID of the token to be transferred
504   */
505   function safeTransferFrom(
506     address _from,
507     address _to,
508     uint256 _tokenId
509   )
510     public
511   {
512     // solium-disable-next-line arg-overflow
513     safeTransferFrom(_from, _to, _tokenId, "");
514   }
515 
516   /**
517    * @dev Safely transfers the ownership of a given token ID to another address
518    * If the target address is a contract, it must implement `onERC721Received`,
519    * which is called upon a safe transfer, and return the magic value
520    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
521    * the transfer is reverted.
522    * Requires the msg sender to be the owner, approved, or operator
523    * @param _from current owner of the token
524    * @param _to address to receive the ownership of the given token ID
525    * @param _tokenId uint256 ID of the token to be transferred
526    * @param _data bytes data to send along with a safe transfer check
527    */
528   function safeTransferFrom(
529     address _from,
530     address _to,
531     uint256 _tokenId,
532     bytes memory _data
533   )
534     public
535   {
536     transferFrom(_from, _to, _tokenId);
537     // solium-disable-next-line arg-overflow
538     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
539   }
540 
541   /**
542    * @dev Returns whether the given spender can transfer a given token ID
543    * @param _spender address of the spender to query
544    * @param _tokenId uint256 ID of the token to be transferred
545    * @return bool whether the msg.sender is approved for the given token ID,
546    *  is an operator of the owner, or is the owner of the token
547    */
548   function isApprovedOrOwner(
549     address _spender,
550     uint256 _tokenId
551   )
552     internal
553     view
554     returns (bool)
555   {
556     address owner = ownerOf(_tokenId);
557     // Disable solium check because of
558     // https://github.com/duaraghav8/Solium/issues/175
559     // solium-disable-next-line operator-whitespace
560     return (
561       _spender == owner ||
562       getApproved(_tokenId) == _spender ||
563       isApprovedForAll(owner, _spender)
564     );
565   }
566 
567   /**
568    * @dev Internal function to mint a new token
569    * Reverts if the given token ID already exists
570    * @param _to The address that will own the minted token
571    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
572    */
573   function _mint(address _to, uint256 _tokenId) internal {
574     require(_to != address(0));
575     addTokenTo(_to, _tokenId);
576     emit Transfer(address(0), _to, _tokenId);
577   }
578 
579   /**
580    * @dev Internal function to burn a specific token
581    * Reverts if the token does not exist
582    * @param _tokenId uint256 ID of the token being burned by the msg.sender
583    */
584   function _burn(address _owner, uint256 _tokenId) internal {
585     clearApproval(_owner, _tokenId);
586     removeTokenFrom(_owner, _tokenId);
587     emit Transfer(_owner, address(0), _tokenId);
588   }
589 
590   /**
591    * @dev Internal function to clear current approval of a given token ID
592    * Reverts if the given address is not indeed the owner of the token
593    * @param _owner owner of the token
594    * @param _tokenId uint256 ID of the token to be transferred
595    */
596   function clearApproval(address _owner, uint256 _tokenId) internal {
597     require(ownerOf(_tokenId) == _owner);
598     if (tokenApprovals[_tokenId] != address(0)) {
599       tokenApprovals[_tokenId] = address(0);
600     }
601   }
602 
603   /**
604    * @dev Internal function to add a token ID to the list of a given address
605    * @param _to address representing the new owner of the given token ID
606    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
607    */
608   function addTokenTo(address _to, uint256 _tokenId) internal {
609     require(tokenOwner[_tokenId] == address(0));
610     tokenOwner[_tokenId] = _to;
611     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
612   }
613 
614   /**
615    * @dev Internal function to remove a token ID from the list of a given address
616    * @param _from address representing the previous owner of the given token ID
617    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
618    */
619   function removeTokenFrom(address _from, uint256 _tokenId) internal {
620     require(ownerOf(_tokenId) == _from);
621     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
622     tokenOwner[_tokenId] = address(0);
623   }
624 
625   /**
626    * @dev Internal function to invoke `onERC721Received` on a target address
627    * The call is not executed if the target address is not a contract
628    * @param _from address representing the previous owner of the given token ID
629    * @param _to target address that will receive the tokens
630    * @param _tokenId uint256 ID of the token to be transferred
631    * @param _data bytes optional data to send along with the call
632    * @return whether the call correctly returned the expected magic value
633    */
634   function checkAndCallSafeTransfer(
635     address _from,
636     address _to,
637     uint256 _tokenId,
638     bytes memory _data
639   )
640     internal
641     returns (bool)
642   {
643     if (!_to.isContract()) {
644       return true;
645     }
646     bytes4 retval = ERC721Receiver(_to).onERC721Received(
647       msg.sender, _from, _tokenId, _data);
648     return (retval == ERC721_RECEIVED);
649   }
650 }
651 
652 // File: contracts\ERC721\ERC721Token.sol
653 
654 pragma solidity ^0.5.0;
655 
656 
657 
658 
659 /**
660  * @title Full ERC721 Token
661  * This implementation includes all the required and some optional functionality of the ERC721 standard
662  * Moreover, it includes approve all functionality using operator terminology
663  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
664  */
665 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
666 
667   // Token name
668   string internal name_;
669 
670   // Token symbol
671   string internal symbol_;
672 
673   // Mapping from owner to list of owned token IDs
674   mapping(address => uint256[]) internal ownedTokens;
675 
676   // Mapping from token ID to index of the owner tokens list
677   mapping(uint256 => uint256) internal ownedTokensIndex;
678 
679   // Array with all token ids, used for enumeration
680   uint256[] internal allTokens;
681 
682   // Mapping from token id to position in the allTokens array
683   mapping(uint256 => uint256) internal allTokensIndex;
684 
685   // Optional mapping for token URIs
686   mapping(uint256 => string) internal tokenURIs;
687 
688   /**
689    * @dev Constructor function
690    */
691   constructor(string memory _name, string memory _symbol) public {
692     name_ = _name;
693     symbol_ = _symbol;
694 
695     // register the supported interfaces to conform to ERC721 via ERC165
696     _registerInterface(InterfaceId_ERC721Enumerable);
697     _registerInterface(InterfaceId_ERC721Metadata);
698   }
699 
700   /**
701    * @dev Gets the token name
702    * @return string representing the token name
703    */
704   function name() external view returns (string memory) {
705     return name_;
706   }
707 
708   /**
709    * @dev Gets the token symbol
710    * @return string representing the token symbol
711    */
712   function symbol() external view returns (string memory) {
713     return symbol_;
714   }
715 
716   /**
717    * @dev Returns an URI for a given token ID
718    * Throws if the token ID does not exist. May return an empty string.
719    * @param _tokenId uint256 ID of the token to query
720    */
721   function tokenURI(uint256 _tokenId) public view returns (string memory) {
722     require(exists(_tokenId));
723     return tokenURIs[_tokenId];
724   }
725 
726   /**
727    * @dev Gets the token ID at a given index of the tokens list of the requested owner
728    * @param _owner address owning the tokens list to be accessed
729    * @param _index uint256 representing the index to be accessed of the requested tokens list
730    * @return uint256 token ID at the given index of the tokens list owned by the requested address
731    */
732   function tokenOfOwnerByIndex(
733     address _owner,
734     uint256 _index
735   )
736     public
737     view
738     returns (uint256)
739   {
740     require(_index < balanceOf(_owner));
741     return ownedTokens[_owner][_index];
742   }
743 
744   /**
745    * @dev Gets the total amount of tokens stored by the contract
746    * @return uint256 representing the total amount of tokens
747    */
748   function totalSupply() public view returns (uint256) {
749     return allTokens.length;
750   }
751 
752   /**
753    * @dev Gets the token ID at a given index of all the tokens in this contract
754    * Reverts if the index is greater or equal to the total number of tokens
755    * @param _index uint256 representing the index to be accessed of the tokens list
756    * @return uint256 token ID at the given index of the tokens list
757    */
758   function tokenByIndex(uint256 _index) public view returns (uint256) {
759     require(_index < totalSupply());
760     return allTokens[_index];
761   }
762 
763   /**
764    * @dev Internal function to set the token URI for a given token
765    * Reverts if the token ID does not exist
766    * @param _tokenId uint256 ID of the token to set its URI
767    * @param _uri string URI to assign
768    */
769   function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
770     require(exists(_tokenId));
771     tokenURIs[_tokenId] = _uri;
772   }
773 
774   /**
775    * @dev Internal function to add a token ID to the list of a given address
776    * @param _to address representing the new owner of the given token ID
777    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
778    */
779   function addTokenTo(address _to, uint256 _tokenId) internal {
780     super.addTokenTo(_to, _tokenId);
781     uint256 length = ownedTokens[_to].length;
782     ownedTokens[_to].push(_tokenId);
783     ownedTokensIndex[_tokenId] = length;
784   }
785 
786   /**
787    * @dev Internal function to remove a token ID from the list of a given address
788    * @param _from address representing the previous owner of the given token ID
789    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
790    */
791   function removeTokenFrom(address _from, uint256 _tokenId) internal {
792     super.removeTokenFrom(_from, _tokenId);
793 
794     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
795     // then delete the last slot.
796     uint256 tokenIndex = ownedTokensIndex[_tokenId];
797     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
798     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
799 
800     ownedTokens[_from][tokenIndex] = lastToken;
801     // This also deletes the contents at the last position of the array
802     ownedTokens[_from].length--;
803 
804     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
805     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
806     // the lastToken to the first position, and then dropping the element placed in the last position of the list
807 
808     ownedTokensIndex[_tokenId] = 0;
809     ownedTokensIndex[lastToken] = tokenIndex;
810   }
811 
812   /**
813    * @dev Internal function to mint a new token
814    * Reverts if the given token ID already exists
815    * @param _to address the beneficiary that will own the minted token
816    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
817    */
818   function _mint(address _to, uint256 _tokenId) internal {
819     super._mint(_to, _tokenId);
820 
821     allTokensIndex[_tokenId] = allTokens.length;
822     allTokens.push(_tokenId);
823   }
824 
825   /**
826    * @dev Internal function to burn a specific token
827    * Reverts if the token does not exist
828    * @param _owner owner of the token to burn
829    * @param _tokenId uint256 ID of the token being burned by the msg.sender
830    */
831   function _burn(address _owner, uint256 _tokenId) internal {
832     super._burn(_owner, _tokenId);
833 
834     // Clear metadata (if any)
835     if (bytes(tokenURIs[_tokenId]).length != 0) {
836       delete tokenURIs[_tokenId];
837     }
838 
839     // Reorg all tokens array
840     uint256 tokenIndex = allTokensIndex[_tokenId];
841     uint256 lastTokenIndex = allTokens.length.sub(1);
842     uint256 lastToken = allTokens[lastTokenIndex];
843 
844     allTokens[tokenIndex] = lastToken;
845     allTokens[lastTokenIndex] = 0;
846 
847     allTokens.length--;
848     allTokensIndex[_tokenId] = 0;
849     allTokensIndex[lastToken] = tokenIndex;
850   }
851 
852 }
853 
854 // File: contracts\PriceRecord.sol
855 
856 pragma solidity ^0.5.0;
857 
858 library RecordKeeping {
859     struct priceRecord {
860         uint256 price;
861         address owner;
862         uint256 timestamp;
863 
864     }
865 }
866 
867 // File: contracts\Common\Ownable.sol
868 
869 pragma solidity ^0.5.0;
870 
871 
872 /**
873  * @title Ownable
874  * @dev The Ownable contract has an owner address, and provides basic authorization control
875  * functions, this simplifies the implementation of "user permissions".
876  */
877 contract Ownable {
878   address public owner;
879 
880 
881   event OwnershipRenounced(address indexed previousOwner);
882   event OwnershipTransferred(
883     address indexed previousOwner,
884     address indexed newOwner
885   );
886 
887 
888   /**
889    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
890    * account.
891    */
892   constructor() public {
893     owner = msg.sender;
894   }
895 
896   /**
897    * @dev Throws if called by any account other than the owner.
898    */
899   modifier onlyOwner() {
900     require(msg.sender == owner);
901     _;
902   }
903 
904   /**
905    * @dev Allows the current owner to relinquish control of the contract.
906    * @notice Renouncing to ownership will leave the contract without an owner.
907    * It will not be possible to call the functions with the `onlyOwner`
908    * modifier anymore.
909    */
910   function renounceOwnership() public onlyOwner {
911     emit OwnershipRenounced(owner);
912     owner = address(0);
913   }
914 
915   /**
916    * @dev Allows the current owner to transfer control of the contract to a newOwner.
917    * @param _newOwner The address to transfer ownership to.
918    */
919   function transferOwnership(address _newOwner) public onlyOwner {
920     _transferOwnership(_newOwner);
921   }
922 
923   /**
924    * @dev Transfers control of the contract to a newOwner.
925    * @param _newOwner The address to transfer ownership to.
926    */
927   function _transferOwnership(address _newOwner) internal {
928     require(_newOwner != address(0));
929     emit OwnershipTransferred(owner, _newOwner);
930     owner = _newOwner;
931   }
932 }
933 
934 // File: contracts\Withdrawable.sol
935 
936 pragma solidity ^0.5.0;
937 
938 /// @title Withdrawable
939 /// @dev 
940 /// @notice 
941 
942 contract Withdrawable  is Ownable {
943     
944     // _changeType is used to indicate the type of the transaction
945     // 0 - normal withdraw 
946     // 1 - deposit from selling asset
947     // 2 - deposit from profit sharing of new token
948     // 3 - deposit from auction
949     // 4 - failed auction refund
950     // 5 - referral commission
951 
952     event BalanceChanged(address indexed _owner, int256 _change,  uint256 _balance, uint8 _changeType);
953   
954     mapping (address => uint256) internal pendingWithdrawals;
955   
956     //total pending amount
957     uint256 internal totalPendingAmount;
958 
959     function _deposit(address addressToDeposit, uint256 amount, uint8 changeType) internal{      
960         if (amount > 0) {
961             _depositWithoutEvent(addressToDeposit, amount);
962             emit BalanceChanged(addressToDeposit, int256(amount), pendingWithdrawals[addressToDeposit], changeType);
963         }
964     }
965 
966     function _depositWithoutEvent(address addressToDeposit, uint256 amount) internal{
967         pendingWithdrawals[addressToDeposit] += amount;
968         totalPendingAmount += amount;       
969     }
970 
971     function getBalance(address addressToCheck) public view returns (uint256){
972         return pendingWithdrawals[addressToCheck];
973     }
974 
975     function withdrawOwnFund(address payable recipient_address) public {
976         require(msg.sender==recipient_address);
977 
978         uint amount = pendingWithdrawals[recipient_address];
979         require(amount > 0);
980         // Remember to zero the pending refund before
981         // sending to prevent re-entrancy attacks
982         pendingWithdrawals[recipient_address] = 0;
983         totalPendingAmount -= amount;
984         recipient_address.transfer(amount);
985         emit BalanceChanged(recipient_address, -1 * int256(amount),  0, 0);
986     }
987 
988     function checkAvailableContractBalance() public view returns (uint256){
989         if (address(this).balance > totalPendingAmount){
990             return address(this).balance - totalPendingAmount;
991         } else{
992             return 0;
993         }
994     }
995     function withdrawContractFund(address payable recipient_address) public onlyOwner  {
996         uint256 amountToWithdraw = checkAvailableContractBalance();
997         if (amountToWithdraw > 0){
998             recipient_address.transfer(amountToWithdraw);
999         }
1000     }
1001 }
1002 
1003 // File: contracts\ERC721WithState.sol
1004 
1005 pragma solidity ^0.5.0;
1006 
1007 
1008 
1009 contract ERC721WithState is ERC721BasicToken {
1010     mapping (uint256 => uint8) internal tokenState;
1011 
1012     event TokenStateSet(uint256 indexed _tokenId,  uint8 _state);
1013 
1014     function setTokenState(uint256  _tokenId,  uint8 _state) public  {
1015         require(isApprovedOrOwner(msg.sender, _tokenId));
1016         require(exists(_tokenId)); 
1017         tokenState[_tokenId] = _state;      
1018         emit TokenStateSet(_tokenId, _state);
1019     }
1020 
1021     function getTokenState(uint256  _tokenId) public view returns (uint8){
1022         require(exists(_tokenId));
1023         return tokenState[_tokenId];
1024     } 
1025 
1026 
1027 }
1028 
1029 // File: contracts\RetroArt.sol
1030 
1031 pragma solidity ^0.5.0;
1032 pragma experimental ABIEncoderV2;
1033 
1034 
1035 
1036 
1037 
1038 
1039 contract RetroArt is ERC721Token, Ownable, Withdrawable, ERC721WithState {
1040     
1041     address public stemTokenContractAddress; 
1042     uint256 public currentPrice;
1043     uint256 constant initiailPrice = 0.03 ether;
1044     //new asset price increase at the rate that determined by the variable below
1045     //it is caculated from the current price + (current price / ( price rate * totalTokens / slowDownRate ))
1046     uint public priceRate = 10;
1047     uint public slowDownRate = 7;
1048     //Commission will be charged if a profit is made
1049     //Commission is the pure profit / profit Commission  
1050     // measured in basis points (1/100 of a percent) 
1051     // Values 0-10,000 map to 0%-100%
1052     uint public profitCommission = 500;
1053 
1054     //the referral percentage of the commission of selling of aset
1055     // measured in basis points (1/100 of a percent) 
1056     // Values 0-10,000 map to 0%-100%
1057     uint public referralCommission = 3000;
1058 
1059     //share will be given to all tokens equally if a new asset is acquired. 
1060     //the amount of total shared value is assetValue/sharePercentage   
1061     // measured in basis points (1/100 of a percent) 
1062     // Values 0-10,000 map to 0%-100%
1063     uint public sharePercentage = 3000;
1064 
1065     //number of shares for acquiring new asset. 
1066     uint public numberOfShares = 10;
1067 
1068     string public uriPrefix ="";
1069 
1070 
1071     // Mapping from owner to list of owned token IDs
1072     mapping (uint256 => string) internal tokenTitles;
1073     mapping (uint256 => RecordKeeping.priceRecord) internal initialPriceRecords;
1074     mapping (uint256 => RecordKeeping.priceRecord) internal lastPriceRecords;
1075     mapping (uint256 => uint256) internal currentTokenPrices;
1076 
1077 
1078     event AssetAcquired(address indexed _owner, uint256 indexed _tokenId, string  _title, uint256 _price);
1079     event TokenPriceSet(uint256 indexed _tokenId,  uint256 _price);
1080     event TokenBrought(address indexed _from, address indexed _to, uint256 indexed _tokenId, uint256 _price);
1081     event PriceRateChanged(uint _priceRate);
1082     event SlowDownRateChanged(uint _slowDownRate);
1083     event ProfitCommissionChanged(uint _profitCommission);
1084     event MintPriceChanged(uint256 _price);
1085     event SharePercentageChanged(uint _sharePercentage);
1086     event NumberOfSharesChanged(uint _numberOfShares);
1087     event ReferralCommissionChanged(uint _referralCommission);
1088     event Burn(address indexed _owner, uint256 _tokenId);
1089 
1090    
1091 
1092     bytes4 private constant InterfaceId_RetroArt = 0x94fb30be;
1093     /*
1094     bytes4(keccak256("buyTokenFrom(address,address,uint256)"))^
1095     bytes4(keccak256("setTokenPrice(uint256,uint256)"))^
1096     bytes4(keccak256("setTokenState(uint256,uint8)"))^
1097     bytes4(keccak256("getTokenState(uint256)"));
1098     */
1099 
1100     address[] internal auctionContractAddresses;
1101  
1102    
1103 
1104     function tokenTitle(uint256 _tokenId) public view returns (string memory) {
1105         require(exists(_tokenId));
1106         return tokenTitles[_tokenId];
1107     }
1108     function lastPriceOf(uint256 _tokenId) public view returns (uint256) {
1109         require(exists(_tokenId));
1110         return  lastPriceRecords[_tokenId].price;
1111     }   
1112 
1113     function lastTransactionTimeOf(uint256 _tokenId) public view returns (uint256) {
1114         require(exists(_tokenId));
1115         return  lastPriceRecords[_tokenId].timestamp;
1116     }
1117 
1118     function firstPriceOf(uint256 _tokenId) public view returns (uint256) {
1119         require(exists(_tokenId));
1120         return  initialPriceRecords[_tokenId].price;
1121     }   
1122     function creatorOf(uint256 _tokenId) public view returns (address) {
1123         require(exists(_tokenId));
1124         return  initialPriceRecords[_tokenId].owner;
1125     }
1126     function firstTransactionTimeOf(uint256 _tokenId) public view returns (uint256) {
1127         require(exists(_tokenId));
1128         return  initialPriceRecords[_tokenId].timestamp;
1129     }
1130     
1131   
1132     //problem with current web3.js that can't return an array of struct
1133     function lastHistoryOf(uint256 _tokenId) internal view returns (RecordKeeping.priceRecord storage) {
1134         require(exists(_tokenId));
1135         return lastPriceRecords[_tokenId];
1136     }
1137 
1138     function firstHistoryOf(uint256 _tokenId) internal view returns (RecordKeeping.priceRecord storage) {
1139         require(exists(_tokenId)); 
1140         return   initialPriceRecords[_tokenId];
1141     }
1142 
1143     function setPriceRate(uint _priceRate) public onlyOwner {
1144         priceRate = _priceRate;
1145         emit PriceRateChanged(priceRate);
1146     }
1147 
1148     function setSlowDownRate(uint _slowDownRate) public onlyOwner {
1149         slowDownRate = _slowDownRate;
1150         emit SlowDownRateChanged(slowDownRate);
1151     }
1152  
1153     function setprofitCommission(uint _profitCommission) public onlyOwner {
1154         require(_profitCommission <= 10000);
1155         profitCommission = _profitCommission;
1156         emit ProfitCommissionChanged(profitCommission);
1157     }
1158 
1159     function setSharePercentage(uint _sharePercentage) public onlyOwner  {
1160         require(_sharePercentage <= 10000);
1161         sharePercentage = _sharePercentage;
1162         emit SharePercentageChanged(sharePercentage);
1163     }
1164 
1165     function setNumberOfShares(uint _numberOfShares) public onlyOwner  {
1166         numberOfShares = _numberOfShares;
1167         emit NumberOfSharesChanged(numberOfShares);
1168     }
1169 
1170     function setReferralCommission(uint _referralCommission) public onlyOwner  {
1171         require(_referralCommission <= 10000);
1172         referralCommission = _referralCommission;
1173         emit ReferralCommissionChanged(referralCommission);
1174     }
1175 
1176     function setUriPrefix(string memory _uri) public onlyOwner  {
1177        uriPrefix = _uri;
1178     }
1179   
1180     //use the token name, symbol as usual
1181     //this contract create another ERC20 as stemToken,
1182     //the constructure takes the stemTokenName and stemTokenSymbol
1183 
1184     constructor(string memory _name, string memory _symbol , address _stemTokenAddress) 
1185         ERC721Token(_name, _symbol) Ownable() public {
1186        
1187         currentPrice = initiailPrice;
1188         stemTokenContractAddress = _stemTokenAddress;
1189         _registerInterface(InterfaceId_RetroArt);
1190     }
1191 
1192     function getAllAssets() public view returns (uint256[] memory){
1193         return allTokens;
1194     }
1195 
1196     function getAllAssetsForSale() public view returns  (uint256[] memory){
1197       
1198         uint arrayLength = allTokens.length;
1199         uint forSaleCount = 0;
1200         for (uint i = 0; i<arrayLength; i++) {
1201             if (currentTokenPrices[allTokens[i]] > 0) {
1202                 forSaleCount++;              
1203             }
1204         }
1205         
1206         uint256[] memory tokensForSale = new uint256[](forSaleCount);
1207 
1208         uint j = 0;
1209         for (uint i = 0; i<arrayLength; i++) {
1210             if (currentTokenPrices[allTokens[i]] > 0) {                
1211                 tokensForSale[j] = allTokens[i];
1212                 j++;
1213             }
1214         }
1215 
1216         return tokensForSale;
1217     }
1218 
1219     function getAssetsForSale(address _owner) public view returns (uint256[] memory) {
1220       
1221         uint arrayLength = allTokens.length;
1222         uint forSaleCount = 0;
1223         for (uint i = 0; i<arrayLength; i++) {
1224             if (currentTokenPrices[allTokens[i]] > 0 && tokenOwner[allTokens[i]] == _owner) {
1225                 forSaleCount++;              
1226             }
1227         }
1228         
1229         uint256[] memory tokensForSale = new uint256[](forSaleCount);
1230 
1231         uint j = 0;
1232         for (uint i = 0; i<arrayLength; i++) {
1233             if (currentTokenPrices[allTokens[i]] > 0 && tokenOwner[allTokens[i]] == _owner) {                
1234                 tokensForSale[j] = allTokens[i];
1235                 j++;
1236             }
1237         }
1238 
1239         return tokensForSale;
1240     }
1241 
1242     function getAssetsByState(uint8 _state) public view returns (uint256[] memory){
1243         
1244         uint arrayLength = allTokens.length;
1245         uint matchCount = 0;
1246         for (uint i = 0; i<arrayLength; i++) {
1247             if (tokenState[allTokens[i]] == _state) {
1248                 matchCount++;              
1249             }
1250         }
1251         
1252         uint256[] memory matchedTokens = new uint256[](matchCount);
1253 
1254         uint j = 0;
1255         for (uint i = 0; i<arrayLength; i++) {
1256             if (tokenState[allTokens[i]] == _state) {                
1257                 matchedTokens[j] = allTokens[i];
1258                 j++;
1259             }
1260         }
1261 
1262         return matchedTokens;
1263     }
1264       
1265 
1266     function acquireAsset(uint256 _tokenId, string memory _title) public payable{
1267         acquireAssetWithReferral(_tokenId, _title, address(0));
1268     }
1269 
1270     function acquireAssetFromStemToken(address _tokenOwner, uint256 _tokenId, string calldata _title) external {     
1271          require(msg.sender == stemTokenContractAddress);
1272         _acquireAsset(_tokenId, _title, _tokenOwner, 0);
1273     }
1274 
1275     function acquireAssetWithReferral(uint256 _tokenId, string memory _title, address referralAddress) public payable{
1276         require(msg.value >= currentPrice);
1277         
1278         uint totalShares = numberOfShares;
1279         if (referralAddress != address(0)) totalShares++;
1280 
1281         uint numberOfTokens = allTokens.length;
1282      
1283         if (numberOfTokens > 0 && sharePercentage > 0) {
1284 
1285             uint256 perShareValue = 0;
1286             uint256 totalShareValue = msg.value * sharePercentage / 10000 ;
1287 
1288             if (totalShares > numberOfTokens) {
1289                                
1290                 if (referralAddress != address(0)) 
1291                     perShareValue = totalShareValue / (numberOfTokens + 1);
1292                 else
1293                     perShareValue = totalShareValue / numberOfTokens;
1294             
1295                 for (uint i = 0; i < numberOfTokens; i++) {
1296                     //turn off events if there are too many tokens in the loop
1297                     if (numberOfTokens > 100) {
1298                         _depositWithoutEvent(tokenOwner[allTokens[i]], perShareValue);
1299                     }else{
1300                         _deposit(tokenOwner[allTokens[i]], perShareValue, 2);
1301                     }
1302                 }
1303                 
1304             }else{
1305                
1306                 if (referralAddress != address(0)) 
1307                     perShareValue = totalShareValue / (totalShares + 1);
1308                 else
1309                     perShareValue = totalShareValue / totalShares;
1310               
1311                 uint[] memory randomArray = random(numberOfShares);
1312 
1313                 for (uint i = 0; i < numberOfShares; i++) {
1314                     uint index = randomArray[i] % numberOfTokens;
1315 
1316                     if (numberOfShares > 100) {
1317                         _depositWithoutEvent(tokenOwner[allTokens[index]], perShareValue);
1318                     }else{
1319                         _deposit(tokenOwner[allTokens[index]], perShareValue, 2);
1320                     }
1321                 }
1322             }
1323                     
1324             if (referralAddress != address(0) && perShareValue > 0) _deposit(referralAddress, perShareValue, 5);
1325 
1326         }
1327 
1328         _acquireAsset(_tokenId, _title, msg.sender, msg.value);
1329      
1330     }
1331 
1332     function _acquireAsset(uint256 _tokenId, string memory _title, address _purchaser, uint256 _value) internal {
1333         
1334         currentPrice = CalculateNextPrice();
1335         _mint(_purchaser, _tokenId);        
1336       
1337         tokenTitles[_tokenId] = _title;
1338        
1339         RecordKeeping.priceRecord memory pr = RecordKeeping.priceRecord(_value, _purchaser, block.timestamp);
1340         initialPriceRecords[_tokenId] = pr;
1341         lastPriceRecords[_tokenId] = pr;     
1342 
1343         emit AssetAcquired(_purchaser,_tokenId, _title, _value);
1344         emit TokenBrought(address(0), _purchaser, _tokenId, _value);
1345         emit MintPriceChanged(currentPrice);
1346     }
1347 
1348     function CalculateNextPrice() public view returns (uint256){      
1349         return currentPrice + currentPrice * slowDownRate / ( priceRate * (allTokens.length + 2));
1350     }
1351 
1352     function tokensOf(address _owner) public view returns (uint256[] memory){
1353         return ownedTokens[_owner];
1354     }
1355 
1356     function _buyTokenFromWithReferral(address _from, address _to, uint256 _tokenId, address referralAddress, address _depositTo) internal {
1357         require(currentTokenPrices[_tokenId] != 0);
1358         require(msg.value >= currentTokenPrices[_tokenId]);
1359         
1360         tokenApprovals[_tokenId] = _to;
1361         safeTransferFrom(_from,_to,_tokenId);
1362 
1363         uint256 valueTransferToOwner = msg.value;
1364         uint256 lastRecordPrice = lastPriceRecords[_tokenId].price;
1365         if (msg.value >  lastRecordPrice){
1366             uint256 profit = msg.value - lastRecordPrice;           
1367             uint256 commission = profit * profitCommission / 10000;
1368             valueTransferToOwner = msg.value - commission;
1369             if (referralAddress != address(0)){
1370                 _deposit(referralAddress, commission * referralCommission / 10000, 5);
1371             }           
1372         }
1373         
1374         if (valueTransferToOwner > 0) _deposit(_depositTo, valueTransferToOwner, 1);
1375         writePriceRecordForAssetSold(_depositTo, msg.sender, _tokenId, msg.value);
1376         
1377     }
1378 
1379     function buyTokenFromWithReferral(address _from, address _to, uint256 _tokenId, address referralAddress) public payable {
1380         _buyTokenFromWithReferral(_from, _to, _tokenId, referralAddress, _from);        
1381     }
1382 
1383     function buyTokenFrom(address _from, address _to, uint256 _tokenId) public payable {
1384         buyTokenFromWithReferral(_from, _to, _tokenId, address(0));        
1385     }   
1386 
1387     function writePriceRecordForAssetSold(address _from, address _to, uint256 _tokenId, uint256 _value) internal {
1388        RecordKeeping.priceRecord memory pr = RecordKeeping.priceRecord(_value, _to, block.timestamp);
1389        lastPriceRecords[_tokenId] = pr;
1390        
1391        tokenApprovals[_tokenId] = address(0);
1392        currentTokenPrices[_tokenId] = 0;
1393        emit TokenBrought(_from, _to, _tokenId, _value);       
1394     }
1395 
1396     function recordAuctionPriceRecord(address _from, address _to, uint256 _tokenId, uint256 _value)
1397        external {
1398 
1399        require(findAuctionContractIndex(msg.sender) >= 0); //make sure the sender is from one of the auction addresses
1400        writePriceRecordForAssetSold(_from, _to, _tokenId, _value);
1401 
1402     }
1403 
1404     function setTokenPrice(uint256 _tokenId, uint256 _newPrice) public  {
1405         require(isApprovedOrOwner(msg.sender, _tokenId));
1406         currentTokenPrices[_tokenId] = _newPrice;
1407         emit TokenPriceSet(_tokenId, _newPrice);
1408     }
1409 
1410     function getTokenPrice(uint256 _tokenId)  public view returns(uint256) {
1411         return currentTokenPrices[_tokenId];
1412     }
1413 
1414     function random(uint num) private view returns (uint[] memory) {
1415         
1416         uint base = uint(keccak256(abi.encodePacked(block.difficulty, now, tokenOwner[allTokens[allTokens.length-1]])));
1417         uint[] memory randomNumbers = new uint[](num);
1418         
1419         for (uint i = 0; i<num; i++) {
1420             randomNumbers[i] = base;
1421             base = base * 2 ** 3;
1422         }
1423         return  randomNumbers;
1424         
1425     }
1426 
1427 
1428     function getAsset(uint256 _tokenId)  external
1429         view
1430         returns
1431     (
1432         string memory title,            
1433         address owner,     
1434         address creator,      
1435         uint256 currentTokenPrice,
1436         uint256 lastPrice,
1437         uint256 initialPrice,
1438         uint256 lastDate,
1439         uint256 createdDate
1440     ) {
1441         require(exists(_tokenId));
1442         RecordKeeping.priceRecord memory lastPriceRecord = lastPriceRecords[_tokenId];
1443         RecordKeeping.priceRecord memory initialPriceRecord = initialPriceRecords[_tokenId];
1444 
1445         return (
1446              
1447             tokenTitles[_tokenId],        
1448             tokenOwner[_tokenId],   
1449             initialPriceRecord.owner,           
1450             currentTokenPrices[_tokenId],      
1451             lastPriceRecord.price,           
1452             initialPriceRecord.price,
1453             lastPriceRecord.timestamp,
1454             initialPriceRecord.timestamp
1455         );
1456     }
1457 
1458     function getAssetUpdatedInfo(uint256 _tokenId) external
1459         view
1460         returns
1461     (         
1462         address owner, 
1463         address approvedAddress,
1464         uint256 currentTokenPrice,
1465         uint256 lastPrice,      
1466         uint256 lastDate
1467       
1468     ) {
1469         require(exists(_tokenId));
1470         RecordKeeping.priceRecord memory lastPriceRecord = lastPriceRecords[_tokenId];
1471      
1472         return (
1473             tokenOwner[_tokenId],   
1474             tokenApprovals[_tokenId],  
1475             currentTokenPrices[_tokenId],      
1476             lastPriceRecord.price,   
1477             lastPriceRecord.timestamp           
1478         );
1479     }
1480 
1481     function getAssetStaticInfo(uint256 _tokenId)  external
1482         view
1483         returns
1484     (
1485         string memory title,            
1486         string memory tokenURI,    
1487         address creator,            
1488         uint256 initialPrice,       
1489         uint256 createdDate
1490     ) {
1491         require(exists(_tokenId));      
1492         RecordKeeping.priceRecord memory initialPriceRecord = initialPriceRecords[_tokenId];
1493 
1494         return (
1495              
1496             tokenTitles[_tokenId],        
1497             tokenURIs[_tokenId],
1498             initialPriceRecord.owner,
1499             initialPriceRecord.price,         
1500             initialPriceRecord.timestamp
1501         );
1502          
1503     }
1504 
1505     function burnExchangeToken(address _tokenOwner, uint256 _tokenId) external  {
1506         require(msg.sender == stemTokenContractAddress);       
1507         _burn(_tokenOwner, _tokenId);       
1508         emit Burn(_tokenOwner, _tokenId);
1509     }
1510 
1511     function findAuctionContractIndex(address _addressToFind) public view returns (int)  {
1512         
1513         for (int i = 0; i < int(auctionContractAddresses.length); i++){
1514             if (auctionContractAddresses[uint256(i)] == _addressToFind){
1515                 return i;
1516             }
1517         }
1518         return -1;
1519     }
1520 
1521     function addAuctionContractAddress(address _auctionContractAddress) public onlyOwner {
1522         require(findAuctionContractIndex(_auctionContractAddress) == -1);
1523         auctionContractAddresses.push(_auctionContractAddress);
1524     }
1525 
1526     function removeAuctionContractAddress(address _auctionContractAddress) public onlyOwner {
1527         int index = findAuctionContractIndex(_auctionContractAddress);
1528         require(index >= 0);        
1529 
1530         for (uint i = uint(index); i < auctionContractAddresses.length-1; i++){
1531             auctionContractAddresses[i] = auctionContractAddresses[i+1];         
1532         }
1533         auctionContractAddresses.length--;
1534     }
1535 
1536     function setStemTokenContractAddress(address _stemTokenContractAddress) public onlyOwner {        
1537         stemTokenContractAddress = _stemTokenContractAddress;
1538     }          
1539    
1540 
1541     function tokenURI(uint256 _tokenId) public view returns (string memory) {
1542         require(exists(_tokenId));   
1543         return string(abi.encodePacked(uriPrefix, uint256ToString(_tokenId)));
1544 
1545     }
1546     // Functions used for generating the URI
1547     function amountOfZeros(uint256 num, uint256 base) public pure returns(uint256){
1548         uint256 result = 0;
1549         num /= base;
1550         while (num > 0){
1551             num /= base;
1552             result += 1;
1553         }
1554         return result;
1555     }
1556 
1557       function uint256ToString(uint256 num) public pure returns(string memory){
1558         if (num == 0){
1559             return "0";
1560         }
1561         uint256 numLen = amountOfZeros(num, 10) + 1;
1562         bytes memory result = new bytes(numLen);
1563         while(num != 0){
1564             numLen -= 1;
1565             result[numLen] = byte(uint8((num - (num / 10 * 10)) + 48));
1566             num /= 10;
1567         }
1568         return string(result);
1569     }
1570 
1571 }