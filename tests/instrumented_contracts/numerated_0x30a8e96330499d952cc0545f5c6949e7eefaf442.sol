1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
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
28 
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
30 
31 pragma solidity ^0.8.0;
32 
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
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
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
199 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
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
225 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
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
443 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
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
468 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
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
536 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
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
564 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
565 
566 pragma solidity ^0.8.0;
567 
568 
569 
570 
571 
572 
573 
574 /**
575  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
576  * the Metadata extension, but not including the Enumerable extension, which is available separately as
577  * {ERC721Enumerable}.
578  */
579 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
580     using Address for address;
581     using Strings for uint256;
582 
583     // Token name
584     string private _name;
585 
586     // Token symbol
587     string private _symbol;
588 
589     // Mapping from token ID to owner address
590     mapping(uint256 => address) private _owners;
591 
592     // Mapping owner address to token count
593     mapping(address => uint256) private _balances;
594 
595     // Mapping from token ID to approved address
596     mapping(uint256 => address) private _tokenApprovals;
597 
598     // Mapping from owner to operator approvals
599     mapping(address => mapping(address => bool)) private _operatorApprovals;
600 
601     /**
602      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
603      */
604     constructor(string memory name_, string memory symbol_) {
605         _name = name_;
606         _symbol = symbol_;
607     }
608 
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
613         return
614             interfaceId == type(IERC721).interfaceId ||
615             interfaceId == type(IERC721Metadata).interfaceId ||
616             super.supportsInterface(interfaceId);
617     }
618 
619     /**
620      * @dev See {IERC721-balanceOf}.
621      */
622     function balanceOf(address owner) public view virtual override returns (uint256) {
623         require(owner != address(0), "ERC721: balance query for the zero address");
624         return _balances[owner];
625     }
626 
627     /**
628      * @dev See {IERC721-ownerOf}.
629      */
630     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
631         address owner = _owners[tokenId];
632         require(owner != address(0), "ERC721: owner query for nonexistent token");
633         return owner;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-name}.
638      */
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-symbol}.
645      */
646     function symbol() public view virtual override returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-tokenURI}.
652      */
653     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
654         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
655 
656         string memory baseURI = _baseURI();
657         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
658     }
659 
660     /**
661      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
662      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
663      * by default, can be overriden in child contracts.
664      */
665     function _baseURI() internal view virtual returns (string memory) {
666         return "";
667     }
668 
669     /**
670      * @dev See {IERC721-approve}.
671      */
672     function approve(address to, uint256 tokenId) public virtual override {
673         address owner = ERC721.ownerOf(tokenId);
674         require(to != owner, "ERC721: approval to current owner");
675 
676         require(
677             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
678             "ERC721: approve caller is not owner nor approved for all"
679         );
680 
681         _approve(to, tokenId);
682     }
683 
684     /**
685      * @dev See {IERC721-getApproved}.
686      */
687     function getApproved(uint256 tokenId) public view virtual override returns (address) {
688         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
689 
690         return _tokenApprovals[tokenId];
691     }
692 
693     /**
694      * @dev See {IERC721-setApprovalForAll}.
695      */
696     function setApprovalForAll(address operator, bool approved) public virtual override {
697         require(operator != _msgSender(), "ERC721: approve to caller");
698 
699         _operatorApprovals[_msgSender()][operator] = approved;
700         emit ApprovalForAll(_msgSender(), operator, approved);
701     }
702 
703     /**
704      * @dev See {IERC721-isApprovedForAll}.
705      */
706     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
707         return _operatorApprovals[owner][operator];
708     }
709 
710     /**
711      * @dev See {IERC721-transferFrom}.
712      */
713     function transferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) public virtual override {
718         //solhint-disable-next-line max-line-length
719         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
720 
721         _transfer(from, to, tokenId);
722     }
723 
724     /**
725      * @dev See {IERC721-safeTransferFrom}.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         safeTransferFrom(from, to, tokenId, "");
733     }
734 
735     /**
736      * @dev See {IERC721-safeTransferFrom}.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) public virtual override {
744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
745         _safeTransfer(from, to, tokenId, _data);
746     }
747 
748     /**
749      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
750      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
751      *
752      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
753      *
754      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
755      * implement alternative mechanisms to perform token transfer, such as signature-based.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _safeTransfer(
767         address from,
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) internal virtual {
772         _transfer(from, to, tokenId);
773         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
774     }
775 
776     /**
777      * @dev Returns whether `tokenId` exists.
778      *
779      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
780      *
781      * Tokens start existing when they are minted (`_mint`),
782      * and stop existing when they are burned (`_burn`).
783      */
784     function _exists(uint256 tokenId) internal view virtual returns (bool) {
785         return _owners[tokenId] != address(0);
786     }
787 
788     /**
789      * @dev Returns whether `spender` is allowed to manage `tokenId`.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must exist.
794      */
795     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
796         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
797         address owner = ERC721.ownerOf(tokenId);
798         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
799     }
800 
801     /**
802      * @dev Safely mints `tokenId` and transfers it to `to`.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must not exist.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _safeMint(address to, uint256 tokenId) internal virtual {
812         _safeMint(to, tokenId, "");
813     }
814 
815     /**
816      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
817      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
818      */
819     function _safeMint(
820         address to,
821         uint256 tokenId,
822         bytes memory _data
823     ) internal virtual {
824         _mint(to, tokenId);
825         require(
826             _checkOnERC721Received(address(0), to, tokenId, _data),
827             "ERC721: transfer to non ERC721Receiver implementer"
828         );
829     }
830 
831     /**
832      * @dev Mints `tokenId` and transfers it to `to`.
833      *
834      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
835      *
836      * Requirements:
837      *
838      * - `tokenId` must not exist.
839      * - `to` cannot be the zero address.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _mint(address to, uint256 tokenId) internal virtual {
844         require(to != address(0), "ERC721: mint to the zero address");
845         require(!_exists(tokenId), "ERC721: token already minted");
846 
847         _beforeTokenTransfer(address(0), to, tokenId);
848 
849         _balances[to] += 1;
850         _owners[tokenId] = to;
851 
852         emit Transfer(address(0), to, tokenId);
853     }
854 
855     /**
856      * @dev Destroys `tokenId`.
857      * The approval is cleared when the token is burned.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must exist.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _burn(uint256 tokenId) internal virtual {
866         address owner = ERC721.ownerOf(tokenId);
867 
868         _beforeTokenTransfer(owner, address(0), tokenId);
869 
870         // Clear approvals
871         _approve(address(0), tokenId);
872 
873         _balances[owner] -= 1;
874         delete _owners[tokenId];
875 
876         emit Transfer(owner, address(0), tokenId);
877     }
878 
879     /**
880      * @dev Transfers `tokenId` from `from` to `to`.
881      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
882      *
883      * Requirements:
884      *
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must be owned by `from`.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _transfer(
891         address from,
892         address to,
893         uint256 tokenId
894     ) internal virtual {
895         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
896         require(to != address(0), "ERC721: transfer to the zero address");
897 
898         _beforeTokenTransfer(from, to, tokenId);
899 
900         // Clear approvals from the previous owner
901         _approve(address(0), tokenId);
902 
903         _balances[from] -= 1;
904         _balances[to] += 1;
905         _owners[tokenId] = to;
906 
907         emit Transfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev Approve `to` to operate on `tokenId`
912      *
913      * Emits a {Approval} event.
914      */
915     function _approve(address to, uint256 tokenId) internal virtual {
916         _tokenApprovals[tokenId] = to;
917         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
918     }
919 
920     /**
921      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
922      * The call is not executed if the target address is not a contract.
923      *
924      * @param from address representing the previous owner of the given token ID
925      * @param to target address that will receive the tokens
926      * @param tokenId uint256 ID of the token to be transferred
927      * @param _data bytes optional data to send along with the call
928      * @return bool whether the call correctly returned the expected magic value
929      */
930     function _checkOnERC721Received(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) private returns (bool) {
936         if (to.isContract()) {
937             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
938                 return retval == IERC721Receiver.onERC721Received.selector;
939             } catch (bytes memory reason) {
940                 if (reason.length == 0) {
941                     revert("ERC721: transfer to non ERC721Receiver implementer");
942                 } else {
943                     assembly {
944                         revert(add(32, reason), mload(reason))
945                     }
946                 }
947             }
948         } else {
949             return true;
950         }
951     }
952 
953     /**
954      * @dev Hook that is called before any token transfer. This includes minting
955      * and burning.
956      *
957      * Calling conditions:
958      *
959      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
960      * transferred to `to`.
961      * - When `from` is zero, `tokenId` will be minted for `to`.
962      * - When `to` is zero, ``from``'s `tokenId` will be burned.
963      * - `from` and `to` are never both zero.
964      *
965      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
966      */
967     function _beforeTokenTransfer(
968         address from,
969         address to,
970         uint256 tokenId
971     ) internal virtual {}
972 }
973 
974 
975 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
976 
977 pragma solidity ^0.8.0;
978 
979 /**
980  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
981  * @dev See https://eips.ethereum.org/EIPS/eip-721
982  */
983 interface IERC721Enumerable is IERC721 {
984     /**
985      * @dev Returns the total amount of tokens stored by the contract.
986      */
987     function totalSupply() external view returns (uint256);
988 
989     /**
990      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
991      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
992      */
993     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
994 
995     /**
996      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
997      * Use along with {totalSupply} to enumerate all tokens.
998      */
999     function tokenByIndex(uint256 index) external view returns (uint256);
1000 }
1001 
1002 
1003 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 /**
1009  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1010  * enumerability of all the token ids in the contract as well as all token ids owned by each
1011  * account.
1012  */
1013 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1014     // Mapping from owner to list of owned token IDs
1015     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1016 
1017     // Mapping from token ID to index of the owner tokens list
1018     mapping(uint256 => uint256) private _ownedTokensIndex;
1019 
1020     // Array with all token ids, used for enumeration
1021     uint256[] private _allTokens;
1022 
1023     // Mapping from token id to position in the allTokens array
1024     mapping(uint256 => uint256) private _allTokensIndex;
1025 
1026     /**
1027      * @dev See {IERC165-supportsInterface}.
1028      */
1029     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1030         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1035      */
1036     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1037         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1038         return _ownedTokens[owner][index];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-totalSupply}.
1043      */
1044     function totalSupply() public view virtual override returns (uint256) {
1045         return _allTokens.length;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenByIndex}.
1050      */
1051     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1052         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1053         return _allTokens[index];
1054     }
1055 
1056     /**
1057      * @dev Hook that is called before any token transfer. This includes minting
1058      * and burning.
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1066      * - `from` cannot be the zero address.
1067      * - `to` cannot be the zero address.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual override {
1076         super._beforeTokenTransfer(from, to, tokenId);
1077 
1078         if (from == address(0)) {
1079             _addTokenToAllTokensEnumeration(tokenId);
1080         } else if (from != to) {
1081             _removeTokenFromOwnerEnumeration(from, tokenId);
1082         }
1083         if (to == address(0)) {
1084             _removeTokenFromAllTokensEnumeration(tokenId);
1085         } else if (to != from) {
1086             _addTokenToOwnerEnumeration(to, tokenId);
1087         }
1088     }
1089 
1090     /**
1091      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1092      * @param to address representing the new owner of the given token ID
1093      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1094      */
1095     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1096         uint256 length = ERC721.balanceOf(to);
1097         _ownedTokens[to][length] = tokenId;
1098         _ownedTokensIndex[tokenId] = length;
1099     }
1100 
1101     /**
1102      * @dev Private function to add a token to this extension's token tracking data structures.
1103      * @param tokenId uint256 ID of the token to be added to the tokens list
1104      */
1105     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1106         _allTokensIndex[tokenId] = _allTokens.length;
1107         _allTokens.push(tokenId);
1108     }
1109 
1110     /**
1111      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1112      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1113      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1114      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1115      * @param from address representing the previous owner of the given token ID
1116      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1117      */
1118     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1119         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1120         // then delete the last slot (swap and pop).
1121 
1122         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1123         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1124 
1125         // When the token to delete is the last token, the swap operation is unnecessary
1126         if (tokenIndex != lastTokenIndex) {
1127             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1128 
1129             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1130             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1131         }
1132 
1133         // This also deletes the contents at the last position of the array
1134         delete _ownedTokensIndex[tokenId];
1135         delete _ownedTokens[from][lastTokenIndex];
1136     }
1137 
1138     /**
1139      * @dev Private function to remove a token from this extension's token tracking data structures.
1140      * This has O(1) time complexity, but alters the order of the _allTokens array.
1141      * @param tokenId uint256 ID of the token to be removed from the tokens list
1142      */
1143     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1144         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1145         // then delete the last slot (swap and pop).
1146 
1147         uint256 lastTokenIndex = _allTokens.length - 1;
1148         uint256 tokenIndex = _allTokensIndex[tokenId];
1149 
1150         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1151         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1152         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1153         uint256 lastTokenId = _allTokens[lastTokenIndex];
1154 
1155         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1156         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1157 
1158         // This also deletes the contents at the last position of the array
1159         delete _allTokensIndex[tokenId];
1160         _allTokens.pop();
1161     }
1162 }
1163 
1164 
1165 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Contract module which provides a basic access control mechanism, where
1171  * there is an account (an owner) that can be granted exclusive access to
1172  * specific functions.
1173  *
1174  * By default, the owner account will be the one that deploys the contract. This
1175  * can later be changed with {transferOwnership}.
1176  *
1177  * This module is used through inheritance. It will make available the modifier
1178  * `onlyOwner`, which can be applied to your functions to restrict their use to
1179  * the owner.
1180  */
1181 abstract contract Ownable is Context {
1182     address private _owner;
1183 
1184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1185 
1186     /**
1187      * @dev Initializes the contract setting the deployer as the initial owner.
1188      */
1189     constructor() {
1190         _setOwner(_msgSender());
1191     }
1192 
1193     /**
1194      * @dev Returns the address of the current owner.
1195      */
1196     function owner() public view virtual returns (address) {
1197         return _owner;
1198     }
1199 
1200     /**
1201      * @dev Throws if called by any account other than the owner.
1202      */
1203     modifier onlyOwner() {
1204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1205         _;
1206     }
1207 
1208     /**
1209      * @dev Leaves the contract without owner. It will not be possible to call
1210      * `onlyOwner` functions anymore. Can only be called by the current owner.
1211      *
1212      * NOTE: Renouncing ownership will leave the contract without an owner,
1213      * thereby removing any functionality that is only available to the owner.
1214      */
1215     function renounceOwnership() public virtual onlyOwner {
1216         _setOwner(address(0));
1217     }
1218 
1219     /**
1220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1221      * Can only be called by the current owner.
1222      */
1223     function transferOwnership(address newOwner) public virtual onlyOwner {
1224         require(newOwner != address(0), "Ownable: new owner is the zero address");
1225         _setOwner(newOwner);
1226     }
1227 
1228     function _setOwner(address newOwner) private {
1229         address oldOwner = _owner;
1230         _owner = newOwner;
1231         emit OwnershipTransferred(oldOwner, newOwner);
1232     }
1233 }
1234 
1235 
1236 // File contracts/PickleAnniversary.sol
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 interface IFeeDistributor {
1242     function ve_for_at(address _user, uint256 _timestamp)
1243         external
1244         returns (uint256);
1245 }
1246 
1247 contract PickleAnniversary is ERC721Enumerable, Ownable {
1248     string public _tokenURI;
1249     uint256 public snapshotTime = 1631248201;
1250     bool public _ownerClaimed;
1251     mapping(address => bool) public userClaimed;
1252     mapping(uint256 => bool) public giftRedeemed;
1253 
1254     IFeeDistributor public constant DILL = IFeeDistributor(
1255         0x74C6CadE3eF61d64dcc9b97490d9FbB231e4BdCc
1256     );
1257 
1258     constructor(string memory _uri)
1259         public
1260         ERC721("Pickle Anniversary Gift", "P1CKLE")
1261     {
1262         _tokenURI = _uri;
1263         _ownerClaimed = false;
1264     }
1265 
1266     // Reserver 25 mints for the team to distribute
1267     function reserveMints() public onlyOwner {
1268         require(_ownerClaimed = false, "Owner has already claimed");
1269         uint256 supply = totalSupply();
1270         uint256 i;
1271         for (i = 0; i < 25; i++) {
1272             _safeMint(msg.sender, supply + i);
1273         }
1274         _ownerClaimed = true;
1275     }
1276 
1277     function tokenURI(uint256 _tokenId)
1278         public
1279         override
1280         view
1281         returns (string memory)
1282     {
1283         require(
1284             _exists(_tokenId),
1285             "ERC721Metadata: URI query for nonexistent token"
1286         );
1287 
1288         string memory uri = _baseURI();
1289         return uri;
1290     }
1291 
1292     function _baseURI() internal override view returns (string memory) {
1293         return _tokenURI;
1294     }
1295 
1296     function setTokenURI(string memory _uri) public onlyOwner {
1297         _tokenURI = _uri;
1298     }
1299 
1300     function mintNFT(address recipient) public returns (uint256) {
1301         require(!userClaimed[msg.sender], "User has already claimed NFT");
1302 
1303         // Require a DILL balance > 10 at the snapshotTime
1304         require(
1305             DILL.ve_for_at(msg.sender, snapshotTime) >= mul(10, 1e18),
1306             "User balance does not qualify"
1307         );
1308 
1309         uint256 supply = totalSupply();
1310         uint256 newItemId = supply;
1311         _mint(recipient, newItemId);
1312 
1313         userClaimed[msg.sender] = true;
1314 
1315         return newItemId;
1316     }
1317 
1318     function redeemGift(uint256 tokenId) public returns (bool) {
1319         require(
1320             msg.sender == ownerOf(tokenId),
1321             "Can only redeem tokens you own"
1322         );
1323         require(
1324             giftRedeemed[tokenId] == false,
1325             "Token has already been redeemed"
1326         );
1327         giftRedeemed[tokenId] = true;
1328         return true;
1329     }
1330 
1331     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1332         if (a == 0) return 0;
1333         uint256 c = a * b;
1334         require(c / a == b, "SafeMath: multiplication overflow");
1335         return c;
1336     }
1337 }