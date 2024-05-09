1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 /**
68  * @dev Provides information about the current execution context, including the
69  * sender of the transaction and its data. While these are generally available
70  * via msg.sender and msg.data, they should not be accessed in such a direct
71  * manner, since when dealing with meta-transactions the account sending and
72  * paying for execution may not be the actual sender (as far as an application
73  * is concerned).
74  *
75  * This contract is only required for intermediate, library-like contracts.
76  */
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize, which returns 0 for contracts in
110         // construction, since the code is only stored at the end of the
111         // constructor execution.
112 
113         uint256 size;
114         assembly {
115             size := extcodesize(account)
116         }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         (bool success, ) = recipient.call{value: amount}("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain `call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
167      * `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but also transferring `value` wei to `target`.
182      *
183      * Requirements:
184      *
185      * - the calling contract must have an ETH balance of at least `value`.
186      * - the called Solidity function must be `payable`.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
200      * with `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         require(isContract(target), "Address: delegate call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.delegatecall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
273      * revert reason using the provided one.
274      *
275      * _Available since v4.3._
276      */
277     function verifyCallResult(
278         bool success,
279         bytes memory returndata,
280         string memory errorMessage
281     ) internal pure returns (bytes memory) {
282         if (success) {
283             return returndata;
284         } else {
285             // Look for revert reason and bubble it up if present
286             if (returndata.length > 0) {
287                 // The easiest way to bubble the revert reason is using memory via assembly
288 
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 /**
324  * @dev Interface of the ERC165 standard, as defined in the
325  * https://eips.ethereum.org/EIPS/eip-165[EIP].
326  *
327  * Implementers can declare support of contract interfaces, which can then be
328  * queried by others ({ERC165Checker}).
329  *
330  * For an implementation, see {ERC165}.
331  */
332 interface IERC165 {
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 }
343 
344 /**
345  * @dev Implementation of the {IERC165} interface.
346  *
347  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
348  * for the additional interface id that will be supported. For example:
349  *
350  * ```solidity
351  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
353  * }
354  * ```
355  *
356  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
357  */
358 abstract contract ERC165 is IERC165 {
359     /**
360      * @dev See {IERC165-supportsInterface}.
361      */
362     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
363         return interfaceId == type(IERC165).interfaceId;
364     }
365 }
366 
367 /**
368  * @dev Required interface of an ERC721 compliant contract.
369  */
370 interface IERC721 is IERC165 {
371     /**
372      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
375 
376     /**
377      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
378      */
379     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
383      */
384     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
385 
386     /**
387      * @dev Returns the number of tokens in ``owner``'s account.
388      */
389     function balanceOf(address owner) external view returns (uint256 balance);
390 
391     /**
392      * @dev Returns the owner of the `tokenId` token.
393      *
394      * Requirements:
395      *
396      * - `tokenId` must exist.
397      */
398     function ownerOf(uint256 tokenId) external view returns (address owner);
399 
400     /**
401      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
402      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Transfers `tokenId` token from `from` to `to`.
422      *
423      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Returns the account approved for `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function getApproved(uint256 tokenId) external view returns (address operator);
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId,
500         bytes calldata data
501     ) external;
502 }
503 
504 /**
505  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
506  * @dev See https://eips.ethereum.org/EIPS/eip-721
507  */
508 interface IERC721Metadata is IERC721 {
509     /**
510      * @dev Returns the token collection name.
511      */
512     function name() external view returns (string memory);
513 
514     /**
515      * @dev Returns the token collection symbol.
516      */
517     function symbol() external view returns (string memory);
518 
519     /**
520      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
521      */
522     function tokenURI(uint256 tokenId) external view returns (string memory);
523 }
524 
525 /**
526  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
527  * the Metadata extension, but not including the Enumerable extension, which is available separately as
528  * {ERC721Enumerable}.
529  */
530 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
531     using Address for address;
532     using Strings for uint256;
533 
534     // Token name
535     string private _name;
536 
537     // Token symbol
538     string private _symbol;
539 
540     // Mapping from token ID to owner address
541     mapping(uint256 => address) private _owners;
542 
543     // Mapping owner address to token count
544     mapping(address => uint256) private _balances;
545 
546     // Mapping from token ID to approved address
547     mapping(uint256 => address) private _tokenApprovals;
548 
549     // Mapping from owner to operator approvals
550     mapping(address => mapping(address => bool)) private _operatorApprovals;
551 
552     /**
553      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
554      */
555     constructor(string memory name_, string memory symbol_) {
556         _name = name_;
557         _symbol = symbol_;
558     }
559 
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
564         return
565             interfaceId == type(IERC721).interfaceId ||
566             interfaceId == type(IERC721Metadata).interfaceId ||
567             super.supportsInterface(interfaceId);
568     }
569 
570     /**
571      * @dev See {IERC721-balanceOf}.
572      */
573     function balanceOf(address owner) public view virtual override returns (uint256) {
574         require(owner != address(0), "ERC721: balance query for the zero address");
575         return _balances[owner];
576     }
577 
578     /**
579      * @dev See {IERC721-ownerOf}.
580      */
581     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
582         // address owner = _owners[tokenId];
583         // require(owner != address(0), "ERC721: owner query for nonexistent token");
584         // return owner;
585         return _owners[tokenId];
586     }
587 
588     /**
589      * @dev See {IERC721Metadata-name}.
590      */
591     function name() public view virtual override returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-symbol}.
597      */
598     function symbol() public view virtual override returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-tokenURI}.
604      */
605     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
606         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
607 
608         string memory baseURI = _baseURI();
609         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
610     }
611 
612     /**
613      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
614      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
615      * by default, can be overriden in child contracts.
616      */
617     function _baseURI() internal view virtual returns (string memory) {
618         return "";
619     }
620 
621     /**
622      * @dev See {IERC721-approve}.
623      */
624     function approve(address to, uint256 tokenId) public virtual override {
625         address owner = ERC721.ownerOf(tokenId);
626         require(to != owner, "ERC721: approval to current owner");
627 
628         require(
629             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
630             "ERC721: approve caller is not owner nor approved for all"
631         );
632 
633         _approve(to, tokenId);
634     }
635 
636     /**
637      * @dev See {IERC721-getApproved}.
638      */
639     function getApproved(uint256 tokenId) public view virtual override returns (address) {
640         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
641 
642         return _tokenApprovals[tokenId];
643     }
644 
645     /**
646      * @dev See {IERC721-setApprovalForAll}.
647      */
648     function setApprovalForAll(address operator, bool approved) public virtual override {
649         _setApprovalForAll(_msgSender(), operator, approved);
650     }
651 
652     /**
653      * @dev See {IERC721-isApprovedForAll}.
654      */
655     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
656         return _operatorApprovals[owner][operator];
657     }
658 
659     /**
660      * @dev See {IERC721-transferFrom}.
661      */
662     function transferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) public virtual override {
667         //solhint-disable-next-line max-line-length
668         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
669 
670         _transfer(from, to, tokenId);
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public virtual override {
681         safeTransferFrom(from, to, tokenId, "");
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) public virtual override {
693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
694         _safeTransfer(from, to, tokenId, _data);
695     }
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
699      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
700      *
701      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
702      *
703      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
704      * implement alternative mechanisms to perform token transfer, such as signature-based.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function _safeTransfer(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) internal virtual {
721         _transfer(from, to, tokenId);
722         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
723     }
724 
725     /**
726      * @dev Returns whether `tokenId` exists.
727      *
728      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
729      *
730      * Tokens start existing when they are minted (`_mint`),
731      * and stop existing when they are burned (`_burn`).
732      */
733     function _exists(uint256 tokenId) internal view virtual returns (bool) {
734         return _owners[tokenId] != address(0);
735     }
736 
737     /**
738      * @dev Returns whether `spender` is allowed to manage `tokenId`.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
745         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
746         address owner = ERC721.ownerOf(tokenId);
747         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
748     }
749 
750     /**
751      * @dev Safely mints `tokenId` and transfers it to `to`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must not exist.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _safeMint(address to, uint256 tokenId) internal virtual {
761         _safeMint(to, tokenId, "");
762     }
763 
764     /**
765      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
766      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
767      */
768     function _safeMint(
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) internal virtual {
773         _mint(to, tokenId);
774         require(
775             _checkOnERC721Received(address(0), to, tokenId, _data),
776             "ERC721: transfer to non ERC721Receiver implementer"
777         );
778     }
779 
780     /**
781      * @dev Mints `tokenId` and transfers it to `to`.
782      *
783      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
784      *
785      * Requirements:
786      *
787      * - `tokenId` must not exist.
788      * - `to` cannot be the zero address.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _mint(address to, uint256 tokenId) internal virtual {
793         require(to != address(0), "ERC721: mint to the zero address");
794         require(!_exists(tokenId), "ERC721: token already minted");
795 
796         _beforeTokenTransfer(address(0), to, tokenId);
797 
798         _balances[to] += 1;
799         _owners[tokenId] = to;
800 
801         emit Transfer(address(0), to, tokenId);
802     }
803 
804     /**
805      * @dev Destroys `tokenId`.
806      * The approval is cleared when the token is burned.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _burn(uint256 tokenId) internal virtual {
815         address owner = ERC721.ownerOf(tokenId);
816 
817         _beforeTokenTransfer(owner, address(0), tokenId);
818 
819         // Clear approvals
820         _approve(address(0), tokenId);
821 
822         _balances[owner] -= 1;
823         delete _owners[tokenId];
824 
825         emit Transfer(owner, address(0), tokenId);
826     }
827 
828     /**
829      * @dev Transfers `tokenId` from `from` to `to`.
830      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
831      *
832      * Requirements:
833      *
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _transfer(
840         address from,
841         address to,
842         uint256 tokenId
843     ) internal virtual {
844         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
845         require(to != address(0), "ERC721: transfer to the zero address");
846 
847         _beforeTokenTransfer(from, to, tokenId);
848 
849         // Clear approvals from the previous owner
850         _approve(address(0), tokenId);
851 
852         _balances[from] -= 1;
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev Approve `to` to operate on `tokenId`
861      *
862      * Emits a {Approval} event.
863      */
864     function _approve(address to, uint256 tokenId) internal virtual {
865         _tokenApprovals[tokenId] = to;
866         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
867     }
868 
869     /**
870      * @dev Approve `operator` to operate on all of `owner` tokens
871      *
872      * Emits a {ApprovalForAll} event.
873      */
874     function _setApprovalForAll(
875         address owner,
876         address operator,
877         bool approved
878     ) internal virtual {
879         require(owner != operator, "ERC721: approve to caller");
880         _operatorApprovals[owner][operator] = approved;
881         emit ApprovalForAll(owner, operator, approved);
882     }
883 
884     /**
885      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
886      * The call is not executed if the target address is not a contract.
887      *
888      * @param from address representing the previous owner of the given token ID
889      * @param to target address that will receive the tokens
890      * @param tokenId uint256 ID of the token to be transferred
891      * @param _data bytes optional data to send along with the call
892      * @return bool whether the call correctly returned the expected magic value
893      */
894     function _checkOnERC721Received(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes memory _data
899     ) private returns (bool) {
900         if (to.isContract()) {
901             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
902                 return retval == IERC721Receiver.onERC721Received.selector;
903             } catch (bytes memory reason) {
904                 if (reason.length == 0) {
905                     revert("ERC721: transfer to non ERC721Receiver implementer");
906                 } else {
907                     assembly {
908                         revert(add(32, reason), mload(reason))
909                     }
910                 }
911             }
912         } else {
913             return true;
914         }
915     }
916 
917     /**
918      * @dev Hook that is called before any token transfer. This includes minting
919      * and burning.
920      *
921      * Calling conditions:
922      *
923      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
924      * transferred to `to`.
925      * - When `from` is zero, `tokenId` will be minted for `to`.
926      * - When `to` is zero, ``from``'s `tokenId` will be burned.
927      * - `from` and `to` are never both zero.
928      *
929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
930      */
931     function _beforeTokenTransfer(
932         address from,
933         address to,
934         uint256 tokenId
935     ) internal virtual {}
936 }
937 
938 interface IERC20 {
939     function transferFrom(address from_, address to_, uint256 amount_) external;
940 }
941 // interface IERC721 {
942 //     function transferFrom(address from_, address to_, uint256 tokenId_) external;
943 // }
944 interface IERC1155 {
945     function safeTransferFrom(address from_, address to_, uint256 id_, uint256 amount_, bytes calldata data_) external;
946     function safeBatchTransferFrom(address from_, address to_, uint256[] calldata ids_, uint256[] calldata amounts_, bytes calldata data_) external;
947 }
948 
949 abstract contract ERCWithdrawable {
950     /*  All functions in this abstract contract are marked as internal because it should
951         generally be paired with ownable.
952         Virtual is for overwritability.
953     */
954     function _withdrawERC20(address contractAddress_, uint256 amount_) internal virtual {
955         IERC20(contractAddress_).transferFrom(address(this), msg.sender, amount_);
956     }
957     function _withdrawERC721(address contractAddress_, uint256 tokenId_) internal virtual {
958         IERC721(contractAddress_).transferFrom(address(this), msg.sender, tokenId_);
959     }
960     function _withdrawERC1155(address contractAddress_, uint256 tokenId_, uint256 amount_) internal virtual {
961         IERC1155(contractAddress_).safeTransferFrom(address(this), msg.sender, tokenId_, amount_, "");
962     }
963     function _withdrawERC1155Batch(address contractAddress_, uint256[] calldata ids_, uint256[] calldata amounts_) internal virtual {
964         IERC1155(contractAddress_).safeBatchTransferFrom(address(this), msg.sender, ids_, amounts_, "");
965     }
966 }
967 
968 // Open0x Ownable
969 abstract contract Ownable {
970     address public owner;
971     
972     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
973 
974     constructor() { owner = msg.sender; }
975 
976     modifier onlyOwner {
977         require(owner == msg.sender, "Ownable: caller is not the owner");
978         _;
979     }
980 
981     function _transferOwnership(address newOwner_) internal virtual {
982         address _oldOwner = owner;
983         owner = newOwner_;
984         emit OwnershipTransferred(_oldOwner, newOwner_);    
985     }
986 
987     function transferOwnership(address newOwner_) public virtual onlyOwner {
988         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
989         _transferOwnership(newOwner_);
990     }
991 
992     function renounceOwnership() public virtual onlyOwner {
993         _transferOwnership(address(0x0));
994     }
995 }
996 
997 abstract contract MerkleWhitelist {
998     bytes32 internal _merkleRoot;
999     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
1000         _merkleRoot = merkleRoot_;
1001     }
1002     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
1003         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1004         for (uint256 i = 0; i < proof_.length; i++) {
1005             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1006         }
1007         return _leaf == _merkleRoot;
1008     }
1009 }
1010 
1011 interface iRenderer {
1012     function tokenURI(uint256 tokenId_) external view returns (string memory);
1013 }
1014 
1015 interface iYield {
1016     function updateReward(address from_, address to_, uint256 tokenId_) external;
1017 }
1018 
1019 contract ZenApes is ERC721, MerkleWhitelist, Ownable, ERCWithdrawable {
1020     /*
1021         ZenApes by 0xInuarashi
1022         Discord: 0xInuarashi#1234
1023         Twitter: https://twitter.com/0xInuarashi
1024 
1025         Features: 
1026         Namable, Descripable (Send to Back-End) [/]
1027         Flexible Interface with ERC20 (Banana, Peel) [/]
1028         Uninstantiated Transfer Hook for Token Yield [/]
1029         Limit to 1 mint per address [/]
1030         Merkle Whitelisting [/]
1031         Public Sale [/]
1032     */
1033 
1034     // Constructor
1035     constructor() ERC721("ZenApe", "ZEN") {}
1036 
1037     // Project Constraints
1038     uint16 immutable public maxTokens = 5000;
1039     
1040     // General NFT Variables
1041     uint256 public mintPrice = 0.07 ether;
1042     uint256 public totalSupply;
1043 
1044     string internal baseTokenURI;
1045     string internal baseTokenURI_EXT;
1046 
1047     // Interfaces
1048     iYield public yieldToken;
1049     mapping(address => bool) public controllers;
1050 
1051     // Whitelist Mappings
1052     mapping(address => uint16) public addressToWhitelistMinted;
1053     mapping(address => uint16) public addressToPublicMinted;
1054 
1055     // Namable
1056     mapping(uint256 => string) public zenApeName;
1057     mapping(uint256 => string) public zenApeBio;
1058 
1059     // Events
1060     event Mint(address to_, uint256 tokenId_);
1061     event NameChange(uint256 tokenId_, string name_);
1062     event BioChange(uint256 tokenId_, string bio_);
1063 
1064     // Contract Governance
1065     function withdrawEther() external onlyOwner {
1066         payable(msg.sender).transfer(address(this).balance); }
1067     function setMintPrice(uint256 price_) external onlyOwner {
1068         mintPrice = price_; }
1069 
1070     // ERCWithdrawable
1071     function withdrawERC20(address contractAddress_, uint256 amount_) external onlyOwner {
1072         _withdrawERC20(contractAddress_, amount_);
1073     }
1074     function withdrawERC721(address contractAddress_, uint256 tokenId_) external onlyOwner {
1075         _withdrawERC721(contractAddress_, tokenId_);
1076     }
1077     function withdrawERC1155(address contractAddress_, uint256 tokenId_, uint256 amount_) external onlyOwner {
1078         _withdrawERC1155(contractAddress_, tokenId_, amount_);
1079     }
1080 
1081     // MerkleRoot
1082     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1083         _setMerkleRoot(merkleRoot_); }
1084 
1085     // // Time Setters
1086     // Whitelist Sale
1087     bool public whitelistSaleEnabled;
1088     uint256 public whitelistSaleTime;
1089     function setWhitelistSale(bool bool_, uint256 time_) external onlyOwner {
1090         whitelistSaleEnabled = bool_; whitelistSaleTime = time_; }
1091     modifier whitelistSale {
1092         require(whitelistSaleEnabled && block.timestamp >= whitelistSaleTime, "Whitelist sale not open yet!"); _; }
1093     function whitelistSaleIsEnabled() public view returns (bool) {
1094         return (whitelistSaleEnabled && block.timestamp >= whitelistSaleTime); }
1095 
1096     // Public Sale
1097     bool public publicSaleEnabled;
1098     uint256 public publicSaleTime;
1099     function setPublicSale(bool bool_, uint256 time_) external onlyOwner {
1100         publicSaleEnabled = bool_; publicSaleTime = time_; }
1101     modifier publicSale {
1102         require(publicSaleEnabled && block.timestamp >= publicSaleTime, "Public Sale is not open yet!"); _; }
1103     function publicSaleIsEnabled() public view returns (bool) {
1104         return (publicSaleEnabled && block.timestamp >= publicSaleTime); }
1105 
1106     // Modifiers
1107     modifier onlySender {
1108         require(msg.sender == tx.origin, "No smart contracts!"); _; }
1109     modifier onlyControllers {
1110         require(controllers[msg.sender], "You are not authorized!"); _; }
1111 
1112     // Contract Administration
1113     function setYieldToken(address address_) external onlyOwner {
1114         yieldToken = iYield(address_); }
1115     function setController(address address_, bool bool_) external onlyOwner {
1116         controllers[address_] = bool_; }
1117     function setBaseTokenURI(string memory uri_) external onlyOwner {
1118         baseTokenURI = uri_; }
1119     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
1120         baseTokenURI_EXT = ext_; }
1121     
1122     // Controller Functions
1123     function changeName(uint256 tokenId_, string memory name_) public onlyControllers {
1124         zenApeName[tokenId_] = name_; }
1125     function changeBio(uint256 tokenId_, string memory bio_) public onlyControllers {
1126         zenApeBio[tokenId_] = bio_; }
1127 
1128     // Mint functions
1129     function __getTokenId() internal view returns (uint256) {
1130         return totalSupply + 1;
1131     }
1132     function ownerMint(address to_, uint256 amount_) external onlyOwner {
1133         for (uint256 i = 0; i < amount_; i++) {
1134             _mint(to_, __getTokenId() + i);
1135         }
1136         totalSupply += amount_;
1137     }
1138     function ownerMintToMany(address[] memory tos_, uint256[] memory amounts_) external onlyOwner {
1139         require(tos_.length == amounts_.length, "Length mismatch!");
1140         // Iterate through each request
1141         for (uint256 i = 0; i < tos_.length; i++) {
1142             // Do ownerMint logic
1143             for (uint256 j = 0 ; j < amounts_[i]; j++) {
1144                 _mint(tos_[i], __getTokenId() + j);
1145             }
1146             totalSupply += amounts_[i];
1147         }
1148     }
1149     function whitelistMint(bytes32[] memory proof_) external payable onlySender whitelistSale {
1150         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1151         require(addressToWhitelistMinted[msg.sender] == 0, "You have no whitelist mints remaining!");
1152         require(msg.value == mintPrice, "Invalid Value Sent!");
1153         require(maxTokens > totalSupply, "No more remaining tokens!");
1154 
1155         addressToWhitelistMinted[msg.sender]++;
1156         totalSupply++;
1157 
1158         _mint(msg.sender, __getTokenId());
1159         emit Mint(msg.sender, __getTokenId());
1160     }
1161     function publicMint() external payable onlySender publicSale {
1162         require(addressToPublicMinted[msg.sender] < 2, "You have no public mints remaining!");
1163         require(msg.value == mintPrice, "Invalid value sent!");
1164         require(maxTokens > totalSupply, "No more remaining tokens!");
1165 
1166         addressToPublicMinted[msg.sender]++;
1167         totalSupply++;
1168 
1169         _mint(msg.sender, __getTokenId());
1170         emit Mint(msg.sender, __getTokenId());
1171     }
1172 
1173     // Transfer Hooks 
1174     function transferFrom(address from_, address to_, uint256 tokenId_) public override {
1175         if ( yieldToken != iYield(address(0x0)) ) {
1176             yieldToken.updateReward(from_, to_, tokenId_);
1177         }
1178         ERC721.transferFrom(from_, to_, tokenId_);
1179     }
1180     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public override {
1181         if ( yieldToken != iYield(address(0x0)) ) {
1182             yieldToken.updateReward(from_, to_, tokenId_);
1183         }
1184         ERC721.safeTransferFrom(from_, to_, tokenId_, data_);
1185     }
1186 
1187     // Those who know will know what this is... I'm just putting it here just in case ;)
1188     address public renderer;
1189     bool public useRenderer;
1190     function setRenderer(address address_) external onlyOwner { renderer = address_; }
1191     function setUseRenderer(bool bool_) external onlyOwner { useRenderer = bool_; }
1192 
1193     // View Function for Tokens
1194     function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1195         require(_exists(tokenId_), "Token doesn't exist!");
1196         if (!useRenderer) {
1197             return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId_), baseTokenURI_EXT));
1198         } else {
1199             return iRenderer(renderer).tokenURI(tokenId_);
1200         }
1201     }
1202 
1203     // 0xInuarashi Custom Functions for ERC721
1204     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public {
1205         for (uint256 i = 0; i < tokenIds_.length; i++) {
1206             ERC721.transferFrom(from_, to_, tokenIds_[i]);
1207         }
1208     }
1209     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes[] memory datas_) public {
1210         for (uint256 i = 0; i < tokenIds_.length; i++) {
1211             ERC721.safeTransferFrom(from_, to_, tokenIds_[i], datas_[i]);
1212         }
1213     }
1214     function walletOfOwner(address address_) public view returns (uint256[] memory) {
1215         uint256 _balance = balanceOf(address_);
1216         uint256[] memory _tokens = new uint256[](_balance);
1217         uint256 _index;
1218         for (uint256 i = 0; i < maxTokens; i++) {
1219             if (address_ == ownerOf(i)) { _tokens[_index] = i; _index++; }
1220         }
1221         return _tokens;
1222     }
1223 }