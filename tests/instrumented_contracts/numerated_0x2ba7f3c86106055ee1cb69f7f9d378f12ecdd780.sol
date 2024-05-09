1 // File: @openzeppelin/contracts/utils/Counters.sol
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
47 // File: @openzeppelin/contracts/utils/Strings.sol
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
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/Address.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Collection of functions related to the address type
153  */
154 library Address {
155     /**
156      * @dev Returns true if `account` is a contract.
157      *
158      * [IMPORTANT]
159      * ====
160      * It is unsafe to assume that an address for which this function returns
161      * false is an externally-owned account (EOA) and not a contract.
162      *
163      * Among others, `isContract` will return false for the following
164      * types of addresses:
165      *
166      *  - an externally-owned account
167      *  - a contract in construction
168      *  - an address where a contract will be created
169      *  - an address where a contract lived, but was destroyed
170      * ====
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies on extcodesize, which returns 0 for contracts in
174         // construction, since the code is only stored at the end of the
175         // constructor execution.
176 
177         uint256 size;
178         assembly {
179             size := extcodesize(account)
180         }
181         return size > 0;
182     }
183 
184     /**
185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
186      * `recipient`, forwarding all available gas and reverting on errors.
187      *
188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
190      * imposed by `transfer`, making them unable to receive funds via
191      * `transfer`. {sendValue} removes this limitation.
192      *
193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
194      *
195      * IMPORTANT: because control is transferred to `recipient`, care must be
196      * taken to not create reentrancy vulnerabilities. Consider using
197      * {ReentrancyGuard} or the
198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         (bool success, ) = recipient.call{value: amount}("");
204         require(success, "Address: unable to send value, recipient may have reverted");
205     }
206 
207     /**
208      * @dev Performs a Solidity function call using a low level `call`. A
209      * plain `call` is an unsafe replacement for a function call: use this
210      * function instead.
211      *
212      * If `target` reverts with a revert reason, it is bubbled up by this
213      * function (like regular Solidity function calls).
214      *
215      * Returns the raw returned data. To convert to the expected return value,
216      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
217      *
218      * Requirements:
219      *
220      * - `target` must be a contract.
221      * - calling `target` with `data` must not revert.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionCall(target, data, "Address: low-level call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
231      * `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but also transferring `value` wei to `target`.
246      *
247      * Requirements:
248      *
249      * - the calling contract must have an ETH balance of at least `value`.
250      * - the called Solidity function must be `payable`.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
264      * with `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         require(isContract(target), "Address: call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.call{value: value}(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
288         return functionStaticCall(target, data, "Address: low-level static call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal view returns (bytes memory) {
302         require(isContract(target), "Address: static call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(isContract(target), "Address: delegate call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.delegatecall(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
337      * revert reason using the provided one.
338      *
339      * _Available since v4.3._
340      */
341     function verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) internal pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @title ERC721 token receiver interface
373  * @dev Interface for any contract that wants to support safeTransfers
374  * from ERC721 asset contracts.
375  */
376 interface IERC721Receiver {
377     /**
378      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
379      * by `operator` from `from`, this function is called.
380      *
381      * It must return its Solidity selector to confirm the token transfer.
382      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
383      *
384      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
385      */
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Interface of the ERC165 standard, as defined in the
403  * https://eips.ethereum.org/EIPS/eip-165[EIP].
404  *
405  * Implementers can declare support of contract interfaces, which can then be
406  * queried by others ({ERC165Checker}).
407  *
408  * For an implementation, see {ERC165}.
409  */
410 interface IERC165 {
411     /**
412      * @dev Returns true if this contract implements the interface defined by
413      * `interfaceId`. See the corresponding
414      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
415      * to learn more about how these ids are created.
416      *
417      * This function call must use less than 30 000 gas.
418      */
419     function supportsInterface(bytes4 interfaceId) external view returns (bool);
420 }
421 
422 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 
430 /**
431  * @dev Implementation of the {IERC165} interface.
432  *
433  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
434  * for the additional interface id that will be supported. For example:
435  *
436  * ```solidity
437  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
439  * }
440  * ```
441  *
442  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
443  */
444 abstract contract ERC165 is IERC165 {
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         return interfaceId == type(IERC165).interfaceId;
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Required interface of an ERC721 compliant contract.
463  */
464 interface IERC721 is IERC165 {
465     /**
466      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
472      */
473     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
477      */
478     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
479 
480     /**
481      * @dev Returns the number of tokens in ``owner``'s account.
482      */
483     function balanceOf(address owner) external view returns (uint256 balance);
484 
485     /**
486      * @dev Returns the owner of the `tokenId` token.
487      *
488      * Requirements:
489      *
490      * - `tokenId` must exist.
491      */
492     function ownerOf(uint256 tokenId) external view returns (address owner);
493 
494     /**
495      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
496      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must exist and be owned by `from`.
503      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
504      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
505      *
506      * Emits a {Transfer} event.
507      */
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     /**
515      * @dev Transfers `tokenId` token from `from` to `to`.
516      *
517      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must be owned by `from`.
524      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
525      *
526      * Emits a {Transfer} event.
527      */
528     function transferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) external;
533 
534     /**
535      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
536      * The approval is cleared when the token is transferred.
537      *
538      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
539      *
540      * Requirements:
541      *
542      * - The caller must own the token or be an approved operator.
543      * - `tokenId` must exist.
544      *
545      * Emits an {Approval} event.
546      */
547     function approve(address to, uint256 tokenId) external;
548 
549     /**
550      * @dev Returns the account approved for `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function getApproved(uint256 tokenId) external view returns (address operator);
557 
558     /**
559      * @dev Approve or remove `operator` as an operator for the caller.
560      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
561      *
562      * Requirements:
563      *
564      * - The `operator` cannot be the caller.
565      *
566      * Emits an {ApprovalForAll} event.
567      */
568     function setApprovalForAll(address operator, bool _approved) external;
569 
570     /**
571      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
572      *
573      * See {setApprovalForAll}
574      */
575     function isApprovedForAll(address owner, address operator) external view returns (bool);
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId,
594         bytes calldata data
595     ) external;
596 }
597 
598 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
608  * @dev See https://eips.ethereum.org/EIPS/eip-721
609  */
610 interface IERC721Metadata is IERC721 {
611     /**
612      * @dev Returns the token collection name.
613      */
614     function name() external view returns (string memory);
615 
616     /**
617      * @dev Returns the token collection symbol.
618      */
619     function symbol() external view returns (string memory);
620 
621     /**
622      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
623      */
624     function tokenURI(uint256 tokenId) external view returns (string memory);
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 
636 
637 
638 
639 
640 
641 /**
642  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
643  * the Metadata extension, but not including the Enumerable extension, which is available separately as
644  * {ERC721Enumerable}.
645  */
646 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
647     using Address for address;
648     using Strings for uint256;
649 
650     // Token name
651     string private _name;
652 
653     // Token symbol
654     string private _symbol;
655 
656     // Mapping from token ID to owner address
657     mapping(uint256 => address) private _owners;
658 
659     // Mapping owner address to token count
660     mapping(address => uint256) private _balances;
661 
662     // Mapping from token ID to approved address
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     /**
669      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
670      */
671     constructor(string memory name_, string memory symbol_) {
672         _name = name_;
673         _symbol = symbol_;
674     }
675 
676     /**
677      * @dev See {IERC165-supportsInterface}.
678      */
679     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
680         return
681             interfaceId == type(IERC721).interfaceId ||
682             interfaceId == type(IERC721Metadata).interfaceId ||
683             super.supportsInterface(interfaceId);
684     }
685 
686     /**
687      * @dev See {IERC721-balanceOf}.
688      */
689     function balanceOf(address owner) public view virtual override returns (uint256) {
690         require(owner != address(0), "ERC721: balance query for the zero address");
691         return _balances[owner];
692     }
693 
694     /**
695      * @dev See {IERC721-ownerOf}.
696      */
697     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
698         address owner = _owners[tokenId];
699         require(owner != address(0), "ERC721: owner query for nonexistent token");
700         return owner;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
721         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
722 
723         string memory baseURI = _baseURI();
724         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
725     }
726 
727     /**
728      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
729      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
730      * by default, can be overriden in child contracts.
731      */
732     function _baseURI() internal view virtual returns (string memory) {
733         return "";
734     }
735 
736     /**
737      * @dev See {IERC721-approve}.
738      */
739     function approve(address to, uint256 tokenId) public virtual override {
740         address owner = ERC721.ownerOf(tokenId);
741         require(to != owner, "ERC721: approval to current owner");
742 
743         require(
744             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
745             "ERC721: approve caller is not owner nor approved for all"
746         );
747 
748         _approve(to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-getApproved}.
753      */
754     function getApproved(uint256 tokenId) public view virtual override returns (address) {
755         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
756 
757         return _tokenApprovals[tokenId];
758     }
759 
760     /**
761      * @dev See {IERC721-setApprovalForAll}.
762      */
763     function setApprovalForAll(address operator, bool approved) public virtual override {
764         _setApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC721-isApprovedForAll}.
769      */
770     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[owner][operator];
772     }
773 
774     /**
775      * @dev See {IERC721-transferFrom}.
776      */
777     function transferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         //solhint-disable-next-line max-line-length
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784 
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809         _safeTransfer(from, to, tokenId, _data);
810     }
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
814      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
815      *
816      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
817      *
818      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
819      * implement alternative mechanisms to perform token transfer, such as signature-based.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must exist and be owned by `from`.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeTransfer(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _transfer(from, to, tokenId);
837         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted (`_mint`),
846      * and stop existing when they are burned (`_burn`).
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return _owners[tokenId] != address(0);
850     }
851 
852     /**
853      * @dev Returns whether `spender` is allowed to manage `tokenId`.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
860         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
861         address owner = ERC721.ownerOf(tokenId);
862         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
863     }
864 
865     /**
866      * @dev Safely mints `tokenId` and transfers it to `to`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must not exist.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeMint(address to, uint256 tokenId) internal virtual {
876         _safeMint(to, tokenId, "");
877     }
878 
879     /**
880      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
881      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
882      */
883     function _safeMint(
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _mint(to, tokenId);
889         require(
890             _checkOnERC721Received(address(0), to, tokenId, _data),
891             "ERC721: transfer to non ERC721Receiver implementer"
892         );
893     }
894 
895     /**
896      * @dev Mints `tokenId` and transfers it to `to`.
897      *
898      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - `to` cannot be the zero address.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _mint(address to, uint256 tokenId) internal virtual {
908         require(to != address(0), "ERC721: mint to the zero address");
909         require(!_exists(tokenId), "ERC721: token already minted");
910 
911         _beforeTokenTransfer(address(0), to, tokenId);
912 
913         _balances[to] += 1;
914         _owners[tokenId] = to;
915 
916         emit Transfer(address(0), to, tokenId);
917     }
918 
919     /**
920      * @dev Destroys `tokenId`.
921      * The approval is cleared when the token is burned.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _burn(uint256 tokenId) internal virtual {
930         address owner = ERC721.ownerOf(tokenId);
931 
932         _beforeTokenTransfer(owner, address(0), tokenId);
933 
934         // Clear approvals
935         _approve(address(0), tokenId);
936 
937         _balances[owner] -= 1;
938         delete _owners[tokenId];
939 
940         emit Transfer(owner, address(0), tokenId);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _transfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {
959         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966 
967         _balances[from] -= 1;
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev Approve `to` to operate on `tokenId`
976      *
977      * Emits a {Approval} event.
978      */
979     function _approve(address to, uint256 tokenId) internal virtual {
980         _tokenApprovals[tokenId] = to;
981         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
982     }
983 
984     /**
985      * @dev Approve `operator` to operate on all of `owner` tokens
986      *
987      * Emits a {ApprovalForAll} event.
988      */
989     function _setApprovalForAll(
990         address owner,
991         address operator,
992         bool approved
993     ) internal virtual {
994         require(owner != operator, "ERC721: approve to caller");
995         _operatorApprovals[owner][operator] = approved;
996         emit ApprovalForAll(owner, operator, approved);
997     }
998 
999     /**
1000      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1001      * The call is not executed if the target address is not a contract.
1002      *
1003      * @param from address representing the previous owner of the given token ID
1004      * @param to target address that will receive the tokens
1005      * @param tokenId uint256 ID of the token to be transferred
1006      * @param _data bytes optional data to send along with the call
1007      * @return bool whether the call correctly returned the expected magic value
1008      */
1009     function _checkOnERC721Received(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) private returns (bool) {
1015         if (to.isContract()) {
1016             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1017                 return retval == IERC721Receiver.onERC721Received.selector;
1018             } catch (bytes memory reason) {
1019                 if (reason.length == 0) {
1020                     revert("ERC721: transfer to non ERC721Receiver implementer");
1021                 } else {
1022                     assembly {
1023                         revert(add(32, reason), mload(reason))
1024                     }
1025                 }
1026             }
1027         } else {
1028             return true;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Hook that is called before any token transfer. This includes minting
1034      * and burning.
1035      *
1036      * Calling conditions:
1037      *
1038      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1039      * transferred to `to`.
1040      * - When `from` is zero, `tokenId` will be minted for `to`.
1041      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 }
1052 
1053 // File: contracts/BB.sol
1054 
1055 
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 
1060 
1061 
1062 interface ILUT {
1063 	function updateReward(address from, address to) external;
1064     function spend(address user, uint256 amount) external;
1065 }
1066 
1067 contract BitBandits is ERC721{
1068     using Strings for uint256;
1069 
1070 
1071     using Counters for Counters.Counter;
1072 
1073     Counters.Counter private _tokenSupply;
1074     Counters.Counter private _testaSupply;
1075 
1076     string baseURI;
1077     string public baseExtension = ".json";
1078     uint256 public publicSaleCost = 0.05 ether;
1079     uint256 public preSale2Cost = 0.04 ether;
1080     uint256 public preSale1Cost = 0.03 ether;
1081 
1082     address public owner = msg.sender;
1083 
1084     
1085     uint256 public maxSupply = 3333; 
1086     uint256 public testaMaxSupply = 15; // testas start after maxSupply
1087 
1088     uint256 public TESTA_PRICE = 300 ether;
1089     // Mapping owner address to testa
1090     mapping(address => uint256) public testa_balances;
1091 
1092 
1093     bool public publicSaleActive = false;
1094 
1095     uint256 public preSale1StartSupply;
1096     uint256 public preSale1Supply = 500;
1097     bool public preSale1Active = false;
1098 
1099     uint256 public preSale2StartSupply;
1100     uint256 public preSale2Supply = 1000;
1101     bool public preSale2Active = false;
1102 
1103     ILUT public yieldToken;
1104 
1105     bool public revealed = false;
1106     string public notRevealedUri;
1107     bool public tokenLinked = false;
1108     //
1109 
1110     address public owner1 = 0xf03B838b42B6313Fa6abdF5c68D7ba672C683A50;
1111     address public owner2 = 0x5384e2110A466F7E611efd37E82FEeE77Dd7e3f5;
1112     address public owner3 = 0x75D48BC691a6c102966FED66B0e3D676dBfC6E90;
1113 
1114 
1115     constructor(
1116         string memory _name,
1117         string memory _symbol,
1118         string memory _initBaseURI,
1119         string memory _initNotRevealedUri
1120 
1121     ) ERC721(_name, _symbol) {
1122         setBaseURI(_initBaseURI);
1123         setNotRevealedURI(_initNotRevealedUri);
1124 
1125     }
1126 
1127 
1128 
1129     ////////////////////
1130     //  TOKEN BASED   //
1131     ////////////////////
1132 
1133     // called on transfer & on mint
1134     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1135         super._beforeTokenTransfer(from, to, tokenId);
1136 
1137         if (tokenLinked == true){
1138             yieldToken.updateReward(from, to);
1139         }
1140         
1141 
1142         if (tokenId > maxSupply && from != address(0) && to != address(0)){
1143             testa_balances[from] -= 1;
1144             testa_balances[to] += 1;
1145         }
1146 
1147     }
1148 
1149     function setLUT(address LUTAddress) external onlyOwner {
1150         yieldToken = ILUT(LUTAddress);
1151         tokenLinked = true;
1152     }
1153 
1154 
1155 
1156 
1157     ////////////////////
1158     //  NFT BASED   //
1159     ////////////////////
1160 
1161 
1162 
1163     function mintGift(address reciever, uint256 _howMany) external payable onlyOwner {
1164         uint256 fullMintAmount = _tokenSupply.current() + _howMany; 
1165         require(fullMintAmount <= maxSupply, "Sold out!");
1166         
1167         for (uint256 i = 0; i < _howMany; i++){
1168             uint256 mintIndex = _tokenSupply.current() + 1; // Start IDs at 1
1169             // Mint.
1170             _tokenSupply.increment();
1171             _safeMint(reciever, mintIndex);
1172         }
1173     }
1174 
1175 
1176     function mintTestaGift() external payable onlyOwner {
1177         uint256 mintIndexTesta = _testaSupply.current() + 1; // Start IDs at 1
1178         require(mintIndexTesta <= testaMaxSupply, "No more Testa's available!");
1179         // Mint.
1180         _testaSupply.increment();
1181         testa_balances[msg.sender] += 1;
1182         _safeMint(msg.sender, maxSupply + mintIndexTesta);
1183     }
1184 
1185 
1186 
1187     ////////////////////
1188     //  PUBLIC SALE   //
1189     ////////////////////
1190 
1191     function mintPubSale(uint256 _howMany) public payable {
1192         require(publicSaleActive, "Public Sale Is Closed");
1193 
1194         uint256 fullMintAmount = _tokenSupply.current() + _howMany; 
1195         require(fullMintAmount <= maxSupply, "Sold out!");
1196 
1197         uint256 mintPrice = publicSaleCost;
1198         require(msg.value >= mintPrice * _howMany, "Not enough ETH to buy!");
1199 
1200 
1201         for (uint256 i = 0; i < _howMany; i++){
1202             uint256 mintIndex = _tokenSupply.current() + 1; // Start IDs at 1
1203             // Mint.
1204             _tokenSupply.increment();
1205             _safeMint(msg.sender, mintIndex);
1206         }
1207     }
1208 
1209     ////////////////////
1210     //  PRE SALES   //
1211     ////////////////////
1212 
1213     function mintPreSale1() public payable {
1214         require(preSale1Active, "Pre Sale Is Closed");
1215 
1216         uint256 mintIndex = _tokenSupply.current() + 1; 
1217        
1218         require(mintIndex <= preSale1StartSupply + preSale1Supply, "Sold out!");
1219         require(mintIndex <= maxSupply, "Sold out!");
1220 
1221         uint256 mintPrice = preSale1Cost;
1222         require(msg.value >= mintPrice, "Not enough ETH to buy!");
1223 
1224         // Mint.
1225         _tokenSupply.increment();
1226         _safeMint(msg.sender, mintIndex);
1227     }
1228 
1229     function mintPreSale2() public payable {
1230         require(preSale2Active, "Pre Sale Is Closed");
1231 
1232         uint256 mintIndex = _tokenSupply.current() + 1; 
1233        
1234         require(mintIndex <= preSale2StartSupply + preSale2Supply, "Sold out!");
1235         require(mintIndex <= maxSupply, "Sold out!");
1236 
1237         uint256 mintPrice = preSale2Cost;
1238         require(msg.value >= mintPrice, "Not enough ETH to buy!");
1239 
1240         // Mint.
1241         _tokenSupply.increment();
1242         _safeMint(msg.sender, mintIndex);
1243     }
1244 
1245 
1246 
1247 
1248     ////////////////////
1249     //  TESTA     //
1250     ////////////////////
1251 
1252     function mintTesta() public payable {
1253         uint256 mintIndexTesta = _testaSupply.current() + 1; // Start IDs at 1
1254         require(mintIndexTesta <= testaMaxSupply, "No more Testa's available!");
1255         yieldToken.spend(msg.sender, TESTA_PRICE);
1256         // Mint.
1257         _testaSupply.increment();
1258         testa_balances[msg.sender] += 1;
1259         _safeMint(msg.sender, maxSupply + mintIndexTesta);
1260     }
1261 
1262 
1263 	function testaBalanceOf(address _owner) external view returns(uint256){
1264         require(_owner != address(0), "ERC721: balance query for the zero address");
1265         return testa_balances[_owner];
1266     }
1267 
1268 
1269     function setTestaPrice(uint256 _newCost) public onlyOwner {
1270         TESTA_PRICE = _newCost;
1271     }
1272 
1273         function setTestaSupply(uint256 _amount) public onlyOwner {
1274         testaMaxSupply = _amount;
1275     }
1276     //only owner
1277 
1278     function reveal() public onlyOwner {
1279       revealed = true;
1280   }
1281 
1282     function setPublicSaleCost(uint256 _newCost) public onlyOwner {
1283         publicSaleCost = _newCost;
1284     }
1285     
1286     function setPreSale1Cost(uint256 _newCost) public onlyOwner {
1287         preSale1Cost = _newCost;
1288     }
1289     function setPreSale2Cost(uint256 _newCost) public onlyOwner {
1290         preSale2Cost = _newCost;
1291     }
1292 
1293    function setPreSale1Amount(uint256 _newAmount) public onlyOwner {
1294         preSale1Supply = _newAmount;
1295     }
1296    function setPreSale2Amount(uint256 _newAmount) public onlyOwner {
1297         preSale2Supply = _newAmount;
1298     }
1299 
1300 
1301 
1302     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1303         baseURI = _newBaseURI;
1304     }
1305 
1306     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1307     notRevealedUri = _notRevealedURI;
1308   }
1309 
1310     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1311         baseExtension = _newBaseExtension;
1312     }
1313 
1314     function setPublicSaleState(bool _state) public onlyOwner {
1315         publicSaleActive = _state;
1316     }
1317     function setPreSale1State(bool _state) public onlyOwner {
1318         preSale1StartSupply = _tokenSupply.current();
1319         preSale1Active = _state;
1320     }
1321     function setPreSale2State(bool _state) public onlyOwner {
1322         preSale2StartSupply = _tokenSupply.current();
1323         preSale2Active = _state;
1324     }
1325 
1326     // Owner can withdraw ETH from here
1327     function withdrawETH() external onlyOwner {
1328         uint256 balance = address(this).balance;
1329 
1330         uint256 _splitTo3 = (balance * 0.333 ether) / 1 ether;
1331 
1332         payable(owner1).transfer(_splitTo3);
1333         payable(owner2).transfer(_splitTo3);
1334         payable(owner3).transfer(_splitTo3);
1335 
1336     }
1337 
1338      ///////////////////
1339     // Query Method  //
1340     ///////////////////
1341 
1342 
1343     function remainingSupply() public view returns (uint256) {
1344         return maxSupply - _tokenSupply.current();
1345     }
1346 
1347 
1348     function tokenSupply() public view returns (uint256) {
1349         return _tokenSupply.current();
1350     }
1351 
1352     function testaTokenSupply() public view returns (uint256) {
1353         return _testaSupply.current();
1354     }
1355 
1356     function _baseURI() internal view override returns (string memory) {
1357         return baseURI;
1358     }
1359 
1360 
1361      function tokenURI(uint256 tokenId)
1362     public
1363     view
1364     virtual
1365     override
1366     returns (string memory)
1367   {
1368     require(
1369       _exists(tokenId),
1370       "ERC721Metadata: URI query for nonexistent token"
1371     );
1372     
1373     if(revealed == false) {
1374         return notRevealedUri;
1375     }
1376 
1377     string memory currentBaseURI = _baseURI();
1378     return bytes(currentBaseURI).length > 0
1379         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1380         : "";
1381   }
1382 
1383     ///////////////////
1384     //  Helper Code  //
1385     ///////////////////
1386 
1387 
1388 
1389     modifier onlyOwner() {
1390         require(owner == msg.sender, "Ownable: caller is not the owner");
1391         _;
1392     }
1393 }