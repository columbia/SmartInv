1 // SPDX-License-Identifier: MIT
2 
3 // File: Users/mile.scan/Documents/GitHub/boncuk/contracts/Base64.sol
4 
5 
6 
7 /// @title Base64
8 /// @author Brecht Devos - <brecht@loopring.org>
9 /// @notice Provides a function for encoding some bytes in base64
10 pragma solidity ^0.8.2;
11 
12 library Base64 {
13     string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
14 
15     function encode(bytes memory data) internal pure returns (string memory) {
16         if (data.length == 0) return '';
17         
18         // load the table into memory
19         string memory table = TABLE;
20 
21         // multiply by 4/3 rounded up
22         uint256 encodedLen = 4 * ((data.length + 2) / 3);
23 
24         // add some extra buffer at the end required for the writing
25         string memory result = new string(encodedLen + 32);
26 
27         assembly {
28             // set the actual output length
29             mstore(result, encodedLen)
30             
31             // prepare the lookup table
32             let tablePtr := add(table, 1)
33             
34             // input ptr
35             let dataPtr := data
36             let endPtr := add(dataPtr, mload(data))
37             
38             // result ptr, jump over length
39             let resultPtr := add(result, 32)
40             
41             // run over the input, 3 bytes at a time
42             for {} lt(dataPtr, endPtr) {}
43             {
44                dataPtr := add(dataPtr, 3)
45                
46                // read 3 bytes
47                let input := mload(dataPtr)
48                
49                // write 4 characters
50                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
51                resultPtr := add(resultPtr, 1)
52                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
53                resultPtr := add(resultPtr, 1)
54                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
55                resultPtr := add(resultPtr, 1)
56                mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
57                resultPtr := add(resultPtr, 1)
58             }
59             
60             // padding with '='
61             switch mod(mload(data), 3)
62             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
63             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
64         }
65         
66         return result;
67     }
68 }
69 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
70 
71 
72 
73 pragma solidity ^0.8.0;
74 
75 // CAUTION
76 // This version of SafeMath should only be used with Solidity 0.8 or later,
77 // because it relies on the compiler's built in overflow checks.
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations.
81  *
82  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
83  * now has built in overflow checking.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, with an overflow flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             uint256 c = a + b;
94             if (c < a) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b > a) return (false, 0);
107             return (true, a - b);
108         }
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119             // benefit is lost if 'b' is also tested.
120             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121             if (a == 0) return (true, 0);
122             uint256 c = a * b;
123             if (c / a != b) return (false, 0);
124             return (true, c);
125         }
126     }
127 
128     /**
129      * @dev Returns the division of two unsigned integers, with a division by zero flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b == 0) return (false, 0);
136             return (true, a / b);
137         }
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b == 0) return (false, 0);
148             return (true, a % b);
149         }
150     }
151 
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a + b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a - b;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a * b;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator.
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a / b;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a % b;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * CAUTION: This function is deprecated because it requires allocating memory for the error
229      * message unnecessarily. For custom revert reasons use {trySub}.
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         unchecked {
243             require(b <= a, errorMessage);
244             return a - b;
245         }
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b > 0, errorMessage);
267             return a / b;
268         }
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * reverting with custom message when dividing by zero.
274      *
275      * CAUTION: This function is deprecated because it requires allocating memory for the error
276      * message unnecessarily. For custom revert reasons use {tryMod}.
277      *
278      * Counterpart to Solidity's `%` operator. This function uses a `revert`
279      * opcode (which leaves remaining gas untouched) while Solidity uses an
280      * invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function mod(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b > 0, errorMessage);
293             return a % b;
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Contract module that helps prevent reentrant calls to a function.
306  *
307  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
308  * available, which can be applied to functions to make sure there are no nested
309  * (reentrant) calls to them.
310  *
311  * Note that because there is a single `nonReentrant` guard, functions marked as
312  * `nonReentrant` may not call one another. This can be worked around by making
313  * those functions `private`, and then adding `external` `nonReentrant` entry
314  * points to them.
315  *
316  * TIP: If you would like to learn more about reentrancy and alternative ways
317  * to protect against it, check out our blog post
318  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
319  */
320 abstract contract ReentrancyGuard {
321     // Booleans are more expensive than uint256 or any type that takes up a full
322     // word because each write operation emits an extra SLOAD to first read the
323     // slot's contents, replace the bits taken up by the boolean, and then write
324     // back. This is the compiler's defense against contract upgrades and
325     // pointer aliasing, and it cannot be disabled.
326 
327     // The values being non-zero value makes deployment a bit more expensive,
328     // but in exchange the refund on every call to nonReentrant will be lower in
329     // amount. Since refunds are capped to a percentage of the total
330     // transaction's gas, it is best to keep them low in cases like this one, to
331     // increase the likelihood of the full refund coming into effect.
332     uint256 private constant _NOT_ENTERED = 1;
333     uint256 private constant _ENTERED = 2;
334 
335     uint256 private _status;
336 
337     constructor() {
338         _status = _NOT_ENTERED;
339     }
340 
341     /**
342      * @dev Prevents a contract from calling itself, directly or indirectly.
343      * Calling a `nonReentrant` function from another `nonReentrant`
344      * function is not supported. It is possible to prevent this from happening
345      * by making the `nonReentrant` function external, and make it call a
346      * `private` function that does the actual work.
347      */
348     modifier nonReentrant() {
349         // On the first call to nonReentrant, _notEntered will be true
350         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
351 
352         // Any calls to nonReentrant after this point will fail
353         _status = _ENTERED;
354 
355         _;
356 
357         // By storing the original value once again, a refund is triggered (see
358         // https://eips.ethereum.org/EIPS/eip-2200)
359         _status = _NOT_ENTERED;
360     }
361 }
362 
363 // File: @openzeppelin/contracts/utils/Strings.sol
364 
365 
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev String operations.
371  */
372 library Strings {
373     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
374 
375     /**
376      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
377      */
378     function toString(uint256 value) internal pure returns (string memory) {
379         // Inspired by OraclizeAPI's implementation - MIT licence
380         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
381 
382         if (value == 0) {
383             return "0";
384         }
385         uint256 temp = value;
386         uint256 digits;
387         while (temp != 0) {
388             digits++;
389             temp /= 10;
390         }
391         bytes memory buffer = new bytes(digits);
392         while (value != 0) {
393             digits -= 1;
394             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
395             value /= 10;
396         }
397         return string(buffer);
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
402      */
403     function toHexString(uint256 value) internal pure returns (string memory) {
404         if (value == 0) {
405             return "0x00";
406         }
407         uint256 temp = value;
408         uint256 length = 0;
409         while (temp != 0) {
410             length++;
411             temp >>= 8;
412         }
413         return toHexString(value, length);
414     }
415 
416     /**
417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
418      */
419     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
420         bytes memory buffer = new bytes(2 * length + 2);
421         buffer[0] = "0";
422         buffer[1] = "x";
423         for (uint256 i = 2 * length + 1; i > 1; --i) {
424             buffer[i] = _HEX_SYMBOLS[value & 0xf];
425             value >>= 4;
426         }
427         require(value == 0, "Strings: hex length insufficient");
428         return string(buffer);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Context.sol
433 
434 
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 // File: @openzeppelin/contracts/access/Ownable.sol
459 
460 
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() {
486         _setOwner(_msgSender());
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view virtual returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(owner() == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _setOwner(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _setOwner(newOwner);
522     }
523 
524     function _setOwner(address newOwner) private {
525         address oldOwner = _owner;
526         _owner = newOwner;
527         emit OwnershipTransferred(oldOwner, newOwner);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/utils/Address.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Collection of functions related to the address type
539  */
540 library Address {
541     /**
542      * @dev Returns true if `account` is a contract.
543      *
544      * [IMPORTANT]
545      * ====
546      * It is unsafe to assume that an address for which this function returns
547      * false is an externally-owned account (EOA) and not a contract.
548      *
549      * Among others, `isContract` will return false for the following
550      * types of addresses:
551      *
552      *  - an externally-owned account
553      *  - a contract in construction
554      *  - an address where a contract will be created
555      *  - an address where a contract lived, but was destroyed
556      * ====
557      */
558     function isContract(address account) internal view returns (bool) {
559         // This method relies on extcodesize, which returns 0 for contracts in
560         // construction, since the code is only stored at the end of the
561         // constructor execution.
562 
563         uint256 size;
564         assembly {
565             size := extcodesize(account)
566         }
567         return size > 0;
568     }
569 
570     /**
571      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
572      * `recipient`, forwarding all available gas and reverting on errors.
573      *
574      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
575      * of certain opcodes, possibly making contracts go over the 2300 gas limit
576      * imposed by `transfer`, making them unable to receive funds via
577      * `transfer`. {sendValue} removes this limitation.
578      *
579      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
580      *
581      * IMPORTANT: because control is transferred to `recipient`, care must be
582      * taken to not create reentrancy vulnerabilities. Consider using
583      * {ReentrancyGuard} or the
584      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
585      */
586     function sendValue(address payable recipient, uint256 amount) internal {
587         require(address(this).balance >= amount, "Address: insufficient balance");
588 
589         (bool success, ) = recipient.call{value: amount}("");
590         require(success, "Address: unable to send value, recipient may have reverted");
591     }
592 
593     /**
594      * @dev Performs a Solidity function call using a low level `call`. A
595      * plain `call` is an unsafe replacement for a function call: use this
596      * function instead.
597      *
598      * If `target` reverts with a revert reason, it is bubbled up by this
599      * function (like regular Solidity function calls).
600      *
601      * Returns the raw returned data. To convert to the expected return value,
602      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
603      *
604      * Requirements:
605      *
606      * - `target` must be a contract.
607      * - calling `target` with `data` must not revert.
608      *
609      * _Available since v3.1._
610      */
611     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
612         return functionCall(target, data, "Address: low-level call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
617      * `errorMessage` as a fallback revert reason when `target` reverts.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(
622         address target,
623         bytes memory data,
624         string memory errorMessage
625     ) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, 0, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but also transferring `value` wei to `target`.
632      *
633      * Requirements:
634      *
635      * - the calling contract must have an ETH balance of at least `value`.
636      * - the called Solidity function must be `payable`.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(
641         address target,
642         bytes memory data,
643         uint256 value
644     ) internal returns (bytes memory) {
645         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
650      * with `errorMessage` as a fallback revert reason when `target` reverts.
651      *
652      * _Available since v3.1._
653      */
654     function functionCallWithValue(
655         address target,
656         bytes memory data,
657         uint256 value,
658         string memory errorMessage
659     ) internal returns (bytes memory) {
660         require(address(this).balance >= value, "Address: insufficient balance for call");
661         require(isContract(target), "Address: call to non-contract");
662 
663         (bool success, bytes memory returndata) = target.call{value: value}(data);
664         return verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but performing a static call.
670      *
671      * _Available since v3.3._
672      */
673     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
674         return functionStaticCall(target, data, "Address: low-level static call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a static call.
680      *
681      * _Available since v3.3._
682      */
683     function functionStaticCall(
684         address target,
685         bytes memory data,
686         string memory errorMessage
687     ) internal view returns (bytes memory) {
688         require(isContract(target), "Address: static call to non-contract");
689 
690         (bool success, bytes memory returndata) = target.staticcall(data);
691         return verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
696      * but performing a delegate call.
697      *
698      * _Available since v3.4._
699      */
700     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
701         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
706      * but performing a delegate call.
707      *
708      * _Available since v3.4._
709      */
710     function functionDelegateCall(
711         address target,
712         bytes memory data,
713         string memory errorMessage
714     ) internal returns (bytes memory) {
715         require(isContract(target), "Address: delegate call to non-contract");
716 
717         (bool success, bytes memory returndata) = target.delegatecall(data);
718         return verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     /**
722      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
723      * revert reason using the provided one.
724      *
725      * _Available since v4.3._
726      */
727     function verifyCallResult(
728         bool success,
729         bytes memory returndata,
730         string memory errorMessage
731     ) internal pure returns (bytes memory) {
732         if (success) {
733             return returndata;
734         } else {
735             // Look for revert reason and bubble it up if present
736             if (returndata.length > 0) {
737                 // The easiest way to bubble the revert reason is using memory via assembly
738 
739                 assembly {
740                     let returndata_size := mload(returndata)
741                     revert(add(32, returndata), returndata_size)
742                 }
743             } else {
744                 revert(errorMessage);
745             }
746         }
747     }
748 }
749 
750 
751 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
752 
753 
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @title ERC721 token receiver interface
759  * @dev Interface for any contract that wants to support safeTransfers
760  * from ERC721 asset contracts.
761  */
762 interface IERC721Receiver {
763     /**
764      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
765      * by `operator` from `from`, this function is called.
766      *
767      * It must return its Solidity selector to confirm the token transfer.
768      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
769      *
770      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
771      */
772     function onERC721Received(
773         address operator,
774         address from,
775         uint256 tokenId,
776         bytes calldata data
777     ) external returns (bytes4);
778 }
779 
780 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
781 
782 
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @dev Interface of the ERC165 standard, as defined in the
788  * https://eips.ethereum.org/EIPS/eip-165[EIP].
789  *
790  * Implementers can declare support of contract interfaces, which can then be
791  * queried by others ({ERC165Checker}).
792  *
793  * For an implementation, see {ERC165}.
794  */
795 interface IERC165 {
796     /**
797      * @dev Returns true if this contract implements the interface defined by
798      * `interfaceId`. See the corresponding
799      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
800      * to learn more about how these ids are created.
801      *
802      * This function call must use less than 30 000 gas.
803      */
804     function supportsInterface(bytes4 interfaceId) external view returns (bool);
805 }
806 
807 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
808 
809 
810 
811 pragma solidity ^0.8.0;
812 
813 
814 /**
815  * @dev Implementation of the {IERC165} interface.
816  *
817  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
818  * for the additional interface id that will be supported. For example:
819  *
820  * ```solidity
821  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
822  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
823  * }
824  * ```
825  *
826  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
827  */
828 abstract contract ERC165 is IERC165 {
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
833         return interfaceId == type(IERC165).interfaceId;
834     }
835 }
836 
837 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
838 
839 
840 
841 pragma solidity ^0.8.0;
842 
843 
844 /**
845  * @dev Required interface of an ERC721 compliant contract.
846  */
847 interface IERC721 is IERC165 {
848     /**
849      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
850      */
851     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
852 
853     /**
854      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
855      */
856     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
857 
858     /**
859      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
860      */
861     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
862 
863     /**
864      * @dev Returns the number of tokens in ``owner``'s account.
865      */
866     function balanceOf(address owner) external view returns (uint256 balance);
867 
868     /**
869      * @dev Returns the owner of the `tokenId` token.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      */
875     function ownerOf(uint256 tokenId) external view returns (address owner);
876 
877     /**
878      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
879      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
880      *
881      * Requirements:
882      *
883      * - `from` cannot be the zero address.
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must exist and be owned by `from`.
886      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) external;
896 
897     /**
898      * @dev Transfers `tokenId` token from `from` to `to`.
899      *
900      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
901      *
902      * Requirements:
903      *
904      * - `from` cannot be the zero address.
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must be owned by `from`.
907      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
908      *
909      * Emits a {Transfer} event.
910      */
911     function transferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) external;
916 
917     /**
918      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
919      * The approval is cleared when the token is transferred.
920      *
921      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
922      *
923      * Requirements:
924      *
925      * - The caller must own the token or be an approved operator.
926      * - `tokenId` must exist.
927      *
928      * Emits an {Approval} event.
929      */
930     function approve(address to, uint256 tokenId) external;
931 
932     /**
933      * @dev Returns the account approved for `tokenId` token.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function getApproved(uint256 tokenId) external view returns (address operator);
940 
941     /**
942      * @dev Approve or remove `operator` as an operator for the caller.
943      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
944      *
945      * Requirements:
946      *
947      * - The `operator` cannot be the caller.
948      *
949      * Emits an {ApprovalForAll} event.
950      */
951     function setApprovalForAll(address operator, bool _approved) external;
952 
953     /**
954      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
955      *
956      * See {setApprovalForAll}
957      */
958     function isApprovedForAll(address owner, address operator) external view returns (bool);
959 
960     /**
961      * @dev Safely transfers `tokenId` token from `from` to `to`.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must exist and be owned by `from`.
968      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes calldata data
978     ) external;
979 }
980 
981 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
982 
983 
984 
985 pragma solidity ^0.8.0;
986 
987 
988 /**
989  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
990  * @dev See https://eips.ethereum.org/EIPS/eip-721
991  */
992 interface IERC721Metadata is IERC721 {
993     /**
994      * @dev Returns the token collection name.
995      */
996     function name() external view returns (string memory);
997 
998     /**
999      * @dev Returns the token collection symbol.
1000      */
1001     function symbol() external view returns (string memory);
1002 
1003     /**
1004      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1005      */
1006     function tokenURI(uint256 tokenId) external view returns (string memory);
1007 }
1008 
1009 
1010 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1011 
1012 
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 /**
1024  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1025  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1026  * {ERC721Enumerable}.
1027  */
1028 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1029     using Address for address;
1030     using Strings for uint256;
1031 
1032     // Token name
1033     string private _name;
1034 
1035     // Token symbol
1036     string private _symbol;
1037 
1038     // Mapping from token ID to owner address
1039     mapping(uint256 => address) private _owners;
1040 
1041     // Mapping owner address to token count
1042     mapping(address => uint256) private _balances;
1043 
1044     // Mapping from token ID to approved address
1045     mapping(uint256 => address) private _tokenApprovals;
1046 
1047     // Mapping from owner to operator approvals
1048     mapping(address => mapping(address => bool)) private _operatorApprovals;
1049 
1050     /**
1051      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1052      */
1053     constructor(string memory name_, string memory symbol_) {
1054         _name = name_;
1055         _symbol = symbol_;
1056     }
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1062         return
1063             interfaceId == type(IERC721).interfaceId ||
1064             interfaceId == type(IERC721Metadata).interfaceId ||
1065             super.supportsInterface(interfaceId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-balanceOf}.
1070      */
1071     function balanceOf(address owner) public view virtual override returns (uint256) {
1072         require(owner != address(0), "ERC721: balance query for the zero address");
1073         return _balances[owner];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-ownerOf}.
1078      */
1079     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1080         address owner = _owners[tokenId];
1081         require(owner != address(0), "ERC721: owner query for nonexistent token");
1082         return owner;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-name}.
1087      */
1088     function name() public view virtual override returns (string memory) {
1089         return _name;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-symbol}.
1094      */
1095     function symbol() public view virtual override returns (string memory) {
1096         return _symbol;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Metadata-tokenURI}.
1101      */
1102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1103         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1104 
1105         string memory baseURI = _baseURI();
1106         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1107     }
1108 
1109     /**
1110      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1111      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1112      * by default, can be overriden in child contracts.
1113      */
1114     function _baseURI() internal view virtual returns (string memory) {
1115         return "";
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-approve}.
1120      */
1121     function approve(address to, uint256 tokenId) public virtual override {
1122         address owner = ERC721.ownerOf(tokenId);
1123         require(to != owner, "ERC721: approval to current owner");
1124 
1125         require(
1126             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1127             "ERC721: approve caller is not owner nor approved for all"
1128         );
1129 
1130         _approve(to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-getApproved}.
1135      */
1136     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1137         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1138 
1139         return _tokenApprovals[tokenId];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-setApprovalForAll}.
1144      */
1145     function setApprovalForAll(address operator, bool approved) public virtual override {
1146         require(operator != _msgSender(), "ERC721: approve to caller");
1147 
1148         _operatorApprovals[_msgSender()][operator] = approved;
1149         emit ApprovalForAll(_msgSender(), operator, approved);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-isApprovedForAll}.
1154      */
1155     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1156         return _operatorApprovals[owner][operator];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-transferFrom}.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         //solhint-disable-next-line max-line-length
1168         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1169 
1170         _transfer(from, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-safeTransferFrom}.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) public virtual override {
1181         safeTransferFrom(from, to, tokenId, "");
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) public virtual override {
1193         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1194         _safeTransfer(from, to, tokenId, _data);
1195     }
1196 
1197     /**
1198      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1199      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1200      *
1201      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1202      *
1203      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1204      * implement alternative mechanisms to perform token transfer, such as signature-based.
1205      *
1206      * Requirements:
1207      *
1208      * - `from` cannot be the zero address.
1209      * - `to` cannot be the zero address.
1210      * - `tokenId` token must exist and be owned by `from`.
1211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeTransfer(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) internal virtual {
1221         _transfer(from, to, tokenId);
1222         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1223     }
1224 
1225     /**
1226      * @dev Returns whether `tokenId` exists.
1227      *
1228      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1229      *
1230      * Tokens start existing when they are minted (`_mint`),
1231      * and stop existing when they are burned (`_burn`).
1232      */
1233     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1234         return _owners[tokenId] != address(0);
1235     }
1236 
1237     /**
1238      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      */
1244     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1245         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1246         address owner = ERC721.ownerOf(tokenId);
1247         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1248     }
1249 
1250     /**
1251      * @dev Safely mints `tokenId` and transfers it to `to`.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must not exist.
1256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _safeMint(address to, uint256 tokenId) internal virtual {
1261         _safeMint(to, tokenId, "");
1262     }
1263 
1264     /**
1265      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1266      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1267      */
1268     function _safeMint(
1269         address to,
1270         uint256 tokenId,
1271         bytes memory _data
1272     ) internal virtual {
1273         _mint(to, tokenId);
1274         require(
1275             _checkOnERC721Received(address(0), to, tokenId, _data),
1276             "ERC721: transfer to non ERC721Receiver implementer"
1277         );
1278     }
1279 
1280     /**
1281      * @dev Mints `tokenId` and transfers it to `to`.
1282      *
1283      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must not exist.
1288      * - `to` cannot be the zero address.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _mint(address to, uint256 tokenId) internal virtual {
1293         require(to != address(0), "ERC721: mint to the zero address");
1294         require(!_exists(tokenId), "ERC721: token already minted");
1295 
1296         _beforeTokenTransfer(address(0), to, tokenId);
1297 
1298         _balances[to] += 1;
1299         _owners[tokenId] = to;
1300 
1301         emit Transfer(address(0), to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Destroys `tokenId`.
1306      * The approval is cleared when the token is burned.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _burn(uint256 tokenId) internal virtual {
1315         address owner = ERC721.ownerOf(tokenId);
1316 
1317         _beforeTokenTransfer(owner, address(0), tokenId);
1318 
1319         // Clear approvals
1320         _approve(address(0), tokenId);
1321 
1322         _balances[owner] -= 1;
1323         delete _owners[tokenId];
1324 
1325         emit Transfer(owner, address(0), tokenId);
1326     }
1327 
1328     /**
1329      * @dev Transfers `tokenId` from `from` to `to`.
1330      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1331      *
1332      * Requirements:
1333      *
1334      * - `to` cannot be the zero address.
1335      * - `tokenId` token must be owned by `from`.
1336      *
1337      * Emits a {Transfer} event.
1338      */
1339     function _transfer(
1340         address from,
1341         address to,
1342         uint256 tokenId
1343     ) internal virtual {
1344         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1345         require(to != address(0), "ERC721: transfer to the zero address");
1346 
1347         _beforeTokenTransfer(from, to, tokenId);
1348 
1349         // Clear approvals from the previous owner
1350         _approve(address(0), tokenId);
1351 
1352         _balances[from] -= 1;
1353         _balances[to] += 1;
1354         _owners[tokenId] = to;
1355 
1356         emit Transfer(from, to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Approve `to` to operate on `tokenId`
1361      *
1362      * Emits a {Approval} event.
1363      */
1364     function _approve(address to, uint256 tokenId) internal virtual {
1365         _tokenApprovals[tokenId] = to;
1366         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1367     }
1368 
1369     /**
1370      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1371      * The call is not executed if the target address is not a contract.
1372      *
1373      * @param from address representing the previous owner of the given token ID
1374      * @param to target address that will receive the tokens
1375      * @param tokenId uint256 ID of the token to be transferred
1376      * @param _data bytes optional data to send along with the call
1377      * @return bool whether the call correctly returned the expected magic value
1378      */
1379     function _checkOnERC721Received(
1380         address from,
1381         address to,
1382         uint256 tokenId,
1383         bytes memory _data
1384     ) private returns (bool) {
1385         if (to.isContract()) {
1386             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1387                 return retval == IERC721Receiver.onERC721Received.selector;
1388             } catch (bytes memory reason) {
1389                 if (reason.length == 0) {
1390                     revert("ERC721: transfer to non ERC721Receiver implementer");
1391                 } else {
1392                     assembly {
1393                         revert(add(32, reason), mload(reason))
1394                     }
1395                 }
1396             }
1397         } else {
1398             return true;
1399         }
1400     }
1401 
1402     /**
1403      * @dev Hook that is called before any token transfer. This includes minting
1404      * and burning.
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1412      * - `from` and `to` are never both zero.
1413      *
1414      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1415      */
1416     function _beforeTokenTransfer(
1417         address from,
1418         address to,
1419         uint256 tokenId
1420     ) internal virtual {}
1421 }
1422 
1423 // File: Users/mile.scan/Documents/GitHub/boncuk/contracts/boncuk.sol
1424 
1425 
1426 
1427 /*
1428     
1429     boncuk
1430     
1431 */
1432 
1433 pragma solidity ^0.8.2;
1434 
1435 
1436 
1437 
1438 
1439 
1440 
1441 contract boncuk is
1442     ERC721,
1443     ReentrancyGuard,
1444     Ownable
1445 {
1446     using SafeMath for uint256;
1447     using Strings for uint256;
1448     using Strings for uint160;
1449     using Strings for uint8;
1450     using Base64 for bytes;
1451     uint256 public boncuk_count;
1452     string public _description;
1453     string public _external_url;
1454     uint MAX_SUPPLY = 1024;
1455     uint MAX_MINT_PER_ADDRESS = 8;
1456 
1457     mapping(uint256 => uint256) private _dnaBank;
1458     mapping(uint256 => uint8) private _bokehBank;
1459     mapping(address => uint8) private _minters;
1460 
1461     function setMinter(address _minter) private {
1462         _minters[_minter] = _minters[_minter] + 1;
1463     }
1464     function didMint(address _minter) private view returns (bool){
1465         return _minters[_minter] == MAX_MINT_PER_ADDRESS;
1466     }
1467     function setDescription(string memory _d) public onlyOwner {
1468         require(msg.sender == tx.origin);
1469         _description = _d;
1470     }
1471     function setExternalUrl(string memory _u) public onlyOwner {
1472         require(msg.sender == tx.origin);
1473         _external_url = _u;
1474     }
1475     function setBokeh(uint _i, uint8 _b) public nonReentrant {
1476         require(ownerOf(_i) == msg.sender, "mind your own boncuk");
1477         require(_b > 0 && _b < 100, "bokeh can be set between 1 - 99");
1478         _bokehBank[_i] = _b % 100;
1479     }
1480     
1481     function random() private view returns (uint256) {
1482         return uint256(keccak256(abi.encodePacked(msg.sender, _dnaBank[boncuk_count-1])));
1483     }
1484 
1485     function _mint(address _to) private {
1486         if (_to != owner()){
1487             setMinter(_to);
1488         }
1489         boncuk_count = boncuk_count.add(1);
1490         _dnaBank[boncuk_count] = random();
1491         _safeMint(_to, boncuk_count);
1492     }
1493 
1494     function mint() external nonReentrant {
1495         require(msg.sender == tx.origin);
1496         require(boncuk_count.add(2) <= MAX_SUPPLY, string(abi.encodePacked("only ", MAX_SUPPLY.toString(), " of them will ever exist")));
1497         require(didMint(msg.sender) == false, string(abi.encodePacked(MAX_MINT_PER_ADDRESS.toString(), " mints per address is allowed")));
1498         _mint(msg.sender);
1499         // angels' share
1500         if (boncuk_count % 8 == 7) {
1501             _mint(address(owner()));
1502         }
1503     }
1504     
1505     // dna structs
1506     
1507     struct s_c {
1508         string _r;
1509         string _g;
1510         string _b;
1511     }
1512     
1513     struct s_e {
1514         uint r_y;
1515         uint r_x;
1516         uint c_y;
1517         uint c_x;
1518     }
1519     
1520     struct s_r {
1521         uint r_0;
1522         uint r_1;
1523         string r_s;
1524     }
1525     
1526     struct DNA_Decoded {
1527         uint b_;
1528         uint e_1_r_x;
1529         s_c e_1_c;
1530         string e_1_c_a;
1531         s_e e_2;
1532         s_e e_3;
1533         s_c e_3_c;
1534         string e_3_c_a;
1535         s_e e_4;
1536         s_r r_;
1537     }
1538     
1539     // dna helpers
1540     
1541     function _g_c(uint _i, uint _p) private view returns (string memory) {
1542         return ((_dnaBank[_i] / (255 ** _p)) % 255).toString();
1543     }
1544     
1545     function g_c(uint _i, uint _o) private view returns (s_c memory) {
1546         return s_c(_g_c(_i, (0 + _o)), _g_c(_i, (1 + _o)), _g_c(_i, (2 + _o)));
1547     }
1548     
1549     function g_r_x(uint _i, uint _r, uint _s) private view returns (uint) {
1550         return _r - (_r / 20) + ((_dnaBank[_i] / 64) % (_r / (10 * _s)));
1551     }
1552     
1553     function g_n_r(uint _i, uint _p_r) private view returns (uint) {
1554         return (_p_r / 2) + ((_dnaBank[_i] / 128) % (_p_r / 3));
1555     }
1556     
1557     function g_n_c(uint _i, uint _p_r, uint _n_r, uint _p_c, uint _s) private view returns (uint) {
1558         uint _d = ((_p_r - _n_r) * 35) / 100;
1559         return _p_c - _d + ((_dnaBank[_i] / (255 * _s)) % (_d * 2));
1560     }
1561 
1562     function g_s_e(uint _i, uint _p_r, uint _p_c_y, uint _p_c_x) private view returns (s_e memory) {
1563         uint _n_r = g_n_r(_i, _p_r);
1564         return s_e(
1565             _n_r,
1566             g_r_x(_i, _n_r, 1),
1567             g_n_c(_i, _p_r, _n_r, _p_c_y, 1),
1568             g_n_c(_i, _p_r, _n_r, _p_c_x, 2));
1569     }
1570     
1571     function g_s_r(uint _i) private view returns (s_r memory) {
1572         uint _r = 360 * ((_dnaBank[_i] / 1025) % 2);
1573         return s_r(_r, (360 - _r), (8 + ((_dnaBank[_i] / 2048) % 25)).toString());
1574     }
1575     
1576     function g_c_a(uint _i, uint _p, uint _d) private view returns (string memory) {
1577         return (_d + (_dnaBank[_i] / 10 ** _p) % 5).toString();
1578     }
1579     
1580     function g_b(uint _i) private view returns (uint) {
1581         return 80 + (_dnaBank[_i] / 1024) % 20;
1582     }
1583     
1584     // dna decoder
1585     
1586     function decode_dna(uint _i) private view returns (DNA_Decoded memory) {
1587         uint b_ = g_b(_i);
1588         uint e_1_r_x = g_r_x(_i, 512, 2);
1589         s_c memory e_1_c = g_c(_i, 3);
1590         string memory e_1_c_a = g_c_a(_i, 4, 5);
1591         s_e memory e_2 = g_s_e(_i, 512, 512, 512);
1592         s_e memory e_3 = g_s_e(_i, e_2.r_y, e_2.c_y, e_2.c_x);
1593         s_c memory e_3_c = g_c(_i, 5);
1594         string memory e_3_c_a = g_c_a(_i, 6, 1);
1595         s_e memory e_4 = g_s_e(_i, e_3.r_y, e_3.c_y, e_3.c_x);
1596         s_r memory r_ = g_s_r(_i);
1597         DNA_Decoded memory d = DNA_Decoded(b_, e_1_r_x, e_1_c, e_1_c_a, e_2, e_3, e_3_c, e_3_c_a, e_4, r_);
1598         return d;
1599     }
1600     
1601     // render helpers
1602     
1603     function s_g_t(address _o) private pure returns (string memory) {
1604         string memory _s;
1605         string memory _g;
1606         string memory _t;
1607         string memory _a = uint160(_o).toHexString();
1608         {
1609             _s = '<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">';
1610             _g = '<g>';
1611             _t = string(abi.encodePacked('<title>', _a, '</title>'));
1612         }
1613         return string(abi.encodePacked(_s, _g, _t));
1614     }
1615 
1616     function e_1_2_3_4(DNA_Decoded memory _d) private pure returns (string memory) {
1617         string memory _e_1;
1618         string memory _e_2;
1619         string memory _e_3;
1620         string memory _e_3_f;
1621         string memory _e_4;
1622         {
1623             _e_1 = string(abi.encodePacked('<ellipse ry="512" rx="', _d.e_1_r_x.toString(), '" cy="512" cx="512" fill="url(#e_1_g)"/>'));
1624         }
1625         {
1626             _e_2 = string(
1627                 abi.encodePacked(
1628                     '<ellipse ry="',_d.e_2.r_y.toString(),
1629                     '" rx="', _d.e_2.r_x.toString(),
1630                     '" cy="', _d.e_2.c_y.toString(),
1631                     '" cx="', _d.e_2.c_x.toString(),
1632                     '" fill="#FFF"/>'));
1633         }
1634         {
1635             _e_3_f = string(abi.encodePacked('rgba(', _d.e_3_c._r, ',', _d.e_3_c._g, ',', _d.e_3_c._b, ',0.', _d.e_3_c_a,')'));
1636         }
1637         {
1638             _e_3 = string(
1639                 abi.encodePacked(
1640                     '<ellipse ry="', _d.e_3.r_y.toString(),
1641                     '" rx="', _d.e_3.r_x.toString(),
1642                     '" cy="', _d.e_3.c_y.toString(),
1643                     '" cx="', _d.e_3.c_x.toString(),
1644                     '" fill="', _e_3_f, '"/>'));
1645         }
1646         {
1647             _e_4 = string(
1648                 abi.encodePacked(
1649                     '<ellipse ry="', _d.e_4.r_y.toString(),
1650                     '" rx="', _d.e_4.r_x.toString(),
1651                     '" cy="', _d.e_4.c_y.toString(),
1652                     '" cx="', _d.e_4.c_x.toString(),
1653                     '" fill="rgba(22, 24, 150, 0.8)"/>'));
1654         }
1655         return string(abi.encodePacked(_e_1, _e_2, _e_3, _e_4));
1656     }
1657 
1658     function a_d_r_g(DNA_Decoded memory _d) private pure returns (string memory) {
1659         string memory _a;
1660         string memory _de;
1661         string memory _r_g;
1662         {
1663             _a = string(
1664                 abi.encodePacked(
1665                     '<animateTransform attributeName="transform" begin="0s" dur="', _d.r_.r_s, 's" type="rotate" from="',
1666                     _d.r_.r_0.toString(), ' 512 512" to="', _d.r_.r_1.toString(), ' 512 512" repeatCount="indefinite"/>'));
1667             _de = '<defs>';
1668            _r_g = '<radialGradient id="e_1_g">';
1669         }
1670         return string(abi.encodePacked(_a, _de, _r_g));
1671     }
1672 
1673     function s_o(DNA_Decoded memory _d, uint _i) private view returns (string memory) {
1674         uint _b;
1675         string memory _s_o_0;
1676         string memory _s_o_1;
1677         string memory _s_o_2;
1678         {
1679             if (_bokehBank[_i] != 0) {
1680                 _b = 80 + ((100 - _bokehBank[_i]) / 5);
1681             } else {
1682                 _b = _d.b_;
1683             }
1684         }
1685         {
1686             _s_o_0 = '<stop offset="30%" stop-color="#000"/>';
1687             _s_o_1 = string(abi.encodePacked('<stop offset="', _b.toString(), '%" stop-color="rgba(', _d.e_1_c._r, ',', _d.e_1_c._g, ',', _d.e_1_c._b, ',0.', _d.e_1_c_a,')"/>'));
1688             _s_o_2 = '<stop offset="100%" stop-color="rgba(255,255,255,0.1)"/>';
1689         }
1690         return string(abi.encodePacked(_s_o_0, _s_o_1, _s_o_2));
1691     }
1692 
1693     function r_d_g_s() private pure returns (string memory) {
1694         string memory _r_g;
1695         string memory _d;
1696         string memory _g;
1697         string memory _s;
1698         {
1699             _r_g = '</radialGradient>';
1700             _d = '</defs>';
1701             _g = '</g>';
1702             _s = '</svg>';
1703         }
1704         return string(abi.encodePacked(_r_g, _d, _g, _s));
1705     }
1706     
1707     // render function
1708 
1709     function render(uint _i) private view returns (string memory) {
1710         DNA_Decoded memory _d = decode_dna(_i);
1711         return string(abi.encodePacked(
1712             s_g_t(ownerOf(_i)),
1713             e_1_2_3_4(_d),
1714             a_d_r_g(_d),
1715             s_o(_d, _i),
1716             r_d_g_s()
1717         ));
1718     }
1719 
1720     // encoded render function
1721 
1722     function render_encoded(uint _i) private view returns (string memory) {
1723         return string(bytes(abi.encodePacked(render(_i))).encode());
1724     }
1725     
1726     // metadata attributes helpers
1727     
1728     function o_w(DNA_Decoded memory _d) private pure returns (string memory) {
1729         return ((1000 * (512 - _d.e_1_r_x)) / 512).toString();
1730     }
1731 
1732     function i_w(s_e memory _s_e) private pure returns (string memory) {
1733         uint _r_x = _s_e.r_x;
1734         uint _r_y = _s_e.r_y;
1735         if (_r_x > _r_y) {
1736             return ((
1737                 1000 * (_r_x - _r_y)
1738             ) / _r_x).toString();
1739         }
1740         return ((
1741             1000 * (_r_y - _r_x)
1742         ) / _r_y).toString();
1743     }
1744 
1745     function w_a(DNA_Decoded memory _d) private pure returns (string memory) {
1746         return string(
1747             abi.encodePacked(
1748                 '{"trait_type": "eye socket warp", "value": ',
1749                 o_w(_d),
1750                 '}, {"trait_type": "eye warp", "value": ',
1751                 i_w(_d.e_2),
1752                 '}, {"trait_type": "iris warp", "value": ',
1753                 i_w(_d.e_3),
1754                 '}, {"trait_type": "pupil warp", "value": ',
1755                 i_w(_d.e_4),
1756                 '}, '
1757             )
1758         );
1759     }
1760 
1761     function s_a(DNA_Decoded memory _d) private pure returns (string memory) {
1762         return string(
1763             abi.encodePacked(
1764                 '{"trait_type": "eye size", "value": ',
1765                 _d.e_2.r_x.toString(),
1766                 '}, {"trait_type": "iris size", "value": ',
1767                 _d.e_3.r_x.toString(),
1768                 '},  {"trait_type": "pupil size", "value": ',
1769                 _d.e_4.r_x.toString(),
1770                 '},'
1771             )
1772         );
1773     }
1774 
1775     function b_a(DNA_Decoded memory _d, uint _i) private view returns (string memory) {
1776         if(_bokehBank[_i] != 0) {
1777             return string(abi.encodePacked(_bokehBank[_i].toString()));
1778         }
1779         return string(abi.encodePacked(((100 - _d.b_) * 5).toString()));
1780     }
1781 
1782     function c_a(DNA_Decoded memory _d, uint _i) private view returns (string memory) {
1783         string memory l_c;
1784         string memory i_c;
1785         string memory b_c;
1786         string memory b_t;
1787         string memory b_t_a;
1788         {
1789             l_c = string(abi.encodePacked('{"trait_type": "eye lid color red", "value": ', _d.e_1_c._r, '}, {"trait_type": "eye lid color green", "value": ', _d.e_1_c._g, '}, {"trait_type": "eye lid color blue", "value": ', _d.e_1_c._b, '}, {"trait_type": "eye lid color transparency", "value": ', _d.e_1_c_a, '0},'));
1790         }
1791         {
1792             i_c = string(abi.encodePacked('{"trait_type": "eye lid color red", "value": ', _d.e_3_c._r, '}, {"trait_type": "eye lid color green", "value": ', _d.e_3_c._g, '}, {"trait_type": "eye lid color blue", "value": ', _d.e_3_c._b, '}, {"trait_type": "eye lid color transparency", "value": ', _d.e_3_c_a, '0},'));
1793         }
1794         {   
1795             b_c = string(abi.encodePacked('{"trait_type": "bokeh", "value": ', b_a(_d, _i)));
1796         }
1797         {
1798             if(_bokehBank[_i] == 0) {
1799                 b_t_a = 'no';
1800             } else {
1801                 b_t_a = 'yes';
1802             }
1803             b_t = string(abi.encodePacked('}, {"trait_type": "bokeh altered", "value": "', b_t_a));
1804         }
1805         return string(
1806             abi.encodePacked(
1807                 l_c,
1808                 i_c,
1809                 b_c,
1810                 b_t,
1811                 '"},'
1812             )
1813         );
1814     }
1815 
1816     function r_a(DNA_Decoded memory _d) private pure returns (string memory) {
1817         return string(
1818             abi.encodePacked(
1819                 '{"trait_type": "full rotation time", "value": ',
1820                 _d.r_.r_s,
1821                 '}, {"trait_type": "rotation direction", "value": "',
1822                 _d.r_.r_0 == 0 ? 'clockwise' : 'counter-clockwise',
1823                 '"}'
1824             )
1825         );
1826     }
1827 
1828     // metadata attribute generation
1829 
1830     function getAttributes(uint _i)
1831         private
1832         view
1833         returns (string memory)
1834     {
1835         DNA_Decoded memory _d = decode_dna(_i);
1836         return string(abi.encodePacked('[', w_a(_d), s_a(_d), c_a(_d, _i), r_a(_d), ']'));
1837     }
1838     
1839     // tokenURI for ERC721
1840 
1841     function tokenURI(uint256 _i)
1842         public
1843         view
1844         override(ERC721)
1845         returns (string memory)
1846     {
1847         super.tokenURI(_i);
1848         return
1849             string(
1850                 abi.encodePacked(
1851                     "data:application/json;base64,",
1852                     bytes(
1853                         abi.encodePacked(
1854                             '{"attributes": ', getAttributes(_i),
1855                             ', "name": "boncuk #', _i.toString(),
1856                             '", "description": "', _description,
1857                             '", "external_url": "', _external_url,
1858                             '", "image": "data:image/svg+xml;base64,',
1859                             render_encoded(_i),
1860                             '"}'
1861                         )
1862                     ).encode(),
1863                     "#"
1864                 )
1865             );
1866     }
1867     
1868     // contractURI for OpenSea
1869   
1870     function contractURI() public view returns (string memory) {
1871         return
1872             string(
1873                 abi.encodePacked(
1874                     "data:application/json;base64,",
1875                     bytes(
1876                         abi.encodePacked(
1877                             '{"name": "boncuk", "description": "', _description,
1878                             '", "external_link": "', _external_url,
1879                             '", "image": "data:image/svg+xml;base64,',
1880                             render_encoded(1),
1881                             '"}'
1882                         )
1883                     ).encode()
1884                 )
1885             );
1886     }
1887     
1888     // Derived 721 contract must override function “supportsInterface”
1889 
1890     function supportsInterface(bytes4 interfaceId)
1891         public
1892         view
1893         virtual
1894         override(ERC721)
1895         returns (bool)
1896     {
1897         return super.supportsInterface(interfaceId);
1898     }
1899      
1900     // constructor populating description, externalUrl, and the genesis NFT for the contractURI
1901 
1902     constructor()
1903         ERC721("boncuk", "boncuk")
1904         onlyOwner
1905     {
1906         setDescription(string(abi.encodePacked(MAX_SUPPLY.toString(), " on-chain stored and dynamically displayed 1024 x 1024 SVG evil eyes")));
1907         setExternalUrl("https://en.wikipedia.org/wiki/Evil_eye");
1908         // angels' share
1909         _mint(address(owner()));
1910     }
1911 }