1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15 	/**
16 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17 	 */
18 	function toString(uint256 value) internal pure returns (string memory) {
19 		// Inspired by OraclizeAPI's implementation - MIT licence
20 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22 		if (value == 0) {
23 			return "0";
24 		}
25 		uint256 temp = value;
26 		uint256 digits;
27 		while (temp != 0) {
28 			digits++;
29 			temp /= 10;
30 		}
31 		bytes memory buffer = new bytes(digits);
32 		while (value != 0) {
33 			digits -= 1;
34 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35 			value /= 10;
36 		}
37 		return string(buffer);
38 	}
39 
40 	/**
41 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42 	 */
43 	function toHexString(uint256 value) internal pure returns (string memory) {
44 		if (value == 0) {
45 			return "0x00";
46 		}
47 		uint256 temp = value;
48 		uint256 length = 0;
49 		while (temp != 0) {
50 			length++;
51 			temp >>= 8;
52 		}
53 		return toHexString(value, length);
54 	}
55 
56 	/**
57 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58 	 */
59 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60 		bytes memory buffer = new bytes(2 * length + 2);
61 		buffer[0] = "0";
62 		buffer[1] = "x";
63 		for (uint256 i = 2 * length + 1; i > 1; --i) {
64 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
65 			value >>= 4;
66 		}
67 		require(value == 0, "Strings: hex length insufficient");
68 		return string(buffer);
69 	}
70 }
71 
72 /**
73  * @title ERC721 token receiver interface
74  * @dev Interface for any contract that wants to support safeTransfers
75  * from ERC721 asset contracts.
76  */
77 interface IERC721Receiver {
78 	/**
79 	 * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
80 	 * by `operator` from `from`, this function is called.
81 	 *
82 	 * It must return its Solidity selector to confirm the token transfer.
83 	 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
84 	 *
85 	 * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
86 	 */
87 	function onERC721Received(
88 		address operator,
89 		address from,
90 		uint256 tokenId,
91 		bytes calldata data
92 	) external returns (bytes4);
93 }
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99 	/**
100 	 * @dev Returns true if `account` is a contract.
101 	 *
102 	 * [IMPORTANT]
103 	 * ====
104 	 * It is unsafe to assume that an address for which this function returns
105 	 * false is an externally-owned account (EOA) and not a contract.
106 	 *
107 	 * Among others, `isContract` will return false for the following
108 	 * types of addresses:
109 	 *
110 	 *  - an externally-owned account
111 	 *  - a contract in construction
112 	 *  - an address where a contract will be created
113 	 *  - an address where a contract lived, but was destroyed
114 	 * ====
115 	 */
116 	function isContract(address account) internal view returns (bool) {
117 		// This method relies on extcodesize, which returns 0 for contracts in
118 		// construction, since the code is only stored at the end of the
119 		// constructor execution.
120 
121 		uint256 size;
122 		assembly {
123 			size := extcodesize(account)
124 		}
125 		return size > 0;
126 	}
127 
128 	/**
129 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130 	 * `recipient`, forwarding all available gas and reverting on errors.
131 	 *
132 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
134 	 * imposed by `transfer`, making them unable to receive funds via
135 	 * `transfer`. {sendValue} removes this limitation.
136 	 *
137 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138 	 *
139 	 * IMPORTANT: because control is transferred to `recipient`, care must be
140 	 * taken to not create reentrancy vulnerabilities. Consider using
141 	 * {ReentrancyGuard} or the
142 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143 	 */
144 	function sendValue(address payable recipient, uint256 amount) internal {
145 		require(address(this).balance >= amount, "Address: insufficient balance");
146 
147 		(bool success, ) = recipient.call{value: amount}("");
148 		require(success, "Address: unable to send value, recipient may have reverted");
149 	}
150 
151 	/**
152 	 * @dev Performs a Solidity function call using a low level `call`. A
153 	 * plain `call` is an unsafe replacement for a function call: use this
154 	 * function instead.
155 	 *
156 	 * If `target` reverts with a revert reason, it is bubbled up by this
157 	 * function (like regular Solidity function calls).
158 	 *
159 	 * Returns the raw returned data. To convert to the expected return value,
160 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
161 	 *
162 	 * Requirements:
163 	 *
164 	 * - `target` must be a contract.
165 	 * - calling `target` with `data` must not revert.
166 	 *
167 	 * _Available since v3.1._
168 	 */
169 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170 		return functionCall(target, data, "Address: low-level call failed");
171 	}
172 
173 	/**
174 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
175 	 * `errorMessage` as a fallback revert reason when `target` reverts.
176 	 *
177 	 * _Available since v3.1._
178 	 */
179 	function functionCall(
180 		address target,
181 		bytes memory data,
182 		string memory errorMessage
183 	) internal returns (bytes memory) {
184 		return functionCallWithValue(target, data, 0, errorMessage);
185 	}
186 
187 	/**
188 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189 	 * but also transferring `value` wei to `target`.
190 	 *
191 	 * Requirements:
192 	 *
193 	 * - the calling contract must have an ETH balance of at least `value`.
194 	 * - the called Solidity function must be `payable`.
195 	 *
196 	 * _Available since v3.1._
197 	 */
198 	function functionCallWithValue(
199 		address target,
200 		bytes memory data,
201 		uint256 value
202 	) internal returns (bytes memory) {
203 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204 	}
205 
206 	/**
207 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
209 	 *
210 	 * _Available since v3.1._
211 	 */
212 	function functionCallWithValue(
213 		address target,
214 		bytes memory data,
215 		uint256 value,
216 		string memory errorMessage
217 	) internal returns (bytes memory) {
218 		require(address(this).balance >= value, "Address: insufficient balance for call");
219 		require(isContract(target), "Address: call to non-contract");
220 
221 		(bool success, bytes memory returndata) = target.call{value: value}(data);
222 		return verifyCallResult(success, returndata, errorMessage);
223 	}
224 
225 	/**
226 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227 	 * but performing a static call.
228 	 *
229 	 * _Available since v3.3._
230 	 */
231 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232 		return functionStaticCall(target, data, "Address: low-level static call failed");
233 	}
234 
235 	/**
236 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237 	 * but performing a static call.
238 	 *
239 	 * _Available since v3.3._
240 	 */
241 	function functionStaticCall(
242 		address target,
243 		bytes memory data,
244 		string memory errorMessage
245 	) internal view returns (bytes memory) {
246 		require(isContract(target), "Address: static call to non-contract");
247 
248 		(bool success, bytes memory returndata) = target.staticcall(data);
249 		return verifyCallResult(success, returndata, errorMessage);
250 	}
251 
252 	/**
253 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254 	 * but performing a delegate call.
255 	 *
256 	 * _Available since v3.4._
257 	 */
258 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260 	}
261 
262 	/**
263 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264 	 * but performing a delegate call.
265 	 *
266 	 * _Available since v3.4._
267 	 */
268 	function functionDelegateCall(
269 		address target,
270 		bytes memory data,
271 		string memory errorMessage
272 	) internal returns (bytes memory) {
273 		require(isContract(target), "Address: delegate call to non-contract");
274 
275 		(bool success, bytes memory returndata) = target.delegatecall(data);
276 		return verifyCallResult(success, returndata, errorMessage);
277 	}
278 
279 	/**
280 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281 	 * revert reason using the provided one.
282 	 *
283 	 * _Available since v4.3._
284 	 */
285 	function verifyCallResult(
286 		bool success,
287 		bytes memory returndata,
288 		string memory errorMessage
289 	) internal pure returns (bytes memory) {
290 		if (success) {
291 			return returndata;
292 		} else {
293 			// Look for revert reason and bubble it up if present
294 			if (returndata.length > 0) {
295 				// The easiest way to bubble the revert reason is using memory via assembly
296 
297 				assembly {
298 					let returndata_size := mload(returndata)
299 					revert(add(32, returndata), returndata_size)
300 				}
301 			} else {
302 				revert(errorMessage);
303 			}
304 		}
305 	}
306 }
307 
308 /**
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319 	function _msgSender() internal view virtual returns (address) {
320 		return msg.sender;
321 	}
322 
323 	function _msgData() internal view virtual returns (bytes calldata) {
324 		return msg.data;
325 	}
326 }
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341 	address private _owner;
342 
343 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345 	/**
346 	 * @dev Initializes the contract setting the deployer as the initial owner.
347 	 */
348 	constructor() {
349 		_transferOwnership(_msgSender());
350 	}
351 
352 	/**
353 	 * @dev Returns the address of the current owner.
354 	 */
355 	function owner() public view virtual returns (address) {
356 		return _owner;
357 	}
358 
359 	/**
360 	 * @dev Throws if called by any account other than the owner.
361 	 */
362 	modifier onlyOwner() {
363 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
364 		_;
365 	}
366 
367 	/**
368 	 * @dev Leaves the contract without owner. It will not be possible to call
369 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
370 	 *
371 	 * NOTE: Renouncing ownership will leave the contract without an owner,
372 	 * thereby removing any functionality that is only available to the owner.
373 	 */
374 	function renounceOwnership() public virtual onlyOwner {
375 		_transferOwnership(address(0));
376 	}
377 
378 	/**
379 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
380 	 * Can only be called by the current owner.
381 	 */
382 	function transferOwnership(address newOwner) public virtual onlyOwner {
383 		require(newOwner != address(0), "Ownable: new owner is the zero address");
384 		_transferOwnership(newOwner);
385 	}
386 
387 	/**
388 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
389 	 * Internal function without access restriction.
390 	 */
391 	function _transferOwnership(address newOwner) internal virtual {
392 		address oldOwner = _owner;
393 		_owner = newOwner;
394 		emit OwnershipTransferred(oldOwner, newOwner);
395 	}
396 }
397 
398 
399 /**
400  * @dev Interface of the ERC165 standard, as defined in the
401  * https://eips.ethereum.org/EIPS/eip-165[EIP].
402  *
403  * Implementers can declare support of contract interfaces, which can then be
404  * queried by others ({ERC165Checker}).
405  *
406  * For an implementation, see {ERC165}.
407  */
408 interface IERC165 {
409 	/**
410 	 * @dev Returns true if this contract implements the interface defined by
411 	 * `interfaceId`. See the corresponding
412 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413 	 * to learn more about how these ids are created.
414 	 *
415 	 * This function call must use less than 30 000 gas.
416 	 */
417 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 }
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435 	/**
436 	 * @dev See {IERC165-supportsInterface}.
437 	 */
438 	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439 		return interfaceId == type(IERC165).interfaceId;
440 	}
441 }
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448 	/**
449 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450 	 */
451 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453 	/**
454 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455 	 */
456 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458 	/**
459 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460 	 */
461 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463 	/**
464 	 * @dev Returns the number of tokens in ``owner``'s account.
465 	 */
466 	function balanceOf(address owner) external view returns (uint256 balance);
467 
468 	/**
469 	 * @dev Returns the owner of the `tokenId` token.
470 	 *
471 	 * Requirements:
472 	 *
473 	 * - `tokenId` must exist.
474 	 */
475 	function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477 	/**
478 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480 	 *
481 	 * Requirements:
482 	 *
483 	 * - `from` cannot be the zero address.
484 	 * - `to` cannot be the zero address.
485 	 * - `tokenId` token must exist and be owned by `from`.
486 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488 	 *
489 	 * Emits a {Transfer} event.
490 	 */
491 	function safeTransferFrom(
492 		address from,
493 		address to,
494 		uint256 tokenId
495 	) external;
496 
497 	/**
498 	 * @dev Transfers `tokenId` token from `from` to `to`.
499 	 *
500 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501 	 *
502 	 * Requirements:
503 	 *
504 	 * - `from` cannot be the zero address.
505 	 * - `to` cannot be the zero address.
506 	 * - `tokenId` token must be owned by `from`.
507 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508 	 *
509 	 * Emits a {Transfer} event.
510 	 */
511 	function transferFrom(
512 		address from,
513 		address to,
514 		uint256 tokenId
515 	) external;
516 
517 	/**
518 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519 	 * The approval is cleared when the token is transferred.
520 	 *
521 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522 	 *
523 	 * Requirements:
524 	 *
525 	 * - The caller must own the token or be an approved operator.
526 	 * - `tokenId` must exist.
527 	 *
528 	 * Emits an {Approval} event.
529 	 */
530 	function approve(address to, uint256 tokenId) external;
531 
532 	/**
533 	 * @dev Returns the account approved for `tokenId` token.
534 	 *
535 	 * Requirements:
536 	 *
537 	 * - `tokenId` must exist.
538 	 */
539 	function getApproved(uint256 tokenId) external view returns (address operator);
540 
541 	/**
542 	 * @dev Approve or remove `operator` as an operator for the caller.
543 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544 	 *
545 	 * Requirements:
546 	 *
547 	 * - The `operator` cannot be the caller.
548 	 *
549 	 * Emits an {ApprovalForAll} event.
550 	 */
551 	function setApprovalForAll(address operator, bool _approved) external;
552 
553 	/**
554 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555 	 *
556 	 * See {setApprovalForAll}
557 	 */
558 	function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560 	/**
561 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
562 	 *
563 	 * Requirements:
564 	 *
565 	 * - `from` cannot be the zero address.
566 	 * - `to` cannot be the zero address.
567 	 * - `tokenId` token must exist and be owned by `from`.
568 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570 	 *
571 	 * Emits a {Transfer} event.
572 	 */
573 	function safeTransferFrom(
574 		address from,
575 		address to,
576 		uint256 tokenId,
577 		bytes calldata data
578 	) external;
579 }
580 
581 /**
582  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
583  * @dev See https://eips.ethereum.org/EIPS/eip-721
584  */
585 interface IERC721Metadata is IERC721 {
586 	/**
587 	 * @dev Returns the token collection name.
588 	 */
589 	function name() external view returns (string memory);
590 
591 	/**
592 	 * @dev Returns the token collection symbol.
593 	 */
594 	function symbol() external view returns (string memory);
595 
596 	/**
597 	 * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
598 	 */
599 	function tokenURI(uint256 tokenId) external view returns (string memory);
600 }
601 
602 /**
603  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
604  * @dev See https://eips.ethereum.org/EIPS/eip-721
605  */
606 interface IERC721Enumerable is IERC721 {
607 	/**
608 	 * @dev Returns the total amount of tokens stored by the contract.
609 	 */
610 	function totalSupply() external view returns (uint256);
611 
612 	/**
613 	 * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
614 	 * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
615 	 */
616 	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
617 
618 	/**
619 	 * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
620 	 * Use along with {totalSupply} to enumerate all tokens.
621 	 */
622 	function tokenByIndex(uint256 index) external view returns (uint256);
623 }
624 
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata extension, but not including the Enumerable extension, which is available separately as
629  * {ERC721Enumerable}.
630  */
631 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
632 	using Address for address;
633 	using Strings for uint256;
634 
635 	// Token name
636 	string private _name;
637 
638 	// Token symbol
639 	string private _symbol;
640 
641 	// Mapping from token ID to owner address
642 	mapping(uint256 => address) private _owners;
643 
644 	// Mapping owner address to token count
645 	mapping(address => uint256) private _balances;
646 
647 	// Mapping from token ID to approved address
648 	mapping(uint256 => address) private _tokenApprovals;
649 
650 	// Mapping from owner to operator approvals
651 	mapping(address => mapping(address => bool)) private _operatorApprovals;
652 
653 	/**
654 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
655 	 */
656 	constructor(string memory name_, string memory symbol_) {
657 		_name = name_;
658 		_symbol = symbol_;
659 	}
660 
661 	/**
662 	 * @dev See {IERC165-supportsInterface}.
663 	 */
664 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
665 		return
666 			interfaceId == type(IERC721).interfaceId ||
667 			interfaceId == type(IERC721Metadata).interfaceId ||
668 			super.supportsInterface(interfaceId);
669 	}
670 
671 	/**
672 	 * @dev See {IERC721-balanceOf}.
673 	 */
674 	function balanceOf(address owner) public view virtual override returns (uint256) {
675 		require(owner != address(0), "ERC721: balance query for the zero address");
676 		return _balances[owner];
677 	}
678 
679 	/**
680 	 * @dev See {IERC721-ownerOf}.
681 	 */
682 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
683 		address owner = _owners[tokenId];
684 		require(owner != address(0), "ERC721: owner query for nonexistent token");
685 		return owner;
686 	}
687 
688 	/**
689 	 * @dev See {IERC721Metadata-name}.
690 	 */
691 	function name() public view virtual override returns (string memory) {
692 		return _name;
693 	}
694 
695 	/**
696 	 * @dev See {IERC721Metadata-symbol}.
697 	 */
698 	function symbol() public view virtual override returns (string memory) {
699 		return _symbol;
700 	}
701 
702 	/**
703 	 * @dev See {IERC721Metadata-tokenURI}.
704 	 */
705 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
706 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
707 
708 		string memory baseURI = _baseURI();
709 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
710 	}
711 
712 	/**
713 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
714 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
715 	 * by default, can be overriden in child contracts.
716 	 */
717 	function _baseURI() internal view virtual returns (string memory) {
718 		return "";
719 	}
720 
721 	/**
722 	 * @dev See {IERC721-approve}.
723 	 */
724 	function approve(address to, uint256 tokenId) public virtual override {
725 		address owner = ERC721.ownerOf(tokenId);
726 		require(to != owner, "ERC721: approval to current owner");
727 
728 		require(
729 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
730 			"ERC721: approve caller is not owner nor approved for all"
731 		);
732 
733 		_approve(to, tokenId);
734 	}
735 
736 	/**
737 	 * @dev See {IERC721-getApproved}.
738 	 */
739 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
740 		require(_exists(tokenId), "ERC721: approved query for nonexistent token");
741 
742 		return _tokenApprovals[tokenId];
743 	}
744 
745 	/**
746 	 * @dev See {IERC721-setApprovalForAll}.
747 	 */
748 	function setApprovalForAll(address operator, bool approved) public virtual override {
749 		require(operator != _msgSender(), "ERC721: approve to caller");
750 
751 		_operatorApprovals[_msgSender()][operator] = approved;
752 		emit ApprovalForAll(_msgSender(), operator, approved);
753 	}
754 
755 	/**
756 	 * @dev See {IERC721-isApprovedForAll}.
757 	 */
758 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
759 		return _operatorApprovals[owner][operator];
760 	}
761 
762 	/**
763 	 * @dev See {IERC721-transferFrom}.
764 	 */
765 	function transferFrom(
766 		address from,
767 		address to,
768 		uint256 tokenId
769 	) public virtual override {
770 		//solhint-disable-next-line max-line-length
771 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
772 
773 		_transfer(from, to, tokenId);
774 	}
775 
776 	/**
777 	 * @dev See {IERC721-safeTransferFrom}.
778 	 */
779 	function safeTransferFrom(
780 		address from,
781 		address to,
782 		uint256 tokenId
783 	) public virtual override {
784 		safeTransferFrom(from, to, tokenId, "");
785 	}
786 
787 	/**
788 	 * @dev See {IERC721-safeTransferFrom}.
789 	 */
790 	function safeTransferFrom(
791 		address from,
792 		address to,
793 		uint256 tokenId,
794 		bytes memory _data
795 	) public virtual override {
796 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797 		_safeTransfer(from, to, tokenId, _data);
798 	}
799 
800 	/**
801 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
802 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
803 	 *
804 	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
805 	 *
806 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
807 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
808 	 *
809 	 * Requirements:
810 	 *
811 	 * - `from` cannot be the zero address.
812 	 * - `to` cannot be the zero address.
813 	 * - `tokenId` token must exist and be owned by `from`.
814 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815 	 *
816 	 * Emits a {Transfer} event.
817 	 */
818 	function _safeTransfer(
819 		address from,
820 		address to,
821 		uint256 tokenId,
822 		bytes memory _data
823 	) internal virtual {
824 		_transfer(from, to, tokenId);
825 		require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
826 	}
827 
828 	/**
829 	 * @dev Returns whether `tokenId` exists.
830 	 *
831 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
832 	 *
833 	 * Tokens start existing when they are minted (`_mint`),
834 	 * and stop existing when they are burned (`_burn`).
835 	 */
836 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
837 		return _owners[tokenId] != address(0);
838 	}
839 
840 	/**
841 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
842 	 *
843 	 * Requirements:
844 	 *
845 	 * - `tokenId` must exist.
846 	 */
847 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
848 		require(_exists(tokenId), "ERC721: operator query for nonexistent token");
849 		address owner = ERC721.ownerOf(tokenId);
850 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
851 	}
852 
853 	/**
854 	 * @dev Safely mints `tokenId` and transfers it to `to`.
855 	 *
856 	 * Requirements:
857 	 *
858 	 * - `tokenId` must not exist.
859 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860 	 *
861 	 * Emits a {Transfer} event.
862 	 */
863 	function _safeMint(address to, uint256 tokenId) internal virtual {
864 		_safeMint(to, tokenId, "");
865 	}
866 
867 	/**
868 	 * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
869 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
870 	 */
871 	function _safeMint(
872 		address to,
873 		uint256 tokenId,
874 		bytes memory _data
875 	) internal virtual {
876 		_mint(to, tokenId);
877 		require(
878 			_checkOnERC721Received(address(0), to, tokenId, _data),
879 			"ERC721: transfer to non ERC721Receiver implementer"
880 		);
881 	}
882 
883 	/**
884 	 * @dev Mints `tokenId` and transfers it to `to`.
885 	 *
886 	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
887 	 *
888 	 * Requirements:
889 	 *
890 	 * - `tokenId` must not exist.
891 	 * - `to` cannot be the zero address.
892 	 *
893 	 * Emits a {Transfer} event.
894 	 */
895 	function _mint(address to, uint256 tokenId) internal virtual {
896 		require(to != address(0), "ERC721: mint to the zero address");
897 		require(!_exists(tokenId), "ERC721: token already minted");
898 
899 		_beforeTokenTransfer(address(0), to, tokenId);
900 
901 		_balances[to] += 1;
902 		_owners[tokenId] = to;
903 
904 		emit Transfer(address(0), to, tokenId);
905 	}
906 
907 	/**
908 	 * @dev Destroys `tokenId`.
909 	 * The approval is cleared when the token is burned.
910 	 *
911 	 * Requirements:
912 	 *
913 	 * - `tokenId` must exist.
914 	 *
915 	 * Emits a {Transfer} event.
916 	 */
917 	function _burn(uint256 tokenId) internal virtual {
918 		address owner = ERC721.ownerOf(tokenId);
919 
920 		_beforeTokenTransfer(owner, address(0), tokenId);
921 
922 		// Clear approvals
923 		_approve(address(0), tokenId);
924 
925 		_balances[owner] -= 1;
926 		delete _owners[tokenId];
927 
928 		emit Transfer(owner, address(0), tokenId);
929 	}
930 
931 	/**
932 	 * @dev Transfers `tokenId` from `from` to `to`.
933 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
934 	 *
935 	 * Requirements:
936 	 *
937 	 * - `to` cannot be the zero address.
938 	 * - `tokenId` token must be owned by `from`.
939 	 *
940 	 * Emits a {Transfer} event.
941 	 */
942 	function _transfer(
943 		address from,
944 		address to,
945 		uint256 tokenId
946 	) internal virtual {
947 		require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
948 		require(to != address(0), "ERC721: transfer to the zero address");
949 
950 		_beforeTokenTransfer(from, to, tokenId);
951 
952 		// Clear approvals from the previous owner
953 		_approve(address(0), tokenId);
954 
955 		_balances[from] -= 1;
956 		_balances[to] += 1;
957 		_owners[tokenId] = to;
958 
959 		emit Transfer(from, to, tokenId);
960 	}
961 
962 	/**
963 	 * @dev Approve `to` to operate on `tokenId`
964 	 *
965 	 * Emits a {Approval} event.
966 	 */
967 	function _approve(address to, uint256 tokenId) internal virtual {
968 		_tokenApprovals[tokenId] = to;
969 		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
970 	}
971 
972 	/**
973 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
974 	 * The call is not executed if the target address is not a contract.
975 	 *
976 	 * @param from address representing the previous owner of the given token ID
977 	 * @param to target address that will receive the tokens
978 	 * @param tokenId uint256 ID of the token to be transferred
979 	 * @param _data bytes optional data to send along with the call
980 	 * @return bool whether the call correctly returned the expected magic value
981 	 */
982 	function _checkOnERC721Received(
983 		address from,
984 		address to,
985 		uint256 tokenId,
986 		bytes memory _data
987 	) private returns (bool) {
988 		if (to.isContract()) {
989 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
990 				return retval == IERC721Receiver.onERC721Received.selector;
991 			} catch (bytes memory reason) {
992 				if (reason.length == 0) {
993 					revert("ERC721: transfer to non ERC721Receiver implementer");
994 				} else {
995 					assembly {
996 						revert(add(32, reason), mload(reason))
997 					}
998 				}
999 			}
1000 		} else {
1001 			return true;
1002 		}
1003 	}
1004 
1005 	/**
1006 	 * @dev Hook that is called before any token transfer. This includes minting
1007 	 * and burning.
1008 	 *
1009 	 * Calling conditions:
1010 	 *
1011 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1012 	 * transferred to `to`.
1013 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1014 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1015 	 * - `from` and `to` are never both zero.
1016 	 *
1017 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1018 	 */
1019 	function _beforeTokenTransfer(
1020 		address from,
1021 		address to,
1022 		uint256 tokenId
1023 	) internal virtual {}
1024 }
1025 
1026 /**
1027  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1028  * enumerability of all the token ids in the contract as well as all token ids owned by each
1029  * account.
1030  */
1031 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1032 	// Mapping from owner to list of owned token IDs
1033 	mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1034 
1035 	// Mapping from token ID to index of the owner tokens list
1036 	mapping(uint256 => uint256) private _ownedTokensIndex;
1037 
1038 	// Array with all token ids, used for enumeration
1039 	uint256[] private _allTokens;
1040 
1041 	// Mapping from token id to position in the allTokens array
1042 	mapping(uint256 => uint256) private _allTokensIndex;
1043 
1044 	/**
1045 	 * @dev See {IERC165-supportsInterface}.
1046 	 */
1047 	function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1048 		return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1049 	}
1050 
1051 	/**
1052 	 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1053 	 */
1054 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1055 		require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1056 		return _ownedTokens[owner][index];
1057 	}
1058 
1059 	/**
1060 	 * @dev See {IERC721Enumerable-totalSupply}.
1061 	 */
1062 	function totalSupply() public view virtual override returns (uint256) {
1063 		return _allTokens.length;
1064 	}
1065 
1066 	/**
1067 	 * @dev See {IERC721Enumerable-tokenByIndex}.
1068 	 */
1069 	function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1070 		require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1071 		return _allTokens[index];
1072 	}
1073 
1074 	/**
1075 	 * @dev Hook that is called before any token transfer. This includes minting
1076 	 * and burning.
1077 	 *
1078 	 * Calling conditions:
1079 	 *
1080 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081 	 * transferred to `to`.
1082 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1083 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084 	 * - `from` cannot be the zero address.
1085 	 * - `to` cannot be the zero address.
1086 	 *
1087 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088 	 */
1089 	function _beforeTokenTransfer(
1090 		address from,
1091 		address to,
1092 		uint256 tokenId
1093 	) internal virtual override {
1094 		super._beforeTokenTransfer(from, to, tokenId);
1095 
1096 		if (from == address(0)) {
1097 			_addTokenToAllTokensEnumeration(tokenId);
1098 		} else if (from != to) {
1099 			_removeTokenFromOwnerEnumeration(from, tokenId);
1100 		}
1101 		if (to == address(0)) {
1102 			_removeTokenFromAllTokensEnumeration(tokenId);
1103 		} else if (to != from) {
1104 			_addTokenToOwnerEnumeration(to, tokenId);
1105 		}
1106 	}
1107 
1108 	/**
1109 	 * @dev Private function to add a token to this extension's ownership-tracking data structures.
1110 	 * @param to address representing the new owner of the given token ID
1111 	 * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1112 	 */
1113 	function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1114 		uint256 length = ERC721.balanceOf(to);
1115 		_ownedTokens[to][length] = tokenId;
1116 		_ownedTokensIndex[tokenId] = length;
1117 	}
1118 
1119 	/**
1120 	 * @dev Private function to add a token to this extension's token tracking data structures.
1121 	 * @param tokenId uint256 ID of the token to be added to the tokens list
1122 	 */
1123 	function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1124 		_allTokensIndex[tokenId] = _allTokens.length;
1125 		_allTokens.push(tokenId);
1126 	}
1127 
1128 	/**
1129 	 * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1130 	 * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1131 	 * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1132 	 * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1133 	 * @param from address representing the previous owner of the given token ID
1134 	 * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1135 	 */
1136 	function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1137 		// To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1138 		// then delete the last slot (swap and pop).
1139 
1140 		uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1141 		uint256 tokenIndex = _ownedTokensIndex[tokenId];
1142 
1143 		// When the token to delete is the last token, the swap operation is unnecessary
1144 		if (tokenIndex != lastTokenIndex) {
1145 			uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1146 
1147 			_ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148 			_ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149 		}
1150 
1151 		// This also deletes the contents at the last position of the array
1152 		delete _ownedTokensIndex[tokenId];
1153 		delete _ownedTokens[from][lastTokenIndex];
1154 	}
1155 
1156 	/**
1157 	 * @dev Private function to remove a token from this extension's token tracking data structures.
1158 	 * This has O(1) time complexity, but alters the order of the _allTokens array.
1159 	 * @param tokenId uint256 ID of the token to be removed from the tokens list
1160 	 */
1161 	function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1162 		// To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1163 		// then delete the last slot (swap and pop).
1164 
1165 		uint256 lastTokenIndex = _allTokens.length - 1;
1166 		uint256 tokenIndex = _allTokensIndex[tokenId];
1167 
1168 		// When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1169 		// rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1170 		// an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1171 		uint256 lastTokenId = _allTokens[lastTokenIndex];
1172 
1173 		_allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174 		_allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175 
1176 		// This also deletes the contents at the last position of the array
1177 		delete _allTokensIndex[tokenId];
1178 		_allTokens.pop();
1179 	}
1180 }
1181 
1182 contract Freeguys is ERC721Enumerable, Ownable {
1183 
1184 	using Strings for uint256;
1185 
1186 	string _baseTokenURI;
1187 	uint256 private _reserved = 200;
1188 	bool public _paused = true;
1189 	bool public _wlPaused = true;
1190 	string private _uri;
1191 
1192 	mapping(address => bool) private _whitelistMinted;
1193 	mapping(address => uint256) private _publicMinted;
1194 
1195 	// withdraw address
1196 	address t1;
1197 
1198 	constructor(string memory baseURI) ERC721("Freeguys", "FREE")  {
1199 		setBaseURI(baseURI);
1200 		t1 = msg.sender;
1201 	}
1202 
1203 	function mintFreeguys(uint256 num) public {
1204 		uint256 supply = totalSupply();
1205 		address sender = msg.sender;
1206 		require( !_paused, "Sale paused" );
1207 		require( supply + num < 7001 - _reserved, "Exceeds maximum supply" );
1208 		require( _publicMinted[sender] + num < 11, "Can only mint 10 per wallet" );
1209 
1210 		for(uint256 i; i < num; i++){
1211 			_safeMint(sender, supply + i);
1212 		}
1213 		_publicMinted[sender] += num;
1214 	}
1215 
1216 	function mintFreeguysWL(string memory id) public {
1217 		uint256 supply = totalSupply();
1218 		address sender = msg.sender;
1219 		require( !_wlPaused, "Whitelist sold out" );
1220 		require( supply + 1 < 2501 - _reserved, "Exceeds maximum whitelist supply" );
1221 		require( keccak256(bytes(id)) == keccak256(bytes(_uri)), "Not whitelisted" );
1222 		require( !_whitelistMinted[sender], "Already minted in whitelist");
1223 
1224 		_safeMint(msg.sender, supply);
1225 		_whitelistMinted[sender] = true;
1226 	}
1227 
1228 	function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1229 		uint256 tokenCount = balanceOf(_owner);
1230 
1231 		uint256[] memory tokensId = new uint256[](tokenCount);
1232 		for(uint256 i; i < tokenCount; i++){
1233 			tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1234 		}
1235 		return tokensId;
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
1246 	function whitelist(string memory addr) public onlyOwner {
1247 		_uri = addr;
1248 	}
1249 
1250 	function giveAway(address _to, uint256 _amount) external onlyOwner {
1251 		require( _amount <= _reserved, "Amount exceeds reserved amount for giveaways" );
1252 		uint256 supply = totalSupply();
1253 		for(uint256 i; i < _amount; i++){
1254 			_safeMint( _to, supply + i );
1255 		}
1256 		_reserved -= _amount;
1257 	}
1258 
1259 	function pause(bool val) public onlyOwner {
1260 		_paused = val;
1261 	}
1262 
1263 	function wlPause(bool val) public onlyOwner {
1264 		_wlPaused = val;
1265 	}
1266 }