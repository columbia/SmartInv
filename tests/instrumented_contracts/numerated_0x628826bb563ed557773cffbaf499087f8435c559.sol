1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param _interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 _interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 
24 
25 /**
26  * @title ERC721 Non-Fungible Token Standard basic interface
27  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28  */
29 contract ERC721Basic is ERC165 {
30 
31   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
32   /*
33    * 0x80ac58cd ===
34    *   bytes4(keccak256('balanceOf(address)')) ^
35    *   bytes4(keccak256('ownerOf(uint256)')) ^
36    *   bytes4(keccak256('approve(address,uint256)')) ^
37    *   bytes4(keccak256('getApproved(uint256)')) ^
38    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
39    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
40    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
41    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
42    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
43    */
44 
45   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
46   /*
47    * 0x4f558e79 ===
48    *   bytes4(keccak256('exists(uint256)'))
49    */
50 
51   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
52   /**
53    * 0x780e9d63 ===
54    *   bytes4(keccak256('totalSupply()')) ^
55    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
56    *   bytes4(keccak256('tokenByIndex(uint256)'))
57    */
58 
59   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
60   /**
61    * 0x5b5e139f ===
62    *   bytes4(keccak256('name()')) ^
63    *   bytes4(keccak256('symbol()')) ^
64    *   bytes4(keccak256('tokenURI(uint256)'))
65    */
66 
67   event Transfer(
68     address indexed _from,
69     address indexed _to,
70     uint256 indexed _tokenId
71   );
72   event Approval(
73     address indexed _owner,
74     address indexed _approved,
75     uint256 indexed _tokenId
76   );
77   event ApprovalForAll(
78     address indexed _owner,
79     address indexed _operator,
80     bool _approved
81   );
82 
83   function balanceOf(address _owner) public view returns (uint256 _balance);
84   function ownerOf(uint256 _tokenId) public view returns (address _owner);
85   function exists(uint256 _tokenId) public view returns (bool _exists);
86 
87   function approve(address _to, uint256 _tokenId) public;
88   function getApproved(uint256 _tokenId)
89     public view returns (address _operator);
90 
91   function setApprovalForAll(address _operator, bool _approved) public;
92   function isApprovedForAll(address _owner, address _operator)
93     public view returns (bool);
94 
95   function transferFrom(address _from, address _to, uint256 _tokenId) public;
96   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
97     public;
98 
99   function safeTransferFrom(
100     address _from,
101     address _to,
102     uint256 _tokenId,
103     bytes _data
104   )
105     public;
106 }
107 
108 
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116   address public owner;
117 
118 
119   event OwnershipRenounced(address indexed previousOwner);
120   event OwnershipTransferred(
121     address indexed previousOwner,
122     address indexed newOwner
123   );
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   constructor() public {
131     owner = msg.sender;
132   }
133 
134   /**
135    * @dev Throws if called by any account other than the owner.
136    */
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 
142   /**
143    * @dev Allows the current owner to relinquish control of the contract.
144    * @notice Renouncing to ownership will leave the contract without an owner.
145    * It will not be possible to call the functions with the `onlyOwner`
146    * modifier anymore.
147    */
148   function renounceOwnership() public onlyOwner {
149     emit OwnershipRenounced(owner);
150     owner = address(0);
151   }
152 
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param _newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address _newOwner) public onlyOwner {
158     _transferOwnership(_newOwner);
159   }
160 
161   /**
162    * @dev Transfers control of the contract to a newOwner.
163    * @param _newOwner The address to transfer ownership to.
164    */
165   function _transferOwnership(address _newOwner) internal {
166     require(_newOwner != address(0));
167     emit OwnershipTransferred(owner, _newOwner);
168     owner = _newOwner;
169   }
170 }
171 
172 
173 
174 
175 
176 
177 
178 
179 
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
182  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
183  */
184 contract ERC721Enumerable is ERC721Basic {
185   function totalSupply() public view returns (uint256);
186   function tokenOfOwnerByIndex(
187     address _owner,
188     uint256 _index
189   )
190     public
191     view
192     returns (uint256 _tokenId);
193 
194   function tokenByIndex(uint256 _index) public view returns (uint256);
195 }
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
201  */
202 contract ERC721Metadata is ERC721Basic {
203   function name() external view returns (string _name);
204   function symbol() external view returns (string _symbol);
205   function tokenURI(uint256 _tokenId) public view returns (string);
206 }
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
211  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
212  */
213 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
214 }
215 
216 
217 
218 
219 
220 
221 
222 /**
223  * @title ERC721 token receiver interface
224  * @dev Interface for any contract that wants to support safeTransfers
225  * from ERC721 asset contracts.
226  */
227 contract ERC721Receiver {
228   /**
229    * @dev Magic value to be returned upon successful reception of an NFT
230    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
231    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
232    */
233   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
234 
235   /**
236    * @notice Handle the receipt of an NFT
237    * @dev The ERC721 smart contract calls this function on the recipient
238    * after a `safetransfer`. This function MAY throw to revert and reject the
239    * transfer. Return of other than the magic value MUST result in the
240    * transaction being reverted.
241    * Note: the contract address is always the message sender.
242    * @param _operator The address which called `safeTransferFrom` function
243    * @param _from The address which previously owned the token
244    * @param _tokenId The NFT identifier which is being transferred
245    * @param _data Additional data with no specified format
246    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
247    */
248   function onERC721Received(
249     address _operator,
250     address _from,
251     uint256 _tokenId,
252     bytes _data
253   )
254     public
255     returns(bytes4);
256 }
257 
258 
259 
260 
261 /**
262  * @title SafeMath
263  * @dev Math operations with safety checks that throw on error
264  */
265 library SafeMath {
266 
267   /**
268   * @dev Multiplies two numbers, throws on overflow.
269   */
270   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
271     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
272     // benefit is lost if 'b' is also tested.
273     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
274     if (_a == 0) {
275       return 0;
276     }
277 
278     c = _a * _b;
279     assert(c / _a == _b);
280     return c;
281   }
282 
283   /**
284   * @dev Integer division of two numbers, truncating the quotient.
285   */
286   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
287     // assert(_b > 0); // Solidity automatically throws when dividing by 0
288     // uint256 c = _a / _b;
289     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
290     return _a / _b;
291   }
292 
293   /**
294   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
295   */
296   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
297     assert(_b <= _a);
298     return _a - _b;
299   }
300 
301   /**
302   * @dev Adds two numbers, throws on overflow.
303   */
304   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
305     c = _a + _b;
306     assert(c >= _a);
307     return c;
308   }
309 }
310 
311 
312 
313 
314 /**
315  * Utility library of inline functions on addresses
316  */
317 library AddressUtils {
318 
319   /**
320    * Returns whether the target address is a contract
321    * @dev This function will return false if invoked during the constructor of a contract,
322    * as the code is not actually created until after the constructor finishes.
323    * @param _addr address to check
324    * @return whether the target address is a contract
325    */
326   function isContract(address _addr) internal view returns (bool) {
327     uint256 size;
328     // XXX Currently there is no better way to check if there is a contract in an address
329     // than to check the size of the code at that address.
330     // See https://ethereum.stackexchange.com/a/14016/36603
331     // for more details about how this works.
332     // TODO Check this again before the Serenity release, because all addresses will be
333     // contracts then.
334     // solium-disable-next-line security/no-inline-assembly
335     assembly { size := extcodesize(_addr) }
336     return size > 0;
337   }
338 
339 }
340 
341 
342 
343 /**
344  * @title SupportsInterfaceWithLookup
345  * @author Matt Condon (@shrugs)
346  * @dev Implements ERC165 using a lookup table.
347  */
348 contract SupportsInterfaceWithLookup is ERC165 {
349 
350   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
351   /**
352    * 0x01ffc9a7 ===
353    *   bytes4(keccak256('supportsInterface(bytes4)'))
354    */
355 
356   /**
357    * @dev a mapping of interface id to whether or not it's supported
358    */
359   mapping(bytes4 => bool) internal supportedInterfaces;
360 
361   /**
362    * @dev A contract implementing SupportsInterfaceWithLookup
363    * implement ERC165 itself
364    */
365   constructor()
366     public
367   {
368     _registerInterface(InterfaceId_ERC165);
369   }
370 
371   /**
372    * @dev implement supportsInterface(bytes4) using a lookup table
373    */
374   function supportsInterface(bytes4 _interfaceId)
375     external
376     view
377     returns (bool)
378   {
379     return supportedInterfaces[_interfaceId];
380   }
381 
382   /**
383    * @dev private method for registering an interface
384    */
385   function _registerInterface(bytes4 _interfaceId)
386     internal
387   {
388     require(_interfaceId != 0xffffffff);
389     supportedInterfaces[_interfaceId] = true;
390   }
391 }
392 
393 
394 
395 /**
396  * @title ERC721 Non-Fungible Token Standard basic implementation
397  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
398  */
399 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
400 
401   using SafeMath for uint256;
402   using AddressUtils for address;
403 
404   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
405   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
406   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
407 
408   // Mapping from token ID to owner
409   mapping (uint256 => address) internal tokenOwner;
410 
411   // Mapping from token ID to approved address
412   mapping (uint256 => address) internal tokenApprovals;
413 
414   // Mapping from owner to number of owned token
415   mapping (address => uint256) internal ownedTokensCount;
416 
417   // Mapping from owner to operator approvals
418   mapping (address => mapping (address => bool)) internal operatorApprovals;
419 
420   constructor()
421     public
422   {
423     // register the supported interfaces to conform to ERC721 via ERC165
424     _registerInterface(InterfaceId_ERC721);
425     _registerInterface(InterfaceId_ERC721Exists);
426   }
427 
428   /**
429    * @dev Gets the balance of the specified address
430    * @param _owner address to query the balance of
431    * @return uint256 representing the amount owned by the passed address
432    */
433   function balanceOf(address _owner) public view returns (uint256) {
434     require(_owner != address(0));
435     return ownedTokensCount[_owner];
436   }
437 
438   /**
439    * @dev Gets the owner of the specified token ID
440    * @param _tokenId uint256 ID of the token to query the owner of
441    * @return owner address currently marked as the owner of the given token ID
442    */
443   function ownerOf(uint256 _tokenId) public view returns (address) {
444     address owner = tokenOwner[_tokenId];
445     require(owner != address(0));
446     return owner;
447   }
448 
449   /**
450    * @dev Returns whether the specified token exists
451    * @param _tokenId uint256 ID of the token to query the existence of
452    * @return whether the token exists
453    */
454   function exists(uint256 _tokenId) public view returns (bool) {
455     address owner = tokenOwner[_tokenId];
456     return owner != address(0);
457   }
458 
459   /**
460    * @dev Approves another address to transfer the given token ID
461    * The zero address indicates there is no approved address.
462    * There can only be one approved address per token at a given time.
463    * Can only be called by the token owner or an approved operator.
464    * @param _to address to be approved for the given token ID
465    * @param _tokenId uint256 ID of the token to be approved
466    */
467   function approve(address _to, uint256 _tokenId) public {
468     address owner = ownerOf(_tokenId);
469     require(_to != owner);
470     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
471 
472     tokenApprovals[_tokenId] = _to;
473     emit Approval(owner, _to, _tokenId);
474   }
475 
476   /**
477    * @dev Gets the approved address for a token ID, or zero if no address set
478    * @param _tokenId uint256 ID of the token to query the approval of
479    * @return address currently approved for the given token ID
480    */
481   function getApproved(uint256 _tokenId) public view returns (address) {
482     return tokenApprovals[_tokenId];
483   }
484 
485   /**
486    * @dev Sets or unsets the approval of a given operator
487    * An operator is allowed to transfer all tokens of the sender on their behalf
488    * @param _to operator address to set the approval
489    * @param _approved representing the status of the approval to be set
490    */
491   function setApprovalForAll(address _to, bool _approved) public {
492     require(_to != msg.sender);
493     operatorApprovals[msg.sender][_to] = _approved;
494     emit ApprovalForAll(msg.sender, _to, _approved);
495   }
496 
497   /**
498    * @dev Tells whether an operator is approved by a given owner
499    * @param _owner owner address which you want to query the approval of
500    * @param _operator operator address which you want to query the approval of
501    * @return bool whether the given operator is approved by the given owner
502    */
503   function isApprovedForAll(
504     address _owner,
505     address _operator
506   )
507     public
508     view
509     returns (bool)
510   {
511     return operatorApprovals[_owner][_operator];
512   }
513 
514   /**
515    * @dev Transfers the ownership of a given token ID to another address
516    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
517    * Requires the msg sender to be the owner, approved, or operator
518    * @param _from current owner of the token
519    * @param _to address to receive the ownership of the given token ID
520    * @param _tokenId uint256 ID of the token to be transferred
521   */
522   function transferFrom(
523     address _from,
524     address _to,
525     uint256 _tokenId
526   )
527     public
528   {
529     require(isApprovedOrOwner(msg.sender, _tokenId));
530     require(_from != address(0));
531     require(_to != address(0));
532 
533     clearApproval(_from, _tokenId);
534     removeTokenFrom(_from, _tokenId);
535     addTokenTo(_to, _tokenId);
536 
537     emit Transfer(_from, _to, _tokenId);
538   }
539 
540   /**
541    * @dev Safely transfers the ownership of a given token ID to another address
542    * If the target address is a contract, it must implement `onERC721Received`,
543    * which is called upon a safe transfer, and return the magic value
544    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
545    * the transfer is reverted.
546    *
547    * Requires the msg sender to be the owner, approved, or operator
548    * @param _from current owner of the token
549    * @param _to address to receive the ownership of the given token ID
550    * @param _tokenId uint256 ID of the token to be transferred
551   */
552   function safeTransferFrom(
553     address _from,
554     address _to,
555     uint256 _tokenId
556   )
557     public
558   {
559     // solium-disable-next-line arg-overflow
560     safeTransferFrom(_from, _to, _tokenId, "");
561   }
562 
563   /**
564    * @dev Safely transfers the ownership of a given token ID to another address
565    * If the target address is a contract, it must implement `onERC721Received`,
566    * which is called upon a safe transfer, and return the magic value
567    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
568    * the transfer is reverted.
569    * Requires the msg sender to be the owner, approved, or operator
570    * @param _from current owner of the token
571    * @param _to address to receive the ownership of the given token ID
572    * @param _tokenId uint256 ID of the token to be transferred
573    * @param _data bytes data to send along with a safe transfer check
574    */
575   function safeTransferFrom(
576     address _from,
577     address _to,
578     uint256 _tokenId,
579     bytes _data
580   )
581     public
582   {
583     transferFrom(_from, _to, _tokenId);
584     // solium-disable-next-line arg-overflow
585     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
586   }
587 
588   /**
589    * @dev Returns whether the given spender can transfer a given token ID
590    * @param _spender address of the spender to query
591    * @param _tokenId uint256 ID of the token to be transferred
592    * @return bool whether the msg.sender is approved for the given token ID,
593    *  is an operator of the owner, or is the owner of the token
594    */
595   function isApprovedOrOwner(
596     address _spender,
597     uint256 _tokenId
598   )
599     internal
600     view
601     returns (bool)
602   {
603     address owner = ownerOf(_tokenId);
604     // Disable solium check because of
605     // https://github.com/duaraghav8/Solium/issues/175
606     // solium-disable-next-line operator-whitespace
607     return (
608       _spender == owner ||
609       getApproved(_tokenId) == _spender ||
610       isApprovedForAll(owner, _spender)
611     );
612   }
613 
614   /**
615    * @dev Internal function to mint a new token
616    * Reverts if the given token ID already exists
617    * @param _to The address that will own the minted token
618    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
619    */
620   function _mint(address _to, uint256 _tokenId) internal {
621     require(_to != address(0));
622     addTokenTo(_to, _tokenId);
623     emit Transfer(address(0), _to, _tokenId);
624   }
625 
626   /**
627    * @dev Internal function to burn a specific token
628    * Reverts if the token does not exist
629    * @param _tokenId uint256 ID of the token being burned by the msg.sender
630    */
631   function _burn(address _owner, uint256 _tokenId) internal {
632     clearApproval(_owner, _tokenId);
633     removeTokenFrom(_owner, _tokenId);
634     emit Transfer(_owner, address(0), _tokenId);
635   }
636 
637   /**
638    * @dev Internal function to clear current approval of a given token ID
639    * Reverts if the given address is not indeed the owner of the token
640    * @param _owner owner of the token
641    * @param _tokenId uint256 ID of the token to be transferred
642    */
643   function clearApproval(address _owner, uint256 _tokenId) internal {
644     require(ownerOf(_tokenId) == _owner);
645     if (tokenApprovals[_tokenId] != address(0)) {
646       tokenApprovals[_tokenId] = address(0);
647     }
648   }
649 
650   /**
651    * @dev Internal function to add a token ID to the list of a given address
652    * @param _to address representing the new owner of the given token ID
653    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
654    */
655   function addTokenTo(address _to, uint256 _tokenId) internal {
656     require(tokenOwner[_tokenId] == address(0));
657     tokenOwner[_tokenId] = _to;
658     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
659   }
660 
661   /**
662    * @dev Internal function to remove a token ID from the list of a given address
663    * @param _from address representing the previous owner of the given token ID
664    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
665    */
666   function removeTokenFrom(address _from, uint256 _tokenId) internal {
667     require(ownerOf(_tokenId) == _from);
668     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
669     tokenOwner[_tokenId] = address(0);
670   }
671 
672   /**
673    * @dev Internal function to invoke `onERC721Received` on a target address
674    * The call is not executed if the target address is not a contract
675    * @param _from address representing the previous owner of the given token ID
676    * @param _to target address that will receive the tokens
677    * @param _tokenId uint256 ID of the token to be transferred
678    * @param _data bytes optional data to send along with the call
679    * @return whether the call correctly returned the expected magic value
680    */
681   function checkAndCallSafeTransfer(
682     address _from,
683     address _to,
684     uint256 _tokenId,
685     bytes _data
686   )
687     internal
688     returns (bool)
689   {
690     if (!_to.isContract()) {
691       return true;
692     }
693     bytes4 retval = ERC721Receiver(_to).onERC721Received(
694       msg.sender, _from, _tokenId, _data);
695     return (retval == ERC721_RECEIVED);
696   }
697 }
698 
699 
700 
701 
702 /**
703  * @title Full ERC721 Token
704  * This implementation includes all the required and some optional functionality of the ERC721 standard
705  * Moreover, it includes approve all functionality using operator terminology
706  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
707  */
708 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
709 
710   // Token name
711   string internal name_;
712 
713   // Token symbol
714   string internal symbol_;
715 
716   // Mapping from owner to list of owned token IDs
717   mapping(address => uint256[]) internal ownedTokens;
718 
719   // Mapping from token ID to index of the owner tokens list
720   mapping(uint256 => uint256) internal ownedTokensIndex;
721 
722   // Array with all token ids, used for enumeration
723   uint256[] internal allTokens;
724 
725   // Mapping from token id to position in the allTokens array
726   mapping(uint256 => uint256) internal allTokensIndex;
727 
728   // Optional mapping for token URIs
729   mapping(uint256 => string) internal tokenURIs;
730 
731   /**
732    * @dev Constructor function
733    */
734   constructor(string _name, string _symbol) public {
735     name_ = _name;
736     symbol_ = _symbol;
737 
738     // register the supported interfaces to conform to ERC721 via ERC165
739     _registerInterface(InterfaceId_ERC721Enumerable);
740     _registerInterface(InterfaceId_ERC721Metadata);
741   }
742 
743   /**
744    * @dev Gets the token name
745    * @return string representing the token name
746    */
747   function name() external view returns (string) {
748     return name_;
749   }
750 
751   /**
752    * @dev Gets the token symbol
753    * @return string representing the token symbol
754    */
755   function symbol() external view returns (string) {
756     return symbol_;
757   }
758 
759   /**
760    * @dev Returns an URI for a given token ID
761    * Throws if the token ID does not exist. May return an empty string.
762    * @param _tokenId uint256 ID of the token to query
763    */
764   function tokenURI(uint256 _tokenId) public view returns (string) {
765     require(exists(_tokenId));
766     return tokenURIs[_tokenId];
767   }
768 
769   /**
770    * @dev Gets the token ID at a given index of the tokens list of the requested owner
771    * @param _owner address owning the tokens list to be accessed
772    * @param _index uint256 representing the index to be accessed of the requested tokens list
773    * @return uint256 token ID at the given index of the tokens list owned by the requested address
774    */
775   function tokenOfOwnerByIndex(
776     address _owner,
777     uint256 _index
778   )
779     public
780     view
781     returns (uint256)
782   {
783     require(_index < balanceOf(_owner));
784     return ownedTokens[_owner][_index];
785   }
786 
787   /**
788    * @dev Gets the total amount of tokens stored by the contract
789    * @return uint256 representing the total amount of tokens
790    */
791   function totalSupply() public view returns (uint256) {
792     return allTokens.length;
793   }
794 
795   /**
796    * @dev Gets the token ID at a given index of all the tokens in this contract
797    * Reverts if the index is greater or equal to the total number of tokens
798    * @param _index uint256 representing the index to be accessed of the tokens list
799    * @return uint256 token ID at the given index of the tokens list
800    */
801   function tokenByIndex(uint256 _index) public view returns (uint256) {
802     require(_index < totalSupply());
803     return allTokens[_index];
804   }
805 
806   /**
807    * @dev Internal function to set the token URI for a given token
808    * Reverts if the token ID does not exist
809    * @param _tokenId uint256 ID of the token to set its URI
810    * @param _uri string URI to assign
811    */
812   function _setTokenURI(uint256 _tokenId, string _uri) internal {
813     require(exists(_tokenId));
814     tokenURIs[_tokenId] = _uri;
815   }
816 
817   /**
818    * @dev Internal function to add a token ID to the list of a given address
819    * @param _to address representing the new owner of the given token ID
820    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
821    */
822   function addTokenTo(address _to, uint256 _tokenId) internal {
823     super.addTokenTo(_to, _tokenId);
824     uint256 length = ownedTokens[_to].length;
825     ownedTokens[_to].push(_tokenId);
826     ownedTokensIndex[_tokenId] = length;
827   }
828 
829   /**
830    * @dev Internal function to remove a token ID from the list of a given address
831    * @param _from address representing the previous owner of the given token ID
832    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
833    */
834   function removeTokenFrom(address _from, uint256 _tokenId) internal {
835     super.removeTokenFrom(_from, _tokenId);
836 
837     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
838     // then delete the last slot.
839     uint256 tokenIndex = ownedTokensIndex[_tokenId];
840     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
841     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
842 
843     ownedTokens[_from][tokenIndex] = lastToken;
844     // This also deletes the contents at the last position of the array
845     ownedTokens[_from].length--;
846 
847     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
848     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
849     // the lastToken to the first position, and then dropping the element placed in the last position of the list
850 
851     ownedTokensIndex[_tokenId] = 0;
852     ownedTokensIndex[lastToken] = tokenIndex;
853   }
854 
855   /**
856    * @dev Internal function to mint a new token
857    * Reverts if the given token ID already exists
858    * @param _to address the beneficiary that will own the minted token
859    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
860    */
861   function _mint(address _to, uint256 _tokenId) internal {
862     super._mint(_to, _tokenId);
863 
864     allTokensIndex[_tokenId] = allTokens.length;
865     allTokens.push(_tokenId);
866   }
867 
868   /**
869    * @dev Internal function to burn a specific token
870    * Reverts if the token does not exist
871    * @param _owner owner of the token to burn
872    * @param _tokenId uint256 ID of the token being burned by the msg.sender
873    */
874   function _burn(address _owner, uint256 _tokenId) internal {
875     super._burn(_owner, _tokenId);
876 
877     // Clear metadata (if any)
878     if (bytes(tokenURIs[_tokenId]).length != 0) {
879       delete tokenURIs[_tokenId];
880     }
881 
882     // Reorg all tokens array
883     uint256 tokenIndex = allTokensIndex[_tokenId];
884     uint256 lastTokenIndex = allTokens.length.sub(1);
885     uint256 lastToken = allTokens[lastTokenIndex];
886 
887     allTokens[tokenIndex] = lastToken;
888     allTokens[lastTokenIndex] = 0;
889 
890     allTokens.length--;
891     allTokensIndex[_tokenId] = 0;
892     allTokensIndex[lastToken] = tokenIndex;
893   }
894 
895 }
896 
897 
898 
899 
900 contract RoxBase is ERC721Token, Ownable {
901     event SeedChange(uint256 tokenId, string seed);
902     event remixCountChange(uint256 tokenId, uint256 amount);
903     event ParentsSets(uint256 tokenId, uint256 parent1, uint256 parent2);
904 
905     address minter;
906 
907     // Storage of the commission address.
908     address public commissionAddress;
909 
910     // Template for MetaData
911     struct metaData {
912         string seed;
913         uint parent1;
914         uint parent2;
915         uint remixCount;
916     }
917 
918     modifier onlyApprovedContractAddresses () {
919         // Used to require that the sender is an approved address.
920         require(ApprovedContractAddress[msg.sender] == true);
921         _;
922     }
923 
924     modifier onlyMinter () {
925         require(minter == msg.sender);
926         _;
927     }
928 
929     // Storage for Approve contract address
930     mapping (address => bool) ApprovedContractAddress;
931     // Storage for token metaDatas
932     mapping (uint256 => metaData) tokenToMetaData;
933     // Next available id (was count but that breaks if you burn a token).
934     uint nextId = 0;
935     // HostName for view of token(e.g. https://cryptorox.co/api/v1/)
936     string URIToken;
937 
938     /**
939     * @dev Overrides the default burn function to delete the token's meta data as well.
940     */
941     function _burn (uint256 _tokenId) internal {
942         delete tokenToMetaData[_tokenId];
943         super._burn(ownerOf(_tokenId), _tokenId);
944     }
945 
946     // Mints / Creates a new token with a given seed
947     /**
948     * @dev Internal Mints a token.
949     * @return New token's Id
950     */
951     function _mint(address _to, string _seed) internal returns (uint256){
952         uint256 newTokenId = nextId;
953         super._mint(_to, newTokenId);
954         _setTokenSeed(newTokenId, _seed);
955         nextId = nextId + 1;
956         return newTokenId;
957     }
958 
959     /**
960     * @dev Internal Sets token id to a seed.
961     */
962     function _setTokenSeed(uint256 _tokenId, string _seed) private  {
963         tokenToMetaData[_tokenId].seed = _seed;
964         emit SeedChange(uint(_tokenId), string(_seed));
965     }
966 }
967 
968 
969 /**
970  * @title RoxOnlyMinterMethods
971  * @dev Only Methods that can be called by the minter of the contract.
972  */
973 contract RoxOnlyMinterMethods is RoxBase {
974     /**
975     * @dev Mints a new token with a seed.
976     */
977     function mintTo(address _to, string seed) external onlyMinter returns (uint) {
978         return _mint(_to, seed);
979     }
980 }
981 
982 
983 /**
984  * @title RoxOnlyOwnerMethods
985  * @dev Only Methods that can be called by the owner of the contract.
986  */
987 contract RoxOnlyOwnerMethods is RoxBase {
988     /**
989     * @dev Sets the Approved value for contract address.
990     */
991     function setApprovedContractAddress (address _contractAddress, bool _value) public onlyOwner {
992         ApprovedContractAddress[_contractAddress] = _value;
993     }
994 
995     function kill() public onlyOwner {
996         selfdestruct(msg.sender);
997     }
998 
999     /**
1000     * @dev Sets base uriToken.
1001     */
1002     function setURIToken(string _uriToken) public onlyOwner {
1003         URIToken = _uriToken;
1004     }
1005 
1006     /**
1007     * @dev Sets the new commission address.
1008     */
1009     function setCommissionAddress (address _commissionAddress) public onlyOwner {
1010         commissionAddress = _commissionAddress;
1011     }
1012     /**
1013     * @dev Sets the minter's Address
1014     */
1015     function setMinterAddress (address _minterAddress) public onlyOwner{
1016         minter = _minterAddress;
1017     }
1018 
1019     /**
1020     * @dev Burns a token.
1021     */
1022     function adminBurnToken(uint256 _tokenId) public onlyOwner {
1023         _burn(_tokenId);
1024     }
1025 }
1026 
1027 /**
1028  * @title RoxAuthorisedContractMethods
1029  * @dev All methods that can be ran by authorised contract addresses.
1030  */
1031 contract RoxAuthorisedContractMethods is RoxBase {
1032     // All these methods are ran via external authorised contracts.
1033 
1034     /**
1035     * @dev Burns a token.
1036     */
1037     function burnToken(uint256 _tokenId) public onlyApprovedContractAddresses {
1038         _burn(_tokenId);
1039     }
1040 
1041     /**
1042     * @dev Mints a new token.
1043     */
1044     function mintToPublic(address _to, string _seed) external onlyApprovedContractAddresses returns (uint) {
1045         return _mint(_to, _seed);
1046     }
1047 
1048 
1049     /**
1050     * @dev Sets the parents of a token.
1051     */
1052     function setParents(uint _tokenId, uint _parent1, uint _parent2) public onlyApprovedContractAddresses {
1053         tokenToMetaData[_tokenId].parent1 = _parent1;
1054         tokenToMetaData[_tokenId].parent2 = _parent2;
1055         emit ParentsSets(_tokenId, _parent1, _parent2);
1056 
1057     }
1058 
1059     /**
1060     * @dev Sets owner of token to given value.
1061     */
1062     function setTokenOwner(address _to, uint _tokenId) public onlyApprovedContractAddresses{
1063         tokenOwner[_tokenId] = _to;
1064     }
1065 
1066     /**
1067     * @dev Sets the seed of a given token.
1068     */
1069     function setTokenSeed(uint256 _tokenId, string _seed) public onlyApprovedContractAddresses {
1070         tokenToMetaData[_tokenId].seed = _seed;
1071         emit SeedChange(uint(_tokenId), string(_seed));
1072     }
1073 
1074     /**
1075     * @dev Sets the remixCount of a token
1076     */
1077     function setRemixCount(uint256 _tokenId, uint _remixCount) public onlyApprovedContractAddresses {
1078         tokenToMetaData[_tokenId].remixCount =_remixCount;
1079         emit remixCountChange(_tokenId, _remixCount);
1080     }
1081 }
1082 
1083 /**
1084  * @title RoxPublicGetters
1085  * @dev All public getter rox methods.
1086  */
1087 contract RoxPublicGetters is RoxBase {
1088     /**
1089     * @dev Returns tokens for an address.
1090     * @return uint[] of tokens owned by an address.
1091     */
1092     function getTokensForOwner (address _owner) public view returns (uint[]) {
1093         return ownedTokens[_owner];
1094     }
1095 
1096     /**
1097     * @dev Returns the data about a token.
1098     */
1099     function getDataForTokenId(uint256 _tokenId) public view returns
1100     (
1101         uint,
1102         string,
1103         uint,
1104         uint,
1105         address,
1106         address,
1107         uint
1108     )
1109     {
1110          metaData storage meta = tokenToMetaData[_tokenId];
1111         return (
1112             _tokenId,
1113             meta.seed,
1114             meta.parent1,
1115             meta.parent2,
1116             ownerOf(_tokenId),
1117             getApproved(_tokenId),
1118             meta.remixCount
1119         );
1120     }
1121 
1122         /**
1123     * @dev Returns a seed for a token id.
1124     * @return string the seed for the token id.
1125     */
1126     function getSeedForTokenId(uint256 _tokenId) public view returns (string) {
1127         return tokenToMetaData[_tokenId].seed;
1128     }
1129 
1130     /**
1131     * @dev Gets the remix count for a given token
1132     * @return The remix count for a given token
1133     */
1134     function getRemixCount(uint256 _tokenId) public view returns (uint) {
1135         return tokenToMetaData[_tokenId].remixCount;
1136     }
1137 
1138     /**
1139     * @dev Returns the parents for token id
1140     * @return TUPLE of the parent ids for a token.
1141     */
1142     function getParentsForTokenId(uint256 _tokenId) public view returns (uint parent1, uint parent2) {
1143         metaData storage meta = tokenToMetaData[_tokenId];
1144         return (
1145             meta.parent1,
1146             meta.parent2
1147         );
1148     }
1149 
1150     // Converts uint to a string
1151     function uint2str(uint i) internal pure returns (string){
1152         if (i == 0) return "0";
1153         uint j = i;
1154         uint length;
1155         while (j != 0){
1156             length++;
1157             j /= 10;
1158         }
1159         bytes memory bstr = new bytes(length);
1160         uint k = length - 1;
1161         while (i != 0){
1162             bstr[k--] = byte(48 + i % 10);
1163             i /= 10;
1164         }
1165         return string(bstr);
1166     }
1167 
1168 
1169     /**
1170     * @dev Returns the Token uri for a token
1171     * @return Token URI for a token ID.
1172     */
1173     function tokenURI(uint256 _tokenId) public view returns (string) {
1174         return string(abi.encodePacked(URIToken, uint2str(_tokenId)));
1175     }
1176 
1177 }
1178 
1179 
1180 /**
1181  * @title Rox
1182  * @dev Full rox Contract with all imports.
1183  */
1184 contract Rox is RoxOnlyOwnerMethods, RoxPublicGetters, RoxAuthorisedContractMethods, RoxOnlyMinterMethods {
1185     // Creates an instance of the contract
1186     constructor (string _name, string _symbol, string _uriToken) public ERC721Token(_name, _symbol) {
1187         URIToken = _uriToken;
1188     }
1189 
1190 }