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
342   /** events **/
343   event RedTokenCreated(
344     address account, 
345     uint256 tokenId, 
346     string rmsBondNo, 
347     uint256 bondAmount, 
348     uint256 listingAmount, 
349     uint256 collectedAmount, 
350     uint createdTime
351   );
352   
353   /*
354    * @notice All redTokens in existence.
355    * @dev The ID of each redToken is an index in this array.
356    */
357   RedToken[] redTokens;
358   
359   /*
360    * @notice Get a redToken RmsBondNo
361    * @param _tokenId the token id
362    */
363   function redTokenRmsBondNo(uint256 _tokenId) external view returns (string memory) {
364     return redTokens[_tokenId].rmsBondNo;
365   }
366 
367   /*
368    * @notice Get a redToken BondAmount
369    * @param _tokenId the token id
370    */
371   function redTokenBondAmount(uint256 _tokenId) external view returns (uint256) {
372     return redTokens[_tokenId].bondAmount;
373   }
374 
375   /*
376    * @notice Get a redToken ListingAmount
377    * @param _tokenId the token id
378    */
379   function redTokenListingAmount(uint256 _tokenId) external view returns (uint256) {
380     return redTokens[_tokenId].listingAmount;
381   }
382   
383   /*
384    * @notice Get a redToken CollectedAmount
385    * @param _tokenId the token id
386    */
387   function redTokenCollectedAmount(uint256 _tokenId) external view returns (uint256) {
388     return redTokens[_tokenId].collectedAmount;
389   }
390 
391   /*
392    * @notice Get a redToken CreatedTime
393    * @param _tokenId the token id
394    */
395   function redTokenCreatedTime(uint256 _tokenId) external view returns (uint) {
396     return redTokens[_tokenId].createdTime;
397   }
398 
399   /*
400    * @notice isValid a redToken
401    * @param _tokenId the token id
402    */
403   function isValidRedToken(uint256 _tokenId) public view returns (bool) {
404     return redTokens[_tokenId].isValid;
405   }
406 
407   /*
408    * @notice info a redToken
409    * @param _tokenId the token id
410    */
411   function redTokenInfo(uint256 _tokenId)
412     external view returns (uint256, string memory, uint256, uint256, uint256, uint)
413   {
414     require(isValidRedToken(_tokenId));
415     RedToken memory _redToken = redTokens[_tokenId];
416 
417     return (
418         _redToken.tokenId,
419         _redToken.rmsBondNo,
420         _redToken.bondAmount,
421         _redToken.listingAmount,
422         _redToken.collectedAmount,
423         _redToken.createdTime
424     );
425   }
426   
427   /*
428    * @notice info a token of share users
429    * @param _tokenId the token id
430    */
431   function redTokenInfoOfshareUsers(uint256 _tokenId) external view returns (address[] memory, uint256[] memory) {
432     require(isValidRedToken(_tokenId));
433 
434     uint256 keySize = shareUsersKeys[_tokenId].length;
435 
436     address[] memory addrs   = new address[](keySize);
437     uint256[] memory amounts = new uint256[](keySize);
438 
439     for (uint index = 0; index < keySize; index++) {
440       addrs[index]   = shareUsersKeys[_tokenId][index];
441       amounts[index] = shareUsers[_tokenId][addrs[index]];
442     }
443     
444     return (addrs, amounts);
445   }
446 }
447 
448 // File: contracts\interfaces\ERC721.sol
449 
450 pragma solidity 0.5.7;
451 
452 /// @title ERC-721 Non-Fungible Token Standard
453 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
454 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
455 interface ERC721 {
456     /// @dev This emits when ownership of any NFT changes by any mechanism.
457     ///  This event emits when NFTs are created (`from` == 0) and destroyed
458     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
459     ///  may be created and assigned without emitting Transfer. At the time of
460     ///  any transfer, the approved address for that NFT (if any) is reset to none.
461     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
462 
463     /// @dev This emits when the approved address for an NFT is changed or
464     ///  reaffirmed. The zero address indicates there is no approved address.
465     ///  When a Transfer event emits, this also indicates that the approved
466     ///  address for that NFT (if any) is reset to none.
467     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
468 
469     /// @dev This emits when an operator is enabled or disabled for an owner.
470     ///  The operator can manage all NFTs of the owner.
471     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
472 
473     /// @notice Count all NFTs assigned to an owner
474     /// @dev NFTs assigned to the zero address are considered invalid, and this
475     ///  function throws for queries about the zero address.
476     /// @param _owner An address for whom to query the balance
477     /// @return The number of NFTs owned by `_owner`, possibly zero
478     function balanceOf(address _owner) external view returns (uint256);
479 
480     /// @notice Find the owner of an NFT
481     /// @dev NFTs assigned to zero address are considered invalid, and queries
482     ///  about them do throw.
483     /// @param _tokenId The identifier for an NFT
484     /// @return The address of the owner of the NFT
485     function ownerOf(uint256 _tokenId) external view returns (address);
486 
487     /// @notice Transfers the ownership of an NFT from one address to another address
488     /// @dev Throws unless `msg.sender` is the current owner, an authorized
489     ///  operator, or the approved address for this NFT. Throws if `_from` is
490     ///  not the current owner. Throws if `_to` is the zero address. Throws if
491     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
492     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
493     ///  `onERC721Received` on `_to` and throws if the return value is not
494     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
495     /// @param _from The current owner of the NFT
496     /// @param _to The new owner
497     /// @param _tokenId The NFT to transfer
498     /// @param data Additional data with no specified format, sent in call to `_to`
499     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
500 
501     /// @notice Transfers the ownership of an NFT from one address to another address
502     /// @dev This works identically to the other function with an extra data parameter,
503     ///  except this function just sets data to "".
504     /// @param _from The current owner of the NFT
505     /// @param _to The new owner
506     /// @param _tokenId The NFT to transfer
507     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
508 
509     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
510     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
511     ///  THEY MAY BE PERMANENTLY LOST
512     /// @dev Throws unless `msg.sender` is the current owner, an authorized
513     ///  operator, or the approved address for this NFT. Throws if `_from` is
514     ///  not the current owner. Throws if `_to` is the zero address. Throws if
515     ///  `_tokenId` is not a valid NFT.
516     /// @param _from The current owner of the NFT
517     /// @param _to The new owner
518     /// @param _tokenId The NFT to transfer
519     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
520 
521     /// @notice Change or reaffirm the approved address for an NFT
522     /// @dev The zero address indicates there is no approved address.
523     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
524     ///  operator of the current owner.
525     /// @param _approved The new approved NFT controller
526     /// @param _tokenId The NFT to approve
527     function approve(address _approved, uint256 _tokenId) external payable;
528 
529     /// @notice Enable or disable approval for a third party ("operator") to manage
530     ///  all of `msg.sender`'s assets
531     /// @dev Emits the ApprovalForAll event. The contract MUST allow
532     ///  multiple operators per owner.
533     /// @param _operator Address to add to the set of authorized operators
534     /// @param _approved True if the operator is approved, false to revoke approval
535     function setApprovalForAll(address _operator, bool _approved) external;
536 
537     /// @notice Get the approved address for a single NFT
538     /// @dev Throws if `_tokenId` is not a valid NFT.
539     /// @param _tokenId The NFT to find the approved address for
540     /// @return The approved address for this NFT, or the zero address if there is none
541     function getApproved(uint256 _tokenId) external view returns (address);
542 
543     /// @notice Query if an address is an authorized operator for another address
544     /// @param _owner The address that owns the NFTs
545     /// @param _operator The address that acts on behalf of the owner
546     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
547     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
548 }
549 
550 // File: contracts\interfaces\ERC721Metadata.sol
551 
552 pragma solidity 0.5.7;
553 
554 /*
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
557  *  Note: the ERC-165 identifier for this interface is 0x5b5e139f
558  */
559 interface ERC721Metadata /* is ERC721 */ {
560     
561     /*
562      * @notice A descriptive name for a collection of NFTs in this contract
563      */
564     function name() external pure returns (string memory _name);
565 
566     /*
567      * @notice An abbreviated name for NFTs in this contract
568      */ 
569     function symbol() external pure returns (string memory _symbol);
570 
571     /*
572      * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
573      * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
574      *  3986. The URI may point to a JSON file that conforms to the "ERC721
575      *  Metadata JSON Schema".
576      */
577     function tokenURI(uint256 _tokenId) external view returns (string memory);
578 }
579 
580 // File: contracts\interfaces\ERC721Enumerable.sol
581 
582 pragma solidity 0.5.7;
583 
584 /*
585  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
586  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
587  *  Note: the ERC-165 identifier for this interface is 0x780e9d63
588  */
589 interface ERC721Enumerable /* is ERC721 */ {
590     /*
591      * @notice Count NFTs tracked by this contract
592      * @return A count of valid NFTs tracked by this contract, where each one of
593      *  them has an assigned and queryable owner not equal to the zero address
594      */
595     function totalSupply() external view returns (uint256);
596 
597     /*
598      * @notice Enumerate valid NFTs
599      * @dev Throws if `_index` >= `totalSupply()`.
600      * @param _index A counter less than `totalSupply()`
601      * @return The token identifier for the `_index`th NFT,
602      *  (sort order not specified)
603      */
604     function tokenByIndex(uint256 _index) external view returns (uint256);
605 
606     /*
607      * @notice Enumerate NFTs assigned to an owner
608      * @dev Throws if `_index` >= `balanceOf(_owner)` or if
609      *  `_owner` is the zero address, representing invalid NFTs.
610      * @param _owner An address where we are interested in NFTs owned by them
611      * @param _index A counter less than `balanceOf(_owner)`
612      * @return The token identifier for the `_index`th NFT assigned to `_owner`,
613      *   (sort order not specified)
614      */
615     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
616 }
617 
618 // File: contracts\interfaces\ERC165.sol
619 
620 pragma solidity 0.5.7;
621 
622 interface ERC165 {
623     /*
624      * @notice Query if a contract implements an interface
625      * @param interfaceID The interface identifier, as specified in ERC-165
626      * @dev Interface identification is specified in ERC-165. This function
627      *  uses less than 30,000 gas.
628      * @return `true` if the contract implements `interfaceID` and
629      *  `interfaceID` is not 0xffffffff, `false` otherwise
630      */
631     function supportsInterface(bytes4 interfaceID) external view returns (bool);
632 }
633 
634 // File: contracts\strings\Strings.sol
635 
636 pragma solidity 0.5.7;
637 
638 library Strings {
639   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
640   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
641     bytes memory _ba = bytes(_a);
642     bytes memory _bb = bytes(_b);
643     bytes memory _bc = bytes(_c);
644     bytes memory _bd = bytes(_d);
645     bytes memory _be = bytes(_e);
646     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
647     bytes memory babcde = bytes(abcde);
648     uint k = 0;
649     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
650     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
651     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
652     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
653     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
654     return string(babcde);
655   }
656 
657   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
658     return strConcat(_a, _b, _c, _d, "");
659   }
660 
661   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
662     return strConcat(_a, _b, _c, "", "");
663   }
664 
665   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
666     return strConcat(_a, _b, "", "", "");
667   }
668 
669   function uint2str(uint i) internal pure returns (string memory) {
670     if (i == 0) return "0";
671     uint j = i;
672     uint len;
673     while (j != 0){
674         len++;
675         j /= 10;
676     }
677     bytes memory bstr = new bytes(len);
678     uint k = len - 1;
679     while (i != 0){
680         bstr[k--] = byte(uint8(48 + i % 10));
681         i /= 10;
682     }
683     return string(bstr);
684   }
685 }
686 
687 // File: contracts\interfaces\ERC721TokenReceiver.sol
688 
689 pragma solidity 0.5.7;
690 
691 /*
692  * @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
693  */
694 interface ERC721TokenReceiver {
695     /*
696      * @notice Handle the receipt of an NFT
697      * @dev The ERC721 smart contract calls this function on the recipient
698      *  after a `transfer`. This function MAY throw to revert and reject the
699      *  transfer. This function MUST use 50,000 gas or less. Return of other
700      *  than the magic value MUST result in the transaction being reverted.
701      *  Note: the contract address is always the message sender.
702      * @param _from The sending address
703      * @param _tokenId The NFT identifier which is being transfered
704      * @param _data Additional data with no specified format
705      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
706      *  unless throwing
707      */
708 	function onERC721Received(address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
709 }
710 
711 // File: contracts\RedTokenOwnership.sol
712 
713 pragma solidity 0.5.7;
714 
715 
716 
717 
718 
719 
720 
721 
722 /*
723  * @title RedTokenOwnership
724  * @notice control by TokenBase.
725  */
726 contract RedTokenOwnership is RedTokenBase, ERC721, ERC165, ERC721Metadata, ERC721Enumerable {
727   using SafeMath for uint256;
728 
729   // Total amount of tokens
730   uint256 private totalTokens;
731 
732   // Mapping from token ID to owner
733   mapping (uint256 => address) private tokenOwner;
734 
735   // Mapping from owner to list of owned token IDs
736   mapping (address => uint256[]) internal ownedTokens;
737 
738   // Mapping from token ID to index of the owner tokens list
739   mapping (uint256 => uint256) internal ownedTokensIndex;
740 
741   // Mapping from token ID to approved address
742   mapping (uint256 => address) internal tokenApprovals;
743 
744   // Mapping from owner address to operator address to approval
745   mapping (address => mapping (address => bool)) internal operatorApprovals;
746 
747   /** events **/
748   event calculateShareUsers(uint256 tokenId, address owner, address from, address to, uint256 amount);
749   event CollectedAmountUpdate(uint256 tokenId, address owner, uint256 amount);
750 
751   /** Constants **/
752   // Configure these for your own deployment
753   string internal constant NAME = "RedToken";
754   string internal constant SYMBOL = "REDT";
755   string internal tokenMetadataBaseURI = "https://doc.reditus.co.kr/?docid=";
756 
757   /** structs **/
758   function supportsInterface(
759     bytes4 interfaceID) // solium-disable-line dotta/underscore-function-arguments
760     external view returns (bool)
761   {
762     return
763       interfaceID == this.supportsInterface.selector || // ERC165
764       interfaceID == 0x5b5e139f || // ERC721Metadata
765       interfaceID == 0x80ac58cd || // ERC-721
766       interfaceID == 0x780e9d63; // ERC721Enumerable
767   }
768 
769   /*
770    * @notice Guarantees msg.sender is owner of the given token
771    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
772    */
773   modifier onlyOwnerOf(uint256 _tokenId) {
774     require(ownerOf(_tokenId) == msg.sender);
775     _;
776   }
777 
778   /** external functions **/  
779   /*
780    * @notice token's name
781    */
782   function name() external pure returns (string memory) {
783     return NAME;
784   }
785 
786   /*
787    * @notice symbols's name
788    */
789   function symbol() external pure returns (string memory) {
790     return SYMBOL;
791   }
792 
793   /*
794    * @notice tokenURI
795    * @dev do not checked in array and used function isValidRedToken value is not important, only check in redTokens array
796    */
797   function tokenURI(uint256 _tokenId)
798     external
799     view
800     returns (string memory infoUrl)
801   {
802     if ( isValidRedToken(_tokenId) ){
803       return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
804     }else{
805       return Strings.strConcat( tokenMetadataBaseURI, Strings.uint2str(_tokenId));
806     }
807   }
808 
809   /*
810    * @notice setTokenMetadataBaseURI
811    */
812   function setTokenMetadataBaseURI(string calldata _newBaseURI) external onlyCOO {
813     tokenMetadataBaseURI = _newBaseURI;
814   }
815 
816   /*
817    * @notice Gets the total amount of tokens stored by the contract
818    * @return uint256 representing the total amount of tokens
819    */
820   function totalSupply() external view returns (uint256) {
821     return totalTokens;
822   }
823 
824   /*
825    * @dev Gets the owner of the specified token ID
826    * @param _tokenId uint256 ID of the token to query the owner of
827    * @return owner address currently marked as the owner of the given token ID
828    */
829   function ownerOf(uint256 _tokenId) public view returns (address) {
830     address owner = tokenOwner[_tokenId];
831     require(owner != address(0));
832     return owner;
833   }
834 
835   /*
836    * @notice Gets the balance of the specified address
837    * @param _owner address to query the balance of
838    * @return uint256 representing the amount owned by the passed address
839    */
840   function balanceOf(address _owner) public view returns (uint256) {
841     require(_owner != address(0));
842     return ownedTokens[_owner].length;
843   }
844 
845   /*
846    * @notice Gets the list of tokens owned by a given address
847    * @param _owner address to query the tokens of
848    * @return uint256[] representing the list of tokens owned by the passed address
849    */
850   function tokensOf(address _owner) external view returns (uint256[] memory) {
851     require(_owner != address(0));
852     return ownedTokens[_owner];
853   }
854 
855   /*
856   * @notice Enumerate valid NFTs
857   * @dev Our Licenses are kept in an array and each new License-token is just
858   * the next element in the array. This method is required for ERC721Enumerable
859   * which may support more complicated storage schemes. However, in our case the
860   * _index is the tokenId
861   * @param _index A counter less than `totalSupply()`
862   * @return The token identifier for the `_index`th NFT
863   */
864   function tokenByIndex(uint256 _index) external view returns (uint256) {
865     require(_index < totalTokens);
866     return _index;
867   }
868 
869   /*
870    * @notice Enumerate NFTs assigned to an owner
871    * @dev Throws if `_index` >= `balanceOf(_owner)` or if
872    *  `_owner` is the zero address, representing invalid NFTs.
873    * @param _owner An address where we are interested in NFTs owned by them
874    * @param _index A counter less than `balanceOf(_owner)`
875    * @return The token identifier for the `_index`th NFT assigned to `_owner`,
876    */
877   function tokenOfOwnerByIndex(address _owner, uint256 _index)
878     external
879     view
880     returns (uint256 _tokenId)
881   {
882     require(_index < balanceOf(_owner));
883     return ownedTokens[_owner][_index];
884   }
885 
886   /*
887    * @notice Gets the approved address to take ownership of a given token ID
888    * @param _tokenId uint256 ID of the token to query the approval of
889    * @return address currently approved to take ownership of the given token ID
890    */
891   function getApproved(uint256 _tokenId) public view returns (address) {
892     return tokenApprovals[_tokenId];
893   }
894 
895   /*
896    * @notice Tells whether an operator is approved by a given owner
897    * @param _owner owner address which you want to query the approval of
898    * @param _operator operator address which you want to query the approval of
899    * @return bool whether the given operator is approved by the given owner
900    */
901   function isApprovedForAll(address _owner, address _operator) public view returns (bool)
902   {
903     return operatorApprovals[_owner][_operator];
904   }
905 
906   /*
907    * @notice Approves another address to claim for the ownership of the given token ID
908    * @param _to address to be approved for the given token ID
909    * @param _tokenId uint256 ID of the token to be approved
910    */
911   function approve(address _to, uint256 _tokenId)
912     external
913     payable
914     whenNotPaused
915     whenNotPausedUser(msg.sender)
916     onlyOwnerOf(_tokenId)
917   {
918     require(_to != ownerOf(_tokenId));
919     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
920       tokenApprovals[_tokenId] = _to;
921 
922       emit Approval(ownerOf(_tokenId), _to, _tokenId);
923     }
924   }
925 
926   /*
927    * @notice Enable or disable approval for a third party ("operator") to manage all your assets
928    * @dev Emits the ApprovalForAll event
929    * @param _to Address to add to the set of authorized operators.
930    * @param _approved True if the operators is approved, false to revoke approval
931    */
932   function setApprovalForAll(address _to, bool _approved)
933     external
934     whenNotPaused
935     whenNotPausedUser(msg.sender)
936   {
937     if(_approved) {
938       approveAll(_to);
939     } else {
940       disapproveAll(_to);
941     }
942   }
943 
944   /*
945    * @notice Approves another address to claim for the ownership of any tokens owned by this account
946    * @param _to address to be approved for the given token ID
947    */
948   function approveAll(address _to)
949     internal
950     whenNotPaused
951     whenNotPausedUser(msg.sender)
952   {
953     require(_to != msg.sender);
954     require(_to != address(0));
955     operatorApprovals[msg.sender][_to] = true;
956 
957     emit ApprovalForAll(msg.sender, _to, true);
958   }
959 
960   /*
961    * @notice Removes approval for another address to claim for the ownership of any
962    *  tokens owned by this account.
963    * @dev Note that this only removes the operator approval and
964    *  does not clear any independent, specific approvals of token transfers to this address
965    * @param _to address to be disapproved for the given token ID
966    */
967   function disapproveAll(address _to)
968     internal
969     whenNotPaused
970     whenNotPausedUser(msg.sender)
971   {
972     require(_to != msg.sender);
973     delete operatorApprovals[msg.sender][_to];
974     
975     emit ApprovalForAll(msg.sender, _to, false);
976   }
977 
978   /*
979    * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
980    * Checks both for specific approval and operator approval
981    * @param _tokenId uint256 ID of the token to query the approval of
982    * @return bool whether transfer by msg.sender is approved for the given token ID or not
983    */
984   function isSenderApprovedFor(uint256 _tokenId) public view returns (bool) {
985     return
986       ownerOf(_tokenId) == msg.sender ||
987       getApproved(_tokenId) == msg.sender ||
988       isApprovedForAll(ownerOf(_tokenId), msg.sender);
989   }
990   
991   /*
992    * @notice Transfers the ownership of a given token ID to another address
993    * @param _to address to receive the ownership of the given token ID
994    * @param _tokenId uint256 ID of the token to be transferred
995    */
996   function transfer(address _to, uint256 _tokenId)
997     external
998     payable
999     whenNotPaused
1000     whenNotPausedUser(msg.sender)
1001     onlyOwnerOf(_tokenId)
1002   {
1003     _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
1004   }
1005 
1006   /*
1007    * @notice Transfer a token owned by another address, for which the calling address has
1008    *  previously been granted transfer approval by the owner.
1009    * @param _from The address that owns the token
1010    * @param _to The address that will take ownership of the token. Can be any address, including the caller
1011    * @param _tokenId The ID of the token to be transferred
1012    */
1013   function transferFrom(
1014     address _from,
1015     address _to,
1016     uint256 _tokenId
1017   )
1018     external
1019     payable
1020     whenNotPaused
1021     whenNotPausedUser(msg.sender)
1022   {
1023     require(isSenderApprovedFor(_tokenId));
1024     _clearApprovalAndTransfer(_from, _to, _tokenId);
1025   }
1026   
1027   /*
1028    * @notice Transfers the ownership of an NFT from one address to another address
1029    * @dev This works identically to the other function with an extra data parameter,
1030    *  except this function just sets data to ""
1031    * @param _from The current owner of the NFT
1032    * @param _to The new owner
1033    * @param _tokenId The NFT to transfer
1034   */
1035   function safeTransferFrom(
1036     address _from,
1037     address _to,
1038     uint256 _tokenId
1039   )
1040     external
1041     payable
1042     whenNotPaused
1043     whenNotPausedUser(msg.sender)
1044   {
1045     require(isSenderApprovedFor(_tokenId));
1046     _safeTransferFrom(_from, _to, _tokenId, "");
1047   }
1048 
1049   /*
1050    * @notice Transfers the ownership of an NFT from one address to another address
1051    * @dev Throws unless `msg.sender` is the current owner, an authorized
1052    * operator, or the approved address for this NFT. Throws if `_from` is
1053    * not the current owner. Throws if `_to` is the zero address. Throws if
1054    * `_tokenId` is not a valid NFT. When transfer is complete, this function
1055    * checks if `_to` is a smart contract (code size > 0). If so, it calls
1056    * `onERC721Received` on `_to` and throws if the return value is not
1057    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
1058    * @param _from The current owner of the NFT
1059    * @param _to The new owner
1060    * @param _tokenId The NFT to transfer
1061    * @param _data Additional data with no specified format, sent in call to `_to`
1062    */
1063   function safeTransferFrom(
1064     address _from,
1065     address _to,
1066     uint256 _tokenId,
1067     bytes calldata _data
1068   )
1069     external
1070     payable
1071     whenNotPaused
1072     whenNotPausedUser(msg.sender)
1073   {
1074     require(isSenderApprovedFor(_tokenId));
1075     _safeTransferFrom(_from, _to, _tokenId, _data);
1076   }
1077 
1078   /*
1079    * @notice send amount shareUsers
1080    */
1081   function sendAmountShareUsers(
1082     uint256 _tokenId, 
1083     address _to, 
1084     uint256 _amount
1085   ) 
1086     external 
1087     onlyCOO
1088     returns (bool) 
1089   {
1090     require(_to != address(0));
1091     return _calculateShareUsers(_tokenId, ownerOf(_tokenId), _to, _amount);
1092   }
1093 
1094   /*
1095    * @notice send amount shareUsers
1096    */
1097   function sendAmountShareUsersFrom(
1098     uint256 _tokenId, 
1099     address _from, 
1100     address _to, 
1101     uint256 _amount
1102   ) 
1103     external 
1104     onlyCOO
1105     returns (bool) 
1106   {
1107     require(_to != address(0));
1108     return _calculateShareUsers(_tokenId, _from, _to, _amount);
1109   }
1110 
1111   /*
1112    * @notice update collectedAmount 
1113    */
1114   function updateCollectedAmount(
1115     uint256 _tokenId, 
1116     uint256 _amount
1117   ) 
1118     external 
1119     onlyCOO 
1120     returns (bool) 
1121   {
1122     require(isValidRedToken(_tokenId));
1123     require(_amount > 0);
1124         
1125     redTokens[_tokenId].collectedAmount = redTokens[_tokenId].collectedAmount.add(_amount);
1126     
1127     emit CollectedAmountUpdate(_tokenId, ownerOf(_tokenId), _amount);
1128     return true;
1129   }
1130 
1131   /*
1132    * @notice createRedToken
1133    */
1134   function createRedToken(
1135     address _user, 
1136     string calldata _rmsBondNo, 
1137     uint256 _bondAmount, 
1138     uint256 _listingAmount
1139   ) 
1140     external 
1141     onlyCOO 
1142     returns (uint256) 
1143   {
1144     return _createRedToken(_user,_rmsBondNo,_bondAmount,_listingAmount);
1145   }
1146 
1147   /*
1148    * @notice burn amount a token by share users
1149    */
1150   function burnAmountByShareUser(
1151     uint256 _tokenId, 
1152     address _from, 
1153     uint256 _amount
1154   ) 
1155     external 
1156     onlyCOO 
1157     returns (bool) 
1158   {
1159     return _calculateShareUsers(_tokenId, _from, address(0), _amount);
1160   }
1161   
1162   /*
1163    * @notice burn RedToken
1164    */
1165   function burn(
1166     address _owner, 
1167     uint256 _tokenId
1168   ) 
1169     external 
1170     onlyCOO 
1171     returns(bool) 
1172   {
1173     require(_owner != address(0));
1174     return _burn(_owner, _tokenId);
1175   }
1176 
1177   /** internal function **/
1178   function isContract(address _addr) internal view returns (bool) {
1179     uint size;
1180     assembly { size := extcodesize(_addr) }
1181     return size > 0;
1182   }
1183 
1184   /*
1185    * @notice checked shareUser by shareUsersKeys
1186    */
1187   function isShareUser(
1188     uint256 _tokenId, 
1189     address _from
1190   ) 
1191     internal  
1192     view 
1193     returns (bool) 
1194   {
1195     bool chechedUser = false;
1196     for (uint index = 0; index < shareUsersKeys[_tokenId].length; index++) {
1197       if (  shareUsersKeys[_tokenId][index] == _from ){
1198         chechedUser = true;
1199         break;
1200       }
1201     }
1202     return chechedUser;
1203   }
1204 
1205   /*
1206    * @notice Transfers the ownership of an NFT from one address to another address
1207    * @param _from The current owner of the NFT
1208    * @param _to The new owner
1209    * @param _tokenId The NFT to transfer
1210    * @param _data Additional data with no specified format, sent in call to `_to`
1211    */
1212   function _safeTransferFrom(
1213     address _from,
1214     address _to,
1215     uint256 _tokenId,
1216     bytes memory _data
1217   )
1218     internal
1219   {
1220     _clearApprovalAndTransfer(_from, _to, _tokenId);
1221 
1222     if (isContract(_to)) {
1223       bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
1224         _from, _tokenId, _data
1225       );
1226       require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
1227     }
1228   }
1229 
1230   /*
1231   * @notice Internal function to clear current approval and transfer the ownership of a given token ID
1232   * @param _from address which you want to send tokens from
1233   * @param _to address which you want to transfer the token to
1234   * @param _tokenId uint256 ID of the token to be transferred
1235   */
1236   function _clearApprovalAndTransfer(
1237     address _from, 
1238     address _to, 
1239     uint256 _tokenId
1240   )
1241     internal 
1242   {
1243     require(_to != address(0));
1244     require(_to != ownerOf(_tokenId));
1245     require(ownerOf(_tokenId) == _from);
1246     require(isValidRedToken(_tokenId));
1247     
1248     address owner = ownerOf(_tokenId);
1249 
1250     _clearApproval(owner, _tokenId);
1251     _removeToken(owner, _tokenId);
1252     _addToken(_to, _tokenId);
1253     _changeTokenShareUserByOwner(owner, _to, _tokenId);
1254 
1255     emit Transfer(owner, _to, _tokenId);
1256   }
1257 
1258   /*
1259    * @notice change token owner rate sending
1260    * @param _from address which you want to change rate from
1261    * @param _to address which you want to change rate the token to
1262    * @param _tokenId uint256 ID of the token to be change rate
1263    */
1264   function _changeTokenShareUserByOwner(
1265     address _from, 
1266     address _to, 
1267     uint256 _tokenId
1268   ) 
1269     internal  
1270   {
1271     uint256 amount = shareUsers[_tokenId][_from];
1272     delete shareUsers[_tokenId][_from];
1273 
1274     shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(amount);
1275 
1276     if ( !isShareUser(_tokenId, _to) ) {
1277       shareUsersKeys[_tokenId].push(_to);
1278     }
1279   }
1280 
1281   /*
1282    * @notice remove shareUsers
1283    */
1284   function _calculateShareUsers(
1285     uint256 _tokenId, 
1286     address _from, 
1287     address _to, 
1288     uint256 _amount
1289   ) 
1290     internal
1291     returns (bool) 
1292   {
1293     require(_from != address(0));
1294     require(_from != _to);
1295     require(_amount > 0);
1296     require(shareUsers[_tokenId][_from] >= _amount);
1297     require(isValidRedToken(_tokenId));
1298     
1299     shareUsers[_tokenId][_from] = shareUsers[_tokenId][_from].sub(_amount);
1300     shareUsers[_tokenId][_to] = shareUsers[_tokenId][_to].add(_amount);
1301 
1302     if ( !isShareUser(_tokenId, _to) ) {
1303       shareUsersKeys[_tokenId].push(_to);
1304     }
1305 
1306     emit calculateShareUsers(_tokenId, ownerOf(_tokenId), _from, _to, _amount);
1307     return true;
1308   }
1309 
1310   /*
1311   * @notice Internal function to clear current approval of a given token ID
1312   * @param _tokenId uint256 ID of the token to be transferred
1313   */
1314   function _clearApproval(
1315     address _owner,
1316     uint256 _tokenId
1317   ) 
1318     internal 
1319   {
1320     require(ownerOf(_tokenId) == _owner);
1321     
1322     tokenApprovals[_tokenId] = address(0);
1323 
1324     emit Approval(_owner, address(0), _tokenId);
1325   }
1326 
1327   function _createRedToken(
1328     address _user, 
1329     string memory _rmsBondNo, 
1330     uint256 _bondAmount, 
1331     uint256 _listingAmount
1332   ) 
1333     internal 
1334     returns (uint256)
1335   {
1336     require(_user != address(0));
1337     require(bytes(_rmsBondNo).length > 0);
1338     require(_bondAmount > 0);
1339     require(_listingAmount > 0);
1340 
1341     uint256 _newTokenId = redTokens.length;
1342 
1343     RedToken memory _redToken = RedToken({
1344       tokenId: _newTokenId,
1345       rmsBondNo: _rmsBondNo,
1346       bondAmount: _bondAmount,
1347       listingAmount: _listingAmount,
1348       collectedAmount: 0,
1349       createdTime: now,
1350       isValid:true
1351     });
1352 
1353     redTokens.push(_redToken) - 1;
1354 
1355     shareUsers[_newTokenId][_user] = shareUsers[_newTokenId][_user].add(_listingAmount);
1356     shareUsersKeys[_newTokenId].push(_user);
1357 
1358     _addToken(_user, _newTokenId);
1359 
1360     emit RedTokenCreated(_user,
1361                         _redToken.tokenId,
1362                         _redToken.rmsBondNo,
1363                         _redToken.bondAmount,
1364                         _redToken.listingAmount,
1365                         _redToken.collectedAmount,
1366                         _redToken.createdTime);
1367     
1368     return _newTokenId;
1369   }
1370   
1371   /*
1372   * @notice Internal function to add a token ID to the list of a given address
1373   * @param _to address representing the new owner of the given token ID
1374   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1375   */
1376   function _addToken(
1377     address _to, 
1378     uint256 _tokenId
1379   ) 
1380     internal 
1381   {
1382     require(tokenOwner[_tokenId] == address(0));
1383 
1384     tokenOwner[_tokenId] = _to;
1385     uint256 length = balanceOf(_to);
1386     ownedTokens[_to].push(_tokenId);
1387     ownedTokensIndex[_tokenId] = length;
1388     totalTokens = totalTokens.add(1);
1389   }
1390 
1391   /*
1392   * @notice Internal function to remove a token ID from the list of a given address
1393   * @param _from address representing the previous owner of the given token ID
1394   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1395   */
1396   function _removeToken(
1397     address _from, 
1398     uint256 _tokenId
1399   ) 
1400     internal 
1401   {
1402     require(ownerOf(_tokenId) == _from);
1403 
1404     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1405     uint256 lastTokenIndex = balanceOf(_from).sub(1);
1406     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1407 
1408     tokenOwner[_tokenId] = address(0);
1409     ownedTokens[_from][tokenIndex] = lastToken;
1410     ownedTokens[_from][lastTokenIndex] = 0;
1411     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1412     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1413     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1414 
1415     ownedTokens[_from].length--;
1416     ownedTokensIndex[_tokenId] = 0;
1417     ownedTokensIndex[lastToken] = tokenIndex;
1418     totalTokens = totalTokens.sub(1);
1419   }
1420 
1421   /*
1422    * @dev Internal function to burn a specific token
1423    * @dev Reverts if the token does not exist
1424    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1425    */
1426   function _burn(
1427     address _owner, 
1428     uint256 _tokenId
1429   ) 
1430     internal 
1431     returns(bool) 
1432   {
1433     require(ownerOf(_tokenId) == _owner);
1434     _clearApproval(_owner, _tokenId);
1435     _removeToken(_owner, _tokenId);
1436 
1437     redTokens[_tokenId].isValid = false;
1438 
1439     emit Transfer(_owner, address(0), _tokenId);
1440     return true;
1441   }
1442 }
1443 
1444 // File: contracts\RedTokenCore.sol
1445 
1446 pragma solidity 0.5.7;
1447 
1448 
1449 /*
1450  * @title RedTokenCore is the entry point of the contract
1451  * @notice RedTokenCore is the entry point and it controls the ability to set a new
1452  * contract address, in the case where an upgrade is required
1453  */
1454 contract RedTokenCore is RedTokenOwnership{
1455 
1456   constructor() public {
1457     ceoAddress = msg.sender;
1458     cooAddress = msg.sender;
1459     cfoAddress = msg.sender;
1460   }
1461 
1462   function() external {
1463     assert(false);
1464   }
1465 }