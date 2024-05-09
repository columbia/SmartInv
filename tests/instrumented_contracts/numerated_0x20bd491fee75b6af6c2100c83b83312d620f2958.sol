1 pragma solidity 0.5.1;
2 
3 // RCC Tokenization Contract
4 
5 /**
6  * @title ERC20
7  * @author Prashant Prabhakar Singh
8  * @dev  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
9  */
10 contract ERC20Interface {
11   function transfer(address to, uint tokens) public returns (bool success);
12   event Transfer(address indexed from, address indexed to, uint tokens);
13 }
14 
15 /**
16  * @title ERC165
17  * @author Prashant Prabhakar Singh
18  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
19  */
20 interface ERC165 {
21 
22   /**
23    * @notice Query if a contract implements an interface
24    * @param _interfaceId The interface identifier, as specified in ERC-165
25    * @dev Interface identification is specified in ERC-165. This function
26    * uses less than 30,000 gas.
27    */
28   function supportsInterface(bytes4 _interfaceId)
29     external
30     view
31     returns (bool);
32 }
33 
34 /**
35  * Utility library of inline functions on addresses
36  */
37 library AddressUtils {
38 
39   /**
40    * Returns whether the target address is a contract
41    * @dev This function will return false if invoked during the constructor of a contract,
42    * as the code is not actually created until after the constructor finishes.
43    * @param addr address to check
44    * @return whether the target address is a contract
45    */
46   function isContract(address addr) internal view returns (bool) {
47     uint256 size;
48     // XXX Currently there is no better way to check if there is a contract in an address
49     // than to check the size of the code at that address.
50     // See https://ethereum.stackexchange.com/a/14016/36603
51     // for more details about how this works.
52     // TODO Check this again before the Serenity release, because all addresses will be
53     // contracts then.
54     // solium-disable-next-line security/no-inline-assembly
55     assembly { size := extcodesize(addr) }
56     return size > 0;
57   }
58 }
59 
60 library SafeMath {
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     if (a == 0) {
63       return 0;
64     }
65     uint256 c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81   
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 
90 /**
91  * @title ERC721 token receiver interface
92  * @author Prashant Prabhakar Singh
93  * @dev Interface for any contract that wants to support safeTransfers
94  * from ERC721 asset contracts.
95  */
96 contract ERC721Receiver {
97   /**
98    * @dev Magic value to be returned upon successful reception of an NFT
99    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
100    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
101    */
102   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
103 
104   /**
105    * @notice Handle the receipt of an NFT
106    * @dev The ERC721 smart contract calls this function on the recipient
107    * after a `safetransfer`. This function MAY throw to revert and reject the
108    * transfer. This function MUST use 50,000 gas or less. Return of other
109    * than the magic value MUST result in the transaction being reverted.
110    * Note: the contract address is always the message sender.
111    * @param _from The sending address
112    * @param _tokenId The NFT identifier which is being transfered
113    * @param _data Additional data with no specified format
114    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
115    */
116   function onERC721Received(
117     address _from,
118     uint256 _tokenId,
119     bytes memory _data
120   )
121     public
122     returns(bytes4);
123 }
124 
125 /**
126  * @title SupportsInterfaceWithLookup
127  * @author Prashant Prabhakar Singh
128  * @dev Implements ERC165 using a lookup table.
129  */
130 contract SupportsInterfaceWithLookup is ERC165 {
131   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
132   /**
133    * 0x01ffc9a7 ===
134    *   bytes4(keccak256('supportsInterface(bytes4)'))
135    */
136 
137   /**
138    * @dev a mapping of interface id to whether or not it's supported
139    */
140   mapping(bytes4 => bool) internal supportedInterfaces;
141 
142   /**
143    * @dev A contract implementing SupportsInterfaceWithLookup
144    * implement ERC165 itself
145    */
146   constructor()
147     public
148   {
149     _registerInterface(InterfaceId_ERC165);
150   }
151 
152   /**
153    * @dev implement supportsInterface(bytes4) using a lookup table
154    */
155   function supportsInterface(bytes4 _interfaceId)
156     external
157     view
158     returns (bool)
159   {
160     return supportedInterfaces[_interfaceId];
161   }
162 
163   /**
164    * @dev private method for registering an interface
165    */
166   function _registerInterface(bytes4 _interfaceId)
167     internal
168   {
169     require(_interfaceId != 0xffffffff);
170     supportedInterfaces[_interfaceId] = true;
171   }
172 }
173 
174 /**
175  * @title Pausable
176  * @author Prashant Prabhakar Singh
177  * @dev Base contract which allows children to implement an emergency stop mechanism.
178  */
179 contract Pausable {
180   event Paused(address account);
181   event Unpaused(address account);
182 
183   bool private _paused;
184   address public pauser;
185 
186   constructor () internal {
187     _paused = false;
188     pauser = msg.sender;
189   }
190 
191   /**
192     * @return true if the contract is paused, false otherwise.
193     */
194   function paused() public view returns (bool) {
195     return _paused;
196   }
197 
198   /**
199     * @dev Modifier to make a function callable only by pauser.
200     */
201   modifier onlyPauser() {
202     require(msg.sender == pauser);
203     _;
204   }
205 
206   /**
207     * @dev Modifier to make a function callable only when the contract is not paused.
208     */
209   modifier whenNotPaused() {
210     require(!_paused);
211     _;
212   }
213 
214 
215   /**
216     * @dev called by the owner to pause, triggers stopped state
217     */
218   function pause() public onlyPauser {
219     require(!_paused);
220     _paused = true;
221     emit Paused(msg.sender);
222   }
223 
224   /**
225     * @dev called by the owner to unpause, returns to normal state
226     */
227   function unpause() public onlyPauser {
228     require(_paused);
229     _paused = false;
230     emit Unpaused(msg.sender);
231   }
232 }
233 
234 /**
235  * @title ERC721 Non-Fungible Token Standard basic interface
236  * @author Prashant Prabhakar Singh
237  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
238  */
239 contract ERC721Basic is ERC165, Pausable {
240   event Transfer(
241     address indexed _from,
242     address indexed _to,
243     uint256 indexed _tokenId
244   );
245   event Approval(
246     address indexed _owner,
247     address indexed _approved,
248     uint256 indexed _tokenId
249   );
250   event ApprovalForAll(
251     address indexed _owner,
252     address indexed _operator,
253     bool _approved
254   );
255 
256   function balanceOf(address _owner) public view returns (uint256 _balance);
257   function ownerOf(uint256 _tokenId) public view returns (address _owner);
258   function exists(uint256 _tokenId) public view returns (bool _exists);
259 
260   function approve(address _to, uint256 _tokenId) public;
261   function getApproved(uint256 _tokenId)
262     public view returns (address _operator);
263 
264   function setApprovalForAll(address _operator, bool _approved) public;
265   function isApprovedForAll(address _owner, address _operator)
266     public view returns (bool);
267 
268   function transferFrom(address _from, address _to, uint256 _tokenId) public;
269   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
270     public;
271 
272   function safeTransferFrom(
273     address _from,
274     address _to,
275     uint256 _tokenId,
276     bytes memory _data
277   )
278     public;
279 }
280 
281 /**
282  * @title ERC721 Non-Fungible Token Standard basic implementation
283  * @author Prashant Prabhakar Singh
284  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
285  */
286 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
287 
288   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
289   /*
290    * 0x80ac58cd ===
291    *   bytes4(keccak256('balanceOf(address)')) ^
292    *   bytes4(keccak256('ownerOf(uint256)')) ^
293    *   bytes4(keccak256('approve(address,uint256)')) ^
294    *   bytes4(keccak256('getApproved(uint256)')) ^
295    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
296    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
297    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
298    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
299    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
300    */
301 
302   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
303   /*
304    * 0x4f558e79 ===
305    *   bytes4(keccak256('exists(uint256)'))
306    */
307 
308   using SafeMath for uint256;
309   using AddressUtils for address;
310 
311   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
312   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
313   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
314 
315   // Mapping from token ID to owner
316   mapping (uint256 => address) internal tokenOwner;
317 
318   // Mapping from token ID to approved address
319   mapping (uint256 => address) internal tokenApprovals;
320 
321   // Mapping from owner to number of owned token
322   mapping (address => uint256) internal ownedTokensCount;
323 
324   // Mapping from owner to operator approvals
325   mapping (address => mapping (address => bool)) internal operatorApprovals;
326 
327   /**
328    * @dev Guarantees msg.sender is owner of the given token
329    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
330    */
331   modifier onlyOwnerOf(uint256 _tokenId) {
332     require(ownerOf(_tokenId) == msg.sender);
333     _;
334   }
335 
336   /**
337    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
338    * @param _tokenId uint256 ID of the token to validate
339    */
340   modifier canTransfer(uint256 _tokenId) {
341     require(isApprovedOrOwner(msg.sender, _tokenId));
342     _;
343   }
344 
345   constructor()
346     public
347   {
348     // register the supported interfaces to conform to ERC721 via ERC165
349     _registerInterface(InterfaceId_ERC721);
350     _registerInterface(InterfaceId_ERC721Exists);
351   }
352 
353   /**
354    * @dev Gets the balance of the specified address
355    * @param _owner address to query the balance of
356    * @return uint256 representing the amount owned by the passed address
357    */
358   function balanceOf(address _owner) public view returns (uint256) {
359     require(_owner != address(0));
360     return ownedTokensCount[_owner];
361   }
362 
363   /**
364    * @dev Gets the owner of the specified token ID
365    * @param _tokenId uint256 ID of the token to query the owner of
366    * @return owner address currently marked as the owner of the given token ID
367    */
368   function ownerOf(uint256 _tokenId) public view returns (address) {
369     address owner = tokenOwner[_tokenId];
370     require(owner != address(0));
371     return owner;
372   }
373 
374   /**
375    * @dev Returns whether the specified token exists
376    * @param _tokenId uint256 ID of the token to query the existence of
377    * @return whether the token exists
378    */
379   function exists(uint256 _tokenId) public view returns (bool) {
380     address owner = tokenOwner[_tokenId];
381     return owner != address(0);
382   }
383 
384   /**
385    * @dev Approves another address to transfer the given token ID
386    * The zero address indicates there is no approved address.
387    * There can only be one approved address per token at a given time.
388    * Can only be called by the token owner or an approved operator.
389    * @param _to address to be approved for the given token ID
390    * @param _tokenId uint256 ID of the token to be approved
391    */
392   function approve(address _to, uint256 _tokenId) public whenNotPaused {
393     address owner = ownerOf(_tokenId);
394     require(_to != owner);
395     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
396 
397     tokenApprovals[_tokenId] = _to;
398     emit Approval(owner, _to, _tokenId);
399   }
400 
401   /**
402    * @dev Gets the approved address for a token ID, or zero if no address set
403    * @param _tokenId uint256 ID of the token to query the approval of
404    * @return address currently approved for the given token ID
405    */
406   function getApproved(uint256 _tokenId) public view returns (address) {
407     return tokenApprovals[_tokenId];
408   }
409 
410   /**
411    * @dev Sets or unsets the approval of a given operator
412    * An operator is allowed to transfer all tokens of the sender on their behalf
413    * @param _to operator address to set the approval
414    * @param _approved representing the status of the approval to be set
415    */
416   function setApprovalForAll(address _to, bool _approved) public whenNotPaused {
417     require(_to != msg.sender);
418     operatorApprovals[msg.sender][_to] = _approved;
419     emit ApprovalForAll(msg.sender, _to, _approved);
420   }
421 
422   /**
423    * @dev Tells whether an operator is approved by a given owner
424    * @param _owner owner address which you want to query the approval of
425    * @param _operator operator address which you want to query the approval of
426    * @return bool whether the given operator is approved by the given owner
427    */
428   function isApprovedForAll(
429     address _owner,
430     address _operator
431   )
432     public
433     view
434     returns (bool)
435   {
436     return operatorApprovals[_owner][_operator];
437   }
438 
439   /**
440    * @dev Transfers the ownership of a given token ID to another address
441    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
442    * Requires the msg sender to be the owner, approved, or operator
443    * @param _from current owner of the token
444    * @param _to address to receive the ownership of the given token ID
445    * @param _tokenId uint256 ID of the token to be transferred
446   */
447   function transferFrom(
448     address _from,
449     address _to,
450     uint256 _tokenId
451   )
452     public
453     canTransfer(_tokenId)
454     whenNotPaused
455   {
456     require(_from != address(0));
457     require(_to != address(0));
458 
459     clearApproval(_from, _tokenId);
460     removeTokenFrom(_from, _tokenId);
461     addTokenTo(_to, _tokenId);
462 
463     emit Transfer(_from, _to, _tokenId);
464   }
465 
466   /**
467    * @dev Safely transfers the ownership of a given token ID to another address
468    * If the target address is a contract, it must implement `onERC721Received`,
469    * which is called upon a safe transfer, and return the magic value
470    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
471    * the transfer is reverted.
472    *
473    * Requires the msg sender to be the owner, approved, or operator
474    * @param _from current owner of the token
475    * @param _to address to receive the ownership of the given token ID
476    * @param _tokenId uint256 ID of the token to be transferred
477   */
478   function safeTransferFrom(
479     address _from,
480     address _to,
481     uint256 _tokenId
482   )
483     public
484     canTransfer(_tokenId)
485     whenNotPaused
486   {
487     // solium-disable-next-line arg-overflow
488     safeTransferFrom(_from, _to, _tokenId, "");
489   }
490 
491   /**
492    * @dev Safely transfers the ownership of a given token ID to another address
493    * If the target address is a contract, it must implement `onERC721Received`,
494    * which is called upon a safe transfer, and return the magic value
495    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
496    * the transfer is reverted.
497    * Requires the msg sender to be the owner, approved, or operator
498    * @param _from current owner of the token
499    * @param _to address to receive the ownership of the given token ID
500    * @param _tokenId uint256 ID of the token to be transferred
501    * @param _data bytes data to send along with a safe transfer check
502    */
503   function safeTransferFrom(
504     address _from,
505     address _to,
506     uint256 _tokenId,
507     bytes memory _data
508   )
509     public
510     canTransfer(_tokenId)
511   {
512     transferFrom(_from, _to, _tokenId);
513     // solium-disable-next-line arg-overflow
514     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
515   }
516 
517   /**
518    * @dev Returns whether the given spender can transfer a given token ID
519    * @param _spender address of the spender to query
520    * @param _tokenId uint256 ID of the token to be transferred
521    * @return bool whether the msg.sender is approved for the given token ID,
522    *  is an operator of the owner, or is the owner of the token
523    */
524   function isApprovedOrOwner(
525     address _spender,
526     uint256 _tokenId
527   )
528     internal
529     view
530     returns (bool)
531   {
532     address owner = ownerOf(_tokenId);
533     // Disable solium check because of
534     // https://github.com/duaraghav8/Solium/issues/175
535     // solium-disable-next-line operator-whitespace
536     return (
537       _spender == owner ||
538       getApproved(_tokenId) == _spender ||
539       isApprovedForAll(owner, _spender)
540     );
541   }
542 
543   /**
544    * @dev Internal function to mint a new token
545    * Reverts if the given token ID already exists
546    * @param _to The address that will own the minted token
547    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
548    */
549   function _mint(address _to, uint256 _tokenId) internal {
550     require(_to != address(0));
551     addTokenTo(_to, _tokenId);
552     emit Transfer(address(0), _to, _tokenId);
553   }
554 
555   /**
556    * @dev Internal function to burn a specific token
557    * Reverts if the token does not exist
558    * @param _tokenId uint256 ID of the token being burned by the msg.sender
559    */
560   function _burn(address _owner, uint256 _tokenId) internal {
561     clearApproval(_owner, _tokenId);
562     removeTokenFrom(_owner, _tokenId);
563     emit Transfer(_owner, address(0), _tokenId);
564   }
565 
566   /**
567    * @dev Internal function to clear current approval of a given token ID
568    * Reverts if the given address is not indeed the owner of the token
569    * @param _owner owner of the token
570    * @param _tokenId uint256 ID of the token to be transferred
571    */
572   function clearApproval(address _owner, uint256 _tokenId) internal {
573     require(ownerOf(_tokenId) == _owner);
574     if (tokenApprovals[_tokenId] != address(0)) {
575       tokenApprovals[_tokenId] = address(0);
576       emit Approval(_owner, address(0), _tokenId);
577     }
578   }
579 
580   /**
581    * @dev Internal function to add a token ID to the list of a given address
582    * @param _to address representing the new owner of the given token ID
583    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
584    */
585   function addTokenTo(address _to, uint256 _tokenId) internal {
586     require(tokenOwner[_tokenId] == address(0));
587     tokenOwner[_tokenId] = _to;
588     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
589   }
590 
591   /**
592    * @dev Internal function to remove a token ID from the list of a given address
593    * @param _from address representing the previous owner of the given token ID
594    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
595    */
596   function removeTokenFrom(address _from, uint256 _tokenId) internal {
597     require(ownerOf(_tokenId) == _from);
598     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
599     tokenOwner[_tokenId] = address(0);
600   }
601 
602   /**
603    * @dev Internal function to invoke `onERC721Received` on a target address
604    * The call is not executed if the target address is not a contract
605    * @param _from address representing the previous owner of the given token ID
606    * @param _to target address that will receive the tokens
607    * @param _tokenId uint256 ID of the token to be transferred
608    * @param _data bytes optional data to send along with the call
609    * @return whether the call correctly returned the expected magic value
610    */
611   function checkAndCallSafeTransfer(
612     address _from,
613     address _to,
614     uint256 _tokenId,
615     bytes memory _data
616   )
617     internal
618     returns (bool)
619   {
620     if (!_to.isContract()) {
621       return true;
622     }
623     bytes4 retval = ERC721Receiver(_to).onERC721Received(
624       _from, _tokenId, _data);
625     return (retval == ERC721_RECEIVED);
626   }
627 }
628 
629 /**
630  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
631  * @author Prashant Prabhakar Singh
632  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
633  */
634 contract ERC721Enumerable is ERC721Basic {
635   function totalSupply() public view returns (uint256);
636   function tokenOfOwnerByIndex(
637     address _owner,
638     uint256 _index
639   )
640     public
641     view
642     returns (uint256 _tokenId);
643 
644   function tokenByIndex(uint256 _index) public view returns (uint256);
645 }
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata 
649  * @author Prashant Prabhakar Singh
650  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
651  */
652 contract ERC721Metadata is ERC721Basic {
653   function name() external view returns (string memory _name);
654   function symbol() external view returns (string memory _symbol);
655   function tokenURI(uint256 _tokenId) public view returns (string memory);
656 }
657 
658 /**
659  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
660  * @author Prashant Prabhakar Singh
661  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
662  */
663 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
664 }
665 
666 /**
667  * @title Full ERC721 Token
668  * @author Prashant Prabhakar Singh
669  * This implementation includes all the required and some optional functionality of the ERC721 standard
670  * Moreover, it includes approve all functionality using operator terminology
671  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
672  */
673 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
674 
675   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
676   /**
677    * 0x780e9d63 ===
678    *   bytes4(keccak256('totalSupply()')) ^
679    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
680    *   bytes4(keccak256('tokenByIndex(uint256)'))
681    */
682 
683   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
684   /**
685    * 0x5b5e139f ===
686    *   bytes4(keccak256('name()')) ^
687    *   bytes4(keccak256('symbol()')) ^
688    *   bytes4(keccak256('tokenURI(uint256)'))
689    */
690 
691   // Token name
692   string internal name_;
693 
694   // Token symbol
695   string internal symbol_;
696 
697   // Mapping from owner to list of owned token IDs
698   mapping(address => uint256[]) internal ownedTokens;
699 
700   // Mapping from token ID to index of the owner tokens list
701   mapping(uint256 => uint256) internal ownedTokensIndex;
702 
703   // Array with all token ids, used for enumeration
704   uint256[] internal allTokens;
705 
706   // Mapping from token id to position in the allTokens array
707   mapping(uint256 => uint256) internal allTokensIndex;
708 
709   // Optional mapping for token URIs
710   mapping(uint256 => string) internal tokenURIs;
711 
712   /**
713    * @dev Constructor function
714    */
715   constructor(string memory _name, string memory _symbol) public {
716     name_ = _name;
717     symbol_ = _symbol;
718 
719     // register the supported interfaces to conform to ERC721 via ERC165
720     _registerInterface(InterfaceId_ERC721Enumerable);
721     _registerInterface(InterfaceId_ERC721Metadata);
722   }
723 
724   /**
725    * @dev Gets the token name
726    * @return string representing the token name
727    */
728   function name() external view returns (string memory) {
729     return name_;
730   }
731 
732   /**
733    * @dev Gets the token symbol
734    * @return string representing the token symbol
735    */
736   function symbol() external view returns (string memory) {
737     return symbol_;
738   }
739 
740   /**
741    * @dev Returns an URI for a given token ID
742    * Throws if the token ID does not exist. May return an empty string.
743    * @param _tokenId uint256 ID of the token to query
744    */
745   function tokenURI(uint256 _tokenId) public view returns (string memory) {
746     require(exists(_tokenId));
747     return tokenURIs[_tokenId];
748   }
749 
750   /**
751    * @dev Gets the token ID at a given index of the tokens list of the requested owner
752    * @param _owner address owning the tokens list to be accessed
753    * @param _index uint256 representing the index to be accessed of the requested tokens list
754    * @return uint256 token ID at the given index of the tokens list owned by the requested address
755    */
756   function tokenOfOwnerByIndex(
757     address _owner,
758     uint256 _index
759   )
760     public
761     view
762     returns (uint256)
763   {
764     require(_index < balanceOf(_owner));
765     return ownedTokens[_owner][_index];
766   }
767 
768   /**
769    * @dev Gets the total amount of tokens stored by the contract
770    * @return uint256 representing the total amount of tokens
771    */
772   function totalSupply() public view returns (uint256) {
773     return allTokens.length;
774   }
775 
776   /**
777    * @dev Gets the token ID at a given index of all the tokens in this contract
778    * Reverts if the index is greater or equal to the total number of tokens
779    * @param _index uint256 representing the index to be accessed of the tokens list
780    * @return uint256 token ID at the given index of the tokens list
781    */
782   function tokenByIndex(uint256 _index) public view returns (uint256) {
783     require(_index < totalSupply());
784     return allTokens[_index];
785   }
786 
787   /**
788    * @dev Internal function to set the token URI for a given token
789    * Reverts if the token ID does not exist
790    * @param _tokenId uint256 ID of the token to set its URI
791    * @param _uri string URI to assign
792    */
793   function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
794     require(exists(_tokenId));
795     tokenURIs[_tokenId] = _uri;
796   }
797 
798   /**
799    * @dev Internal function to add a token ID to the list of a given address
800    * @param _to address representing the new owner of the given token ID
801    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
802    */
803   function addTokenTo(address _to, uint256 _tokenId) internal {
804     super.addTokenTo(_to, _tokenId);
805     uint256 length = ownedTokens[_to].length;
806     ownedTokens[_to].push(_tokenId);
807     ownedTokensIndex[_tokenId] = length;
808   }
809 
810   /**
811    * @dev Internal function to remove a token ID from the list of a given address
812    * @param _from address representing the previous owner of the given token ID
813    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
814    */
815   function removeTokenFrom(address _from, uint256 _tokenId) internal {
816     super.removeTokenFrom(_from, _tokenId);
817 
818     uint256 tokenIndex = ownedTokensIndex[_tokenId];
819     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
820     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
821 
822     ownedTokens[_from][tokenIndex] = lastToken;
823     ownedTokens[_from][lastTokenIndex] = 0;
824     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
825     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
826     // the lastToken to the first position, and then dropping the element placed in the last position of the list
827 
828     ownedTokens[_from].length--;
829     ownedTokensIndex[_tokenId] = 0;
830     ownedTokensIndex[lastToken] = tokenIndex;
831   }
832 
833   /**
834    * @dev Internal function to mint a new token
835    * Reverts if the given token ID already exists
836    * @param _to address the beneficiary that will own the minted token
837    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
838    */
839   function _mint(address _to, uint256 _tokenId) internal {
840     super._mint(_to, _tokenId);
841 
842     allTokensIndex[_tokenId] = allTokens.length;
843     allTokens.push(_tokenId);
844   }
845 
846   /**
847    * @dev Internal function to burn a specific token
848    * Reverts if the token does not exist
849    * @param _owner owner of the token to burn
850    * @param _tokenId uint256 ID of the token being burned by the msg.sender
851    */
852   function _burn(address _owner, uint256 _tokenId) internal {
853     super._burn(_owner, _tokenId);
854 
855     // Clear metadata (if any)
856     if (bytes(tokenURIs[_tokenId]).length != 0) {
857       delete tokenURIs[_tokenId];
858     }
859 
860     // Reorg all tokens array
861     uint256 tokenIndex = allTokensIndex[_tokenId];
862     uint256 lastTokenIndex = allTokens.length.sub(1);
863     uint256 lastToken = allTokens[lastTokenIndex];
864 
865     allTokens[tokenIndex] = lastToken;
866     allTokens[lastTokenIndex] = 0;
867 
868     allTokens.length--;
869     allTokensIndex[_tokenId] = 0;
870     allTokensIndex[lastToken] = tokenIndex;
871   }
872 }
873 
874 /**
875  * @title Ownership
876  * @author Prashant Prabhakar Singh
877  * This contract has an owner address, and provides basic authorization control
878  */
879 contract Ownership is Pausable {
880   address public owner;
881   event OwnershipUpdated(address oldOwner, address newOwner);
882 
883   constructor() public {
884     owner = msg.sender;
885   }
886 
887   modifier onlyOwner() {
888     require(msg.sender == owner);
889     _;
890   }
891 
892   function updateOwner(address _newOwner)
893     public
894     onlyOwner
895     whenNotPaused
896   {
897     owner = _newOwner;
898     emit OwnershipUpdated(msg.sender, owner);
899   }
900 }
901 
902 /**
903  * @title Operators
904  * @author Prashant Prabhakar Singh
905  * This contract add functionlaity of adding operators that have higher authority than a normal user
906  * @dev Operators can perform different actions based on their level.
907  */
908 contract Operators is Ownership {
909   // state variable
910   address[] private operators;
911   uint8 MAX_OP_LEVEL;
912   mapping (address => uint8) operatorLevel; // mapping of address to level
913 
914   // events
915   event OperatorAdded (address _operator, uint8 _level);
916   event OperatorUpdated (address _operator, uint8 _level);
917   event OperatorRemoved (address _operator);
918 
919   constructor()
920     public
921   {
922     MAX_OP_LEVEL = 3;
923   }
924 
925   modifier onlyLevel(uint8 level) {
926     uint8 opLevel = getOperatorLevel(msg.sender);
927     if (level > 0) {
928       require( opLevel <= level && opLevel != 0);
929       _;
930     } else {
931       _;
932     }
933   }
934 
935   modifier onlyValidLevel(uint8 _level){
936     require(_level> 0 && _level <= MAX_OP_LEVEL);
937     _;
938   }
939 
940   function addOperator(address _newOperator, uint8 _level)
941     public 
942     onlyOwner
943     whenNotPaused
944     onlyValidLevel(_level)
945     returns (bool)
946   {
947     require (operatorLevel[_newOperator] == 0); // use change level instead
948     operatorLevel[_newOperator] = _level;
949     operators.push(_newOperator);
950     emit OperatorAdded(_newOperator, _level);
951     return true;
952   }
953 
954   function updateOperator(address _operator, uint8 _level)
955     public
956     onlyOwner
957     whenNotPaused
958     onlyValidLevel(_level)
959     returns (bool)
960   {
961     require (operatorLevel[_operator] != 0); // use add Operator
962     operatorLevel[_operator] = _level;
963     emit OperatorUpdated(_operator, _level);
964     return true;
965   }
966 
967   function removeOperatorByIndex(uint index)
968     public
969     onlyOwner
970     whenNotPaused
971     returns (bool)
972   {
973     index = index - 1;
974     operatorLevel[operators[index]] = 0;
975     operators[index] = operators[operators.length - 1];
976     operators.length -- ;
977     return true;
978 
979   }
980 
981   
982     /**
983    * @dev Use removeOperatorByIndex instead to save gas
984    * warning: not advised to use this function.
985    */
986   function removeOperator(address _operator)
987     public
988     onlyOwner
989     whenNotPaused
990     returns (bool)
991   {
992     uint index = getOperatorIndex(_operator);
993     require(index > 0);
994     return removeOperatorByIndex(index);
995   }
996 
997   function getOperatorIndex(address _operator)
998     public
999     view
1000     returns (uint)
1001   {
1002     for (uint i=0; i<operators.length; i++) {
1003       if (operators[i] == _operator) return i+1;
1004     }
1005     return 0;
1006   }
1007 
1008   function getOperators()
1009     public
1010     view
1011     returns (address[] memory)
1012   {
1013     return operators;
1014   }
1015 
1016   function getOperatorLevel(address _operator)
1017     public
1018     view
1019     returns (uint8)
1020   {
1021     return operatorLevel[_operator];
1022   }
1023 
1024 }
1025 
1026 /**
1027  * @title RealityClashWeapon
1028  * @author Prashant Prabhakar Singh
1029  * This contract implements Reality Clash Weapons NFTs.
1030  */
1031 contract RealityClashWeapon is ERC721Token, Operators {
1032 
1033   // mappings to store RealityClash Weapon Data
1034   mapping (uint => string) gameDataOf;
1035   mapping (uint => string) weaponDataOf;
1036   mapping (uint => string) ownerDataOf;
1037 
1038  
1039   event WeaponAdded(uint indexed weaponId, string gameData, string weaponData, string ownerData, string tokenURI);
1040   event WeaponUpdated(uint indexed weaponId, string gameData, string weaponData, string ownerData, string tokenURI);
1041   event WeaponOwnerUpdated (uint indexed  _weaponId, address indexed  _oldOwner, address indexed  _newOwner);
1042 
1043   constructor() public  ERC721Token('Reality Clash Weapon', 'RC GUN'){
1044   }
1045 
1046   /**
1047    * @dev Mints new tokens wih jsons on blockchain
1048    * Reverts if the sender is not operator with level 1
1049    * @param _id Id of weapon to be minted
1050    * @param _gameData represent game data of the weapon
1051    * @param _weaponData represents weapon data of the weapon
1052    * @param _ownerData represents owner data of the weapon
1053    */
1054   function mint(uint256 _id, string memory _gameData, string memory _weaponData, string memory _ownerData, address _to)
1055     public
1056     onlyLevel(1)
1057     whenNotPaused
1058   {
1059     super._mint(_to, _id);
1060     gameDataOf[_id] = _gameData;
1061     weaponDataOf[_id] = _weaponData;
1062     ownerDataOf[_id] = _ownerData;
1063     emit WeaponAdded(_id, _gameData, _weaponData, _ownerData, '');
1064   }
1065 
1066   /**
1067    * @dev Mints new tokens with tokenURI
1068    * Reverts if the sender is not operator with level 1
1069    * @param _id Id of weapon to be minted
1070    * @param _to represent address to which unique token is minted
1071    * @param _uri represents string URI to assign
1072    */
1073   function mintWithURI(uint256 _id, address _to, string memory _uri)
1074     public
1075     onlyLevel(1)
1076     whenNotPaused
1077   {
1078     super._mint(_to, _id);
1079     super._setTokenURI(_id, _uri);
1080     emit WeaponAdded(_id, '', '', '', _uri);
1081   }
1082 
1083 
1084   /**
1085    * @dev Transfer tokens (similar to ERC-20 transfer)
1086    * Reverts if the sender is not owner of the weapon or approved
1087    * @param _to address to which token is transferred
1088    * @param _tokenId Id of weapon being transferred
1089    */
1090   function transfer(address _to, uint256 _tokenId)
1091     public
1092     whenNotPaused
1093   {
1094     safeTransferFrom(msg.sender, _to, _tokenId);
1095   }
1096 
1097   /**
1098    * @dev Updates metaData of already minted tokens
1099    * Reverts if the sender is not operator with level 2 or above
1100    * @param _id Id of weapon whose data needs to be updated
1101    * @param _gameData represent game data of the weapon
1102    * @param _weaponData represents weapon data of the weapon
1103    * @param _ownerData represents owner data of the weapon
1104    */
1105   function updateMetaData(uint _id, string memory _gameData, string memory _weaponData, string memory _ownerData)
1106     public 
1107     onlyLevel(2)
1108     whenNotPaused
1109   {
1110     gameDataOf[_id] = _gameData;
1111     weaponDataOf[_id] = _weaponData;
1112     ownerDataOf[_id] = _ownerData;
1113   }
1114 
1115   /**
1116    * @dev Burn an existing weapon
1117    * @param _id Id of weapon to be burned
1118    */
1119   function burn(uint _id)
1120     public
1121     whenNotPaused
1122   {
1123    super._burn(msg.sender, _id);
1124   }
1125 
1126 
1127   /**
1128    * @dev Update game proprietary data
1129    * @param _id Id of weapon whose data needs to be updated
1130    * @param _gameData is new game data for weapon
1131    */
1132   function updateGameData (uint _id, string memory _gameData)
1133     public
1134     onlyLevel(2)
1135     whenNotPaused
1136     returns(bool)
1137   {
1138     gameDataOf[_id] = _gameData;
1139     emit WeaponUpdated(_id, _gameData, "", "", "");
1140     return true;
1141   }
1142 
1143   /**
1144    * @dev Update weapon sepcific data of weapon
1145    * @param _id Id of weapon whose data needs to be updated
1146    * @param _weaponData is new public data for weapon
1147    */
1148   function updateWeaponData (uint _id,  string memory _weaponData)
1149     public 
1150     onlyLevel(2)
1151     whenNotPaused
1152     returns(bool) 
1153   {
1154     weaponDataOf[_id] = _weaponData;
1155     emit WeaponUpdated(_id, "", _weaponData, "", "");
1156     return true;
1157   }
1158 
1159   /**
1160    * @dev Update owner proprietary data
1161    * @param _id Id of weapon whose data needs to be updated
1162    * @param _ownerData is new owner data for weapon
1163    */
1164   function updateOwnerData (uint _id, string memory _ownerData)
1165     public
1166     onlyLevel(2)
1167     whenNotPaused
1168     returns(bool)
1169   {
1170     ownerDataOf[_id] = _ownerData;
1171     emit WeaponUpdated(_id, "", "", _ownerData, "");
1172     return true;
1173   }
1174 
1175   /**
1176    * @dev Update token URI of weapon
1177    * @param _id Id of weapon whose data needs to be updated
1178    * @param _uri Url of weapon details
1179    */
1180   function updateURI (uint _id, string memory _uri)
1181     public
1182     onlyLevel(2)
1183     whenNotPaused
1184     returns(bool)
1185   {
1186     super._setTokenURI(_id, _uri);
1187     emit WeaponUpdated(_id, "", "", "", _uri);
1188     return true;
1189   }
1190 
1191   //////////////////////////////////////////
1192   // PUBLICLY ACCESSIBLE METHODS (CONSTANT)
1193   //////////////////////////////////////////
1194 
1195   /**
1196   * @return game data of weapon.
1197   */
1198   function getGameData (uint _id) public view returns(string memory _gameData) {
1199     return gameDataOf[_id];
1200   }
1201 
1202   /**
1203   * @return weapon data of weapon.
1204   */
1205   function getWeaponData (uint _id) public view returns(string memory _pubicData) {
1206     return weaponDataOf[_id];
1207   }
1208 
1209   /**
1210   * @return owner data of weapon.
1211   */
1212   function getOwnerData (uint _id) public view returns(string memory _ownerData) {
1213     return ownerDataOf[_id] ;
1214   }
1215 
1216   /**
1217   * @return all metaData data of weapon including game data, weapon data, owner data.
1218   */
1219   function getMetaData (uint _id) public view returns(string memory _gameData,string memory _pubicData,string memory _ownerData ) {
1220     return (gameDataOf[_id], weaponDataOf[_id], ownerDataOf[_id]);
1221   }
1222 }
1223 
1224 
1225 /**
1226  * @title AdvancedRealityClashWeapon
1227  * @author Prashant Prabhakar Singh
1228  * This contract implements submitting a pre signed tx
1229  * @dev Method allowed is setApproval and transfer
1230  */
1231 contract AdvancedRealityClashWeapon is RealityClashWeapon {
1232 
1233   // mapping for replay protection
1234   mapping(address => uint) private userNonce;
1235 
1236   bool public isNormalUserAllowed; // can normal user access advanced features
1237   
1238   constructor() public {
1239     isNormalUserAllowed = false;
1240   }
1241 
1242   /**
1243    * @dev Allows normal users to call proval fns
1244    * Reverts if the sender is not owner of contract
1245    * @param _perm permission to users
1246    */
1247   function allowNormalUser(bool _perm)
1248     public 
1249     onlyOwner
1250     whenNotPaused
1251   {
1252     isNormalUserAllowed = _perm;
1253   }
1254 
1255   /**
1256    * @dev Allows submitting already signed transaction
1257    * Reverts if the signed data is incorrect
1258    * @param message signed message by user
1259    * @param r signature
1260    * @param s signature
1261    * @param v recovery id of signature
1262    * @param spender address which is approved
1263    * @param approved bool value for status of approval
1264    * message should be hash(functionWord, contractAddress, nonce, fnParams)
1265    */
1266   function provable_setApprovalForAll(bytes32 message, bytes32 r, bytes32 s, uint8 v, address spender, bool approved)
1267     public
1268     whenNotPaused
1269   {
1270     if (!isNormalUserAllowed) {
1271       uint8 opLevel = getOperatorLevel(msg.sender);
1272       require (opLevel != 0 && opLevel < 3); // level 3 operators are allowed to submit proof
1273     }
1274     address signer = getSigner(message, r, s, v);
1275     require (signer != address(0));
1276 
1277     bytes32 proof = getMessageSendApprovalForAll(signer, spender, approved);
1278     require( proof == message);
1279 
1280     // perform the original set Approval
1281     operatorApprovals[signer][spender] = approved;
1282     emit ApprovalForAll(signer, spender, approved);
1283     userNonce[signer] = userNonce[signer].add(1);
1284   }
1285 
1286   /**
1287    * @dev Allows submitting already signed transaction for weapon transfer
1288    * Reverts if the signed data is incorrect
1289    * @param message signed message by user
1290    * @param r signature
1291    * @param s signature
1292    * @param v recovery id of signature
1293    * @param to recipient address
1294    * @param tokenId ID of RC Weapon
1295    * message should be hash(functionWord, contractAddress, nonce, fnParams)
1296    */
1297   function provable_transfer(bytes32 message, bytes32 r, bytes32 s, uint8 v, address to, uint tokenId)
1298     public 
1299     whenNotPaused
1300   {
1301     if (!isNormalUserAllowed) {
1302       uint8 opLevel = getOperatorLevel(msg.sender);
1303       require (opLevel != 0 && opLevel < 3); // level 3 operators are allowed to submit proof
1304     }
1305     address signer = getSigner(message, r, s, v);
1306     require (signer != address(0));
1307 
1308     bytes32 proof = getMessageTransfer(signer, to, tokenId);
1309     require (proof == message);
1310     
1311     // Execute original function
1312     require(to != address(0));
1313     clearApproval(signer, tokenId);
1314     removeTokenFrom(signer, tokenId);
1315     addTokenTo(to, tokenId);
1316     emit Transfer(signer, to, tokenId);
1317 
1318     // update state variables
1319     userNonce[signer] = userNonce[signer].add(1);
1320   }
1321 
1322   /**
1323    * @dev Check signer of a message
1324    * @param message signed message by user
1325    * @param r signature
1326    * @param s signature
1327    * @param v recovery id of signature
1328    * @return signer of message
1329    */
1330   function getSigner(bytes32 message, bytes32 r, bytes32 s,  uint8 v) public pure returns (address){
1331     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1332     bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, message));
1333     address signer = ecrecover(prefixedHash,v,r,s);
1334     return signer;
1335   }
1336 
1337   /**
1338    * @dev Get message to be signed for transfer
1339    * @param signer of message
1340    * @param to recipient address
1341    * @param id weapon id
1342    * @return hash of (functionWord, contractAddress, nonce, ...fnParams)
1343    */
1344   function getMessageTransfer(address signer, address to, uint id)
1345     public
1346     view
1347     returns (bytes32) 
1348   {
1349     return keccak256(abi.encodePacked(
1350       bytes4(0xb483afd3),
1351       address(this),
1352       userNonce[signer],
1353       to,
1354       id
1355     ));
1356   }
1357 
1358   /**
1359    * @dev Get message to be signed for set Approval
1360    * @param signer of message
1361    * @param spender address which is approved
1362    * @param approved bool value for status of approval
1363    * @return hash of (functionWord, contractAddress, nonce, ...fnParams)
1364    */
1365   function getMessageSendApprovalForAll(address signer, address spender, bool approved)
1366     public 
1367     view 
1368     returns (bytes32)
1369   {
1370     bytes32 proof = keccak256(abi.encodePacked(
1371       bytes4(0xbad4c8ea),
1372       address(this),
1373       userNonce[signer],
1374       spender,
1375       approved
1376     ));
1377     return proof;
1378   }
1379 
1380   /**
1381   * returns nonce of user to be used for next signing
1382   */
1383   function getUserNonce(address user) public view returns (uint) {
1384     return userNonce[user];
1385   }
1386 
1387   /**
1388    * @dev Owner can transfer out any accidentally sent ERC20 tokens
1389    * @param contractAddress ERC20 contract address
1390    * @param to withdrawal address
1391    * @param value no of tokens to be withdrawan
1392    */
1393   function transferAnyERC20Token(address contractAddress, address to,  uint value) public onlyOwner {
1394     ERC20Interface(contractAddress).transfer(to, value);
1395   }
1396 
1397   /**
1398    * @dev Owner can transfer out any accidentally sent ERC721 tokens
1399    * @param contractAddress ERC721 contract address
1400    * @param to withdrawal address
1401    * @param tokenId Id of 721 token
1402    */
1403   function withdrawAnyERC721Token(address contractAddress, address to, uint tokenId) public onlyOwner {
1404     ERC721Basic(contractAddress).safeTransferFrom(address(this), to, tokenId);
1405   }
1406 
1407   /**
1408    * @dev Owner kill the smart contract
1409    * @param message Confirmation message to prevent accidebtal calling
1410    * @notice BE VERY CAREFULL BEFORE CALLING THIS FUNCTION
1411    * Better pause the contract
1412    * DO CALL "transferAnyERC20Token" before TO WITHDRAW ANY ERC-2O's FROM CONTRACT
1413    */
1414   function kill(uint message) public onlyOwner {
1415     require (message == 123456789987654321);
1416     // Transfer Eth to owner and terminate contract
1417     selfdestruct(msg.sender);
1418   }
1419 
1420 }