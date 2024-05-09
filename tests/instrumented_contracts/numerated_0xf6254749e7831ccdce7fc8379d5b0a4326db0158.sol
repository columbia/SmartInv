1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File 1: Address.sol
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
10 
11 pragma solidity ^0.8.1;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      *
34      * [IMPORTANT]
35      * ====
36      * You shouldn't rely on `isContract` to protect against flash loan attacks!
37      *
38      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
39      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
40      * constructor.
41      * ====
42      */
43     function isContract(address account) internal view returns (bool) {
44         // This method relies on extcodesize/address.code.length, which returns 0
45         // for contracts in construction, since the code is only stored at the end
46         // of the constructor execution.
47 
48         return account.code.length > 0;
49     }
50 
51     /**
52      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
53      * `recipient`, forwarding all available gas and reverting on errors.
54      *
55      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
56      * of certain opcodes, possibly making contracts go over the 2300 gas limit
57      * imposed by `transfer`, making them unable to receive funds via
58      * `transfer`. {sendValue} removes this limitation.
59      *
60      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
61      *
62      * IMPORTANT: because control is transferred to `recipient`, care must be
63      * taken to not create reentrancy vulnerabilities. Consider using
64      * {ReentrancyGuard} or the
65      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         (bool success, ) = recipient.call{value: amount}("");
71         require(success, "Address: unable to send value, recipient may have reverted");
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain `call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
98      * `errorMessage` as a fallback revert reason when `target` reverts.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
131      * with `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         require(isContract(target), "Address: call to non-contract");
143 
144         (bool success, bytes memory returndata) = target.call{value: value}(data);
145         return verifyCallResult(success, returndata, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal view returns (bytes memory) {
169         require(isContract(target), "Address: static call to non-contract");
170 
171         (bool success, bytes memory returndata) = target.staticcall(data);
172         return verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         require(isContract(target), "Address: delegate call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.delegatecall(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     /**
203      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
204      * revert reason using the provided one.
205      *
206      * _Available since v4.3._
207      */
208     function verifyCallResult(
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal pure returns (bytes memory) {
213         if (success) {
214             return returndata;
215         } else {
216             // Look for revert reason and bubble it up if present
217             if (returndata.length > 0) {
218                 // The easiest way to bubble the revert reason is using memory via assembly
219 
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 }
230 
231 
232 // FILE 2: Context.sol
233 pragma solidity ^0.8.0;
234 
235 /*
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 // File 3: Strings.sol
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev String operations.
264  */
265 library Strings {
266     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
270      */
271     function toString(uint256 value) internal pure returns (string memory) {
272         // Inspired by OraclizeAPI's implementation - MIT licence
273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
274 
275         if (value == 0) {
276             return "0";
277         }
278         uint256 temp = value;
279         uint256 digits;
280         while (temp != 0) {
281             digits++;
282             temp /= 10;
283         }
284         bytes memory buffer = new bytes(digits);
285         while (value != 0) {
286             digits -= 1;
287             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
288             value /= 10;
289         }
290         return string(buffer);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
295      */
296     function toHexString(uint256 value) internal pure returns (string memory) {
297         if (value == 0) {
298             return "0x00";
299         }
300         uint256 temp = value;
301         uint256 length = 0;
302         while (temp != 0) {
303             length++;
304             temp >>= 8;
305         }
306         return toHexString(value, length);
307     }
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
311      */
312     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
313         bytes memory buffer = new bytes(2 * length + 2);
314         buffer[0] = "0";
315         buffer[1] = "x";
316         for (uint256 i = 2 * length + 1; i > 1; --i) {
317             buffer[i] = _HEX_SYMBOLS[value & 0xf];
318             value >>= 4;
319         }
320         require(value == 0, "Strings: hex length insufficient");
321         return string(buffer);
322     }
323 }
324 
325 
326 // File: @openzeppelin/contracts/utils/Counters.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title Counters
335  * @author Matt Condon (@shrugs)
336  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
337  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
338  *
339  * Include with `using Counters for Counters.Counter;`
340  */
341 library Counters {
342     struct Counter {
343         // This variable should never be directly accessed by users of the library: interactions must be restricted to
344         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
345         // this feature: see https://github.com/ethereum/solidity/issues/4637
346         uint256 _value; // default: 0
347     }
348 
349     function current(Counter storage counter) internal view returns (uint256) {
350         return counter._value;
351     }
352 
353     function increment(Counter storage counter) internal {
354         unchecked {
355             counter._value += 1;
356         }
357     }
358 
359     function decrement(Counter storage counter) internal {
360         uint256 value = counter._value;
361         require(value > 0, "Counter: decrement overflow");
362         unchecked {
363             counter._value = value - 1;
364         }
365     }
366 
367     function reset(Counter storage counter) internal {
368         counter._value = 0;
369     }
370 }
371 
372 // File 4: Ownable.sol
373 
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Contract module which provides a basic access control mechanism, where
380  * there is an account (an owner) that can be granted exclusive access to
381  * specific functions.
382  *
383  * By default, the owner account will be the one that deploys the contract. This
384  * can later be changed with {transferOwnership}.
385  *
386  * This module is used through inheritance. It will make available the modifier
387  * `onlyOwner`, which can be applied to your functions to restrict their use to
388  * the owner.
389  */
390 abstract contract Ownable is Context {
391     address private _owner;
392 
393     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
394 
395     /**
396      * @dev Initializes the contract setting the deployer as the initial owner.
397      */
398     constructor () {
399         address msgSender = _msgSender();
400         _owner = msgSender;
401         emit OwnershipTransferred(address(0), msgSender);
402     }
403 
404     /**
405      * @dev Returns the address of the current owner.
406      */
407     function owner() public view virtual returns (address) {
408         return _owner;
409     }
410 
411     /**
412      * @dev Throws if called by any account other than the owner.
413      */
414     modifier onlyOwner() {
415         require(owner() == _msgSender(), "Ownable: caller is not the owner");
416         _;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         emit OwnershipTransferred(_owner, address(0));
428         _owner = address(0);
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Can only be called by the current owner.
434      */
435     function transferOwnership(address newOwner) public virtual onlyOwner {
436         require(newOwner != address(0), "Ownable: new owner is the zero address");
437         emit OwnershipTransferred(_owner, newOwner);
438         _owner = newOwner;
439     }
440 }
441 
442 
443 
444 
445 
446 // File 5: IERC165.sol
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Interface of the ERC165 standard, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-165[EIP].
453  *
454  * Implementers can declare support of contract interfaces, which can then be
455  * queried by others ({ERC165Checker}).
456  *
457  * For an implementation, see {ERC165}.
458  */
459 interface IERC165 {
460     /**
461      * @dev Returns true if this contract implements the interface defined by
462      * `interfaceId`. See the corresponding
463      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
464      * to learn more about how these ids are created.
465      *
466      * This function call must use less than 30 000 gas.
467      */
468     function supportsInterface(bytes4 interfaceId) external view returns (bool);
469 }
470 
471 
472 // File 6: IERC721.sol
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Required interface of an ERC721 compliant contract.
479  */
480 interface IERC721 is IERC165 {
481     /**
482      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
483      */
484     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
485 
486     /**
487      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
488      */
489     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
493      */
494     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
495 
496     /**
497      * @dev Returns the number of tokens in ``owner``'s account.
498      */
499     function balanceOf(address owner) external view returns (uint256 balance);
500 
501     /**
502      * @dev Returns the owner of the `tokenId` token.
503      *
504      * Requirements:
505      *
506      * - `tokenId` must exist.
507      */
508     function ownerOf(uint256 tokenId) external view returns (address owner);
509 
510     /**
511      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
512      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must exist and be owned by `from`.
519      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
521      *
522      * Emits a {Transfer} event.
523      */
524     function safeTransferFrom(address from, address to, uint256 tokenId) external;
525 
526     /**
527      * @dev Transfers `tokenId` token from `from` to `to`.
528      *
529      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
537      *
538      * Emits a {Transfer} event.
539      */
540     function transferFrom(address from, address to, uint256 tokenId) external;
541 
542     /**
543      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
544      * The approval is cleared when the token is transferred.
545      *
546      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
547      *
548      * Requirements:
549      *
550      * - The caller must own the token or be an approved operator.
551      * - `tokenId` must exist.
552      *
553      * Emits an {Approval} event.
554      */
555     function approve(address to, uint256 tokenId) external;
556 
557     /**
558      * @dev Returns the account approved for `tokenId` token.
559      *
560      * Requirements:
561      *
562      * - `tokenId` must exist.
563      */
564     function getApproved(uint256 tokenId) external view returns (address operator);
565 
566     /**
567      * @dev Approve or remove `operator` as an operator for the caller.
568      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
569      *
570      * Requirements:
571      *
572      * - The `operator` cannot be the caller.
573      *
574      * Emits an {ApprovalForAll} event.
575      */
576     function setApprovalForAll(address operator, bool _approved) external;
577 
578     /**
579      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
580      *
581      * See {setApprovalForAll}
582      */
583     function isApprovedForAll(address owner, address operator) external view returns (bool);
584 
585     /**
586       * @dev Safely transfers `tokenId` token from `from` to `to`.
587       *
588       * Requirements:
589       *
590       * - `from` cannot be the zero address.
591       * - `to` cannot be the zero address.
592       * - `tokenId` token must exist and be owned by `from`.
593       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595       *
596       * Emits a {Transfer} event.
597       */
598     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
599 }
600 
601 
602 
603 // File 7: IERC721Metadata.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
613  * @dev See https://eips.ethereum.org/EIPS/eip-721
614  */
615 interface IERC721Metadata is IERC721 {
616     /**
617      * @dev Returns the token collection name.
618      */
619     function name() external view returns (string memory);
620 
621     /**
622      * @dev Returns the token collection symbol.
623      */
624     function symbol() external view returns (string memory);
625 
626     /**
627      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
628      */
629     function tokenURI(uint256 tokenId) external returns (string memory);
630 }
631 
632 
633 
634 
635 // File 8: ERC165.sol
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @dev Implementation of the {IERC165} interface.
644  *
645  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
646  * for the additional interface id that will be supported. For example:
647  *
648  * ```solidity
649  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
651  * }
652  * ```
653  *
654  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
655  */
656 abstract contract ERC165 is IERC165 {
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661         return interfaceId == type(IERC165).interfaceId;
662     }
663 }
664 
665 
666 // File 9: ERC721.sol
667 
668 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
675  * the Metadata extension, but not including the Enumerable extension, which is available separately as
676  * {ERC721Enumerable}.
677  */
678 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
679     using Address for address;
680     using Strings for uint256;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to owner address
689     mapping(uint256 => address) private _owners;
690 
691     // Mapping owner address to token count
692     mapping(address => uint256) private _balances;
693 
694     // Mapping from token ID to approved address
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     /**
701      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
702      */
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view virtual override returns (uint256) {
722         require(owner != address(0), "ERC721: balance query for the zero address");
723         return _balances[owner];
724     }
725 
726     /**
727      * @dev See {IERC721-ownerOf}.
728      */
729     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
730         address owner = _owners[tokenId];
731         require(owner != address(0), "ERC721: owner query for nonexistent token");
732         return owner;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-name}.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-symbol}.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-tokenURI}.
751      */
752     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
753         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
754 
755         string memory baseURI = _baseURI();
756         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
757     }
758 
759     /**
760      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
761      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
762      * by default, can be overridden in child contracts.
763      */
764     function _baseURI() internal view virtual returns (string memory) {
765         return "";
766     }
767 
768     /**
769      * @dev See {IERC721-approve}.
770      */
771     function approve(address to, uint256 tokenId) public virtual override {
772         address owner = ERC721.ownerOf(tokenId);
773         require(to != owner, "ERC721: approval to current owner");
774 
775         require(
776             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
777             "ERC721: approve caller is not owner nor approved for all"
778         );
779         if (to.isContract()) {
780             revert ("Token transfer to contract address is not allowed.");
781         } else {
782             _approve(to, tokenId);
783         }
784         // _approve(to, tokenId);
785     }
786 
787     /**
788      * @dev See {IERC721-getApproved}.
789      */
790     function getApproved(uint256 tokenId) public view virtual override returns (address) {
791         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
792 
793         return _tokenApprovals[tokenId];
794     }
795 
796     /**
797      * @dev See {IERC721-setApprovalForAll}.
798      */
799     function setApprovalForAll(address operator, bool approved) public virtual override {
800         _setApprovalForAll(_msgSender(), operator, approved);
801     }
802 
803     /**
804      * @dev See {IERC721-isApprovedForAll}.
805      */
806     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
807         return _operatorApprovals[owner][operator];
808     }
809 
810     /**
811      * @dev See {IERC721-transferFrom}.
812      */
813     function transferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) public virtual override {
818         //solhint-disable-next-line max-line-length
819         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
820 
821         _transfer(from, to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public virtual override {
832         safeTransferFrom(from, to, tokenId, "");
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) public virtual override {
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845         _safeTransfer(from, to, tokenId, _data);
846     }
847 
848     /**
849      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
850      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
851      *
852      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
853      *
854      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
855      * implement alternative mechanisms to perform token transfer, such as signature-based.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _safeTransfer(
867         address from,
868         address to,
869         uint256 tokenId,
870         bytes memory _data
871     ) internal virtual {
872         _transfer(from, to, tokenId);
873         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
874     }
875 
876     /**
877      * @dev Returns whether `tokenId` exists.
878      *
879      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
880      *
881      * Tokens start existing when they are minted (`_mint`),
882      * and stop existing when they are burned (`_burn`).
883      */
884     function _exists(uint256 tokenId) internal view virtual returns (bool) {
885         return _owners[tokenId] != address(0);
886     }
887 
888     /**
889      * @dev Returns whether `spender` is allowed to manage `tokenId`.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      */
895     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
896         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
897         address owner = ERC721.ownerOf(tokenId);
898         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
899     }
900 
901     /**
902      * @dev Safely mints `tokenId` and transfers it to `to`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must not exist.
907      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeMint(address to, uint256 tokenId) internal virtual {
912         _safeMint(to, tokenId, "");
913     }
914 
915     /**
916      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
917      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
918      */
919     function _safeMint(
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _mint(to, tokenId);
925         require(
926             _checkOnERC721Received(address(0), to, tokenId, _data),
927             "ERC721: transfer to non ERC721Receiver implementer"
928         );
929     }
930 
931     /**
932      * @dev Mints `tokenId` and transfers it to `to`.
933      *
934      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - `to` cannot be the zero address.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(address to, uint256 tokenId) internal virtual {
944         require(to != address(0), "ERC721: mint to the zero address");
945         require(!_exists(tokenId), "ERC721: token already minted");
946 
947         _beforeTokenTransfer(address(0), to, tokenId);
948 
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(address(0), to, tokenId);
953 
954         _afterTokenTransfer(address(0), to, tokenId);
955     }
956 
957     /**
958      * @dev Destroys `tokenId`.
959      * The approval is cleared when the token is burned.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _burn(uint256 tokenId) internal virtual {
968         address owner = ERC721.ownerOf(tokenId);
969 
970         _beforeTokenTransfer(owner, address(0), tokenId);
971 
972         // Clear approvals
973         _approve(address(0), tokenId);
974 
975         _balances[owner] -= 1;
976         delete _owners[tokenId];
977 
978         emit Transfer(owner, address(0), tokenId);
979 
980         _afterTokenTransfer(owner, address(0), tokenId);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
986      *
987      * Requirements:
988      *
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must be owned by `from`.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _transfer(
995         address from,
996         address to,
997         uint256 tokenId
998     ) internal virtual {
999         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1000         require(to != address(0), "ERC721: transfer to the zero address");
1001 
1002         _beforeTokenTransfer(from, to, tokenId);
1003 
1004         // Clear approvals from the previous owner
1005         _approve(address(0), tokenId);
1006 
1007         _balances[from] -= 1;
1008         _balances[to] += 1;
1009         _owners[tokenId] = to;
1010 
1011         emit Transfer(from, to, tokenId);
1012 
1013         _afterTokenTransfer(from, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Approve `to` to operate on `tokenId`
1018      *
1019      * Emits a {Approval} event.
1020      */
1021     function _approve(address to, uint256 tokenId) internal virtual {
1022         _tokenApprovals[tokenId] = to;
1023         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Approve `operator` to operate on all of `owner` tokens
1028      *
1029      * Emits a {ApprovalForAll} event.
1030      */
1031     function _setApprovalForAll(
1032         address owner,
1033         address operator,
1034         bool approved
1035     ) internal virtual {
1036         require(owner != operator, "ERC721: approve to caller");
1037         _operatorApprovals[owner][operator] = approved;
1038         emit ApprovalForAll(owner, operator, approved);
1039     }
1040 
1041     /**
1042      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1043      * The call is not executed if the target address is not a contract.
1044      *
1045      * @param from address representing the previous owner of the given token ID
1046      * @param to target address that will receive the tokens
1047      * @param tokenId uint256 ID of the token to be transferred
1048      * @param _data bytes optional data to send along with the call
1049      * @return bool whether the call correctly returned the expected magic value
1050      */
1051     function _checkOnERC721Received(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) private returns (bool) {
1057         if (to.isContract()) {
1058             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1059                 return retval == IERC721Receiver.onERC721Received.selector;
1060             } catch (bytes memory reason) {
1061                 if (reason.length == 0) {
1062                     revert("ERC721: transfer to non ERC721Receiver implementer");
1063                 } else {
1064                     assembly {
1065                         revert(add(32, reason), mload(reason))
1066                     }
1067                 }
1068             }
1069         } else {
1070             return true;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` and `to` are never both zero.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {}
1093 
1094     /**
1095      * @dev Hook that is called after any transfer of tokens. This includes
1096      * minting and burning.
1097      *
1098      * Calling conditions:
1099      *
1100      * - when `from` and `to` are both non-zero.
1101      * - `from` and `to` are never both zero.
1102      *
1103      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1104      */
1105     function _afterTokenTransfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) internal virtual {}
1110 }
1111 
1112 
1113 
1114 
1115 
1116 // File 10: IERC721Enumerable.sol
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1123  * @dev See https://eips.ethereum.org/EIPS/eip-721
1124  */
1125 interface IERC721Enumerable is IERC721 {
1126 
1127     /**
1128      * @dev Returns the total amount of tokens stored by the contract.
1129      */
1130     function totalSupply() external view returns (uint256);
1131 
1132     /**
1133      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1134      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1135      */
1136     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1137 
1138     /**
1139      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1140      * Use along with {totalSupply} to enumerate all tokens.
1141      */
1142     function tokenByIndex(uint256 index) external view returns (uint256);
1143 }
1144 
1145 
1146 
1147 
1148 
1149 
1150 // File 11: ERC721Enumerable.sol
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 
1155 /**
1156  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1157  * enumerability of all the token ids in the contract as well as all token ids owned by each
1158  * account.
1159  */
1160 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1161     // Mapping from owner to list of owned token IDs
1162     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1163 
1164     // Mapping from token ID to index of the owner tokens list
1165     mapping(uint256 => uint256) private _ownedTokensIndex;
1166 
1167     // Array with all token ids, used for enumeration
1168     uint256[] private _allTokens;
1169 
1170     // Mapping from token id to position in the allTokens array
1171     mapping(uint256 => uint256) private _allTokensIndex;
1172 
1173     /**
1174      * @dev See {IERC165-supportsInterface}.
1175      */
1176     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1177         return interfaceId == type(IERC721Enumerable).interfaceId
1178             || super.supportsInterface(interfaceId);
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1183      */
1184     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1185         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1186         return _ownedTokens[owner][index];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Enumerable-totalSupply}.
1191      */
1192     function totalSupply() public view virtual override returns (uint256) {
1193         return _allTokens.length;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Enumerable-tokenByIndex}.
1198      */
1199     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1200         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1201         return _allTokens[index];
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before any token transfer. This includes minting
1206      * and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` will be minted for `to`.
1213      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1214      * - `from` cannot be the zero address.
1215      * - `to` cannot be the zero address.
1216      *
1217      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1218      */
1219     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1220         super._beforeTokenTransfer(from, to, tokenId);
1221 
1222         if (from == address(0)) {
1223             _addTokenToAllTokensEnumeration(tokenId);
1224         } else if (from != to) {
1225             _removeTokenFromOwnerEnumeration(from, tokenId);
1226         }
1227         if (to == address(0)) {
1228             _removeTokenFromAllTokensEnumeration(tokenId);
1229         } else if (to != from) {
1230             _addTokenToOwnerEnumeration(to, tokenId);
1231         }
1232     }
1233 
1234     /**
1235      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1236      * @param to address representing the new owner of the given token ID
1237      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1238      */
1239     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1240         uint256 length = ERC721.balanceOf(to);
1241         _ownedTokens[to][length] = tokenId;
1242         _ownedTokensIndex[tokenId] = length;
1243     }
1244 
1245     /**
1246      * @dev Private function to add a token to this extension's token tracking data structures.
1247      * @param tokenId uint256 ID of the token to be added to the tokens list
1248      */
1249     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1250         _allTokensIndex[tokenId] = _allTokens.length;
1251         _allTokens.push(tokenId);
1252     }
1253 
1254     /**
1255      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1256      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1257      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1258      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1259      * @param from address representing the previous owner of the given token ID
1260      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1261      */
1262     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1263         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1264         // then delete the last slot (swap and pop).
1265 
1266         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1267         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1268 
1269         // When the token to delete is the last token, the swap operation is unnecessary
1270         if (tokenIndex != lastTokenIndex) {
1271             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1272 
1273             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1274             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1275         }
1276 
1277         // This also deletes the contents at the last position of the array
1278         delete _ownedTokensIndex[tokenId];
1279         delete _ownedTokens[from][lastTokenIndex];
1280     }
1281 
1282     /**
1283      * @dev Private function to remove a token from this extension's token tracking data structures.
1284      * This has O(1) time complexity, but alters the order of the _allTokens array.
1285      * @param tokenId uint256 ID of the token to be removed from the tokens list
1286      */
1287     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1288         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1289         // then delete the last slot (swap and pop).
1290 
1291         uint256 lastTokenIndex = _allTokens.length - 1;
1292         uint256 tokenIndex = _allTokensIndex[tokenId];
1293 
1294         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1295         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1296         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1297         uint256 lastTokenId = _allTokens[lastTokenIndex];
1298 
1299         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1300         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1301 
1302         // This also deletes the contents at the last position of the array
1303         delete _allTokensIndex[tokenId];
1304         _allTokens.pop();
1305     }
1306 }
1307 
1308 
1309 
1310 // File 12: IERC721Receiver.sol
1311 
1312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 /**
1317  * @title ERC721 token receiver interface
1318  * @dev Interface for any contract that wants to support safeTransfers
1319  * from ERC721 asset contracts.
1320  */
1321 interface IERC721Receiver {
1322     /**
1323      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1324      * by `operator` from `from`, this function is called.
1325      *
1326      * It must return its Solidity selector to confirm the token transfer.
1327      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1328      *
1329      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1330      */
1331     function onERC721Received(
1332         address operator,
1333         address from,
1334         uint256 tokenId,
1335         bytes calldata data
1336     ) external returns (bytes4);
1337 }
1338 
1339 
1340 
1341 // File 13: ERC721A.sol
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 error ApprovalCallerNotOwnerNorApproved();
1347 error ApprovalQueryForNonexistentToken();
1348 error ApproveToCaller();
1349 error ApprovalToCurrentOwner();
1350 error BalanceQueryForZeroAddress();
1351 error MintedQueryForZeroAddress();
1352 error BurnedQueryForZeroAddress();
1353 error MintToZeroAddress();
1354 error MintZeroQuantity();
1355 error OwnerIndexOutOfBounds();
1356 error OwnerQueryForNonexistentToken();
1357 error TokenIndexOutOfBounds();
1358 error TransferCallerNotOwnerNorApproved();
1359 error TransferFromIncorrectOwner();
1360 error TransferToNonERC721ReceiverImplementer();
1361 error TransferToZeroAddress();
1362 error URIQueryForNonexistentToken();
1363 
1364 /**
1365  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1366  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1367  *
1368  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1369  *
1370  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1371  *
1372  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1373  */
1374 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
1375     using Address for address;
1376     using Strings for uint256;
1377 
1378     // Compiler will pack this into a single 256bit word.
1379     struct TokenOwnership {
1380         // The address of the owner.
1381         address addr;
1382         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1383         uint64 startTimestamp;
1384         // Whether the token has been burned.
1385         bool burned;
1386     }
1387 
1388     // Compiler will pack this into a single 256bit word.
1389     struct AddressData {
1390         // Realistically, 2**64-1 is more than enough.
1391         uint64 balance;
1392         // Keeps track of mint count with minimal overhead for tokenomics.
1393         uint64 numberMinted;
1394         // Keeps track of burn count with minimal overhead for tokenomics.
1395         uint64 numberBurned;
1396     }
1397 
1398     // The tokenId of the next token to be minted.
1399     uint256 internal _currentIndex = 1;
1400 
1401     // The number of tokens burned.
1402     uint256 internal _burnCounter;
1403 
1404     // Token name
1405     string private _name;
1406 
1407     // Token symbol
1408     string private _symbol;
1409 
1410     //Allow all tokens to transfer to contract
1411     bool public allowedToContract = false;
1412 
1413     function setAllowToContract() external onlyOwner {
1414         allowedToContract = !allowedToContract;
1415     }
1416 
1417     // Mapping from token ID to ownership details
1418     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1419     mapping(uint256 => TokenOwnership) internal _ownerships;
1420 
1421     // Mapping owner address to address data
1422     mapping(address => AddressData) private _addressData;
1423 
1424     // Mapping from token ID to approved address
1425     mapping(uint256 => address) private _tokenApprovals;
1426 
1427     // Mapping from owner to operator approvals
1428     mapping(address => mapping(address => bool)) private _operatorApprovals;
1429 
1430     // Mapping token to allow to transfer to contract
1431     mapping(uint256 => bool) public _transferToContract;
1432 
1433 
1434 // Mapping from token ID to owner address
1435     mapping(uint256 => address) private _owners;
1436 
1437     // Mapping owner address to token count
1438     mapping(address => uint256) private _balances;
1439 
1440 
1441 
1442 
1443     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1444         _transferToContract[_tokenId] = _allow;
1445     }
1446 
1447     constructor(string memory name_, string memory symbol_) {
1448         _name = name_;
1449         _symbol = symbol_;
1450     }
1451 
1452     /**
1453      * @dev See {IERC721Enumerable-totalSupply}.
1454      */
1455     function totalSupply() public view virtual override returns (uint256) {
1456         // Counter underflow is impossible as _burnCounter cannot be incremented
1457         // more than _currentIndex times
1458         unchecked {
1459             return _currentIndex - _burnCounter;    
1460         }
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Enumerable-tokenByIndex}.
1465      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1466      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1467      */
1468     function tokenByIndex(uint256 index) public view override returns (uint256) {
1469         uint256 numMintedSoFar = _currentIndex;
1470         uint256 tokenIdsIdx;
1471 
1472         // Counter overflow is impossible as the loop breaks when
1473         // uint256 i is equal to another uint256 numMintedSoFar.
1474         unchecked {
1475             for (uint256 i; i < numMintedSoFar; i++) {
1476                 TokenOwnership memory ownership = _ownerships[i];
1477                 if (!ownership.burned) {
1478                     if (tokenIdsIdx == index) {
1479                         return i;
1480                     }
1481                     tokenIdsIdx++;
1482                 }
1483             }
1484         }
1485         revert TokenIndexOutOfBounds();
1486     }
1487 
1488     /**
1489      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1490      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1491      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1492      */
1493     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1494         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1495         uint256 numMintedSoFar = _currentIndex;
1496         uint256 tokenIdsIdx;
1497         address currOwnershipAddr;
1498 
1499         // Counter overflow is impossible as the loop breaks when
1500         // uint256 i is equal to another uint256 numMintedSoFar.
1501         unchecked {
1502             for (uint256 i; i < numMintedSoFar; i++) {
1503                 TokenOwnership memory ownership = _ownerships[i];
1504                 if (ownership.burned) {
1505                     continue;
1506                 }
1507                 if (ownership.addr != address(0)) {
1508                     currOwnershipAddr = ownership.addr;
1509                 }
1510                 if (currOwnershipAddr == owner) {
1511                     if (tokenIdsIdx == index) {
1512                         return i;
1513                     }
1514                     tokenIdsIdx++;
1515                 }
1516             }
1517         }
1518 
1519         // Execution should never reach this point.
1520         revert();
1521     }
1522 
1523     /**
1524      * @dev See {IERC165-supportsInterface}.
1525      */
1526     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1527         return
1528             interfaceId == type(IERC721).interfaceId ||
1529             interfaceId == type(IERC721Metadata).interfaceId ||
1530             interfaceId == type(IERC721Enumerable).interfaceId ||
1531             super.supportsInterface(interfaceId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-balanceOf}.
1536      */
1537     function balanceOf(address owner) public view override returns (uint256) {
1538         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1539         return uint256(_addressData[owner].balance);
1540     }
1541 
1542     function _numberMinted(address owner) internal view returns (uint256) {
1543         if (owner == address(0)) revert MintedQueryForZeroAddress();
1544         return uint256(_addressData[owner].numberMinted);
1545     }
1546 
1547     function _numberBurned(address owner) internal view returns (uint256) {
1548         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1549         return uint256(_addressData[owner].numberBurned);
1550     }
1551 
1552     /**
1553      * Gas spent here starts off proportional to the maximum mint batch size.
1554      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1555      */
1556     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1557         uint256 curr = tokenId;
1558 
1559         unchecked {
1560             if (curr < _currentIndex) {
1561                 TokenOwnership memory ownership = _ownerships[curr];
1562                 if (!ownership.burned) {
1563                     if (ownership.addr != address(0)) {
1564                         return ownership;
1565                     }
1566                     // Invariant: 
1567                     // There will always be an ownership that has an address and is not burned 
1568                     // before an ownership that does not have an address and is not burned.
1569                     // Hence, curr will not underflow.
1570                     while (true) {
1571                         curr--;
1572                         ownership = _ownerships[curr];
1573                         if (ownership.addr != address(0)) {
1574                             return ownership;
1575                         }
1576                     }
1577                 }
1578             }
1579         }
1580         revert OwnerQueryForNonexistentToken();
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-ownerOf}.
1585      */
1586     function ownerOf(uint256 tokenId) public view override returns (address) {
1587         return ownershipOf(tokenId).addr;
1588     }
1589 
1590     /**
1591      * @dev See {IERC721Metadata-name}.
1592      */
1593     function name() public view virtual override returns (string memory) {
1594         return _name;
1595     }
1596 
1597     /**
1598      * @dev See {IERC721Metadata-symbol}.
1599      */
1600     function symbol() public view virtual override returns (string memory) {
1601         return _symbol;
1602     }
1603 
1604     /**
1605      * @dev See {IERC721Metadata-tokenURI}.
1606      */
1607     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
1608         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1609 
1610         string memory baseURI = _baseURI();
1611         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1612     }
1613 
1614     /**
1615      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1616      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1617      * by default, can be overriden in child contracts.
1618      */
1619     function _baseURI() internal view virtual returns (string memory) {
1620         return '';
1621     }
1622 
1623     /**
1624      * @dev See {IERC721-approve}.
1625      */
1626     function approve(address to, uint256 tokenId) public override {
1627         address owner = ERC721A.ownerOf(tokenId);
1628         if (to == owner) revert ApprovalToCurrentOwner();
1629 
1630         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1631             revert ApprovalCallerNotOwnerNorApproved();
1632         }
1633         if(!allowedToContract && !_transferToContract[tokenId]){
1634             if (to.isContract()) {
1635                 revert ("Token transfer to contract address is not allowed.");
1636             } else {
1637                 _approve(to, tokenId, owner);
1638             }
1639         } else {
1640             _approve(to, tokenId, owner);
1641         }
1642     }
1643 
1644     /**
1645      * @dev See {IERC721-getApproved}.
1646      */
1647     function getApproved(uint256 tokenId) public view override returns (address) {
1648         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1649 
1650         return _tokenApprovals[tokenId];
1651     }
1652 
1653     /**
1654      * @dev See {IERC721-setApprovalForAll}.
1655      */
1656     function setApprovalForAll(address operator, bool approved) public override {
1657         if (operator == _msgSender()) revert ApproveToCaller();
1658         
1659         if(!allowedToContract){
1660             if (operator.isContract()) {
1661                 revert ("Token transfer to contract address is not allowed.");
1662             } else {
1663                 _operatorApprovals[_msgSender()][operator] = approved;
1664                 emit ApprovalForAll(_msgSender(), operator, approved);
1665             }
1666         } else {
1667             _operatorApprovals[_msgSender()][operator] = approved;
1668             emit ApprovalForAll(_msgSender(), operator, approved);
1669         }
1670     }
1671 
1672     /**
1673      * @dev See {IERC721-isApprovedForAll}.
1674      */
1675     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1676         return _operatorApprovals[owner][operator];
1677     }
1678 
1679     /**
1680      * @dev See {IERC721-transferFrom}.
1681      */
1682     function transferFrom(
1683         address from,
1684         address to,
1685         uint256 tokenId
1686     ) public virtual override {
1687         _transfer(from, to, tokenId);
1688     }
1689 
1690     /**
1691      * @dev See {IERC721-safeTransferFrom}.
1692      */
1693     function safeTransferFrom(
1694         address from,
1695         address to,
1696         uint256 tokenId
1697     ) public virtual override {
1698         safeTransferFrom(from, to, tokenId, '');
1699     }
1700 
1701     /**
1702      * @dev See {IERC721-safeTransferFrom}.
1703      */
1704     function safeTransferFrom(
1705         address from,
1706         address to,
1707         uint256 tokenId,
1708         bytes memory _data
1709     ) public virtual override {
1710         _transfer(from, to, tokenId);
1711         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1712             revert TransferToNonERC721ReceiverImplementer();
1713         }
1714     }
1715 
1716     /**
1717      * @dev Returns whether `tokenId` exists.
1718      *
1719      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1720      *
1721      * Tokens start existing when they are minted (`_mint`),
1722      */
1723     function _exists(uint256 tokenId) internal view returns (bool) {
1724         require(tokenId > 0, "Invalid TokenId");
1725         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1726     }
1727 
1728     function _safeMint(address to, uint256 quantity) internal {
1729         _safeMint(to, quantity, '');
1730     }
1731 
1732     /**
1733      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1734      *
1735      * Requirements:
1736      *
1737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1738      * - `quantity` must be greater than 0.
1739      *
1740      * Emits a {Transfer} event.
1741      */
1742     function _safeMint(
1743         address to,
1744         uint256 quantity,
1745         bytes memory _data
1746     ) internal {
1747         _mint(to, quantity, _data, true);
1748     }
1749 
1750     /**
1751      * @dev Mints `quantity` tokens and transfers them to `to`.
1752      *
1753      * Requirements:
1754      *
1755      * - `to` cannot be the zero address.
1756      * - `quantity` must be greater than 0.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _mint(
1761         address to,
1762         uint256 quantity,
1763         bytes memory _data,
1764         bool safe
1765     ) internal {
1766         uint256 startTokenId = _currentIndex;
1767         if (to == address(0)) revert MintToZeroAddress();
1768         if (quantity == 0) revert MintZeroQuantity();
1769 
1770         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1771 
1772         // Overflows are incredibly unrealistic.
1773         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1774         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1775         unchecked {
1776             _addressData[to].balance += uint64(quantity);
1777             _addressData[to].numberMinted += uint64(quantity);
1778 
1779             _ownerships[startTokenId].addr = to;
1780             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1781 
1782             uint256 updatedIndex = startTokenId;
1783 
1784             for (uint256 i; i < quantity; i++) {
1785                 emit Transfer(address(0), to, updatedIndex);
1786                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1787                     revert TransferToNonERC721ReceiverImplementer();
1788                 }
1789                 updatedIndex++;
1790             }
1791 
1792             _currentIndex = updatedIndex;
1793         }
1794         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1795     }
1796 
1797     /**
1798      * @dev Transfers `tokenId` from `from` to `to`.
1799      *
1800      * Requirements:
1801      *
1802      * - `to` cannot be the zero address.
1803      * - `tokenId` token must be owned by `from`.
1804      *
1805      * Emits a {Transfer} event.
1806      */
1807     function _transfer(
1808         address from,
1809         address to,
1810         uint256 tokenId
1811     ) private {
1812         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1813 
1814         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1815             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1816             getApproved(tokenId) == _msgSender());
1817 
1818         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1819         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1820         if (to == address(0)) revert TransferToZeroAddress();
1821 
1822         _beforeTokenTransfers(from, to, tokenId, 1);
1823 
1824         // Clear approvals from the previous owner
1825         _approve(address(0), tokenId, prevOwnership.addr);
1826 
1827         // Underflow of the sender's balance is impossible because we check for
1828         // ownership above and the recipient's balance can't realistically overflow.
1829         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1830         unchecked {
1831             _addressData[from].balance -= 1;
1832             _addressData[to].balance += 1;
1833 
1834             _ownerships[tokenId].addr = to;
1835             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1836 
1837             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1838             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1839             uint256 nextTokenId = tokenId + 1;
1840             if (_ownerships[nextTokenId].addr == address(0)) {
1841                 // This will suffice for checking _exists(nextTokenId),
1842                 // as a burned slot cannot contain the zero address.
1843                 if (nextTokenId < _currentIndex) {
1844                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1845                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1846                 }
1847             }
1848         }
1849 
1850         emit Transfer(from, to, tokenId);
1851         _afterTokenTransfers(from, to, tokenId, 1);
1852     }
1853 
1854     /**
1855      * @dev Destroys `tokenId`.
1856      * The approval is cleared when the token is burned.
1857      *
1858      * Requirements:
1859      *
1860      * - `tokenId` must exist.
1861      *
1862      * Emits a {Transfer} event.
1863      */
1864     function _burn(uint256 tokenId) internal virtual {
1865         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1866 
1867         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1868 
1869         // Clear approvals from the previous owner
1870         _approve(address(0), tokenId, prevOwnership.addr);
1871 
1872         // Underflow of the sender's balance is impossible because we check for
1873         // ownership above and the recipient's balance can't realistically overflow.
1874         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1875         unchecked {
1876             _addressData[prevOwnership.addr].balance -= 1;
1877             _addressData[prevOwnership.addr].numberBurned += 1;
1878 
1879             // Keep track of who burned the token, and the timestamp of burning.
1880             _ownerships[tokenId].addr = prevOwnership.addr;
1881             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1882             _ownerships[tokenId].burned = true;
1883 
1884             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1885             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1886             uint256 nextTokenId = tokenId + 1;
1887             if (_ownerships[nextTokenId].addr == address(0)) {
1888                 // This will suffice for checking _exists(nextTokenId),
1889                 // as a burned slot cannot contain the zero address.
1890                 if (nextTokenId < _currentIndex) {
1891                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1892                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1893                 }
1894             }
1895         }
1896 
1897         emit Transfer(prevOwnership.addr, address(0), tokenId);
1898         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1899 
1900         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1901         unchecked { 
1902             _burnCounter++;
1903         }
1904     }
1905 
1906     /**
1907      * @dev Approve `to` to operate on `tokenId`
1908      *
1909      * Emits a {Approval} event.
1910      */
1911     function _approve(
1912         address to,
1913         uint256 tokenId,
1914         address owner
1915     ) private {
1916         _tokenApprovals[tokenId] = to;
1917         emit Approval(owner, to, tokenId);
1918     }
1919 
1920     /**
1921      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1922      * The call is not executed if the target address is not a contract.
1923      *
1924      * @param from address representing the previous owner of the given token ID
1925      * @param to target address that will receive the tokens
1926      * @param tokenId uint256 ID of the token to be transferred
1927      * @param _data bytes optional data to send along with the call
1928      * @return bool whether the call correctly returned the expected magic value
1929      */
1930     function _checkOnERC721Received(
1931         address from,
1932         address to,
1933         uint256 tokenId,
1934         bytes memory _data
1935     ) private returns (bool) {
1936         if(!allowedToContract && !_transferToContract[tokenId]){
1937             if (to.isContract()) {
1938                 revert ("Token transfer to contract address is not allowed.");
1939             } else {
1940                 return true;
1941             }
1942         } else {
1943             return true;
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
1993 // FILE 14: T12.sol
1994 
1995 pragma solidity ^0.8.0;
1996 
1997 contract GoblinApeIsland is ERC721A {
1998   using Strings for uint256;
1999   using Counters for Counters.Counter;
2000 
2001   Counters.Counter private supply;
2002 
2003   string private uriPrefix = "";
2004   string public uriSuffix = ".json";
2005   string private hiddenMetadataUri;
2006 
2007     constructor() ERC721A("GoblinApeIsland", "GBAIT") {
2008         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
2009     }
2010 
2011     uint256 public constant maxSupply = 7777;
2012     uint256 private mintCount = 0;
2013     uint256 public maxMintPerTx = 1;
2014     uint256 public maxMintPerWallet = 2;   
2015     uint256 public price = 0.0069 ether;
2016      
2017   bool public paused = false;
2018   bool public revealed = false;
2019 
2020 
2021   mapping (address => uint256) public addressMintedBalance;
2022 
2023 
2024     event Minted(uint256 totalMinted);
2025 
2026       
2027     function totalSupply() public view override returns (uint256) {
2028         return mintCount;
2029     }
2030 
2031     function changePrice(uint256 _newPrice) external onlyOwner {
2032         price = _newPrice;
2033     }
2034 
2035     function withdraw() external onlyOwner {
2036         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2037         require(success, "Transfer failed.");
2038     }
2039 
2040     function mint(uint256 _count) external payable {
2041 
2042         require(!paused, "The contract is paused!");
2043 
2044         require(totalSupply() + _count <= maxSupply, "Exceeds maximum supply");
2045         require(_count > 0, "Minimum 1 NFT has to be minted per transaction");
2046 
2047         if (msg.sender != owner()) {
2048             require(
2049                 _count <= maxMintPerTx,
2050                 "Maximum NFTs can be minted per transaction"
2051             );
2052             require(
2053                 msg.value >= price * _count,
2054                 "Ether sent with this transaction is not correct"
2055             );
2056 
2057             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2058             require (ownerMintedCount + _count <= maxMintPerWallet, "max per address exceeded!");
2059         }
2060 
2061         mintCount += _count;
2062         addressMintedBalance[msg.sender]+= _count;      
2063         _safeMint(msg.sender, _count);
2064         emit Minted(_count);       
2065     }
2066 
2067     function walletOfOwner(address _owner)
2068         public
2069         view
2070         returns (uint256[] memory)
2071     {
2072         uint256 ownerTokenCount = balanceOf(_owner);
2073         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2074         uint256 currentTokenId = 1;
2075         uint256 ownedTokenIndex = 0;
2076 
2077         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2078         address currentTokenOwner = ownerOf(currentTokenId);
2079 
2080         if (currentTokenOwner == _owner) {
2081             ownedTokenIds[ownedTokenIndex] = currentTokenId;
2082 
2083             ownedTokenIndex++;
2084         }
2085 
2086         currentTokenId++;
2087         }
2088 
2089         return ownedTokenIds;
2090     }
2091   
2092   function tokenURI(uint256 _tokenId)
2093     public
2094     /*view*/
2095     virtual
2096     override
2097     returns (string memory)
2098   {
2099     require(
2100       _exists(_tokenId),
2101       "ERC721Metadata: URI query for nonexistent token"
2102     );
2103 
2104     if (revealed == false) {
2105       return hiddenMetadataUri;
2106     }
2107 
2108     string memory currentBaseURI = _baseURI();
2109     return bytes(currentBaseURI).length > 0
2110         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2111         : "";
2112   }
2113 
2114   function setRevealed(bool _state) public onlyOwner {
2115     revealed = _state;
2116   }  
2117 
2118   function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
2119     maxMintPerTx = _maxMintPerTx;
2120   }
2121 
2122   function setMaxMintPerWallet(uint256 _maxMintPerWallet) public onlyOwner {
2123     maxMintPerWallet = _maxMintPerWallet;
2124   }  
2125 
2126   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2127     hiddenMetadataUri = _hiddenMetadataUri;
2128   }  
2129 
2130   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2131     uriPrefix = _uriPrefix;
2132   }  
2133 
2134   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2135     uriSuffix = _uriSuffix;
2136   }
2137 
2138   function setPaused(bool _state) public onlyOwner {
2139     paused = _state;
2140   }
2141 
2142     function _baseURI() internal view virtual override returns (string memory) {
2143         return uriPrefix;
2144     }
2145     
2146 }