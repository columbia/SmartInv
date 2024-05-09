1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 library Counters {
10     struct Counter {
11         // This variable should never be directly accessed by users of the library: interactions must be restricted to
12         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
13         // this feature: see https://github.com/ethereum/solidity/issues/4637
14         uint256 _value; // default: 0
15     }
16 
17     function current(Counter storage counter) internal view returns (uint256) {
18         return counter._value;
19     }
20 
21     function increment(Counter storage counter) internal {
22         unchecked {
23             counter._value += 1;
24         }
25     }
26 
27     function decrement(Counter storage counter) internal {
28         uint256 value = counter._value;
29         require(value > 0, "Counter: decrement overflow");
30         unchecked {
31             counter._value = value - 1;
32         }
33     }
34 
35     function reset(Counter storage counter) internal {
36         counter._value = 0;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/utils/Strings.sol
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev String operations.
49  */
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/access/Ownable.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 
145 /**
146  * @dev Contract module which provides a basic access control mechanism, where
147  * there is an account (an owner) that can be granted exclusive access to
148  * specific functions.
149  *
150  * By default, the owner account will be the one that deploys the contract. This
151  * can later be changed with {transferOwnership}.
152  *
153  * This module is used through inheritance. It will make available the modifier
154  * `onlyOwner`, which can be applied to your functions to restrict their use to
155  * the owner.
156  */
157 abstract contract Ownable is Context {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     /**
163      * @dev Initializes the contract setting the deployer as the initial owner.
164      */
165     constructor() {
166         _transferOwnership(_msgSender());
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view virtual returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(owner() == _msgSender(), "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Address.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
219 
220 pragma solidity ^0.8.1;
221 
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      *
243      * [IMPORTANT]
244      * ====
245      * You shouldn't rely on `isContract` to protect against flash loan attacks!
246      *
247      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
248      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
249      * constructor.
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize/address.code.length, which returns 0
254         // for contracts in construction, since the code is only stored at the end
255         // of the constructor execution.
256 
257         return account.code.length > 0;
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         (bool success, ) = recipient.call{value: amount}("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.staticcall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
441 
442 
443 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @title ERC721 token receiver interface
449  * @dev Interface for any contract that wants to support safeTransfers
450  * from ERC721 asset contracts.
451  */
452 interface IERC721Receiver {
453     /**
454      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
455      * by `operator` from `from`, this function is called.
456      *
457      * It must return its Solidity selector to confirm the token transfer.
458      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
459      *
460      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
461      */
462     function onERC721Received(
463         address operator,
464         address from,
465         uint256 tokenId,
466         bytes calldata data
467     ) external returns (bytes4);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Interface of the ERC165 standard, as defined in the
479  * https://eips.ethereum.org/EIPS/eip-165[EIP].
480  *
481  * Implementers can declare support of contract interfaces, which can then be
482  * queried by others ({ERC165Checker}).
483  *
484  * For an implementation, see {ERC165}.
485  */
486 interface IERC165 {
487     /**
488      * @dev Returns true if this contract implements the interface defined by
489      * `interfaceId`. See the corresponding
490      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
491      * to learn more about how these ids are created.
492      *
493      * This function call must use less than 30 000 gas.
494      */
495     function supportsInterface(bytes4 interfaceId) external view returns (bool);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Implementation of the {IERC165} interface.
508  *
509  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
510  * for the additional interface id that will be supported. For example:
511  *
512  * ```solidity
513  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
515  * }
516  * ```
517  *
518  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
519  */
520 abstract contract ERC165 is IERC165 {
521     /**
522      * @dev See {IERC165-supportsInterface}.
523      */
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return interfaceId == type(IERC165).interfaceId;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Required interface of an ERC721 compliant contract.
539  */
540 interface IERC721 is IERC165 {
541     /**
542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
543      */
544     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
545 
546     /**
547      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
548      */
549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
553      */
554     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
555 
556     /**
557      * @dev Returns the number of tokens in ``owner``'s account.
558      */
559     function balanceOf(address owner) external view returns (uint256 balance);
560 
561     /**
562      * @dev Returns the owner of the `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function ownerOf(uint256 tokenId) external view returns (address owner);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId,
587         bytes calldata data
588     ) external;
589 
590     /**
591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must exist and be owned by `from`.
599      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Transfers `tokenId` token from `from` to `to`.
612      *
613      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
632      * The approval is cleared when the token is transferred.
633      *
634      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
635      *
636      * Requirements:
637      *
638      * - The caller must own the token or be an approved operator.
639      * - `tokenId` must exist.
640      *
641      * Emits an {Approval} event.
642      */
643     function approve(address to, uint256 tokenId) external;
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
648      *
649      * Requirements:
650      *
651      * - The `operator` cannot be the caller.
652      *
653      * Emits an {ApprovalForAll} event.
654      */
655     function setApprovalForAll(address operator, bool _approved) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
668      *
669      * See {setApprovalForAll}
670      */
671     function isApprovedForAll(address owner, address operator) external view returns (bool);
672 }
673 
674 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 
682 /**
683  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
684  * @dev See https://eips.ethereum.org/EIPS/eip-721
685  */
686 interface IERC721Metadata is IERC721 {
687     /**
688      * @dev Returns the token collection name.
689      */
690     function name() external view returns (string memory);
691 
692     /**
693      * @dev Returns the token collection symbol.
694      */
695     function symbol() external view returns (string memory);
696 
697     /**
698      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
699      */
700     function tokenURI(uint256 tokenId) external view returns (string memory);
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
704 
705 
706 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 
712 
713 
714 
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata extension, but not including the Enumerable extension, which is available separately as
720  * {ERC721Enumerable}.
721  */
722 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
723     using Address for address;
724     using Strings for uint256;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to owner address
733     mapping(uint256 => address) private _owners;
734 
735     // Mapping owner address to token count
736     mapping(address => uint256) private _balances;
737 
738     // Mapping from token ID to approved address
739     mapping(uint256 => address) private _tokenApprovals;
740 
741     // Mapping from owner to operator approvals
742     mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744     /**
745      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
746      */
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
756         return
757             interfaceId == type(IERC721).interfaceId ||
758             interfaceId == type(IERC721Metadata).interfaceId ||
759             super.supportsInterface(interfaceId);
760     }
761 
762     /**
763      * @dev See {IERC721-balanceOf}.
764      */
765     function balanceOf(address owner) public view virtual override returns (uint256) {
766         require(owner != address(0), "ERC721: balance query for the zero address");
767         return _balances[owner];
768     }
769 
770     /**
771      * @dev See {IERC721-ownerOf}.
772      */
773     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
774         address owner = _owners[tokenId];
775         require(owner != address(0), "ERC721: owner query for nonexistent token");
776         return owner;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-name}.
781      */
782     function name() public view virtual override returns (string memory) {
783         return _name;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-symbol}.
788      */
789     function symbol() public view virtual override returns (string memory) {
790         return _symbol;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-tokenURI}.
795      */
796     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
797         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
798 
799         string memory baseURI = _baseURI();
800         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
801     }
802 
803     /**
804      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806      * by default, can be overridden in child contracts.
807      */
808     function _baseURI() internal view virtual returns (string memory) {
809         return "";
810     }
811 
812     /**
813      * @dev See {IERC721-approve}.
814      */
815     function approve(address to, uint256 tokenId) public virtual override {
816         address owner = ERC721.ownerOf(tokenId);
817         require(to != owner, "ERC721: approval to current owner");
818 
819         require(
820             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
821             "ERC721: approve caller is not owner nor approved for all"
822         );
823 
824         _approve(to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-getApproved}.
829      */
830     function getApproved(uint256 tokenId) public view virtual override returns (address) {
831         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
832 
833         return _tokenApprovals[tokenId];
834     }
835 
836     /**
837      * @dev See {IERC721-setApprovalForAll}.
838      */
839     function setApprovalForAll(address operator, bool approved) public virtual override {
840         _setApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         //solhint-disable-next-line max-line-length
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860 
861         _transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) public virtual override {
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885         _safeTransfer(from, to, tokenId, _data);
886     }
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
890      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
891      *
892      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
893      *
894      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
895      * implement alternative mechanisms to perform token transfer, such as signature-based.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeTransfer(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _transfer(from, to, tokenId);
913         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      * and stop existing when they are burned (`_burn`).
923      */
924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
925         return _owners[tokenId] != address(0);
926     }
927 
928     /**
929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
936         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
937         address owner = ERC721.ownerOf(tokenId);
938         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
939     }
940 
941     /**
942      * @dev Safely mints `tokenId` and transfers it to `to`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(address to, uint256 tokenId) internal virtual {
952         _safeMint(to, tokenId, "");
953     }
954 
955     /**
956      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
957      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
958      */
959     function _safeMint(
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _mint(to, tokenId);
965         require(
966             _checkOnERC721Received(address(0), to, tokenId, _data),
967             "ERC721: transfer to non ERC721Receiver implementer"
968         );
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993 
994         _afterTokenTransfer(address(0), to, tokenId);
995     }
996 
997     /**
998      * @dev Destroys `tokenId`.
999      * The approval is cleared when the token is burned.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _burn(uint256 tokenId) internal virtual {
1008         address owner = ERC721.ownerOf(tokenId);
1009 
1010         _beforeTokenTransfer(owner, address(0), tokenId);
1011 
1012         // Clear approvals
1013         _approve(address(0), tokenId);
1014 
1015         _balances[owner] -= 1;
1016         delete _owners[tokenId];
1017 
1018         emit Transfer(owner, address(0), tokenId);
1019 
1020         _afterTokenTransfer(owner, address(0), tokenId);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {
1039         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1040         require(to != address(0), "ERC721: transfer to the zero address");
1041 
1042         _beforeTokenTransfer(from, to, tokenId);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId);
1046 
1047         _balances[from] -= 1;
1048         _balances[to] += 1;
1049         _owners[tokenId] = to;
1050 
1051         emit Transfer(from, to, tokenId);
1052 
1053         _afterTokenTransfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `operator` to operate on all of `owner` tokens
1068      *
1069      * Emits a {ApprovalForAll} event.
1070      */
1071     function _setApprovalForAll(
1072         address owner,
1073         address operator,
1074         bool approved
1075     ) internal virtual {
1076         require(owner != operator, "ERC721: approve to caller");
1077         _operatorApprovals[owner][operator] = approved;
1078         emit ApprovalForAll(owner, operator, approved);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver.onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert("ERC721: transfer to non ERC721Receiver implementer");
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Hook that is called after any transfer of tokens. This includes
1136      * minting and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - when `from` and `to` are both non-zero.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _afterTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 }
1151 
1152 // File: contracts/mecha-boki.sol
1153 
1154 
1155 
1156 
1157 
1158 pragma solidity >=0.7.0 <0.9.0;
1159 
1160 
1161 
1162 
1163 contract MechaBoki is ERC721, Ownable {
1164   using Strings for uint256;
1165   using Counters for Counters.Counter;
1166 
1167   Counters.Counter private supply;
1168 
1169   string public uriPrefix = "";
1170   string public uriSuffix = ".json";
1171   string public hiddenMetadataUri;
1172   
1173   uint256 public cost = 0 ether;
1174   uint256 public maxSupply = 6969;
1175   uint256 public maxMintAmountPerTx = 1;
1176 
1177   bool public paused = true;
1178   bool public revealed = false;
1179 
1180   constructor() ERC721("MechaBoki", "MBOKI") {
1181     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1182   }
1183 
1184   modifier mintCompliance(uint256 _mintAmount) {
1185     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1186     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1187     _;
1188   }
1189 
1190   function totalSupply() public view returns (uint256) {
1191     return supply.current();
1192   }
1193 
1194   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1195     require(!paused, "The contract is paused!");
1196     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1197 
1198     _mintLoop(msg.sender, _mintAmount);
1199   }
1200   
1201   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1202     _mintLoop(_receiver, _mintAmount);
1203   }
1204 
1205   function walletOfOwner(address _owner)
1206     public
1207     view
1208     returns (uint256[] memory)
1209   {
1210     uint256 ownerTokenCount = balanceOf(_owner);
1211     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1212     uint256 currentTokenId = 1;
1213     uint256 ownedTokenIndex = 0;
1214 
1215     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1216       address currentTokenOwner = ownerOf(currentTokenId);
1217 
1218       if (currentTokenOwner == _owner) {
1219         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1220 
1221         ownedTokenIndex++;
1222       }
1223 
1224       currentTokenId++;
1225     }
1226 
1227     return ownedTokenIds;
1228   }
1229 
1230   function tokenURI(uint256 _tokenId)
1231     public
1232     view
1233     virtual
1234     override
1235     returns (string memory)
1236   {
1237     require(
1238       _exists(_tokenId),
1239       "ERC721Metadata: URI query for nonexistent token"
1240     );
1241 
1242     if (revealed == false) {
1243       return hiddenMetadataUri;
1244     }
1245 
1246     string memory currentBaseURI = _baseURI();
1247     return bytes(currentBaseURI).length > 0
1248         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1249         : "";
1250   }
1251 
1252   function setRevealed(bool _state) public onlyOwner {
1253     revealed = _state;
1254   }
1255 
1256   function setCost(uint256 _cost) public onlyOwner {
1257     cost = _cost;
1258   }
1259 
1260   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1261     maxMintAmountPerTx = _maxMintAmountPerTx;
1262   }
1263 
1264   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1265     hiddenMetadataUri = _hiddenMetadataUri;
1266   }
1267 
1268   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1269     uriPrefix = _uriPrefix;
1270   }
1271 
1272   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1273     uriSuffix = _uriSuffix;
1274   }
1275 
1276   function setPaused(bool _state) public onlyOwner {
1277     paused = _state;
1278   }
1279 
1280   function withdraw() public onlyOwner {
1281     // This will transfer the remaining contract balance to the owner.
1282     // Do not remove this otherwise you will not be able to withdraw the funds.
1283     // =============================================================================
1284     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1285     require(os);
1286     // =============================================================================
1287   }
1288 
1289   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1290     for (uint256 i = 0; i < _mintAmount; i++) {
1291       supply.increment();
1292       _safeMint(_receiver, supply.current());
1293     }
1294   }
1295 
1296   function _baseURI() internal view virtual override returns (string memory) {
1297     return uriPrefix;
1298   }
1299 }