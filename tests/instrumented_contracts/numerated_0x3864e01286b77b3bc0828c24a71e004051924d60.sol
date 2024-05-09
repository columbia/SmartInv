1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Interface of the ERC165 standard, as defined in the
119  * https://eips.ethereum.org/EIPS/eip-165[EIP].
120  *
121  * Implementers can declare support of contract interfaces, which can then be
122  * queried by others ({ERC165Checker}).
123  *
124  * For an implementation, see {ERC165}.
125  */
126 interface IERC165 {
127     /**
128      * @dev Returns true if this contract implements the interface defined by
129      * `interfaceId`. See the corresponding
130      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
131      * to learn more about how these ids are created.
132      *
133      * This function call must use less than 30 000 gas.
134      */
135     function supportsInterface(bytes4 interfaceId) external view returns (bool);
136 }
137 
138 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
139 
140 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Required interface of an ERC721 compliant contract.
146  */
147 interface IERC721 is IERC165 {
148     /**
149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
155      */
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
160      */
161     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
162 
163     /**
164      * @dev Returns the number of tokens in ``owner``'s account.
165      */
166     function balanceOf(address owner) external view returns (uint256 balance);
167 
168     /**
169      * @dev Returns the owner of the `tokenId` token.
170      *
171      * Requirements:
172      *
173      * - `tokenId` must exist.
174      */
175     function ownerOf(uint256 tokenId) external view returns (address owner);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external;
196 
197     /**
198      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
199      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must exist and be owned by `from`.
206      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Transfers `tokenId` token from `from` to `to`.
219      *
220      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
221      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
222      * understand this adds an external call which potentially creates a reentrancy vulnerability.
223      *
224      * Requirements:
225      *
226      * - `from` cannot be the zero address.
227      * - `to` cannot be the zero address.
228      * - `tokenId` token must be owned by `from`.
229      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external;
238 
239     /**
240      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
241      * The approval is cleared when the token is transferred.
242      *
243      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
244      *
245      * Requirements:
246      *
247      * - The caller must own the token or be an approved operator.
248      * - `tokenId` must exist.
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address to, uint256 tokenId) external;
253 
254     /**
255      * @dev Approve or remove `operator` as an operator for the caller.
256      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
257      *
258      * Requirements:
259      *
260      * - The `operator` cannot be the caller.
261      *
262      * Emits an {ApprovalForAll} event.
263      */
264     function setApprovalForAll(address operator, bool _approved) external;
265 
266     /**
267      * @dev Returns the account approved for `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function getApproved(uint256 tokenId) external view returns (address operator);
274 
275     /**
276      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
277      *
278      * See {setApprovalForAll}
279      */
280     function isApprovedForAll(address owner, address operator) external view returns (bool);
281 }
282 
283 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
284 
285 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
303      */
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
313 
314 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
320  * @dev See https://eips.ethereum.org/EIPS/eip-721
321  */
322 interface IERC721Metadata is IERC721 {
323     /**
324      * @dev Returns the token collection name.
325      */
326     function name() external view returns (string memory);
327 
328     /**
329      * @dev Returns the token collection symbol.
330      */
331     function symbol() external view returns (string memory);
332 
333     /**
334      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
335      */
336     function tokenURI(uint256 tokenId) external view returns (string memory);
337 }
338 
339 // File: @openzeppelin/contracts/utils/Address.sol
340 
341 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
342 
343 pragma solidity ^0.8.1;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      *
366      * [IMPORTANT]
367      * ====
368      * You shouldn't rely on `isContract` to protect against flash loan attacks!
369      *
370      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
371      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
372      * constructor.
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize/address.code.length, which returns 0
377         // for contracts in construction, since the code is only stored at the end
378         // of the constructor execution.
379 
380         return account.code.length > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         (bool success, ) = recipient.call{value: amount}("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain `call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but also transferring `value` wei to `target`.
445      *
446      * Requirements:
447      *
448      * - the calling contract must have an ETH balance of at least `value`.
449      * - the called Solidity function must be `payable`.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(address(this).balance >= value, "Address: insufficient balance for call");
474         (bool success, bytes memory returndata) = target.call{value: value}(data);
475         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
485         return functionStaticCall(target, data, "Address: low-level static call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a static call.
491      *
492      * _Available since v3.3._
493      */
494     function functionStaticCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal view returns (bytes memory) {
499         (bool success, bytes memory returndata) = target.staticcall(data);
500         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         (bool success, bytes memory returndata) = target.delegatecall(data);
525         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
530      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
531      *
532      * _Available since v4.8._
533      */
534     function verifyCallResultFromTarget(
535         address target,
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal view returns (bytes memory) {
540         if (success) {
541             if (returndata.length == 0) {
542                 // only check isContract if the call was successful and the return data is empty
543                 // otherwise we already know that it was a contract
544                 require(isContract(target), "Address: call to non-contract");
545             }
546             return returndata;
547         } else {
548             _revert(returndata, errorMessage);
549         }
550     }
551 
552     /**
553      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
554      * revert reason or using the provided one.
555      *
556      * _Available since v4.3._
557      */
558     function verifyCallResult(
559         bool success,
560         bytes memory returndata,
561         string memory errorMessage
562     ) internal pure returns (bytes memory) {
563         if (success) {
564             return returndata;
565         } else {
566             _revert(returndata, errorMessage);
567         }
568     }
569 
570     function _revert(bytes memory returndata, string memory errorMessage) private pure {
571         // Look for revert reason and bubble it up if present
572         if (returndata.length > 0) {
573             // The easiest way to bubble the revert reason is using memory via assembly
574             /// @solidity memory-safe-assembly
575             assembly {
576                 let returndata_size := mload(returndata)
577                 revert(add(32, returndata), returndata_size)
578             }
579         } else {
580             revert(errorMessage);
581         }
582     }
583 }
584 
585 // File: @openzeppelin/contracts/utils/math/Math.sol
586 
587 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Standard math utilities missing in the Solidity language.
593  */
594 library Math {
595     enum Rounding {
596         Down, // Toward negative infinity
597         Up, // Toward infinity
598         Zero // Toward zero
599     }
600 
601     /**
602      * @dev Returns the largest of two numbers.
603      */
604     function max(uint256 a, uint256 b) internal pure returns (uint256) {
605         return a > b ? a : b;
606     }
607 
608     /**
609      * @dev Returns the smallest of two numbers.
610      */
611     function min(uint256 a, uint256 b) internal pure returns (uint256) {
612         return a < b ? a : b;
613     }
614 
615     /**
616      * @dev Returns the average of two numbers. The result is rounded towards
617      * zero.
618      */
619     function average(uint256 a, uint256 b) internal pure returns (uint256) {
620         // (a + b) / 2 can overflow.
621         return (a & b) + (a ^ b) / 2;
622     }
623 
624     /**
625      * @dev Returns the ceiling of the division of two numbers.
626      *
627      * This differs from standard division with `/` in that it rounds up instead
628      * of rounding down.
629      */
630     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
631         // (a + b - 1) / b can overflow on addition, so we distribute.
632         return a == 0 ? 0 : (a - 1) / b + 1;
633     }
634 
635     /**
636      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
637      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
638      * with further edits by Uniswap Labs also under MIT license.
639      */
640     function mulDiv(
641         uint256 x,
642         uint256 y,
643         uint256 denominator
644     ) internal pure returns (uint256 result) {
645         unchecked {
646             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
647             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
648             // variables such that product = prod1 * 2^256 + prod0.
649             uint256 prod0; // Least significant 256 bits of the product
650             uint256 prod1; // Most significant 256 bits of the product
651             assembly {
652                 let mm := mulmod(x, y, not(0))
653                 prod0 := mul(x, y)
654                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
655             }
656 
657             // Handle non-overflow cases, 256 by 256 division.
658             if (prod1 == 0) {
659                 return prod0 / denominator;
660             }
661 
662             // Make sure the result is less than 2^256. Also prevents denominator == 0.
663             require(denominator > prod1);
664 
665             ///////////////////////////////////////////////
666             // 512 by 256 division.
667             ///////////////////////////////////////////////
668 
669             // Make division exact by subtracting the remainder from [prod1 prod0].
670             uint256 remainder;
671             assembly {
672                 // Compute remainder using mulmod.
673                 remainder := mulmod(x, y, denominator)
674 
675                 // Subtract 256 bit number from 512 bit number.
676                 prod1 := sub(prod1, gt(remainder, prod0))
677                 prod0 := sub(prod0, remainder)
678             }
679 
680             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
681             // See https://cs.stackexchange.com/q/138556/92363.
682 
683             // Does not overflow because the denominator cannot be zero at this stage in the function.
684             uint256 twos = denominator & (~denominator + 1);
685             assembly {
686                 // Divide denominator by twos.
687                 denominator := div(denominator, twos)
688 
689                 // Divide [prod1 prod0] by twos.
690                 prod0 := div(prod0, twos)
691 
692                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
693                 twos := add(div(sub(0, twos), twos), 1)
694             }
695 
696             // Shift in bits from prod1 into prod0.
697             prod0 |= prod1 * twos;
698 
699             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
700             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
701             // four bits. That is, denominator * inv = 1 mod 2^4.
702             uint256 inverse = (3 * denominator) ^ 2;
703 
704             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
705             // in modular arithmetic, doubling the correct bits in each step.
706             inverse *= 2 - denominator * inverse; // inverse mod 2^8
707             inverse *= 2 - denominator * inverse; // inverse mod 2^16
708             inverse *= 2 - denominator * inverse; // inverse mod 2^32
709             inverse *= 2 - denominator * inverse; // inverse mod 2^64
710             inverse *= 2 - denominator * inverse; // inverse mod 2^128
711             inverse *= 2 - denominator * inverse; // inverse mod 2^256
712 
713             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
714             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
715             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
716             // is no longer required.
717             result = prod0 * inverse;
718             return result;
719         }
720     }
721 
722     /**
723      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
724      */
725     function mulDiv(
726         uint256 x,
727         uint256 y,
728         uint256 denominator,
729         Rounding rounding
730     ) internal pure returns (uint256) {
731         uint256 result = mulDiv(x, y, denominator);
732         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
733             result += 1;
734         }
735         return result;
736     }
737 
738     /**
739      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
740      *
741      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
742      */
743     function sqrt(uint256 a) internal pure returns (uint256) {
744         if (a == 0) {
745             return 0;
746         }
747 
748         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
749         //
750         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
751         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
752         //
753         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
754         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
755         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
756         //
757         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
758         uint256 result = 1 << (log2(a) >> 1);
759 
760         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
761         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
762         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
763         // into the expected uint128 result.
764         unchecked {
765             result = (result + a / result) >> 1;
766             result = (result + a / result) >> 1;
767             result = (result + a / result) >> 1;
768             result = (result + a / result) >> 1;
769             result = (result + a / result) >> 1;
770             result = (result + a / result) >> 1;
771             result = (result + a / result) >> 1;
772             return min(result, a / result);
773         }
774     }
775 
776     /**
777      * @notice Calculates sqrt(a), following the selected rounding direction.
778      */
779     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
780         unchecked {
781             uint256 result = sqrt(a);
782             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
783         }
784     }
785 
786     /**
787      * @dev Return the log in base 2, rounded down, of a positive value.
788      * Returns 0 if given 0.
789      */
790     function log2(uint256 value) internal pure returns (uint256) {
791         uint256 result = 0;
792         unchecked {
793             if (value >> 128 > 0) {
794                 value >>= 128;
795                 result += 128;
796             }
797             if (value >> 64 > 0) {
798                 value >>= 64;
799                 result += 64;
800             }
801             if (value >> 32 > 0) {
802                 value >>= 32;
803                 result += 32;
804             }
805             if (value >> 16 > 0) {
806                 value >>= 16;
807                 result += 16;
808             }
809             if (value >> 8 > 0) {
810                 value >>= 8;
811                 result += 8;
812             }
813             if (value >> 4 > 0) {
814                 value >>= 4;
815                 result += 4;
816             }
817             if (value >> 2 > 0) {
818                 value >>= 2;
819                 result += 2;
820             }
821             if (value >> 1 > 0) {
822                 result += 1;
823             }
824         }
825         return result;
826     }
827 
828     /**
829      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
830      * Returns 0 if given 0.
831      */
832     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
833         unchecked {
834             uint256 result = log2(value);
835             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
836         }
837     }
838 
839     /**
840      * @dev Return the log in base 10, rounded down, of a positive value.
841      * Returns 0 if given 0.
842      */
843     function log10(uint256 value) internal pure returns (uint256) {
844         uint256 result = 0;
845         unchecked {
846             if (value >= 10**64) {
847                 value /= 10**64;
848                 result += 64;
849             }
850             if (value >= 10**32) {
851                 value /= 10**32;
852                 result += 32;
853             }
854             if (value >= 10**16) {
855                 value /= 10**16;
856                 result += 16;
857             }
858             if (value >= 10**8) {
859                 value /= 10**8;
860                 result += 8;
861             }
862             if (value >= 10**4) {
863                 value /= 10**4;
864                 result += 4;
865             }
866             if (value >= 10**2) {
867                 value /= 10**2;
868                 result += 2;
869             }
870             if (value >= 10**1) {
871                 result += 1;
872             }
873         }
874         return result;
875     }
876 
877     /**
878      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
879      * Returns 0 if given 0.
880      */
881     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
882         unchecked {
883             uint256 result = log10(value);
884             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
885         }
886     }
887 
888     /**
889      * @dev Return the log in base 256, rounded down, of a positive value.
890      * Returns 0 if given 0.
891      *
892      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
893      */
894     function log256(uint256 value) internal pure returns (uint256) {
895         uint256 result = 0;
896         unchecked {
897             if (value >> 128 > 0) {
898                 value >>= 128;
899                 result += 16;
900             }
901             if (value >> 64 > 0) {
902                 value >>= 64;
903                 result += 8;
904             }
905             if (value >> 32 > 0) {
906                 value >>= 32;
907                 result += 4;
908             }
909             if (value >> 16 > 0) {
910                 value >>= 16;
911                 result += 2;
912             }
913             if (value >> 8 > 0) {
914                 result += 1;
915             }
916         }
917         return result;
918     }
919 
920     /**
921      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
922      * Returns 0 if given 0.
923      */
924     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
925         unchecked {
926             uint256 result = log256(value);
927             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
928         }
929     }
930 }
931 
932 // File: @openzeppelin/contracts/utils/Strings.sol
933 
934 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev String operations.
940  */
941 library Strings {
942     bytes16 private constant _SYMBOLS = "0123456789abcdef";
943     uint8 private constant _ADDRESS_LENGTH = 20;
944 
945     /**
946      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
947      */
948     function toString(uint256 value) internal pure returns (string memory) {
949         unchecked {
950             uint256 length = Math.log10(value) + 1;
951             string memory buffer = new string(length);
952             uint256 ptr;
953             /// @solidity memory-safe-assembly
954             assembly {
955                 ptr := add(buffer, add(32, length))
956             }
957             while (true) {
958                 ptr--;
959                 /// @solidity memory-safe-assembly
960                 assembly {
961                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
962                 }
963                 value /= 10;
964                 if (value == 0) break;
965             }
966             return buffer;
967         }
968     }
969 
970     /**
971      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
972      */
973     function toHexString(uint256 value) internal pure returns (string memory) {
974         unchecked {
975             return toHexString(value, Math.log256(value) + 1);
976         }
977     }
978 
979     /**
980      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
981      */
982     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
983         bytes memory buffer = new bytes(2 * length + 2);
984         buffer[0] = "0";
985         buffer[1] = "x";
986         for (uint256 i = 2 * length + 1; i > 1; --i) {
987             buffer[i] = _SYMBOLS[value & 0xf];
988             value >>= 4;
989         }
990         require(value == 0, "Strings: hex length insufficient");
991         return string(buffer);
992     }
993 
994     /**
995      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
996      */
997     function toHexString(address addr) internal pure returns (string memory) {
998         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
999     }
1000 }
1001 
1002 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1003 
1004 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 /**
1009  * @dev Implementation of the {IERC165} interface.
1010  *
1011  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1012  * for the additional interface id that will be supported. For example:
1013  *
1014  * ```solidity
1015  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1016  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1017  * }
1018  * ```
1019  *
1020  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1021  */
1022 abstract contract ERC165 is IERC165 {
1023     /**
1024      * @dev See {IERC165-supportsInterface}.
1025      */
1026     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1027         return interfaceId == type(IERC165).interfaceId;
1028     }
1029 }
1030 
1031 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1032 
1033 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1034 
1035 pragma solidity ^0.8.0;
1036 
1037 
1038 
1039 
1040 
1041 
1042 
1043 /**
1044  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1045  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1046  * {ERC721Enumerable}.
1047  */
1048 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1049     using Address for address;
1050     using Strings for uint256;
1051 
1052     // Token name
1053     string private _name;
1054 
1055     // Token symbol
1056     string private _symbol;
1057 
1058     // Mapping from token ID to owner address
1059     mapping(uint256 => address) private _owners;
1060 
1061     // Mapping owner address to token count
1062     mapping(address => uint256) private _balances;
1063 
1064     // Mapping from token ID to approved address
1065     mapping(uint256 => address) private _tokenApprovals;
1066 
1067     // Mapping from owner to operator approvals
1068     mapping(address => mapping(address => bool)) private _operatorApprovals;
1069 
1070     /**
1071      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1072      */
1073     constructor(string memory name_, string memory symbol_) {
1074         _name = name_;
1075         _symbol = symbol_;
1076     }
1077 
1078     /**
1079      * @dev See {IERC165-supportsInterface}.
1080      */
1081     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1082         return
1083             interfaceId == type(IERC721).interfaceId ||
1084             interfaceId == type(IERC721Metadata).interfaceId ||
1085             super.supportsInterface(interfaceId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-balanceOf}.
1090      */
1091     function balanceOf(address owner) public view virtual override returns (uint256) {
1092         require(owner != address(0), "ERC721: address zero is not a valid owner");
1093         return _balances[owner];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-ownerOf}.
1098      */
1099     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1100         address owner = _ownerOf(tokenId);
1101         require(owner != address(0), "ERC721: invalid token ID");
1102         return owner;
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Metadata-name}.
1107      */
1108     function name() public view virtual override returns (string memory) {
1109         return _name;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Metadata-symbol}.
1114      */
1115     function symbol() public view virtual override returns (string memory) {
1116         return _symbol;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Metadata-tokenURI}.
1121      */
1122     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1123         _requireMinted(tokenId);
1124 
1125         string memory baseURI = _baseURI();
1126         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1127     }
1128 
1129     /**
1130      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1131      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1132      * by default, can be overridden in child contracts.
1133      */
1134     function _baseURI() internal view virtual returns (string memory) {
1135         return "";
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-approve}.
1140      */
1141     function approve(address to, uint256 tokenId) public virtual override {
1142         address owner = ERC721.ownerOf(tokenId);
1143         require(to != owner, "ERC721: approval to current owner");
1144 
1145         require(
1146             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1147             "ERC721: approve caller is not token owner or approved for all"
1148         );
1149 
1150         _approve(to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-getApproved}.
1155      */
1156     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1157         _requireMinted(tokenId);
1158 
1159         return _tokenApprovals[tokenId];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-setApprovalForAll}.
1164      */
1165     function setApprovalForAll(address operator, bool approved) public virtual override {
1166         _setApprovalForAll(_msgSender(), operator, approved);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-isApprovedForAll}.
1171      */
1172     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1173         return _operatorApprovals[owner][operator];
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-transferFrom}.
1178      */
1179     function transferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) public virtual override {
1184         //solhint-disable-next-line max-line-length
1185         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1186 
1187         _transfer(from, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-safeTransferFrom}.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         safeTransferFrom(from, to, tokenId, "");
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-safeTransferFrom}.
1203      */
1204     function safeTransferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory data
1209     ) public virtual override {
1210         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1211         _safeTransfer(from, to, tokenId, data);
1212     }
1213 
1214     /**
1215      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1216      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1217      *
1218      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1219      *
1220      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1221      * implement alternative mechanisms to perform token transfer, such as signature-based.
1222      *
1223      * Requirements:
1224      *
1225      * - `from` cannot be the zero address.
1226      * - `to` cannot be the zero address.
1227      * - `tokenId` token must exist and be owned by `from`.
1228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _safeTransfer(
1233         address from,
1234         address to,
1235         uint256 tokenId,
1236         bytes memory data
1237     ) internal virtual {
1238         _transfer(from, to, tokenId);
1239         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1240     }
1241 
1242     /**
1243      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1244      */
1245     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1246         return _owners[tokenId];
1247     }
1248 
1249     /**
1250      * @dev Returns whether `tokenId` exists.
1251      *
1252      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1253      *
1254      * Tokens start existing when they are minted (`_mint`),
1255      * and stop existing when they are burned (`_burn`).
1256      */
1257     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1258         return _ownerOf(tokenId) != address(0);
1259     }
1260 
1261     /**
1262      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1263      *
1264      * Requirements:
1265      *
1266      * - `tokenId` must exist.
1267      */
1268     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1269         address owner = ERC721.ownerOf(tokenId);
1270         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1271     }
1272 
1273     /**
1274      * @dev Safely mints `tokenId` and transfers it to `to`.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must not exist.
1279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _safeMint(address to, uint256 tokenId) internal virtual {
1284         _safeMint(to, tokenId, "");
1285     }
1286 
1287     /**
1288      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1289      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1290      */
1291     function _safeMint(
1292         address to,
1293         uint256 tokenId,
1294         bytes memory data
1295     ) internal virtual {
1296         _mint(to, tokenId);
1297         require(
1298             _checkOnERC721Received(address(0), to, tokenId, data),
1299             "ERC721: transfer to non ERC721Receiver implementer"
1300         );
1301     }
1302 
1303     /**
1304      * @dev Mints `tokenId` and transfers it to `to`.
1305      *
1306      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must not exist.
1311      * - `to` cannot be the zero address.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _mint(address to, uint256 tokenId) internal virtual {
1316         require(to != address(0), "ERC721: mint to the zero address");
1317         require(!_exists(tokenId), "ERC721: token already minted");
1318 
1319         _beforeTokenTransfer(address(0), to, tokenId, 1);
1320 
1321         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1322         require(!_exists(tokenId), "ERC721: token already minted");
1323 
1324         unchecked {
1325             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1326             // Given that tokens are minted one by one, it is impossible in practice that
1327             // this ever happens. Might change if we allow batch minting.
1328             // The ERC fails to describe this case.
1329             _balances[to] += 1;
1330         }
1331 
1332         _owners[tokenId] = to;
1333 
1334         emit Transfer(address(0), to, tokenId);
1335 
1336         _afterTokenTransfer(address(0), to, tokenId, 1);
1337     }
1338 
1339     /**
1340      * @dev Destroys `tokenId`.
1341      * The approval is cleared when the token is burned.
1342      * This is an internal function that does not check if the sender is authorized to operate on the token.
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must exist.
1347      *
1348      * Emits a {Transfer} event.
1349      */
1350     function _burn(uint256 tokenId) internal virtual {
1351         address owner = ERC721.ownerOf(tokenId);
1352 
1353         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1354 
1355         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1356         owner = ERC721.ownerOf(tokenId);
1357 
1358         // Clear approvals
1359         delete _tokenApprovals[tokenId];
1360 
1361         unchecked {
1362             // Cannot overflow, as that would require more tokens to be burned/transferred
1363             // out than the owner initially received through minting and transferring in.
1364             _balances[owner] -= 1;
1365         }
1366         delete _owners[tokenId];
1367 
1368         emit Transfer(owner, address(0), tokenId);
1369 
1370         _afterTokenTransfer(owner, address(0), tokenId, 1);
1371     }
1372 
1373     /**
1374      * @dev Transfers `tokenId` from `from` to `to`.
1375      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - `tokenId` token must be owned by `from`.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _transfer(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) internal virtual {
1389         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1390         require(to != address(0), "ERC721: transfer to the zero address");
1391 
1392         _beforeTokenTransfer(from, to, tokenId, 1);
1393 
1394         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1395         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1396 
1397         // Clear approvals from the previous owner
1398         delete _tokenApprovals[tokenId];
1399 
1400         unchecked {
1401             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1402             // `from`'s balance is the number of token held, which is at least one before the current
1403             // transfer.
1404             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1405             // all 2**256 token ids to be minted, which in practice is impossible.
1406             _balances[from] -= 1;
1407             _balances[to] += 1;
1408         }
1409         _owners[tokenId] = to;
1410 
1411         emit Transfer(from, to, tokenId);
1412 
1413         _afterTokenTransfer(from, to, tokenId, 1);
1414     }
1415 
1416     /**
1417      * @dev Approve `to` to operate on `tokenId`
1418      *
1419      * Emits an {Approval} event.
1420      */
1421     function _approve(address to, uint256 tokenId) internal virtual {
1422         _tokenApprovals[tokenId] = to;
1423         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1424     }
1425 
1426     /**
1427      * @dev Approve `operator` to operate on all of `owner` tokens
1428      *
1429      * Emits an {ApprovalForAll} event.
1430      */
1431     function _setApprovalForAll(
1432         address owner,
1433         address operator,
1434         bool approved
1435     ) internal virtual {
1436         require(owner != operator, "ERC721: approve to caller");
1437         _operatorApprovals[owner][operator] = approved;
1438         emit ApprovalForAll(owner, operator, approved);
1439     }
1440 
1441     /**
1442      * @dev Reverts if the `tokenId` has not been minted yet.
1443      */
1444     function _requireMinted(uint256 tokenId) internal view virtual {
1445         require(_exists(tokenId), "ERC721: invalid token ID");
1446     }
1447 
1448     /**
1449      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1450      * The call is not executed if the target address is not a contract.
1451      *
1452      * @param from address representing the previous owner of the given token ID
1453      * @param to target address that will receive the tokens
1454      * @param tokenId uint256 ID of the token to be transferred
1455      * @param data bytes optional data to send along with the call
1456      * @return bool whether the call correctly returned the expected magic value
1457      */
1458     function _checkOnERC721Received(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory data
1463     ) private returns (bool) {
1464         if (to.isContract()) {
1465             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1466                 return retval == IERC721Receiver.onERC721Received.selector;
1467             } catch (bytes memory reason) {
1468                 if (reason.length == 0) {
1469                     revert("ERC721: transfer to non ERC721Receiver implementer");
1470                 } else {
1471                     /// @solidity memory-safe-assembly
1472                     assembly {
1473                         revert(add(32, reason), mload(reason))
1474                     }
1475                 }
1476             }
1477         } else {
1478             return true;
1479         }
1480     }
1481 
1482     /**
1483      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1484      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1485      *
1486      * Calling conditions:
1487      *
1488      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1489      * - When `from` is zero, the tokens will be minted for `to`.
1490      * - When `to` is zero, ``from``'s tokens will be burned.
1491      * - `from` and `to` are never both zero.
1492      * - `batchSize` is non-zero.
1493      *
1494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1495      */
1496     function _beforeTokenTransfer(
1497         address from,
1498         address to,
1499         uint256 firstTokenId,
1500         uint256 batchSize
1501     ) internal virtual {}
1502 
1503     /**
1504      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1505      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1506      *
1507      * Calling conditions:
1508      *
1509      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1510      * - When `from` is zero, the tokens were minted for `to`.
1511      * - When `to` is zero, ``from``'s tokens were burned.
1512      * - `from` and `to` are never both zero.
1513      * - `batchSize` is non-zero.
1514      *
1515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1516      */
1517     function _afterTokenTransfer(
1518         address from,
1519         address to,
1520         uint256 firstTokenId,
1521         uint256 batchSize
1522     ) internal virtual {}
1523 
1524     /**
1525      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1526      *
1527      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1528      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1529      * that `ownerOf(tokenId)` is `a`.
1530      */
1531     // solhint-disable-next-line func-name-mixedcase
1532     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1533         _balances[account] += amount;
1534     }
1535 }
1536 
1537 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1538 
1539 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Interface for the NFT Royalty Standard.
1545  *
1546  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1547  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1548  *
1549  * _Available since v4.5._
1550  */
1551 interface IERC2981 is IERC165 {
1552     /**
1553      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1554      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1555      */
1556     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1557         external
1558         view
1559         returns (address receiver, uint256 royaltyAmount);
1560 }
1561 
1562 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1563 
1564 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1565 
1566 pragma solidity ^0.8.0;
1567 
1568 
1569 /**
1570  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1571  *
1572  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1573  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1574  *
1575  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1576  * fee is specified in basis points by default.
1577  *
1578  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1579  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1580  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1581  *
1582  * _Available since v4.5._
1583  */
1584 abstract contract ERC2981 is IERC2981, ERC165 {
1585     struct RoyaltyInfo {
1586         address receiver;
1587         uint96 royaltyFraction;
1588     }
1589 
1590     RoyaltyInfo private _defaultRoyaltyInfo;
1591     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1592 
1593     /**
1594      * @dev See {IERC165-supportsInterface}.
1595      */
1596     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1597         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1598     }
1599 
1600     /**
1601      * @inheritdoc IERC2981
1602      */
1603     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1604         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1605 
1606         if (royalty.receiver == address(0)) {
1607             royalty = _defaultRoyaltyInfo;
1608         }
1609 
1610         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1611 
1612         return (royalty.receiver, royaltyAmount);
1613     }
1614 
1615     /**
1616      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1617      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1618      * override.
1619      */
1620     function _feeDenominator() internal pure virtual returns (uint96) {
1621         return 10000;
1622     }
1623 
1624     /**
1625      * @dev Sets the royalty information that all ids in this contract will default to.
1626      *
1627      * Requirements:
1628      *
1629      * - `receiver` cannot be the zero address.
1630      * - `feeNumerator` cannot be greater than the fee denominator.
1631      */
1632     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1633         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1634         require(receiver != address(0), "ERC2981: invalid receiver");
1635 
1636         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1637     }
1638 
1639     /**
1640      * @dev Removes default royalty information.
1641      */
1642     function _deleteDefaultRoyalty() internal virtual {
1643         delete _defaultRoyaltyInfo;
1644     }
1645 
1646     /**
1647      * @dev Sets the royalty information for a specific token id, overriding the global default.
1648      *
1649      * Requirements:
1650      *
1651      * - `receiver` cannot be the zero address.
1652      * - `feeNumerator` cannot be greater than the fee denominator.
1653      */
1654     function _setTokenRoyalty(
1655         uint256 tokenId,
1656         address receiver,
1657         uint96 feeNumerator
1658     ) internal virtual {
1659         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1660         require(receiver != address(0), "ERC2981: Invalid parameters");
1661 
1662         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1663     }
1664 
1665     /**
1666      * @dev Resets royalty information for the token id back to the global default.
1667      */
1668     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1669         delete _tokenRoyaltyInfo[tokenId];
1670     }
1671 }
1672 
1673 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
1674 
1675 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
1676 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1677 
1678 pragma solidity ^0.8.0;
1679 
1680 /**
1681  * @dev Library for managing
1682  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1683  * types.
1684  *
1685  * Sets have the following properties:
1686  *
1687  * - Elements are added, removed, and checked for existence in constant time
1688  * (O(1)).
1689  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1690  *
1691  * ```
1692  * contract Example {
1693  *     // Add the library methods
1694  *     using EnumerableSet for EnumerableSet.AddressSet;
1695  *
1696  *     // Declare a set state variable
1697  *     EnumerableSet.AddressSet private mySet;
1698  * }
1699  * ```
1700  *
1701  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1702  * and `uint256` (`UintSet`) are supported.
1703  *
1704  * [WARNING]
1705  * ====
1706  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1707  * unusable.
1708  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1709  *
1710  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1711  * array of EnumerableSet.
1712  * ====
1713  */
1714 library EnumerableSet {
1715     // To implement this library for multiple types with as little code
1716     // repetition as possible, we write it in terms of a generic Set type with
1717     // bytes32 values.
1718     // The Set implementation uses private functions, and user-facing
1719     // implementations (such as AddressSet) are just wrappers around the
1720     // underlying Set.
1721     // This means that we can only create new EnumerableSets for types that fit
1722     // in bytes32.
1723 
1724     struct Set {
1725         // Storage of set values
1726         bytes32[] _values;
1727         // Position of the value in the `values` array, plus 1 because index 0
1728         // means a value is not in the set.
1729         mapping(bytes32 => uint256) _indexes;
1730     }
1731 
1732     /**
1733      * @dev Add a value to a set. O(1).
1734      *
1735      * Returns true if the value was added to the set, that is if it was not
1736      * already present.
1737      */
1738     function _add(Set storage set, bytes32 value) private returns (bool) {
1739         if (!_contains(set, value)) {
1740             set._values.push(value);
1741             // The value is stored at length-1, but we add 1 to all indexes
1742             // and use 0 as a sentinel value
1743             set._indexes[value] = set._values.length;
1744             return true;
1745         } else {
1746             return false;
1747         }
1748     }
1749 
1750     /**
1751      * @dev Removes a value from a set. O(1).
1752      *
1753      * Returns true if the value was removed from the set, that is if it was
1754      * present.
1755      */
1756     function _remove(Set storage set, bytes32 value) private returns (bool) {
1757         // We read and store the value's index to prevent multiple reads from the same storage slot
1758         uint256 valueIndex = set._indexes[value];
1759 
1760         if (valueIndex != 0) {
1761             // Equivalent to contains(set, value)
1762             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1763             // the array, and then remove the last element (sometimes called as 'swap and pop').
1764             // This modifies the order of the array, as noted in {at}.
1765 
1766             uint256 toDeleteIndex = valueIndex - 1;
1767             uint256 lastIndex = set._values.length - 1;
1768 
1769             if (lastIndex != toDeleteIndex) {
1770                 bytes32 lastValue = set._values[lastIndex];
1771 
1772                 // Move the last value to the index where the value to delete is
1773                 set._values[toDeleteIndex] = lastValue;
1774                 // Update the index for the moved value
1775                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1776             }
1777 
1778             // Delete the slot where the moved value was stored
1779             set._values.pop();
1780 
1781             // Delete the index for the deleted slot
1782             delete set._indexes[value];
1783 
1784             return true;
1785         } else {
1786             return false;
1787         }
1788     }
1789 
1790     /**
1791      * @dev Returns true if the value is in the set. O(1).
1792      */
1793     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1794         return set._indexes[value] != 0;
1795     }
1796 
1797     /**
1798      * @dev Returns the number of values on the set. O(1).
1799      */
1800     function _length(Set storage set) private view returns (uint256) {
1801         return set._values.length;
1802     }
1803 
1804     /**
1805      * @dev Returns the value stored at position `index` in the set. O(1).
1806      *
1807      * Note that there are no guarantees on the ordering of values inside the
1808      * array, and it may change when more values are added or removed.
1809      *
1810      * Requirements:
1811      *
1812      * - `index` must be strictly less than {length}.
1813      */
1814     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1815         return set._values[index];
1816     }
1817 
1818     /**
1819      * @dev Return the entire set in an array
1820      *
1821      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1822      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1823      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1824      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1825      */
1826     function _values(Set storage set) private view returns (bytes32[] memory) {
1827         return set._values;
1828     }
1829 
1830     // Bytes32Set
1831 
1832     struct Bytes32Set {
1833         Set _inner;
1834     }
1835 
1836     /**
1837      * @dev Add a value to a set. O(1).
1838      *
1839      * Returns true if the value was added to the set, that is if it was not
1840      * already present.
1841      */
1842     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1843         return _add(set._inner, value);
1844     }
1845 
1846     /**
1847      * @dev Removes a value from a set. O(1).
1848      *
1849      * Returns true if the value was removed from the set, that is if it was
1850      * present.
1851      */
1852     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1853         return _remove(set._inner, value);
1854     }
1855 
1856     /**
1857      * @dev Returns true if the value is in the set. O(1).
1858      */
1859     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1860         return _contains(set._inner, value);
1861     }
1862 
1863     /**
1864      * @dev Returns the number of values in the set. O(1).
1865      */
1866     function length(Bytes32Set storage set) internal view returns (uint256) {
1867         return _length(set._inner);
1868     }
1869 
1870     /**
1871      * @dev Returns the value stored at position `index` in the set. O(1).
1872      *
1873      * Note that there are no guarantees on the ordering of values inside the
1874      * array, and it may change when more values are added or removed.
1875      *
1876      * Requirements:
1877      *
1878      * - `index` must be strictly less than {length}.
1879      */
1880     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1881         return _at(set._inner, index);
1882     }
1883 
1884     /**
1885      * @dev Return the entire set in an array
1886      *
1887      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1888      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1889      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1890      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1891      */
1892     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1893         bytes32[] memory store = _values(set._inner);
1894         bytes32[] memory result;
1895 
1896         /// @solidity memory-safe-assembly
1897         assembly {
1898             result := store
1899         }
1900 
1901         return result;
1902     }
1903 
1904     // AddressSet
1905 
1906     struct AddressSet {
1907         Set _inner;
1908     }
1909 
1910     /**
1911      * @dev Add a value to a set. O(1).
1912      *
1913      * Returns true if the value was added to the set, that is if it was not
1914      * already present.
1915      */
1916     function add(AddressSet storage set, address value) internal returns (bool) {
1917         return _add(set._inner, bytes32(uint256(uint160(value))));
1918     }
1919 
1920     /**
1921      * @dev Removes a value from a set. O(1).
1922      *
1923      * Returns true if the value was removed from the set, that is if it was
1924      * present.
1925      */
1926     function remove(AddressSet storage set, address value) internal returns (bool) {
1927         return _remove(set._inner, bytes32(uint256(uint160(value))));
1928     }
1929 
1930     /**
1931      * @dev Returns true if the value is in the set. O(1).
1932      */
1933     function contains(AddressSet storage set, address value) internal view returns (bool) {
1934         return _contains(set._inner, bytes32(uint256(uint160(value))));
1935     }
1936 
1937     /**
1938      * @dev Returns the number of values in the set. O(1).
1939      */
1940     function length(AddressSet storage set) internal view returns (uint256) {
1941         return _length(set._inner);
1942     }
1943 
1944     /**
1945      * @dev Returns the value stored at position `index` in the set. O(1).
1946      *
1947      * Note that there are no guarantees on the ordering of values inside the
1948      * array, and it may change when more values are added or removed.
1949      *
1950      * Requirements:
1951      *
1952      * - `index` must be strictly less than {length}.
1953      */
1954     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1955         return address(uint160(uint256(_at(set._inner, index))));
1956     }
1957 
1958     /**
1959      * @dev Return the entire set in an array
1960      *
1961      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1962      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1963      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1964      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1965      */
1966     function values(AddressSet storage set) internal view returns (address[] memory) {
1967         bytes32[] memory store = _values(set._inner);
1968         address[] memory result;
1969 
1970         /// @solidity memory-safe-assembly
1971         assembly {
1972             result := store
1973         }
1974 
1975         return result;
1976     }
1977 
1978     // UintSet
1979 
1980     struct UintSet {
1981         Set _inner;
1982     }
1983 
1984     /**
1985      * @dev Add a value to a set. O(1).
1986      *
1987      * Returns true if the value was added to the set, that is if it was not
1988      * already present.
1989      */
1990     function add(UintSet storage set, uint256 value) internal returns (bool) {
1991         return _add(set._inner, bytes32(value));
1992     }
1993 
1994     /**
1995      * @dev Removes a value from a set. O(1).
1996      *
1997      * Returns true if the value was removed from the set, that is if it was
1998      * present.
1999      */
2000     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2001         return _remove(set._inner, bytes32(value));
2002     }
2003 
2004     /**
2005      * @dev Returns true if the value is in the set. O(1).
2006      */
2007     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2008         return _contains(set._inner, bytes32(value));
2009     }
2010 
2011     /**
2012      * @dev Returns the number of values in the set. O(1).
2013      */
2014     function length(UintSet storage set) internal view returns (uint256) {
2015         return _length(set._inner);
2016     }
2017 
2018     /**
2019      * @dev Returns the value stored at position `index` in the set. O(1).
2020      *
2021      * Note that there are no guarantees on the ordering of values inside the
2022      * array, and it may change when more values are added or removed.
2023      *
2024      * Requirements:
2025      *
2026      * - `index` must be strictly less than {length}.
2027      */
2028     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2029         return uint256(_at(set._inner, index));
2030     }
2031 
2032     /**
2033      * @dev Return the entire set in an array
2034      *
2035      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2036      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2037      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2038      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2039      */
2040     function values(UintSet storage set) internal view returns (uint256[] memory) {
2041         bytes32[] memory store = _values(set._inner);
2042         uint256[] memory result;
2043 
2044         /// @solidity memory-safe-assembly
2045         assembly {
2046             result := store
2047         }
2048 
2049         return result;
2050     }
2051 }
2052 
2053 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
2054 
2055 pragma solidity ^0.8.13;
2056 
2057 interface IOperatorFilterRegistry {
2058     /**
2059      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2060      *         true if supplied registrant address is not registered.
2061      */
2062     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2063 
2064     /**
2065      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2066      */
2067     function register(address registrant) external;
2068 
2069     /**
2070      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2071      */
2072     function registerAndSubscribe(address registrant, address subscription) external;
2073 
2074     /**
2075      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2076      *         address without subscribing.
2077      */
2078     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2079 
2080     /**
2081      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2082      *         Note that this does not remove any filtered addresses or codeHashes.
2083      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2084      */
2085     function unregister(address addr) external;
2086 
2087     /**
2088      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2089      */
2090     function updateOperator(address registrant, address operator, bool filtered) external;
2091 
2092     /**
2093      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2094      */
2095     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2096 
2097     /**
2098      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2099      */
2100     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2101 
2102     /**
2103      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2104      */
2105     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2106 
2107     /**
2108      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2109      *         subscription if present.
2110      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2111      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2112      *         used.
2113      */
2114     function subscribe(address registrant, address registrantToSubscribe) external;
2115 
2116     /**
2117      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2118      */
2119     function unsubscribe(address registrant, bool copyExistingEntries) external;
2120 
2121     /**
2122      * @notice Get the subscription address of a given registrant, if any.
2123      */
2124     function subscriptionOf(address addr) external returns (address registrant);
2125 
2126     /**
2127      * @notice Get the set of addresses subscribed to a given registrant.
2128      *         Note that order is not guaranteed as updates are made.
2129      */
2130     function subscribers(address registrant) external returns (address[] memory);
2131 
2132     /**
2133      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2134      *         Note that order is not guaranteed as updates are made.
2135      */
2136     function subscriberAt(address registrant, uint256 index) external returns (address);
2137 
2138     /**
2139      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2140      */
2141     function copyEntriesOf(address registrant, address registrantToCopy) external;
2142 
2143     /**
2144      * @notice Returns true if operator is filtered by a given address or its subscription.
2145      */
2146     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2147 
2148     /**
2149      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2150      */
2151     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2152 
2153     /**
2154      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2155      */
2156     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2157 
2158     /**
2159      * @notice Returns a list of filtered operators for a given address or its subscription.
2160      */
2161     function filteredOperators(address addr) external returns (address[] memory);
2162 
2163     /**
2164      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2165      *         Note that order is not guaranteed as updates are made.
2166      */
2167     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2168 
2169     /**
2170      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2171      *         its subscription.
2172      *         Note that order is not guaranteed as updates are made.
2173      */
2174     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2175 
2176     /**
2177      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2178      *         its subscription.
2179      *         Note that order is not guaranteed as updates are made.
2180      */
2181     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2182 
2183     /**
2184      * @notice Returns true if an address has registered
2185      */
2186     function isRegistered(address addr) external returns (bool);
2187 
2188     /**
2189      * @dev Convenience method to compute the code hash of an arbitrary contract
2190      */
2191     function codeHashOf(address addr) external returns (bytes32);
2192 }
2193 
2194 // File: operator-filter-registry/src/lib/Constants.sol
2195 
2196 pragma solidity ^0.8.13;
2197 
2198 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2199 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2200 
2201 // File: operator-filter-registry/src/OperatorFilterer.sol
2202 
2203 pragma solidity ^0.8.13;
2204 
2205 
2206 /**
2207  * @title  OperatorFilterer
2208  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2209  *         registrant's entries in the OperatorFilterRegistry.
2210  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2211  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2212  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2213  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2214  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2215  *         will be locked to the options set during construction.
2216  */
2217 
2218 abstract contract OperatorFilterer {
2219     /// @dev Emitted when an operator is not allowed.
2220     error OperatorNotAllowed(address operator);
2221 
2222     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2223         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2224 
2225     /// @dev The constructor that is called when the contract is being deployed.
2226     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2227         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2228         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2229         // order for the modifier to filter addresses.
2230         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2231             if (subscribe) {
2232                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2233             } else {
2234                 if (subscriptionOrRegistrantToCopy != address(0)) {
2235                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2236                 } else {
2237                     OPERATOR_FILTER_REGISTRY.register(address(this));
2238                 }
2239             }
2240         }
2241     }
2242 
2243     /**
2244      * @dev A helper function to check if an operator is allowed.
2245      */
2246     modifier onlyAllowedOperator(address from) virtual {
2247         // Allow spending tokens from addresses with balance
2248         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2249         // from an EOA.
2250         if (from != msg.sender) {
2251             _checkFilterOperator(msg.sender);
2252         }
2253         _;
2254     }
2255 
2256     /**
2257      * @dev A helper function to check if an operator approval is allowed.
2258      */
2259     modifier onlyAllowedOperatorApproval(address operator) virtual {
2260         _checkFilterOperator(operator);
2261         _;
2262     }
2263 
2264     /**
2265      * @dev A helper function to check if an operator is allowed.
2266      */
2267     function _checkFilterOperator(address operator) internal view virtual {
2268         // Check registry code length to facilitate testing in environments without a deployed registry.
2269         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2270             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2271             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2272             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2273                 revert OperatorNotAllowed(operator);
2274             }
2275         }
2276     }
2277 }
2278 
2279 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
2280 
2281 pragma solidity ^0.8.13;
2282 
2283 
2284 /**
2285  * @title  DefaultOperatorFilterer
2286  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2287  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2288  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2289  *         will be locked to the options set during construction.
2290  */
2291 
2292 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2293     /// @dev The constructor that is called when the contract is being deployed.
2294     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2295 }
2296 
2297 // File: contracts/nft/AiDogeAvatarNFT.sol
2298 
2299 
2300 pragma solidity =0.8.19;
2301 
2302 
2303 
2304 
2305 
2306 contract TruthAidoge is Ownable, ERC721, ERC2981, DefaultOperatorFilterer {
2307     using EnumerableSet for EnumerableSet.AddressSet;
2308 
2309     uint256 public constant MAX_SUPPLY = 10000;
2310 
2311     event Open(uint256 indexed id, address indexed owner, uint256 openTime);
2312 
2313     uint256 public nextTokenId = 1;
2314     bool public mintEnded;
2315     string public baseURI;
2316     EnumerableSet.AddressSet private _minters;
2317 
2318     constructor() ERC721("Truth AIDOGE", "AIDO") {
2319     }
2320 
2321     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721) returns (bool) {
2322         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2323     }
2324 
2325     function setDefaultRoyalty(address receiver, uint96 royalty) external onlyOwner {
2326         super._setDefaultRoyalty(receiver, royalty);
2327     }
2328 
2329     function setTokenRoyalty(uint256 id, address receiver, uint96 royalty) external onlyOwner {
2330         super._setTokenRoyalty(id, receiver, royalty);
2331     }
2332 
2333     function resetTokenRoyalty(uint256 id) external onlyOwner {
2334         super._resetTokenRoyalty(id);
2335     }
2336 
2337     function mint(address to) external onlyMinter returns(uint256) {
2338         require(!mintEnded, "TruthAidoge: MINT_ENDED");
2339         require(nextTokenId <= MAX_SUPPLY, "AvatarNft: MAX_SUPPLY");
2340 
2341         uint256 id = nextTokenId;
2342         _safeMint(to, id);
2343         nextTokenId++;
2344         
2345         return id;
2346     }
2347 
2348     function mint(address to, uint num) public onlyMinter {
2349         for(uint i = 0; i < num; ++i) {
2350             uint256 id = nextTokenId;
2351              _safeMint(to, id);
2352              nextTokenId++;
2353         }
2354     }
2355 
2356     function burn(uint256 tokenId) external {
2357         _burn(tokenId);
2358     }
2359 
2360     function _baseURI() internal view virtual override returns (string memory) {
2361         return baseURI;
2362     }
2363 
2364     function setBaseURI(string memory _uri) external onlyOwner {
2365         baseURI = _uri;
2366     }
2367 
2368     function endMint() public onlyOwner {
2369         mintEnded = true;
2370     }
2371 
2372     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2373         super.setApprovalForAll(operator, approved);
2374     }
2375 
2376     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2377         super.approve(operator, tokenId);
2378     }
2379 
2380     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2381         super.transferFrom(from, to, tokenId);
2382     }
2383 
2384     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2385         super.safeTransferFrom(from, to, tokenId);
2386     }
2387 
2388     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2389         super.safeTransferFrom(from, to, tokenId, data);
2390     }
2391 
2392     function addMinter(address minter) public onlyOwner returns (bool) {
2393         require(minter != address(0), "TruthAidoge: minter is the zero address");
2394         return _minters.add(minter);
2395     }
2396 
2397     function delMinter(address minter) public onlyOwner returns (bool) {
2398         require(minter != address(0), "TruthAidoge: minter is the zero address");
2399         return _minters.remove(minter);
2400     }
2401 
2402     function getMinterLength() public view returns (uint256) {
2403         return _minters.length();
2404     }
2405 
2406     function isMinter(address account) public view returns (bool) {
2407         return _minters.contains(account);
2408     }
2409 
2410     function getMinter(uint256 index) public view returns (address) {
2411         require(index <= getMinterLength() - 1, "TruthAidoge: index out of bounds");
2412         return _minters.at(index);
2413     }
2414 
2415     // modifier for mint function
2416     modifier onlyMinter() {
2417         require(isMinter(msg.sender), "TruthAidoge: caller is not the minter");
2418         _;
2419     }
2420 }