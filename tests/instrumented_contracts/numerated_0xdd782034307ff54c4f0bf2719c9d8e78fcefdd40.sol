1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-23
3 */
4 
5 //     _   ____________  _   __   ____  __    _______  ____  _______
6 //    / | / / ____/ __ \/ | / /  / __ \/ /   / ____/ |/ / / / / ___/
7 //   /  |/ / __/ / / / /  |/ /  / /_/ / /   / __/  |   / / / /\__ \ 
8 //  / /|  / /___/ /_/ / /|  /  / ____/ /___/ /___ /   / /_/ /___/ / 
9 // /_/_|_/_____/\____/_/_|_/  /_/_  /_____/_____//_/|_\____//____/  
10 //  / __ \ |  / / ____/ __ \/ __ \/  _/ __ \/ ____/                
11 //  / / / / | / / __/ / /_/ / /_/ // // / / / __/                   
12 // / /_/ /| |/ / /___/ _, _/ _, _// // /_/ / /___                   
13 // \____/ |___/_____/_/ |_/_/ |_/___/_____/_____/                   
14                                                                  
15 // NEON PLEXUS: Override created by pixelpolyn8r & team
16 
17 // Sources flattened with hardhat v2.9.3 https://hardhat.org
18 
19 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
20 
21 // 
22 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 
48 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
49 
50 // 
51 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
194 
195 // 
196 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @title ERC721 token receiver interface
202  * @dev Interface for any contract that wants to support safeTransfers
203  * from ERC721 asset contracts.
204  */
205 interface IERC721Receiver {
206     /**
207      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
208      * by `operator` from `from`, this function is called.
209      *
210      * It must return its Solidity selector to confirm the token transfer.
211      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
212      *
213      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
214      */
215     function onERC721Received(
216         address operator,
217         address from,
218         uint256 tokenId,
219         bytes calldata data
220     ) external returns (bytes4);
221 }
222 
223 
224 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
225 
226 // 
227 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
233  * @dev See https://eips.ethereum.org/EIPS/eip-721
234  */
235 interface IERC721Metadata is IERC721 {
236     /**
237      * @dev Returns the token collection name.
238      */
239     function name() external view returns (string memory);
240 
241     /**
242      * @dev Returns the token collection symbol.
243      */
244     function symbol() external view returns (string memory);
245 
246     /**
247      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
248      */
249     function tokenURI(uint256 tokenId) external view returns (string memory);
250 }
251 
252 
253 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
254 
255 // 
256 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
257 
258 pragma solidity ^0.8.1;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      *
281      * [IMPORTANT]
282      * ====
283      * You shouldn't rely on `isContract` to protect against flash loan attacks!
284      *
285      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
286      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
287      * constructor.
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies on extcodesize/address.code.length, which returns 0
292         // for contracts in construction, since the code is only stored at the end
293         // of the constructor execution.
294 
295         return account.code.length > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         (bool success, ) = recipient.call{value: amount}("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain `call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         require(isContract(target), "Address: call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.call{value: value}(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
402         return functionStaticCall(target, data, "Address: low-level static call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal view returns (bytes memory) {
416         require(isContract(target), "Address: static call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.staticcall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(isContract(target), "Address: delegate call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
451      * revert reason using the provided one.
452      *
453      * _Available since v4.3._
454      */
455     function verifyCallResult(
456         bool success,
457         bytes memory returndata,
458         string memory errorMessage
459     ) internal pure returns (bytes memory) {
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 
479 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
480 
481 // 
482 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes calldata) {
502         return msg.data;
503     }
504 }
505 
506 
507 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
508 
509 // 
510 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev String operations.
516  */
517 library Strings {
518     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
522      */
523     function toString(uint256 value) internal pure returns (string memory) {
524         // Inspired by OraclizeAPI's implementation - MIT licence
525         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
526 
527         if (value == 0) {
528             return "0";
529         }
530         uint256 temp = value;
531         uint256 digits;
532         while (temp != 0) {
533             digits++;
534             temp /= 10;
535         }
536         bytes memory buffer = new bytes(digits);
537         while (value != 0) {
538             digits -= 1;
539             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
540             value /= 10;
541         }
542         return string(buffer);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
547      */
548     function toHexString(uint256 value) internal pure returns (string memory) {
549         if (value == 0) {
550             return "0x00";
551         }
552         uint256 temp = value;
553         uint256 length = 0;
554         while (temp != 0) {
555             length++;
556             temp >>= 8;
557         }
558         return toHexString(value, length);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
563      */
564     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
565         bytes memory buffer = new bytes(2 * length + 2);
566         buffer[0] = "0";
567         buffer[1] = "x";
568         for (uint256 i = 2 * length + 1; i > 1; --i) {
569             buffer[i] = _HEX_SYMBOLS[value & 0xf];
570             value >>= 4;
571         }
572         require(value == 0, "Strings: hex length insufficient");
573         return string(buffer);
574     }
575 }
576 
577 
578 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
579 
580 // 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
589  * for the additional interface id that will be supported. For example:
590  *
591  * ```solidity
592  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
594  * }
595  * ```
596  *
597  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
598  */
599 abstract contract ERC165 is IERC165 {
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604         return interfaceId == type(IERC165).interfaceId;
605     }
606 }
607 
608 
609 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
610 
611 // 
612 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 
618 
619 
620 
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension, but not including the Enumerable extension, which is available separately as
625  * {ERC721Enumerable}.
626  */
627 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
628     using Address for address;
629     using Strings for uint256;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to owner address
638     mapping(uint256 => address) private _owners;
639 
640     // Mapping owner address to token count
641     mapping(address => uint256) private _balances;
642 
643     // Mapping from token ID to approved address
644     mapping(uint256 => address) private _tokenApprovals;
645 
646     // Mapping from owner to operator approvals
647     mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649     /**
650      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
651      */
652     constructor(string memory name_, string memory symbol_) {
653         _name = name_;
654         _symbol = symbol_;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661         return
662             interfaceId == type(IERC721).interfaceId ||
663             interfaceId == type(IERC721Metadata).interfaceId ||
664             super.supportsInterface(interfaceId);
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) public view virtual override returns (uint256) {
671         require(owner != address(0), "ERC721: balance query for the zero address");
672         return _balances[owner];
673     }
674 
675     /**
676      * @dev See {IERC721-ownerOf}.
677      */
678     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679         address owner = _owners[tokenId];
680         require(owner != address(0), "ERC721: owner query for nonexistent token");
681         return owner;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-name}.
686      */
687     function name() public view virtual override returns (string memory) {
688         return _name;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-symbol}.
693      */
694     function symbol() public view virtual override returns (string memory) {
695         return _symbol;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-tokenURI}.
700      */
701     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
702         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
703 
704         string memory baseURI = _baseURI();
705         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
706     }
707 
708     /**
709      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
710      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
711      * by default, can be overriden in child contracts.
712      */
713     function _baseURI() internal view virtual returns (string memory) {
714         return "";
715     }
716 
717     /**
718      * @dev See {IERC721-approve}.
719      */
720     function approve(address to, uint256 tokenId) public virtual override {
721         address owner = ERC721.ownerOf(tokenId);
722         require(to != owner, "ERC721: approval to current owner");
723 
724         require(
725             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
726             "ERC721: approve caller is not owner nor approved for all"
727         );
728 
729         _approve(to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-getApproved}.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
737 
738         return _tokenApprovals[tokenId];
739     }
740 
741     /**
742      * @dev See {IERC721-setApprovalForAll}.
743      */
744     function setApprovalForAll(address operator, bool approved) public virtual override {
745         _setApprovalForAll(_msgSender(), operator, approved);
746     }
747 
748     /**
749      * @dev See {IERC721-isApprovedForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev See {IERC721-transferFrom}.
757      */
758     function transferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         //solhint-disable-next-line max-line-length
764         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
765 
766         _transfer(from, to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) public virtual override {
777         safeTransferFrom(from, to, tokenId, "");
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) public virtual override {
789         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
790         _safeTransfer(from, to, tokenId, _data);
791     }
792 
793     /**
794      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
795      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
796      *
797      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
798      *
799      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
800      * implement alternative mechanisms to perform token transfer, such as signature-based.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _safeTransfer(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _transfer(from, to, tokenId);
818         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
819     }
820 
821     /**
822      * @dev Returns whether `tokenId` exists.
823      *
824      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
825      *
826      * Tokens start existing when they are minted (`_mint`),
827      * and stop existing when they are burned (`_burn`).
828      */
829     function _exists(uint256 tokenId) internal view virtual returns (bool) {
830         return _owners[tokenId] != address(0);
831     }
832 
833     /**
834      * @dev Returns whether `spender` is allowed to manage `tokenId`.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
841         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
842         address owner = ERC721.ownerOf(tokenId);
843         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
844     }
845 
846     /**
847      * @dev Safely mints `tokenId` and transfers it to `to`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _safeMint(address to, uint256 tokenId) internal virtual {
857         _safeMint(to, tokenId, "");
858     }
859 
860     /**
861      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
862      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
863      */
864     function _safeMint(
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) internal virtual {
869         _mint(to, tokenId);
870         require(
871             _checkOnERC721Received(address(0), to, tokenId, _data),
872             "ERC721: transfer to non ERC721Receiver implementer"
873         );
874     }
875 
876     /**
877      * @dev Mints `tokenId` and transfers it to `to`.
878      *
879      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - `to` cannot be the zero address.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _mint(address to, uint256 tokenId) internal virtual {
889         require(to != address(0), "ERC721: mint to the zero address");
890         require(!_exists(tokenId), "ERC721: token already minted");
891 
892         _beforeTokenTransfer(address(0), to, tokenId);
893 
894         _balances[to] += 1;
895         _owners[tokenId] = to;
896 
897         emit Transfer(address(0), to, tokenId);
898 
899         _afterTokenTransfer(address(0), to, tokenId);
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId) internal virtual {
913         address owner = ERC721.ownerOf(tokenId);
914 
915         _beforeTokenTransfer(owner, address(0), tokenId);
916 
917         // Clear approvals
918         _approve(address(0), tokenId);
919 
920         _balances[owner] -= 1;
921         delete _owners[tokenId];
922 
923         emit Transfer(owner, address(0), tokenId);
924 
925         _afterTokenTransfer(owner, address(0), tokenId);
926     }
927 
928     /**
929      * @dev Transfers `tokenId` from `from` to `to`.
930      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must be owned by `from`.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _transfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) internal virtual {
944         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
945         require(to != address(0), "ERC721: transfer to the zero address");
946 
947         _beforeTokenTransfer(from, to, tokenId);
948 
949         // Clear approvals from the previous owner
950         _approve(address(0), tokenId);
951 
952         _balances[from] -= 1;
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(from, to, tokenId);
957 
958         _afterTokenTransfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev Approve `to` to operate on `tokenId`
963      *
964      * Emits a {Approval} event.
965      */
966     function _approve(address to, uint256 tokenId) internal virtual {
967         _tokenApprovals[tokenId] = to;
968         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
969     }
970 
971     /**
972      * @dev Approve `operator` to operate on all of `owner` tokens
973      *
974      * Emits a {ApprovalForAll} event.
975      */
976     function _setApprovalForAll(
977         address owner,
978         address operator,
979         bool approved
980     ) internal virtual {
981         require(owner != operator, "ERC721: approve to caller");
982         _operatorApprovals[owner][operator] = approved;
983         emit ApprovalForAll(owner, operator, approved);
984     }
985 
986     /**
987      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
988      * The call is not executed if the target address is not a contract.
989      *
990      * @param from address representing the previous owner of the given token ID
991      * @param to target address that will receive the tokens
992      * @param tokenId uint256 ID of the token to be transferred
993      * @param _data bytes optional data to send along with the call
994      * @return bool whether the call correctly returned the expected magic value
995      */
996     function _checkOnERC721Received(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) private returns (bool) {
1002         if (to.isContract()) {
1003             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1004                 return retval == IERC721Receiver.onERC721Received.selector;
1005             } catch (bytes memory reason) {
1006                 if (reason.length == 0) {
1007                     revert("ERC721: transfer to non ERC721Receiver implementer");
1008                 } else {
1009                     assembly {
1010                         revert(add(32, reason), mload(reason))
1011                     }
1012                 }
1013             }
1014         } else {
1015             return true;
1016         }
1017     }
1018 
1019     /**
1020      * @dev Hook that is called before any token transfer. This includes minting
1021      * and burning.
1022      *
1023      * Calling conditions:
1024      *
1025      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1026      * transferred to `to`.
1027      * - When `from` is zero, `tokenId` will be minted for `to`.
1028      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1029      * - `from` and `to` are never both zero.
1030      *
1031      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1032      */
1033     function _beforeTokenTransfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) internal virtual {}
1038 
1039     /**
1040      * @dev Hook that is called after any transfer of tokens. This includes
1041      * minting and burning.
1042      *
1043      * Calling conditions:
1044      *
1045      * - when `from` and `to` are both non-zero.
1046      * - `from` and `to` are never both zero.
1047      *
1048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049      */
1050     function _afterTokenTransfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) internal virtual {}
1055 }
1056 
1057 
1058 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1059 
1060 // 
1061 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 /**
1066  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1067  * @dev See https://eips.ethereum.org/EIPS/eip-721
1068  */
1069 interface IERC721Enumerable is IERC721 {
1070     /**
1071      * @dev Returns the total amount of tokens stored by the contract.
1072      */
1073     function totalSupply() external view returns (uint256);
1074 
1075     /**
1076      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1077      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1078      */
1079     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1080 
1081     /**
1082      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1083      * Use along with {totalSupply} to enumerate all tokens.
1084      */
1085     function tokenByIndex(uint256 index) external view returns (uint256);
1086 }
1087 
1088 
1089 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1090 
1091 // 
1092 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 /**
1098  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1099  * enumerability of all the token ids in the contract as well as all token ids owned by each
1100  * account.
1101  */
1102 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1103     // Mapping from owner to list of owned token IDs
1104     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1105 
1106     // Mapping from token ID to index of the owner tokens list
1107     mapping(uint256 => uint256) private _ownedTokensIndex;
1108 
1109     // Array with all token ids, used for enumeration
1110     uint256[] private _allTokens;
1111 
1112     // Mapping from token id to position in the allTokens array
1113     mapping(uint256 => uint256) private _allTokensIndex;
1114 
1115     /**
1116      * @dev See {IERC165-supportsInterface}.
1117      */
1118     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1119         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1126         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1127         return _ownedTokens[owner][index];
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-totalSupply}.
1132      */
1133     function totalSupply() public view virtual override returns (uint256) {
1134         return _allTokens.length;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-tokenByIndex}.
1139      */
1140     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1141         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1142         return _allTokens[index];
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any token transfer. This includes minting
1147      * and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      *
1158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1159      */
1160     function _beforeTokenTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) internal virtual override {
1165         super._beforeTokenTransfer(from, to, tokenId);
1166 
1167         if (from == address(0)) {
1168             _addTokenToAllTokensEnumeration(tokenId);
1169         } else if (from != to) {
1170             _removeTokenFromOwnerEnumeration(from, tokenId);
1171         }
1172         if (to == address(0)) {
1173             _removeTokenFromAllTokensEnumeration(tokenId);
1174         } else if (to != from) {
1175             _addTokenToOwnerEnumeration(to, tokenId);
1176         }
1177     }
1178 
1179     /**
1180      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1181      * @param to address representing the new owner of the given token ID
1182      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1183      */
1184     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1185         uint256 length = ERC721.balanceOf(to);
1186         _ownedTokens[to][length] = tokenId;
1187         _ownedTokensIndex[tokenId] = length;
1188     }
1189 
1190     /**
1191      * @dev Private function to add a token to this extension's token tracking data structures.
1192      * @param tokenId uint256 ID of the token to be added to the tokens list
1193      */
1194     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1195         _allTokensIndex[tokenId] = _allTokens.length;
1196         _allTokens.push(tokenId);
1197     }
1198 
1199     /**
1200      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1201      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1202      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1203      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1204      * @param from address representing the previous owner of the given token ID
1205      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1206      */
1207     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1208         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1209         // then delete the last slot (swap and pop).
1210 
1211         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1212         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1213 
1214         // When the token to delete is the last token, the swap operation is unnecessary
1215         if (tokenIndex != lastTokenIndex) {
1216             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1217 
1218             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1219             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1220         }
1221 
1222         // This also deletes the contents at the last position of the array
1223         delete _ownedTokensIndex[tokenId];
1224         delete _ownedTokens[from][lastTokenIndex];
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's token tracking data structures.
1229      * This has O(1) time complexity, but alters the order of the _allTokens array.
1230      * @param tokenId uint256 ID of the token to be removed from the tokens list
1231      */
1232     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1233         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1234         // then delete the last slot (swap and pop).
1235 
1236         uint256 lastTokenIndex = _allTokens.length - 1;
1237         uint256 tokenIndex = _allTokensIndex[tokenId];
1238 
1239         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1240         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1241         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1242         uint256 lastTokenId = _allTokens[lastTokenIndex];
1243 
1244         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1245         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1246 
1247         // This also deletes the contents at the last position of the array
1248         delete _allTokensIndex[tokenId];
1249         _allTokens.pop();
1250     }
1251 }
1252 
1253 
1254 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1255 
1256 // 
1257 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev Contract module which provides a basic access control mechanism, where
1263  * there is an account (an owner) that can be granted exclusive access to
1264  * specific functions.
1265  *
1266  * By default, the owner account will be the one that deploys the contract. This
1267  * can later be changed with {transferOwnership}.
1268  *
1269  * This module is used through inheritance. It will make available the modifier
1270  * `onlyOwner`, which can be applied to your functions to restrict their use to
1271  * the owner.
1272  */
1273 abstract contract Ownable is Context {
1274     address private _owner;
1275 
1276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1277 
1278     /**
1279      * @dev Initializes the contract setting the deployer as the initial owner.
1280      */
1281     constructor() {
1282         _transferOwnership(_msgSender());
1283     }
1284 
1285     /**
1286      * @dev Returns the address of the current owner.
1287      */
1288     function owner() public view virtual returns (address) {
1289         return _owner;
1290     }
1291 
1292     /**
1293      * @dev Throws if called by any account other than the owner.
1294      */
1295     modifier onlyOwner() {
1296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions anymore. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby removing any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         _transferOwnership(address(0));
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Can only be called by the current owner.
1314      */
1315     function transferOwnership(address newOwner) public virtual onlyOwner {
1316         require(newOwner != address(0), "Ownable: new owner is the zero address");
1317         _transferOwnership(newOwner);
1318     }
1319 
1320     /**
1321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1322      * Internal function without access restriction.
1323      */
1324     function _transferOwnership(address newOwner) internal virtual {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 
1332 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
1333 
1334 // 
1335 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 /**
1340  * @dev Contract module which allows children to implement an emergency stop
1341  * mechanism that can be triggered by an authorized account.
1342  *
1343  * This module is used through inheritance. It will make available the
1344  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1345  * the functions of your contract. Note that they will not be pausable by
1346  * simply including this module, only once the modifiers are put in place.
1347  */
1348 abstract contract Pausable is Context {
1349     /**
1350      * @dev Emitted when the pause is triggered by `account`.
1351      */
1352     event Paused(address account);
1353 
1354     /**
1355      * @dev Emitted when the pause is lifted by `account`.
1356      */
1357     event Unpaused(address account);
1358 
1359     bool private _paused;
1360 
1361     /**
1362      * @dev Initializes the contract in unpaused state.
1363      */
1364     constructor() {
1365         _paused = false;
1366     }
1367 
1368     /**
1369      * @dev Returns true if the contract is paused, and false otherwise.
1370      */
1371     function paused() public view virtual returns (bool) {
1372         return _paused;
1373     }
1374 
1375     /**
1376      * @dev Modifier to make a function callable only when the contract is not paused.
1377      *
1378      * Requirements:
1379      *
1380      * - The contract must not be paused.
1381      */
1382     modifier whenNotPaused() {
1383         require(!paused(), "Pausable: paused");
1384         _;
1385     }
1386 
1387     /**
1388      * @dev Modifier to make a function callable only when the contract is paused.
1389      *
1390      * Requirements:
1391      *
1392      * - The contract must be paused.
1393      */
1394     modifier whenPaused() {
1395         require(paused(), "Pausable: not paused");
1396         _;
1397     }
1398 
1399     /**
1400      * @dev Triggers stopped state.
1401      *
1402      * Requirements:
1403      *
1404      * - The contract must not be paused.
1405      */
1406     function _pause() internal virtual whenNotPaused {
1407         _paused = true;
1408         emit Paused(_msgSender());
1409     }
1410 
1411     /**
1412      * @dev Returns to normal state.
1413      *
1414      * Requirements:
1415      *
1416      * - The contract must be paused.
1417      */
1418     function _unpause() internal virtual whenPaused {
1419         _paused = false;
1420         emit Unpaused(_msgSender());
1421     }
1422 }
1423 
1424 
1425 // File contracts/OverrideNftV2.sol
1426 
1427 // 
1428 pragma solidity ^0.8.9;
1429 
1430 
1431 
1432 
1433 contract OverrideNftV2 is Ownable, Pausable, ERC721Enumerable
1434 {
1435     uint256 public constant MAX_SUPPLY = 9000;
1436     address public saleContract;
1437     string public baseURI = "http://cdn.neonplexus.io/collections/neon-plexus-override/preview/metadata/";
1438 
1439     constructor() Ownable() ERC721("NEON PLEXUS: Override", "NPO") { }
1440 
1441     function mintBatch(address to, uint256[] memory tokenIds) public virtual {
1442         require(msg.sender == saleContract, "Nice try lol");
1443         uint256 length = tokenIds.length;
1444         for (uint256 i; i < length; ++i) {
1445             require(tokenIds[i] != 0 && tokenIds[i] <= MAX_SUPPLY, "ID > MAX_SUPPLY");
1446              _safeMint(to, tokenIds[i]);
1447         }
1448     }
1449 
1450     function prepareSale(address _saleContract) public onlyOwner {
1451         saleContract = _saleContract;
1452     }
1453 
1454     function setBaseURI(string memory newURI) public onlyOwner {
1455         baseURI = newURI;
1456     }
1457 
1458     function _baseURI() internal view virtual override returns (string memory) {
1459         return baseURI;
1460     }
1461 
1462     function _beforeTokenTransfer(
1463         address from,
1464         address to,
1465         uint256 tokenId
1466     ) internal override(ERC721Enumerable) whenNotPaused {
1467         super._beforeTokenTransfer(from, to, tokenId);
1468     }
1469 }