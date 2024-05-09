1 // SPDX-License-Identifier: MIT
2 
3 // Amended by AyyyliensNFT
4 /**
5     
6 */
7 
8 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
9 pragma solidity ^0.8.0;
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
32 pragma solidity ^0.8.0;
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 
171 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
172 pragma solidity ^0.8.0;
173 /**
174  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
175  * @dev See https://eips.ethereum.org/EIPS/eip-721
176  */
177 interface IERC721Enumerable is IERC721 {
178     /**
179      * @dev Returns the total amount of tokens stored by the contract.
180      */
181     function totalSupply() external view returns (uint256);
182 
183     /**
184      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
185      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
186      */
187     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
188 
189     /**
190      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
191      * Use along with {totalSupply} to enumerate all tokens.
192      */
193     function tokenByIndex(uint256 index) external view returns (uint256);
194 }
195 
196 
197 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
198 pragma solidity ^0.8.0;
199 /**
200  * @dev Implementation of the {IERC165} interface.
201  *
202  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
203  * for the additional interface id that will be supported. For example:
204  *
205  * ```solidity
206  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
207  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
208  * }
209  * ```
210  *
211  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
212  */
213 abstract contract ERC165 is IERC165 {
214     /**
215      * @dev See {IERC165-supportsInterface}.
216      */
217     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
218         return interfaceId == type(IERC165).interfaceId;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Strings.sol
223 
224 
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev String operations.
230  */
231 library Strings {
232     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
236      */
237     function toString(uint256 value) internal pure returns (string memory) {
238         // Inspired by OraclizeAPI's implementation - MIT licence
239         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
240 
241         if (value == 0) {
242             return "0";
243         }
244         uint256 temp = value;
245         uint256 digits;
246         while (temp != 0) {
247             digits++;
248             temp /= 10;
249         }
250         bytes memory buffer = new bytes(digits);
251         while (value != 0) {
252             digits -= 1;
253             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
254             value /= 10;
255         }
256         return string(buffer);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
261      */
262     function toHexString(uint256 value) internal pure returns (string memory) {
263         if (value == 0) {
264             return "0x00";
265         }
266         uint256 temp = value;
267         uint256 length = 0;
268         while (temp != 0) {
269             length++;
270             temp >>= 8;
271         }
272         return toHexString(value, length);
273     }
274 
275     /**
276      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
277      */
278     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
279         bytes memory buffer = new bytes(2 * length + 2);
280         buffer[0] = "0";
281         buffer[1] = "x";
282         for (uint256 i = 2 * length + 1; i > 1; --i) {
283             buffer[i] = _HEX_SYMBOLS[value & 0xf];
284             value >>= 4;
285         }
286         require(value == 0, "Strings: hex length insufficient");
287         return string(buffer);
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/Address.sol
292 
293 
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         assembly {
325             size := extcodesize(account)
326         }
327         return size > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain `call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(address(this).balance >= value, "Address: insufficient balance for call");
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
511 
512 
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Metadata is IERC721 {
522     /**
523      * @dev Returns the token collection name.
524      */
525     function name() external view returns (string memory);
526 
527     /**
528      * @dev Returns the token collection symbol.
529      */
530     function symbol() external view returns (string memory);
531 
532     /**
533      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
534      */
535     function tokenURI(uint256 tokenId) external view returns (string memory);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @title ERC721 token receiver interface
546  * @dev Interface for any contract that wants to support safeTransfers
547  * from ERC721 asset contracts.
548  */
549 interface IERC721Receiver {
550     /**
551      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
552      * by `operator` from `from`, this function is called.
553      *
554      * It must return its Solidity selector to confirm the token transfer.
555      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
556      *
557      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
558      */
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 // File: @openzeppelin/contracts/utils/Context.sol
568 pragma solidity ^0.8.0;
569 /**
570  * @dev Provides information about the current execution context, including the
571  * sender of the transaction and its data. While these are generally available
572  * via msg.sender and msg.data, they should not be accessed in such a direct
573  * manner, since when dealing with meta-transactions the account sending and
574  * paying for execution may not be the actual sender (as far as an application
575  * is concerned).
576  *
577  * This contract is only required for intermediate, library-like contracts.
578  */
579 abstract contract Context {
580     function _msgSender() internal view virtual returns (address) {
581         return msg.sender;
582     }
583 
584     function _msgData() internal view virtual returns (bytes calldata) {
585         return msg.data;
586     }
587 }
588 
589 
590 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
591 pragma solidity ^0.8.0;
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata extension, but not including the Enumerable extension, which is available separately as
595  * {ERC721Enumerable}.
596  */
597 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
598     using Address for address;
599     using Strings for uint256;
600 
601     // Token name
602     string private _name;
603 
604     // Token symbol
605     string private _symbol;
606 
607     // Mapping from token ID to owner address
608     mapping(uint256 => address) private _owners;
609 
610     // Mapping owner address to token count
611     mapping(address => uint256) private _balances;
612 
613     // Mapping from token ID to approved address
614     mapping(uint256 => address) private _tokenApprovals;
615 
616     // Mapping from owner to operator approvals
617     mapping(address => mapping(address => bool)) private _operatorApprovals;
618 
619     /**
620      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
621      */
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625     }
626 
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
631         return
632             interfaceId == type(IERC721).interfaceId ||
633             interfaceId == type(IERC721Metadata).interfaceId ||
634             super.supportsInterface(interfaceId);
635     }
636 
637     /**
638      * @dev See {IERC721-balanceOf}.
639      */
640     function balanceOf(address owner) public view virtual override returns (uint256) {
641         require(owner != address(0), "ERC721: balance query for the zero address");
642         return _balances[owner];
643     }
644 
645     /**
646      * @dev See {IERC721-ownerOf}.
647      */
648     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
649         address owner = _owners[tokenId];
650         require(owner != address(0), "ERC721: owner query for nonexistent token");
651         return owner;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-name}.
656      */
657     function name() public view virtual override returns (string memory) {
658         return _name;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-symbol}.
663      */
664     function symbol() public view virtual override returns (string memory) {
665         return _symbol;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-tokenURI}.
670      */
671     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
672         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
673 
674         string memory baseURI = _baseURI();
675         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
676     }
677 
678     /**
679      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
680      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
681      * by default, can be overriden in child contracts.
682      */
683     function _baseURI() internal view virtual returns (string memory) {
684         return "";
685     }
686 
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public virtual override {
691         address owner = ERC721.ownerOf(tokenId);
692         require(to != owner, "ERC721: approval to current owner");
693 
694         require(
695             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
696             "ERC721: approve caller is not owner nor approved for all"
697         );
698 
699         _approve(to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-getApproved}.
704      */
705     function getApproved(uint256 tokenId) public view virtual override returns (address) {
706         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev See {IERC721-setApprovalForAll}.
713      */
714     function setApprovalForAll(address operator, bool approved) public virtual override {
715         require(operator != _msgSender(), "ERC721: approve to caller");
716 
717         _operatorApprovals[_msgSender()][operator] = approved;
718         emit ApprovalForAll(_msgSender(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
725         return _operatorApprovals[owner][operator];
726     }
727 
728     /**
729      * @dev See {IERC721-transferFrom}.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         //solhint-disable-next-line max-line-length
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738 
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, "");
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763         _safeTransfer(from, to, tokenId, _data);
764     }
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
771      *
772      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
773      * implement alternative mechanisms to perform token transfer, such as signature-based.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeTransfer(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes memory _data
789     ) internal virtual {
790         _transfer(from, to, tokenId);
791         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted (`_mint`),
800      * and stop existing when they are burned (`_burn`).
801      */
802     function _exists(uint256 tokenId) internal view virtual returns (bool) {
803         return _owners[tokenId] != address(0);
804     }
805 
806     /**
807      * @dev Returns whether `spender` is allowed to manage `tokenId`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
814         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
815         address owner = ERC721.ownerOf(tokenId);
816         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
817     }
818 
819     /**
820      * @dev Safely mints `tokenId` and transfers it to `to`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(address to, uint256 tokenId) internal virtual {
830         _safeMint(to, tokenId, "");
831     }
832 
833     /**
834      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
835      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
836      */
837     function _safeMint(
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) internal virtual {
842         _mint(to, tokenId);
843         require(
844             _checkOnERC721Received(address(0), to, tokenId, _data),
845             "ERC721: transfer to non ERC721Receiver implementer"
846         );
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(address(0), to, tokenId);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId) internal virtual {
884         address owner = ERC721.ownerOf(tokenId);
885 
886         _beforeTokenTransfer(owner, address(0), tokenId);
887 
888         // Clear approvals
889         _approve(address(0), tokenId);
890 
891         _balances[owner] -= 1;
892         delete _owners[tokenId];
893 
894         emit Transfer(owner, address(0), tokenId);
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _transfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
940      * The call is not executed if the target address is not a contract.
941      *
942      * @param from address representing the previous owner of the given token ID
943      * @param to target address that will receive the tokens
944      * @param tokenId uint256 ID of the token to be transferred
945      * @param _data bytes optional data to send along with the call
946      * @return bool whether the call correctly returned the expected magic value
947      */
948     function _checkOnERC721Received(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) private returns (bool) {
954         if (to.isContract()) {
955             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
956                 return retval == IERC721Receiver.onERC721Received.selector;
957             } catch (bytes memory reason) {
958                 if (reason.length == 0) {
959                     revert("ERC721: transfer to non ERC721Receiver implementer");
960                 } else {
961                     assembly {
962                         revert(add(32, reason), mload(reason))
963                     }
964                 }
965             }
966         } else {
967             return true;
968         }
969     }
970 
971     /**
972      * @dev Hook that is called before any token transfer. This includes minting
973      * and burning.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` will be minted for `to`.
980      * - When `to` is zero, ``from``'s `tokenId` will be burned.
981      * - `from` and `to` are never both zero.
982      *
983      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
984      */
985     function _beforeTokenTransfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) internal virtual {}
990 }
991 
992 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
993 
994 
995 
996 pragma solidity ^0.8.0;
997 
998 
999 
1000 /**
1001  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1002  * enumerability of all the token ids in the contract as well as all token ids owned by each
1003  * account.
1004  */
1005 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1006     // Mapping from owner to list of owned token IDs
1007     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1008 
1009     // Mapping from token ID to index of the owner tokens list
1010     mapping(uint256 => uint256) private _ownedTokensIndex;
1011 
1012     // Array with all token ids, used for enumeration
1013     uint256[] private _allTokens;
1014 
1015     // Mapping from token id to position in the allTokens array
1016     mapping(uint256 => uint256) private _allTokensIndex;
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1022         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1029         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1030         return _ownedTokens[owner][index];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-totalSupply}.
1035      */
1036     function totalSupply() public view virtual override returns (uint256) {
1037         return _allTokens.length;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenByIndex}.
1042      */
1043     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1045         return _allTokens[index];
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` cannot be the zero address.
1059      * - `to` cannot be the zero address.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual override {
1068         super._beforeTokenTransfer(from, to, tokenId);
1069 
1070         if (from == address(0)) {
1071             _addTokenToAllTokensEnumeration(tokenId);
1072         } else if (from != to) {
1073             _removeTokenFromOwnerEnumeration(from, tokenId);
1074         }
1075         if (to == address(0)) {
1076             _removeTokenFromAllTokensEnumeration(tokenId);
1077         } else if (to != from) {
1078             _addTokenToOwnerEnumeration(to, tokenId);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1084      * @param to address representing the new owner of the given token ID
1085      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1086      */
1087     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1088         uint256 length = ERC721.balanceOf(to);
1089         _ownedTokens[to][length] = tokenId;
1090         _ownedTokensIndex[tokenId] = length;
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's token tracking data structures.
1095      * @param tokenId uint256 ID of the token to be added to the tokens list
1096      */
1097     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1098         _allTokensIndex[tokenId] = _allTokens.length;
1099         _allTokens.push(tokenId);
1100     }
1101 
1102     /**
1103      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1104      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1105      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1106      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1107      * @param from address representing the previous owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1109      */
1110     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1111         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1112         // then delete the last slot (swap and pop).
1113 
1114         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1115         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1116 
1117         // When the token to delete is the last token, the swap operation is unnecessary
1118         if (tokenIndex != lastTokenIndex) {
1119             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1120 
1121             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123         }
1124 
1125         // This also deletes the contents at the last position of the array
1126         delete _ownedTokensIndex[tokenId];
1127         delete _ownedTokens[from][lastTokenIndex];
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's token tracking data structures.
1132      * This has O(1) time complexity, but alters the order of the _allTokens array.
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list
1134      */
1135     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1136         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = _allTokens.length - 1;
1140         uint256 tokenIndex = _allTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1143         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1144         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1145         uint256 lastTokenId = _allTokens[lastTokenIndex];
1146 
1147         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _allTokensIndex[tokenId];
1152         _allTokens.pop();
1153     }
1154 }
1155 
1156 
1157 // File: @openzeppelin/contracts/access/Ownable.sol
1158 pragma solidity ^0.8.0;
1159 /**
1160  * @dev Contract module which provides a basic access control mechanism, where
1161  * there is an account (an owner) that can be granted exclusive access to
1162  * specific functions.
1163  *
1164  * By default, the owner account will be the one that deploys the contract. This
1165  * can later be changed with {transferOwnership}.
1166  *
1167  * This module is used through inheritance. It will make available the modifier
1168  * `onlyOwner`, which can be applied to your functions to restrict their use to
1169  * the owner.
1170  */
1171 abstract contract Ownable is Context {
1172     address private _owner;
1173 
1174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1175 
1176     /**
1177      * @dev Initializes the contract setting the deployer as the initial owner.
1178      */
1179     constructor() {
1180         _setOwner(_msgSender());
1181     }
1182 
1183     /**
1184      * @dev Returns the address of the current owner.
1185      */
1186     function owner() public view virtual returns (address) {
1187         return _owner;
1188     }
1189 
1190     /**
1191      * @dev Throws if called by any account other than the owner.
1192      */
1193     modifier onlyOwner() {
1194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1195         _;
1196     }
1197 
1198     /**
1199      * @dev Leaves the contract without owner. It will not be possible to call
1200      * `onlyOwner` functions anymore. Can only be called by the current owner.
1201      *
1202      * NOTE: Renouncing ownership will leave the contract without an owner,
1203      * thereby removing any functionality that is only available to the owner.
1204      */
1205     function renounceOwnership() public virtual onlyOwner {
1206         _setOwner(address(0));
1207     }
1208 
1209     /**
1210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1211      * Can only be called by the current owner.
1212      */
1213     function transferOwnership(address newOwner) public virtual onlyOwner {
1214         require(newOwner != address(0), "Ownable: new owner is the zero address");
1215         _setOwner(newOwner);
1216     }
1217 
1218     function _setOwner(address newOwner) private {
1219         address oldOwner = _owner;
1220         _owner = newOwner;
1221         emit OwnershipTransferred(oldOwner, newOwner);
1222     }
1223 }
1224 
1225 pragma solidity >=0.7.0 <0.9.0;
1226 
1227 contract Ayyyliens is ERC721Enumerable, Ownable {
1228   using Strings for uint256;
1229 
1230   string baseURI;
1231   string public baseExtension = ".json";
1232   uint256 public cost = 0.02 ether;
1233   uint256 public maxSupply = 5000;
1234   uint256 public maxMintAmount = 10;
1235   bool public paused = false;
1236   bool public revealed = false;
1237   string public notRevealedUri;
1238 
1239   constructor(
1240     string memory _name,
1241     string memory _symbol,
1242     string memory _initBaseURI,
1243     string memory _initNotRevealedUri
1244   ) ERC721(_name, _symbol) {
1245     setBaseURI(_initBaseURI);
1246     setNotRevealedURI(_initNotRevealedUri);
1247   }
1248 
1249   // internal
1250   function _baseURI() internal view virtual override returns (string memory) {
1251     return baseURI;
1252   }
1253 
1254   // public
1255   function mint(uint256 _mintAmount) public payable {
1256     uint256 supply = totalSupply();
1257     require(!paused);
1258     require(_mintAmount > 0);
1259     require(_mintAmount <= maxMintAmount);
1260     require(supply + _mintAmount <= maxSupply);
1261 
1262     if (msg.sender != owner()) {
1263       require(msg.value >= cost * _mintAmount);
1264     }
1265 
1266     for (uint256 i = 1; i <= _mintAmount; i++) {
1267       _safeMint(msg.sender, supply + i);
1268     }
1269   }
1270 
1271   function walletOfOwner(address _owner)
1272     public
1273     view
1274     returns (uint256[] memory)
1275   {
1276     uint256 ownerTokenCount = balanceOf(_owner);
1277     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1278     for (uint256 i; i < ownerTokenCount; i++) {
1279       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1280     }
1281     return tokenIds;
1282   }
1283 
1284   function tokenURI(uint256 tokenId)
1285     public
1286     view
1287     virtual
1288     override
1289     returns (string memory)
1290   {
1291     require(
1292       _exists(tokenId),
1293       "ERC721Metadata: URI query for nonexistent token"
1294     );
1295     
1296     if(revealed == false) {
1297         return notRevealedUri;
1298     }
1299 
1300     string memory currentBaseURI = _baseURI();
1301     return bytes(currentBaseURI).length > 0
1302         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1303         : "";
1304   }
1305 
1306   //only owner
1307   function reveal() public onlyOwner() {
1308       revealed = true;
1309   }
1310   
1311   function setCost(uint256 _newCost) public onlyOwner() {
1312     cost = _newCost;
1313   }
1314 
1315   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1316     maxMintAmount = _newmaxMintAmount;
1317   }
1318   
1319   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1320     notRevealedUri = _notRevealedURI;
1321   }
1322 
1323   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1324     baseURI = _newBaseURI;
1325   }
1326 
1327   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1328     baseExtension = _newBaseExtension;
1329   }
1330 
1331   function pause(bool _state) public onlyOwner {
1332     paused = _state;
1333   }
1334  
1335   function withdraw() public payable onlyOwner {
1336     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1337     require(success);
1338   }
1339 }