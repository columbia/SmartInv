1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-22
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // File: @openzeppelin/contracts/utils/Counters.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @title Counters
19  * @author Matt Condon (@shrugs)
20  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
21  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
22  *
23  * Include with `using Counters for Counters.Counter;`
24  */
25 library Counters {
26     struct Counter {
27         // This variable should never be directly accessed by users of the library: interactions must be restricted to
28         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
29         // this feature: see https://github.com/ethereum/solidity/issues/4637
30         uint256 _value; // default: 0
31     }
32 
33     function current(Counter storage counter) internal view returns (uint256) {
34         return counter._value;
35     }
36 
37     function increment(Counter storage counter) internal {
38         unchecked {
39             counter._value += 1;
40         }
41     }
42 
43     function decrement(Counter storage counter) internal {
44         uint256 value = counter._value;
45         require(value > 0, "Counter: decrement overflow");
46         unchecked {
47             counter._value = value - 1;
48         }
49     }
50 
51     function reset(Counter storage counter) internal {
52         counter._value = 0;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/access/Ownable.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Returns the address of the current owner.
187      */
188     function owner() public view virtual returns (address) {
189         return _owner;
190     }
191 
192     /**
193      * @dev Throws if called by any account other than the owner.
194      */
195     modifier onlyOwner() {
196         require(owner() == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199 
200     /**
201      * @dev Leaves the contract without owner. It will not be possible to call
202      * `onlyOwner` functions anymore. Can only be called by the current owner.
203      *
204      * NOTE: Renouncing ownership will leave the contract without an owner,
205      * thereby removing any functionality that is only available to the owner.
206      */
207     function renounceOwnership() public virtual onlyOwner {
208         _transferOwnership(address(0));
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Can only be called by the current owner.
214      */
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         _transferOwnership(newOwner);
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Internal function without access restriction.
223      */
224     function _transferOwnership(address newOwner) internal virtual {
225         address oldOwner = _owner;
226         _owner = newOwner;
227         emit OwnershipTransferred(oldOwner, newOwner);
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @title ERC721 token receiver interface
460  * @dev Interface for any contract that wants to support safeTransfers
461  * from ERC721 asset contracts.
462  */
463 interface IERC721Receiver {
464     /**
465      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
466      * by `operator` from `from`, this function is called.
467      *
468      * It must return its Solidity selector to confirm the token transfer.
469      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
470      *
471      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
472      */
473     function onERC721Received(
474         address operator,
475         address from,
476         uint256 tokenId,
477         bytes calldata data
478     ) external returns (bytes4);
479 }
480 
481 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Interface of the ERC165 standard, as defined in the
490  * https://eips.ethereum.org/EIPS/eip-165[EIP].
491  *
492  * Implementers can declare support of contract interfaces, which can then be
493  * queried by others ({ERC165Checker}).
494  *
495  * For an implementation, see {ERC165}.
496  */
497 interface IERC165 {
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Required interface of an ERC721 compliant contract.
550  */
551 interface IERC721 is IERC165 {
552     /**
553      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
554      */
555     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
559      */
560     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
564      */
565     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
566 
567     /**
568      * @dev Returns the number of tokens in ``owner``'s account.
569      */
570     function balanceOf(address owner) external view returns (uint256 balance);
571 
572     /**
573      * @dev Returns the owner of the `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function ownerOf(uint256 tokenId) external view returns (address owner);
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
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
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId,
681         bytes calldata data
682     ) external;
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
695  * @dev See https://eips.ethereum.org/EIPS/eip-721
696  */
697 interface IERC721Metadata is IERC721 {
698     /**
699      * @dev Returns the token collection name.
700      */
701     function name() external view returns (string memory);
702 
703     /**
704      * @dev Returns the token collection symbol.
705      */
706     function symbol() external view returns (string memory);
707 
708     /**
709      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
710      */
711     function tokenURI(uint256 tokenId) external view returns (string memory);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension, but not including the Enumerable extension, which is available separately as
731  * {ERC721Enumerable}.
732  */
733 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to owner address
744     mapping(uint256 => address) private _owners;
745 
746     // Mapping owner address to token count
747     mapping(address => uint256) private _balances;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     /**
756      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
757      */
758     constructor(string memory name_, string memory symbol_) {
759         _name = name_;
760         _symbol = symbol_;
761     }
762 
763     /**
764      * @dev See {IERC165-supportsInterface}.
765      */
766     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
767         return
768             interfaceId == type(IERC721).interfaceId ||
769             interfaceId == type(IERC721Metadata).interfaceId ||
770             super.supportsInterface(interfaceId);
771     }
772 
773     /**
774      * @dev See {IERC721-balanceOf}.
775      */
776     function balanceOf(address owner) public view virtual override returns (uint256) {
777         require(owner != address(0), "ERC721: balance query for the zero address");
778         return _balances[owner];
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
785         address owner = _owners[tokenId];
786         require(owner != address(0), "ERC721: owner query for nonexistent token");
787         return owner;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overriden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return "";
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         //solhint-disable-next-line max-line-length
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871 
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         safeTransferFrom(from, to, tokenId, "");
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
896         _safeTransfer(from, to, tokenId, _data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) internal virtual {
923         _transfer(from, to, tokenId);
924         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      * and stop existing when they are burned (`_burn`).
934      */
935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
936         return _owners[tokenId] != address(0);
937     }
938 
939     /**
940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
947         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
948         address owner = ERC721.ownerOf(tokenId);
949         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
950     }
951 
952     /**
953      * @dev Safely mints `tokenId` and transfers it to `to`.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must not exist.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeMint(address to, uint256 tokenId) internal virtual {
963         _safeMint(to, tokenId, "");
964     }
965 
966     /**
967      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
968      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
969      */
970     function _safeMint(
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) internal virtual {
975         _mint(to, tokenId);
976         require(
977             _checkOnERC721Received(address(0), to, tokenId, _data),
978             "ERC721: transfer to non ERC721Receiver implementer"
979         );
980     }
981 
982     /**
983      * @dev Mints `tokenId` and transfers it to `to`.
984      *
985      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
986      *
987      * Requirements:
988      *
989      * - `tokenId` must not exist.
990      * - `to` cannot be the zero address.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _mint(address to, uint256 tokenId) internal virtual {
995         require(to != address(0), "ERC721: mint to the zero address");
996         require(!_exists(tokenId), "ERC721: token already minted");
997 
998         _beforeTokenTransfer(address(0), to, tokenId);
999 
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(address(0), to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Destroys `tokenId`.
1008      * The approval is cleared when the token is burned.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _burn(uint256 tokenId) internal virtual {
1017         address owner = ERC721.ownerOf(tokenId);
1018 
1019         _beforeTokenTransfer(owner, address(0), tokenId);
1020 
1021         // Clear approvals
1022         _approve(address(0), tokenId);
1023 
1024         _balances[owner] -= 1;
1025         delete _owners[tokenId];
1026 
1027         emit Transfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Transfers `tokenId` from `from` to `to`.
1032      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {
1046         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1047         require(to != address(0), "ERC721: transfer to the zero address");
1048 
1049         _beforeTokenTransfer(from, to, tokenId);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId);
1053 
1054         _balances[from] -= 1;
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(from, to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Approve `to` to operate on `tokenId`
1063      *
1064      * Emits a {Approval} event.
1065      */
1066     function _approve(address to, uint256 tokenId) internal virtual {
1067         _tokenApprovals[tokenId] = to;
1068         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Approve `operator` to operate on all of `owner` tokens
1073      *
1074      * Emits a {ApprovalForAll} event.
1075      */
1076     function _setApprovalForAll(
1077         address owner,
1078         address operator,
1079         bool approved
1080     ) internal virtual {
1081         require(owner != operator, "ERC721: approve to caller");
1082         _operatorApprovals[owner][operator] = approved;
1083         emit ApprovalForAll(owner, operator, approved);
1084     }
1085 
1086     /**
1087      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1088      * The call is not executed if the target address is not a contract.
1089      *
1090      * @param from address representing the previous owner of the given token ID
1091      * @param to target address that will receive the tokens
1092      * @param tokenId uint256 ID of the token to be transferred
1093      * @param _data bytes optional data to send along with the call
1094      * @return bool whether the call correctly returned the expected magic value
1095      */
1096     function _checkOnERC721Received(
1097         address from,
1098         address to,
1099         uint256 tokenId,
1100         bytes memory _data
1101     ) private returns (bool) {
1102         if (to.isContract()) {
1103             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1104                 return retval == IERC721Receiver.onERC721Received.selector;
1105             } catch (bytes memory reason) {
1106                 if (reason.length == 0) {
1107                     revert("ERC721: transfer to non ERC721Receiver implementer");
1108                 } else {
1109                     assembly {
1110                         revert(add(32, reason), mload(reason))
1111                     }
1112                 }
1113             }
1114         } else {
1115             return true;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before any token transfer. This includes minting
1121      * and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` will be minted for `to`.
1128      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1129      * - `from` and `to` are never both zero.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _beforeTokenTransfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) internal virtual {}
1138 }
1139 
1140 // File: contracts/KevinPunks.sol
1141 
1142 
1143 
1144 pragma solidity >=0.7.0 <0.9.0;
1145 
1146 
1147 
1148 
1149 contract KevinPunks is ERC721, Ownable {
1150   using Strings for uint256;
1151   using Counters for Counters.Counter;
1152 
1153   Counters.Counter private supply;
1154 
1155   string public uriPrefix = "";
1156   string public uriSuffix = ".json";
1157   string public hiddenMetadataUri;
1158   
1159   uint256 public cost = 0.02 ether;
1160   uint256 public maxSupply = 555;
1161   uint256 public maxMintAmountPerTx = 10;
1162   uint256 public freeMintAmount = 0;
1163   mapping(address => uint256) public addressMintedBalance;
1164 
1165   bool public paused = false;
1166   bool public revealed = false;
1167 
1168   constructor() ERC721("KevinPunks", "Kevin") {
1169     setHiddenMetadataUri("ipfs://QmcJanwoBaTvPSwMZLwSR18GTZuB5idcKJfrYZHZBNEpNG/1.json");
1170     setUriPrefix("ipfs://QmcJanwoBaTvPSwMZLwSR18GTZuB5idcKJfrYZHZBNEpNG/");
1171     setRevealed(true);
1172   }
1173 
1174   modifier mintCompliance(uint256 _mintAmount) {
1175         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1176         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1177     _;
1178   }
1179 
1180   function totalSupply() public view returns (uint256) {
1181     return supply.current();
1182   }
1183 
1184   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1185     require(!paused, "The contract is paused!");
1186     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1187     _mintLoop(msg.sender, _mintAmount);
1188   }
1189   
1190   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1191     _mintLoop(_receiver, _mintAmount);
1192   }
1193 
1194   function walletOfOwner(address _owner)
1195     public
1196     view
1197     returns (uint256[] memory)
1198   {
1199     uint256 ownerTokenCount = balanceOf(_owner);
1200     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1201     uint256 currentTokenId = 1;
1202     uint256 ownedTokenIndex = 0;
1203 
1204     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1205       address currentTokenOwner = ownerOf(currentTokenId);
1206 
1207       if (currentTokenOwner == _owner) {
1208         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1209 
1210         ownedTokenIndex++;
1211       }
1212 
1213       currentTokenId++;
1214     }
1215 
1216     return ownedTokenIds;
1217   }
1218 
1219   function tokenURI(uint256 _tokenId)
1220     public
1221     view
1222     virtual
1223     override
1224     returns (string memory)
1225   {
1226     require(
1227       _exists(_tokenId),
1228       "ERC721Metadata: URI query for nonexistent token"
1229     );
1230 
1231     if (revealed == false) {
1232       return hiddenMetadataUri;
1233     }
1234 
1235     string memory currentBaseURI = _baseURI();
1236     return bytes(currentBaseURI).length > 0
1237         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1238         : "";
1239   }
1240 
1241   function setRevealed(bool _state) public onlyOwner {
1242     revealed = _state;
1243   }
1244 
1245   function setCost(uint256 _cost) public onlyOwner {
1246     cost = _cost;
1247   }
1248 
1249   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1250     maxMintAmountPerTx = _maxMintAmountPerTx;
1251   }
1252 
1253   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1254     hiddenMetadataUri = _hiddenMetadataUri;
1255   }
1256 
1257   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1258     uriPrefix = _uriPrefix;
1259   }
1260 
1261   function setFreeMintAmount(uint256 _freeMintAmount) public onlyOwner {
1262       freeMintAmount = _freeMintAmount;
1263   }
1264 
1265   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1266     uriSuffix = _uriSuffix;
1267   }
1268 
1269   function setPaused(bool _state) public onlyOwner {
1270     paused = _state;
1271   }
1272 
1273   function withdraw() public onlyOwner {
1274     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1275     require(os);
1276   }
1277 
1278   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1279     for (uint256 i = 0; i < _mintAmount; i++) {
1280       supply.increment();
1281       addressMintedBalance[msg.sender]++;
1282       _safeMint(_receiver, supply.current());
1283     }
1284   }
1285 
1286   function _baseURI() internal view virtual override returns (string memory) {
1287     return uriPrefix;
1288   }
1289 }