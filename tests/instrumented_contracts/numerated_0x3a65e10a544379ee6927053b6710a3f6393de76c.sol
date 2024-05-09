1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.3
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.3
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 
199 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.3
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
205  * @dev See https://eips.ethereum.org/EIPS/eip-721
206  */
207 interface IERC721Metadata is IERC721 {
208     /**
209      * @dev Returns the token collection name.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the token collection symbol.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
220      */
221     function tokenURI(uint256 tokenId) external view returns (string memory);
222 }
223 
224 
225 // File @openzeppelin/contracts/utils/Address.sol@v4.3.3
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 
443 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Provides information about the current execution context, including the
449  * sender of the transaction and its data. While these are generally available
450  * via msg.sender and msg.data, they should not be accessed in such a direct
451  * manner, since when dealing with meta-transactions the account sending and
452  * paying for execution may not be the actual sender (as far as an application
453  * is concerned).
454  *
455  * This contract is only required for intermediate, library-like contracts.
456  */
457 abstract contract Context {
458     function _msgSender() internal view virtual returns (address) {
459         return msg.sender;
460     }
461 
462     function _msgData() internal view virtual returns (bytes calldata) {
463         return msg.data;
464     }
465 }
466 
467 
468 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev String operations.
474  */
475 library Strings {
476     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
480      */
481     function toString(uint256 value) internal pure returns (string memory) {
482         // Inspired by OraclizeAPI's implementation - MIT licence
483         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
484 
485         if (value == 0) {
486             return "0";
487         }
488         uint256 temp = value;
489         uint256 digits;
490         while (temp != 0) {
491             digits++;
492             temp /= 10;
493         }
494         bytes memory buffer = new bytes(digits);
495         while (value != 0) {
496             digits -= 1;
497             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
498             value /= 10;
499         }
500         return string(buffer);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
505      */
506     function toHexString(uint256 value) internal pure returns (string memory) {
507         if (value == 0) {
508             return "0x00";
509         }
510         uint256 temp = value;
511         uint256 length = 0;
512         while (temp != 0) {
513             length++;
514             temp >>= 8;
515         }
516         return toHexString(value, length);
517     }
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
521      */
522     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
523         bytes memory buffer = new bytes(2 * length + 2);
524         buffer[0] = "0";
525         buffer[1] = "x";
526         for (uint256 i = 2 * length + 1; i > 1; --i) {
527             buffer[i] = _HEX_SYMBOLS[value & 0xf];
528             value >>= 4;
529         }
530         require(value == 0, "Strings: hex length insufficient");
531         return string(buffer);
532     }
533 }
534 
535 
536 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Implementation of the {IERC165} interface.
542  *
543  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
544  * for the additional interface id that will be supported. For example:
545  *
546  * ```solidity
547  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
549  * }
550  * ```
551  *
552  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
553  */
554 abstract contract ERC165 is IERC165 {
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         return interfaceId == type(IERC165).interfaceId;
560     }
561 }
562 
563 
564 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.3
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 
572 
573 
574 
575 /**
576  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
577  * the Metadata extension, but not including the Enumerable extension, which is available separately as
578  * {ERC721Enumerable}.
579  */
580 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
581     using Address for address;
582     using Strings for uint256;
583 
584     // Token name
585     string private _name;
586 
587     // Token symbol
588     string private _symbol;
589 
590     // Mapping from token ID to owner address
591     mapping(uint256 => address) private _owners;
592 
593     // Mapping owner address to token count
594     mapping(address => uint256) private _balances;
595 
596     // Mapping from token ID to approved address
597     mapping(uint256 => address) private _tokenApprovals;
598 
599     // Mapping from owner to operator approvals
600     mapping(address => mapping(address => bool)) private _operatorApprovals;
601 
602     /**
603      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
604      */
605     constructor(string memory name_, string memory symbol_) {
606         _name = name_;
607         _symbol = symbol_;
608     }
609 
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
614         return
615             interfaceId == type(IERC721).interfaceId ||
616             interfaceId == type(IERC721Metadata).interfaceId ||
617             super.supportsInterface(interfaceId);
618     }
619 
620     /**
621      * @dev See {IERC721-balanceOf}.
622      */
623     function balanceOf(address owner) public view virtual override returns (uint256) {
624         require(owner != address(0), "ERC721: balance query for the zero address");
625         return _balances[owner];
626     }
627 
628     /**
629      * @dev See {IERC721-ownerOf}.
630      */
631     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
632         address owner = _owners[tokenId];
633         require(owner != address(0), "ERC721: owner query for nonexistent token");
634         return owner;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-name}.
639      */
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-symbol}.
646      */
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-tokenURI}.
653      */
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
656 
657         string memory baseURI = _baseURI();
658         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
659     }
660 
661     /**
662      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
663      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
664      * by default, can be overriden in child contracts.
665      */
666     function _baseURI() internal view virtual returns (string memory) {
667         return "";
668     }
669 
670     /**
671      * @dev See {IERC721-approve}.
672      */
673     function approve(address to, uint256 tokenId) public virtual override {
674         address owner = ERC721.ownerOf(tokenId);
675         require(to != owner, "ERC721: approval to current owner");
676 
677         require(
678             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
679             "ERC721: approve caller is not owner nor approved for all"
680         );
681 
682         _approve(to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-getApproved}.
687      */
688     function getApproved(uint256 tokenId) public view virtual override returns (address) {
689         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
690 
691         return _tokenApprovals[tokenId];
692     }
693 
694     /**
695      * @dev See {IERC721-setApprovalForAll}.
696      */
697     function setApprovalForAll(address operator, bool approved) public virtual override {
698         require(operator != _msgSender(), "ERC721: approve to caller");
699 
700         _operatorApprovals[_msgSender()][operator] = approved;
701         emit ApprovalForAll(_msgSender(), operator, approved);
702     }
703 
704     /**
705      * @dev See {IERC721-isApprovedForAll}.
706      */
707     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
708         return _operatorApprovals[owner][operator];
709     }
710 
711     /**
712      * @dev See {IERC721-transferFrom}.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) public virtual override {
719         //solhint-disable-next-line max-line-length
720         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
721 
722         _transfer(from, to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-safeTransferFrom}.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public virtual override {
733         safeTransferFrom(from, to, tokenId, "");
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) public virtual override {
745         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
746         _safeTransfer(from, to, tokenId, _data);
747     }
748 
749     /**
750      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
751      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
752      *
753      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
754      *
755      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
756      * implement alternative mechanisms to perform token transfer, such as signature-based.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _safeTransfer(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) internal virtual {
773         _transfer(from, to, tokenId);
774         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
775     }
776 
777     /**
778      * @dev Returns whether `tokenId` exists.
779      *
780      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
781      *
782      * Tokens start existing when they are minted (`_mint`),
783      * and stop existing when they are burned (`_burn`).
784      */
785     function _exists(uint256 tokenId) internal view virtual returns (bool) {
786         return _owners[tokenId] != address(0);
787     }
788 
789     /**
790      * @dev Returns whether `spender` is allowed to manage `tokenId`.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
797         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
798         address owner = ERC721.ownerOf(tokenId);
799         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
800     }
801 
802     /**
803      * @dev Safely mints `tokenId` and transfers it to `to`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must not exist.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _safeMint(address to, uint256 tokenId) internal virtual {
813         _safeMint(to, tokenId, "");
814     }
815 
816     /**
817      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
818      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
819      */
820     function _safeMint(
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _mint(to, tokenId);
826         require(
827             _checkOnERC721Received(address(0), to, tokenId, _data),
828             "ERC721: transfer to non ERC721Receiver implementer"
829         );
830     }
831 
832     /**
833      * @dev Mints `tokenId` and transfers it to `to`.
834      *
835      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
836      *
837      * Requirements:
838      *
839      * - `tokenId` must not exist.
840      * - `to` cannot be the zero address.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _mint(address to, uint256 tokenId) internal virtual {
845         require(to != address(0), "ERC721: mint to the zero address");
846         require(!_exists(tokenId), "ERC721: token already minted");
847 
848         _beforeTokenTransfer(address(0), to, tokenId);
849 
850         _balances[to] += 1;
851         _owners[tokenId] = to;
852 
853         emit Transfer(address(0), to, tokenId);
854     }
855 
856     /**
857      * @dev Destroys `tokenId`.
858      * The approval is cleared when the token is burned.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _burn(uint256 tokenId) internal virtual {
867         address owner = ERC721.ownerOf(tokenId);
868 
869         _beforeTokenTransfer(owner, address(0), tokenId);
870 
871         // Clear approvals
872         _approve(address(0), tokenId);
873 
874         _balances[owner] -= 1;
875         delete _owners[tokenId];
876 
877         emit Transfer(owner, address(0), tokenId);
878     }
879 
880     /**
881      * @dev Transfers `tokenId` from `from` to `to`.
882      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
883      *
884      * Requirements:
885      *
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must be owned by `from`.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _transfer(
892         address from,
893         address to,
894         uint256 tokenId
895     ) internal virtual {
896         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
897         require(to != address(0), "ERC721: transfer to the zero address");
898 
899         _beforeTokenTransfer(from, to, tokenId);
900 
901         // Clear approvals from the previous owner
902         _approve(address(0), tokenId);
903 
904         _balances[from] -= 1;
905         _balances[to] += 1;
906         _owners[tokenId] = to;
907 
908         emit Transfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev Approve `to` to operate on `tokenId`
913      *
914      * Emits a {Approval} event.
915      */
916     function _approve(address to, uint256 tokenId) internal virtual {
917         _tokenApprovals[tokenId] = to;
918         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
919     }
920 
921     /**
922      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
923      * The call is not executed if the target address is not a contract.
924      *
925      * @param from address representing the previous owner of the given token ID
926      * @param to target address that will receive the tokens
927      * @param tokenId uint256 ID of the token to be transferred
928      * @param _data bytes optional data to send along with the call
929      * @return bool whether the call correctly returned the expected magic value
930      */
931     function _checkOnERC721Received(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) private returns (bool) {
937         if (to.isContract()) {
938             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
939                 return retval == IERC721Receiver.onERC721Received.selector;
940             } catch (bytes memory reason) {
941                 if (reason.length == 0) {
942                     revert("ERC721: transfer to non ERC721Receiver implementer");
943                 } else {
944                     assembly {
945                         revert(add(32, reason), mload(reason))
946                     }
947                 }
948             }
949         } else {
950             return true;
951         }
952     }
953 
954     /**
955      * @dev Hook that is called before any token transfer. This includes minting
956      * and burning.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` will be minted for `to`.
963      * - When `to` is zero, ``from``'s `tokenId` will be burned.
964      * - `from` and `to` are never both zero.
965      *
966      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
967      */
968     function _beforeTokenTransfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) internal virtual {}
973 }
974 
975 
976 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.3
977 
978 pragma solidity ^0.8.0;
979 
980 /**
981  * @dev Contract module which allows children to implement an emergency stop
982  * mechanism that can be triggered by an authorized account.
983  *
984  * This module is used through inheritance. It will make available the
985  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
986  * the functions of your contract. Note that they will not be pausable by
987  * simply including this module, only once the modifiers are put in place.
988  */
989 abstract contract Pausable is Context {
990     /**
991      * @dev Emitted when the pause is triggered by `account`.
992      */
993     event Paused(address account);
994 
995     /**
996      * @dev Emitted when the pause is lifted by `account`.
997      */
998     event Unpaused(address account);
999 
1000     bool private _paused;
1001 
1002     /**
1003      * @dev Initializes the contract in unpaused state.
1004      */
1005     constructor() {
1006         _paused = false;
1007     }
1008 
1009     /**
1010      * @dev Returns true if the contract is paused, and false otherwise.
1011      */
1012     function paused() public view virtual returns (bool) {
1013         return _paused;
1014     }
1015 
1016     /**
1017      * @dev Modifier to make a function callable only when the contract is not paused.
1018      *
1019      * Requirements:
1020      *
1021      * - The contract must not be paused.
1022      */
1023     modifier whenNotPaused() {
1024         require(!paused(), "Pausable: paused");
1025         _;
1026     }
1027 
1028     /**
1029      * @dev Modifier to make a function callable only when the contract is paused.
1030      *
1031      * Requirements:
1032      *
1033      * - The contract must be paused.
1034      */
1035     modifier whenPaused() {
1036         require(paused(), "Pausable: not paused");
1037         _;
1038     }
1039 
1040     /**
1041      * @dev Triggers stopped state.
1042      *
1043      * Requirements:
1044      *
1045      * - The contract must not be paused.
1046      */
1047     function _pause() internal virtual whenNotPaused {
1048         _paused = true;
1049         emit Paused(_msgSender());
1050     }
1051 
1052     /**
1053      * @dev Returns to normal state.
1054      *
1055      * Requirements:
1056      *
1057      * - The contract must be paused.
1058      */
1059     function _unpause() internal virtual whenPaused {
1060         _paused = false;
1061         emit Unpaused(_msgSender());
1062     }
1063 }
1064 
1065 
1066 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.3
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 /**
1071  * @title Counters
1072  * @author Matt Condon (@shrugs)
1073  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1074  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1075  *
1076  * Include with `using Counters for Counters.Counter;`
1077  */
1078 library Counters {
1079     struct Counter {
1080         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1081         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1082         // this feature: see https://github.com/ethereum/solidity/issues/4637
1083         uint256 _value; // default: 0
1084     }
1085 
1086     function current(Counter storage counter) internal view returns (uint256) {
1087         return counter._value;
1088     }
1089 
1090     function increment(Counter storage counter) internal {
1091         unchecked {
1092             counter._value += 1;
1093         }
1094     }
1095 
1096     function decrement(Counter storage counter) internal {
1097         uint256 value = counter._value;
1098         require(value > 0, "Counter: decrement overflow");
1099         unchecked {
1100             counter._value = value - 1;
1101         }
1102     }
1103 
1104     function reset(Counter storage counter) internal {
1105         counter._value = 0;
1106     }
1107 }
1108 
1109 
1110 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 /**
1115  * @dev Contract module which provides a basic access control mechanism, where
1116  * there is an account (an owner) that can be granted exclusive access to
1117  * specific functions.
1118  *
1119  * By default, the owner account will be the one that deploys the contract. This
1120  * can later be changed with {transferOwnership}.
1121  *
1122  * This module is used through inheritance. It will make available the modifier
1123  * `onlyOwner`, which can be applied to your functions to restrict their use to
1124  * the owner.
1125  */
1126 abstract contract Ownable is Context {
1127     address private _owner;
1128 
1129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1130 
1131     /**
1132      * @dev Initializes the contract setting the deployer as the initial owner.
1133      */
1134     constructor() {
1135         _setOwner(_msgSender());
1136     }
1137 
1138     /**
1139      * @dev Returns the address of the current owner.
1140      */
1141     function owner() public view virtual returns (address) {
1142         return _owner;
1143     }
1144 
1145     /**
1146      * @dev Throws if called by any account other than the owner.
1147      */
1148     modifier onlyOwner() {
1149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1150         _;
1151     }
1152 
1153     /**
1154      * @dev Leaves the contract without owner. It will not be possible to call
1155      * `onlyOwner` functions anymore. Can only be called by the current owner.
1156      *
1157      * NOTE: Renouncing ownership will leave the contract without an owner,
1158      * thereby removing any functionality that is only available to the owner.
1159      */
1160     function renounceOwnership() public virtual onlyOwner {
1161         _setOwner(address(0));
1162     }
1163 
1164     /**
1165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1166      * Can only be called by the current owner.
1167      */
1168     function transferOwnership(address newOwner) public virtual onlyOwner {
1169         require(newOwner != address(0), "Ownable: new owner is the zero address");
1170         _setOwner(newOwner);
1171     }
1172 
1173     function _setOwner(address newOwner) private {
1174         address oldOwner = _owner;
1175         _owner = newOwner;
1176         emit OwnershipTransferred(oldOwner, newOwner);
1177     }
1178 }
1179 
1180 
1181 // File contracts/Flava.sol
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 
1187 
1188 contract Flava is ERC721, Pausable, Ownable {
1189     using Counters for Counters.Counter;
1190     using Strings for uint256;
1191 
1192     Counters.Counter private _tokenIds;
1193     
1194     string _baseTokenURI = 'https://api.flava.tools/api/metadata/';
1195 
1196     uint256 private _price = 0.39 ether;
1197     uint256 private _available_supply = 220;
1198     uint256 TOTAL_SUPPLY = 1000;
1199     uint256 private _founder_supply = 19;
1200     bool public onlyWhitelisted = false;
1201     address[] public whitelistedWallets;
1202 
1203     event Mint(address indexed _address, uint256 tokenId);
1204 
1205     constructor() ERC721("FlavaTools", "FLVA") {
1206         for (uint i = 0; i < _founder_supply; i++) {
1207             _safeMint(msg.sender);
1208         }
1209     }
1210 
1211     function mint() whenNotPaused public payable {
1212         if(onlyWhitelisted == true && msg.sender != owner()) {
1213             require(isWhitelisted(msg.sender), "Wallet is not whitelisted");
1214         }
1215         
1216         require(_tokenIds.current() < _available_supply, "Can't mint over supply limit");
1217 
1218         if (msg.sender != owner()) {
1219             require(msg.value == _price, "Wrong amount sent");
1220             require(balanceOf(msg.sender) == 0, "Can only mint one membership per wallet");
1221         }
1222         
1223         _safeMint(msg.sender);
1224         emit Mint(msg.sender, _tokenIds.current());
1225     }
1226 
1227     function isWhitelisted(address wallet) public view returns (bool) {
1228         for (uint i = 0; i < whitelistedWallets.length; i++) {
1229             if (whitelistedWallets[i] == wallet) {
1230                 return true;
1231             }
1232         }   
1233         return false;
1234     }
1235 
1236     function setOnlyWhitelisted(bool _state) public onlyOwner {
1237         onlyWhitelisted = _state;
1238     }
1239 
1240     function setWhitelistWallets(address[] calldata addresses) public onlyOwner {
1241         delete whitelistedWallets;
1242         whitelistedWallets = addresses;
1243     }
1244 
1245 
1246     function getWhitelistedWallets() public view onlyOwner returns (address[] memory) {
1247         return whitelistedWallets;
1248     }
1249 
1250 
1251     function getBalance() public view returns(uint) {
1252         return address(this).balance;
1253     }
1254 
1255     function getPrice() public view returns (uint256) {
1256         return _price;
1257     }
1258 
1259     function setPrice(uint256 price) public onlyOwner {
1260         _price = price;
1261     }
1262 
1263     function getAvailableSupply() public view returns (uint256) {
1264         return _available_supply;
1265     }
1266 
1267     function setAvailableSupply(uint256 available_supply) public onlyOwner {
1268         _available_supply = available_supply;
1269     }
1270 
1271     function withdraw() public onlyOwner {
1272         uint balance = address(this).balance;
1273         
1274         payable(msg.sender).transfer(balance);
1275     }
1276 
1277     function _baseURI() internal override view returns (string memory) {
1278         return _baseTokenURI;
1279     }
1280 
1281     function setBaseURI(string memory baseURI) public onlyOwner {
1282         _baseTokenURI = baseURI;
1283     }
1284 
1285     function _safeMint(address buyer) internal {
1286         _tokenIds.increment();
1287         _safeMint(buyer, _tokenIds.current());
1288     }
1289 
1290     function pause() public onlyOwner whenNotPaused {
1291         _pause();
1292     }
1293 
1294     function unpause()  public onlyOwner whenPaused {
1295         _unpause();
1296     }
1297 
1298     function totalSupply() view public returns (uint256){
1299         return _tokenIds.current();
1300     }
1301 }