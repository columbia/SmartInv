1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-31
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 
172 
173 
174 /**
175  * @dev String operations.
176  */
177 library Strings {
178     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
182      */
183     function toString(uint256 value) internal pure returns (string memory) {
184         // Inspired by OraclizeAPI's implementation - MIT licence
185         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
186 
187         if (value == 0) {
188             return "0";
189         }
190         uint256 temp = value;
191         uint256 digits;
192         while (temp != 0) {
193             digits++;
194             temp /= 10;
195         }
196         bytes memory buffer = new bytes(digits);
197         while (value != 0) {
198             digits -= 1;
199             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
200             value /= 10;
201         }
202         return string(buffer);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
207      */
208     function toHexString(uint256 value) internal pure returns (string memory) {
209         if (value == 0) {
210             return "0x00";
211         }
212         uint256 temp = value;
213         uint256 length = 0;
214         while (temp != 0) {
215             length++;
216             temp >>= 8;
217         }
218         return toHexString(value, length);
219     }
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
223      */
224     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
225         bytes memory buffer = new bytes(2 * length + 2);
226         buffer[0] = "0";
227         buffer[1] = "x";
228         for (uint256 i = 2 * length + 1; i > 1; --i) {
229             buffer[i] = _HEX_SYMBOLS[value & 0xf];
230             value >>= 4;
231         }
232         require(value == 0, "Strings: hex length insufficient");
233         return string(buffer);
234     }
235 }
236 
237 
238 
239 
240 /*
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 
261 
262 
263 
264 
265 
266 
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract Ownable is Context {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     constructor() {
289         _setOwner(_msgSender());
290     }
291 
292     /**
293      * @dev Returns the address of the current owner.
294      */
295     function owner() public view virtual returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(owner() == _msgSender(), "Ownable: caller is not the owner");
304         _;
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public virtual onlyOwner {
315         _setOwner(address(0));
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _setOwner(newOwner);
325     }
326 
327     function _setOwner(address newOwner) private {
328         address oldOwner = _owner;
329         _owner = newOwner;
330         emit OwnershipTransferred(oldOwner, newOwner);
331     }
332 }
333 
334 
335 
336 
337 
338 /**
339  * @dev Contract module that helps prevent reentrant calls to a function.
340  *
341  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
342  * available, which can be applied to functions to make sure there are no nested
343  * (reentrant) calls to them.
344  *
345  * Note that because there is a single `nonReentrant` guard, functions marked as
346  * `nonReentrant` may not call one another. This can be worked around by making
347  * those functions `private`, and then adding `external` `nonReentrant` entry
348  * points to them.
349  *
350  * TIP: If you would like to learn more about reentrancy and alternative ways
351  * to protect against it, check out our blog post
352  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
353  */
354 abstract contract ReentrancyGuard {
355     // Booleans are more expensive than uint256 or any type that takes up a full
356     // word because each write operation emits an extra SLOAD to first read the
357     // slot's contents, replace the bits taken up by the boolean, and then write
358     // back. This is the compiler's defense against contract upgrades and
359     // pointer aliasing, and it cannot be disabled.
360 
361     // The values being non-zero value makes deployment a bit more expensive,
362     // but in exchange the refund on every call to nonReentrant will be lower in
363     // amount. Since refunds are capped to a percentage of the total
364     // transaction's gas, it is best to keep them low in cases like this one, to
365     // increase the likelihood of the full refund coming into effect.
366     uint256 private constant _NOT_ENTERED = 1;
367     uint256 private constant _ENTERED = 2;
368 
369     uint256 private _status;
370 
371     constructor() {
372         _status = _NOT_ENTERED;
373     }
374 
375     /**
376      * @dev Prevents a contract from calling itself, directly or indirectly.
377      * Calling a `nonReentrant` function from another `nonReentrant`
378      * function is not supported. It is possible to prevent this from happening
379      * by making the `nonReentrant` function external, and make it call a
380      * `private` function that does the actual work.
381      */
382     modifier nonReentrant() {
383         // On the first call to nonReentrant, _notEntered will be true
384         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
385 
386         // Any calls to nonReentrant after this point will fail
387         _status = _ENTERED;
388 
389         _;
390 
391         // By storing the original value once again, a refund is triggered (see
392         // https://eips.ethereum.org/EIPS/eip-2200)
393         _status = _NOT_ENTERED;
394     }
395 }
396 
397 
398 
399 
400 
401 
402 
403 
404 
405 
406 
407 
408 
409 
410 /**
411  * @title ERC721 token receiver interface
412  * @dev Interface for any contract that wants to support safeTransfers
413  * from ERC721 asset contracts.
414  */
415 interface IERC721Receiver {
416     /**
417      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
418      * by `operator` from `from`, this function is called.
419      *
420      * It must return its Solidity selector to confirm the token transfer.
421      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
422      *
423      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 
434 
435 
436 
437 
438 
439 /**
440  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
441  * @dev See https://eips.ethereum.org/EIPS/eip-721
442  */
443 interface IERC721Metadata is IERC721 {
444     /**
445      * @dev Returns the token collection name.
446      */
447     function name() external view returns (string memory);
448 
449     /**
450      * @dev Returns the token collection symbol.
451      */
452     function symbol() external view returns (string memory);
453 
454     /**
455      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
456      */
457     function tokenURI(uint256 tokenId) external view returns (string memory);
458 }
459 
460 
461 
462 
463 
464 /**
465  * @dev Collection of functions related to the address type
466  */
467 library Address {
468     /**
469      * @dev Returns true if `account` is a contract.
470      *
471      * [IMPORTANT]
472      * ====
473      * It is unsafe to assume that an address for which this function returns
474      * false is an externally-owned account (EOA) and not a contract.
475      *
476      * Among others, `isContract` will return false for the following
477      * types of addresses:
478      *
479      *  - an externally-owned account
480      *  - a contract in construction
481      *  - an address where a contract will be created
482      *  - an address where a contract lived, but was destroyed
483      * ====
484      */
485     function isContract(address account) internal view returns (bool) {
486         // This method relies on extcodesize, which returns 0 for contracts in
487         // construction, since the code is only stored at the end of the
488         // constructor execution.
489 
490         uint256 size;
491         assembly {
492             size := extcodesize(account)
493         }
494         return size > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         (bool success, ) = recipient.call{value: amount}("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(address(this).balance >= value, "Address: insufficient balance for call");
588         require(isContract(target), "Address: call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.call{value: value}(data);
591         return _verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal view returns (bytes memory) {
615         require(isContract(target), "Address: static call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return _verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
628         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(isContract(target), "Address: delegate call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return _verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     function _verifyCallResult(
649         bool success,
650         bytes memory returndata,
651         string memory errorMessage
652     ) private pure returns (bytes memory) {
653         if (success) {
654             return returndata;
655         } else {
656             // Look for revert reason and bubble it up if present
657             if (returndata.length > 0) {
658                 // The easiest way to bubble the revert reason is using memory via assembly
659 
660                 assembly {
661                     let returndata_size := mload(returndata)
662                     revert(add(32, returndata), returndata_size)
663                 }
664             } else {
665                 revert(errorMessage);
666             }
667         }
668     }
669 }
670 
671 
672 
673 
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of the {IERC165} interface.
681  *
682  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
683  * for the additional interface id that will be supported. For example:
684  *
685  * ```solidity
686  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
688  * }
689  * ```
690  *
691  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
692  */
693 abstract contract ERC165 is IERC165 {
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698         return interfaceId == type(IERC165).interfaceId;
699     }
700 }
701 
702 
703 /**
704  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
705  * the Metadata extension, but not including the Enumerable extension, which is available separately as
706  * {ERC721Enumerable}.
707  */
708 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     mapping(uint256 => address) private _owners;
720 
721     // Mapping owner address to token count
722     mapping(address => uint256) private _balances;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     /**
731      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
732      */
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return
743             interfaceId == type(IERC721).interfaceId ||
744             interfaceId == type(IERC721Metadata).interfaceId ||
745             super.supportsInterface(interfaceId);
746     }
747 
748     /**
749      * @dev See {IERC721-balanceOf}.
750      */
751     function balanceOf(address owner) public view virtual override returns (uint256) {
752         require(owner != address(0), "ERC721: balance query for the zero address");
753         return _balances[owner];
754     }
755 
756     /**
757      * @dev See {IERC721-ownerOf}.
758      */
759     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
760         address owner = _owners[tokenId];
761         require(owner != address(0), "ERC721: owner query for nonexistent token");
762         return owner;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-name}.
767      */
768     function name() public view virtual override returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-symbol}.
774      */
775     function symbol() public view virtual override returns (string memory) {
776         return _symbol;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-tokenURI}.
781      */
782     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
783         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
784 
785         string memory baseURI = _baseURI();
786         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
787     }
788 
789     /**
790      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
791      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
792      * by default, can be overriden in child contracts.
793      */
794     function _baseURI() internal view virtual returns (string memory) {
795         return "";
796     }
797 
798     /**
799      * @dev See {IERC721-approve}.
800      */
801     function approve(address to, uint256 tokenId) public virtual override {
802         address owner = ERC721.ownerOf(tokenId);
803         require(to != owner, "ERC721: approval to current owner");
804 
805         require(
806             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
807             "ERC721: approve caller is not owner nor approved for all"
808         );
809 
810         _approve(to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-getApproved}.
815      */
816     function getApproved(uint256 tokenId) public view virtual override returns (address) {
817         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
818 
819         return _tokenApprovals[tokenId];
820     }
821 
822     /**
823      * @dev See {IERC721-setApprovalForAll}.
824      */
825     function setApprovalForAll(address operator, bool approved) public virtual override {
826         require(operator != _msgSender(), "ERC721: approve to caller");
827 
828         _operatorApprovals[_msgSender()][operator] = approved;
829         emit ApprovalForAll(_msgSender(), operator, approved);
830     }
831 
832     /**
833      * @dev See {IERC721-isApprovedForAll}.
834      */
835     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
836         return _operatorApprovals[owner][operator];
837     }
838 
839     /**
840      * @dev See {IERC721-transferFrom}.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         //solhint-disable-next-line max-line-length
848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
849 
850         _transfer(from, to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-safeTransferFrom}.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         safeTransferFrom(from, to, tokenId, "");
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) public virtual override {
873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
874         _safeTransfer(from, to, tokenId, _data);
875     }
876 
877     /**
878      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
879      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
880      *
881      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
882      *
883      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
884      * implement alternative mechanisms to perform token transfer, such as signature-based.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must exist and be owned by `from`.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeTransfer(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) internal virtual {
901         _transfer(from, to, tokenId);
902         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
903     }
904 
905     /**
906      * @dev Returns whether `tokenId` exists.
907      *
908      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
909      *
910      * Tokens start existing when they are minted (`_mint`),
911      * and stop existing when they are burned (`_burn`).
912      */
913     function _exists(uint256 tokenId) internal view virtual returns (bool) {
914         return _owners[tokenId] != address(0);
915     }
916 
917     /**
918      * @dev Returns whether `spender` is allowed to manage `tokenId`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must exist.
923      */
924     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
925         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
926         address owner = ERC721.ownerOf(tokenId);
927         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
928     }
929 
930     /**
931      * @dev Safely mints `tokenId` and transfers it to `to`.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must not exist.
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeMint(address to, uint256 tokenId) internal virtual {
941         _safeMint(to, tokenId, "");
942     }
943 
944     /**
945      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
946      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
947      */
948     function _safeMint(
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) internal virtual {
953         _mint(to, tokenId);
954         require(
955             _checkOnERC721Received(address(0), to, tokenId, _data),
956             "ERC721: transfer to non ERC721Receiver implementer"
957         );
958     }
959 
960     /**
961      * @dev Mints `tokenId` and transfers it to `to`.
962      *
963      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - `to` cannot be the zero address.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _mint(address to, uint256 tokenId) internal virtual {
973         require(to != address(0), "ERC721: mint to the zero address");
974         require(!_exists(tokenId), "ERC721: token already minted");
975 
976         _beforeTokenTransfer(address(0), to, tokenId);
977 
978         _balances[to] += 1;
979         _owners[tokenId] = to;
980 
981         emit Transfer(address(0), to, tokenId);
982     }
983 
984     /**
985      * @dev Destroys `tokenId`.
986      * The approval is cleared when the token is burned.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _burn(uint256 tokenId) internal virtual {
995         address owner = ERC721.ownerOf(tokenId);
996 
997         _beforeTokenTransfer(owner, address(0), tokenId);
998 
999         // Clear approvals
1000         _approve(address(0), tokenId);
1001 
1002         _balances[owner] -= 1;
1003         delete _owners[tokenId];
1004 
1005         emit Transfer(owner, address(0), tokenId);
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {
1024         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1025         require(to != address(0), "ERC721: transfer to the zero address");
1026 
1027         _beforeTokenTransfer(from, to, tokenId);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId);
1031 
1032         _balances[from] -= 1;
1033         _balances[to] += 1;
1034         _owners[tokenId] = to;
1035 
1036         emit Transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Approve `to` to operate on `tokenId`
1041      *
1042      * Emits a {Approval} event.
1043      */
1044     function _approve(address to, uint256 tokenId) internal virtual {
1045         _tokenApprovals[tokenId] = to;
1046         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1051      * The call is not executed if the target address is not a contract.
1052      *
1053      * @param from address representing the previous owner of the given token ID
1054      * @param to target address that will receive the tokens
1055      * @param tokenId uint256 ID of the token to be transferred
1056      * @param _data bytes optional data to send along with the call
1057      * @return bool whether the call correctly returned the expected magic value
1058      */
1059     function _checkOnERC721Received(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) private returns (bool) {
1065         if (to.isContract()) {
1066             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1067                 return retval == IERC721Receiver(to).onERC721Received.selector;
1068             } catch (bytes memory reason) {
1069                 if (reason.length == 0) {
1070                     revert("ERC721: transfer to non ERC721Receiver implementer");
1071                 } else {
1072                     assembly {
1073                         revert(add(32, reason), mload(reason))
1074                     }
1075                 }
1076             }
1077         } else {
1078             return true;
1079         }
1080     }
1081 
1082     /**
1083      * @dev Hook that is called before any token transfer. This includes minting
1084      * and burning.
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` will be minted for `to`.
1091      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1092      * - `from` and `to` are never both zero.
1093      *
1094      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1095      */
1096     function _beforeTokenTransfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) internal virtual {}
1101 }
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 /**
1110  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1111  * @dev See https://eips.ethereum.org/EIPS/eip-721
1112  */
1113 interface IERC721Enumerable is IERC721 {
1114     /**
1115      * @dev Returns the total amount of tokens stored by the contract.
1116      */
1117     function totalSupply() external view returns (uint256);
1118 
1119     /**
1120      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1121      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1122      */
1123     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1124 
1125     /**
1126      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1127      * Use along with {totalSupply} to enumerate all tokens.
1128      */
1129     function tokenByIndex(uint256 index) external view returns (uint256);
1130 }
1131 
1132 
1133 /**
1134  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1135  * enumerability of all the token ids in the contract as well as all token ids owned by each
1136  * account.
1137  */
1138 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1139     // Mapping from owner to list of owned token IDs
1140     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1141 
1142     // Mapping from token ID to index of the owner tokens list
1143     mapping(uint256 => uint256) private _ownedTokensIndex;
1144 
1145     // Array with all token ids, used for enumeration
1146     uint256[] private _allTokens;
1147 
1148     // Mapping from token id to position in the allTokens array
1149     mapping(uint256 => uint256) private _allTokensIndex;
1150 
1151     /**
1152      * @dev See {IERC165-supportsInterface}.
1153      */
1154     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1155         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1160      */
1161     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1162         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1163         return _ownedTokens[owner][index];
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Enumerable-totalSupply}.
1168      */
1169     function totalSupply() public view virtual override returns (uint256) {
1170         return _allTokens.length;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Enumerable-tokenByIndex}.
1175      */
1176     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1177         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1178         return _allTokens[index];
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before any token transfer. This includes minting
1183      * and burning.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1191      * - `from` cannot be the zero address.
1192      * - `to` cannot be the zero address.
1193      *
1194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1195      */
1196     function _beforeTokenTransfer(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) internal virtual override {
1201         super._beforeTokenTransfer(from, to, tokenId);
1202 
1203         if (from == address(0)) {
1204             _addTokenToAllTokensEnumeration(tokenId);
1205         } else if (from != to) {
1206             _removeTokenFromOwnerEnumeration(from, tokenId);
1207         }
1208         if (to == address(0)) {
1209             _removeTokenFromAllTokensEnumeration(tokenId);
1210         } else if (to != from) {
1211             _addTokenToOwnerEnumeration(to, tokenId);
1212         }
1213     }
1214 
1215     /**
1216      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1217      * @param to address representing the new owner of the given token ID
1218      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1219      */
1220     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1221         uint256 length = ERC721.balanceOf(to);
1222         _ownedTokens[to][length] = tokenId;
1223         _ownedTokensIndex[tokenId] = length;
1224     }
1225 
1226     /**
1227      * @dev Private function to add a token to this extension's token tracking data structures.
1228      * @param tokenId uint256 ID of the token to be added to the tokens list
1229      */
1230     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1231         _allTokensIndex[tokenId] = _allTokens.length;
1232         _allTokens.push(tokenId);
1233     }
1234 
1235     /**
1236      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1237      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1238      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1239      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1240      * @param from address representing the previous owner of the given token ID
1241      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1242      */
1243     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1244         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1245         // then delete the last slot (swap and pop).
1246 
1247         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1248         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1249 
1250         // When the token to delete is the last token, the swap operation is unnecessary
1251         if (tokenIndex != lastTokenIndex) {
1252             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1253 
1254             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1255             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1256         }
1257 
1258         // This also deletes the contents at the last position of the array
1259         delete _ownedTokensIndex[tokenId];
1260         delete _ownedTokens[from][lastTokenIndex];
1261     }
1262 
1263     /**
1264      * @dev Private function to remove a token from this extension's token tracking data structures.
1265      * This has O(1) time complexity, but alters the order of the _allTokens array.
1266      * @param tokenId uint256 ID of the token to be removed from the tokens list
1267      */
1268     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1269         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1270         // then delete the last slot (swap and pop).
1271 
1272         uint256 lastTokenIndex = _allTokens.length - 1;
1273         uint256 tokenIndex = _allTokensIndex[tokenId];
1274 
1275         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1276         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1277         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1278         uint256 lastTokenId = _allTokens[lastTokenIndex];
1279 
1280         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1281         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1282 
1283         // This also deletes the contents at the last position of the array
1284         delete _allTokensIndex[tokenId];
1285         _allTokens.pop();
1286     }
1287 }
1288 
1289 
1290 contract BlootRealEstate is ERC721Enumerable, ReentrancyGuard, Ownable {
1291 
1292     ERC721 bloot = ERC721(0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613);
1293     
1294     // mirror a n-sided dice roll
1295     function randomN(uint256 tokenId, string memory keyPrefix, uint8 n) internal pure returns (uint256) {
1296         string memory input = string(abi.encodePacked(keyPrefix, toString(tokenId), "1"));
1297         uint256 roll = (uint256(keccak256(abi.encodePacked(input))) % n) + 1;
1298         return roll;
1299     }
1300 
1301     function random3(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
1302         string memory input1 = string(abi.encodePacked(keyPrefix, toString(tokenId), "1"));
1303         string memory input2 = string(abi.encodePacked(keyPrefix, toString(tokenId), "2"));
1304         string memory input3 = string(abi.encodePacked(keyPrefix, toString(tokenId), "3"));
1305 
1306         uint256 roll1 = (uint256(keccak256(abi.encodePacked(input1))) % 6) + 1;
1307         uint256 roll2 = (uint256(keccak256(abi.encodePacked(input2))) % 6) + 1;
1308         uint256 roll3 = (uint256(keccak256(abi.encodePacked(input3))) % 6) + 1;
1309 
1310         uint256 sum = roll1 + roll2 + roll3;
1311         return sum;
1312     }
1313     
1314     function getLocation(uint256 tokenId) public pure returns (string memory) {
1315         return pluckLocation(tokenId, "Location");
1316     }
1317     
1318     function getType(uint256 tokenId) public pure returns (string memory) {
1319         return pluckType(tokenId, "Type");
1320     }
1321     
1322     function getPartOfTown(uint256 tokenId) public pure returns (string memory) {
1323         return pluckPartOfTown(tokenId, "Part of Town");
1324     }
1325     
1326     function getBedrooms(uint256 tokenId) public pure returns (string memory) {
1327         return pluckRooms(tokenId, "Bedrooms");
1328     }
1329 
1330     function getBathrooms(uint256 tokenId) public pure returns (string memory) {
1331         return pluckRooms(tokenId, "Bathrooms");
1332     }
1333     
1334     function getAttribute1(uint256 tokenId) public pure returns (string memory) {
1335         return pluckAttribute(tokenId, "Attribute 1");
1336     }
1337 
1338     function getAttribute2(uint256 tokenId) public pure returns (string memory) {
1339         return pluckAttribute(tokenId, "Attribute 2");
1340     }
1341 
1342     function getAttribute3(uint256 tokenId) public pure returns (string memory) {
1343         return pluckAttribute(tokenId, "Attribute 3");
1344     }
1345     
1346     /*
1347         3: 1/216 = 0.5%, 1
1348         4: 3/216 = 1.4%, 4
1349         5: 6/216 = 2.8%, 10
1350         6: 10/216 = 4.6%, 20
1351         7: 15/216 = 7.0%, 35
1352         8: 21/216 = 9.7%, 56
1353         9: 25/216 = 11.6%, 81
1354         10: 27/216 = 12.5%, 108
1355         11: 27/216 = 12.5%, 135
1356         12: 25/216 = 11.6%, 160
1357         13: 21/216 = 9.7%, 181
1358         14: 15/216 = 7.0%, 196
1359         15: 10/216 = 4.6%, 206
1360         16: 6/216 = 2.8%, 212
1361         17: 3/216 = 1.4%, 215
1362         18: 1/216 = 0.5%, 216
1363     */
1364     function pluckLocation(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1365         uint256 roll = randomN(tokenId, keyPrefix, 13);
1366         string memory location = "";
1367         if (roll == 1) {
1368             location = "Shithole, Nowhere";
1369         }
1370         else if (roll == 2) {
1371             location = "New York, NY";
1372         }
1373         else if (roll == 3) {
1374             location = "Paris, France";
1375         }
1376         else if (roll == 4) {
1377             location = "London, UK";
1378         }
1379         else if (roll == 5) {
1380             location = "Tokyo, Japan";
1381         }
1382         else if (roll == 6) {
1383             location = "Beijing, China";
1384         }
1385         else if (roll == 7) {
1386             location = "Vancouver, Canada";
1387         }
1388         else if (roll == 8) {
1389             location = "Tel Aviv, Israel";
1390         }
1391         else if (roll == 9) {
1392             location = "Amsterdam, Netherlands";
1393         }
1394         else if (roll == 10) {
1395             location = "San Francisco, California";
1396         }
1397         else if (roll == 11) {
1398             location = "Los Angeles, California";
1399         }
1400         else if (roll == 12) {
1401             location = "Miami, Florida";
1402         }
1403         else {
1404             location = "Gary, Indiana";
1405         }
1406 
1407         string memory output = string(abi.encodePacked(keyPrefix, ": ", location));
1408         return output;
1409     }
1410 
1411     function pluckType(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1412         uint256 roll = random3(tokenId, keyPrefix);
1413         string memory homeType = "";
1414         if (roll < 6) {
1415             homeType = "Mansion";
1416         }
1417         else if (roll < 9) {
1418             homeType = "Single Family Home";
1419         }
1420         else if (roll < 11) {
1421             homeType = "Condo";
1422         }
1423         else if (roll == 13) {
1424             homeType = "Townhouse";
1425         }
1426         else if (roll == 14) {
1427             homeType = "Ranch";
1428         }
1429         else {
1430             homeType = "Shack";
1431         }
1432 
1433         string memory output = string(abi.encodePacked(keyPrefix, ": ", homeType));
1434         return output;
1435     }
1436 
1437     function pluckPartOfTown(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1438         uint256 roll = randomN(tokenId, keyPrefix, 3);
1439         string memory part = "";
1440         if (roll == 1) {
1441             part = "Downtown";
1442         }
1443         else if (roll == 2) {
1444             part = "Suburbs";
1445         }
1446         else{
1447             part = 'Wilderness';
1448         }
1449 
1450         string memory output = string(abi.encodePacked(keyPrefix, ": ", part));
1451         return output;
1452     }
1453 
1454     function pluckRooms(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1455         uint256 roll = random3(tokenId, keyPrefix);
1456         uint8 rooms = 1;
1457 
1458         if (roll == 10 || roll == 11) {
1459             rooms = 1;
1460         }
1461         else if (roll == 9 || roll == 12) {
1462             rooms = 2;
1463         }
1464         else if (roll == 8 || roll == 13) {
1465             rooms = 3;
1466         }
1467         else if (roll == 7 || roll == 14) {
1468             rooms = 4;
1469         }
1470         else if (roll == 6 || roll == 15) {
1471             rooms = 5;
1472         }
1473         else if (roll == 5 || roll == 16) {
1474             rooms = 6;
1475         }
1476         else if (roll == 4 || roll == 17) {
1477             rooms = 7;
1478         }
1479         else if (roll == 3 || roll == 18) {
1480             rooms = 8;
1481         }
1482 
1483         string memory output = string(abi.encodePacked(keyPrefix, ": ", toString(rooms)));
1484         return output;
1485     }
1486 
1487     function pluckAttribute(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1488         uint256 roll = random3(tokenId, keyPrefix);
1489         string memory attribute = "";
1490         if (roll == 3) {
1491             attribute = "Beanie's Rainbow Cap";
1492         }
1493         else if (roll == 18) {
1494             attribute = "1,000,000 BGLD Wallet";
1495         }
1496         else if (roll == 4) {
1497             attribute = "Lamborghini Aventador";
1498         }
1499         else if (roll == 17) {
1500             attribute = "Stripper Pole";
1501         }
1502         else if (roll == 5) {
1503             attribute = "Cock Ring Holder";
1504         }
1505         else if (roll == 16) {
1506             attribute = "Infinity Pool";
1507         }
1508         else if (roll == 6) {
1509             attribute = "8Sleep Mattress";
1510         }
1511         else if (roll == 15) {
1512             attribute = "Private Gym";
1513         }
1514         else if (roll == 7) {
1515             attribute = "Broken Toilet";
1516         }
1517         else if (roll == 14) {
1518             attribute = "Inflatable Pool";
1519         }
1520         else if (roll == 8) {
1521             attribute = "Mercedes Benz C300";
1522         }
1523         else if (roll == 13) {
1524             attribute = "Toyota Corolla";
1525         }
1526         else if (roll == 9) {
1527             attribute = "Honda Sienna";
1528         }
1529         else if (roll == 12) { 
1530             attribute = "Expired Milk";
1531         }
1532         else if (roll == 11) {
1533             attribute = "Creaky Furniture";
1534         }
1535         else if (roll == 10) {
1536             attribute = "17 inch TV";
1537         }
1538         else {
1539             attribute = "None";
1540         }
1541 
1542         string memory output = string(abi.encodePacked(keyPrefix, ": ", attribute));
1543         return output;
1544     }
1545 
1546 
1547     function tokenURI(uint256 tokenId) override public pure returns (string memory) {
1548         string[17] memory parts;
1549         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1550 
1551         parts[1] = getLocation(tokenId);
1552 
1553         parts[2] = '</text><text x="10" y="40" class="base">';
1554 
1555         parts[3] = getType(tokenId);
1556 
1557         parts[4] = '</text><text x="10" y="60" class="base">';
1558 
1559         parts[5] = getPartOfTown(tokenId);
1560 
1561         parts[6] = '</text><text x="10" y="80" class="base">';
1562 
1563         parts[7] = getBedrooms(tokenId);
1564 
1565         parts[8] = '</text><text x="10" y="100" class="base">';
1566 
1567         parts[9] = getBathrooms(tokenId);
1568 
1569         parts[10] = '</text><text x="10" y="120" class="base">';
1570 
1571         parts[11] = getAttribute1(tokenId);
1572 
1573         parts[12] = '</text><text x="10" y="140" class="base">';
1574 
1575         parts[13] = getAttribute2(tokenId);
1576 
1577         parts[14] = '</text><text x="10" y="160" class="base">';
1578 
1579         parts[15] = getAttribute3(tokenId);
1580 
1581         parts[16] = '</text></svg>';
1582 
1583         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1584         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1585         
1586         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bloot Home #', toString(tokenId), '", "description": "Bloot Real Estate Market (not for Weaks) is a collection of non-fungible tokens stored on the Ethereum Blockchain, to be used in the Bloot metaverse.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1587         output = string(abi.encodePacked('data:application/json;base64,', json));
1588 
1589         return output;
1590     }
1591     
1592     function claimForBlootOwner(uint256 tokenId) public nonReentrant {
1593         require(tokenId > 0 && tokenId < 8009, "Token ID invalid");
1594         require(bloot.ownerOf(tokenId) == msg.sender, "Not Bloot owner");
1595         _safeMint(_msgSender(), tokenId);
1596     }
1597     
1598     function toString(uint256 value) internal pure returns (string memory) {
1599     // Inspired by OraclizeAPI's implementation - MIT license
1600     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1601 
1602         if (value == 0) {
1603             return "0";
1604         }
1605         uint256 temp = value;
1606         uint256 digits;
1607         while (temp != 0) {
1608             digits++;
1609             temp /= 10;
1610         }
1611         bytes memory buffer = new bytes(digits);
1612         while (value != 0) {
1613             digits -= 1;
1614             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1615             value /= 10;
1616         }
1617         return string(buffer);
1618     }
1619     
1620     constructor() ERC721("BlootRealEstate", "BlootRE") Ownable() {}
1621 }
1622 
1623 /// [MIT License]
1624 /// @title Base64
1625 /// @notice Provides a function for encoding some bytes in base64
1626 /// @author Brecht Devos <brecht@loopring.org>
1627 library Base64 {
1628     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1629 
1630     /// @notice Encodes some bytes to the base64 representation
1631     function encode(bytes memory data) internal pure returns (string memory) {
1632         uint256 len = data.length;
1633         if (len == 0) return "";
1634 
1635         // multiply by 4/3 rounded up
1636         uint256 encodedLen = 4 * ((len + 2) / 3);
1637 
1638         // Add some extra buffer at the end
1639         bytes memory result = new bytes(encodedLen + 32);
1640 
1641         bytes memory table = TABLE;
1642 
1643         assembly {
1644             let tablePtr := add(table, 1)
1645             let resultPtr := add(result, 32)
1646 
1647             for {
1648                 let i := 0
1649             } lt(i, len) {
1650 
1651             } {
1652                 i := add(i, 3)
1653                 let input := and(mload(add(data, i)), 0xffffff)
1654 
1655                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1656                 out := shl(8, out)
1657                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1658                 out := shl(8, out)
1659                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1660                 out := shl(8, out)
1661                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1662                 out := shl(224, out)
1663 
1664                 mstore(resultPtr, out)
1665 
1666                 resultPtr := add(resultPtr, 4)
1667             }
1668 
1669             switch mod(len, 3)
1670             case 1 {
1671                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1672             }
1673             case 2 {
1674                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1675             }
1676 
1677             mstore(result, encodedLen)
1678         }
1679 
1680         return string(result);
1681     }
1682 }