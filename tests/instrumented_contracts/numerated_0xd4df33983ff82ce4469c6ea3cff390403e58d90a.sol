1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 /**
82  * @title Claimable
83  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
84  * This allows the new owner to accept the transfer.
85  */
86 contract Claimable is Ownable {
87   address public pendingOwner;
88 
89   /**
90    * @dev Modifier throws if called by any account other than the pendingOwner.
91    */
92   modifier onlyPendingOwner() {
93     require(msg.sender == pendingOwner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to set the pendingOwner address.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) onlyOwner public {
102     pendingOwner = newOwner;
103   }
104 
105   /**
106    * @dev Allows the pendingOwner address to finalize the transfer.
107    */
108   function claimOwnership() onlyPendingOwner public {
109     OwnershipTransferred(owner, pendingOwner);
110     owner = pendingOwner;
111     pendingOwner = address(0);
112   }
113 }
114 
115 
116 /**
117  * @title Pausable
118  * @dev Base contract which allows children to implement an emergency stop mechanism.
119  */
120 contract Pausable is Ownable {
121   event Pause();
122   event Unpause();
123 
124   bool public paused = false;
125 
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is not paused.
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is paused.
137    */
138   modifier whenPaused() {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     Unpause();
157   }
158 }
159 
160 
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167   uint256 public totalSupply;
168   function balanceOf(address who) public view returns (uint256);
169   function transfer(address to, uint256 value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) public view returns (uint256);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 /**
187  * @title SafeERC20
188  * @dev Wrappers around ERC20 operations that throw on failure.
189  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
190  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
191  */
192 library SafeERC20 {
193   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
194     assert(token.transfer(to, value));
195   }
196 
197   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
198     assert(token.transferFrom(from, to, value));
199   }
200 
201   function safeApprove(ERC20 token, address spender, uint256 value) internal {
202     assert(token.approve(spender, value));
203   }
204 }
205 
206 
207 /**
208  * @title Contracts that should be able to recover tokens
209  * @author SylTi
210  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
211  * This will prevent any accidental loss of tokens.
212  */
213 contract CanReclaimToken is Ownable {
214   using SafeERC20 for ERC20Basic;
215 
216   /**
217    * @dev Reclaim all ERC20Basic compatible tokens
218    * @param token ERC20Basic The address of the token contract
219    */
220   function reclaimToken(ERC20Basic token) external onlyOwner {
221     uint256 balance = token.balanceOf(this);
222     token.safeTransfer(owner, balance);
223   }
224 
225 }
226 
227 
228 /// @title Interface for contracts conforming to ERC-721: Deed Standard
229 /// @author William Entriken (https://phor.net), et al.
230 /// @dev Specification at https://github.com/ethereum/EIPs/pull/841 (DRAFT)
231 interface ERC721 {
232 
233     // COMPLIANCE WITH ERC-165 (DRAFT) /////////////////////////////////////////
234 
235     /// @dev ERC-165 (draft) interface signature for itself
236     // bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
237     //     bytes4(keccak256('supportsInterface(bytes4)'));
238 
239     /// @dev ERC-165 (draft) interface signature for ERC721
240     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
241     //     bytes4(keccak256('ownerOf(uint256)')) ^
242     //     bytes4(keccak256('countOfDeeds()')) ^
243     //     bytes4(keccak256('countOfDeedsByOwner(address)')) ^
244     //     bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
245     //     bytes4(keccak256('approve(address,uint256)')) ^
246     //     bytes4(keccak256('takeOwnership(uint256)'));
247 
248     /// @notice Query a contract to see if it supports a certain interface
249     /// @dev Returns `true` the interface is supported and `false` otherwise,
250     ///  returns `true` for INTERFACE_SIGNATURE_ERC165 and
251     ///  INTERFACE_SIGNATURE_ERC721, see ERC-165 for other interface signatures.
252     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
253 
254     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
255 
256     /// @notice Find the owner of a deed
257     /// @param _deedId The identifier for a deed we are inspecting
258     /// @dev Deeds assigned to zero address are considered destroyed, and
259     ///  queries about them do throw.
260     /// @return The non-zero address of the owner of deed `_deedId`, or `throw`
261     ///  if deed `_deedId` is not tracked by this contract
262     function ownerOf(uint256 _deedId) external view returns (address _owner);
263 
264     /// @notice Count deeds tracked by this contract
265     /// @return A count of the deeds tracked by this contract, where each one of
266     ///  them has an assigned and queryable owner
267     function countOfDeeds() public view returns (uint256 _count);
268 
269     /// @notice Count all deeds assigned to an owner
270     /// @dev Throws if `_owner` is the zero address, representing destroyed deeds.
271     /// @param _owner An address where we are interested in deeds owned by them
272     /// @return The number of deeds owned by `_owner`, possibly zero
273     function countOfDeedsByOwner(address _owner) public view returns (uint256 _count);
274 
275     /// @notice Enumerate deeds assigned to an owner
276     /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
277     ///  `_owner` is the zero address, representing destroyed deeds.
278     /// @param _owner An address where we are interested in deeds owned by them
279     /// @param _index A counter between zero and `countOfDeedsByOwner(_owner)`,
280     ///  inclusive
281     /// @return The identifier for the `_index`th deed assigned to `_owner`,
282     ///   (sort order not specified)
283     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
284 
285     // TRANSFER MECHANISM //////////////////////////////////////////////////////
286 
287     /// @dev This event emits when ownership of any deed changes by any
288     ///  mechanism. This event emits when deeds are created (`from` == 0) and
289     ///  destroyed (`to` == 0). Exception: during contract creation, any
290     ///  transfers may occur without emitting `Transfer`.
291     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
292 
293     /// @dev This event emits on any successful call to
294     ///  `approve(address _spender, uint256 _deedId)`. Exception: does not emit
295     ///  if an owner revokes approval (`_to` == 0x0) on a deed with no existing
296     ///  approval.
297     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
298 
299     /// @notice Approve a new owner to take your deed, or revoke approval by
300     ///  setting the zero address. You may `approve` any number of times while
301     ///  the deed is assigned to you, only the most recent approval matters.
302     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if `_to` ==
303     ///  `msg.sender`.
304     /// @param _deedId The deed you are granting ownership of
305     function approve(address _to, uint256 _deedId) external;
306 
307     /// @notice Become owner of a deed for which you are currently approved
308     /// @dev Throws if `msg.sender` is not approved to become the owner of
309     ///  `deedId` or if `msg.sender` currently owns `_deedId`.
310     /// @param _deedId The deed that is being transferred
311     function takeOwnership(uint256 _deedId) external;
312     
313     // SPEC EXTENSIONS /////////////////////////////////////////////////////////
314     
315     /// @notice Transfer a deed to a new owner.
316     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if
317     ///  `_to` == 0x0.
318     /// @param _to The address of the new owner.
319     /// @param _deedId The deed you are transferring.
320     function transfer(address _to, uint256 _deedId) external;
321 }
322 
323 
324 /// @title Metadata extension to ERC-721 interface
325 /// @author William Entriken (https://phor.net)
326 /// @dev Specification at https://github.com/ethereum/EIPs/pull/841 (DRAFT)
327 interface ERC721Metadata {
328 
329     /// @dev ERC-165 (draft) interface signature for ERC721
330     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
331     //     bytes4(keccak256('name()')) ^
332     //     bytes4(keccak256('symbol()')) ^
333     //     bytes4(keccak256('deedUri(uint256)'));
334 
335     /// @notice A descriptive name for a collection of deeds managed by this
336     ///  contract
337     /// @dev Wallets and exchanges MAY display this to the end user.
338     function name() public pure returns (string _deedName);
339 
340     /// @notice An abbreviated name for deeds managed by this contract
341     /// @dev Wallets and exchanges MAY display this to the end user.
342     function symbol() public pure returns (string _deedSymbol);
343 
344     /// @notice A distinct URI (RFC 3986) for a given token.
345     /// @dev If:
346     ///  * The URI is a URL
347     ///  * The URL is accessible
348     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
349     ///  * The JSON base element is an object
350     ///  then these names of the base element SHALL have special meaning:
351     ///  * "name": A string identifying the item to which `_deedId` grants
352     ///    ownership
353     ///  * "description": A string detailing the item to which `_deedId` grants
354     ///    ownership
355     ///  * "image": A URI pointing to a file of image/* mime type representing
356     ///    the item to which `_deedId` grants ownership
357     ///  Wallets and exchanges MAY display this to the end user.
358     ///  Consider making any images at a width between 320 and 1080 pixels and
359     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
360     function deedUri(uint256 _deedId) external pure returns (string _uri);
361 }
362 
363 
364 /// @dev Implements access control to the DWorld contract.
365 contract DWorldAccessControl is Claimable, Pausable, CanReclaimToken {
366     address public cfoAddress;
367 
368     function DWorldAccessControl() public {
369         // The creator of the contract is the initial CFO.
370         cfoAddress = msg.sender;
371     }
372     
373     /// @dev Access modifier for CFO-only functionality.
374     modifier onlyCFO() {
375         require(msg.sender == cfoAddress);
376         _;
377     }
378 
379     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
380     /// @param _newCFO The address of the new CFO.
381     function setCFO(address _newCFO) external onlyOwner {
382         require(_newCFO != address(0));
383 
384         cfoAddress = _newCFO;
385     }
386 }
387 
388 
389 /// @dev Defines base data structures for DWorld.
390 contract DWorldBase is DWorldAccessControl {
391     using SafeMath for uint256;
392     
393     /// @dev All minted plots (array of plot identifiers). There are
394     /// 2^16 * 2^16 possible plots (covering the entire world), thus
395     /// 32 bits are required. This fits in a uint32. Storing
396     /// the identifiers as uint32 instead of uint256 makes storage
397     /// cheaper. (The impact of this in mappings is less noticeable,
398     /// and using uint32 in the mappings below actually *increases*
399     /// gas cost for minting).
400     uint32[] public plots;
401     
402     mapping (uint256 => address) identifierToOwner;
403     mapping (uint256 => address) identifierToApproved;
404     mapping (address => uint256) ownershipDeedCount;
405     
406     /// @dev Event fired when a plot's data are changed. The plot
407     /// data are not stored in the contract directly, instead the
408     /// data are logged to the block. This gives significant
409     /// reductions in gas requirements (~75k for minting with data
410     /// instead of ~180k). However, it also means plot data are
411     /// not available from *within* other contracts.
412     event SetData(uint256 indexed deedId, string name, string description, string imageUrl, string infoUrl);
413     
414     /// @notice Get all minted plots.
415     function getAllPlots() external view returns(uint32[]) {
416         return plots;
417     }
418     
419     /// @dev Represent a 2D coordinate as a single uint.
420     /// @param x The x-coordinate.
421     /// @param y The y-coordinate.
422     function coordinateToIdentifier(uint256 x, uint256 y) public pure returns(uint256) {
423         require(validCoordinate(x, y));
424         
425         return (y << 16) + x;
426     }
427     
428     /// @dev Turn a single uint representation of a coordinate into its x and y parts.
429     /// @param identifier The uint representation of a coordinate.
430     function identifierToCoordinate(uint256 identifier) public pure returns(uint256 x, uint256 y) {
431         require(validIdentifier(identifier));
432     
433         y = identifier >> 16;
434         x = identifier - (y << 16);
435     }
436     
437     /// @dev Test whether the coordinate is valid.
438     /// @param x The x-part of the coordinate to test.
439     /// @param y The y-part of the coordinate to test.
440     function validCoordinate(uint256 x, uint256 y) public pure returns(bool) {
441         return x < 65536 && y < 65536; // 2^16
442     }
443     
444     /// @dev Test whether an identifier is valid.
445     /// @param identifier The identifier to test.
446     function validIdentifier(uint256 identifier) public pure returns(bool) {
447         return identifier < 4294967296; // 2^16 * 2^16
448     }
449     
450     /// @dev Set a plot's data.
451     /// @param identifier The identifier of the plot to set data for.
452     function _setPlotData(uint256 identifier, string name, string description, string imageUrl, string infoUrl) internal {
453         SetData(identifier, name, description, imageUrl, infoUrl);
454     }
455 }
456 
457 
458 /// @dev Holds deed functionality such as approving and transferring. Implements ERC721.
459 contract DWorldDeed is DWorldBase, ERC721, ERC721Metadata {
460     
461     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
462     function name() public pure returns (string _deedName) {
463         _deedName = "DWorld Plots";
464     }
465     
466     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
467     function symbol() public pure returns (string _deedSymbol) {
468         _deedSymbol = "DWP";
469     }
470     
471     /// @dev ERC-165 (draft) interface signature for itself
472     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
473         bytes4(keccak256('supportsInterface(bytes4)'));
474 
475     /// @dev ERC-165 (draft) interface signature for ERC721
476     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
477         bytes4(keccak256('ownerOf(uint256)')) ^
478         bytes4(keccak256('countOfDeeds()')) ^
479         bytes4(keccak256('countOfDeedsByOwner(address)')) ^
480         bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
481         bytes4(keccak256('approve(address,uint256)')) ^
482         bytes4(keccak256('takeOwnership(uint256)'));
483         
484     /// @dev ERC-165 (draft) interface signature for ERC721
485     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
486         bytes4(keccak256('name()')) ^
487         bytes4(keccak256('symbol()')) ^
488         bytes4(keccak256('deedUri(uint256)'));
489     
490     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
491     /// Returns true for any standardized interfaces implemented by this contract.
492     /// (ERC-165 and ERC-721.)
493     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
494         return (
495             (_interfaceID == INTERFACE_SIGNATURE_ERC165)
496             || (_interfaceID == INTERFACE_SIGNATURE_ERC721)
497             || (_interfaceID == INTERFACE_SIGNATURE_ERC721Metadata)
498         );
499     }
500     
501     /// @dev Checks if a given address owns a particular plot.
502     /// @param _owner The address of the owner to check for.
503     /// @param _deedId The plot identifier to check for.
504     function _owns(address _owner, uint256 _deedId) internal view returns (bool) {
505         return identifierToOwner[_deedId] == _owner;
506     }
507     
508     /// @dev Approve a given address to take ownership of a deed.
509     /// @param _from The address approving taking ownership.
510     /// @param _to The address to approve taking ownership.
511     /// @param _deedId The identifier of the deed to give approval for.
512     function _approve(address _from, address _to, uint256 _deedId) internal {
513         identifierToApproved[_deedId] = _to;
514         
515         // Emit event.
516         Approval(_from, _to, _deedId);
517     }
518     
519     /// @dev Checks if a given address has approval to take ownership of a deed.
520     /// @param _claimant The address of the claimant to check for.
521     /// @param _deedId The identifier of the deed to check for.
522     function _approvedFor(address _claimant, uint256 _deedId) internal view returns (bool) {
523         return identifierToApproved[_deedId] == _claimant;
524     }
525     
526     /// @dev Assigns ownership of a specific deed to an address.
527     /// @param _from The address to transfer the deed from.
528     /// @param _to The address to transfer the deed to.
529     /// @param _deedId The identifier of the deed to transfer.
530     function _transfer(address _from, address _to, uint256 _deedId) internal {
531         // The number of plots is capped at 2^16 * 2^16, so this cannot
532         // be overflowed.
533         ownershipDeedCount[_to]++;
534         
535         // Transfer ownership.
536         identifierToOwner[_deedId] = _to;
537         
538         // When a new deed is minted, the _from address is 0x0, but we
539         // do not track deed ownership of 0x0.
540         if (_from != address(0)) {
541             ownershipDeedCount[_from]--;
542             
543             // Clear taking ownership approval.
544             delete identifierToApproved[_deedId];
545         }
546         
547         // Emit the transfer event.
548         Transfer(_from, _to, _deedId);
549     }
550     
551     // ERC 721 implementation
552     
553     /// @notice Returns the total number of deeds currently in existence.
554     /// @dev Required for ERC-721 compliance.
555     function countOfDeeds() public view returns (uint256) {
556         return plots.length;
557     }
558     
559     /// @notice Returns the number of deeds owned by a specific address.
560     /// @param _owner The owner address to check.
561     /// @dev Required for ERC-721 compliance
562     function countOfDeedsByOwner(address _owner) public view returns (uint256) {
563         return ownershipDeedCount[_owner];
564     }
565     
566     /// @notice Returns the address currently assigned ownership of a given deed.
567     /// @dev Required for ERC-721 compliance.
568     function ownerOf(uint256 _deedId) external view returns (address _owner) {
569         _owner = identifierToOwner[_deedId];
570 
571         require(_owner != address(0));
572     }
573     
574     /// @notice Approve a given address to take ownership of a deed.
575     /// @param _to The address to approve taking owernship.
576     /// @param _deedId The identifier of the deed to give approval for.
577     /// @dev Required for ERC-721 compliance.
578     function approve(address _to, uint256 _deedId) external whenNotPaused {
579         uint256[] memory _deedIds = new uint256[](1);
580         _deedIds[0] = _deedId;
581         
582         approveMultiple(_to, _deedIds);
583     }
584     
585     /// @notice Approve a given address to take ownership of multiple deeds.
586     /// @param _to The address to approve taking ownership.
587     /// @param _deedIds The identifiers of the deeds to give approval for.
588     function approveMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
589         // Ensure the sender is not approving themselves.
590         require(msg.sender != _to);
591     
592         for (uint256 i = 0; i < _deedIds.length; i++) {
593             uint256 _deedId = _deedIds[i];
594             
595             // Require the sender is the owner of the deed.
596             require(_owns(msg.sender, _deedId));
597             
598             // Perform the approval.
599             _approve(msg.sender, _to, _deedId);
600         }
601     }
602     
603     /// @notice Transfer a deed to another address. If transferring to a smart
604     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
605     /// deed may be lost forever.
606     /// @param _to The address of the recipient, can be a user or contract.
607     /// @param _deedId The identifier of the deed to transfer.
608     /// @dev Required for ERC-721 compliance.
609     function transfer(address _to, uint256 _deedId) external whenNotPaused {
610         uint256[] memory _deedIds = new uint256[](1);
611         _deedIds[0] = _deedId;
612         
613         transferMultiple(_to, _deedIds);
614     }
615     
616     /// @notice Transfers multiple deeds to another address. If transferring to
617     /// a smart contract be VERY CAREFUL to ensure that it is aware of ERC-721,
618     /// or your deeds may be lost forever.
619     /// @param _to The address of the recipient, can be a user or contract.
620     /// @param _deedIds The identifiers of the deeds to transfer.
621     function transferMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
622         // Safety check to prevent against an unexpected 0x0 default.
623         require(_to != address(0));
624         
625         // Disallow transfers to this contract to prevent accidental misuse.
626         require(_to != address(this));
627     
628         for (uint256 i = 0; i < _deedIds.length; i++) {
629             uint256 _deedId = _deedIds[i];
630             
631             // One can only transfer their own plots.
632             require(_owns(msg.sender, _deedId));
633 
634             // Transfer ownership
635             _transfer(msg.sender, _to, _deedId);
636         }
637     }
638     
639     /// @notice Transfer a deed owned by another address, for which the calling
640     /// address has previously been granted transfer approval by the owner.
641     /// @param _deedId The identifier of the deed to be transferred.
642     /// @dev Required for ERC-721 compliance.
643     function takeOwnership(uint256 _deedId) external whenNotPaused {
644         uint256[] memory _deedIds = new uint256[](1);
645         _deedIds[0] = _deedId;
646         
647         takeOwnershipMultiple(_deedIds);
648     }
649     
650     /// @notice Transfer multiple deeds owned by another address, for which the
651     /// calling address has previously been granted transfer approval by the owner.
652     /// @param _deedIds The identifier of the deed to be transferred.
653     function takeOwnershipMultiple(uint256[] _deedIds) public whenNotPaused {
654         for (uint256 i = 0; i < _deedIds.length; i++) {
655             uint256 _deedId = _deedIds[i];
656             address _from = identifierToOwner[_deedId];
657             
658             // Check for transfer approval
659             require(_approvedFor(msg.sender, _deedId));
660 
661             // Reassign ownership (also clears pending approvals and emits Transfer event).
662             _transfer(_from, msg.sender, _deedId);
663         }
664     }
665     
666     /// @notice Returns a list of all deed identifiers assigned to an address.
667     /// @param _owner The owner whose deeds we are interested in.
668     /// @dev This method MUST NEVER be called by smart contract code. It's very
669     /// expensive and is not supported in contract-to-contract calls as it returns
670     /// a dynamic array (only supported for web3 calls).
671     function deedsOfOwner(address _owner) external view returns(uint256[]) {
672         uint256 deedCount = countOfDeedsByOwner(_owner);
673 
674         if (deedCount == 0) {
675             // Return an empty array.
676             return new uint256[](0);
677         } else {
678             uint256[] memory result = new uint256[](deedCount);
679             uint256 totalDeeds = countOfDeeds();
680             uint256 resultIndex = 0;
681             
682             for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
683                 uint256 identifier = plots[deedNumber];
684                 if (identifierToOwner[identifier] == _owner) {
685                     result[resultIndex] = identifier;
686                     resultIndex++;
687                 }
688             }
689 
690             return result;
691         }
692     }
693     
694     /// @notice Returns a deed identifier of the owner at the given index.
695     /// @param _owner The address of the owner we want to get a deed for.
696     /// @param _index The index of the deed we want.
697     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
698         // The index should be valid.
699         require(_index < countOfDeedsByOwner(_owner));
700 
701         // Loop through all plots, accounting the number of plots of the owner we've seen.
702         uint256 seen = 0;
703         uint256 totalDeeds = countOfDeeds();
704         
705         for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
706             uint256 identifier = plots[deedNumber];
707             if (identifierToOwner[identifier] == _owner) {
708                 if (seen == _index) {
709                     return identifier;
710                 }
711                 
712                 seen++;
713             }
714         }
715     }
716     
717     /// @notice Returns an (off-chain) metadata url for the given deed.
718     /// @param _deedId The identifier of the deed to get the metadata
719     /// url for.
720     /// @dev Implementation of optional ERC-721 functionality.
721     function deedUri(uint256 _deedId) external pure returns (string uri) {
722         require(validIdentifier(_deedId));
723     
724         var (x, y) = identifierToCoordinate(_deedId);
725     
726         // Maximum coordinate length in decimals is 5 (65535)
727         uri = "https://dworld.io/plot/xxxxx/xxxxx";
728         bytes memory _uri = bytes(uri);
729         
730         for (uint256 i = 0; i < 5; i++) {
731             _uri[27 - i] = byte(48 + (x / 10 ** i) % 10);
732             _uri[33 - i] = byte(48 + (y / 10 ** i) % 10);
733         }
734     }
735 }
736 
737 
738 /// @dev Implements renting functionality.
739 contract DWorldRenting is DWorldDeed {
740     event Rent(address indexed renter, uint256 indexed deedId, uint256 rentPeriodEndTimestamp, uint256 rentPeriod);
741     mapping (uint256 => address) identifierToRenter;
742     mapping (uint256 => uint256) identifierToRentPeriodEndTimestamp;
743 
744     /// @dev Checks if a given address rents a particular plot.
745     /// @param _renter The address of the renter to check for.
746     /// @param _deedId The plot identifier to check for.
747     function _rents(address _renter, uint256 _deedId) internal view returns (bool) {
748         return identifierToRenter[_deedId] == _renter && identifierToRentPeriodEndTimestamp[_deedId] >= now;
749     }
750     
751     /// @dev Rent out a deed to an address.
752     /// @param _to The address to rent the deed out to.
753     /// @param _rentPeriod The rent period in seconds.
754     /// @param _deedId The identifier of the deed to rent out.
755     function _rentOut(address _to, uint256 _rentPeriod, uint256 _deedId) internal {
756         // Set the renter and rent period end timestamp
757         uint256 rentPeriodEndTimestamp = now.add(_rentPeriod);
758         identifierToRenter[_deedId] = _to;
759         identifierToRentPeriodEndTimestamp[_deedId] = rentPeriodEndTimestamp;
760         
761         Rent(_to, _deedId, rentPeriodEndTimestamp, _rentPeriod);
762     }
763     
764     /// @notice Rents a plot out to another address.
765     /// @param _to The address of the renter, can be a user or contract.
766     /// @param _rentPeriod The rent time period in seconds.
767     /// @param _deedId The identifier of the plot to rent out.
768     function rentOut(address _to, uint256 _rentPeriod, uint256 _deedId) external whenNotPaused {
769         uint256[] memory _deedIds = new uint256[](1);
770         _deedIds[0] = _deedId;
771         
772         rentOutMultiple(_to, _rentPeriod, _deedIds);
773     }
774     
775     /// @notice Rents multiple plots out to another address.
776     /// @param _to The address of the renter, can be a user or contract.
777     /// @param _rentPeriod The rent time period in seconds.
778     /// @param _deedIds The identifiers of the plots to rent out.
779     function rentOutMultiple(address _to, uint256 _rentPeriod, uint256[] _deedIds) public whenNotPaused {
780         // Safety check to prevent against an unexpected 0x0 default.
781         require(_to != address(0));
782         
783         // Disallow transfers to this contract to prevent accidental misuse.
784         require(_to != address(this));
785         
786         for (uint256 i = 0; i < _deedIds.length; i++) {
787             uint256 _deedId = _deedIds[i];
788             
789             require(validIdentifier(_deedId));
790         
791             // There should not be an active renter.
792             require(identifierToRentPeriodEndTimestamp[_deedId] < now);
793             
794             // One can only rent out their own plots.
795             require(_owns(msg.sender, _deedId));
796             
797             _rentOut(_to, _rentPeriod, _deedId);
798         }
799     }
800     
801     /// @notice Returns the address of the currently assigned renter and
802     /// end time of the rent period of a given plot.
803     /// @param _deedId The identifier of the deed to get the renter and 
804     /// rent period for.
805     function renterOf(uint256 _deedId) external view returns (address _renter, uint256 _rentPeriodEndTimestamp) {
806         require(validIdentifier(_deedId));
807     
808         if (identifierToRentPeriodEndTimestamp[_deedId] < now) {
809             // There is no active renter
810             _renter = address(0);
811             _rentPeriodEndTimestamp = 0;
812         } else {
813             _renter = identifierToRenter[_deedId];
814             _rentPeriodEndTimestamp = identifierToRentPeriodEndTimestamp[_deedId];
815         }
816     }
817 }
818 
819 
820 /// @title The internal clock auction functionality.
821 /// Inspired by CryptoKitties' clock auction
822 contract ClockAuctionBase {
823 
824     // Address of the ERC721 contract this auction is linked to.
825     ERC721 public deedContract;
826 
827     // Fee per successful auction in 1/1000th of a percentage.
828     uint256 public fee;
829     
830     // Total amount of ether yet to be paid to auction beneficiaries.
831     uint256 public outstandingEther = 0 ether;
832     
833     // Amount of ether yet to be paid per beneficiary.
834     mapping (address => uint256) public addressToEtherOwed;
835     
836     /// @dev Represents a deed auction.
837     /// Care has been taken to ensure the auction fits in
838     /// two 256-bit words.
839     struct Auction {
840         address seller;
841         uint128 startPrice;
842         uint128 endPrice;
843         uint64 duration;
844         uint64 startedAt;
845     }
846 
847     mapping (uint256 => Auction) identifierToAuction;
848     
849     // Events
850     event AuctionCreated(address indexed seller, uint256 indexed deedId, uint256 startPrice, uint256 endPrice, uint256 duration);
851     event AuctionSuccessful(address indexed buyer, uint256 indexed deedId, uint256 totalPrice);
852     event AuctionCancelled(uint256 indexed deedId);
853     
854     /// @dev Modifier to check whether the value can be stored in a 64 bit uint.
855     modifier fitsIn64Bits(uint256 _value) {
856         require (_value == uint256(uint64(_value)));
857         _;
858     }
859     
860     /// @dev Modifier to check whether the value can be stored in a 128 bit uint.
861     modifier fitsIn128Bits(uint256 _value) {
862         require (_value == uint256(uint128(_value)));
863         _;
864     }
865     
866     function ClockAuctionBase(address _deedContractAddress, uint256 _fee) public {
867         deedContract = ERC721(_deedContractAddress);
868         
869         // Contract must indicate support for ERC721 through its interface signature.
870         require(deedContract.supportsInterface(0xda671b9b));
871         
872         // Fee must be between 0 and 100%.
873         require(0 <= _fee && _fee <= 100000);
874         fee = _fee;
875     }
876     
877     /// @dev Checks whether the given auction is active.
878     /// @param auction The auction to check for activity.
879     function _activeAuction(Auction storage auction) internal view returns (bool) {
880         return auction.startedAt > 0;
881     }
882     
883     /// @dev Put the deed into escrow, thereby taking ownership of it.
884     /// @param _deedId The identifier of the deed to place into escrow.
885     function _escrow(uint256 _deedId) internal {
886         // Throws if the transfer fails
887         deedContract.takeOwnership(_deedId);
888     }
889     
890     /// @dev Create the auction.
891     /// @param _deedId The identifier of the deed to create the auction for.
892     /// @param auction The auction to create.
893     function _createAuction(uint256 _deedId, Auction auction) internal {
894         // Add the auction to the auction mapping.
895         identifierToAuction[_deedId] = auction;
896         
897         // Trigger auction created event.
898         AuctionCreated(auction.seller, _deedId, auction.startPrice, auction.endPrice, auction.duration);
899     }
900     
901     /// @dev Bid on an auction.
902     /// @param _buyer The address of the buyer.
903     /// @param _value The value sent by the sender (in ether).
904     /// @param _deedId The identifier of the deed to bid on.
905     function _bid(address _buyer, uint256 _value, uint256 _deedId) internal {
906         Auction storage auction = identifierToAuction[_deedId];
907         
908         // The auction must be active.
909         require(_activeAuction(auction));
910         
911         // Calculate the auction's current price.
912         uint256 price = _currentPrice(auction);
913         
914         // Make sure enough funds were sent.
915         require(_value >= price);
916         
917         address seller = auction.seller;
918     
919         if (price > 0) {
920             uint256 totalFee = _calculateFee(price);
921             uint256 proceeds = price - totalFee;
922             
923             // Assign the proceeds to the seller.
924             // We do not send the proceeds directly, as to prevent
925             // malicious sellers from denying auctions (and burning
926             // the buyer's gas).
927             _assignProceeds(seller, proceeds);
928         }
929         
930         AuctionSuccessful(_buyer, _deedId, price);
931         
932         // The bid was won!
933         _winBid(seller, _buyer, _deedId, price);
934         
935         // Remove the auction (we do this at the end, as
936         // winBid might require some additional information
937         // that will be removed when _removeAuction is
938         // called. As we do not transfer funds here, we do
939         // not have to worry about re-entry attacks.
940         _removeAuction(_deedId);
941     }
942 
943     /// @dev Perform the bid win logic (in this case: transfer the deed).
944     /// @param _seller The address of the seller.
945     /// @param _winner The address of the winner.
946     /// @param _deedId The identifier of the deed.
947     /// @param _price The price the auction was bought at.
948     function _winBid(address _seller, address _winner, uint256 _deedId, uint256 _price) internal {
949         _transfer(_winner, _deedId);
950     }
951     
952     /// @dev Cancel an auction.
953     /// @param _deedId The identifier of the deed for which the auction should be cancelled.
954     /// @param auction The auction to cancel.
955     function _cancelAuction(uint256 _deedId, Auction auction) internal {
956         // Remove the auction
957         _removeAuction(_deedId);
958         
959         // Transfer the deed back to the seller
960         _transfer(auction.seller, _deedId);
961         
962         // Trigger auction cancelled event.
963         AuctionCancelled(_deedId);
964     }
965     
966     /// @dev Remove an auction.
967     /// @param _deedId The identifier of the deed for which the auction should be removed.
968     function _removeAuction(uint256 _deedId) internal {
969         delete identifierToAuction[_deedId];
970     }
971     
972     /// @dev Transfer a deed owned by this contract to another address.
973     /// @param _to The address to transfer the deed to.
974     /// @param _deedId The identifier of the deed.
975     function _transfer(address _to, uint256 _deedId) internal {
976         // Throws if the transfer fails
977         deedContract.transfer(_to, _deedId);
978     }
979     
980     /// @dev Assign proceeds to an address.
981     /// @param _to The address to assign proceeds to.
982     /// @param _value The proceeds to assign.
983     function _assignProceeds(address _to, uint256 _value) internal {
984         outstandingEther += _value;
985         addressToEtherOwed[_to] += _value;
986     }
987     
988     /// @dev Calculate the current price of an auction.
989     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
990         require(now >= _auction.startedAt);
991         
992         uint256 secondsPassed = now - _auction.startedAt;
993         
994         if (secondsPassed >= _auction.duration) {
995             return _auction.endPrice;
996         } else {
997             // Negative if the end price is higher than the start price!
998             int256 totalPriceChange = int256(_auction.endPrice) - int256(_auction.startPrice);
999             
1000             // Calculate the current price based on the total change over the entire
1001             // auction duration, and the amount of time passed since the start of the
1002             // auction.
1003             int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);
1004             
1005             // Calculate the final price. Note this once again
1006             // is representable by a uint256, as the price can
1007             // never be negative.
1008             int256 price = int256(_auction.startPrice) + currentPriceChange;
1009             
1010             // This never throws.
1011             assert(price >= 0);
1012             
1013             return uint256(price);
1014         }
1015     }
1016     
1017     /// @dev Calculate the fee for a given price.
1018     /// @param _price The price to calculate the fee for.
1019     function _calculateFee(uint256 _price) internal view returns (uint256) {
1020         // _price is guaranteed to fit in a uint128 due to the createAuction entry
1021         // modifiers, so this cannot overflow.
1022         return _price * fee / 100000;
1023     }
1024 }
1025 
1026 
1027 contract ClockAuction is ClockAuctionBase, Pausable {
1028     function ClockAuction(address _deedContractAddress, uint256 _fee) 
1029         ClockAuctionBase(_deedContractAddress, _fee)
1030         public
1031     {}
1032     
1033     /// @notice Update the auction fee.
1034     /// @param _fee The new fee.
1035     function setFee(uint256 _fee) external onlyOwner {
1036         require(0 <= _fee && _fee <= 100000);
1037     
1038         fee = _fee;
1039     }
1040     
1041     /// @notice Get the auction for the given deed.
1042     /// @param _deedId The identifier of the deed to get the auction for.
1043     /// @dev Throws if there is no auction for the given deed.
1044     function getAuction(uint256 _deedId) external view returns (
1045             address seller,
1046             uint256 startPrice,
1047             uint256 endPrice,
1048             uint256 duration,
1049             uint256 startedAt
1050         )
1051     {
1052         Auction storage auction = identifierToAuction[_deedId];
1053         
1054         // The auction must be active
1055         require(_activeAuction(auction));
1056         
1057         return (
1058             auction.seller,
1059             auction.startPrice,
1060             auction.endPrice,
1061             auction.duration,
1062             auction.startedAt
1063         );
1064     }
1065 
1066     /// @notice Create an auction for a given deed.
1067     /// Must previously have been given approval to take ownership of the deed.
1068     /// @param _deedId The identifier of the deed to create an auction for.
1069     /// @param _startPrice The starting price of the auction.
1070     /// @param _endPrice The ending price of the auction.
1071     /// @param _duration The duration in seconds of the dynamic pricing part of the auction.
1072     function createAuction(uint256 _deedId, uint256 _startPrice, uint256 _endPrice, uint256 _duration)
1073         public
1074         fitsIn128Bits(_startPrice)
1075         fitsIn128Bits(_endPrice)
1076         fitsIn64Bits(_duration)
1077         whenNotPaused
1078     {
1079         // Get the owner of the deed to be auctioned
1080         address deedOwner = deedContract.ownerOf(_deedId);
1081     
1082         // Caller must either be the deed contract or the owner of the deed
1083         // to prevent abuse.
1084         require(
1085             msg.sender == address(deedContract) ||
1086             msg.sender == deedOwner
1087         );
1088     
1089         // The duration of the auction must be at least 60 seconds.
1090         require(_duration >= 60);
1091     
1092         // Throws if placing the deed in escrow fails (the contract requires
1093         // transfer approval prior to creating the auction).
1094         _escrow(_deedId);
1095         
1096         // Auction struct
1097         Auction memory auction = Auction(
1098             deedOwner,
1099             uint128(_startPrice),
1100             uint128(_endPrice),
1101             uint64(_duration),
1102             uint64(now)
1103         );
1104         
1105         _createAuction(_deedId, auction);
1106     }
1107     
1108     /// @notice Cancel an auction
1109     /// @param _deedId The identifier of the deed to cancel the auction for.
1110     function cancelAuction(uint256 _deedId) external whenNotPaused {
1111         Auction storage auction = identifierToAuction[_deedId];
1112         
1113         // The auction must be active.
1114         require(_activeAuction(auction));
1115         
1116         // The auction can only be cancelled by the seller
1117         require(msg.sender == auction.seller);
1118         
1119         _cancelAuction(_deedId, auction);
1120     }
1121     
1122     /// @notice Bid on an auction.
1123     /// @param _deedId The identifier of the deed to bid on.
1124     function bid(uint256 _deedId) external payable whenNotPaused {
1125         // Throws if the bid does not succeed.
1126         _bid(msg.sender, msg.value, _deedId);
1127     }
1128     
1129     /// @dev Returns the current price of an auction.
1130     /// @param _deedId The identifier of the deed to get the currency price for.
1131     function getCurrentPrice(uint256 _deedId) external view returns (uint256) {
1132         Auction storage auction = identifierToAuction[_deedId];
1133         
1134         // The auction must be active.
1135         require(_activeAuction(auction));
1136         
1137         return _currentPrice(auction);
1138     }
1139     
1140     /// @notice Withdraw ether owed to a beneficiary.
1141     /// @param beneficiary The address to withdraw the auction balance for.
1142     function withdrawAuctionBalance(address beneficiary) external {
1143         // The sender must either be the beneficiary or the core deed contract.
1144         require(
1145             msg.sender == beneficiary ||
1146             msg.sender == address(deedContract)
1147         );
1148         
1149         uint256 etherOwed = addressToEtherOwed[beneficiary];
1150         
1151         // Ensure ether is owed to the beneficiary.
1152         require(etherOwed > 0);
1153          
1154         // Set ether owed to 0   
1155         delete addressToEtherOwed[beneficiary];
1156         
1157         // Subtract from total outstanding balance. etherOwed is guaranteed
1158         // to be less than or equal to outstandingEther, so this cannot
1159         // underflow.
1160         outstandingEther -= etherOwed;
1161         
1162         // Transfer ether owed to the beneficiary (not susceptible to re-entry
1163         // attack, as the ether owed is set to 0 before the transfer takes place).
1164         beneficiary.transfer(etherOwed);
1165     }
1166     
1167     /// @notice Withdraw (unowed) contract balance.
1168     function withdrawFreeBalance() external {
1169         // Calculate the free (unowed) balance. This never underflows, as
1170         // outstandingEther is guaranteed to be less than or equal to the
1171         // contract balance.
1172         uint256 freeBalance = this.balance - outstandingEther;
1173         
1174         address deedContractAddress = address(deedContract);
1175 
1176         require(
1177             msg.sender == owner ||
1178             msg.sender == deedContractAddress
1179         );
1180         
1181         deedContractAddress.transfer(freeBalance);
1182     }
1183 }
1184 
1185 
1186 contract SaleAuction is ClockAuction {
1187     function SaleAuction(address _deedContractAddress, uint256 _fee) ClockAuction(_deedContractAddress, _fee) public {}
1188     
1189     /// @dev Allows other contracts to check whether this is the expected contract.
1190     bool public isSaleAuction = true;
1191 }
1192 
1193 
1194 contract RentAuction is ClockAuction {
1195     function RentAuction(address _deedContractAddress, uint256 _fee) ClockAuction(_deedContractAddress, _fee) public {}
1196     
1197     /// @dev Allows other contracts to check whether this is the expected contract.
1198     bool public isRentAuction = true;
1199     
1200     mapping (uint256 => uint256) public identifierToRentPeriod;
1201     
1202     /// @notice Create an auction for a given deed. Be careful when calling
1203     /// createAuction for a RentAuction, that this overloaded function (including
1204     /// the _rentPeriod parameter) is used. Otherwise the rent period defaults to
1205     /// a week.
1206     /// Must previously have been given approval to take ownership of the deed.
1207     /// @param _deedId The identifier of the deed to create an auction for.
1208     /// @param _startPrice The starting price of the auction.
1209     /// @param _endPrice The ending price of the auction.
1210     /// @param _duration The duration in seconds of the dynamic pricing part of the auction.
1211     /// @param _rentPeriod The rent period in seconds being auctioned.
1212     function createAuction(
1213         uint256 _deedId,
1214         uint256 _startPrice,
1215         uint256 _endPrice,
1216         uint256 _duration,
1217         uint256 _rentPeriod
1218     )
1219         external
1220     {
1221         // Require the rent period to be at least one hour.
1222         require(_rentPeriod >= 3600);
1223         
1224         // Require there to be no active renter.
1225         DWorldRenting dWorldRentingContract = DWorldRenting(deedContract);
1226         var (renter,) = dWorldRentingContract.renterOf(_deedId);
1227         require(renter == address(0));
1228     
1229         // Set the rent period.
1230         identifierToRentPeriod[_deedId] = _rentPeriod;
1231     
1232         // Throws (reverts) if creating the auction fails.
1233         createAuction(_deedId, _startPrice, _endPrice, _duration);
1234     }
1235     
1236     /// @dev Perform the bid win logic (in this case: give renter status to the winner).
1237     /// @param _seller The address of the seller.
1238     /// @param _winner The address of the winner.
1239     /// @param _deedId The identifier of the deed.
1240     /// @param _price The price the auction was bought at.
1241     function _winBid(address _seller, address _winner, uint256 _deedId, uint256 _price) internal {
1242         DWorldRenting dWorldRentingContract = DWorldRenting(deedContract);
1243     
1244         uint256 rentPeriod = identifierToRentPeriod[_deedId];
1245         if (rentPeriod == 0) {
1246             rentPeriod = 604800; // 1 week by default
1247         }
1248     
1249         // Rent the deed out to the winner.
1250         dWorldRentingContract.rentOut(_winner, identifierToRentPeriod[_deedId], _deedId);
1251         
1252         // Transfer the deed back to the seller.
1253         _transfer(_seller, _deedId);
1254     }
1255     
1256     /// @dev Remove an auction.
1257     /// @param _deedId The identifier of the deed for which the auction should be removed.
1258     function _removeAuction(uint256 _deedId) internal {
1259         delete identifierToAuction[_deedId];
1260         delete identifierToRentPeriod[_deedId];
1261     }
1262 }
1263 
1264 
1265 /// @dev Holds functionality for minting new plot deeds.
1266 contract DWorldMinting is DWorldRenting {
1267     uint256 public unclaimedPlotPrice = 0.0025 ether;
1268     mapping (address => uint256) freeClaimAllowance;
1269     
1270     /// @notice Sets the new price for unclaimed plots.
1271     /// @param _unclaimedPlotPrice The new price for unclaimed plots.
1272     function setUnclaimedPlotPrice(uint256 _unclaimedPlotPrice) external onlyCFO {
1273         unclaimedPlotPrice = _unclaimedPlotPrice;
1274     }
1275     
1276     /// @notice Set the free claim allowance for an address.
1277     /// @param addr The address to set the free claim allowance for.
1278     /// @param allowance The free claim allowance to set.
1279     function setFreeClaimAllowance(address addr, uint256 allowance) external onlyCFO {
1280         freeClaimAllowance[addr] = allowance;
1281     }
1282     
1283     /// @notice Get the free claim allowance of an address.
1284     /// @param addr The address to get the free claim allowance of.
1285     function freeClaimAllowanceOf(address addr) external view returns (uint256) {
1286         return freeClaimAllowance[addr];
1287     }
1288        
1289     /// @notice Buy an unclaimed plot.
1290     /// @param _deedId The unclaimed plot to buy.
1291     function claimPlot(uint256 _deedId) external payable whenNotPaused {
1292         claimPlotWithData(_deedId, "", "", "", "");
1293     }
1294        
1295     /// @notice Buy an unclaimed plot.
1296     /// @param _deedId The unclaimed plot to buy.
1297     /// @param name The name to give the plot.
1298     /// @param description The description to add to the plot.
1299     /// @param imageUrl The image url for the plot.
1300     /// @param infoUrl The info url for the plot.
1301     function claimPlotWithData(uint256 _deedId, string name, string description, string imageUrl, string infoUrl) public payable whenNotPaused {
1302         uint256[] memory _deedIds = new uint256[](1);
1303         _deedIds[0] = _deedId;
1304         
1305         claimPlotMultipleWithData(_deedIds, name, description, imageUrl, infoUrl);
1306     }
1307     
1308     /// @notice Buy unclaimed plots.
1309     /// @param _deedIds The unclaimed plots to buy.
1310     function claimPlotMultiple(uint256[] _deedIds) external payable whenNotPaused {
1311         claimPlotMultipleWithData(_deedIds, "", "", "", "");
1312     }
1313     
1314     /// @notice Buy unclaimed plots.
1315     /// @param _deedIds The unclaimed plots to buy.
1316     /// @param name The name to give the plots.
1317     /// @param description The description to add to the plots.
1318     /// @param imageUrl The image url for the plots.
1319     /// @param infoUrl The info url for the plots.
1320     function claimPlotMultipleWithData(uint256[] _deedIds, string name, string description, string imageUrl, string infoUrl) public payable whenNotPaused {
1321         uint256 buyAmount = _deedIds.length;
1322         uint256 etherRequired;
1323         if (freeClaimAllowance[msg.sender] > 0) {
1324             // The sender has a free claim allowance.
1325             if (freeClaimAllowance[msg.sender] > buyAmount) {
1326                 // Subtract from allowance.
1327                 freeClaimAllowance[msg.sender] -= buyAmount;
1328                 
1329                 // No ether is required.
1330                 etherRequired = 0;
1331             } else {
1332                 uint256 freeAmount = freeClaimAllowance[msg.sender];
1333                 
1334                 // The full allowance has been used.
1335                 delete freeClaimAllowance[msg.sender];
1336                 
1337                 // The subtraction cannot underflow, as freeAmount <= buyAmount.
1338                 etherRequired = unclaimedPlotPrice.mul(buyAmount - freeAmount);
1339             }
1340         } else {
1341             // The sender does not have a free claim allowance.
1342             etherRequired = unclaimedPlotPrice.mul(buyAmount);
1343         }
1344         
1345         // Ensure enough ether is supplied.
1346         require(msg.value >= etherRequired);
1347         
1348         uint256 offset = plots.length;
1349         
1350         // Allocate additional memory for the plots array
1351         // (this is more efficient than .push-ing each individual
1352         // plot, as that requires multiple dynamic allocations).
1353         plots.length = plots.length.add(_deedIds.length);
1354         
1355         for (uint256 i = 0; i < _deedIds.length; i++) { 
1356             uint256 _deedId = _deedIds[i];
1357             require(validIdentifier(_deedId));
1358             
1359             // The plot must be unowned (a plot deed cannot be transferred to
1360             // 0x0, so once a plot is claimed it will always be owned by a
1361             // non-zero address).
1362             require(identifierToOwner[_deedId] == address(0));
1363             
1364             // Create the plot
1365             plots[offset + i] = uint32(_deedId);
1366             
1367             // Transfer the new plot to the sender.
1368             _transfer(address(0), msg.sender, _deedId);
1369             
1370             // Set the plot data.
1371             _setPlotData(_deedId, name, description, imageUrl, infoUrl);
1372         }
1373         
1374         // Calculate the excess ether sent
1375         // msg.value is greater than or equal to etherRequired,
1376         // so this cannot underflow.
1377         uint256 excess = msg.value - etherRequired;
1378         
1379         if (excess > 0) {
1380             // Refund any excess ether (not susceptible to re-entry attack, as
1381             // the owner is assigned before the transfer takes place).
1382             msg.sender.transfer(excess);
1383         }
1384     }
1385 }
1386 
1387 
1388 /// @dev Implements DWorld auction functionality.
1389 contract DWorldAuction is DWorldMinting {
1390     SaleAuction public saleAuctionContract;
1391     RentAuction public rentAuctionContract;
1392     
1393     /// @notice set the contract address of the sale auction.
1394     /// @param _address The address of the sale auction.
1395     function setSaleAuctionContractAddress(address _address) external onlyOwner {
1396         SaleAuction _contract = SaleAuction(_address);
1397     
1398         require(_contract.isSaleAuction());
1399         
1400         saleAuctionContract = _contract;
1401     }
1402     
1403     /// @notice Set the contract address of the rent auction.
1404     /// @param _address The address of the rent auction.
1405     function setRentAuctionContractAddress(address _address) external onlyOwner {
1406         RentAuction _contract = RentAuction(_address);
1407     
1408         require(_contract.isRentAuction());
1409         
1410         rentAuctionContract = _contract;
1411     }
1412     
1413     /// @notice Create a sale auction.
1414     /// @param _deedId The identifier of the deed to create a sale auction for.
1415     /// @param _startPrice The starting price of the sale auction.
1416     /// @param _endPrice The ending price of the sale auction.
1417     /// @param _duration The duration in seconds of the dynamic pricing part of the sale auction.
1418     function createSaleAuction(uint256 _deedId, uint256 _startPrice, uint256 _endPrice, uint256 _duration)
1419         external
1420         whenNotPaused
1421     {
1422         require(_owns(msg.sender, _deedId));
1423         
1424         // Prevent creating a sale auction if no sale auction contract is configured.
1425         require(address(saleAuctionContract) != address(0));
1426     
1427         // Approve the deed for transferring to the sale auction.
1428         _approve(msg.sender, address(saleAuctionContract), _deedId);
1429     
1430         // Auction contract checks input values (throws if invalid) and places the deed into escrow.
1431         saleAuctionContract.createAuction(_deedId, _startPrice, _endPrice, _duration);
1432     }
1433     
1434     /// @notice Create a rent auction.
1435     /// @param _deedId The identifier of the deed to create a rent auction for.
1436     /// @param _startPrice The starting price of the rent auction.
1437     /// @param _endPrice The ending price of the rent auction.
1438     /// @param _duration The duration in seconds of the dynamic pricing part of the rent auction.
1439     /// @param _rentPeriod The rent period in seconds being auctioned.
1440     function createRentAuction(uint256 _deedId, uint256 _startPrice, uint256 _endPrice, uint256 _duration, uint256 _rentPeriod)
1441         external
1442         whenNotPaused
1443     {
1444         require(_owns(msg.sender, _deedId));
1445         
1446         // Prevent creating a rent auction if no rent auction contract is configured.
1447         require(address(rentAuctionContract) != address(0));
1448         
1449         // Approve the deed for transferring to the rent auction.
1450         _approve(msg.sender, address(rentAuctionContract), _deedId);
1451         
1452         // Throws if the auction is invalid (e.g. deed is already rented out),
1453         // and places the deed into escrow.
1454         rentAuctionContract.createAuction(_deedId, _startPrice, _endPrice, _duration, _rentPeriod);
1455     }
1456     
1457     /// @notice Allow the CFO to capture the free balance available
1458     /// in the auction contracts.
1459     function withdrawFreeAuctionBalances() external onlyCFO {
1460         saleAuctionContract.withdrawFreeBalance();
1461         rentAuctionContract.withdrawFreeBalance();
1462     }
1463     
1464     /// @notice Allow withdrawing balances from the auction contracts
1465     /// in a single step.
1466     function withdrawAuctionBalances() external {
1467         // Withdraw from the sale contract if the sender is owed Ether.
1468         if (saleAuctionContract.addressToEtherOwed(msg.sender) > 0) {
1469             saleAuctionContract.withdrawAuctionBalance(msg.sender);
1470         }
1471         
1472         // Withdraw from the rent contract if the sender is owed Ether.
1473         if (rentAuctionContract.addressToEtherOwed(msg.sender) > 0) {
1474             rentAuctionContract.withdrawAuctionBalance(msg.sender);
1475         }
1476     }
1477     
1478     /// @dev This contract is only payable by the auction contracts.
1479     function() public payable {
1480         require(
1481             msg.sender == address(saleAuctionContract) ||
1482             msg.sender == address(rentAuctionContract)
1483         );
1484     }
1485 }
1486 
1487 
1488 /// @dev Implements highest-level DWorld functionality.
1489 contract DWorldCore is DWorldAuction {
1490     /// If this contract is broken, this will be used to publish the address at which an upgraded contract can be found
1491     address public upgradedContractAddress;
1492     event ContractUpgrade(address upgradedContractAddress);
1493 
1494     /// @notice Only to be used when this contract is significantly broken,
1495     /// and an upgrade is required.
1496     function setUpgradedContractAddress(address _upgradedContractAddress) external onlyOwner whenPaused {
1497         upgradedContractAddress = _upgradedContractAddress;
1498         ContractUpgrade(_upgradedContractAddress);
1499     }
1500 
1501     /// @notice Set the data associated with a plot.
1502     function setPlotData(uint256 _deedId, string name, string description, string imageUrl, string infoUrl)
1503         public
1504         whenNotPaused
1505     {
1506         // The sender requesting the data update should be
1507         // the owner (without an active renter) or should
1508         // be the active renter.
1509         require(_owns(msg.sender, _deedId) && identifierToRentPeriodEndTimestamp[_deedId] < now || _rents(msg.sender, _deedId));
1510     
1511         // Set the data
1512         _setPlotData(_deedId, name, description, imageUrl, infoUrl);
1513     }
1514     
1515     /// @notice Set the data associated with multiple plots.
1516     function setPlotDataMultiple(uint256[] _deedIds, string name, string description, string imageUrl, string infoUrl)
1517         external
1518         whenNotPaused
1519     {
1520         for (uint256 i = 0; i < _deedIds.length; i++) {
1521             uint256 _deedId = _deedIds[i];
1522         
1523             setPlotData(_deedId, name, description, imageUrl, infoUrl);
1524         }
1525     }
1526     
1527     /// @notice Allow the CFO to withdraw balance available to this contract.
1528     function withdrawBalance() external onlyCFO {
1529         cfoAddress.transfer(this.balance);
1530     }
1531 }