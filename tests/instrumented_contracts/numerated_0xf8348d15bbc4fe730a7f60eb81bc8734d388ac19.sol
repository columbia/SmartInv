1 //
2 //       /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$ 
3 //      /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$
4 //     | $$  \__/| $$  \ $$| $$  \__/| $$  \__/
5 //     |  $$$$$$ | $$$$$$$$| $$ /$$$$| $$      
6 //     \____  $$| $$__  $$| $$|_  $$| $$      
7 //     /$$  \ $$| $$  | $$| $$  \ $$| $$    $$
8 //     |  $$$$$$/| $$  | $$|  $$$$$$/|  $$$$$$/
9 //     \______/ |__/  |__/ \______/  \______/ 
10 // 
11 
12 // SPDX-License-Identifier: MIT
13 
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Address.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
111 
112 pragma solidity ^0.8.1;
113 
114 /**
115  * @dev Collection of functions related to the address type
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      *
121      * [IMPORTANT]
122      * ====
123      * It is unsafe to assume that an address for which this function returns
124      * false is an externally-owned account (EOA) and not a contract.
125      *
126      * Among others, `isContract` will return false for the following
127      * types of addresses:
128      *
129      *  - an externally-owned account
130      *  - a contract in construction
131      *  - an address where a contract will be created
132      *  - an address where a contract lived, but was destroyed
133      * ====
134      *
135      * [IMPORTANT]
136      * ====
137      * You shouldn't rely on `isContract` to protect against flash loan attacks!
138      *
139      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
140      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
141      * constructor.
142      * ====
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize/address.code.length, which returns 0
146         // for contracts in construction, since the code is only stored at the end
147         // of the constructor execution.
148 
149         return account.code.length > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         (bool success, ) = recipient.call{value: amount}("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionCall(target, data, "Address: low-level call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
199      * `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, 0, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but also transferring `value` wei to `target`.
214      *
215      * Requirements:
216      *
217      * - the calling contract must have an ETH balance of at least `value`.
218      * - the called Solidity function must be `payable`.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value
226     ) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
232      * with `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(address(this).balance >= value, "Address: insufficient balance for call");
243         require(isContract(target), "Address: call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.call{value: value}(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
256         return functionStaticCall(target, data, "Address: low-level static call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(isContract(target), "Address: delegate call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
305      * revert reason using the provided one.
306      *
307      * _Available since v4.3._
308      */
309     function verifyCallResult(
310         bool success,
311         bytes memory returndata,
312         string memory errorMessage
313     ) internal pure returns (bytes memory) {
314         if (success) {
315             return returndata;
316         } else {
317             // Look for revert reason and bubble it up if present
318             if (returndata.length > 0) {
319                 // The easiest way to bubble the revert reason is using memory via assembly
320 
321                 assembly {
322                     let returndata_size := mload(returndata)
323                     revert(add(32, returndata), returndata_size)
324                 }
325             } else {
326                 revert(errorMessage);
327             }
328         }
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @title ERC721 token receiver interface
341  * @dev Interface for any contract that wants to support safeTransfers
342  * from ERC721 asset contracts.
343  */
344 interface IERC721Receiver {
345     /**
346      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
347      * by `operator` from `from`, this function is called.
348      *
349      * It must return its Solidity selector to confirm the token transfer.
350      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
351      *
352      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
353      */
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Interface of the ERC165 standard, as defined in the
371  * https://eips.ethereum.org/EIPS/eip-165[EIP].
372  *
373  * Implementers can declare support of contract interfaces, which can then be
374  * queried by others ({ERC165Checker}).
375  *
376  * For an implementation, see {ERC165}.
377  */
378 interface IERC165 {
379     /**
380      * @dev Returns true if this contract implements the interface defined by
381      * `interfaceId`. See the corresponding
382      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
383      * to learn more about how these ids are created.
384      *
385      * This function call must use less than 30 000 gas.
386      */
387     function supportsInterface(bytes4 interfaceId) external view returns (bool);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Implementation of the {IERC165} interface.
400  *
401  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
402  * for the additional interface id that will be supported. For example:
403  *
404  * ```solidity
405  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
407  * }
408  * ```
409  *
410  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
411  */
412 abstract contract ERC165 is IERC165 {
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417         return interfaceId == type(IERC165).interfaceId;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Required interface of an ERC721 compliant contract.
431  */
432 interface IERC721 is IERC165 {
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
440      */
441     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in ``owner``'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
464      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external;
481 
482     /**
483      * @dev Transfers `tokenId` token from `from` to `to`.
484      *
485      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
504      * The approval is cleared when the token is transferred.
505      *
506      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
507      *
508      * Requirements:
509      *
510      * - The caller must own the token or be an approved operator.
511      * - `tokenId` must exist.
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address to, uint256 tokenId) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Approve or remove `operator` as an operator for the caller.
528      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
540      *
541      * See {setApprovalForAll}
542      */
543     function isApprovedForAll(address owner, address operator) external view returns (bool);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must exist and be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
555      *
556      * Emits a {Transfer} event.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes calldata data
563     ) external;
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Enumerable is IERC721 {
579     /**
580      * @dev Returns the total amount of tokens stored by the contract.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
586      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
587      */
588     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
592      * Use along with {totalSupply} to enumerate all tokens.
593      */
594     function tokenByIndex(uint256 index) external view returns (uint256);
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 pragma solidity ^0.8.0;
627 
628 // CAUTION
629 // This version of SafeMath should only be used with Solidity 0.8 or later,
630 // because it relies on the compiler's built in overflow checks.
631 
632 /**
633  * @dev Wrappers over Solidity's arithmetic operations.
634  *
635  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
636  * now has built in overflow checking.
637  */
638 library SafeMath {
639     /**
640      * @dev Returns the addition of two unsigned integers, with an overflow flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             uint256 c = a + b;
647             if (c < a) return (false, 0);
648             return (true, c);
649         }
650     }
651 
652     /**
653      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
654      *
655      * _Available since v3.4._
656      */
657     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         unchecked {
659             if (b > a) return (false, 0);
660             return (true, a - b);
661         }
662     }
663 
664     /**
665      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
666      *
667      * _Available since v3.4._
668      */
669     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
670         unchecked {
671             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
672             // benefit is lost if 'b' is also tested.
673             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
674             if (a == 0) return (true, 0);
675             uint256 c = a * b;
676             if (c / a != b) return (false, 0);
677             return (true, c);
678         }
679     }
680 
681     /**
682      * @dev Returns the division of two unsigned integers, with a division by zero flag.
683      *
684      * _Available since v3.4._
685      */
686     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
687         unchecked {
688             if (b == 0) return (false, 0);
689             return (true, a / b);
690         }
691     }
692 
693     /**
694      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
695      *
696      * _Available since v3.4._
697      */
698     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
699         unchecked {
700             if (b == 0) return (false, 0);
701             return (true, a % b);
702         }
703     }
704 
705     /**
706      * @dev Returns the addition of two unsigned integers, reverting on
707      * overflow.
708      *
709      * Counterpart to Solidity's `+` operator.
710      *
711      * Requirements:
712      *
713      * - Addition cannot overflow.
714      */
715     function add(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a + b;
717     }
718 
719     /**
720      * @dev Returns the subtraction of two unsigned integers, reverting on
721      * overflow (when the result is negative).
722      *
723      * Counterpart to Solidity's `-` operator.
724      *
725      * Requirements:
726      *
727      * - Subtraction cannot overflow.
728      */
729     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a - b;
731     }
732 
733     /**
734      * @dev Returns the multiplication of two unsigned integers, reverting on
735      * overflow.
736      *
737      * Counterpart to Solidity's `*` operator.
738      *
739      * Requirements:
740      *
741      * - Multiplication cannot overflow.
742      */
743     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a * b;
745     }
746 
747     /**
748      * @dev Returns the integer division of two unsigned integers, reverting on
749      * division by zero. The result is rounded towards zero.
750      *
751      * Counterpart to Solidity's `/` operator.
752      *
753      * Requirements:
754      *
755      * - The divisor cannot be zero.
756      */
757     function div(uint256 a, uint256 b) internal pure returns (uint256) {
758         return a / b;
759     }
760 
761     /**
762      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
763      * reverting when dividing by zero.
764      *
765      * Counterpart to Solidity's `%` operator. This function uses a `revert`
766      * opcode (which leaves remaining gas untouched) while Solidity uses an
767      * invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
774         return a % b;
775     }
776 
777     /**
778      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
779      * overflow (when the result is negative).
780      *
781      * CAUTION: This function is deprecated because it requires allocating memory for the error
782      * message unnecessarily. For custom revert reasons use {trySub}.
783      *
784      * Counterpart to Solidity's `-` operator.
785      *
786      * Requirements:
787      *
788      * - Subtraction cannot overflow.
789      */
790     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
791         unchecked {
792             require(b <= a, errorMessage);
793             return a - b;
794         }
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `%` operator. This function uses a `revert`
802      * opcode (which leaves remaining gas untouched) while Solidity uses an
803      * invalid opcode to revert (consuming all remaining gas).
804      *
805      * Counterpart to Solidity's `/` operator. Note: this function uses a
806      * `revert` opcode (which leaves remaining gas untouched) while Solidity
807      * uses an invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
814         unchecked {
815             require(b > 0, errorMessage);
816             return a / b;
817         }
818     }
819 
820     /**
821      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
822      * reverting with custom message when dividing by zero.
823      *
824      * CAUTION: This function is deprecated because it requires allocating memory for the error
825      * message unnecessarily. For custom revert reasons use {tryMod}.
826      *
827      * Counterpart to Solidity's `%` operator. This function uses a `revert`
828      * opcode (which leaves remaining gas untouched) while Solidity uses an
829      * invalid opcode to revert (consuming all remaining gas).
830      *
831      * Requirements:
832      *
833      * - The divisor cannot be zero.
834      */
835     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
836         unchecked {
837             require(b > 0, errorMessage);
838             return a % b;
839         }
840     }
841 }
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Contract module which provides a basic access control mechanism, where
846  * there is an account (an owner) that can be granted exclusive access to
847  * specific functions.
848  *
849  * By default, the owner account will be the one that deploys the contract. This
850  * can later be changed with {transferOwnership}.
851  *
852  * This module is used through inheritance. It will make available the modifier
853  * `onlyOwner`, which can be applied to your functions to restrict their use to
854  * the owner.
855  */
856 abstract contract Ownable is Context {
857     address private _owner;
858 
859     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
860 
861     /**
862      * @dev Initializes the contract setting the deployer as the initial owner.
863      */
864     constructor() {
865         _transferOwnership(_msgSender());
866     }
867 
868     /**
869      * @dev Returns the address of the current owner.
870      */
871     function owner() public view virtual returns (address) {
872         return _owner;
873     }
874 
875     /**
876      * @dev Throws if called by any account other than the owner.
877      */
878     modifier onlyOwner() {
879         require(owner() == _msgSender(), "Ownable: caller is not the owner");
880         _;
881     }
882 
883     /**
884      * @dev Leaves the contract without owner. It will not be possible to call
885      * `onlyOwner` functions anymore. Can only be called by the current owner.
886      *
887      * NOTE: Renouncing ownership will leave the contract without an owner,
888      * thereby removing any functionality that is only available to the owner.
889      */
890     function renounceOwnership() public virtual onlyOwner {
891         _transferOwnership(address(0));
892     }
893 
894     /**
895      * @dev Transfers ownership of the contract to a new account (`newOwner`).
896      * Can only be called by the current owner.
897      */
898     function transferOwnership(address newOwner) public virtual onlyOwner {
899         require(newOwner != address(0), "Ownable: new owner is the zero address");
900         _transferOwnership(newOwner);
901     }
902 
903     /**
904      * @dev Transfers ownership of the contract to a new account (`newOwner`).
905      * Internal function without access restriction.
906      */
907     function _transferOwnership(address newOwner) internal virtual {
908         address oldOwner = _owner;
909         _owner = newOwner;
910         emit OwnershipTransferred(oldOwner, newOwner);
911     }
912 }
913 
914 pragma solidity ^0.8.0;
915 
916 /**
917  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
918  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
919  *
920  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
921  *
922  * Does not support burning tokens to address(0).
923  *
924  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
925  */
926 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
927     using Address for address;
928     using Strings for uint256;
929 
930     struct TokenOwnership {
931         address addr;
932         uint64 startTimestamp;
933     }
934 
935     struct AddressData {
936         uint128 balance;
937         uint128 numberMinted;
938     }
939 
940     uint256 internal currentIndex;
941 
942     // Token name
943     string private _name;
944 
945     // Token symbol
946     string private _symbol;
947 
948     // Mapping from token ID to ownership details
949     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
950     mapping(uint256 => TokenOwnership) internal _ownerships;
951 
952     // Mapping owner address to address data
953     mapping(address => AddressData) private _addressData;
954 
955     // Mapping from token ID to approved address
956     mapping(uint256 => address) private _tokenApprovals;
957 
958     // Mapping from owner to operator approvals
959     mapping(address => mapping(address => bool)) private _operatorApprovals;
960 
961     constructor(string memory name_, string memory symbol_) {
962         _name = name_;
963         _symbol = symbol_;
964     }
965 
966     /**
967      * @dev See {IERC721Enumerable-totalSupply}.
968      */
969     function totalSupply() public view override returns (uint256) {
970         return currentIndex;
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-tokenByIndex}.
975      */
976     function tokenByIndex(uint256 index) public view override returns (uint256) {
977         require(index < totalSupply(), 'ERC721A: global index out of bounds');
978         return index;
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
983      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
984      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
985      */
986     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
987         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
988         uint256 numMintedSoFar = totalSupply();
989         uint256 tokenIdsIdx;
990         address currOwnershipAddr;
991 
992         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
993         unchecked {
994             for (uint256 i; i < numMintedSoFar; i++) {
995                 TokenOwnership memory ownership = _ownerships[i];
996                 if (ownership.addr != address(0)) {
997                     currOwnershipAddr = ownership.addr;
998                 }
999                 if (currOwnershipAddr == owner) {
1000                     if (tokenIdsIdx == index) {
1001                         return i;
1002                     }
1003                     tokenIdsIdx++;
1004                 }
1005             }
1006         }
1007 
1008         revert('ERC721A: unable to get token of owner by index');
1009     }
1010 
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1015         return
1016             interfaceId == type(IERC721).interfaceId ||
1017             interfaceId == type(IERC721Metadata).interfaceId ||
1018             interfaceId == type(IERC721Enumerable).interfaceId ||
1019             super.supportsInterface(interfaceId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-balanceOf}.
1024      */
1025     function balanceOf(address owner) public view override returns (uint256) {
1026         require(owner != address(0), 'ERC721A: balance query for the zero address');
1027         return uint256(_addressData[owner].balance);
1028     }
1029 
1030     function _numberMinted(address owner) internal view returns (uint256) {
1031         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1032         return uint256(_addressData[owner].numberMinted);
1033     }
1034 
1035     /**
1036      * Gas spent here starts off proportional to the maximum mint batch size.
1037      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1038      */
1039     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1040         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1041 
1042         unchecked {
1043             for (uint256 curr = tokenId; curr >= 0; curr--) {
1044                 TokenOwnership memory ownership = _ownerships[curr];
1045                 if (ownership.addr != address(0)) {
1046                     return ownership;
1047                 }
1048             }
1049         }
1050 
1051         revert('ERC721A: unable to determine the owner of token');
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-ownerOf}.
1056      */
1057     function ownerOf(uint256 tokenId) public view override returns (address) {
1058         return ownershipOf(tokenId).addr;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-name}.
1063      */
1064     function name() public view virtual override returns (string memory) {
1065         return _name;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-symbol}.
1070      */
1071     function symbol() public view virtual override returns (string memory) {
1072         return _symbol;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Metadata-tokenURI}.
1077      */
1078     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1079         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1080 
1081         string memory baseURI = _baseURI();
1082         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1083     }
1084 
1085     /**
1086      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1087      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1088      * by default, can be overriden in child contracts.
1089      */
1090     function _baseURI() internal view virtual returns (string memory) {
1091         return '';
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-approve}.
1096      */
1097     function approve(address to, uint256 tokenId) public override {
1098         address owner = ERC721A.ownerOf(tokenId);
1099         require(to != owner, 'ERC721A: approval to current owner');
1100 
1101         require(
1102             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1103             'ERC721A: approve caller is not owner nor approved for all'
1104         );
1105 
1106         _approve(to, tokenId, owner);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-getApproved}.
1111      */
1112     function getApproved(uint256 tokenId) public view override returns (address) {
1113         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1114 
1115         return _tokenApprovals[tokenId];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-setApprovalForAll}.
1120      */
1121     function setApprovalForAll(address operator, bool approved) public override {
1122         require(operator != _msgSender(), 'ERC721A: approve to caller');
1123 
1124         _operatorApprovals[_msgSender()][operator] = approved;
1125         emit ApprovalForAll(_msgSender(), operator, approved);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-isApprovedForAll}.
1130      */
1131     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1132         return _operatorApprovals[owner][operator];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-transferFrom}.
1137      */
1138     function transferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) public virtual override {
1143         _transfer(from, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-safeTransferFrom}.
1148      */
1149     function safeTransferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) public virtual override {
1154         safeTransferFrom(from, to, tokenId, '');
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) public override {
1166         _transfer(from, to, tokenId);
1167         require(
1168             _checkOnERC721Received(from, to, tokenId, _data),
1169             'ERC721A: transfer to non ERC721Receiver implementer'
1170         );
1171     }
1172 
1173     /**
1174      * @dev Returns whether `tokenId` exists.
1175      *
1176      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1177      *
1178      * Tokens start existing when they are minted (`_mint`),
1179      */
1180     function _exists(uint256 tokenId) internal view returns (bool) {
1181         return tokenId < currentIndex;
1182     }
1183 
1184     function _safeMint(address to, uint256 quantity) internal {
1185         _safeMint(to, quantity, '');
1186     }
1187 
1188     /**
1189      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1194      * - `quantity` must be greater than 0.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 quantity,
1201         bytes memory _data
1202     ) internal {
1203         _mint(to, quantity, _data, true);
1204     }
1205 
1206     /**
1207      * @dev Mints `quantity` tokens and transfers them to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - `to` cannot be the zero address.
1212      * - `quantity` must be greater than 0.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _mint(
1217         address to,
1218         uint256 quantity,
1219         bytes memory _data,
1220         bool safe
1221     ) internal {
1222         uint256 startTokenId = currentIndex;
1223         require(to != address(0), 'ERC721A: mint to the zero address');
1224         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1225 
1226         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1227 
1228         // Overflows are incredibly unrealistic.
1229         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1230         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1231         unchecked {
1232             _addressData[to].balance += uint128(quantity);
1233             _addressData[to].numberMinted += uint128(quantity);
1234 
1235             _ownerships[startTokenId].addr = to;
1236             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1237 
1238             uint256 updatedIndex = startTokenId;
1239 
1240             for (uint256 i; i < quantity; i++) {
1241                 emit Transfer(address(0), to, updatedIndex);
1242                 if (safe) {
1243                     require(
1244                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1245                         'ERC721A: transfer to non ERC721Receiver implementer'
1246                     );
1247                 }
1248 
1249                 updatedIndex++;
1250             }
1251 
1252             currentIndex = updatedIndex;
1253         }
1254 
1255         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1256     }
1257 
1258     /**
1259      * @dev Transfers `tokenId` from `from` to `to`.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `tokenId` token must be owned by `from`.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _safeTransfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal {
1273         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1274 
1275         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1276         require(to != address(0), 'ERC721A: transfer to the zero address');
1277 
1278         _beforeTokenTransfers(from, to, tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, prevOwnership.addr);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             _addressData[from].balance -= 1;
1288             _addressData[to].balance += 1;
1289 
1290             _ownerships[tokenId].addr = to;
1291             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1292 
1293             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1294             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1295             uint256 nextTokenId = tokenId + 1;
1296             if (_ownerships[nextTokenId].addr == address(0)) {
1297                 if (_exists(nextTokenId)) {
1298                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1299                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1300                 }
1301             }
1302         }
1303 
1304         emit Transfer(from, to, tokenId);
1305         _afterTokenTransfers(from, to, tokenId, 1);
1306     }
1307 
1308     /**
1309      * @dev Transfers `tokenId` from `from` to `to`.
1310      *
1311      * Requirements:
1312      *
1313      * - `to` cannot be the zero address.
1314      * - `tokenId` token must be owned by `from`.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function _transfer(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) private {
1323         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1324 
1325         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1326             getApproved(tokenId) == _msgSender() ||
1327             isApprovedForAll(prevOwnership.addr, _msgSender()));
1328 
1329         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1330 
1331         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1332         require(to != address(0), 'ERC721A: transfer to the zero address');
1333 
1334         _beforeTokenTransfers(from, to, tokenId, 1);
1335 
1336         // Clear approvals from the previous owner
1337         _approve(address(0), tokenId, prevOwnership.addr);
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1342         unchecked {
1343             _addressData[from].balance -= 1;
1344             _addressData[to].balance += 1;
1345 
1346             _ownerships[tokenId].addr = to;
1347             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1348 
1349             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1350             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1351             uint256 nextTokenId = tokenId + 1;
1352             if (_ownerships[nextTokenId].addr == address(0)) {
1353                 if (_exists(nextTokenId)) {
1354                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1355                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(from, to, tokenId);
1361         _afterTokenTransfers(from, to, tokenId, 1);
1362     }
1363 
1364     /**
1365      * @dev Approve `to` to operate on `tokenId`
1366      *
1367      * Emits a {Approval} event.
1368      */
1369     function _approve(
1370         address to,
1371         uint256 tokenId,
1372         address owner
1373     ) private {
1374         _tokenApprovals[tokenId] = to;
1375         emit Approval(owner, to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1380      * The call is not executed if the target address is not a contract.
1381      *
1382      * @param from address representing the previous owner of the given token ID
1383      * @param to target address that will receive the tokens
1384      * @param tokenId uint256 ID of the token to be transferred
1385      * @param _data bytes optional data to send along with the call
1386      * @return bool whether the call correctly returned the expected magic value
1387      */
1388     function _checkOnERC721Received(
1389         address from,
1390         address to,
1391         uint256 tokenId,
1392         bytes memory _data
1393     ) private returns (bool) {
1394         if (to.isContract()) {
1395             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1396                 return retval == IERC721Receiver(to).onERC721Received.selector;
1397             } catch (bytes memory reason) {
1398                 if (reason.length == 0) {
1399                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1400                 } else {
1401                     assembly {
1402                         revert(add(32, reason), mload(reason))
1403                     }
1404                 }
1405             }
1406         } else {
1407             return true;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1413      *
1414      * startTokenId - the first token id to be transferred
1415      * quantity - the amount to be transferred
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      */
1423     function _beforeTokenTransfers(
1424         address from,
1425         address to,
1426         uint256 startTokenId,
1427         uint256 quantity
1428     ) internal virtual {}
1429 
1430     /**
1431      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1432      * minting.
1433      *
1434      * startTokenId - the first token id to be transferred
1435      * quantity - the amount to be transferred
1436      *
1437      * Calling conditions:
1438      *
1439      * - when `from` and `to` are both non-zero.
1440      * - `from` and `to` are never both zero.
1441      */
1442     function _afterTokenTransfers(
1443         address from,
1444         address to,
1445         uint256 startTokenId,
1446         uint256 quantity
1447     ) internal virtual {}
1448 }
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 /**
1453  * @dev Contract module that helps prevent reentrant calls to a function.
1454  *
1455  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1456  * available, which can be applied to functions to make sure there are no nested
1457  * (reentrant) calls to them.
1458  *
1459  * Note that because there is a single `nonReentrant` guard, functions marked as
1460  * `nonReentrant` may not call one another. This can be worked around by making
1461  * those functions `private`, and then adding `external` `nonReentrant` entry
1462  * points to them.
1463  *
1464  * TIP: If you would like to learn more about reentrancy and alternative ways
1465  * to protect against it, check out our blog post
1466  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1467  */
1468 abstract contract ReentrancyGuard {
1469     // Booleans are more expensive than uint256 or any type that takes up a full
1470     // word because each write operation emits an extra SLOAD to first read the
1471     // slot's contents, replace the bits taken up by the boolean, and then write
1472     // back. This is the compiler's defense against contract upgrades and
1473     // pointer aliasing, and it cannot be disabled.
1474 
1475     // The values being non-zero value makes deployment a bit more expensive,
1476     // but in exchange the refund on every call to nonReentrant will be lower in
1477     // amount. Since refunds are capped to a percentage of the total
1478     // transaction's gas, it is best to keep them low in cases like this one, to
1479     // increase the likelihood of the full refund coming into effect.
1480     uint256 private constant _NOT_ENTERED = 1;
1481     uint256 private constant _ENTERED = 2;
1482 
1483     uint256 private _status;
1484 
1485     constructor() {
1486         _status = _NOT_ENTERED;
1487     }
1488 
1489     /**
1490      * @dev Prevents a contract from calling itself, directly or indirectly.
1491      * Calling a `nonReentrant` function from another `nonReentrant`
1492      * function is not supported. It is possible to prevent this from happening
1493      * by making the `nonReentrant` function external, and make it call a
1494      * `private` function that does the actual work.
1495      */
1496     modifier nonReentrant() {
1497         // On the first call to nonReentrant, _notEntered will be true
1498         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1499 
1500         // Any calls to nonReentrant after this point will fail
1501         _status = _ENTERED;
1502 
1503         _;
1504 
1505         // By storing the original value once again, a refund is triggered (see
1506         // https://eips.ethereum.org/EIPS/eip-2200)
1507         _status = _NOT_ENTERED;
1508     }
1509 }
1510 
1511 pragma solidity ^0.8.0;
1512 
1513 contract Fore {
1514     function balanceOf(address owner) public returns (uint256) {}
1515     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
1516 }
1517 
1518 
1519 contract SkellyApeGolfClub is ERC721A, Ownable, ReentrancyGuard {
1520     using SafeMath for uint256;
1521     using Address for address;
1522     using Strings for uint256;
1523 
1524     uint256 public NFT_PRICE = 1420 * 10 ** 18; // 1420 ETH
1525     uint256 public MAX_SUPPLY = 4444;
1526     address public foreContractAddress;
1527     address public tokenVault;
1528     Fore public fore;
1529 
1530 
1531     // Faciliating the needed functionality for the presale
1532 
1533     string private _baseURIExtended;
1534     mapping (uint256 => string) _tokenURIs;
1535     mapping (uint256 => bool) _isClaimed;
1536 
1537     constructor(address _foreContractAddress, address _tokenVault, string memory _BaseURI) ERC721A("Skelly Ape Golf Club","SAGC V2"){
1538         foreContractAddress = _foreContractAddress;
1539         tokenVault = _tokenVault;
1540         fore = Fore(_foreContractAddress);
1541         _baseURIExtended= _BaseURI;
1542     } 
1543 
1544 
1545     function giveAway(address _to, uint256 _reserveAmount)
1546         public
1547         onlyOwner
1548     { 
1549         require(
1550             totalSupply().add(_reserveAmount) <= MAX_SUPPLY,
1551             "Not enough left for giveAway"
1552         );
1553         _safeMint(_to, _reserveAmount);
1554     }
1555 
1556     function mint(uint numberOfTokens) public {
1557         uint256 userBalance = fore.balanceOf(msg.sender);
1558         uint256 tokenUsedToBuyNft = numberOfTokens * NFT_PRICE;
1559         require(userBalance >= tokenUsedToBuyNft, "user can't have enough token");
1560         fore.transferFrom(msg.sender, tokenVault, tokenUsedToBuyNft);
1561         require(numberOfTokens > 0, "Number of tokens can not be less than or equal to 0");
1562         require(totalSupply().add(numberOfTokens) <= MAX_SUPPLY, "Purchase would exceed max supply of SkellyApeGolfClub");
1563             _safeMint(msg.sender, numberOfTokens);
1564     }
1565 
1566     function _baseURI() internal view virtual override returns (string memory) {
1567         return _baseURIExtended;
1568     }
1569 
1570     function setBaseURI(string memory baseURI_) external onlyOwner {
1571         _baseURIExtended = baseURI_;
1572     }
1573 
1574     function setPrice(uint256 _price) external onlyOwner {
1575         NFT_PRICE = _price * 10 ** 18;
1576     }
1577 
1578     function setTokenVault(address _tokenVault) external onlyOwner {
1579         tokenVault = _tokenVault;
1580     }
1581 
1582     function transferFrom(address from, address to, uint256 tokenId) public override nonReentrant  {
1583         ERC721A.transferFrom(from, to, tokenId);
1584     }
1585 
1586     function setForeContractAddress(address _addr) public onlyOwner(){
1587         // require(msg.sender == admin || msg.sender == owner(), "Invalid sender");
1588         foreContractAddress = _addr;
1589         fore = Fore(_addr);
1590     }
1591 
1592     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1593         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1594 
1595         string memory _tokenURI = _tokenURIs[tokenId];
1596         string memory base = _baseURI();
1597 
1598         // If there is no base URI, return the token URI.
1599         if (bytes(base).length == 0) {
1600             return _tokenURI;
1601         }
1602         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1603         if (bytes(_tokenURI).length > 0) {
1604             return string(abi.encodePacked(base, _tokenURI, '.json'));
1605         }
1606         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1607         return string(abi.encodePacked(base, tokenId.toString(), '.json'));
1608     }
1609 }