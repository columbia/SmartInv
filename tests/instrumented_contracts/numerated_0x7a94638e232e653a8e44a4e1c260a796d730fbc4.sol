1 // SPDX-License-Identifier: MIT
2 
3 // ................................................................................
4 //       ..........................................................................
5 //         ............8888........................................................
6 //           ..........8::8............888888888888................................
7 //               .......888.........88D~~~~~~~~~~~~88..............................
8 //                 ......88........8~~~~~~~~~~~~~~~~~DD............................
9 // ......................888...~8:~8~~~~~~~~~~~~~~~~~~~~8..........................
10 // ........................8...888D~~~~~~~~~~~~~~~~~~~~~8..........................
11 // ........................8.8D~~~~~~~~~~~~~~~~~~~~~~~~~~88........................
12 // ........................88~~~~~~~~~~~~~~~~~~~~~~~~~~~~88........................
13 // ........................:8~~~~~~~~~~~~~888888N~~~~~~~~88........................
14 // ........................8~~~~~~~~..:8888D..:8888D8~:~~8D........................
15 // ........................8~~~~~~~88................888~~~8.......................
16 // ........................8~~~~~888..................:8~~~8.......................
17 // ........................8~~~~~88....:88........88..:88~~8.......................
18 // ................    ...:8~~~~88D....8  8......8  8..:8~~8.......................
19 // ............:.         .8~~~~8......8  8......8  8..:8~~8.......................
20 // ............           .8~~~~888....8  8......8  8..:8~~8.......................
21 // ............           .8~~~~~88....:88~......:88..:88~~8.......................
22 // ............           .8~~~~~888................:888~~~8.......................
23 // ........               .8~~~~~~~88..............:88:~~~~8.......................
24 // ........               .8~~~~~~~~8888888......8888~~~~~~8.......................
25 // ........:...............8~~~~~~~~~~~8~DDDDDDDDD~~~~~~~~~8.......................
26 // ........................8~~~~~~~~~~~8~~~~~~~~~~~~~~~~~~~8.......................
27 // .........................8~~~~~~~~~~8~~~:D8DDDDDD~~~~~88........................
28 // .........................8888~~~~~~~~8~~~~D8..8D~~~~~888........................
29 // .........................8===D8D~~~~~8~~~~~~88~~~~~~88..........................
30 // .........................8==D===888D~8~~~~~~~~~~8888=8..........................
31 // .........................8==D=======++88++++++++=====8..........................
32 // ........................88==D=========88=============8..........................
33 // ......................88==88D=========88============8=88........................
34 // .....................8=====+8888=====8==========8888====8.......................
35 // ....................D====888====8888888888888888========88......................
36 // ..................88===+D8=========+88======++++++88O++==8......................
37 // .................8?===88==========88=888888888++++++=8====88D...................
38 // .................8===888=========8===8================88===+8...................
39 // .................8===8===========8===888========8..8==88===+8...................
40 // ................8==+88==========8=====88========8..88=88=====8..................
41 // ................8==+D===========D=====88========88..8=888====8..................
42 // ................8==+D=========88======88=========+8.8==+8====8..................
43 // ................8=88=========888======88===============+8====D88................
44 // ................8=88=========8===88888D8===============+8=====88................
45 // ................8=88=========8888D8D=D=8===============+8=====88................
46 // ................8=88=========8=+DDD====================+8=====88................
47 // ................8=88========8888=======================+8=====88................
48 // ................8=88========88=========================+8=====88................
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Interface of the ERC165 standard, as defined in the
54  * https://eips.ethereum.org/EIPS/eip-165[EIP].
55  *
56  * Implementers can declare support of contract interfaces, which can then be
57  * queried by others ({ERC165Checker}).
58  *
59  * For an implementation, see {ERC165}.
60  */
61 interface IERC165 {
62 	/**
63 	 * @dev Returns true if this contract implements the interface defined by
64 	 * `interfaceId`. See the corresponding
65 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
66 	 * to learn more about how these ids are created.
67 	 *
68 	 * This function call must use less than 30 000 gas.
69 	 */
70 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
71 }
72 
73 
74 
75 
76 
77 /**
78  * @dev Required interface of an ERC721 compliant contract.
79  */
80 interface IERC721 is IERC165 {
81 	/**
82 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
83 	 */
84 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85 
86 	/**
87 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
88 	 */
89 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
90 
91 	/**
92 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
93 	 */
94 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
95 
96 	/**
97 	 * @dev Returns the number of tokens in ``owner``'s account.
98 	 */
99 	function balanceOf(address owner) external view returns (uint256 balance);
100 
101 	/**
102 	 * @dev Returns the owner of the `tokenId` token.
103 	 *
104 	 * Requirements:
105 	 *
106 	 * - `tokenId` must exist.
107 	 */
108 	function ownerOf(uint256 tokenId) external view returns (address owner);
109 
110 	/**
111 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
112 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
113 	 *
114 	 * Requirements:
115 	 *
116 	 * - `from` cannot be the zero address.
117 	 * - `to` cannot be the zero address.
118 	 * - `tokenId` token must exist and be owned by `from`.
119 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
120 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
121 	 *
122 	 * Emits a {Transfer} event.
123 	 */
124 	function safeTransferFrom(
125 		address from,
126 		address to,
127 		uint256 tokenId
128 	) external;
129 
130 	/**
131 	 * @dev Transfers `tokenId` token from `from` to `to`.
132 	 *
133 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
134 	 *
135 	 * Requirements:
136 	 *
137 	 * - `from` cannot be the zero address.
138 	 * - `to` cannot be the zero address.
139 	 * - `tokenId` token must be owned by `from`.
140 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
141 	 *
142 	 * Emits a {Transfer} event.
143 	 */
144 	function transferFrom(
145 		address from,
146 		address to,
147 		uint256 tokenId
148 	) external;
149 
150 	/**
151 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
152 	 * The approval is cleared when the token is transferred.
153 	 *
154 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
155 	 *
156 	 * Requirements:
157 	 *
158 	 * - The caller must own the token or be an approved operator.
159 	 * - `tokenId` must exist.
160 	 *
161 	 * Emits an {Approval} event.
162 	 */
163 	function approve(address to, uint256 tokenId) external;
164 
165 	/**
166 	 * @dev Returns the account approved for `tokenId` token.
167 	 *
168 	 * Requirements:
169 	 *
170 	 * - `tokenId` must exist.
171 	 */
172 	function getApproved(uint256 tokenId) external view returns (address operator);
173 
174 	/**
175 	 * @dev Approve or remove `operator` as an operator for the caller.
176 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
177 	 *
178 	 * Requirements:
179 	 *
180 	 * - The `operator` cannot be the caller.
181 	 *
182 	 * Emits an {ApprovalForAll} event.
183 	 */
184 	function setApprovalForAll(address operator, bool _approved) external;
185 
186 	/**
187 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
188 	 *
189 	 * See {setApprovalForAll}
190 	 */
191 	function isApprovedForAll(address owner, address operator) external view returns (bool);
192 
193 	/**
194 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
195 	 *
196 	 * Requirements:
197 	 *
198 	 * - `from` cannot be the zero address.
199 	 * - `to` cannot be the zero address.
200 	 * - `tokenId` token must exist and be owned by `from`.
201 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203 	 *
204 	 * Emits a {Transfer} event.
205 	 */
206 	function safeTransferFrom(
207 		address from,
208 		address to,
209 		uint256 tokenId,
210 		bytes calldata data
211 	) external;
212 }
213 
214 
215 
216 
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  * from ERC721 asset contracts.
222  */
223 interface IERC721Receiver {
224 	/**
225 	 * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
226 	 * by `operator` from `from`, this function is called.
227 	 *
228 	 * It must return its Solidity selector to confirm the token transfer.
229 	 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
230 	 *
231 	 * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
232 	 */
233 	function onERC721Received(
234 		address operator,
235 		address from,
236 		uint256 tokenId,
237 		bytes calldata data
238 	) external returns (bytes4);
239 }
240 
241 
242 
243 
244 
245 /**
246  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
247  * @dev See https://eips.ethereum.org/EIPS/eip-721
248  */
249 interface IERC721Metadata is IERC721 {
250 	/**
251 	 * @dev Returns the token collection name.
252 	 */
253 	function name() external view returns (string memory);
254 
255 	/**
256 	 * @dev Returns the token collection symbol.
257 	 */
258 	function symbol() external view returns (string memory);
259 
260 	/**
261 	 * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
262 	 */
263 	function tokenURI(uint256 tokenId) external view returns (string memory);
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 
269 
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275 	/**
276 	 * @dev Returns true if `account` is a contract.
277 	 *
278 	 * [IMPORTANT]
279 	 * ====
280 	 * It is unsafe to assume that an address for which this function returns
281 	 * false is an externally-owned account (EOA) and not a contract.
282 	 *
283 	 * Among others, `isContract` will return false for the following
284 	 * types of addresses:
285 	 *
286 	 *  - an externally-owned account
287 	 *  - a contract in construction
288 	 *  - an address where a contract will be created
289 	 *  - an address where a contract lived, but was destroyed
290 	 * ====
291 	 *
292 	 * [IMPORTANT]
293 	 * ====
294 	 * You shouldn't rely on `isContract` to protect against flash loan attacks!
295 	 *
296 	 * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
297 	 * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
298 	 * constructor.
299 	 * ====
300 	 */
301 	function isContract(address account) internal view returns (bool) {
302 		// This method relies on extcodesize/address.code.length, which returns 0
303 		// for contracts in construction, since the code is only stored at the end
304 		// of the constructor execution.
305 
306 		return account.code.length > 0;
307 	}
308 
309 	/**
310 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311 	 * `recipient`, forwarding all available gas and reverting on errors.
312 	 *
313 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
315 	 * imposed by `transfer`, making them unable to receive funds via
316 	 * `transfer`. {sendValue} removes this limitation.
317 	 *
318 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319 	 *
320 	 * IMPORTANT: because control is transferred to `recipient`, care must be
321 	 * taken to not create reentrancy vulnerabilities. Consider using
322 	 * {ReentrancyGuard} or the
323 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324 	 */
325 	function sendValue(address payable recipient, uint256 amount) internal {
326 		require(address(this).balance >= amount, "Address: insufficient balance");
327 
328 		(bool success, ) = recipient.call{value: amount}("");
329 		require(success, "Address: unable to send value, recipient may have reverted");
330 	}
331 
332 	/**
333 	 * @dev Performs a Solidity function call using a low level `call`. A
334 	 * plain `call` is an unsafe replacement for a function call: use this
335 	 * function instead.
336 	 *
337 	 * If `target` reverts with a revert reason, it is bubbled up by this
338 	 * function (like regular Solidity function calls).
339 	 *
340 	 * Returns the raw returned data. To convert to the expected return value,
341 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342 	 *
343 	 * Requirements:
344 	 *
345 	 * - `target` must be a contract.
346 	 * - calling `target` with `data` must not revert.
347 	 *
348 	 * _Available since v3.1._
349 	 */
350 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351 		return functionCall(target, data, "Address: low-level call failed");
352 	}
353 
354 	/**
355 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356 	 * `errorMessage` as a fallback revert reason when `target` reverts.
357 	 *
358 	 * _Available since v3.1._
359 	 */
360 	function functionCall(
361 		address target,
362 		bytes memory data,
363 		string memory errorMessage
364 	) internal returns (bytes memory) {
365 		return functionCallWithValue(target, data, 0, errorMessage);
366 	}
367 
368 	/**
369 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370 	 * but also transferring `value` wei to `target`.
371 	 *
372 	 * Requirements:
373 	 *
374 	 * - the calling contract must have an ETH balance of at least `value`.
375 	 * - the called Solidity function must be `payable`.
376 	 *
377 	 * _Available since v3.1._
378 	 */
379 	function functionCallWithValue(
380 		address target,
381 		bytes memory data,
382 		uint256 value
383 	) internal returns (bytes memory) {
384 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385 	}
386 
387 	/**
388 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
390 	 *
391 	 * _Available since v3.1._
392 	 */
393 	function functionCallWithValue(
394 		address target,
395 		bytes memory data,
396 		uint256 value,
397 		string memory errorMessage
398 	) internal returns (bytes memory) {
399 		require(address(this).balance >= value, "Address: insufficient balance for call");
400 		require(isContract(target), "Address: call to non-contract");
401 
402 		(bool success, bytes memory returndata) = target.call{value: value}(data);
403 		return verifyCallResult(success, returndata, errorMessage);
404 	}
405 
406 	/**
407 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408 	 * but performing a static call.
409 	 *
410 	 * _Available since v3.3._
411 	 */
412 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413 		return functionStaticCall(target, data, "Address: low-level static call failed");
414 	}
415 
416 	/**
417 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418 	 * but performing a static call.
419 	 *
420 	 * _Available since v3.3._
421 	 */
422 	function functionStaticCall(
423 		address target,
424 		bytes memory data,
425 		string memory errorMessage
426 	) internal view returns (bytes memory) {
427 		require(isContract(target), "Address: static call to non-contract");
428 
429 		(bool success, bytes memory returndata) = target.staticcall(data);
430 		return verifyCallResult(success, returndata, errorMessage);
431 	}
432 
433 	/**
434 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435 	 * but performing a delegate call.
436 	 *
437 	 * _Available since v3.4._
438 	 */
439 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441 	}
442 
443 	/**
444 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445 	 * but performing a delegate call.
446 	 *
447 	 * _Available since v3.4._
448 	 */
449 	function functionDelegateCall(
450 		address target,
451 		bytes memory data,
452 		string memory errorMessage
453 	) internal returns (bytes memory) {
454 		require(isContract(target), "Address: delegate call to non-contract");
455 
456 		(bool success, bytes memory returndata) = target.delegatecall(data);
457 		return verifyCallResult(success, returndata, errorMessage);
458 	}
459 
460 	/**
461 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462 	 * revert reason using the provided one.
463 	 *
464 	 * _Available since v4.3._
465 	 */
466 	function verifyCallResult(
467 		bool success,
468 		bytes memory returndata,
469 		string memory errorMessage
470 	) internal pure returns (bytes memory) {
471 		if (success) {
472 			return returndata;
473 		} else {
474 			// Look for revert reason and bubble it up if present
475 			if (returndata.length > 0) {
476 				// The easiest way to bubble the revert reason is using memory via assembly
477 
478 				assembly {
479 					let returndata_size := mload(returndata)
480 					revert(add(32, returndata), returndata_size)
481 				}
482 			} else {
483 				revert(errorMessage);
484 			}
485 		}
486 	}
487 }
488 
489 
490 
491 
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504 	function _msgSender() internal view virtual returns (address) {
505 		return msg.sender;
506 	}
507 
508 	function _msgData() internal view virtual returns (bytes calldata) {
509 		return msg.data;
510 	}
511 }
512 
513 
514 
515 
516 
517 /**
518  * @dev String operations.
519  */
520 library Strings {
521 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
522 
523 	/**
524 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
525 	 */
526 	function toString(uint256 value) internal pure returns (string memory) {
527 		// Inspired by OraclizeAPI's implementation - MIT licence
528 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
529 
530 		if (value == 0) {
531 			return "0";
532 		}
533 		uint256 temp = value;
534 		uint256 digits;
535 		while (temp != 0) {
536 			digits++;
537 			temp /= 10;
538 		}
539 		bytes memory buffer = new bytes(digits);
540 		while (value != 0) {
541 			digits -= 1;
542 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
543 			value /= 10;
544 		}
545 		return string(buffer);
546 	}
547 
548 	/**
549 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
550 	 */
551 	function toHexString(uint256 value) internal pure returns (string memory) {
552 		if (value == 0) {
553 			return "0x00";
554 		}
555 		uint256 temp = value;
556 		uint256 length = 0;
557 		while (temp != 0) {
558 			length++;
559 			temp >>= 8;
560 		}
561 		return toHexString(value, length);
562 	}
563 
564 	/**
565 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
566 	 */
567 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
568 		bytes memory buffer = new bytes(2 * length + 2);
569 		buffer[0] = "0";
570 		buffer[1] = "x";
571 		for (uint256 i = 2 * length + 1; i > 1; --i) {
572 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
573 			value >>= 4;
574 		}
575 		require(value == 0, "Strings: hex length insufficient");
576 		return string(buffer);
577 	}
578 }
579 
580 
581 
582 
583 
584 /**
585  * @dev Implementation of the {IERC165} interface.
586  *
587  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
588  * for the additional interface id that will be supported. For example:
589  *
590  * ```solidity
591  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
593  * }
594  * ```
595  *
596  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
597  */
598 abstract contract ERC165 is IERC165 {
599 	/**
600 	 * @dev See {IERC165-supportsInterface}.
601 	 */
602 	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603 		return interfaceId == type(IERC165).interfaceId;
604 	}
605 }
606 
607 
608 
609 
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721A] Non-Fungible Token Standard, including
613  * the Metadata extension, but not including the Enumerable extension, which is available separately as
614  * {ERC721Enumerable}.
615  */
616 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
617 	using Address for address;
618 	using Strings for uint256;
619 
620 
621 	uint256 private currentIndex = 0;
622 	uint256 public maxBatchSize = 35;
623 
624 	// Token name
625 	string private _name;
626 
627 	// Token symbol
628 	string private _symbol;
629 
630 	// Mapping from token ID to owner address
631 	mapping(uint256 => address) private _owners;
632 
633 	// Mapping owner address to token count
634 	mapping(address => uint256) private _balances;
635 
636 	// Mapping from token ID to approved address
637 	mapping(uint256 => address) private _tokenApprovals;
638 
639 	// Mapping from owner to operator approvals
640 	mapping(address => mapping(address => bool)) private _operatorApprovals;
641 
642 	/**
643 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
644 	 */
645 	constructor(string memory name_, string memory symbol_) {
646 		_name = name_;
647 		_symbol = symbol_;
648 	}
649 
650 	/**
651 	 * @dev See {IERC165-supportsInterface}.
652 	 */
653 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
654 		return
655 			interfaceId == type(IERC721).interfaceId ||
656 			interfaceId == type(IERC721Metadata).interfaceId ||
657 			super.supportsInterface(interfaceId);
658 	}
659 
660 	/**
661 	 * @dev See {IERC721-balanceOf}.
662 	 */
663 	function balanceOf(address owner) public view virtual override returns (uint256) {
664 		require(owner != address(0), "ERC721A: balance query for the zero address");
665 		return _balances[owner];
666 	}
667 
668 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
669 		require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
670 
671 		uint256 lowestTokenToCheck;
672 		if (tokenId >= maxBatchSize) {
673 			lowestTokenToCheck = tokenId - maxBatchSize + 1;
674 		}
675 
676 		for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
677 			address owner = _owners[curr];
678 			if (owner != address(0)) {
679 				return owner;
680 			}
681 		}
682 
683 		revert("ERC721A: unable to determine the owner of token");
684 	}
685 
686 	/**
687 	 * @dev See {IERC721-ownerOf}.
688 	 */
689 	// function ownerOf(uint256 tokenId) public view virtual override returns (address) {
690 	//     return ownershipOf(tokenId);
691 	// }
692 
693 	/**
694 	 * @dev See {IERC721Metadata-name}.
695 	 */
696 	function name() public view virtual override returns (string memory) {
697 		return _name;
698 	}
699 
700 	/**
701 	 * @dev See {IERC721Metadata-symbol}.
702 	 */
703 	function symbol() public view virtual override returns (string memory) {
704 		return _symbol;
705 	}
706 
707 	/**
708 	 * @dev See {IERC721Metadata-tokenURI}.
709 	 */
710 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
711 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
712 
713 		string memory baseURI = _baseURI();
714 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
715 	}
716 
717 	/**
718 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
719 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
720 	 * by default, can be overriden in child contracts.
721 	 */
722 	function _baseURI() internal view virtual returns (string memory) {
723 		return "";
724 	}
725 
726 	/**
727 	 * @dev See {IERC721-approve}.
728 	 */
729 	function approve(address to, uint256 tokenId) public virtual override {
730 		address owner = ERC721A.ownerOf(tokenId);
731 		require(to != owner, "ERC721A: approval to current owner");
732 
733 		require(
734 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
735 			"ERC721A: approve caller is not owner nor approved for all"
736 		);
737 
738 		_approve(to, tokenId);
739 	}
740 
741 	/**
742 	 * @dev See {IERC721-getApproved}.
743 	 */
744 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
745 		require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
746 
747 		return _tokenApprovals[tokenId];
748 	}
749 
750 	/**
751 	 * @dev See {IERC721-setApprovalForAll}.
752 	 */
753 	function setApprovalForAll(address operator, bool approved) public virtual override {
754 		_setApprovalForAll(_msgSender(), operator, approved);
755 	}
756 
757 	/**
758 	 * @dev See {IERC721-isApprovedForAll}.
759 	 */
760 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761 		return _operatorApprovals[owner][operator];
762 	}
763 
764 	/**
765 	 * @dev See {IERC721-transferFrom}.
766 	 */
767 	function transferFrom(
768 		address from,
769 		address to,
770 		uint256 tokenId
771 	) public virtual override {
772 		//solhint-disable-next-line max-line-length
773 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721A: transfer caller is not owner nor approved");
774 
775 		_transfer(from, to, tokenId);
776 	}
777 
778 	/**
779 	 * @dev See {IERC721-safeTransferFrom}.
780 	 */
781 	function safeTransferFrom(
782 		address from,
783 		address to,
784 		uint256 tokenId
785 	) public virtual override {
786 		safeTransferFrom(from, to, tokenId, "");
787 	}
788 
789 	/**
790 	 * @dev See {IERC721-safeTransferFrom}.
791 	 */
792 	function safeTransferFrom(
793 		address from,
794 		address to,
795 		uint256 tokenId,
796 		bytes memory _data
797 	) public virtual override {
798 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721A: transfer caller is not owner nor approved");
799 		_safeTransfer(from, to, tokenId, _data);
800 	}
801 
802 	/**
803 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
804 	 * are aware of the ERC721A protocol to prevent tokens from being forever locked.
805 	 *
806 	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
807 	 *
808 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
809 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
810 	 *
811 	 * Requirements:
812 	 *
813 	 * - `from` cannot be the zero address.
814 	 * - `to` cannot be the zero address.
815 	 * - `tokenId` token must exist and be owned by `from`.
816 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817 	 *
818 	 * Emits a {Transfer} event.
819 	 */
820 	function _safeTransfer(
821 		address from,
822 		address to,
823 		uint256 tokenId,
824 		bytes memory _data
825 	) internal virtual {
826 		_transfer(from, to, tokenId);
827 		require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721A: transfer to non ERC721Receiver implementer");
828 	}
829 
830 	/**
831 	 * @dev Returns whether `tokenId` exists.
832 	 *
833 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
834 	 *
835 	 * Tokens start existing when they are minted (`_mint`),
836 	 * and stop existing when they are burned (`_burn`).
837 	 */
838 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
839 		return tokenId < currentIndex;
840 	}
841 
842 	/**
843 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
844 	 *
845 	 * Requirements:
846 	 *
847 	 * - `tokenId` must exist.
848 	 */
849 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
850 		require(_exists(tokenId), "ERC721A: operator query for nonexistent token");
851 		address owner = ERC721A.ownerOf(tokenId);
852 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
853 	}
854 
855 	/**
856 	 * @dev Safely mints `tokenId` and transfers it to `to`.
857 	 *
858 	 * Requirements:
859 	 *
860 	 * - `tokenId` must not exist.
861 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862 	 *
863 	 * Emits a {Transfer} event.
864 	 */
865 	function _safeMint(address to, uint256 quantity) internal virtual {
866 		_safeMint(to, quantity, "");
867 	}
868 
869 	/**
870 	 * @dev Same as {xref-ERC721A-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
871 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
872 	 */
873 	function _safeMint(
874 		address to,
875 		uint256 quantity,
876 		bytes memory _data
877 	) internal virtual {
878 		uint256 startTokenId = currentIndex;
879 		require(to != address(0), "ERC721A: mint to the zero address");
880 		require(!_exists(startTokenId), "ERC721A: token already minted");
881 
882 		_beforeTokenTransfers(address(0), to, startTokenId, quantity);
883 
884 		_balances[to] += quantity;
885 		_owners[startTokenId] =to;
886 
887 		uint256 updatedIndex = startTokenId;
888 
889 		for (uint256 i = 0; i < quantity; i++) {
890 			emit Transfer(address(0), to, updatedIndex);
891 			require(
892 				_checkOnERC721Received(address(0), to, updatedIndex, _data),
893 				"ERC721A: transfer to non ERC721Receiver implementer"
894 			);
895 			updatedIndex++;
896 		}
897 
898 		currentIndex = updatedIndex;
899 
900 		_afterTokenTransfers(address(0), to, startTokenId, quantity);
901 	}
902 
903 	/**
904 	 * @dev Destroys `tokenId`.
905 	 * The approval is cleared when the token is burned.
906 	 *
907 	 * Requirements:
908 	 *
909 	 * - `tokenId` must exist.
910 	 *
911 	 * Emits a {Transfer} event.
912 	 */
913 	function _burn(uint256 tokenId) internal virtual {
914 		address owner = ERC721A.ownerOf(tokenId);
915 
916 		_beforeTokenTransfer(owner, address(0), tokenId);
917 
918 		// Clear approvals
919 		_approve(address(0), tokenId);
920 
921 		_balances[owner] -= 1;
922 		delete _owners[tokenId];
923 
924 		emit Transfer(owner, address(0), tokenId);
925 
926 		_afterTokenTransfer(owner, address(0), tokenId);
927 	}
928 
929 	/**
930 	 * @dev Transfers `tokenId` from `from` to `to`.
931 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
932 	 *
933 	 * Requirements:
934 	 *
935 	 * - `to` cannot be the zero address.
936 	 * - `tokenId` token must be owned by `from`.
937 	 *
938 	 * Emits a {Transfer} event.
939 	 */
940 	function _transfer(
941 		address from,
942 		address to,
943 		uint256 tokenId
944 	) internal virtual {
945 		require(ERC721A.ownerOf(tokenId) == from, "ERC721A: transfer from incorrect owner");
946 		require(to != address(0), "ERC721A: transfer to the zero address");
947 
948 		_beforeTokenTransfer(from, to, tokenId);
949 
950 		// Clear approvals from the previous owner
951 		_approve(address(0), tokenId);
952 
953 		_balances[from] -= 1;
954 		_balances[to] += 1;
955 		_owners[tokenId] = to;
956 		if(_owners[tokenId+1] == address(0))
957 			_owners[tokenId+1] = from;
958 
959 		emit Transfer(from, to, tokenId);
960 
961 		_afterTokenTransfer(from, to, tokenId);
962 	}
963 
964 	/**
965 	 * @dev Approve `to` to operate on `tokenId`
966 	 *
967 	 * Emits a {Approval} event.
968 	 */
969 	function _approve(address to, uint256 tokenId) internal virtual {
970 		_tokenApprovals[tokenId] = to;
971 		emit Approval(ERC721A.ownerOf(tokenId), to, tokenId);
972 	}
973 
974 	/**
975 	 * @dev Approve `operator` to operate on all of `owner` tokens
976 	 *
977 	 * Emits a {ApprovalForAll} event.
978 	 */
979 	function _setApprovalForAll(
980 		address owner,
981 		address operator,
982 		bool approved
983 	) internal virtual {
984 		require(owner != operator, "ERC721A: approve to caller");
985 		_operatorApprovals[owner][operator] = approved;
986 		emit ApprovalForAll(owner, operator, approved);
987 	}
988 
989 	/**
990 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
991 	 * The call is not executed if the target address is not a contract.
992 	 *
993 	 * @param from address representing the previous owner of the given token ID
994 	 * @param to target address that will receive the tokens
995 	 * @param tokenId uint256 ID of the token to be transferred
996 	 * @param _data bytes optional data to send along with the call
997 	 * @return bool whether the call correctly returned the expected magic value
998 	 */
999 	function _checkOnERC721Received(
1000 		address from,
1001 		address to,
1002 		uint256 tokenId,
1003 		bytes memory _data
1004 	) private returns (bool) {
1005 		if (to.isContract()) {
1006 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1007 				return retval == IERC721Receiver.onERC721Received.selector;
1008 			} catch (bytes memory reason) {
1009 				if (reason.length == 0) {
1010 					revert("ERC721A: transfer to non ERC721Receiver implementer");
1011 				} else {
1012 					assembly {
1013 						revert(add(32, reason), mload(reason))
1014 					}
1015 				}
1016 			}
1017 		} else {
1018 			return true;
1019 		}
1020 	}
1021 
1022 	function getTotalSupply() public view returns(uint256) {
1023 		return currentIndex;
1024 	}
1025 	/**
1026 	 * @dev Hook that is called before any token transfer. This includes minting
1027 	 * and burning.
1028 	 *
1029 	 * Calling conditions:
1030 	 *
1031 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1032 	 * transferred to `to`.
1033 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1034 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1035 	 * - `from` and `to` are never both zero.
1036 	 *
1037 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1038 	 */
1039 	function _beforeTokenTransfer(
1040 		address from,
1041 		address to,
1042 		uint256 tokenId
1043 	) internal virtual {}
1044 
1045 	/**
1046 	 * @dev Hook that is called after any transfer of tokens. This includes
1047 	 * minting and burning.
1048 	 *
1049 	 * Calling conditions:
1050 	 *
1051 	 * - when `from` and `to` are both non-zero.
1052 	 * - `from` and `to` are never both zero.
1053 	 *
1054 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055 	 */
1056 	function _afterTokenTransfer(
1057 		address from,
1058 		address to,
1059 		uint256 tokenId
1060 	) internal virtual {}
1061 
1062 	function _beforeTokenTransfers(
1063 		address from,
1064 		address to,
1065 		uint256 startTokenId,
1066 		uint256 quantity
1067 	) internal virtual {}
1068 
1069 	function _afterTokenTransfers(
1070 		address from,
1071 		address to,
1072 		uint256 startTokenId,
1073 		uint256 quantity
1074 	) internal virtual {}
1075 }
1076 
1077 
1078 
1079 
1080 
1081 /**
1082  * @dev Contract module which provides a basic access control mechanism, where
1083  * there is an account (an owner) that can be granted exclusive access to
1084  * specific functions.
1085  *
1086  * By default, the owner account will be the one that deploys the contract. This
1087  * can later be changed with {transferOwnership}.
1088  *
1089  * This module is used through inheritance. It will make available the modifier
1090  * `onlyOwner`, which can be applied to your functions to restrict their use to
1091  * the owner.
1092  */
1093 abstract contract Ownable is Context {
1094 	address private _owner;
1095 
1096 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1097 
1098 	/**
1099 	 * @dev Initializes the contract setting the deployer as the initial owner.
1100 	 */
1101 	constructor() {
1102 		_transferOwnership(_msgSender());
1103 	}
1104 
1105 	/**
1106 	 * @dev Returns the address of the current owner.
1107 	 */
1108 	function owner() public view virtual returns (address) {
1109 		return _owner;
1110 	}
1111 
1112 	/**
1113 	 * @dev Throws if called by any account other than the owner.
1114 	 */
1115 	modifier onlyOwner() {
1116 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
1117 		_;
1118 	}
1119 
1120 	/**
1121 	 * @dev Leaves the contract without owner. It will not be possible to call
1122 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
1123 	 *
1124 	 * NOTE: Renouncing ownership will leave the contract without an owner,
1125 	 * thereby removing any functionality that is only available to the owner.
1126 	 */
1127 	function renounceOwnership() public virtual onlyOwner {
1128 		_transferOwnership(address(0));
1129 	}
1130 
1131 	/**
1132 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
1133 	 * Can only be called by the current owner.
1134 	 */
1135 	function transferOwnership(address newOwner) public virtual onlyOwner {
1136 		require(newOwner != address(0), "Ownable: new owner is the zero address");
1137 		_transferOwnership(newOwner);
1138 	}
1139 
1140 	/**
1141 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
1142 	 * Internal function without access restriction.
1143 	 */
1144 	function _transferOwnership(address newOwner) internal virtual {
1145 		address oldOwner = _owner;
1146 		_owner = newOwner;
1147 		emit OwnershipTransferred(oldOwner, newOwner);
1148 	}
1149 }
1150 
1151 
1152 
1153 
1154 
1155 /**
1156  * @dev These functions deal with verification of Merkle Trees proofs.
1157  *
1158  * The proofs can be generated using the JavaScript library
1159  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1160  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1161  *
1162  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1163  */
1164 library MerkleProof {
1165 	/**
1166 	 * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1167 	 * defined by `root`. For this, a `proof` must be provided, containing
1168 	 * sibling hashes on the branch from the leaf to the root of the tree. Each
1169 	 * pair of leaves and each pair of pre-images are assumed to be sorted.
1170 	 */
1171 	function verify(
1172 		bytes32[] memory proof,
1173 		bytes32 root,
1174 		bytes32 leaf
1175 	) internal pure returns (bool) {
1176 		return processProof(proof, leaf) == root;
1177 	}
1178 
1179 	/**
1180 	 * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1181 	 * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1182 	 * hash matches the root of the tree. When processing the proof, the pairs
1183 	 * of leafs & pre-images are assumed to be sorted.
1184 	 *
1185 	 * _Available since v4.4._
1186 	 */
1187 	function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1188 		bytes32 computedHash = leaf;
1189 		for (uint256 i = 0; i < proof.length; i++) {
1190 			bytes32 proofElement = proof[i];
1191 			if (computedHash <= proofElement) {
1192 				// Hash(current computed hash + current element of the proof)
1193 				computedHash = _efficientHash(computedHash, proofElement);
1194 			} else {
1195 				// Hash(current element of the proof + current computed hash)
1196 				computedHash = _efficientHash(proofElement, computedHash);
1197 			}
1198 		}
1199 		return computedHash;
1200 	}
1201 
1202 	function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1203 		assembly {
1204 			mstore(0x00, a)
1205 			mstore(0x20, b)
1206 			value := keccak256(0x00, 0x40)
1207 		}
1208 	}
1209 }
1210 
1211 
1212 
1213 
1214 
1215 /**
1216  * @dev Wrappers over Solidity's arithmetic operations.
1217  *
1218  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1219  * now has built in overflow checking.
1220  */
1221 library SafeMath {
1222 	/**
1223 	 * @dev Returns the addition of two unsigned integers, with an overflow flag.
1224 	 *
1225 	 * _Available since v3.4._
1226 	 */
1227 	function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1228 		unchecked {
1229 			uint256 c = a + b;
1230 			if (c < a) return (false, 0);
1231 			return (true, c);
1232 		}
1233 	}
1234 
1235 	/**
1236 	 * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1237 	 *
1238 	 * _Available since v3.4._
1239 	 */
1240 	function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1241 		unchecked {
1242 			if (b > a) return (false, 0);
1243 			return (true, a - b);
1244 		}
1245 	}
1246 
1247 	/**
1248 	 * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1249 	 *
1250 	 * _Available since v3.4._
1251 	 */
1252 	function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1253 		unchecked {
1254 			// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1255 			// benefit is lost if 'b' is also tested.
1256 			// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1257 			if (a == 0) return (true, 0);
1258 			uint256 c = a * b;
1259 			if (c / a != b) return (false, 0);
1260 			return (true, c);
1261 		}
1262 	}
1263 
1264 	/**
1265 	 * @dev Returns the division of two unsigned integers, with a division by zero flag.
1266 	 *
1267 	 * _Available since v3.4._
1268 	 */
1269 	function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1270 		unchecked {
1271 			if (b == 0) return (false, 0);
1272 			return (true, a / b);
1273 		}
1274 	}
1275 
1276 	/**
1277 	 * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1278 	 *
1279 	 * _Available since v3.4._
1280 	 */
1281 	function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1282 		unchecked {
1283 			if (b == 0) return (false, 0);
1284 			return (true, a % b);
1285 		}
1286 	}
1287 
1288 	/**
1289 	 * @dev Returns the addition of two unsigned integers, reverting on
1290 	 * overflow.
1291 	 *
1292 	 * Counterpart to Solidity's `+` operator.
1293 	 *
1294 	 * Requirements:
1295 	 *
1296 	 * - Addition cannot overflow.
1297 	 */
1298 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
1299 		return a + b;
1300 	}
1301 
1302 	/**
1303 	 * @dev Returns the subtraction of two unsigned integers, reverting on
1304 	 * overflow (when the result is negative).
1305 	 *
1306 	 * Counterpart to Solidity's `-` operator.
1307 	 *
1308 	 * Requirements:
1309 	 *
1310 	 * - Subtraction cannot overflow.
1311 	 */
1312 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1313 		return a - b;
1314 	}
1315 
1316 	/**
1317 	 * @dev Returns the multiplication of two unsigned integers, reverting on
1318 	 * overflow.
1319 	 *
1320 	 * Counterpart to Solidity's `*` operator.
1321 	 *
1322 	 * Requirements:
1323 	 *
1324 	 * - Multiplication cannot overflow.
1325 	 */
1326 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1327 		return a * b;
1328 	}
1329 
1330 	/**
1331 	 * @dev Returns the integer division of two unsigned integers, reverting on
1332 	 * division by zero. The result is rounded towards zero.
1333 	 *
1334 	 * Counterpart to Solidity's `/` operator.
1335 	 *
1336 	 * Requirements:
1337 	 *
1338 	 * - The divisor cannot be zero.
1339 	 */
1340 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
1341 		return a / b;
1342 	}
1343 
1344 	/**
1345 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1346 	 * reverting when dividing by zero.
1347 	 *
1348 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
1349 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
1350 	 * invalid opcode to revert (consuming all remaining gas).
1351 	 *
1352 	 * Requirements:
1353 	 *
1354 	 * - The divisor cannot be zero.
1355 	 */
1356 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1357 		return a % b;
1358 	}
1359 
1360 	/**
1361 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1362 	 * overflow (when the result is negative).
1363 	 *
1364 	 * CAUTION: This function is deprecated because it requires allocating memory for the error
1365 	 * message unnecessarily. For custom revert reasons use {trySub}.
1366 	 *
1367 	 * Counterpart to Solidity's `-` operator.
1368 	 *
1369 	 * Requirements:
1370 	 *
1371 	 * - Subtraction cannot overflow.
1372 	 */
1373 	function sub(
1374 		uint256 a,
1375 		uint256 b,
1376 		string memory errorMessage
1377 	) internal pure returns (uint256) {
1378 		unchecked {
1379 			require(b <= a, errorMessage);
1380 			return a - b;
1381 		}
1382 	}
1383 
1384 	/**
1385 	 * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1386 	 * division by zero. The result is rounded towards zero.
1387 	 *
1388 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
1389 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
1390 	 * uses an invalid opcode to revert (consuming all remaining gas).
1391 	 *
1392 	 * Requirements:
1393 	 *
1394 	 * - The divisor cannot be zero.
1395 	 */
1396 	function div(
1397 		uint256 a,
1398 		uint256 b,
1399 		string memory errorMessage
1400 	) internal pure returns (uint256) {
1401 		unchecked {
1402 			require(b > 0, errorMessage);
1403 			return a / b;
1404 		}
1405 	}
1406 
1407 	/**
1408 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1409 	 * reverting with custom message when dividing by zero.
1410 	 *
1411 	 * CAUTION: This function is deprecated because it requires allocating memory for the error
1412 	 * message unnecessarily. For custom revert reasons use {tryMod}.
1413 	 *
1414 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
1415 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
1416 	 * invalid opcode to revert (consuming all remaining gas).
1417 	 *
1418 	 * Requirements:
1419 	 *
1420 	 * - The divisor cannot be zero.
1421 	 */
1422 	function mod(
1423 		uint256 a,
1424 		uint256 b,
1425 		string memory errorMessage
1426 	) internal pure returns (uint256) {
1427 		unchecked {
1428 			require(b > 0, errorMessage);
1429 			return a % b;
1430 		}
1431 	}
1432 }
1433 
1434 
1435 
1436 
1437 
1438 contract Companions is ERC721A, Ownable
1439 {
1440 	using SafeMath for uint256;
1441 
1442 	IERC721 starContract;
1443 
1444 	string public baseURI;
1445 	string public provenanceHash;
1446 
1447 	uint256 public maxSupply = 10000;
1448 	uint256 public maxBatchAmount = 400;
1449 
1450 	uint256 public holderMintedAmount;
1451 	uint256 public adminMintedAmount;
1452 	uint256 public whitelistMintedAmount;
1453 	uint256 public publicMintedAmount;
1454 
1455 	uint256 public whitelistMintPrice = 0.042 ether;
1456 	uint256 public publicMintPrice;
1457 	uint256 public publicMaxPerTransaction = 10;
1458 	uint256 public startingIndexBlock;
1459 	uint256 public startingIndex;
1460 
1461 	bool public holderMintActive = false;
1462 	bool public whitelistMintActive = false;
1463 	bool public publicMintActive = false;
1464 
1465 	mapping(uint256 => bool) public usedStarIds;
1466 	mapping(uint256 => uint256) public matchStarComp;
1467 	mapping(address => bool) public mintedWhitelist;
1468 
1469 	bytes32 private whitelistRoot;
1470 	bytes32 private tieredWhitelistRoot;
1471 
1472 
1473 	/**
1474 	* @dev TheSolaVerse: Companions
1475 	*/
1476 	constructor() ERC721A("The SolaVerse: Companions", "Companion") {}
1477 
1478 
1479 	/**
1480 	* @dev Calculate the total amount minted so far.
1481 	*/
1482 	function totalSupply() public view returns (uint256)
1483 	{
1484 		return holderMintedAmount.add(adminMintedAmount).add(whitelistMintedAmount).add(publicMintedAmount);
1485 	}
1486 
1487 
1488 	/**
1489 	* @dev SOLA-STAR holder wallets.
1490 	*/
1491 	function holderMint(uint256[] memory _ids) public
1492 	{
1493 		require(holderMintActive, "Holder mint is paused.");
1494 		require(_ids.length <= maxBatchAmount, "Can't mint that many.");
1495 
1496 		for (uint256 i=0; i<_ids.length; i++)
1497 		{
1498 			require(starContract.ownerOf(_ids[i]) == msg.sender, "You don't own this one.");
1499 			require(!usedStarIds[_ids[i]], "This one was already used for minting.");
1500 		}
1501 
1502 		_safeMint(msg.sender, _ids.length);
1503 
1504 		for (uint256 i=0; i<_ids.length; i++)
1505 		{
1506 			usedStarIds[_ids[i]] = true;
1507 			matchStarComp[_ids[i]] = holderMintedAmount + i;
1508 		}
1509 
1510 		holderMintedAmount += _ids.length;
1511 	}
1512 
1513 
1514 	/**
1515 	* @dev Whitelisted wallets.
1516 	*/
1517 	function whitelistMint(bytes32[] memory _proof, uint256 _num_tokens) public payable
1518 	{
1519 		require(whitelistMintActive, "Whitelist mint is paused.");
1520 		require(mintedWhitelist[msg.sender] == false, "Already minted.");
1521 		require(msg.value == _num_tokens.mul(whitelistMintPrice), "Insufficient funds.");
1522 
1523 		bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1524 		require(MerkleProof.verify(_proof, whitelistRoot, leaf), "Invalid proof.");
1525 
1526 		_safeMint(msg.sender, _num_tokens);
1527 
1528 		whitelistMintedAmount += _num_tokens;
1529 		mintedWhitelist[msg.sender] = true;
1530 	}
1531 
1532 
1533 	/**
1534 	* @dev Whitelisted wallets with Tiers.
1535 	*/
1536 	function tieredWhitelistMint(bytes32[] memory _proof, uint256 _num_tokens) public payable
1537 	{
1538 		require(whitelistMintActive, "Whitelist mint is paused.");
1539 		require(mintedWhitelist[msg.sender] == false, "Already minted.");
1540 		require(msg.value == _num_tokens.mul(whitelistMintPrice), "Insufficient funds.");
1541 
1542 		bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _num_tokens));
1543 		require(MerkleProof.verify(_proof, tieredWhitelistRoot, leaf), "Invalid proof.");
1544 
1545 		_safeMint(msg.sender, _num_tokens);
1546 
1547 		whitelistMintedAmount += _num_tokens;
1548 		mintedWhitelist[msg.sender] = true;
1549 	}
1550 
1551 
1552 	/**
1553 	* @dev Public mint.
1554 	*/
1555 	function publicMint(uint256 _num_tokens) public payable
1556 	{
1557 		require(publicMintActive, "Public mint is paused.");
1558 		require(publicMintPrice > 0, "Public mint price not set.");
1559 		require(msg.value == publicMintPrice.mul(_num_tokens), "Insufficient funds.");
1560 		require(_num_tokens <= publicMaxPerTransaction, "Can't mint that many at once.");
1561 		require(totalSupply().add(_num_tokens) <= maxSupply, "Can't mint that many.");
1562 
1563 		_safeMint(msg.sender, _num_tokens);
1564 
1565 		publicMintedAmount += _num_tokens;
1566 
1567 		if (startingIndexBlock == 0 && (totalSupply() == maxSupply))
1568 		{
1569 			startingIndexBlock = block.number;
1570 		}
1571 	}
1572 
1573 
1574 	/**
1575 	* @dev Admin mint.
1576 	*/
1577 	function adminMint(address _to, uint256 _num_tokens) public onlyOwner
1578 	{
1579 		require(_num_tokens <= maxBatchAmount, "Can't mint that many.");
1580 
1581 		_safeMint(_to, _num_tokens);
1582 
1583 		adminMintedAmount += _num_tokens;
1584 	}
1585 
1586 
1587 	/**
1588 	* @dev Link to the SOLA-STAR NFT contract to check ownership during holderMint.
1589 	*/
1590 	function setStarContract(address _addr) public onlyOwner
1591 	{
1592 		starContract = IERC721(_addr);
1593 	}
1594 
1595 
1596 	/**
1597 	* @dev Set the Merkle Root for the Whitelist.
1598 	*/
1599 	function setWhitelistMerkleRoot(bytes32 _root) public onlyOwner
1600 	{
1601 		whitelistRoot = _root;
1602 	}
1603 
1604 
1605 	/**
1606 	* @dev Set the Merkle Root for the Tiered Whitelist.
1607 	*/
1608 	function setTieredWhitelistMerkleRoot(bytes32 _root) public onlyOwner
1609 	{
1610 		tieredWhitelistRoot = _root;
1611 	}
1612 
1613 
1614 	/**
1615 	* @dev Toggle the Holder Mint status.
1616 	*/
1617 	function toggleHolderMint() public onlyOwner
1618 	{
1619 		holderMintActive = !holderMintActive;
1620 	}
1621 
1622 
1623 	/**
1624 	* @dev Toggle the Whitelist Mint status.
1625 	*/
1626 	function toggleWhitelistMint() public onlyOwner
1627 	{
1628 		whitelistMintActive = !whitelistMintActive;
1629 	}
1630 
1631 
1632 	/**
1633 	* @dev Toggle the Public Mint status.
1634 	*/
1635 	function togglepublicMint() public onlyOwner
1636 	{
1637 		publicMintActive = !publicMintActive;
1638 	}
1639 
1640 
1641 	/**
1642 	* @dev Set the cost of the tokens for the public mint.
1643 	*/
1644 	function setPublicMintPrice(uint256 _price) public onlyOwner
1645 	{
1646 		publicMintPrice = _price;
1647 	}
1648 
1649 
1650 	/**
1651 	* @dev Update the BaseURI for the reveals.
1652 	*/
1653 	function setBaseURI(string memory _newBaseURI) public onlyOwner
1654 	{
1655 		baseURI = _newBaseURI;
1656 	}
1657 
1658 
1659 	/**
1660 	* @dev Get the Base URI.
1661 	*/
1662 	function _baseURI() internal view virtual override returns (string memory)
1663 	{
1664 		return baseURI;
1665 	}
1666 
1667 
1668 	/**
1669 	 * @dev Finalize starting index.
1670 	 */
1671 	function finalizeStartingIndex() public onlyOwner
1672 	{
1673 		require(startingIndex == 0, "Starting index already set.");
1674 		require(startingIndexBlock != 0, "Starting index block not set.");
1675 
1676 		startingIndex = uint256(blockhash(startingIndexBlock)) % maxSupply;
1677 
1678 		if (block.number.sub(startingIndexBlock) > 255)
1679 		{
1680 			startingIndex = uint256(blockhash(block.number.sub(1))) % maxSupply;
1681 		}
1682 
1683 		if (startingIndex == 0)
1684 		{
1685 			startingIndex = startingIndex.add(1);
1686 		}
1687 	}
1688 
1689 
1690 	/**
1691 	 * @dev Set the starting index block for the collection, essentially unblocking setting starting index.
1692 	 */
1693 	function emergencySetStartingIndexBlock() public onlyOwner
1694 	{
1695 		require(startingIndex == 0, "Starting index already set.");
1696 
1697 		startingIndexBlock = block.number;
1698 	}
1699 
1700 
1701 	/**
1702 	 * @dev Set provenance once it's calculated.
1703 	 *
1704 	 * @param _provenance_hash string memory
1705 	 */
1706 	function setProvenanceHash(string memory _provenance_hash) public onlyOwner
1707 	{
1708 		provenanceHash = _provenance_hash;
1709 	}
1710 
1711 
1712 	/**
1713 	* @dev Withdraw the balance from the contract.
1714 	*/
1715 	function withdraw() public onlyOwner
1716 	{
1717 		uint256 balance = address(this).balance;
1718 		require(balance > 0, "Balance is 0");
1719 		payable(msg.sender).transfer(balance);
1720 	}
1721 }