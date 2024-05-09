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
106 
107 /**
108  * @title Ownable
109  * @dev The Ownable contract has an owner address, and provides basic authorization control
110  * functions, this simplifies the implementation of "user permissions".
111  */
112 contract Ownable {
113   address public owner;
114 
115 
116   event OwnershipRenounced(address indexed previousOwner);
117   event OwnershipTransferred(
118     address indexed previousOwner,
119     address indexed newOwner
120   );
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   constructor() public {
128     owner = msg.sender;
129   }
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to relinquish control of the contract.
141    * @notice Renouncing to ownership will leave the contract without an owner.
142    * It will not be possible to call the functions with the `onlyOwner`
143    * modifier anymore.
144    */
145   function renounceOwnership() public onlyOwner {
146     emit OwnershipRenounced(owner);
147     owner = address(0);
148   }
149 
150   /**
151    * @dev Allows the current owner to transfer control of the contract to a newOwner.
152    * @param _newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address _newOwner) public onlyOwner {
155     _transferOwnership(_newOwner);
156   }
157 
158   /**
159    * @dev Transfers control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function _transferOwnership(address _newOwner) internal {
163     require(_newOwner != address(0));
164     emit OwnershipTransferred(owner, _newOwner);
165     owner = _newOwner;
166   }
167 }
168 
169 
170 
171 
172 
173 
174 
175 
176 
177 /**
178  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
179  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
180  */
181 contract ERC721Enumerable is ERC721Basic {
182   function totalSupply() public view returns (uint256);
183   function tokenOfOwnerByIndex(
184     address _owner,
185     uint256 _index
186   )
187     public
188     view
189     returns (uint256 _tokenId);
190 
191   function tokenByIndex(uint256 _index) public view returns (uint256);
192 }
193 
194 
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
198  */
199 contract ERC721Metadata is ERC721Basic {
200   function name() external view returns (string _name);
201   function symbol() external view returns (string _symbol);
202   function tokenURI(uint256 _tokenId) public view returns (string);
203 }
204 
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
208  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
209  */
210 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
211 }
212 
213 
214 
215 
216 
217 
218 
219 /**
220  * @title ERC721 token receiver interface
221  * @dev Interface for any contract that wants to support safeTransfers
222  * from ERC721 asset contracts.
223  */
224 contract ERC721Receiver {
225   /**
226    * @dev Magic value to be returned upon successful reception of an NFT
227    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
228    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
229    */
230   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
231 
232   /**
233    * @notice Handle the receipt of an NFT
234    * @dev The ERC721 smart contract calls this function on the recipient
235    * after a `safetransfer`. This function MAY throw to revert and reject the
236    * transfer. Return of other than the magic value MUST result in the
237    * transaction being reverted.
238    * Note: the contract address is always the message sender.
239    * @param _operator The address which called `safeTransferFrom` function
240    * @param _from The address which previously owned the token
241    * @param _tokenId The NFT identifier which is being transferred
242    * @param _data Additional data with no specified format
243    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
244    */
245   function onERC721Received(
246     address _operator,
247     address _from,
248     uint256 _tokenId,
249     bytes _data
250   )
251     public
252     returns(bytes4);
253 }
254 
255 
256 
257 
258 /**
259  * @title SafeMath
260  * @dev Math operations with safety checks that throw on error
261  */
262 library SafeMath {
263 
264   /**
265   * @dev Multiplies two numbers, throws on overflow.
266   */
267   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
268     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
269     // benefit is lost if 'b' is also tested.
270     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
271     if (_a == 0) {
272       return 0;
273     }
274 
275     c = _a * _b;
276     assert(c / _a == _b);
277     return c;
278   }
279 
280   /**
281   * @dev Integer division of two numbers, truncating the quotient.
282   */
283   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
284     // assert(_b > 0); // Solidity automatically throws when dividing by 0
285     // uint256 c = _a / _b;
286     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
287     return _a / _b;
288   }
289 
290   /**
291   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
292   */
293   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
294     assert(_b <= _a);
295     return _a - _b;
296   }
297 
298   /**
299   * @dev Adds two numbers, throws on overflow.
300   */
301   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
302     c = _a + _b;
303     assert(c >= _a);
304     return c;
305   }
306 }
307 
308 
309 
310 
311 /**
312  * Utility library of inline functions on addresses
313  */
314 library AddressUtils {
315 
316   /**
317    * Returns whether the target address is a contract
318    * @dev This function will return false if invoked during the constructor of a contract,
319    * as the code is not actually created until after the constructor finishes.
320    * @param _addr address to check
321    * @return whether the target address is a contract
322    */
323   function isContract(address _addr) internal view returns (bool) {
324     uint256 size;
325     // XXX Currently there is no better way to check if there is a contract in an address
326     // than to check the size of the code at that address.
327     // See https://ethereum.stackexchange.com/a/14016/36603
328     // for more details about how this works.
329     // TODO Check this again before the Serenity release, because all addresses will be
330     // contracts then.
331     // solium-disable-next-line security/no-inline-assembly
332     assembly { size := extcodesize(_addr) }
333     return size > 0;
334   }
335 
336 }
337 
338 
339 
340 /**
341  * @title SupportsInterfaceWithLookup
342  * @author Matt Condon (@shrugs)
343  * @dev Implements ERC165 using a lookup table.
344  */
345 contract SupportsInterfaceWithLookup is ERC165 {
346 
347   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
348   /**
349    * 0x01ffc9a7 ===
350    *   bytes4(keccak256('supportsInterface(bytes4)'))
351    */
352 
353   /**
354    * @dev a mapping of interface id to whether or not it's supported
355    */
356   mapping(bytes4 => bool) internal supportedInterfaces;
357 
358   /**
359    * @dev A contract implementing SupportsInterfaceWithLookup
360    * implement ERC165 itself
361    */
362   constructor()
363     public
364   {
365     _registerInterface(InterfaceId_ERC165);
366   }
367 
368   /**
369    * @dev implement supportsInterface(bytes4) using a lookup table
370    */
371   function supportsInterface(bytes4 _interfaceId)
372     external
373     view
374     returns (bool)
375   {
376     return supportedInterfaces[_interfaceId];
377   }
378 
379   /**
380    * @dev private method for registering an interface
381    */
382   function _registerInterface(bytes4 _interfaceId)
383     internal
384   {
385     require(_interfaceId != 0xffffffff);
386     supportedInterfaces[_interfaceId] = true;
387   }
388 }
389 
390 
391 
392 /**
393  * @title ERC721 Non-Fungible Token Standard basic implementation
394  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
395  */
396 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
397 
398   using SafeMath for uint256;
399   using AddressUtils for address;
400 
401   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
402   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
403   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
404 
405   // Mapping from token ID to owner
406   mapping (uint256 => address) internal tokenOwner;
407 
408   // Mapping from token ID to approved address
409   mapping (uint256 => address) internal tokenApprovals;
410 
411   // Mapping from owner to number of owned token
412   mapping (address => uint256) internal ownedTokensCount;
413 
414   // Mapping from owner to operator approvals
415   mapping (address => mapping (address => bool)) internal operatorApprovals;
416 
417   constructor()
418     public
419   {
420     // register the supported interfaces to conform to ERC721 via ERC165
421     _registerInterface(InterfaceId_ERC721);
422     _registerInterface(InterfaceId_ERC721Exists);
423   }
424 
425   /**
426    * @dev Gets the balance of the specified address
427    * @param _owner address to query the balance of
428    * @return uint256 representing the amount owned by the passed address
429    */
430   function balanceOf(address _owner) public view returns (uint256) {
431     require(_owner != address(0));
432     return ownedTokensCount[_owner];
433   }
434 
435   /**
436    * @dev Gets the owner of the specified token ID
437    * @param _tokenId uint256 ID of the token to query the owner of
438    * @return owner address currently marked as the owner of the given token ID
439    */
440   function ownerOf(uint256 _tokenId) public view returns (address) {
441     address owner = tokenOwner[_tokenId];
442     require(owner != address(0));
443     return owner;
444   }
445 
446   /**
447    * @dev Returns whether the specified token exists
448    * @param _tokenId uint256 ID of the token to query the existence of
449    * @return whether the token exists
450    */
451   function exists(uint256 _tokenId) public view returns (bool) {
452     address owner = tokenOwner[_tokenId];
453     return owner != address(0);
454   }
455 
456   /**
457    * @dev Approves another address to transfer the given token ID
458    * The zero address indicates there is no approved address.
459    * There can only be one approved address per token at a given time.
460    * Can only be called by the token owner or an approved operator.
461    * @param _to address to be approved for the given token ID
462    * @param _tokenId uint256 ID of the token to be approved
463    */
464   function approve(address _to, uint256 _tokenId) public {
465     address owner = ownerOf(_tokenId);
466     require(_to != owner);
467     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
468 
469     tokenApprovals[_tokenId] = _to;
470     emit Approval(owner, _to, _tokenId);
471   }
472 
473   /**
474    * @dev Gets the approved address for a token ID, or zero if no address set
475    * @param _tokenId uint256 ID of the token to query the approval of
476    * @return address currently approved for the given token ID
477    */
478   function getApproved(uint256 _tokenId) public view returns (address) {
479     return tokenApprovals[_tokenId];
480   }
481 
482   /**
483    * @dev Sets or unsets the approval of a given operator
484    * An operator is allowed to transfer all tokens of the sender on their behalf
485    * @param _to operator address to set the approval
486    * @param _approved representing the status of the approval to be set
487    */
488   function setApprovalForAll(address _to, bool _approved) public {
489     require(_to != msg.sender);
490     operatorApprovals[msg.sender][_to] = _approved;
491     emit ApprovalForAll(msg.sender, _to, _approved);
492   }
493 
494   /**
495    * @dev Tells whether an operator is approved by a given owner
496    * @param _owner owner address which you want to query the approval of
497    * @param _operator operator address which you want to query the approval of
498    * @return bool whether the given operator is approved by the given owner
499    */
500   function isApprovedForAll(
501     address _owner,
502     address _operator
503   )
504     public
505     view
506     returns (bool)
507   {
508     return operatorApprovals[_owner][_operator];
509   }
510 
511   /**
512    * @dev Transfers the ownership of a given token ID to another address
513    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
514    * Requires the msg sender to be the owner, approved, or operator
515    * @param _from current owner of the token
516    * @param _to address to receive the ownership of the given token ID
517    * @param _tokenId uint256 ID of the token to be transferred
518   */
519   function transferFrom(
520     address _from,
521     address _to,
522     uint256 _tokenId
523   )
524     public
525   {
526     require(isApprovedOrOwner(msg.sender, _tokenId));
527     require(_from != address(0));
528     require(_to != address(0));
529 
530     clearApproval(_from, _tokenId);
531     removeTokenFrom(_from, _tokenId);
532     addTokenTo(_to, _tokenId);
533 
534     emit Transfer(_from, _to, _tokenId);
535   }
536 
537   /**
538    * @dev Safely transfers the ownership of a given token ID to another address
539    * If the target address is a contract, it must implement `onERC721Received`,
540    * which is called upon a safe transfer, and return the magic value
541    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
542    * the transfer is reverted.
543    *
544    * Requires the msg sender to be the owner, approved, or operator
545    * @param _from current owner of the token
546    * @param _to address to receive the ownership of the given token ID
547    * @param _tokenId uint256 ID of the token to be transferred
548   */
549   function safeTransferFrom(
550     address _from,
551     address _to,
552     uint256 _tokenId
553   )
554     public
555   {
556     // solium-disable-next-line arg-overflow
557     safeTransferFrom(_from, _to, _tokenId, "");
558   }
559 
560   /**
561    * @dev Safely transfers the ownership of a given token ID to another address
562    * If the target address is a contract, it must implement `onERC721Received`,
563    * which is called upon a safe transfer, and return the magic value
564    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
565    * the transfer is reverted.
566    * Requires the msg sender to be the owner, approved, or operator
567    * @param _from current owner of the token
568    * @param _to address to receive the ownership of the given token ID
569    * @param _tokenId uint256 ID of the token to be transferred
570    * @param _data bytes data to send along with a safe transfer check
571    */
572   function safeTransferFrom(
573     address _from,
574     address _to,
575     uint256 _tokenId,
576     bytes _data
577   )
578     public
579   {
580     transferFrom(_from, _to, _tokenId);
581     // solium-disable-next-line arg-overflow
582     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
583   }
584 
585   /**
586    * @dev Returns whether the given spender can transfer a given token ID
587    * @param _spender address of the spender to query
588    * @param _tokenId uint256 ID of the token to be transferred
589    * @return bool whether the msg.sender is approved for the given token ID,
590    *  is an operator of the owner, or is the owner of the token
591    */
592   function isApprovedOrOwner(
593     address _spender,
594     uint256 _tokenId
595   )
596     internal
597     view
598     returns (bool)
599   {
600     address owner = ownerOf(_tokenId);
601     // Disable solium check because of
602     // https://github.com/duaraghav8/Solium/issues/175
603     // solium-disable-next-line operator-whitespace
604     return (
605       _spender == owner ||
606       getApproved(_tokenId) == _spender ||
607       isApprovedForAll(owner, _spender)
608     );
609   }
610 
611   /**
612    * @dev Internal function to mint a new token
613    * Reverts if the given token ID already exists
614    * @param _to The address that will own the minted token
615    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
616    */
617   function _mint(address _to, uint256 _tokenId) internal {
618     require(_to != address(0));
619     addTokenTo(_to, _tokenId);
620     emit Transfer(address(0), _to, _tokenId);
621   }
622 
623   /**
624    * @dev Internal function to burn a specific token
625    * Reverts if the token does not exist
626    * @param _tokenId uint256 ID of the token being burned by the msg.sender
627    */
628   function _burn(address _owner, uint256 _tokenId) internal {
629     clearApproval(_owner, _tokenId);
630     removeTokenFrom(_owner, _tokenId);
631     emit Transfer(_owner, address(0), _tokenId);
632   }
633 
634   /**
635    * @dev Internal function to clear current approval of a given token ID
636    * Reverts if the given address is not indeed the owner of the token
637    * @param _owner owner of the token
638    * @param _tokenId uint256 ID of the token to be transferred
639    */
640   function clearApproval(address _owner, uint256 _tokenId) internal {
641     require(ownerOf(_tokenId) == _owner);
642     if (tokenApprovals[_tokenId] != address(0)) {
643       tokenApprovals[_tokenId] = address(0);
644     }
645   }
646 
647   /**
648    * @dev Internal function to add a token ID to the list of a given address
649    * @param _to address representing the new owner of the given token ID
650    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
651    */
652   function addTokenTo(address _to, uint256 _tokenId) internal {
653     require(tokenOwner[_tokenId] == address(0));
654     tokenOwner[_tokenId] = _to;
655     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
656   }
657 
658   /**
659    * @dev Internal function to remove a token ID from the list of a given address
660    * @param _from address representing the previous owner of the given token ID
661    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
662    */
663   function removeTokenFrom(address _from, uint256 _tokenId) internal {
664     require(ownerOf(_tokenId) == _from);
665     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
666     tokenOwner[_tokenId] = address(0);
667   }
668 
669   /**
670    * @dev Internal function to invoke `onERC721Received` on a target address
671    * The call is not executed if the target address is not a contract
672    * @param _from address representing the previous owner of the given token ID
673    * @param _to target address that will receive the tokens
674    * @param _tokenId uint256 ID of the token to be transferred
675    * @param _data bytes optional data to send along with the call
676    * @return whether the call correctly returned the expected magic value
677    */
678   function checkAndCallSafeTransfer(
679     address _from,
680     address _to,
681     uint256 _tokenId,
682     bytes _data
683   )
684     internal
685     returns (bool)
686   {
687     if (!_to.isContract()) {
688       return true;
689     }
690     bytes4 retval = ERC721Receiver(_to).onERC721Received(
691       msg.sender, _from, _tokenId, _data);
692     return (retval == ERC721_RECEIVED);
693   }
694 }
695 
696 
697 
698 
699 /**
700  * @title Full ERC721 Token
701  * This implementation includes all the required and some optional functionality of the ERC721 standard
702  * Moreover, it includes approve all functionality using operator terminology
703  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
704  */
705 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
706 
707   // Token name
708   string internal name_;
709 
710   // Token symbol
711   string internal symbol_;
712 
713   // Mapping from owner to list of owned token IDs
714   mapping(address => uint256[]) internal ownedTokens;
715 
716   // Mapping from token ID to index of the owner tokens list
717   mapping(uint256 => uint256) internal ownedTokensIndex;
718 
719   // Array with all token ids, used for enumeration
720   uint256[] internal allTokens;
721 
722   // Mapping from token id to position in the allTokens array
723   mapping(uint256 => uint256) internal allTokensIndex;
724 
725   // Optional mapping for token URIs
726   mapping(uint256 => string) internal tokenURIs;
727 
728   /**
729    * @dev Constructor function
730    */
731   constructor(string _name, string _symbol) public {
732     name_ = _name;
733     symbol_ = _symbol;
734 
735     // register the supported interfaces to conform to ERC721 via ERC165
736     _registerInterface(InterfaceId_ERC721Enumerable);
737     _registerInterface(InterfaceId_ERC721Metadata);
738   }
739 
740   /**
741    * @dev Gets the token name
742    * @return string representing the token name
743    */
744   function name() external view returns (string) {
745     return name_;
746   }
747 
748   /**
749    * @dev Gets the token symbol
750    * @return string representing the token symbol
751    */
752   function symbol() external view returns (string) {
753     return symbol_;
754   }
755 
756   /**
757    * @dev Returns an URI for a given token ID
758    * Throws if the token ID does not exist. May return an empty string.
759    * @param _tokenId uint256 ID of the token to query
760    */
761   function tokenURI(uint256 _tokenId) public view returns (string) {
762     require(exists(_tokenId));
763     return tokenURIs[_tokenId];
764   }
765 
766   /**
767    * @dev Gets the token ID at a given index of the tokens list of the requested owner
768    * @param _owner address owning the tokens list to be accessed
769    * @param _index uint256 representing the index to be accessed of the requested tokens list
770    * @return uint256 token ID at the given index of the tokens list owned by the requested address
771    */
772   function tokenOfOwnerByIndex(
773     address _owner,
774     uint256 _index
775   )
776     public
777     view
778     returns (uint256)
779   {
780     require(_index < balanceOf(_owner));
781     return ownedTokens[_owner][_index];
782   }
783 
784   /**
785    * @dev Gets the total amount of tokens stored by the contract
786    * @return uint256 representing the total amount of tokens
787    */
788   function totalSupply() public view returns (uint256) {
789     return allTokens.length;
790   }
791 
792   /**
793    * @dev Gets the token ID at a given index of all the tokens in this contract
794    * Reverts if the index is greater or equal to the total number of tokens
795    * @param _index uint256 representing the index to be accessed of the tokens list
796    * @return uint256 token ID at the given index of the tokens list
797    */
798   function tokenByIndex(uint256 _index) public view returns (uint256) {
799     require(_index < totalSupply());
800     return allTokens[_index];
801   }
802 
803   /**
804    * @dev Internal function to set the token URI for a given token
805    * Reverts if the token ID does not exist
806    * @param _tokenId uint256 ID of the token to set its URI
807    * @param _uri string URI to assign
808    */
809   function _setTokenURI(uint256 _tokenId, string _uri) internal {
810     require(exists(_tokenId));
811     tokenURIs[_tokenId] = _uri;
812   }
813 
814   /**
815    * @dev Internal function to add a token ID to the list of a given address
816    * @param _to address representing the new owner of the given token ID
817    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
818    */
819   function addTokenTo(address _to, uint256 _tokenId) internal {
820     super.addTokenTo(_to, _tokenId);
821     uint256 length = ownedTokens[_to].length;
822     ownedTokens[_to].push(_tokenId);
823     ownedTokensIndex[_tokenId] = length;
824   }
825 
826   /**
827    * @dev Internal function to remove a token ID from the list of a given address
828    * @param _from address representing the previous owner of the given token ID
829    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
830    */
831   function removeTokenFrom(address _from, uint256 _tokenId) internal {
832     super.removeTokenFrom(_from, _tokenId);
833 
834     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
835     // then delete the last slot.
836     uint256 tokenIndex = ownedTokensIndex[_tokenId];
837     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
838     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
839 
840     ownedTokens[_from][tokenIndex] = lastToken;
841     // This also deletes the contents at the last position of the array
842     ownedTokens[_from].length--;
843 
844     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
845     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
846     // the lastToken to the first position, and then dropping the element placed in the last position of the list
847 
848     ownedTokensIndex[_tokenId] = 0;
849     ownedTokensIndex[lastToken] = tokenIndex;
850   }
851 
852   /**
853    * @dev Internal function to mint a new token
854    * Reverts if the given token ID already exists
855    * @param _to address the beneficiary that will own the minted token
856    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
857    */
858   function _mint(address _to, uint256 _tokenId) internal {
859     super._mint(_to, _tokenId);
860 
861     allTokensIndex[_tokenId] = allTokens.length;
862     allTokens.push(_tokenId);
863   }
864 
865   /**
866    * @dev Internal function to burn a specific token
867    * Reverts if the token does not exist
868    * @param _owner owner of the token to burn
869    * @param _tokenId uint256 ID of the token being burned by the msg.sender
870    */
871   function _burn(address _owner, uint256 _tokenId) internal {
872     super._burn(_owner, _tokenId);
873 
874     // Clear metadata (if any)
875     if (bytes(tokenURIs[_tokenId]).length != 0) {
876       delete tokenURIs[_tokenId];
877     }
878 
879     // Reorg all tokens array
880     uint256 tokenIndex = allTokensIndex[_tokenId];
881     uint256 lastTokenIndex = allTokens.length.sub(1);
882     uint256 lastToken = allTokens[lastTokenIndex];
883 
884     allTokens[tokenIndex] = lastToken;
885     allTokens[lastTokenIndex] = 0;
886 
887     allTokens.length--;
888     allTokensIndex[_tokenId] = 0;
889     allTokensIndex[lastToken] = tokenIndex;
890   }
891 
892 }
893 
894 
895 
896 
897 contract RoxBase is ERC721Token, Ownable {
898     event SeedChange(uint256 tokenId, string seed);
899     event remixCountChange(uint256 tokenId, uint256 amount);
900     event ParentsSets(uint256 tokenId, uint256 parent1, uint256 parent2);
901 
902     address minter;
903 
904     // Storage of the commission address.
905     address public commissionAddress;
906 
907     // Template for MetaData
908     struct metaData {
909         string seed;
910         uint parent1;
911         uint parent2;
912         uint remixCount;
913     }
914 
915     modifier onlyApprovedContractAddresses () {
916         // Used to require that the sender is an approved address.
917         require(ApprovedContractAddress[msg.sender] == true);
918         _;
919     }
920 
921     modifier onlyMinter () {
922         require(minter == msg.sender);
923         _;
924     }
925 
926     // Storage for Approve contract address
927     mapping (address => bool) ApprovedContractAddress;
928     // Storage for token metaDatas
929     mapping (uint256 => metaData) tokenToMetaData;
930     // Next available id (was count but that breaks if you burn a token).
931     uint nextId = 0;
932     // HostName for view of token(e.g. https://cryptorox.co/api/v1/)
933     string URIToken;
934 
935     /**
936     * @dev Overrides the default burn function to delete the token's meta data as well.
937     */
938     function _burn (uint256 _tokenId) internal {
939         delete tokenToMetaData[_tokenId];
940         super._burn(ownerOf(_tokenId), _tokenId);
941     }
942 
943     // Mints / Creates a new token with a given seed
944     /**
945     * @dev Internal Mints a token.
946     * @return New token's Id
947     */
948     function _mint(address _to, string _seed) internal returns (uint256){
949         uint256 newTokenId = nextId;
950         super._mint(_to, newTokenId);
951         _setTokenSeed(newTokenId, _seed);
952         nextId = nextId + 1;
953         return newTokenId;
954     }
955 
956     /**
957     * @dev Internal Sets token id to a seed.
958     */
959     function _setTokenSeed(uint256 _tokenId, string _seed) private  {
960         tokenToMetaData[_tokenId].seed = _seed;
961         emit SeedChange(uint(_tokenId), string(_seed));
962     }
963 }
964 
965 
966 /**
967  * @title RoxOnlyMinterMethods
968  * @dev Only Methods that can be called by the minter of the contract.
969  */
970 contract RoxOnlyMinterMethods is RoxBase {
971     /**
972     * @dev Mints a new token with a seed.
973     */
974     function mintTo(address _to, string seed) external onlyMinter returns (uint) {
975         return _mint(_to, seed);
976     }
977 }
978 
979 
980 /**
981  * @title RoxOnlyOwnerMethods
982  * @dev Only Methods that can be called by the owner of the contract.
983  */
984 contract RoxOnlyOwnerMethods is RoxBase {
985     /**
986     * @dev Sets the Approved value for contract address.
987     */
988     function setApprovedContractAddress (address _contractAddress, bool _value) public onlyOwner {
989         ApprovedContractAddress[_contractAddress] = _value;
990     }
991 
992     function kill() public onlyOwner {
993         selfdestruct(msg.sender);
994     }
995 
996     /**
997     * @dev Sets base uriToken.
998     */
999     function setURIToken(string _uriToken) public onlyOwner {
1000         URIToken = _uriToken;
1001     }
1002 
1003     /**
1004     * @dev Sets the new commission address.
1005     */
1006     function setCommissionAddress (address _commissionAddress) public onlyOwner {
1007         commissionAddress = _commissionAddress;
1008     }
1009     /**
1010     * @dev Sets the minter's Address
1011     */
1012     function setMinterAddress (address _minterAddress) public onlyOwner{
1013         minter = _minterAddress;
1014     }
1015 
1016     /**
1017     * @dev Burns a token.
1018     */
1019     function adminBurnToken(uint256 _tokenId) public onlyOwner {
1020         _burn(_tokenId);
1021     }
1022 }
1023 
1024 /**
1025  * @title RoxAuthorisedContractMethods
1026  * @dev All methods that can be ran by authorised contract addresses.
1027  */
1028 contract RoxAuthorisedContractMethods is RoxBase {
1029     // All these methods are ran via external authorised contracts.
1030 
1031     /**
1032     * @dev Burns a token.
1033     */
1034     function burnToken(uint256 _tokenId) public onlyApprovedContractAddresses {
1035         _burn(_tokenId);
1036     }
1037 
1038     /**
1039     * @dev Mints a new token.
1040     */
1041     function mintToPublic(address _to, string _seed) external onlyApprovedContractAddresses returns (uint) {
1042         return _mint(_to, _seed);
1043     }
1044 
1045 
1046     /**
1047     * @dev Sets the parents of a token.
1048     */
1049     function setParents(uint _tokenId, uint _parent1, uint _parent2) public onlyApprovedContractAddresses {
1050         tokenToMetaData[_tokenId].parent1 = _parent1;
1051         tokenToMetaData[_tokenId].parent2 = _parent2;
1052         emit ParentsSets(_tokenId, _parent1, _parent2);
1053 
1054     }
1055 
1056     /**
1057     * @dev Sets owner of token to given value.
1058     */
1059     function setTokenOwner(address _to, uint _tokenId) public onlyApprovedContractAddresses{
1060         tokenOwner[_tokenId] = _to;
1061     }
1062 
1063     /**
1064     * @dev Sets the seed of a given token.
1065     */
1066     function setTokenSeed(uint256 _tokenId, string _seed) public onlyApprovedContractAddresses {
1067         tokenToMetaData[_tokenId].seed = _seed;
1068         emit SeedChange(uint(_tokenId), string(_seed));
1069     }
1070 
1071     /**
1072     * @dev Sets the remixCount of a token
1073     */
1074     function setRemixCount(uint256 _tokenId, uint _remixCount) public onlyApprovedContractAddresses {
1075         tokenToMetaData[_tokenId].remixCount =_remixCount;
1076         emit remixCountChange(_tokenId, _remixCount);
1077     }
1078 }
1079 
1080 /**
1081  * @title RoxPublicGetters
1082  * @dev All public getter rox methods.
1083  */
1084 contract RoxPublicGetters is RoxBase {
1085     /**
1086     * @dev Returns tokens for an address.
1087     * @return uint[] of tokens owned by an address.
1088     */
1089     function getTokensForOwner (address _owner) public view returns (uint[]) {
1090         return ownedTokens[_owner];
1091     }
1092 
1093     /**
1094     * @dev Returns the data about a token.
1095     */
1096     function getDataForTokenId(uint256 _tokenId) public view returns
1097     (
1098         uint,
1099         string,
1100         uint,
1101         uint,
1102         address,
1103         address,
1104         uint
1105     )
1106     {
1107          metaData storage meta = tokenToMetaData[_tokenId];
1108         return (
1109             _tokenId,
1110             meta.seed,
1111             meta.parent1,
1112             meta.parent2,
1113             ownerOf(_tokenId),
1114             getApproved(_tokenId),
1115             meta.remixCount
1116         );
1117     }
1118 
1119         /**
1120     * @dev Returns a seed for a token id.
1121     * @return string the seed for the token id.
1122     */
1123     function getSeedForTokenId(uint256 _tokenId) public view returns (string) {
1124         return tokenToMetaData[_tokenId].seed;
1125     }
1126 
1127     /**
1128     * @dev Gets the remix count for a given token
1129     * @return The remix count for a given token
1130     */
1131     function getRemixCount(uint256 _tokenId) public view returns (uint) {
1132         return tokenToMetaData[_tokenId].remixCount;
1133     }
1134 
1135     /**
1136     * @dev Returns the parents for token id
1137     * @return TUPLE of the parent ids for a token.
1138     */
1139     function getParentsForTokenId(uint256 _tokenId) public view returns (uint parent1, uint parent2) {
1140         metaData storage meta = tokenToMetaData[_tokenId];
1141         return (
1142             meta.parent1,
1143             meta.parent2
1144         );
1145     }
1146 
1147     // Converts uint to a string
1148     function uint2str(uint i) internal pure returns (string){
1149         if (i == 0) return "0";
1150         uint j = i;
1151         uint length;
1152         while (j != 0){
1153             length++;
1154             j /= 10;
1155         }
1156         bytes memory bstr = new bytes(length);
1157         uint k = length - 1;
1158         while (i != 0){
1159             bstr[k--] = byte(48 + i % 10);
1160             i /= 10;
1161         }
1162         return string(bstr);
1163     }
1164 
1165 
1166     /**
1167     * @dev Returns the Token uri for a token
1168     * @return Token URI for a token ID.
1169     */
1170     function tokenURI(uint256 _tokenId) public view returns (string) {
1171         return string(abi.encodePacked(URIToken, uint2str(_tokenId)));
1172     }
1173 
1174 }
1175 
1176 
1177 /**
1178  * @title Rox
1179  * @dev Full rox Contract with all imports.
1180  */
1181 contract Rox is RoxOnlyOwnerMethods, RoxPublicGetters, RoxAuthorisedContractMethods, RoxOnlyMinterMethods {
1182     // Creates an instance of the contract
1183     constructor (string _name, string _symbol, string _uriToken) public ERC721Token(_name, _symbol) {
1184         URIToken = _uriToken;
1185     }
1186 
1187 }