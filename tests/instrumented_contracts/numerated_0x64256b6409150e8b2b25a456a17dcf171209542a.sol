1 // SPDX-License-Identifier: MIT
2 
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.1
147 
148 
149 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Required interface of an ERC721 compliant contract.
155  */
156 interface IERC721 is IERC165 {
157     /**
158      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
164      */
165     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
169      */
170     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
171 
172     /**
173      * @dev Returns the number of tokens in ``owner``'s account.
174      */
175     function balanceOf(address owner) external view returns (uint256 balance);
176 
177     /**
178      * @dev Returns the owner of the `tokenId` token.
179      *
180      * Requirements:
181      *
182      * - `tokenId` must exist.
183      */
184     function ownerOf(uint256 tokenId) external view returns (address owner);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external;
205 
206     /**
207      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
208      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must exist and be owned by `from`.
215      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
217      *
218      * Emits a {Transfer} event.
219      */
220     function safeTransferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     /**
227      * @dev Transfers `tokenId` token from `from` to `to`.
228      *
229      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
230      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
231      * understand this adds an external call which potentially creates a reentrancy vulnerability.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Approve or remove `operator` as an operator for the caller.
265      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
266      *
267      * Requirements:
268      *
269      * - The `operator` cannot be the caller.
270      *
271      * Emits an {ApprovalForAll} event.
272      */
273     function setApprovalForAll(address operator, bool _approved) external;
274 
275     /**
276      * @dev Returns the account approved for `tokenId` token.
277      *
278      * Requirements:
279      *
280      * - `tokenId` must exist.
281      */
282     function getApproved(uint256 tokenId) external view returns (address operator);
283 
284     /**
285      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
286      *
287      * See {setApprovalForAll}
288      */
289     function isApprovedForAll(address owner, address operator) external view returns (bool);
290 }
291 
292 
293 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.1
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
302  * @dev See https://eips.ethereum.org/EIPS/eip-721
303  */
304 interface IERC721Metadata is IERC721 {
305     /**
306      * @dev Returns the token collection name.
307      */
308     function name() external view returns (string memory);
309 
310     /**
311      * @dev Returns the token collection symbol.
312      */
313     function symbol() external view returns (string memory);
314 
315     /**
316      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
317      */
318     function tokenURI(uint256 tokenId) external view returns (string memory);
319 }
320 
321 
322 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.1
323 
324 
325 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @title ERC721 token receiver interface
331  * @dev Interface for any contract that wants to support safeTransfers
332  * from ERC721 asset contracts.
333  */
334 interface IERC721Receiver {
335     /**
336      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
337      * by `operator` from `from`, this function is called.
338      *
339      * It must return its Solidity selector to confirm the token transfer.
340      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
341      *
342      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
343      */
344     function onERC721Received(
345         address operator,
346         address from,
347         uint256 tokenId,
348         bytes calldata data
349     ) external returns (bytes4);
350 }
351 
352 
353 // File @openzeppelin/contracts/utils/Address.sol@v4.8.1
354 
355 
356 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
357 
358 pragma solidity ^0.8.1;
359 
360 /**
361  * @dev Collection of functions related to the address type
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * [IMPORTANT]
368      * ====
369      * It is unsafe to assume that an address for which this function returns
370      * false is an externally-owned account (EOA) and not a contract.
371      *
372      * Among others, `isContract` will return false for the following
373      * types of addresses:
374      *
375      *  - an externally-owned account
376      *  - a contract in construction
377      *  - an address where a contract will be created
378      *  - an address where a contract lived, but was destroyed
379      * ====
380      *
381      * [IMPORTANT]
382      * ====
383      * You shouldn't rely on `isContract` to protect against flash loan attacks!
384      *
385      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
386      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
387      * constructor.
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize/address.code.length, which returns 0
392         // for contracts in construction, since the code is only stored at the end
393         // of the constructor execution.
394 
395         return account.code.length > 0;
396     }
397 
398     /**
399      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
400      * `recipient`, forwarding all available gas and reverting on errors.
401      *
402      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
403      * of certain opcodes, possibly making contracts go over the 2300 gas limit
404      * imposed by `transfer`, making them unable to receive funds via
405      * `transfer`. {sendValue} removes this limitation.
406      *
407      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
408      *
409      * IMPORTANT: because control is transferred to `recipient`, care must be
410      * taken to not create reentrancy vulnerabilities. Consider using
411      * {ReentrancyGuard} or the
412      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
413      */
414     function sendValue(address payable recipient, uint256 amount) internal {
415         require(address(this).balance >= amount, "Address: insufficient balance");
416 
417         (bool success, ) = recipient.call{value: amount}("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain `call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(address(this).balance >= value, "Address: insufficient balance for call");
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         (bool success, bytes memory returndata) = target.staticcall(data);
515         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a delegate call.
521      *
522      * _Available since v3.4._
523      */
524     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a delegate call.
531      *
532      * _Available since v3.4._
533      */
534     function functionDelegateCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         (bool success, bytes memory returndata) = target.delegatecall(data);
540         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
545      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
546      *
547      * _Available since v4.8._
548      */
549     function verifyCallResultFromTarget(
550         address target,
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         if (success) {
556             if (returndata.length == 0) {
557                 // only check isContract if the call was successful and the return data is empty
558                 // otherwise we already know that it was a contract
559                 require(isContract(target), "Address: call to non-contract");
560             }
561             return returndata;
562         } else {
563             _revert(returndata, errorMessage);
564         }
565     }
566 
567     /**
568      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
569      * revert reason or using the provided one.
570      *
571      * _Available since v4.3._
572      */
573     function verifyCallResult(
574         bool success,
575         bytes memory returndata,
576         string memory errorMessage
577     ) internal pure returns (bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             _revert(returndata, errorMessage);
582         }
583     }
584 
585     function _revert(bytes memory returndata, string memory errorMessage) private pure {
586         // Look for revert reason and bubble it up if present
587         if (returndata.length > 0) {
588             // The easiest way to bubble the revert reason is using memory via assembly
589             /// @solidity memory-safe-assembly
590             assembly {
591                 let returndata_size := mload(returndata)
592                 revert(add(32, returndata), returndata_size)
593             }
594         } else {
595             revert(errorMessage);
596         }
597     }
598 }
599 
600 
601 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev Implementation of the {IERC165} interface.
610  *
611  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
612  * for the additional interface id that will be supported. For example:
613  *
614  * ```solidity
615  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
617  * }
618  * ```
619  *
620  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
621  */
622 abstract contract ERC165 is IERC165 {
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627         return interfaceId == type(IERC165).interfaceId;
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1
633 
634 
635 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Standard math utilities missing in the Solidity language.
641  */
642 library Math {
643     enum Rounding {
644         Down, // Toward negative infinity
645         Up, // Toward infinity
646         Zero // Toward zero
647     }
648 
649     /**
650      * @dev Returns the largest of two numbers.
651      */
652     function max(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a > b ? a : b;
654     }
655 
656     /**
657      * @dev Returns the smallest of two numbers.
658      */
659     function min(uint256 a, uint256 b) internal pure returns (uint256) {
660         return a < b ? a : b;
661     }
662 
663     /**
664      * @dev Returns the average of two numbers. The result is rounded towards
665      * zero.
666      */
667     function average(uint256 a, uint256 b) internal pure returns (uint256) {
668         // (a + b) / 2 can overflow.
669         return (a & b) + (a ^ b) / 2;
670     }
671 
672     /**
673      * @dev Returns the ceiling of the division of two numbers.
674      *
675      * This differs from standard division with `/` in that it rounds up instead
676      * of rounding down.
677      */
678     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
679         // (a + b - 1) / b can overflow on addition, so we distribute.
680         return a == 0 ? 0 : (a - 1) / b + 1;
681     }
682 
683     /**
684      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
685      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
686      * with further edits by Uniswap Labs also under MIT license.
687      */
688     function mulDiv(
689         uint256 x,
690         uint256 y,
691         uint256 denominator
692     ) internal pure returns (uint256 result) {
693         unchecked {
694             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
695             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
696             // variables such that product = prod1 * 2^256 + prod0.
697             uint256 prod0; // Least significant 256 bits of the product
698             uint256 prod1; // Most significant 256 bits of the product
699             assembly {
700                 let mm := mulmod(x, y, not(0))
701                 prod0 := mul(x, y)
702                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
703             }
704 
705             // Handle non-overflow cases, 256 by 256 division.
706             if (prod1 == 0) {
707                 return prod0 / denominator;
708             }
709 
710             // Make sure the result is less than 2^256. Also prevents denominator == 0.
711             require(denominator > prod1);
712 
713             ///////////////////////////////////////////////
714             // 512 by 256 division.
715             ///////////////////////////////////////////////
716 
717             // Make division exact by subtracting the remainder from [prod1 prod0].
718             uint256 remainder;
719             assembly {
720                 // Compute remainder using mulmod.
721                 remainder := mulmod(x, y, denominator)
722 
723                 // Subtract 256 bit number from 512 bit number.
724                 prod1 := sub(prod1, gt(remainder, prod0))
725                 prod0 := sub(prod0, remainder)
726             }
727 
728             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
729             // See https://cs.stackexchange.com/q/138556/92363.
730 
731             // Does not overflow because the denominator cannot be zero at this stage in the function.
732             uint256 twos = denominator & (~denominator + 1);
733             assembly {
734                 // Divide denominator by twos.
735                 denominator := div(denominator, twos)
736 
737                 // Divide [prod1 prod0] by twos.
738                 prod0 := div(prod0, twos)
739 
740                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
741                 twos := add(div(sub(0, twos), twos), 1)
742             }
743 
744             // Shift in bits from prod1 into prod0.
745             prod0 |= prod1 * twos;
746 
747             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
748             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
749             // four bits. That is, denominator * inv = 1 mod 2^4.
750             uint256 inverse = (3 * denominator) ^ 2;
751 
752             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
753             // in modular arithmetic, doubling the correct bits in each step.
754             inverse *= 2 - denominator * inverse; // inverse mod 2^8
755             inverse *= 2 - denominator * inverse; // inverse mod 2^16
756             inverse *= 2 - denominator * inverse; // inverse mod 2^32
757             inverse *= 2 - denominator * inverse; // inverse mod 2^64
758             inverse *= 2 - denominator * inverse; // inverse mod 2^128
759             inverse *= 2 - denominator * inverse; // inverse mod 2^256
760 
761             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
762             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
763             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
764             // is no longer required.
765             result = prod0 * inverse;
766             return result;
767         }
768     }
769 
770     /**
771      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
772      */
773     function mulDiv(
774         uint256 x,
775         uint256 y,
776         uint256 denominator,
777         Rounding rounding
778     ) internal pure returns (uint256) {
779         uint256 result = mulDiv(x, y, denominator);
780         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
781             result += 1;
782         }
783         return result;
784     }
785 
786     /**
787      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
788      *
789      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
790      */
791     function sqrt(uint256 a) internal pure returns (uint256) {
792         if (a == 0) {
793             return 0;
794         }
795 
796         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
797         //
798         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
799         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
800         //
801         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
802         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
803         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
804         //
805         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
806         uint256 result = 1 << (log2(a) >> 1);
807 
808         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
809         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
810         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
811         // into the expected uint128 result.
812         unchecked {
813             result = (result + a / result) >> 1;
814             result = (result + a / result) >> 1;
815             result = (result + a / result) >> 1;
816             result = (result + a / result) >> 1;
817             result = (result + a / result) >> 1;
818             result = (result + a / result) >> 1;
819             result = (result + a / result) >> 1;
820             return min(result, a / result);
821         }
822     }
823 
824     /**
825      * @notice Calculates sqrt(a), following the selected rounding direction.
826      */
827     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
828         unchecked {
829             uint256 result = sqrt(a);
830             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
831         }
832     }
833 
834     /**
835      * @dev Return the log in base 2, rounded down, of a positive value.
836      * Returns 0 if given 0.
837      */
838     function log2(uint256 value) internal pure returns (uint256) {
839         uint256 result = 0;
840         unchecked {
841             if (value >> 128 > 0) {
842                 value >>= 128;
843                 result += 128;
844             }
845             if (value >> 64 > 0) {
846                 value >>= 64;
847                 result += 64;
848             }
849             if (value >> 32 > 0) {
850                 value >>= 32;
851                 result += 32;
852             }
853             if (value >> 16 > 0) {
854                 value >>= 16;
855                 result += 16;
856             }
857             if (value >> 8 > 0) {
858                 value >>= 8;
859                 result += 8;
860             }
861             if (value >> 4 > 0) {
862                 value >>= 4;
863                 result += 4;
864             }
865             if (value >> 2 > 0) {
866                 value >>= 2;
867                 result += 2;
868             }
869             if (value >> 1 > 0) {
870                 result += 1;
871             }
872         }
873         return result;
874     }
875 
876     /**
877      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
878      * Returns 0 if given 0.
879      */
880     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
881         unchecked {
882             uint256 result = log2(value);
883             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
884         }
885     }
886 
887     /**
888      * @dev Return the log in base 10, rounded down, of a positive value.
889      * Returns 0 if given 0.
890      */
891     function log10(uint256 value) internal pure returns (uint256) {
892         uint256 result = 0;
893         unchecked {
894             if (value >= 10**64) {
895                 value /= 10**64;
896                 result += 64;
897             }
898             if (value >= 10**32) {
899                 value /= 10**32;
900                 result += 32;
901             }
902             if (value >= 10**16) {
903                 value /= 10**16;
904                 result += 16;
905             }
906             if (value >= 10**8) {
907                 value /= 10**8;
908                 result += 8;
909             }
910             if (value >= 10**4) {
911                 value /= 10**4;
912                 result += 4;
913             }
914             if (value >= 10**2) {
915                 value /= 10**2;
916                 result += 2;
917             }
918             if (value >= 10**1) {
919                 result += 1;
920             }
921         }
922         return result;
923     }
924 
925     /**
926      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
927      * Returns 0 if given 0.
928      */
929     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
930         unchecked {
931             uint256 result = log10(value);
932             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
933         }
934     }
935 
936     /**
937      * @dev Return the log in base 256, rounded down, of a positive value.
938      * Returns 0 if given 0.
939      *
940      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
941      */
942     function log256(uint256 value) internal pure returns (uint256) {
943         uint256 result = 0;
944         unchecked {
945             if (value >> 128 > 0) {
946                 value >>= 128;
947                 result += 16;
948             }
949             if (value >> 64 > 0) {
950                 value >>= 64;
951                 result += 8;
952             }
953             if (value >> 32 > 0) {
954                 value >>= 32;
955                 result += 4;
956             }
957             if (value >> 16 > 0) {
958                 value >>= 16;
959                 result += 2;
960             }
961             if (value >> 8 > 0) {
962                 result += 1;
963             }
964         }
965         return result;
966     }
967 
968     /**
969      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
970      * Returns 0 if given 0.
971      */
972     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
973         unchecked {
974             uint256 result = log256(value);
975             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
976         }
977     }
978 }
979 
980 
981 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.1
982 
983 
984 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
985 
986 pragma solidity ^0.8.0;
987 
988 /**
989  * @dev String operations.
990  */
991 library Strings {
992     bytes16 private constant _SYMBOLS = "0123456789abcdef";
993     uint8 private constant _ADDRESS_LENGTH = 20;
994 
995     /**
996      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
997      */
998     function toString(uint256 value) internal pure returns (string memory) {
999         unchecked {
1000             uint256 length = Math.log10(value) + 1;
1001             string memory buffer = new string(length);
1002             uint256 ptr;
1003             /// @solidity memory-safe-assembly
1004             assembly {
1005                 ptr := add(buffer, add(32, length))
1006             }
1007             while (true) {
1008                 ptr--;
1009                 /// @solidity memory-safe-assembly
1010                 assembly {
1011                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1012                 }
1013                 value /= 10;
1014                 if (value == 0) break;
1015             }
1016             return buffer;
1017         }
1018     }
1019 
1020     /**
1021      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1022      */
1023     function toHexString(uint256 value) internal pure returns (string memory) {
1024         unchecked {
1025             return toHexString(value, Math.log256(value) + 1);
1026         }
1027     }
1028 
1029     /**
1030      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1031      */
1032     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1033         bytes memory buffer = new bytes(2 * length + 2);
1034         buffer[0] = "0";
1035         buffer[1] = "x";
1036         for (uint256 i = 2 * length + 1; i > 1; --i) {
1037             buffer[i] = _SYMBOLS[value & 0xf];
1038             value >>= 4;
1039         }
1040         require(value == 0, "Strings: hex length insufficient");
1041         return string(buffer);
1042     }
1043 
1044     /**
1045      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1046      */
1047     function toHexString(address addr) internal pure returns (string memory) {
1048         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1049     }
1050 }
1051 
1052 
1053 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.1
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 /**
1067  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1068  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1069  * {ERC721Enumerable}.
1070  */
1071 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1072     using Address for address;
1073     using Strings for uint256;
1074 
1075     // Token name
1076     string private _name;
1077 
1078     // Token symbol
1079     string private _symbol;
1080 
1081     // Mapping from token ID to owner address
1082     mapping(uint256 => address) private _owners;
1083 
1084     // Mapping owner address to token count
1085     mapping(address => uint256) private _balances;
1086 
1087     // Mapping from token ID to approved address
1088     mapping(uint256 => address) private _tokenApprovals;
1089 
1090     // Mapping from owner to operator approvals
1091     mapping(address => mapping(address => bool)) private _operatorApprovals;
1092 
1093     /**
1094      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1095      */
1096     constructor(string memory name_, string memory symbol_) {
1097         _name = name_;
1098         _symbol = symbol_;
1099     }
1100 
1101     /**
1102      * @dev See {IERC165-supportsInterface}.
1103      */
1104     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1105         return
1106             interfaceId == type(IERC721).interfaceId ||
1107             interfaceId == type(IERC721Metadata).interfaceId ||
1108             super.supportsInterface(interfaceId);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-balanceOf}.
1113      */
1114     function balanceOf(address owner) public view virtual override returns (uint256) {
1115         require(owner != address(0), "ERC721: address zero is not a valid owner");
1116         return _balances[owner];
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-ownerOf}.
1121      */
1122     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1123         address owner = _ownerOf(tokenId);
1124         require(owner != address(0), "ERC721: invalid token ID");
1125         return owner;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Metadata-name}.
1130      */
1131     function name() public view virtual override returns (string memory) {
1132         return _name;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-symbol}.
1137      */
1138     function symbol() public view virtual override returns (string memory) {
1139         return _symbol;
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Metadata-tokenURI}.
1144      */
1145     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1146         _requireMinted(tokenId);
1147 
1148         string memory baseURI = _baseURI();
1149         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1150     }
1151 
1152     /**
1153      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1154      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1155      * by default, can be overridden in child contracts.
1156      */
1157     function _baseURI() internal view virtual returns (string memory) {
1158         return "";
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-approve}.
1163      */
1164     function approve(address to, uint256 tokenId) public virtual override {
1165         address owner = ERC721.ownerOf(tokenId);
1166         require(to != owner, "ERC721: approval to current owner");
1167 
1168         require(
1169             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1170             "ERC721: approve caller is not token owner or approved for all"
1171         );
1172 
1173         _approve(to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-getApproved}.
1178      */
1179     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1180         _requireMinted(tokenId);
1181 
1182         return _tokenApprovals[tokenId];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-setApprovalForAll}.
1187      */
1188     function setApprovalForAll(address operator, bool approved) public virtual override {
1189         _setApprovalForAll(_msgSender(), operator, approved);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-isApprovedForAll}.
1194      */
1195     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1196         return _operatorApprovals[owner][operator];
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-transferFrom}.
1201      */
1202     function transferFrom(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) public virtual override {
1207         //solhint-disable-next-line max-line-length
1208         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1209 
1210         _transfer(from, to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-safeTransferFrom}.
1215      */
1216     function safeTransferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) public virtual override {
1221         safeTransferFrom(from, to, tokenId, "");
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-safeTransferFrom}.
1226      */
1227     function safeTransferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory data
1232     ) public virtual override {
1233         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1234         _safeTransfer(from, to, tokenId, data);
1235     }
1236 
1237     /**
1238      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1239      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1240      *
1241      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1242      *
1243      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1244      * implement alternative mechanisms to perform token transfer, such as signature-based.
1245      *
1246      * Requirements:
1247      *
1248      * - `from` cannot be the zero address.
1249      * - `to` cannot be the zero address.
1250      * - `tokenId` token must exist and be owned by `from`.
1251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _safeTransfer(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory data
1260     ) internal virtual {
1261         _transfer(from, to, tokenId);
1262         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1263     }
1264 
1265     /**
1266      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1267      */
1268     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1269         return _owners[tokenId];
1270     }
1271 
1272     /**
1273      * @dev Returns whether `tokenId` exists.
1274      *
1275      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1276      *
1277      * Tokens start existing when they are minted (`_mint`),
1278      * and stop existing when they are burned (`_burn`).
1279      */
1280     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1281         return _ownerOf(tokenId) != address(0);
1282     }
1283 
1284     /**
1285      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1286      *
1287      * Requirements:
1288      *
1289      * - `tokenId` must exist.
1290      */
1291     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1292         address owner = ERC721.ownerOf(tokenId);
1293         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1294     }
1295 
1296     /**
1297      * @dev Safely mints `tokenId` and transfers it to `to`.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must not exist.
1302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function _safeMint(address to, uint256 tokenId) internal virtual {
1307         _safeMint(to, tokenId, "");
1308     }
1309 
1310     /**
1311      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1312      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1313      */
1314     function _safeMint(
1315         address to,
1316         uint256 tokenId,
1317         bytes memory data
1318     ) internal virtual {
1319         _mint(to, tokenId);
1320         require(
1321             _checkOnERC721Received(address(0), to, tokenId, data),
1322             "ERC721: transfer to non ERC721Receiver implementer"
1323         );
1324     }
1325 
1326     /**
1327      * @dev Mints `tokenId` and transfers it to `to`.
1328      *
1329      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must not exist.
1334      * - `to` cannot be the zero address.
1335      *
1336      * Emits a {Transfer} event.
1337      */
1338     function _mint(address to, uint256 tokenId) internal virtual {
1339         require(to != address(0), "ERC721: mint to the zero address");
1340         require(!_exists(tokenId), "ERC721: token already minted");
1341 
1342         _beforeTokenTransfer(address(0), to, tokenId, 1);
1343 
1344         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1345         require(!_exists(tokenId), "ERC721: token already minted");
1346 
1347         unchecked {
1348             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1349             // Given that tokens are minted one by one, it is impossible in practice that
1350             // this ever happens. Might change if we allow batch minting.
1351             // The ERC fails to describe this case.
1352             _balances[to] += 1;
1353         }
1354 
1355         _owners[tokenId] = to;
1356 
1357         emit Transfer(address(0), to, tokenId);
1358 
1359         _afterTokenTransfer(address(0), to, tokenId, 1);
1360     }
1361 
1362     /**
1363      * @dev Destroys `tokenId`.
1364      * The approval is cleared when the token is burned.
1365      * This is an internal function that does not check if the sender is authorized to operate on the token.
1366      *
1367      * Requirements:
1368      *
1369      * - `tokenId` must exist.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _burn(uint256 tokenId) internal virtual {
1374         address owner = ERC721.ownerOf(tokenId);
1375 
1376         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1377 
1378         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1379         owner = ERC721.ownerOf(tokenId);
1380 
1381         // Clear approvals
1382         delete _tokenApprovals[tokenId];
1383 
1384         unchecked {
1385             // Cannot overflow, as that would require more tokens to be burned/transferred
1386             // out than the owner initially received through minting and transferring in.
1387             _balances[owner] -= 1;
1388         }
1389         delete _owners[tokenId];
1390 
1391         emit Transfer(owner, address(0), tokenId);
1392 
1393         _afterTokenTransfer(owner, address(0), tokenId, 1);
1394     }
1395 
1396     /**
1397      * @dev Transfers `tokenId` from `from` to `to`.
1398      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1399      *
1400      * Requirements:
1401      *
1402      * - `to` cannot be the zero address.
1403      * - `tokenId` token must be owned by `from`.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _transfer(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) internal virtual {
1412         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1413         require(to != address(0), "ERC721: transfer to the zero address");
1414 
1415         _beforeTokenTransfer(from, to, tokenId, 1);
1416 
1417         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1418         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1419 
1420         // Clear approvals from the previous owner
1421         delete _tokenApprovals[tokenId];
1422 
1423         unchecked {
1424             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1425             // `from`'s balance is the number of token held, which is at least one before the current
1426             // transfer.
1427             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1428             // all 2**256 token ids to be minted, which in practice is impossible.
1429             _balances[from] -= 1;
1430             _balances[to] += 1;
1431         }
1432         _owners[tokenId] = to;
1433 
1434         emit Transfer(from, to, tokenId);
1435 
1436         _afterTokenTransfer(from, to, tokenId, 1);
1437     }
1438 
1439     /**
1440      * @dev Approve `to` to operate on `tokenId`
1441      *
1442      * Emits an {Approval} event.
1443      */
1444     function _approve(address to, uint256 tokenId) internal virtual {
1445         _tokenApprovals[tokenId] = to;
1446         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1447     }
1448 
1449     /**
1450      * @dev Approve `operator` to operate on all of `owner` tokens
1451      *
1452      * Emits an {ApprovalForAll} event.
1453      */
1454     function _setApprovalForAll(
1455         address owner,
1456         address operator,
1457         bool approved
1458     ) internal virtual {
1459         require(owner != operator, "ERC721: approve to caller");
1460         _operatorApprovals[owner][operator] = approved;
1461         emit ApprovalForAll(owner, operator, approved);
1462     }
1463 
1464     /**
1465      * @dev Reverts if the `tokenId` has not been minted yet.
1466      */
1467     function _requireMinted(uint256 tokenId) internal view virtual {
1468         require(_exists(tokenId), "ERC721: invalid token ID");
1469     }
1470 
1471     /**
1472      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1473      * The call is not executed if the target address is not a contract.
1474      *
1475      * @param from address representing the previous owner of the given token ID
1476      * @param to target address that will receive the tokens
1477      * @param tokenId uint256 ID of the token to be transferred
1478      * @param data bytes optional data to send along with the call
1479      * @return bool whether the call correctly returned the expected magic value
1480      */
1481     function _checkOnERC721Received(
1482         address from,
1483         address to,
1484         uint256 tokenId,
1485         bytes memory data
1486     ) private returns (bool) {
1487         if (to.isContract()) {
1488             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1489                 return retval == IERC721Receiver.onERC721Received.selector;
1490             } catch (bytes memory reason) {
1491                 if (reason.length == 0) {
1492                     revert("ERC721: transfer to non ERC721Receiver implementer");
1493                 } else {
1494                     /// @solidity memory-safe-assembly
1495                     assembly {
1496                         revert(add(32, reason), mload(reason))
1497                     }
1498                 }
1499             }
1500         } else {
1501             return true;
1502         }
1503     }
1504 
1505     /**
1506      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1507      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1508      *
1509      * Calling conditions:
1510      *
1511      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1512      * - When `from` is zero, the tokens will be minted for `to`.
1513      * - When `to` is zero, ``from``'s tokens will be burned.
1514      * - `from` and `to` are never both zero.
1515      * - `batchSize` is non-zero.
1516      *
1517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1518      */
1519     function _beforeTokenTransfer(
1520         address from,
1521         address to,
1522         uint256, /* firstTokenId */
1523         uint256 batchSize
1524     ) internal virtual {
1525         if (batchSize > 1) {
1526             if (from != address(0)) {
1527                 _balances[from] -= batchSize;
1528             }
1529             if (to != address(0)) {
1530                 _balances[to] += batchSize;
1531             }
1532         }
1533     }
1534 
1535     /**
1536      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1537      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1538      *
1539      * Calling conditions:
1540      *
1541      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1542      * - When `from` is zero, the tokens were minted for `to`.
1543      * - When `to` is zero, ``from``'s tokens were burned.
1544      * - `from` and `to` are never both zero.
1545      * - `batchSize` is non-zero.
1546      *
1547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1548      */
1549     function _afterTokenTransfer(
1550         address from,
1551         address to,
1552         uint256 firstTokenId,
1553         uint256 batchSize
1554     ) internal virtual {}
1555 }
1556 
1557 
1558 // File erc721a/contracts/IERC721A.sol@v4.2.3
1559 
1560 
1561 // ERC721A Contracts v4.2.3
1562 // Creator: Chiru Labs
1563 
1564 pragma solidity ^0.8.4;
1565 
1566 /**
1567  * @dev Interface of ERC721A.
1568  */
1569 interface IERC721A {
1570     /**
1571      * The caller must own the token or be an approved operator.
1572      */
1573     error ApprovalCallerNotOwnerNorApproved();
1574 
1575     /**
1576      * The token does not exist.
1577      */
1578     error ApprovalQueryForNonexistentToken();
1579 
1580     /**
1581      * Cannot query the balance for the zero address.
1582      */
1583     error BalanceQueryForZeroAddress();
1584 
1585     /**
1586      * Cannot mint to the zero address.
1587      */
1588     error MintToZeroAddress();
1589 
1590     /**
1591      * The quantity of tokens minted must be more than zero.
1592      */
1593     error MintZeroQuantity();
1594 
1595     /**
1596      * The token does not exist.
1597      */
1598     error OwnerQueryForNonexistentToken();
1599 
1600     /**
1601      * The caller must own the token or be an approved operator.
1602      */
1603     error TransferCallerNotOwnerNorApproved();
1604 
1605     /**
1606      * The token must be owned by `from`.
1607      */
1608     error TransferFromIncorrectOwner();
1609 
1610     /**
1611      * Cannot safely transfer to a contract that does not implement the
1612      * ERC721Receiver interface.
1613      */
1614     error TransferToNonERC721ReceiverImplementer();
1615 
1616     /**
1617      * Cannot transfer to the zero address.
1618      */
1619     error TransferToZeroAddress();
1620 
1621     /**
1622      * The token does not exist.
1623      */
1624     error URIQueryForNonexistentToken();
1625 
1626     /**
1627      * The `quantity` minted with ERC2309 exceeds the safety limit.
1628      */
1629     error MintERC2309QuantityExceedsLimit();
1630 
1631     /**
1632      * The `extraData` cannot be set on an unintialized ownership slot.
1633      */
1634     error OwnershipNotInitializedForExtraData();
1635 
1636     // =============================================================
1637     //                            STRUCTS
1638     // =============================================================
1639 
1640     struct TokenOwnership {
1641         // The address of the owner.
1642         address addr;
1643         // Stores the start time of ownership with minimal overhead for tokenomics.
1644         uint64 startTimestamp;
1645         // Whether the token has been burned.
1646         bool burned;
1647         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1648         uint24 extraData;
1649     }
1650 
1651     // =============================================================
1652     //                         TOKEN COUNTERS
1653     // =============================================================
1654 
1655     /**
1656      * @dev Returns the total number of tokens in existence.
1657      * Burned tokens will reduce the count.
1658      * To get the total number of tokens minted, please see {_totalMinted}.
1659      */
1660     function totalSupply() external view returns (uint256);
1661 
1662     // =============================================================
1663     //                            IERC165
1664     // =============================================================
1665 
1666     /**
1667      * @dev Returns true if this contract implements the interface defined by
1668      * `interfaceId`. See the corresponding
1669      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1670      * to learn more about how these ids are created.
1671      *
1672      * This function call must use less than 30000 gas.
1673      */
1674     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1675 
1676     // =============================================================
1677     //                            IERC721
1678     // =============================================================
1679 
1680     /**
1681      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1682      */
1683     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1684 
1685     /**
1686      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1687      */
1688     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1689 
1690     /**
1691      * @dev Emitted when `owner` enables or disables
1692      * (`approved`) `operator` to manage all of its assets.
1693      */
1694     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1695 
1696     /**
1697      * @dev Returns the number of tokens in `owner`'s account.
1698      */
1699     function balanceOf(address owner) external view returns (uint256 balance);
1700 
1701     /**
1702      * @dev Returns the owner of the `tokenId` token.
1703      *
1704      * Requirements:
1705      *
1706      * - `tokenId` must exist.
1707      */
1708     function ownerOf(uint256 tokenId) external view returns (address owner);
1709 
1710     /**
1711      * @dev Safely transfers `tokenId` token from `from` to `to`,
1712      * checking first that contract recipients are aware of the ERC721 protocol
1713      * to prevent tokens from being forever locked.
1714      *
1715      * Requirements:
1716      *
1717      * - `from` cannot be the zero address.
1718      * - `to` cannot be the zero address.
1719      * - `tokenId` token must exist and be owned by `from`.
1720      * - If the caller is not `from`, it must be have been allowed to move
1721      * this token by either {approve} or {setApprovalForAll}.
1722      * - If `to` refers to a smart contract, it must implement
1723      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function safeTransferFrom(
1728         address from,
1729         address to,
1730         uint256 tokenId,
1731         bytes calldata data
1732     ) external payable;
1733 
1734     /**
1735      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1736      */
1737     function safeTransferFrom(
1738         address from,
1739         address to,
1740         uint256 tokenId
1741     ) external payable;
1742 
1743     /**
1744      * @dev Transfers `tokenId` from `from` to `to`.
1745      *
1746      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1747      * whenever possible.
1748      *
1749      * Requirements:
1750      *
1751      * - `from` cannot be the zero address.
1752      * - `to` cannot be the zero address.
1753      * - `tokenId` token must be owned by `from`.
1754      * - If the caller is not `from`, it must be approved to move this token
1755      * by either {approve} or {setApprovalForAll}.
1756      *
1757      * Emits a {Transfer} event.
1758      */
1759     function transferFrom(
1760         address from,
1761         address to,
1762         uint256 tokenId
1763     ) external payable;
1764 
1765     /**
1766      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1767      * The approval is cleared when the token is transferred.
1768      *
1769      * Only a single account can be approved at a time, so approving the
1770      * zero address clears previous approvals.
1771      *
1772      * Requirements:
1773      *
1774      * - The caller must own the token or be an approved operator.
1775      * - `tokenId` must exist.
1776      *
1777      * Emits an {Approval} event.
1778      */
1779     function approve(address to, uint256 tokenId) external payable;
1780 
1781     /**
1782      * @dev Approve or remove `operator` as an operator for the caller.
1783      * Operators can call {transferFrom} or {safeTransferFrom}
1784      * for any token owned by the caller.
1785      *
1786      * Requirements:
1787      *
1788      * - The `operator` cannot be the caller.
1789      *
1790      * Emits an {ApprovalForAll} event.
1791      */
1792     function setApprovalForAll(address operator, bool _approved) external;
1793 
1794     /**
1795      * @dev Returns the account approved for `tokenId` token.
1796      *
1797      * Requirements:
1798      *
1799      * - `tokenId` must exist.
1800      */
1801     function getApproved(uint256 tokenId) external view returns (address operator);
1802 
1803     /**
1804      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1805      *
1806      * See {setApprovalForAll}.
1807      */
1808     function isApprovedForAll(address owner, address operator) external view returns (bool);
1809 
1810     // =============================================================
1811     //                        IERC721Metadata
1812     // =============================================================
1813 
1814     /**
1815      * @dev Returns the token collection name.
1816      */
1817     function name() external view returns (string memory);
1818 
1819     /**
1820      * @dev Returns the token collection symbol.
1821      */
1822     function symbol() external view returns (string memory);
1823 
1824     /**
1825      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1826      */
1827     function tokenURI(uint256 tokenId) external view returns (string memory);
1828 
1829     // =============================================================
1830     //                           IERC2309
1831     // =============================================================
1832 
1833     /**
1834      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1835      * (inclusive) is transferred from `from` to `to`, as defined in the
1836      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1837      *
1838      * See {_mintERC2309} for more details.
1839      */
1840     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1841 }
1842 
1843 
1844 // File erc721a/contracts/ERC721A.sol@v4.2.3
1845 
1846 
1847 // ERC721A Contracts v4.2.3
1848 // Creator: Chiru Labs
1849 
1850 pragma solidity ^0.8.4;
1851 
1852 /**
1853  * @dev Interface of ERC721 token receiver.
1854  */
1855 interface ERC721A__IERC721Receiver {
1856     function onERC721Received(
1857         address operator,
1858         address from,
1859         uint256 tokenId,
1860         bytes calldata data
1861     ) external returns (bytes4);
1862 }
1863 
1864 /**
1865  * @title ERC721A
1866  *
1867  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1868  * Non-Fungible Token Standard, including the Metadata extension.
1869  * Optimized for lower gas during batch mints.
1870  *
1871  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1872  * starting from `_startTokenId()`.
1873  *
1874  * Assumptions:
1875  *
1876  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1877  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1878  */
1879 contract ERC721A is IERC721A {
1880     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1881     struct TokenApprovalRef {
1882         address value;
1883     }
1884 
1885     // =============================================================
1886     //                           CONSTANTS
1887     // =============================================================
1888 
1889     // Mask of an entry in packed address data.
1890     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1891 
1892     // The bit position of `numberMinted` in packed address data.
1893     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1894 
1895     // The bit position of `numberBurned` in packed address data.
1896     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1897 
1898     // The bit position of `aux` in packed address data.
1899     uint256 private constant _BITPOS_AUX = 192;
1900 
1901     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1902     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1903 
1904     // The bit position of `startTimestamp` in packed ownership.
1905     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1906 
1907     // The bit mask of the `burned` bit in packed ownership.
1908     uint256 private constant _BITMASK_BURNED = 1 << 224;
1909 
1910     // The bit position of the `nextInitialized` bit in packed ownership.
1911     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1912 
1913     // The bit mask of the `nextInitialized` bit in packed ownership.
1914     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1915 
1916     // The bit position of `extraData` in packed ownership.
1917     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1918 
1919     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1920     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1921 
1922     // The mask of the lower 160 bits for addresses.
1923     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1924 
1925     // The maximum `quantity` that can be minted with {_mintERC2309}.
1926     // This limit is to prevent overflows on the address data entries.
1927     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1928     // is required to cause an overflow, which is unrealistic.
1929     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1930 
1931     // The `Transfer` event signature is given by:
1932     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1933     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1934         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1935 
1936     // =============================================================
1937     //                            STORAGE
1938     // =============================================================
1939 
1940     // The next token ID to be minted.
1941     uint256 private _currentIndex;
1942 
1943     // The number of tokens burned.
1944     uint256 private _burnCounter;
1945 
1946     // Token name
1947     string private _name;
1948 
1949     // Token symbol
1950     string private _symbol;
1951 
1952     // Mapping from token ID to ownership details
1953     // An empty struct value does not necessarily mean the token is unowned.
1954     // See {_packedOwnershipOf} implementation for details.
1955     //
1956     // Bits Layout:
1957     // - [0..159]   `addr`
1958     // - [160..223] `startTimestamp`
1959     // - [224]      `burned`
1960     // - [225]      `nextInitialized`
1961     // - [232..255] `extraData`
1962     mapping(uint256 => uint256) private _packedOwnerships;
1963 
1964     // Mapping owner address to address data.
1965     //
1966     // Bits Layout:
1967     // - [0..63]    `balance`
1968     // - [64..127]  `numberMinted`
1969     // - [128..191] `numberBurned`
1970     // - [192..255] `aux`
1971     mapping(address => uint256) private _packedAddressData;
1972 
1973     // Mapping from token ID to approved address.
1974     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1975 
1976     // Mapping from owner to operator approvals
1977     mapping(address => mapping(address => bool)) private _operatorApprovals;
1978 
1979     // =============================================================
1980     //                          CONSTRUCTOR
1981     // =============================================================
1982 
1983     constructor(string memory name_, string memory symbol_) {
1984         _name = name_;
1985         _symbol = symbol_;
1986         _currentIndex = _startTokenId();
1987     }
1988 
1989     // =============================================================
1990     //                   TOKEN COUNTING OPERATIONS
1991     // =============================================================
1992 
1993     /**
1994      * @dev Returns the starting token ID.
1995      * To change the starting token ID, please override this function.
1996      */
1997     function _startTokenId() internal view virtual returns (uint256) {
1998         return 0;
1999     }
2000 
2001     /**
2002      * @dev Returns the next token ID to be minted.
2003      */
2004     function _nextTokenId() internal view virtual returns (uint256) {
2005         return _currentIndex;
2006     }
2007 
2008     /**
2009      * @dev Returns the total number of tokens in existence.
2010      * Burned tokens will reduce the count.
2011      * To get the total number of tokens minted, please see {_totalMinted}.
2012      */
2013     function totalSupply() public view virtual override returns (uint256) {
2014         // Counter underflow is impossible as _burnCounter cannot be incremented
2015         // more than `_currentIndex - _startTokenId()` times.
2016         unchecked {
2017             return _currentIndex - _burnCounter - _startTokenId();
2018         }
2019     }
2020 
2021     /**
2022      * @dev Returns the total amount of tokens minted in the contract.
2023      */
2024     function _totalMinted() internal view virtual returns (uint256) {
2025         // Counter underflow is impossible as `_currentIndex` does not decrement,
2026         // and it is initialized to `_startTokenId()`.
2027         unchecked {
2028             return _currentIndex - _startTokenId();
2029         }
2030     }
2031 
2032     /**
2033      * @dev Returns the total number of tokens burned.
2034      */
2035     function _totalBurned() internal view virtual returns (uint256) {
2036         return _burnCounter;
2037     }
2038 
2039     // =============================================================
2040     //                    ADDRESS DATA OPERATIONS
2041     // =============================================================
2042 
2043     /**
2044      * @dev Returns the number of tokens in `owner`'s account.
2045      */
2046     function balanceOf(address owner) public view virtual override returns (uint256) {
2047         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2048         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2049     }
2050 
2051     /**
2052      * Returns the number of tokens minted by `owner`.
2053      */
2054     function _numberMinted(address owner) internal view returns (uint256) {
2055         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2056     }
2057 
2058     /**
2059      * Returns the number of tokens burned by or on behalf of `owner`.
2060      */
2061     function _numberBurned(address owner) internal view returns (uint256) {
2062         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2063     }
2064 
2065     /**
2066      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2067      */
2068     function _getAux(address owner) internal view returns (uint64) {
2069         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2070     }
2071 
2072     /**
2073      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2074      * If there are multiple variables, please pack them into a uint64.
2075      */
2076     function _setAux(address owner, uint64 aux) internal virtual {
2077         uint256 packed = _packedAddressData[owner];
2078         uint256 auxCasted;
2079         // Cast `aux` with assembly to avoid redundant masking.
2080         assembly {
2081             auxCasted := aux
2082         }
2083         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2084         _packedAddressData[owner] = packed;
2085     }
2086 
2087     // =============================================================
2088     //                            IERC165
2089     // =============================================================
2090 
2091     /**
2092      * @dev Returns true if this contract implements the interface defined by
2093      * `interfaceId`. See the corresponding
2094      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2095      * to learn more about how these ids are created.
2096      *
2097      * This function call must use less than 30000 gas.
2098      */
2099     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2100         // The interface IDs are constants representing the first 4 bytes
2101         // of the XOR of all function selectors in the interface.
2102         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2103         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2104         return
2105             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2106             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2107             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2108     }
2109 
2110     // =============================================================
2111     //                        IERC721Metadata
2112     // =============================================================
2113 
2114     /**
2115      * @dev Returns the token collection name.
2116      */
2117     function name() public view virtual override returns (string memory) {
2118         return _name;
2119     }
2120 
2121     /**
2122      * @dev Returns the token collection symbol.
2123      */
2124     function symbol() public view virtual override returns (string memory) {
2125         return _symbol;
2126     }
2127 
2128     /**
2129      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2130      */
2131     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2132         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2133 
2134         string memory baseURI = _baseURI();
2135         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2136     }
2137 
2138     /**
2139      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2140      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2141      * by default, it can be overridden in child contracts.
2142      */
2143     function _baseURI() internal view virtual returns (string memory) {
2144         return '';
2145     }
2146 
2147     // =============================================================
2148     //                     OWNERSHIPS OPERATIONS
2149     // =============================================================
2150 
2151     /**
2152      * @dev Returns the owner of the `tokenId` token.
2153      *
2154      * Requirements:
2155      *
2156      * - `tokenId` must exist.
2157      */
2158     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2159         return address(uint160(_packedOwnershipOf(tokenId)));
2160     }
2161 
2162     /**
2163      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2164      * It gradually moves to O(1) as tokens get transferred around over time.
2165      */
2166     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2167         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2168     }
2169 
2170     /**
2171      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2172      */
2173     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2174         return _unpackedOwnership(_packedOwnerships[index]);
2175     }
2176 
2177     /**
2178      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2179      */
2180     function _initializeOwnershipAt(uint256 index) internal virtual {
2181         if (_packedOwnerships[index] == 0) {
2182             _packedOwnerships[index] = _packedOwnershipOf(index);
2183         }
2184     }
2185 
2186     /**
2187      * Returns the packed ownership data of `tokenId`.
2188      */
2189     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2190         uint256 curr = tokenId;
2191 
2192         unchecked {
2193             if (_startTokenId() <= curr)
2194                 if (curr < _currentIndex) {
2195                     uint256 packed = _packedOwnerships[curr];
2196                     // If not burned.
2197                     if (packed & _BITMASK_BURNED == 0) {
2198                         // Invariant:
2199                         // There will always be an initialized ownership slot
2200                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2201                         // before an unintialized ownership slot
2202                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2203                         // Hence, `curr` will not underflow.
2204                         //
2205                         // We can directly compare the packed value.
2206                         // If the address is zero, packed will be zero.
2207                         while (packed == 0) {
2208                             packed = _packedOwnerships[--curr];
2209                         }
2210                         return packed;
2211                     }
2212                 }
2213         }
2214         revert OwnerQueryForNonexistentToken();
2215     }
2216 
2217     /**
2218      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2219      */
2220     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2221         ownership.addr = address(uint160(packed));
2222         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2223         ownership.burned = packed & _BITMASK_BURNED != 0;
2224         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2225     }
2226 
2227     /**
2228      * @dev Packs ownership data into a single uint256.
2229      */
2230     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2231         assembly {
2232             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2233             owner := and(owner, _BITMASK_ADDRESS)
2234             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2235             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2236         }
2237     }
2238 
2239     /**
2240      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2241      */
2242     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2243         // For branchless setting of the `nextInitialized` flag.
2244         assembly {
2245             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2246             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2247         }
2248     }
2249 
2250     // =============================================================
2251     //                      APPROVAL OPERATIONS
2252     // =============================================================
2253 
2254     /**
2255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2256      * The approval is cleared when the token is transferred.
2257      *
2258      * Only a single account can be approved at a time, so approving the
2259      * zero address clears previous approvals.
2260      *
2261      * Requirements:
2262      *
2263      * - The caller must own the token or be an approved operator.
2264      * - `tokenId` must exist.
2265      *
2266      * Emits an {Approval} event.
2267      */
2268     function approve(address to, uint256 tokenId) public payable virtual override {
2269         address owner = ownerOf(tokenId);
2270 
2271         if (_msgSenderERC721A() != owner)
2272             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2273                 revert ApprovalCallerNotOwnerNorApproved();
2274             }
2275 
2276         _tokenApprovals[tokenId].value = to;
2277         emit Approval(owner, to, tokenId);
2278     }
2279 
2280     /**
2281      * @dev Returns the account approved for `tokenId` token.
2282      *
2283      * Requirements:
2284      *
2285      * - `tokenId` must exist.
2286      */
2287     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2288         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2289 
2290         return _tokenApprovals[tokenId].value;
2291     }
2292 
2293     /**
2294      * @dev Approve or remove `operator` as an operator for the caller.
2295      * Operators can call {transferFrom} or {safeTransferFrom}
2296      * for any token owned by the caller.
2297      *
2298      * Requirements:
2299      *
2300      * - The `operator` cannot be the caller.
2301      *
2302      * Emits an {ApprovalForAll} event.
2303      */
2304     function setApprovalForAll(address operator, bool approved) public virtual override {
2305         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2306         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2307     }
2308 
2309     /**
2310      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2311      *
2312      * See {setApprovalForAll}.
2313      */
2314     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2315         return _operatorApprovals[owner][operator];
2316     }
2317 
2318     /**
2319      * @dev Returns whether `tokenId` exists.
2320      *
2321      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2322      *
2323      * Tokens start existing when they are minted. See {_mint}.
2324      */
2325     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2326         return
2327             _startTokenId() <= tokenId &&
2328             tokenId < _currentIndex && // If within bounds,
2329             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2330     }
2331 
2332     /**
2333      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2334      */
2335     function _isSenderApprovedOrOwner(
2336         address approvedAddress,
2337         address owner,
2338         address msgSender
2339     ) private pure returns (bool result) {
2340         assembly {
2341             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2342             owner := and(owner, _BITMASK_ADDRESS)
2343             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2344             msgSender := and(msgSender, _BITMASK_ADDRESS)
2345             // `msgSender == owner || msgSender == approvedAddress`.
2346             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2347         }
2348     }
2349 
2350     /**
2351      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2352      */
2353     function _getApprovedSlotAndAddress(uint256 tokenId)
2354         private
2355         view
2356         returns (uint256 approvedAddressSlot, address approvedAddress)
2357     {
2358         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2359         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2360         assembly {
2361             approvedAddressSlot := tokenApproval.slot
2362             approvedAddress := sload(approvedAddressSlot)
2363         }
2364     }
2365 
2366     // =============================================================
2367     //                      TRANSFER OPERATIONS
2368     // =============================================================
2369 
2370     /**
2371      * @dev Transfers `tokenId` from `from` to `to`.
2372      *
2373      * Requirements:
2374      *
2375      * - `from` cannot be the zero address.
2376      * - `to` cannot be the zero address.
2377      * - `tokenId` token must be owned by `from`.
2378      * - If the caller is not `from`, it must be approved to move this token
2379      * by either {approve} or {setApprovalForAll}.
2380      *
2381      * Emits a {Transfer} event.
2382      */
2383     function transferFrom(
2384         address from,
2385         address to,
2386         uint256 tokenId
2387     ) public payable virtual override {
2388         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2389 
2390         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2391 
2392         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2393 
2394         // The nested ifs save around 20+ gas over a compound boolean condition.
2395         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2396             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2397 
2398         if (to == address(0)) revert TransferToZeroAddress();
2399 
2400         _beforeTokenTransfers(from, to, tokenId, 1);
2401 
2402         // Clear approvals from the previous owner.
2403         assembly {
2404             if approvedAddress {
2405                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2406                 sstore(approvedAddressSlot, 0)
2407             }
2408         }
2409 
2410         // Underflow of the sender's balance is impossible because we check for
2411         // ownership above and the recipient's balance can't realistically overflow.
2412         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2413         unchecked {
2414             // We can directly increment and decrement the balances.
2415             --_packedAddressData[from]; // Updates: `balance -= 1`.
2416             ++_packedAddressData[to]; // Updates: `balance += 1`.
2417 
2418             // Updates:
2419             // - `address` to the next owner.
2420             // - `startTimestamp` to the timestamp of transfering.
2421             // - `burned` to `false`.
2422             // - `nextInitialized` to `true`.
2423             _packedOwnerships[tokenId] = _packOwnershipData(
2424                 to,
2425                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2426             );
2427 
2428             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2429             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2430                 uint256 nextTokenId = tokenId + 1;
2431                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2432                 if (_packedOwnerships[nextTokenId] == 0) {
2433                     // If the next slot is within bounds.
2434                     if (nextTokenId != _currentIndex) {
2435                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2436                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2437                     }
2438                 }
2439             }
2440         }
2441 
2442         emit Transfer(from, to, tokenId);
2443         _afterTokenTransfers(from, to, tokenId, 1);
2444     }
2445 
2446     /**
2447      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2448      */
2449     function safeTransferFrom(
2450         address from,
2451         address to,
2452         uint256 tokenId
2453     ) public payable virtual override {
2454         safeTransferFrom(from, to, tokenId, '');
2455     }
2456 
2457     /**
2458      * @dev Safely transfers `tokenId` token from `from` to `to`.
2459      *
2460      * Requirements:
2461      *
2462      * - `from` cannot be the zero address.
2463      * - `to` cannot be the zero address.
2464      * - `tokenId` token must exist and be owned by `from`.
2465      * - If the caller is not `from`, it must be approved to move this token
2466      * by either {approve} or {setApprovalForAll}.
2467      * - If `to` refers to a smart contract, it must implement
2468      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2469      *
2470      * Emits a {Transfer} event.
2471      */
2472     function safeTransferFrom(
2473         address from,
2474         address to,
2475         uint256 tokenId,
2476         bytes memory _data
2477     ) public payable virtual override {
2478         transferFrom(from, to, tokenId);
2479         if (to.code.length != 0)
2480             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2481                 revert TransferToNonERC721ReceiverImplementer();
2482             }
2483     }
2484 
2485     /**
2486      * @dev Hook that is called before a set of serially-ordered token IDs
2487      * are about to be transferred. This includes minting.
2488      * And also called before burning one token.
2489      *
2490      * `startTokenId` - the first token ID to be transferred.
2491      * `quantity` - the amount to be transferred.
2492      *
2493      * Calling conditions:
2494      *
2495      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2496      * transferred to `to`.
2497      * - When `from` is zero, `tokenId` will be minted for `to`.
2498      * - When `to` is zero, `tokenId` will be burned by `from`.
2499      * - `from` and `to` are never both zero.
2500      */
2501     function _beforeTokenTransfers(
2502         address from,
2503         address to,
2504         uint256 startTokenId,
2505         uint256 quantity
2506     ) internal virtual {}
2507 
2508     /**
2509      * @dev Hook that is called after a set of serially-ordered token IDs
2510      * have been transferred. This includes minting.
2511      * And also called after one token has been burned.
2512      *
2513      * `startTokenId` - the first token ID to be transferred.
2514      * `quantity` - the amount to be transferred.
2515      *
2516      * Calling conditions:
2517      *
2518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2519      * transferred to `to`.
2520      * - When `from` is zero, `tokenId` has been minted for `to`.
2521      * - When `to` is zero, `tokenId` has been burned by `from`.
2522      * - `from` and `to` are never both zero.
2523      */
2524     function _afterTokenTransfers(
2525         address from,
2526         address to,
2527         uint256 startTokenId,
2528         uint256 quantity
2529     ) internal virtual {}
2530 
2531     /**
2532      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2533      *
2534      * `from` - Previous owner of the given token ID.
2535      * `to` - Target address that will receive the token.
2536      * `tokenId` - Token ID to be transferred.
2537      * `_data` - Optional data to send along with the call.
2538      *
2539      * Returns whether the call correctly returned the expected magic value.
2540      */
2541     function _checkContractOnERC721Received(
2542         address from,
2543         address to,
2544         uint256 tokenId,
2545         bytes memory _data
2546     ) private returns (bool) {
2547         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2548             bytes4 retval
2549         ) {
2550             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2551         } catch (bytes memory reason) {
2552             if (reason.length == 0) {
2553                 revert TransferToNonERC721ReceiverImplementer();
2554             } else {
2555                 assembly {
2556                     revert(add(32, reason), mload(reason))
2557                 }
2558             }
2559         }
2560     }
2561 
2562     // =============================================================
2563     //                        MINT OPERATIONS
2564     // =============================================================
2565 
2566     /**
2567      * @dev Mints `quantity` tokens and transfers them to `to`.
2568      *
2569      * Requirements:
2570      *
2571      * - `to` cannot be the zero address.
2572      * - `quantity` must be greater than 0.
2573      *
2574      * Emits a {Transfer} event for each mint.
2575      */
2576     function _mint(address to, uint256 quantity) internal virtual {
2577         uint256 startTokenId = _currentIndex;
2578         if (quantity == 0) revert MintZeroQuantity();
2579 
2580         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2581 
2582         // Overflows are incredibly unrealistic.
2583         // `balance` and `numberMinted` have a maximum limit of 2**64.
2584         // `tokenId` has a maximum limit of 2**256.
2585         unchecked {
2586             // Updates:
2587             // - `balance += quantity`.
2588             // - `numberMinted += quantity`.
2589             //
2590             // We can directly add to the `balance` and `numberMinted`.
2591             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2592 
2593             // Updates:
2594             // - `address` to the owner.
2595             // - `startTimestamp` to the timestamp of minting.
2596             // - `burned` to `false`.
2597             // - `nextInitialized` to `quantity == 1`.
2598             _packedOwnerships[startTokenId] = _packOwnershipData(
2599                 to,
2600                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2601             );
2602 
2603             uint256 toMasked;
2604             uint256 end = startTokenId + quantity;
2605 
2606             // Use assembly to loop and emit the `Transfer` event for gas savings.
2607             // The duplicated `log4` removes an extra check and reduces stack juggling.
2608             // The assembly, together with the surrounding Solidity code, have been
2609             // delicately arranged to nudge the compiler into producing optimized opcodes.
2610             assembly {
2611                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2612                 toMasked := and(to, _BITMASK_ADDRESS)
2613                 // Emit the `Transfer` event.
2614                 log4(
2615                     0, // Start of data (0, since no data).
2616                     0, // End of data (0, since no data).
2617                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2618                     0, // `address(0)`.
2619                     toMasked, // `to`.
2620                     startTokenId // `tokenId`.
2621                 )
2622 
2623                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2624                 // that overflows uint256 will make the loop run out of gas.
2625                 // The compiler will optimize the `iszero` away for performance.
2626                 for {
2627                     let tokenId := add(startTokenId, 1)
2628                 } iszero(eq(tokenId, end)) {
2629                     tokenId := add(tokenId, 1)
2630                 } {
2631                     // Emit the `Transfer` event. Similar to above.
2632                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2633                 }
2634             }
2635             if (toMasked == 0) revert MintToZeroAddress();
2636 
2637             _currentIndex = end;
2638         }
2639         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2640     }
2641 
2642     /**
2643      * @dev Mints `quantity` tokens and transfers them to `to`.
2644      *
2645      * This function is intended for efficient minting only during contract creation.
2646      *
2647      * It emits only one {ConsecutiveTransfer} as defined in
2648      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2649      * instead of a sequence of {Transfer} event(s).
2650      *
2651      * Calling this function outside of contract creation WILL make your contract
2652      * non-compliant with the ERC721 standard.
2653      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2654      * {ConsecutiveTransfer} event is only permissible during contract creation.
2655      *
2656      * Requirements:
2657      *
2658      * - `to` cannot be the zero address.
2659      * - `quantity` must be greater than 0.
2660      *
2661      * Emits a {ConsecutiveTransfer} event.
2662      */
2663     function _mintERC2309(address to, uint256 quantity) internal virtual {
2664         uint256 startTokenId = _currentIndex;
2665         if (to == address(0)) revert MintToZeroAddress();
2666         if (quantity == 0) revert MintZeroQuantity();
2667         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2668 
2669         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2670 
2671         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2672         unchecked {
2673             // Updates:
2674             // - `balance += quantity`.
2675             // - `numberMinted += quantity`.
2676             //
2677             // We can directly add to the `balance` and `numberMinted`.
2678             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2679 
2680             // Updates:
2681             // - `address` to the owner.
2682             // - `startTimestamp` to the timestamp of minting.
2683             // - `burned` to `false`.
2684             // - `nextInitialized` to `quantity == 1`.
2685             _packedOwnerships[startTokenId] = _packOwnershipData(
2686                 to,
2687                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2688             );
2689 
2690             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2691 
2692             _currentIndex = startTokenId + quantity;
2693         }
2694         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2695     }
2696 
2697     /**
2698      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2699      *
2700      * Requirements:
2701      *
2702      * - If `to` refers to a smart contract, it must implement
2703      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2704      * - `quantity` must be greater than 0.
2705      *
2706      * See {_mint}.
2707      *
2708      * Emits a {Transfer} event for each mint.
2709      */
2710     function _safeMint(
2711         address to,
2712         uint256 quantity,
2713         bytes memory _data
2714     ) internal virtual {
2715         _mint(to, quantity);
2716 
2717         unchecked {
2718             if (to.code.length != 0) {
2719                 uint256 end = _currentIndex;
2720                 uint256 index = end - quantity;
2721                 do {
2722                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2723                         revert TransferToNonERC721ReceiverImplementer();
2724                     }
2725                 } while (index < end);
2726                 // Reentrancy protection.
2727                 if (_currentIndex != end) revert();
2728             }
2729         }
2730     }
2731 
2732     /**
2733      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2734      */
2735     function _safeMint(address to, uint256 quantity) internal virtual {
2736         _safeMint(to, quantity, '');
2737     }
2738 
2739     // =============================================================
2740     //                        BURN OPERATIONS
2741     // =============================================================
2742 
2743     /**
2744      * @dev Equivalent to `_burn(tokenId, false)`.
2745      */
2746     function _burn(uint256 tokenId) internal virtual {
2747         _burn(tokenId, false);
2748     }
2749 
2750     /**
2751      * @dev Destroys `tokenId`.
2752      * The approval is cleared when the token is burned.
2753      *
2754      * Requirements:
2755      *
2756      * - `tokenId` must exist.
2757      *
2758      * Emits a {Transfer} event.
2759      */
2760     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2761         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2762 
2763         address from = address(uint160(prevOwnershipPacked));
2764 
2765         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2766 
2767         if (approvalCheck) {
2768             // The nested ifs save around 20+ gas over a compound boolean condition.
2769             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2770                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2771         }
2772 
2773         _beforeTokenTransfers(from, address(0), tokenId, 1);
2774 
2775         // Clear approvals from the previous owner.
2776         assembly {
2777             if approvedAddress {
2778                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2779                 sstore(approvedAddressSlot, 0)
2780             }
2781         }
2782 
2783         // Underflow of the sender's balance is impossible because we check for
2784         // ownership above and the recipient's balance can't realistically overflow.
2785         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2786         unchecked {
2787             // Updates:
2788             // - `balance -= 1`.
2789             // - `numberBurned += 1`.
2790             //
2791             // We can directly decrement the balance, and increment the number burned.
2792             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2793             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2794 
2795             // Updates:
2796             // - `address` to the last owner.
2797             // - `startTimestamp` to the timestamp of burning.
2798             // - `burned` to `true`.
2799             // - `nextInitialized` to `true`.
2800             _packedOwnerships[tokenId] = _packOwnershipData(
2801                 from,
2802                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2803             );
2804 
2805             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2806             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2807                 uint256 nextTokenId = tokenId + 1;
2808                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2809                 if (_packedOwnerships[nextTokenId] == 0) {
2810                     // If the next slot is within bounds.
2811                     if (nextTokenId != _currentIndex) {
2812                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2813                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2814                     }
2815                 }
2816             }
2817         }
2818 
2819         emit Transfer(from, address(0), tokenId);
2820         _afterTokenTransfers(from, address(0), tokenId, 1);
2821 
2822         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2823         unchecked {
2824             _burnCounter++;
2825         }
2826     }
2827 
2828     // =============================================================
2829     //                     EXTRA DATA OPERATIONS
2830     // =============================================================
2831 
2832     /**
2833      * @dev Directly sets the extra data for the ownership data `index`.
2834      */
2835     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2836         uint256 packed = _packedOwnerships[index];
2837         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2838         uint256 extraDataCasted;
2839         // Cast `extraData` with assembly to avoid redundant masking.
2840         assembly {
2841             extraDataCasted := extraData
2842         }
2843         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2844         _packedOwnerships[index] = packed;
2845     }
2846 
2847     /**
2848      * @dev Called during each token transfer to set the 24bit `extraData` field.
2849      * Intended to be overridden by the cosumer contract.
2850      *
2851      * `previousExtraData` - the value of `extraData` before transfer.
2852      *
2853      * Calling conditions:
2854      *
2855      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2856      * transferred to `to`.
2857      * - When `from` is zero, `tokenId` will be minted for `to`.
2858      * - When `to` is zero, `tokenId` will be burned by `from`.
2859      * - `from` and `to` are never both zero.
2860      */
2861     function _extraData(
2862         address from,
2863         address to,
2864         uint24 previousExtraData
2865     ) internal view virtual returns (uint24) {}
2866 
2867     /**
2868      * @dev Returns the next extra data for the packed ownership data.
2869      * The returned result is shifted into position.
2870      */
2871     function _nextExtraData(
2872         address from,
2873         address to,
2874         uint256 prevOwnershipPacked
2875     ) private view returns (uint256) {
2876         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2877         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2878     }
2879 
2880     // =============================================================
2881     //                       OTHER OPERATIONS
2882     // =============================================================
2883 
2884     /**
2885      * @dev Returns the message sender (defaults to `msg.sender`).
2886      *
2887      * If you are writing GSN compatible contracts, you need to override this function.
2888      */
2889     function _msgSenderERC721A() internal view virtual returns (address) {
2890         return msg.sender;
2891     }
2892 
2893     /**
2894      * @dev Converts a uint256 to its ASCII string decimal representation.
2895      */
2896     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2897         assembly {
2898             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2899             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2900             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2901             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2902             let m := add(mload(0x40), 0xa0)
2903             // Update the free memory pointer to allocate.
2904             mstore(0x40, m)
2905             // Assign the `str` to the end.
2906             str := sub(m, 0x20)
2907             // Zeroize the slot after the string.
2908             mstore(str, 0)
2909 
2910             // Cache the end of the memory to calculate the length later.
2911             let end := str
2912 
2913             // We write the string from rightmost digit to leftmost digit.
2914             // The following is essentially a do-while loop that also handles the zero case.
2915             // prettier-ignore
2916             for { let temp := value } 1 {} {
2917                 str := sub(str, 1)
2918                 // Write the character to the pointer.
2919                 // The ASCII index of the '0' character is 48.
2920                 mstore8(str, add(48, mod(temp, 10)))
2921                 // Keep dividing `temp` until zero.
2922                 temp := div(temp, 10)
2923                 // prettier-ignore
2924                 if iszero(temp) { break }
2925             }
2926 
2927             let length := sub(end, str)
2928             // Move the pointer 32 bytes leftwards to make room for the length.
2929             str := sub(str, 0x20)
2930             // Store the length.
2931             mstore(str, length)
2932         }
2933     }
2934 }
2935 
2936 
2937 // File contracts/SSRWives.sol
2938 
2939 
2940 
2941 pragma solidity ^0.8.17;
2942 
2943 
2944 
2945 contract SSRWives is ERC721A, Ownable {
2946     uint256 public mintPrice = 0.07 ether;
2947     uint256 public friendMintPrice = 0.06 ether;
2948     bool public saleIsActive = false;
2949     bool public friendMintIsActive = false;
2950 
2951     uint256 public maxPerAddressDuringMint = 10;
2952     string private _baseTokenURI;
2953     uint256 public maxSupply = 3210;
2954 
2955     uint256 public amountClaimed = 0;
2956     uint256 public amountFreeMint = 250;
2957 
2958     uint256 public amountFriendClaimed = 0;
2959     uint256 public amountFriendMint = 250;
2960 
2961     mapping(address => bool) public mintedFree;
2962 
2963     address kyokoWallet = 0x3893E707eF23AD48C89d4af55d289a61f42A2535;
2964     address artWallet = 0xf7fb1039790311032c153cC65dbfD2A9FB0d84E5;
2965     address devWallet = 0xaA642262bdf212D7a111c16D7a9691F9cC1dDe37;
2966 
2967     constructor() ERC721A("SSR Wives", "SSRWIVES") {}
2968 
2969     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
2970         _safeMint(msg.sender, numberOfTokens);
2971         require(totalSupply() <= maxSupply, "Limit reached");
2972     }
2973 
2974     function flipSaleState() public onlyOwner {
2975         saleIsActive = !saleIsActive;
2976     }
2977 
2978     function flipFreeMintState() public onlyOwner {
2979         friendMintIsActive = !friendMintIsActive;
2980     }
2981 
2982     function setMintPrice(uint256 newPrice) public onlyOwner {
2983         mintPrice = newPrice;
2984     }
2985 
2986     function setAmountFreeMint(uint256 newAmount) public onlyOwner {
2987         amountFreeMint = newAmount;
2988     }
2989 
2990     function setMaxSupply(uint256 newAmount) public onlyOwner {
2991         maxSupply = newAmount;
2992     }
2993 
2994     function _baseURI() internal view virtual override returns (string memory) {
2995         return _baseTokenURI;
2996     }
2997 
2998     function setBaseURI(string calldata baseURI) external onlyOwner {
2999         _baseTokenURI = baseURI;
3000     }
3001 
3002     function mint(uint256 quantity) external payable {
3003         require(saleIsActive, "Sale must be active to mint");
3004         require(
3005             quantity <= maxPerAddressDuringMint,
3006             "You can't mint that many at once"
3007         );
3008 
3009         require(
3010             mintPrice * quantity <= msg.value,
3011             "Ether value sent is not correct"
3012         );
3013 
3014         _mint(msg.sender, quantity);
3015         require(totalSupply() <= maxSupply, "Limit reached");
3016     }
3017 
3018     function friendMint(uint256 quantity) external payable {
3019         require(saleIsActive, "Sale must be active to mint");
3020         require(
3021             amountFriendClaimed < amountFriendMint,
3022             "No more free mints available"
3023         );
3024         require(
3025             isAFriend(msg.sender),
3026             "This wallet doesn't hold any friend NFTs"
3027         );
3028 
3029         amountFriendClaimed += 1;
3030 
3031         require(
3032             friendMintPrice * quantity <= msg.value,
3033             "Ether value sent is not correct"
3034         );
3035 
3036         _mint(msg.sender, quantity);
3037         require(totalSupply() <= maxSupply, "Limit reached");
3038     }
3039 
3040     function friendFreeMint() external payable {
3041         require(friendMintIsActive, "Sale must be active to mint");
3042 
3043         require(
3044             amountClaimed < amountFreeMint,
3045             "No more discounted mints available"
3046         );
3047 
3048         require(
3049             isAFriend(msg.sender),
3050             "This wallet doesn't hold any friend NFTs"
3051         );
3052         require(
3053             mintedFree[msg.sender] == false,
3054             "You can only mint 1 for free"
3055         );
3056 
3057         amountClaimed += 1;
3058         mintedFree[msg.sender] = true;
3059         _mint(msg.sender, 1);
3060 
3061         require(totalSupply() <= maxSupply, "Limit reached");
3062     }
3063 
3064     function isAFriend(address addr) public view returns (bool) {
3065         address milady = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
3066         address pfpplus = 0x181cde16170fac94c27584492cc9842e2Cb3BD54;
3067         address remilio = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
3068         address pixelady = 0x8Fc0D90f2C45a5e7f94904075c952e0943CFCCfd;
3069         address radbro = 0xABCDB5710B88f456fED1e99025379e2969F29610;
3070         address schizo = 0xBfE47D6D4090940D1c7a0066B63d23875E3e2Ac5;
3071         address mifairy = 0x67B5eE6e29a4230177Dda07AD7848e42d89cF9a0;
3072 
3073         return
3074             ERC721(milady).balanceOf(addr) > 0 ||
3075             ERC721(pfpplus).balanceOf(addr) > 0 ||
3076             ERC721(remilio).balanceOf(addr) > 0 ||
3077             ERC721(pixelady).balanceOf(addr) > 0 ||
3078             ERC721(radbro).balanceOf(addr) > 0 ||
3079             ERC721(milady).balanceOf(addr) > 0 ||
3080             ERC721(schizo).balanceOf(addr) > 0 ||
3081             ERC721(mifairy).balanceOf(addr) > 0;
3082     }
3083 
3084     function withdrawMoney() external onlyOwner {
3085         (bool success, ) = owner().call{value: address(this).balance}("");
3086         require(success, "Transfer failed.");
3087     }
3088 
3089     function withdrawAll() public payable onlyOwner {
3090         uint256 third = address(this).balance / 3;
3091 
3092         require(payable(devWallet).send(third));
3093         require(payable(kyokoWallet).send(third));
3094         require(payable(artWallet).send(third));
3095     }
3096 }