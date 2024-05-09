1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
172 
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
200 
201 
202 pragma solidity ^0.8.0;
203 
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
226 // File: @openzeppelin/contracts/utils/Address.sol
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         uint256 size;
258         assembly {
259             size := extcodesize(account)
260         }
261         return size > 0;
262     }
263 
264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");
282 
283         (bool success, ) = recipient.call{value: amount}("");
284         require(success, "Address: unable to send value, recipient may have reverted");
285     }
286 
287     /**
288      * @dev Performs a Solidity function call using a low level `call`. A
289      * plain `call` is an unsafe replacement for a function call: use this
290      * function instead.
291      *
292      * If `target` reverts with a revert reason, it is bubbled up by this
293      * function (like regular Solidity function calls).
294      *
295      * Returns the raw returned data. To convert to the expected return value,
296      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297      *
298      * Requirements:
299      *
300      * - `target` must be a contract.
301      * - calling `target` with `data` must not revert.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306         return functionCall(target, data, "Address: low-level call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         require(isContract(target), "Address: call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.call{value: value}(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.staticcall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(isContract(target), "Address: delegate call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.delegatecall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
417      * revert reason using the provided one.
418      *
419      * _Available since v4.3._
420      */
421     function verifyCallResult(
422         bool success,
423         bytes memory returndata,
424         string memory errorMessage
425     ) internal pure returns (bytes memory) {
426         if (success) {
427             return returndata;
428         } else {
429             // Look for revert reason and bubble it up if present
430             if (returndata.length > 0) {
431                 // The easiest way to bubble the revert reason is using memory via assembly
432 
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/Context.sol
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Provides information about the current execution context, including the
451  * sender of the transaction and its data. While these are generally available
452  * via msg.sender and msg.data, they should not be accessed in such a direct
453  * manner, since when dealing with meta-transactions the account sending and
454  * paying for execution may not be the actual sender (as far as an application
455  * is concerned).
456  *
457  * This contract is only required for intermediate, library-like contracts.
458  */
459 abstract contract Context {
460     function _msgSender() internal view virtual returns (address) {
461         return msg.sender;
462     }
463 
464     function _msgData() internal view virtual returns (bytes calldata) {
465         return msg.data;
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Strings.sol
470 
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev String operations.
476  */
477 library Strings {
478     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
482      */
483     function toString(uint256 value) internal pure returns (string memory) {
484         // Inspired by OraclizeAPI's implementation - MIT licence
485         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
486 
487         if (value == 0) {
488             return "0";
489         }
490         uint256 temp = value;
491         uint256 digits;
492         while (temp != 0) {
493             digits++;
494             temp /= 10;
495         }
496         bytes memory buffer = new bytes(digits);
497         while (value != 0) {
498             digits -= 1;
499             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
500             value /= 10;
501         }
502         return string(buffer);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
507      */
508     function toHexString(uint256 value) internal pure returns (string memory) {
509         if (value == 0) {
510             return "0x00";
511         }
512         uint256 temp = value;
513         uint256 length = 0;
514         while (temp != 0) {
515             length++;
516             temp >>= 8;
517         }
518         return toHexString(value, length);
519     }
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
523      */
524     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
525         bytes memory buffer = new bytes(2 * length + 2);
526         buffer[0] = "0";
527         buffer[1] = "x";
528         for (uint256 i = 2 * length + 1; i > 1; --i) {
529             buffer[i] = _HEX_SYMBOLS[value & 0xf];
530             value >>= 4;
531         }
532         require(value == 0, "Strings: hex length insufficient");
533         return string(buffer);
534     }
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 
573 
574 
575 
576 
577 
578 /**
579  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
580  * the Metadata extension, but not including the Enumerable extension, which is available separately as
581  * {ERC721Enumerable}.
582  */
583 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
584     using Address for address;
585     using Strings for uint256;
586 
587     // Token name
588     string private _name;
589 
590     // Token symbol
591     string private _symbol;
592 
593     // Mapping from token ID to owner address
594     mapping(uint256 => address) private _owners;
595 
596     // Mapping owner address to token count
597     mapping(address => uint256) private _balances;
598 
599     // Mapping from token ID to approved address
600     mapping(uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     /**
606      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
607      */
608     constructor(string memory name_, string memory symbol_) {
609         _name = name_;
610         _symbol = symbol_;
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
617         return
618             interfaceId == type(IERC721).interfaceId ||
619             interfaceId == type(IERC721Metadata).interfaceId ||
620             super.supportsInterface(interfaceId);
621     }
622 
623     /**
624      * @dev See {IERC721-balanceOf}.
625      */
626     function balanceOf(address owner) public view virtual override returns (uint256) {
627         require(owner != address(0), "ERC721: balance query for the zero address");
628         return _balances[owner];
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
635         address owner = _owners[tokenId];
636         require(owner != address(0), "ERC721: owner query for nonexistent token");
637         return owner;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-name}.
642      */
643     function name() public view virtual override returns (string memory) {
644         return _name;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-symbol}.
649      */
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-tokenURI}.
656      */
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
659 
660         string memory baseURI = _baseURI();
661         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
662     }
663 
664     /**
665      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
666      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
667      * by default, can be overriden in child contracts.
668      */
669     function _baseURI() internal view virtual returns (string memory) {
670         return "";
671     }
672 
673     /**
674      * @dev See {IERC721-approve}.
675      */
676     function approve(address to, uint256 tokenId) public virtual override {
677         address owner = ERC721.ownerOf(tokenId);
678         require(to != owner, "ERC721: approval to current owner");
679 
680         require(
681             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
682             "ERC721: approve caller is not owner nor approved for all"
683         );
684 
685         _approve(to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-getApproved}.
690      */
691     function getApproved(uint256 tokenId) public view virtual override returns (address) {
692         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
693 
694         return _tokenApprovals[tokenId];
695     }
696 
697     /**
698      * @dev See {IERC721-setApprovalForAll}.
699      */
700     function setApprovalForAll(address operator, bool approved) public virtual override {
701         require(operator != _msgSender(), "ERC721: approve to caller");
702 
703         _operatorApprovals[_msgSender()][operator] = approved;
704         emit ApprovalForAll(_msgSender(), operator, approved);
705     }
706 
707     /**
708      * @dev See {IERC721-isApprovedForAll}.
709      */
710     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
711         return _operatorApprovals[owner][operator];
712     }
713 
714     /**
715      * @dev See {IERC721-transferFrom}.
716      */
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         //solhint-disable-next-line max-line-length
723         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
724 
725         _transfer(from, to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         safeTransferFrom(from, to, tokenId, "");
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes memory _data
747     ) public virtual override {
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749         _safeTransfer(from, to, tokenId, _data);
750     }
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
757      *
758      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
759      * implement alternative mechanisms to perform token transfer, such as signature-based.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeTransfer(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) internal virtual {
776         _transfer(from, to, tokenId);
777         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
778     }
779 
780     /**
781      * @dev Returns whether `tokenId` exists.
782      *
783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
784      *
785      * Tokens start existing when they are minted (`_mint`),
786      * and stop existing when they are burned (`_burn`).
787      */
788     function _exists(uint256 tokenId) internal view virtual returns (bool) {
789         return _owners[tokenId] != address(0);
790     }
791 
792     /**
793      * @dev Returns whether `spender` is allowed to manage `tokenId`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
800         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
801         address owner = ERC721.ownerOf(tokenId);
802         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
803     }
804 
805     /**
806      * @dev Safely mints `tokenId` and transfers it to `to`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeMint(address to, uint256 tokenId) internal virtual {
816         _safeMint(to, tokenId, "");
817     }
818 
819     /**
820      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
821      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
822      */
823     function _safeMint(
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) internal virtual {
828         _mint(to, tokenId);
829         require(
830             _checkOnERC721Received(address(0), to, tokenId, _data),
831             "ERC721: transfer to non ERC721Receiver implementer"
832         );
833     }
834 
835     /**
836      * @dev Mints `tokenId` and transfers it to `to`.
837      *
838      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - `to` cannot be the zero address.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _mint(address to, uint256 tokenId) internal virtual {
848         require(to != address(0), "ERC721: mint to the zero address");
849         require(!_exists(tokenId), "ERC721: token already minted");
850 
851         _beforeTokenTransfer(address(0), to, tokenId);
852 
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(address(0), to, tokenId);
857     }
858 
859     /**
860      * @dev Destroys `tokenId`.
861      * The approval is cleared when the token is burned.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _burn(uint256 tokenId) internal virtual {
870         address owner = ERC721.ownerOf(tokenId);
871 
872         _beforeTokenTransfer(owner, address(0), tokenId);
873 
874         // Clear approvals
875         _approve(address(0), tokenId);
876 
877         _balances[owner] -= 1;
878         delete _owners[tokenId];
879 
880         emit Transfer(owner, address(0), tokenId);
881     }
882 
883     /**
884      * @dev Transfers `tokenId` from `from` to `to`.
885      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
886      *
887      * Requirements:
888      *
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _transfer(
895         address from,
896         address to,
897         uint256 tokenId
898     ) internal virtual {
899         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
900         require(to != address(0), "ERC721: transfer to the zero address");
901 
902         _beforeTokenTransfer(from, to, tokenId);
903 
904         // Clear approvals from the previous owner
905         _approve(address(0), tokenId);
906 
907         _balances[from] -= 1;
908         _balances[to] += 1;
909         _owners[tokenId] = to;
910 
911         emit Transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev Approve `to` to operate on `tokenId`
916      *
917      * Emits a {Approval} event.
918      */
919     function _approve(address to, uint256 tokenId) internal virtual {
920         _tokenApprovals[tokenId] = to;
921         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
922     }
923 
924     /**
925      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
926      * The call is not executed if the target address is not a contract.
927      *
928      * @param from address representing the previous owner of the given token ID
929      * @param to target address that will receive the tokens
930      * @param tokenId uint256 ID of the token to be transferred
931      * @param _data bytes optional data to send along with the call
932      * @return bool whether the call correctly returned the expected magic value
933      */
934     function _checkOnERC721Received(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) private returns (bool) {
940         if (to.isContract()) {
941             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
942                 return retval == IERC721Receiver.onERC721Received.selector;
943             } catch (bytes memory reason) {
944                 if (reason.length == 0) {
945                     revert("ERC721: transfer to non ERC721Receiver implementer");
946                 } else {
947                     assembly {
948                         revert(add(32, reason), mload(reason))
949                     }
950                 }
951             }
952         } else {
953             return true;
954         }
955     }
956 
957     /**
958      * @dev Hook that is called before any token transfer. This includes minting
959      * and burning.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, ``from``'s `tokenId` will be burned.
967      * - `from` and `to` are never both zero.
968      *
969      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
970      */
971     function _beforeTokenTransfer(
972         address from,
973         address to,
974         uint256 tokenId
975     ) internal virtual {}
976 }
977 
978 // File: @openzeppelin/contracts/access/Ownable.sol
979 
980 
981 pragma solidity ^0.8.0;
982 
983 
984 /**
985  * @dev Contract module which provides a basic access control mechanism, where
986  * there is an account (an owner) that can be granted exclusive access to
987  * specific functions.
988  *
989  * By default, the owner account will be the one that deploys the contract. This
990  * can later be changed with {transferOwnership}.
991  *
992  * This module is used through inheritance. It will make available the modifier
993  * `onlyOwner`, which can be applied to your functions to restrict their use to
994  * the owner.
995  */
996 abstract contract Ownable is Context {
997     address private _owner;
998 
999     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1000 
1001     /**
1002      * @dev Initializes the contract setting the deployer as the initial owner.
1003      */
1004     constructor() {
1005         _setOwner(_msgSender());
1006     }
1007 
1008     /**
1009      * @dev Returns the address of the current owner.
1010      */
1011     function owner() public view virtual returns (address) {
1012         return _owner;
1013     }
1014 
1015     /**
1016      * @dev Throws if called by any account other than the owner.
1017      */
1018     modifier onlyOwner() {
1019         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1020         _;
1021     }
1022 
1023     /**
1024      * @dev Leaves the contract without owner. It will not be possible to call
1025      * `onlyOwner` functions anymore. Can only be called by the current owner.
1026      *
1027      * NOTE: Renouncing ownership will leave the contract without an owner,
1028      * thereby removing any functionality that is only available to the owner.
1029      */
1030     function renounceOwnership() public virtual onlyOwner {
1031         _setOwner(address(0));
1032     }
1033 
1034     /**
1035      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1036      * Can only be called by the current owner.
1037      */
1038     function transferOwnership(address newOwner) public virtual onlyOwner {
1039         require(newOwner != address(0), "Ownable: new owner is the zero address");
1040         _setOwner(newOwner);
1041     }
1042 
1043     function _setOwner(address newOwner) private {
1044         address oldOwner = _owner;
1045         _owner = newOwner;
1046         emit OwnershipTransferred(oldOwner, newOwner);
1047     }
1048 }
1049 
1050 // File: contracts/interface/MinterMintable.sol
1051 
1052 pragma solidity ^0.8.7;
1053 
1054 interface MinterMintable {
1055     function isMinter(address check) external view returns (bool);
1056     function mint(address owner) external returns (uint256);
1057     function batchMint(address owner, uint256 amount) external returns (uint256[] memory);
1058 }
1059 
1060 // File: contracts/interface/GhettoSharkhoodInterface.sol
1061 
1062 pragma solidity ^0.8.7;
1063 
1064 interface GhettoSharkhoodInterface {
1065     function isRevealed() external view returns (bool);
1066     function sequenceId(uint256 tokenId) external view returns (uint256);
1067     function batchMax() external view returns (uint256);
1068 }
1069 
1070 // File: contracts/GhettoSharkhood.sol
1071 
1072 pragma solidity ^0.8.7;
1073 
1074 
1075 
1076 
1077 
1078 
1079 contract GhettoSharkhood is ERC721, Ownable, MinterMintable, GhettoSharkhoodInterface {
1080 
1081     constructor() ERC721("GhettoSharkhood", "GSH") {
1082 
1083     }
1084 
1085     // minters 
1086 
1087     mapping(address => bool) _isMinter_;
1088 
1089     modifier onlyMinter() {
1090         require(_isMinter_[msg.sender], "GhettoSharkhood: msg.sender is not a minter");
1091         _;
1092     }
1093 
1094     /**
1095      * This function is to get check whether the address is a minter.
1096      */
1097     function isMinter(address addr) external view override returns (bool) {
1098         return _isMinter_[addr];
1099     }
1100 
1101     function setMinter(address addr, bool status) external onlyOwner {
1102         _isMinter_[addr] = status;
1103     }
1104 
1105     // Blackbox control
1106 
1107     /**
1108      * The boolean value that saving the status of revealing.
1109      */
1110     bool private _isRevealed_ = false;
1111 
1112     /**
1113      * The offset of NFT
1114      */
1115     uint256 _offset_ = 0;
1116 
1117     /**
1118      * This event will be triggered after revealing.
1119      */
1120     event Revealed();
1121 
1122     /**
1123      * This is an owner only function
1124      * this function will set revealed to true, and generate a random offset less than totalSupply;
1125      */
1126     function reveal() public onlyOwner {
1127         require(_baseURILocked_, "GhettoSharkhood: Base URI should be locked before revealing.");
1128         _isRevealed_ = true;
1129         _offset_ = randomNumber();
1130 
1131         emit Revealed();
1132     }
1133 
1134     /**
1135      * The view function to the status of revealing.
1136      */
1137     function isRevealed() external override view returns (bool) {
1138         return _isRevealed_;
1139     }
1140 
1141     // Base URI
1142 
1143     bool _baseURILocked_ = false;
1144     string private _baseURI_ = "";
1145     string private _placeholderBaseURI_ = "ipfs://QmQYq3gcXzpsUqorNwt8iBoU5u6xVzjDoffGbV6fijbryK/";
1146 
1147     function lockBaseURI() public onlyOwner {
1148         require(bytes(_baseURI_).length > 0, "GhettoSharkhood: Base URI should be set before locking.");
1149         _baseURILocked_ = true;
1150     }
1151 
1152     /**
1153      * This function is an owner only function, it can change baseURI.
1154      */
1155     function setBaseURI(string memory uri) public onlyOwner {
1156         require(!_baseURILocked_, "GhettoSharkhodd: BaseURI has been locked, it cannot be changed anymore.");
1157         _baseURI_ = uri;
1158     }
1159 
1160     /**
1161      * This function overrides the function defined in ERC721 contract
1162      */
1163     function _baseURI() internal view override returns (string memory) {
1164         return _baseURI_;
1165     }
1166 
1167     /**
1168      * This function will return the real NFT base uri.
1169      */
1170     function baseURI() public view returns (string memory) {
1171         return _baseURI();
1172     }
1173 
1174     /**
1175      * This function is an owner only function, it can change placeholder baseURI.
1176      */
1177     function setPlaceholderBaseURI(string memory uri) public onlyOwner {
1178         _placeholderBaseURI_ = uri;
1179     }
1180 
1181     /**
1182      * This function will return the placeholder base uri.
1183      */
1184     function placeholderBaseURI() public view returns (string memory) {
1185         return _placeholderBaseURI_;
1186     }
1187 
1188     // NFT
1189 
1190     uint256 _totalSupply_ = 10000;
1191 
1192     uint256 _currentTokenId_ = 0;
1193 
1194     /**
1195      * This variable keep the max size of batch to avoid out of gas exception.
1196      */
1197     uint256 _batchMax_ = 100;
1198 
1199     /**
1200      * This modifier will calculate whether it will exceed the totalSupply after minting or not.
1201      */
1202     modifier enoughToMint(uint256 amount) {
1203         require(
1204             amount <= _totalSupply_ 
1205             && _currentTokenId_ + amount > _currentTokenId_
1206             && _currentTokenId_ + amount <= _totalSupply_, "GhettoSharkhood: GhettoSharkhoold are all minted.");
1207         _;
1208     }
1209 
1210     /**
1211      * This modifier will limit the amount larger than batch size.
1212      */
1213     modifier underMaxBatchSize(uint256 amount) {
1214         require(amount <= _batchMax_, "GhettoSharkhood: over the limit of batch size.");
1215         _;
1216     }
1217 
1218     /**
1219      * This function can only be called by minter, it will mint 1 NFT to specified owner.
1220      */
1221     function mint(address owner) external override onlyMinter enoughToMint(1) returns (uint256) {
1222         return (mintSpeficiedAmount(owner, 1))[0];
1223     }
1224 
1225     /**
1226      * This function can only called by minter, it will mint specified amount of NFT to specified owner.
1227      */
1228     function batchMint(address owner, uint256 amount) external override 
1229         onlyMinter
1230         enoughToMint(amount) 
1231         underMaxBatchSize(amount) 
1232         returns (uint256[] memory) {
1233         require(amount >= 1, "GhettoShakhood: amount should larger than 0.");
1234         return mintSpeficiedAmount(owner, amount);
1235     }
1236 
1237     /**
1238      * This is an internal function, and it is the real operator to mint NFT to user,
1239      * it will return an array of tokenID after minting.
1240      */
1241     function mintSpeficiedAmount(address owner, uint256 amount) internal returns (uint256[] memory) {
1242         uint256[] memory minted_ = new uint256[](amount);
1243 
1244         for(uint256 i = 0; i < amount; i ++) {
1245             uint256 tokenIdToMint = _currentTokenId_ + i + 1;
1246             _safeMint(owner, tokenIdToMint);
1247             minted_[i] = tokenIdToMint;
1248         }
1249 
1250         _currentTokenId_ += amount;
1251 
1252         return minted_;
1253     }
1254 
1255     /**
1256      * This function overrides the function defined in ERC721 contract,
1257      * before revealing or baseURI has not been set, it will always return the placeholder.
1258      * otherwise, the sequenceId will be calculated and combined to tokenURI.
1259      */
1260     function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1261         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1262 
1263         if (!_isRevealed_) {
1264             return bytes(_placeholderBaseURI_).length > 0 ? 
1265                 string(abi.encodePacked(_placeholderBaseURI_, Strings.toString(tokenId_), ".json")) : "";
1266         }
1267 
1268         return bytes(_baseURI_).length > 0 ? 
1269             string(abi.encodePacked(_baseURI_, Strings.toString(_sequenceId(tokenId_)), ".json")) : "";
1270     }
1271 
1272     /**
1273      * This function will return the max batch size.
1274      */
1275     function batchMax() external override view returns (uint256) {
1276         return _batchMax_;
1277     }
1278 
1279     /**
1280      * This function will return the totalSupply of NFT.
1281      */
1282     function totalSupply() external view returns (uint256) {
1283         return _totalSupply_;
1284     }
1285 
1286     /**
1287      * This function will return the last tokenID has been bought.
1288      */
1289     function getCurrentTokenId() external view returns (uint256) {
1290         return _currentTokenId_;
1291     }
1292 
1293     // Utilities
1294 
1295     function randomNumber() internal view virtual returns (uint256) {
1296         return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, block.number)));
1297     }
1298 
1299     /**
1300      * This function will return the sequenceId of tokenId,
1301      * as we mentioned above
1302      * sequenceId is the id that point to GhettoSharkhood.
1303      * tokenId is the token that user keep.
1304      */
1305     function sequenceId(uint256 tokenId) external override view returns (uint256) {
1306         return _sequenceId(tokenId);
1307     }
1308 
1309     /**
1310      * This function will caculate the ID for specified tokenID,
1311      * for example: 
1312      * tokenId -> 1 and the offset -> 1, the sequenceId will be 2.
1313      * tokenId -> 10000 and the offset -> 1, the sequenceId will be 1.
1314      */
1315     function _sequenceId(uint256 tokenId) internal view returns (uint256) {
1316         return _isRevealed_ ? (((tokenId - 1) + _offset_) % _totalSupply_ + 1) : 0;
1317     }
1318 
1319     /**
1320      * The flag to save whether team has reserved 200 NFT or not.
1321      */
1322     bool _teamClaimed_ = false;
1323 
1324     /**
1325      * This function is an owner only function,
1326      * the contract owner can mint 200 NFT, and don't need to mint via any minter,
1327      * but this is one time operation.
1328      */
1329     function teamClaim() public onlyOwner returns (uint256[] memory) {
1330         require(!_teamClaimed_, "GhettoSharkhood: team has claimed already");
1331         _teamClaimed_ = true;
1332         return mintSpeficiedAmount(msg.sender, 200);
1333     }
1334 }