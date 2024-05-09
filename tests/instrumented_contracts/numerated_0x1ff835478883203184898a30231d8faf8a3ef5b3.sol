1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Interface of the ERC165 standard, as defined in the
305  * https://eips.ethereum.org/EIPS/eip-165[EIP].
306  *
307  * Implementers can declare support of contract interfaces, which can then be
308  * queried by others ({ERC165Checker}).
309  *
310  * For an implementation, see {ERC165}.
311  */
312 interface IERC165 {
313     /**
314      * @dev Returns true if this contract implements the interface defined by
315      * `interfaceId`. See the corresponding
316      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
317      * to learn more about how these ids are created.
318      *
319      * This function call must use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool);
322 }
323 
324 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Implementation of the {IERC165} interface.
334  *
335  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
336  * for the additional interface id that will be supported. For example:
337  *
338  * ```solidity
339  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
340  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
341  * }
342  * ```
343  *
344  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
345  */
346 abstract contract ERC165 is IERC165 {
347     /**
348      * @dev See {IERC165-supportsInterface}.
349      */
350     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
351         return interfaceId == type(IERC165).interfaceId;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
356 
357 
358 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Required interface of an ERC721 compliant contract.
365  */
366 interface IERC721 is IERC165 {
367     /**
368      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
371 
372     /**
373      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
374      */
375     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
379      */
380     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
381 
382     /**
383      * @dev Returns the number of tokens in ``owner``'s account.
384      */
385     function balanceOf(address owner) external view returns (uint256 balance);
386 
387     /**
388      * @dev Returns the owner of the `tokenId` token.
389      *
390      * Requirements:
391      *
392      * - `tokenId` must exist.
393      */
394     function ownerOf(uint256 tokenId) external view returns (address owner);
395 
396     /**
397      * @dev Safely transfers `tokenId` token from `from` to `to`.
398      *
399      * Requirements:
400      *
401      * - `from` cannot be the zero address.
402      * - `to` cannot be the zero address.
403      * - `tokenId` token must exist and be owned by `from`.
404      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
405      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
406      *
407      * Emits a {Transfer} event.
408      */
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes calldata data
414     ) external;
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
418      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId
434     ) external;
435 
436     /**
437      * @dev Transfers `tokenId` token from `from` to `to`.
438      *
439      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must be owned by `from`.
446      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
458      * The approval is cleared when the token is transferred.
459      *
460      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
461      *
462      * Requirements:
463      *
464      * - The caller must own the token or be an approved operator.
465      * - `tokenId` must exist.
466      *
467      * Emits an {Approval} event.
468      */
469     function approve(address to, uint256 tokenId) external;
470 
471     /**
472      * @dev Approve or remove `operator` as an operator for the caller.
473      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
474      *
475      * Requirements:
476      *
477      * - The `operator` cannot be the caller.
478      *
479      * Emits an {ApprovalForAll} event.
480      */
481     function setApprovalForAll(address operator, bool _approved) external;
482 
483     /**
484      * @dev Returns the account approved for `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function getApproved(uint256 tokenId) external view returns (address operator);
491 
492     /**
493      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
494      *
495      * See {setApprovalForAll}
496      */
497     function isApprovedForAll(address owner, address operator) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
501 
502 
503 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
510  * @dev See https://eips.ethereum.org/EIPS/eip-721
511  */
512 interface IERC721Enumerable is IERC721 {
513     /**
514      * @dev Returns the total amount of tokens stored by the contract.
515      */
516     function totalSupply() external view returns (uint256);
517 
518     /**
519      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
520      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
521      */
522     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
523 
524     /**
525      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
526      * Use along with {totalSupply} to enumerate all tokens.
527      */
528     function tokenByIndex(uint256 index) external view returns (uint256);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Metadata is IERC721 {
544     /**
545      * @dev Returns the token collection name.
546      */
547     function name() external view returns (string memory);
548 
549     /**
550      * @dev Returns the token collection symbol.
551      */
552     function symbol() external view returns (string memory);
553 
554     /**
555      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
556      */
557     function tokenURI(uint256 tokenId) external view returns (string memory);
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @title ERC721 token receiver interface
569  * @dev Interface for any contract that wants to support safeTransfers
570  * from ERC721 asset contracts.
571  */
572 interface IERC721Receiver {
573     /**
574      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
575      * by `operator` from `from`, this function is called.
576      *
577      * It must return its Solidity selector to confirm the token transfer.
578      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
579      *
580      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
581      */
582     function onERC721Received(
583         address operator,
584         address from,
585         uint256 tokenId,
586         bytes calldata data
587     ) external returns (bytes4);
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
591 
592 
593 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Interface of the ERC20 standard as defined in the EIP.
599  */
600 interface IERC20 {
601     /**
602      * @dev Emitted when `value` tokens are moved from one account (`from`) to
603      * another (`to`).
604      *
605      * Note that `value` may be zero.
606      */
607     event Transfer(address indexed from, address indexed to, uint256 value);
608 
609     /**
610      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
611      * a call to {approve}. `value` is the new allowance.
612      */
613     event Approval(address indexed owner, address indexed spender, uint256 value);
614 
615     /**
616      * @dev Returns the amount of tokens in existence.
617      */
618     function totalSupply() external view returns (uint256);
619 
620     /**
621      * @dev Returns the amount of tokens owned by `account`.
622      */
623     function balanceOf(address account) external view returns (uint256);
624 
625     /**
626      * @dev Moves `amount` tokens from the caller's account to `to`.
627      *
628      * Returns a boolean value indicating whether the operation succeeded.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transfer(address to, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Returns the remaining number of tokens that `spender` will be
636      * allowed to spend on behalf of `owner` through {transferFrom}. This is
637      * zero by default.
638      *
639      * This value changes when {approve} or {transferFrom} are called.
640      */
641     function allowance(address owner, address spender) external view returns (uint256);
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
645      *
646      * Returns a boolean value indicating whether the operation succeeded.
647      *
648      * IMPORTANT: Beware that changing an allowance with this method brings the risk
649      * that someone may use both the old and the new allowance by unfortunate
650      * transaction ordering. One possible solution to mitigate this race
651      * condition is to first reduce the spender's allowance to 0 and set the
652      * desired value afterwards:
653      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
654      *
655      * Emits an {Approval} event.
656      */
657     function approve(address spender, uint256 amount) external returns (bool);
658 
659     /**
660      * @dev Moves `amount` tokens from `from` to `to` using the
661      * allowance mechanism. `amount` is then deducted from the caller's
662      * allowance.
663      *
664      * Returns a boolean value indicating whether the operation succeeded.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 amount
672     ) external returns (bool);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @dev Interface for the optional metadata functions from the ERC20 standard.
685  *
686  * _Available since v4.1._
687  */
688 interface IERC20Metadata is IERC20 {
689     /**
690      * @dev Returns the name of the token.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the symbol of the token.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the decimals places of the token.
701      */
702     function decimals() external view returns (uint8);
703 }
704 
705 // File: @openzeppelin/contracts/utils/Context.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev Provides information about the current execution context, including the
714  * sender of the transaction and its data. While these are generally available
715  * via msg.sender and msg.data, they should not be accessed in such a direct
716  * manner, since when dealing with meta-transactions the account sending and
717  * paying for execution may not be the actual sender (as far as an application
718  * is concerned).
719  *
720  * This contract is only required for intermediate, library-like contracts.
721  */
722 abstract contract Context {
723     function _msgSender() internal view virtual returns (address) {
724         return msg.sender;
725     }
726 
727     function _msgData() internal view virtual returns (bytes calldata) {
728         return msg.data;
729     }
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
733 
734 
735 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 
741 
742 
743 
744 
745 
746 /**
747  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
748  * the Metadata extension, but not including the Enumerable extension, which is available separately as
749  * {ERC721Enumerable}.
750  */
751 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
752     using Address for address;
753     using Strings for uint256;
754 
755     // Token name
756     string private _name;
757 
758     // Token symbol
759     string private _symbol;
760 
761     // Mapping from token ID to owner address
762     mapping(uint256 => address) private _owners;
763 
764     // Mapping owner address to token count
765     mapping(address => uint256) private _balances;
766 
767     // Mapping from token ID to approved address
768     mapping(uint256 => address) private _tokenApprovals;
769 
770     // Mapping from owner to operator approvals
771     mapping(address => mapping(address => bool)) private _operatorApprovals;
772 
773     /**
774      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
775      */
776     constructor(string memory name_, string memory symbol_) {
777         _name = name_;
778         _symbol = symbol_;
779     }
780 
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
785         return
786             interfaceId == type(IERC721).interfaceId ||
787             interfaceId == type(IERC721Metadata).interfaceId ||
788             super.supportsInterface(interfaceId);
789     }
790 
791     /**
792      * @dev See {IERC721-balanceOf}.
793      */
794     function balanceOf(address owner) public view virtual override returns (uint256) {
795         require(owner != address(0), "ERC721: balance query for the zero address");
796         return _balances[owner];
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
803         address owner = _owners[tokenId];
804         require(owner != address(0), "ERC721: owner query for nonexistent token");
805         return owner;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
826         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overridden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return "";
839     }
840 
841     /**
842      * @dev See {IERC721-approve}.
843      */
844     function approve(address to, uint256 tokenId) public virtual override {
845         address owner = ERC721.ownerOf(tokenId);
846         require(to != owner, "ERC721: approval to current owner");
847 
848         require(
849             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
850             "ERC721: approve caller is not owner nor approved for all"
851         );
852 
853         _approve(to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view virtual override returns (address) {
860         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         _setApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889 
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, "");
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914         _safeTransfer(from, to, tokenId, _data);
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
919      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
920      *
921      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
922      *
923      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
924      * implement alternative mechanisms to perform token transfer, such as signature-based.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeTransfer(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _transfer(from, to, tokenId);
942         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted (`_mint`),
951      * and stop existing when they are burned (`_burn`).
952      */
953     function _exists(uint256 tokenId) internal view virtual returns (bool) {
954         return _owners[tokenId] != address(0);
955     }
956 
957     /**
958      * @dev Returns whether `spender` is allowed to manage `tokenId`.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      */
964     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
965         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
966         address owner = ERC721.ownerOf(tokenId);
967         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
968     }
969 
970     /**
971      * @dev Safely mints `tokenId` and transfers it to `to`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(address to, uint256 tokenId) internal virtual {
981         _safeMint(to, tokenId, "");
982     }
983 
984     /**
985      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
986      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
987      */
988     function _safeMint(
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) internal virtual {
993         _mint(to, tokenId);
994         require(
995             _checkOnERC721Received(address(0), to, tokenId, _data),
996             "ERC721: transfer to non ERC721Receiver implementer"
997         );
998     }
999 
1000     /**
1001      * @dev Mints `tokenId` and transfers it to `to`.
1002      *
1003      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must not exist.
1008      * - `to` cannot be the zero address.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _mint(address to, uint256 tokenId) internal virtual {
1013         require(to != address(0), "ERC721: mint to the zero address");
1014         require(!_exists(tokenId), "ERC721: token already minted");
1015 
1016         _beforeTokenTransfer(address(0), to, tokenId);
1017 
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(address(0), to, tokenId);
1022 
1023         _afterTokenTransfer(address(0), to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Destroys `tokenId`.
1028      * The approval is cleared when the token is burned.
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must exist.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _burn(uint256 tokenId) internal virtual {
1037         address owner = ERC721.ownerOf(tokenId);
1038 
1039         _beforeTokenTransfer(owner, address(0), tokenId);
1040 
1041         // Clear approvals
1042         _approve(address(0), tokenId);
1043 
1044         _balances[owner] -= 1;
1045         delete _owners[tokenId];
1046 
1047         emit Transfer(owner, address(0), tokenId);
1048 
1049         _afterTokenTransfer(owner, address(0), tokenId);
1050     }
1051 
1052     /**
1053      * @dev Transfers `tokenId` from `from` to `to`.
1054      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {
1068         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1069         require(to != address(0), "ERC721: transfer to the zero address");
1070 
1071         _beforeTokenTransfer(from, to, tokenId);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId);
1075 
1076         _balances[from] -= 1;
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(from, to, tokenId);
1081 
1082         _afterTokenTransfer(from, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Approve `to` to operate on `tokenId`
1087      *
1088      * Emits a {Approval} event.
1089      */
1090     function _approve(address to, uint256 tokenId) internal virtual {
1091         _tokenApprovals[tokenId] = to;
1092         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `operator` to operate on all of `owner` tokens
1097      *
1098      * Emits a {ApprovalForAll} event.
1099      */
1100     function _setApprovalForAll(
1101         address owner,
1102         address operator,
1103         bool approved
1104     ) internal virtual {
1105         require(owner != operator, "ERC721: approve to caller");
1106         _operatorApprovals[owner][operator] = approved;
1107         emit ApprovalForAll(owner, operator, approved);
1108     }
1109 
1110     /**
1111      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1112      * The call is not executed if the target address is not a contract.
1113      *
1114      * @param from address representing the previous owner of the given token ID
1115      * @param to target address that will receive the tokens
1116      * @param tokenId uint256 ID of the token to be transferred
1117      * @param _data bytes optional data to send along with the call
1118      * @return bool whether the call correctly returned the expected magic value
1119      */
1120     function _checkOnERC721Received(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) private returns (bool) {
1126         if (to.isContract()) {
1127             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1128                 return retval == IERC721Receiver.onERC721Received.selector;
1129             } catch (bytes memory reason) {
1130                 if (reason.length == 0) {
1131                     revert("ERC721: transfer to non ERC721Receiver implementer");
1132                 } else {
1133                     assembly {
1134                         revert(add(32, reason), mload(reason))
1135                     }
1136                 }
1137             }
1138         } else {
1139             return true;
1140         }
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before any token transfer. This includes minting
1145      * and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1153      * - `from` and `to` are never both zero.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _beforeTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after any transfer of tokens. This includes
1165      * minting and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - when `from` and `to` are both non-zero.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _afterTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {}
1179 }
1180 
1181 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1182 
1183 
1184 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 
1190 /**
1191  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1192  * enumerability of all the token ids in the contract as well as all token ids owned by each
1193  * account.
1194  */
1195 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1196     // Mapping from owner to list of owned token IDs
1197     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1198 
1199     // Mapping from token ID to index of the owner tokens list
1200     mapping(uint256 => uint256) private _ownedTokensIndex;
1201 
1202     // Array with all token ids, used for enumeration
1203     uint256[] private _allTokens;
1204 
1205     // Mapping from token id to position in the allTokens array
1206     mapping(uint256 => uint256) private _allTokensIndex;
1207 
1208     /**
1209      * @dev See {IERC165-supportsInterface}.
1210      */
1211     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1212         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1217      */
1218     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1219         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1220         return _ownedTokens[owner][index];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Enumerable-totalSupply}.
1225      */
1226     function totalSupply() public view virtual override returns (uint256) {
1227         return _allTokens.length;
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Enumerable-tokenByIndex}.
1232      */
1233     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1234         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1235         return _allTokens[index];
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before any token transfer. This includes minting
1240      * and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1248      * - `from` cannot be the zero address.
1249      * - `to` cannot be the zero address.
1250      *
1251      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1252      */
1253     function _beforeTokenTransfer(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) internal virtual override {
1258         super._beforeTokenTransfer(from, to, tokenId);
1259 
1260         if (from == address(0)) {
1261             _addTokenToAllTokensEnumeration(tokenId);
1262         } else if (from != to) {
1263             _removeTokenFromOwnerEnumeration(from, tokenId);
1264         }
1265         if (to == address(0)) {
1266             _removeTokenFromAllTokensEnumeration(tokenId);
1267         } else if (to != from) {
1268             _addTokenToOwnerEnumeration(to, tokenId);
1269         }
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1274      * @param to address representing the new owner of the given token ID
1275      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1276      */
1277     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1278         uint256 length = ERC721.balanceOf(to);
1279         _ownedTokens[to][length] = tokenId;
1280         _ownedTokensIndex[tokenId] = length;
1281     }
1282 
1283     /**
1284      * @dev Private function to add a token to this extension's token tracking data structures.
1285      * @param tokenId uint256 ID of the token to be added to the tokens list
1286      */
1287     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1288         _allTokensIndex[tokenId] = _allTokens.length;
1289         _allTokens.push(tokenId);
1290     }
1291 
1292     /**
1293      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1294      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1295      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1296      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1297      * @param from address representing the previous owner of the given token ID
1298      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1299      */
1300     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1301         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1302         // then delete the last slot (swap and pop).
1303 
1304         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1305         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1306 
1307         // When the token to delete is the last token, the swap operation is unnecessary
1308         if (tokenIndex != lastTokenIndex) {
1309             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1310 
1311             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1312             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1313         }
1314 
1315         // This also deletes the contents at the last position of the array
1316         delete _ownedTokensIndex[tokenId];
1317         delete _ownedTokens[from][lastTokenIndex];
1318     }
1319 
1320     /**
1321      * @dev Private function to remove a token from this extension's token tracking data structures.
1322      * This has O(1) time complexity, but alters the order of the _allTokens array.
1323      * @param tokenId uint256 ID of the token to be removed from the tokens list
1324      */
1325     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1326         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1327         // then delete the last slot (swap and pop).
1328 
1329         uint256 lastTokenIndex = _allTokens.length - 1;
1330         uint256 tokenIndex = _allTokensIndex[tokenId];
1331 
1332         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1333         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1334         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1335         uint256 lastTokenId = _allTokens[lastTokenIndex];
1336 
1337         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1338         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1339 
1340         // This also deletes the contents at the last position of the array
1341         delete _allTokensIndex[tokenId];
1342         _allTokens.pop();
1343     }
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1347 
1348 
1349 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 
1355 
1356 /**
1357  * @dev Implementation of the {IERC20} interface.
1358  *
1359  * This implementation is agnostic to the way tokens are created. This means
1360  * that a supply mechanism has to be added in a derived contract using {_mint}.
1361  * For a generic mechanism see {ERC20PresetMinterPauser}.
1362  *
1363  * TIP: For a detailed writeup see our guide
1364  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1365  * to implement supply mechanisms].
1366  *
1367  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1368  * instead returning `false` on failure. This behavior is nonetheless
1369  * conventional and does not conflict with the expectations of ERC20
1370  * applications.
1371  *
1372  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1373  * This allows applications to reconstruct the allowance for all accounts just
1374  * by listening to said events. Other implementations of the EIP may not emit
1375  * these events, as it isn't required by the specification.
1376  *
1377  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1378  * functions have been added to mitigate the well-known issues around setting
1379  * allowances. See {IERC20-approve}.
1380  */
1381 contract ERC20 is Context, IERC20, IERC20Metadata {
1382     mapping(address => uint256) private _balances;
1383 
1384     mapping(address => mapping(address => uint256)) private _allowances;
1385 
1386     uint256 private _totalSupply;
1387 
1388     string private _name;
1389     string private _symbol;
1390 
1391     /**
1392      * @dev Sets the values for {name} and {symbol}.
1393      *
1394      * The default value of {decimals} is 18. To select a different value for
1395      * {decimals} you should overload it.
1396      *
1397      * All two of these values are immutable: they can only be set once during
1398      * construction.
1399      */
1400     constructor(string memory name_, string memory symbol_) {
1401         _name = name_;
1402         _symbol = symbol_;
1403     }
1404 
1405     /**
1406      * @dev Returns the name of the token.
1407      */
1408     function name() public view virtual override returns (string memory) {
1409         return _name;
1410     }
1411 
1412     /**
1413      * @dev Returns the symbol of the token, usually a shorter version of the
1414      * name.
1415      */
1416     function symbol() public view virtual override returns (string memory) {
1417         return _symbol;
1418     }
1419 
1420     /**
1421      * @dev Returns the number of decimals used to get its user representation.
1422      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1423      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1424      *
1425      * Tokens usually opt for a value of 18, imitating the relationship between
1426      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1427      * overridden;
1428      *
1429      * NOTE: This information is only used for _display_ purposes: it in
1430      * no way affects any of the arithmetic of the contract, including
1431      * {IERC20-balanceOf} and {IERC20-transfer}.
1432      */
1433     function decimals() public view virtual override returns (uint8) {
1434         return 18;
1435     }
1436 
1437     /**
1438      * @dev See {IERC20-totalSupply}.
1439      */
1440     function totalSupply() public view virtual override returns (uint256) {
1441         return _totalSupply;
1442     }
1443 
1444     /**
1445      * @dev See {IERC20-balanceOf}.
1446      */
1447     function balanceOf(address account) public view virtual override returns (uint256) {
1448         return _balances[account];
1449     }
1450 
1451     /**
1452      * @dev See {IERC20-transfer}.
1453      *
1454      * Requirements:
1455      *
1456      * - `to` cannot be the zero address.
1457      * - the caller must have a balance of at least `amount`.
1458      */
1459     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1460         address owner = _msgSender();
1461         _transfer(owner, to, amount);
1462         return true;
1463     }
1464 
1465     /**
1466      * @dev See {IERC20-allowance}.
1467      */
1468     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1469         return _allowances[owner][spender];
1470     }
1471 
1472     /**
1473      * @dev See {IERC20-approve}.
1474      *
1475      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1476      * `transferFrom`. This is semantically equivalent to an infinite approval.
1477      *
1478      * Requirements:
1479      *
1480      * - `spender` cannot be the zero address.
1481      */
1482     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1483         address owner = _msgSender();
1484         _approve(owner, spender, amount);
1485         return true;
1486     }
1487 
1488     /**
1489      * @dev See {IERC20-transferFrom}.
1490      *
1491      * Emits an {Approval} event indicating the updated allowance. This is not
1492      * required by the EIP. See the note at the beginning of {ERC20}.
1493      *
1494      * NOTE: Does not update the allowance if the current allowance
1495      * is the maximum `uint256`.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` and `to` cannot be the zero address.
1500      * - `from` must have a balance of at least `amount`.
1501      * - the caller must have allowance for ``from``'s tokens of at least
1502      * `amount`.
1503      */
1504     function transferFrom(
1505         address from,
1506         address to,
1507         uint256 amount
1508     ) public virtual override returns (bool) {
1509         address spender = _msgSender();
1510         _spendAllowance(from, spender, amount);
1511         _transfer(from, to, amount);
1512         return true;
1513     }
1514 
1515     /**
1516      * @dev Atomically increases the allowance granted to `spender` by the caller.
1517      *
1518      * This is an alternative to {approve} that can be used as a mitigation for
1519      * problems described in {IERC20-approve}.
1520      *
1521      * Emits an {Approval} event indicating the updated allowance.
1522      *
1523      * Requirements:
1524      *
1525      * - `spender` cannot be the zero address.
1526      */
1527     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1528         address owner = _msgSender();
1529         _approve(owner, spender, allowance(owner, spender) + addedValue);
1530         return true;
1531     }
1532 
1533     /**
1534      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1535      *
1536      * This is an alternative to {approve} that can be used as a mitigation for
1537      * problems described in {IERC20-approve}.
1538      *
1539      * Emits an {Approval} event indicating the updated allowance.
1540      *
1541      * Requirements:
1542      *
1543      * - `spender` cannot be the zero address.
1544      * - `spender` must have allowance for the caller of at least
1545      * `subtractedValue`.
1546      */
1547     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1548         address owner = _msgSender();
1549         uint256 currentAllowance = allowance(owner, spender);
1550         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1551         unchecked {
1552             _approve(owner, spender, currentAllowance - subtractedValue);
1553         }
1554 
1555         return true;
1556     }
1557 
1558     /**
1559      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1560      *
1561      * This internal function is equivalent to {transfer}, and can be used to
1562      * e.g. implement automatic token fees, slashing mechanisms, etc.
1563      *
1564      * Emits a {Transfer} event.
1565      *
1566      * Requirements:
1567      *
1568      * - `from` cannot be the zero address.
1569      * - `to` cannot be the zero address.
1570      * - `from` must have a balance of at least `amount`.
1571      */
1572     function _transfer(
1573         address from,
1574         address to,
1575         uint256 amount
1576     ) internal virtual {
1577         require(from != address(0), "ERC20: transfer from the zero address");
1578         require(to != address(0), "ERC20: transfer to the zero address");
1579 
1580         _beforeTokenTransfer(from, to, amount);
1581 
1582         uint256 fromBalance = _balances[from];
1583         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1584         unchecked {
1585             _balances[from] = fromBalance - amount;
1586         }
1587         _balances[to] += amount;
1588 
1589         emit Transfer(from, to, amount);
1590 
1591         _afterTokenTransfer(from, to, amount);
1592     }
1593 
1594     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1595      * the total supply.
1596      *
1597      * Emits a {Transfer} event with `from` set to the zero address.
1598      *
1599      * Requirements:
1600      *
1601      * - `account` cannot be the zero address.
1602      */
1603     function _mint(address account, uint256 amount) internal virtual {
1604         require(account != address(0), "ERC20: mint to the zero address");
1605 
1606         _beforeTokenTransfer(address(0), account, amount);
1607 
1608         _totalSupply += amount;
1609         _balances[account] += amount;
1610         emit Transfer(address(0), account, amount);
1611 
1612         _afterTokenTransfer(address(0), account, amount);
1613     }
1614 
1615     /**
1616      * @dev Destroys `amount` tokens from `account`, reducing the
1617      * total supply.
1618      *
1619      * Emits a {Transfer} event with `to` set to the zero address.
1620      *
1621      * Requirements:
1622      *
1623      * - `account` cannot be the zero address.
1624      * - `account` must have at least `amount` tokens.
1625      */
1626     function _burn(address account, uint256 amount) internal virtual {
1627         require(account != address(0), "ERC20: burn from the zero address");
1628 
1629         _beforeTokenTransfer(account, address(0), amount);
1630 
1631         uint256 accountBalance = _balances[account];
1632         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1633         unchecked {
1634             _balances[account] = accountBalance - amount;
1635         }
1636         _totalSupply -= amount;
1637 
1638         emit Transfer(account, address(0), amount);
1639 
1640         _afterTokenTransfer(account, address(0), amount);
1641     }
1642 
1643     /**
1644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1645      *
1646      * This internal function is equivalent to `approve`, and can be used to
1647      * e.g. set automatic allowances for certain subsystems, etc.
1648      *
1649      * Emits an {Approval} event.
1650      *
1651      * Requirements:
1652      *
1653      * - `owner` cannot be the zero address.
1654      * - `spender` cannot be the zero address.
1655      */
1656     function _approve(
1657         address owner,
1658         address spender,
1659         uint256 amount
1660     ) internal virtual {
1661         require(owner != address(0), "ERC20: approve from the zero address");
1662         require(spender != address(0), "ERC20: approve to the zero address");
1663 
1664         _allowances[owner][spender] = amount;
1665         emit Approval(owner, spender, amount);
1666     }
1667 
1668     /**
1669      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1670      *
1671      * Does not update the allowance amount in case of infinite allowance.
1672      * Revert if not enough allowance is available.
1673      *
1674      * Might emit an {Approval} event.
1675      */
1676     function _spendAllowance(
1677         address owner,
1678         address spender,
1679         uint256 amount
1680     ) internal virtual {
1681         uint256 currentAllowance = allowance(owner, spender);
1682         if (currentAllowance != type(uint256).max) {
1683             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1684             unchecked {
1685                 _approve(owner, spender, currentAllowance - amount);
1686             }
1687         }
1688     }
1689 
1690     /**
1691      * @dev Hook that is called before any transfer of tokens. This includes
1692      * minting and burning.
1693      *
1694      * Calling conditions:
1695      *
1696      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1697      * will be transferred to `to`.
1698      * - when `from` is zero, `amount` tokens will be minted for `to`.
1699      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1700      * - `from` and `to` are never both zero.
1701      *
1702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1703      */
1704     function _beforeTokenTransfer(
1705         address from,
1706         address to,
1707         uint256 amount
1708     ) internal virtual {}
1709 
1710     /**
1711      * @dev Hook that is called after any transfer of tokens. This includes
1712      * minting and burning.
1713      *
1714      * Calling conditions:
1715      *
1716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1717      * has been transferred to `to`.
1718      * - when `from` is zero, `amount` tokens have been minted for `to`.
1719      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1720      * - `from` and `to` are never both zero.
1721      *
1722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1723      */
1724     function _afterTokenTransfer(
1725         address from,
1726         address to,
1727         uint256 amount
1728     ) internal virtual {}
1729 }
1730 
1731 // File: @openzeppelin/contracts/access/Ownable.sol
1732 
1733 
1734 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 
1739 /**
1740  * @dev Contract module which provides a basic access control mechanism, where
1741  * there is an account (an owner) that can be granted exclusive access to
1742  * specific functions.
1743  *
1744  * By default, the owner account will be the one that deploys the contract. This
1745  * can later be changed with {transferOwnership}.
1746  *
1747  * This module is used through inheritance. It will make available the modifier
1748  * `onlyOwner`, which can be applied to your functions to restrict their use to
1749  * the owner.
1750  */
1751 abstract contract Ownable is Context {
1752     address private _owner;
1753 
1754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1755 
1756     /**
1757      * @dev Initializes the contract setting the deployer as the initial owner.
1758      */
1759     constructor() {
1760         _transferOwnership(_msgSender());
1761     }
1762 
1763     /**
1764      * @dev Returns the address of the current owner.
1765      */
1766     function owner() public view virtual returns (address) {
1767         return _owner;
1768     }
1769 
1770     /**
1771      * @dev Throws if called by any account other than the owner.
1772      */
1773     modifier onlyOwner() {
1774         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1775         _;
1776     }
1777 
1778     /**
1779      * @dev Leaves the contract without owner. It will not be possible to call
1780      * `onlyOwner` functions anymore. Can only be called by the current owner.
1781      *
1782      * NOTE: Renouncing ownership will leave the contract without an owner,
1783      * thereby removing any functionality that is only available to the owner.
1784      */
1785     function renounceOwnership() public virtual onlyOwner {
1786         _transferOwnership(address(0));
1787     }
1788 
1789     /**
1790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1791      * Can only be called by the current owner.
1792      */
1793     function transferOwnership(address newOwner) public virtual onlyOwner {
1794         require(newOwner != address(0), "Ownable: new owner is the zero address");
1795         _transferOwnership(newOwner);
1796     }
1797 
1798     /**
1799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1800      * Internal function without access restriction.
1801      */
1802     function _transferOwnership(address newOwner) internal virtual {
1803         address oldOwner = _owner;
1804         _owner = newOwner;
1805         emit OwnershipTransferred(oldOwner, newOwner);
1806     }
1807 }
1808 
1809 // File: witlinkstaking.sol
1810 
1811 
1812 
1813 pragma solidity 0.8.4;
1814 
1815     interface nftcontract {
1816         function maxSupply() view external returns (uint256);
1817     }
1818 
1819 
1820 
1821     //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1822 
1823     contract WitLinkStaking is Ownable, IERC721Receiver {
1824 
1825     uint256 public totalStaked;
1826     address public contractowner;
1827     uint256 public erc20balance;
1828     uint256 public zone1reward = 2;
1829     uint256 public zone2reward = 2;
1830     uint256 public zone3reward = 3;
1831     uint256 public zone4reward = 5;
1832     uint256 public largereward = 35;
1833     uint256 public smallreward = 15;
1834     uint256 public hightrafficreward = 50;
1835     uint256 public standardbase = 30 ether;
1836     uint256 public deluxebase = 70 ether;
1837     uint256 public villabase = 150 ether;
1838     uint256 public executivebase = 400 ether;
1839     uint16[] large =[uint16(6870), 6935, 6466, 6962, 6562, 6974, 6427, 6866, 6165, 6535, 6470, 6923, 6889, 6309, 6958, 6372, 6260, 6919, 6763, 6671, 6743, 6939, 6893, 6981, 6997, 6978, 6610, 6169, 6885, 6391, 6684, 6954, 6811, 6903, 6915, 6503, 6692, 6368, 6942, 6807, 6410, 6943, 6386, 6914, 6447, 6851, 6902, 6955, 6543, 6390, 6168, 6884, 6187, 6304, 7000, 6996, 6979, 6703, 6579, 6980, 6345, 6715, 6200, 6650, 6484, 6938, 6892, 6742, 6312, 6670, 6277, 6918, 6631, 6666, 6959, 6867, 6922, 6888, 6975, 6426, 6719, 6826, 6963, 6871, 6934, 6467, 6895, 6196, 6987, 6968, 6704, 6568, 6991, 6246, 6616, 6495, 6883, 6929, 6952, 6817, 6905, 6786, 6440, 6913, 6505, 6944, 6801, 6876, 6525, 6175, 6899, 6933, 6964, 6972, 6708, 6499, 6925, 6231, 6909, 6509, 6948, 6227, 6676, 6363, 6949, 6908, 6660, 6375, 6162, 6532, 6861, 6924, 6836, 6973, 6820, 6965, 6877, 6898, 6932, 6945, 6416, 6553, 6441, 6912, 6787, 6768, 6904, 6400, 6953, 6683, 6882, 6928, 6752, 6617, 6990, 6210, 6986, 6969, 6713, 6178, 6528, 6894, 6314, 6946, 6911, 6784, 6907, 6287, 6950, 6881, 6497, 6614, 6993, 6213, 6356, 6439, 6985, 6205, 6655, 6897, 6878, 6481, 6317, 6858, 6321, 6634, 6458, 6726, 6819, 6927, 6862, 6970, 6966, 6989, 6931, 6527, 6874, 6930, 6463, 6526, 6875, 6434, 6967, 6988, 6971, 6926, 6863, 6619, 6818, 6273, 6253, 6195, 6896, 6879, 6480, 6711, 6984, 6838, 6992, 6880, 6479, 6394, 6814, 6951, 6906, 6910, 6382, 6678, 6551, 6947, 6736, 6624, 6665, 6409, 6921, 6864, 6976, 6999, 6960, 6576, 6258, 6937, 6872, 6805, 6940, 6917, 6278, 6901, 6452, 6813, 6956, 6686, 6184, 6887, 6868, 6307, 6583, 6429, 6995, 6215, 6983, 6346, 6891, 6468, 6487, 6605, 6740, 6310, 6890, 6982, 6214, 6994, 6613, 6756, 6886, 6869, 6490, 6404, 6957, 6900, 6783, 6279, 6916, 6557, 6941, 6936, 6873, 6259, 6961, 6598, 6577, 6824, 6977, 6998, 6832, 6920, 6865, 6326, 6449, 6275];
1840     uint16[] small =[uint16(6827), 6831, 6759, 6722, 6630, 6325, 6276, 6333, 6221, 6364, 6190, 6344, 6597, 6702, 6352, 6647, 6217, 6305, 6240, 6186, 6796, 6283, 6779, 6450, 6515, 6295, 6387, 6554, 6806, 6739, 6693, 6369, 6502, 6451, 6797, 6778, 6328, 6492, 6241, 6611, 6646, 6607, 6257, 6365, 6735, 6559, 6627, 6762, 6324, 6774, 6723, 6758, 6830, 6575, 6172, 6315, 6600, 6483, 6529, 6712, 6207, 6657, 6397, 6682, 6401, 6790, 6285, 6456, 6513, 6293, 6769, 6856, 6319, 6572, 6163, 6548, 6724, 6374, 6323, 6289, 6620, 6335, 6226, 6764, 6334, 6267, 6637, 6322, 6288, 6230, 6725, 6359, 6709, 6573, 6436, 6318, 6748, 6524, 6800, 6695, 6857, 6457, 6791, 6284, 6379, 6729, 6181, 6569, 6586, 6355, 6343, 6656, 6197, 6601, 6251, 6415, 6696, 6679, 6854, 6442, 6842, 6511, 6268, 6403, 6395, 6301, 6751, 6585, 6839, 6643, 6710, 6194, 6747, 6675, 6419, 6337, 6788, 6264, 6376, 6663, 6233, 6474, 6161, 6423, 6589, 6835, 6823, 6570, 6462, 6199, 6176, 6822, 6658, 6208, 6422, 6567, 6530, 6249, 6232, 6320, 6635, 6859, 6766, 6623, 6789, 6418, 6361, 6224, 6603, 6746, 6316, 6204, 6592, 6642, 6212, 6707, 6584, 6300, 6183, 6402, 6286, 6228, 6223, 6389, 6761, 6331, 6327, 6777, 6798, 6262, 6848, 6370, 6235, 6188, 6649, 6425, 6560, 6608, 6413, 6690, 6385, 6852, 6501, 6444, 6517, 6281, 6794, 6405, 6669, 6612, 6645, 6595, 6829, 6203, 6653, 6192, 6604, 6311, 6469, 6486, 6594, 6644, 6306, 6185, 6238, 6668, 6812, 6280, 6516, 6845, 6453, 6500, 6445, 6465, 6520, 6218, 6648, 6189, 6473, 6536, 6408, 6721, 6371, 6760, 6330, 6625, 6367, 6222];
1841     uint16[] hightraffic= [uint16(380), 2018, 98, 4457, 1878, 2757, 5968, 363, 6780, 1784, 4704, 1802, 2015, 876, 1253, 4358, 1727, 6867, 2062, 5190, 1147, 1669, 1413, 3992, 2546, 4148, 1464, 4735, 4762, 6724, 1449, 5236, 3073, 2674, 597, 4431, 6498, 2988, 6359, 6820, 2785, 4344, 173, 3268, 5055, 1368, 4557, 45, 1098, 2964, 6463, 4736, 6926, 4794, 4669, 1484, 5202, 2237, 3871, 5527, 6425, 1339, 5395, 3579, 3083, 96, 5100, 4910, 1138, 2353, 6890, 2241, 6347, 3939, 5510, 3333, 4675, 5463, 3718, 4862];
1842     uint16[] zone4 = [uint16(6523), 3371, 2999, 2560, 396, 1989, 1966, 953, 5358, 3326, 6574, 6061, 6962, 5837, 512, 4375, 292, 338, 6831, 4949, 3019, 4676, 2608, 912, 5067, 695, 3367, 5876, 5175, 800, 5030, 1423, 5899, 2448, 5227, 5698, 3465, 5270, 4898, 656, 343, 5335, 3432, 3824, 77, 4318, 6775, 4924, 2235, 2665, 5909, 1419, 6333, 1767, 6364, 1710, 1655, 6190, 5568, 5138, 2307, 288, 2868, 5354, 1602, 5987, 5591, 1182, 5968, 4380, 1028, 5712, 2487, 334, 764, 3296, 6978, 5529, 3804, 4768, 5895, 949, 1706, 6493, 5315, 4857, 6885, 4441, 3193, 898, 4343, 1141, 3740, 6542, 3310, 4986, 5010, 94, 1403, 1546, 3081, 2690, 3202, 6000, 5293, 3582, 3428, 2393, 5006, 2055, 4882, 6446, 1679, 4181, 2956, 1229, 2813, 6850, 3886, 5051, 5401, 4640, 1012, 6738, 2281, 2901, 6411, 5378, 2147, 4569, 3612, 3757, 2795, 5953, 1506, 6914, 1697, 2541, 3429, 4616, 1947, 2668, 972, 2238, 134, 6294, 2941, 6847, 5768, 437, 4745, 4315, 821, 2015, 5380, 6406, 2916, 319, 2150, 876, 5103, 6685, 4712, 2982, 362, 5744, 1212, 5528, 4339, 3413, 4801, 4102, 1300, 6580, 270, 2193, 159, 6353, 6083, 3281, 2185, 6596, 17, 1195, 3901, 2243, 4143, 4513, 1204, 4006, 1654, 2078, 6892, 548, 1984, 6607, 1068, 3055, 6365, 4358, 3167, 6735, 4708, 3537, 1623, 303, 641, 4925, 1731, 3433, 4030, 1377, 4175, 5334, 5764, 2275, 2625, 196, 6236, 6373, 250, 3608, 1635, 2449, 4122, 4088, 5877, 6534, 3736, 5089, 4677, 1926, 5436, 2259, 5066, 769, 4948, 6076, 1875, 905, 1930, 4661, 4231, 2536, 4118, 6125, 3327, 6963, 1822, 1988, 1121, 544, 5861, 3059, 3370, 2998, 378, 6934, 1595, 2643, 1346, 5094, 2614, 3005, 2497, 774, 4406, 5082, 4369, 3156, 5597, 3910, 918, 1757, 5714, 5344, 2194, 3551, 559, 2340, 5743, 6180, 3382, 1215, 3228, 2593, 5256, 4914, 1002, 6397, 1147, 6728, 871, 5104, 4980, 2157, 4579, 2854, 4129, 575, 5850, 5780, 349, 6840, 1940, 5846, 3838, 5515, 2680, 3642, 6010, 6381, 4216, 2268, 922, 5112, 867, 2004, 6047, 6417, 2907, 6102, 2842, 2136, 4148, 2970, 2073, 5866, 6749, 5535, 1433, 6122, 6067, 6437, 1872, 1034, 2248, 5077, 6837, 4559, 3859, 5574, 6860, 4918, 1219, 1649, 806, 5523, 4298, 5935, 4277, 2209, 257, 1632, 1777, 5364, 2272, 5108, 26, 1235, 6909, 4488, 2675, 6773, 4164, 1736, 3422, 5149, 6765, 1274, 2008, 4830, 4099, 6677, 6362, 2321, 1019, 2770, 4427, 6949, 581, 3073, 2662, 89, 6764, 6508, 2674, 3065, 597, 3120, 3989, 2048, 5332, 5298, 344, 2273, 893, 5559, 6725, 4431, 6119, 6549, 5735, 5522, 4626, 2208, 2988, 738, 4919, 5125, 4221, 2526, 4558, 3337, 6420, 6973, 515, 450, 3008, 2619, 283, 6066, 112, 1577, 5164, 5471, 5922, 4519, 6174, 6031, 6945, 6380, 4217, 5810, 4702, 1384, 5797, 4169, 5001, 427, 1412, 1557, 831, 2947, 431, 4256, 3593, 5017, 962, 3985, 1812, 2013, 2156, 6816, 1280, 2785, 6396, 1516, 3878, 4850, 3696, 5257, 4915, 1097, 2341, 1582, 1306, 5650, 6705, 1490, 3638, 260, 4057, 4684, 1486, 5979, 2838, 5611, 237, 4779, 4329, 6601, 3053, 2212, 4994, 5686, 1295, 4428, 4701, 166, 4351, 920, 1446, 4490, 2114, 3210, 6012, 218, 832, 998, 131, 561, 5844, 5901, 2, 2397, 3343, 6454, 3656, 5628, 3085, 1542, 4605, 598, 6792, 6268, 3590, 6546, 2769, 5805, 5940, 5043, 1217, 4500, 2084, 4279, 6244, 2342, 3787, 6993, 5346, 4107, 5595, 449, 6643, 3011, 1606, 6593, 4054, 3791, 5350, 6985, 664, 3396, 4146, 6602, 4795, 5887, 1082, 3115, 45, 5491, 2704, 1763, 306, 4832, 243, 3565, 1108, 2724, 3973, 6622, 3359, 1364, 351, 4166, 3709, 4920, 3573, 6771, 3436, 2677, 717, 4170, 1372, 5331, 1519, 1149, 2335, 890, 3461, 193, 2509, 3318, 4127, 4577, 740, 5034, 557, 1132, 4019, 3226, 1866, 2749, 3158, 629, 1759, 2175, 5075, 3908, 453, 4371, 845, 2533, 4799, 1061, 957, 3660, 6462, 1718, 3375, 6874, 1963, 2709, 5166, 4327, 6064, 2027, 3909, 1934, 5424, 452, 4720, 1522, 5998, 1871, 2461, 6422, 628, 2877, 5432, 5598, 501, 4018, 3677, 5259, 2573, 3732, 4274, 556, 4599, 5672, 891, 1723, 4171, 4464, 6770, 4258, 3067, 5449, 1365, 3708, 4537, 700, 1670, 2660, 4130, 5721, 5234, 6418, 1277, 6048, 3860, 491, 3499, 2637, 5058, 3401, 4794, 1083, 3544, 2705, 3378, 4517, 4239, 6204, 4669, 1892, 3143, 3513, 1187, 3856, 4043, 4940, 2482, 1304, 4782, 4297, 1095, 6880, 1646, 6183, 366, 4151, 5740, 2768, 3179, 1514, 4716, 937, 3895, 3745, 2857, 3250, 576, 3987, 960, 6639, 6793, 1056, 3591, 2103, 2800, 5279, 2379, 3568, 4757, 3587, 6506, 4887, 5795, 4184, 4700, 4350, 167, 5111, 5541, 2284, 3883, 3929, 188, 1017, 1294, 6044, 3246, 6414, 6366, 3867, 880, 183, 479, 4567, 5399, 63, 2722, 3563, 3133, 6331, 584, 1698, 5264, 1227, 6448, 1118, 3963, 204, 1231, 5788, 5622, 22, 3871, 480, 3488, 4658, 3467, 5049, 3934, 4121, 1323, 5730, 4967, 1266, 1636, 4623, 2431, 3670, 6537, 4224, 1163, 6425, 3627, 2935, 3277, 2870, 455, 4662, 5589, 5136, 2759, 510, 6960, 2020, 793, 6825, 6608, 117, 3666, 5248, 2562, 6872, 2098, 3373, 1339, 2846, 5680, 1786, 5116, 5546, 3538, 4357, 5053, 4300, 3095, 2684, 1047, 6782, 588, 1728, 2104, 658, 1397, 5854, 4746, 434, 1401, 5696, 3742, 4087, 1285, 3607, 4341, 3484, 1143, 4711, 5100, 5415, 2780, 6239, 5317, 5747, 3369, 3806, 2190, 3781, 5340, 5985, 3152, 1495, 1600, 2186, 4547, 3328, 1315, 4117, 3902, 4681, 6716, 3847, 4906, 3390, 727, 1712, 4269, 1084, 2216, 5479, 42, 2353, 5245, 6039, 2979, 4454, 6469, 2095, 6202, 4395, 3450, 458, 4680, 6717, 5838, 1528, 2754, 4403, 3796, 4053, 264, 5212, 6982, 2168, 6828, 3779, 771, 321, 4679, 3446, 2257, 5438, 2312, 3850, 6701, 6351, 6582, 1247, 788, 6428, 4415, 3295, 1752, 2484, 419, 3554, 1990, 2345, 675, 4012, 6869, 730, 3368, 1841, 198, 6668, 5697, 4985, 2502, 5228, 2017, 3082, 3128, 6795, 1953, 6516, 6453, 659, 835, 5455, 6853, 6150, 4028, 2056, 2328, 862, 1504, 5814, 4356, 161, 1011, 5402, 1768, 6042, 2830, 5475, 4634, 5160, 2021, 1748, 2534, 454, 1524, 5834, 4376, 3626, 6074, 5434, 442, 157, 1532, 854, 6166, 1359, 2826, 4622, 4272, 2349, 5526, 5674, 4966, 5224, 3870, 3489, 4874, 710, 1375, 4198, 4032, 6776, 2365, 2220, 593, 3431, 1699, 5770, 4024, 6760, 4618, 2666, 614, 4970, 2631, 881];
1843     uint16[] zone3 = [uint16(6489), 2130, 6870, 2425, 3664, 1823, 5499, 1120, 545, 1065, 4267, 3408, 4637, 2219, 2167, 2921, 1527, 5134, 5564, 5421, 904, 1931, 5972, 1198, 2872, 6098, 6562, 6132, 5122, 1161, 4733, 5821, 4226, 3449, 441, 1927, 5437, 2126, 4158, 6165, 4508, 3737, 2960, 3388, 2063, 6759, 4764, 4334, 5525, 5460, 1970, 4066, 1634, 4436, 4820, 5732, 5362, 314, 4123, 1321, 4573, 1771, 4089, 894, 3936, 1458, 1008, 6722, 6688, 3170, 2331, 5620, 1399, 1663, 1726, 713, 4524, 6519, 1376, 590, 2673, 2389, 2223, 1819, 986, 4027, 210, 5636, 5773, 4162, 1360, 4532, 6276, 1049, 3074, 3561, 139, 3832, 2720, 4973, 4070, 247, 4565, 752, 3023, 181, 2632, 928, 882, 2798, 5548, 3865, 2777, 4359, 3166, 6734, 4284, 5495, 1985, 2700, 6256, 1593, 1069, 4791, 3687, 2995, 375, 1340, 725, 4007, 4457, 3392, 2429, 3845, 1878, 6344, 5991, 3003, 6201, 4396, 908, 1747, 3280, 322, 2491, 5704, 4816, 267, 1252, 508, 4695, 6352, 158, 2311, 1881, 3916, 6647, 3445, 4800, 6997, 1301, 4553, 6094, 2891, 1614, 621, 4416, 2468, 2038, 5207, 2716, 5179, 57, 6755, 3557, 3042, 1585, 3412, 5196, 2829, 4504, 1356, 2983, 4154, 5250, 4912, 5600, 1004, 1454, 3469, 2782, 5047, 3890, 877, 5552, 1842, 174, 4713, 5801, 1511, 2014, 1638, 1268, 4590, 4085, 748, 6112, 2151, 5694, 5440, 1950, 5913, 3594, 6796, 6283, 4744, 6779, 5856, 1116, 3828, 820, 1395, 2413, 2043, 6846, 5769, 5339, 4178, 3347, 4482, 4528, 3717, 1045, 420, 1946, 5456, 82, 1550, 6295, 5790, 3701, 709, 4494, 6153, 2110, 2794, 1911, 5952, 1157, 4355, 162, 3869, 1854, 6041, 6942, 5682, 3306, 6410, 5396, 6943, 2003, 5683, 2146, 1290, 2845, 5050, 925, 4211, 1013, 499, 4354, 5115, 3868, 5791, 2054, 4883, 2404, 3645, 4180, 2957, 1228, 2812, 6502, 6152, 4246, 3583, 1414, 5904, 7, 5457, 3995, 5142, 2687, 1551, 6001, 3653, 6902, 5787, 2042, 5292, 4179, 1681, 4529, 5441, 964, 1951, 4600, 1402, 1052, 6797, 1547, 6778, 6328, 3983, 5504, 4968, 2445, 1793, 6056, 1269, 3741, 4084, 749, 1286, 6810, 1455, 3192, 5945, 2629, 2279, 5046, 3891, 5553, 525, 4505, 698, 3690, 5314, 4856, 2081, 5251, 6884, 4913, 3385, 6187, 2717, 3805, 3106, 6754, 3556, 4786, 3043, 2652, 2202, 3297, 1245, 4047, 3782, 4944, 6979, 5656, 2039, 5206, 509, 5986, 1496, 2310, 3917, 5969, 3444, 6216, 3014, 1029, 289, 4544, 6129, 4114, 5355, 5705, 5210, 636, 2886, 1253, 2756, 5139, 1480, 3517, 3002, 4397, 724, 1711, 231, 3393, 4456, 4905, 2582, 2351, 3956, 5181, 1592, 4790, 3022, 3472, 929, 883, 5549, 1859, 37, 4972, 616, 4421, 246, 1789, 1273, 753, 4564, 1336, 4837, 2234, 6277, 1048, 568, 6332, 991, 211, 5637, 5267, 5288, 704, 4533, 3063, 591, 3599, 6631, 968, 99, 2388, 5508, 1818, 3825, 4319, 6324, 6774, 3576, 2808, 342, 4876, 6666, 1009, 6723, 6689, 21, 2330, 2760, 1265, 4964, 5226, 4821, 5363, 1320, 745, 1567, 5174, 5031, 5932, 4270, 1588, 5748, 4159, 4509, 2824, 3223, 381, 3389, 6922, 856, 1863, 1160, 4698, 5820, 505, 1025, 3448, 440, 2609, 913, 2873, 6563, 3331, 2170, 2520, 3624, 1619, 786, 143, 4374, 840, 5565, 5973, 1033, 6826, 5359, 2865, 790, 3262, 3798, 6060, 2920, 2023, 4773, 1064, 4266, 952, 728, 6488, 6172, 2131, 1658, 6037, 3235, 1983, 5539, 3814, 4328, 6315, 6600, 3052, 6250, 959, 689, 6483, 2839, 6529, 5755, 2090, 5610, 4001, 1203, 4451, 3394, 148, 1487, 3510, 518, 6712, 3906, 6657, 5702, 4543, 1741, 1311, 3639, 6591, 1254, 2881, 6968, 5578, 1868, 6704, 3506, 6354, 4693, 5981, 2252, 4105, 6092, 3290, 2481, 2897, 3785, 6587, 4410, 6753, 3802, 1995, 5190, 5313, 2086, 3697, 6495, 1350, 670, 4447, 4017, 2439, 6929, 934, 1901, 4200, 467, 4650, 5942, 1452, 6378, 1517, 4715, 5807, 3879, 2911, 3603, 6051, 5387, 2442, 5368, 6544, 4083, 3746, 1405, 5915, 6790, 4257, 2229, 5016, 2679, 1956, 2696, 3984, 4742, 3087, 1110, 4938, 2415, 3204, 1393, 4191, 1686, 3711, 2550, 2100, 2395, 84, 4241, 1043, 1413, 1556, 6293, 4754, 3091, 6769, 2950, 3212, 6856, 5283, 2546, 4538, 6155, 4168, 1690, 5954, 471, 3029, 888, 3880, 2638, 3496, 4979, 2454, 1278, 4580, 3300, 3750, 2511, 2141, 4996, 6876, 2566, 4518, 6525, 3377, 113, 1576, 4774, 3818, 4261, 406, 3770, 6572, 1608, 5132, 5831, 1521, 3459, 1464, 1937, 5427, 902, 5348, 6134, 3623, 781, 3789, 2032, 6358, 1864, 914, 5061, 447, 4670, 5962, 369, 6533, 739, 6925, 2065, 3224, 2966, 1833, 555, 5870, 105, 1130, 1425, 3418, 4627, 1075, 2659, 1976, 4060, 4430, 4125, 2858, 191, 6661, 3033, 2788, 5558, 3875, 4349, 6374, 3658, 650, 2049, 5276, 715, 345, 596, 3064, 5919, 129, 6289, 3571, 579, 2730, 2360, 5630, 5260, 6159, 6509, 5775, 6620, 580, 3588, 2233, 979, 2399, 5519, 2726, 1624, 4426, 3249, 5237, 1761, 2634, 5958, 1448, 187, 168, 6732, 30, 2635, 2265, 3024, 6699, 3161, 3531, 6733, 2320, 31, 3618, 3248, 2009, 5723, 4831, 305, 3423, 3970, 978, 1808, 3566, 6334, 3136, 4470, 1367, 702, 5324, 1408, 6288, 3570, 2731, 70, 981, 4466, 651, 3209, 5277, 6908, 4870, 4523, 190, 2789, 2623, 2336, 4348, 4962, 4124, 2859, 1998, 5488, 807, 1832, 4763, 5871, 554, 1561, 1131, 3419, 411, 3049, 2658, 3730, 6861, 6924, 2064, 6027, 1648, 1166, 6709, 5826, 1865, 1023, 1189, 1473, 3767, 4108, 6135, 3788, 6070, 3458, 2249, 5076, 6123, 6089, 6573, 2530, 6820, 6965, 796, 2926, 4325, 6748, 3819, 1961, 5888, 407, 4630, 1432, 6524, 3726, 4149, 3376, 391, 6898, 2588, 4978, 2455, 5390, 2005, 1783, 6046, 3301, 6800, 3478, 1015, 2269, 889, 923, 5406, 5113, 2286, 1853, 535, 4352, 3497, 4186, 6912, 5328, 6857, 4539, 2814, 4493, 3356, 2394, 85, 4240, 1042, 6787, 5902, 1107, 6292, 562, 5847, 3090, 4755, 3993, 2681, 2414, 2044, 348, 718, 5294, 5914, 2678, 5152, 827, 6284, 1111, 3252, 5369, 5693, 4578, 2855, 4082, 4128, 5410, 5040, 3897, 1003, 3194, 466, 489, 6683, 4714, 5806, 523, 2290, 5555, 870, 4503, 1701, 4446, 671, 4016, 221, 2068, 2438, 6928, 6302, 558, 3803, 50, 5484, 1994, 3946, 6247, 1078, 3291, 5715, 2896, 4041, 626, 5129, 2316, 2746, 5083, 4738, 6355, 4387, 6640, 5596, 2496, 6986, 5703, 4811, 775, 3287, 6085, 4112, 1255, 6590, 3268, 5216, 4954, 5996, 6713, 519, 5580, 6206, 1039, 1469, 6482, 688, 372, 4145, 1717, 4515, 4903, 1202, 1982, 5168, 5492, 6744, 3403, 5884, 4796, 1594, 3950, 958, 6803, 3302, 4078, 2905, 3617, 536, 5110, 2285, 5540, 5055, 2790, 3882, 6383, 473, 3181, 4644, 5956, 1738, 6157, 3355, 6854, 5281, 4886, 2051, 2401, 2952, 4185, 69, 2682, 3990, 3139, 6291, 1554, 424, 4613, 86, 5452, 1942, 5297, 1684, 3713, 2801, 6511, 4039, 1391, 2944, 2047, 4890, 5151, 2694, 5501, 1954, 5444, 90, 961, 6638, 1057, 4255, 3744, 4081, 1779, 6116, 5690, 2155, 3601, 4594, 1796, 6053, 2293, 873, 6680, 4347, 1515, 3528, 3197, 465, 1450, 3894, 2786, 6881, 5604, 2968, 672, 1702, 4150, 3695, 2987, 367, 6497, 5311, 3046, 3945, 2657, 3800, 2712, 808, 6301, 1094, 4042, 275, 4412, 1610, 5653, 3768, 3292, 3912, 2600, 3441, 4384, 6213, 6706, 3504, 5983, 3154, 4957, 4404, 799, 263, 6069, 3284, 4541, 6086, 4111, 3007, 1190, 3457, 4392, 5429, 5079, 1893, 5583, 849, 12, 6710, 234, 4003, 6194, 4900, 2587, 6878, 2138, 1344, 3379, 371, 1714, 2641, 3953, 408, 3050, 6252, 5868, 3861, 3498, 4218, 6675, 3924, 2266, 1299, 4131, 5370, 4998, 5720, 4977, 5665, 1626, 6419, 4424, 6337, 65, 2374, 3836, 2231, 428, 582, 6788, 6272, 5327, 1734, 4473, 4189, 5632, 5262, 2362, 982, 594, 1722, 1688, 4873, 4936, 4465, 1237, 4035, 3174, 486, 2765, 2270, 2620, 469, 6663, 3031, 4824, 2159, 255, 605, 4625, 1077, 6248, 4275, 1831, 6024, 6474, 384, 5258, 2067, 2572, 6862, 3363, 3699, 2821, 5576, 1535, 2460, 2933, 3271, 6589, 279, 4808, 6835, 2525, 1935, 1466, 5976, 4234, 516, 5833, 5999, 1870, 4058, 4408, 3637, 5219, 2026, 3322, 6570, 3288, 4263, 404, 4633, 5537, 49, 2358, 5167, 1124, 3549, 4776, 2972, 3230, 6032, 238, 4849, 2070, 393, 6463, 2836, 3724, 686, 2135, 4848, 6875, 4262, 1060, 5920, 1430, 5473, 5189, 5023, 1826, 110, 1575, 540, 6434, 5648, 5218, 2162, 2498, 3323, 3289, 901, 6658, 4665, 5977, 6208, 517, 1488, 5131, 844, 2031, 6971, 2932, 782, 3270, 2898, 6567, 3335, 444, 4673, 1471, 1888, 1867, 2748, 5577, 151, 5824, 4448, 2965, 6926, 3698, 2820, 1426, 5936, 4624, 4761, 1133, 1830, 4825, 2158, 5367, 741, 4576, 4063, 604, 1631, 5388, 1518, 2334, 25, 2764, 3899, 3933, 6398, 468, 1666, 2949, 653, 6459, 829, 3088, 4608, 6635, 3437, 6859, 5776, 2119, 3358, 215, 1220, 5799, 3564, 1559, 3134, 64, 995, 3421, 3071, 6789, 4560, 757, 1762, 307, 4999, 2908, 4425, 33, 2322, 3163, 6361, 6224, 3026, 184, 3925, 1918, 2267, 887, 5185, 2640, 3952, 5886, 6746, 1579, 6316, 1980, 4002, 665, 4901, 5243, 6896, 1345, 3728, 1191, 13, 1484, 5214, 5644, 1607, 6438, 632, 798, 6592, 2882, 262, 3285, 777, 327, 2494, 5701, 3913, 3440, 6642, 448, 3010, 6212, 5982, 3155, 5081, 1241, 5202, 5717, 4805, 2178, 6091, 1580, 3801, 5486, 1996, 6300, 2590, 6479, 1216, 4501, 4852, 5557, 2338, 29, 1144, 521, 4203, 1001, 464, 4653, 3196, 1902, 5042, 6117, 3315, 2504, 3600, 2912, 6402, 6052, 5853, 6286, 5150, 5015, 1955, 5445, 599, 6269, 4254, 6843, 4487, 6140, 1390, 4468, 5783, 2729, 999, 5146, 3991, 6290, 6785, 1040, 87, 3354, 2545, 2050, 2953, 3641, 5812, 3495, 2791, 5054, 5404, 921, 4215, 6228, 2512, 6802, 3303, 4079, 2007, 6736, 1509, 2775, 34, 3922, 3888, 3021, 6223, 4834, 3308, 300, 4137, 4072, 4588, 5663, 992, 2372, 6761, 3099, 3426, 5458, 4160, 4530, 5771, 1677, 5858, 3575, 3826, 984, 2671, 6798, 6262, 5767, 6848, 3719, 711, 1374, 4176, 4463, 4930, 2333, 2763, 2299, 6720, 3037, 2276, 5419, 4571, 4064, 6409, 414, 4789, 1071, 5462, 947, 1972, 5198, 59, 802, 5874, 4766, 3109, 4336, 3220, 6188, 6167, 1708, 2827, 4859, 5435, 4674, 4361, 5823, 506, 1860, 5120, 6075, 4048, 5209, 5659, 6999, 2489, 3332, 6130, 1460, 1899, 5423, 18, 843, 5566, 1525, 3148, 140, 2470, 3261, 2889, 6063, 6433, 639, 6126, 4818, 4635, 4320, 547, 4770, 814, 5531, 1821, 4009, 2077, 4091, 1769, 2515, 4992, 6043, 6413, 530, 1155, 6690, 475, 6385, 2796, 3884, 5403, 2112, 6852, 4496, 6151, 6444, 4479, 3646, 3216, 5792, 2407, 4750, 5842, 1552, 834, 5511, 1801, 5141, 3996, 4, 4245, 3580, 422, 5907, 3715, 4879, 3200, 6002, 2368, 3980, 5507, 3579, 6281, 4603, 4253, 5012, 2387, 1952, 2503, 6540, 3312, 4438, 2915, 4068, 5229, 5679, 6956, 176, 526, 1513, 2295, 5550, 875, 1840, 3938, 5946, 6669, 3386, 4443, 224, 5252, 4855, 4506, 4156, 2981, 2651, 2201, 3040, 1587, 3410, 6307, 1138, 4290, 5481, 4947, 5205, 4044, 6079, 2893, 623, 336, 3294, 766, 5710, 6995, 1180, 4382, 3851, 2743, 3502, 6700, 635, 4402, 265, 2885, 6983, 2493, 6829, 6080, 5585, 1895, 6203, 3144, 5993, 14, 6891, 2581, 4005, 6192, 2094, 4639, 6604, 4793, 3056, 5497, 2702, 818, 3543, 3407, 1590, 3057, 4792, 5029, 5183, 3954, 4287, 3112, 1206, 233, 1656, 6193, 663, 6486, 4511, 726, 4842, 5750, 5584, 6347, 3145, 1178, 5091, 15, 2304, 5707, 4116, 6644, 1928, 2742, 5984, 3153, 5654, 2191, 4946, 1617, 337, 6097, 5711, 6994, 3942, 2650, 2200, 5896, 4784, 6306, 1569, 6185, 225, 1210, 6886, 2129, 5316, 3738, 1705, 1355, 3692, 2980, 6687, 527, 4710, 2294, 1904, 3939, 3893, 1007, 6238, 1457, 6392, 462, 3743, 6541, 2914, 6054, 1791, 4069, 3256, 2447, 2693, 5156, 1816, 120, 4317, 4252, 5013, 5443, 97, 3344, 3714, 1729, 6845, 5290, 2040, 6003, 3651, 4751, 566, 1800, 5140, 1945, 6279, 6629, 2113, 3702, 4497, 1380, 4478, 3647, 4881, 2406, 39, 3539, 6691, 3493, 5052, 927, 6107, 1292, 4839, 2514, 4993, 2144, 5681, 6941, 3610, 2975, 6035, 6936, 2133, 2099, 6520, 3958, 1066, 1436, 6609, 403, 1123, 1573, 815, 3260, 6127, 3325, 2164, 4663, 5971, 4399, 5588, 5422, 19, 842, 3519, 1174, 2934, 5208, 2037, 5658, 6998, 6832, 3763, 3299, 3333, 3919, 911, 5064, 6218, 1498, 507, 5822, 5571, 6920, 6023, 383, 6473, 3364, 3734, 4858, 6865, 1420, 4788, 1070, 5033, 5463, 1973, 5199, 58, 3558, 550, 3108, 4823, 1267, 6058, 2332, 878, 3523, 481, 6371, 6664, 3466, 4209, 3036, 5048, 3935, 5336, 2559, 6849, 1725, 4527, 3348, 4462, 205, 1230, 5273, 3124, 1119, 5859, 985, 74, 3962, 3061, 6633, 356, 5320, 6019, 1676, 4474, 2723, 3098, 3132, 6330, 3077, 585, 4835, 1764, 3309, 244, 1271, 5662, 497, 3866, 3020, 6222];
1844     uint16[] zone2 = [uint16(3721), 2833, 729, 6173, 6935, 4908, 2976, 816, 5163, 4322, 5860, 1570, 4288, 5925, 2649, 5476, 5026, 5708, 6827, 4549, 791, 3633, 2188, 4725, 142, 3849, 841, 5071, 457, 1462, 1032, 3330, 2171, 2521, 2034, 6974, 2464, 6427, 1618, 6077, 1248, 3275, 857, 5572, 1862, 154, 1531, 5964, 2258, 6535, 3222, 6020, 3672, 6889, 1566, 553, 3808, 945, 4621, 5933, 4271, 1589, 1073, 1264, 3259, 3609, 4965, 2018, 2624, 5948, 197, 6237, 3035, 482, 6372, 20, 2761, 4932, 4461, 1233, 4174, 4877, 5765, 3598, 6260, 6630, 3961, 5509, 2736, 5159, 4748, 3577, 1225, 2059, 4861, 4498, 6626, 3424, 586, 2370, 5231, 5661, 1622, 1788, 1272, 1337, 5724, 6221, 3189, 2262, 5118, 2327, 36, 3536, 6743, 3111, 119, 6313, 2350, 3812, 2215, 3957, 6606, 3404, 2096, 4841, 6485, 1205, 230, 660, 5616, 4904, 2079, 6893, 2583, 5246, 5092, 1481, 3146, 3516, 3453, 1194, 6651, 3900, 2612, 5587, 6082, 4545, 1317, 4115, 6981, 5211, 5641, 4953, 4400, 637, 3795, 2887, 1497, 5084, 2741, 2254, 3015, 5342, 4103, 6581, 1244, 271, 4046, 3629, 5657, 2192, 1839, 1993, 3107, 4787, 6240, 2653, 3941, 2203, 733, 6169, 2080, 2595, 676, 3384, 1643, 6186, 1213, 3039, 461, 5944, 1907, 932, 5417, 3486, 6684, 524, 6954, 5381, 2444, 2917, 1792, 2852, 1287, 965, 436, 4601, 123, 5155, 3982, 1815, 5505, 2940, 4197, 4894, 5786, 2556, 2106, 2805, 3078, 4247, 1415, 5905, 2239, 1803, 5143, 135, 5840, 3097, 565, 4928, 2405, 3644, 3214, 6503, 3351, 924, 3185, 477, 4705, 532, 498, 861, 4586, 2517, 1291, 4093, 2844, 4587, 3242, 2453, 6806, 2516, 5379, 6105, 4138, 3307, 3887, 5400, 476, 533, 6739, 6693, 6369, 4929, 1678, 6017, 3700, 708, 3350, 358, 6851, 6781, 421, 2392, 83, 837, 4303, 1101, 564, 4753, 3203, 4196, 2557, 5338, 2107, 6144, 3346, 6514, 3716, 5011, 95, 3595, 6282, 3080, 5154, 3829, 6955, 1639, 4591, 3254, 6543, 3311, 6113, 3038, 4207, 6390, 4657, 460, 5416, 933, 3487, 1510, 2828, 1357, 2594, 5601, 677, 1642, 4010, 5178, 1992, 56, 2347, 6304, 4769, 1091, 4293, 6241, 6611, 5197, 948, 5343, 6996, 765, 1750, 2890, 3628, 2469, 6703, 4694, 3151, 1880, 2255, 6646, 2869, 773, 323, 5640, 4952, 4401, 1603, 4051, 5569, 1879, 3844, 2306, 6345, 3147, 4728, 6200, 2613, 5586, 5752, 3686, 1341, 6191, 661, 2428, 5617, 6938, 3540, 6742, 1087, 118, 5494, 40, 3813, 2214, 5928, 1438, 6257, 6220, 6670, 2633, 2263, 2776, 5119, 2326, 6559, 4134, 6109, 3976, 5908, 6627, 3425, 587, 3075, 6762, 3130, 138, 60, 2721, 3219, 1674, 3649, 6918, 2058, 354, 6261, 3960, 76, 4749, 4899, 1398, 1662, 207, 1727, 6518, 4525, 6148, 1459, 3034, 3521, 529, 3171, 483, 3872, 6959, 5676, 4572, 1770, 6758, 552, 1137, 4335, 3809, 801, 5461, 944, 1971, 417, 1422, 1072, 5898, 6867, 2577, 5318, 2127, 3366, 6021, 2961, 3673, 2062, 2598, 4362, 4732, 1530, 3018, 1475, 5965, 6099, 293, 6133, 6830, 6975, 3274, 1526, 513, 6719, 4724, 6349, 3848, 1199, 1463, 6430, 2473, 2189, 817, 5532, 5162, 5498, 114, 1571, 4289, 3409, 401, 2648, 5027, 3720, 2832, 682, 6871, 2074, 4909, 6467, 397, 2977, 5169, 2356, 5493, 1829, 4282, 5885, 6179, 2993, 723, 5305, 2585, 1653, 6196, 5997, 6342, 2751, 2301, 10, 1891, 5581, 6207, 5978, 1192, 1468, 4390, 5352, 6987, 3286, 6084, 324, 631, 3793, 261, 2028, 5217, 5647, 2182, 2747, 3855, 4739, 3443, 1184, 6211, 2602, 1307, 4555, 4806, 5201, 4294, 5485, 3947, 1079, 6616, 1429, 1700, 3678, 220, 6883, 5606, 5411, 5041, 6682, 488, 3480, 522, 1844, 2291, 6401, 2012, 6952, 5692, 2507, 1281, 6114, 3438, 4607, 3068, 3592, 963, 2383, 1540, 4312, 6905, 1669, 3341, 2803, 6513, 5295, 5450, 975, 6786, 4611, 830, 3992, 5145, 4187, 6440, 2116, 6505, 2815, 4492, 1444, 4646, 2792, 5407, 534, 1501, 4353, 6694, 1782, 3245, 6552, 5309, 3727, 2835, 6175, 390, 3232, 6899, 2423, 6933, 6319, 543, 5470, 955, 1063, 5923, 282, 778, 2531, 6821, 4959, 6964, 2474, 2024, 1258, 3265, 797, 2927, 5562, 847, 5098, 4723, 4373, 1171, 451, 3009, 4236, 2177, 5718, 6564, 6071, 2462, 2198, 1167, 502, 851, 5124, 1921, 4220, 693, 6499, 3361, 6163, 3731, 2435, 6026, 6476, 5489, 1560, 410, 5036, 4963, 5221, 1798, 607, 1327, 312, 4575, 3199, 6231, 892, 938, 2767, 1848, 6724, 3526, 3176, 1665, 3208, 200, 2419, 5626, 5333, 5299, 4522, 4172, 1370, 3967, 6266, 1059, 3434, 3121, 980, 71, 3988, 4888, 216, 1389, 646, 1673, 353, 4534, 88, 2376, 996, 6335, 611, 2458, 6948, 5372, 5688, 5722, 4563, 4133, 304, 1331, 3926, 2264, 6227, 3475, 6698, 492, 3863, 2771, 3927, 885, 6226, 186, 1449, 3474, 6363, 539, 3862, 4077, 5236, 2459, 5666, 4974, 5373, 4098, 4132, 1330, 997, 2377, 5518, 3835, 5631, 4889, 217, 1222, 647, 1388, 1672, 352, 6158, 4165, 5774, 2224, 1058, 3435, 1664, 4935, 5762, 714, 3462, 3198, 3931, 2766, 3874, 1849, 5670, 606, 1326, 4574, 4299, 4276, 5467, 942, 368, 6162, 2822, 2121, 2967, 3675, 4734, 915, 4671, 5349, 6836, 2875, 2930, 3622, 780, 2033, 2199, 846, 5563, 1873, 5099, 4722, 145, 1170, 5975, 1035, 4237, 903, 5426, 3321, 329, 3771, 2160, 2475, 2025, 3634, 1609, 6318, 542, 1824, 5021, 5758, 684, 3663, 3399, 6461, 3244, 3614, 2906, 6103, 309, 3751, 4094, 2843, 1296, 759, 2510, 3182, 3028, 866, 5543, 1500, 1150, 6695, 3213, 2052, 2547, 5282, 1941, 4610, 132, 4305, 6768, 5144, 6904, 4939, 5781, 6007, 3205, 1238, 6457, 3655, 1668, 4190, 4485, 3340, 1687, 6142, 2802, 3710, 2101, 1404, 1054, 3069, 2382, 2697, 3086, 124, 2910, 3602, 4597, 1795, 6050, 2443, 4981, 5739, 2506, 6545, 3747, 935, 1900, 4201, 4651, 3481, 6729, 5312, 2087, 5742, 2984, 4153, 364, 6494, 3679, 1644, 3229, 6882, 2592, 108, 3550, 6752, 2654, 5191, 5938, 6139, 333, 6093, 6569, 4554, 6990, 5345, 2480, 2195, 5200, 3784, 1243, 1869, 3854, 3157, 3442, 919, 5353, 1740, 325, 4407, 3792, 2880, 2029, 2479, 2183, 6969, 3511, 2750, 2300, 11, 3907, 1890, 3004, 3454, 4391, 3680, 2992, 722, 6528, 5304, 5241, 4000, 3395, 46, 3815, 1081, 3546, 4283, 6314, 2642, 5187, 2143, 6100, 3752, 6550, 6045, 4582, 6946, 5669, 5813, 1153, 6696, 3928, 1915, 5405, 189, 4214, 2817, 3705, 1692, 1368, 4869, 2544, 6911, 3640, 648, 5147, 1104, 4306, 3569, 4756, 4243, 1041, 6784, 1411, 2102, 4486, 6141, 3206, 4469, 5782, 577, 4310, 127, 1112, 3986, 824, 2381, 1407, 432, 2856, 3314, 2010, 5385, 2913, 609, 6403, 3251, 1846, 5556, 5106, 1145, 3178, 3482, 170, 520, 4202, 5413, 5254, 2591, 4916, 6182, 6478, 3380, 4015, 1352, 5741, 1581, 4629, 5038, 2207, 53, 6751, 2895, 1240, 5203, 5716, 4804, 2179, 4557, 760, 1885, 1493, 4691, 3857, 2745, 5080, 5215, 2180, 5645, 6439, 1743, 326, 1313, 2495, 4812, 6655, 4668, 3904, 2246, 2753, 5096, 1485, 3512, 5242, 6897, 4845, 2092, 5757, 5307, 2991, 3729, 2211, 3400, 1597, 3545, 6317, 1128, 3816, 2289, 32, 490, 3532, 6730, 6225, 3027, 4648, 185, 5409, 2636, 1919, 886, 4561, 1333, 5235, 2909, 6767, 1558, 994, 2661, 3420, 3070, 2548, 5777, 1671, 2698, 6264, 4609, 5448, 1958, 5018, 2227, 4520, 347, 5761, 5274, 5624, 2948, 652, 6376, 3898, 6399, 5736, 6819, 310, 1775, 4062, 1630, 4961, 1974, 941, 1427, 6618, 1562, 107, 5171, 4449, 3676, 5608, 6927, 691, 6161, 3733, 6531, 4222, 1020, 5960, 4672, 445, 1923, 1889, 5599, 2319, 5126, 150, 3508, 6970, 783, 6073, 2899, 6566, 2876, 6136, 900, 5425, 6659, 1036, 6209, 146, 1489, 1173, 5560, 795, 6435, 6966, 5649, 2163, 2499, 6120, 2860, 3772, 5921, 5472, 1962, 2708, 812, 111, 4326, 1574, 541, 5864, 2421, 392, 6198, 2837, 1348, 2134, 2420, 2973, 3231, 239, 6033, 6526, 6176, 1349, 4632, 405, 956, 5536, 3118, 1125, 4777, 5865, 794, 2924, 2532, 6822, 6121, 2861, 3773, 6571, 5074, 1467, 1037, 4235, 5832, 1172, 5561, 6072, 1758, 1308, 6834, 4809, 2524, 4223, 4389, 917, 1922, 2318, 1534, 3509, 4736, 385, 2436, 2089, 6863, 2123, 6160, 1076, 5873, 1099, 4331, 805, 5520, 6818, 3319, 1324, 311, 254, 6727, 487, 1148, 3175, 2621, 192, 6662, 3030, 4521, 346, 1689, 4872, 5275, 1236, 6009, 3821, 2733, 983, 3572, 6265, 595, 5019, 4167, 1735, 4022, 4472, 645, 4188, 4921, 5633, 5849, 6336, 1109, 2725, 3837, 3972, 6623, 4833, 5664, 1627, 2772, 868, 3533, 6731, 3476, 5408, 2210, 409, 3051, 1596, 5869, 1129, 3114, 44, 235, 1200, 3397, 1650, 6879, 6480, 370, 1715, 720, 3006, 6654, 4393, 3456, 2617, 1938, 3905, 5078, 3840, 6711, 2181, 4405, 4055, 1742, 6087, 4110, 1312, 6984, 2251, 2601, 4385, 6707, 1538, 6357, 1492, 4690, 3786, 6584, 624, 1611, 2197, 2528, 6838, 6992, 5347, 3339, 331, 4106, 4556, 6245, 4278, 3047, 6615, 3417, 2656, 2343, 3102, 3552, 5255, 5605, 2969, 673, 4014, 1703, 3694, 2986, 6496, 1847, 171, 5804, 6394, 5412, 2787, 4080, 1778, 2154, 4983, 2011, 2441, 6951, 4595, 258, 3084, 1543, 2695, 3968, 2380, 433, 5916, 4604, 2553, 1685, 3712, 6510, 3207, 6455, 3657, 5629, 2416, 1806, 5516, 68, 2683, 1105, 4307, 130, 1555, 5845, 4612, 5453, 2396, 1693, 4491, 1369, 4868, 5280, 2400, 649, 6013, 537, 864, 1914, 1447, 6678, 3180, 5957, 5687, 2841, 4096, 3753, 6551, 1781, 4583, 4429, 2904, 3616, 6947, 2457, 5238, 496, 3164, 2630, 6389, 6673, 2519, 3758, 1620, 245, 1270, 5233, 2688, 3830, 4249, 5008, 1362, 707, 4863, 5634, 212, 6018, 642, 3125, 6777, 2364, 75, 2221, 438, 2108, 2558, 1724, 3349, 1661, 4033, 5272, 3172, 6665, 6235, 896, 1909, 2626, 316, 746, 1773, 4822, 6059, 603, 5931, 4273, 5177, 2718, 1134, 101, 2061, 228, 2962, 1358, 6864, 2574, 2124, 910, 1026, 5966, 1499, 1533, 4418, 785, 2036, 6976, 2523, 3762, 290, 6560, 3298, 4398, 4232, 5073, 906, 1933, 2309, 3518, 5835, 4377, 6599, 2923, 6576, 286, 1749, 2165, 5474, 1067, 4265, 402, 1088, 5862, 1572, 5161, 6034, 3236, 6937, 5618, 2427, 2132, 2831, 3723, 6521, 681, 3689, 6106, 3304, 1293, 3754, 4838, 2145, 5395, 3241, 2903, 619, 38, 863, 2283, 1505, 5815, 3168, 160, 4212, 1010, 2811, 3353, 4183, 6014, 5268, 6917, 5638, 3979, 971, 80, 2391, 5004, 6278, 1378, 3345, 2807, 6844, 5291, 6901, 5784, 208, 2942, 79, 2692, 571, 3129, 1114, 5911, 1051, 6794, 5442, 96, 967, 2153, 6813, 6110, 1790, 3257, 2016, 6686, 5803, 3892, 5045, 1006, 1456, 3191, 4654, 463, 674, 6184, 1641, 1211, 6887, 5602, 4910, 6868, 1354, 3693, 3943, 5897, 6242, 6612, 1092, 3555, 1568, 5655, 789, 1246, 273, 2939, 6429, 1303, 1753, 4802, 2485, 4678, 6215, 4228, 1883, 5069, 2256, 5439, 3914, 2313, 5086, 859, 4697, 6350, 4052, 1250, 5643, 2169, 5356, 2539, 4814, 3778, 1745, 3282, 320, 2610, 2240, 3451, 4394, 6653, 1196, 459, 1483, 6346, 5839, 2755, 5614, 5244, 232, 6038, 1657, 398, 662, 6468, 2997, 4140, 3685, 6487, 3406, 1591, 5881, 5478, 2647, 4286, 6741, 6311, 6605, 4638, 6255, 4268, 5880, 1969, 5496, 1986, 819, 3542, 1085, 6740, 4907, 6890, 4004, 399, 3391, 2996, 3684, 4141, 2611, 3903, 1894, 3000, 6652, 5992, 3846, 634, 2884, 6594, 1251, 4950, 5642, 2538, 4815, 6081, 4383, 6214, 5068, 5592, 2607, 5087, 858, 4696, 1494, 6078, 4045, 2892, 4550, 4803, 5341, 5195, 6243, 1586, 5879, 4442, 3387, 2596, 5253, 2579, 5746, 4854, 4340, 5802, 1512, 874, 5551, 5101, 931, 2781, 5044, 4205, 5947, 4655, 3190, 2152, 6812, 4086, 2851, 1284, 6111, 6404, 3606, 4593, 5678, 5382, 2369, 989, 2739, 5506, 3578, 6280, 570, 5855, 4747, 1115, 435, 4602, 1400, 3597, 1050, 2386, 6146, 4481, 1379, 2806, 4878, 2410, 5785, 209, 4194, 2943, 136, 1103, 3094, 5843, 5510, 2685, 3997, 3978, 2390, 970, 589, 6783, 1046, 1416, 5906, 423, 4182, 5793, 6916, 5639, 5117, 1154, 4643, 3186, 5951, 474, 1441, 6384, 1912, 1338, 3305, 6557, 2847, 6804, 5394, 3240, 4585, 1787, 2902, 6412, 4458, 395, 4008, 5249, 2563, 680, 1965, 4321, 1089, 4771, 5530, 1820, 2471, 6961, 6598, 792, 2922, 6577, 2867, 4819, 1031, 1898, 1932, 1877, 5567, 4726, 511, 3149, 141, 4419, 6424, 6977, 2488, 2522, 291, 6561, 6131, 1924, 1027, 4225, 1477, 4675, 5988, 1162, 1861, 5121, 2060, 3221, 229, 3671, 679, 696, 6536, 2125, 415, 5176, 1836, 803, 1565, 1135, 100, 4337, 4120, 747, 1288, 4570, 5731, 4989, 4065, 2918, 6408, 4659, 6234, 1908, 2627, 2109, 3718, 340, 4177, 655, 1660, 5623, 4931, 3574, 2735, 1363, 4531, 706, 1733, 4862, 5265, 1226, 62, 3562, 6625, 3427, 5009, 5459, 1949, 2148, 5377, 5727, 1334, 4136, 4423, 4073, 5232, 5398, 6367, 1158, 3165, 6737, 5818, 1508, 2324, 3923, 3889, 6672];
1845     // struct to store a stake's token, owner, and earning values
1846     struct Stake {
1847         uint24 tokenId;
1848         uint48 timestamp;
1849         address owner;
1850     }
1851     event TransferReceived(address _from, uint _amount);
1852     event NFTStaked(address owner, uint256 tokenId, uint256 value);
1853     event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
1854     event Claimed(address owner, uint256 amount);
1855     event TransferSent(address _from, address _destAddr, uint _amount);
1856     // reference to the Block NFT contract
1857     ERC721Enumerable nft;
1858     IERC20 token;
1859     address private constant nftcontractaddress = 0xBfcE321046aaf5879c74cc4555Db8fd9629fde92;
1860     // maps tokenId to stake
1861     mapping(uint256 => Stake) public vault; 
1862 
1863     constructor(ERC721Enumerable _nft, IERC20 _token) { 
1864         contractowner = msg.sender;
1865         nft = _nft;
1866         token = _token;
1867     }
1868     receive() payable external {
1869         erc20balance += msg.value;
1870         emit TransferReceived(msg.sender, msg.value);
1871     }  
1872     function stake(uint256[] calldata tokenIds) external {
1873         uint256 tokenId;
1874         totalStaked += tokenIds.length;
1875         for (uint i = 0; i < tokenIds.length; i++) {
1876             tokenId = tokenIds[i];
1877             require(nft.ownerOf(tokenId) == msg.sender, "not your token");
1878             require(vault[tokenId].tokenId == 0, 'already staked');
1879 
1880             nft.transferFrom(msg.sender, address(this), tokenId);
1881             emit NFTStaked(msg.sender, tokenId, block.timestamp);
1882 
1883             vault[tokenId] = Stake({
1884                 owner: msg.sender,
1885                 tokenId: uint24(tokenId),
1886                 timestamp: uint48(block.timestamp)
1887             });
1888         }
1889     }
1890 
1891     function _unstakeMany(address account, uint256[] calldata tokenIds) internal {
1892         uint256 tokenId;
1893         totalStaked -= tokenIds.length;
1894         for (uint i = 0; i < tokenIds.length; i++) {
1895             tokenId = tokenIds[i];
1896             Stake memory staked = vault[tokenId];
1897             require(staked.owner == msg.sender, "not an owner");
1898 
1899             delete vault[tokenId];
1900             emit NFTUnstaked(account, tokenId, block.timestamp);
1901             nft.transferFrom(address(this), account, tokenId);
1902         }
1903     }
1904 
1905     function claim(uint256[] calldata tokenIds) external {
1906         _claim(msg.sender, tokenIds, false);
1907     }
1908 
1909     function claimForAddress(address account, uint256[] calldata tokenIds) external {
1910         _claim(account, tokenIds, false);
1911     }
1912 
1913     function unstake(uint256[] calldata tokenIds) external {
1914         _claim(msg.sender, tokenIds, true);
1915     }
1916 
1917     function _zonerewards(uint256 _tokenId) internal view returns(uint256){
1918         for(uint i=0; i<2000; i++){
1919             if (zone2[i] == _tokenId) {
1920                 return zone2reward;
1921             }else if(zone3[i] == _tokenId){
1922                 return zone3reward;
1923             }else if(i<1000){
1924                 if (zone4[i] == _tokenId){
1925                     return zone4reward;
1926                 }
1927             }
1928         }
1929         return zone1reward;
1930     }
1931     function _billboardrewards(uint256 _tokenId) internal view returns(uint256){
1932         for(uint i=0; i<large.length; i++){
1933             if(large[i] == _tokenId){
1934                 return largereward;
1935             }
1936         }
1937         for(uint i=0; i<small.length; i++){
1938             if(small[i] == _tokenId){
1939                 return smallreward;
1940             }
1941         }
1942         return 0;
1943     }
1944     function _hightrafficrewards(uint256 _tokenId) internal view returns(uint256){
1945         for(uint i=0; i<hightraffic.length; i++){
1946             if(hightraffic[i] == _tokenId){
1947                 return hightrafficreward;
1948             }
1949         }
1950         return 0;
1951     }
1952     function _claim(address account, uint256[] calldata tokenIds, bool _unstake) internal {
1953         uint256 tokenId;
1954         uint256 earned = 0;
1955         uint256 zone;
1956         uint256 billboard;
1957         uint256 hightrafficr;
1958         for (uint i = 0; i < tokenIds.length; i++) {
1959             tokenId = tokenIds[i];
1960             Stake memory staked = vault[tokenId];
1961       
1962             require(staked.owner == account, "not an owner");
1963             uint256 stakedAt = staked.timestamp;
1964             zone = _zonerewards(tokenId);
1965             billboard = _billboardrewards(tokenId);
1966             hightrafficr= _hightrafficrewards(tokenId);
1967             if (tokenId<=3780) {
1968                 earned =((standardbase + (standardbase*zone/100) + (standardbase*billboard/100) + (standardbase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
1969             }else if (tokenId<=6160){
1970                 earned =((deluxebase + (deluxebase*zone/100) + (deluxebase*billboard/100) + (deluxebase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
1971             }else if (tokenId<=6860){
1972                 earned =((villabase + (villabase*zone/100) + (villabase*billboard/100) + (villabase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
1973             }else if (tokenId<=7000){
1974                 earned =((executivebase + (executivebase*zone/100) + (executivebase*billboard/100) + (executivebase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
1975             }
1976 
1977             vault[tokenId] = Stake({
1978                 owner: account,
1979                 tokenId: uint24(tokenId),
1980                 timestamp: uint48(block.timestamp)
1981             });
1982         }
1983         if (earned > 0) {
1984             token.transfer(account, earned);
1985         }
1986         if (_unstake) {
1987             _unstakeMany(account, tokenIds);
1988         }
1989         emit Claimed(account, earned);
1990     }
1991 
1992     function earningInfo(address account, uint256[] calldata tokenIds) external view returns (uint256[1] memory info) {
1993         uint256 tokenId;
1994         uint256 earned = 0;
1995         uint256 zone;
1996         uint256 billboard;
1997         uint256 hightrafficr;
1998         for (uint i = 0; i < tokenIds.length; i++) {
1999             tokenId = tokenIds[i];
2000             Stake memory staked = vault[tokenId];
2001             require(staked.owner == account, "not an owner");
2002             uint256 stakedAt = staked.timestamp;
2003             zone = _zonerewards(tokenId);
2004             billboard = _billboardrewards(tokenId);
2005             hightrafficr= _hightrafficrewards(tokenId);
2006             if (tokenId<=3780) {
2007                 earned =((standardbase + (standardbase*zone/100) + (standardbase*billboard/100) + (standardbase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
2008             }else if (tokenId<=6160){
2009                 earned =((deluxebase + (deluxebase*zone/100) + (deluxebase*billboard/100) + (deluxebase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
2010             }else if (tokenId<=6860){
2011                 earned =((villabase + (villabase*zone/100) + (villabase*billboard/100) + (villabase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
2012             }else if (tokenId<=7000){
2013                 earned =((executivebase + (executivebase*zone/100) + (executivebase*billboard/100) + (executivebase*hightrafficr/100))*(block.timestamp - stakedAt))/ 86400;
2014             }
2015 
2016         }
2017         if (earned > 0) {
2018             return [earned];
2019         }
2020     }
2021 
2022     function balanceOf(address account) public view returns (uint256) {
2023         uint256 balance = 0;
2024         uint256 supply = nft.totalSupply();
2025         for(uint i = 1; i <= supply; i++) {
2026             if (vault[i].owner == account) {
2027                 balance += 1;
2028             }
2029         }
2030         return balance;
2031     }
2032 
2033     function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {
2034 
2035         uint256 supply = nftcontract(nftcontractaddress).maxSupply();
2036         uint256[] memory tmp = new uint256[](supply);
2037 
2038         uint256 index = 0;
2039         for(uint tokenId = 1; tokenId <= supply; tokenId++) {
2040             if (vault[tokenId].owner == account) {
2041                 tmp[index] = vault[tokenId].tokenId;
2042                 index +=1;
2043             }
2044         }
2045 
2046         uint256[] memory tokens = new uint256[](index);
2047         for(uint i = 0; i < index; i++) {
2048             tokens[i] = tmp[i];
2049         }
2050 
2051         return tokens;
2052     }
2053     function ercbalance() public view returns (uint cbalance) {
2054         return token.balanceOf(address(this));
2055     }
2056     function withdraw(uint256 withrawamount) public {
2057         require(msg.sender == contractowner, "Only owner can withdraw funds"); 
2058         require(withrawamount <= erc20balance, "balance is low");
2059         token.transfer(msg.sender, withrawamount);
2060         erc20balance -= withrawamount;
2061         emit TransferSent(msg.sender, msg.sender, withrawamount);
2062     }
2063     function onERC721Received(
2064         address,
2065         address from,
2066         uint256,
2067         bytes calldata
2068     ) external pure override returns (bytes4) {
2069         require(from == address(0x0), "Cannot send nfts to Vault directly");
2070         return IERC721Receiver.onERC721Received.selector;
2071     }
2072   
2073 }