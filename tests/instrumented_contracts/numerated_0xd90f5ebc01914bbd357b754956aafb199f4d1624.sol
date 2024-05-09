1 pragma solidity ^0.4.24;
2 
3 /// @title New Child Kydy's Genes
4 contract GeneSynthesisInterface {
5     /// @dev boolean to check this is the contract we expect to be
6     function isGeneSynthesis() public pure returns (bool);
7 
8     /**
9      * @dev Synthesizes the genes of yin and yang Kydy, and returns the result as the child's genes. 
10      * @param gene1 genes of yin Kydy
11      * @param gene2 genes of yang Kydy
12      * @return the genes of the child
13      */
14     function synthGenes(uint256 gene1, uint256 gene2) public returns (uint256);
15 }
16 
17 /**
18  * @title Part of KydyCore that manages special access controls.
19  * @author VREX Lab Co., Ltd
20  * @dev See the KydyCore contract documentation to understand how the various contracts are arranged.
21  */
22 contract KydyAccessControl {
23     /**
24      * This contract defines access control for the following important roles of the Dyverse:
25      *
26      *     - The CEO: The CEO can assign roles and change the addresses of the smart contracts. 
27      *         It can also solely unpause the smart contract. 
28      *
29      *     - The CFO: The CFO can withdraw funds from the KydyCore and the auction contracts.
30      *
31      *     - The COO: The COO can release Generation 0 Kydys and create promotional-type Kydys.
32      *
33      */
34 
35     /// @dev Used when contract is upgraded. 
36     event ContractUpgrade(address newContract);
37 
38     // The assigned addresses of each role, as defined in this contract. 
39     address public ceoAddress;
40     address public cfoAddress;
41     address public cooAddress;
42 
43     /// @dev Checks if the contract is paused. When paused, most of the functions of this contract will also be stopped.
44     bool public paused = false;
45 
46     /// @dev Access modifier for CEO-only
47     modifier onlyCEO() {
48         require(msg.sender == ceoAddress);
49         _;
50     }
51 
52     /// @dev Access modifier for CFO-only
53     modifier onlyCFO() {
54         require(msg.sender == cfoAddress);
55         _;
56     }
57 
58     /// @dev Access modifier for COO-only
59     modifier onlyCOO() {
60         require(msg.sender == cooAddress);
61         _;
62     }
63 
64     /// @dev Access modifier for CEO, CFO, COO
65     modifier onlyCLevel() {
66         require(
67             msg.sender == ceoAddress ||
68             msg.sender == cfoAddress ||
69             msg.sender == cooAddress
70         );
71         _;
72     }
73 
74     /**
75      * @dev Assigns a new address to the CEO. Only the current CEO has the authority.
76      * @param _newCEO The address of the new CEO
77      */
78     function setCEO(address _newCEO) external onlyCEO {
79         require(_newCEO != address(0));
80 
81         ceoAddress = _newCEO;
82     }
83 
84     /**
85      * @dev Assigns a new address to the CFO. Only the current CEO has the authority.
86      * @param _newCFO The address of the new CFO
87      */
88     function setCFO(address _newCFO) external onlyCEO {
89         require(_newCFO != address(0));
90 
91         cfoAddress = _newCFO;
92     }
93 
94     /**
95      * @dev Assigns a new address to the COO. Only the current CEO has the authority.
96      * @param _newCOO The address of the new COO
97      */
98     function setCOO(address _newCOO) external onlyCEO {
99         require(_newCOO != address(0));
100 
101         cooAddress = _newCOO;
102     }
103 
104     /*** Pausable functionality adapted from OpenZeppelin ***/
105 
106     /// @dev Modifier to allow actions only when the contract IS NOT paused
107     modifier whenNotPaused() {
108         require(!paused);
109         _;
110     }
111 
112     /// @dev Modifier to allow actions only when the contract IS paused
113     modifier whenPaused {
114         require(paused);
115         _;
116     }
117 
118     /**
119      * @dev Called by any "C-level" role to pause the contract. Used only when
120      *  a bug or exploit is detected to limit the damage.
121      */
122     function pause() external onlyCLevel whenNotPaused {
123         paused = true;
124     }
125 
126     /**
127      * @dev Unpauses the smart contract. Can only be called by the CEO, since
128      *  one reason we may pause the contract is when CFO or COO accounts are
129      *  compromised.
130      * @notice This is public rather than external so it can be called by
131      *  derived contracts.
132      */
133     function unpause() public onlyCEO whenPaused {
134         // can't unpause if contract was upgraded
135         paused = false;
136     }
137 }
138 
139 contract ERC165Interface {
140     /**
141      * @notice Query if a contract implements an interface
142      * @param interfaceID The interface identifier, as specified in ERC-165
143      * @dev Interface identification is specified in ERC-165. This function
144      *  uses less than 30,000 gas.
145      * @return `true` if the contract implements `interfaceID` and
146      *  `interfaceID` is not 0xffffffff, `false` otherwise
147      */
148     function supportsInterface(bytes4 interfaceID) external view returns (bool);
149 }
150 
151 contract ERC165 is ERC165Interface {
152     /**
153      * @dev a mapping of interface id to whether or not it's supported
154      */
155     mapping(bytes4 => bool) private _supportedInterfaces;
156 
157     /**
158      * @dev implement supportsInterface(bytes4) using a lookup table
159      */
160     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
161         return _supportedInterfaces[interfaceId];
162     }
163 
164     /**
165      * @dev internal method for registering an interface
166      */
167     function _registerInterface(bytes4 interfaceId) internal {
168         require(interfaceId != 0xffffffff);
169         _supportedInterfaces[interfaceId] = true;
170     }
171 }
172 
173 // Every ERC-721 compliant contract must implement the ERC721 and ERC165 interfaces.
174 /** 
175  * @title ERC-721 Non-Fungible Token Standard
176  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
177  * Note: the ERC-165 identifier for this interface is 0x80ac58cd.
178  */
179 contract ERC721Basic is ERC165 {
180     // Below is MUST
181 
182     /**
183      * @dev This emits when ownership of any NFT changes by any mechanism.
184      *  This event emits when NFTs are created (`from` == 0) and destroyed
185      *  (`to` == 0). Exception: during contract creation, any number of NFTs
186      *  may be created and assigned without emitting Transfer. At the time of
187      *  any transfer, the approved address for that NFT (if any) is reset to none.
188      */
189     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
190 
191     /**
192      * @dev This emits when the approved address for an NFT is changed or
193      *  reaffirmed. The zero address indicates there is no approved address.
194      *  When a Transfer event emits, this also indicates that the approved
195      *  address for that NFT (if any) is reset to none.
196      */
197     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
198 
199     /**
200      * @dev This emits when an operator is enabled or disabled for an owner.
201      *  The operator can manage all NFTs of the owner.
202      */
203     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
204 
205     /**
206      * @notice Count all NFTs assigned to an owner
207      * @dev NFTs assigned to the zero address are considered invalid, and this
208      *  function throws for queries about the zero address.
209      * @param _owner An address for whom to query the balance
210      * @return The number of NFTs owned by `_owner`, possibly zero
211      */
212     function balanceOf(address _owner) public view returns (uint256);
213 
214     /**
215      * @notice Find the owner of an NFT
216      * @dev NFTs assigned to zero address are considered invalid, and queries
217      *  about them do throw.
218      * @param _tokenId The identifier for an NFT
219      * @return The address of the owner of the NFT
220      */
221     function ownerOf(uint256 _tokenId) public view returns (address);
222 
223     /**
224      * @notice Transfers the ownership of an NFT from one address to another address
225      * @dev Throws unless `msg.sender` is the current owner, an authorized
226      *  operator, or the approved address for this NFT. Throws if `_from` is
227      *  not the current owner. Throws if `_to` is the zero address. Throws if
228      *  `_tokenId` is not a valid NFT. When transfer is complete, this function
229      *  checks if `_to` is a smart contract (code size > 0). If so, it calls
230      *  `onERC721Received` on `_to` and throws if the return value is not
231      *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
232      * @param _from The current owner of the NFT
233      * @param _to The new owner
234      * @param _tokenId The NFT to transfer
235      * @param data Additional data with no specified format, sent in call to `_to`
236      */
237     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
238 
239     /**
240      * @notice Transfers the ownership of an NFT from one address to another address
241      * @dev This works identically to the other function with an extra data parameter,
242      *  except this function just sets data to "".
243      * @param _from The current owner of the NFT
244      * @param _to The new owner
245      * @param _tokenId The NFT to transfer
246      */
247     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
248 
249     /**
250      * @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
251      *  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
252      *  THEY MAY BE PERMANENTLY LOST
253      * @dev Throws unless `msg.sender` is the current owner, an authorized
254      *  operator, or the approved address for this NFT. Throws if `_from` is
255      *  not the current owner. Throws if `_to` is the zero address. Throws if
256      *  `_tokenId` is not a valid NFT.
257      * @param _from The current owner of the NFT
258      * @param _to The new owner
259      * @param _tokenId The NFT to transfer
260      */
261     function transferFrom(address _from, address _to, uint256 _tokenId) public;
262 
263     /**
264      * @notice Change or reaffirm the approved address for an NFT
265      * @dev The zero address indicates there is no approved address.
266      *  Throws unless `msg.sender` is the current NFT owner, or an authorized
267      *  operator of the current owner.
268      * @param _approved The new approved NFT controller
269      * @param _tokenId The NFT to approve
270      */
271     function approve(address _approved, uint256 _tokenId) external;
272 
273     /**
274      * @notice Enable or disable approval for a third party ("operator") to manage
275      *  all of `msg.sender`'s assets
276      * @dev Emits the ApprovalForAll event. The contract MUST allow
277      *  multiple operators per owner.
278      * @param _operator Address to add to the set of authorized operators
279      * @param _approved True if the operator is approved, false to revoke approval
280      */
281     function setApprovalForAll(address _operator, bool _approved) external;
282 
283     /**
284      * @notice Get the approved address for a single NFT
285      * @dev Throws if `_tokenId` is not a valid NFT.
286      * @param _tokenId The NFT to find the approved address for
287      * @return The approved address for this NFT, or the zero address if there is none
288      */
289     function getApproved(uint256 _tokenId) public view returns (address);
290 
291     /**
292      * @notice Query if an address is an authorized operator for another address
293      * @param _owner The address that owns the NFTs
294      * @param _operator The address that acts on behalf of the owner
295      * @return True if `_operator` is an approved operator for `_owner`, false otherwise
296      */
297     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
298 
299     // Below is OPTIONAL
300 
301     // ERC721Metadata
302     // The metadata extension is OPTIONAL for ERC-721 smart contracts (see "caveats", below). This allows your smart contract to be interrogated for its name and for details about the assets which your NFTs represent.
303     
304     /**
305      * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
306      * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
307      *  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
308      */
309 
310     /// @notice A descriptive name for a collection of NFTs in this contract
311     function name() external view returns (string _name);
312 
313     /// @notice An abbreviated name for NFTs in this contract
314     function symbol() external view returns (string _symbol);
315 
316     /**
317      * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
318      * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
319      *  3986. The URI may point to a JSON file that conforms to the "ERC721
320      *  Metadata JSON Schema".
321      */
322     function tokenURI(uint256 _tokenId) external view returns (string);
323 
324     // ERC721Enumerable
325     // The enumeration extension is OPTIONAL for ERC-721 smart contracts (see "caveats", below). This allows your contract to publish its full list of NFTs and make them discoverable.
326 
327     /**
328      * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
329      * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
330      *  Note: the ERC-165 identifier for this interface is 0x780e9d63.
331      */
332 
333     /**
334      * @notice Count NFTs tracked by this contract
335      * @return A count of valid NFTs tracked by this contract, where each one of
336      *  them has an assigned and queryable owner not equal to the zero address
337      */
338     function totalSupply() public view returns (uint256);
339 }
340 
341 /**
342  * @title SafeMath
343  * @dev Math operations with safety checks that revert on error
344  */
345 library SafeMath {
346     /**
347     * @dev Multiplies two numbers, reverts on overflow.
348     */
349     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
350         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
351         // benefit is lost if 'b' is also tested.
352         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
353         if (a == 0) {
354             return 0;
355         }
356 
357         uint256 c = a * b;
358         require(c / a == b);
359 
360         return c;
361     }
362 
363     /**
364     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
365     */
366     function div(uint256 a, uint256 b) internal pure returns (uint256) {
367         // Solidity only automatically asserts when dividing by 0
368         require(b > 0);
369         uint256 c = a / b;
370         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
371 
372         return c;
373     }
374 
375     /**
376     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
377     */
378     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
379         require(b <= a);
380         uint256 c = a - b;
381 
382         return c;
383     }
384 
385     /**
386     * @dev Adds two numbers, reverts on overflow.
387     */
388     function add(uint256 a, uint256 b) internal pure returns (uint256) {
389         uint256 c = a + b;
390         require(c >= a);
391 
392         return c;
393     }
394 
395     /**
396     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
397     * reverts when dividing by zero.
398     */
399     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
400         require(b != 0);
401         return a % b;
402     }
403 }
404 
405 /**
406  * Utility library of inline functions on addresses
407  */
408 library Address {
409     /**
410      * Returns whether the target address is a contract
411      * @dev This function will return false if invoked during the constructor of a contract,
412      * as the code is not actually created until after the constructor finishes.
413      * @param account address of the account to check
414      * @return whether the target address is a contract
415      */
416     function isContract(address account) internal view returns (bool) {
417         uint256 size;
418         // XXX Currently there is no better way to check if there is a contract in an address
419         // than to check the size of the code at that address.
420         // See https://ethereum.stackexchange.com/a/14016/36603
421         // for more details about how this works.
422         // TODO Check this again before the Serenity release, because all addresses will be
423         // contracts then.
424         // solium-disable-next-line security/no-inline-assembly
425         assembly { size := extcodesize(account) }
426         return size > 0;
427     }
428 }
429 
430 /**
431  * @title The base contract of Dyverse. ERC-721 compliant.
432  * @author VREX Lab Co., Ltd
433  * @dev See the KydyCore contract for more info on details. 
434  */
435 contract KydyBase is KydyAccessControl, ERC721Basic {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     /*** EVENT ***/
440 
441     /**
442      * @dev The Creation event takes place whenever a new Kydy is created via Synthesis or minted by the COO.  
443      */
444     event Created(address indexed owner, uint256 kydyId, uint256 yinId, uint256 yangId, uint256 genes);
445 
446     /*** DATA TYPES ***/
447 
448     /**
449      * @dev Every Kydy in the Dyverse is a copy of this structure. 
450      */
451     struct Kydy {
452         // The Kydy's genetic code is stored into 256-bits and never changes.
453         uint256 genes;
454 
455         // The timestamp of the block when this Kydy was created
456         uint64 createdTime;
457 
458         // The timestamp of when this Kydy can synthesize again.
459         uint64 rechargeEndBlock;
460 
461         // The ID of the parents (Yin, female, and Yang, male). It is 0 for Generation 0 Kydys.
462         uint32 yinId;
463         uint32 yangId;
464 
465         // The ID of the yang Kydy that the yin Kydy is creating with. 
466         uint32 synthesizingWithId;
467 
468         // The recharge index that represents the duration of the recharge for this Kydy. 
469         // After each synthesis, this increases by one for both yin and yang Kydys of the synthesis. 
470         uint16 rechargeIndex;
471 
472         // The generation index of this Kydy. The newly created Kydy takes the generation index of the parent 
473         // with a larger generation index. 
474         uint16 generation;
475     }
476 
477     /*** CONSTANTS ***/
478 
479     /**
480      * @dev An array table of the recharge duration. Referred to as "creation time" for yin 
481      *  and "synthesis recharge" for yang Kydys. Maximum duration is 4 days. 
482      */
483     uint32[14] public recharges = [
484         uint32(1 minutes),
485         uint32(2 minutes),
486         uint32(5 minutes),
487         uint32(10 minutes),
488         uint32(30 minutes),
489         uint32(1 hours),
490         uint32(2 hours),
491         uint32(4 hours),
492         uint32(8 hours),
493         uint32(16 hours),
494         uint32(1 days),
495         uint32(2 days),
496         uint32(4 days)
497     ];
498 
499     // An approximation of seconds between blocks.
500     uint256 public secondsPerBlock = 15;
501 
502     /*** STORAGE ***/
503 
504     /**
505      * @dev This array contains the ID of every Kydy as an index. 
506      */
507     Kydy[] kydys;
508 
509     /**
510      * @dev This maps each Kydy ID to the address of the owner. Every Kydy must have an owner, even Gen 0 Kydys.
511      *  You can view this mapping via `ownerOf()`.
512      */
513     mapping (uint256 => address) internal kydyIndexToOwner;
514 
515     /**
516      * @dev This maps the owner's address to the number of Kydys that the address owns.
517      *  You can view this mapping via `balanceOf()`.
518      */
519     mapping (address => uint256) internal ownershipTokenCount;
520 
521     /**
522      * @dev This maps transferring Kydy IDs to the the approved address to call safeTransferFrom().
523      *  You can view this mapping via `getApproved()`.
524      */
525     mapping (uint256 => address) internal kydyIndexToApproved;
526 
527     /**
528      * @dev This maps KydyIDs to the address approved to synthesize via synthesizeWithAuto().
529      *  You can view this mapping via `getSynthesizeApproved()`.
530      */
531     mapping (uint256 => address) internal synthesizeAllowedToAddress;
532 
533     /**
534      * @dev This maps the owner to operator approvals, for the usage of setApprovalForAll().
535      */
536     mapping (address => mapping (address => bool)) private _operatorApprovals;
537 
538     /**
539      * @dev Returns the owner of the given Kydy ID. Required for ERC-721 compliance.
540      * @param _tokenId uint256 ID of the Kydy in query
541      * @return the address of the owner of the given Kydy ID
542      */
543     function ownerOf(uint256 _tokenId) public view returns (address) {
544         address owner = kydyIndexToOwner[_tokenId];
545         require(owner != address(0));
546         return owner;
547     }
548 
549     /**
550      * @dev Returns the approved address of the receiving owner for a Kydy ID. Required for ERC-721 compliance.
551      * @param tokenId uint256 ID of the Kydy in query
552      * @return the address of the approved, receiving owner for the given Kydy ID
553      */
554     function getApproved(uint256 tokenId) public view returns (address) {
555         require(_exists(tokenId));
556         return kydyIndexToApproved[tokenId];
557     }
558 
559     /**
560      * @dev Returns the synthesize approved address of the Kydy ID.
561      * @param tokenId uint256 ID of the Kydy in query
562      * @return the address of the synthesizing approved of the given Kydy ID
563      */
564     function getSynthesizeApproved(uint256 tokenId) external view returns (address) {
565         require(_exists(tokenId));
566         return synthesizeAllowedToAddress[tokenId];
567     }
568 
569     /**
570      * @dev Returns whether an operator is approved by the owner. Required for ERC-721 compliance.
571      * @param owner owner address to check whether it is approved
572      * @param operator operator address to check whether it is approved
573      * @return bool whether the operator is approved or not
574      */
575     function isApprovedForAll(address owner, address operator) public view returns (bool) {
576         return _operatorApprovals[owner][operator];
577     }
578 
579     /**
580      * @dev Sets or unsets the approval of the operator. Required for ERC-721 compliance.
581      * @param to operator address to set the approval
582      * @param approved the status to be set
583      */
584     function setApprovalForAll(address to, bool approved) external {
585         require(to != msg.sender);
586         _operatorApprovals[msg.sender][to] = approved;
587         emit ApprovalForAll(msg.sender, to, approved);
588     }
589 
590     /// @dev Assigns ownership of this Kydy to an address.
591     function _transfer(address _from, address _to, uint256 _tokenId) internal {
592         ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
593         // Transfers the ownership of this Kydy.
594         kydyIndexToOwner[_tokenId] = _to;
595 
596         ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
597         // After a transfer, synthesis allowance is also reset.
598         delete synthesizeAllowedToAddress[_tokenId];
599         // Clears any previously approved transfer.
600         delete kydyIndexToApproved[_tokenId];
601 
602         // Emit the transfer event.
603         emit Transfer(_from, _to, _tokenId);
604     }
605 
606     /**
607      * @dev Returns whether the given Kydy ID exists
608      * @param _tokenId uint256 ID of the Kydy in query
609      * @return whether the Kydy exists
610      */
611     function _exists(uint256 _tokenId) internal view returns (bool) {
612         address owner = kydyIndexToOwner[_tokenId];
613         return owner != address(0);
614     }
615 
616     /**
617      * @dev Returns whether the given spender can transfer the Kydy ID
618      * @param _spender address of the spender to query
619      * @param _tokenId uint256 ID of the Kydy to be transferred
620      * @return bool whether the msg.sender is approved
621      */
622     function _isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
623         address owner = ownerOf(_tokenId);
624         // Disable solium check because of
625         // https://github.com/duaraghav8/Solium/issues/175
626         // solium-disable-next-line operator-whitespace
627         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
628     }
629 
630     /**
631      * @dev Internal function to add a Kydy ID to the new owner's list.
632      * @param _to address the new owner's address
633      * @param _tokenId uint256 ID of the transferred Kydy 
634      */
635     function _addTokenTo(address _to, uint256 _tokenId) internal {
636         // Checks if the owner of the Kydy is 0x0 before the transfer.
637         require(kydyIndexToOwner[_tokenId] == address(0));
638         // Transfers the ownership to the new owner.
639         kydyIndexToOwner[_tokenId] = _to;
640         // Increases the total Kydy count of the new owner.
641         ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
642     }
643 
644     /**
645      * @dev Internal function to remove a Kydy ID from the previous owner's list.
646      * @param _from address the previous owner's address
647      * @param _tokenId uint256 ID of the transferred Kydy 
648      */
649     function _removeTokenFrom(address _from, uint256 _tokenId) internal {
650         // Checks the current owner of the Kydy is '_from'.
651         require(ownerOf(_tokenId) == _from);
652         // Reduces the total Kydy count of the previous owner.
653         ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
654         // Deletes the transferred Kydy from the current owner's list.
655         kydyIndexToOwner[_tokenId] = address(0);
656     }
657 
658     /**
659      * @dev Internal function to mint a new Kydy.
660      * @param _to The address that owns the newly minted Kydy
661      * @param _tokenId uint256 ID of the newly minted Kydy
662      */
663     function _mint(address _to, uint256 _tokenId) internal {
664         require(!_exists(_tokenId));
665         _addTokenTo(_to, _tokenId);
666         emit Transfer(address(0), _to, _tokenId);
667     }
668 
669     /**
670      * @dev Internal function to clear current approvals of a given Kydy ID.
671      * @param _owner owner of the Kydy
672      * @param _tokenId uint256 ID of the Kydy to be transferred
673      */
674     function _clearApproval(address _owner, uint256 _tokenId) internal {
675         require(ownerOf(_tokenId) == _owner);
676         if (kydyIndexToApproved[_tokenId] != address(0)) {
677             kydyIndexToApproved[_tokenId] = address(0);
678         }
679         if (synthesizeAllowedToAddress[_tokenId] != address(0)) {
680             synthesizeAllowedToAddress[_tokenId] = address(0);
681         }
682     }
683 
684     /**
685      * @dev Internal function that creates a new Kydy and stores it. 
686      * @param _yinId The ID of the yin Kydy (zero for Generation 0 Kydy)
687      * @param _yangId The ID of the yang Kydy (zero for Generation 0 Kydy)
688      * @param _generation The generation number of the new Kydy.
689      * @param _genes The Kydy's gene code
690      * @param _owner The owner of this Kydy, must be non-zero (except for the ID 0)
691      */
692     function _createKydy(
693         uint256 _yinId,
694         uint256 _yangId,
695         uint256 _generation,
696         uint256 _genes,
697         address _owner
698     )
699         internal
700         returns (uint)
701     {
702         require(_yinId == uint256(uint32(_yinId)));
703         require(_yangId == uint256(uint32(_yangId)));
704         require(_generation == uint256(uint16(_generation)));
705 
706         // New Kydy's recharge index is its generation / 2.
707         uint16 rechargeIndex = uint16(_generation / 2);
708         if (rechargeIndex > 13) {
709             rechargeIndex = 13;
710         }
711 
712         Kydy memory _kyd = Kydy({
713             genes: _genes,
714             createdTime: uint64(now),
715             rechargeEndBlock: 0,
716             yinId: uint32(_yinId),
717             yangId: uint32(_yangId),
718             synthesizingWithId: 0,
719             rechargeIndex: rechargeIndex,
720             generation: uint16(_generation)
721         });
722         uint256 newbabyKydyId = kydys.push(_kyd) - 1;
723 
724         // Just in case.
725         require(newbabyKydyId == uint256(uint32(newbabyKydyId)));
726 
727         // Emits the Created event.
728         emit Created(
729             _owner,
730             newbabyKydyId,
731             uint256(_kyd.yinId),
732             uint256(_kyd.yangId),
733             _kyd.genes
734         );
735 
736         // Here grants ownership, and also emits the Transfer event.
737         _mint(_owner, newbabyKydyId);
738 
739         return newbabyKydyId;
740     }
741 
742     // Any C-level roles can change the seconds per block
743     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
744         require(secs < recharges[0]);
745         secondsPerBlock = secs;
746     }
747 }
748 
749 /**
750  * @notice This is MUST to be implemented.
751  *  A wallet/broker/auction application MUST implement the wallet interface if it will accept safe transfers.
752  * @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
753  */
754 contract ERC721TokenReceiver {
755     /**
756      * @notice Handle the receipt of an NFT
757      * @dev The ERC721 smart contract calls this function on the recipient
758      *  after a `transfer`. This function MAY throw to revert and reject the
759      *  transfer. Return of other than the magic value MUST result in the
760      *  transaction being reverted.
761      *  Note: the contract address is always the message sender.
762      * @param _operator The address which called `safeTransferFrom` function
763      * @param _from The address which previously owned the token
764      * @param _tokenId The NFT identifier which is being transferred
765      * @param _data Additional data with no specified format
766      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
767      *  unless throwing
768      */
769     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns (bytes4);
770 }
771 
772 // File: contracts/lib/Strings.sol
773 
774 library Strings {
775     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
776     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
777         bytes memory _ba = bytes(_a);
778         bytes memory _bb = bytes(_b);
779         bytes memory _bc = bytes(_c);
780         bytes memory _bd = bytes(_d);
781         bytes memory _be = bytes(_e);
782         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
783         bytes memory babcde = bytes(abcde);
784         uint k = 0;
785         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
786         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
787         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
788         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
789         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
790         return string(babcde);
791     }
792 
793     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
794         return strConcat(_a, _b, _c, _d, "");
795     }
796 
797     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
798         return strConcat(_a, _b, _c, "", "");
799     }
800 
801     function strConcat(string _a, string _b) internal pure returns (string) {
802         return strConcat(_a, _b, "", "", "");
803     }
804 
805     function uint2str(uint i) internal pure returns (string) {
806         if (i == 0) return "0";
807         uint j = i;
808         uint len;
809         while (j != 0){
810             len++;
811             j /= 10;
812         }
813         bytes memory bstr = new bytes(len);
814         uint k = len - 1;
815         while (i != 0){
816             bstr[k--] = byte(48 + i % 10);
817             i /= 10;
818         }
819         return string(bstr);
820     }
821 }
822 
823 /**
824  * @title Part of the KydyCore contract that manages ownership, ERC-721 compliant.
825  * @author VREX Lab Co., Ltd
826  * @dev Ref: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
827  *  See the KydyCore contract documentation to understand how the various contracts are arranged.
828  */
829 contract KydyOwnership is KydyBase {
830     using Strings for string;
831 
832     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
833     string public constant _name = "Dyverse";
834     string public constant _symbol = "KYDY";
835 
836     // Base Server Address for Token MetaData URI
837     string internal tokenURIBase = "http://testapi.dyver.se/api/KydyMetadata/";
838 
839     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
840     // which can be also obtained as `ERC721TokenReceiver(0).onERC721Received.selector`
841     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
842 
843     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
844     /**
845      * 0x01ffc9a7 ===
846      *     bytes4(keccak256('supportsInterface(bytes4)'))
847      */
848 
849     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
850     /*
851      * 0x80ac58cd ===
852      *     bytes4(keccak256('balanceOf(address)')) ^
853      *     bytes4(keccak256('ownerOf(uint256)')) ^
854      *     bytes4(keccak256('approve(address,uint256)')) ^
855      *     bytes4(keccak256('getApproved(uint256)')) ^
856      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
857      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
858      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
859      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
860      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
861      */
862 
863     bytes4 private constant _InterfaceId_ERC721Metadata = 0x5b5e139f;
864     /**
865      * 0x5b5e139f ===
866      *     bytes4(keccak256('name()')) ^
867      *     bytes4(keccak256('symbol()')) ^
868      *     bytes4(keccak256('tokenURI(uint256)'))
869      */
870 
871     constructor() public {
872         _registerInterface(_InterfaceId_ERC165);
873         // register the supported interfaces to conform to ERC721 via ERC165
874         _registerInterface(_InterfaceId_ERC721);
875         // register the supported interfaces to conform to ERC721 via ERC165
876         _registerInterface(_InterfaceId_ERC721Metadata);
877     }
878 
879     /**
880      * @dev Checks if a given address is the current owner of this Kydy.
881      * @param _claimant the address which we want to query the ownership of the Kydy ID.
882      * @param _tokenId Kydy id, only valid when > 0
883      */
884     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
885         return kydyIndexToOwner[_tokenId] == _claimant;
886     }
887 
888     /**
889      * @dev Grants an approval to the given address for safeTransferFrom(), overwriting any
890      *  previous approval. Setting _approved to address(0) clears all transfer approval.
891      *  Note that _approve() does NOT emit the Approval event. This is intentional because
892      *  _approve() and safeTransferFrom() are used together when putting Kydys to the auction,
893      *  and there is no need to spam the log with Approval events in that case.
894      */
895     function _approve(uint256 _tokenId, address _approved) internal {
896         kydyIndexToApproved[_tokenId] = _approved;
897     }
898 
899     /**
900      * @dev Transfers a Kydy owned by this contract to the specified address.
901      *  Used to rescue lost Kydys. (There is no "proper" flow where this contract
902      *  should be the owner of any Kydy. This function exists for us to reassign
903      *  the ownership of Kydys that users may have accidentally sent to our address.)
904      * @param _kydyId ID of the lost Kydy
905      * @param _recipient address to send the Kydy to
906      */
907     function rescueLostKydy(uint256 _kydyId, address _recipient) external onlyCOO whenNotPaused {
908         require(_owns(this, _kydyId));
909         _transfer(this, _recipient, _kydyId);
910     }
911 
912     /**
913      * @dev Gets the number of Kydys owned by the given address.
914      *  Required for ERC-721 compliance.
915      * @param _owner address to query the balance of
916      * @return uint256 representing the amount owned by the passed address
917      */
918     function balanceOf(address _owner) public view returns (uint256) {
919         require(_owner != address(0));
920         return ownershipTokenCount[_owner];
921     }
922 
923     /**
924      * @dev Approves another address to transfer the given Kydy ID.
925      *  The zero address indicates that there is no approved address.
926      *  There can only be one approved address per Kydy at a given time.
927      *  Can only be called by the Kydy owner or an approved operator.
928      *  Required for ERC-721 compliance.
929      * @param to address to be approved for the given Kydy ID
930      * @param tokenId uint256 ID of the Kydy to be approved
931      */
932     function approve(address to, uint256 tokenId) external whenNotPaused {
933         address owner = ownerOf(tokenId);
934         require(to != owner);
935         // Owner or approved operator by owner can approve the another address
936         // to transfer the Kydy.
937         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
938 
939         // Approves the given address.
940         _approve(tokenId, to);
941 
942         // Emits the Approval event.
943         emit Approval(owner, to, tokenId);
944     }
945 
946     /**
947      * @dev Transfers the ownership of the Kydy to another address.
948      *  Usage of this function is discouraged, use `safeTransferFrom` whenever possible.
949      *  Requires the msg sender to be the owner, approved, or operator.
950      *  Required for ERC-721 compliance.
951      * @param from current owner of the Kydy
952      * @param to address to receive the ownership of the given Kydy ID
953      * @param tokenId uint256 ID of the Kydy to be transferred
954      */
955     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
956         // Checks the caller is the owner or approved one or an operator.
957         require(_isApprovedOrOwner(msg.sender, tokenId));
958         // Safety check to prevent from transferring Kydy to 0x0 address.
959         require(to != address(0));
960 
961         // Clears approval from current owner.
962         _clearApproval(from, tokenId);
963         // Resets the ownership of this Kydy from current owner and sets it to 0x0.
964         _removeTokenFrom(from, tokenId);
965         // Grants the ownership of this Kydy to new owner.
966         _addTokenTo(to, tokenId);
967 
968         // Emits the Transfer event.
969         emit Transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev Safely transfers the ownership of a given Kydy to another address.
974      *  If the target address is a contract, it must implement `onERC721Received`,
975      *  which is called upon a safe transfer, and return the magic value
976      *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
977      *  Otherwise, the transfer is reverted.
978      *  Requires the msg sender to be the owner, approved, or operator.
979      *  Required for ERC-721 compliance.
980      * @param from current owner of the Kydy
981      * @param to address to receive the ownership of the given Kydy ID
982      * @param tokenId uint256 ID of the Kydy to be transferred
983      */
984     function safeTransferFrom(address from, address to, uint256 tokenId) public {
985         // solium-disable-next-line arg-overflow
986         safeTransferFrom(from, to, tokenId, "");
987     }
988 
989     /**
990      * @dev Safely transfers the ownership of a given Kydy to another address.
991      *  If the target address is a contract, it must implement `onERC721Received`,
992      *  which is called upon a safe transfer, and return the magic value
993      *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
994      *  Otherwise, the transfer is reverted.
995      *  Requires the msg sender to be the owner, approved, or operator.
996      *  Required for ERC-721 compliance.
997      * @param from current owner of the Kydy
998      * @param to address to receive the ownership of the given Kydy ID
999      * @param tokenId uint256 ID of the Kydy to be transferred
1000      * @param _data bytes data to send along with a safe transfer check
1001      */
1002     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
1003         transferFrom(from, to, tokenId);
1004         // solium-disable-next-line arg-overflow
1005         require(_checkOnERC721Received(from, to, tokenId, _data));
1006     }
1007 
1008     /**
1009      * @dev Internal function to invoke `onERC721Received` on a target address.
1010      *  This function is not executed if the target address is not a contract.
1011      * @param _from address representing the previous owner of the given Kydy ID
1012      * @param _to target address that will receive the Kydys
1013      * @param _tokenId uint256 ID of the Kydy to be transferred
1014      * @param _data bytes optional data to send along with the call
1015      * @return whether the call correctly returned the expected magic value
1016      */
1017     function _checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
1018         if (!_to.isContract()) {
1019             return true;
1020         }
1021 
1022         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1023         return (retval == _ERC721_RECEIVED);
1024     }
1025     
1026     /**
1027      * @dev Gets the token name.
1028      *  Required for ERC721Metadata compliance.
1029      * @return string representing the token name
1030      */
1031     function name() external view returns (string) {
1032         return _name;
1033     }
1034 
1035     /**
1036      * @dev Gets the token symbol.
1037      *  Required for ERC721Metadata compliance.
1038      * @return string representing the token symbol
1039      */
1040     function symbol() external view returns (string) {
1041         return _symbol;
1042     }
1043 
1044     /**
1045      * @dev Returns an URI for a given Kydy ID.
1046      *  Throws if the token ID does not exist. May return an empty string.
1047      *  Required for ERC721Metadata compliance.
1048      * @param tokenId uint256 ID of the token to query
1049      */
1050     function tokenURI(uint256 tokenId) external view returns (string) {
1051         require(_exists(tokenId));
1052         return Strings.strConcat(
1053             tokenURIBase,
1054             Strings.uint2str(tokenId)
1055         );
1056     }
1057 
1058     /**
1059      * @dev Gets the total amount of Kydys stored in the contract
1060      * @return uint256 representing the total amount of Kydys
1061      */
1062     function totalSupply() public view returns (uint256) {
1063         return kydys.length - 1;
1064     }
1065 
1066     /**
1067      * @notice Returns a list of all Kydy IDs assigned to an address.
1068      * @param _owner The owner whose Kydys we are interested in.
1069      * @dev This function MUST NEVER be called by smart contract code. It's pretty
1070      *  expensive (it looks into the entire Kydy array looking for Kydys belonging to owner),
1071      *  and it also returns a dynamic array, which is only supported for web3 calls, and
1072      *  not contract-to-contract calls.
1073      */
1074     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
1075         uint256 tokenCount = balanceOf(_owner);
1076 
1077         if (tokenCount == 0) {
1078             // Return an empty array
1079             return new uint256[](0);
1080         } else {
1081             uint256[] memory result = new uint256[](tokenCount);
1082             uint256 totalKydys = totalSupply();
1083             uint256 resultIndex = 0;
1084 
1085             // All Kydys have IDs starting at 1 and increasing sequentially up to the totalKydy count.
1086             uint256 kydyId;
1087 
1088             for (kydyId = 1; kydyId <= totalKydys; kydyId++) {
1089                 if (kydyIndexToOwner[kydyId] == _owner) {
1090                     result[resultIndex] = kydyId;
1091                     resultIndex++;
1092                 }
1093             }
1094 
1095             return result;
1096         }
1097     }
1098 }
1099 
1100 /**
1101  * @title This manages synthesis and creation of Kydys.
1102  * @author VREX Lab Co., Ltd
1103  * @dev Please reference the KydyCore contract for details. 
1104  */
1105 contract KydySynthesis is KydyOwnership {
1106 
1107     /**
1108      * @dev The Creating event is emitted when two Kydys synthesize and the creation
1109      *  timer begins by the yin.
1110      */
1111     event Creating(address owner, uint256 yinId, uint256 yangId, uint256 rechargeEndBlock);
1112 
1113     /**
1114      * @notice The minimum payment required for synthesizeWithAuto(). This fee is for
1115      *  the gas cost paid by whoever calls bringKydyHome(), and can be updated by the COO address.
1116      */
1117     uint256 public autoCreationFee = 14 finney;
1118 
1119     // Number of the Kydys that are creating a new Kydy.
1120     uint256 public creatingKydys;
1121 
1122     /**
1123      * @dev The address of the sibling contract that mixes and combines genes of the two parent Kydys. 
1124      */
1125     GeneSynthesisInterface public geneSynthesis;
1126 
1127     /**
1128      * @dev Updates the address of the genetic contract. Only CEO may call this function.
1129      * @param _address An address of the new GeneSynthesis contract instance.
1130      */
1131     function setGeneSynthesisAddress(address _address) external onlyCEO {
1132         GeneSynthesisInterface candidateContract = GeneSynthesisInterface(_address);
1133 
1134         // Verifies that the contract is valid.
1135         require(candidateContract.isGeneSynthesis());
1136 
1137         // Sets the new GeneSynthesis contract address.
1138         geneSynthesis = candidateContract;
1139     }
1140 
1141     /**
1142      * @dev Checks that the Kydy is able to synthesize. 
1143      */
1144     function _isReadyToSynthesize(Kydy _kyd) internal view returns (bool) {
1145         // Double-checking if there is any pending creation event. 
1146         return (_kyd.synthesizingWithId == 0) && (_kyd.rechargeEndBlock <= uint64(block.number));
1147     }
1148 
1149     /**
1150      * @dev Checks if a yang Kydy has been approved to synthesize with this yin Kydy.
1151      */
1152     function _isSynthesizingAllowed(uint256 _yangId, uint256 _yinId) internal view returns (bool) {
1153         address yinOwner = kydyIndexToOwner[_yinId];
1154         address yangOwner = kydyIndexToOwner[_yangId];
1155 
1156         return (yinOwner == yangOwner || synthesizeAllowedToAddress[_yangId] == yinOwner);
1157     }
1158 
1159     /**
1160      * @dev Sets the rechargeEndTime for the given Kydy, based on its current rechargeIndex.
1161      *  The rechargeIndex increases until it hits the cap.
1162      * @param _kyd A reference to the Kydy that needs its timer to be started.
1163      */
1164     function _triggerRecharge(Kydy storage _kyd) internal {
1165         // Computes the approximation of the end of recharge time in blocks (based on current rechargeIndex).
1166         _kyd.rechargeEndBlock = uint64((recharges[_kyd.rechargeIndex] / secondsPerBlock) + block.number);
1167 
1168         // Increases this Kydy's synthesizing count, and the cap is fixed at 12.
1169         if (_kyd.rechargeIndex < 12) {
1170             _kyd.rechargeIndex += 1;
1171         }
1172     }
1173 
1174     /**
1175      * @notice Grants approval to another user to synthesize with one of your Kydys.
1176      * @param _address The approved address of the yin Kydy that can synthesize with your yang Kydy. 
1177      * @param _yangId Your kydy that _address can now synthesize with.
1178      */
1179     function approveSynthesizing(address _address, uint256 _yangId)
1180         external
1181         whenNotPaused
1182     {
1183         require(_owns(msg.sender, _yangId));
1184         synthesizeAllowedToAddress[_yangId] = _address;
1185     }
1186 
1187     /**
1188      * @dev Updates the minimum payment required for calling bringKydyHome(). Only COO
1189      *  can call this function. 
1190      */
1191     function setAutoCreationFee(uint256 value) external onlyCOO {
1192         autoCreationFee = value;
1193     }
1194 
1195     /// @dev Checks if this Kydy is creating and if the creation period is complete. 
1196     function _isReadyToBringKydyHome(Kydy _yin) private view returns (bool) {
1197         return (_yin.synthesizingWithId != 0) && (_yin.rechargeEndBlock <= uint64(block.number));
1198     }
1199 
1200     /**
1201      * @notice Checks if this Kydy is able to synthesize 
1202      * @param _kydyId reference the ID of the Kydy
1203      */
1204     function isReadyToSynthesize(uint256 _kydyId)
1205         public
1206         view
1207         returns (bool)
1208     {
1209         require(_kydyId > 0);
1210         Kydy storage kyd = kydys[_kydyId];
1211         return _isReadyToSynthesize(kyd);
1212     }
1213 
1214     /**
1215      * @dev Checks if the Kydy is currently creating.
1216      * @param _kydyId reference the ID of the Kydy
1217      */
1218     function isCreating(uint256 _kydyId)
1219         public
1220         view
1221         returns (bool)
1222     {
1223         require(_kydyId > 0);
1224 
1225         return kydys[_kydyId].synthesizingWithId != 0;
1226     }
1227 
1228     /**
1229      * @dev Internal check to see if these yang and yin are a valid couple. 
1230      * @param _yin A reference to the Kydy struct of the potential yin.
1231      * @param _yinId The yin's ID.
1232      * @param _yang A reference to the Kydy struct of the potential yang.
1233      * @param _yangId The yang's ID
1234      */
1235     function _isValidCouple(
1236         Kydy storage _yin,
1237         uint256 _yinId,
1238         Kydy storage _yang,
1239         uint256 _yangId
1240     )
1241         private
1242         view
1243         returns(bool)
1244     {
1245         // Kydy can't synthesize with itself.
1246         if (_yinId == _yangId) {
1247             return false;
1248         }
1249 
1250         // Kydys can't synthesize with their parents.
1251         if (_yin.yinId == _yangId || _yin.yangId == _yangId) {
1252             return false;
1253         }
1254         if (_yang.yinId == _yinId || _yang.yangId == _yinId) {
1255             return false;
1256         }
1257 
1258         // Skip sibling check for Gen 0
1259         if (_yang.yinId == 0 || _yin.yinId == 0) {
1260             return true;
1261         }
1262 
1263         // Kydys can't synthesize with full or half siblings.
1264         if (_yang.yinId == _yin.yinId || _yang.yinId == _yin.yangId) {
1265             return false;
1266         }
1267         if (_yang.yangId == _yin.yinId || _yang.yangId == _yin.yangId) {
1268             return false;
1269         }
1270         return true;
1271     }
1272 
1273     /**
1274      * @dev Internal check to see if these yang and yin Kydys, connected via market, are a valid couple for synthesis. 
1275      */
1276     function _canSynthesizeWithViaAuction(uint256 _yinId, uint256 _yangId)
1277         internal
1278         view
1279         returns (bool)
1280     {
1281         Kydy storage yin = kydys[_yinId];
1282         Kydy storage yang = kydys[_yangId];
1283         return _isValidCouple(yin, _yinId, yang, _yangId);
1284     }
1285 
1286     /**
1287      * @dev Checks if the two Kydys can synthesize together, including checks for ownership and synthesizing approvals. 
1288      * @param _yinId ID of the yin Kydy
1289      * @param _yangId ID of the yang Kydy
1290      */
1291     function canSynthesizeWith(uint256 _yinId, uint256 _yangId)
1292         external
1293         view
1294         returns(bool)
1295     {
1296         require(_yinId > 0);
1297         require(_yangId > 0);
1298         Kydy storage yin = kydys[_yinId];
1299         Kydy storage yang = kydys[_yangId];
1300         return _isValidCouple(yin, _yinId, yang, _yangId) &&
1301             _isSynthesizingAllowed(_yangId, _yinId);
1302     }
1303 
1304     /**
1305      * @dev Internal function to start synthesizing, when all the conditions are met
1306      */
1307     function _synthesizeWith(uint256 _yinId, uint256 _yangId) internal {
1308         Kydy storage yang = kydys[_yangId];
1309         Kydy storage yin = kydys[_yinId];
1310 
1311         // Marks this yin as creating, and make note of who the yang Kydy is.
1312         yin.synthesizingWithId = uint32(_yangId);
1313 
1314         // Triggers the recharge for both parents.
1315         _triggerRecharge(yang);
1316         _triggerRecharge(yin);
1317 
1318         // Clears synthesizing permission for both parents, just in case.
1319         delete synthesizeAllowedToAddress[_yinId];
1320         delete synthesizeAllowedToAddress[_yangId];
1321 
1322         // When a Kydy starts creating, this number is increased. 
1323         creatingKydys++;
1324 
1325         // Emits the Creating event.
1326         emit Creating(kydyIndexToOwner[_yinId], _yinId, _yangId, yin.rechargeEndBlock);
1327     }
1328 
1329     /**
1330      * @dev Synthesis between two approved Kydys. Requires a pre-payment of the fee to the first caller of bringKydyHome().
1331      * @param _yinId ID of the Kydy which will be a yin (will start creation if successful)
1332      * @param _yangId ID of the Kydy which will be a yang (will begin its synthesizing cooldown if successful)
1333      */
1334     function synthesizeWithAuto(uint256 _yinId, uint256 _yangId)
1335         external
1336         payable
1337         whenNotPaused
1338     {
1339         // Checks for pre-payment.
1340         require(msg.value >= autoCreationFee);
1341 
1342         // Caller must be the yin's owner.
1343         require(_owns(msg.sender, _yinId));
1344 
1345         // Checks if the caller has valid authority for this synthesis
1346         require(_isSynthesizingAllowed(_yangId, _yinId));
1347 
1348         // Gets a reference of the potential yin.
1349         Kydy storage yin = kydys[_yinId];
1350 
1351         // Checks that the potential yin is ready to synthesize
1352         require(_isReadyToSynthesize(yin));
1353 
1354         // Gets a reference of the potential yang.
1355         Kydy storage yang = kydys[_yangId];
1356 
1357         // Checks that the potential yang is ready to synthesize
1358         require(_isReadyToSynthesize(yang));
1359 
1360         // Checks that these Kydys are a valid couple.
1361         require(_isValidCouple(
1362             yin,
1363             _yinId,
1364             yang,
1365             _yangId
1366         ));
1367 
1368         // All checks passed! Yin Kydy starts creating.
1369         _synthesizeWith(_yinId, _yangId);
1370 
1371     }
1372 
1373     /**
1374      * @notice Let's bring the new Kydy to it's home!
1375      * @param _yinId A Kydy which is ready to bring the newly created Kydy to home.
1376      * @return The Kydy ID of the newly created Kydy.
1377      * @dev The newly created Kydy is transferred to the owner of the yin Kydy. Anyone is welcome to call this function.
1378      */
1379     function bringKydyHome(uint256 _yinId)
1380         external
1381         whenNotPaused
1382         returns(uint256)
1383     {
1384         // Gets a reference of the yin from storage.
1385         Kydy storage yin = kydys[_yinId];
1386 
1387         // Checks that the yin is a valid Kydy.
1388         require(yin.createdTime != 0);
1389 
1390         // Checks that the yin is in creation mode, and the creating period is over.
1391         require(_isReadyToBringKydyHome(yin));
1392 
1393         // Gets a reference of the yang from storage.
1394         uint256 yangId = yin.synthesizingWithId;
1395         Kydy storage yang = kydys[yangId];
1396 
1397         // Ascertains which has the higher generation number between the two parents.
1398         uint16 parentGen = yin.generation;
1399         if (yang.generation > yin.generation) {
1400             parentGen = yang.generation;
1401         }
1402 
1403         // The baby Kydy receives its genes 
1404         uint256 childGenes = geneSynthesis.synthGenes(yin.genes, yang.genes);
1405 
1406         // The baby Kydy is now on blockchain
1407         address owner = kydyIndexToOwner[_yinId];
1408         uint256 kydyId = _createKydy(_yinId, yin.synthesizingWithId, parentGen + 1, childGenes, owner);
1409 
1410         // Clears the synthesis status of the parents
1411         delete yin.synthesizingWithId;
1412 
1413         // When a baby Kydy is created, this number is decreased back. 
1414         creatingKydys--;
1415 
1416         // Sends the fee to the person who called this. 
1417         msg.sender.transfer(autoCreationFee);
1418 
1419         // Returns the new Kydy's ID.
1420         return kydyId;
1421     }
1422 }
1423 
1424 contract ERC721Holder is ERC721TokenReceiver {
1425     function onERC721Received(address, address, uint256, bytes) public returns (bytes4) {
1426         return this.onERC721Received.selector;
1427     }
1428 }
1429 
1430 /**
1431  * @title Base auction contract of the Dyverse
1432  * @author VREX Lab Co., Ltd
1433  * @dev Contains necessary functions and variables for the auction.
1434  *  Inherits `ERC721Holder` contract which is the implementation of the `ERC721TokenReceiver`.
1435  *  This is to accept safe transfers.
1436  */
1437 contract AuctionBase is ERC721Holder {
1438     using SafeMath for uint256;
1439 
1440     // Represents an auction on an NFT
1441     struct Auction {
1442         // Current owner of NFT
1443         address seller;
1444         // Price (in wei) of NFT
1445         uint128 price;
1446         // Time when the auction started
1447         // NOTE: 0 if this auction has been concluded
1448         uint64 startedAt;
1449     }
1450 
1451     // Reference to contract tracking NFT ownership
1452     ERC721Basic public nonFungibleContract;
1453 
1454     // The amount owner takes from the sale, (in basis points, which are 1/100 of a percent).
1455     uint256 public ownerCut;
1456 
1457     // Maps token ID to it's corresponding auction.
1458     mapping (uint256 => Auction) tokenIdToAuction;
1459 
1460     event AuctionCreated(uint256 tokenId, uint256 price);
1461     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address bidder);
1462     event AuctionCanceled(uint256 tokenId);
1463 
1464     /// @dev Disables sending funds to this contract.
1465     function() external {}
1466 
1467     /// @dev A modifier to check if the given value can fit in 64-bits.
1468     modifier canBeStoredWith64Bits(uint256 _value) {
1469         require(_value <= (2**64 - 1));
1470         _;
1471     }
1472 
1473     /// @dev A modifier to check if the given value can fit in 128-bits.
1474     modifier canBeStoredWith128Bits(uint256 _value) {
1475         require(_value <= (2**128 - 1));
1476         _;
1477     }
1478 
1479     /**
1480      * @dev Returns true if the claimant owns the token.
1481      * @param _claimant An address which to query the ownership of the token.
1482      * @param _tokenId ID of the token to query the owner of.
1483      */
1484     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1485         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1486     }
1487 
1488     /**
1489      * @dev Escrows the NFT. Grants the ownership of the NFT to this contract safely.
1490      *  Throws if the escrow fails.
1491      * @param _owner Current owner of the token.
1492      * @param _tokenId ID of the token to escrow.
1493      */
1494     function _escrow(address _owner, uint256 _tokenId) internal {
1495         nonFungibleContract.safeTransferFrom(_owner, this, _tokenId);
1496     }
1497 
1498     /**
1499      * @dev Transfers an NFT owned by this contract to another address safely.
1500      * @param _receiver The receiving address of NFT.
1501      * @param _tokenId ID of the token to transfer.
1502      */
1503     function _transfer(address _receiver, uint256 _tokenId) internal {
1504         nonFungibleContract.safeTransferFrom(this, _receiver, _tokenId);
1505     }
1506 
1507     /**
1508      * @dev Adds an auction to the list of open auctions. 
1509      * @param _tokenId ID of the token to be put on auction.
1510      * @param _auction Auction information of this token to open.
1511      */
1512     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1513         tokenIdToAuction[_tokenId] = _auction;
1514 
1515         emit AuctionCreated(
1516             uint256(_tokenId),
1517             uint256(_auction.price)
1518         );
1519     }
1520 
1521     /// @dev Cancels the auction which the _seller wants.
1522     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1523         _removeAuction(_tokenId);
1524         _transfer(_seller, _tokenId);
1525         emit AuctionCanceled(_tokenId);
1526     }
1527 
1528     /**
1529      * @dev Computes the price and sends it to the seller.
1530      *  Note that this does NOT transfer the ownership of the token.
1531      */
1532     function _bid(uint256 _tokenId, uint256 _bidAmount)
1533         internal
1534         returns (uint256)
1535     {
1536         // Gets a reference of the token from auction storage.
1537         Auction storage auction = tokenIdToAuction[_tokenId];
1538 
1539         // Checks that this auction is currently open
1540         require(_isOnAuction(auction));
1541 
1542         // Checks that the bid is greater than or equal to the current token price.
1543         uint256 price = _currentPrice(auction);
1544         require(_bidAmount >= price);
1545 
1546         // Gets a reference of the seller before the auction gets deleted.
1547         address seller = auction.seller;
1548 
1549         // Removes the auction before sending the proceeds to the sender
1550         _removeAuction(_tokenId);
1551 
1552         // Transfers proceeds to the seller.
1553         if (price > 0) {
1554             uint256 auctioneerCut = _computeCut(price);
1555             uint256 sellerProceeds = price.sub(auctioneerCut);
1556 
1557             seller.transfer(sellerProceeds);
1558         }
1559 
1560         // Computes the excess funds included with the bid and transfers it back to bidder. 
1561         uint256 bidExcess = _bidAmount - price;
1562 
1563         // Returns the exceeded funds.
1564         msg.sender.transfer(bidExcess);
1565 
1566         // Emits the AuctionSuccessful event.
1567         emit AuctionSuccessful(_tokenId, price, msg.sender);
1568 
1569         return price;
1570     }
1571 
1572     /**
1573      * @dev Removes an auction from the list of open auctions.
1574      * @param _tokenId ID of the NFT on auction to be removed.
1575      */
1576     function _removeAuction(uint256 _tokenId) internal {
1577         delete tokenIdToAuction[_tokenId];
1578     }
1579 
1580     /**
1581      * @dev Returns true if the NFT is on auction.
1582      * @param _auction An auction to check if it exists.
1583      */
1584     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1585         return (_auction.startedAt > 0);
1586     }
1587 
1588     /// @dev Returns the current price of an NFT on auction.
1589     function _currentPrice(Auction storage _auction)
1590         internal
1591         view
1592         returns (uint256)
1593     {
1594         return _auction.price;
1595     }
1596 
1597     /**
1598      * @dev Computes the owner's receiving amount from the sale.
1599      * @param _price Sale price of the NFT.
1600      */
1601     function _computeCut(uint256 _price) internal view returns (uint256) {
1602         return _price * ownerCut / 10000;
1603     }
1604 }
1605 
1606 contract Ownable {
1607   address public owner;
1608 
1609 
1610   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1611 
1612 
1613   constructor() public {
1614     owner = msg.sender;
1615   }
1616 
1617   modifier onlyOwner() {
1618     require(msg.sender == owner);
1619     _;
1620   }
1621 
1622   function transferOwnership(address newOwner) public onlyOwner {
1623     require(newOwner != address(0));
1624     emit OwnershipTransferred(owner, newOwner);
1625     owner = newOwner;
1626   }
1627 }
1628 
1629 contract Pausable is Ownable {
1630   event Pause();
1631   event Unpause();
1632 
1633   bool public paused = false;
1634 
1635   modifier whenNotPaused() {
1636     require(!paused);
1637     _;
1638   }
1639 
1640   modifier whenPaused() {
1641     require(paused);
1642     _;
1643   }
1644 
1645   function pause() onlyOwner whenNotPaused public {
1646     paused = true;
1647     emit Pause();
1648   }
1649 
1650   function unpause() onlyOwner whenPaused public {
1651     paused = false;
1652     emit Unpause();
1653   }
1654 }
1655 
1656 /**
1657  * @title Auction for NFT.
1658  * @author VREX Lab Co., Ltd
1659  */
1660 contract Auction is Pausable, AuctionBase {
1661 
1662     /**
1663      * @dev Removes all Ether from the contract to the NFT contract.
1664      */
1665     function withdrawBalance() external {
1666         address nftAddress = address(nonFungibleContract);
1667 
1668         require(
1669             msg.sender == owner ||
1670             msg.sender == nftAddress
1671         );
1672         nftAddress.transfer(address(this).balance);
1673     }
1674 
1675     /**
1676      * @dev Creates and begins a new auction.
1677      * @param _tokenId ID of the token to creat an auction, caller must be it's owner.
1678      * @param _price Price of the token (in wei).
1679      * @param _seller Seller of this token.
1680      */
1681     function createAuction(
1682         uint256 _tokenId,
1683         uint256 _price,
1684         address _seller
1685     )
1686         external
1687         whenNotPaused
1688         canBeStoredWith128Bits(_price)
1689     {
1690         require(_owns(msg.sender, _tokenId));
1691         _escrow(msg.sender, _tokenId);
1692         Auction memory auction = Auction(
1693             _seller,
1694             uint128(_price),
1695             uint64(now)
1696         );
1697         _addAuction(_tokenId, auction);
1698     }
1699 
1700     /**
1701      * @dev Bids on an open auction, completing the auction and transferring
1702      *  ownership of the NFT if enough Ether is supplied.
1703      * @param _tokenId - ID of token to bid on.
1704      */
1705     function bid(uint256 _tokenId)
1706         external
1707         payable
1708         whenNotPaused
1709     {
1710         _bid(_tokenId, msg.value);
1711         _transfer(msg.sender, _tokenId);
1712     }
1713 
1714     /**
1715      * @dev Cancels an auction and returns the NFT to the current owner.
1716      * @param _tokenId ID of the token on auction to cancel.
1717      * @param _seller The seller's address.
1718      */
1719     function cancelAuction(uint256 _tokenId, address _seller)
1720         external
1721     {
1722         // Requires that this function should only be called from the
1723         // `cancelSaleAuction()` of NFT ownership contract. This function gets
1724         // the _seller directly from it's arguments, so if this check doesn't
1725         // exist, then anyone can cancel the auction! OMG!
1726         require(msg.sender == address(nonFungibleContract));
1727         Auction storage auction = tokenIdToAuction[_tokenId];
1728         require(_isOnAuction(auction));
1729         address seller = auction.seller;
1730         require(_seller == seller);
1731         _cancelAuction(_tokenId, seller);
1732     }
1733 
1734     /**
1735      * @dev Cancels an auction when the contract is paused.
1736      * Only the owner may do this, and NFTs are returned to the seller. 
1737      * @param _tokenId ID of the token on auction to cancel.
1738      */
1739     function cancelAuctionWhenPaused(uint256 _tokenId)
1740         external
1741         whenPaused
1742         onlyOwner
1743     {
1744         Auction storage auction = tokenIdToAuction[_tokenId];
1745         require(_isOnAuction(auction));
1746         _cancelAuction(_tokenId, auction.seller);
1747     }
1748 
1749     /**
1750      * @dev Returns the auction information for an NFT
1751      * @param _tokenId ID of the NFT on auction
1752      */
1753     function getAuction(uint256 _tokenId)
1754         external
1755         view
1756         returns
1757     (
1758         address seller,
1759         uint256 price,
1760         uint256 startedAt
1761     ) {
1762         Auction storage auction = tokenIdToAuction[_tokenId];
1763         require(_isOnAuction(auction));
1764         return (
1765             auction.seller,
1766             auction.price,
1767             auction.startedAt
1768         );
1769     }
1770 
1771     /**
1772      * @dev Returns the current price of the token on auction.
1773      * @param _tokenId ID of the token
1774      */
1775     function getCurrentPrice(uint256 _tokenId)
1776         external
1777         view
1778         returns (uint256)
1779     {
1780         Auction storage auction = tokenIdToAuction[_tokenId];
1781         require(_isOnAuction(auction));
1782         return _currentPrice(auction);
1783     }
1784 }
1785 
1786 /**
1787  * @title  Auction for synthesizing
1788  * @author VREX Lab Co., Ltd
1789  * @notice Reset fallback function to prevent accidental fund sending to this contract.
1790  */
1791 contract SynthesizingAuction is Auction {
1792 
1793     /**
1794      * @dev Sanity check that allows us to ensure that we are pointing to the
1795      *  right auction in our `setSynthesizingAuctionAddress()` call.
1796      */
1797     bool public isSynthesizingAuction = true;
1798 
1799     /**
1800      * @dev Creates a reference to the NFT ownership contract and checks the owner cut is valid
1801      * @param _nftAddress Address of a deployed NFT interface contract
1802      * @param _cut Percent cut which the owner takes on each auction, between 0-10,000.
1803      */
1804     constructor(address _nftAddress, uint256 _cut) public {
1805         require(_cut <= 10000);
1806         ownerCut = _cut;
1807 
1808         ERC721Basic candidateContract = ERC721Basic(_nftAddress);
1809         nonFungibleContract = candidateContract;
1810     }
1811 
1812     /**
1813      * @dev Creates and begins a new auction. Since this function is wrapped,
1814      *  requires the caller to be KydyCore contract.
1815      * @param _tokenId ID of token to auction, sender must be it's owner.
1816      * @param _price Price of the token (in wei).
1817      * @param _seller Seller of this token.
1818      */
1819     function createAuction(
1820         uint256 _tokenId,
1821         uint256 _price,
1822         address _seller
1823     )
1824         external
1825         canBeStoredWith128Bits(_price)
1826     {
1827         require(msg.sender == address(nonFungibleContract));
1828         _escrow(_seller, _tokenId);
1829         Auction memory auction = Auction(
1830             _seller,
1831             uint128(_price),
1832             uint64(now)
1833         );
1834         _addAuction(_tokenId, auction);
1835     }
1836 
1837     /**
1838      * @dev Places a bid for synthesizing. Requires the caller
1839      *  is the KydyCore contract because all bid functions
1840      *  should be wrapped. Also returns the Kydy to the
1841      *  seller rather than the bidder.
1842      */
1843     function bid(uint256 _tokenId)
1844         external
1845         payable
1846     {
1847         require(msg.sender == address(nonFungibleContract));
1848         address seller = tokenIdToAuction[_tokenId].seller;
1849         // _bid() checks that the token ID is valid and will throw if bid fails
1850         _bid(_tokenId, msg.value);
1851         // Transfers the Kydy back to the seller, and the bidder will get
1852         // the baby Kydy.
1853         _transfer(seller, _tokenId);
1854     }
1855 }
1856 
1857 /**
1858  * @title Auction for sale of Kydys.
1859  * @author VREX Lab Co., Ltd
1860  */
1861 contract SaleAuction is Auction {
1862 
1863     /**
1864      * @dev To make sure we are addressing to the right auction. 
1865      */
1866     bool public isSaleAuction = true;
1867 
1868     // Last 5 sale price of Generation 0 Kydys.
1869     uint256[5] public lastGen0SalePrices;
1870     
1871     // Total number of Generation 0 Kydys sold.
1872     uint256 public gen0SaleCount;
1873 
1874     /**
1875      * @dev Creates a reference to the NFT ownership contract and checks the owner cut is valid
1876      * @param _nftAddress Address of a deployed NFT interface contract
1877      * @param _cut Percent cut which the owner takes on each auction, between 0-10,000.
1878      */
1879     constructor(address _nftAddress, uint256 _cut) public {
1880         require(_cut <= 10000);
1881         ownerCut = _cut;
1882 
1883         ERC721Basic candidateContract = ERC721Basic(_nftAddress);
1884         nonFungibleContract = candidateContract;
1885     }
1886 
1887     /**
1888      * @dev Creates and begins a new auction.
1889      * @param _tokenId ID of token to auction, sender must be it's owner.
1890      * @param _price Price of the token (in wei).
1891      * @param _seller Seller of this token.
1892      */
1893     function createAuction(
1894         uint256 _tokenId,
1895         uint256 _price,
1896         address _seller
1897     )
1898         external
1899         canBeStoredWith128Bits(_price)
1900     {
1901         require(msg.sender == address(nonFungibleContract));
1902         _escrow(_seller, _tokenId);
1903         Auction memory auction = Auction(
1904             _seller,
1905             uint128(_price),
1906             uint64(now)
1907         );
1908         _addAuction(_tokenId, auction);
1909     }
1910 
1911     /**
1912      * @dev Updates lastSalePrice only if the seller is nonFungibleContract. 
1913      */
1914     function bid(uint256 _tokenId)
1915         external
1916         payable
1917     {
1918         // _bid verifies token ID
1919         address seller = tokenIdToAuction[_tokenId].seller;
1920         uint256 price = _bid(_tokenId, msg.value);
1921         _transfer(msg.sender, _tokenId);
1922 
1923         // If the last sale was not Generation 0 Kydy's, the lastSalePrice doesn't change.
1924         if (seller == address(nonFungibleContract)) {
1925             // Tracks gen0's latest sale prices.
1926             lastGen0SalePrices[gen0SaleCount % 5] = price;
1927             gen0SaleCount++;
1928         }
1929     }
1930 
1931     /// @dev Gives the new average Generation 0 sale price after each Generation 0 Kydy sale.
1932     function averageGen0SalePrice() external view returns (uint256) {
1933         uint256 sum = 0;
1934         for (uint256 i = 0; i < 5; i++) {
1935             sum = sum.add(lastGen0SalePrices[i]);
1936         }
1937         return sum / 5;
1938     }
1939 }
1940 
1941 /**
1942  * @title This contract defines how sales and synthesis auctions for Kydys are created. 
1943  * @author VREX Lab Co., Ltd
1944  */
1945 contract KydyAuction is KydySynthesis {
1946 
1947     /**
1948      * @dev The address of the Auction contract which handles ALL sales of Kydys, both user-generated and Generation 0. 
1949      */
1950     SaleAuction public saleAuction;
1951 
1952     /**
1953      * @dev The address of another Auction contract which handles synthesis auctions. 
1954      */
1955     SynthesizingAuction public synthesizingAuction;
1956 
1957     /**
1958      * @dev Sets the address for the sales auction. Only CEO may call this function. 
1959      * @param _address The address of the sale contract.
1960      */
1961     function setSaleAuctionAddress(address _address) external onlyCEO {
1962         SaleAuction candidateContract = SaleAuction(_address);
1963 
1964         // Verifies that the contract is correct
1965         require(candidateContract.isSaleAuction());
1966 
1967         // Sets the new sale auction contract address.
1968         saleAuction = candidateContract;
1969     }
1970 
1971     /**
1972      * @dev Sets the address to the synthesis auction. Only CEO may call this function.
1973      * @param _address The address of the synthesis contract.
1974      */
1975     function setSynthesizingAuctionAddress(address _address) external onlyCEO {
1976         SynthesizingAuction candidateContract = SynthesizingAuction(_address);
1977 
1978         require(candidateContract.isSynthesizingAuction());
1979 
1980         synthesizingAuction = candidateContract;
1981     }
1982 
1983     /**
1984      * @dev Creates a Kydy sale.
1985      */
1986     function createSaleAuction(
1987         uint256 _kydyId,
1988         uint256 _price
1989     )
1990         external
1991         whenNotPaused
1992     {
1993         require(_owns(msg.sender, _kydyId));
1994         require(!isCreating(_kydyId));
1995         _approve(_kydyId, saleAuction);
1996  
1997         saleAuction.createAuction(
1998             _kydyId,
1999             _price,
2000             msg.sender
2001         );
2002     }
2003 
2004     /**
2005      * @dev Creates a synthesis auction. 
2006      */
2007     function createSynthesizingAuction(
2008         uint256 _kydyId,
2009         uint256 _price
2010     )
2011         external
2012         whenNotPaused
2013     {
2014         require(_owns(msg.sender, _kydyId));
2015         require(isReadyToSynthesize(_kydyId));
2016         _approve(_kydyId, synthesizingAuction);
2017 
2018         synthesizingAuction.createAuction(
2019             _kydyId,
2020             _price,
2021             msg.sender
2022         );
2023     }
2024 
2025     /**
2026      * @dev After bidding for a synthesis auction is accepted, this starts the actual synthesis process.
2027      * @param _yangId ID of the yang Kydy on the synthesis auction.
2028      * @param _yinId ID of the yin Kydy owned by the bidder.
2029      */
2030     function bidOnSynthesizingAuction(
2031         uint256 _yangId,
2032         uint256 _yinId
2033     )
2034         external
2035         payable
2036         whenNotPaused
2037     {
2038         require(_owns(msg.sender, _yinId));
2039         require(isReadyToSynthesize(_yinId));
2040         require(_canSynthesizeWithViaAuction(_yinId, _yangId));
2041 
2042         uint256 currentPrice = synthesizingAuction.getCurrentPrice(_yangId);
2043 
2044         require (msg.value >= currentPrice + autoCreationFee);
2045 
2046         synthesizingAuction.bid.value(msg.value - autoCreationFee)(_yangId);
2047 
2048         _synthesizeWith(uint32(_yinId), uint32(_yangId));
2049     }
2050 
2051     /**
2052      * @dev Cancels a sale and returns the Kydy back to the owner.
2053      * @param _kydyId ID of the Kydy on sale that the owner wishes to cancel.
2054      */
2055     function cancelSaleAuction(
2056         uint256 _kydyId
2057     )
2058         external
2059         whenNotPaused
2060     {
2061         // Checks if the Kydy is in auction. 
2062         require(_owns(saleAuction, _kydyId));
2063         // Gets the seller of the Kydy.
2064         (address seller,,) = saleAuction.getAuction(_kydyId);
2065         // Checks that the caller is the real seller.
2066         require(msg.sender == seller);
2067         // Cancels the sale auction of this kydy by it's seller's request.
2068         saleAuction.cancelAuction(_kydyId, msg.sender);
2069     }
2070 
2071     /**
2072      * @dev Cancels an synthesis auction. 
2073      * @param _kydyId ID of the Kydy on the synthesis auction. 
2074      */
2075     function cancelSynthesizingAuction(
2076         uint256 _kydyId
2077     )
2078         external
2079         whenNotPaused
2080     {
2081         require(_owns(synthesizingAuction, _kydyId));
2082         (address seller,,) = synthesizingAuction.getAuction(_kydyId);
2083         require(msg.sender == seller);
2084         synthesizingAuction.cancelAuction(_kydyId, msg.sender);
2085     }
2086 
2087     /**
2088      * @dev Transfers the balance. 
2089      */
2090     function withdrawAuctionBalances() external onlyCLevel {
2091         saleAuction.withdrawBalance();
2092         synthesizingAuction.withdrawBalance();
2093     }
2094 }
2095 
2096 /**
2097  * @title All functions related to creating Kydys
2098  * @author VREX Lab Co., Ltd
2099  */
2100 contract KydyMinting is KydyAuction {
2101 
2102     // Limits of the number of Kydys that COO can create.
2103     uint256 public constant promoCreationLimit = 888;
2104     uint256 public constant gen0CreationLimit = 8888;
2105 
2106     uint256 public constant gen0StartingPrice = 10 finney;
2107 
2108     // Counts the number of Kydys that COO has created.
2109     uint256 public promoCreatedCount;
2110     uint256 public gen0CreatedCount;
2111 
2112     /**
2113      * @dev Creates promo Kydys, up to a limit. Only COO can call this function.
2114      * @param _genes Encoded genes of the Kydy to be created.
2115      * @param _owner Future owner of the created Kydys. COO is the default owner.
2116      */
2117     function createPromoKydy(uint256 _genes, address _owner) external onlyCOO {
2118         address kydyOwner = _owner;
2119         if (kydyOwner == address(0)) {
2120             kydyOwner = cooAddress;
2121         }
2122         require(promoCreatedCount < promoCreationLimit);
2123 
2124         promoCreatedCount++;
2125         _createKydy(0, 0, 0, _genes, kydyOwner);
2126     }
2127 
2128     /**
2129      * @dev Creates a new gen0 Kydy with the given genes and
2130      *  creates an sale auction of it.
2131      */
2132     function createGen0Auction(uint256 _genes) external onlyCOO {
2133         require(gen0CreatedCount < gen0CreationLimit);
2134 
2135         uint256 kydyId = _createKydy(0, 0, 0, _genes, address(this));
2136         _approve(kydyId, saleAuction);
2137 
2138         saleAuction.createAuction(
2139             kydyId,
2140             _computeNextGen0Price(),
2141             address(this)
2142         );
2143 
2144         gen0CreatedCount++;
2145     }
2146 
2147     /**
2148      * @dev Computes the next gen0 auction price. It will be
2149      *  the average of the past 5 prices + 50%.
2150      */
2151     function _computeNextGen0Price() internal view returns (uint256) {
2152         uint256 averagePrice = saleAuction.averageGen0SalePrice();
2153 
2154         // Sanity check to ensure not to overflow arithmetic.
2155         require(averagePrice == uint256(uint128(averagePrice)));
2156 
2157         uint256 nextPrice = averagePrice.add(averagePrice / 2);
2158 
2159         // New gen0 auction price will not be less than the
2160         // starting price always.
2161         if (nextPrice < gen0StartingPrice) {
2162             nextPrice = gen0StartingPrice;
2163         }
2164 
2165         return nextPrice;
2166     }
2167 }
2168 
2169 contract KydyTravelInterface {
2170     function balanceOfUnclaimedTT(address _user) public view returns(uint256);
2171     function transferTTProduction(address _from, address _to, uint256 _kydyId) public;
2172     function getProductionOf(address _user) public view returns (uint256);
2173 }
2174 
2175 /**
2176  * @title The Dyverse : A decentralized universe of Kydys, the unique 3D characters and avatars on the Blockchain.
2177  * @author VREX Lab Co., Ltd
2178  * @dev This is the main KydyCore contract. It keeps track of the kydys over the blockchain, and manages
2179  *  general operation of the contracts, metadata and important addresses, including defining who can withdraw 
2180  *  the balance from the contract.
2181  */
2182 contract KydyCore is KydyMinting {
2183 
2184     // This is the main Kydy contract. To keep the code upgradable and secure, we broke up the code in two different ways.  
2185     // First, we separated auction and gene combination functions into several sibling contracts. This allows us to securely 
2186     // fix bugs and upgrade contracts, if necessary. Please note that while we try to make most code open source, 
2187     // some code regarding gene combination is not open-source to make it more intriguing for users. 
2188     // However, as always, advanced users will be able to figure out how it works. 
2189     //
2190     // We also break the core function into a few files, having one contract for each of the major functionalities of the Dyverse. 
2191     // The breakdown is as follows:
2192     //
2193     //      - KydyBase: This contract defines the most fundamental core functionalities, including data storage and management.
2194     //
2195     //      - KydyAccessControl: This contract manages the roles, addresses and constraints for CEO, CFO and COO.
2196     //
2197     //      - KydyOwnership: This contract provides the methods required for basic non-fungible token transactions.
2198     //
2199     //      - KydySynthesis: This contract contains how new baby Kydy is created via a process called the Synthesis. 
2200     //
2201     //      - KydyAuction: This contract manages auction creation and bidding. 
2202     //
2203     //      - KydyMinting: This contract defines how we create new Generation 0 Kydys. There is a limit of 8,888 Gen 0 Kydys. 
2204 
2205     // Upgraded version of the core contract.
2206     // Should be used when the core contract is broken and an upgrade is required.
2207     address public newContractAddress;
2208 
2209     /// @notice Creates the main Kydy smart contract instance.
2210     constructor() public {
2211         // Starts with the contract is paused.
2212         paused = true;
2213 
2214         // The creator of the contract is the initial CEO
2215         ceoAddress = msg.sender;
2216 
2217         // Starts with the Kydy ID 0 which is invalid one.
2218         // So we don't have generation-0 parent issues.
2219         _createKydy(0, 0, 0, uint256(-1), address(0));
2220     }
2221 
2222     /**
2223      * @dev Used to mark the smart contract as upgraded when an upgrade happens. 
2224      * @param _v2Address Upgraded version of the core contract.
2225      */
2226     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2227         // We'll announce if the upgrade is needed.
2228         newContractAddress = _v2Address;
2229         emit ContractUpgrade(_v2Address);
2230     }
2231 
2232     /**
2233      * @dev Rejects all Ether being sent from unregistered addresses, so that users don't accidentally end us Ether.
2234      */
2235     function() external payable {
2236         require(
2237             msg.sender == address(saleAuction) ||
2238             msg.sender == address(synthesizingAuction)
2239         );
2240     }
2241 
2242     /**
2243      * @notice Returns all info about a given Kydy. 
2244      * @param _id ID of the Kydy you are enquiring about. 
2245      */
2246     function getKydy(uint256 _id)
2247         external
2248         view
2249         returns (
2250         bool isCreating,
2251         bool isReady,
2252         uint256 rechargeIndex,
2253         uint256 nextActionAt,
2254         uint256 synthesizingWithId,
2255         uint256 createdTime,
2256         uint256 yinId,
2257         uint256 yangId,
2258         uint256 generation,
2259         uint256 genes
2260     ) {
2261         Kydy storage kyd = kydys[_id];
2262 
2263         // If this is setted to 0 then it's not at creating mode.
2264         isCreating = (kyd.synthesizingWithId != 0);
2265         isReady = (kyd.rechargeEndBlock <= block.number);
2266         rechargeIndex = uint256(kyd.rechargeIndex);
2267         nextActionAt = uint256(kyd.rechargeEndBlock);
2268         synthesizingWithId = uint256(kyd.synthesizingWithId);
2269         createdTime = uint256(kyd.createdTime);
2270         yinId = uint256(kyd.yinId);
2271         yangId = uint256(kyd.yangId);
2272         generation = uint256(kyd.generation);
2273         genes = kyd.genes;
2274     }
2275 
2276     /**
2277      * @dev Overrides unpause() to make sure that all external contract addresses are set before unpause. 
2278      * @notice This should be public rather than external.
2279      */
2280     function unpause() public onlyCEO whenPaused {
2281         require(saleAuction != address(0));
2282         require(synthesizingAuction != address(0));
2283         require(geneSynthesis != address(0));
2284         require(newContractAddress == address(0));
2285 
2286         // Now the contract actually unpauses.
2287         super.unpause();
2288     }
2289 
2290     /// @dev CFO can withdraw the balance available from the contract.
2291     function withdrawBalance() external onlyCFO {
2292         uint256 balance = address(this).balance;
2293 
2294         // Subtracts all creation fees needed to be given to the bringKydyHome() callers,
2295         // and plus 1 of margin.
2296         uint256 subtractFees = (creatingKydys + 1) * autoCreationFee;
2297 
2298         if (balance > subtractFees) {
2299             cfoAddress.transfer(balance - subtractFees);
2300         }
2301     }
2302 
2303     /// @dev Sets new tokenURI API for token metadata.
2304     function setNewTokenURI(string _newTokenURI) external onlyCLevel {
2305         tokenURIBase = _newTokenURI;
2306     }
2307 
2308     // An address of Kydy Travel Plugin.
2309     KydyTravelInterface public travelCore;
2310 
2311     /**
2312      * @dev Adds the Kydy Travel Plugin contract to the Kydy Core contract.
2313      * @notice We have a plan to add some fun features to the Dyverse. 
2314      *  Your Kydy will travel all over our world while you carry on with your life.
2315      *  During their travel, they will earn some valuable coins which will then be given to you.
2316      *  Please stay tuned!
2317      */
2318     function setTravelCore(address _newTravelCore) external onlyCEO whenPaused {
2319         travelCore = KydyTravelInterface(_newTravelCore);
2320     }
2321 }