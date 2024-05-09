1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 /*
8  This project is in the public domain, no rights reserved.
9 */
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @title Counters
15  * @author Matt Condon (@shrugs)
16  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
17  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
18  *
19  * Include with `using Counters for Counters.Counter;`
20  */
21 library Counters {
22     struct Counter {
23         // This variable should never be directly accessed by users of the library: interactions must be restricted to
24         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
25         // this feature: see https://github.com/ethereum/solidity/issues/4637
26         uint256 _value; // default: 0
27     }
28 
29     function current(Counter storage counter) internal view returns (uint256) {
30         return counter._value;
31     }
32 
33     function increment(Counter storage counter) internal {
34         unchecked {
35             counter._value += 1;
36         }
37     }
38 
39     function decrement(Counter storage counter) internal {
40         uint256 value = counter._value;
41         require(value > 0, "Counter: decrement overflow");
42         unchecked {
43             counter._value = value - 1;
44         }
45     }
46 
47     function reset(Counter storage counter) internal {
48         counter._value = 0;
49     }
50 }
51 
52 // File: @openzeppelin/contracts/utils/Strings.sol
53 
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @dev String operations.
61  */
62 library Strings {
63     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
67      */
68     function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
92      */
93     function toHexString(uint256 value) internal pure returns (string memory) {
94         if (value == 0) {
95             return "0x00";
96         }
97         uint256 temp = value;
98         uint256 length = 0;
99         while (temp != 0) {
100             length++;
101             temp >>= 8;
102         }
103         return toHexString(value, length);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
108      */
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Context.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         return msg.data;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/access/Ownable.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 
157 /**
158  * @dev Contract module which provides a basic access control mechanism, where
159  * there is an account (an owner) that can be granted exclusive access to
160  * specific functions.
161  *
162  * By default, the owner account will be the one that deploys the contract. This
163  * can later be changed with {transferOwnership}.
164  *
165  * This module is used through inheritance. It will make available the modifier
166  * `onlyOwner`, which can be applied to your functions to restrict their use to
167  * the owner.
168  */
169 abstract contract Ownable is Context {
170     address private _owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev Initializes the contract setting the deployer as the initial owner.
176      */
177     constructor() {
178         _transferOwnership(_msgSender());
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view virtual returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         _transferOwnership(address(0));
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         _transferOwnership(newOwner);
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      * Internal function without access restriction.
219      */
220     function _transferOwnership(address newOwner) internal virtual {
221         address oldOwner = _owner;
222         _owner = newOwner;
223         emit OwnershipTransferred(oldOwner, newOwner);
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Address.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @title ERC721 token receiver interface
456  * @dev Interface for any contract that wants to support safeTransfers
457  * from ERC721 asset contracts.
458  */
459 interface IERC721Receiver {
460     /**
461      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
462      * by `operator` from `from`, this function is called.
463      *
464      * It must return its Solidity selector to confirm the token transfer.
465      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
466      *
467      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
468      */
469     function onERC721Received(
470         address operator,
471         address from,
472         uint256 tokenId,
473         bytes calldata data
474     ) external returns (bytes4);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Interface of the ERC165 standard, as defined in the
486  * https://eips.ethereum.org/EIPS/eip-165[EIP].
487  *
488  * Implementers can declare support of contract interfaces, which can then be
489  * queried by others ({ERC165Checker}).
490  *
491  * For an implementation, see {ERC165}.
492  */
493 interface IERC165 {
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30 000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Implementation of the {IERC165} interface.
515  *
516  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
517  * for the additional interface id that will be supported. For example:
518  *
519  * ```solidity
520  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
522  * }
523  * ```
524  *
525  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
526  */
527 abstract contract ERC165 is IERC165 {
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532         return interfaceId == type(IERC165).interfaceId;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Required interface of an ERC721 compliant contract.
546  */
547 interface IERC721 is IERC165 {
548     /**
549      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
555      */
556     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
560      */
561     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
562 
563     /**
564      * @dev Returns the number of tokens in ``owner``'s account.
565      */
566     function balanceOf(address owner) external view returns (uint256 balance);
567 
568     /**
569      * @dev Returns the owner of the `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function ownerOf(uint256 tokenId) external view returns (address owner);
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
579      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Transfers `tokenId` token from `from` to `to`.
599      *
600      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
619      * The approval is cleared when the token is transferred.
620      *
621      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
622      *
623      * Requirements:
624      *
625      * - The caller must own the token or be an approved operator.
626      * - `tokenId` must exist.
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address to, uint256 tokenId) external;
631 
632     /**
633      * @dev Returns the account approved for `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function getApproved(uint256 tokenId) external view returns (address operator);
640 
641     /**
642      * @dev Approve or remove `operator` as an operator for the caller.
643      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
644      *
645      * Requirements:
646      *
647      * - The `operator` cannot be the caller.
648      *
649      * Emits an {ApprovalForAll} event.
650      */
651     function setApprovalForAll(address operator, bool _approved) external;
652 
653     /**
654      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
655      *
656      * See {setApprovalForAll}
657      */
658     function isApprovedForAll(address owner, address operator) external view returns (bool);
659 
660     /**
661      * @dev Safely transfers `tokenId` token from `from` to `to`.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId,
677         bytes calldata data
678     ) external;
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 
719 
720 
721 
722 
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension, but not including the Enumerable extension, which is available separately as
727  * {ERC721Enumerable}.
728  */
729 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
753      */
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view virtual override returns (uint256) {
773         require(owner != address(0), "ERC721: balance query for the zero address");
774         return _balances[owner];
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         address owner = _owners[tokenId];
782         require(owner != address(0), "ERC721: owner query for nonexistent token");
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overriden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return "";
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ERC721.ownerOf(tokenId);
824         require(to != owner, "ERC721: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721: approve caller is not owner nor approved for all"
829         );
830 
831         _approve(to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         _setApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         //solhint-disable-next-line max-line-length
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
867 
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, "");
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) public virtual override {
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
892         _safeTransfer(from, to, tokenId, _data);
893     }
894 
895     /**
896      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
897      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
898      *
899      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
900      *
901      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
902      * implement alternative mechanisms to perform token transfer, such as signature-based.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeTransfer(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
946     }
947 
948     /**
949      * @dev Safely mints `tokenId` and transfers it to `to`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(address to, uint256 tokenId) internal virtual {
959         _safeMint(to, tokenId, "");
960     }
961 
962     /**
963      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
964      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
965      */
966     function _safeMint(
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) internal virtual {
971         _mint(to, tokenId);
972         require(
973             _checkOnERC721Received(address(0), to, tokenId, _data),
974             "ERC721: transfer to non ERC721Receiver implementer"
975         );
976     }
977 
978     /**
979      * @dev Mints `tokenId` and transfers it to `to`.
980      *
981      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - `to` cannot be the zero address.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(address to, uint256 tokenId) internal virtual {
991         require(to != address(0), "ERC721: mint to the zero address");
992         require(!_exists(tokenId), "ERC721: token already minted");
993 
994         _beforeTokenTransfer(address(0), to, tokenId);
995 
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(address(0), to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Destroys `tokenId`.
1004      * The approval is cleared when the token is burned.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _burn(uint256 tokenId) internal virtual {
1013         address owner = ERC721.ownerOf(tokenId);
1014 
1015         _beforeTokenTransfer(owner, address(0), tokenId);
1016 
1017         // Clear approvals
1018         _approve(address(0), tokenId);
1019 
1020         _balances[owner] -= 1;
1021         delete _owners[tokenId];
1022 
1023         emit Transfer(owner, address(0), tokenId);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must be owned by `from`.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _transfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual {
1042         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1043         require(to != address(0), "ERC721: transfer to the zero address");
1044 
1045         _beforeTokenTransfer(from, to, tokenId);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId);
1049 
1050         _balances[from] -= 1;
1051         _balances[to] += 1;
1052         _owners[tokenId] = to;
1053 
1054         emit Transfer(from, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Approve `to` to operate on `tokenId`
1059      *
1060      * Emits a {Approval} event.
1061      */
1062     function _approve(address to, uint256 tokenId) internal virtual {
1063         _tokenApprovals[tokenId] = to;
1064         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `operator` to operate on all of `owner` tokens
1069      *
1070      * Emits a {ApprovalForAll} event.
1071      */
1072     function _setApprovalForAll(
1073         address owner,
1074         address operator,
1075         bool approved
1076     ) internal virtual {
1077         require(owner != operator, "ERC721: approve to caller");
1078         _operatorApprovals[owner][operator] = approved;
1079         emit ApprovalForAll(owner, operator, approved);
1080     }
1081 
1082     /**
1083      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1084      * The call is not executed if the target address is not a contract.
1085      *
1086      * @param from address representing the previous owner of the given token ID
1087      * @param to target address that will receive the tokens
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @param _data bytes optional data to send along with the call
1090      * @return bool whether the call correctly returned the expected magic value
1091      */
1092     function _checkOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         if (to.isContract()) {
1099             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1100                 return retval == IERC721Receiver.onERC721Received.selector;
1101             } catch (bytes memory reason) {
1102                 if (reason.length == 0) {
1103                     revert("ERC721: transfer to non ERC721Receiver implementer");
1104                 } else {
1105                     assembly {
1106                         revert(add(32, reason), mload(reason))
1107                     }
1108                 }
1109             }
1110         } else {
1111             return true;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Hook that is called before any token transfer. This includes minting
1117      * and burning.
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` will be minted for `to`.
1124      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1125      * - `from` and `to` are never both zero.
1126      *
1127      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1128      */
1129     function _beforeTokenTransfer(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) internal virtual {}
1134 }
1135 
1136 // File: contracts/MfersDoinStuff.sol
1137 
1138 pragma solidity >=0.7.0 <0.9.0;
1139 
1140 contract MfersDoinStuff is ERC721, Ownable {
1141   using Strings for uint256;
1142   using Counters for Counters.Counter;
1143 
1144   Counters.Counter private
1145    supply;
1146 
1147   string public uriPrefix = "";
1148   string public uriSuffix = ".json";
1149   string public hiddenMetadataUri;
1150   
1151   uint256 public cost = 0.035 ether;
1152   uint256 public maxSupply = 2069;
1153   uint256 public maxMintAmount = 2069;
1154 
1155   bool public paused = false;
1156   bool public revealed = false;
1157 
1158   bool public onlyWhitelisted = false;
1159   bytes32 private rootHash;
1160   mapping(address => uint256) public addressesMintBalance;
1161 
1162   constructor() ERC721("mfers doin stuff", "mfersdoin") {
1163     setHiddenMetadataUri("ipfs://QmdeVuvQBgNWoTLxKoHyWzJW9i5EHJNJBJrM9N6LyrMm4W/placeholder.gif");
1164   }
1165 
1166   modifier mintCompliance(uint256 _mintAmount) {
1167     require(_mintAmount > 0 && _mintAmount <= maxMintAmount, "Invalid mint amount!");
1168     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1169     _;
1170   }
1171 
1172   function totalSupply() public view returns (uint256) {
1173     return supply.current();
1174   }
1175 
1176   function mint(uint256 _mintAmount, bytes32[] calldata proof) public payable mintCompliance(_mintAmount) {
1177     require(!paused, "The contract is paused!");
1178     
1179     
1180     if (msg.sender != owner()) {
1181         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1182         require(addressesMintBalance[msg.sender] + _mintAmount <= maxMintAmount, "Minting more than allowed");
1183 
1184         if (onlyWhitelisted == true){
1185             require(verify(keccak256(abi.encodePacked(msg.sender)), proof), "Not Whitelisted User!");
1186         }
1187         
1188         require(msg.value >= cost * _mintAmount);
1189     }
1190 
1191     _mintLoop(msg.sender, _mintAmount);
1192   }
1193 
1194   function verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool)
1195   {
1196     bytes32 computedHash = leaf;
1197 
1198     for (uint256 i = 0; i < proof.length; i++) {
1199       bytes32 proofElement = proof[i];
1200 
1201       if (computedHash <= proofElement) {
1202         // Hash(current computed hash + current element of the proof)
1203         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1204       } else {
1205         // Hash(current element of the proof + current computed hash)
1206         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1207       }
1208     }
1209 
1210     // Check if the computed hash (root) is equal to the provided root
1211     return computedHash == rootHash;
1212   }
1213   
1214   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1215     _mintLoop(_receiver, _mintAmount);
1216   }
1217 
1218   function walletOfOwner(address _owner)
1219     public
1220     view
1221     returns (uint256[] memory)
1222   {
1223     uint256 ownerTokenCount = balanceOf(_owner);
1224     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1225     uint256 currentTokenId = 1;
1226     uint256 ownedTokenIndex = 0;
1227 
1228     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1229       address currentTokenOwner = ownerOf(currentTokenId);
1230 
1231       if (currentTokenOwner == _owner) {
1232         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1233 
1234         ownedTokenIndex++;
1235       }
1236 
1237       currentTokenId++;
1238     }
1239 
1240     return ownedTokenIds;
1241   }
1242 
1243   function tokenURI(uint256 _tokenId)
1244     public
1245     view
1246     virtual
1247     override
1248     returns (string memory)
1249   {
1250     require(
1251       _exists(_tokenId),
1252       "ERC721Metadata: URI query for nonexistent token"
1253     );
1254 
1255     if (revealed == false) {
1256       return hiddenMetadataUri;
1257     }
1258 
1259     string memory currentBaseURI = _baseURI();
1260     return bytes(currentBaseURI).length > 0
1261         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1262         : "";
1263   }
1264 
1265   function setRevealed(bool _state) public onlyOwner {
1266     revealed = _state;
1267   }
1268 
1269   function setCost(uint256 _cost) public onlyOwner {
1270     cost = _cost;
1271   }
1272 
1273   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1274     maxMintAmount = _maxMintAmount ;
1275   }
1276 
1277   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1278     hiddenMetadataUri = _hiddenMetadataUri;
1279   }
1280 
1281   function setOnlyWhitelisted(bool _value) public onlyOwner {
1282     onlyWhitelisted = _value;
1283   }
1284 
1285   function setRootHash(bytes32 _hash) public onlyOwner {
1286     rootHash = _hash;
1287   }
1288 
1289   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1290     uriPrefix = _uriPrefix;
1291   }
1292 
1293   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1294     uriSuffix = _uriSuffix;
1295   }
1296 
1297   function setPaused(bool _state) public onlyOwner {
1298     paused = _state;
1299   }
1300 
1301   function withdraw() public onlyOwner {
1302     
1303     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1304     require(os);
1305     
1306   }
1307 
1308   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1309     for (uint256 i = 0; i < _mintAmount; i++) {
1310       supply.increment();
1311       _safeMint(_receiver, supply.current());
1312       addressesMintBalance[msg.sender]++;
1313     }
1314   }
1315 
1316   function _baseURI() internal view virtual override returns (string memory) {
1317     return uriPrefix;
1318   }
1319 }