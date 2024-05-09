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
47 // File: contracts/RDBCCLive.sol
48 
49 
50 
51 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
52 pragma solidity ^0.8.0;
53 /**
54  * @dev Interface of the ERC165 standard, as defined in the
55  * https://eips.ethereum.org/EIPS/eip-165[EIP].
56  *
57  * Implementers can declare support of contract interfaces, which can then be
58  * queried by others ({ERC165Checker}).
59  *
60  * For an implementation, see {ERC165}.
61  */
62 interface IERC165 {
63     /**
64      * @dev Returns true if this contract implements the interface defined by
65      * `interfaceId`. See the corresponding
66      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
67      * to learn more about how these ids are created.
68      *
69      * This function call must use less than 30 000 gas.
70      */
71     function supportsInterface(bytes4 interfaceId) external view returns (bool);
72 }
73 
74 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
75 pragma solidity ^0.8.0;
76 /**
77  * @dev Required interface of an ERC721 compliant contract.
78  */
79 interface IERC721 is IERC165 {
80     /**
81      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
87      */
88     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
89 
90     /**
91      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
92      */
93     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
94 
95     /**
96      * @dev Returns the number of tokens in ``owner``'s account.
97      */
98     function balanceOf(address owner) external view returns (uint256 balance);
99 
100     /**
101      * @dev Returns the owner of the `tokenId` token.
102      *
103      * Requirements:
104      *
105      * - `tokenId` must exist.
106      */
107     function ownerOf(uint256 tokenId) external view returns (address owner);
108 
109     /**
110      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
111      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must exist and be owned by `from`.
118      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
120      *
121      * Emits a {Transfer} event.
122      */
123     function safeTransferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Transfers `tokenId` token from `from` to `to`.
131      *
132      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address from,
145         address to,
146         uint256 tokenId
147     ) external;
148 
149     /**
150      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
151      * The approval is cleared when the token is transferred.
152      *
153      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
154      *
155      * Requirements:
156      *
157      * - The caller must own the token or be an approved operator.
158      * - `tokenId` must exist.
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address to, uint256 tokenId) external;
163 
164     /**
165      * @dev Returns the account approved for `tokenId` token.
166      *
167      * Requirements:
168      *
169      * - `tokenId` must exist.
170      */
171     function getApproved(uint256 tokenId) external view returns (address operator);
172 
173     /**
174      * @dev Approve or remove `operator` as an operator for the caller.
175      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
176      *
177      * Requirements:
178      *
179      * - The `operator` cannot be the caller.
180      *
181      * Emits an {ApprovalForAll} event.
182      */
183     function setApprovalForAll(address operator, bool _approved) external;
184 
185     /**
186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
187      *
188      * See {setApprovalForAll}
189      */
190     function isApprovedForAll(address owner, address operator) external view returns (bool);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId,
209         bytes calldata data
210     ) external;
211 }
212 
213 
214 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
215 pragma solidity ^0.8.0;
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Enumerable is IERC721 {
221     /**
222      * @dev Returns the total amount of tokens stored by the contract.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
228      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
229      */
230     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
231 
232     /**
233      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
234      * Use along with {totalSupply} to enumerate all tokens.
235      */
236     function tokenByIndex(uint256 index) external view returns (uint256);
237 }
238 
239 
240 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
241 pragma solidity ^0.8.0;
242 /**
243  * @dev Implementation of the {IERC165} interface.
244  *
245  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
246  * for the additional interface id that will be supported. For example:
247  *
248  * ```solidity
249  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
250  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
251  * }
252  * ```
253  *
254  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
255  */
256 abstract contract ERC165 is IERC165 {
257     /**
258      * @dev See {IERC165-supportsInterface}.
259      */
260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
261         return interfaceId == type(IERC165).interfaceId;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/utils/Strings.sol
266 
267 
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
334 // File: @openzeppelin/contracts/utils/Address.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Collection of functions related to the address type
342  */
343 library Address {
344     /**
345      * @dev Returns true if `account` is a contract.
346      *
347      * [IMPORTANT]
348      * ====
349      * It is unsafe to assume that an address for which this function returns
350      * false is an externally-owned account (EOA) and not a contract.
351      *
352      * Among others, `isContract` will return false for the following
353      * types of addresses:
354      *
355      *  - an externally-owned account
356      *  - a contract in construction
357      *  - an address where a contract will be created
358      *  - an address where a contract lived, but was destroyed
359      * ====
360      */
361     function isContract(address account) internal view returns (bool) {
362         // This method relies on extcodesize, which returns 0 for contracts in
363         // construction, since the code is only stored at the end of the
364         // constructor execution.
365 
366         uint256 size;
367         assembly {
368             size := extcodesize(account)
369         }
370         return size > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         (bool success, ) = recipient.call{value: amount}("");
393         require(success, "Address: unable to send value, recipient may have reverted");
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain `call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionCall(target, data, "Address: low-level call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
420      * `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, 0, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but also transferring `value` wei to `target`.
435      *
436      * Requirements:
437      *
438      * - the calling contract must have an ETH balance of at least `value`.
439      * - the called Solidity function must be `payable`.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 value
447     ) internal returns (bytes memory) {
448         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
453      * with `errorMessage` as a fallback revert reason when `target` reverts.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(address(this).balance >= value, "Address: insufficient balance for call");
464         require(isContract(target), "Address: call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.call{value: value}(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
477         return functionStaticCall(target, data, "Address: low-level static call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal view returns (bytes memory) {
491         require(isContract(target), "Address: static call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.staticcall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but performing a delegate call.
500      *
501      * _Available since v3.4._
502      */
503     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(isContract(target), "Address: delegate call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
526      * revert reason using the provided one.
527      *
528      * _Available since v4.3._
529      */
530     function verifyCallResult(
531         bool success,
532         bytes memory returndata,
533         string memory errorMessage
534     ) internal pure returns (bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
562  * @dev See https://eips.ethereum.org/EIPS/eip-721
563  */
564 interface IERC721Metadata is IERC721 {
565     /**
566      * @dev Returns the token collection name.
567      */
568     function name() external view returns (string memory);
569 
570     /**
571      * @dev Returns the token collection symbol.
572      */
573     function symbol() external view returns (string memory);
574 
575     /**
576      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
577      */
578     function tokenURI(uint256 tokenId) external view returns (string memory);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
582 
583 
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @title ERC721 token receiver interface
589  * @dev Interface for any contract that wants to support safeTransfers
590  * from ERC721 asset contracts.
591  */
592 interface IERC721Receiver {
593     /**
594      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
595      * by `operator` from `from`, this function is called.
596      *
597      * It must return its Solidity selector to confirm the token transfer.
598      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
599      *
600      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
601      */
602     function onERC721Received(
603         address operator,
604         address from,
605         uint256 tokenId,
606         bytes calldata data
607     ) external returns (bytes4);
608 }
609 
610 // File: @openzeppelin/contracts/utils/Context.sol
611 pragma solidity ^0.8.0;
612 /**
613  * @dev Provides information about the current execution context, including the
614  * sender of the transaction and its data. While these are generally available
615  * via msg.sender and msg.data, they should not be accessed in such a direct
616  * manner, since when dealing with meta-transactions the account sending and
617  * paying for execution may not be the actual sender (as far as an application
618  * is concerned).
619  *
620  * This contract is only required for intermediate, library-like contracts.
621  */
622 abstract contract Context {
623     function _msgSender() internal view virtual returns (address) {
624         return msg.sender;
625     }
626 
627     function _msgData() internal view virtual returns (bytes calldata) {
628         return msg.data;
629     }
630 }
631 
632 
633 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
634 pragma solidity ^0.8.0;
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension, but not including the Enumerable extension, which is available separately as
638  * {ERC721Enumerable}.
639  */
640 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     // Token name
645     string private _name;
646 
647     // Token symbol
648     string private _symbol;
649 
650     // Mapping from token ID to owner address
651     mapping(uint256 => address) private _owners;
652 
653     // Mapping owner address to token count
654     mapping(address => uint256) private _balances;
655 
656     // Mapping from token ID to approved address
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     /**
663      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
664      */
665     constructor(string memory name_, string memory symbol_) {
666         _name = name_;
667         _symbol = symbol_;
668     }
669 
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
674         return
675             interfaceId == type(IERC721).interfaceId ||
676             interfaceId == type(IERC721Metadata).interfaceId ||
677             super.supportsInterface(interfaceId);
678     }
679 
680     /**
681      * @dev See {IERC721-balanceOf}.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         require(owner != address(0), "ERC721: balance query for the zero address");
685         return _balances[owner];
686     }
687 
688     /**
689      * @dev See {IERC721-ownerOf}.
690      */
691     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
692         address owner = _owners[tokenId];
693         require(owner != address(0), "ERC721: owner query for nonexistent token");
694         return owner;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-name}.
699      */
700     function name() public view virtual override returns (string memory) {
701         return _name;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-symbol}.
706      */
707     function symbol() public view virtual override returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-tokenURI}.
713      */
714     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
715         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
716 
717         string memory baseURI = _baseURI();
718         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
719     }
720 
721     /**
722      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
723      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
724      * by default, can be overriden in child contracts.
725      */
726     function _baseURI() internal view virtual returns (string memory) {
727         return "";
728     }
729 
730     /**
731      * @dev See {IERC721-approve}.
732      */
733     function approve(address to, uint256 tokenId) public virtual override {
734         address owner = ERC721.ownerOf(tokenId);
735         require(to != owner, "ERC721: approval to current owner");
736 
737         require(
738             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
739             "ERC721: approve caller is not owner nor approved for all"
740         );
741 
742         _approve(to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-getApproved}.
747      */
748     function getApproved(uint256 tokenId) public view virtual override returns (address) {
749         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
750 
751         return _tokenApprovals[tokenId];
752     }
753 
754     /**
755      * @dev See {IERC721-setApprovalForAll}.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         require(operator != _msgSender(), "ERC721: approve to caller");
759 
760         _operatorApprovals[_msgSender()][operator] = approved;
761         emit ApprovalForAll(_msgSender(), operator, approved);
762     }
763 
764     /**
765      * @dev See {IERC721-isApprovedForAll}.
766      */
767     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     /**
772      * @dev See {IERC721-transferFrom}.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         //solhint-disable-next-line max-line-length
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781 
782         _transfer(from, to, tokenId);
783     }
784 
785     /**
786      * @dev See {IERC721-safeTransferFrom}.
787      */
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         safeTransferFrom(from, to, tokenId, "");
794     }
795 
796     /**
797      * @dev See {IERC721-safeTransferFrom}.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId,
803         bytes memory _data
804     ) public virtual override {
805         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
806         _safeTransfer(from, to, tokenId, _data);
807     }
808 
809     /**
810      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
811      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
812      *
813      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
814      *
815      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
816      * implement alternative mechanisms to perform token transfer, such as signature-based.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must exist and be owned by `from`.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeTransfer(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) internal virtual {
833         _transfer(from, to, tokenId);
834         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
835     }
836 
837     /**
838      * @dev Returns whether `tokenId` exists.
839      *
840      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
841      *
842      * Tokens start existing when they are minted (`_mint`),
843      * and stop existing when they are burned (`_burn`).
844      */
845     function _exists(uint256 tokenId) internal view virtual returns (bool) {
846         return _owners[tokenId] != address(0);
847     }
848 
849     /**
850      * @dev Returns whether `spender` is allowed to manage `tokenId`.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      */
856     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
857         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
858         address owner = ERC721.ownerOf(tokenId);
859         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
883         bytes memory _data
884     ) internal virtual {
885         _mint(to, tokenId);
886         require(
887             _checkOnERC721Received(address(0), to, tokenId, _data),
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
914     }
915 
916     /**
917      * @dev Destroys `tokenId`.
918      * The approval is cleared when the token is burned.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must exist.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _burn(uint256 tokenId) internal virtual {
927         address owner = ERC721.ownerOf(tokenId);
928 
929         _beforeTokenTransfer(owner, address(0), tokenId);
930 
931         // Clear approvals
932         _approve(address(0), tokenId);
933 
934         _balances[owner] -= 1;
935         delete _owners[tokenId];
936 
937         emit Transfer(owner, address(0), tokenId);
938     }
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
943      *
944      * Requirements:
945      *
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must be owned by `from`.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _transfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {
956         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
957         require(to != address(0), "ERC721: transfer to the zero address");
958 
959         _beforeTokenTransfer(from, to, tokenId);
960 
961         // Clear approvals from the previous owner
962         _approve(address(0), tokenId);
963 
964         _balances[from] -= 1;
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(from, to, tokenId);
969     }
970 
971     /**
972      * @dev Approve `to` to operate on `tokenId`
973      *
974      * Emits a {Approval} event.
975      */
976     function _approve(address to, uint256 tokenId) internal virtual {
977         _tokenApprovals[tokenId] = to;
978         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
979     }
980 
981     /**
982      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
983      * The call is not executed if the target address is not a contract.
984      *
985      * @param from address representing the previous owner of the given token ID
986      * @param to target address that will receive the tokens
987      * @param tokenId uint256 ID of the token to be transferred
988      * @param _data bytes optional data to send along with the call
989      * @return bool whether the call correctly returned the expected magic value
990      */
991     function _checkOnERC721Received(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) private returns (bool) {
997         if (to.isContract()) {
998             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
999                 return retval == IERC721Receiver.onERC721Received.selector;
1000             } catch (bytes memory reason) {
1001                 if (reason.length == 0) {
1002                     revert("ERC721: transfer to non ERC721Receiver implementer");
1003                 } else {
1004                     assembly {
1005                         revert(add(32, reason), mload(reason))
1006                     }
1007                 }
1008             }
1009         } else {
1010             return true;
1011         }
1012     }
1013 
1014     /**
1015      * @dev Hook that is called before any token transfer. This includes minting
1016      * and burning.
1017      *
1018      * Calling conditions:
1019      *
1020      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1021      * transferred to `to`.
1022      * - When `from` is zero, `tokenId` will be minted for `to`.
1023      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1024      * - `from` and `to` are never both zero.
1025      *
1026      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1027      */
1028     function _beforeTokenTransfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {}
1033 }
1034 
1035 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1036 
1037 
1038 
1039 pragma solidity ^0.8.0;
1040 
1041 
1042 
1043 /**
1044  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1045  * enumerability of all the token ids in the contract as well as all token ids owned by each
1046  * account.
1047  */
1048 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1049     // Mapping from owner to list of owned token IDs
1050     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1051 
1052     // Mapping from token ID to index of the owner tokens list
1053     mapping(uint256 => uint256) private _ownedTokensIndex;
1054 
1055     // Array with all token ids, used for enumeration
1056     uint256[] private _allTokens;
1057 
1058     // Mapping from token id to position in the allTokens array
1059     mapping(uint256 => uint256) private _allTokensIndex;
1060 
1061     /**
1062      * @dev See {IERC165-supportsInterface}.
1063      */
1064     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1065         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1070      */
1071     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1072         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1073         return _ownedTokens[owner][index];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Enumerable-totalSupply}.
1078      */
1079     function totalSupply() public view virtual override returns (uint256) {
1080         return _allTokens.length;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Enumerable-tokenByIndex}.
1085      */
1086     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1087         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1088         return _allTokens[index];
1089     }
1090 
1091     /**
1092      * @dev Hook that is called before any token transfer. This includes minting
1093      * and burning.
1094      *
1095      * Calling conditions:
1096      *
1097      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1098      * transferred to `to`.
1099      * - When `from` is zero, `tokenId` will be minted for `to`.
1100      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _beforeTokenTransfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) internal virtual override {
1111         super._beforeTokenTransfer(from, to, tokenId);
1112 
1113         if (from == address(0)) {
1114             _addTokenToAllTokensEnumeration(tokenId);
1115         } else if (from != to) {
1116             _removeTokenFromOwnerEnumeration(from, tokenId);
1117         }
1118         if (to == address(0)) {
1119             _removeTokenFromAllTokensEnumeration(tokenId);
1120         } else if (to != from) {
1121             _addTokenToOwnerEnumeration(to, tokenId);
1122         }
1123     }
1124 
1125     /**
1126      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1127      * @param to address representing the new owner of the given token ID
1128      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1129      */
1130     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1131         uint256 length = ERC721.balanceOf(to);
1132         _ownedTokens[to][length] = tokenId;
1133         _ownedTokensIndex[tokenId] = length;
1134     }
1135 
1136     /**
1137      * @dev Private function to add a token to this extension's token tracking data structures.
1138      * @param tokenId uint256 ID of the token to be added to the tokens list
1139      */
1140     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1141         _allTokensIndex[tokenId] = _allTokens.length;
1142         _allTokens.push(tokenId);
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1147      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1148      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1149      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1150      * @param from address representing the previous owner of the given token ID
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1152      */
1153     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1154         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1158         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary
1161         if (tokenIndex != lastTokenIndex) {
1162             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1163 
1164             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1165             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1166         }
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _ownedTokensIndex[tokenId];
1170         delete _ownedTokens[from][lastTokenIndex];
1171     }
1172 
1173     /**
1174      * @dev Private function to remove a token from this extension's token tracking data structures.
1175      * This has O(1) time complexity, but alters the order of the _allTokens array.
1176      * @param tokenId uint256 ID of the token to be removed from the tokens list
1177      */
1178     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1179         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1180         // then delete the last slot (swap and pop).
1181 
1182         uint256 lastTokenIndex = _allTokens.length - 1;
1183         uint256 tokenIndex = _allTokensIndex[tokenId];
1184 
1185         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1186         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1187         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1188         uint256 lastTokenId = _allTokens[lastTokenIndex];
1189 
1190         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1191         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1192 
1193         // This also deletes the contents at the last position of the array
1194         delete _allTokensIndex[tokenId];
1195         _allTokens.pop();
1196     }
1197 }
1198 
1199 
1200 // File: @openzeppelin/contracts/access/Ownable.sol
1201 pragma solidity ^0.8.0;
1202 /**
1203  * @dev Contract module which provides a basic access control mechanism, where
1204  * there is an account (an owner) that can be granted exclusive access to
1205  * specific functions.
1206  *
1207  * By default, the owner account will be the one that deploys the contract. This
1208  * can later be changed with {transferOwnership}.
1209  *
1210  * This module is used through inheritance. It will make available the modifier
1211  * `onlyOwner`, which can be applied to your functions to restrict their use to
1212  * the owner.
1213  */
1214 abstract contract Ownable is Context {
1215     address private _owner;
1216 
1217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1218 
1219     /**
1220      * @dev Initializes the contract setting the deployer as the initial owner.
1221      */
1222     constructor() {
1223         _setOwner(_msgSender());
1224     }
1225 
1226     /**
1227      * @dev Returns the address of the current owner.
1228      */
1229     function owner() public view virtual returns (address) {
1230         return _owner;
1231     }
1232 
1233     /**
1234      * @dev Throws if called by any account other than the owner.
1235      */
1236     modifier onlyOwner() {
1237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1238         _;
1239     }
1240 
1241     /**
1242      * @dev Leaves the contract without owner. It will not be possible to call
1243      * `onlyOwner` functions anymore. Can only be called by the current owner.
1244      *
1245      * NOTE: Renouncing ownership will leave the contract without an owner,
1246      * thereby removing any functionality that is only available to the owner.
1247      */
1248     function renounceOwnership() public virtual onlyOwner {
1249         _setOwner(address(0));
1250     }
1251 
1252     /**
1253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1254      * Can only be called by the current owner.
1255      */
1256     function transferOwnership(address newOwner) public virtual onlyOwner {
1257         require(newOwner != address(0), "Ownable: new owner is the zero address");
1258         _setOwner(newOwner);
1259     }
1260 
1261     function _setOwner(address newOwner) private {
1262         address oldOwner = _owner;
1263         _owner = newOwner;
1264         emit OwnershipTransferred(oldOwner, newOwner);
1265     }
1266 }
1267 
1268 
1269 pragma solidity >=0.7.0 <0.9.0;
1270 
1271 
1272 contract RBDCC is ERC721, Ownable {
1273   using Strings for uint256;
1274   using  Counters for Counters.Counter;
1275 
1276   Counters.Counter private supply;
1277 
1278   string private baseURI;
1279   string private baseExtension;
1280   string private RevealedUri;
1281   string private signature;
1282   address[] private Twallets;
1283   uint256 public presaleCost = 0.1 ether;
1284   uint256 public cost = 0.2 ether;
1285   uint256 public maxSupply = 10000;
1286   uint256 public maxMintAmountPerTx = 50;
1287   uint256 public nftPerWLAddressLimit = 5;
1288   bool public paused = true;
1289   bool public revealed = false;
1290   bool public presaleActive = true; 
1291   mapping(address => uint256) public addressMintedBalance;
1292 
1293   constructor(
1294     string memory _name,
1295     string memory _symbol,
1296     string memory _signature,
1297     string memory _initBaseURI,
1298     string memory _initRevealedUri
1299   ) ERC721(_name, _symbol) { setSignature(_signature);
1300     setBaseURI(_initBaseURI);
1301     setRevealedURI(_initRevealedUri);
1302   }
1303 
1304   // internal
1305   function _baseURI() internal view virtual override returns (string memory) {
1306     return baseURI;
1307   }
1308   
1309   modifier mintCompliance(uint256 _mintAmount) {
1310     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1311     require(supply.current() + _mintAmount <= maxSupply, "This tx would exceed max supply");
1312     _;
1313   }
1314 
1315   function totalSupply() public view returns (uint256) {
1316     return supply.current();
1317   }
1318 
1319   // Mint-Presale and Public
1320 
1321   function mint(uint256 _mintAmount, string memory _signature) public payable mintCompliance(_mintAmount) {
1322     
1323     if (presaleActive == true){
1324         require(!paused, "the contract is paused");
1325         require(presaleActive, "Presale is not Active!");
1326         require(keccak256(abi.encodePacked((signature))) == keccak256(abi.encodePacked((_signature))), "Invalid Signature");
1327         require(msg.value >= presaleCost * _mintAmount, "Balance too low");
1328 
1329     
1330             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1331             require(ownerMintedCount + _mintAmount <= nftPerWLAddressLimit, "max NFT per presale tx exceeded");
1332             
1333         
1334             _mintLoop(msg.sender, _mintAmount);
1335     }
1336 
1337     if (presaleActive == false){
1338     require(!paused, "the contract is paused");
1339     require(!presaleActive, "Presale is still active");
1340     require(msg.value >= cost * _mintAmount, "Balance too low");
1341         
1342         _mintLoop(msg.sender, _mintAmount);
1343   
1344     }
1345     }
1346 
1347 
1348     
1349 
1350 
1351    function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1352     _mintLoop(_receiver, _mintAmount);
1353   }
1354 
1355 
1356    function walletOfOwner(address _owner)
1357     public
1358     view
1359     returns (uint256[] memory)
1360   {
1361     uint256 ownerTokenCount = balanceOf(_owner);
1362     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1363     uint256 currentTokenId = 1;
1364     uint256 ownedTokenIndex = 0;
1365 
1366     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1367       address currentTokenOwner = ownerOf(currentTokenId);
1368 
1369       if (currentTokenOwner == _owner) {
1370         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1371 
1372         ownedTokenIndex++;
1373       }
1374 
1375       currentTokenId++;
1376     }
1377 
1378     return ownedTokenIds;
1379   }
1380 
1381   function tokenURI(uint256 tokenId)
1382     public
1383     view
1384     virtual
1385     override
1386     returns (string memory)
1387   {
1388     require(
1389       _exists(tokenId),
1390       "ERC721Metadata: URI query for nonexistent token"
1391     );
1392     
1393     if(revealed == false) {
1394         return RevealedUri;
1395     }
1396 
1397     string memory currentBaseURI = _baseURI();
1398     return bytes(currentBaseURI).length > 0
1399         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1400         : "";
1401   }
1402 
1403 
1404   //owner commands only
1405   function reveal() public onlyOwner {
1406       revealed = true;
1407   }
1408 
1409   function setSignature(string memory _signature) public onlyOwner {
1410      signature = _signature;
1411   }
1412 
1413   
1414   function setNftPerWLAddressLimit(uint256 _limit) public onlyOwner {
1415     nftPerWLAddressLimit = _limit;
1416   }
1417 
1418   function setpresaleCost(uint256 _newpreCost) public onlyOwner {
1419     presaleCost = _newpreCost;
1420   }
1421 
1422   function setPublicCost(uint256 _newCost) public onlyOwner {
1423     cost = _newCost;
1424   }
1425 
1426   function setmaxMintAmount(uint256 _newmaxMintAmountPerTx) public onlyOwner {
1427     maxMintAmountPerTx = _newmaxMintAmountPerTx;
1428   }
1429 
1430   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1431     baseURI = _newBaseURI;
1432   }
1433 
1434   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1435     baseExtension = _newBaseExtension;
1436   }
1437   
1438   function setRevealedURI(string memory _RevealedURI) public onlyOwner {
1439     RevealedUri = _RevealedURI;
1440   }
1441 
1442   function pause(bool _state) public onlyOwner {
1443     paused = _state;
1444   }
1445   
1446   function setpreSale(bool _state) public onlyOwner {
1447     presaleActive = _state;
1448   }
1449   
1450   function setTwallets(address[] calldata _devwallets) public onlyOwner {
1451       delete Twallets;
1452       Twallets = _devwallets;
1453   }
1454 
1455   function getBalance() public view onlyOwner returns (uint256) {
1456         return address(this).balance;
1457     }
1458  
1459   function withdrawl1() public payable onlyOwner {
1460     // Do the splits here!
1461     // Project Wallet: 0x71CfB6c8Afa53B05148b8bf420E566caeE21d6bc
1462     uint256 currentBalance = address(this).balance;
1463     (bool hs, ) = payable(Twallets[2]).call{value: currentBalance * 225 / 1000}("");
1464     require(hs);
1465     (bool bs, ) = payable(Twallets[3]).call{value: currentBalance * 225 / 1000}("");
1466     require(bs);
1467     (bool cs, ) = payable(Twallets[1]).call{value: currentBalance * 200 / 1000}("");
1468     require(cs);
1469     (bool es, ) = payable(0x71CfB6c8Afa53B05148b8bf420E566caeE21d6bc).call{value: currentBalance * 100 / 1000}("");
1470     require(es);
1471     (bool ds, ) = payable(Twallets[0]).call{value: currentBalance * 50 / 1000}("");
1472     require(ds);
1473     //remainder to owner
1474     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1475     require(os);
1476   }
1477 
1478   function withdrawB() external onlyOwner {
1479         uint256 currentBalance = address(this).balance;
1480         payable(Twallets[2]).transfer(currentBalance * 225 / 1000);
1481         payable(Twallets[3]).transfer(currentBalance * 225/ 1000);
1482         payable(Twallets[1]).transfer(currentBalance * 200/ 1000);
1483         payable(0x71CfB6c8Afa53B05148b8bf420E566caeE21d6bc).transfer(currentBalance * 100 / 1000);
1484         payable(Twallets[0]).transfer(currentBalance * 50/ 1000);           
1485         payable(owner()).transfer(address(this).balance);
1486     }
1487 
1488    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1489     for (uint256 i = 0; i < _mintAmount; i++) {
1490       supply.increment();
1491       _safeMint(_receiver, supply.current());
1492     }
1493   }
1494 }