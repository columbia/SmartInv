1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-02
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
14 /**
15  * @title Counters
16  * @author Matt Condon (@shrugs)
17  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
18  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
19  *
20  * Include with `using Counters for Counters.Counter;`
21  */
22 library Counters {
23     struct Counter {
24         // This variable should never be directly accessed by users of the library: interactions must be restricted to
25         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
26         // this feature: see https://github.com/ethereum/solidity/issues/4637
27         uint256 _value; // default: 0
28     }
29 
30     function current(Counter storage counter) internal view returns (uint256) {
31         return counter._value;
32     }
33 
34     function increment(Counter storage counter) internal {
35         unchecked {
36             counter._value += 1;
37         }
38     }
39 
40     function decrement(Counter storage counter) internal {
41         uint256 value = counter._value;
42         require(value > 0, "Counter: decrement overflow");
43         unchecked {
44             counter._value = value - 1;
45         }
46     }
47 
48     function reset(Counter storage counter) internal {
49         counter._value = 0;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/utils/Strings.sol
54 
55 
56 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65     uint8 private constant _ADDRESS_LENGTH = 20;
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 
123     /**
124      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
125      */
126     function toHexString(address addr) internal pure returns (string memory) {
127         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Context.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Provides information about the current execution context, including the
140  * sender of the transaction and its data. While these are generally available
141  * via msg.sender and msg.data, they should not be accessed in such a direct
142  * manner, since when dealing with meta-transactions the account sending and
143  * paying for execution may not be the actual sender (as far as an application
144  * is concerned).
145  *
146  * This contract is only required for intermediate, library-like contracts.
147  */
148 abstract contract Context {
149     function _msgSender() internal view virtual returns (address) {
150         return msg.sender;
151     }
152 
153     function _msgData() internal view virtual returns (bytes calldata) {
154         return msg.data;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/access/Ownable.sol
159 
160 
161 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 
166 /**
167  * @dev Contract module which provides a basic access control mechanism, where
168  * there is an account (an owner) that can be granted exclusive access to
169  * specific functions.
170  *
171  * By default, the owner account will be the one that deploys the contract. This
172  * can later be changed with {transferOwnership}.
173  *
174  * This module is used through inheritance. It will make available the modifier
175  * `onlyOwner`, which can be applied to your functions to restrict their use to
176  * the owner.
177  */
178 abstract contract Ownable is Context {
179     address private _owner;
180 
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183     /**
184      * @dev Initializes the contract setting the deployer as the initial owner.
185      */
186     constructor() {
187         _transferOwnership(_msgSender());
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         _checkOwner();
195         _;
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if the sender is not the owner.
207      */
208     function _checkOwner() internal view virtual {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
247 
248 pragma solidity ^0.8.1;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      *
271      * [IMPORTANT]
272      * ====
273      * You shouldn't rely on `isContract` to protect against flash loan attacks!
274      *
275      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
276      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
277      * constructor.
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies on extcodesize/address.code.length, which returns 0
282         // for contracts in construction, since the code is only stored at the end
283         // of the constructor execution.
284 
285         return account.code.length > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain `call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         require(isContract(target), "Address: call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.call{value: value}(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
392         return functionStaticCall(target, data, "Address: low-level static call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         require(isContract(target), "Address: static call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(isContract(target), "Address: delegate call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
441      * revert reason using the provided one.
442      *
443      * _Available since v4.3._
444      */
445     function verifyCallResult(
446         bool success,
447         bytes memory returndata,
448         string memory errorMessage
449     ) internal pure returns (bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456                 /// @solidity memory-safe-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
469 
470 
471 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 interface IERC721Receiver {
481     /**
482      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
483      * by `operator` from `from`, this function is called.
484      *
485      * It must return its Solidity selector to confirm the token transfer.
486      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
487      *
488      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
489      */
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC165 standard, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-165[EIP].
508  *
509  * Implementers can declare support of contract interfaces, which can then be
510  * queried by others ({ERC165Checker}).
511  *
512  * For an implementation, see {ERC165}.
513  */
514 interface IERC165 {
515     /**
516      * @dev Returns true if this contract implements the interface defined by
517      * `interfaceId`. See the corresponding
518      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
519      * to learn more about how these ids are created.
520      *
521      * This function call must use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool);
524 }
525 
526 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Required interface of an ERC721 compliant contract.
567  */
568 interface IERC721 is IERC165 {
569     /**
570      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
571      */
572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
576      */
577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
581      */
582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
583 
584     /**
585      * @dev Returns the number of tokens in ``owner``'s account.
586      */
587     function balanceOf(address owner) external view returns (uint256 balance);
588 
589     /**
590      * @dev Returns the owner of the `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function ownerOf(uint256 tokenId) external view returns (address owner);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Transfers `tokenId` token from `from` to `to`.
640      *
641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
660      * The approval is cleared when the token is transferred.
661      *
662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
663      *
664      * Requirements:
665      *
666      * - The caller must own the token or be an approved operator.
667      * - `tokenId` must exist.
668      *
669      * Emits an {Approval} event.
670      */
671     function approve(address to, uint256 tokenId) external;
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns the account approved for `tokenId` token.
687      *
688      * Requirements:
689      *
690      * - `tokenId` must exist.
691      */
692     function getApproved(uint256 tokenId) external view returns (address operator);
693 
694     /**
695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
696      *
697      * See {setApprovalForAll}
698      */
699     function isApprovedForAll(address owner, address operator) external view returns (bool);
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Metadata is IERC721 {
715     /**
716      * @dev Returns the token collection name.
717      */
718     function name() external view returns (string memory);
719 
720     /**
721      * @dev Returns the token collection symbol.
722      */
723     function symbol() external view returns (string memory);
724 
725     /**
726      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
727      */
728     function tokenURI(uint256 tokenId) external view returns (string memory);
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
732 
733 
734 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 
740 
741 
742 
743 
744 
745 /**
746  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
747  * the Metadata extension, but not including the Enumerable extension, which is available separately as
748  * {ERC721Enumerable}.
749  */
750 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
751     using Address for address;
752     using Strings for uint256;
753 
754     // Token name
755     string private _name;
756 
757     // Token symbol
758     string private _symbol;
759 
760     // Mapping from token ID to owner address
761     mapping(uint256 => address) private _owners;
762 
763     // Mapping owner address to token count
764     mapping(address => uint256) private _balances;
765 
766     // Mapping from token ID to approved address
767     mapping(uint256 => address) private _tokenApprovals;
768 
769     // Mapping from owner to operator approvals
770     mapping(address => mapping(address => bool)) private _operatorApprovals;
771 
772     /**
773      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
774      */
775     constructor(string memory name_, string memory symbol_) {
776         _name = name_;
777         _symbol = symbol_;
778     }
779 
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
784         return
785             interfaceId == type(IERC721).interfaceId ||
786             interfaceId == type(IERC721Metadata).interfaceId ||
787             super.supportsInterface(interfaceId);
788     }
789 
790     /**
791      * @dev See {IERC721-balanceOf}.
792      */
793     function balanceOf(address owner) public view virtual override returns (uint256) {
794         require(owner != address(0), "ERC721: address zero is not a valid owner");
795         return _balances[owner];
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
802         address owner = _owners[tokenId];
803         require(owner != address(0), "ERC721: invalid token ID");
804         return owner;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-name}.
809      */
810     function name() public view virtual override returns (string memory) {
811         return _name;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-symbol}.
816      */
817     function symbol() public view virtual override returns (string memory) {
818         return _symbol;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-tokenURI}.
823      */
824     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
825         _requireMinted(tokenId);
826 
827         string memory baseURI = _baseURI();
828         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
829     }
830 
831     /**
832      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
833      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
834      * by default, can be overridden in child contracts.
835      */
836     function _baseURI() internal view virtual returns (string memory) {
837         return "";
838     }
839 
840     /**
841      * @dev See {IERC721-approve}.
842      */
843     function approve(address to, uint256 tokenId) public virtual override {
844         address owner = ERC721.ownerOf(tokenId);
845         require(to != owner, "ERC721: approval to current owner");
846 
847         require(
848             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
849             "ERC721: approve caller is not token owner nor approved for all"
850         );
851 
852         _approve(to, tokenId);
853     }
854 
855     /**
856      * @dev See {IERC721-getApproved}.
857      */
858     function getApproved(uint256 tokenId) public view virtual override returns (address) {
859         _requireMinted(tokenId);
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved) public virtual override {
868         _setApprovalForAll(_msgSender(), operator, approved);
869     }
870 
871     /**
872      * @dev See {IERC721-isApprovedForAll}.
873      */
874     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
875         return _operatorApprovals[owner][operator];
876     }
877 
878     /**
879      * @dev See {IERC721-transferFrom}.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         //solhint-disable-next-line max-line-length
887         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
888 
889         _transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         safeTransferFrom(from, to, tokenId, "");
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory data
911     ) public virtual override {
912         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
913         _safeTransfer(from, to, tokenId, data);
914     }
915 
916     /**
917      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
918      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
919      *
920      * `data` is additional data, it has no specified format and it is sent in call to `to`.
921      *
922      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
923      * implement alternative mechanisms to perform token transfer, such as signature-based.
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must exist and be owned by `from`.
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeTransfer(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory data
939     ) internal virtual {
940         _transfer(from, to, tokenId);
941         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted (`_mint`),
950      * and stop existing when they are burned (`_burn`).
951      */
952     function _exists(uint256 tokenId) internal view virtual returns (bool) {
953         return _owners[tokenId] != address(0);
954     }
955 
956     /**
957      * @dev Returns whether `spender` is allowed to manage `tokenId`.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      */
963     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
964         address owner = ERC721.ownerOf(tokenId);
965         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
966     }
967 
968     /**
969      * @dev Safely mints `tokenId` and transfers it to `to`.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must not exist.
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _safeMint(address to, uint256 tokenId) internal virtual {
979         _safeMint(to, tokenId, "");
980     }
981 
982     /**
983      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
984      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
985      */
986     function _safeMint(
987         address to,
988         uint256 tokenId,
989         bytes memory data
990     ) internal virtual {
991         _mint(to, tokenId);
992         require(
993             _checkOnERC721Received(address(0), to, tokenId, data),
994             "ERC721: transfer to non ERC721Receiver implementer"
995         );
996     }
997 
998     /**
999      * @dev Mints `tokenId` and transfers it to `to`.
1000      *
1001      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must not exist.
1006      * - `to` cannot be the zero address.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _mint(address to, uint256 tokenId) internal virtual {
1011         require(to != address(0), "ERC721: mint to the zero address");
1012         require(!_exists(tokenId), "ERC721: token already minted");
1013 
1014         _beforeTokenTransfer(address(0), to, tokenId);
1015 
1016         _balances[to] += 1;
1017         _owners[tokenId] = to;
1018 
1019         emit Transfer(address(0), to, tokenId);
1020 
1021         _afterTokenTransfer(address(0), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Destroys `tokenId`.
1026      * The approval is cleared when the token is burned.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _burn(uint256 tokenId) internal virtual {
1035         address owner = ERC721.ownerOf(tokenId);
1036 
1037         _beforeTokenTransfer(owner, address(0), tokenId);
1038 
1039         // Clear approvals
1040         _approve(address(0), tokenId);
1041 
1042         _balances[owner] -= 1;
1043         delete _owners[tokenId];
1044 
1045         emit Transfer(owner, address(0), tokenId);
1046 
1047         _afterTokenTransfer(owner, address(0), tokenId);
1048     }
1049 
1050     /**
1051      * @dev Transfers `tokenId` from `from` to `to`.
1052      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must be owned by `from`.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _transfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) internal virtual {
1066         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1067         require(to != address(0), "ERC721: transfer to the zero address");
1068 
1069         _beforeTokenTransfer(from, to, tokenId);
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId);
1073 
1074         _balances[from] -= 1;
1075         _balances[to] += 1;
1076         _owners[tokenId] = to;
1077 
1078         emit Transfer(from, to, tokenId);
1079 
1080         _afterTokenTransfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits an {Approval} event.
1087      */
1088     function _approve(address to, uint256 tokenId) internal virtual {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `operator` to operate on all of `owner` tokens
1095      *
1096      * Emits an {ApprovalForAll} event.
1097      */
1098     function _setApprovalForAll(
1099         address owner,
1100         address operator,
1101         bool approved
1102     ) internal virtual {
1103         require(owner != operator, "ERC721: approve to caller");
1104         _operatorApprovals[owner][operator] = approved;
1105         emit ApprovalForAll(owner, operator, approved);
1106     }
1107 
1108     /**
1109      * @dev Reverts if the `tokenId` has not been minted yet.
1110      */
1111     function _requireMinted(uint256 tokenId) internal view virtual {
1112         require(_exists(tokenId), "ERC721: invalid token ID");
1113     }
1114 
1115     /**
1116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1117      * The call is not executed if the target address is not a contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory data
1130     ) private returns (bool) {
1131         if (to.isContract()) {
1132             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1133                 return retval == IERC721Receiver.onERC721Received.selector;
1134             } catch (bytes memory reason) {
1135                 if (reason.length == 0) {
1136                     revert("ERC721: transfer to non ERC721Receiver implementer");
1137                 } else {
1138                     /// @solidity memory-safe-assembly
1139                     assembly {
1140                         revert(add(32, reason), mload(reason))
1141                     }
1142                 }
1143             }
1144         } else {
1145             return true;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Hook that is called before any token transfer. This includes minting
1151      * and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` will be minted for `to`.
1158      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _beforeTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 
1169     /**
1170      * @dev Hook that is called after any transfer of tokens. This includes
1171      * minting and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - when `from` and `to` are both non-zero.
1176      * - `from` and `to` are never both zero.
1177      *
1178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1179      */
1180     function _afterTokenTransfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual {}
1185 }
1186 
1187 // File: contracts/LowGas.sol
1188 
1189 
1190 
1191 pragma solidity >=0.7.0 <0.9.0;
1192 
1193 
1194 
1195 
1196 contract AiDoodlesArt is ERC721, Ownable {
1197   using Strings for uint256;
1198   using Counters for Counters.Counter;
1199 
1200   Counters.Counter private supply;
1201 
1202   string public uriPrefix = "";
1203   string public uriSuffix = ".json";
1204   string public hiddenMetadataUri;
1205   
1206   uint256 public cost = 0.0049 ether;
1207 
1208   uint256 public maxSupply = 10000;
1209   uint256 public freeSupplyLeft = 1000;
1210 
1211   uint256 public maxPaidMintAmountPerTx = 10;
1212   uint256 public maxFreeMintAmountPerTx = 3;
1213   uint256 public paidMintPerWallet = 20;
1214   uint256 public freeMintPerWallet = 3;
1215 
1216   mapping(address => uint256) public mintedList;
1217   mapping(address => uint256) public freeMintedList;
1218 
1219   bool public paused = false;
1220   bool public revealed = false;
1221 
1222   constructor() ERC721("Ai Doodles Art", "AiDoodlesArt") {
1223     setHiddenMetadataUri("ipfs://QmQ61RCgzuZ7FreoyzBu5yAdAYQAsWmTsTkXgQJJcsKHcR/hidden.json");
1224   }
1225   
1226 
1227   function totalSupply() public view returns (uint256) {
1228     return supply.current();
1229   }
1230 
1231   function mint(uint256 _mintAmount) public payable {
1232     require(!paused, "The contract is paused!");
1233     
1234     if (msg.value > 0) {
1235         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1236         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1237         require(_mintAmount <= maxPaidMintAmountPerTx, "Max 10 NFTs per transaction");
1238         require(mintedList[msg.sender] + _mintAmount <= paidMintPerWallet, "Max NFTs per wallet");
1239         mintedList[msg.sender] += _mintAmount; 
1240         _mintLoop(msg.sender, _mintAmount);
1241     } else {
1242         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1243         require(freeSupplyLeft - _mintAmount >= 0, "Reached free mint supply");
1244         require(freeMintedList[msg.sender] + _mintAmount <= freeMintPerWallet, "Max free NFTs per wallet");
1245         freeMintedList[msg.sender] += _mintAmount; 
1246         freeSupplyLeft = freeSupplyLeft - _mintAmount;
1247         _mintLoop(msg.sender, _mintAmount);
1248     }
1249   }
1250   
1251   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1252     _mintLoop(_receiver, _mintAmount);
1253   }
1254 
1255   function walletOfOwner(address _owner)
1256     public
1257     view
1258     returns (uint256[] memory)
1259   {
1260     uint256 ownerTokenCount = balanceOf(_owner);
1261     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1262     uint256 currentTokenId = 1;
1263     uint256 ownedTokenIndex = 0;
1264 
1265     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1266       address currentTokenOwner = ownerOf(currentTokenId);
1267 
1268       if (currentTokenOwner == _owner) {
1269         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1270 
1271         ownedTokenIndex++;
1272       }
1273 
1274       currentTokenId++;
1275     }
1276 
1277     return ownedTokenIds;
1278   }
1279 
1280   function tokenURI(uint256 _tokenId)
1281     public
1282     view
1283     virtual
1284     override
1285     returns (string memory)
1286   {
1287     require(
1288       _exists(_tokenId),
1289       "ERC721Metadata: URI query for nonexistent token"
1290     );
1291 
1292     if (revealed == false) {
1293       return hiddenMetadataUri;
1294     }
1295 
1296     string memory currentBaseURI = _baseURI();
1297     return bytes(currentBaseURI).length > 0
1298         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1299         : "";
1300   }
1301 
1302   function setRevealed(bool _state) public onlyOwner {
1303     revealed = _state;
1304   }
1305   function setPaidMintPerWallet(uint256 _paidMintPerWallet) public onlyOwner {
1306     paidMintPerWallet = _paidMintPerWallet;
1307   }
1308    function setFreeMintPerWallet(uint256 _freeMintPerWallet) public onlyOwner {
1309     freeMintPerWallet = _freeMintPerWallet;
1310   }
1311   function setMaxPaidMintAmountPerTx(uint256 _maxPaidMintAmountPerTx) public onlyOwner {
1312     maxPaidMintAmountPerTx = _maxPaidMintAmountPerTx;
1313   }
1314   function setMaxFreeMintAmountPerTx(uint256 _maxFreeMintAmountPerTx) public onlyOwner {
1315     maxFreeMintAmountPerTx = _maxFreeMintAmountPerTx;
1316   }
1317 
1318   function setCost(uint256 _cost) public onlyOwner {
1319     cost = _cost;
1320   }
1321 
1322   function setfreeSupplyLeft(uint256 _freeSupplyLeft) public onlyOwner {
1323     freeSupplyLeft = _freeSupplyLeft;
1324   }
1325   
1326   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1327     hiddenMetadataUri = _hiddenMetadataUri;
1328   }
1329 
1330   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1331     uriPrefix = _uriPrefix;
1332   }
1333 
1334   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1335     uriSuffix = _uriSuffix;
1336   }
1337 
1338   function setPaused(bool _state) public onlyOwner {
1339     paused = _state;
1340   }
1341 
1342   function withdraw() public onlyOwner {
1343     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1344     require(os);
1345   }
1346 
1347   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1348     for (uint256 i = 0; i < _mintAmount; i++) {
1349       supply.increment();
1350       _safeMint(_receiver, supply.current());
1351     }
1352   }
1353 
1354   function _baseURI() internal view virtual override returns (string memory) {
1355     return uriPrefix;
1356   }
1357 }