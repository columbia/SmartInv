1 // File: contracts/ERC1155/enjin/Common.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6     Note: Simple contract to use as base for const vals
7 */
8 contract CommonConstants {
9 
10     bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
11     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
12 }
13 
14 // File: contracts/ERC1155/enjin/IEnjinERC1155.sol
15 
16 pragma solidity 0.5.0;
17 
18 interface IEnjinERC1155 {
19   function acceptAssignment ( uint256 _id ) external;
20   function assign ( uint256 _id, address _creator ) external;
21   function balanceOf ( address _owner, uint256 _id ) external view returns ( uint256 );
22   function balanceOfBatch ( address[] calldata _owners, uint256[] calldata _ids ) external view returns ( uint256[] memory);
23   function create ( string calldata _name, uint256 _totalSupply, uint256 _initialReserve, address _supplyModel, uint256 _meltValue, uint16 _meltFeeRatio, uint8 _transferable, uint256[3] calldata _transferFeeSettings, bool _nonFungible ) external;
24   function isApprovedForAll ( address _owner, address _operator ) external view returns ( bool );
25   function melt ( uint256[] calldata _ids, uint256[] calldata _values ) external;
26   function mintFungibles ( uint256 _id, address[] calldata _to, uint256[] calldata _values ) external;
27   function mintNonFungibles ( uint256 _id, address[] calldata _to ) external;
28   function safeBatchTransferFrom ( address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data ) external;
29   function safeTransferFrom ( address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data ) external;
30   function setApprovalForAll ( address _operator, bool _approved ) external;
31   function setURI ( uint256 _id, string calldata _uri ) external;
32   function supportsInterface ( bytes4 _interfaceID ) external pure returns ( bool );
33   function uri ( uint256 _id ) external view returns ( string memory );
34 }
35 
36 // File: contracts/ERC1155/enjin/IERC1155TokenReceiver.sol
37 
38 pragma solidity 0.5.0;
39 
40 /**
41     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
42 */
43 interface ERC1155TokenReceiver {
44     /**
45         @notice Handle the receipt of a single ERC1155 token type.
46         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
47         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
48         This function MUST revert if it rejects the transfer.
49         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
50         @param _operator  The address which initiated the transfer (i.e. msg.sender)
51         @param _from      The address which previously owned the token
52         @param _id        The ID of the token being transferred
53         @param _value     The amount of tokens being transferred
54         @param _data      Additional data with no specified format
55         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
56     */
57     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
58 
59     /**
60         @notice Handle the receipt of multiple ERC1155 token types.
61         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
62         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
63         This function MUST revert if it rejects the transfer(s).
64         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
65         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
66         @param _from      The address which previously owned the token
67         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
68         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
69         @param _data      Additional data with no specified format
70         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
71     */
72     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
73 }
74 
75 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
76 
77 pragma solidity ^0.5.0;
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
81  * the optional functions; to access them see `ERC20Detailed`.
82  */
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a `Transfer` event.
100      */
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Returns the remaining number of tokens that `spender` will be
105      * allowed to spend on behalf of `owner` through `transferFrom`. This is
106      * zero by default.
107      *
108      * This value changes when `approve` or `transferFrom` are called.
109      */
110     function allowance(address owner, address spender) external view returns (uint256);
111 
112     /**
113      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * > Beware that changing an allowance with this method brings the risk
118      * that someone may use both the old and the new allowance by unfortunate
119      * transaction ordering. One possible solution to mitigate this race
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an `Approval` event.
125      */
126     function approve(address spender, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Moves `amount` tokens from `sender` to `recipient` using the
130      * allowance mechanism. `amount` is then deducted from the caller's
131      * allowance.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a `Transfer` event.
136      */
137     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Emitted when `value` tokens are moved from one account (`from`) to
141      * another (`to`).
142      *
143      * Note that `value` may be zero.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     /**
148      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
149      * a call to `approve`. `value` is the new allowance.
150      */
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: contracts/ERC721/el/forging/ForgeERC1155Operations.sol
155 
156 pragma solidity 0.5.0;
157 
158 
159 
160 
161 
162 contract ForgeERC1155Operations is ERC1155TokenReceiver, CommonConstants {
163 
164     // The Enjin ERC-1155 smart contract
165     IEnjinERC1155 public enjinContract;
166 
167     // The Enjin Coin ERC-20 smart contract
168     IERC20 public enjinCoinContract;
169 
170     function safeTransferFungibleItemWithOptionalMelt(uint256 tokenId, address recipient, bool melt) internal {
171       bytes memory extraData = new bytes(0); 
172       enjinContract.safeTransferFrom(msg.sender, melt ? address(this) : recipient, tokenId, 1, extraData);
173 
174       if(melt) {
175         uint256 startingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
176         uint256[] memory ids = new uint256[](1);
177         uint256[] memory values = new uint256[](1);
178         ids[0] = tokenId;
179         values[0] = 1;
180         enjinContract.melt(ids, values);
181         uint256 endingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
182         uint256 changeInEnjinCoinBalance = endingEnjinCoinBalance - startingEnjinCoinBalance;
183 
184         if(changeInEnjinCoinBalance > 0) {
185           enjinCoinContract.transfer(msg.sender, changeInEnjinCoinBalance);
186         }
187       }
188     }    
189 
190     function safeTransferNonFungibleItemWithOptionalMelt(uint256 tokenId, uint256 NFTIndex, address recipient, bool melt) internal {
191       uint256[] memory nftIds = new uint256[](1);
192       uint256[] memory values = new uint256[](1);
193       nftIds[0] = tokenId | NFTIndex;
194       values[0] = 1;
195 
196       bytes memory extraData = new bytes(0);
197       enjinContract.safeBatchTransferFrom(msg.sender, melt ? address(this) : recipient, nftIds, values, extraData);
198 
199       if(melt) {
200         uint256 startingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
201         enjinContract.melt(nftIds, values);
202         uint256 endingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
203         uint256 changeInEnjinCoinBalance = endingEnjinCoinBalance - startingEnjinCoinBalance;
204 
205         if(changeInEnjinCoinBalance > 0) {
206           enjinCoinContract.transfer(msg.sender, changeInEnjinCoinBalance);
207         }        
208       }      
209     }        
210 
211     function onERC1155Received(address /*_operator*/, address /*_from*/, uint256 /*_id*/, uint256 /*_value*/, bytes calldata /*_data*/) external returns(bytes4) {
212       return ERC1155_ACCEPTED;
213     }
214 
215     function onERC1155BatchReceived(address /*_operator*/, address /*_from*/, uint256[] calldata /*_ids*/, uint256[] calldata /*_values*/, bytes calldata /*_data*/) external returns(bytes4) {        
216       return ERC1155_BATCH_ACCEPTED;        
217     }
218 
219     // ERC165 interface support
220     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
221         return  interfaceID == 0x01ffc9a7 ||    // ERC165
222                 interfaceID == 0x4e2312e0;      // ERC1155_ACCEPTED ^ ERC1155_BATCH_ACCEPTED;
223     }
224 }
225 
226 // File: contracts/ERC721/el/forging/IForgePathCatalogCombined.sol
227 
228 pragma solidity 0.5.0;
229 
230 interface IForgePathCatalogCombined {        
231     function getNumberOfPathDefinitions() external view returns (uint256);
232     function getForgePathNameAtIndex(uint256 index) external view returns (string memory);
233     function getForgePathIdAtIndex(uint256 index) external view returns (uint256);
234 
235     function getForgeType(uint256 pathId) external view returns (uint8);
236     function getForgePathDetailsCommon(uint256 pathId) external view returns (uint256, uint256, uint256);
237     function getForgePathDetailsTwoGen1Tokens(uint256 pathId) external view returns (uint256, uint256, bool, bool);
238     function getForgePathDetailsTwoERC721Addresses(uint256 pathId) external view returns (address, address);
239     function getForgePathDetailsERC721AddressWithGen1Token(uint256 pathId) external view returns (address, uint256, bool);
240     function getForgePathDetailsTwoERC1155Tokens(uint256 pathId) external view returns (uint256, uint256, bool, bool, bool, bool);
241     function getForgePathDetailsERC1155WithGen1Token(uint256 pathId) external view returns (uint256, uint256, bool, bool, bool);
242     function getForgePathDetailsERC1155WithERC721Address(uint256 pathId) external view returns (uint256, address, bool, bool);
243 }
244 
245 // File: contracts/ERC721/el/IBurnableEtherLegendsToken.sol
246 
247 pragma solidity 0.5.0;
248 
249 interface IBurnableEtherLegendsToken {        
250     function burn(uint256 tokenId) external;
251 }
252 
253 // File: contracts/ERC721/el/IMintableEtherLegendsToken.sol
254 
255 pragma solidity 0.5.0;
256 
257 interface IMintableEtherLegendsToken {        
258     function mintTokenOfType(address to, uint256 idOfTokenType) external;
259 }
260 
261 // File: contracts/ERC721/el/ITokenDefinitionManager.sol
262 
263 pragma solidity 0.5.0;
264 
265 interface ITokenDefinitionManager {        
266     function getNumberOfTokenDefinitions() external view returns (uint256);
267     function hasTokenDefinition(uint256 tokenTypeId) external view returns (bool);
268     function getTokenTypeNameAtIndex(uint256 index) external view returns (string memory);
269     function getTokenTypeName(uint256 tokenTypeId) external view returns (string memory);
270     function getTokenTypeId(string calldata name) external view returns (uint256);
271     function getCap(uint256 tokenTypeId) external view returns (uint256);
272     function getAbbreviation(uint256 tokenTypeId) external view returns (string memory);
273 }
274 
275 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
276 
277 pragma solidity ^0.5.0;
278 
279 /**
280  * @dev Interface of the ERC165 standard, as defined in the
281  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
282  *
283  * Implementers can declare support of contract interfaces, which can then be
284  * queried by others (`ERC165Checker`).
285  *
286  * For an implementation, see `ERC165`.
287  */
288 interface IERC165 {
289     /**
290      * @dev Returns true if this contract implements the interface defined by
291      * `interfaceId`. See the corresponding
292      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
293      * to learn more about how these ids are created.
294      *
295      * This function call must use less than 30 000 gas.
296      */
297     function supportsInterface(bytes4 interfaceId) external view returns (bool);
298 }
299 
300 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
301 
302 pragma solidity ^0.5.0;
303 
304 
305 /**
306  * @dev Required interface of an ERC721 compliant contract.
307  */
308 contract IERC721 is IERC165 {
309     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
310     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
311     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
312 
313     /**
314      * @dev Returns the number of NFTs in `owner`'s account.
315      */
316     function balanceOf(address owner) public view returns (uint256 balance);
317 
318     /**
319      * @dev Returns the owner of the NFT specified by `tokenId`.
320      */
321     function ownerOf(uint256 tokenId) public view returns (address owner);
322 
323     /**
324      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
325      * another (`to`).
326      *
327      * 
328      *
329      * Requirements:
330      * - `from`, `to` cannot be zero.
331      * - `tokenId` must be owned by `from`.
332      * - If the caller is not `from`, it must be have been allowed to move this
333      * NFT by either `approve` or `setApproveForAll`.
334      */
335     function safeTransferFrom(address from, address to, uint256 tokenId) public;
336     /**
337      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
338      * another (`to`).
339      *
340      * Requirements:
341      * - If the caller is not `from`, it must be approved to move this NFT by
342      * either `approve` or `setApproveForAll`.
343      */
344     function transferFrom(address from, address to, uint256 tokenId) public;
345     function approve(address to, uint256 tokenId) public;
346     function getApproved(uint256 tokenId) public view returns (address operator);
347 
348     function setApprovalForAll(address operator, bool _approved) public;
349     function isApprovedForAll(address owner, address operator) public view returns (bool);
350 
351 
352     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
353 }
354 
355 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
356 
357 pragma solidity ^0.5.0;
358 
359 
360 /**
361  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
362  * @dev See https://eips.ethereum.org/EIPS/eip-721
363  */
364 contract IERC721Enumerable is IERC721 {
365     function totalSupply() public view returns (uint256);
366     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
367 
368     function tokenByIndex(uint256 index) public view returns (uint256);
369 }
370 
371 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
372 
373 pragma solidity ^0.5.0;
374 
375 
376 /**
377  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
378  * @dev See https://eips.ethereum.org/EIPS/eip-721
379  */
380 contract IERC721Metadata is IERC721 {
381     function name() external view returns (string memory);
382     function symbol() external view returns (string memory);
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol
387 
388 pragma solidity ^0.5.0;
389 
390 
391 
392 
393 /**
394  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
395  * @dev See https://eips.ethereum.org/EIPS/eip-721
396  */
397 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
398     // solhint-disable-previous-line no-empty-blocks
399 }
400 
401 // File: contracts/ERC721/el/IEtherLegendsToken.sol
402 
403 pragma solidity 0.5.0;
404 
405 
406 
407 
408 
409 contract IEtherLegendsToken is IERC721Full, IMintableEtherLegendsToken, IBurnableEtherLegendsToken, ITokenDefinitionManager {
410     function totalSupplyOfType(uint256 tokenTypeId) external view returns (uint256);
411     function getTypeIdOfToken(uint256 tokenId) external view returns (uint256);
412 }
413 
414 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
415 
416 pragma solidity ^0.5.0;
417 
418 /**
419  * @dev Contract module which provides a basic access control mechanism, where
420  * there is an account (an owner) that can be granted exclusive access to
421  * specific functions.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be aplied to your functions to restrict their use to
425  * the owner.
426  */
427 contract Ownable {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () internal {
436         _owner = msg.sender;
437         emit OwnershipTransferred(address(0), _owner);
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if called by any account other than the owner.
449      */
450     modifier onlyOwner() {
451         require(isOwner(), "Ownable: caller is not the owner");
452         _;
453     }
454 
455     /**
456      * @dev Returns true if the caller is the current owner.
457      */
458     function isOwner() public view returns (bool) {
459         return msg.sender == _owner;
460     }
461 
462     /**
463      * @dev Leaves the contract without owner. It will not be possible to call
464      * `onlyOwner` functions anymore. Can only be called by the current owner.
465      *
466      * > Note: Renouncing ownership will leave the contract without an owner,
467      * thereby removing any functionality that is only available to the owner.
468      */
469     function renounceOwnership() public onlyOwner {
470         emit OwnershipTransferred(_owner, address(0));
471         _owner = address(0);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Can only be called by the current owner.
477      */
478     function transferOwnership(address newOwner) public onlyOwner {
479         _transferOwnership(newOwner);
480     }
481 
482     /**
483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
484      */
485     function _transferOwnership(address newOwner) internal {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         emit OwnershipTransferred(_owner, newOwner);
488         _owner = newOwner;
489     }
490 }
491 
492 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
493 
494 pragma solidity ^0.5.0;
495 
496 /**
497  * @dev Contract module that helps prevent reentrant calls to a function.
498  *
499  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
500  * available, which can be aplied to functions to make sure there are no nested
501  * (reentrant) calls to them.
502  *
503  * Note that because there is a single `nonReentrant` guard, functions marked as
504  * `nonReentrant` may not call one another. This can be worked around by making
505  * those functions `private`, and then adding `external` `nonReentrant` entry
506  * points to them.
507  */
508 contract ReentrancyGuard {
509     /// @dev counter to allow mutex lock with only one SSTORE operation
510     uint256 private _guardCounter;
511 
512     constructor () internal {
513         // The counter starts at one to prevent changing it from zero to a non-zero
514         // value, which is a more expensive operation.
515         _guardCounter = 1;
516     }
517 
518     /**
519      * @dev Prevents a contract from calling itself, directly or indirectly.
520      * Calling a `nonReentrant` function from another `nonReentrant`
521      * function is not supported. It is possible to prevent this from happening
522      * by making the `nonReentrant` function external, and make it call a
523      * `private` function that does the actual work.
524      */
525     modifier nonReentrant() {
526         _guardCounter += 1;
527         uint256 localCounter = _guardCounter;
528         _;
529         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
530     }
531 }
532 
533 // File: contracts/ERC721/el/forging/ForgeCombined.sol
534 
535 pragma solidity 0.5.0;
536 
537 
538 
539 
540 
541 
542 
543 
544 
545 contract ForgeCombined is ForgeERC1155Operations, Ownable, ReentrancyGuard {    
546 
547     // Address to which elementeum and ETH are transferred
548     address public payee;    
549 
550     // Address to which non-melted items are transferred
551     address public lootWallet;    
552 
553     // The forge catalog smart contract
554     IForgePathCatalogCombined public catalogContract;    
555 
556     // The Elementeum ERC-20 token smart contract
557     IERC20 public elementeumContract;
558 
559     // The Ether Legends Gen 1 ERC-721 token smart contract
560     IEtherLegendsToken public etherLegendsGen1;    
561 
562     constructor() public 
563       Ownable()
564       ReentrancyGuard()
565     {
566       
567     }    
568 
569     function() external payable {
570         revert("Fallback function not permitted.");
571     }
572 
573     function destroyContract() external {
574       _requireOnlyOwner();
575       address payable payableOwner = address(uint160(owner()));
576       selfdestruct(payableOwner);
577     }
578 
579     function setPayee(address addr) external {
580       _requireOnlyOwner();
581       payee = addr;
582     }
583 
584     function setLootWallet(address addr) external {
585       _requireOnlyOwner();
586       lootWallet = addr;
587     }
588 
589     function setCatalogContractAddress(address addr) external {
590       _requireOnlyOwner();
591       catalogContract = IForgePathCatalogCombined(addr);
592     }
593 
594     function setElementeumERC20ContractAddress(address addr) external {
595       _requireOnlyOwner();
596       elementeumContract = IERC20(addr);
597     }    
598 
599     function setEtherLegendsGen1(address addr) external {
600       _requireOnlyOwner();
601       etherLegendsGen1 = IEtherLegendsToken(addr);
602     }  
603 
604     function setEnjinERC1155ContractAddress(address addr) external {
605       _requireOnlyOwner();
606       enjinContract = IEnjinERC1155(addr);
607     }
608 
609     function setEnjinERC20ContractAddress(address addr) external {
610       _requireOnlyOwner();
611       enjinCoinContract = IERC20(addr);
612     }
613 
614     function forge(uint256 pathId, uint256 material1TokenId, uint256 material2TokenId) external payable nonReentrant {
615       _requireOnlyHuman();      
616 
617       uint8 forgeType = catalogContract.getForgeType(pathId);
618       (uint256 weiCost, uint256 elementeumCost, uint256 forgedItem) = catalogContract.getForgePathDetailsCommon(pathId);
619 
620       require(msg.value >= weiCost, "Insufficient ETH");
621 
622       if(forgeType == 1) {
623         require(material1TokenId != material2TokenId, "NFT ids must be unique");  
624         (uint256 material1, 
625          uint256 material2, 
626          bool burnMaterial1, 
627          bool burnMaterial2) = catalogContract.getForgePathDetailsTwoGen1Tokens(pathId);
628          _forgeGen1Token(material1, material1TokenId, burnMaterial1);
629          _forgeGen1Token(material2, material2TokenId, burnMaterial2);
630       } else if(forgeType == 2) {
631         (address material1, address material2) = catalogContract.getForgePathDetailsTwoERC721Addresses(pathId);
632         if(material1 == material2) {
633           require(material1TokenId != material2TokenId, "NFT ids must be unique");
634         }
635         _forgeERC721Token(material1, material1TokenId);
636         _forgeERC721Token(material2, material2TokenId);
637       } else if(forgeType == 3) {
638         (address material1, 
639          uint256 material2, 
640          bool burnMaterial2) = catalogContract.getForgePathDetailsERC721AddressWithGen1Token(pathId);
641          _forgeERC721Token(material1, material1TokenId);
642          _forgeGen1Token(material2, material2TokenId, burnMaterial2);
643       } else if(forgeType == 4) {
644         (uint256 material1,
645          uint256 material2,
646          bool meltMaterial1,
647          bool meltMaterial2,
648          bool material1IsNonFungible,
649          bool material2IsNonFungible) = catalogContract.getForgePathDetailsTwoERC1155Tokens(pathId);
650         if(material1 == material2 && material1IsNonFungible && material2IsNonFungible) {
651           require(material1TokenId != material2TokenId, "NFT ids must be unique");
652         }
653         _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
654         _forgeERC1155Token(material2, material2TokenId, meltMaterial2, material2IsNonFungible);
655       } else if(forgeType == 5) {
656         (uint256 material1,
657          uint256 material2,
658          bool meltMaterial1,
659          bool burnMaterial2,
660          bool material1IsNonFungible) = catalogContract.getForgePathDetailsERC1155WithGen1Token(pathId);
661          _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
662          _forgeGen1Token(material2, material2TokenId, burnMaterial2);
663       } else if(forgeType == 6) {
664         (uint256 material1,
665          address material2,
666          bool meltMaterial1,
667          bool material1IsNonFungible) = catalogContract.getForgePathDetailsERC1155WithERC721Address(pathId);
668          _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
669          _forgeERC721Token(material2, material2TokenId);
670       } else {
671         revert("Non-existent forge type");
672       }
673 
674       if(elementeumCost > 0) {
675         elementeumContract.transferFrom(msg.sender, payee, elementeumCost);      
676       }                    
677 
678       if(msg.value > 0) {                
679         address payable payableWallet = address(uint160(payee));
680         payableWallet.transfer(weiCost);
681 
682         uint256 change = msg.value - weiCost;
683         if(change > 0) {
684           msg.sender.transfer(change);
685         }
686       }
687 
688       etherLegendsGen1.mintTokenOfType(msg.sender, forgedItem);            
689     }
690 
691     function _forgeGen1Token(uint256 material, uint256 tokenId, bool burnMaterial) internal {
692       _verifyOwnershipAndApprovalERC721(address(etherLegendsGen1), tokenId);
693       require(material == etherLegendsGen1.getTypeIdOfToken(tokenId), "Incorrect material type");
694       burnMaterial ? etherLegendsGen1.burn(tokenId) : _safeTransferERC721(address(etherLegendsGen1), tokenId);
695     } 
696 
697     function _forgeERC721Token(address material, uint256 tokenId) internal {
698       _verifyOwnershipAndApprovalERC721(material, tokenId);
699       _safeTransferERC721(material, tokenId);
700     }       
701 
702     function _forgeERC1155Token(uint256 material, uint256 materialNFTIndex, bool meltMaterial, bool materialIsNonFungible) internal {
703       require(enjinContract.isApprovedForAll(msg.sender, address(this)), "Not approved to spend user's ERC1155 tokens");      
704       require(enjinContract.balanceOf(msg.sender, materialIsNonFungible ? ( material | materialNFTIndex ) : material) > 0, "Insufficient material balance");  
705       materialIsNonFungible ? 
706       safeTransferNonFungibleItemWithOptionalMelt(material, materialNFTIndex, lootWallet, meltMaterial) :
707       safeTransferFungibleItemWithOptionalMelt(material, lootWallet, meltMaterial);
708     }                 
709 
710     function _verifyOwnershipAndApprovalERC721(address tokenAddress, uint256 tokenId) internal view {
711       IERC721Full tokenContract = IERC721Full(tokenAddress);
712       require(tokenContract.ownerOf(tokenId) == msg.sender, "Token not owned by user");
713       require(tokenContract.getApproved(tokenId) == address(this) || tokenContract.isApprovedForAll(msg.sender, address(this)), "Token not approved");      
714     }    
715 
716     function _safeTransferERC721(address tokenAddress, uint256 tokenId) internal {
717       IERC721Full tokenContract = IERC721Full(tokenAddress);
718       tokenContract.safeTransferFrom(msg.sender, lootWallet, tokenId);
719     }    
720 
721     function _requireOnlyOwner() internal view {
722       require(isOwner(), "Ownable: caller is not the owner");
723     }
724 
725     function _requireOnlyHuman() internal view {
726       require(msg.sender == tx.origin, "Caller must be human user");
727     }
728 }