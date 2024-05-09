1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.3
26 
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.3
170 
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
201 
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210     /**
211      * @dev Returns the token collection name.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the token collection symbol.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222      */
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 
227 // File @openzeppelin/contracts/utils/Address.sol@v4.3.3
228 
229 
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         uint256 size;
260         assembly {
261             size := extcodesize(account)
262         }
263         return size > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 
447 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
448 
449 
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 
474 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev String operations.
482  */
483 library Strings {
484     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
488      */
489     function toString(uint256 value) internal pure returns (string memory) {
490         // Inspired by OraclizeAPI's implementation - MIT licence
491         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
492 
493         if (value == 0) {
494             return "0";
495         }
496         uint256 temp = value;
497         uint256 digits;
498         while (temp != 0) {
499             digits++;
500             temp /= 10;
501         }
502         bytes memory buffer = new bytes(digits);
503         while (value != 0) {
504             digits -= 1;
505             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
506             value /= 10;
507         }
508         return string(buffer);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
513      */
514     function toHexString(uint256 value) internal pure returns (string memory) {
515         if (value == 0) {
516             return "0x00";
517         }
518         uint256 temp = value;
519         uint256 length = 0;
520         while (temp != 0) {
521             length++;
522             temp >>= 8;
523         }
524         return toHexString(value, length);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
529      */
530     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
531         bytes memory buffer = new bytes(2 * length + 2);
532         buffer[0] = "0";
533         buffer[1] = "x";
534         for (uint256 i = 2 * length + 1; i > 1; --i) {
535             buffer[i] = _HEX_SYMBOLS[value & 0xf];
536             value >>= 4;
537         }
538         require(value == 0, "Strings: hex length insufficient");
539         return string(buffer);
540     }
541 }
542 
543 
544 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * ```solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * ```
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 
574 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.3
575 
576 
577 
578 pragma solidity ^0.8.0;
579 
580 
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 
987 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @dev Contract module which provides a basic access control mechanism, where
995  * there is an account (an owner) that can be granted exclusive access to
996  * specific functions.
997  *
998  * By default, the owner account will be the one that deploys the contract. This
999  * can later be changed with {transferOwnership}.
1000  *
1001  * This module is used through inheritance. It will make available the modifier
1002  * `onlyOwner`, which can be applied to your functions to restrict their use to
1003  * the owner.
1004  */
1005 abstract contract Ownable is Context {
1006     
1007     address private _owner;
1008 
1009     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1010 
1011     /**
1012      * @dev Initializes the contract setting the deployer as the initial owner.
1013      */
1014     constructor() {
1015         _setOwner(_msgSender());
1016     }
1017 
1018     /**
1019      * @dev Returns the address of the current owner.
1020      */
1021     function owner() public view virtual returns (address) {
1022         return _owner;
1023     }
1024 
1025     /**
1026      * @dev Throws if called by any account other than the owner.
1027      */
1028     modifier onlyOwner() {
1029         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1030         _;
1031     }
1032 
1033     /**
1034      * @dev Leaves the contract without owner. It will not be possible to call
1035      * `onlyOwner` functions anymore. Can only be called by the current owner.
1036      *
1037      * NOTE: Renouncing ownership will leave the contract without an owner,
1038      * thereby removing any functionality that is only available to the owner.
1039      */
1040     function renounceOwnership() public virtual onlyOwner {
1041         _setOwner(address(0));
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1046      * Can only be called by the current owner.
1047      */
1048     function transferOwnership(address newOwner) public virtual onlyOwner {
1049         require(newOwner != address(0), "Ownable: new owner is the zero address");
1050         _setOwner(newOwner);
1051     }
1052 
1053     function _setOwner(address newOwner) private {
1054         address oldOwner = _owner;
1055         _owner = newOwner;
1056         emit OwnershipTransferred(oldOwner, newOwner);
1057     }
1058 }
1059 
1060 
1061 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.3
1062 
1063 
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 // CAUTION
1068 // This version of SafeMath should only be used with Solidity 0.8 or later,
1069 // because it relies on the compiler's built in overflow checks.
1070 
1071 /**
1072  * @dev Wrappers over Solidity's arithmetic operations.
1073  *
1074  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1075  * now has built in overflow checking.
1076  */
1077 library SafeMath {
1078     /**
1079      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1080      *
1081      * _Available since v3.4._
1082      */
1083     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1084         unchecked {
1085             uint256 c = a + b;
1086             if (c < a) return (false, 0);
1087             return (true, c);
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1093      *
1094      * _Available since v3.4._
1095      */
1096     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1097         unchecked {
1098             if (b > a) return (false, 0);
1099             return (true, a - b);
1100         }
1101     }
1102 
1103     /**
1104      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1105      *
1106      * _Available since v3.4._
1107      */
1108     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1109         unchecked {
1110             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1111             // benefit is lost if 'b' is also tested.
1112             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1113             if (a == 0) return (true, 0);
1114             uint256 c = a * b;
1115             if (c / a != b) return (false, 0);
1116             return (true, c);
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1122      *
1123      * _Available since v3.4._
1124      */
1125     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1126         unchecked {
1127             if (b == 0) return (false, 0);
1128             return (true, a / b);
1129         }
1130     }
1131 
1132     /**
1133      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1134      *
1135      * _Available since v3.4._
1136      */
1137     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1138         unchecked {
1139             if (b == 0) return (false, 0);
1140             return (true, a % b);
1141         }
1142     }
1143 
1144     /**
1145      * @dev Returns the addition of two unsigned integers, reverting on
1146      * overflow.
1147      *
1148      * Counterpart to Solidity's `+` operator.
1149      *
1150      * Requirements:
1151      *
1152      * - Addition cannot overflow.
1153      */
1154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1155         return a + b;
1156     }
1157 
1158     /**
1159      * @dev Returns the subtraction of two unsigned integers, reverting on
1160      * overflow (when the result is negative).
1161      *
1162      * Counterpart to Solidity's `-` operator.
1163      *
1164      * Requirements:
1165      *
1166      * - Subtraction cannot overflow.
1167      */
1168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1169         return a - b;
1170     }
1171 
1172     /**
1173      * @dev Returns the multiplication of two unsigned integers, reverting on
1174      * overflow.
1175      *
1176      * Counterpart to Solidity's `*` operator.
1177      *
1178      * Requirements:
1179      *
1180      * - Multiplication cannot overflow.
1181      */
1182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1183         return a * b;
1184     }
1185 
1186     /**
1187      * @dev Returns the integer division of two unsigned integers, reverting on
1188      * division by zero. The result is rounded towards zero.
1189      *
1190      * Counterpart to Solidity's `/` operator.
1191      *
1192      * Requirements:
1193      *
1194      * - The divisor cannot be zero.
1195      */
1196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1197         return a / b;
1198     }
1199 
1200     /**
1201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1202      * reverting when dividing by zero.
1203      *
1204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1205      * opcode (which leaves remaining gas untouched) while Solidity uses an
1206      * invalid opcode to revert (consuming all remaining gas).
1207      *
1208      * Requirements:
1209      *
1210      * - The divisor cannot be zero.
1211      */
1212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1213         return a % b;
1214     }
1215 
1216     /**
1217      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1218      * overflow (when the result is negative).
1219      *
1220      * CAUTION: This function is deprecated because it requires allocating memory for the error
1221      * message unnecessarily. For custom revert reasons use {trySub}.
1222      *
1223      * Counterpart to Solidity's `-` operator.
1224      *
1225      * Requirements:
1226      *
1227      * - Subtraction cannot overflow.
1228      */
1229     function sub(
1230         uint256 a,
1231         uint256 b,
1232         string memory errorMessage
1233     ) internal pure returns (uint256) {
1234         unchecked {
1235             require(b <= a, errorMessage);
1236             return a - b;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1242      * division by zero. The result is rounded towards zero.
1243      *
1244      * Counterpart to Solidity's `/` operator. Note: this function uses a
1245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1246      * uses an invalid opcode to revert (consuming all remaining gas).
1247      *
1248      * Requirements:
1249      *
1250      * - The divisor cannot be zero.
1251      */
1252     function div(
1253         uint256 a,
1254         uint256 b,
1255         string memory errorMessage
1256     ) internal pure returns (uint256) {
1257         unchecked {
1258             require(b > 0, errorMessage);
1259             return a / b;
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1265      * reverting with custom message when dividing by zero.
1266      *
1267      * CAUTION: This function is deprecated because it requires allocating memory for the error
1268      * message unnecessarily. For custom revert reasons use {tryMod}.
1269      *
1270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1271      * opcode (which leaves remaining gas untouched) while Solidity uses an
1272      * invalid opcode to revert (consuming all remaining gas).
1273      *
1274      * Requirements:
1275      *
1276      * - The divisor cannot be zero.
1277      */
1278     function mod(
1279         uint256 a,
1280         uint256 b,
1281         string memory errorMessage
1282     ) internal pure returns (uint256) {
1283         unchecked {
1284             require(b > 0, errorMessage);
1285             return a % b;
1286         }
1287     }
1288 }
1289 
1290 
1291 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.3
1292 
1293 
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @title Counters
1299  * @author Matt Condon (@shrugs)
1300  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1301  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1302  *
1303  * Include with `using Counters for Counters.Counter;`
1304  */
1305 library Counters {
1306     struct Counter {
1307         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1308         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1309         // this feature: see https://github.com/ethereum/solidity/issues/4637
1310         uint256 _value; // default: 0
1311     }
1312 
1313     function current(Counter storage counter) internal view returns (uint256) {
1314         return counter._value;
1315     }
1316 
1317     function increment(Counter storage counter) internal {
1318         unchecked {
1319             counter._value += 1;
1320         }
1321     }
1322 
1323     function decrement(Counter storage counter) internal {
1324         uint256 value = counter._value;
1325         require(value > 0, "Counter: decrement overflow");
1326         unchecked {
1327             counter._value = value - 1;
1328         }
1329     }
1330 
1331     function reset(Counter storage counter) internal {
1332         counter._value = 0;
1333     }
1334 }
1335 
1336 
1337 // File contracts/IWasteLandNFT.sol
1338 
1339 
1340 pragma solidity >=0.8.4;
1341 
1342 
1343 struct WhitelistPurchaseLimit {
1344     address[] whitelist;
1345     uint purchaseLimit;
1346 }
1347 
1348 struct PurchaseStageLimitation {
1349     uint stage;
1350     uint256 start;
1351     uint256 end;
1352     /// @dev 1=exist
1353     uint256 exist; 
1354     WhitelistPurchaseLimit[] purchaseLimit;
1355 }
1356 
1357 
1358 interface IWasteLandNFT {
1359 
1360 
1361     struct ProfileEquipmentsLogs {
1362 
1363         mapping(uint256=>uint256[]) profileEquipments;
1364         
1365         uint256 currentEquipmentStartTime;
1366         uint256 currentEquipmentEndTime;
1367         bool claimed;
1368         uint256 claimTime;
1369     
1370     }
1371 
1372 
1373     /// Purchase is emitted when an ad unit is reserved.
1374     event Purchase (
1375         uint indexed amount,
1376         address owner
1377     );
1378 
1379     event PauseEvent(bool pause);
1380 
1381     /// ads are stored in an array, the id of an ad is its index in this array.
1382     // function purchase(uint amount) external payable returns (uint);
1383 
1384     function withdraw() external;
1385 
1386     function setRevealedURI(string memory uri) external;
1387 
1388     function setBaseURI(string memory uri) external;
1389 
1390     function isTokenOwner(uint256 tokenId, address useraddress) external view returns(bool);
1391 
1392     function getTokenPurchaseTime(uint256 tokenId) external view returns(uint256);
1393 
1394     function getOwnedTokenAmount(address useraddress) external view returns(uint);
1395 
1396 }
1397 
1398 
1399 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.3
1400 
1401 
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1407  * @dev See https://eips.ethereum.org/EIPS/eip-721
1408  */
1409 interface IERC721Enumerable is IERC721 {
1410     /**
1411      * @dev Returns the total amount of tokens stored by the contract.
1412      */
1413     function totalSupply() external view returns (uint256);
1414 
1415     /**
1416      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1417      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1418      */
1419     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1420 
1421     /**
1422      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1423      * Use along with {totalSupply} to enumerate all tokens.
1424      */
1425     function tokenByIndex(uint256 index) external view returns (uint256);
1426 }
1427 
1428 
1429 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.3
1430 
1431 
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 
1436 /**
1437  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1438  * enumerability of all the token ids in the contract as well as all token ids owned by each
1439  * account.
1440  */
1441 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1442     // Mapping from owner to list of owned token IDs
1443     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1444 
1445     // Mapping from token ID to index of the owner tokens list
1446     mapping(uint256 => uint256) private _ownedTokensIndex;
1447 
1448     // Array with all token ids, used for enumeration
1449     uint256[] private _allTokens;
1450 
1451     // Mapping from token id to position in the allTokens array
1452     mapping(uint256 => uint256) private _allTokensIndex;
1453 
1454     /**
1455      * @dev See {IERC165-supportsInterface}.
1456      */
1457     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1458         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1463      */
1464     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1465         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1466         return _ownedTokens[owner][index];
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Enumerable-totalSupply}.
1471      */
1472     function totalSupply() public view virtual override returns (uint256) {
1473         return _allTokens.length;
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-tokenByIndex}.
1478      */
1479     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1480         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1481         return _allTokens[index];
1482     }
1483 
1484     /**
1485      * @dev Hook that is called before any token transfer. This includes minting
1486      * and burning.
1487      *
1488      * Calling conditions:
1489      *
1490      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1491      * transferred to `to`.
1492      * - When `from` is zero, `tokenId` will be minted for `to`.
1493      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1494      * - `from` cannot be the zero address.
1495      * - `to` cannot be the zero address.
1496      *
1497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1498      */
1499     function _beforeTokenTransfer(
1500         address from,
1501         address to,
1502         uint256 tokenId
1503     ) internal virtual override {
1504         super._beforeTokenTransfer(from, to, tokenId);
1505 
1506         if (from == address(0)) {
1507             _addTokenToAllTokensEnumeration(tokenId);
1508         } else if (from != to) {
1509             _removeTokenFromOwnerEnumeration(from, tokenId);
1510         }
1511         if (to == address(0)) {
1512             _removeTokenFromAllTokensEnumeration(tokenId);
1513         } else if (to != from) {
1514             _addTokenToOwnerEnumeration(to, tokenId);
1515         }
1516     }
1517 
1518     /**
1519      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1520      * @param to address representing the new owner of the given token ID
1521      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1522      */
1523     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1524         uint256 length = ERC721.balanceOf(to);
1525         _ownedTokens[to][length] = tokenId;
1526         _ownedTokensIndex[tokenId] = length;
1527     }
1528 
1529     /**
1530      * @dev Private function to add a token to this extension's token tracking data structures.
1531      * @param tokenId uint256 ID of the token to be added to the tokens list
1532      */
1533     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1534         _allTokensIndex[tokenId] = _allTokens.length;
1535         _allTokens.push(tokenId);
1536     }
1537 
1538     /**
1539      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1540      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1541      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1542      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1543      * @param from address representing the previous owner of the given token ID
1544      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1545      */
1546     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1547         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1548         // then delete the last slot (swap and pop).
1549 
1550         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1551         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1552 
1553         // When the token to delete is the last token, the swap operation is unnecessary
1554         if (tokenIndex != lastTokenIndex) {
1555             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1556 
1557             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1558             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1559         }
1560 
1561         // This also deletes the contents at the last position of the array
1562         delete _ownedTokensIndex[tokenId];
1563         delete _ownedTokens[from][lastTokenIndex];
1564     }
1565 
1566     /**
1567      * @dev Private function to remove a token from this extension's token tracking data structures.
1568      * This has O(1) time complexity, but alters the order of the _allTokens array.
1569      * @param tokenId uint256 ID of the token to be removed from the tokens list
1570      */
1571     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1572         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1573         // then delete the last slot (swap and pop).
1574 
1575         uint256 lastTokenIndex = _allTokens.length - 1;
1576         uint256 tokenIndex = _allTokensIndex[tokenId];
1577 
1578         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1579         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1580         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1581         uint256 lastTokenId = _allTokens[lastTokenIndex];
1582 
1583         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1584         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1585 
1586         // This also deletes the contents at the last position of the array
1587         delete _allTokensIndex[tokenId];
1588         _allTokens.pop();
1589     }
1590 }
1591 
1592 
1593 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.3
1594 
1595 
1596 
1597 pragma solidity ^0.8.0;
1598 
1599 /**
1600  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1601  *
1602  * These functions can be used to verify that a message was signed by the holder
1603  * of the private keys of a given address.
1604  */
1605 library ECDSA {
1606     enum RecoverError {
1607         NoError,
1608         InvalidSignature,
1609         InvalidSignatureLength,
1610         InvalidSignatureS,
1611         InvalidSignatureV
1612     }
1613 
1614     function _throwError(RecoverError error) private pure {
1615         if (error == RecoverError.NoError) {
1616             return; // no error: do nothing
1617         } else if (error == RecoverError.InvalidSignature) {
1618             revert("ECDSA: invalid signature");
1619         } else if (error == RecoverError.InvalidSignatureLength) {
1620             revert("ECDSA: invalid signature length");
1621         } else if (error == RecoverError.InvalidSignatureS) {
1622             revert("ECDSA: invalid signature 's' value");
1623         } else if (error == RecoverError.InvalidSignatureV) {
1624             revert("ECDSA: invalid signature 'v' value");
1625         }
1626     }
1627 
1628     /**
1629      * @dev Returns the address that signed a hashed message (`hash`) with
1630      * `signature` or error string. This address can then be used for verification purposes.
1631      *
1632      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1633      * this function rejects them by requiring the `s` value to be in the lower
1634      * half order, and the `v` value to be either 27 or 28.
1635      *
1636      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1637      * verification to be secure: it is possible to craft signatures that
1638      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1639      * this is by receiving a hash of the original message (which may otherwise
1640      * be too long), and then calling {toEthSignedMessageHash} on it.
1641      *
1642      * Documentation for signature generation:
1643      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1644      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1645      *
1646      * _Available since v4.3._
1647      */
1648     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1649         // Check the signature length
1650         // - case 65: r,s,v signature (standard)
1651         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1652         if (signature.length == 65) {
1653             bytes32 r;
1654             bytes32 s;
1655             uint8 v;
1656             // ecrecover takes the signature parameters, and the only way to get them
1657             // currently is to use assembly.
1658             assembly {
1659                 r := mload(add(signature, 0x20))
1660                 s := mload(add(signature, 0x40))
1661                 v := byte(0, mload(add(signature, 0x60)))
1662             }
1663             return tryRecover(hash, v, r, s);
1664         } else if (signature.length == 64) {
1665             bytes32 r;
1666             bytes32 vs;
1667             // ecrecover takes the signature parameters, and the only way to get them
1668             // currently is to use assembly.
1669             assembly {
1670                 r := mload(add(signature, 0x20))
1671                 vs := mload(add(signature, 0x40))
1672             }
1673             return tryRecover(hash, r, vs);
1674         } else {
1675             return (address(0), RecoverError.InvalidSignatureLength);
1676         }
1677     }
1678 
1679     /**
1680      * @dev Returns the address that signed a hashed message (`hash`) with
1681      * `signature`. This address can then be used for verification purposes.
1682      *
1683      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1684      * this function rejects them by requiring the `s` value to be in the lower
1685      * half order, and the `v` value to be either 27 or 28.
1686      *
1687      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1688      * verification to be secure: it is possible to craft signatures that
1689      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1690      * this is by receiving a hash of the original message (which may otherwise
1691      * be too long), and then calling {toEthSignedMessageHash} on it.
1692      */
1693     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1694         (address recovered, RecoverError error) = tryRecover(hash, signature);
1695         _throwError(error);
1696         return recovered;
1697     }
1698 
1699     /**
1700      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1701      *
1702      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1703      *
1704      * _Available since v4.3._
1705      */
1706     function tryRecover(
1707         bytes32 hash,
1708         bytes32 r,
1709         bytes32 vs
1710     ) internal pure returns (address, RecoverError) {
1711         bytes32 s;
1712         uint8 v;
1713         assembly {
1714             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1715             v := add(shr(255, vs), 27)
1716         }
1717         return tryRecover(hash, v, r, s);
1718     }
1719 
1720     /**
1721      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1722      *
1723      * _Available since v4.2._
1724      */
1725     function recover(
1726         bytes32 hash,
1727         bytes32 r,
1728         bytes32 vs
1729     ) internal pure returns (address) {
1730         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1731         _throwError(error);
1732         return recovered;
1733     }
1734 
1735     /**
1736      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1737      * `r` and `s` signature fields separately.
1738      *
1739      * _Available since v4.3._
1740      */
1741     function tryRecover(
1742         bytes32 hash,
1743         uint8 v,
1744         bytes32 r,
1745         bytes32 s
1746     ) internal pure returns (address, RecoverError) {
1747         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1748         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1749         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1750         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1751         //
1752         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1753         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1754         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1755         // these malleable signatures as well.
1756         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1757             return (address(0), RecoverError.InvalidSignatureS);
1758         }
1759         if (v != 27 && v != 28) {
1760             return (address(0), RecoverError.InvalidSignatureV);
1761         }
1762 
1763         // If the signature is valid (and not malleable), return the signer address
1764         address signer = ecrecover(hash, v, r, s);
1765         if (signer == address(0)) {
1766             return (address(0), RecoverError.InvalidSignature);
1767         }
1768 
1769         return (signer, RecoverError.NoError);
1770     }
1771 
1772     /**
1773      * @dev Overload of {ECDSA-recover} that receives the `v`,
1774      * `r` and `s` signature fields separately.
1775      */
1776     function recover(
1777         bytes32 hash,
1778         uint8 v,
1779         bytes32 r,
1780         bytes32 s
1781     ) internal pure returns (address) {
1782         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1783         _throwError(error);
1784         return recovered;
1785     }
1786 
1787     /**
1788      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1789      * produces hash corresponding to the one signed with the
1790      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1791      * JSON-RPC method as part of EIP-191.
1792      *
1793      * See {recover}.
1794      */
1795     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1796         // 32 is the length in bytes of hash,
1797         // enforced by the type signature above
1798         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1799     }
1800 
1801     /**
1802      * @dev Returns an Ethereum Signed Typed Data, created from a
1803      * `domainSeparator` and a `structHash`. This produces hash corresponding
1804      * to the one signed with the
1805      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1806      * JSON-RPC method as part of EIP-712.
1807      *
1808      * See {recover}.
1809      */
1810     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1811         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1812     }
1813 }
1814 
1815 
1816 // File contracts/INFTEquipment.sol
1817 
1818 
1819 pragma solidity ^0.8.0;
1820 
1821 
1822 
1823 
1824 
1825 struct Equipments {
1826     uint tokenId;
1827     uint equipment;
1828     uint category;
1829     uint level;
1830     uint[] property;
1831 }
1832 
1833 interface INFTEquipment is IWasteLandNFT {
1834 
1835 
1836     function doEquipment(uint256 profileTokenId, uint256 equipmentTokenId, address ownerAddress) external returns (uint256);
1837 
1838     function isEquiped(uint256 equipmentTokenId) external view returns (bool);
1839 
1840     function equipmentDetails(uint256 equipmentTokenId) external view returns (Equipments memory);
1841 
1842 
1843     
1844 
1845 
1846 }
1847 
1848 
1849 // File hardhat/console.sol@v2.6.8
1850 
1851 
1852 pragma solidity >= 0.4.22 <0.9.0;
1853 
1854 library console {
1855 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1856 
1857 	function _sendLogPayload(bytes memory payload) private view {
1858 		uint256 payloadLength = payload.length;
1859 		address consoleAddress = CONSOLE_ADDRESS;
1860 		assembly {
1861 			let payloadStart := add(payload, 32)
1862 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1863 		}
1864 	}
1865 
1866 	function log() internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log()"));
1868 	}
1869 
1870 	function logInt(int p0) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1872 	}
1873 
1874 	function logUint(uint p0) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1876 	}
1877 
1878 	function logString(string memory p0) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1880 	}
1881 
1882 	function logBool(bool p0) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1884 	}
1885 
1886 	function logAddress(address p0) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1888 	}
1889 
1890 	function logBytes(bytes memory p0) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1892 	}
1893 
1894 	function logBytes1(bytes1 p0) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1896 	}
1897 
1898 	function logBytes2(bytes2 p0) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1900 	}
1901 
1902 	function logBytes3(bytes3 p0) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1904 	}
1905 
1906 	function logBytes4(bytes4 p0) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1908 	}
1909 
1910 	function logBytes5(bytes5 p0) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1912 	}
1913 
1914 	function logBytes6(bytes6 p0) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1916 	}
1917 
1918 	function logBytes7(bytes7 p0) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1920 	}
1921 
1922 	function logBytes8(bytes8 p0) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1924 	}
1925 
1926 	function logBytes9(bytes9 p0) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1928 	}
1929 
1930 	function logBytes10(bytes10 p0) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1932 	}
1933 
1934 	function logBytes11(bytes11 p0) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1936 	}
1937 
1938 	function logBytes12(bytes12 p0) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1940 	}
1941 
1942 	function logBytes13(bytes13 p0) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1944 	}
1945 
1946 	function logBytes14(bytes14 p0) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1948 	}
1949 
1950 	function logBytes15(bytes15 p0) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1952 	}
1953 
1954 	function logBytes16(bytes16 p0) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1956 	}
1957 
1958 	function logBytes17(bytes17 p0) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1960 	}
1961 
1962 	function logBytes18(bytes18 p0) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1964 	}
1965 
1966 	function logBytes19(bytes19 p0) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1968 	}
1969 
1970 	function logBytes20(bytes20 p0) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1972 	}
1973 
1974 	function logBytes21(bytes21 p0) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1976 	}
1977 
1978 	function logBytes22(bytes22 p0) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1980 	}
1981 
1982 	function logBytes23(bytes23 p0) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1984 	}
1985 
1986 	function logBytes24(bytes24 p0) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1988 	}
1989 
1990 	function logBytes25(bytes25 p0) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1992 	}
1993 
1994 	function logBytes26(bytes26 p0) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1996 	}
1997 
1998 	function logBytes27(bytes27 p0) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
2000 	}
2001 
2002 	function logBytes28(bytes28 p0) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
2004 	}
2005 
2006 	function logBytes29(bytes29 p0) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
2008 	}
2009 
2010 	function logBytes30(bytes30 p0) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
2012 	}
2013 
2014 	function logBytes31(bytes31 p0) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
2016 	}
2017 
2018 	function logBytes32(bytes32 p0) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2020 	}
2021 
2022 	function log(uint p0) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
2024 	}
2025 
2026 	function log(string memory p0) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2028 	}
2029 
2030 	function log(bool p0) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2032 	}
2033 
2034 	function log(address p0) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2036 	}
2037 
2038 	function log(uint p0, uint p1) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
2040 	}
2041 
2042 	function log(uint p0, string memory p1) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
2044 	}
2045 
2046 	function log(uint p0, bool p1) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
2048 	}
2049 
2050 	function log(uint p0, address p1) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
2052 	}
2053 
2054 	function log(string memory p0, uint p1) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
2056 	}
2057 
2058 	function log(string memory p0, string memory p1) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2060 	}
2061 
2062 	function log(string memory p0, bool p1) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2064 	}
2065 
2066 	function log(string memory p0, address p1) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2068 	}
2069 
2070 	function log(bool p0, uint p1) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
2072 	}
2073 
2074 	function log(bool p0, string memory p1) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2076 	}
2077 
2078 	function log(bool p0, bool p1) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2080 	}
2081 
2082 	function log(bool p0, address p1) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2084 	}
2085 
2086 	function log(address p0, uint p1) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
2088 	}
2089 
2090 	function log(address p0, string memory p1) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2092 	}
2093 
2094 	function log(address p0, bool p1) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2096 	}
2097 
2098 	function log(address p0, address p1) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2100 	}
2101 
2102 	function log(uint p0, uint p1, uint p2) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
2104 	}
2105 
2106 	function log(uint p0, uint p1, string memory p2) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
2108 	}
2109 
2110 	function log(uint p0, uint p1, bool p2) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
2112 	}
2113 
2114 	function log(uint p0, uint p1, address p2) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
2116 	}
2117 
2118 	function log(uint p0, string memory p1, uint p2) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
2120 	}
2121 
2122 	function log(uint p0, string memory p1, string memory p2) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
2124 	}
2125 
2126 	function log(uint p0, string memory p1, bool p2) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
2128 	}
2129 
2130 	function log(uint p0, string memory p1, address p2) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
2132 	}
2133 
2134 	function log(uint p0, bool p1, uint p2) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
2136 	}
2137 
2138 	function log(uint p0, bool p1, string memory p2) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
2140 	}
2141 
2142 	function log(uint p0, bool p1, bool p2) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
2144 	}
2145 
2146 	function log(uint p0, bool p1, address p2) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
2148 	}
2149 
2150 	function log(uint p0, address p1, uint p2) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
2152 	}
2153 
2154 	function log(uint p0, address p1, string memory p2) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
2156 	}
2157 
2158 	function log(uint p0, address p1, bool p2) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
2160 	}
2161 
2162 	function log(uint p0, address p1, address p2) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
2164 	}
2165 
2166 	function log(string memory p0, uint p1, uint p2) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
2168 	}
2169 
2170 	function log(string memory p0, uint p1, string memory p2) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
2172 	}
2173 
2174 	function log(string memory p0, uint p1, bool p2) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
2176 	}
2177 
2178 	function log(string memory p0, uint p1, address p2) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
2180 	}
2181 
2182 	function log(string memory p0, string memory p1, uint p2) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
2184 	}
2185 
2186 	function log(string memory p0, string memory p1, string memory p2) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2188 	}
2189 
2190 	function log(string memory p0, string memory p1, bool p2) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2192 	}
2193 
2194 	function log(string memory p0, string memory p1, address p2) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2196 	}
2197 
2198 	function log(string memory p0, bool p1, uint p2) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
2200 	}
2201 
2202 	function log(string memory p0, bool p1, string memory p2) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2204 	}
2205 
2206 	function log(string memory p0, bool p1, bool p2) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2208 	}
2209 
2210 	function log(string memory p0, bool p1, address p2) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2212 	}
2213 
2214 	function log(string memory p0, address p1, uint p2) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
2216 	}
2217 
2218 	function log(string memory p0, address p1, string memory p2) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2220 	}
2221 
2222 	function log(string memory p0, address p1, bool p2) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2224 	}
2225 
2226 	function log(string memory p0, address p1, address p2) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2228 	}
2229 
2230 	function log(bool p0, uint p1, uint p2) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
2232 	}
2233 
2234 	function log(bool p0, uint p1, string memory p2) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
2236 	}
2237 
2238 	function log(bool p0, uint p1, bool p2) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2240 	}
2241 
2242 	function log(bool p0, uint p1, address p2) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2244 	}
2245 
2246 	function log(bool p0, string memory p1, uint p2) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2248 	}
2249 
2250 	function log(bool p0, string memory p1, string memory p2) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2252 	}
2253 
2254 	function log(bool p0, string memory p1, bool p2) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2256 	}
2257 
2258 	function log(bool p0, string memory p1, address p2) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2260 	}
2261 
2262 	function log(bool p0, bool p1, uint p2) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2264 	}
2265 
2266 	function log(bool p0, bool p1, string memory p2) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2268 	}
2269 
2270 	function log(bool p0, bool p1, bool p2) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2272 	}
2273 
2274 	function log(bool p0, bool p1, address p2) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2276 	}
2277 
2278 	function log(bool p0, address p1, uint p2) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2280 	}
2281 
2282 	function log(bool p0, address p1, string memory p2) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2284 	}
2285 
2286 	function log(bool p0, address p1, bool p2) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2288 	}
2289 
2290 	function log(bool p0, address p1, address p2) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2292 	}
2293 
2294 	function log(address p0, uint p1, uint p2) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2296 	}
2297 
2298 	function log(address p0, uint p1, string memory p2) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2300 	}
2301 
2302 	function log(address p0, uint p1, bool p2) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2304 	}
2305 
2306 	function log(address p0, uint p1, address p2) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2308 	}
2309 
2310 	function log(address p0, string memory p1, uint p2) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2312 	}
2313 
2314 	function log(address p0, string memory p1, string memory p2) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2316 	}
2317 
2318 	function log(address p0, string memory p1, bool p2) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2320 	}
2321 
2322 	function log(address p0, string memory p1, address p2) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2324 	}
2325 
2326 	function log(address p0, bool p1, uint p2) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2328 	}
2329 
2330 	function log(address p0, bool p1, string memory p2) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2332 	}
2333 
2334 	function log(address p0, bool p1, bool p2) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2336 	}
2337 
2338 	function log(address p0, bool p1, address p2) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2340 	}
2341 
2342 	function log(address p0, address p1, uint p2) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2344 	}
2345 
2346 	function log(address p0, address p1, string memory p2) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2348 	}
2349 
2350 	function log(address p0, address p1, bool p2) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2352 	}
2353 
2354 	function log(address p0, address p1, address p2) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2356 	}
2357 
2358 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2359 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2360 	}
2361 
2362 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2363 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2364 	}
2365 
2366 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2367 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2368 	}
2369 
2370 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2371 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2372 	}
2373 
2374 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2375 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2376 	}
2377 
2378 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2379 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2380 	}
2381 
2382 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2383 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2384 	}
2385 
2386 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2387 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2388 	}
2389 
2390 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2391 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2392 	}
2393 
2394 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2395 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2396 	}
2397 
2398 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2399 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2400 	}
2401 
2402 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2403 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2404 	}
2405 
2406 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2407 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2408 	}
2409 
2410 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2411 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2412 	}
2413 
2414 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2415 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2416 	}
2417 
2418 	function log(uint p0, uint p1, address p2, address p3) internal view {
2419 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2420 	}
2421 
2422 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2423 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2424 	}
2425 
2426 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2427 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2428 	}
2429 
2430 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2431 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2432 	}
2433 
2434 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2435 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2436 	}
2437 
2438 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2439 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2440 	}
2441 
2442 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2443 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2444 	}
2445 
2446 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2447 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2448 	}
2449 
2450 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2451 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2452 	}
2453 
2454 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2455 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2456 	}
2457 
2458 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2459 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2460 	}
2461 
2462 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2463 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2464 	}
2465 
2466 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2467 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2468 	}
2469 
2470 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2471 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2472 	}
2473 
2474 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2475 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2476 	}
2477 
2478 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2479 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2480 	}
2481 
2482 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2483 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2484 	}
2485 
2486 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2487 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2488 	}
2489 
2490 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2491 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2492 	}
2493 
2494 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2495 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2496 	}
2497 
2498 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2499 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2500 	}
2501 
2502 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2503 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2504 	}
2505 
2506 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2507 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2508 	}
2509 
2510 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2511 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2512 	}
2513 
2514 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2515 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2516 	}
2517 
2518 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2519 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2520 	}
2521 
2522 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2523 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2524 	}
2525 
2526 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2527 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2528 	}
2529 
2530 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2531 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2532 	}
2533 
2534 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2535 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2536 	}
2537 
2538 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2539 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2540 	}
2541 
2542 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2543 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2544 	}
2545 
2546 	function log(uint p0, bool p1, address p2, address p3) internal view {
2547 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2548 	}
2549 
2550 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2551 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2552 	}
2553 
2554 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2555 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2556 	}
2557 
2558 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2559 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2560 	}
2561 
2562 	function log(uint p0, address p1, uint p2, address p3) internal view {
2563 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2564 	}
2565 
2566 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2567 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2568 	}
2569 
2570 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2571 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2572 	}
2573 
2574 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2575 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2576 	}
2577 
2578 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2579 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2580 	}
2581 
2582 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2583 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2584 	}
2585 
2586 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2587 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2588 	}
2589 
2590 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2591 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2592 	}
2593 
2594 	function log(uint p0, address p1, bool p2, address p3) internal view {
2595 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2596 	}
2597 
2598 	function log(uint p0, address p1, address p2, uint p3) internal view {
2599 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2600 	}
2601 
2602 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2603 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2604 	}
2605 
2606 	function log(uint p0, address p1, address p2, bool p3) internal view {
2607 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2608 	}
2609 
2610 	function log(uint p0, address p1, address p2, address p3) internal view {
2611 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2612 	}
2613 
2614 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2615 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2616 	}
2617 
2618 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2619 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2620 	}
2621 
2622 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2623 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2624 	}
2625 
2626 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2627 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2628 	}
2629 
2630 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2631 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2632 	}
2633 
2634 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2635 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2636 	}
2637 
2638 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2639 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2640 	}
2641 
2642 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2643 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2644 	}
2645 
2646 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2647 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2648 	}
2649 
2650 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2651 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2652 	}
2653 
2654 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2655 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2656 	}
2657 
2658 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2659 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2660 	}
2661 
2662 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2663 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2664 	}
2665 
2666 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2667 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2668 	}
2669 
2670 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2671 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2672 	}
2673 
2674 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2675 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2676 	}
2677 
2678 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2679 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2680 	}
2681 
2682 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2683 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2684 	}
2685 
2686 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2687 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2688 	}
2689 
2690 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2691 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2692 	}
2693 
2694 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2695 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2696 	}
2697 
2698 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2699 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2700 	}
2701 
2702 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2703 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2704 	}
2705 
2706 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2707 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2708 	}
2709 
2710 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2711 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2712 	}
2713 
2714 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2715 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2716 	}
2717 
2718 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2719 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2720 	}
2721 
2722 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2723 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2724 	}
2725 
2726 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2727 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2728 	}
2729 
2730 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2731 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2732 	}
2733 
2734 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2735 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2736 	}
2737 
2738 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2739 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2740 	}
2741 
2742 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2743 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2744 	}
2745 
2746 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2747 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2748 	}
2749 
2750 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2751 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2752 	}
2753 
2754 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2755 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2756 	}
2757 
2758 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2759 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2760 	}
2761 
2762 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2763 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2764 	}
2765 
2766 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2767 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2768 	}
2769 
2770 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2771 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2772 	}
2773 
2774 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2775 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2776 	}
2777 
2778 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2779 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2780 	}
2781 
2782 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2783 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2784 	}
2785 
2786 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2787 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2788 	}
2789 
2790 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2791 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2792 	}
2793 
2794 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2795 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2796 	}
2797 
2798 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2799 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2800 	}
2801 
2802 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2803 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2804 	}
2805 
2806 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2807 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2808 	}
2809 
2810 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2811 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2812 	}
2813 
2814 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2815 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2816 	}
2817 
2818 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2819 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2820 	}
2821 
2822 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2823 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2824 	}
2825 
2826 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2827 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2828 	}
2829 
2830 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2831 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2832 	}
2833 
2834 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2835 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2836 	}
2837 
2838 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2839 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2840 	}
2841 
2842 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2843 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2844 	}
2845 
2846 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2847 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2848 	}
2849 
2850 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2851 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2852 	}
2853 
2854 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2855 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2856 	}
2857 
2858 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2859 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2860 	}
2861 
2862 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2863 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2864 	}
2865 
2866 	function log(string memory p0, address p1, address p2, address p3) internal view {
2867 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2868 	}
2869 
2870 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2871 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2872 	}
2873 
2874 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2875 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2876 	}
2877 
2878 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2879 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2880 	}
2881 
2882 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2883 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2884 	}
2885 
2886 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2887 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2888 	}
2889 
2890 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2891 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2892 	}
2893 
2894 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2895 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2896 	}
2897 
2898 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2899 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2900 	}
2901 
2902 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2903 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2904 	}
2905 
2906 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2907 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2908 	}
2909 
2910 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2911 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2912 	}
2913 
2914 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2915 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2916 	}
2917 
2918 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2919 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2920 	}
2921 
2922 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2923 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2924 	}
2925 
2926 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2927 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2928 	}
2929 
2930 	function log(bool p0, uint p1, address p2, address p3) internal view {
2931 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2932 	}
2933 
2934 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2935 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2936 	}
2937 
2938 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2939 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2940 	}
2941 
2942 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2943 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2944 	}
2945 
2946 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2947 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2948 	}
2949 
2950 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2951 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2952 	}
2953 
2954 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2955 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2956 	}
2957 
2958 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2959 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2960 	}
2961 
2962 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2963 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2964 	}
2965 
2966 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2967 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2968 	}
2969 
2970 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2971 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2972 	}
2973 
2974 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2975 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2976 	}
2977 
2978 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2979 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2980 	}
2981 
2982 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2983 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2984 	}
2985 
2986 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2987 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2988 	}
2989 
2990 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2991 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2992 	}
2993 
2994 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2995 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2996 	}
2997 
2998 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2999 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
3000 	}
3001 
3002 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
3003 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
3004 	}
3005 
3006 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
3007 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
3008 	}
3009 
3010 	function log(bool p0, bool p1, uint p2, address p3) internal view {
3011 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
3012 	}
3013 
3014 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
3015 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
3016 	}
3017 
3018 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
3019 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
3020 	}
3021 
3022 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
3023 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
3024 	}
3025 
3026 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
3027 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
3028 	}
3029 
3030 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
3031 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
3032 	}
3033 
3034 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
3035 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
3036 	}
3037 
3038 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
3039 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
3040 	}
3041 
3042 	function log(bool p0, bool p1, bool p2, address p3) internal view {
3043 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
3044 	}
3045 
3046 	function log(bool p0, bool p1, address p2, uint p3) internal view {
3047 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
3048 	}
3049 
3050 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
3051 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3052 	}
3053 
3054 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3055 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3056 	}
3057 
3058 	function log(bool p0, bool p1, address p2, address p3) internal view {
3059 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3060 	}
3061 
3062 	function log(bool p0, address p1, uint p2, uint p3) internal view {
3063 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
3064 	}
3065 
3066 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
3067 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
3068 	}
3069 
3070 	function log(bool p0, address p1, uint p2, bool p3) internal view {
3071 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
3072 	}
3073 
3074 	function log(bool p0, address p1, uint p2, address p3) internal view {
3075 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
3076 	}
3077 
3078 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
3079 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
3080 	}
3081 
3082 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3083 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3084 	}
3085 
3086 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3087 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3088 	}
3089 
3090 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3091 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3092 	}
3093 
3094 	function log(bool p0, address p1, bool p2, uint p3) internal view {
3095 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
3096 	}
3097 
3098 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3099 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3100 	}
3101 
3102 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3103 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3104 	}
3105 
3106 	function log(bool p0, address p1, bool p2, address p3) internal view {
3107 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3108 	}
3109 
3110 	function log(bool p0, address p1, address p2, uint p3) internal view {
3111 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
3112 	}
3113 
3114 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3115 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3116 	}
3117 
3118 	function log(bool p0, address p1, address p2, bool p3) internal view {
3119 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3120 	}
3121 
3122 	function log(bool p0, address p1, address p2, address p3) internal view {
3123 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3124 	}
3125 
3126 	function log(address p0, uint p1, uint p2, uint p3) internal view {
3127 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
3128 	}
3129 
3130 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
3131 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
3132 	}
3133 
3134 	function log(address p0, uint p1, uint p2, bool p3) internal view {
3135 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
3136 	}
3137 
3138 	function log(address p0, uint p1, uint p2, address p3) internal view {
3139 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
3140 	}
3141 
3142 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
3143 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
3144 	}
3145 
3146 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
3147 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
3148 	}
3149 
3150 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
3151 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
3152 	}
3153 
3154 	function log(address p0, uint p1, string memory p2, address p3) internal view {
3155 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
3156 	}
3157 
3158 	function log(address p0, uint p1, bool p2, uint p3) internal view {
3159 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
3160 	}
3161 
3162 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
3163 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
3164 	}
3165 
3166 	function log(address p0, uint p1, bool p2, bool p3) internal view {
3167 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
3168 	}
3169 
3170 	function log(address p0, uint p1, bool p2, address p3) internal view {
3171 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
3172 	}
3173 
3174 	function log(address p0, uint p1, address p2, uint p3) internal view {
3175 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
3176 	}
3177 
3178 	function log(address p0, uint p1, address p2, string memory p3) internal view {
3179 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
3180 	}
3181 
3182 	function log(address p0, uint p1, address p2, bool p3) internal view {
3183 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
3184 	}
3185 
3186 	function log(address p0, uint p1, address p2, address p3) internal view {
3187 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
3188 	}
3189 
3190 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
3191 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
3192 	}
3193 
3194 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
3195 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
3196 	}
3197 
3198 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
3199 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
3200 	}
3201 
3202 	function log(address p0, string memory p1, uint p2, address p3) internal view {
3203 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
3204 	}
3205 
3206 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
3207 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
3208 	}
3209 
3210 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3211 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3212 	}
3213 
3214 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3215 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3216 	}
3217 
3218 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3219 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3220 	}
3221 
3222 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
3223 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
3224 	}
3225 
3226 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3227 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3228 	}
3229 
3230 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3231 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3232 	}
3233 
3234 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3235 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3236 	}
3237 
3238 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3239 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3240 	}
3241 
3242 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3243 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3244 	}
3245 
3246 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3247 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3248 	}
3249 
3250 	function log(address p0, string memory p1, address p2, address p3) internal view {
3251 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3252 	}
3253 
3254 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3255 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3256 	}
3257 
3258 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3259 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3260 	}
3261 
3262 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3263 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3264 	}
3265 
3266 	function log(address p0, bool p1, uint p2, address p3) internal view {
3267 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3268 	}
3269 
3270 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3271 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3272 	}
3273 
3274 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3275 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3276 	}
3277 
3278 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3279 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3280 	}
3281 
3282 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3283 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3284 	}
3285 
3286 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3287 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3288 	}
3289 
3290 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3291 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3292 	}
3293 
3294 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3295 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3296 	}
3297 
3298 	function log(address p0, bool p1, bool p2, address p3) internal view {
3299 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3300 	}
3301 
3302 	function log(address p0, bool p1, address p2, uint p3) internal view {
3303 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3304 	}
3305 
3306 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3307 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3308 	}
3309 
3310 	function log(address p0, bool p1, address p2, bool p3) internal view {
3311 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3312 	}
3313 
3314 	function log(address p0, bool p1, address p2, address p3) internal view {
3315 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3316 	}
3317 
3318 	function log(address p0, address p1, uint p2, uint p3) internal view {
3319 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3320 	}
3321 
3322 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3323 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3324 	}
3325 
3326 	function log(address p0, address p1, uint p2, bool p3) internal view {
3327 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3328 	}
3329 
3330 	function log(address p0, address p1, uint p2, address p3) internal view {
3331 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3332 	}
3333 
3334 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3335 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3336 	}
3337 
3338 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3339 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3340 	}
3341 
3342 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3343 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3344 	}
3345 
3346 	function log(address p0, address p1, string memory p2, address p3) internal view {
3347 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3348 	}
3349 
3350 	function log(address p0, address p1, bool p2, uint p3) internal view {
3351 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3352 	}
3353 
3354 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3355 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3356 	}
3357 
3358 	function log(address p0, address p1, bool p2, bool p3) internal view {
3359 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3360 	}
3361 
3362 	function log(address p0, address p1, bool p2, address p3) internal view {
3363 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3364 	}
3365 
3366 	function log(address p0, address p1, address p2, uint p3) internal view {
3367 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3368 	}
3369 
3370 	function log(address p0, address p1, address p2, string memory p3) internal view {
3371 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3372 	}
3373 
3374 	function log(address p0, address p1, address p2, bool p3) internal view {
3375 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3376 	}
3377 
3378 	function log(address p0, address p1, address p2, address p3) internal view {
3379 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3380 	}
3381 
3382 }
3383 
3384 
3385 // File contracts/Admin.sol
3386 
3387 
3388 
3389 pragma solidity ^0.8.0;
3390 
3391 
3392 abstract contract Admin is Context {
3393     
3394     mapping(address=>uint) private _adminMap;
3395 
3396     // event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
3397 
3398     constructor() {
3399         _setAdmin(_msgSender(), 1);
3400     }
3401 
3402     /**
3403      * @dev Throws if called by any account other than the admin.
3404      */
3405     modifier onlyAdmin() {
3406         require(_adminMap[_msgSender()] == 1, "Admin: caller is not the admin");
3407         _;
3408     }
3409 
3410     /**
3411      * @dev Transfers admin of the contract to a new account (`newAdmin`).
3412      * Can only be called by the current admin.
3413      */
3414     function updateAdmin(address newAdmin, uint isAdmin) public virtual onlyAdmin {
3415         require(newAdmin != address(0), "Admin: new admin is the zero address");
3416         _setAdmin(newAdmin, isAdmin);
3417     }
3418 
3419 
3420     function _setAdmin(address newAdmin, uint isAdmin) private {
3421         _adminMap[newAdmin] = isAdmin;
3422     }
3423 }
3424 
3425 
3426 // File contracts/WasteLandUnionNFTV2.sol
3427 
3428 
3429 pragma solidity ^0.8.0;
3430 
3431 
3432 
3433 
3434 
3435 
3436 /**
3437 
3438 
3439  */
3440 contract WasteLandUnionNFTV2 is IWasteLandNFT, ERC721, Ownable, Admin {
3441     /**
3442     
3443      */
3444     address EQUIPMENT_CONTRACT;
3445 
3446     function updateEquipmentContract(address contractAddress) external onlyAdmin {
3447         EQUIPMENT_CONTRACT = contractAddress;
3448     } 
3449 
3450     function getEquipmentContractAddress() external view returns (address) {
3451         return EQUIPMENT_CONTRACT;
3452     }
3453 
3454     /**
3455         stage=>Limitation
3456      */
3457     mapping(uint=>PurchaseStageLimitation) purchaseStage;
3458 
3459     /**
3460         fixed top 4000 early purchaser
3461      */
3462     mapping(address=>uint) equipmentAirdrops;
3463 
3464     /**
3465         5 - 15 - 20 get abyxx NFT airdrops
3466      */
3467     mapping(address=>uint) abyxxAirdrops;
3468 
3469     /**
3470         @dev each account limitation
3471      */
3472     uint ACCOUNT_LIMITATION = 10;
3473 
3474     using SafeMath for uint256;
3475     using Counters for Counters.Counter;
3476 
3477     /// @dev base profile nft token
3478     uint256 public PROFILE_START_TOKEN_ID = 100000000000000;
3479     uint256 public PROFILE_NEXT_TOKEN_SPAN = 10000000000;
3480     
3481     /// @dev 
3482     uint256 public constant TOTAL_SUPPLY = 10000;
3483     uint256 public constant PRICE = 0.06 ether;
3484 
3485     /// @dev
3486     bool private PAUSE_SELLING = false;
3487     bool private REVEALED = false;
3488 
3489     bool private CAN_UPDATE_EQUIPMENT = false;
3490     
3491     Counters.Counter private _totalSold;
3492 
3493     /// dev 
3494     mapping(address=>uint256[]) ownedToken;
3495 
3496     /// original token => updated token
3497     mapping(uint256=>uint256) updatedToken;
3498 
3499     /// updated token => original token
3500     mapping(uint256=>uint256) orginalTokenMapping;
3501 
3502     /// @dev anyone purchase token from Wastelandunion or thirdparty platform, the time they purchased will be recored
3503     mapping(uint256=>uint256) tokenPurchaseTime;
3504 
3505     /// @dev 
3506     string private baseTokenURI; 
3507 
3508     /// @dev 
3509     string private revealedURI;
3510 
3511     string private defaultURI = "https://wastelandunion.com/WASTELAND_D1.json";
3512     
3513     address OwnerAddress = 0x4A4bE24E17e96a9cdBdCcd8391fD8387e98403D5;
3514 
3515     /// 
3516     constructor() ERC721("WasteLandUnionNFT", "WLN") {
3517         transferOwnership(OwnerAddress);
3518     }
3519 
3520     modifier saleIsOpen {
3521         require(totalSold() <= TOTAL_SUPPLY, "Soldout!");
3522         require(!PAUSE_SELLING, "Sales not open");
3523         _;
3524     }
3525 
3526     function setRevealedURI(string memory _revealedURI) public override onlyAdmin {
3527         revealedURI = _revealedURI;
3528     }
3529 
3530     function setBaseURI(string memory _baseURI) external override onlyAdmin {
3531         baseTokenURI = _baseURI;
3532     }
3533 
3534     function totalSold() public view returns (uint256) {
3535         return _totalSold.current();
3536     }
3537 
3538     function setRevealed(bool revealed) external onlyAdmin {
3539         REVEALED = revealed;
3540     }
3541 
3542     function setDefaultURI(string memory _defaultURI) external onlyAdmin {
3543         defaultURI = _defaultURI;
3544     }
3545 
3546     function tokenURI(uint tokenId) public view override(ERC721) returns (string memory) {
3547 
3548         if (REVEALED) {
3549             uint256 viewTokenId = updatedToken[tokenId];
3550             if (viewTokenId == 0) {
3551                 viewTokenId = tokenId;
3552             }
3553             return string(abi.encodePacked(baseTokenURI, revealedURI, Strings.toString(viewTokenId), ".json"));
3554         }
3555 
3556         return defaultURI;
3557     }
3558 
3559 
3560     /**
3561         @dev
3562      */
3563     function whitelistAvailableQuery(uint stage, address purchaseUser) external view returns (uint) {
3564 
3565         PurchaseStageLimitation storage stageLimitation = purchaseStage[stage];
3566         require(stageLimitation.exist == 1, "WastelandUnion: purchase not open yet(1).");
3567 
3568         uint purchaseLimit = 0;
3569         for(uint i=0; i<stageLimitation.purchaseLimit.length; i++) {
3570             address[] memory whitelists = stageLimitation.purchaseLimit[i].whitelist;
3571             for (uint j=0; j<whitelists.length; j++) {
3572                 if (whitelists[j] == purchaseUser) {
3573                     purchaseLimit = stageLimitation.purchaseLimit[i].purchaseLimit;
3574                     return purchaseLimit;
3575                 }
3576             }
3577         }
3578         return 0;
3579     }
3580 
3581 
3582     function updatePurchaseStageLimitation(uint stage, uint256 start, uint256 end) public onlyAdmin {
3583         PurchaseStageLimitation storage stageLimitation = purchaseStage[stage];
3584         stageLimitation.stage = stage;
3585         stageLimitation.start = start;
3586         stageLimitation.end = end;
3587         stageLimitation.exist = 1; 
3588     } 
3589 
3590 
3591     function updatePurchaseStageWhiteList(uint stage, address[] memory _whitelist, uint _purchaseLimit) public onlyAdmin {
3592         PurchaseStageLimitation storage stageLimitation = purchaseStage[stage];
3593         WhitelistPurchaseLimit memory purchaseWhitelist = WhitelistPurchaseLimit({whitelist:_whitelist, purchaseLimit:_purchaseLimit});
3594         stageLimitation.purchaseLimit.push(purchaseWhitelist);
3595     }
3596 
3597 
3598     function queryWhiteList(uint stage, uint index) public view onlyAdmin returns (address[] memory) {
3599 
3600         PurchaseStageLimitation storage stageLimitation = purchaseStage[stage];
3601         WhitelistPurchaseLimit memory purchaseWhitelist = stageLimitation.purchaseLimit[index];
3602         return purchaseWhitelist.whitelist;
3603     }
3604 
3605 
3606     function baseRequire(address purchaseUser, uint amount) private {
3607 
3608         require(PAUSE_SELLING == false, "WastelandUnion: Not start selling yet(1)");
3609         require(amount >= 1, "WastelandUnion: at least purchase 1");
3610         require(amount <= 5, "WastelandUnion: at most purchase 5");
3611         require(msg.value >= (PRICE * amount), "WastelandUnion: insufficient value"); // must send 10 ether to play
3612 
3613         isEnoughSupply(amount, true);
3614 
3615         
3616         /*
3617         PurchaseStageLimitation storage stageLimitation = purchaseStage[stage];
3618         require(stageLimitation.exist == 1, "WastelandUnion: purchase not open yet(1).");
3619 
3620         uint256 start = stageLimitation.start;
3621         uint256 end = stageLimitation.end;
3622 
3623         // console.log("start %d, end %d, blocktime: %d", start, end, block.timestamp);
3624 
3625         if (start != 0 && block.timestamp < start) {
3626             require(false, "WastelandUnion: Not start yet(2)");
3627         } 
3628         
3629         if (end != 0 && block.timestamp > end) {
3630             require(false, "WastelandUnion: Purchase stage end");
3631         }
3632 
3633         if (stageLimitation.purchaseLimit.length == 0) {
3634             // no white list
3635             return;
3636         }
3637         
3638         bool inWhitelist = false;
3639         uint purchaseLimit = 0;
3640 
3641         for(uint i=0; i<stageLimitation.purchaseLimit.length; i++) {
3642             address[] memory whitelists = stageLimitation.purchaseLimit[i].whitelist;
3643             for (uint j=0; j<whitelists.length; j++) {
3644                 if (whitelists[j] == purchaseUser) {
3645                     purchaseLimit = stageLimitation.purchaseLimit[i].purchaseLimit;
3646                     inWhitelist = true;
3647                     break;
3648                 }
3649             }
3650         }
3651 
3652         require(inWhitelist, "WastelandUnion: Should be in the white list"); 
3653 
3654         uint[] storage tokens = ownedToken[purchaseUser];
3655         if (tokens.length >= purchaseLimit) { 
3656             require(false, "WastelandUnion: purchase limited(1)");
3657         } 
3658 
3659         if (tokens.length + amount > purchaseLimit) {
3660             require(false, "WastelandUnion: purchase limited(2)");
3661         }
3662 
3663         */
3664 
3665     }
3666 
3667     /**
3668      */
3669     function isEnoughSupply(uint amount, bool needReportError) private view returns (bool) {
3670 
3671         uint256 solded = totalSold();
3672 
3673         uint256 afterPurchase = solded + amount;
3674         if (needReportError) {
3675             require(afterPurchase <= TOTAL_SUPPLY, "WastelandUnion: Max limit");
3676             return true;
3677         } else {
3678             if (afterPurchase <= TOTAL_SUPPLY) {
3679                 return true;
3680             } else {
3681                 return false;
3682             }
3683         }
3684     }
3685 
3686 
3687     /**
3688 
3689      */
3690     function claimAirdropAmount(uint claimType) public view returns(uint) {
3691         address claimAddress = msg.sender;
3692         uint amount = 0;
3693         if (claimType == 1) {
3694             amount = equipmentAirdrops[claimAddress];
3695 
3696         } else if (claimType == 2) {
3697             amount = abyxxAirdrops[claimAddress];
3698         }
3699 
3700         // console.log(amount);
3701         return amount;
3702     }
3703 
3704 
3705     function removeToken(address owner, uint256 profileTokenId) private {
3706         uint[] storage tokens = ownedToken[owner];
3707         bool findIndex = false;
3708         for (uint i=0; i<tokens.length-1; i++){
3709             console.log("compare : %d, %d, %s", profileTokenId, tokens[i], findIndex);
3710             if (findIndex == true) {
3711                 tokens[i] = tokens[i+1];
3712             } else {
3713                 if (tokens[i] == profileTokenId) {
3714                     tokens[i] = tokens[i+1];
3715                     findIndex = true;
3716                 }
3717             }
3718         }
3719 
3720         // check the last one
3721         if (!findIndex) {
3722             if (tokens[tokens.length - 1] == profileTokenId) {
3723                 findIndex = true;
3724             }
3725         }
3726 
3727         if (findIndex) {
3728             // remove
3729             tokens.pop(); 
3730         }
3731     }
3732 
3733 
3734     /// @dev inner method to verify the owner of the token
3735     function isOwner(uint256 tokenId, address owner) private view returns(bool) {
3736         uint256[] memory ownedTokens = ownedToken[owner];
3737         for (uint i = 0; i<ownedTokens.length; i++) {
3738             if (ownedTokens[i] == tokenId) {
3739                 return true;
3740             }
3741 
3742             uint256 mappedUpdatedToken = updatedToken[ownedTokens[i]];
3743             if (mappedUpdatedToken == tokenId) {
3744                 return true;
3745             }
3746 
3747         }
3748         return false;
3749     } 
3750 
3751 
3752     /// @dev 
3753     function isTokenOwner(uint256 tokenId, address owner) external view override returns(bool) { 
3754         return isOwner(tokenId, owner);
3755     } 
3756 
3757 
3758     function purchase(uint amount) external payable returns (bool) {
3759         // console.log("purchase user: %s", msg.sender); 
3760         address purchaseUser = msg.sender;
3761 
3762         baseRequire(purchaseUser, amount);
3763 
3764         uint[] storage tokens = ownedToken[purchaseUser];
3765         if (tokens.length + amount > ACCOUNT_LIMITATION) {
3766             require(false, "WastelandUnion: purchase limited(3) 10 NFTs at most");
3767         } 
3768 
3769         for (uint256 i = 0; i < amount; i++) {
3770             _mintOne(purchaseUser, PROFILE_START_TOKEN_ID);
3771             tokens.push(PROFILE_START_TOKEN_ID);
3772             PROFILE_START_TOKEN_ID = PROFILE_START_TOKEN_ID + PROFILE_NEXT_TOKEN_SPAN;
3773 
3774             tokenPurchaseTime[PROFILE_START_TOKEN_ID] = block.timestamp;
3775             emit Purchase(PROFILE_START_TOKEN_ID, purchaseUser);
3776 
3777             /// @dev for airdrop
3778             if (totalSold() <= 4000) { 
3779                 equipmentAirdrops[purchaseUser] ++ ;
3780             }
3781 
3782             if (totalSold() % 5 == 0 && totalSold() > 1 ) {
3783                 // console.log("%d, %d, %d", abyxxAirdrops.length, totalSold() % 5, totalSold());
3784                 abyxxAirdrops[purchaseUser]++;
3785             }
3786 
3787         }
3788         ownedToken[purchaseUser] = tokens;
3789         return true;
3790     }
3791 
3792 
3793     function listMine() external view returns (uint256[] memory) {
3794         return ownedToken[msg.sender];
3795     }
3796 
3797     function _mintOne(address _to, uint256 _tokenId) private { 
3798         _totalSold.increment();
3799         _safeMint(_to, _tokenId);
3800     }
3801 
3802 
3803     function setPause(bool _pause) public onlyAdmin {
3804         PAUSE_SELLING = _pause;
3805         emit PauseEvent(PAUSE_SELLING);
3806     }
3807 
3808 
3809     function withdraw() public override onlyOwner {
3810         payable(msg.sender).transfer(address(this).balance);
3811     }
3812 
3813     /**
3814     
3815      */
3816     function batchMint(address wallet, uint amount) external onlyAdmin {
3817 
3818         isEnoughSupply(amount, true);
3819 
3820         uint[] storage tokens = ownedToken[wallet];
3821 
3822         for (uint256 i = 0; i < amount; i++) {
3823             _mintOne(wallet, PROFILE_START_TOKEN_ID);
3824             tokens.push(PROFILE_START_TOKEN_ID);
3825             PROFILE_START_TOKEN_ID = PROFILE_START_TOKEN_ID + PROFILE_NEXT_TOKEN_SPAN;
3826         }
3827 
3828         ownedToken[wallet] = tokens;
3829     } 
3830 
3831     function transferFrom(
3832         address from,
3833         address to,
3834         uint256 tokenId
3835     ) public override {
3836 
3837         removeToken(from, tokenId);
3838         super.transferFrom(from, to, tokenId);
3839         uint[] storage tokens = ownedToken[to];
3840         tokens.push(tokenId);
3841         tokenPurchaseTime[tokenId] = block.timestamp;
3842 
3843     }
3844 
3845     function specialMint(uint256 tokenId, address wallet) public onlyAdmin {
3846         uint[] storage tokens = ownedToken[wallet];
3847         _safeMint(wallet, tokenId);
3848         tokens.push(tokenId);
3849     }
3850 
3851 
3852     function getTokenPurchaseTime(uint256 tokenId) external override view returns(uint256) {
3853         return tokenPurchaseTime[tokenId];
3854     }
3855 
3856     function myUpdatedToken(uint256 tokenId) public view returns(uint256) {
3857         return updatedToken[tokenId];
3858     }
3859 
3860     function myOriginalToken(uint256 tokenId) public view returns(uint256) {
3861         return orginalTokenMapping[tokenId];
3862     }
3863 
3864     function updateEquipment(uint256 profileTokenId, uint256 equipmentTokenId) public {
3865 
3866         address requireUserAddress = msg.sender;
3867         // console.log(EQUIPMENT_CONTRACT);
3868 
3869         bool isEquipmentTokenOwner = INFTEquipment(EQUIPMENT_CONTRACT).isTokenOwner(equipmentTokenId, requireUserAddress);
3870 
3871         // console.log(isEquipmentTokenOwner);
3872         require(isEquipmentTokenOwner, "WastelandUnion: should be owner1.");
3873 
3874         bool isProfileOwner = isOwner(profileTokenId, requireUserAddress);
3875         require(isProfileOwner, "WastelandUnion: should be owner2.");
3876 
3877         uint256 origialProfile = orginalTokenMapping[profileTokenId];
3878         if (origialProfile == 0) {
3879             origialProfile = profileTokenId;
3880         }
3881 
3882         uint256 currentUpdatedProfile = updatedToken[origialProfile];
3883         if (currentUpdatedProfile == 0) { 
3884             currentUpdatedProfile = profileTokenId;
3885         }
3886 
3887         require(profileTokenId == currentUpdatedProfile, "WastelandUnion: Should be the same");
3888         uint256 nowUpdatedToken = INFTEquipment(EQUIPMENT_CONTRACT).doEquipment(profileTokenId, equipmentTokenId, requireUserAddress);
3889 
3890         updatedToken[origialProfile] = nowUpdatedToken;
3891         orginalTokenMapping[nowUpdatedToken] = origialProfile;
3892 
3893         delete orginalTokenMapping[currentUpdatedProfile];
3894 
3895     } 
3896 
3897     function getOwnedTokenAmount(address useraddress) external override view returns(uint) {
3898         return ownedToken[useraddress].length;
3899     }
3900 
3901 }