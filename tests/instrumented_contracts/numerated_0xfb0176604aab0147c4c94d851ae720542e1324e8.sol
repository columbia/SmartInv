1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface ERC165 {
9 
10   /**
11    * @notice Query if a contract implements an interface
12    * @param _interfaceId The interface identifier, as specified in ERC-165
13    * @dev Interface identification is specified in ERC-165. This function
14    * uses less than 30,000 gas.
15    */
16   function supportsInterface(bytes4 _interfaceId)
17     external
18     view
19     returns (bool);
20 }
21 
22 
23 /**
24  * @title ERC721 Non-Fungible Token Standard basic interface
25  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
26  */
27 contract ERC721Basic is ERC165 {
28 
29   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
30   /*
31    * 0x80ac58cd ===
32    *   bytes4(keccak256('balanceOf(address)')) ^
33    *   bytes4(keccak256('ownerOf(uint256)')) ^
34    *   bytes4(keccak256('approve(address,uint256)')) ^
35    *   bytes4(keccak256('getApproved(uint256)')) ^
36    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
37    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
38    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
39    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
40    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
41    */
42 
43   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
44   /*
45    * 0x4f558e79 ===
46    *   bytes4(keccak256('exists(uint256)'))
47    */
48 
49   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
50   /**
51    * 0x780e9d63 ===
52    *   bytes4(keccak256('totalSupply()')) ^
53    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
54    *   bytes4(keccak256('tokenByIndex(uint256)'))
55    */
56 
57   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
58   /**
59    * 0x5b5e139f ===
60    *   bytes4(keccak256('name()')) ^
61    *   bytes4(keccak256('symbol()')) ^
62    *   bytes4(keccak256('tokenURI(uint256)'))
63    */
64 
65   event Transfer(
66     address indexed _from,
67     address indexed _to,
68     uint256 indexed _tokenId
69   );
70   event Approval(
71     address indexed _owner,
72     address indexed _approved,
73     uint256 indexed _tokenId
74   );
75   event ApprovalForAll(
76     address indexed _owner,
77     address indexed _operator,
78     bool _approved
79   );
80 
81   function balanceOf(address _owner) public view returns (uint256 _balance);
82   function ownerOf(uint256 _tokenId) public view returns (address _owner);
83   function exists(uint256 _tokenId) public view returns (bool _exists);
84 
85   function approve(address _to, uint256 _tokenId) public;
86   function getApproved(uint256 _tokenId)
87     public view returns (address _operator);
88 
89   function setApprovalForAll(address _operator, bool _approved) public;
90   function isApprovedForAll(address _owner, address _operator)
91     public view returns (bool);
92 
93   function transferFrom(address _from, address _to, uint256 _tokenId) public;
94   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
95     public;
96 
97   function safeTransferFrom(
98     address _from,
99     address _to,
100     uint256 _tokenId,
101     bytes _data
102   )
103     public;
104 }
105 
106 
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract has an owner address, and provides basic authorization control
111  * functions, this simplifies the implementation of "user permissions".
112  */
113 contract Ownable {
114   address public owner;
115 
116 
117   event OwnershipRenounced(address indexed previousOwner);
118   event OwnershipTransferred(
119     address indexed previousOwner,
120     address indexed newOwner
121   );
122 
123 
124   /**
125    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126    * account.
127    */
128   constructor() public {
129     owner = msg.sender;
130   }
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140   /**
141    * @dev Allows the current owner to relinquish control of the contract.
142    * @notice Renouncing to ownership will leave the contract without an owner.
143    * It will not be possible to call the functions with the `onlyOwner`
144    * modifier anymore.
145    */
146   function renounceOwnership() public onlyOwner {
147     emit OwnershipRenounced(owner);
148     owner = address(0);
149   }
150 
151   /**
152    * @dev Allows the current owner to transfer control of the contract to a newOwner.
153    * @param _newOwner The address to transfer ownership to.
154    */
155   function transferOwnership(address _newOwner) public onlyOwner {
156     _transferOwnership(_newOwner);
157   }
158 
159   /**
160    * @dev Transfers control of the contract to a newOwner.
161    * @param _newOwner The address to transfer ownership to.
162    */
163   function _transferOwnership(address _newOwner) internal {
164     require(_newOwner != address(0));
165     emit OwnershipTransferred(owner, _newOwner);
166     owner = _newOwner;
167   }
168 }
169 
170 
171 
172 
173 
174 
175 
176 
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
180  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
181  */
182 contract ERC721Enumerable is ERC721Basic {
183   function totalSupply() public view returns (uint256);
184   function tokenOfOwnerByIndex(
185     address _owner,
186     uint256 _index
187   )
188     public
189     view
190     returns (uint256 _tokenId);
191 
192   function tokenByIndex(uint256 _index) public view returns (uint256);
193 }
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
199  */
200 contract ERC721Metadata is ERC721Basic {
201   function name() external view returns (string _name);
202   function symbol() external view returns (string _symbol);
203   function tokenURI(uint256 _tokenId) public view returns (string);
204 }
205 
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
209  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
210  */
211 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
212 }
213 
214 
215 
216 
217 
218 
219 
220 /**
221  * @title ERC721 token receiver interface
222  * @dev Interface for any contract that wants to support safeTransfers
223  * from ERC721 asset contracts.
224  */
225 contract ERC721Receiver {
226   /**
227    * @dev Magic value to be returned upon successful reception of an NFT
228    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
229    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
230    */
231   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
232 
233   /**
234    * @notice Handle the receipt of an NFT
235    * @dev The ERC721 smart contract calls this function on the recipient
236    * after a `safetransfer`. This function MAY throw to revert and reject the
237    * transfer. Return of other than the magic value MUST result in the
238    * transaction being reverted.
239    * Note: the contract address is always the message sender.
240    * @param _operator The address which called `safeTransferFrom` function
241    * @param _from The address which previously owned the token
242    * @param _tokenId The NFT identifier which is being transferred
243    * @param _data Additional data with no specified format
244    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
245    */
246   function onERC721Received(
247     address _operator,
248     address _from,
249     uint256 _tokenId,
250     bytes _data
251   )
252     public
253     returns(bytes4);
254 }
255 
256 
257 
258 
259 /**
260  * @title SafeMath
261  * @dev Math operations with safety checks that throw on error
262  */
263 library SafeMath {
264 
265   /**
266   * @dev Multiplies two numbers, throws on overflow.
267   */
268   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
269     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
270     // benefit is lost if 'b' is also tested.
271     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
272     if (_a == 0) {
273       return 0;
274     }
275 
276     c = _a * _b;
277     assert(c / _a == _b);
278     return c;
279   }
280 
281   /**
282   * @dev Integer division of two numbers, truncating the quotient.
283   */
284   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
285     // assert(_b > 0); // Solidity automatically throws when dividing by 0
286     // uint256 c = _a / _b;
287     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
288     return _a / _b;
289   }
290 
291   /**
292   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
293   */
294   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
295     assert(_b <= _a);
296     return _a - _b;
297   }
298 
299   /**
300   * @dev Adds two numbers, throws on overflow.
301   */
302   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
303     c = _a + _b;
304     assert(c >= _a);
305     return c;
306   }
307 }
308 
309 
310 
311 
312 /**
313  * Utility library of inline functions on addresses
314  */
315 library AddressUtils {
316 
317   /**
318    * Returns whether the target address is a contract
319    * @dev This function will return false if invoked during the constructor of a contract,
320    * as the code is not actually created until after the constructor finishes.
321    * @param _addr address to check
322    * @return whether the target address is a contract
323    */
324   function isContract(address _addr) internal view returns (bool) {
325     uint256 size;
326     // XXX Currently there is no better way to check if there is a contract in an address
327     // than to check the size of the code at that address.
328     // See https://ethereum.stackexchange.com/a/14016/36603
329     // for more details about how this works.
330     // TODO Check this again before the Serenity release, because all addresses will be
331     // contracts then.
332     // solium-disable-next-line security/no-inline-assembly
333     assembly { size := extcodesize(_addr) }
334     return size > 0;
335   }
336 
337 }
338 
339 
340 
341 
342 
343 
344 
345 
346 
347 
348 /**
349  * @title SupportsInterfaceWithLookup
350  * @author Matt Condon (@shrugs)
351  * @dev Implements ERC165 using a lookup table.
352  */
353 contract SupportsInterfaceWithLookup is ERC165 {
354 
355   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
356   /**
357    * 0x01ffc9a7 ===
358    *   bytes4(keccak256('supportsInterface(bytes4)'))
359    */
360 
361   /**
362    * @dev a mapping of interface id to whether or not it's supported
363    */
364   mapping(bytes4 => bool) internal supportedInterfaces;
365 
366   /**
367    * @dev A contract implementing SupportsInterfaceWithLookup
368    * implement ERC165 itself
369    */
370   constructor()
371     public
372   {
373     _registerInterface(InterfaceId_ERC165);
374   }
375 
376   /**
377    * @dev implement supportsInterface(bytes4) using a lookup table
378    */
379   function supportsInterface(bytes4 _interfaceId)
380     external
381     view
382     returns (bool)
383   {
384     return supportedInterfaces[_interfaceId];
385   }
386 
387   /**
388    * @dev private method for registering an interface
389    */
390   function _registerInterface(bytes4 _interfaceId)
391     internal
392   {
393     require(_interfaceId != 0xffffffff);
394     supportedInterfaces[_interfaceId] = true;
395   }
396 }
397 
398 
399 
400 /**
401  * @title ERC721 Non-Fungible Token Standard basic implementation
402  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
403  */
404 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
405 
406   using SafeMath for uint256;
407   using AddressUtils for address;
408 
409   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
410   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
411   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
412 
413   // Mapping from token ID to owner
414   mapping (uint256 => address) internal tokenOwner;
415 
416   // Mapping from token ID to approved address
417   mapping (uint256 => address) internal tokenApprovals;
418 
419   // Mapping from owner to number of owned token
420   mapping (address => uint256) internal ownedTokensCount;
421 
422   // Mapping from owner to operator approvals
423   mapping (address => mapping (address => bool)) internal operatorApprovals;
424 
425   constructor()
426     public
427   {
428     // register the supported interfaces to conform to ERC721 via ERC165
429     _registerInterface(InterfaceId_ERC721);
430     _registerInterface(InterfaceId_ERC721Exists);
431   }
432 
433   /**
434    * @dev Gets the balance of the specified address
435    * @param _owner address to query the balance of
436    * @return uint256 representing the amount owned by the passed address
437    */
438   function balanceOf(address _owner) public view returns (uint256) {
439     require(_owner != address(0));
440     return ownedTokensCount[_owner];
441   }
442 
443   /**
444    * @dev Gets the owner of the specified token ID
445    * @param _tokenId uint256 ID of the token to query the owner of
446    * @return owner address currently marked as the owner of the given token ID
447    */
448   function ownerOf(uint256 _tokenId) public view returns (address) {
449     address owner = tokenOwner[_tokenId];
450     require(owner != address(0));
451     return owner;
452   }
453 
454   /**
455    * @dev Returns whether the specified token exists
456    * @param _tokenId uint256 ID of the token to query the existence of
457    * @return whether the token exists
458    */
459   function exists(uint256 _tokenId) public view returns (bool) {
460     address owner = tokenOwner[_tokenId];
461     return owner != address(0);
462   }
463 
464   /**
465    * @dev Approves another address to transfer the given token ID
466    * The zero address indicates there is no approved address.
467    * There can only be one approved address per token at a given time.
468    * Can only be called by the token owner or an approved operator.
469    * @param _to address to be approved for the given token ID
470    * @param _tokenId uint256 ID of the token to be approved
471    */
472   function approve(address _to, uint256 _tokenId) public {
473     address owner = ownerOf(_tokenId);
474     require(_to != owner);
475     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
476 
477     tokenApprovals[_tokenId] = _to;
478     emit Approval(owner, _to, _tokenId);
479   }
480 
481   /**
482    * @dev Gets the approved address for a token ID, or zero if no address set
483    * @param _tokenId uint256 ID of the token to query the approval of
484    * @return address currently approved for the given token ID
485    */
486   function getApproved(uint256 _tokenId) public view returns (address) {
487     return tokenApprovals[_tokenId];
488   }
489 
490   /**
491    * @dev Sets or unsets the approval of a given operator
492    * An operator is allowed to transfer all tokens of the sender on their behalf
493    * @param _to operator address to set the approval
494    * @param _approved representing the status of the approval to be set
495    */
496   function setApprovalForAll(address _to, bool _approved) public {
497     require(_to != msg.sender);
498     operatorApprovals[msg.sender][_to] = _approved;
499     emit ApprovalForAll(msg.sender, _to, _approved);
500   }
501 
502   /**
503    * @dev Tells whether an operator is approved by a given owner
504    * @param _owner owner address which you want to query the approval of
505    * @param _operator operator address which you want to query the approval of
506    * @return bool whether the given operator is approved by the given owner
507    */
508   function isApprovedForAll(
509     address _owner,
510     address _operator
511   )
512     public
513     view
514     returns (bool)
515   {
516     return operatorApprovals[_owner][_operator];
517   }
518 
519   /**
520    * @dev Transfers the ownership of a given token ID to another address
521    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
522    * Requires the msg sender to be the owner, approved, or operator
523    * @param _from current owner of the token
524    * @param _to address to receive the ownership of the given token ID
525    * @param _tokenId uint256 ID of the token to be transferred
526   */
527   function transferFrom(
528     address _from,
529     address _to,
530     uint256 _tokenId
531   )
532     public
533   {
534     require(isApprovedOrOwner(msg.sender, _tokenId));
535     require(_from != address(0));
536     require(_to != address(0));
537 
538     clearApproval(_from, _tokenId);
539     removeTokenFrom(_from, _tokenId);
540     addTokenTo(_to, _tokenId);
541 
542     emit Transfer(_from, _to, _tokenId);
543   }
544 
545   /**
546    * @dev Safely transfers the ownership of a given token ID to another address
547    * If the target address is a contract, it must implement `onERC721Received`,
548    * which is called upon a safe transfer, and return the magic value
549    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
550    * the transfer is reverted.
551    *
552    * Requires the msg sender to be the owner, approved, or operator
553    * @param _from current owner of the token
554    * @param _to address to receive the ownership of the given token ID
555    * @param _tokenId uint256 ID of the token to be transferred
556   */
557   function safeTransferFrom(
558     address _from,
559     address _to,
560     uint256 _tokenId
561   )
562     public
563   {
564     // solium-disable-next-line arg-overflow
565     safeTransferFrom(_from, _to, _tokenId, "");
566   }
567 
568   /**
569    * @dev Safely transfers the ownership of a given token ID to another address
570    * If the target address is a contract, it must implement `onERC721Received`,
571    * which is called upon a safe transfer, and return the magic value
572    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
573    * the transfer is reverted.
574    * Requires the msg sender to be the owner, approved, or operator
575    * @param _from current owner of the token
576    * @param _to address to receive the ownership of the given token ID
577    * @param _tokenId uint256 ID of the token to be transferred
578    * @param _data bytes data to send along with a safe transfer check
579    */
580   function safeTransferFrom(
581     address _from,
582     address _to,
583     uint256 _tokenId,
584     bytes _data
585   )
586     public
587   {
588     transferFrom(_from, _to, _tokenId);
589     // solium-disable-next-line arg-overflow
590     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
591   }
592 
593   /**
594    * @dev Returns whether the given spender can transfer a given token ID
595    * @param _spender address of the spender to query
596    * @param _tokenId uint256 ID of the token to be transferred
597    * @return bool whether the msg.sender is approved for the given token ID,
598    *  is an operator of the owner, or is the owner of the token
599    */
600   function isApprovedOrOwner(
601     address _spender,
602     uint256 _tokenId
603   )
604     internal
605     view
606     returns (bool)
607   {
608     address owner = ownerOf(_tokenId);
609     // Disable solium check because of
610     // https://github.com/duaraghav8/Solium/issues/175
611     // solium-disable-next-line operator-whitespace
612     return (
613       _spender == owner ||
614       getApproved(_tokenId) == _spender ||
615       isApprovedForAll(owner, _spender)
616     );
617   }
618 
619   /**
620    * @dev Internal function to mint a new token
621    * Reverts if the given token ID already exists
622    * @param _to The address that will own the minted token
623    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
624    */
625   function _mint(address _to, uint256 _tokenId) internal {
626     require(_to != address(0));
627     addTokenTo(_to, _tokenId);
628     emit Transfer(address(0), _to, _tokenId);
629   }
630 
631   /**
632    * @dev Internal function to burn a specific token
633    * Reverts if the token does not exist
634    * @param _tokenId uint256 ID of the token being burned by the msg.sender
635    */
636   function _burn(address _owner, uint256 _tokenId) internal {
637     clearApproval(_owner, _tokenId);
638     removeTokenFrom(_owner, _tokenId);
639     emit Transfer(_owner, address(0), _tokenId);
640   }
641 
642   /**
643    * @dev Internal function to clear current approval of a given token ID
644    * Reverts if the given address is not indeed the owner of the token
645    * @param _owner owner of the token
646    * @param _tokenId uint256 ID of the token to be transferred
647    */
648   function clearApproval(address _owner, uint256 _tokenId) internal {
649     require(ownerOf(_tokenId) == _owner);
650     if (tokenApprovals[_tokenId] != address(0)) {
651       tokenApprovals[_tokenId] = address(0);
652     }
653   }
654 
655   /**
656    * @dev Internal function to add a token ID to the list of a given address
657    * @param _to address representing the new owner of the given token ID
658    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
659    */
660   function addTokenTo(address _to, uint256 _tokenId) internal {
661     require(tokenOwner[_tokenId] == address(0));
662     tokenOwner[_tokenId] = _to;
663     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
664   }
665 
666   /**
667    * @dev Internal function to remove a token ID from the list of a given address
668    * @param _from address representing the previous owner of the given token ID
669    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
670    */
671   function removeTokenFrom(address _from, uint256 _tokenId) internal {
672     require(ownerOf(_tokenId) == _from);
673     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
674     tokenOwner[_tokenId] = address(0);
675   }
676 
677   /**
678    * @dev Internal function to invoke `onERC721Received` on a target address
679    * The call is not executed if the target address is not a contract
680    * @param _from address representing the previous owner of the given token ID
681    * @param _to target address that will receive the tokens
682    * @param _tokenId uint256 ID of the token to be transferred
683    * @param _data bytes optional data to send along with the call
684    * @return whether the call correctly returned the expected magic value
685    */
686   function checkAndCallSafeTransfer(
687     address _from,
688     address _to,
689     uint256 _tokenId,
690     bytes _data
691   )
692     internal
693     returns (bool)
694   {
695     if (!_to.isContract()) {
696       return true;
697     }
698     bytes4 retval = ERC721Receiver(_to).onERC721Received(
699       msg.sender, _from, _tokenId, _data);
700     return (retval == ERC721_RECEIVED);
701   }
702 }
703 
704 
705 
706 
707 /**
708  * @title Full ERC721 Token
709  * This implementation includes all the required and some optional functionality of the ERC721 standard
710  * Moreover, it includes approve all functionality using operator terminology
711  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
712  */
713 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
714 
715   // Token name
716   string internal name_;
717 
718   // Token symbol
719   string internal symbol_;
720 
721   // Mapping from owner to list of owned token IDs
722   mapping(address => uint256[]) internal ownedTokens;
723 
724   // Mapping from token ID to index of the owner tokens list
725   mapping(uint256 => uint256) internal ownedTokensIndex;
726 
727   // Array with all token ids, used for enumeration
728   uint256[] internal allTokens;
729 
730   // Mapping from token id to position in the allTokens array
731   mapping(uint256 => uint256) internal allTokensIndex;
732 
733   // Optional mapping for token URIs
734   mapping(uint256 => string) internal tokenURIs;
735 
736   /**
737    * @dev Constructor function
738    */
739   constructor(string _name, string _symbol) public {
740     name_ = _name;
741     symbol_ = _symbol;
742 
743     // register the supported interfaces to conform to ERC721 via ERC165
744     _registerInterface(InterfaceId_ERC721Enumerable);
745     _registerInterface(InterfaceId_ERC721Metadata);
746   }
747 
748   /**
749    * @dev Gets the token name
750    * @return string representing the token name
751    */
752   function name() external view returns (string) {
753     return name_;
754   }
755 
756   /**
757    * @dev Gets the token symbol
758    * @return string representing the token symbol
759    */
760   function symbol() external view returns (string) {
761     return symbol_;
762   }
763 
764   /**
765    * @dev Returns an URI for a given token ID
766    * Throws if the token ID does not exist. May return an empty string.
767    * @param _tokenId uint256 ID of the token to query
768    */
769   function tokenURI(uint256 _tokenId) public view returns (string) {
770     require(exists(_tokenId));
771     return tokenURIs[_tokenId];
772   }
773 
774   /**
775    * @dev Gets the token ID at a given index of the tokens list of the requested owner
776    * @param _owner address owning the tokens list to be accessed
777    * @param _index uint256 representing the index to be accessed of the requested tokens list
778    * @return uint256 token ID at the given index of the tokens list owned by the requested address
779    */
780   function tokenOfOwnerByIndex(
781     address _owner,
782     uint256 _index
783   )
784     public
785     view
786     returns (uint256)
787   {
788     require(_index < balanceOf(_owner));
789     return ownedTokens[_owner][_index];
790   }
791 
792   /**
793    * @dev Gets the total amount of tokens stored by the contract
794    * @return uint256 representing the total amount of tokens
795    */
796   function totalSupply() public view returns (uint256) {
797     return allTokens.length;
798   }
799 
800   /**
801    * @dev Gets the token ID at a given index of all the tokens in this contract
802    * Reverts if the index is greater or equal to the total number of tokens
803    * @param _index uint256 representing the index to be accessed of the tokens list
804    * @return uint256 token ID at the given index of the tokens list
805    */
806   function tokenByIndex(uint256 _index) public view returns (uint256) {
807     require(_index < totalSupply());
808     return allTokens[_index];
809   }
810 
811   /**
812    * @dev Internal function to set the token URI for a given token
813    * Reverts if the token ID does not exist
814    * @param _tokenId uint256 ID of the token to set its URI
815    * @param _uri string URI to assign
816    */
817   function _setTokenURI(uint256 _tokenId, string _uri) internal {
818     require(exists(_tokenId));
819     tokenURIs[_tokenId] = _uri;
820   }
821 
822   /**
823    * @dev Internal function to add a token ID to the list of a given address
824    * @param _to address representing the new owner of the given token ID
825    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
826    */
827   function addTokenTo(address _to, uint256 _tokenId) internal {
828     super.addTokenTo(_to, _tokenId);
829     uint256 length = ownedTokens[_to].length;
830     ownedTokens[_to].push(_tokenId);
831     ownedTokensIndex[_tokenId] = length;
832   }
833 
834   /**
835    * @dev Internal function to remove a token ID from the list of a given address
836    * @param _from address representing the previous owner of the given token ID
837    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
838    */
839   function removeTokenFrom(address _from, uint256 _tokenId) internal {
840     super.removeTokenFrom(_from, _tokenId);
841 
842     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
843     // then delete the last slot.
844     uint256 tokenIndex = ownedTokensIndex[_tokenId];
845     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
846     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
847 
848     ownedTokens[_from][tokenIndex] = lastToken;
849     // This also deletes the contents at the last position of the array
850     ownedTokens[_from].length--;
851 
852     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
853     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
854     // the lastToken to the first position, and then dropping the element placed in the last position of the list
855 
856     ownedTokensIndex[_tokenId] = 0;
857     ownedTokensIndex[lastToken] = tokenIndex;
858   }
859 
860   /**
861    * @dev Internal function to mint a new token
862    * Reverts if the given token ID already exists
863    * @param _to address the beneficiary that will own the minted token
864    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
865    */
866   function _mint(address _to, uint256 _tokenId) internal {
867     super._mint(_to, _tokenId);
868 
869     allTokensIndex[_tokenId] = allTokens.length;
870     allTokens.push(_tokenId);
871   }
872 
873   /**
874    * @dev Internal function to burn a specific token
875    * Reverts if the token does not exist
876    * @param _owner owner of the token to burn
877    * @param _tokenId uint256 ID of the token being burned by the msg.sender
878    */
879   function _burn(address _owner, uint256 _tokenId) internal {
880     super._burn(_owner, _tokenId);
881 
882     // Clear metadata (if any)
883     if (bytes(tokenURIs[_tokenId]).length != 0) {
884       delete tokenURIs[_tokenId];
885     }
886 
887     // Reorg all tokens array
888     uint256 tokenIndex = allTokensIndex[_tokenId];
889     uint256 lastTokenIndex = allTokens.length.sub(1);
890     uint256 lastToken = allTokens[lastTokenIndex];
891 
892     allTokens[tokenIndex] = lastToken;
893     allTokens[lastTokenIndex] = 0;
894 
895     allTokens.length--;
896     allTokensIndex[_tokenId] = 0;
897     allTokensIndex[lastToken] = tokenIndex;
898   }
899 
900 }
901 
902 
903 
904 
905 contract RoxBase is ERC721Token, Ownable {
906     event SeedChange(uint256 tokenId, string seed);
907     event remixCountChange(uint256 tokenId, uint256 amount);
908     event ParentsSets(uint256 tokenId, uint256 parent1, uint256 parent2);
909 
910     address minter;
911 
912     // Storage of the commission address.
913     address public commissionAddress;
914 
915     // Template for MetaData
916     struct metaData {
917         string seed;
918         uint parent1;
919         uint parent2;
920         uint remixCount;
921     }
922 
923     modifier onlyApprovedContractAddresses () {
924         // Used to require that the sender is an approved address.
925         require(ApprovedContractAddress[msg.sender] == true);
926         _;
927     }
928 
929     modifier onlyMinter () {
930         require(minter == msg.sender);
931         _;
932     }
933 
934 
935     // Storage for Approve contract address
936     mapping (address => bool) ApprovedContractAddress;
937     // Storage for token metaDatas
938     mapping (uint256 => metaData) tokenToMetaData;
939     // Next available id (was count but that breaks if you burn a token).
940     uint nextId = 0;
941     // HostName for view of token(e.g. https://cryptorox.co/api/v1/)
942     string URIToken;
943 
944     /**
945     * @dev Overrides the default burn function to delete the token's meta data as well.
946     */
947     function _burn (uint256 _tokenId) internal {
948         delete tokenToMetaData[_tokenId];
949         super._burn(ownerOf(_tokenId), _tokenId);
950     }
951 
952     // Mints / Creates a new token with a given seed
953     /**
954     * @dev Internal Mints a token.
955     * @return New token's Id
956     */
957     function _mint(address _to, string _seed) internal returns (uint256){
958         uint256 newTokenId = nextId;
959         super._mint(_to, newTokenId);
960         _setTokenSeed(newTokenId, _seed);
961         nextId = nextId + 1;
962         return newTokenId;
963     }
964 
965     /**
966     * @dev Internal Sets token id to a seed.
967     */
968     function _setTokenSeed(uint256 _tokenId, string _seed) private  {
969         tokenToMetaData[_tokenId].seed = _seed;
970         emit SeedChange(uint(_tokenId), string(_seed));
971     }
972 }
973 
974 
975 /**
976  * @title RoxOnlyMinterMethods
977  * @dev Only Methods that can be called by the minter of the contract.
978  */
979 contract RoxOnlyMinterMethods is RoxBase {
980     /**
981     * @dev Mints a new token with a seed.
982     */
983     function mintTo(address _to, string seed) external onlyMinter returns (uint) {
984         return _mint(_to, seed);
985     }
986 }
987 
988 
989 /**
990  * @title RoxOnlyOwnerMethods
991  * @dev Only Methods that can be called by the owner of the contract.
992  */
993 contract RoxOnlyOwnerMethods is RoxBase {
994     /**
995     * @dev Sets the Approved value for contract address.
996     */
997     function setApprovedContractAddress (address _contractAddress, bool _value) public onlyOwner {
998         ApprovedContractAddress[_contractAddress] = _value;
999     }
1000 
1001     /**
1002     * @dev Sets base uriToken.
1003     */
1004     function setURIToken(string _uriToken) public onlyOwner {
1005         URIToken = _uriToken;
1006     }
1007 
1008     /**
1009     * @dev Sets the new commission address.
1010     */
1011     function setCommissionAddress (address _commissionAddress) public onlyOwner {
1012         commissionAddress = _commissionAddress;
1013     }
1014     /**
1015     * @dev Sets the minter's Address
1016     */
1017     function setMinterAddress (address _minterAddress) public onlyOwner{
1018         minter = _minterAddress;
1019     }
1020 
1021     /**
1022     * @dev Burns a token.
1023     */
1024     function adminBurnToken(uint256 _tokenId) public onlyOwner {
1025         _burn(_tokenId);
1026     }
1027 }
1028 
1029 /**
1030  * @title RoxAuthorisedContractMethods
1031  * @dev All methods that can be ran by authorised contract addresses.
1032  */
1033 contract RoxAuthorisedContractMethods is RoxBase {
1034     // All these methods are ran via external authorised contracts.
1035 
1036     /**
1037     * @dev Burns a token.
1038     */
1039     function burnToken(uint256 _tokenId) public onlyApprovedContractAddresses {
1040         _burn(_tokenId);
1041     }
1042 
1043     /**
1044     * @dev Mints a new token.
1045     */
1046     function mintToPublic(address _to, string _seed) external onlyApprovedContractAddresses returns (uint) {
1047         return _mint(_to, _seed);
1048     }
1049 
1050 
1051     /**
1052     * @dev Sets the parents of a token.
1053     */
1054     function setParents(uint _tokenId, uint _parent1, uint _parent2) public onlyApprovedContractAddresses {
1055         tokenToMetaData[_tokenId].parent1 = _parent1;
1056         tokenToMetaData[_tokenId].parent2 = _parent2;
1057         emit ParentsSets(_tokenId, _parent1, _parent2);
1058 
1059     }
1060 
1061     /**
1062     * @dev Sets owner of token to given value.
1063     */
1064     function setTokenOwner(address _to, uint _tokenId) public onlyApprovedContractAddresses{
1065         tokenOwner[_tokenId] = _to;
1066     }
1067 
1068     /**
1069     * @dev Sets the seed of a given token.
1070     */
1071     function setTokenSeed(uint256 _tokenId, string _seed) public onlyApprovedContractAddresses {
1072         tokenToMetaData[_tokenId].seed = _seed;
1073         emit SeedChange(uint(_tokenId), string(_seed));
1074     }
1075 
1076     /**
1077     * @dev Sets the remixCount of a token
1078     */
1079     function setRemixCount(uint256 _tokenId, uint _remixCount) public onlyApprovedContractAddresses {
1080         tokenToMetaData[_tokenId].remixCount =_remixCount;
1081         emit remixCountChange(_tokenId, _remixCount);
1082     }
1083 }
1084 
1085 /**
1086  * @title RoxPublicGetters
1087  * @dev All public getter rox methods.
1088  */
1089 contract RoxPublicGetters is RoxBase {
1090     /**
1091     * @dev Returns tokens for an address.
1092     * @return uint[] of tokens owned by an address.
1093     */
1094     function getTokensForOwner (address _owner) public view returns (uint[]) {
1095         return ownedTokens[_owner];
1096     }
1097 
1098     /**
1099     * @dev Returns the data about a token.
1100     */
1101     function getDataForTokenId(uint256 _tokenId) public view returns
1102     (
1103         uint,
1104         string,
1105         uint,
1106         uint,
1107         address,
1108         address,
1109         uint
1110     )
1111     {
1112          metaData storage meta = tokenToMetaData[_tokenId];
1113         return (
1114             _tokenId,
1115             meta.seed,
1116             meta.parent1,
1117             meta.parent2,
1118             ownerOf(_tokenId),
1119             getApproved(_tokenId),
1120             meta.remixCount
1121         );
1122     }
1123 
1124         /**
1125     * @dev Returns a seed for a token id.
1126     * @return string the seed for the token id.
1127     */
1128     function getSeedForTokenId(uint256 _tokenId) public view returns (string) {
1129         return tokenToMetaData[_tokenId].seed;
1130     }
1131 
1132     /**
1133     * @dev Gets the remix count for a given token
1134     * @return The remix count for a given token
1135     */
1136     function getRemixCount(uint256 _tokenId) public view returns (uint) {
1137         return tokenToMetaData[_tokenId].remixCount;
1138     }
1139 
1140     /**
1141     * @dev Returns the parents for token id
1142     * @return TUPLE of the parent ids for a token.
1143     */
1144     function getParentsForTokenId(uint256 _tokenId) public view returns (uint parent1, uint parent2) {
1145         metaData storage meta = tokenToMetaData[_tokenId];
1146         return (
1147             meta.parent1,
1148             meta.parent2
1149         );
1150     }
1151 
1152     /**
1153     * @dev Returns the Token uri for a token
1154     * @return Token URI for a token ID.
1155     */
1156     function tokenURI(uint256 _tokenId) public view returns (string) {
1157         return string(abi.encodePacked(URIToken, tokenToMetaData[_tokenId].seed, ';', _tokenId));
1158     }
1159 
1160 }
1161 
1162 
1163 /**
1164  * @title Rox
1165  * @dev Full rox Contract with all imports.
1166  */
1167 contract Rox is RoxOnlyOwnerMethods, RoxPublicGetters, RoxAuthorisedContractMethods, RoxOnlyMinterMethods {
1168     // Creates an instance of the contract
1169     constructor (string _name, string _symbol, string _uriToken) public ERC721Token(_name, _symbol) {
1170         URIToken = _uriToken;
1171     }
1172 
1173 }