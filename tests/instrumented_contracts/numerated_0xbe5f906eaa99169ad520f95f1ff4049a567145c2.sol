1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Enumerable is IERC721 {
551     /**
552      * @dev Returns the total amount of tokens stored by the contract.
553      */
554     function totalSupply() external view returns (uint256);
555 
556     /**
557      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
558      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
559      */
560     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
561 
562     /**
563      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
564      * Use along with {totalSupply} to enumerate all tokens.
565      */
566     function tokenByIndex(uint256 index) external view returns (uint256);
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Interface of the ERC20 standard as defined in the EIP.
607  */
608 interface IERC20 {
609     /**
610      * @dev Emitted when `value` tokens are moved from one account (`from`) to
611      * another (`to`).
612      *
613      * Note that `value` may be zero.
614      */
615     event Transfer(address indexed from, address indexed to, uint256 value);
616 
617     /**
618      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
619      * a call to {approve}. `value` is the new allowance.
620      */
621     event Approval(address indexed owner, address indexed spender, uint256 value);
622 
623     /**
624      * @dev Returns the amount of tokens in existence.
625      */
626     function totalSupply() external view returns (uint256);
627 
628     /**
629      * @dev Returns the amount of tokens owned by `account`.
630      */
631     function balanceOf(address account) external view returns (uint256);
632 
633     /**
634      * @dev Moves `amount` tokens from the caller's account to `to`.
635      *
636      * Returns a boolean value indicating whether the operation succeeded.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transfer(address to, uint256 amount) external returns (bool);
641 
642     /**
643      * @dev Returns the remaining number of tokens that `spender` will be
644      * allowed to spend on behalf of `owner` through {transferFrom}. This is
645      * zero by default.
646      *
647      * This value changes when {approve} or {transferFrom} are called.
648      */
649     function allowance(address owner, address spender) external view returns (uint256);
650 
651     /**
652      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
653      *
654      * Returns a boolean value indicating whether the operation succeeded.
655      *
656      * IMPORTANT: Beware that changing an allowance with this method brings the risk
657      * that someone may use both the old and the new allowance by unfortunate
658      * transaction ordering. One possible solution to mitigate this race
659      * condition is to first reduce the spender's allowance to 0 and set the
660      * desired value afterwards:
661      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
662      *
663      * Emits an {Approval} event.
664      */
665     function approve(address spender, uint256 amount) external returns (bool);
666 
667     /**
668      * @dev Moves `amount` tokens from `from` to `to` using the
669      * allowance mechanism. `amount` is then deducted from the caller's
670      * allowance.
671      *
672      * Returns a boolean value indicating whether the operation succeeded.
673      *
674      * Emits a {Transfer} event.
675      */
676     function transferFrom(
677         address from,
678         address to,
679         uint256 amount
680     ) external returns (bool);
681 }
682 
683 // File: @openzeppelin/contracts/utils/Context.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Provides information about the current execution context, including the
692  * sender of the transaction and its data. While these are generally available
693  * via msg.sender and msg.data, they should not be accessed in such a direct
694  * manner, since when dealing with meta-transactions the account sending and
695  * paying for execution may not be the actual sender (as far as an application
696  * is concerned).
697  *
698  * This contract is only required for intermediate, library-like contracts.
699  */
700 abstract contract Context {
701     function _msgSender() internal view virtual returns (address) {
702         return msg.sender;
703     }
704 
705     function _msgData() internal view virtual returns (bytes calldata) {
706         return msg.data;
707     }
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
711 
712 
713 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 
719 
720 
721 
722 
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension, but not including the Enumerable extension, which is available separately as
727  * {ERC721Enumerable}.
728  */
729 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
753      */
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view virtual override returns (uint256) {
773         require(owner != address(0), "ERC721: address zero is not a valid owner");
774         return _balances[owner];
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         address owner = _owners[tokenId];
782         require(owner != address(0), "ERC721: invalid token ID");
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         _requireMinted(tokenId);
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overridden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return "";
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ERC721.ownerOf(tokenId);
824         require(to != owner, "ERC721: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721: approve caller is not token owner nor approved for all"
829         );
830 
831         _approve(to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         _requireMinted(tokenId);
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         _setApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         //solhint-disable-next-line max-line-length
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
867 
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, "");
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory data
890     ) public virtual override {
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
892         _safeTransfer(from, to, tokenId, data);
893     }
894 
895     /**
896      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
897      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
898      *
899      * `data` is additional data, it has no specified format and it is sent in call to `to`.
900      *
901      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
902      * implement alternative mechanisms to perform token transfer, such as signature-based.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeTransfer(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory data
918     ) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999 
1000         _afterTokenTransfer(address(0), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         address owner = ERC721.ownerOf(tokenId);
1015 
1016         _beforeTokenTransfer(owner, address(0), tokenId);
1017 
1018         // Clear approvals
1019         _approve(address(0), tokenId);
1020 
1021         _balances[owner] -= 1;
1022         delete _owners[tokenId];
1023 
1024         emit Transfer(owner, address(0), tokenId);
1025 
1026         _afterTokenTransfer(owner, address(0), tokenId);
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must be owned by `from`.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _transfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) internal virtual {
1045         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1046         require(to != address(0), "ERC721: transfer to the zero address");
1047 
1048         _beforeTokenTransfer(from, to, tokenId);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId);
1052 
1053         _balances[from] -= 1;
1054         _balances[to] += 1;
1055         _owners[tokenId] = to;
1056 
1057         emit Transfer(from, to, tokenId);
1058 
1059         _afterTokenTransfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `to` to operate on `tokenId`
1064      *
1065      * Emits an {Approval} event.
1066      */
1067     function _approve(address to, uint256 tokenId) internal virtual {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Approve `operator` to operate on all of `owner` tokens
1074      *
1075      * Emits an {ApprovalForAll} event.
1076      */
1077     function _setApprovalForAll(
1078         address owner,
1079         address operator,
1080         bool approved
1081     ) internal virtual {
1082         require(owner != operator, "ERC721: approve to caller");
1083         _operatorApprovals[owner][operator] = approved;
1084         emit ApprovalForAll(owner, operator, approved);
1085     }
1086 
1087     /**
1088      * @dev Reverts if the `tokenId` has not been minted yet.
1089      */
1090     function _requireMinted(uint256 tokenId) internal view virtual {
1091         require(_exists(tokenId), "ERC721: invalid token ID");
1092     }
1093 
1094     /**
1095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1096      * The call is not executed if the target address is not a contract.
1097      *
1098      * @param from address representing the previous owner of the given token ID
1099      * @param to target address that will receive the tokens
1100      * @param tokenId uint256 ID of the token to be transferred
1101      * @param data bytes optional data to send along with the call
1102      * @return bool whether the call correctly returned the expected magic value
1103      */
1104     function _checkOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory data
1109     ) private returns (bool) {
1110         if (to.isContract()) {
1111             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1112                 return retval == IERC721Receiver.onERC721Received.selector;
1113             } catch (bytes memory reason) {
1114                 if (reason.length == 0) {
1115                     revert("ERC721: transfer to non ERC721Receiver implementer");
1116                 } else {
1117                     /// @solidity memory-safe-assembly
1118                     assembly {
1119                         revert(add(32, reason), mload(reason))
1120                     }
1121                 }
1122             }
1123         } else {
1124             return true;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before any token transfer. This includes minting
1130      * and burning.
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1138      * - `from` and `to` are never both zero.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _beforeTokenTransfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Hook that is called after any transfer of tokens. This includes
1150      * minting and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - when `from` and `to` are both non-zero.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _afterTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 }
1165 
1166 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 
1175 /**
1176  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1177  * enumerability of all the token ids in the contract as well as all token ids owned by each
1178  * account.
1179  */
1180 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1181     // Mapping from owner to list of owned token IDs
1182     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1183 
1184     // Mapping from token ID to index of the owner tokens list
1185     mapping(uint256 => uint256) private _ownedTokensIndex;
1186 
1187     // Array with all token ids, used for enumeration
1188     uint256[] private _allTokens;
1189 
1190     // Mapping from token id to position in the allTokens array
1191     mapping(uint256 => uint256) private _allTokensIndex;
1192 
1193     /**
1194      * @dev See {IERC165-supportsInterface}.
1195      */
1196     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1197         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1202      */
1203     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1204         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1205         return _ownedTokens[owner][index];
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Enumerable-totalSupply}.
1210      */
1211     function totalSupply() public view virtual override returns (uint256) {
1212         return _allTokens.length;
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Enumerable-tokenByIndex}.
1217      */
1218     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1219         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1220         return _allTokens[index];
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before any token transfer. This includes minting
1225      * and burning.
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` will be minted for `to`.
1232      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1233      * - `from` cannot be the zero address.
1234      * - `to` cannot be the zero address.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _beforeTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual override {
1243         super._beforeTokenTransfer(from, to, tokenId);
1244 
1245         if (from == address(0)) {
1246             _addTokenToAllTokensEnumeration(tokenId);
1247         } else if (from != to) {
1248             _removeTokenFromOwnerEnumeration(from, tokenId);
1249         }
1250         if (to == address(0)) {
1251             _removeTokenFromAllTokensEnumeration(tokenId);
1252         } else if (to != from) {
1253             _addTokenToOwnerEnumeration(to, tokenId);
1254         }
1255     }
1256 
1257     /**
1258      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1259      * @param to address representing the new owner of the given token ID
1260      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1261      */
1262     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1263         uint256 length = ERC721.balanceOf(to);
1264         _ownedTokens[to][length] = tokenId;
1265         _ownedTokensIndex[tokenId] = length;
1266     }
1267 
1268     /**
1269      * @dev Private function to add a token to this extension's token tracking data structures.
1270      * @param tokenId uint256 ID of the token to be added to the tokens list
1271      */
1272     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1273         _allTokensIndex[tokenId] = _allTokens.length;
1274         _allTokens.push(tokenId);
1275     }
1276 
1277     /**
1278      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1279      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1280      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1281      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1282      * @param from address representing the previous owner of the given token ID
1283      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1284      */
1285     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1286         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1287         // then delete the last slot (swap and pop).
1288 
1289         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1290         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1291 
1292         // When the token to delete is the last token, the swap operation is unnecessary
1293         if (tokenIndex != lastTokenIndex) {
1294             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1295 
1296             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1297             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1298         }
1299 
1300         // This also deletes the contents at the last position of the array
1301         delete _ownedTokensIndex[tokenId];
1302         delete _ownedTokens[from][lastTokenIndex];
1303     }
1304 
1305     /**
1306      * @dev Private function to remove a token from this extension's token tracking data structures.
1307      * This has O(1) time complexity, but alters the order of the _allTokens array.
1308      * @param tokenId uint256 ID of the token to be removed from the tokens list
1309      */
1310     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1311         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1312         // then delete the last slot (swap and pop).
1313 
1314         uint256 lastTokenIndex = _allTokens.length - 1;
1315         uint256 tokenIndex = _allTokensIndex[tokenId];
1316 
1317         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1318         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1319         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1320         uint256 lastTokenId = _allTokens[lastTokenIndex];
1321 
1322         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1323         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1324 
1325         // This also deletes the contents at the last position of the array
1326         delete _allTokensIndex[tokenId];
1327         _allTokens.pop();
1328     }
1329 }
1330 
1331 // File: @openzeppelin/contracts/access/Ownable.sol
1332 
1333 
1334 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1355 
1356     /**
1357      * @dev Initializes the contract setting the deployer as the initial owner.
1358      */
1359     constructor() {
1360         _transferOwnership(_msgSender());
1361     }
1362 
1363     /**
1364      * @dev Throws if called by any account other than the owner.
1365      */
1366     modifier onlyOwner() {
1367         _checkOwner();
1368         _;
1369     }
1370 
1371     /**
1372      * @dev Returns the address of the current owner.
1373      */
1374     function owner() public view virtual returns (address) {
1375         return _owner;
1376     }
1377 
1378     /**
1379      * @dev Throws if the sender is not the owner.
1380      */
1381     function _checkOwner() internal view virtual {
1382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1383     }
1384 
1385     /**
1386      * @dev Leaves the contract without owner. It will not be possible to call
1387      * `onlyOwner` functions anymore. Can only be called by the current owner.
1388      *
1389      * NOTE: Renouncing ownership will leave the contract without an owner,
1390      * thereby removing any functionality that is only available to the owner.
1391      */
1392     function renounceOwnership() public virtual onlyOwner {
1393         _transferOwnership(address(0));
1394     }
1395 
1396     /**
1397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1398      * Can only be called by the current owner.
1399      */
1400     function transferOwnership(address newOwner) public virtual onlyOwner {
1401         require(newOwner != address(0), "Ownable: new owner is the zero address");
1402         _transferOwnership(newOwner);
1403     }
1404 
1405     /**
1406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1407      * Internal function without access restriction.
1408      */
1409     function _transferOwnership(address newOwner) internal virtual {
1410         address oldOwner = _owner;
1411         _owner = newOwner;
1412         emit OwnershipTransferred(oldOwner, newOwner);
1413     }
1414 }
1415 
1416 // File: FreeMint3.sol
1417 
1418 
1419 
1420 
1421 
1422 
1423 pragma solidity ^0.8.0;
1424 
1425 contract Collection is ERC721Enumerable, Ownable {
1426 
1427     struct TokenInfo {
1428         IERC20 paytoken;
1429         uint256 costvalue;
1430     }
1431 
1432     TokenInfo[] public AllowedCrypto;
1433     
1434     using Strings for uint256;
1435     string public baseURI;
1436     string public baseExtension = ".json";
1437     uint256 public cost = 0 ether;
1438     uint256 public maxSupply = 3333;
1439     uint256 public maxMintAmount = 3333;
1440     bool public paused = false;
1441 
1442     constructor() ERC721("The Pocket Hamsters", "POCKETHAMSTER") {}
1443 
1444     function addCurrency(
1445         IERC20 _paytoken,
1446         uint256 _costvalue
1447     ) public onlyOwner {
1448         AllowedCrypto.push(
1449             TokenInfo({
1450                 paytoken: _paytoken,
1451                 costvalue: _costvalue
1452             })
1453         );
1454     }
1455 
1456     function _baseURI() internal view virtual override returns (string memory) {
1457     return "ipfs://QmSFaiHASMDpQTugHAm9HoPSjTQ2r9F5S1pRqszcqBEcQr/";
1458 
1459     }
1460     
1461     function mint(address _to, uint256 _mintAmount) public payable {
1462             uint256 supply = totalSupply();
1463             require(!paused);
1464             require(_mintAmount > 0);
1465             require(_mintAmount <= maxMintAmount);
1466             require(supply + _mintAmount <= maxSupply);
1467             
1468             if (msg.sender != owner()) {
1469             require(msg.value == cost * _mintAmount, "Not enough balance to complete transaction.");
1470             }
1471             
1472             for (uint256 i = 1; i <= _mintAmount; i++) {
1473                 _safeMint(_to, supply + i);
1474             }
1475     }
1476 
1477 
1478     function mintpid(address _to, uint256 _mintAmount, uint256 _pid) public payable {
1479         TokenInfo storage tokens = AllowedCrypto[_pid];
1480         IERC20 paytoken;
1481         paytoken = tokens.paytoken;
1482         uint256 costval;
1483         costval = tokens.costvalue;
1484         uint256 supply = totalSupply();
1485         require(!paused);
1486         require(_mintAmount > 0);
1487         require(_mintAmount <= maxMintAmount);
1488         require(supply + _mintAmount <= maxSupply);
1489             
1490             for (uint256 i = 1; i <= _mintAmount; i++) {
1491                 require(paytoken.transferFrom(msg.sender, address(this), costval));
1492                 _safeMint(_to, supply + i);
1493             }
1494         }
1495 
1496         function walletOfOwner(address _owner)
1497         public
1498         view
1499         returns (uint256[] memory)
1500         {
1501             uint256 ownerTokenCount = balanceOf(_owner);
1502             uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1503             for (uint256 i; i < ownerTokenCount; i++) {
1504                 tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1505             }
1506             return tokenIds;
1507         }
1508     
1509         
1510         function tokenURI(uint256 tokenId)
1511         public
1512         view
1513         virtual
1514         override
1515         returns (string memory) {
1516             require(
1517                 _exists(tokenId),
1518                 "ERC721Metadata: URI query for nonexistent token"
1519                 );
1520                 
1521                 string memory currentBaseURI = _baseURI();
1522                 return
1523                 bytes(currentBaseURI).length > 0 
1524                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1525                 : "";
1526         }
1527         // only owner
1528         
1529         function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1530             maxMintAmount = _newmaxMintAmount;
1531         }
1532         
1533         function setBaseURI(string memory _newBaseURI) public onlyOwner() {
1534             baseURI = _newBaseURI;
1535         }
1536         
1537         function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
1538             baseExtension = _newBaseExtension;
1539         }
1540         
1541         function pause(bool _state) public onlyOwner() {
1542             paused = _state;
1543         }
1544 
1545         function getNFTCost(uint256 _pid) public view virtual returns(uint256) {
1546             TokenInfo storage tokens = AllowedCrypto[_pid];
1547             uint256 costval;
1548             costval = tokens.costvalue;
1549             return costval;
1550         }
1551 
1552         function getCryptotoken(uint256 _pid) public view virtual returns(IERC20) {
1553             TokenInfo storage tokens = AllowedCrypto[_pid];
1554             IERC20 paytoken;
1555             paytoken = tokens.paytoken;
1556             return paytoken;
1557         }
1558         
1559         function withdrawcustom(uint256 _pid) public payable onlyOwner() {
1560             TokenInfo storage tokens = AllowedCrypto[_pid];
1561             IERC20 paytoken;
1562             paytoken = tokens.paytoken;
1563             paytoken.transfer(msg.sender, paytoken.balanceOf(address(this)));
1564         }
1565         
1566         function withdraw() public payable onlyOwner() {
1567             require(payable(msg.sender).send(address(this).balance));
1568         }
1569 }