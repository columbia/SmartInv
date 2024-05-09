1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts@4.5.0/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts@4.5.0/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
183 
184 pragma solidity ^0.8.1;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      *
207      * [IMPORTANT]
208      * ====
209      * You shouldn't rely on `isContract` to protect against flash loan attacks!
210      *
211      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
212      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
213      * constructor.
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // This method relies on extcodesize/address.code.length, which returns 0
218         // for contracts in construction, since the code is only stored at the end
219         // of the constructor execution.
220 
221         return account.code.length > 0;
222     }
223 
224     /**
225      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
226      * `recipient`, forwarding all available gas and reverting on errors.
227      *
228      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
229      * of certain opcodes, possibly making contracts go over the 2300 gas limit
230      * imposed by `transfer`, making them unable to receive funds via
231      * `transfer`. {sendValue} removes this limitation.
232      *
233      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
234      *
235      * IMPORTANT: because control is transferred to `recipient`, care must be
236      * taken to not create reentrancy vulnerabilities. Consider using
237      * {ReentrancyGuard} or the
238      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
239      */
240     function sendValue(address payable recipient, uint256 amount) internal {
241         require(address(this).balance >= amount, "Address: insufficient balance");
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         require(success, "Address: unable to send value, recipient may have reverted");
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionCall(target, data, "Address: low-level call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
271      * `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, 0, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but also transferring `value` wei to `target`.
286      *
287      * Requirements:
288      *
289      * - the calling contract must have an ETH balance of at least `value`.
290      * - the called Solidity function must be `payable`.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
304      * with `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         require(isContract(target), "Address: static call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(isContract(target), "Address: delegate call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
377      * revert reason using the provided one.
378      *
379      * _Available since v4.3._
380      */
381     function verifyCallResult(
382         bool success,
383         bytes memory returndata,
384         string memory errorMessage
385     ) internal pure returns (bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721Receiver.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
408 
409 pragma solidity ^0.8.0;
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
434 // File: @openzeppelin/contracts@4.5.0/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts@4.5.0/utils/introspection/ERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts@4.5.0/token/ERC721/IERC721.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Approve or remove `operator` as an operator for the caller.
600      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 }
637 
638 // File: @openzeppelin/contracts@4.5.0/token/ERC721/extensions/IERC721Metadata.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
648  * @dev See https://eips.ethereum.org/EIPS/eip-721
649  */
650 interface IERC721Metadata is IERC721 {
651     /**
652      * @dev Returns the token collection name.
653      */
654     function name() external view returns (string memory);
655 
656     /**
657      * @dev Returns the token collection symbol.
658      */
659     function symbol() external view returns (string memory);
660 
661     /**
662      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
663      */
664     function tokenURI(uint256 tokenId) external view returns (string memory);
665 }
666 
667 // File: @openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol
668 
669 
670 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 
676 
677 
678 
679 
680 
681 /**
682  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
683  * the Metadata extension, but not including the Enumerable extension, which is available separately as
684  * {ERC721Enumerable}.
685  */
686 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
687     using Address for address;
688     using Strings for uint256;
689 
690     // Token name
691     string private _name;
692 
693     // Token symbol
694     string private _symbol;
695 
696     // Mapping from token ID to owner address
697     mapping(uint256 => address) private _owners;
698 
699     // Mapping owner address to token count
700     mapping(address => uint256) private _balances;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708     /**
709      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
710      */
711     constructor(string memory name_, string memory symbol_) {
712         _name = name_;
713         _symbol = symbol_;
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
720         return
721             interfaceId == type(IERC721).interfaceId ||
722             interfaceId == type(IERC721Metadata).interfaceId ||
723             super.supportsInterface(interfaceId);
724     }
725 
726     /**
727      * @dev See {IERC721-balanceOf}.
728      */
729     function balanceOf(address owner) public view virtual override returns (uint256) {
730         require(owner != address(0), "ERC721: balance query for the zero address");
731         return _balances[owner];
732     }
733 
734     /**
735      * @dev See {IERC721-ownerOf}.
736      */
737     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
738         address owner = _owners[tokenId];
739         require(owner != address(0), "ERC721: owner query for nonexistent token");
740         return owner;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-name}.
745      */
746     function name() public view virtual override returns (string memory) {
747         return _name;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-symbol}.
752      */
753     function symbol() public view virtual override returns (string memory) {
754         return _symbol;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-tokenURI}.
759      */
760     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
761         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
762 
763         string memory baseURI = _baseURI();
764         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
765     }
766 
767     /**
768      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
769      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
770      * by default, can be overriden in child contracts.
771      */
772     function _baseURI() internal view virtual returns (string memory) {
773         return "";
774     }
775 
776     /**
777      * @dev See {IERC721-approve}.
778      */
779     function approve(address to, uint256 tokenId) public virtual override {
780         address owner = ERC721.ownerOf(tokenId);
781         require(to != owner, "ERC721: approval to current owner");
782 
783         require(
784             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
785             "ERC721: approve caller is not owner nor approved for all"
786         );
787 
788         _approve(to, tokenId);
789     }
790 
791     /**
792      * @dev See {IERC721-getApproved}.
793      */
794     function getApproved(uint256 tokenId) public view virtual override returns (address) {
795         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
796 
797         return _tokenApprovals[tokenId];
798     }
799 
800     /**
801      * @dev See {IERC721-setApprovalForAll}.
802      */
803     function setApprovalForAll(address operator, bool approved) public virtual override {
804         _setApprovalForAll(_msgSender(), operator, approved);
805     }
806 
807     /**
808      * @dev See {IERC721-isApprovedForAll}.
809      */
810     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         //solhint-disable-next-line max-line-length
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824 
825         _transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         safeTransferFrom(from, to, tokenId, "");
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) public virtual override {
848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
849         _safeTransfer(from, to, tokenId, _data);
850     }
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
857      *
858      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
859      * implement alternative mechanisms to perform token transfer, such as signature-based.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _safeTransfer(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) internal virtual {
876         _transfer(from, to, tokenId);
877         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted (`_mint`),
886      * and stop existing when they are burned (`_burn`).
887      */
888     function _exists(uint256 tokenId) internal view virtual returns (bool) {
889         return _owners[tokenId] != address(0);
890     }
891 
892     /**
893      * @dev Returns whether `spender` is allowed to manage `tokenId`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
900         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
901         address owner = ERC721.ownerOf(tokenId);
902         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
903     }
904 
905     /**
906      * @dev Safely mints `tokenId` and transfers it to `to`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must not exist.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeMint(address to, uint256 tokenId) internal virtual {
916         _safeMint(to, tokenId, "");
917     }
918 
919     /**
920      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
921      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
922      */
923     function _safeMint(
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) internal virtual {
928         _mint(to, tokenId);
929         require(
930             _checkOnERC721Received(address(0), to, tokenId, _data),
931             "ERC721: transfer to non ERC721Receiver implementer"
932         );
933     }
934 
935     /**
936      * @dev Mints `tokenId` and transfers it to `to`.
937      *
938      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
939      *
940      * Requirements:
941      *
942      * - `tokenId` must not exist.
943      * - `to` cannot be the zero address.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _mint(address to, uint256 tokenId) internal virtual {
948         require(to != address(0), "ERC721: mint to the zero address");
949         require(!_exists(tokenId), "ERC721: token already minted");
950 
951         _beforeTokenTransfer(address(0), to, tokenId);
952 
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(address(0), to, tokenId);
957 
958         _afterTokenTransfer(address(0), to, tokenId);
959     }
960 
961     /**
962      * @dev Destroys `tokenId`.
963      * The approval is cleared when the token is burned.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must exist.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _burn(uint256 tokenId) internal virtual {
972         address owner = ERC721.ownerOf(tokenId);
973 
974         _beforeTokenTransfer(owner, address(0), tokenId);
975 
976         // Clear approvals
977         _approve(address(0), tokenId);
978 
979         _balances[owner] -= 1;
980         delete _owners[tokenId];
981 
982         emit Transfer(owner, address(0), tokenId);
983 
984         _afterTokenTransfer(owner, address(0), tokenId);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {
1003         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1004         require(to != address(0), "ERC721: transfer to the zero address");
1005 
1006         _beforeTokenTransfer(from, to, tokenId);
1007 
1008         // Clear approvals from the previous owner
1009         _approve(address(0), tokenId);
1010 
1011         _balances[from] -= 1;
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(from, to, tokenId);
1016 
1017         _afterTokenTransfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Approve `to` to operate on `tokenId`
1022      *
1023      * Emits a {Approval} event.
1024      */
1025     function _approve(address to, uint256 tokenId) internal virtual {
1026         _tokenApprovals[tokenId] = to;
1027         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Approve `operator` to operate on all of `owner` tokens
1032      *
1033      * Emits a {ApprovalForAll} event.
1034      */
1035     function _setApprovalForAll(
1036         address owner,
1037         address operator,
1038         bool approved
1039     ) internal virtual {
1040         require(owner != operator, "ERC721: approve to caller");
1041         _operatorApprovals[owner][operator] = approved;
1042         emit ApprovalForAll(owner, operator, approved);
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
1063                 return retval == IERC721Receiver.onERC721Received.selector;
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
1097 
1098     /**
1099      * @dev Hook that is called after any transfer of tokens. This includes
1100      * minting and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - when `from` and `to` are both non-zero.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _afterTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 }
1115 
1116 // File: @openzeppelin/contracts@4.5.0/token/ERC20/IERC20.sol
1117 
1118 
1119 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 /**
1124  * @dev Interface of the ERC20 standard as defined in the EIP.
1125  */
1126 interface IERC20 {
1127     /**
1128      * @dev Returns the amount of tokens in existence.
1129      */
1130     function totalSupply() external view returns (uint256);
1131 
1132     /**
1133      * @dev Returns the amount of tokens owned by `account`.
1134      */
1135     function balanceOf(address account) external view returns (uint256);
1136 
1137     /**
1138      * @dev Moves `amount` tokens from the caller's account to `to`.
1139      *
1140      * Returns a boolean value indicating whether the operation succeeded.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function transfer(address to, uint256 amount) external returns (bool);
1145 
1146     /**
1147      * @dev Returns the remaining number of tokens that `spender` will be
1148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1149      * zero by default.
1150      *
1151      * This value changes when {approve} or {transferFrom} are called.
1152      */
1153     function allowance(address owner, address spender) external view returns (uint256);
1154 
1155     /**
1156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1157      *
1158      * Returns a boolean value indicating whether the operation succeeded.
1159      *
1160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1161      * that someone may use both the old and the new allowance by unfortunate
1162      * transaction ordering. One possible solution to mitigate this race
1163      * condition is to first reduce the spender's allowance to 0 and set the
1164      * desired value afterwards:
1165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1166      *
1167      * Emits an {Approval} event.
1168      */
1169     function approve(address spender, uint256 amount) external returns (bool);
1170 
1171     /**
1172      * @dev Moves `amount` tokens from `from` to `to` using the
1173      * allowance mechanism. `amount` is then deducted from the caller's
1174      * allowance.
1175      *
1176      * Returns a boolean value indicating whether the operation succeeded.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function transferFrom(
1181         address from,
1182         address to,
1183         uint256 amount
1184     ) external returns (bool);
1185 
1186     /**
1187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1188      * another (`to`).
1189      *
1190      * Note that `value` may be zero.
1191      */
1192     event Transfer(address indexed from, address indexed to, uint256 value);
1193 
1194     /**
1195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1196      * a call to {approve}. `value` is the new allowance.
1197      */
1198     event Approval(address indexed owner, address indexed spender, uint256 value);
1199 }
1200 
1201 // File: erc721a/contracts/IERC721A.sol
1202 
1203 
1204 // ERC721A Contracts v4.2.3
1205 // Creator: Chiru Labs
1206 
1207 pragma solidity ^0.8.4;
1208 
1209 /**
1210  * @dev Interface of ERC721A.
1211  */
1212 interface IERC721A {
1213     /**
1214      * The caller must own the token or be an approved operator.
1215      */
1216     error ApprovalCallerNotOwnerNorApproved();
1217 
1218     /**
1219      * The token does not exist.
1220      */
1221     error ApprovalQueryForNonexistentToken();
1222 
1223     /**
1224      * Cannot query the balance for the zero address.
1225      */
1226     error BalanceQueryForZeroAddress();
1227 
1228     /**
1229      * Cannot mint to the zero address.
1230      */
1231     error MintToZeroAddress();
1232 
1233     /**
1234      * The quantity of tokens minted must be more than zero.
1235      */
1236     error MintZeroQuantity();
1237 
1238     /**
1239      * The token does not exist.
1240      */
1241     error OwnerQueryForNonexistentToken();
1242 
1243     /**
1244      * The caller must own the token or be an approved operator.
1245      */
1246     error TransferCallerNotOwnerNorApproved();
1247 
1248     /**
1249      * The token must be owned by `from`.
1250      */
1251     error TransferFromIncorrectOwner();
1252 
1253     /**
1254      * Cannot safely transfer to a contract that does not implement the
1255      * ERC721Receiver interface.
1256      */
1257     error TransferToNonERC721ReceiverImplementer();
1258 
1259     /**
1260      * Cannot transfer to the zero address.
1261      */
1262     error TransferToZeroAddress();
1263 
1264     /**
1265      * The token does not exist.
1266      */
1267     error URIQueryForNonexistentToken();
1268 
1269     /**
1270      * The `quantity` minted with ERC2309 exceeds the safety limit.
1271      */
1272     error MintERC2309QuantityExceedsLimit();
1273 
1274     /**
1275      * The `extraData` cannot be set on an unintialized ownership slot.
1276      */
1277     error OwnershipNotInitializedForExtraData();
1278 
1279     // =============================================================
1280     //                            STRUCTS
1281     // =============================================================
1282 
1283     struct TokenOwnership {
1284         // The address of the owner.
1285         address addr;
1286         // Stores the start time of ownership with minimal overhead for tokenomics.
1287         uint64 startTimestamp;
1288         // Whether the token has been burned.
1289         bool burned;
1290         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1291         uint24 extraData;
1292     }
1293 
1294     // =============================================================
1295     //                         TOKEN COUNTERS
1296     // =============================================================
1297 
1298     /**
1299      * @dev Returns the total number of tokens in existence.
1300      * Burned tokens will reduce the count.
1301      * To get the total number of tokens minted, please see {_totalMinted}.
1302      */
1303     function totalSupply() external view returns (uint256);
1304 
1305     // =============================================================
1306     //                            IERC165
1307     // =============================================================
1308 
1309     /**
1310      * @dev Returns true if this contract implements the interface defined by
1311      * `interfaceId`. See the corresponding
1312      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1313      * to learn more about how these ids are created.
1314      *
1315      * This function call must use less than 30000 gas.
1316      */
1317     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1318 
1319     // =============================================================
1320     //                            IERC721
1321     // =============================================================
1322 
1323     /**
1324      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1325      */
1326     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1327 
1328     /**
1329      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1330      */
1331     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1332 
1333     /**
1334      * @dev Emitted when `owner` enables or disables
1335      * (`approved`) `operator` to manage all of its assets.
1336      */
1337     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1338 
1339     /**
1340      * @dev Returns the number of tokens in `owner`'s account.
1341      */
1342     function balanceOf(address owner) external view returns (uint256 balance);
1343 
1344     /**
1345      * @dev Returns the owner of the `tokenId` token.
1346      *
1347      * Requirements:
1348      *
1349      * - `tokenId` must exist.
1350      */
1351     function ownerOf(uint256 tokenId) external view returns (address owner);
1352 
1353     /**
1354      * @dev Safely transfers `tokenId` token from `from` to `to`,
1355      * checking first that contract recipients are aware of the ERC721 protocol
1356      * to prevent tokens from being forever locked.
1357      *
1358      * Requirements:
1359      *
1360      * - `from` cannot be the zero address.
1361      * - `to` cannot be the zero address.
1362      * - `tokenId` token must exist and be owned by `from`.
1363      * - If the caller is not `from`, it must be have been allowed to move
1364      * this token by either {approve} or {setApprovalForAll}.
1365      * - If `to` refers to a smart contract, it must implement
1366      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function safeTransferFrom(
1371         address from,
1372         address to,
1373         uint256 tokenId,
1374         bytes calldata data
1375     ) external payable;
1376 
1377     /**
1378      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1379      */
1380     function safeTransferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) external payable;
1385 
1386     /**
1387      * @dev Transfers `tokenId` from `from` to `to`.
1388      *
1389      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1390      * whenever possible.
1391      *
1392      * Requirements:
1393      *
1394      * - `from` cannot be the zero address.
1395      * - `to` cannot be the zero address.
1396      * - `tokenId` token must be owned by `from`.
1397      * - If the caller is not `from`, it must be approved to move this token
1398      * by either {approve} or {setApprovalForAll}.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function transferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) external payable;
1407 
1408     /**
1409      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1410      * The approval is cleared when the token is transferred.
1411      *
1412      * Only a single account can be approved at a time, so approving the
1413      * zero address clears previous approvals.
1414      *
1415      * Requirements:
1416      *
1417      * - The caller must own the token or be an approved operator.
1418      * - `tokenId` must exist.
1419      *
1420      * Emits an {Approval} event.
1421      */
1422     function approve(address to, uint256 tokenId) external payable;
1423 
1424     /**
1425      * @dev Approve or remove `operator` as an operator for the caller.
1426      * Operators can call {transferFrom} or {safeTransferFrom}
1427      * for any token owned by the caller.
1428      *
1429      * Requirements:
1430      *
1431      * - The `operator` cannot be the caller.
1432      *
1433      * Emits an {ApprovalForAll} event.
1434      */
1435     function setApprovalForAll(address operator, bool _approved) external;
1436 
1437     /**
1438      * @dev Returns the account approved for `tokenId` token.
1439      *
1440      * Requirements:
1441      *
1442      * - `tokenId` must exist.
1443      */
1444     function getApproved(uint256 tokenId) external view returns (address operator);
1445 
1446     /**
1447      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1448      *
1449      * See {setApprovalForAll}.
1450      */
1451     function isApprovedForAll(address owner, address operator) external view returns (bool);
1452 
1453     // =============================================================
1454     //                        IERC721Metadata
1455     // =============================================================
1456 
1457     /**
1458      * @dev Returns the token collection name.
1459      */
1460     function name() external view returns (string memory);
1461 
1462     /**
1463      * @dev Returns the token collection symbol.
1464      */
1465     function symbol() external view returns (string memory);
1466 
1467     /**
1468      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1469      */
1470     function tokenURI(uint256 tokenId) external view returns (string memory);
1471 
1472     // =============================================================
1473     //                           IERC2309
1474     // =============================================================
1475 
1476     /**
1477      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1478      * (inclusive) is transferred from `from` to `to`, as defined in the
1479      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1480      *
1481      * See {_mintERC2309} for more details.
1482      */
1483     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1484 }
1485 
1486 // File: erc721a/contracts/ERC721A.sol
1487 
1488 
1489 // ERC721A Contracts v4.2.3
1490 // Creator: Chiru Labs
1491 
1492 pragma solidity ^0.8.4;
1493 
1494 
1495 /**
1496  * @dev Interface of ERC721 token receiver.
1497  */
1498 interface ERC721A__IERC721Receiver {
1499     function onERC721Received(
1500         address operator,
1501         address from,
1502         uint256 tokenId,
1503         bytes calldata data
1504     ) external returns (bytes4);
1505 }
1506 
1507 /**
1508  * @title ERC721A
1509  *
1510  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1511  * Non-Fungible Token Standard, including the Metadata extension.
1512  * Optimized for lower gas during batch mints.
1513  *
1514  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1515  * starting from `_startTokenId()`.
1516  *
1517  * Assumptions:
1518  *
1519  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1520  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1521  */
1522 contract ERC721A is IERC721A {
1523     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1524     struct TokenApprovalRef {
1525         address value;
1526     }
1527 
1528     // =============================================================
1529     //                           CONSTANTS
1530     // =============================================================
1531 
1532     // Mask of an entry in packed address data.
1533     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1534 
1535     // The bit position of `numberMinted` in packed address data.
1536     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1537 
1538     // The bit position of `numberBurned` in packed address data.
1539     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1540 
1541     // The bit position of `aux` in packed address data.
1542     uint256 private constant _BITPOS_AUX = 192;
1543 
1544     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1545     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1546 
1547     // The bit position of `startTimestamp` in packed ownership.
1548     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1549 
1550     // The bit mask of the `burned` bit in packed ownership.
1551     uint256 private constant _BITMASK_BURNED = 1 << 224;
1552 
1553     // The bit position of the `nextInitialized` bit in packed ownership.
1554     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1555 
1556     // The bit mask of the `nextInitialized` bit in packed ownership.
1557     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1558 
1559     // The bit position of `extraData` in packed ownership.
1560     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1561 
1562     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1563     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1564 
1565     // The mask of the lower 160 bits for addresses.
1566     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1567 
1568     // The maximum `quantity` that can be minted with {_mintERC2309}.
1569     // This limit is to prevent overflows on the address data entries.
1570     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1571     // is required to cause an overflow, which is unrealistic.
1572     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1573 
1574     // The `Transfer` event signature is given by:
1575     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1576     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1577         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1578 
1579     // =============================================================
1580     //                            STORAGE
1581     // =============================================================
1582 
1583     // The next token ID to be minted.
1584     uint256 private _currentIndex;
1585 
1586     // The number of tokens burned.
1587     uint256 private _burnCounter;
1588 
1589     // Token name
1590     string private _name;
1591 
1592     // Token symbol
1593     string private _symbol;
1594 
1595     // Mapping from token ID to ownership details
1596     // An empty struct value does not necessarily mean the token is unowned.
1597     // See {_packedOwnershipOf} implementation for details.
1598     //
1599     // Bits Layout:
1600     // - [0..159]   `addr`
1601     // - [160..223] `startTimestamp`
1602     // - [224]      `burned`
1603     // - [225]      `nextInitialized`
1604     // - [232..255] `extraData`
1605     mapping(uint256 => uint256) private _packedOwnerships;
1606 
1607     // Mapping owner address to address data.
1608     //
1609     // Bits Layout:
1610     // - [0..63]    `balance`
1611     // - [64..127]  `numberMinted`
1612     // - [128..191] `numberBurned`
1613     // - [192..255] `aux`
1614     mapping(address => uint256) private _packedAddressData;
1615 
1616     // Mapping from token ID to approved address.
1617     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1618 
1619     // Mapping from owner to operator approvals
1620     mapping(address => mapping(address => bool)) private _operatorApprovals;
1621 
1622     // =============================================================
1623     //                          CONSTRUCTOR
1624     // =============================================================
1625 
1626     constructor(string memory name_, string memory symbol_) {
1627         _name = name_;
1628         _symbol = symbol_;
1629         _currentIndex = _startTokenId();
1630     }
1631 
1632     // =============================================================
1633     //                   TOKEN COUNTING OPERATIONS
1634     // =============================================================
1635 
1636     /**
1637      * @dev Returns the starting token ID.
1638      * To change the starting token ID, please override this function.
1639      */
1640     function _startTokenId() internal view virtual returns (uint256) {
1641         return 0;
1642     }
1643 
1644     /**
1645      * @dev Returns the next token ID to be minted.
1646      */
1647     function _nextTokenId() internal view virtual returns (uint256) {
1648         return _currentIndex;
1649     }
1650 
1651     /**
1652      * @dev Returns the total number of tokens in existence.
1653      * Burned tokens will reduce the count.
1654      * To get the total number of tokens minted, please see {_totalMinted}.
1655      */
1656     function totalSupply() public view virtual override returns (uint256) {
1657         // Counter underflow is impossible as _burnCounter cannot be incremented
1658         // more than `_currentIndex - _startTokenId()` times.
1659         unchecked {
1660             return _currentIndex - _burnCounter - _startTokenId();
1661         }
1662     }
1663 
1664     /**
1665      * @dev Returns the total amount of tokens minted in the contract.
1666      */
1667     function _totalMinted() internal view virtual returns (uint256) {
1668         // Counter underflow is impossible as `_currentIndex` does not decrement,
1669         // and it is initialized to `_startTokenId()`.
1670         unchecked {
1671             return _currentIndex - _startTokenId();
1672         }
1673     }
1674 
1675     /**
1676      * @dev Returns the total number of tokens burned.
1677      */
1678     function _totalBurned() internal view virtual returns (uint256) {
1679         return _burnCounter;
1680     }
1681 
1682     // =============================================================
1683     //                    ADDRESS DATA OPERATIONS
1684     // =============================================================
1685 
1686     /**
1687      * @dev Returns the number of tokens in `owner`'s account.
1688      */
1689     function balanceOf(address owner) public view virtual override returns (uint256) {
1690         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1691         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1692     }
1693 
1694     /**
1695      * Returns the number of tokens minted by `owner`.
1696      */
1697     function _numberMinted(address owner) internal view returns (uint256) {
1698         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1699     }
1700 
1701     /**
1702      * Returns the number of tokens burned by or on behalf of `owner`.
1703      */
1704     function _numberBurned(address owner) internal view returns (uint256) {
1705         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1706     }
1707 
1708     /**
1709      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1710      */
1711     function _getAux(address owner) internal view returns (uint64) {
1712         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1713     }
1714 
1715     /**
1716      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1717      * If there are multiple variables, please pack them into a uint64.
1718      */
1719     function _setAux(address owner, uint64 aux) internal virtual {
1720         uint256 packed = _packedAddressData[owner];
1721         uint256 auxCasted;
1722         // Cast `aux` with assembly to avoid redundant masking.
1723         assembly {
1724             auxCasted := aux
1725         }
1726         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1727         _packedAddressData[owner] = packed;
1728     }
1729 
1730     // =============================================================
1731     //                            IERC165
1732     // =============================================================
1733 
1734     /**
1735      * @dev Returns true if this contract implements the interface defined by
1736      * `interfaceId`. See the corresponding
1737      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1738      * to learn more about how these ids are created.
1739      *
1740      * This function call must use less than 30000 gas.
1741      */
1742     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1743         // The interface IDs are constants representing the first 4 bytes
1744         // of the XOR of all function selectors in the interface.
1745         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1746         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1747         return
1748             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1749             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1750             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1751     }
1752 
1753     // =============================================================
1754     //                        IERC721Metadata
1755     // =============================================================
1756 
1757     /**
1758      * @dev Returns the token collection name.
1759      */
1760     function name() public view virtual override returns (string memory) {
1761         return _name;
1762     }
1763 
1764     /**
1765      * @dev Returns the token collection symbol.
1766      */
1767     function symbol() public view virtual override returns (string memory) {
1768         return _symbol;
1769     }
1770 
1771     /**
1772      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1773      */
1774     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1775         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1776 
1777         string memory baseURI = _baseURI();
1778         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1779     }
1780 
1781     /**
1782      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1783      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1784      * by default, it can be overridden in child contracts.
1785      */
1786     function _baseURI() internal view virtual returns (string memory) {
1787         return '';
1788     }
1789 
1790     // =============================================================
1791     //                     OWNERSHIPS OPERATIONS
1792     // =============================================================
1793 
1794     /**
1795      * @dev Returns the owner of the `tokenId` token.
1796      *
1797      * Requirements:
1798      *
1799      * - `tokenId` must exist.
1800      */
1801     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1802         return address(uint160(_packedOwnershipOf(tokenId)));
1803     }
1804 
1805     /**
1806      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1807      * It gradually moves to O(1) as tokens get transferred around over time.
1808      */
1809     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1810         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1811     }
1812 
1813     /**
1814      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1815      */
1816     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1817         return _unpackedOwnership(_packedOwnerships[index]);
1818     }
1819 
1820     /**
1821      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1822      */
1823     function _initializeOwnershipAt(uint256 index) internal virtual {
1824         if (_packedOwnerships[index] == 0) {
1825             _packedOwnerships[index] = _packedOwnershipOf(index);
1826         }
1827     }
1828 
1829     /**
1830      * Returns the packed ownership data of `tokenId`.
1831      */
1832     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1833         uint256 curr = tokenId;
1834 
1835         unchecked {
1836             if (_startTokenId() <= curr)
1837                 if (curr < _currentIndex) {
1838                     uint256 packed = _packedOwnerships[curr];
1839                     // If not burned.
1840                     if (packed & _BITMASK_BURNED == 0) {
1841                         // Invariant:
1842                         // There will always be an initialized ownership slot
1843                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1844                         // before an unintialized ownership slot
1845                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1846                         // Hence, `curr` will not underflow.
1847                         //
1848                         // We can directly compare the packed value.
1849                         // If the address is zero, packed will be zero.
1850                         while (packed == 0) {
1851                             packed = _packedOwnerships[--curr];
1852                         }
1853                         return packed;
1854                     }
1855                 }
1856         }
1857         revert OwnerQueryForNonexistentToken();
1858     }
1859 
1860     /**
1861      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1862      */
1863     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1864         ownership.addr = address(uint160(packed));
1865         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1866         ownership.burned = packed & _BITMASK_BURNED != 0;
1867         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1868     }
1869 
1870     /**
1871      * @dev Packs ownership data into a single uint256.
1872      */
1873     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1874         assembly {
1875             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1876             owner := and(owner, _BITMASK_ADDRESS)
1877             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1878             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1879         }
1880     }
1881 
1882     /**
1883      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1884      */
1885     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1886         // For branchless setting of the `nextInitialized` flag.
1887         assembly {
1888             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1889             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1890         }
1891     }
1892 
1893     // =============================================================
1894     //                      APPROVAL OPERATIONS
1895     // =============================================================
1896 
1897     /**
1898      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1899      * The approval is cleared when the token is transferred.
1900      *
1901      * Only a single account can be approved at a time, so approving the
1902      * zero address clears previous approvals.
1903      *
1904      * Requirements:
1905      *
1906      * - The caller must own the token or be an approved operator.
1907      * - `tokenId` must exist.
1908      *
1909      * Emits an {Approval} event.
1910      */
1911     function approve(address to, uint256 tokenId) public payable virtual override {
1912         address owner = ownerOf(tokenId);
1913 
1914         if (_msgSenderERC721A() != owner)
1915             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1916                 revert ApprovalCallerNotOwnerNorApproved();
1917             }
1918 
1919         _tokenApprovals[tokenId].value = to;
1920         emit Approval(owner, to, tokenId);
1921     }
1922 
1923     /**
1924      * @dev Returns the account approved for `tokenId` token.
1925      *
1926      * Requirements:
1927      *
1928      * - `tokenId` must exist.
1929      */
1930     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1931         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1932 
1933         return _tokenApprovals[tokenId].value;
1934     }
1935 
1936     /**
1937      * @dev Approve or remove `operator` as an operator for the caller.
1938      * Operators can call {transferFrom} or {safeTransferFrom}
1939      * for any token owned by the caller.
1940      *
1941      * Requirements:
1942      *
1943      * - The `operator` cannot be the caller.
1944      *
1945      * Emits an {ApprovalForAll} event.
1946      */
1947     function setApprovalForAll(address operator, bool approved) public virtual override {
1948         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1949         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1950     }
1951 
1952     /**
1953      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1954      *
1955      * See {setApprovalForAll}.
1956      */
1957     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1958         return _operatorApprovals[owner][operator];
1959     }
1960 
1961     /**
1962      * @dev Returns whether `tokenId` exists.
1963      *
1964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1965      *
1966      * Tokens start existing when they are minted. See {_mint}.
1967      */
1968     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1969         return
1970             _startTokenId() <= tokenId &&
1971             tokenId < _currentIndex && // If within bounds,
1972             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1973     }
1974 
1975     /**
1976      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1977      */
1978     function _isSenderApprovedOrOwner(
1979         address approvedAddress,
1980         address owner,
1981         address msgSender
1982     ) private pure returns (bool result) {
1983         assembly {
1984             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1985             owner := and(owner, _BITMASK_ADDRESS)
1986             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1987             msgSender := and(msgSender, _BITMASK_ADDRESS)
1988             // `msgSender == owner || msgSender == approvedAddress`.
1989             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1990         }
1991     }
1992 
1993     /**
1994      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1995      */
1996     function _getApprovedSlotAndAddress(uint256 tokenId)
1997         private
1998         view
1999         returns (uint256 approvedAddressSlot, address approvedAddress)
2000     {
2001         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2002         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2003         assembly {
2004             approvedAddressSlot := tokenApproval.slot
2005             approvedAddress := sload(approvedAddressSlot)
2006         }
2007     }
2008 
2009     // =============================================================
2010     //                      TRANSFER OPERATIONS
2011     // =============================================================
2012 
2013     /**
2014      * @dev Transfers `tokenId` from `from` to `to`.
2015      *
2016      * Requirements:
2017      *
2018      * - `from` cannot be the zero address.
2019      * - `to` cannot be the zero address.
2020      * - `tokenId` token must be owned by `from`.
2021      * - If the caller is not `from`, it must be approved to move this token
2022      * by either {approve} or {setApprovalForAll}.
2023      *
2024      * Emits a {Transfer} event.
2025      */
2026     function transferFrom(
2027         address from,
2028         address to,
2029         uint256 tokenId
2030     ) public payable virtual override {
2031         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2032 
2033         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2034 
2035         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2036 
2037         // The nested ifs save around 20+ gas over a compound boolean condition.
2038         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2039             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2040 
2041         if (to == address(0)) revert TransferToZeroAddress();
2042 
2043         _beforeTokenTransfers(from, to, tokenId, 1);
2044 
2045         // Clear approvals from the previous owner.
2046         assembly {
2047             if approvedAddress {
2048                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2049                 sstore(approvedAddressSlot, 0)
2050             }
2051         }
2052 
2053         // Underflow of the sender's balance is impossible because we check for
2054         // ownership above and the recipient's balance can't realistically overflow.
2055         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2056         unchecked {
2057             // We can directly increment and decrement the balances.
2058             --_packedAddressData[from]; // Updates: `balance -= 1`.
2059             ++_packedAddressData[to]; // Updates: `balance += 1`.
2060 
2061             // Updates:
2062             // - `address` to the next owner.
2063             // - `startTimestamp` to the timestamp of transfering.
2064             // - `burned` to `false`.
2065             // - `nextInitialized` to `true`.
2066             _packedOwnerships[tokenId] = _packOwnershipData(
2067                 to,
2068                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2069             );
2070 
2071             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2072             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2073                 uint256 nextTokenId = tokenId + 1;
2074                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2075                 if (_packedOwnerships[nextTokenId] == 0) {
2076                     // If the next slot is within bounds.
2077                     if (nextTokenId != _currentIndex) {
2078                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2079                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2080                     }
2081                 }
2082             }
2083         }
2084 
2085         emit Transfer(from, to, tokenId);
2086         _afterTokenTransfers(from, to, tokenId, 1);
2087     }
2088 
2089     /**
2090      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2091      */
2092     function safeTransferFrom(
2093         address from,
2094         address to,
2095         uint256 tokenId
2096     ) public payable virtual override {
2097         safeTransferFrom(from, to, tokenId, '');
2098     }
2099 
2100     /**
2101      * @dev Safely transfers `tokenId` token from `from` to `to`.
2102      *
2103      * Requirements:
2104      *
2105      * - `from` cannot be the zero address.
2106      * - `to` cannot be the zero address.
2107      * - `tokenId` token must exist and be owned by `from`.
2108      * - If the caller is not `from`, it must be approved to move this token
2109      * by either {approve} or {setApprovalForAll}.
2110      * - If `to` refers to a smart contract, it must implement
2111      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2112      *
2113      * Emits a {Transfer} event.
2114      */
2115     function safeTransferFrom(
2116         address from,
2117         address to,
2118         uint256 tokenId,
2119         bytes memory _data
2120     ) public payable virtual override {
2121         transferFrom(from, to, tokenId);
2122         if (to.code.length != 0)
2123             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2124                 revert TransferToNonERC721ReceiverImplementer();
2125             }
2126     }
2127 
2128     /**
2129      * @dev Hook that is called before a set of serially-ordered token IDs
2130      * are about to be transferred. This includes minting.
2131      * And also called before burning one token.
2132      *
2133      * `startTokenId` - the first token ID to be transferred.
2134      * `quantity` - the amount to be transferred.
2135      *
2136      * Calling conditions:
2137      *
2138      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2139      * transferred to `to`.
2140      * - When `from` is zero, `tokenId` will be minted for `to`.
2141      * - When `to` is zero, `tokenId` will be burned by `from`.
2142      * - `from` and `to` are never both zero.
2143      */
2144     function _beforeTokenTransfers(
2145         address from,
2146         address to,
2147         uint256 startTokenId,
2148         uint256 quantity
2149     ) internal virtual {}
2150 
2151     /**
2152      * @dev Hook that is called after a set of serially-ordered token IDs
2153      * have been transferred. This includes minting.
2154      * And also called after one token has been burned.
2155      *
2156      * `startTokenId` - the first token ID to be transferred.
2157      * `quantity` - the amount to be transferred.
2158      *
2159      * Calling conditions:
2160      *
2161      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2162      * transferred to `to`.
2163      * - When `from` is zero, `tokenId` has been minted for `to`.
2164      * - When `to` is zero, `tokenId` has been burned by `from`.
2165      * - `from` and `to` are never both zero.
2166      */
2167     function _afterTokenTransfers(
2168         address from,
2169         address to,
2170         uint256 startTokenId,
2171         uint256 quantity
2172     ) internal virtual {}
2173 
2174     /**
2175      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2176      *
2177      * `from` - Previous owner of the given token ID.
2178      * `to` - Target address that will receive the token.
2179      * `tokenId` - Token ID to be transferred.
2180      * `_data` - Optional data to send along with the call.
2181      *
2182      * Returns whether the call correctly returned the expected magic value.
2183      */
2184     function _checkContractOnERC721Received(
2185         address from,
2186         address to,
2187         uint256 tokenId,
2188         bytes memory _data
2189     ) private returns (bool) {
2190         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2191             bytes4 retval
2192         ) {
2193             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2194         } catch (bytes memory reason) {
2195             if (reason.length == 0) {
2196                 revert TransferToNonERC721ReceiverImplementer();
2197             } else {
2198                 assembly {
2199                     revert(add(32, reason), mload(reason))
2200                 }
2201             }
2202         }
2203     }
2204 
2205     // =============================================================
2206     //                        MINT OPERATIONS
2207     // =============================================================
2208 
2209     /**
2210      * @dev Mints `quantity` tokens and transfers them to `to`.
2211      *
2212      * Requirements:
2213      *
2214      * - `to` cannot be the zero address.
2215      * - `quantity` must be greater than 0.
2216      *
2217      * Emits a {Transfer} event for each mint.
2218      */
2219     function _mint(address to, uint256 quantity) internal virtual {
2220         uint256 startTokenId = _currentIndex;
2221         if (quantity == 0) revert MintZeroQuantity();
2222 
2223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2224 
2225         // Overflows are incredibly unrealistic.
2226         // `balance` and `numberMinted` have a maximum limit of 2**64.
2227         // `tokenId` has a maximum limit of 2**256.
2228         unchecked {
2229             // Updates:
2230             // - `balance += quantity`.
2231             // - `numberMinted += quantity`.
2232             //
2233             // We can directly add to the `balance` and `numberMinted`.
2234             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2235 
2236             // Updates:
2237             // - `address` to the owner.
2238             // - `startTimestamp` to the timestamp of minting.
2239             // - `burned` to `false`.
2240             // - `nextInitialized` to `quantity == 1`.
2241             _packedOwnerships[startTokenId] = _packOwnershipData(
2242                 to,
2243                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2244             );
2245 
2246             uint256 toMasked;
2247             uint256 end = startTokenId + quantity;
2248 
2249             // Use assembly to loop and emit the `Transfer` event for gas savings.
2250             // The duplicated `log4` removes an extra check and reduces stack juggling.
2251             // The assembly, together with the surrounding Solidity code, have been
2252             // delicately arranged to nudge the compiler into producing optimized opcodes.
2253             assembly {
2254                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2255                 toMasked := and(to, _BITMASK_ADDRESS)
2256                 // Emit the `Transfer` event.
2257                 log4(
2258                     0, // Start of data (0, since no data).
2259                     0, // End of data (0, since no data).
2260                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2261                     0, // `address(0)`.
2262                     toMasked, // `to`.
2263                     startTokenId // `tokenId`.
2264                 )
2265 
2266                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2267                 // that overflows uint256 will make the loop run out of gas.
2268                 // The compiler will optimize the `iszero` away for performance.
2269                 for {
2270                     let tokenId := add(startTokenId, 1)
2271                 } iszero(eq(tokenId, end)) {
2272                     tokenId := add(tokenId, 1)
2273                 } {
2274                     // Emit the `Transfer` event. Similar to above.
2275                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2276                 }
2277             }
2278             if (toMasked == 0) revert MintToZeroAddress();
2279 
2280             _currentIndex = end;
2281         }
2282         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2283     }
2284 
2285     /**
2286      * @dev Mints `quantity` tokens and transfers them to `to`.
2287      *
2288      * This function is intended for efficient minting only during contract creation.
2289      *
2290      * It emits only one {ConsecutiveTransfer} as defined in
2291      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2292      * instead of a sequence of {Transfer} event(s).
2293      *
2294      * Calling this function outside of contract creation WILL make your contract
2295      * non-compliant with the ERC721 standard.
2296      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2297      * {ConsecutiveTransfer} event is only permissible during contract creation.
2298      *
2299      * Requirements:
2300      *
2301      * - `to` cannot be the zero address.
2302      * - `quantity` must be greater than 0.
2303      *
2304      * Emits a {ConsecutiveTransfer} event.
2305      */
2306     function _mintERC2309(address to, uint256 quantity) internal virtual {
2307         uint256 startTokenId = _currentIndex;
2308         if (to == address(0)) revert MintToZeroAddress();
2309         if (quantity == 0) revert MintZeroQuantity();
2310         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2311 
2312         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2313 
2314         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2315         unchecked {
2316             // Updates:
2317             // - `balance += quantity`.
2318             // - `numberMinted += quantity`.
2319             //
2320             // We can directly add to the `balance` and `numberMinted`.
2321             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2322 
2323             // Updates:
2324             // - `address` to the owner.
2325             // - `startTimestamp` to the timestamp of minting.
2326             // - `burned` to `false`.
2327             // - `nextInitialized` to `quantity == 1`.
2328             _packedOwnerships[startTokenId] = _packOwnershipData(
2329                 to,
2330                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2331             );
2332 
2333             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2334 
2335             _currentIndex = startTokenId + quantity;
2336         }
2337         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2338     }
2339 
2340     /**
2341      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2342      *
2343      * Requirements:
2344      *
2345      * - If `to` refers to a smart contract, it must implement
2346      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2347      * - `quantity` must be greater than 0.
2348      *
2349      * See {_mint}.
2350      *
2351      * Emits a {Transfer} event for each mint.
2352      */
2353     function _safeMint(
2354         address to,
2355         uint256 quantity,
2356         bytes memory _data
2357     ) internal virtual {
2358         _mint(to, quantity);
2359 
2360         unchecked {
2361             if (to.code.length != 0) {
2362                 uint256 end = _currentIndex;
2363                 uint256 index = end - quantity;
2364                 do {
2365                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2366                         revert TransferToNonERC721ReceiverImplementer();
2367                     }
2368                 } while (index < end);
2369                 // Reentrancy protection.
2370                 if (_currentIndex != end) revert();
2371             }
2372         }
2373     }
2374 
2375     /**
2376      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2377      */
2378     function _safeMint(address to, uint256 quantity) internal virtual {
2379         _safeMint(to, quantity, '');
2380     }
2381 
2382     // =============================================================
2383     //                        BURN OPERATIONS
2384     // =============================================================
2385 
2386     /**
2387      * @dev Equivalent to `_burn(tokenId, false)`.
2388      */
2389     function _burn(uint256 tokenId) internal virtual {
2390         _burn(tokenId, false);
2391     }
2392 
2393     /**
2394      * @dev Destroys `tokenId`.
2395      * The approval is cleared when the token is burned.
2396      *
2397      * Requirements:
2398      *
2399      * - `tokenId` must exist.
2400      *
2401      * Emits a {Transfer} event.
2402      */
2403     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2404         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2405 
2406         address from = address(uint160(prevOwnershipPacked));
2407 
2408         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2409 
2410         if (approvalCheck) {
2411             // The nested ifs save around 20+ gas over a compound boolean condition.
2412             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2413                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2414         }
2415 
2416         _beforeTokenTransfers(from, address(0), tokenId, 1);
2417 
2418         // Clear approvals from the previous owner.
2419         assembly {
2420             if approvedAddress {
2421                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2422                 sstore(approvedAddressSlot, 0)
2423             }
2424         }
2425 
2426         // Underflow of the sender's balance is impossible because we check for
2427         // ownership above and the recipient's balance can't realistically overflow.
2428         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2429         unchecked {
2430             // Updates:
2431             // - `balance -= 1`.
2432             // - `numberBurned += 1`.
2433             //
2434             // We can directly decrement the balance, and increment the number burned.
2435             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2436             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2437 
2438             // Updates:
2439             // - `address` to the last owner.
2440             // - `startTimestamp` to the timestamp of burning.
2441             // - `burned` to `true`.
2442             // - `nextInitialized` to `true`.
2443             _packedOwnerships[tokenId] = _packOwnershipData(
2444                 from,
2445                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2446             );
2447 
2448             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2449             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2450                 uint256 nextTokenId = tokenId + 1;
2451                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2452                 if (_packedOwnerships[nextTokenId] == 0) {
2453                     // If the next slot is within bounds.
2454                     if (nextTokenId != _currentIndex) {
2455                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2456                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2457                     }
2458                 }
2459             }
2460         }
2461 
2462         emit Transfer(from, address(0), tokenId);
2463         _afterTokenTransfers(from, address(0), tokenId, 1);
2464 
2465         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2466         unchecked {
2467             _burnCounter++;
2468         }
2469     }
2470 
2471     // =============================================================
2472     //                     EXTRA DATA OPERATIONS
2473     // =============================================================
2474 
2475     /**
2476      * @dev Directly sets the extra data for the ownership data `index`.
2477      */
2478     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2479         uint256 packed = _packedOwnerships[index];
2480         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2481         uint256 extraDataCasted;
2482         // Cast `extraData` with assembly to avoid redundant masking.
2483         assembly {
2484             extraDataCasted := extraData
2485         }
2486         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2487         _packedOwnerships[index] = packed;
2488     }
2489 
2490     /**
2491      * @dev Called during each token transfer to set the 24bit `extraData` field.
2492      * Intended to be overridden by the cosumer contract.
2493      *
2494      * `previousExtraData` - the value of `extraData` before transfer.
2495      *
2496      * Calling conditions:
2497      *
2498      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2499      * transferred to `to`.
2500      * - When `from` is zero, `tokenId` will be minted for `to`.
2501      * - When `to` is zero, `tokenId` will be burned by `from`.
2502      * - `from` and `to` are never both zero.
2503      */
2504     function _extraData(
2505         address from,
2506         address to,
2507         uint24 previousExtraData
2508     ) internal view virtual returns (uint24) {}
2509 
2510     /**
2511      * @dev Returns the next extra data for the packed ownership data.
2512      * The returned result is shifted into position.
2513      */
2514     function _nextExtraData(
2515         address from,
2516         address to,
2517         uint256 prevOwnershipPacked
2518     ) private view returns (uint256) {
2519         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2520         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2521     }
2522 
2523     // =============================================================
2524     //                       OTHER OPERATIONS
2525     // =============================================================
2526 
2527     /**
2528      * @dev Returns the message sender (defaults to `msg.sender`).
2529      *
2530      * If you are writing GSN compatible contracts, you need to override this function.
2531      */
2532     function _msgSenderERC721A() internal view virtual returns (address) {
2533         return msg.sender;
2534     }
2535 
2536     /**
2537      * @dev Converts a uint256 to its ASCII string decimal representation.
2538      */
2539     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2540         assembly {
2541             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2542             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2543             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2544             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2545             let m := add(mload(0x40), 0xa0)
2546             // Update the free memory pointer to allocate.
2547             mstore(0x40, m)
2548             // Assign the `str` to the end.
2549             str := sub(m, 0x20)
2550             // Zeroize the slot after the string.
2551             mstore(str, 0)
2552 
2553             // Cache the end of the memory to calculate the length later.
2554             let end := str
2555 
2556             // We write the string from rightmost digit to leftmost digit.
2557             // The following is essentially a do-while loop that also handles the zero case.
2558             // prettier-ignore
2559             for { let temp := value } 1 {} {
2560                 str := sub(str, 1)
2561                 // Write the character to the pointer.
2562                 // The ASCII index of the '0' character is 48.
2563                 mstore8(str, add(48, mod(temp, 10)))
2564                 // Keep dividing `temp` until zero.
2565                 temp := div(temp, 10)
2566                 // prettier-ignore
2567                 if iszero(temp) { break }
2568             }
2569 
2570             let length := sub(end, str)
2571             // Move the pointer 32 bytes leftwards to make room for the length.
2572             str := sub(str, 0x20)
2573             // Store the length.
2574             mstore(str, length)
2575         }
2576     }
2577 }
2578 
2579 // File: contracts/dw.sol
2580 
2581 
2582 
2583 // author :: itz0xAkira :D 
2584 
2585 
2586 pragma solidity ^0.8.9;
2587 
2588 
2589 
2590 
2591 
2592 contract DeltaWolves is ERC721A, Ownable {
2593     uint256 MAX_SUPPLY = 7777;
2594     uint256 public MAX_MINT = 5;
2595 
2596     bool Publicsale = false;
2597 
2598 
2599     string private baseURI;
2600 
2601     mapping (address => uint256) public mintedCounts;
2602     
2603     mapping (address => bool) public AllowedMarketplaces;
2604 
2605     event Minted(address indexed recipient);
2606 
2607     constructor() ERC721A("Delta Wolves", "DW") {}
2608 
2609     function approve(address to, uint256 id) public virtual payable override {
2610         require(AllowedMarketplaces[to], "Invalid marketplace");
2611         super.approve(to, id);
2612     }
2613 
2614     function setApprovalForAll(address operator, bool approved) public virtual override {
2615         require(AllowedMarketplaces[operator], "Invalid marketplace");
2616         super.setApprovalForAll(operator, approved);
2617     }
2618 
2619     function setAllowedMarketplace(address marketplace, bool allowed) public onlyOwner{
2620         AllowedMarketplaces[marketplace] = allowed;
2621     }
2622 
2623     modifier callerIsUser() {
2624         require(tx.origin == msg.sender, "The caller is another contract");
2625         _;
2626     }
2627 
2628     function setBaseURI(string memory _baseURI_) external onlyOwner {
2629         baseURI = _baseURI_;
2630     }
2631 
2632     function setMaxMint(uint256 MaxMints) external onlyOwner {
2633         MAX_MINT = MaxMints;
2634     }
2635 
2636     function ownerMint(uint256 quantity) public onlyOwner {
2637         require((totalSupply() + quantity) <= MAX_SUPPLY, "There is no more wolves to mint!!");
2638         _mint(msg.sender, quantity);
2639     }    
2640 
2641     function AirDrop(address to, uint256 quantity) public onlyOwner {
2642         require((totalSupply() + quantity) <= MAX_SUPPLY, "There is no more wolves to mint!!");
2643         _mint(to, quantity);
2644     }
2645 
2646     function mint(uint256 quantity) external payable callerIsUser {
2647         require(Publicsale, " Not active yet");
2648         require((totalSupply() + quantity) <= MAX_SUPPLY, "There is no more wolves to mint!!");
2649         require(quantity + mintedCounts[msg.sender] <= MAX_MINT, "Already claimed the max amount of wolves allowed");
2650 
2651         _safeMint(msg.sender, quantity);
2652         mintedCounts[msg.sender] += quantity;
2653         emit Minted(msg.sender);
2654     }
2655 
2656     function ActivatePublicsale() external onlyOwner {
2657         Publicsale = !Publicsale;
2658     }
2659 
2660     function _baseURI() internal view override returns (string memory) {
2661         return baseURI;
2662     }
2663 
2664     function withdraw() external payable onlyOwner {
2665         payable(owner()).transfer(address(this).balance);
2666     }
2667 
2668 }