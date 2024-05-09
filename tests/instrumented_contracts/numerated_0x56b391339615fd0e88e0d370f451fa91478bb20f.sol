1 // SPDX-License-Identifier: MIT
2 
3 // Ethaliens contract starts at 1307 ;)
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
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
171 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
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
199 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
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
226 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
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
444 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
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
469 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
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
537 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
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
566 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
574  * the Metadata extension, but not including the Enumerable extension, which is available separately as
575  * {ERC721Enumerable}.
576  */
577 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
578     using Address for address;
579     using Strings for uint256;
580 
581     // Token name
582     string private _name;
583 
584     // Token symbol
585     string private _symbol;
586 
587     // Mapping from token ID to owner address
588     mapping(uint256 => address) private _owners;
589 
590     // Mapping owner address to token count
591     mapping(address => uint256) private _balances;
592 
593     // Mapping from token ID to approved address
594     mapping(uint256 => address) private _tokenApprovals;
595 
596     // Mapping from owner to operator approvals
597     mapping(address => mapping(address => bool)) private _operatorApprovals;
598 
599     /**
600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
601      */
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
611         return
612             interfaceId == type(IERC721).interfaceId ||
613             interfaceId == type(IERC721Metadata).interfaceId ||
614             super.supportsInterface(interfaceId);
615     }
616 
617     /**
618      * @dev See {IERC721-balanceOf}.
619      */
620     function balanceOf(address owner) public view virtual override returns (uint256) {
621         require(owner != address(0), "ERC721: balance query for the zero address");
622         return _balances[owner];
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
629         address owner = _owners[tokenId];
630         require(owner != address(0), "ERC721: owner query for nonexistent token");
631         return owner;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-name}.
636      */
637     function name() public view virtual override returns (string memory) {
638         return _name;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-symbol}.
643      */
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-tokenURI}.
650      */
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
656     }
657 
658     /**
659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
661      * by default, can be overriden in child contracts.
662      */
663     function _baseURI() internal view virtual returns (string memory) {
664         return "";
665     }
666 
667     /**
668      * @dev See {IERC721-approve}.
669      */
670     function approve(address to, uint256 tokenId) public virtual override {
671         address owner = ERC721.ownerOf(tokenId);
672         require(to != owner, "ERC721: approval to current owner");
673 
674         require(
675             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
676             "ERC721: approve caller is not owner nor approved for all"
677         );
678 
679         _approve(to, tokenId);
680     }
681 
682     /**
683      * @dev See {IERC721-getApproved}.
684      */
685     function getApproved(uint256 tokenId) public view virtual override returns (address) {
686         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
687 
688         return _tokenApprovals[tokenId];
689     }
690 
691     /**
692      * @dev See {IERC721-setApprovalForAll}.
693      */
694     function setApprovalForAll(address operator, bool approved) public virtual override {
695         require(operator != _msgSender(), "ERC721: approve to caller");
696 
697         _operatorApprovals[_msgSender()][operator] = approved;
698         emit ApprovalForAll(_msgSender(), operator, approved);
699     }
700 
701     /**
702      * @dev See {IERC721-isApprovedForAll}.
703      */
704     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
705         return _operatorApprovals[owner][operator];
706     }
707 
708     /**
709      * @dev See {IERC721-transferFrom}.
710      */
711     function transferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transfer(from, to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         safeTransferFrom(from, to, tokenId, "");
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) public virtual override {
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743         _safeTransfer(from, to, tokenId, _data);
744     }
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
748      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
749      *
750      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
751      *
752      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
753      * implement alternative mechanisms to perform token transfer, such as signature-based.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must exist and be owned by `from`.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _safeTransfer(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) internal virtual {
770         _transfer(from, to, tokenId);
771         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      * and stop existing when they are burned (`_burn`).
781      */
782     function _exists(uint256 tokenId) internal view virtual returns (bool) {
783         return _owners[tokenId] != address(0);
784     }
785 
786     /**
787      * @dev Returns whether `spender` is allowed to manage `tokenId`.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
794         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
795         address owner = ERC721.ownerOf(tokenId);
796         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
797     }
798 
799     /**
800      * @dev Safely mints `tokenId` and transfers it to `to`.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must not exist.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeMint(address to, uint256 tokenId) internal virtual {
810         _safeMint(to, tokenId, "");
811     }
812 
813     /**
814      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
815      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
816      */
817     function _safeMint(
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal virtual {
822         _mint(to, tokenId);
823         require(
824             _checkOnERC721Received(address(0), to, tokenId, _data),
825             "ERC721: transfer to non ERC721Receiver implementer"
826         );
827     }
828 
829     /**
830      * @dev Mints `tokenId` and transfers it to `to`.
831      *
832      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - `to` cannot be the zero address.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _mint(address to, uint256 tokenId) internal virtual {
842         require(to != address(0), "ERC721: mint to the zero address");
843         require(!_exists(tokenId), "ERC721: token already minted");
844 
845         _beforeTokenTransfer(address(0), to, tokenId);
846 
847         _balances[to] += 1;
848         _owners[tokenId] = to;
849 
850         emit Transfer(address(0), to, tokenId);
851     }
852 
853     /**
854      * @dev Destroys `tokenId`.
855      * The approval is cleared when the token is burned.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _burn(uint256 tokenId) internal virtual {
864         address owner = ERC721.ownerOf(tokenId);
865 
866         _beforeTokenTransfer(owner, address(0), tokenId);
867 
868         // Clear approvals
869         _approve(address(0), tokenId);
870 
871         _balances[owner] -= 1;
872         delete _owners[tokenId];
873 
874         emit Transfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
894         require(to != address(0), "ERC721: transfer to the zero address");
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         _approve(address(0), tokenId);
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits a {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
920      * The call is not executed if the target address is not a contract.
921      *
922      * @param from address representing the previous owner of the given token ID
923      * @param to target address that will receive the tokens
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes optional data to send along with the call
926      * @return bool whether the call correctly returned the expected magic value
927      */
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
936                 return retval == IERC721Receiver.onERC721Received.selector;
937             } catch (bytes memory reason) {
938                 if (reason.length == 0) {
939                     revert("ERC721: transfer to non ERC721Receiver implementer");
940                 } else {
941                     assembly {
942                         revert(add(32, reason), mload(reason))
943                     }
944                 }
945             }
946         } else {
947             return true;
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, ``from``'s `tokenId` will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {}
970 }
971 
972 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721URIStorage.sol
973 
974 
975 pragma solidity ^0.8.0;
976 
977 
978 /**
979  * @dev ERC721 token with storage based token URI management.
980  */
981 abstract contract ERC721URIStorage is ERC721 {
982     using Strings for uint256;
983 
984     // Optional mapping for token URIs
985     mapping(uint256 => string) private _tokenURIs;
986 
987     /**
988      * @dev See {IERC721Metadata-tokenURI}.
989      */
990     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
991         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
992 
993         string memory _tokenURI = _tokenURIs[tokenId];
994         string memory base = _baseURI();
995 
996         // If there is no base URI, return the token URI.
997         if (bytes(base).length == 0) {
998             return _tokenURI;
999         }
1000         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1001         if (bytes(_tokenURI).length > 0) {
1002             return string(abi.encodePacked(base, _tokenURI));
1003         }
1004 
1005         return super.tokenURI(tokenId);
1006     }
1007 
1008     /**
1009      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1016         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1017         _tokenURIs[tokenId] = _tokenURI;
1018     }
1019 
1020     /**
1021      * @dev Destroys `tokenId`.
1022      * The approval is cleared when the token is burned.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _burn(uint256 tokenId) internal virtual override {
1031         super._burn(tokenId);
1032 
1033         if (bytes(_tokenURIs[tokenId]).length != 0) {
1034             delete _tokenURIs[tokenId];
1035         }
1036     }
1037 }
1038 
1039 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1040 
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1047  * @dev See https://eips.ethereum.org/EIPS/eip-721
1048  */
1049 interface IERC721Enumerable is IERC721 {
1050     /**
1051      * @dev Returns the total amount of tokens stored by the contract.
1052      */
1053     function totalSupply() external view returns (uint256);
1054 
1055     /**
1056      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1057      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1058      */
1059     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1060 
1061     /**
1062      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1063      * Use along with {totalSupply} to enumerate all tokens.
1064      */
1065     function tokenByIndex(uint256 index) external view returns (uint256);
1066 }
1067 
1068 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1069 
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 
1075 /**
1076  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1077  * enumerability of all the token ids in the contract as well as all token ids owned by each
1078  * account.
1079  */
1080 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1081     // Mapping from owner to list of owned token IDs
1082     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1083 
1084     // Mapping from token ID to index of the owner tokens list
1085     mapping(uint256 => uint256) private _ownedTokensIndex;
1086 
1087     // Array with all token ids, used for enumeration
1088     uint256[] private _allTokens;
1089 
1090     // Mapping from token id to position in the allTokens array
1091     mapping(uint256 => uint256) private _allTokensIndex;
1092 
1093     /**
1094      * @dev See {IERC165-supportsInterface}.
1095      */
1096     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1097         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1102      */
1103     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1104         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1105         return _ownedTokens[owner][index];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-totalSupply}.
1110      */
1111     function totalSupply() public view virtual override returns (uint256) {
1112         return _allTokens.length;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenByIndex}.
1117      */
1118     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1120         return _allTokens[index];
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` cannot be the zero address.
1134      * - `to` cannot be the zero address.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual override {
1143         super._beforeTokenTransfer(from, to, tokenId);
1144 
1145         if (from == address(0)) {
1146             _addTokenToAllTokensEnumeration(tokenId);
1147         } else if (from != to) {
1148             _removeTokenFromOwnerEnumeration(from, tokenId);
1149         }
1150         if (to == address(0)) {
1151             _removeTokenFromAllTokensEnumeration(tokenId);
1152         } else if (to != from) {
1153             _addTokenToOwnerEnumeration(to, tokenId);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1159      * @param to address representing the new owner of the given token ID
1160      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1161      */
1162     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1163         uint256 length = ERC721.balanceOf(to);
1164         _ownedTokens[to][length] = tokenId;
1165         _ownedTokensIndex[tokenId] = length;
1166     }
1167 
1168     /**
1169      * @dev Private function to add a token to this extension's token tracking data structures.
1170      * @param tokenId uint256 ID of the token to be added to the tokens list
1171      */
1172     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1173         _allTokensIndex[tokenId] = _allTokens.length;
1174         _allTokens.push(tokenId);
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1179      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1180      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1181      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1182      * @param from address representing the previous owner of the given token ID
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1184      */
1185     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1186         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1190         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary
1193         if (tokenIndex != lastTokenIndex) {
1194             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1195 
1196             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1197             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1198         }
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _ownedTokensIndex[tokenId];
1202         delete _ownedTokens[from][lastTokenIndex];
1203     }
1204 
1205     /**
1206      * @dev Private function to remove a token from this extension's token tracking data structures.
1207      * This has O(1) time complexity, but alters the order of the _allTokens array.
1208      * @param tokenId uint256 ID of the token to be removed from the tokens list
1209      */
1210     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1211         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1212         // then delete the last slot (swap and pop).
1213 
1214         uint256 lastTokenIndex = _allTokens.length - 1;
1215         uint256 tokenIndex = _allTokensIndex[tokenId];
1216 
1217         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1218         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1219         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1220         uint256 lastTokenId = _allTokens[lastTokenIndex];
1221 
1222         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1223         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1224 
1225         // This also deletes the contents at the last position of the array
1226         delete _allTokensIndex[tokenId];
1227         _allTokens.pop();
1228     }
1229 }
1230 
1231 // File: node_modules\@openzeppelin\contracts\access\Ownable.sol
1232 
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 
1237 /**
1238  * @dev Contract module which provides a basic access control mechanism, where
1239  * there is an account (an owner) that can be granted exclusive access to
1240  * specific functions.
1241  *
1242  * By default, the owner account will be the one that deploys the contract. This
1243  * can later be changed with {transferOwnership}.
1244  *
1245  * This module is used through inheritance. It will make available the modifier
1246  * `onlyOwner`, which can be applied to your functions to restrict their use to
1247  * the owner.
1248  */
1249 abstract contract Ownable is Context {
1250     address private _owner;
1251 
1252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1253 
1254     /**
1255      * @dev Initializes the contract setting the deployer as the initial owner.
1256      */
1257     constructor() {
1258         _setOwner(_msgSender());
1259     }
1260 
1261     /**
1262      * @dev Returns the address of the current owner.
1263      */
1264     function owner() public view virtual returns (address) {
1265         return _owner;
1266     }
1267 
1268     /**
1269      * @dev Throws if called by any account other than the owner.
1270      */
1271     modifier onlyOwner() {
1272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1273         _;
1274     }
1275 
1276     /**
1277      * @dev Leaves the contract without owner. It will not be possible to call
1278      * `onlyOwner` functions anymore. Can only be called by the current owner.
1279      *
1280      * NOTE: Renouncing ownership will leave the contract without an owner,
1281      * thereby removing any functionality that is only available to the owner.
1282      */
1283     function renounceOwnership() public virtual onlyOwner {
1284         _setOwner(address(0));
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Can only be called by the current owner.
1290      */
1291     function transferOwnership(address newOwner) public virtual onlyOwner {
1292         require(newOwner != address(0), "Ownable: new owner is the zero address");
1293         _setOwner(newOwner);
1294     }
1295 
1296     function _setOwner(address newOwner) private {
1297         address oldOwner = _owner;
1298         _owner = newOwner;
1299         emit OwnershipTransferred(oldOwner, newOwner);
1300     }
1301 }
1302 
1303 // File: contracts\Ethalien.sol
1304 // @dev: beefJenson, bighatlevi
1305 
1306 pragma solidity ^0.8.0;
1307 
1308 contract Ethalien is ERC721Enumerable, Ownable {
1309     
1310     string public _baseTokenURI;
1311     uint private aliensReserved = 200;
1312     uint public alienPrice = 0.02 ether;
1313     bool public saleIsActive = false;
1314     string public alienProvenance = "";
1315 
1316     constructor() ERC721("Ethaliens", "EALIEN"){}
1317 
1318     function _baseURI() internal view virtual override returns (string memory) {
1319         return _baseTokenURI;
1320     }
1321 
1322     function setBaseURI(string memory baseURI) public onlyOwner {
1323         _baseTokenURI = baseURI;
1324     }
1325 
1326     function setAlienPrice(uint _alienPrice) public onlyOwner() {
1327         alienPrice = _alienPrice;
1328     }
1329 
1330     function flipSaleState() public onlyOwner() {
1331         saleIsActive = !saleIsActive;
1332     }
1333 
1334     function withdraw () public payable onlyOwner() {
1335         uint contractBalance = address(this).balance;
1336         payable(_msgSender()).transfer(contractBalance);
1337     }
1338 
1339     function reserveAliens(address _to, uint _reserveAmount) public onlyOwner() {
1340         uint supply = totalSupply();
1341         require(_reserveAmount > 0 && _reserveAmount < aliensReserved + 1, "Insufficient reserves remaining" );
1342         for (uint i = 0; i < _reserveAmount; i++) {
1343             _safeMint(_to, supply + i);
1344         }
1345         aliensReserved = aliensReserved - (_reserveAmount);
1346     }
1347 
1348     function mintAliens(uint _num) public payable {
1349         uint supply = totalSupply();
1350 		require(saleIsActive, "Sale is not active" );
1351 		require(_num < 11, "You can only mint 10 at once" );
1352 		require(supply + _num < 7501, "Transaction would exceed the total supply" );
1353 		require(msg.value >= alienPrice * _num, "Ether value sent is not correct" );
1354 		for(uint i = 0; i < _num; i++ ) {
1355 			uint mintIndex = supply + i;
1356 			_safeMint(msg.sender, mintIndex);
1357         }
1358     }
1359     
1360     function tokensOfWalletOwner(address _owner) public view returns (uint[] memory) {
1361         uint tokenCount = balanceOf(_owner);
1362         uint[] memory tokenIds = new uint[](tokenCount);
1363         for(uint i; i < tokenCount; i++){
1364             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1365         }
1366         return tokenIds;
1367     }
1368 }