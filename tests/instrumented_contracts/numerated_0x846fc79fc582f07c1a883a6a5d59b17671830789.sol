1 // SPDX-License-Identifier: MIT
2 // File: contracts/cogoz.sol
3 
4 
5 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
6 // ██████╗  ██████╗  ██████╗  ██████╗ ███████╗
7 //██╔════╝ ██╔═══██╗██╔════╝ ██╔═══██╗╚══███╔╝
8 //██║  ███╗██║   ██║██║  ███╗██║   ██║  ███╔╝ 
9 //██║   ██║██║   ██║██║   ██║██║   ██║ ███╔╝  
10 //╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝███████╗
11 // ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝
12   
13 
14 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @title ERC721 token receiver interface
20  * @dev Interface for any contract that wants to support safeTransfers
21  * from ERC721 asset contracts.
22  */
23 interface IERC721Receiver {
24     /**
25      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
26      * by `operator` from `from`, this function is called.
27      *
28      * It must return its Solidity selector to confirm the token transfer.
29      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
30      *
31      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
32      */
33     function onERC721Received(
34         address operator,
35         address from,
36         uint256 tokenId,
37         bytes calldata data
38     ) external returns (bytes4);
39 }
40 
41 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
42 
43 
44 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @dev Interface of the ERC165 standard, as defined in the
50  * https://eips.ethereum.org/EIPS/eip-165[EIP].
51  *
52  * Implementers can declare support of contract interfaces, which can then be
53  * queried by others ({ERC165Checker}).
54  *
55  * For an implementation, see {ERC165}.
56  */
57 interface IERC165 {
58     /**
59      * @dev Returns true if this contract implements the interface defined by
60      * `interfaceId`. See the corresponding
61      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
62      * to learn more about how these ids are created.
63      *
64      * This function call must use less than 30 000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 
69 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 
77 /**
78  * @dev Implementation of the {IERC165} interface.
79  *
80  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
81  * for the additional interface id that will be supported. For example:
82  *
83  * ```solidity
84  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
85  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
86  * }
87  * ```
88  *
89  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
90  */
91 abstract contract ERC165 is IERC165 {
92     /**
93      * @dev See {IERC165-supportsInterface}.
94      */
95     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
96         return interfaceId == type(IERC165).interfaceId;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 interface IERC721 is IERC165 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 
253 /**
254  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
255  * @dev See https://eips.ethereum.org/EIPS/eip-721
256  */
257 interface IERC721Enumerable is IERC721 {
258     /**
259      * @dev Returns the total amount of tokens stored by the contract.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
265      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
266      */
267     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
268 
269     /**
270      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
271      * Use along with {totalSupply} to enumerate all tokens.
272      */
273     function tokenByIndex(uint256 index) external view returns (uint256);
274 }
275 
276 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
286  * @dev See https://eips.ethereum.org/EIPS/eip-721
287  */
288 interface IERC721Metadata is IERC721 {
289     /**
290      * @dev Returns the token collection name.
291      */
292     function name() external view returns (string memory);
293 
294     /**
295      * @dev Returns the token collection symbol.
296      */
297     function symbol() external view returns (string memory);
298 
299     /**
300      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
301      */
302     function tokenURI(uint256 tokenId) external view returns (string memory);
303 }
304 
305 // File: @openzeppelin/contracts/utils/Strings.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev String operations.
314  */
315 library Strings {
316     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
320      */
321     function toString(uint256 value) internal pure returns (string memory) {
322         // Inspired by OraclizeAPI's implementation - MIT licence
323         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
324 
325         if (value == 0) {
326             return "0";
327         }
328         uint256 temp = value;
329         uint256 digits;
330         while (temp != 0) {
331             digits++;
332             temp /= 10;
333         }
334         bytes memory buffer = new bytes(digits);
335         while (value != 0) {
336             digits -= 1;
337             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
338             value /= 10;
339         }
340         return string(buffer);
341     }
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
345      */
346     function toHexString(uint256 value) internal pure returns (string memory) {
347         if (value == 0) {
348             return "0x00";
349         }
350         uint256 temp = value;
351         uint256 length = 0;
352         while (temp != 0) {
353             length++;
354             temp >>= 8;
355         }
356         return toHexString(value, length);
357     }
358 
359     /**
360      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
361      */
362     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
363         bytes memory buffer = new bytes(2 * length + 2);
364         buffer[0] = "0";
365         buffer[1] = "x";
366         for (uint256 i = 2 * length + 1; i > 1; --i) {
367             buffer[i] = _HEX_SYMBOLS[value & 0xf];
368             value >>= 4;
369         }
370         require(value == 0, "Strings: hex length insufficient");
371         return string(buffer);
372     }
373 }
374 
375 // File: @openzeppelin/contracts/utils/Address.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
379 
380 pragma solidity ^0.8.1;
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      *
403      * [IMPORTANT]
404      * ====
405      * You shouldn't rely on `isContract` to protect against flash loan attacks!
406      *
407      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
408      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
409      * constructor.
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize/address.code.length, which returns 0
414         // for contracts in construction, since the code is only stored at the end
415         // of the constructor execution.
416 
417         return account.code.length > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         (bool success, ) = recipient.call{value: amount}("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain `call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(
491         address target,
492         bytes memory data,
493         uint256 value
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(address(this).balance >= value, "Address: insufficient balance for call");
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.staticcall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
573      * revert reason using the provided one.
574      *
575      * _Available since v4.3._
576      */
577     function verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) internal pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
601 
602 
603 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Interface of the ERC20 standard as defined in the EIP.
609  */
610 interface IERC20 {
611     /**
612      * @dev Emitted when `value` tokens are moved from one account (`from`) to
613      * another (`to`).
614      *
615      * Note that `value` may be zero.
616      */
617     event Transfer(address indexed from, address indexed to, uint256 value);
618 
619     /**
620      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
621      * a call to {approve}. `value` is the new allowance.
622      */
623     event Approval(address indexed owner, address indexed spender, uint256 value);
624 
625     /**
626      * @dev Returns the amount of tokens in existence.
627      */
628     function totalSupply() external view returns (uint256);
629 
630     /**
631      * @dev Returns the amount of tokens owned by `account`.
632      */
633     function balanceOf(address account) external view returns (uint256);
634 
635     /**
636      * @dev Moves `amount` tokens from the caller's account to `to`.
637      *
638      * Returns a boolean value indicating whether the operation succeeded.
639      *
640      * Emits a {Transfer} event.
641      */
642     function transfer(address to, uint256 amount) external returns (bool);
643 
644     /**
645      * @dev Returns the remaining number of tokens that `spender` will be
646      * allowed to spend on behalf of `owner` through {transferFrom}. This is
647      * zero by default.
648      *
649      * This value changes when {approve} or {transferFrom} are called.
650      */
651     function allowance(address owner, address spender) external view returns (uint256);
652 
653     /**
654      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
655      *
656      * Returns a boolean value indicating whether the operation succeeded.
657      *
658      * IMPORTANT: Beware that changing an allowance with this method brings the risk
659      * that someone may use both the old and the new allowance by unfortunate
660      * transaction ordering. One possible solution to mitigate this race
661      * condition is to first reduce the spender's allowance to 0 and set the
662      * desired value afterwards:
663      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address spender, uint256 amount) external returns (bool);
668 
669     /**
670      * @dev Moves `amount` tokens from `from` to `to` using the
671      * allowance mechanism. `amount` is then deducted from the caller's
672      * allowance.
673      *
674      * Returns a boolean value indicating whether the operation succeeded.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 amount
682     ) external returns (bool);
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 
694 /**
695  * @title SafeERC20
696  * @dev Wrappers around ERC20 operations that throw on failure (when the token
697  * contract returns false). Tokens that return no value (and instead revert or
698  * throw on failure) are also supported, non-reverting calls are assumed to be
699  * successful.
700  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
701  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
702  */
703 library SafeERC20 {
704     using Address for address;
705 
706     function safeTransfer(
707         IERC20 token,
708         address to,
709         uint256 value
710     ) internal {
711         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
712     }
713 
714     function safeTransferFrom(
715         IERC20 token,
716         address from,
717         address to,
718         uint256 value
719     ) internal {
720         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
721     }
722 
723     /**
724      * @dev Deprecated. This function has issues similar to the ones found in
725      * {IERC20-approve}, and its usage is discouraged.
726      *
727      * Whenever possible, use {safeIncreaseAllowance} and
728      * {safeDecreaseAllowance} instead.
729      */
730     function safeApprove(
731         IERC20 token,
732         address spender,
733         uint256 value
734     ) internal {
735         // safeApprove should only be called when setting an initial allowance,
736         // or when resetting it to zero. To increase and decrease it, use
737         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
738         require(
739             (value == 0) || (token.allowance(address(this), spender) == 0),
740             "SafeERC20: approve from non-zero to non-zero allowance"
741         );
742         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
743     }
744 
745     function safeIncreaseAllowance(
746         IERC20 token,
747         address spender,
748         uint256 value
749     ) internal {
750         uint256 newAllowance = token.allowance(address(this), spender) + value;
751         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
752     }
753 
754     function safeDecreaseAllowance(
755         IERC20 token,
756         address spender,
757         uint256 value
758     ) internal {
759         unchecked {
760             uint256 oldAllowance = token.allowance(address(this), spender);
761             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
762             uint256 newAllowance = oldAllowance - value;
763             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
764         }
765     }
766 
767     /**
768      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
769      * on the return value: the return value is optional (but if data is returned, it must not be false).
770      * @param token The token targeted by the call.
771      * @param data The call data (encoded using abi.encode or one of its variants).
772      */
773     function _callOptionalReturn(IERC20 token, bytes memory data) private {
774         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
775         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
776         // the target address contains contract code and also asserts for success in the low-level call.
777 
778         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
779         if (returndata.length > 0) {
780             // Return data is optional
781             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
782         }
783     }
784 }
785 
786 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 /**
794  * @dev These functions deal with verification of Merkle Trees proofs.
795  *
796  * The proofs can be generated using the JavaScript library
797  * https://github.com/miguelmota/merkletreejs[merkletreejs].
798  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
799  *
800  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
801  *
802  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
803  * hashing, or use a hash function other than keccak256 for hashing leaves.
804  * This is because the concatenation of a sorted pair of internal nodes in
805  * the merkle tree could be reinterpreted as a leaf value.
806  */
807 library MerkleProof {
808     /**
809      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
810      * defined by `root`. For this, a `proof` must be provided, containing
811      * sibling hashes on the branch from the leaf to the root of the tree. Each
812      * pair of leaves and each pair of pre-images are assumed to be sorted.
813      */
814     function verify(
815         bytes32[] memory proof,
816         bytes32 root,
817         bytes32 leaf
818     ) internal pure returns (bool) {
819         return processProof(proof, leaf) == root;
820     }
821 
822     /**
823      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
824      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
825      * hash matches the root of the tree. When processing the proof, the pairs
826      * of leafs & pre-images are assumed to be sorted.
827      *
828      * _Available since v4.4._
829      */
830     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
831         bytes32 computedHash = leaf;
832         for (uint256 i = 0; i < proof.length; i++) {
833             bytes32 proofElement = proof[i];
834             if (computedHash <= proofElement) {
835                 // Hash(current computed hash + current element of the proof)
836                 computedHash = _efficientHash(computedHash, proofElement);
837             } else {
838                 // Hash(current element of the proof + current computed hash)
839                 computedHash = _efficientHash(proofElement, computedHash);
840             }
841         }
842         return computedHash;
843     }
844 
845     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
846         assembly {
847             mstore(0x00, a)
848             mstore(0x20, b)
849             value := keccak256(0x00, 0x40)
850         }
851     }
852 }
853 
854 // File: @openzeppelin/contracts/utils/Context.sol
855 
856 
857 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev Provides information about the current execution context, including the
863  * sender of the transaction and its data. While these are generally available
864  * via msg.sender and msg.data, they should not be accessed in such a direct
865  * manner, since when dealing with meta-transactions the account sending and
866  * paying for execution may not be the actual sender (as far as an application
867  * is concerned).
868  *
869  * This contract is only required for intermediate, library-like contracts.
870  */
871 abstract contract Context {
872     function _msgSender() internal view virtual returns (address) {
873         return msg.sender;
874     }
875 
876     function _msgData() internal view virtual returns (bytes calldata) {
877         return msg.data;
878     }
879 }
880 
881 // File: contracts/ERC721A.sol
882 
883 
884 
885 pragma solidity ^0.8.0;
886 
887 
888 
889 
890 
891 
892 
893 
894 
895 /**
896  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
897  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
898  *
899  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
900  *
901  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
902  *
903  * Does not support burning tokens to address(0).
904  */
905 contract ERC721A is
906     Context,
907     ERC165,
908     IERC721,
909     IERC721Metadata,
910     IERC721Enumerable
911 {
912     using Address for address;
913     using Strings for uint256;
914 
915     struct TokenOwnership {
916         address addr;
917         uint64 startTimestamp;
918     }
919 
920     struct AddressData {
921         uint128 balance;
922         uint128 numberMinted;
923     }
924 
925     uint256 private currentIndex = 1;
926 
927     uint256 internal immutable collectionSize;
928     uint256 internal immutable maxBatchSize;
929 
930     // Token name
931     string private _name;
932 
933     // Token symbol
934     string private _symbol;
935 
936     // Mapping from token ID to ownership details
937     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
938     mapping(uint256 => TokenOwnership) private _ownerships;
939 
940     // Mapping owner address to address data
941     mapping(address => AddressData) private _addressData;
942 
943     // Mapping from token ID to approved address
944     mapping(uint256 => address) private _tokenApprovals;
945 
946     // Mapping from owner to operator approvals
947     mapping(address => mapping(address => bool)) private _operatorApprovals;
948 
949     /**
950      * @dev
951      * `maxBatchSize` refers to how much a minter can mint at a time.
952      * `collectionSize_` refers to how many tokens are in the collection.
953      */
954     constructor(
955         string memory name_,
956         string memory symbol_,
957         uint256 maxBatchSize_,
958         uint256 collectionSize_
959     ) {
960         require( collectionSize_ > 0, "ERC721A: collection must have a nonzero supply");
961         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
962         _name = name_;
963         _symbol = symbol_;
964         maxBatchSize = maxBatchSize_;
965         collectionSize = collectionSize_;
966     }
967 
968     /**
969      * @dev See {IERC721Enumerable-totalSupply}.
970      */
971     function totalSupply() public view override returns (uint256) {
972         return currentIndex;
973     }
974 
975     /**
976      * @dev See {IERC721Enumerable-tokenByIndex}.
977      */
978     function tokenByIndex(uint256 index)
979         public
980         view
981         override
982         returns (uint256)
983     {
984         require(index < totalSupply(), "ERC721A: global index out of bounds");
985         return index;
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
990      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
991      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
992      */
993     function tokenOfOwnerByIndex(address owner, uint256 index)
994         public
995         view
996         override
997         returns (uint256)
998     {
999         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1000         uint256 numMintedSoFar = totalSupply();
1001         uint256 tokenIdsIdx = 0;
1002         address currOwnershipAddr = address(0);
1003         for (uint256 i = 0; i < numMintedSoFar; i++) {
1004             TokenOwnership memory ownership = _ownerships[i];
1005             if (ownership.addr != address(0)) {
1006                 currOwnershipAddr = ownership.addr;
1007             }
1008             if (currOwnershipAddr == owner) {
1009                 if (tokenIdsIdx == index) {
1010                     return i;
1011                 }
1012                 tokenIdsIdx++;
1013             }
1014         }
1015         revert("ERC721A: unable to get token of owner by index");
1016     }
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId)
1022         public
1023         view
1024         virtual
1025         override(ERC165, IERC165)
1026         returns (bool)
1027     {
1028         return
1029             interfaceId == type(IERC721).interfaceId ||
1030             interfaceId == type(IERC721Metadata).interfaceId ||
1031             interfaceId == type(IERC721Enumerable).interfaceId ||
1032             super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-balanceOf}.
1037      */
1038     function balanceOf(address owner) public view override returns (uint256) {
1039         require(
1040             owner != address(0),
1041             "ERC721A: balance query for the zero address"
1042         );
1043         return uint256(_addressData[owner].balance);
1044     }
1045 
1046     function _numberMinted(address owner) internal view returns (uint256) {
1047         require(
1048             owner != address(0),
1049             "ERC721A: number minted query for the zero address"
1050         );
1051         return uint256(_addressData[owner].numberMinted);
1052     }
1053 
1054     function ownershipOf(uint256 tokenId)
1055         internal
1056         view
1057         returns (TokenOwnership memory)
1058     {
1059         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1060 
1061         uint256 lowestTokenToCheck;
1062         if (tokenId >= maxBatchSize) {
1063             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1064         }
1065 
1066         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1067             TokenOwnership memory ownership = _ownerships[curr];
1068             if (ownership.addr != address(0)) {
1069                 return ownership;
1070             }
1071         }
1072 
1073         revert("ERC721A: unable to determine the owner of token");
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-ownerOf}.
1078      */
1079     function ownerOf(uint256 tokenId) public view override returns (address) {
1080         return ownershipOf(tokenId).addr;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-name}.
1085      */
1086     function name() public view virtual override returns (string memory) {
1087         return _name;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Metadata-symbol}.
1092      */
1093     function symbol() public view virtual override returns (string memory) {
1094         return _symbol;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Metadata-tokenURI}.
1099      */
1100     function tokenURI(uint256 tokenId)
1101         public
1102         view
1103         virtual
1104         override
1105         returns (string memory)
1106     {
1107         require(
1108             _exists(tokenId),
1109             "ERC721Metadata: URI query for nonexistent token"
1110         );
1111 
1112         string memory baseURI = _baseURI();
1113         return
1114             bytes(baseURI).length > 0
1115                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1116                 : "";
1117     }
1118 
1119     /**
1120      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1121      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1122      * by default, can be overriden in child contracts.
1123      */
1124     function _baseURI() internal view virtual returns (string memory) {
1125         return "";
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-approve}.
1130      */
1131     function approve(address to, uint256 tokenId) public override {
1132         address owner = ERC721A.ownerOf(tokenId);
1133         require(to != owner, "ERC721A: approval to current owner");
1134 
1135         require(
1136             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1137             "ERC721A: approve caller is not owner nor approved for all"
1138         );
1139 
1140         _approve(to, tokenId, owner);
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-getApproved}.
1145      */
1146     function getApproved(uint256 tokenId)
1147         public
1148         view
1149         override
1150         returns (address)
1151     {
1152         require(
1153             _exists(tokenId),
1154             "ERC721A: approved query for nonexistent token"
1155         );
1156 
1157         return _tokenApprovals[tokenId];
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-setApprovalForAll}.
1162      */
1163     function setApprovalForAll(address operator, bool approved)
1164         public
1165         override
1166     {
1167         require(operator != _msgSender(), "ERC721A: approve to caller");
1168 
1169         _operatorApprovals[_msgSender()][operator] = approved;
1170         emit ApprovalForAll(_msgSender(), operator, approved);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-isApprovedForAll}.
1175      */
1176     function isApprovedForAll(address owner, address operator)
1177         public
1178         view
1179         virtual
1180         override
1181         returns (bool)
1182     {
1183         return _operatorApprovals[owner][operator];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-transferFrom}.
1188      */
1189     function transferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) public override {
1194         _transfer(from, to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-safeTransferFrom}.
1199      */
1200     function safeTransferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public override {
1205         safeTransferFrom(from, to, tokenId, "");
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-safeTransferFrom}.
1210      */
1211     function safeTransferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) public override {
1217         _transfer(from, to, tokenId);
1218         require(
1219             _checkOnERC721Received(from, to, tokenId, _data),
1220             "ERC721A: transfer to non ERC721Receiver implementer"
1221         );
1222     }
1223 
1224     /**
1225      * @dev Returns whether `tokenId` exists.
1226      *
1227      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1228      *
1229      * Tokens start existing when they are minted (`_mint`),
1230      */
1231     function _exists(uint256 tokenId) internal view returns (bool) {
1232         return tokenId < currentIndex;
1233     }
1234 
1235     function _safeMint(address to, uint256 quantity) internal {
1236         _safeMint(to, quantity, "");
1237     }
1238 
1239     /**
1240      * @dev Mints `quantity` tokens and transfers them to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - there must be `quantity` tokens remaining unminted in the total collection.
1245      * - `to` cannot be the zero address.
1246      * - `quantity` cannot be larger than the max batch size.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal {
1255         uint256 startTokenId = currentIndex;
1256         require(to != address(0), "ERC721A: mint to the zero address");
1257         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1258         require(!_exists(startTokenId), "ERC721A: token already minted");
1259         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1260 
1261         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1262 
1263         AddressData memory addressData = _addressData[to];
1264         _addressData[to] = AddressData(
1265             addressData.balance + uint128(quantity),
1266             addressData.numberMinted + uint128(quantity)
1267         );
1268         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1269 
1270         uint256 updatedIndex = startTokenId;
1271 
1272         for (uint256 i = 0; i < quantity; i++) {
1273             emit Transfer(address(0), to, updatedIndex);
1274             require(
1275                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1276                 "ERC721A: transfer to non ERC721Receiver implementer"
1277             );
1278             updatedIndex++;
1279         }
1280 
1281         currentIndex = updatedIndex;
1282         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1283     }
1284 
1285     /**
1286      * @dev Transfers `tokenId` from `from` to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must be owned by `from`.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _transfer(
1296         address from,
1297         address to,
1298         uint256 tokenId
1299     ) private {
1300         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1301 
1302         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1303             getApproved(tokenId) == _msgSender() ||
1304             isApprovedForAll(prevOwnership.addr, _msgSender()));
1305 
1306         require(
1307             isApprovedOrOwner,
1308             "ERC721A: transfer caller is not owner nor approved"
1309         );
1310 
1311         require(
1312             prevOwnership.addr == from,
1313             "ERC721A: transfer from incorrect owner"
1314         );
1315         require(to != address(0), "ERC721A: transfer to the zero address");
1316 
1317         _beforeTokenTransfers(from, to, tokenId, 1);
1318 
1319         // Clear approvals from the previous owner
1320         _approve(address(0), tokenId, prevOwnership.addr);
1321 
1322         _addressData[from].balance -= 1;
1323         _addressData[to].balance += 1;
1324         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1325 
1326         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1327         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1328         uint256 nextTokenId = tokenId + 1;
1329         if (_ownerships[nextTokenId].addr == address(0)) {
1330             if (_exists(nextTokenId)) {
1331                 _ownerships[nextTokenId] = TokenOwnership(
1332                     prevOwnership.addr,
1333                     prevOwnership.startTimestamp
1334                 );
1335             }
1336         }
1337 
1338         emit Transfer(from, to, tokenId);
1339         _afterTokenTransfers(from, to, tokenId, 1);
1340     }
1341 
1342     /**
1343      * @dev Approve `to` to operate on `tokenId`
1344      *
1345      * Emits a {Approval} event.
1346      */
1347     function _approve(
1348         address to,
1349         uint256 tokenId,
1350         address owner
1351     ) private {
1352         _tokenApprovals[tokenId] = to;
1353         emit Approval(owner, to, tokenId);
1354     }
1355 
1356     uint256 public nextOwnerToExplicitlySet = 0;
1357 
1358     /**
1359      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1360      */
1361     function _setOwnersExplicit(uint256 quantity) internal {
1362         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1363         require(quantity > 0, "quantity must be nonzero");
1364         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1365         if (endIndex > collectionSize - 1) {
1366             endIndex = collectionSize - 1;
1367         }
1368         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1369         require(_exists(endIndex), "not enough minted yet for this cleanup");
1370         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1371             if (_ownerships[i].addr == address(0)) {
1372                 TokenOwnership memory ownership = ownershipOf(i);
1373                 _ownerships[i] = TokenOwnership(
1374                     ownership.addr,
1375                     ownership.startTimestamp
1376                 );
1377             }
1378         }
1379         nextOwnerToExplicitlySet = endIndex + 1;
1380     }
1381 
1382     /**
1383      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1384      * The call is not executed if the target address is not a contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         if (to.isContract()) {
1399             try
1400                 IERC721Receiver(to).onERC721Received(
1401                     _msgSender(),
1402                     from,
1403                     tokenId,
1404                     _data
1405                 )
1406             returns (bytes4 retval) {
1407                 return retval == IERC721Receiver(to).onERC721Received.selector;
1408             } catch (bytes memory reason) {
1409                 if (reason.length == 0) {
1410                     revert(
1411                         "ERC721A: transfer to non ERC721Receiver implementer"
1412                     );
1413                 } else {
1414                     assembly {
1415                         revert(add(32, reason), mload(reason))
1416                     }
1417                 }
1418             }
1419         } else {
1420             return true;
1421         }
1422     }
1423 
1424     /**
1425      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1426      *
1427      * startTokenId - the first token id to be transferred
1428      * quantity - the amount to be transferred
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` will be minted for `to`.
1435      */
1436     function _beforeTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 
1443     /**
1444      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1445      * minting.
1446      *
1447      * startTokenId - the first token id to be transferred
1448      * quantity - the amount to be transferred
1449      *
1450      * Calling conditions:
1451      *
1452      * - when `from` and `to` are both non-zero.
1453      * - `from` and `to` are never both zero.
1454      */
1455     function _afterTokenTransfers(
1456         address from,
1457         address to,
1458         uint256 startTokenId,
1459         uint256 quantity
1460     ) internal virtual {}
1461 }
1462 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1463 
1464 
1465 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1466 
1467 pragma solidity ^0.8.0;
1468 
1469 
1470 
1471 
1472 /**
1473  * @title PaymentSplitter
1474  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1475  * that the Ether will be split in this way, since it is handled transparently by the contract.
1476  *
1477  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1478  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1479  * an amount proportional to the percentage of total shares they were assigned.
1480  *
1481  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1482  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1483  * function.
1484  *
1485  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1486  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1487  * to run tests before sending real value to this contract.
1488  */
1489 contract PaymentSplitter is Context {
1490     event PayeeAdded(address account, uint256 shares);
1491     event PaymentReleased(address to, uint256 amount);
1492     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1493     event PaymentReceived(address from, uint256 amount);
1494 
1495     uint256 private _totalShares;
1496     uint256 private _totalReleased;
1497 
1498     mapping(address => uint256) private _shares;
1499     mapping(address => uint256) private _released;
1500     address[] private _payees;
1501 
1502     mapping(IERC20 => uint256) private _erc20TotalReleased;
1503     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1504 
1505     /**
1506      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1507      * the matching position in the `shares` array.
1508      *
1509      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1510      * duplicates in `payees`.
1511      */
1512     constructor(address[] memory payees, uint256[] memory shares_) payable {
1513         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1514         require(payees.length > 0, "PaymentSplitter: no payees");
1515 
1516         for (uint256 i = 0; i < payees.length; i++) {
1517             _addPayee(payees[i], shares_[i]);
1518         }
1519     }
1520 
1521     /**
1522      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1523      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1524      * reliability of the events, and not the actual splitting of Ether.
1525      *
1526      * To learn more about this see the Solidity documentation for
1527      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1528      * functions].
1529      */
1530     receive() external payable virtual {
1531         emit PaymentReceived(_msgSender(), msg.value);
1532     }
1533 
1534     /**
1535      * @dev Getter for the total shares held by payees.
1536      */
1537     function totalShares() public view returns (uint256) {
1538         return _totalShares;
1539     }
1540 
1541     /**
1542      * @dev Getter for the total amount of Ether already released.
1543      */
1544     function totalReleased() public view returns (uint256) {
1545         return _totalReleased;
1546     }
1547 
1548     /**
1549      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1550      * contract.
1551      */
1552     function totalReleased(IERC20 token) public view returns (uint256) {
1553         return _erc20TotalReleased[token];
1554     }
1555 
1556     /**
1557      * @dev Getter for the amount of shares held by an account.
1558      */
1559     function shares(address account) public view returns (uint256) {
1560         return _shares[account];
1561     }
1562 
1563     /**
1564      * @dev Getter for the amount of Ether already released to a payee.
1565      */
1566     function released(address account) public view returns (uint256) {
1567         return _released[account];
1568     }
1569 
1570     /**
1571      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1572      * IERC20 contract.
1573      */
1574     function released(IERC20 token, address account) public view returns (uint256) {
1575         return _erc20Released[token][account];
1576     }
1577 
1578     /**
1579      * @dev Getter for the address of the payee number `index`.
1580      */
1581     function payee(uint256 index) public view returns (address) {
1582         return _payees[index];
1583     }
1584 
1585     /**
1586      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1587      * total shares and their previous withdrawals.
1588      */
1589     function release(address payable account) public virtual {
1590         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1591 
1592         uint256 totalReceived = address(this).balance + totalReleased();
1593         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1594 
1595         require(payment != 0, "PaymentSplitter: account is not due payment");
1596 
1597         _released[account] += payment;
1598         _totalReleased += payment;
1599 
1600         Address.sendValue(account, payment);
1601         emit PaymentReleased(account, payment);
1602     }
1603 
1604     /**
1605      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1606      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1607      * contract.
1608      */
1609     function release(IERC20 token, address account) public virtual {
1610         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1611 
1612         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1613         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1614 
1615         require(payment != 0, "PaymentSplitter: account is not due payment");
1616 
1617         _erc20Released[token][account] += payment;
1618         _erc20TotalReleased[token] += payment;
1619 
1620         SafeERC20.safeTransfer(token, account, payment);
1621         emit ERC20PaymentReleased(token, account, payment);
1622     }
1623 
1624     /**
1625      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1626      * already released amounts.
1627      */
1628     function _pendingPayment(
1629         address account,
1630         uint256 totalReceived,
1631         uint256 alreadyReleased
1632     ) private view returns (uint256) {
1633         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1634     }
1635 
1636     /**
1637      * @dev Add a new payee to the contract.
1638      * @param account The address of the payee to add.
1639      * @param shares_ The number of shares owned by the payee.
1640      */
1641     function _addPayee(address account, uint256 shares_) private {
1642         require(account != address(0), "PaymentSplitter: account is the zero address");
1643         require(shares_ > 0, "PaymentSplitter: shares are 0");
1644         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1645 
1646         _payees.push(account);
1647         _shares[account] = shares_;
1648         _totalShares = _totalShares + shares_;
1649         emit PayeeAdded(account, shares_);
1650     }
1651 }
1652 
1653 // File: @openzeppelin/contracts/access/Ownable.sol
1654 
1655 
1656 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 
1661 /**
1662  * @dev Contract module which provides a basic access control mechanism, where
1663  * there is an account (an owner) that can be granted exclusive access to
1664  * specific functions.
1665  *
1666  * By default, the owner account will be the one that deploys the contract. This
1667  * can later be changed with {transferOwnership}.
1668  *
1669  * This module is used through inheritance. It will make available the modifier
1670  * `onlyOwner`, which can be applied to your functions to restrict their use to
1671  * the owner.
1672  */
1673 abstract contract Ownable is Context {
1674     address private _owner;
1675 
1676     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1677 
1678     /**
1679      * @dev Initializes the contract setting the deployer as the initial owner.
1680      */
1681     constructor() {
1682         _transferOwnership(_msgSender());
1683     }
1684 
1685     /**
1686      * @dev Returns the address of the current owner.
1687      */
1688     function owner() public view virtual returns (address) {
1689         return _owner;
1690     }
1691 
1692     /**
1693      * @dev Throws if called by any account other than the owner.
1694      */
1695     modifier onlyOwner() {
1696         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1697         _;
1698     }
1699 
1700     /**
1701      * @dev Leaves the contract without owner. It will not be possible to call
1702      * `onlyOwner` functions anymore. Can only be called by the current owner.
1703      *
1704      * NOTE: Renouncing ownership will leave the contract without an owner,
1705      * thereby removing any functionality that is only available to the owner.
1706      */
1707     function renounceOwnership() public virtual onlyOwner {
1708         _transferOwnership(address(0));
1709     }
1710 
1711     /**
1712      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1713      * Can only be called by the current owner.
1714      */
1715     function transferOwnership(address newOwner) public virtual onlyOwner {
1716         require(newOwner != address(0), "Ownable: new owner is the zero address");
1717         _transferOwnership(newOwner);
1718     }
1719 
1720     /**
1721      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1722      * Internal function without access restriction.
1723      */
1724     function _transferOwnership(address newOwner) internal virtual {
1725         address oldOwner = _owner;
1726         _owner = newOwner;
1727         emit OwnershipTransferred(oldOwner, newOwner);
1728     }
1729 }
1730 
1731 // File: contracts/contract.sol
1732 
1733 
1734 
1735 pragma solidity ^0.8.0;
1736 
1737 // ██████╗  ██████╗  ██████╗  ██████╗ ███████╗
1738 //██╔════╝ ██╔═══██╗██╔════╝ ██╔═══██╗╚══███╔╝
1739 //██║  ███╗██║   ██║██║  ███╗██║   ██║  ███╔╝ 
1740 //██║   ██║██║   ██║██║   ██║██║   ██║ ███╔╝  
1741 //╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝███████╗
1742 // ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝
1743 
1744 
1745 contract Gogoz is ERC721A, Ownable {
1746     enum Status {
1747         Pending,
1748         Freemint,
1749         PublicSale
1750         
1751     }
1752 
1753     Status public status;
1754     string public baseURI;
1755     uint256 public immutable maxFreeMint;
1756     uint256 public immutable maxPublicMint;
1757     uint256 public immutable maxSupply;
1758     uint256 public immutable maxfreesupply = 4444;
1759     uint256 public  FreeMintPrice = 0 ether;
1760      uint256 public constant PRICE = 0.02 ether;
1761 
1762     event Minted(address minter, uint256 amount);
1763     event StatusChanged(Status status);
1764     event BaseURIChanged(string newBaseURI);
1765 
1766     modifier callerIsUser() {
1767         require(tx.origin == msg.sender, "Contract is not allowed to mint.");
1768         _;
1769     }
1770 
1771     constructor(
1772         string memory initBaseURI,
1773         uint256 _maxFreeMint,
1774         uint256 _maxPublicMint,
1775         uint256 _maxSupply
1776     )
1777         ERC721A(
1778             "Gogoz",
1779             "Gogoz",
1780             _maxFreeMint > _maxPublicMint ? _maxFreeMint : _maxPublicMint,
1781             _maxSupply
1782         )
1783     {
1784         baseURI = initBaseURI;
1785         maxFreeMint = _maxFreeMint;
1786         maxPublicMint = _maxPublicMint;
1787         maxSupply = _maxSupply;
1788     }
1789 
1790     function _baseURI() internal view override returns (string memory) {
1791         return baseURI;
1792     }
1793 
1794     function tokenURI(uint256 tokenId)
1795         public
1796         view
1797         virtual
1798         override
1799         returns (string memory)
1800     {
1801         string memory uri = super.tokenURI(tokenId);
1802         return
1803             bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1804     }
1805 
1806    
1807     function Freemint(uint256 amount)
1808         external
1809         payable
1810         callerIsUser
1811     {
1812         require(status == Status.Freemint, "Freemint is not active.");
1813          require(msg.value >= FreeMintPrice * amount, "Not enought funds.");
1814          require(amount <= maxFreeMint, "You can't mint more than 2 tokens");
1815          require(totalSupply() + amount <= maxfreesupply, "Max supply exceeded." );
1816         _safeMint(msg.sender, amount );
1817         emit Minted(msg.sender, amount);
1818     }
1819 
1820     function mint(uint256 amount) external payable callerIsUser {
1821         require(status == Status.PublicSale, "Public sale is not active.");
1822         require(amount <= maxPublicMint, "You can't mint more than 10 tokens");
1823         require(msg.value >= PRICE * amount, "Not enought funds.");
1824         require(totalSupply() + amount <= maxSupply, "Max supply exceeded." );
1825         _safeMint(msg.sender, amount);
1826         emit Minted(msg.sender, amount);
1827     }
1828 
1829 
1830     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1831         baseURI = newBaseURI;
1832         emit BaseURIChanged(newBaseURI);
1833     }
1834 
1835     function setStatus(Status _status) external onlyOwner {
1836         status = _status;
1837         emit StatusChanged(_status);
1838     }
1839 
1840     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1841         _setOwnersExplicit(quantity);
1842     }
1843 
1844     function numberMinted(address owner) public view returns (uint256) {
1845         return _numberMinted(owner);
1846     }
1847 
1848     function getOwnershipData(uint256 tokenId)
1849         external
1850         view
1851         returns (TokenOwnership memory)
1852     {
1853         return ownershipOf(tokenId);
1854     }
1855 
1856       function withdraw() public payable onlyOwner {
1857     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1858     require(success, "Withdrawal of funds failed");
1859   }
1860 }