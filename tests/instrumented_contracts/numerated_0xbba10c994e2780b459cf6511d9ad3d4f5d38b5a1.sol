1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // Sources flattened with hardhat v2.9.3 https://hardhat.org
8 
9 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 
38 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 
183 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
184 
185 
186 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Enumerable is IERC721 {
195     /**
196      * @dev Returns the total amount of tokens stored by the contract.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
202      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
203      */
204     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
205 
206     /**
207      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
208      * Use along with {totalSupply} to enumerate all tokens.
209      */
210     function tokenByIndex(uint256 index) external view returns (uint256);
211 }
212 
213 
214 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
215 
216 
217 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  * from ERC721 asset contracts.
225  */
226 interface IERC721Receiver {
227     /**
228      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
229      * by `operator` from `from`, this function is called.
230      *
231      * It must return its Solidity selector to confirm the token transfer.
232      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
233      *
234      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
235      */
236     function onERC721Received(
237         address operator,
238         address from,
239         uint256 tokenId,
240         bytes calldata data
241     ) external returns (bytes4);
242 }
243 
244 
245 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Contract module that helps prevent reentrant calls to a function.
254  *
255  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
256  * available, which can be applied to functions to make sure there are no nested
257  * (reentrant) calls to them.
258  *
259  * Note that because there is a single `nonReentrant` guard, functions marked as
260  * `nonReentrant` may not call one another. This can be worked around by making
261  * those functions `private`, and then adding `external` `nonReentrant` entry
262  * points to them.
263  *
264  * TIP: If you would like to learn more about reentrancy and alternative ways
265  * to protect against it, check out our blog post
266  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
267  */
268 abstract contract ReentrancyGuard {
269     // Booleans are more expensive than uint256 or any type that takes up a full
270     // word because each write operation emits an extra SLOAD to first read the
271     // slot's contents, replace the bits taken up by the boolean, and then write
272     // back. This is the compiler's defense against contract upgrades and
273     // pointer aliasing, and it cannot be disabled.
274 
275     // The values being non-zero value makes deployment a bit more expensive,
276     // but in exchange the refund on every call to nonReentrant will be lower in
277     // amount. Since refunds are capped to a percentage of the total
278     // transaction's gas, it is best to keep them low in cases like this one, to
279     // increase the likelihood of the full refund coming into effect.
280     uint256 private constant _NOT_ENTERED = 1;
281     uint256 private constant _ENTERED = 2;
282 
283     uint256 private _status;
284 
285     constructor() {
286         _status = _NOT_ENTERED;
287     }
288 
289     /**
290      * @dev Prevents a contract from calling itself, directly or indirectly.
291      * Calling a `nonReentrant` function from another `nonReentrant`
292      * function is not supported. It is possible to prevent this from happening
293      * by making the `nonReentrant` function external, and making it call a
294      * `private` function that does the actual work.
295      */
296     modifier nonReentrant() {
297         // On the first call to nonReentrant, _notEntered will be true
298         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
299 
300         // Any calls to nonReentrant after this point will fail
301         _status = _ENTERED;
302 
303         _;
304 
305         // By storing the original value once again, a refund is triggered (see
306         // https://eips.ethereum.org/EIPS/eip-2200)
307         _status = _NOT_ENTERED;
308     }
309 }
310 
311 
312 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Provides information about the current execution context, including the
321  * sender of the transaction and its data. While these are generally available
322  * via msg.sender and msg.data, they should not be accessed in such a direct
323  * manner, since when dealing with meta-transactions the account sending and
324  * paying for execution may not be the actual sender (as far as an application
325  * is concerned).
326  *
327  * This contract is only required for intermediate, library-like contracts.
328  */
329 abstract contract Context {
330     function _msgSender() internal view virtual returns (address) {
331         return msg.sender;
332     }
333 
334     function _msgData() internal view virtual returns (bytes calldata) {
335         return msg.data;
336     }
337 }
338 
339 
340 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Contract module which provides a basic access control mechanism, where
349  * there is an account (an owner) that can be granted exclusive access to
350  * specific functions.
351  *
352  * By default, the owner account will be the one that deploys the contract. This
353  * can later be changed with {transferOwnership}.
354  *
355  * This module is used through inheritance. It will make available the modifier
356  * `onlyOwner`, which can be applied to your functions to restrict their use to
357  * the owner.
358  */
359 abstract contract Ownable is Context {
360     address private _owner;
361 
362     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
363 
364     /**
365      * @dev Initializes the contract setting the deployer as the initial owner.
366      */
367     constructor() {
368         _transferOwnership(_msgSender());
369     }
370 
371     /**
372      * @dev Returns the address of the current owner.
373      */
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     /**
379      * @dev Throws if called by any account other than the owner.
380      */
381     modifier onlyOwner() {
382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
383         _;
384     }
385 
386     /**
387      * @dev Leaves the contract without owner. It will not be possible to call
388      * `onlyOwner` functions anymore. Can only be called by the current owner.
389      *
390      * NOTE: Renouncing ownership will leave the contract without an owner,
391      * thereby removing any functionality that is only available to the owner.
392      */
393     function renounceOwnership() public virtual onlyOwner {
394         _transferOwnership(address(0));
395     }
396 
397     /**
398      * @dev Transfers ownership of the contract to a new account (`newOwner`).
399      * Can only be called by the current owner.
400      */
401     function transferOwnership(address newOwner) public virtual onlyOwner {
402         require(newOwner != address(0), "Ownable: new owner is the zero address");
403         _transferOwnership(newOwner);
404     }
405 
406     /**
407      * @dev Transfers ownership of the contract to a new account (`newOwner`).
408      * Internal function without access restriction.
409      */
410     function _transferOwnership(address newOwner) internal virtual {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 
417 
418 // File contracts/OxyaStaking.sol
419 
420 
421 pragma solidity ^0.8.12;
422 
423 
424 
425 
426 
427 contract OxyaStaking is Ownable, ReentrancyGuard {
428 
429     mapping(uint256 => address) public depositaries;
430     
431     address public OxyaAddress;
432     bool public isActive = false;
433 
434     event Staked(address owner, uint256 tokenId, uint256 timeframe);
435     event Unstaked(address owner, uint256 tokenId, uint256 timeframe);
436 
437     modifier shouldBeActive() {
438         require(isActive, "Contract is not active");
439         _;
440     }
441 
442     constructor(address oxyaAddress_) {
443         OxyaAddress = oxyaAddress_;
444     }
445 
446     /**
447      * @dev   activate/desactivate the smart contract
448      * staking methods will be blocked but this will not be the case of unstaking methods
449      */
450     function toggleActive() external onlyOwner {
451         isActive = !isActive;
452     }
453 
454     /**
455      * @dev stake tokens in the contract, if the token was already staked it replace prev timestamp by actual
456      * @param _tokenId ids of token
457      */
458     function stake(uint256 _tokenId) internal shouldBeActive {
459         require(
460             IERC721Enumerable(OxyaAddress).ownerOf(_tokenId) == msg.sender &&
461                 depositaries[_tokenId] == address(0),
462             "You must own the NFT."
463         );
464         IERC721Enumerable(OxyaAddress).transferFrom(
465             msg.sender,
466             address(this),
467             _tokenId
468         );
469         depositaries[_tokenId] = msg.sender;
470 
471         emit Staked(msg.sender, _tokenId, block.timestamp);
472     }
473 
474     /**
475      * @dev stake tokens in the contract, if the token was already staked it replace prev timestamp by actual
476      * @param _tokenIds ids of token
477      */
478     function batchStake(uint256[] memory _tokenIds) public shouldBeActive {
479         for (uint256 i = 0; i < _tokenIds.length; i++) {
480             stake(_tokenIds[i]);
481         }
482     }
483 
484     // UNSTAKE
485     /**
486      * @dev unstake token out of the contract
487      * @param _tokenId tokenId of token to unstake
488      */
489     function unstake(uint256 _tokenId) internal {
490         require(depositaries[_tokenId] == msg.sender, "Not original owner");
491 
492         IERC721Enumerable(OxyaAddress).transferFrom(
493             address(this),
494             msg.sender,
495             _tokenId
496         );
497         depositaries[_tokenId] = address(0);
498 
499         emit Unstaked(msg.sender, _tokenId, block.timestamp);
500     }
501 
502     /**
503      * @dev unstake tokens out of the contract
504      * @param _tokenIds tokenIds of token to unstake
505      */
506     function batchUnstake(uint256[] memory _tokenIds) public {
507         for (uint256 i = 0; i < _tokenIds.length; i++) {
508             unstake(_tokenIds[i]);
509         }
510     }
511 
512     /**
513      * @dev necessary to transfer tokens
514      */
515     function onERC721Received(
516         address,
517         address,
518         uint256,
519         bytes calldata
520     ) external pure returns (bytes4) {
521         return IERC721Receiver.onERC721Received.selector;
522     }
523 }