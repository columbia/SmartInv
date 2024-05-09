1 // SPDX-License-Identifier: MIT
2 
3 /*
4                                                   
5                     )                    )  (             
6     )        (   ( /( (    (  (       ( /(  )\ (          
7  ( /(  (    ))\  )\()))\   )\))(  (   )\())((_))\   (     
8  )(_)) )\  /((_)((_)\((_) ((_))\  )\ ((_)\  _ ((_)  )\ )  
9 ((_)_ ((_)(_))( | |(_)(_)  (()(_)((_)| |(_)| | (_) _(_/(  
10 / _` ||_ /| || || / / | | / _` |/ _ \| '_ \| | | || ' \)) 
11 \__,_|/__| \_,_||_\_\ |_| \__, |\___/|_.__/|_| |_||_||_|  
12                           |___/                           
13 
14 */
15 
16 // File 1: Address.sol
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
19 
20 pragma solidity ^0.8.1;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if `account` is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, `isContract` will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      *
43      * [IMPORTANT]
44      * ====
45      * You shouldn't rely on `isContract` to protect against flash loan attacks!
46      *
47      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
48      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
49      * constructor.
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize/address.code.length, which returns 0
54         // for contracts in construction, since the code is only stored at the end
55         // of the constructor execution.
56 
57         return account.code.length > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62      * `recipient`, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by `transfer`, making them unable to receive funds via
67      * `transfer`. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to `recipient`, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level `call`. A
85      * plain `call` is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If `target` reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
93      *
94      * Requirements:
95      *
96      * - `target` must be a contract.
97      * - calling `target` with `data` must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
107      * `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 
241 // FILE 2: Context.sol
242 pragma solidity ^0.8.0;
243 
244 /*
245  * @dev Provides information about the current execution context, including the
246  * sender of the transaction and its data. While these are generally available
247  * via msg.sender and msg.data, they should not be accessed in such a direct
248  * manner, since when dealing with meta-transactions the account sending and
249  * paying for execution may not be the actual sender (as far as an application
250  * is concerned).
251  *
252  * This contract is only required for intermediate, library-like contracts.
253  */
254 abstract contract Context {
255     function _msgSender() internal view virtual returns (address) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view virtual returns (bytes calldata) {
260         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
261         return msg.data;
262     }
263 }
264 
265 // File 3: Strings.sol
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev String operations.
273  */
274 library Strings {
275     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
279      */
280     function toString(uint256 value) internal pure returns (string memory) {
281         // Inspired by OraclizeAPI's implementation - MIT licence
282         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
283 
284         if (value == 0) {
285             return "0";
286         }
287         uint256 temp = value;
288         uint256 digits;
289         while (temp != 0) {
290             digits++;
291             temp /= 10;
292         }
293         bytes memory buffer = new bytes(digits);
294         while (value != 0) {
295             digits -= 1;
296             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
297             value /= 10;
298         }
299         return string(buffer);
300     }
301 
302     /**
303      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
304      */
305     function toHexString(uint256 value) internal pure returns (string memory) {
306         if (value == 0) {
307             return "0x00";
308         }
309         uint256 temp = value;
310         uint256 length = 0;
311         while (temp != 0) {
312             length++;
313             temp >>= 8;
314         }
315         return toHexString(value, length);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
320      */
321     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
322         bytes memory buffer = new bytes(2 * length + 2);
323         buffer[0] = "0";
324         buffer[1] = "x";
325         for (uint256 i = 2 * length + 1; i > 1; --i) {
326             buffer[i] = _HEX_SYMBOLS[value & 0xf];
327             value >>= 4;
328         }
329         require(value == 0, "Strings: hex length insufficient");
330         return string(buffer);
331     }
332 }
333 
334 
335 // File: @openzeppelin/contracts/utils/Counters.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @title Counters
344  * @author Matt Condon (@shrugs)
345  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
346  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
347  *
348  * Include with `using Counters for Counters.Counter;`
349  */
350 library Counters {
351     struct Counter {
352         // This variable should never be directly accessed by users of the library: interactions must be restricted to
353         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
354         // this feature: see https://github.com/ethereum/solidity/issues/4637
355         uint256 _value; // default: 0
356     }
357 
358     function current(Counter storage counter) internal view returns (uint256) {
359         return counter._value;
360     }
361 
362     function increment(Counter storage counter) internal {
363         unchecked {
364             counter._value += 1;
365         }
366     }
367 
368     function decrement(Counter storage counter) internal {
369         uint256 value = counter._value;
370         require(value > 0, "Counter: decrement overflow");
371         unchecked {
372             counter._value = value - 1;
373         }
374     }
375 
376     function reset(Counter storage counter) internal {
377         counter._value = 0;
378     }
379 }
380 
381 // File 4: Ownable.sol
382 
383 
384 pragma solidity ^0.8.0;
385 
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 abstract contract Ownable is Context {
400     address private _owner;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor () {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view virtual returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         require(owner() == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428     /**
429      * @dev Leaves the contract without owner. It will not be possible to call
430      * `onlyOwner` functions anymore. Can only be called by the current owner.
431      *
432      * NOTE: Renouncing ownership will leave the contract without an owner,
433      * thereby removing any functionality that is only available to the owner.
434      */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 }
450 
451 
452 
453 
454 
455 // File 5: IERC165.sol
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Interface of the ERC165 standard, as defined in the
461  * https://eips.ethereum.org/EIPS/eip-165[EIP].
462  *
463  * Implementers can declare support of contract interfaces, which can then be
464  * queried by others ({ERC165Checker}).
465  *
466  * For an implementation, see {ERC165}.
467  */
468 interface IERC165 {
469     /**
470      * @dev Returns true if this contract implements the interface defined by
471      * `interfaceId`. See the corresponding
472      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
473      * to learn more about how these ids are created.
474      *
475      * This function call must use less than 30 000 gas.
476      */
477     function supportsInterface(bytes4 interfaceId) external view returns (bool);
478 }
479 
480 
481 // File 6: IERC721.sol
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Required interface of an ERC721 compliant contract.
488  */
489 interface IERC721 is IERC165 {
490     /**
491      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
492      */
493     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
497      */
498     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
499 
500     /**
501      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
502      */
503     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
504 
505     /**
506      * @dev Returns the number of tokens in ``owner``'s account.
507      */
508     function balanceOf(address owner) external view returns (uint256 balance);
509 
510     /**
511      * @dev Returns the owner of the `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function ownerOf(uint256 tokenId) external view returns (address owner);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
521      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
522      *
523      * Requirements:
524      *
525      * - `from` cannot be the zero address.
526      * - `to` cannot be the zero address.
527      * - `tokenId` token must exist and be owned by `from`.
528      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
529      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
530      *
531      * Emits a {Transfer} event.
532      */
533     function safeTransferFrom(address from, address to, uint256 tokenId) external;
534 
535     /**
536      * @dev Transfers `tokenId` token from `from` to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(address from, address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
553      * The approval is cleared when the token is transferred.
554      *
555      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
556      *
557      * Requirements:
558      *
559      * - The caller must own the token or be an approved operator.
560      * - `tokenId` must exist.
561      *
562      * Emits an {Approval} event.
563      */
564     function approve(address to, uint256 tokenId) external;
565 
566     /**
567      * @dev Returns the account approved for `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function getApproved(uint256 tokenId) external view returns (address operator);
574 
575     /**
576      * @dev Approve or remove `operator` as an operator for the caller.
577      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
578      *
579      * Requirements:
580      *
581      * - The `operator` cannot be the caller.
582      *
583      * Emits an {ApprovalForAll} event.
584      */
585     function setApprovalForAll(address operator, bool _approved) external;
586 
587     /**
588      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
589      *
590      * See {setApprovalForAll}
591      */
592     function isApprovedForAll(address owner, address operator) external view returns (bool);
593 
594     /**
595       * @dev Safely transfers `tokenId` token from `from` to `to`.
596       *
597       * Requirements:
598       *
599       * - `from` cannot be the zero address.
600       * - `to` cannot be the zero address.
601       * - `tokenId` token must exist and be owned by `from`.
602       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604       *
605       * Emits a {Transfer} event.
606       */
607     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
608 }
609 
610 
611 
612 // File 7: IERC721Metadata.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Metadata is IERC721 {
625     /**
626      * @dev Returns the token collection name.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the token collection symbol.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     function tokenURI(uint256 tokenId) external returns (string memory);
639 }
640 
641 
642 
643 
644 // File 8: ERC165.sol
645 
646 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @dev Implementation of the {IERC165} interface.
653  *
654  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
655  * for the additional interface id that will be supported. For example:
656  *
657  * ```solidity
658  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
660  * }
661  * ```
662  *
663  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
664  */
665 abstract contract ERC165 is IERC165 {
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
670         return interfaceId == type(IERC165).interfaceId;
671     }
672 }
673 
674 
675 // File 9: ERC721.sol
676 
677 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension, but not including the Enumerable extension, which is available separately as
685  * {ERC721Enumerable}.
686  */
687 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to owner address
698     mapping(uint256 => address) private _owners;
699 
700     // Mapping owner address to token count
701     mapping(address => uint256) private _balances;
702 
703     // Mapping from token ID to approved address
704     mapping(uint256 => address) private _tokenApprovals;
705 
706     // Mapping from owner to operator approvals
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     /**
710      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view virtual override returns (uint256) {
731         require(owner != address(0), "ERC721: balance query for the zero address");
732         return _balances[owner];
733     }
734 
735     /**
736      * @dev See {IERC721-ownerOf}.
737      */
738     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
739         address owner = _owners[tokenId];
740         require(owner != address(0), "ERC721: owner query for nonexistent token");
741         return owner;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-name}.
746      */
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-symbol}.
753      */
754     function symbol() public view virtual override returns (string memory) {
755         return _symbol;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-tokenURI}.
760      */
761     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
762         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
763 
764         string memory baseURI = _baseURI();
765         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
766     }
767 
768     /**
769      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
770      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
771      * by default, can be overridden in child contracts.
772      */
773     function _baseURI() internal view virtual returns (string memory) {
774         return "";
775     }
776 
777     /**
778      * @dev See {IERC721-approve}.
779      */
780     function approve(address to, uint256 tokenId) public virtual override {
781         address owner = ERC721.ownerOf(tokenId);
782         require(to != owner, "ERC721: approval to current owner");
783 
784         require(
785             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
786             "ERC721: approve caller is not owner nor approved for all"
787         );
788         if (to.isContract()) {
789             revert ("Token transfer to contract address is not allowed.");
790         } else {
791             _approve(to, tokenId);
792         }
793         // _approve(to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-getApproved}.
798      */
799     function getApproved(uint256 tokenId) public view virtual override returns (address) {
800         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
801 
802         return _tokenApprovals[tokenId];
803     }
804 
805     /**
806      * @dev See {IERC721-setApprovalForAll}.
807      */
808     function setApprovalForAll(address operator, bool approved) public virtual override {
809         _setApprovalForAll(_msgSender(), operator, approved);
810     }
811 
812     /**
813      * @dev See {IERC721-isApprovedForAll}.
814      */
815     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
816         return _operatorApprovals[owner][operator];
817     }
818 
819     /**
820      * @dev See {IERC721-transferFrom}.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         //solhint-disable-next-line max-line-length
828         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
829 
830         _transfer(from, to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         safeTransferFrom(from, to, tokenId, "");
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) public virtual override {
853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
854         _safeTransfer(from, to, tokenId, _data);
855     }
856 
857     /**
858      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
859      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
860      *
861      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
862      *
863      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
864      * implement alternative mechanisms to perform token transfer, such as signature-based.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must exist and be owned by `from`.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeTransfer(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) internal virtual {
881         _transfer(from, to, tokenId);
882         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
883     }
884 
885     /**
886      * @dev Returns whether `tokenId` exists.
887      *
888      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
889      *
890      * Tokens start existing when they are minted (`_mint`),
891      * and stop existing when they are burned (`_burn`).
892      */
893     function _exists(uint256 tokenId) internal view virtual returns (bool) {
894         return _owners[tokenId] != address(0);
895     }
896 
897     /**
898      * @dev Returns whether `spender` is allowed to manage `tokenId`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      */
904     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
905         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
906         address owner = ERC721.ownerOf(tokenId);
907         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
908     }
909 
910     /**
911      * @dev Safely mints `tokenId` and transfers it to `to`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeMint(address to, uint256 tokenId) internal virtual {
921         _safeMint(to, tokenId, "");
922     }
923 
924     /**
925      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
926      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
927      */
928     function _safeMint(
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _mint(to, tokenId);
934         require(
935             _checkOnERC721Received(address(0), to, tokenId, _data),
936             "ERC721: transfer to non ERC721Receiver implementer"
937         );
938     }
939 
940     /**
941      * @dev Mints `tokenId` and transfers it to `to`.
942      *
943      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - `to` cannot be the zero address.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _mint(address to, uint256 tokenId) internal virtual {
953         require(to != address(0), "ERC721: mint to the zero address");
954         require(!_exists(tokenId), "ERC721: token already minted");
955 
956         _beforeTokenTransfer(address(0), to, tokenId);
957 
958         _balances[to] += 1;
959         _owners[tokenId] = to;
960 
961         emit Transfer(address(0), to, tokenId);
962 
963         _afterTokenTransfer(address(0), to, tokenId);
964     }
965 
966     /**
967      * @dev Destroys `tokenId`.
968      * The approval is cleared when the token is burned.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         address owner = ERC721.ownerOf(tokenId);
978 
979         _beforeTokenTransfer(owner, address(0), tokenId);
980 
981         // Clear approvals
982         _approve(address(0), tokenId);
983 
984         _balances[owner] -= 1;
985         delete _owners[tokenId];
986 
987         emit Transfer(owner, address(0), tokenId);
988 
989         _afterTokenTransfer(owner, address(0), tokenId);
990     }
991 
992     /**
993      * @dev Transfers `tokenId` from `from` to `to`.
994      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must be owned by `from`.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _transfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) internal virtual {
1008         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1009         require(to != address(0), "ERC721: transfer to the zero address");
1010 
1011         _beforeTokenTransfer(from, to, tokenId);
1012 
1013         // Clear approvals from the previous owner
1014         _approve(address(0), tokenId);
1015 
1016         _balances[from] -= 1;
1017         _balances[to] += 1;
1018         _owners[tokenId] = to;
1019 
1020         emit Transfer(from, to, tokenId);
1021 
1022         _afterTokenTransfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(address to, uint256 tokenId) internal virtual {
1031         _tokenApprovals[tokenId] = to;
1032         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `operator` to operate on all of `owner` tokens
1037      *
1038      * Emits a {ApprovalForAll} event.
1039      */
1040     function _setApprovalForAll(
1041         address owner,
1042         address operator,
1043         bool approved
1044     ) internal virtual {
1045         require(owner != operator, "ERC721: approve to caller");
1046         _operatorApprovals[owner][operator] = approved;
1047         emit ApprovalForAll(owner, operator, approved);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver.onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert("ERC721: transfer to non ERC721Receiver implementer");
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 
1103     /**
1104      * @dev Hook that is called after any transfer of tokens. This includes
1105      * minting and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero.
1110      * - `from` and `to` are never both zero.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _afterTokenTransfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) internal virtual {}
1119 }
1120 
1121 
1122 
1123 
1124 
1125 // File 10: IERC721Enumerable.sol
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 /**
1131  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1132  * @dev See https://eips.ethereum.org/EIPS/eip-721
1133  */
1134 interface IERC721Enumerable is IERC721 {
1135 
1136     /**
1137      * @dev Returns the total amount of tokens stored by the contract.
1138      */
1139     function totalSupply() external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1143      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1146 
1147     /**
1148      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1149      * Use along with {totalSupply} to enumerate all tokens.
1150      */
1151     function tokenByIndex(uint256 index) external view returns (uint256);
1152 }
1153 
1154 
1155 
1156 
1157 
1158 
1159 // File 11: ERC721Enumerable.sol
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 /**
1165  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1166  * enumerability of all the token ids in the contract as well as all token ids owned by each
1167  * account.
1168  */
1169 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1170     // Mapping from owner to list of owned token IDs
1171     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1172 
1173     // Mapping from token ID to index of the owner tokens list
1174     mapping(uint256 => uint256) private _ownedTokensIndex;
1175 
1176     // Array with all token ids, used for enumeration
1177     uint256[] private _allTokens;
1178 
1179     // Mapping from token id to position in the allTokens array
1180     mapping(uint256 => uint256) private _allTokensIndex;
1181 
1182     /**
1183      * @dev See {IERC165-supportsInterface}.
1184      */
1185     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1186         return interfaceId == type(IERC721Enumerable).interfaceId
1187             || super.supportsInterface(interfaceId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1192      */
1193     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1194         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1195         return _ownedTokens[owner][index];
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Enumerable-totalSupply}.
1200      */
1201     function totalSupply() public view virtual override returns (uint256) {
1202         return _allTokens.length;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-tokenByIndex}.
1207      */
1208     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1209         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1210         return _allTokens[index];
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before any token transfer. This includes minting
1215      * and burning.
1216      *
1217      * Calling conditions:
1218      *
1219      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1220      * transferred to `to`.
1221      * - When `from` is zero, `tokenId` will be minted for `to`.
1222      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      *
1226      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1227      */
1228     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1229         super._beforeTokenTransfer(from, to, tokenId);
1230 
1231         if (from == address(0)) {
1232             _addTokenToAllTokensEnumeration(tokenId);
1233         } else if (from != to) {
1234             _removeTokenFromOwnerEnumeration(from, tokenId);
1235         }
1236         if (to == address(0)) {
1237             _removeTokenFromAllTokensEnumeration(tokenId);
1238         } else if (to != from) {
1239             _addTokenToOwnerEnumeration(to, tokenId);
1240         }
1241     }
1242 
1243     /**
1244      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1245      * @param to address representing the new owner of the given token ID
1246      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1247      */
1248     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1249         uint256 length = ERC721.balanceOf(to);
1250         _ownedTokens[to][length] = tokenId;
1251         _ownedTokensIndex[tokenId] = length;
1252     }
1253 
1254     /**
1255      * @dev Private function to add a token to this extension's token tracking data structures.
1256      * @param tokenId uint256 ID of the token to be added to the tokens list
1257      */
1258     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1259         _allTokensIndex[tokenId] = _allTokens.length;
1260         _allTokens.push(tokenId);
1261     }
1262 
1263     /**
1264      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1265      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1266      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1267      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1268      * @param from address representing the previous owner of the given token ID
1269      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1270      */
1271     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1272         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1273         // then delete the last slot (swap and pop).
1274 
1275         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1276         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1277 
1278         // When the token to delete is the last token, the swap operation is unnecessary
1279         if (tokenIndex != lastTokenIndex) {
1280             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1281 
1282             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1283             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1284         }
1285 
1286         // This also deletes the contents at the last position of the array
1287         delete _ownedTokensIndex[tokenId];
1288         delete _ownedTokens[from][lastTokenIndex];
1289     }
1290 
1291     /**
1292      * @dev Private function to remove a token from this extension's token tracking data structures.
1293      * This has O(1) time complexity, but alters the order of the _allTokens array.
1294      * @param tokenId uint256 ID of the token to be removed from the tokens list
1295      */
1296     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1297         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1298         // then delete the last slot (swap and pop).
1299 
1300         uint256 lastTokenIndex = _allTokens.length - 1;
1301         uint256 tokenIndex = _allTokensIndex[tokenId];
1302 
1303         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1304         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1305         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1306         uint256 lastTokenId = _allTokens[lastTokenIndex];
1307 
1308         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1309         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1310 
1311         // This also deletes the contents at the last position of the array
1312         delete _allTokensIndex[tokenId];
1313         _allTokens.pop();
1314     }
1315 }
1316 
1317 
1318 
1319 // File 12: IERC721Receiver.sol
1320 
1321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 /**
1326  * @title ERC721 token receiver interface
1327  * @dev Interface for any contract that wants to support safeTransfers
1328  * from ERC721 asset contracts.
1329  */
1330 interface IERC721Receiver {
1331     /**
1332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1333      * by `operator` from `from`, this function is called.
1334      *
1335      * It must return its Solidity selector to confirm the token transfer.
1336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1337      *
1338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1339      */
1340     function onERC721Received(
1341         address operator,
1342         address from,
1343         uint256 tokenId,
1344         bytes calldata data
1345     ) external returns (bytes4);
1346 }
1347 
1348 
1349 
1350 // File 13: ERC721A.sol
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 
1355 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1356     using Address for address;
1357     using Strings for uint256;
1358 
1359     struct TokenOwnership {
1360         address addr;
1361         uint64 startTimestamp;
1362     }
1363 
1364     struct AddressData {
1365         uint128 balance;
1366         uint128 numberMinted;
1367     }
1368 
1369     uint256 internal currentIndex;
1370 
1371     // Token name
1372     string private _name;
1373 
1374     // Token symbol
1375     string private _symbol;
1376 
1377     // Mapping from token ID to ownership details
1378     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1379     mapping(uint256 => TokenOwnership) internal _ownerships;
1380 
1381     // Mapping owner address to address data
1382     mapping(address => AddressData) private _addressData;
1383 
1384     // Mapping from token ID to approved address
1385     mapping(uint256 => address) private _tokenApprovals;
1386 
1387     // Mapping from owner to operator approvals
1388     mapping(address => mapping(address => bool)) private _operatorApprovals;
1389 
1390     constructor(string memory name_, string memory symbol_) {
1391         _name = name_;
1392         _symbol = symbol_;
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-totalSupply}.
1397      */
1398     function totalSupply() public view override virtual returns (uint256) {
1399         return currentIndex;
1400     }
1401 
1402     /**
1403      * @dev See {IERC721Enumerable-tokenByIndex}.
1404      */
1405     function tokenByIndex(uint256 index) public view override returns (uint256) {
1406         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1407         return index;
1408     }
1409 
1410     /**
1411      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1412      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1413      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1414      */
1415     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1416         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1417         uint256 numMintedSoFar = totalSupply();
1418         uint256 tokenIdsIdx;
1419         address currOwnershipAddr;
1420 
1421         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1422         unchecked {
1423             for (uint256 i; i < numMintedSoFar; i++) {
1424                 TokenOwnership memory ownership = _ownerships[i];
1425                 if (ownership.addr != address(0)) {
1426                     currOwnershipAddr = ownership.addr;
1427                 }
1428                 if (currOwnershipAddr == owner) {
1429                     if (tokenIdsIdx == index) {
1430                         return i;
1431                     }
1432                     tokenIdsIdx++;
1433                 }
1434             }
1435         }
1436 
1437         revert('ERC721A: unable to get token of owner by index');
1438     }
1439 
1440     /**
1441      * @dev See {IERC165-supportsInterface}.
1442      */
1443     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1444         return
1445             interfaceId == type(IERC721).interfaceId ||
1446             interfaceId == type(IERC721Metadata).interfaceId ||
1447             interfaceId == type(IERC721Enumerable).interfaceId ||
1448             super.supportsInterface(interfaceId);
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-balanceOf}.
1453      */
1454     function balanceOf(address owner) public view override returns (uint256) {
1455         require(owner != address(0), 'ERC721A: balance query for the zero address');
1456         return uint256(_addressData[owner].balance);
1457     }
1458 
1459     function _numberMinted(address owner) internal view returns (uint256) {
1460         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1461         return uint256(_addressData[owner].numberMinted);
1462     }
1463 
1464     /**
1465      * Gas spent here starts off proportional to the maximum mint batch size.
1466      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1467      */
1468     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1469         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1470 
1471         unchecked {
1472             for (uint256 curr = tokenId; curr >= 0; curr--) {
1473                 TokenOwnership memory ownership = _ownerships[curr];
1474                 if (ownership.addr != address(0)) {
1475                     return ownership;
1476                 }
1477             }
1478         }
1479 
1480         revert('ERC721A: unable to determine the owner of token');
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-ownerOf}.
1485      */
1486     function ownerOf(uint256 tokenId) public view override returns (address) {
1487         return ownershipOf(tokenId).addr;
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Metadata-name}.
1492      */
1493     function name() public view virtual override returns (string memory) {
1494         return _name;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Metadata-symbol}.
1499      */
1500     function symbol() public view virtual override returns (string memory) {
1501         return _symbol;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Metadata-tokenURI}.
1506      */
1507     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1508         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1509 
1510         string memory baseURI = _baseURI();
1511         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1512     }
1513 
1514     /**
1515      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1516      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1517      * by default, can be overriden in child contracts.
1518      */
1519     function _baseURI() internal view virtual returns (string memory) {
1520         return '';
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-approve}.
1525      */
1526     function approve(address to, uint256 tokenId) public override {
1527         address owner = ERC721A.ownerOf(tokenId);
1528         require(to != owner, 'ERC721A: approval to current owner');
1529 
1530         require(
1531             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1532             'ERC721A: approve caller is not owner nor approved for all'
1533         );
1534 
1535         _approve(to, tokenId, owner);
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-getApproved}.
1540      */
1541     function getApproved(uint256 tokenId) public view override returns (address) {
1542         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1543 
1544         return _tokenApprovals[tokenId];
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-setApprovalForAll}.
1549      */
1550     function setApprovalForAll(address operator, bool approved) public override {
1551         require(operator != _msgSender(), 'ERC721A: approve to caller');
1552 
1553         _operatorApprovals[_msgSender()][operator] = approved;
1554         emit ApprovalForAll(_msgSender(), operator, approved);
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-isApprovedForAll}.
1559      */
1560     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1561         return _operatorApprovals[owner][operator];
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-transferFrom}.
1566      */
1567     function transferFrom(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) public override {
1572         _transfer(from, to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-safeTransferFrom}.
1577      */
1578     function safeTransferFrom(
1579         address from,
1580         address to,
1581         uint256 tokenId
1582     ) public override {
1583         safeTransferFrom(from, to, tokenId, '');
1584     }
1585 
1586     /**
1587      * @dev See {IERC721-safeTransferFrom}.
1588      */
1589     function safeTransferFrom(
1590         address from,
1591         address to,
1592         uint256 tokenId,
1593         bytes memory _data
1594     ) public override {
1595         _transfer(from, to, tokenId);
1596         require(
1597             _checkOnERC721Received(from, to, tokenId, _data),
1598             'ERC721A: transfer to non ERC721Receiver implementer'
1599         );
1600     }
1601 
1602     /**
1603      * @dev Returns whether `tokenId` exists.
1604      *
1605      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1606      *
1607      * Tokens start existing when they are minted (`_mint`),
1608      */
1609     function _exists(uint256 tokenId) internal view returns (bool) {
1610         return tokenId < currentIndex;
1611     }
1612 
1613     function _safeMint(address to, uint256 quantity) internal {
1614         _safeMint(to, quantity, '');
1615     }
1616 
1617     /**
1618      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1619      *
1620      * Requirements:
1621      *
1622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1623      * - `quantity` must be greater than 0.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function _safeMint(
1628         address to,
1629         uint256 quantity,
1630         bytes memory _data
1631     ) internal {
1632         _mint(to, quantity, _data, true);
1633     }
1634 
1635     /**
1636      * @dev Mints `quantity` tokens and transfers them to `to`.
1637      *
1638      * Requirements:
1639      *
1640      * - `to` cannot be the zero address.
1641      * - `quantity` must be greater than 0.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function _mint(
1646         address to,
1647         uint256 quantity,
1648         bytes memory _data,
1649         bool safe
1650     ) internal {
1651         uint256 startTokenId = currentIndex;
1652         require(to != address(0), 'ERC721A: mint to the zero address');
1653         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1654 
1655         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1656 
1657         // Overflows are incredibly unrealistic.
1658         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1659         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1660         unchecked {
1661             _addressData[to].balance += uint128(quantity);
1662             _addressData[to].numberMinted += uint128(quantity);
1663 
1664             _ownerships[startTokenId].addr = to;
1665             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1666 
1667             uint256 updatedIndex = startTokenId;
1668 
1669             for (uint256 i; i < quantity; i++) {
1670                 emit Transfer(address(0), to, updatedIndex);
1671                 if (safe) {
1672                     require(
1673                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1674                         'ERC721A: transfer to non ERC721Receiver implementer'
1675                     );
1676                 }
1677 
1678                 updatedIndex++;
1679             }
1680 
1681             currentIndex = updatedIndex;
1682         }
1683 
1684         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1685     }
1686 
1687     /**
1688      * @dev Transfers `tokenId` from `from` to `to`.
1689      *
1690      * Requirements:
1691      *
1692      * - `to` cannot be the zero address.
1693      * - `tokenId` token must be owned by `from`.
1694      *
1695      * Emits a {Transfer} event.
1696      */
1697     function _transfer(
1698         address from,
1699         address to,
1700         uint256 tokenId
1701     ) private {
1702         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1703 
1704         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1705             getApproved(tokenId) == _msgSender() ||
1706             isApprovedForAll(prevOwnership.addr, _msgSender()));
1707 
1708         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1709 
1710         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1711         require(to != address(0), 'ERC721A: transfer to the zero address');
1712 
1713         _beforeTokenTransfers(from, to, tokenId, 1);
1714 
1715         // Clear approvals from the previous owner
1716         _approve(address(0), tokenId, prevOwnership.addr);
1717 
1718         // Underflow of the sender's balance is impossible because we check for
1719         // ownership above and the recipient's balance can't realistically overflow.
1720         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1721         unchecked {
1722             _addressData[from].balance -= 1;
1723             _addressData[to].balance += 1;
1724 
1725             _ownerships[tokenId].addr = to;
1726             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1727 
1728             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1729             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1730             uint256 nextTokenId = tokenId + 1;
1731             if (_ownerships[nextTokenId].addr == address(0)) {
1732                 if (_exists(nextTokenId)) {
1733                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1734                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1735                 }
1736             }
1737         }
1738 
1739         emit Transfer(from, to, tokenId);
1740         _afterTokenTransfers(from, to, tokenId, 1);
1741     }
1742 
1743     /**
1744      * @dev Approve `to` to operate on `tokenId`
1745      *
1746      * Emits a {Approval} event.
1747      */
1748     function _approve(
1749         address to,
1750         uint256 tokenId,
1751         address owner
1752     ) private {
1753         _tokenApprovals[tokenId] = to;
1754         emit Approval(owner, to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1759      * The call is not executed if the target address is not a contract.
1760      *
1761      * @param from address representing the previous owner of the given token ID
1762      * @param to target address that will receive the tokens
1763      * @param tokenId uint256 ID of the token to be transferred
1764      * @param _data bytes optional data to send along with the call
1765      * @return bool whether the call correctly returned the expected magic value
1766      */
1767     function _checkOnERC721Received(
1768         address from,
1769         address to,
1770         uint256 tokenId,
1771         bytes memory _data
1772     ) private returns (bool) {
1773         if (to.isContract()) {
1774             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1775                 return retval == IERC721Receiver(to).onERC721Received.selector;
1776             } catch (bytes memory reason) {
1777                 if (reason.length == 0) {
1778                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1779                 } else {
1780                     assembly {
1781                         revert(add(32, reason), mload(reason))
1782                     }
1783                 }
1784             }
1785         } else {
1786             return true;
1787         }
1788     }
1789 
1790     /**
1791      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1792      *
1793      * startTokenId - the first token id to be transferred
1794      * quantity - the amount to be transferred
1795      *
1796      * Calling conditions:
1797      *
1798      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1799      * transferred to `to`.
1800      * - When `from` is zero, `tokenId` will be minted for `to`.
1801      */
1802     function _beforeTokenTransfers(
1803         address from,
1804         address to,
1805         uint256 startTokenId,
1806         uint256 quantity
1807     ) internal virtual {}
1808 
1809     /**
1810      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1811      * minting.
1812      *
1813      * startTokenId - the first token id to be transferred
1814      * quantity - the amount to be transferred
1815      *
1816      * Calling conditions:
1817      *
1818      * - when `from` and `to` are both non-zero.
1819      * - `from` and `to` are never both zero.
1820      */
1821     function _afterTokenTransfers(
1822         address from,
1823         address to,
1824         uint256 startTokenId,
1825         uint256 quantity
1826     ) internal virtual {}
1827 }
1828 
1829 // FILE 14: azukigoblin.sol
1830 
1831 pragma solidity ^0.8.0;
1832 
1833 contract AzukiGoblin is ERC721A, Ownable {
1834   using Strings for uint256;
1835   using Counters for Counters.Counter;
1836 
1837   string private uriPrefix = "";
1838   string public uriSuffix = ".json";
1839   string private hiddenMetadataUri;
1840 
1841     constructor() ERC721A("AzukiGoblin", "AZKGOBLIN") {
1842         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1843     }
1844 
1845     uint256 public maxSupply = 2999;
1846     uint256 private mintCount = 0;
1847     uint256 public maxMintPerTx = 2;
1848     uint256 public maxMintPerWallet = 2;   
1849     uint256 public price = 0.003 ether;
1850      
1851   bool public paused = true;
1852   bool public revealed = true;
1853   bool public dynamicCost = true;
1854 
1855   mapping (address => uint256) public addressMintedBalance;
1856   event Minted(uint256 totalMinted);
1857      
1858     function totalSupply() public view override returns (uint256) {
1859         return mintCount;
1860     }
1861 
1862     function changePrice(uint256 _newPrice) external onlyOwner {
1863         price = _newPrice;
1864     }
1865 
1866     function withdraw() external onlyOwner {
1867         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1868         require(success, "Transfer failed.");
1869     }
1870 
1871     function needToUpdateCost(uint256 _supply) internal view returns (uint256 _cost){
1872         if(_supply < 999) {
1873             return 0 ether;
1874         }
1875         if(_supply <= maxSupply) {
1876             return 0.003 ether;
1877         }
1878     }
1879 
1880     // dynamic mint
1881     function mint(uint256 _mintAmount) public payable {
1882     uint256 supply = totalSupply();
1883     require(!paused, "The contract is paused!");
1884     require(_mintAmount > 0, "Minimum 1 NFT has to be minted per transaction");
1885     require(supply + _mintAmount <= maxSupply, "Exceeds maximum supply");
1886 
1887     if (msg.sender != owner()) {
1888         require(_mintAmount <= maxMintPerTx, "max per tx exceeded!");
1889 
1890         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1891         require (ownerMintedCount + _mintAmount <= maxMintPerWallet, "max per address exceeded!");
1892 
1893         if(dynamicCost == true) {
1894             require(msg.value >= needToUpdateCost(supply) * _mintAmount, "Not enough funds");
1895         }
1896 
1897         if(dynamicCost == false) {
1898             require(msg.value >= price * _mintAmount, "Not enough funds");
1899         }
1900     }
1901  
1902     mintCount += _mintAmount;
1903     addressMintedBalance[msg.sender]+= _mintAmount;      
1904     emit Minted(_mintAmount);
1905     _safeMint(msg.sender, _mintAmount);
1906   }
1907 
1908     function walletOfOwner(address _owner)
1909         public
1910         view
1911         returns (uint256[] memory)
1912     {
1913         uint256 ownerTokenCount = balanceOf(_owner);
1914         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1915         uint256 currentTokenId = 1;
1916         uint256 ownedTokenIndex = 0;
1917 
1918         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1919         address currentTokenOwner = ownerOf(currentTokenId);
1920             if (currentTokenOwner == _owner) {
1921                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1922                 ownedTokenIndex++;
1923             }
1924         currentTokenId++;
1925         }
1926         return ownedTokenIds;
1927     }
1928   
1929   function tokenURI(uint256 _tokenId)
1930     public
1931     view
1932     virtual
1933     override
1934     returns (string memory)
1935   {
1936     require(
1937       _exists(_tokenId),
1938       "ERC721Metadata: URI query for nonexistent token"
1939     );
1940     if (revealed == false) {
1941       return hiddenMetadataUri;
1942     }
1943     string memory currentBaseURI = _baseURI();
1944     return bytes(currentBaseURI).length > 0
1945         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1946         : "";
1947   }
1948 
1949   function setRevealed(bool _state) public onlyOwner {
1950     revealed = _state;
1951   }  
1952 
1953   function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
1954     maxMintPerTx = _maxMintPerTx;
1955   }
1956 
1957   function setMaxMintPerWallet(uint256 _maxMintPerWallet) public onlyOwner {
1958     maxMintPerWallet = _maxMintPerWallet;
1959   }  
1960 
1961   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1962     hiddenMetadataUri = _hiddenMetadataUri;
1963   }  
1964 
1965   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1966     uriPrefix = _uriPrefix;
1967   }  
1968 
1969   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1970     uriSuffix = _uriSuffix;
1971   }
1972 
1973   function setPaused(bool _state) public onlyOwner {
1974     paused = _state;
1975   }
1976 
1977   function setdynamicCost(bool _state) public onlyOwner {
1978     dynamicCost = _state;
1979   }
1980 
1981   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1982     maxSupply = _maxSupply;
1983   }
1984 
1985   function _baseURI() internal view virtual override returns (string memory) {
1986     return uriPrefix;
1987   }
1988 }