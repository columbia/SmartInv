1 // SPDX-License-Identifier: MIT
2 
3 // File 1: Address.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 
228 // FILE 2: Context.sol
229 pragma solidity ^0.8.0;
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
248         return msg.data;
249     }
250 }
251 
252 // File 3: Strings.sol
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev String operations.
260  */
261 library Strings {
262     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
266      */
267     function toString(uint256 value) internal pure returns (string memory) {
268         // Inspired by OraclizeAPI's implementation - MIT licence
269         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
270 
271         if (value == 0) {
272             return "0";
273         }
274         uint256 temp = value;
275         uint256 digits;
276         while (temp != 0) {
277             digits++;
278             temp /= 10;
279         }
280         bytes memory buffer = new bytes(digits);
281         while (value != 0) {
282             digits -= 1;
283             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
284             value /= 10;
285         }
286         return string(buffer);
287     }
288 
289     /**
290      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
291      */
292     function toHexString(uint256 value) internal pure returns (string memory) {
293         if (value == 0) {
294             return "0x00";
295         }
296         uint256 temp = value;
297         uint256 length = 0;
298         while (temp != 0) {
299             length++;
300             temp >>= 8;
301         }
302         return toHexString(value, length);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
307      */
308     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
309         bytes memory buffer = new bytes(2 * length + 2);
310         buffer[0] = "0";
311         buffer[1] = "x";
312         for (uint256 i = 2 * length + 1; i > 1; --i) {
313             buffer[i] = _HEX_SYMBOLS[value & 0xf];
314             value >>= 4;
315         }
316         require(value == 0, "Strings: hex length insufficient");
317         return string(buffer);
318     }
319 }
320 
321 
322 // File: @openzeppelin/contracts/utils/Counters.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @title Counters
331  * @author Matt Condon (@shrugs)
332  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
333  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
334  *
335  * Include with `using Counters for Counters.Counter;`
336  */
337 library Counters {
338     struct Counter {
339         // This variable should never be directly accessed by users of the library: interactions must be restricted to
340         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
341         // this feature: see https://github.com/ethereum/solidity/issues/4637
342         uint256 _value; // default: 0
343     }
344 
345     function current(Counter storage counter) internal view returns (uint256) {
346         return counter._value;
347     }
348 
349     function increment(Counter storage counter) internal {
350         unchecked {
351             counter._value += 1;
352         }
353     }
354 
355     function decrement(Counter storage counter) internal {
356         uint256 value = counter._value;
357         require(value > 0, "Counter: decrement overflow");
358         unchecked {
359             counter._value = value - 1;
360         }
361     }
362 
363     function reset(Counter storage counter) internal {
364         counter._value = 0;
365     }
366 }
367 
368 // File 4: Ownable.sol
369 
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Contract module which provides a basic access control mechanism, where
376  * there is an account (an owner) that can be granted exclusive access to
377  * specific functions.
378  *
379  * By default, the owner account will be the one that deploys the contract. This
380  * can later be changed with {transferOwnership}.
381  *
382  * This module is used through inheritance. It will make available the modifier
383  * `onlyOwner`, which can be applied to your functions to restrict their use to
384  * the owner.
385  */
386 abstract contract Ownable is Context {
387     address private _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor () {
395         address msgSender = _msgSender();
396         _owner = msgSender;
397         emit OwnershipTransferred(address(0), msgSender);
398     }
399 
400     /**
401      * @dev Returns the address of the current owner.
402      */
403     function owner() public view virtual returns (address) {
404         return _owner;
405     }
406 
407     /**
408      * @dev Throws if called by any account other than the owner.
409      */
410     modifier onlyOwner() {
411         require(owner() == _msgSender(), "Ownable: caller is not the owner");
412         _;
413     }
414 
415     /**
416      * @dev Leaves the contract without owner. It will not be possible to call
417      * `onlyOwner` functions anymore. Can only be called by the current owner.
418      *
419      * NOTE: Renouncing ownership will leave the contract without an owner,
420      * thereby removing any functionality that is only available to the owner.
421      */
422     function renounceOwnership() public virtual onlyOwner {
423         emit OwnershipTransferred(_owner, address(0));
424         _owner = address(0);
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Can only be called by the current owner.
430      */
431     function transferOwnership(address newOwner) public virtual onlyOwner {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         emit OwnershipTransferred(_owner, newOwner);
434         _owner = newOwner;
435     }
436 }
437 
438 
439 
440 
441 
442 // File 5: IERC165.sol
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 
468 // File 6: IERC721.sol
469 
470 pragma solidity ^0.8.0;
471 
472 
473 /**
474  * @dev Required interface of an ERC721 compliant contract.
475  */
476 interface IERC721 is IERC165 {
477     /**
478      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
479      */
480     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
481 
482     /**
483      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
484      */
485     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
489      */
490     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
491 
492     /**
493      * @dev Returns the number of tokens in ``owner``'s account.
494      */
495     function balanceOf(address owner) external view returns (uint256 balance);
496 
497     /**
498      * @dev Returns the owner of the `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function ownerOf(uint256 tokenId) external view returns (address owner);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
508      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(address from, address to, uint256 tokenId) external;
521 
522     /**
523      * @dev Transfers `tokenId` token from `from` to `to`.
524      *
525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transferFrom(address from, address to, uint256 tokenId) external;
537 
538     /**
539      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
540      * The approval is cleared when the token is transferred.
541      *
542      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
543      *
544      * Requirements:
545      *
546      * - The caller must own the token or be an approved operator.
547      * - `tokenId` must exist.
548      *
549      * Emits an {Approval} event.
550      */
551     function approve(address to, uint256 tokenId) external;
552 
553     /**
554      * @dev Returns the account approved for `tokenId` token.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function getApproved(uint256 tokenId) external view returns (address operator);
561 
562     /**
563      * @dev Approve or remove `operator` as an operator for the caller.
564      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
565      *
566      * Requirements:
567      *
568      * - The `operator` cannot be the caller.
569      *
570      * Emits an {ApprovalForAll} event.
571      */
572     function setApprovalForAll(address operator, bool _approved) external;
573 
574     /**
575      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
576      *
577      * See {setApprovalForAll}
578      */
579     function isApprovedForAll(address owner, address operator) external view returns (bool);
580 
581     /**
582       * @dev Safely transfers `tokenId` token from `from` to `to`.
583       *
584       * Requirements:
585       *
586       * - `from` cannot be the zero address.
587       * - `to` cannot be the zero address.
588       * - `tokenId` token must exist and be owned by `from`.
589       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
590       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591       *
592       * Emits a {Transfer} event.
593       */
594     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
595 }
596 
597 
598 
599 // File 7: IERC721Metadata.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external returns (string memory);
626 }
627 
628 
629 
630 
631 // File 8: ERC165.sol
632 
633 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Implementation of the {IERC165} interface.
640  *
641  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
642  * for the additional interface id that will be supported. For example:
643  *
644  * ```solidity
645  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
647  * }
648  * ```
649  *
650  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
651  */
652 abstract contract ERC165 is IERC165 {
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
657         return interfaceId == type(IERC165).interfaceId;
658     }
659 }
660 
661 
662 // File 9: ERC721.sol
663 
664 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
671  * the Metadata extension, but not including the Enumerable extension, which is available separately as
672  * {ERC721Enumerable}.
673  */
674 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
675     using Address for address;
676     using Strings for uint256;
677 
678     // Token name
679     string private _name;
680 
681     // Token symbol
682     string private _symbol;
683 
684     // Mapping from token ID to owner address
685     mapping(uint256 => address) private _owners;
686 
687     // Mapping owner address to token count
688     mapping(address => uint256) private _balances;
689 
690     // Mapping from token ID to approved address
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     /**
697      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
698      */
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
708         return
709             interfaceId == type(IERC721).interfaceId ||
710             interfaceId == type(IERC721Metadata).interfaceId ||
711             super.supportsInterface(interfaceId);
712     }
713 
714     /**
715      * @dev See {IERC721-balanceOf}.
716      */
717     function balanceOf(address owner) public view virtual override returns (uint256) {
718         require(owner != address(0), "ERC721: balance query for the zero address");
719         return _balances[owner];
720     }
721 
722     /**
723      * @dev See {IERC721-ownerOf}.
724      */
725     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
726         address owner = _owners[tokenId];
727         require(owner != address(0), "ERC721: owner query for nonexistent token");
728         return owner;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-name}.
733      */
734     function name() public view virtual override returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-symbol}.
740      */
741     function symbol() public view virtual override returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-tokenURI}.
747      */
748     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
749         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
750 
751         string memory baseURI = _baseURI();
752         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
753     }
754 
755     /**
756      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
757      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
758      * by default, can be overridden in child contracts.
759      */
760     function _baseURI() internal view virtual returns (string memory) {
761         return "";
762     }
763 
764     /**
765      * @dev See {IERC721-approve}.
766      */
767     function approve(address to, uint256 tokenId) public virtual override {
768         address owner = ERC721.ownerOf(tokenId);
769         require(to != owner, "ERC721: approval to current owner");
770 
771         require(
772             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
773             "ERC721: approve caller is not owner nor approved for all"
774         );
775         if (to.isContract()) {
776             revert ("Token transfer to contract address is not allowed.");
777         } else {
778             _approve(to, tokenId);
779         }
780         // _approve(to, tokenId);
781     }
782 
783     /**
784      * @dev See {IERC721-getApproved}.
785      */
786     function getApproved(uint256 tokenId) public view virtual override returns (address) {
787         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved) public virtual override {
796         _setApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         //solhint-disable-next-line max-line-length
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816 
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, "");
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      * and stop existing when they are burned (`_burn`).
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return _owners[tokenId] != address(0);
882     }
883 
884     /**
885      * @dev Returns whether `spender` is allowed to manage `tokenId`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
892         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
893         address owner = ERC721.ownerOf(tokenId);
894         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
895     }
896 
897     /**
898      * @dev Safely mints `tokenId` and transfers it to `to`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeMint(address to, uint256 tokenId) internal virtual {
908         _safeMint(to, tokenId, "");
909     }
910 
911     /**
912      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914      */
915     function _safeMint(
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _mint(to, tokenId);
921         require(
922             _checkOnERC721Received(address(0), to, tokenId, _data),
923             "ERC721: transfer to non ERC721Receiver implementer"
924         );
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949 
950         _afterTokenTransfer(address(0), to, tokenId);
951     }
952 
953     /**
954      * @dev Destroys `tokenId`.
955      * The approval is cleared when the token is burned.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _burn(uint256 tokenId) internal virtual {
964         address owner = ERC721.ownerOf(tokenId);
965 
966         _beforeTokenTransfer(owner, address(0), tokenId);
967 
968         // Clear approvals
969         _approve(address(0), tokenId);
970 
971         _balances[owner] -= 1;
972         delete _owners[tokenId];
973 
974         emit Transfer(owner, address(0), tokenId);
975 
976         _afterTokenTransfer(owner, address(0), tokenId);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {
995         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
996         require(to != address(0), "ERC721: transfer to the zero address");
997 
998         _beforeTokenTransfer(from, to, tokenId);
999 
1000         // Clear approvals from the previous owner
1001         _approve(address(0), tokenId);
1002 
1003         _balances[from] -= 1;
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(from, to, tokenId);
1008 
1009         _afterTokenTransfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `to` to operate on `tokenId`
1014      *
1015      * Emits a {Approval} event.
1016      */
1017     function _approve(address to, uint256 tokenId) internal virtual {
1018         _tokenApprovals[tokenId] = to;
1019         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `operator` to operate on all of `owner` tokens
1024      *
1025      * Emits a {ApprovalForAll} event.
1026      */
1027     function _setApprovalForAll(
1028         address owner,
1029         address operator,
1030         bool approved
1031     ) internal virtual {
1032         require(owner != operator, "ERC721: approve to caller");
1033         _operatorApprovals[owner][operator] = approved;
1034         emit ApprovalForAll(owner, operator, approved);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1055                 return retval == IERC721Receiver.onERC721Received.selector;
1056             } catch (bytes memory reason) {
1057                 if (reason.length == 0) {
1058                     revert("ERC721: transfer to non ERC721Receiver implementer");
1059                 } else {
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {}
1089 
1090     /**
1091      * @dev Hook that is called after any transfer of tokens. This includes
1092      * minting and burning.
1093      *
1094      * Calling conditions:
1095      *
1096      * - when `from` and `to` are both non-zero.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _afterTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 }
1107 
1108 
1109 
1110 
1111 
1112 // File 10: IERC721Enumerable.sol
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 
1117 /**
1118  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1119  * @dev See https://eips.ethereum.org/EIPS/eip-721
1120  */
1121 interface IERC721Enumerable is IERC721 {
1122 
1123     /**
1124      * @dev Returns the total amount of tokens stored by the contract.
1125      */
1126     function totalSupply() external view returns (uint256);
1127 
1128     /**
1129      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1130      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1131      */
1132     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1133 
1134     /**
1135      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1136      * Use along with {totalSupply} to enumerate all tokens.
1137      */
1138     function tokenByIndex(uint256 index) external view returns (uint256);
1139 }
1140 
1141 
1142 
1143 
1144 
1145 
1146 // File 11: ERC721Enumerable.sol
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 /**
1152  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1153  * enumerability of all the token ids in the contract as well as all token ids owned by each
1154  * account.
1155  */
1156 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1157     // Mapping from owner to list of owned token IDs
1158     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1159 
1160     // Mapping from token ID to index of the owner tokens list
1161     mapping(uint256 => uint256) private _ownedTokensIndex;
1162 
1163     // Array with all token ids, used for enumeration
1164     uint256[] private _allTokens;
1165 
1166     // Mapping from token id to position in the allTokens array
1167     mapping(uint256 => uint256) private _allTokensIndex;
1168 
1169     /**
1170      * @dev See {IERC165-supportsInterface}.
1171      */
1172     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1173         return interfaceId == type(IERC721Enumerable).interfaceId
1174             || super.supportsInterface(interfaceId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1179      */
1180     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1181         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1182         return _ownedTokens[owner][index];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721Enumerable-totalSupply}.
1187      */
1188     function totalSupply() public view virtual override returns (uint256) {
1189         return _allTokens.length;
1190     }
1191 
1192     /**
1193      * @dev See {IERC721Enumerable-tokenByIndex}.
1194      */
1195     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1196         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1197         return _allTokens[index];
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before any token transfer. This includes minting
1202      * and burning.
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` will be minted for `to`.
1209      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1210      * - `from` cannot be the zero address.
1211      * - `to` cannot be the zero address.
1212      *
1213      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1214      */
1215     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1216         super._beforeTokenTransfer(from, to, tokenId);
1217 
1218         if (from == address(0)) {
1219             _addTokenToAllTokensEnumeration(tokenId);
1220         } else if (from != to) {
1221             _removeTokenFromOwnerEnumeration(from, tokenId);
1222         }
1223         if (to == address(0)) {
1224             _removeTokenFromAllTokensEnumeration(tokenId);
1225         } else if (to != from) {
1226             _addTokenToOwnerEnumeration(to, tokenId);
1227         }
1228     }
1229 
1230     /**
1231      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1232      * @param to address representing the new owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1234      */
1235     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1236         uint256 length = ERC721.balanceOf(to);
1237         _ownedTokens[to][length] = tokenId;
1238         _ownedTokensIndex[tokenId] = length;
1239     }
1240 
1241     /**
1242      * @dev Private function to add a token to this extension's token tracking data structures.
1243      * @param tokenId uint256 ID of the token to be added to the tokens list
1244      */
1245     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1246         _allTokensIndex[tokenId] = _allTokens.length;
1247         _allTokens.push(tokenId);
1248     }
1249 
1250     /**
1251      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1252      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1253      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1254      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1255      * @param from address representing the previous owner of the given token ID
1256      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1257      */
1258     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1259         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1260         // then delete the last slot (swap and pop).
1261 
1262         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1263         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1264 
1265         // When the token to delete is the last token, the swap operation is unnecessary
1266         if (tokenIndex != lastTokenIndex) {
1267             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1268 
1269             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1270             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1271         }
1272 
1273         // This also deletes the contents at the last position of the array
1274         delete _ownedTokensIndex[tokenId];
1275         delete _ownedTokens[from][lastTokenIndex];
1276     }
1277 
1278     /**
1279      * @dev Private function to remove a token from this extension's token tracking data structures.
1280      * This has O(1) time complexity, but alters the order of the _allTokens array.
1281      * @param tokenId uint256 ID of the token to be removed from the tokens list
1282      */
1283     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1284         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1285         // then delete the last slot (swap and pop).
1286 
1287         uint256 lastTokenIndex = _allTokens.length - 1;
1288         uint256 tokenIndex = _allTokensIndex[tokenId];
1289 
1290         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1291         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1292         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1293         uint256 lastTokenId = _allTokens[lastTokenIndex];
1294 
1295         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1296         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1297 
1298         // This also deletes the contents at the last position of the array
1299         delete _allTokensIndex[tokenId];
1300         _allTokens.pop();
1301     }
1302 }
1303 
1304 
1305 
1306 // File 12: IERC721Receiver.sol
1307 
1308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 /**
1313  * @title ERC721 token receiver interface
1314  * @dev Interface for any contract that wants to support safeTransfers
1315  * from ERC721 asset contracts.
1316  */
1317 interface IERC721Receiver {
1318     /**
1319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1320      * by `operator` from `from`, this function is called.
1321      *
1322      * It must return its Solidity selector to confirm the token transfer.
1323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1324      *
1325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1326      */
1327     function onERC721Received(
1328         address operator,
1329         address from,
1330         uint256 tokenId,
1331         bytes calldata data
1332     ) external returns (bytes4);
1333 }
1334 
1335 
1336 
1337 // File 13: ERC721A.sol
1338 
1339 pragma solidity ^0.8.0;
1340 
1341 
1342 error ApprovalCallerNotOwnerNorApproved();
1343 error ApprovalQueryForNonexistentToken();
1344 error ApproveToCaller();
1345 error ApprovalToCurrentOwner();
1346 error BalanceQueryForZeroAddress();
1347 error MintedQueryForZeroAddress();
1348 error BurnedQueryForZeroAddress();
1349 error MintToZeroAddress();
1350 error MintZeroQuantity();
1351 error OwnerIndexOutOfBounds();
1352 error OwnerQueryForNonexistentToken();
1353 error TokenIndexOutOfBounds();
1354 error TransferCallerNotOwnerNorApproved();
1355 error TransferFromIncorrectOwner();
1356 error TransferToNonERC721ReceiverImplementer();
1357 error TransferToZeroAddress();
1358 error URIQueryForNonexistentToken();
1359 
1360 /**
1361  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1362  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1363  *
1364  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1365  *
1366  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1367  *
1368  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1369  */
1370 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
1371     using Address for address;
1372     using Strings for uint256;
1373 
1374     // Compiler will pack this into a single 256bit word.
1375     struct TokenOwnership {
1376         // The address of the owner.
1377         address addr;
1378         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1379         uint64 startTimestamp;
1380         // Whether the token has been burned.
1381         bool burned;
1382     }
1383 
1384     // Compiler will pack this into a single 256bit word.
1385     struct AddressData {
1386         // Realistically, 2**64-1 is more than enough.
1387         uint64 balance;
1388         // Keeps track of mint count with minimal overhead for tokenomics.
1389         uint64 numberMinted;
1390         // Keeps track of burn count with minimal overhead for tokenomics.
1391         uint64 numberBurned;
1392     }
1393 
1394     // The tokenId of the next token to be minted.
1395     uint256 internal _currentIndex = 1;
1396 
1397     // The number of tokens burned.
1398     uint256 internal _burnCounter;
1399 
1400     // Token name
1401     string private _name;
1402 
1403     // Token symbol
1404     string private _symbol;
1405 
1406     //Allow all tokens to transfer to contract
1407     bool public allowedToContract = false;
1408 
1409     function setAllowToContract() external onlyOwner {
1410         allowedToContract = !allowedToContract;
1411     }
1412 
1413     // Mapping from token ID to ownership details
1414     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1415     mapping(uint256 => TokenOwnership) internal _ownerships;
1416 
1417     // Mapping owner address to address data
1418     mapping(address => AddressData) private _addressData;
1419 
1420     // Mapping from token ID to approved address
1421     mapping(uint256 => address) private _tokenApprovals;
1422 
1423     // Mapping from owner to operator approvals
1424     mapping(address => mapping(address => bool)) private _operatorApprovals;
1425 
1426     // Mapping token to allow to transfer to contract
1427     mapping(uint256 => bool) public _transferToContract;
1428 
1429 
1430 // Mapping from token ID to owner address
1431     mapping(uint256 => address) private _owners;
1432 
1433     // Mapping owner address to token count
1434     mapping(address => uint256) private _balances;
1435 
1436 
1437 
1438 
1439     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1440         _transferToContract[_tokenId] = _allow;
1441     }
1442 
1443     constructor(string memory name_, string memory symbol_) {
1444         _name = name_;
1445         _symbol = symbol_;
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Enumerable-totalSupply}.
1450      */
1451     function totalSupply() public view virtual override returns (uint256) {
1452         // Counter underflow is impossible as _burnCounter cannot be incremented
1453         // more than _currentIndex times
1454         unchecked {
1455             return _currentIndex - _burnCounter;    
1456         }
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Enumerable-tokenByIndex}.
1461      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1462      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1463      */
1464     function tokenByIndex(uint256 index) public view override returns (uint256) {
1465         uint256 numMintedSoFar = _currentIndex;
1466         uint256 tokenIdsIdx;
1467 
1468         // Counter overflow is impossible as the loop breaks when
1469         // uint256 i is equal to another uint256 numMintedSoFar.
1470         unchecked {
1471             for (uint256 i; i < numMintedSoFar; i++) {
1472                 TokenOwnership memory ownership = _ownerships[i];
1473                 if (!ownership.burned) {
1474                     if (tokenIdsIdx == index) {
1475                         return i;
1476                     }
1477                     tokenIdsIdx++;
1478                 }
1479             }
1480         }
1481         revert TokenIndexOutOfBounds();
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1486      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1487      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1488      */
1489     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1490         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1491         uint256 numMintedSoFar = _currentIndex;
1492         uint256 tokenIdsIdx;
1493         address currOwnershipAddr;
1494 
1495         // Counter overflow is impossible as the loop breaks when
1496         // uint256 i is equal to another uint256 numMintedSoFar.
1497         unchecked {
1498             for (uint256 i; i < numMintedSoFar; i++) {
1499                 TokenOwnership memory ownership = _ownerships[i];
1500                 if (ownership.burned) {
1501                     continue;
1502                 }
1503                 if (ownership.addr != address(0)) {
1504                     currOwnershipAddr = ownership.addr;
1505                 }
1506                 if (currOwnershipAddr == owner) {
1507                     if (tokenIdsIdx == index) {
1508                         return i;
1509                     }
1510                     tokenIdsIdx++;
1511                 }
1512             }
1513         }
1514 
1515         // Execution should never reach this point.
1516         revert();
1517     }
1518 
1519     /**
1520      * @dev See {IERC165-supportsInterface}.
1521      */
1522     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1523         return
1524             interfaceId == type(IERC721).interfaceId ||
1525             interfaceId == type(IERC721Metadata).interfaceId ||
1526             interfaceId == type(IERC721Enumerable).interfaceId ||
1527             super.supportsInterface(interfaceId);
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-balanceOf}.
1532      */
1533     function balanceOf(address owner) public view override returns (uint256) {
1534         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1535         return uint256(_addressData[owner].balance);
1536     }
1537 
1538     function _numberMinted(address owner) internal view returns (uint256) {
1539         if (owner == address(0)) revert MintedQueryForZeroAddress();
1540         return uint256(_addressData[owner].numberMinted);
1541     }
1542 
1543     function _numberBurned(address owner) internal view returns (uint256) {
1544         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1545         return uint256(_addressData[owner].numberBurned);
1546     }
1547 
1548     /**
1549      * Gas spent here starts off proportional to the maximum mint batch size.
1550      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1551      */
1552     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1553         uint256 curr = tokenId;
1554 
1555         unchecked {
1556             if (curr < _currentIndex) {
1557                 TokenOwnership memory ownership = _ownerships[curr];
1558                 if (!ownership.burned) {
1559                     if (ownership.addr != address(0)) {
1560                         return ownership;
1561                     }
1562                     // Invariant: 
1563                     // There will always be an ownership that has an address and is not burned 
1564                     // before an ownership that does not have an address and is not burned.
1565                     // Hence, curr will not underflow.
1566                     while (true) {
1567                         curr--;
1568                         ownership = _ownerships[curr];
1569                         if (ownership.addr != address(0)) {
1570                             return ownership;
1571                         }
1572                     }
1573                 }
1574             }
1575         }
1576         revert OwnerQueryForNonexistentToken();
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-ownerOf}.
1581      */
1582     function ownerOf(uint256 tokenId) public view override returns (address) {
1583         return ownershipOf(tokenId).addr;
1584     }
1585 
1586     /**
1587      * @dev See {IERC721Metadata-name}.
1588      */
1589     function name() public view virtual override returns (string memory) {
1590         return _name;
1591     }
1592 
1593     /**
1594      * @dev See {IERC721Metadata-symbol}.
1595      */
1596     function symbol() public view virtual override returns (string memory) {
1597         return _symbol;
1598     }
1599 
1600     /**
1601      * @dev See {IERC721Metadata-tokenURI}.
1602      */
1603     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
1604         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1605 
1606         string memory baseURI = _baseURI();
1607         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1608     }
1609 
1610     /**
1611      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1612      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1613      * by default, can be overriden in child contracts.
1614      */
1615     function _baseURI() internal view virtual returns (string memory) {
1616         return '';
1617     }
1618 
1619     /**
1620      * @dev See {IERC721-approve}.
1621      */
1622     function approve(address to, uint256 tokenId) public override {
1623         address owner = ERC721A.ownerOf(tokenId);
1624         if (to == owner) revert ApprovalToCurrentOwner();
1625 
1626         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1627             revert ApprovalCallerNotOwnerNorApproved();
1628         }
1629         if(!allowedToContract && !_transferToContract[tokenId]){
1630             if (to.isContract()) {
1631                 revert ("Token transfer to contract address is not allowed.");
1632             } else {
1633                 _approve(to, tokenId, owner);
1634             }
1635         } else {
1636             _approve(to, tokenId, owner);
1637         }
1638     }
1639 
1640     /**
1641      * @dev See {IERC721-getApproved}.
1642      */
1643     function getApproved(uint256 tokenId) public view override returns (address) {
1644         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1645 
1646         return _tokenApprovals[tokenId];
1647     }
1648 
1649     /**
1650      * @dev See {IERC721-setApprovalForAll}.
1651      */
1652     function setApprovalForAll(address operator, bool approved) public override {
1653         if (operator == _msgSender()) revert ApproveToCaller();
1654         
1655         if(!allowedToContract){
1656             if (operator.isContract()) {
1657                 revert ("Token transfer to contract address is not allowed.");
1658             } else {
1659                 _operatorApprovals[_msgSender()][operator] = approved;
1660                 emit ApprovalForAll(_msgSender(), operator, approved);
1661             }
1662         } else {
1663             _operatorApprovals[_msgSender()][operator] = approved;
1664             emit ApprovalForAll(_msgSender(), operator, approved);
1665         }
1666     }
1667 
1668     /**
1669      * @dev See {IERC721-isApprovedForAll}.
1670      */
1671     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1672         return _operatorApprovals[owner][operator];
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-transferFrom}.
1677      */
1678     function transferFrom(
1679         address from,
1680         address to,
1681         uint256 tokenId
1682     ) public virtual override {
1683         _transfer(from, to, tokenId);
1684     }
1685 
1686     /**
1687      * @dev See {IERC721-safeTransferFrom}.
1688      */
1689     function safeTransferFrom(
1690         address from,
1691         address to,
1692         uint256 tokenId
1693     ) public virtual override {
1694         safeTransferFrom(from, to, tokenId, '');
1695     }
1696 
1697     /**
1698      * @dev See {IERC721-safeTransferFrom}.
1699      */
1700     function safeTransferFrom(
1701         address from,
1702         address to,
1703         uint256 tokenId,
1704         bytes memory _data
1705     ) public virtual override {
1706         _transfer(from, to, tokenId);
1707         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1708             revert TransferToNonERC721ReceiverImplementer();
1709         }
1710     }
1711 
1712     /**
1713      * @dev Returns whether `tokenId` exists.
1714      *
1715      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1716      *
1717      * Tokens start existing when they are minted (`_mint`),
1718      */
1719     function _exists(uint256 tokenId) internal view returns (bool) {
1720         require(tokenId > 0, "Invalid TokenId");
1721         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1722     }
1723 
1724     function _safeMint(address to, uint256 quantity) internal {
1725         _safeMint(to, quantity, '');
1726     }
1727 
1728     /**
1729      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1730      *
1731      * Requirements:
1732      *
1733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1734      * - `quantity` must be greater than 0.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function _safeMint(
1739         address to,
1740         uint256 quantity,
1741         bytes memory _data
1742     ) internal {
1743         _mint(to, quantity, _data, true);
1744     }
1745 
1746     /**
1747      * @dev Mints `quantity` tokens and transfers them to `to`.
1748      *
1749      * Requirements:
1750      *
1751      * - `to` cannot be the zero address.
1752      * - `quantity` must be greater than 0.
1753      *
1754      * Emits a {Transfer} event.
1755      */
1756     function _mint(
1757         address to,
1758         uint256 quantity,
1759         bytes memory _data,
1760         bool safe
1761     ) internal {
1762         uint256 startTokenId = _currentIndex;
1763         if (to == address(0)) revert MintToZeroAddress();
1764         if (quantity == 0) revert MintZeroQuantity();
1765 
1766         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1767 
1768         // Overflows are incredibly unrealistic.
1769         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1770         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1771         unchecked {
1772             _addressData[to].balance += uint64(quantity);
1773             _addressData[to].numberMinted += uint64(quantity);
1774 
1775             _ownerships[startTokenId].addr = to;
1776             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1777 
1778             uint256 updatedIndex = startTokenId;
1779 
1780             for (uint256 i; i < quantity; i++) {
1781                 emit Transfer(address(0), to, updatedIndex);
1782                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1783                     revert TransferToNonERC721ReceiverImplementer();
1784                 }
1785                 updatedIndex++;
1786             }
1787 
1788             _currentIndex = updatedIndex;
1789         }
1790         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1791     }
1792 
1793     /**
1794      * @dev Transfers `tokenId` from `from` to `to`.
1795      *
1796      * Requirements:
1797      *
1798      * - `to` cannot be the zero address.
1799      * - `tokenId` token must be owned by `from`.
1800      *
1801      * Emits a {Transfer} event.
1802      */
1803     function _transfer(
1804         address from,
1805         address to,
1806         uint256 tokenId
1807     ) private {
1808         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1809 
1810         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1811             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1812             getApproved(tokenId) == _msgSender());
1813 
1814         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1815         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1816         if (to == address(0)) revert TransferToZeroAddress();
1817 
1818         _beforeTokenTransfers(from, to, tokenId, 1);
1819 
1820         // Clear approvals from the previous owner
1821         _approve(address(0), tokenId, prevOwnership.addr);
1822 
1823         // Underflow of the sender's balance is impossible because we check for
1824         // ownership above and the recipient's balance can't realistically overflow.
1825         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1826         unchecked {
1827             _addressData[from].balance -= 1;
1828             _addressData[to].balance += 1;
1829 
1830             _ownerships[tokenId].addr = to;
1831             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1832 
1833             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1834             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1835             uint256 nextTokenId = tokenId + 1;
1836             if (_ownerships[nextTokenId].addr == address(0)) {
1837                 // This will suffice for checking _exists(nextTokenId),
1838                 // as a burned slot cannot contain the zero address.
1839                 if (nextTokenId < _currentIndex) {
1840                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1841                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1842                 }
1843             }
1844         }
1845 
1846         emit Transfer(from, to, tokenId);
1847         _afterTokenTransfers(from, to, tokenId, 1);
1848     }
1849 
1850     /**
1851      * @dev Destroys `tokenId`.
1852      * The approval is cleared when the token is burned.
1853      *
1854      * Requirements:
1855      *
1856      * - `tokenId` must exist.
1857      *
1858      * Emits a {Transfer} event.
1859      */
1860     function _burn(uint256 tokenId) internal virtual {
1861         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1862 
1863         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1864 
1865         // Clear approvals from the previous owner
1866         _approve(address(0), tokenId, prevOwnership.addr);
1867 
1868         // Underflow of the sender's balance is impossible because we check for
1869         // ownership above and the recipient's balance can't realistically overflow.
1870         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1871         unchecked {
1872             _addressData[prevOwnership.addr].balance -= 1;
1873             _addressData[prevOwnership.addr].numberBurned += 1;
1874 
1875             // Keep track of who burned the token, and the timestamp of burning.
1876             _ownerships[tokenId].addr = prevOwnership.addr;
1877             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1878             _ownerships[tokenId].burned = true;
1879 
1880             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1881             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1882             uint256 nextTokenId = tokenId + 1;
1883             if (_ownerships[nextTokenId].addr == address(0)) {
1884                 // This will suffice for checking _exists(nextTokenId),
1885                 // as a burned slot cannot contain the zero address.
1886                 if (nextTokenId < _currentIndex) {
1887                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1888                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1889                 }
1890             }
1891         }
1892 
1893         emit Transfer(prevOwnership.addr, address(0), tokenId);
1894         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1895 
1896         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1897         unchecked { 
1898             _burnCounter++;
1899         }
1900     }
1901 
1902     /**
1903      * @dev Approve `to` to operate on `tokenId`
1904      *
1905      * Emits a {Approval} event.
1906      */
1907     function _approve(
1908         address to,
1909         uint256 tokenId,
1910         address owner
1911     ) private {
1912         _tokenApprovals[tokenId] = to;
1913         emit Approval(owner, to, tokenId);
1914     }
1915 
1916     /**
1917      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1918      * The call is not executed if the target address is not a contract.
1919      *
1920      * @param from address representing the previous owner of the given token ID
1921      * @param to target address that will receive the tokens
1922      * @param tokenId uint256 ID of the token to be transferred
1923      * @param _data bytes optional data to send along with the call
1924      * @return bool whether the call correctly returned the expected magic value
1925      */
1926     function _checkOnERC721Received(
1927         address from,
1928         address to,
1929         uint256 tokenId,
1930         bytes memory _data
1931     ) private returns (bool) {
1932         if(!allowedToContract && !_transferToContract[tokenId]){
1933             if (to.isContract()) {
1934                 revert ("Token transfer to contract address is not allowed.");
1935             } else {
1936                 return true;
1937             }
1938         } else {
1939             return true;
1940         }
1941     }
1942 
1943     /**
1944      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1945      * And also called before burning one token.
1946      *
1947      * startTokenId - the first token id to be transferred
1948      * quantity - the amount to be transferred
1949      *
1950      * Calling conditions:
1951      *
1952      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1953      * transferred to `to`.
1954      * - When `from` is zero, `tokenId` will be minted for `to`.
1955      * - When `to` is zero, `tokenId` will be burned by `from`.
1956      * - `from` and `to` are never both zero.
1957      */
1958     function _beforeTokenTransfers(
1959         address from,
1960         address to,
1961         uint256 startTokenId,
1962         uint256 quantity
1963     ) internal virtual {}
1964 
1965     /**
1966      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1967      * minting.
1968      * And also called after one token has been burned.
1969      *
1970      * startTokenId - the first token id to be transferred
1971      * quantity - the amount to be transferred
1972      *
1973      * Calling conditions:
1974      *
1975      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1976      * transferred to `to`.
1977      * - When `from` is zero, `tokenId` has been minted for `to`.
1978      * - When `to` is zero, `tokenId` has been burned by `from`.
1979      * - `from` and `to` are never both zero.
1980      */
1981     function _afterTokenTransfers(
1982         address from,
1983         address to,
1984         uint256 startTokenId,
1985         uint256 quantity
1986     ) internal virtual {}
1987 }
1988 
1989 // FILE 14: T12.sol
1990 
1991 pragma solidity ^0.8.0;
1992 
1993 contract NotOkayZukibears is ERC721A {
1994   using Strings for uint256;
1995   using Counters for Counters.Counter;
1996 
1997   Counters.Counter private supply;
1998 
1999   string private uriPrefix = "";
2000   string public uriSuffix = ".json";
2001   string private hiddenMetadataUri;
2002 
2003     constructor() ERC721A("NotOkayZukibears", "NOZB") {
2004         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
2005     }
2006 
2007     uint256 public constant maxSupply = 9999;
2008     uint256 private mintCount = 0;
2009     uint256 public maxMintPerTx = 5;
2010     uint256 public maxMintPerWallet = 5;   
2011     uint256 public price = 0.01 ether;
2012      
2013   bool public paused = false;
2014   bool public revealed = true;
2015 
2016 
2017   mapping (address => uint256) public addressMintedBalance;
2018 
2019 
2020     event Minted(uint256 totalMinted);
2021 
2022       
2023     function totalSupply() public view override returns (uint256) {
2024         return mintCount;
2025     }
2026 
2027     function changePrice(uint256 _newPrice) external onlyOwner {
2028         price = _newPrice;
2029     }
2030 
2031     function withdraw() external onlyOwner {
2032         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2033         require(success, "Transfer failed.");
2034     }
2035 
2036     function mint(uint256 _count) external payable {
2037 
2038         require(!paused, "The contract is paused!");
2039 
2040         require(totalSupply() + _count <= maxSupply, "Exceeds maximum supply");
2041         require(_count > 0, "Minimum 1 NFT has to be minted per transaction");
2042 
2043         if (msg.sender != owner()) {
2044             require(
2045                 _count <= maxMintPerTx,
2046                 "Maximum NFTs can be minted per transaction"
2047             );
2048             require(
2049                 msg.value >= price * _count,
2050                 "Ether sent with this transaction is not correct"
2051             );
2052 
2053             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2054             require (ownerMintedCount + _count <= maxMintPerWallet, "max per address exceeded!");
2055         }
2056 
2057         mintCount += _count;
2058         addressMintedBalance[msg.sender]+= _count;      
2059         _safeMint(msg.sender, _count);
2060         emit Minted(_count);       
2061     }
2062 
2063     function walletOfOwner(address _owner)
2064         public
2065         view
2066         returns (uint256[] memory)
2067     {
2068         uint256 ownerTokenCount = balanceOf(_owner);
2069         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2070         uint256 currentTokenId = 1;
2071         uint256 ownedTokenIndex = 0;
2072 
2073         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2074         address currentTokenOwner = ownerOf(currentTokenId);
2075 
2076         if (currentTokenOwner == _owner) {
2077             ownedTokenIds[ownedTokenIndex] = currentTokenId;
2078 
2079             ownedTokenIndex++;
2080         }
2081 
2082         currentTokenId++;
2083         }
2084 
2085         return ownedTokenIds;
2086     }
2087   
2088   function tokenURI(uint256 _tokenId)
2089     public
2090     /*view*/
2091     virtual
2092     override
2093     returns (string memory)
2094   {
2095     require(
2096       _exists(_tokenId),
2097       "ERC721Metadata: URI query for nonexistent token"
2098     );
2099 
2100     if (revealed == false) {
2101       return hiddenMetadataUri;
2102     }
2103 
2104     string memory currentBaseURI = _baseURI();
2105     return bytes(currentBaseURI).length > 0
2106         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2107         : "";
2108   }
2109 
2110   function setRevealed(bool _state) public onlyOwner {
2111     revealed = _state;
2112   }  
2113 
2114   function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
2115     maxMintPerTx = _maxMintPerTx;
2116   }
2117 
2118   function setMaxMintPerWallet(uint256 _maxMintPerWallet) public onlyOwner {
2119     maxMintPerWallet = _maxMintPerWallet;
2120   }  
2121 
2122   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2123     hiddenMetadataUri = _hiddenMetadataUri;
2124   }  
2125 
2126   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2127     uriPrefix = _uriPrefix;
2128   }  
2129 
2130   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2131     uriSuffix = _uriSuffix;
2132   }
2133 
2134   function setPaused(bool _state) public onlyOwner {
2135     paused = _state;
2136   }
2137 
2138     function _baseURI() internal view virtual override returns (string memory) {
2139         return uriPrefix;
2140     }
2141     
2142 }