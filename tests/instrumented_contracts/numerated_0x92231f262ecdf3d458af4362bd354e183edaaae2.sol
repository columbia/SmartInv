1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.13;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Context
223 
224 /**
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes calldata) {
240         return msg.data;
241     }
242 }
243 
244 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC165
245 
246 /**
247  * @dev Interface of the ERC165 standard, as defined in the
248  * https://eips.ethereum.org/EIPS/eip-165[EIP].
249  *
250  * Implementers can declare support of contract interfaces, which can then be
251  * queried by others ({ERC165Checker}).
252  *
253  * For an implementation, see {ERC165}.
254  */
255 interface IERC165 {
256     /**
257      * @dev Returns true if this contract implements the interface defined by
258      * `interfaceId`. See the corresponding
259      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
260      * to learn more about how these ids are created.
261      *
262      * This function call must use less than 30 000 gas.
263      */
264     function supportsInterface(bytes4 interfaceId) external view returns (bool);
265 }
266 
267 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Receiver
268 
269 /**
270  * @title ERC721 token receiver interface
271  * @dev Interface for any contract that wants to support safeTransfers
272  * from ERC721 asset contracts.
273  */
274 interface IERC721Receiver {
275     /**
276      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
277      * by `operator` from `from`, this function is called.
278      *
279      * It must return its Solidity selector to confirm the token transfer.
280      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
281      *
282      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
283      */
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/ReentrancyGuard
293 
294 /**
295  * @dev Contract module that helps prevent reentrant calls to a function.
296  *
297  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
298  * available, which can be applied to functions to make sure there are no nested
299  * (reentrant) calls to them.
300  *
301  * Note that because there is a single `nonReentrant` guard, functions marked as
302  * `nonReentrant` may not call one another. This can be worked around by making
303  * those functions `private`, and then adding `external` `nonReentrant` entry
304  * points to them.
305  *
306  * TIP: If you would like to learn more about reentrancy and alternative ways
307  * to protect against it, check out our blog post
308  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
309  */
310 abstract contract ReentrancyGuard {
311     // Booleans are more expensive than uint256 or any type that takes up a full
312     // word because each write operation emits an extra SLOAD to first read the
313     // slot's contents, replace the bits taken up by the boolean, and then write
314     // back. This is the compiler's defense against contract upgrades and
315     // pointer aliasing, and it cannot be disabled.
316 
317     // The values being non-zero value makes deployment a bit more expensive,
318     // but in exchange the refund on every call to nonReentrant will be lower in
319     // amount. Since refunds are capped to a percentage of the total
320     // transaction's gas, it is best to keep them low in cases like this one, to
321     // increase the likelihood of the full refund coming into effect.
322     uint256 private constant _NOT_ENTERED = 1;
323     uint256 private constant _ENTERED = 2;
324 
325     uint256 private _status;
326 
327     constructor() {
328         _status = _NOT_ENTERED;
329     }
330 
331     /**
332      * @dev Prevents a contract from calling itself, directly or indirectly.
333      * Calling a `nonReentrant` function from another `nonReentrant`
334      * function is not supported. It is possible to prevent this from happening
335      * by making the `nonReentrant` function external, and making it call a
336      * `private` function that does the actual work.
337      */
338     modifier nonReentrant() {
339         // On the first call to nonReentrant, _notEntered will be true
340         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
341 
342         // Any calls to nonReentrant after this point will fail
343         _status = _ENTERED;
344 
345         _;
346 
347         // By storing the original value once again, a refund is triggered (see
348         // https://eips.ethereum.org/EIPS/eip-2200)
349         _status = _NOT_ENTERED;
350     }
351 }
352 
353 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Strings
354 
355 /**
356  * @dev String operations.
357  */
358 library Strings {
359     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
360 
361     /**
362      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
363      */
364     function toString(uint256 value) internal pure returns (string memory) {
365         // Inspired by OraclizeAPI's implementation - MIT licence
366         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
367 
368         if (value == 0) {
369             return "0";
370         }
371         uint256 temp = value;
372         uint256 digits;
373         while (temp != 0) {
374             digits++;
375             temp /= 10;
376         }
377         bytes memory buffer = new bytes(digits);
378         while (value != 0) {
379             digits -= 1;
380             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
381             value /= 10;
382         }
383         return string(buffer);
384     }
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
388      */
389     function toHexString(uint256 value) internal pure returns (string memory) {
390         if (value == 0) {
391             return "0x00";
392         }
393         uint256 temp = value;
394         uint256 length = 0;
395         while (temp != 0) {
396             length++;
397             temp >>= 8;
398         }
399         return toHexString(value, length);
400     }
401 
402     /**
403      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
404      */
405     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
406         bytes memory buffer = new bytes(2 * length + 2);
407         buffer[0] = "0";
408         buffer[1] = "x";
409         for (uint256 i = 2 * length + 1; i > 1; --i) {
410             buffer[i] = _HEX_SYMBOLS[value & 0xf];
411             value >>= 4;
412         }
413         require(value == 0, "Strings: hex length insufficient");
414         return string(buffer);
415     }
416 }
417 
418 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/ERC165
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         return interfaceId == type(IERC165).interfaceId;
440     }
441 }
442 
443 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721
444 
445 /**
446  * @dev Required interface of an ERC721 compliant contract.
447  */
448 interface IERC721 is IERC165 {
449     /**
450      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
451      */
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453 
454     /**
455      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
456      */
457     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
461      */
462     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
463 
464     /**
465      * @dev Returns the number of tokens in ``owner``'s account.
466      */
467     function balanceOf(address owner) external view returns (uint256 balance);
468 
469     /**
470      * @dev Returns the owner of the `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function ownerOf(uint256 tokenId) external view returns (address owner);
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Transfers `tokenId` token from `from` to `to`.
500      *
501      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
520      * The approval is cleared when the token is transferred.
521      *
522      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external;
532 
533     /**
534      * @dev Returns the account approved for `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function getApproved(uint256 tokenId) external view returns (address operator);
541 
542     /**
543      * @dev Approve or remove `operator` as an operator for the caller.
544      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
545      *
546      * Requirements:
547      *
548      * - The `operator` cannot be the caller.
549      *
550      * Emits an {ApprovalForAll} event.
551      */
552     function setApprovalForAll(address operator, bool _approved) external;
553 
554     /**
555      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
556      *
557      * See {setApprovalForAll}
558      */
559     function isApprovedForAll(address owner, address operator) external view returns (bool);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 }
581 
582 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Ownable
583 
584 /**
585  * @dev Contract module which provides a basic access control mechanism, where
586  * there is an account (an owner) that can be granted exclusive access to
587  * specific functions.
588  *
589  * By default, the owner account will be the one that deploys the contract. This
590  * can later be changed with {transferOwnership}.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be applied to your functions to restrict their use to
594  * the owner.
595  */
596 abstract contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600 
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor() {
605         _transferOwnership(_msgSender());
606     }
607 
608     /**
609      * @dev Returns the address of the current owner.
610      */
611     function owner() public view virtual returns (address) {
612         return _owner;
613     }
614 
615     /**
616      * @dev Throws if called by any account other than the owner.
617      */
618     modifier onlyOwner() {
619         require(owner() == _msgSender(), "Ownable: caller is not the owner");
620         _;
621     }
622 
623     /**
624      * @dev Leaves the contract without owner. It will not be possible to call
625      * `onlyOwner` functions anymore. Can only be called by the current owner.
626      *
627      * NOTE: Renouncing ownership will leave the contract without an owner,
628      * thereby removing any functionality that is only available to the owner.
629      */
630     function renounceOwnership() public virtual onlyOwner {
631         _transferOwnership(address(0));
632     }
633 
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      * Can only be called by the current owner.
637      */
638     function transferOwnership(address newOwner) public virtual onlyOwner {
639         require(newOwner != address(0), "Ownable: new owner is the zero address");
640         _transferOwnership(newOwner);
641     }
642 
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Internal function without access restriction.
646      */
647     function _transferOwnership(address newOwner) internal virtual {
648         address oldOwner = _owner;
649         _owner = newOwner;
650         emit OwnershipTransferred(oldOwner, newOwner);
651     }
652 }
653 
654 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Enumerable
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Enumerable is IERC721 {
661     /**
662      * @dev Returns the total amount of tokens stored by the contract.
663      */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
668      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
669      */
670     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
671 
672     /**
673      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
674      * Use along with {totalSupply} to enumerate all tokens.
675      */
676     function tokenByIndex(uint256 index) external view returns (uint256);
677 }
678 
679 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Metadata
680 
681 /**
682  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
683  * @dev See https://eips.ethereum.org/EIPS/eip-721
684  */
685 interface IERC721Metadata is IERC721 {
686     /**
687      * @dev Returns the token collection name.
688      */
689     function name() external view returns (string memory);
690 
691     /**
692      * @dev Returns the token collection symbol.
693      */
694     function symbol() external view returns (string memory);
695 
696     /**
697      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
698      */
699     function tokenURI(uint256 tokenId) external view returns (string memory);
700 }
701 
702 // Part: ERC721A
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
707  *
708  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
709  *
710  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
711  *
712  * Does not support burning tokens to address(0).
713  */
714 contract ERC721A is
715     Context,
716     ERC165,
717     IERC721,
718     IERC721Metadata,
719     IERC721Enumerable
720 {
721     using Address for address;
722     using Strings for uint256;
723 
724     struct TokenOwnership {
725         address addr;
726         uint64 startTimestamp;
727     }
728 
729     struct AddressData {
730         uint128 balance;
731         uint128 numberMinted;
732     }
733 
734     uint256 private currentIndex = 0;
735 
736     uint256 internal immutable collectionSize;
737     uint256 internal immutable maxBatchSize;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to ownership details
746     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
747     mapping(uint256 => TokenOwnership) private _ownerships;
748 
749     // Mapping owner address to address data
750     mapping(address => AddressData) private _addressData;
751 
752     // Mapping from token ID to approved address
753     mapping(uint256 => address) private _tokenApprovals;
754 
755     // Mapping from owner to operator approvals
756     mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758     /**
759      * @dev
760      * `maxBatchSize` refers to how much a minter can mint at a time.
761      * `collectionSize_` refers to how many tokens are in the collection.
762      */
763     constructor(
764         string memory name_,
765         string memory symbol_,
766         uint256 maxBatchSize_,
767         uint256 collectionSize_
768     ) {
769         require(
770             collectionSize_ > 0,
771             "ERC721A: collection must have a nonzero supply"
772         );
773         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
774         _name = name_;
775         _symbol = symbol_;
776         maxBatchSize = maxBatchSize_;
777         collectionSize = collectionSize_;
778     }
779 
780     /**
781      * @dev See {IERC721Enumerable-totalSupply}.
782      */
783     function totalSupply() public view override returns (uint256) {
784         return currentIndex;
785     }
786 
787     /**
788      * @dev See {IERC721Enumerable-tokenByIndex}.
789      */
790     function tokenByIndex(uint256 index)
791         public
792         view
793         override
794         returns (uint256)
795     {
796         require(index < totalSupply(), "ERC721A: global index out of bounds");
797         return index;
798     }
799 
800     /**
801      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
802      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
803      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
804      */
805     function tokenOfOwnerByIndex(address owner, uint256 index)
806         public
807         view
808         override
809         returns (uint256)
810     {
811         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
812         uint256 numMintedSoFar = totalSupply();
813         uint256 tokenIdsIdx = 0;
814         address currOwnershipAddr = address(0);
815         for (uint256 i = 0; i < numMintedSoFar; i++) {
816             TokenOwnership memory ownership = _ownerships[i];
817             if (ownership.addr != address(0)) {
818                 currOwnershipAddr = ownership.addr;
819             }
820             if (currOwnershipAddr == owner) {
821                 if (tokenIdsIdx == index) {
822                     return i;
823                 }
824                 tokenIdsIdx++;
825             }
826         }
827         revert("ERC721A: unable to get token of owner by index");
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      */
833     function supportsInterface(bytes4 interfaceId)
834         public
835         view
836         virtual
837         override(ERC165, IERC165)
838         returns (bool)
839     {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             interfaceId == type(IERC721Enumerable).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850     function balanceOf(address owner) public view override returns (uint256) {
851         require(
852             owner != address(0),
853             "ERC721A: balance query for the zero address"
854         );
855         return uint256(_addressData[owner].balance);
856     }
857 
858     function _numberMinted(address owner) internal view returns (uint256) {
859         require(
860             owner != address(0),
861             "ERC721A: number minted query for the zero address"
862         );
863         return uint256(_addressData[owner].numberMinted);
864     }
865 
866     function ownershipOf(uint256 tokenId)
867         internal
868         view
869         returns (TokenOwnership memory)
870     {
871         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
872 
873         uint256 lowestTokenToCheck;
874         if (tokenId >= maxBatchSize) {
875             lowestTokenToCheck = tokenId - maxBatchSize + 1;
876         }
877 
878         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
879             TokenOwnership memory ownership = _ownerships[curr];
880             if (ownership.addr != address(0)) {
881                 return ownership;
882             }
883         }
884 
885         revert("ERC721A: unable to determine the owner of token");
886     }
887 
888     /**
889      * @dev See {IERC721-ownerOf}.
890      */
891     function ownerOf(uint256 tokenId) public view override returns (address) {
892         return ownershipOf(tokenId).addr;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId)
913         public
914         view
915         virtual
916         override
917         returns (string memory)
918     {
919         require(
920             _exists(tokenId),
921             "ERC721Metadata: URI query for nonexistent token"
922         );
923 
924         string memory baseURI = _baseURI();
925         return
926             bytes(baseURI).length > 0
927                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
928                 : "";
929     }
930 
931     /**
932      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
933      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
934      * by default, can be overriden in child contracts.
935      */
936     function _baseURI() internal view virtual returns (string memory) {
937         return "";
938     }
939 
940     /**
941      * @dev See {IERC721-approve}.
942      */
943     function approve(address to, uint256 tokenId) public override {
944         address owner = ERC721A.ownerOf(tokenId);
945         require(to != owner, "ERC721A: approval to current owner");
946 
947         require(
948             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
949             "ERC721A: approve caller is not owner nor approved for all"
950         );
951 
952         _approve(to, tokenId, owner);
953     }
954 
955     /**
956      * @dev See {IERC721-getApproved}.
957      */
958     function getApproved(uint256 tokenId)
959         public
960         view
961         override
962         returns (address)
963     {
964         require(
965             _exists(tokenId),
966             "ERC721A: approved query for nonexistent token"
967         );
968 
969         return _tokenApprovals[tokenId];
970     }
971 
972     /**
973      * @dev See {IERC721-setApprovalForAll}.
974      */
975     function setApprovalForAll(address operator, bool approved)
976         public
977         override
978     {
979         require(operator != _msgSender(), "ERC721A: approve to caller");
980 
981         _operatorApprovals[_msgSender()][operator] = approved;
982         emit ApprovalForAll(_msgSender(), operator, approved);
983     }
984 
985     /**
986      * @dev See {IERC721-isApprovedForAll}.
987      */
988     function isApprovedForAll(address owner, address operator)
989         public
990         view
991         virtual
992         override
993         returns (bool)
994     {
995         return _operatorApprovals[owner][operator];
996     }
997 
998     /**
999      * @dev See {IERC721-transferFrom}.
1000      */
1001     function transferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public override {
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public override {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public override {
1029         _transfer(from, to, tokenId);
1030         require(
1031             _checkOnERC721Received(from, to, tokenId, _data),
1032             "ERC721A: transfer to non ERC721Receiver implementer"
1033         );
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      */
1043     function _exists(uint256 tokenId) internal view returns (bool) {
1044         return tokenId < currentIndex;
1045     }
1046 
1047     function _safeMint(address to, uint256 quantity) internal {
1048         _safeMint(to, quantity, "");
1049     }
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - there must be `quantity` tokens remaining unminted in the total collection.
1057      * - `to` cannot be the zero address.
1058      * - `quantity` cannot be larger than the max batch size.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 quantity,
1065         bytes memory _data
1066     ) internal {
1067         uint256 startTokenId = currentIndex;
1068         require(to != address(0), "ERC721A: mint to the zero address");
1069         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1070         require(!_exists(startTokenId), "ERC721A: token already minted");
1071         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         AddressData memory addressData = _addressData[to];
1076         _addressData[to] = AddressData(
1077             addressData.balance + uint128(quantity),
1078             addressData.numberMinted + uint128(quantity)
1079         );
1080         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1081 
1082         uint256 updatedIndex = startTokenId;
1083 
1084         for (uint256 i = 0; i < quantity; i++) {
1085             emit Transfer(address(0), to, updatedIndex);
1086             require(
1087                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1088                 "ERC721A: transfer to non ERC721Receiver implementer"
1089             );
1090             updatedIndex++;
1091         }
1092 
1093         currentIndex = updatedIndex;
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1113 
1114         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1115             getApproved(tokenId) == _msgSender() ||
1116             isApprovedForAll(prevOwnership.addr, _msgSender()));
1117 
1118         require(
1119             isApprovedOrOwner,
1120             "ERC721A: transfer caller is not owner nor approved"
1121         );
1122 
1123         require(
1124             prevOwnership.addr == from,
1125             "ERC721A: transfer from incorrect owner"
1126         );
1127         require(to != address(0), "ERC721A: transfer to the zero address");
1128 
1129         _beforeTokenTransfers(from, to, tokenId, 1);
1130 
1131         // Clear approvals from the previous owner
1132         _approve(address(0), tokenId, prevOwnership.addr);
1133 
1134         _addressData[from].balance -= 1;
1135         _addressData[to].balance += 1;
1136         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1137 
1138         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1139         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1140         uint256 nextTokenId = tokenId + 1;
1141         if (_ownerships[nextTokenId].addr == address(0)) {
1142             if (_exists(nextTokenId)) {
1143                 _ownerships[nextTokenId] = TokenOwnership(
1144                     prevOwnership.addr,
1145                     prevOwnership.startTimestamp
1146                 );
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(
1160         address to,
1161         uint256 tokenId,
1162         address owner
1163     ) private {
1164         _tokenApprovals[tokenId] = to;
1165         emit Approval(owner, to, tokenId);
1166     }
1167 
1168     uint256 public nextOwnerToExplicitlySet = 0;
1169 
1170     /**
1171      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1172      */
1173     function _setOwnersExplicit(uint256 quantity) internal {
1174         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1175         require(quantity > 0, "quantity must be nonzero");
1176         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1177         if (endIndex > collectionSize - 1) {
1178             endIndex = collectionSize - 1;
1179         }
1180         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1181         require(_exists(endIndex), "not enough minted yet for this cleanup");
1182         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1183             if (_ownerships[i].addr == address(0)) {
1184                 TokenOwnership memory ownership = ownershipOf(i);
1185                 _ownerships[i] = TokenOwnership(
1186                     ownership.addr,
1187                     ownership.startTimestamp
1188                 );
1189             }
1190         }
1191         nextOwnerToExplicitlySet = endIndex + 1;
1192     }
1193 
1194     /**
1195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1196      * The call is not executed if the target address is not a contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         if (to.isContract()) {
1211             try
1212                 IERC721Receiver(to).onERC721Received(
1213                     _msgSender(),
1214                     from,
1215                     tokenId,
1216                     _data
1217                 )
1218             returns (bytes4 retval) {
1219                 return retval == IERC721Receiver(to).onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert(
1223                         "ERC721A: transfer to non ERC721Receiver implementer"
1224                     );
1225                 } else {
1226                     assembly {
1227                         revert(add(32, reason), mload(reason))
1228                     }
1229                 }
1230             }
1231         } else {
1232             return true;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1238      *
1239      * startTokenId - the first token id to be transferred
1240      * quantity - the amount to be transferred
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      */
1248     function _beforeTokenTransfers(
1249         address from,
1250         address to,
1251         uint256 startTokenId,
1252         uint256 quantity
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1257      * minting.
1258      *
1259      * startTokenId - the first token id to be transferred
1260      * quantity - the amount to be transferred
1261      *
1262      * Calling conditions:
1263      *
1264      * - when `from` and `to` are both non-zero.
1265      * - `from` and `to` are never both zero.
1266      */
1267     function _afterTokenTransfers(
1268         address from,
1269         address to,
1270         uint256 startTokenId,
1271         uint256 quantity
1272     ) internal virtual {}
1273 }
1274 
1275 // File: Goblinwiveswtf.sol
1276 
1277 contract GoblinWivesWtf is Ownable, ERC721A, ReentrancyGuard {
1278     uint256 public immutable maxPerWallet = 50;
1279 
1280     uint256 public immutable devMints;
1281     uint256 public immutable maxPerTx;
1282     uint256 public immutable actualCollectionSize;
1283 
1284     bool public mintActive = false;
1285 
1286     mapping(address => uint256) amountMintedByDevs;
1287 
1288     constructor(uint256 maxBatchSize_, uint256 collectionSize_, uint256 amountForDevs_)
1289         ERC721A(
1290             "GoblinWives.WTF",
1291             "GW.WTF",
1292             maxBatchSize_,
1293             collectionSize_
1294         )
1295     {
1296         maxPerTx = maxBatchSize_;
1297         actualCollectionSize = collectionSize_;
1298         devMints = amountForDevs_;
1299     }
1300 
1301     modifier callerIsUser() {
1302         require(tx.origin == msg.sender, "The caller is another contract");
1303         _;
1304     }
1305 
1306     function mintWives(uint256 quantity) external callerIsUser {
1307 
1308         require(
1309             totalSupply() + quantity <= collectionSize,
1310             "reached max supply"
1311         );
1312         require(
1313             walletQuantity(msg.sender) + quantity <= maxPerWallet,
1314             "can not mint this many .. you have too many goblins"
1315         );
1316         require(quantity <= maxPerTx, "you are trying to mint too many, can only mint 5 at a time");
1317         require(mintActive, "can not mint yet .. wait for the moon");
1318         _safeMint(msg.sender, quantity);
1319     }
1320 
1321   
1322 
1323     function devMint(uint256 quantity) external onlyOwner {
1324         require(
1325             totalSupply() + quantity <= collectionSize,
1326             "too many already minted before dev mint, try minting less if contract isn't sold out"
1327         );
1328         require(amountMintedByDevs[msg.sender] + quantity <= devMints, "there are no more dev mints");
1329         amountMintedByDevs[msg.sender]+=quantity;
1330         _safeMint(msg.sender, quantity);
1331     }
1332 
1333 
1334     string private _baseTokenURI;
1335 
1336     function _baseURI() internal view virtual override returns (string memory) {
1337         return _baseTokenURI;
1338     }
1339 
1340     function setBaseURI(string calldata baseURI) external onlyOwner {
1341         _baseTokenURI = baseURI;
1342     }
1343 
1344     function withdrawMoney() external onlyOwner nonReentrant {
1345         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1346         require(success, "Transfer failed.");
1347     }
1348 
1349     function setOwnersExplicit(uint256 quantity)
1350         external
1351         onlyOwner
1352         nonReentrant
1353     {
1354         _setOwnersExplicit(quantity);
1355     }
1356 
1357     function walletQuantity(address owner) public view returns (uint256) {
1358         return _numberMinted(owner);
1359     }
1360 
1361     function getOwnershipData(uint256 tokenId)
1362         external
1363         view
1364         returns (TokenOwnership memory)
1365     {
1366         return ownershipOf(tokenId);
1367     }
1368 
1369     function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1370         for (uint256 i = 0; i < _tokenIds.length; i++) {
1371             transferFrom(_from, _to, _tokenIds[i]);
1372         }
1373     }
1374 
1375     function toggleMint() public onlyOwner {
1376         mintActive = !mintActive;
1377     }
1378 
1379 }
