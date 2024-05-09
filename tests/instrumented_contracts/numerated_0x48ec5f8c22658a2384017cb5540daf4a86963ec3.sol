1 pragma solidity ^0.8.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     
73     event Mint(address indexed to, uint256 value);
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 interface IERC721 is IERC165 {
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in ``owner``'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Transfers `tokenId` token from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
202      * The approval is cleared when the token is transferred.
203      *
204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
205      *
206      * Requirements:
207      *
208      * - The caller must own the token or be an approved operator.
209      * - `tokenId` must exist.
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address to, uint256 tokenId) external;
214 
215     /**
216      * @dev Returns the account approved for `tokenId` token.
217      *
218      * Requirements:
219      *
220      * - `tokenId` must exist.
221      */
222     function getApproved(uint256 tokenId) external view returns (address operator);
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
227      *
228      * Requirements:
229      *
230      * - The `operator` cannot be the caller.
231      *
232      * Emits an {ApprovalForAll} event.
233      */
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     /**
237      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
238      *
239      * See {setApprovalForAll}
240      */
241     function isApprovedForAll(address owner, address operator) external view returns (bool);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 }
263 
264 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
265 /**
266  * @title ERC721 token receiver interface
267  * @dev Interface for any contract that wants to support safeTransfers
268  * from ERC721 asset contracts.
269  */
270 interface IERC721Receiver {
271     /**
272      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
273      * by `operator` from `from`, this function is called.
274      *
275      * It must return its Solidity selector to confirm the token transfer.
276      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
277      *
278      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
279      */
280     function onERC721Received(
281         address operator,
282         address from,
283         uint256 tokenId,
284         bytes calldata data
285     ) external returns (bytes4);
286 }
287 
288 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
289 /**
290  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
291  * @dev See https://eips.ethereum.org/EIPS/eip-721
292  */
293 interface IERC721Metadata is IERC721 {
294     /**
295      * @dev Returns the token collection name.
296      */
297     function name() external view returns (string memory);
298 
299     /**
300      * @dev Returns the token collection symbol.
301      */
302     function symbol() external view returns (string memory);
303 
304     /**
305      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
306      */
307     function tokenURI(uint256 tokenId) external view returns (string memory);
308 }
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      *
332      * [IMPORTANT]
333      * ====
334      * You shouldn't rely on `isContract` to protect against flash loan attacks!
335      *
336      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
337      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
338      * constructor.
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize/address.code.length, which returns 0
343         // for contracts in construction, since the code is only stored at the end
344         // of the constructor execution.
345 
346         return account.code.length > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
530 /**
531  * @dev Provides information about the current execution context, including the
532  * sender of the transaction and its data. While these are generally available
533  * via msg.sender and msg.data, they should not be accessed in such a direct
534  * manner, since when dealing with meta-transactions the account sending and
535  * paying for execution may not be the actual sender (as far as an application
536  * is concerned).
537  *
538  * This contract is only required for intermediate, library-like contracts.
539  */
540 abstract contract Context {
541     function _msgSender() internal view virtual returns (address) {
542         return msg.sender;
543     }
544 
545     function _msgData() internal view virtual returns (bytes calldata) {
546         return msg.data;
547     }
548 }
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
551 /**
552  * @dev String operations.
553  */
554 library Strings {
555     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
556 
557     /**
558      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
559      */
560     function toString(uint256 value) internal pure returns (string memory) {
561         // Inspired by OraclizeAPI's implementation - MIT licence
562         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
563 
564         if (value == 0) {
565             return "0";
566         }
567         uint256 temp = value;
568         uint256 digits;
569         while (temp != 0) {
570             digits++;
571             temp /= 10;
572         }
573         bytes memory buffer = new bytes(digits);
574         while (value != 0) {
575             digits -= 1;
576             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
577             value /= 10;
578         }
579         return string(buffer);
580     }
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
584      */
585     function toHexString(uint256 value) internal pure returns (string memory) {
586         if (value == 0) {
587             return "0x00";
588         }
589         uint256 temp = value;
590         uint256 length = 0;
591         while (temp != 0) {
592             length++;
593             temp >>= 8;
594         }
595         return toHexString(value, length);
596     }
597 
598     /**
599      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
600      */
601     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
602         bytes memory buffer = new bytes(2 * length + 2);
603         buffer[0] = "0";
604         buffer[1] = "x";
605         for (uint256 i = 2 * length + 1; i > 1; --i) {
606             buffer[i] = _HEX_SYMBOLS[value & 0xf];
607             value >>= 4;
608         }
609         require(value == 0, "Strings: hex length insufficient");
610         return string(buffer);
611     }
612 }
613 
614 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
615 /**
616  * @dev Implementation of the {IERC165} interface.
617  *
618  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
619  * for the additional interface id that will be supported. For example:
620  *
621  * ```solidity
622  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
623  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
624  * }
625  * ```
626  *
627  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
628  */
629 abstract contract ERC165 is IERC165 {
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634         return interfaceId == type(IERC165).interfaceId;
635     }
636 }
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata extension, but not including the Enumerable extension, which is available separately as
642  * {ERC721Enumerable}.
643  */
644 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
645     using Address for address;
646     using Strings for uint256;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     string baseURI;
655 
656     // Mapping from token ID to owner address
657     mapping(uint256 => address) private _owners;
658 
659     // Mapping owner address to token count
660     mapping(address => uint256) private _balances;
661 
662     // Mapping from token ID to approved address
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     /**
669      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
670      */
671     constructor(string memory name_, string memory symbol_) {
672         _name = name_;
673         _symbol = symbol_;
674     }
675 
676     /**
677      * @dev See {IERC165-supportsInterface}.
678      */
679     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
680         return
681             interfaceId == type(IERC721).interfaceId ||
682             interfaceId == type(IERC721Metadata).interfaceId ||
683             super.supportsInterface(interfaceId);
684     }
685 
686     /**
687      * @dev See {IERC721-balanceOf}.
688      */
689     function balanceOf(address owner) public view virtual override returns (uint256) {
690         require(owner != address(0), "ERC721: balance query for the zero address");
691         return _balances[owner];
692     }
693 
694     /**
695      * @dev See {IERC721-ownerOf}.
696      */
697     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
698         address owner = _owners[tokenId];
699         require(owner != address(0), "ERC721: owner query for nonexistent token");
700         return owner;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
721         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
722 
723         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
724     }
725 
726     /**
727      * @dev See {IERC721-approve}.
728      */
729     function approve(address to, uint256 tokenId) public virtual override {
730         address owner = ERC721.ownerOf(tokenId);
731         require(to != owner, "ERC721: approval to current owner");
732 
733         require(
734             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
735             "ERC721: approve caller is not owner nor approved for all"
736         );
737 
738         _approve(to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-getApproved}.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
746 
747         return _tokenApprovals[tokenId];
748     }
749 
750     /**
751      * @dev See {IERC721-setApprovalForAll}.
752      */
753     function setApprovalForAll(address operator, bool approved) public virtual override {
754         _setApprovalForAll(_msgSender(), operator, approved);
755     }
756 
757     /**
758      * @dev See {IERC721-isApprovedForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev See {IERC721-transferFrom}.
766      */
767     function transferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) public virtual override {
772         //solhint-disable-next-line max-line-length
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774 
775         _transfer(from, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) public virtual override {
786         safeTransferFrom(from, to, tokenId, "");
787     }
788 
789     /**
790      * @dev See {IERC721-safeTransferFrom}.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) public virtual override {
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799         _safeTransfer(from, to, tokenId, _data);
800     }
801 
802     /**
803      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
804      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
805      *
806      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
807      *
808      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
809      * implement alternative mechanisms to perform token transfer, such as signature-based.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeTransfer(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes memory _data
825     ) internal virtual {
826         _transfer(from, to, tokenId);
827         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
828     }
829 
830     /**
831      * @dev Returns whether `tokenId` exists.
832      *
833      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
834      *
835      * Tokens start existing when they are minted (`_mint`),
836      * and stop existing when they are burned (`_burn`).
837      */
838     function _exists(uint256 tokenId) internal view virtual returns (bool) {
839         return _owners[tokenId] != address(0);
840     }
841 
842     /**
843      * @dev Returns whether `spender` is allowed to manage `tokenId`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
850         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
851         address owner = ERC721.ownerOf(tokenId);
852         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
853     }
854 
855     /**
856      * @dev Safely mints `tokenId` and transfers it to `to`.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must not exist.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _safeMint(address to, uint256 tokenId) internal virtual {
866         _safeMint(to, tokenId, "");
867     }
868 
869     /**
870      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
871      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
872      */
873     function _safeMint(
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) internal virtual {
878         _mint(to, tokenId);
879         require(
880             _checkOnERC721Received(address(0), to, tokenId, _data),
881             "ERC721: transfer to non ERC721Receiver implementer"
882         );
883     }
884 
885     /**
886      * @dev Mints `tokenId` and transfers it to `to`.
887      *
888      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
889      *
890      * Requirements:
891      *
892      * - `tokenId` must not exist.
893      * - `to` cannot be the zero address.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _mint(address to, uint256 tokenId) internal virtual {
898         require(to != address(0), "ERC721: mint to the zero address");
899         require(!_exists(tokenId), "ERC721: token already minted");
900 
901         _beforeTokenTransfer(address(0), to, tokenId);
902 
903         _balances[to] += 1;
904         _owners[tokenId] = to;
905 
906         emit Transfer(address(0), to, tokenId);
907 
908         _afterTokenTransfer(address(0), to, tokenId);
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal virtual {
922         address owner = ERC721.ownerOf(tokenId);
923 
924         _beforeTokenTransfer(owner, address(0), tokenId);
925 
926         // Clear approvals
927         _approve(address(0), tokenId);
928 
929         _balances[owner] -= 1;
930         delete _owners[tokenId];
931 
932         emit Transfer(owner, address(0), tokenId);
933 
934         _afterTokenTransfer(owner, address(0), tokenId);
935     }
936 
937     /**
938      * @dev Transfers `tokenId` from `from` to `to`.
939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _transfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {
953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
954         require(to != address(0), "ERC721: transfer to the zero address");
955 
956         _beforeTokenTransfer(from, to, tokenId);
957 
958         // Clear approvals from the previous owner
959         _approve(address(0), tokenId);
960 
961         _balances[from] -= 1;
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(from, to, tokenId);
966 
967         _afterTokenTransfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev Approve `to` to operate on `tokenId`
972      *
973      * Emits a {Approval} event.
974      */
975     function _approve(address to, uint256 tokenId) internal virtual {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
978     }
979 
980     /**
981      * @dev Approve `operator` to operate on all of `owner` tokens
982      *
983      * Emits a {ApprovalForAll} event.
984      */
985     function _setApprovalForAll(
986         address owner,
987         address operator,
988         bool approved
989     ) internal virtual {
990         require(owner != operator, "ERC721: approve to caller");
991         _operatorApprovals[owner][operator] = approved;
992         emit ApprovalForAll(owner, operator, approved);
993     }
994 
995     /**
996      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
997      * The call is not executed if the target address is not a contract.
998      *
999      * @param from address representing the previous owner of the given token ID
1000      * @param to target address that will receive the tokens
1001      * @param tokenId uint256 ID of the token to be transferred
1002      * @param _data bytes optional data to send along with the call
1003      * @return bool whether the call correctly returned the expected magic value
1004      */
1005     function _checkOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         if (to.isContract()) {
1012             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1013                 return retval == IERC721Receiver.onERC721Received.selector;
1014             } catch (bytes memory reason) {
1015                 if (reason.length == 0) {
1016                     revert("ERC721: transfer to non ERC721Receiver implementer");
1017                 } else {
1018                     assembly {
1019                         revert(add(32, reason), mload(reason))
1020                     }
1021                 }
1022             }
1023         } else {
1024             return true;
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any token transfer. This includes minting
1030      * and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1035      * transferred to `to`.
1036      * - When `from` is zero, `tokenId` will be minted for `to`.
1037      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Hook that is called after any transfer of tokens. This includes
1050      * minting and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - when `from` and `to` are both non-zero.
1055      * - `from` and `to` are never both zero.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _afterTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {}
1064 }
1065 
1066 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1067 /**
1068  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1069  * @dev See https://eips.ethereum.org/EIPS/eip-721
1070  */
1071 interface IERC721Enumerable is IERC721 {
1072     /**
1073      * @dev Returns the total amount of tokens stored by the contract.
1074      */
1075     function totalSupply() external view returns (uint256);
1076 
1077     /**
1078      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1079      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1080      */
1081     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1082 
1083     /**
1084      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1085      * Use along with {totalSupply} to enumerate all tokens.
1086      */
1087     function tokenByIndex(uint256 index) external view returns (uint256);
1088 }
1089 
1090 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1091 /**
1092  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1093  * enumerability of all the token ids in the contract as well as all token ids owned by each
1094  * account.
1095  */
1096 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1097     // Mapping from owner to list of owned token IDs
1098     mapping(address => mapping(uint256 => uint256)) _ownedTokens;
1099 
1100     // Mapping from token ID to index of the owner tokens list
1101     mapping(uint256 => uint256) private _ownedTokensIndex;
1102 
1103     // Array with all token ids, used for enumeration
1104     uint256[] _allTokens;
1105 
1106     // Mapping from token id to position in the allTokens array
1107     mapping(uint256 => uint256) private _allTokensIndex;
1108 
1109     /**
1110      * @dev See {IERC165-supportsInterface}.
1111      */
1112     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1113         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1120         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1121         return _ownedTokens[owner][index];
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Enumerable-totalSupply}.
1126      */
1127     function totalSupply() public view virtual override returns (uint256) {
1128         return _allTokens.length;
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Enumerable-tokenByIndex}.
1133      */
1134     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1135         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1136         return _allTokens[index];
1137     }
1138 
1139     /**
1140      * @dev Hook that is called before any token transfer. This includes minting
1141      * and burning.
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1149      * - `from` cannot be the zero address.
1150      * - `to` cannot be the zero address.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _beforeTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual override {
1159         super._beforeTokenTransfer(from, to, tokenId);
1160 
1161         if (from == address(0)) {
1162             _addTokenToAllTokensEnumeration(tokenId);
1163         } else if (from != to) {
1164             _removeTokenFromOwnerEnumeration(from, tokenId);
1165         }
1166         if (to == address(0)) {
1167             _removeTokenFromAllTokensEnumeration(tokenId);
1168         } else if (to != from) {
1169             _addTokenToOwnerEnumeration(to, tokenId);
1170         }
1171     }
1172 
1173     /**
1174      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1175      * @param to address representing the new owner of the given token ID
1176      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1177      */
1178     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1179         uint256 length = ERC721.balanceOf(to);
1180         _ownedTokens[to][length] = tokenId;
1181         _ownedTokensIndex[tokenId] = length;
1182     }
1183 
1184     /**
1185      * @dev Private function to add a token to this extension's token tracking data structures.
1186      * @param tokenId uint256 ID of the token to be added to the tokens list
1187      */
1188     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1189         _allTokensIndex[tokenId] = _allTokens.length;
1190         _allTokens.push(tokenId);
1191     }
1192 
1193     /**
1194      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1195      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1196      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1197      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1198      * @param from address representing the previous owner of the given token ID
1199      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1200      */
1201     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1202         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1203         // then delete the last slot (swap and pop).
1204 
1205         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1206         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1207 
1208         // When the token to delete is the last token, the swap operation is unnecessary
1209         if (tokenIndex != lastTokenIndex) {
1210             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1211 
1212             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1213             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1214         }
1215 
1216         // This also deletes the contents at the last position of the array
1217         delete _ownedTokensIndex[tokenId];
1218         delete _ownedTokens[from][lastTokenIndex];
1219     }
1220 
1221     /**
1222      * @dev Private function to remove a token from this extension's token tracking data structures.
1223      * This has O(1) time complexity, but alters the order of the _allTokens array.
1224      * @param tokenId uint256 ID of the token to be removed from the tokens list
1225      */
1226     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1227         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1228         // then delete the last slot (swap and pop).
1229 
1230         uint256 lastTokenIndex = _allTokens.length - 1;
1231         uint256 tokenIndex = _allTokensIndex[tokenId];
1232 
1233         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1234         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1235         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1236         uint256 lastTokenId = _allTokens[lastTokenIndex];
1237 
1238         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1239         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1240 
1241         // This also deletes the contents at the last position of the array
1242         delete _allTokensIndex[tokenId];
1243         _allTokens.pop();
1244     }
1245 }
1246 
1247 
1248 contract Membership is Context {
1249     address private owner;
1250     event MembershipChanged(address indexed owner, uint256 level);
1251     event OwnerTransferred(address indexed preOwner, address indexed newOwner);
1252 
1253     mapping(address => uint256) internal membership;
1254 
1255     constructor() {
1256         owner = _msgSender();
1257         setMembership(_msgSender(), 1);
1258     }
1259 
1260     function transferOwner(address newOwner) public onlyOwner {
1261         address preOwner = owner;
1262         setMembership(newOwner, 1);
1263         setMembership(preOwner, 0);
1264         owner = newOwner;
1265         emit OwnerTransferred(preOwner, newOwner);
1266     }
1267 
1268     function setMembership(address key, uint256 level) public onlyOwner {
1269         membership[key] = level;
1270         emit MembershipChanged(key, level);
1271     }
1272 
1273     modifier onlyOwner() {
1274         require(isOwner(), "Membership : caller is not the owner");
1275         _;
1276     }
1277 
1278     function isOwner() public view returns (bool) {
1279         return _msgSender() == owner;
1280     }
1281 
1282 
1283     modifier onlyAdmin() {
1284         require(isAdmin(), "Membership : caller is not a admin");
1285         _;
1286     }
1287 
1288     function isAdmin() public view returns (bool) {
1289         return membership[_msgSender()] == 1;
1290     }
1291 
1292     modifier onlyMinter() {
1293         require(isMinter(), "Memberhsip : caller is not a Minter");
1294         _;
1295     }
1296 
1297     function isMinter() public view returns (bool) {
1298         return isOwner() || membership[_msgSender()] == 11;
1299     }
1300     
1301     function getMembership(address account) public view returns (uint256){
1302         return membership[account];
1303     }
1304 }
1305 
1306 
1307 contract LOKPay is Membership {
1308     event Pay(address token, uint256 code, uint256 value);
1309     event Take(uint256 code, uint256 value);
1310 
1311     address payable private receiver;
1312     address private tokenReceiver;
1313 
1314     receive() external payable {}
1315 
1316     fallback() external payable {}
1317 
1318     constructor() {
1319         setReceiver(payable(_msgSender()));
1320         setTokenReceiver(_msgSender());
1321     }
1322 
1323     function take(uint256 code) public payable {
1324         emit Take(code, msg.value);
1325     }
1326 
1327     function pay(uint256 code) public payable {
1328         emit Pay(address(0), code, msg.value);
1329     }
1330 
1331     function setReceiver(address payable r) public onlyOwner {
1332         receiver = r;
1333     }
1334 
1335     function setTokenReceiver(address r) public onlyOwner {
1336         tokenReceiver = r;
1337     }
1338 
1339     function withdraw() public {
1340         require(receiver != address(0));
1341         require(_msgSender() == receiver || isOwner(), "Incorrect address");
1342         receiver.transfer(address(this).balance);
1343     }
1344     
1345     function payBy(address token, uint256 code, uint256 value) public {
1346         emit Pay(token, code, value);
1347         IERC20(token).transferFrom(_msgSender(), tokenReceiver, value);
1348     }
1349 }