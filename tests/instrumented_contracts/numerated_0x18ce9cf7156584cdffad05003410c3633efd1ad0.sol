1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/utils/Address.sol
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if `account` is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, `isContract` will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize, which returns 0 for contracts in
54         // construction, since the code is only stored at the end of the
55         // constructor execution.
56 
57         uint256 size;
58         assembly {
59             size := extcodesize(account)
60         }
61         return size > 0;
62     }
63 
64     /**
65      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
66      * `recipient`, forwarding all available gas and reverting on errors.
67      *
68      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
69      * of certain opcodes, possibly making contracts go over the 2300 gas limit
70      * imposed by `transfer`, making them unable to receive funds via
71      * `transfer`. {sendValue} removes this limitation.
72      *
73      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
74      *
75      * IMPORTANT: because control is transferred to `recipient`, care must be
76      * taken to not create reentrancy vulnerabilities. Consider using
77      * {ReentrancyGuard} or the
78      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
79      */
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         (bool success, ) = recipient.call{value: amount}("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level `call`. A
89      * plain `call` is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If `target` reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
97      *
98      * Requirements:
99      *
100      * - `target` must be a contract.
101      * - calling `target` with `data` must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
111      * `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(
116         address target,
117         bytes memory data,
118         string memory errorMessage
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but also transferring `value` wei to `target`.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least `value`.
130      * - the called Solidity function must be `payable`.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
144      * with `errorMessage` as a fallback revert reason when `target` reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         require(address(this).balance >= value, "Address: insufficient balance for call");
155         require(isContract(target), "Address: call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.call{value: value}(data);
158         return _verifyCallResult(success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
168         return functionStaticCall(target, data, "Address: low-level static call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal view returns (bytes memory) {
182         require(isContract(target), "Address: static call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.staticcall(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return _verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     function _verifyCallResult(
216         bool success,
217         bytes memory returndata,
218         string memory errorMessage
219     ) private pure returns (bytes memory) {
220         if (success) {
221             return returndata;
222         } else {
223             // Look for revert reason and bubble it up if present
224             if (returndata.length > 0) {
225                 // The easiest way to bubble the revert reason is using memory via assembly
226 
227                 assembly {
228                     let returndata_size := mload(returndata)
229                     revert(add(32, returndata), returndata_size)
230                 }
231             } else {
232                 revert(errorMessage);
233             }
234         }
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Interface of the ERC165 standard, as defined in the
244  * https://eips.ethereum.org/EIPS/eip-165[EIP].
245  *
246  * Implementers can declare support of contract interfaces, which can then be
247  * queried by others ({ERC165Checker}).
248  *
249  * For an implementation, see {ERC165}.
250  */
251 interface IERC165 {
252     /**
253      * @dev Returns true if this contract implements the interface defined by
254      * `interfaceId`. See the corresponding
255      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
256      * to learn more about how these ids are created.
257      *
258      * This function call must use less than 30 000 gas.
259      */
260     function supportsInterface(bytes4 interfaceId) external view returns (bool);
261 }
262 
263 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
264 
265 pragma solidity ^0.8.0;
266 
267 
268 /**
269  * @dev Implementation of the {IERC165} interface.
270  *
271  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
272  * for the additional interface id that will be supported. For example:
273  *
274  * ```solidity
275  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
277  * }
278  * ```
279  *
280  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
281  */
282 abstract contract ERC165 is IERC165 {
283     /**
284      * @dev See {IERC165-supportsInterface}.
285      */
286     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
287         return interfaceId == type(IERC165).interfaceId;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/Strings.sol
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev String operations.
297  */
298 library Strings {
299     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
303      */
304     function toString(uint256 value) internal pure returns (string memory) {
305         // Inspired by OraclizeAPI's implementation - MIT licence
306         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
307 
308         if (value == 0) {
309             return "0";
310         }
311         uint256 temp = value;
312         uint256 digits;
313         while (temp != 0) {
314             digits++;
315             temp /= 10;
316         }
317         bytes memory buffer = new bytes(digits);
318         while (value != 0) {
319             digits -= 1;
320             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
321             value /= 10;
322         }
323         return string(buffer);
324     }
325 
326     /**
327      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
328      */
329     function toHexString(uint256 value) internal pure returns (string memory) {
330         if (value == 0) {
331             return "0x00";
332         }
333         uint256 temp = value;
334         uint256 length = 0;
335         while (temp != 0) {
336             length++;
337             temp >>= 8;
338         }
339         return toHexString(value, length);
340     }
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
344      */
345     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
346         bytes memory buffer = new bytes(2 * length + 2);
347         buffer[0] = "0";
348         buffer[1] = "x";
349         for (uint256 i = 2 * length + 1; i > 1; --i) {
350             buffer[i] = _HEX_SYMBOLS[value & 0xf];
351             value >>= 4;
352         }
353         require(value == 0, "Strings: hex length insufficient");
354         return string(buffer);
355     }
356 }
357 
358 
359 
360 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @title ERC721 token receiver interface
366  * @dev Interface for any contract that wants to support safeTransfers
367  * from ERC721 asset contracts.
368  */
369 interface IERC721Receiver {
370     /**
371      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
372      * by `operator` from `from`, this function is called.
373      *
374      * It must return its Solidity selector to confirm the token transfer.
375      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
376      *
377      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
378      */
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
537  * @dev See https://eips.ethereum.org/EIPS/eip-721
538  */
539 interface IERC721Metadata is IERC721 {
540     /**
541      * @dev Returns the token collection name.
542      */
543     function name() external view returns (string memory);
544 
545     /**
546      * @dev Returns the token collection symbol.
547      */
548     function symbol() external view returns (string memory);
549 
550     /**
551      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
552      */
553     function tokenURI(uint256 tokenId) external view returns (string memory);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
557 
558 pragma solidity ^0.8.0;
559 
560 
561 
562 
563 
564 
565 
566 
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
569  * the Metadata extension, but not including the Enumerable extension, which is available separately as
570  * {ERC721Enumerable}.
571  */
572 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
573     using Address for address;
574     using Strings for uint256;
575 
576     // Token name
577     string private _name;
578 
579     // Token symbol
580     string private _symbol;
581 
582     // Mapping from token ID to owner address
583     mapping(uint256 => address) private _owners;
584 
585     // Mapping owner address to token count
586     mapping(address => uint256) private _balances;
587 
588     // Mapping from token ID to approved address
589     mapping(uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     /**
595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
596      */
597     constructor(string memory name_, string memory symbol_) {
598         _name = name_;
599         _symbol = symbol_;
600     }
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
606         return
607             interfaceId == type(IERC721).interfaceId ||
608             interfaceId == type(IERC721Metadata).interfaceId ||
609             super.supportsInterface(interfaceId);
610     }
611 
612     /**
613      * @dev See {IERC721-balanceOf}.
614      */
615     function balanceOf(address owner) public view virtual override returns (uint256) {
616         require(owner != address(0), "ERC721: balance query for the zero address");
617         return _balances[owner];
618     }
619 
620     /**
621      * @dev See {IERC721-ownerOf}.
622      */
623     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
624         address owner = _owners[tokenId];
625         require(owner != address(0), "ERC721: owner query for nonexistent token");
626         return owner;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-name}.
631      */
632     function name() public view virtual override returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-symbol}.
638      */
639     function symbol() public view virtual override returns (string memory) {
640         return _symbol;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-tokenURI}.
645      */
646     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
647         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
648 
649         string memory baseURI = _baseURI();
650         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
655      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
656      * by default, can be overriden in child contracts.
657      */
658     function _baseURI() internal view virtual returns (string memory) {
659         return "";
660     }
661 
662     /**
663      * @dev See {IERC721-approve}.
664      */
665     function approve(address to, uint256 tokenId) public virtual override {
666         address owner = ERC721.ownerOf(tokenId);
667         require(to != owner, "ERC721: approval to current owner");
668 
669         require(
670             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
671             "ERC721: approve caller is not owner nor approved for all"
672         );
673 
674         _approve(to, tokenId);
675     }
676 
677     /**
678      * @dev See {IERC721-getApproved}.
679      */
680     function getApproved(uint256 tokenId) public view virtual override returns (address) {
681         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
682 
683         return _tokenApprovals[tokenId];
684     }
685 
686     /**
687      * @dev See {IERC721-setApprovalForAll}.
688      */
689     function setApprovalForAll(address operator, bool approved) public virtual override {
690         require(operator != _msgSender(), "ERC721: approve to caller");
691 
692         _operatorApprovals[_msgSender()][operator] = approved;
693         emit ApprovalForAll(_msgSender(), operator, approved);
694     }
695 
696     /**
697      * @dev See {IERC721-isApprovedForAll}.
698      */
699     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
700         return _operatorApprovals[owner][operator];
701     }
702 
703     /**
704      * @dev See {IERC721-transferFrom}.
705      */
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) public virtual override {
711         //solhint-disable-next-line max-line-length
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713 
714         _transfer(from, to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         safeTransferFrom(from, to, tokenId, "");
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) public virtual override {
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738         _safeTransfer(from, to, tokenId, _data);
739     }
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
743      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
744      *
745      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
746      *
747      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
748      * implement alternative mechanisms to perform token transfer, such as signature-based.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _safeTransfer(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) internal virtual {
765         _transfer(from, to, tokenId);
766         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      * and stop existing when they are burned (`_burn`).
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return _owners[tokenId] != address(0);
779     }
780 
781     /**
782      * @dev Returns whether `spender` is allowed to manage `tokenId`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
789         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
790         address owner = ERC721.ownerOf(tokenId);
791         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
792     }
793 
794     /**
795      * @dev Safely mints `tokenId` and transfers it to `to`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeMint(address to, uint256 tokenId) internal virtual {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
810      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
811      */
812     function _safeMint(
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _mint(to, tokenId);
818         require(
819             _checkOnERC721Received(address(0), to, tokenId, _data),
820             "ERC721: transfer to non ERC721Receiver implementer"
821         );
822     }
823 
824     /**
825      * @dev Mints `tokenId` and transfers it to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - `to` cannot be the zero address.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _mint(address to, uint256 tokenId) internal virtual {
837         require(to != address(0), "ERC721: mint to the zero address");
838         require(!_exists(tokenId), "ERC721: token already minted");
839 
840         _beforeTokenTransfer(address(0), to, tokenId);
841 
842         _balances[to] += 1;
843         _owners[tokenId] = to;
844 
845         emit Transfer(address(0), to, tokenId);
846     }
847 
848     /**
849      * @dev Destroys `tokenId`.
850      * The approval is cleared when the token is burned.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _burn(uint256 tokenId) internal virtual {
859         address owner = ERC721.ownerOf(tokenId);
860 
861         _beforeTokenTransfer(owner, address(0), tokenId);
862 
863         // Clear approvals
864         _approve(address(0), tokenId);
865 
866         _balances[owner] -= 1;
867         delete _owners[tokenId];
868 
869         emit Transfer(owner, address(0), tokenId);
870     }
871 
872     /**
873      * @dev Transfers `tokenId` from `from` to `to`.
874      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must be owned by `from`.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _transfer(
884         address from,
885         address to,
886         uint256 tokenId
887     ) internal virtual {
888         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
889         require(to != address(0), "ERC721: transfer to the zero address");
890 
891         _beforeTokenTransfer(from, to, tokenId);
892 
893         // Clear approvals from the previous owner
894         _approve(address(0), tokenId);
895 
896         _balances[from] -= 1;
897         _balances[to] += 1;
898         _owners[tokenId] = to;
899 
900         emit Transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev Approve `to` to operate on `tokenId`
905      *
906      * Emits a {Approval} event.
907      */
908     function _approve(address to, uint256 tokenId) internal virtual {
909         _tokenApprovals[tokenId] = to;
910         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
911     }
912 
913     /**
914      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
915      * The call is not executed if the target address is not a contract.
916      *
917      * @param from address representing the previous owner of the given token ID
918      * @param to target address that will receive the tokens
919      * @param tokenId uint256 ID of the token to be transferred
920      * @param _data bytes optional data to send along with the call
921      * @return bool whether the call correctly returned the expected magic value
922      */
923     function _checkOnERC721Received(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) private returns (bool) {
929         if (to.isContract()) {
930             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
931                 return retval == IERC721Receiver(to).onERC721Received.selector;
932             } catch (bytes memory reason) {
933                 if (reason.length == 0) {
934                     revert("ERC721: transfer to non ERC721Receiver implementer");
935                 } else {
936                     assembly {
937                         revert(add(32, reason), mload(reason))
938                     }
939                 }
940             }
941         } else {
942             return true;
943         }
944     }
945 
946     /**
947      * @dev Hook that is called before any token transfer. This includes minting
948      * and burning.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, ``from``'s `tokenId` will be burned.
956      * - `from` and `to` are never both zero.
957      *
958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
959      */
960     function _beforeTokenTransfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {}
965 }
966 
967 // File: @openzeppelin/contracts/access/Ownable.sol
968 
969 pragma solidity ^0.8.0;
970 
971 
972 /**
973  * @dev Contract module which provides a basic access control mechanism, where
974  * there is an account (an owner) that can be granted exclusive access to
975  * specific functions.
976  *
977  * By default, the owner account will be the one that deploys the contract. This
978  * can later be changed with {transferOwnership}.
979  *
980  * This module is used through inheritance. It will make available the modifier
981  * `onlyOwner`, which can be applied to your functions to restrict their use to
982  * the owner.
983  */
984 abstract contract Ownable is Context {
985     address private _owner;
986 
987     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
988 
989     /**
990      * @dev Initializes the contract setting the deployer as the initial owner.
991      */
992     constructor() {
993         _setOwner(_msgSender());
994     }
995 
996     /**
997      * @dev Returns the address of the current owner.
998      */
999     function owner() public view virtual returns (address) {
1000         return _owner;
1001     }
1002 
1003     /**
1004      * @dev Throws if called by any account other than the owner.
1005      */
1006     modifier onlyOwner() {
1007         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1008         _;
1009     }
1010 
1011     /**
1012      * @dev Leaves the contract without owner. It will not be possible to call
1013      * `onlyOwner` functions anymore. Can only be called by the current owner.
1014      *
1015      * NOTE: Renouncing ownership will leave the contract without an owner,
1016      * thereby removing any functionality that is only available to the owner.
1017      */
1018     function renounceOwnership() public virtual onlyOwner {
1019         _setOwner(address(0));
1020     }
1021 
1022     /**
1023      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1024      * Can only be called by the current owner.
1025      */
1026     function transferOwnership(address newOwner) public virtual onlyOwner {
1027         require(newOwner != address(0), "Ownable: new owner is the zero address");
1028         _setOwner(newOwner);
1029     }
1030 
1031     function _setOwner(address newOwner) private {
1032         address oldOwner = _owner;
1033         _owner = newOwner;
1034         emit OwnershipTransferred(oldOwner, newOwner);
1035     }
1036 }
1037 
1038 // File: @openzeppelin/contracts/utils/Counters.sol
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @title Counters
1044  * @author Matt Condon (@shrugs)
1045  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1046  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1047  *
1048  * Include with `using Counters for Counters.Counter;`
1049  */
1050 library Counters {
1051     struct Counter {
1052         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1053         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1054         // this feature: see https://github.com/ethereum/solidity/issues/4637
1055         uint256 _value; // default: 0
1056     }
1057 
1058     function current(Counter storage counter) internal view returns (uint256) {
1059         return counter._value;
1060     }
1061 
1062     function increment(Counter storage counter) internal {
1063         unchecked {
1064             counter._value += 1;
1065         }
1066     }
1067 
1068     function decrement(Counter storage counter) internal {
1069         uint256 value = counter._value;
1070         require(value > 0, "Counter: decrement overflow");
1071         unchecked {
1072             counter._value = value - 1;
1073         }
1074     }
1075 
1076     function reset(Counter storage counter) internal {
1077         counter._value = 0;
1078     }
1079 }
1080 
1081 // File: @openzeppelin/contracts/security/Pausable.sol
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 
1086 /**
1087  * @dev Contract module which allows children to implement an emergency stop
1088  * mechanism that can be triggered by an authorized account.
1089  *
1090  * This module is used through inheritance. It will make available the
1091  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1092  * the functions of your contract. Note that they will not be pausable by
1093  * simply including this module, only once the modifiers are put in place.
1094  */
1095 abstract contract Pausable is Context {
1096     /**
1097      * @dev Emitted when the pause is triggered by `account`.
1098      */
1099     event Paused(address account);
1100 
1101     /**
1102      * @dev Emitted when the pause is lifted by `account`.
1103      */
1104     event Unpaused(address account);
1105 
1106     bool private _paused;
1107 
1108     /**
1109      * @dev Initializes the contract in unpaused state.
1110      */
1111     constructor() {
1112         _paused = false;
1113     }
1114 
1115     /**
1116      * @dev Returns true if the contract is paused, and false otherwise.
1117      */
1118     function paused() public view virtual returns (bool) {
1119         return _paused;
1120     }
1121 
1122     /**
1123      * @dev Modifier to make a function callable only when the contract is not paused.
1124      *
1125      * Requirements:
1126      *
1127      * - The contract must not be paused.
1128      */
1129     modifier whenNotPaused() {
1130         require(!paused(), "Pausable: paused");
1131         _;
1132     }
1133 
1134     /**
1135      * @dev Modifier to make a function callable only when the contract is paused.
1136      *
1137      * Requirements:
1138      *
1139      * - The contract must be paused.
1140      */
1141     modifier whenPaused() {
1142         require(paused(), "Pausable: not paused");
1143         _;
1144     }
1145 
1146     /**
1147      * @dev Triggers stopped state.
1148      *
1149      * Requirements:
1150      *
1151      * - The contract must not be paused.
1152      */
1153     function _pause() internal virtual whenNotPaused {
1154         _paused = true;
1155         emit Paused(_msgSender());
1156     }
1157 
1158     /**
1159      * @dev Returns to normal state.
1160      *
1161      * Requirements:
1162      *
1163      * - The contract must be paused.
1164      */
1165     function _unpause() internal virtual whenPaused {
1166         _paused = false;
1167         emit Unpaused(_msgSender());
1168     }
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 
1176 /**
1177  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1178  * @dev See https://eips.ethereum.org/EIPS/eip-721
1179  */
1180 interface IERC721Enumerable is IERC721 {
1181     /**
1182      * @dev Returns the total amount of tokens stored by the contract.
1183      */
1184     function totalSupply() external view returns (uint256);
1185 
1186     /**
1187      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1188      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1189      */
1190     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1191 
1192     /**
1193      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1194      * Use along with {totalSupply} to enumerate all tokens.
1195      */
1196     function tokenByIndex(uint256 index) external view returns (uint256);
1197 }
1198 
1199 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1200 
1201 pragma solidity ^0.8.0;
1202 
1203 
1204 
1205 /**
1206  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1207  * enumerability of all the token ids in the contract as well as all token ids owned by each
1208  * account.
1209  */
1210 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1211     // Mapping from owner to list of owned token IDs
1212     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1213 
1214     // Mapping from token ID to index of the owner tokens list
1215     mapping(uint256 => uint256) private _ownedTokensIndex;
1216 
1217     // Array with all token ids, used for enumeration
1218     uint256[] private _allTokens;
1219 
1220     // Mapping from token id to position in the allTokens array
1221     mapping(uint256 => uint256) private _allTokensIndex;
1222 
1223     /**
1224      * @dev See {IERC165-supportsInterface}.
1225      */
1226     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1227         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1232      */
1233     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1234         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1235         return _ownedTokens[owner][index];
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Enumerable-totalSupply}.
1240      */
1241     function totalSupply() public view virtual override returns (uint256) {
1242         return _allTokens.length;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Enumerable-tokenByIndex}.
1247      */
1248     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1249         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1250         return _allTokens[index];
1251     }
1252 
1253     /**
1254      * @dev Hook that is called before any token transfer. This includes minting
1255      * and burning.
1256      *
1257      * Calling conditions:
1258      *
1259      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1260      * transferred to `to`.
1261      * - When `from` is zero, `tokenId` will be minted for `to`.
1262      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      *
1266      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1267      */
1268     function _beforeTokenTransfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal virtual override {
1273         super._beforeTokenTransfer(from, to, tokenId);
1274 
1275         if (from == address(0)) {
1276             _addTokenToAllTokensEnumeration(tokenId);
1277         } else if (from != to) {
1278             _removeTokenFromOwnerEnumeration(from, tokenId);
1279         }
1280         if (to == address(0)) {
1281             _removeTokenFromAllTokensEnumeration(tokenId);
1282         } else if (to != from) {
1283             _addTokenToOwnerEnumeration(to, tokenId);
1284         }
1285     }
1286 
1287     /**
1288      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1289      * @param to address representing the new owner of the given token ID
1290      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1291      */
1292     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1293         uint256 length = ERC721.balanceOf(to);
1294         _ownedTokens[to][length] = tokenId;
1295         _ownedTokensIndex[tokenId] = length;
1296     }
1297 
1298     /**
1299      * @dev Private function to add a token to this extension's token tracking data structures.
1300      * @param tokenId uint256 ID of the token to be added to the tokens list
1301      */
1302     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1303         _allTokensIndex[tokenId] = _allTokens.length;
1304         _allTokens.push(tokenId);
1305     }
1306 
1307     /**
1308      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1309      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1310      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1311      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1312      * @param from address representing the previous owner of the given token ID
1313      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1314      */
1315     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1316         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1317         // then delete the last slot (swap and pop).
1318 
1319         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1320         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1321 
1322         // When the token to delete is the last token, the swap operation is unnecessary
1323         if (tokenIndex != lastTokenIndex) {
1324             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1325 
1326             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1327             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1328         }
1329 
1330         // This also deletes the contents at the last position of the array
1331         delete _ownedTokensIndex[tokenId];
1332         delete _ownedTokens[from][lastTokenIndex];
1333     }
1334 
1335     /**
1336      * @dev Private function to remove a token from this extension's token tracking data structures.
1337      * This has O(1) time complexity, but alters the order of the _allTokens array.
1338      * @param tokenId uint256 ID of the token to be removed from the tokens list
1339      */
1340     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1341         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1342         // then delete the last slot (swap and pop).
1343 
1344         uint256 lastTokenIndex = _allTokens.length - 1;
1345         uint256 tokenIndex = _allTokensIndex[tokenId];
1346 
1347         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1348         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1349         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1350         uint256 lastTokenId = _allTokens[lastTokenIndex];
1351 
1352         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1353         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1354 
1355         // This also deletes the contents at the last position of the array
1356         delete _allTokensIndex[tokenId];
1357         _allTokens.pop();
1358     }
1359 }
1360 
1361 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 
1366 /**
1367  * @dev ERC721 token with storage based token URI management.
1368  */
1369 abstract contract ERC721URIStorage is ERC721 {
1370     using Strings for uint256;
1371 
1372     // Optional mapping for token URIs
1373     mapping(uint256 => string) private _tokenURIs;
1374 
1375     /**
1376      * @dev See {IERC721Metadata-tokenURI}.
1377      */
1378     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1379         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1380 
1381         string memory _tokenURI = _tokenURIs[tokenId];
1382         string memory base = _baseURI();
1383 
1384         // If there is no base URI, return the token URI.
1385         if (bytes(base).length == 0) {
1386             return _tokenURI;
1387         }
1388         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1389         if (bytes(_tokenURI).length > 0) {
1390             return string(abi.encodePacked(base, _tokenURI));
1391         }
1392 
1393         return super.tokenURI(tokenId);
1394     }
1395 
1396     /**
1397      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must exist.
1402      */
1403     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1404         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1405         _tokenURIs[tokenId] = _tokenURI;
1406     }
1407 
1408     /**
1409      * @dev Destroys `tokenId`.
1410      * The approval is cleared when the token is burned.
1411      *
1412      * Requirements:
1413      *
1414      * - `tokenId` must exist.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _burn(uint256 tokenId) internal virtual override {
1419         super._burn(tokenId);
1420 
1421         if (bytes(_tokenURIs[tokenId]).length != 0) {
1422             delete _tokenURIs[tokenId];
1423         }
1424     }
1425 }
1426 
1427 
1428 
1429 // File: contracts/NFTFiesta.sol
1430 
1431 pragma solidity ^0.8.0;
1432 
1433 
1434 
1435 
1436 
1437 
1438 
1439 contract NFT_Fiesta is ERC721URIStorage, ERC721Enumerable, Ownable, Pausable {
1440     using Counters for Counters.Counter;
1441     Counters.Counter public _tokenIds;
1442     address payable private _owner;
1443     uint internal  MAX_Tickets = 500;
1444     uint ticket_price = 15000000000000000; // 0.015 ETH
1445     
1446     constructor () payable ERC721("FIESTA", "NFT Fiesta") {}
1447     
1448     mapping(address => bool) internal authorised_contracts;
1449     
1450     mapping (uint256 => string) internal access_codes;
1451     
1452     function change_ticket_price(uint new_price) public onlyOwner returns(uint)
1453     {
1454         ticket_price = new_price;
1455         return(new_price);
1456     }
1457     
1458     function price() public view returns (uint256) {
1459         return ticket_price; 
1460     }
1461 
1462     
1463     function modify_MAX_Tickets(uint256 new_MAX) public onlyOwner {
1464         MAX_Tickets = new_MAX;
1465     }
1466     
1467     function show_MAX_Tickets() public view returns (uint256)
1468     {
1469         return(MAX_Tickets);
1470     }
1471     
1472     string private baseURI = ""; 
1473     
1474     function insert_access_code(uint256 tokenId, string memory access_code) public onlyOwner returns(string memory)
1475     {
1476         access_codes[tokenId] = access_code;
1477         
1478         return(access_code);
1479     }
1480     
1481     function view_acces_code(uint256 tokenId) public view returns(string memory)
1482     {
1483         require(msg.sender == ownerOf(tokenId));
1484         return(access_codes[tokenId]);
1485     }
1486     
1487     
1488     function addAuthorisedAddress(address _address) public onlyOwner {
1489         authorised_contracts[_address] = true;
1490     }
1491     
1492     modifier onlyAuthorised()
1493     {
1494         require(authorised_contracts[msg.sender]);
1495         _;
1496     }
1497 
1498     
1499     function check_tokenCount() view public returns (uint256)
1500     {
1501         return _tokenIds.current();
1502     }
1503     
1504     function change_base_URI(string memory new_base_URI)
1505         onlyOwner
1506         public
1507     {
1508         baseURI = new_base_URI;
1509     }
1510     
1511     function _baseURI() internal view override returns (string memory) {
1512         return baseURI;
1513     }
1514     
1515     function pause() public onlyOwner {
1516         _pause();
1517     }
1518 
1519     function unpause() public onlyOwner {
1520         _unpause();
1521     }
1522     
1523     modifier saleIsOpen{
1524         require(totalSupply() <= MAX_Tickets, "Sale end");
1525         _;
1526     }
1527     
1528     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1529         super._burn(tokenId);
1530     }
1531     
1532     function burn_admin(uint256 tokenid)
1533         public
1534         onlyOwner
1535         returns (uint256)
1536     {
1537         _burn(tokenid);
1538         return tokenid;
1539     }
1540     
1541     function mint_admin(address address_, uint256 tokenid)
1542         public
1543         onlyOwner
1544         returns (uint256)
1545     {
1546         _mint(address_, tokenid);
1547         return tokenid;
1548     }
1549     
1550     function tokenURI(uint256 tokenId)
1551         public
1552         view
1553         override(ERC721, ERC721URIStorage)
1554         returns (string memory)
1555     {
1556         return super.tokenURI(tokenId);
1557     }
1558     
1559     function createTicket()
1560         public
1561         payable
1562         saleIsOpen
1563         whenNotPaused
1564         returns (uint256)
1565     {
1566         require(msg.value == ticket_price, "Payment Error");
1567         require(balanceOf(msg.sender) < 1, "Reached wallet's minting limit");
1568         _tokenIds.increment();
1569         uint256 newItemId = _tokenIds.current();
1570         _mint(msg.sender, newItemId);
1571         return newItemId;
1572     }
1573     
1574     function see_sold_Tickets()
1575         public 
1576         view
1577         returns (uint256)
1578     {
1579         return(_tokenIds.current());
1580     }
1581     
1582     function checkContractBalance()
1583         public
1584         onlyOwner
1585         view
1586         returns (uint256)
1587     {
1588         return address(this).balance;
1589     }
1590     
1591     function withdraw()
1592         public
1593         payable
1594         onlyOwner
1595     {
1596         payable(msg.sender).transfer(address(this).balance);
1597     }
1598     
1599     function supportsInterface(bytes4 interfaceId)
1600         public
1601         view
1602         override(ERC721, ERC721Enumerable)
1603         returns (bool)
1604     {
1605         return super.supportsInterface(interfaceId);
1606     }
1607     
1608     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1609         internal
1610         whenNotPaused
1611         override(ERC721, ERC721Enumerable)
1612     {
1613         super._beforeTokenTransfer(from, to, tokenId);
1614     }
1615     
1616     function retrieveTokens(address owner) public view returns (uint256[] memory tokens) {
1617         uint256 iterator = balanceOf(owner);
1618         uint256[] memory tokenlist = new uint256[](iterator);
1619         for (uint256 i = 0; i < iterator; i++){
1620             tokenlist[i] = tokenOfOwnerByIndex(owner, i);
1621         }
1622         return tokenlist;
1623     }
1624     
1625 }