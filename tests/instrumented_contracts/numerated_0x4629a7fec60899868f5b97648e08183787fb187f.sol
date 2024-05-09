1 /** 
2  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 
33 
34 /** 
35  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
36 */
37             
38 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
39 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 ////import "../../utils/introspection/IERC165.sol";
44 
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
79      * @dev Safely transfers `tokenId` token from `from` to `to`.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId,
95         bytes calldata data
96     ) external;
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Approve or remove `operator` as an operator for the caller.
155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
156      *
157      * Requirements:
158      *
159      * - The `operator` cannot be the caller.
160      *
161      * Emits an {ApprovalForAll} event.
162      */
163     function setApprovalForAll(address operator, bool _approved) external;
164 
165     /**
166      * @dev Returns the account approved for `tokenId` token.
167      *
168      * Requirements:
169      *
170      * - `tokenId` must exist.
171      */
172     function getApproved(uint256 tokenId) external view returns (address operator);
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 }
181 
182 
183 
184 
185 /** 
186  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
187 */
188             
189 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
190 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP.
196  */
197 interface IERC20 {
198     /**
199      * @dev Emitted when `value` tokens are moved from one account (`from`) to
200      * another (`to`).
201      *
202      * Note that `value` may be zero.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     /**
207      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
208      * a call to {approve}. `value` is the new allowance.
209      */
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 
212     /**
213      * @dev Returns the amount of tokens in existence.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns the amount of tokens owned by `account`.
219      */
220     function balanceOf(address account) external view returns (uint256);
221 
222     /**
223      * @dev Moves `amount` tokens from the caller's account to `to`.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transfer(address to, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Returns the remaining number of tokens that `spender` will be
233      * allowed to spend on behalf of `owner` through {transferFrom}. This is
234      * zero by default.
235      *
236      * This value changes when {approve} or {transferFrom} are called.
237      */
238     function allowance(address owner, address spender) external view returns (uint256);
239 
240     /**
241      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
246      * that someone may use both the old and the new allowance by unfortunate
247      * transaction ordering. One possible solution to mitigate this race
248      * condition is to first reduce the spender's allowance to 0 and set the
249      * desired value afterwards:
250      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address spender, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Moves `amount` tokens from `from` to `to` using the
258      * allowance mechanism. `amount` is then deducted from the caller's
259      * allowance.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 amount
269     ) external returns (bool);
270 }
271 
272 
273 
274 
275 /** 
276  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
277 */
278             
279 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
280 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 ////import "./IERC165.sol";
285 
286 /**
287  * @dev Implementation of the {IERC165} interface.
288  *
289  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
290  * for the additional interface id that will be supported. For example:
291  *
292  * ```solidity
293  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
294  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
295  * }
296  * ```
297  *
298  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
299  */
300 abstract contract ERC165 is IERC165 {
301     /**
302      * @dev See {IERC165-supportsInterface}.
303      */
304     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
305         return interfaceId == type(IERC165).interfaceId;
306     }
307 }
308 
309 
310 
311 
312 /** 
313  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
314 */
315             
316 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
317 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev String operations.
323  */
324 library Strings {
325     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
329      */
330     function toString(uint256 value) internal pure returns (string memory) {
331         // Inspired by OraclizeAPI's implementation - MIT licence
332         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
333 
334         if (value == 0) {
335             return "0";
336         }
337         uint256 temp = value;
338         uint256 digits;
339         while (temp != 0) {
340             digits++;
341             temp /= 10;
342         }
343         bytes memory buffer = new bytes(digits);
344         while (value != 0) {
345             digits -= 1;
346             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
347             value /= 10;
348         }
349         return string(buffer);
350     }
351 
352     /**
353      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
354      */
355     function toHexString(uint256 value) internal pure returns (string memory) {
356         if (value == 0) {
357             return "0x00";
358         }
359         uint256 temp = value;
360         uint256 length = 0;
361         while (temp != 0) {
362             length++;
363             temp >>= 8;
364         }
365         return toHexString(value, length);
366     }
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
370      */
371     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
372         bytes memory buffer = new bytes(2 * length + 2);
373         buffer[0] = "0";
374         buffer[1] = "x";
375         for (uint256 i = 2 * length + 1; i > 1; --i) {
376             buffer[i] = _HEX_SYMBOLS[value & 0xf];
377             value >>= 4;
378         }
379         require(value == 0, "Strings: hex length insufficient");
380         return string(buffer);
381     }
382 }
383 
384 
385 
386 
387 /** 
388  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
389 */
390             
391 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
392 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 
417 
418 
419 /** 
420  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
421 */
422             
423 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
424 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
425 
426 pragma solidity ^0.8.1;
427 
428 /**
429  * @dev Collection of functions related to the address type
430  */
431 library Address {
432     /**
433      * @dev Returns true if `account` is a contract.
434      *
435      * [////IMPORTANT]
436      * ====
437      * It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      *
440      * Among others, `isContract` will return false for the following
441      * types of addresses:
442      *
443      *  - an externally-owned account
444      *  - a contract in construction
445      *  - an address where a contract will be created
446      *  - an address where a contract lived, but was destroyed
447      * ====
448      *
449      * [IMPORTANT]
450      * ====
451      * You shouldn't rely on `isContract` to protect against flash loan attacks!
452      *
453      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
454      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
455      * constructor.
456      * ====
457      */
458     function isContract(address account) internal view returns (bool) {
459         // This method relies on extcodesize/address.code.length, which returns 0
460         // for contracts in construction, since the code is only stored at the end
461         // of the constructor execution.
462 
463         return account.code.length > 0;
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * ////IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(address(this).balance >= amount, "Address: insufficient balance");
484 
485         (bool success, ) = recipient.call{value: amount}("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 
489     /**
490      * @dev Performs a Solidity function call using a low level `call`. A
491      * plain `call` is an unsafe replacement for a function call: use this
492      * function instead.
493      *
494      * If `target` reverts with a revert reason, it is bubbled up by this
495      * function (like regular Solidity function calls).
496      *
497      * Returns the raw returned data. To convert to the expected return value,
498      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
499      *
500      * Requirements:
501      *
502      * - `target` must be a contract.
503      * - calling `target` with `data` must not revert.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
508         return functionCall(target, data, "Address: low-level call failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
513      * `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCall(
518         address target,
519         bytes memory data,
520         string memory errorMessage
521     ) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, 0, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but also transferring `value` wei to `target`.
528      *
529      * Requirements:
530      *
531      * - the calling contract must have an ETH balance of at least `value`.
532      * - the called Solidity function must be `payable`.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value
540     ) internal returns (bytes memory) {
541         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
546      * with `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCallWithValue(
551         address target,
552         bytes memory data,
553         uint256 value,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         require(address(this).balance >= value, "Address: insufficient balance for call");
557         require(isContract(target), "Address: call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.call{value: value}(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
570         return functionStaticCall(target, data, "Address: low-level static call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
575      * but performing a static call.
576      *
577      * _Available since v3.3._
578      */
579     function functionStaticCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal view returns (bytes memory) {
584         require(isContract(target), "Address: static call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.staticcall(data);
587         return verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
597         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
602      * but performing a delegate call.
603      *
604      * _Available since v3.4._
605      */
606     function functionDelegateCall(
607         address target,
608         bytes memory data,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         require(isContract(target), "Address: delegate call to non-contract");
612 
613         (bool success, bytes memory returndata) = target.delegatecall(data);
614         return verifyCallResult(success, returndata, errorMessage);
615     }
616 
617     /**
618      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
619      * revert reason using the provided one.
620      *
621      * _Available since v4.3._
622      */
623     function verifyCallResult(
624         bool success,
625         bytes memory returndata,
626         string memory errorMessage
627     ) internal pure returns (bytes memory) {
628         if (success) {
629             return returndata;
630         } else {
631             // Look for revert reason and bubble it up if present
632             if (returndata.length > 0) {
633                 // The easiest way to bubble the revert reason is using memory via assembly
634 
635                 assembly {
636                     let returndata_size := mload(returndata)
637                     revert(add(32, returndata), returndata_size)
638                 }
639             } else {
640                 revert(errorMessage);
641             }
642         }
643     }
644 }
645 
646 
647 
648 
649 /** 
650  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
651 */
652             
653 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
654 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 ////import "../IERC721.sol";
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Metadata is IERC721 {
665     /**
666      * @dev Returns the token collection name.
667      */
668     function name() external view returns (string memory);
669 
670     /**
671      * @dev Returns the token collection symbol.
672      */
673     function symbol() external view returns (string memory);
674 
675     /**
676      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
677      */
678     function tokenURI(uint256 tokenId) external view returns (string memory);
679 }
680 
681 
682 
683 
684 /** 
685  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
686 */
687             
688 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
689 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 /**
694  * @title ERC721 token receiver interface
695  * @dev Interface for any contract that wants to support safeTransfers
696  * from ERC721 asset contracts.
697  */
698 interface IERC721Receiver {
699     /**
700      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
701      * by `operator` from `from`, this function is called.
702      *
703      * It must return its Solidity selector to confirm the token transfer.
704      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
705      *
706      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
707      */
708     function onERC721Received(
709         address operator,
710         address from,
711         uint256 tokenId,
712         bytes calldata data
713     ) external returns (bytes4);
714 }
715 
716 
717 
718 
719 /** 
720  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
721 */
722             
723 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
724 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 ////import "../IERC20.sol";
729 
730 /**
731  * @dev Interface for the optional metadata functions from the ERC20 standard.
732  *
733  * _Available since v4.1._
734  */
735 interface IERC20Metadata is IERC20 {
736     /**
737      * @dev Returns the name of the token.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the symbol of the token.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the decimals places of the token.
748      */
749     function decimals() external view returns (uint8);
750 }
751 
752 
753 
754 
755 /** 
756  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
757 */
758             
759 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: Apache-2.0
760 pragma solidity ^0.8.4;
761 
762 ////import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
763 ////import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
764 
765 /// @title ERC721Staking
766 /// @author Risser Labs LLC
767 /// @dev staking contract
768 /// @custom:security-contact dev@risserlabs.com
769 interface IERC721Staking {
770     event Deposit(
771         address indexed user,
772         uint256 indexed poolIdx,
773         uint256 stakeAmount
774     );
775 
776     event Withdraw(
777         address indexed user,
778         uint256 indexed poolIdx,
779         uint256 stakeAmount
780     );
781 
782     event Claim(
783         address indexed user,
784         uint256 indexed poolIdx,
785         uint256 rewardAmount
786     );
787 
788     function rewardsToken() external view returns (IERC20);
789 
790     function stakingToken() external view returns (IERC721);
791 
792     function totalStaked() external view returns (uint256);
793 
794     function balanceOf(address staker) external view returns (uint256 balance);
795 
796     function walletOf(address staker)
797         external
798         view
799         returns (uint256[] memory tokenIds);
800 
801     function ownerOf(uint256 tokenId) external view returns (address owner);
802 
803     function unclaimedRewards(address staker)
804         external
805         view
806         returns (uint256 rewards);
807 
808     function deposit(uint256 tokenId) external;
809 
810     function withdraw(uint256 tokenId) external;
811 
812     function claim() external returns (uint256 rewards);
813 }
814 
815 
816 
817 
818 /** 
819  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
820 */
821             
822 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
823 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 // CAUTION
828 // This version of SafeMath should only be used with Solidity 0.8 or later,
829 // because it relies on the compiler's built in overflow checks.
830 
831 /**
832  * @dev Wrappers over Solidity's arithmetic operations.
833  *
834  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
835  * now has built in overflow checking.
836  */
837 library SafeMath {
838     /**
839      * @dev Returns the addition of two unsigned integers, with an overflow flag.
840      *
841      * _Available since v3.4._
842      */
843     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
844         unchecked {
845             uint256 c = a + b;
846             if (c < a) return (false, 0);
847             return (true, c);
848         }
849     }
850 
851     /**
852      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
853      *
854      * _Available since v3.4._
855      */
856     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
857         unchecked {
858             if (b > a) return (false, 0);
859             return (true, a - b);
860         }
861     }
862 
863     /**
864      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
865      *
866      * _Available since v3.4._
867      */
868     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
869         unchecked {
870             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
871             // benefit is lost if 'b' is also tested.
872             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
873             if (a == 0) return (true, 0);
874             uint256 c = a * b;
875             if (c / a != b) return (false, 0);
876             return (true, c);
877         }
878     }
879 
880     /**
881      * @dev Returns the division of two unsigned integers, with a division by zero flag.
882      *
883      * _Available since v3.4._
884      */
885     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
886         unchecked {
887             if (b == 0) return (false, 0);
888             return (true, a / b);
889         }
890     }
891 
892     /**
893      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
894      *
895      * _Available since v3.4._
896      */
897     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
898         unchecked {
899             if (b == 0) return (false, 0);
900             return (true, a % b);
901         }
902     }
903 
904     /**
905      * @dev Returns the addition of two unsigned integers, reverting on
906      * overflow.
907      *
908      * Counterpart to Solidity's `+` operator.
909      *
910      * Requirements:
911      *
912      * - Addition cannot overflow.
913      */
914     function add(uint256 a, uint256 b) internal pure returns (uint256) {
915         return a + b;
916     }
917 
918     /**
919      * @dev Returns the subtraction of two unsigned integers, reverting on
920      * overflow (when the result is negative).
921      *
922      * Counterpart to Solidity's `-` operator.
923      *
924      * Requirements:
925      *
926      * - Subtraction cannot overflow.
927      */
928     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
929         return a - b;
930     }
931 
932     /**
933      * @dev Returns the multiplication of two unsigned integers, reverting on
934      * overflow.
935      *
936      * Counterpart to Solidity's `*` operator.
937      *
938      * Requirements:
939      *
940      * - Multiplication cannot overflow.
941      */
942     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
943         return a * b;
944     }
945 
946     /**
947      * @dev Returns the integer division of two unsigned integers, reverting on
948      * division by zero. The result is rounded towards zero.
949      *
950      * Counterpart to Solidity's `/` operator.
951      *
952      * Requirements:
953      *
954      * - The divisor cannot be zero.
955      */
956     function div(uint256 a, uint256 b) internal pure returns (uint256) {
957         return a / b;
958     }
959 
960     /**
961      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
962      * reverting when dividing by zero.
963      *
964      * Counterpart to Solidity's `%` operator. This function uses a `revert`
965      * opcode (which leaves remaining gas untouched) while Solidity uses an
966      * invalid opcode to revert (consuming all remaining gas).
967      *
968      * Requirements:
969      *
970      * - The divisor cannot be zero.
971      */
972     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
973         return a % b;
974     }
975 
976     /**
977      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
978      * overflow (when the result is negative).
979      *
980      * CAUTION: This function is deprecated because it requires allocating memory for the error
981      * message unnecessarily. For custom revert reasons use {trySub}.
982      *
983      * Counterpart to Solidity's `-` operator.
984      *
985      * Requirements:
986      *
987      * - Subtraction cannot overflow.
988      */
989     function sub(
990         uint256 a,
991         uint256 b,
992         string memory errorMessage
993     ) internal pure returns (uint256) {
994         unchecked {
995             require(b <= a, errorMessage);
996             return a - b;
997         }
998     }
999 
1000     /**
1001      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1002      * division by zero. The result is rounded towards zero.
1003      *
1004      * Counterpart to Solidity's `/` operator. Note: this function uses a
1005      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1006      * uses an invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function div(
1013         uint256 a,
1014         uint256 b,
1015         string memory errorMessage
1016     ) internal pure returns (uint256) {
1017         unchecked {
1018             require(b > 0, errorMessage);
1019             return a / b;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1025      * reverting with custom message when dividing by zero.
1026      *
1027      * CAUTION: This function is deprecated because it requires allocating memory for the error
1028      * message unnecessarily. For custom revert reasons use {tryMod}.
1029      *
1030      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1031      * opcode (which leaves remaining gas untouched) while Solidity uses an
1032      * invalid opcode to revert (consuming all remaining gas).
1033      *
1034      * Requirements:
1035      *
1036      * - The divisor cannot be zero.
1037      */
1038     function mod(
1039         uint256 a,
1040         uint256 b,
1041         string memory errorMessage
1042     ) internal pure returns (uint256) {
1043         unchecked {
1044             require(b > 0, errorMessage);
1045             return a % b;
1046         }
1047     }
1048 }
1049 
1050 
1051 
1052 
1053 /** 
1054  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
1055 */
1056             
1057 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1058 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 ////import "./IERC721.sol";
1063 ////import "./IERC721Receiver.sol";
1064 ////import "./extensions/IERC721Metadata.sol";
1065 ////import "../../utils/Address.sol";
1066 ////import "../../utils/Context.sol";
1067 ////import "../../utils/Strings.sol";
1068 ////import "../../utils/introspection/ERC165.sol";
1069 
1070 /**
1071  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1072  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1073  * {ERC721Enumerable}.
1074  */
1075 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1076     using Address for address;
1077     using Strings for uint256;
1078 
1079     // Token name
1080     string private _name;
1081 
1082     // Token symbol
1083     string private _symbol;
1084 
1085     // Mapping from token ID to owner address
1086     mapping(uint256 => address) private _owners;
1087 
1088     // Mapping owner address to token count
1089     mapping(address => uint256) private _balances;
1090 
1091     // Mapping from token ID to approved address
1092     mapping(uint256 => address) private _tokenApprovals;
1093 
1094     // Mapping from owner to operator approvals
1095     mapping(address => mapping(address => bool)) private _operatorApprovals;
1096 
1097     /**
1098      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1099      */
1100     constructor(string memory name_, string memory symbol_) {
1101         _name = name_;
1102         _symbol = symbol_;
1103     }
1104 
1105     /**
1106      * @dev See {IERC165-supportsInterface}.
1107      */
1108     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1109         return
1110             interfaceId == type(IERC721).interfaceId ||
1111             interfaceId == type(IERC721Metadata).interfaceId ||
1112             super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-balanceOf}.
1117      */
1118     function balanceOf(address owner) public view virtual override returns (uint256) {
1119         require(owner != address(0), "ERC721: balance query for the zero address");
1120         return _balances[owner];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-ownerOf}.
1125      */
1126     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1127         address owner = _owners[tokenId];
1128         require(owner != address(0), "ERC721: owner query for nonexistent token");
1129         return owner;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-name}.
1134      */
1135     function name() public view virtual override returns (string memory) {
1136         return _name;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Metadata-symbol}.
1141      */
1142     function symbol() public view virtual override returns (string memory) {
1143         return _symbol;
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Metadata-tokenURI}.
1148      */
1149     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1150         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1151 
1152         string memory baseURI = _baseURI();
1153         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1154     }
1155 
1156     /**
1157      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1158      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1159      * by default, can be overridden in child contracts.
1160      */
1161     function _baseURI() internal view virtual returns (string memory) {
1162         return "";
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-approve}.
1167      */
1168     function approve(address to, uint256 tokenId) public virtual override {
1169         address owner = ERC721.ownerOf(tokenId);
1170         require(to != owner, "ERC721: approval to current owner");
1171 
1172         require(
1173             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1174             "ERC721: approve caller is not owner nor approved for all"
1175         );
1176 
1177         _approve(to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-getApproved}.
1182      */
1183     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1184         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1185 
1186         return _tokenApprovals[tokenId];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-setApprovalForAll}.
1191      */
1192     function setApprovalForAll(address operator, bool approved) public virtual override {
1193         _setApprovalForAll(_msgSender(), operator, approved);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-isApprovedForAll}.
1198      */
1199     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1200         return _operatorApprovals[owner][operator];
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-transferFrom}.
1205      */
1206     function transferFrom(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) public virtual override {
1211         //solhint-disable-next-line max-line-length
1212         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1213 
1214         _transfer(from, to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-safeTransferFrom}.
1219      */
1220     function safeTransferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) public virtual override {
1225         safeTransferFrom(from, to, tokenId, "");
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-safeTransferFrom}.
1230      */
1231     function safeTransferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId,
1235         bytes memory _data
1236     ) public virtual override {
1237         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1238         _safeTransfer(from, to, tokenId, _data);
1239     }
1240 
1241     /**
1242      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1243      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1244      *
1245      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1246      *
1247      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1248      * implement alternative mechanisms to perform token transfer, such as signature-based.
1249      *
1250      * Requirements:
1251      *
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must exist and be owned by `from`.
1255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _safeTransfer(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) internal virtual {
1265         _transfer(from, to, tokenId);
1266         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1267     }
1268 
1269     /**
1270      * @dev Returns whether `tokenId` exists.
1271      *
1272      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1273      *
1274      * Tokens start existing when they are minted (`_mint`),
1275      * and stop existing when they are burned (`_burn`).
1276      */
1277     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1278         return _owners[tokenId] != address(0);
1279     }
1280 
1281     /**
1282      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1283      *
1284      * Requirements:
1285      *
1286      * - `tokenId` must exist.
1287      */
1288     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1289         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1290         address owner = ERC721.ownerOf(tokenId);
1291         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1292     }
1293 
1294     /**
1295      * @dev Safely mints `tokenId` and transfers it to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must not exist.
1300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _safeMint(address to, uint256 tokenId) internal virtual {
1305         _safeMint(to, tokenId, "");
1306     }
1307 
1308     /**
1309      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1310      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1311      */
1312     function _safeMint(
1313         address to,
1314         uint256 tokenId,
1315         bytes memory _data
1316     ) internal virtual {
1317         _mint(to, tokenId);
1318         require(
1319             _checkOnERC721Received(address(0), to, tokenId, _data),
1320             "ERC721: transfer to non ERC721Receiver implementer"
1321         );
1322     }
1323 
1324     /**
1325      * @dev Mints `tokenId` and transfers it to `to`.
1326      *
1327      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1328      *
1329      * Requirements:
1330      *
1331      * - `tokenId` must not exist.
1332      * - `to` cannot be the zero address.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _mint(address to, uint256 tokenId) internal virtual {
1337         require(to != address(0), "ERC721: mint to the zero address");
1338         require(!_exists(tokenId), "ERC721: token already minted");
1339 
1340         _beforeTokenTransfer(address(0), to, tokenId);
1341 
1342         _balances[to] += 1;
1343         _owners[tokenId] = to;
1344 
1345         emit Transfer(address(0), to, tokenId);
1346 
1347         _afterTokenTransfer(address(0), to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev Destroys `tokenId`.
1352      * The approval is cleared when the token is burned.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _burn(uint256 tokenId) internal virtual {
1361         address owner = ERC721.ownerOf(tokenId);
1362 
1363         _beforeTokenTransfer(owner, address(0), tokenId);
1364 
1365         // Clear approvals
1366         _approve(address(0), tokenId);
1367 
1368         _balances[owner] -= 1;
1369         delete _owners[tokenId];
1370 
1371         emit Transfer(owner, address(0), tokenId);
1372 
1373         _afterTokenTransfer(owner, address(0), tokenId);
1374     }
1375 
1376     /**
1377      * @dev Transfers `tokenId` from `from` to `to`.
1378      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1379      *
1380      * Requirements:
1381      *
1382      * - `to` cannot be the zero address.
1383      * - `tokenId` token must be owned by `from`.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function _transfer(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) internal virtual {
1392         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1393         require(to != address(0), "ERC721: transfer to the zero address");
1394 
1395         _beforeTokenTransfer(from, to, tokenId);
1396 
1397         // Clear approvals from the previous owner
1398         _approve(address(0), tokenId);
1399 
1400         _balances[from] -= 1;
1401         _balances[to] += 1;
1402         _owners[tokenId] = to;
1403 
1404         emit Transfer(from, to, tokenId);
1405 
1406         _afterTokenTransfer(from, to, tokenId);
1407     }
1408 
1409     /**
1410      * @dev Approve `to` to operate on `tokenId`
1411      *
1412      * Emits a {Approval} event.
1413      */
1414     function _approve(address to, uint256 tokenId) internal virtual {
1415         _tokenApprovals[tokenId] = to;
1416         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1417     }
1418 
1419     /**
1420      * @dev Approve `operator` to operate on all of `owner` tokens
1421      *
1422      * Emits a {ApprovalForAll} event.
1423      */
1424     function _setApprovalForAll(
1425         address owner,
1426         address operator,
1427         bool approved
1428     ) internal virtual {
1429         require(owner != operator, "ERC721: approve to caller");
1430         _operatorApprovals[owner][operator] = approved;
1431         emit ApprovalForAll(owner, operator, approved);
1432     }
1433 
1434     /**
1435      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1436      * The call is not executed if the target address is not a contract.
1437      *
1438      * @param from address representing the previous owner of the given token ID
1439      * @param to target address that will receive the tokens
1440      * @param tokenId uint256 ID of the token to be transferred
1441      * @param _data bytes optional data to send along with the call
1442      * @return bool whether the call correctly returned the expected magic value
1443      */
1444     function _checkOnERC721Received(
1445         address from,
1446         address to,
1447         uint256 tokenId,
1448         bytes memory _data
1449     ) private returns (bool) {
1450         if (to.isContract()) {
1451             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1452                 return retval == IERC721Receiver.onERC721Received.selector;
1453             } catch (bytes memory reason) {
1454                 if (reason.length == 0) {
1455                     revert("ERC721: transfer to non ERC721Receiver implementer");
1456                 } else {
1457                     assembly {
1458                         revert(add(32, reason), mload(reason))
1459                     }
1460                 }
1461             }
1462         } else {
1463             return true;
1464         }
1465     }
1466 
1467     /**
1468      * @dev Hook that is called before any token transfer. This includes minting
1469      * and burning.
1470      *
1471      * Calling conditions:
1472      *
1473      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1474      * transferred to `to`.
1475      * - When `from` is zero, `tokenId` will be minted for `to`.
1476      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1477      * - `from` and `to` are never both zero.
1478      *
1479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1480      */
1481     function _beforeTokenTransfer(
1482         address from,
1483         address to,
1484         uint256 tokenId
1485     ) internal virtual {}
1486 
1487     /**
1488      * @dev Hook that is called after any transfer of tokens. This includes
1489      * minting and burning.
1490      *
1491      * Calling conditions:
1492      *
1493      * - when `from` and `to` are both non-zero.
1494      * - `from` and `to` are never both zero.
1495      *
1496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1497      */
1498     function _afterTokenTransfer(
1499         address from,
1500         address to,
1501         uint256 tokenId
1502     ) internal virtual {}
1503 }
1504 
1505 
1506 
1507 
1508 /** 
1509  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
1510 */
1511             
1512 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1513 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 ////import "./IERC20.sol";
1518 ////import "./extensions/IERC20Metadata.sol";
1519 ////import "../../utils/Context.sol";
1520 
1521 /**
1522  * @dev Implementation of the {IERC20} interface.
1523  *
1524  * This implementation is agnostic to the way tokens are created. This means
1525  * that a supply mechanism has to be added in a derived contract using {_mint}.
1526  * For a generic mechanism see {ERC20PresetMinterPauser}.
1527  *
1528  * TIP: For a detailed writeup see our guide
1529  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1530  * to implement supply mechanisms].
1531  *
1532  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1533  * instead returning `false` on failure. This behavior is nonetheless
1534  * conventional and does not conflict with the expectations of ERC20
1535  * applications.
1536  *
1537  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1538  * This allows applications to reconstruct the allowance for all accounts just
1539  * by listening to said events. Other implementations of the EIP may not emit
1540  * these events, as it isn't required by the specification.
1541  *
1542  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1543  * functions have been added to mitigate the well-known issues around setting
1544  * allowances. See {IERC20-approve}.
1545  */
1546 contract ERC20 is Context, IERC20, IERC20Metadata {
1547     mapping(address => uint256) private _balances;
1548 
1549     mapping(address => mapping(address => uint256)) private _allowances;
1550 
1551     uint256 private _totalSupply;
1552 
1553     string private _name;
1554     string private _symbol;
1555 
1556     /**
1557      * @dev Sets the values for {name} and {symbol}.
1558      *
1559      * The default value of {decimals} is 18. To select a different value for
1560      * {decimals} you should overload it.
1561      *
1562      * All two of these values are immutable: they can only be set once during
1563      * construction.
1564      */
1565     constructor(string memory name_, string memory symbol_) {
1566         _name = name_;
1567         _symbol = symbol_;
1568     }
1569 
1570     /**
1571      * @dev Returns the name of the token.
1572      */
1573     function name() public view virtual override returns (string memory) {
1574         return _name;
1575     }
1576 
1577     /**
1578      * @dev Returns the symbol of the token, usually a shorter version of the
1579      * name.
1580      */
1581     function symbol() public view virtual override returns (string memory) {
1582         return _symbol;
1583     }
1584 
1585     /**
1586      * @dev Returns the number of decimals used to get its user representation.
1587      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1588      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1589      *
1590      * Tokens usually opt for a value of 18, imitating the relationship between
1591      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1592      * overridden;
1593      *
1594      * NOTE: This information is only used for _display_ purposes: it in
1595      * no way affects any of the arithmetic of the contract, including
1596      * {IERC20-balanceOf} and {IERC20-transfer}.
1597      */
1598     function decimals() public view virtual override returns (uint8) {
1599         return 18;
1600     }
1601 
1602     /**
1603      * @dev See {IERC20-totalSupply}.
1604      */
1605     function totalSupply() public view virtual override returns (uint256) {
1606         return _totalSupply;
1607     }
1608 
1609     /**
1610      * @dev See {IERC20-balanceOf}.
1611      */
1612     function balanceOf(address account) public view virtual override returns (uint256) {
1613         return _balances[account];
1614     }
1615 
1616     /**
1617      * @dev See {IERC20-transfer}.
1618      *
1619      * Requirements:
1620      *
1621      * - `to` cannot be the zero address.
1622      * - the caller must have a balance of at least `amount`.
1623      */
1624     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1625         address owner = _msgSender();
1626         _transfer(owner, to, amount);
1627         return true;
1628     }
1629 
1630     /**
1631      * @dev See {IERC20-allowance}.
1632      */
1633     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1634         return _allowances[owner][spender];
1635     }
1636 
1637     /**
1638      * @dev See {IERC20-approve}.
1639      *
1640      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1641      * `transferFrom`. This is semantically equivalent to an infinite approval.
1642      *
1643      * Requirements:
1644      *
1645      * - `spender` cannot be the zero address.
1646      */
1647     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1648         address owner = _msgSender();
1649         _approve(owner, spender, amount);
1650         return true;
1651     }
1652 
1653     /**
1654      * @dev See {IERC20-transferFrom}.
1655      *
1656      * Emits an {Approval} event indicating the updated allowance. This is not
1657      * required by the EIP. See the note at the beginning of {ERC20}.
1658      *
1659      * NOTE: Does not update the allowance if the current allowance
1660      * is the maximum `uint256`.
1661      *
1662      * Requirements:
1663      *
1664      * - `from` and `to` cannot be the zero address.
1665      * - `from` must have a balance of at least `amount`.
1666      * - the caller must have allowance for ``from``'s tokens of at least
1667      * `amount`.
1668      */
1669     function transferFrom(
1670         address from,
1671         address to,
1672         uint256 amount
1673     ) public virtual override returns (bool) {
1674         address spender = _msgSender();
1675         _spendAllowance(from, spender, amount);
1676         _transfer(from, to, amount);
1677         return true;
1678     }
1679 
1680     /**
1681      * @dev Atomically increases the allowance granted to `spender` by the caller.
1682      *
1683      * This is an alternative to {approve} that can be used as a mitigation for
1684      * problems described in {IERC20-approve}.
1685      *
1686      * Emits an {Approval} event indicating the updated allowance.
1687      *
1688      * Requirements:
1689      *
1690      * - `spender` cannot be the zero address.
1691      */
1692     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1693         address owner = _msgSender();
1694         _approve(owner, spender, allowance(owner, spender) + addedValue);
1695         return true;
1696     }
1697 
1698     /**
1699      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1700      *
1701      * This is an alternative to {approve} that can be used as a mitigation for
1702      * problems described in {IERC20-approve}.
1703      *
1704      * Emits an {Approval} event indicating the updated allowance.
1705      *
1706      * Requirements:
1707      *
1708      * - `spender` cannot be the zero address.
1709      * - `spender` must have allowance for the caller of at least
1710      * `subtractedValue`.
1711      */
1712     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1713         address owner = _msgSender();
1714         uint256 currentAllowance = allowance(owner, spender);
1715         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1716         unchecked {
1717             _approve(owner, spender, currentAllowance - subtractedValue);
1718         }
1719 
1720         return true;
1721     }
1722 
1723     /**
1724      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1725      *
1726      * This internal function is equivalent to {transfer}, and can be used to
1727      * e.g. implement automatic token fees, slashing mechanisms, etc.
1728      *
1729      * Emits a {Transfer} event.
1730      *
1731      * Requirements:
1732      *
1733      * - `from` cannot be the zero address.
1734      * - `to` cannot be the zero address.
1735      * - `from` must have a balance of at least `amount`.
1736      */
1737     function _transfer(
1738         address from,
1739         address to,
1740         uint256 amount
1741     ) internal virtual {
1742         require(from != address(0), "ERC20: transfer from the zero address");
1743         require(to != address(0), "ERC20: transfer to the zero address");
1744 
1745         _beforeTokenTransfer(from, to, amount);
1746 
1747         uint256 fromBalance = _balances[from];
1748         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1749         unchecked {
1750             _balances[from] = fromBalance - amount;
1751         }
1752         _balances[to] += amount;
1753 
1754         emit Transfer(from, to, amount);
1755 
1756         _afterTokenTransfer(from, to, amount);
1757     }
1758 
1759     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1760      * the total supply.
1761      *
1762      * Emits a {Transfer} event with `from` set to the zero address.
1763      *
1764      * Requirements:
1765      *
1766      * - `account` cannot be the zero address.
1767      */
1768     function _mint(address account, uint256 amount) internal virtual {
1769         require(account != address(0), "ERC20: mint to the zero address");
1770 
1771         _beforeTokenTransfer(address(0), account, amount);
1772 
1773         _totalSupply += amount;
1774         _balances[account] += amount;
1775         emit Transfer(address(0), account, amount);
1776 
1777         _afterTokenTransfer(address(0), account, amount);
1778     }
1779 
1780     /**
1781      * @dev Destroys `amount` tokens from `account`, reducing the
1782      * total supply.
1783      *
1784      * Emits a {Transfer} event with `to` set to the zero address.
1785      *
1786      * Requirements:
1787      *
1788      * - `account` cannot be the zero address.
1789      * - `account` must have at least `amount` tokens.
1790      */
1791     function _burn(address account, uint256 amount) internal virtual {
1792         require(account != address(0), "ERC20: burn from the zero address");
1793 
1794         _beforeTokenTransfer(account, address(0), amount);
1795 
1796         uint256 accountBalance = _balances[account];
1797         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1798         unchecked {
1799             _balances[account] = accountBalance - amount;
1800         }
1801         _totalSupply -= amount;
1802 
1803         emit Transfer(account, address(0), amount);
1804 
1805         _afterTokenTransfer(account, address(0), amount);
1806     }
1807 
1808     /**
1809      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1810      *
1811      * This internal function is equivalent to `approve`, and can be used to
1812      * e.g. set automatic allowances for certain subsystems, etc.
1813      *
1814      * Emits an {Approval} event.
1815      *
1816      * Requirements:
1817      *
1818      * - `owner` cannot be the zero address.
1819      * - `spender` cannot be the zero address.
1820      */
1821     function _approve(
1822         address owner,
1823         address spender,
1824         uint256 amount
1825     ) internal virtual {
1826         require(owner != address(0), "ERC20: approve from the zero address");
1827         require(spender != address(0), "ERC20: approve to the zero address");
1828 
1829         _allowances[owner][spender] = amount;
1830         emit Approval(owner, spender, amount);
1831     }
1832 
1833     /**
1834      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1835      *
1836      * Does not update the allowance amount in case of infinite allowance.
1837      * Revert if not enough allowance is available.
1838      *
1839      * Might emit an {Approval} event.
1840      */
1841     function _spendAllowance(
1842         address owner,
1843         address spender,
1844         uint256 amount
1845     ) internal virtual {
1846         uint256 currentAllowance = allowance(owner, spender);
1847         if (currentAllowance != type(uint256).max) {
1848             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1849             unchecked {
1850                 _approve(owner, spender, currentAllowance - amount);
1851             }
1852         }
1853     }
1854 
1855     /**
1856      * @dev Hook that is called before any transfer of tokens. This includes
1857      * minting and burning.
1858      *
1859      * Calling conditions:
1860      *
1861      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1862      * will be transferred to `to`.
1863      * - when `from` is zero, `amount` tokens will be minted for `to`.
1864      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1865      * - `from` and `to` are never both zero.
1866      *
1867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1868      */
1869     function _beforeTokenTransfer(
1870         address from,
1871         address to,
1872         uint256 amount
1873     ) internal virtual {}
1874 
1875     /**
1876      * @dev Hook that is called after any transfer of tokens. This includes
1877      * minting and burning.
1878      *
1879      * Calling conditions:
1880      *
1881      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1882      * has been transferred to `to`.
1883      * - when `from` is zero, `amount` tokens have been minted for `to`.
1884      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1885      * - `from` and `to` are never both zero.
1886      *
1887      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1888      */
1889     function _afterTokenTransfer(
1890         address from,
1891         address to,
1892         uint256 amount
1893     ) internal virtual {}
1894 }
1895 
1896 
1897 
1898 
1899 /** 
1900  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
1901 */
1902             
1903 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1904 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1905 
1906 pragma solidity ^0.8.0;
1907 
1908 /**
1909  * @dev Contract module that helps prevent reentrant calls to a function.
1910  *
1911  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1912  * available, which can be applied to functions to make sure there are no nested
1913  * (reentrant) calls to them.
1914  *
1915  * Note that because there is a single `nonReentrant` guard, functions marked as
1916  * `nonReentrant` may not call one another. This can be worked around by making
1917  * those functions `private`, and then adding `external` `nonReentrant` entry
1918  * points to them.
1919  *
1920  * TIP: If you would like to learn more about reentrancy and alternative ways
1921  * to protect against it, check out our blog post
1922  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1923  */
1924 abstract contract ReentrancyGuard {
1925     // Booleans are more expensive than uint256 or any type that takes up a full
1926     // word because each write operation emits an extra SLOAD to first read the
1927     // slot's contents, replace the bits taken up by the boolean, and then write
1928     // back. This is the compiler's defense against contract upgrades and
1929     // pointer aliasing, and it cannot be disabled.
1930 
1931     // The values being non-zero value makes deployment a bit more expensive,
1932     // but in exchange the refund on every call to nonReentrant will be lower in
1933     // amount. Since refunds are capped to a percentage of the total
1934     // transaction's gas, it is best to keep them low in cases like this one, to
1935     // increase the likelihood of the full refund coming into effect.
1936     uint256 private constant _NOT_ENTERED = 1;
1937     uint256 private constant _ENTERED = 2;
1938 
1939     uint256 private _status;
1940 
1941     constructor() {
1942         _status = _NOT_ENTERED;
1943     }
1944 
1945     /**
1946      * @dev Prevents a contract from calling itself, directly or indirectly.
1947      * Calling a `nonReentrant` function from another `nonReentrant`
1948      * function is not supported. It is possible to prevent this from happening
1949      * by making the `nonReentrant` function external, and making it call a
1950      * `private` function that does the actual work.
1951      */
1952     modifier nonReentrant() {
1953         // On the first call to nonReentrant, _notEntered will be true
1954         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1955 
1956         // Any calls to nonReentrant after this point will fail
1957         _status = _ENTERED;
1958 
1959         _;
1960 
1961         // By storing the original value once again, a refund is triggered (see
1962         // https://eips.ethereum.org/EIPS/eip-2200)
1963         _status = _NOT_ENTERED;
1964     }
1965 }
1966 
1967 
1968 
1969 
1970 /** 
1971  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
1972 */
1973             
1974 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1975 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1976 
1977 pragma solidity ^0.8.0;
1978 
1979 ////import "../utils/Context.sol";
1980 
1981 /**
1982  * @dev Contract module which allows children to implement an emergency stop
1983  * mechanism that can be triggered by an authorized account.
1984  *
1985  * This module is used through inheritance. It will make available the
1986  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1987  * the functions of your contract. Note that they will not be pausable by
1988  * simply including this module, only once the modifiers are put in place.
1989  */
1990 abstract contract Pausable is Context {
1991     /**
1992      * @dev Emitted when the pause is triggered by `account`.
1993      */
1994     event Paused(address account);
1995 
1996     /**
1997      * @dev Emitted when the pause is lifted by `account`.
1998      */
1999     event Unpaused(address account);
2000 
2001     bool private _paused;
2002 
2003     /**
2004      * @dev Initializes the contract in unpaused state.
2005      */
2006     constructor() {
2007         _paused = false;
2008     }
2009 
2010     /**
2011      * @dev Returns true if the contract is paused, and false otherwise.
2012      */
2013     function paused() public view virtual returns (bool) {
2014         return _paused;
2015     }
2016 
2017     /**
2018      * @dev Modifier to make a function callable only when the contract is not paused.
2019      *
2020      * Requirements:
2021      *
2022      * - The contract must not be paused.
2023      */
2024     modifier whenNotPaused() {
2025         require(!paused(), "Pausable: paused");
2026         _;
2027     }
2028 
2029     /**
2030      * @dev Modifier to make a function callable only when the contract is paused.
2031      *
2032      * Requirements:
2033      *
2034      * - The contract must be paused.
2035      */
2036     modifier whenPaused() {
2037         require(paused(), "Pausable: not paused");
2038         _;
2039     }
2040 
2041     /**
2042      * @dev Triggers stopped state.
2043      *
2044      * Requirements:
2045      *
2046      * - The contract must not be paused.
2047      */
2048     function _pause() internal virtual whenNotPaused {
2049         _paused = true;
2050         emit Paused(_msgSender());
2051     }
2052 
2053     /**
2054      * @dev Returns to normal state.
2055      *
2056      * Requirements:
2057      *
2058      * - The contract must be paused.
2059      */
2060     function _unpause() internal virtual whenPaused {
2061         _paused = false;
2062         emit Unpaused(_msgSender());
2063     }
2064 }
2065 
2066 
2067 
2068 
2069 /** 
2070  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
2071 */
2072             
2073 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
2074 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2075 
2076 pragma solidity ^0.8.0;
2077 
2078 ////import "../utils/Context.sol";
2079 
2080 /**
2081  * @dev Contract module which provides a basic access control mechanism, where
2082  * there is an account (an owner) that can be granted exclusive access to
2083  * specific functions.
2084  *
2085  * By default, the owner account will be the one that deploys the contract. This
2086  * can later be changed with {transferOwnership}.
2087  *
2088  * This module is used through inheritance. It will make available the modifier
2089  * `onlyOwner`, which can be applied to your functions to restrict their use to
2090  * the owner.
2091  */
2092 abstract contract Ownable is Context {
2093     address private _owner;
2094 
2095     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2096 
2097     /**
2098      * @dev Initializes the contract setting the deployer as the initial owner.
2099      */
2100     constructor() {
2101         _transferOwnership(_msgSender());
2102     }
2103 
2104     /**
2105      * @dev Returns the address of the current owner.
2106      */
2107     function owner() public view virtual returns (address) {
2108         return _owner;
2109     }
2110 
2111     /**
2112      * @dev Throws if called by any account other than the owner.
2113      */
2114     modifier onlyOwner() {
2115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2116         _;
2117     }
2118 
2119     /**
2120      * @dev Leaves the contract without owner. It will not be possible to call
2121      * `onlyOwner` functions anymore. Can only be called by the current owner.
2122      *
2123      * NOTE: Renouncing ownership will leave the contract without an owner,
2124      * thereby removing any functionality that is only available to the owner.
2125      */
2126     function renounceOwnership() public virtual onlyOwner {
2127         _transferOwnership(address(0));
2128     }
2129 
2130     /**
2131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2132      * Can only be called by the current owner.
2133      */
2134     function transferOwnership(address newOwner) public virtual onlyOwner {
2135         require(newOwner != address(0), "Ownable: new owner is the zero address");
2136         _transferOwnership(newOwner);
2137     }
2138 
2139     /**
2140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2141      * Internal function without access restriction.
2142      */
2143     function _transferOwnership(address newOwner) internal virtual {
2144         address oldOwner = _owner;
2145         _owner = newOwner;
2146         emit OwnershipTransferred(oldOwner, newOwner);
2147     }
2148 }
2149 
2150 
2151 
2152 
2153 /** 
2154  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
2155 */
2156             
2157 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: UNLICENSED
2158 pragma solidity ^0.8.4;
2159 
2160 interface IBullet {
2161     function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
2162 
2163     function LICENSE() external view returns (string memory);
2164 
2165     function MINTER_ROLE() external view returns (bytes32);
2166 
2167     function PAUSER_ROLE() external view returns (bytes32);
2168 
2169     function STAKING_CONTRACT_ROLE() external view returns (bytes32);
2170 
2171     function allowance(address owner_, address spender)
2172         external
2173         view
2174         returns (uint256);
2175 
2176     function approve(address spender, uint256 amount) external returns (bool);
2177 
2178     function balanceOf(address account) external view returns (uint256);
2179 
2180     function burn(uint256 amount) external;
2181 
2182     function burnFrom(address account, uint256 amount) external;
2183 
2184     function decimals() external view returns (uint8);
2185 
2186     function decreaseAllowance(address spender, uint256 subtractedValue)
2187         external
2188         returns (bool);
2189 
2190     function flipPublicSale() external;
2191 
2192     function getPublicMintPrice() external view returns (uint256);
2193 
2194     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2195 
2196     function grantRole(bytes32 role, address account) external;
2197 
2198     function hasRole(bytes32 role, address account)
2199         external
2200         view
2201         returns (bool);
2202 
2203     function increaseAllowance(address spender, uint256 addedValue)
2204         external
2205         returns (bool);
2206 
2207     function maxSupply() external view returns (uint256);
2208 
2209     function mint(uint256 amount) external;
2210 
2211     function name() external view returns (string memory);
2212 
2213     function owner() external view returns (address);
2214 
2215     function pause() external;
2216 
2217     function paused() external view returns (bool);
2218 
2219     function publicSale() external view returns (bool);
2220 
2221     function renounceOwnership() external;
2222 
2223     function renounceRole(bytes32 role, address account) external;
2224 
2225     function revokeRole(bytes32 role, address account) external;
2226 
2227     function setMaxSupply(uint256 amount) external;
2228 
2229     function setPublicMintPrice(uint256 amount) external;
2230 
2231     function stakerMint(address staker, uint256 amount) external;
2232 
2233     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2234 
2235     function symbol() external view returns (string memory);
2236 
2237     function totalSupply() external view returns (uint256);
2238 
2239     function transfer(address to, uint256 amount) external returns (bool);
2240 
2241     function transferFrom(
2242         address from,
2243         address to,
2244         uint256 amount
2245     ) external returns (bool);
2246 
2247     function transferOwnership(address newOwner) external;
2248 
2249     function transferToStaker(address staker, uint256 amount) external;
2250 
2251     function unpause() external;
2252 
2253     function withdraw() external;
2254 }
2255 
2256 
2257 /** 
2258  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/staking/contracts/OLWStaking.sol
2259 */
2260 
2261 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: UNLICENSED
2262 pragma solidity ^0.8.4;
2263 
2264 ////import "@crypto-outlaws/bullet/contracts/IBullet.sol";
2265 ////import "@openzeppelin/contracts/access/Ownable.sol";
2266 ////import "@openzeppelin/contracts/security/Pausable.sol";
2267 ////import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
2268 ////import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2269 ////import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
2270 ////import "@openzeppelin/contracts/utils/Context.sol";
2271 ////import "@openzeppelin/contracts/utils/math/SafeMath.sol";
2272 ////import "./ERC721Staking/IERC721Staking.sol";
2273 
2274 /// @title Staking
2275 /// @author New Frontiers Entertainment and Gaming LLC
2276 /// @dev staking contract
2277 /// @custom:security-contact zach@outlawsnft.io
2278 contract OLWStaking is Pausable, Ownable, ReentrancyGuard, IERC721Staking {
2279     IERC20 public immutable override rewardsToken;
2280     IERC721 public immutable override stakingToken;
2281     uint256 public override totalStaked = 0;
2282 
2283     uint256 private constant _DECIMALS = 18;
2284     uint256 private immutable _rewardInterval;
2285     uint256 private immutable _specialRewardFactor;
2286     uint256[] private _halvingCycles;
2287     uint256[] private _specialTokens;
2288 
2289     using SafeMath for uint256;
2290 
2291     struct StakedToken {
2292         address staker;
2293         uint256 tokenId;
2294     }
2295 
2296     struct Staker {
2297         StakedToken[] specialStakedTokens;
2298         StakedToken[] stakedTokens;
2299         uint256 timeOfLastUpdate;
2300         uint256 totalSpecialStaked;
2301         uint256 totalStaked;
2302         uint256 unclaimedRewards;
2303     }
2304 
2305     mapping(address => Staker) private _stakers;
2306 
2307     mapping(uint256 => address) private _stakerAddressesByTokenId;
2308 
2309     constructor(
2310         IERC721 stakingToken_,
2311         IBullet bulletToken_,
2312         uint256 rewardInterval_,
2313         uint256 halvingCycles_,
2314         uint256 specialRewardFactor_,
2315         uint256[] memory specialTokens_
2316     ) ReentrancyGuard() {
2317         require(
2318             halvingCycles_ > 0 && halvingCycles_ < 256,
2319             "halving cycles must be greater than 0 and less than 256"
2320         );
2321         require(
2322             specialRewardFactor_ >= 1,
2323             "special reward factor must be greater than or equal to 1"
2324         );
2325         _halvingCycles = new uint256[](halvingCycles_);
2326         _halvingCycles[0] = block.timestamp;
2327         _rewardInterval = rewardInterval_;
2328         rewardsToken = IERC20(address(bulletToken_));
2329         stakingToken = stakingToken_;
2330         _specialRewardFactor = specialRewardFactor_;
2331         _specialTokens = specialTokens_;
2332     }
2333 
2334     function currentRewardRate() external view returns (uint256) {
2335         return _getRewardRate(_getLastHalvingCycleIndex()) * 10**_DECIMALS;
2336     }
2337 
2338     function balanceOf(address staker_)
2339         public
2340         view
2341         override
2342         returns (uint256 balance)
2343     {
2344         return
2345             _stakers[staker_].totalStaked +
2346             _stakers[staker_].totalSpecialStaked;
2347     }
2348 
2349     function walletOf(address staker_)
2350         external
2351         view
2352         override
2353         returns (uint256[] memory tokenIds)
2354     {
2355         uint256[] memory _tokenIds = new uint256[](
2356             _stakers[staker_].totalStaked + _stakers[staker_].totalSpecialStaked
2357         );
2358         uint256 j = 0;
2359         if (_stakers[staker_].totalStaked > 0) {
2360             for (
2361                 uint256 i = 0;
2362                 i < _stakers[staker_].stakedTokens.length;
2363                 i++
2364             ) {
2365                 if (
2366                     _stakers[staker_].stakedTokens[i].staker != address(0) &&
2367                     j < _tokenIds.length
2368                 ) {
2369                     _tokenIds[j] = _stakers[staker_].stakedTokens[i].tokenId;
2370                     j++;
2371                 }
2372             }
2373         }
2374         if (_stakers[staker_].totalSpecialStaked > 0) {
2375             for (
2376                 uint256 i = 0;
2377                 i < _stakers[staker_].specialStakedTokens.length;
2378                 i++
2379             ) {
2380                 if (
2381                     _stakers[staker_].specialStakedTokens[i].staker !=
2382                     address(0) &&
2383                     j < _tokenIds.length
2384                 ) {
2385                     _tokenIds[j] = _stakers[staker_]
2386                         .specialStakedTokens[i]
2387                         .tokenId;
2388                     j++;
2389                 }
2390             }
2391         }
2392         return _tokenIds;
2393     }
2394 
2395     function ownerOf(uint256 tokenId_)
2396         external
2397         view
2398         override
2399         returns (address staker)
2400     {
2401         return _stakerAddressesByTokenId[tokenId_];
2402     }
2403 
2404     function unclaimedRewards(address staker_)
2405         external
2406         view
2407         override
2408         returns (uint256 reward)
2409     {
2410         return (_calculateRewards(staker_) +
2411             _stakers[_msgSender()].unclaimedRewards);
2412     }
2413 
2414     function deposit(uint256 tokenId_) external override nonReentrant {
2415         return _deposit(tokenId_, _msgSender());
2416     }
2417 
2418     function batchDeposit(uint256[] memory tokenIds_) external nonReentrant {
2419         require(tokenIds_.length > 0, "token ids must be greater than 0");
2420         for (uint256 i = 0; i < tokenIds_.length; i++) {
2421             _deposit(tokenIds_[i], _msgSender());
2422         }
2423     }
2424 
2425     function withdraw(uint256 tokenId_) external override nonReentrant {
2426         return _withdraw(tokenId_, _msgSender());
2427     }
2428 
2429     function batchWithdraw(uint256[] memory tokenIds_) external nonReentrant {
2430         require(tokenIds_.length > 0, "token ids must be greater than 0");
2431         for (uint256 i = 0; i < tokenIds_.length; i++) {
2432             _withdraw(tokenIds_[i], _msgSender());
2433         }
2434     }
2435 
2436     function claim() external override nonReentrant returns (uint256 rewards) {
2437         return _claim(_msgSender());
2438     }
2439 
2440     function batchWithdrawAndClaim(uint256[] memory tokenIds_)
2441         external
2442         nonReentrant
2443     {
2444         require(tokenIds_.length > 0, "token ids must be greater than 0");
2445         for (uint256 i = 0; i < tokenIds_.length; i++) {
2446             _withdraw(tokenIds_[i], _msgSender());
2447         }
2448         _claim(_msgSender());
2449     }
2450 
2451     function pause() external onlyOwner {
2452         _pause();
2453     }
2454 
2455     function unpause() external onlyOwner {
2456         _unpause();
2457     }
2458 
2459     function activateNextHalvingCycle() external onlyOwner {
2460         uint256 lastHalvingCycleIndex = _getLastHalvingCycleIndex();
2461         require(
2462             lastHalvingCycleIndex < (_halvingCycles.length - 1),
2463             "all halving cycles have been activated"
2464         );
2465         _halvingCycles[lastHalvingCycleIndex + 1] = block.timestamp;
2466     }
2467 
2468     function withdrawFor(address staker_, uint256 tokenId_) external onlyOwner {
2469         if (tokenId_ > 0) {
2470             _withdraw(tokenId_, staker_);
2471             return;
2472         }
2473         for (uint256 j = 0; j < _stakers[staker_].stakedTokens.length; j++) {
2474             if (_stakers[staker_].stakedTokens[j].staker != address(0)) {
2475                 _withdraw(_stakers[staker_].stakedTokens[j].tokenId, staker_);
2476             }
2477         }
2478         for (
2479             uint256 j = 0;
2480             j < _stakers[staker_].specialStakedTokens.length;
2481             j++
2482         ) {
2483             if (_stakers[staker_].specialStakedTokens[j].staker != address(0)) {
2484                 _withdraw(
2485                     _stakers[staker_].specialStakedTokens[j].tokenId,
2486                     staker_
2487                 );
2488             }
2489         }
2490     }
2491 
2492     function _beforeDeposit(address staker_, uint256 tokenId_)
2493         private
2494         whenNotPaused
2495     {}
2496 
2497     function _afterDeposit(address staker_, uint256 tokenId_) private {}
2498 
2499     function _beforeWithdraw(address staker_, uint256 tokenId_)
2500         private
2501         whenNotPaused
2502     {}
2503 
2504     function _afterWithdraw(address staker_, uint256 tokenId_) private {}
2505 
2506     function _beforeClaim(address staker_, uint256 rewards_)
2507         private
2508         whenNotPaused
2509     {}
2510 
2511     function _afterClaim(address staker_, uint256 rewards_) private {}
2512 
2513     function _deposit(uint256 tokenId_, address staker_) private {
2514         require(
2515             stakingToken.ownerOf(tokenId_) == staker_,
2516             "must own token to deposit"
2517         );
2518         _beforeDeposit(staker_, tokenId_);
2519         if (balanceOf(staker_) > 0) {
2520             _stakers[staker_].unclaimedRewards += _calculateRewards(staker_);
2521         }
2522         stakingToken.transferFrom(staker_, address(this), tokenId_);
2523         StakedToken memory stakedToken = StakedToken(staker_, tokenId_);
2524         if (_isSpecialToken(tokenId_)) {
2525             _stakers[staker_].specialStakedTokens.push(stakedToken);
2526             _stakers[staker_].totalSpecialStaked++;
2527         } else {
2528             _stakers[staker_].stakedTokens.push(stakedToken);
2529             _stakers[staker_].totalStaked++;
2530         }
2531         _stakers[staker_].timeOfLastUpdate = block.timestamp;
2532         _stakerAddressesByTokenId[tokenId_] = staker_;
2533         totalStaked++;
2534         _afterDeposit(staker_, tokenId_);
2535     }
2536 
2537     function _withdraw(uint256 tokenId_, address staker_) private {
2538         require(balanceOf(staker_) > 0, "must have staked token to withdraw");
2539         require(
2540             _stakerAddressesByTokenId[tokenId_] == staker_,
2541             "must own token to withdraw"
2542         );
2543         _beforeWithdraw(staker_, tokenId_);
2544         _stakers[staker_].unclaimedRewards += _calculateRewards(staker_);
2545         uint256 index = 0;
2546         if (_isSpecialToken(tokenId_)) {
2547             for (
2548                 uint256 i = 0;
2549                 i < _stakers[staker_].specialStakedTokens.length;
2550                 i++
2551             ) {
2552                 if (
2553                     _stakers[staker_].specialStakedTokens[i].tokenId ==
2554                     tokenId_ &&
2555                     _stakers[staker_].specialStakedTokens[i].staker !=
2556                     address(0)
2557                 ) {
2558                     index = i;
2559                     break;
2560                 }
2561             }
2562             _stakers[staker_].specialStakedTokens[index].staker = address(0);
2563             _stakers[staker_].totalSpecialStaked--;
2564         } else {
2565             for (
2566                 uint256 i = 0;
2567                 i < _stakers[staker_].stakedTokens.length;
2568                 i++
2569             ) {
2570                 if (
2571                     _stakers[staker_].stakedTokens[i].tokenId == tokenId_ &&
2572                     _stakers[staker_].stakedTokens[i].staker != address(0)
2573                 ) {
2574                     index = i;
2575                     break;
2576                 }
2577             }
2578             _stakers[staker_].stakedTokens[index].staker = address(0);
2579             _stakers[staker_].totalStaked--;
2580         }
2581         _stakers[staker_].timeOfLastUpdate = block.timestamp;
2582         _stakerAddressesByTokenId[tokenId_] = address(0);
2583         totalStaked--;
2584         stakingToken.transferFrom(address(this), staker_, tokenId_);
2585         _afterWithdraw(staker_, tokenId_);
2586     }
2587 
2588     function _claim(address staker_) private returns (uint256) {
2589         uint256 _rewards = (_calculateRewards(staker_) +
2590             _stakers[staker_].unclaimedRewards);
2591         require(_rewards > 0, "must have rewards to claim");
2592         _beforeClaim(staker_, _rewards);
2593         _stakers[staker_].timeOfLastUpdate = block.timestamp;
2594         _stakers[staker_].unclaimedRewards = 0;
2595         IBullet _bulletToken = IBullet(address(rewardsToken));
2596         if (_bulletToken.balanceOf(address(rewardsToken)) >= _rewards) {
2597             _bulletToken.transferToStaker(staker_, _rewards);
2598         } else {
2599             _bulletToken.stakerMint(staker_, _rewards);
2600         }
2601         _afterClaim(staker_, _rewards);
2602         return _rewards;
2603     }
2604 
2605     /**
2606      *          _____________
2607      *         /             \
2608      *    |---*--|---*----|---*----*->
2609      *    G   D  H   C    H   W    C
2610      *
2611      * G=genesis
2612      * D=deposit
2613      * H=halving
2614      * W=withdraw
2615      * C=claim
2616      */
2617     function _calculateRewards(address staker_) private view returns (uint256) {
2618         uint256 rewards = 0;
2619         uint256 timeOfLastUpdate = _stakers[staker_].timeOfLastUpdate;
2620         uint256 lastHalvingCycleIndex = _getLastHalvingCycleIndex();
2621         for (
2622             uint256 i = _getFirstHalvingCycleIndex(staker_);
2623             i <= lastHalvingCycleIndex;
2624             i++
2625         ) {
2626             if (i == lastHalvingCycleIndex) {
2627                 rewards =
2628                     rewards +
2629                     ((((block.timestamp - timeOfLastUpdate) *
2630                         (_stakers[staker_].totalStaked +
2631                             (_stakers[staker_].totalSpecialStaked *
2632                                 _specialRewardFactor)) *
2633                         _getRewardRate(i)) / _rewardInterval) * 10**_DECIMALS);
2634             } else {
2635                 rewards =
2636                     rewards +
2637                     ((((_halvingCycles[i + 1] - timeOfLastUpdate) *
2638                         (_stakers[staker_].totalStaked +
2639                             (_stakers[staker_].totalSpecialStaked *
2640                                 _specialRewardFactor)) *
2641                         _getRewardRate(i)) / _rewardInterval) * 10**_DECIMALS);
2642                 timeOfLastUpdate = _halvingCycles[i + 1];
2643             }
2644         }
2645         return rewards;
2646     }
2647 
2648     function _getFirstHalvingCycleIndex(address staker_)
2649         private
2650         view
2651         returns (uint256)
2652     {
2653         for (uint256 i = _halvingCycles.length - 1; i > 0; i--) {
2654             if (
2655                 _halvingCycles[i] != 0 &&
2656                 _stakers[staker_].timeOfLastUpdate > _halvingCycles[i]
2657             ) {
2658                 return i;
2659             }
2660         }
2661         return 0;
2662     }
2663 
2664     function _getLastHalvingCycleIndex() private view returns (uint256) {
2665         uint256 index = 0;
2666         for (uint256 i = 1; i < _halvingCycles.length; i++) {
2667             if (_halvingCycles[i] == 0) {
2668                 return index;
2669             }
2670             index = i;
2671         }
2672         return index;
2673     }
2674 
2675     function _getRewardRate(uint256 halvingCycleIndex_)
2676         private
2677         view
2678         returns (uint256)
2679     {
2680         return 2**(_halvingCycles.length - halvingCycleIndex_ - 1);
2681     }
2682 
2683     function _isSpecialToken(uint256 tokenId_) private view returns (bool) {
2684         for (uint256 i = 0; i < _specialTokens.length; i++) {
2685             if (_specialTokens[i] == tokenId_) {
2686                 return true;
2687             }
2688         }
2689         return false;
2690     }
2691 }