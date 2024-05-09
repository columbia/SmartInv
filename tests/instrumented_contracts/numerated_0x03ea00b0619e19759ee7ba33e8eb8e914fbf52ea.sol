1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-27
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
34 
35 
36 
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 
178 
179 /**
180  * @dev String operations.
181  */
182 library Strings {
183     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
187      */
188     function toString(uint256 value) internal pure returns (string memory) {
189         // Inspired by OraclizeAPI's implementation - MIT licence
190         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
191 
192         if (value == 0) {
193             return "0";
194         }
195         uint256 temp = value;
196         uint256 digits;
197         while (temp != 0) {
198             digits++;
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         while (value != 0) {
203             digits -= 1;
204             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
205             value /= 10;
206         }
207         return string(buffer);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
212      */
213     function toHexString(uint256 value) internal pure returns (string memory) {
214         if (value == 0) {
215             return "0x00";
216         }
217         uint256 temp = value;
218         uint256 length = 0;
219         while (temp != 0) {
220             length++;
221             temp >>= 8;
222         }
223         return toHexString(value, length);
224     }
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
228      */
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 }
241 
242 
243 
244 
245 /*
246  * @dev Provides information about the current execution context, including the
247  * sender of the transaction and its data. While these are generally available
248  * via msg.sender and msg.data, they should not be accessed in such a direct
249  * manner, since when dealing with meta-transactions the account sending and
250  * paying for execution may not be the actual sender (as far as an application
251  * is concerned).
252  *
253  * This contract is only required for intermediate, library-like contracts.
254  */
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes calldata) {
261         return msg.data;
262     }
263 }
264 
265 
266 
267 
268 
269 
270 
271 
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor() {
294         _setOwner(_msgSender());
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         _setOwner(address(0));
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         _setOwner(newOwner);
330     }
331 
332     function _setOwner(address newOwner) private {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 
340 
341 
342 
343 /**
344  * @dev Contract module that helps prevent reentrant calls to a function.
345  *
346  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
347  * available, which can be applied to functions to make sure there are no nested
348  * (reentrant) calls to them.
349  *
350  * Note that because there is a single `nonReentrant` guard, functions marked as
351  * `nonReentrant` may not call one another. This can be worked around by making
352  * those functions `private`, and then adding `external` `nonReentrant` entry
353  * points to them.
354  *
355  * TIP: If you would like to learn more about reentrancy and alternative ways
356  * to protect against it, check out our blog post
357  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
358  */
359 abstract contract ReentrancyGuard {
360     // Booleans are more expensive than uint256 or any type that takes up a full
361     // word because each write operation emits an extra SLOAD to first read the
362     // slot's contents, replace the bits taken up by the boolean, and then write
363     // back. This is the compiler's defense against contract upgrades and
364     // pointer aliasing, and it cannot be disabled.
365 
366     // The values being non-zero value makes deployment a bit more expensive,
367     // but in exchange the refund on every call to nonReentrant will be lower in
368     // amount. Since refunds are capped to a percentage of the total
369     // transaction's gas, it is best to keep them low in cases like this one, to
370     // increase the likelihood of the full refund coming into effect.
371     uint256 private constant _NOT_ENTERED = 1;
372     uint256 private constant _ENTERED = 2;
373 
374     uint256 private _status;
375 
376     constructor() {
377         _status = _NOT_ENTERED;
378     }
379 
380     /**
381      * @dev Prevents a contract from calling itself, directly or indirectly.
382      * Calling a `nonReentrant` function from another `nonReentrant`
383      * function is not supported. It is possible to prevent this from happening
384      * by making the `nonReentrant` function external, and make it call a
385      * `private` function that does the actual work.
386      */
387     modifier nonReentrant() {
388         // On the first call to nonReentrant, _notEntered will be true
389         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
390 
391         // Any calls to nonReentrant after this point will fail
392         _status = _ENTERED;
393 
394         _;
395 
396         // By storing the original value once again, a refund is triggered (see
397         // https://eips.ethereum.org/EIPS/eip-2200)
398         _status = _NOT_ENTERED;
399     }
400 }
401 
402 
403 
404 
405 
406 
407 
408 
409 
410 
411 
412 
413 
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 
439 
440 
441 
442 
443 
444 /**
445  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
446  * @dev See https://eips.ethereum.org/EIPS/eip-721
447  */
448 interface IERC721Metadata is IERC721 {
449     /**
450      * @dev Returns the token collection name.
451      */
452     function name() external view returns (string memory);
453 
454     /**
455      * @dev Returns the token collection symbol.
456      */
457     function symbol() external view returns (string memory);
458 
459     /**
460      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
461      */
462     function tokenURI(uint256 tokenId) external view returns (string memory);
463 }
464 
465 
466 
467 
468 
469 /**
470  * @dev Collection of functions related to the address type
471  */
472 library Address {
473     /**
474      * @dev Returns true if `account` is a contract.
475      *
476      * [IMPORTANT]
477      * ====
478      * It is unsafe to assume that an address for which this function returns
479      * false is an externally-owned account (EOA) and not a contract.
480      *
481      * Among others, `isContract` will return false for the following
482      * types of addresses:
483      *
484      *  - an externally-owned account
485      *  - a contract in construction
486      *  - an address where a contract will be created
487      *  - an address where a contract lived, but was destroyed
488      * ====
489      */
490     function isContract(address account) internal view returns (bool) {
491         // This method relies on extcodesize, which returns 0 for contracts in
492         // construction, since the code is only stored at the end of the
493         // constructor execution.
494 
495         uint256 size;
496         assembly {
497             size := extcodesize(account)
498         }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * IMPORTANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         (bool success, ) = recipient.call{value: amount}("");
522         require(success, "Address: unable to send value, recipient may have reverted");
523     }
524 
525     /**
526      * @dev Performs a Solidity function call using a low level `call`. A
527      * plain `call` is an unsafe replacement for a function call: use this
528      * function instead.
529      *
530      * If `target` reverts with a revert reason, it is bubbled up by this
531      * function (like regular Solidity function calls).
532      *
533      * Returns the raw returned data. To convert to the expected return value,
534      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
535      *
536      * Requirements:
537      *
538      * - `target` must be a contract.
539      * - calling `target` with `data` must not revert.
540      *
541      * _Available since v3.1._
542      */
543     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionCall(target, data, "Address: low-level call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
549      * `errorMessage` as a fallback revert reason when `target` reverts.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(
573         address target,
574         bytes memory data,
575         uint256 value
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
582      * with `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(address(this).balance >= value, "Address: insufficient balance for call");
593         require(isContract(target), "Address: call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.call{value: value}(data);
596         return _verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
606         return functionStaticCall(target, data, "Address: low-level static call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a static call.
612      *
613      * _Available since v3.3._
614      */
615     function functionStaticCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal view returns (bytes memory) {
620         require(isContract(target), "Address: static call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.staticcall(data);
623         return _verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but performing a delegate call.
629      *
630      * _Available since v3.4._
631      */
632     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
633         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638      * but performing a delegate call.
639      *
640      * _Available since v3.4._
641      */
642     function functionDelegateCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal returns (bytes memory) {
647         require(isContract(target), "Address: delegate call to non-contract");
648 
649         (bool success, bytes memory returndata) = target.delegatecall(data);
650         return _verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     function _verifyCallResult(
654         bool success,
655         bytes memory returndata,
656         string memory errorMessage
657     ) private pure returns (bytes memory) {
658         if (success) {
659             return returndata;
660         } else {
661             // Look for revert reason and bubble it up if present
662             if (returndata.length > 0) {
663                 // The easiest way to bubble the revert reason is using memory via assembly
664 
665                 assembly {
666                     let returndata_size := mload(returndata)
667                     revert(add(32, returndata), returndata_size)
668                 }
669             } else {
670                 revert(errorMessage);
671             }
672         }
673     }
674 }
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 /**
685  * @dev Implementation of the {IERC165} interface.
686  *
687  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
688  * for the additional interface id that will be supported. For example:
689  *
690  * ```solidity
691  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
693  * }
694  * ```
695  *
696  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
697  */
698 abstract contract ERC165 is IERC165 {
699     /**
700      * @dev See {IERC165-supportsInterface}.
701      */
702     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703         return interfaceId == type(IERC165).interfaceId;
704     }
705 }
706 
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata extension, but not including the Enumerable extension, which is available separately as
711  * {ERC721Enumerable}.
712  */
713 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     using Strings for uint256;
716 
717     // Token name
718     string private _name;
719 
720     // Token symbol
721     string private _symbol;
722 
723     // Mapping from token ID to owner address
724     mapping(uint256 => address) private _owners;
725 
726     // Mapping owner address to token count
727     mapping(address => uint256) private _balances;
728 
729     // Mapping from token ID to approved address
730     mapping(uint256 => address) private _tokenApprovals;
731 
732     // Mapping from owner to operator approvals
733     mapping(address => mapping(address => bool)) private _operatorApprovals;
734 
735     /**
736      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
737      */
738     constructor(string memory name_, string memory symbol_) {
739         _name = name_;
740         _symbol = symbol_;
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC721).interfaceId ||
749             interfaceId == type(IERC721Metadata).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view virtual override returns (uint256) {
757         require(owner != address(0), "ERC721: balance query for the zero address");
758         return _balances[owner];
759     }
760 
761     /**
762      * @dev See {IERC721-ownerOf}.
763      */
764     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
765         address owner = _owners[tokenId];
766         require(owner != address(0), "ERC721: owner query for nonexistent token");
767         return owner;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-name}.
772      */
773     function name() public view virtual override returns (string memory) {
774         return _name;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-symbol}.
779      */
780     function symbol() public view virtual override returns (string memory) {
781         return _symbol;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-tokenURI}.
786      */
787     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
788         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
789 
790         string memory baseURI = _baseURI();
791         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
792     }
793 
794     /**
795      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
796      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
797      * by default, can be overriden in child contracts.
798      */
799     function _baseURI() internal view virtual returns (string memory) {
800         return "";
801     }
802 
803     /**
804      * @dev See {IERC721-approve}.
805      */
806     function approve(address to, uint256 tokenId) public virtual override {
807         address owner = ERC721.ownerOf(tokenId);
808         require(to != owner, "ERC721: approval to current owner");
809 
810         require(
811             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
812             "ERC721: approve caller is not owner nor approved for all"
813         );
814 
815         _approve(to, tokenId);
816     }
817 
818     /**
819      * @dev See {IERC721-getApproved}.
820      */
821     function getApproved(uint256 tokenId) public view virtual override returns (address) {
822         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
823 
824         return _tokenApprovals[tokenId];
825     }
826 
827     /**
828      * @dev See {IERC721-setApprovalForAll}.
829      */
830     function setApprovalForAll(address operator, bool approved) public virtual override {
831         require(operator != _msgSender(), "ERC721: approve to caller");
832 
833         _operatorApprovals[_msgSender()][operator] = approved;
834         emit ApprovalForAll(_msgSender(), operator, approved);
835     }
836 
837     /**
838      * @dev See {IERC721-isApprovedForAll}.
839      */
840     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
841         return _operatorApprovals[owner][operator];
842     }
843 
844     /**
845      * @dev See {IERC721-transferFrom}.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         //solhint-disable-next-line max-line-length
853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
854 
855         _transfer(from, to, tokenId);
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         safeTransferFrom(from, to, tokenId, "");
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) public virtual override {
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879         _safeTransfer(from, to, tokenId, _data);
880     }
881 
882     /**
883      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
884      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
885      *
886      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
887      *
888      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
889      * implement alternative mechanisms to perform token transfer, such as signature-based.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeTransfer(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) internal virtual {
906         _transfer(from, to, tokenId);
907         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      * and stop existing when they are burned (`_burn`).
917      */
918     function _exists(uint256 tokenId) internal view virtual returns (bool) {
919         return _owners[tokenId] != address(0);
920     }
921 
922     /**
923      * @dev Returns whether `spender` is allowed to manage `tokenId`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must exist.
928      */
929     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
930         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
931         address owner = ERC721.ownerOf(tokenId);
932         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
933     }
934 
935     /**
936      * @dev Safely mints `tokenId` and transfers it to `to`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must not exist.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(address to, uint256 tokenId) internal virtual {
946         _safeMint(to, tokenId, "");
947     }
948 
949     /**
950      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
951      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
952      */
953     function _safeMint(
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) internal virtual {
958         _mint(to, tokenId);
959         require(
960             _checkOnERC721Received(address(0), to, tokenId, _data),
961             "ERC721: transfer to non ERC721Receiver implementer"
962         );
963     }
964 
965     /**
966      * @dev Mints `tokenId` and transfers it to `to`.
967      *
968      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
969      *
970      * Requirements:
971      *
972      * - `tokenId` must not exist.
973      * - `to` cannot be the zero address.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _mint(address to, uint256 tokenId) internal virtual {
978         require(to != address(0), "ERC721: mint to the zero address");
979         require(!_exists(tokenId), "ERC721: token already minted");
980 
981         _beforeTokenTransfer(address(0), to, tokenId);
982 
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(address(0), to, tokenId);
987     }
988 
989     /**
990      * @dev Destroys `tokenId`.
991      * The approval is cleared when the token is burned.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _burn(uint256 tokenId) internal virtual {
1000         address owner = ERC721.ownerOf(tokenId);
1001 
1002         _beforeTokenTransfer(owner, address(0), tokenId);
1003 
1004         // Clear approvals
1005         _approve(address(0), tokenId);
1006 
1007         _balances[owner] -= 1;
1008         delete _owners[tokenId];
1009 
1010         emit Transfer(owner, address(0), tokenId);
1011     }
1012 
1013     /**
1014      * @dev Transfers `tokenId` from `from` to `to`.
1015      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _transfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) internal virtual {
1029         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1030         require(to != address(0), "ERC721: transfer to the zero address");
1031 
1032         _beforeTokenTransfer(from, to, tokenId);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId);
1036 
1037         _balances[from] -= 1;
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Approve `to` to operate on `tokenId`
1046      *
1047      * Emits a {Approval} event.
1048      */
1049     function _approve(address to, uint256 tokenId) internal virtual {
1050         _tokenApprovals[tokenId] = to;
1051         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         if (to.isContract()) {
1071             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1072                 return retval == IERC721Receiver(to).onERC721Received.selector;
1073             } catch (bytes memory reason) {
1074                 if (reason.length == 0) {
1075                     revert("ERC721: transfer to non ERC721Receiver implementer");
1076                 } else {
1077                     assembly {
1078                         revert(add(32, reason), mload(reason))
1079                     }
1080                 }
1081             }
1082         } else {
1083             return true;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 }
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 /**
1115  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1116  * @dev See https://eips.ethereum.org/EIPS/eip-721
1117  */
1118 interface IERC721Enumerable is IERC721 {
1119     /**
1120      * @dev Returns the total amount of tokens stored by the contract.
1121      */
1122     function totalSupply() external view returns (uint256);
1123 
1124     /**
1125      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1126      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1127      */
1128     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1129 
1130     /**
1131      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1132      * Use along with {totalSupply} to enumerate all tokens.
1133      */
1134     function tokenByIndex(uint256 index) external view returns (uint256);
1135 }
1136 
1137 
1138 /**
1139  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1140  * enumerability of all the token ids in the contract as well as all token ids owned by each
1141  * account.
1142  */
1143 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1144     // Mapping from owner to list of owned token IDs
1145     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1146 
1147     // Mapping from token ID to index of the owner tokens list
1148     mapping(uint256 => uint256) private _ownedTokensIndex;
1149 
1150     // Array with all token ids, used for enumeration
1151     uint256[] private _allTokens;
1152 
1153     // Mapping from token id to position in the allTokens array
1154     mapping(uint256 => uint256) private _allTokensIndex;
1155     
1156     /**
1157      * @dev See {IERC165-supportsInterface}.
1158      */
1159     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1160         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1165      */
1166     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1167         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1168         return _ownedTokens[owner][index];
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-totalSupply}.
1173      */
1174     function totalSupply() public view virtual override returns (uint256) {
1175         return _allTokens.length;
1176     }
1177 
1178     /**
1179      * @dev See {IERC721Enumerable-tokenByIndex}.
1180      */
1181     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1182         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1183         return _allTokens[index];
1184     }
1185 
1186     /**
1187      * @dev Hook that is called before any token transfer. This includes minting
1188      * and burning.
1189      *
1190      * Calling conditions:
1191      *
1192      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1193      * transferred to `to`.
1194      * - When `from` is zero, `tokenId` will be minted for `to`.
1195      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1196      * - `from` cannot be the zero address.
1197      * - `to` cannot be the zero address.
1198      *
1199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1200      */
1201     function _beforeTokenTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual override {
1206         super._beforeTokenTransfer(from, to, tokenId);
1207 
1208         if (from == address(0)) {
1209             _addTokenToAllTokensEnumeration(tokenId);
1210         } else if (from != to) {
1211             _removeTokenFromOwnerEnumeration(from, tokenId);
1212         }
1213         if (to == address(0)) {
1214             _removeTokenFromAllTokensEnumeration(tokenId);
1215         } else if (to != from) {
1216             _addTokenToOwnerEnumeration(to, tokenId);
1217         }
1218     }
1219 
1220     /**
1221      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1222      * @param to address representing the new owner of the given token ID
1223      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1224      */
1225     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1226         uint256 length = ERC721.balanceOf(to);
1227         _ownedTokens[to][length] = tokenId;
1228         _ownedTokensIndex[tokenId] = length;
1229     }
1230 
1231     /**
1232      * @dev Private function to add a token to this extension's token tracking data structures.
1233      * @param tokenId uint256 ID of the token to be added to the tokens list
1234      */
1235     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1236         _allTokensIndex[tokenId] = _allTokens.length;
1237         _allTokens.push(tokenId);
1238     }
1239 
1240     /**
1241      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1242      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1243      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1244      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1245      * @param from address representing the previous owner of the given token ID
1246      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1247      */
1248     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1249         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1250         // then delete the last slot (swap and pop).
1251 
1252         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1253         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1254 
1255         // When the token to delete is the last token, the swap operation is unnecessary
1256         if (tokenIndex != lastTokenIndex) {
1257             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1258 
1259             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1260             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1261         }
1262 
1263         // This also deletes the contents at the last position of the array
1264         delete _ownedTokensIndex[tokenId];
1265         delete _ownedTokens[from][lastTokenIndex];
1266     }
1267 
1268     /**
1269      * @dev Private function to remove a token from this extension's token tracking data structures.
1270      * This has O(1) time complexity, but alters the order of the _allTokens array.
1271      * @param tokenId uint256 ID of the token to be removed from the tokens list
1272      */
1273     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1274         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1275         // then delete the last slot (swap and pop).
1276 
1277         uint256 lastTokenIndex = _allTokens.length - 1;
1278         uint256 tokenIndex = _allTokensIndex[tokenId];
1279 
1280         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1281         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1282         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1283         uint256 lastTokenId = _allTokens[lastTokenIndex];
1284 
1285         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1286         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1287 
1288         // This also deletes the contents at the last position of the array
1289         delete _allTokensIndex[tokenId];
1290         _allTokens.pop();
1291     }
1292 }
1293 
1294 
1295 contract pLoot is ERC721Enumerable, ReentrancyGuard, Ownable {
1296     
1297     //ddddToken address
1298     address ddddToken = address(0x8cA9a0fbd8DB501F013F2e9e33a1B9dC129A48E0);
1299     
1300     // claim times
1301     mapping(address => uint256) public _claimTimes;
1302     
1303     //global token id
1304     uint256 _globalTokenId = 16001;
1305     
1306     receive() external payable {
1307         claim();
1308     }
1309 
1310     string[] private weapons = [
1311         "Warhammer",
1312         "Quarterstaff",
1313         "Maul",
1314         "Mace",
1315         "Club",
1316         "Katana",
1317         "Falchion",
1318         "Scimitar",
1319         "Long Sword",
1320         "Short Sword",
1321         "Ghost Wand",
1322         "Grave Wand",
1323         "Bone Wand",
1324         "Wand",
1325         "Grimoire",
1326         "Chronicle",
1327         "Tome",
1328         "Book"
1329     ];
1330     
1331     string[] private chestArmor = [
1332         "Divine Robe",
1333         "Silk Robe",
1334         "Linen Robe",
1335         "Robe",
1336         "Shirt",
1337         "Demon Husk",
1338         "Dragonskin Armor",
1339         "Studded Leather Armor",
1340         "Hard Leather Armor",
1341         "Leather Armor",
1342         "Holy Chestplate",
1343         "Ornate Chestplate",
1344         "Plate Mail",
1345         "Chain Mail",
1346         "Ring Mail"
1347     ];
1348     
1349     string[] private headArmor = [
1350         "Ancient Helm",
1351         "Ornate Helm",
1352         "Great Helm",
1353         "Full Helm",
1354         "Helm",
1355         "Demon Crown",
1356         "Dragon's Crown",
1357         "War Cap",
1358         "Leather Cap",
1359         "Cap",
1360         "Crown",
1361         "Divine Hood",
1362         "Silk Hood",
1363         "Linen Hood",
1364         "Hood"
1365     ];
1366     
1367     string[] private waistArmor = [
1368         "Ornate Belt",
1369         "War Belt",
1370         "Plated Belt",
1371         "Mesh Belt",
1372         "Heavy Belt",
1373         "Demonhide Belt",
1374         "Dragonskin Belt",
1375         "Studded Leather Belt",
1376         "Hard Leather Belt",
1377         "Leather Belt",
1378         "Brightsilk Sash",
1379         "Silk Sash",
1380         "Wool Sash",
1381         "Linen Sash",
1382         "Sash"
1383     ];
1384     
1385     string[] private footArmor = [
1386         "Holy Greaves",
1387         "Ornate Greaves",
1388         "Greaves",
1389         "Chain Boots",
1390         "Heavy Boots",
1391         "Demonhide Boots",
1392         "Dragonskin Boots",
1393         "Studded Leather Boots",
1394         "Hard Leather Boots",
1395         "Leather Boots",
1396         "Divine Slippers",
1397         "Silk Slippers",
1398         "Wool Shoes",
1399         "Linen Shoes",
1400         "Shoes"
1401     ];
1402     
1403     string[] private handArmor = [
1404         "Holy Gauntlets",
1405         "Ornate Gauntlets",
1406         "Gauntlets",
1407         "Chain Gloves",
1408         "Heavy Gloves",
1409         "Demon's Hands",
1410         "Dragonskin Gloves",
1411         "Studded Leather Gloves",
1412         "Hard Leather Gloves",
1413         "Leather Gloves",
1414         "Divine Gloves",
1415         "Silk Gloves",
1416         "Wool Gloves",
1417         "Linen Gloves",
1418         "Gloves"
1419     ];
1420     
1421     string[] private necklaces = [
1422         "Necklace",
1423         "Amulet",
1424         "Pendant"
1425     ];
1426     
1427     string[] private rings = [
1428         "Gold Ring",
1429         "Silver Ring",
1430         "Bronze Ring",
1431         "Platinum Ring",
1432         "Titanium Ring"
1433     ];
1434     
1435     string[] private suffixes = [
1436         "of Power",
1437         "of Giants",
1438         "of Titans",
1439         "of Skill",
1440         "of Perfection",
1441         "of Brilliance",
1442         "of Enlightenment",
1443         "of Protection",
1444         "of Anger",
1445         "of Rage",
1446         "of Fury",
1447         "of Vitriol",
1448         "of the Fox",
1449         "of Detection",
1450         "of Reflection",
1451         "of the Twins"
1452     ];
1453     
1454     string[] private namePrefixes = [
1455         "Agony", "Apocalypse", "Armageddon", "Beast", "Behemoth", "Blight", "Blood", "Bramble", 
1456         "Brimstone", "Brood", "Carrion", "Cataclysm", "Chimeric", "Corpse", "Corruption", "Damnation", 
1457         "Death", "Demon", "Dire", "Dragon", "Dread", "Doom", "Dusk", "Eagle", "Empyrean", "Fate", "Foe", 
1458         "Gale", "Ghoul", "Gloom", "Glyph", "Golem", "Grim", "Hate", "Havoc", "Honour", "Horror", "Hypnotic", 
1459         "Kraken", "Loath", "Maelstrom", "Mind", "Miracle", "Morbid", "Oblivion", "Onslaught", "Pain", 
1460         "Pandemonium", "Phoenix", "Plague", "Rage", "Rapture", "Rune", "Skull", "Sol", "Soul", "Sorrow", 
1461         "Spirit", "Storm", "Tempest", "Torment", "Vengeance", "Victory", "Viper", "Vortex", "Woe", "Wrath",
1462         "Light's", "Shimmering"  
1463     ];
1464     
1465     string[] private nameSuffixes = [
1466         "Bane",
1467         "Root",
1468         "Bite",
1469         "Song",
1470         "Roar",
1471         "Grasp",
1472         "Instrument",
1473         "Glow",
1474         "Bender",
1475         "Shadow",
1476         "Whisper",
1477         "Shout",
1478         "Growl",
1479         "Tear",
1480         "Peak",
1481         "Form",
1482         "Sun",
1483         "Moon"
1484     ];
1485     
1486     function random(string memory input) internal pure returns (uint256) {
1487         return uint256(keccak256(abi.encodePacked(input)));
1488     }
1489     
1490     function getWeapon(uint256 tokenId) public view returns (string memory) {
1491         return pluck(tokenId, "WEAPON", weapons);
1492     }
1493     
1494     function getChest(uint256 tokenId) public view returns (string memory) {
1495         return pluck(tokenId, "CHEST", chestArmor);
1496     }
1497     
1498     function getHead(uint256 tokenId) public view returns (string memory) {
1499         return pluck(tokenId, "HEAD", headArmor);
1500     }
1501     
1502     function getWaist(uint256 tokenId) public view returns (string memory) {
1503         return pluck(tokenId, "WAIST", waistArmor);
1504     }
1505 
1506     function getFoot(uint256 tokenId) public view returns (string memory) {
1507         return pluck(tokenId, "FOOT", footArmor);
1508     }
1509     
1510     function getHand(uint256 tokenId) public view returns (string memory) {
1511         return pluck(tokenId, "HAND", handArmor);
1512     }
1513     
1514     function getNeck(uint256 tokenId) public view returns (string memory) {
1515         return pluck(tokenId, "NECK", necklaces);
1516     }
1517     
1518     function getRing(uint256 tokenId) public view returns (string memory) {
1519         return pluck(tokenId, "RING", rings);
1520     }
1521     
1522     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1523         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1524         string memory output = sourceArray[rand % sourceArray.length];
1525         uint256 greatness = rand % 21;
1526         if (greatness > 14) {
1527             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1528         }
1529         if (greatness >= 19) {
1530             string[2] memory name;
1531             name[0] = namePrefixes[rand % namePrefixes.length];
1532             name[1] = nameSuffixes[rand % nameSuffixes.length];
1533             if (greatness == 19) {
1534                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1535             } else {
1536                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1537             }
1538         }
1539         return output;
1540     }
1541 
1542     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1543         string[17] memory parts;
1544         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1545 
1546         parts[1] = getWeapon(tokenId);
1547 
1548         parts[2] = '</text><text x="10" y="40" class="base">';
1549 
1550         parts[3] = getChest(tokenId);
1551 
1552         parts[4] = '</text><text x="10" y="60" class="base">';
1553 
1554         parts[5] = getHead(tokenId);
1555 
1556         parts[6] = '</text><text x="10" y="80" class="base">';
1557 
1558         parts[7] = getWaist(tokenId);
1559 
1560         parts[8] = '</text><text x="10" y="100" class="base">';
1561 
1562         parts[9] = getFoot(tokenId);
1563 
1564         parts[10] = '</text><text x="10" y="120" class="base">';
1565 
1566         parts[11] = getHand(tokenId);
1567 
1568         parts[12] = '</text><text x="10" y="140" class="base">';
1569 
1570         parts[13] = getNeck(tokenId);
1571 
1572         parts[14] = '</text><text x="10" y="160" class="base">';
1573 
1574         parts[15] = getRing(tokenId);
1575 
1576         parts[16] = '</text></svg>';
1577 
1578         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1579         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1580         
1581         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "There was one maverick punk girl, in order to show the world what real Punk was, she sacrificed herself to the God. Her body was gone, but her fiery spirit remained and became the Goddess of Punk. 173 trailblazers were inspired by her deed and swore to be her first apostles. They called themselves the People\'s Punks and devoted their lives proselytizing. The Word called on them from all over the world to assemble in the Punk Valley. They established the Punk Camp, and, with the Spirit of the Goddess of Punk, forged invaluable weapons, armors, and other items, to which the name the pLoot was given.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1582         output = string(abi.encodePacked('data:application/json;base64,', json));
1583 
1584         return output;
1585     }
1586 
1587     function claim() public nonReentrant {
1588         require(_globalTokenId < 24001, "Token ID invalid");
1589         uint256 times = _claimTimes[msg.sender];
1590         uint256 ddddAmount = IERC721(ddddToken).balanceOf(msg.sender);
1591         require (times < 1 || (ddddAmount >= 4000000e18 && times < 5) || (ddddAmount < 4000000e18 && ddddAmount >= 400000e18 && times < 3) ||  (ddddAmount < 400000e18 && ddddAmount >= 40000e18 && times < 2 ) , "invalid claim times");
1592         _safeMint(_msgSender(), _globalTokenId);
1593         _globalTokenId++;
1594         _claimTimes[msg.sender] = ++times;
1595     }
1596     
1597     // function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1598     //     require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
1599     //     _safeMint(owner(), tokenId);
1600     // }
1601     
1602     function toString(uint256 value) internal pure returns (string memory) {
1603     // Inspired by OraclizeAPI's implementation - MIT license
1604     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1605 
1606         if (value == 0) {
1607             return "0";
1608         }
1609         uint256 temp = value;
1610         uint256 digits;
1611         while (temp != 0) {
1612             digits++;
1613             temp /= 10;
1614         }
1615         bytes memory buffer = new bytes(digits);
1616         while (value != 0) {
1617             digits -= 1;
1618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1619             value /= 10;
1620         }
1621         return string(buffer);
1622     }
1623     
1624     constructor() ERC721("pLOOT", "pLOOT") Ownable() {}
1625 }
1626 
1627 /// [MIT License]
1628 /// @title Base64
1629 /// @notice Provides a function for encoding some bytes in base64
1630 /// @author Brecht Devos <brecht@loopring.org>
1631 library Base64 {
1632     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1633 
1634     /// @notice Encodes some bytes to the base64 representation
1635     function encode(bytes memory data) internal pure returns (string memory) {
1636         uint256 len = data.length;
1637         if (len == 0) return "";
1638 
1639         // multiply by 4/3 rounded up
1640         uint256 encodedLen = 4 * ((len + 2) / 3);
1641 
1642         // Add some extra buffer at the end
1643         bytes memory result = new bytes(encodedLen + 32);
1644 
1645         bytes memory table = TABLE;
1646 
1647         assembly {
1648             let tablePtr := add(table, 1)
1649             let resultPtr := add(result, 32)
1650 
1651             for {
1652                 let i := 0
1653             } lt(i, len) {
1654 
1655             } {
1656                 i := add(i, 3)
1657                 let input := and(mload(add(data, i)), 0xffffff)
1658 
1659                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1660                 out := shl(8, out)
1661                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1662                 out := shl(8, out)
1663                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1664                 out := shl(8, out)
1665                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1666                 out := shl(224, out)
1667 
1668                 mstore(resultPtr, out)
1669 
1670                 resultPtr := add(resultPtr, 4)
1671             }
1672 
1673             switch mod(len, 3)
1674             case 1 {
1675                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1676             }
1677             case 2 {
1678                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1679             }
1680 
1681             mstore(result, encodedLen)
1682         }
1683 
1684         return string(result);
1685     }
1686 }