1 /*
2   ___  _____  _  _  ____  ____     ____  ____  ____  _  _  ___  ____  ___  ___  ____  ___    _  _  ____  ____ 
3  / __)(  _  )( \/ )(_  _)(  _ \   (  _ \(  _ \(_  _)( \( )/ __)( ___)/ __)/ __)( ___)/ __)  ( \( )( ___)(_  _)
4 ( (__  )(_)(  \  /  _)(_  )(_) )   )___/ )   / _)(_  )  (( (__  )__) \__ \\__ \ )__) \__ \   )  (  )__)   )(  
5  \___)(_____)  \/  (____)(____/   (__)  (_)\_)(____)(_)\_)\___)(____)(___/(___/(____)(___/  (_)\_)(__)   (__) 
6 
7 */
8 
9 // File: openzeppelin-solidity/contracts/utils/Counters.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @title Counters
18  * @author Matt Condon (@shrugs)
19  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
20  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
21  *
22  * Include with `using Counters for Counters.Counter;`
23  */
24 library Counters {
25     struct Counter {
26         // This variable should never be directly accessed by users of the library: interactions must be restricted to
27         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
28         // this feature: see https://github.com/ethereum/solidity/issues/4637
29         uint256 _value; // default: 0
30     }
31 
32     function current(Counter storage counter) internal view returns (uint256) {
33         return counter._value;
34     }
35 
36     function increment(Counter storage counter) internal {
37         unchecked {
38             counter._value += 1;
39         }
40     }
41 
42     function decrement(Counter storage counter) internal {
43         uint256 value = counter._value;
44         require(value > 0, "Counter: decrement overflow");
45         unchecked {
46             counter._value = value - 1;
47         }
48     }
49 
50     function reset(Counter storage counter) internal {
51         counter._value = 0;
52     }
53 }
54 
55 // File: openzeppelin-solidity/contracts/utils/Strings.sol
56 
57 
58 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev String operations.
64  */
65 library Strings {
66     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
70      */
71     function toString(uint256 value) internal pure returns (string memory) {
72         // Inspired by OraclizeAPI's implementation - MIT licence
73         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
74 
75         if (value == 0) {
76             return "0";
77         }
78         uint256 temp = value;
79         uint256 digits;
80         while (temp != 0) {
81             digits++;
82             temp /= 10;
83         }
84         bytes memory buffer = new bytes(digits);
85         while (value != 0) {
86             digits -= 1;
87             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
88             value /= 10;
89         }
90         return string(buffer);
91     }
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
95      */
96     function toHexString(uint256 value) internal pure returns (string memory) {
97         if (value == 0) {
98             return "0x00";
99         }
100         uint256 temp = value;
101         uint256 length = 0;
102         while (temp != 0) {
103             length++;
104             temp >>= 8;
105         }
106         return toHexString(value, length);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
111      */
112     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
113         bytes memory buffer = new bytes(2 * length + 2);
114         buffer[0] = "0";
115         buffer[1] = "x";
116         for (uint256 i = 2 * length + 1; i > 1; --i) {
117             buffer[i] = _HEX_SYMBOLS[value & 0xf];
118             value >>= 4;
119         }
120         require(value == 0, "Strings: hex length insufficient");
121         return string(buffer);
122     }
123 }
124 
125 // File: openzeppelin-solidity/contracts/utils/Context.sol
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
152 // File: openzeppelin-solidity/contracts/access/Ownable.sol
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
230 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
443 
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
455 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
485 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
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
513 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
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
544 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
614      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
689 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
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
718 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
781         require(owner != address(0), "ERC721: balance query for the zero address");
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
789         address owner = _owners[tokenId];
790         require(owner != address(0), "ERC721: owner query for nonexistent token");
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
812         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
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
836             "ERC721: approve caller is not owner nor approved for all"
837         );
838 
839         _approve(to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view virtual override returns (address) {
846         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
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
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
897         bytes memory _data
898     ) public virtual override {
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
900         _safeTransfer(from, to, tokenId, _data);
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
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
925         bytes memory _data
926     ) internal virtual {
927         _transfer(from, to, tokenId);
928         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
951         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
952         address owner = ERC721.ownerOf(tokenId);
953         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
954     }
955 
956     /**
957      * @dev Safely mints `tokenId` and transfers it to `to`.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must not exist.
962      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(address to, uint256 tokenId) internal virtual {
967         _safeMint(to, tokenId, "");
968     }
969 
970     /**
971      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
972      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
973      */
974     function _safeMint(
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) internal virtual {
979         _mint(to, tokenId);
980         require(
981             _checkOnERC721Received(address(0), to, tokenId, _data),
982             "ERC721: transfer to non ERC721Receiver implementer"
983         );
984     }
985 
986     /**
987      * @dev Mints `tokenId` and transfers it to `to`.
988      *
989      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
990      *
991      * Requirements:
992      *
993      * - `tokenId` must not exist.
994      * - `to` cannot be the zero address.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _mint(address to, uint256 tokenId) internal virtual {
999         require(to != address(0), "ERC721: mint to the zero address");
1000         require(!_exists(tokenId), "ERC721: token already minted");
1001 
1002         _beforeTokenTransfer(address(0), to, tokenId);
1003 
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(address(0), to, tokenId);
1008 
1009         _afterTokenTransfer(address(0), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Destroys `tokenId`.
1014      * The approval is cleared when the token is burned.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _burn(uint256 tokenId) internal virtual {
1023         address owner = ERC721.ownerOf(tokenId);
1024 
1025         _beforeTokenTransfer(owner, address(0), tokenId);
1026 
1027         // Clear approvals
1028         _approve(address(0), tokenId);
1029 
1030         _balances[owner] -= 1;
1031         delete _owners[tokenId];
1032 
1033         emit Transfer(owner, address(0), tokenId);
1034 
1035         _afterTokenTransfer(owner, address(0), tokenId);
1036     }
1037 
1038     /**
1039      * @dev Transfers `tokenId` from `from` to `to`.
1040      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {
1054         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1055         require(to != address(0), "ERC721: transfer to the zero address");
1056 
1057         _beforeTokenTransfer(from, to, tokenId);
1058 
1059         // Clear approvals from the previous owner
1060         _approve(address(0), tokenId);
1061 
1062         _balances[from] -= 1;
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(from, to, tokenId);
1067 
1068         _afterTokenTransfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Approve `to` to operate on `tokenId`
1073      *
1074      * Emits a {Approval} event.
1075      */
1076     function _approve(address to, uint256 tokenId) internal virtual {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Approve `operator` to operate on all of `owner` tokens
1083      *
1084      * Emits a {ApprovalForAll} event.
1085      */
1086     function _setApprovalForAll(
1087         address owner,
1088         address operator,
1089         bool approved
1090     ) internal virtual {
1091         require(owner != operator, "ERC721: approve to caller");
1092         _operatorApprovals[owner][operator] = approved;
1093         emit ApprovalForAll(owner, operator, approved);
1094     }
1095 
1096     /**
1097      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1098      * The call is not executed if the target address is not a contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param _data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) private returns (bool) {
1112         if (to.isContract()) {
1113             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1114                 return retval == IERC721Receiver.onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert("ERC721: transfer to non ERC721Receiver implementer");
1118                 } else {
1119                     assembly {
1120                         revert(add(32, reason), mload(reason))
1121                     }
1122                 }
1123             }
1124         } else {
1125             return true;
1126         }
1127     }
1128 
1129     /**
1130      * @dev Hook that is called before any token transfer. This includes minting
1131      * and burning.
1132      *
1133      * Calling conditions:
1134      *
1135      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1136      * transferred to `to`.
1137      * - When `from` is zero, `tokenId` will be minted for `to`.
1138      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1139      * - `from` and `to` are never both zero.
1140      *
1141      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1142      */
1143     function _beforeTokenTransfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {}
1148 
1149     /**
1150      * @dev Hook that is called after any transfer of tokens. This includes
1151      * minting and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - when `from` and `to` are both non-zero.
1156      * - `from` and `to` are never both zero.
1157      *
1158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1159      */
1160     function _afterTokenTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) internal virtual {}
1165 }
1166 
1167 // File: contracts/contractfree.sol
1168 
1169 
1170 pragma solidity 0.8.7;
1171 
1172 /*
1173   ___  _____  _  _  ____  ____     ____  ____  ____  _  _  ___  ____  ___  ___  ____  ___    _  _  ____  ____ 
1174  / __)(  _  )( \/ )(_  _)(  _ \   (  _ \(  _ \(_  _)( \( )/ __)( ___)/ __)/ __)( ___)/ __)  ( \( )( ___)(_  _)
1175 ( (__  )(_)(  \  /  _)(_  )(_) )   )___/ )   / _)(_  )  (( (__  )__) \__ \\__ \ )__) \__ \   )  (  )__)   )(  
1176  \___)(_____)  \/  (____)(____/   (__)  (_)\_)(____)(_)\_)\___)(____)(___/(___/(____)(___/  (_)\_)(__)   (__) 
1177 
1178 */
1179 
1180 
1181 
1182 
1183 contract COVIDPrincessesNFT is ERC721, Ownable {
1184     using Counters for Counters.Counter;
1185     using Strings for uint256;
1186 
1187     Counters.Counter private _supply;
1188 
1189     string private baseURI; 
1190     string private baseExtension = ".json";
1191 
1192     string private _contractURI; 
1193 
1194     uint256 public constant MAX_SUPPLY = 3333;
1195     uint256 public reservedAmount = 100;
1196     uint256 public price = 0.0 ether;
1197     uint256 public maxMintAmountPerTx = 10;
1198 
1199     bool public paused = true;
1200 
1201 
1202     constructor() ERC721("COVID Princesses", "COVP") {
1203         setContractURI("ipfs://QmXByXsf23BwSxh7cK8yKoEyVqchYe8LvbUGa1GZitkpGP/QmXiKFJjUw99LkMuecP1ZtYPuNsoB9McpgU5UxLGRM4stW");
1204         setBaseURI("ipfs://QmcekHX9LkuQciBJNceXXm6KtMTdmV74V6bAt6KRvxaNQs/");// slash at the end needed!
1205     }    
1206 
1207     modifier notPaused() {
1208         require(!paused, "Contract is paused!");
1209         _;
1210     }
1211     modifier mintAmountPossible(uint256 _amount) {
1212         require(_amount > 0 && _amount <= maxMintAmountPerTx, "Invalid mint amount!");
1213         require(_supply.current() + _amount <= MAX_SUPPLY - reservedAmount, "No tokens left!");
1214         _;
1215     }
1216     modifier mintPricePossible(uint256 _amount) {
1217         require(msg.value >= price * _amount, "Not enough ETH sent!");
1218         _;
1219     }
1220     modifier mintReservedPossible(uint256 _amount) {
1221         require(_amount > 0, "Invalid mint amount!");
1222         require(_amount <= reservedAmount, "Reserve exceeded!");
1223         _;
1224     }
1225 
1226 
1227     function _mintLoop(address _receiver, uint256 _amount) internal {
1228         for (uint256 i = 0; i < _amount; i++) {
1229             _supply.increment();
1230             _safeMint(_receiver, _supply.current());
1231         }
1232     }
1233 
1234     function mint(uint256 _amount) public payable notPaused mintAmountPossible(_amount) mintPricePossible(_amount) {       
1235         _mintLoop(msg.sender, _amount);
1236     }
1237 
1238     function mintReserved(address _receiver, uint256 _amount) public onlyOwner mintReservedPossible(_amount){
1239         require(_receiver != address(0), "Wrong receiver address");
1240 
1241         _mintLoop(_receiver, _amount);
1242         reservedAmount = reservedAmount - _amount;
1243     }
1244 
1245     function mintReservedMultiple(address[] calldata _receivers, uint256 _amount) public onlyOwner{
1246         require(_receivers.length > 0, "Wrong receiver length");
1247         require(_receivers.length * _amount <= maxMintAmountPerTx && _receivers.length * _amount <= reservedAmount, "Invalid mint amount!");
1248 
1249         for(uint256 i = 0; i < _receivers.length; i++){
1250             mintReserved(_receivers[i], _amount);
1251         }
1252     }
1253 
1254     receive() external payable{
1255     }
1256     
1257 
1258     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1259         uint256 tokenCount = balanceOf(_owner);
1260 
1261         uint256[] memory tokenIds = new uint256[](tokenCount);
1262         uint256 i = 1;
1263         uint256 ownedTokenIndex = 0;
1264 
1265         while (ownedTokenIndex < tokenCount && i <= MAX_SUPPLY) {
1266             address currentTokenOwner = ownerOf(i);
1267 
1268             if (currentTokenOwner == _owner) {
1269                 tokenIds[ownedTokenIndex] = i;
1270 
1271                 ownedTokenIndex++;
1272             }
1273 
1274             i++;
1275         }
1276 
1277         return tokenIds;
1278     }
1279 
1280     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1281         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1282 
1283         string memory currentBaseURI = _baseURI();
1284         return
1285             bytes(currentBaseURI).length > 0
1286                 ? string(
1287                     abi.encodePacked(
1288                         currentBaseURI,
1289                         _tokenId.toString(),
1290                         baseExtension
1291                     )
1292                 )
1293                 : "";
1294     }
1295 
1296     
1297 
1298     //Getters
1299     function totalSupply() public view returns (uint256) {
1300         return _supply.current();
1301     }
1302 
1303     function remainingSupply() public view returns (uint256) {
1304         return MAX_SUPPLY - _supply.current();
1305     }
1306 
1307     function contractURI() public view returns (string memory) {
1308         return _contractURI;
1309     }
1310 
1311     function _baseURI() internal view virtual override returns (string memory) {
1312         return baseURI;
1313     }
1314 
1315     function getBalance() external view returns (uint256) {
1316         return address(this).balance;
1317     }
1318 
1319     
1320 
1321     //Setters
1322     function setPaused(bool _state) public onlyOwner {
1323         paused = _state;
1324     }
1325 
1326     function setCost(uint256 _cost) public onlyOwner {
1327         price = _cost;
1328     }
1329 
1330     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1331         maxMintAmountPerTx = _maxMintAmountPerTx;
1332     } 
1333 
1334     function setBaseURI(string memory _uri) public onlyOwner {
1335         baseURI = _uri;
1336     }
1337 
1338     function setBaseExtension(string memory _baseExtension) public onlyOwner {
1339         baseExtension = _baseExtension;
1340     }
1341 
1342     function setContractURI(string memory _uri) public onlyOwner {
1343         _contractURI = _uri;
1344     }
1345 
1346     function withdraw() public onlyOwner {
1347         payable(owner()).transfer(address(this).balance);
1348     }    
1349 }