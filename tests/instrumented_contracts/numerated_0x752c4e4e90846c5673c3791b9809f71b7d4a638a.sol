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
406     // Boolean indicating whether the plot was bought before the migration.
407     mapping (uint256 => bool) public identifierIsOriginal;
408     
409     /// @dev Event fired when a plot's data are changed. The plot
410     /// data are not stored in the contract directly, instead the
411     /// data are logged to the block. This gives significant
412     /// reductions in gas requirements (~75k for minting with data
413     /// instead of ~180k). However, it also means plot data are
414     /// not available from *within* other contracts.
415     event SetData(uint256 indexed deedId, string name, string description, string imageUrl, string infoUrl);
416     
417     /// @notice Get all minted plots.
418     function getAllPlots() external view returns(uint32[]) {
419         return plots;
420     }
421     
422     /// @dev Represent a 2D coordinate as a single uint.
423     /// @param x The x-coordinate.
424     /// @param y The y-coordinate.
425     function coordinateToIdentifier(uint256 x, uint256 y) public pure returns(uint256) {
426         require(validCoordinate(x, y));
427         
428         return (y << 16) + x;
429     }
430     
431     /// @dev Turn a single uint representation of a coordinate into its x and y parts.
432     /// @param identifier The uint representation of a coordinate.
433     function identifierToCoordinate(uint256 identifier) public pure returns(uint256 x, uint256 y) {
434         require(validIdentifier(identifier));
435     
436         y = identifier >> 16;
437         x = identifier - (y << 16);
438     }
439     
440     /// @dev Test whether the coordinate is valid.
441     /// @param x The x-part of the coordinate to test.
442     /// @param y The y-part of the coordinate to test.
443     function validCoordinate(uint256 x, uint256 y) public pure returns(bool) {
444         return x < 65536 && y < 65536; // 2^16
445     }
446     
447     /// @dev Test whether an identifier is valid.
448     /// @param identifier The identifier to test.
449     function validIdentifier(uint256 identifier) public pure returns(bool) {
450         return identifier < 4294967296; // 2^16 * 2^16
451     }
452     
453     /// @dev Set a plot's data.
454     /// @param identifier The identifier of the plot to set data for.
455     function _setPlotData(uint256 identifier, string name, string description, string imageUrl, string infoUrl) internal {
456         SetData(identifier, name, description, imageUrl, infoUrl);
457     }
458 }
459 
460 
461 /// @dev Holds deed functionality such as approving and transferring. Implements ERC721.
462 contract DWorldDeed is DWorldBase, ERC721, ERC721Metadata {
463     
464     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
465     function name() public pure returns (string _deedName) {
466         _deedName = "DWorld Plots";
467     }
468     
469     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
470     function symbol() public pure returns (string _deedSymbol) {
471         _deedSymbol = "DWP";
472     }
473     
474     /// @dev ERC-165 (draft) interface signature for itself
475     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
476         bytes4(keccak256('supportsInterface(bytes4)'));
477 
478     /// @dev ERC-165 (draft) interface signature for ERC721
479     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
480         bytes4(keccak256('ownerOf(uint256)')) ^
481         bytes4(keccak256('countOfDeeds()')) ^
482         bytes4(keccak256('countOfDeedsByOwner(address)')) ^
483         bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
484         bytes4(keccak256('approve(address,uint256)')) ^
485         bytes4(keccak256('takeOwnership(uint256)'));
486         
487     /// @dev ERC-165 (draft) interface signature for ERC721
488     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
489         bytes4(keccak256('name()')) ^
490         bytes4(keccak256('symbol()')) ^
491         bytes4(keccak256('deedUri(uint256)'));
492     
493     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
494     /// Returns true for any standardized interfaces implemented by this contract.
495     /// (ERC-165 and ERC-721.)
496     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
497         return (
498             (_interfaceID == INTERFACE_SIGNATURE_ERC165)
499             || (_interfaceID == INTERFACE_SIGNATURE_ERC721)
500             || (_interfaceID == INTERFACE_SIGNATURE_ERC721Metadata)
501         );
502     }
503     
504     /// @dev Checks if a given address owns a particular plot.
505     /// @param _owner The address of the owner to check for.
506     /// @param _deedId The plot identifier to check for.
507     function _owns(address _owner, uint256 _deedId) internal view returns (bool) {
508         return identifierToOwner[_deedId] == _owner;
509     }
510     
511     /// @dev Approve a given address to take ownership of a deed.
512     /// @param _from The address approving taking ownership.
513     /// @param _to The address to approve taking ownership.
514     /// @param _deedId The identifier of the deed to give approval for.
515     function _approve(address _from, address _to, uint256 _deedId) internal {
516         identifierToApproved[_deedId] = _to;
517         
518         // Emit event.
519         Approval(_from, _to, _deedId);
520     }
521     
522     /// @dev Checks if a given address has approval to take ownership of a deed.
523     /// @param _claimant The address of the claimant to check for.
524     /// @param _deedId The identifier of the deed to check for.
525     function _approvedFor(address _claimant, uint256 _deedId) internal view returns (bool) {
526         return identifierToApproved[_deedId] == _claimant;
527     }
528     
529     /// @dev Assigns ownership of a specific deed to an address.
530     /// @param _from The address to transfer the deed from.
531     /// @param _to The address to transfer the deed to.
532     /// @param _deedId The identifier of the deed to transfer.
533     function _transfer(address _from, address _to, uint256 _deedId) internal {
534         // The number of plots is capped at 2^16 * 2^16, so this cannot
535         // be overflowed.
536         ownershipDeedCount[_to]++;
537         
538         // Transfer ownership.
539         identifierToOwner[_deedId] = _to;
540         
541         // When a new deed is minted, the _from address is 0x0, but we
542         // do not track deed ownership of 0x0.
543         if (_from != address(0)) {
544             ownershipDeedCount[_from]--;
545             
546             // Clear taking ownership approval.
547             delete identifierToApproved[_deedId];
548         }
549         
550         // Emit the transfer event.
551         Transfer(_from, _to, _deedId);
552     }
553     
554     // ERC 721 implementation
555     
556     /// @notice Returns the total number of deeds currently in existence.
557     /// @dev Required for ERC-721 compliance.
558     function countOfDeeds() public view returns (uint256) {
559         return plots.length;
560     }
561     
562     /// @notice Returns the number of deeds owned by a specific address.
563     /// @param _owner The owner address to check.
564     /// @dev Required for ERC-721 compliance
565     function countOfDeedsByOwner(address _owner) public view returns (uint256) {
566         return ownershipDeedCount[_owner];
567     }
568     
569     /// @notice Returns the address currently assigned ownership of a given deed.
570     /// @dev Required for ERC-721 compliance.
571     function ownerOf(uint256 _deedId) external view returns (address _owner) {
572         _owner = identifierToOwner[_deedId];
573 
574         require(_owner != address(0));
575     }
576     
577     /// @notice Approve a given address to take ownership of a deed.
578     /// @param _to The address to approve taking owernship.
579     /// @param _deedId The identifier of the deed to give approval for.
580     /// @dev Required for ERC-721 compliance.
581     function approve(address _to, uint256 _deedId) external whenNotPaused {
582         uint256[] memory _deedIds = new uint256[](1);
583         _deedIds[0] = _deedId;
584         
585         approveMultiple(_to, _deedIds);
586     }
587     
588     /// @notice Approve a given address to take ownership of multiple deeds.
589     /// @param _to The address to approve taking ownership.
590     /// @param _deedIds The identifiers of the deeds to give approval for.
591     function approveMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
592         // Ensure the sender is not approving themselves.
593         require(msg.sender != _to);
594     
595         for (uint256 i = 0; i < _deedIds.length; i++) {
596             uint256 _deedId = _deedIds[i];
597             
598             // Require the sender is the owner of the deed.
599             require(_owns(msg.sender, _deedId));
600             
601             // Perform the approval.
602             _approve(msg.sender, _to, _deedId);
603         }
604     }
605     
606     /// @notice Transfer a deed to another address. If transferring to a smart
607     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
608     /// deed may be lost forever.
609     /// @param _to The address of the recipient, can be a user or contract.
610     /// @param _deedId The identifier of the deed to transfer.
611     /// @dev Required for ERC-721 compliance.
612     function transfer(address _to, uint256 _deedId) external whenNotPaused {
613         uint256[] memory _deedIds = new uint256[](1);
614         _deedIds[0] = _deedId;
615         
616         transferMultiple(_to, _deedIds);
617     }
618     
619     /// @notice Transfers multiple deeds to another address. If transferring to
620     /// a smart contract be VERY CAREFUL to ensure that it is aware of ERC-721,
621     /// or your deeds may be lost forever.
622     /// @param _to The address of the recipient, can be a user or contract.
623     /// @param _deedIds The identifiers of the deeds to transfer.
624     function transferMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
625         // Safety check to prevent against an unexpected 0x0 default.
626         require(_to != address(0));
627         
628         // Disallow transfers to this contract to prevent accidental misuse.
629         require(_to != address(this));
630     
631         for (uint256 i = 0; i < _deedIds.length; i++) {
632             uint256 _deedId = _deedIds[i];
633             
634             // One can only transfer their own plots.
635             require(_owns(msg.sender, _deedId));
636 
637             // Transfer ownership
638             _transfer(msg.sender, _to, _deedId);
639         }
640     }
641     
642     /// @notice Transfer a deed owned by another address, for which the calling
643     /// address has previously been granted transfer approval by the owner.
644     /// @param _deedId The identifier of the deed to be transferred.
645     /// @dev Required for ERC-721 compliance.
646     function takeOwnership(uint256 _deedId) external whenNotPaused {
647         uint256[] memory _deedIds = new uint256[](1);
648         _deedIds[0] = _deedId;
649         
650         takeOwnershipMultiple(_deedIds);
651     }
652     
653     /// @notice Transfer multiple deeds owned by another address, for which the
654     /// calling address has previously been granted transfer approval by the owner.
655     /// @param _deedIds The identifier of the deed to be transferred.
656     function takeOwnershipMultiple(uint256[] _deedIds) public whenNotPaused {
657         for (uint256 i = 0; i < _deedIds.length; i++) {
658             uint256 _deedId = _deedIds[i];
659             address _from = identifierToOwner[_deedId];
660             
661             // Check for transfer approval
662             require(_approvedFor(msg.sender, _deedId));
663 
664             // Reassign ownership (also clears pending approvals and emits Transfer event).
665             _transfer(_from, msg.sender, _deedId);
666         }
667     }
668     
669     /// @notice Returns a list of all deed identifiers assigned to an address.
670     /// @param _owner The owner whose deeds we are interested in.
671     /// @dev This method MUST NEVER be called by smart contract code. It's very
672     /// expensive and is not supported in contract-to-contract calls as it returns
673     /// a dynamic array (only supported for web3 calls).
674     function deedsOfOwner(address _owner) external view returns(uint256[]) {
675         uint256 deedCount = countOfDeedsByOwner(_owner);
676 
677         if (deedCount == 0) {
678             // Return an empty array.
679             return new uint256[](0);
680         } else {
681             uint256[] memory result = new uint256[](deedCount);
682             uint256 totalDeeds = countOfDeeds();
683             uint256 resultIndex = 0;
684             
685             for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
686                 uint256 identifier = plots[deedNumber];
687                 if (identifierToOwner[identifier] == _owner) {
688                     result[resultIndex] = identifier;
689                     resultIndex++;
690                 }
691             }
692 
693             return result;
694         }
695     }
696     
697     /// @notice Returns a deed identifier of the owner at the given index.
698     /// @param _owner The address of the owner we want to get a deed for.
699     /// @param _index The index of the deed we want.
700     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
701         // The index should be valid.
702         require(_index < countOfDeedsByOwner(_owner));
703 
704         // Loop through all plots, accounting the number of plots of the owner we've seen.
705         uint256 seen = 0;
706         uint256 totalDeeds = countOfDeeds();
707         
708         for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
709             uint256 identifier = plots[deedNumber];
710             if (identifierToOwner[identifier] == _owner) {
711                 if (seen == _index) {
712                     return identifier;
713                 }
714                 
715                 seen++;
716             }
717         }
718     }
719     
720     /// @notice Returns an (off-chain) metadata url for the given deed.
721     /// @param _deedId The identifier of the deed to get the metadata
722     /// url for.
723     /// @dev Implementation of optional ERC-721 functionality.
724     function deedUri(uint256 _deedId) external pure returns (string uri) {
725         require(validIdentifier(_deedId));
726     
727         var (x, y) = identifierToCoordinate(_deedId);
728     
729         // Maximum coordinate length in decimals is 5 (65535)
730         uri = "https://dworld.io/plot/xxxxx/xxxxx";
731         bytes memory _uri = bytes(uri);
732         
733         for (uint256 i = 0; i < 5; i++) {
734             _uri[27 - i] = byte(48 + (x / 10 ** i) % 10);
735             _uri[33 - i] = byte(48 + (y / 10 ** i) % 10);
736         }
737     }
738 }
739 
740 
741 /// @dev Holds functionality for finance related to plots.
742 contract DWorldFinance is DWorldDeed {
743     /// Total amount of Ether yet to be paid to auction beneficiaries.
744     uint256 public outstandingEther = 0 ether;
745     
746     /// Amount of Ether yet to be paid per beneficiary.
747     mapping (address => uint256) public addressToEtherOwed;
748     
749     /// Base price for unclaimed plots.
750     uint256 public unclaimedPlotPrice = 0.0125 ether;
751     
752     /// Dividend per plot surrounding a new claim, in 1/1000th of percentages
753     /// of the base unclaimed plot price.
754     uint256 public claimDividendPercentage = 50000;
755     
756     /// Percentage of the buyout price that goes towards dividends.
757     uint256 public buyoutDividendPercentage = 5000;
758     
759     /// Buyout fee in 1/1000th of a percentage.
760     uint256 public buyoutFeePercentage = 3500;
761     
762     /// Number of free claims per address.
763     mapping (address => uint256) freeClaimAllowance;
764     
765     /// Initial price paid for a plot.
766     mapping (uint256 => uint256) public initialPricePaid;
767     
768     /// Current plot price.
769     mapping (uint256 => uint256) public identifierToBuyoutPrice;
770     
771     /// Boolean indicating whether the plot has been bought out at least once.
772     mapping (uint256 => bool) identifierToBoughtOutOnce;
773     
774     /// @dev Event fired when dividend is paid for a new plot claim.
775     event ClaimDividend(address indexed from, address indexed to, uint256 deedIdFrom, uint256 indexed deedIdTo, uint256 dividend);
776     
777     /// @dev Event fired when a buyout is performed.
778     event Buyout(address indexed buyer, address indexed seller, uint256 indexed deedId, uint256 winnings, uint256 totalCost, uint256 newPrice);
779     
780     /// @dev Event fired when dividend is paid for a buyout.
781     event BuyoutDividend(address indexed from, address indexed to, uint256 deedIdFrom, uint256 indexed deedIdTo, uint256 dividend);
782     
783     /// @dev Event fired when the buyout price is manually changed for a plot.
784     event SetBuyoutPrice(uint256 indexed deedId, uint256 newPrice);
785     
786     /// @dev The time after which buyouts will be enabled. Set in the DWorldCore constructor.
787     uint256 public buyoutsEnabledFromTimestamp;
788     
789     /// @notice Sets the new price for unclaimed plots.
790     /// @param _unclaimedPlotPrice The new price for unclaimed plots.
791     function setUnclaimedPlotPrice(uint256 _unclaimedPlotPrice) external onlyCFO {
792         unclaimedPlotPrice = _unclaimedPlotPrice;
793     }
794     
795     /// @notice Sets the new dividend percentage for unclaimed plots.
796     /// @param _claimDividendPercentage The new dividend percentage for unclaimed plots.
797     function setClaimDividendPercentage(uint256 _claimDividendPercentage) external onlyCFO {
798         // Claim dividend percentage must be 10% at the least.
799         // Claim dividend percentage may be 100% at the most.
800         require(10000 <= _claimDividendPercentage && _claimDividendPercentage <= 100000);
801         
802         claimDividendPercentage = _claimDividendPercentage;
803     }
804     
805     /// @notice Sets the new dividend percentage for buyouts.
806     /// @param _buyoutDividendPercentage The new dividend percentage for buyouts.
807     function setBuyoutDividendPercentage(uint256 _buyoutDividendPercentage) external onlyCFO {
808         // Buyout dividend must be 2% at the least.
809         // Buyout dividend percentage may be 12.5% at the most.
810         require(2000 <= _buyoutDividendPercentage && _buyoutDividendPercentage <= 12500);
811         
812         buyoutDividendPercentage = _buyoutDividendPercentage;
813     }
814     
815     /// @notice Sets the new fee percentage for buyouts.
816     /// @param _buyoutFeePercentage The new fee percentage for buyouts.
817     function setBuyoutFeePercentage(uint256 _buyoutFeePercentage) external onlyCFO {
818         // Buyout fee may be 5% at the most.
819         require(0 <= _buyoutFeePercentage && _buyoutFeePercentage <= 5000);
820         
821         buyoutFeePercentage = _buyoutFeePercentage;
822     }
823     
824     /// @notice The claim dividend to be paid for each adjacent plot, and
825     /// as a flat dividend for each buyout.
826     function claimDividend() public view returns (uint256) {
827         return unclaimedPlotPrice.mul(claimDividendPercentage).div(100000);
828     }
829     
830     /// @notice Set the free claim allowance for an address.
831     /// @param addr The address to set the free claim allowance for.
832     /// @param allowance The free claim allowance to set.
833     function setFreeClaimAllowance(address addr, uint256 allowance) external onlyCFO {
834         freeClaimAllowance[addr] = allowance;
835     }
836     
837     /// @notice Get the free claim allowance of an address.
838     /// @param addr The address to get the free claim allowance of.
839     function freeClaimAllowanceOf(address addr) external view returns (uint256) {
840         return freeClaimAllowance[addr];
841     }
842     
843     /// @dev Assign balance to an account.
844     /// @param addr The address to assign balance to.
845     /// @param amount The amount to assign.
846     function _assignBalance(address addr, uint256 amount) internal {
847         addressToEtherOwed[addr] = addressToEtherOwed[addr].add(amount);
848         outstandingEther = outstandingEther.add(amount);
849     }
850     
851     /// @dev Find the _claimed_ plots surrounding a plot.
852     /// @param _deedId The identifier of the plot to get the surrounding plots for.
853     function _claimedSurroundingPlots(uint256 _deedId) internal view returns (uint256[] memory) {
854         var (x, y) = identifierToCoordinate(_deedId);
855         
856         // Find all claimed surrounding plots.
857         uint256 claimed = 0;
858         
859         // Create memory buffer capable of holding all plots.
860         uint256[] memory _plots = new uint256[](8);
861         
862         // Loop through all neighbors.
863         for (int256 dx = -1; dx <= 1; dx++) {
864             for (int256 dy = -1; dy <= 1; dy++) {
865                 if (dx == 0 && dy == 0) {
866                     // Skip the center (i.e., the plot itself).
867                     continue;
868                 }
869                 
870                 // Get the coordinates of this neighboring identifier.
871                 uint256 neighborIdentifier = coordinateToIdentifier(
872                     uint256(int256(x) + dx) % 65536,
873                     uint256(int256(y) + dy) % 65536
874                 );
875                 
876                 if (identifierToOwner[neighborIdentifier] != 0x0) {
877                     _plots[claimed] = neighborIdentifier;
878                     claimed++;
879                 }
880             }
881         }
882         
883         // Memory arrays cannot be resized, so copy all
884         // plots from the buffer to the plot array.
885         uint256[] memory plots = new uint256[](claimed);
886         
887         for (uint256 i = 0; i < claimed; i++) {
888             plots[i] = _plots[i];
889         }
890         
891         return plots;
892     }
893     
894     /// @dev Assign claim dividend to an address.
895     /// @param _from The address who paid the dividend.
896     /// @param _to The dividend beneficiary.
897     /// @param _deedIdFrom The identifier of the deed the dividend is being paid for.
898     /// @param _deedIdTo The identifier of the deed the dividend is being paid to.
899     function _assignClaimDividend(address _from, address _to, uint256 _deedIdFrom, uint256 _deedIdTo) internal {
900         uint256 _claimDividend = claimDividend();
901         
902         // Trigger event.
903         ClaimDividend(_from, _to, _deedIdFrom, _deedIdTo, _claimDividend);
904         
905         // Assign the dividend.
906         _assignBalance(_to, _claimDividend);
907     }
908 
909     /// @dev Calculate and assign the dividend payable for the new plot claim.
910     /// A new claim pays dividends to all existing surrounding plots.
911     /// @param _deedId The identifier of the new plot to calculate and assign dividends for.
912     /// Assumed to be valid.
913     function _calculateAndAssignClaimDividends(uint256 _deedId)
914         internal
915         returns (uint256 totalClaimDividend)
916     {
917         // Get existing surrounding plots.
918         uint256[] memory claimedSurroundingPlots = _claimedSurroundingPlots(_deedId);
919         
920         // Keep track of the claim dividend.
921         uint256 _claimDividend = claimDividend();
922         totalClaimDividend = 0;
923         
924         // Assign claim dividend.
925         for (uint256 i = 0; i < claimedSurroundingPlots.length; i++) {
926             if (identifierToOwner[claimedSurroundingPlots[i]] != msg.sender) {
927                 totalClaimDividend = totalClaimDividend.add(_claimDividend);
928                 _assignClaimDividend(msg.sender, identifierToOwner[claimedSurroundingPlots[i]], _deedId, claimedSurroundingPlots[i]);
929             }
930         }
931     }
932     
933     /// @dev Calculate the next buyout price given the current total buyout cost.
934     /// @param totalCost The current total buyout cost.
935     function nextBuyoutPrice(uint256 totalCost) public pure returns (uint256) {
936         if (totalCost < 0.05 ether) {
937             return totalCost * 2;
938         } else if (totalCost < 0.2 ether) {
939             return totalCost * 170 / 100; // * 1.7
940         } else if (totalCost < 0.5 ether) {
941             return totalCost * 150 / 100; // * 1.5
942         } else {
943             return totalCost.mul(125).div(100); // * 1.25
944         }
945     }
946     
947     /// @notice Get the buyout cost for a given plot.
948     /// @param _deedId The identifier of the plot to get the buyout cost for.
949     function buyoutCost(uint256 _deedId) external view returns (uint256) {
950         // The current buyout price.
951         uint256 price = identifierToBuyoutPrice[_deedId];
952     
953         // Get existing surrounding plots.
954         uint256[] memory claimedSurroundingPlots = _claimedSurroundingPlots(_deedId);
955     
956         // The total cost is the price plus flat rate dividends based on claim dividends.
957         uint256 flatDividends = claimDividend().mul(claimedSurroundingPlots.length);
958         return price.add(flatDividends);
959     }
960     
961     /// @dev Assign the proceeds of the buyout.
962     /// @param _deedId The identifier of the plot that is being bought out.
963     function _assignBuyoutProceeds(
964         address currentOwner,
965         uint256 _deedId,
966         uint256[] memory claimedSurroundingPlots,
967         uint256 currentOwnerWinnings,
968         uint256 totalDividendPerBeneficiary,
969         uint256 totalCost
970     )
971         internal
972     {
973         // Calculate and assign the current owner's winnings.
974         
975         Buyout(msg.sender, currentOwner, _deedId, currentOwnerWinnings, totalCost, nextBuyoutPrice(totalCost));
976         _assignBalance(currentOwner, currentOwnerWinnings);
977         
978         // Assign dividends to owners of surrounding plots.
979         for (uint256 i = 0; i < claimedSurroundingPlots.length; i++) {
980             address beneficiary = identifierToOwner[claimedSurroundingPlots[i]];
981             BuyoutDividend(msg.sender, beneficiary, _deedId, claimedSurroundingPlots[i], totalDividendPerBeneficiary);
982             _assignBalance(beneficiary, totalDividendPerBeneficiary);
983         }
984     }
985     
986     /// @dev Calculate and assign the proceeds from the buyout.
987     /// @param currentOwner The current owner of the plot that is being bought out.
988     /// @param _deedId The identifier of the plot that is being bought out.
989     /// @param claimedSurroundingPlots The surrounding plots that have been claimed.
990     function _calculateAndAssignBuyoutProceeds(address currentOwner, uint256 _deedId, uint256[] memory claimedSurroundingPlots)
991         internal 
992         returns (uint256 totalCost)
993     {
994         // The current price.
995         uint256 price = identifierToBuyoutPrice[_deedId];
996     
997         // The total cost is the price plus flat rate dividends based on claim dividends.
998         uint256 flatDividends = claimDividend().mul(claimedSurroundingPlots.length);
999         totalCost = price.add(flatDividends);
1000         
1001         // Calculate the variable dividends based on the buyout price
1002         // (only to be paid if there are surrounding plots).
1003         uint256 variableDividends = price.mul(buyoutDividendPercentage).div(100000);
1004         
1005         // Calculate fees.
1006         uint256 fee = price.mul(buyoutFeePercentage).div(100000);
1007         
1008         // Calculate and assign buyout proceeds.
1009         uint256 currentOwnerWinnings = price.sub(fee);
1010         
1011         uint256 totalDividendPerBeneficiary;
1012         if (claimedSurroundingPlots.length > 0) {
1013             // If there are surrounding plots, variable dividend is to be paid
1014             // based on the buyout price..
1015             currentOwnerWinnings = currentOwnerWinnings.sub(variableDividends);
1016             
1017             // Calculate the dividend per surrounding plot.
1018             totalDividendPerBeneficiary = flatDividends.add(variableDividends) / claimedSurroundingPlots.length;
1019         }
1020         
1021         _assignBuyoutProceeds(
1022             currentOwner,
1023             _deedId,
1024             claimedSurroundingPlots,
1025             currentOwnerWinnings,
1026             totalDividendPerBeneficiary,
1027             totalCost
1028         );
1029     }
1030     
1031     /// @notice Buy the current owner out of the plot.
1032     function buyout(uint256 _deedId) external payable whenNotPaused {
1033         buyoutWithData(_deedId, "", "", "", "");
1034     }
1035     
1036     /// @notice Buy the current owner out of the plot.
1037     function buyoutWithData(uint256 _deedId, string name, string description, string imageUrl, string infoUrl)
1038         public
1039         payable
1040         whenNotPaused 
1041     {
1042         // Buyouts must be enabled.
1043         require(buyoutsEnabledFromTimestamp <= block.timestamp);
1044     
1045         address currentOwner = identifierToOwner[_deedId];
1046     
1047         // The plot must be owned before it can be bought out.
1048         require(currentOwner != 0x0);
1049         
1050         // Get existing surrounding plots.
1051         uint256[] memory claimedSurroundingPlots = _claimedSurroundingPlots(_deedId);
1052         
1053         // Assign the buyout proceeds and retrieve the total cost.
1054         uint256 totalCost = _calculateAndAssignBuyoutProceeds(currentOwner, _deedId, claimedSurroundingPlots);
1055         
1056         // Ensure the message has enough value.
1057         require(msg.value >= totalCost);
1058         
1059         // Transfer the plot.
1060         _transfer(currentOwner, msg.sender, _deedId);
1061         
1062         // Set the plot data
1063         SetData(_deedId, name, description, imageUrl, infoUrl);
1064         
1065         // Calculate and set the new plot price.
1066         identifierToBuyoutPrice[_deedId] = nextBuyoutPrice(totalCost);
1067         
1068         // Indicate the plot has been bought out at least once
1069         if (!identifierToBoughtOutOnce[_deedId]) {
1070             identifierToBoughtOutOnce[_deedId] = true;
1071         }
1072         
1073         // Calculate the excess Ether sent.
1074         // msg.value is greater than or equal to totalCost,
1075         // so this cannot underflow.
1076         uint256 excess = msg.value - totalCost;
1077         
1078         if (excess > 0) {
1079             // Refund any excess Ether (not susceptible to re-entry attack, as
1080             // the owner is assigned before the transfer takes place).
1081             msg.sender.transfer(excess);
1082         }
1083     }
1084     
1085     /// @notice Calculate the maximum initial buyout price for a plot.
1086     /// @param _deedId The identifier of the plot to get the maximum initial buyout price for.
1087     function maximumInitialBuyoutPrice(uint256 _deedId) public view returns (uint256) {
1088         // The initial buyout price can be set to 4x the initial plot price
1089         // (or 100x for the original pre-migration plots).
1090         uint256 mul = 4;
1091         
1092         if (identifierIsOriginal[_deedId]) {
1093             mul = 100;
1094         }
1095         
1096         return initialPricePaid[_deedId].mul(mul);
1097     }
1098     
1099     /// @notice Test whether a buyout price is valid.
1100     /// @param _deedId The identifier of the plot to test the buyout price for.
1101     /// @param price The buyout price to test.
1102     function validInitialBuyoutPrice(uint256 _deedId, uint256 price) public view returns (bool) {        
1103         return (price >= unclaimedPlotPrice && price <= maximumInitialBuyoutPrice(_deedId));
1104     }
1105     
1106     /// @notice Manually set the initial buyout price of a plot.
1107     /// @param _deedId The identifier of the plot to set the buyout price for.
1108     /// @param price The value to set the buyout price to.
1109     function setInitialBuyoutPrice(uint256 _deedId, uint256 price) public whenNotPaused {
1110         // One can only set the buyout price of their own plots.
1111         require(_owns(msg.sender, _deedId));
1112         
1113         // The initial buyout price can only be set if the plot has never been bought out before.
1114         require(!identifierToBoughtOutOnce[_deedId]);
1115         
1116         // The buyout price must be valid.
1117         require(validInitialBuyoutPrice(_deedId, price));
1118         
1119         // Set the buyout price.
1120         identifierToBuyoutPrice[_deedId] = price;
1121         
1122         // Trigger the buyout price event.
1123         SetBuyoutPrice(_deedId, price);
1124     }
1125 }
1126 
1127 
1128 /// @dev Holds functionality for minting new plot deeds.
1129 contract DWorldMinting is DWorldFinance {       
1130     /// @notice Buy an unclaimed plot.
1131     /// @param _deedId The unclaimed plot to buy.
1132     /// @param _buyoutPrice The initial buyout price to set on the plot.
1133     function claimPlot(uint256 _deedId, uint256 _buyoutPrice) external payable whenNotPaused {
1134         claimPlotWithData(_deedId, _buyoutPrice, "", "", "", "");
1135     }
1136        
1137     /// @notice Buy an unclaimed plot.
1138     /// @param _deedId The unclaimed plot to buy.
1139     /// @param _buyoutPrice The initial buyout price to set on the plot.
1140     /// @param name The name to give the plot.
1141     /// @param description The description to add to the plot.
1142     /// @param imageUrl The image url for the plot.
1143     /// @param infoUrl The info url for the plot.
1144     function claimPlotWithData(uint256 _deedId, uint256 _buyoutPrice, string name, string description, string imageUrl, string infoUrl) public payable whenNotPaused {
1145         uint256[] memory _deedIds = new uint256[](1);
1146         _deedIds[0] = _deedId;
1147         
1148         claimPlotMultipleWithData(_deedIds, _buyoutPrice, name, description, imageUrl, infoUrl);
1149     }
1150     
1151     /// @notice Buy unclaimed plots.
1152     /// @param _deedIds The unclaimed plots to buy.
1153     /// @param _buyoutPrice The initial buyout price to set on the plot.
1154     function claimPlotMultiple(uint256[] _deedIds, uint256 _buyoutPrice) external payable whenNotPaused {
1155         claimPlotMultipleWithData(_deedIds, _buyoutPrice, "", "", "", "");
1156     }
1157     
1158     /// @notice Buy unclaimed plots.
1159     /// @param _deedIds The unclaimed plots to buy.
1160     /// @param _buyoutPrice The initial buyout price to set on the plot.
1161     /// @param name The name to give the plots.
1162     /// @param description The description to add to the plots.
1163     /// @param imageUrl The image url for the plots.
1164     /// @param infoUrl The info url for the plots.
1165     function claimPlotMultipleWithData(uint256[] _deedIds, uint256 _buyoutPrice, string name, string description, string imageUrl, string infoUrl) public payable whenNotPaused {
1166         uint256 buyAmount = _deedIds.length;
1167         uint256 etherRequired;
1168         if (freeClaimAllowance[msg.sender] > 0) {
1169             // The sender has a free claim allowance.
1170             if (freeClaimAllowance[msg.sender] > buyAmount) {
1171                 // Subtract from allowance.
1172                 freeClaimAllowance[msg.sender] -= buyAmount;
1173                 
1174                 // No ether is required.
1175                 etherRequired = 0;
1176             } else {
1177                 uint256 freeAmount = freeClaimAllowance[msg.sender];
1178                 
1179                 // The full allowance has been used.
1180                 delete freeClaimAllowance[msg.sender];
1181                 
1182                 // The subtraction cannot underflow, as freeAmount <= buyAmount.
1183                 etherRequired = unclaimedPlotPrice.mul(buyAmount - freeAmount);
1184             }
1185         } else {
1186             // The sender does not have a free claim allowance.
1187             etherRequired = unclaimedPlotPrice.mul(buyAmount);
1188         }
1189         
1190         uint256 offset = plots.length;
1191         
1192         // Allocate additional memory for the plots array
1193         // (this is more efficient than .push-ing each individual
1194         // plot, as that requires multiple dynamic allocations).
1195         plots.length = plots.length.add(_deedIds.length);
1196         
1197         for (uint256 i = 0; i < _deedIds.length; i++) { 
1198             uint256 _deedId = _deedIds[i];
1199             require(validIdentifier(_deedId));
1200             
1201             // The plot must be unowned (a plot deed cannot be transferred to
1202             // 0x0, so once a plot is claimed it will always be owned by a
1203             // non-zero address).
1204             require(identifierToOwner[_deedId] == address(0));
1205             
1206             // Create the plot
1207             plots[offset + i] = uint32(_deedId);
1208             
1209             // Transfer the new plot to the sender.
1210             _transfer(address(0), msg.sender, _deedId);
1211             
1212             // Set the plot data.
1213             _setPlotData(_deedId, name, description, imageUrl, infoUrl);
1214             
1215             // Calculate and assign claim dividends.
1216             uint256 claimDividends = _calculateAndAssignClaimDividends(_deedId);
1217             etherRequired = etherRequired.add(claimDividends);
1218             
1219             // Set the initial price paid for the plot.
1220             initialPricePaid[_deedId] = unclaimedPlotPrice.add(claimDividends);
1221             
1222             // Set the initial buyout price. Throws if it does not succeed.
1223             setInitialBuyoutPrice(_deedId, _buyoutPrice);
1224         }
1225         
1226         // Ensure enough ether is supplied.
1227         require(msg.value >= etherRequired);
1228         
1229         // Calculate the excess ether sent
1230         // msg.value is greater than or equal to etherRequired,
1231         // so this cannot underflow.
1232         uint256 excess = msg.value - etherRequired;
1233         
1234         if (excess > 0) {
1235             // Refund any excess ether (not susceptible to re-entry attack, as
1236             // the owner is assigned before the transfer takes place).
1237             msg.sender.transfer(excess);
1238         }
1239     }
1240 }
1241 
1242 
1243 /// @title The internal clock auction functionality.
1244 /// Inspired by CryptoKitties' clock auction
1245 contract ClockAuctionBase {
1246 
1247     // Address of the ERC721 contract this auction is linked to.
1248     ERC721 public deedContract;
1249 
1250     // Fee per successful auction in 1/1000th of a percentage.
1251     uint256 public fee;
1252     
1253     // Total amount of ether yet to be paid to auction beneficiaries.
1254     uint256 public outstandingEther = 0 ether;
1255     
1256     // Amount of ether yet to be paid per beneficiary.
1257     mapping (address => uint256) public addressToEtherOwed;
1258     
1259     /// @dev Represents a deed auction.
1260     /// Care has been taken to ensure the auction fits in
1261     /// two 256-bit words.
1262     struct Auction {
1263         address seller;
1264         uint128 startPrice;
1265         uint128 endPrice;
1266         uint64 duration;
1267         uint64 startedAt;
1268     }
1269 
1270     mapping (uint256 => Auction) identifierToAuction;
1271     
1272     // Events
1273     event AuctionCreated(address indexed seller, uint256 indexed deedId, uint256 startPrice, uint256 endPrice, uint256 duration);
1274     event AuctionSuccessful(address indexed buyer, uint256 indexed deedId, uint256 totalPrice);
1275     event AuctionCancelled(uint256 indexed deedId);
1276     
1277     /// @dev Modifier to check whether the value can be stored in a 64 bit uint.
1278     modifier fitsIn64Bits(uint256 _value) {
1279         require (_value == uint256(uint64(_value)));
1280         _;
1281     }
1282     
1283     /// @dev Modifier to check whether the value can be stored in a 128 bit uint.
1284     modifier fitsIn128Bits(uint256 _value) {
1285         require (_value == uint256(uint128(_value)));
1286         _;
1287     }
1288     
1289     function ClockAuctionBase(address _deedContractAddress, uint256 _fee) public {
1290         deedContract = ERC721(_deedContractAddress);
1291         
1292         // Contract must indicate support for ERC721 through its interface signature.
1293         require(deedContract.supportsInterface(0xda671b9b));
1294         
1295         // Fee must be between 0 and 100%.
1296         require(0 <= _fee && _fee <= 100000);
1297         fee = _fee;
1298     }
1299     
1300     /// @dev Checks whether the given auction is active.
1301     /// @param auction The auction to check for activity.
1302     function _activeAuction(Auction storage auction) internal view returns (bool) {
1303         return auction.startedAt > 0;
1304     }
1305     
1306     /// @dev Put the deed into escrow, thereby taking ownership of it.
1307     /// @param _deedId The identifier of the deed to place into escrow.
1308     function _escrow(uint256 _deedId) internal {
1309         // Throws if the transfer fails
1310         deedContract.takeOwnership(_deedId);
1311     }
1312     
1313     /// @dev Create the auction.
1314     /// @param _deedId The identifier of the deed to create the auction for.
1315     /// @param auction The auction to create.
1316     function _createAuction(uint256 _deedId, Auction auction) internal {
1317         // Add the auction to the auction mapping.
1318         identifierToAuction[_deedId] = auction;
1319         
1320         // Trigger auction created event.
1321         AuctionCreated(auction.seller, _deedId, auction.startPrice, auction.endPrice, auction.duration);
1322     }
1323     
1324     /// @dev Bid on an auction.
1325     /// @param _buyer The address of the buyer.
1326     /// @param _value The value sent by the sender (in ether).
1327     /// @param _deedId The identifier of the deed to bid on.
1328     function _bid(address _buyer, uint256 _value, uint256 _deedId) internal {
1329         Auction storage auction = identifierToAuction[_deedId];
1330         
1331         // The auction must be active.
1332         require(_activeAuction(auction));
1333         
1334         // Calculate the auction's current price.
1335         uint256 price = _currentPrice(auction);
1336         
1337         // Make sure enough funds were sent.
1338         require(_value >= price);
1339         
1340         address seller = auction.seller;
1341     
1342         if (price > 0) {
1343             uint256 totalFee = _calculateFee(price);
1344             uint256 proceeds = price - totalFee;
1345             
1346             // Assign the proceeds to the seller.
1347             // We do not send the proceeds directly, as to prevent
1348             // malicious sellers from denying auctions (and burning
1349             // the buyer's gas).
1350             _assignProceeds(seller, proceeds);
1351         }
1352         
1353         AuctionSuccessful(_buyer, _deedId, price);
1354         
1355         // The bid was won!
1356         _winBid(seller, _buyer, _deedId, price);
1357         
1358         // Remove the auction (we do this at the end, as
1359         // winBid might require some additional information
1360         // that will be removed when _removeAuction is
1361         // called. As we do not transfer funds here, we do
1362         // not have to worry about re-entry attacks.
1363         _removeAuction(_deedId);
1364     }
1365 
1366     /// @dev Perform the bid win logic (in this case: transfer the deed).
1367     /// @param _seller The address of the seller.
1368     /// @param _winner The address of the winner.
1369     /// @param _deedId The identifier of the deed.
1370     /// @param _price The price the auction was bought at.
1371     function _winBid(address _seller, address _winner, uint256 _deedId, uint256 _price) internal {
1372         _transfer(_winner, _deedId);
1373     }
1374     
1375     /// @dev Cancel an auction.
1376     /// @param _deedId The identifier of the deed for which the auction should be cancelled.
1377     /// @param auction The auction to cancel.
1378     function _cancelAuction(uint256 _deedId, Auction auction) internal {
1379         // Remove the auction
1380         _removeAuction(_deedId);
1381         
1382         // Transfer the deed back to the seller
1383         _transfer(auction.seller, _deedId);
1384         
1385         // Trigger auction cancelled event.
1386         AuctionCancelled(_deedId);
1387     }
1388     
1389     /// @dev Remove an auction.
1390     /// @param _deedId The identifier of the deed for which the auction should be removed.
1391     function _removeAuction(uint256 _deedId) internal {
1392         delete identifierToAuction[_deedId];
1393     }
1394     
1395     /// @dev Transfer a deed owned by this contract to another address.
1396     /// @param _to The address to transfer the deed to.
1397     /// @param _deedId The identifier of the deed.
1398     function _transfer(address _to, uint256 _deedId) internal {
1399         // Throws if the transfer fails
1400         deedContract.transfer(_to, _deedId);
1401     }
1402     
1403     /// @dev Assign proceeds to an address.
1404     /// @param _to The address to assign proceeds to.
1405     /// @param _value The proceeds to assign.
1406     function _assignProceeds(address _to, uint256 _value) internal {
1407         outstandingEther += _value;
1408         addressToEtherOwed[_to] += _value;
1409     }
1410     
1411     /// @dev Calculate the current price of an auction.
1412     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
1413         require(now >= _auction.startedAt);
1414         
1415         uint256 secondsPassed = now - _auction.startedAt;
1416         
1417         if (secondsPassed >= _auction.duration) {
1418             return _auction.endPrice;
1419         } else {
1420             // Negative if the end price is higher than the start price!
1421             int256 totalPriceChange = int256(_auction.endPrice) - int256(_auction.startPrice);
1422             
1423             // Calculate the current price based on the total change over the entire
1424             // auction duration, and the amount of time passed since the start of the
1425             // auction.
1426             int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);
1427             
1428             // Calculate the final price. Note this once again
1429             // is representable by a uint256, as the price can
1430             // never be negative.
1431             int256 price = int256(_auction.startPrice) + currentPriceChange;
1432             
1433             // This never throws.
1434             assert(price >= 0);
1435             
1436             return uint256(price);
1437         }
1438     }
1439     
1440     /// @dev Calculate the fee for a given price.
1441     /// @param _price The price to calculate the fee for.
1442     function _calculateFee(uint256 _price) internal view returns (uint256) {
1443         // _price is guaranteed to fit in a uint128 due to the createAuction entry
1444         // modifiers, so this cannot overflow.
1445         return _price * fee / 100000;
1446     }
1447 }
1448 
1449 
1450 contract ClockAuction is ClockAuctionBase, Pausable {
1451     function ClockAuction(address _deedContractAddress, uint256 _fee) 
1452         ClockAuctionBase(_deedContractAddress, _fee)
1453         public
1454     {}
1455     
1456     /// @notice Update the auction fee.
1457     /// @param _fee The new fee.
1458     function setFee(uint256 _fee) external onlyOwner {
1459         require(0 <= _fee && _fee <= 100000);
1460     
1461         fee = _fee;
1462     }
1463     
1464     /// @notice Get the auction for the given deed.
1465     /// @param _deedId The identifier of the deed to get the auction for.
1466     /// @dev Throws if there is no auction for the given deed.
1467     function getAuction(uint256 _deedId) external view returns (
1468             address seller,
1469             uint256 startPrice,
1470             uint256 endPrice,
1471             uint256 duration,
1472             uint256 startedAt
1473         )
1474     {
1475         Auction storage auction = identifierToAuction[_deedId];
1476         
1477         // The auction must be active
1478         require(_activeAuction(auction));
1479         
1480         return (
1481             auction.seller,
1482             auction.startPrice,
1483             auction.endPrice,
1484             auction.duration,
1485             auction.startedAt
1486         );
1487     }
1488 
1489     /// @notice Create an auction for a given deed.
1490     /// Must previously have been given approval to take ownership of the deed.
1491     /// @param _deedId The identifier of the deed to create an auction for.
1492     /// @param _startPrice The starting price of the auction.
1493     /// @param _endPrice The ending price of the auction.
1494     /// @param _duration The duration in seconds of the dynamic pricing part of the auction.
1495     function createAuction(uint256 _deedId, uint256 _startPrice, uint256 _endPrice, uint256 _duration)
1496         public
1497         fitsIn128Bits(_startPrice)
1498         fitsIn128Bits(_endPrice)
1499         fitsIn64Bits(_duration)
1500         whenNotPaused
1501     {
1502         // Get the owner of the deed to be auctioned
1503         address deedOwner = deedContract.ownerOf(_deedId);
1504     
1505         // Caller must either be the deed contract or the owner of the deed
1506         // to prevent abuse.
1507         require(
1508             msg.sender == address(deedContract) ||
1509             msg.sender == deedOwner
1510         );
1511     
1512         // The duration of the auction must be at least 60 seconds.
1513         require(_duration >= 60);
1514     
1515         // Throws if placing the deed in escrow fails (the contract requires
1516         // transfer approval prior to creating the auction).
1517         _escrow(_deedId);
1518         
1519         // Auction struct
1520         Auction memory auction = Auction(
1521             deedOwner,
1522             uint128(_startPrice),
1523             uint128(_endPrice),
1524             uint64(_duration),
1525             uint64(now)
1526         );
1527         
1528         _createAuction(_deedId, auction);
1529     }
1530     
1531     /// @notice Cancel an auction
1532     /// @param _deedId The identifier of the deed to cancel the auction for.
1533     function cancelAuction(uint256 _deedId) external whenNotPaused {
1534         Auction storage auction = identifierToAuction[_deedId];
1535         
1536         // The auction must be active.
1537         require(_activeAuction(auction));
1538         
1539         // The auction can only be cancelled by the seller
1540         require(msg.sender == auction.seller);
1541         
1542         _cancelAuction(_deedId, auction);
1543     }
1544     
1545     /// @notice Bid on an auction.
1546     /// @param _deedId The identifier of the deed to bid on.
1547     function bid(uint256 _deedId) external payable whenNotPaused {
1548         // Throws if the bid does not succeed.
1549         _bid(msg.sender, msg.value, _deedId);
1550     }
1551     
1552     /// @dev Returns the current price of an auction.
1553     /// @param _deedId The identifier of the deed to get the currency price for.
1554     function getCurrentPrice(uint256 _deedId) external view returns (uint256) {
1555         Auction storage auction = identifierToAuction[_deedId];
1556         
1557         // The auction must be active.
1558         require(_activeAuction(auction));
1559         
1560         return _currentPrice(auction);
1561     }
1562     
1563     /// @notice Withdraw ether owed to a beneficiary.
1564     /// @param beneficiary The address to withdraw the auction balance for.
1565     function withdrawAuctionBalance(address beneficiary) external {
1566         // The sender must either be the beneficiary or the core deed contract.
1567         require(
1568             msg.sender == beneficiary ||
1569             msg.sender == address(deedContract)
1570         );
1571         
1572         uint256 etherOwed = addressToEtherOwed[beneficiary];
1573         
1574         // Ensure ether is owed to the beneficiary.
1575         require(etherOwed > 0);
1576          
1577         // Set ether owed to 0   
1578         delete addressToEtherOwed[beneficiary];
1579         
1580         // Subtract from total outstanding balance. etherOwed is guaranteed
1581         // to be less than or equal to outstandingEther, so this cannot
1582         // underflow.
1583         outstandingEther -= etherOwed;
1584         
1585         // Transfer ether owed to the beneficiary (not susceptible to re-entry
1586         // attack, as the ether owed is set to 0 before the transfer takes place).
1587         beneficiary.transfer(etherOwed);
1588     }
1589     
1590     /// @notice Withdraw (unowed) contract balance.
1591     function withdrawFreeBalance() external {
1592         // Calculate the free (unowed) balance. This never underflows, as
1593         // outstandingEther is guaranteed to be less than or equal to the
1594         // contract balance.
1595         uint256 freeBalance = this.balance - outstandingEther;
1596         
1597         address deedContractAddress = address(deedContract);
1598 
1599         require(
1600             msg.sender == owner ||
1601             msg.sender == deedContractAddress
1602         );
1603         
1604         deedContractAddress.transfer(freeBalance);
1605     }
1606 }
1607 
1608 
1609 /// @dev Defines base data structures for DWorld.
1610 contract OriginalDWorldBase is DWorldAccessControl {
1611     using SafeMath for uint256;
1612     
1613     /// @dev All minted plots (array of plot identifiers). There are
1614     /// 2^16 * 2^16 possible plots (covering the entire world), thus
1615     /// 32 bits are required. This fits in a uint32. Storing
1616     /// the identifiers as uint32 instead of uint256 makes storage
1617     /// cheaper. (The impact of this in mappings is less noticeable,
1618     /// and using uint32 in the mappings below actually *increases*
1619     /// gas cost for minting).
1620     uint32[] public plots;
1621     
1622     mapping (uint256 => address) identifierToOwner;
1623     mapping (uint256 => address) identifierToApproved;
1624     mapping (address => uint256) ownershipDeedCount;
1625     
1626     /// @dev Event fired when a plot's data are changed. The plot
1627     /// data are not stored in the contract directly, instead the
1628     /// data are logged to the block. This gives significant
1629     /// reductions in gas requirements (~75k for minting with data
1630     /// instead of ~180k). However, it also means plot data are
1631     /// not available from *within* other contracts.
1632     event SetData(uint256 indexed deedId, string name, string description, string imageUrl, string infoUrl);
1633     
1634     /// @notice Get all minted plots.
1635     function getAllPlots() external view returns(uint32[]) {
1636         return plots;
1637     }
1638     
1639     /// @dev Represent a 2D coordinate as a single uint.
1640     /// @param x The x-coordinate.
1641     /// @param y The y-coordinate.
1642     function coordinateToIdentifier(uint256 x, uint256 y) public pure returns(uint256) {
1643         require(validCoordinate(x, y));
1644         
1645         return (y << 16) + x;
1646     }
1647     
1648     /// @dev Turn a single uint representation of a coordinate into its x and y parts.
1649     /// @param identifier The uint representation of a coordinate.
1650     function identifierToCoordinate(uint256 identifier) public pure returns(uint256 x, uint256 y) {
1651         require(validIdentifier(identifier));
1652     
1653         y = identifier >> 16;
1654         x = identifier - (y << 16);
1655     }
1656     
1657     /// @dev Test whether the coordinate is valid.
1658     /// @param x The x-part of the coordinate to test.
1659     /// @param y The y-part of the coordinate to test.
1660     function validCoordinate(uint256 x, uint256 y) public pure returns(bool) {
1661         return x < 65536 && y < 65536; // 2^16
1662     }
1663     
1664     /// @dev Test whether an identifier is valid.
1665     /// @param identifier The identifier to test.
1666     function validIdentifier(uint256 identifier) public pure returns(bool) {
1667         return identifier < 4294967296; // 2^16 * 2^16
1668     }
1669     
1670     /// @dev Set a plot's data.
1671     /// @param identifier The identifier of the plot to set data for.
1672     function _setPlotData(uint256 identifier, string name, string description, string imageUrl, string infoUrl) internal {
1673         SetData(identifier, name, description, imageUrl, infoUrl);
1674     }
1675 }
1676 
1677 
1678 /// @dev Holds deed functionality such as approving and transferring. Implements ERC721.
1679 contract OriginalDWorldDeed is OriginalDWorldBase, ERC721, ERC721Metadata {
1680     
1681     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
1682     function name() public pure returns (string _deedName) {
1683         _deedName = "DWorld Plots";
1684     }
1685     
1686     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
1687     function symbol() public pure returns (string _deedSymbol) {
1688         _deedSymbol = "DWP";
1689     }
1690     
1691     /// @dev ERC-165 (draft) interface signature for itself
1692     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
1693         bytes4(keccak256('supportsInterface(bytes4)'));
1694 
1695     /// @dev ERC-165 (draft) interface signature for ERC721
1696     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
1697         bytes4(keccak256('ownerOf(uint256)')) ^
1698         bytes4(keccak256('countOfDeeds()')) ^
1699         bytes4(keccak256('countOfDeedsByOwner(address)')) ^
1700         bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
1701         bytes4(keccak256('approve(address,uint256)')) ^
1702         bytes4(keccak256('takeOwnership(uint256)'));
1703         
1704     /// @dev ERC-165 (draft) interface signature for ERC721
1705     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
1706         bytes4(keccak256('name()')) ^
1707         bytes4(keccak256('symbol()')) ^
1708         bytes4(keccak256('deedUri(uint256)'));
1709     
1710     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
1711     /// Returns true for any standardized interfaces implemented by this contract.
1712     /// (ERC-165 and ERC-721.)
1713     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
1714         return (
1715             (_interfaceID == INTERFACE_SIGNATURE_ERC165)
1716             || (_interfaceID == INTERFACE_SIGNATURE_ERC721)
1717             || (_interfaceID == INTERFACE_SIGNATURE_ERC721Metadata)
1718         );
1719     }
1720     
1721     /// @dev Checks if a given address owns a particular plot.
1722     /// @param _owner The address of the owner to check for.
1723     /// @param _deedId The plot identifier to check for.
1724     function _owns(address _owner, uint256 _deedId) internal view returns (bool) {
1725         return identifierToOwner[_deedId] == _owner;
1726     }
1727     
1728     /// @dev Approve a given address to take ownership of a deed.
1729     /// @param _from The address approving taking ownership.
1730     /// @param _to The address to approve taking ownership.
1731     /// @param _deedId The identifier of the deed to give approval for.
1732     function _approve(address _from, address _to, uint256 _deedId) internal {
1733         identifierToApproved[_deedId] = _to;
1734         
1735         // Emit event.
1736         Approval(_from, _to, _deedId);
1737     }
1738     
1739     /// @dev Checks if a given address has approval to take ownership of a deed.
1740     /// @param _claimant The address of the claimant to check for.
1741     /// @param _deedId The identifier of the deed to check for.
1742     function _approvedFor(address _claimant, uint256 _deedId) internal view returns (bool) {
1743         return identifierToApproved[_deedId] == _claimant;
1744     }
1745     
1746     /// @dev Assigns ownership of a specific deed to an address.
1747     /// @param _from The address to transfer the deed from.
1748     /// @param _to The address to transfer the deed to.
1749     /// @param _deedId The identifier of the deed to transfer.
1750     function _transfer(address _from, address _to, uint256 _deedId) internal {
1751         // The number of plots is capped at 2^16 * 2^16, so this cannot
1752         // be overflowed.
1753         ownershipDeedCount[_to]++;
1754         
1755         // Transfer ownership.
1756         identifierToOwner[_deedId] = _to;
1757         
1758         // When a new deed is minted, the _from address is 0x0, but we
1759         // do not track deed ownership of 0x0.
1760         if (_from != address(0)) {
1761             ownershipDeedCount[_from]--;
1762             
1763             // Clear taking ownership approval.
1764             delete identifierToApproved[_deedId];
1765         }
1766         
1767         // Emit the transfer event.
1768         Transfer(_from, _to, _deedId);
1769     }
1770     
1771     // ERC 721 implementation
1772     
1773     /// @notice Returns the total number of deeds currently in existence.
1774     /// @dev Required for ERC-721 compliance.
1775     function countOfDeeds() public view returns (uint256) {
1776         return plots.length;
1777     }
1778     
1779     /// @notice Returns the number of deeds owned by a specific address.
1780     /// @param _owner The owner address to check.
1781     /// @dev Required for ERC-721 compliance
1782     function countOfDeedsByOwner(address _owner) public view returns (uint256) {
1783         return ownershipDeedCount[_owner];
1784     }
1785     
1786     /// @notice Returns the address currently assigned ownership of a given deed.
1787     /// @dev Required for ERC-721 compliance.
1788     function ownerOf(uint256 _deedId) external view returns (address _owner) {
1789         _owner = identifierToOwner[_deedId];
1790 
1791         require(_owner != address(0));
1792     }
1793     
1794     /// @notice Approve a given address to take ownership of a deed.
1795     /// @param _to The address to approve taking owernship.
1796     /// @param _deedId The identifier of the deed to give approval for.
1797     /// @dev Required for ERC-721 compliance.
1798     function approve(address _to, uint256 _deedId) external whenNotPaused {
1799         uint256[] memory _deedIds = new uint256[](1);
1800         _deedIds[0] = _deedId;
1801         
1802         approveMultiple(_to, _deedIds);
1803     }
1804     
1805     /// @notice Approve a given address to take ownership of multiple deeds.
1806     /// @param _to The address to approve taking ownership.
1807     /// @param _deedIds The identifiers of the deeds to give approval for.
1808     function approveMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
1809         // Ensure the sender is not approving themselves.
1810         require(msg.sender != _to);
1811     
1812         for (uint256 i = 0; i < _deedIds.length; i++) {
1813             uint256 _deedId = _deedIds[i];
1814             
1815             // Require the sender is the owner of the deed.
1816             require(_owns(msg.sender, _deedId));
1817             
1818             // Perform the approval.
1819             _approve(msg.sender, _to, _deedId);
1820         }
1821     }
1822     
1823     /// @notice Transfer a deed to another address. If transferring to a smart
1824     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
1825     /// deed may be lost forever.
1826     /// @param _to The address of the recipient, can be a user or contract.
1827     /// @param _deedId The identifier of the deed to transfer.
1828     /// @dev Required for ERC-721 compliance.
1829     function transfer(address _to, uint256 _deedId) external whenNotPaused {
1830         uint256[] memory _deedIds = new uint256[](1);
1831         _deedIds[0] = _deedId;
1832         
1833         transferMultiple(_to, _deedIds);
1834     }
1835     
1836     /// @notice Transfers multiple deeds to another address. If transferring to
1837     /// a smart contract be VERY CAREFUL to ensure that it is aware of ERC-721,
1838     /// or your deeds may be lost forever.
1839     /// @param _to The address of the recipient, can be a user or contract.
1840     /// @param _deedIds The identifiers of the deeds to transfer.
1841     function transferMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
1842         // Safety check to prevent against an unexpected 0x0 default.
1843         require(_to != address(0));
1844         
1845         // Disallow transfers to this contract to prevent accidental misuse.
1846         require(_to != address(this));
1847     
1848         for (uint256 i = 0; i < _deedIds.length; i++) {
1849             uint256 _deedId = _deedIds[i];
1850             
1851             // One can only transfer their own plots.
1852             require(_owns(msg.sender, _deedId));
1853 
1854             // Transfer ownership
1855             _transfer(msg.sender, _to, _deedId);
1856         }
1857     }
1858     
1859     /// @notice Transfer a deed owned by another address, for which the calling
1860     /// address has previously been granted transfer approval by the owner.
1861     /// @param _deedId The identifier of the deed to be transferred.
1862     /// @dev Required for ERC-721 compliance.
1863     function takeOwnership(uint256 _deedId) external whenNotPaused {
1864         uint256[] memory _deedIds = new uint256[](1);
1865         _deedIds[0] = _deedId;
1866         
1867         takeOwnershipMultiple(_deedIds);
1868     }
1869     
1870     /// @notice Transfer multiple deeds owned by another address, for which the
1871     /// calling address has previously been granted transfer approval by the owner.
1872     /// @param _deedIds The identifier of the deed to be transferred.
1873     function takeOwnershipMultiple(uint256[] _deedIds) public whenNotPaused {
1874         for (uint256 i = 0; i < _deedIds.length; i++) {
1875             uint256 _deedId = _deedIds[i];
1876             address _from = identifierToOwner[_deedId];
1877             
1878             // Check for transfer approval
1879             require(_approvedFor(msg.sender, _deedId));
1880 
1881             // Reassign ownership (also clears pending approvals and emits Transfer event).
1882             _transfer(_from, msg.sender, _deedId);
1883         }
1884     }
1885     
1886     /// @notice Returns a list of all deed identifiers assigned to an address.
1887     /// @param _owner The owner whose deeds we are interested in.
1888     /// @dev This method MUST NEVER be called by smart contract code. It's very
1889     /// expensive and is not supported in contract-to-contract calls as it returns
1890     /// a dynamic array (only supported for web3 calls).
1891     function deedsOfOwner(address _owner) external view returns(uint256[]) {
1892         uint256 deedCount = countOfDeedsByOwner(_owner);
1893 
1894         if (deedCount == 0) {
1895             // Return an empty array.
1896             return new uint256[](0);
1897         } else {
1898             uint256[] memory result = new uint256[](deedCount);
1899             uint256 totalDeeds = countOfDeeds();
1900             uint256 resultIndex = 0;
1901             
1902             for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
1903                 uint256 identifier = plots[deedNumber];
1904                 if (identifierToOwner[identifier] == _owner) {
1905                     result[resultIndex] = identifier;
1906                     resultIndex++;
1907                 }
1908             }
1909 
1910             return result;
1911         }
1912     }
1913     
1914     /// @notice Returns a deed identifier of the owner at the given index.
1915     /// @param _owner The address of the owner we want to get a deed for.
1916     /// @param _index The index of the deed we want.
1917     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
1918         // The index should be valid.
1919         require(_index < countOfDeedsByOwner(_owner));
1920 
1921         // Loop through all plots, accounting the number of plots of the owner we've seen.
1922         uint256 seen = 0;
1923         uint256 totalDeeds = countOfDeeds();
1924         
1925         for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
1926             uint256 identifier = plots[deedNumber];
1927             if (identifierToOwner[identifier] == _owner) {
1928                 if (seen == _index) {
1929                     return identifier;
1930                 }
1931                 
1932                 seen++;
1933             }
1934         }
1935     }
1936     
1937     /// @notice Returns an (off-chain) metadata url for the given deed.
1938     /// @param _deedId The identifier of the deed to get the metadata
1939     /// url for.
1940     /// @dev Implementation of optional ERC-721 functionality.
1941     function deedUri(uint256 _deedId) external pure returns (string uri) {
1942         require(validIdentifier(_deedId));
1943     
1944         var (x, y) = identifierToCoordinate(_deedId);
1945     
1946         // Maximum coordinate length in decimals is 5 (65535)
1947         uri = "https://dworld.io/plot/xxxxx/xxxxx";
1948         bytes memory _uri = bytes(uri);
1949         
1950         for (uint256 i = 0; i < 5; i++) {
1951             _uri[27 - i] = byte(48 + (x / 10 ** i) % 10);
1952             _uri[33 - i] = byte(48 + (y / 10 ** i) % 10);
1953         }
1954     }
1955 }
1956 
1957 
1958 /// @dev Migrate original data from the old contract.
1959 contract DWorldUpgrade is DWorldMinting {
1960     OriginalDWorldDeed originalContract;
1961     ClockAuction originalSaleAuction;
1962     ClockAuction originalRentAuction;
1963     
1964     /// @notice Keep track of whether we have finished migrating.
1965     bool public migrationFinished = false;
1966     
1967     /// @dev Keep track of how many plots have been transferred so far.
1968     uint256 migrationNumPlotsTransferred = 0;
1969     
1970     function DWorldUpgrade(
1971         address originalContractAddress,
1972         address originalSaleAuctionAddress,
1973         address originalRentAuctionAddress
1974     )
1975         public
1976     {
1977         if (originalContractAddress != 0) {
1978             _startMigration(originalContractAddress, originalSaleAuctionAddress, originalRentAuctionAddress);
1979         } else {
1980             migrationFinished = true;
1981         }
1982     }
1983     
1984     /// @dev Migrate data from the original contract. Assumes the original
1985     /// contract is paused, and remains paused for the duration of the
1986     /// migration.
1987     /// @param originalContractAddress The address of the original contract.
1988     function _startMigration(
1989         address originalContractAddress,
1990         address originalSaleAuctionAddress,
1991         address originalRentAuctionAddress
1992     )
1993         internal
1994     {
1995         // Set contracts.
1996         originalContract = OriginalDWorldDeed(originalContractAddress);
1997         originalSaleAuction = ClockAuction(originalSaleAuctionAddress);
1998         originalRentAuction = ClockAuction(originalRentAuctionAddress);
1999         
2000         // Start paused.
2001         paused = true;
2002         
2003         // Get count of original plots.
2004         uint256 numPlots = originalContract.countOfDeeds();
2005         
2006         // Allocate storage for the plots array (this is more
2007         // efficient than .push-ing each individual plot, as
2008         // that requires multiple dynamic allocations).
2009         plots.length = numPlots;
2010     }
2011     
2012     function migrationStep(uint256 numPlotsTransfer) external onlyOwner whenPaused {
2013         // Migration must not be finished yet.
2014         require(!migrationFinished);
2015     
2016         // Get count of original plots.
2017         uint256 numPlots = originalContract.countOfDeeds();
2018     
2019         // Loop through plots and assign to original owner.
2020         uint256 i;
2021         for (i = migrationNumPlotsTransferred; i < numPlots && i < migrationNumPlotsTransferred + numPlotsTransfer; i++) {
2022             uint32 _deedId = originalContract.plots(i);
2023             
2024             // Set plot.
2025             plots[i] = _deedId;
2026             
2027             // Get the original owner and transfer.
2028             address owner = originalContract.ownerOf(_deedId);
2029             
2030             // If the owner of the plot is an auction contract,
2031             // get the actual owner of the plot.
2032             address seller;
2033             if (owner == address(originalSaleAuction)) {
2034                 (seller, ) = originalSaleAuction.getAuction(_deedId);
2035                 owner = seller;
2036             } else if (owner == address(originalRentAuction)) {
2037                 (seller, ) = originalRentAuction.getAuction(_deedId);
2038                 owner = seller;
2039             }
2040             
2041             _transfer(address(0), owner, _deedId);
2042             
2043             // Set the initial price paid for the plot.
2044             initialPricePaid[_deedId] = 0.0125 ether;
2045             
2046             // The initial buyout price.
2047             uint256 _initialBuyoutPrice = 0.050 ether;
2048             
2049             // Set the initial buyout price.
2050             identifierToBuyoutPrice[_deedId] = _initialBuyoutPrice;
2051             
2052             // Trigger the buyout price event.
2053             SetBuyoutPrice(_deedId, _initialBuyoutPrice);
2054             
2055             // Mark the plot as being an original.
2056             identifierIsOriginal[_deedId] = true;
2057         }
2058         
2059         migrationNumPlotsTransferred += numPlotsTransfer;
2060         
2061         // Finished migration.
2062         if (i == numPlots) {
2063             migrationFinished = true;
2064         }
2065     }
2066 }
2067 
2068 
2069 /// @dev Implements highest-level DWorld functionality.
2070 contract DWorldCore is DWorldUpgrade {
2071     /// If this contract is broken, this will be used to publish the address at which an upgraded contract can be found
2072     address public upgradedContractAddress;
2073     event ContractUpgrade(address upgradedContractAddress);
2074 
2075     function DWorldCore(
2076         address originalContractAddress,
2077         address originalSaleAuctionAddress,
2078         address originalRentAuctionAddress,
2079         uint256 buyoutsEnabledAfterHours
2080     )
2081         DWorldUpgrade(originalContractAddress, originalSaleAuctionAddress, originalRentAuctionAddress)
2082         public 
2083     {
2084         buyoutsEnabledFromTimestamp = block.timestamp + buyoutsEnabledAfterHours * 3600;
2085     }
2086     
2087     /// @notice Only to be used when this contract is significantly broken,
2088     /// and an upgrade is required.
2089     function setUpgradedContractAddress(address _upgradedContractAddress) external onlyOwner whenPaused {
2090         upgradedContractAddress = _upgradedContractAddress;
2091         ContractUpgrade(_upgradedContractAddress);
2092     }
2093 
2094     /// @notice Set the data associated with a plot.
2095     function setPlotData(uint256 _deedId, string name, string description, string imageUrl, string infoUrl)
2096         public
2097         whenNotPaused
2098     {
2099         // The sender requesting the data update should be
2100         // the owner.
2101         require(_owns(msg.sender, _deedId));
2102     
2103         // Set the data
2104         _setPlotData(_deedId, name, description, imageUrl, infoUrl);
2105     }
2106     
2107     /// @notice Set the data associated with multiple plots.
2108     function setPlotDataMultiple(uint256[] _deedIds, string name, string description, string imageUrl, string infoUrl)
2109         external
2110         whenNotPaused
2111     {
2112         for (uint256 i = 0; i < _deedIds.length; i++) {
2113             uint256 _deedId = _deedIds[i];
2114         
2115             setPlotData(_deedId, name, description, imageUrl, infoUrl);
2116         }
2117     }
2118     
2119     /// @notice Withdraw Ether owed to the sender.
2120     function withdrawBalance() external {
2121         uint256 etherOwed = addressToEtherOwed[msg.sender];
2122         
2123         // Ensure Ether is owed to the sender.
2124         require(etherOwed > 0);
2125          
2126         // Set Ether owed to 0.
2127         delete addressToEtherOwed[msg.sender];
2128         
2129         // Subtract from total outstanding balance. etherOwed is guaranteed
2130         // to be less than or equal to outstandingEther, so this cannot
2131         // underflow.
2132         outstandingEther -= etherOwed;
2133         
2134         // Transfer Ether owed to the sender (not susceptible to re-entry
2135         // attack, as the Ether owed is set to 0 before the transfer takes place).
2136         msg.sender.transfer(etherOwed);
2137     }
2138     
2139     /// @notice Withdraw (unowed) contract balance.
2140     function withdrawFreeBalance() external onlyCFO {
2141         // Calculate the free (unowed) balance. This never underflows, as
2142         // outstandingEther is guaranteed to be less than or equal to the
2143         // contract balance.
2144         uint256 freeBalance = this.balance - outstandingEther;
2145         
2146         cfoAddress.transfer(freeBalance);
2147     }
2148 }