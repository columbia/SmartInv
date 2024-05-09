1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 
32 
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 
174 
175 /**
176  * @dev String operations.
177  */
178 library Strings {
179     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
183      */
184     function toString(uint256 value) internal pure returns (string memory) {
185         // Inspired by OraclizeAPI's implementation - MIT licence
186         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
187 
188         if (value == 0) {
189             return "0";
190         }
191         uint256 temp = value;
192         uint256 digits;
193         while (temp != 0) {
194             digits++;
195             temp /= 10;
196         }
197         bytes memory buffer = new bytes(digits);
198         while (value != 0) {
199             digits -= 1;
200             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
201             value /= 10;
202         }
203         return string(buffer);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
208      */
209     function toHexString(uint256 value) internal pure returns (string memory) {
210         if (value == 0) {
211             return "0x00";
212         }
213         uint256 temp = value;
214         uint256 length = 0;
215         while (temp != 0) {
216             length++;
217             temp >>= 8;
218         }
219         return toHexString(value, length);
220     }
221 
222     /**
223      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
224      */
225     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
226         bytes memory buffer = new bytes(2 * length + 2);
227         buffer[0] = "0";
228         buffer[1] = "x";
229         for (uint256 i = 2 * length + 1; i > 1; --i) {
230             buffer[i] = _HEX_SYMBOLS[value & 0xf];
231             value >>= 4;
232         }
233         require(value == 0, "Strings: hex length insufficient");
234         return string(buffer);
235     }
236 }
237 
238 
239 
240 
241 /*
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 
262 
263 
264 
265 
266 
267 
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor() {
290         _setOwner(_msgSender());
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305         _;
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public virtual onlyOwner {
316         _setOwner(address(0));
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         _setOwner(newOwner);
326     }
327 
328     function _setOwner(address newOwner) private {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 
336 
337 
338 
339 /**
340  * @dev Contract module that helps prevent reentrant calls to a function.
341  *
342  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
343  * available, which can be applied to functions to make sure there are no nested
344  * (reentrant) calls to them.
345  *
346  * Note that because there is a single `nonReentrant` guard, functions marked as
347  * `nonReentrant` may not call one another. This can be worked around by making
348  * those functions `private`, and then adding `external` `nonReentrant` entry
349  * points to them.
350  *
351  * TIP: If you would like to learn more about reentrancy and alternative ways
352  * to protect against it, check out our blog post
353  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
354  */
355 abstract contract ReentrancyGuard {
356     // Booleans are more expensive than uint256 or any type that takes up a full
357     // word because each write operation emits an extra SLOAD to first read the
358     // slot's contents, replace the bits taken up by the boolean, and then write
359     // back. This is the compiler's defense against contract upgrades and
360     // pointer aliasing, and it cannot be disabled.
361 
362     // The values being non-zero value makes deployment a bit more expensive,
363     // but in exchange the refund on every call to nonReentrant will be lower in
364     // amount. Since refunds are capped to a percentage of the total
365     // transaction's gas, it is best to keep them low in cases like this one, to
366     // increase the likelihood of the full refund coming into effect.
367     uint256 private constant _NOT_ENTERED = 1;
368     uint256 private constant _ENTERED = 2;
369 
370     uint256 private _status;
371 
372     constructor() {
373         _status = _NOT_ENTERED;
374     }
375 
376     /**
377      * @dev Prevents a contract from calling itself, directly or indirectly.
378      * Calling a `nonReentrant` function from another `nonReentrant`
379      * function is not supported. It is possible to prevent this from happening
380      * by making the `nonReentrant` function external, and make it call a
381      * `private` function that does the actual work.
382      */
383     modifier nonReentrant() {
384         // On the first call to nonReentrant, _notEntered will be true
385         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
386 
387         // Any calls to nonReentrant after this point will fail
388         _status = _ENTERED;
389 
390         _;
391 
392         // By storing the original value once again, a refund is triggered (see
393         // https://eips.ethereum.org/EIPS/eip-2200)
394         _status = _NOT_ENTERED;
395     }
396 }
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
410 
411 /**
412  * @title ERC721 token receiver interface
413  * @dev Interface for any contract that wants to support safeTransfers
414  * from ERC721 asset contracts.
415  */
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 
435 
436 
437 
438 
439 
440 /**
441  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
442  * @dev See https://eips.ethereum.org/EIPS/eip-721
443  */
444 interface IERC721Metadata is IERC721 {
445     /**
446      * @dev Returns the token collection name.
447      */
448     function name() external view returns (string memory);
449 
450     /**
451      * @dev Returns the token collection symbol.
452      */
453     function symbol() external view returns (string memory);
454 
455     /**
456      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
457      */
458     function tokenURI(uint256 tokenId) external view returns (string memory);
459 }
460 
461 
462 
463 
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain `call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(data);
592         return _verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
602         return functionStaticCall(target, data, "Address: low-level static call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return _verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         require(isContract(target), "Address: delegate call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.delegatecall(data);
646         return _verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     function _verifyCallResult(
650         bool success,
651         bytes memory returndata,
652         string memory errorMessage
653     ) private pure returns (bytes memory) {
654         if (success) {
655             return returndata;
656         } else {
657             // Look for revert reason and bubble it up if present
658             if (returndata.length > 0) {
659                 // The easiest way to bubble the revert reason is using memory via assembly
660 
661                 assembly {
662                     let returndata_size := mload(returndata)
663                     revert(add(32, returndata), returndata_size)
664                 }
665             } else {
666                 revert(errorMessage);
667             }
668         }
669     }
670 }
671 
672 
673 
674 
675 
676 
677 
678 
679 
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata extension, but not including the Enumerable extension, which is available separately as
707  * {ERC721Enumerable}.
708  */
709 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     using Strings for uint256;
712 
713     // Token name
714     string private _name;
715 
716     // Token symbol
717     string private _symbol;
718 
719     // Mapping from token ID to owner address
720     mapping(uint256 => address) private _owners;
721 
722     // Mapping owner address to token count
723     mapping(address => uint256) private _balances;
724 
725     // Mapping from token ID to approved address
726     mapping(uint256 => address) private _tokenApprovals;
727 
728     // Mapping from owner to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     /**
732      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
733      */
734     constructor(string memory name_, string memory symbol_) {
735         _name = name_;
736         _symbol = symbol_;
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
743         return
744             interfaceId == type(IERC721).interfaceId ||
745             interfaceId == type(IERC721Metadata).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view virtual override returns (uint256) {
753         require(owner != address(0), "ERC721: balance query for the zero address");
754         return _balances[owner];
755     }
756 
757     /**
758      * @dev See {IERC721-ownerOf}.
759      */
760     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
761         address owner = _owners[tokenId];
762         require(owner != address(0), "ERC721: owner query for nonexistent token");
763         return owner;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-name}.
768      */
769     function name() public view virtual override returns (string memory) {
770         return _name;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-symbol}.
775      */
776     function symbol() public view virtual override returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-tokenURI}.
782      */
783     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
784         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
785 
786         string memory baseURI = _baseURI();
787         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
788     }
789 
790     /**
791      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
792      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
793      * by default, can be overriden in child contracts.
794      */
795     function _baseURI() internal view virtual returns (string memory) {
796         return "";
797     }
798 
799     /**
800      * @dev See {IERC721-approve}.
801      */
802     function approve(address to, uint256 tokenId) public virtual override {
803         address owner = ERC721.ownerOf(tokenId);
804         require(to != owner, "ERC721: approval to current owner");
805 
806         require(
807             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
808             "ERC721: approve caller is not owner nor approved for all"
809         );
810 
811         _approve(to, tokenId);
812     }
813 
814     /**
815      * @dev See {IERC721-getApproved}.
816      */
817     function getApproved(uint256 tokenId) public view virtual override returns (address) {
818         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
819 
820         return _tokenApprovals[tokenId];
821     }
822 
823     /**
824      * @dev See {IERC721-setApprovalForAll}.
825      */
826     function setApprovalForAll(address operator, bool approved) public virtual override {
827         require(operator != _msgSender(), "ERC721: approve to caller");
828 
829         _operatorApprovals[_msgSender()][operator] = approved;
830         emit ApprovalForAll(_msgSender(), operator, approved);
831     }
832 
833     /**
834      * @dev See {IERC721-isApprovedForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev See {IERC721-transferFrom}.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         //solhint-disable-next-line max-line-length
849         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
850 
851         _transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         safeTransferFrom(from, to, tokenId, "");
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) public virtual override {
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
875         _safeTransfer(from, to, tokenId, _data);
876     }
877 
878     /**
879      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
880      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
881      *
882      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
883      *
884      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
885      * implement alternative mechanisms to perform token transfer, such as signature-based.
886      *
887      * Requirements:
888      *
889      * - `from` cannot be the zero address.
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must exist and be owned by `from`.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _safeTransfer(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) internal virtual {
902         _transfer(from, to, tokenId);
903         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
904     }
905 
906     /**
907      * @dev Returns whether `tokenId` exists.
908      *
909      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
910      *
911      * Tokens start existing when they are minted (`_mint`),
912      * and stop existing when they are burned (`_burn`).
913      */
914     function _exists(uint256 tokenId) internal view virtual returns (bool) {
915         return _owners[tokenId] != address(0);
916     }
917 
918     /**
919      * @dev Returns whether `spender` is allowed to manage `tokenId`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
926         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
927         address owner = ERC721.ownerOf(tokenId);
928         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
929     }
930 
931     /**
932      * @dev Safely mints `tokenId` and transfers it to `to`.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must not exist.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeMint(address to, uint256 tokenId) internal virtual {
942         _safeMint(to, tokenId, "");
943     }
944 
945     /**
946      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
947      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
948      */
949     function _safeMint(
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _mint(to, tokenId);
955         require(
956             _checkOnERC721Received(address(0), to, tokenId, _data),
957             "ERC721: transfer to non ERC721Receiver implementer"
958         );
959     }
960 
961     /**
962      * @dev Mints `tokenId` and transfers it to `to`.
963      *
964      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
965      *
966      * Requirements:
967      *
968      * - `tokenId` must not exist.
969      * - `to` cannot be the zero address.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _mint(address to, uint256 tokenId) internal virtual {
974         require(to != address(0), "ERC721: mint to the zero address");
975         require(!_exists(tokenId), "ERC721: token already minted");
976 
977         _beforeTokenTransfer(address(0), to, tokenId);
978 
979         _balances[to] += 1;
980         _owners[tokenId] = to;
981 
982         emit Transfer(address(0), to, tokenId);
983     }
984 
985     /**
986      * @dev Destroys `tokenId`.
987      * The approval is cleared when the token is burned.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _burn(uint256 tokenId) internal virtual {
996         address owner = ERC721.ownerOf(tokenId);
997 
998         _beforeTokenTransfer(owner, address(0), tokenId);
999 
1000         // Clear approvals
1001         _approve(address(0), tokenId);
1002 
1003         _balances[owner] -= 1;
1004         delete _owners[tokenId];
1005 
1006         emit Transfer(owner, address(0), tokenId);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {
1025         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1026         require(to != address(0), "ERC721: transfer to the zero address");
1027 
1028         _beforeTokenTransfer(from, to, tokenId);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId);
1032 
1033         _balances[from] -= 1;
1034         _balances[to] += 1;
1035         _owners[tokenId] = to;
1036 
1037         emit Transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev Approve `to` to operate on `tokenId`
1042      *
1043      * Emits a {Approval} event.
1044      */
1045     function _approve(address to, uint256 tokenId) internal virtual {
1046         _tokenApprovals[tokenId] = to;
1047         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver(to).onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert("ERC721: transfer to non ERC721Receiver implementer");
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 }
1103 
1104 
1105 
1106 
1107 
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115     /**
1116      * @dev Returns the total amount of tokens stored by the contract.
1117      */
1118     function totalSupply() external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1122      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1125 
1126     /**
1127      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1128      * Use along with {totalSupply} to enumerate all tokens.
1129      */
1130     function tokenByIndex(uint256 index) external view returns (uint256);
1131 }
1132 
1133 
1134 /**
1135  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1136  * enumerability of all the token ids in the contract as well as all token ids owned by each
1137  * account.
1138  */
1139 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1140     // Mapping from owner to list of owned token IDs
1141     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1142 
1143     // Mapping from token ID to index of the owner tokens list
1144     mapping(uint256 => uint256) private _ownedTokensIndex;
1145 
1146     // Array with all token ids, used for enumeration
1147     uint256[] private _allTokens;
1148 
1149     // Mapping from token id to position in the allTokens array
1150     mapping(uint256 => uint256) private _allTokensIndex;
1151 
1152     /**
1153      * @dev See {IERC165-supportsInterface}.
1154      */
1155     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1156         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1161      */
1162     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1163         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1164         return _ownedTokens[owner][index];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Enumerable-totalSupply}.
1169      */
1170     function totalSupply() public view virtual override returns (uint256) {
1171         return _allTokens.length;
1172     }
1173 
1174     /**
1175      * @dev See {IERC721Enumerable-tokenByIndex}.
1176      */
1177     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1178         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1179         return _allTokens[index];
1180     }
1181 
1182     /**
1183      * @dev Hook that is called before any token transfer. This includes minting
1184      * and burning.
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` will be minted for `to`.
1191      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1192      * - `from` cannot be the zero address.
1193      * - `to` cannot be the zero address.
1194      *
1195      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1196      */
1197     function _beforeTokenTransfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) internal virtual override {
1202         super._beforeTokenTransfer(from, to, tokenId);
1203 
1204         if (from == address(0)) {
1205             _addTokenToAllTokensEnumeration(tokenId);
1206         } else if (from != to) {
1207             _removeTokenFromOwnerEnumeration(from, tokenId);
1208         }
1209         if (to == address(0)) {
1210             _removeTokenFromAllTokensEnumeration(tokenId);
1211         } else if (to != from) {
1212             _addTokenToOwnerEnumeration(to, tokenId);
1213         }
1214     }
1215 
1216     /**
1217      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1218      * @param to address representing the new owner of the given token ID
1219      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1220      */
1221     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1222         uint256 length = ERC721.balanceOf(to);
1223         _ownedTokens[to][length] = tokenId;
1224         _ownedTokensIndex[tokenId] = length;
1225     }
1226 
1227     /**
1228      * @dev Private function to add a token to this extension's token tracking data structures.
1229      * @param tokenId uint256 ID of the token to be added to the tokens list
1230      */
1231     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1232         _allTokensIndex[tokenId] = _allTokens.length;
1233         _allTokens.push(tokenId);
1234     }
1235 
1236     /**
1237      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1238      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1239      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1240      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1241      * @param from address representing the previous owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1243      */
1244     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1245         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1246         // then delete the last slot (swap and pop).
1247 
1248         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1249         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1250 
1251         // When the token to delete is the last token, the swap operation is unnecessary
1252         if (tokenIndex != lastTokenIndex) {
1253             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1254 
1255             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1256             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1257         }
1258 
1259         // This also deletes the contents at the last position of the array
1260         delete _ownedTokensIndex[tokenId];
1261         delete _ownedTokens[from][lastTokenIndex];
1262     }
1263 
1264     /**
1265      * @dev Private function to remove a token from this extension's token tracking data structures.
1266      * This has O(1) time complexity, but alters the order of the _allTokens array.
1267      * @param tokenId uint256 ID of the token to be removed from the tokens list
1268      */
1269     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1270         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1271         // then delete the last slot (swap and pop).
1272 
1273         uint256 lastTokenIndex = _allTokens.length - 1;
1274         uint256 tokenIndex = _allTokensIndex[tokenId];
1275 
1276         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1277         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1278         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1279         uint256 lastTokenId = _allTokens[lastTokenIndex];
1280 
1281         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1282         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1283 
1284         // This also deletes the contents at the last position of the array
1285         delete _allTokensIndex[tokenId];
1286         _allTokens.pop();
1287     }
1288 }
1289 
1290 
1291 contract TemporalLoot is ERC721Enumerable, ReentrancyGuard, Ownable {
1292 
1293         string[] private weapons = [
1294         "Warhammer",
1295         "Quarterstaff",
1296         "Maul",
1297         "Mace",
1298         "Club",
1299         "Katana",
1300         "Falchion",
1301         "Scimitar",
1302         "Long Sword",
1303         "Short Sword",
1304         "Ghost Wand",
1305         "Grave Wand",
1306         "Bone Wand",
1307         "Wand",
1308         "Grimoire",
1309         "Chronicle",
1310         "Tome",
1311         "Book"
1312     ];
1313     
1314     string[] private chestArmor = [
1315         "Divine Robe",
1316         "Silk Robe",
1317         "Linen Robe",
1318         "Robe",
1319         "Shirt",
1320         "Demon Husk",
1321         "Dragonskin Armor",
1322         "Studded Leather Armor",
1323         "Hard Leather Armor",
1324         "Leather Armor",
1325         "Holy Chestplate",
1326         "Ornate Chestplate",
1327         "Plate Mail",
1328         "Chain Mail",
1329         "Ring Mail"
1330     ];
1331     
1332     string[] private headArmor = [
1333         "Ancient Helm",
1334         "Ornate Helm",
1335         "Great Helm",
1336         "Full Helm",
1337         "Helm",
1338         "Demon Crown",
1339         "Dragon's Crown",
1340         "War Cap",
1341         "Leather Cap",
1342         "Cap",
1343         "Crown",
1344         "Divine Hood",
1345         "Silk Hood",
1346         "Linen Hood",
1347         "Hood"
1348     ];
1349     
1350     string[] private waistArmor = [
1351         "Ornate Belt",
1352         "War Belt",
1353         "Plated Belt",
1354         "Mesh Belt",
1355         "Heavy Belt",
1356         "Demonhide Belt",
1357         "Dragonskin Belt",
1358         "Studded Leather Belt",
1359         "Hard Leather Belt",
1360         "Leather Belt",
1361         "Brightsilk Sash",
1362         "Silk Sash",
1363         "Wool Sash",
1364         "Linen Sash",
1365         "Sash"
1366     ];
1367     
1368     string[] private footArmor = [
1369         "Holy Greaves",
1370         "Ornate Greaves",
1371         "Greaves",
1372         "Chain Boots",
1373         "Heavy Boots",
1374         "Demonhide Boots",
1375         "Dragonskin Boots",
1376         "Studded Leather Boots",
1377         "Hard Leather Boots",
1378         "Leather Boots",
1379         "Divine Slippers",
1380         "Silk Slippers",
1381         "Wool Shoes",
1382         "Linen Shoes",
1383         "Shoes"
1384     ];
1385     
1386     string[] private handArmor = [
1387         "Holy Gauntlets",
1388         "Ornate Gauntlets",
1389         "Gauntlets",
1390         "Chain Gloves",
1391         "Heavy Gloves",
1392         "Demon's Hands",
1393         "Dragonskin Gloves",
1394         "Studded Leather Gloves",
1395         "Hard Leather Gloves",
1396         "Leather Gloves",
1397         "Divine Gloves",
1398         "Silk Gloves",
1399         "Wool Gloves",
1400         "Linen Gloves",
1401         "Gloves"
1402     ];
1403     
1404     string[] private necklaces = [
1405         "Necklace",
1406         "Amulet",
1407         "Pendant"
1408     ];
1409     
1410     string[] private rings = [
1411         "Gold Ring",
1412         "Silver Ring",
1413         "Bronze Ring",
1414         "Platinum Ring",
1415         "Titanium Ring"
1416     ];
1417     
1418     string[] private suffixes = [
1419         "of Power",
1420         "of Giants",
1421         "of Titans",
1422         "of Skill",
1423         "of Perfection",
1424         "of Brilliance",
1425         "of Enlightenment",
1426         "of Protection",
1427         "of Anger",
1428         "of Rage",
1429         "of Fury",
1430         "of Vitriol",
1431         "of the Fox",
1432         "of Detection",
1433         "of Reflection",
1434         "of the Twins"
1435     ];
1436     
1437     string[] private namePrefixes = [
1438         "Agony", "Apocalypse", "Armageddon", "Beast", "Behemoth", "Blight", "Blood", "Bramble", 
1439         "Brimstone", "Brood", "Carrion", "Cataclysm", "Chimeric", "Corpse", "Corruption", "Damnation", 
1440         "Death", "Demon", "Dire", "Dragon", "Dread", "Doom", "Dusk", "Eagle", "Empyrean", "Fate", "Foe", 
1441         "Gale", "Ghoul", "Gloom", "Glyph", "Golem", "Grim", "Hate", "Havoc", "Honour", "Horror", "Hypnotic", 
1442         "Kraken", "Loath", "Maelstrom", "Mind", "Miracle", "Morbid", "Oblivion", "Onslaught", "Pain", 
1443         "Pandemonium", "Phoenix", "Plague", "Rage", "Rapture", "Rune", "Skull", "Sol", "Soul", "Sorrow", 
1444         "Spirit", "Storm", "Tempest", "Torment", "Vengeance", "Victory", "Viper", "Vortex", "Woe", "Wrath",
1445         "Light's", "Shimmering"  
1446     ];
1447     
1448     string[] private nameSuffixes = [
1449         "Bane",
1450         "Root",
1451         "Bite",
1452         "Song",
1453         "Roar",
1454         "Grasp",
1455         "Instrument",
1456         "Glow",
1457         "Bender",
1458         "Shadow",
1459         "Whisper",
1460         "Shout",
1461         "Growl",
1462         "Tear",
1463         "Peak",
1464         "Form",
1465         "Sun",
1466         "Moon"
1467     ];
1468     
1469     function random(string memory input) internal pure returns (uint256) {
1470         return uint256(keccak256(abi.encodePacked(input)));
1471     }
1472     
1473     function getWeapon(uint256 tokenId) public view returns (string memory) {
1474         return pluck(tokenId, "WEAPON", weapons);
1475     }
1476     
1477     function getChest(uint256 tokenId) public view returns (string memory) {
1478         return pluck(tokenId, "CHEST", chestArmor);
1479     }
1480     
1481     function getHead(uint256 tokenId) public view returns (string memory) {
1482         return pluck(tokenId, "HEAD", headArmor);
1483     }
1484     
1485     function getWaist(uint256 tokenId) public view returns (string memory) {
1486         return pluck(tokenId, "WAIST", waistArmor);
1487     }
1488 
1489     function getFoot(uint256 tokenId) public view returns (string memory) {
1490         return pluck(tokenId, "FOOT", footArmor);
1491     }
1492     
1493     function getHand(uint256 tokenId) public view returns (string memory) {
1494         return pluck(tokenId, "HAND", handArmor);
1495     }
1496     
1497     function getNeck(uint256 tokenId) public view returns (string memory) {
1498         return pluck(tokenId, "NECK", necklaces);
1499     }
1500     
1501     function getRing(uint256 tokenId) public view returns (string memory) {
1502         return pluck(tokenId, "RING", rings);
1503     }
1504     
1505     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1506         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1507         string memory output = sourceArray[rand % sourceArray.length];
1508         uint256 greatness = rand % 21;
1509         if (greatness > 14) {
1510             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1511         }
1512         if (greatness >= 19) {
1513             string[2] memory name;
1514             name[0] = namePrefixes[rand % namePrefixes.length];
1515             name[1] = nameSuffixes[rand % nameSuffixes.length];
1516             if (greatness == 19) {
1517                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1518             } else {
1519                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1520             }
1521         }
1522         return output;
1523     }
1524 
1525     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1526         string[17] memory parts;
1527         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1528 
1529         parts[1] = getWeapon(tokenId);
1530 
1531         parts[2] = '</text><text x="10" y="40" class="base">';
1532 
1533         parts[3] = getChest(tokenId);
1534 
1535         parts[4] = '</text><text x="10" y="60" class="base">';
1536 
1537         parts[5] = getHead(tokenId);
1538 
1539         parts[6] = '</text><text x="10" y="80" class="base">';
1540 
1541         parts[7] = getWaist(tokenId);
1542 
1543         parts[8] = '</text><text x="10" y="100" class="base">';
1544 
1545         parts[9] = getFoot(tokenId);
1546 
1547         parts[10] = '</text><text x="10" y="120" class="base">';
1548 
1549         parts[11] = getHand(tokenId);
1550 
1551         parts[12] = '</text><text x="10" y="140" class="base">';
1552 
1553         parts[13] = getNeck(tokenId);
1554 
1555         parts[14] = '</text><text x="10" y="160" class="base">';
1556 
1557         parts[15] = getRing(tokenId);
1558 
1559         parts[16] = '</text></svg>';
1560 
1561         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1562         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1563         
1564         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "More Loot is additional randomized adventurer gear generated and stored on chain. Maximum supply is dynamic, increasing at 1/10th of Ethereum\'s block rate. Stats, images, and other functionality are intentionally omitted for others to interpret. Feel free to use More Loot in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1565         output = string(abi.encodePacked('data:application/json;base64,', json));
1566 
1567         return output;
1568     }
1569 
1570     function claim(uint256 tokenId) public nonReentrant {
1571         require(tokenId > 8000 && tokenId < (block.number / 10) + 1, "Token ID invalid");
1572         _safeMint(_msgSender(), tokenId);
1573     }
1574     
1575     function toString(uint256 value) internal pure returns (string memory) {
1576     // Inspired by OraclizeAPI's implementation - MIT license
1577     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1578 
1579         if (value == 0) {
1580             return "0";
1581         }
1582         uint256 temp = value;
1583         uint256 digits;
1584         while (temp != 0) {
1585             digits++;
1586             temp /= 10;
1587         }
1588         bytes memory buffer = new bytes(digits);
1589         while (value != 0) {
1590             digits -= 1;
1591             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1592             value /= 10;
1593         }
1594         return string(buffer);
1595     }
1596     
1597     constructor() ERC721("More Loot", "MLOOT") Ownable() {}
1598 }
1599 
1600 /// [MIT License]
1601 /// @title Base64
1602 /// @notice Provides a function for encoding some bytes in base64
1603 /// @author Brecht Devos <brecht@loopring.org>
1604 library Base64 {
1605     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1606 
1607     /// @notice Encodes some bytes to the base64 representation
1608     function encode(bytes memory data) internal pure returns (string memory) {
1609         uint256 len = data.length;
1610         if (len == 0) return "";
1611 
1612         // multiply by 4/3 rounded up
1613         uint256 encodedLen = 4 * ((len + 2) / 3);
1614 
1615         // Add some extra buffer at the end
1616         bytes memory result = new bytes(encodedLen + 32);
1617 
1618         bytes memory table = TABLE;
1619 
1620         assembly {
1621             let tablePtr := add(table, 1)
1622             let resultPtr := add(result, 32)
1623 
1624             for {
1625                 let i := 0
1626             } lt(i, len) {
1627 
1628             } {
1629                 i := add(i, 3)
1630                 let input := and(mload(add(data, i)), 0xffffff)
1631 
1632                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1633                 out := shl(8, out)
1634                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1635                 out := shl(8, out)
1636                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1637                 out := shl(8, out)
1638                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1639                 out := shl(224, out)
1640 
1641                 mstore(resultPtr, out)
1642 
1643                 resultPtr := add(resultPtr, 4)
1644             }
1645 
1646             switch mod(len, 3)
1647             case 1 {
1648                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1649             }
1650             case 2 {
1651                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1652             }
1653 
1654             mstore(result, encodedLen)
1655         }
1656 
1657         return string(result);
1658     }
1659 }