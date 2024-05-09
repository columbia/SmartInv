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
204   function ownerOf(uint256 _tokenId) public view returns (address owner);
205   function approve(address _to, uint256 _tokenId) public;
206   function transfer(address _to, uint256 _tokenId) public;
207   function transferFrom(address _from, address _to, uint256 _tokenId) public;
208   function implementsERC721() public pure returns (bool);
209   function takeOwnership(uint256 _tokenId) public;
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
225 /* Controls state and access rights for contract functions
226  * @title Operational Control
227  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
228  * Inspired and adapted from contract created by OpenZeppelin
229  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
230  */
231 contract OperationalControl {
232     // Facilitates access & control for the game.
233     // Roles:
234     //  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
235     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
236 
237     /// @dev Emited when contract is upgraded
238     event ContractUpgrade(address newContract);
239 
240     // The addresses of the accounts (or contracts) that can execute actions within each roles.
241     address public managerPrimary;
242     address public managerSecondary;
243     address public bankManager;
244 
245     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
246     bool public paused = false;
247 
248     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
249     bool public error = false;
250 
251     /// @dev Operation modifiers for limiting access
252     modifier onlyManager() {
253         require(msg.sender == managerPrimary || msg.sender == managerSecondary);
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
264             msg.sender == managerPrimary ||
265             msg.sender == managerSecondary ||
266             msg.sender == bankManager
267         );
268         _;
269     }
270 
271     /// @dev Assigns a new address to act as the Primary Manager.
272     function setPrimaryManager(address _newGM) external onlyManager {
273         require(_newGM != address(0));
274 
275         managerPrimary = _newGM;
276     }
277 
278     /// @dev Assigns a new address to act as the Secondary Manager.
279     function setSecondaryManager(address _newGM) external onlyManager {
280         require(_newGM != address(0));
281 
282         managerSecondary = _newGM;
283     }
284 
285     /// @dev Assigns a new address to act as the Banker.
286     function setBanker(address _newBK) external onlyManager {
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
314     function pause() external onlyManager whenNotPaused {
315         paused = true;
316     }
317 
318     /// @dev Unpauses the smart contract. Can only be called by the Game Master
319     /// @notice This is public rather than external so it can be called by derived contracts. 
320     function unpause() public onlyManager whenPaused {
321         // can't unpause if contract was upgraded
322         paused = false;
323     }
324 
325     /// @dev Unpauses the smart contract. Can only be called by the Game Master
326     /// @notice This is public rather than external so it can be called by derived contracts. 
327     function hasError() public onlyManager whenPaused {
328         error = true;
329     }
330 
331     /// @dev Unpauses the smart contract. Can only be called by the Game Master
332     /// @notice This is public rather than external so it can be called by derived contracts. 
333     function noError() public onlyManager whenPaused {
334         error = false;
335     }
336 }
337 
338 contract CSCPreSaleItemBase is ERC721, OperationalControl, StringHelpers {
339 
340     /*** EVENTS ***/
341     /// @dev The Created event is fired whenever a new collectible comes into existence.
342     event CollectibleCreated(address owner, uint256 globalId, uint256 collectibleType, uint256 collectibleClass, uint256 sequenceId, bytes32 collectibleName);
343     
344     /*** CONSTANTS ***/
345     
346     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
347     string public constant NAME = "CSCPreSaleFactory";
348     string public constant SYMBOL = "CSCPF";
349     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
350     bytes4 constant InterfaceSignature_ERC721 =
351         bytes4(keccak256('name()')) ^
352         bytes4(keccak256('symbol()')) ^
353         bytes4(keccak256('totalSupply()')) ^
354         bytes4(keccak256('balanceOf(address)')) ^
355         bytes4(keccak256('ownerOf(uint256)')) ^
356         bytes4(keccak256('approve(address,uint256)')) ^
357         bytes4(keccak256('transfer(address,uint256)')) ^
358         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
359         bytes4(keccak256('tokensOfOwner(address)')) ^
360         bytes4(keccak256('tokenMetadata(uint256,string)'));
361     
362     /// @dev CSC Pre Sale Struct, having details of the collectible
363     struct CSCPreSaleItem {
364     
365         /// @dev sequence ID i..e Local Index
366         uint256 sequenceId;
367         
368         /// @dev name of the collectible stored in bytes
369         bytes32 collectibleName;
370         
371         /// @dev Collectible Type
372         uint256 collectibleType;
373         
374         /// @dev Collectible Class
375         uint256 collectibleClass;
376         
377         /// @dev owner address
378         address owner;
379         
380         /// @dev redeemed flag (to help whether it got redeemed or not)
381         bool isRedeemed;
382     }
383     
384     /// @dev array of CSCPreSaleItem type holding information on the Collectibles Created
385     CSCPreSaleItem[] allPreSaleItems;
386     
387     /// @dev Max Count for preSaleItem type -> preSaleItem class -> max. limit
388     mapping(uint256 => mapping(uint256 => uint256)) public preSaleItemTypeToClassToMaxLimit;
389     
390     /// @dev Map from preSaleItem type -> preSaleItem class -> max. limit set (bool)
391     mapping(uint256 => mapping(uint256 => bool)) public preSaleItemTypeToClassToMaxLimitSet;
392 
393     /// @dev Map from preSaleItem type -> preSaleItem class -> Name (string / bytes32)
394     mapping(uint256 => mapping(uint256 => bytes32)) public preSaleItemTypeToClassToName;
395     
396     // @dev mapping which holds all the possible addresses which are allowed to interact with the contract
397     mapping (address => bool) approvedAddressList;
398     
399     // @dev mapping holds the preSaleItem -> owner details
400     mapping (uint256 => address) public preSaleItemIndexToOwner;
401     
402     // @dev A mapping from owner address to count of tokens that address owns.
403     //  Used internally inside balanceOf() to resolve ownership count.
404     mapping (address => uint256) private ownershipTokenCount;
405     
406     /// @dev A mapping from preSaleItem to an address that has been approved to call
407     ///  transferFrom(). Each Collectible can only have one approved address for transfer
408     ///  at any time. A zero value means no approval is outstanding.
409     mapping (uint256 => address) public preSaleItemIndexToApproved;
410     
411     /// @dev A mapping of preSaleItem Type to Type Sequence Number to Collectible
412     mapping (uint256 => mapping (uint256 => mapping ( uint256 => uint256 ) ) ) public preSaleItemTypeToSequenceIdToCollectible;
413     
414     /// @dev A mapping from Pre Sale Item Type IDs to the Sequqence Number .
415     mapping (uint256 => mapping ( uint256 => uint256 ) ) public preSaleItemTypeToCollectibleCount;
416 
417     /// @dev Token Starting Index taking into account the old presaleContract total assets that can be generated
418     uint256 public STARTING_ASSET_BASE = 3000;
419     
420     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
421     ///  Returns true for any standardized interfaces implemented by this contract. We implement
422     ///  ERC-165 (obviously!) and ERC-721.
423     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
424     {
425         // DEBUG ONLY
426         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
427         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
428     }
429     
430     function setMaxLimit(string _collectibleName, uint256 _collectibleType, uint256 _collectibleClass, uint256 _maxLimit) external onlyManager whenNotPaused {
431         require(_maxLimit > 0);
432         require(_collectibleType >= 0 && _collectibleClass >= 0);
433         require(stringToBytes32(_collectibleName) != stringToBytes32(""));
434 
435         require(!preSaleItemTypeToClassToMaxLimitSet[_collectibleType][_collectibleClass]);
436         preSaleItemTypeToClassToMaxLimit[_collectibleType][_collectibleClass] = _maxLimit;
437         preSaleItemTypeToClassToMaxLimitSet[_collectibleType][_collectibleClass] = true;
438         preSaleItemTypeToClassToName[_collectibleType][_collectibleClass] = stringToBytes32(_collectibleName);
439     }
440     
441     /// @dev Method to fetch collectible details
442     function getCollectibleDetails(uint256 _tokenId) external view returns(uint256 assetId, uint256 sequenceId, uint256 collectibleType, uint256 collectibleClass, string collectibleName, bool isRedeemed, address owner) {
443 
444         require (_tokenId > STARTING_ASSET_BASE);
445         uint256 generatedCollectibleId = _tokenId - STARTING_ASSET_BASE;
446         
447         CSCPreSaleItem memory _Obj = allPreSaleItems[generatedCollectibleId];
448         assetId = _tokenId;
449         sequenceId = _Obj.sequenceId;
450         collectibleType = _Obj.collectibleType;
451         collectibleClass = _Obj.collectibleClass;
452         collectibleName = bytes32ToString(_Obj.collectibleName);
453         owner = _Obj.owner;
454         isRedeemed = _Obj.isRedeemed;
455     }
456     
457     /*** PUBLIC FUNCTIONS ***/
458     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
459     /// @param _to The address to be granted transfer approval. Pass address(0) to
460     ///  clear all approvals.
461     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
462     /// @dev Required for ERC-721 compliance.
463     function approve(address _to, uint256 _tokenId) public {
464         // Caller must own token.
465         require (_tokenId > STARTING_ASSET_BASE);
466         
467         require(_owns(msg.sender, _tokenId));
468         preSaleItemIndexToApproved[_tokenId] = _to;
469         
470         Approval(msg.sender, _to, _tokenId);
471     }
472     
473     /// For querying balance of a particular account
474     /// @param _owner The address for balance query
475     /// @dev Required for ERC-721 compliance.
476     function balanceOf(address _owner) public view returns (uint256 balance) {
477         return ownershipTokenCount[_owner];
478     }
479     
480     function implementsERC721() public pure returns (bool) {
481         return true;
482     }
483     
484     /// For querying owner of token
485     /// @param _tokenId The tokenID for owner inquiry
486     /// @dev Required for ERC-721 compliance.
487     function ownerOf(uint256 _tokenId) public view returns (address owner) {
488         require (_tokenId > STARTING_ASSET_BASE);
489 
490         owner = preSaleItemIndexToOwner[_tokenId];
491         require(owner != address(0));
492     }
493     
494     /// @dev Required for ERC-721 compliance.
495     function symbol() public pure returns (string) {
496         return SYMBOL;
497     }
498     
499     /// @notice Allow pre-approved user to take ownership of a token
500     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
501     /// @dev Required for ERC-721 compliance.
502     function takeOwnership(uint256 _tokenId) public {
503         require (_tokenId > STARTING_ASSET_BASE);
504 
505         address newOwner = msg.sender;
506         address oldOwner = preSaleItemIndexToOwner[_tokenId];
507         
508         // Safety check to prevent against an unexpected 0x0 default.
509         require(_addressNotNull(newOwner));
510         
511         // Making sure transfer is approved
512         require(_approved(newOwner, _tokenId));
513         
514         _transfer(oldOwner, newOwner, _tokenId);
515     }
516     
517     /// @param _owner The owner whose collectibles tokens we are interested in.
518     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
519     ///  expensive (it walks the entire CSCPreSaleItem array looking for collectibles belonging to owner),
520     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
521     ///  not contract-to-contract calls.
522     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
523         uint256 tokenCount = balanceOf(_owner);
524         
525         if (tokenCount == 0) {
526             // Return an empty array
527             return new uint256[](0);
528         } else {
529             uint256[] memory result = new uint256[](tokenCount);
530             uint256 totalCount = totalSupply() + 1 + STARTING_ASSET_BASE;
531             uint256 resultIndex = 0;
532         
533             // We count on the fact that all LS PreSaleItems have IDs starting at 0 and increasing
534             // sequentially up to the total count.
535             uint256 _tokenId;
536         
537             for (_tokenId = STARTING_ASSET_BASE; _tokenId < totalCount; _tokenId++) {
538                 if (preSaleItemIndexToOwner[_tokenId] == _owner) {
539                     result[resultIndex] = _tokenId;
540                     resultIndex++;
541                 }
542             }
543         
544             return result;
545         }
546     }
547     
548     /// For querying totalSupply of token
549     /// @dev Required for ERC-721 compliance.
550     function totalSupply() public view returns (uint256 total) {
551         return allPreSaleItems.length - 1; //Removed 0 index
552     }
553     
554     /// Owner initates the transfer of the token to another account
555     /// @param _to The address for the token to be transferred to.
556     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
557     /// @dev Required for ERC-721 compliance.
558     function transfer(address _to, uint256 _tokenId) public {
559 
560         require (_tokenId > STARTING_ASSET_BASE);
561         
562         require(_addressNotNull(_to));
563         require(_owns(msg.sender, _tokenId));
564         
565         _transfer(msg.sender, _to, _tokenId);
566     }
567     
568     /// Third-party initiates transfer of token from address _from to address _to
569     /// @param _from The address for the token to be transferred from.
570     /// @param _to The address for the token to be transferred to.
571     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
572     /// @dev Required for ERC-721 compliance.
573     function transferFrom(address _from, address _to, uint256 _tokenId) public {
574         require (_tokenId > STARTING_ASSET_BASE);
575 
576         require(_owns(_from, _tokenId));
577         require(_approved(_to, _tokenId));
578         require(_addressNotNull(_to));
579         
580         _transfer(_from, _to, _tokenId);
581     }
582     
583     /*** PRIVATE FUNCTIONS ***/
584     /// @dev  Safety check on _to address to prevent against an unexpected 0x0 default.
585     function _addressNotNull(address _to) internal pure returns (bool) {
586         return _to != address(0);
587     }
588     
589     /// @dev  For checking approval of transfer for address _to
590     function _approved(address _to, uint256 _tokenId) internal view returns (bool) {
591         return preSaleItemIndexToApproved[_tokenId] == _to;
592     }
593     
594     /// @dev For creating CSC Collectible
595     function _createCollectible(bytes32 _collectibleName, uint256 _collectibleType, uint256 _collectibleClass) internal returns(uint256) {
596         uint256 _sequenceId = uint256(preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass]) + 1;
597         
598         // These requires are not strictly necessary, our calling code should make
599         // sure that these conditions are never broken.
600         require(_sequenceId == uint256(uint32(_sequenceId)));
601         
602         CSCPreSaleItem memory _collectibleObj = CSCPreSaleItem(
603           _sequenceId,
604           _collectibleName,
605           _collectibleType,
606           _collectibleClass,
607           address(0),
608           false
609         );
610         
611         uint256 generatedCollectibleId = allPreSaleItems.push(_collectibleObj) - 1;
612         uint256 collectibleIndex = generatedCollectibleId + STARTING_ASSET_BASE;
613         
614         preSaleItemTypeToSequenceIdToCollectible[_collectibleType][_collectibleClass][_sequenceId] = collectibleIndex;
615         preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass] = _sequenceId;
616         
617         // emit Created event
618         // CollectibleCreated(address owner, uint256 globalId, uint256 collectibleType, uint256 collectibleClass, uint256 sequenceId, bytes32 collectibleName);
619         CollectibleCreated(address(this), collectibleIndex, _collectibleType, _collectibleClass, _sequenceId, _collectibleObj.collectibleName);
620         
621         // This will assign ownership, and also emit the Transfer event as
622         // per ERC721 draft
623         _transfer(address(0), address(this), collectibleIndex);
624         
625         return collectibleIndex;
626     }
627     
628     /// @dev Check for token ownership
629     function _owns(address claimant, uint256 _tokenId) internal view returns (bool) {
630         return claimant == preSaleItemIndexToOwner[_tokenId];
631     }
632     
633     /// @dev Assigns ownership of a specific preSaleItem to an address.
634     function _transfer(address _from, address _to, uint256 _tokenId) internal {
635         uint256 generatedCollectibleId = _tokenId - STARTING_ASSET_BASE;
636 
637         // Updating the owner details of the collectible
638         CSCPreSaleItem memory _Obj = allPreSaleItems[generatedCollectibleId];
639         _Obj.owner = _to;
640         allPreSaleItems[generatedCollectibleId] = _Obj;
641         
642         // Since the number of preSaleItem is capped to 2^32 we can't overflow this
643         ownershipTokenCount[_to]++;
644         
645         //transfer ownership
646         preSaleItemIndexToOwner[_tokenId] = _to;
647         
648         // When creating new collectibles _from is 0x0, but we can't account that address.
649         if (_from != address(0)) {
650           ownershipTokenCount[_from]--;
651           // clear any previously approved ownership exchange
652           delete preSaleItemIndexToApproved[_tokenId];
653         }
654         
655         // Emit the transfer event.
656         Transfer(_from, _to, _tokenId);
657     }
658     
659     /// @dev Checks if a given address currently has transferApproval for a particular CSCPreSaleItem.
660     /// 0 is a valid value as it will be the starter
661     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
662         require(_tokenId > STARTING_ASSET_BASE);
663 
664         return preSaleItemIndexToApproved[_tokenId] == _claimant;
665     }
666 }
667 
668 /* Lucid Sight, Inc. ERC-721 Collectibles Manager. 
669  * @title LSPreSaleManager - Lucid Sight, Inc. Non-Fungible Token
670  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
671  */
672 contract CSCPreSaleManager is CSCPreSaleItemBase {
673 
674     event RefundClaimed(address owner, uint256 refundValue);
675 
676     /// @dev defines if preSaleItem type -> preSaleItem class -> Vending Machine to set limit (bool)
677     mapping(uint256 => mapping(uint256 => bool)) public preSaleItemTypeToClassToCanBeVendingMachine;
678 
679     /// @dev defines if preSaleItem type -> preSaleItem class -> Vending Machine Fee
680     mapping(uint256 => mapping(uint256 => uint256)) public preSaleItemTypeToClassToVendingFee;
681 
682     /// @dev Mapping created store the amount of value a wallet address used to buy assets
683     mapping(address => uint256) public addressToValue;
684     
685     bool CSCPreSaleInit = false;
686     /// @dev Constructor creates a reference to the NFT (ERC721) ownership contract
687     function CSCPreSaleManager() public {
688         require(msg.sender != address(0));
689         paused = true;
690         error = false;
691         managerPrimary = msg.sender;
692     }
693 
694     /// @dev allows the contract to accept ETH
695     function() external payable {
696     }
697     
698     /// @dev Function to add approved address to the 
699     /// approved address list
700     function addToApprovedAddress (address _newAddr) onlyManager whenNotPaused {
701         require(_newAddr != address(0));
702         require(!approvedAddressList[_newAddr]);
703         approvedAddressList[_newAddr] = true;
704     }
705     
706     /// @dev Function to remove an approved address from the 
707     /// approved address list
708     function removeFromApprovedAddress (address _newAddr) onlyManager whenNotPaused {
709         require(_newAddr != address(0));
710         require(approvedAddressList[_newAddr]);
711         approvedAddressList[_newAddr] = false;
712     }
713 
714     /// @dev Function toggle vending for collectible
715     function toggleVending (uint256 _collectibleType, uint256 _collectibleClass) external onlyManager {
716         if(preSaleItemTypeToClassToCanBeVendingMachine[_collectibleType][_collectibleClass] == false) {
717             preSaleItemTypeToClassToCanBeVendingMachine[_collectibleType][_collectibleClass] = true;
718         } else {
719             preSaleItemTypeToClassToCanBeVendingMachine[_collectibleType][_collectibleClass] = false;
720         }
721     }
722 
723     /// @dev Function toggle vending for collectible
724     function setVendingFee (uint256 _collectibleType, uint256 _collectibleClass, uint fee) external onlyManager {
725         preSaleItemTypeToClassToVendingFee[_collectibleType][_collectibleClass] = fee;
726     }
727     
728     /// @dev This helps in creating a collectible and then 
729     /// transfer it _toAddress
730     function createCollectible(uint256 _collectibleType, uint256 _collectibleClass, address _toAddress) onlyManager external whenNotPaused {
731         require(msg.sender != address(0));
732         require(msg.sender != address(this));
733         
734         require(_toAddress != address(0));
735         require(_toAddress != address(this));
736         
737         require(preSaleItemTypeToClassToMaxLimitSet[_collectibleType][_collectibleClass]);
738         require(preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass] < preSaleItemTypeToClassToMaxLimit[_collectibleType][_collectibleClass]);
739         
740         uint256 _tokenId = _createCollectible(preSaleItemTypeToClassToName[_collectibleType][_collectibleClass], _collectibleType, _collectibleClass);
741         
742         _transfer(address(this), _toAddress, _tokenId);
743     }
744 
745 
746     /// @dev This helps in creating a collectible and then 
747     /// transfer it _toAddress
748     function vendingCreateCollectible(uint256 _collectibleType, uint256 _collectibleClass, address _toAddress) payable external whenNotPaused {
749         
750         //Only if Vending is Allowed for this Asset
751         require(preSaleItemTypeToClassToCanBeVendingMachine[_collectibleType][_collectibleClass]);
752 
753         require(msg.value >= preSaleItemTypeToClassToVendingFee[_collectibleType][_collectibleClass]);
754 
755         require(msg.sender != address(0));
756         require(msg.sender != address(this));
757         
758         require(_toAddress != address(0));
759         require(_toAddress != address(this));
760         
761         require(preSaleItemTypeToClassToMaxLimitSet[_collectibleType][_collectibleClass]);
762         require(preSaleItemTypeToCollectibleCount[_collectibleType][_collectibleClass] < preSaleItemTypeToClassToMaxLimit[_collectibleType][_collectibleClass]);
763         
764         uint256 _tokenId = _createCollectible(preSaleItemTypeToClassToName[_collectibleType][_collectibleClass], _collectibleType, _collectibleClass);
765         uint256 excessBid = msg.value - preSaleItemTypeToClassToVendingFee[_collectibleType][_collectibleClass];
766         
767         if(excessBid > 0) {
768             msg.sender.transfer(excessBid);
769         }
770 
771         addressToValue[msg.sender] += preSaleItemTypeToClassToVendingFee[_collectibleType][_collectibleClass];
772         
773         _transfer(address(this), _toAddress, _tokenId);
774     }
775 
776     
777     
778     /// @dev Override unpause so it requires all external contract addresses
779     ///  to be set before contract can be unpaused. Also, we can't have
780     ///  newContractAddress set either, because then the contract was upgraded.
781     /// @notice This is public rather than external so we can call super.unpause
782     ///  without using an expensive CALL.
783     function unpause() public onlyManager whenPaused {
784         // Actually unpause the contract.
785         super.unpause();
786     }
787 
788     /// @dev Override unpause so it requires all external contract addresses
789     ///  to be set before contract can be unpaused. Also, we can't have
790     ///  newContractAddress set either, because then the contract was upgraded.
791     /// @notice This is public rather than external so we can call super.unpause
792     ///  without using an expensive CALL.
793     function hasError() public onlyManager whenPaused {
794         // Actually error out the contract.
795         super.hasError();
796     }
797     
798     /// @dev Function does the init step and thus allow
799     /// to create a Dummy 0th colelctible
800     function preSaleInit() onlyManager {
801         require(!CSCPreSaleInit);
802         require(allPreSaleItems.length == 0);
803         
804         CSCPreSaleInit = true;
805         
806         //Fill in index 0 to null requests
807         CSCPreSaleItem memory _Obj = CSCPreSaleItem(0, stringToBytes32("DummyAsset"), 0, 0, address(this), true);
808         allPreSaleItems.push(_Obj);
809     }
810 
811     /// @dev Remove all Ether from the contract, which is the owner's cuts
812     ///  as well as any Ether sent directly to the contract address.
813     ///  Always transfers to the NFT (ERC721) contract, but can be called either by
814     ///  the owner or the NFT (ERC721) contract.
815     function withdrawBalance() onlyBanker {
816         // We are using this boolean method to make sure that even if one fails it will still work
817         bankManager.transfer(this.balance);
818     }
819 
820     // @dev a function to claim refund if and only if theres an error in the contract
821     function claimRefund(address _ownerAddress) whenError {
822         uint256 refundValue = addressToValue[_ownerAddress];
823 
824         require (refundValue > 0);
825         
826         addressToValue[_ownerAddress] = 0;
827 
828         _ownerAddress.transfer(refundValue);
829         RefundClaimed(_ownerAddress, refundValue);
830     }
831     
832 
833     /// @dev Function used to set the flag isRedeemed to true
834     /// can be called by addresses in the approvedAddressList
835     function isRedeemed(uint256 _tokenId) {
836         require(approvedAddressList[msg.sender]);
837         require(_tokenId > STARTING_ASSET_BASE);
838         uint256 generatedCollectibleId = _tokenId - STARTING_ASSET_BASE;
839         
840         CSCPreSaleItem memory _Obj = allPreSaleItems[generatedCollectibleId];
841         _Obj.isRedeemed = true;
842         
843         allPreSaleItems[generatedCollectibleId] = _Obj;
844     }
845 }