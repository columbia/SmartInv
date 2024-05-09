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
51 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60     uint8 private constant _ADDRESS_LENGTH = 20;
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 
118     /**
119      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
120      */
121     function toHexString(address addr) internal pure returns (string memory) {
122         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
156 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         _checkOwner();
190         _;
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if the sender is not the owner.
202      */
203     function _checkOwner() internal view virtual {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _transferOwnership(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _transferOwnership(newOwner);
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Internal function without access restriction.
230      */
231     function _transferOwnership(address newOwner) internal virtual {
232         address oldOwner = _owner;
233         _owner = newOwner;
234         emit OwnershipTransferred(oldOwner, newOwner);
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
242 
243 pragma solidity ^0.8.1;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451                 /// @solidity memory-safe-assembly
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC721 token receiver interface
472  * @dev Interface for any contract that wants to support safeTransfers
473  * from ERC721 asset contracts.
474  */
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must exist and be owned by `from`.
601      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
603      *
604      * Emits a {Transfer} event.
605      */
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId,
610         bytes calldata data
611     ) external;
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
615      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Transfers `tokenId` token from `from` to `to`.
635      *
636      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
655      * The approval is cleared when the token is transferred.
656      *
657      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
658      *
659      * Requirements:
660      *
661      * - The caller must own the token or be an approved operator.
662      * - `tokenId` must exist.
663      *
664      * Emits an {Approval} event.
665      */
666     function approve(address to, uint256 tokenId) external;
667 
668     /**
669      * @dev Approve or remove `operator` as an operator for the caller.
670      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
671      *
672      * Requirements:
673      *
674      * - The `operator` cannot be the caller.
675      *
676      * Emits an {ApprovalForAll} event.
677      */
678     function setApprovalForAll(address operator, bool _approved) external;
679 
680     /**
681      * @dev Returns the account approved for `tokenId` token.
682      *
683      * Requirements:
684      *
685      * - `tokenId` must exist.
686      */
687     function getApproved(uint256 tokenId) external view returns (address operator);
688 
689     /**
690      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
691      *
692      * See {setApprovalForAll}
693      */
694     function isApprovedForAll(address owner, address operator) external view returns (bool);
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 
735 
736 
737 
738 
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension, but not including the Enumerable extension, which is available separately as
743  * {ERC721Enumerable}.
744  */
745 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to owner address
756     mapping(uint256 => address) private _owners;
757 
758     // Mapping owner address to token count
759     mapping(address => uint256) private _balances;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
769      */
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view virtual override returns (uint256) {
789         require(owner != address(0), "ERC721: address zero is not a valid owner");
790         return _balances[owner];
791     }
792 
793     /**
794      * @dev See {IERC721-ownerOf}.
795      */
796     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
797         address owner = _owners[tokenId];
798         require(owner != address(0), "ERC721: invalid token ID");
799         return owner;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         _requireMinted(tokenId);
821 
822         string memory baseURI = _baseURI();
823         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
828      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
829      * by default, can be overridden in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return "";
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public virtual override {
839         address owner = ERC721.ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(
843             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
844             "ERC721: approve caller is not token owner nor approved for all"
845         );
846 
847         _approve(to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         _requireMinted(tokenId);
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, "");
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory data
906     ) public virtual override {
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
908         _safeTransfer(from, to, tokenId, data);
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
914      *
915      * `data` is additional data, it has no specified format and it is sent in call to `to`.
916      *
917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
918      * implement alternative mechanisms to perform token transfer, such as signature-based.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _safeTransfer(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory data
934     ) internal virtual {
935         _transfer(from, to, tokenId);
936         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      * and stop existing when they are burned (`_burn`).
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return _owners[tokenId] != address(0);
949     }
950 
951     /**
952      * @dev Returns whether `spender` is allowed to manage `tokenId`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
959         address owner = ERC721.ownerOf(tokenId);
960         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
961     }
962 
963     /**
964      * @dev Safely mints `tokenId` and transfers it to `to`.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must not exist.
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeMint(address to, uint256 tokenId) internal virtual {
974         _safeMint(to, tokenId, "");
975     }
976 
977     /**
978      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
979      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
980      */
981     function _safeMint(
982         address to,
983         uint256 tokenId,
984         bytes memory data
985     ) internal virtual {
986         _mint(to, tokenId);
987         require(
988             _checkOnERC721Received(address(0), to, tokenId, data),
989             "ERC721: transfer to non ERC721Receiver implementer"
990         );
991     }
992 
993     /**
994      * @dev Mints `tokenId` and transfers it to `to`.
995      *
996      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - `to` cannot be the zero address.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _mint(address to, uint256 tokenId) internal virtual {
1006         require(to != address(0), "ERC721: mint to the zero address");
1007         require(!_exists(tokenId), "ERC721: token already minted");
1008 
1009         _beforeTokenTransfer(address(0), to, tokenId);
1010 
1011         _balances[to] += 1;
1012         _owners[tokenId] = to;
1013 
1014         emit Transfer(address(0), to, tokenId);
1015 
1016         _afterTokenTransfer(address(0), to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev Destroys `tokenId`.
1021      * The approval is cleared when the token is burned.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _burn(uint256 tokenId) internal virtual {
1030         address owner = ERC721.ownerOf(tokenId);
1031 
1032         _beforeTokenTransfer(owner, address(0), tokenId);
1033 
1034         // Clear approvals
1035         _approve(address(0), tokenId);
1036 
1037         _balances[owner] -= 1;
1038         delete _owners[tokenId];
1039 
1040         emit Transfer(owner, address(0), tokenId);
1041 
1042         _afterTokenTransfer(owner, address(0), tokenId);
1043     }
1044 
1045     /**
1046      * @dev Transfers `tokenId` from `from` to `to`.
1047      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1048      *
1049      * Requirements:
1050      *
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must be owned by `from`.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _transfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) internal virtual {
1061         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1062         require(to != address(0), "ERC721: transfer to the zero address");
1063 
1064         _beforeTokenTransfer(from, to, tokenId);
1065 
1066         // Clear approvals from the previous owner
1067         _approve(address(0), tokenId);
1068 
1069         _balances[from] -= 1;
1070         _balances[to] += 1;
1071         _owners[tokenId] = to;
1072 
1073         emit Transfer(from, to, tokenId);
1074 
1075         _afterTokenTransfer(from, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `to` to operate on `tokenId`
1080      *
1081      * Emits an {Approval} event.
1082      */
1083     function _approve(address to, uint256 tokenId) internal virtual {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Approve `operator` to operate on all of `owner` tokens
1090      *
1091      * Emits an {ApprovalForAll} event.
1092      */
1093     function _setApprovalForAll(
1094         address owner,
1095         address operator,
1096         bool approved
1097     ) internal virtual {
1098         require(owner != operator, "ERC721: approve to caller");
1099         _operatorApprovals[owner][operator] = approved;
1100         emit ApprovalForAll(owner, operator, approved);
1101     }
1102 
1103     /**
1104      * @dev Reverts if the `tokenId` has not been minted yet.
1105      */
1106     function _requireMinted(uint256 tokenId) internal view virtual {
1107         require(_exists(tokenId), "ERC721: invalid token ID");
1108     }
1109 
1110     /**
1111      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1112      * The call is not executed if the target address is not a contract.
1113      *
1114      * @param from address representing the previous owner of the given token ID
1115      * @param to target address that will receive the tokens
1116      * @param tokenId uint256 ID of the token to be transferred
1117      * @param data bytes optional data to send along with the call
1118      * @return bool whether the call correctly returned the expected magic value
1119      */
1120     function _checkOnERC721Received(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory data
1125     ) private returns (bool) {
1126         if (to.isContract()) {
1127             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1128                 return retval == IERC721Receiver.onERC721Received.selector;
1129             } catch (bytes memory reason) {
1130                 if (reason.length == 0) {
1131                     revert("ERC721: transfer to non ERC721Receiver implementer");
1132                 } else {
1133                     /// @solidity memory-safe-assembly
1134                     assembly {
1135                         revert(add(32, reason), mload(reason))
1136                     }
1137                 }
1138             }
1139         } else {
1140             return true;
1141         }
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before any token transfer. This includes minting
1146      * and burning.
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` will be minted for `to`.
1153      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1154      * - `from` and `to` are never both zero.
1155      *
1156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1157      */
1158     function _beforeTokenTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal virtual {}
1163 
1164     /**
1165      * @dev Hook that is called after any transfer of tokens. This includes
1166      * minting and burning.
1167      *
1168      * Calling conditions:
1169      *
1170      * - when `from` and `to` are both non-zero.
1171      * - `from` and `to` are never both zero.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _afterTokenTransfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual {}
1180 }
1181 
1182 // File: contracts/LowGas.sol
1183 
1184 
1185 
1186 // Amended by HashLips
1187 /**
1188     !Disclaimer!
1189 
1190     These contracts have been used to create tutorials,
1191     and was created for the purpose to teach people
1192     how to create smart contracts on the blockchain.
1193     please review this code on your own before using any of
1194     the following code for production.
1195     The developer will not be responsible or liable for all loss or 
1196     damage whatsoever caused by you participating in any way in the 
1197     experimental code, whether putting money into the contract or 
1198     using the code for your own project.
1199 */
1200 
1201 pragma solidity >=0.7.0 <0.9.0;
1202 
1203 
1204 
1205 
1206 contract noartonlytoken is ERC721, Ownable {
1207   using Strings for uint256;
1208   using Counters for Counters.Counter;
1209 
1210   Counters.Counter private supply;
1211 
1212   string public uriPrefix = "ipfs://noartonlytoken/";
1213   string public uriSuffix = ".json";
1214   string public hiddenMetadataUri;
1215   
1216   uint256 public cost = 0.00 ether;
1217   uint256 public maxSupply = 999;
1218   uint256 public maxMintAmountPerTx = 1;
1219 
1220   bool public paused = false;
1221   bool public revealed = true;
1222   bool public dynamicCost = true;
1223 
1224   constructor() ERC721("noartonlytoken", "noartonlytoken") {
1225     setHiddenMetadataUri("ipfs://noartonlytoken/");
1226   }
1227 
1228   modifier mintCompliance(uint256 _mintAmount) {
1229     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1230     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1231     _;
1232   }
1233 
1234   function totalSupply() public view returns (uint256) {
1235     return supply.current();
1236   }
1237 
1238   function needToUpdateCost (uint256 _supply) internal view returns (uint256 _cost){
1239       if(_supply < 666) {
1240           return 0.00 ether;
1241       }
1242       if(_supply <= maxSupply) {
1243           return 0.01 ether;
1244       }
1245 
1246   }
1247 
1248   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1249     require(!paused, "The contract is paused!");
1250     require(msg.value >= needToUpdateCost(supply.current()) * _mintAmount, "Insufficient funds!");
1251 
1252     _mintLoop(msg.sender, _mintAmount);
1253   }
1254   
1255 
1256   function walletOfOwner(address _owner)
1257     public
1258     view
1259     returns (uint256[] memory)
1260   {
1261     uint256 ownerTokenCount = balanceOf(_owner);
1262     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1263     uint256 currentTokenId = 1;
1264     uint256 ownedTokenIndex = 0;
1265 
1266     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1267       address currentTokenOwner = ownerOf(currentTokenId);
1268 
1269       if (currentTokenOwner == _owner) {
1270         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1271 
1272         ownedTokenIndex++;
1273       }
1274 
1275       currentTokenId++;
1276     }
1277 
1278     return ownedTokenIds;
1279   }
1280 
1281   function tokenURI(uint256 _tokenId)
1282     public
1283     view
1284     virtual
1285     override
1286     returns (string memory)
1287   {
1288     require(
1289       _exists(_tokenId),
1290       "ERC721Metadata: URI query for nonexistent token"
1291     );
1292 
1293     if (revealed == false) {
1294       return hiddenMetadataUri;
1295     }
1296 
1297     string memory currentBaseURI = _baseURI();
1298     return bytes(currentBaseURI).length > 0
1299         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1300         : "";
1301   }
1302 
1303   function setRevealed(bool _state) public onlyOwner {
1304     revealed = _state;
1305   }
1306 
1307   function setCost(uint256 _cost) public onlyOwner {
1308     cost = _cost;
1309   }
1310 
1311   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1312     maxMintAmountPerTx = _maxMintAmountPerTx;
1313   }
1314 
1315   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1316     hiddenMetadataUri = _hiddenMetadataUri;
1317   }
1318 
1319   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1320     uriPrefix = _uriPrefix;
1321   }
1322 
1323   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1324     uriSuffix = _uriSuffix;
1325   }
1326 
1327   function setPaused(bool _state) public onlyOwner {
1328     paused = _state;
1329   }
1330 
1331   function withdraw() public onlyOwner {
1332     // This will transfer the remaining contract balance to the owner.
1333     // Do not remove this otherwise you will not be able to withdraw the funds.
1334     // =============================================================================
1335     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1336     require(os);
1337     // =============================================================================
1338   }
1339 
1340   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1341     for (uint256 i = 0; i < _mintAmount; i++) {
1342       supply.increment();
1343       _safeMint(_receiver, supply.current());
1344     }
1345   }
1346 
1347   function _baseURI() internal view virtual override returns (string memory) {
1348     return uriPrefix;
1349   }
1350 }