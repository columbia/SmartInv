1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.9.3 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
6 
7 // License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
33 
34 // License-Identifier: MIT
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _setOwner(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _setOwner(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _setOwner(newOwner);
95     }
96 
97     function _setOwner(address newOwner) private {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
106 
107 // License-Identifier: MIT
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Interface of the ERC165 standard, as defined in the
113  * https://eips.ethereum.org/EIPS/eip-165[EIP].
114  *
115  * Implementers can declare support of contract interfaces, which can then be
116  * queried by others ({ERC165Checker}).
117  *
118  * For an implementation, see {ERC165}.
119  */
120 interface IERC165 {
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30 000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 }
131 
132 
133 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
134 
135 // License-Identifier: MIT
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Implementation of the {IERC165} interface.
141  *
142  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
143  * for the additional interface id that will be supported. For example:
144  *
145  * ```solidity
146  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
147  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
148  * }
149  * ```
150  *
151  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
152  */
153 abstract contract ERC165 is IERC165 {
154     /**
155      * @dev See {IERC165-supportsInterface}.
156      */
157     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
158         return interfaceId == type(IERC165).interfaceId;
159     }
160 }
161 
162 
163 // File contracts/interfaces/INFTExtension.sol
164 
165 // License-Identifier: MIT
166 pragma solidity ^0.8.9;
167 
168 interface INFTExtension is IERC165 {
169 }
170 
171 interface INFTURIExtension is INFTExtension {
172     function tokenURI(uint256 tokenId) external view returns (string memory);
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
177 
178 // License-Identifier: MIT
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Required interface of an ERC721 compliant contract.
184  */
185 interface IERC721 is IERC165 {
186     /**
187      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
193      */
194     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
195 
196     /**
197      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
198      */
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     /**
202      * @dev Returns the number of tokens in ``owner``'s account.
203      */
204     function balanceOf(address owner) external view returns (uint256 balance);
205 
206     /**
207      * @dev Returns the owner of the `tokenId` token.
208      *
209      * Requirements:
210      *
211      * - `tokenId` must exist.
212      */
213     function ownerOf(uint256 tokenId) external view returns (address owner);
214 
215     /**
216      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
217      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must exist and be owned by `from`.
224      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
225      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
226      *
227      * Emits a {Transfer} event.
228      */
229     function safeTransferFrom(
230         address from,
231         address to,
232         uint256 tokenId
233     ) external;
234 
235     /**
236      * @dev Transfers `tokenId` token from `from` to `to`.
237      *
238      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(
250         address from,
251         address to,
252         uint256 tokenId
253     ) external;
254 
255     /**
256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
257      * The approval is cleared when the token is transferred.
258      *
259      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
260      *
261      * Requirements:
262      *
263      * - The caller must own the token or be an approved operator.
264      * - `tokenId` must exist.
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Returns the account approved for `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function getApproved(uint256 tokenId) external view returns (address operator);
278 
279     /**
280      * @dev Approve or remove `operator` as an operator for the caller.
281      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
282      *
283      * Requirements:
284      *
285      * - The `operator` cannot be the caller.
286      *
287      * Emits an {ApprovalForAll} event.
288      */
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) external view returns (bool);
297 
298     /**
299      * @dev Safely transfers `tokenId` token from `from` to `to`.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId,
315         bytes calldata data
316     ) external;
317 }
318 
319 
320 // File contracts/interfaces/IMetaverseNFT.sol
321 
322 // License-Identifier: MIT
323 pragma solidity ^0.8.9;
324 
325 interface IAvatarNFT {
326     function DEVELOPER() external pure returns (string memory _url);
327 
328     function DEVELOPER_ADDRESS() external pure returns (address payable _dev);
329 
330     // ------ View functions ------
331     function saleStarted() external view returns (bool);
332 
333     function isExtensionAdded(address extension) external view returns (bool);
334 
335     /**
336         Extra information stored for each tokenId. Optional, provided on mint
337      */
338     function data(uint256 tokenId) external view returns (bytes32);
339 
340     // ------ Mint functions ------
341     /**
342         Mint from NFTExtension contract. Optionally provide data parameter.
343      */
344     function mintExternal(
345         uint256 tokenId,
346         address to,
347         bytes32 data
348     ) external payable;
349 
350     // ------ Admin functions ------
351     function addExtension(address extension) external;
352 
353     function revokeExtension(address extension) external;
354 
355     function withdraw() external;
356 }
357 
358 interface IMetaverseNFT is IAvatarNFT {
359     // ------ View functions ------
360     /**
361         Recommended royalty for tokenId sale.
362      */
363     function royaltyInfo(uint256 tokenId, uint256 salePrice)
364         external
365         view
366         returns (address receiver, uint256 royaltyAmount);
367 
368     // ------ Admin functions ------
369     function setRoyaltyReceiver(address receiver) external;
370 
371     function setRoyaltyFee(uint256 fee) external;
372 }
373 
374 
375 // File contracts/extensions/base/NFTExtension.sol
376 
377 // License-Identifier: MIT
378 pragma solidity ^0.8.9;
379 
380 
381 contract NFTExtension is INFTExtension, ERC165 {
382     IMetaverseNFT public immutable nft;
383 
384     constructor(address _nft) {
385         nft = IMetaverseNFT(_nft);
386     }
387 
388     function beforeMint() internal view {
389         require(nft.isExtensionAdded(address(this)), "NFTExtension: this contract is not allowed to be used as an extension");
390     }
391 
392     function supportsInterface(bytes4 interfaceId) public virtual override(IERC165, ERC165) view returns (bool) {
393         return interfaceId == type(INFTExtension).interfaceId || super.supportsInterface(interfaceId);
394     }
395 
396 }
397 
398 
399 // File contracts/extensions/base/SaleControl.sol
400 
401 // License-Identifier: MIT
402 pragma solidity ^0.8.9;
403 
404 abstract contract SaleControl is Ownable {
405 
406     uint256 public constant __SALE_NEVER_STARTS = 2**256 - 1;
407 
408     uint256 public startTimestamp = __SALE_NEVER_STARTS;
409 
410     modifier whenSaleStarted {
411         require(saleStarted(), "Sale not started yet");
412         _;
413     }
414 
415     function updateStartTimestamp(uint256 _startTimestamp) public onlyOwner {
416         startTimestamp = _startTimestamp;
417     }
418 
419     function startSale() public onlyOwner {
420         startTimestamp = block.timestamp;
421     }
422 
423     function stopSale() public onlyOwner {
424         startTimestamp = __SALE_NEVER_STARTS;
425     }
426 
427     function saleStarted() public view returns (bool) {
428         return block.timestamp >= startTimestamp;
429     }
430 }
431 
432 
433 // File contracts/extensions/LimitedSupplyMintingExtension.sol
434 
435 // License-Identifier: MIT
436 pragma solidity ^0.8.9;
437 
438 
439 interface NFT is IMetaverseNFT {
440     function maxSupply() external view returns (uint256);
441     function totalSupply() external view returns (uint256);
442 }
443 
444 contract LimitedSupplyMintingExtension is NFTExtension, Ownable, SaleControl {
445 
446     uint256 public price;
447     uint256 public maxPerMint;
448     uint256 public maxPerWallet;
449     uint256 public totalMinted;
450     uint256 public extensionSupply;
451 
452     constructor(address _nft, uint256 _price, uint256 _maxPerMint, uint256 _maxPerWallet, uint256 _extensionSupply) NFTExtension(_nft) {
453         stopSale();
454         // sale stopped by default
455 
456         price = _price;
457         maxPerMint = _maxPerMint;
458         maxPerWallet = _maxPerWallet;
459         extensionSupply = _extensionSupply;
460     }
461 
462     function mint(uint256 nTokens) external whenSaleStarted payable {
463         require(IERC721(address(nft)).balanceOf(msg.sender) + nTokens <= maxPerWallet, "LimitedSupplyMintingExtension: max per wallet reached");
464 
465         require(nTokens + totalMinted <= extensionSupply, "max extensionSupply reached");
466         require(nTokens <= maxPerMint, "Too many tokens to mint");
467         require(msg.value >= nTokens * price, "Not enough ETH to mint");
468 
469         totalMinted += nTokens;
470 
471         nft.mintExternal{ value: msg.value }(nTokens, msg.sender, bytes32(0x0));
472     }
473 
474     function maxSupply() public view returns (uint256) {
475         return NFT(address(nft)).maxSupply();
476     }
477 
478     function totalSupply() public view returns (uint256) {
479         return NFT(address(nft)).totalSupply();
480     }
481 
482 }