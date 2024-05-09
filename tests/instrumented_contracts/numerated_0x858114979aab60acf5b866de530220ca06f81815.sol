1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Address.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
182 
183 pragma solidity ^0.8.1;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      *
206      * [IMPORTANT]
207      * ====
208      * You shouldn't rely on `isContract` to protect against flash loan attacks!
209      *
210      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
211      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
212      * constructor.
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize/address.code.length, which returns 0
217         // for contracts in construction, since the code is only stored at the end
218         // of the constructor execution.
219 
220         return account.code.length > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
407 
408 pragma solidity ^0.8.0;
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
423      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
473  * for the additional interface id that will be supported. For example:
474  *
475  * ```solidity
476  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
478  * }
479  * ```
480  *
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482  */
483 abstract contract ERC165 is IERC165 {
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         return interfaceId == type(IERC165).interfaceId;
489     }
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
516      */
517     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
518 
519     /**
520      * @dev Returns the number of tokens in ``owner``'s account.
521      */
522     function balanceOf(address owner) external view returns (uint256 balance);
523 
524     /**
525      * @dev Returns the owner of the `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function ownerOf(uint256 tokenId) external view returns (address owner);
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId,
550         bytes calldata data
551     ) external;
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
555      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
564      *
565      * Emits a {Transfer} event.
566      */
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Transfers `tokenId` token from `from` to `to`.
575      *
576      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
595      * The approval is cleared when the token is transferred.
596      *
597      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
598      *
599      * Requirements:
600      *
601      * - The caller must own the token or be an approved operator.
602      * - `tokenId` must exist.
603      *
604      * Emits an {Approval} event.
605      */
606     function approve(address to, uint256 tokenId) external;
607 
608     /**
609      * @dev Approve or remove `operator` as an operator for the caller.
610      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
611      *
612      * Requirements:
613      *
614      * - The `operator` cannot be the caller.
615      *
616      * Emits an {ApprovalForAll} event.
617      */
618     function setApprovalForAll(address operator, bool _approved) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
631      *
632      * See {setApprovalForAll}
633      */
634     function isApprovedForAll(address owner, address operator) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Metadata is IERC721 {
650     /**
651      * @dev Returns the token collection name.
652      */
653     function name() external view returns (string memory);
654 
655     /**
656      * @dev Returns the token collection symbol.
657      */
658     function symbol() external view returns (string memory);
659 
660     /**
661      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
662      */
663     function tokenURI(uint256 tokenId) external view returns (string memory);
664 }
665 
666 // File: erc721a/contracts/IERC721A.sol
667 
668 
669 // ERC721A Contracts v3.3.0
670 // Creator: Chiru Labs
671 
672 pragma solidity ^0.8.4;
673 
674 
675 
676 /**
677  * @dev Interface of an ERC721A compliant contract.
678  */
679 interface IERC721A is IERC721, IERC721Metadata {
680     /**
681      * The caller must own the token or be an approved operator.
682      */
683     error ApprovalCallerNotOwnerNorApproved();
684 
685     /**
686      * The token does not exist.
687      */
688     error ApprovalQueryForNonexistentToken();
689 
690     /**
691      * The caller cannot approve to their own address.
692      */
693     error ApproveToCaller();
694 
695     /**
696      * The caller cannot approve to the current owner.
697      */
698     error ApprovalToCurrentOwner();
699 
700     /**
701      * Cannot query the balance for the zero address.
702      */
703     error BalanceQueryForZeroAddress();
704 
705     /**
706      * Cannot mint to the zero address.
707      */
708     error MintToZeroAddress();
709 
710     /**
711      * The quantity of tokens minted must be more than zero.
712      */
713     error MintZeroQuantity();
714 
715     /**
716      * The token does not exist.
717      */
718     error OwnerQueryForNonexistentToken();
719 
720     /**
721      * The caller must own the token or be an approved operator.
722      */
723     error TransferCallerNotOwnerNorApproved();
724 
725     /**
726      * The token must be owned by `from`.
727      */
728     error TransferFromIncorrectOwner();
729 
730     /**
731      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
732      */
733     error TransferToNonERC721ReceiverImplementer();
734 
735     /**
736      * Cannot transfer to the zero address.
737      */
738     error TransferToZeroAddress();
739 
740     /**
741      * The token does not exist.
742      */
743     error URIQueryForNonexistentToken();
744 
745     // Compiler will pack this into a single 256bit word.
746     struct TokenOwnership {
747         // The address of the owner.
748         address addr;
749         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
750         uint64 startTimestamp;
751         // Whether the token has been burned.
752         bool burned;
753     }
754 
755     // Compiler will pack this into a single 256bit word.
756     struct AddressData {
757         // Realistically, 2**64-1 is more than enough.
758         uint64 balance;
759         // Keeps track of mint count with minimal overhead for tokenomics.
760         uint64 numberMinted;
761         // Keeps track of burn count with minimal overhead for tokenomics.
762         uint64 numberBurned;
763         // For miscellaneous variable(s) pertaining to the address
764         // (e.g. number of whitelist mint slots used).
765         // If there are multiple variables, please pack them into a uint64.
766         uint64 aux;
767     }
768 
769     /**
770      * @dev Returns the total amount of tokens stored by the contract.
771      * 
772      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
773      */
774     function totalSupply() external view returns (uint256);
775 }
776 
777 // File: erc721a/contracts/ERC721A.sol
778 
779 
780 // ERC721A Contracts v3.3.0
781 // Creator: Chiru Labs
782 
783 pragma solidity ^0.8.4;
784 
785 
786 
787 
788 
789 
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata extension. Built to optimize for lower gas during batch mints.
794  *
795  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
796  *
797  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
798  *
799  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
800  */
801 contract ERC721A is Context, ERC165, IERC721A {
802     using Address for address;
803     using Strings for uint256;
804 
805     // The tokenId of the next token to be minted.
806     uint256 internal _currentIndex;
807 
808     // The number of tokens burned.
809     uint256 internal _burnCounter;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to ownership details
818     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
819     mapping(uint256 => TokenOwnership) internal _ownerships;
820 
821     // Mapping owner address to address data
822     mapping(address => AddressData) private _addressData;
823 
824     // Mapping from token ID to approved address
825     mapping(uint256 => address) private _tokenApprovals;
826 
827     // Mapping from owner to operator approvals
828     mapping(address => mapping(address => bool)) private _operatorApprovals;
829 
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833         _currentIndex = _startTokenId();
834     }
835 
836     /**
837      * To change the starting tokenId, please override this function.
838      */
839     function _startTokenId() internal view virtual returns (uint256) {
840         return 0;
841     }
842 
843     /**
844      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
845      */
846     function totalSupply() public view override returns (uint256) {
847         // Counter underflow is impossible as _burnCounter cannot be incremented
848         // more than _currentIndex - _startTokenId() times
849         unchecked {
850             return _currentIndex - _burnCounter - _startTokenId();
851         }
852     }
853 
854     /**
855      * Returns the total amount of tokens minted in the contract.
856      */
857     function _totalMinted() internal view returns (uint256) {
858         // Counter underflow is impossible as _currentIndex does not decrement,
859         // and it is initialized to _startTokenId()
860         unchecked {
861             return _currentIndex - _startTokenId();
862         }
863     }
864 
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      * @dev See {IERC721-balanceOf}.
877      */
878     function balanceOf(address owner) public view override returns (uint256) {
879         if (owner == address(0)) revert BalanceQueryForZeroAddress();
880         return uint256(_addressData[owner].balance);
881     }
882 
883     /**
884      * Returns the number of tokens minted by `owner`.
885      */
886     function _numberMinted(address owner) internal view returns (uint256) {
887         return uint256(_addressData[owner].numberMinted);
888     }
889 
890     /**
891      * Returns the number of tokens burned by or on behalf of `owner`.
892      */
893     function _numberBurned(address owner) internal view returns (uint256) {
894         return uint256(_addressData[owner].numberBurned);
895     }
896 
897     /**
898      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      */
900     function _getAux(address owner) internal view returns (uint64) {
901         return _addressData[owner].aux;
902     }
903 
904     /**
905      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      * If there are multiple variables, please pack them into a uint64.
907      */
908     function _setAux(address owner, uint64 aux) internal {
909         _addressData[owner].aux = aux;
910     }
911 
912     /**
913      * Gas spent here starts off proportional to the maximum mint batch size.
914      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
915      */
916     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
917         uint256 curr = tokenId;
918 
919         unchecked {
920             if (_startTokenId() <= curr) if (curr < _currentIndex) {
921                 TokenOwnership memory ownership = _ownerships[curr];
922                 if (!ownership.burned) {
923                     if (ownership.addr != address(0)) {
924                         return ownership;
925                     }
926                     // Invariant:
927                     // There will always be an ownership that has an address and is not burned
928                     // before an ownership that does not have an address and is not burned.
929                     // Hence, curr will not underflow.
930                     while (true) {
931                         curr--;
932                         ownership = _ownerships[curr];
933                         if (ownership.addr != address(0)) {
934                             return ownership;
935                         }
936                     }
937                 }
938             }
939         }
940         revert OwnerQueryForNonexistentToken();
941     }
942 
943     /**
944      * @dev See {IERC721-ownerOf}.
945      */
946     function ownerOf(uint256 tokenId) public view override returns (address) {
947         return _ownershipOf(tokenId).addr;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return '';
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public override {
987         address owner = ERC721A.ownerOf(tokenId);
988         if (to == owner) revert ApprovalToCurrentOwner();
989 
990         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
991             revert ApprovalCallerNotOwnerNorApproved();
992         }
993 
994         _approve(to, tokenId, owner);
995     }
996 
997     /**
998      * @dev See {IERC721-getApproved}.
999      */
1000     function getApproved(uint256 tokenId) public view override returns (address) {
1001         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1002 
1003         return _tokenApprovals[tokenId];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-setApprovalForAll}.
1008      */
1009     function setApprovalForAll(address operator, bool approved) public virtual override {
1010         if (operator == _msgSender()) revert ApproveToCaller();
1011 
1012         _operatorApprovals[_msgSender()][operator] = approved;
1013         emit ApprovalForAll(_msgSender(), operator, approved);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-isApprovedForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1020         return _operatorApprovals[owner][operator];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-transferFrom}.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         _transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public virtual override {
1042         safeTransferFrom(from, to, tokenId, '');
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) public virtual override {
1054         _transfer(from, to, tokenId);
1055         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1056             revert TransferToNonERC721ReceiverImplementer();
1057         }
1058     }
1059 
1060     /**
1061      * @dev Returns whether `tokenId` exists.
1062      *
1063      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064      *
1065      * Tokens start existing when they are minted (`_mint`),
1066      */
1067     function _exists(uint256 tokenId) internal view returns (bool) {
1068         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1069     }
1070 
1071     /**
1072      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1073      */
1074     function _safeMint(address to, uint256 quantity) internal {
1075         _safeMint(to, quantity, '');
1076     }
1077 
1078     /**
1079      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - If `to` refers to a smart contract, it must implement
1084      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _safeMint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data
1093     ) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are incredibly unrealistic.
1101         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1102         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1103         unchecked {
1104             _addressData[to].balance += uint64(quantity);
1105             _addressData[to].numberMinted += uint64(quantity);
1106 
1107             _ownerships[startTokenId].addr = to;
1108             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1109 
1110             uint256 updatedIndex = startTokenId;
1111             uint256 end = updatedIndex + quantity;
1112 
1113             if (to.isContract()) {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex);
1116                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1117                         revert TransferToNonERC721ReceiverImplementer();
1118                     }
1119                 } while (updatedIndex < end);
1120                 // Reentrancy protection
1121                 if (_currentIndex != startTokenId) revert();
1122             } else {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex++);
1125                 } while (updatedIndex < end);
1126             }
1127             _currentIndex = updatedIndex;
1128         }
1129         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1130     }
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _mint(address to, uint256 quantity) internal {
1143         uint256 startTokenId = _currentIndex;
1144         if (to == address(0)) revert MintToZeroAddress();
1145         if (quantity == 0) revert MintZeroQuantity();
1146 
1147         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1148 
1149         // Overflows are incredibly unrealistic.
1150         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1151         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1152         unchecked {
1153             _addressData[to].balance += uint64(quantity);
1154             _addressData[to].numberMinted += uint64(quantity);
1155 
1156             _ownerships[startTokenId].addr = to;
1157             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1158 
1159             uint256 updatedIndex = startTokenId;
1160             uint256 end = updatedIndex + quantity;
1161 
1162             do {
1163                 emit Transfer(address(0), to, updatedIndex++);
1164             } while (updatedIndex < end);
1165 
1166             _currentIndex = updatedIndex;
1167         }
1168         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _transfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) private {
1186         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1187 
1188         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1189 
1190         bool isApprovedOrOwner = (_msgSender() == from ||
1191             isApprovedForAll(from, _msgSender()) ||
1192             getApproved(tokenId) == _msgSender());
1193 
1194         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         if (to == address(0)) revert TransferToZeroAddress();
1196 
1197         _beforeTokenTransfers(from, to, tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, from);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             _addressData[from].balance -= 1;
1207             _addressData[to].balance += 1;
1208 
1209             TokenOwnership storage currSlot = _ownerships[tokenId];
1210             currSlot.addr = to;
1211             currSlot.startTimestamp = uint64(block.timestamp);
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1217             if (nextSlot.addr == address(0)) {
1218                 // This will suffice for checking _exists(nextTokenId),
1219                 // as a burned slot cannot contain the zero address.
1220                 if (nextTokenId != _currentIndex) {
1221                     nextSlot.addr = from;
1222                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(from, to, tokenId);
1228         _afterTokenTransfers(from, to, tokenId, 1);
1229     }
1230 
1231     /**
1232      * @dev Equivalent to `_burn(tokenId, false)`.
1233      */
1234     function _burn(uint256 tokenId) internal virtual {
1235         _burn(tokenId, false);
1236     }
1237 
1238     /**
1239      * @dev Destroys `tokenId`.
1240      * The approval is cleared when the token is burned.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1249         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1250 
1251         address from = prevOwnership.addr;
1252 
1253         if (approvalCheck) {
1254             bool isApprovedOrOwner = (_msgSender() == from ||
1255                 isApprovedForAll(from, _msgSender()) ||
1256                 getApproved(tokenId) == _msgSender());
1257 
1258             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1259         }
1260 
1261         _beforeTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Clear approvals from the previous owner
1264         _approve(address(0), tokenId, from);
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             AddressData storage addressData = _addressData[from];
1271             addressData.balance -= 1;
1272             addressData.numberBurned += 1;
1273 
1274             // Keep track of who burned the token, and the timestamp of burning.
1275             TokenOwnership storage currSlot = _ownerships[tokenId];
1276             currSlot.addr = from;
1277             currSlot.startTimestamp = uint64(block.timestamp);
1278             currSlot.burned = true;
1279 
1280             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1281             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1282             uint256 nextTokenId = tokenId + 1;
1283             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1284             if (nextSlot.addr == address(0)) {
1285                 // This will suffice for checking _exists(nextTokenId),
1286                 // as a burned slot cannot contain the zero address.
1287                 if (nextTokenId != _currentIndex) {
1288                     nextSlot.addr = from;
1289                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1290                 }
1291             }
1292         }
1293 
1294         emit Transfer(from, address(0), tokenId);
1295         _afterTokenTransfers(from, address(0), tokenId, 1);
1296 
1297         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1298         unchecked {
1299             _burnCounter++;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Approve `to` to operate on `tokenId`
1305      *
1306      * Emits a {Approval} event.
1307      */
1308     function _approve(
1309         address to,
1310         uint256 tokenId,
1311         address owner
1312     ) private {
1313         _tokenApprovals[tokenId] = to;
1314         emit Approval(owner, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1319      *
1320      * @param from address representing the previous owner of the given token ID
1321      * @param to target address that will receive the tokens
1322      * @param tokenId uint256 ID of the token to be transferred
1323      * @param _data bytes optional data to send along with the call
1324      * @return bool whether the call correctly returned the expected magic value
1325      */
1326     function _checkContractOnERC721Received(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) private returns (bool) {
1332         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1333             return retval == IERC721Receiver(to).onERC721Received.selector;
1334         } catch (bytes memory reason) {
1335             if (reason.length == 0) {
1336                 revert TransferToNonERC721ReceiverImplementer();
1337             } else {
1338                 assembly {
1339                     revert(add(32, reason), mload(reason))
1340                 }
1341             }
1342         }
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1347      * And also called before burning one token.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, `tokenId` will be burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1369      * minting.
1370      * And also called after one token has been burned.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` has been minted for `to`.
1380      * - When `to` is zero, `tokenId` has been burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _afterTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 }
1390 
1391 // File: contract.sol
1392 
1393 
1394 pragma solidity ^0.8.4;
1395 
1396 
1397 
1398 contract innocentchaos is ERC721A, Ownable {
1399     using Strings for uint256;
1400 
1401     uint256 MAX_MINTS = 1;
1402     uint256 MAX_SUPPLY = 222;
1403     bool private paused = true;
1404     uint256 MAX_FREE = 222;
1405     uint256 public mintRate = 0 ether;
1406 
1407     string public baseURI = "ipfs://chaos/";
1408 
1409     constructor() ERC721A("Innocent Chaos", "cos") {}
1410 
1411     modifier callerIsuser(){
1412         require(tx.origin ==msg.sender, "Can't be called from contract");
1413         _;
1414     }
1415 
1416     function mint(uint256 quantity) external payable callerIsuser {
1417         uint256 freemint = 0 ether;
1418         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
1419         require(!paused);
1420         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1421         if(totalSupply() + quantity <=MAX_FREE){
1422             require(msg.value >= (freemint * quantity), "Not enough ether sent");
1423         }
1424         else{
1425             require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1426         }
1427         _safeMint(msg.sender, quantity);
1428     }
1429 
1430     function _baseURI() internal view override returns (string memory) {
1431         return baseURI;
1432     }
1433 
1434     function setMintRate(uint256 _mintRate) public onlyOwner {
1435         mintRate = _mintRate;
1436     }
1437 
1438     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1439         baseURI = _newBaseURI;
1440     }
1441 
1442     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1443       require( _exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1444       string memory currentBaseURI = _baseURI();
1445       uint256 trueid = tokenId + 1;
1446       return bytes(currentBaseURI).length > 0
1447           ? string(abi.encodePacked(currentBaseURI, trueid.toString() , ".json"))
1448           : "";
1449     }
1450 
1451     
1452     function withdrawsplitter() external payable onlyOwner {
1453         uint balance = address(this).balance;
1454         address ad1 = 0xFd42450Dc82328aB8c9628456108F9F1F21cBE0c;
1455         payable(ad1).transfer((balance *100) / 100);
1456     }
1457 
1458   function unpause(bool _state) public onlyOwner {
1459     paused = _state;
1460   }
1461 
1462   function setMaxPerWallet(uint256 newmaxperwallet) public onlyOwner {
1463       MAX_MINTS = newmaxperwallet;
1464   }
1465     
1466 }