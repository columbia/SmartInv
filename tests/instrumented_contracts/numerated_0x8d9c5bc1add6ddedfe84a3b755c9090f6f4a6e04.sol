1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Transfers `tokenId` token from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
593      * The approval is cleared when the token is transferred.
594      *
595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
596      *
597      * Requirements:
598      *
599      * - The caller must own the token or be an approved operator.
600      * - `tokenId` must exist.
601      *
602      * Emits an {Approval} event.
603      */
604     function approve(address to, uint256 tokenId) external;
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Metadata is IERC721 {
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 }
663 
664 // File: erc721a/contracts/IERC721A.sol
665 
666 
667 // ERC721A Contracts v3.3.0
668 // Creator: Chiru Labs
669 
670 pragma solidity ^0.8.4;
671 
672 
673 
674 /**
675  * @dev Interface of an ERC721A compliant contract.
676  */
677 interface IERC721A is IERC721, IERC721Metadata {
678     /**
679      * The caller must own the token or be an approved operator.
680      */
681     error ApprovalCallerNotOwnerNorApproved();
682 
683     /**
684      * The token does not exist.
685      */
686     error ApprovalQueryForNonexistentToken();
687 
688     /**
689      * The caller cannot approve to their own address.
690      */
691     error ApproveToCaller();
692 
693     /**
694      * The caller cannot approve to the current owner.
695      */
696     error ApprovalToCurrentOwner();
697 
698     /**
699      * Cannot query the balance for the zero address.
700      */
701     error BalanceQueryForZeroAddress();
702 
703     /**
704      * Cannot mint to the zero address.
705      */
706     error MintToZeroAddress();
707 
708     /**
709      * The quantity of tokens minted must be more than zero.
710      */
711     error MintZeroQuantity();
712 
713     /**
714      * The token does not exist.
715      */
716     error OwnerQueryForNonexistentToken();
717 
718     /**
719      * The caller must own the token or be an approved operator.
720      */
721     error TransferCallerNotOwnerNorApproved();
722 
723     /**
724      * The token must be owned by `from`.
725      */
726     error TransferFromIncorrectOwner();
727 
728     /**
729      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
730      */
731     error TransferToNonERC721ReceiverImplementer();
732 
733     /**
734      * Cannot transfer to the zero address.
735      */
736     error TransferToZeroAddress();
737 
738     /**
739      * The token does not exist.
740      */
741     error URIQueryForNonexistentToken();
742 
743     // Compiler will pack this into a single 256bit word.
744     struct TokenOwnership {
745         // The address of the owner.
746         address addr;
747         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
748         uint64 startTimestamp;
749         // Whether the token has been burned.
750         bool burned;
751     }
752 
753     // Compiler will pack this into a single 256bit word.
754     struct AddressData {
755         // Realistically, 2**64-1 is more than enough.
756         uint64 balance;
757         // Keeps track of mint count with minimal overhead for tokenomics.
758         uint64 numberMinted;
759         // Keeps track of burn count with minimal overhead for tokenomics.
760         uint64 numberBurned;
761         // For miscellaneous variable(s) pertaining to the address
762         // (e.g. number of whitelist mint slots used).
763         // If there are multiple variables, please pack them into a uint64.
764         uint64 aux;
765     }
766 
767     /**
768      * @dev Returns the total amount of tokens stored by the contract.
769      * 
770      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
771      */
772     function totalSupply() external view returns (uint256);
773 }
774 
775 // File: erc721a/contracts/ERC721A.sol
776 
777 
778 // ERC721A Contracts v3.3.0
779 // Creator: Chiru Labs
780 
781 pragma solidity ^0.8.4;
782 
783 
784 
785 
786 
787 
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
1315     /**
1316      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1317      *
1318      * @param from address representing the previous owner of the given token ID
1319      * @param to target address that will receive the tokens
1320      * @param tokenId uint256 ID of the token to be transferred
1321      * @param _data bytes optional data to send along with the call
1322      * @return bool whether the call correctly returned the expected magic value
1323      */
1324     function _checkContractOnERC721Received(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) private returns (bool) {
1330         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1331             return retval == IERC721Receiver(to).onERC721Received.selector;
1332         } catch (bytes memory reason) {
1333             if (reason.length == 0) {
1334                 revert TransferToNonERC721ReceiverImplementer();
1335             } else {
1336                 assembly {
1337                     revert(add(32, reason), mload(reason))
1338                 }
1339             }
1340         }
1341     }
1342 
1343     /**
1344      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1345      * And also called before burning one token.
1346      *
1347      * startTokenId - the first token id to be transferred
1348      * quantity - the amount to be transferred
1349      *
1350      * Calling conditions:
1351      *
1352      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1353      * transferred to `to`.
1354      * - When `from` is zero, `tokenId` will be minted for `to`.
1355      * - When `to` is zero, `tokenId` will be burned by `from`.
1356      * - `from` and `to` are never both zero.
1357      */
1358     function _beforeTokenTransfers(
1359         address from,
1360         address to,
1361         uint256 startTokenId,
1362         uint256 quantity
1363     ) internal virtual {}
1364 
1365     /**
1366      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1367      * minting.
1368      * And also called after one token has been burned.
1369      *
1370      * startTokenId - the first token id to be transferred
1371      * quantity - the amount to be transferred
1372      *
1373      * Calling conditions:
1374      *
1375      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1376      * transferred to `to`.
1377      * - When `from` is zero, `tokenId` has been minted for `to`.
1378      * - When `to` is zero, `tokenId` has been burned by `from`.
1379      * - `from` and `to` are never both zero.
1380      */
1381     function _afterTokenTransfers(
1382         address from,
1383         address to,
1384         uint256 startTokenId,
1385         uint256 quantity
1386     ) internal virtual {}
1387 }
1388 
1389 // File: contract.sol
1390 
1391 
1392 pragma solidity ^0.8.4;
1393 
1394 
1395 
1396 contract IMAGINARYBALLS is ERC721A, Ownable {
1397     using Strings for uint256;
1398 
1399     uint256 MAX_MINTS = 3;
1400     uint256 MAX_SUPPLY = 3333;
1401     bool private paused = true;
1402     uint256 MAX_FREE = 1000;
1403     uint256 public mintRate = 0 ether;
1404 
1405     string public baseURI = "https://imaginaryballs.com/api/";
1406 
1407     constructor() ERC721A("IMAGINARY BALLS", "IB") {}
1408 
1409     modifier callerIsuser(){
1410         require(tx.origin ==msg.sender, "Can't be called from contract");
1411         _;
1412     }
1413 
1414     function mint(uint256 quantity) external payable callerIsuser {
1415         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
1416         require(!paused);
1417         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1418         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1419         _safeMint(msg.sender, quantity);
1420     }
1421 
1422     function withdraw() external payable onlyOwner {
1423         payable(owner()).transfer(address(this).balance);
1424     }
1425 
1426     function _baseURI() internal view override returns (string memory) {
1427         return baseURI;
1428     }
1429 
1430     function setMintRate(uint256 _mintRate) public onlyOwner {
1431         mintRate = _mintRate;
1432     }
1433 
1434     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1435         baseURI = _newBaseURI;
1436     }
1437 
1438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1439       require( _exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1440       string memory currentBaseURI = _baseURI();
1441       uint256 trueid = tokenId + 1;
1442       return bytes(currentBaseURI).length > 0
1443           ? string(abi.encodePacked(currentBaseURI, trueid.toString() , ".json"))
1444           : "";
1445   }
1446 
1447   function unpause(bool _state) public onlyOwner {
1448     paused = _state;
1449   }
1450 
1451   function setMaxPerWallet(uint256 newmaxperwallet) public onlyOwner {
1452       MAX_MINTS = newmaxperwallet;
1453   }
1454 
1455   function changesupply(uint256 newsupply_) public onlyOwner{
1456       MAX_SUPPLY = newsupply_;
1457   }
1458 
1459     
1460 }