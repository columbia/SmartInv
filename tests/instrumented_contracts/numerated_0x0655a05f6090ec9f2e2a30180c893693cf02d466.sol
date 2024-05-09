1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
101  * now has built in overflow checking.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             uint256 c = a + b;
112             if (c < a) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b > a) return (false, 0);
125             return (true, a - b);
126         }
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137             // benefit is lost if 'b' is also tested.
138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139             if (a == 0) return (true, 0);
140             uint256 c = a * b;
141             if (c / a != b) return (false, 0);
142             return (true, c);
143         }
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a / b);
155         }
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a % b);
167         }
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a + b;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a * b;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator.
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a / b;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * reverting when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b <= a, errorMessage);
262             return a - b;
263         }
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a / b;
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Strings.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev String operations.
325  */
326 library Strings {
327     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
331      */
332     function toString(uint256 value) internal pure returns (string memory) {
333         // Inspired by OraclizeAPI's implementation - MIT licence
334         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
335 
336         if (value == 0) {
337             return "0";
338         }
339         uint256 temp = value;
340         uint256 digits;
341         while (temp != 0) {
342             digits++;
343             temp /= 10;
344         }
345         bytes memory buffer = new bytes(digits);
346         while (value != 0) {
347             digits -= 1;
348             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
349             value /= 10;
350         }
351         return string(buffer);
352     }
353 
354     /**
355      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
356      */
357     function toHexString(uint256 value) internal pure returns (string memory) {
358         if (value == 0) {
359             return "0x00";
360         }
361         uint256 temp = value;
362         uint256 length = 0;
363         while (temp != 0) {
364             length++;
365             temp >>= 8;
366         }
367         return toHexString(value, length);
368     }
369 
370     /**
371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
372      */
373     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
374         bytes memory buffer = new bytes(2 * length + 2);
375         buffer[0] = "0";
376         buffer[1] = "x";
377         for (uint256 i = 2 * length + 1; i > 1; --i) {
378             buffer[i] = _HEX_SYMBOLS[value & 0xf];
379             value >>= 4;
380         }
381         require(value == 0, "Strings: hex length insufficient");
382         return string(buffer);
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/Context.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/access/Ownable.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership}.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be applied to your functions to restrict their use to
431  * the owner.
432  */
433 abstract contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor() {
442         _transferOwnership(_msgSender());
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view virtual returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(owner() == _msgSender(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         _transferOwnership(address(0));
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         _transferOwnership(newOwner);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Internal function without access restriction.
483      */
484     function _transferOwnership(address newOwner) internal virtual {
485         address oldOwner = _owner;
486         _owner = newOwner;
487         emit OwnershipTransferred(oldOwner, newOwner);
488     }
489 }
490 
491 // File: @openzeppelin/contracts/utils/Address.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Collection of functions related to the address type
500  */
501 library Address {
502     /**
503      * @dev Returns true if `account` is a contract.
504      *
505      * [IMPORTANT]
506      * ====
507      * It is unsafe to assume that an address for which this function returns
508      * false is an externally-owned account (EOA) and not a contract.
509      *
510      * Among others, `isContract` will return false for the following
511      * types of addresses:
512      *
513      *  - an externally-owned account
514      *  - a contract in construction
515      *  - an address where a contract will be created
516      *  - an address where a contract lived, but was destroyed
517      * ====
518      */
519     function isContract(address account) internal view returns (bool) {
520         // This method relies on extcodesize, which returns 0 for contracts in
521         // construction, since the code is only stored at the end of the
522         // constructor execution.
523 
524         uint256 size;
525         assembly {
526             size := extcodesize(account)
527         }
528         return size > 0;
529     }
530 
531     /**
532      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
533      * `recipient`, forwarding all available gas and reverting on errors.
534      *
535      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
536      * of certain opcodes, possibly making contracts go over the 2300 gas limit
537      * imposed by `transfer`, making them unable to receive funds via
538      * `transfer`. {sendValue} removes this limitation.
539      *
540      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
541      *
542      * IMPORTANT: because control is transferred to `recipient`, care must be
543      * taken to not create reentrancy vulnerabilities. Consider using
544      * {ReentrancyGuard} or the
545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
546      */
547     function sendValue(address payable recipient, uint256 amount) internal {
548         require(address(this).balance >= amount, "Address: insufficient balance");
549 
550         (bool success, ) = recipient.call{value: amount}("");
551         require(success, "Address: unable to send value, recipient may have reverted");
552     }
553 
554     /**
555      * @dev Performs a Solidity function call using a low level `call`. A
556      * plain `call` is an unsafe replacement for a function call: use this
557      * function instead.
558      *
559      * If `target` reverts with a revert reason, it is bubbled up by this
560      * function (like regular Solidity function calls).
561      *
562      * Returns the raw returned data. To convert to the expected return value,
563      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
564      *
565      * Requirements:
566      *
567      * - `target` must be a contract.
568      * - calling `target` with `data` must not revert.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionCall(target, data, "Address: low-level call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
578      * `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, 0, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but also transferring `value` wei to `target`.
593      *
594      * Requirements:
595      *
596      * - the calling contract must have an ETH balance of at least `value`.
597      * - the called Solidity function must be `payable`.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value
605     ) internal returns (bytes memory) {
606         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
611      * with `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCallWithValue(
616         address target,
617         bytes memory data,
618         uint256 value,
619         string memory errorMessage
620     ) internal returns (bytes memory) {
621         require(address(this).balance >= value, "Address: insufficient balance for call");
622         require(isContract(target), "Address: call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.call{value: value}(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
635         return functionStaticCall(target, data, "Address: low-level static call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.staticcall(data);
652         return verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
662         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal returns (bytes memory) {
676         require(isContract(target), "Address: delegate call to non-contract");
677 
678         (bool success, bytes memory returndata) = target.delegatecall(data);
679         return verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
684      * revert reason using the provided one.
685      *
686      * _Available since v4.3._
687      */
688     function verifyCallResult(
689         bool success,
690         bytes memory returndata,
691         string memory errorMessage
692     ) internal pure returns (bytes memory) {
693         if (success) {
694             return returndata;
695         } else {
696             // Look for revert reason and bubble it up if present
697             if (returndata.length > 0) {
698                 // The easiest way to bubble the revert reason is using memory via assembly
699 
700                 assembly {
701                     let returndata_size := mload(returndata)
702                     revert(add(32, returndata), returndata_size)
703                 }
704             } else {
705                 revert(errorMessage);
706             }
707         }
708     }
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @title ERC721 token receiver interface
720  * @dev Interface for any contract that wants to support safeTransfers
721  * from ERC721 asset contracts.
722  */
723 interface IERC721Receiver {
724     /**
725      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
726      * by `operator` from `from`, this function is called.
727      *
728      * It must return its Solidity selector to confirm the token transfer.
729      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
730      *
731      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
732      */
733     function onERC721Received(
734         address operator,
735         address from,
736         uint256 tokenId,
737         bytes calldata data
738     ) external returns (bytes4);
739 }
740 
741 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
742 
743 
744 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @dev Interface of the ERC165 standard, as defined in the
750  * https://eips.ethereum.org/EIPS/eip-165[EIP].
751  *
752  * Implementers can declare support of contract interfaces, which can then be
753  * queried by others ({ERC165Checker}).
754  *
755  * For an implementation, see {ERC165}.
756  */
757 interface IERC165 {
758     /**
759      * @dev Returns true if this contract implements the interface defined by
760      * `interfaceId`. See the corresponding
761      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
762      * to learn more about how these ids are created.
763      *
764      * This function call must use less than 30 000 gas.
765      */
766     function supportsInterface(bytes4 interfaceId) external view returns (bool);
767 }
768 
769 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @dev Implementation of the {IERC165} interface.
779  *
780  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
781  * for the additional interface id that will be supported. For example:
782  *
783  * ```solidity
784  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
786  * }
787  * ```
788  *
789  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
790  */
791 abstract contract ERC165 is IERC165 {
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
796         return interfaceId == type(IERC165).interfaceId;
797     }
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
801 
802 
803 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 /**
809  * @dev Required interface of an ERC721 compliant contract.
810  */
811 interface IERC721 is IERC165 {
812     /**
813      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
814      */
815     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
816 
817     /**
818      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
819      */
820     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
821 
822     /**
823      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
824      */
825     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
826 
827     /**
828      * @dev Returns the number of tokens in ``owner``'s account.
829      */
830     function balanceOf(address owner) external view returns (uint256 balance);
831 
832     /**
833      * @dev Returns the owner of the `tokenId` token.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function ownerOf(uint256 tokenId) external view returns (address owner);
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must exist and be owned by `from`.
850      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Transfers `tokenId` token from `from` to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must be owned by `from`.
871      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
872      *
873      * Emits a {Transfer} event.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) external;
880 
881     /**
882      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
883      * The approval is cleared when the token is transferred.
884      *
885      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
886      *
887      * Requirements:
888      *
889      * - The caller must own the token or be an approved operator.
890      * - `tokenId` must exist.
891      *
892      * Emits an {Approval} event.
893      */
894     function approve(address to, uint256 tokenId) external;
895 
896     /**
897      * @dev Returns the account approved for `tokenId` token.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      */
903     function getApproved(uint256 tokenId) external view returns (address operator);
904 
905     /**
906      * @dev Approve or remove `operator` as an operator for the caller.
907      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
908      *
909      * Requirements:
910      *
911      * - The `operator` cannot be the caller.
912      *
913      * Emits an {ApprovalForAll} event.
914      */
915     function setApprovalForAll(address operator, bool _approved) external;
916 
917     /**
918      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
919      *
920      * See {setApprovalForAll}
921      */
922     function isApprovedForAll(address owner, address operator) external view returns (bool);
923 
924     /**
925      * @dev Safely transfers `tokenId` token from `from` to `to`.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must exist and be owned by `from`.
932      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes calldata data
942     ) external;
943 }
944 
945 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
946 
947 
948 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
949 
950 pragma solidity ^0.8.0;
951 
952 
953 /**
954  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
955  * @dev See https://eips.ethereum.org/EIPS/eip-721
956  */
957 interface IERC721Enumerable is IERC721 {
958     /**
959      * @dev Returns the total amount of tokens stored by the contract.
960      */
961     function totalSupply() external view returns (uint256);
962 
963     /**
964      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
965      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
968 
969     /**
970      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
971      * Use along with {totalSupply} to enumerate all tokens.
972      */
973     function tokenByIndex(uint256 index) external view returns (uint256);
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
977 
978 
979 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 
984 /**
985  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
986  * @dev See https://eips.ethereum.org/EIPS/eip-721
987  */
988 interface IERC721Metadata is IERC721 {
989     /**
990      * @dev Returns the token collection name.
991      */
992     function name() external view returns (string memory);
993 
994     /**
995      * @dev Returns the token collection symbol.
996      */
997     function symbol() external view returns (string memory);
998 
999     /**
1000      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1001      */
1002     function tokenURI(uint256 tokenId) external view returns (string memory);
1003 }
1004 
1005 // File: contracts/ERC721a.sol
1006 
1007 
1008 // Creators: locationtba.eth, 2pmflow.eth
1009 
1010 pragma solidity ^0.8.10;
1011 
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 /**
1021  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1022  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1023  *
1024  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1025  *
1026  * Does not support burning tokens to address(0).
1027  */
1028 contract ERC721A is
1029   Context,
1030   ERC165,
1031   IERC721,
1032   IERC721Metadata,
1033   IERC721Enumerable
1034 {
1035   using Address for address;
1036   using Strings for uint256;
1037 
1038   struct TokenOwnership {
1039     address addr;
1040     uint64 startTimestamp;
1041   }
1042 
1043   struct AddressData {
1044     uint128 balance;
1045     uint128 numberMinted;
1046   }
1047 
1048   uint256 private currentIndex = 0; //save 15000gas starting at 1
1049 
1050   uint256 public immutable maxBatchSize;
1051 
1052   // Token name
1053   string private _name;
1054 
1055   // Token symbol
1056   string private _symbol;
1057 
1058   // Mapping from token ID to ownership details
1059   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1060   mapping(uint256 => TokenOwnership) private _ownerships;
1061 
1062   // Mapping owner address to address data
1063   mapping(address => AddressData) private _addressData;
1064 
1065   // Mapping from token ID to approved address
1066   mapping(uint256 => address) private _tokenApprovals;
1067 
1068   // Mapping from owner to operator approvals
1069   mapping(address => mapping(address => bool)) private _operatorApprovals;
1070 
1071   /**
1072    * @dev
1073    * `maxBatchSize` refers to how much a minter can mint at a time.
1074    */
1075   constructor(
1076     string memory name_,
1077     string memory symbol_,
1078     uint256 maxBatchSize_
1079   ) {
1080     require(maxBatchSize_ > 0, "ERC721A: size must be nonzero");
1081     _name = name_;
1082     _symbol = symbol_;
1083     maxBatchSize = maxBatchSize_;
1084   }
1085 
1086   /**
1087    * @dev See {IERC721Enumerable-totalSupply}.
1088    */
1089   function totalSupply() public view override returns (uint256) {
1090     return currentIndex;
1091   }
1092 
1093   /**
1094    * @dev See {IERC721Enumerable-tokenByIndex}.
1095    */
1096   function tokenByIndex(uint256 index) public view override returns (uint256) {
1097     require(index < totalSupply(), "ERC721A: index out of bounds");
1098     return index;
1099   }
1100 
1101   /**
1102    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1103    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1104    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1105    */
1106   function tokenOfOwnerByIndex(address owner, uint256 index)
1107     public
1108     view
1109     override
1110     returns (uint256)
1111   {
1112     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1113     uint256 numMintedSoFar = totalSupply();
1114     uint256 tokenIdsIdx = 0;
1115     address currOwnershipAddr = address(0);
1116     for (uint256 i = 0; i < numMintedSoFar; i++) {
1117       TokenOwnership memory ownership = _ownerships[i];
1118       if (ownership.addr != address(0)) {
1119         currOwnershipAddr = ownership.addr;
1120       }
1121       if (currOwnershipAddr == owner) {
1122         if (tokenIdsIdx == index) {
1123           return i;
1124         }
1125         tokenIdsIdx++;
1126       }
1127     }
1128     revert("ERC721A: unable to get");
1129   }
1130 
1131   /**
1132    * @dev See {IERC165-supportsInterface}.
1133    */
1134   function supportsInterface(bytes4 interfaceId)
1135     public
1136     view
1137     virtual
1138     override(ERC165, IERC165)
1139     returns (bool)
1140   {
1141     return
1142       interfaceId == type(IERC721).interfaceId ||
1143       interfaceId == type(IERC721Metadata).interfaceId ||
1144       interfaceId == type(IERC721Enumerable).interfaceId ||
1145       super.supportsInterface(interfaceId);
1146   }
1147 
1148   /**
1149    * @dev See {IERC721-balanceOf}.
1150    */
1151   function balanceOf(address owner) public view override returns (uint256) {
1152     require(owner != address(0), "ERC721A: query for 0 addy");
1153     return uint256(_addressData[owner].balance);
1154   }
1155 
1156   function _numberMinted(address owner) internal view returns (uint256) {
1157     require(
1158       owner != address(0),
1159       "ERC721A: number mints for 0 addy"
1160     );
1161     return uint256(_addressData[owner].numberMinted);
1162   }
1163 
1164   function ownershipOf(uint256 tokenId)
1165     internal
1166     view
1167     returns (TokenOwnership memory)
1168   {
1169     require(_exists(tokenId), "ERC721A: nonexistent token");
1170 
1171     uint256 lowestTokenToCheck;
1172     if (tokenId >= maxBatchSize) {
1173       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1174     }
1175 
1176     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1177       TokenOwnership memory ownership = _ownerships[curr];
1178       if (ownership.addr != address(0)) {
1179         return ownership;
1180       }
1181     }
1182 
1183     revert("ERC721A: unable to find owner");
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-ownerOf}.
1188    */
1189   function ownerOf(uint256 tokenId) public view override returns (address) {
1190     return ownershipOf(tokenId).addr;
1191   }
1192 
1193   /**
1194    * @dev See {IERC721Metadata-name}.
1195    */
1196   function name() public view virtual override returns (string memory) {
1197     return _name;
1198   }
1199 
1200   /**
1201    * @dev See {IERC721Metadata-symbol}.
1202    */
1203   function symbol() public view virtual override returns (string memory) {
1204     return _symbol;
1205   }
1206 
1207   /**
1208    * @dev See {IERC721Metadata-tokenURI}.
1209    */
1210   function tokenURI(uint256 tokenId)
1211     public
1212     view
1213     virtual
1214     override
1215     returns (string memory)
1216   {
1217     require(
1218       _exists(tokenId),
1219       "ERC721Metadata: URI query for nonexistent token"
1220     );
1221 
1222     string memory baseURI = _baseURI();
1223     return
1224       bytes(baseURI).length > 0
1225         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1226         : "";
1227   }
1228 
1229   /**
1230    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1231    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1232    * by default, can be overriden in child contracts.
1233    */
1234   function _baseURI() internal view virtual returns (string memory) {
1235     return "";
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-approve}.
1240    */
1241   function approve(address to, uint256 tokenId) public override {
1242     address owner = ERC721A.ownerOf(tokenId);
1243     require(to != owner, "ERC721A: approval current owner");
1244 
1245     require(
1246       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1247       "ERC721A: approve caller is not owner nor approved for all"
1248     );
1249 
1250     _approve(to, tokenId, owner);
1251   }
1252 
1253   /**
1254    * @dev See {IERC721-getApproved}.
1255    */
1256   function getApproved(uint256 tokenId) public view override returns (address) {
1257     require(_exists(tokenId), "ERC721A: approved nonexistent");
1258 
1259     return _tokenApprovals[tokenId];
1260   }
1261 
1262   /**
1263    * @dev See {IERC721-setApprovalForAll}.
1264    */
1265   function setApprovalForAll(address operator, bool approved) public override {
1266     require(operator != _msgSender(), "ERC721A: approve to caller");
1267 
1268     _operatorApprovals[_msgSender()][operator] = approved;
1269     emit ApprovalForAll(_msgSender(), operator, approved);
1270   }
1271 
1272   /**
1273    * @dev See {IERC721-isApprovedForAll}.
1274    */
1275   function isApprovedForAll(address owner, address operator)
1276     public
1277     view
1278     virtual
1279     override
1280     returns (bool)
1281   {
1282     return _operatorApprovals[owner][operator];
1283   }
1284 
1285   /**
1286    * @dev See {IERC721-transferFrom}.
1287    */
1288   function transferFrom(
1289     address from,
1290     address to,
1291     uint256 tokenId
1292   ) public override {
1293     _transfer(from, to, tokenId);
1294   }
1295 
1296   /**
1297    * @dev See {IERC721-safeTransferFrom}.
1298    */
1299   function safeTransferFrom(
1300     address from,
1301     address to,
1302     uint256 tokenId
1303   ) public override {
1304     safeTransferFrom(from, to, tokenId, "");
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-safeTransferFrom}.
1309    */
1310   function safeTransferFrom(
1311     address from,
1312     address to,
1313     uint256 tokenId,
1314     bytes memory _data
1315   ) public override {
1316     _transfer(from, to, tokenId);
1317     require(
1318       _checkOnERC721Received(from, to, tokenId, _data),
1319       "ERC721A: transfer to non ERC721Receiver implementer"
1320     );
1321   }
1322 
1323   /**
1324    * @dev Returns whether `tokenId` exists.
1325    *
1326    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1327    *
1328    * Tokens start existing when they are minted (`_mint`),
1329    */
1330   function _exists(uint256 tokenId) internal view returns (bool) {
1331     return tokenId < currentIndex;
1332   }
1333 
1334   function _safeMint(address to, uint256 quantity) internal {
1335     _safeMint(to, quantity, "");
1336   }
1337 
1338   /**
1339    * @dev Mints `quantity` tokens and transfers them to `to`.
1340    *
1341    * Requirements:
1342    *
1343    * - `to` cannot be the zero address.
1344    * - `quantity` cannot be larger than the max batch size.
1345    *
1346    * Emits a {Transfer} event.
1347    */
1348   function _safeMint(
1349     address to,
1350     uint256 quantity,
1351     bytes memory _data
1352   ) internal {
1353     uint256 startTokenId = currentIndex;
1354     require(to != address(0), "ERC721A: mint to the 0 addy");
1355     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1356     require(!_exists(startTokenId), "ERC721A: token already minted");
1357     require(quantity <= maxBatchSize, "ERC721A: quantity mint too high");
1358 
1359     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1360 
1361     AddressData memory addressData = _addressData[to];
1362     _addressData[to] = AddressData(
1363       addressData.balance + uint128(quantity),
1364       addressData.numberMinted + uint128(quantity)
1365     );
1366     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1367 
1368     uint256 updatedIndex = startTokenId;
1369 
1370     for (uint256 i = 0; i < quantity; i++) {
1371       emit Transfer(address(0), to, updatedIndex);
1372       require(
1373         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1374         "ERC721A: transfer to non ERC721Receiver implementer"
1375       );
1376       updatedIndex++;
1377     }
1378 
1379     currentIndex = updatedIndex;
1380     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1381   }
1382 
1383   /**
1384    * @dev Transfers `tokenId` from `from` to `to`.
1385    *
1386    * Requirements:
1387    *
1388    * - `to` cannot be the zero address.
1389    * - `tokenId` token must be owned by `from`.
1390    *
1391    * Emits a {Transfer} event.
1392    */
1393   function _transfer(
1394     address from,
1395     address to,
1396     uint256 tokenId
1397   ) private {
1398     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1399 
1400     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1401       getApproved(tokenId) == _msgSender() ||
1402       isApprovedForAll(prevOwnership.addr, _msgSender()));
1403 
1404     require(
1405       isApprovedOrOwner,
1406       "ERC721A: transfer caller is not owner nor approved"
1407     );
1408 
1409     require(
1410       prevOwnership.addr == from,
1411       "ERC721A: transfer from incorrect owner"
1412     );
1413     require(to != address(0), "ERC721A: transfer to 0 addy");
1414 
1415     _beforeTokenTransfers(from, to, tokenId, 1);
1416 
1417     // Clear approvals from the previous owner
1418     _approve(address(0), tokenId, prevOwnership.addr);
1419 
1420     _addressData[from].balance -= 1;
1421     _addressData[to].balance += 1;
1422     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1423 
1424     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1425     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1426     uint256 nextTokenId = tokenId + 1;
1427     if (_ownerships[nextTokenId].addr == address(0)) {
1428       if (_exists(nextTokenId)) {
1429         _ownerships[nextTokenId] = TokenOwnership(
1430           prevOwnership.addr,
1431           prevOwnership.startTimestamp
1432         );
1433       }
1434     }
1435 
1436     emit Transfer(from, to, tokenId);
1437     _afterTokenTransfers(from, to, tokenId, 1);
1438   }
1439 
1440   /**
1441    * @dev Approve `to` to operate on `tokenId`
1442    *
1443    * Emits a {Approval} event.
1444    */
1445   function _approve(
1446     address to,
1447     uint256 tokenId,
1448     address owner
1449   ) private {
1450     _tokenApprovals[tokenId] = to;
1451     emit Approval(owner, to, tokenId);
1452   }
1453 
1454   uint256 public nextOwnerToExplicitlySet = 0;
1455 
1456   /**
1457    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1458    */
1459   function _setOwnersExplicit(uint256 quantity) internal {
1460     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1461     require(quantity > 0, "quantity must be nonzero");
1462     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1463     if (endIndex > currentIndex - 1) {
1464       endIndex = currentIndex - 1;
1465     }
1466     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1467     require(_exists(endIndex), "not enough minted yet for this cleanup");
1468     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1469       if (_ownerships[i].addr == address(0)) {
1470         TokenOwnership memory ownership = ownershipOf(i);
1471         _ownerships[i] = TokenOwnership(
1472           ownership.addr,
1473           ownership.startTimestamp
1474         );
1475       }
1476     }
1477     nextOwnerToExplicitlySet = endIndex + 1;
1478   }
1479 
1480   /**
1481    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1482    * The call is not executed if the target address is not a contract.
1483    *
1484    * @param from address representing the previous owner of the given token ID
1485    * @param to target address that will receive the tokens
1486    * @param tokenId uint256 ID of the token to be transferred
1487    * @param _data bytes optional data to send along with the call
1488    * @return bool whether the call correctly returned the expected magic value
1489    */
1490   function _checkOnERC721Received(
1491     address from,
1492     address to,
1493     uint256 tokenId,
1494     bytes memory _data
1495   ) private returns (bool) {
1496     if (to.isContract()) {
1497       try
1498         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1499       returns (bytes4 retval) {
1500         return retval == IERC721Receiver(to).onERC721Received.selector;
1501       } catch (bytes memory reason) {
1502         if (reason.length == 0) {
1503           revert("ERC721A: transfer to non ERC721Receiver implementer");
1504         } else {
1505           assembly {
1506             revert(add(32, reason), mload(reason))
1507           }
1508         }
1509       }
1510     } else {
1511       return true;
1512     }
1513   }
1514 
1515   /**
1516    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1517    *
1518    * startTokenId - the first token id to be transferred
1519    * quantity - the amount to be transferred
1520    *
1521    * Calling conditions:
1522    *
1523    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1524    * transferred to `to`.
1525    * - When `from` is zero, `tokenId` will be minted for `to`.
1526    */
1527   function _beforeTokenTransfers(
1528     address from,
1529     address to,
1530     uint256 startTokenId,
1531     uint256 quantity
1532   ) internal virtual {}
1533 
1534   /**
1535    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1536    * minting.
1537    *
1538    * startTokenId - the first token id to be transferred
1539    * quantity - the amount to be transferred
1540    *
1541    * Calling conditions:
1542    *
1543    * - when `from` and `to` are both non-zero.
1544    * - `from` and `to` are never both zero.
1545    */
1546   function _afterTokenTransfers(
1547     address from,
1548     address to,
1549     uint256 startTokenId,
1550     uint256 quantity
1551   ) internal virtual {}
1552 }
1553 // File: contracts/RFAC.sol
1554 
1555 //SPDX-License-Identifier: MIT
1556 pragma solidity ^0.8.10;
1557 
1558 
1559 
1560 
1561 
1562 
1563 contract RFAC is ERC721A{
1564   using SafeMath for uint256;
1565   using Strings for uint256;
1566 
1567   IERC20 public rfacToken;
1568   uint256 public priceInTokens;
1569 
1570   uint256 public maxSupply;
1571   uint256 public maxMint;
1572   uint256 public redrawSupply;
1573   uint256 public nFreeMints;
1574   uint256 public price;
1575 
1576   address payable public owner;
1577 
1578   string baseURI;
1579   uint256 public mintState;
1580 
1581   mapping(address => uint256) private vipList;
1582 
1583   mapping(uint256 => uint256) private redrawnToken;
1584   uint256 public nRedrawn;
1585 
1586   constructor() ERC721A("Royal Flush Ape Club","RFAC", 200){
1587       maxSupply = 8888;
1588       maxMint = 5;
1589       redrawSupply = 2222;
1590       nFreeMints = 1111;
1591       nRedrawn = 0;
1592       price = 0.05 ether;
1593       mintState = 2; //1 - paused for all, 2 - vip, 3 - public, 4 - redrawWithToken enabled , 5 - redrawWithEth enabled
1594       owner = payable(msg.sender);
1595   }
1596 
1597   function _baseURI() internal view virtual override returns (string memory) {
1598     return baseURI;
1599   }
1600 
1601   function mintPublic(uint256 amt) external payable{
1602     require(mintState > 2, "Public sale not open.");
1603     if(totalSupply() > nFreeMints){
1604       require(msg.value == price*amt, "Incorrect Amount of Eth sent."); 
1605     }     
1606     require(totalSupply() + amt <= maxSupply, "Sorry, Sold Out");
1607     require(amt <= maxMint,"Too many mints per transaction");
1608 
1609     _safeMint(_msgSender(),amt);
1610   }
1611 
1612   function mintVIP(uint256 amt) external payable {
1613     require(mintState > 1, "VIP list is not active");
1614     require(amt <= vipList[msg.sender], "Exceeded max available to purchase");
1615     require(totalSupply() + amt <= maxSupply, "Purchase would exceed max tokens");
1616     if(totalSupply() > nFreeMints){
1617       require(msg.value == price*amt, "Incorrect Amount of Eth sent."); 
1618     }
1619 
1620     vipList[msg.sender] -= amt;
1621     _safeMint(_msgSender(),amt);
1622   }
1623 
1624   function tokenURI(uint256 tokenId)
1625   public
1626   view
1627   virtual
1628   override
1629   returns (string memory){
1630     require(_exists(tokenId),"ERC721: nonexistent token");
1631     
1632 
1633     string memory currentBaseURI = _baseURI();
1634                 
1635       if(redrawnToken[tokenId]>0){
1636         return bytes(currentBaseURI).length > 0
1637           ? string(abi.encodePacked(currentBaseURI, uintToString(redrawnToken[tokenId])))
1638           : "";
1639       }else{
1640         return bytes(currentBaseURI).length > 0
1641                 ? string(abi.encodePacked(currentBaseURI, uintToString(tokenId)))
1642                 : "";
1643       }
1644   }
1645 
1646   function redrawWithToken(uint256 _tokenId) external payable{
1647     require(mintState > 3, "No redraws yet");
1648     require(msg.sender == ownerOf(_tokenId),"You don't own this Token");
1649     require(rfacToken.transferFrom(msg.sender, address(this), priceInTokens), "Error with token transfer");
1650     require(nRedrawn < redrawSupply,"No more cards in Deck");
1651 
1652     redrawnToken[_tokenId] = maxSupply + nRedrawn;
1653     nRedrawn++;
1654   }
1655 
1656   function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
1657       if (_i == 0) {
1658           return "0";
1659       }
1660       uint j = _i;
1661       uint len;
1662       while (j != 0) {
1663           len++;
1664           j /= 10;
1665       }
1666       bytes memory bstr = new bytes(len);
1667       uint k = len;
1668       while (_i != 0) {
1669           k = k-1;
1670           uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1671           bytes1 b1 = bytes1(temp);
1672           bstr[k] = b1;
1673           _i /= 10;
1674       }
1675       return string(bstr);
1676   }
1677 
1678   //only owner
1679   modifier onlyOwner(){
1680       require(msg.sender == owner,"not owner");
1681       _;
1682   }
1683 
1684   function withdraw() external payable onlyOwner{
1685     uint amount = address(this).balance;
1686 
1687     (bool success, ) = owner.call{value: amount}("");
1688     require(success, "Failed to send Ether");
1689   }
1690          
1691   function setPrice(uint32 _newPrice) external onlyOwner {
1692     price = _newPrice;
1693   }
1694 
1695   function setMaxSupply(uint32 _newMax) external onlyOwner {
1696     maxSupply = _newMax;
1697   }
1698 
1699   function setRedrawSupply(uint32 _newSupply) external onlyOwner {
1700     redrawSupply = _newSupply;
1701   }
1702 
1703   function setPriceInTokens(uint32 _newPrice) external onlyOwner {
1704     priceInTokens = _newPrice;
1705   }
1706 
1707   function setVipList(address[] calldata _addresses, uint8 _numAllowedToMint) external onlyOwner {
1708     for (uint256 i = 0; i < _addresses.length; i++) {
1709         vipList[_addresses[i]] = _numAllowedToMint;
1710     }
1711   }
1712 
1713   function setBaseURI(string memory _newBaseURI) external onlyOwner {
1714     baseURI = _newBaseURI;
1715   }
1716 
1717   function setMintState(uint256 _state) external onlyOwner {
1718     mintState = _state;
1719   }
1720 
1721   function setTokenAddress(address _tokenAddress) external onlyOwner {
1722     rfacToken = IERC20(_tokenAddress);
1723   }
1724 }