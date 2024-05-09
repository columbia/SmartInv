1 // SPDX-License-Identifier: MIT
2 //         _ .-') _     ('-.     _   .-')                _  .-')     ('-.     
3 //         ( (  OO) )   ( OO ).-.( '.( OO )_             ( \( -O )   ( OO ).-. 
4 //   ,-.-') \     .'_   / . --. / ,--.   ,--.),--. ,--.   ,------.   / . --. / 
5 //   |  |OO),`'--..._)  | \-.  \  |   `.'   | |  | |  |   |   /`. '  | \-.  \  
6 //   |  |  \|  |  \  '.-'-'  |  | |         | |  | | .-') |  /  | |.-'-'  |  | 
7 //   |  |(_/|  |   ' | \| |_.'  | |  |'.'|  | |  |_|( OO )|  |_.' | \| |_.'  | 
8 //  ,|  |_.'|  |   / :  |  .-.  | |  |   |  | |  | | `-' /|  .  '.'  |  .-.  | 
9 // (_|  |   |  '--'  /  |  | |  | |  |   |  |('  '-'(_.-' |  |\  \   |  | |  | 
10 //   `--'   `-------'   `--' `--' `--'   `--'  `-----'    `--' '--'  `--' `--'
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Emitted when `value` tokens are moved from one account (`from`) to
20      * another (`to`).
21      *
22      * Note that `value` may be zero.
23      */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     /**
27      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
28      * a call to {approve}. `value` is the new allowance.
29      */
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 // File: @openzeppelin/contracts/utils/Strings.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev String operations.
101  */
102 library Strings {
103     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
104     uint8 private constant _ADDRESS_LENGTH = 20;
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
108      */
109     function toString(uint256 value) internal pure returns (string memory) {
110         // Inspired by OraclizeAPI's implementation - MIT licence
111         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
112 
113         if (value == 0) {
114             return "0";
115         }
116         uint256 temp = value;
117         uint256 digits;
118         while (temp != 0) {
119             digits++;
120             temp /= 10;
121         }
122         bytes memory buffer = new bytes(digits);
123         while (value != 0) {
124             digits -= 1;
125             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
126             value /= 10;
127         }
128         return string(buffer);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
133      */
134     function toHexString(uint256 value) internal pure returns (string memory) {
135         if (value == 0) {
136             return "0x00";
137         }
138         uint256 temp = value;
139         uint256 length = 0;
140         while (temp != 0) {
141             length++;
142             temp >>= 8;
143         }
144         return toHexString(value, length);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
149      */
150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
151         bytes memory buffer = new bytes(2 * length + 2);
152         buffer[0] = "0";
153         buffer[1] = "x";
154         for (uint256 i = 2 * length + 1; i > 1; --i) {
155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
156             value >>= 4;
157         }
158         require(value == 0, "Strings: hex length insufficient");
159         return string(buffer);
160     }
161 
162     /**
163      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
164      */
165     function toHexString(address addr) internal pure returns (string memory) {
166         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Address.sol
171 
172 
173 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
174 
175 pragma solidity ^0.8.1;
176 
177 /**
178  * @dev Collection of functions related to the address type
179  */
180 library Address {
181     /**
182      * @dev Returns true if `account` is a contract.
183      *
184      * [IMPORTANT]
185      * ====
186      * It is unsafe to assume that an address for which this function returns
187      * false is an externally-owned account (EOA) and not a contract.
188      *
189      * Among others, `isContract` will return false for the following
190      * types of addresses:
191      *
192      *  - an externally-owned account
193      *  - a contract in construction
194      *  - an address where a contract will be created
195      *  - an address where a contract lived, but was destroyed
196      * ====
197      *
198      * [IMPORTANT]
199      * ====
200      * You shouldn't rely on `isContract` to protect against flash loan attacks!
201      *
202      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
203      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
204      * constructor.
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize/address.code.length, which returns 0
209         // for contracts in construction, since the code is only stored at the end
210         // of the constructor execution.
211 
212         return account.code.length > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionCall(target, data, "Address: low-level call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
262      * `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(address(this).balance >= value, "Address: insufficient balance for call");
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383                 /// @solidity memory-safe-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC165 standard, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-165[EIP].
435  *
436  * Implementers can declare support of contract interfaces, which can then be
437  * queried by others ({ERC165Checker}).
438  *
439  * For an implementation, see {ERC165}.
440  */
441 interface IERC165 {
442     /**
443      * @dev Returns true if this contract implements the interface defined by
444      * `interfaceId`. See the corresponding
445      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
446      * to learn more about how these ids are created.
447      *
448      * This function call must use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Implementation of the {IERC165} interface.
463  *
464  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
465  * for the additional interface id that will be supported. For example:
466  *
467  * ```solidity
468  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
470  * }
471  * ```
472  *
473  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
474  */
475 abstract contract ERC165 is IERC165 {
476     /**
477      * @dev See {IERC165-supportsInterface}.
478      */
479     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480         return interfaceId == type(IERC165).interfaceId;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Required interface of an ERC721 compliant contract.
494  */
495 interface IERC721 is IERC165 {
496     /**
497      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500 
501     /**
502      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
503      */
504     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
508      */
509     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
510 
511     /**
512      * @dev Returns the number of tokens in ``owner``'s account.
513      */
514     function balanceOf(address owner) external view returns (uint256 balance);
515 
516     /**
517      * @dev Returns the owner of the `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function ownerOf(uint256 tokenId) external view returns (address owner);
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId,
542         bytes calldata data
543     ) external;
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
547      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Transfers `tokenId` token from `from` to `to`.
567      *
568      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      *
577      * Emits a {Transfer} event.
578      */
579     function transferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
587      * The approval is cleared when the token is transferred.
588      *
589      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
590      *
591      * Requirements:
592      *
593      * - The caller must own the token or be an approved operator.
594      * - `tokenId` must exist.
595      *
596      * Emits an {Approval} event.
597      */
598     function approve(address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Approve or remove `operator` as an operator for the caller.
602      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
603      *
604      * Requirements:
605      *
606      * - The `operator` cannot be the caller.
607      *
608      * Emits an {ApprovalForAll} event.
609      */
610     function setApprovalForAll(address operator, bool _approved) external;
611 
612     /**
613      * @dev Returns the account approved for `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function getApproved(uint256 tokenId) external view returns (address operator);
620 
621     /**
622      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
623      *
624      * See {setApprovalForAll}
625      */
626     function isApprovedForAll(address owner, address operator) external view returns (bool);
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
630 
631 
632 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 interface IERC721Enumerable is IERC721 {
642     /**
643      * @dev Returns the total amount of tokens stored by the contract.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
649      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
650      */
651     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
655      * Use along with {totalSupply} to enumerate all tokens.
656      */
657     function tokenByIndex(uint256 index) external view returns (uint256);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 // File: @openzeppelin/contracts/utils/Context.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @dev Provides information about the current execution context, including the
698  * sender of the transaction and its data. While these are generally available
699  * via msg.sender and msg.data, they should not be accessed in such a direct
700  * manner, since when dealing with meta-transactions the account sending and
701  * paying for execution may not be the actual sender (as far as an application
702  * is concerned).
703  *
704  * This contract is only required for intermediate, library-like contracts.
705  */
706 abstract contract Context {
707     function _msgSender() internal view virtual returns (address) {
708         return msg.sender;
709     }
710 
711     function _msgData() internal view virtual returns (bytes calldata) {
712         return msg.data;
713     }
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
717 
718 
719 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 
725 
726 
727 
728 
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension, but not including the Enumerable extension, which is available separately as
733  * {ERC721Enumerable}.
734  */
735 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to owner address
746     mapping(uint256 => address) private _owners;
747 
748     // Mapping owner address to token count
749     mapping(address => uint256) private _balances;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     /**
758      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view virtual override returns (uint256) {
779         require(owner != address(0), "ERC721: address zero is not a valid owner");
780         return _balances[owner];
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _owners[tokenId];
788         require(owner != address(0), "ERC721: invalid token ID");
789         return owner;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-tokenURI}.
808      */
809     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
810         _requireMinted(tokenId);
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overridden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not token owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         _requireMinted(tokenId);
845 
846         return _tokenApprovals[tokenId];
847     }
848 
849     /**
850      * @dev See {IERC721-setApprovalForAll}.
851      */
852     function setApprovalForAll(address operator, bool approved) public virtual override {
853         _setApprovalForAll(_msgSender(), operator, approved);
854     }
855 
856     /**
857      * @dev See {IERC721-isApprovedForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev See {IERC721-transferFrom}.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         //solhint-disable-next-line max-line-length
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
873 
874         _transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         safeTransferFrom(from, to, tokenId, "");
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory data
896     ) public virtual override {
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
898         _safeTransfer(from, to, tokenId, data);
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * `data` is additional data, it has no specified format and it is sent in call to `to`.
906      *
907      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
908      * implement alternative mechanisms to perform token transfer, such as signature-based.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeTransfer(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory data
924     ) internal virtual {
925         _transfer(from, to, tokenId);
926         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
935      * and stop existing when they are burned (`_burn`).
936      */
937     function _exists(uint256 tokenId) internal view virtual returns (bool) {
938         return _owners[tokenId] != address(0);
939     }
940 
941     /**
942      * @dev Returns whether `spender` is allowed to manage `tokenId`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
951     }
952 
953     /**
954      * @dev Safely mints `tokenId` and transfers it to `to`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeMint(address to, uint256 tokenId) internal virtual {
964         _safeMint(to, tokenId, "");
965     }
966 
967     /**
968      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
970      */
971     function _safeMint(
972         address to,
973         uint256 tokenId,
974         bytes memory data
975     ) internal virtual {
976         _mint(to, tokenId);
977         require(
978             _checkOnERC721Received(address(0), to, tokenId, data),
979             "ERC721: transfer to non ERC721Receiver implementer"
980         );
981     }
982 
983     /**
984      * @dev Mints `tokenId` and transfers it to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - `to` cannot be the zero address.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mint(address to, uint256 tokenId) internal virtual {
996         require(to != address(0), "ERC721: mint to the zero address");
997         require(!_exists(tokenId), "ERC721: token already minted");
998 
999         _beforeTokenTransfer(address(0), to, tokenId);
1000 
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(address(0), to, tokenId);
1005 
1006         _afterTokenTransfer(address(0), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Destroys `tokenId`.
1011      * The approval is cleared when the token is burned.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _burn(uint256 tokenId) internal virtual {
1020         address owner = ERC721.ownerOf(tokenId);
1021 
1022         _beforeTokenTransfer(owner, address(0), tokenId);
1023 
1024         // Clear approvals
1025         _approve(address(0), tokenId);
1026 
1027         _balances[owner] -= 1;
1028         delete _owners[tokenId];
1029 
1030         emit Transfer(owner, address(0), tokenId);
1031 
1032         _afterTokenTransfer(owner, address(0), tokenId);
1033     }
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1038      *
1039      * Requirements:
1040      *
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must be owned by `from`.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _transfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {
1051         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1052         require(to != address(0), "ERC721: transfer to the zero address");
1053 
1054         _beforeTokenTransfer(from, to, tokenId);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId);
1058 
1059         _balances[from] -= 1;
1060         _balances[to] += 1;
1061         _owners[tokenId] = to;
1062 
1063         emit Transfer(from, to, tokenId);
1064 
1065         _afterTokenTransfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits an {Approval} event.
1072      */
1073     function _approve(address to, uint256 tokenId) internal virtual {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `operator` to operate on all of `owner` tokens
1080      *
1081      * Emits an {ApprovalForAll} event.
1082      */
1083     function _setApprovalForAll(
1084         address owner,
1085         address operator,
1086         bool approved
1087     ) internal virtual {
1088         require(owner != operator, "ERC721: approve to caller");
1089         _operatorApprovals[owner][operator] = approved;
1090         emit ApprovalForAll(owner, operator, approved);
1091     }
1092 
1093     /**
1094      * @dev Reverts if the `tokenId` has not been minted yet.
1095      */
1096     function _requireMinted(uint256 tokenId) internal view virtual {
1097         require(_exists(tokenId), "ERC721: invalid token ID");
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102      * The call is not executed if the target address is not a contract.
1103      *
1104      * @param from address representing the previous owner of the given token ID
1105      * @param to target address that will receive the tokens
1106      * @param tokenId uint256 ID of the token to be transferred
1107      * @param data bytes optional data to send along with the call
1108      * @return bool whether the call correctly returned the expected magic value
1109      */
1110     function _checkOnERC721Received(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory data
1115     ) private returns (bool) {
1116         if (to.isContract()) {
1117             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1118                 return retval == IERC721Receiver.onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert("ERC721: transfer to non ERC721Receiver implementer");
1122                 } else {
1123                     /// @solidity memory-safe-assembly
1124                     assembly {
1125                         revert(add(32, reason), mload(reason))
1126                     }
1127                 }
1128             }
1129         } else {
1130             return true;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before any token transfer. This includes minting
1136      * and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` will be minted for `to`.
1143      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1144      * - `from` and `to` are never both zero.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual {}
1153 
1154     /**
1155      * @dev Hook that is called after any transfer of tokens. This includes
1156      * minting and burning.
1157      *
1158      * Calling conditions:
1159      *
1160      * - when `from` and `to` are both non-zero.
1161      * - `from` and `to` are never both zero.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _afterTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {}
1170 }
1171 
1172 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1173 
1174 
1175 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 
1180 
1181 /**
1182  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1183  * enumerability of all the token ids in the contract as well as all token ids owned by each
1184  * account.
1185  */
1186 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1187     // Mapping from owner to list of owned token IDs
1188     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1189 
1190     // Mapping from token ID to index of the owner tokens list
1191     mapping(uint256 => uint256) private _ownedTokensIndex;
1192 
1193     // Array with all token ids, used for enumeration
1194     uint256[] private _allTokens;
1195 
1196     // Mapping from token id to position in the allTokens array
1197     mapping(uint256 => uint256) private _allTokensIndex;
1198 
1199     /**
1200      * @dev See {IERC165-supportsInterface}.
1201      */
1202     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1203         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1208      */
1209     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1210         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1211         return _ownedTokens[owner][index];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-totalSupply}.
1216      */
1217     function totalSupply() public view virtual override returns (uint256) {
1218         return _allTokens.length;
1219     }
1220 
1221     /**
1222      * @dev See {IERC721Enumerable-tokenByIndex}.
1223      */
1224     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1225         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1226         return _allTokens[index];
1227     }
1228 
1229     /**
1230      * @dev Hook that is called before any token transfer. This includes minting
1231      * and burning.
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` will be minted for `to`.
1238      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1239      * - `from` cannot be the zero address.
1240      * - `to` cannot be the zero address.
1241      *
1242      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1243      */
1244     function _beforeTokenTransfer(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) internal virtual override {
1249         super._beforeTokenTransfer(from, to, tokenId);
1250 
1251         if (from == address(0)) {
1252             _addTokenToAllTokensEnumeration(tokenId);
1253         } else if (from != to) {
1254             _removeTokenFromOwnerEnumeration(from, tokenId);
1255         }
1256         if (to == address(0)) {
1257             _removeTokenFromAllTokensEnumeration(tokenId);
1258         } else if (to != from) {
1259             _addTokenToOwnerEnumeration(to, tokenId);
1260         }
1261     }
1262 
1263     /**
1264      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1265      * @param to address representing the new owner of the given token ID
1266      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1267      */
1268     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1269         uint256 length = ERC721.balanceOf(to);
1270         _ownedTokens[to][length] = tokenId;
1271         _ownedTokensIndex[tokenId] = length;
1272     }
1273 
1274     /**
1275      * @dev Private function to add a token to this extension's token tracking data structures.
1276      * @param tokenId uint256 ID of the token to be added to the tokens list
1277      */
1278     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1279         _allTokensIndex[tokenId] = _allTokens.length;
1280         _allTokens.push(tokenId);
1281     }
1282 
1283     /**
1284      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1285      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1286      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1287      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1288      * @param from address representing the previous owner of the given token ID
1289      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1290      */
1291     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1292         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1293         // then delete the last slot (swap and pop).
1294 
1295         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1296         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1297 
1298         // When the token to delete is the last token, the swap operation is unnecessary
1299         if (tokenIndex != lastTokenIndex) {
1300             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1301 
1302             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1303             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1304         }
1305 
1306         // This also deletes the contents at the last position of the array
1307         delete _ownedTokensIndex[tokenId];
1308         delete _ownedTokens[from][lastTokenIndex];
1309     }
1310 
1311     /**
1312      * @dev Private function to remove a token from this extension's token tracking data structures.
1313      * This has O(1) time complexity, but alters the order of the _allTokens array.
1314      * @param tokenId uint256 ID of the token to be removed from the tokens list
1315      */
1316     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1317         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1318         // then delete the last slot (swap and pop).
1319 
1320         uint256 lastTokenIndex = _allTokens.length - 1;
1321         uint256 tokenIndex = _allTokensIndex[tokenId];
1322 
1323         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1324         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1325         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1326         uint256 lastTokenId = _allTokens[lastTokenIndex];
1327 
1328         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1329         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1330 
1331         // This also deletes the contents at the last position of the array
1332         delete _allTokensIndex[tokenId];
1333         _allTokens.pop();
1334     }
1335 }
1336 
1337 // File: @openzeppelin/contracts/access/Ownable.sol
1338 
1339 
1340 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 
1345 /**
1346  * @dev Contract module which provides a basic access control mechanism, where
1347  * there is an account (an owner) that can be granted exclusive access to
1348  * specific functions.
1349  *
1350  * By default, the owner account will be the one that deploys the contract. This
1351  * can later be changed with {transferOwnership}.
1352  *
1353  * This module is used through inheritance. It will make available the modifier
1354  * `onlyOwner`, which can be applied to your functions to restrict their use to
1355  * the owner.
1356  */
1357 abstract contract Ownable is Context {
1358     address private _owner;
1359 
1360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1361 
1362     /**
1363      * @dev Initializes the contract setting the deployer as the initial owner.
1364      */
1365     constructor() {
1366         _transferOwnership(_msgSender());
1367     }
1368 
1369     /**
1370      * @dev Throws if called by any account other than the owner.
1371      */
1372     modifier onlyOwner() {
1373         _checkOwner();
1374         _;
1375     }
1376 
1377     /**
1378      * @dev Returns the address of the current owner.
1379      */
1380     function owner() public view virtual returns (address) {
1381         return _owner;
1382     }
1383 
1384     /**
1385      * @dev Throws if the sender is not the owner.
1386      */
1387     function _checkOwner() internal view virtual {
1388         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1389     }
1390 
1391     /**
1392      * @dev Leaves the contract without owner. It will not be possible to call
1393      * `onlyOwner` functions anymore. Can only be called by the current owner.
1394      *
1395      * NOTE: Renouncing ownership will leave the contract without an owner,
1396      * thereby removing any functionality that is only available to the owner.
1397      */
1398     function renounceOwnership() public virtual onlyOwner {
1399         _transferOwnership(address(0));
1400     }
1401 
1402     /**
1403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1404      * Can only be called by the current owner.
1405      */
1406     function transferOwnership(address newOwner) public virtual onlyOwner {
1407         require(newOwner != address(0), "Ownable: new owner is the zero address");
1408         _transferOwnership(newOwner);
1409     }
1410 
1411     /**
1412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1413      * Internal function without access restriction.
1414      */
1415     function _transferOwnership(address newOwner) internal virtual {
1416         address oldOwner = _owner;
1417         _owner = newOwner;
1418         emit OwnershipTransferred(oldOwner, newOwner);
1419     }
1420 }
1421 
1422 // File: @openzeppelin/contracts/security/Pausable.sol
1423 
1424 
1425 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1426 
1427 pragma solidity ^0.8.0;
1428 
1429 
1430 /**
1431  * @dev Contract module which allows children to implement an emergency stop
1432  * mechanism that can be triggered by an authorized account.
1433  *
1434  * This module is used through inheritance. It will make available the
1435  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1436  * the functions of your contract. Note that they will not be pausable by
1437  * simply including this module, only once the modifiers are put in place.
1438  */
1439 abstract contract Pausable is Context {
1440     /**
1441      * @dev Emitted when the pause is triggered by `account`.
1442      */
1443     event Paused(address account);
1444 
1445     /**
1446      * @dev Emitted when the pause is lifted by `account`.
1447      */
1448     event Unpaused(address account);
1449 
1450     bool private _paused;
1451 
1452     /**
1453      * @dev Initializes the contract in unpaused state.
1454      */
1455     constructor() {
1456         _paused = false;
1457     }
1458 
1459     /**
1460      * @dev Modifier to make a function callable only when the contract is not paused.
1461      *
1462      * Requirements:
1463      *
1464      * - The contract must not be paused.
1465      */
1466     modifier whenNotPaused() {
1467         _requireNotPaused();
1468         _;
1469     }
1470 
1471     /**
1472      * @dev Modifier to make a function callable only when the contract is paused.
1473      *
1474      * Requirements:
1475      *
1476      * - The contract must be paused.
1477      */
1478     modifier whenPaused() {
1479         _requirePaused();
1480         _;
1481     }
1482 
1483     /**
1484      * @dev Returns true if the contract is paused, and false otherwise.
1485      */
1486     function paused() public view virtual returns (bool) {
1487         return _paused;
1488     }
1489 
1490     /**
1491      * @dev Throws if the contract is paused.
1492      */
1493     function _requireNotPaused() internal view virtual {
1494         require(!paused(), "Pausable: paused");
1495     }
1496 
1497     /**
1498      * @dev Throws if the contract is not paused.
1499      */
1500     function _requirePaused() internal view virtual {
1501         require(paused(), "Pausable: not paused");
1502     }
1503 
1504     /**
1505      * @dev Triggers stopped state.
1506      *
1507      * Requirements:
1508      *
1509      * - The contract must not be paused.
1510      */
1511     function _pause() internal virtual whenNotPaused {
1512         _paused = true;
1513         emit Paused(_msgSender());
1514     }
1515 
1516     /**
1517      * @dev Returns to normal state.
1518      *
1519      * Requirements:
1520      *
1521      * - The contract must be paused.
1522      */
1523     function _unpause() internal virtual whenPaused {
1524         _paused = false;
1525         emit Unpaused(_msgSender());
1526     }
1527 }
1528 
1529 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1530 
1531 
1532 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 // CAUTION
1537 // This version of SafeMath should only be used with Solidity 0.8 or later,
1538 // because it relies on the compiler's built in overflow checks.
1539 
1540 /**
1541  * @dev Wrappers over Solidity's arithmetic operations.
1542  *
1543  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1544  * now has built in overflow checking.
1545  */
1546 library SafeMath {
1547     /**
1548      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1549      *
1550      * _Available since v3.4._
1551      */
1552     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1553         unchecked {
1554             uint256 c = a + b;
1555             if (c < a) return (false, 0);
1556             return (true, c);
1557         }
1558     }
1559 
1560     /**
1561      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1562      *
1563      * _Available since v3.4._
1564      */
1565     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1566         unchecked {
1567             if (b > a) return (false, 0);
1568             return (true, a - b);
1569         }
1570     }
1571 
1572     /**
1573      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1574      *
1575      * _Available since v3.4._
1576      */
1577     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1578         unchecked {
1579             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1580             // benefit is lost if 'b' is also tested.
1581             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1582             if (a == 0) return (true, 0);
1583             uint256 c = a * b;
1584             if (c / a != b) return (false, 0);
1585             return (true, c);
1586         }
1587     }
1588 
1589     /**
1590      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1591      *
1592      * _Available since v3.4._
1593      */
1594     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1595         unchecked {
1596             if (b == 0) return (false, 0);
1597             return (true, a / b);
1598         }
1599     }
1600 
1601     /**
1602      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1603      *
1604      * _Available since v3.4._
1605      */
1606     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1607         unchecked {
1608             if (b == 0) return (false, 0);
1609             return (true, a % b);
1610         }
1611     }
1612 
1613     /**
1614      * @dev Returns the addition of two unsigned integers, reverting on
1615      * overflow.
1616      *
1617      * Counterpart to Solidity's `+` operator.
1618      *
1619      * Requirements:
1620      *
1621      * - Addition cannot overflow.
1622      */
1623     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1624         return a + b;
1625     }
1626 
1627     /**
1628      * @dev Returns the subtraction of two unsigned integers, reverting on
1629      * overflow (when the result is negative).
1630      *
1631      * Counterpart to Solidity's `-` operator.
1632      *
1633      * Requirements:
1634      *
1635      * - Subtraction cannot overflow.
1636      */
1637     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1638         return a - b;
1639     }
1640 
1641     /**
1642      * @dev Returns the multiplication of two unsigned integers, reverting on
1643      * overflow.
1644      *
1645      * Counterpart to Solidity's `*` operator.
1646      *
1647      * Requirements:
1648      *
1649      * - Multiplication cannot overflow.
1650      */
1651     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1652         return a * b;
1653     }
1654 
1655     /**
1656      * @dev Returns the integer division of two unsigned integers, reverting on
1657      * division by zero. The result is rounded towards zero.
1658      *
1659      * Counterpart to Solidity's `/` operator.
1660      *
1661      * Requirements:
1662      *
1663      * - The divisor cannot be zero.
1664      */
1665     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1666         return a / b;
1667     }
1668 
1669     /**
1670      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1671      * reverting when dividing by zero.
1672      *
1673      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1674      * opcode (which leaves remaining gas untouched) while Solidity uses an
1675      * invalid opcode to revert (consuming all remaining gas).
1676      *
1677      * Requirements:
1678      *
1679      * - The divisor cannot be zero.
1680      */
1681     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1682         return a % b;
1683     }
1684 
1685     /**
1686      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1687      * overflow (when the result is negative).
1688      *
1689      * CAUTION: This function is deprecated because it requires allocating memory for the error
1690      * message unnecessarily. For custom revert reasons use {trySub}.
1691      *
1692      * Counterpart to Solidity's `-` operator.
1693      *
1694      * Requirements:
1695      *
1696      * - Subtraction cannot overflow.
1697      */
1698     function sub(
1699         uint256 a,
1700         uint256 b,
1701         string memory errorMessage
1702     ) internal pure returns (uint256) {
1703         unchecked {
1704             require(b <= a, errorMessage);
1705             return a - b;
1706         }
1707     }
1708 
1709     /**
1710      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1711      * division by zero. The result is rounded towards zero.
1712      *
1713      * Counterpart to Solidity's `/` operator. Note: this function uses a
1714      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1715      * uses an invalid opcode to revert (consuming all remaining gas).
1716      *
1717      * Requirements:
1718      *
1719      * - The divisor cannot be zero.
1720      */
1721     function div(
1722         uint256 a,
1723         uint256 b,
1724         string memory errorMessage
1725     ) internal pure returns (uint256) {
1726         unchecked {
1727             require(b > 0, errorMessage);
1728             return a / b;
1729         }
1730     }
1731 
1732     /**
1733      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1734      * reverting with custom message when dividing by zero.
1735      *
1736      * CAUTION: This function is deprecated because it requires allocating memory for the error
1737      * message unnecessarily. For custom revert reasons use {tryMod}.
1738      *
1739      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1740      * opcode (which leaves remaining gas untouched) while Solidity uses an
1741      * invalid opcode to revert (consuming all remaining gas).
1742      *
1743      * Requirements:
1744      *
1745      * - The divisor cannot be zero.
1746      */
1747     function mod(
1748         uint256 a,
1749         uint256 b,
1750         string memory errorMessage
1751     ) internal pure returns (uint256) {
1752         unchecked {
1753             require(b > 0, errorMessage);
1754             return a % b;
1755         }
1756     }
1757 }
1758 
1759 // File: contracts/idamura.sol
1760 
1761 pragma solidity ^0.8.0;
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 interface IUniswapV2Pair {
1771     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1772 }
1773 
1774 
1775 interface IVoidCell {
1776  
1777     function mint(address addr) external;
1778     function burn(uint256 tokenId) external;
1779 
1780 }
1781 
1782 
1783 contract IRamura is Ownable, ERC721Enumerable, Pausable {
1784     using Strings for uint256;
1785     using Strings for uint8;
1786     using SafeMath for uint256;
1787 
1788     address public treasuryAddress;
1789     address public whitelistContract = 0xE36979d52B449A09C845E7519F743101975f8cAf;
1790     string private baseURL = 'https://metadata.idamura.xyz/';
1791     uint256 constant public MAX_SUPPLY = 4444;
1792     uint256 constant public MAX_SOCIAL_MINT = 4244;
1793     uint256 private totalMint;
1794     uint256 public totalSocialMinted;
1795     uint256 public constant price = 0.04444 ether;
1796     uint256 public startTime;
1797     uint256 private halfADays = 43200;
1798     uint256 private baseTime = 1641016800;
1799     address public voidCell = address(0);
1800     address private pair = address(0);
1801     mapping(address => bool) public whitelistedVoid;
1802     mapping(address => bool) public isVoidCell;
1803     mapping(uint256 => string) traits;
1804     mapping(bytes32 => bool) traitsExists;
1805     mapping(uint8 => uint8) maxTraits;
1806     mapping(address => bool) _isClaimedVoidCell;
1807     mapping(address => bool) _isMint;
1808     mapping(uint256 => bool) public isTransformed;
1809     mapping(uint256 => mapping(address => bool)) public isVoidTransformed;
1810     modifier mintRole() {
1811         if(block.timestamp <= startTime.add(1 days)){
1812             require(whitelisted(msg.sender) && block.timestamp >= startTime , "Only whitelited can mint");
1813         }
1814         _;
1815     }
1816 
1817     modifier onlyWhitelisted() {
1818         require(whitelistedVoid[msg.sender], "Only whitelited can mint");
1819         _;
1820     }
1821 
1822     modifier validateData(uint8[6] calldata data) {
1823        for(uint8 i=0; i<6; i++){
1824         require(data[i]>0 && data[i] <= maxTraits[i+1],"Wrong data");
1825        }
1826         _;
1827     }
1828 
1829     modifier validateToken(address token) {
1830         require(isVoidCell[token], "Wrong Token");
1831         _;
1832     }
1833 
1834     constructor(
1835         address _pair
1836     ) ERC721("Idamura","WAIFU") {
1837         startTime = 1666425600;
1838         pair = _pair;
1839         maxTraits[1] = 11;
1840         maxTraits[2] = 14;
1841         maxTraits[3] = 14;
1842         maxTraits[4] = 4;
1843         maxTraits[5] = 7;
1844         maxTraits[6] = 15;
1845     }
1846 
1847     function freeMint() external mintRole {
1848         require(block.timestamp >= startTime.add(30 minutes),"Not avaiable for free mint");
1849         require(totalSocialMinted < MAX_SOCIAL_MINT && !_isMint[msg.sender], "Full NFT or Have mint");
1850         uint8[6] memory _traits = _getRandom();
1851         string memory datastring;
1852         for(uint8 i=0; i<6; i++){
1853             datastring = string(abi.encodePacked(datastring,"/",_traits[i].toString()));
1854         }
1855         totalSocialMinted++;
1856         traitsExists[keccak256(abi.encodePacked(datastring))] = true;
1857         traits[totalSocialMinted] = datastring;
1858         _safeMint(msg.sender, totalSocialMinted);
1859         _isMint[msg.sender] = true;
1860     }
1861 
1862     function buildAWaifu(uint8[6] calldata data) external payable mintRole validateData(data){
1863         require(msg.value == price, "Not enought value");
1864         require(totalSocialMinted < MAX_SOCIAL_MINT && !_isMint[msg.sender], "Full NFT or Have mint");
1865         string memory datastring;
1866         for(uint8 i=0; i<6; i++){
1867             datastring = string(abi.encodePacked(datastring,"/",data[i].toString()));
1868         }
1869         require(!traitsExists[keccak256(abi.encodePacked(datastring))],"Traits Exists");
1870         traitsExists[keccak256(abi.encodePacked(datastring))] = true;
1871         totalSocialMinted++;
1872         _safeMint(msg.sender, totalSocialMinted);
1873         traits[totalSocialMinted] = datastring;
1874         _isMint[msg.sender] = true;
1875     }
1876 
1877     function mintTreasury(uint256 amount) external onlyOwner {
1878         require(totalMint.add(amount) < MAX_SUPPLY && MAX_SOCIAL_MINT.add(amount) <= MAX_SUPPLY);
1879         if(totalMint == 0){
1880             totalMint = MAX_SOCIAL_MINT;
1881         }
1882         for(uint i = 1; i <= amount; i++) {
1883             uint8[6] memory _traits = _getRandom();
1884             string memory datastring;
1885             for(uint8 j=0; j<6; j++){
1886                 datastring = string(abi.encodePacked(datastring,"/",_traits[j].toString()));
1887             }
1888             traitsExists[keccak256(abi.encodePacked(datastring))] = true;
1889             traits[totalMint.add(i)] = datastring;
1890             _safeMint(msg.sender, totalMint.add(i));
1891         }
1892         totalMint = totalMint.add(amount);
1893     }
1894 
1895     function checkTraits(uint8[6] calldata _traits) external view returns(bool){
1896         return _compareTraits(_traits);
1897     }
1898 
1899     function collect() external onlyWhitelisted {
1900         require(!_isClaimedVoidCell[msg.sender],"Have been claimed voidCell");
1901         IVoidCell(voidCell).mint(msg.sender);
1902         _isClaimedVoidCell[msg.sender] = true;
1903     }
1904 
1905     function transform(uint256 tokenId) external {
1906         require(ERC721.ownerOf(tokenId) == msg.sender, "Only owner upgrade");
1907         require(!isTransformed[tokenId], "TokenID has been upgraded");
1908         uint256 token1 = ERC721Enumerable(voidCell).tokenOfOwnerByIndex(msg.sender, 0);
1909         IVoidCell(voidCell).burn(token1);
1910         isTransformed[tokenId] = true;    
1911     }
1912 
1913     function transform(address token, uint256 tokenId) external validateToken(token) {
1914         require(ERC721.ownerOf(tokenId) == msg.sender, "Only owner upgrade");
1915         require(!isVoidTransformed[tokenId][token], "TokenID has been upgraded");
1916         require(ERC721(token).isApprovedForAll(msg.sender, address(this)),"Not Set Approve");
1917         ERC721(token).transferFrom(msg.sender, treasuryAddress, ERC721Enumerable(token).tokenOfOwnerByIndex(msg.sender, 0));
1918         isVoidTransformed[tokenId][token] = true;    
1919     }
1920 
1921     function _baseURI() internal view override returns (string memory) {
1922         return baseURL;
1923     }
1924 
1925     function setBaseURI(string memory _uri) external onlyOwner {
1926         baseURL = _uri;
1927     }
1928 
1929     function _getRandom() internal view returns(uint8[6] memory result) {
1930         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();
1931         uint256 number = uint256(keccak256(abi.encodePacked(block.timestamp, reserve0, reserve1)));
1932         bool isDone;
1933         uint256 increaseNumber = 1;
1934         while(!isDone){
1935             for(uint8 i =0; i<6; i++){
1936                 result[i] = uint8(number.mod((maxTraits[i+1])) +1);
1937                 number = number.div(maxTraits[i+1]);
1938             }
1939             if(number == 0) {
1940                  number = uint256(keccak256(abi.encodePacked(block.timestamp, reserve0.add(increaseNumber), reserve1)));
1941                  increaseNumber++;
1942             }
1943 
1944             if(!_compareTraits(result)){
1945                 isDone = true;
1946             }
1947         }
1948         return result;
1949     }
1950 
1951 
1952     function _compareTraits(uint8[6] memory _traits) internal view returns(bool) {
1953         string memory datastring;
1954         for(uint8 i=0; i<6; i++){
1955             datastring = string(abi.encodePacked(datastring,"/",_traits[i].toString()));
1956         }
1957 
1958         return traitsExists[keccak256(abi.encodePacked(datastring))];
1959     }
1960     
1961     function tokenURI(uint256 tokenId)
1962     public
1963     view
1964     override
1965     returns (string memory)
1966     {
1967         if(isTransformed[tokenId]){
1968             if(block.timestamp.sub(baseTime).div(halfADays).mod(2) == 0){
1969                 return string(abi.encodePacked(_baseURI(), tokenId.toString(), "/0", traits[tokenId]));
1970             } else {
1971                 return string(abi.encodePacked(_baseURI(), tokenId.toString(), "/1", traits[tokenId]));
1972             }
1973         } else {
1974             return string(abi.encodePacked(_baseURI(), tokenId.toString(), "/0",  traits[tokenId]));
1975         }
1976     }
1977 
1978     function _beforeTokenTransfer(
1979         address from,
1980         address to,
1981         uint256 tokenId
1982     ) internal virtual override {
1983         super._beforeTokenTransfer(from,to,tokenId);
1984     }
1985 
1986     function _afterTokenTransfer(
1987         address from,
1988         address to,
1989         uint256 tokenId
1990     ) internal virtual override {
1991         super._afterTokenTransfer(from,to,tokenId);
1992     }
1993 
1994     function pause() external onlyOwner whenNotPaused {
1995         _pause();
1996     }
1997 
1998     function unpause() external onlyOwner whenPaused {
1999         _unpause();
2000     }
2001 
2002     function setStartTime(uint256 time) external onlyOwner {
2003         startTime = time;
2004     }
2005     
2006     function addWhitelisteVoid(address[] calldata list) external onlyOwner {
2007         for(uint i =0; i < list.length ; i ++) {
2008             whitelistedVoid[list[i]] = true;
2009         }
2010     }
2011 
2012     function setVoidCell(address _voidCell, bool isBurn) external onlyOwner {
2013         if(isBurn){
2014             voidCell = _voidCell;
2015         } else {
2016             isVoidCell[_voidCell] = true;
2017         }
2018     }
2019 
2020     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
2021         require(_treasuryAddress != address(0), "Not accept zero address");
2022         treasuryAddress = _treasuryAddress;
2023     }
2024 
2025     function isMint(address addr) external view returns(bool) {
2026         return _isMint[addr];
2027     }
2028 
2029     function whitelisted(address addr) public view returns(bool) {
2030         return IRamura(whitelistContract).whitelisted(addr);
2031     }
2032 
2033     function takeFee(address token, uint256 amount) external onlyOwner {
2034         if(token == address(0)){
2035             if(amount <= address(this).balance){
2036                 payable(owner()).transfer(amount);
2037             } else {
2038                 payable(owner()).transfer(address(this).balance);
2039             }
2040         }  else {
2041             IERC20(token).transfer(owner(), amount);
2042         }
2043     }
2044 }