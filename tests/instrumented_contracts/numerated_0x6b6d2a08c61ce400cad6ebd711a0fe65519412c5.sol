1 /* SPDX-License-Identifier: GPL-3.0
2 
3 ████████╗██╗░░██╗███████╗░░██████╗░░█████╗░███╗░░██╗░██████╗░░█████╗░███████╗███╗░░██╗░██████╗
4 ╚══██╔══╝██║░░██║██╔════╝░░██╔══██╗██╔══██╗████╗░██║██╔════╝░██╔══██╗██╔════╝████╗░██║██╔════╝
5 ░░░██║░░░███████║█████╗░░░░██████╔╝███████║██╔██╗██║██║░░██╗░███████║█████╗░░██╔██╗██║╚█████╗░
6 ░░░██║░░░██╔══██║██╔══╝░░░░██╔═══╝░██╔══██║██║╚████║██║░░╚██╗██╔══██║██╔══╝░░██║╚████║░╚═══██╗
7 ░░░██║░░░██║░░██║███████╗░░██║░░░░░██║░░██║██║░╚███║╚██████╔╝██║░░██║███████╗██║░╚███║██████╔╝
8 ░░░╚═╝░░░╚═╝░░╚═╝╚══════╝░░╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝╚═════╝░
9 
10 */
11 
12 pragma solidity ^0.8.0;
13 
14 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
15 /**
16  * @dev Interface of the ERC165 standard, as defined in the
17  * https://eips.ethereum.org/EIPS/eip-165[EIP].
18  *
19  * Implementers can declare support of contract interfaces, which can then be
20  * queried by others ({ERC165Checker}).
21  *
22  * For an implementation, see {ERC165}.
23  */
24 interface IERC165 {
25     /**
26      * @dev Returns true if this contract implements the interface defined by
27      * `interfaceId`. See the corresponding
28      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
29      * to learn more about how these ids are created.
30      *
31      * This function call must use less than 30 000 gas.
32      */
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
37 pragma solidity ^0.8.0;
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
177 pragma solidity ^0.8.0;
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
180  * @dev See https://eips.ethereum.org/EIPS/eip-721
181  */
182 interface IERC721Enumerable is IERC721 {
183     /**
184      * @dev Returns the total amount of tokens stored by the contract.
185      */
186     function totalSupply() external view returns (uint256);
187 
188     /**
189      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
190      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
191      */
192     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
193 
194     /**
195      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
196      * Use along with {totalSupply} to enumerate all tokens.
197      */
198     function tokenByIndex(uint256 index) external view returns (uint256);
199 }
200 
201 
202 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
203 pragma solidity ^0.8.0;
204 /**
205  * @dev Implementation of the {IERC165} interface.
206  *
207  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
208  * for the additional interface id that will be supported. For example:
209  *
210  * ```solidity
211  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
212  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
213  * }
214  * ```
215  *
216  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
217  */
218 abstract contract ERC165 is IERC165 {
219     /**
220      * @dev See {IERC165-supportsInterface}.
221      */
222     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
223         return interfaceId == type(IERC165).interfaceId;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Strings.sol
228 
229 
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev String operations.
235  */
236 library Strings {
237     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
241      */
242     function toString(uint256 value) internal pure returns (string memory) {
243         // Inspired by OraclizeAPI's implementation - MIT licence
244         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
245 
246         if (value == 0) {
247             return "0";
248         }
249         uint256 temp = value;
250         uint256 digits;
251         while (temp != 0) {
252             digits++;
253             temp /= 10;
254         }
255         bytes memory buffer = new bytes(digits);
256         while (value != 0) {
257             digits -= 1;
258             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
259             value /= 10;
260         }
261         return string(buffer);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
266      */
267     function toHexString(uint256 value) internal pure returns (string memory) {
268         if (value == 0) {
269             return "0x00";
270         }
271         uint256 temp = value;
272         uint256 length = 0;
273         while (temp != 0) {
274             length++;
275             temp >>= 8;
276         }
277         return toHexString(value, length);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
282      */
283     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
284         bytes memory buffer = new bytes(2 * length + 2);
285         buffer[0] = "0";
286         buffer[1] = "x";
287         for (uint256 i = 2 * length + 1; i > 1; --i) {
288             buffer[i] = _HEX_SYMBOLS[value & 0xf];
289             value >>= 4;
290         }
291         require(value == 0, "Strings: hex length insufficient");
292         return string(buffer);
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/Address.sol
297 
298 
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         assembly {
330             size := extcodesize(account)
331         }
332         return size > 0;
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, "Address: insufficient balance");
353 
354         (bool success, ) = recipient.call{value: amount}("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain `call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(address(this).balance >= value, "Address: insufficient balance for call");
426         require(isContract(target), "Address: call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.call{value: value}(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, "Address: low-level static call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal view returns (bytes memory) {
453         require(isContract(target), "Address: static call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a delegate call.
462      *
463      * _Available since v3.4._
464      */
465     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
488      * revert reason using the provided one.
489      *
490      * _Available since v4.3._
491      */
492     function verifyCallResult(
493         bool success,
494         bytes memory returndata,
495         string memory errorMessage
496     ) internal pure returns (bytes memory) {
497         if (success) {
498             return returndata;
499         } else {
500             // Look for revert reason and bubble it up if present
501             if (returndata.length > 0) {
502                 // The easiest way to bubble the revert reason is using memory via assembly
503 
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
524  * @dev See https://eips.ethereum.org/EIPS/eip-721
525  */
526 interface IERC721Metadata is IERC721 {
527     /**
528      * @dev Returns the token collection name.
529      */
530     function name() external view returns (string memory);
531 
532     /**
533      * @dev Returns the token collection symbol.
534      */
535     function symbol() external view returns (string memory);
536 
537     /**
538      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
539      */
540     function tokenURI(uint256 tokenId) external view returns (string memory);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
544 
545 
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @title ERC721 token receiver interface
551  * @dev Interface for any contract that wants to support safeTransfers
552  * from ERC721 asset contracts.
553  */
554 interface IERC721Receiver {
555     /**
556      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
557      * by `operator` from `from`, this function is called.
558      *
559      * It must return its Solidity selector to confirm the token transfer.
560      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
561      *
562      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
563      */
564     function onERC721Received(
565         address operator,
566         address from,
567         uint256 tokenId,
568         bytes calldata data
569     ) external returns (bytes4);
570 }
571 
572 // File: @openzeppelin/contracts/utils/Context.sol
573 pragma solidity ^0.8.0;
574 /**
575  * @dev Provides information about the current execution context, including the
576  * sender of the transaction and its data. While these are generally available
577  * via msg.sender and msg.data, they should not be accessed in such a direct
578  * manner, since when dealing with meta-transactions the account sending and
579  * paying for execution may not be the actual sender (as far as an application
580  * is concerned).
581  *
582  * This contract is only required for intermediate, library-like contracts.
583  */
584 abstract contract Context {
585     function _msgSender() internal view virtual returns (address) {
586         return msg.sender;
587     }
588 
589     function _msgData() internal view virtual returns (bytes calldata) {
590         return msg.data;
591     }
592 }
593 
594 
595 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
596 pragma solidity ^0.8.0;
597 /**
598  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
599  * the Metadata extension, but not including the Enumerable extension, which is available separately as
600  * {ERC721Enumerable}.
601  */
602 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
603     using Address for address;
604     using Strings for uint256;
605 
606     // Token name
607     string private _name;
608 
609     // Token symbol
610     string private _symbol;
611 
612     // Mapping from token ID to owner address
613     mapping(uint256 => address) private _owners;
614 
615     // Mapping owner address to token count
616     mapping(address => uint256) private _balances;
617 
618     // Mapping from token ID to approved address
619     mapping(uint256 => address) private _tokenApprovals;
620 
621     // Mapping from owner to operator approvals
622     mapping(address => mapping(address => bool)) private _operatorApprovals;
623 
624     /**
625      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
626      */
627     constructor(string memory name_, string memory symbol_) {
628         _name = name_;
629         _symbol = symbol_;
630     }
631 
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
636         return
637             interfaceId == type(IERC721).interfaceId ||
638             interfaceId == type(IERC721Metadata).interfaceId ||
639             super.supportsInterface(interfaceId);
640     }
641 
642     /**
643      * @dev See {IERC721-balanceOf}.
644      */
645     function balanceOf(address owner) public view virtual override returns (uint256) {
646         require(owner != address(0), "ERC721: balance query for the zero address");
647         return _balances[owner];
648     }
649 
650     /**
651      * @dev See {IERC721-ownerOf}.
652      */
653     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
654         address owner = _owners[tokenId];
655         require(owner != address(0), "ERC721: owner query for nonexistent token");
656         return owner;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-name}.
661      */
662     function name() public view virtual override returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-symbol}.
668      */
669     function symbol() public view virtual override returns (string memory) {
670         return _symbol;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-tokenURI}.
675      */
676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
677         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
678 
679         string memory baseURI = _baseURI();
680         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
686      * by default, can be overriden in child contracts.
687      */
688     function _baseURI() internal view virtual returns (string memory) {
689         return "";
690     }
691 
692     /**
693      * @dev See {IERC721-approve}.
694      */
695     function approve(address to, uint256 tokenId) public virtual override {
696         address owner = ERC721.ownerOf(tokenId);
697         require(to != owner, "ERC721: approval to current owner");
698 
699         require(
700             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
701             "ERC721: approve caller is not owner nor approved for all"
702         );
703 
704         _approve(to, tokenId);
705     }
706 
707     /**
708      * @dev See {IERC721-getApproved}.
709      */
710     function getApproved(uint256 tokenId) public view virtual override returns (address) {
711         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
712 
713         return _tokenApprovals[tokenId];
714     }
715 
716     /**
717      * @dev See {IERC721-setApprovalForAll}.
718      */
719     function setApprovalForAll(address operator, bool approved) public virtual override {
720         require(operator != _msgSender(), "ERC721: approve to caller");
721 
722         _operatorApprovals[_msgSender()][operator] = approved;
723         emit ApprovalForAll(_msgSender(), operator, approved);
724     }
725 
726     /**
727      * @dev See {IERC721-isApprovedForAll}.
728      */
729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-transferFrom}.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         //solhint-disable-next-line max-line-length
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743 
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, "");
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
768         _safeTransfer(from, to, tokenId, _data);
769     }
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
776      *
777      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
778      * implement alternative mechanisms to perform token transfer, such as signature-based.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeTransfer(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _transfer(from, to, tokenId);
796         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
797     }
798 
799     /**
800      * @dev Returns whether `tokenId` exists.
801      *
802      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
803      *
804      * Tokens start existing when they are minted (`_mint`),
805      * and stop existing when they are burned (`_burn`).
806      */
807     function _exists(uint256 tokenId) internal view virtual returns (bool) {
808         return _owners[tokenId] != address(0);
809     }
810 
811     /**
812      * @dev Returns whether `spender` is allowed to manage `tokenId`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
819         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
820         address owner = ERC721.ownerOf(tokenId);
821         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
822     }
823 
824     /**
825      * @dev Safely mints `tokenId` and transfers it to `to`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeMint(address to, uint256 tokenId) internal virtual {
835         _safeMint(to, tokenId, "");
836     }
837 
838     /**
839      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
840      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
841      */
842     function _safeMint(
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _mint(to, tokenId);
848         require(
849             _checkOnERC721Received(address(0), to, tokenId, _data),
850             "ERC721: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Mints `tokenId` and transfers it to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - `to` cannot be the zero address.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 tokenId) internal virtual {
867         require(to != address(0), "ERC721: mint to the zero address");
868         require(!_exists(tokenId), "ERC721: token already minted");
869 
870         _beforeTokenTransfer(address(0), to, tokenId);
871 
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(address(0), to, tokenId);
876     }
877 
878     /**
879      * @dev Destroys `tokenId`.
880      * The approval is cleared when the token is burned.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _burn(uint256 tokenId) internal virtual {
889         address owner = ERC721.ownerOf(tokenId);
890 
891         _beforeTokenTransfer(owner, address(0), tokenId);
892 
893         // Clear approvals
894         _approve(address(0), tokenId);
895 
896         _balances[owner] -= 1;
897         delete _owners[tokenId];
898 
899         emit Transfer(owner, address(0), tokenId);
900     }
901 
902     /**
903      * @dev Transfers `tokenId` from `from` to `to`.
904      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _transfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) internal virtual {
918         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
919         require(to != address(0), "ERC721: transfer to the zero address");
920 
921         _beforeTokenTransfer(from, to, tokenId);
922 
923         // Clear approvals from the previous owner
924         _approve(address(0), tokenId);
925 
926         _balances[from] -= 1;
927         _balances[to] += 1;
928         _owners[tokenId] = to;
929 
930         emit Transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev Approve `to` to operate on `tokenId`
935      *
936      * Emits a {Approval} event.
937      */
938     function _approve(address to, uint256 tokenId) internal virtual {
939         _tokenApprovals[tokenId] = to;
940         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
941     }
942 
943     /**
944      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
945      * The call is not executed if the target address is not a contract.
946      *
947      * @param from address representing the previous owner of the given token ID
948      * @param to target address that will receive the tokens
949      * @param tokenId uint256 ID of the token to be transferred
950      * @param _data bytes optional data to send along with the call
951      * @return bool whether the call correctly returned the expected magic value
952      */
953     function _checkOnERC721Received(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) private returns (bool) {
959         if (to.isContract()) {
960             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
961                 return retval == IERC721Receiver.onERC721Received.selector;
962             } catch (bytes memory reason) {
963                 if (reason.length == 0) {
964                     revert("ERC721: transfer to non ERC721Receiver implementer");
965                 } else {
966                     assembly {
967                         revert(add(32, reason), mload(reason))
968                     }
969                 }
970             }
971         } else {
972             return true;
973         }
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, ``from``'s `tokenId` will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {}
995 }
996 
997 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
998 
999 
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 
1005 /**
1006  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1007  * enumerability of all the token ids in the contract as well as all token ids owned by each
1008  * account.
1009  */
1010 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1011     // Mapping from owner to list of owned token IDs
1012     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1013 
1014     // Mapping from token ID to index of the owner tokens list
1015     mapping(uint256 => uint256) private _ownedTokensIndex;
1016 
1017     // Array with all token ids, used for enumeration
1018     uint256[] private _allTokens;
1019 
1020     // Mapping from token id to position in the allTokens array
1021     mapping(uint256 => uint256) private _allTokensIndex;
1022 
1023     /**
1024      * @dev See {IERC165-supportsInterface}.
1025      */
1026     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1027         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1032      */
1033     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1034         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1035         return _ownedTokens[owner][index];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-totalSupply}.
1040      */
1041     function totalSupply() public view virtual override returns (uint256) {
1042         return _allTokens.length;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Enumerable-tokenByIndex}.
1047      */
1048     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1049         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1050         return _allTokens[index];
1051     }
1052 
1053     /**
1054      * @dev Hook that is called before any token transfer. This includes minting
1055      * and burning.
1056      *
1057      * Calling conditions:
1058      *
1059      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1060      * transferred to `to`.
1061      * - When `from` is zero, `tokenId` will be minted for `to`.
1062      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1063      * - `from` cannot be the zero address.
1064      * - `to` cannot be the zero address.
1065      *
1066      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1067      */
1068     function _beforeTokenTransfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) internal virtual override {
1073         super._beforeTokenTransfer(from, to, tokenId);
1074 
1075         if (from == address(0)) {
1076             _addTokenToAllTokensEnumeration(tokenId);
1077         } else if (from != to) {
1078             _removeTokenFromOwnerEnumeration(from, tokenId);
1079         }
1080         if (to == address(0)) {
1081             _removeTokenFromAllTokensEnumeration(tokenId);
1082         } else if (to != from) {
1083             _addTokenToOwnerEnumeration(to, tokenId);
1084         }
1085     }
1086 
1087     /**
1088      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1089      * @param to address representing the new owner of the given token ID
1090      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1091      */
1092     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1093         uint256 length = ERC721.balanceOf(to);
1094         _ownedTokens[to][length] = tokenId;
1095         _ownedTokensIndex[tokenId] = length;
1096     }
1097 
1098     /**
1099      * @dev Private function to add a token to this extension's token tracking data structures.
1100      * @param tokenId uint256 ID of the token to be added to the tokens list
1101      */
1102     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1103         _allTokensIndex[tokenId] = _allTokens.length;
1104         _allTokens.push(tokenId);
1105     }
1106 
1107     /**
1108      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1109      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1110      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1111      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1112      * @param from address representing the previous owner of the given token ID
1113      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1114      */
1115     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1116         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1117         // then delete the last slot (swap and pop).
1118 
1119         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1120         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1121 
1122         // When the token to delete is the last token, the swap operation is unnecessary
1123         if (tokenIndex != lastTokenIndex) {
1124             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1125 
1126             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1127             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1128         }
1129 
1130         // This also deletes the contents at the last position of the array
1131         delete _ownedTokensIndex[tokenId];
1132         delete _ownedTokens[from][lastTokenIndex];
1133     }
1134 
1135     /**
1136      * @dev Private function to remove a token from this extension's token tracking data structures.
1137      * This has O(1) time complexity, but alters the order of the _allTokens array.
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list
1139      */
1140     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1141         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = _allTokens.length - 1;
1145         uint256 tokenIndex = _allTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1148         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1149         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1150         uint256 lastTokenId = _allTokens[lastTokenIndex];
1151 
1152         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1153         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _allTokensIndex[tokenId];
1157         _allTokens.pop();
1158     }
1159 }
1160 
1161 
1162 // File: @openzeppelin/contracts/access/Ownable.sol
1163 pragma solidity ^0.8.0;
1164 /**
1165  * @dev Contract module which provides a basic access control mechanism, where
1166  * there is an account (an owner) that can be granted exclusive access to
1167  * specific functions.
1168  *
1169  * By default, the owner account will be the one that deploys the contract. This
1170  * can later be changed with {transferOwnership}.
1171  *
1172  * This module is used through inheritance. It will make available the modifier
1173  * `onlyOwner`, which can be applied to your functions to restrict their use to
1174  * the owner.
1175  */
1176 abstract contract Ownable is Context {
1177     address private _owner;
1178 
1179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1180 
1181     /**
1182      * @dev Initializes the contract setting the deployer as the initial owner.
1183      */
1184     constructor() {
1185         _setOwner(_msgSender());
1186     }
1187 
1188     /**
1189      * @dev Returns the address of the current owner.
1190      */
1191     function owner() public view virtual returns (address) {
1192         return _owner;
1193     }
1194 
1195     /**
1196      * @dev Throws if called by any account other than the owner.
1197      */
1198     modifier onlyOwner() {
1199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Leaves the contract without owner. It will not be possible to call
1205      * `onlyOwner` functions anymore. Can only be called by the current owner.
1206      *
1207      * NOTE: Renouncing ownership will leave the contract without an owner,
1208      * thereby removing any functionality that is only available to the owner.
1209      */
1210     function renounceOwnership() public virtual onlyOwner {
1211         _setOwner(address(0));
1212     }
1213 
1214     /**
1215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1216      * Can only be called by the current owner.
1217      */
1218     function transferOwnership(address newOwner) public virtual onlyOwner {
1219         require(newOwner != address(0), "Ownable: new owner is the zero address");
1220         _setOwner(newOwner);
1221     }
1222 
1223     function _setOwner(address newOwner) private {
1224         address oldOwner = _owner;
1225         _owner = newOwner;
1226         emit OwnershipTransferred(oldOwner, newOwner);
1227     }
1228 }
1229 
1230 
1231 /**
1232  * @dev Contract module that helps prevent reentrant calls to a function.
1233  *
1234  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1235  * available, which can be applied to functions to make sure there are no nested
1236  * (reentrant) calls to them.
1237  *
1238  * Note that because there is a single `nonReentrant` guard, functions marked as
1239  * `nonReentrant` may not call one another. This can be worked around by making
1240  * those functions `private`, and then adding `external` `nonReentrant` entry
1241  * points to them.
1242  *
1243  * TIP: If you would like to learn more about reentrancy and alternative ways
1244  * to protect against it, check out our blog post
1245  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1246  */
1247 abstract contract ReentrancyGuard {
1248     // Booleans are more expensive than uint256 or any type that takes up a full
1249     // word because each write operation emits an extra SLOAD to first read the
1250     // slot's contents, replace the bits taken up by the boolean, and then write
1251     // back. This is the compiler's defense against contract upgrades and
1252     // pointer aliasing, and it cannot be disabled.
1253 
1254     // The values being non-zero value makes deployment a bit more expensive,
1255     // but in exchange the refund on every call to nonReentrant will be lower in
1256     // amount. Since refunds are capped to a percentage of the total
1257     // transaction's gas, it is best to keep them low in cases like this one, to
1258     // increase the likelihood of the full refund coming into effect.
1259     uint256 private constant _NOT_ENTERED = 1;
1260     uint256 private constant _ENTERED = 2;
1261 
1262     uint256 private _status;
1263 
1264     constructor () {
1265         _status = _NOT_ENTERED;
1266     }
1267 
1268     /**
1269      * @dev Prevents a contract from calling itself, directly or indirectly.
1270      * Calling a `nonReentrant` function from another `nonReentrant`
1271      * function is not supported. It is possible to prevent this from happening
1272      * by making the `nonReentrant` function external, and make it call a
1273      * `private` function that does the actual work.
1274      */
1275     modifier nonReentrant() {
1276         // On the first call to nonReentrant, _notEntered will be true
1277         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1278 
1279         // Any calls to nonReentrant after this point will fail
1280         _status = _ENTERED;
1281 
1282         _;
1283 
1284         // By storing the original value once again, a refund is triggered (see
1285         // https://eips.ethereum.org/EIPS/eip-2200)
1286         _status = _NOT_ENTERED;
1287     }
1288 }
1289 
1290 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1291 
1292 /**
1293  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1294  *
1295  * These functions can be used to verify that a message was signed by the holder
1296  * of the private keys of a given address.
1297  */
1298 library ECDSA {
1299     enum RecoverError {
1300         NoError,
1301         InvalidSignature,
1302         InvalidSignatureLength,
1303         InvalidSignatureS,
1304         InvalidSignatureV
1305     }
1306 
1307     function _throwError(RecoverError error) private pure {
1308         if (error == RecoverError.NoError) {
1309             return; // no error: do nothing
1310         } else if (error == RecoverError.InvalidSignature) {
1311             revert("ECDSA: invalid signature");
1312         } else if (error == RecoverError.InvalidSignatureLength) {
1313             revert("ECDSA: invalid signature length");
1314         } else if (error == RecoverError.InvalidSignatureS) {
1315             revert("ECDSA: invalid signature 's' value");
1316         } else if (error == RecoverError.InvalidSignatureV) {
1317             revert("ECDSA: invalid signature 'v' value");
1318         }
1319     }
1320 
1321     /**
1322      * @dev Returns the address that signed a hashed message (`hash`) with
1323      * `signature` or error string. This address can then be used for verification purposes.
1324      *
1325      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1326      * this function rejects them by requiring the `s` value to be in the lower
1327      * half order, and the `v` value to be either 27 or 28.
1328      *
1329      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1330      * verification to be secure: it is possible to craft signatures that
1331      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1332      * this is by receiving a hash of the original message (which may otherwise
1333      * be too long), and then calling {toEthSignedMessageHash} on it.
1334      *
1335      * Documentation for signature generation:
1336      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1337      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1338      *
1339      * _Available since v4.3._
1340      */
1341     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1342         // Check the signature length
1343         // - case 65: r,s,v signature (standard)
1344         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1345         if (signature.length == 65) {
1346             bytes32 r;
1347             bytes32 s;
1348             uint8 v;
1349             // ecrecover takes the signature parameters, and the only way to get them
1350             // currently is to use assembly.
1351             assembly {
1352                 r := mload(add(signature, 0x20))
1353                 s := mload(add(signature, 0x40))
1354                 v := byte(0, mload(add(signature, 0x60)))
1355             }
1356             return tryRecover(hash, v, r, s);
1357         } else if (signature.length == 64) {
1358             bytes32 r;
1359             bytes32 vs;
1360             // ecrecover takes the signature parameters, and the only way to get them
1361             // currently is to use assembly.
1362             assembly {
1363                 r := mload(add(signature, 0x20))
1364                 vs := mload(add(signature, 0x40))
1365             }
1366             return tryRecover(hash, r, vs);
1367         } else {
1368             return (address(0), RecoverError.InvalidSignatureLength);
1369         }
1370     }
1371 
1372     /**
1373      * @dev Returns the address that signed a hashed message (`hash`) with
1374      * `signature`. This address can then be used for verification purposes.
1375      *
1376      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1377      * this function rejects them by requiring the `s` value to be in the lower
1378      * half order, and the `v` value to be either 27 or 28.
1379      *
1380      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1381      * verification to be secure: it is possible to craft signatures that
1382      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1383      * this is by receiving a hash of the original message (which may otherwise
1384      * be too long), and then calling {toEthSignedMessageHash} on it.
1385      */
1386     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1387         (address recovered, RecoverError error) = tryRecover(hash, signature);
1388         _throwError(error);
1389         return recovered;
1390     }
1391 
1392     /**
1393      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1394      *
1395      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1396      *
1397      * _Available since v4.3._
1398      */
1399     function tryRecover(
1400         bytes32 hash,
1401         bytes32 r,
1402         bytes32 vs
1403     ) internal pure returns (address, RecoverError) {
1404         bytes32 s;
1405         uint8 v;
1406         assembly {
1407             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1408             v := add(shr(255, vs), 27)
1409         }
1410         return tryRecover(hash, v, r, s);
1411     }
1412 
1413     /**
1414      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1415      *
1416      * _Available since v4.2._
1417      */
1418     function recover(
1419         bytes32 hash,
1420         bytes32 r,
1421         bytes32 vs
1422     ) internal pure returns (address) {
1423         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1424         _throwError(error);
1425         return recovered;
1426     }
1427 
1428     /**
1429      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1430      * `r` and `s` signature fields separately.
1431      *
1432      * _Available since v4.3._
1433      */
1434     function tryRecover(
1435         bytes32 hash,
1436         uint8 v,
1437         bytes32 r,
1438         bytes32 s
1439     ) internal pure returns (address, RecoverError) {
1440         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1441         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1442         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1443         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1444         //
1445         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1446         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1447         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1448         // these malleable signatures as well.
1449         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1450             return (address(0), RecoverError.InvalidSignatureS);
1451         }
1452         if (v != 27 && v != 28) {
1453             return (address(0), RecoverError.InvalidSignatureV);
1454         }
1455 
1456         // If the signature is valid (and not malleable), return the signer address
1457         address signer = ecrecover(hash, v, r, s);
1458         if (signer == address(0)) {
1459             return (address(0), RecoverError.InvalidSignature);
1460         }
1461 
1462         return (signer, RecoverError.NoError);
1463     }
1464 
1465     /**
1466      * @dev Overload of {ECDSA-recover} that receives the `v`,
1467      * `r` and `s` signature fields separately.
1468      */
1469     function recover(
1470         bytes32 hash,
1471         uint8 v,
1472         bytes32 r,
1473         bytes32 s
1474     ) internal pure returns (address) {
1475         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1476         _throwError(error);
1477         return recovered;
1478     }
1479 
1480     /**
1481      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1482      * produces hash corresponding to the one signed with the
1483      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1484      * JSON-RPC method as part of EIP-191.
1485      *
1486      * See {recover}.
1487      */
1488     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1489         // 32 is the length in bytes of hash,
1490         // enforced by the type signature above
1491         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1492     }
1493 
1494     /**
1495      * @dev Returns an Ethereum Signed Typed Data, created from a
1496      * `domainSeparator` and a `structHash`. This produces hash corresponding
1497      * to the one signed with the
1498      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1499      * JSON-RPC method as part of EIP-712.
1500      *
1501      * See {recover}.
1502      */
1503     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1504         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1505     }
1506 }
1507 
1508 
1509 // File: PangaensTheGenesis.sol
1510 
1511 /**
1512  * @dev Contract to mint the Pangaens The Genesis NFT collection.
1513  *
1514  * The contract allows user to mint during both presale and the public sale
1515  *
1516  */
1517 contract PangaensTheGenesis is ERC721Enumerable, Ownable, ReentrancyGuard {
1518     using Strings for uint256;
1519     using ECDSA for bytes32;
1520 
1521     // Mint constants
1522     uint256 public presaleCost = 0.05 ether;
1523     uint256 public publicSaleCost = 0.06 ether;
1524     uint256 public maxSupply = 8900;
1525     uint256 public specialMintMaxSupply = 200;
1526     uint256 public publicSaleMaxMintPerTx = 20;
1527     uint256 public presaleMaxMint = 10;
1528     
1529     // Mint flags
1530     bool public isPresaleActive = false;
1531     bool public isPublicSaleActive = false;
1532     bool public revealed = false;
1533     
1534     // URI for presale and public mint
1535     string private baseURI;
1536     string private preRevealURI;
1537     
1538     // Mapping presale mint address. Allows presale mint only once
1539     mapping (address => bool) private presaleClaimed; 
1540     
1541     // Presale signer address to verify WL
1542     address private presaleSigner; 
1543 
1544     /**
1545      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1546      * Sets the baseURI, preRevealedURI & presaleSigner values to be used in the contract
1547      * 
1548      */
1549     constructor(
1550         string memory _name,
1551         string memory _symbol,
1552         string memory _initBaseURI,
1553         string memory _initPreRevealURI,
1554         address _initPresaleSigner
1555     ) ERC721(_name, _symbol) {
1556         setBaseURI(_initBaseURI);
1557         setPreRevealURI(_initPreRevealURI);
1558         setPresaleSigner(_initPresaleSigner);
1559     }
1560   
1561     /**
1562      * @dev Public sale mint
1563      * 
1564      * @param _mintAmount Number of tokens to mint.
1565      */
1566     function mintPublicSale(
1567         uint256 _mintAmount
1568     ) external nonReentrant payable {
1569         require(isPublicSaleActive, "Sale is not active");
1570         require(_mintAmount > 0, "Must mint at least 1 NFT");
1571         require(_mintAmount <= publicSaleMaxMintPerTx, "Mint count exceeds limit for public sale");
1572         require((publicSaleCost * _mintAmount) <= msg.value, "ETH sent does not match required payment");
1573         
1574         // Mint
1575         _mintToUser(msg.sender, _mintAmount, maxSupply);
1576     }
1577     
1578     /**
1579      * @dev Presale mint
1580      * 
1581      * @param _hashMessage Must be a valid hash message.
1582      * @param _signature Must be a valid signature.
1583      * @param _mintAmount Number of tokens to mint.
1584      */
1585     function mintPresale(
1586         bytes32 _hashMessage, 
1587         bytes memory _signature,
1588         uint256 _mintAmount
1589     ) external nonReentrant payable {
1590         require(isPresaleActive, "Presale not active");
1591         require(!isPublicSaleActive, "Cannot mint while main sale is active");
1592         require(_mintAmount > 0, "Must mint at least 1 NFT");
1593         require(_mintAmount <= presaleMaxMint, "Mint count exceeds limit for presale");
1594         require((presaleCost * _mintAmount) <= msg.value, "ETH sent does not match required payment");
1595         require(!presaleClaimed[msg.sender], "User already minted in the presale with this address");
1596            
1597         // Verify signature
1598         require(_verifySigner(_hashMessage, _signature), "Invalid signature");
1599         
1600         // Verify hash sent is for the given sender address
1601         require(_verifyHash(_hashMessage, msg.sender), "Invalid hash for address");
1602 
1603         // Mint
1604         _mintToUser(msg.sender, _mintAmount, maxSupply);
1605         
1606         //Adds the user to the presale claimed map
1607         presaleClaimed[msg.sender] = true;
1608     }
1609     
1610     /**
1611      * @dev Verify signature sent is valid
1612      */
1613     function _verifySigner(bytes32 _hashMessage, bytes memory _signature) private view returns (bool) {
1614         return _hashMessage.recover(_signature) == presaleSigner;
1615     }
1616     
1617     /**
1618      * @dev Verify hash sent is for the user address
1619      */
1620     function _verifyHash(bytes32 hash, address _user) private pure returns(bool){
1621         return hash == keccak256(abi.encodePacked(_user)).toEthSignedMessageHash();
1622     }
1623     
1624     /**
1625      * @dev Mints to the given recipient. Internal mint function
1626      */
1627     function _mintToUser(address recipient, uint256 _mintAmount, uint256 maxMintSupply) private {
1628         uint256 supply = totalSupply();
1629         require(supply + _mintAmount <= maxMintSupply, "Cannot mint more than available");
1630     
1631         for (uint256 i = 1; i <= _mintAmount; i++) {
1632             _safeMint(recipient, supply + i);
1633         }
1634     } 
1635     
1636     /**
1637      * @dev Returns the baseURI
1638      */
1639     function _baseURI() internal view virtual override returns (string memory) {
1640         return baseURI;
1641     }
1642 
1643     /**
1644      * @dev Overrides the tokenURI method
1645      * 
1646      * @param tokenId ID of the token
1647      * @return string preRevealURI if not revealed else baseURI 
1648      */
1649     function tokenURI(uint256 tokenId)
1650         public
1651         view
1652         virtual
1653         override
1654         returns (string memory)
1655     {
1656         require(
1657           _exists(tokenId),
1658           "ERC721Metadata: URI query for nonexistent token"
1659         );
1660     
1661         if(!revealed) {
1662             return preRevealURI;
1663         }
1664  
1665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1666     }
1667     
1668     
1669     /**
1670      * @dev Mint for giveaways. Used by onlyOwner 
1671      * 
1672      * @param _user Recipient user address
1673      * @param _mintAmount Number of tokens to mint
1674      */
1675     function specialMint(address _user, uint256 _mintAmount) external onlyOwner {
1676         require(_mintAmount > 0, "Must mint at least 1 NFT");
1677         
1678         // Mint
1679         _mintToUser(_user, _mintAmount, specialMintMaxSupply);
1680     }
1681     
1682     /**
1683      * @dev Allows to enable/disable public sale minting
1684      */
1685     function togglePublicSaleState() external onlyOwner {
1686         isPublicSaleActive = !isPublicSaleActive;
1687     }
1688     
1689     /**
1690      * @dev Allows to enable/disable presale minting
1691      */
1692     function togglePresaleState() external onlyOwner {
1693         isPresaleActive = !isPresaleActive;
1694     }
1695     
1696     /**
1697      * @dev Sets the new preRevealURI
1698      */
1699     function setPreRevealURI(string memory _newPreRevealURI) public onlyOwner {
1700         preRevealURI = _newPreRevealURI;
1701     }
1702   
1703     /**
1704      * @dev Sets the revealed flag
1705      */
1706     function reveal(bool _state) public onlyOwner {
1707         revealed = _state;
1708     }
1709   
1710     /**
1711      * @dev Sets the new baseURI
1712      */
1713     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1714         baseURI = _newBaseURI;
1715     }
1716 
1717     /**
1718      * @dev Sets the new cost for public sale
1719      */
1720     function setPublicSaleCost(uint256 _newCost) public onlyOwner() {
1721         publicSaleCost = _newCost;
1722     }
1723   
1724     /**
1725      * @dev Sets the new cost for presale
1726      */
1727     function setPresaleCost(uint256 _newCost) public onlyOwner() {
1728         presaleCost = _newCost;
1729     }
1730 
1731     /**
1732      * @dev Sets the new maximum mint amount per transaction for public sale
1733      */
1734     function setPublicSaleMaxMintPerTx(uint256 _newmaxMintAmount) public onlyOwner() {
1735         publicSaleMaxMintPerTx = _newmaxMintAmount;
1736     }
1737   
1738     /**
1739      * @dev Sets the new maximum mint amount for presale
1740      */
1741     function setPresaleMaxMint(uint256 _newmaxMintAmount) public onlyOwner() {
1742         presaleMaxMint = _newmaxMintAmount;
1743     }
1744  
1745     /**
1746      * @dev Sets a new signature verifier for presale
1747      */
1748     function setPresaleSigner(address _signer) public onlyOwner {
1749         presaleSigner = _signer;
1750     }
1751 
1752     /**
1753      * @dev Returns whether a user has claimed in the presale
1754      */ 
1755     function getPresaleClaimed(address _user) external view returns (bool) {
1756         return presaleClaimed[_user];
1757     }
1758 
1759     /**
1760      * @dev Withdraws the funds from the contract 
1761      */ 
1762     function withdraw() public payable onlyOwner {
1763        (bool success, ) =  payable(msg.sender).call{value:address(this).balance }("");
1764        require(success);
1765     }
1766 }