1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @title Counters
8  * @author Matt Condon (@shrugs)
9  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
10  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
11  *
12  * Include with `using Counters for Counters.Counter;`
13  */
14 library Counters {
15     struct Counter {
16         // This variable should never be directly accessed by users of the library: interactions must be restricted to
17         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
18         // this feature: see https://github.com/ethereum/solidity/issues/4637
19         uint256 _value; // default: 0
20     }
21 
22     function current(Counter storage counter) internal view returns (uint256) {
23         return counter._value;
24     }
25 
26     function increment(Counter storage counter) internal {
27         unchecked {
28             counter._value += 1;
29         }
30     }
31 
32     function decrement(Counter storage counter) internal {
33         uint256 value = counter._value;
34         require(value > 0, "Counter: decrement overflow");
35         unchecked {
36             counter._value = value - 1;
37         }
38     }
39 
40     function reset(Counter storage counter) internal {
41         counter._value = 0;
42     }
43 }
44 
45 // File: @openzeppelin/contracts/utils/Strings.sol
46 
47 
48 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/access/Ownable.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 /**
151  * @dev Contract module which provides a basic access control mechanism, where
152  * there is an account (an owner) that can be granted exclusive access to
153  * specific functions.
154  *
155  * By default, the owner account will be the one that deploys the contract. This
156  * can later be changed with {transferOwnership}.
157  *
158  * This module is used through inheritance. It will make available the modifier
159  * `onlyOwner`, which can be applied to your functions to restrict their use to
160  * the owner.
161  */
162 abstract contract Ownable is Context {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     /**
168      * @dev Initializes the contract setting the deployer as the initial owner.
169      */
170     constructor() {
171         _transferOwnership(_msgSender());
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view virtual returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(owner() == _msgSender(), "Ownable: caller is not the owner");
186         _;
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _transferOwnership(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Address.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies on extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         assembly {
255             size := extcodesize(account)
256         }
257         return size > 0;
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
443 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
460      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
532 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
571      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
572      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must exist and be owned by `from`.
579      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
581      *
582      * Emits a {Transfer} event.
583      */
584     function safeTransferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Transfers `tokenId` token from `from` to `to`.
592      *
593      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
612      * The approval is cleared when the token is transferred.
613      *
614      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
615      *
616      * Requirements:
617      *
618      * - The caller must own the token or be an approved operator.
619      * - `tokenId` must exist.
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address to, uint256 tokenId) external;
624 
625     /**
626      * @dev Returns the account approved for `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function getApproved(uint256 tokenId) external view returns (address operator);
633 
634     /**
635      * @dev Approve or remove `operator` as an operator for the caller.
636      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
637      *
638      * Requirements:
639      *
640      * - The `operator` cannot be the caller.
641      *
642      * Emits an {ApprovalForAll} event.
643      */
644     function setApprovalForAll(address operator, bool _approved) external;
645 
646     /**
647      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
648      *
649      * See {setApprovalForAll}
650      */
651     function isApprovedForAll(address owner, address operator) external view returns (bool);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes calldata data
671     ) external;
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
706 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
806      * by default, can be overriden in child contracts.
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
938         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
993     }
994 
995     /**
996      * @dev Destroys `tokenId`.
997      * The approval is cleared when the token is burned.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _burn(uint256 tokenId) internal virtual {
1006         address owner = ERC721.ownerOf(tokenId);
1007 
1008         _beforeTokenTransfer(owner, address(0), tokenId);
1009 
1010         // Clear approvals
1011         _approve(address(0), tokenId);
1012 
1013         _balances[owner] -= 1;
1014         delete _owners[tokenId];
1015 
1016         emit Transfer(owner, address(0), tokenId);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {
1035         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1036         require(to != address(0), "ERC721: transfer to the zero address");
1037 
1038         _beforeTokenTransfer(from, to, tokenId);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId);
1042 
1043         _balances[from] -= 1;
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Approve `operator` to operate on all of `owner` tokens
1062      *
1063      * Emits a {ApprovalForAll} event.
1064      */
1065     function _setApprovalForAll(
1066         address owner,
1067         address operator,
1068         bool approved
1069     ) internal virtual {
1070         require(owner != operator, "ERC721: approve to caller");
1071         _operatorApprovals[owner][operator] = approved;
1072         emit ApprovalForAll(owner, operator, approved);
1073     }
1074 
1075     /**
1076      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1077      * The call is not executed if the target address is not a contract.
1078      *
1079      * @param from address representing the previous owner of the given token ID
1080      * @param to target address that will receive the tokens
1081      * @param tokenId uint256 ID of the token to be transferred
1082      * @param _data bytes optional data to send along with the call
1083      * @return bool whether the call correctly returned the expected magic value
1084      */
1085     function _checkOnERC721Received(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) private returns (bool) {
1091         if (to.isContract()) {
1092             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1093                 return retval == IERC721Receiver.onERC721Received.selector;
1094             } catch (bytes memory reason) {
1095                 if (reason.length == 0) {
1096                     revert("ERC721: transfer to non ERC721Receiver implementer");
1097                 } else {
1098                     assembly {
1099                         revert(add(32, reason), mload(reason))
1100                     }
1101                 }
1102             }
1103         } else {
1104             return true;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before any token transfer. This includes minting
1110      * and burning.
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1118      * - `from` and `to` are never both zero.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {}
1127 }
1128 
1129 // File: contracts/dynamic.sol
1130 
1131 
1132 
1133 
1134 pragma solidity >=0.7.0 <0.9.0;
1135 
1136 contract genesizShapez is ERC721, Ownable {
1137   using Strings for uint256;
1138   using Counters for Counters.Counter;
1139 
1140   Counters.Counter private supply;
1141 
1142   string public uriPrefix = "";
1143   string public uriSuffix = ".json";
1144   string public hiddenMetadataUri;
1145   
1146   uint256 public cost = 0.0555 ether;
1147   uint256 public maxSupply = 3500;
1148   uint256 public maxMintAmountPerTx = 20;
1149 
1150   bool public paused = false;
1151   bool public revealed = true;
1152 
1153   address public rooAddress;
1154   uint256 public roosMinted;
1155   uint256 public maxRooMints;
1156 
1157   constructor() ERC721("Genesiz Shapez", "SHAPEZ") {
1158     setHiddenMetadataUri("https://evolutionz.art/nft/hidden.json");
1159     setUriPrefix("https://evolutionz.art/nft/");
1160 
1161     // set the contract address to RooTroop Contract
1162     setRooAddress(0x928f072C009727FbAd81bBF3aAa885f9fEa65fcf);
1163     //set amount of max roo mints
1164     setMaxRooMints(100);
1165   }
1166 
1167   modifier mintCompliance(uint256 _mintAmount) {
1168     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1169     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1170     _;
1171   }
1172 
1173   function totalSupply() public view returns (uint256) {
1174     return supply.current();
1175   }
1176 
1177 
1178   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1179     require(!paused, "The contract is paused!");
1180 
1181     // declare new custom token from address
1182     IERC721 rooToken = IERC721(rooAddress);
1183     // save roo tokens owned as variable
1184     uint256 rooAmountOwned = rooToken.balanceOf(msg.sender);
1185 
1186     // if roo holder, owns 0 Shapez and not fully free minted
1187     if (rooAmountOwned >= 1 && balanceOf(msg.sender) < 1 && roosMinted < maxRooMints) {
1188         require(msg.value >= cost * (_mintAmount - 1), "Insufficient funds!");
1189         roosMinted++;
1190     }   else {
1191         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1192     } 
1193     
1194     _mintLoop(msg.sender, _mintAmount);
1195   }
1196 
1197   
1198   
1199   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1200     _mintLoop(_receiver, _mintAmount);
1201   }
1202 
1203   function walletOfOwner(address _owner)
1204     public
1205     view
1206     returns (uint256[] memory)
1207   {
1208     uint256 ownerTokenCount = balanceOf(_owner);
1209     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1210     uint256 currentTokenId = 1;
1211     uint256 ownedTokenIndex = 0;
1212 
1213     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1214       address currentTokenOwner = ownerOf(currentTokenId);
1215 
1216       if (currentTokenOwner == _owner) {
1217         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1218 
1219         ownedTokenIndex++;
1220       }
1221 
1222       currentTokenId++;
1223     }
1224 
1225     return ownedTokenIds;
1226   }
1227 
1228 
1229   function tokenURI(uint256 _tokenId)
1230     public
1231     view
1232     virtual
1233     override
1234     returns (string memory)
1235   {
1236     require(
1237       _exists(_tokenId),
1238       "ERC721Metadata: URI query for nonexistent token"
1239     );
1240 
1241     if (revealed == false) {
1242       return hiddenMetadataUri;
1243     }
1244 
1245     string memory currentBaseURI = _baseURI();
1246     return bytes(currentBaseURI).length > 0
1247         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1248         : "";
1249   }
1250 
1251   function setRevealed(bool _state) public onlyOwner {
1252     revealed = _state;
1253   }
1254 
1255   function setCost(uint256 _cost) public onlyOwner {
1256     cost = _cost;
1257   }
1258 
1259   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1260     maxMintAmountPerTx = _maxMintAmountPerTx;
1261   }
1262 
1263   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1264     hiddenMetadataUri = _hiddenMetadataUri;
1265   }
1266 
1267   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1268     uriPrefix = _uriPrefix;
1269   }
1270 
1271   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1272     uriSuffix = _uriSuffix;
1273   }
1274 
1275   function setPaused(bool _state) public onlyOwner {
1276     paused = _state;
1277   }
1278 
1279   function withdraw(uint256 _amount) public onlyOwner {
1280 
1281     (bool os, ) = payable(owner()).call{value: _amount }("");
1282     require(os);
1283 
1284   }
1285 
1286   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1287     for (uint256 i = 0; i < _mintAmount; i++) {
1288       supply.increment();
1289       _safeMint(_receiver, supply.current());
1290     }
1291   }
1292 
1293   function _baseURI() internal view virtual override returns (string memory) {
1294     return uriPrefix;
1295   }
1296 
1297 
1298     // sets the contract address to Roo Troop
1299   function setRooAddress(address _newAddress) public onlyOwner{
1300     rooAddress = _newAddress;
1301   }
1302 
1303     //sets max amount of roos that can be minted
1304   function setMaxRooMints(uint256 _newAmount) public onlyOwner{
1305     maxRooMints = _newAmount;
1306   }
1307 }