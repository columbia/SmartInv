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
45  // Pause functionality taken from OpenZeppelin. License below.
46  /* The MIT License (MIT)
47  Copyright (c) 2016 Smart Contract Solutions, Inc.
48  Permission is hereby granted, free of charge, to any person obtaining
49  a copy of this software and associated documentation files (the
50  "Software"), to deal in the Software without restriction, including
51  without limitation the rights to use, copy, modify, merge, publish,
52  distribute, sublicense, and/or sell copies of the Software, and to
53  permit persons to whom the Software is furnished to do so, subject to
54  the following conditions: */
55 
56  /**
57   * @title Pausable
58   * @dev Base contract which allows children to implement an emergency stop mechanism.
59   */
60 contract Pausable is Ownable {
61 
62   event SetPaused(bool paused);
63 
64   // starts unpaused
65   bool public paused = false;
66 
67   /* @dev modifier to allow actions only when the contract IS paused */
68   modifier whenNotPaused() {
69     require(!paused);
70     _;
71   }
72 
73   /* @dev modifier to allow actions only when the contract IS NOT paused */
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   function pause() public onlyOwner whenNotPaused returns (bool) {
80     paused = true;
81     SetPaused(paused);
82     return true;
83   }
84 
85   function unpause() public onlyOwner whenPaused returns (bool) {
86     paused = false;
87     SetPaused(paused);
88     return true;
89   }
90 }
91 
92 contract EtherbotsPrivileges is Pausable {
93   event ContractUpgrade(address newContract);
94 
95 }
96 
97 
98 
99 // This contract implements both the original ERC-721 standard and
100 // the proposed 'deed' standard of 841
101 // I don't know which standard will eventually be adopted - support both for now
102 
103 
104 /// @title Interface for contracts conforming to ERC-721: Deed Standard
105 /// @author William Entriken (https://phor.net), et. al.
106 /// @dev Specification at https://github.com/ethereum/eips/841
107 /// can read the comments there
108 contract ERC721 {
109 
110     // COMPLIANCE WITH ERC-165 (DRAFT)
111 
112     /// @dev ERC-165 (draft) interface signature for itself
113     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 =
114         bytes4(keccak256("supportsInterface(bytes4)"));
115 
116     /// @dev ERC-165 (draft) interface signature for ERC721
117     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 =
118          bytes4(keccak256("ownerOf(uint256)")) ^
119          bytes4(keccak256("countOfDeeds()")) ^
120          bytes4(keccak256("countOfDeedsByOwner(address)")) ^
121          bytes4(keccak256("deedOfOwnerByIndex(address,uint256)")) ^
122          bytes4(keccak256("approve(address,uint256)")) ^
123          bytes4(keccak256("takeOwnership(uint256)"));
124 
125     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
126 
127     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
128 
129     function ownerOf(uint256 _deedId) public view returns (address _owner);
130     function countOfDeeds() external view returns (uint256 _count);
131     function countOfDeedsByOwner(address _owner) external view returns (uint256 _count);
132     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
133 
134     // TRANSFER MECHANISM //////////////////////////////////////////////////////
135 
136     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
137     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
138 
139     function approve(address _to, uint256 _deedId) external payable;
140     function takeOwnership(uint256 _deedId) external payable;
141 }
142 
143 /// @title Metadata extension to ERC-721 interface
144 /// @author William Entriken (https://phor.net)
145 /// @dev Specification at https://github.com/ethereum/eips/issues/XXXX
146 contract ERC721Metadata is ERC721 {
147 
148     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata =
149         bytes4(keccak256("name()")) ^
150         bytes4(keccak256("symbol()")) ^
151         bytes4(keccak256("deedUri(uint256)"));
152 
153     function name() public pure returns (string n);
154     function symbol() public pure returns (string s);
155 
156     /// @notice A distinct URI (RFC 3986) for a given token.
157     /// @dev If:
158     ///  * The URI is a URL
159     ///  * The URL is accessible
160     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
161     ///  * The JSON base element is an object
162     ///  then these names of the base element SHALL have special meaning:
163     ///  * "name": A string identifying the item to which `_deedId` grants
164     ///    ownership
165     ///  * "description": A string detailing the item to which `_deedId` grants
166     ///    ownership
167     ///  * "image": A URI pointing to a file of image/* mime type representing
168     ///    the item to which `_deedId` grants ownership
169     ///  Wallets and exchanges MAY display this to the end user.
170     ///  Consider making any images at a width between 320 and 1080 pixels and
171     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
172     function deedUri(uint256 _deedId) external view returns (string _uri);
173 }
174 
175 /// @title Enumeration extension to ERC-721 interface
176 /// @author William Entriken (https://phor.net)
177 /// @dev Specification at https://github.com/ethereum/eips/issues/XXXX
178 contract ERC721Enumerable is ERC721Metadata {
179 
180     /// @dev ERC-165 (draft) interface signature for ERC721
181     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Enumerable =
182         bytes4(keccak256("deedByIndex()")) ^
183         bytes4(keccak256("countOfOwners()")) ^
184         bytes4(keccak256("ownerByIndex(uint256)"));
185 
186     function deedByIndex(uint256 _index) external view returns (uint256 _deedId);
187     function countOfOwners() external view returns (uint256 _count);
188     function ownerByIndex(uint256 _index) external view returns (address _owner);
189 }
190 
191 contract ERC721Original {
192 
193     bytes4 constant INTERFACE_SIGNATURE_ERC721Original =
194         bytes4(keccak256("totalSupply()")) ^
195         bytes4(keccak256("balanceOf(address)")) ^
196         bytes4(keccak256("ownerOf(uint256)")) ^
197         bytes4(keccak256("approve(address,uint256)")) ^
198         bytes4(keccak256("takeOwnership(uint256)")) ^
199         bytes4(keccak256("transfer(address,uint256)"));
200 
201     // Core functions
202     function implementsERC721() public pure returns (bool);
203     function totalSupply() public view returns (uint256 _totalSupply);
204     function balanceOf(address _owner) public view returns (uint256 _balance);
205     function ownerOf(uint _tokenId) public view returns (address _owner);
206     function approve(address _to, uint _tokenId) external payable;
207     function transferFrom(address _from, address _to, uint _tokenId) public;
208     function transfer(address _to, uint _tokenId) public payable;
209 
210     // Optional functions
211     function name() public pure returns (string _name);
212     function symbol() public pure returns (string _symbol);
213     function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint _tokenId);
214     function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
215 
216     // Events
217     // event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
218     // event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
219 }
220 
221 contract ERC721AllImplementations is ERC721Original, ERC721Enumerable {
222 
223 }
224 
225 contract EtherbotsBase is EtherbotsPrivileges {
226 
227 
228     function EtherbotsBase() public {
229     //   scrapyard = address(this);
230     }
231     /*** EVENTS ***/
232 
233     ///  Forge fires when a new part is created - 4 times when a crate is opened,
234     /// and once when a battle takes place. Also has fires when
235     /// parts are combined in the furnace.
236     event Forge(address owner, uint256 partID, Part part);
237 
238     ///  Transfer event as defined in ERC721.
239     event Transfer(address from, address to, uint256 tokenId);
240 
241     /*** DATA TYPES ***/
242     ///  The main struct representation of a robot part. Each robot in Etherbots is represented by four copies
243     ///  of this structure, one for each of the four parts comprising it:
244     /// 1. Right Arm (Melee),
245     /// 2. Left Arm (Defence),
246     /// 3. Head (Turret),
247     /// 4. Body.
248     // store token id on this?
249      struct Part {
250         uint32 tokenId;
251         uint8 partType;
252         uint8 partSubType;
253         uint8 rarity;
254         uint8 element;
255         uint32 battlesLastDay;
256         uint32 experience;
257         uint32 forgeTime;
258         uint32 battlesLastReset;
259     }
260 
261     // Part type - can be shared with other part factories.
262     uint8 constant DEFENCE = 1;
263     uint8 constant MELEE = 2;
264     uint8 constant BODY = 3;
265     uint8 constant TURRET = 4;
266 
267     // Rarity - can be shared with other part factories.
268     uint8 constant STANDARD = 1;
269     uint8 constant SHADOW = 2;
270     uint8 constant GOLD = 3;
271 
272 
273     // Store a user struct
274     // in order to keep track of experience and perk choices.
275     // This perk tree is a binary tree, efficiently encodable as an array.
276     // 0 reflects no perk selected. 1 is first choice. 2 is second. 3 is both.
277     // Each choice costs experience (deducted from user struct).
278 
279     /*** ~~~~~ROBOT PERKS~~~~~ ***/
280     // PERK 1: ATTACK vs DEFENCE PERK CHOICE.
281     // Choose
282     // PERK TWO ATTACK/ SHOOT, or DEFEND/DODGE
283     // PERK 2: MECH vs ELEMENTAL PERK CHOICE ---
284     // Choose steel and electric (Mech path), or water and fire (Elemetal path)
285     // (... will the mechs win the war for Ethertopia? or will the androids
286     // be deluged in flood and fire? ...)
287     // PERK 3: Commit to a specific elemental pathway:
288     // 1. the path of steel: the iron sword; the burning frying pan!
289     // 2. the path of electricity: the deadly taser, the fearsome forcefield
290     // 3. the path of water: high pressure water blasters have never been so cool
291     // 4. the path of fire!: we will hunt you down, Aang...
292 
293 
294     struct User {
295         // address userAddress;
296         uint32 numShards; //limit shards to upper bound eg 10000
297         uint32 experience;
298         uint8[32] perks;
299     }
300 
301     //Maintain an array of all users.
302     // User[] public users;
303 
304     // Store a map of the address to a uint representing index of User within users
305     // we check if a user exists at multiple points, every time they acquire
306     // via a crate or the market. Users can also manually register their address.
307     mapping ( address => User ) public addressToUser;
308 
309     // Array containing the structs of all parts in existence. The ID
310     // of each part is an index into this array.
311     Part[] parts;
312 
313     // Mapping from part IDs to to owning address. Should always exist.
314     mapping (uint256 => address) public partIndexToOwner;
315 
316     //  A mapping from owner address to count of tokens that address owns.
317     //  Used internally inside balanceOf() to resolve ownership count. REMOVE?
318     mapping (address => uint256) addressToTokensOwned;
319 
320     // Mapping from Part ID to an address approved to call transferFrom().
321     // maximum of one approved address for transfer at any time.
322     mapping (uint256 => address) public partIndexToApproved;
323 
324     address auction;
325     // address scrapyard;
326 
327     // Array to store approved battle contracts.
328     // Can only ever be added to, not removed from.
329     // Once a ruleset is published, you will ALWAYS be able to use that contract
330     address[] approvedBattles;
331 
332 
333     function getUserByAddress(address _user) public view returns (uint32, uint8[32]) {
334         return (addressToUser[_user].experience, addressToUser[_user].perks);
335     }
336 
337     //  Transfer a part to an address
338     function _transfer(address _from, address _to, uint256 _tokenId) internal {
339         // No cap on number of parts
340         // Very unlikely to ever be 2^256 parts owned by one account
341         // Shouldn't waste gas checking for overflow
342         // no point making it less than a uint --> mappings don't pack
343         addressToTokensOwned[_to]++;
344         // transfer ownership
345         partIndexToOwner[_tokenId] = _to;
346         // New parts are transferred _from 0x0, but we can't account that address.
347         if (_from != address(0)) {
348             addressToTokensOwned[_from]--;
349             // clear any previously approved ownership exchange
350             delete partIndexToApproved[_tokenId];
351         }
352         // Emit the transfer event.
353         Transfer(_from, _to, _tokenId);
354     }
355 
356     function getPartById(uint _id) external view returns (
357         uint32 tokenId,
358         uint8 partType,
359         uint8 partSubType,
360         uint8 rarity,
361         uint8 element,
362         uint32 battlesLastDay,
363         uint32 experience,
364         uint32 forgeTime,
365         uint32 battlesLastReset
366     ) {
367         Part memory p = parts[_id];
368         return (p.tokenId, p.partType, p.partSubType, p.rarity, p.element, p.battlesLastDay, p.experience, p.forgeTime, p.battlesLastReset);
369     }
370 
371 
372     function substring(string str, uint startIndex, uint endIndex) internal pure returns (string) {
373         bytes memory strBytes = bytes(str);
374         bytes memory result = new bytes(endIndex-startIndex);
375         for (uint i = startIndex; i < endIndex; i++) {
376             result[i-startIndex] = strBytes[i];
377         }
378         return string(result);
379     }
380 
381     // helper functions adapted from  Jossie Calderon on stackexchange
382     function stringToUint32(string s) internal pure returns (uint32) {
383         bytes memory b = bytes(s);
384         uint result = 0;
385         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
386             if (b[i] >= 48 && b[i] <= 57) {
387                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
388             }
389         }
390         return uint32(result);
391     }
392 
393     function stringToUint8(string s) internal pure returns (uint8) {
394         return uint8(stringToUint32(s));
395     }
396 
397     function uintToString(uint v) internal pure returns (string) {
398         uint maxlength = 100;
399         bytes memory reversed = new bytes(maxlength);
400         uint i = 0;
401         while (v != 0) {
402             uint remainder = v % 10;
403             v = v / 10;
404             reversed[i++] = byte(48 + remainder);
405         }
406         bytes memory s = new bytes(i); // i + 1 is inefficient
407         for (uint j = 0; j < i; j++) {
408             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
409         }
410         string memory str = string(s);
411         return str;
412     }
413 }
414 contract EtherbotsNFT is EtherbotsBase, ERC721Enumerable, ERC721Original {
415     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
416         return (_interfaceID == ERC721Original.INTERFACE_SIGNATURE_ERC721Original) ||
417             (_interfaceID == ERC721.INTERFACE_SIGNATURE_ERC721) ||
418             (_interfaceID == ERC721Metadata.INTERFACE_SIGNATURE_ERC721Metadata) ||
419             (_interfaceID == ERC721Enumerable.INTERFACE_SIGNATURE_ERC721Enumerable);
420     }
421     function implementsERC721() public pure returns (bool) {
422         return true;
423     }
424 
425     function name() public pure returns (string _name) {
426       return "Etherbots";
427     }
428 
429     function symbol() public pure returns (string _smbol) {
430       return "ETHBOT";
431     }
432 
433     // total supply of parts --> as no parts are ever deleted, this is simply
434     // the total supply of parts ever created
435     function totalSupply() public view returns (uint) {
436         return parts.length;
437     }
438 
439     /// @notice Returns the total number of deeds currently in existence.
440     /// @dev Required for ERC-721 compliance.
441     function countOfDeeds() external view returns (uint256) {
442         return parts.length;
443     }
444 
445     //--/ internal function    which checks whether the token with id (_tokenId)
446     /// is owned by the (_claimant) address
447     function owns(address _owner, uint256 _tokenId) public view returns (bool) {
448         return (partIndexToOwner[_tokenId] == _owner);
449     }
450 
451     /// internal function    which checks whether the token with id (_tokenId)
452     /// is owned by the (_claimant) address
453     function ownsAll(address _owner, uint256[] _tokenIds) public view returns (bool) {
454         require(_tokenIds.length > 0);
455         for (uint i = 0; i < _tokenIds.length; i++) {
456             if (partIndexToOwner[_tokenIds[i]] != _owner) {
457                 return false;
458             }
459         }
460         return true;
461     }
462 
463     function _approve(uint256 _tokenId, address _approved) internal {
464         partIndexToApproved[_tokenId] = _approved;
465     }
466 
467     function _approvedFor(address _newOwner, uint256 _tokenId) internal view returns (bool) {
468         return (partIndexToApproved[_tokenId] == _newOwner);
469     }
470 
471     function ownerByIndex(uint256 _index) external view returns (address _owner){
472         return partIndexToOwner[_index];
473     }
474 
475     // returns the NUMBER of tokens owned by (_owner)
476     function balanceOf(address _owner) public view returns (uint256 count) {
477         return addressToTokensOwned[_owner];
478     }
479 
480     function countOfDeedsByOwner(address _owner) external view returns (uint256) {
481         return balanceOf(_owner);
482     }
483 
484     // transfers a part to another account
485     function transfer(address _to, uint256 _tokenId) public whenNotPaused payable {
486         // payable for ERC721 --> don't actually send eth @_@
487         require(msg.value == 0);
488 
489         // Safety checks to prevent accidental transfers to common accounts
490         require(_to != address(0));
491         require(_to != address(this));
492         // can't transfer parts to the auction contract directly
493         require(_to != address(auction));
494         // can't transfer parts to any of the battle contracts directly
495         for (uint j = 0; j < approvedBattles.length; j++) {
496             require(_to != approvedBattles[j]);
497         }
498 
499         // Cannot send tokens you don't own
500         require(owns(msg.sender, _tokenId));
501 
502         // perform state changes necessary for transfer
503         _transfer(msg.sender, _to, _tokenId);
504     }
505     // transfers a part to another account
506 
507     function transferAll(address _to, uint256[] _tokenIds) public whenNotPaused payable {
508         require(msg.value == 0);
509 
510         // Safety checks to prevent accidental transfers to common accounts
511         require(_to != address(0));
512         require(_to != address(this));
513         // can't transfer parts to the auction contract directly
514         require(_to != address(auction));
515         // can't transfer parts to any of the battle contracts directly
516         for (uint j = 0; j < approvedBattles.length; j++) {
517             require(_to != approvedBattles[j]);
518         }
519 
520         // Cannot send tokens you don't own
521         require(ownsAll(msg.sender, _tokenIds));
522 
523         for (uint k = 0; k < _tokenIds.length; k++) {
524             // perform state changes necessary for transfer
525             _transfer(msg.sender, _to, _tokenIds[k]);
526         }
527 
528 
529     }
530 
531 
532     // approves the (_to) address to use the transferFrom function on the token with id (_tokenId)
533     // if you want to clear all approvals, simply pass the zero address
534     function approve(address _to, uint256 _deedId) external whenNotPaused payable {
535         // payable for ERC721 --> don't actually send eth @_@
536         require(msg.value == 0);
537 // use internal function?
538         // Cannot approve the transfer of tokens you don't own
539         require(owns(msg.sender, _deedId));
540 
541         // Store the approval (can only approve one at a time)
542         partIndexToApproved[_deedId] = _to;
543 
544         Approval(msg.sender, _to, _deedId);
545     }
546 
547     // approves many token ids
548     function approveMany(address _to, uint256[] _tokenIds) external whenNotPaused payable {
549 
550         for (uint i = 0; i < _tokenIds.length; i++) {
551             uint _tokenId = _tokenIds[i];
552 
553             // Cannot approve the transfer of tokens you don't own
554             require(owns(msg.sender, _tokenId));
555 
556             // Store the approval (can only approve one at a time)
557             partIndexToApproved[_tokenId] = _to;
558             //create event for each approval? _tokenId guaranteed to hold correct value?
559             Approval(msg.sender, _to, _tokenId);
560         }
561     }
562 
563     // transfer the part with id (_tokenId) from (_from) to (_to)
564     // (_to) must already be approved for this (_tokenId)
565     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
566 
567         // Safety checks to prevent accidents
568         require(_to != address(0));
569         require(_to != address(this));
570 
571         // sender must be approved
572         require(partIndexToApproved[_tokenId] == msg.sender);
573         // from must currently own the token
574         require(owns(_from, _tokenId));
575 
576         // Reassign ownership (also clears pending approvals and emits Transfer event).
577         _transfer(_from, _to, _tokenId);
578     }
579 
580     // returns the current owner of the token with id = _tokenId
581     function ownerOf(uint256 _deedId) public view returns (address _owner) {
582         _owner = partIndexToOwner[_deedId];
583         // must result false if index key not found
584         require(_owner != address(0));
585     }
586 
587     // returns a dynamic array of the ids of all tokens which are owned by (_owner)
588     // Looping through every possible part and checking it against the owner is
589     // actually much more efficient than storing a mapping or something, because
590     // it won't be executed as a transaction
591     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
592         uint256 totalParts = totalSupply();
593 
594         return tokensOfOwnerWithinRange(_owner, 0, totalParts);
595   
596     }
597 
598     function tokensOfOwnerWithinRange(address _owner, uint _start, uint _numToSearch) public view returns(uint256[] ownerTokens) {
599         uint256 tokenCount = balanceOf(_owner);
600 
601         uint256[] memory tmpResult = new uint256[](tokenCount);
602         if (tokenCount == 0) {
603             return tmpResult;
604         }
605 
606         uint256 resultIndex = 0;
607         for (uint partId = _start; partId < _start + _numToSearch; partId++) {
608             if (partIndexToOwner[partId] == _owner) {
609                 tmpResult[resultIndex] = partId;
610                 resultIndex++;
611                 if (resultIndex == tokenCount) { //found all tokens accounted for, no need to continue
612                     break;
613                 }
614             }
615         }
616 
617         // copy number of tokens found in given range
618         uint resultLength = resultIndex;
619         uint256[] memory result = new uint256[](resultLength);
620         for (uint i=0; i<resultLength; i++) {
621             result[i] = tmpResult[i];
622         }
623         return result;
624     }
625 
626 
627 
628     //same issues as above
629     // Returns an array of all part structs owned by the user. Free to call.
630     function getPartsOfOwner(address _owner) external view returns(bytes24[]) {
631         uint256 totalParts = totalSupply();
632 
633         return getPartsOfOwnerWithinRange(_owner, 0, totalParts);
634     }
635     
636     // This is public so it can be called by getPartsOfOwner. It should NOT be called by another contract
637     // as it is very gas hungry.
638     function getPartsOfOwnerWithinRange(address _owner, uint _start, uint _numToSearch) public view returns(bytes24[]) {
639         uint256 tokenCount = balanceOf(_owner);
640 
641         uint resultIndex = 0;
642         bytes24[] memory result = new bytes24[](tokenCount);
643         for (uint partId = _start; partId < _start + _numToSearch; partId++) {
644             if (partIndexToOwner[partId] == _owner) {
645                 result[resultIndex] = _partToBytes(parts[partId]);
646                 resultIndex++;
647             }
648         }
649         return result; // will have 0 elements if tokenCount == 0
650     }
651 
652 
653     function _partToBytes(Part p) internal pure returns (bytes24 b) {
654         b = bytes24(p.tokenId);
655 
656         b = b << 8;
657         b = b | bytes24(p.partType);
658 
659         b = b << 8;
660         b = b | bytes24(p.partSubType);
661 
662         b = b << 8;
663         b = b | bytes24(p.rarity);
664 
665         b = b << 8;
666         b = b | bytes24(p.element);
667 
668         b = b << 32;
669         b = b | bytes24(p.battlesLastDay);
670 
671         b = b << 32;
672         b = b | bytes24(p.experience);
673 
674         b = b << 32;
675         b = b | bytes24(p.forgeTime);
676 
677         b = b << 32;
678         b = b | bytes24(p.battlesLastReset);
679     }
680 
681     uint32 constant FIRST_LEVEL = 1000;
682     uint32 constant INCREMENT = 1000;
683 
684     // every level, you need 1000 more exp to go up a level
685     function getLevel(uint32 _exp) public pure returns(uint32) {
686         uint32 c = 0;
687         for (uint32 i = FIRST_LEVEL; i <= FIRST_LEVEL + _exp; i += c * INCREMENT) {
688             c++;
689         }
690         return c;
691     }
692 
693     string metadataBase = "https://api.etherbots.io/api/";
694 
695 
696     function setMetadataBase(string _base) external onlyOwner {
697         metadataBase = _base;
698     }
699 
700     // part type, subtype,
701     // have one internal function which lets us implement the divergent interfaces
702     function _metadata(uint256 _id) internal view returns(string) {
703         Part memory p = parts[_id];
704         return strConcat(strConcat(
705             metadataBase,
706             uintToString(uint(p.partType)),
707             "/",
708             uintToString(uint(p.partSubType)),
709             "/"
710         ), uintToString(uint(p.rarity)), "", "", "");
711     }
712 
713     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
714         bytes memory _ba = bytes(_a);
715         bytes memory _bb = bytes(_b);
716         bytes memory _bc = bytes(_c);
717         bytes memory _bd = bytes(_d);
718         bytes memory _be = bytes(_e);
719         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
720         bytes memory babcde = bytes(abcde);
721         uint k = 0;
722         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
723         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
724         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
725         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
726         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
727         return string(babcde);
728     }
729 
730     /// @notice A distinct URI (RFC 3986) for a given token.
731     /// @dev If:
732     ///  * The URI is a URL
733     ///  * The URL is accessible
734     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
735     ///  * The JSON base element is an object
736     ///  then these names of the base element SHALL have special meaning:
737     ///  * "name": A string identifying the item to which `_deedId` grants
738     ///    ownership
739     ///  * "description": A string detailing the item to which `_deedId` grants
740     ///    ownership
741     ///  * "image": A URI pointing to a file of image/* mime type representing
742     ///    the item to which `_deedId` grants ownership
743     ///  Wallets and exchanges MAY display this to the end user.
744     ///  Consider making any images at a width between 320 and 1080 pixels and
745     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
746     function deedUri(uint256 _deedId) external view returns (string _uri){
747         return _metadata(_deedId);
748     }
749 
750     /// returns a metadata URI
751     function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl) {
752         return _metadata(_tokenId);
753     }
754 
755     function takeOwnership(uint256 _deedId) external payable {
756         // payable for ERC721 --> don't actually send eth @_@
757         require(msg.value == 0);
758 
759         address _from = partIndexToOwner[_deedId];
760 
761         require(_approvedFor(msg.sender, _deedId));
762 
763         _transfer(_from, msg.sender, _deedId);
764     }
765 
766     // parts are stored sequentially
767     function deedByIndex(uint256 _index) external view returns (uint256 _deedId){
768         return _index;
769     }
770 
771     function countOfOwners() external view returns (uint256 _count){
772         // TODO: implement this
773         return 0;
774     }
775 
776 // thirsty function
777     function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint _tokenId){
778         return _tokenOfOwnerByIndex(_owner, _index);
779     }
780 
781 // code duplicated
782     function _tokenOfOwnerByIndex(address _owner, uint _index) private view returns (uint _tokenId){
783         // The index should be valid.
784         require(_index < balanceOf(_owner));
785 
786         // can loop through all without
787         uint256 seen = 0;
788         uint256 totalTokens = totalSupply();
789 
790         for (uint i = 0; i < totalTokens; i++) {
791             if (partIndexToOwner[i] == _owner) {
792                 if (seen == _index) {
793                     return i;
794                 }
795                 seen++;
796             }
797         }
798     }
799 
800     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId){
801         return _tokenOfOwnerByIndex(_owner, _index);
802     }
803 }
804 
805 // the contract which all battles must implement
806 // allows for different types of battles to take place
807 contract PerkTree is EtherbotsNFT {
808     // The perktree is represented in a uint8[32] representing a binary tree
809     // see the number of perks active
810     // buy a new perk
811     // 0: Prestige level -> starts at 0;
812     // next row of tree
813     // 1: offensive moves 2: defensive moves
814     // next row of tree
815     // 3: melee attack 4: turret shooting 5: defend arm 6: body dodge
816     // next row of tree
817     // 7: mech melee 8: android melee 9: mech turret 10: android turret
818     // 11: mech defence 12: android defence 13: mech body 14: android body
819     //next row of tree
820     // 15: melee electric 16: melee steel 17: melee fire 18: melee water
821     // 19: turret electric 20: turret steel 21: turret fire 22: turret water
822     // 23: defend electric 24: defend steel 25: defend fire 26: defend water
823     // 27: body electric 28: body steel 29: body fire 30: body water
824     function _leftChild(uint8 _i) internal pure returns (uint8) {
825         return 2*_i + 1;
826     }
827     function _rightChild(uint8 _i) internal pure returns (uint8) {
828         return 2*_i + 2;
829     }
830     function _parent(uint8 _i) internal pure returns (uint8) {
831         return (_i-1)/2;
832     }
833 
834 
835     uint8 constant PRESTIGE_INDEX = 0;
836     uint8 constant PERK_COUNT = 30;
837 
838     event PrintPerk(string,uint8,uint8[32]);
839 
840     function _isValidPerkToAdd(uint8[32] _perks, uint8 _index) internal pure returns (bool) {
841         // a previously unlocked perk is not a valid perk to add.
842         if ((_index==PRESTIGE_INDEX) || (_perks[_index] > 0)) {
843             return false;
844         }
845         // perk not valid if any ancestor not unlocked
846         for (uint8 i = _parent(_index); i > PRESTIGE_INDEX; i = _parent(i)) {
847             if (_perks[i] == 0) {
848                 return false;
849             }
850         }
851         return true;
852     }
853 
854     // sum of perks (excluding prestige)
855     function _sumActivePerks(uint8[32] _perks) internal pure returns (uint256) {
856         uint32 sum = 0;
857         //sum from after prestige_index, to count+1 (for prestige index).
858         for (uint8 i = PRESTIGE_INDEX+1; i < PERK_COUNT+1; i++) {
859             sum += _perks[i];
860         }
861         return sum;
862     }
863 
864     // you can unlock a new perk every two levels (including prestige when possible)
865     function choosePerk(uint8 _i) external {
866         require((_i >= PRESTIGE_INDEX) && (_i < PERK_COUNT+1));
867         User storage currentUser = addressToUser[msg.sender];
868         uint256 _numActivePerks = _sumActivePerks(currentUser.perks);
869         bool canPrestige = (_numActivePerks == PERK_COUNT);
870 
871         //add prestige value to sum of perks
872         _numActivePerks += currentUser.perks[PRESTIGE_INDEX] * PERK_COUNT;
873         require(_numActivePerks < getLevel(currentUser.experience) / 2);
874 
875         if (_i == PRESTIGE_INDEX) {
876             require(canPrestige);
877             _prestige();
878         } else {
879             require(_isValidPerkToAdd(currentUser.perks, _i));
880             _addPerk(_i);
881         }
882         PerkChosen(msg.sender, _i);
883     }
884 
885     function _addPerk(uint8 perk) internal {
886         addressToUser[msg.sender].perks[perk]++;
887     }
888 
889     function _prestige() internal {
890         User storage currentUser = addressToUser[msg.sender];
891         for (uint8 i = 1; i < currentUser.perks.length; i++) {
892             currentUser.perks[i] = 0;
893         }
894         currentUser.perks[PRESTIGE_INDEX]++;
895     }
896 
897     event PerkChosen(address indexed upgradedUser, uint8 indexed perk);
898 
899 }
900 
901 // Central collection of storage on which all other contracts depend.
902 // Contains structs for parts, users and functions which control their
903 // transferrence.
904 
905 
906 // Auction contract, facilitating statically priced sales, as well as 
907 // inflationary and deflationary pricing for items.
908 // Relies heavily on the ERC721 interface and so most of the methods
909 // are tightly bound to that implementation
910 contract NFTAuctionBase is Pausable {
911 
912     ERC721AllImplementations public nftContract;
913     uint256 public ownerCut;
914     uint public minDuration;
915     uint public maxDuration;
916 
917     // Represents an auction on an NFT (in this case, Robot part)
918     struct Auction {
919         // address of part owner
920         address seller;
921         // wei price of listing
922         uint256 startPrice;
923         // wei price of floor
924         uint256 endPrice;
925         // duration of sale in seconds.
926         uint64 duration;
927         // Time when sale started
928         // Reset to 0 after sale concluded
929         uint64 start;
930     }
931 
932     function NFTAuctionBase() public {
933         minDuration = 60 minutes;
934         maxDuration = 30 days; // arbitrary
935     }
936 
937     // map of all tokens and their auctions
938     mapping (uint256 => Auction) tokenIdToAuction;
939 
940     event AuctionCreated(uint256 tokenId, uint256 startPrice, uint256 endPrice, uint64 duration, uint64 start);
941     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
942     event AuctionCancelled(uint256 tokenId);
943 
944     // returns true if the token with id _partId is owned by the _claimant address
945     function _owns(address _claimant, uint256 _partId) internal view returns (bool) {
946         return nftContract.ownerOf(_partId) == _claimant;
947     }
948 
949    // returns false if auction start time is 0, likely from uninitialised struct
950     function _isActiveAuction(Auction _auction) internal pure returns (bool) {
951         return _auction.start > 0;
952     }
953     
954     // assigns ownership of the token with id = _partId to this contract
955     // must have already been approved
956     function _escrow(address, uint _partId) internal {
957         // throws on transfer fail
958         nftContract.takeOwnership(_partId);
959     }
960 
961     // transfer the token with id = _partId to buying address
962     function _transfer(address _purchasor, uint256 _partId) internal {
963         // successful purchaseder must takeOwnership of _partId
964         // nftContract.approve(_purchasor, _partId); 
965                // actual transfer
966                 nftContract.transfer(_purchasor, _partId);
967 
968     }
969 
970     // creates
971     function _newAuction(uint256 _partId, Auction _auction) internal {
972 
973         require(_auction.duration >= minDuration);
974         require(_auction.duration <= maxDuration);
975 
976         tokenIdToAuction[_partId] = _auction;
977 
978         AuctionCreated(uint256(_partId),
979             uint256(_auction.startPrice),
980             uint256(_auction.endPrice),
981             uint64(_auction.duration),
982             uint64(_auction.start)
983         );
984     }
985 
986     function setMinDuration(uint _duration) external onlyOwner {
987         minDuration = _duration;
988     }
989 
990     function setMaxDuration(uint _duration) external onlyOwner {
991         maxDuration = _duration;
992     }
993 
994     /// Removes auction from public view, returns token to the seller
995     function _cancelAuction(uint256 _partId, address _seller) internal {
996         _removeAuction(_partId);
997         _transfer(_seller, _partId);
998         AuctionCancelled(_partId);
999     }
1000 
1001     event PrintEvent(string, address, uint);
1002 
1003     // Calculates price and transfers purchase to owner. Part is NOT transferred to buyer.
1004     function _purchase(uint256 _partId, uint256 _purchaseAmount) internal returns (uint256) {
1005 
1006         Auction storage auction = tokenIdToAuction[_partId];
1007 
1008         // check that this token is being auctioned
1009         require(_isActiveAuction(auction));
1010 
1011         // enforce purchase >= the current price
1012         uint256 price = _currentPrice(auction);
1013         require(_purchaseAmount >= price);
1014 
1015         // Store seller before we delete auction.
1016         address seller = auction.seller;
1017 
1018         // Valid purchase. Remove auction to prevent reentrancy.
1019         _removeAuction(_partId);
1020 
1021         // Transfer proceeds to seller (if there are any!)
1022         if (price > 0) {
1023             
1024             // Calculate and take fee from purchase
1025 
1026             uint256 auctioneerCut = _computeFee(price);
1027             uint256 sellerProceeds = price - auctioneerCut;
1028 
1029             PrintEvent("Seller, proceeds", seller, sellerProceeds);
1030 
1031             // Pay the seller
1032             seller.transfer(sellerProceeds);
1033         }
1034 
1035         // Calculate excess funds and return to buyer.
1036         uint256 purchaseExcess = _purchaseAmount - price;
1037 
1038         PrintEvent("Sender, excess", msg.sender, purchaseExcess);
1039         // Return any excess funds. Reentrancy again prevented by deleting auction.
1040         msg.sender.transfer(purchaseExcess);
1041 
1042         AuctionSuccessful(_partId, price, msg.sender);
1043 
1044         return price;
1045     }
1046 
1047     // returns the current price of the token being auctioned in _auction
1048     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
1049         uint256 secsElapsed = now - _auction.start;
1050         return _computeCurrentPrice(
1051             _auction.startPrice,
1052             _auction.endPrice,
1053             _auction.duration,
1054             secsElapsed
1055         );
1056     }
1057 
1058     // Checks if NFTPart is currently being auctioned.
1059     // function _isBeingAuctioned(Auction storage _auction) internal view returns (bool) {
1060     //     return (_auction.start > 0);
1061     // }
1062 
1063     // removes the auction of the part with id _partId
1064     function _removeAuction(uint256 _partId) internal {
1065         delete tokenIdToAuction[_partId];
1066     }
1067 
1068     // computes the current price of an deflating-price auction 
1069     function _computeCurrentPrice( uint256 _startPrice, uint256 _endPrice, uint256 _duration, uint256 _secondsPassed ) internal pure returns (uint256 _price) {
1070         _price = _startPrice;
1071         if (_secondsPassed >= _duration) {
1072             // Has been up long enough to hit endPrice.
1073             // Return this price floor.
1074             _price = _endPrice;
1075             // this is a statically price sale. Just return the price.
1076         }
1077         else if (_duration > 0) {
1078             // This auction contract supports auctioning from any valid price to any other valid price.
1079             // This means the price can dynamically increase upward, or downard.
1080             int256 priceDifference = int256(_endPrice) - int256(_startPrice);
1081             int256 currentPriceDifference = priceDifference * int256(_secondsPassed) / int256(_duration);
1082             int256 currentPrice = int256(_startPrice) + currentPriceDifference;
1083 
1084             _price = uint256(currentPrice);
1085         }
1086         return _price;
1087     }
1088 
1089     // Compute percentage fee of transaction
1090 
1091     function _computeFee (uint256 _price) internal view returns (uint256) {
1092         return _price * ownerCut / 10000; 
1093     }
1094 
1095 }
1096 
1097 // Clock auction for NFTParts.
1098 // Only timed when pricing is dynamic (i.e. startPrice != endPrice).
1099 // Else, this becomes an infinite duration statically priced sale,
1100 // resolving when succesfully purchase for or cancelled.
1101 
1102 contract DutchAuction is NFTAuctionBase, EtherbotsPrivileges {
1103 
1104     // The ERC-165 interface signature for ERC-721.
1105     bytes4 constant InterfaceSignature_ERC721 = bytes4(0xda671b9b);
1106  
1107     function DutchAuction(address _nftAddress, uint256 _fee) public {
1108         require(_fee <= 10000);
1109         ownerCut = _fee;
1110 
1111         ERC721AllImplementations candidateContract = ERC721AllImplementations(_nftAddress);
1112         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1113         nftContract = candidateContract;
1114     }
1115 
1116     // Remove all ether from the contract. This will be marketplace fees.
1117     // Transfers to the NFT contract. 
1118     // Can be called by owner or NFT contract.
1119 
1120     function withdrawBalance() external {
1121         address nftAddress = address(nftContract);
1122 
1123         require(msg.sender == owner || msg.sender == nftAddress);
1124 
1125         nftAddress.transfer(this.balance);
1126     }
1127 
1128     event PrintEvent(string, address, uint);
1129 
1130     // Creates an auction and lists it.
1131     function createAuction( uint256 _partId, uint256 _startPrice, uint256 _endPrice, uint256 _duration, address _seller ) external whenNotPaused {
1132         // Sanity check that no inputs overflow how many bits we've allocated
1133         // to store them in the auction struct.
1134         require(_startPrice == uint256(uint128(_startPrice)));
1135         require(_endPrice == uint256(uint128(_endPrice)));
1136         require(_duration == uint256(uint64(_duration)));
1137         require(_startPrice >= _endPrice);
1138 
1139         require(msg.sender == address(nftContract));
1140         _escrow(_seller, _partId);
1141         Auction memory auction = Auction(
1142             _seller,
1143             uint128(_startPrice),
1144             uint128(_endPrice),
1145             uint64(_duration),
1146             uint64(now) //seconds uint 
1147         );
1148         PrintEvent("Auction Start", 0x0, auction.start);
1149         _newAuction(_partId, auction);
1150     }
1151 
1152 
1153     // SCRAPYARD PRICING LOGIC
1154 
1155     uint8 constant LAST_CONSIDERED = 5;
1156     uint8 public scrapCounter = 0;
1157     uint[5] public lastScrapPrices;
1158     
1159     // Purchases an open auction
1160     // Will transfer ownership if successful.
1161     
1162     function purchase(uint256 _partId) external payable whenNotPaused {
1163         address seller = tokenIdToAuction[_partId].seller;
1164 
1165         // _purchase will throw if the purchase or funds transfer fails
1166         uint256 price = _purchase(_partId, msg.value);
1167         _transfer(msg.sender, _partId);
1168         
1169         // If the seller is the scrapyard, track price information.
1170         if (seller == address(nftContract)) {
1171 
1172             lastScrapPrices[scrapCounter] = price;
1173             if (scrapCounter == LAST_CONSIDERED - 1) {
1174                 scrapCounter = 0;
1175             } else {
1176                 scrapCounter++;
1177             }
1178         }
1179     }
1180 
1181     function averageScrapPrice() public view returns (uint) {
1182         uint sum = 0;
1183         for (uint8 i = 0; i < LAST_CONSIDERED; i++) {
1184             sum += lastScrapPrices[i];
1185         }
1186         return sum / LAST_CONSIDERED;
1187     }
1188 
1189     // Allows a user to cancel an auction before it's resolved.
1190     // Returns the part to the seller.
1191 
1192     function cancelAuction(uint256 _partId) external {
1193         Auction storage auction = tokenIdToAuction[_partId];
1194         require(_isActiveAuction(auction));
1195         address seller = auction.seller;
1196         require(msg.sender == seller);
1197         _cancelAuction(_partId, seller);
1198     }
1199 
1200     // returns the current price of the auction of a token with id _partId
1201     function getCurrentPrice(uint256 _partId) external view returns (uint256) {
1202         Auction storage auction = tokenIdToAuction[_partId];
1203         require(_isActiveAuction(auction));
1204         return _currentPrice(auction);
1205     }
1206 
1207     //  Returns the details of an auction from its _partId.
1208     function getAuction(uint256 _partId) external view returns ( address seller, uint256 startPrice, uint256 endPrice, uint256 duration, uint256 startedAt ) {
1209         Auction storage auction = tokenIdToAuction[_partId];
1210         require(_isActiveAuction(auction));
1211         return ( auction.seller, auction.startPrice, auction.endPrice, auction.duration, auction.start);
1212     }
1213 
1214     // Allows owner to cancel an auction.
1215     // ONLY able to be used when contract is paused,
1216     // in the case of emergencies.
1217     // Parts returned to seller as it's equivalent to them 
1218     // calling cancel.
1219     function cancelAuctionWhenPaused(uint256 _partId) whenPaused onlyOwner external {
1220         Auction storage auction = tokenIdToAuction[_partId];
1221         require(_isActiveAuction(auction));
1222         _cancelAuction(_partId, auction.seller);
1223     }
1224 }
1225 
1226 contract EtherbotsAuction is PerkTree {
1227 
1228     // Sets the reference to the sale auction.
1229 
1230     function setAuctionAddress(address _address) external onlyOwner {
1231         require(_address != address(0));
1232         DutchAuction candidateContract = DutchAuction(_address);
1233 
1234         // Set the new contract address
1235         auction = candidateContract;
1236     }
1237 
1238     // list a part for auction.
1239 
1240     function createAuction(
1241         uint256 _partId,
1242         uint256 _startPrice,
1243         uint256 _endPrice,
1244         uint256 _duration ) external whenNotPaused 
1245     {
1246 
1247 
1248         // user must have current control of the part
1249         // will lose control if they delegate to the auction
1250         // therefore no duplicate auctions!
1251         require(owns(msg.sender, _partId));
1252 
1253         _approve(_partId, auction);
1254 
1255         // will throw if inputs are invalid
1256         // will clear transfer approval
1257         DutchAuction(auction).createAuction(_partId,_startPrice,_endPrice,_duration,msg.sender);
1258     }
1259 
1260     // transfer balance back to core contract
1261     function withdrawAuctionBalance() external onlyOwner {
1262         DutchAuction(auction).withdrawBalance();
1263     }
1264 
1265     // SCRAP FUNCTION
1266   
1267     // This takes scrapped parts and automatically relists them on the market.
1268     // Provides a good floor for entrance into the game, while keeping supply
1269     // constant as these parts were already in circulation.
1270 
1271     // uint public constant SCRAPYARD_STARTING_PRICE = 0.1 ether;
1272     uint scrapMinStartPrice = 0.05 ether; // settable minimum starting price for sanity
1273     uint scrapMinEndPrice = 0.005 ether;  // settable minimum ending price for sanity
1274     uint scrapAuctionDuration = 2 days;
1275     
1276     function setScrapMinStartPrice(uint _newMinStartPrice) external onlyOwner {
1277         scrapMinStartPrice = _newMinStartPrice;
1278     }
1279     function setScrapMinEndPrice(uint _newMinEndPrice) external onlyOwner {
1280         scrapMinEndPrice = _newMinEndPrice;
1281     }
1282     function setScrapAuctionDuration(uint _newScrapAuctionDuration) external onlyOwner {
1283         scrapAuctionDuration = _newScrapAuctionDuration;
1284     }
1285  
1286     function _createScrapPartAuction(uint _scrapPartId) internal {
1287         // if (scrapyard == address(this)) {
1288         _approve(_scrapPartId, auction);
1289         
1290         DutchAuction(auction).createAuction(
1291             _scrapPartId,
1292             _getNextAuctionPrice(), // gen next auction price
1293             scrapMinEndPrice,
1294             scrapAuctionDuration,
1295             address(this)
1296         );
1297         // }
1298     }
1299 
1300     function _getNextAuctionPrice() internal view returns (uint) {
1301         uint avg = DutchAuction(auction).averageScrapPrice();
1302         // add 30% to the average
1303         // prevent runaway pricing
1304         uint next = avg + ((30 * avg) / 100);
1305         if (next < scrapMinStartPrice) {
1306             next = scrapMinStartPrice;
1307         }
1308         return next;
1309     }
1310 
1311 }
1312 
1313 contract PerksRewards is EtherbotsAuction {
1314     ///  An internal method that creates a new part and stores it. This
1315     ///  method doesn't do any checking and should only be called when the
1316     ///  input data is known to be valid. Will generate both a Forge event
1317     ///  and a Transfer event.
1318    function _createPart(uint8[4] _partArray, address _owner) internal returns (uint) {
1319         uint32 newPartId = uint32(parts.length);
1320         assert(newPartId == parts.length);
1321 
1322         Part memory _part = Part({
1323             tokenId: newPartId,
1324             partType: _partArray[0],
1325             partSubType: _partArray[1],
1326             rarity: _partArray[2],
1327             element: _partArray[3],
1328             battlesLastDay: 0,
1329             experience: 0,
1330             forgeTime: uint32(now),
1331             battlesLastReset: uint32(now)
1332         });
1333         assert(newPartId == parts.push(_part) - 1);
1334 
1335         // emit the FORGING!!!
1336         Forge(_owner, newPartId, _part);
1337 
1338         // This will assign ownership, and also emit the Transfer event as
1339         // per ERC721 draft
1340         _transfer(0, _owner, newPartId);
1341 
1342         return newPartId;
1343     }
1344 
1345     uint public PART_REWARD_CHANCE = 995;
1346     // Deprecated subtypes contain the subtype IDs of legacy items
1347     // which are no longer available to be redeemed in game.
1348     // i.e. subtype ID 14 represents lambo body, presale exclusive.
1349     // a value of 0 represents that subtype (id within range)
1350     // as being deprecated for that part type (body, turret, etc)
1351     uint8[] public defenceElementBySubtypeIndex;
1352     uint8[] public meleeElementBySubtypeIndex;
1353     uint8[] public bodyElementBySubtypeIndex;
1354     uint8[] public turretElementBySubtypeIndex;
1355     // uint8[] public defenceElementBySubtypeIndex = [1,2,4,3,4,1,3,3,2,1,4];
1356     // uint8[] public meleeElementBySubtypeIndex = [3,1,3,2,3,4,2,2,1,1,1,1,4,4];
1357     // uint8[] public bodyElementBySubtypeIndex = [2,1,2,3,4,3,1,1,4,2,3,4,1,0,1]; // no more lambos :'(
1358     // uint8[] public turretElementBySubtypeIndex = [4,3,2,1,2,1,1,3,4,3,4];
1359 
1360     function setRewardChance(uint _newChance) external onlyOwner {
1361         require(_newChance > 980); // not too hot
1362         require(_newChance <= 1000); // not too cold
1363         PART_REWARD_CHANCE = _newChance; // just right
1364         // come at me goldilocks
1365     }
1366     // The following functions DON'T create parts, they add new parts
1367     // as possible rewards from the reward pool.
1368 
1369 
1370     function addDefenceParts(uint8[] _newElement) external onlyOwner {
1371         for (uint8 i = 0; i < _newElement.length; i++) {
1372             defenceElementBySubtypeIndex.push(_newElement[i]);
1373         }
1374         // require(defenceElementBySubtypeIndex.length < uint(uint8(-1)));
1375     }
1376     function addMeleeParts(uint8[] _newElement) external onlyOwner {
1377         for (uint8 i = 0; i < _newElement.length; i++) {
1378             meleeElementBySubtypeIndex.push(_newElement[i]);
1379         }
1380         // require(meleeElementBySubtypeIndex.length < uint(uint8(-1)));
1381     }
1382     function addBodyParts(uint8[] _newElement) external onlyOwner {
1383         for (uint8 i = 0; i < _newElement.length; i++) {
1384             bodyElementBySubtypeIndex.push(_newElement[i]);
1385         }
1386         // require(bodyElementBySubtypeIndex.length < uint(uint8(-1)));
1387     }
1388     function addTurretParts(uint8[] _newElement) external onlyOwner {
1389         for (uint8 i = 0; i < _newElement.length; i++) {
1390             turretElementBySubtypeIndex.push(_newElement[i]);
1391         }
1392         // require(turretElementBySubtypeIndex.length < uint(uint8(-1)));
1393     }
1394     // Deprecate subtypes. Once a subtype has been deprecated it can never be
1395     // undeprecated. Starting with lambo!
1396     function deprecateDefenceSubtype(uint8 _subtypeIndexToDeprecate) external onlyOwner {
1397         defenceElementBySubtypeIndex[_subtypeIndexToDeprecate] = 0;
1398     }
1399 
1400     function deprecateMeleeSubtype(uint8 _subtypeIndexToDeprecate) external onlyOwner {
1401         meleeElementBySubtypeIndex[_subtypeIndexToDeprecate] = 0;
1402     }
1403 
1404     function deprecateBodySubtype(uint8 _subtypeIndexToDeprecate) external onlyOwner {
1405         bodyElementBySubtypeIndex[_subtypeIndexToDeprecate] = 0;
1406     }
1407 
1408     function deprecateTurretSubtype(uint8 _subtypeIndexToDeprecate) external onlyOwner {
1409         turretElementBySubtypeIndex[_subtypeIndexToDeprecate] = 0;
1410     }
1411 
1412     // function _randomIndex(uint _rand, uint8 _startIx, uint8 _endIx, uint8 _modulo) internal pure returns (uint8) {
1413     //     require(_startIx < _endIx);
1414     //     bytes32 randBytes = bytes32(_rand);
1415     //     uint result = 0;
1416     //     for (uint8 i=_startIx; i<_endIx; i++) {
1417     //         result = result | uint8(randBytes[i]);
1418     //         result << 8;
1419     //     }
1420     //     uint8 resultInt = uint8(uint(result) % _modulo);
1421     //     return resultInt;
1422     // }
1423 
1424 
1425     // This function takes a random uint, an owner and randomly generates a valid part.
1426     // It then transfers that part to the owner.
1427     function _generateRandomPart(uint _rand, address _owner) internal {
1428         // random uint 20 in length - MAYBE 20.
1429         // first randomly gen a part type
1430         _rand = uint(keccak256(_rand));
1431         uint8[4] memory randomPart;
1432         randomPart[0] = uint8(_rand % 4) + 1;
1433         _rand = uint(keccak256(_rand));
1434 
1435         // randomPart[0] = _randomIndex(_rand,0,4,4) + 1; // 1, 2, 3, 4, => defence, melee, body, turret
1436 
1437         if (randomPart[0] == DEFENCE) {
1438             randomPart[1] = _getRandomPartSubtype(_rand,defenceElementBySubtypeIndex);
1439             randomPart[3] = _getElement(defenceElementBySubtypeIndex, randomPart[1]);
1440 
1441         } else if (randomPart[0] == MELEE) {
1442             randomPart[1] = _getRandomPartSubtype(_rand,meleeElementBySubtypeIndex);
1443             randomPart[3] = _getElement(meleeElementBySubtypeIndex, randomPart[1]);
1444 
1445         } else if (randomPart[0] == BODY) {
1446             randomPart[1] = _getRandomPartSubtype(_rand,bodyElementBySubtypeIndex);
1447             randomPart[3] = _getElement(bodyElementBySubtypeIndex, randomPart[1]);
1448 
1449         } else if (randomPart[0] == TURRET) {
1450             randomPart[1] = _getRandomPartSubtype(_rand,turretElementBySubtypeIndex);
1451             randomPart[3] = _getElement(turretElementBySubtypeIndex, randomPart[1]);
1452 
1453         }
1454         _rand = uint(keccak256(_rand));
1455         randomPart[2] = _getRarity(_rand);
1456         // randomPart[2] = _getRarity(_randomIndex(_rand,8,12,3)); // rarity
1457         _createPart(randomPart, _owner);
1458     }
1459 
1460     function _getRandomPartSubtype(uint _rand, uint8[] elementBySubtypeIndex) internal pure returns (uint8) {
1461         require(elementBySubtypeIndex.length < uint(uint8(-1)));
1462         uint8 subtypeLength = uint8(elementBySubtypeIndex.length);
1463         require(subtypeLength > 0);
1464         uint8 subtypeIndex = uint8(_rand % subtypeLength);
1465         // uint8 subtypeIndex = _randomIndex(_rand,4,8,subtypeLength);
1466         uint8 count = 0;
1467         while (elementBySubtypeIndex[subtypeIndex] == 0) {
1468             subtypeIndex++;
1469             count++;
1470             if (subtypeIndex == subtypeLength) {
1471                 subtypeIndex = 0;
1472             }
1473             if (count > subtypeLength) {
1474                 break;
1475             }
1476         }
1477         require(elementBySubtypeIndex[subtypeIndex] != 0);
1478         return subtypeIndex + 1;
1479     }
1480 
1481 
1482     function _getRarity(uint rand) pure internal returns (uint8) {
1483         uint16 rarity = uint16(rand % 1000);
1484         if (rarity >= 990) {  // 1% chance of gold
1485           return GOLD;
1486         } else if (rarity >= 970) { // 2% chance of shadow
1487           return SHADOW;
1488         } else {
1489           return STANDARD;
1490         }
1491     }
1492 
1493     function _getElement(uint8[] elementBySubtypeIndex, uint8 subtype) internal pure returns (uint8) {
1494         uint8 subtypeIndex = subtype - 1;
1495         return elementBySubtypeIndex[subtypeIndex];
1496     }
1497 
1498     mapping(address => uint[]) pendingPartCrates ;
1499 
1500     function getPendingPartCrateLength() external view returns (uint) {
1501         return pendingPartCrates[msg.sender].length;
1502     }
1503 
1504     /// Put shards together into a new part-crate
1505     function redeemShardsIntoPending() external {
1506         User storage user = addressToUser[msg.sender];
1507          while (user.numShards >= SHARDS_TO_PART) {
1508              user.numShards -= SHARDS_TO_PART;
1509              pendingPartCrates[msg.sender].push(block.number);
1510              // 256 blocks to redeem
1511          }
1512     }
1513 
1514     function openPendingPartCrates() external {
1515         uint[] memory crates = pendingPartCrates[msg.sender];
1516         for (uint i = 0; i < crates.length; i++) {
1517             uint pendingBlockNumber = crates[i];
1518             // can't open on the same timestamp
1519             require(block.number > pendingBlockNumber);
1520 
1521             var hash = block.blockhash(pendingBlockNumber);
1522 
1523             if (uint(hash) != 0) {
1524                 // different results for all different crates, even on the same block/same user
1525                 // randomness is already taken care of
1526                 uint rand = uint(keccak256(hash, msg.sender, i)); // % (10 ** 20);
1527                 _generateRandomPart(rand, msg.sender);
1528             } else {
1529                 // Do nothing, no second chances to secure integrity of randomness.
1530             }
1531         }
1532         delete pendingPartCrates[msg.sender];
1533     }
1534 
1535     uint32 constant SHARDS_MAX = 10000;
1536 
1537     function _addShardsToUser(User storage _user, uint32 _shards) internal {
1538         uint32 updatedShards = _user.numShards + _shards;
1539         if (updatedShards > SHARDS_MAX) {
1540             updatedShards = SHARDS_MAX;
1541         }
1542         _user.numShards = updatedShards;
1543         ShardsAdded(msg.sender, _shards);
1544     }
1545 
1546     // FORGING / SCRAPPING
1547     event ShardsAdded(address caller, uint32 shards);
1548     event Scrap(address user, uint partId);
1549 
1550     uint32 constant SHARDS_TO_PART = 500;
1551     uint8 public scrapPercent = 60;
1552     uint8 public burnRate = 60; 
1553 
1554     function setScrapPercent(uint8 _newPercent) external onlyOwner {
1555         require((_newPercent >= 50) && (_newPercent <= 90));
1556         scrapPercent = _newPercent;
1557     }
1558 
1559     // function setScrapyard(address _scrapyard) external onlyOwner {
1560     //     scrapyard = _scrapyard;
1561     // }
1562 
1563     function setBurnRate(uint8 _rate) external onlyOwner {
1564         burnRate = _rate;
1565     }
1566 
1567 
1568     uint public scrapCount = 0;
1569 
1570     // scraps a part for shards
1571     function scrap(uint partId) external {
1572         require(owns(msg.sender, partId));
1573         User storage u = addressToUser[msg.sender];
1574         _addShardsToUser(u, (SHARDS_TO_PART * scrapPercent) / 100);
1575         Scrap(msg.sender, partId);
1576         // this doesn't need to be secure
1577         // no way to manipulate it apart from guaranteeing your parts are resold
1578         // or burnt
1579         if (uint(keccak256(scrapCount)) % 100 >= burnRate) {
1580             _transfer(msg.sender, address(this), partId);
1581             _createScrapPartAuction(partId);
1582         } else {
1583             _transfer(msg.sender, address(0), partId);
1584         }
1585         scrapCount++;
1586     }
1587 
1588 }
1589 
1590 contract Mint is PerksRewards {
1591     
1592     // Owner only function to give an address new parts.
1593     // Strictly capped at 5000.
1594     // This will ONLY be used for promotional purposes (i.e. providing items for Wax/OPSkins partnership)
1595     // which we don't benefit financially from, or giving users who win the prize of designing a part 
1596     // for the game, a single copy of that part.
1597     
1598     uint16 constant MINT_LIMIT = 5000;
1599     uint16 public partsMinted = 0;
1600 
1601     function mintParts(uint16 _count, address _owner) public onlyOwner {
1602         require(_count > 0 && _count <= 50);
1603         // check overflow
1604         require(partsMinted + _count > partsMinted);
1605         require(partsMinted + _count < MINT_LIMIT);
1606         
1607         addressToUser[_owner].numShards += SHARDS_TO_PART * _count;
1608         
1609         partsMinted += _count;
1610     }       
1611 
1612     function mintParticularPart(uint8[4] _partArray, address _owner) public onlyOwner {
1613         require(partsMinted < MINT_LIMIT);
1614         /* cannot create deprecated parts
1615         for (uint i = 0; i < deprecated.length; i++) {
1616             if (_partArray[2] == deprecated[i]) {
1617                 revert();
1618             }
1619         } */
1620         _createPart(_partArray, _owner);
1621         partsMinted++;
1622     }
1623 
1624 }
1625 
1626 
1627 
1628 
1629 contract NewCratePreSale {
1630     
1631     // migration functions migrate the data from the previous contract in stages
1632     // all addresses are included for transparency and easy verification
1633     // however addresses with no robots (i.e. failed transaction and never bought properly) have been commented out.
1634     // to view the full list of state assignments, go to etherscan.io/address/{address} and you can view the verified
1635     mapping (address => uint[]) public userToRobots; 
1636 
1637     function _migrate(uint _index) external onlyOwner {
1638         bytes4 selector = bytes4(keccak256("setData()"));
1639         address a = migrators[_index];
1640         require(a.delegatecall(selector));
1641     }
1642     // source code - feel free to verify the migration
1643     address[6] migrators = [
1644         0x700FeBD9360ac0A0a72F371615427Bec4E4454E5, //0x97AE01893E42d6d33fd9851A28E5627222Af7BBB,
1645         0x72Cc898de0A4EAC49c46ccb990379099461342f6,
1646         0xc3cC48da3B8168154e0f14Bf0446C7a93613F0A7,
1647         0x4cC96f2Ddf6844323ae0d8461d418a4D473b9AC3,
1648         0xa52bFcb5FF599e29EE2B9130F1575BaBaa27de0A,
1649         0xe503b42AabdA22974e2A8B75Fa87E010e1B13584
1650     ];
1651     
1652     function NewCratePreSale() public payable {
1653         
1654             owner = msg.sender;
1655         // one time transfer of state from the previous contract
1656         // var previous = CratePreSale(0x3c7767011C443EfeF2187cf1F2a4c02062da3998); //MAINNET
1657 
1658         // oldAppreciationRateWei = previous.appreciationRateWei();
1659         oldAppreciationRateWei = 100000000000000;
1660         appreciationRateWei = oldAppreciationRateWei;
1661   
1662         // oldPrice = previous.currentPrice();
1663         oldPrice = 232600000000000000;
1664         currentPrice = oldPrice;
1665 
1666         // oldCratesSold = previous.cratesSold();
1667         oldCratesSold = 1075;
1668         cratesSold = oldCratesSold;
1669 
1670         // Migration Rationale
1671         // due to solidity issues with enumerability (contract calls cannot return dynamic arrays etc)
1672         // no need for trust -> can still use web3 to call the previous contract and check the state
1673         // will only change in the future if people send more eth
1674         // and will be obvious due to change in crate count. Any purchases on the old contract
1675         // after this contract is deployed will be fully refunded, and those robots bought will be voided. 
1676         // feel free to validate any address on the old etherscan:
1677         // https://etherscan.io/address/0x3c7767011C443EfeF2187cf1F2a4c02062da3998
1678         // can visit the exact contracts at the addresses listed above
1679     }
1680 
1681     // ------ STATE ------
1682     uint256 constant public MAX_CRATES_TO_SELL = 3900; // Max no. of robot crates to ever be sold
1683     uint256 constant public PRESALE_END_TIMESTAMP = 1518699600; // End date for the presale - no purchases can be made after this date - Midnight 16 Feb 2018 UTC
1684 
1685     uint256 public appreciationRateWei;
1686     uint32 public cratesSold;
1687     uint256 public currentPrice;
1688 
1689     // preserve these for later verification
1690     uint32 public oldCratesSold;
1691     uint256 public oldPrice;
1692     uint256 public oldAppreciationRateWei;
1693     // mapping (address => uint32) public userCrateCount; // replaced with more efficient method
1694     
1695 
1696     // store the unopened crates of this user
1697     // actually stores the blocknumber of each crate 
1698     mapping (address => uint[]) public addressToPurchasedBlocks;
1699     // store the number of expired crates for each user 
1700     // i.e. crates where the user failed to open the crate within 256 blocks (~1 hour)
1701     // these crates will be able to be opened post-launch
1702     mapping (address => uint) public expiredCrates;
1703     // store the part information of purchased crates
1704 
1705 
1706 
1707     function openAll() public {
1708         uint len = addressToPurchasedBlocks[msg.sender].length;
1709         require(len > 0);
1710         uint8 count = 0;
1711         // len > i to stop predicatable wraparound
1712         for (uint i = len - 1; i >= 0 && len > i; i--) {
1713             uint crateBlock = addressToPurchasedBlocks[msg.sender][i];
1714             require(block.number > crateBlock);
1715             // can't open on the same timestamp
1716             var hash = block.blockhash(crateBlock);
1717             if (uint(hash) != 0) {
1718                 // different results for all different crates, even on the same block/same user
1719                 // randomness is already taken care of
1720                 uint rand = uint(keccak256(hash, msg.sender, i)) % (10 ** 20);
1721                 userToRobots[msg.sender].push(rand);
1722                 count++;
1723             } else {
1724                 // all others will be expired
1725                 expiredCrates[msg.sender] += (i + 1);
1726                 break;
1727             }
1728         }
1729         CratesOpened(msg.sender, count);
1730         delete addressToPurchasedBlocks[msg.sender];
1731     }
1732 
1733     // ------ EVENTS ------
1734     event CratesPurchased(address indexed _from, uint8 _quantity);
1735     event CratesOpened(address indexed _from, uint8 _quantity);
1736 
1737     // ------ FUNCTIONS ------
1738     function getPrice() view public returns (uint256) {
1739         return currentPrice;
1740     }
1741 
1742     function getRobotCountForUser(address _user) external view returns(uint256) {
1743         return userToRobots[_user].length;
1744     }
1745 
1746     function getRobotForUserByIndex(address _user, uint _index) external view returns(uint) {
1747         return userToRobots[_user][_index];
1748     }
1749 
1750     function getRobotsForUser(address _user) view public returns (uint[]) {
1751         return userToRobots[_user];
1752     }
1753 
1754     function getPendingCratesForUser(address _user) external view returns(uint[]) {
1755         return addressToPurchasedBlocks[_user];
1756     }
1757 
1758     function getPendingCrateForUserByIndex(address _user, uint _index) external view returns(uint) {
1759         return addressToPurchasedBlocks[_user][_index];
1760     }
1761 
1762     function getExpiredCratesForUser(address _user) external view returns(uint) {
1763         return expiredCrates[_user];
1764     }
1765 
1766     function incrementPrice() private {
1767         // Decrease the rate of increase of the crate price
1768         // as the crates become more expensive
1769         // to avoid runaway pricing
1770         // (halving rate of increase at 0.1 ETH, 0.2 ETH, 0.3 ETH).
1771         if ( currentPrice == 100000000000000000 ) {
1772             appreciationRateWei = 200000000000000;
1773         } else if ( currentPrice == 200000000000000000) {
1774             appreciationRateWei = 100000000000000;
1775         } else if (currentPrice == 300000000000000000) {
1776             appreciationRateWei = 50000000000000;
1777         }
1778         currentPrice += appreciationRateWei;
1779     }
1780 
1781     function purchaseCrates(uint8 _cratesToBuy) public payable whenNotPaused {
1782         require(now < PRESALE_END_TIMESTAMP); // Check presale is still ongoing.
1783         require(_cratesToBuy <= 10); // Can only buy max 10 crates at a time. Don't be greedy!
1784         require(_cratesToBuy >= 1); // Sanity check. Also, you have to buy a crate. 
1785         require(cratesSold + _cratesToBuy <= MAX_CRATES_TO_SELL); // Check max crates sold is less than hard limit
1786         uint256 priceToPay = _calculatePayment(_cratesToBuy);
1787          require(msg.value >= priceToPay); // Check buyer sent sufficient funds to purchase
1788         if (msg.value > priceToPay) { //overpaid, return excess
1789             msg.sender.transfer(msg.value-priceToPay);
1790         }
1791         //all good, payment received. increment number sold, price, and generate crate receipts!
1792         cratesSold += _cratesToBuy;
1793       for (uint8 i = 0; i < _cratesToBuy; i++) {
1794             incrementPrice();
1795             addressToPurchasedBlocks[msg.sender].push(block.number);
1796         }
1797 
1798         CratesPurchased(msg.sender, _cratesToBuy);
1799     } 
1800 
1801     function _calculatePayment (uint8 _cratesToBuy) private view returns (uint256) {
1802         
1803         uint256 tempPrice = currentPrice;
1804 
1805         for (uint8 i = 1; i < _cratesToBuy; i++) {
1806             tempPrice += (currentPrice + (appreciationRateWei * i));
1807         } // for every crate over 1 bought, add current Price and a multiple of the appreciation rate
1808           // very small edge case of buying 10 when you the appreciation rate is about to halve
1809           // is compensated by the great reduction in gas by buying N at a time.
1810         
1811         return tempPrice;
1812     }
1813 
1814 
1815     //owner only withdrawal function for the presale
1816     function withdraw() onlyOwner public {
1817         owner.transfer(this.balance);
1818     }
1819 
1820     function addFunds() onlyOwner external payable {
1821 
1822     }
1823 
1824   event SetPaused(bool paused);
1825 
1826   // starts unpaused
1827   bool public paused = false;
1828 
1829   modifier whenNotPaused() {
1830     require(!paused);
1831     _;
1832   }
1833 
1834   modifier whenPaused() {
1835     require(paused);
1836     _;
1837   }
1838 
1839   function pause() external onlyOwner whenNotPaused returns (bool) {
1840     paused = true;
1841     SetPaused(paused);
1842     return true;
1843   }
1844 
1845   function unpause() external onlyOwner whenPaused returns (bool) {
1846     paused = false;
1847     SetPaused(paused);
1848     return true;
1849   }
1850 
1851 
1852   address public owner;
1853 
1854   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1855 
1856 
1857 
1858 
1859   modifier onlyOwner() {
1860     require(msg.sender == owner);
1861     _;
1862   }
1863 
1864   function transferOwnership(address newOwner) public onlyOwner {
1865     require(newOwner != address(0));
1866     OwnershipTransferred(owner, newOwner);
1867     owner = newOwner;
1868   }
1869     
1870 }
1871 contract EtherbotsMigrations is Mint {
1872 
1873     event CratesOpened(address indexed _from, uint8 _quantity);
1874     event OpenedOldCrates(address indexed _from);
1875     event MigratedCrates(address indexed _from, uint16 _quantity, bool isMigrationComplete);
1876 
1877     address presale = 0xc23F76aEa00B775AADC8504CcB22468F4fD2261A;
1878     mapping(address => bool) public hasMigrated;
1879     mapping(address => bool) public hasOpenedOldCrates;
1880     mapping(address => uint[]) pendingCrates;
1881     mapping(address => uint16) public cratesMigrated;
1882 
1883   
1884     // Element: copy for MIGRATIONS ONLY.
1885     string constant private DEFENCE_ELEMENT_BY_ID = "12434133214";
1886     string constant private MELEE_ELEMENT_BY_ID = "31323422111144";
1887     string constant private BODY_ELEMENT_BY_ID = "212343114234111";
1888     string constant private TURRET_ELEMENT_BY_ID = "43212113434";
1889 
1890     // Once only function.
1891     // Transfers all pending and expired crates in the old contract
1892     // into pending crates in the current one.
1893     // Users can then open them on the new contract.
1894     // Should only rarely have to be called.
1895     // event oldpending(uint old);
1896 
1897     function openOldCrates() external {
1898         require(hasOpenedOldCrates[msg.sender] == false);
1899         // uint oldPendingCrates = NewCratePreSale(presale).getPendingCrateForUserByIndex(msg.sender,0); // getting unrecognised opcode here --!
1900         // oldpending(oldPendingCrates);
1901         // require(oldPendingCrates == 0);
1902         _migrateExpiredCrates();
1903         hasOpenedOldCrates[msg.sender] = true;
1904         OpenedOldCrates(msg.sender);
1905     }
1906 
1907     function migrate() external whenNotPaused {
1908         
1909         // Can't migrate twice .
1910         require(hasMigrated[msg.sender] == false);
1911         
1912         // require(NewCratePreSale(presale).getPendingCrateForUserByIndex(msg.sender,0) == 0);
1913         // No pending crates in the new contract allowed. Make sure you open them first.
1914         require(pendingCrates[msg.sender].length == 0);
1915         
1916         // If the user has old expired crates, don't let them migrate until they've
1917         // converted them to pending crates in the new contract.
1918         if (NewCratePreSale(presale).getExpiredCratesForUser(msg.sender) > 0) {
1919             require(hasOpenedOldCrates[msg.sender]); 
1920         }
1921 
1922         // have to make a ton of calls unfortunately 
1923         uint16 length = uint16(NewCratePreSale(presale).getRobotCountForUser(msg.sender));
1924 
1925         // gas limit will be exceeded with *whale* etherbot players!
1926         // let's migrate their robots in batches of ten.
1927         // they can afford it
1928         bool isMigrationComplete = false;
1929         var max = length - cratesMigrated[msg.sender];
1930         if (max > 9) {
1931             max = 9;
1932         } else { // final call - all robots will be migrated
1933             isMigrationComplete = true;
1934             hasMigrated[msg.sender] = true;
1935         }
1936         for (uint i = cratesMigrated[msg.sender]; i < cratesMigrated[msg.sender] + max; i++) {
1937             var robot = NewCratePreSale(presale).getRobotForUserByIndex(msg.sender, i);
1938             var robotString = uintToString(robot);
1939             // MigratedBot(robotString);
1940 
1941             _migrateRobot(robotString);
1942             
1943         }
1944         cratesMigrated[msg.sender] += max;
1945         MigratedCrates(msg.sender, cratesMigrated[msg.sender], isMigrationComplete);
1946     }
1947 
1948     function _migrateRobot(string robot) private {
1949         var (melee, defence, body, turret) = _convertBlueprint(robot);
1950         // blueprints event
1951         // blueprints(body, turret, melee, defence);
1952         _createPart(melee, msg.sender);
1953         _createPart(defence, msg.sender);
1954         _createPart(turret, msg.sender);
1955         _createPart(body, msg.sender);
1956     }
1957 
1958     function _getRarity(string original, uint8 low, uint8 high) pure private returns (uint8) {
1959         uint32 rarity = stringToUint32(substring(original,low,high));
1960         if (rarity >= 950) {
1961           return GOLD; 
1962         } else if (rarity >= 850) {
1963           return SHADOW;
1964         } else {
1965           return STANDARD; 
1966         }
1967     }
1968    
1969     function _getElement(string elementString, uint partId) pure private returns(uint8) {
1970         return stringToUint8(substring(elementString, partId-1,partId));
1971     }
1972 
1973     // Actually part type
1974     function _getPartId(string original, uint8 start, uint8 end, uint8 partCount) pure private returns(uint8) {
1975         return (stringToUint8(substring(original,start,end)) % partCount) + 1;
1976     }
1977 
1978     function userPendingCrateNumber(address _user) external view returns (uint) {
1979         return pendingCrates[_user].length;
1980     }    
1981     
1982     // convert old string representation of robot into 4 new ERC721 parts
1983   
1984     function _convertBlueprint(string original) pure private returns(uint8[4] body,uint8[4] melee, uint8[4] turret, uint8[4] defence ) {
1985 
1986         /* ------ CONVERSION TIME ------ */
1987         
1988 
1989         body[0] = BODY; 
1990         body[1] = _getPartId(original, 3, 5, 15);
1991         body[2] = _getRarity(original, 0, 3);
1992         body[3] = _getElement(BODY_ELEMENT_BY_ID, body[1]);
1993         
1994         turret[0] = TURRET;
1995         turret[1] = _getPartId(original, 8, 10, 11);
1996         turret[2] = _getRarity(original, 5, 8);
1997         turret[3] = _getElement(TURRET_ELEMENT_BY_ID, turret[1]);
1998 
1999         melee[0] = MELEE;
2000         melee[1] = _getPartId(original, 13, 15, 14);
2001         melee[2] = _getRarity(original, 10, 13);
2002         melee[3] = _getElement(MELEE_ELEMENT_BY_ID, melee[1]);
2003 
2004         defence[0] = DEFENCE;
2005         var len = bytes(original).length;
2006         // string of number does not have preceding 0's
2007         if (len == 20) {
2008             defence[1] = _getPartId(original, 18, 20, 11);
2009         } else if (len == 19) {
2010             defence[1] = _getPartId(original, 18, 19, 11);
2011         } else { //unlikely to have length less than 19
2012             defence[1] = uint8(1);
2013         }
2014         defence[2] = _getRarity(original, 15, 18);
2015         defence[3] = _getElement(DEFENCE_ELEMENT_BY_ID, defence[1]);
2016 
2017         // implicit return
2018     }
2019 
2020     // give one more chance
2021     function _migrateExpiredCrates() private {
2022         // get the number of expired crates
2023         uint expired = NewCratePreSale(presale).getExpiredCratesForUser(msg.sender);
2024         for (uint i = 0; i < expired; i++) {
2025             pendingCrates[msg.sender].push(block.number);
2026         }
2027     }
2028     // Users can open pending crates on the new contract.
2029     function openCrates() public whenNotPaused {
2030         uint[] memory pc = pendingCrates[msg.sender];
2031         require(pc.length > 0);
2032         uint8 count = 0;
2033         for (uint i = 0; i < pc.length; i++) {
2034             uint crateBlock = pc[i];
2035             require(block.number > crateBlock);
2036             // can't open on the same timestamp
2037             var hash = block.blockhash(crateBlock);
2038             if (uint(hash) != 0) {
2039                 // different results for all different crates, even on the same block/same user
2040                 // randomness is already taken care of
2041                 uint rand = uint(keccak256(hash, msg.sender, i)) % (10 ** 20);
2042                 _migrateRobot(uintToString(rand));
2043                 count++;
2044             }
2045         }
2046         CratesOpened(msg.sender, count);
2047         delete pendingCrates[msg.sender];
2048     }
2049 
2050     
2051 }
2052 
2053 contract Battle {
2054     // This struct does not exist outside the context of a battle
2055 
2056     // the name of the battle type
2057     function name() external view returns (string);
2058     // the number of robots currently battling
2059     function playerCount() external view returns (uint count);
2060     // creates a new battle, with a submitted user string for initial input/
2061     function createBattle(address _creator, uint[] _partIds, bytes32 _commit, uint _revealLength) external payable returns (uint);
2062     // cancels the battle at battleID
2063     function cancelBattle(uint battleID) external;
2064     
2065     function winnerOf(uint battleId, uint index) external view returns (address);
2066     function loserOf(uint battleId, uint index) external view returns (address);
2067 
2068     event BattleCreated(uint indexed battleID, address indexed starter);
2069     event BattleStage(uint indexed battleID, uint8 moveNumber, uint8[2] attackerMovesDefenderMoves, uint16[2] attackerDamageDefenderDamage);
2070     event BattleEnded(uint indexed battleID, address indexed winner);
2071     event BattleConcluded(uint indexed battleID);
2072     event BattlePropertyChanged(string name, uint previous, uint value);
2073 }
2074 contract EtherbotsBattle is EtherbotsMigrations {
2075 
2076     // can never remove any of these contracts, can only add
2077     // once we publish a contract, you'll always be able to play by that ruleset
2078     // good for two player games which are non-susceptible to collusion
2079     // people can be trusted to choose the most beneficial outcome, which in this case
2080     // is the fairest form of gameplay.
2081     // fields which are vulnerable to collusion still have to be centrally controlled :(
2082     function addApprovedBattle(Battle _battle) external onlyOwner {
2083         approvedBattles.push(_battle);
2084     }
2085 
2086     function _isApprovedBattle() internal view returns (bool) {
2087         for (uint8 i = 0; i < approvedBattles.length; i++) {
2088             if (msg.sender == address(approvedBattles[i])) {
2089                 return true;
2090             }
2091         }
2092         return false;
2093     }
2094 
2095     modifier onlyApprovedBattles(){
2096         require(_isApprovedBattle());
2097         _;
2098     }
2099 
2100 
2101     function createBattle(uint _battleId, uint[] partIds, bytes32 commit, uint revealLength) external payable {
2102         // sanity check to make sure _battleId is a valid battle
2103         require(_battleId < approvedBattles.length);
2104         //if parts are given, make sure they are owned
2105         if (partIds.length > 0) {
2106             require(ownsAll(msg.sender, partIds));
2107         }
2108         //battle can decide number of parts required for battle
2109 
2110         Battle battle = Battle(approvedBattles[_battleId]);
2111         // Transfer all to selected battle contract.
2112         for (uint i=0; i<partIds.length; i++) {
2113             _approve(partIds[i], address(battle));
2114         }
2115         uint newDuelId = battle.createBattle.value(msg.value)(msg.sender, partIds, commit, revealLength);
2116         NewDuel(_battleId, newDuelId);
2117     }
2118 
2119     event NewDuel(uint battleId, uint duelId);
2120 
2121 
2122     mapping(address => Reward[]) public pendingRewards;
2123     // actually probably just want a length getter here as default public mapping getters
2124     // are pretty expensive
2125 
2126     function getPendingBattleRewardsCount(address _user) external view returns (uint) {
2127         return pendingRewards[_user].length;
2128     } 
2129 
2130     struct Reward {
2131         uint blocknumber;
2132         int32 exp;
2133     }
2134 
2135     function addExperience(address _user, uint[] _partIds, int32[] _exps) external onlyApprovedBattles {
2136         address user = _user;
2137         require(_partIds.length == _exps.length);
2138         int32 sum = 0;
2139         for (uint i = 0; i < _exps.length; i++) {
2140             sum += _addPartExperience(_partIds[i], _exps[i]);
2141         }
2142         _addUserExperience(user, sum);
2143         _storeReward(user, sum);
2144     }
2145 
2146     // store sum.
2147     function _storeReward(address _user, int32 _battleExp) internal {
2148         pendingRewards[_user].push(Reward({
2149             blocknumber: 0,
2150             exp: _battleExp
2151         }));
2152     }
2153 
2154     /* function _getExpProportion(int _exp) returns(int) {
2155         // assume max/min of 1k, -1k
2156         return 1000 + _exp + 1; // makes it between (1, 2001)
2157     } */
2158     uint8 bestMultiple = 3;
2159     uint8 mediumMultiple = 2;
2160     uint8 worstMultiple = 1;
2161     uint8 minShards = 1;
2162     uint8 bestProbability = 97;
2163     uint8 mediumProbability = 85;
2164     function _getExpMultiple(int _exp) internal view returns (uint8, uint8) {
2165         if (_exp > 500) {
2166             return (bestMultiple,mediumMultiple);
2167         } else if (_exp > 0) {
2168             return (mediumMultiple,mediumMultiple);
2169         } else {
2170             return (worstMultiple,mediumMultiple);
2171         }
2172     }
2173 
2174     function setBest(uint8 _newBestMultiple) external onlyOwner {
2175         bestMultiple = _newBestMultiple;
2176     }
2177     function setMedium(uint8 _newMediumMultiple) external onlyOwner {
2178         mediumMultiple = _newMediumMultiple;
2179     }
2180     function setWorst(uint8 _newWorstMultiple) external onlyOwner {
2181         worstMultiple = _newWorstMultiple;
2182     }
2183     function setMinShards(uint8 _newMin) external onlyOwner {
2184         minShards = _newMin;
2185     }
2186     function setBestProbability(uint8 _newBestProb) external onlyOwner {
2187         bestProbability = _newBestProb;
2188     }
2189     function setMediumProbability(uint8 _newMinProb) external onlyOwner {
2190         mediumProbability = _newMinProb;
2191     }
2192 
2193 
2194 
2195     function _calculateShards(int _exp, uint rand) internal view returns (uint16) {
2196         var (a, b) = _getExpMultiple(_exp);
2197         uint16 shards;
2198         uint randPercent = rand % 100;
2199         if (randPercent > bestProbability) {
2200             shards = uint16(a * ((rand % 20) + 12) / b);
2201         } else if (randPercent > mediumProbability) {
2202             shards = uint16(a * ((rand % 10) + 6) / b);  
2203         } else {
2204             shards = uint16((a * (rand % 5)) / b);       
2205         }
2206 
2207         if (shards < minShards) {
2208             shards = minShards;
2209         }
2210 
2211         return shards;
2212     }
2213 
2214     // convert wins into pending battle crates
2215     // Not to pending old crates (migration), nor pending part crates (redeemShards)
2216     function convertReward() external {
2217 
2218         Reward[] storage rewards = pendingRewards[msg.sender];
2219 
2220         for (uint i = 0; i < rewards.length; i++) {
2221             if (rewards[i].blocknumber == 0) {
2222                 rewards[i].blocknumber = block.number;
2223             }
2224         }
2225 
2226     }
2227 
2228     // in PerksRewards
2229     function redeemBattleCrates() external {
2230         uint8 count = 0;
2231         uint len = pendingRewards[msg.sender].length;
2232         require(len > 0);
2233         for (uint i = 0; i < len; i++) {
2234             Reward memory rewardStruct = pendingRewards[msg.sender][i];
2235             // can't open on the same timestamp
2236             require(block.number > rewardStruct.blocknumber);
2237             // ensure user has converted all pendingRewards
2238             require(rewardStruct.blocknumber != 0);
2239 
2240             var hash = block.blockhash(rewardStruct.blocknumber);
2241 
2242             if (uint(hash) != 0) {
2243                 // different results for all different crates, even on the same block/same user
2244                 // randomness is already taken care of
2245                 uint rand = uint(keccak256(hash, msg.sender, i));
2246                 _generateBattleReward(rand,rewardStruct.exp);
2247                 count++;
2248             } else {
2249                 // Do nothing, no second chances to secure integrity of randomness.
2250             }
2251         }
2252         CratesOpened(msg.sender, count);
2253         delete pendingRewards[msg.sender];
2254     }
2255 
2256     function _generateBattleReward(uint rand, int32 exp) internal {
2257         if (((rand % 1000) > PART_REWARD_CHANCE) && (exp > 0)) {
2258             _generateRandomPart(rand, msg.sender);
2259         } else {
2260             _addShardsToUser(addressToUser[msg.sender], _calculateShards(exp, rand));
2261         }
2262     }
2263 
2264     // don't need to do any scaling
2265     // should already have been done by previous stages
2266     function _addUserExperience(address user, int32 exp) internal {
2267         // never allow exp to drop below 0
2268         User memory u = addressToUser[user];
2269         if (exp < 0 && uint32(int32(u.experience) + exp) > u.experience) {
2270             u.experience = 0;
2271             return;
2272         } else if (exp > 0) {
2273             // check for overflow
2274             require(uint32(int32(u.experience) + exp) > u.experience);
2275         }
2276         addressToUser[user].experience = uint32(int32(u.experience) + exp);
2277         //_addUserReward(user, exp);
2278     }
2279 
2280     function setMinScaled(int8 _min) external onlyOwner {
2281         minScaled = _min;
2282     }
2283 
2284     int8 minScaled = 25;
2285 
2286     function _scaleExp(uint32 _battleCount, int32 _exp) internal view returns (int32) {
2287         if (_battleCount <= 10) {
2288             return _exp; // no drop off
2289         }
2290         int32 exp =  (_exp * 10)/int32(_battleCount);
2291 
2292         if (exp < minScaled) {
2293             return minScaled;
2294         }
2295         return exp;
2296     }
2297 
2298     function _addPartExperience(uint _id, int32 _baseExp) internal returns (int32) {
2299         // never allow exp to drop below 0
2300         Part storage p = parts[_id];
2301         if (now - p.battlesLastReset > 24 hours) {
2302             p.battlesLastReset = uint32(now);
2303             p.battlesLastDay = 0;
2304         }
2305         p.battlesLastDay++;
2306         int32 exp = _baseExp;
2307         if (exp > 0) {
2308             exp = _scaleExp(p.battlesLastDay, _baseExp);
2309         }
2310 
2311         if (exp < 0 && uint32(int32(p.experience) + exp) > p.experience) {
2312             // check for wrap-around
2313             p.experience = 0;
2314             return;
2315         } else if (exp > 0) {
2316             // check for overflow
2317             require(uint32(int32(p.experience) + exp) > p.experience);
2318         }
2319 
2320         parts[_id].experience = uint32(int32(parts[_id].experience) + exp);
2321         return exp;
2322     }
2323 
2324     function totalLevel(uint[] partIds) public view returns (uint32) {
2325         uint32 total = 0;
2326         for (uint i = 0; i < partIds.length; i++) {
2327             total += getLevel(parts[partIds[i]].experience);
2328         }
2329         return total;
2330     }
2331 
2332     //requires parts in order
2333     function hasOrderedRobotParts(uint[] partIds) external view returns(bool) {
2334         uint len = partIds.length;
2335         if (len != 4) {
2336             return false;
2337         }
2338         for (uint i = 0; i < len; i++) {
2339             if (parts[partIds[i]].partType != i+1) {
2340                 return false;
2341             }
2342         }
2343         return true;
2344     }
2345 
2346 }
2347 
2348 contract EtherbotsCore is EtherbotsBattle {
2349 
2350     // The structure of Etherbots is modelled on CryptoKitties for obvious reasons:
2351     // ease of implementation, tried + tested etc.
2352     // it elides some features and includes some others.
2353 
2354     // The full system is implemented in the following manner:
2355     //
2356     // EtherbotsBase    | Storage and base types
2357     // EtherbotsAccess  | Access Control - who can change which state vars etc.
2358     // EtherbotsNFT     | ERC721 Implementation
2359     // EtherbotsBattle  | Battle interface contract: only one implementation currently, but could add more later.
2360     // EtherbotsAuction | Auction interface contract
2361 
2362 
2363     function EtherbotsCore() public {
2364         // Starts paused.
2365         paused = true;
2366         owner = msg.sender;
2367     }
2368     
2369     
2370     function() external payable {
2371     }
2372 
2373     function withdrawBalance() external onlyOwner {
2374         owner.transfer(this.balance);
2375     }
2376 }