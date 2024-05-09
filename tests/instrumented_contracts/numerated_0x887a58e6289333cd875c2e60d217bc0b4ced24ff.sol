1 // SPDX-License-Identifier: MIT
2 
3 // Contract by Clayco
4 //
5 //
6 // You own a PumpJack.
7 // Pumping is earns.
8 // The release of the genesis PumpJack will lay the foundation for a much broader concept.
9 // 
10 // *Texas PumpJack*
11 // 3500 NFT
12 // Free mint
13 // max 3 for tx 
14 //
15 //
16 //
17 /**
18     !Disclaimer!
19     These contracts have been used to create tutorials,
20     and was created for the purpose to teach people
21     how to create smart contracts on the blockchain.
22     please review this code on your own before using any of
23     the following code for production.
24     HashLips will not be liable in any way if for the use 
25     of the code. That being said, the code has been tested 
26     to the best of the developers' knowledge to work as intended.
27 */
28 
29 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
30 pragma solidity ^0.8.0;
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
53 pragma solidity ^0.8.0;
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65      */
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 }
190 
191 
192 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
193 pragma solidity ^0.8.0;
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Enumerable is IERC721 {
199     /**
200      * @dev Returns the total amount of tokens stored by the contract.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
206      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
207      */
208     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
209 
210     /**
211      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
212      * Use along with {totalSupply} to enumerate all tokens.
213      */
214     function tokenByIndex(uint256 index) external view returns (uint256);
215 }
216 
217 
218 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
219 pragma solidity ^0.8.0;
220 /**
221  * @dev Implementation of the {IERC165} interface.
222  *
223  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
224  * for the additional interface id that will be supported. For example:
225  *
226  * ```solidity
227  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
229  * }
230  * ```
231  *
232  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
233  */
234 abstract contract ERC165 is IERC165 {
235     /**
236      * @dev See {IERC165-supportsInterface}.
237      */
238     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
239         return interfaceId == type(IERC165).interfaceId;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Strings.sol
244 
245 
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev String operations.
251  */
252 library Strings {
253     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
257      */
258     function toString(uint256 value) internal pure returns (string memory) {
259         // Inspired by OraclizeAPI's implementation - MIT licence
260         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
261 
262         if (value == 0) {
263             return "0";
264         }
265         uint256 temp = value;
266         uint256 digits;
267         while (temp != 0) {
268             digits++;
269             temp /= 10;
270         }
271         bytes memory buffer = new bytes(digits);
272         while (value != 0) {
273             digits -= 1;
274             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
275             value /= 10;
276         }
277         return string(buffer);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
282      */
283     function toHexString(uint256 value) internal pure returns (string memory) {
284         if (value == 0) {
285             return "0x00";
286         }
287         uint256 temp = value;
288         uint256 length = 0;
289         while (temp != 0) {
290             length++;
291             temp >>= 8;
292         }
293         return toHexString(value, length);
294     }
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
298      */
299     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
300         bytes memory buffer = new bytes(2 * length + 2);
301         buffer[0] = "0";
302         buffer[1] = "x";
303         for (uint256 i = 2 * length + 1; i > 1; --i) {
304             buffer[i] = _HEX_SYMBOLS[value & 0xf];
305             value >>= 4;
306         }
307         require(value == 0, "Strings: hex length insufficient");
308         return string(buffer);
309     }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Address.sol
313 
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Collection of functions related to the address type
320  */
321 library Address {
322     /**
323      * @dev Returns true if `account` is a contract.
324      *
325      * [IMPORTANT]
326      * ====
327      * It is unsafe to assume that an address for which this function returns
328      * false is an externally-owned account (EOA) and not a contract.
329      *
330      * Among others, `isContract` will return false for the following
331      * types of addresses:
332      *
333      *  - an externally-owned account
334      *  - a contract in construction
335      *  - an address where a contract will be created
336      *  - an address where a contract lived, but was destroyed
337      * ====
338      */
339     function isContract(address account) internal view returns (bool) {
340         // This method relies on extcodesize, which returns 0 for contracts in
341         // construction, since the code is only stored at the end of the
342         // constructor execution.
343 
344         uint256 size;
345         assembly {
346             size := extcodesize(account)
347         }
348         return size > 0;
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         (bool success, ) = recipient.call{value: amount}("");
371         require(success, "Address: unable to send value, recipient may have reverted");
372     }
373 
374     /**
375      * @dev Performs a Solidity function call using a low level `call`. A
376      * plain `call` is an unsafe replacement for a function call: use this
377      * function instead.
378      *
379      * If `target` reverts with a revert reason, it is bubbled up by this
380      * function (like regular Solidity function calls).
381      *
382      * Returns the raw returned data. To convert to the expected return value,
383      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
384      *
385      * Requirements:
386      *
387      * - `target` must be a contract.
388      * - calling `target` with `data` must not revert.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionCall(target, data, "Address: low-level call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
398      * `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, 0, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but also transferring `value` wei to `target`.
413      *
414      * Requirements:
415      *
416      * - the calling contract must have an ETH balance of at least `value`.
417      * - the called Solidity function must be `payable`.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value
425     ) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         require(address(this).balance >= value, "Address: insufficient balance for call");
442         require(isContract(target), "Address: call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.call{value: value}(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
455         return functionStaticCall(target, data, "Address: low-level static call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal view returns (bytes memory) {
469         require(isContract(target), "Address: static call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.staticcall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.delegatecall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
504      * revert reason using the provided one.
505      *
506      * _Available since v4.3._
507      */
508     function verifyCallResult(
509         bool success,
510         bytes memory returndata,
511         string memory errorMessage
512     ) internal pure returns (bytes memory) {
513         if (success) {
514             return returndata;
515         } else {
516             // Look for revert reason and bubble it up if present
517             if (returndata.length > 0) {
518                 // The easiest way to bubble the revert reason is using memory via assembly
519 
520                 assembly {
521                     let returndata_size := mload(returndata)
522                     revert(add(32, returndata), returndata_size)
523                 }
524             } else {
525                 revert(errorMessage);
526             }
527         }
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
560 
561 
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title ERC721 token receiver interface
567  * @dev Interface for any contract that wants to support safeTransfers
568  * from ERC721 asset contracts.
569  */
570 interface IERC721Receiver {
571     /**
572      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
573      * by `operator` from `from`, this function is called.
574      *
575      * It must return its Solidity selector to confirm the token transfer.
576      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
577      *
578      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
579      */
580     function onERC721Received(
581         address operator,
582         address from,
583         uint256 tokenId,
584         bytes calldata data
585     ) external returns (bytes4);
586 }
587 
588 // File: @openzeppelin/contracts/utils/Context.sol
589 pragma solidity ^0.8.0;
590 /**
591  * @dev Provides information about the current execution context, including the
592  * sender of the transaction and its data. While these are generally available
593  * via msg.sender and msg.data, they should not be accessed in such a direct
594  * manner, since when dealing with meta-transactions the account sending and
595  * paying for execution may not be the actual sender (as far as an application
596  * is concerned).
597  *
598  * This contract is only required for intermediate, library-like contracts.
599  */
600 abstract contract Context {
601     function _msgSender() internal view virtual returns (address) {
602         return msg.sender;
603     }
604 
605     function _msgData() internal view virtual returns (bytes calldata) {
606         return msg.data;
607     }
608 }
609 
610 
611 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
612 pragma solidity ^0.8.0;
613 /**
614  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
615  * the Metadata extension, but not including the Enumerable extension, which is available separately as
616  * {ERC721Enumerable}.
617  */
618 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
619     using Address for address;
620     using Strings for uint256;
621 
622     // Token name
623     string private _name;
624 
625     // Token symbol
626     string private _symbol;
627 
628     // Mapping from token ID to owner address
629     mapping(uint256 => address) private _owners;
630 
631     // Mapping owner address to token count
632     mapping(address => uint256) private _balances;
633 
634     // Mapping from token ID to approved address
635     mapping(uint256 => address) private _tokenApprovals;
636 
637     // Mapping from owner to operator approvals
638     mapping(address => mapping(address => bool)) private _operatorApprovals;
639 
640     /**
641      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
642      */
643     constructor(string memory name_, string memory symbol_) {
644         _name = name_;
645         _symbol = symbol_;
646     }
647 
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
652         return
653             interfaceId == type(IERC721).interfaceId ||
654             interfaceId == type(IERC721Metadata).interfaceId ||
655             super.supportsInterface(interfaceId);
656     }
657 
658     /**
659      * @dev See {IERC721-balanceOf}.
660      */
661     function balanceOf(address owner) public view virtual override returns (uint256) {
662         require(owner != address(0), "ERC721: balance query for the zero address");
663         return _balances[owner];
664     }
665 
666     /**
667      * @dev See {IERC721-ownerOf}.
668      */
669     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
670         address owner = _owners[tokenId];
671         require(owner != address(0), "ERC721: owner query for nonexistent token");
672         return owner;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-name}.
677      */
678     function name() public view virtual override returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-symbol}.
684      */
685     function symbol() public view virtual override returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-tokenURI}.
691      */
692     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
693         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
694 
695         string memory baseURI = _baseURI();
696         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
697     }
698 
699     /**
700      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
701      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
702      * by default, can be overriden in child contracts.
703      */
704     function _baseURI() internal view virtual returns (string memory) {
705         return "";
706     }
707 
708     /**
709      * @dev See {IERC721-approve}.
710      */
711     function approve(address to, uint256 tokenId) public virtual override {
712         address owner = ERC721.ownerOf(tokenId);
713         require(to != owner, "ERC721: approval to current owner");
714 
715         require(
716             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
717             "ERC721: approve caller is not owner nor approved for all"
718         );
719 
720         _approve(to, tokenId);
721     }
722 
723     /**
724      * @dev See {IERC721-getApproved}.
725      */
726     function getApproved(uint256 tokenId) public view virtual override returns (address) {
727         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
728 
729         return _tokenApprovals[tokenId];
730     }
731 
732     /**
733      * @dev See {IERC721-setApprovalForAll}.
734      */
735     function setApprovalForAll(address operator, bool approved) public virtual override {
736         require(operator != _msgSender(), "ERC721: approve to caller");
737 
738         _operatorApprovals[_msgSender()][operator] = approved;
739         emit ApprovalForAll(_msgSender(), operator, approved);
740     }
741 
742     /**
743      * @dev See {IERC721-isApprovedForAll}.
744      */
745     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
746         return _operatorApprovals[owner][operator];
747     }
748 
749     /**
750      * @dev See {IERC721-transferFrom}.
751      */
752     function transferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         //solhint-disable-next-line max-line-length
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759 
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         safeTransferFrom(from, to, tokenId, "");
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) public virtual override {
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784         _safeTransfer(from, to, tokenId, _data);
785     }
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
789      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
790      *
791      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
792      *
793      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
794      * implement alternative mechanisms to perform token transfer, such as signature-based.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must exist and be owned by `from`.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _safeTransfer(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _transfer(from, to, tokenId);
812         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
813     }
814 
815     /**
816      * @dev Returns whether `tokenId` exists.
817      *
818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
819      *
820      * Tokens start existing when they are minted (`_mint`),
821      * and stop existing when they are burned (`_burn`).
822      */
823     function _exists(uint256 tokenId) internal view virtual returns (bool) {
824         return _owners[tokenId] != address(0);
825     }
826 
827     /**
828      * @dev Returns whether `spender` is allowed to manage `tokenId`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
835         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
836         address owner = ERC721.ownerOf(tokenId);
837         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
838     }
839 
840     /**
841      * @dev Safely mints `tokenId` and transfers it to `to`.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must not exist.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _safeMint(address to, uint256 tokenId) internal virtual {
851         _safeMint(to, tokenId, "");
852     }
853 
854     /**
855      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
856      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
857      */
858     function _safeMint(
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) internal virtual {
863         _mint(to, tokenId);
864         require(
865             _checkOnERC721Received(address(0), to, tokenId, _data),
866             "ERC721: transfer to non ERC721Receiver implementer"
867         );
868     }
869 
870     /**
871      * @dev Mints `tokenId` and transfers it to `to`.
872      *
873      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
874      *
875      * Requirements:
876      *
877      * - `tokenId` must not exist.
878      * - `to` cannot be the zero address.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _mint(address to, uint256 tokenId) internal virtual {
883         require(to != address(0), "ERC721: mint to the zero address");
884         require(!_exists(tokenId), "ERC721: token already minted");
885 
886         _beforeTokenTransfer(address(0), to, tokenId);
887 
888         _balances[to] += 1;
889         _owners[tokenId] = to;
890 
891         emit Transfer(address(0), to, tokenId);
892     }
893 
894     /**
895      * @dev Destroys `tokenId`.
896      * The approval is cleared when the token is burned.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _burn(uint256 tokenId) internal virtual {
905         address owner = ERC721.ownerOf(tokenId);
906 
907         _beforeTokenTransfer(owner, address(0), tokenId);
908 
909         // Clear approvals
910         _approve(address(0), tokenId);
911 
912         _balances[owner] -= 1;
913         delete _owners[tokenId];
914 
915         emit Transfer(owner, address(0), tokenId);
916     }
917 
918     /**
919      * @dev Transfers `tokenId` from `from` to `to`.
920      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
921      *
922      * Requirements:
923      *
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must be owned by `from`.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _transfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {
934         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
935         require(to != address(0), "ERC721: transfer to the zero address");
936 
937         _beforeTokenTransfer(from, to, tokenId);
938 
939         // Clear approvals from the previous owner
940         _approve(address(0), tokenId);
941 
942         _balances[from] -= 1;
943         _balances[to] += 1;
944         _owners[tokenId] = to;
945 
946         emit Transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits a {Approval} event.
953      */
954     function _approve(address to, uint256 tokenId) internal virtual {
955         _tokenApprovals[tokenId] = to;
956         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
957     }
958 
959     /**
960      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
961      * The call is not executed if the target address is not a contract.
962      *
963      * @param from address representing the previous owner of the given token ID
964      * @param to target address that will receive the tokens
965      * @param tokenId uint256 ID of the token to be transferred
966      * @param _data bytes optional data to send along with the call
967      * @return bool whether the call correctly returned the expected magic value
968      */
969     function _checkOnERC721Received(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) private returns (bool) {
975         if (to.isContract()) {
976             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
977                 return retval == IERC721Receiver.onERC721Received.selector;
978             } catch (bytes memory reason) {
979                 if (reason.length == 0) {
980                     revert("ERC721: transfer to non ERC721Receiver implementer");
981                 } else {
982                     assembly {
983                         revert(add(32, reason), mload(reason))
984                     }
985                 }
986             }
987         } else {
988             return true;
989         }
990     }
991 
992     /**
993      * @dev Hook that is called before any token transfer. This includes minting
994      * and burning.
995      *
996      * Calling conditions:
997      *
998      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
999      * transferred to `to`.
1000      * - When `from` is zero, `tokenId` will be minted for `to`.
1001      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1002      * - `from` and `to` are never both zero.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {}
1011 }
1012 
1013 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1014 
1015 
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 
1021 /**
1022  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1023  * enumerability of all the token ids in the contract as well as all token ids owned by each
1024  * account.
1025  */
1026 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1027     // Mapping from owner to list of owned token IDs
1028     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1029 
1030     // Mapping from token ID to index of the owner tokens list
1031     mapping(uint256 => uint256) private _ownedTokensIndex;
1032 
1033     // Array with all token ids, used for enumeration
1034     uint256[] private _allTokens;
1035 
1036     // Mapping from token id to position in the allTokens array
1037     mapping(uint256 => uint256) private _allTokensIndex;
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1043         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1048      */
1049     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1050         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1051         return _ownedTokens[owner][index];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-totalSupply}.
1056      */
1057     function totalSupply() public view virtual override returns (uint256) {
1058         return _allTokens.length;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Enumerable-tokenByIndex}.
1063      */
1064     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1065         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1066         return _allTokens[index];
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual override {
1089         super._beforeTokenTransfer(from, to, tokenId);
1090 
1091         if (from == address(0)) {
1092             _addTokenToAllTokensEnumeration(tokenId);
1093         } else if (from != to) {
1094             _removeTokenFromOwnerEnumeration(from, tokenId);
1095         }
1096         if (to == address(0)) {
1097             _removeTokenFromAllTokensEnumeration(tokenId);
1098         } else if (to != from) {
1099             _addTokenToOwnerEnumeration(to, tokenId);
1100         }
1101     }
1102 
1103     /**
1104      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1105      * @param to address representing the new owner of the given token ID
1106      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1107      */
1108     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1109         uint256 length = ERC721.balanceOf(to);
1110         _ownedTokens[to][length] = tokenId;
1111         _ownedTokensIndex[tokenId] = length;
1112     }
1113 
1114     /**
1115      * @dev Private function to add a token to this extension's token tracking data structures.
1116      * @param tokenId uint256 ID of the token to be added to the tokens list
1117      */
1118     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1119         _allTokensIndex[tokenId] = _allTokens.length;
1120         _allTokens.push(tokenId);
1121     }
1122 
1123     /**
1124      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1125      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1126      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1127      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1128      * @param from address representing the previous owner of the given token ID
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1130      */
1131     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1132         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1136         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary
1139         if (tokenIndex != lastTokenIndex) {
1140             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1141 
1142             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1143             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1144         }
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _ownedTokensIndex[tokenId];
1148         delete _ownedTokens[from][lastTokenIndex];
1149     }
1150 
1151     /**
1152      * @dev Private function to remove a token from this extension's token tracking data structures.
1153      * This has O(1) time complexity, but alters the order of the _allTokens array.
1154      * @param tokenId uint256 ID of the token to be removed from the tokens list
1155      */
1156     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1157         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1158         // then delete the last slot (swap and pop).
1159 
1160         uint256 lastTokenIndex = _allTokens.length - 1;
1161         uint256 tokenIndex = _allTokensIndex[tokenId];
1162 
1163         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1164         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1165         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1166         uint256 lastTokenId = _allTokens[lastTokenIndex];
1167 
1168         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1169         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1170 
1171         // This also deletes the contents at the last position of the array
1172         delete _allTokensIndex[tokenId];
1173         _allTokens.pop();
1174     }
1175 }
1176 
1177 
1178 // File: @openzeppelin/contracts/access/Ownable.sol
1179 pragma solidity ^0.8.0;
1180 /**
1181  * @dev Contract module which provides a basic access control mechanism, where
1182  * there is an account (an owner) that can be granted exclusive access to
1183  * specific functions.
1184  *
1185  * By default, the owner account will be the one that deploys the contract. This
1186  * can later be changed with {transferOwnership}.
1187  *
1188  * This module is used through inheritance. It will make available the modifier
1189  * `onlyOwner`, which can be applied to your functions to restrict their use to
1190  * the owner.
1191  */
1192 abstract contract Ownable is Context {
1193     address private _owner;
1194 
1195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1196 
1197     /**
1198      * @dev Initializes the contract setting the deployer as the initial owner.
1199      */
1200     constructor() {
1201         _setOwner(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if called by any account other than the owner.
1213      */
1214     modifier onlyOwner() {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216         _;
1217     }
1218 
1219     /**
1220      * @dev Leaves the contract without owner. It will not be possible to call
1221      * `onlyOwner` functions anymore. Can only be called by the current owner.
1222      *
1223      * NOTE: Renouncing ownership will leave the contract without an owner,
1224      * thereby removing any functionality that is only available to the owner.
1225      */
1226     function renounceOwnership() public virtual onlyOwner {
1227         _setOwner(address(0));
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Can only be called by the current owner.
1233      */
1234     function transferOwnership(address newOwner) public virtual onlyOwner {
1235         require(newOwner != address(0), "Ownable: new owner is the zero address");
1236         _setOwner(newOwner);
1237     }
1238 
1239     function _setOwner(address newOwner) private {
1240         address oldOwner = _owner;
1241         _owner = newOwner;
1242         emit OwnershipTransferred(oldOwner, newOwner);
1243     }
1244 }
1245 
1246 pragma solidity >=0.7.0 <0.9.0;
1247 
1248 contract TexasPumpJack is ERC721Enumerable, Ownable {
1249   using Strings for uint256;
1250 
1251   string baseURI;
1252   string public baseExtension = ".json";
1253   uint256 public cost = 0 ether;
1254   uint256 public maxSupply = 3500;
1255   uint256 public maxMintAmount = 3;
1256   bool public paused = false;
1257   bool public revealed = false;
1258   string public notRevealedUri;
1259 
1260   constructor(
1261     string memory _name,
1262     string memory _symbol,
1263     string memory _initBaseURI,
1264     string memory _initNotRevealedUri
1265   ) ERC721(_name, _symbol) {
1266     setBaseURI(_initBaseURI);
1267     setNotRevealedURI(_initNotRevealedUri);
1268   }
1269 
1270   // internal
1271   function _baseURI() internal view virtual override returns (string memory) {
1272     return baseURI;
1273   }
1274 
1275   // public
1276   function mint(uint256 _mintAmount) public payable {
1277     uint256 supply = totalSupply();
1278     require(!paused);
1279     require(_mintAmount > 0);
1280     require(_mintAmount <= maxMintAmount);
1281     require(supply + _mintAmount <= maxSupply);
1282 
1283     if (msg.sender != owner()) {
1284       require(msg.value >= cost * _mintAmount);
1285     }
1286 
1287     for (uint256 i = 1; i <= _mintAmount; i++) {
1288       _safeMint(msg.sender, supply + i);
1289     }
1290   }
1291 
1292   function walletOfOwner(address _owner)
1293     public
1294     view
1295     returns (uint256[] memory)
1296   {
1297     uint256 ownerTokenCount = balanceOf(_owner);
1298     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1299     for (uint256 i; i < ownerTokenCount; i++) {
1300       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1301     }
1302     return tokenIds;
1303   }
1304 
1305   function tokenURI(uint256 tokenId)
1306     public
1307     view
1308     virtual
1309     override
1310     returns (string memory)
1311   {
1312     require(
1313       _exists(tokenId),
1314       "ERC721Metadata: URI query for nonexistent token"
1315     );
1316     
1317     if(revealed == false) {
1318         return notRevealedUri;
1319     }
1320 
1321     string memory currentBaseURI = _baseURI();
1322     return bytes(currentBaseURI).length > 0
1323         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1324         : "";
1325   }
1326 
1327   //only owner
1328   function reveal() public onlyOwner {
1329       revealed = true;
1330   }
1331   
1332   function setCost(uint256 _newCost) public onlyOwner {
1333     cost = _newCost;
1334   }
1335 
1336   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1337     maxMintAmount = _newmaxMintAmount;
1338   }
1339   
1340   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1341     notRevealedUri = _notRevealedURI;
1342   }
1343 
1344   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1345     baseURI = _newBaseURI;
1346   }
1347 
1348   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1349     baseExtension = _newBaseExtension;
1350   }
1351 
1352   function pause(bool _state) public onlyOwner {
1353     paused = _state;
1354   }
1355  
1356   function withdraw() public payable onlyOwner {
1357     // This will pay Clayco 5% of the initial sale.
1358     // You can remove this if you want, or keep it in to support Clayco and his channel.
1359     // =============================================================================
1360     (bool hs, ) = payable(0xd1B796B04f31059B7F4FaFaA5BB77fc5EB34fb9e).call{value: address(this).balance * 5 / 100}("");
1361     require(hs);
1362     // =============================================================================
1363     
1364     // This will payout the owner 95% of the contract balance.
1365     // Do not remove this otherwise you will not be able to withdraw the funds.
1366     // =============================================================================
1367     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1368     require(os);
1369     // =============================================================================
1370   }
1371 }