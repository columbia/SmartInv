1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-14
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Counters.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 
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
715 
716 
717 
718 /**
719  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
720  * the Metadata extension, but not including the Enumerable extension, which is available separately as
721  * {ERC721Enumerable}.
722  */
723 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     using Strings for uint256;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to owner address
734     mapping(uint256 => address) private _owners;
735 
736     // Mapping owner address to token count
737     mapping(address => uint256) private _balances;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     /**
746      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
747      */
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
757         return
758             interfaceId == type(IERC721).interfaceId ||
759             interfaceId == type(IERC721Metadata).interfaceId ||
760             super.supportsInterface(interfaceId);
761     }
762 
763     /**
764      * @dev See {IERC721-balanceOf}.
765      */
766     function balanceOf(address owner) public view virtual override returns (uint256) {
767         require(owner != address(0), "ERC721: balance query for the zero address");
768         return _balances[owner];
769     }
770 
771     /**
772      * @dev See {IERC721-ownerOf}.
773      */
774     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
775         address owner = _owners[tokenId];
776         require(owner != address(0), "ERC721: owner query for nonexistent token");
777         return owner;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
798         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
799 
800         string memory baseURI = _baseURI();
801         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return "";
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public virtual override {
817         address owner = ERC721.ownerOf(tokenId);
818         require(to != owner, "ERC721: approval to current owner");
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             "ERC721: approve caller is not owner nor approved for all"
823         );
824 
825         _approve(to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId) public view virtual override returns (address) {
832         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
833 
834         return _tokenApprovals[tokenId];
835     }
836 
837     /**
838      * @dev See {IERC721-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         _setApprovalForAll(_msgSender(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC721-isApprovedForAll}.
846      */
847     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[owner][operator];
849     }
850 
851     /**
852      * @dev See {IERC721-transferFrom}.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         //solhint-disable-next-line max-line-length
860         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
861 
862         _transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         safeTransferFrom(from, to, tokenId, "");
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) public virtual override {
885         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
886         _safeTransfer(from, to, tokenId, _data);
887     }
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
892      *
893      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
894      *
895      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
896      * implement alternative mechanisms to perform token transfer, such as signature-based.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must exist and be owned by `from`.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeTransfer(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _transfer(from, to, tokenId);
914         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
915     }
916 
917     /**
918      * @dev Returns whether `tokenId` exists.
919      *
920      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
921      *
922      * Tokens start existing when they are minted (`_mint`),
923      * and stop existing when they are burned (`_burn`).
924      */
925     function _exists(uint256 tokenId) internal view virtual returns (bool) {
926         return _owners[tokenId] != address(0);
927     }
928 
929     /**
930      * @dev Returns whether `spender` is allowed to manage `tokenId`.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      */
936     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
937         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
938         address owner = ERC721.ownerOf(tokenId);
939         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
940     }
941 
942     /**
943      * @dev Safely mints `tokenId` and transfers it to `to`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(address to, uint256 tokenId) internal virtual {
953         _safeMint(to, tokenId, "");
954     }
955 
956     /**
957      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
958      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
959      */
960     function _safeMint(
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) internal virtual {
965         _mint(to, tokenId);
966         require(
967             _checkOnERC721Received(address(0), to, tokenId, _data),
968             "ERC721: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Mints `tokenId` and transfers it to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - `to` cannot be the zero address.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(address to, uint256 tokenId) internal virtual {
985         require(to != address(0), "ERC721: mint to the zero address");
986         require(!_exists(tokenId), "ERC721: token already minted");
987 
988         _beforeTokenTransfer(address(0), to, tokenId);
989 
990         _balances[to] += 1;
991         _owners[tokenId] = to;
992 
993         emit Transfer(address(0), to, tokenId);
994     }
995 
996     /**
997      * @dev Destroys `tokenId`.
998      * The approval is cleared when the token is burned.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _burn(uint256 tokenId) internal virtual {
1007         address owner = ERC721.ownerOf(tokenId);
1008 
1009         _beforeTokenTransfer(owner, address(0), tokenId);
1010 
1011         // Clear approvals
1012         _approve(address(0), tokenId);
1013 
1014         _balances[owner] -= 1;
1015         delete _owners[tokenId];
1016 
1017         emit Transfer(owner, address(0), tokenId);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {
1036         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1037         require(to != address(0), "ERC721: transfer to the zero address");
1038 
1039         _beforeTokenTransfer(from, to, tokenId);
1040 
1041         // Clear approvals from the previous owner
1042         _approve(address(0), tokenId);
1043 
1044         _balances[from] -= 1;
1045         _balances[to] += 1;
1046         _owners[tokenId] = to;
1047 
1048         emit Transfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Approve `to` to operate on `tokenId`
1053      *
1054      * Emits a {Approval} event.
1055      */
1056     function _approve(address to, uint256 tokenId) internal virtual {
1057         _tokenApprovals[tokenId] = to;
1058         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Approve `operator` to operate on all of `owner` tokens
1063      *
1064      * Emits a {ApprovalForAll} event.
1065      */
1066     function _setApprovalForAll(
1067         address owner,
1068         address operator,
1069         bool approved
1070     ) internal virtual {
1071         require(owner != operator, "ERC721: approve to caller");
1072         _operatorApprovals[owner][operator] = approved;
1073         emit ApprovalForAll(owner, operator, approved);
1074     }
1075 
1076     /**
1077      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1078      * The call is not executed if the target address is not a contract.
1079      *
1080      * @param from address representing the previous owner of the given token ID
1081      * @param to target address that will receive the tokens
1082      * @param tokenId uint256 ID of the token to be transferred
1083      * @param _data bytes optional data to send along with the call
1084      * @return bool whether the call correctly returned the expected magic value
1085      */
1086     function _checkOnERC721Received(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) private returns (bool) {
1092         if (to.isContract()) {
1093             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1094                 return retval == IERC721Receiver.onERC721Received.selector;
1095             } catch (bytes memory reason) {
1096                 if (reason.length == 0) {
1097                     revert("ERC721: transfer to non ERC721Receiver implementer");
1098                 } else {
1099                     assembly {
1100                         revert(add(32, reason), mload(reason))
1101                     }
1102                 }
1103             }
1104         } else {
1105             return true;
1106         }
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any token transfer. This includes minting
1111      * and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1116      * transferred to `to`.
1117      * - When `from` is zero, `tokenId` will be minted for `to`.
1118      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1119      * - `from` and `to` are never both zero.
1120      *
1121      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1122      */
1123     function _beforeTokenTransfer(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) internal virtual {}
1128 }
1129 
1130 // File: contracts/LowGas.sol
1131 
1132 
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 contract MetafrensOfficial is ERC721, Ownable {
1137   using Strings for uint256;
1138   using Counters for Counters.Counter;
1139   Counters.Counter private supply;
1140   string public uriPrefix = "ipfs://QmXqK6uKrrViJ7nsRT4RLtGF3xxAmvT5umMSSgmZV2FNKH/";
1141   string public uriSuffix = ".json";
1142   string public hiddenMetadataUri;
1143   uint256 public preSaleWalletLimit = 3;
1144   uint256 public publicSaleWalletLimit = 10;
1145   uint256 public preSaleCost = 0.06 ether;
1146   uint256 public publicSaleCost = 0.07 ether;
1147   uint256 public maxSupply = 1000;
1148   uint256 public maxMintAmountPerTx = 10;
1149   bool public paused = false;
1150   bool public revealed = true;
1151   bool public preSale = true;
1152 
1153   constructor() ERC721("Metafrens Official", "Frens") {
1154     setHiddenMetadataUri("ipfs://hidden.json");
1155   }
1156 
1157   modifier mintCompliance(uint256 _mintAmount) {
1158     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1159     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1160     _;
1161   }
1162 
1163   function totalSupply() public view returns (uint256) {
1164     return supply.current();
1165   }
1166 
1167   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1168     require(!preSale, "Public sale is not yet open");
1169     require(!paused, "The contract is paused!");
1170     require(
1171             balanceOf(msg.sender) + _mintAmount <= publicSaleWalletLimit,
1172             "Max NFT mint limit reached. Try minting in next sale"
1173         );
1174     require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
1175 
1176     _mintLoop(msg.sender, _mintAmount);
1177     
1178   }
1179 
1180   function preSaleMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1181     require(!paused, "The contract is paused!");
1182     if(preSale = true)        
1183         require(
1184             balanceOf(msg.sender) + _mintAmount <= preSaleWalletLimit,
1185             "Max NFT mint limit reached. Try minting in next sale"
1186             );
1187     require(msg.value >= preSaleCost * _mintAmount, "Insufficient funds!");
1188 
1189     _mintLoop(msg.sender, _mintAmount);
1190     
1191   }
1192   // Owner quota for the team and giveaways
1193   function ownerMint(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1194     _mintLoop(_receiver, _mintAmount);
1195     
1196   }
1197 
1198   function walletOfOwner(address _owner)
1199     public
1200     view
1201     returns (uint256[] memory)
1202   {
1203     uint256 ownerTokenCount = balanceOf(_owner);
1204     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1205     uint256 currentTokenId = 1;
1206     uint256 ownedTokenIndex = 0;
1207 
1208     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1209       address currentTokenOwner = ownerOf(currentTokenId);
1210 
1211       if (currentTokenOwner == _owner) {
1212         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1213 
1214         ownedTokenIndex++;
1215       }
1216 
1217       currentTokenId++;
1218     }
1219 
1220     return ownedTokenIds;
1221   }
1222 
1223   function tokenURI(uint256 _tokenId)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (string memory)
1229   {
1230     require(
1231       _exists(_tokenId),
1232       "ERC721Metadata: URI query for nonexistent token"
1233     );
1234 
1235     if (revealed == false) {
1236       return hiddenMetadataUri;
1237     }
1238 
1239     string memory currentBaseURI = _baseURI();
1240     return bytes(currentBaseURI).length > 0
1241         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1242         : "";
1243   }
1244 
1245   function setRevealed(bool _state) public onlyOwner {
1246     revealed = _state;
1247   }
1248 
1249   function setPreSale(bool _state) public onlyOwner {
1250     preSale = _state;
1251   }
1252 
1253   function setPreSaleCost(uint256 _cost) public onlyOwner {
1254     preSaleCost = _cost;
1255   }
1256 
1257   function setPublicSaleCost(uint256 _cost) public onlyOwner {
1258     publicSaleCost = _cost;
1259   }
1260 
1261   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1262     maxMintAmountPerTx = _maxMintAmountPerTx;
1263   }
1264 
1265   function setMaxSupply(uint256 _MaxSupply) public onlyOwner {
1266     maxSupply = _MaxSupply;
1267   }
1268 
1269   function setPreSaleWalletLimit(uint256 _PreSaleWalletLimit) public onlyOwner {
1270     preSaleWalletLimit = _PreSaleWalletLimit;
1271   }
1272 
1273   function setPublicSaleWalletLimit(uint256 _PublicSaleWalletLimit) public onlyOwner {
1274     publicSaleWalletLimit = _PublicSaleWalletLimit;
1275   }
1276 
1277   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1278     hiddenMetadataUri = _hiddenMetadataUri;
1279   }
1280 
1281   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1282     uriPrefix = _uriPrefix;
1283   }
1284 
1285   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1286     uriSuffix = _uriSuffix;
1287   }
1288 
1289   function setPaused(bool _state) public onlyOwner {
1290     paused = _state;
1291   }
1292 
1293   function withdraw() public onlyOwner {    
1294     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1295     require(os);    
1296   }
1297 
1298   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1299     for (uint256 i = 0; i < _mintAmount; i++) {
1300       supply.increment();
1301       _safeMint(_receiver, supply.current());
1302     }
1303   }
1304 
1305   function _baseURI() internal view virtual override returns (string memory) {
1306     return uriPrefix;
1307   }
1308 }