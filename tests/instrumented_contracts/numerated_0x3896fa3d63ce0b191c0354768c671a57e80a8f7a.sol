1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC721 token receiver interface
452  * @dev Interface for any contract that wants to support safeTransfers
453  * from ERC721 asset contracts.
454  */
455 interface IERC721Receiver {
456     /**
457      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
458      * by `operator` from `from`, this function is called.
459      *
460      * It must return its Solidity selector to confirm the token transfer.
461      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
462      *
463      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
464      */
465     function onERC721Received(
466         address operator,
467         address from,
468         uint256 tokenId,
469         bytes calldata data
470     ) external returns (bytes4);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes calldata data
674     ) external;
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Metadata is IERC721 {
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 
715 
716 
717 
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension, but not including the Enumerable extension, which is available separately as
723  * {ERC721Enumerable}.
724  */
725 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Token name
730     string private _name;
731 
732     // Token symbol
733     string private _symbol;
734 
735     // Mapping from token ID to owner address
736     mapping(uint256 => address) private _owners;
737 
738     // Mapping owner address to token count
739     mapping(address => uint256) private _balances;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
749      */
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
759         return
760             interfaceId == type(IERC721).interfaceId ||
761             interfaceId == type(IERC721Metadata).interfaceId ||
762             super.supportsInterface(interfaceId);
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view virtual override returns (uint256) {
769         require(owner != address(0), "ERC721: balance query for the zero address");
770         return _balances[owner];
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
777         address owner = _owners[tokenId];
778         require(owner != address(0), "ERC721: owner query for nonexistent token");
779         return owner;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public virtual override {
819         address owner = ERC721.ownerOf(tokenId);
820         require(to != owner, "ERC721: approval to current owner");
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721: approve caller is not owner nor approved for all"
825         );
826 
827         _approve(to, tokenId);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view virtual override returns (address) {
834         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public virtual override {
843         _setApprovalForAll(_msgSender(), operator, approved);
844     }
845 
846     /**
847      * @dev See {IERC721-isApprovedForAll}.
848      */
849     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
850         return _operatorApprovals[owner][operator];
851     }
852 
853     /**
854      * @dev See {IERC721-transferFrom}.
855      */
856     function transferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         //solhint-disable-next-line max-line-length
862         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
863 
864         _transfer(from, to, tokenId);
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         safeTransferFrom(from, to, tokenId, "");
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public virtual override {
887         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
888         _safeTransfer(from, to, tokenId, _data);
889     }
890 
891     /**
892      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
893      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
894      *
895      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
896      *
897      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
898      * implement alternative mechanisms to perform token transfer, such as signature-based.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _safeTransfer(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) internal virtual {
915         _transfer(from, to, tokenId);
916         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      * and stop existing when they are burned (`_burn`).
926      */
927     function _exists(uint256 tokenId) internal view virtual returns (bool) {
928         return _owners[tokenId] != address(0);
929     }
930 
931     /**
932      * @dev Returns whether `spender` is allowed to manage `tokenId`.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      */
938     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
939         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
940         address owner = ERC721.ownerOf(tokenId);
941         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
942     }
943 
944     /**
945      * @dev Safely mints `tokenId` and transfers it to `to`.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must not exist.
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeMint(address to, uint256 tokenId) internal virtual {
955         _safeMint(to, tokenId, "");
956     }
957 
958     /**
959      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
960      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
961      */
962     function _safeMint(
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _mint(to, tokenId);
968         require(
969             _checkOnERC721Received(address(0), to, tokenId, _data),
970             "ERC721: transfer to non ERC721Receiver implementer"
971         );
972     }
973 
974     /**
975      * @dev Mints `tokenId` and transfers it to `to`.
976      *
977      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
978      *
979      * Requirements:
980      *
981      * - `tokenId` must not exist.
982      * - `to` cannot be the zero address.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _mint(address to, uint256 tokenId) internal virtual {
987         require(to != address(0), "ERC721: mint to the zero address");
988         require(!_exists(tokenId), "ERC721: token already minted");
989 
990         _beforeTokenTransfer(address(0), to, tokenId);
991 
992         _balances[to] += 1;
993         _owners[tokenId] = to;
994 
995         emit Transfer(address(0), to, tokenId);
996     }
997 
998     /**
999      * @dev Destroys `tokenId`.
1000      * The approval is cleared when the token is burned.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _burn(uint256 tokenId) internal virtual {
1009         address owner = ERC721.ownerOf(tokenId);
1010 
1011         _beforeTokenTransfer(owner, address(0), tokenId);
1012 
1013         // Clear approvals
1014         _approve(address(0), tokenId);
1015 
1016         _balances[owner] -= 1;
1017         delete _owners[tokenId];
1018 
1019         emit Transfer(owner, address(0), tokenId);
1020     }
1021 
1022     /**
1023      * @dev Transfers `tokenId` from `from` to `to`.
1024      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must be owned by `from`.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) internal virtual {
1038         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1039         require(to != address(0), "ERC721: transfer to the zero address");
1040 
1041         _beforeTokenTransfer(from, to, tokenId);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId);
1045 
1046         _balances[from] -= 1;
1047         _balances[to] += 1;
1048         _owners[tokenId] = to;
1049 
1050         emit Transfer(from, to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Approve `to` to operate on `tokenId`
1055      *
1056      * Emits a {Approval} event.
1057      */
1058     function _approve(address to, uint256 tokenId) internal virtual {
1059         _tokenApprovals[tokenId] = to;
1060         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `operator` to operate on all of `owner` tokens
1065      *
1066      * Emits a {ApprovalForAll} event.
1067      */
1068     function _setApprovalForAll(
1069         address owner,
1070         address operator,
1071         bool approved
1072     ) internal virtual {
1073         require(owner != operator, "ERC721: approve to caller");
1074         _operatorApprovals[owner][operator] = approved;
1075         emit ApprovalForAll(owner, operator, approved);
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param _data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1096                 return retval == IERC721Receiver.onERC721Received.selector;
1097             } catch (bytes memory reason) {
1098                 if (reason.length == 0) {
1099                     revert("ERC721: transfer to non ERC721Receiver implementer");
1100                 } else {
1101                     assembly {
1102                         revert(add(32, reason), mload(reason))
1103                     }
1104                 }
1105             }
1106         } else {
1107             return true;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1121      * - `from` and `to` are never both zero.
1122      *
1123      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1124      */
1125     function _beforeTokenTransfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) internal virtual {}
1130 }
1131 
1132 // File: contracts/GK.sol
1133 
1134 
1135 // Written by Andrew Olson
1136 
1137 pragma solidity >=0.7.0 <0.9.0;
1138 
1139 
1140 
1141 
1142 contract GangstaKongz is ERC721, Ownable {
1143   using Strings for uint256;
1144   using Counters for Counters.Counter;
1145 
1146   Counters.Counter private supply;
1147 
1148   string public uriPrefix = "";
1149   string public uriSuffix = ".json";
1150   string public hiddenMetadataUri;
1151   
1152   uint256 public cost = 0.0824 ether;
1153   uint256 public maxSupply = 10000;
1154   uint256 public maxMintAmountPerTx = 10;
1155   uint256 public nftPerAddressLimit = 30;
1156 
1157   bool public paused = false;
1158   bool public revealed = true;
1159 
1160   mapping(address => uint256) public addressMintedBalance;
1161 
1162   constructor() ERC721("Gangsta Kong", "GK") {
1163     setHiddenMetadataUri("ipfs://QmUcG8U4kKRfjrqbuJ2z7yqGZhpVEY69QjBGrat97xz6bd/unrevealed.json");
1164   }
1165 
1166   modifier mintCompliance(uint256 _mintAmount) {
1167     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1168     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1169     uint256 ownerMintedAmount = addressMintedBalance[msg.sender];
1170     require(ownerMintedAmount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1171     _;
1172   }
1173 
1174   function totalSupply() public view returns (uint256) {
1175     return supply.current();
1176   }
1177 
1178   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1179     require(!paused, "The contract is paused!");
1180     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1181 
1182     _mintLoop(msg.sender, _mintAmount);
1183   }
1184   
1185   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1186     _mintLoop(_receiver, _mintAmount);
1187   }
1188 
1189   function walletOfOwner(address _owner)
1190     public
1191     view
1192     returns (uint256[] memory)
1193   {
1194     uint256 ownerTokenCount = balanceOf(_owner);
1195     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1196     uint256 currentTokenId = 1;
1197     uint256 ownedTokenIndex = 0;
1198 
1199     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1200       address currentTokenOwner = ownerOf(currentTokenId);
1201 
1202       if (currentTokenOwner == _owner) {
1203         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1204 
1205         ownedTokenIndex++;
1206       }
1207 
1208       currentTokenId++;
1209     }
1210 
1211     return ownedTokenIds;
1212   }
1213 
1214   function tokenURI(uint256 _tokenId)
1215     public
1216     view
1217     virtual
1218     override
1219     returns (string memory)
1220   {
1221     require(
1222       _exists(_tokenId),
1223       "ERC721Metadata: URI query for nonexistent token"
1224     );
1225 
1226     if (revealed == false) {
1227       return hiddenMetadataUri;
1228     }
1229 
1230     string memory currentBaseURI = _baseURI();
1231     return bytes(currentBaseURI).length > 0
1232         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1233         : "";
1234   }
1235 
1236   function setRevealed(bool _state) public onlyOwner {
1237     revealed = _state;
1238   }
1239 
1240   function setCost(uint256 _cost) public onlyOwner {
1241     cost = _cost;
1242   }
1243 
1244   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1245     maxMintAmountPerTx = _maxMintAmountPerTx;
1246   }
1247 
1248   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1249     hiddenMetadataUri = _hiddenMetadataUri;
1250   }
1251 
1252   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1253     uriPrefix = _uriPrefix;
1254   }
1255 
1256   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1257     uriSuffix = _uriSuffix;
1258   }
1259 
1260   function setPaused(bool _state) public onlyOwner {
1261     paused = _state;
1262   }
1263     
1264   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1265     nftPerAddressLimit = _limit;
1266   }
1267 
1268   function setSupply(uint256 _newSupply) public onlyOwner {
1269     maxSupply = _newSupply;
1270   }
1271   
1272   function withdraw() public onlyOwner {
1273   
1274     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1275     require(os);  
1276   }
1277 
1278   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1279     for (uint256 i = 0; i < _mintAmount; i++) {
1280       supply.increment();
1281       _safeMint(_receiver, supply.current());
1282     }
1283   }
1284 
1285   function _baseURI() internal view virtual override returns (string memory) {
1286     return uriPrefix;
1287   }
1288 }