1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title Claimable
94  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable is Ownable {
98   address public pendingOwner;
99 
100   /**
101    * @dev Modifier throws if called by any account other than the pendingOwner.
102    */
103   modifier onlyPendingOwner() {
104     require(msg.sender == pendingOwner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to set the pendingOwner address.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner public {
113     pendingOwner = newOwner;
114   }
115 
116   /**
117    * @dev Allows the pendingOwner address to finalize the transfer.
118    */
119   function claimOwnership() onlyPendingOwner public {
120     OwnershipTransferred(owner, pendingOwner);
121     owner = pendingOwner;
122     pendingOwner = address(0);
123   }
124 }
125 
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     Unpause();
168   }
169 }
170 
171 
172 /**
173  * @title ERC20Basic
174  * @dev Simpler version of ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/179
176  */
177 contract ERC20Basic {
178   function totalSupply() public view returns (uint256);
179   function balanceOf(address who) public view returns (uint256);
180   function transfer(address to, uint256 value) public returns (bool);
181   event Transfer(address indexed from, address indexed to, uint256 value);
182 }
183 
184 
185 /**
186  * @title ERC20 interface
187  * @dev see https://github.com/ethereum/EIPs/issues/20
188  */
189 contract ERC20 is ERC20Basic {
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 
197 /**
198  * @title SafeERC20
199  * @dev Wrappers around ERC20 operations that throw on failure.
200  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
201  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
202  */
203 library SafeERC20 {
204   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205     assert(token.transfer(to, value));
206   }
207 
208   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209     assert(token.transferFrom(from, to, value));
210   }
211 
212   function safeApprove(ERC20 token, address spender, uint256 value) internal {
213     assert(token.approve(spender, value));
214   }
215 }
216 
217 
218 /**
219  * @title Contracts that should be able to recover tokens
220  * @author SylTi
221  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
222  * This will prevent any accidental loss of tokens.
223  */
224 contract CanReclaimToken is Ownable {
225   using SafeERC20 for ERC20Basic;
226 
227   /**
228    * @dev Reclaim all ERC20Basic compatible tokens
229    * @param token ERC20Basic The address of the token contract
230    */
231   function reclaimToken(ERC20Basic token) external onlyOwner {
232     uint256 balance = token.balanceOf(this);
233     token.safeTransfer(owner, balance);
234   }
235 
236 }
237 
238 
239 /// @dev Implements access control to the MetaGame contract.
240 contract MetaGameAccessControl is Claimable, Pausable, CanReclaimToken {
241     address public cfoAddress;
242     
243     function MetaGameAccessControl() public {
244         // The creator of the contract is the initial CFO.
245         cfoAddress = msg.sender;
246     }
247     
248     /// @dev Access modifier for CFO-only functionality.
249     modifier onlyCFO() {
250         require(msg.sender == cfoAddress);
251         _;
252     }
253 
254     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
255     /// @param _newCFO The address of the new CFO.
256     function setCFO(address _newCFO) external onlyOwner {
257         require(_newCFO != address(0));
258 
259         cfoAddress = _newCFO;
260     }
261 }
262 
263 
264 /// @dev Defines base data structures for MetaGame.
265 contract MetaGameBase is MetaGameAccessControl {
266     using SafeMath for uint256;
267     
268     mapping (uint256 => address) identifierToOwner;
269     mapping (uint256 => address) identifierToApproved;
270     mapping (address => uint256) ownershipDeedCount;
271     
272     mapping (uint256 => uint256) identifierToParentIdentifier;
273     
274     /// @dev All existing identifiers.
275     uint256[] public identifiers;
276     
277     /// @notice Get all minted identifiers;
278     function getAllIdentifiers() external view returns(uint256[]) {
279         return identifiers;
280     }
281     
282     /// @notice Returns the identifier of the parent of an identifier.
283     /// The parent identifier is 0 if the identifier has no parent.
284     /// @param identifier The identifier to get the parent identifier of.
285     function parentOf(uint256 identifier) external view returns (uint256 parentIdentifier) {
286         parentIdentifier = identifierToParentIdentifier[identifier];
287     }
288 }
289 
290 
291 /// @title Interface for contracts conforming to ERC-721: Deed Standard
292 /// @author William Entriken (https://phor.net), et al.
293 /// @dev Specification at https://github.com/ethereum/EIPs/pull/841 (DRAFT)
294 interface ERC721 {
295 
296     // COMPLIANCE WITH ERC-165 (DRAFT) /////////////////////////////////////////
297 
298     /// @dev ERC-165 (draft) interface signature for itself
299     // bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
300     //     bytes4(keccak256('supportsInterface(bytes4)'));
301 
302     /// @dev ERC-165 (draft) interface signature for ERC721
303     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
304     //     bytes4(keccak256('ownerOf(uint256)')) ^
305     //     bytes4(keccak256('countOfDeeds()')) ^
306     //     bytes4(keccak256('countOfDeedsByOwner(address)')) ^
307     //     bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
308     //     bytes4(keccak256('approve(address,uint256)')) ^
309     //     bytes4(keccak256('takeOwnership(uint256)'));
310 
311     /// @notice Query a contract to see if it supports a certain interface
312     /// @dev Returns `true` the interface is supported and `false` otherwise,
313     ///  returns `true` for INTERFACE_SIGNATURE_ERC165 and
314     ///  INTERFACE_SIGNATURE_ERC721, see ERC-165 for other interface signatures.
315     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
316 
317     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
318 
319     /// @notice Find the owner of a deed
320     /// @param _deedId The identifier for a deed we are inspecting
321     /// @dev Deeds assigned to zero address are considered destroyed, and
322     ///  queries about them do throw.
323     /// @return The non-zero address of the owner of deed `_deedId`, or `throw`
324     ///  if deed `_deedId` is not tracked by this contract
325     function ownerOf(uint256 _deedId) external view returns (address _owner);
326 
327     /// @notice Count deeds tracked by this contract
328     /// @return A count of the deeds tracked by this contract, where each one of
329     ///  them has an assigned and queryable owner
330     function countOfDeeds() public view returns (uint256 _count);
331 
332     /// @notice Count all deeds assigned to an owner
333     /// @dev Throws if `_owner` is the zero address, representing destroyed deeds.
334     /// @param _owner An address where we are interested in deeds owned by them
335     /// @return The number of deeds owned by `_owner`, possibly zero
336     function countOfDeedsByOwner(address _owner) public view returns (uint256 _count);
337 
338     /// @notice Enumerate deeds assigned to an owner
339     /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
340     ///  `_owner` is the zero address, representing destroyed deeds.
341     /// @param _owner An address where we are interested in deeds owned by them
342     /// @param _index A counter between zero and `countOfDeedsByOwner(_owner)`,
343     ///  inclusive
344     /// @return The identifier for the `_index`th deed assigned to `_owner`,
345     ///   (sort order not specified)
346     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
347 
348     // TRANSFER MECHANISM //////////////////////////////////////////////////////
349 
350     /// @dev This event emits when ownership of any deed changes by any
351     ///  mechanism. This event emits when deeds are created (`from` == 0) and
352     ///  destroyed (`to` == 0). Exception: during contract creation, any
353     ///  transfers may occur without emitting `Transfer`.
354     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
355 
356     /// @dev This event emits on any successful call to
357     ///  `approve(address _spender, uint256 _deedId)`. Exception: does not emit
358     ///  if an owner revokes approval (`_to` == 0x0) on a deed with no existing
359     ///  approval.
360     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
361 
362     /// @notice Approve a new owner to take your deed, or revoke approval by
363     ///  setting the zero address. You may `approve` any number of times while
364     ///  the deed is assigned to you, only the most recent approval matters.
365     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if `_to` ==
366     ///  `msg.sender`.
367     /// @param _deedId The deed you are granting ownership of
368     function approve(address _to, uint256 _deedId) external;
369 
370     /// @notice Become owner of a deed for which you are currently approved
371     /// @dev Throws if `msg.sender` is not approved to become the owner of
372     ///  `deedId` or if `msg.sender` currently owns `_deedId`.
373     /// @param _deedId The deed that is being transferred
374     function takeOwnership(uint256 _deedId) external;
375     
376     // SPEC EXTENSIONS /////////////////////////////////////////////////////////
377     
378     /// @notice Transfer a deed to a new owner.
379     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if
380     ///  `_to` == 0x0.
381     /// @param _to The address of the new owner.
382     /// @param _deedId The deed you are transferring.
383     function transfer(address _to, uint256 _deedId) external;
384 }
385 
386 
387 /// @title Metadata extension to ERC-721 interface
388 /// @author William Entriken (https://phor.net)
389 /// @dev Specification at https://github.com/ethereum/EIPs/pull/841 (DRAFT)
390 interface ERC721Metadata {
391 
392     /// @dev ERC-165 (draft) interface signature for ERC721
393     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
394     //     bytes4(keccak256('name()')) ^
395     //     bytes4(keccak256('symbol()')) ^
396     //     bytes4(keccak256('deedUri(uint256)'));
397 
398     /// @notice A descriptive name for a collection of deeds managed by this
399     ///  contract
400     /// @dev Wallets and exchanges MAY display this to the end user.
401     function name() public pure returns (string _deedName);
402 
403     /// @notice An abbreviated name for deeds managed by this contract
404     /// @dev Wallets and exchanges MAY display this to the end user.
405     function symbol() public pure returns (string _deedSymbol);
406 
407     /// @notice A distinct URI (RFC 3986) for a given token.
408     /// @dev If:
409     ///  * The URI is a URL
410     ///  * The URL is accessible
411     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
412     ///  * The JSON base element is an object
413     ///  then these names of the base element SHALL have special meaning:
414     ///  * "name": A string identifying the item to which `_deedId` grants
415     ///    ownership
416     ///  * "description": A string detailing the item to which `_deedId` grants
417     ///    ownership
418     ///  * "image": A URI pointing to a file of image/* mime type representing
419     ///    the item to which `_deedId` grants ownership
420     ///  Wallets and exchanges MAY display this to the end user.
421     ///  Consider making any images at a width between 320 and 1080 pixels and
422     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
423     function deedUri(uint256 _deedId) external pure returns (string _uri);
424 }
425 
426 
427 /// @dev Holds deed functionality such as approving and transferring. Implements ERC721.
428 contract MetaGameDeed is MetaGameBase, ERC721, ERC721Metadata {
429     
430     /// @notice Name of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
431     function name() public pure returns (string _deedName) {
432         _deedName = "MetaGame";
433     }
434     
435     /// @notice Symbol of the collection of deeds (non-fungible token), as defined in ERC721Metadata.
436     function symbol() public pure returns (string _deedSymbol) {
437         _deedSymbol = "MG";
438     }
439     
440     /// @dev ERC-165 (draft) interface signature for itself
441     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
442         bytes4(keccak256('supportsInterface(bytes4)'));
443 
444     /// @dev ERC-165 (draft) interface signature for ERC721
445     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
446         bytes4(keccak256('ownerOf(uint256)')) ^
447         bytes4(keccak256('countOfDeeds()')) ^
448         bytes4(keccak256('countOfDeedsByOwner(address)')) ^
449         bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
450         bytes4(keccak256('approve(address,uint256)')) ^
451         bytes4(keccak256('takeOwnership(uint256)'));
452         
453     /// @dev ERC-165 (draft) interface signature for ERC721
454     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = // 0x2a786f11
455         bytes4(keccak256('name()')) ^
456         bytes4(keccak256('symbol()')) ^
457         bytes4(keccak256('deedUri(uint256)'));
458     
459     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
460     /// Returns true for any standardized interfaces implemented by this contract.
461     /// (ERC-165 and ERC-721.)
462     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
463         return (
464             (_interfaceID == INTERFACE_SIGNATURE_ERC165)
465             || (_interfaceID == INTERFACE_SIGNATURE_ERC721)
466             || (_interfaceID == INTERFACE_SIGNATURE_ERC721Metadata)
467         );
468     }
469     
470     /// @dev Checks if a given address owns a particular deed.
471     /// @param _owner The address of the owner to check for.
472     /// @param _deedId The deed identifier to check for.
473     function _owns(address _owner, uint256 _deedId) internal view returns (bool) {
474         return identifierToOwner[_deedId] == _owner;
475     }
476     
477     /// @dev Approve a given address to take ownership of a deed.
478     /// @param _from The address approving taking ownership.
479     /// @param _to The address to approve taking ownership.
480     /// @param _deedId The identifier of the deed to give approval for.
481     function _approve(address _from, address _to, uint256 _deedId) internal {
482         identifierToApproved[_deedId] = _to;
483         
484         // Emit event.
485         Approval(_from, _to, _deedId);
486     }
487     
488     /// @dev Checks if a given address has approval to take ownership of a deed.
489     /// @param _claimant The address of the claimant to check for.
490     /// @param _deedId The identifier of the deed to check for.
491     function _approvedFor(address _claimant, uint256 _deedId) internal view returns (bool) {
492         return identifierToApproved[_deedId] == _claimant;
493     }
494     
495     /// @dev Assigns ownership of a specific deed to an address.
496     /// @param _from The address to transfer the deed from.
497     /// @param _to The address to transfer the deed to.
498     /// @param _deedId The identifier of the deed to transfer.
499     function _transfer(address _from, address _to, uint256 _deedId) internal {
500         // The number of deeds is capped at rows * cols, so this cannot
501         // be overflowed if those parameters are sensible.
502         ownershipDeedCount[_to]++;
503         
504         // Transfer ownership.
505         identifierToOwner[_deedId] = _to;
506         
507         // When a new deed is minted, the _from address is 0x0, but we
508         // do not track deed ownership of 0x0.
509         if (_from != address(0)) {
510             ownershipDeedCount[_from]--;
511             
512             // Clear taking ownership approval.
513             delete identifierToApproved[_deedId];
514         }
515         
516         // Emit the transfer event.
517         Transfer(_from, _to, _deedId);
518     }
519     
520     // ERC 721 implementation
521     
522     /// @notice Returns the total number of deeds currently in existence.
523     /// @dev Required for ERC-721 compliance.
524     function countOfDeeds() public view returns (uint256) {
525         return identifiers.length;
526     }
527     
528     /// @notice Returns the number of deeds owned by a specific address.
529     /// @param _owner The owner address to check.
530     /// @dev Required for ERC-721 compliance
531     function countOfDeedsByOwner(address _owner) public view returns (uint256) {
532         return ownershipDeedCount[_owner];
533     }
534     
535     /// @notice Returns the address currently assigned ownership of a given deed.
536     /// @dev Required for ERC-721 compliance.
537     function ownerOf(uint256 _deedId) external view returns (address _owner) {
538         _owner = identifierToOwner[_deedId];
539 
540         require(_owner != address(0));
541     }
542     
543     /// @notice Approve a given address to take ownership of a deed.
544     /// @param _to The address to approve taking owernship.
545     /// @param _deedId The identifier of the deed to give approval for.
546     /// @dev Required for ERC-721 compliance.
547     function approve(address _to, uint256 _deedId) external whenNotPaused {
548         uint256[] memory _deedIds = new uint256[](1);
549         _deedIds[0] = _deedId;
550         
551         approveMultiple(_to, _deedIds);
552     }
553     
554     /// @notice Approve a given address to take ownership of multiple deeds.
555     /// @param _to The address to approve taking ownership.
556     /// @param _deedIds The identifiers of the deeds to give approval for.
557     function approveMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
558         // Ensure the sender is not approving themselves.
559         require(msg.sender != _to);
560     
561         for (uint256 i = 0; i < _deedIds.length; i++) {
562             uint256 _deedId = _deedIds[i];
563             
564             // Require the sender is the owner of the deed.
565             require(_owns(msg.sender, _deedId));
566             
567             // Perform the approval.
568             _approve(msg.sender, _to, _deedId);
569         }
570     }
571     
572     /// @notice Transfer a deed to another address. If transferring to a smart
573     /// contract be VERY CAREFUL to ensure that it is aware of ERC-721, or your
574     /// deed may be lost forever.
575     /// @param _to The address of the recipient, can be a user or contract.
576     /// @param _deedId The identifier of the deed to transfer.
577     /// @dev Required for ERC-721 compliance.
578     function transfer(address _to, uint256 _deedId) external whenNotPaused {
579         uint256[] memory _deedIds = new uint256[](1);
580         _deedIds[0] = _deedId;
581         
582         transferMultiple(_to, _deedIds);
583     }
584     
585     /// @notice Transfers multiple deeds to another address. If transferring to
586     /// a smart contract be VERY CAREFUL to ensure that it is aware of ERC-721,
587     /// or your deeds may be lost forever.
588     /// @param _to The address of the recipient, can be a user or contract.
589     /// @param _deedIds The identifiers of the deeds to transfer.
590     function transferMultiple(address _to, uint256[] _deedIds) public whenNotPaused {
591         // Safety check to prevent against an unexpected 0x0 default.
592         require(_to != address(0));
593         
594         // Disallow transfers to this contract to prevent accidental misuse.
595         require(_to != address(this));
596     
597         for (uint256 i = 0; i < _deedIds.length; i++) {
598             uint256 _deedId = _deedIds[i];
599             
600             // One can only transfer their own deeds.
601             require(_owns(msg.sender, _deedId));
602 
603             // Transfer ownership
604             _transfer(msg.sender, _to, _deedId);
605         }
606     }
607     
608     /// @notice Transfer a deed owned by another address, for which the calling
609     /// address has previously been granted transfer approval by the owner.
610     /// @param _deedId The identifier of the deed to be transferred.
611     /// @dev Required for ERC-721 compliance.
612     function takeOwnership(uint256 _deedId) external whenNotPaused {
613         uint256[] memory _deedIds = new uint256[](1);
614         _deedIds[0] = _deedId;
615         
616         takeOwnershipMultiple(_deedIds);
617     }
618     
619     /// @notice Transfer multiple deeds owned by another address, for which the
620     /// calling address has previously been granted transfer approval by the owner.
621     /// @param _deedIds The identifier of the deed to be transferred.
622     function takeOwnershipMultiple(uint256[] _deedIds) public whenNotPaused {
623         for (uint256 i = 0; i < _deedIds.length; i++) {
624             uint256 _deedId = _deedIds[i];
625             address _from = identifierToOwner[_deedId];
626             
627             // Check for transfer approval
628             require(_approvedFor(msg.sender, _deedId));
629 
630             // Reassign ownership (also clears pending approvals and emits Transfer event).
631             _transfer(_from, msg.sender, _deedId);
632         }
633     }
634     
635     /// @notice Returns a list of all deed identifiers assigned to an address.
636     /// @param _owner The owner whose deeds we are interested in.
637     /// @dev This method MUST NEVER be called by smart contract code. It's very
638     /// expensive and is not supported in contract-to-contract calls as it returns
639     /// a dynamic array (only supported for web3 calls).
640     function deedsOfOwner(address _owner) external view returns(uint256[]) {
641         uint256 deedCount = countOfDeedsByOwner(_owner);
642 
643         if (deedCount == 0) {
644             // Return an empty array.
645             return new uint256[](0);
646         } else {
647             uint256[] memory result = new uint256[](deedCount);
648             uint256 totalDeeds = countOfDeeds();
649             uint256 resultIndex = 0;
650             
651             for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
652                 uint256 identifier = identifiers[deedNumber];
653                 if (identifierToOwner[identifier] == _owner) {
654                     result[resultIndex] = identifier;
655                     resultIndex++;
656                 }
657             }
658 
659             return result;
660         }
661     }
662     
663     /// @notice Returns a deed identifier of the owner at the given index.
664     /// @param _owner The address of the owner we want to get a deed for.
665     /// @param _index The index of the deed we want.
666     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
667         // The index should be valid.
668         require(_index < countOfDeedsByOwner(_owner));
669 
670         // Loop through all deeds, accounting the number of deeds of the owner we've seen.
671         uint256 seen = 0;
672         uint256 totalDeeds = countOfDeeds();
673         
674         for (uint256 deedNumber = 0; deedNumber < totalDeeds; deedNumber++) {
675             uint256 identifier = identifiers[deedNumber];
676             if (identifierToOwner[identifier] == _owner) {
677                 if (seen == _index) {
678                     return identifier;
679                 }
680                 
681                 seen++;
682             }
683         }
684     }
685     
686     /// @notice Returns an (off-chain) metadata url for the given deed.
687     /// @param _deedId The identifier of the deed to get the metadata
688     /// url for.
689     /// @dev Implementation of optional ERC-721 functionality.
690     function deedUri(uint256 _deedId) external pure returns (string uri) {
691         // Assume a maximum deed id length.
692         require (_deedId < 1000000);
693         
694         uri = "https://meta.quazr.io/card/xxxxxxx";
695         bytes memory _uri = bytes(uri);
696         
697         for (uint256 i = 0; i < 7; i++) {
698             _uri[33 - i] = byte(48 + (_deedId / 10 ** i) % 10);
699         }
700     }
701 }
702 
703 
704 /**
705  * @title PullPayment
706  * @dev Base contract supporting async send for pull payments. Inherit from this
707  * contract and use asyncSend instead of send.
708  */
709 contract PullPayment {
710   using SafeMath for uint256;
711 
712   mapping(address => uint256) public payments;
713   uint256 public totalPayments;
714 
715   /**
716   * @dev withdraw accumulated balance, called by payee.
717   */
718   function withdrawPayments() public {
719     address payee = msg.sender;
720     uint256 payment = payments[payee];
721 
722     require(payment != 0);
723     require(this.balance >= payment);
724 
725     totalPayments = totalPayments.sub(payment);
726     payments[payee] = 0;
727 
728     assert(payee.send(payment));
729   }
730 
731   /**
732   * @dev Called by the payer to store the sent amount as credit to be pulled.
733   * @param dest The destination address of the funds.
734   * @param amount The amount to transfer.
735   */
736   function asyncSend(address dest, uint256 amount) internal {
737     payments[dest] = payments[dest].add(amount);
738     totalPayments = totalPayments.add(amount);
739   }
740 }
741 
742 
743 /// @dev Defines base data structures for MetaGame.
744 contract MetaGameFinance is MetaGameDeed, PullPayment {
745     /// @notice The dividend given to all parents of a deed, 
746     /// in 1/1000th of a percentage.
747     uint256 public dividendParentsPercentage = 1000;
748     
749     /// @notice The minimum fee for the contract in 1/1000th
750     /// of a percentage.
751     uint256 public minimumFeePercentage = 2500;
752     
753     /// @notice The minimum total paid in fees and dividends.
754     /// If there are (almost) no dividends to be paid, the fee
755     /// for the contract is higher. This happens for deeds at
756     /// or near the top of the hierarchy. In 1/1000th of a
757     /// percentage.
758     uint256 public minimumFeePlusDividendsPercentage = 8000;
759     
760     /// @notice Most-recent card buyers. These will be given
761     /// dividends on the next sale. Then, the buyers will be
762     /// shifted, the least recent buyer dropped, and the buyer
763     /// of this sale is added as the most recent buyer.
764     address[] public recentBuyers = new address[](6);
765     
766     /// @notice The dividend given to the most recent buyers,
767     /// in 1/1000th of a percentage. The dividend decreases by
768     /// the given factor for subsequent levels of recent buyers.
769     uint256 public dividendRecentBuyersPercentage = 1000;
770     uint256 public dividendRecentBuyersPercentageDecreaseFactor = 2;
771     
772     // @dev A mapping from deed identifiers to the buyout price.
773     mapping (uint256 => uint256) public identifierToPrice;
774     
775     /// @notice The threshold for a payment to be sent directly,
776     /// instead of added to a beneficiary's balance.
777     uint256 public directPaymentThreshold = 0 ether;
778     
779     /// @notice Boolean indicating whether deed price can be changed
780     /// manually.
781     bool public allowChangePrice = false;
782     
783     /// @notice The maximum depth for which dividends will be paid to parents.
784     uint256 public maxDividendDepth = 6;
785     
786     /// @dev This event is emitted when a deed's buyout price is initially set or changed.
787     event Price(uint256 indexed identifier, uint256 price, uint256 nextPrice);
788     
789     /// @dev This event is emitted when a deed is bought out.
790     event Buy(address indexed oldOwner, address indexed newOwner, uint256 indexed identifier, uint256 price, uint256 ownerWinnings);
791     
792     /// @dev This event is emitted when a dividend is paid.
793     event DividendPaid(address indexed beneficiary, uint256 indexed identifierBought, uint256 indexed identifier, uint256 dividend);
794     
795     /// @notice Set the threshold for a payment to be sent directly.
796     /// @param threshold The threshold for a payment to be sent directly.
797     function setDirectPaymentThreshold(uint256 threshold) external onlyCFO {
798         directPaymentThreshold = threshold;
799     }
800     
801     /// @notice Set whether prices can be changed manually.
802     /// @param _allowChangePrice Bool indiciating wether prices can be changed manually.
803     function setAllowChangePrice(bool _allowChangePrice) external onlyCFO {
804         allowChangePrice = _allowChangePrice;
805     }
806     
807     /// @notice Set the maximum dividend depth.
808     /// @param _maxDividendDepth The maximum dividend depth.
809     function setMaxDividendDepth(uint256 _maxDividendDepth) external onlyCFO {
810         maxDividendDepth = _maxDividendDepth;
811     }
812     
813     /// @notice Calculate the next price given the current price.
814     /// @param currentPrice The current price.
815     function nextPrice(uint256 currentPrice) public pure returns(uint256) {
816         if (currentPrice < 1 ether) {
817             return currentPrice.mul(200).div(100); // 100% increase
818         } else if (currentPrice < 5 ether) {
819             return currentPrice.mul(150).div(100); // 50% increase
820         } else {
821             return currentPrice.mul(135).div(100); // 35% increase
822         }
823     }
824     
825     /// @notice Set the price of a deed.
826     /// @param identifier The identifier of the deed to change the price of.
827     /// @param newPrice The new price of the deed.
828     function changeDeedPrice(uint256 identifier, uint256 newPrice) public {
829         // The message sender must be the deed owner.
830         require(identifierToOwner[identifier] == msg.sender);
831         
832         // Price changes must be enabled.
833         require(allowChangePrice);
834         
835         // The new price must be lower than the current price.
836         require(newPrice < identifierToPrice[identifier]);
837         
838         // Set the new price.
839         identifierToPrice[identifier] = newPrice;
840         Price(identifier, newPrice, nextPrice(newPrice));
841     }
842     
843     /// @notice Set the initial price of a deed.
844     /// @param identifier The identifier of the deed to change the price of.
845     /// @param newPrice The new price of the deed.
846     function changeInitialPrice(uint256 identifier, uint256 newPrice) public onlyCFO {        
847         // The deed must be owned by the contract.
848         require(identifierToOwner[identifier] == address(this));
849         
850         // Set the new price.
851         identifierToPrice[identifier] = newPrice;
852         Price(identifier, newPrice, nextPrice(newPrice));
853     }
854     
855     /// @dev Pay dividends to parents of a deed.
856     /// @param identifierBought The identifier of the deed that was bought.
857     /// @param identifier The identifier of the deed to pay its parents dividends for (recursed).
858     /// @param dividend The dividend to be paid to parents of the deed.
859     /// @param depth The depth of this dividend.
860     function _payParentDividends(uint256 identifierBought, uint256 identifier, uint256 dividend, uint256 depth)
861         internal
862         returns(uint256 totalDividendsPaid)
863     {
864         uint256 parentIdentifier = identifierToParentIdentifier[identifier];
865         
866         if (parentIdentifier != 0 && depth < maxDividendDepth) {
867             address parentOwner = identifierToOwner[parentIdentifier];
868         
869             if (parentOwner != address(this)) {            
870                 // Send dividend to the owner of the parent.
871                 _sendFunds(parentOwner, dividend);
872                 DividendPaid(parentOwner, identifierBought, parentIdentifier, dividend);
873             }
874             
875             totalDividendsPaid = dividend;
876         
877             // Recursively pay dividends to parents of parents.
878             uint256 dividendsPaid = _payParentDividends(identifierBought, parentIdentifier, dividend, depth + 1);
879             
880             totalDividendsPaid = totalDividendsPaid.add(dividendsPaid);
881         } else {
882             // Not strictly necessary to set this to 0 explicitly... but makes
883             // it clearer to see what happens.
884             totalDividendsPaid = 0;
885         }
886     }
887     
888     /// @dev Pay dividends to recent buyers.
889     /// @param price The price of the card that was bought.
890     function _payRecentBuyerDividends(uint256 price)
891         internal
892         returns(uint256 totalDividendsPaid)
893     {
894         uint256 dividend = price.mul(dividendRecentBuyersPercentage).div(100000);
895         
896         // Pay first dividend.
897         if (recentBuyers[0] != 0x0) {
898             _sendFunds(recentBuyers[0], dividend);
899         }
900         totalDividendsPaid = dividend;
901         
902         // Pay second dividend.
903         dividend = dividend.div(dividendRecentBuyersPercentageDecreaseFactor);
904         if (recentBuyers[1] != 0x0) {
905             _sendFunds(recentBuyers[1], dividend);
906         }
907         totalDividendsPaid = totalDividendsPaid.add(dividend);
908         
909         // Pay third dividend.
910         dividend = dividend.div(dividendRecentBuyersPercentageDecreaseFactor);
911         if (recentBuyers[2] != 0x0) {
912             _sendFunds(recentBuyers[2], dividend);
913         }
914         totalDividendsPaid = totalDividendsPaid.add(dividend);
915         
916         // Pay fourth dividend.
917         dividend = dividend.div(dividendRecentBuyersPercentageDecreaseFactor);
918         if (recentBuyers[3] != 0x0) {
919             _sendFunds(recentBuyers[3], dividend);
920         }
921         totalDividendsPaid = totalDividendsPaid.add(dividend);
922         
923         // Pay fifth dividend.
924         dividend = dividend.div(dividendRecentBuyersPercentageDecreaseFactor);
925         if (recentBuyers[4] != 0x0) {
926             _sendFunds(recentBuyers[4], dividend);
927         }
928         totalDividendsPaid = totalDividendsPaid.add(dividend);
929         
930         // Pay sixth dividend.
931         dividend = dividend.div(dividendRecentBuyersPercentageDecreaseFactor);
932         if (recentBuyers[5] != 0x0) {
933             _sendFunds(recentBuyers[5], dividend);
934         }
935         totalDividendsPaid = totalDividendsPaid.add(dividend);
936     }
937     
938     /// @dev Pay trade dividends.
939     /// @param price The identifier of the card that was bought.
940     /// @param price The price of the card that was bought.
941     function _payDividends(uint256 identifier, uint256 price)
942         internal
943         returns(uint256 totalDividendsPaid)
944     {
945         // Pay parent dividends.
946         uint256 parentDividend = price.mul(dividendParentsPercentage).div(100000);
947         totalDividendsPaid = _payParentDividends(identifier, identifier, parentDividend, 0);
948         
949         // Pay recent buyer dividends.
950         totalDividendsPaid = totalDividendsPaid.add(_payRecentBuyerDividends(price));
951     }
952     
953     /// @dev Calculate the contract fee.
954     /// @param price The price of the buyout.
955     /// @param dividendsPaid The total amount paid in dividends.
956     function calculateFee(uint256 price, uint256 dividendsPaid) public view returns(uint256 fee) {
957         // Calculate the absolute minimum fee.
958         fee = price.mul(minimumFeePercentage).div(100000);
959         
960         // Calculate the minimum fee plus dividends payable.
961         // See also the explanation at the definition of
962         // minimumFeePlusDividends.
963         uint256 _minimumFeePlusDividends = price.mul(minimumFeePlusDividendsPercentage).div(100000);
964         
965         if (_minimumFeePlusDividends > dividendsPaid) {
966             uint256 feeMinusDividends = _minimumFeePlusDividends.sub(dividendsPaid);
967         
968             // The minimum total paid in 'fees plus dividends', minus dividends, is
969             // greater than the minimum fee. Set the fee to this value.
970             if (feeMinusDividends > fee) {
971                 fee = feeMinusDividends;
972             }
973         }
974     }
975     
976     /// @dev Shift the 6 most recent buyers, and add the new buyer
977     /// to the front.
978     /// @param newBuyer The buyer to add to the front of the recent
979     /// buyers list.
980     function _shiftRecentBuyers(address newBuyer) internal {
981         recentBuyers[5] = recentBuyers[4];
982         recentBuyers[4] = recentBuyers[3];
983         recentBuyers[3] = recentBuyers[2];
984         recentBuyers[2] = recentBuyers[1];
985         recentBuyers[1] = recentBuyers[0];
986         recentBuyers[0] = newBuyer;
987     }
988     
989     /// @dev Send funds to a beneficiary. If sending fails, assign
990     /// funds to the beneficiary's balance for manual withdrawal.
991     /// @param beneficiary The beneficiary's address to send funds to
992     /// @param amount The amount to send.
993     function _sendFunds(address beneficiary, uint256 amount) internal {
994         if (amount < directPaymentThreshold) {
995             // Amount is under send threshold. Send funds asynchronously
996             // for manual withdrawal by the beneficiary.
997             asyncSend(beneficiary, amount);
998         } else if (!beneficiary.send(amount)) {
999             // Failed to send funds. This can happen due to a failure in
1000             // fallback code of the beneficiary, or because of callstack
1001             // depth.
1002             // Send funds asynchronously for manual withdrawal by the
1003             // beneficiary.
1004             asyncSend(beneficiary, amount);
1005         }
1006     }
1007     
1008     /// @notice Withdraw (unowed) contract balance.
1009     function withdrawFreeBalance() external onlyCFO {
1010         // Calculate the free (unowed) balance. This never underflows, as
1011         // totalPayments is guaranteed to be less than or equal to the
1012         // contract balance.
1013         uint256 freeBalance = this.balance - totalPayments;
1014         
1015         cfoAddress.transfer(freeBalance);
1016     }
1017 }
1018 
1019 
1020 /// @dev Defines core MetaGame functionality.
1021 contract MetaGameCore is MetaGameFinance {
1022     
1023     function MetaGameCore() public {
1024         // Start the contract paused.
1025         paused = true;
1026     }
1027     
1028     /// @notice Create a collectible.
1029     /// @param identifier The identifier of the collectible that is to be created.
1030     /// @param owner The address of the initial owner. Blank if this contract should
1031     /// be the initial owner.
1032     /// @param parentIdentifier The identifier of the parent of the collectible, which
1033     /// receives dividends when this collectible trades.
1034     /// @param price The initial price of the collectible.
1035     function createCollectible(uint256 identifier, address owner, uint256 parentIdentifier, uint256 price) external onlyCFO {
1036         // The identifier must be valid. Identifier 0 is reserved
1037         // to mark a collectible as having no parent.
1038         require(identifier >= 1);
1039     
1040         // The identifier must not exist yet.
1041         require(identifierToOwner[identifier] == 0x0);
1042         
1043         // Add the identifier to the list of existing identifiers.
1044         identifiers.push(identifier);
1045         
1046         address initialOwner = owner;
1047         
1048         if (initialOwner == 0x0) {
1049             // Set the initial owner to be the contract itself.
1050             initialOwner = address(this);
1051         }
1052         
1053         // Transfer the collectible to the initial owner.
1054         _transfer(0x0, initialOwner, identifier);
1055         
1056         // Set the parent identifier.
1057         identifierToParentIdentifier[identifier] = parentIdentifier;
1058         
1059         // Set the initial price.
1060         identifierToPrice[identifier] = price;
1061         
1062         // Emit price event.
1063         Price(identifier, price, nextPrice(price));
1064     }
1065     
1066     /// @notice Set the parent collectible of a collectible.
1067     function setParent(uint256 identifier, uint256 parentIdentifier) external onlyCFO {
1068         // The deed must exist.
1069         require(identifierToOwner[identifier] != 0x0);
1070         
1071         identifierToParentIdentifier[identifier] = parentIdentifier;
1072     }
1073     
1074     /// @notice Buy a collectible.
1075     function buy(uint256 identifier) external payable whenNotPaused {
1076         // The collectible must exist.
1077         require(identifierToOwner[identifier] != 0x0);
1078         
1079         address oldOwner = identifierToOwner[identifier];
1080         uint256 price = identifierToPrice[identifier];
1081         
1082         // The old owner must not be the same as the buyer.
1083         require(oldOwner != msg.sender);
1084         
1085         // Enough ether must be provided.
1086         require(msg.value >= price);
1087         
1088         // Set the new price.
1089         uint256 newPrice = nextPrice(price);
1090         identifierToPrice[identifier] = newPrice;
1091         
1092         // Transfer the collectible.
1093         _transfer(oldOwner, msg.sender, identifier);
1094         
1095         // Emit price change event.
1096         Price(identifier, newPrice, nextPrice(newPrice));
1097         
1098         // Emit buy event.
1099         Buy(oldOwner, msg.sender, identifier, price, oldOwnerWinnings);
1100         
1101         // Pay dividends.
1102         uint256 dividendsPaid = _payDividends(identifier, price);
1103         
1104         // Calculate the contract fee.
1105         uint256 fee = calculateFee(price, dividendsPaid);
1106         
1107         // Calculate the winnings for the previous owner.
1108         uint256 oldOwnerWinnings = price.sub(dividendsPaid).sub(fee);
1109         
1110         // Add the buyer to the recent buyer list.
1111         _shiftRecentBuyers(msg.sender);
1112         
1113         if (oldOwner != address(this)) {
1114             // The old owner is not this contract itself.
1115             // Pay the old owner.
1116             _sendFunds(oldOwner, oldOwnerWinnings);
1117         }
1118         
1119         // Calculate overspent ether. This cannot underflow, as the require
1120         // guarantees price to be greater than or equal to msg.value.
1121         uint256 excess = msg.value - price;
1122         
1123         if (excess > 0) {
1124             // Refund overspent Ether.
1125             msg.sender.transfer(excess);
1126         }
1127     }
1128     
1129     /// @notice Return a collectible's details.
1130     /// @param identifier The identifier of the collectible to get details for.
1131     function getDeed(uint256 identifier)
1132         external
1133         view
1134         returns(uint256 deedId, address owner, uint256 buyPrice, uint256 nextBuyPrice)
1135     {
1136         deedId = identifier;
1137         owner = identifierToOwner[identifier];
1138         buyPrice = identifierToPrice[identifier];
1139         nextBuyPrice = nextPrice(buyPrice);
1140     }
1141 }