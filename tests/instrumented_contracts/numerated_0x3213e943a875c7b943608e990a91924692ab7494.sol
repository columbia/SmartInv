1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-31
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
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 
168 
169 
170 /**
171  * @dev String operations.
172  */
173 library Strings {
174     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
178      */
179     function toString(uint256 value) internal pure returns (string memory) {
180         // Inspired by OraclizeAPI's implementation - MIT licence
181         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
182 
183         if (value == 0) {
184             return "0";
185         }
186         uint256 temp = value;
187         uint256 digits;
188         while (temp != 0) {
189             digits++;
190             temp /= 10;
191         }
192         bytes memory buffer = new bytes(digits);
193         while (value != 0) {
194             digits -= 1;
195             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
196             value /= 10;
197         }
198         return string(buffer);
199     }
200 
201     /**
202      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
203      */
204     function toHexString(uint256 value) internal pure returns (string memory) {
205         if (value == 0) {
206             return "0x00";
207         }
208         uint256 temp = value;
209         uint256 length = 0;
210         while (temp != 0) {
211             length++;
212             temp >>= 8;
213         }
214         return toHexString(value, length);
215     }
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
219      */
220     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
221         bytes memory buffer = new bytes(2 * length + 2);
222         buffer[0] = "0";
223         buffer[1] = "x";
224         for (uint256 i = 2 * length + 1; i > 1; --i) {
225             buffer[i] = _HEX_SYMBOLS[value & 0xf];
226             value >>= 4;
227         }
228         require(value == 0, "Strings: hex length insufficient");
229         return string(buffer);
230     }
231 }
232 
233 
234 
235 
236 /*
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 
257 
258 
259 
260 
261 
262 
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * By default, the owner account will be the one that deploys the contract. This
270  * can later be changed with {transferOwnership}.
271  *
272  * This module is used through inheritance. It will make available the modifier
273  * `onlyOwner`, which can be applied to your functions to restrict their use to
274  * the owner.
275  */
276 abstract contract Ownable is Context {
277     address private _owner;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor() {
285         _setOwner(_msgSender());
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view virtual returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _setOwner(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _setOwner(newOwner);
321     }
322 
323     function _setOwner(address newOwner) private {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 
331 
332 
333 
334 /**
335  * @dev Contract module that helps prevent reentrant calls to a function.
336  *
337  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
338  * available, which can be applied to functions to make sure there are no nested
339  * (reentrant) calls to them.
340  *
341  * Note that because there is a single `nonReentrant` guard, functions marked as
342  * `nonReentrant` may not call one another. This can be worked around by making
343  * those functions `private`, and then adding `external` `nonReentrant` entry
344  * points to them.
345  *
346  * TIP: If you would like to learn more about reentrancy and alternative ways
347  * to protect against it, check out our blog post
348  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
349  */
350 abstract contract ReentrancyGuard {
351     // Booleans are more expensive than uint256 or any type that takes up a full
352     // word because each write operation emits an extra SLOAD to first read the
353     // slot's contents, replace the bits taken up by the boolean, and then write
354     // back. This is the compiler's defense against contract upgrades and
355     // pointer aliasing, and it cannot be disabled.
356 
357     // The values being non-zero value makes deployment a bit more expensive,
358     // but in exchange the refund on every call to nonReentrant will be lower in
359     // amount. Since refunds are capped to a percentage of the total
360     // transaction's gas, it is best to keep them low in cases like this one, to
361     // increase the likelihood of the full refund coming into effect.
362     uint256 private constant _NOT_ENTERED = 1;
363     uint256 private constant _ENTERED = 2;
364 
365     uint256 private _status;
366 
367     constructor() {
368         _status = _NOT_ENTERED;
369     }
370 
371     /**
372      * @dev Prevents a contract from calling itself, directly or indirectly.
373      * Calling a `nonReentrant` function from another `nonReentrant`
374      * function is not supported. It is possible to prevent this from happening
375      * by making the `nonReentrant` function external, and make it call a
376      * `private` function that does the actual work.
377      */
378     modifier nonReentrant() {
379         // On the first call to nonReentrant, _notEntered will be true
380         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
381 
382         // Any calls to nonReentrant after this point will fail
383         _status = _ENTERED;
384 
385         _;
386 
387         // By storing the original value once again, a refund is triggered (see
388         // https://eips.ethereum.org/EIPS/eip-2200)
389         _status = _NOT_ENTERED;
390     }
391 }
392 
393 
394 
395 
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
406 /**
407  * @title ERC721 token receiver interface
408  * @dev Interface for any contract that wants to support safeTransfers
409  * from ERC721 asset contracts.
410  */
411 interface IERC721Receiver {
412     /**
413      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
414      * by `operator` from `from`, this function is called.
415      *
416      * It must return its Solidity selector to confirm the token transfer.
417      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
418      *
419      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
420      */
421     function onERC721Received(
422         address operator,
423         address from,
424         uint256 tokenId,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 
430 
431 
432 
433 
434 
435 /**
436  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
437  * @dev See https://eips.ethereum.org/EIPS/eip-721
438  */
439 interface IERC721Metadata is IERC721 {
440     /**
441      * @dev Returns the token collection name.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the token collection symbol.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
452      */
453     function tokenURI(uint256 tokenId) external view returns (string memory);
454 }
455 
456 
457 
458 
459 
460 /**
461  * @dev Collection of functions related to the address type
462  */
463 library Address {
464     /**
465      * @dev Returns true if `account` is a contract.
466      *
467      * [IMPORTANT]
468      * ====
469      * It is unsafe to assume that an address for which this function returns
470      * false is an externally-owned account (EOA) and not a contract.
471      *
472      * Among others, `isContract` will return false for the following
473      * types of addresses:
474      *
475      *  - an externally-owned account
476      *  - a contract in construction
477      *  - an address where a contract will be created
478      *  - an address where a contract lived, but was destroyed
479      * ====
480      */
481     function isContract(address account) internal view returns (bool) {
482         // This method relies on extcodesize, which returns 0 for contracts in
483         // construction, since the code is only stored at the end of the
484         // constructor execution.
485 
486         uint256 size;
487         assembly {
488             size := extcodesize(account)
489         }
490         return size > 0;
491     }
492 
493     /**
494      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
495      * `recipient`, forwarding all available gas and reverting on errors.
496      *
497      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
498      * of certain opcodes, possibly making contracts go over the 2300 gas limit
499      * imposed by `transfer`, making them unable to receive funds via
500      * `transfer`. {sendValue} removes this limitation.
501      *
502      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
503      *
504      * IMPORTANT: because control is transferred to `recipient`, care must be
505      * taken to not create reentrancy vulnerabilities. Consider using
506      * {ReentrancyGuard} or the
507      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
508      */
509     function sendValue(address payable recipient, uint256 amount) internal {
510         require(address(this).balance >= amount, "Address: insufficient balance");
511 
512         (bool success, ) = recipient.call{value: amount}("");
513         require(success, "Address: unable to send value, recipient may have reverted");
514     }
515 
516     /**
517      * @dev Performs a Solidity function call using a low level `call`. A
518      * plain `call` is an unsafe replacement for a function call: use this
519      * function instead.
520      *
521      * If `target` reverts with a revert reason, it is bubbled up by this
522      * function (like regular Solidity function calls).
523      *
524      * Returns the raw returned data. To convert to the expected return value,
525      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
526      *
527      * Requirements:
528      *
529      * - `target` must be a contract.
530      * - calling `target` with `data` must not revert.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
535         return functionCall(target, data, "Address: low-level call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
540      * `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, 0, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but also transferring `value` wei to `target`.
555      *
556      * Requirements:
557      *
558      * - the calling contract must have an ETH balance of at least `value`.
559      * - the called Solidity function must be `payable`.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value
567     ) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(
578         address target,
579         bytes memory data,
580         uint256 value,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         require(isContract(target), "Address: call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.call{value: value}(data);
587         return _verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
597         return functionStaticCall(target, data, "Address: low-level static call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(
607         address target,
608         bytes memory data,
609         string memory errorMessage
610     ) internal view returns (bytes memory) {
611         require(isContract(target), "Address: static call to non-contract");
612 
613         (bool success, bytes memory returndata) = target.staticcall(data);
614         return _verifyCallResult(success, returndata, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
624         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(
634         address target,
635         bytes memory data,
636         string memory errorMessage
637     ) internal returns (bytes memory) {
638         require(isContract(target), "Address: delegate call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.delegatecall(data);
641         return _verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     function _verifyCallResult(
645         bool success,
646         bytes memory returndata,
647         string memory errorMessage
648     ) private pure returns (bytes memory) {
649         if (success) {
650             return returndata;
651         } else {
652             // Look for revert reason and bubble it up if present
653             if (returndata.length > 0) {
654                 // The easiest way to bubble the revert reason is using memory via assembly
655 
656                 assembly {
657                     let returndata_size := mload(returndata)
658                     revert(add(32, returndata), returndata_size)
659                 }
660             } else {
661                 revert(errorMessage);
662             }
663         }
664     }
665 }
666 
667 
668 
669 
670 
671 
672 
673 
674 
675 /**
676  * @dev Implementation of the {IERC165} interface.
677  *
678  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
679  * for the additional interface id that will be supported. For example:
680  *
681  * ```solidity
682  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
684  * }
685  * ```
686  *
687  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
688  */
689 abstract contract ERC165 is IERC165 {
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694         return interfaceId == type(IERC165).interfaceId;
695     }
696 }
697 
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata extension, but not including the Enumerable extension, which is available separately as
702  * {ERC721Enumerable}.
703  */
704 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
705     using Address for address;
706     using Strings for uint256;
707 
708     // Token name
709     string private _name;
710 
711     // Token symbol
712     string private _symbol;
713 
714     // Mapping from token ID to owner address
715     mapping(uint256 => address) private _owners;
716 
717     // Mapping owner address to token count
718     mapping(address => uint256) private _balances;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     /**
727      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
728      */
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view virtual override returns (uint256) {
748         require(owner != address(0), "ERC721: balance query for the zero address");
749         return _balances[owner];
750     }
751 
752     /**
753      * @dev See {IERC721-ownerOf}.
754      */
755     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
756         address owner = _owners[tokenId];
757         require(owner != address(0), "ERC721: owner query for nonexistent token");
758         return owner;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-name}.
763      */
764     function name() public view virtual override returns (string memory) {
765         return _name;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-symbol}.
770      */
771     function symbol() public view virtual override returns (string memory) {
772         return _symbol;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-tokenURI}.
777      */
778     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
779         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
780 
781         string memory baseURI = _baseURI();
782         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
783     }
784 
785     /**
786      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
787      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
788      * by default, can be overriden in child contracts.
789      */
790     function _baseURI() internal view virtual returns (string memory) {
791         return "";
792     }
793 
794     /**
795      * @dev See {IERC721-approve}.
796      */
797     function approve(address to, uint256 tokenId) public virtual override {
798         address owner = ERC721.ownerOf(tokenId);
799         require(to != owner, "ERC721: approval to current owner");
800 
801         require(
802             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
803             "ERC721: approve caller is not owner nor approved for all"
804         );
805 
806         _approve(to, tokenId);
807     }
808 
809     /**
810      * @dev See {IERC721-getApproved}.
811      */
812     function getApproved(uint256 tokenId) public view virtual override returns (address) {
813         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
814 
815         return _tokenApprovals[tokenId];
816     }
817 
818     /**
819      * @dev See {IERC721-setApprovalForAll}.
820      */
821     function setApprovalForAll(address operator, bool approved) public virtual override {
822         require(operator != _msgSender(), "ERC721: approve to caller");
823 
824         _operatorApprovals[_msgSender()][operator] = approved;
825         emit ApprovalForAll(_msgSender(), operator, approved);
826     }
827 
828     /**
829      * @dev See {IERC721-isApprovedForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         //solhint-disable-next-line max-line-length
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845 
846         _transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, "");
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
870         _safeTransfer(from, to, tokenId, _data);
871     }
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
875      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
876      *
877      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
878      *
879      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
880      * implement alternative mechanisms to perform token transfer, such as signature-based.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeTransfer(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) internal virtual {
897         _transfer(from, to, tokenId);
898         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
899     }
900 
901     /**
902      * @dev Returns whether `tokenId` exists.
903      *
904      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
905      *
906      * Tokens start existing when they are minted (`_mint`),
907      * and stop existing when they are burned (`_burn`).
908      */
909     function _exists(uint256 tokenId) internal view virtual returns (bool) {
910         return _owners[tokenId] != address(0);
911     }
912 
913     /**
914      * @dev Returns whether `spender` is allowed to manage `tokenId`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
921         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
922         address owner = ERC721.ownerOf(tokenId);
923         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, _data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId) internal virtual {
991         address owner = ERC721.ownerOf(tokenId);
992 
993         _beforeTokenTransfer(owner, address(0), tokenId);
994 
995         // Clear approvals
996         _approve(address(0), tokenId);
997 
998         _balances[owner] -= 1;
999         delete _owners[tokenId];
1000 
1001         emit Transfer(owner, address(0), tokenId);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {
1020         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1021         require(to != address(0), "ERC721: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(from, to, tokenId);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId);
1027 
1028         _balances[from] -= 1;
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `to` to operate on `tokenId`
1037      *
1038      * Emits a {Approval} event.
1039      */
1040     function _approve(address to, uint256 tokenId) internal virtual {
1041         _tokenApprovals[tokenId] = to;
1042         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1047      * The call is not executed if the target address is not a contract.
1048      *
1049      * @param from address representing the previous owner of the given token ID
1050      * @param to target address that will receive the tokens
1051      * @param tokenId uint256 ID of the token to be transferred
1052      * @param _data bytes optional data to send along with the call
1053      * @return bool whether the call correctly returned the expected magic value
1054      */
1055     function _checkOnERC721Received(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) private returns (bool) {
1061         if (to.isContract()) {
1062             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1063                 return retval == IERC721Receiver(to).onERC721Received.selector;
1064             } catch (bytes memory reason) {
1065                 if (reason.length == 0) {
1066                     revert("ERC721: transfer to non ERC721Receiver implementer");
1067                 } else {
1068                     assembly {
1069                         revert(add(32, reason), mload(reason))
1070                     }
1071                 }
1072             }
1073         } else {
1074             return true;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {}
1097 }
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 /**
1106  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1107  * @dev See https://eips.ethereum.org/EIPS/eip-721
1108  */
1109 interface IERC721Enumerable is IERC721 {
1110     /**
1111      * @dev Returns the total amount of tokens stored by the contract.
1112      */
1113     function totalSupply() external view returns (uint256);
1114 
1115     /**
1116      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1117      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1120 
1121     /**
1122      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1123      * Use along with {totalSupply} to enumerate all tokens.
1124      */
1125     function tokenByIndex(uint256 index) external view returns (uint256);
1126 }
1127 
1128 
1129 /**
1130  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1131  * enumerability of all the token ids in the contract as well as all token ids owned by each
1132  * account.
1133  */
1134 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1135     // Mapping from owner to list of owned token IDs
1136     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1137 
1138     // Mapping from token ID to index of the owner tokens list
1139     mapping(uint256 => uint256) private _ownedTokensIndex;
1140 
1141     // Array with all token ids, used for enumeration
1142     uint256[] private _allTokens;
1143 
1144     // Mapping from token id to position in the allTokens array
1145     mapping(uint256 => uint256) private _allTokensIndex;
1146 
1147     /**
1148      * @dev See {IERC165-supportsInterface}.
1149      */
1150     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1151         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1156      */
1157     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1158         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1159         return _ownedTokens[owner][index];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-totalSupply}.
1164      */
1165     function totalSupply() public view virtual override returns (uint256) {
1166         return _allTokens.length;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-tokenByIndex}.
1171      */
1172     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1173         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1174         return _allTokens[index];
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before any token transfer. This includes minting
1179      * and burning.
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` will be minted for `to`.
1186      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1187      * - `from` cannot be the zero address.
1188      * - `to` cannot be the zero address.
1189      *
1190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1191      */
1192     function _beforeTokenTransfer(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) internal virtual override {
1197         super._beforeTokenTransfer(from, to, tokenId);
1198 
1199         if (from == address(0)) {
1200             _addTokenToAllTokensEnumeration(tokenId);
1201         } else if (from != to) {
1202             _removeTokenFromOwnerEnumeration(from, tokenId);
1203         }
1204         if (to == address(0)) {
1205             _removeTokenFromAllTokensEnumeration(tokenId);
1206         } else if (to != from) {
1207             _addTokenToOwnerEnumeration(to, tokenId);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1213      * @param to address representing the new owner of the given token ID
1214      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1215      */
1216     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1217         uint256 length = ERC721.balanceOf(to);
1218         _ownedTokens[to][length] = tokenId;
1219         _ownedTokensIndex[tokenId] = length;
1220     }
1221 
1222     /**
1223      * @dev Private function to add a token to this extension's token tracking data structures.
1224      * @param tokenId uint256 ID of the token to be added to the tokens list
1225      */
1226     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1227         _allTokensIndex[tokenId] = _allTokens.length;
1228         _allTokens.push(tokenId);
1229     }
1230 
1231     /**
1232      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1233      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1234      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1235      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1236      * @param from address representing the previous owner of the given token ID
1237      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1238      */
1239     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1240         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1241         // then delete the last slot (swap and pop).
1242 
1243         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1244         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1245 
1246         // When the token to delete is the last token, the swap operation is unnecessary
1247         if (tokenIndex != lastTokenIndex) {
1248             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1249 
1250             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1251             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1252         }
1253 
1254         // This also deletes the contents at the last position of the array
1255         delete _ownedTokensIndex[tokenId];
1256         delete _ownedTokens[from][lastTokenIndex];
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's token tracking data structures.
1261      * This has O(1) time complexity, but alters the order of the _allTokens array.
1262      * @param tokenId uint256 ID of the token to be removed from the tokens list
1263      */
1264     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1265         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1266         // then delete the last slot (swap and pop).
1267 
1268         uint256 lastTokenIndex = _allTokens.length - 1;
1269         uint256 tokenIndex = _allTokensIndex[tokenId];
1270 
1271         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1272         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1273         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1274         uint256 lastTokenId = _allTokens[lastTokenIndex];
1275 
1276         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1277         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1278 
1279         // This also deletes the contents at the last position of the array
1280         delete _allTokensIndex[tokenId];
1281         _allTokens.pop();
1282     }
1283 }
1284 
1285 
1286 contract AbilityScores is ERC721Enumerable, ReentrancyGuard, Ownable {
1287 
1288     ERC721 loot = ERC721(0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613);
1289     
1290     // mirror a dice roll
1291     function random(string memory input) internal pure returns (uint256) {
1292         return (uint256(keccak256(abi.encodePacked(input))) % 6) + 1;
1293     }
1294     
1295     function getStrength(uint256 tokenId) public pure returns (string memory) {
1296         return pluck(tokenId, "Strength");
1297     }
1298     
1299     function getAiming(uint256 tokenId) public pure returns (string memory) {
1300         return pluck(tokenId, "Aiming");
1301     }
1302     
1303     function getStamina(uint256 tokenId) public pure returns (string memory) {
1304         return pluck(tokenId, "Stamina");
1305     }
1306     
1307     function getStealth(uint256 tokenId) public pure returns (string memory) {
1308         return pluck(tokenId, "Stealth");
1309     }
1310 
1311     function getDriving(uint256 tokenId) public pure returns (string memory) {
1312         return pluck(tokenId, "Driving");
1313     }
1314     
1315     function getSwimming(uint256 tokenId) public pure returns (string memory) {
1316         return pluck(tokenId, "Swimming");
1317     }
1318     
1319     function pluck(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
1320         uint256 roll1 = random(string(abi.encodePacked(keyPrefix, toString(tokenId), "1")));
1321         uint256 min = roll1;
1322         uint256 roll2 = random(string(abi.encodePacked(keyPrefix, toString(tokenId), "2")));
1323         min = min > roll2 ? roll2 : min;
1324         uint256 roll3 = random(string(abi.encodePacked(keyPrefix, toString(tokenId), "3")));
1325         min = min > roll3 ? roll3 : min;
1326         uint256 roll4 = random(string(abi.encodePacked(keyPrefix, toString(tokenId), "4")));
1327         min = min > roll4 ? roll4 : min;
1328         
1329         // get 3 highest dice rolls
1330         uint256 stat = roll1 + roll2 + roll3 + roll4 - min;
1331         
1332         string memory output = string(abi.encodePacked(keyPrefix, ": ", toString(stat)));
1333 
1334         return output;
1335     }
1336 
1337     function tokenURI(uint256 tokenId) override public pure returns (string memory) {
1338         string[13] memory parts;
1339         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1340 
1341         parts[1] = getStrength(tokenId);
1342 
1343         parts[2] = '</text><text x="10" y="40" class="base">';
1344 
1345         parts[3] = getAiming(tokenId);
1346 
1347         parts[4] = '</text><text x="10" y="60" class="base">';
1348 
1349         parts[5] = getStamina(tokenId);
1350 
1351         parts[6] = '</text><text x="10" y="80" class="base">';
1352 
1353         parts[7] = getStealth(tokenId);
1354 
1355         parts[8] = '</text><text x="10" y="100" class="base">';
1356 
1357         parts[9] = getDriving(tokenId);
1358 
1359         parts[10] = '</text><text x="10" y="120" class="base">';
1360 
1361         parts[11] = getSwimming(tokenId);
1362 
1363         parts[12] = '</text></svg>';
1364 
1365         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1366         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12]));
1367         
1368         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Sheet #', toString(tokenId), '", "description": "Skill Stats are randomized RPG style stats generated and stored on chain. Feel free to use Skill Stats in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1369         output = string(abi.encodePacked('data:application/json;base64,', json));
1370 
1371         return output;
1372     }
1373 
1374     function claim(uint256 tokenId) public nonReentrant {
1375         require(tokenId > 8000 && tokenId < 9576, "Token ID invalid");
1376         _safeMint(_msgSender(), tokenId);
1377     }
1378     
1379     function claimForLoot(uint256 tokenId) public nonReentrant {
1380         require(tokenId > 0 && tokenId < 8001, "Token ID invalid");
1381         require(loot.ownerOf(tokenId) == msg.sender, "Not Loot owner");
1382         _safeMint(_msgSender(), tokenId);
1383     }
1384     
1385     function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1386         require(tokenId > 9575 && tokenId < 10001, "Token ID invalid");
1387         _safeMint(owner(), tokenId);
1388     }
1389     
1390     function toString(uint256 value) internal pure returns (string memory) {
1391     // Inspired by OraclizeAPI's implementation - MIT license
1392     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1393 
1394         if (value == 0) {
1395             return "0";
1396         }
1397         uint256 temp = value;
1398         uint256 digits;
1399         while (temp != 0) {
1400             digits++;
1401             temp /= 10;
1402         }
1403         bytes memory buffer = new bytes(digits);
1404         while (value != 0) {
1405             digits -= 1;
1406             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1407             value /= 10;
1408         }
1409         return string(buffer);
1410     }
1411     
1412     constructor() ERC721("Stats", "STATS") Ownable() {}
1413 }
1414 
1415 /// [MIT License]
1416 /// @title Base64
1417 /// @notice Provides a function for encoding some bytes in base64
1418 /// @author Brecht Devos <brecht@loopring.org>
1419 library Base64 {
1420     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1421 
1422     /// @notice Encodes some bytes to the base64 representation
1423     function encode(bytes memory data) internal pure returns (string memory) {
1424         uint256 len = data.length;
1425         if (len == 0) return "";
1426 
1427         // multiply by 4/3 rounded up
1428         uint256 encodedLen = 4 * ((len + 2) / 3);
1429 
1430         // Add some extra buffer at the end
1431         bytes memory result = new bytes(encodedLen + 32);
1432 
1433         bytes memory table = TABLE;
1434 
1435         assembly {
1436             let tablePtr := add(table, 1)
1437             let resultPtr := add(result, 32)
1438 
1439             for {
1440                 let i := 0
1441             } lt(i, len) {
1442 
1443             } {
1444                 i := add(i, 3)
1445                 let input := and(mload(add(data, i)), 0xffffff)
1446 
1447                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1448                 out := shl(8, out)
1449                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1450                 out := shl(8, out)
1451                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1452                 out := shl(8, out)
1453                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1454                 out := shl(224, out)
1455 
1456                 mstore(resultPtr, out)
1457 
1458                 resultPtr := add(resultPtr, 4)
1459             }
1460 
1461             switch mod(len, 3)
1462             case 1 {
1463                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1464             }
1465             case 2 {
1466                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1467             }
1468 
1469             mstore(result, encodedLen)
1470         }
1471 
1472         return string(result);
1473     }
1474 }