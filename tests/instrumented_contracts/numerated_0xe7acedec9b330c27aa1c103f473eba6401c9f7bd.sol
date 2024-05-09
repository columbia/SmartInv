1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 // 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
178 
179 // 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
209 
210 // 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
238 
239 // 
240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
246  * @dev See https://eips.ethereum.org/EIPS/eip-721
247  */
248 interface IERC721Enumerable is IERC721 {
249     /**
250      * @dev Returns the total amount of tokens stored by the contract.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
256      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
257      */
258     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
259 
260     /**
261      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
262      * Use along with {totalSupply} to enumerate all tokens.
263      */
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 
268 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
269 
270 // 
271 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
272 
273 pragma solidity ^0.8.1;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      *
296      * [IMPORTANT]
297      * ====
298      * You shouldn't rely on `isContract` to protect against flash loan attacks!
299      *
300      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
301      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
302      * constructor.
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize/address.code.length, which returns 0
307         // for contracts in construction, since the code is only stored at the end
308         // of the constructor execution.
309 
310         return account.code.length > 0;
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.call{value: value}(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 
494 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
495 
496 // 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Provides information about the current execution context, including the
503  * sender of the transaction and its data. While these are generally available
504  * via msg.sender and msg.data, they should not be accessed in such a direct
505  * manner, since when dealing with meta-transactions the account sending and
506  * paying for execution may not be the actual sender (as far as an application
507  * is concerned).
508  *
509  * This contract is only required for intermediate, library-like contracts.
510  */
511 abstract contract Context {
512     function _msgSender() internal view virtual returns (address) {
513         return msg.sender;
514     }
515 
516     function _msgData() internal view virtual returns (bytes calldata) {
517         return msg.data;
518     }
519 }
520 
521 
522 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
523 
524 // 
525 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 
593 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
594 
595 // 
596 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @dev Implementation of the {IERC165} interface.
602  *
603  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
604  * for the additional interface id that will be supported. For example:
605  *
606  * ```solidity
607  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
609  * }
610  * ```
611  *
612  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
613  */
614 abstract contract ERC165 is IERC165 {
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619         return interfaceId == type(IERC165).interfaceId;
620     }
621 }
622 
623 
624 // File hardhat/console.sol@v2.8.4
625 
626 // 
627 pragma solidity >= 0.4.22 <0.9.0;
628 
629 library console {
630 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
631 
632 	function _sendLogPayload(bytes memory payload) private view {
633 		uint256 payloadLength = payload.length;
634 		address consoleAddress = CONSOLE_ADDRESS;
635 		assembly {
636 			let payloadStart := add(payload, 32)
637 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
638 		}
639 	}
640 
641 	function log() internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log()"));
643 	}
644 
645 	function logInt(int p0) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
647 	}
648 
649 	function logUint(uint p0) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
651 	}
652 
653 	function logString(string memory p0) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
655 	}
656 
657 	function logBool(bool p0) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
659 	}
660 
661 	function logAddress(address p0) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
663 	}
664 
665 	function logBytes(bytes memory p0) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
667 	}
668 
669 	function logBytes1(bytes1 p0) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
671 	}
672 
673 	function logBytes2(bytes2 p0) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
675 	}
676 
677 	function logBytes3(bytes3 p0) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
679 	}
680 
681 	function logBytes4(bytes4 p0) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
683 	}
684 
685 	function logBytes5(bytes5 p0) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
687 	}
688 
689 	function logBytes6(bytes6 p0) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
691 	}
692 
693 	function logBytes7(bytes7 p0) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
695 	}
696 
697 	function logBytes8(bytes8 p0) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
699 	}
700 
701 	function logBytes9(bytes9 p0) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
703 	}
704 
705 	function logBytes10(bytes10 p0) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
707 	}
708 
709 	function logBytes11(bytes11 p0) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
711 	}
712 
713 	function logBytes12(bytes12 p0) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
715 	}
716 
717 	function logBytes13(bytes13 p0) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
719 	}
720 
721 	function logBytes14(bytes14 p0) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
723 	}
724 
725 	function logBytes15(bytes15 p0) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
727 	}
728 
729 	function logBytes16(bytes16 p0) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
731 	}
732 
733 	function logBytes17(bytes17 p0) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
735 	}
736 
737 	function logBytes18(bytes18 p0) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
739 	}
740 
741 	function logBytes19(bytes19 p0) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
743 	}
744 
745 	function logBytes20(bytes20 p0) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
747 	}
748 
749 	function logBytes21(bytes21 p0) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
751 	}
752 
753 	function logBytes22(bytes22 p0) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
755 	}
756 
757 	function logBytes23(bytes23 p0) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
759 	}
760 
761 	function logBytes24(bytes24 p0) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
763 	}
764 
765 	function logBytes25(bytes25 p0) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
767 	}
768 
769 	function logBytes26(bytes26 p0) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
771 	}
772 
773 	function logBytes27(bytes27 p0) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
775 	}
776 
777 	function logBytes28(bytes28 p0) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
779 	}
780 
781 	function logBytes29(bytes29 p0) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
783 	}
784 
785 	function logBytes30(bytes30 p0) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
787 	}
788 
789 	function logBytes31(bytes31 p0) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
791 	}
792 
793 	function logBytes32(bytes32 p0) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
795 	}
796 
797 	function log(uint p0) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
799 	}
800 
801 	function log(string memory p0) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
803 	}
804 
805 	function log(bool p0) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
807 	}
808 
809 	function log(address p0) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
811 	}
812 
813 	function log(uint p0, uint p1) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
815 	}
816 
817 	function log(uint p0, string memory p1) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
819 	}
820 
821 	function log(uint p0, bool p1) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
823 	}
824 
825 	function log(uint p0, address p1) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
827 	}
828 
829 	function log(string memory p0, uint p1) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
831 	}
832 
833 	function log(string memory p0, string memory p1) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
835 	}
836 
837 	function log(string memory p0, bool p1) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
839 	}
840 
841 	function log(string memory p0, address p1) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
843 	}
844 
845 	function log(bool p0, uint p1) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
847 	}
848 
849 	function log(bool p0, string memory p1) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
851 	}
852 
853 	function log(bool p0, bool p1) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
855 	}
856 
857 	function log(bool p0, address p1) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
859 	}
860 
861 	function log(address p0, uint p1) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
863 	}
864 
865 	function log(address p0, string memory p1) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
867 	}
868 
869 	function log(address p0, bool p1) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
871 	}
872 
873 	function log(address p0, address p1) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
875 	}
876 
877 	function log(uint p0, uint p1, uint p2) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
879 	}
880 
881 	function log(uint p0, uint p1, string memory p2) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
883 	}
884 
885 	function log(uint p0, uint p1, bool p2) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
887 	}
888 
889 	function log(uint p0, uint p1, address p2) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
891 	}
892 
893 	function log(uint p0, string memory p1, uint p2) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
895 	}
896 
897 	function log(uint p0, string memory p1, string memory p2) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
899 	}
900 
901 	function log(uint p0, string memory p1, bool p2) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
903 	}
904 
905 	function log(uint p0, string memory p1, address p2) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
907 	}
908 
909 	function log(uint p0, bool p1, uint p2) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
911 	}
912 
913 	function log(uint p0, bool p1, string memory p2) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
915 	}
916 
917 	function log(uint p0, bool p1, bool p2) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
919 	}
920 
921 	function log(uint p0, bool p1, address p2) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
923 	}
924 
925 	function log(uint p0, address p1, uint p2) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
927 	}
928 
929 	function log(uint p0, address p1, string memory p2) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
931 	}
932 
933 	function log(uint p0, address p1, bool p2) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
935 	}
936 
937 	function log(uint p0, address p1, address p2) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
939 	}
940 
941 	function log(string memory p0, uint p1, uint p2) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
943 	}
944 
945 	function log(string memory p0, uint p1, string memory p2) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
947 	}
948 
949 	function log(string memory p0, uint p1, bool p2) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
951 	}
952 
953 	function log(string memory p0, uint p1, address p2) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
955 	}
956 
957 	function log(string memory p0, string memory p1, uint p2) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
959 	}
960 
961 	function log(string memory p0, string memory p1, string memory p2) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
963 	}
964 
965 	function log(string memory p0, string memory p1, bool p2) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
967 	}
968 
969 	function log(string memory p0, string memory p1, address p2) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
971 	}
972 
973 	function log(string memory p0, bool p1, uint p2) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
975 	}
976 
977 	function log(string memory p0, bool p1, string memory p2) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
979 	}
980 
981 	function log(string memory p0, bool p1, bool p2) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
983 	}
984 
985 	function log(string memory p0, bool p1, address p2) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
987 	}
988 
989 	function log(string memory p0, address p1, uint p2) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
991 	}
992 
993 	function log(string memory p0, address p1, string memory p2) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
995 	}
996 
997 	function log(string memory p0, address p1, bool p2) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
999 	}
1000 
1001 	function log(string memory p0, address p1, address p2) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1003 	}
1004 
1005 	function log(bool p0, uint p1, uint p2) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1007 	}
1008 
1009 	function log(bool p0, uint p1, string memory p2) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1011 	}
1012 
1013 	function log(bool p0, uint p1, bool p2) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1015 	}
1016 
1017 	function log(bool p0, uint p1, address p2) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1019 	}
1020 
1021 	function log(bool p0, string memory p1, uint p2) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1023 	}
1024 
1025 	function log(bool p0, string memory p1, string memory p2) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1027 	}
1028 
1029 	function log(bool p0, string memory p1, bool p2) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1031 	}
1032 
1033 	function log(bool p0, string memory p1, address p2) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1035 	}
1036 
1037 	function log(bool p0, bool p1, uint p2) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1039 	}
1040 
1041 	function log(bool p0, bool p1, string memory p2) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1043 	}
1044 
1045 	function log(bool p0, bool p1, bool p2) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1047 	}
1048 
1049 	function log(bool p0, bool p1, address p2) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1051 	}
1052 
1053 	function log(bool p0, address p1, uint p2) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1055 	}
1056 
1057 	function log(bool p0, address p1, string memory p2) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1059 	}
1060 
1061 	function log(bool p0, address p1, bool p2) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1063 	}
1064 
1065 	function log(bool p0, address p1, address p2) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1067 	}
1068 
1069 	function log(address p0, uint p1, uint p2) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1071 	}
1072 
1073 	function log(address p0, uint p1, string memory p2) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1075 	}
1076 
1077 	function log(address p0, uint p1, bool p2) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1079 	}
1080 
1081 	function log(address p0, uint p1, address p2) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1083 	}
1084 
1085 	function log(address p0, string memory p1, uint p2) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1087 	}
1088 
1089 	function log(address p0, string memory p1, string memory p2) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1091 	}
1092 
1093 	function log(address p0, string memory p1, bool p2) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1095 	}
1096 
1097 	function log(address p0, string memory p1, address p2) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1099 	}
1100 
1101 	function log(address p0, bool p1, uint p2) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1103 	}
1104 
1105 	function log(address p0, bool p1, string memory p2) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1107 	}
1108 
1109 	function log(address p0, bool p1, bool p2) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1111 	}
1112 
1113 	function log(address p0, bool p1, address p2) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1115 	}
1116 
1117 	function log(address p0, address p1, uint p2) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1119 	}
1120 
1121 	function log(address p0, address p1, string memory p2) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1123 	}
1124 
1125 	function log(address p0, address p1, bool p2) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1127 	}
1128 
1129 	function log(address p0, address p1, address p2) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1131 	}
1132 
1133 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(uint p0, uint p1, address p2, address p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(uint p0, bool p1, address p2, address p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(uint p0, address p1, uint p2, address p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(uint p0, address p1, bool p2, address p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(uint p0, address p1, address p2, uint p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(uint p0, address p1, address p2, bool p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(uint p0, address p1, address p2, address p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1571 	}
1572 
1573 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1575 	}
1576 
1577 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1579 	}
1580 
1581 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1583 	}
1584 
1585 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1587 	}
1588 
1589 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1591 	}
1592 
1593 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1595 	}
1596 
1597 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1599 	}
1600 
1601 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1603 	}
1604 
1605 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1607 	}
1608 
1609 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1611 	}
1612 
1613 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1615 	}
1616 
1617 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1619 	}
1620 
1621 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1623 	}
1624 
1625 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1627 	}
1628 
1629 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1631 	}
1632 
1633 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1635 	}
1636 
1637 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1639 	}
1640 
1641 	function log(string memory p0, address p1, address p2, address p3) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1643 	}
1644 
1645 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1647 	}
1648 
1649 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1651 	}
1652 
1653 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1655 	}
1656 
1657 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1659 	}
1660 
1661 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1663 	}
1664 
1665 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1667 	}
1668 
1669 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1671 	}
1672 
1673 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1675 	}
1676 
1677 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1679 	}
1680 
1681 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1683 	}
1684 
1685 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1687 	}
1688 
1689 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1691 	}
1692 
1693 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1695 	}
1696 
1697 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1699 	}
1700 
1701 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1703 	}
1704 
1705 	function log(bool p0, uint p1, address p2, address p3) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1707 	}
1708 
1709 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1711 	}
1712 
1713 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1715 	}
1716 
1717 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1719 	}
1720 
1721 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1723 	}
1724 
1725 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1727 	}
1728 
1729 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1731 	}
1732 
1733 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1735 	}
1736 
1737 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1739 	}
1740 
1741 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1743 	}
1744 
1745 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1747 	}
1748 
1749 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1751 	}
1752 
1753 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1755 	}
1756 
1757 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1759 	}
1760 
1761 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1763 	}
1764 
1765 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1767 	}
1768 
1769 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1771 	}
1772 
1773 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1775 	}
1776 
1777 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1779 	}
1780 
1781 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1783 	}
1784 
1785 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1787 	}
1788 
1789 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1791 	}
1792 
1793 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1795 	}
1796 
1797 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(bool p0, bool p1, address p2, address p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1843 	}
1844 
1845 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1847 	}
1848 
1849 	function log(bool p0, address p1, uint p2, address p3) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1851 	}
1852 
1853 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1855 	}
1856 
1857 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1859 	}
1860 
1861 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1863 	}
1864 
1865 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(bool p0, address p1, bool p2, address p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(bool p0, address p1, address p2, uint p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(bool p0, address p1, address p2, bool p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(bool p0, address p1, address p2, address p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(address p0, uint p1, uint p2, address p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(address p0, uint p1, bool p2, address p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(address p0, uint p1, address p2, uint p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(address p0, uint p1, address p2, bool p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(address p0, uint p1, address p2, address p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(address p0, string memory p1, address p2, address p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(address p0, bool p1, uint p2, address p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(address p0, bool p1, bool p2, address p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(address p0, bool p1, address p2, uint p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(address p0, bool p1, address p2, bool p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(address p0, bool p1, address p2, address p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(address p0, address p1, uint p2, uint p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(address p0, address p1, uint p2, bool p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(address p0, address p1, uint p2, address p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(address p0, address p1, string memory p2, address p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(address p0, address p1, bool p2, uint p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(address p0, address p1, bool p2, bool p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(address p0, address p1, bool p2, address p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(address p0, address p1, address p2, uint p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(address p0, address p1, address p2, string memory p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(address p0, address p1, address p2, bool p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(address p0, address p1, address p2, address p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2155 	}
2156 
2157 }
2158 
2159 
2160 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
2161 
2162 // 
2163 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
2164 
2165 pragma solidity ^0.8.0;
2166 
2167 // CAUTION
2168 // This version of SafeMath should only be used with Solidity 0.8 or later,
2169 // because it relies on the compiler's built in overflow checks.
2170 
2171 /**
2172  * @dev Wrappers over Solidity's arithmetic operations.
2173  *
2174  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2175  * now has built in overflow checking.
2176  */
2177 library SafeMath {
2178     /**
2179      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2180      *
2181      * _Available since v3.4._
2182      */
2183     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2184         unchecked {
2185             uint256 c = a + b;
2186             if (c < a) return (false, 0);
2187             return (true, c);
2188         }
2189     }
2190 
2191     /**
2192      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2193      *
2194      * _Available since v3.4._
2195      */
2196     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2197         unchecked {
2198             if (b > a) return (false, 0);
2199             return (true, a - b);
2200         }
2201     }
2202 
2203     /**
2204      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2205      *
2206      * _Available since v3.4._
2207      */
2208     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2209         unchecked {
2210             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2211             // benefit is lost if 'b' is also tested.
2212             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2213             if (a == 0) return (true, 0);
2214             uint256 c = a * b;
2215             if (c / a != b) return (false, 0);
2216             return (true, c);
2217         }
2218     }
2219 
2220     /**
2221      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2222      *
2223      * _Available since v3.4._
2224      */
2225     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2226         unchecked {
2227             if (b == 0) return (false, 0);
2228             return (true, a / b);
2229         }
2230     }
2231 
2232     /**
2233      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2234      *
2235      * _Available since v3.4._
2236      */
2237     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2238         unchecked {
2239             if (b == 0) return (false, 0);
2240             return (true, a % b);
2241         }
2242     }
2243 
2244     /**
2245      * @dev Returns the addition of two unsigned integers, reverting on
2246      * overflow.
2247      *
2248      * Counterpart to Solidity's `+` operator.
2249      *
2250      * Requirements:
2251      *
2252      * - Addition cannot overflow.
2253      */
2254     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2255         return a + b;
2256     }
2257 
2258     /**
2259      * @dev Returns the subtraction of two unsigned integers, reverting on
2260      * overflow (when the result is negative).
2261      *
2262      * Counterpart to Solidity's `-` operator.
2263      *
2264      * Requirements:
2265      *
2266      * - Subtraction cannot overflow.
2267      */
2268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2269         return a - b;
2270     }
2271 
2272     /**
2273      * @dev Returns the multiplication of two unsigned integers, reverting on
2274      * overflow.
2275      *
2276      * Counterpart to Solidity's `*` operator.
2277      *
2278      * Requirements:
2279      *
2280      * - Multiplication cannot overflow.
2281      */
2282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2283         return a * b;
2284     }
2285 
2286     /**
2287      * @dev Returns the integer division of two unsigned integers, reverting on
2288      * division by zero. The result is rounded towards zero.
2289      *
2290      * Counterpart to Solidity's `/` operator.
2291      *
2292      * Requirements:
2293      *
2294      * - The divisor cannot be zero.
2295      */
2296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2297         return a / b;
2298     }
2299 
2300     /**
2301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2302      * reverting when dividing by zero.
2303      *
2304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2305      * opcode (which leaves remaining gas untouched) while Solidity uses an
2306      * invalid opcode to revert (consuming all remaining gas).
2307      *
2308      * Requirements:
2309      *
2310      * - The divisor cannot be zero.
2311      */
2312     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2313         return a % b;
2314     }
2315 
2316     /**
2317      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2318      * overflow (when the result is negative).
2319      *
2320      * CAUTION: This function is deprecated because it requires allocating memory for the error
2321      * message unnecessarily. For custom revert reasons use {trySub}.
2322      *
2323      * Counterpart to Solidity's `-` operator.
2324      *
2325      * Requirements:
2326      *
2327      * - Subtraction cannot overflow.
2328      */
2329     function sub(
2330         uint256 a,
2331         uint256 b,
2332         string memory errorMessage
2333     ) internal pure returns (uint256) {
2334         unchecked {
2335             require(b <= a, errorMessage);
2336             return a - b;
2337         }
2338     }
2339 
2340     /**
2341      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2342      * division by zero. The result is rounded towards zero.
2343      *
2344      * Counterpart to Solidity's `/` operator. Note: this function uses a
2345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2346      * uses an invalid opcode to revert (consuming all remaining gas).
2347      *
2348      * Requirements:
2349      *
2350      * - The divisor cannot be zero.
2351      */
2352     function div(
2353         uint256 a,
2354         uint256 b,
2355         string memory errorMessage
2356     ) internal pure returns (uint256) {
2357         unchecked {
2358             require(b > 0, errorMessage);
2359             return a / b;
2360         }
2361     }
2362 
2363     /**
2364      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2365      * reverting with custom message when dividing by zero.
2366      *
2367      * CAUTION: This function is deprecated because it requires allocating memory for the error
2368      * message unnecessarily. For custom revert reasons use {tryMod}.
2369      *
2370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2371      * opcode (which leaves remaining gas untouched) while Solidity uses an
2372      * invalid opcode to revert (consuming all remaining gas).
2373      *
2374      * Requirements:
2375      *
2376      * - The divisor cannot be zero.
2377      */
2378     function mod(
2379         uint256 a,
2380         uint256 b,
2381         string memory errorMessage
2382     ) internal pure returns (uint256) {
2383         unchecked {
2384             require(b > 0, errorMessage);
2385             return a % b;
2386         }
2387     }
2388 }
2389 
2390 
2391 // File contracts/NFT.sol
2392 
2393 error ApprovalCallerNotOwnerNorApproved();
2394 error ApprovalQueryForNonexistentToken();
2395 error ApproveToCaller();
2396 error ApprovalToCurrentOwner();
2397 error BalanceQueryForZeroAddress();
2398 error MintedQueryForZeroAddress();
2399 error BurnedQueryForZeroAddress();
2400 error MintToZeroAddress();
2401 error MintZeroQuantity();
2402 error OwnerIndexOutOfBounds();
2403 error OwnerQueryForNonexistentToken();
2404 error TokenIndexOutOfBounds();
2405 error TransferCallerNotOwnerNorApproved();
2406 error TransferFromIncorrectOwner();
2407 error TransferToNonERC721ReceiverImplementer();
2408 error TransferToZeroAddress();
2409 error URIQueryForNonexistentToken();
2410 /**
2411  *Submitted for verification at Etherscan.io on 2021-04-22
2412 */
2413 
2414 // File: @openzeppelin/contracts/utils/Context.sol
2415 
2416 // 
2417 
2418 pragma solidity >=0.6.0 <= 0.8.4;
2419 
2420 /*
2421  * @dev Provides information about the current execution context, including the
2422  * sender of the transaction and its data. While these are generally available
2423  * via msg.sender and msg.data, they should not be accessed in such a direct
2424  * manner, since when dealing with GSN meta-transactions the account sending and
2425  * paying for execution may not be the actual sender (as far as an application
2426  * is concerned).
2427  *
2428  * This contract is only required for intermediate, library-like contracts.
2429  */
2430 
2431    
2432 // Creator: Chiru Labs
2433 
2434 pragma solidity ^0.8.4;
2435 
2436 /**
2437  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2438  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
2439  *
2440  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
2441  *
2442  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2443  *
2444  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2445  */
2446 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2447     using Address for address;
2448     using Strings for uint256;
2449 
2450     // Compiler will pack this into a single 256bit word.
2451     struct TokenOwnership {
2452         // The address of the owner.
2453         address addr;
2454         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2455         uint64 startTimestamp;
2456         // Whether the token has been burned.
2457         bool burned;
2458     }
2459 
2460     // Compiler will pack this into a single 256bit word.
2461     struct AddressData {
2462         // Realistically, 2**64-1 is more than enough.
2463         uint64 balance;
2464         // Keeps track of mint count with minimal overhead for tokenomics.
2465         uint64 numberMinted;
2466         // Keeps track of burn count with minimal overhead for tokenomics.
2467         uint64 numberBurned;
2468     }
2469 
2470     // The tokenId of the next token to be minted.
2471     uint256 internal _currentIndex;
2472 
2473     // The number of tokens burned.
2474     uint256 internal _burnCounter;
2475 
2476     // Token name
2477     string private _name;
2478 
2479     // Token symbol
2480     string private _symbol;
2481 
2482     // Mapping from token ID to ownership details
2483     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
2484     mapping(uint256 => TokenOwnership) internal _ownerships;
2485 
2486     // Mapping owner address to address data
2487     mapping(address => AddressData) private _addressData;
2488 
2489     // Mapping from token ID to approved address
2490     mapping(uint256 => address) private _tokenApprovals;
2491 
2492     // Mapping from owner to operator approvals
2493     mapping(address => mapping(address => bool)) private _operatorApprovals;
2494 
2495     constructor(string memory name_, string memory symbol_) {
2496         _name = name_;
2497         _symbol = symbol_;
2498     }
2499 
2500     /**
2501      * @dev See {IERC721Enumerable-totalSupply}.
2502      */
2503     function totalSupply() public view returns (uint256) {
2504         // Counter underflow is impossible as _burnCounter cannot be incremented
2505         // more than _currentIndex times
2506         unchecked {
2507             return _currentIndex - _burnCounter;    
2508         }
2509     }
2510 
2511     /**
2512      * @dev See {IERC165-supportsInterface}.
2513      */
2514     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2515         return
2516             interfaceId == type(IERC721).interfaceId ||
2517             interfaceId == type(IERC721Metadata).interfaceId ||
2518             super.supportsInterface(interfaceId);
2519     }
2520 
2521     /**
2522      * @dev See {IERC721-balanceOf}.
2523      */
2524     function balanceOf(address owner) public view override returns (uint256) {
2525         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2526         return uint256(_addressData[owner].balance);
2527     }
2528 
2529     function _numberMinted(address owner) internal view returns (uint256) {
2530         if (owner == address(0)) revert MintedQueryForZeroAddress();
2531         return uint256(_addressData[owner].numberMinted);
2532     }
2533 
2534     function _numberBurned(address owner) internal view returns (uint256) {
2535         if (owner == address(0)) revert BurnedQueryForZeroAddress();
2536         return uint256(_addressData[owner].numberBurned);
2537     }
2538 
2539     /**
2540      * Gas spent here starts off proportional to the maximum mint batch size.
2541      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2542      */
2543     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2544         uint256 curr = tokenId;
2545 
2546         unchecked {
2547             if (curr < _currentIndex) {
2548                 TokenOwnership memory ownership = _ownerships[curr];
2549                 if (!ownership.burned) {
2550                     if (ownership.addr != address(0)) {
2551                         return ownership;
2552                     }
2553                     // Invariant: 
2554                     // There will always be an ownership that has an address and is not burned 
2555                     // before an ownership that does not have an address and is not burned.
2556                     // Hence, curr will not underflow.
2557                     while (true) {
2558                         curr--;
2559                         ownership = _ownerships[curr];
2560                         if (ownership.addr != address(0)) {
2561                             return ownership;
2562                         }
2563                     }
2564                 }
2565             }
2566         }
2567         revert OwnerQueryForNonexistentToken();
2568     }
2569 
2570     /**
2571      * @dev See {IERC721-ownerOf}.
2572      */
2573     function ownerOf(uint256 tokenId) public view override returns (address) {
2574         return ownershipOf(tokenId).addr;
2575     }
2576 
2577     /**
2578      * @dev See {IERC721Metadata-name}.
2579      */
2580     function name() public view virtual override returns (string memory) {
2581         return _name;
2582     }
2583 
2584     /**
2585      * @dev See {IERC721Metadata-symbol}.
2586      */
2587     function symbol() public view virtual override returns (string memory) {
2588         return _symbol;
2589     }
2590 
2591     /**
2592      * @dev See {IERC721Metadata-tokenURI}.
2593      */
2594     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2595         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2596 
2597         string memory baseURI = _baseURI();
2598         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2599     }
2600 
2601     /**
2602      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2603      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2604      * by default, can be overriden in child contracts.
2605      */
2606     function _baseURI() internal view virtual returns (string memory) {
2607         return '';
2608     }
2609 
2610     /**
2611      * @dev See {IERC721-approve}.
2612      */
2613     function approve(address to, uint256 tokenId) public override {
2614         address owner = ERC721A.ownerOf(tokenId);
2615         if (to == owner) revert ApprovalToCurrentOwner();
2616 
2617         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2618             revert ApprovalCallerNotOwnerNorApproved();
2619         }
2620 
2621         _approve(to, tokenId, owner);
2622     }
2623 
2624     /**
2625      * @dev See {IERC721-getApproved}.
2626      */
2627     function getApproved(uint256 tokenId) public view override returns (address) {
2628         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2629 
2630         return _tokenApprovals[tokenId];
2631     }
2632 
2633     /**
2634      * @dev See {IERC721-setApprovalForAll}.
2635      */
2636     function setApprovalForAll(address operator, bool approved) public override {
2637         if (operator == _msgSender()) revert ApproveToCaller();
2638 
2639         _operatorApprovals[_msgSender()][operator] = approved;
2640         emit ApprovalForAll(_msgSender(), operator, approved);
2641     }
2642 
2643     /**
2644      * @dev See {IERC721-isApprovedForAll}.
2645      */
2646     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2647         return _operatorApprovals[owner][operator];
2648     }
2649 
2650     /**
2651      * @dev See {IERC721-transferFrom}.
2652      */
2653     function transferFrom(
2654         address from,
2655         address to,
2656         uint256 tokenId
2657     ) public virtual override {
2658         _transfer(from, to, tokenId);
2659     }
2660 
2661     /**
2662      * @dev See {IERC721-safeTransferFrom}.
2663      */
2664     function safeTransferFrom(
2665         address from,
2666         address to,
2667         uint256 tokenId
2668     ) public virtual override {
2669         safeTransferFrom(from, to, tokenId, '');
2670     }
2671 
2672     /**
2673      * @dev See {IERC721-safeTransferFrom}.
2674      */
2675     function safeTransferFrom(
2676         address from,
2677         address to,
2678         uint256 tokenId,
2679         bytes memory _data
2680     ) public virtual override {
2681         _transfer(from, to, tokenId);
2682         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
2683             revert TransferToNonERC721ReceiverImplementer();
2684         }
2685     }
2686 
2687     /**
2688      * @dev Returns whether `tokenId` exists.
2689      *
2690      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2691      *
2692      * Tokens start existing when they are minted (`_mint`),
2693      */
2694     function _exists(uint256 tokenId) internal view returns (bool) {
2695         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
2696     }
2697 
2698     function _safeMint(address to, uint256 quantity) internal {
2699         _safeMint(to, quantity, '');
2700     }
2701 
2702     /**
2703      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2704      *
2705      * Requirements:
2706      *
2707      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2708      * - `quantity` must be greater than 0.
2709      *
2710      * Emits a {Transfer} event.
2711      */
2712     function _safeMint(
2713         address to,
2714         uint256 quantity,
2715         bytes memory _data
2716     ) internal {
2717         _mint(to, quantity, _data, true);
2718     }
2719 
2720     /**
2721      * @dev Mints `quantity` tokens and transfers them to `to`.
2722      *
2723      * Requirements:
2724      *
2725      * - `to` cannot be the zero address.
2726      * - `quantity` must be greater than 0.
2727      *
2728      * Emits a {Transfer} event.
2729      */
2730     function _mint(
2731         address to,
2732         uint256 quantity,
2733         bytes memory _data,
2734         bool safe
2735     ) internal {
2736         uint256 startTokenId = _currentIndex;
2737         if (to == address(0)) revert MintToZeroAddress();
2738         if (quantity == 0) revert MintZeroQuantity();
2739 
2740         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2741 
2742         // Overflows are incredibly unrealistic.
2743         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2744         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2745         unchecked {
2746             _addressData[to].balance += uint64(quantity);
2747             _addressData[to].numberMinted += uint64(quantity);
2748 
2749             _ownerships[startTokenId].addr = to;
2750             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2751 
2752             uint256 updatedIndex = startTokenId;
2753 
2754             for (uint256 i; i < quantity; i++) {
2755                 emit Transfer(address(0), to, updatedIndex);
2756                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
2757                     revert TransferToNonERC721ReceiverImplementer();
2758                 }
2759                 updatedIndex++;
2760             }
2761 
2762             _currentIndex = updatedIndex;
2763         }
2764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2765     }
2766 
2767     /**
2768      * @dev Transfers `tokenId` from `from` to `to`.
2769      *
2770      * Requirements:
2771      *
2772      * - `to` cannot be the zero address.
2773      * - `tokenId` token must be owned by `from`.
2774      *
2775      * Emits a {Transfer} event.
2776      */
2777     function _transfer(
2778         address from,
2779         address to,
2780         uint256 tokenId
2781     ) private {
2782         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2783 
2784         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2785             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
2786             getApproved(tokenId) == _msgSender());
2787 
2788         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2789         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2790         if (to == address(0)) revert TransferToZeroAddress();
2791 
2792         _beforeTokenTransfers(from, to, tokenId, 1);
2793 
2794         // Clear approvals from the previous owner
2795         _approve(address(0), tokenId, prevOwnership.addr);
2796 
2797         // Underflow of the sender's balance is impossible because we check for
2798         // ownership above and the recipient's balance can't realistically overflow.
2799         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2800         unchecked {
2801             _addressData[from].balance -= 1;
2802             _addressData[to].balance += 1;
2803 
2804             _ownerships[tokenId].addr = to;
2805             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2806 
2807             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2808             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2809             uint256 nextTokenId = tokenId + 1;
2810             if (_ownerships[nextTokenId].addr == address(0)) {
2811                 // This will suffice for checking _exists(nextTokenId),
2812                 // as a burned slot cannot contain the zero address.
2813                 if (nextTokenId < _currentIndex) {
2814                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2815                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2816                 }
2817             }
2818         }
2819 
2820         emit Transfer(from, to, tokenId);
2821         _afterTokenTransfers(from, to, tokenId, 1);
2822     }
2823 
2824     /**
2825      * @dev Destroys `tokenId`.
2826      * The approval is cleared when the token is burned.
2827      *
2828      * Requirements:
2829      *
2830      * - `tokenId` must exist.
2831      *
2832      * Emits a {Transfer} event.
2833      */
2834     function _burn(uint256 tokenId) internal virtual {
2835         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2836 
2837         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2838 
2839         // Clear approvals from the previous owner
2840         _approve(address(0), tokenId, prevOwnership.addr);
2841 
2842         // Underflow of the sender's balance is impossible because we check for
2843         // ownership above and the recipient's balance can't realistically overflow.
2844         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2845         unchecked {
2846             _addressData[prevOwnership.addr].balance -= 1;
2847             _addressData[prevOwnership.addr].numberBurned += 1;
2848 
2849             // Keep track of who burned the token, and the timestamp of burning.
2850             _ownerships[tokenId].addr = prevOwnership.addr;
2851             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2852             _ownerships[tokenId].burned = true;
2853 
2854             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2855             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2856             uint256 nextTokenId = tokenId + 1;
2857             if (_ownerships[nextTokenId].addr == address(0)) {
2858                 // This will suffice for checking _exists(nextTokenId),
2859                 // as a burned slot cannot contain the zero address.
2860                 if (nextTokenId < _currentIndex) {
2861                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2862                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2863                 }
2864             }
2865         }
2866 
2867         emit Transfer(prevOwnership.addr, address(0), tokenId);
2868         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2869 
2870         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2871         unchecked { 
2872             _burnCounter++;
2873         }
2874     }
2875 
2876     /**
2877      * @dev Approve `to` to operate on `tokenId`
2878      *
2879      * Emits a {Approval} event.
2880      */
2881     function _approve(
2882         address to,
2883         uint256 tokenId,
2884         address owner
2885     ) private {
2886         _tokenApprovals[tokenId] = to;
2887         emit Approval(owner, to, tokenId);
2888     }
2889 
2890     /**
2891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2892      * The call is not executed if the target address is not a contract.
2893      *
2894      * @param from address representing the previous owner of the given token ID
2895      * @param to target address that will receive the tokens
2896      * @param tokenId uint256 ID of the token to be transferred
2897      * @param _data bytes optional data to send along with the call
2898      * @return bool whether the call correctly returned the expected magic value
2899      */
2900     function _checkOnERC721Received(
2901         address from,
2902         address to,
2903         uint256 tokenId,
2904         bytes memory _data
2905     ) private returns (bool) {
2906         if (to.isContract()) {
2907             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2908                 return retval == IERC721Receiver(to).onERC721Received.selector;
2909             } catch (bytes memory reason) {
2910                 if (reason.length == 0) {
2911                     revert TransferToNonERC721ReceiverImplementer();
2912                 } else {
2913                     assembly {
2914                         revert(add(32, reason), mload(reason))
2915                     }
2916                 }
2917             }
2918         } else {
2919             return true;
2920         }
2921     }
2922 
2923     /**
2924      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2925      * And also called before burning one token.
2926      *
2927      * startTokenId - the first token id to be transferred
2928      * quantity - the amount to be transferred
2929      *
2930      * Calling conditions:
2931      *
2932      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2933      * transferred to `to`.
2934      * - When `from` is zero, `tokenId` will be minted for `to`.
2935      * - When `to` is zero, `tokenId` will be burned by `from`.
2936      * - `from` and `to` are never both zero.
2937      */
2938     function _beforeTokenTransfers(
2939         address from,
2940         address to,
2941         uint256 startTokenId,
2942         uint256 quantity
2943     ) internal virtual {}
2944 
2945     /**
2946      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2947      * minting.
2948      * And also called after one token has been burned.
2949      *
2950      * startTokenId - the first token id to be transferred
2951      * quantity - the amount to be transferred
2952      *
2953      * Calling conditions:
2954      *
2955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2956      * transferred to `to`.
2957      * - When `from` is zero, `tokenId` has been minted for `to`.
2958      * - When `to` is zero, `tokenId` has been burned by `from`.
2959      * - `from` and `to` are never both zero.
2960      */
2961     function _afterTokenTransfers(
2962         address from,
2963         address to,
2964         uint256 startTokenId,
2965         uint256 quantity
2966     ) internal virtual {}
2967 }
2968 
2969 // File: @openzeppelin/contracts/access/Ownable.sol
2970 
2971 abstract contract ReentrancyGuard {
2972     // Booleans are more expensive than uint256 or any type that takes up a full
2973     // word because each write operation emits an extra SLOAD to first read the
2974     // slot's contents, replace the bits taken up by the boolean, and then write
2975     // back. This is the compiler's defense against contract upgrades and
2976     // pointer aliasing, and it cannot be disabled.
2977 
2978     // The values being non-zero value makes deployment a bit more expensive,
2979     // but in exchange the refund on every call to nonReentrant will be lower in
2980     // amount. Since refunds are capped to a percentage of the total
2981     // transaction's gas, it is best to keep them low in cases like this one, to
2982     // increase the likelihood of the full refund coming into effect.
2983     uint256 private constant _NOT_ENTERED = 1;
2984     uint256 private constant _ENTERED = 2;
2985 
2986     uint256 private _status;
2987 
2988     constructor() {
2989         _status = _NOT_ENTERED;
2990     }
2991 
2992     /**
2993      * @dev Prevents a contract from calling itself, directly or indirectly.
2994      * Calling a `nonReentrant` function from another `nonReentrant`
2995      * function is not supported. It is possible to prevent this from happening
2996      * by making the `nonReentrant` function external, and making it call a
2997      * `private` function that does the actual work.
2998      */
2999     modifier nonReentrant() {
3000         // On the first call to nonReentrant, _notEntered will be true
3001         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
3002 
3003         // Any calls to nonReentrant after this point will fail
3004         _status = _ENTERED;
3005 
3006         _;
3007 
3008         // By storing the original value once again, a refund is triggered (see
3009         // https://eips.ethereum.org/EIPS/eip-2200)
3010         _status = _NOT_ENTERED;
3011     }
3012 }
3013 
3014 
3015 pragma solidity >=0.6.0 <= 0.8.4;
3016 
3017 /**
3018  * @dev Contract module which provides a basic access control mechanism, where
3019  * there is an account (an owner) that can be granted exclusive access to
3020  * specific functions.
3021  *
3022  * By default, the owner account will be the one that deploys the contract. This
3023  * can later be changed with {transferOwnership}.
3024  *
3025  * This module is used through inheritance. It will make available the modifier
3026  * `onlyOwner`, which can be applied to your functions to restrict their use to
3027  * the owner.
3028  */
3029 abstract contract Ownable is Context {
3030     address private _owner;
3031 
3032     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3033 
3034     /**
3035      * @dev Initializes the contract setting the deployer as the initial owner.
3036      */
3037     constructor () {
3038         address msgSender = _msgSender();
3039         _owner = msgSender;
3040         emit OwnershipTransferred(address(0), msgSender);
3041     }
3042 
3043     /**
3044      * @dev Returns the address of the current owner.
3045      */
3046     function owner() public view virtual returns (address) {
3047         return _owner;
3048     }
3049 
3050     /**
3051      * @dev Throws if called by any account other than the owner.
3052      */
3053     modifier onlyOwner() {
3054         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3055         _;
3056     }
3057 
3058     /**
3059      * @dev Leaves the contract without owner. It will not be possible to call
3060      * `onlyOwner` functions anymore. Can only be called by the current owner.
3061      *
3062      * NOTE: Renouncing ownership will leave the contract without an owner,
3063      * thereby removing any functionality that is only available to the owner.
3064      */
3065     function renounceOwnership() public virtual onlyOwner {
3066         emit OwnershipTransferred(_owner, address(0));
3067         _owner = address(0);
3068     }
3069 
3070     /**
3071      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3072      * Can only be called by the current owner.
3073      */
3074     function transferOwnership(address newOwner) public virtual onlyOwner {
3075         require(newOwner != address(0), "Ownable: new owner is the zero address");
3076         emit OwnershipTransferred(_owner, newOwner);
3077         _owner = newOwner;
3078     }
3079 }
3080 
3081 // File: contracts/NFT.sol
3082 
3083 
3084 pragma solidity ^0.8.4;
3085 /**
3086  * @title NFT contract
3087  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
3088  */
3089 contract NFT is ERC721A, Ownable, ReentrancyGuard {
3090     using SafeMath for uint256;
3091     using Strings for uint256;
3092 
3093     bool public preSaleActive = false;
3094     bool public publicSaleActive = false;
3095 
3096     bool public paused = true;
3097     bool public revealed = false;
3098 
3099     string public NETWORK_PROVENANCE = "";
3100     string public notRevealedUri;
3101 
3102     uint256 public maxSupply; // 2500
3103     uint256 public maxAirDropSupply; // 100
3104     uint256 public currentAirDropSupply; 
3105     uint256 public preSalePrice; //0.05 ETH --> 50000000000000000
3106     uint256 public publicSalePrice; //0.05 ETH --> 50000000000000000
3107 
3108     uint public maxPurchase; // 2
3109     uint public maxPurchaseOG; // 4
3110     uint public publicPurchase; // 5
3111     string private _baseURIextended;
3112 
3113     mapping(address => bool) public isWhiteListed;
3114     mapping(address => bool) public isWhiteListedOG;
3115 
3116     constructor(string memory name, string memory symbol, uint256 _maxSupply, uint256 _publicPurchase, uint256 _maxPurchase, uint256 _maxPurchaseOG, uint256 _preSalePrice, uint256 _publicSalePrice, uint256 _maxAirDropSupply) ERC721A(name, symbol) ReentrancyGuard() {
3117         maxSupply = _maxSupply;
3118         preSalePrice = _preSalePrice;
3119         publicSalePrice = _publicSalePrice;
3120         publicPurchase = _publicPurchase;
3121         maxPurchase = _maxPurchase;
3122         maxPurchaseOG = _maxPurchaseOG;
3123         maxAirDropSupply = _maxAirDropSupply;
3124     }
3125 
3126     function preSaleMint(uint256 _amount)external payable nonReentrant{
3127 
3128         require(preSaleActive, "NFT:Pre-sale is not active");
3129         require(isWhiteListed[msg.sender], "NFT:Sender is not whitelisted");
3130         mint(_amount, true);
3131     }
3132 
3133     function publicSaleMint(uint256 _amount)external payable nonReentrant{
3134         require(publicSaleActive, "NFT:Public-sale is not active");
3135         mint(_amount, false);
3136     }
3137 
3138     function mint(uint256 _amount, bool _state)internal{
3139         require(!paused, "NFT: contract is paused");
3140         require(totalSupply().add(_amount) <= maxSupply, "NFT: minting would exceed total supply");
3141         if(publicSaleActive){
3142             require(balanceOf(msg.sender).add(_amount) <= publicPurchase, "NFT-Public: You can't mint any more tokens");
3143         }
3144         else{
3145             if(isWhiteListedOG[msg.sender]){
3146                 require(balanceOf(msg.sender).add(_amount) <= maxPurchaseOG, "NFT-OG: You can't mint any more tokens");
3147             }
3148             else{
3149                 require(balanceOf(msg.sender).add(_amount) <= maxPurchase, "NFT: You can't mint any more tokens");
3150             }
3151         }
3152         if(_state){
3153             require(preSalePrice.mul(_amount) <= msg.value, "NFT: Ether value sent for presale mint is not correct");
3154         }
3155         else{
3156             require(publicSalePrice.mul(_amount) <= msg.value, "NFT: Ether value sent for public mint is not correct");
3157         }
3158         uint mintIndex = totalSupply();
3159         for (uint256 ind = 1; ind <= _amount; ind++) {
3160             mintIndex.add(ind);
3161         }
3162          _safeMint(msg.sender, _amount);
3163     }
3164 
3165     function getTotalSupply() public view returns (uint){
3166         return totalSupply();
3167     }
3168 
3169     function _baseURI() internal view virtual override returns (string memory) {
3170         return _baseURIextended;
3171     }
3172 
3173     function setBaseURI(string calldata baseURI_) external onlyOwner {
3174         _baseURIextended = baseURI_;
3175     }
3176 
3177 
3178     function addWhiteListedAddresses(address[] memory _address) external onlyOwner {
3179         for (uint256 i = 0; i < _address.length; i++) {
3180             require(!isWhiteListed[_address[i]], "NFT: address is already white listed");
3181             isWhiteListed[_address[i]] = true;
3182         }
3183     }
3184     function addWhiteListedAddressesOG(address[] memory _address) external onlyOwner {
3185         for (uint256 i = 0; i < _address.length; i++) {
3186             require(!isWhiteListedOG[_address[i]], "NFT: address is already OG listed");
3187             isWhiteListed[_address[i]] = true;
3188             isWhiteListedOG[_address[i]] = true;
3189         }
3190     }
3191 
3192     function togglePauseState() external onlyOwner {
3193         paused = !paused;
3194     }
3195 
3196     function togglePreSale()external onlyOwner {
3197         preSaleActive = !preSaleActive;
3198     }
3199 
3200     function setPreSalePrice(uint256 _preSalePrice)external onlyOwner {
3201         preSalePrice = _preSalePrice;
3202     }
3203 
3204     function togglePublicSale()external onlyOwner {
3205         publicSaleActive = !publicSaleActive;
3206     }
3207 
3208     function setPublicSalePrice(uint256 _publicSalePrice)external onlyOwner {
3209         publicSalePrice = _publicSalePrice;
3210     }
3211 
3212     function airDrop(address[] memory _address)external onlyOwner{
3213         uint256 mintIndex = totalSupply();
3214         require(currentAirDropSupply + _address.length <= maxAirDropSupply, "NFT: Maximum Air Drop Limit Reached");
3215         require(mintIndex.add(_address.length) <= maxSupply, "NFT: minting would exceed total supply");
3216         for(uint256 i = 0; i < _address.length; i++){
3217             mintIndex.add(i);
3218             _safeMint(_address[i],1);
3219         }
3220         currentAirDropSupply += _address.length;
3221     }
3222 
3223     function reveal() external onlyOwner {
3224         revealed = true;
3225     }
3226 
3227     function withdraw() external onlyOwner {
3228         uint balance = address(this).balance;
3229         payable(msg.sender).transfer(balance);
3230     }
3231     /*     
3232     * Set provenance once it's calculated
3233     */
3234     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
3235         NETWORK_PROVENANCE = provenanceHash;
3236     }
3237 
3238     function tokenURI(uint256 tokenId)
3239         public
3240         view
3241         virtual
3242         override
3243         returns (string memory)
3244     {
3245         require(
3246             _exists(tokenId),
3247             "ERC721Metadata: URI query for nonexistent token"
3248         );
3249         if (revealed == false) {
3250             return notRevealedUri;
3251         }
3252         tokenId+=1;
3253         string memory currentBaseURI = _baseURI();
3254         return
3255             bytes(currentBaseURI).length > 0
3256                 ? string(
3257                     abi.encodePacked(
3258                         currentBaseURI,
3259                         tokenId.toString(),
3260                         ".json"
3261                     )
3262                 )
3263                 : "";
3264     }
3265     
3266     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
3267         notRevealedUri = _notRevealedURI;
3268     }
3269 
3270 }