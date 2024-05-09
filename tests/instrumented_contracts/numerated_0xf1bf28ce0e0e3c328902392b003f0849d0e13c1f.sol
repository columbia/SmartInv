1 // SPDX-License-Identifier: MIT
2 
3 // Sources flattened with hardhat v2.9.9 https://hardhat.org
4 
5 // File contracts/openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21 	/**
22 	 * @dev Returns true if this contract implements the interface defined by
23 	 * `interfaceId`. See the corresponding
24 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25 	 * to learn more about how these ids are created.
26 	 *
27 	 * This function call must use less than 30 000 gas.
28 	 */
29 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File contracts/openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42 	/**
43 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44 	 */
45 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47 	/**
48 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49 	 */
50 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52 	/**
53 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54 	 */
55 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57 	/**
58 	 * @dev Returns the number of tokens in ``owner``'s account.
59 	 */
60 	function balanceOf(address owner) external view returns (uint256 balance);
61 
62 	/**
63 	 * @dev Returns the owner of the `tokenId` token.
64 	 *
65 	 * Requirements:
66 	 *
67 	 * - `tokenId` must exist.
68 	 */
69 	function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71 	/**
72 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
73 	 *
74 	 * Requirements:
75 	 *
76 	 * - `from` cannot be the zero address.
77 	 * - `to` cannot be the zero address.
78 	 * - `tokenId` token must exist and be owned by `from`.
79 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81 	 *
82 	 * Emits a {Transfer} event.
83 	 */
84 	function safeTransferFrom(
85 		address from,
86 		address to,
87 		uint256 tokenId,
88 		bytes calldata data
89 	) external;
90 
91 	/**
92 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94 	 *
95 	 * Requirements:
96 	 *
97 	 * - `from` cannot be the zero address.
98 	 * - `to` cannot be the zero address.
99 	 * - `tokenId` token must exist and be owned by `from`.
100 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102 	 *
103 	 * Emits a {Transfer} event.
104 	 */
105 	function safeTransferFrom(
106 		address from,
107 		address to,
108 		uint256 tokenId
109 	) external;
110 
111 	/**
112 	 * @dev Transfers `tokenId` token from `from` to `to`.
113 	 *
114 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115 	 *
116 	 * Requirements:
117 	 *
118 	 * - `from` cannot be the zero address.
119 	 * - `to` cannot be the zero address.
120 	 * - `tokenId` token must be owned by `from`.
121 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122 	 *
123 	 * Emits a {Transfer} event.
124 	 */
125 	function transferFrom(
126 		address from,
127 		address to,
128 		uint256 tokenId
129 	) external;
130 
131 	/**
132 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133 	 * The approval is cleared when the token is transferred.
134 	 *
135 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136 	 *
137 	 * Requirements:
138 	 *
139 	 * - The caller must own the token or be an approved operator.
140 	 * - `tokenId` must exist.
141 	 *
142 	 * Emits an {Approval} event.
143 	 */
144 	function approve(address to, uint256 tokenId) external;
145 
146 	/**
147 	 * @dev Approve or remove `operator` as an operator for the caller.
148 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149 	 *
150 	 * Requirements:
151 	 *
152 	 * - The `operator` cannot be the caller.
153 	 *
154 	 * Emits an {ApprovalForAll} event.
155 	 */
156 	function setApprovalForAll(address operator, bool _approved) external;
157 
158 	/**
159 	 * @dev Returns the account approved for `tokenId` token.
160 	 *
161 	 * Requirements:
162 	 *
163 	 * - `tokenId` must exist.
164 	 */
165 	function getApproved(uint256 tokenId) external view returns (address operator);
166 
167 	/**
168 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169 	 *
170 	 * See {setApprovalForAll}
171 	 */
172 	function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 // File contracts/openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187 	/**
188 	 * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189 	 * by `operator` from `from`, this function is called.
190 	 *
191 	 * It must return its Solidity selector to confirm the token transfer.
192 	 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193 	 *
194 	 * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
195 	 */
196 	function onERC721Received(
197 		address operator,
198 		address from,
199 		uint256 tokenId,
200 		bytes calldata data
201 	) external returns (bytes4);
202 }
203 
204 // File contracts/openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215 	/**
216 	 * @dev Returns the token collection name.
217 	 */
218 	function name() external view returns (string memory);
219 
220 	/**
221 	 * @dev Returns the token collection symbol.
222 	 */
223 	function symbol() external view returns (string memory);
224 
225 	/**
226 	 * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227 	 */
228 	function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File contracts/openzeppelin/contracts/utils/Address.sol
232 
233 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
234 
235 pragma solidity ^0.8.1;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241 	/**
242 	 * @dev Returns true if `account` is a contract.
243 	 *
244 	 * [IMPORTANT]
245 	 * ====
246 	 * It is unsafe to assume that an address for which this function returns
247 	 * false is an externally-owned account (EOA) and not a contract.
248 	 *
249 	 * Among others, `isContract` will return false for the following
250 	 * types of addresses:
251 	 *
252 	 *  - an externally-owned account
253 	 *  - a contract in construction
254 	 *  - an address where a contract will be created
255 	 *  - an address where a contract lived, but was destroyed
256 	 * ====
257 	 *
258 	 * [IMPORTANT]
259 	 * ====
260 	 * You shouldn't rely on `isContract` to protect against flash loan attacks!
261 	 *
262 	 * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
263 	 * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
264 	 * constructor.
265 	 * ====
266 	 */
267 	function isContract(address account) internal view returns (bool) {
268 		// This method relies on extcodesize/address.code.length, which returns 0
269 		// for contracts in construction, since the code is only stored at the end
270 		// of the constructor execution.
271 
272 		return account.code.length > 0;
273 	}
274 
275 	/**
276 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277 	 * `recipient`, forwarding all available gas and reverting on errors.
278 	 *
279 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
281 	 * imposed by `transfer`, making them unable to receive funds via
282 	 * `transfer`. {sendValue} removes this limitation.
283 	 *
284 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285 	 *
286 	 * IMPORTANT: because control is transferred to `recipient`, care must be
287 	 * taken to not create reentrancy vulnerabilities. Consider using
288 	 * {ReentrancyGuard} or the
289 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290 	 */
291 	function sendValue(address payable recipient, uint256 amount) internal {
292 		require(address(this).balance >= amount, "Address: insufficient balance");
293 
294 		(bool success, ) = recipient.call{ value: amount }("");
295 		require(success, "Address: unable to send value, recipient may have reverted");
296 	}
297 
298 	/**
299 	 * @dev Performs a Solidity function call using a low level `call`. A
300 	 * plain `call` is an unsafe replacement for a function call: use this
301 	 * function instead.
302 	 *
303 	 * If `target` reverts with a revert reason, it is bubbled up by this
304 	 * function (like regular Solidity function calls).
305 	 *
306 	 * Returns the raw returned data. To convert to the expected return value,
307 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308 	 *
309 	 * Requirements:
310 	 *
311 	 * - `target` must be a contract.
312 	 * - calling `target` with `data` must not revert.
313 	 *
314 	 * _Available since v3.1._
315 	 */
316 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317 		return functionCall(target, data, "Address: low-level call failed");
318 	}
319 
320 	/**
321 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322 	 * `errorMessage` as a fallback revert reason when `target` reverts.
323 	 *
324 	 * _Available since v3.1._
325 	 */
326 	function functionCall(
327 		address target,
328 		bytes memory data,
329 		string memory errorMessage
330 	) internal returns (bytes memory) {
331 		return functionCallWithValue(target, data, 0, errorMessage);
332 	}
333 
334 	/**
335 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336 	 * but also transferring `value` wei to `target`.
337 	 *
338 	 * Requirements:
339 	 *
340 	 * - the calling contract must have an ETH balance of at least `value`.
341 	 * - the called Solidity function must be `payable`.
342 	 *
343 	 * _Available since v3.1._
344 	 */
345 	function functionCallWithValue(
346 		address target,
347 		bytes memory data,
348 		uint256 value
349 	) internal returns (bytes memory) {
350 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351 	}
352 
353 	/**
354 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
356 	 *
357 	 * _Available since v3.1._
358 	 */
359 	function functionCallWithValue(
360 		address target,
361 		bytes memory data,
362 		uint256 value,
363 		string memory errorMessage
364 	) internal returns (bytes memory) {
365 		require(address(this).balance >= value, "Address: insufficient balance for call");
366 		require(isContract(target), "Address: call to non-contract");
367 
368 		(bool success, bytes memory returndata) = target.call{ value: value }(data);
369 		return verifyCallResult(success, returndata, errorMessage);
370 	}
371 
372 	/**
373 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374 	 * but performing a static call.
375 	 *
376 	 * _Available since v3.3._
377 	 */
378 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379 		return functionStaticCall(target, data, "Address: low-level static call failed");
380 	}
381 
382 	/**
383 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384 	 * but performing a static call.
385 	 *
386 	 * _Available since v3.3._
387 	 */
388 	function functionStaticCall(
389 		address target,
390 		bytes memory data,
391 		string memory errorMessage
392 	) internal view returns (bytes memory) {
393 		require(isContract(target), "Address: static call to non-contract");
394 
395 		(bool success, bytes memory returndata) = target.staticcall(data);
396 		return verifyCallResult(success, returndata, errorMessage);
397 	}
398 
399 	/**
400 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401 	 * but performing a delegate call.
402 	 *
403 	 * _Available since v3.4._
404 	 */
405 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
406 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
407 	}
408 
409 	/**
410 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411 	 * but performing a delegate call.
412 	 *
413 	 * _Available since v3.4._
414 	 */
415 	function functionDelegateCall(
416 		address target,
417 		bytes memory data,
418 		string memory errorMessage
419 	) internal returns (bytes memory) {
420 		require(isContract(target), "Address: delegate call to non-contract");
421 
422 		(bool success, bytes memory returndata) = target.delegatecall(data);
423 		return verifyCallResult(success, returndata, errorMessage);
424 	}
425 
426 	/**
427 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
428 	 * revert reason using the provided one.
429 	 *
430 	 * _Available since v4.3._
431 	 */
432 	function verifyCallResult(
433 		bool success,
434 		bytes memory returndata,
435 		string memory errorMessage
436 	) internal pure returns (bytes memory) {
437 		if (success) {
438 			return returndata;
439 		} else {
440 			// Look for revert reason and bubble it up if present
441 			if (returndata.length > 0) {
442 				// The easiest way to bubble the revert reason is using memory via assembly
443 
444 				assembly {
445 					let returndata_size := mload(returndata)
446 					revert(add(32, returndata), returndata_size)
447 				}
448 			} else {
449 				revert(errorMessage);
450 			}
451 		}
452 	}
453 }
454 
455 // File contracts/openzeppelin/contracts/utils/Context.sol
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Provides information about the current execution context, including the
463  * sender of the transaction and its data. While these are generally available
464  * via msg.sender and msg.data, they should not be accessed in such a direct
465  * manner, since when dealing with meta-transactions the account sending and
466  * paying for execution may not be the actual sender (as far as an application
467  * is concerned).
468  *
469  * This contract is only required for intermediate, library-like contracts.
470  */
471 abstract contract Context {
472 	function _msgSender() internal view virtual returns (address) {
473 		return msg.sender;
474 	}
475 
476 	function _msgData() internal view virtual returns (bytes calldata) {
477 		return msg.data;
478 	}
479 }
480 
481 // File contracts/openzeppelin/contracts/utils/Strings.sol
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev String operations.
489  */
490 library Strings {
491 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
492 
493 	/**
494 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
495 	 */
496 	function toString(uint256 value) internal pure returns (string memory) {
497 		// Inspired by OraclizeAPI's implementation - MIT licence
498 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
499 
500 		if (value == 0) {
501 			return "0";
502 		}
503 		uint256 temp = value;
504 		uint256 digits;
505 		while (temp != 0) {
506 			digits++;
507 			temp /= 10;
508 		}
509 		bytes memory buffer = new bytes(digits);
510 		while (value != 0) {
511 			digits -= 1;
512 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
513 			value /= 10;
514 		}
515 		return string(buffer);
516 	}
517 
518 	/**
519 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520 	 */
521 	function toHexString(uint256 value) internal pure returns (string memory) {
522 		if (value == 0) {
523 			return "0x00";
524 		}
525 		uint256 temp = value;
526 		uint256 length = 0;
527 		while (temp != 0) {
528 			length++;
529 			temp >>= 8;
530 		}
531 		return toHexString(value, length);
532 	}
533 
534 	/**
535 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
536 	 */
537 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
538 		bytes memory buffer = new bytes(2 * length + 2);
539 		buffer[0] = "0";
540 		buffer[1] = "x";
541 		for (uint256 i = 2 * length + 1; i > 1; --i) {
542 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
543 			value >>= 4;
544 		}
545 		require(value == 0, "Strings: hex length insufficient");
546 		return string(buffer);
547 	}
548 }
549 
550 // File contracts/openzeppelin/contracts/utils/introspection/ERC165.sol
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571 	/**
572 	 * @dev See {IERC165-supportsInterface}.
573 	 */
574 	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575 		return interfaceId == type(IERC165).interfaceId;
576 	}
577 }
578 
579 // File contracts/openzeppelin/contracts/token/ERC721/ERC721.sol
580 
581 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
587  * the Metadata extension, but not including the Enumerable extension, which is available separately as
588  * {ERC721Enumerable}.
589  */
590 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
591 	using Address for address;
592 	using Strings for uint256;
593 
594 	// Token name
595 	string private _name;
596 
597 	// Token symbol
598 	string private _symbol;
599 
600 	// Mapping from token ID to owner address
601 	mapping(uint256 => address) private _owners;
602 
603 	// Mapping owner address to token count
604 	mapping(address => uint256) private _balances;
605 
606 	// Mapping from token ID to approved address
607 	mapping(uint256 => address) private _tokenApprovals;
608 
609 	// Mapping from owner to operator approvals
610 	mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612 	/**
613 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
614 	 */
615 	constructor(string memory name_, string memory symbol_) {
616 		_name = name_;
617 		_symbol = symbol_;
618 	}
619 
620 	/**
621 	 * @dev See {IERC165-supportsInterface}.
622 	 */
623 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
624 		return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
625 	}
626 
627 	/**
628 	 * @dev See {IERC721-balanceOf}.
629 	 */
630 	function balanceOf(address owner) public view virtual override returns (uint256) {
631 		require(owner != address(0), "ERC721: balance query for the zero address");
632 		return _balances[owner];
633 	}
634 
635 	/**
636 	 * @dev See {IERC721-ownerOf}.
637 	 */
638 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
639 		address owner = _owners[tokenId];
640 		require(owner != address(0), "ERC721: owner query for nonexistent token");
641 		return owner;
642 	}
643 
644 	/**
645 	 * @dev See {IERC721Metadata-name}.
646 	 */
647 	function name() public view virtual override returns (string memory) {
648 		return _name;
649 	}
650 
651 	/**
652 	 * @dev See {IERC721Metadata-symbol}.
653 	 */
654 	function symbol() public view virtual override returns (string memory) {
655 		return _symbol;
656 	}
657 
658 	/**
659 	 * @dev See {IERC721Metadata-tokenURI}.
660 	 */
661 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
663 
664 		string memory baseURI = _baseURI();
665 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
666 	}
667 
668 	/**
669 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671 	 * by default, can be overridden in child contracts.
672 	 */
673 	function _baseURI() internal view virtual returns (string memory) {
674 		return "";
675 	}
676 
677 	/**
678 	 * @dev See {IERC721-approve}.
679 	 */
680 	function approve(address to, uint256 tokenId) public virtual override {
681 		address owner = ERC721.ownerOf(tokenId);
682 		require(to != owner, "ERC721: approval to current owner");
683 
684 		require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
685 
686 		_approve(to, tokenId);
687 	}
688 
689 	/**
690 	 * @dev See {IERC721-getApproved}.
691 	 */
692 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
693 		require(_exists(tokenId), "ERC721: approved query for nonexistent token");
694 
695 		return _tokenApprovals[tokenId];
696 	}
697 
698 	/**
699 	 * @dev See {IERC721-setApprovalForAll}.
700 	 */
701 	function setApprovalForAll(address operator, bool approved) public virtual override {
702 		_setApprovalForAll(_msgSender(), operator, approved);
703 	}
704 
705 	/**
706 	 * @dev See {IERC721-isApprovedForAll}.
707 	 */
708 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
709 		return _operatorApprovals[owner][operator];
710 	}
711 
712 	/**
713 	 * @dev See {IERC721-transferFrom}.
714 	 */
715 	function transferFrom(
716 		address from,
717 		address to,
718 		uint256 tokenId
719 	) public virtual override {
720 		//solhint-disable-next-line max-line-length
721 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
722 
723 		_transfer(from, to, tokenId);
724 	}
725 
726 	/**
727 	 * @dev See {IERC721-safeTransferFrom}.
728 	 */
729 	function safeTransferFrom(
730 		address from,
731 		address to,
732 		uint256 tokenId
733 	) public virtual override {
734 		safeTransferFrom(from, to, tokenId, "");
735 	}
736 
737 	/**
738 	 * @dev See {IERC721-safeTransferFrom}.
739 	 */
740 	function safeTransferFrom(
741 		address from,
742 		address to,
743 		uint256 tokenId,
744 		bytes memory data
745 	) public virtual override {
746 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
747 		_safeTransfer(from, to, tokenId, data);
748 	}
749 
750 	/**
751 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
752 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
753 	 *
754 	 * `data` is additional data, it has no specified format and it is sent in call to `to`.
755 	 *
756 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
757 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
758 	 *
759 	 * Requirements:
760 	 *
761 	 * - `from` cannot be the zero address.
762 	 * - `to` cannot be the zero address.
763 	 * - `tokenId` token must exist and be owned by `from`.
764 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765 	 *
766 	 * Emits a {Transfer} event.
767 	 */
768 	function _safeTransfer(
769 		address from,
770 		address to,
771 		uint256 tokenId,
772 		bytes memory data
773 	) internal virtual {
774 		_transfer(from, to, tokenId);
775 		require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
776 	}
777 
778 	/**
779 	 * @dev Returns whether `tokenId` exists.
780 	 *
781 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782 	 *
783 	 * Tokens start existing when they are minted (`_mint`),
784 	 * and stop existing when they are burned (`_burn`).
785 	 */
786 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
787 		return _owners[tokenId] != address(0);
788 	}
789 
790 	/**
791 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
792 	 *
793 	 * Requirements:
794 	 *
795 	 * - `tokenId` must exist.
796 	 */
797 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
798 		require(_exists(tokenId), "ERC721: operator query for nonexistent token");
799 		address owner = ERC721.ownerOf(tokenId);
800 		return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
801 	}
802 
803 	/**
804 	 * @dev Safely mints `tokenId` and transfers it to `to`.
805 	 *
806 	 * Requirements:
807 	 *
808 	 * - `tokenId` must not exist.
809 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810 	 *
811 	 * Emits a {Transfer} event.
812 	 */
813 	function _safeMint(address to, uint256 tokenId) internal virtual {
814 		_safeMint(to, tokenId, "");
815 	}
816 
817 	/**
818 	 * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
819 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
820 	 */
821 	function _safeMint(
822 		address to,
823 		uint256 tokenId,
824 		bytes memory data
825 	) internal virtual {
826 		_mint(to, tokenId);
827 		require(_checkOnERC721Received(address(0), to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
828 	}
829 
830 	/**
831 	 * @dev Mints `tokenId` and transfers it to `to`.
832 	 *
833 	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
834 	 *
835 	 * Requirements:
836 	 *
837 	 * - `tokenId` must not exist.
838 	 * - `to` cannot be the zero address.
839 	 *
840 	 * Emits a {Transfer} event.
841 	 */
842 	function _mint(address to, uint256 tokenId) internal virtual {
843 		require(to != address(0), "ERC721: mint to the zero address");
844 		require(!_exists(tokenId), "ERC721: token already minted");
845 
846 		_beforeTokenTransfer(address(0), to, tokenId);
847 
848 		_balances[to] += 1;
849 		_owners[tokenId] = to;
850 
851 		emit Transfer(address(0), to, tokenId);
852 
853 		_afterTokenTransfer(address(0), to, tokenId);
854 	}
855 
856 	/**
857 	 * @dev Destroys `tokenId`.
858 	 * The approval is cleared when the token is burned.
859 	 *
860 	 * Requirements:
861 	 *
862 	 * - `tokenId` must exist.
863 	 *
864 	 * Emits a {Transfer} event.
865 	 */
866 	function _burn(uint256 tokenId) internal virtual {
867 		address owner = ERC721.ownerOf(tokenId);
868 
869 		_beforeTokenTransfer(owner, address(0), tokenId);
870 
871 		// Clear approvals
872 		_approve(address(0), tokenId);
873 
874 		_balances[owner] -= 1;
875 		delete _owners[tokenId];
876 
877 		emit Transfer(owner, address(0), tokenId);
878 
879 		_afterTokenTransfer(owner, address(0), tokenId);
880 	}
881 
882 	/**
883 	 * @dev Transfers `tokenId` from `from` to `to`.
884 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
885 	 *
886 	 * Requirements:
887 	 *
888 	 * - `to` cannot be the zero address.
889 	 * - `tokenId` token must be owned by `from`.
890 	 *
891 	 * Emits a {Transfer} event.
892 	 */
893 	function _transfer(
894 		address from,
895 		address to,
896 		uint256 tokenId
897 	) internal virtual {
898 		require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
899 		require(to != address(0), "ERC721: transfer to the zero address");
900 
901 		_beforeTokenTransfer(from, to, tokenId);
902 
903 		// Clear approvals from the previous owner
904 		_approve(address(0), tokenId);
905 
906 		_balances[from] -= 1;
907 		_balances[to] += 1;
908 		_owners[tokenId] = to;
909 
910 		emit Transfer(from, to, tokenId);
911 
912 		_afterTokenTransfer(from, to, tokenId);
913 	}
914 
915 	/**
916 	 * @dev Approve `to` to operate on `tokenId`
917 	 *
918 	 * Emits an {Approval} event.
919 	 */
920 	function _approve(address to, uint256 tokenId) internal virtual {
921 		_tokenApprovals[tokenId] = to;
922 		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
923 	}
924 
925 	/**
926 	 * @dev Approve `operator` to operate on all of `owner` tokens
927 	 *
928 	 * Emits an {ApprovalForAll} event.
929 	 */
930 	function _setApprovalForAll(
931 		address owner,
932 		address operator,
933 		bool approved
934 	) internal virtual {
935 		require(owner != operator, "ERC721: approve to caller");
936 		_operatorApprovals[owner][operator] = approved;
937 		emit ApprovalForAll(owner, operator, approved);
938 	}
939 
940 	/**
941 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942 	 * The call is not executed if the target address is not a contract.
943 	 *
944 	 * @param from address representing the previous owner of the given token ID
945 	 * @param to target address that will receive the tokens
946 	 * @param tokenId uint256 ID of the token to be transferred
947 	 * @param data bytes optional data to send along with the call
948 	 * @return bool whether the call correctly returned the expected magic value
949 	 */
950 	function _checkOnERC721Received(
951 		address from,
952 		address to,
953 		uint256 tokenId,
954 		bytes memory data
955 	) private returns (bool) {
956 		if (to.isContract()) {
957 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
958 				return retval == IERC721Receiver.onERC721Received.selector;
959 			} catch (bytes memory reason) {
960 				if (reason.length == 0) {
961 					revert("ERC721: transfer to non ERC721Receiver implementer");
962 				} else {
963 					assembly {
964 						revert(add(32, reason), mload(reason))
965 					}
966 				}
967 			}
968 		} else {
969 			return true;
970 		}
971 	}
972 
973 	/**
974 	 * @dev Hook that is called before any token transfer. This includes minting
975 	 * and burning.
976 	 *
977 	 * Calling conditions:
978 	 *
979 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
980 	 * transferred to `to`.
981 	 * - When `from` is zero, `tokenId` will be minted for `to`.
982 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
983 	 * - `from` and `to` are never both zero.
984 	 *
985 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986 	 */
987 	function _beforeTokenTransfer(
988 		address from,
989 		address to,
990 		uint256 tokenId
991 	) internal virtual {}
992 
993 	/**
994 	 * @dev Hook that is called after any transfer of tokens. This includes
995 	 * minting and burning.
996 	 *
997 	 * Calling conditions:
998 	 *
999 	 * - when `from` and `to` are both non-zero.
1000 	 * - `from` and `to` are never both zero.
1001 	 *
1002 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003 	 */
1004 	function _afterTokenTransfer(
1005 		address from,
1006 		address to,
1007 		uint256 tokenId
1008 	) internal virtual {}
1009 }
1010 
1011 // File contracts/openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1012 
1013 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1019  * @dev See https://eips.ethereum.org/EIPS/eip-721
1020  */
1021 interface IERC721Enumerable is IERC721 {
1022 	/**
1023 	 * @dev Returns the total amount of tokens stored by the contract.
1024 	 */
1025 	function totalSupply() external view returns (uint256);
1026 
1027 	/**
1028 	 * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1029 	 * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1030 	 */
1031 	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1032 
1033 	/**
1034 	 * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1035 	 * Use along with {totalSupply} to enumerate all tokens.
1036 	 */
1037 	function tokenByIndex(uint256 index) external view returns (uint256);
1038 }
1039 
1040 // File contracts/openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1041 
1042 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1048  * enumerability of all the token ids in the contract as well as all token ids owned by each
1049  * account.
1050  */
1051 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1052 	// Mapping from owner to list of owned token IDs
1053 	mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1054 
1055 	// Mapping from token ID to index of the owner tokens list
1056 	mapping(uint256 => uint256) private _ownedTokensIndex;
1057 
1058 	// Array with all token ids, used for enumeration
1059 	uint256[] private _allTokens;
1060 
1061 	// Mapping from token id to position in the allTokens array
1062 	mapping(uint256 => uint256) private _allTokensIndex;
1063 
1064 	/**
1065 	 * @dev See {IERC165-supportsInterface}.
1066 	 */
1067 	function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1068 		return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1069 	}
1070 
1071 	/**
1072 	 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1073 	 */
1074 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1075 		require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1076 		return _ownedTokens[owner][index];
1077 	}
1078 
1079 	/**
1080 	 * @dev See {IERC721Enumerable-totalSupply}.
1081 	 */
1082 	function totalSupply() public view virtual override returns (uint256) {
1083 		return _allTokens.length;
1084 	}
1085 
1086 	/**
1087 	 * @dev See {IERC721Enumerable-tokenByIndex}.
1088 	 */
1089 	function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1090 		require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1091 		return _allTokens[index];
1092 	}
1093 
1094 	/**
1095 	 * @dev Hook that is called before any token transfer. This includes minting
1096 	 * and burning.
1097 	 *
1098 	 * Calling conditions:
1099 	 *
1100 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1101 	 * transferred to `to`.
1102 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1103 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1104 	 * - `from` cannot be the zero address.
1105 	 * - `to` cannot be the zero address.
1106 	 *
1107 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108 	 */
1109 	function _beforeTokenTransfer(
1110 		address from,
1111 		address to,
1112 		uint256 tokenId
1113 	) internal virtual override {
1114 		super._beforeTokenTransfer(from, to, tokenId);
1115 
1116 		if (from == address(0)) {
1117 			_addTokenToAllTokensEnumeration(tokenId);
1118 		} else if (from != to) {
1119 			_removeTokenFromOwnerEnumeration(from, tokenId);
1120 		}
1121 		if (to == address(0)) {
1122 			_removeTokenFromAllTokensEnumeration(tokenId);
1123 		} else if (to != from) {
1124 			_addTokenToOwnerEnumeration(to, tokenId);
1125 		}
1126 	}
1127 
1128 	/**
1129 	 * @dev Private function to add a token to this extension's ownership-tracking data structures.
1130 	 * @param to address representing the new owner of the given token ID
1131 	 * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1132 	 */
1133 	function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1134 		uint256 length = ERC721.balanceOf(to);
1135 		_ownedTokens[to][length] = tokenId;
1136 		_ownedTokensIndex[tokenId] = length;
1137 	}
1138 
1139 	/**
1140 	 * @dev Private function to add a token to this extension's token tracking data structures.
1141 	 * @param tokenId uint256 ID of the token to be added to the tokens list
1142 	 */
1143 	function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1144 		_allTokensIndex[tokenId] = _allTokens.length;
1145 		_allTokens.push(tokenId);
1146 	}
1147 
1148 	/**
1149 	 * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1150 	 * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1151 	 * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1152 	 * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1153 	 * @param from address representing the previous owner of the given token ID
1154 	 * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1155 	 */
1156 	function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1157 		// To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1158 		// then delete the last slot (swap and pop).
1159 
1160 		uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1161 		uint256 tokenIndex = _ownedTokensIndex[tokenId];
1162 
1163 		// When the token to delete is the last token, the swap operation is unnecessary
1164 		if (tokenIndex != lastTokenIndex) {
1165 			uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1166 
1167 			_ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1168 			_ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1169 		}
1170 
1171 		// This also deletes the contents at the last position of the array
1172 		delete _ownedTokensIndex[tokenId];
1173 		delete _ownedTokens[from][lastTokenIndex];
1174 	}
1175 
1176 	/**
1177 	 * @dev Private function to remove a token from this extension's token tracking data structures.
1178 	 * This has O(1) time complexity, but alters the order of the _allTokens array.
1179 	 * @param tokenId uint256 ID of the token to be removed from the tokens list
1180 	 */
1181 	function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1182 		// To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1183 		// then delete the last slot (swap and pop).
1184 
1185 		uint256 lastTokenIndex = _allTokens.length - 1;
1186 		uint256 tokenIndex = _allTokensIndex[tokenId];
1187 
1188 		// When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1189 		// rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1190 		// an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1191 		uint256 lastTokenId = _allTokens[lastTokenIndex];
1192 
1193 		_allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1194 		_allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1195 
1196 		// This also deletes the contents at the last position of the array
1197 		delete _allTokensIndex[tokenId];
1198 		_allTokens.pop();
1199 	}
1200 }
1201 
1202 // File contracts/openzeppelin/contracts/security/Pausable.sol
1203 
1204 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev Contract module which allows children to implement an emergency stop
1210  * mechanism that can be triggered by an authorized account.
1211  *
1212  * This module is used through inheritance. It will make available the
1213  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1214  * the functions of your contract. Note that they will not be pausable by
1215  * simply including this module, only once the modifiers are put in place.
1216  */
1217 abstract contract Pausable is Context {
1218 	/**
1219 	 * @dev Emitted when the pause is triggered by `account`.
1220 	 */
1221 	event Paused(address account);
1222 
1223 	/**
1224 	 * @dev Emitted when the pause is lifted by `account`.
1225 	 */
1226 	event Unpaused(address account);
1227 
1228 	bool private _paused;
1229 
1230 	/**
1231 	 * @dev Initializes the contract in unpaused state.
1232 	 */
1233 	constructor() {
1234 		_paused = false;
1235 	}
1236 
1237 	/**
1238 	 * @dev Returns true if the contract is paused, and false otherwise.
1239 	 */
1240 	function paused() public view virtual returns (bool) {
1241 		return _paused;
1242 	}
1243 
1244 	/**
1245 	 * @dev Modifier to make a function callable only when the contract is not paused.
1246 	 *
1247 	 * Requirements:
1248 	 *
1249 	 * - The contract must not be paused.
1250 	 */
1251 	modifier whenNotPaused() {
1252 		require(!paused(), "Pausable: paused");
1253 		_;
1254 	}
1255 
1256 	/**
1257 	 * @dev Modifier to make a function callable only when the contract is paused.
1258 	 *
1259 	 * Requirements:
1260 	 *
1261 	 * - The contract must be paused.
1262 	 */
1263 	modifier whenPaused() {
1264 		require(paused(), "Pausable: not paused");
1265 		_;
1266 	}
1267 
1268 	/**
1269 	 * @dev Triggers stopped state.
1270 	 *
1271 	 * Requirements:
1272 	 *
1273 	 * - The contract must not be paused.
1274 	 */
1275 	function _pause() internal virtual whenNotPaused {
1276 		_paused = true;
1277 		emit Paused(_msgSender());
1278 	}
1279 
1280 	/**
1281 	 * @dev Returns to normal state.
1282 	 *
1283 	 * Requirements:
1284 	 *
1285 	 * - The contract must be paused.
1286 	 */
1287 	function _unpause() internal virtual whenPaused {
1288 		_paused = false;
1289 		emit Unpaused(_msgSender());
1290 	}
1291 }
1292 
1293 // File contracts/openzeppelin/contracts/access/Ownable.sol
1294 
1295 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 /**
1300  * @dev Contract module which provides a basic access control mechanism, where
1301  * there is an account (an owner) that can be granted exclusive access to
1302  * specific functions.
1303  *
1304  * By default, the owner account will be the one that deploys the contract. This
1305  * can later be changed with {transferOwnership}.
1306  *
1307  * This module is used through inheritance. It will make available the modifier
1308  * `onlyOwner`, which can be applied to your functions to restrict their use to
1309  * the owner.
1310  */
1311 abstract contract Ownable is Context {
1312 	address private _owner;
1313 
1314 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1315 
1316 	/**
1317 	 * @dev Initializes the contract setting the deployer as the initial owner.
1318 	 */
1319 	constructor() {
1320 		_transferOwnership(_msgSender());
1321 	}
1322 
1323 	/**
1324 	 * @dev Returns the address of the current owner.
1325 	 */
1326 	function owner() public view virtual returns (address) {
1327 		return _owner;
1328 	}
1329 
1330 	/**
1331 	 * @dev Throws if called by any account other than the owner.
1332 	 */
1333 	modifier onlyOwner() {
1334 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
1335 		_;
1336 	}
1337 
1338 	/**
1339 	 * @dev Leaves the contract without owner. It will not be possible to call
1340 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
1341 	 *
1342 	 * NOTE: Renouncing ownership will leave the contract without an owner,
1343 	 * thereby removing any functionality that is only available to the owner.
1344 	 */
1345 	function renounceOwnership() public virtual onlyOwner {
1346 		_transferOwnership(address(0));
1347 	}
1348 
1349 	/**
1350 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351 	 * Can only be called by the current owner.
1352 	 */
1353 	function transferOwnership(address newOwner) public virtual onlyOwner {
1354 		require(newOwner != address(0), "Ownable: new owner is the zero address");
1355 		_transferOwnership(newOwner);
1356 	}
1357 
1358 	/**
1359 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
1360 	 * Internal function without access restriction.
1361 	 */
1362 	function _transferOwnership(address newOwner) internal virtual {
1363 		address oldOwner = _owner;
1364 		_owner = newOwner;
1365 		emit OwnershipTransferred(oldOwner, newOwner);
1366 	}
1367 }
1368 
1369 // File contracts/openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1370 
1371 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @title ERC721 Burnable Token
1377  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1378  */
1379 abstract contract ERC721Burnable is Context, ERC721 {
1380 	/**
1381 	 * @dev Burns `tokenId`. See {ERC721-_burn}.
1382 	 *
1383 	 * Requirements:
1384 	 *
1385 	 * - The caller must own `tokenId` or be an approved operator.
1386 	 */
1387 	function burn(uint256 tokenId) public virtual {
1388 		//solhint-disable-next-line max-line-length
1389 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1390 		_burn(tokenId);
1391 	}
1392 }
1393 
1394 // File contracts/openzeppelin/contracts/utils/Counters.sol
1395 
1396 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @title Counters
1402  * @author Matt Condon (@shrugs)
1403  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1404  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1405  *
1406  * Include with `using Counters for Counters.Counter;`
1407  */
1408 library Counters {
1409 	struct Counter {
1410 		// This variable should never be directly accessed by users of the library: interactions must be restricted to
1411 		// the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1412 		// this feature: see https://github.com/ethereum/solidity/issues/4637
1413 		uint256 _value; // default: 0
1414 	}
1415 
1416 	function current(Counter storage counter) internal view returns (uint256) {
1417 		return counter._value;
1418 	}
1419 
1420 	function increment(Counter storage counter) internal {
1421 		unchecked {
1422 			counter._value += 1;
1423 		}
1424 	}
1425 
1426 	function decrement(Counter storage counter) internal {
1427 		uint256 value = counter._value;
1428 		require(value > 0, "Counter: decrement overflow");
1429 		unchecked {
1430 			counter._value = value - 1;
1431 		}
1432 	}
1433 
1434 	function reset(Counter storage counter) internal {
1435 		counter._value = 0;
1436 	}
1437 }
1438 
1439 // File contracts/NFT/NFT.sol
1440 
1441 pragma solidity ^0.8.7;
1442 
1443 contract NFT is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
1444 	using Counters for Counters.Counter;
1445 
1446 	Counters.Counter private _tokenIdCounter;
1447 	string private _baseTokenURI;
1448 	uint256 public maxAmount;
1449 	address public minterContract;
1450 	address public devAddress;
1451 
1452 	constructor(address _devAddress, uint256 _amount) ERC721("Bubbly and Friends", "BUBBLY") {
1453 		setDevAddress(_devAddress);
1454 		setMaxAmount(_amount);
1455 	}
1456 
1457 	modifier checkMaxAmount() {
1458 		require(maxAmount > _tokenIdCounter.current(), "Maximum number of NFTs reached.");
1459 		_;
1460 	}
1461 
1462 	modifier onlyDev() {
1463 		require(_msgSender() == devAddress);
1464 		_;
1465 	}
1466 
1467 	modifier onlyMinter() {
1468 		require(_msgSender() == minterContract);
1469 		_;
1470 	}
1471 
1472 	function pause() public onlyOwner {
1473 		_pause();
1474 	}
1475 
1476 	function unpause() public onlyOwner {
1477 		_unpause();
1478 	}
1479 
1480 	// !! Sale Contract Only mintable
1481 	function saleMint(address to) external checkMaxAmount onlyMinter {
1482 		_tokenIdCounter.increment();
1483 		uint256 _tokenId = _tokenIdCounter.current();
1484 		_mint(to, _tokenId);
1485 	}
1486 
1487 	function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1488 		require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1489 		return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId)));
1490 	}
1491 
1492 	function setBaseURI(string memory _uri) public onlyDev {
1493 		_baseTokenURI = _uri;
1494 	}
1495 
1496 	function setMinterContract(address saleContract) public onlyDev {
1497 		minterContract = saleContract;
1498 	}
1499 
1500 	function setDevAddress(address _devAddress) public onlyOwner {
1501 		devAddress = _devAddress;
1502 	}
1503 
1504 	function setMaxAmount(uint256 _amount) public onlyDev {
1505 		maxAmount = _amount;
1506 	}
1507 
1508 	function _baseURI() internal view virtual override returns (string memory) {
1509 		return _baseTokenURI;
1510 	}
1511 
1512 	function _beforeTokenTransfer(
1513 		address from,
1514 		address to,
1515 		uint256 tokenId
1516 	) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1517 		super._beforeTokenTransfer(from, to, tokenId);
1518 	}
1519 
1520 	function _afterTokenTransfer(
1521 		address from,
1522 		address to,
1523 		uint256 tokenId
1524 	) internal override(ERC721) {
1525 		super._afterTokenTransfer(from, to, tokenId);
1526 	}
1527 
1528 	function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1529 		return super.supportsInterface(interfaceId);
1530 	}
1531 }