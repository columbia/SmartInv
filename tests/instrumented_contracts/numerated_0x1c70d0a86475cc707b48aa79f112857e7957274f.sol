1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 
6 // 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // 
30 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 // 
169 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
170 /**
171  * @title ERC721 token receiver interface
172  * @dev Interface for any contract that wants to support safeTransfers
173  * from ERC721 asset contracts.
174  */
175 interface IERC721Receiver {
176     /**
177      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
178      * by `operator` from `from`, this function is called.
179      *
180      * It must return its Solidity selector to confirm the token transfer.
181      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
182      *
183      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
184      */
185     function onERC721Received(
186         address operator,
187         address from,
188         uint256 tokenId,
189         bytes calldata data
190     ) external returns (bytes4);
191 }
192 
193 // 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) external returns (bool);
257 
258     /**
259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
260      * another (`to`).
261      *
262      * Note that `value` may be zero.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 value);
265 
266     /**
267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
268      * a call to {approve}. `value` is the new allowance.
269      */
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 // 
274 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
275 /**
276  * @dev Standard math utilities missing in the Solidity language.
277  */
278 library Math {
279     /**
280      * @dev Returns the largest of two numbers.
281      */
282     function max(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a >= b ? a : b;
284     }
285 
286     /**
287      * @dev Returns the smallest of two numbers.
288      */
289     function min(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a < b ? a : b;
291     }
292 
293     /**
294      * @dev Returns the average of two numbers. The result is rounded towards
295      * zero.
296      */
297     function average(uint256 a, uint256 b) internal pure returns (uint256) {
298         // (a + b) / 2 can overflow.
299         return (a & b) + (a ^ b) / 2;
300     }
301 
302     /**
303      * @dev Returns the ceiling of the division of two numbers.
304      *
305      * This differs from standard division with `/` in that it rounds up instead
306      * of rounding down.
307      */
308     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
309         // (a + b - 1) / b can overflow on addition, so we distribute.
310         return a / b + (a % b == 0 ? 0 : 1);
311     }
312 }
313 
314 // 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
316 /**
317  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
318  * @dev See https://eips.ethereum.org/EIPS/eip-721
319  */
320 interface IERC721Metadata is IERC721 {
321     /**
322      * @dev Returns the token collection name.
323      */
324     function name() external view returns (string memory);
325 
326     /**
327      * @dev Returns the token collection symbol.
328      */
329     function symbol() external view returns (string memory);
330 
331     /**
332      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
333      */
334     function tokenURI(uint256 tokenId) external view returns (string memory);
335 }
336 
337 // 
338 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize, which returns 0 for contracts in
362         // construction, since the code is only stored at the end of the
363         // constructor execution.
364 
365         uint256 size;
366         assembly {
367             size := extcodesize(account)
368         }
369         return size > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         (bool success, ) = recipient.call{value: amount}("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value
446     ) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.delegatecall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
525      * revert reason using the provided one.
526      *
527      * _Available since v4.3._
528      */
529     function verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) internal pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 // 
553 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
554 /**
555  * @dev Provides information about the current execution context, including the
556  * sender of the transaction and its data. While these are generally available
557  * via msg.sender and msg.data, they should not be accessed in such a direct
558  * manner, since when dealing with meta-transactions the account sending and
559  * paying for execution may not be the actual sender (as far as an application
560  * is concerned).
561  *
562  * This contract is only required for intermediate, library-like contracts.
563  */
564 abstract contract Context {
565     function _msgSender() internal view virtual returns (address) {
566         return msg.sender;
567     }
568 
569     function _msgData() internal view virtual returns (bytes calldata) {
570         return msg.data;
571     }
572 }
573 
574 // 
575 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
576 /**
577  * @dev String operations.
578  */
579 library Strings {
580     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
584      */
585     function toString(uint256 value) internal pure returns (string memory) {
586         // Inspired by OraclizeAPI's implementation - MIT licence
587         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
588 
589         if (value == 0) {
590             return "0";
591         }
592         uint256 temp = value;
593         uint256 digits;
594         while (temp != 0) {
595             digits++;
596             temp /= 10;
597         }
598         bytes memory buffer = new bytes(digits);
599         while (value != 0) {
600             digits -= 1;
601             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
602             value /= 10;
603         }
604         return string(buffer);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
609      */
610     function toHexString(uint256 value) internal pure returns (string memory) {
611         if (value == 0) {
612             return "0x00";
613         }
614         uint256 temp = value;
615         uint256 length = 0;
616         while (temp != 0) {
617             length++;
618             temp >>= 8;
619         }
620         return toHexString(value, length);
621     }
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
625      */
626     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
627         bytes memory buffer = new bytes(2 * length + 2);
628         buffer[0] = "0";
629         buffer[1] = "x";
630         for (uint256 i = 2 * length + 1; i > 1; --i) {
631             buffer[i] = _HEX_SYMBOLS[value & 0xf];
632             value >>= 4;
633         }
634         require(value == 0, "Strings: hex length insufficient");
635         return string(buffer);
636     }
637 }
638 
639 // 
640 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
660         return interfaceId == type(IERC165).interfaceId;
661     }
662 }
663 
664 // 
665 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
666 /**
667  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
668  * the Metadata extension, but not including the Enumerable extension, which is available separately as
669  * {ERC721Enumerable}.
670  */
671 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
672     using Address for address;
673     using Strings for uint256;
674 
675     // Token name
676     string private _name;
677 
678     // Token symbol
679     string private _symbol;
680 
681     // Mapping from token ID to owner address
682     mapping(uint256 => address) private _owners;
683 
684     // Mapping owner address to token count
685     mapping(address => uint256) private _balances;
686 
687     // Mapping from token ID to approved address
688     mapping(uint256 => address) private _tokenApprovals;
689 
690     // Mapping from owner to operator approvals
691     mapping(address => mapping(address => bool)) private _operatorApprovals;
692 
693     /**
694      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
695      */
696     constructor(string memory name_, string memory symbol_) {
697         _name = name_;
698         _symbol = symbol_;
699     }
700 
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
705         return
706         interfaceId == type(IERC721).interfaceId ||
707     interfaceId == type(IERC721Metadata).interfaceId ||
708     super.supportsInterface(interfaceId);
709     }
710 
711     /**
712      * @dev See {IERC721-balanceOf}.
713      */
714     function balanceOf(address owner) public view virtual override returns (uint256) {
715         require(owner != address(0), "ERC721: balance query for the zero address");
716         return _balances[owner];
717     }
718 
719     /**
720      * @dev See {IERC721-ownerOf}.
721      */
722     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
723         address owner = _owners[tokenId];
724         require(owner != address(0), "ERC721: owner query for nonexistent token");
725         return owner;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-name}.
730      */
731     function name() public view virtual override returns (string memory) {
732         return _name;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-symbol}.
737      */
738     function symbol() public view virtual override returns (string memory) {
739         return _symbol;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-tokenURI}.
744      */
745     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
746         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
747 
748         string memory baseURI = _baseURI();
749         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
750     }
751 
752     /**
753      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
754      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
755      * by default, can be overriden in child contracts.
756      */
757     function _baseURI() internal view virtual returns (string memory) {
758         return "";
759     }
760 
761     /**
762      * @dev See {IERC721-approve}.
763      */
764     function approve(address to, uint256 tokenId) public virtual override {
765         address owner = ERC721.ownerOf(tokenId);
766         require(to != owner, "ERC721: approval to current owner");
767 
768         require(
769             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
770             "ERC721: approve caller is not owner nor approved for all"
771         );
772 
773         _approve(to, tokenId);
774     }
775 
776     /**
777      * @dev See {IERC721-getApproved}.
778      */
779     function getApproved(uint256 tokenId) public view virtual override returns (address) {
780         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
781 
782         return _tokenApprovals[tokenId];
783     }
784 
785     /**
786      * @dev See {IERC721-setApprovalForAll}.
787      */
788     function setApprovalForAll(address operator, bool approved) public virtual override {
789         _setApprovalForAll(_msgSender(), operator, approved);
790     }
791 
792     /**
793      * @dev See {IERC721-isApprovedForAll}.
794      */
795     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
796         return _operatorApprovals[owner][operator];
797     }
798 
799     /**
800      * @dev See {IERC721-transferFrom}.
801      */
802     function transferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         //solhint-disable-next-line max-line-length
808         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
809 
810         _transfer(from, to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-safeTransferFrom}.
815      */
816     function safeTransferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public virtual override {
821         safeTransferFrom(from, to, tokenId, "");
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) public virtual override {
833         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
834         _safeTransfer(from, to, tokenId, _data);
835     }
836 
837     /**
838      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
839      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
840      *
841      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
842      *
843      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
844      * implement alternative mechanisms to perform token transfer, such as signature-based.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _safeTransfer(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) internal virtual {
861         _transfer(from, to, tokenId);
862         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
863     }
864 
865     /**
866      * @dev Returns whether `tokenId` exists.
867      *
868      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
869      *
870      * Tokens start existing when they are minted (`_mint`),
871      * and stop existing when they are burned (`_burn`).
872      */
873     function _exists(uint256 tokenId) internal view virtual returns (bool) {
874         return _owners[tokenId] != address(0);
875     }
876 
877     /**
878      * @dev Returns whether `spender` is allowed to manage `tokenId`.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      */
884     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
885         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
886         address owner = ERC721.ownerOf(tokenId);
887         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
888     }
889 
890     /**
891      * @dev Safely mints `tokenId` and transfers it to `to`.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must not exist.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeMint(address to, uint256 tokenId) internal virtual {
901         _safeMint(to, tokenId, "");
902     }
903 
904     /**
905      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
906      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
907      */
908     function _safeMint(
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _mint(to, tokenId);
914         require(
915             _checkOnERC721Received(address(0), to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919 
920     /**
921      * @dev Mints `tokenId` and transfers it to `to`.
922      *
923      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
924      *
925      * Requirements:
926      *
927      * - `tokenId` must not exist.
928      * - `to` cannot be the zero address.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _mint(address to, uint256 tokenId) internal virtual {
933         require(to != address(0), "ERC721: mint to the zero address");
934         require(!_exists(tokenId), "ERC721: token already minted");
935 
936         _beforeTokenTransfer(address(0), to, tokenId);
937 
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(address(0), to, tokenId);
942     }
943 
944     /**
945      * @dev Destroys `tokenId`.
946      * The approval is cleared when the token is burned.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _burn(uint256 tokenId) internal virtual {
955         address owner = ERC721.ownerOf(tokenId);
956 
957         _beforeTokenTransfer(owner, address(0), tokenId);
958 
959         // Clear approvals
960         _approve(address(0), tokenId);
961 
962         _balances[owner] -= 1;
963         delete _owners[tokenId];
964 
965         emit Transfer(owner, address(0), tokenId);
966     }
967 
968     /**
969      * @dev Transfers `tokenId` from `from` to `to`.
970      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {
984         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
985         require(to != address(0), "ERC721: transfer to the zero address");
986 
987         _beforeTokenTransfer(from, to, tokenId);
988 
989         // Clear approvals from the previous owner
990         _approve(address(0), tokenId);
991 
992         _balances[from] -= 1;
993         _balances[to] += 1;
994         _owners[tokenId] = to;
995 
996         emit Transfer(from, to, tokenId);
997     }
998 
999     /**
1000      * @dev Approve `to` to operate on `tokenId`
1001      *
1002      * Emits a {Approval} event.
1003      */
1004     function _approve(address to, uint256 tokenId) internal virtual {
1005         _tokenApprovals[tokenId] = to;
1006         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Approve `operator` to operate on all of `owner` tokens
1011      *
1012      * Emits a {ApprovalForAll} event.
1013      */
1014     function _setApprovalForAll(
1015         address owner,
1016         address operator,
1017         bool approved
1018     ) internal virtual {
1019         require(owner != operator, "ERC721: approve to caller");
1020         _operatorApprovals[owner][operator] = approved;
1021         emit ApprovalForAll(owner, operator, approved);
1022     }
1023 
1024     /**
1025      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1026      * The call is not executed if the target address is not a contract.
1027      *
1028      * @param from address representing the previous owner of the given token ID
1029      * @param to target address that will receive the tokens
1030      * @param tokenId uint256 ID of the token to be transferred
1031      * @param _data bytes optional data to send along with the call
1032      * @return bool whether the call correctly returned the expected magic value
1033      */
1034     function _checkOnERC721Received(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) private returns (bool) {
1040         if (to.isContract()) {
1041             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1042                 return retval == IERC721Receiver.onERC721Received.selector;
1043             } catch (bytes memory reason) {
1044                 if (reason.length == 0) {
1045                     revert("ERC721: transfer to non ERC721Receiver implementer");
1046                 } else {
1047                     assembly {
1048                         revert(add(32, reason), mload(reason))
1049                     }
1050                 }
1051             }
1052         } else {
1053             return true;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any token transfer. This includes minting
1059      * and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1067      * - `from` and `to` are never both zero.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual {}
1076 }
1077 
1078 // 
1079 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1080 /**
1081  * @dev Contract module which provides a basic access control mechanism, where
1082  * there is an account (an owner) that can be granted exclusive access to
1083  * specific functions.
1084  *
1085  * By default, the owner account will be the one that deploys the contract. This
1086  * can later be changed with {transferOwnership}.
1087  *
1088  * This module is used through inheritance. It will make available the modifier
1089  * `onlyOwner`, which can be applied to your functions to restrict their use to
1090  * the owner.
1091  */
1092 abstract contract Ownable is Context {
1093     address private _owner;
1094 
1095     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1096 
1097     /**
1098      * @dev Initializes the contract setting the deployer as the initial owner.
1099      */
1100     constructor() {
1101         _transferOwnership(_msgSender());
1102     }
1103 
1104     /**
1105      * @dev Returns the address of the current owner.
1106      */
1107     function owner() public view virtual returns (address) {
1108         return _owner;
1109     }
1110 
1111     /**
1112      * @dev Throws if called by any account other than the owner.
1113      */
1114     modifier onlyOwner() {
1115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1116         _;
1117     }
1118 
1119     /**
1120      * @dev Leaves the contract without owner. It will not be possible to call
1121      * `onlyOwner` functions anymore. Can only be called by the current owner.
1122      *
1123      * NOTE: Renouncing ownership will leave the contract without an owner,
1124      * thereby removing any functionality that is only available to the owner.
1125      */
1126     function renounceOwnership() public virtual onlyOwner {
1127         _transferOwnership(address(0));
1128     }
1129 
1130     /**
1131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1132      * Can only be called by the current owner.
1133      */
1134     function transferOwnership(address newOwner) public virtual onlyOwner {
1135         require(newOwner != address(0), "Ownable: new owner is the zero address");
1136         _transferOwnership(newOwner);
1137     }
1138 
1139     /**
1140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1141      * Internal function without access restriction.
1142      */
1143     function _transferOwnership(address newOwner) internal virtual {
1144         address oldOwner = _owner;
1145         _owner = newOwner;
1146         emit OwnershipTransferred(oldOwner, newOwner);
1147     }
1148 }
1149 
1150 // 
1151 /**
1152  * @title UntransferableERC721
1153  * @author @lozzereth (www.allthingsweb3.com)
1154  * @notice An NFT implementation that cannot be transfered no matter what
1155  *         unless minting or burning.
1156  */
1157 contract UntransferableERC721 is ERC721, Ownable {
1158     /// @dev Base URI for the underlying token
1159     string private baseURI;
1160 
1161     /// @dev Thrown when an approval is made while untransferable
1162     error Unapprovable();
1163 
1164     /// @dev Thrown when making an transfer while untransferable
1165     error Untransferable();
1166 
1167     constructor(string memory name_, string memory symbol_)
1168     ERC721(name_, symbol_)
1169     {}
1170 
1171     /**
1172      * @dev Prevent token transfer unless burn
1173      */
1174     function _beforeTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal override(ERC721) {
1179         if (to != address(0) && from != address(0)) {
1180             revert Untransferable();
1181         }
1182         super._beforeTokenTransfer(from, to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev Prevent approvals of staked token
1187      */
1188     function approve(address, uint256) public virtual override {
1189         revert Unapprovable();
1190     }
1191 
1192     /**
1193      * @dev Prevent approval of staked token
1194      */
1195     function setApprovalForAll(address, bool) public virtual override {
1196         revert Unapprovable();
1197     }
1198 
1199     /**
1200      * @notice Set the base URI for the NFT
1201      */
1202     function setBaseURI(string memory baseURI_) public virtual onlyOwner {
1203         baseURI = baseURI_;
1204     }
1205 
1206     /**
1207      * @dev Returns the base URI
1208      */
1209     function _baseURI() internal view virtual override returns (string memory) {
1210         return baseURI;
1211     }
1212 }
1213 
1214 // 
1215 /**
1216  * @title StakeSeals
1217  * @custom:website www.sappyseals.com
1218  * @author Original author @lozzereth (www.allthingsweb3.com), forked for Seals.
1219  * Make sure to check him out and give him a follow on twitter xoxo
1220  */
1221 interface IStakeSeals {
1222     function setTokenAddress(address _tokenAddress) external;
1223 
1224     function depositsOf(address account)
1225         external
1226         view
1227         returns (uint256[] memory);
1228 
1229     function findRate(uint256 tokenId) external view returns (uint256 rate);
1230 
1231     function calculateRewards(address account, uint256[] memory tokenIds)
1232         external
1233         view
1234         returns (uint256[] memory rewards);
1235 
1236     function claimRewards(uint256[] calldata tokenIds) external;
1237 
1238     function deposit(uint256[] calldata tokenIds) external;
1239 
1240     function admin_deposit(uint256[] calldata tokenIds) external;
1241 
1242     function withdraw(uint256[] calldata tokenIds) external;
1243 
1244     function tokenRarity(uint256 tokenId)
1245         external
1246         view
1247         returns (uint256 rarity);
1248 }
1249 
1250 contract StakeSealsV2 is UntransferableERC721, IERC721Receiver {
1251 
1252     event ClaimedPixl(
1253         address person,
1254         uint256[] sealIds,
1255         uint256 pixlAmount,
1256         uint256 claimedAt
1257     );
1258 
1259     using Math for uint256;
1260 
1261     /// @notice Contract addresses
1262     IERC721 public erc721Address;
1263     IERC20 public erc20Address;
1264     IStakeSeals public stakeSealsV1;
1265     uint256 public EXPIRATION;
1266     /// @notice Track the deposit and claim state of tokens
1267     struct StakedToken {
1268         uint256 claimedAt;
1269     }
1270     mapping(uint256 => StakedToken) public staked;
1271 
1272     mapping(uint256 => uint256) public rewardRate;
1273 
1274     bool public pauseTokenEmissions = false;
1275 
1276     /// @notice Token non-existent
1277     error TokenNonExistent(uint256 tokenId);
1278 
1279     /// @notice Not an owner of the frog
1280     error TokenNonOwner(uint256 tokenId);
1281 
1282     /// @notice Using a non-zero value
1283     error NonZeroValue();
1284 
1285     /// @notice Pause deposit blocks so this suffering can never happen again
1286     bool public pausedDepositBlocks = false;
1287 
1288     constructor(
1289         IERC721 _erc721Address,
1290         IERC20 _erc20Address,
1291         IStakeSeals _stakeSealsV1Address,
1292         uint256[] memory _defaultRates
1293     ) UntransferableERC721("StakedSealsV2", "sSEAL") {
1294         erc721Address = _erc721Address;
1295         erc20Address = _erc20Address;
1296         stakeSealsV1 = _stakeSealsV1Address;
1297         setBaseURI("ipfs://QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7/");
1298         for (uint256 i = 0; i < 7; i++) {
1299             rewardRate[i] = _defaultRates[i];
1300         }
1301         EXPIRATION = block.number + 1000000000000000000000;
1302     }
1303 
1304     /**
1305      * @notice Track deposits of an account
1306      * @dev Intended for off-chain computation having O(totalSupply) complexity
1307      * @param account - Account to query
1308      * @return tokenIds
1309      */
1310     function depositsOf(address account)
1311         external
1312         view
1313         returns (uint256[] memory)
1314     {
1315         unchecked {
1316             uint256 tokenIdsIdx;
1317             uint256 tokenIdsLength = balanceOf(account);
1318             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1319             for (uint256 i; tokenIdsIdx != tokenIdsLength; ++i) {
1320                 if (!_exists(i)) {
1321                     continue;
1322                 }
1323                 if (ownerOf(i) == account) {
1324                     tokenIds[tokenIdsIdx++] = i;
1325                 }
1326             }
1327             return tokenIds;
1328         }
1329     }
1330 
1331     /**
1332      * @notice Calculates the rewards for specific tokens under an address
1333      * @param account - account to check
1334      * @param tokenIds - token ids to check against
1335      * @return rewards
1336      */
1337     function calculateRewards(address account, uint256[] memory tokenIds)
1338         external
1339         view
1340         returns (uint256[] memory rewards)
1341     {
1342         rewards = new uint256[](tokenIds.length);
1343         for (uint256 i; i < tokenIds.length; i++) {
1344             rewards[i] = _calculateReward(account, tokenIds[i]);
1345         }
1346         return rewards;
1347     }
1348 
1349     /**
1350      * @notice Calculates the rewards for specific token
1351      * @param account - account to check
1352      * @param tokenId - token id to check against
1353      * @return total
1354      */
1355     function calculateReward(address account, uint256 tokenId)
1356         external
1357         view
1358         returns (uint256 total)
1359     {
1360         return _calculateReward(account, tokenId);
1361     }
1362 
1363     function _calculateReward(address account, uint256 tokenId)
1364         private
1365         view
1366         returns (uint256 total)
1367     {
1368         if (!_exists(tokenId)) {
1369             revert TokenNonExistent(tokenId);
1370         }
1371         if (ownerOf(tokenId) != account) {
1372             revert TokenNonOwner(tokenId);
1373         }
1374         unchecked {
1375             uint256 rate = _findRate(tokenId);
1376             uint256 rewards = rate *
1377                 (Math.min(block.number, EXPIRATION) -
1378                     staked[tokenId].claimedAt);
1379             return rewards;
1380         }
1381     }
1382 
1383     /**
1384      * @notice Finds the rates of NFTs from the old StakeSeal contract
1385      * @param tokenId - The id where you want to find the rate
1386      * @return rate - The rate
1387      */
1388     function findRate(uint256 tokenId) external view returns (uint256 rate) {
1389         return _findRate(tokenId);
1390     }
1391 
1392     function _findRate(uint256 tokenId) private view returns (uint256 rate) {
1393         uint256 rarity = stakeSealsV1.tokenRarity(tokenId);
1394         uint256 perDay = rewardRate[rarity];
1395         // 6000 blocks per day
1396         // perDay / 6000 = reward per block
1397         rate = (perDay * 1e18) / 6000;
1398         return rate;
1399     }
1400 
1401     /**
1402      * @notice Represent the staked information of specific token ids as an array of bytes.
1403      *         Intended for off-chain computation.
1404      * @param tokenIds - token ids to check against
1405      * @return stakedInfoBytes
1406      */
1407     function stakedInfoOf(uint256[] memory tokenIds)
1408         external
1409         view
1410         returns (bytes[] memory)
1411     {
1412         bytes[] memory stakedTimes = new bytes[](tokenIds.length);
1413         for (uint256 i; i < tokenIds.length; i++) {
1414             uint256 tokenId = tokenIds[i];
1415             stakedTimes[i] = abi.encodePacked(
1416                 tokenId,
1417                 staked[tokenId].claimedAt
1418             );
1419         }
1420         return stakedTimes;
1421     }
1422 
1423     /**
1424      * @notice Claim the rewards for the tokens
1425      * @param tokenIds - Array of token ids
1426      */
1427     function claimRewards(uint256[] calldata tokenIds) external {
1428         _claimRewards(tokenIds);
1429     }
1430 
1431     function _claimRewards(uint256[] calldata tokenIds) private {
1432         uint256 reward;
1433         for (uint256 i; i < tokenIds.length; i++) {
1434             uint256 tokenId = tokenIds[i];
1435             unchecked {
1436                 reward += _calculateReward(msg.sender, tokenId);
1437             }
1438             if (!pausedDepositBlocks) {
1439                 staked[tokenId].claimedAt = block.number;
1440             }
1441         }
1442         emit ClaimedPixl(msg.sender, tokenIds, reward, block.number);
1443         if (reward > 0 && !pauseTokenEmissions) {
1444             _safeTransferRewards(msg.sender, reward);
1445         }
1446     }
1447 
1448     /**
1449      * @notice Deposit tokens into the contract
1450      * @param tokenIds - Array of token ids to stake
1451      */
1452     function deposit(uint256[] calldata tokenIds) external {
1453         for (uint256 i; i < tokenIds.length; i++) {
1454             uint256 tokenId = tokenIds[i];
1455             if (!pausedDepositBlocks) {
1456                 staked[tokenId].claimedAt = block.number;
1457             }
1458             erc721Address.safeTransferFrom(
1459                 msg.sender,
1460                 address(this),
1461                 tokenId,
1462                 ""
1463             );
1464             _mint(msg.sender, tokenId);
1465         }
1466     }
1467 
1468     /**
1469      * @notice Withdraw tokens from the contract
1470      * @param tokenIds - Array of token ids to stake
1471      */
1472     function withdraw(uint256[] calldata tokenIds) external {
1473         _claimRewards(tokenIds);
1474         for (uint256 i; i < tokenIds.length; i++) {
1475             uint256 tokenId = tokenIds[i];
1476             if (!_exists(tokenId)) {
1477                 revert TokenNonExistent(tokenId);
1478             }
1479             if (ownerOf(tokenId) != msg.sender) {
1480                 revert TokenNonOwner(tokenId);
1481             }
1482             _burn(tokenId);
1483             erc721Address.safeTransferFrom(
1484                 address(this),
1485                 msg.sender,
1486                 tokenId,
1487                 ""
1488             );
1489         }
1490     }
1491 
1492     /**
1493      * @notice Withdraw tokens from the staking contract
1494      * @param amount - Amount in wei to withdraw
1495      */
1496     function withdrawTokens(uint256 amount) external onlyOwner {
1497         _safeTransferRewards(msg.sender, amount);
1498     }
1499 
1500     /**
1501      *  @notice Toggles pause deposit blocks
1502      */
1503 
1504     function togglePauseDepositBlocks() external onlyOwner {
1505         pausedDepositBlocks = !pausedDepositBlocks;
1506     }
1507 
1508     /**
1509      * @dev Issues tokens only if there is a sufficient balance in the contract
1510      * @param recipient - receiving address
1511      * @param amount - amount in wei to transfer
1512      */
1513     function _safeTransferRewards(address recipient, uint256 amount) private {
1514         uint256 balance = erc20Address.balanceOf(address(this));
1515         if (amount <= balance) {
1516             erc20Address.transfer(recipient, amount);
1517         }
1518     }
1519 
1520     /**
1521      * @dev Modify the ERC20 token being emitted
1522      * @param _newErc20Address - address of token to emit
1523      */
1524     function setErc20Address(IERC20 _newErc20Address) external onlyOwner {
1525         erc20Address = _newErc20Address;
1526     }
1527 
1528     /**
1529      * @dev Modify the Staking contract address
1530      * @param _stakingContractV1Address - the new Staking contract
1531      */
1532     function setStakedSealsAddress(address _stakingContractV1Address)
1533         external
1534         onlyOwner
1535     {
1536         stakeSealsV1 = IStakeSeals(_stakingContractV1Address);
1537     }
1538 
1539     /**
1540      * @dev Modify the ERC721 contract address
1541      * @param _newErc721Address - the new Staking contract
1542      */
1543     function setERC721Address(IERC721 _newErc721Address) external onlyOwner {
1544         erc721Address = _newErc721Address;
1545     }
1546 
1547     /**
1548      * @dev Update the rates
1549      * @param index - the index of the new rate
1550      * @param rate - the new rate
1551      */
1552     function updateRewardRate(uint256 index, uint256 rate) external onlyOwner {
1553         rewardRate[index] = rate;
1554     }
1555 
1556     /**
1557      * @dev Toggle pausing the emissions
1558      */
1559     function toggleEmissions() external onlyOwner {
1560         pauseTokenEmissions = !pauseTokenEmissions;
1561     }
1562 
1563     /**
1564      * @dev Receive ERC721 tokens
1565      */
1566     function onERC721Received(
1567         address,
1568         address,
1569         uint256,
1570         bytes calldata
1571     ) external pure override returns (bytes4) {
1572         return IERC721Receiver.onERC721Received.selector;
1573     }
1574 }