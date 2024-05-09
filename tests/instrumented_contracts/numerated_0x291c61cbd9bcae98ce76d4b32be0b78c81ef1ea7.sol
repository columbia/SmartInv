1 // File: contracts/Lil Llamas.sol
2 
3 
4 
5 // Amended by 9-bit
6 /**
7     !Disclaimer!
8     These contracts have been used to create tutorials,
9     and was created for the purpose to teach people
10     how to create smart contracts on the blockchain.
11     please review this code on your own before using any of
12     the following code for production.
13     HashLips will not be liable in any way if for the use 
14     of the code. That being said, the code has been tested 
15     to the best of the developers' knowledge to work as intended.
16 */
17 
18 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
19 pragma solidity ^0.8.0;
20 /**
21  * @dev Interface of the ERC165 standard, as defined in the
22  * https://eips.ethereum.org/EIPS/eip-165[EIP].
23  *
24  * Implementers can declare support of contract interfaces, which can then be
25  * queried by others ({ERC165Checker}).
26  *
27  * For an implementation, see {ERC165}.
28  */
29 interface IERC165 {
30     /**
31      * @dev Returns true if this contract implements the interface defined by
32      * `interfaceId`. See the corresponding
33      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
34      * to learn more about how these ids are created.
35      *
36      * This function call must use less than 30 000 gas.
37      */
38     function supportsInterface(bytes4 interfaceId) external view returns (bool);
39 }
40 
41 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
42 pragma solidity ^0.8.0;
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 }
179 
180 
181 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
182 pragma solidity ^0.8.0;
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Enumerable is IERC721 {
188     /**
189      * @dev Returns the total amount of tokens stored by the contract.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
195      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
196      */
197     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
198 
199     /**
200      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
201      * Use along with {totalSupply} to enumerate all tokens.
202      */
203     function tokenByIndex(uint256 index) external view returns (uint256);
204 }
205 
206 
207 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
208 pragma solidity ^0.8.0;
209 /**
210  * @dev Implementation of the {IERC165} interface.
211  *
212  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
213  * for the additional interface id that will be supported. For example:
214  *
215  * ```solidity
216  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
218  * }
219  * ```
220  *
221  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
222  */
223 abstract contract ERC165 is IERC165 {
224     /**
225      * @dev See {IERC165-supportsInterface}.
226      */
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Strings.sol
233 
234 
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250 
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Address.sol
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         uint256 size;
334         assembly {
335             size := extcodesize(account)
336         }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
521 
522 
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
529  * @dev See https://eips.ethereum.org/EIPS/eip-721
530  */
531 interface IERC721Metadata is IERC721 {
532     /**
533      * @dev Returns the token collection name.
534      */
535     function name() external view returns (string memory);
536 
537     /**
538      * @dev Returns the token collection symbol.
539      */
540     function symbol() external view returns (string memory);
541 
542     /**
543      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
544      */
545     function tokenURI(uint256 tokenId) external view returns (string memory);
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
549 
550 
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @title ERC721 token receiver interface
556  * @dev Interface for any contract that wants to support safeTransfers
557  * from ERC721 asset contracts.
558  */
559 interface IERC721Receiver {
560     /**
561      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
562      * by `operator` from `from`, this function is called.
563      *
564      * It must return its Solidity selector to confirm the token transfer.
565      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
566      *
567      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
568      */
569     function onERC721Received(
570         address operator,
571         address from,
572         uint256 tokenId,
573         bytes calldata data
574     ) external returns (bytes4);
575 }
576 
577 // File: @openzeppelin/contracts/utils/Context.sol
578 pragma solidity ^0.8.0;
579 /**
580  * @dev Provides information about the current execution context, including the
581  * sender of the transaction and its data. While these are generally available
582  * via msg.sender and msg.data, they should not be accessed in such a direct
583  * manner, since when dealing with meta-transactions the account sending and
584  * paying for execution may not be the actual sender (as far as an application
585  * is concerned).
586  *
587  * This contract is only required for intermediate, library-like contracts.
588  */
589 abstract contract Context {
590     function _msgSender() internal view virtual returns (address) {
591         return msg.sender;
592     }
593 
594     function _msgData() internal view virtual returns (bytes calldata) {
595         return msg.data;
596     }
597 }
598 
599 
600 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
601 pragma solidity ^0.8.0;
602 /**
603  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
604  * the Metadata extension, but not including the Enumerable extension, which is available separately as
605  * {ERC721Enumerable}.
606  */
607 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
608     using Address for address;
609     using Strings for uint256;
610 
611     // Token name
612     string private _name;
613 
614     // Token symbol
615     string private _symbol;
616 
617     // Mapping from token ID to owner address
618     mapping(uint256 => address) private _owners;
619 
620     // Mapping owner address to token count
621     mapping(address => uint256) private _balances;
622 
623     // Mapping from token ID to approved address
624     mapping(uint256 => address) private _tokenApprovals;
625 
626     // Mapping from owner to operator approvals
627     mapping(address => mapping(address => bool)) private _operatorApprovals;
628 
629     /**
630      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
631      */
632     constructor(string memory name_, string memory symbol_) {
633         _name = name_;
634         _symbol = symbol_;
635     }
636 
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
641         return
642             interfaceId == type(IERC721).interfaceId ||
643             interfaceId == type(IERC721Metadata).interfaceId ||
644             super.supportsInterface(interfaceId);
645     }
646 
647     /**
648      * @dev See {IERC721-balanceOf}.
649      */
650     function balanceOf(address owner) public view virtual override returns (uint256) {
651         require(owner != address(0), "ERC721: balance query for the zero address");
652         return _balances[owner];
653     }
654 
655     /**
656      * @dev See {IERC721-ownerOf}.
657      */
658     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
659         address owner = _owners[tokenId];
660         require(owner != address(0), "ERC721: owner query for nonexistent token");
661         return owner;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-name}.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-symbol}.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-tokenURI}.
680      */
681     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
682         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
683 
684         string memory baseURI = _baseURI();
685         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
686     }
687 
688     /**
689      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
690      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
691      * by default, can be overriden in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {
694         return "";
695     }
696 
697     /**
698      * @dev See {IERC721-approve}.
699      */
700     function approve(address to, uint256 tokenId) public virtual override {
701         address owner = ERC721.ownerOf(tokenId);
702         require(to != owner, "ERC721: approval to current owner");
703 
704         require(
705             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
706             "ERC721: approve caller is not owner nor approved for all"
707         );
708 
709         _approve(to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-getApproved}.
714      */
715     function getApproved(uint256 tokenId) public view virtual override returns (address) {
716         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
717 
718         return _tokenApprovals[tokenId];
719     }
720 
721     /**
722      * @dev See {IERC721-setApprovalForAll}.
723      */
724     function setApprovalForAll(address operator, bool approved) public virtual override {
725         require(operator != _msgSender(), "ERC721: approve to caller");
726 
727         _operatorApprovals[_msgSender()][operator] = approved;
728         emit ApprovalForAll(_msgSender(), operator, approved);
729     }
730 
731     /**
732      * @dev See {IERC721-isApprovedForAll}.
733      */
734     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
735         return _operatorApprovals[owner][operator];
736     }
737 
738     /**
739      * @dev See {IERC721-transferFrom}.
740      */
741     function transferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         //solhint-disable-next-line max-line-length
747         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
748 
749         _transfer(from, to, tokenId);
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) public virtual override {
760         safeTransferFrom(from, to, tokenId, "");
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) public virtual override {
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
773         _safeTransfer(from, to, tokenId, _data);
774     }
775 
776     /**
777      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
778      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
779      *
780      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
781      *
782      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
783      * implement alternative mechanisms to perform token transfer, such as signature-based.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _safeTransfer(
795         address from,
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) internal virtual {
800         _transfer(from, to, tokenId);
801         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
802     }
803 
804     /**
805      * @dev Returns whether `tokenId` exists.
806      *
807      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
808      *
809      * Tokens start existing when they are minted (`_mint`),
810      * and stop existing when they are burned (`_burn`).
811      */
812     function _exists(uint256 tokenId) internal view virtual returns (bool) {
813         return _owners[tokenId] != address(0);
814     }
815 
816     /**
817      * @dev Returns whether `spender` is allowed to manage `tokenId`.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
824         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
825         address owner = ERC721.ownerOf(tokenId);
826         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
827     }
828 
829     /**
830      * @dev Safely mints `tokenId` and transfers it to `to`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must not exist.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _safeMint(address to, uint256 tokenId) internal virtual {
840         _safeMint(to, tokenId, "");
841     }
842 
843     /**
844      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
845      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
846      */
847     function _safeMint(
848         address to,
849         uint256 tokenId,
850         bytes memory _data
851     ) internal virtual {
852         _mint(to, tokenId);
853         require(
854             _checkOnERC721Received(address(0), to, tokenId, _data),
855             "ERC721: transfer to non ERC721Receiver implementer"
856         );
857     }
858 
859     /**
860      * @dev Mints `tokenId` and transfers it to `to`.
861      *
862      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
863      *
864      * Requirements:
865      *
866      * - `tokenId` must not exist.
867      * - `to` cannot be the zero address.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _mint(address to, uint256 tokenId) internal virtual {
872         require(to != address(0), "ERC721: mint to the zero address");
873         require(!_exists(tokenId), "ERC721: token already minted");
874 
875         _beforeTokenTransfer(address(0), to, tokenId);
876 
877         _balances[to] += 1;
878         _owners[tokenId] = to;
879 
880         emit Transfer(address(0), to, tokenId);
881     }
882 
883     /**
884      * @dev Destroys `tokenId`.
885      * The approval is cleared when the token is burned.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _burn(uint256 tokenId) internal virtual {
894         address owner = ERC721.ownerOf(tokenId);
895 
896         _beforeTokenTransfer(owner, address(0), tokenId);
897 
898         // Clear approvals
899         _approve(address(0), tokenId);
900 
901         _balances[owner] -= 1;
902         delete _owners[tokenId];
903 
904         emit Transfer(owner, address(0), tokenId);
905     }
906 
907     /**
908      * @dev Transfers `tokenId` from `from` to `to`.
909      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
910      *
911      * Requirements:
912      *
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _transfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) internal virtual {
923         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
924         require(to != address(0), "ERC721: transfer to the zero address");
925 
926         _beforeTokenTransfer(from, to, tokenId);
927 
928         // Clear approvals from the previous owner
929         _approve(address(0), tokenId);
930 
931         _balances[from] -= 1;
932         _balances[to] += 1;
933         _owners[tokenId] = to;
934 
935         emit Transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev Approve `to` to operate on `tokenId`
940      *
941      * Emits a {Approval} event.
942      */
943     function _approve(address to, uint256 tokenId) internal virtual {
944         _tokenApprovals[tokenId] = to;
945         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
946     }
947 
948     /**
949      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
950      * The call is not executed if the target address is not a contract.
951      *
952      * @param from address representing the previous owner of the given token ID
953      * @param to target address that will receive the tokens
954      * @param tokenId uint256 ID of the token to be transferred
955      * @param _data bytes optional data to send along with the call
956      * @return bool whether the call correctly returned the expected magic value
957      */
958     function _checkOnERC721Received(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) private returns (bool) {
964         if (to.isContract()) {
965             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
966                 return retval == IERC721Receiver.onERC721Received.selector;
967             } catch (bytes memory reason) {
968                 if (reason.length == 0) {
969                     revert("ERC721: transfer to non ERC721Receiver implementer");
970                 } else {
971                     assembly {
972                         revert(add(32, reason), mload(reason))
973                     }
974                 }
975             }
976         } else {
977             return true;
978         }
979     }
980 
981     /**
982      * @dev Hook that is called before any token transfer. This includes minting
983      * and burning.
984      *
985      * Calling conditions:
986      *
987      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
988      * transferred to `to`.
989      * - When `from` is zero, `tokenId` will be minted for `to`.
990      * - When `to` is zero, ``from``'s `tokenId` will be burned.
991      * - `from` and `to` are never both zero.
992      *
993      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
994      */
995     function _beforeTokenTransfer(
996         address from,
997         address to,
998         uint256 tokenId
999     ) internal virtual {}
1000 }
1001 
1002 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1003 
1004 
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 
1009 
1010 /**
1011  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1012  * enumerability of all the token ids in the contract as well as all token ids owned by each
1013  * account.
1014  */
1015 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1016     // Mapping from owner to list of owned token IDs
1017     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1018 
1019     // Mapping from token ID to index of the owner tokens list
1020     mapping(uint256 => uint256) private _ownedTokensIndex;
1021 
1022     // Array with all token ids, used for enumeration
1023     uint256[] private _allTokens;
1024 
1025     // Mapping from token id to position in the allTokens array
1026     mapping(uint256 => uint256) private _allTokensIndex;
1027 
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1032         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1037      */
1038     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1039         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1040         return _ownedTokens[owner][index];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-totalSupply}.
1045      */
1046     function totalSupply() public view virtual override returns (uint256) {
1047         return _allTokens.length;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenByIndex}.
1052      */
1053     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1054         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1055         return _allTokens[index];
1056     }
1057 
1058     /**
1059      * @dev Hook that is called before any token transfer. This includes minting
1060      * and burning.
1061      *
1062      * Calling conditions:
1063      *
1064      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1065      * transferred to `to`.
1066      * - When `from` is zero, `tokenId` will be minted for `to`.
1067      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      *
1071      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1072      */
1073     function _beforeTokenTransfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual override {
1078         super._beforeTokenTransfer(from, to, tokenId);
1079 
1080         if (from == address(0)) {
1081             _addTokenToAllTokensEnumeration(tokenId);
1082         } else if (from != to) {
1083             _removeTokenFromOwnerEnumeration(from, tokenId);
1084         }
1085         if (to == address(0)) {
1086             _removeTokenFromAllTokensEnumeration(tokenId);
1087         } else if (to != from) {
1088             _addTokenToOwnerEnumeration(to, tokenId);
1089         }
1090     }
1091 
1092     /**
1093      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1094      * @param to address representing the new owner of the given token ID
1095      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1096      */
1097     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1098         uint256 length = ERC721.balanceOf(to);
1099         _ownedTokens[to][length] = tokenId;
1100         _ownedTokensIndex[tokenId] = length;
1101     }
1102 
1103     /**
1104      * @dev Private function to add a token to this extension's token tracking data structures.
1105      * @param tokenId uint256 ID of the token to be added to the tokens list
1106      */
1107     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1108         _allTokensIndex[tokenId] = _allTokens.length;
1109         _allTokens.push(tokenId);
1110     }
1111 
1112     /**
1113      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1114      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1115      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1116      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1117      * @param from address representing the previous owner of the given token ID
1118      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1119      */
1120     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1121         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1122         // then delete the last slot (swap and pop).
1123 
1124         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1125         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1126 
1127         // When the token to delete is the last token, the swap operation is unnecessary
1128         if (tokenIndex != lastTokenIndex) {
1129             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1130 
1131             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1132             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1133         }
1134 
1135         // This also deletes the contents at the last position of the array
1136         delete _ownedTokensIndex[tokenId];
1137         delete _ownedTokens[from][lastTokenIndex];
1138     }
1139 
1140     /**
1141      * @dev Private function to remove a token from this extension's token tracking data structures.
1142      * This has O(1) time complexity, but alters the order of the _allTokens array.
1143      * @param tokenId uint256 ID of the token to be removed from the tokens list
1144      */
1145     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1146         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1147         // then delete the last slot (swap and pop).
1148 
1149         uint256 lastTokenIndex = _allTokens.length - 1;
1150         uint256 tokenIndex = _allTokensIndex[tokenId];
1151 
1152         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1153         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1154         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1155         uint256 lastTokenId = _allTokens[lastTokenIndex];
1156 
1157         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1158         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1159 
1160         // This also deletes the contents at the last position of the array
1161         delete _allTokensIndex[tokenId];
1162         _allTokens.pop();
1163     }
1164 }
1165 
1166 
1167 // File: @openzeppelin/contracts/access/Ownable.sol
1168 pragma solidity ^0.8.0;
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
1235 pragma solidity >=0.7.0 <0.9.0;
1236 
1237 contract LilLlamas is ERC721Enumerable, Ownable {
1238   using Strings for uint256;
1239 
1240   string baseURI;
1241   string public baseExtension = ".json";
1242   uint256 public cost = 0.0 ether;
1243   uint256 public maxSupply = 7777;
1244   uint256 public maxMintAmount = 10;
1245   bool public paused = false;
1246   bool public revealed = true;
1247   string public notRevealedUri;
1248 
1249   constructor(
1250     string memory _name,
1251     string memory _symbol,
1252     string memory _initBaseURI,
1253     string memory _initNotRevealedUri
1254   ) ERC721(_name, _symbol) {
1255     setBaseURI(_initBaseURI);
1256     setNotRevealedURI(_initNotRevealedUri);
1257   }
1258 
1259   // internal
1260   function _baseURI() internal view virtual override returns (string memory) {
1261     return baseURI;
1262   }
1263 
1264   // public
1265   function mint(uint256 _mintAmount) public payable {
1266     uint256 supply = totalSupply();
1267     require(!paused);
1268     require(_mintAmount > 0);
1269     require(_mintAmount <= maxMintAmount);
1270     require(supply + _mintAmount <= maxSupply);
1271 
1272     if (msg.sender != owner()) {
1273       require(msg.value >= cost * _mintAmount);
1274     }
1275 
1276     for (uint256 i = 1; i <= _mintAmount; i++) {
1277       _safeMint(msg.sender, supply + i);
1278     }
1279   }
1280 
1281   function walletOfOwner(address _owner)
1282     public
1283     view
1284     returns (uint256[] memory)
1285   {
1286     uint256 ownerTokenCount = balanceOf(_owner);
1287     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1288     for (uint256 i; i < ownerTokenCount; i++) {
1289       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1290     }
1291     return tokenIds;
1292   }
1293 
1294   function tokenURI(uint256 tokenId)
1295     public
1296     view
1297     virtual
1298     override
1299     returns (string memory)
1300   {
1301     require(
1302       _exists(tokenId),
1303       "ERC721Metadata: URI query for nonexistent token"
1304     );
1305     
1306     if(revealed == false) {
1307         return notRevealedUri;
1308     }
1309 
1310     string memory currentBaseURI = _baseURI();
1311     return bytes(currentBaseURI).length > 0
1312         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1313         : "";
1314   }
1315 
1316   //only owner
1317   function reveal() public onlyOwner {
1318       revealed = true;
1319   }
1320   
1321   function setCost(uint256 _newCost) public onlyOwner {
1322     cost = _newCost;
1323   }
1324 
1325   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1326     maxMintAmount = _newmaxMintAmount;
1327   }
1328   
1329   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1330     notRevealedUri = _notRevealedURI;
1331   }
1332 
1333   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1334     baseURI = _newBaseURI;
1335   }
1336 
1337   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1338     baseExtension = _newBaseExtension;
1339   }
1340 
1341   function pause(bool _state) public onlyOwner {
1342     paused = _state;
1343   }
1344  
1345   function withdraw() public payable onlyOwner {
1346     
1347     
1348     // This will payout the owner 95% of the contract balance.
1349     // Do not remove this otherwise you will not be able to withdraw the funds.
1350     // =============================================================================
1351     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1352     require(os);
1353     // =============================================================================
1354   }
1355 }