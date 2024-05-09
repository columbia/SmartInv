1 // File: @openzeppelin/contracts/utils/Counters.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
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
103     function toHexString(uint256 value, uint256 length)
104         internal
105         pure
106         returns (string memory)
107     {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Context.sol
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/access/Ownable.sol
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(
168         address indexed previousOwner,
169         address indexed newOwner
170     );
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor() {
176         _transferOwnership(_msgSender());
177     }
178 
179     /**
180      * @dev Returns the address of the current owner.
181      */
182     function owner() public view virtual returns (address) {
183         return _owner;
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public virtual onlyOwner {
202         _transferOwnership(address(0));
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(
211             newOwner != address(0),
212             "Ownable: new owner is the zero address"
213         );
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Internal function without access restriction.
220      */
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Address.sol
229 
230 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
231 
232 pragma solidity ^0.8.1;
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
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(
290             address(this).balance >= amount,
291             "Address: insufficient balance"
292         );
293 
294         (bool success, ) = recipient.call{value: amount}("");
295         require(
296             success,
297             "Address: unable to send value, recipient may have reverted"
298         );
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain `call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data)
320         internal
321         returns (bytes memory)
322     {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return
357             functionCallWithValue(
358                 target,
359                 data,
360                 value,
361                 "Address: low-level call with value failed"
362             );
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(
378             address(this).balance >= value,
379             "Address: insufficient balance for call"
380         );
381         require(isContract(target), "Address: call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.call{value: value}(
384             data
385         );
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(address target, bytes memory data)
396         internal
397         view
398         returns (bytes memory)
399     {
400         return
401             functionStaticCall(
402                 target,
403                 data,
404                 "Address: low-level static call failed"
405             );
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal view returns (bytes memory) {
419         require(isContract(target), "Address: static call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data)
432         internal
433         returns (bytes memory)
434     {
435         return
436             functionDelegateCall(
437                 target,
438                 data,
439                 "Address: low-level delegate call failed"
440             );
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462      * revert reason using the provided one.
463      *
464      * _Available since v4.3._
465      */
466     function verifyCallResult(
467         bool success,
468         bytes memory returndata,
469         string memory errorMessage
470     ) internal pure returns (bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @title ERC721 token receiver interface
497  * @dev Interface for any contract that wants to support safeTransfers
498  * from ERC721 asset contracts.
499  */
500 interface IERC721Receiver {
501     /**
502      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
503      * by `operator` from `from`, this function is called.
504      *
505      * It must return its Solidity selector to confirm the token transfer.
506      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
507      *
508      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
509      */
510     function onERC721Received(
511         address operator,
512         address from,
513         uint256 tokenId,
514         bytes calldata data
515     ) external returns (bytes4);
516 }
517 
518 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Interface of the ERC165 standard, as defined in the
526  * https://eips.ethereum.org/EIPS/eip-165[EIP].
527  *
528  * Implementers can declare support of contract interfaces, which can then be
529  * queried by others ({ERC165Checker}).
530  *
531  * For an implementation, see {ERC165}.
532  */
533 interface IERC165 {
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30 000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) external view returns (bool);
543 }
544 
545 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId)
570         public
571         view
572         virtual
573         override
574         returns (bool)
575     {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(
594         address indexed from,
595         address indexed to,
596         uint256 indexed tokenId
597     );
598 
599     /**
600      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
601      */
602     event Approval(
603         address indexed owner,
604         address indexed approved,
605         uint256 indexed tokenId
606     );
607 
608     /**
609      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
610      */
611     event ApprovalForAll(
612         address indexed owner,
613         address indexed operator,
614         bool approved
615     );
616 
617     /**
618      * @dev Returns the number of tokens in ``owner``'s account.
619      */
620     function balanceOf(address owner) external view returns (uint256 balance);
621 
622     /**
623      * @dev Returns the owner of the `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function ownerOf(uint256 tokenId) external view returns (address owner);
630 
631     /**
632      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
633      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
642      *
643      * Emits a {Transfer} event.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) external;
650 
651     /**
652      * @dev Transfers `tokenId` token from `from` to `to`.
653      *
654      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      *
663      * Emits a {Transfer} event.
664      */
665     function transferFrom(
666         address from,
667         address to,
668         uint256 tokenId
669     ) external;
670 
671     /**
672      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
673      * The approval is cleared when the token is transferred.
674      *
675      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
676      *
677      * Requirements:
678      *
679      * - The caller must own the token or be an approved operator.
680      * - `tokenId` must exist.
681      *
682      * Emits an {Approval} event.
683      */
684     function approve(address to, uint256 tokenId) external;
685 
686     /**
687      * @dev Returns the account approved for `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function getApproved(uint256 tokenId)
694         external
695         view
696         returns (address operator);
697 
698     /**
699      * @dev Approve or remove `operator` as an operator for the caller.
700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
701      *
702      * Requirements:
703      *
704      * - The `operator` cannot be the caller.
705      *
706      * Emits an {ApprovalForAll} event.
707      */
708     function setApprovalForAll(address operator, bool _approved) external;
709 
710     /**
711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
712      *
713      * See {setApprovalForAll}
714      */
715     function isApprovedForAll(address owner, address operator)
716         external
717         view
718         returns (bool);
719 
720     /**
721      * @dev Safely transfers `tokenId` token from `from` to `to`.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must exist and be owned by `from`.
728      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes calldata data
738     ) external;
739 }
740 
741 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
742 
743 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 /**
748  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
749  * @dev See https://eips.ethereum.org/EIPS/eip-721
750  */
751 interface IERC721Metadata is IERC721 {
752     /**
753      * @dev Returns the token collection name.
754      */
755     function name() external view returns (string memory);
756 
757     /**
758      * @dev Returns the token collection symbol.
759      */
760     function symbol() external view returns (string memory);
761 
762     /**
763      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
764      */
765     function tokenURI(uint256 tokenId) external view returns (string memory);
766 }
767 
768 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
769 
770 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata extension, but not including the Enumerable extension, which is available separately as
777  * {ERC721Enumerable}.
778  */
779 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
780     using Address for address;
781     using Strings for uint256;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to owner address
790     mapping(uint256 => address) private _owners;
791 
792     // Mapping owner address to token count
793     mapping(address => uint256) private _balances;
794 
795     // Mapping from token ID to approved address
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     /**
802      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
803      */
804     constructor(string memory name_, string memory symbol_) {
805         _name = name_;
806         _symbol = symbol_;
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId)
813         public
814         view
815         virtual
816         override(ERC165, IERC165)
817         returns (bool)
818     {
819         return
820             interfaceId == type(IERC721).interfaceId ||
821             interfaceId == type(IERC721Metadata).interfaceId ||
822             super.supportsInterface(interfaceId);
823     }
824 
825     /**
826      * @dev See {IERC721-balanceOf}.
827      */
828     function balanceOf(address owner)
829         public
830         view
831         virtual
832         override
833         returns (uint256)
834     {
835         require(
836             owner != address(0),
837             "ERC721: balance query for the zero address"
838         );
839         return _balances[owner];
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId)
846         public
847         view
848         virtual
849         override
850         returns (address)
851     {
852         address owner = _owners[tokenId];
853         require(
854             owner != address(0),
855             "ERC721: owner query for nonexistent token"
856         );
857         return owner;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-name}.
862      */
863     function name() public view virtual override returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-symbol}.
869      */
870     function symbol() public view virtual override returns (string memory) {
871         return _symbol;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-tokenURI}.
876      */
877     function tokenURI(uint256 tokenId)
878         public
879         view
880         virtual
881         override
882         returns (string memory)
883     {
884         require(
885             _exists(tokenId),
886             "ERC721Metadata: URI query for nonexistent token"
887         );
888 
889         string memory baseURI = _baseURI();
890         return
891             bytes(baseURI).length > 0
892                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
893                 : "";
894     }
895 
896     /**
897      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
898      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
899      * by default, can be overriden in child contracts.
900      */
901     function _baseURI() internal view virtual returns (string memory) {
902         return "";
903     }
904 
905     /**
906      * @dev See {IERC721-approve}.
907      */
908     function approve(address to, uint256 tokenId) public virtual override {
909         address owner = ERC721.ownerOf(tokenId);
910         require(to != owner, "ERC721: approval to current owner");
911 
912         require(
913             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
914             "ERC721: approve caller is not owner nor approved for all"
915         );
916 
917         _approve(to, tokenId);
918     }
919 
920     /**
921      * @dev See {IERC721-getApproved}.
922      */
923     function getApproved(uint256 tokenId)
924         public
925         view
926         virtual
927         override
928         returns (address)
929     {
930         require(
931             _exists(tokenId),
932             "ERC721: approved query for nonexistent token"
933         );
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved)
942         public
943         virtual
944         override
945     {
946         _setApprovalForAll(_msgSender(), operator, approved);
947     }
948 
949     /**
950      * @dev See {IERC721-isApprovedForAll}.
951      */
952     function isApprovedForAll(address owner, address operator)
953         public
954         view
955         virtual
956         override
957         returns (bool)
958     {
959         return _operatorApprovals[owner][operator];
960     }
961 
962     /**
963      * @dev See {IERC721-transferFrom}.
964      */
965     function transferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         //solhint-disable-next-line max-line-length
971         require(
972             _isApprovedOrOwner(_msgSender(), tokenId),
973             "ERC721: transfer caller is not owner nor approved"
974         );
975 
976         _transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         safeTransferFrom(from, to, tokenId, "");
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) public virtual override {
999         require(
1000             _isApprovedOrOwner(_msgSender(), tokenId),
1001             "ERC721: transfer caller is not owner nor approved"
1002         );
1003         _safeTransfer(from, to, tokenId, _data);
1004     }
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1008      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1009      *
1010      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1011      *
1012      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1013      * implement alternative mechanisms to perform token transfer, such as signature-based.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must exist and be owned by `from`.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _safeTransfer(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) internal virtual {
1030         _transfer(from, to, tokenId);
1031         require(
1032             _checkOnERC721Received(from, to, tokenId, _data),
1033             "ERC721: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      * and stop existing when they are burned (`_burn`).
1044      */
1045     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1046         return _owners[tokenId] != address(0);
1047     }
1048 
1049     /**
1050      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must exist.
1055      */
1056     function _isApprovedOrOwner(address spender, uint256 tokenId)
1057         internal
1058         view
1059         virtual
1060         returns (bool)
1061     {
1062         require(
1063             _exists(tokenId),
1064             "ERC721: operator query for nonexistent token"
1065         );
1066         address owner = ERC721.ownerOf(tokenId);
1067         return (spender == owner ||
1068             getApproved(tokenId) == spender ||
1069             isApprovedForAll(owner, spender));
1070     }
1071 
1072     /**
1073      * @dev Safely mints `tokenId` and transfers it to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(address to, uint256 tokenId) internal virtual {
1083         _safeMint(to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1088      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) internal virtual {
1095         _mint(to, tokenId);
1096         require(
1097             _checkOnERC721Received(address(0), to, tokenId, _data),
1098             "ERC721: transfer to non ERC721Receiver implementer"
1099         );
1100     }
1101 
1102     /**
1103      * @dev Mints `tokenId` and transfers it to `to`.
1104      *
1105      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must not exist.
1110      * - `to` cannot be the zero address.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(address to, uint256 tokenId) internal virtual {
1115         require(to != address(0), "ERC721: mint to the zero address");
1116         require(!_exists(tokenId), "ERC721: token already minted");
1117 
1118         _beforeTokenTransfer(address(0), to, tokenId);
1119 
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(address(0), to, tokenId);
1124 
1125         _afterTokenTransfer(address(0), to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev Destroys `tokenId`.
1130      * The approval is cleared when the token is burned.
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must exist.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _burn(uint256 tokenId) internal virtual {
1139         address owner = ERC721.ownerOf(tokenId);
1140 
1141         _beforeTokenTransfer(owner, address(0), tokenId);
1142 
1143         // Clear approvals
1144         _approve(address(0), tokenId);
1145 
1146         _balances[owner] -= 1;
1147         delete _owners[tokenId];
1148 
1149         emit Transfer(owner, address(0), tokenId);
1150 
1151         _afterTokenTransfer(owner, address(0), tokenId);
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {
1170         require(
1171             ERC721.ownerOf(tokenId) == from,
1172             "ERC721: transfer from incorrect owner"
1173         );
1174         require(to != address(0), "ERC721: transfer to the zero address");
1175 
1176         _beforeTokenTransfer(from, to, tokenId);
1177 
1178         // Clear approvals from the previous owner
1179         _approve(address(0), tokenId);
1180 
1181         _balances[from] -= 1;
1182         _balances[to] += 1;
1183         _owners[tokenId] = to;
1184 
1185         emit Transfer(from, to, tokenId);
1186 
1187         _afterTokenTransfer(from, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev Approve `to` to operate on `tokenId`
1192      *
1193      * Emits a {Approval} event.
1194      */
1195     function _approve(address to, uint256 tokenId) internal virtual {
1196         _tokenApprovals[tokenId] = to;
1197         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev Approve `operator` to operate on all of `owner` tokens
1202      *
1203      * Emits a {ApprovalForAll} event.
1204      */
1205     function _setApprovalForAll(
1206         address owner,
1207         address operator,
1208         bool approved
1209     ) internal virtual {
1210         require(owner != operator, "ERC721: approve to caller");
1211         _operatorApprovals[owner][operator] = approved;
1212         emit ApprovalForAll(owner, operator, approved);
1213     }
1214 
1215     /**
1216      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1217      * The call is not executed if the target address is not a contract.
1218      *
1219      * @param from address representing the previous owner of the given token ID
1220      * @param to target address that will receive the tokens
1221      * @param tokenId uint256 ID of the token to be transferred
1222      * @param _data bytes optional data to send along with the call
1223      * @return bool whether the call correctly returned the expected magic value
1224      */
1225     function _checkOnERC721Received(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) private returns (bool) {
1231         if (to.isContract()) {
1232             try
1233                 IERC721Receiver(to).onERC721Received(
1234                     _msgSender(),
1235                     from,
1236                     tokenId,
1237                     _data
1238                 )
1239             returns (bytes4 retval) {
1240                 return retval == IERC721Receiver.onERC721Received.selector;
1241             } catch (bytes memory reason) {
1242                 if (reason.length == 0) {
1243                     revert(
1244                         "ERC721: transfer to non ERC721Receiver implementer"
1245                     );
1246                 } else {
1247                     assembly {
1248                         revert(add(32, reason), mload(reason))
1249                     }
1250                 }
1251             }
1252         } else {
1253             return true;
1254         }
1255     }
1256 
1257     /**
1258      * @dev Hook that is called before any token transfer. This includes minting
1259      * and burning.
1260      *
1261      * Calling conditions:
1262      *
1263      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1264      * transferred to `to`.
1265      * - When `from` is zero, `tokenId` will be minted for `to`.
1266      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1267      * - `from` and `to` are never both zero.
1268      *
1269      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1270      */
1271     function _beforeTokenTransfer(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) internal virtual {}
1276 
1277     /**
1278      * @dev Hook that is called after any transfer of tokens. This includes
1279      * minting and burning.
1280      *
1281      * Calling conditions:
1282      *
1283      * - when `from` and `to` are both non-zero.
1284      * - `from` and `to` are never both zero.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _afterTokenTransfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) internal virtual {}
1293 }
1294 
1295 // File: contracts/LowGas.sol
1296 
1297 pragma solidity >=0.7.0 <0.9.0;
1298 
1299 contract vmfer is ERC721, Ownable {
1300     using Strings for uint256;
1301     using Counters for Counters.Counter;
1302 
1303     Counters.Counter private supply;
1304 
1305     //other token nft contract
1306     address public otherTokenAddress =
1307         0xE2609354791Bf57E54B3f7F9A26b2dacBed61DA1;
1308     address public secondTokenAddress =
1309         0x79FCDEF22feeD20eDDacbB2587640e45491b757f;
1310     address public thirdTokenAddress =
1311         0xB156ADf8523FdC6152aFFdbA076a2143FD7e3c69;
1312     address public fourthTokenAddress =
1313         0x50092539A224953d82995C9D950E042dA4556283;
1314     address public fifthTokenAddress =
1315         0xdA858C5183e9024C0D5301ee85AE1e41dbe0F880;
1316 
1317     string public uriPrefix = "";
1318     string public uriSuffix = ".json";
1319     string public hiddenMetadataUri;
1320 
1321     uint256 public cost = 0.02 ether;
1322     uint256 public maxSupply = 1000;
1323     uint256 public maxMintAmountPerTx = 10;
1324     uint256 public giveawaylimit = 500;
1325     uint256 public givedAway = 0;
1326     bool public paused = false;
1327     bool public revealed = false;
1328 
1329     struct GivedAwayFree {
1330         bool claimedFree;
1331     }
1332     mapping(address => GivedAwayFree) public givedAwayFree;
1333 
1334     constructor() ERC721("vmfer", "vmfer") {
1335         setHiddenMetadataUri(
1336             "ipfs://QmQuzeQE7Videvii8KCfN8oW1uHv1GiPhdwcyYfX69kC6m/hidden.json"
1337         );
1338     }
1339 
1340     modifier mintCompliance(uint256 _mintAmount) {
1341         require(
1342             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1343             "Invalid mint amount!"
1344         );
1345         require(
1346             supply.current() + _mintAmount <= maxSupply,
1347             "Max supply exceeded!"
1348         );
1349         _;
1350     }
1351 
1352     function totalSupply() public view returns (uint256) {
1353         return supply.current();
1354     }
1355 
1356     function mint(uint256 _mintAmount)
1357         public
1358         payable
1359         mintCompliance(_mintAmount)
1360     {
1361         require(!paused, "The contract is paused!");
1362         // check if other user owns token from different contract
1363         uint256 ownedOtherToken = walletOfOwnerOfOtherContract(
1364             msg.sender,
1365             otherTokenAddress
1366         );
1367         uint256 _secondTokenAddress = walletOfOwnerOfOtherContract(
1368             msg.sender,
1369             secondTokenAddress
1370         );
1371         uint256 _thirdTokenAddress = walletOfOwnerOfOtherContract(
1372             msg.sender,
1373             thirdTokenAddress
1374         );
1375         uint256 _fourthTokenAddress = walletOfOwnerOfOtherContract(
1376             msg.sender,
1377             fourthTokenAddress
1378         );
1379         uint256 _fifthTokenAddress = walletOfOwnerOfOtherContract(
1380             msg.sender,
1381             fifthTokenAddress
1382         );
1383 
1384         //if user owns any token from different contract
1385         if (givedAway >= 500) {
1386             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1387             _mintLoop(msg.sender, _mintAmount);
1388         } else {
1389             if (
1390                 ownedOtherToken > 0 || 
1391                 _secondTokenAddress > 0 ||
1392                 _thirdTokenAddress > 0 ||
1393                 _fourthTokenAddress > 0 ||
1394                 _fifthTokenAddress > 0
1395             ) {
1396                 //check if user has already claimed free token
1397                 if (givedAwayFree[msg.sender].claimedFree == true) {
1398                     // if user has already claimed free token, then he can't mint for free, and has to pay
1399                     require(
1400                         msg.value >= cost * _mintAmount,
1401                         "Insufficient funds!"
1402                     );
1403                     _mintLoop(msg.sender, _mintAmount);
1404                 } else {
1405                     // if user has not claimed free token, then he can mint for free
1406                     _mintLoop(msg.sender, _mintAmount);
1407                     givedAwayFree[msg.sender].claimedFree = true;
1408                     givedAway++;
1409                 }
1410             } else {
1411                 // if user does not own any token from different contract, then he cannot mint for free
1412                 require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1413                 _mintLoop(msg.sender, _mintAmount);
1414             }
1415         }
1416     }
1417 
1418     function mintForAddress(uint256 _mintAmount, address _receiver)
1419         public
1420         mintCompliance(_mintAmount)
1421         onlyOwner
1422     {
1423         _mintLoop(_receiver, _mintAmount);
1424     }
1425 
1426     function walletOfOwnerOfOtherContract(
1427         address _owner,
1428         address contractAddress
1429     ) public view returns (uint256 otherTokenAmount) {
1430         uint256 ownerTokenCount = ERC721(contractAddress).balanceOf(_owner);
1431         return ownerTokenCount;
1432     }
1433 
1434     function walletOfOwner(address _owner)
1435         public
1436         view
1437         returns (uint256[] memory)
1438     {
1439         uint256 ownerTokenCount = balanceOf(_owner);
1440         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1441         uint256 currentTokenId = 1;
1442         uint256 ownedTokenIndex = 0;
1443 
1444         while (
1445             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1446         ) {
1447             address currentTokenOwner = ownerOf(currentTokenId);
1448 
1449             if (currentTokenOwner == _owner) {
1450                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1451 
1452                 ownedTokenIndex++;
1453             }
1454 
1455             currentTokenId++;
1456         }
1457 
1458         return ownedTokenIds;
1459     }
1460 
1461     function tokenURI(uint256 _tokenId)
1462         public
1463         view
1464         virtual
1465         override
1466         returns (string memory)
1467     {
1468         require(
1469             _exists(_tokenId),
1470             "ERC721Metadata: URI query for nonexistent token"
1471         );
1472 
1473         if (revealed == false) {
1474             return hiddenMetadataUri;
1475         }
1476 
1477         string memory currentBaseURI = _baseURI();
1478         return
1479             bytes(currentBaseURI).length > 0
1480                 ? string(
1481                     abi.encodePacked(
1482                         currentBaseURI,
1483                         _tokenId.toString(),
1484                         uriSuffix
1485                     )
1486                 )
1487                 : "";
1488     }
1489 
1490     function setRevealed(bool _state) public onlyOwner {
1491         revealed = _state;
1492     }
1493 
1494     function setCost(uint256 _cost) public onlyOwner {
1495         cost = _cost;
1496     }
1497 
1498     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1499         public
1500         onlyOwner
1501     {
1502         maxMintAmountPerTx = _maxMintAmountPerTx;
1503     }
1504 
1505     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1506         public
1507         onlyOwner
1508     {
1509         hiddenMetadataUri = _hiddenMetadataUri;
1510     }
1511 
1512     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1513         uriPrefix = _uriPrefix;
1514     }
1515 
1516     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1517         uriSuffix = _uriSuffix;
1518     }
1519 
1520     function setPaused(bool _state) public onlyOwner {
1521         paused = _state;
1522     }
1523 
1524     function withdraw() public onlyOwner {
1525         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1526         require(os);
1527     }
1528 
1529     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1530         for (uint256 i = 0; i < _mintAmount; i++) {
1531             supply.increment();
1532             _safeMint(_receiver, supply.current());
1533         }
1534     }
1535 
1536     function _baseURI() internal view virtual override returns (string memory) {
1537         return uriPrefix;
1538     }
1539 }