1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-09
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 
7 // Amended by HashLips
8 /**
9     !Disclaimer!
10     These contracts have been used to create tutorials,
11     and was created for the purpose to teach people
12     how to create smart contracts on the blockchain.
13     please review this code on your own before using any of
14     the following code for production.
15     HashLips will not be liable in any way if for the use 
16     of the code. That being said, the code has been tested 
17     to the best of the developers' knowledge to work as intended.
18 */
19 
20 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
21 pragma solidity ^0.8.0;
22 /**
23  * @dev Interface of the ERC165 standard, as defined in the
24  * https://eips.ethereum.org/EIPS/eip-165[EIP].
25  *
26  * Implementers can declare support of contract interfaces, which can then be
27  * queried by others ({ERC165Checker}).
28  *
29  * For an implementation, see {ERC165}.
30  */
31 interface IERC165 {
32     /**
33      * @dev Returns true if this contract implements the interface defined by
34      * `interfaceId`. See the corresponding
35      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
36      * to learn more about how these ids are created.
37      *
38      * This function call must use less than 30 000 gas.
39      */
40     function supportsInterface(bytes4 interfaceId) external view returns (bool);
41 }
42 
43 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
44 pragma solidity ^0.8.0;
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 
183 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
184 pragma solidity ^0.8.0;
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Enumerable is IERC721 {
190     /**
191      * @dev Returns the total amount of tokens stored by the contract.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
197      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
198      */
199     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
200 
201     /**
202      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
203      * Use along with {totalSupply} to enumerate all tokens.
204      */
205     function tokenByIndex(uint256 index) external view returns (uint256);
206 }
207 
208 
209 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
210 pragma solidity ^0.8.0;
211 /**
212  * @dev Implementation of the {IERC165} interface.
213  *
214  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
215  * for the additional interface id that will be supported. For example:
216  *
217  * ```solidity
218  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
219  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
220  * }
221  * ```
222  *
223  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
224  */
225 abstract contract ERC165 is IERC165 {
226     /**
227      * @dev See {IERC165-supportsInterface}.
228      */
229     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230         return interfaceId == type(IERC165).interfaceId;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Strings.sol
235 
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev String operations.
242  */
243 library Strings {
244     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
248      */
249     function toString(uint256 value) internal pure returns (string memory) {
250         // Inspired by OraclizeAPI's implementation - MIT licence
251         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
252 
253         if (value == 0) {
254             return "0";
255         }
256         uint256 temp = value;
257         uint256 digits;
258         while (temp != 0) {
259             digits++;
260             temp /= 10;
261         }
262         bytes memory buffer = new bytes(digits);
263         while (value != 0) {
264             digits -= 1;
265             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
266             value /= 10;
267         }
268         return string(buffer);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
273      */
274     function toHexString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0x00";
277         }
278         uint256 temp = value;
279         uint256 length = 0;
280         while (temp != 0) {
281             length++;
282             temp >>= 8;
283         }
284         return toHexString(value, length);
285     }
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
289      */
290     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
291         bytes memory buffer = new bytes(2 * length + 2);
292         buffer[0] = "0";
293         buffer[1] = "x";
294         for (uint256 i = 2 * length + 1; i > 1; --i) {
295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
296             value >>= 4;
297         }
298         require(value == 0, "Strings: hex length insufficient");
299         return string(buffer);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Address.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Collection of functions related to the address type
311  */
312 library Address {
313     /**
314      * @dev Returns true if `account` is a contract.
315      *
316      * [IMPORTANT]
317      * ====
318      * It is unsafe to assume that an address for which this function returns
319      * false is an externally-owned account (EOA) and not a contract.
320      *
321      * Among others, `isContract` will return false for the following
322      * types of addresses:
323      *
324      *  - an externally-owned account
325      *  - a contract in construction
326      *  - an address where a contract will be created
327      *  - an address where a contract lived, but was destroyed
328      * ====
329      */
330     function isContract(address account) internal view returns (bool) {
331         // This method relies on extcodesize, which returns 0 for contracts in
332         // construction, since the code is only stored at the end of the
333         // constructor execution.
334 
335         uint256 size;
336         assembly {
337             size := extcodesize(account)
338         }
339         return size > 0;
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      */
358     function sendValue(address payable recipient, uint256 amount) internal {
359         require(address(this).balance >= amount, "Address: insufficient balance");
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain `call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422      * with `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.call{value: value}(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
523 
524 
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
531  * @dev See https://eips.ethereum.org/EIPS/eip-721
532  */
533 interface IERC721Metadata is IERC721 {
534     /**
535      * @dev Returns the token collection name.
536      */
537     function name() external view returns (string memory);
538 
539     /**
540      * @dev Returns the token collection symbol.
541      */
542     function symbol() external view returns (string memory);
543 
544     /**
545      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
546      */
547     function tokenURI(uint256 tokenId) external view returns (string memory);
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
551 
552 
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @title ERC721 token receiver interface
558  * @dev Interface for any contract that wants to support safeTransfers
559  * from ERC721 asset contracts.
560  */
561 interface IERC721Receiver {
562     /**
563      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
564      * by `operator` from `from`, this function is called.
565      *
566      * It must return its Solidity selector to confirm the token transfer.
567      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
568      *
569      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
570      */
571     function onERC721Received(
572         address operator,
573         address from,
574         uint256 tokenId,
575         bytes calldata data
576     ) external returns (bytes4);
577 }
578 
579 // File: @openzeppelin/contracts/utils/Context.sol
580 pragma solidity ^0.8.0;
581 /**
582  * @dev Provides information about the current execution context, including the
583  * sender of the transaction and its data. While these are generally available
584  * via msg.sender and msg.data, they should not be accessed in such a direct
585  * manner, since when dealing with meta-transactions the account sending and
586  * paying for execution may not be the actual sender (as far as an application
587  * is concerned).
588  *
589  * This contract is only required for intermediate, library-like contracts.
590  */
591 abstract contract Context {
592     function _msgSender() internal view virtual returns (address) {
593         return msg.sender;
594     }
595 
596     function _msgData() internal view virtual returns (bytes calldata) {
597         return msg.data;
598     }
599 }
600 
601 
602 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
603 pragma solidity ^0.8.0;
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: balance query for the zero address");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: owner query for nonexistent token");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overriden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         require(operator != _msgSender(), "ERC721: approve to caller");
728 
729         _operatorApprovals[_msgSender()][operator] = approved;
730         emit ApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750 
751         _transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817 
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
827         address owner = ERC721.ownerOf(tokenId);
828         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
829     }
830 
831     /**
832      * @dev Safely mints `tokenId` and transfers it to `to`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(address to, uint256 tokenId) internal virtual {
842         _safeMint(to, tokenId, "");
843     }
844 
845     /**
846      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
847      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
848      */
849     function _safeMint(
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _mint(to, tokenId);
855         require(
856             _checkOnERC721Received(address(0), to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         address owner = ERC721.ownerOf(tokenId);
897 
898         _beforeTokenTransfer(owner, address(0), tokenId);
899 
900         // Clear approvals
901         _approve(address(0), tokenId);
902 
903         _balances[owner] -= 1;
904         delete _owners[tokenId];
905 
906         emit Transfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {
925         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
926         require(to != address(0), "ERC721: transfer to the zero address");
927 
928         _beforeTokenTransfer(from, to, tokenId);
929 
930         // Clear approvals from the previous owner
931         _approve(address(0), tokenId);
932 
933         _balances[from] -= 1;
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `to` to operate on `tokenId`
942      *
943      * Emits a {Approval} event.
944      */
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver.onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1005 
1006 
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 
1012 /**
1013  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1014  * enumerability of all the token ids in the contract as well as all token ids owned by each
1015  * account.
1016  */
1017 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1018     // Mapping from owner to list of owned token IDs
1019     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1020 
1021     // Mapping from token ID to index of the owner tokens list
1022     mapping(uint256 => uint256) private _ownedTokensIndex;
1023 
1024     // Array with all token ids, used for enumeration
1025     uint256[] private _allTokens;
1026 
1027     // Mapping from token id to position in the allTokens array
1028     mapping(uint256 => uint256) private _allTokensIndex;
1029 
1030     /**
1031      * @dev See {IERC165-supportsInterface}.
1032      */
1033     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1034         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1039      */
1040     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1041         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1042         return _ownedTokens[owner][index];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Enumerable-totalSupply}.
1047      */
1048     function totalSupply() public view virtual override returns (uint256) {
1049         return _allTokens.length;
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-tokenByIndex}.
1054      */
1055     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1056         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1057         return _allTokens[index];
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before any token transfer. This includes minting
1062      * and burning.
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` will be minted for `to`.
1069      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1070      * - `from` cannot be the zero address.
1071      * - `to` cannot be the zero address.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) internal virtual override {
1080         super._beforeTokenTransfer(from, to, tokenId);
1081 
1082         if (from == address(0)) {
1083             _addTokenToAllTokensEnumeration(tokenId);
1084         } else if (from != to) {
1085             _removeTokenFromOwnerEnumeration(from, tokenId);
1086         }
1087         if (to == address(0)) {
1088             _removeTokenFromAllTokensEnumeration(tokenId);
1089         } else if (to != from) {
1090             _addTokenToOwnerEnumeration(to, tokenId);
1091         }
1092     }
1093 
1094     /**
1095      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1096      * @param to address representing the new owner of the given token ID
1097      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1098      */
1099     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1100         uint256 length = ERC721.balanceOf(to);
1101         _ownedTokens[to][length] = tokenId;
1102         _ownedTokensIndex[tokenId] = length;
1103     }
1104 
1105     /**
1106      * @dev Private function to add a token to this extension's token tracking data structures.
1107      * @param tokenId uint256 ID of the token to be added to the tokens list
1108      */
1109     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1110         _allTokensIndex[tokenId] = _allTokens.length;
1111         _allTokens.push(tokenId);
1112     }
1113 
1114     /**
1115      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1116      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1117      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1118      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1119      * @param from address representing the previous owner of the given token ID
1120      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1121      */
1122     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1123         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1124         // then delete the last slot (swap and pop).
1125 
1126         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1127         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1128 
1129         // When the token to delete is the last token, the swap operation is unnecessary
1130         if (tokenIndex != lastTokenIndex) {
1131             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1132 
1133             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1134             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1135         }
1136 
1137         // This also deletes the contents at the last position of the array
1138         delete _ownedTokensIndex[tokenId];
1139         delete _ownedTokens[from][lastTokenIndex];
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's token tracking data structures.
1144      * This has O(1) time complexity, but alters the order of the _allTokens array.
1145      * @param tokenId uint256 ID of the token to be removed from the tokens list
1146      */
1147     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1148         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1149         // then delete the last slot (swap and pop).
1150 
1151         uint256 lastTokenIndex = _allTokens.length - 1;
1152         uint256 tokenIndex = _allTokensIndex[tokenId];
1153 
1154         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1155         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1156         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1157         uint256 lastTokenId = _allTokens[lastTokenIndex];
1158 
1159         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1160         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1161 
1162         // This also deletes the contents at the last position of the array
1163         delete _allTokensIndex[tokenId];
1164         _allTokens.pop();
1165     }
1166 }
1167 
1168 
1169 // File: @openzeppelin/contracts/access/Ownable.sol
1170 pragma solidity ^0.8.0;
1171 /**
1172  * @dev Contract module which provides a basic access control mechanism, where
1173  * there is an account (an owner) that can be granted exclusive access to
1174  * specific functions.
1175  *
1176  * By default, the owner account will be the one that deploys the contract. This
1177  * can later be changed with {transferOwnership}.
1178  *
1179  * This module is used through inheritance. It will make available the modifier
1180  * `onlyOwner`, which can be applied to your functions to restrict their use to
1181  * the owner.
1182  */
1183 abstract contract Ownable is Context {
1184     address private _owner;
1185 
1186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1187 
1188     /**
1189      * @dev Initializes the contract setting the deployer as the initial owner.
1190      */
1191     constructor() {
1192         _setOwner(_msgSender());
1193     }
1194 
1195     /**
1196      * @dev Returns the address of the current owner.
1197      */
1198     function owner() public view virtual returns (address) {
1199         return _owner;
1200     }
1201 
1202     /**
1203      * @dev Throws if called by any account other than the owner.
1204      */
1205     modifier onlyOwner() {
1206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1207         _;
1208     }
1209 
1210     /**
1211      * @dev Leaves the contract without owner. It will not be possible to call
1212      * `onlyOwner` functions anymore. Can only be called by the current owner.
1213      *
1214      * NOTE: Renouncing ownership will leave the contract without an owner,
1215      * thereby removing any functionality that is only available to the owner.
1216      */
1217     function renounceOwnership() public virtual onlyOwner {
1218         _setOwner(address(0));
1219     }
1220 
1221     /**
1222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1223      * Can only be called by the current owner.
1224      */
1225     function transferOwnership(address newOwner) public virtual onlyOwner {
1226         require(newOwner != address(0), "Ownable: new owner is the zero address");
1227         _setOwner(newOwner);
1228     }
1229 
1230     function _setOwner(address newOwner) private {
1231         address oldOwner = _owner;
1232         _owner = newOwner;
1233         emit OwnershipTransferred(oldOwner, newOwner);
1234     }
1235 }
1236 
1237 
1238 pragma solidity >=0.7.0 <0.9.0;
1239 
1240 contract HSC is ERC721Enumerable, Ownable {
1241   using Strings for uint256;
1242 
1243   string public baseURI;
1244   string public baseExtension = ".json";
1245   string public notRevealedUri;
1246   uint256 public cost = 0.055 ether;
1247   uint256 public maxSupply = 5555;
1248   uint256 public maxMintAmount = 5;
1249   uint256 public nftPerAddressLimit = 100;
1250   bool public paused = true;
1251   bool public revealed = true;
1252   bool public onlyWhitelisted = false;
1253   address[] public whitelistedAddresses;
1254 //   mapping(address=>bool) public whitelistedAddresses;
1255   mapping(address => uint256) public addressMintedBalance;
1256 
1257   constructor(
1258     string memory _name,
1259     string memory _symbol,
1260     string memory _initBaseURI,
1261     string memory _initNotRevealedUri
1262   ) ERC721(_name, _symbol) {
1263     setBaseURI(_initBaseURI);
1264     setNotRevealedURI(_initNotRevealedUri);
1265   }
1266 
1267   // internal
1268   function _baseURI() internal view virtual override returns (string memory) {
1269     return baseURI;
1270   }
1271 
1272   // public
1273   function mint(uint256 _mintAmount) public payable {
1274     require(!paused, "the contract is paused");
1275     uint256 supply = totalSupply();
1276     uint256 differCost = cost;
1277     require(_mintAmount > 0, "need to mint at least 1 NFT");
1278     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1279     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1280 
1281     if (msg.sender != owner()) {
1282         if(onlyWhitelisted == true) {
1283             differCost = 0 ether;
1284             require(isWhitelisted(msg.sender), "user is not whitelisted");
1285             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1286             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1287         }
1288         require(msg.value >= differCost * _mintAmount, "insufficient funds");
1289     }
1290 
1291     for (uint256 i = 1; i <= _mintAmount; i++) {
1292       addressMintedBalance[msg.sender]++;
1293       _safeMint(msg.sender, supply + i);
1294     }
1295 
1296   }
1297   
1298   //giveaway
1299     function giveaway(address[] calldata _address, uint256 _newCost) public payable onlyOwner{
1300         for (uint i = 0; i < _address.length; i++) {
1301             (bool gs, ) = payable(_address[i]).call{value: _newCost}("");
1302             require(gs);
1303         }
1304     }
1305 
1306   function isWhitelisted(address _user) public view returns (bool) {
1307     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1308       if (whitelistedAddresses[i] == _user) {
1309           return true;
1310       }
1311     }
1312     return false;
1313   }
1314 
1315   function walletOfOwner(address _owner)
1316     public
1317     view
1318     returns (uint256[] memory)
1319   {
1320     uint256 ownerTokenCount = balanceOf(_owner);
1321     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1322     for (uint256 i; i < ownerTokenCount; i++) {
1323       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1324     }
1325     return tokenIds;
1326   }
1327 
1328   function tokenURI(uint256 tokenId)
1329     public
1330     view
1331     virtual
1332     override
1333     returns (string memory)
1334   {
1335     require(
1336       _exists(tokenId),
1337       "ERC721Metadata: URI query for nonexistent token"
1338     );
1339     
1340     if(revealed == false) {
1341         return notRevealedUri;
1342     }
1343 
1344     string memory currentBaseURI = _baseURI();
1345     return bytes(currentBaseURI).length > 0
1346         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1347         : "";
1348   }
1349 
1350   //only owner
1351   function reveal() public onlyOwner {
1352       revealed = true;
1353   }
1354   
1355   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1356     nftPerAddressLimit = _limit;
1357   }
1358   
1359   function setCost(uint256 _newCost) public onlyOwner {
1360     cost = _newCost;
1361   }
1362 
1363   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1364     maxMintAmount = _newmaxMintAmount;
1365   }
1366 
1367   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1368     baseURI = _newBaseURI;
1369   }
1370 
1371   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1372     baseExtension = _newBaseExtension;
1373   }
1374   
1375   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1376     notRevealedUri = _notRevealedURI;
1377   }
1378 
1379   function pause(bool _state) public onlyOwner {
1380     paused = _state;
1381   }
1382   
1383   function setOnlyWhitelisted(bool _state) public onlyOwner {
1384     onlyWhitelisted = _state;
1385   }
1386 
1387   function addWhitelistUsers(address[] calldata _addresses) public onlyOwner {
1388     for(uint i=0; i<_addresses.length; i++){
1389         whitelistedAddresses.push(_addresses[i]);
1390     }
1391   }
1392 
1393   function removeWhitelistUsers() public onlyOwner {
1394     delete whitelistedAddresses;
1395   }
1396  
1397   function withdraw() public payable onlyOwner {
1398  
1399     (bool hs, ) = payable(0x93e793F06B783551B82B9BB1fB1617EE8F2062b0).call{value: address(this).balance * 25 / 100}("");
1400     require(hs);
1401 
1402     // Do not remove this otherwise you will not be able to withdraw the funds.
1403     // =============================================================================
1404     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1405     require(os);
1406     // =============================================================================
1407 
1408   }
1409 }