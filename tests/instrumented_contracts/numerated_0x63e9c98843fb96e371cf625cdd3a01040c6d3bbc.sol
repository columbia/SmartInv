1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
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
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      */
98     function isContract(address account) internal view returns (bool) {
99         // This method relies on extcodesize, which returns 0 for contracts in
100         // construction, since the code is only stored at the end of the
101         // constructor execution.
102 
103         uint256 size;
104         assembly {
105             size := extcodesize(account)
106         }
107         return size > 0;
108     }
109 
110     /**
111      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
112      * `recipient`, forwarding all available gas and reverting on errors.
113      *
114      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
115      * of certain opcodes, possibly making contracts go over the 2300 gas limit
116      * imposed by `transfer`, making them unable to receive funds via
117      * `transfer`. {sendValue} removes this limitation.
118      *
119      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
120      *
121      * IMPORTANT: because control is transferred to `recipient`, care must be
122      * taken to not create reentrancy vulnerabilities. Consider using
123      * {ReentrancyGuard} or the
124      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
125      */
126     function sendValue(address payable recipient, uint256 amount) internal {
127         require(address(this).balance >= amount, "Address: insufficient balance");
128 
129         (bool success, ) = recipient.call{value: amount}("");
130         require(success, "Address: unable to send value, recipient may have reverted");
131     }
132 
133     /**
134      * @dev Performs a Solidity function call using a low level `call`. A
135      * plain `call` is an unsafe replacement for a function call: use this
136      * function instead.
137      *
138      * If `target` reverts with a revert reason, it is bubbled up by this
139      * function (like regular Solidity function calls).
140      *
141      * Returns the raw returned data. To convert to the expected return value,
142      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
143      *
144      * Requirements:
145      *
146      * - `target` must be a contract.
147      * - calling `target` with `data` must not revert.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionCall(target, data, "Address: low-level call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
157      * `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but also transferring `value` wei to `target`.
172      *
173      * Requirements:
174      *
175      * - the calling contract must have an ETH balance of at least `value`.
176      * - the called Solidity function must be `payable`.
177      *
178      * _Available since v3.1._
179      */
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.call{value: value}(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal view returns (bytes memory) {
228         require(isContract(target), "Address: static call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.staticcall(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
263      * revert reason using the provided one.
264      *
265      * _Available since v4.3._
266      */
267     function verifyCallResult(
268         bool success,
269         bytes memory returndata,
270         string memory errorMessage
271     ) internal pure returns (bytes memory) {
272         if (success) {
273             return returndata;
274         } else {
275             // Look for revert reason and bubble it up if present
276             if (returndata.length > 0) {
277                 // The easiest way to bubble the revert reason is using memory via assembly
278 
279                 assembly {
280                     let returndata_size := mload(returndata)
281                     revert(add(32, returndata), returndata_size)
282                 }
283             } else {
284                 revert(errorMessage);
285             }
286         }
287     }
288 }
289 
290 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @title ERC721 token receiver interface
298  * @dev Interface for any contract that wants to support safeTransfers
299  * from ERC721 asset contracts.
300  */
301 interface IERC721Receiver {
302     /**
303      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
304      * by `operator` from `from`, this function is called.
305      *
306      * It must return its Solidity selector to confirm the token transfer.
307      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
308      *
309      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
310      */
311     function onERC721Received(
312         address operator,
313         address from,
314         uint256 tokenId,
315         bytes calldata data
316     ) external returns (bytes4);
317 }
318 
319 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
320 
321 
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Interface of the ERC165 standard, as defined in the
327  * https://eips.ethereum.org/EIPS/eip-165[EIP].
328  *
329  * Implementers can declare support of contract interfaces, which can then be
330  * queried by others ({ERC165Checker}).
331  *
332  * For an implementation, see {ERC165}.
333  */
334 interface IERC165 {
335     /**
336      * @dev Returns true if this contract implements the interface defined by
337      * `interfaceId`. See the corresponding
338      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
339      * to learn more about how these ids are created.
340      *
341      * This function call must use less than 30 000 gas.
342      */
343     function supportsInterface(bytes4 interfaceId) external view returns (bool);
344 }
345 
346 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Implementation of the {IERC165} interface.
355  *
356  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
357  * for the additional interface id that will be supported. For example:
358  *
359  * ```solidity
360  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
361  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
362  * }
363  * ```
364  *
365  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
366  */
367 abstract contract ERC165 is IERC165 {
368     /**
369      * @dev See {IERC165-supportsInterface}.
370      */
371     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372         return interfaceId == type(IERC165).interfaceId;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
377 
378 
379 
380 pragma solidity ^0.8.0;
381 
382 
383 /**
384  * @dev Required interface of an ERC721 compliant contract.
385  */
386 interface IERC721 is IERC165 {
387     /**
388      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
394      */
395     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in ``owner``'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
418      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId
434     ) external;
435 
436     /**
437      * @dev Transfers `tokenId` token from `from` to `to`.
438      *
439      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must be owned by `from`.
446      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
458      * The approval is cleared when the token is transferred.
459      *
460      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
461      *
462      * Requirements:
463      *
464      * - The caller must own the token or be an approved operator.
465      * - `tokenId` must exist.
466      *
467      * Emits an {Approval} event.
468      */
469     function approve(address to, uint256 tokenId) external;
470 
471     /**
472      * @dev Returns the account approved for `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function getApproved(uint256 tokenId) external view returns (address operator);
479 
480     /**
481      * @dev Approve or remove `operator` as an operator for the caller.
482      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
483      *
484      * Requirements:
485      *
486      * - The `operator` cannot be the caller.
487      *
488      * Emits an {ApprovalForAll} event.
489      */
490     function setApprovalForAll(address operator, bool _approved) external;
491 
492     /**
493      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
494      *
495      * See {setApprovalForAll}
496      */
497     function isApprovedForAll(address owner, address operator) external view returns (bool);
498 
499     /**
500      * @dev Safely transfers `tokenId` token from `from` to `to`.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must exist and be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
509      *
510      * Emits a {Transfer} event.
511      */
512     function safeTransferFrom(
513         address from,
514         address to,
515         uint256 tokenId,
516         bytes calldata data
517     ) external;
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
521 
522 
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
529  * @dev See https://eips.ethereum.org/EIPS/eip-721
530  */
531 interface IERC721Enumerable is IERC721 {
532     /**
533      * @dev Returns the total amount of tokens stored by the contract.
534      */
535     function totalSupply() external view returns (uint256);
536 
537     /**
538      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
539      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
540      */
541     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
542 
543     /**
544      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
545      * Use along with {totalSupply} to enumerate all tokens.
546      */
547     function tokenByIndex(uint256 index) external view returns (uint256);
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
551 
552 
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
559  * @dev See https://eips.ethereum.org/EIPS/eip-721
560  */
561 interface IERC721Metadata is IERC721 {
562     /**
563      * @dev Returns the token collection name.
564      */
565     function name() external view returns (string memory);
566 
567     /**
568      * @dev Returns the token collection symbol.
569      */
570     function symbol() external view returns (string memory);
571 
572     /**
573      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
574      */
575     function tokenURI(uint256 tokenId) external view returns (string memory);
576 }
577 
578 // File: @openzeppelin/contracts/utils/Counters.sol
579 
580 
581 
582 pragma solidity ^0.8.0;
583 
584 /**
585  * @title Counters
586  * @author Matt Condon (@shrugs)
587  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
588  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
589  *
590  * Include with `using Counters for Counters.Counter;`
591  */
592 library Counters {
593     struct Counter {
594         // This variable should never be directly accessed by users of the library: interactions must be restricted to
595         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
596         // this feature: see https://github.com/ethereum/solidity/issues/4637
597         uint256 _value; // default: 0
598     }
599 
600     function current(Counter storage counter) internal view returns (uint256) {
601         return counter._value;
602     }
603 
604     function increment(Counter storage counter) internal {
605         unchecked {
606             counter._value += 1;
607         }
608     }
609 
610     function decrement(Counter storage counter) internal {
611         uint256 value = counter._value;
612         require(value > 0, "Counter: decrement overflow");
613         unchecked {
614             counter._value = value - 1;
615         }
616     }
617 
618     function reset(Counter storage counter) internal {
619         counter._value = 0;
620     }
621 }
622 
623 // File: @openzeppelin/contracts/utils/Context.sol
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Provides information about the current execution context, including the
631  * sender of the transaction and its data. While these are generally available
632  * via msg.sender and msg.data, they should not be accessed in such a direct
633  * manner, since when dealing with meta-transactions the account sending and
634  * paying for execution may not be the actual sender (as far as an application
635  * is concerned).
636  *
637  * This contract is only required for intermediate, library-like contracts.
638  */
639 abstract contract Context {
640     function _msgSender() internal view virtual returns (address) {
641         return msg.sender;
642     }
643 
644     function _msgData() internal view virtual returns (bytes calldata) {
645         return msg.data;
646     }
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 
656 
657 
658 
659 
660 
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata extension, but not including the Enumerable extension, which is available separately as
665  * {ERC721Enumerable}.
666  */
667 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
668     using Address for address;
669     using Strings for uint256;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to owner address
678     mapping(uint256 => address) private _owners;
679 
680     // Mapping owner address to token count
681     mapping(address => uint256) private _balances;
682 
683     // Mapping from token ID to approved address
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     /**
690      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
691      */
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695     }
696 
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
701         return
702             interfaceId == type(IERC721).interfaceId ||
703             interfaceId == type(IERC721Metadata).interfaceId ||
704             super.supportsInterface(interfaceId);
705     }
706 
707     /**
708      * @dev See {IERC721-balanceOf}.
709      */
710     function balanceOf(address owner) public view virtual override returns (uint256) {
711         require(owner != address(0), "ERC721: balance query for the zero address");
712         return _balances[owner];
713     }
714 
715     /**
716      * @dev See {IERC721-ownerOf}.
717      */
718     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
719         address owner = _owners[tokenId];
720         require(owner != address(0), "ERC721: owner query for nonexistent token");
721         return owner;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-name}.
726      */
727     function name() public view virtual override returns (string memory) {
728         return _name;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-symbol}.
733      */
734     function symbol() public view virtual override returns (string memory) {
735         return _symbol;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-tokenURI}.
740      */
741     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
742         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
743 
744         string memory baseURI = _baseURI();
745         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
746     }
747 
748     /**
749      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
750      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
751      * by default, can be overriden in child contracts.
752      */
753     function _baseURI() internal view virtual returns (string memory) {
754         return "";
755     }
756 
757     /**
758      * @dev See {IERC721-approve}.
759      */
760     function approve(address to, uint256 tokenId) public virtual override {
761         address owner = ERC721.ownerOf(tokenId);
762         require(to != owner, "ERC721: approval to current owner");
763 
764         require(
765             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
766             "ERC721: approve caller is not owner nor approved for all"
767         );
768 
769         _approve(to, tokenId);
770     }
771 
772     /**
773      * @dev See {IERC721-getApproved}.
774      */
775     function getApproved(uint256 tokenId) public view virtual override returns (address) {
776         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
777 
778         return _tokenApprovals[tokenId];
779     }
780 
781     /**
782      * @dev See {IERC721-setApprovalForAll}.
783      */
784     function setApprovalForAll(address operator, bool approved) public virtual override {
785         require(operator != _msgSender(), "ERC721: approve to caller");
786 
787         _operatorApprovals[_msgSender()][operator] = approved;
788         emit ApprovalForAll(_msgSender(), operator, approved);
789     }
790 
791     /**
792      * @dev See {IERC721-isApprovedForAll}.
793      */
794     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
795         return _operatorApprovals[owner][operator];
796     }
797 
798     /**
799      * @dev See {IERC721-transferFrom}.
800      */
801     function transferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         //solhint-disable-next-line max-line-length
807         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
808 
809         _transfer(from, to, tokenId);
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         safeTransferFrom(from, to, tokenId, "");
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) public virtual override {
832         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
833         _safeTransfer(from, to, tokenId, _data);
834     }
835 
836     /**
837      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
838      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
839      *
840      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
841      *
842      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
843      * implement alternative mechanisms to perform token transfer, such as signature-based.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must exist and be owned by `from`.
850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _safeTransfer(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) internal virtual {
860         _transfer(from, to, tokenId);
861         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
862     }
863 
864     /**
865      * @dev Returns whether `tokenId` exists.
866      *
867      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
868      *
869      * Tokens start existing when they are minted (`_mint`),
870      * and stop existing when they are burned (`_burn`).
871      */
872     function _exists(uint256 tokenId) internal view virtual returns (bool) {
873         return _owners[tokenId] != address(0);
874     }
875 
876     /**
877      * @dev Returns whether `spender` is allowed to manage `tokenId`.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      */
883     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
884         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
885         address owner = ERC721.ownerOf(tokenId);
886         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
887     }
888 
889     /**
890      * @dev Safely mints `tokenId` and transfers it to `to`.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must not exist.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeMint(address to, uint256 tokenId) internal virtual {
900         _safeMint(to, tokenId, "");
901     }
902 
903     /**
904      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
905      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
906      */
907     function _safeMint(
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _mint(to, tokenId);
913         require(
914             _checkOnERC721Received(address(0), to, tokenId, _data),
915             "ERC721: transfer to non ERC721Receiver implementer"
916         );
917     }
918 
919     /**
920      * @dev Mints `tokenId` and transfers it to `to`.
921      *
922      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
923      *
924      * Requirements:
925      *
926      * - `tokenId` must not exist.
927      * - `to` cannot be the zero address.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _mint(address to, uint256 tokenId) internal virtual {
932         require(to != address(0), "ERC721: mint to the zero address");
933         require(!_exists(tokenId), "ERC721: token already minted");
934 
935         _beforeTokenTransfer(address(0), to, tokenId);
936 
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939 
940         emit Transfer(address(0), to, tokenId);
941     }
942 
943     /**
944      * @dev Destroys `tokenId`.
945      * The approval is cleared when the token is burned.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must exist.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _burn(uint256 tokenId) internal virtual {
954         address owner = ERC721.ownerOf(tokenId);
955 
956         _beforeTokenTransfer(owner, address(0), tokenId);
957 
958         // Clear approvals
959         _approve(address(0), tokenId);
960 
961         _balances[owner] -= 1;
962         delete _owners[tokenId];
963 
964         emit Transfer(owner, address(0), tokenId);
965     }
966 
967     /**
968      * @dev Transfers `tokenId` from `from` to `to`.
969      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must be owned by `from`.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _transfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) internal virtual {
983         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
984         require(to != address(0), "ERC721: transfer to the zero address");
985 
986         _beforeTokenTransfer(from, to, tokenId);
987 
988         // Clear approvals from the previous owner
989         _approve(address(0), tokenId);
990 
991         _balances[from] -= 1;
992         _balances[to] += 1;
993         _owners[tokenId] = to;
994 
995         emit Transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev Approve `to` to operate on `tokenId`
1000      *
1001      * Emits a {Approval} event.
1002      */
1003     function _approve(address to, uint256 tokenId) internal virtual {
1004         _tokenApprovals[tokenId] = to;
1005         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1010      * The call is not executed if the target address is not a contract.
1011      *
1012      * @param from address representing the previous owner of the given token ID
1013      * @param to target address that will receive the tokens
1014      * @param tokenId uint256 ID of the token to be transferred
1015      * @param _data bytes optional data to send along with the call
1016      * @return bool whether the call correctly returned the expected magic value
1017      */
1018     function _checkOnERC721Received(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) private returns (bool) {
1024         if (to.isContract()) {
1025             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1026                 return retval == IERC721Receiver.onERC721Received.selector;
1027             } catch (bytes memory reason) {
1028                 if (reason.length == 0) {
1029                     revert("ERC721: transfer to non ERC721Receiver implementer");
1030                 } else {
1031                     assembly {
1032                         revert(add(32, reason), mload(reason))
1033                     }
1034                 }
1035             }
1036         } else {
1037             return true;
1038         }
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` and `to` are never both zero.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _beforeTokenTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {}
1060 }
1061 
1062 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1063 
1064 
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 
1069 
1070 /**
1071  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1072  * enumerability of all the token ids in the contract as well as all token ids owned by each
1073  * account.
1074  */
1075 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1076     // Mapping from owner to list of owned token IDs
1077     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1078 
1079     // Mapping from token ID to index of the owner tokens list
1080     mapping(uint256 => uint256) private _ownedTokensIndex;
1081 
1082     // Array with all token ids, used for enumeration
1083     uint256[] private _allTokens;
1084 
1085     // Mapping from token id to position in the allTokens array
1086     mapping(uint256 => uint256) private _allTokensIndex;
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      */
1091     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1092         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1097      */
1098     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1100         return _ownedTokens[owner][index];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-totalSupply}.
1105      */
1106     function totalSupply() public view virtual override returns (uint256) {
1107         return _allTokens.length;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenByIndex}.
1112      */
1113     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1115         return _allTokens[index];
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _beforeTokenTransfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) internal virtual override {
1138         super._beforeTokenTransfer(from, to, tokenId);
1139 
1140         if (from == address(0)) {
1141             _addTokenToAllTokensEnumeration(tokenId);
1142         } else if (from != to) {
1143             _removeTokenFromOwnerEnumeration(from, tokenId);
1144         }
1145         if (to == address(0)) {
1146             _removeTokenFromAllTokensEnumeration(tokenId);
1147         } else if (to != from) {
1148             _addTokenToOwnerEnumeration(to, tokenId);
1149         }
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1154      * @param to address representing the new owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1156      */
1157     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1158         uint256 length = ERC721.balanceOf(to);
1159         _ownedTokens[to][length] = tokenId;
1160         _ownedTokensIndex[tokenId] = length;
1161     }
1162 
1163     /**
1164      * @dev Private function to add a token to this extension's token tracking data structures.
1165      * @param tokenId uint256 ID of the token to be added to the tokens list
1166      */
1167     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1168         _allTokensIndex[tokenId] = _allTokens.length;
1169         _allTokens.push(tokenId);
1170     }
1171 
1172     /**
1173      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1174      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1175      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1176      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1177      * @param from address representing the previous owner of the given token ID
1178      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1179      */
1180     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1181         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1182         // then delete the last slot (swap and pop).
1183 
1184         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1185         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1186 
1187         // When the token to delete is the last token, the swap operation is unnecessary
1188         if (tokenIndex != lastTokenIndex) {
1189             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1190 
1191             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1192             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1193         }
1194 
1195         // This also deletes the contents at the last position of the array
1196         delete _ownedTokensIndex[tokenId];
1197         delete _ownedTokens[from][lastTokenIndex];
1198     }
1199 
1200     /**
1201      * @dev Private function to remove a token from this extension's token tracking data structures.
1202      * This has O(1) time complexity, but alters the order of the _allTokens array.
1203      * @param tokenId uint256 ID of the token to be removed from the tokens list
1204      */
1205     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1206         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1207         // then delete the last slot (swap and pop).
1208 
1209         uint256 lastTokenIndex = _allTokens.length - 1;
1210         uint256 tokenIndex = _allTokensIndex[tokenId];
1211 
1212         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1213         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1214         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1215         uint256 lastTokenId = _allTokens[lastTokenIndex];
1216 
1217         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219 
1220         // This also deletes the contents at the last position of the array
1221         delete _allTokensIndex[tokenId];
1222         _allTokens.pop();
1223     }
1224 }
1225 
1226 // File: @openzeppelin/contracts/access/Ownable.sol
1227 
1228 
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 /**
1234  * @dev Contract module which provides a basic access control mechanism, where
1235  * there is an account (an owner) that can be granted exclusive access to
1236  * specific functions.
1237  *
1238  * By default, the owner account will be the one that deploys the contract. This
1239  * can later be changed with {transferOwnership}.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _setOwner(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Returns the address of the current owner.
1259      */
1260     function owner() public view virtual returns (address) {
1261         return _owner;
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Leaves the contract without owner. It will not be possible to call
1274      * `onlyOwner` functions anymore. Can only be called by the current owner.
1275      *
1276      * NOTE: Renouncing ownership will leave the contract without an owner,
1277      * thereby removing any functionality that is only available to the owner.
1278      */
1279     function renounceOwnership() public virtual onlyOwner {
1280         _setOwner(address(0));
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Can only be called by the current owner.
1286      */
1287     function transferOwnership(address newOwner) public virtual onlyOwner {
1288         require(newOwner != address(0), "Ownable: new owner is the zero address");
1289         _setOwner(newOwner);
1290     }
1291 
1292     function _setOwner(address newOwner) private {
1293         address oldOwner = _owner;
1294         _owner = newOwner;
1295         emit OwnershipTransferred(oldOwner, newOwner);
1296     }
1297 }
1298 
1299 // File: contracts/DeadHandzTartarus.sol
1300 pragma solidity ^0.8.0;
1301 
1302 /// @title Dead Handz Tartarus
1303 /// @author Aric Kuter
1304 /// @dev All function calls are currently implemented without events to save on gas
1305 contract DeadHandzTartarus is ERC721Enumerable, Ownable {
1306     using Strings for uint256;
1307     using Counters for Counters.Counter;
1308 
1309     Counters.Counter private _tokenIdCounter;
1310 
1311     ERC721Enumerable private genesisContract;
1312 
1313     /// ============ Mutable storage ============
1314 
1315     /// @notice URI for revealed metadata
1316     string public baseURI;
1317     /// @notice URI for hidden metadata
1318     string public hiddenURI;
1319     /// @notice Extension for metadata files
1320     string public baseExtension = "";
1321 
1322     /// @notice Mint cost per NFT
1323     uint256 public COST = 0.07 ether;
1324     /// @notice Max supply of NFTs
1325     uint256 public MAX_SUPPLY = 667;
1326     /// @notice Max mint amount
1327     uint256 public MAX_MINT = 10;
1328 
1329     /// @notice Pause or Resume minting
1330     bool public mintMain = false;
1331     /// @notice Open whitelisting
1332     bool public mintWhitelist = false;
1333     /// @notice Reveal metadata
1334     bool public revealed = false;
1335 
1336     /// @notice Map address to minted amount
1337     mapping(address => uint256) public addressMintedBalance;
1338     /// @notice Map token IDs to bool
1339     mapping(uint256 => bool) public idMinted;
1340 
1341     /// ============ Constructor ============
1342 
1343     /// @param _name name of NFT
1344     /// @param _symbol symbol of NFT
1345     /// @param _initBaseURI URI for revealed metadata in format: ipfs://HASH/
1346     /// @param _initHiddenURI URI for hidden metadata in format: ipfs://HASH/
1347     /// @param _OWNER_MINT_AMOUNT Number of NFTs to mint to the owners address
1348     constructor(
1349         string memory _name,
1350         string memory _symbol,
1351         string memory _initBaseURI,
1352         string memory _initHiddenURI,
1353         uint256 _OWNER_MINT_AMOUNT
1354     ) ERC721(_name, _symbol) {
1355         baseURI = _initBaseURI;
1356         hiddenURI = _initHiddenURI;
1357         genesisContract = ERC721Enumerable(0x04B591AD5f4E23447c41E7Abbb5a2c2e9D797b8F);
1358 
1359         /// @notice Start token IDs at 1
1360         _tokenIdCounter.increment();
1361 
1362         /// @notice mint to owners address
1363         reserveTokens(owner(), _OWNER_MINT_AMOUNT);
1364     }
1365 
1366     /// @return Returns the baseURI
1367     function _baseURI() internal view virtual override returns (string memory) {
1368         return baseURI;
1369     }
1370 
1371     /// @notice Mint NFTs to senders address
1372     /// @param _mintAmount Number of NFTs to mint
1373     function mint(uint256 _mintAmount, bytes memory _signature) external payable {
1374         /// @notice Check the mint is active or the sender is whitelisted
1375         require(
1376             mintMain || (mintWhitelist && isValidAccessMessage(msg.sender, _signature)),
1377             "Minting unavailable"
1378         );
1379         require(_mintAmount > 0 && _mintAmount < MAX_MINT, "Invalid amount");
1380         uint256 _tokenId = _tokenIdCounter.current();
1381         require(_tokenId + _mintAmount < MAX_SUPPLY, "Supply limit reached");
1382         require(
1383             addressMintedBalance[msg.sender] + _mintAmount < MAX_MINT,"Mint limit reached"
1384         );
1385         require(msg.value == COST * _mintAmount, "Incorrect ETH");
1386 
1387         addressMintedBalance[msg.sender] += _mintAmount;
1388         for (uint256 i = 0; i < _mintAmount; i++) {
1389             _safeMint(msg.sender, _tokenId + i);
1390             _tokenIdCounter.increment();
1391         }
1392     }
1393 
1394     /// @notice Mint NFTs to senders address without cost - Genesis holders only mint function
1395     /// @param _mintAmount Number of NFTs to mint
1396     function genesisMint(uint256 _mintAmount) external {
1397         /// @notice Check the mint is active or the sender is whitelisted
1398         require(
1399             mintMain || mintWhitelist,
1400             "Minting unavailable"
1401         );
1402         require(_mintAmount > 0, "Invalid amount");
1403         uint256 _genesisBalance = genesisContract.balanceOf(msg.sender);
1404         require(_genesisBalance >= _mintAmount + addressMintedBalance[msg.sender], "Insufficient genesis handz");
1405         uint256 _tokenId = _tokenIdCounter.current();
1406         require(_tokenId + _mintAmount < MAX_SUPPLY, "Supply limit reached");
1407         require(
1408             addressMintedBalance[msg.sender] + _mintAmount < MAX_MINT,"Mint limit reached"
1409         );
1410 
1411         for (uint256 i = 0; i < _mintAmount; i++) {
1412             uint256 tokenId = genesisContract.tokenOfOwnerByIndex(msg.sender, i);
1413             require(!idMinted[tokenId], "Token already redeemed");
1414         }
1415 
1416         addressMintedBalance[msg.sender] += _mintAmount;
1417         for (uint256 i = 0; i < _mintAmount; i++) {
1418             _safeMint(msg.sender, _tokenId + i);
1419             idMinted[genesisContract.tokenOfOwnerByIndex(msg.sender, i)] = true;
1420             _tokenIdCounter.increment();
1421         }
1422     }
1423 
1424     /// @notice Reserved mint function for owner only
1425     /// @param _to Address to send tokens to
1426     /// @param _mintAmount Number of NFTs to mint
1427     function reserveTokens(address _to, uint256 _mintAmount) public onlyOwner {
1428         uint256 _tokenId = _tokenIdCounter.current();
1429         /// @notice Safely mint the NFTs
1430         for (uint256 i = 0; i < _mintAmount; i++) {
1431             _safeMint(_to, _tokenId + i);
1432             _tokenIdCounter.increment();
1433         }
1434     }
1435 
1436     /*
1437      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1438      *      Assumes Geth signature prefix.
1439      * @param _add Address of agent with access
1440      * @param _v ECDSA signature parameter v.
1441      * @param _r ECDSA signature parameters r.
1442      * @param _s ECDSA signature parameters s.
1443      * @return Validity of access message for a given address.
1444      */
1445     function isValidAccessMessage(address _addr, bytes memory _signature)
1446         public
1447         view
1448         returns (bool)
1449     {
1450         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1451         bytes32 messageHash = getMessageHash(address(this), _addr);
1452         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1453 
1454         return owner() == ecrecover(ethSignedMessageHash, v, r, s);
1455     }
1456 
1457     function getMessageHash(address _contractAddr, address _addr)
1458         public
1459         pure
1460         returns (bytes32)
1461     {
1462         return keccak256(abi.encodePacked(_contractAddr, _addr));
1463     }
1464 
1465     function getEthSignedMessageHash(bytes32 _messageHash)
1466         public
1467         pure
1468         returns (bytes32)
1469     {
1470         return
1471             keccak256(
1472                 abi.encodePacked(
1473                     "\x19Ethereum Signed Message:\n32",
1474                     _messageHash
1475                 )
1476             );
1477     }
1478 
1479     function recoverSigner(
1480         bytes32 _ethSignedMessageHash,
1481         bytes memory _signature
1482     ) public pure returns (address) {
1483         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1484 
1485         return ecrecover(_ethSignedMessageHash, v, r, s);
1486     }
1487 
1488     function splitSignature(bytes memory sig)
1489         public
1490         pure
1491         returns (
1492             bytes32 r,
1493             bytes32 s,
1494             uint8 v
1495         )
1496     {
1497         require(sig.length == 65, "invalid signature length");
1498 
1499         assembly {
1500             /*
1501             First 32 bytes stores the length of the signature
1502             add(sig, 32) = pointer of sig + 32
1503             effectively, skips first 32 bytes of signature
1504             mload(p) loads next 32 bytes starting at the memory address p into memory
1505             */
1506 
1507             // first 32 bytes, after the length prefix
1508             r := mload(add(sig, 32))
1509             // second 32 bytes
1510             s := mload(add(sig, 64))
1511             // final byte (first byte of the next 32 bytes)
1512             v := byte(0, mload(add(sig, 96)))
1513         }
1514 
1515         // implicitly return (r, s, v)
1516     }
1517 
1518     /// @return Returns a conststructed string in the format: //ipfs/HASH/[tokenId].json
1519     function tokenURI(uint256 tokenId)
1520         public
1521         view
1522         virtual
1523         override
1524         returns (string memory)
1525     {
1526         require(
1527             _exists(tokenId),
1528             "ERC721Metadata: URI query for NonExistent Token."
1529         );
1530 
1531         if (!revealed) {
1532             return hiddenURI;
1533         }
1534 
1535         string memory currentBaseURI = _baseURI();
1536         return
1537             bytes(currentBaseURI).length > 0
1538                 ? string(
1539                     abi.encodePacked(
1540                         currentBaseURI,
1541                         tokenId.toString(),
1542                         baseExtension
1543                     )
1544                 )
1545                 : "";
1546     }
1547 
1548     /// @notice Reveal metadata
1549     function reveal() external onlyOwner {
1550         revealed = true;
1551     }
1552 
1553     /// @notice Set the URI of the hidden metadata
1554     /// @param _hiddenURI URI for hidden metadata NOTE: This URI must be the link to the exact file in format: ipfs//HASH/
1555     function setHiddenURI(string memory _hiddenURI) external onlyOwner {
1556         hiddenURI = _hiddenURI;
1557     }
1558 
1559     /// @notice Set URI of the metadata
1560     /// @param _newBaseURI URI for revealed metadata
1561     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1562         baseURI = _newBaseURI;
1563     }
1564 
1565     /// @notice Set the base extension for the metadata
1566     /// @param _newBaseExtension Base extension value
1567     function setBaseExtension(string memory _newBaseExtension)
1568         external
1569         onlyOwner
1570     {
1571         baseExtension = _newBaseExtension;
1572     }
1573 
1574     /// @notice Toggle mintMain
1575     function toggleMintMain() external onlyOwner {
1576         mintMain = !mintMain;
1577     }
1578 
1579     /// @notice Toggle mintWhitelist
1580     function toggleMintWhitelist() external onlyOwner {
1581         mintWhitelist = !mintWhitelist;
1582     }
1583 
1584     /// @notice Withdraw proceeds from contract address to owners address
1585     function withdraw() external {
1586         require(payable(owner()).send(address(this).balance));
1587     }
1588 }