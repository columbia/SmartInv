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
219   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
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
342   event CollectibleCreated(address owner, uint256 globalId, uint256 collectibleType, uint256 collectibleClass, uint256 sequenceId, bytes32 collectibleName, bool isRedeemed);
343   event Transfer(address from, address to, uint256 shipId);
344 
345   /*** CONSTANTS ***/
346 
347   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
348   string public constant NAME = "CSCPreSaleShip";
349   string public constant SYMBOL = "CSC";
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
364   struct CSCPreSaleItem {
365 
366     /// @dev asset ID i..e Local Index
367     uint256 assetId;
368 
369     /// @dev name of the collectible stored in bytes
370     bytes32 collectibleName;
371 
372     /// @dev Timestamp when bought
373     uint256 boughtTimestamp;
374 
375     /// @dev Collectible Types (Voucher/Ship)
376     /// can be 0 - Voucher, 1 - Ship
377     uint256 collectibleType;
378 
379     /// @dev Collectible Class (1 - Prometheus, 2 - Crosair, 3 - Intrepid)
380     uint256 collectibleClass;
381 
382     // @dev owner address
383     address owner;
384 
385     // @dev redeeme flag (to help whether it got redeemed or not)
386     bool isRedeemed;
387   }
388   
389   // @dev Mapping containing the reference to all CSC PreSaleItem
390   //mapping (uint256 => CSCPreSaleItem[]) public indexToPreSaleItem;
391 
392   // @dev array of CSCPreSaleItem type holding information on the Ships
393   CSCPreSaleItem[] allPreSaleItems;
394 
395   // Max Count for Voucher(s), Prometheus, Crosair & Intrepid Ships
396   uint256 public constant PROMETHEUS_SHIP_LIMIT = 300;
397   uint256 public constant INTREPID_SHIP_LIMIT = 1500;
398   uint256 public constant CROSAIR_SHIP_LIMIT = 600;
399   uint256 public constant PROMETHEUS_VOUCHER_LIMIT = 100;
400   uint256 public constant INTREPID_VOUCHER_LIMIT = 300;
401   uint256 public constant CROSAIR_VOUCHER_LIMIT = 200;
402 
403   // Variable to keep a count of Prometheus/Intrepid/Crosair Minted
404   uint256 public prometheusShipMinted;
405   uint256 public intrepidShipMinted;
406   uint256 public crosairShipMinted;
407   uint256 public prometheusVouchersMinted;
408   uint256 public intrepidVouchersMinted;
409   uint256 public crosairVouchersMinted;
410 
411   // @dev mapping which holds all the possible addresses which are allowed to interact with the contract
412   mapping (address => bool) approvedAddressList;
413 
414   // @dev mapping holds the preSaleItem -> owner details
415   mapping (uint256 => address) public preSaleItemIndexToOwner;
416 
417   // @dev A mapping from owner address to count of tokens that address owns.
418   //  Used internally inside balanceOf() to resolve ownership count.
419   mapping (address => uint256) private ownershipTokenCount;
420 
421   /// @dev A mapping from preSaleItem to an address that has been approved to call
422   ///  transferFrom(). Each Ship can only have one approved address for transfer
423   ///  at any time. A zero value means no approval is outstanding.
424   mapping (uint256 => address) public preSaleItemIndexToApproved;
425 
426   /// @dev A mapping of preSaleItem Type to Type Sequence Number to Collectible
427   /// 0 - Voucher
428   /// 1 - Prometheus
429   /// 2 - Crosair
430   /// 3 - Intrepid
431   mapping (uint256 => mapping (uint256 => mapping ( uint256 => uint256 ) ) ) public preSaleItemTypeToSequenceIdToCollectible;
432 
433   /// @dev A mapping from Pre Sale Item Type IDs to the Sequqence Number .
434   /// 0 - Voucher
435   /// 1 - Prometheus
436   /// 2 - Crosair
437   /// 3 - Intrepid
438   mapping (uint256 => mapping ( uint256 => uint256 ) ) public preSaleItemTypeToCollectibleCount;
439 
440   /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
441   ///  Returns true for any standardized interfaces implemented by this contract. We implement
442   ///  ERC-165 (obviously!) and ERC-721.
443   function supportsInterface(bytes4 _interfaceID) external view returns (bool)
444   {
445       // DEBUG ONLY
446       //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
447       return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
448   }
449 
450   function getCollectibleDetails(uint256 _assetId) external view returns(uint256 assetId, uint256 sequenceId, uint256 collectibleType, uint256 collectibleClass, bool isRedeemed, address owner) {
451     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
452     assetId = _assetId;
453     sequenceId = _Obj.assetId;
454     collectibleType = _Obj.collectibleType;
455     collectibleClass = _Obj.collectibleClass;
456     owner = _Obj.owner;
457     isRedeemed = _Obj.isRedeemed;
458   }
459   
460   /*** PUBLIC FUNCTIONS ***/
461   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
462   /// @param _to The address to be granted transfer approval. Pass address(0) to
463   ///  clear all approvals.
464   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
465   /// @dev Required for ERC-721 compliance.
466   function approve(address _to, uint256 _assetId) public {
467     // Caller must own token.
468     require(_owns(msg.sender, _assetId));
469     preSaleItemIndexToApproved[_assetId] = _to;
470 
471     Approval(msg.sender, _to, _assetId);
472   }
473 
474   /// For querying balance of a particular account
475   /// @param _owner The address for balance query
476   /// @dev Required for ERC-721 compliance.
477   function balanceOf(address _owner) public view returns (uint256 balance) {
478     return ownershipTokenCount[_owner];
479   }
480 
481   function implementsERC721() public pure returns (bool) {
482     return true;
483   }
484 
485   /// For querying owner of token
486   /// @param _assetId The tokenID for owner inquiry
487   /// @dev Required for ERC-721 compliance.
488   function ownerOf(uint256 _assetId) public view returns (address owner) {
489     owner = preSaleItemIndexToOwner[_assetId];
490     require(owner != address(0));
491   }
492 
493   /// @dev Required for ERC-721 compliance.
494   function symbol() public pure returns (string) {
495     return SYMBOL;
496   }
497 
498   /// @notice Allow pre-approved user to take ownership of a token
499   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
500   /// @dev Required for ERC-721 compliance.
501   function takeOwnership(uint256 _assetId) public {
502     address newOwner = msg.sender;
503     address oldOwner = preSaleItemIndexToOwner[_assetId];
504 
505     // Safety check to prevent against an unexpected 0x0 default.
506     require(_addressNotNull(newOwner));
507 
508     // Making sure transfer is approved
509     require(_approved(newOwner, _assetId));
510 
511     _transfer(oldOwner, newOwner, _assetId);
512   }
513 
514   /// @param _owner The owner whose ships tokens we are interested in.
515   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
516   ///  expensive (it walks the entire CSCShips array looking for emojis belonging to owner),
517   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
518   ///  not contract-to-contract calls.
519   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
520     uint256 tokenCount = balanceOf(_owner);
521 
522     if (tokenCount == 0) {
523         // Return an empty array
524         return new uint256[](0);
525     } else {
526         uint256[] memory result = new uint256[](tokenCount);
527         uint256 totalShips = totalSupply() + 1;
528         uint256 resultIndex = 0;
529 
530         // We count on the fact that all CSC Ship Collectible have IDs starting at 0 and increasing
531         // sequentially up to the total count.
532         uint256 _assetId;
533 
534         for (_assetId = 0; _assetId < totalShips; _assetId++) {
535             if (preSaleItemIndexToOwner[_assetId] == _owner) {
536                 result[resultIndex] = _assetId;
537                 resultIndex++;
538             }
539         }
540 
541         return result;
542     }
543   }
544 
545   /// For querying totalSupply of token
546   /// @dev Required for ERC-721 compliance.
547   function totalSupply() public view returns (uint256 total) {
548     return allPreSaleItems.length - 1; //Removed 0 index
549   }
550 
551   /// Owner initates the transfer of the token to another account
552   /// @param _to The address for the token to be transferred to.
553   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
554   /// @dev Required for ERC-721 compliance.
555   function transfer(address _to, uint256 _assetId) public {
556     require(_addressNotNull(_to));
557     require(_owns(msg.sender, _assetId));
558 
559     _transfer(msg.sender, _to, _assetId);
560   }
561 
562   /// Third-party initiates transfer of token from address _from to address _to
563   /// @param _from The address for the token to be transferred from.
564   /// @param _to The address for the token to be transferred to.
565   /// @param _assetId The ID of the Token that can be transferred if this call succeeds.
566   /// @dev Required for ERC-721 compliance.
567   function transferFrom(address _from, address _to, uint256 _assetId) public {
568     require(_owns(_from, _assetId));
569     require(_approved(_to, _assetId));
570     require(_addressNotNull(_to));
571 
572     _transfer(_from, _to, _assetId);
573   }
574 
575   /*** PRIVATE FUNCTIONS ***/
576   /// @dev  Safety check on _to address to prevent against an unexpected 0x0 default.
577   function _addressNotNull(address _to) internal pure returns (bool) {
578     return _to != address(0);
579   }
580 
581   /// @dev  For checking approval of transfer for address _to
582   function _approved(address _to, uint256 _assetId) internal view returns (bool) {
583     return preSaleItemIndexToApproved[_assetId] == _to;
584   }
585 
586   /// @dev For creating CSC Collectible
587   function _createCollectible(bytes32 _collectibleName, uint256 _collectibleType, uint256 _collectibleClass) internal returns(uint256) {
588     uint256 _sequenceId = uint256(preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass]) + 1;
589 
590     // These requires are not strictly necessary, our calling code should make
591     // sure that these conditions are never broken.
592     require(_sequenceId == uint256(uint32(_sequenceId)));
593     
594     CSCPreSaleItem memory _collectibleObj = CSCPreSaleItem(
595       _sequenceId,
596       _collectibleName,
597       0,
598       _collectibleType,
599       _collectibleClass,
600       address(0),
601       false
602     );
603 
604     uint256 newCollectibleId = allPreSaleItems.push(_collectibleObj) - 1;
605     
606     preSaleItemTypeToSequenceIdToCollectible[_collectibleType][_collectibleClass][_sequenceId] = newCollectibleId;
607     preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass] = _sequenceId;
608 
609     // emit Created event
610     // CollectibleCreated(address owner, uint256 globalId, uint256 collectibleType, uint256 collectibleClass, uint256 sequenceId, bytes32[6] attributes, bool isRedeemed);
611     CollectibleCreated(address(this), newCollectibleId, _collectibleType, _collectibleClass, _sequenceId, _collectibleObj.collectibleName, false);
612     
613     // This will assign ownership, and also emit the Transfer event as
614     // per ERC721 draft
615     _transfer(address(0), address(this), newCollectibleId);
616     
617     return newCollectibleId;
618   }
619 
620   /// Check for token ownership
621   function _owns(address claimant, uint256 _assetId) internal view returns (bool) {
622     return claimant == preSaleItemIndexToOwner[_assetId];
623   }
624 
625   /// @dev Assigns ownership of a specific Emoji to an address.
626   function _transfer(address _from, address _to, uint256 _assetId) internal {
627     // Updating the owner details of the ship
628     CSCPreSaleItem memory _shipObj = allPreSaleItems[_assetId];
629     _shipObj.owner = _to;
630     allPreSaleItems[_assetId] = _shipObj;
631 
632     // Since the number of emojis is capped to 2^32 we can't overflow this
633     ownershipTokenCount[_to]++;
634 
635     //transfer ownership
636     preSaleItemIndexToOwner[_assetId] = _to;
637 
638     // When creating new emojis _from is 0x0, but we can't account that address.
639     if (_from != address(0)) {
640       ownershipTokenCount[_from]--;
641       // clear any previously approved ownership exchange
642       delete preSaleItemIndexToApproved[_assetId];
643     }
644 
645     // Emit the transfer event.
646     Transfer(_from, _to, _assetId);
647   }
648 
649   /// @dev Checks if a given address currently has transferApproval for a particular CSCPreSaleItem.
650   /// 0 is a valid value as it will be the starter
651   function _approvedFor(address _claimant, uint256 _assetId) internal view returns (bool) {
652       return preSaleItemIndexToApproved[_assetId] == _claimant;
653   }
654 
655   function _getCollectibleDetails (uint256 _assetId) internal view returns(CSCPreSaleItem) {
656     CSCPreSaleItem storage _Obj = allPreSaleItems[_assetId];
657     return _Obj;
658   }
659 
660   /// @dev Helps in fetching the attributes of the ship depending on the ship
661   /// assetId : The actual ERC721 Asset ID
662   /// sequenceId : Index w.r.t Ship type
663   function getShipDetails(uint256 _sequenceId, uint256 _shipClass) external view returns (
664     uint256 assetId,
665     uint256 sequenceId,
666     string shipName,
667     uint256 collectibleClass,
668     uint256 boughtTimestamp,
669     address owner
670     ) {  
671     uint256 _assetId = preSaleItemTypeToSequenceIdToCollectible[1][_shipClass][_sequenceId];
672 
673     CSCPreSaleItem storage _collectibleObj = allPreSaleItems[_assetId];
674     require(_collectibleObj.collectibleType == 1);
675 
676     assetId = _assetId;
677     sequenceId = _sequenceId;
678     shipName = bytes32ToString(_collectibleObj.collectibleName);
679     collectibleClass = _collectibleObj.collectibleClass;
680     boughtTimestamp = _collectibleObj.boughtTimestamp;
681     owner = _collectibleObj.owner;
682   }
683 
684   /// @dev Helps in fetching information regarding a Voucher
685   /// assetId : The actual ERC721 Asset ID
686   /// sequenceId : Index w.r.t Voucher Type
687   function getVoucherDetails(uint256 _sequenceId, uint256 _voucherClass) external view returns (
688     uint256 assetId,
689     uint256 sequenceId,
690     uint256 boughtTimestamp,
691     uint256 voucherClass,
692     address owner
693     ) {
694     uint256 _assetId = preSaleItemTypeToSequenceIdToCollectible[0][_voucherClass][_sequenceId];
695 
696     CSCPreSaleItem storage _collectibleObj = allPreSaleItems[_assetId];
697     require(_collectibleObj.collectibleType == 0);
698 
699     assetId = _assetId;
700     sequenceId = _sequenceId;
701     boughtTimestamp = _collectibleObj.boughtTimestamp;
702     voucherClass = _collectibleObj.collectibleClass;
703     owner = _collectibleObj.owner;
704   }
705 
706   function _isActive(uint256 _assetId) internal returns(bool) {
707     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
708     return (_Obj.boughtTimestamp == 0);
709   }
710 }
711 
712 /* Lucid Sight, Inc. ERC-721 CSC Collectilbe Sale Contract. 
713  * @title CSCCollectibleSale
714  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
715  */
716 contract CSCCollectibleSale is CSCCollectibleBase {
717   event CollectibleBought (uint256 _assetId, address owner);
718   event PriceUpdated (uint256 collectibleClass, uint256 newPrice, uint256 oldPrice);
719 
720   //  SHIP DATATYPES & CONSTANTS
721   // @dev ship Prices & price cap
722   uint256 public PROMETHEUS_SHIP_PRICE = 0.25 ether;
723   uint256 public INTREPID_SHIP_PRICE = 0.005 ether;
724   uint256 public CROSAIR_SHIP_PRICE = 0.1 ether;
725 
726   uint256 public constant PROMETHEUS_MAX_PRICE = 0.85 ether;
727   uint256 public constant INTREPID_MAX_PRICE = 0.25 ether;
728   uint256 public constant CROSAIR_MAX_PRICE = 0.5 ether;
729 
730   uint256 public constant PROMETHEUS_PRICE_INCREMENT = 0.05 ether;
731   uint256 public constant INTREPID_PRICE_INCREMENT = 0.002 ether;
732   uint256 public constant CROSAIR_PRICE_INCREMENT = 0.01 ether;
733 
734   uint256 public constant PROMETHEUS_PRICE_THRESHOLD = 0.85 ether;
735   uint256 public constant INTREPID_PRICE_THRESHOLD = 0.25 ether;
736   uint256 public constant CROSAIR_PRICE_THRESHOLD = 0.5 ether;
737 
738   uint256 public prometheusSoldCount;
739   uint256 public intrepidSoldCount;
740   uint256 public crosairSoldCount;
741 
742   //  VOUCHER DATATYPES & CONSTANTS
743   uint256 public PROMETHEUS_VOUCHER_PRICE = 0.75 ether;
744   uint256 public INTREPID_VOUCHER_PRICE = 0.2 ether;
745   uint256 public CROSAIR_VOUCHER_PRICE = 0.35 ether;
746 
747   uint256 public prometheusVoucherSoldCount;
748   uint256 public crosairVoucherSoldCount;
749   uint256 public intrepidVoucherSoldCount;
750   
751   /// @dev Mapping created store the amount of value a wallet address used to buy assets
752   mapping(address => uint256) addressToValue;
753 
754   /// @dev Mapping to holde the balance of each address, i.e. addrs -> collectibleType -> collectibleClass -> balance
755   mapping(address => mapping(uint256 => mapping (uint256 => uint256))) addressToCollectibleTypeBalance;
756 
757   function _bid(uint256 _assetId, uint256 _price,uint256 _collectibleType,uint256 _collectibleClass, address _buyer) internal {
758     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
759 
760     if(_collectibleType == 1 && _collectibleClass == 1) {
761       require(_price == PROMETHEUS_SHIP_PRICE);
762       _Obj.owner = _buyer;
763       _Obj.boughtTimestamp = now;
764 
765       addressToValue[_buyer] += _price;
766 
767       prometheusSoldCount++;
768       if(prometheusSoldCount % 10 == 0){
769         if(PROMETHEUS_SHIP_PRICE < PROMETHEUS_PRICE_THRESHOLD){
770           PROMETHEUS_SHIP_PRICE +=  PROMETHEUS_PRICE_INCREMENT;
771         }
772       }
773     }
774 
775     if(_collectibleType == 1 && _collectibleClass == 2) {
776       require(_price == CROSAIR_SHIP_PRICE);
777       _Obj.owner = _buyer;
778       _Obj.boughtTimestamp = now;
779 
780       addressToValue[_buyer] += _price;
781 
782       crosairSoldCount++;
783       if(crosairSoldCount % 10 == 0){
784         if(CROSAIR_SHIP_PRICE < CROSAIR_PRICE_THRESHOLD){
785           CROSAIR_SHIP_PRICE += CROSAIR_PRICE_INCREMENT;
786         }
787       }
788     }
789 
790     if(_collectibleType == 1 && _collectibleClass == 3) {
791       require(_price == INTREPID_SHIP_PRICE);
792       _Obj.owner = _buyer;
793       _Obj.boughtTimestamp = now;
794 
795       addressToValue[_buyer] += _price;
796 
797       intrepidSoldCount++;
798       if(intrepidSoldCount % 10 == 0){
799         if(INTREPID_SHIP_PRICE < INTREPID_PRICE_THRESHOLD){
800           INTREPID_SHIP_PRICE += INTREPID_PRICE_INCREMENT;
801         }
802       }
803     }
804 
805     if(_collectibleType == 0 &&_collectibleClass == 1) {
806         require(_price == PROMETHEUS_VOUCHER_PRICE);
807         _Obj.owner = _buyer;
808         _Obj.boughtTimestamp = now;
809 
810         addressToValue[_buyer] += _price;
811 
812         prometheusVoucherSoldCount++;
813       }
814 
815       if(_collectibleType == 0 && _collectibleClass == 2) {
816         require(_price == CROSAIR_VOUCHER_PRICE);
817         _Obj.owner = _buyer;
818         _Obj.boughtTimestamp = now;
819 
820         addressToValue[_buyer] += _price;
821 
822         crosairVoucherSoldCount++;
823       }
824       
825       if(_collectibleType == 0 && _collectibleClass == 3) {
826         require(_price == INTREPID_VOUCHER_PRICE);
827         _Obj.owner = _buyer;
828         _Obj.boughtTimestamp = now;
829 
830         addressToValue[_buyer] += _price;
831 
832         intrepidVoucherSoldCount++;
833       }
834 
835     addressToCollectibleTypeBalance[_buyer][_collectibleType][_collectibleClass]++;
836 
837     CollectibleBought(_assetId, _buyer);
838   }
839 
840   function getCollectibleTypeBalance(address _owner, uint256 _collectibleType, uint256 _collectibleClass) external view returns(uint256) {
841     require(_owner != address(0));
842     return addressToCollectibleTypeBalance[_owner][_collectibleType][_collectibleClass];
843   }
844 
845   function getCollectiblePrice(uint256 _collectibleType, uint256 _collectibleClass) external view returns(uint256 _price){
846 
847     // For Ships
848     if(_collectibleType == 1 && _collectibleClass == 1) {
849       return PROMETHEUS_SHIP_PRICE;
850     }
851 
852     if(_collectibleType == 1 && _collectibleClass == 2) {
853       return CROSAIR_SHIP_PRICE;
854     }
855 
856     if(_collectibleType == 1 && _collectibleClass == 3) {
857       return INTREPID_SHIP_PRICE;
858     }
859 
860     // For Vouchers
861     if(_collectibleType == 0 && _collectibleClass == 1) {
862       return PROMETHEUS_VOUCHER_PRICE;
863     }
864 
865     if(_collectibleType == 0 && _collectibleClass == 2) {
866       return CROSAIR_VOUCHER_PRICE;
867     }
868 
869     if(_collectibleType == 0 && _collectibleClass == 3) {
870       return INTREPID_VOUCHER_PRICE;
871     }
872   }
873 }
874 
875 /* Lucid Sight, Inc. ERC-721 Collectibles. 
876  * @title LSNFT - Lucid Sight, Inc. Non-Fungible Token
877  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
878  */
879 contract CSCPreSaleManager is CSCCollectibleSale {
880   event RefundClaimed(address owner, uint256 refundValue);
881 
882   // Ship Names
883   string private constant prometheusShipName = "Vulcan Harvester";
884   string private constant crosairShipName = "Phoenix Cruiser";
885   string private constant intrepidShipName = "Reaper Interceptor";
886 
887   bool CSCPreSaleInit = false;
888 
889   /// @dev Constructor creates a reference to the NFT (ERC721) ownership contract
890   function CSCPreSaleManager() public {
891       require(msg.sender != address(0));
892       paused = true;
893       error = false;
894       gameManagerPrimary = msg.sender;
895   }
896 
897   function addToApprovedAddress (address _newAddr) onlyGameManager {
898     require(_newAddr != address(0));
899     require(!approvedAddressList[_newAddr]);
900     approvedAddressList[_newAddr] = true;
901   }
902 
903   function removeFromApprovedAddress (address _newAddr) onlyGameManager {
904     require(_newAddr != address(0));
905     require(approvedAddressList[_newAddr]);
906     approvedAddressList[_newAddr] = false;
907   }
908 
909   function() external payable {
910   }
911 
912   /// @dev Bid Function which call the interncal bid function
913   /// after doing all the pre-checks required to initiate a bid
914   function bid(uint256 _collectibleType, uint256 _collectibleClass) external payable {
915     require(msg.sender != address(0));
916     require(msg.sender != address(this));
917 
918     require(_collectibleType >= 0 && _collectibleType <= 1);
919 
920     require(_isActive(_assetId));
921 
922     bytes32 collectibleName;
923 
924     if(_collectibleType == 0){
925       collectibleName = bytes32("NoNameForVoucher");
926       if(_collectibleClass == 1){
927         require(prometheusVouchersMinted < PROMETHEUS_VOUCHER_LIMIT);
928         collectibleName = stringToBytes32(prometheusShipName);
929         prometheusVouchersMinted++;
930       }
931       
932       if(_collectibleClass == 2){
933         require(crosairVouchersMinted < CROSAIR_VOUCHER_LIMIT);
934         crosairVouchersMinted++;
935       }
936 
937       if(_collectibleClass == 3){
938         require(intrepidVoucherSoldCount < INTREPID_VOUCHER_LIMIT);
939         intrepidVouchersMinted++;
940       }
941     }
942 
943     if(_collectibleType == 1){
944       if(_collectibleClass == 1){
945         require(prometheusShipMinted < PROMETHEUS_SHIP_LIMIT);
946         collectibleName = stringToBytes32(prometheusShipName);
947         prometheusShipMinted++;
948       }
949       
950       if(_collectibleClass == 2){
951         require(crosairShipMinted < CROSAIR_VOUCHER_LIMIT);
952         collectibleName = stringToBytes32(crosairShipName);
953         crosairShipMinted++;
954       }
955 
956       if(_collectibleClass == 3){
957         require(intrepidShipMinted < INTREPID_SHIP_LIMIT);
958         collectibleName = stringToBytes32(intrepidShipName);
959         intrepidShipMinted++;
960       }
961     }
962 
963     uint256 _assetId = _createCollectible(collectibleName, _collectibleType, _collectibleClass); 
964 
965     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
966 
967     _bid(_assetId, msg.value, _Obj.collectibleType, _Obj.collectibleClass, msg.sender);
968     
969     _transfer(address(this), msg.sender, _assetId);
970   }
971 
972   /// @dev Bid Function which call the interncal bid function
973   /// after doing all the pre-checks required to initiate a bid
974   function createReferralGiveAways(uint256 _collectibleType, uint256 _collectibleClass, address _toAddress) onlyGameManager external {
975     require(msg.sender != address(0));
976     require(msg.sender != address(this));
977 
978     require(_collectibleType >= 0 && _collectibleType <= 1);
979 
980     bytes32 collectibleName;
981 
982     if(_collectibleType == 0){
983       collectibleName = bytes32("ReferralGiveAwayVoucher");
984       if(_collectibleClass == 1){
985         collectibleName = stringToBytes32(prometheusShipName);
986       }
987       
988       if(_collectibleClass == 2){
989         crosairVouchersMinted++;
990       }
991 
992       if(_collectibleClass == 3){
993         intrepidVouchersMinted++;
994       }
995     }
996 
997     if(_collectibleType == 1){
998       if(_collectibleClass == 1){
999         collectibleName = stringToBytes32(prometheusShipName);
1000       }
1001       
1002       if(_collectibleClass == 2){
1003         collectibleName = stringToBytes32(crosairShipName);
1004       }
1005 
1006       if(_collectibleClass == 3){
1007         collectibleName = stringToBytes32(intrepidShipName);
1008       }
1009     }
1010 
1011     uint256 _assetId = _createCollectible(collectibleName, _collectibleType, _collectibleClass); 
1012 
1013     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
1014     
1015     _transfer(address(this), _toAddress, _assetId);
1016   }
1017 
1018   /// @dev Override unpause so it requires all external contract addresses
1019   ///  to be set before contract can be unpaused. Also, we can't have
1020   ///  newContractAddress set either, because then the contract was upgraded.
1021   /// @notice This is public rather than external so we can call super.unpause
1022   ///  without using an expensive CALL.
1023   function unpause() public onlyGameManager whenPaused {
1024       // Actually unpause the contract.
1025       super.unpause();
1026   }
1027 
1028   /// @dev Remove all Ether from the contract, which is the owner's cuts
1029   ///  as well as any Ether sent directly to the contract address.
1030   ///  Always transfers to the NFT (ERC721) contract, but can be called either by
1031   ///  the owner or the NFT (ERC721) contract.
1032   function withdrawBalance() onlyBanker {
1033       // We are using this boolean method to make sure that even if one fails it will still work
1034       bankManager.transfer(this.balance);
1035   }
1036 
1037   function claimRefund(address _ownerAddress) whenError {
1038     uint256 refundValue = addressToValue[_ownerAddress];
1039     addressToValue[_ownerAddress] = 0;
1040 
1041     _ownerAddress.transfer(refundValue);
1042     RefundClaimed(_ownerAddress, refundValue);
1043   }
1044   
1045   function preSaleInit() onlyGameManager {
1046     require(!CSCPreSaleInit);
1047     require(allPreSaleItems.length == 0);
1048       
1049     CSCPreSaleInit = true;
1050 
1051     //Fill in index 0 to null requests
1052     CSCPreSaleItem memory _Obj = CSCPreSaleItem(0, stringToBytes32("DummyAsset"), 0, 0, 0, address(this), true);
1053     allPreSaleItems.push(_Obj);
1054   }
1055 
1056   function isRedeemed(uint256 _assetId) {
1057     require(approvedAddressList[msg.sender]);
1058 
1059     CSCPreSaleItem memory _Obj = allPreSaleItems[_assetId];
1060     _Obj.isRedeemed = true;
1061 
1062     allPreSaleItems[_assetId] = _Obj;
1063   }
1064 }