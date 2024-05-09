1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @title Counters
563  * @author Matt Condon (@shrugs)
564  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
565  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
566  *
567  * Include with `using Counters for Counters.Counter;`
568  */
569 library Counters {
570     struct Counter {
571         // This variable should never be directly accessed by users of the library: interactions must be restricted to
572         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
573         // this feature: see https://github.com/ethereum/solidity/issues/4637
574         uint256 _value; // default: 0
575     }
576 
577     function current(Counter storage counter) internal view returns (uint256) {
578         return counter._value;
579     }
580 
581     function increment(Counter storage counter) internal {
582         unchecked {
583             counter._value += 1;
584         }
585     }
586 
587     function decrement(Counter storage counter) internal {
588         uint256 value = counter._value;
589         require(value > 0, "Counter: decrement overflow");
590         unchecked {
591             counter._value = value - 1;
592         }
593     }
594 
595     function reset(Counter storage counter) internal {
596         counter._value = 0;
597     }
598 }
599 
600 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Provides information about the current execution context, including the
609  * sender of the transaction and its data. While these are generally available
610  * via msg.sender and msg.data, they should not be accessed in such a direct
611  * manner, since when dealing with meta-transactions the account sending and
612  * paying for execution may not be the actual sender (as far as an application
613  * is concerned).
614  *
615  * This contract is only required for intermediate, library-like contracts.
616  */
617 abstract contract Context {
618     function _msgSender() internal view virtual returns (address) {
619         return msg.sender;
620     }
621 
622     function _msgData() internal view virtual returns (bytes calldata) {
623         return msg.data;
624     }
625 }
626 
627 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
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
1053 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol
1054 
1055 
1056 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Burnable.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 
1062 /**
1063  * @title ERC721 Burnable Token
1064  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1065  */
1066 abstract contract ERC721Burnable is Context, ERC721 {
1067     /**
1068      * @dev Burns `tokenId`. See {ERC721-_burn}.
1069      *
1070      * Requirements:
1071      *
1072      * - The caller must own `tokenId` or be an approved operator.
1073      */
1074     function burn(uint256 tokenId) public virtual {
1075         //solhint-disable-next-line max-line-length
1076         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1077         _burn(tokenId);
1078     }
1079 }
1080 
1081 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1082 
1083 
1084 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 
1089 /**
1090  * @dev Contract module which provides a basic access control mechanism, where
1091  * there is an account (an owner) that can be granted exclusive access to
1092  * specific functions.
1093  *
1094  * By default, the owner account will be the one that deploys the contract. This
1095  * can later be changed with {transferOwnership}.
1096  *
1097  * This module is used through inheritance. It will make available the modifier
1098  * `onlyOwner`, which can be applied to your functions to restrict their use to
1099  * the owner.
1100  */
1101 abstract contract Ownable is Context {
1102     address private _owner;
1103 
1104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1105 
1106     /**
1107      * @dev Initializes the contract setting the deployer as the initial owner.
1108      */
1109     constructor() {
1110         _transferOwnership(_msgSender());
1111     }
1112 
1113     /**
1114      * @dev Returns the address of the current owner.
1115      */
1116     function owner() public view virtual returns (address) {
1117         return _owner;
1118     }
1119 
1120     /**
1121      * @dev Throws if called by any account other than the owner.
1122      */
1123     modifier onlyOwner() {
1124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1125         _;
1126     }
1127 
1128     /**
1129      * @dev Leaves the contract without owner. It will not be possible to call
1130      * `onlyOwner` functions anymore. Can only be called by the current owner.
1131      *
1132      * NOTE: Renouncing ownership will leave the contract without an owner,
1133      * thereby removing any functionality that is only available to the owner.
1134      */
1135     function renounceOwnership() public virtual onlyOwner {
1136         _transferOwnership(address(0));
1137     }
1138 
1139     /**
1140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1141      * Can only be called by the current owner.
1142      */
1143     function transferOwnership(address newOwner) public virtual onlyOwner {
1144         require(newOwner != address(0), "Ownable: new owner is the zero address");
1145         _transferOwnership(newOwner);
1146     }
1147 
1148     /**
1149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1150      * Internal function without access restriction.
1151      */
1152     function _transferOwnership(address newOwner) internal virtual {
1153         address oldOwner = _owner;
1154         _owner = newOwner;
1155         emit OwnershipTransferred(oldOwner, newOwner);
1156     }
1157 }
1158 
1159 // File: wgg.sol
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 
1165 
1166 
1167 
1168 /// SPDX-License-Identifier: UNLICENSED
1169 
1170 /*
1171  __      __.__.__       .___   ________              __      ________                       
1172 /  \    /  \__|  |    __| _/  /  _____/  _________ _/  |_   /  _____/_____    ____    ____  
1173 \   \/\/   /  |  |   / __ |  /   \  ___ /  _ \__  \\   __\ /   \  ___\__  \  /    \  / ___\ 
1174  \        /|  |  |__/ /_/ |  \    \_\  (  <_> ) __ \|  |   \    \_\  \/ __ \|   |  \/ /_/  >
1175   \__/\  / |__|____/\____ |   \______  /\____(____  /__|    \______  (____  /___|  /\___  / 
1176        \/                \/          \/           \/               \/     \/     \//_____/  
1177 */
1178 
1179 
1180 contract WGG is ERC721Burnable, Ownable {
1181    
1182     using Strings for uint256;
1183     using Counters for Counters.Counter;
1184     
1185     string public baseURI;
1186     string public baseExtension = ".json";
1187     uint8 public maxTx = 3;
1188     uint256 public maxSupply = 10000;
1189     uint256 public price = 0.08 ether;
1190     
1191     bool public goatPresaleOpen = true;
1192     bool public goatMainsaleOpen = false;
1193     
1194     Counters.Counter private _tokenIdTracker;
1195 
1196     mapping (address => bool) whiteListed;
1197     mapping (address => uint256) walletMinted;
1198     
1199     constructor(string memory _initBaseURI) ERC721("Wild Goat Gang", "WGG")
1200     {
1201         setBaseURI(_initBaseURI);
1202 
1203         for(uint i=0;i<100;i++)
1204         {
1205             _tokenIdTracker.increment();
1206             _safeMint(0x5a065F2E2E05BBe470d8Fc6930bb23a162Ae9b96, totalToken());
1207         }
1208     }
1209     
1210     modifier isPresaleOpen
1211     {
1212          require(goatPresaleOpen == true);
1213          _;
1214     }
1215 
1216     modifier isMainsaleOpen
1217     {
1218          require(goatMainsaleOpen == true);
1219          _;
1220     }
1221 
1222     function flipPresale() public onlyOwner
1223     {
1224         goatPresaleOpen = false;
1225         goatMainsaleOpen = true;
1226     }
1227 
1228     function changeMaxSupply(uint256 _maxSupply) public onlyOwner
1229     {
1230         maxSupply = _maxSupply;
1231     }
1232     
1233     function totalToken() public view returns (uint256) {
1234             return _tokenIdTracker.current();
1235     }
1236 
1237     function addWhiteList(address[] memory whiteListedAddresses) public onlyOwner
1238     {
1239         for(uint256 i=0; i<whiteListedAddresses.length;i++)
1240         {
1241             whiteListed[whiteListedAddresses[i]] = true;
1242         }
1243     }
1244 
1245     function isAddressWhitelisted(address whitelist) public view returns(bool)
1246     {
1247         return whiteListed[whitelist];
1248     }
1249 
1250 
1251     function preSale(uint8 mintTotal) public payable isPresaleOpen
1252     {
1253         uint256 totalMinted = mintTotal + walletMinted[msg.sender];
1254         
1255         require(whiteListed[msg.sender] == true, "You are not whitelisted!");
1256         require(totalMinted <= maxTx, "Mint exceeds limitations");
1257         require(mintTotal >= 1 , "Mint Amount Incorrect");
1258         require(msg.value >= price * mintTotal, "Minting a Wild Goat Costs 0.08 Ether Each!");
1259         require(totalToken() < maxSupply, "SOLD OUT!");
1260        
1261         for(uint i=0;i<mintTotal;i++)
1262         {
1263             require(totalToken() < maxSupply, "SOLD OUT!");
1264             _tokenIdTracker.increment();
1265             _safeMint(msg.sender, totalToken());
1266         }
1267     }
1268 
1269     
1270     function mainSale(uint8 mintTotal) public payable isMainsaleOpen
1271     {
1272         uint256 totalMinted = mintTotal + walletMinted[msg.sender];
1273 
1274         require(totalMinted <= maxTx, "Mint exceeds limitations");
1275         require(mintTotal >= 1 , "Mint Amount Incorrect");
1276         require(msg.value >= price * mintTotal, "Minting a Wild Goat Costs 0.08 Ether Each!");
1277         require(totalToken() < maxSupply, "SOLD OUT!");
1278        
1279         for(uint i=0;i<mintTotal;i++)
1280         {
1281             require(totalToken() < maxSupply, "SOLD OUT!");
1282             _tokenIdTracker.increment();
1283             _safeMint(msg.sender, totalToken());
1284         }
1285     }
1286    
1287     function withdrawContractEther() external onlyOwner
1288     {
1289         address payable teamOne = payable(0x9f199f62a1aCb6877AC6C82759Df34B24A484e9C);
1290         address payable teamTwo = payable(0x1599f9F775451DBd03a1a951d4D93107900276A4);
1291         address payable teamThree = payable(0xEEe7dB024C2c629556Df7F80f528913048f12fbc);
1292         address payable teamFour = payable(0xD43763625605fF5894100B24Db41EB19A9c0E65e);
1293         
1294         uint256 totalSplit = (getBalance() / 4);
1295 
1296         teamOne.transfer(totalSplit);
1297         teamTwo.transfer(totalSplit);
1298         teamThree.transfer(totalSplit);
1299         teamFour.transfer(totalSplit);
1300 
1301     }
1302     function getBalance() public view returns(uint)
1303     {
1304         return address(this).balance;
1305     }
1306    
1307     function _baseURI() internal view virtual override returns (string memory) {
1308         return baseURI;
1309     }
1310    
1311     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1312         baseURI = _newBaseURI;
1313     }
1314    
1315     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1316     {
1317         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1318 
1319         string memory currentBaseURI = _baseURI();
1320         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1321     }
1322 }