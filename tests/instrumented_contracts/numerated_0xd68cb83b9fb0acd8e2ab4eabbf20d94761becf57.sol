1 pragma solidity >=0.4.22 <0.6.0;
2 
3 //-----------------------------------------------------------------------------
4 /// @title AAC Ownership
5 /// @notice defines AAC ownership-tracking structures and view functions.
6 //-----------------------------------------------------------------------------
7 contract AacOwnership {
8     struct Aac {
9         // owner ID list
10         address payable owner;
11         // unique identifier
12         uint uid;
13         // timestamp
14         uint timestamp;
15         // exp
16         uint exp;
17         // AAC data
18         bytes aacData;
19     }
20 
21     struct ExternalNft{
22         // Contract address
23         address nftContractAddress;
24         // Token Identifier
25         uint nftId;
26     }
27 
28     // Array containing all AACs. The first element in aacArray returns as
29     //  invalid
30     Aac[] aacArray;
31     // Mapping containing all UIDs tracked by this contract. Valid UIDs map to
32     //  index numbers, invalid UIDs map to 0.
33     mapping (uint => uint) uidToAacIndex;
34     // Mapping containing linked external NFTs. Linked AACs always map to
35     //  non-zero numbers, invalid AACs map to 0.
36     mapping (uint => ExternalNft) uidToExternalNft;
37     // Mapping containing tokens IDs for tokens created by an external contract
38     //  and whether or not it is linked to an AAC. 
39     mapping (address => mapping (uint => bool)) linkedExternalNfts;
40     
41     //-------------------------------------------------------------------------
42     /// @dev Throws if AAC #`_tokenId` isn't tracked by the aacArray.
43     //-------------------------------------------------------------------------
44     modifier mustExist(uint _tokenId) {
45         require (uidToAacIndex[_tokenId] != 0);
46         _;
47     }
48 
49     //-------------------------------------------------------------------------
50     /// @dev Throws if AAC #`_tokenId` isn't owned by sender.
51     //-------------------------------------------------------------------------
52     modifier mustOwn(uint _tokenId) {
53         require (ownerOf(_tokenId) == msg.sender);
54         _;
55     }
56 
57     //-------------------------------------------------------------------------
58     /// @dev Throws if parameter is zero
59     //-------------------------------------------------------------------------
60     modifier notZero(uint _param) {
61         require(_param != 0);
62         _;
63     }
64 
65     //-------------------------------------------------------------------------
66     /// @dev Creates an empty AAC as a [0] placeholder for invalid AAC queries.
67     //-------------------------------------------------------------------------
68     constructor () public {
69         aacArray.push(Aac(address(0), 0, 0, 0, ""));
70     }
71 
72     //-------------------------------------------------------------------------
73     /// @notice Find the owner of AAC #`_tokenId`
74     /// @dev throws if `_owner` is the zero address.
75     /// @param _tokenId The identifier for an AAC
76     /// @return The address of the owner of the AAC
77     //-------------------------------------------------------------------------
78     function ownerOf(uint256 _tokenId) 
79         public 
80         view 
81         mustExist(_tokenId) 
82         returns (address payable) 
83     {
84         // owner must not be the zero address
85         require (aacArray[uidToAacIndex[_tokenId]].owner != address(0));
86         return aacArray[uidToAacIndex[_tokenId]].owner;
87     }
88 
89     //-------------------------------------------------------------------------
90     /// @notice Count all AACs assigned to an owner
91     /// @dev throws if `_owner` is the zero address.
92     /// @param _owner An address to query
93     /// @return The number of AACs owned by `_owner`, possibly zero
94     //-------------------------------------------------------------------------
95     function balanceOf(address _owner) 
96         public 
97         view 
98         notZero(uint(_owner)) 
99         returns (uint256) 
100     {
101         uint owned;
102         for (uint i = 1; i < aacArray.length; ++i) {
103             if(aacArray[i].owner == _owner) {
104                 ++owned;
105             }
106         }
107         return owned;
108     }
109 
110     //-------------------------------------------------------------------------
111     /// @notice Get a list of AACs assigned to an owner
112     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
113     ///  `_owner` is the zero address, representing invalid AACs.
114     /// @param _owner Address to query for AACs.
115     /// @return The complete list of Unique Indentifiers for AACs
116     ///  assigned to `_owner`
117     //-------------------------------------------------------------------------
118     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
119         uint aacsOwned = balanceOf(_owner);
120         require(aacsOwned > 0);
121         uint counter = 0;
122         uint[] memory result = new uint[](aacsOwned);
123         for (uint i = 0; i < aacArray.length; i++) {
124             if(aacArray[i].owner == _owner) {
125                 result[counter] = aacArray[i].uid;
126                 counter++;
127             }
128         }
129         return result;
130     }
131 
132     //-------------------------------------------------------------------------
133     /// @notice Get number of AACs tracked by this contract
134     /// @return A count of valid AACs tracked by this contract, where
135     ///  each one has an assigned and queryable owner.
136     //-------------------------------------------------------------------------
137     function totalSupply() external view returns (uint256) {
138         return (aacArray.length - 1);
139     }
140 
141     //-------------------------------------------------------------------------
142     /// @notice Get the UID of AAC with index number `index`.
143     /// @dev Throws if `_index` >= `totalSupply()`.
144     /// @param _index A counter less than `totalSupply()`
145     /// @return The UID for the #`_index` AAC in the AAC array.
146     //-------------------------------------------------------------------------
147     function tokenByIndex(uint256 _index) external view returns (uint256) {
148         // index must correspond to an existing AAC
149         require (_index > 0 && _index < aacArray.length);
150         return (aacArray[_index].uid);
151     }
152 
153     //-------------------------------------------------------------------------
154     /// @notice Enumerate NFTs assigned to an owner
155     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
156     ///  `_owner` is the zero address, representing invalid NFTs.
157     /// @param _owner Address to query for AACs.
158     /// @param _index A counter less than `balanceOf(_owner)`
159     /// @return The Unique Indentifier for the #`_index` AAC assigned to
160     ///  `_owner`, (sort order not specified)
161     //-------------------------------------------------------------------------
162     function tokenOfOwnerByIndex(
163         address _owner, 
164         uint256 _index
165     ) external view notZero(uint(_owner)) returns (uint256) {
166         uint aacsOwned = balanceOf(_owner);
167         require(aacsOwned > 0);
168         require(_index < aacsOwned);
169         uint counter = 0;
170         for (uint i = 0; i < aacArray.length; i++) {
171             if (aacArray[i].owner == _owner) {
172                 if (counter == _index) {
173                     return(aacArray[i].uid);
174                 } else {
175                     counter++;
176                 }
177             }
178         }
179     }
180 }
181 
182 
183 //-----------------------------------------------------------------------------
184 /// @title Token Receiver Interface
185 //-----------------------------------------------------------------------------
186 interface TokenReceiverInterface {
187     function onERC721Received(
188         address _operator, 
189         address _from, 
190         uint256 _tokenId, 
191         bytes calldata _data
192     ) external returns(bytes4);
193 }
194 
195 
196 //-----------------------------------------------------------------------------
197 /// @title VIP-181 Interface
198 //-----------------------------------------------------------------------------
199 interface VIP181 {
200     function transferFrom (
201         address _from, 
202         address _to, 
203         uint256 _tokenId
204     ) external payable;
205     function ownerOf(uint _tokenId) external returns(address);
206     function getApproved(uint256 _tokenId) external view returns (address);
207     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
208     function tokenURI(uint _tokenId) external view returns (string memory);
209 }
210 
211 
212 //-----------------------------------------------------------------------------
213 /// @title AAC Transfers
214 /// @notice Defines transfer functionality for AACs to transfer ownership.
215 ///  Defines approval functionality for 3rd parties to enable transfers on
216 ///  owners' behalf.
217 //-----------------------------------------------------------------------------
218 contract AacTransfers is AacOwnership {
219     //-------------------------------------------------------------------------
220     /// @dev Transfer emits when ownership of an AAC changes by any
221     ///  mechanism. This event emits when AACs are created ('from' == 0).
222     ///  At the time of any transfer, the approved address for that AAC
223     ///  (if any) is reset to address(0).
224     //-------------------------------------------------------------------------
225     event Transfer(
226         address indexed _from, 
227         address indexed _to, 
228         uint256 indexed _tokenId
229     );
230 
231     //-------------------------------------------------------------------------
232     /// @dev Approval emits when the approved address for an AAC is
233     ///  changed or reaffirmed. The zero address indicates there is no approved
234     ///  address. When a Transfer event emits, this also indicates that the
235     ///  approved address for that AAC (if any) is reset to none.
236     //-------------------------------------------------------------------------
237     event Approval(
238         address indexed _owner, 
239         address indexed _approved, 
240         uint256 indexed _tokenId
241     );
242 
243     //-------------------------------------------------------------------------
244     /// @dev This emits when an operator is enabled or disabled for an owner.
245     ///  The operator can manage all AACs of the owner.
246     //-------------------------------------------------------------------------
247     event ApprovalForAll(
248         address indexed _owner, 
249         address indexed _operator, 
250         bool _approved
251     );
252 
253     // Mapping from token ID to approved address
254     mapping (uint => address) idToApprovedAddress;
255     // Mapping from owner to operator approvals
256     mapping (address => mapping (address => bool)) operatorApprovals;
257 
258     //-------------------------------------------------------------------------
259     /// @dev Throws if called by any account other than token owner, approved
260     ///  address, or authorized operator.
261     //-------------------------------------------------------------------------
262     modifier canOperate(uint _uid) {
263         // sender must be owner of AAC #uid, or sender must be the
264         //  approved address of AAC #uid, or an authorized operator for
265         //  AAC owner
266         require (
267             msg.sender == aacArray[uidToAacIndex[_uid]].owner ||
268             msg.sender == idToApprovedAddress[_uid] ||
269             operatorApprovals[aacArray[uidToAacIndex[_uid]].owner][msg.sender]
270         );
271         _;
272     }
273 
274     //-------------------------------------------------------------------------
275     /// @notice Change or reaffirm the approved address for AAC #`_tokenId`.
276     /// @dev The zero address indicates there is no approved address.
277     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
278     ///  operator of the current owner.
279     /// @param _approved The new approved AAC controller
280     /// @param _tokenId The AAC to approve
281     //-------------------------------------------------------------------------
282     function approve(address _approved, uint256 _tokenId) external payable {
283         address owner = ownerOf(_tokenId);
284         // msg.sender must be the current NFT owner, or an authorized operator
285         //  of the current owner.
286         require (
287             msg.sender == owner || isApprovedForAll(owner, msg.sender)
288         );
289         idToApprovedAddress[_tokenId] = _approved;
290         emit Approval(owner, _approved, _tokenId);
291     }
292     
293     //-------------------------------------------------------------------------
294     /// @notice Get the approved address for a single NFT
295     /// @dev Throws if `_tokenId` is not a valid NFT.
296     /// @param _tokenId The NFT to find the approved address for
297     /// @return The approved address for this NFT, or the zero address if
298     ///  there is none
299     //-------------------------------------------------------------------------
300     function getApproved(
301         uint256 _tokenId
302     ) external view mustExist(_tokenId) returns (address) {
303         return idToApprovedAddress[_tokenId];
304     }
305     
306     //-------------------------------------------------------------------------
307     /// @notice Enable or disable approval for a third party ("operator") to
308     ///  manage all of sender's AACs
309     /// @dev Emits the ApprovalForAll event. The contract MUST allow multiple
310     ///  operators per owner.
311     /// @param _operator Address to add to the set of authorized operators
312     /// @param _approved True if the operator is approved, false to revoke
313     ///  approval
314     //-------------------------------------------------------------------------
315     function setApprovalForAll(address _operator, bool _approved) external {
316         require(_operator != msg.sender);
317         operatorApprovals[msg.sender][_operator] = _approved;
318         emit ApprovalForAll(msg.sender, _operator, _approved);
319     }
320     
321     //-------------------------------------------------------------------------
322     /// @notice Get whether '_operator' is approved to manage all of '_owner's
323     ///  AACs
324     /// @param _owner AAC Owner.
325     /// @param _operator Address to check for approval.
326     /// @return True if '_operator' is approved to manage all of '_owner's' AACs.
327     //-------------------------------------------------------------------------
328     function isApprovedForAll(
329         address _owner, 
330         address _operator
331     ) public view returns (bool) {
332         return operatorApprovals[_owner][_operator];
333     }
334 
335     
336     //-------------------------------------------------------------------------
337     /// @notice Transfers ownership of AAC #`_tokenId` from `_from` to 
338     ///  `_to`
339     /// @dev Throws unless `msg.sender` is the current owner, an authorized
340     ///  operator, or the approved address for this NFT. Throws if `_from` is
341     ///  not the current owner. Throws if `_to` is the zero address. Throws if
342     ///  `_tokenId` is not a valid NFT. When transfer is complete, checks if
343     ///  `_to` is a smart contract (code size > 0). If so, it calls
344     ///  `onERC721Received` on `_to` and throws if the return value is not
345     ///  `0x150b7a02`. If AAC is linked to an external NFT, this function
346     ///  calls TransferFrom from the external address. Throws if this contract
347     ///  is not an approved operator for the external NFT.
348     /// @param _from The current owner of the NFT
349     /// @param _to The new owner
350     /// @param _tokenId The NFT to transfer
351     //-------------------------------------------------------------------------
352     function safeTransferFrom(address _from, address payable _to, uint256 _tokenId) 
353         external 
354         payable 
355         mustExist(_tokenId) 
356         canOperate(_tokenId) 
357         notZero(uint(_to)) 
358     {
359         address owner = ownerOf(_tokenId);
360         // _from address must be current owner of the AAC
361         require (_from == owner);
362                
363         // if AAC has a linked external NFT, call TransferFrom on the 
364         //  external NFT contract
365         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
366         if (externalNft.nftContractAddress != address(0)) {
367             // initialize external NFT contract
368             VIP181 externalContract = VIP181(externalNft.nftContractAddress);
369             // check that sender is authorized to transfer external NFT
370             address nftOwner = externalContract.ownerOf(externalNft.nftId);
371             if(
372                 msg.sender == nftOwner ||
373                 msg.sender == externalContract.getApproved(externalNft.nftId) ||
374                 externalContract.isApprovedForAll(nftOwner, msg.sender)
375             ) {
376                 // call TransferFrom
377                 externalContract.transferFrom(_from, _to, externalNft.nftId);
378             }
379         }
380 
381         // clear approval
382         idToApprovedAddress[_tokenId] = address(0);
383         // transfer ownership
384         aacArray[uidToAacIndex[_tokenId]].owner = _to;
385 
386         emit Transfer(_from, _to, _tokenId);
387 
388         // check and call onERC721Received. Throws and rolls back the transfer
389         //  if _to does not implement the expected interface
390         uint size;
391         assembly { size := extcodesize(_to) }
392         if (size > 0) {
393             bytes4 retval = TokenReceiverInterface(_to).onERC721Received(msg.sender, _from, _tokenId, "");
394             require(
395                 retval == 0x150b7a02
396             );
397         }
398     }
399     
400     //-------------------------------------------------------------------------
401     /// @notice Transfers ownership of AAC #`_tokenId` from `_from` to 
402     ///  `_to`
403     /// @dev Throws unless `msg.sender` is the current owner, an authorized
404     ///  operator, or the approved address for this NFT. Throws if `_from` is
405     ///  not the current owner. Throws if `_to` is the zero address. Throws if
406     ///  `_tokenId` is not a valid NFT. If AAC is linked to an external
407     ///  NFT, this function calls TransferFrom from the external address.
408     ///  Throws if this contract is not an approved operator for the external
409     ///  NFT. When transfer is complete, checks if `_to` is a smart contract
410     ///  (code size > 0). If so, it calls `onERC721Received` on `_to` and
411     ///  throws if the return value is not `0x150b7a02`.
412     /// @param _from The current owner of the NFT
413     /// @param _to The new owner
414     /// @param _tokenId The NFT to transfer
415     /// @param _data Additional data with no pre-specified format
416     //-------------------------------------------------------------------------
417     function safeTransferFrom(
418         address _from, 
419         address payable _to, 
420         uint256 _tokenId, 
421         bytes calldata _data
422     ) 
423         external 
424         payable 
425         mustExist(_tokenId) 
426         canOperate(_tokenId) 
427         notZero(uint(_to)) 
428     {
429         address owner = ownerOf(_tokenId);
430         // _from address must be current owner of the AAC
431         require (_from == owner);
432         
433         // if AAC has a linked external NFT, call TransferFrom on the 
434         //  external NFT contract
435         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
436         if (externalNft.nftContractAddress != address(0)) {
437             // initialize external NFT contract
438             VIP181 externalContract = VIP181(externalNft.nftContractAddress);
439             // check that sender is authorized to transfer external NFT
440             address nftOwner = externalContract.ownerOf(externalNft.nftId);
441             if(
442                 msg.sender == nftOwner ||
443                 msg.sender == externalContract.getApproved(externalNft.nftId) ||
444                 externalContract.isApprovedForAll(nftOwner, msg.sender)
445             ) {
446                 // call TransferFrom
447                 externalContract.transferFrom(_from, _to, externalNft.nftId);
448             }
449         }
450 
451         // clear approval
452         idToApprovedAddress[_tokenId] = address(0);
453         // transfer ownership
454         aacArray[uidToAacIndex[_tokenId]].owner = _to;
455 
456         emit Transfer(_from, _to, _tokenId);
457 
458         // check and call onERC721Received. Throws and rolls back the transfer
459         //  if _to does not implement the expected interface
460         uint size;
461         assembly { size := extcodesize(_to) }
462         if (size > 0) {
463             bytes4 retval = TokenReceiverInterface(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
464             require (retval == 0x150b7a02);
465         }
466     }
467 
468     //-------------------------------------------------------------------------
469     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
470     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
471     ///  THEY MAY BE PERMANENTLY LOST
472     /// @dev Throws unless `msg.sender` is the current owner, an authorized
473     ///  operator, or the approved address for this NFT. Throws if `_from` is
474     ///  not the current owner. Throws if `_to` is the zero address. Throws if
475     ///  `_tokenId` is not a valid NFT. If AAC is linked to an external
476     ///  NFT, this function calls TransferFrom from the external address.
477     ///  Throws if this contract is not an approved operator for the external
478     ///  NFT.
479     /// @param _from The current owner of the NFT
480     /// @param _to The new owner
481     /// @param _tokenId The NFT to transfer
482     //-------------------------------------------------------------------------
483     function transferFrom(address _from, address payable _to, uint256 _tokenId)
484         external 
485         payable 
486         mustExist(_tokenId) 
487         canOperate(_tokenId) 
488         notZero(uint(_to)) 
489     {
490         address owner = ownerOf(_tokenId);
491         // _from address must be current owner of the AAC
492         require (_from == owner && _from != address(0));
493         
494         // if AAC has a linked external NFT, call TransferFrom on the 
495         //  external NFT contract
496         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
497         if (externalNft.nftContractAddress != address(0)) {
498             // initialize external NFT contract
499             VIP181 externalContract = VIP181(externalNft.nftContractAddress);
500             // check that sender is authorized to transfer external NFT
501             address nftOwner = externalContract.ownerOf(externalNft.nftId);
502             if(
503                 msg.sender == nftOwner ||
504                 msg.sender == externalContract.getApproved(externalNft.nftId) ||
505                 externalContract.isApprovedForAll(nftOwner, msg.sender)
506             ) {
507                 // call TransferFrom
508                 externalContract.transferFrom(_from, _to, externalNft.nftId);
509             }
510         }
511 
512         // clear approval
513         idToApprovedAddress[_tokenId] = address(0);
514         // transfer ownership
515         aacArray[uidToAacIndex[_tokenId]].owner = _to;
516 
517         emit Transfer(_from, _to, _tokenId);
518     }
519 }
520 
521 //-----------------------------------------------------------------------------
522 /// @title Ownable
523 /// @dev The Ownable contract has an owner address, and provides basic 
524 ///  authorization control functions, this simplifies the implementation of
525 ///  "user permissions".
526 //-----------------------------------------------------------------------------
527 contract Ownable {
528     //-------------------------------------------------------------------------
529     /// @dev Emits when owner address changes by any mechanism.
530     //-------------------------------------------------------------------------
531     event OwnershipTransfer (address previousOwner, address newOwner);
532     
533     // Wallet address that can sucessfully execute onlyOwner functions
534     address owner;
535     
536     //-------------------------------------------------------------------------
537     /// @dev Sets the owner of the contract to the sender account.
538     //-------------------------------------------------------------------------
539     constructor() public {
540         owner = msg.sender;
541     }
542 
543     //-------------------------------------------------------------------------
544     /// @dev Throws if called by any account other than `owner`.
545     //-------------------------------------------------------------------------
546     modifier onlyOwner() {
547         require (msg.sender == owner);
548         _;
549     }
550 
551     //-------------------------------------------------------------------------
552     /// @notice Transfer control of the contract to a newOwner.
553     /// @dev Throws if `_newOwner` is zero address.
554     /// @param _newOwner The address to transfer ownership to.
555     //-------------------------------------------------------------------------
556     function transferOwnership(address _newOwner) public onlyOwner {
557         // for safety, new owner parameter must not be 0
558         require (_newOwner != address(0));
559         // define local variable for old owner
560         address oldOwner = owner;
561         // set owner to new owner
562         owner = _newOwner;
563         // emit ownership transfer event
564         emit OwnershipTransfer(oldOwner, _newOwner);
565     }
566 }
567 
568 
569 //-----------------------------------------------------------------------------
570 /// @title ERC-165 Pseudo-Introspection Interface Support
571 /// @notice Defines supported interfaces
572 //-----------------------------------------------------------------------------
573 contract ERC165 {
574     // mapping of all possible interfaces to whether they are supported
575     mapping (bytes4 => bool) interfaceIdToIsSupported;
576     
577     bytes4 constant ERC_165 = 0x01ffc9a7;
578     bytes4 constant ERC_721 = 0x80ac58cd;
579     bytes4 constant ERC_721_ENUMERATION = 0x780e9d63;
580     bytes4 constant ERC_721_METADATA = 0x5b5e139f;
581     
582     //-------------------------------------------------------------------------
583     /// @notice AacInterfaceSupport constructor. Sets to true interfaces
584     ///  supported at launch.
585     //-------------------------------------------------------------------------
586     constructor () public {
587         // supports ERC-165
588         interfaceIdToIsSupported[ERC_165] = true;
589         // supports ERC-721
590         interfaceIdToIsSupported[ERC_721] = true;
591         // supports ERC-721 Enumeration
592         interfaceIdToIsSupported[ERC_721_ENUMERATION] = true;
593         // supports ERC-721 Metadata
594         interfaceIdToIsSupported[ERC_721_METADATA] = true;
595     }
596 
597     //-------------------------------------------------------------------------
598     /// @notice Query if a contract implements an interface
599     /// @param interfaceID The interface identifier, as specified in ERC-165
600     /// @dev Interface identification is specified in ERC-165. This function
601     ///  uses less than 30,000 gas.
602     /// @return `true` if the contract implements `interfaceID` and
603     ///  `interfaceID` is not 0xffffffff, `false` otherwise
604     //-------------------------------------------------------------------------
605     function supportsInterface(
606         bytes4 interfaceID
607     ) external view returns (bool) {
608         if(interfaceID == 0xffffffff) {
609             return false;
610         } else {
611             return interfaceIdToIsSupported[interfaceID];
612         }
613     }
614 }
615 
616 
617 //-----------------------------------------------------------------------------
618 /// @title AAC Creation
619 /// @notice Defines new AAC creation (minting) and AAC linking to
620 ///  RFID-enabled physical objects.
621 //-----------------------------------------------------------------------------
622 contract AacCreation is AacTransfers, ERC165, Ownable {
623     //-------------------------------------------------------------------------
624     /// @dev Link emits when an empty AAC gets assigned to a valid RFID.
625     //-------------------------------------------------------------------------
626     event Link(uint _oldUid, uint _newUid);
627 
628     address public creationHandlerContractAddress;
629     // UID value is 7 bytes. Max value is 2**56 - 1
630     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
631     
632     function setCreationHandlerContractAddress(address _creationHandlerAddress) 
633     external 
634     notZero(uint(_creationHandlerAddress))
635     onlyOwner 
636     {
637         creationHandlerContractAddress = _creationHandlerAddress;
638     }
639 
640     //-------------------------------------------------------------------------
641     /// @notice Transfer EHrTs to mint a new empty AAC for '_to'.
642     /// @dev Sender must have approved this contract address as an authorized
643     ///  spender with at least "priceToMint" tokens. Throws if the sender has
644     ///  insufficient balance. Throws if sender has not granted this contract's
645     ///  address sufficient allowance.
646     /// @param _to The address to deduct EHrTs from and send new AAC to.
647     //-------------------------------------------------------------------------
648     function mintAndSend(address payable _to) external {
649         require (msg.sender == creationHandlerContractAddress);
650 
651         uint uid = UID_MAX + aacArray.length + 1;
652         uint index = aacArray.push(Aac(_to, uid, 0, 0, ""));
653         uidToAacIndex[uid] = index - 1;
654 
655         emit Transfer(address(0), _to, uid);
656     }
657 
658     //-------------------------------------------------------------------------
659     /// @notice Change AAC #`_aacId` to AAC #`_newUid`. Writes any
660     ///  data passed through '_data' into the AAC's public data.
661     /// @dev Throws if AAC #`_aacId` does not exist. Throws if sender is
662     ///  not approved to operate for AAC. Throws if '_aacId' is smaller
663     ///  than 8 bytes. Throws if '_newUid' is bigger than 7 bytes. Throws if 
664     ///  '_newUid' is zero. Throws if '_newUid' is already taken.
665     /// @param _newUid The UID of the RFID chip to link to the AAC
666     /// @param _aacId The UID of the empty AAC to link
667     /// @param _data A byte string of data to attach to the AAC
668     //-------------------------------------------------------------------------
669     function link(
670         bytes7 _newUid, 
671         uint _currentUid, 
672         bytes calldata _data
673     ) external {
674         require (msg.sender == creationHandlerContractAddress);
675         Aac storage aac = aacArray[uidToAacIndex[_currentUid]];
676         uint newUid = uint(uint56(_newUid));
677 
678         // set new UID's mapping to index to old UID's mapping
679         uidToAacIndex[newUid] = uidToAacIndex[_currentUid];
680         // reset old UID's mapping to index
681         uidToAacIndex[_currentUid] = 0;
682         // set AAC's UID to new UID
683         aac.uid = newUid;
684         // set any data
685         aac.aacData = _data;
686         // reset the timestamp
687         aac.timestamp = now;
688         // set new uid to externalNft
689         if (uidToExternalNft[_currentUid].nftContractAddress != address(0)) {
690             uidToExternalNft[newUid] = uidToExternalNft[_currentUid];
691         }
692 
693         emit Link(_currentUid, newUid);
694     }
695 
696     //-------------------------------------------------------------------------
697     /// @notice Set external NFT #`_externalId` as AAC #`_aacUid`'s
698     ///  linked external NFT.
699     /// @dev Throws if sender is not authorized to operate AAC #`_aacUid`
700     ///  Throws if external NFT is already linked. Throws if sender is not
701     ///  authorized to operate external NFT.
702     /// @param _aacUid The UID of the AAC to link
703     /// @param _externalAddress The contract address of the external NFT
704     /// @param _externalId The UID of the external NFT to link
705     //-------------------------------------------------------------------------
706     function linkExternalNft(
707         uint _aacUid, 
708         address _externalAddress, 
709         uint _externalId
710     ) external canOperate(_aacUid) {
711         require (linkedExternalNfts[_externalAddress][_externalId] == false);
712         require (ERC165(_externalAddress).supportsInterface(ERC_721));
713         require (msg.sender == VIP181(_externalAddress).ownerOf(_externalId));
714         uidToExternalNft[_aacUid] = ExternalNft(_externalAddress, _externalId);
715         linkedExternalNfts[_externalAddress][_externalId] = true;
716     }
717     
718     //-------------------------------------------------------------------------
719     /// @notice Gets whether or not an AAC #`_uid` exists.
720     //-------------------------------------------------------------------------
721     function checkExists(uint _tokenId) external view returns(bool) {
722         return (uidToAacIndex[_tokenId] != 0);
723     }
724 }
725 
726 
727 //-----------------------------------------------------------------------------
728 /// @title AAC Experience
729 /// @notice Defines AAC exp increaser contract and function
730 //-----------------------------------------------------------------------------
731 contract AacExperience is AacCreation {
732     address public expIncreaserContractAddress;
733 
734     function setExpIncreaserContractAddress(address _expAddress) 
735     external 
736     notZero(uint(_expAddress))
737     onlyOwner 
738     {
739         expIncreaserContractAddress = _expAddress;
740     }
741     
742     function addExp(uint _uid, uint _amount) external mustExist(_uid) {
743         require (msg.sender == expIncreaserContractAddress);
744         aacArray[uidToAacIndex[_uid]].exp += _amount;
745     }
746 }
747 
748 
749 //-----------------------------------------------------------------------------
750 /// @title AAC Interface
751 /// @notice Interface for highest-level AAC getters
752 //-----------------------------------------------------------------------------
753 contract AacInterface is AacExperience {
754     // URL Containing AAC metadata
755     string metadataUrl;
756 
757     //-------------------------------------------------------------------------
758     /// @notice Change old metadata URL to `_newUrl`
759     /// @dev Throws if new URL is empty
760     /// @param _newUrl The new URL containing AAC metadata
761     //-------------------------------------------------------------------------
762     function updateMetadataUrl(string calldata _newUrl)
763         external 
764         onlyOwner 
765         notZero(bytes(_newUrl).length)
766     {
767         metadataUrl = _newUrl;
768     }
769 
770     //-------------------------------------------------------------------------
771     /// @notice Sets all data for AAC #`_uid`.
772     /// @dev Throws if AAC #`_uid` does not exist. Throws if not authorized to
773     ///  operate AAC.
774     /// @param _uid the UID of the AAC to change.
775     //-------------------------------------------------------------------------
776     function changeAacData(uint _uid, bytes calldata _data) 
777         external 
778         mustExist(_uid)
779         canOperate(_uid)
780     {
781         aacArray[uidToAacIndex[_uid]].aacData = _data;
782     }
783 
784     //-------------------------------------------------------------------------
785     /// @notice Gets all public info for AAC #`_uid`.
786     /// @dev Throws if AAC #`_uid` does not exist.
787     /// @param _uid the UID of the AAC to view.
788     /// @return AAC owner, AAC UID, Creation Timestamp, Experience,
789     ///  and Public Data.
790     //-------------------------------------------------------------------------
791     function getAac(uint _uid) 
792         external
793         view 
794         mustExist(_uid) 
795         returns (address, uint, uint, uint, bytes memory) 
796     {
797         Aac memory aac = aacArray[uidToAacIndex[_uid]];
798         return(aac.owner, aac.uid, aac.timestamp, aac.exp, aac.aacData);
799     }
800 
801     //-------------------------------------------------------------------------
802     /// @notice Gets all info for AAC #`_uid`'s linked NFT.
803     /// @dev Throws if AAC #`_uid` does not exist.
804     /// @param _uid the UID of the AAC to view.
805     /// @return NFT contract address, External NFT ID.
806     //-------------------------------------------------------------------------
807     function getLinkedNft(uint _uid) 
808         external
809         view 
810         mustExist(_uid) 
811         returns (address, uint) 
812     {
813         ExternalNft memory nft = uidToExternalNft[_uid];
814         return (nft.nftContractAddress, nft.nftId);
815     }
816 
817     //-------------------------------------------------------------------------
818     /// @notice Gets whether NFT #`_externalId` is linked to an AAC.
819     /// @param _externalAddress the contract address for the external NFT
820     /// @param _externalId the UID of the external NFT to view.
821     /// @return NFT contract address, External NFT ID.
822     //-------------------------------------------------------------------------
823     function externalNftIsLinked(address _externalAddress, uint _externalId)
824         external
825         view
826         returns(bool)
827     {
828         return linkedExternalNfts[_externalAddress][_externalId];
829     }
830 
831     //-------------------------------------------------------------------------
832     /// @notice A descriptive name for a collection of NFTs in this contract
833     //-------------------------------------------------------------------------
834     function name() external pure returns (string memory) {
835         return "Authentic Asset Certificates";
836     }
837 
838     //-------------------------------------------------------------------------
839     /// @notice An abbreviated name for NFTs in this contract
840     //-------------------------------------------------------------------------
841     function symbol() external pure returns (string memory) { return "AAC"; }
842 
843     //-------------------------------------------------------------------------
844     /// @notice A distinct URL for a given asset.
845     /// @dev Throws if `_tokenId` is not a valid NFT.
846     ///  If:
847     ///  * The URI is a URL
848     ///  * The URL is accessible
849     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
850     ///  * The JSON base element is an object
851     ///  then these names of the base element SHALL have special meaning:
852     ///  * "name": A string identifying the item to which `_tokenId` grants
853     ///    ownership
854     ///  * "description": A string detailing the item to which `_tokenId`
855     ///    grants ownership
856     ///  * "image": A URI pointing to a file of image/* mime type representing
857     ///    the item to which `_tokenId` grants ownership
858     ///  Wallets and exchanges MAY display this to the end user.
859     ///  Consider making any images at a width between 320 and 1080 pixels and
860     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
861     /// @param _tokenId The AAC whose metadata address is being queried
862     //-------------------------------------------------------------------------
863     function tokenURI(uint _tokenId) external view returns (string memory) {
864         if (uidToExternalNft[_tokenId].nftContractAddress != address(0) && 
865             ERC165(uidToExternalNft[_tokenId].nftContractAddress).supportsInterface(ERC_721_METADATA)) 
866         {
867             return VIP181(uidToExternalNft[_tokenId].nftContractAddress).tokenURI(_tokenId);
868         }
869         else {
870             // convert AAC UID to a 14 character long string of character bytes
871             bytes memory uidString = intToBytes(_tokenId);
872             // declare new string of bytes with combined length of url and uid 
873             bytes memory fullUrlBytes = new bytes(bytes(metadataUrl).length + uidString.length);
874             // copy URL string and uid string into new string
875             uint counter = 0;
876             for (uint i = 0; i < bytes(metadataUrl).length; i++) {
877                 fullUrlBytes[counter++] = bytes(metadataUrl)[i];
878             }
879             for (uint i = 0; i < uidString.length; i++) {
880                 fullUrlBytes[counter++] = uidString[i];
881             }
882             // return full URL
883             return string(fullUrlBytes);
884         }
885     }
886     
887     //-------------------------------------------------------------------------
888     /// @notice Convert int to 14 character bytes
889     //-------------------------------------------------------------------------
890     function intToBytes(uint _tokenId) 
891         private 
892         pure 
893         returns (bytes memory) 
894     {
895         // convert int to bytes32
896         bytes32 x = bytes32(_tokenId);
897         
898         // convert each byte into two, and assign each byte a hex digit
899         bytes memory uidBytes64 = new bytes(64);
900         for (uint i = 0; i < 32; i++) {
901             byte b = byte(x[i]);
902             byte hi = byte(uint8(b) / 16);
903             byte lo = byte(uint8(b) - 16 * uint8(hi));
904             uidBytes64[i*2] = char(hi);
905             uidBytes64[i*2+1] = char(lo);
906         }
907         
908         // reduce size to last 14 chars (7 bytes)
909         bytes memory uidBytes = new bytes(14);
910         for (uint i = 0; i < 14; ++i) {
911             uidBytes[i] = uidBytes64[i + 50];
912         }
913         return uidBytes;
914     }
915     
916     //-------------------------------------------------------------------------
917     /// @notice Convert byte to UTF-8-encoded hex character
918     //-------------------------------------------------------------------------
919     function char(byte b) private pure returns (byte c) {
920         if (uint8(b) < 10) return byte(uint8(b) + 0x30);
921         else return byte(uint8(b) + 0x57);
922     }
923 }