1 // SPDX-License-Identifier: MIT
2 /*
3 
4   _                             ______                _   _                         _____                 _          
5  | |                           |___  /               | \ | |                       / ____|               (_)         
6  | |     __ _ _   _  ___ _ __     / / ___ _ __ ___   |  \| | __ _ _ __ ___   ___  | (___   ___ _ ____   ___  ___ ___ 
7  | |    / _` | | | |/ _ \ '__|   / / / _ \ '__/ _ \  | . ` |/ _` | '_ ` _ \ / _ \  \___ \ / _ \ '__\ \ / / |/ __/ _ \
8  | |___| (_| | |_| |  __/ |     / /_|  __/ | | (_) | | |\  | (_| | | | | | |  __/  ____) |  __/ |   \ V /| | (_|  __/
9  |______\__,_|\__, |\___|_|    /_____\___|_|  \___/  |_| \_|\__,_|_| |_| |_|\___| |_____/ \___|_|    \_/ |_|\___\___|
10                __/ |                                                                                                 
11               |___/                                                                                                  
12 
13 
14 lz.domains
15 https://twitter.com/LzDomains
16 
17 Core hash: 0x2eb3a4fd7939b5f4bdc4a7412252ddea785e21e20ad23739cbe3cfa994be9d14
18 Primary Core hash: 0x00000006a0091b698c4f64ef90225f4d847ca44fef0280755c87ef0211e36163
19  */
20 
21 // File: @openzeppelin/contracts/utils/Strings.sol
22 
23 
24 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33     uint8 private constant _ADDRESS_LENGTH = 20;
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
93      */
94     function toHexString(address addr) internal pure returns (string memory) {
95         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Context.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Address.sol
127 
128 
129 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
130 
131 pragma solidity ^0.8.1;
132 
133 /**
134  * @dev Collection of functions related to the address type
135  */
136 library Address {
137     /**
138      * @dev Returns true if `account` is a contract.
139      *
140      * [IMPORTANT]
141      * ====
142      * It is unsafe to assume that an address for which this function returns
143      * false is an externally-owned account (EOA) and not a contract.
144      *
145      * Among others, `isContract` will return false for the following
146      * types of addresses:
147      *
148      *  - an externally-owned account
149      *  - a contract in construction
150      *  - an address where a contract will be created
151      *  - an address where a contract lived, but was destroyed
152      * ====
153      *
154      * [IMPORTANT]
155      * ====
156      * You shouldn't rely on `isContract` to protect against flash loan attacks!
157      *
158      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
159      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
160      * constructor.
161      * ====
162      */
163     function isContract(address account) internal view returns (bool) {
164         // This method relies on extcodesize/address.code.length, which returns 0
165         // for contracts in construction, since the code is only stored at the end
166         // of the constructor execution.
167 
168         return account.code.length > 0;
169     }
170 
171     /**
172      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
173      * `recipient`, forwarding all available gas and reverting on errors.
174      *
175      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
176      * of certain opcodes, possibly making contracts go over the 2300 gas limit
177      * imposed by `transfer`, making them unable to receive funds via
178      * `transfer`. {sendValue} removes this limitation.
179      *
180      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
181      *
182      * IMPORTANT: because control is transferred to `recipient`, care must be
183      * taken to not create reentrancy vulnerabilities. Consider using
184      * {ReentrancyGuard} or the
185      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
186      */
187     function sendValue(address payable recipient, uint256 amount) internal {
188         require(address(this).balance >= amount, "Address: insufficient balance");
189 
190         (bool success, ) = recipient.call{value: amount}("");
191         require(success, "Address: unable to send value, recipient may have reverted");
192     }
193 
194     /**
195      * @dev Performs a Solidity function call using a low level `call`. A
196      * plain `call` is an unsafe replacement for a function call: use this
197      * function instead.
198      *
199      * If `target` reverts with a revert reason, it is bubbled up by this
200      * function (like regular Solidity function calls).
201      *
202      * Returns the raw returned data. To convert to the expected return value,
203      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
204      *
205      * Requirements:
206      *
207      * - `target` must be a contract.
208      * - calling `target` with `data` must not revert.
209      *
210      * _Available since v3.1._
211      */
212     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionCall(target, data, "Address: low-level call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
218      * `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, 0, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but also transferring `value` wei to `target`.
233      *
234      * Requirements:
235      *
236      * - the calling contract must have an ETH balance of at least `value`.
237      * - the called Solidity function must be `payable`.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(
242         address target,
243         bytes memory data,
244         uint256 value
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
251      * with `errorMessage` as a fallback revert reason when `target` reverts.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(address(this).balance >= value, "Address: insufficient balance for call");
262         require(isContract(target), "Address: call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.call{value: value}(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a static call.
271      *
272      * _Available since v3.3._
273      */
274     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
275         return functionStaticCall(target, data, "Address: low-level static call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a static call.
281      *
282      * _Available since v3.3._
283      */
284     function functionStaticCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal view returns (bytes memory) {
289         require(isContract(target), "Address: static call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.staticcall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a delegate call.
298      *
299      * _Available since v3.4._
300      */
301     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(isContract(target), "Address: delegate call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.delegatecall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
324      * revert reason using the provided one.
325      *
326      * _Available since v4.3._
327      */
328     function verifyCallResult(
329         bool success,
330         bytes memory returndata,
331         string memory errorMessage
332     ) internal pure returns (bytes memory) {
333         if (success) {
334             return returndata;
335         } else {
336             // Look for revert reason and bubble it up if present
337             if (returndata.length > 0) {
338                 // The easiest way to bubble the revert reason is using memory via assembly
339                 /// @solidity memory-safe-assembly
340                 assembly {
341                     let returndata_size := mload(returndata)
342                     revert(add(32, returndata), returndata_size)
343                 }
344             } else {
345                 revert(errorMessage);
346             }
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Interface of the ERC165 standard, as defined in the
390  * https://eips.ethereum.org/EIPS/eip-165[EIP].
391  *
392  * Implementers can declare support of contract interfaces, which can then be
393  * queried by others ({ERC165Checker}).
394  *
395  * For an implementation, see {ERC165}.
396  */
397 interface IERC165 {
398     /**
399      * @dev Returns true if this contract implements the interface defined by
400      * `interfaceId`. See the corresponding
401      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
402      * to learn more about how these ids are created.
403      *
404      * This function call must use less than 30 000 gas.
405      */
406     function supportsInterface(bytes4 interfaceId) external view returns (bool);
407 }
408 
409 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
410 
411 
412 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Implementation of the {IERC165} interface.
419  *
420  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
421  * for the additional interface id that will be supported. For example:
422  *
423  * ```solidity
424  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
425  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
426  * }
427  * ```
428  *
429  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
430  */
431 abstract contract ERC165 is IERC165 {
432     /**
433      * @dev See {IERC165-supportsInterface}.
434      */
435     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436         return interfaceId == type(IERC165).interfaceId;
437     }
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
441 
442 
443 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Required interface of an ERC721 compliant contract.
450  */
451 interface IERC721 is IERC165 {
452     /**
453      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
459      */
460     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in ``owner``'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes calldata data
499     ) external;
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
503      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Transfers `tokenId` token from `from` to `to`.
523      *
524      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must be owned by `from`.
531      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
532      *
533      * Emits a {Transfer} event.
534      */
535     function transferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) external;
540 
541     /**
542      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
543      * The approval is cleared when the token is transferred.
544      *
545      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
546      *
547      * Requirements:
548      *
549      * - The caller must own the token or be an approved operator.
550      * - `tokenId` must exist.
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address to, uint256 tokenId) external;
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns the account approved for `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function getApproved(uint256 tokenId) external view returns (address operator);
576 
577     /**
578      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
579      *
580      * See {setApprovalForAll}
581      */
582     function isApprovedForAll(address owner, address operator) external view returns (bool);
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
595  * @dev See https://eips.ethereum.org/EIPS/eip-721
596  */
597 interface IERC721Metadata is IERC721 {
598     /**
599      * @dev Returns the token collection name.
600      */
601     function name() external view returns (string memory);
602 
603     /**
604      * @dev Returns the token collection symbol.
605      */
606     function symbol() external view returns (string memory);
607 
608     /**
609      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
610      */
611     function tokenURI(uint256 tokenId) external view returns (string memory);
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
615 
616 
617 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 
623 
624 
625 
626 
627 
628 /**
629  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
630  * the Metadata extension, but not including the Enumerable extension, which is available separately as
631  * {ERC721Enumerable}.
632  */
633 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
634     using Address for address;
635     using Strings for uint256;
636 
637     // Token name
638     string private _name;
639 
640     // Token symbol
641     string private _symbol;
642 
643     // Mapping from token ID to owner address
644     mapping(uint256 => address) private _owners;
645 
646     // Mapping owner address to token count
647     mapping(address => uint256) private _balances;
648 
649     // Mapping from token ID to approved address
650     mapping(uint256 => address) private _tokenApprovals;
651 
652     // Mapping from owner to operator approvals
653     mapping(address => mapping(address => bool)) private _operatorApprovals;
654 
655     /**
656      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
657      */
658     constructor(string memory name_, string memory symbol_) {
659         _name = name_;
660         _symbol = symbol_;
661     }
662 
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
667         return
668             interfaceId == type(IERC721).interfaceId ||
669             interfaceId == type(IERC721Metadata).interfaceId ||
670             super.supportsInterface(interfaceId);
671     }
672 
673     /**
674      * @dev See {IERC721-balanceOf}.
675      */
676     function balanceOf(address owner) public view virtual override returns (uint256) {
677         require(owner != address(0), "ERC721: address zero is not a valid owner");
678         return _balances[owner];
679     }
680 
681     /**
682      * @dev See {IERC721-ownerOf}.
683      */
684     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
685         address owner = _owners[tokenId];
686         require(owner != address(0), "ERC721: invalid token ID");
687         return owner;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-name}.
692      */
693     function name() public view virtual override returns (string memory) {
694         return _name;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-symbol}.
699      */
700     function symbol() public view virtual override returns (string memory) {
701         return _symbol;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-tokenURI}.
706      */
707     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
708         _requireMinted(tokenId);
709 
710         string memory baseURI = _baseURI();
711         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
712     }
713 
714     /**
715      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
716      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
717      * by default, can be overridden in child contracts.
718      */
719     function _baseURI() internal view virtual returns (string memory) {
720         return "";
721     }
722 
723     /**
724      * @dev See {IERC721-approve}.
725      */
726     function approve(address to, uint256 tokenId) public virtual override {
727         address owner = ERC721.ownerOf(tokenId);
728         require(to != owner, "ERC721: approval to current owner");
729 
730         require(
731             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
732             "ERC721: approve caller is not token owner nor approved for all"
733         );
734 
735         _approve(to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-getApproved}.
740      */
741     function getApproved(uint256 tokenId) public view virtual override returns (address) {
742         _requireMinted(tokenId);
743 
744         return _tokenApprovals[tokenId];
745     }
746 
747     /**
748      * @dev See {IERC721-setApprovalForAll}.
749      */
750     function setApprovalForAll(address operator, bool approved) public virtual override {
751         _setApprovalForAll(_msgSender(), operator, approved);
752     }
753 
754     /**
755      * @dev See {IERC721-isApprovedForAll}.
756      */
757     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
758         return _operatorApprovals[owner][operator];
759     }
760 
761     /**
762      * @dev See {IERC721-transferFrom}.
763      */
764     function transferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) public virtual override {
769         //solhint-disable-next-line max-line-length
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
771 
772         _transfer(from, to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-safeTransferFrom}.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) public virtual override {
783         safeTransferFrom(from, to, tokenId, "");
784     }
785 
786     /**
787      * @dev See {IERC721-safeTransferFrom}.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory data
794     ) public virtual override {
795         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
796         _safeTransfer(from, to, tokenId, data);
797     }
798 
799     /**
800      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
801      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
802      *
803      * `data` is additional data, it has no specified format and it is sent in call to `to`.
804      *
805      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
806      * implement alternative mechanisms to perform token transfer, such as signature-based.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _safeTransfer(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory data
822     ) internal virtual {
823         _transfer(from, to, tokenId);
824         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
825     }
826 
827     /**
828      * @dev Returns whether `tokenId` exists.
829      *
830      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
831      *
832      * Tokens start existing when they are minted (`_mint`),
833      * and stop existing when they are burned (`_burn`).
834      */
835     function _exists(uint256 tokenId) internal view virtual returns (bool) {
836         return _owners[tokenId] != address(0);
837     }
838 
839     /**
840      * @dev Returns whether `spender` is allowed to manage `tokenId`.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must exist.
845      */
846     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
847         address owner = ERC721.ownerOf(tokenId);
848         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
849     }
850 
851     /**
852      * @dev Safely mints `tokenId` and transfers it to `to`.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeMint(address to, uint256 tokenId) internal virtual {
862         _safeMint(to, tokenId, "");
863     }
864 
865     /**
866      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
867      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
868      */
869     function _safeMint(
870         address to,
871         uint256 tokenId,
872         bytes memory data
873     ) internal virtual {
874         _mint(to, tokenId);
875         require(
876             _checkOnERC721Received(address(0), to, tokenId, data),
877             "ERC721: transfer to non ERC721Receiver implementer"
878         );
879     }
880 
881     /**
882      * @dev Mints `tokenId` and transfers it to `to`.
883      *
884      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
885      *
886      * Requirements:
887      *
888      * - `tokenId` must not exist.
889      * - `to` cannot be the zero address.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _mint(address to, uint256 tokenId) internal virtual {
894         require(to != address(0), "ERC721: mint to the zero address");
895         require(!_exists(tokenId), "ERC721: token already minted");
896 
897         _beforeTokenTransfer(address(0), to, tokenId);
898 
899         _balances[to] += 1;
900         _owners[tokenId] = to;
901 
902         emit Transfer(address(0), to, tokenId);
903 
904         _afterTokenTransfer(address(0), to, tokenId);
905     }
906 
907     /**
908      * @dev Destroys `tokenId`.
909      * The approval is cleared when the token is burned.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _burn(uint256 tokenId) internal virtual {
918         address owner = ERC721.ownerOf(tokenId);
919 
920         _beforeTokenTransfer(owner, address(0), tokenId);
921 
922         // Clear approvals
923         _approve(address(0), tokenId);
924 
925         _balances[owner] -= 1;
926         delete _owners[tokenId];
927 
928         emit Transfer(owner, address(0), tokenId);
929 
930         _afterTokenTransfer(owner, address(0), tokenId);
931     }
932 
933     /**
934      * @dev Transfers `tokenId` from `from` to `to`.
935      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
936      *
937      * Requirements:
938      *
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must be owned by `from`.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _transfer(
945         address from,
946         address to,
947         uint256 tokenId
948     ) internal virtual {
949         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
950         require(to != address(0), "ERC721: transfer to the zero address");
951 
952         _beforeTokenTransfer(from, to, tokenId);
953 
954         // Clear approvals from the previous owner
955         _approve(address(0), tokenId);
956 
957         _balances[from] -= 1;
958         _balances[to] += 1;
959         _owners[tokenId] = to;
960 
961         emit Transfer(from, to, tokenId);
962 
963         _afterTokenTransfer(from, to, tokenId);
964     }
965 
966     /**
967      * @dev Approve `to` to operate on `tokenId`
968      *
969      * Emits an {Approval} event.
970      */
971     function _approve(address to, uint256 tokenId) internal virtual {
972         _tokenApprovals[tokenId] = to;
973         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
974     }
975 
976     /**
977      * @dev Approve `operator` to operate on all of `owner` tokens
978      *
979      * Emits an {ApprovalForAll} event.
980      */
981     function _setApprovalForAll(
982         address owner,
983         address operator,
984         bool approved
985     ) internal virtual {
986         require(owner != operator, "ERC721: approve to caller");
987         _operatorApprovals[owner][operator] = approved;
988         emit ApprovalForAll(owner, operator, approved);
989     }
990 
991     /**
992      * @dev Reverts if the `tokenId` has not been minted yet.
993      */
994     function _requireMinted(uint256 tokenId) internal view virtual {
995         require(_exists(tokenId), "ERC721: invalid token ID");
996     }
997 
998     /**
999      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1000      * The call is not executed if the target address is not a contract.
1001      *
1002      * @param from address representing the previous owner of the given token ID
1003      * @param to target address that will receive the tokens
1004      * @param tokenId uint256 ID of the token to be transferred
1005      * @param data bytes optional data to send along with the call
1006      * @return bool whether the call correctly returned the expected magic value
1007      */
1008     function _checkOnERC721Received(
1009         address from,
1010         address to,
1011         uint256 tokenId,
1012         bytes memory data
1013     ) private returns (bool) {
1014         if (to.isContract()) {
1015             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1016                 return retval == IERC721Receiver.onERC721Received.selector;
1017             } catch (bytes memory reason) {
1018                 if (reason.length == 0) {
1019                     revert("ERC721: transfer to non ERC721Receiver implementer");
1020                 } else {
1021                     /// @solidity memory-safe-assembly
1022                     assembly {
1023                         revert(add(32, reason), mload(reason))
1024                     }
1025                 }
1026             }
1027         } else {
1028             return true;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Hook that is called before any token transfer. This includes minting
1034      * and burning.
1035      *
1036      * Calling conditions:
1037      *
1038      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1039      * transferred to `to`.
1040      * - When `from` is zero, `tokenId` will be minted for `to`.
1041      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 
1052     /**
1053      * @dev Hook that is called after any transfer of tokens. This includes
1054      * minting and burning.
1055      *
1056      * Calling conditions:
1057      *
1058      * - when `from` and `to` are both non-zero.
1059      * - `from` and `to` are never both zero.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _afterTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {}
1068 }
1069 
1070 // File: primary.sol
1071 pragma solidity ^0.8.20;
1072 
1073 
1074 interface IlzCore {
1075     struct domainInfos{
1076         string name;
1077     }
1078     function domainInfo(uint256 tokenId) external view returns (domainInfos memory);
1079 
1080     struct domainLogs{
1081         uint256 time;
1082         uint256 nftID;
1083     }
1084     function domainsData(string calldata domainName) external view returns (domainLogs memory);
1085 }
1086 
1087 
1088 
1089 contract LayerZeroNameServicePrimaryContract {
1090     using Strings for uint256;
1091     ERC721 public lzDomains;
1092     IlzCore public lzCore;
1093 
1094     string public chainName = "Ethereum";
1095 
1096     mapping(address => uint256) public userData;
1097     mapping(uint256 => address) public tokenData;
1098 
1099     constructor() {
1100         lzDomains = ERC721(0x45704edaBe7D2e038C35876dd3B6789511e452cF);
1101         lzCore = IlzCore(0x45704edaBe7D2e038C35876dd3B6789511e452cF);
1102     }
1103 
1104     function setName(uint256 tokenID) public{
1105         if(userData[msg.sender] != 0){
1106             unsetName();
1107         }        
1108         require(lzDomains.ownerOf(tokenID) == msg.sender, "LayerZeroNameServicePrimaryContract: User is not the owner");
1109         lzDomains.transferFrom(msg.sender, address(this), tokenID);
1110         userData[msg.sender] = tokenID;
1111         tokenData[tokenID] = msg.sender;
1112     }
1113     function unsetName() public{
1114         uint256 tokenID = userData[msg.sender];
1115         require(tokenID != 0, "LayerZeroNameServicePrimaryContract: Error #23.");
1116         require(lzDomains.ownerOf(tokenID) == address(this), "LayerZeroNameServicePrimaryContract: This contract is not the owner");
1117         lzDomains.transferFrom(address(this), msg.sender, tokenID);
1118         userData[msg.sender] = 0;
1119         tokenData[tokenID] = address(0);
1120     }
1121     function resolverNameToAddress(string memory name) public view returns(address){
1122         IlzCore.domainLogs memory logs = lzCore.domainsData(name);
1123         uint256 tokenId = logs.nftID;
1124         address user = tokenData[tokenId];
1125         if(userData[user] == 0) {
1126             return address(0);
1127         }
1128         return user;
1129     }
1130 }