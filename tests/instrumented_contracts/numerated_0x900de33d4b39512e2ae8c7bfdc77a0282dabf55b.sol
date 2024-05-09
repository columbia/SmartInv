1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
101 /**
102  * @dev Contract module that helps prevent reentrant calls to a function.
103  *
104  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
105  * available, which can be applied to functions to make sure there are no nested
106  * (reentrant) calls to them.
107  *
108  * Note that because there is a single `nonReentrant` guard, functions marked as
109  * `nonReentrant` may not call one another. This can be worked around by making
110  * those functions `private`, and then adding `external` `nonReentrant` entry
111  * points to them.
112  *
113  * TIP: If you would like to learn more about reentrancy and alternative ways
114  * to protect against it, check out our blog post
115  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
116  */
117 abstract contract ReentrancyGuard {
118     // Booleans are more expensive than uint256 or any type that takes up a full
119     // word because each write operation emits an extra SLOAD to first read the
120     // slot's contents, replace the bits taken up by the boolean, and then write
121     // back. This is the compiler's defense against contract upgrades and
122     // pointer aliasing, and it cannot be disabled.
123 
124     // The values being non-zero value makes deployment a bit more expensive,
125     // but in exchange the refund on every call to nonReentrant will be lower in
126     // amount. Since refunds are capped to a percentage of the total
127     // transaction's gas, it is best to keep them low in cases like this one, to
128     // increase the likelihood of the full refund coming into effect.
129     uint256 private constant _NOT_ENTERED = 1;
130     uint256 private constant _ENTERED = 2;
131 
132     uint256 private _status;
133 
134     constructor() {
135         _status = _NOT_ENTERED;
136     }
137 
138     /**
139      * @dev Prevents a contract from calling itself, directly or indirectly.
140      * Calling a `nonReentrant` function from another `nonReentrant`
141      * function is not supported. It is possible to prevent this from happening
142      * by making the `nonReentrant` function external, and making it call a
143      * `private` function that does the actual work.
144      */
145     modifier nonReentrant() {
146         // On the first call to nonReentrant, _notEntered will be true
147         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
148 
149         // Any calls to nonReentrant after this point will fail
150         _status = _ENTERED;
151 
152         _;
153 
154         // By storing the original value once again, a refund is triggered (see
155         // https://eips.ethereum.org/EIPS/eip-2200)
156         _status = _NOT_ENTERED;
157     }
158 }
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 /**
163  * @dev String operations.
164  */
165 library Strings {
166     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
170      */
171     function toString(uint256 value) internal pure returns (string memory) {
172         // Inspired by OraclizeAPI's implementation - MIT licence
173         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
174 
175         if (value == 0) {
176             return "0";
177         }
178         uint256 temp = value;
179         uint256 digits;
180         while (temp != 0) {
181             digits++;
182             temp /= 10;
183         }
184         bytes memory buffer = new bytes(digits);
185         while (value != 0) {
186             digits -= 1;
187             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
188             value /= 10;
189         }
190         return string(buffer);
191     }
192 
193     /**
194      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
195      */
196     function toHexString(uint256 value) internal pure returns (string memory) {
197         if (value == 0) {
198             return "0x00";
199         }
200         uint256 temp = value;
201         uint256 length = 0;
202         while (temp != 0) {
203             length++;
204             temp >>= 8;
205         }
206         return toHexString(value, length);
207     }
208 
209     /**
210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
211      */
212     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
213         bytes memory buffer = new bytes(2 * length + 2);
214         buffer[0] = "0";
215         buffer[1] = "x";
216         for (uint256 i = 2 * length + 1; i > 1; --i) {
217             buffer[i] = _HEX_SYMBOLS[value & 0xf];
218             value >>= 4;
219         }
220         require(value == 0, "Strings: hex length insufficient");
221         return string(buffer);
222     }
223 }
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
227 // CAUTION
228 // This version of SafeMath should only be used with Solidity 0.8 or later,
229 // because it relies on the compiler's built in overflow checks.
230 /**
231  * @dev Wrappers over Solidity's arithmetic operations.
232  *
233  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
234  * now has built in overflow checking.
235  */
236 library SafeMath {
237     /**
238      * @dev Returns the addition of two unsigned integers, with an overflow flag.
239      *
240      * _Available since v3.4._
241      */
242     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
243         unchecked {
244             uint256 c = a + b;
245             if (c < a) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     /**
251      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
252      *
253      * _Available since v3.4._
254      */
255     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b > a) return (false, 0);
258             return (true, a - b);
259         }
260     }
261 
262     /**
263      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
264      *
265      * _Available since v3.4._
266      */
267     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270             // benefit is lost if 'b' is also tested.
271             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272             if (a == 0) return (true, 0);
273             uint256 c = a * b;
274             if (c / a != b) return (false, 0);
275             return (true, c);
276         }
277     }
278 
279     /**
280      * @dev Returns the division of two unsigned integers, with a division by zero flag.
281      *
282      * _Available since v3.4._
283      */
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
293      *
294      * _Available since v3.4._
295      */
296     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             if (b == 0) return (false, 0);
299             return (true, a % b);
300         }
301     }
302 
303     /**
304      * @dev Returns the addition of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `+` operator.
308      *
309      * Requirements:
310      *
311      * - Addition cannot overflow.
312      */
313     function add(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a + b;
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a - b;
329     }
330 
331     /**
332      * @dev Returns the multiplication of two unsigned integers, reverting on
333      * overflow.
334      *
335      * Counterpart to Solidity's `*` operator.
336      *
337      * Requirements:
338      *
339      * - Multiplication cannot overflow.
340      */
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a * b;
343     }
344 
345     /**
346      * @dev Returns the integer division of two unsigned integers, reverting on
347      * division by zero. The result is rounded towards zero.
348      *
349      * Counterpart to Solidity's `/` operator.
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function div(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a / b;
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * reverting when dividing by zero.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a % b;
373     }
374 
375     /**
376      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
377      * overflow (when the result is negative).
378      *
379      * CAUTION: This function is deprecated because it requires allocating memory for the error
380      * message unnecessarily. For custom revert reasons use {trySub}.
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      *
386      * - Subtraction cannot overflow.
387      */
388     function sub(
389         uint256 a,
390         uint256 b,
391         string memory errorMessage
392     ) internal pure returns (uint256) {
393         unchecked {
394             require(b <= a, errorMessage);
395             return a - b;
396         }
397     }
398 
399     /**
400      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
401      * division by zero. The result is rounded towards zero.
402      *
403      * Counterpart to Solidity's `/` operator. Note: this function uses a
404      * `revert` opcode (which leaves remaining gas untouched) while Solidity
405      * uses an invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      *
409      * - The divisor cannot be zero.
410      */
411     function div(
412         uint256 a,
413         uint256 b,
414         string memory errorMessage
415     ) internal pure returns (uint256) {
416         unchecked {
417             require(b > 0, errorMessage);
418             return a / b;
419         }
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * reverting with custom message when dividing by zero.
425      *
426      * CAUTION: This function is deprecated because it requires allocating memory for the error
427      * message unnecessarily. For custom revert reasons use {tryMod}.
428      *
429      * Counterpart to Solidity's `%` operator. This function uses a `revert`
430      * opcode (which leaves remaining gas untouched) while Solidity uses an
431      * invalid opcode to revert (consuming all remaining gas).
432      *
433      * Requirements:
434      *
435      * - The divisor cannot be zero.
436      */
437     function mod(
438         uint256 a,
439         uint256 b,
440         string memory errorMessage
441     ) internal pure returns (uint256) {
442         unchecked {
443             require(b > 0, errorMessage);
444             return a % b;
445         }
446     }
447 }
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
451 /**
452  * @dev Collection of functions related to the address type
453  */
454 library Address {
455     /**
456      * @dev Returns true if `account` is a contract.
457      *
458      * [IMPORTANT]
459      * ====
460      * It is unsafe to assume that an address for which this function returns
461      * false is an externally-owned account (EOA) and not a contract.
462      *
463      * Among others, `isContract` will return false for the following
464      * types of addresses:
465      *
466      *  - an externally-owned account
467      *  - a contract in construction
468      *  - an address where a contract will be created
469      *  - an address where a contract lived, but was destroyed
470      * ====
471      */
472     function isContract(address account) internal view returns (bool) {
473         // This method relies on extcodesize, which returns 0 for contracts in
474         // construction, since the code is only stored at the end of the
475         // constructor execution.
476 
477         uint256 size;
478         assembly {
479             size := extcodesize(account)
480         }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
666 /**
667  * @dev Interface of the ERC165 standard, as defined in the
668  * https://eips.ethereum.org/EIPS/eip-165[EIP].
669  *
670  * Implementers can declare support of contract interfaces, which can then be
671  * queried by others ({ERC165Checker}).
672  *
673  * For an implementation, see {ERC165}.
674  */
675 interface IERC165 {
676     /**
677      * @dev Returns true if this contract implements the interface defined by
678      * `interfaceId`. See the corresponding
679      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
680      * to learn more about how these ids are created.
681      *
682      * This function call must use less than 30 000 gas.
683      */
684     function supportsInterface(bytes4 interfaceId) external view returns (bool);
685 }
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
689 /**
690  * @dev Required interface of an ERC721 compliant contract.
691  */
692 interface IERC721 is IERC165 {
693     /**
694      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
695      */
696     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
697 
698     /**
699      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
700      */
701     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
702 
703     /**
704      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
705      */
706     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
707 
708     /**
709      * @dev Returns the number of tokens in ``owner``'s account.
710      */
711     function balanceOf(address owner) external view returns (uint256 balance);
712 
713     /**
714      * @dev Returns the owner of the `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function ownerOf(uint256 tokenId) external view returns (address owner);
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
724      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must exist and be owned by `from`.
731      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) external;
741 
742     /**
743      * @dev Transfers `tokenId` token from `from` to `to`.
744      *
745      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must be owned by `from`.
752      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
753      *
754      * Emits a {Transfer} event.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) external;
761 
762     /**
763      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
764      * The approval is cleared when the token is transferred.
765      *
766      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
767      *
768      * Requirements:
769      *
770      * - The caller must own the token or be an approved operator.
771      * - `tokenId` must exist.
772      *
773      * Emits an {Approval} event.
774      */
775     function approve(address to, uint256 tokenId) external;
776 
777     /**
778      * @dev Returns the account approved for `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function getApproved(uint256 tokenId) external view returns (address operator);
785 
786     /**
787      * @dev Approve or remove `operator` as an operator for the caller.
788      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
789      *
790      * Requirements:
791      *
792      * - The `operator` cannot be the caller.
793      *
794      * Emits an {ApprovalForAll} event.
795      */
796     function setApprovalForAll(address operator, bool _approved) external;
797 
798     /**
799      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
800      *
801      * See {setApprovalForAll}
802      */
803     function isApprovedForAll(address owner, address operator) external view returns (bool);
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes calldata data
823     ) external;
824 }
825 
826 
827 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
828 /**
829  * @title ERC721 token receiver interface
830  * @dev Interface for any contract that wants to support safeTransfers
831  * from ERC721 asset contracts.
832  */
833 interface IERC721Receiver {
834     /**
835      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
836      * by `operator` from `from`, this function is called.
837      *
838      * It must return its Solidity selector to confirm the token transfer.
839      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
840      *
841      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
842      */
843     function onERC721Received(
844         address operator,
845         address from,
846         uint256 tokenId,
847         bytes calldata data
848     ) external returns (bytes4);
849 }
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
853 /**
854  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
855  * @dev See https://eips.ethereum.org/EIPS/eip-721
856  */
857 interface IERC721Metadata is IERC721 {
858     /**
859      * @dev Returns the token collection name.
860      */
861     function name() external view returns (string memory);
862 
863     /**
864      * @dev Returns the token collection symbol.
865      */
866     function symbol() external view returns (string memory);
867 
868     /**
869      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
870      */
871     function tokenURI(uint256 tokenId) external view returns (string memory);
872 }
873 
874 
875 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
876 /**
877  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
878  * @dev See https://eips.ethereum.org/EIPS/eip-721
879  */
880 interface IERC721Enumerable is IERC721 {
881     /**
882      * @dev Returns the total amount of tokens stored by the contract.
883      */
884     function totalSupply() external view returns (uint256);
885 
886     /**
887      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
888      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
889      */
890     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
891 
892     /**
893      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
894      * Use along with {totalSupply} to enumerate all tokens.
895      */
896     function tokenByIndex(uint256 index) external view returns (uint256);
897 }
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
901 /**
902  * @dev Implementation of the {IERC165} interface.
903  *
904  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
905  * for the additional interface id that will be supported. For example:
906  *
907  * ```solidity
908  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
910  * }
911  * ```
912  *
913  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
914  */
915 abstract contract ERC165 is IERC165 {
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
920         return interfaceId == type(IERC165).interfaceId;
921     }
922 }
923 
924 
925 // Creator: Chiru Labs
926 /**
927  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
928  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
929  *
930  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
931  *
932  * Does not support burning tokens to address(0).
933  *
934  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
935  */
936 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
937     using Address for address;
938     using Strings for uint256;
939 
940     struct TokenOwnership {
941         address addr;
942         uint64 startTimestamp;
943     }
944 
945     struct AddressData {
946         uint128 balance;
947         uint128 numberMinted;
948     }
949 
950     uint256 internal currentIndex = 0;
951 
952     // Token name
953     string private _name;
954 
955     // Token symbol
956     string private _symbol;
957 
958     // Mapping from token ID to ownership details
959     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
960     mapping(uint256 => TokenOwnership) internal _ownerships;
961 
962     // Mapping owner address to address data
963     mapping(address => AddressData) private _addressData;
964 
965     // Mapping from token ID to approved address
966     mapping(uint256 => address) private _tokenApprovals;
967 
968     // Mapping from owner to operator approvals
969     mapping(address => mapping(address => bool)) private _operatorApprovals;
970 
971     constructor(string memory name_, string memory symbol_) {
972         _name = name_;
973         _symbol = symbol_;
974     }
975 
976     /**
977      * @dev See {IERC721Enumerable-totalSupply}.
978      */
979     function totalSupply() public view override returns (uint256) {
980         return currentIndex;
981     }
982 
983     /**
984      * @dev See {IERC721Enumerable-tokenByIndex}.
985      */
986     function tokenByIndex(uint256 index) public view override returns (uint256) {
987         require(index < totalSupply(), 'ERC721A: global index out of bounds');
988         return index;
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
993      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
994      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
995      */
996     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
997         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
998         uint256 numMintedSoFar = totalSupply();
999         uint256 tokenIdsIdx = 0;
1000         address currOwnershipAddr = address(0);
1001         for (uint256 i = 0; i < numMintedSoFar; i++) {
1002             TokenOwnership memory ownership = _ownerships[i];
1003             if (ownership.addr != address(0)) {
1004                 currOwnershipAddr = ownership.addr;
1005             }
1006             if (currOwnershipAddr == owner) {
1007                 if (tokenIdsIdx == index) {
1008                     return i;
1009                 }
1010                 tokenIdsIdx++;
1011             }
1012         }
1013         revert('ERC721A: unable to get token of owner by index');
1014     }
1015 
1016     /**
1017      * @dev See {IERC165-supportsInterface}.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1020         return
1021             interfaceId == type(IERC721).interfaceId ||
1022             interfaceId == type(IERC721Metadata).interfaceId ||
1023             interfaceId == type(IERC721Enumerable).interfaceId ||
1024             super.supportsInterface(interfaceId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-balanceOf}.
1029      */
1030     function balanceOf(address owner) public view override returns (uint256) {
1031         require(owner != address(0), 'ERC721A: balance query for the zero address');
1032         return uint256(_addressData[owner].balance);
1033     }
1034 
1035     function _numberMinted(address owner) internal view returns (uint256) {
1036         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1037         return uint256(_addressData[owner].numberMinted);
1038     }
1039 
1040     /**
1041      * Gas spent here starts off proportional to the maximum mint batch size.
1042      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1043      */
1044     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1045         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1046 
1047         for (uint256 curr = tokenId; ; curr--) {
1048             TokenOwnership memory ownership = _ownerships[curr];
1049             if (ownership.addr != address(0)) {
1050                 return ownership;
1051             }
1052         }
1053 
1054         revert('ERC721A: unable to determine the owner of token');
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-ownerOf}.
1059      */
1060     function ownerOf(uint256 tokenId) public view override returns (address) {
1061         return ownershipOf(tokenId).addr;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Metadata-name}.
1066      */
1067     function name() public view virtual override returns (string memory) {
1068         return _name;
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Metadata-symbol}.
1073      */
1074     function symbol() public view virtual override returns (string memory) {
1075         return _symbol;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-tokenURI}.
1080      */
1081     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1082         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1083 
1084         string memory baseURI = _baseURI();
1085         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1086     }
1087 
1088     /**
1089      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1090      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1091      * by default, can be overriden in child contracts.
1092      */
1093     function _baseURI() internal view virtual returns (string memory) {
1094         return '';
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-approve}.
1099      */
1100     function approve(address to, uint256 tokenId) public override {
1101         address owner = ERC721A.ownerOf(tokenId);
1102         require(to != owner, 'ERC721A: approval to current owner');
1103 
1104         require(
1105             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1106             'ERC721A: approve caller is not owner nor approved for all'
1107         );
1108 
1109         _approve(to, tokenId, owner);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-getApproved}.
1114      */
1115     function getApproved(uint256 tokenId) public view override returns (address) {
1116         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1117 
1118         return _tokenApprovals[tokenId];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-setApprovalForAll}.
1123      */
1124     function setApprovalForAll(address operator, bool approved) public override {
1125         require(operator != _msgSender(), 'ERC721A: approve to caller');
1126 
1127         _operatorApprovals[_msgSender()][operator] = approved;
1128         emit ApprovalForAll(_msgSender(), operator, approved);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-isApprovedForAll}.
1133      */
1134     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1135         return _operatorApprovals[owner][operator];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-transferFrom}.
1140      */
1141     function transferFrom(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) public override {
1146         _transfer(from, to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-safeTransferFrom}.
1151      */
1152     function safeTransferFrom(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) public override {
1157         safeTransferFrom(from, to, tokenId, '');
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-safeTransferFrom}.
1162      */
1163     function safeTransferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) public override {
1169         _transfer(from, to, tokenId);
1170         require(
1171             _checkOnERC721Received(from, to, tokenId, _data),
1172             'ERC721A: transfer to non ERC721Receiver implementer'
1173         );
1174     }
1175 
1176     /**
1177      * @dev Returns whether `tokenId` exists.
1178      *
1179      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1180      *
1181      * Tokens start existing when they are minted (`_mint`),
1182      */
1183     function _exists(uint256 tokenId) internal view returns (bool) {
1184         return tokenId < currentIndex;
1185     }
1186 
1187     function _safeMint(address to, uint256 quantity) internal {
1188         _safeMint(to, quantity, '');
1189     }
1190 
1191     /**
1192      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1197      * - `quantity` must be greater than 0.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _safeMint(
1202         address to,
1203         uint256 quantity,
1204         bytes memory _data
1205     ) internal {
1206         _mint(to, quantity, _data, true);
1207     }
1208 
1209     /**
1210      * @dev Mints `quantity` tokens and transfers them to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _mint(
1220         address to,
1221         uint256 quantity,
1222         bytes memory _data,
1223         bool safe
1224     ) internal {
1225         uint256 startTokenId = currentIndex;
1226         require(to != address(0), 'ERC721A: mint to the zero address');
1227         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1228         require(!_exists(startTokenId), 'ERC721A: token already minted');
1229         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
1230 
1231         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1232 
1233         _addressData[to].balance += uint128(quantity);
1234         _addressData[to].numberMinted += uint128(quantity);
1235 
1236         _ownerships[startTokenId].addr = to;
1237         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1238 
1239         uint256 updatedIndex = startTokenId;
1240 
1241         for (uint256 i = 0; i < quantity; i++) {
1242             emit Transfer(address(0), to, updatedIndex);
1243             if (safe) {
1244                 require(
1245                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1246                     'ERC721A: transfer to non ERC721Receiver implementer'
1247                 );
1248             }
1249             updatedIndex++;
1250         }
1251 
1252         currentIndex = updatedIndex;
1253         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1254     }
1255 
1256     /**
1257      * @dev Transfers `tokenId` from `from` to `to`.
1258      *
1259      * Requirements:
1260      *
1261      * - `to` cannot be the zero address.
1262      * - `tokenId` token must be owned by `from`.
1263      *
1264      * Emits a {Transfer} event.
1265      */
1266     function _transfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) private {
1271         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1272 
1273         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1274             getApproved(tokenId) == _msgSender() ||
1275             isApprovedForAll(prevOwnership.addr, _msgSender()));
1276 
1277         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1278 
1279         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1280         require(to != address(0), 'ERC721A: transfer to the zero address');
1281 
1282         _beforeTokenTransfers(from, to, tokenId, 1);
1283 
1284         // Clear approvals from the previous owner
1285         _approve(address(0), tokenId, prevOwnership.addr);
1286 
1287         // Underflow of the sender's balance is impossible because we check for
1288         // ownership above and the recipient's balance can't realistically overflow.
1289         unchecked {
1290             _addressData[from].balance -= 1;
1291             _addressData[to].balance += 1;
1292         }
1293 
1294         _ownerships[tokenId].addr = to;
1295         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1296 
1297         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1298         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1299         uint256 nextTokenId = tokenId + 1;
1300         if (_ownerships[nextTokenId].addr == address(0)) {
1301             if (_exists(nextTokenId)) {
1302                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1303                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1304             }
1305         }
1306 
1307         emit Transfer(from, to, tokenId);
1308         _afterTokenTransfers(from, to, tokenId, 1);
1309     }
1310 
1311     /**
1312      * @dev Approve `to` to operate on `tokenId`
1313      *
1314      * Emits a {Approval} event.
1315      */
1316     function _approve(
1317         address to,
1318         uint256 tokenId,
1319         address owner
1320     ) private {
1321         _tokenApprovals[tokenId] = to;
1322         emit Approval(owner, to, tokenId);
1323     }
1324 
1325     /**
1326      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1327      * The call is not executed if the target address is not a contract.
1328      *
1329      * @param from address representing the previous owner of the given token ID
1330      * @param to target address that will receive the tokens
1331      * @param tokenId uint256 ID of the token to be transferred
1332      * @param _data bytes optional data to send along with the call
1333      * @return bool whether the call correctly returned the expected magic value
1334      */
1335     function _checkOnERC721Received(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) private returns (bool) {
1341         if (to.isContract()) {
1342             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1343                 return retval == IERC721Receiver(to).onERC721Received.selector;
1344             } catch (bytes memory reason) {
1345                 if (reason.length == 0) {
1346                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1347                 } else {
1348                     assembly {
1349                         revert(add(32, reason), mload(reason))
1350                     }
1351                 }
1352             }
1353         } else {
1354             return true;
1355         }
1356     }
1357 
1358     /**
1359      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1360      *
1361      * startTokenId - the first token id to be transferred
1362      * quantity - the amount to be transferred
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` will be minted for `to`.
1369      */
1370     function _beforeTokenTransfers(
1371         address from,
1372         address to,
1373         uint256 startTokenId,
1374         uint256 quantity
1375     ) internal virtual {}
1376 
1377     /**
1378      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1379      * minting.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - when `from` and `to` are both non-zero.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _afterTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 }
1396 
1397 
1398 contract KevinZukiClub is Ownable, ERC721A, ReentrancyGuard {
1399     using SafeMath for uint256;
1400     using Strings for uint256;
1401     using Address for address;
1402 
1403     string public azuKevinBaseURI;
1404     bool public saleIsActive;
1405     bool public isMetadataLocked;
1406 
1407     uint256 public constant MAX_TOKEN_SUPPLY = 2222;
1408     uint256 public constant MAX_MINT_QUANTITY = 5;
1409 
1410     constructor(string memory _initialBaseURI, bool _saleIsActive)
1411         ERC721A("KevinZuki Club", "KZC")
1412     {
1413         azuKevinBaseURI = _initialBaseURI;
1414         saleIsActive = _saleIsActive;
1415         isMetadataLocked = false;
1416     }
1417 
1418     modifier quantityIsOk(uint256 amount) {
1419         require(
1420             amount > 0 && amount <= MAX_MINT_QUANTITY,
1421             "Can only mint 5 tokens at a time."
1422         );
1423         require(
1424             totalSupply().add(amount) <= MAX_TOKEN_SUPPLY,
1425             "Minting would exceed max supply."
1426         );
1427         _;
1428     }
1429 
1430     modifier saleActive() {
1431         require(saleIsActive, "Sale is not active.");
1432         _;
1433     }
1434 
1435     function flipSaleState() public onlyOwner {
1436         saleIsActive = !saleIsActive;
1437     }
1438 
1439     function mint(uint256 amount)
1440         public
1441         saleActive
1442         nonReentrant
1443         quantityIsOk(amount)
1444     {
1445         _safeMint(msg.sender, amount);
1446     }
1447 
1448     function _baseURI() internal view virtual override returns (string memory) {
1449         return azuKevinBaseURI;
1450     }
1451 
1452     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1453         require(!isMetadataLocked, "Metadata is locked");
1454         azuKevinBaseURI = _newBaseURI;
1455     }
1456 
1457     function tokenURI(uint256 tokenId)
1458         public
1459         view
1460         virtual
1461         override
1462         returns (string memory)
1463     {
1464         require(
1465             _exists(tokenId),
1466             "ERC721Metadata: URI query for nonexistent token"
1467         );
1468 
1469         string memory base = _baseURI();
1470 
1471         return string(abi.encodePacked(base, tokenId.toString()));
1472     }
1473 
1474     function lockMetadata() external onlyOwner {
1475         isMetadataLocked = true;
1476     }
1477 }