1 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/operator-filter-registry/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: @openzeppelin/contracts/utils/Address.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
37 
38 pragma solidity ^0.8.1;
39 
40 /**
41  * @dev Collection of functions related to the address type
42  */
43 library Address {
44     /**
45      * @dev Returns true if `account` is a contract.
46      *
47      * [IMPORTANT]
48      * ====
49      * It is unsafe to assume that an address for which this function returns
50      * false is an externally-owned account (EOA) and not a contract.
51      *
52      * Among others, `isContract` will return false for the following
53      * types of addresses:
54      *
55      *  - an externally-owned account
56      *  - a contract in construction
57      *  - an address where a contract will be created
58      *  - an address where a contract lived, but was destroyed
59      * ====
60      *
61      * [IMPORTANT]
62      * ====
63      * You shouldn't rely on `isContract` to protect against flash loan attacks!
64      *
65      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
66      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
67      * constructor.
68      * ====
69      */
70     function isContract(address account) internal view returns (bool) {
71         // This method relies on extcodesize/address.code.length, which returns 0
72         // for contracts in construction, since the code is only stored at the end
73         // of the constructor execution.
74 
75         return account.code.length > 0;
76     }
77 
78     /**
79      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
80      * `recipient`, forwarding all available gas and reverting on errors.
81      *
82      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
83      * of certain opcodes, possibly making contracts go over the 2300 gas limit
84      * imposed by `transfer`, making them unable to receive funds via
85      * `transfer`. {sendValue} removes this limitation.
86      *
87      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
88      *
89      * IMPORTANT: because control is transferred to `recipient`, care must be
90      * taken to not create reentrancy vulnerabilities. Consider using
91      * {ReentrancyGuard} or the
92      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
93      */
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         (bool success, ) = recipient.call{value: amount}("");
98         require(success, "Address: unable to send value, recipient may have reverted");
99     }
100 
101     /**
102      * @dev Performs a Solidity function call using a low level `call`. A
103      * plain `call` is an unsafe replacement for a function call: use this
104      * function instead.
105      *
106      * If `target` reverts with a revert reason, it is bubbled up by this
107      * function (like regular Solidity function calls).
108      *
109      * Returns the raw returned data. To convert to the expected return value,
110      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
111      *
112      * Requirements:
113      *
114      * - `target` must be a contract.
115      * - calling `target` with `data` must not revert.
116      *
117      * _Available since v3.1._
118      */
119     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
125      * `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but also transferring `value` wei to `target`.
140      *
141      * Requirements:
142      *
143      * - the calling contract must have an ETH balance of at least `value`.
144      * - the called Solidity function must be `payable`.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value
152     ) internal returns (bytes memory) {
153         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
158      * with `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         require(address(this).balance >= value, "Address: insufficient balance for call");
169         (bool success, bytes memory returndata) = target.call{value: value}(data);
170         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a static call.
176      *
177      * _Available since v3.3._
178      */
179     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
180         return functionStaticCall(target, data, "Address: low-level static call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a static call.
186      *
187      * _Available since v3.3._
188      */
189     function functionStaticCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal view returns (bytes memory) {
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a delegate call.
211      *
212      * _Available since v3.4._
213      */
214     function functionDelegateCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
225      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
226      *
227      * _Available since v4.8._
228      */
229     function verifyCallResultFromTarget(
230         address target,
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         if (success) {
236             if (returndata.length == 0) {
237                 // only check isContract if the call was successful and the return data is empty
238                 // otherwise we already know that it was a contract
239                 require(isContract(target), "Address: call to non-contract");
240             }
241             return returndata;
242         } else {
243             _revert(returndata, errorMessage);
244         }
245     }
246 
247     /**
248      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
249      * revert reason or using the provided one.
250      *
251      * _Available since v4.3._
252      */
253     function verifyCallResult(
254         bool success,
255         bytes memory returndata,
256         string memory errorMessage
257     ) internal pure returns (bytes memory) {
258         if (success) {
259             return returndata;
260         } else {
261             _revert(returndata, errorMessage);
262         }
263     }
264 
265     function _revert(bytes memory returndata, string memory errorMessage) private pure {
266         // Look for revert reason and bubble it up if present
267         if (returndata.length > 0) {
268             // The easiest way to bubble the revert reason is using memory via assembly
269             /// @solidity memory-safe-assembly
270             assembly {
271                 let returndata_size := mload(returndata)
272                 revert(add(32, returndata), returndata_size)
273             }
274         } else {
275             revert(errorMessage);
276         }
277     }
278 }
279 
280 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
281 
282 
283 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Interface of the ERC165 standard, as defined in the
319  * https://eips.ethereum.org/EIPS/eip-165[EIP].
320  *
321  * Implementers can declare support of contract interfaces, which can then be
322  * queried by others ({ERC165Checker}).
323  *
324  * For an implementation, see {ERC165}.
325  */
326 interface IERC165 {
327     /**
328      * @dev Returns true if this contract implements the interface defined by
329      * `interfaceId`. See the corresponding
330      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
331      * to learn more about how these ids are created.
332      *
333      * This function call must use less than 30 000 gas.
334      */
335     function supportsInterface(bytes4 interfaceId) external view returns (bool);
336 }
337 
338 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
339 
340 
341 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Interface for the NFT Royalty Standard.
348  *
349  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
350  * support for royalty payments across all NFT marketplaces and ecosystem participants.
351  *
352  * _Available since v4.5._
353  */
354 interface IERC2981 is IERC165 {
355     /**
356      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
357      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
358      */
359     function royaltyInfo(uint256 tokenId, uint256 salePrice)
360         external
361         view
362         returns (address receiver, uint256 royaltyAmount);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Implementation of the {IERC165} interface.
375  *
376  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
377  * for the additional interface id that will be supported. For example:
378  *
379  * ```solidity
380  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
382  * }
383  * ```
384  *
385  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
386  */
387 abstract contract ERC165 is IERC165 {
388     /**
389      * @dev See {IERC165-supportsInterface}.
390      */
391     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
397 
398 
399 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes calldata data
455     ) external;
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Transfers `tokenId` token from `from` to `to`.
479      *
480      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
481      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
482      * understand this adds an external call which potentially creates a reentrancy vulnerability.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
501      * The approval is cleared when the token is transferred.
502      *
503      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
504      *
505      * Requirements:
506      *
507      * - The caller must own the token or be an approved operator.
508      * - `tokenId` must exist.
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address to, uint256 tokenId) external;
513 
514     /**
515      * @dev Approve or remove `operator` as an operator for the caller.
516      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
517      *
518      * Requirements:
519      *
520      * - The `operator` cannot be the caller.
521      *
522      * Emits an {ApprovalForAll} event.
523      */
524     function setApprovalForAll(address operator, bool _approved) external;
525 
526     /**
527      * @dev Returns the account approved for `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function getApproved(uint256 tokenId) external view returns (address operator);
534 
535     /**
536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
537      *
538      * See {setApprovalForAll}
539      */
540     function isApprovedForAll(address owner, address operator) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
544 
545 
546 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 interface IERC721Enumerable is IERC721 {
556     /**
557      * @dev Returns the total amount of tokens stored by the contract.
558      */
559     function totalSupply() external view returns (uint256);
560 
561     /**
562      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
563      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
564      */
565     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
566 
567     /**
568      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
569      * Use along with {totalSupply} to enumerate all tokens.
570      */
571     function tokenByIndex(uint256 index) external view returns (uint256);
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
584  * @dev See https://eips.ethereum.org/EIPS/eip-721
585  */
586 interface IERC721Metadata is IERC721 {
587     /**
588      * @dev Returns the token collection name.
589      */
590     function name() external view returns (string memory);
591 
592     /**
593      * @dev Returns the token collection symbol.
594      */
595     function symbol() external view returns (string memory);
596 
597     /**
598      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
599      */
600     function tokenURI(uint256 tokenId) external view returns (string memory);
601 }
602 
603 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/Decentraland.sol
604 
605 
606 pragma solidity ^0.8.0;
607 
608 // Decentraland interface
609 contract Decentraland {
610     function ownerOf(uint256 tokenId) public view returns (address) {}
611 }
612 
613 // File: @openzeppelin/contracts/utils/Context.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Provides information about the current execution context, including the
622  * sender of the transaction and its data. While these are generally available
623  * via msg.sender and msg.data, they should not be accessed in such a direct
624  * manner, since when dealing with meta-transactions the account sending and
625  * paying for execution may not be the actual sender (as far as an application
626  * is concerned).
627  *
628  * This contract is only required for intermediate, library-like contracts.
629  */
630 abstract contract Context {
631     function _msgSender() internal view virtual returns (address) {
632         return msg.sender;
633     }
634 
635     function _msgData() internal view virtual returns (bytes calldata) {
636         return msg.data;
637     }
638 }
639 
640 // File: @openzeppelin/contracts/access/Ownable.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Contract module which provides a basic access control mechanism, where
650  * there is an account (an owner) that can be granted exclusive access to
651  * specific functions.
652  *
653  * By default, the owner account will be the one that deploys the contract. This
654  * can later be changed with {transferOwnership}.
655  *
656  * This module is used through inheritance. It will make available the modifier
657  * `onlyOwner`, which can be applied to your functions to restrict their use to
658  * the owner.
659  */
660 abstract contract Ownable is Context {
661     address private _owner;
662 
663     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
664 
665     /**
666      * @dev Initializes the contract setting the deployer as the initial owner.
667      */
668     constructor() {
669         _transferOwnership(_msgSender());
670     }
671 
672     /**
673      * @dev Throws if called by any account other than the owner.
674      */
675     modifier onlyOwner() {
676         _checkOwner();
677         _;
678     }
679 
680     /**
681      * @dev Returns the address of the current owner.
682      */
683     function owner() public view virtual returns (address) {
684         return _owner;
685     }
686 
687     /**
688      * @dev Throws if the sender is not the owner.
689      */
690     function _checkOwner() internal view virtual {
691         require(owner() == _msgSender(), "Ownable: caller is not the owner");
692     }
693 
694     /**
695      * @dev Leaves the contract without owner. It will not be possible to call
696      * `onlyOwner` functions anymore. Can only be called by the current owner.
697      *
698      * NOTE: Renouncing ownership will leave the contract without an owner,
699      * thereby removing any functionality that is only available to the owner.
700      */
701     function renounceOwnership() public virtual onlyOwner {
702         _transferOwnership(address(0));
703     }
704 
705     /**
706      * @dev Transfers ownership of the contract to a new account (`newOwner`).
707      * Can only be called by the current owner.
708      */
709     function transferOwnership(address newOwner) public virtual onlyOwner {
710         require(newOwner != address(0), "Ownable: new owner is the zero address");
711         _transferOwnership(newOwner);
712     }
713 
714     /**
715      * @dev Transfers ownership of the contract to a new account (`newOwner`).
716      * Internal function without access restriction.
717      */
718     function _transferOwnership(address newOwner) internal virtual {
719         address oldOwner = _owner;
720         _owner = newOwner;
721         emit OwnershipTransferred(oldOwner, newOwner);
722     }
723 }
724 
725 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/Authorizable.sol
726 
727 
728 pragma solidity >=0.4.22 <0.9.0;
729 
730 
731 contract Authorizable is Ownable {
732     mapping(address => bool) public trustees;
733 
734     constructor() {}
735 
736     modifier onlyAuthorized() {
737         require(trustees[msg.sender] || msg.sender == owner());
738         _;
739     }
740 
741     function addTrustee(address _trustee) public onlyOwner {
742         trustees[_trustee] = true;
743     }
744 
745     function removeTrustee(address _trustee) public onlyOwner {
746         delete trustees[_trustee];
747     }
748 }
749 
750 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/UpdateableOperatorFilterer.sol
751 
752 
753 pragma solidity ^0.8.13;
754 
755 
756 
757 /**
758  * @title  UpdateableOperatorFilterer
759  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
760  *         registrant's entries in the OperatorFilterRegistry.
761  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
762  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
763  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
764  */
765 abstract contract UpdateableOperatorFilterer is Authorizable {
766     error OperatorNotAllowed(address operator);
767 
768     address constant DEFAULT_OPERATOR_FILTER_REGISTRY_ADDRESS =
769         address(0x000000000000AAeB6D7670E522A718067333cd4E);
770 
771     address constant DEFAULT_SUBSCRIPTION =
772         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
773 
774     IOperatorFilterRegistry public OperatorFilterRegistry =
775         IOperatorFilterRegistry(DEFAULT_OPERATOR_FILTER_REGISTRY_ADDRESS);
776 
777     constructor() {
778         if (address(OperatorFilterRegistry).code.length > 0) {
779             OperatorFilterRegistry.registerAndSubscribe(
780                 address(this),
781                 DEFAULT_SUBSCRIPTION
782             );
783         }
784     }
785 
786     modifier onlyAllowedOperator(address from) virtual {
787         // Allow spending tokens from addresses with balance
788         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
789         // from an EOA.
790         if (from != msg.sender) {
791             _checkFilterOperator(msg.sender);
792         }
793         _;
794     }
795 
796     modifier onlyAllowedOperatorApproval(address operator) virtual {
797         _checkFilterOperator(operator);
798         _;
799     }
800 
801     function _checkFilterOperator(address operator) internal view virtual {
802         // Check registry code length to facilitate testing in environments without a deployed registry.
803         if (address(OperatorFilterRegistry).code.length > 0) {
804             require(
805                 OperatorFilterRegistry.isOperatorAllowed(
806                     address(this),
807                     operator
808                 ),
809                 "operator is not allowed"
810             );
811         }
812     }
813 
814     /**
815      * @notice update the operator filter registry
816      */
817     function updateOperatorFilterRegistry(address operatorFilterRegisterAddress)
818         external
819         onlyOwner
820     {
821         OperatorFilterRegistry = IOperatorFilterRegistry(
822             operatorFilterRegisterAddress
823         );
824     }
825 }
826 
827 // File: @openzeppelin/contracts/utils/Base64.sol
828 
829 
830 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 /**
835  * @dev Provides a set of functions to operate with Base64 strings.
836  *
837  * _Available since v4.5._
838  */
839 library Base64 {
840     /**
841      * @dev Base64 Encoding/Decoding Table
842      */
843     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
844 
845     /**
846      * @dev Converts a `bytes` to its Bytes64 `string` representation.
847      */
848     function encode(bytes memory data) internal pure returns (string memory) {
849         /**
850          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
851          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
852          */
853         if (data.length == 0) return "";
854 
855         // Loads the table into memory
856         string memory table = _TABLE;
857 
858         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
859         // and split into 4 numbers of 6 bits.
860         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
861         // - `data.length + 2`  -> Round up
862         // - `/ 3`              -> Number of 3-bytes chunks
863         // - `4 *`              -> 4 characters for each chunk
864         string memory result = new string(4 * ((data.length + 2) / 3));
865 
866         /// @solidity memory-safe-assembly
867         assembly {
868             // Prepare the lookup table (skip the first "length" byte)
869             let tablePtr := add(table, 1)
870 
871             // Prepare result pointer, jump over length
872             let resultPtr := add(result, 32)
873 
874             // Run over the input, 3 bytes at a time
875             for {
876                 let dataPtr := data
877                 let endPtr := add(data, mload(data))
878             } lt(dataPtr, endPtr) {
879 
880             } {
881                 // Advance 3 bytes
882                 dataPtr := add(dataPtr, 3)
883                 let input := mload(dataPtr)
884 
885                 // To write each character, shift the 3 bytes (18 bits) chunk
886                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
887                 // and apply logical AND with 0x3F which is the number of
888                 // the previous character in the ASCII table prior to the Base64 Table
889                 // The result is then added to the table to get the character to write,
890                 // and finally write it in the result pointer but with a left shift
891                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
892 
893                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
894                 resultPtr := add(resultPtr, 1) // Advance
895 
896                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
897                 resultPtr := add(resultPtr, 1) // Advance
898 
899                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
900                 resultPtr := add(resultPtr, 1) // Advance
901 
902                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
903                 resultPtr := add(resultPtr, 1) // Advance
904             }
905 
906             // When data `bytes` is not exactly 3 bytes long
907             // it is padded with `=` characters at the end
908             switch mod(mload(data), 3)
909             case 1 {
910                 mstore8(sub(resultPtr, 1), 0x3d)
911                 mstore8(sub(resultPtr, 2), 0x3d)
912             }
913             case 2 {
914                 mstore8(sub(resultPtr, 1), 0x3d)
915             }
916         }
917 
918         return result;
919     }
920 }
921 
922 // File: @openzeppelin/contracts/utils/math/Math.sol
923 
924 
925 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 /**
930  * @dev Standard math utilities missing in the Solidity language.
931  */
932 library Math {
933     enum Rounding {
934         Down, // Toward negative infinity
935         Up, // Toward infinity
936         Zero // Toward zero
937     }
938 
939     /**
940      * @dev Returns the largest of two numbers.
941      */
942     function max(uint256 a, uint256 b) internal pure returns (uint256) {
943         return a > b ? a : b;
944     }
945 
946     /**
947      * @dev Returns the smallest of two numbers.
948      */
949     function min(uint256 a, uint256 b) internal pure returns (uint256) {
950         return a < b ? a : b;
951     }
952 
953     /**
954      * @dev Returns the average of two numbers. The result is rounded towards
955      * zero.
956      */
957     function average(uint256 a, uint256 b) internal pure returns (uint256) {
958         // (a + b) / 2 can overflow.
959         return (a & b) + (a ^ b) / 2;
960     }
961 
962     /**
963      * @dev Returns the ceiling of the division of two numbers.
964      *
965      * This differs from standard division with `/` in that it rounds up instead
966      * of rounding down.
967      */
968     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
969         // (a + b - 1) / b can overflow on addition, so we distribute.
970         return a == 0 ? 0 : (a - 1) / b + 1;
971     }
972 
973     /**
974      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
975      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
976      * with further edits by Uniswap Labs also under MIT license.
977      */
978     function mulDiv(
979         uint256 x,
980         uint256 y,
981         uint256 denominator
982     ) internal pure returns (uint256 result) {
983         unchecked {
984             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
985             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
986             // variables such that product = prod1 * 2^256 + prod0.
987             uint256 prod0; // Least significant 256 bits of the product
988             uint256 prod1; // Most significant 256 bits of the product
989             assembly {
990                 let mm := mulmod(x, y, not(0))
991                 prod0 := mul(x, y)
992                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
993             }
994 
995             // Handle non-overflow cases, 256 by 256 division.
996             if (prod1 == 0) {
997                 return prod0 / denominator;
998             }
999 
1000             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1001             require(denominator > prod1);
1002 
1003             ///////////////////////////////////////////////
1004             // 512 by 256 division.
1005             ///////////////////////////////////////////////
1006 
1007             // Make division exact by subtracting the remainder from [prod1 prod0].
1008             uint256 remainder;
1009             assembly {
1010                 // Compute remainder using mulmod.
1011                 remainder := mulmod(x, y, denominator)
1012 
1013                 // Subtract 256 bit number from 512 bit number.
1014                 prod1 := sub(prod1, gt(remainder, prod0))
1015                 prod0 := sub(prod0, remainder)
1016             }
1017 
1018             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1019             // See https://cs.stackexchange.com/q/138556/92363.
1020 
1021             // Does not overflow because the denominator cannot be zero at this stage in the function.
1022             uint256 twos = denominator & (~denominator + 1);
1023             assembly {
1024                 // Divide denominator by twos.
1025                 denominator := div(denominator, twos)
1026 
1027                 // Divide [prod1 prod0] by twos.
1028                 prod0 := div(prod0, twos)
1029 
1030                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1031                 twos := add(div(sub(0, twos), twos), 1)
1032             }
1033 
1034             // Shift in bits from prod1 into prod0.
1035             prod0 |= prod1 * twos;
1036 
1037             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1038             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1039             // four bits. That is, denominator * inv = 1 mod 2^4.
1040             uint256 inverse = (3 * denominator) ^ 2;
1041 
1042             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1043             // in modular arithmetic, doubling the correct bits in each step.
1044             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1045             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1046             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1047             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1048             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1049             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1050 
1051             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1052             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1053             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1054             // is no longer required.
1055             result = prod0 * inverse;
1056             return result;
1057         }
1058     }
1059 
1060     /**
1061      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1062      */
1063     function mulDiv(
1064         uint256 x,
1065         uint256 y,
1066         uint256 denominator,
1067         Rounding rounding
1068     ) internal pure returns (uint256) {
1069         uint256 result = mulDiv(x, y, denominator);
1070         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1071             result += 1;
1072         }
1073         return result;
1074     }
1075 
1076     /**
1077      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1078      *
1079      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1080      */
1081     function sqrt(uint256 a) internal pure returns (uint256) {
1082         if (a == 0) {
1083             return 0;
1084         }
1085 
1086         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1087         //
1088         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1089         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1090         //
1091         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1092         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1093         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1094         //
1095         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1096         uint256 result = 1 << (log2(a) >> 1);
1097 
1098         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1099         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1100         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1101         // into the expected uint128 result.
1102         unchecked {
1103             result = (result + a / result) >> 1;
1104             result = (result + a / result) >> 1;
1105             result = (result + a / result) >> 1;
1106             result = (result + a / result) >> 1;
1107             result = (result + a / result) >> 1;
1108             result = (result + a / result) >> 1;
1109             result = (result + a / result) >> 1;
1110             return min(result, a / result);
1111         }
1112     }
1113 
1114     /**
1115      * @notice Calculates sqrt(a), following the selected rounding direction.
1116      */
1117     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1118         unchecked {
1119             uint256 result = sqrt(a);
1120             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1121         }
1122     }
1123 
1124     /**
1125      * @dev Return the log in base 2, rounded down, of a positive value.
1126      * Returns 0 if given 0.
1127      */
1128     function log2(uint256 value) internal pure returns (uint256) {
1129         uint256 result = 0;
1130         unchecked {
1131             if (value >> 128 > 0) {
1132                 value >>= 128;
1133                 result += 128;
1134             }
1135             if (value >> 64 > 0) {
1136                 value >>= 64;
1137                 result += 64;
1138             }
1139             if (value >> 32 > 0) {
1140                 value >>= 32;
1141                 result += 32;
1142             }
1143             if (value >> 16 > 0) {
1144                 value >>= 16;
1145                 result += 16;
1146             }
1147             if (value >> 8 > 0) {
1148                 value >>= 8;
1149                 result += 8;
1150             }
1151             if (value >> 4 > 0) {
1152                 value >>= 4;
1153                 result += 4;
1154             }
1155             if (value >> 2 > 0) {
1156                 value >>= 2;
1157                 result += 2;
1158             }
1159             if (value >> 1 > 0) {
1160                 result += 1;
1161             }
1162         }
1163         return result;
1164     }
1165 
1166     /**
1167      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1168      * Returns 0 if given 0.
1169      */
1170     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1171         unchecked {
1172             uint256 result = log2(value);
1173             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1174         }
1175     }
1176 
1177     /**
1178      * @dev Return the log in base 10, rounded down, of a positive value.
1179      * Returns 0 if given 0.
1180      */
1181     function log10(uint256 value) internal pure returns (uint256) {
1182         uint256 result = 0;
1183         unchecked {
1184             if (value >= 10**64) {
1185                 value /= 10**64;
1186                 result += 64;
1187             }
1188             if (value >= 10**32) {
1189                 value /= 10**32;
1190                 result += 32;
1191             }
1192             if (value >= 10**16) {
1193                 value /= 10**16;
1194                 result += 16;
1195             }
1196             if (value >= 10**8) {
1197                 value /= 10**8;
1198                 result += 8;
1199             }
1200             if (value >= 10**4) {
1201                 value /= 10**4;
1202                 result += 4;
1203             }
1204             if (value >= 10**2) {
1205                 value /= 10**2;
1206                 result += 2;
1207             }
1208             if (value >= 10**1) {
1209                 result += 1;
1210             }
1211         }
1212         return result;
1213     }
1214 
1215     /**
1216      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1217      * Returns 0 if given 0.
1218      */
1219     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1220         unchecked {
1221             uint256 result = log10(value);
1222             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1223         }
1224     }
1225 
1226     /**
1227      * @dev Return the log in base 256, rounded down, of a positive value.
1228      * Returns 0 if given 0.
1229      *
1230      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1231      */
1232     function log256(uint256 value) internal pure returns (uint256) {
1233         uint256 result = 0;
1234         unchecked {
1235             if (value >> 128 > 0) {
1236                 value >>= 128;
1237                 result += 16;
1238             }
1239             if (value >> 64 > 0) {
1240                 value >>= 64;
1241                 result += 8;
1242             }
1243             if (value >> 32 > 0) {
1244                 value >>= 32;
1245                 result += 4;
1246             }
1247             if (value >> 16 > 0) {
1248                 value >>= 16;
1249                 result += 2;
1250             }
1251             if (value >> 8 > 0) {
1252                 result += 1;
1253             }
1254         }
1255         return result;
1256     }
1257 
1258     /**
1259      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1260      * Returns 0 if given 0.
1261      */
1262     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1263         unchecked {
1264             uint256 result = log256(value);
1265             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1266         }
1267     }
1268 }
1269 
1270 // File: @openzeppelin/contracts/utils/Strings.sol
1271 
1272 
1273 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 
1278 /**
1279  * @dev String operations.
1280  */
1281 library Strings {
1282     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1283     uint8 private constant _ADDRESS_LENGTH = 20;
1284 
1285     /**
1286      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1287      */
1288     function toString(uint256 value) internal pure returns (string memory) {
1289         unchecked {
1290             uint256 length = Math.log10(value) + 1;
1291             string memory buffer = new string(length);
1292             uint256 ptr;
1293             /// @solidity memory-safe-assembly
1294             assembly {
1295                 ptr := add(buffer, add(32, length))
1296             }
1297             while (true) {
1298                 ptr--;
1299                 /// @solidity memory-safe-assembly
1300                 assembly {
1301                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1302                 }
1303                 value /= 10;
1304                 if (value == 0) break;
1305             }
1306             return buffer;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1312      */
1313     function toHexString(uint256 value) internal pure returns (string memory) {
1314         unchecked {
1315             return toHexString(value, Math.log256(value) + 1);
1316         }
1317     }
1318 
1319     /**
1320      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1321      */
1322     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1323         bytes memory buffer = new bytes(2 * length + 2);
1324         buffer[0] = "0";
1325         buffer[1] = "x";
1326         for (uint256 i = 2 * length + 1; i > 1; --i) {
1327             buffer[i] = _SYMBOLS[value & 0xf];
1328             value >>= 4;
1329         }
1330         require(value == 0, "Strings: hex length insufficient");
1331         return string(buffer);
1332     }
1333 
1334     /**
1335      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1336      */
1337     function toHexString(address addr) internal pure returns (string memory) {
1338         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1339     }
1340 }
1341 
1342 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1343 
1344 
1345 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 /**
1357  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1358  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1359  * {ERC721Enumerable}.
1360  */
1361 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1362     using Address for address;
1363     using Strings for uint256;
1364 
1365     // Token name
1366     string private _name;
1367 
1368     // Token symbol
1369     string private _symbol;
1370 
1371     // Mapping from token ID to owner address
1372     mapping(uint256 => address) private _owners;
1373 
1374     // Mapping owner address to token count
1375     mapping(address => uint256) private _balances;
1376 
1377     // Mapping from token ID to approved address
1378     mapping(uint256 => address) private _tokenApprovals;
1379 
1380     // Mapping from owner to operator approvals
1381     mapping(address => mapping(address => bool)) private _operatorApprovals;
1382 
1383     /**
1384      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1385      */
1386     constructor(string memory name_, string memory symbol_) {
1387         _name = name_;
1388         _symbol = symbol_;
1389     }
1390 
1391     /**
1392      * @dev See {IERC165-supportsInterface}.
1393      */
1394     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1395         return
1396             interfaceId == type(IERC721).interfaceId ||
1397             interfaceId == type(IERC721Metadata).interfaceId ||
1398             super.supportsInterface(interfaceId);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-balanceOf}.
1403      */
1404     function balanceOf(address owner) public view virtual override returns (uint256) {
1405         require(owner != address(0), "ERC721: address zero is not a valid owner");
1406         return _balances[owner];
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-ownerOf}.
1411      */
1412     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1413         address owner = _ownerOf(tokenId);
1414         require(owner != address(0), "ERC721: invalid token ID");
1415         return owner;
1416     }
1417 
1418     /**
1419      * @dev See {IERC721Metadata-name}.
1420      */
1421     function name() public view virtual override returns (string memory) {
1422         return _name;
1423     }
1424 
1425     /**
1426      * @dev See {IERC721Metadata-symbol}.
1427      */
1428     function symbol() public view virtual override returns (string memory) {
1429         return _symbol;
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Metadata-tokenURI}.
1434      */
1435     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1436         _requireMinted(tokenId);
1437 
1438         string memory baseURI = _baseURI();
1439         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1440     }
1441 
1442     /**
1443      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1444      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1445      * by default, can be overridden in child contracts.
1446      */
1447     function _baseURI() internal view virtual returns (string memory) {
1448         return "";
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-approve}.
1453      */
1454     function approve(address to, uint256 tokenId) public virtual override {
1455         address owner = ERC721.ownerOf(tokenId);
1456         require(to != owner, "ERC721: approval to current owner");
1457 
1458         require(
1459             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1460             "ERC721: approve caller is not token owner or approved for all"
1461         );
1462 
1463         _approve(to, tokenId);
1464     }
1465 
1466     /**
1467      * @dev See {IERC721-getApproved}.
1468      */
1469     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1470         _requireMinted(tokenId);
1471 
1472         return _tokenApprovals[tokenId];
1473     }
1474 
1475     /**
1476      * @dev See {IERC721-setApprovalForAll}.
1477      */
1478     function setApprovalForAll(address operator, bool approved) public virtual override {
1479         _setApprovalForAll(_msgSender(), operator, approved);
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-isApprovedForAll}.
1484      */
1485     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1486         return _operatorApprovals[owner][operator];
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-transferFrom}.
1491      */
1492     function transferFrom(
1493         address from,
1494         address to,
1495         uint256 tokenId
1496     ) public virtual override {
1497         //solhint-disable-next-line max-line-length
1498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1499 
1500         _transfer(from, to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-safeTransferFrom}.
1505      */
1506     function safeTransferFrom(
1507         address from,
1508         address to,
1509         uint256 tokenId
1510     ) public virtual override {
1511         safeTransferFrom(from, to, tokenId, "");
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-safeTransferFrom}.
1516      */
1517     function safeTransferFrom(
1518         address from,
1519         address to,
1520         uint256 tokenId,
1521         bytes memory data
1522     ) public virtual override {
1523         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1524         _safeTransfer(from, to, tokenId, data);
1525     }
1526 
1527     /**
1528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1530      *
1531      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1532      *
1533      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1534      * implement alternative mechanisms to perform token transfer, such as signature-based.
1535      *
1536      * Requirements:
1537      *
1538      * - `from` cannot be the zero address.
1539      * - `to` cannot be the zero address.
1540      * - `tokenId` token must exist and be owned by `from`.
1541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1542      *
1543      * Emits a {Transfer} event.
1544      */
1545     function _safeTransfer(
1546         address from,
1547         address to,
1548         uint256 tokenId,
1549         bytes memory data
1550     ) internal virtual {
1551         _transfer(from, to, tokenId);
1552         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1553     }
1554 
1555     /**
1556      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1557      */
1558     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1559         return _owners[tokenId];
1560     }
1561 
1562     /**
1563      * @dev Returns whether `tokenId` exists.
1564      *
1565      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1566      *
1567      * Tokens start existing when they are minted (`_mint`),
1568      * and stop existing when they are burned (`_burn`).
1569      */
1570     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1571         return _ownerOf(tokenId) != address(0);
1572     }
1573 
1574     /**
1575      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1576      *
1577      * Requirements:
1578      *
1579      * - `tokenId` must exist.
1580      */
1581     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1582         address owner = ERC721.ownerOf(tokenId);
1583         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1584     }
1585 
1586     /**
1587      * @dev Safely mints `tokenId` and transfers it to `to`.
1588      *
1589      * Requirements:
1590      *
1591      * - `tokenId` must not exist.
1592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _safeMint(address to, uint256 tokenId) internal virtual {
1597         _safeMint(to, tokenId, "");
1598     }
1599 
1600     /**
1601      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1602      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1603      */
1604     function _safeMint(
1605         address to,
1606         uint256 tokenId,
1607         bytes memory data
1608     ) internal virtual {
1609         _mint(to, tokenId);
1610         require(
1611             _checkOnERC721Received(address(0), to, tokenId, data),
1612             "ERC721: transfer to non ERC721Receiver implementer"
1613         );
1614     }
1615 
1616     /**
1617      * @dev Mints `tokenId` and transfers it to `to`.
1618      *
1619      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must not exist.
1624      * - `to` cannot be the zero address.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _mint(address to, uint256 tokenId) internal virtual {
1629         require(to != address(0), "ERC721: mint to the zero address");
1630         require(!_exists(tokenId), "ERC721: token already minted");
1631 
1632         _beforeTokenTransfer(address(0), to, tokenId, 1);
1633 
1634         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1635         require(!_exists(tokenId), "ERC721: token already minted");
1636 
1637         unchecked {
1638             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1639             // Given that tokens are minted one by one, it is impossible in practice that
1640             // this ever happens. Might change if we allow batch minting.
1641             // The ERC fails to describe this case.
1642             _balances[to] += 1;
1643         }
1644 
1645         _owners[tokenId] = to;
1646 
1647         emit Transfer(address(0), to, tokenId);
1648 
1649         _afterTokenTransfer(address(0), to, tokenId, 1);
1650     }
1651 
1652     /**
1653      * @dev Destroys `tokenId`.
1654      * The approval is cleared when the token is burned.
1655      * This is an internal function that does not check if the sender is authorized to operate on the token.
1656      *
1657      * Requirements:
1658      *
1659      * - `tokenId` must exist.
1660      *
1661      * Emits a {Transfer} event.
1662      */
1663     function _burn(uint256 tokenId) internal virtual {
1664         address owner = ERC721.ownerOf(tokenId);
1665 
1666         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1667 
1668         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1669         owner = ERC721.ownerOf(tokenId);
1670 
1671         // Clear approvals
1672         delete _tokenApprovals[tokenId];
1673 
1674         unchecked {
1675             // Cannot overflow, as that would require more tokens to be burned/transferred
1676             // out than the owner initially received through minting and transferring in.
1677             _balances[owner] -= 1;
1678         }
1679         delete _owners[tokenId];
1680 
1681         emit Transfer(owner, address(0), tokenId);
1682 
1683         _afterTokenTransfer(owner, address(0), tokenId, 1);
1684     }
1685 
1686     /**
1687      * @dev Transfers `tokenId` from `from` to `to`.
1688      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1689      *
1690      * Requirements:
1691      *
1692      * - `to` cannot be the zero address.
1693      * - `tokenId` token must be owned by `from`.
1694      *
1695      * Emits a {Transfer} event.
1696      */
1697     function _transfer(
1698         address from,
1699         address to,
1700         uint256 tokenId
1701     ) internal virtual {
1702         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1703         require(to != address(0), "ERC721: transfer to the zero address");
1704 
1705         _beforeTokenTransfer(from, to, tokenId, 1);
1706 
1707         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1708         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1709 
1710         // Clear approvals from the previous owner
1711         delete _tokenApprovals[tokenId];
1712 
1713         unchecked {
1714             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1715             // `from`'s balance is the number of token held, which is at least one before the current
1716             // transfer.
1717             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1718             // all 2**256 token ids to be minted, which in practice is impossible.
1719             _balances[from] -= 1;
1720             _balances[to] += 1;
1721         }
1722         _owners[tokenId] = to;
1723 
1724         emit Transfer(from, to, tokenId);
1725 
1726         _afterTokenTransfer(from, to, tokenId, 1);
1727     }
1728 
1729     /**
1730      * @dev Approve `to` to operate on `tokenId`
1731      *
1732      * Emits an {Approval} event.
1733      */
1734     function _approve(address to, uint256 tokenId) internal virtual {
1735         _tokenApprovals[tokenId] = to;
1736         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1737     }
1738 
1739     /**
1740      * @dev Approve `operator` to operate on all of `owner` tokens
1741      *
1742      * Emits an {ApprovalForAll} event.
1743      */
1744     function _setApprovalForAll(
1745         address owner,
1746         address operator,
1747         bool approved
1748     ) internal virtual {
1749         require(owner != operator, "ERC721: approve to caller");
1750         _operatorApprovals[owner][operator] = approved;
1751         emit ApprovalForAll(owner, operator, approved);
1752     }
1753 
1754     /**
1755      * @dev Reverts if the `tokenId` has not been minted yet.
1756      */
1757     function _requireMinted(uint256 tokenId) internal view virtual {
1758         require(_exists(tokenId), "ERC721: invalid token ID");
1759     }
1760 
1761     /**
1762      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1763      * The call is not executed if the target address is not a contract.
1764      *
1765      * @param from address representing the previous owner of the given token ID
1766      * @param to target address that will receive the tokens
1767      * @param tokenId uint256 ID of the token to be transferred
1768      * @param data bytes optional data to send along with the call
1769      * @return bool whether the call correctly returned the expected magic value
1770      */
1771     function _checkOnERC721Received(
1772         address from,
1773         address to,
1774         uint256 tokenId,
1775         bytes memory data
1776     ) private returns (bool) {
1777         if (to.isContract()) {
1778             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1779                 return retval == IERC721Receiver.onERC721Received.selector;
1780             } catch (bytes memory reason) {
1781                 if (reason.length == 0) {
1782                     revert("ERC721: transfer to non ERC721Receiver implementer");
1783                 } else {
1784                     /// @solidity memory-safe-assembly
1785                     assembly {
1786                         revert(add(32, reason), mload(reason))
1787                     }
1788                 }
1789             }
1790         } else {
1791             return true;
1792         }
1793     }
1794 
1795     /**
1796      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1797      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1798      *
1799      * Calling conditions:
1800      *
1801      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1802      * - When `from` is zero, the tokens will be minted for `to`.
1803      * - When `to` is zero, ``from``'s tokens will be burned.
1804      * - `from` and `to` are never both zero.
1805      * - `batchSize` is non-zero.
1806      *
1807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1808      */
1809     function _beforeTokenTransfer(
1810         address from,
1811         address to,
1812         uint256, /* firstTokenId */
1813         uint256 batchSize
1814     ) internal virtual {
1815         if (batchSize > 1) {
1816             if (from != address(0)) {
1817                 _balances[from] -= batchSize;
1818             }
1819             if (to != address(0)) {
1820                 _balances[to] += batchSize;
1821             }
1822         }
1823     }
1824 
1825     /**
1826      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1827      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1828      *
1829      * Calling conditions:
1830      *
1831      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1832      * - When `from` is zero, the tokens were minted for `to`.
1833      * - When `to` is zero, ``from``'s tokens were burned.
1834      * - `from` and `to` are never both zero.
1835      * - `batchSize` is non-zero.
1836      *
1837      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1838      */
1839     function _afterTokenTransfer(
1840         address from,
1841         address to,
1842         uint256 firstTokenId,
1843         uint256 batchSize
1844     ) internal virtual {}
1845 }
1846 
1847 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1848 
1849 
1850 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1851 
1852 pragma solidity ^0.8.0;
1853 
1854 
1855 
1856 /**
1857  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1858  * enumerability of all the token ids in the contract as well as all token ids owned by each
1859  * account.
1860  */
1861 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1862     // Mapping from owner to list of owned token IDs
1863     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1864 
1865     // Mapping from token ID to index of the owner tokens list
1866     mapping(uint256 => uint256) private _ownedTokensIndex;
1867 
1868     // Array with all token ids, used for enumeration
1869     uint256[] private _allTokens;
1870 
1871     // Mapping from token id to position in the allTokens array
1872     mapping(uint256 => uint256) private _allTokensIndex;
1873 
1874     /**
1875      * @dev See {IERC165-supportsInterface}.
1876      */
1877     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1878         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1879     }
1880 
1881     /**
1882      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1883      */
1884     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1885         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1886         return _ownedTokens[owner][index];
1887     }
1888 
1889     /**
1890      * @dev See {IERC721Enumerable-totalSupply}.
1891      */
1892     function totalSupply() public view virtual override returns (uint256) {
1893         return _allTokens.length;
1894     }
1895 
1896     /**
1897      * @dev See {IERC721Enumerable-tokenByIndex}.
1898      */
1899     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1900         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1901         return _allTokens[index];
1902     }
1903 
1904     /**
1905      * @dev See {ERC721-_beforeTokenTransfer}.
1906      */
1907     function _beforeTokenTransfer(
1908         address from,
1909         address to,
1910         uint256 firstTokenId,
1911         uint256 batchSize
1912     ) internal virtual override {
1913         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1914 
1915         if (batchSize > 1) {
1916             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1917             revert("ERC721Enumerable: consecutive transfers not supported");
1918         }
1919 
1920         uint256 tokenId = firstTokenId;
1921 
1922         if (from == address(0)) {
1923             _addTokenToAllTokensEnumeration(tokenId);
1924         } else if (from != to) {
1925             _removeTokenFromOwnerEnumeration(from, tokenId);
1926         }
1927         if (to == address(0)) {
1928             _removeTokenFromAllTokensEnumeration(tokenId);
1929         } else if (to != from) {
1930             _addTokenToOwnerEnumeration(to, tokenId);
1931         }
1932     }
1933 
1934     /**
1935      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1936      * @param to address representing the new owner of the given token ID
1937      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1938      */
1939     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1940         uint256 length = ERC721.balanceOf(to);
1941         _ownedTokens[to][length] = tokenId;
1942         _ownedTokensIndex[tokenId] = length;
1943     }
1944 
1945     /**
1946      * @dev Private function to add a token to this extension's token tracking data structures.
1947      * @param tokenId uint256 ID of the token to be added to the tokens list
1948      */
1949     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1950         _allTokensIndex[tokenId] = _allTokens.length;
1951         _allTokens.push(tokenId);
1952     }
1953 
1954     /**
1955      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1956      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1957      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1958      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1959      * @param from address representing the previous owner of the given token ID
1960      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1961      */
1962     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1963         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1964         // then delete the last slot (swap and pop).
1965 
1966         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1967         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1968 
1969         // When the token to delete is the last token, the swap operation is unnecessary
1970         if (tokenIndex != lastTokenIndex) {
1971             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1972 
1973             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1974             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1975         }
1976 
1977         // This also deletes the contents at the last position of the array
1978         delete _ownedTokensIndex[tokenId];
1979         delete _ownedTokens[from][lastTokenIndex];
1980     }
1981 
1982     /**
1983      * @dev Private function to remove a token from this extension's token tracking data structures.
1984      * This has O(1) time complexity, but alters the order of the _allTokens array.
1985      * @param tokenId uint256 ID of the token to be removed from the tokens list
1986      */
1987     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1988         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1989         // then delete the last slot (swap and pop).
1990 
1991         uint256 lastTokenIndex = _allTokens.length - 1;
1992         uint256 tokenIndex = _allTokensIndex[tokenId];
1993 
1994         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1995         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1996         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1997         uint256 lastTokenId = _allTokens[lastTokenIndex];
1998 
1999         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2000         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2001 
2002         // This also deletes the contents at the last position of the array
2003         delete _allTokensIndex[tokenId];
2004         _allTokens.pop();
2005     }
2006 }
2007 
2008 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2009 
2010 
2011 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
2012 
2013 pragma solidity ^0.8.0;
2014 
2015 
2016 /**
2017  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2018  *
2019  * These functions can be used to verify that a message was signed by the holder
2020  * of the private keys of a given address.
2021  */
2022 library ECDSA {
2023     enum RecoverError {
2024         NoError,
2025         InvalidSignature,
2026         InvalidSignatureLength,
2027         InvalidSignatureS,
2028         InvalidSignatureV // Deprecated in v4.8
2029     }
2030 
2031     function _throwError(RecoverError error) private pure {
2032         if (error == RecoverError.NoError) {
2033             return; // no error: do nothing
2034         } else if (error == RecoverError.InvalidSignature) {
2035             revert("ECDSA: invalid signature");
2036         } else if (error == RecoverError.InvalidSignatureLength) {
2037             revert("ECDSA: invalid signature length");
2038         } else if (error == RecoverError.InvalidSignatureS) {
2039             revert("ECDSA: invalid signature 's' value");
2040         }
2041     }
2042 
2043     /**
2044      * @dev Returns the address that signed a hashed message (`hash`) with
2045      * `signature` or error string. This address can then be used for verification purposes.
2046      *
2047      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2048      * this function rejects them by requiring the `s` value to be in the lower
2049      * half order, and the `v` value to be either 27 or 28.
2050      *
2051      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2052      * verification to be secure: it is possible to craft signatures that
2053      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2054      * this is by receiving a hash of the original message (which may otherwise
2055      * be too long), and then calling {toEthSignedMessageHash} on it.
2056      *
2057      * Documentation for signature generation:
2058      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2059      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2060      *
2061      * _Available since v4.3._
2062      */
2063     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2064         if (signature.length == 65) {
2065             bytes32 r;
2066             bytes32 s;
2067             uint8 v;
2068             // ecrecover takes the signature parameters, and the only way to get them
2069             // currently is to use assembly.
2070             /// @solidity memory-safe-assembly
2071             assembly {
2072                 r := mload(add(signature, 0x20))
2073                 s := mload(add(signature, 0x40))
2074                 v := byte(0, mload(add(signature, 0x60)))
2075             }
2076             return tryRecover(hash, v, r, s);
2077         } else {
2078             return (address(0), RecoverError.InvalidSignatureLength);
2079         }
2080     }
2081 
2082     /**
2083      * @dev Returns the address that signed a hashed message (`hash`) with
2084      * `signature`. This address can then be used for verification purposes.
2085      *
2086      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2087      * this function rejects them by requiring the `s` value to be in the lower
2088      * half order, and the `v` value to be either 27 or 28.
2089      *
2090      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2091      * verification to be secure: it is possible to craft signatures that
2092      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2093      * this is by receiving a hash of the original message (which may otherwise
2094      * be too long), and then calling {toEthSignedMessageHash} on it.
2095      */
2096     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2097         (address recovered, RecoverError error) = tryRecover(hash, signature);
2098         _throwError(error);
2099         return recovered;
2100     }
2101 
2102     /**
2103      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2104      *
2105      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2106      *
2107      * _Available since v4.3._
2108      */
2109     function tryRecover(
2110         bytes32 hash,
2111         bytes32 r,
2112         bytes32 vs
2113     ) internal pure returns (address, RecoverError) {
2114         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2115         uint8 v = uint8((uint256(vs) >> 255) + 27);
2116         return tryRecover(hash, v, r, s);
2117     }
2118 
2119     /**
2120      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2121      *
2122      * _Available since v4.2._
2123      */
2124     function recover(
2125         bytes32 hash,
2126         bytes32 r,
2127         bytes32 vs
2128     ) internal pure returns (address) {
2129         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2130         _throwError(error);
2131         return recovered;
2132     }
2133 
2134     /**
2135      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2136      * `r` and `s` signature fields separately.
2137      *
2138      * _Available since v4.3._
2139      */
2140     function tryRecover(
2141         bytes32 hash,
2142         uint8 v,
2143         bytes32 r,
2144         bytes32 s
2145     ) internal pure returns (address, RecoverError) {
2146         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2147         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2148         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2149         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2150         //
2151         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2152         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2153         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2154         // these malleable signatures as well.
2155         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2156             return (address(0), RecoverError.InvalidSignatureS);
2157         }
2158 
2159         // If the signature is valid (and not malleable), return the signer address
2160         address signer = ecrecover(hash, v, r, s);
2161         if (signer == address(0)) {
2162             return (address(0), RecoverError.InvalidSignature);
2163         }
2164 
2165         return (signer, RecoverError.NoError);
2166     }
2167 
2168     /**
2169      * @dev Overload of {ECDSA-recover} that receives the `v`,
2170      * `r` and `s` signature fields separately.
2171      */
2172     function recover(
2173         bytes32 hash,
2174         uint8 v,
2175         bytes32 r,
2176         bytes32 s
2177     ) internal pure returns (address) {
2178         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2179         _throwError(error);
2180         return recovered;
2181     }
2182 
2183     /**
2184      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2185      * produces hash corresponding to the one signed with the
2186      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2187      * JSON-RPC method as part of EIP-191.
2188      *
2189      * See {recover}.
2190      */
2191     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2192         // 32 is the length in bytes of hash,
2193         // enforced by the type signature above
2194         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2195     }
2196 
2197     /**
2198      * @dev Returns an Ethereum Signed Message, created from `s`. This
2199      * produces hash corresponding to the one signed with the
2200      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2201      * JSON-RPC method as part of EIP-191.
2202      *
2203      * See {recover}.
2204      */
2205     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2206         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2207     }
2208 
2209     /**
2210      * @dev Returns an Ethereum Signed Typed Data, created from a
2211      * `domainSeparator` and a `structHash`. This produces hash corresponding
2212      * to the one signed with the
2213      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2214      * JSON-RPC method as part of EIP-712.
2215      *
2216      * See {recover}.
2217      */
2218     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2219         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2220     }
2221 }
2222 
2223 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/FeralfileArtworkV3.sol
2224 
2225 
2226 pragma solidity ^0.8.0;
2227 
2228 
2229 
2230 
2231 
2232 
2233 contract FeralfileExhibitionV3 is ERC721Enumerable, Authorizable, IERC2981 {
2234     using Strings for uint256;
2235 
2236     // royalty payout address
2237     address public royaltyPayoutAddress;
2238 
2239     // the basis points of royalty payments for each secondary sales
2240     uint256 public immutable secondarySaleRoyaltyBPS;
2241 
2242     // the maximum basis points of royalty payments
2243     uint256 public constant MAX_ROYALITY_BPS = 100_00;
2244 
2245     // version code of contract
2246     string public constant codeVersion = "FeralfileExhibitionV3";
2247 
2248     // burnable
2249     bool public isBurnable;
2250 
2251     // bridgeable
2252     bool public isBridgeable;
2253 
2254     // token base URI
2255     string internal _tokenBaseURI;
2256 
2257     // contract URI
2258     string private _contractURI;
2259 
2260     /// @notice A structure for Feral File artwork
2261     struct Artwork {
2262         string title;
2263         string artistName;
2264         string fingerprint;
2265         uint256 editionSize;
2266         uint256 AEAmount;
2267         uint256 PPAmount;
2268     }
2269 
2270     struct ArtworkEdition {
2271         uint256 editionID;
2272         string ipfsCID;
2273     }
2274 
2275     struct TransferArtworkParam {
2276         address from;
2277         address to;
2278         uint256 tokenID;
2279         uint256 expireTime;
2280         bytes32 r_;
2281         bytes32 s_;
2282         uint8 v_;
2283     }
2284 
2285     struct MintArtworkParam {
2286         uint256 artworkID;
2287         uint256 edition;
2288         address artist;
2289         address owner;
2290         string ipfsCID;
2291     }
2292 
2293     struct ArtworkEditionIndex {
2294         uint256 artworkID;
2295         uint256 index;
2296     }
2297 
2298     uint256[] private _allArtworks;
2299     mapping(uint256 => Artwork) public artworks; // artworkID => Artwork
2300     mapping(uint256 => ArtworkEdition) public artworkEditions; // artworkEditionID => ArtworkEdition
2301     mapping(uint256 => uint256[]) internal allArtworkEditions; // artworkID => []ArtworkEditionID
2302     mapping(string => bool) internal registeredIPFSCIDs; // ipfsCID => bool
2303     mapping(uint256 => ArtworkEditionIndex) internal allArtworkEditionsIndex; // editionID => ArtworkEditionIndex
2304 
2305     constructor(
2306         string memory name_,
2307         string memory symbol_,
2308         uint256 secondarySaleRoyaltyBPS_,
2309         address royaltyPayoutAddress_,
2310         string memory contractURI_,
2311         string memory tokenBaseURI_,
2312         bool isBurnable_,
2313         bool isBridgeable_
2314     ) ERC721(name_, symbol_) {
2315         require(
2316             secondarySaleRoyaltyBPS_ <= MAX_ROYALITY_BPS,
2317             "royalty BPS for secondary sales can not be greater than the maximum royalty BPS"
2318         );
2319         require(
2320             royaltyPayoutAddress_ != address(0),
2321             "invalid royalty payout address"
2322         );
2323 
2324         secondarySaleRoyaltyBPS = secondarySaleRoyaltyBPS_;
2325         royaltyPayoutAddress = royaltyPayoutAddress_;
2326         _contractURI = contractURI_;
2327         _tokenBaseURI = tokenBaseURI_;
2328         isBurnable = isBurnable_;
2329         isBridgeable = isBridgeable_;
2330     }
2331 
2332     function supportsInterface(bytes4 interfaceId)
2333         public
2334         view
2335         virtual
2336         override(ERC721Enumerable, IERC165)
2337         returns (bool)
2338     {
2339         return
2340             interfaceId == type(IERC721Enumerable).interfaceId ||
2341             super.supportsInterface(interfaceId);
2342     }
2343 
2344     /// @notice Call to create an artwork in the exhibition
2345     /// @param fingerprint - the fingerprint of an artwork
2346     /// @param title - the title of an artwork
2347     /// @param artistName - the artist of an artwork
2348     /// @param editionSize - the maximum edition size of an artwork
2349     function _createArtwork(
2350         string memory fingerprint,
2351         string memory title,
2352         string memory artistName,
2353         uint256 editionSize,
2354         uint256 aeAmount,
2355         uint256 ppAmount
2356     ) internal returns (uint256) {
2357         require(bytes(title).length != 0, "title can not be empty");
2358         require(bytes(artistName).length != 0, "artist can not be empty");
2359         require(bytes(fingerprint).length != 0, "fingerprint can not be empty");
2360         require(editionSize > 0, "edition size needs to be at least 1");
2361 
2362         uint256 artworkID = uint256(keccak256(abi.encode(fingerprint)));
2363 
2364         /// @notice make sure the artwork have not been registered
2365         require(
2366             bytes(artworks[artworkID].fingerprint).length == 0,
2367             "an artwork with the same fingerprint has already registered"
2368         );
2369 
2370         Artwork memory artwork = Artwork(
2371             title = title,
2372             artistName = artistName,
2373             fingerprint = fingerprint,
2374             editionSize = editionSize,
2375             aeAmount = aeAmount,
2376             ppAmount = ppAmount
2377         );
2378 
2379         _allArtworks.push(artworkID);
2380         artworks[artworkID] = artwork;
2381 
2382         emit NewArtwork(artworkID);
2383 
2384         return artworkID;
2385     }
2386 
2387     /// @notice createArtworks use for create list of artworks in a transaction
2388     /// @param artworks_ - the array of artwork
2389     function createArtworks(Artwork[] memory artworks_)
2390         external
2391         onlyAuthorized
2392     {
2393         for (uint256 i = 0; i < artworks_.length; i++) {
2394             _createArtwork(
2395                 artworks_[i].fingerprint,
2396                 artworks_[i].title,
2397                 artworks_[i].artistName,
2398                 artworks_[i].editionSize,
2399                 artworks_[i].AEAmount,
2400                 artworks_[i].PPAmount
2401             );
2402         }
2403     }
2404 
2405     /// @notice Return a count of artworks registered in this exhibition
2406     function totalArtworks() public view virtual returns (uint256) {
2407         return _allArtworks.length;
2408     }
2409 
2410     /// @notice Return the token identifier for the `index`th artwork
2411     function getArtworkByIndex(uint256 index)
2412         public
2413         view
2414         virtual
2415         returns (uint256)
2416     {
2417         require(
2418             index < totalArtworks(),
2419             "artworks: global index out of bounds"
2420         );
2421         return _allArtworks[index];
2422     }
2423 
2424     /// @notice Update the IPFS cid of an edition to a new value
2425     function updateArtworkEditionIPFSCid(uint256 tokenId, string memory ipfsCID)
2426         external
2427         onlyAuthorized
2428     {
2429         require(_exists(tokenId), "artwork edition is not found");
2430         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
2431 
2432         ArtworkEdition storage edition = artworkEditions[tokenId];
2433         delete registeredIPFSCIDs[edition.ipfsCID];
2434         registeredIPFSCIDs[ipfsCID] = true;
2435         edition.ipfsCID = ipfsCID;
2436     }
2437 
2438     /// @notice setRoyaltyPayoutAddress assigns a payout address so
2439     //          that we can split the royalty.
2440     /// @param royaltyPayoutAddress_ - the new royalty payout address
2441     function setRoyaltyPayoutAddress(address royaltyPayoutAddress_)
2442         external
2443         onlyAuthorized
2444     {
2445         require(
2446             royaltyPayoutAddress_ != address(0),
2447             "invalid royalty payout address"
2448         );
2449         royaltyPayoutAddress = royaltyPayoutAddress_;
2450     }
2451 
2452     /// @notice Return the edition counts for an artwork
2453     function totalEditionOfArtwork(uint256 artworkID)
2454         public
2455         view
2456         returns (uint256)
2457     {
2458         return allArtworkEditions[artworkID].length;
2459     }
2460 
2461     /// @notice Return the edition id of an artwork by index
2462     function getArtworkEditionByIndex(uint256 artworkID, uint256 index)
2463         public
2464         view
2465         returns (uint256)
2466     {
2467         require(index < totalEditionOfArtwork(artworkID));
2468         return allArtworkEditions[artworkID][index];
2469     }
2470 
2471     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
2472     function tokenURI(uint256 tokenId)
2473         public
2474         view
2475         virtual
2476         override
2477         returns (string memory)
2478     {
2479         require(
2480             _exists(tokenId),
2481             "ERC721Metadata: URI query for nonexistent token"
2482         );
2483 
2484         string memory baseURI = _tokenBaseURI;
2485         if (bytes(baseURI).length == 0) {
2486             baseURI = "ipfs://";
2487         }
2488 
2489         return
2490             string(abi.encodePacked(baseURI, artworkEditions[tokenId].ipfsCID));
2491     }
2492 
2493     /// @notice Update the base URI for all tokens
2494     function setTokenBaseURI(string memory baseURI_) external onlyAuthorized {
2495         _tokenBaseURI = baseURI_;
2496     }
2497 
2498     /// @notice A URL for the opensea storefront-level metadata
2499     function contractURI() public view returns (string memory) {
2500         return _contractURI;
2501     }
2502 
2503     /// @notice Called with the sale price to determine how much royalty
2504     //          is owed and to whom.
2505     /// @param tokenId - the NFT asset queried for royalty information
2506     /// @param salePrice - the sale price of the NFT asset specified by tokenId
2507     /// @return receiver - address of who should be sent the royalty payment
2508     /// @return royaltyAmount - the royalty payment amount for salePrice
2509     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2510         external
2511         view
2512         override
2513         returns (address receiver, uint256 royaltyAmount)
2514     {
2515         require(
2516             _exists(tokenId),
2517             "ERC2981: query royalty info for nonexistent token"
2518         );
2519 
2520         receiver = royaltyPayoutAddress;
2521 
2522         royaltyAmount =
2523             (salePrice * secondarySaleRoyaltyBPS) /
2524             MAX_ROYALITY_BPS;
2525     }
2526 
2527     /// @notice isValidRequest validates a message by ecrecover to ensure
2528     //          it is signed by owner of token.
2529     /// @param message_ - the raw message for signing
2530     /// @param owner_ - owner address of token
2531     /// @param r_ - part of signature for validating parameters integrity
2532     /// @param s_ - part of signature for validating parameters integrity
2533     /// @param v_ - part of signature for validating parameters integrity
2534     function isValidRequest(
2535         bytes32 message_,
2536         address owner_,
2537         bytes32 r_,
2538         bytes32 s_,
2539         uint8 v_
2540     ) internal pure returns (bool) {
2541         address signer = ECDSA.recover(
2542             ECDSA.toEthSignedMessageHash(message_),
2543             v_,
2544             r_,
2545             s_
2546         );
2547         return signer == owner_;
2548     }
2549 
2550     /// @notice authorizedTransfer use for transfer list of items in a transaction
2551     /// @param transferParams_ - the array of transfer parameters
2552     function authorizedTransfer(TransferArtworkParam[] memory transferParams_)
2553         external
2554         onlyAuthorized
2555     {
2556         for (uint256 i = 0; i < transferParams_.length; i++) {
2557             _authorizedTransfer(transferParams_[i]);
2558         }
2559     }
2560 
2561     function _authorizedTransfer(TransferArtworkParam memory transferParam_)
2562         private
2563     {
2564         require(
2565             _exists(transferParam_.tokenID),
2566             "ERC721: artwork edition is not found"
2567         );
2568 
2569         require(
2570             _isApprovedOrOwner(transferParam_.from, transferParam_.tokenID),
2571             "ERC721: caller is not token owner nor approved"
2572         );
2573 
2574         require(
2575             block.timestamp <= transferParam_.expireTime,
2576             "FeralfileExhibitionV3: the transfer request is expired"
2577         );
2578 
2579         bytes32 requestHash = keccak256(
2580             abi.encode(
2581                 transferParam_.from,
2582                 transferParam_.to,
2583                 transferParam_.tokenID,
2584                 transferParam_.expireTime
2585             )
2586         );
2587 
2588         require(
2589             isValidRequest(
2590                 requestHash,
2591                 transferParam_.from,
2592                 transferParam_.r_,
2593                 transferParam_.s_,
2594                 transferParam_.v_
2595             ),
2596             "FeralfileExhibitionV3: the transfer request is not authorized"
2597         );
2598 
2599         _safeTransfer(
2600             transferParam_.from,
2601             transferParam_.to,
2602             transferParam_.tokenID,
2603             ""
2604         );
2605     }
2606 
2607     /// @notice batchMint is function mint array of tokens
2608     /// @param mintParams_ - the array of transfer parameters
2609     function batchMint(MintArtworkParam[] memory mintParams_)
2610         external
2611         onlyAuthorized
2612     {
2613         for (uint256 i = 0; i < mintParams_.length; i++) {
2614             _mintArtwork(
2615                 mintParams_[i].artworkID,
2616                 mintParams_[i].edition,
2617                 mintParams_[i].artist,
2618                 mintParams_[i].owner,
2619                 mintParams_[i].ipfsCID
2620             );
2621         }
2622     }
2623 
2624     /// @notice mint artwork to ERC721
2625     /// @param artworkID_ - the artwork id where the new edition is referenced to
2626     /// @param editionNumber_ - the edition number of the artwork edition
2627     /// @param artist_ - the artist address of the new minted token
2628     /// @param owner_ - the owner address of the new minted token
2629     /// @param ipfsCID_ - the IPFS cid for the new token
2630     function _mintArtwork(
2631         uint256 artworkID_,
2632         uint256 editionNumber_,
2633         address artist_,
2634         address owner_,
2635         string memory ipfsCID_
2636     ) private {
2637         /// @notice the edition size is not set implies the artwork is not created
2638         require(
2639             artworks[artworkID_].editionSize > 0,
2640             "FeralfileExhibitionV3: artwork is not found"
2641         );
2642         /// @notice The range of editionNumber should be between 0 to artwork.editionSize + artwork.AEAmount + artwork.PPAmount - 1
2643         require(
2644             editionNumber_ <
2645                 artworks[artworkID_].editionSize +
2646                     artworks[artworkID_].AEAmount +
2647                     artworks[artworkID_].PPAmount,
2648             "FeralfileExhibitionV3: edition number exceed the edition size of the artwork"
2649         );
2650         require(artist_ != address(0), "invalid artist address");
2651         require(owner_ != address(0), "invalid owner address");
2652         require(!registeredIPFSCIDs[ipfsCID_], "ipfs id has registered");
2653 
2654         uint256 editionID = artworkID_ + editionNumber_;
2655         require(
2656             artworkEditions[editionID].editionID == 0,
2657             "FeralfileExhibitionV3: the edition is existent"
2658         );
2659 
2660         ArtworkEdition memory edition = ArtworkEdition(editionID, ipfsCID_);
2661 
2662         artworkEditions[editionID] = edition;
2663         allArtworkEditions[artworkID_].push(editionID);
2664         allArtworkEditionsIndex[editionID] = ArtworkEditionIndex(
2665             artworkID_,
2666             allArtworkEditions[artworkID_].length - 1
2667         );
2668 
2669         registeredIPFSCIDs[ipfsCID_] = true;
2670 
2671         _safeMint(artist_, editionID);
2672 
2673         if (artist_ != owner_) {
2674             _safeTransfer(artist_, owner_, editionID, "");
2675         }
2676 
2677         emit NewArtworkEdition(owner_, artworkID_, editionID);
2678     }
2679 
2680     /// @notice remove an edition from allArtworkEditions
2681     /// @param editionID - the edition id where we are going to remove from allArtworkEditions
2682     function _removeEditionFromAllArtworkEditions(uint256 editionID) private {
2683         ArtworkEditionIndex
2684             memory artworkEditionIndex = allArtworkEditionsIndex[editionID];
2685 
2686         require(
2687             artworkEditionIndex.artworkID > 0,
2688             "FeralfileExhibitionV3: artworkID is no found for the artworkEditionIndex"
2689         );
2690 
2691         uint256[] storage artworkEditions_ = allArtworkEditions[
2692             artworkEditionIndex.artworkID
2693         ];
2694 
2695         require(
2696             artworkEditions_.length > 0,
2697             "FeralfileExhibitionV3: no editions in this artwork of allArtworkEditions"
2698         );
2699 
2700         uint256 lastEditionIndex = artworkEditions_.length - 1;
2701         uint256 lastEditionID = artworkEditions_[artworkEditions_.length - 1];
2702 
2703         // Swap between the last token and the to-delete token and pop up the last token
2704         artworkEditions_[artworkEditionIndex.index] = lastEditionID;
2705         artworkEditions_[lastEditionIndex] = artworkEditionIndex.index;
2706         artworkEditions_.pop();
2707 
2708         delete allArtworkEditionsIndex[editionID];
2709     }
2710 
2711     /// @notice burn editions
2712     /// @param editionIDs_ - the list of edition id will be burned
2713     function burnEditions(uint256[] memory editionIDs_) public {
2714         require(isBurnable, "FeralfileExhibitionV3: not allow burn edition");
2715 
2716         for (uint256 i = 0; i < editionIDs_.length; i++) {
2717             require(
2718                 _exists(editionIDs_[i]),
2719                 "ERC721: artwork edition is not found"
2720             );
2721             require(
2722                 _isApprovedOrOwner(_msgSender(), editionIDs_[i]),
2723                 "ERC721: caller is not token owner nor approved"
2724             );
2725             ArtworkEdition memory edition = artworkEditions[editionIDs_[i]];
2726 
2727             delete registeredIPFSCIDs[edition.ipfsCID];
2728             delete artworkEditions[editionIDs_[i]];
2729 
2730             _removeEditionFromAllArtworkEditions(editionIDs_[i]);
2731 
2732             _burn(editionIDs_[i]);
2733 
2734             emit BurnArtworkEdition(editionIDs_[i]);
2735         }
2736     }
2737 
2738     event NewArtwork(uint256 indexed artworkID);
2739     event NewArtworkEdition(
2740         address indexed owner,
2741         uint256 indexed artworkID,
2742         uint256 indexed editionID
2743     );
2744     event BurnArtworkEdition(uint256 indexed editionID);
2745 }
2746 
2747 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/FeralfileArtworkV3_2.sol
2748 
2749 
2750 pragma solidity ^0.8.0;
2751 
2752 
2753 
2754 
2755 
2756 
2757 contract FeralfileExhibitionV3_2 is
2758     FeralfileExhibitionV3,
2759     UpdateableOperatorFilterer
2760 {
2761     constructor(
2762         string memory name_,
2763         string memory symbol_,
2764         uint256 secondarySaleRoyaltyBPS_,
2765         address royaltyPayoutAddress_,
2766         string memory contractURI_,
2767         string memory tokenBaseURI_,
2768         bool isBurnable_,
2769         bool isBridgeable_
2770     )
2771         FeralfileExhibitionV3(
2772             name_,
2773             symbol_,
2774             secondarySaleRoyaltyBPS_,
2775             royaltyPayoutAddress_,
2776             contractURI_,
2777             tokenBaseURI_,
2778             isBurnable_,
2779             isBridgeable_
2780         )
2781     {}
2782 
2783     function setApprovalForAll(address operator, bool approved)
2784         public
2785         override(ERC721, IERC721)
2786         onlyAllowedOperatorApproval(operator)
2787     {
2788         super.setApprovalForAll(operator, approved);
2789     }
2790 
2791     function approve(address operator, uint256 tokenId)
2792         public
2793         override(ERC721, IERC721)
2794         onlyAllowedOperatorApproval(operator)
2795     {
2796         super.approve(operator, tokenId);
2797     }
2798 
2799     function transferFrom(
2800         address from,
2801         address to,
2802         uint256 tokenId
2803     ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2804         super.transferFrom(from, to, tokenId);
2805     }
2806 
2807     function safeTransferFrom(
2808         address from,
2809         address to,
2810         uint256 tokenId
2811     ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2812         super.safeTransferFrom(from, to, tokenId);
2813     }
2814 
2815     function safeTransferFrom(
2816         address from,
2817         address to,
2818         uint256 tokenId,
2819         bytes memory data
2820     ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2821         super.safeTransferFrom(from, to, tokenId, data);
2822     }
2823 }
2824 
2825 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/FF_V3_3_AKG%2BV3_2/contracts/FeralfileArtworkV3_3.sol
2826 
2827 
2828 pragma solidity ^0.8.0;
2829 
2830 
2831 
2832 
2833 
2834 
2835 contract FeralfileExhibitionV3_3 is FeralfileExhibitionV3_2 {
2836     using Strings for uint256;
2837 
2838     struct ExternalArtworkData {
2839         string thumbnailCID;
2840         string artworkCID;
2841     }
2842 
2843     mapping(uint256 => ExternalArtworkData) public externalArtworkIPFSCID; // artworkID => ExternalArtworkData
2844 
2845     constructor(
2846         string memory name_,
2847         string memory symbol_,
2848         uint256 secondarySaleRoyaltyBPS_,
2849         address royaltyPayoutAddress_,
2850         string memory contractURI_,
2851         string memory tokenBaseURI_,
2852         bool isBurnable_,
2853         bool isBridgeable_
2854     )
2855         FeralfileExhibitionV3_2(
2856             name_,
2857             symbol_,
2858             secondarySaleRoyaltyBPS_,
2859             royaltyPayoutAddress_,
2860             contractURI_,
2861             tokenBaseURI_,
2862             isBurnable_,
2863             isBridgeable_
2864         )
2865     {}
2866 
2867     address public decentralandAddress =
2868         0xF87E31492Faf9A91B02Ee0dEAAd50d51d56D5d4d;
2869     uint256 public decentralandTokenID =
2870         115792089237316195423570985008687907826047395311965486962387615413371672723439;
2871 
2872     function updateDecentralandInfo(address contractAddress, uint256 tokenId)
2873         external
2874         onlyOwner
2875     {
2876         decentralandAddress = contractAddress;
2877         decentralandTokenID = tokenId;
2878     }
2879 
2880     /// @notice createArtworkWithIPFSCID creates an artwork with a specific
2881     /// artwork IPFS CID given.
2882     /// @param artwork - the artwork information to be created
2883     /// @param thumbnailCID - the thumbnail CID of the external artwork file
2884     /// @param artworkCID - the artwork CID of the external artwork file
2885     function createArtworkWithIPFSCID(
2886         Artwork memory artwork,
2887         string memory thumbnailCID,
2888         string memory artworkCID
2889     ) external onlyAuthorized {
2890         require(
2891             bytes(thumbnailCID).length != 0,
2892             "thumbnail IPFS CID can not be empty"
2893         );
2894 
2895         require(
2896             bytes(artworkCID).length != 0,
2897             "artwork IPFS CID can not be empty"
2898         );
2899 
2900         uint256 artworkID = _createArtwork(
2901             artwork.fingerprint,
2902             artwork.title,
2903             artwork.artistName,
2904             artwork.editionSize,
2905             artwork.AEAmount,
2906             artwork.PPAmount
2907         );
2908 
2909         externalArtworkIPFSCID[artworkID] = ExternalArtworkData(
2910             thumbnailCID,
2911             artworkCID
2912         );
2913     }
2914 
2915     /// @notice createArtworkWithIPFSCID creates an artwork with a specific
2916     /// artwork IPFS CID given.
2917     /// @param artworkID - the artwork ID for updateing external artwork files
2918     /// @param thumbnailCID - the thumbnail CID of the external artwork file
2919     /// @param artworkCID - the artwork CID of the external artwork file
2920     function updateExternalArtworkIPFSCID(
2921         uint256 artworkID,
2922         string memory thumbnailCID,
2923         string memory artworkCID
2924     ) external onlyOwner {
2925         /// @notice make sure the artwork has already registered
2926         require(
2927             bytes(artworks[artworkID].fingerprint).length != 0,
2928             "the target artwork is not existent"
2929         );
2930 
2931         /// @notice remove external artwork info for an artwork if both
2932         /// thumbnailCID and thumbnailCID are empty
2933         if (bytes(thumbnailCID).length == 0 && bytes(artworkCID).length == 0) {
2934             delete externalArtworkIPFSCID[artworkID];
2935             return;
2936         }
2937 
2938         externalArtworkIPFSCID[artworkID] = ExternalArtworkData(
2939             thumbnailCID,
2940             artworkCID
2941         );
2942     }
2943 
2944     /// @notice tokenEditionNumber returns the edition number of a token
2945     function tokenEditionNumber(uint256 tokenID)
2946         public
2947         view
2948         returns (string memory)
2949     {
2950         ArtworkEditionIndex
2951             memory artworkEditionIndex = allArtworkEditionsIndex[tokenID];
2952 
2953         uint256 artworkID = artworkEditionIndex.artworkID;
2954 
2955         Artwork memory artwork = artworks[artworkID];
2956         uint256 ppStart = artworkID + artwork.AEAmount;
2957         uint256 neStart = artworkID + artwork.AEAmount + artwork.PPAmount;
2958 
2959         if (tokenID < ppStart) {
2960             return "AE";
2961         } else if (tokenID < neStart) {
2962             return "PP";
2963         } else {
2964             return
2965                 string(
2966                     abi.encodePacked("#", (tokenID - neStart + 1).toString())
2967                 );
2968         }
2969     }
2970 
2971     /// @notice buildArtworkData returns an object of artwork which would push to the actually artwork
2972     /// @param artworkID - the artwork ID for building artwork data
2973     function buildArtworkData(uint256 artworkID)
2974         private
2975         view
2976         returns (string memory)
2977     {
2978         Decentraland dc = Decentraland(decentralandAddress);
2979         uint256[] memory editionIDs = allArtworkEditions[artworkID];
2980         bytes memory ownersMap = bytes("{");
2981 
2982         for (uint256 i = 0; i < editionIDs.length; i++) {
2983             uint256 tokenID = editionIDs[i];
2984             ownersMap = abi.encodePacked(
2985                 ownersMap,
2986                 (tokenID - artworkID).toString(),
2987                 ':"',
2988                 Strings.toHexString(ownerOf(tokenID)),
2989                 '",'
2990             );
2991         }
2992 
2993         ownersMap = abi.encodePacked(ownersMap, "}");
2994 
2995         return
2996             string(
2997                 abi.encodePacked(
2998                     "{"
2999                     'landOwner:"',
3000                     Strings.toHexString(dc.ownerOf(decentralandTokenID)),
3001                     '", ownerMap:',
3002                     string(ownersMap),
3003                     "}"
3004                 )
3005             );
3006     }
3007 
3008     /// @notice buildIframe returns a base64 encoded data for ff-frame
3009     /// @param artworkData - the artwork data which would bring into the artwork
3010     /// @param iframeURI - the artwork URL to loaded into iframe
3011     function buildIframe(string memory artworkData, string memory iframeURI)
3012         private
3013         pure
3014         returns (string memory)
3015     {
3016         return
3017             Base64.encode(
3018                 abi.encodePacked(
3019                     '<!DOCTYPE html><html lang="en"><head><script> var defaultArtworkData= ',
3020                     artworkData,
3021                     "</script><script>"
3022                     'let allowOrigins={"https://feralfile.com":!0};function resizeIframe(e){let t=document.getElementById("mainframe");e&&(t.style.minHeight=e+"px")}'
3023                     "function initData(){defaultArtworkData.ownerArray=[];let e=defaultArtworkData.ownerMap;Object.keys(e).sort((e,t)=>e<t).forEach(t=>{defaultArtworkData.ownerArray.push(e[t])}),"
3024                     'pushArtworkDataToIframe(defaultArtworkData)}function pushArtworkDataToIframe(e){e&&document.getElementById("mainframe").contentWindow.postMessage(e,"*")}'
3025                     'function updateArtowrkData(e){document.getElementById("mainframe").contentWindow.postMessage(e,"*")}window.addEventListener("message",function(e){allowOrigins[e.origin]?'
3026                     '"update-artwork-data"===e.data.type&&updateArtowrkData(e.data.artworkData):"object"==typeof e.data&&"resize-iframe"===e.data.type&&resizeIframe(e.data.newHeight)});'
3027                     '</script></head><body style="overflow-x:hidden;padding:0;margin:0;width:100%;" onload="initData()">'
3028                     '<iframe id="mainframe" style="display:block;padding:0;margin:0;border:none;width:100%;height:100vh;" src="',
3029                     iframeURI,
3030                     '"></iframe> </body></html>'
3031                 )
3032             );
3033     }
3034 
3035     /// @notice buildDataURL returns a base64 encoded data for ff-frame
3036     /// @param artworkID - the artwork ID for building artwork data
3037     /// @param tokenID - the token ID for building artwork data
3038     /// @param thumbnailCID - the thumbnail ipfs CID for this specific artwork
3039     /// @param artworkCID - the artwork ipfs CID for this specific artwork
3040     function buildDataURL(
3041         uint256 artworkID,
3042         uint256 tokenID,
3043         string memory thumbnailCID,
3044         string memory artworkCID
3045     ) private view returns (string memory) {
3046         Artwork memory artwork = artworks[artworkID];
3047 
3048         string memory editionNumber = tokenEditionNumber(tokenID);
3049         string memory tokenName = string(
3050             abi.encodePacked(artwork.title, " ", editionNumber)
3051         );
3052         return
3053             string(
3054                 abi.encodePacked(
3055                     "data:application/json;base64,",
3056                     Base64.encode(
3057                         // We need to encode twice since the parameters are too many and
3058                         // cause the `Stack too deep` error on compilation.
3059                         abi.encodePacked(
3060                             abi.encodePacked(
3061                                 '{"id":"',
3062                                 tokenID.toString(),
3063                                 '", "name":"',
3064                                 tokenName,
3065                                 '", "artist":"',
3066                                 artwork.artistName,
3067                                 '", "artwork_id":"',
3068                                 artworkID.toHexString(),
3069                                 '", "edition_index":"',
3070                                 (tokenID - artworkID).toString(),
3071                                 '", "edition_number":"',
3072                                 editionNumber
3073                             ),
3074                             '", "external_url":"https://feralfile.com", "image":"',
3075                             buildIPFSURL(thumbnailCID),
3076                             '", "animation_url":"data:text/html;base64,',
3077                             buildIframe(
3078                                 buildArtworkData(artworkID),
3079                                 buildIPFSURL(artworkCID)
3080                             ),
3081                             '"}'
3082                         )
3083                     )
3084                 )
3085             );
3086     }
3087 
3088     /// @notice buildIPFSURL returns a formatted IPFS link based on the _tokenBaseURI
3089     /// @param ipfsCID - thei IPFS Cid
3090     function buildIPFSURL(string memory ipfsCID)
3091         private
3092         view
3093         returns (string memory)
3094     {
3095         string memory baseURI = _tokenBaseURI;
3096         if (bytes(baseURI).length == 0) {
3097             baseURI = "ipfs://";
3098         }
3099 
3100         return string(abi.encodePacked(baseURI, ipfsCID));
3101     }
3102 
3103     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
3104     function tokenURI(uint256 tokenId)
3105         public
3106         view
3107         virtual
3108         override
3109         returns (string memory)
3110     {
3111         require(
3112             _exists(tokenId),
3113             "ERC721Metadata: URI query for nonexistent token"
3114         );
3115 
3116         ArtworkEditionIndex
3117             memory artworkEditionIndex = allArtworkEditionsIndex[tokenId];
3118 
3119         uint256 artworkID = artworkEditionIndex.artworkID;
3120         string memory thumbnailCID = externalArtworkIPFSCID[artworkID]
3121             .thumbnailCID;
3122         string memory artworkCID = externalArtworkIPFSCID[artworkID].artworkCID;
3123 
3124         if (bytes(artworkCID).length > 0 && bytes(thumbnailCID).length > 0) {
3125             return buildDataURL(artworkID, tokenId, thumbnailCID, artworkCID);
3126         } else {
3127             return buildIPFSURL(artworkEditions[tokenId].ipfsCID);
3128         }
3129     }
3130 }