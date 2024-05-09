1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 
45 
46  // Pause functionality taken from OpenZeppelin. License below.
47  /* The MIT License (MIT)
48  Copyright (c) 2016 Smart Contract Solutions, Inc.
49  Permission is hereby granted, free of charge, to any person obtaining
50  a copy of this software and associated documentation files (the
51  "Software"), to deal in the Software without restriction, including
52  without limitation the rights to use, copy, modify, merge, publish,
53  distribute, sublicense, and/or sell copies of the Software, and to
54  permit persons to whom the Software is furnished to do so, subject to
55  the following conditions: */
56 
57  /**
58   * @title Pausable
59   * @dev Base contract which allows children to implement an emergency stop mechanism.
60   */
61 contract Pausable is Ownable {
62 
63   event SetPaused(bool paused);
64 
65   // starts unpaused
66   bool public paused = false;
67 
68   /* @dev modifier to allow actions only when the contract IS paused */
69   modifier whenNotPaused() {
70     require(!paused);
71     _;
72   }
73 
74   /* @dev modifier to allow actions only when the contract IS NOT paused */
75   modifier whenPaused() {
76     require(paused);
77     _;
78   }
79 
80   function pause() public onlyOwner whenNotPaused returns (bool) {
81     paused = true;
82     SetPaused(paused);
83     return true;
84   }
85 
86   function unpause() public onlyOwner whenPaused returns (bool) {
87     paused = false;
88     SetPaused(paused);
89     return true;
90   }
91 }
92 
93 contract EtherbotsPrivileges is Pausable {
94   event ContractUpgrade(address newContract);
95 
96 }
97 
98 // import "./contracts/CratePreSale.sol";
99 // Central collection of storage on which all other contracts depend.
100 // Contains structs for parts, users and functions which control their
101 // transferrence.
102 contract EtherbotsBase is EtherbotsPrivileges {
103 
104 
105     function EtherbotsBase() public {
106     //   scrapyard = address(this);
107     }
108     /*** EVENTS ***/
109 
110     ///  Forge fires when a new part is created - 4 times when a crate is opened,
111     /// and once when a battle takes place. Also has fires when
112     /// parts are combined in the furnace.
113     event Forge(address owner, uint256 partID, Part part);
114 
115     ///  Transfer event as defined in ERC721.
116     event Transfer(address from, address to, uint256 tokenId);
117 
118     /*** DATA TYPES ***/
119     ///  The main struct representation of a robot part. Each robot in Etherbots is represented by four copies
120     ///  of this structure, one for each of the four parts comprising it:
121     /// 1. Right Arm (Melee),
122     /// 2. Left Arm (Defence),
123     /// 3. Head (Turret),
124     /// 4. Body.
125     // store token id on this?
126      struct Part {
127         uint32 tokenId;
128         uint8 partType;
129         uint8 partSubType;
130         uint8 rarity;
131         uint8 element;
132         uint32 battlesLastDay;
133         uint32 experience;
134         uint32 forgeTime;
135         uint32 battlesLastReset;
136     }
137 
138     // Part type - can be shared with other part factories.
139     uint8 constant DEFENCE = 1;
140     uint8 constant MELEE = 2;
141     uint8 constant BODY = 3;
142     uint8 constant TURRET = 4;
143 
144     // Rarity - can be shared with other part factories.
145     uint8 constant STANDARD = 1;
146     uint8 constant SHADOW = 2;
147     uint8 constant GOLD = 3;
148 
149 
150     // Store a user struct
151     // in order to keep track of experience and perk choices.
152     // This perk tree is a binary tree, efficiently encodable as an array.
153     // 0 reflects no perk selected. 1 is first choice. 2 is second. 3 is both.
154     // Each choice costs experience (deducted from user struct).
155 
156     /*** ~~~~~ROBOT PERKS~~~~~ ***/
157     // PERK 1: ATTACK vs DEFENCE PERK CHOICE.
158     // Choose
159     // PERK TWO ATTACK/ SHOOT, or DEFEND/DODGE
160     // PERK 2: MECH vs ELEMENTAL PERK CHOICE ---
161     // Choose steel and electric (Mech path), or water and fire (Elemetal path)
162     // (... will the mechs win the war for Ethertopia? or will the androids
163     // be deluged in flood and fire? ...)
164     // PERK 3: Commit to a specific elemental pathway:
165     // 1. the path of steel: the iron sword; the burning frying pan!
166     // 2. the path of electricity: the deadly taser, the fearsome forcefield
167     // 3. the path of water: high pressure water blasters have never been so cool
168     // 4. the path of fire!: we will hunt you down, Aang...
169 
170 
171     struct User {
172         // address userAddress;
173         uint32 numShards; //limit shards to upper bound eg 10000
174         uint32 experience;
175         uint8[32] perks;
176     }
177 
178     //Maintain an array of all users.
179     // User[] public users;
180 
181     // Store a map of the address to a uint representing index of User within users
182     // we check if a user exists at multiple points, every time they acquire
183     // via a crate or the market. Users can also manually register their address.
184     mapping ( address => User ) public addressToUser;
185 
186     // Array containing the structs of all parts in existence. The ID
187     // of each part is an index into this array.
188     Part[] parts;
189 
190     // Mapping from part IDs to to owning address. Should always exist.
191     mapping (uint256 => address) public partIndexToOwner;
192 
193     //  A mapping from owner address to count of tokens that address owns.
194     //  Used internally inside balanceOf() to resolve ownership count. REMOVE?
195     mapping (address => uint256) addressToTokensOwned;
196 
197     // Mapping from Part ID to an address approved to call transferFrom().
198     // maximum of one approved address for transfer at any time.
199     mapping (uint256 => address) public partIndexToApproved;
200 
201     address auction;
202     // address scrapyard;
203 
204     // Array to store approved battle contracts.
205     // Can only ever be added to, not removed from.
206     // Once a ruleset is published, you will ALWAYS be able to use that contract
207     address[] approvedBattles;
208 
209 
210     function getUserByAddress(address _user) public view returns (uint32, uint8[32]) {
211         return (addressToUser[_user].experience, addressToUser[_user].perks);
212     }
213 
214     //  Transfer a part to an address
215     function _transfer(address _from, address _to, uint256 _tokenId) internal {
216         // No cap on number of parts
217         // Very unlikely to ever be 2^256 parts owned by one account
218         // Shouldn't waste gas checking for overflow
219         // no point making it less than a uint --> mappings don't pack
220         addressToTokensOwned[_to]++;
221         // transfer ownership
222         partIndexToOwner[_tokenId] = _to;
223         // New parts are transferred _from 0x0, but we can't account that address.
224         if (_from != address(0)) {
225             addressToTokensOwned[_from]--;
226             // clear any previously approved ownership exchange
227             delete partIndexToApproved[_tokenId];
228         }
229         // Emit the transfer event.
230         Transfer(_from, _to, _tokenId);
231     }
232 
233     function getPartById(uint _id) external view returns (
234         uint32 tokenId,
235         uint8 partType,
236         uint8 partSubType,
237         uint8 rarity,
238         uint8 element,
239         uint32 battlesLastDay,
240         uint32 experience,
241         uint32 forgeTime,
242         uint32 battlesLastReset
243     ) {
244         Part memory p = parts[_id];
245         return (p.tokenId, p.partType, p.partSubType, p.rarity, p.element, p.battlesLastDay, p.experience, p.forgeTime, p.battlesLastReset);
246     }
247 
248 
249     function substring(string str, uint startIndex, uint endIndex) internal pure returns (string) {
250         bytes memory strBytes = bytes(str);
251         bytes memory result = new bytes(endIndex-startIndex);
252         for (uint i = startIndex; i < endIndex; i++) {
253             result[i-startIndex] = strBytes[i];
254         }
255         return string(result);
256     }
257 
258     // helper functions adapted from  Jossie Calderon on stackexchange
259     function stringToUint32(string s) internal pure returns (uint32) {
260         bytes memory b = bytes(s);
261         uint result = 0;
262         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
263             if (b[i] >= 48 && b[i] <= 57) {
264                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
265             }
266         }
267         return uint32(result);
268     }
269 
270     function stringToUint8(string s) internal pure returns (uint8) {
271         return uint8(stringToUint32(s));
272     }
273 
274     function uintToString(uint v) internal pure returns (string) {
275         uint maxlength = 100;
276         bytes memory reversed = new bytes(maxlength);
277         uint i = 0;
278         while (v != 0) {
279             uint remainder = v % 10;
280             v = v / 10;
281             reversed[i++] = byte(48 + remainder);
282         }
283         bytes memory s = new bytes(i); // i + 1 is inefficient
284         for (uint j = 0; j < i; j++) {
285             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
286         }
287         string memory str = string(s);
288         return str;
289     }
290 }
291 
292 
293 // This contract implements both the original ERC-721 standard and
294 // the proposed 'deed' standard of 841
295 // I don't know which standard will eventually be adopted - support both for now
296 
297 
298 /// @title Interface for contracts conforming to ERC-721: Deed Standard
299 /// @author William Entriken (https://phor.net), et. al.
300 /// @dev Specification at https://github.com/ethereum/eips/841
301 /// can read the comments there
302 contract ERC721 {
303 
304     // COMPLIANCE WITH ERC-165 (DRAFT)
305 
306     /// @dev ERC-165 (draft) interface signature for itself
307     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 =
308         bytes4(keccak256("supportsInterface(bytes4)"));
309 
310     /// @dev ERC-165 (draft) interface signature for ERC721
311     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 =
312          bytes4(keccak256("ownerOf(uint256)")) ^
313          bytes4(keccak256("countOfDeeds()")) ^
314          bytes4(keccak256("countOfDeedsByOwner(address)")) ^
315          bytes4(keccak256("deedOfOwnerByIndex(address,uint256)")) ^
316          bytes4(keccak256("approve(address,uint256)")) ^
317          bytes4(keccak256("takeOwnership(uint256)"));
318 
319     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
320 
321     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
322 
323     function ownerOf(uint256 _deedId) public view returns (address _owner);
324     function countOfDeeds() external view returns (uint256 _count);
325     function countOfDeedsByOwner(address _owner) external view returns (uint256 _count);
326     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
327 
328     // TRANSFER MECHANISM //////////////////////////////////////////////////////
329 
330     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
331     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
332 
333     function approve(address _to, uint256 _deedId) external payable;
334     function takeOwnership(uint256 _deedId) external payable;
335 }
336 
337 /// @title Metadata extension to ERC-721 interface
338 /// @author William Entriken (https://phor.net)
339 /// @dev Specification at https://github.com/ethereum/eips/issues/XXXX
340 contract ERC721Metadata is ERC721 {
341 
342     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata =
343         bytes4(keccak256("name()")) ^
344         bytes4(keccak256("symbol()")) ^
345         bytes4(keccak256("deedUri(uint256)"));
346 
347     function name() public pure returns (string n);
348     function symbol() public pure returns (string s);
349 
350     /// @notice A distinct URI (RFC 3986) for a given token.
351     /// @dev If:
352     ///  * The URI is a URL
353     ///  * The URL is accessible
354     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
355     ///  * The JSON base element is an object
356     ///  then these names of the base element SHALL have special meaning:
357     ///  * "name": A string identifying the item to which `_deedId` grants
358     ///    ownership
359     ///  * "description": A string detailing the item to which `_deedId` grants
360     ///    ownership
361     ///  * "image": A URI pointing to a file of image/* mime type representing
362     ///    the item to which `_deedId` grants ownership
363     ///  Wallets and exchanges MAY display this to the end user.
364     ///  Consider making any images at a width between 320 and 1080 pixels and
365     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
366     function deedUri(uint256 _deedId) external view returns (string _uri);
367 }
368 
369 /// @title Enumeration extension to ERC-721 interface
370 /// @author William Entriken (https://phor.net)
371 /// @dev Specification at https://github.com/ethereum/eips/issues/XXXX
372 contract ERC721Enumerable is ERC721Metadata {
373 
374     /// @dev ERC-165 (draft) interface signature for ERC721
375     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Enumerable =
376         bytes4(keccak256("deedByIndex()")) ^
377         bytes4(keccak256("countOfOwners()")) ^
378         bytes4(keccak256("ownerByIndex(uint256)"));
379 
380     function deedByIndex(uint256 _index) external view returns (uint256 _deedId);
381     function countOfOwners() external view returns (uint256 _count);
382     function ownerByIndex(uint256 _index) external view returns (address _owner);
383 }
384 
385 contract ERC721Original {
386 
387     bytes4 constant INTERFACE_SIGNATURE_ERC721Original =
388         bytes4(keccak256("totalSupply()")) ^
389         bytes4(keccak256("balanceOf(address)")) ^
390         bytes4(keccak256("ownerOf(uint256)")) ^
391         bytes4(keccak256("approve(address,uint256)")) ^
392         bytes4(keccak256("takeOwnership(uint256)")) ^
393         bytes4(keccak256("transfer(address,uint256)"));
394 
395     // Core functions
396     function implementsERC721() public pure returns (bool);
397     function totalSupply() public view returns (uint256 _totalSupply);
398     function balanceOf(address _owner) public view returns (uint256 _balance);
399     function ownerOf(uint _tokenId) public view returns (address _owner);
400     function approve(address _to, uint _tokenId) external payable;
401     function transferFrom(address _from, address _to, uint _tokenId) public;
402     function transfer(address _to, uint _tokenId) public payable;
403 
404     // Optional functions
405     function name() public pure returns (string _name);
406     function symbol() public pure returns (string _symbol);
407     function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint _tokenId);
408     function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
409 
410     // Events
411     // event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
412     // event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
413 }
414 
415 contract ERC721AllImplementations is ERC721Original, ERC721Enumerable {
416 
417 }
418 
419 
420 contract EtherbotsNFT is EtherbotsBase, ERC721Enumerable, ERC721Original {
421     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
422         return (_interfaceID == ERC721Original.INTERFACE_SIGNATURE_ERC721Original) ||
423             (_interfaceID == ERC721.INTERFACE_SIGNATURE_ERC721) ||
424             (_interfaceID == ERC721Metadata.INTERFACE_SIGNATURE_ERC721Metadata) ||
425             (_interfaceID == ERC721Enumerable.INTERFACE_SIGNATURE_ERC721Enumerable);
426     }
427     function implementsERC721() public pure returns (bool) {
428         return true;
429     }
430 
431     function name() public pure returns (string _name) {
432       return "Etherbots";
433     }
434 
435     function symbol() public pure returns (string _smbol) {
436       return "ETHBOT";
437     }
438 
439     // total supply of parts --> as no parts are ever deleted, this is simply
440     // the total supply of parts ever created
441     function totalSupply() public view returns (uint) {
442         return parts.length;
443     }
444 
445     /// @notice Returns the total number of deeds currently in existence.
446     /// @dev Required for ERC-721 compliance.
447     function countOfDeeds() external view returns (uint256) {
448         return parts.length;
449     }
450 
451     //--/ internal function    which checks whether the token with id (_tokenId)
452     /// is owned by the (_claimant) address
453     function owns(address _owner, uint256 _tokenId) public view returns (bool) {
454         return (partIndexToOwner[_tokenId] == _owner);
455     }
456 
457     /// internal function    which checks whether the token with id (_tokenId)
458     /// is owned by the (_claimant) address
459     function ownsAll(address _owner, uint256[] _tokenIds) public view returns (bool) {
460         require(_tokenIds.length > 0);
461         for (uint i = 0; i < _tokenIds.length; i++) {
462             if (partIndexToOwner[_tokenIds[i]] != _owner) {
463                 return false;
464             }
465         }
466         return true;
467     }
468 
469     function _approve(uint256 _tokenId, address _approved) internal {
470         partIndexToApproved[_tokenId] = _approved;
471     }
472 
473     function _approvedFor(address _newOwner, uint256 _tokenId) internal view returns (bool) {
474         return (partIndexToApproved[_tokenId] == _newOwner);
475     }
476 
477     function ownerByIndex(uint256 _index) external view returns (address _owner){
478         return partIndexToOwner[_index];
479     }
480 
481     // returns the NUMBER of tokens owned by (_owner)
482     function balanceOf(address _owner) public view returns (uint256 count) {
483         return addressToTokensOwned[_owner];
484     }
485 
486     function countOfDeedsByOwner(address _owner) external view returns (uint256) {
487         return balanceOf(_owner);
488     }
489 
490     // transfers a part to another account
491     function transfer(address _to, uint256 _tokenId) public whenNotPaused payable {
492         // payable for ERC721 --> don't actually send eth @_@
493         require(msg.value == 0);
494 
495         // Safety checks to prevent accidental transfers to common accounts
496         require(_to != address(0));
497         require(_to != address(this));
498         // can't transfer parts to the auction contract directly
499         require(_to != address(auction));
500         // can't transfer parts to any of the battle contracts directly
501         for (uint j = 0; j < approvedBattles.length; j++) {
502             require(_to != approvedBattles[j]);
503         }
504 
505         // Cannot send tokens you don't own
506         require(owns(msg.sender, _tokenId));
507 
508         // perform state changes necessary for transfer
509         _transfer(msg.sender, _to, _tokenId);
510     }
511     // transfers a part to another account
512 
513     function transferAll(address _to, uint256[] _tokenIds) public whenNotPaused payable {
514         require(msg.value == 0);
515 
516         // Safety checks to prevent accidental transfers to common accounts
517         require(_to != address(0));
518         require(_to != address(this));
519         // can't transfer parts to the auction contract directly
520         require(_to != address(auction));
521         // can't transfer parts to any of the battle contracts directly
522         for (uint j = 0; j < approvedBattles.length; j++) {
523             require(_to != approvedBattles[j]);
524         }
525 
526         // Cannot send tokens you don't own
527         require(ownsAll(msg.sender, _tokenIds));
528 
529         for (uint k = 0; k < _tokenIds.length; k++) {
530             // perform state changes necessary for transfer
531             _transfer(msg.sender, _to, _tokenIds[k]);
532         }
533 
534 
535     }
536 
537 
538     // approves the (_to) address to use the transferFrom function on the token with id (_tokenId)
539     // if you want to clear all approvals, simply pass the zero address
540     function approve(address _to, uint256 _deedId) external whenNotPaused payable {
541         // payable for ERC721 --> don't actually send eth @_@
542         require(msg.value == 0);
543 // use internal function?
544         // Cannot approve the transfer of tokens you don't own
545         require(owns(msg.sender, _deedId));
546 
547         // Store the approval (can only approve one at a time)
548         partIndexToApproved[_deedId] = _to;
549 
550         Approval(msg.sender, _to, _deedId);
551     }
552 
553     // approves many token ids
554     function approveMany(address _to, uint256[] _tokenIds) external whenNotPaused payable {
555 
556         for (uint i = 0; i < _tokenIds.length; i++) {
557             uint _tokenId = _tokenIds[i];
558 
559             // Cannot approve the transfer of tokens you don't own
560             require(owns(msg.sender, _tokenId));
561 
562             // Store the approval (can only approve one at a time)
563             partIndexToApproved[_tokenId] = _to;
564             //create event for each approval? _tokenId guaranteed to hold correct value?
565             Approval(msg.sender, _to, _tokenId);
566         }
567     }
568 
569     // transfer the part with id (_tokenId) from (_from) to (_to)
570     // (_to) must already be approved for this (_tokenId)
571     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
572 
573         // Safety checks to prevent accidents
574         require(_to != address(0));
575         require(_to != address(this));
576 
577         // sender must be approved
578         require(partIndexToApproved[_tokenId] == msg.sender);
579         // from must currently own the token
580         require(owns(_from, _tokenId));
581 
582         // Reassign ownership (also clears pending approvals and emits Transfer event).
583         _transfer(_from, _to, _tokenId);
584     }
585 
586     // returns the current owner of the token with id = _tokenId
587     function ownerOf(uint256 _deedId) public view returns (address _owner) {
588         _owner = partIndexToOwner[_deedId];
589         // must result false if index key not found
590         require(_owner != address(0));
591     }
592 
593     // returns a dynamic array of the ids of all tokens which are owned by (_owner)
594     // Looping through every possible part and checking it against the owner is
595     // actually much more efficient than storing a mapping or something, because
596     // it won't be executed as a transaction
597     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
598         uint256 totalParts = totalSupply();
599 
600         return tokensOfOwnerWithinRange(_owner, 0, totalParts);
601   
602     }
603 
604     function tokensOfOwnerWithinRange(address _owner, uint _start, uint _numToSearch) public view returns(uint256[] ownerTokens) {
605         uint256 tokenCount = balanceOf(_owner);
606 
607         uint256[] memory tmpResult = new uint256[](tokenCount);
608         if (tokenCount == 0) {
609             return tmpResult;
610         }
611 
612         uint256 resultIndex = 0;
613         for (uint partId = _start; partId < _start + _numToSearch; partId++) {
614             if (partIndexToOwner[partId] == _owner) {
615                 tmpResult[resultIndex] = partId;
616                 resultIndex++;
617                 if (resultIndex == tokenCount) { //found all tokens accounted for, no need to continue
618                     break;
619                 }
620             }
621         }
622 
623         // copy number of tokens found in given range
624         uint resultLength = resultIndex;
625         uint256[] memory result = new uint256[](resultLength);
626         for (uint i=0; i<resultLength; i++) {
627             result[i] = tmpResult[i];
628         }
629         return result;
630     }
631 
632 
633 
634     //same issues as above
635     // Returns an array of all part structs owned by the user. Free to call.
636     function getPartsOfOwner(address _owner) external view returns(bytes24[]) {
637         uint256 totalParts = totalSupply();
638 
639         return getPartsOfOwnerWithinRange(_owner, 0, totalParts);
640     }
641     
642     // This is public so it can be called by getPartsOfOwner. It should NOT be called by another contract
643     // as it is very gas hungry.
644     function getPartsOfOwnerWithinRange(address _owner, uint _start, uint _numToSearch) public view returns(bytes24[]) {
645         uint256 tokenCount = balanceOf(_owner);
646 
647         uint resultIndex = 0;
648         bytes24[] memory result = new bytes24[](tokenCount);
649         for (uint partId = _start; partId < _start + _numToSearch; partId++) {
650             if (partIndexToOwner[partId] == _owner) {
651                 result[resultIndex] = _partToBytes(parts[partId]);
652                 resultIndex++;
653             }
654         }
655         return result; // will have 0 elements if tokenCount == 0
656     }
657 
658 
659     function _partToBytes(Part p) internal pure returns (bytes24 b) {
660         b = bytes24(p.tokenId);
661 
662         b = b << 8;
663         b = b | bytes24(p.partType);
664 
665         b = b << 8;
666         b = b | bytes24(p.partSubType);
667 
668         b = b << 8;
669         b = b | bytes24(p.rarity);
670 
671         b = b << 8;
672         b = b | bytes24(p.element);
673 
674         b = b << 32;
675         b = b | bytes24(p.battlesLastDay);
676 
677         b = b << 32;
678         b = b | bytes24(p.experience);
679 
680         b = b << 32;
681         b = b | bytes24(p.forgeTime);
682 
683         b = b << 32;
684         b = b | bytes24(p.battlesLastReset);
685     }
686 
687     uint32 constant FIRST_LEVEL = 1000;
688     uint32 constant INCREMENT = 1000;
689 
690     // every level, you need 1000 more exp to go up a level
691     function getLevel(uint32 _exp) public pure returns(uint32) {
692         uint32 c = 0;
693         for (uint32 i = FIRST_LEVEL; i <= FIRST_LEVEL + _exp; i += c * INCREMENT) {
694             c++;
695         }
696         return c;
697     }
698 
699     string metadataBase = "https://api.etherbots.io/api/";
700 
701 
702     function setMetadataBase(string _base) external onlyOwner {
703         metadataBase = _base;
704     }
705 
706     // part type, subtype,
707     // have one internal function which lets us implement the divergent interfaces
708     function _metadata(uint256 _id) internal view returns(string) {
709         Part memory p = parts[_id];
710         return strConcat(strConcat(
711             metadataBase,
712             uintToString(uint(p.partType)),
713             "/",
714             uintToString(uint(p.partSubType)),
715             "/"
716         ), uintToString(uint(p.rarity)), "", "", "");
717     }
718 
719     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
720         bytes memory _ba = bytes(_a);
721         bytes memory _bb = bytes(_b);
722         bytes memory _bc = bytes(_c);
723         bytes memory _bd = bytes(_d);
724         bytes memory _be = bytes(_e);
725         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
726         bytes memory babcde = bytes(abcde);
727         uint k = 0;
728         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
729         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
730         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
731         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
732         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
733         return string(babcde);
734     }
735 
736     /// @notice A distinct URI (RFC 3986) for a given token.
737     /// @dev If:
738     ///  * The URI is a URL
739     ///  * The URL is accessible
740     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
741     ///  * The JSON base element is an object
742     ///  then these names of the base element SHALL have special meaning:
743     ///  * "name": A string identifying the item to which `_deedId` grants
744     ///    ownership
745     ///  * "description": A string detailing the item to which `_deedId` grants
746     ///    ownership
747     ///  * "image": A URI pointing to a file of image/* mime type representing
748     ///    the item to which `_deedId` grants ownership
749     ///  Wallets and exchanges MAY display this to the end user.
750     ///  Consider making any images at a width between 320 and 1080 pixels and
751     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
752     function deedUri(uint256 _deedId) external view returns (string _uri){
753         return _metadata(_deedId);
754     }
755 
756     /// returns a metadata URI
757     function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl) {
758         return _metadata(_tokenId);
759     }
760 
761     function takeOwnership(uint256 _deedId) external payable {
762         // payable for ERC721 --> don't actually send eth @_@
763         require(msg.value == 0);
764 
765         address _from = partIndexToOwner[_deedId];
766 
767         require(_approvedFor(msg.sender, _deedId));
768 
769         _transfer(_from, msg.sender, _deedId);
770     }
771 
772     // parts are stored sequentially
773     function deedByIndex(uint256 _index) external view returns (uint256 _deedId){
774         return _index;
775     }
776 
777     function countOfOwners() external view returns (uint256 _count){
778         // TODO: implement this
779         return 0;
780     }
781 
782 // thirsty function
783     function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint _tokenId){
784         return _tokenOfOwnerByIndex(_owner, _index);
785     }
786 
787 // code duplicated
788     function _tokenOfOwnerByIndex(address _owner, uint _index) private view returns (uint _tokenId){
789         // The index should be valid.
790         require(_index < balanceOf(_owner));
791 
792         // can loop through all without
793         uint256 seen = 0;
794         uint256 totalTokens = totalSupply();
795 
796         for (uint i = 0; i < totalTokens; i++) {
797             if (partIndexToOwner[i] == _owner) {
798                 if (seen == _index) {
799                     return i;
800                 }
801                 seen++;
802             }
803         }
804     }
805 
806     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId){
807         return _tokenOfOwnerByIndex(_owner, _index);
808     }
809 }
810 
811 
812 
813 
814 
815 // Auction contract, facilitating statically priced sales, as well as 
816 // inflationary and deflationary pricing for items.
817 // Relies heavily on the ERC721 interface and so most of the methods
818 // are tightly bound to that implementation
819 contract NFTAuctionBase is Pausable {
820 
821     ERC721AllImplementations public nftContract;
822     uint256 public ownerCut;
823     uint public minDuration;
824     uint public maxDuration;
825 
826     // Represents an auction on an NFT (in this case, Robot part)
827     struct Auction {
828         // address of part owner
829         address seller;
830         // wei price of listing
831         uint256 startPrice;
832         // wei price of floor
833         uint256 endPrice;
834         // duration of sale in seconds.
835         uint64 duration;
836         // Time when sale started
837         // Reset to 0 after sale concluded
838         uint64 start;
839     }
840 
841     function NFTAuctionBase() public {
842         minDuration = 60 minutes;
843         maxDuration = 30 days; // arbitrary
844     }
845 
846     // map of all tokens and their auctions
847     mapping (uint256 => Auction) tokenIdToAuction;
848 
849     event AuctionCreated(uint256 tokenId, uint256 startPrice, uint256 endPrice, uint64 duration, uint64 start);
850     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
851     event AuctionCancelled(uint256 tokenId);
852 
853     // returns true if the token with id _partId is owned by the _claimant address
854     function _owns(address _claimant, uint256 _partId) internal view returns (bool) {
855         return nftContract.ownerOf(_partId) == _claimant;
856     }
857 
858    // returns false if auction start time is 0, likely from uninitialised struct
859     function _isActiveAuction(Auction _auction) internal pure returns (bool) {
860         return _auction.start > 0;
861     }
862     
863     // assigns ownership of the token with id = _partId to this contract
864     // must have already been approved
865     function _escrow(address, uint _partId) internal {
866         // throws on transfer fail
867         nftContract.takeOwnership(_partId);
868     }
869 
870     // transfer the token with id = _partId to buying address
871     function _transfer(address _purchasor, uint256 _partId) internal {
872         // successful purchaseder must takeOwnership of _partId
873         // nftContract.approve(_purchasor, _partId); 
874                // actual transfer
875                 nftContract.transfer(_purchasor, _partId);
876 
877     }
878 
879     // creates
880     function _newAuction(uint256 _partId, Auction _auction) internal {
881 
882         require(_auction.duration >= minDuration);
883         require(_auction.duration <= maxDuration);
884 
885         tokenIdToAuction[_partId] = _auction;
886 
887         AuctionCreated(uint256(_partId),
888             uint256(_auction.startPrice),
889             uint256(_auction.endPrice),
890             uint64(_auction.duration),
891             uint64(_auction.start)
892         );
893     }
894 
895     function setMinDuration(uint _duration) external onlyOwner {
896         minDuration = _duration;
897     }
898 
899     function setMaxDuration(uint _duration) external onlyOwner {
900         maxDuration = _duration;
901     }
902 
903     /// Removes auction from public view, returns token to the seller
904     function _cancelAuction(uint256 _partId, address _seller) internal {
905         _removeAuction(_partId);
906         _transfer(_seller, _partId);
907         AuctionCancelled(_partId);
908     }
909 
910     event PrintEvent(string, address, uint);
911 
912     // Calculates price and transfers purchase to owner. Part is NOT transferred to buyer.
913     function _purchase(uint256 _partId, uint256 _purchaseAmount) internal returns (uint256) {
914 
915         Auction storage auction = tokenIdToAuction[_partId];
916 
917         // check that this token is being auctioned
918         require(_isActiveAuction(auction));
919 
920         // enforce purchase >= the current price
921         uint256 price = _currentPrice(auction);
922         require(_purchaseAmount >= price);
923 
924         // Store seller before we delete auction.
925         address seller = auction.seller;
926 
927         // Valid purchase. Remove auction to prevent reentrancy.
928         _removeAuction(_partId);
929 
930         // Transfer proceeds to seller (if there are any!)
931         if (price > 0) {
932             
933             // Calculate and take fee from purchase
934 
935             uint256 auctioneerCut = _computeFee(price);
936             uint256 sellerProceeds = price - auctioneerCut;
937 
938             PrintEvent("Seller, proceeds", seller, sellerProceeds);
939 
940             // Pay the seller
941             seller.transfer(sellerProceeds);
942         }
943 
944         // Calculate excess funds and return to buyer.
945         uint256 purchaseExcess = _purchaseAmount - price;
946 
947         PrintEvent("Sender, excess", msg.sender, purchaseExcess);
948         // Return any excess funds. Reentrancy again prevented by deleting auction.
949         msg.sender.transfer(purchaseExcess);
950 
951         AuctionSuccessful(_partId, price, msg.sender);
952 
953         return price;
954     }
955 
956     // returns the current price of the token being auctioned in _auction
957     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
958         uint256 secsElapsed = now - _auction.start;
959         return _computeCurrentPrice(
960             _auction.startPrice,
961             _auction.endPrice,
962             _auction.duration,
963             secsElapsed
964         );
965     }
966 
967     // Checks if NFTPart is currently being auctioned.
968     // function _isBeingAuctioned(Auction storage _auction) internal view returns (bool) {
969     //     return (_auction.start > 0);
970     // }
971 
972     // removes the auction of the part with id _partId
973     function _removeAuction(uint256 _partId) internal {
974         delete tokenIdToAuction[_partId];
975     }
976 
977     // computes the current price of an deflating-price auction 
978     function _computeCurrentPrice( uint256 _startPrice, uint256 _endPrice, uint256 _duration, uint256 _secondsPassed ) internal pure returns (uint256 _price) {
979         _price = _startPrice;
980         if (_secondsPassed >= _duration) {
981             // Has been up long enough to hit endPrice.
982             // Return this price floor.
983             _price = _endPrice;
984             // this is a statically price sale. Just return the price.
985         }
986         else if (_duration > 0) {
987             // This auction contract supports auctioning from any valid price to any other valid price.
988             // This means the price can dynamically increase upward, or downard.
989             int256 priceDifference = int256(_endPrice) - int256(_startPrice);
990             int256 currentPriceDifference = priceDifference * int256(_secondsPassed) / int256(_duration);
991             int256 currentPrice = int256(_startPrice) + currentPriceDifference;
992 
993             _price = uint256(currentPrice);
994         }
995         return _price;
996     }
997 
998     // Compute percentage fee of transaction
999 
1000     function _computeFee (uint256 _price) internal view returns (uint256) {
1001         return _price * ownerCut / 10000; 
1002     }
1003 
1004 }
1005 
1006 // Clock auction for NFTParts.
1007 // Only timed when pricing is dynamic (i.e. startPrice != endPrice).
1008 // Else, this becomes an infinite duration statically priced sale,
1009 // resolving when succesfully purchase for or cancelled.
1010 
1011 contract DutchAuction is NFTAuctionBase, EtherbotsPrivileges {
1012 
1013     // The ERC-165 interface signature for ERC-721.
1014     bytes4 constant InterfaceSignature_ERC721 = bytes4(0xda671b9b);
1015  
1016     function DutchAuction(address _nftAddress, uint256 _fee) public {
1017         require(_fee <= 10000);
1018         ownerCut = _fee;
1019 
1020         ERC721AllImplementations candidateContract = ERC721AllImplementations(_nftAddress);
1021         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1022         nftContract = candidateContract;
1023     }
1024 
1025     // Remove all ether from the contract. This will be marketplace fees.
1026     // Transfers to the NFT contract. 
1027     // Can be called by owner or NFT contract.
1028 
1029     function withdrawBalance() external {
1030         address nftAddress = address(nftContract);
1031 
1032         require(msg.sender == owner || msg.sender == nftAddress);
1033 
1034         nftAddress.transfer(this.balance);
1035     }
1036 
1037     event PrintEvent(string, address, uint);
1038 
1039     // Creates an auction and lists it.
1040     function createAuction( uint256 _partId, uint256 _startPrice, uint256 _endPrice, uint256 _duration, address _seller ) external whenNotPaused {
1041         // Sanity check that no inputs overflow how many bits we've allocated
1042         // to store them in the auction struct.
1043         require(_startPrice == uint256(uint128(_startPrice)));
1044         require(_endPrice == uint256(uint128(_endPrice)));
1045         require(_duration == uint256(uint64(_duration)));
1046         require(_startPrice >= _endPrice);
1047 
1048         require(msg.sender == address(nftContract));
1049         _escrow(_seller, _partId);
1050         Auction memory auction = Auction(
1051             _seller,
1052             uint128(_startPrice),
1053             uint128(_endPrice),
1054             uint64(_duration),
1055             uint64(now) //seconds uint 
1056         );
1057         PrintEvent("Auction Start", 0x0, auction.start);
1058         _newAuction(_partId, auction);
1059     }
1060 
1061 
1062     // SCRAPYARD PRICING LOGIC
1063 
1064     uint8 constant LAST_CONSIDERED = 5;
1065     uint8 public scrapCounter = 0;
1066     uint[5] public lastScrapPrices;
1067     
1068     // Purchases an open auction
1069     // Will transfer ownership if successful.
1070     
1071     function purchase(uint256 _partId) external payable whenNotPaused {
1072         address seller = tokenIdToAuction[_partId].seller;
1073 
1074         // _purchase will throw if the purchase or funds transfer fails
1075         uint256 price = _purchase(_partId, msg.value);
1076         _transfer(msg.sender, _partId);
1077         
1078         // If the seller is the scrapyard, track price information.
1079         if (seller == address(nftContract)) {
1080 
1081             lastScrapPrices[scrapCounter] = price;
1082             if (scrapCounter == LAST_CONSIDERED - 1) {
1083                 scrapCounter = 0;
1084             } else {
1085                 scrapCounter++;
1086             }
1087         }
1088     }
1089 
1090     function averageScrapPrice() public view returns (uint) {
1091         uint sum = 0;
1092         for (uint8 i = 0; i < LAST_CONSIDERED; i++) {
1093             sum += lastScrapPrices[i];
1094         }
1095         return sum / LAST_CONSIDERED;
1096     }
1097 
1098     // Allows a user to cancel an auction before it's resolved.
1099     // Returns the part to the seller.
1100 
1101     function cancelAuction(uint256 _partId) external {
1102         Auction storage auction = tokenIdToAuction[_partId];
1103         require(_isActiveAuction(auction));
1104         address seller = auction.seller;
1105         require(msg.sender == seller);
1106         _cancelAuction(_partId, seller);
1107     }
1108 
1109     // returns the current price of the auction of a token with id _partId
1110     function getCurrentPrice(uint256 _partId) external view returns (uint256) {
1111         Auction storage auction = tokenIdToAuction[_partId];
1112         require(_isActiveAuction(auction));
1113         return _currentPrice(auction);
1114     }
1115 
1116     //  Returns the details of an auction from its _partId.
1117     function getAuction(uint256 _partId) external view returns ( address seller, uint256 startPrice, uint256 endPrice, uint256 duration, uint256 startedAt ) {
1118         Auction storage auction = tokenIdToAuction[_partId];
1119         require(_isActiveAuction(auction));
1120         return ( auction.seller, auction.startPrice, auction.endPrice, auction.duration, auction.start);
1121     }
1122 
1123     // Allows owner to cancel an auction.
1124     // ONLY able to be used when contract is paused,
1125     // in the case of emergencies.
1126     // Parts returned to seller as it's equivalent to them 
1127     // calling cancel.
1128     function cancelAuctionWhenPaused(uint256 _partId) whenPaused onlyOwner external {
1129         Auction storage auction = tokenIdToAuction[_partId];
1130         require(_isActiveAuction(auction));
1131         _cancelAuction(_partId, auction.seller);
1132     }
1133 }