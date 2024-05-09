1 // SPDX-License-Identifier: MIT
2 // File: contracts/DiscoveryNFT.sol
3 
4 
5 
6 // File 1: Address.sol
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
9 
10 pragma solidity ^0.8.1;
11 
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on `isContract` to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
52      * `recipient`, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by `transfer`, making them unable to receive funds via
57      * `transfer`. {sendValue} removes this limitation.
58      *
59      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to `recipient`, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain `call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
97      * `errorMessage` as a fallback revert reason when `target` reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
130      * with `errorMessage` as a fallback revert reason when `target` reverts.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{value: value}(data);
144         return verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
154         return functionStaticCall(target, data, "Address: low-level static call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal view returns (bytes memory) {
168         require(isContract(target), "Address: static call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.staticcall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
181         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         require(isContract(target), "Address: delegate call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
203      * revert reason using the provided one.
204      *
205      * _Available since v4.3._
206      */
207     function verifyCallResult(
208         bool success,
209         bytes memory returndata,
210         string memory errorMessage
211     ) internal pure returns (bytes memory) {
212         if (success) {
213             return returndata;
214         } else {
215             // Look for revert reason and bubble it up if present
216             if (returndata.length > 0) {
217                 // The easiest way to bubble the revert reason is using memory via assembly
218 
219                 assembly {
220                     let returndata_size := mload(returndata)
221                     revert(add(32, returndata), returndata_size)
222                 }
223             } else {
224                 revert(errorMessage);
225             }
226         }
227     }
228 }
229 
230 
231 // FILE 2: Context.sol
232 pragma solidity ^0.8.0;
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 // File 3: Strings.sol
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev String operations.
263  */
264 library Strings {
265     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
269      */
270     function toString(uint256 value) internal pure returns (string memory) {
271         // Inspired by OraclizeAPI's implementation - MIT licence
272         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
273 
274         if (value == 0) {
275             return "0";
276         }
277         uint256 temp = value;
278         uint256 digits;
279         while (temp != 0) {
280             digits++;
281             temp /= 10;
282         }
283         bytes memory buffer = new bytes(digits);
284         while (value != 0) {
285             digits -= 1;
286             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
287             value /= 10;
288         }
289         return string(buffer);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
294      */
295     function toHexString(uint256 value) internal pure returns (string memory) {
296         if (value == 0) {
297             return "0x00";
298         }
299         uint256 temp = value;
300         uint256 length = 0;
301         while (temp != 0) {
302             length++;
303             temp >>= 8;
304         }
305         return toHexString(value, length);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
310      */
311     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
312         bytes memory buffer = new bytes(2 * length + 2);
313         buffer[0] = "0";
314         buffer[1] = "x";
315         for (uint256 i = 2 * length + 1; i > 1; --i) {
316             buffer[i] = _HEX_SYMBOLS[value & 0xf];
317             value >>= 4;
318         }
319         require(value == 0, "Strings: hex length insufficient");
320         return string(buffer);
321     }
322 }
323 
324 
325 // File: @openzeppelin/contracts/utils/Counters.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @title Counters
334  * @author Matt Condon (@shrugs)
335  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
336  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
337  *
338  * Include with `using Counters for Counters.Counter;`
339  */
340 library Counters {
341     struct Counter {
342         // This variable should never be directly accessed by users of the library: interactions must be restricted to
343         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
344         // this feature: see https://github.com/ethereum/solidity/issues/4637
345         uint256 _value; // default: 0
346     }
347 
348     function current(Counter storage counter) internal view returns (uint256) {
349         return counter._value;
350     }
351 
352     function increment(Counter storage counter) internal {
353         unchecked {
354             counter._value += 1;
355         }
356     }
357 
358     function decrement(Counter storage counter) internal {
359         uint256 value = counter._value;
360         require(value > 0, "Counter: decrement overflow");
361         unchecked {
362             counter._value = value - 1;
363         }
364     }
365 
366     function reset(Counter storage counter) internal {
367         counter._value = 0;
368     }
369 }
370 
371 // File 4: Ownable.sol
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor () {
398         address msgSender = _msgSender();
399         _owner = msgSender;
400         emit OwnershipTransferred(address(0), msgSender);
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view virtual returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(owner() == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         emit OwnershipTransferred(_owner, newOwner);
437         _owner = newOwner;
438     }
439 }
440 
441 
442 
443 
444 
445 // File 5: IERC165.sol
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 
471 // File 6: IERC721.sol
472 
473 pragma solidity ^0.8.0;
474 
475 
476 /**
477  * @dev Required interface of an ERC721 compliant contract.
478  */
479 interface IERC721 is IERC165 {
480     /**
481      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
482      */
483     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
484 
485     /**
486      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
487      */
488     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
492      */
493     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
494 
495     /**
496      * @dev Returns the number of tokens in ``owner``'s account.
497      */
498     function balanceOf(address owner) external view returns (uint256 balance);
499 
500     /**
501      * @dev Returns the owner of the `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function ownerOf(uint256 tokenId) external view returns (address owner);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
511      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
512      *
513      * Requirements:
514      *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517      * - `tokenId` token must exist and be owned by `from`.
518      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
520      *
521      * Emits a {Transfer} event.
522      */
523     function safeTransferFrom(address from, address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Transfers `tokenId` token from `from` to `to`.
527      *
528      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
536      *
537      * Emits a {Transfer} event.
538      */
539     function transferFrom(address from, address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
543      * The approval is cleared when the token is transferred.
544      *
545      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
546      *
547      * Requirements:
548      *
549      * - The caller must own the token or be an approved operator.
550      * - `tokenId` must exist.
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address to, uint256 tokenId) external;
555 
556     /**
557      * @dev Returns the account approved for `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function getApproved(uint256 tokenId) external view returns (address operator);
564 
565     /**
566      * @dev Approve or remove `operator` as an operator for the caller.
567      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
568      *
569      * Requirements:
570      *
571      * - The `operator` cannot be the caller.
572      *
573      * Emits an {ApprovalForAll} event.
574      */
575     function setApprovalForAll(address operator, bool _approved) external;
576 
577     /**
578      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
579      *
580      * See {setApprovalForAll}
581      */
582     function isApprovedForAll(address owner, address operator) external view returns (bool);
583 
584     /**
585       * @dev Safely transfers `tokenId` token from `from` to `to`.
586       *
587       * Requirements:
588       *
589       * - `from` cannot be the zero address.
590       * - `to` cannot be the zero address.
591       * - `tokenId` token must exist and be owned by `from`.
592       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594       *
595       * Emits a {Transfer} event.
596       */
597     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
598 }
599 
600 
601 
602 // File 7: IERC721Metadata.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
612  * @dev See https://eips.ethereum.org/EIPS/eip-721
613  */
614 interface IERC721Metadata is IERC721 {
615     /**
616      * @dev Returns the token collection name.
617      */
618     function name() external view returns (string memory);
619 
620     /**
621      * @dev Returns the token collection symbol.
622      */
623     function symbol() external view returns (string memory);
624 
625     /**
626      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
627      */
628     function tokenURI(uint256 tokenId) external returns (string memory);
629 }
630 
631 
632 
633 
634 // File 8: ERC165.sol
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
660         return interfaceId == type(IERC165).interfaceId;
661     }
662 }
663 
664 
665 // File 9: ERC721.sol
666 
667 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata extension, but not including the Enumerable extension, which is available separately as
675  * {ERC721Enumerable}.
676  */
677 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
678     using Address for address;
679     using Strings for uint256;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to owner address
688     mapping(uint256 => address) private _owners;
689 
690     // Mapping owner address to token count
691     mapping(address => uint256) private _balances;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     /**
700      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
701      */
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view virtual override returns (uint256) {
721         require(owner != address(0), "ERC721: balance query for the zero address");
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
729         address owner = _owners[tokenId];
730         require(owner != address(0), "ERC721: owner query for nonexistent token");
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
752         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
753 
754         string memory baseURI = _baseURI();
755         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
756     }
757 
758     /**
759      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
760      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
761      * by default, can be overridden in child contracts.
762      */
763     function _baseURI() internal view virtual returns (string memory) {
764         return "";
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public virtual override {
771         address owner = ERC721.ownerOf(tokenId);
772         require(to != owner, "ERC721: approval to current owner");
773 
774         require(
775             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
776             "ERC721: approve caller is not owner nor approved for all"
777         );
778         if (to.isContract()) {
779             revert ("Token transfer to contract address is not allowed.");
780         } else {
781             _approve(to, tokenId);
782         }
783         // _approve(to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId) public view virtual override returns (address) {
790         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved) public virtual override {
799         _setApprovalForAll(_msgSender(), operator, approved);
800     }
801 
802     /**
803      * @dev See {IERC721-isApprovedForAll}.
804      */
805     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
806         return _operatorApprovals[owner][operator];
807     }
808 
809     /**
810      * @dev See {IERC721-transferFrom}.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public virtual override {
817         //solhint-disable-next-line max-line-length
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
819 
820         _transfer(from, to, tokenId);
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         safeTransferFrom(from, to, tokenId, "");
832     }
833 
834     /**
835      * @dev See {IERC721-safeTransferFrom}.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) public virtual override {
843         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
844         _safeTransfer(from, to, tokenId, _data);
845     }
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
849      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
850      *
851      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
852      *
853      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
854      * implement alternative mechanisms to perform token transfer, such as signature-based.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must exist and be owned by `from`.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _safeTransfer(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) internal virtual {
871         _transfer(from, to, tokenId);
872         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
873     }
874 
875     /**
876      * @dev Returns whether `tokenId` exists.
877      *
878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
879      *
880      * Tokens start existing when they are minted (`_mint`),
881      * and stop existing when they are burned (`_burn`).
882      */
883     function _exists(uint256 tokenId) internal view virtual returns (bool) {
884         return _owners[tokenId] != address(0);
885     }
886 
887     /**
888      * @dev Returns whether `spender` is allowed to manage `tokenId`.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
895         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
896         address owner = ERC721.ownerOf(tokenId);
897         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
898     }
899 
900     /**
901      * @dev Safely mints `tokenId` and transfers it to `to`.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must not exist.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _safeMint(address to, uint256 tokenId) internal virtual {
911         _safeMint(to, tokenId, "");
912     }
913 
914     /**
915      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
916      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
917      */
918     function _safeMint(
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) internal virtual {
923         _mint(to, tokenId);
924         require(
925             _checkOnERC721Received(address(0), to, tokenId, _data),
926             "ERC721: transfer to non ERC721Receiver implementer"
927         );
928     }
929 
930     /**
931      * @dev Mints `tokenId` and transfers it to `to`.
932      *
933      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
934      *
935      * Requirements:
936      *
937      * - `tokenId` must not exist.
938      * - `to` cannot be the zero address.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _mint(address to, uint256 tokenId) internal virtual {
943         require(to != address(0), "ERC721: mint to the zero address");
944         require(!_exists(tokenId), "ERC721: token already minted");
945 
946         _beforeTokenTransfer(address(0), to, tokenId);
947 
948         _balances[to] += 1;
949         _owners[tokenId] = to;
950 
951         emit Transfer(address(0), to, tokenId);
952 
953         _afterTokenTransfer(address(0), to, tokenId);
954     }
955 
956     /**
957      * @dev Destroys `tokenId`.
958      * The approval is cleared when the token is burned.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _burn(uint256 tokenId) internal virtual {
967         address owner = ERC721.ownerOf(tokenId);
968 
969         _beforeTokenTransfer(owner, address(0), tokenId);
970 
971         // Clear approvals
972         _approve(address(0), tokenId);
973 
974         _balances[owner] -= 1;
975         delete _owners[tokenId];
976 
977         emit Transfer(owner, address(0), tokenId);
978 
979         _afterTokenTransfer(owner, address(0), tokenId);
980     }
981 
982     /**
983      * @dev Transfers `tokenId` from `from` to `to`.
984      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) internal virtual {
998         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
999         require(to != address(0), "ERC721: transfer to the zero address");
1000 
1001         _beforeTokenTransfer(from, to, tokenId);
1002 
1003         // Clear approvals from the previous owner
1004         _approve(address(0), tokenId);
1005 
1006         _balances[from] -= 1;
1007         _balances[to] += 1;
1008         _owners[tokenId] = to;
1009 
1010         emit Transfer(from, to, tokenId);
1011 
1012         _afterTokenTransfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Approve `to` to operate on `tokenId`
1017      *
1018      * Emits a {Approval} event.
1019      */
1020     function _approve(address to, uint256 tokenId) internal virtual {
1021         _tokenApprovals[tokenId] = to;
1022         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Approve `operator` to operate on all of `owner` tokens
1027      *
1028      * Emits a {ApprovalForAll} event.
1029      */
1030     function _setApprovalForAll(
1031         address owner,
1032         address operator,
1033         bool approved
1034     ) internal virtual {
1035         require(owner != operator, "ERC721: approve to caller");
1036         _operatorApprovals[owner][operator] = approved;
1037         emit ApprovalForAll(owner, operator, approved);
1038     }
1039 
1040     /**
1041      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1042      * The call is not executed if the target address is not a contract.
1043      *
1044      * @param from address representing the previous owner of the given token ID
1045      * @param to target address that will receive the tokens
1046      * @param tokenId uint256 ID of the token to be transferred
1047      * @param _data bytes optional data to send along with the call
1048      * @return bool whether the call correctly returned the expected magic value
1049      */
1050     function _checkOnERC721Received(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) private returns (bool) {
1056         if (to.isContract()) {
1057             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1058                 return retval == IERC721Receiver.onERC721Received.selector;
1059             } catch (bytes memory reason) {
1060                 if (reason.length == 0) {
1061                     revert("ERC721: transfer to non ERC721Receiver implementer");
1062                 } else {
1063                     assembly {
1064                         revert(add(32, reason), mload(reason))
1065                     }
1066                 }
1067             }
1068         } else {
1069             return true;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` and `to` are never both zero.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {}
1092 
1093     /**
1094      * @dev Hook that is called after any transfer of tokens. This includes
1095      * minting and burning.
1096      *
1097      * Calling conditions:
1098      *
1099      * - when `from` and `to` are both non-zero.
1100      * - `from` and `to` are never both zero.
1101      *
1102      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1103      */
1104     function _afterTokenTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {}
1109 }
1110 
1111 
1112 
1113 
1114 
1115 // File 10: IERC721Enumerable.sol
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 
1120 /**
1121  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1122  * @dev See https://eips.ethereum.org/EIPS/eip-721
1123  */
1124 interface IERC721Enumerable is IERC721 {
1125 
1126     /**
1127      * @dev Returns the total amount of tokens stored by the contract.
1128      */
1129     function totalSupply() external view returns (uint256);
1130 
1131     /**
1132      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1133      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1134      */
1135     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1136 
1137     /**
1138      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1139      * Use along with {totalSupply} to enumerate all tokens.
1140      */
1141     function tokenByIndex(uint256 index) external view returns (uint256);
1142 }
1143 
1144 
1145 
1146 
1147 
1148 
1149 // File 11: ERC721Enumerable.sol
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 
1154 /**
1155  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1156  * enumerability of all the token ids in the contract as well as all token ids owned by each
1157  * account.
1158  */
1159 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1160     // Mapping from owner to list of owned token IDs
1161     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1162 
1163     // Mapping from token ID to index of the owner tokens list
1164     mapping(uint256 => uint256) private _ownedTokensIndex;
1165 
1166     // Array with all token ids, used for enumeration
1167     uint256[] private _allTokens;
1168 
1169     // Mapping from token id to position in the allTokens array
1170     mapping(uint256 => uint256) private _allTokensIndex;
1171 
1172     /**
1173      * @dev See {IERC165-supportsInterface}.
1174      */
1175     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1176         return interfaceId == type(IERC721Enumerable).interfaceId
1177             || super.supportsInterface(interfaceId);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1182      */
1183     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1184         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1185         return _ownedTokens[owner][index];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-totalSupply}.
1190      */
1191     function totalSupply() public view virtual override returns (uint256) {
1192         return _allTokens.length;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-tokenByIndex}.
1197      */
1198     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1199         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1200         return _allTokens[index];
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before any token transfer. This includes minting
1205      * and burning.
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1213      * - `from` cannot be the zero address.
1214      * - `to` cannot be the zero address.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1219         super._beforeTokenTransfer(from, to, tokenId);
1220 
1221         if (from == address(0)) {
1222             _addTokenToAllTokensEnumeration(tokenId);
1223         } else if (from != to) {
1224             _removeTokenFromOwnerEnumeration(from, tokenId);
1225         }
1226         if (to == address(0)) {
1227             _removeTokenFromAllTokensEnumeration(tokenId);
1228         } else if (to != from) {
1229             _addTokenToOwnerEnumeration(to, tokenId);
1230         }
1231     }
1232 
1233     /**
1234      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1235      * @param to address representing the new owner of the given token ID
1236      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1237      */
1238     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1239         uint256 length = ERC721.balanceOf(to);
1240         _ownedTokens[to][length] = tokenId;
1241         _ownedTokensIndex[tokenId] = length;
1242     }
1243 
1244     /**
1245      * @dev Private function to add a token to this extension's token tracking data structures.
1246      * @param tokenId uint256 ID of the token to be added to the tokens list
1247      */
1248     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1249         _allTokensIndex[tokenId] = _allTokens.length;
1250         _allTokens.push(tokenId);
1251     }
1252 
1253     /**
1254      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1255      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1256      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1257      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1258      * @param from address representing the previous owner of the given token ID
1259      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1260      */
1261     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1262         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1263         // then delete the last slot (swap and pop).
1264 
1265         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1266         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1267 
1268         // When the token to delete is the last token, the swap operation is unnecessary
1269         if (tokenIndex != lastTokenIndex) {
1270             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1271 
1272             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274         }
1275 
1276         // This also deletes the contents at the last position of the array
1277         delete _ownedTokensIndex[tokenId];
1278         delete _ownedTokens[from][lastTokenIndex];
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's token tracking data structures.
1283      * This has O(1) time complexity, but alters the order of the _allTokens array.
1284      * @param tokenId uint256 ID of the token to be removed from the tokens list
1285      */
1286     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1287         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1288         // then delete the last slot (swap and pop).
1289 
1290         uint256 lastTokenIndex = _allTokens.length - 1;
1291         uint256 tokenIndex = _allTokensIndex[tokenId];
1292 
1293         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1294         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1295         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1296         uint256 lastTokenId = _allTokens[lastTokenIndex];
1297 
1298         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1299         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1300 
1301         // This also deletes the contents at the last position of the array
1302         delete _allTokensIndex[tokenId];
1303         _allTokens.pop();
1304     }
1305 }
1306 
1307 
1308 
1309 // File 12: IERC721Receiver.sol
1310 
1311 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1312 
1313 pragma solidity ^0.8.0;
1314 
1315 /**
1316  * @title ERC721 token receiver interface
1317  * @dev Interface for any contract that wants to support safeTransfers
1318  * from ERC721 asset contracts.
1319  */
1320 interface IERC721Receiver {
1321     /**
1322      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1323      * by `operator` from `from`, this function is called.
1324      *
1325      * It must return its Solidity selector to confirm the token transfer.
1326      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1327      *
1328      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1329      */
1330     function onERC721Received(
1331         address operator,
1332         address from,
1333         uint256 tokenId,
1334         bytes calldata data
1335     ) external returns (bytes4);
1336 }
1337 
1338 
1339 
1340 // File 13: ERC721A.sol
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 
1345 error ApprovalCallerNotOwnerNorApproved();
1346 error ApprovalQueryForNonexistentToken();
1347 error ApproveToCaller();
1348 error ApprovalToCurrentOwner();
1349 error BalanceQueryForZeroAddress();
1350 error MintedQueryForZeroAddress();
1351 error BurnedQueryForZeroAddress();
1352 error MintToZeroAddress();
1353 error MintZeroQuantity();
1354 error OwnerIndexOutOfBounds();
1355 error OwnerQueryForNonexistentToken();
1356 error TokenIndexOutOfBounds();
1357 error TransferCallerNotOwnerNorApproved();
1358 error TransferFromIncorrectOwner();
1359 error TransferToNonERC721ReceiverImplementer();
1360 error TransferToZeroAddress();
1361 error URIQueryForNonexistentToken();
1362 
1363 /**
1364  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1365  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1366  *
1367  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1368  *
1369  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1370  *
1371  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1372  */
1373 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
1374     using Address for address;
1375     using Strings for uint256;
1376 
1377     // Compiler will pack this into a single 256bit word.
1378     struct TokenOwnership {
1379         // The address of the owner.
1380         address addr;
1381         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1382         uint64 startTimestamp;
1383         // Whether the token has been burned.
1384         bool burned;
1385     }
1386 
1387     // Compiler will pack this into a single 256bit word.
1388     struct AddressData {
1389         // Realistically, 2**64-1 is more than enough.
1390         uint64 balance;
1391         // Keeps track of mint count with minimal overhead for tokenomics.
1392         uint64 numberMinted;
1393         // Keeps track of burn count with minimal overhead for tokenomics.
1394         uint64 numberBurned;
1395     }
1396 
1397     // The tokenId of the next token to be minted.
1398     uint256 internal _currentIndex = 1;
1399 
1400     // The number of tokens burned.
1401     uint256 internal _burnCounter;
1402 
1403     // Token name
1404     string private _name;
1405 
1406     // Token symbol
1407     string private _symbol;
1408 
1409     //Allow all tokens to transfer to contract
1410     bool public allowedToContract = false;
1411 
1412     function setAllowToContract() external onlyOwner {
1413         allowedToContract = !allowedToContract;
1414     }
1415 
1416     // Mapping from token ID to ownership details
1417     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1418     mapping(uint256 => TokenOwnership) internal _ownerships;
1419 
1420     // Mapping owner address to address data
1421     mapping(address => AddressData) private _addressData;
1422 
1423     // Mapping from token ID to approved address
1424     mapping(uint256 => address) private _tokenApprovals;
1425 
1426     // Mapping from owner to operator approvals
1427     mapping(address => mapping(address => bool)) private _operatorApprovals;
1428 
1429     // Mapping token to allow to transfer to contract
1430     mapping(uint256 => bool) public _transferToContract;
1431 
1432 
1433 // Mapping from token ID to owner address
1434     mapping(uint256 => address) private _owners;
1435 
1436     // Mapping owner address to token count
1437     mapping(address => uint256) private _balances;
1438 
1439 
1440 
1441 
1442     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1443         _transferToContract[_tokenId] = _allow;
1444     }
1445 
1446     constructor(string memory name_, string memory symbol_) {
1447         _name = name_;
1448         _symbol = symbol_;
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Enumerable-totalSupply}.
1453      */
1454     function totalSupply() public view virtual override returns (uint256) {
1455         // Counter underflow is impossible as _burnCounter cannot be incremented
1456         // more than _currentIndex times
1457         unchecked {
1458             return _currentIndex - _burnCounter;    
1459         }
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Enumerable-tokenByIndex}.
1464      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1465      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1466      */
1467     function tokenByIndex(uint256 index) public view override returns (uint256) {
1468         uint256 numMintedSoFar = _currentIndex;
1469         uint256 tokenIdsIdx;
1470 
1471         // Counter overflow is impossible as the loop breaks when
1472         // uint256 i is equal to another uint256 numMintedSoFar.
1473         unchecked {
1474             for (uint256 i; i < numMintedSoFar; i++) {
1475                 TokenOwnership memory ownership = _ownerships[i];
1476                 if (!ownership.burned) {
1477                     if (tokenIdsIdx == index) {
1478                         return i;
1479                     }
1480                     tokenIdsIdx++;
1481                 }
1482             }
1483         }
1484         revert TokenIndexOutOfBounds();
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1489      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1490      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1491      */
1492     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1493         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1494         uint256 numMintedSoFar = _currentIndex;
1495         uint256 tokenIdsIdx;
1496         address currOwnershipAddr;
1497 
1498         // Counter overflow is impossible as the loop breaks when
1499         // uint256 i is equal to another uint256 numMintedSoFar.
1500         unchecked {
1501             for (uint256 i; i < numMintedSoFar; i++) {
1502                 TokenOwnership memory ownership = _ownerships[i];
1503                 if (ownership.burned) {
1504                     continue;
1505                 }
1506                 if (ownership.addr != address(0)) {
1507                     currOwnershipAddr = ownership.addr;
1508                 }
1509                 if (currOwnershipAddr == owner) {
1510                     if (tokenIdsIdx == index) {
1511                         return i;
1512                     }
1513                     tokenIdsIdx++;
1514                 }
1515             }
1516         }
1517 
1518         // Execution should never reach this point.
1519         revert();
1520     }
1521 
1522     /**
1523      * @dev See {IERC165-supportsInterface}.
1524      */
1525     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1526         return
1527             interfaceId == type(IERC721).interfaceId ||
1528             interfaceId == type(IERC721Metadata).interfaceId ||
1529             interfaceId == type(IERC721Enumerable).interfaceId ||
1530             super.supportsInterface(interfaceId);
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-balanceOf}.
1535      */
1536     function balanceOf(address owner) public view override returns (uint256) {
1537         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1538         return uint256(_addressData[owner].balance);
1539     }
1540 
1541     function _numberMinted(address owner) internal view returns (uint256) {
1542         if (owner == address(0)) revert MintedQueryForZeroAddress();
1543         return uint256(_addressData[owner].numberMinted);
1544     }
1545 
1546     function _numberBurned(address owner) internal view returns (uint256) {
1547         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1548         return uint256(_addressData[owner].numberBurned);
1549     }
1550 
1551     /**
1552      * Gas spent here starts off proportional to the maximum mint batch size.
1553      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1554      */
1555     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1556         uint256 curr = tokenId;
1557 
1558         unchecked {
1559             if (curr < _currentIndex) {
1560                 TokenOwnership memory ownership = _ownerships[curr];
1561                 if (!ownership.burned) {
1562                     if (ownership.addr != address(0)) {
1563                         return ownership;
1564                     }
1565                     // Invariant: 
1566                     // There will always be an ownership that has an address and is not burned 
1567                     // before an ownership that does not have an address and is not burned.
1568                     // Hence, curr will not underflow.
1569                     while (true) {
1570                         curr--;
1571                         ownership = _ownerships[curr];
1572                         if (ownership.addr != address(0)) {
1573                             return ownership;
1574                         }
1575                     }
1576                 }
1577             }
1578         }
1579         revert OwnerQueryForNonexistentToken();
1580     }
1581 
1582     /**
1583      * @dev See {IERC721-ownerOf}.
1584      */
1585     function ownerOf(uint256 tokenId) public view override returns (address) {
1586         return ownershipOf(tokenId).addr;
1587     }
1588 
1589     /**
1590      * @dev See {IERC721Metadata-name}.
1591      */
1592     function name() public view virtual override returns (string memory) {
1593         return _name;
1594     }
1595 
1596     /**
1597      * @dev See {IERC721Metadata-symbol}.
1598      */
1599     function symbol() public view virtual override returns (string memory) {
1600         return _symbol;
1601     }
1602 
1603     /**
1604      * @dev See {IERC721Metadata-tokenURI}.
1605      */
1606     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
1607         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1608 
1609         string memory baseURI = _baseURI();
1610         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1611     }
1612 
1613     /**
1614      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1615      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1616      * by default, can be overriden in child contracts.
1617      */
1618     function _baseURI() internal view virtual returns (string memory) {
1619         return '';
1620     }
1621 
1622     /**
1623      * @dev See {IERC721-approve}.
1624      */
1625     function approve(address to, uint256 tokenId) public override {
1626         address owner = ERC721A.ownerOf(tokenId);
1627         if (to == owner) revert ApprovalToCurrentOwner();
1628 
1629         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1630             revert ApprovalCallerNotOwnerNorApproved();
1631         }
1632         if(!allowedToContract && !_transferToContract[tokenId]){
1633             if (to.isContract()) {
1634                 revert ("Token transfer to contract address is not allowed.");
1635             } else {
1636                 _approve(to, tokenId, owner);
1637             }
1638         } else {
1639             _approve(to, tokenId, owner);
1640         }
1641     }
1642 
1643     /**
1644      * @dev See {IERC721-getApproved}.
1645      */
1646     function getApproved(uint256 tokenId) public view override returns (address) {
1647         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1648 
1649         return _tokenApprovals[tokenId];
1650     }
1651 
1652     /**
1653      * @dev See {IERC721-setApprovalForAll}.
1654      */
1655     function setApprovalForAll(address operator, bool approved) public override {
1656         if (operator == _msgSender()) revert ApproveToCaller();
1657         
1658         if(!allowedToContract){
1659             if (operator.isContract()) {
1660                 revert ("Token transfer to contract address is not allowed.");
1661             } else {
1662                 _operatorApprovals[_msgSender()][operator] = approved;
1663                 emit ApprovalForAll(_msgSender(), operator, approved);
1664             }
1665         } else {
1666             _operatorApprovals[_msgSender()][operator] = approved;
1667             emit ApprovalForAll(_msgSender(), operator, approved);
1668         }
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-isApprovedForAll}.
1673      */
1674     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1675         return _operatorApprovals[owner][operator];
1676     }
1677 
1678     /**
1679      * @dev See {IERC721-transferFrom}.
1680      */
1681     function transferFrom(
1682         address from,
1683         address to,
1684         uint256 tokenId
1685     ) public virtual override {
1686         _transfer(from, to, tokenId);
1687     }
1688 
1689     /**
1690      * @dev See {IERC721-safeTransferFrom}.
1691      */
1692     function safeTransferFrom(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) public virtual override {
1697         safeTransferFrom(from, to, tokenId, '');
1698     }
1699 
1700     /**
1701      * @dev See {IERC721-safeTransferFrom}.
1702      */
1703     function safeTransferFrom(
1704         address from,
1705         address to,
1706         uint256 tokenId,
1707         bytes memory _data
1708     ) public virtual override {
1709         _transfer(from, to, tokenId);
1710         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1711             revert TransferToNonERC721ReceiverImplementer();
1712         }
1713     }
1714 
1715     /**
1716      * @dev Returns whether `tokenId` exists.
1717      *
1718      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1719      *
1720      * Tokens start existing when they are minted (`_mint`),
1721      */
1722     function _exists(uint256 tokenId) internal view returns (bool) {
1723         require(tokenId > 0, "Invalid TokenId");
1724         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1725     }
1726 
1727     function _safeMint(address to, uint256 quantity) internal {
1728         _safeMint(to, quantity, '');
1729     }
1730 
1731     /**
1732      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1733      *
1734      * Requirements:
1735      *
1736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1737      * - `quantity` must be greater than 0.
1738      *
1739      * Emits a {Transfer} event.
1740      */
1741     function _safeMint(
1742         address to,
1743         uint256 quantity,
1744         bytes memory _data
1745     ) internal {
1746         _mint(to, quantity, _data, true);
1747     }
1748 
1749     /**
1750      * @dev Mints `quantity` tokens and transfers them to `to`.
1751      *
1752      * Requirements:
1753      *
1754      * - `to` cannot be the zero address.
1755      * - `quantity` must be greater than 0.
1756      *
1757      * Emits a {Transfer} event.
1758      */
1759     function _mint(
1760         address to,
1761         uint256 quantity,
1762         bytes memory _data,
1763         bool safe
1764     ) internal {
1765         uint256 startTokenId = _currentIndex;
1766         if (to == address(0)) revert MintToZeroAddress();
1767         if (quantity == 0) revert MintZeroQuantity();
1768 
1769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1770 
1771         // Overflows are incredibly unrealistic.
1772         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1773         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1774         unchecked {
1775             _addressData[to].balance += uint64(quantity);
1776             _addressData[to].numberMinted += uint64(quantity);
1777 
1778             _ownerships[startTokenId].addr = to;
1779             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1780 
1781             uint256 updatedIndex = startTokenId;
1782 
1783             for (uint256 i; i < quantity; i++) {
1784                 emit Transfer(address(0), to, updatedIndex);
1785                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1786                     revert TransferToNonERC721ReceiverImplementer();
1787                 }
1788                 updatedIndex++;
1789             }
1790 
1791             _currentIndex = updatedIndex;
1792         }
1793         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1794     }
1795 
1796     /**
1797      * @dev Transfers `tokenId` from `from` to `to`.
1798      *
1799      * Requirements:
1800      *
1801      * - `to` cannot be the zero address.
1802      * - `tokenId` token must be owned by `from`.
1803      *
1804      * Emits a {Transfer} event.
1805      */
1806     function _transfer(
1807         address from,
1808         address to,
1809         uint256 tokenId
1810     ) private {
1811         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1812 
1813         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1814             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1815             getApproved(tokenId) == _msgSender());
1816 
1817         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1818         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1819         if (to == address(0)) revert TransferToZeroAddress();
1820 
1821         _beforeTokenTransfers(from, to, tokenId, 1);
1822 
1823         // Clear approvals from the previous owner
1824         _approve(address(0), tokenId, prevOwnership.addr);
1825 
1826         // Underflow of the sender's balance is impossible because we check for
1827         // ownership above and the recipient's balance can't realistically overflow.
1828         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1829         unchecked {
1830             _addressData[from].balance -= 1;
1831             _addressData[to].balance += 1;
1832 
1833             _ownerships[tokenId].addr = to;
1834             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1835 
1836             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1837             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1838             uint256 nextTokenId = tokenId + 1;
1839             if (_ownerships[nextTokenId].addr == address(0)) {
1840                 // This will suffice for checking _exists(nextTokenId),
1841                 // as a burned slot cannot contain the zero address.
1842                 if (nextTokenId < _currentIndex) {
1843                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1844                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1845                 }
1846             }
1847         }
1848 
1849         emit Transfer(from, to, tokenId);
1850         _afterTokenTransfers(from, to, tokenId, 1);
1851     }
1852 
1853     /**
1854      * @dev Destroys `tokenId`.
1855      * The approval is cleared when the token is burned.
1856      *
1857      * Requirements:
1858      *
1859      * - `tokenId` must exist.
1860      *
1861      * Emits a {Transfer} event.
1862      */
1863     function _burn(uint256 tokenId) internal virtual {
1864         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1865 
1866         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1867 
1868         // Clear approvals from the previous owner
1869         _approve(address(0), tokenId, prevOwnership.addr);
1870 
1871         // Underflow of the sender's balance is impossible because we check for
1872         // ownership above and the recipient's balance can't realistically overflow.
1873         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1874         unchecked {
1875             _addressData[prevOwnership.addr].balance -= 1;
1876             _addressData[prevOwnership.addr].numberBurned += 1;
1877 
1878             // Keep track of who burned the token, and the timestamp of burning.
1879             _ownerships[tokenId].addr = prevOwnership.addr;
1880             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1881             _ownerships[tokenId].burned = true;
1882 
1883             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1884             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1885             uint256 nextTokenId = tokenId + 1;
1886             if (_ownerships[nextTokenId].addr == address(0)) {
1887                 // This will suffice for checking _exists(nextTokenId),
1888                 // as a burned slot cannot contain the zero address.
1889                 if (nextTokenId < _currentIndex) {
1890                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1891                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1892                 }
1893             }
1894         }
1895 
1896         emit Transfer(prevOwnership.addr, address(0), tokenId);
1897         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
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
1920      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1921      * The call is not executed if the target address is not a contract.
1922      *
1923      * @param from address representing the previous owner of the given token ID
1924      * @param to target address that will receive the tokens
1925      * @param tokenId uint256 ID of the token to be transferred
1926      * @param _data bytes optional data to send along with the call
1927      * @return bool whether the call correctly returned the expected magic value
1928      */
1929     function _checkOnERC721Received(
1930         address from,
1931         address to,
1932         uint256 tokenId,
1933         bytes memory _data
1934     ) private returns (bool) {
1935         if(!allowedToContract && !_transferToContract[tokenId]){
1936             if (to.isContract()) {
1937                 revert ("Token transfer to contract address is not allowed.");
1938             } else {
1939                 return true;
1940             }
1941         } else {
1942             return true;
1943         }
1944     }
1945 
1946     /**
1947      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1948      * And also called before burning one token.
1949      *
1950      * startTokenId - the first token id to be transferred
1951      * quantity - the amount to be transferred
1952      *
1953      * Calling conditions:
1954      *
1955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1956      * transferred to `to`.
1957      * - When `from` is zero, `tokenId` will be minted for `to`.
1958      * - When `to` is zero, `tokenId` will be burned by `from`.
1959      * - `from` and `to` are never both zero.
1960      */
1961     function _beforeTokenTransfers(
1962         address from,
1963         address to,
1964         uint256 startTokenId,
1965         uint256 quantity
1966     ) internal virtual {}
1967 
1968     /**
1969      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1970      * minting.
1971      * And also called after one token has been burned.
1972      *
1973      * startTokenId - the first token id to be transferred
1974      * quantity - the amount to be transferred
1975      *
1976      * Calling conditions:
1977      *
1978      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1979      * transferred to `to`.
1980      * - When `from` is zero, `tokenId` has been minted for `to`.
1981      * - When `to` is zero, `tokenId` has been burned by `from`.
1982      * - `from` and `to` are never both zero.
1983      */
1984     function _afterTokenTransfers(
1985         address from,
1986         address to,
1987         uint256 startTokenId,
1988         uint256 quantity
1989     ) internal virtual {}
1990 }
1991 
1992 // FILE 14: T12.sol
1993 
1994 
1995 contract DiscoveryNFT is ERC721A {
1996     using Strings for uint256;
1997     uint256 public cost;
1998     uint256 public maxSupply;
1999     string private BASE_URI;
2000     uint256 public MAX_MINT_AMOUNT_PER_TX;
2001     bool public IS_SALE_ACTIVE;
2002 
2003 
2004     constructor(
2005         uint256 price,
2006         uint256 max_Supply,
2007         string memory baseUri,
2008         uint256 maxMintPerTx,
2009         bool isSaleActive
2010     ) ERC721A("Discovery NFT Access Pass", "DNAP") {
2011         cost = price;
2012         maxSupply = max_Supply;
2013         BASE_URI = baseUri;
2014         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
2015         IS_SALE_ACTIVE = isSaleActive;
2016     }
2017 
2018 
2019     /** GETTERS **/
2020 
2021     function _baseURI() internal view virtual override returns (string memory) {
2022         return BASE_URI;
2023     }
2024 
2025     /** SETTERS **/
2026 
2027     function setPrice(uint256 customPrice) external onlyOwner {
2028         cost = customPrice;
2029     }
2030 
2031 
2032     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
2033         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
2034         maxSupply = newMaxSupply;
2035     }
2036 
2037     function setBaseURI(string memory customBaseURI_) external onlyOwner {
2038         BASE_URI = customBaseURI_;
2039     }
2040 
2041    
2042 
2043     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
2044         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
2045     }
2046 
2047     function setSaleActive(bool saleIsActive) external onlyOwner {
2048         IS_SALE_ACTIVE = saleIsActive;
2049     }
2050 
2051 
2052     /** MINT **/
2053 
2054     modifier mintCompliance(uint256 _mintAmount) {
2055         require(
2056             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
2057             "Invalid mint amount!"
2058         );
2059         require(
2060             _currentIndex + _mintAmount <= maxSupply,
2061             "Max supply exceeded!"
2062         );
2063         _;
2064     }
2065 
2066     function mint(uint256 _mintAmount)
2067         public
2068         payable
2069         mintCompliance(_mintAmount)
2070     {
2071         require(IS_SALE_ACTIVE, "Sale is not active!");
2072 
2073         uint256 price = cost * _mintAmount;
2074 
2075         require(msg.value >= price, "Insufficient funds!");
2076 
2077         _safeMint(msg.sender, _mintAmount);
2078     }
2079 
2080     function godMint(address _to, uint256 _mintAmount)
2081         public
2082         mintCompliance(_mintAmount)
2083         onlyOwner
2084     {
2085         _safeMint(_to, _mintAmount);
2086     }
2087 
2088     /** PAYOUT **/
2089 
2090     function withdraw() external onlyOwner {
2091         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2092         require(success, "Transfer failed.");
2093     }
2094 
2095 }