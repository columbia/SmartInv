1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
28 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId,
82         bytes calldata data
83     ) external;
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
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
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 }
168 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
186      */
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes calldata data
192     ) external returns (bytes4);
193 }
194 
195 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
201  * @dev See https://eips.ethereum.org/EIPS/eip-721
202  */
203 interface IERC721Metadata is IERC721 {
204     /**
205      * @dev Returns the token collection name.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the token collection symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
216      */
217     function tokenURI(uint256 tokenId) external view returns (string memory);
218 }
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
220 
221 pragma solidity ^0.8.1;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      *
244      * [IMPORTANT]
245      * ====
246      * You shouldn't rely on `isContract` to protect against flash loan attacks!
247      *
248      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
249      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
250      * constructor.
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize/address.code.length, which returns 0
255         // for contracts in construction, since the code is only stored at the end
256         // of the constructor execution.
257 
258         return account.code.length > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         (bool success, bytes memory returndata) = target.call{value: value}(data);
353         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
363         return functionStaticCall(target, data, "Address: low-level static call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal view returns (bytes memory) {
377         (bool success, bytes memory returndata) = target.staticcall(data);
378         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
408      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
409      *
410      * _Available since v4.8._
411      */
412     function verifyCallResultFromTarget(
413         address target,
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         if (success) {
419             if (returndata.length == 0) {
420                 // only check isContract if the call was successful and the return data is empty
421                 // otherwise we already know that it was a contract
422                 require(isContract(target), "Address: call to non-contract");
423             }
424             return returndata;
425         } else {
426             _revert(returndata, errorMessage);
427         }
428     }
429 
430     /**
431      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason or using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             _revert(returndata, errorMessage);
445         }
446     }
447 
448     function _revert(bytes memory returndata, string memory errorMessage) private pure {
449         // Look for revert reason and bubble it up if present
450         if (returndata.length > 0) {
451             // The easiest way to bubble the revert reason is using memory via assembly
452             /// @solidity memory-safe-assembly
453             assembly {
454                 let returndata_size := mload(returndata)
455                 revert(add(32, returndata), returndata_size)
456             }
457         } else {
458             revert(errorMessage);
459         }
460     }
461 }
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Provides information about the current execution context, including the
469  * sender of the transaction and its data. While these are generally available
470  * via msg.sender and msg.data, they should not be accessed in such a direct
471  * manner, since when dealing with meta-transactions the account sending and
472  * paying for execution may not be the actual sender (as far as an application
473  * is concerned).
474  *
475  * This contract is only required for intermediate, library-like contracts.
476  */
477 abstract contract Context {
478     function _msgSender() internal view virtual returns (address) {
479         return msg.sender;
480     }
481 
482     function _msgData() internal view virtual returns (bytes calldata) {
483         return msg.data;
484     }
485 }
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title Counters
493  * @author Matt Condon (@shrugs)
494  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
495  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
496  *
497  * Include with `using Counters for Counters.Counter;`
498  */
499 library Counters {
500     struct Counter {
501         // This variable should never be directly accessed by users of the library: interactions must be restricted to
502         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
503         // this feature: see https://github.com/ethereum/solidity/issues/4637
504         uint256 _value; // default: 0
505     }
506 
507     function current(Counter storage counter) internal view returns (uint256) {
508         return counter._value;
509     }
510 
511     function increment(Counter storage counter) internal {
512         unchecked {
513             counter._value += 1;
514         }
515     }
516 
517     function decrement(Counter storage counter) internal {
518         uint256 value = counter._value;
519         require(value > 0, "Counter: decrement overflow");
520         unchecked {
521             counter._value = value - 1;
522         }
523     }
524 
525     function reset(Counter storage counter) internal {
526         counter._value = 0;
527     }
528 }
529 
530 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev String operations.
536  */
537 library Strings {
538     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
539     uint8 private constant _ADDRESS_LENGTH = 20;
540 
541     /**
542      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
543      */
544     function toString(uint256 value) internal pure returns (string memory) {
545         // Inspired by OraclizeAPI's implementation - MIT licence
546         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
547 
548         if (value == 0) {
549             return "0";
550         }
551         uint256 temp = value;
552         uint256 digits;
553         while (temp != 0) {
554             digits++;
555             temp /= 10;
556         }
557         bytes memory buffer = new bytes(digits);
558         while (value != 0) {
559             digits -= 1;
560             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
561             value /= 10;
562         }
563         return string(buffer);
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
568      */
569     function toHexString(uint256 value) internal pure returns (string memory) {
570         if (value == 0) {
571             return "0x00";
572         }
573         uint256 temp = value;
574         uint256 length = 0;
575         while (temp != 0) {
576             length++;
577             temp >>= 8;
578         }
579         return toHexString(value, length);
580     }
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
584      */
585     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
586         bytes memory buffer = new bytes(2 * length + 2);
587         buffer[0] = "0";
588         buffer[1] = "x";
589         for (uint256 i = 2 * length + 1; i > 1; --i) {
590             buffer[i] = _HEX_SYMBOLS[value & 0xf];
591             value >>= 4;
592         }
593         require(value == 0, "Strings: hex length insufficient");
594         return string(buffer);
595     }
596 
597     /**
598      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
599      */
600     function toHexString(address addr) internal pure returns (string memory) {
601         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
602     }
603 }
604 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev Implementation of the {IERC165} interface.
610  *
611  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
612  * for the additional interface id that will be supported. For example:
613  *
614  * ```solidity
615  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
617  * }
618  * ```
619  *
620  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
621  */
622 abstract contract ERC165 is IERC165 {
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627         return interfaceId == type(IERC165).interfaceId;
628     }
629 }
630 
631 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension, but not including the Enumerable extension, which is available separately as
638  * {ERC721Enumerable}.
639  */
640 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     // Token name
645     string private _name;
646 
647     // Token symbol
648     string private _symbol;
649 
650     // Optional mapping for token URIs
651     mapping(uint256 => string) private _tokenURIs;
652 
653     // Type
654     mapping(uint256 => string) private _tokenType;
655     
656     // Data
657     mapping(uint256 => string) private _tokenData;
658     
659     // Key
660     mapping(uint256 => string) private _tokenKey;
661     
662     // Database key
663     mapping(uint256 => string) private _databaseKey;
664 
665     // Mapping from token ID to owner address
666     mapping(uint256 => address) private _owners;
667 
668     // Mapping owner address to token count
669     mapping(address => uint256) private _balances;
670 
671     // Mapping from token ID to approved address
672     mapping(uint256 => address) private _tokenApprovals;
673 
674     // Mapping from owner to operator approvals
675     mapping(address => mapping(address => bool)) private _operatorApprovals;
676 
677     /**
678      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
679      */
680     constructor(string memory name_, string memory symbol_) {
681         _name = name_;
682         _symbol = symbol_;
683     }
684 
685     /**
686      * @dev See {IERC165-supportsInterface}.
687      */
688     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
689         return
690             interfaceId == type(IERC721).interfaceId ||
691             interfaceId == type(IERC721Metadata).interfaceId ||
692             super.supportsInterface(interfaceId);
693     }
694 
695     /**
696      * @dev See {IERC721-balanceOf}.
697      */
698     function balanceOf(address owner) public view virtual override returns (uint256) {
699         require(owner != address(0), "ERC721: address zero is not a valid owner");
700         return _balances[owner];
701     }
702 
703     /**
704      * @dev See {IERC721-ownerOf}.
705      */
706     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
707         address owner = _owners[tokenId];
708         require(owner != address(0), "ERC721: invalid token ID");
709         return owner;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-name}.
714      */
715     function name() public view virtual override returns (string memory) {
716         return _name;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-symbol}.
721      */
722     function symbol() public view virtual override returns (string memory) {
723         return _symbol;
724     }
725 
726     /**
727      * @dev Returns an URI for a given token ID.
728      * Throws if the token ID does not exist. May return an empty string.
729      * @param tokenId uint256 ID of the token to query
730      */
731     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
732         _requireMinted(tokenId);
733         return _tokenURIs[tokenId];
734 
735     }
736 
737     /**
738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740      * by default, can be overridden in child contracts.
741      */
742     function _baseURI() internal view virtual returns (string memory) {
743         return "";
744     }
745 
746     /**
747      * @dev See {IERC721-approve}.
748      */
749     function approve(address to, uint256 tokenId) public virtual override {
750         address owner = ERC721.ownerOf(tokenId);
751         require(to != owner, "ERC721: approval to current owner");
752 
753         require(
754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755             "ERC721: approve caller is not token owner or approved for all"
756         );
757 
758         _approve(to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-getApproved}.
763      */
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         _requireMinted(tokenId);
766 
767         return _tokenApprovals[tokenId];
768     }
769 
770     /**
771      * @dev See {IERC721-setApprovalForAll}.
772      */
773     function setApprovalForAll(address operator, bool approved) public virtual override {
774         _setApprovalForAll(_msgSender(), operator, approved);
775     }
776 
777     /**
778      * @dev See {IERC721-isApprovedForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev See {IERC721-transferFrom}.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         //solhint-disable-next-line max-line-length
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
794 
795         _transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         safeTransferFrom(from, to, tokenId, "");
807     }
808 
809     /**
810      * @dev See {IERC721-safeTransferFrom}.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory data
817     ) public virtual override {
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
819         _safeTransfer(from, to, tokenId, data);
820     }
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
825      *
826      * `data` is additional data, it has no specified format and it is sent in call to `to`.
827      *
828      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
829      * implement alternative mechanisms to perform token transfer, such as signature-based.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeTransfer(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory data
845     ) internal virtual {
846         _transfer(from, to, tokenId);
847         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
848     }
849 
850     /**
851      * @dev Returns whether `tokenId` exists.
852      *
853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
854      *
855      * Tokens start existing when they are minted (`_mint`),
856      * and stop existing when they are burned (`_burn`).
857      */
858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
859         return _owners[tokenId] != address(0);
860     }
861 
862     /**
863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
870         address owner = ERC721.ownerOf(tokenId);
871         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
872     }
873 
874     /**
875      * @dev Safely mints `tokenId` and transfers it to `to`.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _safeMint(address to, uint256 tokenId) internal virtual {
885         _safeMint(to, tokenId, "");
886     }
887 
888     /**
889      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
890      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
891      */
892     function _safeMint(
893         address to,
894         uint256 tokenId,
895         bytes memory data
896     ) internal virtual {
897         _mint(to, tokenId);
898         require(
899             _checkOnERC721Received(address(0), to, tokenId, data),
900             "ERC721: transfer to non ERC721Receiver implementer"
901         );
902     }
903 
904     /**
905      * @dev Mints `tokenId` and transfers it to `to`.
906      *
907      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
908      *
909      * Requirements:
910      *
911      * - `tokenId` must not exist.
912      * - `to` cannot be the zero address.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _mint(address to, uint256 tokenId) internal virtual {
917         require(to != address(0), "ERC721: mint to the zero address");
918         require(!_exists(tokenId), "ERC721: token already minted");
919 
920         _beforeTokenTransfer(address(0), to, tokenId);
921 
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(address(0), to, tokenId);
926 
927         _afterTokenTransfer(address(0), to, tokenId);
928     }
929 
930     /**
931      * @dev Internal function to set the token URI for a given token.
932      * Reverts if the token ID does not exist.
933      * @param tokenId uint256 ID of the token to set its URI
934      * @param uri string URI to assign
935      */
936     function _setTokenURI(uint256 tokenId, string memory uri) internal {
937         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
938         _tokenURIs[tokenId] = uri;
939     }
940 
941     /**
942      * @dev Returns an TokenType for a given token ID.
943      * Throws if the token ID does not exist. May return an empty string.
944      * @param tokenId uint256 ID of the token to query
945      */
946     function getTokenType(uint256 tokenId) external view returns (string memory) {
947         require(_exists(tokenId), "ERC721Metadata: TokenType query for nonexistent token");
948         return _tokenType[tokenId];
949     }
950 
951     /**
952      * @dev Internal function to set the token Type for a given token.
953      * Reverts if the token ID does not exist.
954      * @param tokenId uint256 ID of the token to set its Type
955      * @param tokenType string Type to assign
956      */
957     function _setTokenType(uint256 tokenId, string memory tokenType) internal {
958         require(_exists(tokenId), "ERC721Metadata: TokenType set of nonexistent token");
959         _tokenType[tokenId] = tokenType;
960     }
961     
962     /**
963      * @dev Returns an TokenData for a given token ID.
964      * Throws if the token ID does not exist. May return an empty string.
965      * @param tokenId uint256 ID of the token to query
966      */
967     function getTokenData(uint256 tokenId) external view returns (string memory) {
968         require(_exists(tokenId), "ERC721Metadata: TokenData query for nonexistent token");
969         return _tokenData[tokenId];
970     }
971 
972     /**
973      * @dev Internal function to set the token Data for a given token.
974      * Reverts if the token ID does not exist.
975      * @param tokenId uint256 ID of the token to set its Data
976      * @param tokenData string Data to assign
977      */
978     function _setTokenData(uint256 tokenId, string memory tokenData) internal {
979         require(_exists(tokenId), "ERC721Metadata: TokenData set of nonexistent token");
980         _tokenData[tokenId] = tokenData;
981     }
982     
983     /**
984      * @dev Returns an TokenKey for a given token ID.
985      * Throws if the token ID does not exist. May return an empty string.
986      * @param tokenId uint256 ID of the token to query
987      */
988     function getTokenKey(uint256 tokenId) external view returns (string memory) {
989         require(_exists(tokenId), "ERC721Metadata: TokenKey query for nonexistent token");
990         return _tokenKey[tokenId];
991     }
992 
993     /**
994      * @dev Internal function to set the token Key for a given token.
995      * Reverts if the token ID does not exist.
996      * @param tokenId uint256 ID of the token to set its Key
997      * @param tokenKey string Key to assign
998      */
999     function _setTokenKey(uint256 tokenId, string memory tokenKey) internal {
1000         require(_exists(tokenId), "ERC721Metadata: TokenKey set of nonexistent token");
1001         _tokenKey[tokenId] = tokenKey;
1002     }
1003     
1004     /**
1005      * @dev Returns an DatabaseKey for a given token ID.
1006      * Throws if the token ID does not exist. May return an empty string.
1007      * @param tokenId uint256 ID of the token to query
1008      */
1009     function getDatabaseKey(uint256 tokenId) external view returns (string memory) {
1010         require(_exists(tokenId), "ERC721Metadata: DatabaseKey query for nonexistent token");
1011         return _databaseKey[tokenId];
1012     }
1013 
1014     /**
1015      * @dev Internal function to set the DatabaseKey for a given token.
1016      * Reverts if the token ID does not exist.
1017      * @param tokenId uint256 ID of the token to set its Key
1018      * @param databaseKey string Key to assign
1019      */
1020     function _setDatabaseKey(uint256 tokenId, string memory databaseKey) internal {
1021         require(_exists(tokenId), "ERC721Metadata: DatabaseKey set of nonexistent token");
1022         _databaseKey[tokenId] = databaseKey;
1023     }
1024 
1025 
1026     /**
1027      * @dev Destroys `tokenId`.
1028      * The approval is cleared when the token is burned.
1029      * This is an internal function that does not check if the sender is authorized to operate on the token.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _burn(uint256 tokenId) internal virtual {
1038         address owner = ERC721.ownerOf(tokenId);
1039 
1040         _beforeTokenTransfer(owner, address(0), tokenId);
1041 
1042         // Clear approvals
1043         delete _tokenApprovals[tokenId];
1044 
1045         _balances[owner] -= 1;
1046         delete _owners[tokenId];
1047 
1048         emit Transfer(owner, address(0), tokenId);
1049 
1050         _afterTokenTransfer(owner, address(0), tokenId);
1051     }
1052 
1053     /**
1054      * @dev Transfers `tokenId` from `from` to `to`.
1055      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1056      *
1057      * Requirements:
1058      *
1059      * - `to` cannot be the zero address.
1060      * - `tokenId` token must be owned by `from`.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual {
1069         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1070         require(to != address(0), "ERC721: transfer to the zero address");
1071 
1072         _beforeTokenTransfer(from, to, tokenId);
1073 
1074         // Clear approvals from the previous owner
1075         delete _tokenApprovals[tokenId];
1076 
1077         _balances[from] -= 1;
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(from, to, tokenId);
1082 
1083         _afterTokenTransfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev Approve `to` to operate on `tokenId`
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function _approve(address to, uint256 tokenId) internal virtual {
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Approve `operator` to operate on all of `owner` tokens
1098      *
1099      * Emits an {ApprovalForAll} event.
1100      */
1101     function _setApprovalForAll(
1102         address owner,
1103         address operator,
1104         bool approved
1105     ) internal virtual {
1106         require(owner != operator, "ERC721: approve to caller");
1107         _operatorApprovals[owner][operator] = approved;
1108         emit ApprovalForAll(owner, operator, approved);
1109     }
1110 
1111     /**
1112      * @dev Reverts if the `tokenId` has not been minted yet.
1113      */
1114     function _requireMinted(uint256 tokenId) internal view virtual {
1115         require(_exists(tokenId), "ERC721: invalid token ID");
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver.onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert("ERC721: transfer to non ERC721Receiver implementer");
1140                 } else {
1141                     /// @solidity memory-safe-assembly
1142                     assembly {
1143                         revert(add(32, reason), mload(reason))
1144                     }
1145                 }
1146             }
1147         } else {
1148             return true;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Hook that is called after any transfer of tokens. This includes
1174      * minting and burning.
1175      *
1176      * Calling conditions:
1177      *
1178      * - when `from` and `to` are both non-zero.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _afterTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 }
1189 
1190 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1197  * @dev See https://eips.ethereum.org/EIPS/eip-721
1198  */
1199 interface IERC721Enumerable is IERC721 {
1200     /**
1201      * @dev Returns the total amount of tokens stored by the contract.
1202      */
1203     function totalSupply() external view returns (uint256);
1204 
1205     /**
1206      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1207      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1208      */
1209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1210 
1211     /**
1212      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1213      * Use along with {totalSupply} to enumerate all tokens.
1214      */
1215     function tokenByIndex(uint256 index) external view returns (uint256);
1216 }
1217 
1218 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 /**
1223  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1224  * enumerability of all the token ids in the contract as well as all token ids owned by each
1225  * account.
1226  */
1227 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1228     // Mapping from owner to list of owned token IDs
1229     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1230 
1231     // Mapping from token ID to index of the owner tokens list
1232     mapping(uint256 => uint256) private _ownedTokensIndex;
1233 
1234     // Array with all token ids, used for enumeration
1235     uint256[] private _allTokens;
1236 
1237     // Mapping from token id to position in the allTokens array
1238     mapping(uint256 => uint256) private _allTokensIndex;
1239 
1240     /**
1241      * @dev See {IERC165-supportsInterface}.
1242      */
1243     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1244         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1249      */
1250     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1251         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1252         return _ownedTokens[owner][index];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-totalSupply}.
1257      */
1258     function totalSupply() public view virtual override returns (uint256) {
1259         return _allTokens.length;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Enumerable-tokenByIndex}.
1264      */
1265     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1266         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1267         return _allTokens[index];
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before any token transfer. This includes minting
1272      * and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1280      * - `from` cannot be the zero address.
1281      * - `to` cannot be the zero address.
1282      *
1283      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1284      */
1285     function _beforeTokenTransfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual override {
1290         super._beforeTokenTransfer(from, to, tokenId);
1291 
1292         if (from == address(0)) {
1293             _addTokenToAllTokensEnumeration(tokenId);
1294         } else if (from != to) {
1295             _removeTokenFromOwnerEnumeration(from, tokenId);
1296         }
1297         if (to == address(0)) {
1298             _removeTokenFromAllTokensEnumeration(tokenId);
1299         } else if (to != from) {
1300             _addTokenToOwnerEnumeration(to, tokenId);
1301         }
1302     }
1303 
1304     /**
1305      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1306      * @param to address representing the new owner of the given token ID
1307      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1308      */
1309     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1310         uint256 length = ERC721.balanceOf(to);
1311         _ownedTokens[to][length] = tokenId;
1312         _ownedTokensIndex[tokenId] = length;
1313     }
1314 
1315     /**
1316      * @dev Private function to add a token to this extension's token tracking data structures.
1317      * @param tokenId uint256 ID of the token to be added to the tokens list
1318      */
1319     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1320         _allTokensIndex[tokenId] = _allTokens.length;
1321         _allTokens.push(tokenId);
1322     }
1323 
1324     /**
1325      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1326      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1327      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1328      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1329      * @param from address representing the previous owner of the given token ID
1330      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1331      */
1332     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1333         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1334         // then delete the last slot (swap and pop).
1335 
1336         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1337         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1338 
1339         // When the token to delete is the last token, the swap operation is unnecessary
1340         if (tokenIndex != lastTokenIndex) {
1341             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1342 
1343             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1344             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1345         }
1346 
1347         // This also deletes the contents at the last position of the array
1348         delete _ownedTokensIndex[tokenId];
1349         delete _ownedTokens[from][lastTokenIndex];
1350     }
1351 
1352     /**
1353      * @dev Private function to remove a token from this extension's token tracking data structures.
1354      * This has O(1) time complexity, but alters the order of the _allTokens array.
1355      * @param tokenId uint256 ID of the token to be removed from the tokens list
1356      */
1357     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1358         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1359         // then delete the last slot (swap and pop).
1360 
1361         uint256 lastTokenIndex = _allTokens.length - 1;
1362         uint256 tokenIndex = _allTokensIndex[tokenId];
1363 
1364         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1365         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1366         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1367         uint256 lastTokenId = _allTokens[lastTokenIndex];
1368 
1369         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1370         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1371 
1372         // This also deletes the contents at the last position of the array
1373         delete _allTokensIndex[tokenId];
1374         _allTokens.pop();
1375     }
1376 }
1377 
1378 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 /**
1383  * @title ERC721 Burnable Token
1384  * @dev ERC721 Token that can be burned (destroyed).
1385  */
1386 abstract contract ERC721Burnable is Context, ERC721 {
1387     /**
1388      * @dev Burns `tokenId`. See {ERC721-_burn}.
1389      *
1390      * Requirements:
1391      *
1392      * - The caller must own `tokenId` or be an approved operator.
1393      */
1394     function burn(uint256 tokenId) public virtual {
1395         //solhint-disable-next-line max-line-length
1396         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1397         _burn(tokenId);
1398     }
1399 }
1400 
1401 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol)
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @dev {ERC721} token, including:
1407  *
1408  *  - ability for holders to burn (destroy) their tokens
1409  *  - a minter role that allows for token minting (creation)
1410  *  - a pauser role that allows to stop all token transfers
1411  *  - token ID and URI autogeneration
1412  *
1413  * This contract uses {AccessControl} to lock permissioned functions using the
1414  * different roles - head to its documentation for details.
1415  *
1416  * The account that deploys the contract will be granted the minter and pauser
1417  * roles, as well as the default admin role, which will let it grant both minter
1418  * and pauser roles to other accounts.
1419  *
1420  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
1421  */
1422 contract ERC721Preset is
1423     Context,
1424     ERC721Enumerable,
1425     ERC721Burnable
1426 {
1427 
1428     /**
1429      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1430      * account that deploys the contract.
1431      *
1432      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
1433      * See {ERC721-tokenURI}.
1434      */
1435     constructor(
1436         string memory name,
1437         string memory symbol
1438     ) ERC721(name, symbol) { }
1439 
1440     /**
1441      * @dev Function to mint tokens.
1442      * @param to The address that will receive the minted tokens.
1443      * @param tokenId The token id to mint.
1444      * @param tokenURI The token URI of the minted token.
1445      * @param tokenType The token URI of the minted token.
1446      * @param tokenData The token URI of the minted token.
1447      * @param tokenKey The token URI of the minted token.
1448      * @param databaseKey The token databaseKey of the minted token.
1449      * @return A boolean that indicates if the operation was successful.
1450      */
1451     function mintWithTokenObjectData(
1452         address to,
1453         uint256 tokenId,
1454         string memory tokenURI,
1455         string memory tokenType,
1456         string memory tokenData,
1457         string memory tokenKey,
1458         string memory databaseKey
1459         ) public returns (bool) {
1460         _mint(to, tokenId);
1461         _setTokenURI(tokenId, tokenURI);
1462         _setTokenType(tokenId, tokenType);
1463         _setTokenData(tokenId, tokenData);
1464         _setTokenKey(tokenId, tokenKey);
1465         _setDatabaseKey(tokenId, databaseKey);
1466         return true;
1467     }
1468 
1469     function _beforeTokenTransfer(
1470         address from,
1471         address to,
1472         uint256 tokenId
1473     ) internal virtual override(ERC721, ERC721Enumerable) {
1474         super._beforeTokenTransfer(from, to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev See {IERC165-supportsInterface}.
1479      */
1480     function supportsInterface(bytes4 interfaceId)
1481         public
1482         view
1483         virtual
1484         override(ERC721, ERC721Enumerable)
1485         returns (bool)
1486     {
1487         return super.supportsInterface(interfaceId);
1488     }
1489 }