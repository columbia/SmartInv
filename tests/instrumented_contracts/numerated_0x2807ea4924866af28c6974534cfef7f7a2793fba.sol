1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Strings.sol
47 
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
61      */
62     function toString(uint256 value) internal pure returns (string memory) {
63         // Inspired by OraclizeAPI's implementation - MIT licence
64         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
65 
66         if (value == 0) {
67             return "0";
68         }
69         uint256 temp = value;
70         uint256 digits;
71         while (temp != 0) {
72             digits++;
73             temp /= 10;
74         }
75         bytes memory buffer = new bytes(digits);
76         while (value != 0) {
77             digits -= 1;
78             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
79             value /= 10;
80         }
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
86      */
87     function toHexString(uint256 value) internal pure returns (string memory) {
88         if (value == 0) {
89             return "0x00";
90         }
91         uint256 temp = value;
92         uint256 length = 0;
93         while (temp != 0) {
94             length++;
95             temp >>= 8;
96         }
97         return toHexString(value, length);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
102      */
103     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 /**
152  * @dev Contract module which provides a basic access control mechanism, where
153  * there is an account (an owner) that can be granted exclusive access to
154  * specific functions.
155  *
156  * By default, the owner account will be the one that deploys the contract. This
157  * can later be changed with {transferOwnership}.
158  *
159  * This module is used through inheritance. It will make available the modifier
160  * `onlyOwner`, which can be applied to your functions to restrict their use to
161  * the owner.
162  */
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor() {
172         _transferOwnership(_msgSender());
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner() {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     /**
191      * @dev Leaves the contract without owner. It will not be possible to call
192      * `onlyOwner` functions anymore. Can only be called by the current owner.
193      *
194      * NOTE: Renouncing ownership will leave the contract without an owner,
195      * thereby removing any functionality that is only available to the owner.
196      */
197     function renounceOwnership() public virtual onlyOwner {
198         _transferOwnership(address(0));
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _transferOwnership(newOwner);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Internal function without access restriction.
213      */
214     function _transferOwnership(address newOwner) internal virtual {
215         address oldOwner = _owner;
216         _owner = newOwner;
217         emit OwnershipTransferred(oldOwner, newOwner);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Address.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Collection of functions related to the address type
230  */
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      */
249     function isContract(address account) internal view returns (bool) {
250         // This method relies on extcodesize, which returns 0 for contracts in
251         // construction, since the code is only stored at the end of the
252         // constructor execution.
253 
254         uint256 size;
255         assembly {
256             size := extcodesize(account)
257         }
258         return size > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         require(isContract(target), "Address: call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.call{value: value}(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal view returns (bytes memory) {
379         require(isContract(target), "Address: static call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         require(isContract(target), "Address: delegate call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.delegatecall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
414      * revert reason using the provided one.
415      *
416      * _Available since v4.3._
417      */
418     function verifyCallResult(
419         bool success,
420         bytes memory returndata,
421         string memory errorMessage
422     ) internal pure returns (bytes memory) {
423         if (success) {
424             return returndata;
425         } else {
426             // Look for revert reason and bubble it up if present
427             if (returndata.length > 0) {
428                 // The easiest way to bubble the revert reason is using memory via assembly
429 
430                 assembly {
431                     let returndata_size := mload(returndata)
432                     revert(add(32, returndata), returndata_size)
433                 }
434             } else {
435                 revert(errorMessage);
436             }
437         }
438     }
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @title ERC721 token receiver interface
450  * @dev Interface for any contract that wants to support safeTransfers
451  * from ERC721 asset contracts.
452  */
453 interface IERC721Receiver {
454     /**
455      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
456      * by `operator` from `from`, this function is called.
457      *
458      * It must return its Solidity selector to confirm the token transfer.
459      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
460      *
461      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
462      */
463     function onERC721Received(
464         address operator,
465         address from,
466         uint256 tokenId,
467         bytes calldata data
468     ) external returns (bytes4);
469 }
470 
471 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
472 
473 
474 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev Interface of the ERC165 standard, as defined in the
480  * https://eips.ethereum.org/EIPS/eip-165[EIP].
481  *
482  * Implementers can declare support of contract interfaces, which can then be
483  * queried by others ({ERC165Checker}).
484  *
485  * For an implementation, see {ERC165}.
486  */
487 interface IERC165 {
488     /**
489      * @dev Returns true if this contract implements the interface defined by
490      * `interfaceId`. See the corresponding
491      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
492      * to learn more about how these ids are created.
493      *
494      * This function call must use less than 30 000 gas.
495      */
496     function supportsInterface(bytes4 interfaceId) external view returns (bool);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Implementation of the {IERC165} interface.
509  *
510  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
511  * for the additional interface id that will be supported. For example:
512  *
513  * ```solidity
514  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
516  * }
517  * ```
518  *
519  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
520  */
521 abstract contract ERC165 is IERC165 {
522     /**
523      * @dev See {IERC165-supportsInterface}.
524      */
525     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526         return interfaceId == type(IERC165).interfaceId;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Required interface of an ERC721 compliant contract.
540  */
541 interface IERC721 is IERC165 {
542     /**
543      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
544      */
545     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
546 
547     /**
548      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
549      */
550     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
554      */
555     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
556 
557     /**
558      * @dev Returns the number of tokens in ``owner``'s account.
559      */
560     function balanceOf(address owner) external view returns (uint256 balance);
561 
562     /**
563      * @dev Returns the owner of the `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function ownerOf(uint256 tokenId) external view returns (address owner);
570 
571     /**
572      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
573      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Transfers `tokenId` token from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must be owned by `from`.
601      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) external;
610 
611     /**
612      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
613      * The approval is cleared when the token is transferred.
614      *
615      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
616      *
617      * Requirements:
618      *
619      * - The caller must own the token or be an approved operator.
620      * - `tokenId` must exist.
621      *
622      * Emits an {Approval} event.
623      */
624     function approve(address to, uint256 tokenId) external;
625 
626     /**
627      * @dev Returns the account approved for `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function getApproved(uint256 tokenId) external view returns (address operator);
634 
635     /**
636      * @dev Approve or remove `operator` as an operator for the caller.
637      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
638      *
639      * Requirements:
640      *
641      * - The `operator` cannot be the caller.
642      *
643      * Emits an {ApprovalForAll} event.
644      */
645     function setApprovalForAll(address operator, bool _approved) external;
646 
647     /**
648      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
649      *
650      * See {setApprovalForAll}
651      */
652     function isApprovedForAll(address owner, address operator) external view returns (bool);
653 
654     /**
655      * @dev Safely transfers `tokenId` token from `from` to `to`.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must exist and be owned by `from`.
662      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
663      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
664      *
665      * Emits a {Transfer} event.
666      */
667     function safeTransferFrom(
668         address from,
669         address to,
670         uint256 tokenId,
671         bytes calldata data
672     ) external;
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
685  * @dev See https://eips.ethereum.org/EIPS/eip-721
686  */
687 interface IERC721Metadata is IERC721 {
688     /**
689      * @dev Returns the token collection name.
690      */
691     function name() external view returns (string memory);
692 
693     /**
694      * @dev Returns the token collection symbol.
695      */
696     function symbol() external view returns (string memory);
697 
698     /**
699      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
700      */
701     function tokenURI(uint256 tokenId) external view returns (string memory);
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
705 
706 
707 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 
713 
714 
715 /**
716  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata extension, but not including the Enumerable extension, which is available separately as
718  * {ERC721Enumerable}.
719  */
720 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
721     using Address for address;
722     using Strings for uint256;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to owner address
731     mapping(uint256 => address) private _owners;
732 
733     // Mapping owner address to token count
734     mapping(address => uint256) private _balances;
735 
736     // Mapping from token ID to approved address
737     mapping(uint256 => address) private _tokenApprovals;
738 
739     // Mapping from owner to operator approvals
740     mapping(address => mapping(address => bool)) private _operatorApprovals;
741 
742     /**
743      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
744      */
745     constructor(string memory name_, string memory symbol_) {
746         _name = name_;
747         _symbol = symbol_;
748     }
749 
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
754         return
755             interfaceId == type(IERC721).interfaceId ||
756             interfaceId == type(IERC721Metadata).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev See {IERC721-balanceOf}.
762      */
763     function balanceOf(address owner) public view virtual override returns (uint256) {
764         require(owner != address(0), "ERC721: balance query for the zero address");
765         return _balances[owner];
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
792      * @dev See {IERC721Metadata-tokenURI}.
793      */
794     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
795         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
796 
797         string memory baseURI = _baseURI();
798         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
799     }
800 
801     /**
802      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
803      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
804      * by default, can be overriden in child contracts.
805      */
806     function _baseURI() internal view virtual returns (string memory) {
807         return "";
808     }
809 
810     /**
811      * @dev See {IERC721-approve}.
812      */
813     function approve(address to, uint256 tokenId) public virtual override {
814         address owner = ERC721.ownerOf(tokenId);
815         require(to != owner, "ERC721: approval to current owner");
816 
817         require(
818             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
819             "ERC721: approve caller is not owner nor approved for all"
820         );
821 
822         _approve(to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-getApproved}.
827      */
828     function getApproved(uint256 tokenId) public view virtual override returns (address) {
829         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
830 
831         return _tokenApprovals[tokenId];
832     }
833 
834     /**
835      * @dev See {IERC721-setApprovalForAll}.
836      */
837     function setApprovalForAll(address operator, bool approved) public virtual override {
838         _setApprovalForAll(_msgSender(), operator, approved);
839     }
840 
841     /**
842      * @dev See {IERC721-isApprovedForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
845         return _operatorApprovals[owner][operator];
846     }
847 
848     /**
849      * @dev See {IERC721-transferFrom}.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public virtual override {
856         //solhint-disable-next-line max-line-length
857         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
858 
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, "");
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883         _safeTransfer(from, to, tokenId, _data);
884     }
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
888      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
889      *
890      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
891      *
892      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
893      * implement alternative mechanisms to perform token transfer, such as signature-based.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must exist and be owned by `from`.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeTransfer(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) internal virtual {
910         _transfer(from, to, tokenId);
911         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      * and stop existing when they are burned (`_burn`).
921      */
922     function _exists(uint256 tokenId) internal view virtual returns (bool) {
923         return _owners[tokenId] != address(0);
924     }
925 
926     /**
927      * @dev Returns whether `spender` is allowed to manage `tokenId`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
934         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
935         address owner = ERC721.ownerOf(tokenId);
936         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
937     }
938 
939     /**
940      * @dev Safely mints `tokenId` and transfers it to `to`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must not exist.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeMint(address to, uint256 tokenId) internal virtual {
950         _safeMint(to, tokenId, "");
951     }
952 
953     /**
954      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
956      */
957     function _safeMint(
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) internal virtual {
962         _mint(to, tokenId);
963         require(
964             _checkOnERC721Received(address(0), to, tokenId, _data),
965             "ERC721: transfer to non ERC721Receiver implementer"
966         );
967     }
968 
969     /**
970      * @dev Mints `tokenId` and transfers it to `to`.
971      *
972      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - `to` cannot be the zero address.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _mint(address to, uint256 tokenId) internal virtual {
982         require(to != address(0), "ERC721: mint to the zero address");
983         require(!_exists(tokenId), "ERC721: token already minted");
984 
985         _beforeTokenTransfer(address(0), to, tokenId);
986 
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(address(0), to, tokenId);
991     }
992 
993     /**
994      * @dev Destroys `tokenId`.
995      * The approval is cleared when the token is burned.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _burn(uint256 tokenId) internal virtual {
1004         address owner = ERC721.ownerOf(tokenId);
1005 
1006         _beforeTokenTransfer(owner, address(0), tokenId);
1007 
1008         // Clear approvals
1009         _approve(address(0), tokenId);
1010 
1011         _balances[owner] -= 1;
1012         delete _owners[tokenId];
1013 
1014         emit Transfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {
1033         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1034         require(to != address(0), "ERC721: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(from, to, tokenId);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId);
1040 
1041         _balances[from] -= 1;
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Approve `to` to operate on `tokenId`
1050      *
1051      * Emits a {Approval} event.
1052      */
1053     function _approve(address to, uint256 tokenId) internal virtual {
1054         _tokenApprovals[tokenId] = to;
1055         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Approve `operator` to operate on all of `owner` tokens
1060      *
1061      * Emits a {ApprovalForAll} event.
1062      */
1063     function _setApprovalForAll(
1064         address owner,
1065         address operator,
1066         bool approved
1067     ) internal virtual {
1068         require(owner != operator, "ERC721: approve to caller");
1069         _operatorApprovals[owner][operator] = approved;
1070         emit ApprovalForAll(owner, operator, approved);
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1075      * The call is not executed if the target address is not a contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param _data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) private returns (bool) {
1089         if (to.isContract()) {
1090             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1091                 return retval == IERC721Receiver.onERC721Received.selector;
1092             } catch (bytes memory reason) {
1093                 if (reason.length == 0) {
1094                     revert("ERC721: transfer to non ERC721Receiver implementer");
1095                 } else {
1096                     assembly {
1097                         revert(add(32, reason), mload(reason))
1098                     }
1099                 }
1100             }
1101         } else {
1102             return true;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before any token transfer. This includes minting
1108      * and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1116      * - `from` and `to` are never both zero.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _beforeTokenTransfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {}
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 // CAUTION
1135 // This version of SafeMath should only be used with Solidity 0.8 or later,
1136 // because it relies on the compiler's built in overflow checks.
1137 
1138 /**
1139  * @dev Wrappers over Solidity's arithmetic operations.
1140  *
1141  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1142  * now has built in overflow checking.
1143  */
1144 library SafeMath {
1145     /**
1146      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1147      *
1148      * _Available since v3.4._
1149      */
1150     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1151         unchecked {
1152             uint256 c = a + b;
1153             if (c < a) return (false, 0);
1154             return (true, c);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1160      *
1161      * _Available since v3.4._
1162      */
1163     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1164         unchecked {
1165             if (b > a) return (false, 0);
1166             return (true, a - b);
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1172      *
1173      * _Available since v3.4._
1174      */
1175     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1176         unchecked {
1177             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1178             // benefit is lost if 'b' is also tested.
1179             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1180             if (a == 0) return (true, 0);
1181             uint256 c = a * b;
1182             if (c / a != b) return (false, 0);
1183             return (true, c);
1184         }
1185     }
1186 
1187     /**
1188      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1189      *
1190      * _Available since v3.4._
1191      */
1192     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1193         unchecked {
1194             if (b == 0) return (false, 0);
1195             return (true, a / b);
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1201      *
1202      * _Available since v3.4._
1203      */
1204     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1205         unchecked {
1206             if (b == 0) return (false, 0);
1207             return (true, a % b);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Returns the addition of two unsigned integers, reverting on
1213      * overflow.
1214      *
1215      * Counterpart to Solidity's `+` operator.
1216      *
1217      * Requirements:
1218      *
1219      * - Addition cannot overflow.
1220      */
1221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1222         return a + b;
1223     }
1224 
1225     /**
1226      * @dev Returns the subtraction of two unsigned integers, reverting on
1227      * overflow (when the result is negative).
1228      *
1229      * Counterpart to Solidity's `-` operator.
1230      *
1231      * Requirements:
1232      *
1233      * - Subtraction cannot overflow.
1234      */
1235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1236         return a - b;
1237     }
1238 
1239     /**
1240      * @dev Returns the multiplication of two unsigned integers, reverting on
1241      * overflow.
1242      *
1243      * Counterpart to Solidity's `*` operator.
1244      *
1245      * Requirements:
1246      *
1247      * - Multiplication cannot overflow.
1248      */
1249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1250         return a * b;
1251     }
1252 
1253     /**
1254      * @dev Returns the integer division of two unsigned integers, reverting on
1255      * division by zero. The result is rounded towards zero.
1256      *
1257      * Counterpart to Solidity's `/` operator.
1258      *
1259      * Requirements:
1260      *
1261      * - The divisor cannot be zero.
1262      */
1263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1264         return a / b;
1265     }
1266 
1267     /**
1268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1269      * reverting when dividing by zero.
1270      *
1271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1272      * opcode (which leaves remaining gas untouched) while Solidity uses an
1273      * invalid opcode to revert (consuming all remaining gas).
1274      *
1275      * Requirements:
1276      *
1277      * - The divisor cannot be zero.
1278      */
1279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1280         return a % b;
1281     }
1282 
1283     /**
1284      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1285      * overflow (when the result is negative).
1286      *
1287      * CAUTION: This function is deprecated because it requires allocating memory for the error
1288      * message unnecessarily. For custom revert reasons use {trySub}.
1289      *
1290      * Counterpart to Solidity's `-` operator.
1291      *
1292      * Requirements:
1293      *
1294      * - Subtraction cannot overflow.
1295      */
1296     function sub(
1297         uint256 a,
1298         uint256 b,
1299         string memory errorMessage
1300     ) internal pure returns (uint256) {
1301         unchecked {
1302             require(b <= a, errorMessage);
1303             return a - b;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1309      * division by zero. The result is rounded towards zero.
1310      *
1311      * Counterpart to Solidity's `/` operator. Note: this function uses a
1312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1313      * uses an invalid opcode to revert (consuming all remaining gas).
1314      *
1315      * Requirements:
1316      *
1317      * - The divisor cannot be zero.
1318      */
1319     function div(
1320         uint256 a,
1321         uint256 b,
1322         string memory errorMessage
1323     ) internal pure returns (uint256) {
1324         unchecked {
1325             require(b > 0, errorMessage);
1326             return a / b;
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1332      * reverting with custom message when dividing by zero.
1333      *
1334      * CAUTION: This function is deprecated because it requires allocating memory for the error
1335      * message unnecessarily. For custom revert reasons use {tryMod}.
1336      *
1337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1338      * opcode (which leaves remaining gas untouched) while Solidity uses an
1339      * invalid opcode to revert (consuming all remaining gas).
1340      *
1341      * Requirements:
1342      *
1343      * - The divisor cannot be zero.
1344      */
1345     function mod(
1346         uint256 a,
1347         uint256 b,
1348         string memory errorMessage
1349     ) internal pure returns (uint256) {
1350         unchecked {
1351             require(b > 0, errorMessage);
1352             return a % b;
1353         }
1354     }
1355 }
1356 
1357 // File: contracts/xenesis.sol
1358 
1359 
1360 pragma solidity >=0.7.0 <0.9.0;
1361 
1362 
1363 contract MoonRabbits is ERC721, Ownable {
1364   using Strings for uint256;
1365   using Counters for Counters.Counter;
1366   using SafeMath for uint256;
1367 
1368   mapping (address => bool) public whitelistForRabbits;
1369   mapping (address => bool) public mintedForRabbits;
1370 
1371   Counters.Counter private supply;
1372 
1373   string public uriPrefix = "";
1374   string public uriSuffix = ".json";
1375   
1376   uint256 public costForRabbits = 0.0369 ether;
1377   uint256 public maxSupply = 10000;
1378   uint256 public maxMintAmountPerTx = 1;
1379   uint256 public mintCountForRabbits = 0;
1380   uint256 public maxMintCountForRabbits = 10000;
1381 
1382   bool public paused = true;
1383   bool public pausedForRabbits = true;
1384 
1385   address public managerAccount;
1386 
1387   constructor() ERC721("Moon Rabbits", "MRB") {
1388     setUriPrefix("ipfs://QmcdDgNNp612eCuhkf5nazVNWK3m8fSs1RsriKya8RZCSB/");
1389     managerAccount = 0x7f32647F85801a95886Aa722DA408CF28f01671E;
1390   }
1391 
1392   modifier mintCompliance(uint256 _mintAmount) {
1393     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "You sure that is the right size for you?");
1394     require(supply.current() + _mintAmount <= maxSupply, "Out of your condoms");
1395     _;
1396   }
1397 
1398   function totalSupply() public view returns (uint256) {
1399     return supply.current();
1400   }
1401 
1402   function mintForRabbits(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1403     require(!paused, "Sex y playlist has been paused!");
1404     require(!pausedForRabbits, "Let your Rabbit take a quick break!");
1405     require(msg.value >= costForRabbits * _mintAmount, "You need more $ Bills!");
1406     require(!mintedForRabbits[msg.sender], "Seed has already been spread!");
1407 
1408     //_mintLoop(msg.sender, _mintAmount);
1409     for (uint256 i = 0; i < _mintAmount; i++) {
1410         require(mintCountForRabbits < maxMintCountForRabbits);
1411         supply.increment();
1412         _safeMint(msg.sender, mintCountForRabbits);
1413         mintCountForRabbits = mintCountForRabbits + 1;
1414     }
1415     mintedForRabbits[msg.sender] = true;
1416   }
1417 
1418 //   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1419 //     _mintLoop(_receiver, _mintAmount);
1420 //   }
1421 
1422   function walletOfOwner(address _owner)
1423     public
1424     view
1425     returns (uint256[] memory)
1426   {
1427     uint256 ownerTokenCount = balanceOf(_owner);
1428     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1429     uint256 currentTokenId = 1;
1430     uint256 ownedTokenIndex = 0;
1431 
1432     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1433       address currentTokenOwner = ownerOf(currentTokenId);
1434 
1435       if (currentTokenOwner == _owner) {
1436         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1437 
1438         ownedTokenIndex++;
1439       }
1440 
1441       currentTokenId++;
1442     }
1443 
1444     return ownedTokenIds;
1445   }
1446 
1447   function tokenURI(uint256 _tokenId)
1448     public
1449     view
1450     virtual
1451     override
1452     returns (string memory)
1453   {
1454     require(
1455       _exists(_tokenId),
1456       "ERC721Metadata: URI query for nonexistent token"
1457     );
1458     
1459     string memory currentBaseURI = _baseURI();
1460     return bytes(currentBaseURI).length > 0
1461         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1462         : "";
1463   }
1464 
1465   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1466     maxMintAmountPerTx = _maxMintAmountPerTx;
1467   }
1468 
1469   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1470     uriPrefix = _uriPrefix;
1471   }
1472 
1473   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1474     uriSuffix = _uriSuffix;
1475   }
1476 
1477   function setPaused(bool _state) public onlyOwner {
1478     paused = _state;
1479   }
1480 
1481   function setPausedForRabbits(bool _state) public onlyOwner {
1482     pausedForRabbits = _state;
1483   }
1484 
1485   function withdraw() public onlyOwner {
1486     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1487     require(os);
1488   }
1489 
1490   function _baseURI() internal view virtual override returns (string memory) {
1491     return uriPrefix;
1492   }
1493 
1494   function setWhitelistForRabbitsForLoop(address[] calldata _whitelistMembers) public {
1495       require(msg.sender == managerAccount, "Only manager can set whitelist");
1496       for (uint256 i = 0; i < _whitelistMembers.length; i++) {
1497         whitelistForRabbits[_whitelistMembers[i]] = true;
1498       }
1499   }
1500 
1501   function setWhitelistForRabbits(address _whitelistMember, bool _enable) public {
1502       require(msg.sender == managerAccount, "Only manager can set whitelist");
1503       whitelistForRabbits[_whitelistMember] = _enable;
1504   }
1505 
1506   function getMintCountForRabbits() public view returns (uint256) {
1507     return mintCountForRabbits;
1508   }
1509 
1510   function getWhitelistedForRabbits(address _checkAddress) public view returns (bool) {
1511     return whitelistForRabbits[_checkAddress];
1512   }
1513 
1514   function getMintedForRabbits(address _checkAddress) public view returns (bool) {
1515     return mintedForRabbits[_checkAddress];
1516   }
1517 }