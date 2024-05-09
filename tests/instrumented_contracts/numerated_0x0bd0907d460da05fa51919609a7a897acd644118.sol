1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11 	/**
12 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13 	 */
14 	function toString(uint256 value) internal pure returns (string memory) {
15 		// Inspired by OraclizeAPI's implementation - MIT licence
16 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18 		if (value == 0) {
19 			return "0";
20 		}
21 		uint256 temp = value;
22 		uint256 digits;
23 		while (temp != 0) {
24 			digits++;
25 			temp /= 10;
26 		}
27 		bytes memory buffer = new bytes(digits);
28 		while (value != 0) {
29 			digits -= 1;
30 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31 			value /= 10;
32 		}
33 		return string(buffer);
34 	}
35 
36 	/**
37 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38 	 */
39 	function toHexString(uint256 value) internal pure returns (string memory) {
40 		if (value == 0) {
41 			return "0x00";
42 		}
43 		uint256 temp = value;
44 		uint256 length = 0;
45 		while (temp != 0) {
46 			length++;
47 			temp >>= 8;
48 		}
49 		return toHexString(value, length);
50 	}
51 
52 	/**
53 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54 	 */
55 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56 		bytes memory buffer = new bytes(2 * length + 2);
57 		buffer[0] = "0";
58 		buffer[1] = "x";
59 		for (uint256 i = 2 * length + 1; i > 1; --i) {
60 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
61 			value >>= 4;
62 		}
63 		require(value == 0, "Strings: hex length insufficient");
64 		return string(buffer);
65 	}
66 }
67 
68 /**
69  * @title ERC721 token receiver interface
70  * @dev Interface for any contract that wants to support safeTransfers
71  * from ERC721 asset contracts.
72  */
73 interface IERC721Receiver {
74 	/**
75 	 * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
76 	 * by `operator` from `from`, this function is called.
77 	 *
78 	 * It must return its Solidity selector to confirm the token transfer.
79 	 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
80 	 *
81 	 * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
82 	 */
83 	function onERC721Received(
84 		address operator,
85 		address from,
86 		uint256 tokenId,
87 		bytes calldata data
88 	) external returns (bytes4);
89 }
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95 	/**
96 	 * @dev Returns true if `account` is a contract.
97 	 *
98 	 * [IMPORTANT]
99 	 * ====
100 	 * It is unsafe to assume that an address for which this function returns
101 	 * false is an externally-owned account (EOA) and not a contract.
102 	 *
103 	 * Among others, `isContract` will return false for the following
104 	 * types of addresses:
105 	 *
106 	 *  - an externally-owned account
107 	 *  - a contract in construction
108 	 *  - an address where a contract will be created
109 	 *  - an address where a contract lived, but was destroyed
110 	 * ====
111 	 */
112 	function isContract(address account) internal view returns (bool) {
113 		// This method relies on extcodesize, which returns 0 for contracts in
114 		// construction, since the code is only stored at the end of the
115 		// constructor execution.
116 
117 		uint256 size;
118 		assembly {
119 			size := extcodesize(account)
120 		}
121 		return size > 0;
122 	}
123 
124 	/**
125 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126 	 * `recipient`, forwarding all available gas and reverting on errors.
127 	 *
128 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
130 	 * imposed by `transfer`, making them unable to receive funds via
131 	 * `transfer`. {sendValue} removes this limitation.
132 	 *
133 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134 	 *
135 	 * IMPORTANT: because control is transferred to `recipient`, care must be
136 	 * taken to not create reentrancy vulnerabilities. Consider using
137 	 * {ReentrancyGuard} or the
138 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139 	 */
140 	function sendValue(address payable recipient, uint256 amount) internal {
141 		require(address(this).balance >= amount, "Address: insufficient balance");
142 
143 		(bool success, ) = recipient.call{value: amount}("");
144 		require(success, "Address: unable to send value, recipient may have reverted");
145 	}
146 
147 	/**
148 	 * @dev Performs a Solidity function call using a low level `call`. A
149 	 * plain `call` is an unsafe replacement for a function call: use this
150 	 * function instead.
151 	 *
152 	 * If `target` reverts with a revert reason, it is bubbled up by this
153 	 * function (like regular Solidity function calls).
154 	 *
155 	 * Returns the raw returned data. To convert to the expected return value,
156 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157 	 *
158 	 * Requirements:
159 	 *
160 	 * - `target` must be a contract.
161 	 * - calling `target` with `data` must not revert.
162 	 *
163 	 * _Available since v3.1._
164 	 */
165 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166 		return functionCall(target, data, "Address: low-level call failed");
167 	}
168 
169 	/**
170 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171 	 * `errorMessage` as a fallback revert reason when `target` reverts.
172 	 *
173 	 * _Available since v3.1._
174 	 */
175 	function functionCall(
176 		address target,
177 		bytes memory data,
178 		string memory errorMessage
179 	) internal returns (bytes memory) {
180 		return functionCallWithValue(target, data, 0, errorMessage);
181 	}
182 
183 	/**
184 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185 	 * but also transferring `value` wei to `target`.
186 	 *
187 	 * Requirements:
188 	 *
189 	 * - the calling contract must have an ETH balance of at least `value`.
190 	 * - the called Solidity function must be `payable`.
191 	 *
192 	 * _Available since v3.1._
193 	 */
194 	function functionCallWithValue(
195 		address target,
196 		bytes memory data,
197 		uint256 value
198 	) internal returns (bytes memory) {
199 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200 	}
201 
202 	/**
203 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
205 	 *
206 	 * _Available since v3.1._
207 	 */
208 	function functionCallWithValue(
209 		address target,
210 		bytes memory data,
211 		uint256 value,
212 		string memory errorMessage
213 	) internal returns (bytes memory) {
214 		require(address(this).balance >= value, "Address: insufficient balance for call");
215 		require(isContract(target), "Address: call to non-contract");
216 
217 		(bool success, bytes memory returndata) = target.call{value: value}(data);
218 		return verifyCallResult(success, returndata, errorMessage);
219 	}
220 
221 	/**
222 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223 	 * but performing a static call.
224 	 *
225 	 * _Available since v3.3._
226 	 */
227 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228 		return functionStaticCall(target, data, "Address: low-level static call failed");
229 	}
230 
231 	/**
232 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233 	 * but performing a static call.
234 	 *
235 	 * _Available since v3.3._
236 	 */
237 	function functionStaticCall(
238 		address target,
239 		bytes memory data,
240 		string memory errorMessage
241 	) internal view returns (bytes memory) {
242 		require(isContract(target), "Address: static call to non-contract");
243 
244 		(bool success, bytes memory returndata) = target.staticcall(data);
245 		return verifyCallResult(success, returndata, errorMessage);
246 	}
247 
248 	/**
249 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250 	 * but performing a delegate call.
251 	 *
252 	 * _Available since v3.4._
253 	 */
254 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256 	}
257 
258 	/**
259 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260 	 * but performing a delegate call.
261 	 *
262 	 * _Available since v3.4._
263 	 */
264 	function functionDelegateCall(
265 		address target,
266 		bytes memory data,
267 		string memory errorMessage
268 	) internal returns (bytes memory) {
269 		require(isContract(target), "Address: delegate call to non-contract");
270 
271 		(bool success, bytes memory returndata) = target.delegatecall(data);
272 		return verifyCallResult(success, returndata, errorMessage);
273 	}
274 
275 	/**
276 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277 	 * revert reason using the provided one.
278 	 *
279 	 * _Available since v4.3._
280 	 */
281 	function verifyCallResult(
282 		bool success,
283 		bytes memory returndata,
284 		string memory errorMessage
285 	) internal pure returns (bytes memory) {
286 		if (success) {
287 			return returndata;
288 		} else {
289 			// Look for revert reason and bubble it up if present
290 			if (returndata.length > 0) {
291 				// The easiest way to bubble the revert reason is using memory via assembly
292 
293 				assembly {
294 					let returndata_size := mload(returndata)
295 					revert(add(32, returndata), returndata_size)
296 				}
297 			} else {
298 				revert(errorMessage);
299 			}
300 		}
301 	}
302 }
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315 	function _msgSender() internal view virtual returns (address) {
316 		return msg.sender;
317 	}
318 
319 	function _msgData() internal view virtual returns (bytes calldata) {
320 		return msg.data;
321 	}
322 }
323 
324 /**
325  * @dev Contract module which provides a basic access control mechanism, where
326  * there is an account (an owner) that can be granted exclusive access to
327  * specific functions.
328  *
329  * By default, the owner account will be the one that deploys the contract. This
330  * can later be changed with {transferOwnership}.
331  *
332  * This module is used through inheritance. It will make available the modifier
333  * `onlyOwner`, which can be applied to your functions to restrict their use to
334  * the owner.
335  */
336 abstract contract Ownable is Context {
337 	address private _owner;
338 
339 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
340 
341 	/**
342 	 * @dev Initializes the contract setting the deployer as the initial owner.
343 	 */
344 	constructor() {
345 		_transferOwnership(_msgSender());
346 	}
347 
348 	/**
349 	 * @dev Returns the address of the current owner.
350 	 */
351 	function owner() public view virtual returns (address) {
352 		return _owner;
353 	}
354 
355 	/**
356 	 * @dev Throws if called by any account other than the owner.
357 	 */
358 	modifier onlyOwner() {
359 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
360 		_;
361 	}
362 
363 	/**
364 	 * @dev Leaves the contract without owner. It will not be possible to call
365 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
366 	 *
367 	 * NOTE: Renouncing ownership will leave the contract without an owner,
368 	 * thereby removing any functionality that is only available to the owner.
369 	 */
370 	function renounceOwnership() public virtual onlyOwner {
371 		_transferOwnership(address(0));
372 	}
373 
374 	/**
375 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
376 	 * Can only be called by the current owner.
377 	 */
378 	function transferOwnership(address newOwner) public virtual onlyOwner {
379 		require(newOwner != address(0), "Ownable: new owner is the zero address");
380 		_transferOwnership(newOwner);
381 	}
382 
383 	/**
384 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
385 	 * Internal function without access restriction.
386 	 */
387 	function _transferOwnership(address newOwner) internal virtual {
388 		address oldOwner = _owner;
389 		_owner = newOwner;
390 		emit OwnershipTransferred(oldOwner, newOwner);
391 	}
392 }
393 
394 
395 /**
396  * @dev Interface of the ERC165 standard, as defined in the
397  * https://eips.ethereum.org/EIPS/eip-165[EIP].
398  *
399  * Implementers can declare support of contract interfaces, which can then be
400  * queried by others ({ERC165Checker}).
401  *
402  * For an implementation, see {ERC165}.
403  */
404 interface IERC165 {
405 	/**
406 	 * @dev Returns true if this contract implements the interface defined by
407 	 * `interfaceId`. See the corresponding
408 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
409 	 * to learn more about how these ids are created.
410 	 *
411 	 * This function call must use less than 30 000 gas.
412 	 */
413 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
414 }
415 
416 /**
417  * @dev Implementation of the {IERC165} interface.
418  *
419  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
420  * for the additional interface id that will be supported. For example:
421  *
422  * ```solidity
423  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
425  * }
426  * ```
427  *
428  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
429  */
430 abstract contract ERC165 is IERC165 {
431 	/**
432 	 * @dev See {IERC165-supportsInterface}.
433 	 */
434 	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435 		return interfaceId == type(IERC165).interfaceId;
436 	}
437 }
438 
439 
440 /**
441  * @dev Required interface of an ERC721 compliant contract.
442  */
443 interface IERC721 is IERC165 {
444 	/**
445 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
446 	 */
447 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
448 
449 	/**
450 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
451 	 */
452 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
453 
454 	/**
455 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
456 	 */
457 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
458 
459 	/**
460 	 * @dev Returns the number of tokens in ``owner``'s account.
461 	 */
462 	function balanceOf(address owner) external view returns (uint256 balance);
463 
464 	/**
465 	 * @dev Returns the owner of the `tokenId` token.
466 	 *
467 	 * Requirements:
468 	 *
469 	 * - `tokenId` must exist.
470 	 */
471 	function ownerOf(uint256 tokenId) external view returns (address owner);
472 
473 	/**
474 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476 	 *
477 	 * Requirements:
478 	 *
479 	 * - `from` cannot be the zero address.
480 	 * - `to` cannot be the zero address.
481 	 * - `tokenId` token must exist and be owned by `from`.
482 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484 	 *
485 	 * Emits a {Transfer} event.
486 	 */
487 	function safeTransferFrom(
488 		address from,
489 		address to,
490 		uint256 tokenId
491 	) external;
492 
493 	/**
494 	 * @dev Transfers `tokenId` token from `from` to `to`.
495 	 *
496 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497 	 *
498 	 * Requirements:
499 	 *
500 	 * - `from` cannot be the zero address.
501 	 * - `to` cannot be the zero address.
502 	 * - `tokenId` token must be owned by `from`.
503 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504 	 *
505 	 * Emits a {Transfer} event.
506 	 */
507 	function transferFrom(
508 		address from,
509 		address to,
510 		uint256 tokenId
511 	) external;
512 
513 	/**
514 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515 	 * The approval is cleared when the token is transferred.
516 	 *
517 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518 	 *
519 	 * Requirements:
520 	 *
521 	 * - The caller must own the token or be an approved operator.
522 	 * - `tokenId` must exist.
523 	 *
524 	 * Emits an {Approval} event.
525 	 */
526 	function approve(address to, uint256 tokenId) external;
527 
528 	/**
529 	 * @dev Returns the account approved for `tokenId` token.
530 	 *
531 	 * Requirements:
532 	 *
533 	 * - `tokenId` must exist.
534 	 */
535 	function getApproved(uint256 tokenId) external view returns (address operator);
536 
537 	/**
538 	 * @dev Approve or remove `operator` as an operator for the caller.
539 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
540 	 *
541 	 * Requirements:
542 	 *
543 	 * - The `operator` cannot be the caller.
544 	 *
545 	 * Emits an {ApprovalForAll} event.
546 	 */
547 	function setApprovalForAll(address operator, bool _approved) external;
548 
549 	/**
550 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551 	 *
552 	 * See {setApprovalForAll}
553 	 */
554 	function isApprovedForAll(address owner, address operator) external view returns (bool);
555 
556 	/**
557 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
558 	 *
559 	 * Requirements:
560 	 *
561 	 * - `from` cannot be the zero address.
562 	 * - `to` cannot be the zero address.
563 	 * - `tokenId` token must exist and be owned by `from`.
564 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566 	 *
567 	 * Emits a {Transfer} event.
568 	 */
569 	function safeTransferFrom(
570 		address from,
571 		address to,
572 		uint256 tokenId,
573 		bytes calldata data
574 	) external;
575 }
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582 	/**
583 	 * @dev Returns the token collection name.
584 	 */
585 	function name() external view returns (string memory);
586 
587 	/**
588 	 * @dev Returns the token collection symbol.
589 	 */
590 	function symbol() external view returns (string memory);
591 
592 	/**
593 	 * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594 	 */
595 	function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 /**
599  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
600  * @dev See https://eips.ethereum.org/EIPS/eip-721
601  */
602 interface IERC721Enumerable is IERC721 {
603 	/**
604 	 * @dev Returns the total amount of tokens stored by the contract.
605 	 */
606 	function totalSupply() external view returns (uint256);
607 
608 	/**
609 	 * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
610 	 * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
611 	 */
612 	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
613 
614 	/**
615 	 * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
616 	 * Use along with {totalSupply} to enumerate all tokens.
617 	 */
618 	function tokenByIndex(uint256 index) external view returns (uint256);
619 }
620 
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension, but not including the Enumerable extension, which is available separately as
625  * {ERC721Enumerable}.
626  */
627 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
628 	using Address for address;
629 	using Strings for uint256;
630 
631 	// Token name
632 	string private _name;
633 
634 	// Token symbol
635 	string private _symbol;
636 
637 	// Mapping from token ID to owner address
638 	mapping(uint256 => address) private _owners;
639 
640 	// Mapping owner address to token count
641 	mapping(address => uint256) private _balances;
642 
643 	// Mapping from token ID to approved address
644 	mapping(uint256 => address) private _tokenApprovals;
645 
646 	// Mapping from owner to operator approvals
647 	mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649 	/**
650 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
651 	 */
652 	constructor(string memory name_, string memory symbol_) {
653 		_name = name_;
654 		_symbol = symbol_;
655 	}
656 
657 	/**
658 	 * @dev See {IERC165-supportsInterface}.
659 	 */
660 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661 		return
662 			interfaceId == type(IERC721).interfaceId ||
663 			interfaceId == type(IERC721Metadata).interfaceId ||
664 			super.supportsInterface(interfaceId);
665 	}
666 
667 	/**
668 	 * @dev See {IERC721-balanceOf}.
669 	 */
670 	function balanceOf(address owner) public view virtual override returns (uint256) {
671 		require(owner != address(0), "ERC721: balance query for the zero address");
672 		return _balances[owner];
673 	}
674 
675 	/**
676 	 * @dev See {IERC721-ownerOf}.
677 	 */
678 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679 		address owner = _owners[tokenId];
680 		require(owner != address(0), "ERC721: owner query for nonexistent token");
681 		return owner;
682 	}
683 
684 	/**
685 	 * @dev See {IERC721Metadata-name}.
686 	 */
687 	function name() public view virtual override returns (string memory) {
688 		return _name;
689 	}
690 
691 	/**
692 	 * @dev See {IERC721Metadata-symbol}.
693 	 */
694 	function symbol() public view virtual override returns (string memory) {
695 		return _symbol;
696 	}
697 
698 	/**
699 	 * @dev See {IERC721Metadata-tokenURI}.
700 	 */
701 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
702 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
703 
704 		string memory baseURI = _baseURI();
705 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
706 	}
707 
708 	/**
709 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
710 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
711 	 * by default, can be overriden in child contracts.
712 	 */
713 	function _baseURI() internal view virtual returns (string memory) {
714 		return "";
715 	}
716 
717 	/**
718 	 * @dev See {IERC721-approve}.
719 	 */
720 	function approve(address to, uint256 tokenId) public virtual override {
721 		address owner = ERC721.ownerOf(tokenId);
722 		require(to != owner, "ERC721: approval to current owner");
723 
724 		require(
725 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
726 			"ERC721: approve caller is not owner nor approved for all"
727 		);
728 
729 		_approve(to, tokenId);
730 	}
731 
732 	/**
733 	 * @dev See {IERC721-getApproved}.
734 	 */
735 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
736 		require(_exists(tokenId), "ERC721: approved query for nonexistent token");
737 
738 		return _tokenApprovals[tokenId];
739 	}
740 
741 	/**
742 	 * @dev See {IERC721-setApprovalForAll}.
743 	 */
744 	function setApprovalForAll(address operator, bool approved) public virtual override {
745 		require(operator != _msgSender(), "ERC721: approve to caller");
746 
747 		_operatorApprovals[_msgSender()][operator] = approved;
748 		emit ApprovalForAll(_msgSender(), operator, approved);
749 	}
750 
751 	/**
752 	 * @dev See {IERC721-isApprovedForAll}.
753 	 */
754 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
755 		return _operatorApprovals[owner][operator];
756 	}
757 
758 	/**
759 	 * @dev See {IERC721-transferFrom}.
760 	 */
761 	function transferFrom(
762 		address from,
763 		address to,
764 		uint256 tokenId
765 	) public virtual override {
766 		//solhint-disable-next-line max-line-length
767 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
768 
769 		_transfer(from, to, tokenId);
770 	}
771 
772 	/**
773 	 * @dev See {IERC721-safeTransferFrom}.
774 	 */
775 	function safeTransferFrom(
776 		address from,
777 		address to,
778 		uint256 tokenId
779 	) public virtual override {
780 		safeTransferFrom(from, to, tokenId, "");
781 	}
782 
783 	/**
784 	 * @dev See {IERC721-safeTransferFrom}.
785 	 */
786 	function safeTransferFrom(
787 		address from,
788 		address to,
789 		uint256 tokenId,
790 		bytes memory _data
791 	) public virtual override {
792 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
793 		_safeTransfer(from, to, tokenId, _data);
794 	}
795 
796 	/**
797 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
798 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
799 	 *
800 	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
801 	 *
802 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
803 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
804 	 *
805 	 * Requirements:
806 	 *
807 	 * - `from` cannot be the zero address.
808 	 * - `to` cannot be the zero address.
809 	 * - `tokenId` token must exist and be owned by `from`.
810 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811 	 *
812 	 * Emits a {Transfer} event.
813 	 */
814 	function _safeTransfer(
815 		address from,
816 		address to,
817 		uint256 tokenId,
818 		bytes memory _data
819 	) internal virtual {
820 		_transfer(from, to, tokenId);
821 		require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
822 	}
823 
824 	/**
825 	 * @dev Returns whether `tokenId` exists.
826 	 *
827 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
828 	 *
829 	 * Tokens start existing when they are minted (`_mint`),
830 	 * and stop existing when they are burned (`_burn`).
831 	 */
832 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
833 		return _owners[tokenId] != address(0);
834 	}
835 
836 	/**
837 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
838 	 *
839 	 * Requirements:
840 	 *
841 	 * - `tokenId` must exist.
842 	 */
843 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
844 		require(_exists(tokenId), "ERC721: operator query for nonexistent token");
845 		address owner = ERC721.ownerOf(tokenId);
846 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
847 	}
848 
849 	/**
850 	 * @dev Safely mints `tokenId` and transfers it to `to`.
851 	 *
852 	 * Requirements:
853 	 *
854 	 * - `tokenId` must not exist.
855 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856 	 *
857 	 * Emits a {Transfer} event.
858 	 */
859 	function _safeMint(address to, uint256 tokenId) internal virtual {
860 		_safeMint(to, tokenId, "");
861 	}
862 
863 	/**
864 	 * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
865 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
866 	 */
867 	function _safeMint(
868 		address to,
869 		uint256 tokenId,
870 		bytes memory _data
871 	) internal virtual {
872 		_mint(to, tokenId);
873 		require(
874 			_checkOnERC721Received(address(0), to, tokenId, _data),
875 			"ERC721: transfer to non ERC721Receiver implementer"
876 		);
877 	}
878 
879 	/**
880 	 * @dev Mints `tokenId` and transfers it to `to`.
881 	 *
882 	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
883 	 *
884 	 * Requirements:
885 	 *
886 	 * - `tokenId` must not exist.
887 	 * - `to` cannot be the zero address.
888 	 *
889 	 * Emits a {Transfer} event.
890 	 */
891 	function _mint(address to, uint256 tokenId) internal virtual {
892 		require(to != address(0), "ERC721: mint to the zero address");
893 		require(!_exists(tokenId), "ERC721: token already minted");
894 
895 		_beforeTokenTransfer(address(0), to, tokenId);
896 
897 		_balances[to] += 1;
898 		_owners[tokenId] = to;
899 
900 		emit Transfer(address(0), to, tokenId);
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
914 		address owner = ERC721.ownerOf(tokenId);
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
925 	}
926 
927 	/**
928 	 * @dev Transfers `tokenId` from `from` to `to`.
929 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
930 	 *
931 	 * Requirements:
932 	 *
933 	 * - `to` cannot be the zero address.
934 	 * - `tokenId` token must be owned by `from`.
935 	 *
936 	 * Emits a {Transfer} event.
937 	 */
938 	function _transfer(
939 		address from,
940 		address to,
941 		uint256 tokenId
942 	) internal virtual {
943 		require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
944 		require(to != address(0), "ERC721: transfer to the zero address");
945 
946 		_beforeTokenTransfer(from, to, tokenId);
947 
948 		// Clear approvals from the previous owner
949 		_approve(address(0), tokenId);
950 
951 		_balances[from] -= 1;
952 		_balances[to] += 1;
953 		_owners[tokenId] = to;
954 
955 		emit Transfer(from, to, tokenId);
956 	}
957 
958 	/**
959 	 * @dev Approve `to` to operate on `tokenId`
960 	 *
961 	 * Emits a {Approval} event.
962 	 */
963 	function _approve(address to, uint256 tokenId) internal virtual {
964 		_tokenApprovals[tokenId] = to;
965 		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
966 	}
967 
968 	/**
969 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
970 	 * The call is not executed if the target address is not a contract.
971 	 *
972 	 * @param from address representing the previous owner of the given token ID
973 	 * @param to target address that will receive the tokens
974 	 * @param tokenId uint256 ID of the token to be transferred
975 	 * @param _data bytes optional data to send along with the call
976 	 * @return bool whether the call correctly returned the expected magic value
977 	 */
978 	function _checkOnERC721Received(
979 		address from,
980 		address to,
981 		uint256 tokenId,
982 		bytes memory _data
983 	) private returns (bool) {
984 		if (to.isContract()) {
985 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
986 				return retval == IERC721Receiver.onERC721Received.selector;
987 			} catch (bytes memory reason) {
988 				if (reason.length == 0) {
989 					revert("ERC721: transfer to non ERC721Receiver implementer");
990 				} else {
991 					assembly {
992 						revert(add(32, reason), mload(reason))
993 					}
994 				}
995 			}
996 		} else {
997 			return true;
998 		}
999 	}
1000 
1001 	/**
1002 	 * @dev Hook that is called before any token transfer. This includes minting
1003 	 * and burning.
1004 	 *
1005 	 * Calling conditions:
1006 	 *
1007 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1008 	 * transferred to `to`.
1009 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1010 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1011 	 * - `from` and `to` are never both zero.
1012 	 *
1013 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1014 	 */
1015 	function _beforeTokenTransfer(
1016 		address from,
1017 		address to,
1018 		uint256 tokenId
1019 	) internal virtual {}
1020 }
1021 
1022 /**
1023  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1024  * enumerability of all the token ids in the contract as well as all token ids owned by each
1025  * account.
1026  */
1027 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1028 	// Mapping from owner to list of owned token IDs
1029 	mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1030 
1031 	// Mapping from token ID to index of the owner tokens list
1032 	mapping(uint256 => uint256) private _ownedTokensIndex;
1033 
1034 	// Array with all token ids, used for enumeration
1035 	uint256[] private _allTokens;
1036 
1037 	// Mapping from token id to position in the allTokens array
1038 	mapping(uint256 => uint256) private _allTokensIndex;
1039 
1040 	/**
1041 	 * @dev See {IERC165-supportsInterface}.
1042 	 */
1043 	function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1044 		return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1045 	}
1046 
1047 	/**
1048 	 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1049 	 */
1050 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1051 		require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1052 		return _ownedTokens[owner][index];
1053 	}
1054 
1055 	/**
1056 	 * @dev See {IERC721Enumerable-totalSupply}.
1057 	 */
1058 	function totalSupply() public view virtual override returns (uint256) {
1059 		return _allTokens.length;
1060 	}
1061 
1062 	/**
1063 	 * @dev See {IERC721Enumerable-tokenByIndex}.
1064 	 */
1065 	function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1066 		require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1067 		return _allTokens[index];
1068 	}
1069 
1070 	/**
1071 	 * @dev Hook that is called before any token transfer. This includes minting
1072 	 * and burning.
1073 	 *
1074 	 * Calling conditions:
1075 	 *
1076 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077 	 * transferred to `to`.
1078 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1079 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080 	 * - `from` cannot be the zero address.
1081 	 * - `to` cannot be the zero address.
1082 	 *
1083 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1084 	 */
1085 	function _beforeTokenTransfer(
1086 		address from,
1087 		address to,
1088 		uint256 tokenId
1089 	) internal virtual override {
1090 		super._beforeTokenTransfer(from, to, tokenId);
1091 
1092 		if (from == address(0)) {
1093 			_addTokenToAllTokensEnumeration(tokenId);
1094 		} else if (from != to) {
1095 			_removeTokenFromOwnerEnumeration(from, tokenId);
1096 		}
1097 		if (to == address(0)) {
1098 			_removeTokenFromAllTokensEnumeration(tokenId);
1099 		} else if (to != from) {
1100 			_addTokenToOwnerEnumeration(to, tokenId);
1101 		}
1102 	}
1103 
1104 	/**
1105 	 * @dev Private function to add a token to this extension's ownership-tracking data structures.
1106 	 * @param to address representing the new owner of the given token ID
1107 	 * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1108 	 */
1109 	function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1110 		uint256 length = ERC721.balanceOf(to);
1111 		_ownedTokens[to][length] = tokenId;
1112 		_ownedTokensIndex[tokenId] = length;
1113 	}
1114 
1115 	/**
1116 	 * @dev Private function to add a token to this extension's token tracking data structures.
1117 	 * @param tokenId uint256 ID of the token to be added to the tokens list
1118 	 */
1119 	function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1120 		_allTokensIndex[tokenId] = _allTokens.length;
1121 		_allTokens.push(tokenId);
1122 	}
1123 
1124 	/**
1125 	 * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1126 	 * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1127 	 * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1128 	 * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1129 	 * @param from address representing the previous owner of the given token ID
1130 	 * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1131 	 */
1132 	function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1133 		// To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1134 		// then delete the last slot (swap and pop).
1135 
1136 		uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1137 		uint256 tokenIndex = _ownedTokensIndex[tokenId];
1138 
1139 		// When the token to delete is the last token, the swap operation is unnecessary
1140 		if (tokenIndex != lastTokenIndex) {
1141 			uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1142 
1143 			_ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144 			_ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145 		}
1146 
1147 		// This also deletes the contents at the last position of the array
1148 		delete _ownedTokensIndex[tokenId];
1149 		delete _ownedTokens[from][lastTokenIndex];
1150 	}
1151 
1152 	/**
1153 	 * @dev Private function to remove a token from this extension's token tracking data structures.
1154 	 * This has O(1) time complexity, but alters the order of the _allTokens array.
1155 	 * @param tokenId uint256 ID of the token to be removed from the tokens list
1156 	 */
1157 	function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1158 		// To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1159 		// then delete the last slot (swap and pop).
1160 
1161 		uint256 lastTokenIndex = _allTokens.length - 1;
1162 		uint256 tokenIndex = _allTokensIndex[tokenId];
1163 
1164 		// When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1165 		// rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1166 		// an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1167 		uint256 lastTokenId = _allTokens[lastTokenIndex];
1168 
1169 		_allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1170 		_allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1171 
1172 		// This also deletes the contents at the last position of the array
1173 		delete _allTokensIndex[tokenId];
1174 		_allTokens.pop();
1175 	}
1176 }
1177 
1178 contract thelilguys is ERC721Enumerable, Ownable {
1179 
1180 	using Strings for uint256;
1181 
1182 	string _baseTokenURI;
1183 	uint256 private _reserved = 50;
1184 	uint256 private _price = 0.045 ether;
1185 	bool public _paused = true;
1186 
1187 	string private _passPhrase;
1188 	bool public _claimPaused = true;
1189 
1190 	// withdraw address
1191 	address t1;
1192 
1193 	constructor(string memory baseURI, string memory passPhrase) ERC721("thelilguys", "LILGUYS")  {
1194 		setBaseURI(baseURI);
1195 		_passPhrase = passPhrase;
1196 		t1 = msg.sender;
1197 
1198 		// team gets the first lilguy
1199 		_safeMint(t1, 0);
1200 	}
1201 
1202 	function mintLilguys(uint256 num) public payable {
1203 		uint256 supply = totalSupply();
1204 		require( !_paused, "Sale paused" );
1205 		require( supply + num < 8501 - _reserved, "Exceeds maximum lilguys supply" );
1206 		require( msg.value >= _price * num, "Incorrect ether amount" );
1207 
1208 		for(uint256 i; i < num; i++){
1209 			_safeMint(msg.sender, supply + i);
1210 		}
1211 	}
1212 
1213 	function claimLilguy(string memory passCode) public {
1214 		require( !_claimPaused, "OG free mint is over");
1215 		uint256 supply = totalSupply();
1216 		require( supply < 501, "OG freemint sold out");
1217 		require( keccak256(bytes(passCode)) == keccak256(bytes(_passPhrase)), "Wrong passcode");
1218 		address sender = msg.sender;
1219 		require( balanceOf(sender) < 1, "OGs can only claim 1 lilguy");
1220 		_safeMint(sender, supply);
1221 	}
1222 
1223 	function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1224 		uint256 tokenCount = balanceOf(_owner);
1225 
1226 		uint256[] memory tokensId = new uint256[](tokenCount);
1227 		for(uint256 i; i < tokenCount; i++){
1228 			tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1229 		}
1230 		return tokensId;
1231 	}
1232 
1233 	// Just in case Eth does some crazy stuff
1234 	function setPrice(uint256 _newPrice) public onlyOwner {
1235 		_price = _newPrice;
1236 	}
1237 
1238 	function _baseURI() internal view virtual override returns (string memory) {
1239 		return _baseTokenURI;
1240 	}
1241 
1242 	function setBaseURI(string memory baseURI) public onlyOwner {
1243 		_baseTokenURI = baseURI;
1244 	}
1245 
1246 	function getPrice() public view returns (uint256) {
1247 		return _price;
1248 	}
1249 
1250 	function giveAway(address _to, uint256 _amount) external onlyOwner {
1251 		require( _amount <= _reserved, "Exceeds reserved lilguy supply" );
1252 
1253 		uint256 supply = totalSupply();
1254 		for(uint256 i; i < _amount; i++){
1255 			_safeMint( _to, supply + i );
1256 		}
1257 
1258 		_reserved -= _amount;
1259 	}
1260 
1261 	function pause(bool val) public onlyOwner {
1262 		_paused = val;
1263 	}
1264 
1265 	function pauseClaim(bool val) public onlyOwner {
1266 		_claimPaused = val;
1267 	}
1268 
1269 	function setPassPhrase(string memory newPass) public onlyOwner {
1270 		_passPhrase = newPass;
1271 	}
1272 
1273 	function withdrawAll() public onlyOwner {
1274 		address payable _to = payable(t1);
1275 		uint256 _balance = address(this).balance;
1276 		_to.transfer(_balance);
1277 	}
1278 }