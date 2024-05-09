1 // SPDX-License-Identifier: MIT
2 /*
3                               ▄▄▄████████▄▄▄
4                           ▄▄███▀▀▀       ▀▀███▄▄       ▄██▄
5                       ▄▄███▀                  ▀██▄    ▄██▀██▄
6     ▄▄          ▄▄▄███▀▀                       ▀██▄▄██▀  ▄███
7     ▀████████████▀▀▀                          ▄▄▄▄█████▄███▀▀
8      ▀██                                 ▄▄███▀▀▀▀▀▀███▀
9       ▀██▄                 ▄▄▄▄▄▄▄▄▄▄████▀▀          ▀█▌
10         ▀██▄                ▀▀▀▀▀▀▀▀▀▀               ▐██
11           ███▄                                       ██▌
12           ██▀██▄▄                                  ▄███▌
13          ██▌   ▀███▄▄                            ▄██▀ ██
14          ██       ▀▀████▄▄▄▄               ▄▄▄███▀▀   ▐█▌
15          ▐██            ▀▀▀████████████████▀▀▀▀       ▐██
16           ██                                          ▐██
17            █▌                                         ▐█▌
18           ██     ▄    ▄             ▄     ▄           ██
19          ▐█▌     ▀████▀             ▀█████▀          ▐██
20          ▐██              ████████                  ▄██
21           ██▌              ▀▀▀▀▀▀                  ▄██
22            ▀██▄                                   ██▀
23              ▀██▄                              ▄███
24                ▀▀██▄▄                       ▄▄██▀
25                    ▀▀████▄▄▄▄▄        ▄▄▄▄███▀▀
26                         ▀▀▀▀▀█████████▀▀▀▀
27 
28      ______   __  __     ______     ______   __         ______
29     /\__  _\ /\ \/\ \   /\  == \   /\__  _\ /\ \       /\  ___\
30     \/_/\ \/ \ \ \_\ \  \ \  __<   \/_/\ \/ \ \ \____  \ \  __\
31        \ \_\  \ \_____\  \ \_\ \_\    \ \_\  \ \_____\  \ \_____\
32         \/_/   \/_____/   \/_/ /_/     \/_/   \/_____/   \/_____/
33                      
34                 ______   ______     __     __     __   __
35                /\__  _\ /\  __ \   /\ \  _ \ \   /\ "-.\ \  
36                \/_/\ \/ \ \ \/\ \  \ \ \/ ".\ \  \ \ \-.  \ 
37                   \ \_\  \ \_____\  \ \__/".~\_\  \ \_\\"\_\
38                    \/_/   \/_____/   \/_/   \/_/   \/_/ \/_/
39 */
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Wrappers over Solidity's arithmetic operations with added overflow
45  * checks.
46  *
47  * Arithmetic operations in Solidity wrap on overflow. This can easily result
48  * in bugs, because programmers usually assume that an overflow raises an
49  * error, which is the standard behavior in high level programming languages.
50  * `SafeMath` restores this intuition by reverting the transaction when an
51  * operation overflows.
52  *
53  * Using this library instead of the unchecked operations eliminates an entire
54  * class of bugs, so it's recommended to use it always.
55  */
56 library SafeMath {
57     /**
58      * @dev Returns the addition of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryAdd(uint256 a, uint256 b)
63         internal
64         pure
65         returns (bool, uint256)
66     {
67         uint256 c = a + b;
68         if (c < a) return (false, 0);
69         return (true, c);
70     }
71 
72     /**
73      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
74      *
75      * _Available since v3.4._
76      */
77     function trySub(uint256 a, uint256 b)
78         internal
79         pure
80         returns (bool, uint256)
81     {
82         if (b > a) return (false, 0);
83         return (true, a - b);
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryMul(uint256 a, uint256 b)
92         internal
93         pure
94         returns (bool, uint256)
95     {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
99         if (a == 0) return (true, 0);
100         uint256 c = a * b;
101         if (c / a != b) return (false, 0);
102         return (true, c);
103     }
104 
105     /**
106      * @dev Returns the division of two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryDiv(uint256 a, uint256 b)
111         internal
112         pure
113         returns (bool, uint256)
114     {
115         if (b == 0) return (false, 0);
116         return (true, a / b);
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryMod(uint256 a, uint256 b)
125         internal
126         pure
127         returns (bool, uint256)
128     {
129         if (b == 0) return (false, 0);
130         return (true, a % b);
131     }
132 
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b <= a, "SafeMath: subtraction overflow");
161         return a - b;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         if (a == 0) return 0;
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b > 0, "SafeMath: division by zero");
195         return a / b;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * reverting when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b > 0, "SafeMath: modulo by zero");
212         return a % b;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
217      * overflow (when the result is negative).
218      *
219      * CAUTION: This function is deprecated because it requires allocating memory for the error
220      * message unnecessarily. For custom revert reasons use {trySub}.
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         return a - b;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
239      * division by zero. The result is rounded towards zero.
240      *
241      * CAUTION: This function is deprecated because it requires allocating memory for the error
242      * message unnecessarily. For custom revert reasons use {tryDiv}.
243      *
244      * Counterpart to Solidity's `/` operator. Note: this function uses a
245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
246      * uses an invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function div(
253         uint256 a,
254         uint256 b,
255         string memory errorMessage
256     ) internal pure returns (uint256) {
257         require(b > 0, errorMessage);
258         return a / b;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * reverting with custom message when dividing by zero.
264      *
265      * CAUTION: This function is deprecated because it requires allocating memory for the error
266      * message unnecessarily. For custom revert reasons use {tryMod}.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev String operations.
292  */
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
298      */
299     function toString(uint256 value) internal pure returns (string memory) {
300         // Inspired by OraclizeAPI's implementation - MIT licence
301         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
302 
303         if (value == 0) {
304             return "0";
305         }
306         uint256 temp = value;
307         uint256 digits;
308         while (temp != 0) {
309             digits++;
310             temp /= 10;
311         }
312         bytes memory buffer = new bytes(digits);
313         while (value != 0) {
314             digits -= 1;
315             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
316             value /= 10;
317         }
318         return string(buffer);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
323      */
324     function toHexString(uint256 value) internal pure returns (string memory) {
325         if (value == 0) {
326             return "0x00";
327         }
328         uint256 temp = value;
329         uint256 length = 0;
330         while (temp != 0) {
331             length++;
332             temp >>= 8;
333         }
334         return toHexString(value, length);
335     }
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
339      */
340     function toHexString(uint256 value, uint256 length)
341         internal
342         pure
343         returns (string memory)
344     {
345         bytes memory buffer = new bytes(2 * length + 2);
346         buffer[0] = "0";
347         buffer[1] = "x";
348         for (uint256 i = 2 * length + 1; i > 1; --i) {
349             buffer[i] = _HEX_SYMBOLS[value & 0xf];
350             value >>= 4;
351         }
352         require(value == 0, "Strings: hex length insufficient");
353         return string(buffer);
354     }
355 }
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Provides information about the current execution context, including the
363  * sender of the transaction and its data. While these are generally available
364  * via msg.sender and msg.data, they should not be accessed in such a direct
365  * manner, since when dealing with meta-transactions the account sending and
366  * paying for execution may not be the actual sender (as far as an application
367  * is concerned).
368  *
369  * This contract is only required for intermediate, library-like contracts.
370  */
371 abstract contract Context {
372     function _msgSender() internal view virtual returns (address) {
373         return msg.sender;
374     }
375 
376     function _msgData() internal view virtual returns (bytes calldata) {
377         return msg.data;
378     }
379 }
380 
381 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 abstract contract Ownable is Context {
398     address private _owner;
399 
400     event OwnershipTransferred(
401         address indexed previousOwner,
402         address indexed newOwner
403     );
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor() {
409         _transferOwnership(_msgSender());
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         _transferOwnership(address(0));
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(
444             newOwner != address(0),
445             "Ownable: new owner is the zero address"
446         );
447         _transferOwnership(newOwner);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Internal function without access restriction.
453      */
454     function _transferOwnership(address newOwner) internal virtual {
455         address oldOwner = _owner;
456         _owner = newOwner;
457         emit OwnershipTransferred(oldOwner, newOwner);
458     }
459 }
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(
516             address(this).balance >= amount,
517             "Address: insufficient balance"
518         );
519 
520         (bool success, ) = recipient.call{value: amount}("");
521         require(
522             success,
523             "Address: unable to send value, recipient may have reverted"
524         );
525     }
526 
527     /**
528      * @dev Performs a Solidity function call using a low level `call`. A
529      * plain `call` is an unsafe replacement for a function call: use this
530      * function instead.
531      *
532      * If `target` reverts with a revert reason, it is bubbled up by this
533      * function (like regular Solidity function calls).
534      *
535      * Returns the raw returned data. To convert to the expected return value,
536      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
537      *
538      * Requirements:
539      *
540      * - `target` must be a contract.
541      * - calling `target` with `data` must not revert.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(address target, bytes memory data)
546         internal
547         returns (bytes memory)
548     {
549         return functionCall(target, data, "Address: low-level call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
554      * `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, 0, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but also transferring `value` wei to `target`.
569      *
570      * Requirements:
571      *
572      * - the calling contract must have an ETH balance of at least `value`.
573      * - the called Solidity function must be `payable`.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(
578         address target,
579         bytes memory data,
580         uint256 value
581     ) internal returns (bytes memory) {
582         return
583             functionCallWithValue(
584                 target,
585                 data,
586                 value,
587                 "Address: low-level call with value failed"
588             );
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
593      * with `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(
598         address target,
599         bytes memory data,
600         uint256 value,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(
604             address(this).balance >= value,
605             "Address: insufficient balance for call"
606         );
607         require(isContract(target), "Address: call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.call{value: value}(
610             data
611         );
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(address target, bytes memory data)
622         internal
623         view
624         returns (bytes memory)
625     {
626         return
627             functionStaticCall(
628                 target,
629                 data,
630                 "Address: low-level static call failed"
631             );
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal view returns (bytes memory) {
645         require(isContract(target), "Address: static call to non-contract");
646 
647         (bool success, bytes memory returndata) = target.staticcall(data);
648         return verifyCallResult(success, returndata, errorMessage);
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(address target, bytes memory data)
658         internal
659         returns (bytes memory)
660     {
661         return
662             functionDelegateCall(
663                 target,
664                 data,
665                 "Address: low-level delegate call failed"
666             );
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(
676         address target,
677         bytes memory data,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         require(isContract(target), "Address: delegate call to non-contract");
681 
682         (bool success, bytes memory returndata) = target.delegatecall(data);
683         return verifyCallResult(success, returndata, errorMessage);
684     }
685 
686     /**
687      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
688      * revert reason using the provided one.
689      *
690      * _Available since v4.3._
691      */
692     function verifyCallResult(
693         bool success,
694         bytes memory returndata,
695         string memory errorMessage
696     ) internal pure returns (bytes memory) {
697         if (success) {
698             return returndata;
699         } else {
700             // Look for revert reason and bubble it up if present
701             if (returndata.length > 0) {
702                 // The easiest way to bubble the revert reason is using memory via assembly
703 
704                 assembly {
705                     let returndata_size := mload(returndata)
706                     revert(add(32, returndata), returndata_size)
707                 }
708             } else {
709                 revert(errorMessage);
710             }
711         }
712     }
713 }
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @title ERC721 token receiver interface
721  * @dev Interface for any contract that wants to support safeTransfers
722  * from ERC721 asset contracts.
723  */
724 interface IERC721Receiver {
725     /**
726      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
727      * by `operator` from `from`, this function is called.
728      *
729      * It must return its Solidity selector to confirm the token transfer.
730      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
731      *
732      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
733      */
734     function onERC721Received(
735         address operator,
736         address from,
737         uint256 tokenId,
738         bytes calldata data
739     ) external returns (bytes4);
740 }
741 
742 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
769 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @dev Implementation of the {IERC165} interface.
775  *
776  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
777  * for the additional interface id that will be supported. For example:
778  *
779  * ```solidity
780  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
781  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
782  * }
783  * ```
784  *
785  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
786  */
787 abstract contract ERC165 is IERC165 {
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId)
792         public
793         view
794         virtual
795         override
796         returns (bool)
797     {
798         return interfaceId == type(IERC165).interfaceId;
799     }
800 }
801 
802 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Required interface of an ERC721 compliant contract.
808  */
809 interface IERC721 is IERC165 {
810     /**
811      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
812      */
813     event Transfer(
814         address indexed from,
815         address indexed to,
816         uint256 indexed tokenId
817     );
818 
819     /**
820      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
821      */
822     event Approval(
823         address indexed owner,
824         address indexed approved,
825         uint256 indexed tokenId
826     );
827 
828     /**
829      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
830      */
831     event ApprovalForAll(
832         address indexed owner,
833         address indexed operator,
834         bool approved
835     );
836 
837     /**
838      * @dev Returns the number of tokens in ``owner``'s account.
839      */
840     function balanceOf(address owner) external view returns (uint256 balance);
841 
842     /**
843      * @dev Returns the owner of the `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function ownerOf(uint256 tokenId) external view returns (address owner);
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
853      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
854      *
855      * Requirements:
856      *
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must exist and be owned by `from`.
860      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) external;
870 
871     /**
872      * @dev Transfers `tokenId` token from `from` to `to`.
873      *
874      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must be owned by `from`.
881      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
882      *
883      * Emits a {Transfer} event.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) external;
890 
891     /**
892      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
893      * The approval is cleared when the token is transferred.
894      *
895      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
896      *
897      * Requirements:
898      *
899      * - The caller must own the token or be an approved operator.
900      * - `tokenId` must exist.
901      *
902      * Emits an {Approval} event.
903      */
904     function approve(address to, uint256 tokenId) external;
905 
906     /**
907      * @dev Returns the account approved for `tokenId` token.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function getApproved(uint256 tokenId)
914         external
915         view
916         returns (address operator);
917 
918     /**
919      * @dev Approve or remove `operator` as an operator for the caller.
920      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
921      *
922      * Requirements:
923      *
924      * - The `operator` cannot be the caller.
925      *
926      * Emits an {ApprovalForAll} event.
927      */
928     function setApprovalForAll(address operator, bool _approved) external;
929 
930     /**
931      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
932      *
933      * See {setApprovalForAll}
934      */
935     function isApprovedForAll(address owner, address operator)
936         external
937         view
938         returns (bool);
939 
940     /**
941      * @dev Safely transfers `tokenId` token from `from` to `to`.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes calldata data
958     ) external;
959 }
960 
961 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
962 
963 pragma solidity ^0.8.0;
964 
965 /**
966  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
967  * @dev See https://eips.ethereum.org/EIPS/eip-721
968  */
969 interface IERC721Metadata is IERC721 {
970     /**
971      * @dev Returns the token collection name.
972      */
973     function name() external view returns (string memory);
974 
975     /**
976      * @dev Returns the token collection symbol.
977      */
978     function symbol() external view returns (string memory);
979 
980     /**
981      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
982      */
983     function tokenURI(uint256 tokenId) external view returns (string memory);
984 }
985 
986 // Creator: Chiru Labs
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
992  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
993  *
994  * Assumes serials are sequentially minted starting at 1 (e.g. 1, 2, 3, 4..).
995  *
996  * Does not support burning tokens to address(0).
997  *
998  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
999  */
1000 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1001     using Address for address;
1002     using Strings for uint256;
1003 
1004     struct TokenOwnership {
1005         address addr;
1006         uint64 startTimestamp;
1007     }
1008 
1009     struct AddressData {
1010         uint128 balance;
1011         uint128 numberMinted;
1012     }
1013 
1014     uint256 internal _nextTokenId;
1015 
1016     // Token name
1017     string private _name;
1018 
1019     // Token symbol
1020     string private _symbol;
1021 
1022     // Mapping from token ID to ownership details
1023     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1024     mapping(uint256 => TokenOwnership) internal _ownerships;
1025 
1026     // Mapping owner address to address data
1027     mapping(address => AddressData) private _addressData;
1028 
1029     // Mapping from token ID to approved address
1030     mapping(uint256 => address) private _tokenApprovals;
1031 
1032     // Mapping from owner to operator approvals
1033     mapping(address => mapping(address => bool)) private _operatorApprovals;
1034 
1035     constructor(string memory name_, string memory symbol_) {
1036         _name = name_;
1037         _symbol = symbol_;
1038         _nextTokenId = 1;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-totalSupply}.
1043      */
1044     function totalSupply() public view returns (uint256) {
1045         return _nextTokenId - 1;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenByIndex}.
1050      */
1051     function tokenByIndex(uint256 index) public view returns (uint256) {
1052         require(index < totalSupply(), "ERC721A: global index out of bounds");
1053         return index + 1;
1054     }
1055 
1056     /**
1057      * @dev See {IERC165-supportsInterface}.
1058      */
1059     function supportsInterface(bytes4 interfaceId)
1060         public
1061         view
1062         virtual
1063         override(ERC165, IERC165)
1064         returns (bool)
1065     {
1066         return
1067             interfaceId == type(IERC721).interfaceId ||
1068             interfaceId == type(IERC721Metadata).interfaceId ||
1069             super.supportsInterface(interfaceId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-balanceOf}.
1074      */
1075     function balanceOf(address owner) public view override returns (uint256) {
1076         require(
1077             owner != address(0),
1078             "ERC721A: balance query for the zero address"
1079         );
1080         return uint256(_addressData[owner].balance);
1081     }
1082 
1083     function _numberMinted(address owner) internal view returns (uint256) {
1084         require(
1085             owner != address(0),
1086             "ERC721A: number minted query for the zero address"
1087         );
1088         return uint256(_addressData[owner].numberMinted);
1089     }
1090 
1091     /**
1092      * Gas spent here starts off proportional to the maximum mint batch size.
1093      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1094      */
1095     function ownershipOf(uint256 tokenId)
1096         internal
1097         view
1098         returns (TokenOwnership memory)
1099     {
1100         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1101 
1102         unchecked {
1103             for (uint256 curr = tokenId; curr > 0; curr--) {
1104                 TokenOwnership memory ownership = _ownerships[curr];
1105                 if (ownership.addr != address(0)) {
1106                     return ownership;
1107                 }
1108             }
1109         }
1110 
1111         revert("ERC721A: unable to determine the owner of token");
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-ownerOf}.
1116      */
1117     function ownerOf(uint256 tokenId) public view override returns (address) {
1118         return ownershipOf(tokenId).addr;
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Metadata-name}.
1123      */
1124     function name() public view virtual override returns (string memory) {
1125         return _name;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Metadata-symbol}.
1130      */
1131     function symbol() public view virtual override returns (string memory) {
1132         return _symbol;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-tokenURI}.
1137      */
1138     function tokenURI(uint256 tokenId)
1139         public
1140         view
1141         virtual
1142         override
1143         returns (string memory)
1144     {
1145         require(
1146             _exists(tokenId),
1147             "ERC721Metadata: URI query for nonexistent token"
1148         );
1149 
1150         string memory baseURI = _baseURI();
1151         return
1152             bytes(baseURI).length != 0
1153                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1154                 : "";
1155     }
1156 
1157     /**
1158      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1159      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1160      * by default, can be overriden in child contracts.
1161      */
1162     function _baseURI() internal view virtual returns (string memory) {
1163         return "";
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-approve}.
1168      */
1169     function approve(address to, uint256 tokenId) public override {
1170         address owner = ERC721A.ownerOf(tokenId);
1171         require(to != owner, "ERC721A: approval to current owner");
1172 
1173         require(
1174             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1175             "ERC721A: approve caller is not owner nor approved for all"
1176         );
1177 
1178         _approve(to, tokenId, owner);
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-getApproved}.
1183      */
1184     function getApproved(uint256 tokenId)
1185         public
1186         view
1187         override
1188         returns (address)
1189     {
1190         require(
1191             _exists(tokenId),
1192             "ERC721A: approved query for nonexistent token"
1193         );
1194 
1195         return _tokenApprovals[tokenId];
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-setApprovalForAll}.
1200      */
1201     function setApprovalForAll(address operator, bool approved)
1202         public
1203         override
1204     {
1205         require(operator != _msgSender(), "ERC721A: approve to caller");
1206 
1207         _operatorApprovals[_msgSender()][operator] = approved;
1208         emit ApprovalForAll(_msgSender(), operator, approved);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-isApprovedForAll}.
1213      */
1214     function isApprovedForAll(address owner, address operator)
1215         public
1216         view
1217         virtual
1218         override
1219         returns (bool)
1220     {
1221         return _operatorApprovals[owner][operator];
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-transferFrom}.
1226      */
1227     function transferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public override {
1232         _transfer(from, to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-safeTransferFrom}.
1237      */
1238     function safeTransferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) public override {
1243         safeTransferFrom(from, to, tokenId, "");
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-safeTransferFrom}.
1248      */
1249     function safeTransferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) public override {
1255         _transfer(from, to, tokenId);
1256         require(
1257             _checkOnERC721Received(from, to, tokenId, _data),
1258             "ERC721A: transfer to non ERC721Receiver implementer"
1259         );
1260     }
1261 
1262     /**
1263      * @dev Returns whether `tokenId` exists.
1264      *
1265      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1266      *
1267      * Tokens start existing when they are minted (`_mint`),
1268      */
1269     function _exists(uint256 tokenId) internal view returns (bool) {
1270         return tokenId < _nextTokenId && tokenId > 0;
1271     }
1272 
1273     function _safeMint(address to, uint256 quantity) internal {
1274         _safeMint(to, quantity, "");
1275     }
1276 
1277     /**
1278      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1279      *
1280      * Requirements:
1281      *
1282      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1283      * - `quantity` must be greater than 0.
1284      *
1285      * Emits a {Transfer} event.
1286      */
1287     function _safeMint(
1288         address to,
1289         uint256 quantity,
1290         bytes memory _data
1291     ) internal {
1292         _mint(to, quantity, _data, true);
1293     }
1294 
1295     /**
1296      * @dev Mints `quantity` tokens and transfers them to `to`.
1297      *
1298      * Requirements:
1299      *
1300      * - `to` cannot be the zero address.
1301      * - `quantity` must be greater than 0.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _mint(
1306         address to,
1307         uint256 quantity,
1308         bytes memory _data,
1309         bool safe
1310     ) internal {
1311         uint256 startTokenId = _nextTokenId;
1312         require(to != address(0), "ERC721A: mint to the zero address");
1313         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1314 
1315         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1316 
1317         // Overflows are incredibly unrealistic.
1318         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1319         // updatedIndex overflows if _nextTokenId + quantity > 1.56e77 (2**256) - 1
1320         unchecked {
1321             _addressData[to].balance += uint128(quantity);
1322             _addressData[to].numberMinted += uint128(quantity);
1323 
1324             _ownerships[startTokenId].addr = to;
1325             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1326 
1327             uint256 updatedIndex = startTokenId;
1328 
1329             for (uint256 i; i < quantity; i++) {
1330                 emit Transfer(address(0), to, updatedIndex);
1331                 if (safe) {
1332                     require(
1333                         _checkOnERC721Received(
1334                             address(0),
1335                             to,
1336                             updatedIndex,
1337                             _data
1338                         ),
1339                         "ERC721A: transfer to non ERC721Receiver implementer"
1340                     );
1341                 }
1342 
1343                 updatedIndex++;
1344             }
1345 
1346             _nextTokenId = updatedIndex;
1347         }
1348 
1349         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1350     }
1351 
1352     /**
1353      * @dev Transfers `tokenId` from `from` to `to`.
1354      *
1355      * Requirements:
1356      *
1357      * - `to` cannot be the zero address.
1358      * - `tokenId` token must be owned by `from`.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _transfer(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) private {
1367         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1368 
1369         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1370             getApproved(tokenId) == _msgSender() ||
1371             isApprovedForAll(prevOwnership.addr, _msgSender()));
1372 
1373         require(
1374             isApprovedOrOwner,
1375             "ERC721A: transfer caller is not owner nor approved"
1376         );
1377 
1378         require(
1379             prevOwnership.addr == from,
1380             "ERC721A: transfer from incorrect owner"
1381         );
1382         require(to != address(0), "ERC721A: transfer to the zero address");
1383 
1384         _beforeTokenTransfers(from, to, tokenId, 1);
1385 
1386         // Clear approvals from the previous owner
1387         _approve(address(0), tokenId, prevOwnership.addr);
1388 
1389         // Underflow of the sender's balance is impossible because we check for
1390         // ownership above and the recipient's balance can't realistically overflow.
1391         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1392         unchecked {
1393             _addressData[from].balance -= 1;
1394             _addressData[to].balance += 1;
1395 
1396             _ownerships[tokenId].addr = to;
1397             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1398 
1399             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1400             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1401             uint256 nextTokenId = tokenId + 1;
1402             if (_ownerships[nextTokenId].addr == address(0)) {
1403                 if (_exists(nextTokenId)) {
1404                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1405                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1406                         .startTimestamp;
1407                 }
1408             }
1409         }
1410 
1411         emit Transfer(from, to, tokenId);
1412         _afterTokenTransfers(from, to, tokenId, 1);
1413     }
1414 
1415     /**
1416      * @dev Approve `to` to operate on `tokenId`
1417      *
1418      * Emits a {Approval} event.
1419      */
1420     function _approve(
1421         address to,
1422         uint256 tokenId,
1423         address owner
1424     ) private {
1425         _tokenApprovals[tokenId] = to;
1426         emit Approval(owner, to, tokenId);
1427     }
1428 
1429     /**
1430      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1431      * The call is not executed if the target address is not a contract.
1432      *
1433      * @param from address representing the previous owner of the given token ID
1434      * @param to target address that will receive the tokens
1435      * @param tokenId uint256 ID of the token to be transferred
1436      * @param _data bytes optional data to send along with the call
1437      * @return bool whether the call correctly returned the expected magic value
1438      */
1439     function _checkOnERC721Received(
1440         address from,
1441         address to,
1442         uint256 tokenId,
1443         bytes memory _data
1444     ) private returns (bool) {
1445         if (to.isContract()) {
1446             try
1447                 IERC721Receiver(to).onERC721Received(
1448                     _msgSender(),
1449                     from,
1450                     tokenId,
1451                     _data
1452                 )
1453             returns (bytes4 retval) {
1454                 return retval == IERC721Receiver(to).onERC721Received.selector;
1455             } catch (bytes memory reason) {
1456                 if (reason.length == 0) {
1457                     revert(
1458                         "ERC721A: transfer to non ERC721Receiver implementer"
1459                     );
1460                 } else {
1461                     assembly {
1462                         revert(add(32, reason), mload(reason))
1463                     }
1464                 }
1465             }
1466         } else {
1467             return true;
1468         }
1469     }
1470 
1471     /**
1472      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1473      *
1474      * startTokenId - the first token id to be transferred
1475      * quantity - the amount to be transferred
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` will be minted for `to`.
1482      */
1483     function _beforeTokenTransfers(
1484         address from,
1485         address to,
1486         uint256 startTokenId,
1487         uint256 quantity
1488     ) internal virtual {}
1489 
1490     /**
1491      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1492      * minting.
1493      *
1494      * startTokenId - the first token id to be transferred
1495      * quantity - the amount to be transferred
1496      *
1497      * Calling conditions:
1498      *
1499      * - when `from` and `to` are both non-zero.
1500      * - `from` and `to` are never both zero.
1501      */
1502     function _afterTokenTransfers(
1503         address from,
1504         address to,
1505         uint256 startTokenId,
1506         uint256 quantity
1507     ) internal virtual {}
1508 }
1509 
1510 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/payment/PaymentSplitter.sol
1511 
1512 pragma solidity ^0.8.0;
1513 
1514 /**
1515  * @title PaymentSplitter
1516  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1517  * that the Ether will be split in this way, since it is handled transparently by the contract.
1518  *
1519  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1520  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1521  * an amount proportional to the percentage of total shares they were assigned.
1522  *
1523  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1524  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1525  * function.
1526  */
1527 contract PaymentSplitter is Context {
1528     using SafeMath for uint256;
1529 
1530     event PayeeAdded(address account, uint256 shares);
1531     event PaymentReleased(address to, uint256 amount);
1532     event PaymentReceived(address from, uint256 amount);
1533 
1534     uint256 private _totalShares;
1535     uint256 private _totalReleased;
1536 
1537     mapping(address => uint256) private _shares;
1538     mapping(address => uint256) private _released;
1539     address[] private _payees;
1540 
1541     /**
1542      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1543      * the matching position in the `shares` array.
1544      *
1545      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1546      * duplicates in `payees`.
1547      */
1548     constructor() payable {}
1549 
1550     /**
1551      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1552      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1553      * reliability of the events, and not the actual splitting of Ether.
1554      *
1555      * To learn more about this see the Solidity documentation for
1556      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1557      * functions].
1558      */
1559     receive() external payable virtual {
1560         emit PaymentReceived(_msgSender(), msg.value);
1561     }
1562 
1563     /**
1564      * @dev Getter for the total shares held by payees.
1565      */
1566     function totalShares() public view returns (uint256) {
1567         return _totalShares;
1568     }
1569 
1570     /**
1571      * @dev Getter for the total amount of Ether already released.
1572      */
1573     function totalReleased() public view returns (uint256) {
1574         return _totalReleased;
1575     }
1576 
1577     /**
1578      * @dev Getter for the amount of shares held by an account.
1579      */
1580     function shares(address account) public view returns (uint256) {
1581         return _shares[account];
1582     }
1583 
1584     /**
1585      * @dev Getter for the amount of Ether already released to a payee.
1586      */
1587     function released(address account) public view returns (uint256) {
1588         return _released[account];
1589     }
1590 
1591     /**
1592      * @dev Getter for the address of the payee number `index`.
1593      */
1594     function payee(uint256 index) public view returns (address) {
1595         return _payees[index];
1596     }
1597 
1598     /**
1599      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1600      * total shares and their previous withdrawals.
1601      */
1602     function release(address payable account) public virtual {
1603         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1604 
1605         uint256 totalReceived = address(this).balance.add(_totalReleased);
1606         uint256 payment = totalReceived
1607             .mul(_shares[account])
1608             .div(_totalShares)
1609             .sub(_released[account]);
1610 
1611         require(payment != 0, "PaymentSplitter: account is not due payment");
1612 
1613         _released[account] = _released[account].add(payment);
1614         _totalReleased = _totalReleased.add(payment);
1615 
1616         Address.sendValue(account, payment);
1617         emit PaymentReleased(account, payment);
1618     }
1619 
1620     /**
1621      * @dev Add a new payee to the contract.
1622      * @param account The address of the payee to add.
1623      * @param shares_ The number of shares owned by the payee.
1624      */
1625     function _addPayee(address account, uint256 shares_) internal {
1626         require(
1627             account != address(0),
1628             "PaymentSplitter: account is the zero address"
1629         );
1630         require(shares_ > 0, "PaymentSplitter: shares are 0");
1631         require(
1632             _shares[account] == 0,
1633             "PaymentSplitter: account already has shares"
1634         );
1635 
1636         _payees.push(account);
1637         _shares[account] = shares_;
1638         _totalShares = _totalShares.add(shares_);
1639         emit PayeeAdded(account, shares_);
1640     }
1641 }
1642 
1643 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1644 
1645 pragma solidity ^0.8.0;
1646 
1647 /**
1648  * @dev These functions deal with verification of Merkle Trees proofs.
1649  *
1650  * The proofs can be generated using the JavaScript library
1651  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1652  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1653  *
1654  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1655  *
1656  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1657  * hashing, or use a hash function other than keccak256 for hashing leaves.
1658  * This is because the concatenation of a sorted pair of internal nodes in
1659  * the merkle tree could be reinterpreted as a leaf value.
1660  */
1661 library MerkleProof {
1662     /**
1663      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1664      * defined by `root`. For this, a `proof` must be provided, containing
1665      * sibling hashes on the branch from the leaf to the root of the tree. Each
1666      * pair of leaves and each pair of pre-images are assumed to be sorted.
1667      */
1668     function verify(
1669         bytes32[] memory proof,
1670         bytes32 root,
1671         bytes32 leaf
1672     ) internal pure returns (bool) {
1673         return processProof(proof, leaf) == root;
1674     }
1675 
1676     /**
1677      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1678      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1679      * hash matches the root of the tree. When processing the proof, the pairs
1680      * of leafs & pre-images are assumed to be sorted.
1681      *
1682      * _Available since v4.4._
1683      */
1684     function processProof(bytes32[] memory proof, bytes32 leaf)
1685         internal
1686         pure
1687         returns (bytes32)
1688     {
1689         bytes32 computedHash = leaf;
1690         for (uint256 i = 0; i < proof.length; i++) {
1691             bytes32 proofElement = proof[i];
1692             if (computedHash <= proofElement) {
1693                 // Hash(current computed hash + current element of the proof)
1694                 computedHash = _efficientHash(computedHash, proofElement);
1695             } else {
1696                 // Hash(current element of the proof + current computed hash)
1697                 computedHash = _efficientHash(proofElement, computedHash);
1698             }
1699         }
1700         return computedHash;
1701     }
1702 
1703     function _efficientHash(bytes32 a, bytes32 b)
1704         private
1705         pure
1706         returns (bytes32 value)
1707     {
1708         assembly {
1709             mstore(0x00, a)
1710             mstore(0x20, b)
1711             value := keccak256(0x00, 0x40)
1712         }
1713     }
1714 }
1715 
1716 pragma solidity ^0.8.0;
1717 
1718 /**
1719  * @title Turtle Town contract
1720  * @dev Extends ERC721a Non-Fungible Token Standard basic implementation
1721  */
1722 contract TurtleTown is ERC721A, Ownable, PaymentSplitter {
1723     bool public openWhitelistMint = false;
1724     bool public openPresaleMint = false;
1725     bool public openPublicMint = false;
1726 
1727     bool private initialized = false;
1728 
1729     uint256 public tokenPrice = 0.025 ether;
1730 
1731     uint256 public constant maxTokens = 10000;
1732     uint256 public constant maxWhitelistTokens = 1500;
1733 
1734     uint256 public maxMintsPerWallet = 3;
1735 
1736     string private _baseTokenURI;
1737 
1738     bytes32 public merkleRoot;
1739 
1740     mapping(address => bool) public whitelistClaimed;
1741     mapping(address => uint256) public presaleAddressMinted;
1742     mapping(address => uint256) public publicsaleAddressMinted;
1743 
1744     constructor() ERC721A("Turtle Town", "TRTL") {}
1745 
1746     function mintDev(uint256 quantity) external onlyOwner {
1747         require(totalSupply() + quantity <= maxTokens, "Minting too many");
1748         _safeMint(msg.sender, quantity);
1749     }
1750 
1751     function whitelistMint(bytes32[] calldata _merkleProof) public payable {
1752         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1753         require(
1754             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1755             "Invalid proof."
1756         );
1757         require(!whitelistClaimed[msg.sender], "Address has already claimed.");
1758         require(openWhitelistMint, "Mint closed");
1759         require(totalSupply() + 1 <= maxWhitelistTokens, "Minting too many");
1760 
1761         whitelistClaimed[msg.sender] = true;
1762 
1763         _safeMint(msg.sender, 1);
1764     }
1765 
1766     function preSaleMint(bytes32[] calldata _merkleProof, uint256 quantity)
1767         public
1768         payable
1769     {
1770         require(openPresaleMint, "Mint not open");
1771         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1772         require(
1773             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1774             "Invalid proof."
1775         );
1776         require(totalSupply() + quantity <= maxTokens, "Minting too many");
1777         require(
1778             presaleAddressMinted[msg.sender] + quantity <= maxMintsPerWallet,
1779             "Max 3 per wallet"
1780         );
1781         require(msg.value >= tokenPrice * quantity, "Not enough ether sent");
1782 
1783         presaleAddressMinted[msg.sender] += quantity;
1784 
1785         _safeMint(msg.sender, quantity);
1786     }
1787 
1788     function publicMint(uint256 quantity) external payable {
1789         require(openPublicMint, "mint not open");
1790         require(totalSupply() + quantity <= maxTokens, "Minting over supply");
1791         require(
1792             publicsaleAddressMinted[msg.sender] + quantity <= maxMintsPerWallet,
1793             "Max 3 per wallet"
1794         );
1795         require(msg.value >= tokenPrice * quantity, "Not enought ether sent.");
1796 
1797         publicsaleAddressMinted[msg.sender] += quantity;
1798 
1799         _safeMint(msg.sender, quantity);
1800     }
1801 
1802     function _baseURI() internal view virtual override returns (string memory) {
1803         return _baseTokenURI;
1804     }
1805 
1806     function setBaseURI(string calldata baseURI) external onlyOwner {
1807         _baseTokenURI = baseURI;
1808     }
1809 
1810     function flipWhitelistMintState() public onlyOwner {
1811         openWhitelistMint = !openWhitelistMint;
1812     }
1813 
1814     function whitelistMintState() public view returns (bool) {
1815         return openWhitelistMint;
1816     }
1817 
1818     function flipPresaleMintState() public onlyOwner {
1819         openPresaleMint = !openPresaleMint;
1820     }
1821 
1822     function presaleMintState() public view returns (bool) {
1823         return openPresaleMint;
1824     }
1825 
1826     function flipPublicMintState() public onlyOwner {
1827         openPublicMint = !openPublicMint;
1828     }
1829 
1830     function publicMintState() public view returns (bool) {
1831         return openPublicMint;
1832     }
1833 
1834     function initializePaymentSplitter(
1835         address[] memory payees,
1836         uint256[] memory shares_
1837     ) external onlyOwner {
1838         require(!initialized, "Payment Split Already Initialized!");
1839         require(
1840             payees.length == shares_.length,
1841             "PaymentSplitter: payees and shares length mismatch"
1842         );
1843         require(payees.length > 0, "PaymentSplitter: no payees");
1844 
1845         for (uint256 i = 0; i < payees.length; i++) {
1846             _addPayee(payees[i], shares_[i]);
1847         }
1848         initialized = true;
1849     }
1850 
1851     function boolWhitelistMinted(address whitelist) public view returns (bool) {
1852         return whitelistClaimed[whitelist];
1853     }
1854 
1855     function setPrice(uint256 newPrice) external onlyOwner {
1856         tokenPrice = newPrice;
1857     }
1858 
1859     function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
1860         merkleRoot = newMerkleRoot;
1861     }
1862 }