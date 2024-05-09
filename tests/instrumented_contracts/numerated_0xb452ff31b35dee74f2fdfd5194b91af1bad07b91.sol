1 // SPDX-License-Identifier: MIT
2 
3 //                      //  ////////////////                 ///\\\               ////////////////                   ///////
4   //                  //    //             //             //        \\            //             //                //       //
5     //              //      //              //          //            \\          //              //             //           //
6       //          //        //               //       //                \\        //               //          //               //
7         //      //          //              //      //                    \\      //              //         //
8           //  //            //             //     //                        \\    //             //        //
9             //              ////////////////     //                          \\   ///////////////        //            ///////////
10           //  //            //             //    \\                          //   //           //         //           //       // 
11         //      //          //              //     \\                      //     //            //          //         //       //
12       //          //        //               //      \\                  //       //             //           //                //
13     //              //      //              //         \\              //         //              //            //              //
14   //                  //    //             //            \\          //           //               //             //            //
15 //                      //  ////////////////                \\\\////              //                //              /////////////
16 
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct9                                
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
42 pragma solidity ^0.8.1;
43 
44 /**
45  * @dev Collection of functions related to the address type
46  */
47 library Address {
48     /**
49      * @dev Returns true if `account` is a contract.
50      *
51      * [IMPORTANT]
52      * ====
53      * It is unsafe to assume that an address for which this function returns
54      * false is an externally-owned account (EOA) and not a contract.
55      *
56      * Among others, `isContract` will return false for the following
57      * types of addresses:
58      *
59      *  - an externally-owned account
60      *  - a contract in construction
61      *  - an address where a contract will be created
62      *  - an address where a contract lived, but was destroyed
63      * ====
64      *
65      * [IMPORTANT]
66      * ====
67      * You shouldn't rely on `isContract` to protect against flash loan attacks!
68      *
69      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
70      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
71      * constructor.
72      * ====
73      */
74     function isContract(address account) internal view returns (bool) {
75         // This method relies on extcodesize/address.code.length, which returns 0
76         // for contracts in construction, since the code is only stored at the end
77         // of the constructor execution.
78 
79         return account.code.length > 0;
80     }
81 
82     /**
83      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
84      * `recipient`, forwarding all available gas and reverting on errors.
85      *
86      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
87      * of certain opcodes, possibly making contracts go over the 2300 gas limit
88      * imposed by `transfer`, making them unable to receive funds via
89      * `transfer`. {sendValue} removes this limitation.
90      *
91      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
92      *
93      * IMPORTANT: because control is transferred to `recipient`, care must be
94      * taken to not create reentrancy vulnerabilities. Consider using
95      * {ReentrancyGuard} or the
96      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
97      */
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         (bool success, ) = recipient.call{value: amount}("");
102         require(success, "Address: unable to send value, recipient may have reverted");
103     }
104 
105     /**
106      * @dev Performs a Solidity function call using a low level `call`. A
107      * plain `call` is an unsafe replacement for a function call: use this
108      * function instead.
109      *
110      * If `target` reverts with a revert reason, it is bubbled up by this
111      * function (like regular Solidity function calls).
112      *
113      * Returns the raw returned data. To convert to the expected return value,
114      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
115      *
116      * Requirements:
117      *
118      * - `target` must be a contract.
119      * - calling `target` with `data` must not revert.
120      *
121      * _Available since v3.1._
122      */
123     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
124         return functionCall(target, data, "Address: low-level call failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
129      * `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCall(
134         address target,
135         bytes memory data,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, 0, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but also transferring `value` wei to `target`.
144      *
145      * Requirements:
146      *
147      * - the calling contract must have an ETH balance of at least `value`.
148      * - the called Solidity function must be `payable`.
149      *
150      * _Available since v3.1._
151      */
152     function functionCallWithValue(
153         address target,
154         bytes memory data,
155         uint256 value
156     ) internal returns (bytes memory) {
157         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
162      * with `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         require(address(this).balance >= value, "Address: insufficient balance for call");
173         require(isContract(target), "Address: call to non-contract");
174 
175         (bool success, bytes memory returndata) = target.call{value: value}(data);
176         return verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but performing a static call.
182      *
183      * _Available since v3.3._
184      */
185     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
186         return functionStaticCall(target, data, "Address: low-level static call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal view returns (bytes memory) {
200         require(isContract(target), "Address: static call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.staticcall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a delegate call.
209      *
210      * _Available since v3.4._
211      */
212     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(isContract(target), "Address: delegate call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.delegatecall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
235      * revert reason using the provided one.
236      *
237      * _Available since v4.3._
238      */
239     function verifyCallResult(
240         bool success,
241         bytes memory returndata,
242         string memory errorMessage
243     ) internal pure returns (bytes memory) {
244         if (success) {
245             return returndata;
246         } else {
247             // Look for revert reason and bubble it up if present
248             if (returndata.length > 0) {
249                 // The easiest way to bubble the revert reason is using memory via assembly
250 
251                 assembly {
252                     let returndata_size := mload(returndata)
253                     revert(add(32, returndata), returndata_size)
254                 }
255             } else {
256                 revert(errorMessage);
257             }
258         }
259     }
260 }
261 
262 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
263 pragma solidity ^0.8.0;
264 
265 // CAUTION
266 // This version of SafeMath should only be used with Solidity 0.8 or later,
267 // because it relies on the compiler's built in overflow checks.
268 
269 /**
270  * @dev Wrappers over Solidity's arithmetic operations.
271  *
272  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
273  * now has built in overflow checking.
274  */
275 library SafeMath {
276     /**
277      * @dev Returns the addition of two unsigned integers, with an overflow flag.
278      *
279      * _Available since v3.4._
280      */
281     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             uint256 c = a + b;
284             if (c < a) return (false, 0);
285             return (true, c);
286         }
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
291      *
292      * _Available since v3.4._
293      */
294     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         unchecked {
296             if (b > a) return (false, 0);
297             return (true, a - b);
298         }
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
303      *
304      * _Available since v3.4._
305      */
306     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         unchecked {
308             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
309             // benefit is lost if 'b' is also tested.
310             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
311             if (a == 0) return (true, 0);
312             uint256 c = a * b;
313             if (c / a != b) return (false, 0);
314             return (true, c);
315         }
316     }
317 
318     /**
319      * @dev Returns the division of two unsigned integers, with a division by zero flag.
320      *
321      * _Available since v3.4._
322      */
323     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
324         unchecked {
325             if (b == 0) return (false, 0);
326             return (true, a / b);
327         }
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         unchecked {
337             if (b == 0) return (false, 0);
338             return (true, a % b);
339         }
340     }
341 
342     /**
343      * @dev Returns the addition of two unsigned integers, reverting on
344      * overflow.
345      *
346      * Counterpart to Solidity's `+` operator.
347      *
348      * Requirements:
349      *
350      * - Addition cannot overflow.
351      */
352     function add(uint256 a, uint256 b) internal pure returns (uint256) {
353         return a + b;
354     }
355 
356     /**
357      * @dev Returns the subtraction of two unsigned integers, reverting on
358      * overflow (when the result is negative).
359      *
360      * Counterpart to Solidity's `-` operator.
361      *
362      * Requirements:
363      *
364      * - Subtraction cannot overflow.
365      */
366     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a - b;
368     }
369 
370     /**
371      * @dev Returns the multiplication of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `*` operator.
375      *
376      * Requirements:
377      *
378      * - Multiplication cannot overflow.
379      */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         return a * b;
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers, reverting on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator.
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b) internal pure returns (uint256) {
395         return a / b;
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400      * reverting when dividing by zero.
401      *
402      * Counterpart to Solidity's `%` operator. This function uses a `revert`
403      * opcode (which leaves remaining gas untouched) while Solidity uses an
404      * invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
411         return a % b;
412     }
413 
414     /**
415      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
416      * overflow (when the result is negative).
417      *
418      * CAUTION: This function is deprecated because it requires allocating memory for the error
419      * message unnecessarily. For custom revert reasons use {trySub}.
420      *
421      * Counterpart to Solidity's `-` operator.
422      *
423      * Requirements:
424      *
425      * - Subtraction cannot overflow.
426      */
427     function sub(
428         uint256 a,
429         uint256 b,
430         string memory errorMessage
431     ) internal pure returns (uint256) {
432         unchecked {
433             require(b <= a, errorMessage);
434             return a - b;
435         }
436     }
437 
438     /**
439      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
440      * division by zero. The result is rounded towards zero.
441      *
442      * Counterpart to Solidity's `/` operator. Note: this function uses a
443      * `revert` opcode (which leaves remaining gas untouched) while Solidity
444      * uses an invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function div(
451         uint256 a,
452         uint256 b,
453         string memory errorMessage
454     ) internal pure returns (uint256) {
455         unchecked {
456             require(b > 0, errorMessage);
457             return a / b;
458         }
459     }
460 
461     /**
462      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
463      * reverting with custom message when dividing by zero.
464      *
465      * CAUTION: This function is deprecated because it requires allocating memory for the error
466      * message unnecessarily. For custom revert reasons use {tryMod}.
467      *
468      * Counterpart to Solidity's `%` operator. This function uses a `revert`
469      * opcode (which leaves remaining gas untouched) while Solidity uses an
470      * invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      *
474      * - The divisor cannot be zero.
475      */
476     function mod(
477         uint256 a,
478         uint256 b,
479         string memory errorMessage
480     ) internal pure returns (uint256) {
481         unchecked {
482             require(b > 0, errorMessage);
483             return a % b;
484         }
485     }
486 }
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev String operations.
493  */
494 library Strings {
495     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
499      */
500     function toString(uint256 value) internal pure returns (string memory) {
501         // Inspired by OraclizeAPI's implementation - MIT licence
502         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
503 
504         if (value == 0) {
505             return "0";
506         }
507         uint256 temp = value;
508         uint256 digits;
509         while (temp != 0) {
510             digits++;
511             temp /= 10;
512         }
513         bytes memory buffer = new bytes(digits);
514         while (value != 0) {
515             digits -= 1;
516             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
517             value /= 10;
518         }
519         return string(buffer);
520     }
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
524      */
525     function toHexString(uint256 value) internal pure returns (string memory) {
526         if (value == 0) {
527             return "0x00";
528         }
529         uint256 temp = value;
530         uint256 length = 0;
531         while (temp != 0) {
532             length++;
533             temp >>= 8;
534         }
535         return toHexString(value, length);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
540      */
541     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
542         bytes memory buffer = new bytes(2 * length + 2);
543         buffer[0] = "0";
544         buffer[1] = "x";
545         for (uint256 i = 2 * length + 1; i > 1; --i) {
546             buffer[i] = _HEX_SYMBOLS[value & 0xf];
547             value >>= 4;
548         }
549         require(value == 0, "Strings: hex length insufficient");
550         return string(buffer);
551     }
552 }
553 
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Contract module which provides a basic access control mechanism, where
559  * there is an account (an owner) that can be granted exclusive access to
560  * specific functions.
561  *
562  * By default, the owner account will be the one that deploys the contract. This
563  * can later be changed with {transferOwnership}.
564  *
565  * This module is used through inheritance. It will make available the modifier
566  * `onlyOwner`, which can be applied to your functions to restrict their use to
567  * the owner.
568  */
569 abstract contract Ownable is Context {
570     address private _owner;
571 
572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
573 
574     /**
575      * @dev Initializes the contract setting the deployer as the initial owner.
576      */
577     constructor() {
578         _setOwner(_msgSender());
579     }
580 
581     /**
582      * @dev Returns the address of the current owner.
583      */
584     function owner() public view virtual returns (address) {
585         return _owner;
586     }
587 
588     /**
589      * @dev Throws if called by any account other than the owner.
590      */
591     modifier onlyOwner() {
592         require(owner() == _msgSender(), "Ownable: caller is not the owner");
593         _;
594     }
595 
596     /**
597      * @dev Leaves the contract without owner. It will not be possible to call
598      * `onlyOwner` functions anymore. Can only be called by the current owner.
599      *
600      * NOTE: Renouncing ownership will leave the contract without an owner,
601      * thereby removing any functionality that is only available to the owner.
602      */
603     function renounceOwnership() public virtual onlyOwner {
604         _setOwner(address(0));
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Can only be called by the current owner.
610      */
611     function transferOwnership(address newOwner) public virtual onlyOwner {
612         require(newOwner != address(0), "Ownable: new owner is the zero address");
613         _setOwner(newOwner);
614     }
615 
616     function _setOwner(address newOwner) private {
617         address oldOwner = _owner;
618         _owner = newOwner;
619         emit OwnershipTransferred(oldOwner, newOwner);
620     }
621 }
622 
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Contract module that helps prevent reentrant calls to a function.
628  *
629  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
630  * available, which can be applied to functions to make sure there are no nested
631  * (reentrant) calls to them.
632  *
633  * Note that because there is a single `nonReentrant` guard, functions marked as
634  * `nonReentrant` may not call one another. This can be worked around by making
635  * those functions `private`, and then adding `external` `nonReentrant` entry
636  * points to them.
637  *
638  * TIP: If you would like to learn more about reentrancy and alternative ways
639  * to protect against it, check out our blog post
640  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
641  */
642 abstract contract ReentrancyGuard {
643     // Booleans are more expensive than uint256 or any type that takes up a full
644     // word because each write operation emits an extra SLOAD to first read the
645     // slot's contents, replace the bits taken up by the boolean, and then write
646     // back. This is the compiler's defense against contract upgrades and
647     // pointer aliasing, and it cannot be disabled.
648 
649     // The values being non-zero value makes deployment a bit more expensive,
650     // but in exchange the refund on every call to nonReentrant will be lower in
651     // amount. Since refunds are capped to a percentage of the total
652     // transaction's gas, it is best to keep them low in cases like this one, to
653     // increase the likelihood of the full refund coming into effect.
654     uint256 private constant _NOT_ENTERED = 1;
655     uint256 private constant _ENTERED = 2;
656 
657     uint256 private _status;
658 
659     constructor() {
660         _status = _NOT_ENTERED;
661     }
662 
663     /**
664      * @dev Prevents a contract from calling itself, directly or indirectly.
665      * Calling a `nonReentrant` function from another `nonReentrant`
666      * function is not supported. It is possible to prevent this from happening
667      * by making the `nonReentrant` function external, and make it call a
668      * `private` function that does the actual work.
669      */
670     modifier nonReentrant() {
671         // On the first call to nonReentrant, _notEntered will be true
672         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
673 
674         // Any calls to nonReentrant after this point will fail
675         _status = _ENTERED;
676 
677         _;
678 
679         // By storing the original value once again, a refund is triggered (see
680         // https://eips.ethereum.org/EIPS/eip-2200)
681         _status = _NOT_ENTERED;
682     }
683 }
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev Interface of the ERC165 standard, as defined in the
690  * https://eips.ethereum.org/EIPS/eip-165[EIP].
691  *
692  * Implementers can declare support of contract interfaces, which can then be
693  * queried by others ({ERC165Checker}).
694  *
695  * For an implementation, see {ERC165}.
696  */
697 interface IERC165 {
698     /**
699      * @dev Returns true if this contract implements the interface defined by
700      * `interfaceId`. See the corresponding
701      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
702      * to learn more about how these ids are created.
703      *
704      * This function call must use less than 30 000 gas.
705      */
706     function supportsInterface(bytes4 interfaceId) external view returns (bool);
707 }
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev Implementation of the {IERC165} interface.
714  *
715  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
716  * for the additional interface id that will be supported. For example:
717  *
718  * ```solidity
719  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
721  * }
722  * ```
723  *
724  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
725  */
726 abstract contract ERC165 is IERC165 {
727     /**
728      * @dev See {IERC165-supportsInterface}.
729      */
730     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731         return interfaceId == type(IERC165).interfaceId;
732     }
733 }
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Required interface of an ERC721 compliant contract.
740  */
741 interface IERC721 is IERC165 {
742     /**
743      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
744      */
745     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
749      */
750     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
751 
752     /**
753      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
754      */
755     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
756 
757     /**
758      * @dev Returns the number of tokens in ``owner``'s account.
759      */
760     function balanceOf(address owner) external view returns (uint256 balance);
761 
762     /**
763      * @dev Returns the owner of the `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function ownerOf(uint256 tokenId) external view returns (address owner);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes calldata data
789     ) external;
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * Requirements:
796      *
797      * - `from` cannot be the zero address.
798      * - `to` cannot be the zero address.
799      * - `tokenId` token must exist and be owned by `from`.
800      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Transfers `tokenId` token from `from` to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) external;
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
836      *
837      * Requirements:
838      *
839      * - The caller must own the token or be an approved operator.
840      * - `tokenId` must exist.
841      *
842      * Emits an {Approval} event.
843      */
844     function approve(address to, uint256 tokenId) external;
845 
846     /**
847      * @dev Approve or remove `operator` as an operator for the caller.
848      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
849      *
850      * Requirements:
851      *
852      * - The `operator` cannot be the caller.
853      *
854      * Emits an {ApprovalForAll} event.
855      */
856     function setApprovalForAll(address operator, bool _approved) external;
857 
858     /**
859      * @dev Returns the account approved for `tokenId` token.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function getApproved(uint256 tokenId) external view returns (address operator);
866 
867     /**
868      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
869      *
870      * See {setApprovalForAll}
871      */
872     function isApprovedForAll(address owner, address operator) external view returns (bool);
873 }
874 
875 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
876 pragma solidity ^0.8.0;
877 
878 /**
879  * @title ERC721 token receiver interface
880  * @dev Interface for any contract that wants to support safeTransfers
881  * from ERC721 asset contracts.
882  */
883 interface IERC721Receiver {
884     /**
885      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
886      * by `operator` from `from`, this function is called.
887      *
888      * It must return its Solidity selector to confirm the token transfer.
889      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
890      *
891      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
892      */
893     function onERC721Received(
894         address operator,
895         address from,
896         uint256 tokenId,
897         bytes calldata data
898     ) external returns (bytes4);
899 }
900 
901 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
902 pragma solidity ^0.8.0;
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Metadata is IERC721 {
909     /**
910      * @dev Returns the token collection name.
911      */
912     function name() external view returns (string memory);
913 
914     /**
915      * @dev Returns the token collection symbol.
916      */
917     function symbol() external view returns (string memory);
918 
919     /**
920      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
921      */
922     function tokenURI(uint256 tokenId) external view returns (string memory);
923 }
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @dev Interface for the NFT Royalty Standard.
929  *
930  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
931  * support for royalty payments across all NFT marketplaces and ecosystem participants.
932  *
933  * _Available since v4.5._
934  */
935 interface IERC2981 is IERC165 {
936     /**
937      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
938      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
939      */
940     function royaltyInfo(uint256 tokenId, uint256 salePrice)
941         external
942         view
943         returns (address receiver, uint256 royaltyAmount);
944 }
945 
946 pragma solidity ^0.8.0;
947 
948 /**
949  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
950  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
951  *
952  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
953  *
954  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
955  *
956  * Does not support burning tokens to address(0).
957  */
958 contract ERC721X is Context, ERC165, IERC721, IERC721Metadata {
959     using Address for address;
960     using Strings for uint256;
961 
962     struct TokenOwnership {
963         address addr;
964         uint64 startTimestamp;
965     }
966 
967     struct AddressData {
968         uint64 balance;
969         uint64 numberMinted;
970     }
971 
972     uint256 private currentIndex = 0;
973     uint256 private burnedIndex = 0;
974 
975     uint256 internal immutable collectionSize;
976     uint256 internal immutable maxBatchSize;
977 
978     // Token name
979     string private _name;
980 
981     // Token symbol
982     string private _symbol;
983 
984     // Mapping from token ID to ownership details
985     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
986     mapping(uint256 => TokenOwnership) private _ownerships;
987 
988     // Mapping owner address to address data
989     mapping(address => AddressData) private _addressData;
990 
991     // Mapping from token ID to approved address
992     mapping(uint256 => address) private _tokenApprovals;
993 
994     // Mapping from owner to operator approvals
995     mapping(address => mapping(address => bool)) private _operatorApprovals;
996 
997     /**
998     * @dev
999     * `maxBatchSize` refers to how much a minter can mint at a time.
1000     * `collectionSize_` refers to how many tokens are in the collection.
1001     */
1002     constructor(
1003         string memory name_,
1004         string memory symbol_,
1005         uint256 maxBatchSize_,
1006         uint256 collectionSize_
1007     ) {
1008         require(collectionSize_ > 0, "ERC721X: collection must have a nonzero supply");
1009         require(maxBatchSize_ > 0, "ERC721X: max batch size must be nonzero");
1010         _name = name_;
1011         _symbol = symbol_;
1012         maxBatchSize = maxBatchSize_;
1013         collectionSize = collectionSize_;
1014     }
1015 
1016     /**
1017     * @dev See Remove store data in IERC721Enumerable {IERC721Enumerable-totalSupply}.
1018     */
1019     function totalSupply() public view returns (uint256) {
1020         return currentIndex - burnedIndex;
1021     }
1022 
1023     /**
1024     * @dev See {IERC165-supportsInterface}.
1025     */
1026     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1027         return
1028             interfaceId == type(IERC721).interfaceId ||
1029             interfaceId == type(IERC721Metadata).interfaceId ||
1030             super.supportsInterface(interfaceId);
1031     }
1032 
1033     /**
1034     * @dev See {IERC721-balanceOf}.
1035     */
1036     function balanceOf(address owner) public view override returns (uint256) {
1037         require(owner != address(0), "ERC721X: balance query for the zero address");
1038         return uint256(_addressData[owner].balance);
1039     }
1040 
1041     function _numberMinted(address owner) internal view returns (uint256) {
1042         require(owner != address(0), "ERC721X: number minted query for the zero address");
1043         return uint256(_addressData[owner].numberMinted);
1044     }
1045 
1046     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1047         require(_exists(tokenId), "ERC721X: owner query for nonexistent token");
1048         uint256 lowestTokenToCheck;
1049         if (tokenId >= maxBatchSize) {
1050             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1051         }
1052 
1053         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1054             TokenOwnership memory ownership = _ownerships[curr];
1055             if (ownership.addr != address(0)) {
1056                 return ownership;
1057             }
1058         }
1059         revert("ERC721X: unable to determine the owner of token");
1060     }
1061 
1062     /**
1063     * @dev See {IERC721-ownerOf}.
1064     */
1065     function ownerOf(uint256 tokenId) public view override returns (address) {
1066         return ownershipOf(tokenId).addr;
1067     }
1068 
1069     /**
1070     * @dev See {IERC721Metadata-name}.
1071     */
1072     function name() public view virtual override returns (string memory) {
1073         return _name;
1074     }
1075 
1076     /**
1077     * @dev See {IERC721Metadata-symbol}.
1078     */
1079     function symbol() public view virtual override returns (string memory) {
1080         return _symbol;
1081     }
1082 
1083     /**
1084     * @dev See {IERC721Metadata-tokenURI}.
1085     */
1086     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1087         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1088         string memory baseURI = _baseURI();
1089         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")): "";
1090     }
1091 
1092     /**
1093     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1094     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1095     * by default, can be overriden in child contracts.
1096     */
1097     function _baseURI() internal view virtual returns (string memory) {
1098         return "";
1099     }
1100 
1101     /**
1102     * @dev See {IERC721-approve}.
1103     */
1104     function approve(address to, uint256 tokenId) public override {
1105         address owner = ERC721X.ownerOf(tokenId);
1106         require(to != owner, "ERC721X: approval to current owner");
1107         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),"ERC721X: approve caller is not owner nor approved for all");
1108         _approve(to, tokenId, owner);
1109     }
1110 
1111     /**
1112     * @dev See {IERC721-getApproved}.
1113     */
1114     function getApproved(uint256 tokenId) public view override returns (address) {
1115         require(_exists(tokenId), "ERC721X: approved query for nonexistent token");
1116 
1117         return _tokenApprovals[tokenId];
1118     }
1119 
1120     /**
1121     * @dev See {IERC721-setApprovalForAll}.
1122     */
1123     function setApprovalForAll(address operator, bool approved) public override {
1124         require(operator != _msgSender(), "ERC721X: approve to caller");
1125 
1126         _operatorApprovals[_msgSender()][operator] = approved;
1127         emit ApprovalForAll(_msgSender(), operator, approved);
1128     }
1129 
1130     /**
1131     * @dev See {IERC721-isApprovedForAll}.
1132     */
1133     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
1134         return _operatorApprovals[owner][operator];
1135     }
1136 
1137     /**
1138     * @dev See {IERC721-transferFrom}.
1139     */
1140     function transferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) public override {
1145         _transfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149     * @dev See {IERC721-safeTransferFrom}.
1150     */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public override {
1156         safeTransferFrom(from, to, tokenId, "");
1157     }
1158 
1159     /**
1160     * @dev See {IERC721-safeTransferFrom}.
1161     */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) public override {
1168         _transfer(from, to, tokenId);
1169         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721X: transfer to non ERC721Receiver implementer");
1170     }
1171 
1172     /**
1173     * @dev Returns whether `tokenId` exists.
1174     *
1175     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1176     *
1177     * Tokens start existing when they are minted (`_mint`),
1178     */
1179     function _exists(uint256 tokenId) internal view returns (bool) {
1180         return tokenId < currentIndex;
1181     }
1182 
1183     /**
1184      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      */
1190     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1191         require(_exists(tokenId), "ERC721X: operator query for nonexistent token");
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193         return(spender == prevOwnership.addr || getApproved(tokenId) == spender || isApprovedForAll(prevOwnership.addr, spender));
1194         //return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1195     }
1196 
1197     function _safeMint(address to, uint256 quantity) internal {
1198         _safeMint(to, quantity, "");
1199     }
1200 
1201     /**
1202     * @dev Mints `quantity` tokens and transfers them to `to`.
1203     *
1204     * Requirements:
1205     *
1206     * - there must be `quantity` tokens remaining unminted in the total collection.
1207     * - `to` cannot be the zero address.
1208     * - `quantity` cannot be larger than the max batch size.
1209     *
1210     * Emits a {Transfer} event.
1211     */
1212     function _safeMint(
1213         address to,
1214         uint256 quantity,
1215         bytes memory _data
1216     ) internal {
1217         uint256 startTokenId = currentIndex;
1218         require(to != address(0), "ERC721X: mint to the zero address");
1219         require(!_exists(startTokenId), "ERC721X: token already minted");
1220         require(quantity <= maxBatchSize, "ERC721X: quantity to mint over than max batch size");
1221 
1222         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1223 
1224         unchecked {
1225             _addressData[to].balance += uint64(quantity);
1226             _addressData[to].numberMinted += uint64(quantity);
1227 
1228             _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1229 
1230             uint256 updatedIndex = startTokenId;
1231 
1232             for (uint256 i = 0; i < quantity; i++) {
1233                 emit Transfer(address(0), to, updatedIndex);
1234                 require(_checkOnERC721Received(address(0), to, updatedIndex, _data), "ERC721X: transfer to non ERC721Receiver implementer");
1235                 updatedIndex++;
1236             }
1237             currentIndex = updatedIndex;
1238             _afterTokenTransfers(address(0), to, startTokenId, quantity);
1239         }
1240     }
1241 
1242     /**
1243     * @dev burn function Transfers `tokenId` from `from` to `unused address`.
1244     *
1245     * Requirements:
1246     *
1247     * - `to` cannot be the zero address and fix to unused address.
1248     * - `tokenId` token must be owned by `from`.
1249     *
1250     * Emits a {Transfer} event.
1251     */
1252 
1253     function _burn(
1254         address from,
1255         uint256 tokenId
1256         ) internal virtual {
1257         address to = 0x000000000000000000000000000000000000dEaD;
1258         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1259 
1260         //bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1261         //getApproved(tokenId) == _msgSender() ||
1262         //isApprovedForAll(prevOwnership.addr, _msgSender()));
1263 
1264         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721X: burn caller is not owner nor approved");
1265         require(prevOwnership.addr == from, "ERC721X: burn from incorrect owner");
1266 
1267         _beforeTokenTransfers(from, to, tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, prevOwnership.addr);
1271 
1272         _addressData[from].balance -= 1;
1273         _addressData[to].balance += 1;
1274         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1275 
1276         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1277         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1278         uint256 nextTokenId = tokenId + 1;
1279         if (_ownerships[nextTokenId].addr == address(0)) {
1280             if (_exists(nextTokenId)) {
1281                 _ownerships[nextTokenId] = TokenOwnership(
1282                 prevOwnership.addr,
1283                 prevOwnership.startTimestamp
1284                 );
1285             }
1286         }
1287         emit Transfer(from, to, tokenId);
1288         burnedIndex++;
1289         _afterTokenTransfers(from, to, tokenId, 1);
1290     }
1291 
1292     /**
1293     * @dev Transfers `tokenId` from `from` to `to`.
1294     *
1295     * Requirements:
1296     *
1297     * - `to` cannot be the zero address.
1298     * - `tokenId` token must be owned by `from`.
1299     *
1300     * Emits a {Transfer} event.
1301     */
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) internal virtual {
1307         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1308 
1309         //bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1310         //getApproved(tokenId) == _msgSender() ||
1311         //isApprovedForAll(prevOwnership.addr, _msgSender()));
1312 
1313         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721X: transfer caller is not owner nor approved");
1314         require(prevOwnership.addr == from, "ERC721X: transfer from incorrect owner");
1315         require(to != address(0), "ERC721X: transfer to the zero address");
1316 
1317         _beforeTokenTransfers(from, to, tokenId, 1);
1318 
1319         // Clear approvals from the previous owner
1320         _approve(address(0), tokenId, prevOwnership.addr);
1321 
1322         _addressData[from].balance -= 1;
1323         _addressData[to].balance += 1;
1324         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1325 
1326         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1327         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1328         uint256 nextTokenId = tokenId + 1;
1329         if (_ownerships[nextTokenId].addr == address(0)) {
1330             if (_exists(nextTokenId)) {
1331                 _ownerships[nextTokenId] = TokenOwnership(
1332                 prevOwnership.addr,
1333                 prevOwnership.startTimestamp
1334                 );
1335             }
1336         }
1337 
1338         emit Transfer(from, to, tokenId);
1339         _afterTokenTransfers(from, to, tokenId, 1);
1340     }
1341 
1342     /**
1343     * @dev Approve `to` to operate on `tokenId`
1344     *
1345     * Emits a {Approval} event.
1346     */
1347     function _approve(
1348         address to,
1349         uint256 tokenId,
1350         address owner
1351     ) private {
1352         _tokenApprovals[tokenId] = to;
1353         emit Approval(owner, to, tokenId);
1354     }
1355 
1356     uint256 public nextOwnerToExplicitlySet = 0;
1357 
1358     /**
1359     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1360     */
1361     function _setOwnersExplicit(uint256 quantity) internal {
1362         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1363         require(quantity > 0, "quantity must be nonzero");
1364         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1365         if (endIndex > collectionSize - 1) {
1366             endIndex = collectionSize - 1;
1367         }
1368         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1369         require(_exists(endIndex), "not enough minted yet for this cleanup");
1370         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1371             if (_ownerships[i].addr == address(0)) {
1372                 TokenOwnership memory ownership = ownershipOf(i);
1373                 _ownerships[i] = TokenOwnership(
1374                 ownership.addr,
1375                 ownership.startTimestamp
1376                 );
1377             }
1378         }
1379         nextOwnerToExplicitlySet = endIndex + 1;
1380     }
1381 
1382     /**
1383     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1384     * The call is not executed if the target address is not a contract.
1385     *
1386     * @param from address representing the previous owner of the given token ID
1387     * @param to target address that will receive the tokens
1388     * @param tokenId uint256 ID of the token to be transferred
1389     * @param _data bytes optional data to send along with the call
1390     * @return bool whether the call correctly returned the expected magic value
1391     */
1392     function _checkOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         if (to.isContract()) {
1399             try
1400                 IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1401             returns (bytes4 retval) {
1402                 return retval == IERC721Receiver(to).onERC721Received.selector;
1403             } catch (bytes memory reason) {
1404                 if (reason.length == 0) {
1405                     revert("ERC721X: transfer to non ERC721Receiver implementer");
1406                 } else {
1407                     assembly {
1408                         revert(add(32, reason), mload(reason))
1409                     }
1410                 }
1411             }
1412         } else {
1413             return true;
1414         }
1415     }
1416 
1417     /**
1418     * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1419     *
1420     * startTokenId - the first token id to be transferred
1421     * quantity - the amount to be transferred
1422     *
1423     * Calling conditions:
1424     *
1425     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1426     * transferred to `to`.
1427     * - When `from` is zero, `tokenId` will be minted for `to`.
1428     */
1429     function _beforeTokenTransfers(
1430         address from,
1431         address to,
1432         uint256 startTokenId,
1433         uint256 quantity
1434     ) internal virtual {}
1435 
1436     /**
1437     * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1438     * minting.
1439     *
1440     * startTokenId - the first token id to be transferred
1441     * quantity - the amount to be transferred
1442     *
1443     * Calling conditions:
1444     *
1445     * - when `from` and `to` are both non-zero.
1446     * - `from` and `to` are never both zero.
1447     */
1448     function _afterTokenTransfers(
1449         address from,
1450         address to,
1451         uint256 startTokenId,
1452         uint256 quantity
1453     ) internal virtual {}
1454 }
1455 
1456 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
1457 pragma solidity ^0.8.0;
1458 
1459 /**
1460  * @dev Library for managing
1461  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1462  * types.
1463  *
1464  * Sets have the following properties:
1465  *
1466  * - Elements are added, removed, and checked for existence in constant time
1467  * (O(1)).
1468  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1469  *
1470  * ```
1471  * contract Example {
1472  *     // Add the library methods
1473  *     using EnumerableSet for EnumerableSet.AddressSet;
1474  *
1475  *     // Declare a set state variable
1476  *     EnumerableSet.AddressSet private mySet;
1477  * }
1478  * ```
1479  *
1480  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1481  * and `uint256` (`UintSet`) are supported.
1482  */
1483 library EnumerableSet {
1484     // To implement this library for multiple types with as little code
1485     // repetition as possible, we write it in terms of a generic Set type with
1486     // bytes32 values.
1487     // The Set implementation uses private functions, and user-facing
1488     // implementations (such as AddressSet) are just wrappers around the
1489     // underlying Set.
1490     // This means that we can only create new EnumerableSets for types that fit
1491     // in bytes32.
1492 
1493     struct Set {
1494         // Storage of set values
1495         bytes32[] _values;
1496         // Position of the value in the `values` array, plus 1 because index 0
1497         // means a value is not in the set.
1498         mapping(bytes32 => uint256) _indexes;
1499     }
1500 
1501     /**
1502      * @dev Add a value to a set. O(1).
1503      *
1504      * Returns true if the value was added to the set, that is if it was not
1505      * already present.
1506      */
1507     function _add(Set storage set, bytes32 value) private returns (bool) {
1508         if (!_contains(set, value)) {
1509             set._values.push(value);
1510             // The value is stored at length-1, but we add 1 to all indexes
1511             // and use 0 as a sentinel value
1512             set._indexes[value] = set._values.length;
1513             return true;
1514         } else {
1515             return false;
1516         }
1517     }
1518 
1519     /**
1520      * @dev Removes a value from a set. O(1).
1521      *
1522      * Returns true if the value was removed from the set, that is if it was
1523      * present.
1524      */
1525     function _remove(Set storage set, bytes32 value) private returns (bool) {
1526         // We read and store the value's index to prevent multiple reads from the same storage slot
1527         uint256 valueIndex = set._indexes[value];
1528 
1529         if (valueIndex != 0) {
1530             // Equivalent to contains(set, value)
1531             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1532             // the array, and then remove the last element (sometimes called as 'swap and pop').
1533             // This modifies the order of the array, as noted in {at}.
1534 
1535             uint256 toDeleteIndex = valueIndex - 1;
1536             uint256 lastIndex = set._values.length - 1;
1537 
1538             if (lastIndex != toDeleteIndex) {
1539                 bytes32 lastValue = set._values[lastIndex];
1540 
1541                 // Move the last value to the index where the value to delete is
1542                 set._values[toDeleteIndex] = lastValue;
1543                 // Update the index for the moved value
1544                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1545             }
1546 
1547             // Delete the slot where the moved value was stored
1548             set._values.pop();
1549 
1550             // Delete the index for the deleted slot
1551             delete set._indexes[value];
1552 
1553             return true;
1554         } else {
1555             return false;
1556         }
1557     }
1558 
1559     /**
1560      * @dev Returns true if the value is in the set. O(1).
1561      */
1562     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1563         return set._indexes[value] != 0;
1564     }
1565 
1566     /**
1567      * @dev Returns the number of values on the set. O(1).
1568      */
1569     function _length(Set storage set) private view returns (uint256) {
1570         return set._values.length;
1571     }
1572 
1573     /**
1574      * @dev Returns the value stored at position `index` in the set. O(1).
1575      *
1576      * Note that there are no guarantees on the ordering of values inside the
1577      * array, and it may change when more values are added or removed.
1578      *
1579      * Requirements:
1580      *
1581      * - `index` must be strictly less than {length}.
1582      */
1583     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1584         return set._values[index];
1585     }
1586 
1587     /**
1588      * @dev Return the entire set in an array
1589      *
1590      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1591      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1592      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1593      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1594      */
1595     function _values(Set storage set) private view returns (bytes32[] memory) {
1596         return set._values;
1597     }
1598 
1599     // Bytes32Set
1600 
1601     struct Bytes32Set {
1602         Set _inner;
1603     }
1604 
1605     /**
1606      * @dev Add a value to a set. O(1).
1607      *
1608      * Returns true if the value was added to the set, that is if it was not
1609      * already present.
1610      */
1611     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1612         return _add(set._inner, value);
1613     }
1614 
1615     /**
1616      * @dev Removes a value from a set. O(1).
1617      *
1618      * Returns true if the value was removed from the set, that is if it was
1619      * present.
1620      */
1621     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1622         return _remove(set._inner, value);
1623     }
1624 
1625     /**
1626      * @dev Returns true if the value is in the set. O(1).
1627      */
1628     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1629         return _contains(set._inner, value);
1630     }
1631 
1632     /**
1633      * @dev Returns the number of values in the set. O(1).
1634      */
1635     function length(Bytes32Set storage set) internal view returns (uint256) {
1636         return _length(set._inner);
1637     }
1638 
1639     /**
1640      * @dev Returns the value stored at position `index` in the set. O(1).
1641      *
1642      * Note that there are no guarantees on the ordering of values inside the
1643      * array, and it may change when more values are added or removed.
1644      *
1645      * Requirements:
1646      *
1647      * - `index` must be strictly less than {length}.
1648      */
1649     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1650         return _at(set._inner, index);
1651     }
1652 
1653     /**
1654      * @dev Return the entire set in an array
1655      *
1656      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1657      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1658      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1659      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1660      */
1661     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1662         return _values(set._inner);
1663     }
1664 
1665     // AddressSet
1666 
1667     struct AddressSet {
1668         Set _inner;
1669     }
1670 
1671     /**
1672      * @dev Add a value to a set. O(1).
1673      *
1674      * Returns true if the value was added to the set, that is if it was not
1675      * already present.
1676      */
1677     function add(AddressSet storage set, address value) internal returns (bool) {
1678         return _add(set._inner, bytes32(uint256(uint160(value))));
1679     }
1680 
1681     /**
1682      * @dev Removes a value from a set. O(1).
1683      *
1684      * Returns true if the value was removed from the set, that is if it was
1685      * present.
1686      */
1687     function remove(AddressSet storage set, address value) internal returns (bool) {
1688         return _remove(set._inner, bytes32(uint256(uint160(value))));
1689     }
1690 
1691     /**
1692      * @dev Returns true if the value is in the set. O(1).
1693      */
1694     function contains(AddressSet storage set, address value) internal view returns (bool) {
1695         return _contains(set._inner, bytes32(uint256(uint160(value))));
1696     }
1697 
1698     /**
1699      * @dev Returns the number of values in the set. O(1).
1700      */
1701     function length(AddressSet storage set) internal view returns (uint256) {
1702         return _length(set._inner);
1703     }
1704 
1705     /**
1706      * @dev Returns the value stored at position `index` in the set. O(1).
1707      *
1708      * Note that there are no guarantees on the ordering of values inside the
1709      * array, and it may change when more values are added or removed.
1710      *
1711      * Requirements:
1712      *
1713      * - `index` must be strictly less than {length}.
1714      */
1715     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1716         return address(uint160(uint256(_at(set._inner, index))));
1717     }
1718 
1719     /**
1720      * @dev Return the entire set in an array
1721      *
1722      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1723      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1724      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1725      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1726      */
1727     function values(AddressSet storage set) internal view returns (address[] memory) {
1728         bytes32[] memory store = _values(set._inner);
1729         address[] memory result;
1730 
1731         assembly {
1732             result := store
1733         }
1734 
1735         return result;
1736     }
1737 
1738     // UintSet
1739 
1740     struct UintSet {
1741         Set _inner;
1742     }
1743 
1744     /**
1745      * @dev Add a value to a set. O(1).
1746      *
1747      * Returns true if the value was added to the set, that is if it was not
1748      * already present.
1749      */
1750     function add(UintSet storage set, uint256 value) internal returns (bool) {
1751         return _add(set._inner, bytes32(value));
1752     }
1753 
1754     /**
1755      * @dev Removes a value from a set. O(1).
1756      *
1757      * Returns true if the value was removed from the set, that is if it was
1758      * present.
1759      */
1760     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1761         return _remove(set._inner, bytes32(value));
1762     }
1763 
1764     /**
1765      * @dev Returns true if the value is in the set. O(1).
1766      */
1767     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1768         return _contains(set._inner, bytes32(value));
1769     }
1770 
1771     /**
1772      * @dev Returns the number of values on the set. O(1).
1773      */
1774     function length(UintSet storage set) internal view returns (uint256) {
1775         return _length(set._inner);
1776     }
1777 
1778     /**
1779      * @dev Returns the value stored at position `index` in the set. O(1).
1780      *
1781      * Note that there are no guarantees on the ordering of values inside the
1782      * array, and it may change when more values are added or removed.
1783      *
1784      * Requirements:
1785      *
1786      * - `index` must be strictly less than {length}.
1787      */
1788     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1789         return uint256(_at(set._inner, index));
1790     }
1791 
1792     /**
1793      * @dev Return the entire set in an array
1794      *
1795      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1796      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1797      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1798      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1799      */
1800     function values(UintSet storage set) internal view returns (uint256[] memory) {
1801         bytes32[] memory store = _values(set._inner);
1802         uint256[] memory result;
1803 
1804         assembly {
1805             result := store
1806         }
1807 
1808         return result;
1809     }
1810 }
1811 
1812 pragma solidity ^0.8.0;
1813 pragma abicoder v2;
1814 
1815 abstract contract TokenStake is Ownable, ERC721X {
1816     using EnumerableSet for EnumerableSet.AddressSet;
1817 
1818     EnumerableSet.AddressSet private _tokenStakers;
1819     mapping(uint256 => address) private _stakedTokens;
1820 
1821     event TokenStaked(address indexed tokenStaker, uint256 tokenId);
1822     event TokenUnstaked(address indexed tokenStaker, uint256 tokenId);
1823     event TokenRecoverUnstaked(uint256 tokenId);
1824     event BatchUpdateTokenStaked(address indexed newTokenStaker, uint256[] tokenIds);
1825 
1826     event TokenStakerAdded(address indexed tokenStaker);
1827     event TokenStakerRemoved(address indexed tokenStaker);
1828 
1829     modifier tokenStakersOnly() {
1830         require(_tokenStakers.contains(_msgSender()), "TokenStake: Not staker");
1831         _;
1832     }
1833 
1834     modifier whenTokenNotStaked(uint256 tokenId) {
1835         require(_stakedTokens[tokenId] == address(0), "TokenStake: Token is staked");
1836         _;
1837     }
1838 
1839     modifier whenTokenStaked(uint256 tokenId) {
1840         require(_stakedTokens[tokenId] != address(0), "TokenStake: Token is not staked");
1841         _;
1842     }
1843 
1844     /**
1845      * @notice Returns `true` if token is staked and can't be transfered
1846      */
1847     function isTokenStaked(uint256 tokenId) public view returns (bool) {
1848         return _stakedTokens[tokenId] != address(0);
1849     }
1850 
1851     /**
1852      * @notice Returns the address of the staker for a specific `tokenId``
1853      * Returns 0x0 if token is not staked
1854      */
1855     function stakerForToken(uint256 tokenId) public view returns (address) {
1856         return _stakedTokens[tokenId];
1857     }
1858 
1859     /**
1860      * @notice Lock a token for staking
1861      * only callable by members of the `tokenStakers` list
1862      * The owner of the token must approve the staking contract prior to call this method
1863      */
1864     function stakeToken(uint256 tokenId) external tokenStakersOnly whenTokenNotStaked(tokenId) {
1865         require(_isApprovedOrOwner(_msgSender(), tokenId), "TokenStake: Staker not approved");
1866         _stakedTokens[tokenId] = _msgSender();
1867         emit TokenStaked(_msgSender(), tokenId);
1868     }
1869 
1870     /**
1871      * @notice Lock a token for staking
1872      * only callable by the staker
1873      */
1874     function unstakeToken(uint256 tokenId) external whenTokenStaked(tokenId) {
1875         require(_msgSender() == _stakedTokens[tokenId], "TokenStake: Token not stake by account");
1876         require(_msgSender() != address(0), "TokenStake: can't unstake from zero address");
1877         _stakedTokens[tokenId] = address(0);
1878         emit TokenUnstaked(_msgSender(), tokenId);
1879     }
1880 
1881     /**
1882      * @notice Recover a staked token
1883      * only callable by the owner
1884      */
1885     function recoverStakeToken(uint256 tokenId) external onlyOwner whenTokenStaked(tokenId) {
1886         _stakedTokens[tokenId] = address(0);
1887         emit TokenRecoverUnstaked(tokenId);
1888     }
1889 
1890     /**
1891      * @dev Change the token staker for a list of tokenIds
1892      * only callable by the owner
1893      * this is usefull if the staker contract must be updated
1894      * if `newStaker` is set to 0x0, tokens will be unstaked
1895      */
1896     function batchUpdateTokenStake(address newStaker, uint256[] calldata tokenIds) external onlyOwner {
1897         for (uint256 i = 0; i < tokenIds.length; i++) {
1898             require(_stakedTokens[tokenIds[i]] != address(0), "TokenStake: not restakeable");
1899             if (newStaker != address(0)) {
1900                 require(_isApprovedOrOwner(newStaker, tokenIds[i]), "TokenStake: Staker not approved");
1901             }
1902             _stakedTokens[tokenIds[i]] = newStaker;
1903         }
1904         emit BatchUpdateTokenStaked(newStaker, tokenIds);
1905     }
1906 
1907     /**
1908      * @dev returns true if `account` is a member of the staker group
1909      */
1910     function isTokenStaker(address account) public view returns (bool) {
1911         return _tokenStakers.contains(account);
1912     }
1913 
1914     /**
1915      * @dev Add `tokenStaker` to the list of allowed stakers
1916      * only callable by the owner
1917      */
1918     function addTokenStaker(address tokenStaker) external onlyOwner {
1919         require(!_tokenStakers.contains(tokenStaker), "TokenStake: Already TokenStaker");
1920         _tokenStakers.add(tokenStaker);
1921         emit TokenStakerAdded(tokenStaker);
1922     }
1923 
1924     /**
1925      * @dev Remove `tokenStaker` from the list of allowed stakers
1926      * only callable by the owner
1927      */
1928     function removeTokenStaker(address tokenStaker) external onlyOwner {
1929         require(_tokenStakers.contains(tokenStaker), "TokenStake: Not TokenStaker");
1930         _tokenStakers.remove(tokenStaker);
1931         emit TokenStakerRemoved(tokenStaker);
1932     }
1933 }
1934 
1935 
1936 pragma solidity ^0.8.0;
1937 
1938 interface INftCollection {
1939      /**
1940      * @dev Stake Token
1941      */
1942     function stakeToken(uint256 tokenId) external;
1943 
1944     /**
1945      * @dev Unstake Token
1946      */
1947     function unstakeToken(uint256 tokenId) external;
1948 
1949     /**
1950      * @dev return Token stake status
1951      */
1952     function isTokenStaked(uint256 tokenId) external view returns (bool);
1953 }
1954 
1955 pragma solidity ^0.8.0;
1956 
1957 contract XBorg is Ownable, IERC2981, ERC721X, ReentrancyGuard, TokenStake {
1958     using SafeMath for uint256;
1959 
1960     uint256 public MaxMintPerWallet = 3;
1961     uint256 public MaxSupply = 6000;
1962     uint256 public MaxMintSupply = 5500;
1963     uint256 public MaxBatchSize = 100;
1964     uint256 public NFT_PRICE = 0.08 ether;
1965     address public royalties;
1966     bool public isMetadataLocked;
1967     bool public saleIsActive = false;
1968     bool public PublicsaleIsActive = false;
1969     uint32 private publicSaleKey;
1970     string private _baseTokenURI;
1971     uint256 private WL_Class;
1972     address private constant WithDrawWallet1 = 0x592d4aE36dB7D196E0caD2c3083431B392f95e78;
1973     address private constant WithDrawWallet2 = 0xC0c464514d6397b7b529A3650697Fd5967b5A892;
1974     
1975 
1976     event LockMetadata();
1977     event Withdraw(uint256 amount);
1978 
1979     constructor(uint32 SetpublicSaleKey, uint32 SetWL_Class, address _royalty, string memory baseURI) ERC721X("XBorg", "XBORG", MaxBatchSize, MaxSupply) {
1980         publicSaleKey = SetpublicSaleKey;
1981         WL_Class = SetWL_Class;
1982         royalties = _royalty;
1983         _baseTokenURI = baseURI;
1984     }
1985 
1986     modifier callerIsUser() {
1987         require(tx.origin == msg.sender, "The caller is another contract");
1988         _;
1989     }
1990 
1991     function flipSaleState() public onlyOwner {
1992         saleIsActive = !saleIsActive;
1993     }
1994 
1995     function flipPublicSaleState() public onlyOwner {
1996         PublicsaleIsActive = !PublicsaleIsActive;
1997         MaxMintPerWallet = 10;
1998         NFT_PRICE = 0.095 ether;
1999     }
2000 
2001     function mint(uint256 _Quantity, uint256 _WL, uint256 _CallerPublicSaleKey) external payable callerIsUser {
2002         require(saleIsActive, "Sale is not active at the moment");
2003         if(PublicsaleIsActive == false) {
2004             require(_WL == WL_Class, "You're not in WhiteList");
2005         }     
2006         require(publicSaleKey == _CallerPublicSaleKey, "Called with incorrect public sale key");
2007         require(totalSupply() + _Quantity <= MaxMintSupply, "Supply over the mint supply limit");
2008         require(numberMinted(msg.sender) + _Quantity <= MaxMintPerWallet,"Mint exceed the limit per wallet");
2009         require(NFT_PRICE * _Quantity <= msg.value, "Ether value sent is not correct");
2010         _safeMint(msg.sender, _Quantity);
2011     }
2012 
2013     function OwnerMint(uint256 _Quantity) external onlyOwner {     
2014         require(totalSupply() + _Quantity <= collectionSize, "Supply over the supply limit");
2015         _safeMint(msg.sender, _Quantity);
2016     }
2017 
2018     function _transfer(address from, address to, uint256 tokenId) internal override whenTokenNotStaked(tokenId) {
2019         super._transfer(from, to, tokenId);
2020     }
2021 
2022     function Burn(uint256 tokenId) external {           
2023         _burn(msg.sender, tokenId);
2024     }
2025 
2026     function setSaleConfig(uint32 key, uint256 MaxMint) external onlyOwner {
2027         publicSaleKey = key;
2028         MaxMintSupply = MaxMint;
2029     }
2030 
2031     function _baseURI() internal view virtual override returns (string memory) {
2032         return _baseTokenURI;
2033     }
2034 
2035     function lockMetadata() external onlyOwner {
2036         require(!isMetadataLocked, "Contract is locked");
2037         require(bytes(_baseTokenURI).length > 0, "BaseUri not set");
2038         isMetadataLocked = true;
2039         emit LockMetadata();
2040     }
2041 
2042     function setBaseURI(string calldata baseURI) external onlyOwner {
2043         require(!isMetadataLocked, "Contract is locked");
2044         _baseTokenURI = baseURI;
2045     }
2046 
2047     function withdraw() external onlyOwner {
2048         uint256 TotalBalance = address(this).balance;
2049         uint256 amount1 = TotalBalance.mul(50).div(100);
2050         uint256 amount2 = TotalBalance.mul(50).div(100);
2051 
2052         payable(WithDrawWallet1).transfer(amount1);
2053         payable(WithDrawWallet2).transfer(amount2);
2054 
2055         emit Withdraw(TotalBalance);
2056     }
2057 
2058     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2059         _setOwnersExplicit(quantity);
2060     }
2061 
2062     function numberMinted(address owner) public view returns (uint256) {
2063         return _numberMinted(owner);
2064     }
2065 
2066     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2067         return ownershipOf(tokenId);
2068     }
2069 
2070     function contractURI() public view returns (string memory) {
2071         return bytes(_baseTokenURI).length > 0 ? string(abi.encodePacked(_baseTokenURI, "XBORG.json")) : "";
2072     }
2073 
2074     function setRoyalties(address _royalties) public onlyOwner {
2075         royalties = _royalties;
2076     }
2077 
2078     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view override returns (address, uint256 royaltyAmount) {
2079         _tokenId; // silence solc warning
2080         royaltyAmount = (_salePrice / 100) * 5;
2081         return (royalties, royaltyAmount);
2082     }
2083 }