1 // File: @openzeppelin/contracts/utils/Strings.sol
2 //////////////////////////////////////////////////////////////////////////////////////
3 //                                                                                  //
4 //                                                                                  //
5 //                                                                                  //
6 //    _________         __           _________         __    ______________  ___    //
7 //    \_   ___ \ __ ___/  |_  ____   \_   ___ \_____ _/  |_  \______   \   \/  /    //
8 //    /    \  \/|  |  \   __\/ __ \  /    \  \/\__  \\   __\  |     ___/\     /     //
9 //    \     \___|  |  /|  | \  ___/  \     \____/ __ \|  |    |    |    /     \     //
10 //     \______  /____/ |__|  \___  >  \______  (____  /__|    |____|   /___/\  \    //
11 //            \/                 \/          \/     \/                       \_/    //
12 //                                                                                  //
13 //                                                                                  //
14 //                                                                                  //
15 //////////////////////////////////////////////////////////////////////////////////////
16 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev String operations.
22  */
23 library Strings {
24     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
25 
26     /**
27      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
28      */
29     function toString(uint256 value) internal pure returns (string memory) {
30         // Inspired by OraclizeAPI's implementation - MIT licence
31         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
32 
33         if (value == 0) {
34             return "0";
35         }
36         uint256 temp = value;
37         uint256 digits;
38         while (temp != 0) {
39             digits++;
40             temp /= 10;
41         }
42         bytes memory buffer = new bytes(digits);
43         while (value != 0) {
44             digits -= 1;
45             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
46             value /= 10;
47         }
48         return string(buffer);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
53      */
54     function toHexString(uint256 value) internal pure returns (string memory) {
55         if (value == 0) {
56             return "0x00";
57         }
58         uint256 temp = value;
59         uint256 length = 0;
60         while (temp != 0) {
61             length++;
62             temp >>= 8;
63         }
64         return toHexString(value, length);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
69      */
70     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
71         bytes memory buffer = new bytes(2 * length + 2);
72         buffer[0] = "0";
73         buffer[1] = "x";
74         for (uint256 i = 2 * length + 1; i > 1; --i) {
75             buffer[i] = _HEX_SYMBOLS[value & 0xf];
76             value >>= 4;
77         }
78         require(value == 0, "Strings: hex length insufficient");
79         return string(buffer);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Context.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/access/Ownable.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor() {
139         _transferOwnership(_msgSender());
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/utils/Address.sol
189 
190 
191 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Collection of functions related to the address type
197  */
198 library Address {
199     /**
200      * @dev Returns true if `account` is a contract.
201      *
202      * [IMPORTANT]
203      * ====
204      * It is unsafe to assume that an address for which this function returns
205      * false is an externally-owned account (EOA) and not a contract.
206      *
207      * Among others, `isContract` will return false for the following
208      * types of addresses:
209      *
210      *  - an externally-owned account
211      *  - a contract in construction
212      *  - an address where a contract will be created
213      *  - an address where a contract lived, but was destroyed
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // This method relies on extcodesize, which returns 0 for contracts in
218         // construction, since the code is only stored at the end of the
219         // constructor execution.
220 
221         uint256 size;
222         assembly {
223             size := extcodesize(account)
224         }
225         return size > 0;
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      */
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246 
247         (bool success, ) = recipient.call{value: amount}("");
248         require(success, "Address: unable to send value, recipient may have reverted");
249     }
250 
251     /**
252      * @dev Performs a Solidity function call using a low level `call`. A
253      * plain `call` is an unsafe replacement for a function call: use this
254      * function instead.
255      *
256      * If `target` reverts with a revert reason, it is bubbled up by this
257      * function (like regular Solidity function calls).
258      *
259      * Returns the raw returned data. To convert to the expected return value,
260      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
261      *
262      * Requirements:
263      *
264      * - `target` must be a contract.
265      * - calling `target` with `data` must not revert.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionCall(target, data, "Address: low-level call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
275      * `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, 0, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but also transferring `value` wei to `target`.
290      *
291      * Requirements:
292      *
293      * - the calling contract must have an ETH balance of at least `value`.
294      * - the called Solidity function must be `payable`.
295      *
296      * _Available since v3.1._
297      */
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value
302     ) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
308      * with `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         require(isContract(target), "Address: call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.call{value: value}(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
332         return functionStaticCall(target, data, "Address: low-level static call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal view returns (bytes memory) {
346         require(isContract(target), "Address: static call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.staticcall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.delegatecall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
381      * revert reason using the provided one.
382      *
383      * _Available since v4.3._
384      */
385     function verifyCallResult(
386         bool success,
387         bytes memory returndata,
388         string memory errorMessage
389     ) internal pure returns (bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
412 
413 pragma solidity ^0.8.0;
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
438 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Implementation of the {IERC165} interface.
476  *
477  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
478  * for the additional interface id that will be supported. For example:
479  *
480  * ```solidity
481  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
483  * }
484  * ```
485  *
486  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
487  */
488 abstract contract ERC165 is IERC165 {
489     /**
490      * @dev See {IERC165-supportsInterface}.
491      */
492     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493         return interfaceId == type(IERC165).interfaceId;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Required interface of an ERC721 compliant contract.
507  */
508 interface IERC721 is IERC165 {
509     /**
510      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
511      */
512     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
516      */
517     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
521      */
522     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
523 
524     /**
525      * @dev Returns the number of tokens in ``owner``'s account.
526      */
527     function balanceOf(address owner) external view returns (uint256 balance);
528 
529     /**
530      * @dev Returns the owner of the `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function ownerOf(uint256 tokenId) external view returns (address owner);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Transfers `tokenId` token from `from` to `to`.
560      *
561      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
580      * The approval is cleared when the token is transferred.
581      *
582      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
583      *
584      * Requirements:
585      *
586      * - The caller must own the token or be an approved operator.
587      * - `tokenId` must exist.
588      *
589      * Emits an {Approval} event.
590      */
591     function approve(address to, uint256 tokenId) external;
592 
593     /**
594      * @dev Returns the account approved for `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function getApproved(uint256 tokenId) external view returns (address operator);
601 
602     /**
603      * @dev Approve or remove `operator` as an operator for the caller.
604      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
605      *
606      * Requirements:
607      *
608      * - The `operator` cannot be the caller.
609      *
610      * Emits an {ApprovalForAll} event.
611      */
612     function setApprovalForAll(address operator, bool _approved) external;
613 
614     /**
615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
616      *
617      * See {setApprovalForAll}
618      */
619     function isApprovedForAll(address owner, address operator) external view returns (bool);
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes calldata data
639     ) external;
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Enumerable is IERC721 {
655     /**
656      * @dev Returns the total amount of tokens stored by the contract.
657      */
658     function totalSupply() external view returns (uint256);
659 
660     /**
661      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
662      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
663      */
664     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
665 
666     /**
667      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
668      * Use along with {totalSupply} to enumerate all tokens.
669      */
670     function tokenByIndex(uint256 index) external view returns (uint256);
671 }
672 
673 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
677 
678 pragma solidity ^0.8.0;
679 
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
702 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 
711 
712 
713 
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Strings for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view virtual override returns (uint256) {
765         require(owner != address(0), "ERC721: balance query for the zero address");
766         return _balances[owner];
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
773         address owner = _owners[tokenId];
774         require(owner != address(0), "ERC721: owner query for nonexistent token");
775         return owner;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public virtual override {
815         address owner = ERC721.ownerOf(tokenId);
816         require(to != owner, "ERC721: approval to current owner");
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             "ERC721: approve caller is not owner nor approved for all"
821         );
822 
823         _approve(to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view virtual override returns (address) {
830         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         _setApprovalForAll(_msgSender(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-transferFrom}.
851      */
852     function transferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         //solhint-disable-next-line max-line-length
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859 
860         _transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         safeTransferFrom(from, to, tokenId, "");
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) public virtual override {
883         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
884         _safeTransfer(from, to, tokenId, _data);
885     }
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
890      *
891      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
892      *
893      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
894      * implement alternative mechanisms to perform token transfer, such as signature-based.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must exist and be owned by `from`.
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _safeTransfer(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) internal virtual {
911         _transfer(from, to, tokenId);
912         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      * and stop existing when they are burned (`_burn`).
922      */
923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
924         return _owners[tokenId] != address(0);
925     }
926 
927     /**
928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      */
934     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
935         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
936         address owner = ERC721.ownerOf(tokenId);
937         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
938     }
939 
940     /**
941      * @dev Safely mints `tokenId` and transfers it to `to`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must not exist.
946      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(address to, uint256 tokenId) internal virtual {
951         _safeMint(to, tokenId, "");
952     }
953 
954     /**
955      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
956      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
957      */
958     function _safeMint(
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) internal virtual {
963         _mint(to, tokenId);
964         require(
965             _checkOnERC721Received(address(0), to, tokenId, _data),
966             "ERC721: transfer to non ERC721Receiver implementer"
967         );
968     }
969 
970     /**
971      * @dev Mints `tokenId` and transfers it to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - `to` cannot be the zero address.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(address to, uint256 tokenId) internal virtual {
983         require(to != address(0), "ERC721: mint to the zero address");
984         require(!_exists(tokenId), "ERC721: token already minted");
985 
986         _beforeTokenTransfer(address(0), to, tokenId);
987 
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {
1034         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1035         require(to != address(0), "ERC721: transfer to the zero address");
1036 
1037         _beforeTokenTransfer(from, to, tokenId);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId);
1041 
1042         _balances[from] -= 1;
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(address to, uint256 tokenId) internal virtual {
1055         _tokenApprovals[tokenId] = to;
1056         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `operator` to operate on all of `owner` tokens
1061      *
1062      * Emits a {ApprovalForAll} event.
1063      */
1064     function _setApprovalForAll(
1065         address owner,
1066         address operator,
1067         bool approved
1068     ) internal virtual {
1069         require(owner != operator, "ERC721: approve to caller");
1070         _operatorApprovals[owner][operator] = approved;
1071         emit ApprovalForAll(owner, operator, approved);
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1076      * The call is not executed if the target address is not a contract.
1077      *
1078      * @param from address representing the previous owner of the given token ID
1079      * @param to target address that will receive the tokens
1080      * @param tokenId uint256 ID of the token to be transferred
1081      * @param _data bytes optional data to send along with the call
1082      * @return bool whether the call correctly returned the expected magic value
1083      */
1084     function _checkOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         if (to.isContract()) {
1091             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1092                 return retval == IERC721Receiver.onERC721Received.selector;
1093             } catch (bytes memory reason) {
1094                 if (reason.length == 0) {
1095                     revert("ERC721: transfer to non ERC721Receiver implementer");
1096                 } else {
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual {}
1126 }
1127 
1128 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1129 
1130 
1131 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 
1136 
1137 /**
1138  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1139  * enumerability of all the token ids in the contract as well as all token ids owned by each
1140  * account.
1141  */
1142 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1143     // Mapping from owner to list of owned token IDs
1144     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1145 
1146     // Mapping from token ID to index of the owner tokens list
1147     mapping(uint256 => uint256) private _ownedTokensIndex;
1148 
1149     // Array with all token ids, used for enumeration
1150     uint256[] private _allTokens;
1151 
1152     // Mapping from token id to position in the allTokens array
1153     mapping(uint256 => uint256) private _allTokensIndex;
1154 
1155     /**
1156      * @dev See {IERC165-supportsInterface}.
1157      */
1158     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1159         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1164      */
1165     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1166         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1167         return _ownedTokens[owner][index];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Enumerable-totalSupply}.
1172      */
1173     function totalSupply() public view virtual override returns (uint256) {
1174         return _allTokens.length;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-tokenByIndex}.
1179      */
1180     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1181         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1182         return _allTokens[index];
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1195      * - `from` cannot be the zero address.
1196      * - `to` cannot be the zero address.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _beforeTokenTransfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual override {
1205         super._beforeTokenTransfer(from, to, tokenId);
1206 
1207         if (from == address(0)) {
1208             _addTokenToAllTokensEnumeration(tokenId);
1209         } else if (from != to) {
1210             _removeTokenFromOwnerEnumeration(from, tokenId);
1211         }
1212         if (to == address(0)) {
1213             _removeTokenFromAllTokensEnumeration(tokenId);
1214         } else if (to != from) {
1215             _addTokenToOwnerEnumeration(to, tokenId);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1221      * @param to address representing the new owner of the given token ID
1222      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1223      */
1224     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1225         uint256 length = ERC721.balanceOf(to);
1226         _ownedTokens[to][length] = tokenId;
1227         _ownedTokensIndex[tokenId] = length;
1228     }
1229 
1230     /**
1231      * @dev Private function to add a token to this extension's token tracking data structures.
1232      * @param tokenId uint256 ID of the token to be added to the tokens list
1233      */
1234     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1235         _allTokensIndex[tokenId] = _allTokens.length;
1236         _allTokens.push(tokenId);
1237     }
1238 
1239     /**
1240      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1241      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1242      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1243      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1244      * @param from address representing the previous owner of the given token ID
1245      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1246      */
1247     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1248         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1249         // then delete the last slot (swap and pop).
1250 
1251         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1252         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1253 
1254         // When the token to delete is the last token, the swap operation is unnecessary
1255         if (tokenIndex != lastTokenIndex) {
1256             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1257 
1258             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1259             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1260         }
1261 
1262         // This also deletes the contents at the last position of the array
1263         delete _ownedTokensIndex[tokenId];
1264         delete _ownedTokens[from][lastTokenIndex];
1265     }
1266 
1267     /**
1268      * @dev Private function to remove a token from this extension's token tracking data structures.
1269      * This has O(1) time complexity, but alters the order of the _allTokens array.
1270      * @param tokenId uint256 ID of the token to be removed from the tokens list
1271      */
1272     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1273         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1274         // then delete the last slot (swap and pop).
1275 
1276         uint256 lastTokenIndex = _allTokens.length - 1;
1277         uint256 tokenIndex = _allTokensIndex[tokenId];
1278 
1279         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1280         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1281         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1282         uint256 lastTokenId = _allTokens[lastTokenIndex];
1283 
1284         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1285         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1286 
1287         // This also deletes the contents at the last position of the array
1288         delete _allTokensIndex[tokenId];
1289         _allTokens.pop();
1290     }
1291 }
1292 
1293 // File: contracts/cutecatpx.sol
1294 
1295 
1296 
1297 
1298 
1299 pragma solidity >=0.7.0 <0.9.0;
1300 
1301 
1302 
1303 contract CuteCatPX is ERC721Enumerable, Ownable {
1304   using Strings for uint256;
1305 
1306   string public baseURI;
1307   string public baseExtension = ".json";
1308   string public notRevealedUri;
1309   uint256 public cost = 0.03 ether;
1310   uint256 public maxSupply = 5000;
1311   uint256 public maxMintAmount = 10;
1312   uint256 public nftPerAddressLimit = 5;
1313   bool public paused = false;
1314   bool public revealed = false;
1315   bool public onlyWhitelisted = true;
1316   address[] public whitelistedAddresses;
1317   mapping(address => uint256) public addressMintedBalance;
1318   
1319     // @dev struct used to receive array of addFreeUsers
1320   struct FreeLimit {
1321     address _address;
1322     uint256 _freeMax;
1323   }
1324 
1325   // @dev this mapping is used to set individual limits of free tokens
1326   mapping(address => uint256) public freeMintLimit;
1327   
1328   constructor(
1329     string memory _name,
1330     string memory _symbol,
1331     string memory _initBaseURI,
1332     string memory _initNotRevealedUri
1333   ) ERC721(_name, _symbol) {
1334     setBaseURI(_initBaseURI);
1335     setNotRevealedURI(_initNotRevealedUri);
1336   }
1337 
1338   // internal
1339   function _baseURI() internal view virtual override returns (string memory) {
1340     return baseURI;
1341   }
1342 
1343   // public
1344   function mint(uint256 _mintAmount) public payable {
1345     require(!paused, "the contract is paused");
1346     uint256 supply = totalSupply();
1347     require(_mintAmount > 0, "need to mint at least 1 NFT");
1348     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1349     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1350 
1351     if (msg.sender != owner()) {
1352         if(!isFreeEligible(msg.sender, _mintAmount)){
1353             if(onlyWhitelisted == true) {
1354                 require(isWhitelisted(msg.sender), "user is not whitelisted");
1355                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1356                 require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1357             }
1358         
1359         // Check to see if the user is on the freeList, and has available free balanceOf
1360         require(msg.value >= cost * _mintAmount, "insufficient funds");
1361         }
1362     }
1363     
1364     for (uint256 i = 1; i <= _mintAmount; i++) {
1365         addressMintedBalance[msg.sender]++;
1366       _safeMint(msg.sender, supply + i);
1367     }
1368   }
1369   
1370   function isWhitelisted(address _user) public view returns (bool) {
1371     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1372       if (whitelistedAddresses[i] == _user) {
1373           return true;
1374       }
1375     }
1376     return false;
1377   }
1378 
1379   function walletOfOwner(address _owner)
1380     public
1381     view
1382     returns (uint256[] memory)
1383   {
1384     uint256 ownerTokenCount = balanceOf(_owner);
1385     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1386     for (uint256 i; i < ownerTokenCount; i++) {
1387       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1388     }
1389     return tokenIds;
1390   }
1391 
1392   function tokenURI(uint256 tokenId)
1393     public
1394     view
1395     virtual
1396     override
1397     returns (string memory)
1398   {
1399     require(
1400       _exists(tokenId),
1401       "ERC721Metadata: URI query for nonexistent token"
1402     );
1403     
1404     if(revealed == false) {
1405         return notRevealedUri;
1406     }
1407 
1408     string memory currentBaseURI = _baseURI();
1409     return bytes(currentBaseURI).length > 0
1410         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1411         : "";
1412   }
1413 
1414     function isFreeEligible(address _address, uint256 _qty) public view returns(bool) {
1415         bool hasBalance = balanceOf(_address) + _qty <= freeMintLimit[msg.sender];
1416         
1417         return hasBalance;
1418     }
1419     
1420   //only owner
1421   
1422   // @dev Add users and individual free mint limits to the free mint mapping.
1423   // send an array of Structs, with each address & _freeMax value in square brackets:
1424   //
1425   // [["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", 1], ["0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c", 2]]
1426   function addFreeUsers(FreeLimit[] calldata _limits) public onlyOwner() {
1427     for(uint256  i = 0; i < _limits .length; i ++) {
1428     freeMintLimit[_limits[i]._address] = _limits[i]._freeMax;    
1429     }
1430     
1431   }
1432   
1433   
1434   
1435   function reveal() public onlyOwner() {
1436       revealed = true;
1437   }
1438   
1439   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1440     nftPerAddressLimit = _limit;
1441   }
1442   
1443   function setCost(uint256 _newCost) public onlyOwner() {
1444     cost = _newCost;
1445   }
1446 
1447   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1448     maxMintAmount = _newmaxMintAmount;
1449   }
1450 
1451   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1452     baseURI = _newBaseURI;
1453   }
1454 
1455   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1456     baseExtension = _newBaseExtension;
1457   }
1458   
1459   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1460     notRevealedUri = _notRevealedURI;
1461   }
1462 
1463   function pause(bool _state) public onlyOwner {
1464     paused = _state;
1465   }
1466   
1467   function setOnlyWhitelisted(bool _state) public onlyOwner {
1468     onlyWhitelisted = _state;
1469   }
1470   
1471   function whitelistUsers(address[] calldata _users) public onlyOwner {
1472     delete whitelistedAddresses;
1473     whitelistedAddresses = _users;
1474   }
1475  
1476   function withdraw() public payable onlyOwner {
1477     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1478     require(success);
1479   }
1480 }