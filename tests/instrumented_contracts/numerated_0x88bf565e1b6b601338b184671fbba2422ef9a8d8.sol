1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-30
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/utils/Counters.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @title Counters
20  * @author Matt Condon (@shrugs)
21  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
22  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
23  *
24  * Include with `using Counters for Counters.Counter;`
25  */
26 library Counters {
27     struct Counter {
28         // This variable should never be directly accessed by users of the library: interactions must be restricted to
29         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
30         // this feature: see https://github.com/ethereum/solidity/issues/4637
31         uint256 _value; // default: 0
32     }
33 
34     function current(Counter storage counter) internal view returns (uint256) {
35         return counter._value;
36     }
37 
38     function increment(Counter storage counter) internal {
39         unchecked {
40             counter._value += 1;
41         }
42     }
43 
44     function decrement(Counter storage counter) internal {
45         uint256 value = counter._value;
46         require(value > 0, "Counter: decrement overflow");
47         unchecked {
48             counter._value = value - 1;
49         }
50     }
51 
52     function reset(Counter storage counter) internal {
53         counter._value = 0;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/utils/Strings.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev String operations.
66  */
67 library Strings {
68     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
72      */
73     function toString(uint256 value) internal pure returns (string memory) {
74         // Inspired by OraclizeAPI's implementation - MIT licence
75         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
76 
77         if (value == 0) {
78             return "0";
79         }
80         uint256 temp = value;
81         uint256 digits;
82         while (temp != 0) {
83             digits++;
84             temp /= 10;
85         }
86         bytes memory buffer = new bytes(digits);
87         while (value != 0) {
88             digits -= 1;
89             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
90             value /= 10;
91         }
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
97      */
98     function toHexString(uint256 value) internal pure returns (string memory) {
99         if (value == 0) {
100             return "0x00";
101         }
102         uint256 temp = value;
103         uint256 length = 0;
104         while (temp != 0) {
105             length++;
106             temp >>= 8;
107         }
108         return toHexString(value, length);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
113      */
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = _HEX_SYMBOLS[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/access/Ownable.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Contract module which provides a basic access control mechanism, where
164  * there is an account (an owner) that can be granted exclusive access to
165  * specific functions.
166  *
167  * By default, the owner account will be the one that deploys the contract. This
168  * can later be changed with {transferOwnership}.
169  *
170  * This module is used through inheritance. It will make available the modifier
171  * `onlyOwner`, which can be applied to your functions to restrict their use to
172  * the owner.
173  */
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev Initializes the contract setting the deployer as the initial owner.
181      */
182     constructor() {
183         _transferOwnership(_msgSender());
184     }
185 
186     /**
187      * @dev Returns the address of the current owner.
188      */
189     function owner() public view virtual returns (address) {
190         return _owner;
191     }
192 
193     /**
194      * @dev Throws if called by any account other than the owner.
195      */
196     modifier onlyOwner() {
197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     /**
202      * @dev Leaves the contract without owner. It will not be possible to call
203      * `onlyOwner` functions anymore. Can only be called by the current owner.
204      *
205      * NOTE: Renouncing ownership will leave the contract without an owner,
206      * thereby removing any functionality that is only available to the owner.
207      */
208     function renounceOwnership() public virtual onlyOwner {
209         _transferOwnership(address(0));
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Can only be called by the current owner.
215      */
216     function transferOwnership(address newOwner) public virtual onlyOwner {
217         require(newOwner != address(0), "Ownable: new owner is the zero address");
218         _transferOwnership(newOwner);
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Internal function without access restriction.
224      */
225     function _transferOwnership(address newOwner) internal virtual {
226         address oldOwner = _owner;
227         _owner = newOwner;
228         emit OwnershipTransferred(oldOwner, newOwner);
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
236 
237 pragma solidity ^0.8.1;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      *
260      * [IMPORTANT]
261      * ====
262      * You shouldn't rely on `isContract` to protect against flash loan attacks!
263      *
264      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
265      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
266      * constructor.
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @title ERC721 token receiver interface
466  * @dev Interface for any contract that wants to support safeTransfers
467  * from ERC721 asset contracts.
468  */
469 interface IERC721Receiver {
470     /**
471      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
472      * by `operator` from `from`, this function is called.
473      *
474      * It must return its Solidity selector to confirm the token transfer.
475      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
476      *
477      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
478      */
479     function onERC721Received(
480         address operator,
481         address from,
482         uint256 tokenId,
483         bytes calldata data
484     ) external returns (bytes4);
485 }
486 
487 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @dev Interface of the ERC165 standard, as defined in the
496  * https://eips.ethereum.org/EIPS/eip-165[EIP].
497  *
498  * Implementers can declare support of contract interfaces, which can then be
499  * queried by others ({ERC165Checker}).
500  *
501  * For an implementation, see {ERC165}.
502  */
503 interface IERC165 {
504     /**
505      * @dev Returns true if this contract implements the interface defined by
506      * `interfaceId`. See the corresponding
507      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
508      * to learn more about how these ids are created.
509      *
510      * This function call must use less than 30 000 gas.
511      */
512     function supportsInterface(bytes4 interfaceId) external view returns (bool);
513 }
514 
515 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Implementation of the {IERC165} interface.
525  *
526  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
527  * for the additional interface id that will be supported. For example:
528  *
529  * ```solidity
530  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
532  * }
533  * ```
534  *
535  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
536  */
537 abstract contract ERC165 is IERC165 {
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         return interfaceId == type(IERC165).interfaceId;
543     }
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Required interface of an ERC721 compliant contract.
556  */
557 interface IERC721 is IERC165 {
558     /**
559      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
560      */
561     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
565      */
566     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
570      */
571     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
572 
573     /**
574      * @dev Returns the number of tokens in ``owner``'s account.
575      */
576     function balanceOf(address owner) external view returns (uint256 balance);
577 
578     /**
579      * @dev Returns the owner of the `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function ownerOf(uint256 tokenId) external view returns (address owner);
586 
587     /**
588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must exist and be owned by `from`.
596      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Transfers `tokenId` token from `from` to `to`.
609      *
610      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      *
619      * Emits a {Transfer} event.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) external;
626 
627     /**
628      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
629      * The approval is cleared when the token is transferred.
630      *
631      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
632      *
633      * Requirements:
634      *
635      * - The caller must own the token or be an approved operator.
636      * - `tokenId` must exist.
637      *
638      * Emits an {Approval} event.
639      */
640     function approve(address to, uint256 tokenId) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Approve or remove `operator` as an operator for the caller.
653      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
654      *
655      * Requirements:
656      *
657      * - The `operator` cannot be the caller.
658      *
659      * Emits an {ApprovalForAll} event.
660      */
661     function setApprovalForAll(address operator, bool _approved) external;
662 
663     /**
664      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
665      *
666      * See {setApprovalForAll}
667      */
668     function isApprovedForAll(address owner, address operator) external view returns (bool);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
680      *
681      * Emits a {Transfer} event.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId,
687         bytes calldata data
688     ) external;
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
692 
693 
694 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Enumerable is IERC721 {
704     /**
705      * @dev Returns the total amount of tokens stored by the contract.
706      */
707     function totalSupply() external view returns (uint256);
708 
709     /**
710      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
711      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
712      */
713     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
714 
715     /**
716      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
717      * Use along with {totalSupply} to enumerate all tokens.
718      */
719     function tokenByIndex(uint256 index) external view returns (uint256);
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Metadata is IERC721 {
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
752 
753 
754 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 
759 
760 
761 
762 
763 
764 
765 /**
766  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
767  * the Metadata extension, but not including the Enumerable extension, which is available separately as
768  * {ERC721Enumerable}.
769  */
770 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
771     using Address for address;
772     using Strings for uint256;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to owner address
781     mapping(uint256 => address) private _owners;
782 
783     // Mapping owner address to token count
784     mapping(address => uint256) private _balances;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     /**
793      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
794      */
795     constructor(string memory name_, string memory symbol_) {
796         _name = name_;
797         _symbol = symbol_;
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805             interfaceId == type(IERC721).interfaceId ||
806             interfaceId == type(IERC721Metadata).interfaceId ||
807             super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev See {IERC721-balanceOf}.
812      */
813     function balanceOf(address owner) public view virtual override returns (uint256) {
814         require(owner != address(0), "ERC721: balance query for the zero address");
815         return _balances[owner];
816     }
817 
818     /**
819      * @dev See {IERC721-ownerOf}.
820      */
821     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
822         address owner = _owners[tokenId];
823         require(owner != address(0), "ERC721: owner query for nonexistent token");
824         return owner;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
845         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
846 
847         string memory baseURI = _baseURI();
848         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return "";
858     }
859 
860     /**
861      * @dev See {IERC721-approve}.
862      */
863     function approve(address to, uint256 tokenId) public virtual override {
864         address owner = ERC721.ownerOf(tokenId);
865         require(to != owner, "ERC721: approval to current owner");
866 
867         require(
868             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
869             "ERC721: approve caller is not owner nor approved for all"
870         );
871 
872         _approve(to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId) public view virtual override returns (address) {
879         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved) public virtual override {
888         _setApprovalForAll(_msgSender(), operator, approved);
889     }
890 
891     /**
892      * @dev See {IERC721-isApprovedForAll}.
893      */
894     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
895         return _operatorApprovals[owner][operator];
896     }
897 
898     /**
899      * @dev See {IERC721-transferFrom}.
900      */
901     function transferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         //solhint-disable-next-line max-line-length
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908 
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, "");
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
933         _safeTransfer(from, to, tokenId, _data);
934     }
935 
936     /**
937      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
938      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
939      *
940      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
941      *
942      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
943      * implement alternative mechanisms to perform token transfer, such as signature-based.
944      *
945      * Requirements:
946      *
947      * - `from` cannot be the zero address.
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must exist and be owned by `from`.
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeTransfer(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) internal virtual {
960         _transfer(from, to, tokenId);
961         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
962     }
963 
964     /**
965      * @dev Returns whether `tokenId` exists.
966      *
967      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
968      *
969      * Tokens start existing when they are minted (`_mint`),
970      * and stop existing when they are burned (`_burn`).
971      */
972     function _exists(uint256 tokenId) internal view virtual returns (bool) {
973         return _owners[tokenId] != address(0);
974     }
975 
976     /**
977      * @dev Returns whether `spender` is allowed to manage `tokenId`.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      */
983     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
984         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
985         address owner = ERC721.ownerOf(tokenId);
986         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
987     }
988 
989     /**
990      * @dev Safely mints `tokenId` and transfers it to `to`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must not exist.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(address to, uint256 tokenId) internal virtual {
1000         _safeMint(to, tokenId, "");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) internal virtual {
1012         _mint(to, tokenId);
1013         require(
1014             _checkOnERC721Received(address(0), to, tokenId, _data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Mints `tokenId` and transfers it to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - `to` cannot be the zero address.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 tokenId) internal virtual {
1032         require(to != address(0), "ERC721: mint to the zero address");
1033         require(!_exists(tokenId), "ERC721: token already minted");
1034 
1035         _beforeTokenTransfer(address(0), to, tokenId);
1036 
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(address(0), to, tokenId);
1041 
1042         _afterTokenTransfer(address(0), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Destroys `tokenId`.
1047      * The approval is cleared when the token is burned.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _burn(uint256 tokenId) internal virtual {
1056         address owner = ERC721.ownerOf(tokenId);
1057 
1058         _beforeTokenTransfer(owner, address(0), tokenId);
1059 
1060         // Clear approvals
1061         _approve(address(0), tokenId);
1062 
1063         _balances[owner] -= 1;
1064         delete _owners[tokenId];
1065 
1066         emit Transfer(owner, address(0), tokenId);
1067 
1068         _afterTokenTransfer(owner, address(0), tokenId);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {
1087         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1088         require(to != address(0), "ERC721: transfer to the zero address");
1089 
1090         _beforeTokenTransfer(from, to, tokenId);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId);
1094 
1095         _balances[from] -= 1;
1096         _balances[to] += 1;
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(from, to, tokenId);
1100 
1101         _afterTokenTransfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits a {Approval} event.
1108      */
1109     function _approve(address to, uint256 tokenId) internal virtual {
1110         _tokenApprovals[tokenId] = to;
1111         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Approve `operator` to operate on all of `owner` tokens
1116      *
1117      * Emits a {ApprovalForAll} event.
1118      */
1119     function _setApprovalForAll(
1120         address owner,
1121         address operator,
1122         bool approved
1123     ) internal virtual {
1124         require(owner != operator, "ERC721: approve to caller");
1125         _operatorApprovals[owner][operator] = approved;
1126         emit ApprovalForAll(owner, operator, approved);
1127     }
1128 
1129     /**
1130      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1131      * The call is not executed if the target address is not a contract.
1132      *
1133      * @param from address representing the previous owner of the given token ID
1134      * @param to target address that will receive the tokens
1135      * @param tokenId uint256 ID of the token to be transferred
1136      * @param _data bytes optional data to send along with the call
1137      * @return bool whether the call correctly returned the expected magic value
1138      */
1139     function _checkOnERC721Received(
1140         address from,
1141         address to,
1142         uint256 tokenId,
1143         bytes memory _data
1144     ) private returns (bool) {
1145         if (to.isContract()) {
1146             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1147                 return retval == IERC721Receiver.onERC721Received.selector;
1148             } catch (bytes memory reason) {
1149                 if (reason.length == 0) {
1150                     revert("ERC721: transfer to non ERC721Receiver implementer");
1151                 } else {
1152                     assembly {
1153                         revert(add(32, reason), mload(reason))
1154                     }
1155                 }
1156             }
1157         } else {
1158             return true;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Hook that is called before any token transfer. This includes minting
1164      * and burning.
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1172      * - `from` and `to` are never both zero.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _beforeTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual {}
1181 
1182     /**
1183      * @dev Hook that is called after any transfer of tokens. This includes
1184      * minting and burning.
1185      *
1186      * Calling conditions:
1187      *
1188      * - when `from` and `to` are both non-zero.
1189      * - `from` and `to` are never both zero.
1190      *
1191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1192      */
1193     function _afterTokenTransfer(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) internal virtual {}
1198 }
1199 
1200 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1201 
1202 
1203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1204 
1205 pragma solidity ^0.8.0;
1206 
1207 
1208 
1209 /**
1210  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1211  * enumerability of all the token ids in the contract as well as all token ids owned by each
1212  * account.
1213  */
1214 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1215     // Mapping from owner to list of owned token IDs
1216     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1217 
1218     // Mapping from token ID to index of the owner tokens list
1219     mapping(uint256 => uint256) private _ownedTokensIndex;
1220 
1221     // Array with all token ids, used for enumeration
1222     uint256[] private _allTokens;
1223 
1224     // Mapping from token id to position in the allTokens array
1225     mapping(uint256 => uint256) private _allTokensIndex;
1226 
1227     /**
1228      * @dev See {IERC165-supportsInterface}.
1229      */
1230     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1231         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1236      */
1237     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1238         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1239         return _ownedTokens[owner][index];
1240     }
1241 
1242     /**
1243      * @dev See {IERC721Enumerable-totalSupply}.
1244      */
1245     function totalSupply() public view virtual override returns (uint256) {
1246         return _allTokens.length;
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Enumerable-tokenByIndex}.
1251      */
1252     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1253         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1254         return _allTokens[index];
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
1267      * - `from` cannot be the zero address.
1268      * - `to` cannot be the zero address.
1269      *
1270      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1271      */
1272     function _beforeTokenTransfer(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) internal virtual override {
1277         super._beforeTokenTransfer(from, to, tokenId);
1278 
1279         if (from == address(0)) {
1280             _addTokenToAllTokensEnumeration(tokenId);
1281         } else if (from != to) {
1282             _removeTokenFromOwnerEnumeration(from, tokenId);
1283         }
1284         if (to == address(0)) {
1285             _removeTokenFromAllTokensEnumeration(tokenId);
1286         } else if (to != from) {
1287             _addTokenToOwnerEnumeration(to, tokenId);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1293      * @param to address representing the new owner of the given token ID
1294      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1295      */
1296     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1297         uint256 length = ERC721.balanceOf(to);
1298         _ownedTokens[to][length] = tokenId;
1299         _ownedTokensIndex[tokenId] = length;
1300     }
1301 
1302     /**
1303      * @dev Private function to add a token to this extension's token tracking data structures.
1304      * @param tokenId uint256 ID of the token to be added to the tokens list
1305      */
1306     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1307         _allTokensIndex[tokenId] = _allTokens.length;
1308         _allTokens.push(tokenId);
1309     }
1310 
1311     /**
1312      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1313      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1314      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1315      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1316      * @param from address representing the previous owner of the given token ID
1317      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1318      */
1319     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1320         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1321         // then delete the last slot (swap and pop).
1322 
1323         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1324         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1325 
1326         // When the token to delete is the last token, the swap operation is unnecessary
1327         if (tokenIndex != lastTokenIndex) {
1328             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1329 
1330             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1331             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1332         }
1333 
1334         // This also deletes the contents at the last position of the array
1335         delete _ownedTokensIndex[tokenId];
1336         delete _ownedTokens[from][lastTokenIndex];
1337     }
1338 
1339     /**
1340      * @dev Private function to remove a token from this extension's token tracking data structures.
1341      * This has O(1) time complexity, but alters the order of the _allTokens array.
1342      * @param tokenId uint256 ID of the token to be removed from the tokens list
1343      */
1344     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1345         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1346         // then delete the last slot (swap and pop).
1347 
1348         uint256 lastTokenIndex = _allTokens.length - 1;
1349         uint256 tokenIndex = _allTokensIndex[tokenId];
1350 
1351         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1352         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1353         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1354         uint256 lastTokenId = _allTokens[lastTokenIndex];
1355 
1356         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1357         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1358 
1359         // This also deletes the contents at the last position of the array
1360         delete _allTokensIndex[tokenId];
1361         _allTokens.pop();
1362     }
1363 }
1364 
1365 // File: erc721a/contracts/ERC721A.sol
1366 
1367 
1368 // Creator: Chiru Labs
1369 
1370 pragma solidity ^0.8.4;
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 error ApprovalCallerNotOwnerNorApproved();
1380 error ApprovalQueryForNonexistentToken();
1381 error ApproveToCaller();
1382 error ApprovalToCurrentOwner();
1383 error BalanceQueryForZeroAddress();
1384 error MintToZeroAddress();
1385 error MintZeroQuantity();
1386 error OwnerQueryForNonexistentToken();
1387 error TransferCallerNotOwnerNorApproved();
1388 error TransferFromIncorrectOwner();
1389 error TransferToNonERC721ReceiverImplementer();
1390 error TransferToZeroAddress();
1391 error URIQueryForNonexistentToken();
1392 
1393 /**
1394  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1395  * the Metadata extension. Built to optimize for lower gas during batch mints.
1396  *
1397  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1398  *
1399  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1400  *
1401  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1402  */
1403 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1404     using Address for address;
1405     using Strings for uint256;
1406 
1407     // Compiler will pack this into a single 256bit word.
1408     struct TokenOwnership {
1409         // The address of the owner.
1410         address addr;
1411         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1412         uint64 startTimestamp;
1413         // Whether the token has been burned.
1414         bool burned;
1415     }
1416 
1417     // Compiler will pack this into a single 256bit word.
1418     struct AddressData {
1419         // Realistically, 2**64-1 is more than enough.
1420         uint64 balance;
1421         // Keeps track of mint count with minimal overhead for tokenomics.
1422         uint64 numberMinted;
1423         // Keeps track of burn count with minimal overhead for tokenomics.
1424         uint64 numberBurned;
1425         // For miscellaneous variable(s) pertaining to the address
1426         // (e.g. number of whitelist mint slots used).
1427         // If there are multiple variables, please pack them into a uint64.
1428         uint64 aux;
1429     }
1430 
1431     // The tokenId of the next token to be minted.
1432     uint256 internal _currentIndex;
1433 
1434     // The number of tokens burned.
1435     uint256 internal _burnCounter;
1436 
1437     // Token name
1438     string private _name;
1439 
1440     // Token symbol
1441     string private _symbol;
1442 
1443     // Mapping from token ID to ownership details
1444     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1445     mapping(uint256 => TokenOwnership) internal _ownerships;
1446 
1447     // Mapping owner address to address data
1448     mapping(address => AddressData) private _addressData;
1449 
1450     // Mapping from token ID to approved address
1451     mapping(uint256 => address) private _tokenApprovals;
1452 
1453     // Mapping from owner to operator approvals
1454     mapping(address => mapping(address => bool)) private _operatorApprovals;
1455 
1456     constructor(string memory name_, string memory symbol_) {
1457         _name = name_;
1458         _symbol = symbol_;
1459         _currentIndex = _startTokenId();
1460     }
1461 
1462     /**
1463      * To change the starting tokenId, please override this function.
1464      */
1465     function _startTokenId() internal view virtual returns (uint256) {
1466         return 0;
1467     }
1468 
1469     /**
1470      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1471      */
1472     function totalSupply() public view returns (uint256) {
1473         // Counter underflow is impossible as _burnCounter cannot be incremented
1474         // more than _currentIndex - _startTokenId() times
1475         unchecked {
1476             return _currentIndex - _burnCounter - _startTokenId();
1477         }
1478     }
1479 
1480     /**
1481      * Returns the total amount of tokens minted in the contract.
1482      */
1483     function _totalMinted() internal view returns (uint256) {
1484         // Counter underflow is impossible as _currentIndex does not decrement,
1485         // and it is initialized to _startTokenId()
1486         unchecked {
1487             return _currentIndex - _startTokenId();
1488         }
1489     }
1490 
1491     /**
1492      * @dev See {IERC165-supportsInterface}.
1493      */
1494     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1495         return
1496             interfaceId == type(IERC721).interfaceId ||
1497             interfaceId == type(IERC721Metadata).interfaceId ||
1498             super.supportsInterface(interfaceId);
1499     }
1500 
1501     /**
1502      * @dev See {IERC721-balanceOf}.
1503      */
1504     function balanceOf(address owner) public view override returns (uint256) {
1505         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1506         return uint256(_addressData[owner].balance);
1507     }
1508 
1509     /**
1510      * Returns the number of tokens minted by `owner`.
1511      */
1512     function _numberMinted(address owner) internal view returns (uint256) {
1513         return uint256(_addressData[owner].numberMinted);
1514     }
1515 
1516     /**
1517      * Returns the number of tokens burned by or on behalf of `owner`.
1518      */
1519     function _numberBurned(address owner) internal view returns (uint256) {
1520         return uint256(_addressData[owner].numberBurned);
1521     }
1522 
1523     /**
1524      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1525      */
1526     function _getAux(address owner) internal view returns (uint64) {
1527         return _addressData[owner].aux;
1528     }
1529 
1530     /**
1531      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1532      * If there are multiple variables, please pack them into a uint64.
1533      */
1534     function _setAux(address owner, uint64 aux) internal {
1535         _addressData[owner].aux = aux;
1536     }
1537 
1538     /**
1539      * Gas spent here starts off proportional to the maximum mint batch size.
1540      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1541      */
1542     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1543         uint256 curr = tokenId;
1544 
1545         unchecked {
1546             if (_startTokenId() <= curr && curr < _currentIndex) {
1547                 TokenOwnership memory ownership = _ownerships[curr];
1548                 if (!ownership.burned) {
1549                     if (ownership.addr != address(0)) {
1550                         return ownership;
1551                     }
1552                     // Invariant:
1553                     // There will always be an ownership that has an address and is not burned
1554                     // before an ownership that does not have an address and is not burned.
1555                     // Hence, curr will not underflow.
1556                     while (true) {
1557                         curr--;
1558                         ownership = _ownerships[curr];
1559                         if (ownership.addr != address(0)) {
1560                             return ownership;
1561                         }
1562                     }
1563                 }
1564             }
1565         }
1566         revert OwnerQueryForNonexistentToken();
1567     }
1568 
1569     /**
1570      * @dev See {IERC721-ownerOf}.
1571      */
1572     function ownerOf(uint256 tokenId) public view override returns (address) {
1573         return _ownershipOf(tokenId).addr;
1574     }
1575 
1576     /**
1577      * @dev See {IERC721Metadata-name}.
1578      */
1579     function name() public view virtual override returns (string memory) {
1580         return _name;
1581     }
1582 
1583     /**
1584      * @dev See {IERC721Metadata-symbol}.
1585      */
1586     function symbol() public view virtual override returns (string memory) {
1587         return _symbol;
1588     }
1589 
1590     /**
1591      * @dev See {IERC721Metadata-tokenURI}.
1592      */
1593     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1594         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1595 
1596         string memory baseURI = _baseURI();
1597         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1598     }
1599 
1600     /**
1601      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1602      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1603      * by default, can be overriden in child contracts.
1604      */
1605     function _baseURI() internal view virtual returns (string memory) {
1606         return '';
1607     }
1608 
1609     /**
1610      * @dev See {IERC721-approve}.
1611      */
1612     function approve(address to, uint256 tokenId) public override {
1613         address owner = ERC721A.ownerOf(tokenId);
1614         if (to == owner) revert ApprovalToCurrentOwner();
1615 
1616         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1617             revert ApprovalCallerNotOwnerNorApproved();
1618         }
1619 
1620         _approve(to, tokenId, owner);
1621     }
1622 
1623     /**
1624      * @dev See {IERC721-getApproved}.
1625      */
1626     function getApproved(uint256 tokenId) public view override returns (address) {
1627         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1628 
1629         return _tokenApprovals[tokenId];
1630     }
1631 
1632     /**
1633      * @dev See {IERC721-setApprovalForAll}.
1634      */
1635     function setApprovalForAll(address operator, bool approved) public virtual override {
1636         if (operator == _msgSender()) revert ApproveToCaller();
1637 
1638         _operatorApprovals[_msgSender()][operator] = approved;
1639         emit ApprovalForAll(_msgSender(), operator, approved);
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-isApprovedForAll}.
1644      */
1645     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1646         return _operatorApprovals[owner][operator];
1647     }
1648 
1649     /**
1650      * @dev See {IERC721-transferFrom}.
1651      */
1652     function transferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) public virtual override {
1657         _transfer(from, to, tokenId);
1658     }
1659 
1660     /**
1661      * @dev See {IERC721-safeTransferFrom}.
1662      */
1663     function safeTransferFrom(
1664         address from,
1665         address to,
1666         uint256 tokenId
1667     ) public virtual override {
1668         safeTransferFrom(from, to, tokenId, '');
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-safeTransferFrom}.
1673      */
1674     function safeTransferFrom(
1675         address from,
1676         address to,
1677         uint256 tokenId,
1678         bytes memory _data
1679     ) public virtual override {
1680         _transfer(from, to, tokenId);
1681         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1682             revert TransferToNonERC721ReceiverImplementer();
1683         }
1684     }
1685 
1686     /**
1687      * @dev Returns whether `tokenId` exists.
1688      *
1689      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1690      *
1691      * Tokens start existing when they are minted (`_mint`),
1692      */
1693     function _exists(uint256 tokenId) internal view returns (bool) {
1694         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1695     }
1696 
1697     function _safeMint(address to, uint256 quantity) internal {
1698         _safeMint(to, quantity, '');
1699     }
1700 
1701     /**
1702      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1703      *
1704      * Requirements:
1705      *
1706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1707      * - `quantity` must be greater than 0.
1708      *
1709      * Emits a {Transfer} event.
1710      */
1711     function _safeMint(
1712         address to,
1713         uint256 quantity,
1714         bytes memory _data
1715     ) internal {
1716         _mint(to, quantity, _data, true);
1717     }
1718 
1719     /**
1720      * @dev Mints `quantity` tokens and transfers them to `to`.
1721      *
1722      * Requirements:
1723      *
1724      * - `to` cannot be the zero address.
1725      * - `quantity` must be greater than 0.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _mint(
1730         address to,
1731         uint256 quantity,
1732         bytes memory _data,
1733         bool safe
1734     ) internal {
1735         uint256 startTokenId = _currentIndex;
1736         if (to == address(0)) revert MintToZeroAddress();
1737         if (quantity == 0) revert MintZeroQuantity();
1738 
1739         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1740 
1741         // Overflows are incredibly unrealistic.
1742         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1743         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1744         unchecked {
1745             _addressData[to].balance += uint64(quantity);
1746             _addressData[to].numberMinted += uint64(quantity);
1747 
1748             _ownerships[startTokenId].addr = to;
1749             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1750 
1751             uint256 updatedIndex = startTokenId;
1752             uint256 end = updatedIndex + quantity;
1753 
1754             if (safe && to.isContract()) {
1755                 do {
1756                     emit Transfer(address(0), to, updatedIndex);
1757                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1758                         revert TransferToNonERC721ReceiverImplementer();
1759                     }
1760                 } while (updatedIndex != end);
1761                 // Reentrancy protection
1762                 if (_currentIndex != startTokenId) revert();
1763             } else {
1764                 do {
1765                     emit Transfer(address(0), to, updatedIndex++);
1766                 } while (updatedIndex != end);
1767             }
1768             _currentIndex = updatedIndex;
1769         }
1770         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1771     }
1772 
1773     /**
1774      * @dev Transfers `tokenId` from `from` to `to`.
1775      *
1776      * Requirements:
1777      *
1778      * - `to` cannot be the zero address.
1779      * - `tokenId` token must be owned by `from`.
1780      *
1781      * Emits a {Transfer} event.
1782      */
1783     function _transfer(
1784         address from,
1785         address to,
1786         uint256 tokenId
1787     ) private {
1788         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1789 
1790         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1791 
1792         bool isApprovedOrOwner = (_msgSender() == from ||
1793             isApprovedForAll(from, _msgSender()) ||
1794             getApproved(tokenId) == _msgSender());
1795 
1796         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1797         if (to == address(0)) revert TransferToZeroAddress();
1798 
1799         _beforeTokenTransfers(from, to, tokenId, 1);
1800 
1801         // Clear approvals from the previous owner
1802         _approve(address(0), tokenId, from);
1803 
1804         // Underflow of the sender's balance is impossible because we check for
1805         // ownership above and the recipient's balance can't realistically overflow.
1806         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1807         unchecked {
1808             _addressData[from].balance -= 1;
1809             _addressData[to].balance += 1;
1810 
1811             TokenOwnership storage currSlot = _ownerships[tokenId];
1812             currSlot.addr = to;
1813             currSlot.startTimestamp = uint64(block.timestamp);
1814 
1815             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1816             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1817             uint256 nextTokenId = tokenId + 1;
1818             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1819             if (nextSlot.addr == address(0)) {
1820                 // This will suffice for checking _exists(nextTokenId),
1821                 // as a burned slot cannot contain the zero address.
1822                 if (nextTokenId != _currentIndex) {
1823                     nextSlot.addr = from;
1824                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1825                 }
1826             }
1827         }
1828 
1829         emit Transfer(from, to, tokenId);
1830         _afterTokenTransfers(from, to, tokenId, 1);
1831     }
1832 
1833     /**
1834      * @dev This is equivalent to _burn(tokenId, false)
1835      */
1836     function _burn(uint256 tokenId) internal virtual {
1837         _burn(tokenId, false);
1838     }
1839 
1840     /**
1841      * @dev Destroys `tokenId`.
1842      * The approval is cleared when the token is burned.
1843      *
1844      * Requirements:
1845      *
1846      * - `tokenId` must exist.
1847      *
1848      * Emits a {Transfer} event.
1849      */
1850     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1851         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1852 
1853         address from = prevOwnership.addr;
1854 
1855         if (approvalCheck) {
1856             bool isApprovedOrOwner = (_msgSender() == from ||
1857                 isApprovedForAll(from, _msgSender()) ||
1858                 getApproved(tokenId) == _msgSender());
1859 
1860             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1861         }
1862 
1863         _beforeTokenTransfers(from, address(0), tokenId, 1);
1864 
1865         // Clear approvals from the previous owner
1866         _approve(address(0), tokenId, from);
1867 
1868         // Underflow of the sender's balance is impossible because we check for
1869         // ownership above and the recipient's balance can't realistically overflow.
1870         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1871         unchecked {
1872             AddressData storage addressData = _addressData[from];
1873             addressData.balance -= 1;
1874             addressData.numberBurned += 1;
1875 
1876             // Keep track of who burned the token, and the timestamp of burning.
1877             TokenOwnership storage currSlot = _ownerships[tokenId];
1878             currSlot.addr = from;
1879             currSlot.startTimestamp = uint64(block.timestamp);
1880             currSlot.burned = true;
1881 
1882             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1883             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1884             uint256 nextTokenId = tokenId + 1;
1885             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1886             if (nextSlot.addr == address(0)) {
1887                 // This will suffice for checking _exists(nextTokenId),
1888                 // as a burned slot cannot contain the zero address.
1889                 if (nextTokenId != _currentIndex) {
1890                     nextSlot.addr = from;
1891                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1892                 }
1893             }
1894         }
1895 
1896         emit Transfer(from, address(0), tokenId);
1897         _afterTokenTransfers(from, address(0), tokenId, 1);
1898 
1899         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1900         unchecked {
1901             _burnCounter++;
1902         }
1903     }
1904 
1905     /**
1906      * @dev Approve `to` to operate on `tokenId`
1907      *
1908      * Emits a {Approval} event.
1909      */
1910     function _approve(
1911         address to,
1912         uint256 tokenId,
1913         address owner
1914     ) private {
1915         _tokenApprovals[tokenId] = to;
1916         emit Approval(owner, to, tokenId);
1917     }
1918 
1919     /**
1920      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1921      *
1922      * @param from address representing the previous owner of the given token ID
1923      * @param to target address that will receive the tokens
1924      * @param tokenId uint256 ID of the token to be transferred
1925      * @param _data bytes optional data to send along with the call
1926      * @return bool whether the call correctly returned the expected magic value
1927      */
1928     function _checkContractOnERC721Received(
1929         address from,
1930         address to,
1931         uint256 tokenId,
1932         bytes memory _data
1933     ) private returns (bool) {
1934         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1935             return retval == IERC721Receiver(to).onERC721Received.selector;
1936         } catch (bytes memory reason) {
1937             if (reason.length == 0) {
1938                 revert TransferToNonERC721ReceiverImplementer();
1939             } else {
1940                 assembly {
1941                     revert(add(32, reason), mload(reason))
1942                 }
1943             }
1944         }
1945     }
1946 
1947     /**
1948      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1949      * And also called before burning one token.
1950      *
1951      * startTokenId - the first token id to be transferred
1952      * quantity - the amount to be transferred
1953      *
1954      * Calling conditions:
1955      *
1956      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1957      * transferred to `to`.
1958      * - When `from` is zero, `tokenId` will be minted for `to`.
1959      * - When `to` is zero, `tokenId` will be burned by `from`.
1960      * - `from` and `to` are never both zero.
1961      */
1962     function _beforeTokenTransfers(
1963         address from,
1964         address to,
1965         uint256 startTokenId,
1966         uint256 quantity
1967     ) internal virtual {}
1968 
1969     /**
1970      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1971      * minting.
1972      * And also called after one token has been burned.
1973      *
1974      * startTokenId - the first token id to be transferred
1975      * quantity - the amount to be transferred
1976      *
1977      * Calling conditions:
1978      *
1979      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1980      * transferred to `to`.
1981      * - When `from` is zero, `tokenId` has been minted for `to`.
1982      * - When `to` is zero, `tokenId` has been burned by `from`.
1983      * - `from` and `to` are never both zero.
1984      */
1985     function _afterTokenTransfers(
1986         address from,
1987         address to,
1988         uint256 startTokenId,
1989         uint256 quantity
1990     ) internal virtual {}
1991 }
1992 
1993 // File: contracts/GOBLIN.sol
1994 
1995 
1996 pragma solidity ^0.8.4;
1997 
1998 
1999 
2000 
2001 
2002 
2003 contract GoblinPaperhandsTown is ERC721A, Ownable {
2004     using Strings for uint256;
2005 
2006     string private baseURI;
2007 
2008     uint256 public price = 0.005 ether;
2009 
2010     uint256 public maxPerTx = 5;
2011 
2012     uint256 public maxPerWallet = 20;
2013 
2014     uint256 public totalFree = 1000;
2015 
2016     uint256 public maxSupply = 5555;
2017 
2018     bool public mintEnabled = false;
2019 
2020     mapping(address => uint256) private _mintedAmount;
2021 
2022     constructor() ERC721A("Goblin Paperhands Town", "GPHT") {
2023         setBaseURI("ipfs://QmcD77jQcTxTU5nwVehDQAcbYQAmuEXZGcuo6L89z3nXxL/metadata2/");
2024     }
2025 
2026     function mint(uint256 count) external payable {
2027       uint256 cost = price;
2028       bool isFree =
2029       ((totalSupply() + count < totalFree + 1) &&
2030       (_mintedAmount[msg.sender] + count <= maxPerWallet) &&
2031       (count <= maxPerTx));
2032 
2033       if (isFree) {
2034       cost = 0;
2035      }
2036 
2037      else {
2038       require(msg.value >= count * price, "Please send the exact amount.");
2039       require(totalSupply() + count <= maxSupply, "No more Goblins");
2040       require(mintEnabled, "Minting is not live yet");
2041       require(count <= maxPerTx, "Max per TX reached.");
2042       require(_mintedAmount[msg.sender] + count <= maxPerWallet, "Max per wallet reached.");
2043      }
2044 
2045       if (isFree) {
2046          _mintedAmount[msg.sender] += count;
2047       }
2048 
2049      _safeMint(msg.sender, count);
2050     }
2051 
2052     function _baseURI() internal view virtual override returns (string memory) {
2053         return baseURI;
2054     }
2055 
2056     function tokenURI(uint256 tokenId)
2057         public
2058         view
2059         virtual
2060         override
2061         returns (string memory)
2062     {
2063         require(
2064             _exists(tokenId),
2065             "ERC721Metadata: URI query for nonexistent token"
2066         );
2067     
2068         return string(abi.encodePacked(baseURI, tokenId.toString()));
2069     }
2070 
2071     function setBaseURI(string memory uri) public onlyOwner {
2072         baseURI = uri;
2073     }
2074 
2075     function setFreeAmount(uint256 amount) external onlyOwner {
2076         totalFree = amount;
2077     }
2078 
2079     function setPrice(uint256 _newPrice) external onlyOwner {
2080         price = _newPrice;
2081     }
2082 
2083     function flipSale() external onlyOwner {
2084         mintEnabled = !mintEnabled;
2085     }
2086 
2087     function _startTokenId() internal pure override returns (uint256) {
2088         return 0;
2089     }
2090 
2091     function withdraw() external onlyOwner {
2092         (bool success, ) = payable(msg.sender).call{
2093             value: address(this).balance
2094         }("");
2095         require(success, "Transfer failed.");
2096     }
2097 }