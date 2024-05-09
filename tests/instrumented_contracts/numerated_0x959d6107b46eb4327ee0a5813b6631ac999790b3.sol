1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.3.2 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 
47 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
48 pragma solidity ^0.8.0;
49 /**
50  * @dev Interface of the ERC165 standard, as defined in the
51  * https://eips.ethereum.org/EIPS/eip-165[EIP].
52  *
53  * Implementers can declare support of contract interfaces, which can then be
54  * queried by others ({ERC165Checker}).
55  *
56  * For an implementation, see {ERC165}.
57  */
58 interface IERC165 {
59     /**
60      * @dev Returns true if this contract implements the interface defined by
61      * `interfaceId`. See the corresponding
62      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
63      * to learn more about how these ids are created.
64      *
65      * This function call must use less than 30 000 gas.
66      */
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
71 pragma solidity ^0.8.0;
72 /**
73  * @dev Required interface of an ERC721 compliant contract.
74  */
75 interface IERC721 is IERC165 {
76     /**
77      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
83      */
84     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
85 
86     /**
87      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
88      */
89     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
90 
91     /**
92      * @dev Returns the number of tokens in ``owner``'s account.
93      */
94     function balanceOf(address owner) external view returns (uint256 balance);
95 
96     /**
97      * @dev Returns the owner of the `tokenId` token.
98      *
99      * Requirements:
100      *
101      * - `tokenId` must exist.
102      */
103     function ownerOf(uint256 tokenId) external view returns (address owner);
104 
105     /**
106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must exist and be owned by `from`.
114      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
116      *
117      * Emits a {Transfer} event.
118      */
119     function safeTransferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Transfers `tokenId` token from `from` to `to`.
127      *
128      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
147      * The approval is cleared when the token is transferred.
148      *
149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
150      *
151      * Requirements:
152      *
153      * - The caller must own the token or be an approved operator.
154      * - `tokenId` must exist.
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address to, uint256 tokenId) external;
159 
160     /**
161      * @dev Returns the account approved for `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function getApproved(uint256 tokenId) external view returns (address operator);
168 
169     /**
170      * @dev Approve or remove `operator` as an operator for the caller.
171      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
172      *
173      * Requirements:
174      *
175      * - The `operator` cannot be the caller.
176      *
177      * Emits an {ApprovalForAll} event.
178      */
179     function setApprovalForAll(address operator, bool _approved) external;
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator) external view returns (bool);
187 
188     /**
189      * @dev Safely transfers `tokenId` token from `from` to `to`.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must exist and be owned by `from`.
196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198      *
199      * Emits a {Transfer} event.
200      */
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId,
205         bytes calldata data
206     ) external;
207 }
208 
209 
210 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
211 pragma solidity ^0.8.0;
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Enumerable is IERC721 {
217     /**
218      * @dev Returns the total amount of tokens stored by the contract.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
224      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
225      */
226     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
227 
228     /**
229      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
230      * Use along with {totalSupply} to enumerate all tokens.
231      */
232     function tokenByIndex(uint256 index) external view returns (uint256);
233 }
234 
235 
236 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
237 pragma solidity ^0.8.0;
238 /**
239  * @dev Implementation of the {IERC165} interface.
240  *
241  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
242  * for the additional interface id that will be supported. For example:
243  *
244  * ```solidity
245  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
246  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
247  * }
248  * ```
249  *
250  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
251  */
252 abstract contract ERC165 is IERC165 {
253     /**
254      * @dev See {IERC165-supportsInterface}.
255      */
256     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
257         return interfaceId == type(IERC165).interfaceId;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Strings.sol
262 
263 
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev String operations.
269  */
270 library Strings {
271     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
272 
273     /**
274      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
275      */
276     function toString(uint256 value) internal pure returns (string memory) {
277         // Inspired by OraclizeAPI's implementation - MIT licence
278         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
279 
280         if (value == 0) {
281             return "0";
282         }
283         uint256 temp = value;
284         uint256 digits;
285         while (temp != 0) {
286             digits++;
287             temp /= 10;
288         }
289         bytes memory buffer = new bytes(digits);
290         while (value != 0) {
291             digits -= 1;
292             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
293             value /= 10;
294         }
295         return string(buffer);
296     }
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
300      */
301     function toHexString(uint256 value) internal pure returns (string memory) {
302         if (value == 0) {
303             return "0x00";
304         }
305         uint256 temp = value;
306         uint256 length = 0;
307         while (temp != 0) {
308             length++;
309             temp >>= 8;
310         }
311         return toHexString(value, length);
312     }
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
316      */
317     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
318         bytes memory buffer = new bytes(2 * length + 2);
319         buffer[0] = "0";
320         buffer[1] = "x";
321         for (uint256 i = 2 * length + 1; i > 1; --i) {
322             buffer[i] = _HEX_SYMBOLS[value & 0xf];
323             value >>= 4;
324         }
325         require(value == 0, "Strings: hex length insufficient");
326         return string(buffer);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies on extcodesize, which returns 0 for contracts in
359         // construction, since the code is only stored at the end of the
360         // constructor execution.
361 
362         uint256 size;
363         assembly {
364             size := extcodesize(account)
365         }
366         return size > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         require(isContract(target), "Address: call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.call{value: value}(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
473         return functionStaticCall(target, data, "Address: low-level static call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(isContract(target), "Address: delegate call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
522      * revert reason using the provided one.
523      *
524      * _Available since v4.3._
525      */
526     function verifyCallResult(
527         bool success,
528         bytes memory returndata,
529         string memory errorMessage
530     ) internal pure returns (bytes memory) {
531         if (success) {
532             return returndata;
533         } else {
534             // Look for revert reason and bubble it up if present
535             if (returndata.length > 0) {
536                 // The easiest way to bubble the revert reason is using memory via assembly
537 
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @title ERC721 token receiver interface
585  * @dev Interface for any contract that wants to support safeTransfers
586  * from ERC721 asset contracts.
587  */
588 interface IERC721Receiver {
589     /**
590      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
591      * by `operator` from `from`, this function is called.
592      *
593      * It must return its Solidity selector to confirm the token transfer.
594      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
595      *
596      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
597      */
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 // File: @openzeppelin/contracts/utils/Context.sol
607 pragma solidity ^0.8.0;
608 /**
609  * @dev Provides information about the current execution context, including the
610  * sender of the transaction and its data. While these are generally available
611  * via msg.sender and msg.data, they should not be accessed in such a direct
612  * manner, since when dealing with meta-transactions the account sending and
613  * paying for execution may not be the actual sender (as far as an application
614  * is concerned).
615  *
616  * This contract is only required for intermediate, library-like contracts.
617  */
618 abstract contract Context {
619     function _msgSender() internal view virtual returns (address) {
620         return msg.sender;
621     }
622 
623     function _msgData() internal view virtual returns (bytes calldata) {
624         return msg.data;
625     }
626 }
627 
628 
629 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
630 pragma solidity ^0.8.0;
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension, but not including the Enumerable extension, which is available separately as
634  * {ERC721Enumerable}.
635  */
636 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Token name
641     string private _name;
642 
643     // Token symbol
644     string private _symbol;
645 
646     // Mapping from token ID to owner address
647     mapping(uint256 => address) private _owners;
648 
649     // Mapping owner address to token count
650     mapping(address => uint256) private _balances;
651 
652     // Mapping from token ID to approved address
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     /**
659      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
660      */
661     constructor(string memory name_, string memory symbol_) {
662         _name = name_;
663         _symbol = symbol_;
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
670         return
671             interfaceId == type(IERC721).interfaceId ||
672             interfaceId == type(IERC721Metadata).interfaceId ||
673             super.supportsInterface(interfaceId);
674     }
675 
676     /**
677      * @dev See {IERC721-balanceOf}.
678      */
679     function balanceOf(address owner) public view virtual override returns (uint256) {
680         require(owner != address(0), "ERC721: balance query for the zero address");
681         return _balances[owner];
682     }
683 
684     /**
685      * @dev See {IERC721-ownerOf}.
686      */
687     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
688         address owner = _owners[tokenId];
689         require(owner != address(0), "ERC721: owner query for nonexistent token");
690         return owner;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-name}.
695      */
696     function name() public view virtual override returns (string memory) {
697         return _name;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-symbol}.
702      */
703     function symbol() public view virtual override returns (string memory) {
704         return _symbol;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-tokenURI}.
709      */
710     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
711         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
712 
713         string memory baseURI = _baseURI();
714         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
715     }
716 
717     /**
718      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
719      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
720      * by default, can be overriden in child contracts.
721      */
722     function _baseURI() internal view virtual returns (string memory) {
723         return "";
724     }
725 
726     /**
727      * @dev See {IERC721-approve}.
728      */
729     function approve(address to, uint256 tokenId) public virtual override {
730         address owner = ERC721.ownerOf(tokenId);
731         require(to != owner, "ERC721: approval to current owner");
732 
733         require(
734             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
735             "ERC721: approve caller is not owner nor approved for all"
736         );
737 
738         _approve(to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-getApproved}.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
746 
747         return _tokenApprovals[tokenId];
748     }
749 
750     /**
751      * @dev See {IERC721-setApprovalForAll}.
752      */
753     function setApprovalForAll(address operator, bool approved) public virtual override {
754         require(operator != _msgSender(), "ERC721: approve to caller");
755 
756         _operatorApprovals[_msgSender()][operator] = approved;
757         emit ApprovalForAll(_msgSender(), operator, approved);
758     }
759 
760     /**
761      * @dev See {IERC721-isApprovedForAll}.
762      */
763     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
764         return _operatorApprovals[owner][operator];
765     }
766 
767     /**
768      * @dev See {IERC721-transferFrom}.
769      */
770     function transferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) public virtual override {
775         //solhint-disable-next-line max-line-length
776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
777 
778         _transfer(from, to, tokenId);
779     }
780 
781     /**
782      * @dev See {IERC721-safeTransferFrom}.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId
788     ) public virtual override {
789         safeTransferFrom(from, to, tokenId, "");
790     }
791 
792     /**
793      * @dev See {IERC721-safeTransferFrom}.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) public virtual override {
801         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
802         _safeTransfer(from, to, tokenId, _data);
803     }
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
807      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
808      *
809      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
810      *
811      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
812      * implement alternative mechanisms to perform token transfer, such as signature-based.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must exist and be owned by `from`.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeTransfer(
824         address from,
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _transfer(from, to, tokenId);
830         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
831     }
832 
833     /**
834      * @dev Returns whether `tokenId` exists.
835      *
836      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
837      *
838      * Tokens start existing when they are minted (`_mint`),
839      * and stop existing when they are burned (`_burn`).
840      */
841     function _exists(uint256 tokenId) internal view virtual returns (bool) {
842         return _owners[tokenId] != address(0);
843     }
844 
845     /**
846      * @dev Returns whether `spender` is allowed to manage `tokenId`.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
853         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
854         address owner = ERC721.ownerOf(tokenId);
855         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
856     }
857 
858     /**
859      * @dev Safely mints `tokenId` and transfers it to `to`.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must not exist.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _safeMint(address to, uint256 tokenId) internal virtual {
869         _safeMint(to, tokenId, "");
870     }
871 
872     /**
873      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
874      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
875      */
876     function _safeMint(
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) internal virtual {
881         _mint(to, tokenId);
882         require(
883             _checkOnERC721Received(address(0), to, tokenId, _data),
884             "ERC721: transfer to non ERC721Receiver implementer"
885         );
886     }
887 
888     /**
889      * @dev Mints `tokenId` and transfers it to `to`.
890      *
891      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
892      *
893      * Requirements:
894      *
895      * - `tokenId` must not exist.
896      * - `to` cannot be the zero address.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _mint(address to, uint256 tokenId) internal virtual {
901         require(to != address(0), "ERC721: mint to the zero address");
902         require(!_exists(tokenId), "ERC721: token already minted");
903 
904         _beforeTokenTransfer(address(0), to, tokenId);
905 
906         _balances[to] += 1;
907         _owners[tokenId] = to;
908 
909         emit Transfer(address(0), to, tokenId);
910     }
911 
912     /**
913      * @dev Destroys `tokenId`.
914      * The approval is cleared when the token is burned.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _burn(uint256 tokenId) internal virtual {
923         address owner = ERC721.ownerOf(tokenId);
924 
925         _beforeTokenTransfer(owner, address(0), tokenId);
926 
927         // Clear approvals
928         _approve(address(0), tokenId);
929 
930         _balances[owner] -= 1;
931         delete _owners[tokenId];
932 
933         emit Transfer(owner, address(0), tokenId);
934     }
935 
936     /**
937      * @dev Transfers `tokenId` from `from` to `to`.
938      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
939      *
940      * Requirements:
941      *
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must be owned by `from`.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _transfer(
948         address from,
949         address to,
950         uint256 tokenId
951     ) internal virtual {
952         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
953         require(to != address(0), "ERC721: transfer to the zero address");
954 
955         _beforeTokenTransfer(from, to, tokenId);
956 
957         // Clear approvals from the previous owner
958         _approve(address(0), tokenId);
959 
960         _balances[from] -= 1;
961         _balances[to] += 1;
962         _owners[tokenId] = to;
963 
964         emit Transfer(from, to, tokenId);
965     }
966 
967     /**
968      * @dev Approve `to` to operate on `tokenId`
969      *
970      * Emits a {Approval} event.
971      */
972     function _approve(address to, uint256 tokenId) internal virtual {
973         _tokenApprovals[tokenId] = to;
974         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
975     }
976 
977     /**
978      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
979      * The call is not executed if the target address is not a contract.
980      *
981      * @param from address representing the previous owner of the given token ID
982      * @param to target address that will receive the tokens
983      * @param tokenId uint256 ID of the token to be transferred
984      * @param _data bytes optional data to send along with the call
985      * @return bool whether the call correctly returned the expected magic value
986      */
987     function _checkOnERC721Received(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) private returns (bool) {
993         if (to.isContract()) {
994             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
995                 return retval == IERC721Receiver.onERC721Received.selector;
996             } catch (bytes memory reason) {
997                 if (reason.length == 0) {
998                     revert("ERC721: transfer to non ERC721Receiver implementer");
999                 } else {
1000                     assembly {
1001                         revert(add(32, reason), mload(reason))
1002                     }
1003                 }
1004             }
1005         } else {
1006             return true;
1007         }
1008     }
1009 
1010     /**
1011      * @dev Hook that is called before any token transfer. This includes minting
1012      * and burning.
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` will be minted for `to`.
1019      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1020      * - `from` and `to` are never both zero.
1021      *
1022      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1023      */
1024     function _beforeTokenTransfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) internal virtual {}
1029 }
1030 
1031 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1032 
1033 
1034 
1035 pragma solidity ^0.8.0;
1036 
1037 
1038 
1039 /**
1040  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1041  * enumerability of all the token ids in the contract as well as all token ids owned by each
1042  * account.
1043  */
1044 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1045     // Mapping from owner to list of owned token IDs
1046     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1047 
1048     // Mapping from token ID to index of the owner tokens list
1049     mapping(uint256 => uint256) private _ownedTokensIndex;
1050 
1051     // Array with all token ids, used for enumeration
1052     uint256[] private _allTokens;
1053 
1054     // Mapping from token id to position in the allTokens array
1055     mapping(uint256 => uint256) private _allTokensIndex;
1056 
1057     /**
1058      * @dev See {IERC165-supportsInterface}.
1059      */
1060     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1061         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1066      */
1067     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1069         return _ownedTokens[owner][index];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Enumerable-totalSupply}.
1074      */
1075     function totalSupply() public view virtual override returns (uint256) {
1076         return _allTokens.length;
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Enumerable-tokenByIndex}.
1081      */
1082     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1083         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1084         return _allTokens[index];
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      *
1100      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1101      */
1102     function _beforeTokenTransfer(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) internal virtual override {
1107         super._beforeTokenTransfer(from, to, tokenId);
1108 
1109         if (from == address(0)) {
1110             _addTokenToAllTokensEnumeration(tokenId);
1111         } else if (from != to) {
1112             _removeTokenFromOwnerEnumeration(from, tokenId);
1113         }
1114         if (to == address(0)) {
1115             _removeTokenFromAllTokensEnumeration(tokenId);
1116         } else if (to != from) {
1117             _addTokenToOwnerEnumeration(to, tokenId);
1118         }
1119     }
1120 
1121     /**
1122      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1123      * @param to address representing the new owner of the given token ID
1124      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1125      */
1126     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1127         uint256 length = ERC721.balanceOf(to);
1128         _ownedTokens[to][length] = tokenId;
1129         _ownedTokensIndex[tokenId] = length;
1130     }
1131 
1132     /**
1133      * @dev Private function to add a token to this extension's token tracking data structures.
1134      * @param tokenId uint256 ID of the token to be added to the tokens list
1135      */
1136     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1137         _allTokensIndex[tokenId] = _allTokens.length;
1138         _allTokens.push(tokenId);
1139     }
1140 
1141     /**
1142      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1143      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1144      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1145      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1146      * @param from address representing the previous owner of the given token ID
1147      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1148      */
1149     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1150         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1151         // then delete the last slot (swap and pop).
1152 
1153         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1154         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1155 
1156         // When the token to delete is the last token, the swap operation is unnecessary
1157         if (tokenIndex != lastTokenIndex) {
1158             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1159 
1160             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1161             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1162         }
1163 
1164         // This also deletes the contents at the last position of the array
1165         delete _ownedTokensIndex[tokenId];
1166         delete _ownedTokens[from][lastTokenIndex];
1167     }
1168 
1169     /**
1170      * @dev Private function to remove a token from this extension's token tracking data structures.
1171      * This has O(1) time complexity, but alters the order of the _allTokens array.
1172      * @param tokenId uint256 ID of the token to be removed from the tokens list
1173      */
1174     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1175         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1176         // then delete the last slot (swap and pop).
1177 
1178         uint256 lastTokenIndex = _allTokens.length - 1;
1179         uint256 tokenIndex = _allTokensIndex[tokenId];
1180 
1181         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1182         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1183         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1184         uint256 lastTokenId = _allTokens[lastTokenIndex];
1185 
1186         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1187         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1188 
1189         // This also deletes the contents at the last position of the array
1190         delete _allTokensIndex[tokenId];
1191         _allTokens.pop();
1192     }
1193 }
1194 
1195 
1196 // File: @openzeppelin/contracts/access/Ownable.sol
1197 pragma solidity ^0.8.0;
1198 /**
1199  * @dev Contract module which provides a basic access control mechanism, where
1200  * there is an account (an owner) that can be granted exclusive access to
1201  * specific functions.
1202  *
1203  * By default, the owner account will be the one that deploys the contract. This
1204  * can later be changed with {transferOwnership}.
1205  *
1206  * This module is used through inheritance. It will make available the modifier
1207  * `onlyOwner`, which can be applied to your functions to restrict their use to
1208  * the owner.
1209  */
1210 abstract contract Ownable is Context {
1211     address private _owner;
1212 
1213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1214 
1215     /**
1216      * @dev Initializes the contract setting the deployer as the initial owner.
1217      */
1218     constructor() {
1219         _setOwner(_msgSender());
1220     }
1221 
1222     /**
1223      * @dev Returns the address of the current owner.
1224      */
1225     function owner() public view virtual returns (address) {
1226         return _owner;
1227     }
1228 
1229     /**
1230      * @dev Throws if called by any account other than the owner.
1231      */
1232     modifier onlyOwner() {
1233         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1234         _;
1235     }
1236 
1237     /**
1238      * @dev Leaves the contract without owner. It will not be possible to call
1239      * `onlyOwner` functions anymore. Can only be called by the current owner.
1240      *
1241      * NOTE: Renouncing ownership will leave the contract without an owner,
1242      * thereby removing any functionality that is only available to the owner.
1243      */
1244     function renounceOwnership() public virtual onlyOwner {
1245         _setOwner(address(0));
1246     }
1247 
1248     /**
1249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1250      * Can only be called by the current owner.
1251      */
1252     function transferOwnership(address newOwner) public virtual onlyOwner {
1253         require(newOwner != address(0), "Ownable: new owner is the zero address");
1254         _setOwner(newOwner);
1255     }
1256 
1257     function _setOwner(address newOwner) private {
1258         address oldOwner = _owner;
1259         _owner = newOwner;
1260         emit OwnershipTransferred(oldOwner, newOwner);
1261     }
1262 }
1263 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1264 
1265 
1266 
1267 pragma solidity ^0.8.0;
1268 
1269 
1270 /**
1271  * @dev Interface for the NFT Royalty Standard
1272  */
1273 interface IERC2981 is IERC165 {
1274     /**
1275      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1276      * @param tokenId - the NFT asset queried for royalty information
1277      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1278      * @return receiver - address of who should be sent the royalty payment
1279      * @return royaltyAmount - the royalty payment amount for `salePrice`
1280      */
1281     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1282         external
1283         view
1284         returns (address receiver, uint256 royaltyAmount);
1285 }
1286 
1287 
1288 /**Start of Barely Bears Contact */
1289 
1290 
1291 //██████╗  █████╗ ██████╗ ███████╗██╗  ██╗   ██╗    ██████╗ ███████╗ █████╗ ██████╗ ███████╗
1292 //██╔══██╗██╔══██╗██╔══██╗██╔════╝██║  ╚██╗ ██╔╝    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝
1293 //██████╔╝███████║██████╔╝█████╗  ██║   ╚████╔╝     ██████╔╝█████╗  ███████║██████╔╝███████╗
1294 //██╔══██╗██╔══██║██╔══██╗██╔══╝  ██║    ╚██╔╝      ██╔══██╗██╔══╝  ██╔══██║██╔══██╗╚════██║
1295 //██████╔╝██║  ██║██║  ██║███████╗███████╗██║       ██████╔╝███████╗██║  ██║██║  ██║███████║
1296 //╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝       ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
1297                                                                                           
1298 //BarelyBears is the a generative NFT collection featuring 10,000 hand-painted bear portraits from a live human-bear
1299 
1300 
1301 pragma solidity >=0.7.0 <0.9.0;
1302 
1303 contract BarelyBears10k is ERC721Enumerable, Ownable {
1304   using Strings for uint256;
1305 
1306   string public baseURI;
1307   string public baseExtension = ".json";
1308   string public notRevealedUri;
1309   uint256 public cost = 0.05 ether;
1310   uint256 public maxSupply = 10000;
1311   uint256 public maxWhitelistMintAmount = 4;
1312   uint256 public maxMintAmount = 10;
1313   uint256 public nftPerAddressLimit = 4;
1314   uint256 private _tokenId = 0;
1315   uint16 internal royalty = 1000; // base 10000, 10%
1316   uint16 public constant BASE = 10000;
1317   bool public paused = false;
1318   bool public revealed = false;
1319   bool public onlyWhitelisted = true;
1320   address[] public whitelistedAddresses;
1321   address public constant founderAddress = 0x9286c3d14C235Bf404a335a59F04fF806f6d6944;
1322   address public constant projectAddress = 0x08269c0FA570C4Bc91cF054bFEdECe2A3CC9442b;
1323   address public constant devAddress = 0x739A49E67D46A2f0f60217901CFd6a86E816Cc62;
1324   address public constant artist1Address = 0x4ba4a533D9355BbF0cE56BAF9fe15E2cccc83132;
1325   address public constant artist2Address = 0x82341fB007544721efa2e3E74fA7421888B10489;
1326   mapping(address => uint256) public addressMintedBalance;
1327   
1328   
1329   constructor(
1330     string memory _name,
1331     string memory _symbol,
1332     string memory _initBaseURI,
1333     string memory _initNotRevealedUri
1334   ) ERC721(_name, _symbol) {
1335     setBaseURI(_initBaseURI);
1336     setNotRevealedURI(_initNotRevealedUri);
1337   }
1338 
1339   function _baseURI() internal view virtual override returns (string memory) {
1340     return baseURI;
1341   }
1342 
1343 
1344     struct FreeBearUser {
1345         uint maxMint;       
1346     }
1347 
1348     mapping (address => FreeBearUser ) wlUsers;
1349         address[] public userAccounts;
1350     
1351     
1352     function resetFreeBearUsers (address _address) public {
1353         FreeBearUser storage wlUser = wlUsers[_address];       
1354         wlUser.maxMint = 0;
1355     }
1356     
1357     function getFreeBearUserAccount(address _address) view public returns (uint) {
1358         return (wlUsers[_address].maxMint);
1359     }
1360 
1361   function normalMint(uint256 _mintAmount) public payable {
1362     require(!paused, "the contract is paused");
1363     uint256 supply = totalSupply();
1364     require(_mintAmount > 0, "need to mint at least 1 NFT");
1365     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1366     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1367 
1368     if (msg.sender != owner()) {
1369         require(msg.value >= cost * _mintAmount, "insufficient funds");
1370     }
1371     
1372     for (uint256 i = 1; i <= _mintAmount; i++) {
1373       _safeMint(msg.sender, supply + i);
1374     }
1375   }
1376 
1377   function freeMint() public payable {
1378     require(!paused, "the contract is paused");
1379     uint256 supply = totalSupply();
1380     uint256 cost = 0;
1381     uint256 _mintAmount = getFreeBearUserAccount(msg.sender);
1382     require(_mintAmount > 0, "you are not entitled for a free bear");
1383     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1384     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1385 
1386     if (msg.sender != owner()) {
1387         require(msg.value >= cost * _mintAmount, "insufficient funds");
1388     }
1389     
1390     for (uint256 i = 1; i <= _mintAmount; i++) {
1391         addressMintedBalance[msg.sender]++;
1392       _safeMint(msg.sender, supply + i);
1393     }
1394     resetFreeBearUsers(msg.sender);
1395   }
1396 
1397     function whitelistMint(uint256 _mintAmount) public payable {
1398     require(!paused, "the contract is paused");
1399     uint256 supply = totalSupply();
1400     require(_mintAmount > 0, "need to mint at least 1 NFT");
1401     require(_mintAmount <= maxWhitelistMintAmount, "cannot mint more than 4 NFT on whitelist");
1402     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1403     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1404 
1405     if (msg.sender != owner()) {
1406         if(onlyWhitelisted == true) {
1407             require(isWhitelisted(msg.sender), "user is not whitelisted");
1408             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1409             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1410         }
1411         require(msg.value >= cost * _mintAmount, "insufficient funds");
1412     }
1413     
1414     for (uint256 i = 1; i <= _mintAmount; i++) {
1415         addressMintedBalance[msg.sender]++;
1416       _safeMint(msg.sender, supply + i);
1417     }
1418   }
1419 
1420   
1421   function isWhitelisted(address _user) public view returns (bool) {
1422     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1423       if (whitelistedAddresses[i] == _user) {
1424           return true;
1425       }
1426     }
1427     return false;
1428   }
1429 
1430   function walletOfOwner(address _owner)
1431     public
1432     view
1433     returns (uint256[] memory)
1434   {
1435     uint256 ownerTokenCount = balanceOf(_owner);
1436     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1437     for (uint256 i; i < ownerTokenCount; i++) {
1438       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1439     }
1440     return tokenIds;
1441   }
1442 
1443   function tokenURI(uint256 tokenId)
1444     public
1445     view
1446     virtual
1447     override
1448     returns (string memory)
1449   {
1450     require(
1451       _exists(tokenId),
1452       "ERC721Metadata: URI query for nonexistent token"
1453     );
1454     
1455     if(revealed == false) {
1456         return notRevealedUri;
1457     }
1458 
1459     string memory currentBaseURI = _baseURI();
1460     return bytes(currentBaseURI).length > 0
1461         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1462         : "";
1463   }
1464 
1465   //only owner
1466   function reveal() public onlyOwner {
1467       revealed = true;
1468   }
1469   
1470   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1471     nftPerAddressLimit = _limit;
1472   }
1473   
1474   function setCost(uint256 _newCost) public onlyOwner {
1475     cost = _newCost;
1476   }
1477 
1478   function setMaxWhitelistMintAmount(uint256 _newmaxWhitelistMintAmount) public onlyOwner {
1479     maxWhitelistMintAmount = _newmaxWhitelistMintAmount;
1480   }
1481 
1482     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1483     maxMintAmount = _newmaxMintAmount;
1484   }
1485 
1486 
1487   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1488     baseURI = _newBaseURI;
1489   }
1490 
1491   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1492     baseExtension = _newBaseExtension;
1493   }
1494   
1495   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1496     notRevealedUri = _notRevealedURI;
1497   }
1498 
1499   function pause(bool _state) public onlyOwner {
1500     paused = _state;
1501   }
1502   
1503   function setFreeBearUsers (address _address, uint _maxMint) public onlyOwner {
1504      FreeBearUser storage wlUser = wlUsers[_address];       
1505      wlUser.maxMint = _maxMint;
1506   }
1507   function setOnlyWhitelisted(bool _state) public onlyOwner {
1508     onlyWhitelisted = _state;
1509   }
1510   
1511   function whitelistUsers(address[] calldata _users) public onlyOwner {
1512     delete whitelistedAddresses;
1513     whitelistedAddresses = _users;
1514   }
1515  
1516   function withdrawAll() public onlyOwner {
1517       uint256 balance = address(this).balance;
1518       require(balance > 0, "Insufficent balance");
1519       _widthdraw(projectAddress, ((balance * 20) / 100));
1520       _widthdraw(devAddress, ((balance * 10) / 100));
1521       _widthdraw(artist1Address, ((balance * 10) / 100));
1522       _widthdraw(artist2Address, ((balance * 10) / 100));
1523       _widthdraw(founderAddress, address(this).balance);
1524   }
1525 
1526   function _widthdraw(address _address, uint256 _amount) private {
1527      (bool success, ) = _address.call{ value: _amount }("");
1528      require(success, "Failed to widthdraw Ether");
1529    }
1530 
1531        /// @notice Calculate the royalty payment
1532     /// @param _salePrice the sale price of the token
1533     function royaltyInfo(uint256, uint256 _salePrice)
1534         external
1535         view
1536         returns (address receiver, uint256 royaltyAmount)
1537     {
1538         return (address(this), (_salePrice * royalty) / BASE);
1539     }
1540 
1541     /// @dev set the royalty
1542     /// @param _royalty the royalty in base 10000, 500 = 5%
1543     function setRoyalty(uint16 _royalty) public virtual onlyOwner {
1544         require(_royalty >= 0 && _royalty <= 1000, 'Royalty must be between 0% and 10%.');
1545 
1546         royalty = _royalty;
1547     }
1548 }