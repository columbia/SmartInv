1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319                 /// @solidity memory-safe-assembly
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @title ERC721 token receiver interface
340  * @dev Interface for any contract that wants to support safeTransfers
341  * from ERC721 asset contracts.
342  */
343 interface IERC721Receiver {
344     /**
345      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
346      * by `operator` from `from`, this function is called.
347      *
348      * It must return its Solidity selector to confirm the token transfer.
349      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
350      *
351      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
352      */
353     function onERC721Received(
354         address operator,
355         address from,
356         uint256 tokenId,
357         bytes calldata data
358     ) external returns (bytes4);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Interface of the ERC165 standard, as defined in the
370  * https://eips.ethereum.org/EIPS/eip-165[EIP].
371  *
372  * Implementers can declare support of contract interfaces, which can then be
373  * queried by others ({ERC165Checker}).
374  *
375  * For an implementation, see {ERC165}.
376  */
377 interface IERC165 {
378     /**
379      * @dev Returns true if this contract implements the interface defined by
380      * `interfaceId`. See the corresponding
381      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
382      * to learn more about how these ids are created.
383      *
384      * This function call must use less than 30 000 gas.
385      */
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Implementation of the {IERC165} interface.
399  *
400  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
401  * for the additional interface id that will be supported. For example:
402  *
403  * ```solidity
404  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
406  * }
407  * ```
408  *
409  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
410  */
411 abstract contract ERC165 is IERC165 {
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416         return interfaceId == type(IERC165).interfaceId;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
421 
422 
423 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Required interface of an ERC721 compliant contract.
430  */
431 interface IERC721 is IERC165 {
432     /**
433      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
436 
437     /**
438      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
439      */
440     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
444      */
445     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
446 
447     /**
448      * @dev Returns the number of tokens in ``owner``'s account.
449      */
450     function balanceOf(address owner) external view returns (uint256 balance);
451 
452     /**
453      * @dev Returns the owner of the `tokenId` token.
454      *
455      * Requirements:
456      *
457      * - `tokenId` must exist.
458      */
459     function ownerOf(uint256 tokenId) external view returns (address owner);
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must exist and be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function safeTransferFrom(
475         address from,
476         address to,
477         uint256 tokenId,
478         bytes calldata data
479     ) external;
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
483      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
492      *
493      * Emits a {Transfer} event.
494      */
495     function safeTransferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Transfers `tokenId` token from `from` to `to`.
503      *
504      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      *
513      * Emits a {Transfer} event.
514      */
515     function transferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
523      * The approval is cleared when the token is transferred.
524      *
525      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
526      *
527      * Requirements:
528      *
529      * - The caller must own the token or be an approved operator.
530      * - `tokenId` must exist.
531      *
532      * Emits an {Approval} event.
533      */
534     function approve(address to, uint256 tokenId) external;
535 
536     /**
537      * @dev Approve or remove `operator` as an operator for the caller.
538      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
539      *
540      * Requirements:
541      *
542      * - The `operator` cannot be the caller.
543      *
544      * Emits an {ApprovalForAll} event.
545      */
546     function setApprovalForAll(address operator, bool _approved) external;
547 
548     /**
549      * @dev Returns the account approved for `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function getApproved(uint256 tokenId) external view returns (address operator);
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}
561      */
562     function isApprovedForAll(address owner, address operator) external view returns (bool);
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
566 
567 
568 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://eips.ethereum.org/EIPS/eip-721
576  */
577 interface IERC721Enumerable is IERC721 {
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
585      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
586      */
587     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
588 
589     /**
590      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
591      * Use along with {totalSupply} to enumerate all tokens.
592      */
593     function tokenByIndex(uint256 index) external view returns (uint256);
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
606  * @dev See https://eips.ethereum.org/EIPS/eip-721
607  */
608 interface IERC721Metadata is IERC721 {
609     /**
610      * @dev Returns the token collection name.
611      */
612     function name() external view returns (string memory);
613 
614     /**
615      * @dev Returns the token collection symbol.
616      */
617     function symbol() external view returns (string memory);
618 
619     /**
620      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
621      */
622     function tokenURI(uint256 tokenId) external view returns (string memory);
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
626 
627 
628 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 
634 
635 
636 
637 
638 
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata extension, but not including the Enumerable extension, which is available separately as
642  * {ERC721Enumerable}.
643  */
644 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
645     using Address for address;
646     using Strings for uint256;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to owner address
655     mapping(uint256 => address) private _owners;
656 
657     // Mapping owner address to token count
658     mapping(address => uint256) private _balances;
659 
660     // Mapping from token ID to approved address
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     /**
667      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
668      */
669     constructor(string memory name_, string memory symbol_) {
670         _name = name_;
671         _symbol = symbol_;
672     }
673 
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
678         return
679             interfaceId == type(IERC721).interfaceId ||
680             interfaceId == type(IERC721Metadata).interfaceId ||
681             super.supportsInterface(interfaceId);
682     }
683 
684     /**
685      * @dev See {IERC721-balanceOf}.
686      */
687     function balanceOf(address owner) public view virtual override returns (uint256) {
688         require(owner != address(0), "ERC721: address zero is not a valid owner");
689         return _balances[owner];
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
696         address owner = _owners[tokenId];
697         require(owner != address(0), "ERC721: invalid token ID");
698         return owner;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-name}.
703      */
704     function name() public view virtual override returns (string memory) {
705         return _name;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-symbol}.
710      */
711     function symbol() public view virtual override returns (string memory) {
712         return _symbol;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-tokenURI}.
717      */
718     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
719         _requireMinted(tokenId);
720 
721         string memory baseURI = _baseURI();
722         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
723     }
724 
725     /**
726      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
727      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
728      * by default, can be overridden in child contracts.
729      */
730     function _baseURI() internal view virtual returns (string memory) {
731         return "";
732     }
733 
734     /**
735      * @dev See {IERC721-approve}.
736      */
737     function approve(address to, uint256 tokenId) public virtual override {
738         address owner = ERC721.ownerOf(tokenId);
739         require(to != owner, "ERC721: approval to current owner");
740 
741         require(
742             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
743             "ERC721: approve caller is not token owner nor approved for all"
744         );
745 
746         _approve(to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-getApproved}.
751      */
752     function getApproved(uint256 tokenId) public view virtual override returns (address) {
753         _requireMinted(tokenId);
754 
755         return _tokenApprovals[tokenId];
756     }
757 
758     /**
759      * @dev See {IERC721-setApprovalForAll}.
760      */
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         _setApprovalForAll(_msgSender(), operator, approved);
763     }
764 
765     /**
766      * @dev See {IERC721-isApprovedForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
769         return _operatorApprovals[owner][operator];
770     }
771 
772     /**
773      * @dev See {IERC721-transferFrom}.
774      */
775     function transferFrom(
776         address from,
777         address to,
778         uint256 tokenId
779     ) public virtual override {
780         //solhint-disable-next-line max-line-length
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
782 
783         _transfer(from, to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-safeTransferFrom}.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) public virtual override {
794         safeTransferFrom(from, to, tokenId, "");
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory data
805     ) public virtual override {
806         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
807         _safeTransfer(from, to, tokenId, data);
808     }
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
812      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
813      *
814      * `data` is additional data, it has no specified format and it is sent in call to `to`.
815      *
816      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
817      * implement alternative mechanisms to perform token transfer, such as signature-based.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must exist and be owned by `from`.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeTransfer(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes memory data
833     ) internal virtual {
834         _transfer(from, to, tokenId);
835         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
836     }
837 
838     /**
839      * @dev Returns whether `tokenId` exists.
840      *
841      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
842      *
843      * Tokens start existing when they are minted (`_mint`),
844      * and stop existing when they are burned (`_burn`).
845      */
846     function _exists(uint256 tokenId) internal view virtual returns (bool) {
847         return _owners[tokenId] != address(0);
848     }
849 
850     /**
851      * @dev Returns whether `spender` is allowed to manage `tokenId`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
858         address owner = ERC721.ownerOf(tokenId);
859         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
860     }
861 
862     /**
863      * @dev Safely mints `tokenId` and transfers it to `to`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _safeMint(address to, uint256 tokenId) internal virtual {
873         _safeMint(to, tokenId, "");
874     }
875 
876     /**
877      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
878      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
879      */
880     function _safeMint(
881         address to,
882         uint256 tokenId,
883         bytes memory data
884     ) internal virtual {
885         _mint(to, tokenId);
886         require(
887             _checkOnERC721Received(address(0), to, tokenId, data),
888             "ERC721: transfer to non ERC721Receiver implementer"
889         );
890     }
891 
892     /**
893      * @dev Mints `tokenId` and transfers it to `to`.
894      *
895      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - `to` cannot be the zero address.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _mint(address to, uint256 tokenId) internal virtual {
905         require(to != address(0), "ERC721: mint to the zero address");
906         require(!_exists(tokenId), "ERC721: token already minted");
907 
908         _beforeTokenTransfer(address(0), to, tokenId);
909 
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(address(0), to, tokenId);
914 
915         _afterTokenTransfer(address(0), to, tokenId);
916     }
917 
918     /**
919      * @dev Destroys `tokenId`.
920      * The approval is cleared when the token is burned.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _burn(uint256 tokenId) internal virtual {
929         address owner = ERC721.ownerOf(tokenId);
930 
931         _beforeTokenTransfer(owner, address(0), tokenId);
932 
933         // Clear approvals
934         _approve(address(0), tokenId);
935 
936         _balances[owner] -= 1;
937         delete _owners[tokenId];
938 
939         emit Transfer(owner, address(0), tokenId);
940 
941         _afterTokenTransfer(owner, address(0), tokenId);
942     }
943 
944     /**
945      * @dev Transfers `tokenId` from `from` to `to`.
946      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
947      *
948      * Requirements:
949      *
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {
960         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
961         require(to != address(0), "ERC721: transfer to the zero address");
962 
963         _beforeTokenTransfer(from, to, tokenId);
964 
965         // Clear approvals from the previous owner
966         _approve(address(0), tokenId);
967 
968         _balances[from] -= 1;
969         _balances[to] += 1;
970         _owners[tokenId] = to;
971 
972         emit Transfer(from, to, tokenId);
973 
974         _afterTokenTransfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev Approve `to` to operate on `tokenId`
979      *
980      * Emits an {Approval} event.
981      */
982     function _approve(address to, uint256 tokenId) internal virtual {
983         _tokenApprovals[tokenId] = to;
984         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
985     }
986 
987     /**
988      * @dev Approve `operator` to operate on all of `owner` tokens
989      *
990      * Emits an {ApprovalForAll} event.
991      */
992     function _setApprovalForAll(
993         address owner,
994         address operator,
995         bool approved
996     ) internal virtual {
997         require(owner != operator, "ERC721: approve to caller");
998         _operatorApprovals[owner][operator] = approved;
999         emit ApprovalForAll(owner, operator, approved);
1000     }
1001 
1002     /**
1003      * @dev Reverts if the `tokenId` has not been minted yet.
1004      */
1005     function _requireMinted(uint256 tokenId) internal view virtual {
1006         require(_exists(tokenId), "ERC721: invalid token ID");
1007     }
1008 
1009     /**
1010      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1011      * The call is not executed if the target address is not a contract.
1012      *
1013      * @param from address representing the previous owner of the given token ID
1014      * @param to target address that will receive the tokens
1015      * @param tokenId uint256 ID of the token to be transferred
1016      * @param data bytes optional data to send along with the call
1017      * @return bool whether the call correctly returned the expected magic value
1018      */
1019     function _checkOnERC721Received(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory data
1024     ) private returns (bool) {
1025         if (to.isContract()) {
1026             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1027                 return retval == IERC721Receiver.onERC721Received.selector;
1028             } catch (bytes memory reason) {
1029                 if (reason.length == 0) {
1030                     revert("ERC721: transfer to non ERC721Receiver implementer");
1031                 } else {
1032                     /// @solidity memory-safe-assembly
1033                     assembly {
1034                         revert(add(32, reason), mload(reason))
1035                     }
1036                 }
1037             }
1038         } else {
1039             return true;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1053      * - `from` and `to` are never both zero.
1054      *
1055      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1056      */
1057     function _beforeTokenTransfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {}
1062 
1063     /**
1064      * @dev Hook that is called after any transfer of tokens. This includes
1065      * minting and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - when `from` and `to` are both non-zero.
1070      * - `from` and `to` are never both zero.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _afterTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {}
1079 }
1080 
1081 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1082 
1083 
1084 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 
1089 
1090 /**
1091  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1092  * enumerability of all the token ids in the contract as well as all token ids owned by each
1093  * account.
1094  */
1095 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1096     // Mapping from owner to list of owned token IDs
1097     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1098 
1099     // Mapping from token ID to index of the owner tokens list
1100     mapping(uint256 => uint256) private _ownedTokensIndex;
1101 
1102     // Array with all token ids, used for enumeration
1103     uint256[] private _allTokens;
1104 
1105     // Mapping from token id to position in the allTokens array
1106     mapping(uint256 => uint256) private _allTokensIndex;
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      */
1111     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1112         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1120         return _ownedTokens[owner][index];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-totalSupply}.
1125      */
1126     function totalSupply() public view virtual override returns (uint256) {
1127         return _allTokens.length;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-tokenByIndex}.
1132      */
1133     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1134         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1135         return _allTokens[index];
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before any token transfer. This includes minting
1140      * and burning.
1141      *
1142      * Calling conditions:
1143      *
1144      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1145      * transferred to `to`.
1146      * - When `from` is zero, `tokenId` will be minted for `to`.
1147      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual override {
1158         super._beforeTokenTransfer(from, to, tokenId);
1159 
1160         if (from == address(0)) {
1161             _addTokenToAllTokensEnumeration(tokenId);
1162         } else if (from != to) {
1163             _removeTokenFromOwnerEnumeration(from, tokenId);
1164         }
1165         if (to == address(0)) {
1166             _removeTokenFromAllTokensEnumeration(tokenId);
1167         } else if (to != from) {
1168             _addTokenToOwnerEnumeration(to, tokenId);
1169         }
1170     }
1171 
1172     /**
1173      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1174      * @param to address representing the new owner of the given token ID
1175      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1176      */
1177     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1178         uint256 length = ERC721.balanceOf(to);
1179         _ownedTokens[to][length] = tokenId;
1180         _ownedTokensIndex[tokenId] = length;
1181     }
1182 
1183     /**
1184      * @dev Private function to add a token to this extension's token tracking data structures.
1185      * @param tokenId uint256 ID of the token to be added to the tokens list
1186      */
1187     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1188         _allTokensIndex[tokenId] = _allTokens.length;
1189         _allTokens.push(tokenId);
1190     }
1191 
1192     /**
1193      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1194      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1195      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1196      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1197      * @param from address representing the previous owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1199      */
1200     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1201         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1202         // then delete the last slot (swap and pop).
1203 
1204         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1205         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1206 
1207         // When the token to delete is the last token, the swap operation is unnecessary
1208         if (tokenIndex != lastTokenIndex) {
1209             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1210 
1211             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213         }
1214 
1215         // This also deletes the contents at the last position of the array
1216         delete _ownedTokensIndex[tokenId];
1217         delete _ownedTokens[from][lastTokenIndex];
1218     }
1219 
1220     /**
1221      * @dev Private function to remove a token from this extension's token tracking data structures.
1222      * This has O(1) time complexity, but alters the order of the _allTokens array.
1223      * @param tokenId uint256 ID of the token to be removed from the tokens list
1224      */
1225     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1226         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1227         // then delete the last slot (swap and pop).
1228 
1229         uint256 lastTokenIndex = _allTokens.length - 1;
1230         uint256 tokenIndex = _allTokensIndex[tokenId];
1231 
1232         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1233         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1234         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1235         uint256 lastTokenId = _allTokens[lastTokenIndex];
1236 
1237         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1238         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1239 
1240         // This also deletes the contents at the last position of the array
1241         delete _allTokensIndex[tokenId];
1242         _allTokens.pop();
1243     }
1244 }
1245 
1246 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 // CAUTION
1254 // This version of SafeMath should only be used with Solidity 0.8 or later,
1255 // because it relies on the compiler's built in overflow checks.
1256 
1257 /**
1258  * @dev Wrappers over Solidity's arithmetic operations.
1259  *
1260  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1261  * now has built in overflow checking.
1262  */
1263 library SafeMath {
1264     /**
1265      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1266      *
1267      * _Available since v3.4._
1268      */
1269     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1270         unchecked {
1271             uint256 c = a + b;
1272             if (c < a) return (false, 0);
1273             return (true, c);
1274         }
1275     }
1276 
1277     /**
1278      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1279      *
1280      * _Available since v3.4._
1281      */
1282     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1283         unchecked {
1284             if (b > a) return (false, 0);
1285             return (true, a - b);
1286         }
1287     }
1288 
1289     /**
1290      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1291      *
1292      * _Available since v3.4._
1293      */
1294     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1295         unchecked {
1296             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1297             // benefit is lost if 'b' is also tested.
1298             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1299             if (a == 0) return (true, 0);
1300             uint256 c = a * b;
1301             if (c / a != b) return (false, 0);
1302             return (true, c);
1303         }
1304     }
1305 
1306     /**
1307      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1308      *
1309      * _Available since v3.4._
1310      */
1311     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1312         unchecked {
1313             if (b == 0) return (false, 0);
1314             return (true, a / b);
1315         }
1316     }
1317 
1318     /**
1319      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1320      *
1321      * _Available since v3.4._
1322      */
1323     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1324         unchecked {
1325             if (b == 0) return (false, 0);
1326             return (true, a % b);
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the addition of two unsigned integers, reverting on
1332      * overflow.
1333      *
1334      * Counterpart to Solidity's `+` operator.
1335      *
1336      * Requirements:
1337      *
1338      * - Addition cannot overflow.
1339      */
1340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1341         return a + b;
1342     }
1343 
1344     /**
1345      * @dev Returns the subtraction of two unsigned integers, reverting on
1346      * overflow (when the result is negative).
1347      *
1348      * Counterpart to Solidity's `-` operator.
1349      *
1350      * Requirements:
1351      *
1352      * - Subtraction cannot overflow.
1353      */
1354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1355         return a - b;
1356     }
1357 
1358     /**
1359      * @dev Returns the multiplication of two unsigned integers, reverting on
1360      * overflow.
1361      *
1362      * Counterpart to Solidity's `*` operator.
1363      *
1364      * Requirements:
1365      *
1366      * - Multiplication cannot overflow.
1367      */
1368     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1369         return a * b;
1370     }
1371 
1372     /**
1373      * @dev Returns the integer division of two unsigned integers, reverting on
1374      * division by zero. The result is rounded towards zero.
1375      *
1376      * Counterpart to Solidity's `/` operator.
1377      *
1378      * Requirements:
1379      *
1380      * - The divisor cannot be zero.
1381      */
1382     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1383         return a / b;
1384     }
1385 
1386     /**
1387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1388      * reverting when dividing by zero.
1389      *
1390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1391      * opcode (which leaves remaining gas untouched) while Solidity uses an
1392      * invalid opcode to revert (consuming all remaining gas).
1393      *
1394      * Requirements:
1395      *
1396      * - The divisor cannot be zero.
1397      */
1398     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1399         return a % b;
1400     }
1401 
1402     /**
1403      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1404      * overflow (when the result is negative).
1405      *
1406      * CAUTION: This function is deprecated because it requires allocating memory for the error
1407      * message unnecessarily. For custom revert reasons use {trySub}.
1408      *
1409      * Counterpart to Solidity's `-` operator.
1410      *
1411      * Requirements:
1412      *
1413      * - Subtraction cannot overflow.
1414      */
1415     function sub(
1416         uint256 a,
1417         uint256 b,
1418         string memory errorMessage
1419     ) internal pure returns (uint256) {
1420         unchecked {
1421             require(b <= a, errorMessage);
1422             return a - b;
1423         }
1424     }
1425 
1426     /**
1427      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1428      * division by zero. The result is rounded towards zero.
1429      *
1430      * Counterpart to Solidity's `/` operator. Note: this function uses a
1431      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1432      * uses an invalid opcode to revert (consuming all remaining gas).
1433      *
1434      * Requirements:
1435      *
1436      * - The divisor cannot be zero.
1437      */
1438     function div(
1439         uint256 a,
1440         uint256 b,
1441         string memory errorMessage
1442     ) internal pure returns (uint256) {
1443         unchecked {
1444             require(b > 0, errorMessage);
1445             return a / b;
1446         }
1447     }
1448 
1449     /**
1450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1451      * reverting with custom message when dividing by zero.
1452      *
1453      * CAUTION: This function is deprecated because it requires allocating memory for the error
1454      * message unnecessarily. For custom revert reasons use {tryMod}.
1455      *
1456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1457      * opcode (which leaves remaining gas untouched) while Solidity uses an
1458      * invalid opcode to revert (consuming all remaining gas).
1459      *
1460      * Requirements:
1461      *
1462      * - The divisor cannot be zero.
1463      */
1464     function mod(
1465         uint256 a,
1466         uint256 b,
1467         string memory errorMessage
1468     ) internal pure returns (uint256) {
1469         unchecked {
1470             require(b > 0, errorMessage);
1471             return a % b;
1472         }
1473     }
1474 }
1475 
1476 // File: @openzeppelin/contracts/utils/math/SafeCast.sol
1477 
1478 
1479 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/SafeCast.sol)
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 /**
1484  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1485  * checks.
1486  *
1487  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1488  * easily result in undesired exploitation or bugs, since developers usually
1489  * assume that overflows raise errors. `SafeCast` restores this intuition by
1490  * reverting the transaction when such an operation overflows.
1491  *
1492  * Using this library instead of the unchecked operations eliminates an entire
1493  * class of bugs, so it's recommended to use it always.
1494  *
1495  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1496  * all math on `uint256` and `int256` and then downcasting.
1497  */
1498 library SafeCast {
1499     /**
1500      * @dev Returns the downcasted uint248 from uint256, reverting on
1501      * overflow (when the input is greater than largest uint248).
1502      *
1503      * Counterpart to Solidity's `uint248` operator.
1504      *
1505      * Requirements:
1506      *
1507      * - input must fit into 248 bits
1508      *
1509      * _Available since v4.7._
1510      */
1511     function toUint248(uint256 value) internal pure returns (uint248) {
1512         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
1513         return uint248(value);
1514     }
1515 
1516     /**
1517      * @dev Returns the downcasted uint240 from uint256, reverting on
1518      * overflow (when the input is greater than largest uint240).
1519      *
1520      * Counterpart to Solidity's `uint240` operator.
1521      *
1522      * Requirements:
1523      *
1524      * - input must fit into 240 bits
1525      *
1526      * _Available since v4.7._
1527      */
1528     function toUint240(uint256 value) internal pure returns (uint240) {
1529         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
1530         return uint240(value);
1531     }
1532 
1533     /**
1534      * @dev Returns the downcasted uint232 from uint256, reverting on
1535      * overflow (when the input is greater than largest uint232).
1536      *
1537      * Counterpart to Solidity's `uint232` operator.
1538      *
1539      * Requirements:
1540      *
1541      * - input must fit into 232 bits
1542      *
1543      * _Available since v4.7._
1544      */
1545     function toUint232(uint256 value) internal pure returns (uint232) {
1546         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
1547         return uint232(value);
1548     }
1549 
1550     /**
1551      * @dev Returns the downcasted uint224 from uint256, reverting on
1552      * overflow (when the input is greater than largest uint224).
1553      *
1554      * Counterpart to Solidity's `uint224` operator.
1555      *
1556      * Requirements:
1557      *
1558      * - input must fit into 224 bits
1559      *
1560      * _Available since v4.2._
1561      */
1562     function toUint224(uint256 value) internal pure returns (uint224) {
1563         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1564         return uint224(value);
1565     }
1566 
1567     /**
1568      * @dev Returns the downcasted uint216 from uint256, reverting on
1569      * overflow (when the input is greater than largest uint216).
1570      *
1571      * Counterpart to Solidity's `uint216` operator.
1572      *
1573      * Requirements:
1574      *
1575      * - input must fit into 216 bits
1576      *
1577      * _Available since v4.7._
1578      */
1579     function toUint216(uint256 value) internal pure returns (uint216) {
1580         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
1581         return uint216(value);
1582     }
1583 
1584     /**
1585      * @dev Returns the downcasted uint208 from uint256, reverting on
1586      * overflow (when the input is greater than largest uint208).
1587      *
1588      * Counterpart to Solidity's `uint208` operator.
1589      *
1590      * Requirements:
1591      *
1592      * - input must fit into 208 bits
1593      *
1594      * _Available since v4.7._
1595      */
1596     function toUint208(uint256 value) internal pure returns (uint208) {
1597         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
1598         return uint208(value);
1599     }
1600 
1601     /**
1602      * @dev Returns the downcasted uint200 from uint256, reverting on
1603      * overflow (when the input is greater than largest uint200).
1604      *
1605      * Counterpart to Solidity's `uint200` operator.
1606      *
1607      * Requirements:
1608      *
1609      * - input must fit into 200 bits
1610      *
1611      * _Available since v4.7._
1612      */
1613     function toUint200(uint256 value) internal pure returns (uint200) {
1614         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
1615         return uint200(value);
1616     }
1617 
1618     /**
1619      * @dev Returns the downcasted uint192 from uint256, reverting on
1620      * overflow (when the input is greater than largest uint192).
1621      *
1622      * Counterpart to Solidity's `uint192` operator.
1623      *
1624      * Requirements:
1625      *
1626      * - input must fit into 192 bits
1627      *
1628      * _Available since v4.7._
1629      */
1630     function toUint192(uint256 value) internal pure returns (uint192) {
1631         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
1632         return uint192(value);
1633     }
1634 
1635     /**
1636      * @dev Returns the downcasted uint184 from uint256, reverting on
1637      * overflow (when the input is greater than largest uint184).
1638      *
1639      * Counterpart to Solidity's `uint184` operator.
1640      *
1641      * Requirements:
1642      *
1643      * - input must fit into 184 bits
1644      *
1645      * _Available since v4.7._
1646      */
1647     function toUint184(uint256 value) internal pure returns (uint184) {
1648         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
1649         return uint184(value);
1650     }
1651 
1652     /**
1653      * @dev Returns the downcasted uint176 from uint256, reverting on
1654      * overflow (when the input is greater than largest uint176).
1655      *
1656      * Counterpart to Solidity's `uint176` operator.
1657      *
1658      * Requirements:
1659      *
1660      * - input must fit into 176 bits
1661      *
1662      * _Available since v4.7._
1663      */
1664     function toUint176(uint256 value) internal pure returns (uint176) {
1665         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
1666         return uint176(value);
1667     }
1668 
1669     /**
1670      * @dev Returns the downcasted uint168 from uint256, reverting on
1671      * overflow (when the input is greater than largest uint168).
1672      *
1673      * Counterpart to Solidity's `uint168` operator.
1674      *
1675      * Requirements:
1676      *
1677      * - input must fit into 168 bits
1678      *
1679      * _Available since v4.7._
1680      */
1681     function toUint168(uint256 value) internal pure returns (uint168) {
1682         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
1683         return uint168(value);
1684     }
1685 
1686     /**
1687      * @dev Returns the downcasted uint160 from uint256, reverting on
1688      * overflow (when the input is greater than largest uint160).
1689      *
1690      * Counterpart to Solidity's `uint160` operator.
1691      *
1692      * Requirements:
1693      *
1694      * - input must fit into 160 bits
1695      *
1696      * _Available since v4.7._
1697      */
1698     function toUint160(uint256 value) internal pure returns (uint160) {
1699         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
1700         return uint160(value);
1701     }
1702 
1703     /**
1704      * @dev Returns the downcasted uint152 from uint256, reverting on
1705      * overflow (when the input is greater than largest uint152).
1706      *
1707      * Counterpart to Solidity's `uint152` operator.
1708      *
1709      * Requirements:
1710      *
1711      * - input must fit into 152 bits
1712      *
1713      * _Available since v4.7._
1714      */
1715     function toUint152(uint256 value) internal pure returns (uint152) {
1716         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
1717         return uint152(value);
1718     }
1719 
1720     /**
1721      * @dev Returns the downcasted uint144 from uint256, reverting on
1722      * overflow (when the input is greater than largest uint144).
1723      *
1724      * Counterpart to Solidity's `uint144` operator.
1725      *
1726      * Requirements:
1727      *
1728      * - input must fit into 144 bits
1729      *
1730      * _Available since v4.7._
1731      */
1732     function toUint144(uint256 value) internal pure returns (uint144) {
1733         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
1734         return uint144(value);
1735     }
1736 
1737     /**
1738      * @dev Returns the downcasted uint136 from uint256, reverting on
1739      * overflow (when the input is greater than largest uint136).
1740      *
1741      * Counterpart to Solidity's `uint136` operator.
1742      *
1743      * Requirements:
1744      *
1745      * - input must fit into 136 bits
1746      *
1747      * _Available since v4.7._
1748      */
1749     function toUint136(uint256 value) internal pure returns (uint136) {
1750         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
1751         return uint136(value);
1752     }
1753 
1754     /**
1755      * @dev Returns the downcasted uint128 from uint256, reverting on
1756      * overflow (when the input is greater than largest uint128).
1757      *
1758      * Counterpart to Solidity's `uint128` operator.
1759      *
1760      * Requirements:
1761      *
1762      * - input must fit into 128 bits
1763      *
1764      * _Available since v2.5._
1765      */
1766     function toUint128(uint256 value) internal pure returns (uint128) {
1767         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1768         return uint128(value);
1769     }
1770 
1771     /**
1772      * @dev Returns the downcasted uint120 from uint256, reverting on
1773      * overflow (when the input is greater than largest uint120).
1774      *
1775      * Counterpart to Solidity's `uint120` operator.
1776      *
1777      * Requirements:
1778      *
1779      * - input must fit into 120 bits
1780      *
1781      * _Available since v4.7._
1782      */
1783     function toUint120(uint256 value) internal pure returns (uint120) {
1784         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
1785         return uint120(value);
1786     }
1787 
1788     /**
1789      * @dev Returns the downcasted uint112 from uint256, reverting on
1790      * overflow (when the input is greater than largest uint112).
1791      *
1792      * Counterpart to Solidity's `uint112` operator.
1793      *
1794      * Requirements:
1795      *
1796      * - input must fit into 112 bits
1797      *
1798      * _Available since v4.7._
1799      */
1800     function toUint112(uint256 value) internal pure returns (uint112) {
1801         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
1802         return uint112(value);
1803     }
1804 
1805     /**
1806      * @dev Returns the downcasted uint104 from uint256, reverting on
1807      * overflow (when the input is greater than largest uint104).
1808      *
1809      * Counterpart to Solidity's `uint104` operator.
1810      *
1811      * Requirements:
1812      *
1813      * - input must fit into 104 bits
1814      *
1815      * _Available since v4.7._
1816      */
1817     function toUint104(uint256 value) internal pure returns (uint104) {
1818         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
1819         return uint104(value);
1820     }
1821 
1822     /**
1823      * @dev Returns the downcasted uint96 from uint256, reverting on
1824      * overflow (when the input is greater than largest uint96).
1825      *
1826      * Counterpart to Solidity's `uint96` operator.
1827      *
1828      * Requirements:
1829      *
1830      * - input must fit into 96 bits
1831      *
1832      * _Available since v4.2._
1833      */
1834     function toUint96(uint256 value) internal pure returns (uint96) {
1835         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1836         return uint96(value);
1837     }
1838 
1839     /**
1840      * @dev Returns the downcasted uint88 from uint256, reverting on
1841      * overflow (when the input is greater than largest uint88).
1842      *
1843      * Counterpart to Solidity's `uint88` operator.
1844      *
1845      * Requirements:
1846      *
1847      * - input must fit into 88 bits
1848      *
1849      * _Available since v4.7._
1850      */
1851     function toUint88(uint256 value) internal pure returns (uint88) {
1852         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
1853         return uint88(value);
1854     }
1855 
1856     /**
1857      * @dev Returns the downcasted uint80 from uint256, reverting on
1858      * overflow (when the input is greater than largest uint80).
1859      *
1860      * Counterpart to Solidity's `uint80` operator.
1861      *
1862      * Requirements:
1863      *
1864      * - input must fit into 80 bits
1865      *
1866      * _Available since v4.7._
1867      */
1868     function toUint80(uint256 value) internal pure returns (uint80) {
1869         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
1870         return uint80(value);
1871     }
1872 
1873     /**
1874      * @dev Returns the downcasted uint72 from uint256, reverting on
1875      * overflow (when the input is greater than largest uint72).
1876      *
1877      * Counterpart to Solidity's `uint72` operator.
1878      *
1879      * Requirements:
1880      *
1881      * - input must fit into 72 bits
1882      *
1883      * _Available since v4.7._
1884      */
1885     function toUint72(uint256 value) internal pure returns (uint72) {
1886         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
1887         return uint72(value);
1888     }
1889 
1890     /**
1891      * @dev Returns the downcasted uint64 from uint256, reverting on
1892      * overflow (when the input is greater than largest uint64).
1893      *
1894      * Counterpart to Solidity's `uint64` operator.
1895      *
1896      * Requirements:
1897      *
1898      * - input must fit into 64 bits
1899      *
1900      * _Available since v2.5._
1901      */
1902     function toUint64(uint256 value) internal pure returns (uint64) {
1903         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1904         return uint64(value);
1905     }
1906 
1907     /**
1908      * @dev Returns the downcasted uint56 from uint256, reverting on
1909      * overflow (when the input is greater than largest uint56).
1910      *
1911      * Counterpart to Solidity's `uint56` operator.
1912      *
1913      * Requirements:
1914      *
1915      * - input must fit into 56 bits
1916      *
1917      * _Available since v4.7._
1918      */
1919     function toUint56(uint256 value) internal pure returns (uint56) {
1920         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
1921         return uint56(value);
1922     }
1923 
1924     /**
1925      * @dev Returns the downcasted uint48 from uint256, reverting on
1926      * overflow (when the input is greater than largest uint48).
1927      *
1928      * Counterpart to Solidity's `uint48` operator.
1929      *
1930      * Requirements:
1931      *
1932      * - input must fit into 48 bits
1933      *
1934      * _Available since v4.7._
1935      */
1936     function toUint48(uint256 value) internal pure returns (uint48) {
1937         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
1938         return uint48(value);
1939     }
1940 
1941     /**
1942      * @dev Returns the downcasted uint40 from uint256, reverting on
1943      * overflow (when the input is greater than largest uint40).
1944      *
1945      * Counterpart to Solidity's `uint40` operator.
1946      *
1947      * Requirements:
1948      *
1949      * - input must fit into 40 bits
1950      *
1951      * _Available since v4.7._
1952      */
1953     function toUint40(uint256 value) internal pure returns (uint40) {
1954         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
1955         return uint40(value);
1956     }
1957 
1958     /**
1959      * @dev Returns the downcasted uint32 from uint256, reverting on
1960      * overflow (when the input is greater than largest uint32).
1961      *
1962      * Counterpart to Solidity's `uint32` operator.
1963      *
1964      * Requirements:
1965      *
1966      * - input must fit into 32 bits
1967      *
1968      * _Available since v2.5._
1969      */
1970     function toUint32(uint256 value) internal pure returns (uint32) {
1971         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1972         return uint32(value);
1973     }
1974 
1975     /**
1976      * @dev Returns the downcasted uint24 from uint256, reverting on
1977      * overflow (when the input is greater than largest uint24).
1978      *
1979      * Counterpart to Solidity's `uint24` operator.
1980      *
1981      * Requirements:
1982      *
1983      * - input must fit into 24 bits
1984      *
1985      * _Available since v4.7._
1986      */
1987     function toUint24(uint256 value) internal pure returns (uint24) {
1988         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
1989         return uint24(value);
1990     }
1991 
1992     /**
1993      * @dev Returns the downcasted uint16 from uint256, reverting on
1994      * overflow (when the input is greater than largest uint16).
1995      *
1996      * Counterpart to Solidity's `uint16` operator.
1997      *
1998      * Requirements:
1999      *
2000      * - input must fit into 16 bits
2001      *
2002      * _Available since v2.5._
2003      */
2004     function toUint16(uint256 value) internal pure returns (uint16) {
2005         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
2006         return uint16(value);
2007     }
2008 
2009     /**
2010      * @dev Returns the downcasted uint8 from uint256, reverting on
2011      * overflow (when the input is greater than largest uint8).
2012      *
2013      * Counterpart to Solidity's `uint8` operator.
2014      *
2015      * Requirements:
2016      *
2017      * - input must fit into 8 bits
2018      *
2019      * _Available since v2.5._
2020      */
2021     function toUint8(uint256 value) internal pure returns (uint8) {
2022         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
2023         return uint8(value);
2024     }
2025 
2026     /**
2027      * @dev Converts a signed int256 into an unsigned uint256.
2028      *
2029      * Requirements:
2030      *
2031      * - input must be greater than or equal to 0.
2032      *
2033      * _Available since v3.0._
2034      */
2035     function toUint256(int256 value) internal pure returns (uint256) {
2036         require(value >= 0, "SafeCast: value must be positive");
2037         return uint256(value);
2038     }
2039 
2040     /**
2041      * @dev Returns the downcasted int248 from int256, reverting on
2042      * overflow (when the input is less than smallest int248 or
2043      * greater than largest int248).
2044      *
2045      * Counterpart to Solidity's `int248` operator.
2046      *
2047      * Requirements:
2048      *
2049      * - input must fit into 248 bits
2050      *
2051      * _Available since v4.7._
2052      */
2053     function toInt248(int256 value) internal pure returns (int248) {
2054         require(value >= type(int248).min && value <= type(int248).max, "SafeCast: value doesn't fit in 248 bits");
2055         return int248(value);
2056     }
2057 
2058     /**
2059      * @dev Returns the downcasted int240 from int256, reverting on
2060      * overflow (when the input is less than smallest int240 or
2061      * greater than largest int240).
2062      *
2063      * Counterpart to Solidity's `int240` operator.
2064      *
2065      * Requirements:
2066      *
2067      * - input must fit into 240 bits
2068      *
2069      * _Available since v4.7._
2070      */
2071     function toInt240(int256 value) internal pure returns (int240) {
2072         require(value >= type(int240).min && value <= type(int240).max, "SafeCast: value doesn't fit in 240 bits");
2073         return int240(value);
2074     }
2075 
2076     /**
2077      * @dev Returns the downcasted int232 from int256, reverting on
2078      * overflow (when the input is less than smallest int232 or
2079      * greater than largest int232).
2080      *
2081      * Counterpart to Solidity's `int232` operator.
2082      *
2083      * Requirements:
2084      *
2085      * - input must fit into 232 bits
2086      *
2087      * _Available since v4.7._
2088      */
2089     function toInt232(int256 value) internal pure returns (int232) {
2090         require(value >= type(int232).min && value <= type(int232).max, "SafeCast: value doesn't fit in 232 bits");
2091         return int232(value);
2092     }
2093 
2094     /**
2095      * @dev Returns the downcasted int224 from int256, reverting on
2096      * overflow (when the input is less than smallest int224 or
2097      * greater than largest int224).
2098      *
2099      * Counterpart to Solidity's `int224` operator.
2100      *
2101      * Requirements:
2102      *
2103      * - input must fit into 224 bits
2104      *
2105      * _Available since v4.7._
2106      */
2107     function toInt224(int256 value) internal pure returns (int224) {
2108         require(value >= type(int224).min && value <= type(int224).max, "SafeCast: value doesn't fit in 224 bits");
2109         return int224(value);
2110     }
2111 
2112     /**
2113      * @dev Returns the downcasted int216 from int256, reverting on
2114      * overflow (when the input is less than smallest int216 or
2115      * greater than largest int216).
2116      *
2117      * Counterpart to Solidity's `int216` operator.
2118      *
2119      * Requirements:
2120      *
2121      * - input must fit into 216 bits
2122      *
2123      * _Available since v4.7._
2124      */
2125     function toInt216(int256 value) internal pure returns (int216) {
2126         require(value >= type(int216).min && value <= type(int216).max, "SafeCast: value doesn't fit in 216 bits");
2127         return int216(value);
2128     }
2129 
2130     /**
2131      * @dev Returns the downcasted int208 from int256, reverting on
2132      * overflow (when the input is less than smallest int208 or
2133      * greater than largest int208).
2134      *
2135      * Counterpart to Solidity's `int208` operator.
2136      *
2137      * Requirements:
2138      *
2139      * - input must fit into 208 bits
2140      *
2141      * _Available since v4.7._
2142      */
2143     function toInt208(int256 value) internal pure returns (int208) {
2144         require(value >= type(int208).min && value <= type(int208).max, "SafeCast: value doesn't fit in 208 bits");
2145         return int208(value);
2146     }
2147 
2148     /**
2149      * @dev Returns the downcasted int200 from int256, reverting on
2150      * overflow (when the input is less than smallest int200 or
2151      * greater than largest int200).
2152      *
2153      * Counterpart to Solidity's `int200` operator.
2154      *
2155      * Requirements:
2156      *
2157      * - input must fit into 200 bits
2158      *
2159      * _Available since v4.7._
2160      */
2161     function toInt200(int256 value) internal pure returns (int200) {
2162         require(value >= type(int200).min && value <= type(int200).max, "SafeCast: value doesn't fit in 200 bits");
2163         return int200(value);
2164     }
2165 
2166     /**
2167      * @dev Returns the downcasted int192 from int256, reverting on
2168      * overflow (when the input is less than smallest int192 or
2169      * greater than largest int192).
2170      *
2171      * Counterpart to Solidity's `int192` operator.
2172      *
2173      * Requirements:
2174      *
2175      * - input must fit into 192 bits
2176      *
2177      * _Available since v4.7._
2178      */
2179     function toInt192(int256 value) internal pure returns (int192) {
2180         require(value >= type(int192).min && value <= type(int192).max, "SafeCast: value doesn't fit in 192 bits");
2181         return int192(value);
2182     }
2183 
2184     /**
2185      * @dev Returns the downcasted int184 from int256, reverting on
2186      * overflow (when the input is less than smallest int184 or
2187      * greater than largest int184).
2188      *
2189      * Counterpart to Solidity's `int184` operator.
2190      *
2191      * Requirements:
2192      *
2193      * - input must fit into 184 bits
2194      *
2195      * _Available since v4.7._
2196      */
2197     function toInt184(int256 value) internal pure returns (int184) {
2198         require(value >= type(int184).min && value <= type(int184).max, "SafeCast: value doesn't fit in 184 bits");
2199         return int184(value);
2200     }
2201 
2202     /**
2203      * @dev Returns the downcasted int176 from int256, reverting on
2204      * overflow (when the input is less than smallest int176 or
2205      * greater than largest int176).
2206      *
2207      * Counterpart to Solidity's `int176` operator.
2208      *
2209      * Requirements:
2210      *
2211      * - input must fit into 176 bits
2212      *
2213      * _Available since v4.7._
2214      */
2215     function toInt176(int256 value) internal pure returns (int176) {
2216         require(value >= type(int176).min && value <= type(int176).max, "SafeCast: value doesn't fit in 176 bits");
2217         return int176(value);
2218     }
2219 
2220     /**
2221      * @dev Returns the downcasted int168 from int256, reverting on
2222      * overflow (when the input is less than smallest int168 or
2223      * greater than largest int168).
2224      *
2225      * Counterpart to Solidity's `int168` operator.
2226      *
2227      * Requirements:
2228      *
2229      * - input must fit into 168 bits
2230      *
2231      * _Available since v4.7._
2232      */
2233     function toInt168(int256 value) internal pure returns (int168) {
2234         require(value >= type(int168).min && value <= type(int168).max, "SafeCast: value doesn't fit in 168 bits");
2235         return int168(value);
2236     }
2237 
2238     /**
2239      * @dev Returns the downcasted int160 from int256, reverting on
2240      * overflow (when the input is less than smallest int160 or
2241      * greater than largest int160).
2242      *
2243      * Counterpart to Solidity's `int160` operator.
2244      *
2245      * Requirements:
2246      *
2247      * - input must fit into 160 bits
2248      *
2249      * _Available since v4.7._
2250      */
2251     function toInt160(int256 value) internal pure returns (int160) {
2252         require(value >= type(int160).min && value <= type(int160).max, "SafeCast: value doesn't fit in 160 bits");
2253         return int160(value);
2254     }
2255 
2256     /**
2257      * @dev Returns the downcasted int152 from int256, reverting on
2258      * overflow (when the input is less than smallest int152 or
2259      * greater than largest int152).
2260      *
2261      * Counterpart to Solidity's `int152` operator.
2262      *
2263      * Requirements:
2264      *
2265      * - input must fit into 152 bits
2266      *
2267      * _Available since v4.7._
2268      */
2269     function toInt152(int256 value) internal pure returns (int152) {
2270         require(value >= type(int152).min && value <= type(int152).max, "SafeCast: value doesn't fit in 152 bits");
2271         return int152(value);
2272     }
2273 
2274     /**
2275      * @dev Returns the downcasted int144 from int256, reverting on
2276      * overflow (when the input is less than smallest int144 or
2277      * greater than largest int144).
2278      *
2279      * Counterpart to Solidity's `int144` operator.
2280      *
2281      * Requirements:
2282      *
2283      * - input must fit into 144 bits
2284      *
2285      * _Available since v4.7._
2286      */
2287     function toInt144(int256 value) internal pure returns (int144) {
2288         require(value >= type(int144).min && value <= type(int144).max, "SafeCast: value doesn't fit in 144 bits");
2289         return int144(value);
2290     }
2291 
2292     /**
2293      * @dev Returns the downcasted int136 from int256, reverting on
2294      * overflow (when the input is less than smallest int136 or
2295      * greater than largest int136).
2296      *
2297      * Counterpart to Solidity's `int136` operator.
2298      *
2299      * Requirements:
2300      *
2301      * - input must fit into 136 bits
2302      *
2303      * _Available since v4.7._
2304      */
2305     function toInt136(int256 value) internal pure returns (int136) {
2306         require(value >= type(int136).min && value <= type(int136).max, "SafeCast: value doesn't fit in 136 bits");
2307         return int136(value);
2308     }
2309 
2310     /**
2311      * @dev Returns the downcasted int128 from int256, reverting on
2312      * overflow (when the input is less than smallest int128 or
2313      * greater than largest int128).
2314      *
2315      * Counterpart to Solidity's `int128` operator.
2316      *
2317      * Requirements:
2318      *
2319      * - input must fit into 128 bits
2320      *
2321      * _Available since v3.1._
2322      */
2323     function toInt128(int256 value) internal pure returns (int128) {
2324         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
2325         return int128(value);
2326     }
2327 
2328     /**
2329      * @dev Returns the downcasted int120 from int256, reverting on
2330      * overflow (when the input is less than smallest int120 or
2331      * greater than largest int120).
2332      *
2333      * Counterpart to Solidity's `int120` operator.
2334      *
2335      * Requirements:
2336      *
2337      * - input must fit into 120 bits
2338      *
2339      * _Available since v4.7._
2340      */
2341     function toInt120(int256 value) internal pure returns (int120) {
2342         require(value >= type(int120).min && value <= type(int120).max, "SafeCast: value doesn't fit in 120 bits");
2343         return int120(value);
2344     }
2345 
2346     /**
2347      * @dev Returns the downcasted int112 from int256, reverting on
2348      * overflow (when the input is less than smallest int112 or
2349      * greater than largest int112).
2350      *
2351      * Counterpart to Solidity's `int112` operator.
2352      *
2353      * Requirements:
2354      *
2355      * - input must fit into 112 bits
2356      *
2357      * _Available since v4.7._
2358      */
2359     function toInt112(int256 value) internal pure returns (int112) {
2360         require(value >= type(int112).min && value <= type(int112).max, "SafeCast: value doesn't fit in 112 bits");
2361         return int112(value);
2362     }
2363 
2364     /**
2365      * @dev Returns the downcasted int104 from int256, reverting on
2366      * overflow (when the input is less than smallest int104 or
2367      * greater than largest int104).
2368      *
2369      * Counterpart to Solidity's `int104` operator.
2370      *
2371      * Requirements:
2372      *
2373      * - input must fit into 104 bits
2374      *
2375      * _Available since v4.7._
2376      */
2377     function toInt104(int256 value) internal pure returns (int104) {
2378         require(value >= type(int104).min && value <= type(int104).max, "SafeCast: value doesn't fit in 104 bits");
2379         return int104(value);
2380     }
2381 
2382     /**
2383      * @dev Returns the downcasted int96 from int256, reverting on
2384      * overflow (when the input is less than smallest int96 or
2385      * greater than largest int96).
2386      *
2387      * Counterpart to Solidity's `int96` operator.
2388      *
2389      * Requirements:
2390      *
2391      * - input must fit into 96 bits
2392      *
2393      * _Available since v4.7._
2394      */
2395     function toInt96(int256 value) internal pure returns (int96) {
2396         require(value >= type(int96).min && value <= type(int96).max, "SafeCast: value doesn't fit in 96 bits");
2397         return int96(value);
2398     }
2399 
2400     /**
2401      * @dev Returns the downcasted int88 from int256, reverting on
2402      * overflow (when the input is less than smallest int88 or
2403      * greater than largest int88).
2404      *
2405      * Counterpart to Solidity's `int88` operator.
2406      *
2407      * Requirements:
2408      *
2409      * - input must fit into 88 bits
2410      *
2411      * _Available since v4.7._
2412      */
2413     function toInt88(int256 value) internal pure returns (int88) {
2414         require(value >= type(int88).min && value <= type(int88).max, "SafeCast: value doesn't fit in 88 bits");
2415         return int88(value);
2416     }
2417 
2418     /**
2419      * @dev Returns the downcasted int80 from int256, reverting on
2420      * overflow (when the input is less than smallest int80 or
2421      * greater than largest int80).
2422      *
2423      * Counterpart to Solidity's `int80` operator.
2424      *
2425      * Requirements:
2426      *
2427      * - input must fit into 80 bits
2428      *
2429      * _Available since v4.7._
2430      */
2431     function toInt80(int256 value) internal pure returns (int80) {
2432         require(value >= type(int80).min && value <= type(int80).max, "SafeCast: value doesn't fit in 80 bits");
2433         return int80(value);
2434     }
2435 
2436     /**
2437      * @dev Returns the downcasted int72 from int256, reverting on
2438      * overflow (when the input is less than smallest int72 or
2439      * greater than largest int72).
2440      *
2441      * Counterpart to Solidity's `int72` operator.
2442      *
2443      * Requirements:
2444      *
2445      * - input must fit into 72 bits
2446      *
2447      * _Available since v4.7._
2448      */
2449     function toInt72(int256 value) internal pure returns (int72) {
2450         require(value >= type(int72).min && value <= type(int72).max, "SafeCast: value doesn't fit in 72 bits");
2451         return int72(value);
2452     }
2453 
2454     /**
2455      * @dev Returns the downcasted int64 from int256, reverting on
2456      * overflow (when the input is less than smallest int64 or
2457      * greater than largest int64).
2458      *
2459      * Counterpart to Solidity's `int64` operator.
2460      *
2461      * Requirements:
2462      *
2463      * - input must fit into 64 bits
2464      *
2465      * _Available since v3.1._
2466      */
2467     function toInt64(int256 value) internal pure returns (int64) {
2468         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
2469         return int64(value);
2470     }
2471 
2472     /**
2473      * @dev Returns the downcasted int56 from int256, reverting on
2474      * overflow (when the input is less than smallest int56 or
2475      * greater than largest int56).
2476      *
2477      * Counterpart to Solidity's `int56` operator.
2478      *
2479      * Requirements:
2480      *
2481      * - input must fit into 56 bits
2482      *
2483      * _Available since v4.7._
2484      */
2485     function toInt56(int256 value) internal pure returns (int56) {
2486         require(value >= type(int56).min && value <= type(int56).max, "SafeCast: value doesn't fit in 56 bits");
2487         return int56(value);
2488     }
2489 
2490     /**
2491      * @dev Returns the downcasted int48 from int256, reverting on
2492      * overflow (when the input is less than smallest int48 or
2493      * greater than largest int48).
2494      *
2495      * Counterpart to Solidity's `int48` operator.
2496      *
2497      * Requirements:
2498      *
2499      * - input must fit into 48 bits
2500      *
2501      * _Available since v4.7._
2502      */
2503     function toInt48(int256 value) internal pure returns (int48) {
2504         require(value >= type(int48).min && value <= type(int48).max, "SafeCast: value doesn't fit in 48 bits");
2505         return int48(value);
2506     }
2507 
2508     /**
2509      * @dev Returns the downcasted int40 from int256, reverting on
2510      * overflow (when the input is less than smallest int40 or
2511      * greater than largest int40).
2512      *
2513      * Counterpart to Solidity's `int40` operator.
2514      *
2515      * Requirements:
2516      *
2517      * - input must fit into 40 bits
2518      *
2519      * _Available since v4.7._
2520      */
2521     function toInt40(int256 value) internal pure returns (int40) {
2522         require(value >= type(int40).min && value <= type(int40).max, "SafeCast: value doesn't fit in 40 bits");
2523         return int40(value);
2524     }
2525 
2526     /**
2527      * @dev Returns the downcasted int32 from int256, reverting on
2528      * overflow (when the input is less than smallest int32 or
2529      * greater than largest int32).
2530      *
2531      * Counterpart to Solidity's `int32` operator.
2532      *
2533      * Requirements:
2534      *
2535      * - input must fit into 32 bits
2536      *
2537      * _Available since v3.1._
2538      */
2539     function toInt32(int256 value) internal pure returns (int32) {
2540         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
2541         return int32(value);
2542     }
2543 
2544     /**
2545      * @dev Returns the downcasted int24 from int256, reverting on
2546      * overflow (when the input is less than smallest int24 or
2547      * greater than largest int24).
2548      *
2549      * Counterpart to Solidity's `int24` operator.
2550      *
2551      * Requirements:
2552      *
2553      * - input must fit into 24 bits
2554      *
2555      * _Available since v4.7._
2556      */
2557     function toInt24(int256 value) internal pure returns (int24) {
2558         require(value >= type(int24).min && value <= type(int24).max, "SafeCast: value doesn't fit in 24 bits");
2559         return int24(value);
2560     }
2561 
2562     /**
2563      * @dev Returns the downcasted int16 from int256, reverting on
2564      * overflow (when the input is less than smallest int16 or
2565      * greater than largest int16).
2566      *
2567      * Counterpart to Solidity's `int16` operator.
2568      *
2569      * Requirements:
2570      *
2571      * - input must fit into 16 bits
2572      *
2573      * _Available since v3.1._
2574      */
2575     function toInt16(int256 value) internal pure returns (int16) {
2576         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
2577         return int16(value);
2578     }
2579 
2580     /**
2581      * @dev Returns the downcasted int8 from int256, reverting on
2582      * overflow (when the input is less than smallest int8 or
2583      * greater than largest int8).
2584      *
2585      * Counterpart to Solidity's `int8` operator.
2586      *
2587      * Requirements:
2588      *
2589      * - input must fit into 8 bits
2590      *
2591      * _Available since v3.1._
2592      */
2593     function toInt8(int256 value) internal pure returns (int8) {
2594         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
2595         return int8(value);
2596     }
2597 
2598     /**
2599      * @dev Converts an unsigned uint256 into a signed int256.
2600      *
2601      * Requirements:
2602      *
2603      * - input must be less than or equal to maxInt256.
2604      *
2605      * _Available since v3.0._
2606      */
2607     function toInt256(uint256 value) internal pure returns (int256) {
2608         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
2609         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
2610         return int256(value);
2611     }
2612 }
2613 
2614 // File: @chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol
2615 
2616 
2617 pragma solidity ^0.8.0;
2618 
2619 interface AggregatorInterface {
2620   function latestAnswer() external view returns (int256);
2621 
2622   function latestTimestamp() external view returns (uint256);
2623 
2624   function latestRound() external view returns (uint256);
2625 
2626   function getAnswer(uint256 roundId) external view returns (int256);
2627 
2628   function getTimestamp(uint256 roundId) external view returns (uint256);
2629 
2630   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
2631 
2632   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
2633 }
2634 
2635 // File: Ethereum.sol
2636 
2637 
2638 
2639 
2640 
2641 
2642 
2643 
2644 
2645 
2646 pragma solidity >=0.5.0;
2647 
2648 interface ILayerZeroUserApplicationConfig {
2649     // @notice set the configuration of the LayerZero messaging library of the specified version
2650     // @param _version - messaging library version
2651     // @param _chainId - the chainId for the pending config change
2652     // @param _configType - type of configuration. every messaging library has its own convention.
2653     // @param _config - configuration in the bytes. can encode arbitrary content.
2654     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
2655 
2656     // @notice set the send() LayerZero messaging library version to _version
2657     // @param _version - new messaging library version
2658     function setSendVersion(uint16 _version) external;
2659 
2660     // @notice set the lzReceive() LayerZero messaging library version to _version
2661     // @param _version - new messaging library version
2662     function setReceiveVersion(uint16 _version) external;
2663 
2664     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
2665     // @param _srcChainId - the chainId of the source chain
2666     // @param _srcAddress - the contract address of the source contract at the source chain
2667     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
2668 }
2669 
2670 // File: contracts/interfaces/ILayerZeroEndpoint.sol
2671 
2672 
2673 
2674 pragma solidity >=0.5.0;
2675 
2676 
2677 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
2678     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
2679     // @param _dstChainId - the destination chain identifier
2680     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
2681     // @param _payload - a custom bytes payload to send to the destination contract
2682     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
2683     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
2684     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
2685     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
2686 
2687     // @notice used by the messaging library to publish verified payload
2688     // @param _srcChainId - the source chain identifier
2689     // @param _srcAddress - the source contract (as bytes) at the source chain
2690     // @param _dstAddress - the address on destination chain
2691     // @param _nonce - the unbound message ordering nonce
2692     // @param _gasLimit - the gas limit for external contract execution
2693     // @param _payload - verified payload to send to the destination contract
2694     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
2695 
2696     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
2697     // @param _srcChainId - the source chain identifier
2698     // @param _srcAddress - the source chain contract address
2699     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
2700 
2701     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
2702     // @param _srcAddress - the source chain contract address
2703     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
2704 
2705     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
2706     // @param _dstChainId - the destination chain identifier
2707     // @param _userApplication - the user app address on this EVM chain
2708     // @param _payload - the custom message to send over LayerZero
2709     // @param _payInZRO - if false, user app pays the protocol fee in native token
2710     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
2711     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
2712 
2713     // @notice get this Endpoint's immutable source identifier
2714     function getChainId() external view returns (uint16);
2715 
2716     // @notice the interface to retry failed message on this Endpoint destination
2717     // @param _srcChainId - the source chain identifier
2718     // @param _srcAddress - the source chain contract address
2719     // @param _payload - the payload to be retried
2720     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
2721 
2722     // @notice query if any STORED payload (message blocking) at the endpoint.
2723     // @param _srcChainId - the source chain identifier
2724     // @param _srcAddress - the source chain contract address
2725     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
2726 
2727     // @notice query if the _libraryAddress is valid for sending msgs.
2728     // @param _userApplication - the user app address on this EVM chain
2729     function getSendLibraryAddress(address _userApplication) external view returns (address);
2730 
2731     // @notice query if the _libraryAddress is valid for receiving msgs.
2732     // @param _userApplication - the user app address on this EVM chain
2733     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
2734 
2735     // @notice query if the non-reentrancy guard for send() is on
2736     // @return true if the guard is on. false otherwise
2737     function isSendingPayload() external view returns (bool);
2738 
2739     // @notice query if the non-reentrancy guard for receive() is on
2740     // @return true if the guard is on. false otherwise
2741     function isReceivingPayload() external view returns (bool);
2742 
2743     // @notice get the configuration of the LayerZero messaging library of the specified version
2744     // @param _version - messaging library version
2745     // @param _chainId - the chainId for the pending config change
2746     // @param _userApplication - the contract address of the user application
2747     // @param _configType - type of configuration. every messaging library has its own convention.
2748     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
2749 
2750     // @notice get the send() LayerZero messaging library version
2751     // @param _userApplication - the contract address of the user application
2752     function getSendVersion(address _userApplication) external view returns (uint16);
2753 
2754     // @notice get the lzReceive() LayerZero messaging library version
2755     // @param _userApplication - the contract address of the user application
2756     function getReceiveVersion(address _userApplication) external view returns (uint16);
2757 }
2758 
2759 // File: contracts/interfaces/ILayerZeroReceiver.sol
2760 
2761 
2762 
2763 pragma solidity >=0.5.0;
2764 
2765 interface ILayerZeroReceiver {
2766     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
2767     // @param _srcChainId - the source endpoint identifier
2768     // @param _srcAddress - the source sending contract address from the source chain
2769     // @param _nonce - the ordered message nonce
2770     // @param _payload - the signed payload is the UA bytes has encoded to be sent
2771     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
2772 }
2773 
2774 // File: @openzeppelin/contracts/access/Ownable.sol
2775 
2776 
2777 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2778 
2779 pragma solidity ^0.8.0;
2780 
2781 
2782 /**
2783  * @dev Contract module which provides a basic access control mechanism, where
2784  * there is an account (an owner) that can be granted exclusive access to
2785  * specific functions.
2786  *
2787  * By default, the owner account will be the one that deploys the contract. This
2788  * can later be changed with {transferOwnership}.
2789  *
2790  * This module is used through inheritance. It will make available the modifier
2791  * `onlyOwner`, which can be applied to your functions to restrict their use to
2792  * the owner.
2793  */
2794 abstract contract Ownable is Context {
2795     address private _owner;
2796 
2797     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2798 
2799     /**
2800      * @dev Initializes the contract setting the deployer as the initial owner.
2801      */
2802     constructor() {
2803         _transferOwnership(_msgSender());
2804     }
2805 
2806     /**
2807      * @dev Returns the address of the current owner.
2808      */
2809     function owner() public view virtual returns (address) {
2810         return _owner;
2811     }
2812 
2813     /**
2814      * @dev Throws if called by any account other than the owner.
2815      */
2816     modifier onlyOwner() {
2817         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2818         _;
2819     }
2820 
2821     /**
2822      * @dev Leaves the contract without owner. It will not be possible to call
2823      * `onlyOwner` functions anymore. Can only be called by the current owner.
2824      *
2825      * NOTE: Renouncing ownership will leave the contract without an owner,
2826      * thereby removing any functionality that is only available to the owner.
2827      */
2828     function renounceOwnership() public virtual onlyOwner {
2829         _transferOwnership(address(0));
2830     }
2831 
2832     /**
2833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2834      * Can only be called by the current owner.
2835      */
2836     function transferOwnership(address newOwner) public virtual onlyOwner {
2837         require(newOwner != address(0), "Ownable: new owner is the zero address");
2838         _transferOwnership(newOwner);
2839     }
2840 
2841     /**
2842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2843      * Internal function without access restriction.
2844      */
2845     function _transferOwnership(address newOwner) internal virtual {
2846         address oldOwner = _owner;
2847         _owner = newOwner;
2848         emit OwnershipTransferred(oldOwner, newOwner);
2849     }
2850 }
2851 
2852 // File: contracts/NonblockingReceiver.sol
2853 
2854 
2855 pragma solidity ^0.8.6;
2856 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
2857 
2858     ILayerZeroEndpoint internal endpoint;
2859 
2860     struct FailedMessages {
2861         uint payloadLength;
2862         bytes32 payloadHash;
2863     }
2864 
2865     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
2866     mapping(uint16 => bytes) public trustedRemoteLookup;
2867 
2868     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
2869 
2870     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
2871         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
2872         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
2873             "NonblockingReceiver: invalid source sending contract");
2874 
2875         // try-catch all errors/exceptions
2876         // having failed messages does not block messages passing
2877         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
2878             // do nothing
2879         } catch {
2880             // error / exception
2881             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
2882             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
2883         }
2884     }
2885 
2886     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
2887         // only internal transaction
2888         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
2889 
2890         // handle incoming message
2891         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
2892     }
2893 
2894     // abstract function
2895     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
2896 
2897     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
2898         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
2899     }
2900 
2901     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
2902         // assert there is message to retry
2903         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
2904         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
2905         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
2906         // clear the stored message
2907         failedMsg.payloadLength = 0;
2908         failedMsg.payloadHash = bytes32(0);
2909         // execute the message. revert if it fails again
2910         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
2911     }
2912 
2913     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
2914         trustedRemoteLookup[_chainId] = _trustedRemote;
2915     }
2916 }
2917 
2918 // File: contracts/GhostlyGhosts.sol
2919 
2920 
2921 
2922 pragma solidity ^0.8.7;
2923 
2924 
2925 /*
2926  *      _      ______     _____                        _           
2927  *     | |    |___  /    |  __ \                      (_)          
2928  *     | |       / /     | |  | | ___  _ __ ___   __ _ _ _ __  ___ 
2929  *     | |      / /      | |  | |/ _ \| '_ ` _ \ / _` | | '_ \/ __|
2930  *     | |____ / /__     | |__| | (_) | | | | | | (_| | | | | \__ \
2931  *     |______/_____|    |_____/ \___/|_| |_| |_|\__,_|_|_| |_|___/
2932  *                                                                 
2933  *                                                                 
2934  */
2935 
2936 contract lzCore is Ownable, ERC721Enumerable, NonblockingReceiver {
2937     using SafeCast for int256;
2938     using SafeMath for uint256;
2939 
2940     AggregatorInterface internal ethUSDAPI;
2941 
2942     /*
2943         Ethereum ,
2944         Binance Chain ,
2945         Avalanche ,        
2946         Arbitrum ,
2947         Optimism ,        
2948         Fantom ,
2949         Polygon ,
2950         Harmony ,
2951      */
2952     string public chainName = "Ethereum";
2953     bool public paused = true;
2954     string public baseURI;
2955     int256 private fiveLetter= 5000000000000000000 * 10 **18;
2956     int256 private fourLetter= 30000000000000000000 * 10 **18;
2957     int256 private threeLetter= 100000000000000000000 * 10 **18;
2958     uint256 private tolerance = 98;
2959     uint gasForDestinationLzReceive = 350000;
2960     uint256 count = 0;
2961     struct domainLogs{
2962         uint256 time;
2963         uint256 nftID;
2964     }
2965     mapping(string => domainLogs) public domainsData;
2966 
2967     struct domainInfos{
2968         string name;
2969     }
2970     mapping(uint256 => domainInfos) public domainInfo;
2971     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("Layer Zero Name Service", "LZNM") { 
2972         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
2973         baseURI = baseURI_;
2974         ethUSDAPI = AggregatorInterface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
2975     }
2976     receive() external payable {
2977         /* 
2978             thanks <3
2979         */
2980     }
2981     function ethUSD() public view returns (int256) {
2982         return ethUSDAPI.latestAnswer()*10**10;
2983     }
2984     function burnExpiredDomain(string memory domainName) public onlyOwner{
2985         require(domainsData[domainName].time < block.timestamp, "Domain is not expired. Error #66");
2986         if(_exists(domainsData[domainName].nftID)){
2987             _burn(domainsData[domainName].nftID);
2988         }        
2989         delete domainInfo[domainsData[domainName].nftID].name;
2990         domainsData[domainName].time = 0;
2991         domainsData[domainName].nftID = 0;
2992     }
2993     function otherChainRenew(string memory domainName , uint256 newTime) public onlyOwner{
2994         domainsData[domainName].time = newTime;
2995     }
2996     function register(string memory domainName , uint256 year) public payable{
2997         require(!paused , "Register now not avaliable. Try again later. Error #1");
2998         require(year >= 1 , "Invalid year value. Error #30");
2999         require(bytes(domainName).length >= 3, "Name is too short. Names must be at least 3 characters long. Error #2");
3000         require(checkDomainAvaliable(domainName) == true , "Domain unavaliable (Has been registered). Error #41");
3001         uint256 price = domainPrice(domainName) * year;
3002         require(msg.value >= (price / 100) * tolerance , "Check register price. Error #3");
3003 
3004         domainsData[domainName].time = block.timestamp + year * 31557600;
3005         domainsData[domainName].nftID = count + 1;
3006 
3007         //set domain names
3008         domainInfo[count + 1].name = domainName;
3009         _safeMint(msg.sender, count + 1);
3010         count += 1;
3011 
3012     }
3013     function renew(string memory domainName , uint256 year) public payable{
3014         require(bytes(domainName).length >= 3, "Name is too short. Names must be at least 3 characters long. Error #45");
3015         require(msg.sender == ownerOf(domainsData[domainName].nftID) , "Access denied. Error #35");
3016         uint256 price = domainPrice(domainName) * year;
3017         require(msg.value >= (price / 100) * tolerance , "Check register price. Error #32");
3018         domainsData[domainName].time += year * 31557600;
3019 
3020     }    
3021     function domainPrice(string memory domainName) public view returns(uint256){
3022         uint256 lenCount = bytes(domainName).length;
3023         if (lenCount <= 3){
3024             return (threeLetter / ethUSD()).toUint256();
3025         }
3026         else if(lenCount == 4){
3027             return (fourLetter / ethUSD()).toUint256();
3028         }
3029         else if(lenCount >= 5){
3030             return (fiveLetter / ethUSD()).toUint256();
3031         }
3032     }
3033     function checkDomainAvaliable(string memory domainName) public view returns(bool){
3034         if( domainsData[domainName].time == 0 ){
3035             return true;
3036         }
3037         else{
3038             return false;
3039         }
3040     }
3041     function estimateFeesView(uint16 _chainId, uint tokenId) public view returns (uint) {
3042         bytes memory payload = abi.encode(msg.sender , tokenId , domainsData[domainInfo[tokenId].name].time , domainInfo[tokenId].name);
3043 
3044         uint16 version = 1;
3045         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
3046 
3047         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
3048         return messageFee;
3049     }
3050     function traverseChains(uint16 _chainId, uint tokenId) public payable {
3051         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
3052         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
3053 
3054         bytes memory payload = abi.encode(msg.sender , tokenId ,  domainsData[domainInfo[tokenId].name].time , domainInfo[tokenId].name);
3055 
3056         uint16 version = 1;
3057         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
3058 
3059         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
3060         
3061         require(msg.value >= messageFee, "LZ: msg.value not enough to cover messageFee. Send gas for message fees");
3062 
3063         endpoint.send{value: msg.value}(
3064             _chainId,                           
3065             trustedRemoteLookup[_chainId],      
3066             payload,                           
3067             payable(msg.sender),               
3068             address(0x0),                       
3069             adapterParams                      
3070         );
3071         _burn(tokenId);
3072     }
3073     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
3074         // decode
3075         (address toAddr, uint tokenId, uint256 time, string memory domainName) = abi.decode(_payload, (address, uint, uint256, string));
3076         domainsData[domainName].time = time;
3077         domainsData[domainName].nftID = tokenId;
3078         domainInfo[tokenId].name = domainName;
3079         _safeMint(toAddr, tokenId);
3080 
3081     }  
3082     function changePaused() external onlyOwner{
3083         if (paused == true) {
3084             paused = false;
3085         }
3086         else{
3087             paused = true;
3088         }
3089     }
3090     function changePrice(int256 a , int256 b , int256 c) public onlyOwner{
3091         if (a != 0){
3092             threeLetter = a;
3093         }
3094         if ( b != 0){
3095             fourLetter = b;
3096         }
3097         if (c != 0){
3098             fiveLetter = c;
3099         }
3100     }
3101     function setBaseURI(string memory URI) external onlyOwner {
3102         baseURI = URI;
3103     }
3104 
3105     function withdraw() public payable onlyOwner {
3106         (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
3107         require(sent);
3108     }
3109 
3110     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
3111         gasForDestinationLzReceive = newVal;
3112     }
3113 
3114     function changeTolerance(uint256 newTolerance) public onlyOwner{
3115         tolerance = newTolerance;
3116     }
3117 
3118     function getCount() public view returns(uint256){
3119         return count;
3120     }
3121 
3122     function _baseURI() override internal view returns (string memory) {
3123         return baseURI;
3124     }
3125     
3126     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
3127         uint256 ownerTokenCount = balanceOf(_owner);
3128         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3129         for (uint256 i; i < ownerTokenCount; i++) {
3130             tokenIds [i]
3131             = tokenOfOwnerByIndex(_owner, i);
3132         }
3133         return tokenIds;
3134     }
3135 }