1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and make it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Interface of the ERC165 standard, as defined in the
69  * https://eips.ethereum.org/EIPS/eip-165[EIP].
70  *
71  * Implementers can declare support of contract interfaces, which can then be
72  * queried by others ({ERC165Checker}).
73  *
74  * For an implementation, see {ERC165}.
75  */
76 interface IERC165 {
77     /**
78      * @dev Returns true if this contract implements the interface defined by
79      * `interfaceId`. See the corresponding
80      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
81      * to learn more about how these ids are created.
82      *
83      * This function call must use less than 30 000 gas.
84      */
85     function supportsInterface(bytes4 interfaceId) external view returns (bool);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
90 
91 
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Required interface of an ERC721 compliant contract.
97  */
98 interface IERC721 is IERC165 {
99     /**
100      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
103 
104     /**
105      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
106      */
107     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
108 
109     /**
110      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
111      */
112     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
113 
114     /**
115      * @dev Returns the number of tokens in ``owner``'s account.
116      */
117     function balanceOf(address owner) external view returns (uint256 balance);
118 
119     /**
120      * @dev Returns the owner of the `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function ownerOf(uint256 tokenId) external view returns (address owner);
127 
128     /**
129      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
130      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
131      *
132      * Requirements:
133      *
134      * - `from` cannot be the zero address.
135      * - `to` cannot be the zero address.
136      * - `tokenId` token must exist and be owned by `from`.
137      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
139      *
140      * Emits a {Transfer} event.
141      */
142     function safeTransferFrom(
143         address from,
144         address to,
145         uint256 tokenId
146     ) external;
147 
148     /**
149      * @dev Transfers `tokenId` token from `from` to `to`.
150      *
151      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address from,
164         address to,
165         uint256 tokenId
166     ) external;
167 
168     /**
169      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
170      * The approval is cleared when the token is transferred.
171      *
172      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
173      *
174      * Requirements:
175      *
176      * - The caller must own the token or be an approved operator.
177      * - `tokenId` must exist.
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address to, uint256 tokenId) external;
182 
183     /**
184      * @dev Returns the account approved for `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function getApproved(uint256 tokenId) external view returns (address operator);
191 
192     /**
193      * @dev Approve or remove `operator` as an operator for the caller.
194      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
195      *
196      * Requirements:
197      *
198      * - The `operator` cannot be the caller.
199      *
200      * Emits an {ApprovalForAll} event.
201      */
202     function setApprovalForAll(address operator, bool _approved) external;
203 
204     /**
205      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
206      *
207      * See {setApprovalForAll}
208      */
209     function isApprovedForAll(address owner, address operator) external view returns (bool);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId,
228         bytes calldata data
229     ) external;
230 }
231 
232 
233 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
234 
235 
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @title ERC721 token receiver interface
241  * @dev Interface for any contract that wants to support safeTransfers
242  * from ERC721 asset contracts.
243  */
244 interface IERC721Receiver {
245     /**
246      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
247      * by `operator` from `from`, this function is called.
248      *
249      * It must return its Solidity selector to confirm the token transfer.
250      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
251      *
252      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
253      */
254     function onERC721Received(
255         address operator,
256         address from,
257         uint256 tokenId,
258         bytes calldata data
259     ) external returns (bytes4);
260 }
261 
262 
263 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
264 
265 
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
271  * @dev See https://eips.ethereum.org/EIPS/eip-721
272  */
273 interface IERC721Metadata is IERC721 {
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 }
289 
290 
291 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
292 
293 
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         assembly {
325             size := extcodesize(account)
326         }
327         return size > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain `call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(address(this).balance >= value, "Address: insufficient balance for call");
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 
511 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Provides information about the current execution context, including the
519  * sender of the transaction and its data. While these are generally available
520  * via msg.sender and msg.data, they should not be accessed in such a direct
521  * manner, since when dealing with meta-transactions the account sending and
522  * paying for execution may not be the actual sender (as far as an application
523  * is concerned).
524  *
525  * This contract is only required for intermediate, library-like contracts.
526  */
527 abstract contract Context {
528     function _msgSender() internal view virtual returns (address) {
529         return msg.sender;
530     }
531 
532     function _msgData() internal view virtual returns (bytes calldata) {
533         return msg.data;
534     }
535 }
536 
537 
538 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev String operations.
573  */
574 library Strings {
575     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
579      */
580     function toString(uint256 value) internal pure returns (string memory) {
581         // Inspired by OraclizeAPI's implementation - MIT licence
582         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
583 
584         if (value == 0) {
585             return "0";
586         }
587         uint256 temp = value;
588         uint256 digits;
589         while (temp != 0) {
590             digits++;
591             temp /= 10;
592         }
593         bytes memory buffer = new bytes(digits);
594         while (value != 0) {
595             digits -= 1;
596             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
597             value /= 10;
598         }
599         return string(buffer);
600     }
601 
602     /**
603      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
604      */
605     function toHexString(uint256 value) internal pure returns (string memory) {
606         if (value == 0) {
607             return "0x00";
608         }
609         uint256 temp = value;
610         uint256 length = 0;
611         while (temp != 0) {
612             length++;
613             temp >>= 8;
614         }
615         return toHexString(value, length);
616     }
617 
618     /**
619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
620      */
621     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
622         bytes memory buffer = new bytes(2 * length + 2);
623         buffer[0] = "0";
624         buffer[1] = "x";
625         for (uint256 i = 2 * length + 1; i > 1; --i) {
626             buffer[i] = _HEX_SYMBOLS[value & 0xf];
627             value >>= 4;
628         }
629         require(value == 0, "Strings: hex length insufficient");
630         return string(buffer);
631     }
632 }
633 
634 
635 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
636 
637 
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Contract module which provides a basic access control mechanism, where
643  * there is an account (an owner) that can be granted exclusive access to
644  * specific functions.
645  *
646  * By default, the owner account will be the one that deploys the contract. This
647  * can later be changed with {transferOwnership}.
648  *
649  * This module is used through inheritance. It will make available the modifier
650  * `onlyOwner`, which can be applied to your functions to restrict their use to
651  * the owner.
652  */
653 abstract contract Ownable is Context {
654     address private _owner;
655 
656     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
657 
658     /**
659      * @dev Initializes the contract setting the deployer as the initial owner.
660      */
661     constructor() {
662         _setOwner(_msgSender());
663     }
664 
665     /**
666      * @dev Returns the address of the current owner.
667      */
668     function owner() public view virtual returns (address) {
669         return _owner;
670     }
671 
672     /**
673      * @dev Throws if called by any account other than the owner.
674      */
675     modifier onlyOwner() {
676         require(owner() == _msgSender(), "Ownable: caller is not the owner");
677         _;
678     }
679 
680     /**
681      * @dev Leaves the contract without owner. It will not be possible to call
682      * `onlyOwner` functions anymore. Can only be called by the current owner.
683      *
684      * NOTE: Renouncing ownership will leave the contract without an owner,
685      * thereby removing any functionality that is only available to the owner.
686      */
687     function renounceOwnership() public virtual onlyOwner {
688         _setOwner(address(0));
689     }
690 
691     /**
692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
693      * Can only be called by the current owner.
694      */
695     function transferOwnership(address newOwner) public virtual onlyOwner {
696         require(newOwner != address(0), "Ownable: new owner is the zero address");
697         _setOwner(newOwner);
698     }
699 
700     function _setOwner(address newOwner) private {
701         address oldOwner = _owner;
702         _owner = newOwner;
703         emit OwnershipTransferred(oldOwner, newOwner);
704     }
705 }
706 
707 pragma solidity ^0.8.10;
708 
709 //***********************
710 //Developed by Mercurial
711 //***********************
712 
713 abstract contract ERC721BaseTKC is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     string private _name;
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     address[] internal _owners;
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
734     /**
735      * @dev Returns the total supplied tokens. Note we are not supporting IERC721Enumerable in the supportsInterface call.
736      */
737     function totalSupply() public view virtual returns (uint256) {
738         return _owners.length;
739     }
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
744         return
745             interfaceId == type(IERC721).interfaceId ||
746             interfaceId == type(IERC721Metadata).interfaceId ||
747             super.supportsInterface(interfaceId);
748     }
749 
750     /**
751      * @dev See {IERC721-balanceOf}.
752      */
753     function balanceOf(address owner) public view virtual override returns (uint256) {
754         require(owner != address(0), "ERC721: balance query for the zero address");
755 
756         uint count = 0;
757         uint length = _owners.length;
758         for(uint i = 0; i < length; ++i){
759           if(owner == _owners[i]){
760             ++count;
761           }
762         }
763 
764         delete length;
765         return count;
766     }
767 
768     /**
769      * @dev See {IERC721-ownerOf}.
770      */
771     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
772         address owner = _owners[tokenId];
773         require(owner != address(0), "ERC721: owner query for nonexistent token");
774         return owner;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-name}.
779      */
780     function name() public view virtual override returns (string memory) {
781         return _name;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-symbol}.
786      */
787     function symbol() public view virtual override returns (string memory) {
788         return _symbol;
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public virtual override {
795         address owner = ERC721BaseTKC.ownerOf(tokenId);
796         require(to != owner, "ERC721: approval to current owner");
797 
798         require(
799             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800             "ERC721: approve caller is not owner nor approved for all"
801         );
802 
803         _approve(to, tokenId);
804     }
805 
806     /**
807      * @dev See {IERC721-getApproved}.
808      */
809     function getApproved(uint256 tokenId) public view virtual override returns (address) {
810         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
811 
812         return _tokenApprovals[tokenId];
813     }
814 
815     /**
816      * @dev See {IERC721-setApprovalForAll}.
817      */
818     function setApprovalForAll(address operator, bool approved) public virtual override {
819         require(operator != _msgSender(), "ERC721: approve to caller");
820 
821         _operatorApprovals[_msgSender()][operator] = approved;
822         emit ApprovalForAll(_msgSender(), operator, approved);
823     }
824 
825     /**
826      * @dev See {IERC721-isApprovedForAll}.
827      */
828     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
829         return _operatorApprovals[owner][operator];
830     }
831 
832 
833     /**
834      * @dev See {IERC721-transferFrom}.
835      */
836     function transferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         //solhint-disable-next-line max-line-length
842         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
843 
844         _transfer(from, to, tokenId);
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public virtual override {
855         safeTransferFrom(from, to, tokenId, "");
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) public virtual override {
867         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
868         _safeTransfer(from, to, tokenId, _data);
869     }
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
873      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
874      *
875      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
876      *
877      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
878      * implement alternative mechanisms to perform token transfer, such as signature-based.
879      *
880      * Requirements:
881      *
882      * - `from` cannot be the zero address.
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must exist and be owned by `from`.
885      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _safeTransfer(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) internal virtual {
895         _transfer(from, to, tokenId);
896         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
897     }
898 
899     /**
900      * @dev Returns whether `tokenId` exists.
901      *
902      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
903      *
904      * Tokens start existing when they are minted (`_mint`),
905      * and stop existing when they are burned (`_burn`).
906      */
907     function _exists(uint256 tokenId) internal view virtual returns (bool) {
908         return tokenId < _owners.length && _owners[tokenId] != address(0);
909     }
910 
911     /**
912      * @dev Returns whether `spender` is allowed to manage `tokenId`.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      */
918     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
919         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
920         address owner = ERC721BaseTKC.ownerOf(tokenId);
921         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
922     }
923 
924     /**
925      * @dev Safely mints `tokenId` and transfers it to `to`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must not exist.
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeMint(address to, uint256 tokenId) internal virtual {
935         _safeMint(to, tokenId, "");
936     }
937 
938 
939     /**
940      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
941      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
942      */
943     function _safeMint(
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) internal virtual {
948         _mint(to, tokenId);
949         require(
950             _checkOnERC721Received(address(0), to, tokenId, _data),
951             "ERC721: transfer to non ERC721Receiver implementer"
952         );
953     }
954 
955     /**
956      * @dev Mints `tokenId` and transfers it to `to`.
957      *
958      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
959      *
960      * Requirements:
961      *
962      * - `tokenId` must not exist.
963      * - `to` cannot be the zero address.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _mint(address to, uint256 tokenId) internal virtual {
968         require(to != address(0), "ERC721: mint to the zero address");
969         require(!_exists(tokenId), "ERC721: token already minted");
970 
971         _beforeTokenTransfer(address(0), to, tokenId);
972         _owners.push(to);
973 
974         emit Transfer(address(0), to, tokenId);
975     }
976 
977     /**
978      * @dev Destroys `tokenId`.
979      * The approval is cleared when the token is burned.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _burn(uint256 tokenId) internal virtual {
988         address owner = ERC721BaseTKC.ownerOf(tokenId);
989 
990         _beforeTokenTransfer(owner, address(0), tokenId);
991 
992         // Clear approvals
993         _approve(address(0), tokenId);
994         _owners[tokenId] = address(0);
995 
996         emit Transfer(owner, address(0), tokenId);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) internal virtual {
1015         require(ERC721BaseTKC.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1016         require(to != address(0), "ERC721: transfer to the zero address");
1017 
1018         _beforeTokenTransfer(from, to, tokenId);
1019 
1020         // Clear approvals from the previous owner
1021         _approve(address(0), tokenId);
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(address to, uint256 tokenId) internal virtual {
1033         _tokenApprovals[tokenId] = to;
1034         emit Approval(ERC721BaseTKC.ownerOf(tokenId), to, tokenId);
1035     }
1036 
1037 
1038     /**
1039      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1040      * The call is not executed if the target address is not a contract.
1041      *
1042      * @param from address representing the previous owner of the given token ID
1043      * @param to target address that will receive the tokens
1044      * @param tokenId uint256 ID of the token to be transferred
1045      * @param _data bytes optional data to send along with the call
1046      * @return bool whether the call correctly returned the expected magic value
1047      */
1048     function _checkOnERC721Received(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) private returns (bool) {
1054         if (to.isContract()) {
1055             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1056                 return retval == IERC721Receiver.onERC721Received.selector;
1057             } catch (bytes memory reason) {
1058                 if (reason.length == 0) {
1059                     revert("ERC721: transfer to non ERC721Receiver implementer");
1060                 } else {
1061                     assembly {
1062                         revert(add(32, reason), mload(reason))
1063                     }
1064                 }
1065             }
1066         } else {
1067             return true;
1068         }
1069     }
1070 
1071     /**
1072      * @dev Hook that is called before any token transfer. This includes minting
1073      * and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` will be minted for `to`.
1080      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1081      * - `from` and `to` are never both zero.
1082      *
1083      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1084      */
1085     function _beforeTokenTransfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual {}
1090 }
1091 
1092 pragma solidity ^0.8.10;
1093 
1094 //****************************************
1095 //Developed by Mercurial (@Mercurial__me)
1096 //****************************************
1097 
1098 contract KRAKEN is ERC721BaseTKC, Ownable, ReentrancyGuard{
1099     using Strings for uint256;
1100     string public provenanceHash;
1101     string private _tokenBaseURI;
1102     
1103     // Sale params
1104     uint256 public cost = 0.08 ether;
1105     uint256 public tokensMaxPerTx = 8; // Public sale
1106     uint256 public tokensMaxPerWallet = 4; // Presale
1107     uint256 public tokensReserved = 88;
1108     uint256 public tokensMaxPresaleSupply = 500;
1109     uint256 public tokensMaxSupply = 888;
1110     uint256 public totalGifted;
1111     bool public isPublicSaleActive = false;
1112     bool public isPresaleActive = false;
1113 
1114     mapping(address => uint256) public presaleAllowlist;
1115 
1116     constructor() ERC721BaseTKC("The Kraken Collective", "KRAKEN") { }
1117     function mint(uint256 _mintQty) external payable nonReentrant{
1118         require(isPublicSaleActive, "SALE NOT ACTIVE");
1119         require(_mintQty <= tokensMaxPerTx, "EXCEEDING MINT LIMIT OF 8/TX");
1120         require(msg.value >= cost * _mintQty , "INSUFFICIENT ETH");
1121         uint256 supply = _owners.length;
1122         require(supply + tokensReserved + _mintQty - totalGifted <= tokensMaxSupply, "EXCEEDING TOTAL SUPPLY");
1123         for(uint256 i; i < _mintQty; i++) {
1124             _safeMint(msg.sender, supply++, "");
1125         }
1126     }
1127     function mintPresale(uint256 _mintQty) external payable {
1128         require(isPresaleActive, "PRESALE NOT ACTIVE");
1129         require(msg.value >= cost * _mintQty , "INSUFFICIENT ETH");
1130         uint256 reserve = presaleAllowlist[msg.sender];
1131         require(reserve > 0, "LOW RESERVE OR USER NOT WHITELISTED");
1132         require(_mintQty <= reserve, "TRY LESS");
1133         uint256 supply = _owners.length;
1134         require(supply + _mintQty - totalGifted <= tokensMaxPresaleSupply, "EXCEEDING MAX PRESALE SUPPLY");
1135         presaleAllowlist[msg.sender] = reserve - _mintQty;
1136         delete reserve;
1137         for(uint256 i; i < _mintQty; i++) {
1138             _safeMint( msg.sender, supply++, "");
1139         }
1140     }
1141     function gift(address[] calldata recipient, uint[] calldata quantity) external onlyOwner{
1142         require(recipient.length == quantity.length, "RECIPIENT AND QUANTITY NOT EQUAL LENGTH");
1143         uint256 totalQuantity = 0;
1144         uint256 supply = _owners.length;
1145         for(uint256 i=0; i < quantity.length; i++){
1146             totalQuantity += quantity[i];
1147         }
1148         require(totalQuantity <= tokensReserved, "EXCEEDING RESERVED SUPPLY TXN");
1149         require(supply + totalQuantity <= tokensMaxSupply, "EXCEEDING TOTAL SUPPLY");
1150         delete totalQuantity;
1151         for(uint256 i; i < recipient.length; i++){
1152             for(uint256 j; j < quantity[i]; j++){
1153                 totalGifted++;
1154                 _safeMint(recipient[i], supply++, "");
1155             }
1156         }
1157     }
1158     function withdraw() external onlyOwner {
1159         uint256 sendAmount = address(this).balance;
1160         bool success;
1161 
1162         address wade = payable(0x096a9d16AFFD7fB6b881dA383723bB10180Cc333);
1163         address tim = payable(0x1435Db7390300EB252C806df378ecC882c041641);
1164         address mark = payable(0x1e16870873b28d956f8EBCb5179E518f8A9f89B5);
1165         address community = payable(0x14967Af4019989557489E2621b22C76d6404D2Cd); 
1166 
1167         (success, ) = wade.call{value: (sendAmount * 174/1000)}("");
1168         require(success, "Transaction Unsuccessful");
1169 
1170         (success, ) = tim.call{value: (sendAmount * 313/1000)}("");
1171         require(success, "Transaction Unsuccessful");
1172 
1173         (success, ) = mark.call{value: (sendAmount * 313/1000)}("");
1174         require(success, "Transaction Unsuccessful");
1175 
1176         (success, ) = community.call{value: (sendAmount * 200/1000)}("");
1177         require(success, "Transaction Unsuccessful");
1178     }
1179     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1180         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1181         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1182     }
1183     // Setters
1184     function setBaseURI(string calldata URI) external onlyOwner {
1185         _tokenBaseURI = URI;
1186     }
1187     function setprovenanceHash(string calldata _newHash) external onlyOwner {
1188         provenanceHash = _newHash;
1189     }
1190     function settokensMaxSupply(uint256 _newMax) external onlyOwner {
1191         tokensMaxSupply = _newMax;
1192     }
1193     function settokensMaxPresaleSupply(uint256 _newMax) external onlyOwner {
1194         tokensMaxPresaleSupply = _newMax;
1195     }
1196     function settokensMaxPerWallet(uint256 _newMax) external onlyOwner {
1197         tokensMaxPerWallet = _newMax;
1198     }
1199     function presaleSet(address[] calldata _addresses) external onlyOwner {
1200         for(uint256 i; i < _addresses.length; i++){
1201             presaleAllowlist[_addresses[i]] = tokensMaxPerWallet;
1202         }
1203     }
1204     function setPreSaleState(bool _newState) public onlyOwner {
1205         isPresaleActive = _newState;
1206     }
1207     function setPublicSaleStatus(bool _newState) public onlyOwner {
1208         isPublicSaleActive = _newState;
1209     }
1210     receive() external payable {}
1211     fallback() external payable {}
1212 }