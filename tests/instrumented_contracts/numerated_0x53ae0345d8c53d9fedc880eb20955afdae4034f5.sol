1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9 	/**
10 	 * @dev Returns true if `account` is a contract.
11 	 *
12 	 * [IMPORTANT]
13 	 * ====
14 	 * It is unsafe to assume that an address for which this function returns
15 	 * false is an externally-owned account (EOA) and not a contract.
16 	 *
17 	 * Among others, `isContract` will return false for the following
18 	 * types of addresses:
19 	 *
20 	 *  - an externally-owned account
21 	 *  - a contract in construction
22 	 *  - an address where a contract will be created
23 	 *  - an address where a contract lived, but was destroyed
24 	 * ====
25 	 */
26 	function isContract(address account) internal view returns (bool) {
27 		// This method relies on extcodesize, which returns 0 for contracts in
28 		// construction, since the code is only stored at the end of the
29 		// constructor execution.
30 
31 		uint256 size;
32 		assembly {
33 			size := extcodesize(account)
34 		}
35 		return size > 0;
36 	}
37 
38 	/**
39 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40 	 * `recipient`, forwarding all available gas and reverting on errors.
41 	 *
42 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
44 	 * imposed by `transfer`, making them unable to receive funds via
45 	 * `transfer`. {sendValue} removes this limitation.
46 	 *
47 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48 	 *
49 	 * IMPORTANT: because control is transferred to `recipient`, care must be
50 	 * taken to not create reentrancy vulnerabilities. Consider using
51 	 * {ReentrancyGuard} or the
52 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53 	 */
54 	function sendValue(address payable recipient, uint256 amount) internal {
55 		require(address(this).balance >= amount, "Address: insufficient balance");
56 
57 		(bool success, ) = recipient.call{value: amount}("");
58 		require(success, "Address: unable to send value, recipient may have reverted");
59 	}
60 
61 	/**
62 	 * @dev Performs a Solidity function call using a low level `call`. A
63 	 * plain `call` is an unsafe replacement for a function call: use this
64 	 * function instead.
65 	 *
66 	 * If `target` reverts with a revert reason, it is bubbled up by this
67 	 * function (like regular Solidity function calls).
68 	 *
69 	 * Returns the raw returned data. To convert to the expected return value,
70 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71 	 *
72 	 * Requirements:
73 	 *
74 	 * - `target` must be a contract.
75 	 * - calling `target` with `data` must not revert.
76 	 *
77 	 * _Available since v3.1._
78 	 */
79 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80 		return functionCall(target, data, "Address: low-level call failed");
81 	}
82 
83 	/**
84 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85 	 * `errorMessage` as a fallback revert reason when `target` reverts.
86 	 *
87 	 * _Available since v3.1._
88 	 */
89 	function functionCall(
90 		address target,
91 		bytes memory data,
92 		string memory errorMessage
93 	) internal returns (bytes memory) {
94 		return functionCallWithValue(target, data, 0, errorMessage);
95 	}
96 
97 	/**
98 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99 	 * but also transferring `value` wei to `target`.
100 	 *
101 	 * Requirements:
102 	 *
103 	 * - the calling contract must have an ETH balance of at least `value`.
104 	 * - the called Solidity function must be `payable`.
105 	 *
106 	 * _Available since v3.1._
107 	 */
108 	function functionCallWithValue(
109 		address target,
110 		bytes memory data,
111 		uint256 value
112 	) internal returns (bytes memory) {
113 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114 	}
115 
116 	/**
117 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
119 	 *
120 	 * _Available since v3.1._
121 	 */
122 	function functionCallWithValue(
123 		address target,
124 		bytes memory data,
125 		uint256 value,
126 		string memory errorMessage
127 	) internal returns (bytes memory) {
128 		require(address(this).balance >= value, "Address: insufficient balance for call");
129 		require(isContract(target), "Address: call to non-contract");
130 
131 		(bool success, bytes memory returndata) = target.call{value: value}(data);
132 		return verifyCallResult(success, returndata, errorMessage);
133 	}
134 
135 	/**
136 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137 	 * but performing a static call.
138 	 *
139 	 * _Available since v3.3._
140 	 */
141 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
142 		return functionStaticCall(target, data, "Address: low-level static call failed");
143 	}
144 
145 	/**
146 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
147 	 * but performing a static call.
148 	 *
149 	 * _Available since v3.3._
150 	 */
151 	function functionStaticCall(
152 		address target,
153 		bytes memory data,
154 		string memory errorMessage
155 	) internal view returns (bytes memory) {
156 		require(isContract(target), "Address: static call to non-contract");
157 
158 		(bool success, bytes memory returndata) = target.staticcall(data);
159 		return verifyCallResult(success, returndata, errorMessage);
160 	}
161 
162 	/**
163 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164 	 * but performing a delegate call.
165 	 *
166 	 * _Available since v3.4._
167 	 */
168 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
169 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
170 	}
171 
172 	/**
173 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
174 	 * but performing a delegate call.
175 	 *
176 	 * _Available since v3.4._
177 	 */
178 	function functionDelegateCall(
179 		address target,
180 		bytes memory data,
181 		string memory errorMessage
182 	) internal returns (bytes memory) {
183 		require(isContract(target), "Address: delegate call to non-contract");
184 
185 		(bool success, bytes memory returndata) = target.delegatecall(data);
186 		return verifyCallResult(success, returndata, errorMessage);
187 	}
188 
189 	/**
190 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
191 	 * revert reason using the provided one.
192 	 *
193 	 * _Available since v4.3._
194 	 */
195 	function verifyCallResult(
196 		bool success,
197 		bytes memory returndata,
198 		string memory errorMessage
199 	) internal pure returns (bytes memory) {
200 		if (success) {
201 			return returndata;
202 		} else {
203 			// Look for revert reason and bubble it up if present
204 			if (returndata.length > 0) {
205 				// The easiest way to bubble the revert reason is using memory via assembly
206 
207 				assembly {
208 					let returndata_size := mload(returndata)
209 					revert(add(32, returndata), returndata_size)
210 				}
211 			} else {
212 				revert(errorMessage);
213 			}
214 		}
215 	}
216 }
217 
218 /**
219  * @dev String operations.
220  */
221 library Strings {
222 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
223 
224 	/**
225 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
226 	 */
227 	function toString(uint256 value) internal pure returns (string memory) {
228 		// Inspired by OraclizeAPI's implementation - MIT licence
229 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
230 
231 		if (value == 0) {
232 			return "0";
233 		}
234 		uint256 temp = value;
235 		uint256 digits;
236 		while (temp != 0) {
237 			digits++;
238 			temp /= 10;
239 		}
240 		bytes memory buffer = new bytes(digits);
241 		while (value != 0) {
242 			digits -= 1;
243 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
244 			value /= 10;
245 		}
246 		return string(buffer);
247 	}
248 
249 	/**
250 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
251 	 */
252 	function toHexString(uint256 value) internal pure returns (string memory) {
253 		if (value == 0) {
254 			return "0x00";
255 		}
256 		uint256 temp = value;
257 		uint256 length = 0;
258 		while (temp != 0) {
259 			length++;
260 			temp >>= 8;
261 		}
262 		return toHexString(value, length);
263 	}
264 
265 	/**
266 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
267 	 */
268 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
269 		bytes memory buffer = new bytes(2 * length + 2);
270 		buffer[0] = "0";
271 		buffer[1] = "x";
272 		for (uint256 i = 2 * length + 1; i > 1; --i) {
273 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
274 			value >>= 4;
275 		}
276 		require(value == 0, "Strings: hex length insufficient");
277 		return string(buffer);
278 	}
279 }
280 
281 /**
282  * @dev Provides information about the current execution context, including the
283  * sender of the transaction and its data. While these are generally available
284  * via msg.sender and msg.data, they should not be accessed in such a direct
285  * manner, since when dealing with meta-transactions the account sending and
286  * paying for execution may not be the actual sender (as far as an application
287  * is concerned).
288  *
289  * This contract is only required for intermediate, library-like contracts.
290  */
291 abstract contract Context {
292 	function _msgSender() internal view virtual returns (address) {
293 		return msg.sender;
294 	}
295 
296 	function _msgData() internal view virtual returns (bytes calldata) {
297 		return msg.data;
298 	}
299 }
300 
301 /**
302  * @dev Contract module which provides a basic access control mechanism, where
303  * there is an account (an owner) that can be granted exclusive access to
304  * specific functions.
305  *
306  * By default, the owner account will be the one that deploys the contract. This
307  * can later be changed with {transferOwnership}.
308  *
309  * This module is used through inheritance. It will make available the modifier
310  * `onlyOwner`, which can be applied to your functions to restrict their use to
311  * the owner.
312  */
313 abstract contract Ownable is Context {
314 	address private _owner;
315 
316 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
317 
318 	/**
319 	 * @dev Initializes the contract setting the deployer as the initial owner.
320 	 */
321 	constructor() {
322 		_setOwner(_msgSender());
323 	}
324 
325 	/**
326 	 * @dev Returns the address of the current owner.
327 	 */
328 	function owner() public view virtual returns (address) {
329 		return _owner;
330 	}
331 
332 	/**
333 	 * @dev Throws if called by any account other than the owner.
334 	 */
335 	modifier onlyOwner() {
336 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
337 		_;
338 	}
339 
340 	/**
341 	 * @dev Leaves the contract without owner. It will not be possible to call
342 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
343 	 *
344 	 * NOTE: Renouncing ownership will leave the contract without an owner,
345 	 * thereby removing any functionality that is only available to the owner.
346 	 */
347 	function renounceOwnership() public virtual onlyOwner {
348 		_setOwner(address(0));
349 	}
350 
351 	/**
352 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
353 	 * Can only be called by the current owner.
354 	 */
355 	function transferOwnership(address newOwner) public virtual onlyOwner {
356 		require(newOwner != address(0), "Ownable: new owner is the zero address");
357 		_setOwner(newOwner);
358 	}
359 
360 	function _setOwner(address newOwner) private {
361 		address oldOwner = _owner;
362 		_owner = newOwner;
363 		emit OwnershipTransferred(oldOwner, newOwner);
364 	}
365 }
366 
367 /**
368  * @dev Contract module that helps prevent reentrant calls to a function.
369  *
370  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
371  * available, which can be applied to functions to make sure there are no nested
372  * (reentrant) calls to them.
373  *
374  * Note that because there is a single `nonReentrant` guard, functions marked as
375  * `nonReentrant` may not call one another. This can be worked around by making
376  * those functions `private`, and then adding `external` `nonReentrant` entry
377  * points to them.
378  *
379  * TIP: If you would like to learn more about reentrancy and alternative ways
380  * to protect against it, check out our blog post
381  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
382  */
383 abstract contract ReentrancyGuard {
384 	// Booleans are more expensive than uint256 or any type that takes up a full
385 	// word because each write operation emits an extra SLOAD to first read the
386 	// slot's contents, replace the bits taken up by the boolean, and then write
387 	// back. This is the compiler's defense against contract upgrades and
388 	// pointer aliasing, and it cannot be disabled.
389 
390 	// The values being non-zero value makes deployment a bit more expensive,
391 	// but in exchange the refund on every call to nonReentrant will be lower in
392 	// amount. Since refunds are capped to a percentage of the total
393 	// transaction's gas, it is best to keep them low in cases like this one, to
394 	// increase the likelihood of the full refund coming into effect.
395 	uint256 private constant _NOT_ENTERED = 1;
396 	uint256 private constant _ENTERED = 2;
397 
398 	uint256 private _status;
399 
400 	constructor() {
401 		_status = _NOT_ENTERED;
402 	}
403 
404 	/**
405 	 * @dev Prevents a contract from calling itself, directly or indirectly.
406 	 * Calling a `nonReentrant` function from another `nonReentrant`
407 	 * function is not supported. It is possible to prevent this from happening
408 	 * by making the `nonReentrant` function external, and make it call a
409 	 * `private` function that does the actual work.
410 	 */
411 	modifier nonReentrant() {
412 		// On the first call to nonReentrant, _notEntered will be true
413 		require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
414 
415 		// Any calls to nonReentrant after this point will fail
416 		_status = _ENTERED;
417 
418 		_;
419 
420 		// By storing the original value once again, a refund is triggered (see
421 		// https://eips.ethereum.org/EIPS/eip-2200)
422 		_status = _NOT_ENTERED;
423 	}
424 }
425 
426 /**
427  * @dev Interface of the ERC165 standard, as defined in the
428  * https://eips.ethereum.org/EIPS/eip-165[EIP].
429  *
430  * Implementers can declare support of contract interfaces, which can then be
431  * queried by others ({ERC165Checker}).
432  *
433  * For an implementation, see {ERC165}.
434  */
435 interface IERC165 {
436 	/**
437 	 * @dev Returns true if this contract implements the interface defined by
438 	 * `interfaceId`. See the corresponding
439 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
440 	 * to learn more about how these ids are created.
441 	 *
442 	 * This function call must use less than 30 000 gas.
443 	 */
444 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
445 }
446 
447 /**
448  * @dev Required interface of an ERC721 compliant contract.
449  */
450 interface IERC721 is IERC165 {
451 	/**
452 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453 	 */
454 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456 	/**
457 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458 	 */
459 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461 	/**
462 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
463 	 */
464 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
465 
466 	/**
467 	 * @dev Returns the number of tokens in ``owner``'s account.
468 	 */
469 	function balanceOf(address owner) external view returns (uint256 balance);
470 
471 	/**
472 	 * @dev Returns the owner of the `tokenId` token.
473 	 *
474 	 * Requirements:
475 	 *
476 	 * - `tokenId` must exist.
477 	 */
478 	function ownerOf(uint256 tokenId) external view returns (address owner);
479 
480 	/**
481 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
482 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
483 	 *
484 	 * Requirements:
485 	 *
486 	 * - `from` cannot be the zero address.
487 	 * - `to` cannot be the zero address.
488 	 * - `tokenId` token must exist and be owned by `from`.
489 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
490 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491 	 *
492 	 * Emits a {Transfer} event.
493 	 */
494 	function safeTransferFrom(
495 		address from,
496 		address to,
497 		uint256 tokenId
498 	) external;
499 
500 	/**
501 	 * @dev Transfers `tokenId` token from `from` to `to`.
502 	 *
503 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
504 	 *
505 	 * Requirements:
506 	 *
507 	 * - `from` cannot be the zero address.
508 	 * - `to` cannot be the zero address.
509 	 * - `tokenId` token must be owned by `from`.
510 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511 	 *
512 	 * Emits a {Transfer} event.
513 	 */
514 	function transferFrom(
515 		address from,
516 		address to,
517 		uint256 tokenId
518 	) external;
519 
520 	/**
521 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
522 	 * The approval is cleared when the token is transferred.
523 	 *
524 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
525 	 *
526 	 * Requirements:
527 	 *
528 	 * - The caller must own the token or be an approved operator.
529 	 * - `tokenId` must exist.
530 	 *
531 	 * Emits an {Approval} event.
532 	 */
533 	function approve(address to, uint256 tokenId) external;
534 
535 	/**
536 	 * @dev Returns the account approved for `tokenId` token.
537 	 *
538 	 * Requirements:
539 	 *
540 	 * - `tokenId` must exist.
541 	 */
542 	function getApproved(uint256 tokenId) external view returns (address operator);
543 
544 	/**
545 	 * @dev Approve or remove `operator` as an operator for the caller.
546 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547 	 *
548 	 * Requirements:
549 	 *
550 	 * - The `operator` cannot be the caller.
551 	 *
552 	 * Emits an {ApprovalForAll} event.
553 	 */
554 	function setApprovalForAll(address operator, bool _approved) external;
555 
556 	/**
557 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558 	 *
559 	 * See {setApprovalForAll}
560 	 */
561 	function isApprovedForAll(address owner, address operator) external view returns (bool);
562 
563 	/**
564 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
565 	 *
566 	 * Requirements:
567 	 *
568 	 * - `from` cannot be the zero address.
569 	 * - `to` cannot be the zero address.
570 	 * - `tokenId` token must exist and be owned by `from`.
571 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573 	 *
574 	 * Emits a {Transfer} event.
575 	 */
576 	function safeTransferFrom(
577 		address from,
578 		address to,
579 		uint256 tokenId,
580 		bytes calldata data
581 	) external;
582 }
583 
584 /**
585  * @title ERC721 token receiver interface
586  * @dev Interface for any contract that wants to support safeTransfers
587  * from ERC721 asset contracts.
588  */
589 interface IERC721Receiver {
590 	/**
591 	 * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
592 	 * by `operator` from `from`, this function is called.
593 	 *
594 	 * It must return its Solidity selector to confirm the token transfer.
595 	 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
596 	 *
597 	 * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
598 	 */
599 	function onERC721Received(
600 		address operator,
601 		address from,
602 		uint256 tokenId,
603 		bytes calldata data
604 	) external returns (bytes4);
605 }
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612 	/**
613 	 * @dev Returns the token collection name.
614 	 */
615 	function name() external view returns (string memory);
616 
617 	/**
618 	 * @dev Returns the token collection symbol.
619 	 */
620 	function symbol() external view returns (string memory);
621 
622 	/**
623 	 * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624 	 */
625 	function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 /**
629  * @dev Implementation of the {IERC165} interface.
630  *
631  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
632  * for the additional interface id that will be supported. For example:
633  *
634  * ```solidity
635  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
637  * }
638  * ```
639  *
640  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
641  */
642 abstract contract ERC165 is IERC165 {
643 	/**
644 	 * @dev See {IERC165-supportsInterface}.
645 	 */
646 	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647 		return interfaceId == type(IERC165).interfaceId;
648 	}
649 }
650 
651 /**
652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
653  * the Metadata extension, but not including the Enumerable extension, which is available separately as
654  * {ERC721Enumerable}.
655  */
656 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
657 	using Address for address;
658 	using Strings for uint256;
659 
660 	// Token name
661 	string private _name;
662 
663 	// Token symbol
664 	string private _symbol;
665 
666 	// Mapping from token ID to owner address
667 	mapping(uint256 => address) private _owners;
668 
669 	// Mapping owner address to token count
670 	mapping(address => uint256) private _balances;
671 
672 	// Mapping from token ID to approved address
673 	mapping(uint256 => address) private _tokenApprovals;
674 
675 	// Mapping from owner to operator approvals
676 	mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678 	/**
679 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
680 	 */
681 	constructor(string memory name_, string memory symbol_) {
682 		_name = name_;
683 		_symbol = symbol_;
684 	}
685 
686 	/**
687 	 * @dev See {IERC165-supportsInterface}.
688 	 */
689 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
690 		return
691 		interfaceId == type(IERC721).interfaceId ||
692 		interfaceId == type(IERC721Metadata).interfaceId ||
693 		super.supportsInterface(interfaceId);
694 	}
695 
696 	/**
697 	 * @dev See {IERC721-balanceOf}.
698 	 */
699 	function balanceOf(address owner) public view virtual override returns (uint256) {
700 		require(owner != address(0), "ERC721: balance query for the zero address");
701 		return _balances[owner];
702 	}
703 
704 	/**
705 	 * @dev See {IERC721-ownerOf}.
706 	 */
707 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
708 		address owner = _owners[tokenId];
709 		require(owner != address(0), "ERC721: owner query for nonexistent token");
710 		return owner;
711 	}
712 
713 	/**
714 	 * @dev See {IERC721Metadata-name}.
715 	 */
716 	function name() public view virtual override returns (string memory) {
717 		return _name;
718 	}
719 
720 	/**
721 	 * @dev See {IERC721Metadata-symbol}.
722 	 */
723 	function symbol() public view virtual override returns (string memory) {
724 		return _symbol;
725 	}
726 
727 	/**
728 	 * @dev See {IERC721Metadata-tokenURI}.
729 	 */
730 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
731 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
732 
733 		string memory baseURI = _baseURI();
734 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
735 	}
736 
737 	/**
738 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740 	 * by default, can be overriden in child contracts.
741 	 */
742 	function _baseURI() internal view virtual returns (string memory) {
743 		return "";
744 	}
745 
746 	/**
747 	 * @dev See {IERC721-approve}.
748 	 */
749 	function approve(address to, uint256 tokenId) public virtual override {
750 		address owner = ERC721.ownerOf(tokenId);
751 		require(to != owner, "ERC721: approval to current owner");
752 
753 		require(
754 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755 			"ERC721: approve caller is not owner nor approved for all"
756 		);
757 
758 		_approve(to, tokenId);
759 	}
760 
761 	/**
762 	 * @dev See {IERC721-getApproved}.
763 	 */
764 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
765 		require(_exists(tokenId), "ERC721: approved query for nonexistent token");
766 
767 		return _tokenApprovals[tokenId];
768 	}
769 
770 	/**
771 	 * @dev See {IERC721-setApprovalForAll}.
772 	 */
773 	function setApprovalForAll(address operator, bool approved) public virtual override {
774 		require(operator != _msgSender(), "ERC721: approve to caller");
775 
776 		_operatorApprovals[_msgSender()][operator] = approved;
777 		emit ApprovalForAll(_msgSender(), operator, approved);
778 	}
779 
780 	/**
781 	 * @dev See {IERC721-isApprovedForAll}.
782 	 */
783 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
784 		return _operatorApprovals[owner][operator];
785 	}
786 
787 	/**
788 	 * @dev See {IERC721-transferFrom}.
789 	 */
790 	function transferFrom(
791 		address from,
792 		address to,
793 		uint256 tokenId
794 	) public virtual override {
795 		//solhint-disable-next-line max-line-length
796 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797 
798 		_transfer(from, to, tokenId);
799 	}
800 
801 	/**
802 	 * @dev See {IERC721-safeTransferFrom}.
803 	 */
804 	function safeTransferFrom(
805 		address from,
806 		address to,
807 		uint256 tokenId
808 	) public virtual override {
809 		safeTransferFrom(from, to, tokenId, "");
810 	}
811 
812 	/**
813 	 * @dev See {IERC721-safeTransferFrom}.
814 	 */
815 	function safeTransferFrom(
816 		address from,
817 		address to,
818 		uint256 tokenId,
819 		bytes memory _data
820 	) public virtual override {
821 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
822 		_safeTransfer(from, to, tokenId, _data);
823 	}
824 
825 	/**
826 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828 	 *
829 	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
830 	 *
831 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
832 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
833 	 *
834 	 * Requirements:
835 	 *
836 	 * - `from` cannot be the zero address.
837 	 * - `to` cannot be the zero address.
838 	 * - `tokenId` token must exist and be owned by `from`.
839 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840 	 *
841 	 * Emits a {Transfer} event.
842 	 */
843 	function _safeTransfer(
844 		address from,
845 		address to,
846 		uint256 tokenId,
847 		bytes memory _data
848 	) internal virtual {
849 		_transfer(from, to, tokenId);
850 		require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
851 	}
852 
853 	/**
854 	 * @dev Returns whether `tokenId` exists.
855 	 *
856 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
857 	 *
858 	 * Tokens start existing when they are minted (`_mint`),
859 	 * and stop existing when they are burned (`_burn`).
860 	 */
861 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
862 		return _owners[tokenId] != address(0);
863 	}
864 
865 	/**
866 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
867 	 *
868 	 * Requirements:
869 	 *
870 	 * - `tokenId` must exist.
871 	 */
872 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
873 		require(_exists(tokenId), "ERC721: operator query for nonexistent token");
874 		address owner = ERC721.ownerOf(tokenId);
875 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
876 	}
877 
878 	/**
879 	 * @dev Safely mints `tokenId` and transfers it to `to`.
880 	 *
881 	 * Requirements:
882 	 *
883 	 * - `tokenId` must not exist.
884 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885 	 *
886 	 * Emits a {Transfer} event.
887 	 */
888 	function _safeMint(address to, uint256 tokenId) internal virtual {
889 		_safeMint(to, tokenId, "");
890 	}
891 
892 	/**
893 	 * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
894 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
895 	 */
896 	function _safeMint(
897 		address to,
898 		uint256 tokenId,
899 		bytes memory _data
900 	) internal virtual {
901 		_mint(to, tokenId);
902 		require(
903 			_checkOnERC721Received(address(0), to, tokenId, _data),
904 			"ERC721: transfer to non ERC721Receiver implementer"
905 		);
906 	}
907 
908 	/**
909 	 * @dev Mints `tokenId` and transfers it to `to`.
910 	 *
911 	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
912 	 *
913 	 * Requirements:
914 	 *
915 	 * - `tokenId` must not exist.
916 	 * - `to` cannot be the zero address.
917 	 *
918 	 * Emits a {Transfer} event.
919 	 */
920 	function _mint(address to, uint256 tokenId) internal virtual {
921 		require(to != address(0), "ERC721: mint to the zero address");
922 		require(!_exists(tokenId), "ERC721: token already minted");
923 
924 		_beforeTokenTransfer(address(0), to, tokenId);
925 
926 		_balances[to] += 1;
927 		_owners[tokenId] = to;
928 
929 		emit Transfer(address(0), to, tokenId);
930 	}
931 
932 	/**
933 	 * @dev Destroys `tokenId`.
934 	 * The approval is cleared when the token is burned.
935 	 *
936 	 * Requirements:
937 	 *
938 	 * - `tokenId` must exist.
939 	 *
940 	 * Emits a {Transfer} event.
941 	 */
942 	function _burn(uint256 tokenId) internal virtual {
943 		address owner = ERC721.ownerOf(tokenId);
944 
945 		_beforeTokenTransfer(owner, address(0), tokenId);
946 
947 		// Clear approvals
948 		_approve(address(0), tokenId);
949 
950 		_balances[owner] -= 1;
951 		delete _owners[tokenId];
952 
953 		emit Transfer(owner, address(0), tokenId);
954 	}
955 
956 	/**
957 	 * @dev Transfers `tokenId` from `from` to `to`.
958 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
959 	 *
960 	 * Requirements:
961 	 *
962 	 * - `to` cannot be the zero address.
963 	 * - `tokenId` token must be owned by `from`.
964 	 *
965 	 * Emits a {Transfer} event.
966 	 */
967 	function _transfer(
968 		address from,
969 		address to,
970 		uint256 tokenId
971 	) internal virtual {
972 		require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
973 		require(to != address(0), "ERC721: transfer to the zero address");
974 
975 		_beforeTokenTransfer(from, to, tokenId);
976 
977 		// Clear approvals from the previous owner
978 		_approve(address(0), tokenId);
979 
980 		_balances[from] -= 1;
981 		_balances[to] += 1;
982 		_owners[tokenId] = to;
983 
984 		emit Transfer(from, to, tokenId);
985 	}
986 
987 	/**
988 	 * @dev Approve `to` to operate on `tokenId`
989 	 *
990 	 * Emits a {Approval} event.
991 	 */
992 	function _approve(address to, uint256 tokenId) internal virtual {
993 		_tokenApprovals[tokenId] = to;
994 		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
995 	}
996 
997 	/**
998 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
999 	 * The call is not executed if the target address is not a contract.
1000 	 *
1001 	 * @param from address representing the previous owner of the given token ID
1002 	 * @param to target address that will receive the tokens
1003 	 * @param tokenId uint256 ID of the token to be transferred
1004 	 * @param _data bytes optional data to send along with the call
1005 	 * @return bool whether the call correctly returned the expected magic value
1006 	 */
1007 	function _checkOnERC721Received(
1008 		address from,
1009 		address to,
1010 		uint256 tokenId,
1011 		bytes memory _data
1012 	) private returns (bool) {
1013 		if (to.isContract()) {
1014 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1015 				return retval == IERC721Receiver.onERC721Received.selector;
1016 			} catch (bytes memory reason) {
1017 				if (reason.length == 0) {
1018 					revert("ERC721: transfer to non ERC721Receiver implementer");
1019 				} else {
1020 					assembly {
1021 						revert(add(32, reason), mload(reason))
1022 					}
1023 				}
1024 			}
1025 		} else {
1026 			return true;
1027 		}
1028 	}
1029 
1030 	/**
1031 	 * @dev Hook that is called before any token transfer. This includes minting
1032 	 * and burning.
1033 	 *
1034 	 * Calling conditions:
1035 	 *
1036 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037 	 * transferred to `to`.
1038 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1039 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040 	 * - `from` and `to` are never both zero.
1041 	 *
1042 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043 	 */
1044 	function _beforeTokenTransfer(
1045 		address from,
1046 		address to,
1047 		uint256 tokenId
1048 	) internal virtual {}
1049 }
1050 
1051 /**
1052  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1053  * @dev See https://eips.ethereum.org/EIPS/eip-721
1054  */
1055 interface IERC721Enumerable is IERC721 {
1056 	/**
1057 	 * @dev Returns the total amount of tokens stored by the contract.
1058 	 */
1059 	function totalSupply() external view returns (uint256);
1060 
1061 	/**
1062 	 * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1063 	 * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1064 	 */
1065 	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1066 
1067 	/**
1068 	 * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1069 	 * Use along with {totalSupply} to enumerate all tokens.
1070 	 */
1071 	function tokenByIndex(uint256 index) external view returns (uint256);
1072 }
1073 
1074 /**
1075  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1076  * enumerability of all the token ids in the contract as well as all token ids owned by each
1077  * account.
1078  */
1079 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1080 	// Mapping from owner to list of owned token IDs
1081 	mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1082 
1083 	// Mapping from token ID to index of the owner tokens list
1084 	mapping(uint256 => uint256) private _ownedTokensIndex;
1085 
1086 	// Array with all token ids, used for enumeration
1087 	uint256[] private _allTokens;
1088 
1089 	// Mapping from token id to position in the allTokens array
1090 	mapping(uint256 => uint256) private _allTokensIndex;
1091 
1092 	/**
1093 	 * @dev See {IERC165-supportsInterface}.
1094 	 */
1095 	function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1096 		return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1097 	}
1098 
1099 	/**
1100 	 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1101 	 */
1102 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1103 		require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1104 		return _ownedTokens[owner][index];
1105 	}
1106 
1107 	/**
1108 	 * @dev See {IERC721Enumerable-totalSupply}.
1109 	 */
1110 	function totalSupply() public view virtual override returns (uint256) {
1111 		return _allTokens.length;
1112 	}
1113 
1114 	/**
1115 	 * @dev See {IERC721Enumerable-tokenByIndex}.
1116 	 */
1117 	function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1118 		require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1119 		return _allTokens[index];
1120 	}
1121 
1122 	/**
1123 	 * @dev Hook that is called before any token transfer. This includes minting
1124 	 * and burning.
1125 	 *
1126 	 * Calling conditions:
1127 	 *
1128 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129 	 * transferred to `to`.
1130 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1131 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132 	 * - `from` cannot be the zero address.
1133 	 * - `to` cannot be the zero address.
1134 	 *
1135 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136 	 */
1137 	function _beforeTokenTransfer(
1138 		address from,
1139 		address to,
1140 		uint256 tokenId
1141 	) internal virtual override {
1142 		super._beforeTokenTransfer(from, to, tokenId);
1143 
1144 		if (from == address(0)) {
1145 			_addTokenToAllTokensEnumeration(tokenId);
1146 		} else if (from != to) {
1147 			_removeTokenFromOwnerEnumeration(from, tokenId);
1148 		}
1149 		if (to == address(0)) {
1150 			_removeTokenFromAllTokensEnumeration(tokenId);
1151 		} else if (to != from) {
1152 			_addTokenToOwnerEnumeration(to, tokenId);
1153 		}
1154 	}
1155 
1156 	/**
1157 	 * @dev Private function to add a token to this extension's ownership-tracking data structures.
1158 	 * @param to address representing the new owner of the given token ID
1159 	 * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1160 	 */
1161 	function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1162 		uint256 length = ERC721.balanceOf(to);
1163 		_ownedTokens[to][length] = tokenId;
1164 		_ownedTokensIndex[tokenId] = length;
1165 	}
1166 
1167 	/**
1168 	 * @dev Private function to add a token to this extension's token tracking data structures.
1169 	 * @param tokenId uint256 ID of the token to be added to the tokens list
1170 	 */
1171 	function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1172 		_allTokensIndex[tokenId] = _allTokens.length;
1173 		_allTokens.push(tokenId);
1174 	}
1175 
1176 	/**
1177 	 * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1178 	 * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1179 	 * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1180 	 * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1181 	 * @param from address representing the previous owner of the given token ID
1182 	 * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1183 	 */
1184 	function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1185 		// To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1186 		// then delete the last slot (swap and pop).
1187 
1188 		uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1189 		uint256 tokenIndex = _ownedTokensIndex[tokenId];
1190 
1191 		// When the token to delete is the last token, the swap operation is unnecessary
1192 		if (tokenIndex != lastTokenIndex) {
1193 			uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1194 
1195 			_ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1196 			_ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1197 		}
1198 
1199 		// This also deletes the contents at the last position of the array
1200 		delete _ownedTokensIndex[tokenId];
1201 		delete _ownedTokens[from][lastTokenIndex];
1202 	}
1203 
1204 	/**
1205 	 * @dev Private function to remove a token from this extension's token tracking data structures.
1206 	 * This has O(1) time complexity, but alters the order of the _allTokens array.
1207 	 * @param tokenId uint256 ID of the token to be removed from the tokens list
1208 	 */
1209 	function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1210 		// To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1211 		// then delete the last slot (swap and pop).
1212 
1213 		uint256 lastTokenIndex = _allTokens.length - 1;
1214 		uint256 tokenIndex = _allTokensIndex[tokenId];
1215 
1216 		// When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1217 		// rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1218 		// an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1219 		uint256 lastTokenId = _allTokens[lastTokenIndex];
1220 
1221 		_allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1222 		_allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1223 
1224 		// This also deletes the contents at the last position of the array
1225 		delete _allTokensIndex[tokenId];
1226 		_allTokens.pop();
1227 	}
1228 }
1229 
1230 contract DOGO is ERC721Enumerable, Ownable, ReentrancyGuard {
1231 
1232 	uint256 public constant DOGO_MAX_AMOUNT = 4500;
1233 	uint256 public DOGO_PER_TX = 15;
1234 	uint256 public PRICE = 0.077 ether;
1235 	address public founder = 0xB4B39dfB2ba6320F6a31C52D8bb790Eb19F457Fa;
1236 
1237 	uint256 public mintedPresaleCount;
1238 
1239 	mapping (uint256 => uint256) private _entityBirthdays;
1240 	mapping (address => uint256) private _availableClaims;
1241 	mapping (uint256 => string) private _ipfsHash;
1242 	string private _simpleIpfsHash;
1243 
1244 	bool private _isPublicSaleActive = false;
1245 	bool private _isPreSaleActive = false;
1246 	bool private _isSimpleIpfsHash = true;
1247 
1248 	string public tokenURIPrefix = "ipfs://";
1249 	string public tokenURISuffix = "/metadata.json";
1250 	string private _baseTokenURI;
1251 
1252 	event SendETH(address indexed to, uint256 amount);
1253 	event SetNewPercent(address indexed to, uint256 percent);
1254 	event SetNewValue(string nameValue, uint256 oldValue, uint256 newValue);
1255 
1256 	constructor (string memory name, string memory symbol, string memory baseTokenURI) ERC721(name, symbol) {
1257 		_baseTokenURI = baseTokenURI;
1258 	}
1259 
1260 	function mintPublic(uint256 amount) external payable nonReentrant() {
1261 		require(_isPublicSaleActive, "Public sale is not active");
1262 		require(amount <= DOGO_PER_TX, "You can't mint that many tokens");
1263 		require(totalSupply() + amount <= DOGO_MAX_AMOUNT, "Mint would exceed max supply of tokens");
1264 		require(msg.value == amount * PRICE, "You didn't send the right amount of eth");
1265 
1266 		_mintMultiple(msg.sender, amount);
1267 	}
1268 
1269 	function _mintMultiple(address owner, uint256 amount) private {
1270 		for (uint256 i = 0; i < amount; i++) {
1271 			uint256 tokenId = totalSupply();
1272 			_entityBirthdays[tokenId] = block.timestamp;
1273 			_safeMint(owner, tokenId);
1274 		}
1275 	}
1276 
1277 	function enableClaimFoundingMembers(address[] memory members, uint256[] memory amounts) external onlyOwner {
1278 		require(amounts.length == members.length, "miscellaneous number of elements");
1279 		for (uint256 i = 0; i < members.length; i++) {
1280 			require(members[i] != address(0), "member is the zero address");
1281 			require(amounts[i] <= DOGO_PER_TX, "amount is more than the allowable");
1282 			_availableClaims[members[i]] = amounts[i];
1283 		}
1284 	}
1285 
1286 	function setIpfsHash(string[] memory ipfsHashs, uint256[] memory idTokens) external onlyOwner {
1287 		require(ipfsHashs.length == idTokens.length, "miscellaneous number of elements");
1288 		if(_isSimpleIpfsHash) {
1289 			_simpleIpfsHash = ipfsHashs[0];
1290 			return;
1291 		}
1292 		for (uint256 i = 0; i < idTokens.length; i++) {
1293 			bytes memory tempHash = bytes(_ipfsHash[idTokens[i]]);
1294 			require(tempHash.length == 0, "IPFS hash can be set only once");
1295 			require(idTokens[i] <= DOGO_MAX_AMOUNT, "id is more than the allowable");
1296 			_ipfsHash[idTokens[i]] = ipfsHashs[i];
1297 		}
1298 	}
1299 
1300 	function isAvailableForClaim() public view returns (bool) {
1301 		return _availableClaims[msg.sender] > 0;
1302 	}
1303 
1304 	function mintPresaleMember() external payable nonReentrant() {
1305 		uint256 amount = _availableClaims[msg.sender];
1306 		makePresaleMemberMint(amount, msg.value);
1307 	}
1308 
1309 	function mintPresaleMemberWithAmount(uint256 amount) external payable nonReentrant() {
1310 		makePresaleMemberMint(amount, msg.value);
1311 	}
1312 
1313 	function makePresaleMemberMint(uint256 tokenAmount, uint256 etherAmount) private {
1314 		uint256 availableAmount = _availableClaims[msg.sender];
1315 		require(availableAmount >= tokenAmount, "Wrong amount");
1316 
1317 		require(_isPreSaleActive, "Pre-sale is not active");
1318 		require(isAvailableForClaim(), "You've not claimed your token");
1319 		require(totalSupply() + tokenAmount <= DOGO_MAX_AMOUNT, "Mint would exceed max supply of tokens");
1320 		require(mintedPresaleCount + tokenAmount <= DOGO_MAX_AMOUNT, "Mint would exceed max pre-sale tokens");
1321 		require(etherAmount == tokenAmount*PRICE, "You didn't send the right amount of eth");
1322 
1323 		mintedPresaleCount += tokenAmount;
1324 		_availableClaims[msg.sender] -= tokenAmount;
1325 		_mintMultiple(msg.sender, tokenAmount);
1326 	}
1327 
1328 	function setBaseTokenURI(string memory baseTokenURI) public onlyOwner {
1329 		_baseTokenURI = baseTokenURI;
1330 	}
1331 
1332 	function setEntityBirthdaysPrice(uint256 newPrice) public onlyOwner {
1333 		require(newPrice > 0, "Wrong price");
1334 		emit SetNewValue("PRICE", PRICE, newPrice);
1335 		PRICE = newPrice;
1336 	}
1337 
1338 	function setEntityBirthdaysPerTx(uint256 newPerTx) public onlyOwner {
1339 		require(newPerTx > 0, "Wrong per tx");
1340 		emit SetNewValue("DOGO_PER_TX", DOGO_PER_TX, newPerTx);
1341 		DOGO_PER_TX = newPerTx;
1342 	}
1343 
1344 	function claimETH() external {
1345 		require(owner() == _msgSender() || founder == _msgSender(), "You have no right to it");
1346 		sendETH(payable(founder), getContractBalance());
1347 	}
1348 
1349 	function sendETH(address payable to, uint256 amount) private nonReentrant() {
1350 		uint256 balance = getContractBalance();
1351 		amount = amount > balance ? balance : amount;
1352 		(bool sent, ) = to.call{value: amount}("");
1353 		require(sent, "Failed to send ETH");
1354 		emit SendETH(to, amount);
1355 	}
1356 
1357 	function getContractBalance() public view returns (uint256) {
1358 		return address(this).balance;
1359 	}
1360 
1361 	function tokensOfOwner(address user) external view returns (uint256[] memory ownerTokens) {
1362 		uint256 tokenCount = balanceOf(user);
1363 		if (tokenCount == 0) {
1364 			return new uint256[](0);
1365 		} else {
1366 			uint256[] memory output = new uint256[](tokenCount);
1367 			for (uint256 index = 0; index < tokenCount; index++) {
1368 				output[index] = tokenOfOwnerByIndex(user, index);
1369 			}
1370 			return output;
1371 		}
1372 	}
1373 
1374 	function getBirthday(uint256 tokenId) public view returns (uint256) {
1375 		require(tokenId < totalSupply(), "That entity has not been make yet");
1376 		return _entityBirthdays[tokenId];
1377 	}
1378 
1379 	function getIpfsTokenUri(uint256 tokenId) external view returns (string memory) {
1380 		require(tokenId < totalSupply(), "That entity has not been make yet");
1381 		require(getBirthday(tokenId) < block.timestamp, "That entity has not grown yet");
1382 		return string(abi.encodePacked(tokenURIPrefix, _ipfsHash[tokenId], tokenURISuffix));
1383 	}
1384 
1385 	function getIpfsHash(uint256 tokenId) external onlyOwner view returns (string memory) {
1386 		require(tokenId < totalSupply(), "That entity has not been make yet");
1387 		if(_isSimpleIpfsHash) {
1388 			return _simpleIpfsHash;
1389 		} else {
1390 			return _ipfsHash[tokenId];
1391 		}
1392 	}
1393 
1394 	function togglePublicSale() external onlyOwner {
1395 		_isPublicSaleActive = !_isPublicSaleActive;
1396 	}
1397 
1398 	function togglePreSale() external onlyOwner {
1399 		_isPreSaleActive = !_isPreSaleActive;
1400 	}
1401 
1402 	function isPublicSaleActive() external view returns (bool status) {
1403 		return _isPublicSaleActive;
1404 	}
1405 
1406 	function isPreSaleActive() external view returns (bool status) {
1407 		return _isPreSaleActive;
1408 	}
1409 
1410 	function _baseURI() internal view virtual override returns (string memory) {
1411 		return _baseTokenURI;
1412 	}
1413 
1414 	function _setTokenURIPrefix(string memory _tokenURIPrefix) external onlyOwner {
1415 		tokenURIPrefix = _tokenURIPrefix;
1416 	}
1417 
1418 	function _setTokenURISuffix(string memory _tokenURISuffix) external onlyOwner {
1419 		tokenURISuffix = _tokenURISuffix;
1420 	}
1421 }