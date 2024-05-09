1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181         // Inspired by OraclizeAPI's implementation - MIT licence
182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
183 
184         if (value == 0) {
185             return "0";
186         }
187         uint256 temp = value;
188         uint256 digits;
189         while (temp != 0) {
190             digits++;
191             temp /= 10;
192         }
193         bytes memory buffer = new bytes(digits);
194         while (value != 0) {
195             digits -= 1;
196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
197             value /= 10;
198         }
199         return string(buffer);
200     }
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
204      */
205     function toHexString(uint256 value) internal pure returns (string memory) {
206         if (value == 0) {
207             return "0x00";
208         }
209         uint256 temp = value;
210         uint256 length = 0;
211         while (temp != 0) {
212             length++;
213             temp >>= 8;
214         }
215         return toHexString(value, length);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
220      */
221     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
222         bytes memory buffer = new bytes(2 * length + 2);
223         buffer[0] = "0";
224         buffer[1] = "x";
225         for (uint256 i = 2 * length + 1; i > 1; --i) {
226             buffer[i] = _HEX_SYMBOLS[value & 0xf];
227             value >>= 4;
228         }
229         require(value == 0, "Strings: hex length insufficient");
230         return string(buffer);
231     }
232 }
233 
234 
235 
236 
237 /*
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 
258 
259 
260 
261 
262 
263 
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * By default, the owner account will be the one that deploys the contract. This
271  * can later be changed with {transferOwnership}.
272  *
273  * This module is used through inheritance. It will make available the modifier
274  * `onlyOwner`, which can be applied to your functions to restrict their use to
275  * the owner.
276  */
277 abstract contract Ownable is Context {
278     address private _owner;
279 
280     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
281 
282     /**
283      * @dev Initializes the contract setting the deployer as the initial owner.
284      */
285     constructor() {
286         _setOwner(_msgSender());
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         _setOwner(address(0));
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         _setOwner(newOwner);
322     }
323 
324     function _setOwner(address newOwner) private {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 
331 
332 
333 
334 
335 /**
336  * @dev Contract module that helps prevent reentrant calls to a function.
337  *
338  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
339  * available, which can be applied to functions to make sure there are no nested
340  * (reentrant) calls to them.
341  *
342  * Note that because there is a single `nonReentrant` guard, functions marked as
343  * `nonReentrant` may not call one another. This can be worked around by making
344  * those functions `private`, and then adding `external` `nonReentrant` entry
345  * points to them.
346  *
347  * TIP: If you would like to learn more about reentrancy and alternative ways
348  * to protect against it, check out our blog post
349  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
350  */
351 abstract contract ReentrancyGuard {
352     // Booleans are more expensive than uint256 or any type that takes up a full
353     // word because each write operation emits an extra SLOAD to first read the
354     // slot's contents, replace the bits taken up by the boolean, and then write
355     // back. This is the compiler's defense against contract upgrades and
356     // pointer aliasing, and it cannot be disabled.
357 
358     // The values being non-zero value makes deployment a bit more expensive,
359     // but in exchange the refund on every call to nonReentrant will be lower in
360     // amount. Since refunds are capped to a percentage of the total
361     // transaction's gas, it is best to keep them low in cases like this one, to
362     // increase the likelihood of the full refund coming into effect.
363     uint256 private constant _NOT_ENTERED = 1;
364     uint256 private constant _ENTERED = 2;
365 
366     uint256 private _status;
367 
368     constructor() {
369         _status = _NOT_ENTERED;
370     }
371 
372     /**
373      * @dev Prevents a contract from calling itself, directly or indirectly.
374      * Calling a `nonReentrant` function from another `nonReentrant`
375      * function is not supported. It is possible to prevent this from happening
376      * by making the `nonReentrant` function external, and make it call a
377      * `private` function that does the actual work.
378      */
379     modifier nonReentrant() {
380         // On the first call to nonReentrant, _notEntered will be true
381         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
382 
383         // Any calls to nonReentrant after this point will fail
384         _status = _ENTERED;
385 
386         _;
387 
388         // By storing the original value once again, a refund is triggered (see
389         // https://eips.ethereum.org/EIPS/eip-2200)
390         _status = _NOT_ENTERED;
391     }
392 }
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
406 
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 
431 
432 
433 
434 
435 
436 /**
437  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
438  * @dev See https://eips.ethereum.org/EIPS/eip-721
439  */
440 interface IERC721Metadata is IERC721 {
441     /**
442      * @dev Returns the token collection name.
443      */
444     function name() external view returns (string memory);
445 
446     /**
447      * @dev Returns the token collection symbol.
448      */
449     function symbol() external view returns (string memory);
450 
451     /**
452      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
453      */
454     function tokenURI(uint256 tokenId) external view returns (string memory);
455 }
456 
457 
458 
459 
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // This method relies on extcodesize, which returns 0 for contracts in
484         // construction, since the code is only stored at the end of the
485         // constructor execution.
486 
487         uint256 size;
488         assembly {
489             size := extcodesize(account)
490         }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         (bool success, ) = recipient.call{value: amount}("");
514         require(success, "Address: unable to send value, recipient may have reverted");
515     }
516 
517     /**
518      * @dev Performs a Solidity function call using a low level `call`. A
519      * plain `call` is an unsafe replacement for a function call: use this
520      * function instead.
521      *
522      * If `target` reverts with a revert reason, it is bubbled up by this
523      * function (like regular Solidity function calls).
524      *
525      * Returns the raw returned data. To convert to the expected return value,
526      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
527      *
528      * Requirements:
529      *
530      * - `target` must be a contract.
531      * - calling `target` with `data` must not revert.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
536         return functionCall(target, data, "Address: low-level call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
541      * `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, 0, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but also transferring `value` wei to `target`.
556      *
557      * Requirements:
558      *
559      * - the calling contract must have an ETH balance of at least `value`.
560      * - the called Solidity function must be `payable`.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(
565         address target,
566         bytes memory data,
567         uint256 value
568     ) internal returns (bytes memory) {
569         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
574      * with `errorMessage` as a fallback revert reason when `target` reverts.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(
579         address target,
580         bytes memory data,
581         uint256 value,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(address(this).balance >= value, "Address: insufficient balance for call");
585         require(isContract(target), "Address: call to non-contract");
586 
587         (bool success, bytes memory returndata) = target.call{value: value}(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(
608         address target,
609         bytes memory data,
610         string memory errorMessage
611     ) internal view returns (bytes memory) {
612         require(isContract(target), "Address: static call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.staticcall(data);
615         return _verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
625         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a delegate call.
631      *
632      * _Available since v3.4._
633      */
634     function functionDelegateCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal returns (bytes memory) {
639         require(isContract(target), "Address: delegate call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.delegatecall(data);
642         return _verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     function _verifyCallResult(
646         bool success,
647         bytes memory returndata,
648         string memory errorMessage
649     ) private pure returns (bytes memory) {
650         if (success) {
651             return returndata;
652         } else {
653             // Look for revert reason and bubble it up if present
654             if (returndata.length > 0) {
655                 // The easiest way to bubble the revert reason is using memory via assembly
656 
657                 assembly {
658                     let returndata_size := mload(returndata)
659                     revert(add(32, returndata), returndata_size)
660                 }
661             } else {
662                 revert(errorMessage);
663             }
664         }
665     }
666 }
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 /**
677  * @dev Implementation of the {IERC165} interface.
678  *
679  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
680  * for the additional interface id that will be supported. For example:
681  *
682  * ```solidity
683  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
684  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
685  * }
686  * ```
687  *
688  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
689  */
690 abstract contract ERC165 is IERC165 {
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695         return interfaceId == type(IERC165).interfaceId;
696     }
697 }
698 
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
702  * the Metadata extension, but not including the Enumerable extension, which is available separately as
703  * {ERC721Enumerable}.
704  */
705 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
706     using Address for address;
707     using Strings for uint256;
708 
709     // Token name
710     string private _name;
711 
712     // Token symbol
713     string private _symbol;
714 
715     // Mapping from token ID to owner address
716     mapping(uint256 => address) private _owners;
717 
718     // Mapping owner address to token count
719     mapping(address => uint256) private _balances;
720 
721     // Mapping from token ID to approved address
722     mapping(uint256 => address) private _tokenApprovals;
723 
724     // Mapping from owner to operator approvals
725     mapping(address => mapping(address => bool)) private _operatorApprovals;
726 
727     /**
728      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
729      */
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733     }
734 
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
739         return
740             interfaceId == type(IERC721).interfaceId ||
741             interfaceId == type(IERC721Metadata).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev See {IERC721-balanceOf}.
747      */
748     function balanceOf(address owner) public view virtual override returns (uint256) {
749         require(owner != address(0), "ERC721: balance query for the zero address");
750         return _balances[owner];
751     }
752 
753     /**
754      * @dev See {IERC721-ownerOf}.
755      */
756     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
757         address owner = _owners[tokenId];
758         require(owner != address(0), "ERC721: owner query for nonexistent token");
759         return owner;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-name}.
764      */
765     function name() public view virtual override returns (string memory) {
766         return _name;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-symbol}.
771      */
772     function symbol() public view virtual override returns (string memory) {
773         return _symbol;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-tokenURI}.
778      */
779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
780         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
781 
782         string memory baseURI = _baseURI();
783         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
784     }
785 
786     /**
787      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
788      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
789      * by default, can be overriden in child contracts.
790      */
791     function _baseURI() internal view virtual returns (string memory) {
792         return "";
793     }
794 
795     /**
796      * @dev See {IERC721-approve}.
797      */
798     function approve(address to, uint256 tokenId) public virtual override {
799         address owner = ERC721.ownerOf(tokenId);
800         require(to != owner, "ERC721: approval to current owner");
801 
802         require(
803             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
804             "ERC721: approve caller is not owner nor approved for all"
805         );
806 
807         _approve(to, tokenId);
808     }
809 
810     /**
811      * @dev See {IERC721-getApproved}.
812      */
813     function getApproved(uint256 tokenId) public view virtual override returns (address) {
814         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
815 
816         return _tokenApprovals[tokenId];
817     }
818 
819     /**
820      * @dev See {IERC721-setApprovalForAll}.
821      */
822     function setApprovalForAll(address operator, bool approved) public virtual override {
823         require(operator != _msgSender(), "ERC721: approve to caller");
824 
825         _operatorApprovals[_msgSender()][operator] = approved;
826         emit ApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         //solhint-disable-next-line max-line-length
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
846 
847         _transfer(from, to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         safeTransferFrom(from, to, tokenId, "");
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes memory _data
869     ) public virtual override {
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871         _safeTransfer(from, to, tokenId, _data);
872     }
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
879      *
880      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
881      * implement alternative mechanisms to perform token transfer, such as signature-based.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeTransfer(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _transfer(from, to, tokenId);
899         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      * and stop existing when they are burned (`_burn`).
909      */
910     function _exists(uint256 tokenId) internal view virtual returns (bool) {
911         return _owners[tokenId] != address(0);
912     }
913 
914     /**
915      * @dev Returns whether `spender` is allowed to manage `tokenId`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
922         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
923         address owner = ERC721.ownerOf(tokenId);
924         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
925     }
926 
927     /**
928      * @dev Safely mints `tokenId` and transfers it to `to`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must not exist.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeMint(address to, uint256 tokenId) internal virtual {
938         _safeMint(to, tokenId, "");
939     }
940 
941     /**
942      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
943      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
944      */
945     function _safeMint(
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) internal virtual {
950         _mint(to, tokenId);
951         require(
952             _checkOnERC721Received(address(0), to, tokenId, _data),
953             "ERC721: transfer to non ERC721Receiver implementer"
954         );
955     }
956 
957     /**
958      * @dev Mints `tokenId` and transfers it to `to`.
959      *
960      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - `to` cannot be the zero address.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _mint(address to, uint256 tokenId) internal virtual {
970         require(to != address(0), "ERC721: mint to the zero address");
971         require(!_exists(tokenId), "ERC721: token already minted");
972 
973         _beforeTokenTransfer(address(0), to, tokenId);
974 
975         _balances[to] += 1;
976         _owners[tokenId] = to;
977 
978         emit Transfer(address(0), to, tokenId);
979     }
980 
981     /**
982      * @dev Destroys `tokenId`.
983      * The approval is cleared when the token is burned.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _burn(uint256 tokenId) internal virtual {
992         address owner = ERC721.ownerOf(tokenId);
993 
994         _beforeTokenTransfer(owner, address(0), tokenId);
995 
996         // Clear approvals
997         _approve(address(0), tokenId);
998 
999         _balances[owner] -= 1;
1000         delete _owners[tokenId];
1001 
1002         emit Transfer(owner, address(0), tokenId);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must be owned by `from`.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {
1021         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1022         require(to != address(0), "ERC721: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(from, to, tokenId);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId);
1028 
1029         _balances[from] -= 1;
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(address to, uint256 tokenId) internal virtual {
1042         _tokenApprovals[tokenId] = to;
1043         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver(to).onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 }
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Enumerable is IERC721 {
1111     /**
1112      * @dev Returns the total amount of tokens stored by the contract.
1113      */
1114     function totalSupply() external view returns (uint256);
1115 
1116     /**
1117      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1118      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1119      */
1120     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1121 
1122     /**
1123      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1124      * Use along with {totalSupply} to enumerate all tokens.
1125      */
1126     function tokenByIndex(uint256 index) external view returns (uint256);
1127 }
1128 
1129 
1130 /**
1131  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1132  * enumerability of all the token ids in the contract as well as all token ids owned by each
1133  * account.
1134  */
1135 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1136     // Mapping from owner to list of owned token IDs
1137     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1138 
1139     // Mapping from token ID to index of the owner tokens list
1140     mapping(uint256 => uint256) private _ownedTokensIndex;
1141 
1142     // Array with all token ids, used for enumeration
1143     uint256[] private _allTokens;
1144 
1145     // Mapping from token id to position in the allTokens array
1146     mapping(uint256 => uint256) private _allTokensIndex;
1147 
1148     /**
1149      * @dev See {IERC165-supportsInterface}.
1150      */
1151     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1152         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1157      */
1158     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1159         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1160         return _ownedTokens[owner][index];
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Enumerable-totalSupply}.
1165      */
1166     function totalSupply() public view virtual override returns (uint256) {
1167         return _allTokens.length;
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Enumerable-tokenByIndex}.
1172      */
1173     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1174         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1175         return _allTokens[index];
1176     }
1177 
1178     /**
1179      * @dev Hook that is called before any token transfer. This includes minting
1180      * and burning.
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1188      * - `from` cannot be the zero address.
1189      * - `to` cannot be the zero address.
1190      *
1191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1192      */
1193     function _beforeTokenTransfer(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) internal virtual override {
1198         super._beforeTokenTransfer(from, to, tokenId);
1199 
1200         if (from == address(0)) {
1201             _addTokenToAllTokensEnumeration(tokenId);
1202         } else if (from != to) {
1203             _removeTokenFromOwnerEnumeration(from, tokenId);
1204         }
1205         if (to == address(0)) {
1206             _removeTokenFromAllTokensEnumeration(tokenId);
1207         } else if (to != from) {
1208             _addTokenToOwnerEnumeration(to, tokenId);
1209         }
1210     }
1211 
1212     /**
1213      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1214      * @param to address representing the new owner of the given token ID
1215      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1216      */
1217     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1218         uint256 length = ERC721.balanceOf(to);
1219         _ownedTokens[to][length] = tokenId;
1220         _ownedTokensIndex[tokenId] = length;
1221     }
1222 
1223     /**
1224      * @dev Private function to add a token to this extension's token tracking data structures.
1225      * @param tokenId uint256 ID of the token to be added to the tokens list
1226      */
1227     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1228         _allTokensIndex[tokenId] = _allTokens.length;
1229         _allTokens.push(tokenId);
1230     }
1231 
1232     /**
1233      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1234      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1235      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1236      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1237      * @param from address representing the previous owner of the given token ID
1238      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1239      */
1240     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1241         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1242         // then delete the last slot (swap and pop).
1243 
1244         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1245         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1246 
1247         // When the token to delete is the last token, the swap operation is unnecessary
1248         if (tokenIndex != lastTokenIndex) {
1249             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1250 
1251             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1252             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1253         }
1254 
1255         // This also deletes the contents at the last position of the array
1256         delete _ownedTokensIndex[tokenId];
1257         delete _ownedTokens[from][lastTokenIndex];
1258     }
1259 
1260     /**
1261      * @dev Private function to remove a token from this extension's token tracking data structures.
1262      * This has O(1) time complexity, but alters the order of the _allTokens array.
1263      * @param tokenId uint256 ID of the token to be removed from the tokens list
1264      */
1265     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1266         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1267         // then delete the last slot (swap and pop).
1268 
1269         uint256 lastTokenIndex = _allTokens.length - 1;
1270         uint256 tokenIndex = _allTokensIndex[tokenId];
1271 
1272         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1273         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1274         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1275         uint256 lastTokenId = _allTokens[lastTokenIndex];
1276 
1277         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1278         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1279 
1280         // This also deletes the contents at the last position of the array
1281         delete _allTokensIndex[tokenId];
1282         _allTokens.pop();
1283     }
1284 }
1285 
1286 /// @title A Loot-Derivative Project for the Travel Industry
1287 /// @author jacmos3 - TripsCommunity
1288 /// @notice Text-based NFTs thought for the Travel Industry appannage. Hotels, restaurants, hospitality etc can use them both in the real or metaverse worlds
1289 contract TravelerLoot is ERC721Enumerable, ReentrancyGuard, Ownable {
1290 
1291     uint256 private constant DISCOUNT_EXPIRATION = 1790553599; //Sun 27 Sep 2026 21:59:59 UTC
1292     string private constant WHITE = "white";
1293     string private constant BLACK = "black";
1294     string private constant GOLD = "gold";
1295     string private constant PLATINUM = "#D5D6D8";
1296     string private constant GUILD = "GUILD";
1297     string private constant PATRON = "PATRON";
1298     string private constant CONQUEROR = "CONQUEROR";
1299     uint160 private constant INITIAL_PRICE_FOR_PATRONS = 1 ether;
1300     string private constant ERROR_TOKEN_ID_INVALID = "Token ID invalid";
1301     string private constant ERROR_ADDRESS_NOT_VERIFIED = "Address not verified. Try another";
1302     string private constant ERROR_NOT_THE_OWNER = "You do not own token(s) of the address";
1303     string private constant ERROR_DOM_40TH_BIRTHDAY = "Only valid till Dom's 40th bday";
1304     string private constant ERROR_LOW_VALUE = "Set a higher value";
1305     string private constant ERROR_COMPETITION_ENDED = "Competition has ended. Check the Conqueror!";
1306     string private constant ERROR_COMPETITION_ONGOING = "Conqueror not yet elected!";
1307     string private constant ERROR_OWNER_NOT_ALLOWED = "Use claimByOwner() instead";
1308     string private constant ERROR_ALREADY_ACTIVATED = "Already activated";
1309     string private constant ERROR_COME_BACK_LATER = "Come back later";
1310     string private constant ERROR_WITHDRAW_NEEDED = "Treasurer already changed. Perform a withdrawal before changing it";
1311     string private constant ERROR_GUILD_ALREADY_WHITELISTED = "Guild already whitelisted!";
1312     string private constant ERROR_CANNOT_ADD_THIS_CONTRACT = "Not possible";
1313     string private constant ERROR_NOT_ENTITLED = "Check conditions before whitelisting";
1314 
1315     address private constant INITIAL_TREASURER = 0xce73904422880604e78591fD6c758B0D5106dD50; //TripsCommunity address
1316     address private constant ADDRESS_OG_LOOT = 0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7;
1317     address private constant PH_USERS = address(1);
1318     address private constant PH_PATRONS = address(2);
1319     address private constant PH_OG_LOOT = address(3);
1320     address private constant PH_CONQUERORS = address(4);
1321     address private constant PH_OWNER = address(0);
1322 
1323     uint16 public constant MAX_ID = 10000;
1324     uint16 public constant MAX_FOR_OWNER = 100;
1325     uint16 public constant MAX_FOR_GUILDS = 900;
1326     uint16 public constant LOCK_TIME = 5760 * 3; //it's three days
1327     struct Traveler {
1328         string familyType;
1329         string familyName;
1330         string color;
1331         uint256 counter;
1332         bool verified;
1333     }
1334 
1335     struct Conqueror {
1336       address addr;
1337       uint16 count;
1338       bool elected;
1339     }
1340 
1341     struct Treasurer {
1342       address old;
1343       address current;
1344       uint256 blockNumber;
1345     }
1346 
1347     struct Initial{
1348         address addr;
1349         string symbol;
1350     }
1351     Conqueror public conqueror;
1352     Treasurer public treasurer;
1353     bool public canChangeTreasurer = true;
1354     mapping(address => Traveler) public detailsByAddress;
1355     mapping(uint256 => address) public addressList;
1356     uint8 public counterOwner = 0;
1357     uint16 public counterStandard = 0;
1358     uint16 public counterGuild = 0;
1359     uint16 public counterPatrons = 0;
1360     uint160 public priceForPatrons = INITIAL_PRICE_FOR_PATRONS;
1361     uint256 public blockActivation = 0;
1362     string[] private categories = ["ENVIRONMENT","TALENT","PLACE","CHARACTER","TRANSPORT","LANGUAGE","EXPERIENCE","OCCUPATION","ACCOMMODATION","BAG"];
1363 
1364     address[] public whiteListedGuilds;
1365     mapping(string => string[]) elements;
1366 
1367 
1368 
1369     constructor() ERC721("TravelerLoot", "TRVLR") Ownable(){
1370       uint256 blockNumber = block.number;
1371       treasurer.old = address(0);
1372       treasurer.current = INITIAL_TREASURER;
1373       treasurer.blockNumber = blockNumber;
1374       elements[categories[0]] = ["Beaches", "Mountains", "Urban", "Countrysides", "Lakes", "Rivers", "Farms", "Tropical areas", "Snowy places", "Forests", "Historical cities", "Islands", "Wilderness", "Deserts", "Natural parks", "Old towns", "Lakes", "Villages", "Forests", "Coral Reefs", "Wetlands", "Rainforests", "Grasslands", "Chaparral"];
1375       elements[categories[1]] = ["Cooking", "Painting", "Basketball", "Tennis", "Football", "Soccer", "Climbing", "Surfing", "Photographer", "Fishing", "Painting", "Writing", "Dancing", "Architecture", "Singing", "Dancing", "Baking", "Running", "Sword-fighting", "Boxing", "Jumping", "Climbing", "Hiking", "Kitesurfing", "Sailing", "Comforting others", "Flipping NFTs", "Katana sword fighter", "Programming Solidity", "Creating Memes"];
1376       elements[categories[2]] = ["Eiffel Tower", "Colosseum", "Taj Mahal", "Forbidden City", "Las Vegas", "Sagrada Familia", "Statue of Liberty", "Pompeii", "Tulum", "St. Peter's Basilica", "Bangkok", "Tower of London", "Alhambra", "San Marco Square", "Ciudad de las Artes y las Ciencias", "Moscow Kremlin", "Copacabana", "Great Wall of China", "Havana", "Arc de Triomphe", "Neuschwanstein Castle", "Machu Picchu", "Gili Islands", "Maya Bay", "Etherscan", "0x0000000000000000000000000000000000000000", "::1", "42.452483,-6.051345","Parcel 0, CityDAO", "Wyoming"];
1377       elements[categories[3]] = ["Energetic", "Good-Natured", "Enthusiastic", "Challenging", "Charismatic", "Wise", "Modest", "Honest", "Protective", "Perceptive", "Providential", "Prudent", "Spontaneous", "Insightful", "Intelligent", "Intuitive", "Precise", "Sharing", "Simple", "Sociable", "Sophisticated", "Benevolent", "Admirable", "Brilliant", "Accessible", "Calm", "Capable", "Optimistic", "Respectful", "Responsible"];
1378       elements[categories[4]] = ["Train", "Car", "Airplane", "Cruise", "4 wheel drive car", "Bus", "Convertible car", "Bicycle", "Motorbike", "Campervan", "Trailer", "Sailboat", "Electric car", "Sidecar", "Scooter", "Tram", "Cinquecento", "Hitch-hiking", "VW Beetle", "VW Bus", "Truck", "Off-road Vehicle", "Cab", "Lambo", "Ferrari", "Rocket", "DeLorean", "Kia Sedona", "Magic carpet", "Broomstick"];
1379       elements[categories[5]] = ["English", "Mandarin Chinese", "Hindi", "Spanish", "Arabic", "French", "Russian", "Portuguese", "Indonesian", "German", "Japanese", "Turkish", "Korean", "Vietnamese", "Iranian Persian", "Swahili", "Javanese", "Italian", "Thai", "Filipino", "Burmese", "Polish", "Croatian", "Danish", "Serbian", "Slovenian", "Czech", "Slovakian", "Greek", "Hungarian"];
1380       elements[categories[6]] = ["2", "3", "4", "5", "6", "7", "8", "9","10","100","0","1"];
1381       elements[categories[7]] = ["Host", "Cook", "Writer", "DeeJay", "Employee", "Doctor", "Traveler", "Tour Guide", "Ship Pilot", "DAO Member", "Driver", "NFT flipper", "Meme creator", "Sales Manager", "Play 2 Earner", "NFT collector", "Hotel receptionist", "Hotel Manager", "Digital Nomad", "Crypto Trader", "Head of Growth", "PoS validator", "Lightning Network Developer", "Anonymous DeFi Protocol Lead", "Yacht owner (in bull markets)", "Web3 Engineer", "Blockchain Consultant", "Crypto VC", "Miner","Metaverse Realtor"];
1382       elements[categories[8]] = ["Hotel", "Apartment", "Hostel", "Tent", "BnB", "Guest House", "Chalet", "Cottage", "Boat", "Caravan", "Motorhome", "5 stars Hotel", "Suite in 5 Stars Hotel", "Tipi", "Tree House", "Bungalow", "Ranch", "Co-living", "Gablefront cottage", "Longhouse", "Villa", "Yurt", "Housebarn", "Adobe House", "Castle", "Rammed earth", "Underground living", "Venetian palace", "Igloo", "Trullo"];
1383       elements[categories[9]] = ["Pen", "eBook reader", "Water", "Cigarettes", "Swiss knife", "Mobile phone", "Notebook", "Laptop", "Digital Camera", "Lighter", "Earphones", "Beauty case", "Toothbrush", "Toothpaste", "Slippers", "Shirts", "Pants", "T-shirts", "Socks", "Underwear","Condoms"];
1384 
1385       detailsByAddress[PH_USERS] = Traveler({color:BLACK,familyType:"",familyName:"",counter:0,verified:true});
1386       detailsByAddress[PH_PATRONS] = Traveler({color:"#F87151",familyType:PATRON,familyName:"",counter:0,verified:true});
1387       detailsByAddress[PH_OG_LOOT] = Traveler({color:GOLD,familyType:PATRON,familyName:"Loot (for Adventurers)",counter:0,verified:true});
1388       detailsByAddress[PH_CONQUERORS] = Traveler({color:WHITE,familyType:CONQUEROR,familyName:"",counter:0,verified:true});
1389       detailsByAddress[PH_OWNER] = Traveler({color:BLACK,familyType:" ",familyName:"",counter:0,verified:true});
1390 
1391       whiteListedGuilds.push(ADDRESS_OG_LOOT);
1392       detailsByAddress[ADDRESS_OG_LOOT] = Traveler({color:BLACK,familyType:PLATINUM,familyName:"LOOT",counter:0,verified:true});
1393     }
1394 
1395     modifier checkStart() {
1396       require(blockActivation > 0 && block.number >= blockActivation,ERROR_COME_BACK_LATER);
1397       _;
1398     }
1399 
1400     /// @notice                     Everyone can claim an available tokenId for free (+ gas)
1401     function claim() external nonReentrant checkStart {
1402         require(owner() != _msgSender(),ERROR_OWNER_NOT_ALLOWED);
1403         uint16 adjusted = 1 + counterStandard + MAX_FOR_GUILDS + MAX_FOR_OWNER;
1404         require(adjusted <= MAX_ID, ERROR_TOKEN_ID_INVALID);
1405         processing(adjusted,PH_USERS,1,false);
1406         _safeMint(_msgSender(), adjusted);
1407         counterStandard++;
1408     }
1409 
1410     /// @notice                     Guilds can use this function to mint a forged Traveler Loot.
1411     ///                             Forged TLs are recognizable by a colored line on the NFT.
1412     ///                             When all the forgeable TLs are minted, the guild who forged
1413     ///                             the most becomes Conqueror. Its members gain access to
1414     ///                             claimByConquerors() function
1415     /// @param                      tokenId         derivative's tokenId owned by the user
1416     /// @param                      contractAddress derivative's address pretending to be guild
1417     function claimByGuilds(uint256 tokenId, address contractAddress) external nonReentrant checkStart{
1418         require(!conqueror.elected, ERROR_COMPETITION_ENDED);
1419         Traveler storage details = detailsByAddress[contractAddress];
1420         require(details.verified, ERROR_ADDRESS_NOT_VERIFIED);
1421         IERC721 looter = IERC721(contractAddress);
1422         require(tokenId > 0 && looter.ownerOf(tokenId) == _msgSender(), ERROR_NOT_THE_OWNER);
1423         if (details.counter == 0 && contractAddress != whiteListedGuilds[0]){
1424             details.color = pickAColor();
1425         }
1426         uint16 discretId = uint16(tokenId % MAX_FOR_GUILDS);
1427 
1428         if (counterGuild == MAX_FOR_GUILDS - 1 ){
1429             (conqueror.addr, conqueror.count) = whoIsWinning();
1430             conqueror.elected = true;
1431             detailsByAddress[PH_CONQUERORS].color = details.color;
1432             detailsByAddress[PH_CONQUERORS].familyName = details.familyName;
1433         }
1434         // after this mint, the price for patrons will be increased by 1%
1435         uint16 finalId = discretId == 0 ? MAX_FOR_GUILDS : discretId;
1436         processing(finalId, contractAddress, 1, true);
1437         _safeMint(_msgSender(), finalId);
1438         counterGuild++;
1439     }
1440 
1441     /// @notice                     Becoming a Patron. Requires payment
1442     function claimByPatrons() external payable nonReentrant checkStart{
1443       require(msg.value >= priceForPatrons, ERROR_LOW_VALUE);
1444       if (priceForPatrons < INITIAL_PRICE_FOR_PATRONS){
1445         priceForPatrons == INITIAL_PRICE_FOR_PATRONS;
1446       }
1447       // After this mint, the price for next patrons will be increased by 5%
1448       reservedMinting(PH_PATRONS, 5, true);
1449       counterPatrons++;
1450     }
1451 
1452     /// @notice                     - Loot (for Adventurers) holders can become Patrons for free if:
1453     ///                             . the Conqueror Guild is not yet elected,
1454     ///                             . or Dominik Hoffman (@ dhof on twitter) is still younger than 40 y/o.
1455     function claimByOGLooters() external nonReentrant checkStart{
1456       require(IERC721(whiteListedGuilds[0]).balanceOf(_msgSender()) > 0, ERROR_NOT_THE_OWNER);
1457       require(!conqueror.elected, ERROR_COMPETITION_ENDED);
1458       require(block.timestamp <= DISCOUNT_EXPIRATION, ERROR_DOM_40TH_BIRTHDAY);
1459 
1460       // After this mint, the price for patrons will be decreased by 5%
1461       reservedMinting(PH_OG_LOOT, 5, false);
1462       counterPatrons++;
1463     }
1464 
1465     /// @notice                     Conquerors can mint a CONQUEROR Traveler Loot for free + gas
1466     ///                             only valid if they have not already minted a PATRON type before
1467     function claimByConquerors() external nonReentrant checkStart{
1468         require(conqueror.elected, ERROR_COMPETITION_ONGOING);
1469         require(IERC721(conqueror.addr).balanceOf(_msgSender()) > 0, ERROR_NOT_THE_OWNER);
1470         // After this mint, the price for patrons is increased by 2%
1471         reservedMinting(PH_CONQUERORS, 2, true);
1472         counterPatrons++;
1473     }
1474 
1475     /// @notice                     Owner can claim its reserved tokenIds.
1476     function claimByOwner() external nonReentrant onlyOwner checkStart{
1477         uint16 adjusted = 1 + counterOwner + MAX_FOR_GUILDS;
1478         require(adjusted <= MAX_FOR_GUILDS + MAX_FOR_OWNER, ERROR_TOKEN_ID_INVALID);
1479         //after this mint, the price for patrons will remain the same
1480         processing(adjusted,PH_OWNER,0,true);
1481         _safeMint(_msgSender(), adjusted);
1482         counterOwner++;
1483     }
1484 
1485     /// @notice                     Owner can call this function to activate the mintings.
1486     ///                             Note that the activation is delayed of LOCK_TIME blocks
1487     function activateClaims() external onlyOwner{
1488       require (blockActivation == 0, ERROR_ALREADY_ACTIVATED);
1489       blockActivation = block.number + LOCK_TIME;
1490     }
1491 
1492     /// @notice                     Owner can order the withdraw all the funds coming from Patron mints
1493     ///                             to the Treasurer address previously set.
1494     function withdraw() external onlyOwner {
1495       require(block.number >= treasurer.blockNumber, ERROR_COME_BACK_LATER);
1496       canChangeTreasurer = true; //release treasurer
1497       payable(treasurer.current).transfer(address(this).balance);
1498     }
1499 
1500 
1501     /// @notice                     . Owner calls this function with lockTreasurer = true if the intent is
1502     ///                             to do a donation to a public-good project. Lock guarantees that nobody
1503     ///                             (not even the owner) can change treasurer till the donation is made.
1504     ///                             . Owner calls this function with lockTreasurer = false if the intent is
1505     ///                             to keep open the chance to change the treasurer even if no any
1506     ///                             withdrawal has been performed in the meanwhile.
1507     /// @param      newAddress      the new treasurer address
1508     /// @param      lockTreasurer   true if the the treasurer has to be locked till one withdraw is performed
1509     function setTreasurer(address newAddress, bool lockTreasurer) external onlyOwner{
1510       require(canChangeTreasurer, ERROR_WITHDRAW_NEEDED); //this is a safety measure for when donating to public goods
1511       if (lockTreasurer){
1512         canChangeTreasurer = false;
1513       }
1514       uint256 blockNumber = block.number + LOCK_TIME;
1515       treasurer.old = treasurer.current;
1516       treasurer.current = newAddress;
1517       treasurer.blockNumber = blockNumber;
1518     }
1519 
1520     /// @notice                     You can register new Guilds to the whitelist, if:
1521     ///                             - You own at least 50 Traveler Loots in your address
1522     ///                             - Or if you have mint a Patron version by using claimByPatrons() or
1523     ///                             claimByOGLooters() functions (no matter if you dont own them anymore)
1524     ///                             - Or if you are the owner of this Contract
1525     ///                             NOTE: no Guilds can be registered once the competition has ended
1526     /// @param      addresses       List of contract addresses to be whitelisted for the game.
1527     ///                             They'll be allowed to mint GUILD type Traveler Loot
1528     function addNewGuildToWhiteList(address[] calldata addresses) nonReentrant external {
1529         require(!conqueror.elected, ERROR_COMPETITION_ENDED);
1530         for (uint8 j = 0; j< addresses.length; j++){
1531             address addr = addresses[j];
1532             require(address(this) != addr, ERROR_CANNOT_ADD_THIS_CONTRACT);
1533             require(IERC721(address(this)).balanceOf(_msgSender()) > 50
1534                         || _exists(uint160(_msgSender()))
1535                         || owner() == _msgSender()
1536                     ,ERROR_NOT_ENTITLED);
1537             for (uint16 i = 0; i < whiteListedGuilds.length; i++){
1538                 require(whiteListedGuilds[i] != addr, ERROR_GUILD_ALREADY_WHITELISTED);
1539             }
1540             whiteListedGuilds.push(addr);
1541             detailsByAddress[addr] = Traveler({color:BLACK,familyType:GUILD,familyName:familyName(addr),counter:0,verified:true});
1542         }
1543     }
1544 
1545     /// @notice                     Given a Guild address, returns the count for that addr
1546     /// @param      addr            Address of the Guild to be checked (the contract address)
1547     /// @return                     Number of the NFT minted from the members of the given Guild address
1548     function getCounterForAddress(address addr) external view returns (uint256){
1549         Traveler memory details = detailsByAddress[addr];
1550         require(details.verified, ERROR_ADDRESS_NOT_VERIFIED);
1551         return details.counter;
1552     }
1553 
1554     /// @notice                     Call this function if you want to know the list of the current Guilds
1555     /// return                      Array containing the addresses of all the whitelisted guilds
1556     function getWhiteListedGuilds() external view returns (address[] memory){
1557         return whiteListedGuilds;
1558     }
1559 
1560     /// @notice                     Call this function to see the element for a given tokenId and categoryId
1561     /// @param      tokenId         The id of the Traveler Loot you want to check
1562     /// @param      categoryId      The category of the Traveler Loot you want to check
1563     /// @return                     The element of the given Token Id for the given categoryId
1564     function getElement(uint256 tokenId, uint8 categoryId) public view returns (string memory){
1565       return pluck(tokenId, categories[categoryId], elements[categories[categoryId]]);
1566     }
1567 
1568     /// @notice                     Provides metadata and image of the PATRONS and CONQUEROR
1569     /// @param      addr            Address of the user who minted the PATRON or CONQUEROR you are checking
1570     /// @return                     The json containing the NFT info
1571     function addressURI(address addr) external view returns (string memory){
1572         return tokenURI(uint160(addr));
1573     }
1574 
1575     /// @notice                     Provides metadata and image of the Traveler Loot
1576     /// @param      tokenId         Token if of the Traveler Loot to process
1577     /// @return                     The json containing the NFT info
1578     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1579         Traveler memory details = detailsByAddress[addressList[tokenId]];
1580         string[4] memory parts;
1581         parts[0] = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.b { fill:white; font-family: serif; font-size: 14px; }</style> <rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="b">'));
1582         parts[1] = string(abi.encodePacked(getElement(tokenId,0),'</text><text x="10" y="40" class="b">',getElement(tokenId,1),'</text><text x="10" y="60" class="b">',getElement(tokenId,2),'</text><text x="10" y="80" class="b">',getElement(tokenId,3),'</text><text x="10" y="100" class="b">',getElement(tokenId,4),'</text><text x="10" y="120" class="b">',getElement(tokenId,5)));
1583         parts[2] = string(abi.encodePacked('</text><text x="10" y="140" class="b">',getElement(tokenId,6),'</text><text x="10" y="160" class="b">',getElement(tokenId,7),'</text><text x="10" y="180" class="b">',getElement(tokenId,8),'</text><text x="10" y="200" class="b">',getElement(tokenId,9),'</text>'));
1584         parts[3] = string(abi.encodePacked('<line x1="0" x2="350" y1="300" y2="300" stroke="',details.color,'" stroke-width="4"/>','<text x="340" y="294" text-anchor="end" class="b">',details.familyType,'</text></svg>'));
1585 
1586         string memory compact = string(abi.encodePacked(parts[0], parts[1], parts[2],parts[3]));
1587         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Traveler #', toString(tokenId), '", "description": "Traveler Loot is a Loot derivative for the Travel Industry, generated and stored on chain. Feel free to use the Traveler Loot in any way you want", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(compact)), '","attributes":[',metadata(tokenId,details),']}'))));
1588 
1589         return string(abi.encodePacked('data:application/json;base64,', json));
1590     }
1591 
1592     /// @notice                     Call this method to check the Guild which is owning the most Forged Traveler Loot
1593     ///
1594     /// @return                     The address of the guild who has the most Forged Traveler Loot so far
1595     /// @return                     The amount of Forged Traveler Loot minted by the Winning Guild so far
1596     function whoIsWinning() public view returns (address, uint16){
1597       if (conqueror.elected){
1598         return (conqueror.addr,conqueror.count);
1599       }
1600       address winningLoot = whiteListedGuilds[0];
1601       uint16 winningCount = uint16(detailsByAddress[winningLoot].counter);
1602 
1603       for (uint8 i = 1; i < whiteListedGuilds.length; i++){
1604         address addr = whiteListedGuilds[i];
1605         (winningLoot, winningCount) = checkWinning(winningLoot,winningCount, addr, uint16(detailsByAddress[addr].counter));
1606       }
1607       return (winningLoot, winningCount);
1608     }
1609 
1610     /// @notice                     Call this function to get a random color using block difficulty, timestamp as seed
1611     /// @return                     A string containing the HEX number of a random color
1612     function pickAColor() internal view returns (string memory){
1613         string[16] memory list = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
1614         string memory color = "#";
1615         for (uint8 i=0; i<6;i++){
1616           uint rand = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, i )));
1617           color = string(abi.encodePacked(color,list[rand % list.length]));
1618         }
1619         return color;
1620     }
1621 
1622     /// @notice                     This function calls an external NFT contract and gets the symbol to be used into the metadata
1623     /// @param      addr            The address of the contract address to whitelist
1624     /// @return                     The symbol of the given external contract address
1625     function familyName(address addr) internal view returns (string memory){
1626       return IERC721Metadata(addr).symbol();
1627     }
1628 
1629     function random(string memory input) internal pure returns (uint256) {
1630         return uint256(keccak256(abi.encodePacked(input)));
1631     }
1632 
1633     /// @notice                     Update the PATRON price and the address counter
1634     /// @param      id              TokenId minted
1635     /// @param      addr            address Guild of the token to mint
1636     /// @param      percentage      percentage number of the PATRON'price variability
1637     /// @param      isPositive      true if the variability is positive, false if it's negative
1638     function processing(uint256 id, address addr, uint8 percentage, bool isPositive) internal{
1639       if (percentage != 0){
1640         uint160 x = priceForPatrons / (100 / percentage);
1641         priceForPatrons = isPositive ? priceForPatrons + x : priceForPatrons - x;
1642       }
1643       detailsByAddress[addr].counter++;
1644       addressList[id] = addr;
1645     }
1646 
1647     /// @notice                     It mints the Traveler Loot using the address as tokenId.
1648     ///                             Only particular cases can access to this:
1649     ///                             - Users who decide to become Patrons by paying the patronPrice
1650     ///                             - Conqueror Guild members, as the prize for have won the competition
1651     ///                             - OG Loot owners, as privilegiate users till @ dhof 40 bday or till Conqueror Guild election
1652     /// @param      addr            address Guild of the token to mint
1653     /// @param      percentage      percentage number of the PATRON'price variability
1654     /// @param      isPositive      true if the variability is positive, false if it's negative
1655     function reservedMinting(address addr,uint8 percentage, bool isPositive) internal{
1656       uint160 castedAddress = uint160(_msgSender());
1657       require(castedAddress > MAX_ID, ERROR_ADDRESS_NOT_VERIFIED);
1658       processing(castedAddress, addr, percentage, isPositive);
1659       _safeMint(_msgSender(), castedAddress);
1660     }
1661 
1662     /// @notice                     Call this function to get pick the element for a given Traveler Loot id and category
1663     /// @param      tokenId         TokenId
1664     /// @param      keyPrefix       Seed/nounce of the randomity
1665     /// @param      sourceArray     The list of all the elements
1666     /// @return                     The element extracted
1667     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1668         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1669         uint8 toHoundred = uint8(rand % 100);
1670         uint8 delta = toHoundred > 95 ? 1 : toHoundred > 80 ? 2 : 3;
1671         uint8 len = uint8(sourceArray.length);
1672         uint8 x = len / 3;
1673         uint8 min = len - (delta * x);
1674         uint8 max = (len - 1) - ((delta - 1) * x);
1675         uint8 rand2 = uint8((random(string(abi.encodePacked(msg.sender, toHoundred, keyPrefix ))) % (max - min + 1)) + min);
1676         return sourceArray[rand2];
1677     }
1678 
1679     /// @dev                     This function processes and build the metadata for the given tokenId
1680     /// @param      tokenId         TokenId
1681     /// @param      details         The details to be used for filling the metadata
1682     /// @return                     The json with the metadata to be appended to the full json
1683     function metadata(uint256 tokenId, Traveler memory details) internal view returns (string memory){
1684      string memory toRet = "";
1685      for (uint8 i = 0; i < 10; i++){
1686         toRet = string(abi.encodePacked(toRet,'{"trait_type":"', categories[i], '","value":"',getElement(tokenId,i),'"},'));
1687      }
1688      if (keccak256(abi.encodePacked(details.color)) != keccak256(abi.encodePacked(BLACK))) {
1689       toRet = string(abi.encodePacked(toRet,'{"trait_type":"Type","value":"',details.familyType,'"}'));
1690       toRet = string(abi.encodePacked(toRet,',{"trait_type":"Flag Color","value":"',details.color,'"}'));
1691       toRet = string(abi.encodePacked(toRet,',{"trait_type":"',details.familyType,'","value":"',details.familyName,'"}'));
1692      }
1693      else{
1694         toRet = string(abi.encodePacked(toRet,'{"trait_type":"Type","value":"EXPLORER"}'));
1695      }
1696 
1697      return toRet;
1698    }
1699 
1700     /// @dev                     This function compares two Guilds and check which has more Froged Guild already minted
1701     /// @param      winningAddress  The legacy winning address (so far)
1702     /// @param      winningCount    The amount for the legacy winning address (so far)
1703     /// @param      newAddress      The new address to compare with legacy
1704     /// @param      newCount        The new amount to compare with legacy
1705     /// @return                     The new winning address after comparison
1706     /// @return                     The new minted amount of winning address after comparison
1707     function checkWinning(address winningAddress, uint16 winningCount, address newAddress, uint16 newCount) internal pure returns(address,uint16){
1708         return newCount > winningCount ? (newAddress, newCount) : (winningAddress, winningCount);
1709     }
1710 
1711     function toString(uint256 value) internal pure returns (string memory) {
1712     // Inspired by OraclizeAPI's implementation - MIT license
1713     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1714 
1715         if (value == 0) {
1716             return "0";
1717         }
1718         uint256 temp = value;
1719         uint256 digits;
1720         while (temp != 0) {
1721             digits++;
1722             temp /= 10;
1723         }
1724         bytes memory buffer = new bytes(digits);
1725         while (value != 0) {
1726             digits -= 1;
1727             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1728             value /= 10;
1729         }
1730         return string(buffer);
1731     }
1732 }
1733 
1734 
1735 /// [MIT License]
1736 /// @title Base64
1737 /// @notice Provides a function for encoding some bytes in base64
1738 /// @author Brecht Devos <brecht@loopring.org>
1739 library Base64 {
1740 
1741     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1742 
1743     /// @notice Encodes some bytes to the base64 representation
1744     function encode(bytes memory data) internal pure returns (string memory) {
1745         uint256 len = data.length;
1746         if (len == 0) return "";
1747 
1748         // multiply by 4/3 rounded up
1749         uint256 encodedLen = 4 * ((len + 2) / 3);
1750 
1751         // Add some extra buffer at the end
1752         bytes memory result = new bytes(encodedLen + 32);
1753 
1754         bytes memory table = TABLE;
1755 
1756         assembly {
1757             let tablePtr := add(table, 1)
1758             let resultPtr := add(result, 32)
1759 
1760             for {
1761                 let i := 0
1762             } lt(i, len) {
1763 
1764             } {
1765                 i := add(i, 3)
1766                 let input := and(mload(add(data, i)), 0xffffff)
1767 
1768                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1769                 out := shl(8, out)
1770                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1771                 out := shl(8, out)
1772                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1773                 out := shl(8, out)
1774                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1775                 out := shl(224, out)
1776 
1777                 mstore(resultPtr, out)
1778 
1779                 resultPtr := add(resultPtr, 4)
1780             }
1781 
1782             switch mod(len, 3)
1783             case 1 {
1784                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1785             }
1786             case 2 {
1787                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1788             }
1789 
1790             mstore(result, encodedLen)
1791         }
1792 
1793         return string(result);
1794     }
1795 }