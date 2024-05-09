1 // SPDX-License-Identifier: MIT
2 
3 // Amended by HashLips
4 /**
5     !Disclaimer!
6     These contracts have been used to create tutorials,
7     and was created for the purpose to teach people
8     how to create smart contracts on the blockchain.
9     please review this code on your own before using any of
10     the following code for production.
11     HashLips will not be liable in any way if for the use 
12     of the code. That being said, the code has been tested 
13     to the best of the developers' knowledge to work as intended.
14 */
15 
16 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
17 pragma solidity ^0.8.0;
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
40 pragma solidity ^0.8.0;
41 /**
42  * @dev Required interface of an ERC721 compliant contract.
43  */
44 interface IERC721 is IERC165 {
45     /**
46      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external;
176 }
177 
178 
179 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
180 pragma solidity ^0.8.0;
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Enumerable is IERC721 {
186     /**
187      * @dev Returns the total amount of tokens stored by the contract.
188      */
189     function totalSupply() external view returns (uint256);
190 
191     /**
192      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
193      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
194      */
195     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
196 
197     /**
198      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
199      * Use along with {totalSupply} to enumerate all tokens.
200      */
201     function tokenByIndex(uint256 index) external view returns (uint256);
202 }
203 
204 
205 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
206 pragma solidity ^0.8.0;
207 /**
208  * @dev Implementation of the {IERC165} interface.
209  *
210  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
211  * for the additional interface id that will be supported. For example:
212  *
213  * ```solidity
214  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
215  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
216  * }
217  * ```
218  *
219  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
220  */
221 abstract contract ERC165 is IERC165 {
222     /**
223      * @dev See {IERC165-supportsInterface}.
224      */
225     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
226         return interfaceId == type(IERC165).interfaceId;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Strings.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev String operations.
238  */
239 library Strings {
240     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
241 
242     /**
243      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
244      */
245     function toString(uint256 value) internal pure returns (string memory) {
246         // Inspired by OraclizeAPI's implementation - MIT licence
247         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
248 
249         if (value == 0) {
250             return "0";
251         }
252         uint256 temp = value;
253         uint256 digits;
254         while (temp != 0) {
255             digits++;
256             temp /= 10;
257         }
258         bytes memory buffer = new bytes(digits);
259         while (value != 0) {
260             digits -= 1;
261             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
262             value /= 10;
263         }
264         return string(buffer);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
269      */
270     function toHexString(uint256 value) internal pure returns (string memory) {
271         if (value == 0) {
272             return "0x00";
273         }
274         uint256 temp = value;
275         uint256 length = 0;
276         while (temp != 0) {
277             length++;
278             temp >>= 8;
279         }
280         return toHexString(value, length);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
285      */
286     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
287         bytes memory buffer = new bytes(2 * length + 2);
288         buffer[0] = "0";
289         buffer[1] = "x";
290         for (uint256 i = 2 * length + 1; i > 1; --i) {
291             buffer[i] = _HEX_SYMBOLS[value & 0xf];
292             value >>= 4;
293         }
294         require(value == 0, "Strings: hex length insufficient");
295         return string(buffer);
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Address.sol
300 
301 
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         (bool success, ) = recipient.call{value: amount}("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain `call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
491      * revert reason using the provided one.
492      *
493      * _Available since v4.3._
494      */
495     function verifyCallResult(
496         bool success,
497         bytes memory returndata,
498         string memory errorMessage
499     ) internal pure returns (bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 assembly {
508                     let returndata_size := mload(returndata)
509                     revert(add(32, returndata), returndata_size)
510                 }
511             } else {
512                 revert(errorMessage);
513             }
514         }
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
519 
520 
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Metadata is IERC721 {
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @title ERC721 token receiver interface
554  * @dev Interface for any contract that wants to support safeTransfers
555  * from ERC721 asset contracts.
556  */
557 interface IERC721Receiver {
558     /**
559      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
560      * by `operator` from `from`, this function is called.
561      *
562      * It must return its Solidity selector to confirm the token transfer.
563      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
564      *
565      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
566      */
567     function onERC721Received(
568         address operator,
569         address from,
570         uint256 tokenId,
571         bytes calldata data
572     ) external returns (bytes4);
573 }
574 
575 // File: @openzeppelin/contracts/utils/Context.sol
576 pragma solidity ^0.8.0;
577 /**
578  * @dev Provides information about the current execution context, including the
579  * sender of the transaction and its data. While these are generally available
580  * via msg.sender and msg.data, they should not be accessed in such a direct
581  * manner, since when dealing with meta-transactions the account sending and
582  * paying for execution may not be the actual sender (as far as an application
583  * is concerned).
584  *
585  * This contract is only required for intermediate, library-like contracts.
586  */
587 abstract contract Context {
588     function _msgSender() internal view virtual returns (address) {
589         return msg.sender;
590     }
591 
592     function _msgData() internal view virtual returns (bytes calldata) {
593         return msg.data;
594     }
595 }
596 
597 
598 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
599 pragma solidity ^0.8.0;
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
639         return
640             interfaceId == type(IERC721).interfaceId ||
641             interfaceId == type(IERC721Metadata).interfaceId ||
642             super.supportsInterface(interfaceId);
643     }
644 
645     /**
646      * @dev See {IERC721-balanceOf}.
647      */
648     function balanceOf(address owner) public view virtual override returns (uint256) {
649         require(owner != address(0), "ERC721: balance query for the zero address");
650         return _balances[owner];
651     }
652 
653     /**
654      * @dev See {IERC721-ownerOf}.
655      */
656     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
657         address owner = _owners[tokenId];
658         require(owner != address(0), "ERC721: owner query for nonexistent token");
659         return owner;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         require(operator != _msgSender(), "ERC721: approve to caller");
724 
725         _operatorApprovals[_msgSender()][operator] = approved;
726         emit ApprovalForAll(_msgSender(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         //solhint-disable-next-line max-line-length
745         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
746 
747         _transfer(from, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         safeTransferFrom(from, to, tokenId, "");
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) public virtual override {
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
771         _safeTransfer(from, to, tokenId, _data);
772     }
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
779      *
780      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
781      * implement alternative mechanisms to perform token transfer, such as signature-based.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeTransfer(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _transfer(from, to, tokenId);
799         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
800     }
801 
802     /**
803      * @dev Returns whether `tokenId` exists.
804      *
805      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
806      *
807      * Tokens start existing when they are minted (`_mint`),
808      * and stop existing when they are burned (`_burn`).
809      */
810     function _exists(uint256 tokenId) internal view virtual returns (bool) {
811         return _owners[tokenId] != address(0);
812     }
813 
814     /**
815      * @dev Returns whether `spender` is allowed to manage `tokenId`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
822         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
823         address owner = ERC721.ownerOf(tokenId);
824         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, _data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ERC721.ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {
921         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
922         require(to != address(0), "ERC721: transfer to the zero address");
923 
924         _beforeTokenTransfer(from, to, tokenId);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId);
928 
929         _balances[from] -= 1;
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `to` to operate on `tokenId`
938      *
939      * Emits a {Approval} event.
940      */
941     function _approve(address to, uint256 tokenId) internal virtual {
942         _tokenApprovals[tokenId] = to;
943         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
944     }
945 
946     /**
947      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
948      * The call is not executed if the target address is not a contract.
949      *
950      * @param from address representing the previous owner of the given token ID
951      * @param to target address that will receive the tokens
952      * @param tokenId uint256 ID of the token to be transferred
953      * @param _data bytes optional data to send along with the call
954      * @return bool whether the call correctly returned the expected magic value
955      */
956     function _checkOnERC721Received(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) private returns (bool) {
962         if (to.isContract()) {
963             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
964                 return retval == IERC721Receiver.onERC721Received.selector;
965             } catch (bytes memory reason) {
966                 if (reason.length == 0) {
967                     revert("ERC721: transfer to non ERC721Receiver implementer");
968                 } else {
969                     assembly {
970                         revert(add(32, reason), mload(reason))
971                     }
972                 }
973             }
974         } else {
975             return true;
976         }
977     }
978 
979     /**
980      * @dev Hook that is called before any token transfer. This includes minting
981      * and burning.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, ``from``'s `tokenId` will be burned.
989      * - `from` and `to` are never both zero.
990      *
991      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
992      */
993     function _beforeTokenTransfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) internal virtual {}
998 }
999 
1000 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1001 
1002 
1003 
1004 pragma solidity ^0.8.0;
1005 
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
1165 // File: @openzeppelin/contracts/access/Ownable.sol
1166 pragma solidity ^0.8.0;
1167 /**
1168  * @dev Contract module which provides a basic access control mechanism, where
1169  * there is an account (an owner) that can be granted exclusive access to
1170  * specific functions.
1171  *
1172  * By default, the owner account will be the one that deploys the contract. This
1173  * can later be changed with {transferOwnership}.
1174  *
1175  * This module is used through inheritance. It will make available the modifier
1176  * `onlyOwner`, which can be applied to your functions to restrict their use to
1177  * the owner.
1178  */
1179 abstract contract Ownable is Context {
1180     address private _owner;
1181 
1182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1183 
1184     /**
1185      * @dev Initializes the contract setting the deployer as the initial owner.
1186      */
1187     constructor() {
1188         _setOwner(_msgSender());
1189     }
1190 
1191     /**
1192      * @dev Returns the address of the current owner.
1193      */
1194     function owner() public view virtual returns (address) {
1195         return _owner;
1196     }
1197 
1198     /**
1199      * @dev Throws if called by any account other than the owner.
1200      */
1201     modifier onlyOwner() {
1202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1203         _;
1204     }
1205 
1206     /**
1207      * @dev Leaves the contract without owner. It will not be possible to call
1208      * `onlyOwner` functions anymore. Can only be called by the current owner.
1209      *
1210      * NOTE: Renouncing ownership will leave the contract without an owner,
1211      * thereby removing any functionality that is only available to the owner.
1212      */
1213     function renounceOwnership() public virtual onlyOwner {
1214         _setOwner(address(0));
1215     }
1216 
1217     /**
1218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1219      * Can only be called by the current owner.
1220      */
1221     function transferOwnership(address newOwner) public virtual onlyOwner {
1222         require(newOwner != address(0), "Ownable: new owner is the zero address");
1223         _setOwner(newOwner);
1224     }
1225 
1226     function _setOwner(address newOwner) private {
1227         address oldOwner = _owner;
1228         _owner = newOwner;
1229         emit OwnershipTransferred(oldOwner, newOwner);
1230     }
1231 }
1232 
1233 pragma solidity >=0.7.0 <0.9.0;
1234 
1235 contract InvisibleApesClub is ERC721Enumerable, Ownable {
1236   using Strings for uint256;
1237 
1238   string baseURI;
1239   string public baseExtension = ".json";
1240   uint256 public cost = 0.03 ether;
1241   uint256 public maxSupply = 5555;
1242   uint256 public maxMintAmount = 5;
1243   bool public paused = true;
1244   bool public revealed = false;
1245   string public notRevealedUri;
1246 
1247   constructor(
1248     string memory _name,
1249     string memory _symbol,
1250     string memory _initBaseURI,
1251     string memory _initNotRevealedUri
1252   ) ERC721(_name, _symbol) {
1253     setBaseURI(_initBaseURI);
1254     setNotRevealedURI(_initNotRevealedUri);
1255   }
1256 
1257   // internal
1258   function _baseURI() internal view virtual override returns (string memory) {
1259     return baseURI;
1260   }
1261 
1262   // public
1263   function mint(uint256 _mintAmount) public payable {
1264     uint256 supply = totalSupply();
1265     require(!paused);
1266     require(_mintAmount > 0);
1267     require(_mintAmount <= maxMintAmount);
1268     require(supply + _mintAmount <= maxSupply);
1269 
1270     if (msg.sender != owner()) {
1271       require(msg.value >= cost * _mintAmount);
1272     }
1273 
1274     for (uint256 i = 1; i <= _mintAmount; i++) {
1275       _safeMint(msg.sender, supply + i);
1276     }
1277   }
1278 
1279   function walletOfOwner(address _owner)
1280     public
1281     view
1282     returns (uint256[] memory)
1283   {
1284     uint256 ownerTokenCount = balanceOf(_owner);
1285     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1286     for (uint256 i; i < ownerTokenCount; i++) {
1287       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1288     }
1289     return tokenIds;
1290   }
1291 
1292   function tokenURI(uint256 tokenId)
1293     public
1294     view
1295     virtual
1296     override
1297     returns (string memory)
1298   {
1299     require(
1300       _exists(tokenId),
1301       "ERC721Metadata: URI query for nonexistent token"
1302     );
1303     
1304     if(revealed == false) {
1305         return notRevealedUri;
1306     }
1307 
1308     string memory currentBaseURI = _baseURI();
1309     return bytes(currentBaseURI).length > 0
1310         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1311         : "";
1312   }
1313 
1314   //only owner
1315   function reveal() public onlyOwner {
1316       revealed = true;
1317   }
1318   
1319   function setCost(uint256 _newCost) public onlyOwner {
1320     cost = _newCost;
1321   }
1322 
1323   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1324     maxMintAmount = _newmaxMintAmount;
1325   }
1326   
1327   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1328     notRevealedUri = _notRevealedURI;
1329   }
1330 
1331   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1332     baseURI = _newBaseURI;
1333   }
1334 
1335   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1336     baseExtension = _newBaseExtension;
1337   }
1338 
1339   function pause(bool _state) public onlyOwner {
1340     paused = _state;
1341   }
1342  
1343   function withdraw() public payable onlyOwner {
1344     // This will pay HashLips 5% of the initial sale.
1345     // You can remove this if you want, or keep it in to support HashLips and his channel.
1346     // =============================================================================
1347     
1348     // This will payout the owner 95% of the contract balance.
1349     // Do not remove this otherwise you will not be able to withdraw the funds.
1350     // =============================================================================
1351     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1352     require(os);
1353     // =============================================================================
1354   }
1355 }