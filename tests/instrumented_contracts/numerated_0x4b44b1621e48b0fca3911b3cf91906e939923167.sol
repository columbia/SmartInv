1 // SPDX-License-Identifier: WTFPL
2 
3 // ████████████████████████████████████████████████████████████████████████████████
4 // ████████████████████████████████████████████████████████████████████████████████
5 // ███████████  █████  ████████████████████████████████████████  █████  ███████████
6 // ███████████  █████  ████████████████████████████████████████  █████  ███████████
7 // ███████████  █████  █████▀      ▀██████████████▀       █████  █████  ███████████
8 // ███████████  █████  ████   ████   ████████████   ████   ████  █████  ███████████
9 // ███████████  █████  ████   ████   ████████████   ████   ████  █████  ███████████
10 // ███████████  █████  █████   ▀▀   ▄█████████████   ▀▀   ▄████  █████  ███████████
11 // ███████████▄▄█████▄▄███████▄▄▄▄██████████████████▄▄▄▄███████▄▄█████▄▄███████████
12 // ████████████████████████████████████        ████████████████████████████████████
13 // ████████████████████████████████████████████████████████████████████████████████
14 // ████████████████████████████████████████████████████████████████████████████████
15 
16 // File: @openzeppelin/contracts/utils/Counters.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @title Counters
25  * @author Matt Condon (@shrugs)
26  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
27  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
28  *
29  * Include with `using Counters for Counters.Counter;`
30  */
31 library Counters {
32     struct Counter {
33         // This variable should never be directly accessed by users of the library: interactions must be restricted to
34         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
35         // this feature: see https://github.com/ethereum/solidity/issues/4637
36         uint256 _value; // default: 0
37     }
38 
39     function current(Counter storage counter) internal view returns (uint256) {
40         return counter._value;
41     }
42 
43     function increment(Counter storage counter) internal {
44         unchecked {
45             counter._value += 1;
46         }
47     }
48 
49     function decrement(Counter storage counter) internal {
50         uint256 value = counter._value;
51         require(value > 0, "Counter: decrement overflow");
52         unchecked {
53             counter._value = value - 1;
54         }
55     }
56 
57     function reset(Counter storage counter) internal {
58         counter._value = 0;
59     }
60 }
61 
62 // File: @openzeppelin/contracts/utils/Strings.sol
63 
64 
65 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
77      */
78     function toString(uint256 value) internal pure returns (string memory) {
79         // Inspired by OraclizeAPI's implementation - MIT licence
80         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
81 
82         if (value == 0) {
83             return "0";
84         }
85         uint256 temp = value;
86         uint256 digits;
87         while (temp != 0) {
88             digits++;
89             temp /= 10;
90         }
91         bytes memory buffer = new bytes(digits);
92         while (value != 0) {
93             digits -= 1;
94             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
95             value /= 10;
96         }
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
102      */
103     function toHexString(uint256 value) internal pure returns (string memory) {
104         if (value == 0) {
105             return "0x00";
106         }
107         uint256 temp = value;
108         uint256 length = 0;
109         while (temp != 0) {
110             length++;
111             temp >>= 8;
112         }
113         return toHexString(value, length);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
118      */
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Context.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Provides information about the current execution context, including the
141  * sender of the transaction and its data. While these are generally available
142  * via msg.sender and msg.data, they should not be accessed in such a direct
143  * manner, since when dealing with meta-transactions the account sending and
144  * paying for execution may not be the actual sender (as far as an application
145  * is concerned).
146  *
147  * This contract is only required for intermediate, library-like contracts.
148  */
149 abstract contract Context {
150     function _msgSender() internal view virtual returns (address) {
151         return msg.sender;
152     }
153 
154     function _msgData() internal view virtual returns (bytes calldata) {
155         return msg.data;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/access/Ownable.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 /**
168  * @dev Contract module which provides a basic access control mechanism, where
169  * there is an account (an owner) that can be granted exclusive access to
170  * specific functions.
171  *
172  * By default, the owner account will be the one that deploys the contract. This
173  * can later be changed with {transferOwnership}.
174  *
175  * This module is used through inheritance. It will make available the modifier
176  * `onlyOwner`, which can be applied to your functions to restrict their use to
177  * the owner.
178  */
179 abstract contract Ownable is Context {
180     address private _owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     /**
185      * @dev Initializes the contract setting the deployer as the initial owner.
186      */
187     constructor() {
188         _transferOwnership(_msgSender());
189     }
190 
191     /**
192      * @dev Returns the address of the current owner.
193      */
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     /**
199      * @dev Throws if called by any account other than the owner.
200      */
201     modifier onlyOwner() {
202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
203         _;
204     }
205 
206     /**
207      * @dev Leaves the contract without owner. It will not be possible to call
208      * `onlyOwner` functions anymore. Can only be called by the current owner.
209      *
210      * NOTE: Renouncing ownership will leave the contract without an owner,
211      * thereby removing any functionality that is only available to the owner.
212      */
213     function renounceOwnership() public virtual onlyOwner {
214         _transferOwnership(address(0));
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Can only be called by the current owner.
220      */
221     function transferOwnership(address newOwner) public virtual onlyOwner {
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223         _transferOwnership(newOwner);
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Internal function without access restriction.
229      */
230     function _transferOwnership(address newOwner) internal virtual {
231         address oldOwner = _owner;
232         _owner = newOwner;
233         emit OwnershipTransferred(oldOwner, newOwner);
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 interface IERC721Receiver {
475     /**
476      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
477      * by `operator` from `from`, this function is called.
478      *
479      * It must return its Solidity selector to confirm the token transfer.
480      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
481      *
482      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
483      */
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Interface of the ERC165 standard, as defined in the
501  * https://eips.ethereum.org/EIPS/eip-165[EIP].
502  *
503  * Implementers can declare support of contract interfaces, which can then be
504  * queried by others ({ERC165Checker}).
505  *
506  * For an implementation, see {ERC165}.
507  */
508 interface IERC165 {
509     /**
510      * @dev Returns true if this contract implements the interface defined by
511      * `interfaceId`. See the corresponding
512      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
513      * to learn more about how these ids are created.
514      *
515      * This function call must use less than 30 000 gas.
516      */
517     function supportsInterface(bytes4 interfaceId) external view returns (bool);
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
532  * for the additional interface id that will be supported. For example:
533  *
534  * ```solidity
535  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
537  * }
538  * ```
539  *
540  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
541  */
542 abstract contract ERC165 is IERC165 {
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         return interfaceId == type(IERC165).interfaceId;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
552 
553 
554 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Required interface of an ERC721 compliant contract.
561  */
562 interface IERC721 is IERC165 {
563     /**
564      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
570      */
571     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
575      */
576     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
577 
578     /**
579      * @dev Returns the number of tokens in ``owner``'s account.
580      */
581     function balanceOf(address owner) external view returns (uint256 balance);
582 
583     /**
584      * @dev Returns the owner of the `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function ownerOf(uint256 tokenId) external view returns (address owner);
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId,
609         bytes calldata data
610     ) external;
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
614      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Transfers `tokenId` token from `from` to `to`.
634      *
635      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must be owned by `from`.
642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
643      *
644      * Emits a {Transfer} event.
645      */
646     function transferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
654      * The approval is cleared when the token is transferred.
655      *
656      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
657      *
658      * Requirements:
659      *
660      * - The caller must own the token or be an approved operator.
661      * - `tokenId` must exist.
662      *
663      * Emits an {Approval} event.
664      */
665     function approve(address to, uint256 tokenId) external;
666 
667     /**
668      * @dev Approve or remove `operator` as an operator for the caller.
669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
670      *
671      * Requirements:
672      *
673      * - The `operator` cannot be the caller.
674      *
675      * Emits an {ApprovalForAll} event.
676      */
677     function setApprovalForAll(address operator, bool _approved) external;
678 
679     /**
680      * @dev Returns the account approved for `tokenId` token.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function getApproved(uint256 tokenId) external view returns (address operator);
687 
688     /**
689      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
690      *
691      * See {setApprovalForAll}
692      */
693     function isApprovedForAll(address owner, address operator) external view returns (bool);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
726 
727 
728 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 
734 
735 
736 
737 
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension, but not including the Enumerable extension, which is available separately as
742  * {ERC721Enumerable}.
743  */
744 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to owner address
755     mapping(uint256 => address) private _owners;
756 
757     // Mapping owner address to token count
758     mapping(address => uint256) private _balances;
759 
760     // Mapping from token ID to approved address
761     mapping(uint256 => address) private _tokenApprovals;
762 
763     // Mapping from owner to operator approvals
764     mapping(address => mapping(address => bool)) private _operatorApprovals;
765 
766     /**
767      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
768      */
769     constructor(string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
778         return
779             interfaceId == type(IERC721).interfaceId ||
780             interfaceId == type(IERC721Metadata).interfaceId ||
781             super.supportsInterface(interfaceId);
782     }
783 
784     /**
785      * @dev See {IERC721-balanceOf}.
786      */
787     function balanceOf(address owner) public view virtual override returns (uint256) {
788         require(owner != address(0), "ERC721: balance query for the zero address");
789         return _balances[owner];
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         address owner = _owners[tokenId];
797         require(owner != address(0), "ERC721: owner query for nonexistent token");
798         return owner;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-name}.
803      */
804     function name() public view virtual override returns (string memory) {
805         return _name;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-symbol}.
810      */
811     function symbol() public view virtual override returns (string memory) {
812         return _symbol;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-tokenURI}.
817      */
818     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
819         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
820 
821         string memory baseURI = _baseURI();
822         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
827      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
828      * by default, can be overridden in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return "";
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ERC721.ownerOf(tokenId);
839         require(to != owner, "ERC721: approval to current owner");
840 
841         require(
842             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
843             "ERC721: approve caller is not owner nor approved for all"
844         );
845 
846         _approve(to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view virtual override returns (address) {
853         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         _setApprovalForAll(_msgSender(), operator, approved);
863     }
864 
865     /**
866      * @dev See {IERC721-isApprovedForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev See {IERC721-transferFrom}.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         //solhint-disable-next-line max-line-length
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882 
883         _transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         safeTransferFrom(from, to, tokenId, "");
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) public virtual override {
906         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
907         _safeTransfer(from, to, tokenId, _data);
908     }
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
912      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
913      *
914      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
915      *
916      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
917      * implement alternative mechanisms to perform token transfer, such as signature-based.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must exist and be owned by `from`.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeTransfer(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) internal virtual {
934         _transfer(from, to, tokenId);
935         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      * and stop existing when they are burned (`_burn`).
945      */
946     function _exists(uint256 tokenId) internal view virtual returns (bool) {
947         return _owners[tokenId] != address(0);
948     }
949 
950     /**
951      * @dev Returns whether `spender` is allowed to manage `tokenId`.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must exist.
956      */
957     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
958         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
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
984         bytes memory _data
985     ) internal virtual {
986         _mint(to, tokenId);
987         require(
988             _checkOnERC721Received(address(0), to, tokenId, _data),
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
1081      * Emits a {Approval} event.
1082      */
1083     function _approve(address to, uint256 tokenId) internal virtual {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Approve `operator` to operate on all of `owner` tokens
1090      *
1091      * Emits a {ApprovalForAll} event.
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
1104      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1105      * The call is not executed if the target address is not a contract.
1106      *
1107      * @param from address representing the previous owner of the given token ID
1108      * @param to target address that will receive the tokens
1109      * @param tokenId uint256 ID of the token to be transferred
1110      * @param _data bytes optional data to send along with the call
1111      * @return bool whether the call correctly returned the expected magic value
1112      */
1113     function _checkOnERC721Received(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) private returns (bool) {
1119         if (to.isContract()) {
1120             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1121                 return retval == IERC721Receiver.onERC721Received.selector;
1122             } catch (bytes memory reason) {
1123                 if (reason.length == 0) {
1124                     revert("ERC721: transfer to non ERC721Receiver implementer");
1125                 } else {
1126                     assembly {
1127                         revert(add(32, reason), mload(reason))
1128                     }
1129                 }
1130             }
1131         } else {
1132             return true;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any token transfer. This includes minting
1138      * and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1146      * - `from` and `to` are never both zero.
1147      *
1148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1149      */
1150     function _beforeTokenTransfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after any transfer of tokens. This includes
1158      * minting and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - when `from` and `to` are both non-zero.
1163      * - `from` and `to` are never both zero.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _afterTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {}
1172 }
1173 
1174 // File: LoveDeathRobotNFT.freemint.sol
1175 
1176 // ████████████████████████████████████████████████████████████████████████████████
1177 // ████████████████████████████████████████████████████████████████████████████████
1178 // ███████████  █████  ████████████████████████████████████████  █████  ███████████
1179 // ███████████  █████  ████████████████████████████████████████  █████  ███████████
1180 // ███████████  █████  █████▀      ▀██████████████▀       █████  █████  ███████████
1181 // ███████████  █████  ████   ████   ████████████   ████   ████  █████  ███████████
1182 // ███████████  █████  ████   ████   ████████████   ████   ████  █████  ███████████
1183 // ███████████  █████  █████   ▀▀   ▄█████████████   ▀▀   ▄████  █████  ███████████
1184 // ███████████▄▄█████▄▄███████▄▄▄▄██████████████████▄▄▄▄███████▄▄█████▄▄███████████
1185 // ████████████████████████████████████        ████████████████████████████████████
1186 // ████████████████████████████████████████████████████████████████████████████████
1187 // ████████████████████████████████████████████████████████████████████████████████
1188 
1189 pragma solidity >=0.7.0 <0.9.0;
1190 
1191 contract LoveDeathRobotVol1 is ERC721, Ownable {
1192   using Strings for uint256;
1193   using Counters for Counters.Counter;
1194 
1195   Counters.Counter private supply;
1196 
1197   string public uriPrefix = "ipfs://QmezqKS4zux77EbUNz8narztU4LmzRPAoPKo56fqaJsxWJ/";
1198   string public uriSuffix = ".json";
1199   string public hiddenMetadataUri;
1200 
1201   // uint256 public cost = 0.1 ether;
1202   uint256 public maxSupply = 1000;
1203   uint256 public freeMintSupply = 100;
1204   uint256 public maxMintAmountPerTx = 5;
1205   uint256 public priceAfterFreeMint = 0.1 ether;
1206 
1207   bool public paused = true;
1208   // bool public dynamicCostEnable = true;
1209   bool public revealed = true;
1210 
1211   constructor() ERC721("Love Death Robot & AI Vol. 1", unicode"❤️DR") {
1212     // setHiddenMetadataUri("ipfs://QmezqKS4zux77EbUNz8narztU4LmzRPAoPKo56fqaJsxWJ/hidden.json");
1213   }
1214 
1215   modifier mintCompliance(uint256 _mintAmount) {
1216     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1217     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1218     _;
1219   }
1220 
1221   function totalSupply() public view returns (uint256) {
1222     return supply.current();
1223   }
1224 
1225   function getPrice() public view returns (uint256) {
1226     if (totalSupply() < freeMintSupply) {
1227       return 0 ether;
1228     } else {
1229       return priceAfterFreeMint;
1230     }
1231   }
1232 
1233   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1234     require(!paused, "The contract is paused!");
1235     require(msg.value >= getPrice() * _mintAmount, "Insufficient funds!");
1236     
1237     _mintLoop(msg.sender, _mintAmount);
1238   }
1239   
1240   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1241     _mintLoop(_receiver, _mintAmount);
1242   }
1243 
1244   function mintForOwner(uint256 _mintAmount, address _receiver) public onlyOwner {
1245     require(_mintAmount > 0, "Invalid mint amount!");
1246     _mintLoop(_receiver, _mintAmount);
1247   }
1248 
1249   function walletOfOwner(address _owner)
1250     public
1251     view
1252     returns (uint256[] memory)
1253   {
1254     uint256 ownerTokenCount = balanceOf(_owner);
1255     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1256     uint256 currentTokenId = 1;
1257     uint256 ownedTokenIndex = 0;
1258 
1259     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1260       address currentTokenOwner = ownerOf(currentTokenId);
1261 
1262       if (currentTokenOwner == _owner) {
1263         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1264 
1265         ownedTokenIndex++;
1266       }
1267 
1268       currentTokenId++;
1269     }
1270 
1271     return ownedTokenIds;
1272   }
1273 
1274   function tokenURI(uint256 _tokenId)
1275     public
1276     view
1277     virtual
1278     override
1279     returns (string memory)
1280   {
1281     require(
1282       _exists(_tokenId),
1283       "ERC721Metadata: URI query for nonexistent token"
1284     );
1285 
1286     if (revealed == false) {
1287       return hiddenMetadataUri;
1288     }
1289 
1290     string memory currentBaseURI = _baseURI();
1291     return bytes(currentBaseURI).length > 0
1292         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1293         : "";
1294   }
1295 
1296   function setRevealed(bool _state) public onlyOwner {
1297     revealed = _state;
1298   }
1299 
1300   // function setCost(uint256 _cost) public onlyOwner {
1301   //   cost = _cost;
1302   // }
1303 
1304   function setCost(uint256 _priceAfterFreeMint) public onlyOwner {
1305     priceAfterFreeMint = _priceAfterFreeMint;
1306   }
1307 
1308   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1309     maxMintAmountPerTx = _maxMintAmountPerTx;
1310   }
1311 
1312   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1313     hiddenMetadataUri = _hiddenMetadataUri;
1314   }
1315 
1316   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1317     uriPrefix = _uriPrefix;
1318   }
1319 
1320   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1321     uriSuffix = _uriSuffix;
1322   }
1323 
1324   function setPaused(bool _state) public onlyOwner {
1325     paused = _state;
1326   }
1327 
1328   function withdraw() public onlyOwner {
1329     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1330     require(os);
1331   }
1332 
1333   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1334     for (uint256 i = 0; i < _mintAmount; i++) {
1335       _safeMint(_receiver, supply.current());
1336       supply.increment();
1337     }
1338   }
1339 
1340   function _baseURI() internal view virtual override returns (string memory) {
1341     return uriPrefix;
1342   }
1343 }