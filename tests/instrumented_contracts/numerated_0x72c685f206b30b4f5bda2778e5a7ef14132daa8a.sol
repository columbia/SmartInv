1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId,
82         bytes calldata data
83     ) external;
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 }
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes calldata) {
190         return msg.data;
191     }
192 }
193 
194 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Contract module which provides a basic access control mechanism, where
200  * there is an account (an owner) that can be granted exclusive access to
201  * specific functions.
202  *
203  * By default, the owner account will be the one that deploys the contract. This
204  * can later be changed with {transferOwnership}.
205  *
206  * This module is used through inheritance. It will make available the modifier
207  * `onlyOwner`, which can be applied to your functions to restrict their use to
208  * the owner.
209  */
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     /**
216      * @dev Initializes the contract setting the deployer as the initial owner.
217      */
218     constructor() {
219         _transferOwnership(_msgSender());
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         _checkOwner();
227         _;
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if the sender is not the owner.
239      */
240     function _checkOwner() internal view virtual {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242     }
243 
244     /**
245      * @dev Leaves the contract without owner. It will not be possible to call
246      * `onlyOwner` functions anymore. Can only be called by the current owner.
247      *
248      * NOTE: Renouncing ownership will leave the contract without an owner,
249      * thereby removing any functionality that is only available to the owner.
250      */
251     function renounceOwnership() public virtual onlyOwner {
252         _transferOwnership(address(0));
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Can only be called by the current owner.
258      */
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         _transferOwnership(newOwner);
262     }
263 
264     /**
265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
266      * Internal function without access restriction.
267      */
268     function _transferOwnership(address newOwner) internal virtual {
269         address oldOwner = _owner;
270         _owner = newOwner;
271         emit OwnershipTransferred(oldOwner, newOwner);
272     }
273 }
274 
275 pragma solidity ^0.8.7;
276 
277 interface IMoonLanderzNFT {
278     function saleMint(uint256 amount) external payable;
279 }
280 
281 contract MoonBase is Ownable {
282     error InsufficientBalance();
283     error CannotClaim();
284     error NotTokenOwner();
285     error InsufficientETHValue();
286     error MaxMintTxReached();
287     error MintOut();
288     error MintPaused();
289 
290     uint256 private constant BATCH_SIZE = 3;
291     uint256 private constant SALE_PRICE = 0.088 ether;
292     address public mlz;
293     uint256 public currentClaimId;
294     uint256 public lastClaimId = 1420;
295     uint256 public currentMintId;
296     uint256 public lastMintId = 7885;
297     uint256 public mintPrice = 0.044 ether;
298     uint256 public maxMintTx = 3;
299     bool public mintPaused;
300     mapping(uint256 => bool) private claims;
301 
302     event UpdatedLastClaimId(uint256 last);
303     event UpdatedCurrentClaimId(uint256 current);
304     event UpdatedLastMintId(uint256 last);
305     event UpdatedCurrentMintId(uint256 current);
306     event UpdatedMintPrice(uint256 price);
307     event UpdatedMaxMintTx(uint256 max);
308     event UpdatedMintPaused(bool paused);
309     event Claimed(uint256 amount);
310 
311     constructor(address _mlz) {
312         mlz = _mlz;
313     }
314 
315     function updateLastClaimId(uint256 id) external onlyOwner {
316         lastClaimId = id;
317 
318         emit UpdatedLastClaimId(id);
319     }
320 
321     function updateCurrentClaimId(uint256 id) external onlyOwner {
322         currentClaimId = id;
323 
324         emit UpdatedCurrentClaimId(id);
325     }
326 
327     function updateLastMintId(uint256 id) external onlyOwner {
328         lastMintId = id;
329 
330         emit UpdatedLastMintId(id);
331     }
332 
333     function updateCurrentMintId(uint256 id) external onlyOwner {
334         currentMintId = id;
335 
336         emit UpdatedCurrentMintId(id);
337     }
338 
339     function updateMintPrice(uint256 price) external onlyOwner {
340         mintPrice = price;
341 
342         emit UpdatedMintPrice(price);
343     }
344 
345     function updateMaxMintTx(uint256 max) external onlyOwner {
346         maxMintTx = max;
347 
348         emit UpdatedMaxMintTx(max);
349     } 
350 
351     function updateMintPaused(bool paused) external onlyOwner {
352         mintPaused = paused;
353 
354         emit UpdatedMintPaused(paused);
355     } 
356 
357     function withdrawNFT(uint256 id) external onlyOwner {
358         IERC721(mlz).transferFrom(address(this), mlz, id);
359     }
360 
361     function withdraw(uint256 _amount) external onlyOwner {
362         (bool success, ) = mlz.call{value: _amount}("");
363         require(success, "Transfer failed.");
364     }
365 
366     function mintBatches(uint256 batches) external onlyOwner {
367         uint256 batchValue = BATCH_SIZE * SALE_PRICE;
368         uint256 minBalance = batches * batchValue;
369 
370         if (address(this).balance < minBalance)
371             revert InsufficientBalance();
372 
373         IMoonLanderzNFT mintContract = IMoonLanderzNFT(mlz);
374 
375         for (uint256 i; i < batches;) {
376             mintContract.saleMint{value: batchValue}(BATCH_SIZE);
377 
378             unchecked {
379                 i++;
380             }
381         }
382     }
383 
384     function mint(uint256 amount) external payable {
385         IERC721 nftContract = IERC721(mlz);
386 
387         if (msg.value != amount * mintPrice)
388             revert InsufficientETHValue();
389 
390         if (amount > maxMintTx)
391             revert MaxMintTxReached();
392 
393         if (currentMintId + amount > lastMintId)
394             revert MintOut();
395 
396         if (mintPaused)
397             revert MintPaused();
398 
399         for (uint256 i; i < amount;) {
400             nftContract.transferFrom(address(this), msg.sender, currentMintId + i);
401 
402             unchecked {
403                 i++;
404             }
405         }
406 
407         unchecked {
408             currentMintId += amount;
409         }
410     }
411 
412     function canClaim(uint256 mlzId) external view returns (bool) {
413         return IERC721(mlz).ownerOf(mlzId) == msg.sender &&
414             (mlzId <= lastClaimId && !claims[mlzId]);
415     }
416 
417     function canMint(uint256 amount) external view returns (bool) {
418         return currentMintId + amount <= lastMintId;
419     }
420 
421     function claim(uint256[] calldata tokenIds) external {
422         uint256 tokensNb = tokenIds.length;
423         IERC721 nftContract = IERC721(mlz);
424 
425         for (uint256 i; i < tokensNb;) {
426             uint256 tokenId = tokenIds[i];
427 
428             if (tokenId > lastClaimId || claims[tokenId])
429                 revert CannotClaim();
430 
431             if (nftContract.ownerOf(tokenId) != msg.sender)
432                 revert NotTokenOwner();
433             
434             claims[tokenId] = true;
435 
436             nftContract.transferFrom(address(this), msg.sender, currentClaimId + i);
437             
438             unchecked {
439                 i++;
440             }
441         }
442 
443         unchecked {
444             currentClaimId += tokensNb;
445         }
446         
447         emit Claimed(tokensNb);
448     }
449 
450     receive() external payable {}
451 }