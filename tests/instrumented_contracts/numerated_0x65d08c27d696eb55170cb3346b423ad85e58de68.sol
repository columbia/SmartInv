1 pragma solidity ^0.4.19;
2 
3 /* Adapted from strings.sol created by Nick Johnson <arachnid@notdot.net>
4  * Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
5  * @title String & slice utility library for Solidity contracts.
6  * @author Nick Johnson <arachnid@notdot.net>
7  */
8 library strings {
9     
10     struct slice {
11         uint _len;
12         uint _ptr;
13     }
14 
15     /*
16      * @dev Returns a slice containing the entire string.
17      * @param self The string to make a slice from.
18      * @return A newly allocated slice containing the entire string.
19      */
20     function toSlice(string self) internal pure returns (slice) {
21         uint ptr;
22         assembly {
23             ptr := add(self, 0x20)
24         }
25         return slice(bytes(self).length, ptr);
26     }
27 
28     function memcpy(uint dest, uint src, uint len) private pure {
29         // Copy word-length chunks while possible
30         for(; len >= 32; len -= 32) {
31             assembly {
32                 mstore(dest, mload(src))
33             }
34             dest += 32;
35             src += 32;
36         }
37 
38         // Copy remaining bytes
39         uint mask = 256 ** (32 - len) - 1;
40         assembly {
41             let srcpart := and(mload(src), not(mask))
42             let destpart := and(mload(dest), mask)
43             mstore(dest, or(destpart, srcpart))
44         }
45     }
46 
47     
48     function concat(slice self, slice other) internal returns (string) {
49         var ret = new string(self._len + other._len);
50         uint retptr;
51         assembly { retptr := add(ret, 32) }
52         memcpy(retptr, self._ptr, self._len);
53         memcpy(retptr + self._len, other._ptr, other._len);
54         return ret;
55     }
56 
57     /*
58      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
59      * @param self The slice to search.
60      * @param needle The text to search for in `self`.
61      * @return The number of occurrences of `needle` found in `self`.
62      */
63     function count(slice self, slice needle) internal returns (uint cnt) {
64         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
65         while (ptr <= self._ptr + self._len) {
66             cnt++;
67             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
68         }
69     }
70 
71     // Returns the memory address of the first byte of the first occurrence of
72     // `needle` in `self`, or the first byte after `self` if not found.
73     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
74         uint ptr;
75         uint idx;
76 
77         if (needlelen <= selflen) {
78             if (needlelen <= 32) {
79                 // Optimized assembly for 68 gas per byte on short strings
80                 assembly {
81                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
82                     let needledata := and(mload(needleptr), mask)
83                     let end := add(selfptr, sub(selflen, needlelen))
84                     ptr := selfptr
85                     loop:
86                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
87                     ptr := add(ptr, 1)
88                     jumpi(loop, lt(sub(ptr, 1), end))
89                     ptr := add(selfptr, selflen)
90                     exit:
91                 }
92                 return ptr;
93             } else {
94                 // For long needles, use hashing
95                 bytes32 hash;
96                 assembly { hash := sha3(needleptr, needlelen) }
97                 ptr = selfptr;
98                 for (idx = 0; idx <= selflen - needlelen; idx++) {
99                     bytes32 testHash;
100                     assembly { testHash := sha3(ptr, needlelen) }
101                     if (hash == testHash)
102                         return ptr;
103                     ptr += 1;
104                 }
105             }
106         }
107         return selfptr + selflen;
108     }
109 
110     /*
111      * @dev Splits the slice, setting `self` to everything after the first
112      *      occurrence of `needle`, and `token` to everything before it. If
113      *      `needle` does not occur in `self`, `self` is set to the empty slice,
114      *      and `token` is set to the entirety of `self`.
115      * @param self The slice to split.
116      * @param needle The text to search for in `self`.
117      * @param token An output parameter to which the first token is written.
118      * @return `token`.
119      */
120     function split(slice self, slice needle, slice token) internal returns (slice) {
121         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
122         token._ptr = self._ptr;
123         token._len = ptr - self._ptr;
124         if (ptr == self._ptr + self._len) {
125             // Not found
126             self._len = 0;
127         } else {
128             self._len -= token._len + needle._len;
129             self._ptr = ptr + needle._len;
130         }
131         return token;
132     }
133 
134      /*
135      * @dev Splits the slice, setting `self` to everything after the first
136      *      occurrence of `needle`, and returning everything before it. If
137      *      `needle` does not occur in `self`, `self` is set to the empty slice,
138      *      and the entirety of `self` is returned.
139      * @param self The slice to split.
140      * @param needle The text to search for in `self`.
141      * @return The part of `self` up to the first occurrence of `delim`.
142      */
143     function split(slice self, slice needle) internal returns (slice token) {
144         split(self, needle, token);
145     }
146 
147     /*
148      * @dev Copies a slice to a new string.
149      * @param self The slice to copy.
150      * @return A newly allocated string containing the slice's text.
151      */
152     function toString(slice self) internal pure returns (string) {
153         var ret = new string(self._len);
154         uint retptr;
155         assembly { retptr := add(ret, 32) }
156 
157         memcpy(retptr, self._ptr, self._len);
158         return ret;
159     }
160 
161 }
162 
163 /* Helper String Functions for Game Manager Contract
164  * @title String Healpers
165  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
166  */
167 contract StringHelpers {
168     using strings for *;
169     
170     function stringToBytes32(string memory source) internal returns (bytes32 result) {
171         bytes memory tempEmptyStringTest = bytes(source);
172         if (tempEmptyStringTest.length == 0) {
173             return 0x0;
174         }
175     
176         assembly {
177             result := mload(add(source, 32))
178         }
179     }
180 
181     function bytes32ToString(bytes32 x) constant internal returns (string) {
182         bytes memory bytesString = new bytes(32);
183         uint charCount = 0;
184         for (uint j = 0; j < 32; j++) {
185             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
186             if (char != 0) {
187                 bytesString[charCount] = char;
188                 charCount++;
189             }
190         }
191         bytes memory bytesStringTrimmed = new bytes(charCount);
192         for (j = 0; j < charCount; j++) {
193             bytesStringTrimmed[j] = bytesString[j];
194         }
195         return string(bytesStringTrimmed);
196     }
197 }
198 
199 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
200 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
201 contract ERC721 {
202   // Required methods
203   function balanceOf(address _owner) public view returns (uint256 balance);
204   function ownerOf(uint256 _assetId) public view returns (address owner);
205   function approve(address _to, uint256 _assetId) public;
206   function transfer(address _to, uint256 _assetId) public;
207   function transferFrom(address _from, address _to, uint256 _assetId) public;
208   function implementsERC721() public pure returns (bool);
209   function takeOwnership(uint256 _assetId) public;
210   function totalSupply() public view returns (uint256 total);
211 
212   event Transfer(address indexed from, address indexed to, uint256 tokenId);
213   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
214 
215   // Optional
216   // function name() public view returns (string name);
217   // function symbol() public view returns (string symbol);
218   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
219   // function tokenMetadata(uint256 _assetId) public view returns (string infoUrl);
220 
221   // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
222   function supportsInterface(bytes4 _interfaceID) external view returns (bool);
223 }
224 
225 /* Controls game play state and access rights for game functions
226  * @title Operational Control
227  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
228  * Inspired and adapted from contract created by OpenZeppelin
229  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
230  */
231 contract OperationalControl {
232     // Facilitates access & control for the game.
233     // Roles:
234     //  -The Game Managers (Primary/Secondary): Has universal control of all game elements (No ability to withdraw)
235     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
236 
237     /// @dev Emited when contract is upgraded
238     event ContractUpgrade(address newContract);
239 
240     // The addresses of the accounts (or contracts) that can execute actions within each roles.
241     address public gameManagerPrimary;
242     address public gameManagerSecondary;
243     address public bankManager;
244 
245     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
246     bool public paused = false;
247 
248     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
249     bool public error = false;
250 
251     /// @dev Operation modifiers for limiting access
252     modifier onlyGameManager() {
253         require(msg.sender == gameManagerPrimary || msg.sender == gameManagerSecondary);
254         _;
255     }
256 
257     modifier onlyBanker() {
258         require(msg.sender == bankManager);
259         _;
260     }
261 
262     modifier anyOperator() {
263         require(
264             msg.sender == gameManagerPrimary ||
265             msg.sender == gameManagerSecondary ||
266             msg.sender == bankManager
267         );
268         _;
269     }
270 
271     /// @dev Assigns a new address to act as the GM.
272     function setPrimaryGameManager(address _newGM) external onlyGameManager {
273         require(_newGM != address(0));
274 
275         gameManagerPrimary = _newGM;
276     }
277 
278     /// @dev Assigns a new address to act as the GM.
279     function setSecondaryGameManager(address _newGM) external onlyGameManager {
280         require(_newGM != address(0));
281 
282         gameManagerSecondary = _newGM;
283     }
284 
285     /// @dev Assigns a new address to act as the Banker.
286     function setBanker(address _newBK) external onlyGameManager {
287         require(_newBK != address(0));
288 
289         bankManager = _newBK;
290     }
291 
292     /*** Pausable functionality adapted from OpenZeppelin ***/
293 
294     /// @dev Modifier to allow actions only when the contract IS NOT paused
295     modifier whenNotPaused() {
296         require(!paused);
297         _;
298     }
299 
300     /// @dev Modifier to allow actions only when the contract IS paused
301     modifier whenPaused {
302         require(paused);
303         _;
304     }
305 
306     /// @dev Modifier to allow actions only when the contract has Error
307     modifier whenError {
308         require(error);
309         _;
310     }
311 
312     /// @dev Called by any Operator role to pause the contract.
313     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
314     function pause() external onlyGameManager whenNotPaused {
315         paused = true;
316     }
317 
318     /// @dev Unpauses the smart contract. Can only be called by the Game Master
319     /// @notice This is public rather than external so it can be called by derived contracts. 
320     function unpause() public onlyGameManager whenPaused {
321         // can't unpause if contract was upgraded
322         paused = false;
323     }
324 
325     /// @dev Unpauses the smart contract. Can only be called by the Game Master
326     /// @notice This is public rather than external so it can be called by derived contracts. 
327     function hasError() public onlyGameManager whenPaused {
328         error = true;
329     }
330 
331     /// @dev Unpauses the smart contract. Can only be called by the Game Master
332     /// @notice This is public rather than external so it can be called by derived contracts. 
333     function noError() public onlyGameManager whenPaused {
334         error = false;
335     }
336 }
337 
338 contract CSCCollectibleBase is ERC721, OperationalControl, StringHelpers {
339 
340   /*** EVENTS ***/
341   /// @dev The Created event is fired whenever a new collectible comes into existence.
342   event CollectibleCreated(address owner, uint256 collectibleId, bytes32 collectibleName, bool isRedeemed);
343   event Transfer(address from, address to, uint256 shipId);
344 
345   /*** CONSTANTS ***/
346 
347   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
348   string public constant NAME = "CSCRareCollectiblePreSale";
349   string public constant SYMBOL = "CSCR";
350   bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
351   bytes4 constant InterfaceSignature_ERC721 =
352         bytes4(keccak256('name()')) ^
353         bytes4(keccak256('symbol()')) ^
354         bytes4(keccak256('totalSupply()')) ^
355         bytes4(keccak256('balanceOf(address)')) ^
356         bytes4(keccak256('ownerOf(uint256)')) ^
357         bytes4(keccak256('approve(address,uint256)')) ^
358         bytes4(keccak256('transfer(address,uint256)')) ^
359         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
360         bytes4(keccak256('tokensOfOwner(address)')) ^
361         bytes4(keccak256('tokenMetadata(uint256,string)'));
362 
363   /// @dev CSC Pre Sale Struct, having details of the ship
364   struct RarePreSaleItem {
365 
366     /// @dev name of the collectible stored in bytes
367     bytes32 collectibleName;
368 
369     /// @dev Timestamp when bought
370     uint256 boughtTimestamp;
371 
372     // @dev owner address
373     address owner;
374 
375     // @dev redeeme flag (to help whether it got redeemed or not)
376     bool isRedeemed;
377   }
378 
379   // @dev array of RarePreSaleItem type holding information on the Ships
380   RarePreSaleItem[] allPreSaleItems;
381 
382   // @dev mapping which holds all the possible addresses which are allowed to interact with the contract
383   mapping (address => bool) approvedAddressList;
384 
385   // @dev mapping holds the preSaleItem -> owner details
386   mapping (uint256 => address) public preSaleItemIndexToOwner;
387 
388   // @dev A mapping from owner address to count of tokens that address owns.
389   //  Used internally inside balanceOf() to resolve ownership count.
390   mapping (address => uint256) private ownershipTokenCount;
391 
392   /// @dev A mapping from preSaleItem to an address that has been approved to call
393   ///  transferFrom(). Each Ship can only have one approved address for transfer
394   ///  at any time. A zero value means no approval is outstanding.
395   mapping (uint256 => address) public preSaleItemIndexToApproved;
396 
397   /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
398   ///  Returns true for any standardized interfaces implemented by this contract. We implement
399   ///  ERC-165 (obviously!) and ERC-721.
400   function supportsInterface(bytes4 _interfaceID) external view returns (bool)
401   {
402       // DEBUG ONLY
403       //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
404       return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
405   }
406 
407   /*** PUBLIC FUNCTIONS ***/
408   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
409   /// @param _to The address to be granted transfer approval. Pass address(0) to
410   ///  clear all approvals.
411   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
412   /// @dev Required for ERC-721 compliance.
413   function approve(address _to, uint256 _assetId) public {
414     // Caller must own token.
415     require(_owns(address(this), _assetId));
416     preSaleItemIndexToApproved[_assetId] = _to;
417 
418     Approval(msg.sender, _to, _assetId);
419   }
420 
421   /// For querying balance of a particular account
422   /// @param _owner The address for balance query
423   /// @dev Required for ERC-721 compliance.
424   function balanceOf(address _owner) public view returns (uint256 balance) {
425     return ownershipTokenCount[_owner];
426   }
427 
428   function implementsERC721() public pure returns (bool) {
429     return true;
430   }
431 
432   /// For querying owner of token
433   /// @param _assetId The tokenID for owner inquiry
434   /// @dev Required for ERC-721 compliance.
435   function ownerOf(uint256 _assetId) public view returns (address owner) {
436     owner = preSaleItemIndexToOwner[_assetId];
437     require(owner != address(0));
438   }
439 
440   /// @dev Required for ERC-721 compliance.
441   function symbol() public pure returns (string) {
442     return SYMBOL;
443   }
444 
445   /// @notice Allow pre-approved user to take ownership of a token
446   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
447   /// @dev Required for ERC-721 compliance.
448   function takeOwnership(uint256 _assetId) public {
449     address newOwner = msg.sender;
450     address oldOwner = preSaleItemIndexToOwner[_assetId];
451 
452     // Safety check to prevent against an unexpected 0x0 default.
453     require(_addressNotNull(newOwner));
454 
455     // Making sure transfer is approved
456     require(_approved(newOwner, _assetId));
457 
458     _transfer(oldOwner, newOwner, _assetId);
459   }
460 
461   /// @param _owner The owner whose ships tokens we are interested in.
462   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
463   ///  expensive (it walks the entire CSCShips array looking for emojis belonging to owner),
464   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
465   ///  not contract-to-contract calls.
466   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
467     uint256 tokenCount = balanceOf(_owner);
468 
469     if (tokenCount == 0) {
470         // Return an empty array
471         return new uint256[](0);
472     } else {
473         uint256[] memory result = new uint256[](tokenCount);
474         uint256 totalShips = totalSupply() + 1;
475         uint256 resultIndex = 0;
476 
477         // We count on the fact that all CSC Ship Collectible have IDs starting at 0 and increasing
478         // sequentially up to the total count.
479         uint256 _assetId;
480 
481         for (_assetId = 0; _assetId < totalShips; _assetId++) {
482             if (preSaleItemIndexToOwner[_assetId] == _owner) {
483                 result[resultIndex] = _assetId;
484                 resultIndex++;
485             }
486         }
487 
488         return result;
489     }
490   }
491 
492   /// For querying totalSupply of token
493   /// @dev Required for ERC-721 compliance.
494   function totalSupply() public view returns (uint256 total) {
495     return allPreSaleItems.length - 1; //Removed 0 index
496   }
497 
498   /// Owner initates the transfer of the token to another account
499   /// @param _to The address for the token to be transferred to.
500   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
501   /// @dev Required for ERC-721 compliance.
502   function transfer(address _to, uint256 _assetId) public {
503     require(_addressNotNull(_to));
504     require(_owns(msg.sender, _assetId));
505 
506     _transfer(msg.sender, _to, _assetId);
507   }
508 
509   /// Third-party initiates transfer of token from address _from to address _to
510   /// @param _from The address for the token to be transferred from.
511   /// @param _to The address for the token to be transferred to.
512   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
513   /// @dev Required for ERC-721 compliance.
514   function transferFrom(address _from, address _to, uint256 _assetId) public {
515     require(_owns(_from, _assetId));
516     require(_approved(_to, _assetId));
517     require(_addressNotNull(_to));
518 
519     _transfer(_from, _to, _assetId);
520   }
521 
522   /*** PRIVATE FUNCTIONS ***/
523   /// @dev  Safety check on _to address to prevent against an unexpected 0x0 default.
524   function _addressNotNull(address _to) internal pure returns (bool) {
525     return _to != address(0);
526   }
527 
528   /// @dev  For checking approval of transfer for address _to
529   function _approved(address _to, uint256 _assetId) internal view returns (bool) {
530     return preSaleItemIndexToApproved[_assetId] == _to;
531   }
532 
533   /// @dev For creating CSC Collectible
534   function _createCollectible(bytes32 _collectibleName, address _owner) internal returns(uint256) {
535     
536     RarePreSaleItem memory _collectibleObj = RarePreSaleItem(
537       _collectibleName,
538       0,
539       address(0),
540       false
541     );
542 
543     uint256 newCollectibleId = allPreSaleItems.push(_collectibleObj) - 1;
544     
545     // emit Created event
546     CollectibleCreated(_owner, newCollectibleId, _collectibleName, false);
547     
548     // This will assign ownership, and also emit the Transfer event as
549     // per ERC721 draft
550     _transfer(address(0), _owner, newCollectibleId);
551     
552     return newCollectibleId;
553   }
554 
555   /// Check for token ownership
556   function _owns(address claimant, uint256 _assetId) internal view returns (bool) {
557     return claimant == preSaleItemIndexToOwner[_assetId];
558   }
559 
560   /// @dev Assigns ownership of a specific Emoji to an address.
561   function _transfer(address _from, address _to, uint256 _assetId) internal {
562     // Updating the owner details of the ship
563     RarePreSaleItem memory _shipObj = allPreSaleItems[_assetId];
564     _shipObj.owner = _to;
565     allPreSaleItems[_assetId] = _shipObj;
566 
567     // Since the number of emojis is capped to 2^32 we can't overflow this
568     ownershipTokenCount[_to]++;
569 
570     //transfer ownership
571     preSaleItemIndexToOwner[_assetId] = _to;
572 
573     // When creating new emojis _from is 0x0, but we can't account that address.
574     if (_from != address(0)) {
575       ownershipTokenCount[_from]--;
576       // clear any previously approved ownership exchange
577       delete preSaleItemIndexToApproved[_assetId];
578     }
579 
580     // Emit the transfer event.
581     Transfer(_from, _to, _assetId);
582   }
583 
584   /// @dev Checks if a given address currently has transferApproval for a particular RarePreSaleItem.
585   /// 0 is a valid value as it will be the starter
586   function _approvedFor(address _claimant, uint256 _assetId) internal view returns (bool) {
587       return preSaleItemIndexToApproved[_assetId] == _claimant;
588   }
589 
590   function _getCollectibleDetails (uint256 _assetId) internal view returns(RarePreSaleItem) {
591     RarePreSaleItem storage _Obj = allPreSaleItems[_assetId];
592     return _Obj;
593   }
594 
595   /// @dev Helps in fetching the attributes of the ship depending on the ship
596   /// assetId : The actual ERC721 Asset ID
597   /// sequenceId : Index w.r.t Ship type
598   function getShipDetails(uint256 _assetId) external view returns (
599     uint256 collectibleId,
600     string shipName,
601     uint256 boughtTimestamp,
602     address owner,
603     bool isRedeemed
604     ) {
605     RarePreSaleItem storage _collectibleObj = allPreSaleItems[_assetId];
606     collectibleId = _assetId;
607     shipName = bytes32ToString(_collectibleObj.collectibleName);
608     boughtTimestamp = _collectibleObj.boughtTimestamp;
609     owner = _collectibleObj.owner;
610     isRedeemed = _collectibleObj.isRedeemed;
611   }
612 }
613 
614 /* Lucid Sight, Inc. ERC-721 CSC Collectilbe Sale Contract. 
615  * @title CSCCollectibleSale
616  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
617  */
618 contract CSCCollectibleSale is CSCCollectibleBase {
619   event SaleWinner(address owner, uint256 collectibleId, uint256 buyingPrice);
620   event CollectibleBidSuccess(address owner, uint256 collectibleId, uint256 newBidPrice, bool isActive);
621   event SaleCreated(uint256 tokenID, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint64 startedAt, bool isActive, uint256 bidPrice);
622 
623   //  SHIP DATATYPES & CONSTANTS
624   struct CollectibleSale {
625     // Current owner of NFT (ERC721)
626     address seller;
627     // Price (in wei) at beginning of sale (For Buying)
628     uint256 startingPrice;
629     // Price (in wei) at end of sale (For Buying)
630     uint256 endingPrice;
631     // Duration (in seconds) of sale
632     uint256 duration;
633     // Time when sale started
634     // NOTE: 0 if this sale has been concluded
635     uint64 startedAt;
636 
637     // Flag denoting is the Sale stilla ctive
638     bool isActive;
639 
640     // address of the wallet who had the maxBid
641     address highestBidder;
642 
643     // address of the wallet who bought the asset
644     address buyer;
645 
646     // ERC721 AssetID
647     uint256 tokenId;
648   }
649 
650   // @dev ship Prices & price cap
651   uint256 public constant SALE_DURATION = 2592000;
652   
653   /// mapping holding details of the last person who had a successfull bid. used for giving back the last bid price until the asset is bought
654   mapping(uint256 => address) indexToBidderAddress;
655   mapping(address => mapping(uint256 => uint256)) addressToBidValue;
656 
657   // A map from assetId to the bid increment
658   mapping ( uint256 => uint256 ) indexToPriceIncrement;
659   /// Map from assetId to bid price
660   mapping ( uint256 => uint256 ) indexToBidPrice;
661 
662   // Map from token to their corresponding sale.
663   mapping (uint256 => CollectibleSale) tokenIdToSale;
664 
665   /// @dev Adds an sale to the list of open sales. Also fires the
666   ///  SaleCreated event.
667   function _addSale(uint256 _assetId, CollectibleSale _sale) internal {
668       // Require that all sales have a duration of
669       // at least one minute.
670       require(_sale.duration >= 1 minutes);
671       
672       tokenIdToSale[_assetId] = _sale;
673       indexToBidPrice[_assetId] = _sale.endingPrice;
674 
675       SaleCreated(
676           uint256(_assetId),
677           uint256(_sale.startingPrice),
678           uint256(_sale.endingPrice),
679           uint256(_sale.duration),
680           uint64(_sale.startedAt),
681           _sale.isActive,
682           indexToBidPrice[_assetId]
683       );
684   }
685 
686   /// @dev Removes an sale from the list of open sales.
687   /// @param _assetId - ID of the token on sale
688   function _removeSale(uint256 _assetId) internal {
689       delete tokenIdToSale[_assetId];
690   }
691 
692   function _bid(uint256 _assetId, address _buyer, uint256 _bidAmount) internal {
693     CollectibleSale storage _sale = tokenIdToSale[_assetId];
694     
695     require(_bidAmount >= indexToBidPrice[_assetId]);
696 
697     uint256 _newBidPrice = _bidAmount + indexToPriceIncrement[_assetId];
698     indexToBidPrice[_assetId] = _newBidPrice;
699 
700     _sale.highestBidder = _buyer;
701     _sale.endingPrice = _newBidPrice;
702 
703     address lastBidder = indexToBidderAddress[_assetId];
704     
705     if(lastBidder != address(0)){
706       uint256 _value = addressToBidValue[lastBidder][_assetId];
707 
708       indexToBidderAddress[_assetId] = _buyer;
709 
710       addressToBidValue[lastBidder][_assetId] = 0;
711       addressToBidValue[_buyer][_assetId] = _bidAmount;
712 
713       lastBidder.transfer(_value);
714     } else {
715       indexToBidderAddress[_assetId] = _buyer;
716       addressToBidValue[_buyer][_assetId] = _bidAmount;
717     }
718 
719     // Check that the bid is greater than or equal to the current buyOut price
720     uint256 price = _currentPrice(_sale);
721 
722     if(_bidAmount >= price) {
723       _sale.buyer = _buyer;
724       _sale.isActive = false;
725 
726       _removeSale(_assetId);
727 
728       uint256 bidExcess = _bidAmount - price;
729       _buyer.transfer(bidExcess);
730 
731       SaleWinner(_buyer, _assetId, _bidAmount);
732       _transfer(address(this), _buyer, _assetId);
733     } else {
734       tokenIdToSale[_assetId] = _sale;
735 
736       CollectibleBidSuccess(_buyer, _assetId, _sale.endingPrice, _sale.isActive);
737     }
738   }
739 
740   /// @dev Returns true if the FT (ERC721) is on sale.
741   function _isOnSale(CollectibleSale memory _sale) internal view returns (bool) {
742       return (_sale.startedAt > 0 && _sale.isActive);
743   }
744 
745   /// @dev Returns current price of a Collectible (ERC721) on sale. Broken into two
746   ///  functions (this one, that computes the duration from the sale
747   ///  structure, and the other that does the price computation) so we
748   ///  can easily test that the price computation works correctly.
749   function _currentPrice(CollectibleSale memory _sale) internal view returns (uint256) {
750       uint256 secondsPassed = 0;
751 
752       // A bit of insurance against negative values (or wraparound).
753       // Probably not necessary (since Ethereum guarnatees that the
754       // now variable doesn't ever go backwards).
755       if (now > _sale.startedAt) {
756           secondsPassed = now - _sale.startedAt;
757       }
758 
759       return _computeCurrentPrice(
760           _sale.startingPrice,
761           _sale.endingPrice,
762           _sale.duration,
763           secondsPassed
764       );
765   }
766 
767   /// @dev Computes the current price of an sale. Factored out
768   ///  from _currentPrice so we can run extensive unit tests.
769   ///  When testing, make this function public and turn on
770   ///  `Current price computation` test suite.
771   function _computeCurrentPrice(uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint256 _secondsPassed) internal pure returns (uint256) {
772       // NOTE: We don't use SafeMath (or similar) in this function because
773       //  all of our public functions carefully cap the maximum values for
774       //  time (at 64-bits) and currency (at 128-bits). _duration is
775       //  also known to be non-zero (see the require() statement in
776       //  _addSale())
777       if (_secondsPassed >= _duration) {
778           // We've reached the end of the dynamic pricing portion
779           // of the sale, just return the end price.
780           return _endingPrice;
781       } else {
782           // Starting price can be higher than ending price (and often is!), so
783           // this delta can be negative.
784           int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
785 
786           // This multiplication can't overflow, _secondsPassed will easily fit within
787           // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
788           // will always fit within 256-bits.
789           int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
790 
791           // currentPriceChange can be negative, but if so, will have a magnitude
792           // less that _startingPrice. Thus, this result will always end up positive.
793           int256 currentPrice = int256(_startingPrice) + currentPriceChange;
794 
795           return uint256(currentPrice);
796       }
797   }
798   
799   /// @dev Escrows the ERC721 Token, assigning ownership to this contract.
800   /// Throws if the escrow fails.
801   function _escrow(address _owner, uint256 _tokenId) internal {
802     transferFrom(_owner, this, _tokenId);
803   }
804 
805   function getBuyPrice(uint256 _assetId) external view returns(uint256 _price){
806     CollectibleSale memory _sale = tokenIdToSale[_assetId];
807     
808     return _currentPrice(_sale);
809   }
810   
811   function getBidPrice(uint256 _assetId) external view returns(uint256 _price){
812     return indexToBidPrice[_assetId];
813   }
814 
815   /// @dev Creates and begins a new sale.
816   function _createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) internal {
817       // Sanity check that no inputs overflow how many bits we've allocated
818       // to store them in the sale struct.
819       require(_startingPrice == uint256(uint128(_startingPrice)));
820       require(_endingPrice == uint256(uint128(_endingPrice)));
821       require(_duration == uint256(uint64(_duration)));
822 
823       CollectibleSale memory sale = CollectibleSale(
824           _seller,
825           uint128(_startingPrice),
826           uint128(_endingPrice),
827           uint64(_duration),
828           uint64(now),
829           true,
830           address(this),
831           address(this),
832           uint256(_tokenId)
833       );
834       _addSale(_tokenId, sale);
835   }
836 
837   function _buy(uint256 _assetId, address _buyer, uint256 _price) internal {
838 
839     CollectibleSale storage _sale = tokenIdToSale[_assetId];
840     address lastBidder = indexToBidderAddress[_assetId];
841     
842     if(lastBidder != address(0)){
843       uint256 _value = addressToBidValue[lastBidder][_assetId];
844 
845       indexToBidderAddress[_assetId] = _buyer;
846 
847       addressToBidValue[lastBidder][_assetId] = 0;
848       addressToBidValue[_buyer][_assetId] = _price;
849 
850       lastBidder.transfer(_value);
851     }
852 
853     // Check that the bid is greater than or equal to the current buyOut price
854     uint256 currentPrice = _currentPrice(_sale);
855 
856     require(_price >= currentPrice);
857     _sale.buyer = _buyer;
858     _sale.isActive = false;
859 
860     _removeSale(_assetId);
861 
862     uint256 bidExcess = _price - currentPrice;
863     _buyer.transfer(bidExcess);
864 
865     SaleWinner(_buyer, _assetId, _price);
866     _transfer(address(this), _buyer, _assetId);
867   }
868 
869   /// @dev Returns sales info for an CSLCollectibles (ERC721) on sale.
870   /// @param _assetId - ID of the token on sale
871   function getSale(uint256 _assetId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, bool isActive, address owner, address highestBidder) {
872       CollectibleSale memory sale = tokenIdToSale[_assetId];
873       require(_isOnSale(sale));
874       return (
875           sale.seller,
876           sale.startingPrice,
877           sale.endingPrice,
878           sale.duration,
879           sale.startedAt,
880           sale.isActive,
881           sale.buyer,
882           sale.highestBidder
883       );
884   }
885 }
886 
887 /* Lucid Sight, Inc. ERC-721 Collectibles. 
888  * @title LSNFT - Lucid Sight, Inc. Non-Fungible Token
889  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
890  */
891 contract CSCRarePreSaleManager is CSCCollectibleSale {
892   event RefundClaimed(address owner);
893 
894   bool CSCPreSaleInit = false;
895 
896   /// @dev Constructor creates a reference to the NFT (ERC721) ownership contract
897   function CSCRarePreSaleManager() public {
898       require(msg.sender != address(0));
899       paused = true;
900       error = false;
901       gameManagerPrimary = msg.sender;
902   }
903 
904   function addToApprovedAddress (address _newAddr) onlyGameManager {
905     require(_newAddr != address(0));
906     require(!approvedAddressList[_newAddr]);
907     approvedAddressList[_newAddr] = true;
908   }
909 
910   function removeFromApprovedAddress (address _newAddr) onlyGameManager {
911     require(_newAddr != address(0));
912     require(approvedAddressList[_newAddr]);
913     approvedAddressList[_newAddr] = false;
914   }
915 
916   function createPreSaleShip(string collectibleName, uint256 startingPrice, uint256 bidPrice) whenNotPaused returns (uint256){
917     require(approvedAddressList[msg.sender] || msg.sender == gameManagerPrimary || msg.sender == gameManagerSecondary);
918     
919     uint256 assetId = _createCollectible(stringToBytes32(collectibleName), address(this));
920 
921     indexToPriceIncrement[assetId] = bidPrice;
922 
923     _createSale(assetId, startingPrice, bidPrice, uint64(SALE_DURATION), address(this));
924   }
925 
926   function() external payable {
927   }
928 
929   /// @dev Bid Function which call the interncal bid function
930   /// after doing all the pre-checks required to initiate a bid
931   function bid(uint256 _assetId) external whenNotPaused payable {
932     require(msg.sender != address(0));
933     require(msg.sender != address(this));
934     CollectibleSale memory _sale = tokenIdToSale[_assetId];
935     require(_isOnSale(_sale));
936     
937     address seller = _sale.seller;
938 
939     _bid(_assetId, msg.sender, msg.value);
940   }
941 
942   /// @dev BuyNow Function which call the interncal buy function
943   /// after doing all the pre-checks required to initiate a buy
944   function buyNow(uint256 _assetId) external whenNotPaused payable {
945     require(msg.sender != address(0));
946     require(msg.sender != address(this));
947     CollectibleSale memory _sale = tokenIdToSale[_assetId];
948     require(_isOnSale(_sale));
949     
950     address seller = _sale.seller;
951 
952     _buy(_assetId, msg.sender, msg.value);
953   }
954 
955   /// @dev Override unpause so it requires all external contract addresses
956   ///  to be set before contract can be unpaused. Also, we can't have
957   ///  newContractAddress set either, because then the contract was upgraded.
958   /// @notice This is public rather than external so we can call super.unpause
959   ///  without using an expensive CALL.
960   function unpause() public onlyGameManager whenPaused {
961       // Actually unpause the contract.
962       super.unpause();
963   }
964 
965   /// @dev Remove all Ether from the contract, which is the owner's cuts
966   ///  as well as any Ether sent directly to the contract address.
967   ///  Always transfers to the NFT (ERC721) contract, but can be called either by
968   ///  the owner or the NFT (ERC721) contract.
969   function withdrawBalance() onlyBanker {
970       // We are using this boolean method to make sure that even if one fails it will still work
971       bankManager.transfer(this.balance);
972   }
973   
974   function preSaleInit() onlyGameManager {
975     require(!CSCPreSaleInit);
976     require(allPreSaleItems.length == 0);
977       
978     CSCPreSaleInit = true;
979 
980     bytes32[6] memory attributes = [bytes32(999), bytes32(999), bytes32(999), bytes32(999), bytes32(999), bytes32(999)];
981     //Fill in index 0 to null requests
982     RarePreSaleItem memory _Obj = RarePreSaleItem(stringToBytes32("Dummy"), 0, address(this), true);
983     allPreSaleItems.push(_Obj);
984   } 
985 }