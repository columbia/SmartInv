1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
2 
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
47 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59     uint8 private constant _ADDRESS_LENGTH = 20;
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
116 
117     /**
118      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
119      */
120     function toHexString(address addr) internal pure returns (string memory) {
121         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
122     }
123 }
124 
125 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 /**
161  * @dev Contract module which provides a basic access control mechanism, where
162  * there is an account (an owner) that can be granted exclusive access to
163  * specific functions.
164  *
165  * By default, the owner account will be the one that deploys the contract. This
166  * can later be changed with {transferOwnership}.
167  *
168  * This module is used through inheritance. It will make available the modifier
169  * `onlyOwner`, which can be applied to your functions to restrict their use to
170  * the owner.
171  */
172 abstract contract Ownable is Context {
173     address private _owner;
174 
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     /**
178      * @dev Initializes the contract setting the deployer as the initial owner.
179      */
180     constructor() {
181         _transferOwnership(_msgSender());
182     }
183 
184     /**
185      * @dev Returns the address of the current owner.
186      */
187     function owner() public view virtual returns (address) {
188         return _owner;
189     }
190 
191     /**
192      * @dev Throws if called by any account other than the owner.
193      */
194     modifier onlyOwner() {
195         require(owner() == _msgSender(), "Ownable: caller is not the owner");
196         _;
197     }
198 
199     /**
200      * @dev Leaves the contract without owner. It will not be possible to call
201      * `onlyOwner` functions anymore. Can only be called by the current owner.
202      *
203      * NOTE: Renouncing ownership will leave the contract without an owner,
204      * thereby removing any functionality that is only available to the owner.
205      */
206     function renounceOwnership() public virtual onlyOwner {
207         _transferOwnership(address(0));
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Can only be called by the current owner.
213      */
214     function transferOwnership(address newOwner) public virtual onlyOwner {
215         require(newOwner != address(0), "Ownable: new owner is the zero address");
216         _transferOwnership(newOwner);
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Internal function without access restriction.
222      */
223     function _transferOwnership(address newOwner) internal virtual {
224         address oldOwner = _owner;
225         _owner = newOwner;
226         emit OwnershipTransferred(oldOwner, newOwner);
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
231 
232 
233 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
234 
235 pragma solidity ^0.8.1;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      *
258      * [IMPORTANT]
259      * ====
260      * You shouldn't rely on `isContract` to protect against flash loan attacks!
261      *
262      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
263      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
264      * constructor.
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize/address.code.length, which returns 0
269         // for contracts in construction, since the code is only stored at the end
270         // of the constructor execution.
271 
272         return account.code.length > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         (bool success, ) = recipient.call{value: amount}("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain `call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         require(isContract(target), "Address: call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.call{value: value}(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal view returns (bytes memory) {
393         require(isContract(target), "Address: static call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.staticcall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(isContract(target), "Address: delegate call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.delegatecall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
428      * revert reason using the provided one.
429      *
430      * _Available since v4.3._
431      */
432     function verifyCallResult(
433         bool success,
434         bytes memory returndata,
435         string memory errorMessage
436     ) internal pure returns (bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443                 /// @solidity memory-safe-assembly
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
456 
457 
458 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @title ERC721 token receiver interface
464  * @dev Interface for any contract that wants to support safeTransfers
465  * from ERC721 asset contracts.
466  */
467 interface IERC721Receiver {
468     /**
469      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
470      * by `operator` from `from`, this function is called.
471      *
472      * It must return its Solidity selector to confirm the token transfer.
473      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
474      *
475      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
476      */
477     function onERC721Received(
478         address operator,
479         address from,
480         uint256 tokenId,
481         bytes calldata data
482     ) external returns (bytes4);
483 }
484 
485 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Interface of the ERC165 standard, as defined in the
494  * https://eips.ethereum.org/EIPS/eip-165[EIP].
495  *
496  * Implementers can declare support of contract interfaces, which can then be
497  * queried by others ({ERC165Checker}).
498  *
499  * For an implementation, see {ERC165}.
500  */
501 interface IERC165 {
502     /**
503      * @dev Returns true if this contract implements the interface defined by
504      * `interfaceId`. See the corresponding
505      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
506      * to learn more about how these ids are created.
507      *
508      * This function call must use less than 30 000 gas.
509      */
510     function supportsInterface(bytes4 interfaceId) external view returns (bool);
511 }
512 
513 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @dev Implementation of the {IERC165} interface.
523  *
524  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
525  * for the additional interface id that will be supported. For example:
526  *
527  * ```solidity
528  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
530  * }
531  * ```
532  *
533  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
534  */
535 abstract contract ERC165 is IERC165 {
536     /**
537      * @dev See {IERC165-supportsInterface}.
538      */
539     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540         return interfaceId == type(IERC165).interfaceId;
541     }
542 }
543 
544 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
545 
546 
547 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Required interface of an ERC721 compliant contract.
554  */
555 interface IERC721 is IERC165 {
556     /**
557      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
563      */
564     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
565 
566     /**
567      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
568      */
569     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
570 
571     /**
572      * @dev Returns the number of tokens in ``owner``'s account.
573      */
574     function balanceOf(address owner) external view returns (uint256 balance);
575 
576     /**
577      * @dev Returns the owner of the `tokenId` token.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function ownerOf(uint256 tokenId) external view returns (address owner);
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId,
602         bytes calldata data
603     ) external;
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers `tokenId` token from `from` to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - `tokenId` must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Approve or remove `operator` as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The `operator` cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns the account approved for `tokenId` token.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must exist.
678      */
679     function getApproved(uint256 tokenId) external view returns (address operator);
680 
681     /**
682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 }
688 
689 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Metadata is IERC721 {
702     /**
703      * @dev Returns the token collection name.
704      */
705     function name() external view returns (string memory);
706 
707     /**
708      * @dev Returns the token collection symbol.
709      */
710     function symbol() external view returns (string memory);
711 
712     /**
713      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
714      */
715     function tokenURI(uint256 tokenId) external view returns (string memory);
716 }
717 
718 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
719 
720 
721 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 
727 
728 
729 
730 
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension, but not including the Enumerable extension, which is available separately as
735  * {ERC721Enumerable}.
736  */
737 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
738     using Address for address;
739     using Strings for uint256;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) private _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) private _balances;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     /**
760      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
761      */
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view virtual override returns (uint256) {
781         require(owner != address(0), "ERC721: address zero is not a valid owner");
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
789         address owner = _owners[tokenId];
790         require(owner != address(0), "ERC721: invalid token ID");
791         return owner;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         _requireMinted(tokenId);
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overridden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return "";
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public virtual override {
831         address owner = ERC721.ownerOf(tokenId);
832         require(to != owner, "ERC721: approval to current owner");
833 
834         require(
835             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
836             "ERC721: approve caller is not token owner nor approved for all"
837         );
838 
839         _approve(to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view virtual override returns (address) {
846         _requireMinted(tokenId);
847 
848         return _tokenApprovals[tokenId];
849     }
850 
851     /**
852      * @dev See {IERC721-setApprovalForAll}.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         _setApprovalForAll(_msgSender(), operator, approved);
856     }
857 
858     /**
859      * @dev See {IERC721-isApprovedForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev See {IERC721-transferFrom}.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         //solhint-disable-next-line max-line-length
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
875 
876         _transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         safeTransferFrom(from, to, tokenId, "");
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory data
898     ) public virtual override {
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
900         _safeTransfer(from, to, tokenId, data);
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * `data` is additional data, it has no specified format and it is sent in call to `to`.
908      *
909      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
910      * implement alternative mechanisms to perform token transfer, such as signature-based.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeTransfer(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory data
926     ) internal virtual {
927         _transfer(from, to, tokenId);
928         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
929     }
930 
931     /**
932      * @dev Returns whether `tokenId` exists.
933      *
934      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935      *
936      * Tokens start existing when they are minted (`_mint`),
937      * and stop existing when they are burned (`_burn`).
938      */
939     function _exists(uint256 tokenId) internal view virtual returns (bool) {
940         return _owners[tokenId] != address(0);
941     }
942 
943     /**
944      * @dev Returns whether `spender` is allowed to manage `tokenId`.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      */
950     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
951         address owner = ERC721.ownerOf(tokenId);
952         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007 
1008         _afterTokenTransfer(address(0), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Destroys `tokenId`.
1013      * The approval is cleared when the token is burned.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must exist.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _burn(uint256 tokenId) internal virtual {
1022         address owner = ERC721.ownerOf(tokenId);
1023 
1024         _beforeTokenTransfer(owner, address(0), tokenId);
1025 
1026         // Clear approvals
1027         _approve(address(0), tokenId);
1028 
1029         _balances[owner] -= 1;
1030         delete _owners[tokenId];
1031 
1032         emit Transfer(owner, address(0), tokenId);
1033 
1034         _afterTokenTransfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1054         require(to != address(0), "ERC721: transfer to the zero address");
1055 
1056         _beforeTokenTransfer(from, to, tokenId);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId);
1060 
1061         _balances[from] -= 1;
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(from, to, tokenId);
1066 
1067         _afterTokenTransfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Approve `to` to operate on `tokenId`
1072      *
1073      * Emits an {Approval} event.
1074      */
1075     function _approve(address to, uint256 tokenId) internal virtual {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Approve `operator` to operate on all of `owner` tokens
1082      *
1083      * Emits an {ApprovalForAll} event.
1084      */
1085     function _setApprovalForAll(
1086         address owner,
1087         address operator,
1088         bool approved
1089     ) internal virtual {
1090         require(owner != operator, "ERC721: approve to caller");
1091         _operatorApprovals[owner][operator] = approved;
1092         emit ApprovalForAll(owner, operator, approved);
1093     }
1094 
1095     /**
1096      * @dev Reverts if the `tokenId` has not been minted yet.
1097      */
1098     function _requireMinted(uint256 tokenId) internal view virtual {
1099         require(_exists(tokenId), "ERC721: invalid token ID");
1100     }
1101 
1102     /**
1103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1104      * The call is not executed if the target address is not a contract.
1105      *
1106      * @param from address representing the previous owner of the given token ID
1107      * @param to target address that will receive the tokens
1108      * @param tokenId uint256 ID of the token to be transferred
1109      * @param data bytes optional data to send along with the call
1110      * @return bool whether the call correctly returned the expected magic value
1111      */
1112     function _checkOnERC721Received(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory data
1117     ) private returns (bool) {
1118         if (to.isContract()) {
1119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1120                 return retval == IERC721Receiver.onERC721Received.selector;
1121             } catch (bytes memory reason) {
1122                 if (reason.length == 0) {
1123                     revert("ERC721: transfer to non ERC721Receiver implementer");
1124                 } else {
1125                     /// @solidity memory-safe-assembly
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
1174 // File: contracts/Nft.sol
1175 
1176 
1177 // Amended by HashLips
1178 
1179 pragma solidity >=0.7.0 <0.9.0;
1180 
1181 
1182 
1183 
1184 contract Forgotten is ERC721, Ownable {
1185   using Strings for uint256;
1186   using Counters for Counters.Counter;
1187 
1188   Counters.Counter private supply;
1189 
1190   string public uriPrefix;
1191   string public uriSuffix = ".json";
1192   string public hiddenMetadataUri;
1193   
1194   uint256 public cost = 0 ether;
1195   uint256 public maxSupply = 777;
1196   uint256 public maxMintAmountPerTx = 2;
1197   uint256 public maxByWallet = 3;
1198 
1199   bool public paused = true;
1200   bool public revealed = true;
1201   bool public isAllowListActive = false;
1202 
1203   mapping(address => uint8) private _allowList;
1204   mapping(address => uint256) public mintedByWallet;
1205 
1206   constructor() ERC721("Forgott3n Worlds", "F3W") {
1207     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1208   }
1209 
1210   modifier mintCompliance(uint256 _mintAmount) {
1211     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1212     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1213     _;
1214   }
1215 
1216   function totalSupply() public view returns (uint256) {
1217     return supply.current();
1218   }
1219 
1220   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1221     require(!paused, "The contract is paused!");
1222     require(_mintAmount + mintedByWallet[msg.sender] <= maxByWallet, "Exceed maxByWallet");
1223 
1224     mintedByWallet[msg.sender] += _mintAmount;
1225 
1226     _mintLoop(msg.sender, _mintAmount);
1227   }
1228   
1229   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1230     _mintLoop(_receiver, _mintAmount);
1231   }
1232 
1233   function walletOfOwner(address _owner)
1234     public
1235     view
1236     returns (uint256[] memory)
1237   {
1238     uint256 ownerTokenCount = balanceOf(_owner);
1239     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1240     uint256 currentTokenId = 1;
1241     uint256 ownedTokenIndex = 0;
1242 
1243     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1244       address currentTokenOwner = ownerOf(currentTokenId);
1245 
1246       if (currentTokenOwner == _owner) {
1247         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1248 
1249         ownedTokenIndex++;
1250       }
1251 
1252       currentTokenId++;
1253     }
1254 
1255     return ownedTokenIds;
1256   }
1257 
1258   function tokenURI(uint256 _tokenId)
1259     public
1260     view
1261     virtual
1262     override
1263     returns (string memory)
1264   {
1265     require(
1266       _exists(_tokenId),
1267       "ERC721Metadata: URI query for nonexistent token"
1268     );
1269 
1270     if (revealed == false) {
1271       return hiddenMetadataUri;
1272     }
1273 
1274 
1275     string memory currentBaseURI = _baseURI();
1276     return bytes(currentBaseURI).length > 0
1277         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1278         : "";
1279   }
1280 
1281   function setRevealed(bool _state) public onlyOwner {
1282     revealed = _state;
1283   }
1284 
1285   function setCost(uint256 _cost) public onlyOwner {
1286     cost = _cost;
1287   }
1288 
1289   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1290     maxMintAmountPerTx = _maxMintAmountPerTx;
1291   }
1292 
1293   function setMaxByWallet(uint256 _maxByWallet) public onlyOwner {
1294     maxByWallet = _maxByWallet;
1295   }
1296 
1297   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1298     hiddenMetadataUri = _hiddenMetadataUri;
1299   }
1300 
1301   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1302     uriPrefix = _uriPrefix;
1303   }
1304 
1305   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1306     uriSuffix = _uriSuffix;
1307   }
1308 
1309   function setPaused(bool _state) public onlyOwner {
1310     paused = _state;
1311   }
1312 
1313   function setAllowListActive(bool _state) public onlyOwner {
1314     isAllowListActive = _state;
1315   }
1316 
1317   function setAllowList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1318     for (uint256 i = 0; i < addresses.length; i++) {
1319         _allowList[addresses[i]] = numAllowedToMint;
1320     }
1321   }
1322 
1323   function withdraw() public onlyOwner {
1324     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1325     require(os);
1326   }
1327 
1328   function mintAllowList(uint8 numberOfTokens) public payable{
1329 
1330     require(isAllowListActive, "Allow list is not active");
1331     require(numberOfTokens <= _allowList[msg.sender], "Exceeded max available to purchase");
1332     require(supply.current() + numberOfTokens <= maxSupply, "Purchase would exceed max tokens");
1333     require(numberOfTokens + mintedByWallet[msg.sender] <= maxByWallet, "Exceed maxByWallet");
1334 
1335     mintedByWallet[msg.sender] += numberOfTokens;
1336 
1337     _allowList[msg.sender] -= numberOfTokens;
1338     for (uint256 i = 0; i < numberOfTokens; i++) {
1339         supply.increment();
1340         _safeMint(msg.sender, supply.current());
1341     }
1342   }
1343 
1344   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1345     for (uint256 i = 0; i < _mintAmount; i++) {
1346       supply.increment();
1347       _safeMint(_receiver, supply.current());
1348     }
1349   }
1350 
1351   function _baseURI() internal view virtual override returns (string memory) {
1352     return uriPrefix;
1353   }
1354 }