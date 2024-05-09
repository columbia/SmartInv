1 // File: contracts/ERC721/el/IBurnableEtherLegendsToken.sol
2 
3 pragma solidity 0.5.0;
4 
5 interface IBurnableEtherLegendsToken {        
6     function burn(uint256 tokenId) external;
7 }
8 
9 // File: contracts/ERC721/el/IMintableEtherLegendsToken.sol
10 
11 pragma solidity 0.5.0;
12 
13 interface IMintableEtherLegendsToken {        
14     function mintTokenOfType(address to, uint256 idOfTokenType) external;
15 }
16 
17 // File: contracts/ERC721/el/ITokenDefinitionManager.sol
18 
19 pragma solidity 0.5.0;
20 
21 interface ITokenDefinitionManager {        
22     function getNumberOfTokenDefinitions() external view returns (uint256);
23     function hasTokenDefinition(uint256 tokenTypeId) external view returns (bool);
24     function getTokenTypeNameAtIndex(uint256 index) external view returns (string memory);
25     function getTokenTypeName(uint256 tokenTypeId) external view returns (string memory);
26     function getTokenTypeId(string calldata name) external view returns (uint256);
27     function getCap(uint256 tokenTypeId) external view returns (uint256);
28     function getAbbreviation(uint256 tokenTypeId) external view returns (string memory);
29 }
30 
31 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others (`ERC165Checker`).
41  *
42  * For an implementation, see `ERC165`.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
57 
58 pragma solidity ^0.5.0;
59 
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 contract IERC721 is IERC165 {
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of NFTs in `owner`'s account.
71      */
72     function balanceOf(address owner) public view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the NFT specified by `tokenId`.
76      */
77     function ownerOf(uint256 tokenId) public view returns (address owner);
78 
79     /**
80      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
81      * another (`to`).
82      *
83      * 
84      *
85      * Requirements:
86      * - `from`, `to` cannot be zero.
87      * - `tokenId` must be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this
89      * NFT by either `approve` or `setApproveForAll`.
90      */
91     function safeTransferFrom(address from, address to, uint256 tokenId) public;
92     /**
93      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
94      * another (`to`).
95      *
96      * Requirements:
97      * - If the caller is not `from`, it must be approved to move this NFT by
98      * either `approve` or `setApproveForAll`.
99      */
100     function transferFrom(address from, address to, uint256 tokenId) public;
101     function approve(address to, uint256 tokenId) public;
102     function getApproved(uint256 tokenId) public view returns (address operator);
103 
104     function setApprovalForAll(address operator, bool _approved) public;
105     function isApprovedForAll(address owner, address operator) public view returns (bool);
106 
107 
108     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
112 
113 pragma solidity ^0.5.0;
114 
115 
116 /**
117  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
118  * @dev See https://eips.ethereum.org/EIPS/eip-721
119  */
120 contract IERC721Enumerable is IERC721 {
121     function totalSupply() public view returns (uint256);
122     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
123 
124     function tokenByIndex(uint256 index) public view returns (uint256);
125 }
126 
127 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
128 
129 pragma solidity ^0.5.0;
130 
131 
132 /**
133  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
134  * @dev See https://eips.ethereum.org/EIPS/eip-721
135  */
136 contract IERC721Metadata is IERC721 {
137     function name() external view returns (string memory);
138     function symbol() external view returns (string memory);
139     function tokenURI(uint256 tokenId) external view returns (string memory);
140 }
141 
142 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol
143 
144 pragma solidity ^0.5.0;
145 
146 
147 
148 
149 /**
150  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
151  * @dev See https://eips.ethereum.org/EIPS/eip-721
152  */
153 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
154     // solhint-disable-previous-line no-empty-blocks
155 }
156 
157 // File: contracts/ERC721/el/IEtherLegendsToken.sol
158 
159 pragma solidity 0.5.0;
160 
161 
162 
163 
164 
165 contract IEtherLegendsToken is IERC721Full, IMintableEtherLegendsToken, IBurnableEtherLegendsToken, ITokenDefinitionManager {
166     function totalSupplyOfType(uint256 tokenTypeId) external view returns (uint256);
167     function getTypeIdOfToken(uint256 tokenId) external view returns (uint256);
168 }
169 
170 // File: contracts/ERC721/el/IBoosterPack.sol
171 
172 pragma solidity 0.5.0;
173 
174 interface IBoosterPack {        
175     function getNumberOfCards() external view returns (uint256);
176     function getCardTypeIdAtIndex(uint256 index) external view returns (uint256);
177     function getPricePerCard() external view returns (uint256);
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
181 
182 pragma solidity ^0.5.0;
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see `ERC20Detailed`.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a `Transfer` event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through `transferFrom`. This is
211      * zero by default.
212      *
213      * This value changes when `approve` or `transferFrom` are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * > Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an `Approval` event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a `Transfer` event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to `approve`. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
260 
261 pragma solidity ^0.5.0;
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be aplied to your functions to restrict their use to
270  * the owner.
271  */
272 contract Ownable {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor () internal {
281         _owner = msg.sender;
282         emit OwnershipTransferred(address(0), _owner);
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(isOwner(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @dev Returns true if the caller is the current owner.
302      */
303     function isOwner() public view returns (bool) {
304         return msg.sender == _owner;
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * > Note: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public onlyOwner {
315         emit OwnershipTransferred(_owner, address(0));
316         _owner = address(0);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public onlyOwner {
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      */
330     function _transferOwnership(address newOwner) internal {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335 }
336 
337 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
338 
339 pragma solidity ^0.5.0;
340 
341 /**
342  * @dev Contract module that helps prevent reentrant calls to a function.
343  *
344  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
345  * available, which can be aplied to functions to make sure there are no nested
346  * (reentrant) calls to them.
347  *
348  * Note that because there is a single `nonReentrant` guard, functions marked as
349  * `nonReentrant` may not call one another. This can be worked around by making
350  * those functions `private`, and then adding `external` `nonReentrant` entry
351  * points to them.
352  */
353 contract ReentrancyGuard {
354     /// @dev counter to allow mutex lock with only one SSTORE operation
355     uint256 private _guardCounter;
356 
357     constructor () internal {
358         // The counter starts at one to prevent changing it from zero to a non-zero
359         // value, which is a more expensive operation.
360         _guardCounter = 1;
361     }
362 
363     /**
364      * @dev Prevents a contract from calling itself, directly or indirectly.
365      * Calling a `nonReentrant` function from another `nonReentrant`
366      * function is not supported. It is possible to prevent this from happening
367      * by making the `nonReentrant` function external, and make it call a
368      * `private` function that does the actual work.
369      */
370     modifier nonReentrant() {
371         _guardCounter += 1;
372         uint256 localCounter = _guardCounter;
373         _;
374         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
375     }
376 }
377 
378 // File: contracts/ERC721/el/BoosterPack.sol
379 
380 pragma solidity 0.5.0;
381 
382 
383 
384 
385 
386 
387 contract BoosterPack is IBoosterPack, Ownable, ReentrancyGuard {
388 
389   // Address where funds are collected
390   address public payee;
391 
392   // Address where elementeum funds are payed to users from
393   address public funder;
394 
395   // Address that is permitted to call destroyContract
396   address public permittedDestroyer;
397 
398   // ETH price per card
399   uint256 public pricePerCard = 50 finney;
400 
401   uint256[] public cardTypeIds;
402   uint16 private totalWeight;
403   mapping (uint16 => uint256) private rollToCard;
404   mapping (uint256 => uint256) private cardToElementeumReturned;
405   bytes32 private lastHash;
406 
407   IEtherLegendsToken public etherLegendsToken;
408   IERC20 public elementeumToken;
409 
410   constructor(address payeeWallet, address funderWallet) public 
411     Ownable() 
412     ReentrancyGuard() {
413     payee = payeeWallet;
414     funder = funderWallet;
415     lastHash = keccak256(abi.encodePacked(block.number));
416   }
417 
418   /**
419    * @dev fallback function ***DO NOT OVERRIDE***
420    */
421   function () external payable {
422     purchaseCards(msg.sender);
423   }
424 
425   function destroyContract() external {
426     require(msg.sender == permittedDestroyer, "caller is not the permitted destroyer - should be address of BoosterPackFactory");
427     address payable payableOwner = address(uint160(owner()));
428     selfdestruct(payableOwner);
429   }
430 
431   function setEtherLegendsToken(address addr) external {
432     _requireOnlyOwner();
433     etherLegendsToken = IEtherLegendsToken(addr);
434   }  
435 
436   function setElementeumERC20ContractAddress(address addr) external {
437     _requireOnlyOwner();
438     elementeumToken = IERC20(addr);
439   }    
440 
441   function setPricePerCard(uint256 price) public {
442     _requireOnlyOwner();
443     pricePerCard = price;
444   }
445 
446   function permitDestruction(address addr) external {
447     _requireOnlyOwner();
448     require(addr != address(0));
449     permittedDestroyer = addr;
450   }
451 
452   function setDropWeights(uint256[] calldata tokenTypeIds, uint8[] calldata weights, uint256[] calldata elementeumsReturned) external {
453     _requireOnlyOwner();
454     require(
455       tokenTypeIds.length > 0 && 
456       tokenTypeIds.length == weights.length && 
457       tokenTypeIds.length == elementeumsReturned.length, 
458       "array lengths are not the same");
459 
460     for(uint256 i = 0; i < tokenTypeIds.length; i++) {
461       setDropWeight(tokenTypeIds[i], weights[i], elementeumsReturned[i]);
462     }    
463   }
464 
465   function setDropWeight(uint256 tokenTypeId, uint8 weight, uint256 elementeumReturned) public {
466     _requireOnlyOwner();    
467     require(etherLegendsToken.hasTokenDefinition(tokenTypeId), "card is not defined");
468     totalWeight += weight;
469     for(uint16 i = totalWeight - weight; i < totalWeight; i++) {
470       rollToCard[i] = tokenTypeId;
471     }
472     cardToElementeumReturned[tokenTypeId] = elementeumReturned;
473     cardTypeIds.push(tokenTypeId);
474   }
475 
476   function getNumberOfCards() external view returns (uint256) {
477     return cardTypeIds.length;
478   }
479 
480   function getCardTypeIdAtIndex(uint256 index) external view returns (uint256) {
481     require(index < cardTypeIds.length, "Index Out Of Range");
482     return cardTypeIds[index];
483   }
484 
485   function getPricePerCard() external view returns (uint256) {
486     return pricePerCard;
487   }
488 
489   function getCardTypeIds() external view returns (uint256[] memory) {
490     return cardTypeIds;
491   }  
492 
493   function purchaseCards(address beneficiary) public payable nonReentrant {
494     require(msg.sender == tx.origin, "caller must be transaction origin (only human)");    
495     require(msg.value >= pricePerCard, "purchase price not met");
496     require(pricePerCard > 0, "price per card must be greater than 0");
497     require(totalWeight > 0, "total weight must be greater than 0");
498 
499     uint256 numberOfCards = _min(msg.value / pricePerCard, (gasleft() - 100000) / 200000);
500     uint256 totalElementeumToReturn = 0;
501     bytes32 tempLastHash =  lastHash;    
502     for(uint256 i = 0; i < numberOfCards; i++) {
503         tempLastHash = keccak256(abi.encodePacked(block.number, tempLastHash, msg.sender, gasleft()));
504         uint16 randNumber = uint16(uint256(tempLastHash) % (totalWeight));        
505         uint256 cardType = rollToCard[randNumber];
506 
507         etherLegendsToken.mintTokenOfType(beneficiary, cardType);        
508         totalElementeumToReturn += cardToElementeumReturned[cardType];                
509     }
510 
511     lastHash = tempLastHash; // Save in the blockchain for next tx
512     
513     if(totalElementeumToReturn > 0) {
514       uint256 elementeumThatCanBeReturned = _min(totalElementeumToReturn, _min(elementeumToken.allowance(funder, address(this)), elementeumToken.balanceOf(funder)));
515       if(elementeumThatCanBeReturned > 0) {
516         elementeumToken.transferFrom(funder, beneficiary, elementeumThatCanBeReturned);      
517       }            
518     }
519 
520     uint256 change = msg.value - (pricePerCard * numberOfCards); //This amount to be refunded as it was unused
521     address payable payableWallet = address(uint160(payee));
522     payableWallet.transfer(pricePerCard  * numberOfCards);
523     if(change > 0) {
524       msg.sender.transfer(change);
525     }
526   }
527 
528   function _min(uint256 a, uint256 b) internal pure returns (uint256) {
529     return a < b ? a : b;
530   }  
531 
532   function _requireOnlyOwner() internal view {
533     require(isOwner(), "Ownable: caller is not the owner");
534   }
535 }