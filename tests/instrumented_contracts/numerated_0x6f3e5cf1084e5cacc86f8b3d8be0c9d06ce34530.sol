1 // File: contracts\math\SafeMath.sol
2 
3 pragma solidity 0.5.7;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts\RedTokenAccessControl.sol
70 
71 pragma solidity 0.5.7;
72 
73 /*
74  * @title RedTokenAccessControl
75  * @notice This contract defines organizational roles and permissions.
76  */
77 contract RedTokenAccessControl {
78 
79   event Paused();
80   event Unpaused();
81   event PausedUser(address indexed account);
82   event UnpausedUser(address indexed account);
83 
84   /*
85    * @notice CEO's address
86    */
87   address public ceoAddress;
88 
89   /*
90    * @notice CFO's address
91    */
92   address public cfoAddress;
93 
94   /*
95    * @notice COO's address
96    */
97   address public cooAddress;
98 
99   bool public paused = false;
100 
101   /*
102    * @notice paused users status
103    */
104   mapping (address => bool) private pausedUsers;
105 
106   /*
107    * @notice init constructor
108    */
109   constructor () internal {
110       ceoAddress = msg.sender;
111       cfoAddress = msg.sender;
112       cooAddress = msg.sender;
113   }
114 
115   /*
116    * @dev Modifier to make a function only callable by the CEO
117    */
118   modifier onlyCEO() {
119     require(msg.sender == ceoAddress);
120     _;
121   }
122 
123   /*
124    * @dev Modifier to make a function only callable by the CFO
125    */
126   modifier onlyCFO() {
127     require(msg.sender == cfoAddress);
128     _;
129   }
130 
131   /*
132    * @dev Modifier to make a function only callable by the COO
133    */
134   modifier onlyCOO() {
135     require(msg.sender == cooAddress);
136     _;
137   }
138 
139   /*
140    * @dev Modifier to make a function only callable by C-level execs
141    */
142   modifier onlyCLevel() {
143     require(
144       msg.sender == cooAddress ||
145       msg.sender == ceoAddress ||
146       msg.sender == cfoAddress
147     );
148     _;
149   }
150 
151   /*
152    * @dev Modifier to make a function only callable by CEO or CFO
153    */
154   modifier onlyCEOOrCFO() {
155     require(
156       msg.sender == cfoAddress ||
157       msg.sender == ceoAddress
158     );
159     _;
160   }
161 
162   /*
163    * @dev Modifier to make a function only callable by CEO or COO
164    */
165   modifier onlyCEOOrCOO() {
166     require(
167       msg.sender == cooAddress ||
168       msg.sender == ceoAddress
169     );
170     _;
171   }
172 
173   /*
174    * @notice Sets a new CEO
175    * @param _newCEO - the address of the new CEO
176    */
177   function setCEO(address _newCEO) external onlyCEO {
178     require(_newCEO != address(0));
179     ceoAddress = _newCEO;
180   }
181 
182   /*
183    * @notice Sets a new CFO
184    * @param _newCFO - the address of the new CFO
185    */
186   function setCFO(address _newCFO) external onlyCEO {
187     require(_newCFO != address(0));
188     cfoAddress = _newCFO;
189   }
190 
191   /*
192    * @notice Sets a new COO
193    * @param _newCOO - the address of the new COO
194    */
195   function setCOO(address _newCOO) external onlyCEO {
196     require(_newCOO != address(0));
197     cooAddress = _newCOO;
198   }
199 
200   /* Pausable functionality adapted from OpenZeppelin **/
201   /*
202    * @dev Modifier to make a function callable only when the contract is not paused.
203    */
204   modifier whenNotPaused() {
205     require(!paused);
206     _;
207   }
208 
209   /*
210    * @dev Modifier to make a function callable only when the contract is paused.
211    */
212   modifier whenPaused() {
213     require(paused);
214     _;
215   }
216 
217   /*
218    * @notice called by any C-LEVEL to pause, triggers stopped state
219    */
220   function pause() external onlyCLevel whenNotPaused {
221     paused = true;
222     emit Paused();
223   }
224 
225   /*
226    * @notice called by any C-LEVEL to unpause, returns to normal state
227    */
228   function unpause() external onlyCLevel whenPaused {
229     paused = false;
230     emit Unpaused();
231   }
232 
233   /* user Pausable functionality ref someting : openzeppelin/access/Roles.sol **/
234   /*
235    * @dev Modifier to make a function callable only when the user is not paused.
236    */
237   modifier whenNotPausedUser(address account) {
238     require(account != address(0));
239     require(!pausedUsers[account]);
240     _;
241   }
242 
243   /*
244    * @dev Modifier to make a function callable only when the user is paused.
245    */
246   modifier whenPausedUser(address account) {
247     require(account != address(0));
248     require(pausedUsers[account]);
249     _;
250   }
251 
252   /*
253     * @dev check if an account has this pausedUsers
254     * @return bool
255     */
256   function has(address account) internal view returns (bool) {
257       require(account != address(0));
258       return pausedUsers[account];
259   }
260   
261   /*
262    * @notice _addPauseUser
263    */
264   function _addPauseUser(address account) internal {
265       require(account != address(0));
266       require(!has(account));
267 
268       pausedUsers[account] = true;
269 
270       emit PausedUser(account);
271   }
272 
273   /*
274    * @notice _unpausedUser
275    */
276   function _unpausedUser(address account) internal {
277       require(account != address(0));
278       require(has(account));
279 
280       pausedUsers[account] = false;
281       emit UnpausedUser(account);
282   }
283 
284   /*
285    * @notice isPausedUser
286    */
287   function isPausedUser(address account) external view returns (bool) {
288       return has(account);
289   }
290 
291   /*
292    * @notice called by the COO to pauseUser, triggers stopped user state
293    */
294   function pauseUser(address account) external onlyCOO whenNotPausedUser(account) {
295     _addPauseUser(account);
296   }
297 
298   /*
299    * @notice called by any C-LEVEL to unpauseUser, returns to user state
300    */
301   function unpauseUser(address account) external onlyCLevel whenPausedUser(account) {
302     _unpausedUser(account);
303   }
304 }
305 
306 // File: contracts\RedTokenBase.sol
307 
308 pragma solidity 0.5.7;
309 
310 
311 
312 /*
313  * @title RedTokenBase
314  * @notice This contract defines the RedToken data structure and how to read from it / functions
315  */
316 contract RedTokenBase is RedTokenAccessControl {
317   using SafeMath for uint256;
318 
319   /*
320    * @notice Product defines a RedToken
321    */ 
322   struct RedToken {
323     uint256 tokenId;
324     string rmsBondNo;
325     uint256 bondAmount;
326     uint256 listingAmount;
327     uint256 collectedAmount;
328     uint createdTime;
329     bool isValid;
330   }
331 
332   /*
333    * @notice tokenId for share users by listingAmount
334    */
335   mapping (uint256 => mapping(address => uint256)) shareUsers;
336 
337   /*
338    * @notice tokenid by share accounts in shareUsers list iterator.
339    */
340   mapping (uint256 => address []) shareUsersKeys;
341   
342   /*
343    * @notice All redTokens in existence.
344    * @dev The ID of each redToken is an index in this array.
345    */
346   RedToken[] redTokens;
347   
348   /*
349    * @notice Get a redToken RmsBondNo
350    * @param _tokenId the token id
351    */
352   function redTokenRmsBondNo(uint256 _tokenId) external view returns (string memory) {
353     return redTokens[_tokenId].rmsBondNo;
354   }
355 
356   /*
357    * @notice Get a redToken BondAmount
358    * @param _tokenId the token id
359    */
360   function redTokenBondAmount(uint256 _tokenId) external view returns (uint256) {
361     return redTokens[_tokenId].bondAmount;
362   }
363 
364   /*
365    * @notice Get a redToken ListingAmount
366    * @param _tokenId the token id
367    */
368   function redTokenListingAmount(uint256 _tokenId) external view returns (uint256) {
369     return redTokens[_tokenId].listingAmount;
370   }
371   
372   /*
373    * @notice Get a redToken CollectedAmount
374    * @param _tokenId the token id
375    */
376   function redTokenCollectedAmount(uint256 _tokenId) external view returns (uint256) {
377     return redTokens[_tokenId].collectedAmount;
378   }
379 
380   /*
381    * @notice Get a redToken CreatedTime
382    * @param _tokenId the token id
383    */
384   function redTokenCreatedTime(uint256 _tokenId) external view returns (uint) {
385     return redTokens[_tokenId].createdTime;
386   }
387 
388   /*
389    * @notice isValid a redToken
390    * @param _tokenId the token id
391    */
392   function isValidRedToken(uint256 _tokenId) public view returns (bool) {
393     return redTokens[_tokenId].isValid;
394   }
395 
396   /*
397    * @notice info a redToken
398    * @param _tokenId the token id
399    */
400   function redTokenInfo(uint256 _tokenId)
401     external view returns (uint256, string memory, uint256, uint256, uint256, uint)
402   {
403     require(isValidRedToken(_tokenId));
404     RedToken memory _redToken = redTokens[_tokenId];
405 
406     return (
407         _redToken.tokenId,
408         _redToken.rmsBondNo,
409         _redToken.bondAmount,
410         _redToken.listingAmount,
411         _redToken.collectedAmount,
412         _redToken.createdTime
413     );
414   }
415   
416   /*
417    * @notice info a token of share users
418    * @param _tokenId the token id
419    */
420   function redTokenInfoOfshareUsers(uint256 _tokenId) external view returns (address[] memory, uint256[] memory) {
421     require(isValidRedToken(_tokenId));
422 
423     uint256 keySize = shareUsersKeys[_tokenId].length;
424 
425     address[] memory addrs   = new address[](keySize);
426     uint256[] memory amounts = new uint256[](keySize);
427 
428     for (uint index = 0; index < keySize; index++) {
429       addrs[index]   = shareUsersKeys[_tokenId][index];
430       amounts[index] = shareUsers[_tokenId][addrs[index]];
431     }
432     
433     return (addrs, amounts);
434   }
435 }
436 
437 // File: contracts\interfaces\ERC721.sol
438 
439 pragma solidity 0.5.7;
440 
441 /// @title ERC-721 Non-Fungible Token Standard
442 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
443 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
444 interface ERC721 {
445     /// @dev This emits when ownership of any NFT changes by any mechanism.
446     ///  This event emits when NFTs are created (`from` == 0) and destroyed
447     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
448     ///  may be created and assigned without emitting Transfer. At the time of
449     ///  any transfer, the approved address for that NFT (if any) is reset to none.
450     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
451 
452     /// @dev This emits when the approved address for an NFT is changed or
453     ///  reaffirmed. The zero address indicates there is no approved address.
454     ///  When a Transfer event emits, this also indicates that the approved
455     ///  address for that NFT (if any) is reset to none.
456     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
457 
458     /// @dev This emits when an operator is enabled or disabled for an owner.
459     ///  The operator can manage all NFTs of the owner.
460     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
461 
462     /// @notice Count all NFTs assigned to an owner
463     /// @dev NFTs assigned to the zero address are considered invalid, and this
464     ///  function throws for queries about the zero address.
465     /// @param _owner An address for whom to query the balance
466     /// @return The number of NFTs owned by `_owner`, possibly zero
467     function balanceOf(address _owner) external view returns (uint256);
468 
469     /// @notice Find the owner of an NFT
470     /// @dev NFTs assigned to zero address are considered invalid, and queries
471     ///  about them do throw.
472     /// @param _tokenId The identifier for an NFT
473     /// @return The address of the owner of the NFT
474     function ownerOf(uint256 _tokenId) external view returns (address);
475 
476     /// @notice Transfers the ownership of an NFT from one address to another address
477     /// @dev Throws unless `msg.sender` is the current owner, an authorized
478     ///  operator, or the approved address for this NFT. Throws if `_from` is
479     ///  not the current owner. Throws if `_to` is the zero address. Throws if
480     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
481     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
482     ///  `onERC721Received` on `_to` and throws if the return value is not
483     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
484     /// @param _from The current owner of the NFT
485     /// @param _to The new owner
486     /// @param _tokenId The NFT to transfer
487     /// @param data Additional data with no specified format, sent in call to `_to`
488     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
489 
490     /// @notice Transfers the ownership of an NFT from one address to another address
491     /// @dev This works identically to the other function with an extra data parameter,
492     ///  except this function just sets data to "".
493     /// @param _from The current owner of the NFT
494     /// @param _to The new owner
495     /// @param _tokenId The NFT to transfer
496     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
497 
498     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
499     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
500     ///  THEY MAY BE PERMANENTLY LOST
501     /// @dev Throws unless `msg.sender` is the current owner, an authorized
502     ///  operator, or the approved address for this NFT. Throws if `_from` is
503     ///  not the current owner. Throws if `_to` is the zero address. Throws if
504     ///  `_tokenId` is not a valid NFT.
505     /// @param _from The current owner of the NFT
506     /// @param _to The new owner
507     /// @param _tokenId The NFT to transfer
508     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
509 
510     /// @notice Change or reaffirm the approved address for an NFT
511     /// @dev The zero address indicates there is no approved address.
512     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
513     ///  operator of the current owner.
514     /// @param _approved The new approved NFT controller
515     /// @param _tokenId The NFT to approve
516     function approve(address _approved, uint256 _tokenId) external payable;
517 
518     /// @notice Enable or disable approval for a third party ("operator") to manage
519     ///  all of `msg.sender`'s assets
520     /// @dev Emits the ApprovalForAll event. The contract MUST allow
521     ///  multiple operators per owner.
522     /// @param _operator Address to add to the set of authorized operators
523     /// @param _approved True if the operator is approved, false to revoke approval
524     function setApprovalForAll(address _operator, bool _approved) external;
525 
526     /// @notice Get the approved address for a single NFT
527     /// @dev Throws if `_tokenId` is not a valid NFT.
528     /// @param _tokenId The NFT to find the approved address for
529     /// @return The approved address for this NFT, or the zero address if there is none
530     function getApproved(uint256 _tokenId) external view returns (address);
531 
532     /// @notice Query if an address is an authorized operator for another address
533     /// @param _owner The address that owns the NFTs
534     /// @param _operator The address that acts on behalf of the owner
535     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
536     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
537 }
538 
539 // File: contracts\interfaces\ERC721Metadata.sol
540 
541 pragma solidity 0.5.7;
542 
543 /*
544  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
545  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
546  *  Note: the ERC-165 identifier for this interface is 0x5b5e139f
547  */
548 interface ERC721Metadata /* is ERC721 */ {
549     
550     /*
551      * @notice A descriptive name for a collection of NFTs in this contract
552      */
553     function name() external pure returns (string memory _name);
554 
555     /*
556      * @notice An abbreviated name for NFTs in this contract
557      */ 
558     function symbol() external pure returns (string memory _symbol);
559 
560     /*
561      * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
562      * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
563      *  3986. The URI may point to a JSON file that conforms to the "ERC721
564      *  Metadata JSON Schema".
565      */
566     function tokenURI(uint256 _tokenId) external view returns (string memory);
567 }
568 
569 // File: contracts\interfaces\ERC721Enumerable.sol
570 
571 pragma solidity 0.5.7;
572 
573 /*
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
576  *  Note: the ERC-165 identifier for this interface is 0x780e9d63
577  */
578 interface ERC721Enumerable /* is ERC721 */ {
579     /*
580      * @notice Count NFTs tracked by this contract
581      * @return A count of valid NFTs tracked by this contract, where each one of
582      *  them has an assigned and queryable owner not equal to the zero address
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /*
587      * @notice Enumerate valid NFTs
588      * @dev Throws if `_index` >= `totalSupply()`.
589      * @param _index A counter less than `totalSupply()`
590      * @return The token identifier for the `_index`th NFT,
591      *  (sort order not specified)
592      */
593     function tokenByIndex(uint256 _index) external view returns (uint256);
594 
595     /*
596      * @notice Enumerate NFTs assigned to an owner
597      * @dev Throws if `_index` >= `balanceOf(_owner)` or if
598      *  `_owner` is the zero address, representing invalid NFTs.
599      * @param _owner An address where we are interested in NFTs owned by them
600      * @param _index A counter less than `balanceOf(_owner)`
601      * @return The token identifier for the `_index`th NFT assigned to `_owner`,
602      *   (sort order not specified)
603      */
604     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
605 }
606 
607 // File: contracts\interfaces\ERC165.sol
608 
609 pragma solidity 0.5.7;
610 
611 interface ERC165 {
612     /*
613      * @notice Query if a contract implements an interface
614      * @param interfaceID The interface identifier, as specified in ERC-165
615      * @dev Interface identification is specified in ERC-165. This function
616      *  uses less than 30,000 gas.
617      * @return `true` if the contract implements `interfaceID` and
618      *  `interfaceID` is not 0xffffffff, `false` otherwise
619      */
620     function supportsInterface(bytes4 interfaceID) external view returns (bool);
621 }
622 
623 // File: contracts\strings\Strings.sol
624 
625 pragma solidity 0.5.7;
626 
627 library Strings {
628   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
629   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
630     bytes memory _ba = bytes(_a);
631     bytes memory _bb = bytes(_b);
632     bytes memory _bc = bytes(_c);
633     bytes memory _bd = bytes(_d);
634     bytes memory _be = bytes(_e);
635     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
636     bytes memory babcde = bytes(abcde);
637     uint k = 0;
638     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
639     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
640     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
641     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
642     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
643     return string(babcde);
644   }
645 
646   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
647     return strConcat(_a, _b, _c, _d, "");
648   }
649 
650   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
651     return strConcat(_a, _b, _c, "", "");
652   }
653 
654   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
655     return strConcat(_a, _b, "", "", "");
656   }
657 
658   function uint2str(uint i) internal pure returns (string memory) {
659     if (i == 0) return "0";
660     uint j = i;
661     uint len;
662     while (j != 0){
663         len++;
664         j /= 10;
665     }
666     bytes memory bstr = new bytes(len);
667     uint k = len - 1;
668     while (i != 0){
669         bstr[k--] = byte(uint8(48 + i % 10));
670         i /= 10;
671     }
672     return string(bstr);
673   }
674 }
675 
676 // File: contracts\interfaces\ERC721TokenReceiver.sol
677 
678 pragma solidity 0.5.7;
679 
680 /*
681  * @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
682  */
683 interface ERC721TokenReceiver {
684     /*
685      * @notice Handle the receipt of an NFT
686      * @dev The ERC721 smart contract calls this function on the recipient
687      *  after a `transfer`. This function MAY throw to revert and reject the
688      *  transfer. This function MUST use 50,000 gas or less. Return of other
689      *  than the magic value MUST result in the transaction being reverted.
690      *  Note: the contract address is always the message sender.
691      * @param _from The sending address
692      * @param _tokenId The NFT identifier which is being transfered
693      * @param _data Additional data with no specified format
694      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
695      *  unless throwing
696      */
697 	function onERC721Received(address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
698 }
699 
700 // File: contracts\RedTokenOwnership.sol
701 
702 pragma solidity 0.5.7;
703 
704 
705 
706 
707 
708 
709 
710 
711 /*
712  * @title RedTokenOwnership
713  * @notice control by TokenBase.
714  */
715 contract RedTokenOwnership is RedTokenBase, ERC721, ERC165, ERC721Metadata, ERC721Enumerable {
716   using SafeMath for uint256;
717 
718   // Total amount of tokens
719   uint256 private totalTokens;
720 
721   // Mapping from token ID to owner
722   mapping (uint256 => address) private tokenOwner;
723 
724   // Mapping from owner to list of owned token IDs
725   mapping (address => uint256[]) internal ownedTokens;
726 
727   // Mapping from token ID to index of the owner tokens list
728   mapping (uint256 => uint256) internal ownedTokensIndex;
729 
730   // Mapping from token ID to approved address
731   mapping (uint256 => address) internal tokenApprovals;
732 
733   // Mapping from owner address to operator address to approval
734   mapping (address => mapping (address => bool)) internal operatorApprovals;
735 
736   /** events **/
737   event calculateShareUsers(uint256 tokenId, address owner, address from, address to, uint256 amount);
738   event CollectedAmountUpdate(uint256 tokenId, address owner, uint256 amount);
739 
740   /** Constants **/
741   // Configure these for your own deployment
742   string internal constant NAME = "RedToken";
743   string internal constant SYMBOL = "REDT";
744   string internal tokenMetadataBaseURI = "https://doc.reditus.co.kr/?docid=";
745 
746   /** structs **/
747   function supportsInterface(
748     bytes4 interfaceID) // solium-disable-line dotta/underscore-function-arguments
749     external view returns (bool)
750   {
751     return
752       interfaceID == this.supportsInterface.selector || // ERC165
753       interfaceID == 0x5b5e139f || // ERC721Metadata
754       interfaceID == 0x80ac58cd || // ERC-721
755       interfaceID == 0x780e9d63; // ERC721Enumerable
756   }
757 
758   /*
759    * @notice Guarantees msg.sender is owner of the given token
760    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
761    */
762   modifier onlyOwnerOf(uint256 _tokenId) {
763     require(ownerOf(_tokenId) == msg.sender);
764     _;
765   }
766 
767   /** external functions **/  
768   /*
769    * @notice token's name
770    */
771   function name() external pure returns (string memory) {
772     return NAME;
773   }
774 
775   /*
776    * @notice symbols's name
777    */
778   function symbol() external pure returns (string memory) {
779     return SYMBOL;
780   }
781 
782   /*
783    * @notice tokenURI
784    * @dev do not checked in array and used function isValidRedToken value is not important, only check in redTokens array
785    */
786   function tokenURI(uint256 _tokenId)
787     external
788     view
789     returns (string memory infoUrl)
790   {
791     if ( isValidRedToken(_tokenId) ){
792       return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
793     }else{
794       return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
795     }
796   }
797 
798   /*
799    * @notice setTokenMetadataBaseURI
800    */
801   function setTokenMetadataBaseURI(string calldata _newBaseURI) external onlyCOO {
802     tokenMetadataBaseURI = _newBaseURI;
803   }
804 
805   /*
806    * @notice Gets the total amount of tokens stored by the contract
807    * @return uint256 representing the total amount of tokens
808    */
809   function totalSupply() external view returns (uint256) {
810     return totalTokens;
811   }
812 
813   /*
814    * @dev Gets the owner of the specified token ID
815    * @param _tokenId uint256 ID of the token to query the owner of
816    * @return owner address currently marked as the owner of the given token ID
817    */
818   function ownerOf(uint256 _tokenId) public view returns (address) {
819     address owner = tokenOwner[_tokenId];
820     require(owner != address(0));
821     return owner;
822   }
823 
824   /*
825    * @notice Gets the balance of the specified address
826    * @param _owner address to query the balance of
827    * @return uint256 representing the amount owned by the passed address
828    */
829   function balanceOf(address _owner) public view returns (uint256) {
830     require(_owner != address(0));
831     return ownedTokens[_owner].length;
832   }
833 
834   /*
835    * @notice Gets the list of tokens owned by a given address
836    * @param _owner address to query the tokens of
837    * @return uint256[] representing the list of tokens owned by the passed address
838    */
839   function tokensOf(address _owner) external view returns (uint256[] memory) {
840     require(_owner != address(0));
841     return ownedTokens[_owner];
842   }
843 
844   /*
845   * @notice Enumerate valid NFTs
846   * @dev Our Licenses are kept in an array and each new License-token is just
847   * the next element in the array. This method is required for ERC721Enumerable
848   * which may support more complicated storage schemes. However, in our case the
849   * _index is the tokenId
850   * @param _index A counter less than `totalSupply()`
851   * @return The token identifier for the `_index`th NFT
852   */
853   function tokenByIndex(uint256 _index) external view returns (uint256) {
854     require(_index < totalTokens);
855     return _index;
856   }
857 
858   /*
859    * @notice Enumerate NFTs assigned to an owner
860    * @dev Throws if `_index` >= `balanceOf(_owner)` or if
861    *  `_owner` is the zero address, representing invalid NFTs.
862    * @param _owner An address where we are interested in NFTs owned by them
863    * @param _index A counter less than `balanceOf(_owner)`
864    * @return The token identifier for the `_index`th NFT assigned to `_owner`,
865    */
866   function tokenOfOwnerByIndex(address _owner, uint256 _index)
867     external
868     view
869     returns (uint256 _tokenId)
870   {
871     require(_index < balanceOf(_owner));
872     return ownedTokens[_owner][_index];
873   }
874 
875   /*
876    * @notice Gets the approved address to take ownership of a given token ID
877    * @param _tokenId uint256 ID of the token to query the approval of
878    * @return address currently approved to take ownership of the given token ID
879    */
880   function getApproved(uint256 _tokenId) public view returns (address) {
881     return tokenApprovals[_tokenId];
882   }
883 
884   /*
885    * @notice Tells whether an operator is approved by a given owner
886    * @param _owner owner address which you want to query the approval of
887    * @param _operator operator address which you want to query the approval of
888    * @return bool whether the given operator is approved by the given owner
889    */
890   function isApprovedForAll(address _owner, address _operator) public view returns (bool)
891   {
892     return operatorApprovals[_owner][_operator];
893   }
894 
895   /*
896    * @notice Approves another address to claim for the ownership of the given token ID
897    * @param _to address to be approved for the given token ID
898    * @param _tokenId uint256 ID of the token to be approved
899    */
900   function approve(address _to, uint256 _tokenId)
901     external
902     payable
903     whenNotPaused
904     whenNotPausedUser(msg.sender)
905     onlyOwnerOf(_tokenId)
906   {
907     require(_to != ownerOf(_tokenId));
908     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
909       tokenApprovals[_tokenId] = _to;
910 
911       emit Approval(ownerOf(_tokenId), _to, _tokenId);
912     }
913   }
914 
915   /*
916    * @notice Enable or disable approval for a third party ("operator") to manage all your assets
917    * @dev Emits the ApprovalForAll event
918    * @param _to Address to add to the set of authorized operators.
919    * @param _approved True if the operators is approved, false to revoke approval
920    */
921   function setApprovalForAll(address _to, bool _approved)
922     external
923     whenNotPaused
924     whenNotPausedUser(msg.sender)
925   {
926     if(_approved) {
927       approveAll(_to);
928     } else {
929       disapproveAll(_to);
930     }
931   }
932 
933   /*
934    * @notice Approves another address to claim for the ownership of any tokens owned by this account
935    * @param _to address to be approved for the given token ID
936    */
937   function approveAll(address _to)
938     internal
939     whenNotPaused
940     whenNotPausedUser(msg.sender)
941   {
942     require(_to != msg.sender);
943     require(_to != address(0));
944     operatorApprovals[msg.sender][_to] = true;
945 
946     emit ApprovalForAll(msg.sender, _to, true);
947   }
948 
949   /*
950    * @notice Removes approval for another address to claim for the ownership of any
951    *  tokens owned by this account.
952    * @dev Note that this only removes the operator approval and
953    *  does not clear any independent, specific approvals of token transfers to this address
954    * @param _to address to be disapproved for the given token ID
955    */
956   function disapproveAll(address _to)
957     internal
958     whenNotPaused
959     whenNotPausedUser(msg.sender)
960   {
961     require(_to != msg.sender);
962     delete operatorApprovals[msg.sender][_to];
963     
964     emit ApprovalForAll(msg.sender, _to, false);
965   }
966 
967   /*
968    * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
969    * Checks both for specific approval and operator approval
970    * @param _tokenId uint256 ID of the token to query the approval of
971    * @return bool whether transfer by msg.sender is approved for the given token ID or not
972    */
973   function isSenderApprovedFor(uint256 _tokenId) public view returns (bool) {
974     return
975       ownerOf(_tokenId) == msg.sender ||
976       getApproved(_tokenId) == msg.sender ||
977       isApprovedForAll(ownerOf(_tokenId), msg.sender);
978   }
979   
980   /*
981    * @notice Transfers the ownership of a given token ID to another address
982    * @param _to address to receive the ownership of the given token ID
983    * @param _tokenId uint256 ID of the token to be transferred
984    */
985   function transfer(address _to, uint256 _tokenId)
986     external
987     payable
988     whenNotPaused
989     whenNotPausedUser(msg.sender)
990     onlyOwnerOf(_tokenId)
991   {
992     _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
993   }
994 
995   /*
996    * @notice Transfer a token owned by another address, for which the calling address has
997    *  previously been granted transfer approval by the owner.
998    * @param _from The address that owns the token
999    * @param _to The address that will take ownership of the token. Can be any address, including the caller
1000    * @param _tokenId The ID of the token to be transferred
1001    */
1002   function transferFrom(
1003     address _from,
1004     address _to,
1005     uint256 _tokenId
1006   )
1007     external
1008     payable
1009     whenNotPaused
1010     whenNotPausedUser(msg.sender)
1011   {
1012     require(isSenderApprovedFor(_tokenId));
1013     _clearApprovalAndTransfer(_from, _to, _tokenId);
1014   }
1015   
1016   /*
1017    * @notice Transfers the ownership of an NFT from one address to another address
1018    * @dev This works identically to the other function with an extra data parameter,
1019    *  except this function just sets data to ""
1020    * @param _from The current owner of the NFT
1021    * @param _to The new owner
1022    * @param _tokenId The NFT to transfer
1023   */
1024   function safeTransferFrom(
1025     address _from,
1026     address _to,
1027     uint256 _tokenId
1028   )
1029     external
1030     payable
1031     whenNotPaused
1032     whenNotPausedUser(msg.sender)
1033   {
1034     require(isSenderApprovedFor(_tokenId));
1035     _safeTransferFrom(_from, _to, _tokenId, "");
1036   }
1037 
1038   /*
1039    * @notice Transfers the ownership of an NFT from one address to another address
1040    * @dev Throws unless `msg.sender` is the current owner, an authorized
1041    * operator, or the approved address for this NFT. Throws if `_from` is
1042    * not the current owner. Throws if `_to` is the zero address. Throws if
1043    * `_tokenId` is not a valid NFT. When transfer is complete, this function
1044    * checks if `_to` is a smart contract (code size > 0). If so, it calls
1045    * `onERC721Received` on `_to` and throws if the return value is not
1046    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
1047    * @param _from The current owner of the NFT
1048    * @param _to The new owner
1049    * @param _tokenId The NFT to transfer
1050    * @param _data Additional data with no specified format, sent in call to `_to`
1051    */
1052   function safeTransferFrom(
1053     address _from,
1054     address _to,
1055     uint256 _tokenId,
1056     bytes calldata _data
1057   )
1058     external
1059     payable
1060     whenNotPaused
1061     whenNotPausedUser(msg.sender)
1062   {
1063     require(isSenderApprovedFor(_tokenId));
1064     _safeTransferFrom(_from, _to, _tokenId, _data);
1065   }
1066 
1067   /*
1068    * @notice send amount shareUsers
1069    */
1070   function sendAmountShareUsers(
1071     uint256 _tokenId, 
1072     address _to, 
1073     uint256 _amount
1074   ) 
1075     external 
1076     onlyCOO
1077     returns (bool) 
1078   {
1079     require(_to != address(0));
1080     return _calculateShareUsers(_tokenId, ownerOf(_tokenId), _to, _amount);
1081   }
1082 
1083   /*
1084    * @notice send amount shareUsers
1085    */
1086   function sendAmountShareUsersFrom(
1087     uint256 _tokenId, 
1088     address _from, 
1089     address _to, 
1090     uint256 _amount
1091   ) 
1092     external 
1093     onlyCOO
1094     returns (bool) 
1095   {
1096     require(_to != address(0));
1097     return _calculateShareUsers(_tokenId, _from, _to, _amount);
1098   }
1099 
1100   /*
1101    * @notice update collectedAmount 
1102    */
1103   function updateCollectedAmount(
1104     uint256 _tokenId, 
1105     uint256 _amount
1106   ) 
1107     external 
1108     onlyCOO 
1109     returns (bool) 
1110   {
1111     require(isValidRedToken(_tokenId));
1112     require(_amount > 0);
1113         
1114     redTokens[_tokenId].collectedAmount = redTokens[_tokenId].collectedAmount.add(_amount);
1115     
1116     emit CollectedAmountUpdate(_tokenId, ownerOf(_tokenId), _amount);
1117     return true;
1118   }
1119 
1120   /*
1121    * @notice createRedToken
1122    */
1123   function createRedToken(
1124     address _user, 
1125     string calldata _rmsBondNo, 
1126     uint256 _bondAmount, 
1127     uint256 _listingAmount
1128   ) 
1129     external 
1130     onlyCOO 
1131     returns (uint256) 
1132   {
1133     return _createRedToken(_user,_rmsBondNo,_bondAmount,_listingAmount);
1134   }
1135 
1136   /*
1137    * @notice burn amount a token by share users
1138    */
1139   function burnAmountByShareUser(
1140     uint256 _tokenId, 
1141     address _from, 
1142     uint256 _amount
1143   ) 
1144     external 
1145     onlyCOO 
1146     returns (bool) 
1147   {
1148     return _calculateShareUsers(_tokenId, _from, address(0), _amount);
1149   }
1150   
1151   /*
1152    * @notice burn RedToken
1153    */
1154   function burn(
1155     address _owner, 
1156     uint256 _tokenId
1157   ) 
1158     external 
1159     onlyCOO 
1160     returns(bool) 
1161   {
1162     require(_owner != address(0));
1163     return _burn(_owner, _tokenId);
1164   }
1165 
1166   /** internal function **/
1167   function isContract(address _addr) internal view returns (bool) {
1168     uint size;
1169     assembly { size := extcodesize(_addr) }
1170     return size > 0;
1171   }
1172 
1173   /*
1174    * @notice checked shareUser by shareUsersKeys
1175    */
1176   function isShareUser(
1177     uint256 _tokenId, 
1178     address _from
1179   ) 
1180     internal  
1181     view 
1182     returns (bool) 
1183   {
1184     bool chechedUser = false;
1185     for (uint index = 0; index < shareUsersKeys[_tokenId].length; index++) {
1186       if (  shareUsersKeys[_tokenId][index] == _from ){
1187         chechedUser = true;
1188         break;
1189       }
1190     }
1191     return chechedUser;
1192   }
1193 
1194   /*
1195    * @notice Transfers the ownership of an NFT from one address to another address
1196    * @param _from The current owner of the NFT
1197    * @param _to The new owner
1198    * @param _tokenId The NFT to transfer
1199    * @param _data Additional data with no specified format, sent in call to `_to`
1200    */
1201   function _safeTransferFrom(
1202     address _from,
1203     address _to,
1204     uint256 _tokenId,
1205     bytes memory _data
1206   )
1207     internal
1208   {
1209     _clearApprovalAndTransfer(_from, _to, _tokenId);
1210 
1211     if (isContract(_to)) {
1212       bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
1213         _from, _tokenId, _data
1214       );
1215       require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
1216     }
1217   }
1218 
1219   /*
1220   * @notice Internal function to clear current approval and transfer the ownership of a given token ID
1221   * @param _from address which you want to send tokens from
1222   * @param _to address which you want to transfer the token to
1223   * @param _tokenId uint256 ID of the token to be transferred
1224   */
1225   function _clearApprovalAndTransfer(
1226     address _from, 
1227     address _to, 
1228     uint256 _tokenId
1229   )
1230     internal 
1231   {
1232     require(_to != address(0));
1233     require(_to != ownerOf(_tokenId));
1234     require(ownerOf(_tokenId) == _from);
1235     require(isValidRedToken(_tokenId));
1236     
1237     address owner = ownerOf(_tokenId);
1238 
1239     _clearApproval(owner, _tokenId);
1240     _removeToken(owner, _tokenId);
1241     _addToken(_to, _tokenId);
1242     _changeTokenShareUserByOwner(owner, _to, _tokenId);
1243 
1244     emit Transfer(owner, _to, _tokenId);
1245   }
1246 
1247   /*
1248    * @notice change token owner rate sending
1249    * @param _from address which you want to change rate from
1250    * @param _to address which you want to change rate the token to
1251    * @param _tokenId uint256 ID of the token to be change rate
1252    */
1253   function _changeTokenShareUserByOwner(
1254     address _from, 
1255     address _to, 
1256     uint256 _tokenId
1257   ) 
1258     internal  
1259   {
1260     uint256 amount = shareUsers[_tokenId][_from];
1261     delete shareUsers[_tokenId][_from];
1262 
1263     shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(amount);
1264 
1265     if ( !isShareUser(_tokenId, _to) ) {
1266       shareUsersKeys[_tokenId].push(_to);
1267     }
1268   }
1269 
1270   /*
1271    * @notice remove shareUsers
1272    */
1273   function _calculateShareUsers(
1274     uint256 _tokenId, 
1275     address _from, 
1276     address _to, 
1277     uint256 _amount
1278   ) 
1279     internal
1280     returns (bool) 
1281   {
1282     require(_from != address(0));
1283     require(_from != _to);
1284     require(_amount > 0);
1285     require(shareUsers[_tokenId][_from] >= _amount);
1286     require(isValidRedToken(_tokenId));
1287     
1288     shareUsers[_tokenId][_from] = shareUsers[_tokenId][_from].sub(_amount);
1289     shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(_amount);
1290 
1291     if ( !isShareUser(_tokenId, _to) ) {
1292       shareUsersKeys[_tokenId].push(_to);
1293     }
1294 
1295     emit calculateShareUsers(_tokenId, ownerOf(_tokenId), _from, _to, _amount);
1296     return true;
1297   }
1298 
1299   /*
1300   * @notice Internal function to clear current approval of a given token ID
1301   * @param _tokenId uint256 ID of the token to be transferred
1302   */
1303   function _clearApproval(
1304     address _owner,
1305     uint256 _tokenId
1306   ) 
1307     internal 
1308   {
1309     require(ownerOf(_tokenId) == _owner);
1310     
1311     tokenApprovals[_tokenId] = address(0);
1312 
1313     emit Approval(_owner, address(0), _tokenId);
1314   }
1315 
1316   function _createRedToken(
1317     address _user, 
1318     string memory _rmsBondNo, 
1319     uint256 _bondAmount, 
1320     uint256 _listingAmount
1321   ) 
1322     internal 
1323     returns (uint256)
1324   {
1325     require(_user != address(0));
1326     require(bytes(_rmsBondNo).length > 0);
1327     require(_bondAmount > 0);
1328     require(_listingAmount > 0);
1329 
1330     uint256 _newTokenId = redTokens.length;
1331 
1332     RedToken memory _redToken = RedToken({
1333       tokenId: _newTokenId,
1334       rmsBondNo: _rmsBondNo,
1335       bondAmount: _bondAmount,
1336       listingAmount: _listingAmount,
1337       collectedAmount: 0,
1338       createdTime: now,
1339       isValid:true
1340     });
1341 
1342     redTokens.push(_redToken) - 1;
1343 
1344     shareUsers[_newTokenId][_user] = shareUsers[_newTokenId][_user].add(_listingAmount);
1345     shareUsersKeys[_newTokenId].push(_user);
1346 
1347     _addToken(_user, _newTokenId);
1348 
1349     emit Transfer(address(0), _user, _newTokenId);
1350 
1351     return _newTokenId;
1352   }
1353   
1354   /*
1355   * @notice Internal function to add a token ID to the list of a given address
1356   * @param _to address representing the new owner of the given token ID
1357   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1358   */
1359   function _addToken(
1360     address _to, 
1361     uint256 _tokenId
1362   ) 
1363     internal 
1364   {
1365     require(tokenOwner[_tokenId] == address(0));
1366 
1367     tokenOwner[_tokenId] = _to;
1368     uint256 length = balanceOf(_to);
1369     ownedTokens[_to].push(_tokenId);
1370     ownedTokensIndex[_tokenId] = length;
1371     totalTokens = totalTokens.add(1);
1372   }
1373 
1374   /*
1375   * @notice Internal function to remove a token ID from the list of a given address
1376   * @param _from address representing the previous owner of the given token ID
1377   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1378   */
1379   function _removeToken(
1380     address _from, 
1381     uint256 _tokenId
1382   ) 
1383     internal 
1384   {
1385     require(ownerOf(_tokenId) == _from);
1386 
1387     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1388     uint256 lastTokenIndex = balanceOf(_from).sub(1);
1389     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1390 
1391     tokenOwner[_tokenId] = address(0);
1392     ownedTokens[_from][tokenIndex] = lastToken;
1393     ownedTokens[_from][lastTokenIndex] = 0;
1394     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1395     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1396     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1397 
1398     ownedTokens[_from].length--;
1399     ownedTokensIndex[_tokenId] = 0;
1400     ownedTokensIndex[lastToken] = tokenIndex;
1401     totalTokens = totalTokens.sub(1);
1402   }
1403 
1404   /*
1405    * @dev Internal function to burn a specific token
1406    * @dev Reverts if the token does not exist
1407    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1408    */
1409   function _burn(
1410     address _owner, 
1411     uint256 _tokenId
1412   ) 
1413     internal 
1414     returns(bool) 
1415   {
1416     require(ownerOf(_tokenId) == _owner);
1417     _clearApproval(_owner, _tokenId);
1418     _removeToken(_owner, _tokenId);
1419 
1420     redTokens[_tokenId].isValid = false;
1421 
1422     emit Transfer(_owner, address(0), _tokenId);
1423     return true;
1424   }
1425 }
1426 
1427 // File: contracts\RedTokenCore.sol
1428 
1429 pragma solidity 0.5.7;
1430 
1431 
1432 /*
1433  * @title RedTokenCore is the entry point of the contract
1434  * @notice RedTokenCore is the entry point and it controls the ability to set a new
1435  * contract address, in the case where an upgrade is required
1436  */
1437 contract RedTokenCore is RedTokenOwnership{
1438 
1439   constructor() public {
1440     ceoAddress = msg.sender;
1441     cooAddress = msg.sender;
1442     cfoAddress = msg.sender;
1443   }
1444 
1445   function() external {
1446     assert(false);
1447   }
1448 }