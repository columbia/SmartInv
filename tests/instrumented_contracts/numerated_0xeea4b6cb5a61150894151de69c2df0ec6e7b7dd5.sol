1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5 ########   #######   ######   ##       #### ######## ##    ##  ######  
6 ##     ## ##     ## ##    ##  ##        ##  ##       ###   ## ##    ## 
7 ##     ## ##     ## ##        ##        ##  ##       ####  ## ##       
8 ##     ## ##     ## ##   #### ##        ##  ######   ## ## ##  ######  
9 ##     ## ##     ## ##    ##  ##        ##  ##       ##  ####       ## 
10 ##     ## ##     ## ##    ##  ##        ##  ##       ##   ### ##    ## 
11 ########   #######   ######   ######## #### ######## ##    ##  ######  
12 
13 */
14 
15 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
16 
17 pragma solidity ^0.8.0;
18 
19 abstract contract ReentrancyGuard {
20     
21     uint256 private constant _NOT_ENTERED = 1;
22     uint256 private constant _ENTERED = 2;
23 
24     uint256 private _status;
25 
26     constructor() {
27         _status = _NOT_ENTERED;
28     }
29 
30     modifier nonReentrant() {
31         // On the first call to nonReentrant, _notEntered will be true
32         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
33 
34         // Any calls to nonReentrant after this point will fail
35         _status = _ENTERED;
36 
37         _;
38 
39         _status = _NOT_ENTERED;
40     }
41 }
42 
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
84      */
85     function toHexString(uint256 value) internal pure returns (string memory) {
86         if (value == 0) {
87             return "0x00";
88         }
89         uint256 temp = value;
90         uint256 length = 0;
91         while (temp != 0) {
92             length++;
93             temp >>= 8;
94         }
95         return toHexString(value, length);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
100      */
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Address.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
118 
119 pragma solidity ^0.8.1;
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      *
142      * [IMPORTANT]
143      * ====
144      * You shouldn't rely on `isContract` to protect against flash loan attacks!
145      *
146      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
147      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
148      * constructor.
149      * ====
150      */
151     function isContract(address account) internal view returns (bool) {
152         // This method relies on extcodesize/address.code.length, which returns 0
153         // for contracts in construction, since the code is only stored at the end
154         // of the constructor execution.
155 
156         return account.code.length > 0;
157     }
158 
159     /**
160      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
161      * `recipient`, forwarding all available gas and reverting on errors.
162      *
163      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
164      * of certain opcodes, possibly making contracts go over the 2300 gas limit
165      * imposed by `transfer`, making them unable to receive funds via
166      * `transfer`. {sendValue} removes this limitation.
167      *
168      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
169      *
170      * IMPORTANT: because control is transferred to `recipient`, care must be
171      * taken to not create reentrancy vulnerabilities. Consider using
172      * {ReentrancyGuard} or the
173      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
174      */
175     function sendValue(address payable recipient, uint256 amount) internal {
176         require(address(this).balance >= amount, "Address: insufficient balance");
177 
178         (bool success, ) = recipient.call{value: amount}("");
179         require(success, "Address: unable to send value, recipient may have reverted");
180     }
181 
182     /**
183      * @dev Performs a Solidity function call using a low level `call`. A
184      * plain `call` is an unsafe replacement for a function call: use this
185      * function instead.
186      *
187      * If `target` reverts with a revert reason, it is bubbled up by this
188      * function (like regular Solidity function calls).
189      *
190      * Returns the raw returned data. To convert to the expected return value,
191      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
192      *
193      * Requirements:
194      *
195      * - `target` must be a contract.
196      * - calling `target` with `data` must not revert.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
206      * `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, 0, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but also transferring `value` wei to `target`.
221      *
222      * Requirements:
223      *
224      * - the calling contract must have an ETH balance of at least `value`.
225      * - the called Solidity function must be `payable`.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
239      * with `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         require(address(this).balance >= value, "Address: insufficient balance for call");
250         require(isContract(target), "Address: call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.call{value: value}(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a static call.
259      *
260      * _Available since v3.3._
261      */
262     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
263         return functionStaticCall(target, data, "Address: low-level static call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal view returns (bytes memory) {
277         require(isContract(target), "Address: static call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.staticcall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a delegate call.
286      *
287      * _Available since v3.4._
288      */
289     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(isContract(target), "Address: delegate call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.delegatecall(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
312      * revert reason using the provided one.
313      *
314      * _Available since v4.3._
315      */
316     function verifyCallResult(
317         bool success,
318         bytes memory returndata,
319         string memory errorMessage
320     ) internal pure returns (bytes memory) {
321         if (success) {
322             return returndata;
323         } else {
324             // Look for revert reason and bubble it up if present
325             if (returndata.length > 0) {
326                 // The easiest way to bubble the revert reason is using memory via assembly
327 
328                 assembly {
329                     let returndata_size := mload(returndata)
330                     revert(add(32, returndata), returndata_size)
331                 }
332             } else {
333                 revert(errorMessage);
334             }
335         }
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/Context.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 abstract contract Context {
347     function _msgSender() internal view virtual returns (address) {
348         return msg.sender;
349     }
350 
351     function _msgData() internal view virtual returns (bytes calldata) {
352         return msg.data;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/access/Ownable.sol
357 
358 pragma solidity ^0.8.0;
359 
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor() {
369         _transferOwnership(_msgSender());
370     }
371 
372     /**
373      * @dev Returns the address of the current owner.
374      */
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _transferOwnership(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _transferOwnership(newOwner);
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Internal function without access restriction.
410      */
411     function _transferOwnership(address newOwner) internal virtual {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC165 standard, as defined in the
427  * https://eips.ethereum.org/EIPS/eip-165[EIP].
428  *
429  * Implementers can declare support of contract interfaces, which can then be
430  * queried by others ({ERC165Checker}).
431  *
432  * For an implementation, see {ERC165}.
433  */
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Implementation of the {IERC165} interface.
456  *
457  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
458  * for the additional interface id that will be supported. For example:
459  *
460  * ```solidity
461  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
463  * }
464  * ```
465  *
466  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
467  */
468 abstract contract ERC165 is IERC165 {
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473         return interfaceId == type(IERC165).interfaceId;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Required interface of an ERC721 compliant contract.
487  */
488 interface IERC721 is IERC165 {
489     /**
490      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
501      */
502     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
503 
504     /**
505      * @dev Returns the number of tokens in ``owner``'s account.
506      */
507     function balanceOf(address owner) external view returns (uint256 balance);
508 
509     /**
510      * @dev Returns the owner of the `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function ownerOf(uint256 tokenId) external view returns (address owner);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external;
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
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
616      *
617      * See {setApprovalForAll}
618      */
619     function isApprovedForAll(address owner, address operator) external view returns (bool);
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
623 
624 
625 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 interface IERC721Receiver {
630   
631     function onERC721Received(
632         address operator,
633         address from,
634         uint256 tokenId,
635         bytes calldata data
636     ) external returns (bytes4);
637 }
638 
639 
640 
641 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
651  * @dev See https://eips.ethereum.org/EIPS/eip-721
652  */
653 interface IERC721Metadata is IERC721 {
654     /**
655      * @dev Returns the token collection name.
656      */
657     function name() external view returns (string memory);
658 
659     /**
660      * @dev Returns the token collection symbol.
661      */
662     function symbol() external view returns (string memory);
663 
664     /**
665      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
666      */
667     function tokenURI(uint256 tokenId) external view returns (string memory);
668 }
669 
670 // File: erc721a/contracts/IERC721A.sol
671 
672 
673 // ERC721A Contracts v3.3.0
674 // Creator: Chiru Labs
675 
676 pragma solidity ^0.8.4;
677 
678 
679 
680 /**
681  * @dev Interface of an ERC721A compliant contract.
682  */
683 interface IERC721A is IERC721, IERC721Metadata {
684     /**
685      * The caller must own the token or be an approved operator.
686      */
687     error ApprovalCallerNotOwnerNorApproved();
688 
689     /**
690      * The token does not exist.
691      */
692     error ApprovalQueryForNonexistentToken();
693 
694     /**
695      * The caller cannot approve to their own address.
696      */
697     error ApproveToCaller();
698 
699     /**
700      * The caller cannot approve to the current owner.
701      */
702     error ApprovalToCurrentOwner();
703 
704     /**
705      * Cannot query the balance for the zero address.
706      */
707     error BalanceQueryForZeroAddress();
708 
709     /**
710      * Cannot mint to the zero address.
711      */
712     error MintToZeroAddress();
713 
714     /**
715      * The quantity of tokens minted must be more than zero.
716      */
717     error MintZeroQuantity();
718 
719     /**
720      * The token does not exist.
721      */
722     error OwnerQueryForNonexistentToken();
723 
724     /**
725      * The caller must own the token or be an approved operator.
726      */
727     error TransferCallerNotOwnerNorApproved();
728 
729     /**
730      * The token must be owned by `from`.
731      */
732     error TransferFromIncorrectOwner();
733 
734     /**
735      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
736      */
737     error TransferToNonERC721ReceiverImplementer();
738 
739     /**
740      * Cannot transfer to the zero address.
741      */
742     error TransferToZeroAddress();
743 
744     /**
745      * The token does not exist.
746      */
747     error URIQueryForNonexistentToken();
748 
749     // Compiler will pack this into a single 256bit word.
750     struct TokenOwnership {
751         // The address of the owner.
752         address addr;
753         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
754         uint64 startTimestamp;
755         // Whether the token has been burned.
756         bool burned;
757     }
758 
759     // Compiler will pack this into a single 256bit word.
760     struct AddressData {
761         // Realistically, 2**64-1 is more than enough.
762         uint64 balance;
763         // Keeps track of mint count with minimal overhead for tokenomics.
764         uint64 numberMinted;
765         // Keeps track of burn count with minimal overhead for tokenomics.
766         uint64 numberBurned;
767         // For miscellaneous variable(s) pertaining to the address
768         // (e.g. number of whitelist mint slots used).
769         // If there are multiple variables, please pack them into a uint64.
770         uint64 aux;
771     }
772 
773     /**
774      * @dev Returns the total amount of tokens stored by the contract.
775      * 
776      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
777      */
778     function totalSupply() external view returns (uint256);
779 }
780 
781 
782 // File: erc721a/contracts/ERC721A.sol
783 
784 // ERC721A Contracts v3.3.0
785 // Creator: Chiru Labs
786 
787 pragma solidity ^0.8.4;
788 
789 /**
790  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
791  * the Metadata extension. Built to optimize for lower gas during batch mints.
792  *
793  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
794  *
795  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
796  *
797  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
798  */
799 contract ERC721A is Context, ERC165, IERC721A {
800     using Address for address;
801     using Strings for uint256;
802 
803     // The tokenId of the next token to be minted.
804     uint256 internal _currentIndex;
805 
806     // The number of tokens burned.
807     uint256 internal _burnCounter;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     constructor(string memory name_, string memory symbol_) {
829         _name = name_;
830         _symbol = symbol_;
831         _currentIndex = _startTokenId();
832     }
833 
834     /**
835      * To change the starting tokenId, please override this function.
836      */
837     function _startTokenId() internal view virtual returns (uint256) {
838         return 0;
839     }
840 
841     /**
842      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
843      */
844     function totalSupply() public view override returns (uint256) {
845         // Counter underflow is impossible as _burnCounter cannot be incremented
846         // more than _currentIndex - _startTokenId() times
847         unchecked {
848             return _currentIndex - _burnCounter - _startTokenId();
849         }
850     }
851 
852     /**
853      * Returns the total amount of tokens minted in the contract.
854      */
855     function _totalMinted() internal view returns (uint256) {
856         // Counter underflow is impossible as _currentIndex does not decrement,
857         // and it is initialized to _startTokenId()
858         unchecked {
859             return _currentIndex - _startTokenId();
860         }
861     }
862 
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
867         return
868             interfaceId == type(IERC721).interfaceId ||
869             interfaceId == type(IERC721Metadata).interfaceId ||
870             super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721-balanceOf}.
875      */
876     function balanceOf(address owner) public view override returns (uint256) {
877         if (owner == address(0)) revert BalanceQueryForZeroAddress();
878         return uint256(_addressData[owner].balance);
879     }
880 
881     /**
882      * Returns the number of tokens minted by `owner`.
883      */
884     function _numberMinted(address owner) internal view returns (uint256) {
885         return uint256(_addressData[owner].numberMinted);
886     }
887 
888     /**
889      * Returns the number of tokens burned by or on behalf of `owner`.
890      */
891     function _numberBurned(address owner) internal view returns (uint256) {
892         return uint256(_addressData[owner].numberBurned);
893     }
894 
895     /**
896      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
897      */
898     function _getAux(address owner) internal view returns (uint64) {
899         return _addressData[owner].aux;
900     }
901 
902     /**
903      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      * If there are multiple variables, please pack them into a uint64.
905      */
906     function _setAux(address owner, uint64 aux) internal {
907         _addressData[owner].aux = aux;
908     }
909 
910     /**
911      * Gas spent here starts off proportional to the maximum mint batch size.
912      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
913      */
914     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
915         uint256 curr = tokenId;
916 
917         unchecked {
918             if (_startTokenId() <= curr) if (curr < _currentIndex) {
919                 TokenOwnership memory ownership = _ownerships[curr];
920                 if (!ownership.burned) {
921                     if (ownership.addr != address(0)) {
922                         return ownership;
923                     }
924                     // Invariant:
925                     // There will always be an ownership that has an address and is not burned
926                     // before an ownership that does not have an address and is not burned.
927                     // Hence, curr will not underflow.
928                     while (true) {
929                         curr--;
930                         ownership = _ownerships[curr];
931                         if (ownership.addr != address(0)) {
932                             return ownership;
933                         }
934                     }
935                 }
936             }
937         }
938         revert OwnerQueryForNonexistentToken();
939     }
940 
941     /**
942      * @dev See {IERC721-ownerOf}.
943      */
944     function ownerOf(uint256 tokenId) public view override returns (address) {
945         return _ownershipOf(tokenId).addr;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-name}.
950      */
951     function name() public view virtual override returns (string memory) {
952         return _name;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-symbol}.
957      */
958     function symbol() public view virtual override returns (string memory) {
959         return _symbol;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-tokenURI}.
964      */
965     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
966         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
967 
968         string memory baseURI = _baseURI();
969         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
970     }
971 
972     /**
973      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
974      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
975      * by default, can be overriden in child contracts.
976      */
977     function _baseURI() internal view virtual returns (string memory) {
978         return '';
979     }
980 
981     /**
982      * @dev See {IERC721-approve}.
983      */
984     function approve(address to, uint256 tokenId) public override {
985         address owner = ERC721A.ownerOf(tokenId);
986         if (to == owner) revert ApprovalToCurrentOwner();
987 
988         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
989             revert ApprovalCallerNotOwnerNorApproved();
990         }
991 
992         _approve(to, tokenId, owner);
993     }
994 
995     /**
996      * @dev See {IERC721-getApproved}.
997      */
998     function getApproved(uint256 tokenId) public view override returns (address) {
999         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         if (operator == _msgSender()) revert ApproveToCaller();
1009 
1010         _operatorApprovals[_msgSender()][operator] = approved;
1011         emit ApprovalForAll(_msgSender(), operator, approved);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-isApprovedForAll}.
1016      */
1017     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1018         return _operatorApprovals[owner][operator];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-transferFrom}.
1023      */
1024     function transferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         _transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         safeTransferFrom(from, to, tokenId, '');
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) public virtual override {
1052         _transfer(from, to, tokenId);
1053         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1054             revert TransferToNonERC721ReceiverImplementer();
1055         }
1056     }
1057 
1058     /**
1059      * @dev Returns whether `tokenId` exists.
1060      *
1061      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1062      *
1063      * Tokens start existing when they are minted (`_mint`),
1064      */
1065     function _exists(uint256 tokenId) internal view returns (bool) {
1066         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1067     }
1068 
1069     /**
1070      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1071      */
1072     function _safeMint(address to, uint256 quantity) internal {
1073         _safeMint(to, quantity, '');
1074     }
1075 
1076     /**
1077      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - If `to` refers to a smart contract, it must implement
1082      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data
1091     ) internal {
1092         uint256 startTokenId = _currentIndex;
1093         if (to == address(0)) revert MintToZeroAddress();
1094         if (quantity == 0) revert MintZeroQuantity();
1095 
1096         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098         // Overflows are incredibly unrealistic.
1099         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1100         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1101         unchecked {
1102             _addressData[to].balance += uint64(quantity);
1103             _addressData[to].numberMinted += uint64(quantity);
1104 
1105             _ownerships[startTokenId].addr = to;
1106             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1107 
1108             uint256 updatedIndex = startTokenId;
1109             uint256 end = updatedIndex + quantity;
1110 
1111             if (to.isContract()) {
1112                 do {
1113                     emit Transfer(address(0), to, updatedIndex);
1114                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1115                         revert TransferToNonERC721ReceiverImplementer();
1116                     }
1117                 } while (updatedIndex < end);
1118                 // Reentrancy protection
1119                 if (_currentIndex != startTokenId) revert();
1120             } else {
1121                 do {
1122                     emit Transfer(address(0), to, updatedIndex++);
1123                 } while (updatedIndex < end);
1124             }
1125             _currentIndex = updatedIndex;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _mint(address to, uint256 quantity) internal {
1141         uint256 startTokenId = _currentIndex;
1142         if (to == address(0)) revert MintToZeroAddress();
1143         if (quantity == 0) revert MintZeroQuantity();
1144 
1145         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1146 
1147         // Overflows are incredibly unrealistic.
1148         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1149         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1150         unchecked {
1151             _addressData[to].balance += uint64(quantity);
1152             _addressData[to].numberMinted += uint64(quantity);
1153 
1154             _ownerships[startTokenId].addr = to;
1155             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1156 
1157             uint256 updatedIndex = startTokenId;
1158             uint256 end = updatedIndex + quantity;
1159 
1160             do {
1161                 emit Transfer(address(0), to, updatedIndex++);
1162             } while (updatedIndex < end);
1163 
1164             _currentIndex = updatedIndex;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168 
1169     /**
1170      * @dev Transfers `tokenId` from `from` to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `to` cannot be the zero address.
1175      * - `tokenId` token must be owned by `from`.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _transfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) private {
1184         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1185 
1186         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1187 
1188         bool isApprovedOrOwner = (_msgSender() == from ||
1189             isApprovedForAll(from, _msgSender()) ||
1190             getApproved(tokenId) == _msgSender());
1191 
1192         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1193         if (to == address(0)) revert TransferToZeroAddress();
1194 
1195         _beforeTokenTransfers(from, to, tokenId, 1);
1196 
1197         // Clear approvals from the previous owner
1198         _approve(address(0), tokenId, from);
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1203         unchecked {
1204             _addressData[from].balance -= 1;
1205             _addressData[to].balance += 1;
1206 
1207             TokenOwnership storage currSlot = _ownerships[tokenId];
1208             currSlot.addr = to;
1209             currSlot.startTimestamp = uint64(block.timestamp);
1210 
1211             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1212             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1213             uint256 nextTokenId = tokenId + 1;
1214             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1215             if (nextSlot.addr == address(0)) {
1216                 // This will suffice for checking _exists(nextTokenId),
1217                 // as a burned slot cannot contain the zero address.
1218                 if (nextTokenId != _currentIndex) {
1219                     nextSlot.addr = from;
1220                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1221                 }
1222             }
1223         }
1224 
1225         emit Transfer(from, to, tokenId);
1226         _afterTokenTransfers(from, to, tokenId, 1);
1227     }
1228 
1229     /**
1230      * @dev Equivalent to `_burn(tokenId, false)`.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         _burn(tokenId, false);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1247         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1248 
1249         address from = prevOwnership.addr;
1250 
1251         if (approvalCheck) {
1252             bool isApprovedOrOwner = (_msgSender() == from ||
1253                 isApprovedForAll(from, _msgSender()) ||
1254                 getApproved(tokenId) == _msgSender());
1255 
1256             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1257         }
1258 
1259         _beforeTokenTransfers(from, address(0), tokenId, 1);
1260 
1261         // Clear approvals from the previous owner
1262         _approve(address(0), tokenId, from);
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1267         unchecked {
1268             AddressData storage addressData = _addressData[from];
1269             addressData.balance -= 1;
1270             addressData.numberBurned += 1;
1271 
1272             // Keep track of who burned the token, and the timestamp of burning.
1273             TokenOwnership storage currSlot = _ownerships[tokenId];
1274             currSlot.addr = from;
1275             currSlot.startTimestamp = uint64(block.timestamp);
1276             currSlot.burned = true;
1277 
1278             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1279             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1280             uint256 nextTokenId = tokenId + 1;
1281             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1282             if (nextSlot.addr == address(0)) {
1283                 // This will suffice for checking _exists(nextTokenId),
1284                 // as a burned slot cannot contain the zero address.
1285                 if (nextTokenId != _currentIndex) {
1286                     nextSlot.addr = from;
1287                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1288                 }
1289             }
1290         }
1291 
1292         emit Transfer(from, address(0), tokenId);
1293         _afterTokenTransfers(from, address(0), tokenId, 1);
1294 
1295         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1296         unchecked {
1297             _burnCounter++;
1298         }
1299     }
1300 
1301     /**
1302      * @dev Approve `to` to operate on `tokenId`
1303      *
1304      * Emits a {Approval} event.
1305      */
1306     function _approve(
1307         address to,
1308         uint256 tokenId,
1309         address owner
1310     ) private {
1311         _tokenApprovals[tokenId] = to;
1312         emit Approval(owner, to, tokenId);
1313     }
1314 
1315 
1316     function _checkContractOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323             return retval == IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335  
1336     function _beforeTokenTransfers(
1337         address from,
1338         address to,
1339         uint256 startTokenId,
1340         uint256 quantity
1341     ) internal virtual {}
1342 
1343 
1344     function _afterTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 }
1351 
1352 // STAKING CONTRACT
1353 interface Staking {
1354   function claim(uint256[] calldata tokenIds) external;
1355   function claimForAddress(address account, uint256[] calldata tokenIds) external;
1356   function unstake(uint256[] calldata tokenIds) external;
1357 }
1358 
1359 // HEADACHE CONTRACT
1360 interface Headache {
1361   function mintDapp(uint256 _mintAmount, address _receiver) external;
1362 }
1363 
1364 // TOKENS REWARDS
1365 interface TokenRewards {
1366   function mint(address to, uint256 amount) external;
1367   function burnFrom(address account, uint256 amount) external;
1368   function balanceOf(address owner) external view returns (uint256 balance);
1369 }
1370 
1371 
1372 // File: contracts/NFTStaking.sol
1373 
1374 pragma solidity >= 0.8.0 < 0.9.0;
1375 
1376 contract A_STAKING_EXT is Ownable, ReentrancyGuard {
1377 
1378   address public wallet;
1379   address public signerAddress;
1380   address public headache_wallet;
1381   uint256 public stakeTime = 2629743;
1382   uint256 public doglienID = 1501;
1383 
1384   uint256 public cost = 0.1 ether;
1385   uint256 public cost2 = 0.1 ether;
1386   uint256 public discRate = 300 * 10 ** 18;
1387   uint256 public discountRate = 2;
1388   
1389   uint256 public dogliensPerAddressLimit = 5;
1390   uint256 public headachePerAddressLimit = 5;
1391   uint256 public MaxperTx = 5;
1392   
1393   bool public signatureRequired = true;
1394   bool public claimDoglienEnabled = true;
1395   bool public mintHeadacheEnabled = true;
1396   
1397   mapping(address => uint256) public EXTRA_KEYS;
1398   mapping(address => uint256) public lastRewardsClaim;
1399   mapping(address => uint256) public addressMintedDogliens;
1400   mapping(address => uint256) public addressMintedHeadache;
1401 
1402   // reference to the Dogliens NFT contracts & ERC20 token
1403   ERC721A nft;
1404   TokenRewards token;
1405   Headache headacheContract;
1406   Staking stakingContract;
1407 
1408    constructor (ERC721A _nft, TokenRewards _token, Headache _headacheContract, Staking _stakingContract) {
1409     nft = _nft;
1410     token = _token;
1411     headacheContract = _headacheContract;
1412     stakingContract = _stakingContract;
1413   }
1414   
1415 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1416 
1417   modifier mintCompliance(uint256 _mintAmount, bytes memory sig) {
1418     if (signatureRequired) {
1419         require(isValidData(msg.sender, sig) == true, "Invalid signature!");
1420     }
1421     require(_mintAmount > 0, "Mint amount can't be zero.");
1422     _;
1423   }
1424 
1425 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1426   // CLAIM DOGLIENS WITH DISC
1427   function claimDoglien(bytes memory sig) public payable {
1428     if (signatureRequired) {
1429         require(isValidData(msg.sender, sig) == true, "Invalid signature!");
1430     }
1431     require(claimDoglienEnabled, "Doglien claim is not active yet!");
1432     require(doglienID <= 2000, "No more dogliens to claim!");
1433     require(addressMintedDogliens[msg.sender] < dogliensPerAddressLimit, "Max mint amount per address exceeded!");
1434     require(token.balanceOf(_msgSender()) >= discRate, "insufficient DISC balance");
1435     require(msg.value >= cost / discountRate, "insufficient funds!");
1436 
1437     token.burnFrom(_msgSender(), discRate);
1438     nft.safeTransferFrom(headache_wallet, msg.sender, doglienID);
1439     addressMintedDogliens[msg.sender] += 1;
1440     doglienID += 1;
1441   }
1442 
1443   // CLAIM EXTRA DOGLIENS
1444   function mintExtraDogliens() public payable {
1445     require(EXTRA_KEYS[msg.sender] > 0, "Not enough EXTRA KEYS!");
1446     require(doglienID <= 2000, "No more dogliens to claim!");
1447     require(msg.value >= cost / discountRate, "Insufficient funds!");
1448 
1449     nft.safeTransferFrom(headache_wallet, msg.sender, doglienID);
1450     EXTRA_KEYS[msg.sender] -= 1;
1451     doglienID += 1;
1452   }
1453 
1454   // MINT HEADACHE WITH DISC
1455   function mintHeadacheDisc(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount, sig) {
1456     require(mintHeadacheEnabled, "Headache mint is not active yet!");
1457     require(addressMintedHeadache[msg.sender] + _mintAmount <= headachePerAddressLimit, "Max mint amount per address exceeded!");
1458     require(token.balanceOf(_msgSender()) >= discRate * _mintAmount, "Insufficient DISC balance");
1459     require(msg.value >= cost2 * _mintAmount / discountRate, "Insufficient funds!");
1460 
1461     token.burnFrom(_msgSender(), discRate * _mintAmount);
1462     headacheContract.mintDapp(_mintAmount, msg.sender);
1463     addressMintedHeadache[msg.sender] += _mintAmount;
1464   }
1465 
1466   // MINT EXTRA HEADACHE
1467   function mintExtraHeadache(uint256 _mintAmount) public payable {
1468     require(EXTRA_KEYS[msg.sender] > 0, "Not enough EXTRA KEYS!");
1469     require(_mintAmount <= EXTRA_KEYS[msg.sender], "Not enough EXTRA KEYS!");
1470     require(_mintAmount <= MaxperTx, "Max mint amount per tx exceeded!");
1471     require(msg.value >= cost2 * _mintAmount / discountRate, "Insufficient funds!");
1472 
1473     headacheContract.mintDapp(_mintAmount, msg.sender);
1474     EXTRA_KEYS[msg.sender] -= _mintAmount;
1475   }
1476 
1477   // MINT HEADACHE FULL ETH
1478   function mintHeadache(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount, sig) {
1479     require(mintHeadacheEnabled, "Headache mint is not active yet!");
1480     require(addressMintedHeadache[msg.sender] + _mintAmount <= headachePerAddressLimit, "Max mint amount per address exceeded!");
1481     require(msg.value >= cost2 * _mintAmount, "Insufficient funds!");
1482 
1483     headacheContract.mintDapp(_mintAmount, msg.sender);
1484     addressMintedHeadache[msg.sender] += _mintAmount;
1485   }
1486 
1487   // Token rewards
1488   function claim(address account, uint256 amount, uint256[] calldata tokenIds, bytes memory sig) external {
1489     require(isValidData(wallet, sig) == true, "Invalid Address!");
1490     require(block.timestamp - lastRewardsClaim[account] >= 180, "Need to wait 3 minutes between each rewards claim transaction.");
1491 
1492     lastRewardsClaim[account] = block.timestamp;
1493     stakingContract.claimForAddress(account, tokenIds);
1494     token.mint(account, amount);
1495   }
1496 
1497   // Token rewards extended
1498   function claimExt(address account, uint256 amount, bytes memory sig) external {
1499     require(isValidData(wallet, sig) == true, "Invalid wallet address!");
1500 
1501     lastRewardsClaim[account] = block.timestamp;
1502     token.mint(account, amount);
1503   }
1504   
1505 // ~~~~~~~~~~~~~~~~~~~~ SIGNATURES ~~~~~~~~~~~~~~~~~~~~
1506   function isValidData(address _user, bytes memory sig) public view returns (bool) {
1507     bytes32 message = keccak256(abi.encodePacked(_user));
1508     return (recoverSigner(message, sig) == signerAddress);
1509   }
1510 
1511   function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address) {
1512     uint8 v; bytes32 r; bytes32 s;
1513     (v, r, s) = splitSignature(sig);
1514     return ecrecover(message, v, r, s);
1515   }
1516 
1517   function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32) {
1518     require(sig.length == 65);
1519     bytes32 r; bytes32 s; uint8 v;
1520     assembly { r := mload(add(sig, 32)) s := mload(add(sig, 64)) v := byte(0, mload(add(sig, 96))) }
1521     return (v, r, s);
1522   }
1523 
1524 
1525 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1526 
1527   // SIGNER
1528   function setSigner(address _newSigner) public onlyOwner {
1529     signerAddress = _newSigner;
1530   }
1531 
1532   // SET SIGNATURE REQUIRED
1533   function setSignatureRequired(bool _state) public onlyOwner {
1534     signatureRequired = _state;
1535   }
1536 
1537   // SET STAKE TIME
1538   function setStakeTime(uint256 _stakeTime) public onlyOwner {
1539     stakeTime = _stakeTime;
1540   }
1541 
1542   // SET COST
1543   function setCostDogliens(uint256 _costDogliens) public onlyOwner {
1544     cost = _costDogliens;
1545   }
1546 
1547   // SET COST 2
1548   function setCostHeadache(uint256 _costHeadache) public onlyOwner {
1549     cost2 = _costHeadache;
1550   }
1551 
1552   // SET DISC COST
1553   function setDiscCost(uint256 _discCost) public onlyOwner {
1554     discRate = _discCost;
1555   }
1556 
1557   // SET DISCOUNT RATE
1558   function setDiscountRate(uint256 _discountRate) public onlyOwner {
1559     discountRate = _discountRate;
1560   }
1561 
1562   // SET DOGLIEN ID
1563   function setDoglienID(uint256 _ID) public onlyOwner {
1564     doglienID = _ID;
1565   }
1566 
1567   // SET ADDRESS EXTRA_KEYS AMOUNT
1568   function setExtraKeys(address _wallet, uint256 _amount) public onlyOwner {
1569     EXTRA_KEYS[_wallet] += _amount;
1570   }
1571 
1572   // SET MAX MINT PER TX
1573   function setMaxMintPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1574     MaxperTx = _maxMintAmountPerTx;
1575   }
1576 
1577   // SET MAX DOGLIENS PER ADDRESS LIMIT
1578   function setMaxDogliensPerAddressLimit(uint256 _maxDogliensLimit) public onlyOwner {
1579     dogliensPerAddressLimit = _maxDogliensLimit;
1580   }
1581 
1582   // SET MAX HEADACHE PER ADDRESS LIMIT
1583   function setMaxHeadachePerAddLimit(uint256 _maxHeadacheLimit) public onlyOwner {
1584     headachePerAddressLimit = _maxHeadacheLimit;
1585   }
1586 
1587   // SET CLAIM DOGLIEN STATE
1588   function setClaimDoglienState(bool _state) public onlyOwner {
1589     claimDoglienEnabled = _state;
1590   }
1591 
1592   // SET CLAIM HEADACHE STATE
1593   function setClaimHeadacheState(bool _state) public onlyOwner {
1594     mintHeadacheEnabled = _state;
1595   }
1596 
1597   // SET SIGNATURES WALLET
1598   function setSignWallet(address _wallet) public onlyOwner {
1599     wallet = _wallet;
1600   }
1601 
1602   // SET HEADACHE WALLET
1603   function setHaWallet(address _wallet) public onlyOwner {
1604     headache_wallet = _wallet;
1605   }
1606 
1607   // WITHDRAW BALANCE
1608   function withdraw() public onlyOwner nonReentrant {
1609     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1610     require(os);
1611   }
1612 
1613 }