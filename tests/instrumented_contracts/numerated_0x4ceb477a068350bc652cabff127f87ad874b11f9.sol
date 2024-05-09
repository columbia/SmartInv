1 // Dependency file: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
5 
6 // pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
30 
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
32 
33 // pragma solidity ^0.8.0;
34 
35 // import "@openzeppelin/contracts/utils/Context.sol";
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // Dependency file: @openzeppelin/contracts/security/ReentrancyGuard.sol
109 
110 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
111 
112 // pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Contract module that helps prevent reentrant calls to a function.
116  *
117  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
118  * available, which can be applied to functions to make sure there are no nested
119  * (reentrant) calls to them.
120  *
121  * Note that because there is a single `nonReentrant` guard, functions marked as
122  * `nonReentrant` may not call one another. This can be worked around by making
123  * those functions `private`, and then adding `external` `nonReentrant` entry
124  * points to them.
125  *
126  * TIP: If you would like to learn more about reentrancy and alternative ways
127  * to protect against it, check out our blog post
128  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
129  */
130 abstract contract ReentrancyGuard {
131     // Booleans are more expensive than uint256 or any type that takes up a full
132     // word because each write operation emits an extra SLOAD to first read the
133     // slot's contents, replace the bits taken up by the boolean, and then write
134     // back. This is the compiler's defense against contract upgrades and
135     // pointer aliasing, and it cannot be disabled.
136 
137     // The values being non-zero value makes deployment a bit more expensive,
138     // but in exchange the refund on every call to nonReentrant will be lower in
139     // amount. Since refunds are capped to a percentage of the total
140     // transaction's gas, it is best to keep them low in cases like this one, to
141     // increase the likelihood of the full refund coming into effect.
142     uint256 private constant _NOT_ENTERED = 1;
143     uint256 private constant _ENTERED = 2;
144 
145     uint256 private _status;
146 
147     constructor() {
148         _status = _NOT_ENTERED;
149     }
150 
151     /**
152      * @dev Prevents a contract from calling itself, directly or indirectly.
153      * Calling a `nonReentrant` function from another `nonReentrant`
154      * function is not supported. It is possible to prevent this from happening
155      * by making the `nonReentrant` function external, and making it call a
156      * `private` function that does the actual work.
157      */
158     modifier nonReentrant() {
159         // On the first call to nonReentrant, _notEntered will be true
160         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
161 
162         // Any calls to nonReentrant after this point will fail
163         _status = _ENTERED;
164 
165         _;
166 
167         // By storing the original value once again, a refund is triggered (see
168         // https://eips.ethereum.org/EIPS/eip-2200)
169         _status = _NOT_ENTERED;
170     }
171 }
172 
173 
174 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
175 
176 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
177 
178 // pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC20 standard as defined in the EIP.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `recipient`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transfer(address recipient, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
206      * zero by default.
207      *
208      * This value changes when {approve} or {transferFrom} are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * IMPORTANT: Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `sender` to `recipient` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transferFrom(
238         address sender,
239         address recipient,
240         uint256 amount
241     ) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 
259 // Dependency file: contracts/RecoverableErc20ByOwner.sol
260 
261 // pragma solidity ^0.8.0;
262 
263 // import "@openzeppelin/contracts/access/Ownable.sol";
264 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
265 
266 abstract contract RecoverableErc20ByOwner is Ownable {
267     function recoverErc20(address tokenAddress, uint256 amount, address to) external onlyOwner {
268         uint256 recoverableAmount = _getRecoverableAmount(tokenAddress);
269         require(amount <= recoverableAmount, "RecoverableByOwner: RECOVERABLE_AMOUNT_NOT_ENOUGH");
270         _sendErc20(tokenAddress, amount, to);
271     }
272 
273     function _getRecoverableAmount(address tokenAddress) private view returns (uint256) {
274         return IERC20(tokenAddress).balanceOf(address(this));
275     }
276 
277     function _sendErc20(address tokenAddress, uint256 amount, address to) private {
278         // bytes4(keccak256(bytes('transfer(address,uint256)')));
279         (bool success, bytes memory data) = tokenAddress.call(abi.encodeWithSelector(0xa9059cbb, to, amount));
280         require(success && (data.length == 0 || abi.decode(data, (bool))), "RecoverableByOwner: ERC20_TRANSFER_FAILED");
281     }
282 }
283 
284 
285 // Dependency file: @openzeppelin/contracts/utils/Address.sol
286 
287 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
288 
289 // pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // This method relies on extcodesize, which returns 0 for contracts in
314         // construction, since the code is only stored at the end of the
315         // constructor execution.
316 
317         uint256 size;
318         assembly {
319             size := extcodesize(account)
320         }
321         return size > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain `call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.call{value: value}(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
428         return functionStaticCall(target, data, "Address: low-level static call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
477      * revert reason using the provided one.
478      *
479      * _Available since v4.3._
480      */
481     function verifyCallResult(
482         bool success,
483         bytes memory returndata,
484         string memory errorMessage
485     ) internal pure returns (bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 
505 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
506 
507 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
508 
509 // pragma solidity ^0.8.0;
510 
511 /**
512  * @dev String operations.
513  */
514 library Strings {
515     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
519      */
520     function toString(uint256 value) internal pure returns (string memory) {
521         // Inspired by OraclizeAPI's implementation - MIT licence
522         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
523 
524         if (value == 0) {
525             return "0";
526         }
527         uint256 temp = value;
528         uint256 digits;
529         while (temp != 0) {
530             digits++;
531             temp /= 10;
532         }
533         bytes memory buffer = new bytes(digits);
534         while (value != 0) {
535             digits -= 1;
536             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
537             value /= 10;
538         }
539         return string(buffer);
540     }
541 
542     /**
543      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
544      */
545     function toHexString(uint256 value) internal pure returns (string memory) {
546         if (value == 0) {
547             return "0x00";
548         }
549         uint256 temp = value;
550         uint256 length = 0;
551         while (temp != 0) {
552             length++;
553             temp >>= 8;
554         }
555         return toHexString(value, length);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
560      */
561     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
562         bytes memory buffer = new bytes(2 * length + 2);
563         buffer[0] = "0";
564         buffer[1] = "x";
565         for (uint256 i = 2 * length + 1; i > 1; --i) {
566             buffer[i] = _HEX_SYMBOLS[value & 0xf];
567             value >>= 4;
568         }
569         require(value == 0, "Strings: hex length insufficient");
570         return string(buffer);
571     }
572 }
573 
574 
575 // Dependency file: @openzeppelin/contracts/utils/introspection/IERC165.sol
576 
577 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
578 
579 // pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Interface of the ERC165 standard, as defined in the
583  * https://eips.ethereum.org/EIPS/eip-165[EIP].
584  *
585  * Implementers can declare support of contract interfaces, which can then be
586  * queried by others ({ERC165Checker}).
587  *
588  * For an implementation, see {ERC165}.
589  */
590 interface IERC165 {
591     /**
592      * @dev Returns true if this contract implements the interface defined by
593      * `interfaceId`. See the corresponding
594      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
595      * to learn more about how these ids are created.
596      *
597      * This function call must use less than 30 000 gas.
598      */
599     function supportsInterface(bytes4 interfaceId) external view returns (bool);
600 }
601 
602 
603 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721.sol
604 
605 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
606 
607 // pragma solidity ^0.8.0;
608 
609 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
610 
611 /**
612  * @dev Required interface of an ERC721 compliant contract.
613  */
614 interface IERC721 is IERC165 {
615     /**
616      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
627      */
628     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
629 
630     /**
631      * @dev Returns the number of tokens in ``owner``'s account.
632      */
633     function balanceOf(address owner) external view returns (uint256 balance);
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) external view returns (address owner);
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId) external view returns (address operator);
707 
708     /**
709      * @dev Approve or remove `operator` as an operator for the caller.
710      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
711      *
712      * Requirements:
713      *
714      * - The `operator` cannot be the caller.
715      *
716      * Emits an {ApprovalForAll} event.
717      */
718     function setApprovalForAll(address operator, bool _approved) external;
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 
727     /**
728      * @dev Safely transfers `tokenId` token from `from` to `to`.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes calldata data
745     ) external;
746 }
747 
748 
749 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
750 
751 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
752 
753 // pragma solidity ^0.8.0;
754 
755 /**
756  * @title ERC721 token receiver interface
757  * @dev Interface for any contract that wants to support safeTransfers
758  * from ERC721 asset contracts.
759  */
760 interface IERC721Receiver {
761     /**
762      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
763      * by `operator` from `from`, this function is called.
764      *
765      * It must return its Solidity selector to confirm the token transfer.
766      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
767      *
768      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
769      */
770     function onERC721Received(
771         address operator,
772         address from,
773         uint256 tokenId,
774         bytes calldata data
775     ) external returns (bytes4);
776 }
777 
778 
779 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
780 
781 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
782 
783 // pragma solidity ^0.8.0;
784 
785 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
786 
787 /**
788  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
789  * @dev See https://eips.ethereum.org/EIPS/eip-721
790  */
791 interface IERC721Metadata is IERC721 {
792     /**
793      * @dev Returns the token collection name.
794      */
795     function name() external view returns (string memory);
796 
797     /**
798      * @dev Returns the token collection symbol.
799      */
800     function symbol() external view returns (string memory);
801 
802     /**
803      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
804      */
805     function tokenURI(uint256 tokenId) external view returns (string memory);
806 }
807 
808 
809 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
810 
811 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
812 
813 // pragma solidity ^0.8.0;
814 
815 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
816 
817 /**
818  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
819  * @dev See https://eips.ethereum.org/EIPS/eip-721
820  */
821 interface IERC721Enumerable is IERC721 {
822     /**
823      * @dev Returns the total amount of tokens stored by the contract.
824      */
825     function totalSupply() external view returns (uint256);
826 
827     /**
828      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
829      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
830      */
831     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
832 
833     /**
834      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
835      * Use along with {totalSupply} to enumerate all tokens.
836      */
837     function tokenByIndex(uint256 index) external view returns (uint256);
838 }
839 
840 
841 // Dependency file: contracts/ProxyRegistry.sol
842 
843 // pragma solidity ^0.8.0;
844 
845 contract OwnableDelegateProxy {}
846 
847 contract ProxyRegistry {
848     mapping(address => OwnableDelegateProxy) public proxies;
849 }
850 
851 
852 // Dependency file: contracts/interfaces/IRoboTraitsShort.sol
853 
854 // pragma solidity ^0.8.0;
855 
856 interface IRoboTraitsShort {
857     function contractURI() external view returns (string memory);
858     function tokenURI(uint256 tokenId) external view returns (string memory);
859 }
860 
861 
862 // Dependency file: contracts/RoborovskiErc721.sol
863 
864 // pragma solidity ^0.8.0;
865 
866 // import "@openzeppelin/contracts/utils/Address.sol";
867 // import "@openzeppelin/contracts/utils/Strings.sol";
868 // import "@openzeppelin/contracts/access/Ownable.sol";
869 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
870 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
871 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
872 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
873 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
874 // import "contracts/ProxyRegistry.sol";
875 // import "contracts/interfaces/IRoboTraitsShort.sol";
876 
877 abstract contract RoborovskiErc721 is
878     Ownable,
879     IERC165,
880     IERC721,
881     IERC721Metadata,
882     IERC721Enumerable
883 {
884     using Strings for uint256;
885     using Address for address;
886 
887     // Metadata
888     string private _name = "ROBOROVSKI";
889     string private _symbol = "ROBO";
890     string private _contractURI = "https://ipfs.io/ipfs/QmXHfdENe1vLPn2g6BP7KnvnhgXGMekst3YaP49hYjXbFY";
891     string private _baseURI = "";
892     string private _baseExtension = ".json";
893     bool private _revealed = false;
894     string private _notRevealedURI = "https://ipfs.io/ipfs/QmUCSUQPJuvLbm7ymJ3BFfAc9CYMqCbBX9hoMFQQvP3iTa";
895     mapping(uint256 => string) private _tokenURIs;
896 
897     // Balances
898     uint256 internal constant MAX_SUPPLY = 10000;
899     uint256 private _total;
900     address[MAX_SUPPLY + 1] private _owners;
901 
902     // Approvals
903     mapping(uint256 => address) private _tokenApprovals;
904     mapping(address => mapping(address => bool)) private _operatorApprovals;
905 
906     // Traits
907     address public TRAITS;
908 
909     // OpenSea
910     address private _proxyRegistry;
911 
912     constructor(address proxyRegistry_) {
913         _proxyRegistry = proxyRegistry_;
914     }
915 
916     function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
917         return
918             interfaceId == type(IERC721Enumerable).interfaceId ||
919             interfaceId == type(IERC721Metadata).interfaceId ||
920             interfaceId == type(IERC721).interfaceId ||
921             interfaceId == type(IERC165).interfaceId;
922     }
923 
924     function balanceOf(address owner) public view override returns (uint256) {
925         require(owner != address(0), "ERC721: balance query for the zero address");
926         uint256 count = 0;
927         uint256 length = _owners.length;
928         for (uint256 i = 0; i < length; ++i) {
929             if (owner == _owners[i]) {
930                 ++count;
931             }
932         }
933         delete length;
934         return count;
935     }
936 
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         address owner = _owners[tokenId];
939         require(owner != address(0), "ERC721: owner query for nonexistent token");
940         return owner;
941     }
942 
943     function rawOwnerOf(uint256 tokenId) public view returns (address) {
944         return _owners[tokenId];
945     }
946 
947     function name() public view override returns (string memory) {
948         return _name;
949     }
950 
951     function symbol() public view override returns (string memory) {
952         return _symbol;
953     }
954 
955     function contractURI() external view returns (string memory) {
956         if (TRAITS != address(0))
957             return IRoboTraitsShort(TRAITS).contractURI();
958         return _contractURI;
959     }
960 
961     function tokenURI(uint256 tokenId) external view override returns (string memory) {
962         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
963 
964         if (!_revealed)
965             return _notRevealedURI;
966 
967         if (TRAITS != address(0))
968             return IRoboTraitsShort(TRAITS).tokenURI(tokenId);
969 
970         string memory _tokenURI = _tokenURIs[tokenId];
971         if (bytes(_tokenURI).length > 0)
972             return _tokenURI;
973 
974         return string(abi.encodePacked(_baseURI, tokenId.toString(), _baseExtension));
975     }
976 
977     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
978         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
979         uint256 count;
980         for (uint256 i; i < _owners.length; ++i) {
981             if (owner == _owners[i]) {
982                 if (count == index)
983                     return i;
984                 else
985                     ++count;
986             }
987         }
988         require(false, "ERC721Enumerable: owner index out of bounds");
989     }
990 
991     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
992         require(0 < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
993         uint256 tokenCount = balanceOf(owner);
994         uint256[] memory tokenIds = new uint256[](tokenCount);
995         for (uint256 i = 0; i < tokenCount; i++) {
996             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
997         }
998         return tokenIds;
999     }
1000 
1001     function totalSupply() public view override returns (uint256) {
1002         return _total;
1003     }
1004 
1005     function tokenByIndex(uint256 index) public pure override returns (uint256) {
1006         return index;
1007     }
1008 
1009     function approve(address to, uint256 tokenId) public override {
1010         address owner = ownerOf(tokenId);
1011         require(to != owner, "ERC721: approval to current owner");
1012         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
1013         _approve(to, tokenId);
1014     }
1015 
1016     function getApproved(uint256 tokenId) public view override returns (address) {
1017         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1018         return _tokenApprovals[tokenId];
1019     }
1020 
1021     function setApprovalForAll(address operator, bool approved) public override {
1022         _setApprovalForAll(_msgSender(), operator, approved);
1023     }
1024 
1025     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1026         if (_proxyRegistry != address(0) && address(ProxyRegistry(_proxyRegistry).proxies(owner)) == operator)
1027             return true;
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     function transferFrom(address from, address to, uint256 tokenId) public override {
1032         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1033         _transfer(from, to, tokenId);
1034     }
1035 
1036     function safeTransferFrom(address from, address to, uint256 tokenId) public override {
1037         safeTransferFrom(from, to, tokenId, "");
1038     }
1039 
1040     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1041         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1042         _safeTransfer(from, to, tokenId, _data);
1043     }
1044 
1045     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
1046         _transfer(from, to, tokenId);
1047         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1048     }
1049 
1050     function _exists(uint256 tokenId) internal view returns (bool) {
1051         return _owners[tokenId] != address(0);
1052     }
1053 
1054     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1055         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1056         address owner = ownerOf(tokenId);
1057         return
1058             spender == owner ||
1059             getApproved(tokenId) == spender ||
1060             isApprovedForAll(owner, spender);
1061     }
1062 
1063     /*function _safeMint(address to, uint256 tokenId) internal {
1064         _safeMint(to, tokenId, "");
1065     }
1066 
1067     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
1068         _mint(to, tokenId);
1069         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1070     }*/
1071 
1072     function _mint(address to, uint256 tokenId) internal {
1073         require(to != address(0), "ERC721: mint to the zero address");
1074         require(!_exists(tokenId), "ERC721: token already minted");
1075         _owners[tokenId] = to;
1076         _total++;
1077         emit Transfer(address(0), to, tokenId);
1078     }
1079 
1080     function _burn(uint256 tokenId) internal {
1081         address owner = ownerOf(tokenId);
1082         _approve(address(0), tokenId);
1083         _owners[tokenId] = address(0);
1084         _total--;
1085 
1086         if (bytes(_tokenURIs[tokenId]).length != 0)
1087             delete _tokenURIs[tokenId];
1088 
1089         emit Transfer(owner, address(0), tokenId);
1090     }
1091 
1092     function _transfer(address from, address to, uint256 tokenId) internal {
1093         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1094         require(to != address(0), "ERC721: transfer to the zero address");
1095 
1096         _approve(address(0), tokenId);
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(from, to, tokenId);
1100     }
1101 
1102     function _approve(address to, uint256 tokenId) internal {
1103         _tokenApprovals[tokenId] = to;
1104         emit Approval(ownerOf(tokenId), to, tokenId);
1105     }
1106 
1107     function _setApprovalForAll(address owner, address operator, bool approved) internal {
1108         require(owner != operator, "ERC721: approve to caller");
1109         _operatorApprovals[owner][operator] = approved;
1110         emit ApprovalForAll(owner, operator, approved);
1111     }
1112 
1113     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     // Metadata
1132     function reveal() external onlyOwner {
1133         _revealed = true;
1134     }
1135 
1136     function setNotRevealedURI(string memory uri_) external onlyOwner {
1137         _notRevealedURI = uri_;
1138     }
1139 
1140     function setContractURI(string memory uri_) external onlyOwner {
1141         _contractURI = uri_;
1142     }
1143 
1144     function setBaseURI(string memory uri_) external onlyOwner {
1145         _baseURI = uri_;
1146     }
1147 
1148     function setBaseExtension(string memory fileExtension) external onlyOwner {
1149         _baseExtension = fileExtension;
1150     }
1151 
1152     function setTokenURIs(uint256[] memory ids, string[] memory uris) external onlyOwner {
1153         require(ids.length == uris.length, "ERC721URIStorage: parameters mismatch");
1154         for (uint256 i = 0; i < ids.length; i++) {
1155             _setTokenURI(ids[i], uris[i]);
1156         }
1157     }
1158 
1159     function _setTokenURI(uint256 tokenId, string memory _tokenURI) private {
1160         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1161         _tokenURIs[tokenId] = _tokenURI;
1162     }
1163 
1164     // Traits
1165     function setTraits(address traits_) external onlyOwner {
1166         TRAITS = traits_;
1167     }
1168 
1169     // OpenSea
1170     function unsetProxyRegistry() external onlyOwner {
1171         _proxyRegistry = address(0);
1172     }
1173 }
1174 
1175 
1176 // Dependency file: contracts/interfaces/IRnctShort.sol
1177 
1178 // pragma solidity ^0.8.0;
1179 
1180 interface IRnctShort {
1181     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1182     function burn(uint256 amount) external;
1183 }
1184 
1185 
1186 // Dependency file: contracts/RoborovskiName.sol
1187 
1188 // pragma solidity ^0.8.0;
1189 
1190 // import "@openzeppelin/contracts/utils/Context.sol";
1191 // import "contracts/RoborovskiErc721.sol";
1192 // import "contracts/interfaces/IRnctShort.sol";
1193 
1194 abstract contract RoborovskiName is Context, RoborovskiErc721 {
1195     uint256 public constant PRICE_CHANGE_NAME = 1830 ether;
1196     address public immutable RNCT;
1197 
1198     mapping(uint256 => string) private _tokenName;
1199     mapping(string => bool) private _nameReserved;
1200 
1201     event NameChange(uint256 indexed tokenId, string newName);
1202 
1203     constructor(address rnct_) {
1204         RNCT = rnct_;
1205     }
1206 
1207     function burn(uint256 tokenId) external {
1208         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1209         _burn(tokenId);
1210 
1211         // If already named, dereserve and remove name
1212         if (bytes(_tokenName[tokenId]).length != 0) {
1213             _toggleReserveName(_tokenName[tokenId], false);
1214             delete _tokenName[tokenId];
1215             emit NameChange(tokenId, "");
1216         }
1217     }
1218 
1219     function tokenName(uint256 tokenId) external view returns (string memory) {
1220         return _tokenName[tokenId];
1221     }
1222 
1223     function isNameReserved(string memory nameString) public view returns (bool) {
1224         return _nameReserved[toLower(nameString)];
1225     }
1226 
1227     function changeName(uint256 tokenId, string memory newName) external {
1228         address owner = ownerOf(tokenId);
1229         require(_msgSender() == owner, "ROBOROVSKI: caller is not the token owner");
1230         require(validateName(newName) == true, "ROBOROVSKI: not a valid new name");
1231         require(sha256(bytes(newName)) != sha256(bytes(_tokenName[tokenId])), "ROBOROVSKI: new name is same as the current one");
1232         require(isNameReserved(newName) == false, "ROBOROVSKI: name already reserved");
1233         require(IRnctShort(RNCT).transferFrom(_msgSender(), address(this), PRICE_CHANGE_NAME), "ROBOROVSKI: ERC20_TRANSFER_FAILED");
1234         IRnctShort(RNCT).burn(PRICE_CHANGE_NAME);
1235 
1236         // If already named, dereserve old name
1237         if (bytes(_tokenName[tokenId]).length > 0) {
1238             _toggleReserveName(_tokenName[tokenId], false);
1239         }
1240         _toggleReserveName(newName, true);
1241         _tokenName[tokenId] = newName;
1242         emit NameChange(tokenId, newName);
1243     }
1244 
1245     // Reserves the name if isReserve is set to true, de-reserves if set to false
1246     function _toggleReserveName(string memory str, bool isReserve) private {
1247         _nameReserved[toLower(str)] = isReserve;
1248     }
1249 
1250     // Check if the name string is valid (Alphanumeric and spaces without leading or trailing space)
1251     function validateName(string memory str) public pure returns (bool) {
1252         bytes memory b = bytes(str);
1253         if (b.length < 1)
1254             return false;
1255         // Cannot be longer than 25 characters
1256         if (b.length > 25)
1257             return false;
1258         // Leading space
1259         if (b[0] == 0x20)
1260             return false;
1261         // Trailing space
1262         if (b[b.length - 1] == 0x20)
1263             return false;
1264 
1265         bytes1 lastChar = b[0];
1266 
1267         for (uint256 i; i < b.length; i++) {
1268             bytes1 char = b[i];
1269             // Cannot contain continous spaces
1270             if (char == 0x20 && lastChar == 0x20)
1271                 return false;
1272             if (
1273                 !(char >= 0x30 && char <= 0x39) && //9-0
1274                 !(char >= 0x41 && char <= 0x5A) && //A-Z
1275                 !(char >= 0x61 && char <= 0x7A) && //a-z
1276                 !(char == 0x20) //space
1277             )
1278                 return false;
1279             lastChar = char;
1280         }
1281         return true;
1282     }
1283 
1284     // Converts the string to lowercase
1285     function toLower(string memory str) public pure returns (string memory) {
1286         bytes memory bStr = bytes(str);
1287         bytes memory bLower = new bytes(bStr.length);
1288         for (uint256 i = 0; i < bStr.length; i++) {
1289             // Uppercase character
1290             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90))
1291                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
1292             else
1293                 bLower[i] = bStr[i];
1294         }
1295         return string(bLower);
1296     }
1297 }
1298 
1299 
1300 // Dependency file: contracts/RoborovskiProvenance.sol
1301 
1302 // pragma solidity ^0.8.0;
1303 
1304 // import "@openzeppelin/contracts/access/Ownable.sol";
1305 
1306 abstract contract RoborovskiProvenance is Ownable {
1307     string public PROVENANCE = "";
1308 
1309     function setProvenance(string memory provenance_) external onlyOwner {
1310         require(bytes(PROVENANCE).length == 0, "ROBOROVSKI: provenance is already set");
1311         PROVENANCE = provenance_;
1312     }
1313 }
1314 
1315 
1316 // Dependency file: contracts/RoborovskiRandom.sol
1317 
1318 // pragma solidity ^0.8.0;
1319 
1320 // import "@openzeppelin/contracts/utils/Context.sol";
1321 // import "contracts/RoborovskiErc721.sol";
1322 
1323 abstract contract RoborovskiRandom is Context, RoborovskiErc721 {
1324     uint256[MAX_SUPPLY] internal _indices;
1325     uint256 private _randomNonce;
1326 
1327     function _internalMint(address account) internal returns (uint256 tokenId) {
1328         tokenId = _randomIndex();
1329         _mint(account, tokenId);
1330     }
1331 
1332     function _randomIndex() private returns (uint256) {
1333         uint256 totalSize = MAX_SUPPLY - totalSupply();
1334         uint256 index = uint256(
1335             keccak256(abi.encodePacked(_randomNonce++, _msgSender(), block.difficulty, block.timestamp))
1336         ) % totalSize;
1337 
1338         uint256 value = 0;
1339         if (_indices[index] != 0)
1340             value = _indices[index];
1341         else
1342             value = index;
1343 
1344         // Move last value to selected position
1345         if (_indices[totalSize - 1] == 0)
1346             // Array position not initialized, so use position
1347             _indices[index] = totalSize - 1;
1348         else
1349             // Array position holds a value so use that
1350             _indices[index] = _indices[totalSize - 1];
1351 
1352         return value + 1;
1353     }
1354 }
1355 
1356 
1357 // Dependency file: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1358 
1359 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
1360 
1361 // pragma solidity ^0.8.0;
1362 
1363 // import "@openzeppelin/contracts/utils/Strings.sol";
1364 
1365 /**
1366  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1367  *
1368  * These functions can be used to verify that a message was signed by the holder
1369  * of the private keys of a given address.
1370  */
1371 library ECDSA {
1372     enum RecoverError {
1373         NoError,
1374         InvalidSignature,
1375         InvalidSignatureLength,
1376         InvalidSignatureS,
1377         InvalidSignatureV
1378     }
1379 
1380     function _throwError(RecoverError error) private pure {
1381         if (error == RecoverError.NoError) {
1382             return; // no error: do nothing
1383         } else if (error == RecoverError.InvalidSignature) {
1384             revert("ECDSA: invalid signature");
1385         } else if (error == RecoverError.InvalidSignatureLength) {
1386             revert("ECDSA: invalid signature length");
1387         } else if (error == RecoverError.InvalidSignatureS) {
1388             revert("ECDSA: invalid signature 's' value");
1389         } else if (error == RecoverError.InvalidSignatureV) {
1390             revert("ECDSA: invalid signature 'v' value");
1391         }
1392     }
1393 
1394     /**
1395      * @dev Returns the address that signed a hashed message (`hash`) with
1396      * `signature` or error string. This address can then be used for verification purposes.
1397      *
1398      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1399      * this function rejects them by requiring the `s` value to be in the lower
1400      * half order, and the `v` value to be either 27 or 28.
1401      *
1402      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1403      * verification to be secure: it is possible to craft signatures that
1404      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1405      * this is by receiving a hash of the original message (which may otherwise
1406      * be too long), and then calling {toEthSignedMessageHash} on it.
1407      *
1408      * Documentation for signature generation:
1409      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1410      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1411      *
1412      * _Available since v4.3._
1413      */
1414     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1415         // Check the signature length
1416         // - case 65: r,s,v signature (standard)
1417         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1418         if (signature.length == 65) {
1419             bytes32 r;
1420             bytes32 s;
1421             uint8 v;
1422             // ecrecover takes the signature parameters, and the only way to get them
1423             // currently is to use assembly.
1424             assembly {
1425                 r := mload(add(signature, 0x20))
1426                 s := mload(add(signature, 0x40))
1427                 v := byte(0, mload(add(signature, 0x60)))
1428             }
1429             return tryRecover(hash, v, r, s);
1430         } else if (signature.length == 64) {
1431             bytes32 r;
1432             bytes32 vs;
1433             // ecrecover takes the signature parameters, and the only way to get them
1434             // currently is to use assembly.
1435             assembly {
1436                 r := mload(add(signature, 0x20))
1437                 vs := mload(add(signature, 0x40))
1438             }
1439             return tryRecover(hash, r, vs);
1440         } else {
1441             return (address(0), RecoverError.InvalidSignatureLength);
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the address that signed a hashed message (`hash`) with
1447      * `signature`. This address can then be used for verification purposes.
1448      *
1449      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1450      * this function rejects them by requiring the `s` value to be in the lower
1451      * half order, and the `v` value to be either 27 or 28.
1452      *
1453      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1454      * verification to be secure: it is possible to craft signatures that
1455      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1456      * this is by receiving a hash of the original message (which may otherwise
1457      * be too long), and then calling {toEthSignedMessageHash} on it.
1458      */
1459     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1460         (address recovered, RecoverError error) = tryRecover(hash, signature);
1461         _throwError(error);
1462         return recovered;
1463     }
1464 
1465     /**
1466      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1467      *
1468      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1469      *
1470      * _Available since v4.3._
1471      */
1472     function tryRecover(
1473         bytes32 hash,
1474         bytes32 r,
1475         bytes32 vs
1476     ) internal pure returns (address, RecoverError) {
1477         bytes32 s;
1478         uint8 v;
1479         assembly {
1480             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1481             v := add(shr(255, vs), 27)
1482         }
1483         return tryRecover(hash, v, r, s);
1484     }
1485 
1486     /**
1487      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1488      *
1489      * _Available since v4.2._
1490      */
1491     function recover(
1492         bytes32 hash,
1493         bytes32 r,
1494         bytes32 vs
1495     ) internal pure returns (address) {
1496         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1497         _throwError(error);
1498         return recovered;
1499     }
1500 
1501     /**
1502      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1503      * `r` and `s` signature fields separately.
1504      *
1505      * _Available since v4.3._
1506      */
1507     function tryRecover(
1508         bytes32 hash,
1509         uint8 v,
1510         bytes32 r,
1511         bytes32 s
1512     ) internal pure returns (address, RecoverError) {
1513         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1514         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1515         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1516         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1517         //
1518         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1519         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1520         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1521         // these malleable signatures as well.
1522         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1523             return (address(0), RecoverError.InvalidSignatureS);
1524         }
1525         if (v != 27 && v != 28) {
1526             return (address(0), RecoverError.InvalidSignatureV);
1527         }
1528 
1529         // If the signature is valid (and not malleable), return the signer address
1530         address signer = ecrecover(hash, v, r, s);
1531         if (signer == address(0)) {
1532             return (address(0), RecoverError.InvalidSignature);
1533         }
1534 
1535         return (signer, RecoverError.NoError);
1536     }
1537 
1538     /**
1539      * @dev Overload of {ECDSA-recover} that receives the `v`,
1540      * `r` and `s` signature fields separately.
1541      */
1542     function recover(
1543         bytes32 hash,
1544         uint8 v,
1545         bytes32 r,
1546         bytes32 s
1547     ) internal pure returns (address) {
1548         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1549         _throwError(error);
1550         return recovered;
1551     }
1552 
1553     /**
1554      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1555      * produces hash corresponding to the one signed with the
1556      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1557      * JSON-RPC method as part of EIP-191.
1558      *
1559      * See {recover}.
1560      */
1561     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1562         // 32 is the length in bytes of hash,
1563         // enforced by the type signature above
1564         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1565     }
1566 
1567     /**
1568      * @dev Returns an Ethereum Signed Message, created from `s`. This
1569      * produces hash corresponding to the one signed with the
1570      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1571      * JSON-RPC method as part of EIP-191.
1572      *
1573      * See {recover}.
1574      */
1575     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1576         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1577     }
1578 
1579     /**
1580      * @dev Returns an Ethereum Signed Typed Data, created from a
1581      * `domainSeparator` and a `structHash`. This produces hash corresponding
1582      * to the one signed with the
1583      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1584      * JSON-RPC method as part of EIP-712.
1585      *
1586      * See {recover}.
1587      */
1588     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1589         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1590     }
1591 }
1592 
1593 
1594 // Dependency file: contracts/RoborovskiSignature.sol
1595 
1596 // pragma solidity ^0.8.0;
1597 
1598 // import "@openzeppelin/contracts/access/Ownable.sol";
1599 // import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
1600 
1601 abstract contract RoborovskiSignature is Ownable {
1602     address private _signer;
1603     mapping(uint256 => bool) private _signatureUsed;
1604 
1605     constructor() {
1606         _signer = _msgSender();
1607     }
1608 
1609     function setSigner(address newSigner) external onlyOwner {
1610         _signer = newSigner;
1611     }
1612 
1613     function _checkSignature(address wallet, uint256 count, uint256 signId, bytes memory signature) internal {
1614         require(!_signatureUsed[signId] && _signatureWallet(wallet, count, signId, signature) == _signer, "ROBOROVSKI: not authorized to mint");
1615         _signatureUsed[signId] = true;
1616     }
1617 
1618     function _signatureWallet(address wallet, uint256 count, uint256 signId, bytes memory signature) private pure returns (address) {
1619         return ECDSA.recover( keccak256(abi.encode(wallet, count, signId)), signature);
1620     }
1621 }
1622 
1623 
1624 // Dependency file: contracts/RoborovskiTeam.sol
1625 
1626 // pragma solidity ^0.8.0;
1627 
1628 // import "@openzeppelin/contracts/access/Ownable.sol";
1629 
1630 abstract contract RoborovskiTeam is Ownable {
1631     address[] private _team = [
1632         0xA28F5fD46DC3C9b4399492fF81827983F2555600,
1633         0xBd0AD46710D75Fb936F01aA5DBEA6Eeb8845C1d0
1634     ];
1635 
1636     event Withdrawed(address indexed recipient, uint256 amount);
1637 
1638     function withdraw(uint256 amount) external onlyOwner {
1639         if (amount > address(this).balance)
1640             amount = address(this).balance;
1641         uint256 share = (amount * 50) / 100;
1642         _widthdraw(_team[0], share);
1643         _widthdraw(_team[1], amount - share);
1644     }
1645 
1646     function _widthdraw(address recipient, uint256 amount) private {
1647         (bool success, ) = recipient.call{value: amount}("");
1648         require(success, "ROBOROVSKI: ETH_TRANSFER_FAILED");
1649         emit Withdrawed(recipient, amount);
1650     }
1651 }
1652 
1653 
1654 // Root file: contracts/ROBOROVSKI.sol
1655 
1656 pragma solidity ^0.8.0;
1657 
1658 // import "@openzeppelin/contracts/access/Ownable.sol";
1659 // import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1660 // import "contracts/RecoverableErc20ByOwner.sol";
1661 // import "contracts/RoborovskiErc721.sol";
1662 // import "contracts/RoborovskiName.sol";
1663 // import "contracts/RoborovskiProvenance.sol";
1664 // import "contracts/RoborovskiRandom.sol";
1665 // import "contracts/RoborovskiSignature.sol";
1666 // import "contracts/RoborovskiTeam.sol";
1667 
1668 contract ROBOROVSKI is
1669     Ownable,
1670     ReentrancyGuard,
1671     RecoverableErc20ByOwner,
1672     RoborovskiErc721,
1673     RoborovskiName,
1674     RoborovskiProvenance,
1675     RoborovskiRandom,
1676     RoborovskiSignature,
1677     RoborovskiTeam
1678 {
1679     // Time
1680     uint256 private constant TIMESTAMP_PRESALE = 1645279170;
1681     uint256 private constant TIMESTAMP_RAFFLE = 1645322400;
1682     uint256 private constant TIMESTAMP_SALE = 1645344000;
1683 
1684     // Price
1685     uint256 private constant PRICE = 0.165 ether;
1686 
1687     // Mint
1688     uint256 private constant LIMIT = 1;
1689     uint256 private constant LIMIT_SALE = 2;
1690     mapping(uint256 => mapping(address => uint256)) public mintedOf;
1691     bool private _paused = false;
1692 
1693     // Bonus
1694     bool[MAX_SUPPLY + 1] public isMintedBeforeSale;
1695 
1696     constructor(address rnct_, address proxyRegistry_)
1697         RoborovskiErc721(proxyRegistry_)
1698         RoborovskiName(rnct_)
1699     {
1700         // For offline auction
1701         _indices[0] = MAX_SUPPLY - 1;
1702         _mint(0x5AF3F92c0725D54565014b5EA0d5f15A685d1a2a, 1);
1703         isMintedBeforeSale[1] = true;
1704         _indices[1] = MAX_SUPPLY - 2;
1705         _mint(0x5AF3F92c0725D54565014b5EA0d5f15A685d1a2a, 2);
1706         isMintedBeforeSale[2] = true;
1707     }
1708 
1709     function mintAirdrop(address[] memory accounts) external onlyOwner {
1710         for (uint256 i = 0; i < accounts.length; i++) {
1711             isMintedBeforeSale[_internalMint(accounts[i])] = true;
1712         }
1713     }
1714 
1715     function mintPresale(uint256 count, uint256 signId, bytes memory signature) external payable nonReentrant {
1716         require(block.timestamp >= TIMESTAMP_PRESALE && block.timestamp < TIMESTAMP_RAFFLE, "ROBOROVSKI: presale not open");
1717         _checkSignature(_msgSender(), count, signId, signature);
1718         _checkCount(0, _msgSender(), count, LIMIT, count * PRICE);
1719         for (uint256 i = 0; i < count; i++) {
1720             isMintedBeforeSale[_internalMint(_msgSender())] = true;
1721         }
1722     }
1723 
1724     function mintRaffle(uint256 count, uint256 signId, bytes memory signature) external payable nonReentrant {
1725         require(block.timestamp >= TIMESTAMP_RAFFLE && block.timestamp < TIMESTAMP_SALE, "ROBOROVSKI: raffle not open");
1726         _checkSignature(_msgSender(), count, signId, signature);
1727         _checkCount(1, _msgSender(), count, LIMIT, count * PRICE);
1728         for (uint256 i = 0; i < count; i++) {
1729             isMintedBeforeSale[_internalMint(_msgSender())] = true;
1730         }
1731     }
1732 
1733     function mint(uint256 count, uint256 signId, bytes memory signature) external payable nonReentrant {
1734         require(block.timestamp >= TIMESTAMP_SALE, "ROBOROVSKI: sale not open");
1735         _checkSignature(_msgSender(), count, signId, signature);
1736         _checkCount(2, _msgSender(), count, LIMIT_SALE, count * PRICE);
1737         for (uint256 i = 0; i < count; i++) {
1738             _internalMint(_msgSender());
1739         }
1740     }
1741 
1742     function _checkCount(uint256 stage, address wallet, uint256 count, uint256 limit, uint256 purchaseAmount) private {
1743         require(mintedOf[stage][wallet] + count <= limit, "ROBOROVSKI: address limit");
1744         require(msg.value >= purchaseAmount, "ROBOROVSKI: value below purchase amount");
1745         mintedOf[stage][wallet] += count;
1746     }
1747 
1748     function setPause(bool paused_) external onlyOwner {
1749         _paused = paused_;
1750     }
1751 }