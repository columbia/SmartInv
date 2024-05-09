1 // SPDX-License-Identifier: MIT
2 // File: base64-sol/base64.sol
3 
4 
5 
6 pragma solidity >=0.6.0;
7 
8 /// @title Base64
9 /// @author Brecht Devos - <brecht@loopring.org>
10 /// @notice Provides functions for encoding/decoding base64
11 library Base64 {
12     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
13     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
14                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
15                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
16                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
17 
18     function encode(bytes memory data) internal pure returns (string memory) {
19         if (data.length == 0) return '';
20 
21         // load the table into memory
22         string memory table = TABLE_ENCODE;
23 
24         // multiply by 4/3 rounded up
25         uint256 encodedLen = 4 * ((data.length + 2) / 3);
26 
27         // add some extra buffer at the end required for the writing
28         string memory result = new string(encodedLen + 32);
29 
30         assembly {
31             // set the actual output length
32             mstore(result, encodedLen)
33 
34             // prepare the lookup table
35             let tablePtr := add(table, 1)
36 
37             // input ptr
38             let dataPtr := data
39             let endPtr := add(dataPtr, mload(data))
40 
41             // result ptr, jump over length
42             let resultPtr := add(result, 32)
43 
44             // run over the input, 3 bytes at a time
45             for {} lt(dataPtr, endPtr) {}
46             {
47                 // read 3 bytes
48                 dataPtr := add(dataPtr, 3)
49                 let input := mload(dataPtr)
50 
51                 // write 4 characters
52                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
53                 resultPtr := add(resultPtr, 1)
54                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
55                 resultPtr := add(resultPtr, 1)
56                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
57                 resultPtr := add(resultPtr, 1)
58                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
59                 resultPtr := add(resultPtr, 1)
60             }
61 
62             // padding with '='
63             switch mod(mload(data), 3)
64             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
65             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
66         }
67 
68         return result;
69     }
70 
71     function decode(string memory _data) internal pure returns (bytes memory) {
72         bytes memory data = bytes(_data);
73 
74         if (data.length == 0) return new bytes(0);
75         require(data.length % 4 == 0, "invalid base64 decoder input");
76 
77         // load the table into memory
78         bytes memory table = TABLE_DECODE;
79 
80         // every 4 characters represent 3 bytes
81         uint256 decodedLen = (data.length / 4) * 3;
82 
83         // add some extra buffer at the end required for the writing
84         bytes memory result = new bytes(decodedLen + 32);
85 
86         assembly {
87             // padding with '='
88             let lastBytes := mload(add(data, mload(data)))
89             if eq(and(lastBytes, 0xFF), 0x3d) {
90                 decodedLen := sub(decodedLen, 1)
91                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
92                     decodedLen := sub(decodedLen, 1)
93                 }
94             }
95 
96             // set the actual output length
97             mstore(result, decodedLen)
98 
99             // prepare the lookup table
100             let tablePtr := add(table, 1)
101 
102             // input ptr
103             let dataPtr := data
104             let endPtr := add(dataPtr, mload(data))
105 
106             // result ptr, jump over length
107             let resultPtr := add(result, 32)
108 
109             // run over the input, 4 characters at a time
110             for {} lt(dataPtr, endPtr) {}
111             {
112                // read 4 characters
113                dataPtr := add(dataPtr, 4)
114                let input := mload(dataPtr)
115 
116                // write 3 bytes
117                let output := add(
118                    add(
119                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
120                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
121                    add(
122                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
123                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
124                     )
125                 )
126                 mstore(resultPtr, shl(232, output))
127                 resultPtr := add(resultPtr, 3)
128             }
129         }
130 
131         return result;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 // CAUTION
143 // This version of SafeMath should only be used with Solidity 0.8 or later,
144 // because it relies on the compiler's built in overflow checks.
145 
146 /**
147  * @dev Wrappers over Solidity's arithmetic operations.
148  *
149  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
150  * now has built in overflow checking.
151  */
152 library SafeMath {
153     /**
154      * @dev Returns the addition of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             uint256 c = a + b;
161             if (c < a) return (false, 0);
162             return (true, c);
163         }
164     }
165 
166     /**
167      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             if (b > a) return (false, 0);
174             return (true, a - b);
175         }
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         unchecked {
185             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186             // benefit is lost if 'b' is also tested.
187             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188             if (a == 0) return (true, 0);
189             uint256 c = a * b;
190             if (c / a != b) return (false, 0);
191             return (true, c);
192         }
193     }
194 
195     /**
196      * @dev Returns the division of two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             if (b == 0) return (false, 0);
203             return (true, a / b);
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
209      *
210      * _Available since v3.4._
211      */
212     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b == 0) return (false, 0);
215             return (true, a % b);
216         }
217     }
218 
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      *
227      * - Addition cannot overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a + b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a - b;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a * b;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers, reverting on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator.
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a % b;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {trySub}.
297      *
298      * Counterpart to Solidity's `-` operator.
299      *
300      * Requirements:
301      *
302      * - Subtraction cannot overflow.
303      */
304     function sub(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b <= a, errorMessage);
311             return a - b;
312         }
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a / b;
335         }
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting with custom message when dividing by zero.
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {tryMod}.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a % b;
361         }
362     }
363 }
364 
365 // File: @openzeppelin/contracts/utils/Counters.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @title Counters
374  * @author Matt Condon (@shrugs)
375  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
376  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
377  *
378  * Include with `using Counters for Counters.Counter;`
379  */
380 library Counters {
381     struct Counter {
382         // This variable should never be directly accessed by users of the library: interactions must be restricted to
383         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
384         // this feature: see https://github.com/ethereum/solidity/issues/4637
385         uint256 _value; // default: 0
386     }
387 
388     function current(Counter storage counter) internal view returns (uint256) {
389         return counter._value;
390     }
391 
392     function increment(Counter storage counter) internal {
393         unchecked {
394             counter._value += 1;
395         }
396     }
397 
398     function decrement(Counter storage counter) internal {
399         uint256 value = counter._value;
400         require(value > 0, "Counter: decrement overflow");
401         unchecked {
402             counter._value = value - 1;
403         }
404     }
405 
406     function reset(Counter storage counter) internal {
407         counter._value = 0;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/utils/Strings.sol
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev String operations.
420  */
421 library Strings {
422     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
423 
424     /**
425      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
426      */
427     function toString(uint256 value) internal pure returns (string memory) {
428         // Inspired by OraclizeAPI's implementation - MIT licence
429         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
430 
431         if (value == 0) {
432             return "0";
433         }
434         uint256 temp = value;
435         uint256 digits;
436         while (temp != 0) {
437             digits++;
438             temp /= 10;
439         }
440         bytes memory buffer = new bytes(digits);
441         while (value != 0) {
442             digits -= 1;
443             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
444             value /= 10;
445         }
446         return string(buffer);
447     }
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
451      */
452     function toHexString(uint256 value) internal pure returns (string memory) {
453         if (value == 0) {
454             return "0x00";
455         }
456         uint256 temp = value;
457         uint256 length = 0;
458         while (temp != 0) {
459             length++;
460             temp >>= 8;
461         }
462         return toHexString(value, length);
463     }
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
467      */
468     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
469         bytes memory buffer = new bytes(2 * length + 2);
470         buffer[0] = "0";
471         buffer[1] = "x";
472         for (uint256 i = 2 * length + 1; i > 1; --i) {
473             buffer[i] = _HEX_SYMBOLS[value & 0xf];
474             value >>= 4;
475         }
476         require(value == 0, "Strings: hex length insufficient");
477         return string(buffer);
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Context.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Provides information about the current execution context, including the
490  * sender of the transaction and its data. While these are generally available
491  * via msg.sender and msg.data, they should not be accessed in such a direct
492  * manner, since when dealing with meta-transactions the account sending and
493  * paying for execution may not be the actual sender (as far as an application
494  * is concerned).
495  *
496  * This contract is only required for intermediate, library-like contracts.
497  */
498 abstract contract Context {
499     function _msgSender() internal view virtual returns (address) {
500         return msg.sender;
501     }
502 
503     function _msgData() internal view virtual returns (bytes calldata) {
504         return msg.data;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/access/Ownable.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Contract module which provides a basic access control mechanism, where
518  * there is an account (an owner) that can be granted exclusive access to
519  * specific functions.
520  *
521  * By default, the owner account will be the one that deploys the contract. This
522  * can later be changed with {transferOwnership}.
523  *
524  * This module is used through inheritance. It will make available the modifier
525  * `onlyOwner`, which can be applied to your functions to restrict their use to
526  * the owner.
527  */
528 abstract contract Ownable is Context {
529     address private _owner;
530 
531     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
532 
533     /**
534      * @dev Initializes the contract setting the deployer as the initial owner.
535      */
536     constructor() {
537         _transferOwnership(_msgSender());
538     }
539 
540     /**
541      * @dev Returns the address of the current owner.
542      */
543     function owner() public view virtual returns (address) {
544         return _owner;
545     }
546 
547     /**
548      * @dev Throws if called by any account other than the owner.
549      */
550     modifier onlyOwner() {
551         require(owner() == _msgSender(), "Ownable: caller is not the owner");
552         _;
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         _transferOwnership(address(0));
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(newOwner != address(0), "Ownable: new owner is the zero address");
572         _transferOwnership(newOwner);
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Internal function without access restriction.
578      */
579     function _transferOwnership(address newOwner) internal virtual {
580         address oldOwner = _owner;
581         _owner = newOwner;
582         emit OwnershipTransferred(oldOwner, newOwner);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/security/Pausable.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Contract module which allows children to implement an emergency stop
596  * mechanism that can be triggered by an authorized account.
597  *
598  * This module is used through inheritance. It will make available the
599  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
600  * the functions of your contract. Note that they will not be pausable by
601  * simply including this module, only once the modifiers are put in place.
602  */
603 abstract contract Pausable is Context {
604     /**
605      * @dev Emitted when the pause is triggered by `account`.
606      */
607     event Paused(address account);
608 
609     /**
610      * @dev Emitted when the pause is lifted by `account`.
611      */
612     event Unpaused(address account);
613 
614     bool private _paused;
615 
616     /**
617      * @dev Initializes the contract in unpaused state.
618      */
619     constructor() {
620         _paused = false;
621     }
622 
623     /**
624      * @dev Returns true if the contract is paused, and false otherwise.
625      */
626     function paused() public view virtual returns (bool) {
627         return _paused;
628     }
629 
630     /**
631      * @dev Modifier to make a function callable only when the contract is not paused.
632      *
633      * Requirements:
634      *
635      * - The contract must not be paused.
636      */
637     modifier whenNotPaused() {
638         require(!paused(), "Pausable: paused");
639         _;
640     }
641 
642     /**
643      * @dev Modifier to make a function callable only when the contract is paused.
644      *
645      * Requirements:
646      *
647      * - The contract must be paused.
648      */
649     modifier whenPaused() {
650         require(paused(), "Pausable: not paused");
651         _;
652     }
653 
654     /**
655      * @dev Triggers stopped state.
656      *
657      * Requirements:
658      *
659      * - The contract must not be paused.
660      */
661     function _pause() internal virtual whenNotPaused {
662         _paused = true;
663         emit Paused(_msgSender());
664     }
665 
666     /**
667      * @dev Returns to normal state.
668      *
669      * Requirements:
670      *
671      * - The contract must be paused.
672      */
673     function _unpause() internal virtual whenPaused {
674         _paused = false;
675         emit Unpaused(_msgSender());
676     }
677 }
678 
679 // File: @openzeppelin/contracts/utils/Address.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Collection of functions related to the address type
688  */
689 library Address {
690     /**
691      * @dev Returns true if `account` is a contract.
692      *
693      * [IMPORTANT]
694      * ====
695      * It is unsafe to assume that an address for which this function returns
696      * false is an externally-owned account (EOA) and not a contract.
697      *
698      * Among others, `isContract` will return false for the following
699      * types of addresses:
700      *
701      *  - an externally-owned account
702      *  - a contract in construction
703      *  - an address where a contract will be created
704      *  - an address where a contract lived, but was destroyed
705      * ====
706      */
707     function isContract(address account) internal view returns (bool) {
708         // This method relies on extcodesize, which returns 0 for contracts in
709         // construction, since the code is only stored at the end of the
710         // constructor execution.
711 
712         uint256 size;
713         assembly {
714             size := extcodesize(account)
715         }
716         return size > 0;
717     }
718 
719     /**
720      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
721      * `recipient`, forwarding all available gas and reverting on errors.
722      *
723      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
724      * of certain opcodes, possibly making contracts go over the 2300 gas limit
725      * imposed by `transfer`, making them unable to receive funds via
726      * `transfer`. {sendValue} removes this limitation.
727      *
728      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
729      *
730      * IMPORTANT: because control is transferred to `recipient`, care must be
731      * taken to not create reentrancy vulnerabilities. Consider using
732      * {ReentrancyGuard} or the
733      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
734      */
735     function sendValue(address payable recipient, uint256 amount) internal {
736         require(address(this).balance >= amount, "Address: insufficient balance");
737 
738         (bool success, ) = recipient.call{value: amount}("");
739         require(success, "Address: unable to send value, recipient may have reverted");
740     }
741 
742     /**
743      * @dev Performs a Solidity function call using a low level `call`. A
744      * plain `call` is an unsafe replacement for a function call: use this
745      * function instead.
746      *
747      * If `target` reverts with a revert reason, it is bubbled up by this
748      * function (like regular Solidity function calls).
749      *
750      * Returns the raw returned data. To convert to the expected return value,
751      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
752      *
753      * Requirements:
754      *
755      * - `target` must be a contract.
756      * - calling `target` with `data` must not revert.
757      *
758      * _Available since v3.1._
759      */
760     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
761         return functionCall(target, data, "Address: low-level call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
766      * `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal returns (bytes memory) {
775         return functionCallWithValue(target, data, 0, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but also transferring `value` wei to `target`.
781      *
782      * Requirements:
783      *
784      * - the calling contract must have an ETH balance of at least `value`.
785      * - the called Solidity function must be `payable`.
786      *
787      * _Available since v3.1._
788      */
789     function functionCallWithValue(
790         address target,
791         bytes memory data,
792         uint256 value
793     ) internal returns (bytes memory) {
794         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
799      * with `errorMessage` as a fallback revert reason when `target` reverts.
800      *
801      * _Available since v3.1._
802      */
803     function functionCallWithValue(
804         address target,
805         bytes memory data,
806         uint256 value,
807         string memory errorMessage
808     ) internal returns (bytes memory) {
809         require(address(this).balance >= value, "Address: insufficient balance for call");
810         require(isContract(target), "Address: call to non-contract");
811 
812         (bool success, bytes memory returndata) = target.call{value: value}(data);
813         return verifyCallResult(success, returndata, errorMessage);
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
818      * but performing a static call.
819      *
820      * _Available since v3.3._
821      */
822     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
823         return functionStaticCall(target, data, "Address: low-level static call failed");
824     }
825 
826     /**
827      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
828      * but performing a static call.
829      *
830      * _Available since v3.3._
831      */
832     function functionStaticCall(
833         address target,
834         bytes memory data,
835         string memory errorMessage
836     ) internal view returns (bytes memory) {
837         require(isContract(target), "Address: static call to non-contract");
838 
839         (bool success, bytes memory returndata) = target.staticcall(data);
840         return verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but performing a delegate call.
846      *
847      * _Available since v3.4._
848      */
849     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
850         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a delegate call.
856      *
857      * _Available since v3.4._
858      */
859     function functionDelegateCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal returns (bytes memory) {
864         require(isContract(target), "Address: delegate call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.delegatecall(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     /**
871      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
872      * revert reason using the provided one.
873      *
874      * _Available since v4.3._
875      */
876     function verifyCallResult(
877         bool success,
878         bytes memory returndata,
879         string memory errorMessage
880     ) internal pure returns (bytes memory) {
881         if (success) {
882             return returndata;
883         } else {
884             // Look for revert reason and bubble it up if present
885             if (returndata.length > 0) {
886                 // The easiest way to bubble the revert reason is using memory via assembly
887 
888                 assembly {
889                     let returndata_size := mload(returndata)
890                     revert(add(32, returndata), returndata_size)
891                 }
892             } else {
893                 revert(errorMessage);
894             }
895         }
896     }
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @title ERC721 token receiver interface
908  * @dev Interface for any contract that wants to support safeTransfers
909  * from ERC721 asset contracts.
910  */
911 interface IERC721Receiver {
912     /**
913      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
914      * by `operator` from `from`, this function is called.
915      *
916      * It must return its Solidity selector to confirm the token transfer.
917      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
918      *
919      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
920      */
921     function onERC721Received(
922         address operator,
923         address from,
924         uint256 tokenId,
925         bytes calldata data
926     ) external returns (bytes4);
927 }
928 
929 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev Interface of the ERC165 standard, as defined in the
938  * https://eips.ethereum.org/EIPS/eip-165[EIP].
939  *
940  * Implementers can declare support of contract interfaces, which can then be
941  * queried by others ({ERC165Checker}).
942  *
943  * For an implementation, see {ERC165}.
944  */
945 interface IERC165 {
946     /**
947      * @dev Returns true if this contract implements the interface defined by
948      * `interfaceId`. See the corresponding
949      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
950      * to learn more about how these ids are created.
951      *
952      * This function call must use less than 30 000 gas.
953      */
954     function supportsInterface(bytes4 interfaceId) external view returns (bool);
955 }
956 
957 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Implementation of the {IERC165} interface.
967  *
968  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
969  * for the additional interface id that will be supported. For example:
970  *
971  * ```solidity
972  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
974  * }
975  * ```
976  *
977  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
978  */
979 abstract contract ERC165 is IERC165 {
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
984         return interfaceId == type(IERC165).interfaceId;
985     }
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
989 
990 
991 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @dev Required interface of an ERC721 compliant contract.
998  */
999 interface IERC721 is IERC165 {
1000     /**
1001      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1002      */
1003     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1004 
1005     /**
1006      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1007      */
1008     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1009 
1010     /**
1011      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1012      */
1013     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1014 
1015     /**
1016      * @dev Returns the number of tokens in ``owner``'s account.
1017      */
1018     function balanceOf(address owner) external view returns (uint256 balance);
1019 
1020     /**
1021      * @dev Returns the owner of the `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function ownerOf(uint256 tokenId) external view returns (address owner);
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1039      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) external;
1048 
1049     /**
1050      * @dev Transfers `tokenId` token from `from` to `to`.
1051      *
1052      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1053      *
1054      * Requirements:
1055      *
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must be owned by `from`.
1059      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) external;
1068 
1069     /**
1070      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1071      * The approval is cleared when the token is transferred.
1072      *
1073      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1074      *
1075      * Requirements:
1076      *
1077      * - The caller must own the token or be an approved operator.
1078      * - `tokenId` must exist.
1079      *
1080      * Emits an {Approval} event.
1081      */
1082     function approve(address to, uint256 tokenId) external;
1083 
1084     /**
1085      * @dev Returns the account approved for `tokenId` token.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      */
1091     function getApproved(uint256 tokenId) external view returns (address operator);
1092 
1093     /**
1094      * @dev Approve or remove `operator` as an operator for the caller.
1095      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1096      *
1097      * Requirements:
1098      *
1099      * - The `operator` cannot be the caller.
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      */
1103     function setApprovalForAll(address operator, bool _approved) external;
1104 
1105     /**
1106      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1107      *
1108      * See {setApprovalForAll}
1109      */
1110     function isApprovedForAll(address owner, address operator) external view returns (bool);
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must exist and be owned by `from`.
1120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes calldata data
1130     ) external;
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1134 
1135 
1136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 /**
1142  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1143  * @dev See https://eips.ethereum.org/EIPS/eip-721
1144  */
1145 interface IERC721Enumerable is IERC721 {
1146     /**
1147      * @dev Returns the total amount of tokens stored by the contract.
1148      */
1149     function totalSupply() external view returns (uint256);
1150 
1151     /**
1152      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1153      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1154      */
1155     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1156 
1157     /**
1158      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1159      * Use along with {totalSupply} to enumerate all tokens.
1160      */
1161     function tokenByIndex(uint256 index) external view returns (uint256);
1162 }
1163 
1164 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1165 
1166 
1167 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 /**
1173  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1174  * @dev See https://eips.ethereum.org/EIPS/eip-721
1175  */
1176 interface IERC721Metadata is IERC721 {
1177     /**
1178      * @dev Returns the token collection name.
1179      */
1180     function name() external view returns (string memory);
1181 
1182     /**
1183      * @dev Returns the token collection symbol.
1184      */
1185     function symbol() external view returns (string memory);
1186 
1187     /**
1188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1189      */
1190     function tokenURI(uint256 tokenId) external view returns (string memory);
1191 }
1192 
1193 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1194 
1195 
1196 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 
1202 
1203 
1204 
1205 
1206 
1207 /**
1208  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1209  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1210  * {ERC721Enumerable}.
1211  */
1212 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1213     using Address for address;
1214     using Strings for uint256;
1215 
1216     // Token name
1217     string private _name;
1218 
1219     // Token symbol
1220     string private _symbol;
1221 
1222     // Mapping from token ID to owner address
1223     mapping(uint256 => address) private _owners;
1224 
1225     // Mapping owner address to token count
1226     mapping(address => uint256) private _balances;
1227 
1228     // Mapping from token ID to approved address
1229     mapping(uint256 => address) private _tokenApprovals;
1230 
1231     // Mapping from owner to operator approvals
1232     mapping(address => mapping(address => bool)) private _operatorApprovals;
1233 
1234     /**
1235      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1236      */
1237     constructor(string memory name_, string memory symbol_) {
1238         _name = name_;
1239         _symbol = symbol_;
1240     }
1241 
1242     /**
1243      * @dev See {IERC165-supportsInterface}.
1244      */
1245     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1246         return
1247             interfaceId == type(IERC721).interfaceId ||
1248             interfaceId == type(IERC721Metadata).interfaceId ||
1249             super.supportsInterface(interfaceId);
1250     }
1251 
1252     /**
1253      * @dev See {IERC721-balanceOf}.
1254      */
1255     function balanceOf(address owner) public view virtual override returns (uint256) {
1256         require(owner != address(0), "ERC721: balance query for the zero address");
1257         return _balances[owner];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-ownerOf}.
1262      */
1263     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1264         address owner = _owners[tokenId];
1265         require(owner != address(0), "ERC721: owner query for nonexistent token");
1266         return owner;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Metadata-name}.
1271      */
1272     function name() public view virtual override returns (string memory) {
1273         return _name;
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Metadata-symbol}.
1278      */
1279     function symbol() public view virtual override returns (string memory) {
1280         return _symbol;
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Metadata-tokenURI}.
1285      */
1286     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1287         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1288 
1289         string memory baseURI = _baseURI();
1290         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1291     }
1292 
1293     /**
1294      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1295      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1296      * by default, can be overriden in child contracts.
1297      */
1298     function _baseURI() internal view virtual returns (string memory) {
1299         return "";
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-approve}.
1304      */
1305     function approve(address to, uint256 tokenId) public virtual override {
1306         address owner = ERC721.ownerOf(tokenId);
1307         require(to != owner, "ERC721: approval to current owner");
1308 
1309         require(
1310             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1311             "ERC721: approve caller is not owner nor approved for all"
1312         );
1313 
1314         _approve(to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-getApproved}.
1319      */
1320     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1321         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1322 
1323         return _tokenApprovals[tokenId];
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-setApprovalForAll}.
1328      */
1329     function setApprovalForAll(address operator, bool approved) public virtual override {
1330         _setApprovalForAll(_msgSender(), operator, approved);
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-isApprovedForAll}.
1335      */
1336     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1337         return _operatorApprovals[owner][operator];
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-transferFrom}.
1342      */
1343     function transferFrom(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) public virtual override {
1348         //solhint-disable-next-line max-line-length
1349         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1350 
1351         _transfer(from, to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-safeTransferFrom}.
1356      */
1357     function safeTransferFrom(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) public virtual override {
1362         safeTransferFrom(from, to, tokenId, "");
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-safeTransferFrom}.
1367      */
1368     function safeTransferFrom(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) public virtual override {
1374         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1375         _safeTransfer(from, to, tokenId, _data);
1376     }
1377 
1378     /**
1379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1381      *
1382      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1383      *
1384      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1385      * implement alternative mechanisms to perform token transfer, such as signature-based.
1386      *
1387      * Requirements:
1388      *
1389      * - `from` cannot be the zero address.
1390      * - `to` cannot be the zero address.
1391      * - `tokenId` token must exist and be owned by `from`.
1392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1393      *
1394      * Emits a {Transfer} event.
1395      */
1396     function _safeTransfer(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) internal virtual {
1402         _transfer(from, to, tokenId);
1403         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1404     }
1405 
1406     /**
1407      * @dev Returns whether `tokenId` exists.
1408      *
1409      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1410      *
1411      * Tokens start existing when they are minted (`_mint`),
1412      * and stop existing when they are burned (`_burn`).
1413      */
1414     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1415         return _owners[tokenId] != address(0);
1416     }
1417 
1418     /**
1419      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1420      *
1421      * Requirements:
1422      *
1423      * - `tokenId` must exist.
1424      */
1425     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1426         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1427         address owner = ERC721.ownerOf(tokenId);
1428         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1429     }
1430 
1431     /**
1432      * @dev Safely mints `tokenId` and transfers it to `to`.
1433      *
1434      * Requirements:
1435      *
1436      * - `tokenId` must not exist.
1437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function _safeMint(address to, uint256 tokenId) internal virtual {
1442         _safeMint(to, tokenId, "");
1443     }
1444 
1445     /**
1446      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1447      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1448      */
1449     function _safeMint(
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) internal virtual {
1454         _mint(to, tokenId);
1455         require(
1456             _checkOnERC721Received(address(0), to, tokenId, _data),
1457             "ERC721: transfer to non ERC721Receiver implementer"
1458         );
1459     }
1460 
1461     /**
1462      * @dev Mints `tokenId` and transfers it to `to`.
1463      *
1464      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1465      *
1466      * Requirements:
1467      *
1468      * - `tokenId` must not exist.
1469      * - `to` cannot be the zero address.
1470      *
1471      * Emits a {Transfer} event.
1472      */
1473     function _mint(address to, uint256 tokenId) internal virtual {
1474         require(to != address(0), "ERC721: mint to the zero address");
1475         require(!_exists(tokenId), "ERC721: token already minted");
1476 
1477         _beforeTokenTransfer(address(0), to, tokenId);
1478 
1479         _balances[to] += 1;
1480         _owners[tokenId] = to;
1481 
1482         emit Transfer(address(0), to, tokenId);
1483     }
1484 
1485     /**
1486      * @dev Destroys `tokenId`.
1487      * The approval is cleared when the token is burned.
1488      *
1489      * Requirements:
1490      *
1491      * - `tokenId` must exist.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function _burn(uint256 tokenId) internal virtual {
1496         address owner = ERC721.ownerOf(tokenId);
1497 
1498         _beforeTokenTransfer(owner, address(0), tokenId);
1499 
1500         // Clear approvals
1501         _approve(address(0), tokenId);
1502 
1503         _balances[owner] -= 1;
1504         delete _owners[tokenId];
1505 
1506         emit Transfer(owner, address(0), tokenId);
1507     }
1508 
1509     /**
1510      * @dev Transfers `tokenId` from `from` to `to`.
1511      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1512      *
1513      * Requirements:
1514      *
1515      * - `to` cannot be the zero address.
1516      * - `tokenId` token must be owned by `from`.
1517      *
1518      * Emits a {Transfer} event.
1519      */
1520     function _transfer(
1521         address from,
1522         address to,
1523         uint256 tokenId
1524     ) internal virtual {
1525         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1526         require(to != address(0), "ERC721: transfer to the zero address");
1527 
1528         _beforeTokenTransfer(from, to, tokenId);
1529 
1530         // Clear approvals from the previous owner
1531         _approve(address(0), tokenId);
1532 
1533         _balances[from] -= 1;
1534         _balances[to] += 1;
1535         _owners[tokenId] = to;
1536 
1537         emit Transfer(from, to, tokenId);
1538     }
1539 
1540     /**
1541      * @dev Approve `to` to operate on `tokenId`
1542      *
1543      * Emits a {Approval} event.
1544      */
1545     function _approve(address to, uint256 tokenId) internal virtual {
1546         _tokenApprovals[tokenId] = to;
1547         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1548     }
1549 
1550     /**
1551      * @dev Approve `operator` to operate on all of `owner` tokens
1552      *
1553      * Emits a {ApprovalForAll} event.
1554      */
1555     function _setApprovalForAll(
1556         address owner,
1557         address operator,
1558         bool approved
1559     ) internal virtual {
1560         require(owner != operator, "ERC721: approve to caller");
1561         _operatorApprovals[owner][operator] = approved;
1562         emit ApprovalForAll(owner, operator, approved);
1563     }
1564 
1565     /**
1566      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1567      * The call is not executed if the target address is not a contract.
1568      *
1569      * @param from address representing the previous owner of the given token ID
1570      * @param to target address that will receive the tokens
1571      * @param tokenId uint256 ID of the token to be transferred
1572      * @param _data bytes optional data to send along with the call
1573      * @return bool whether the call correctly returned the expected magic value
1574      */
1575     function _checkOnERC721Received(
1576         address from,
1577         address to,
1578         uint256 tokenId,
1579         bytes memory _data
1580     ) private returns (bool) {
1581         if (to.isContract()) {
1582             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1583                 return retval == IERC721Receiver.onERC721Received.selector;
1584             } catch (bytes memory reason) {
1585                 if (reason.length == 0) {
1586                     revert("ERC721: transfer to non ERC721Receiver implementer");
1587                 } else {
1588                     assembly {
1589                         revert(add(32, reason), mload(reason))
1590                     }
1591                 }
1592             }
1593         } else {
1594             return true;
1595         }
1596     }
1597 
1598     /**
1599      * @dev Hook that is called before any token transfer. This includes minting
1600      * and burning.
1601      *
1602      * Calling conditions:
1603      *
1604      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1605      * transferred to `to`.
1606      * - When `from` is zero, `tokenId` will be minted for `to`.
1607      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1608      * - `from` and `to` are never both zero.
1609      *
1610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1611      */
1612     function _beforeTokenTransfer(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) internal virtual {}
1617 }
1618 
1619 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1620 
1621 
1622 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1623 
1624 pragma solidity ^0.8.0;
1625 
1626 
1627 
1628 /**
1629  * @title ERC721 Burnable Token
1630  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1631  */
1632 abstract contract ERC721Burnable is Context, ERC721 {
1633     /**
1634      * @dev Burns `tokenId`. See {ERC721-_burn}.
1635      *
1636      * Requirements:
1637      *
1638      * - The caller must own `tokenId` or be an approved operator.
1639      */
1640     function burn(uint256 tokenId) public virtual {
1641         //solhint-disable-next-line max-line-length
1642         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1643         _burn(tokenId);
1644     }
1645 }
1646 
1647 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1648 
1649 
1650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1651 
1652 pragma solidity ^0.8.0;
1653 
1654 
1655 /**
1656  * @dev ERC721 token with storage based token URI management.
1657  */
1658 abstract contract ERC721URIStorage is ERC721 {
1659     using Strings for uint256;
1660 
1661     // Optional mapping for token URIs
1662     mapping(uint256 => string) private _tokenURIs;
1663 
1664     /**
1665      * @dev See {IERC721Metadata-tokenURI}.
1666      */
1667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1668         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1669 
1670         string memory _tokenURI = _tokenURIs[tokenId];
1671         string memory base = _baseURI();
1672 
1673         // If there is no base URI, return the token URI.
1674         if (bytes(base).length == 0) {
1675             return _tokenURI;
1676         }
1677         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1678         if (bytes(_tokenURI).length > 0) {
1679             return string(abi.encodePacked(base, _tokenURI));
1680         }
1681 
1682         return super.tokenURI(tokenId);
1683     }
1684 
1685     /**
1686      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      */
1692     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1693         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1694         _tokenURIs[tokenId] = _tokenURI;
1695     }
1696 
1697     /**
1698      * @dev Destroys `tokenId`.
1699      * The approval is cleared when the token is burned.
1700      *
1701      * Requirements:
1702      *
1703      * - `tokenId` must exist.
1704      *
1705      * Emits a {Transfer} event.
1706      */
1707     function _burn(uint256 tokenId) internal virtual override {
1708         super._burn(tokenId);
1709 
1710         if (bytes(_tokenURIs[tokenId]).length != 0) {
1711             delete _tokenURIs[tokenId];
1712         }
1713     }
1714 }
1715 
1716 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1717 
1718 
1719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1720 
1721 pragma solidity ^0.8.0;
1722 
1723 
1724 
1725 /**
1726  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1727  * enumerability of all the token ids in the contract as well as all token ids owned by each
1728  * account.
1729  */
1730 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1731     // Mapping from owner to list of owned token IDs
1732     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1733 
1734     // Mapping from token ID to index of the owner tokens list
1735     mapping(uint256 => uint256) private _ownedTokensIndex;
1736 
1737     // Array with all token ids, used for enumeration
1738     uint256[] private _allTokens;
1739 
1740     // Mapping from token id to position in the allTokens array
1741     mapping(uint256 => uint256) private _allTokensIndex;
1742 
1743     /**
1744      * @dev See {IERC165-supportsInterface}.
1745      */
1746     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1747         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1748     }
1749 
1750     /**
1751      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1752      */
1753     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1754         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1755         return _ownedTokens[owner][index];
1756     }
1757 
1758     /**
1759      * @dev See {IERC721Enumerable-totalSupply}.
1760      */
1761     function totalSupply() public view virtual override returns (uint256) {
1762         return _allTokens.length;
1763     }
1764 
1765     /**
1766      * @dev See {IERC721Enumerable-tokenByIndex}.
1767      */
1768     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1769         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1770         return _allTokens[index];
1771     }
1772 
1773     /**
1774      * @dev Hook that is called before any token transfer. This includes minting
1775      * and burning.
1776      *
1777      * Calling conditions:
1778      *
1779      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1780      * transferred to `to`.
1781      * - When `from` is zero, `tokenId` will be minted for `to`.
1782      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1783      * - `from` cannot be the zero address.
1784      * - `to` cannot be the zero address.
1785      *
1786      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1787      */
1788     function _beforeTokenTransfer(
1789         address from,
1790         address to,
1791         uint256 tokenId
1792     ) internal virtual override {
1793         super._beforeTokenTransfer(from, to, tokenId);
1794 
1795         if (from == address(0)) {
1796             _addTokenToAllTokensEnumeration(tokenId);
1797         } else if (from != to) {
1798             _removeTokenFromOwnerEnumeration(from, tokenId);
1799         }
1800         if (to == address(0)) {
1801             _removeTokenFromAllTokensEnumeration(tokenId);
1802         } else if (to != from) {
1803             _addTokenToOwnerEnumeration(to, tokenId);
1804         }
1805     }
1806 
1807     /**
1808      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1809      * @param to address representing the new owner of the given token ID
1810      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1811      */
1812     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1813         uint256 length = ERC721.balanceOf(to);
1814         _ownedTokens[to][length] = tokenId;
1815         _ownedTokensIndex[tokenId] = length;
1816     }
1817 
1818     /**
1819      * @dev Private function to add a token to this extension's token tracking data structures.
1820      * @param tokenId uint256 ID of the token to be added to the tokens list
1821      */
1822     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1823         _allTokensIndex[tokenId] = _allTokens.length;
1824         _allTokens.push(tokenId);
1825     }
1826 
1827     /**
1828      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1829      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1830      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1831      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1832      * @param from address representing the previous owner of the given token ID
1833      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1834      */
1835     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1836         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1837         // then delete the last slot (swap and pop).
1838 
1839         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1840         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1841 
1842         // When the token to delete is the last token, the swap operation is unnecessary
1843         if (tokenIndex != lastTokenIndex) {
1844             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1845 
1846             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1847             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1848         }
1849 
1850         // This also deletes the contents at the last position of the array
1851         delete _ownedTokensIndex[tokenId];
1852         delete _ownedTokens[from][lastTokenIndex];
1853     }
1854 
1855     /**
1856      * @dev Private function to remove a token from this extension's token tracking data structures.
1857      * This has O(1) time complexity, but alters the order of the _allTokens array.
1858      * @param tokenId uint256 ID of the token to be removed from the tokens list
1859      */
1860     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1861         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1862         // then delete the last slot (swap and pop).
1863 
1864         uint256 lastTokenIndex = _allTokens.length - 1;
1865         uint256 tokenIndex = _allTokensIndex[tokenId];
1866 
1867         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1868         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1869         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1870         uint256 lastTokenId = _allTokens[lastTokenIndex];
1871 
1872         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1873         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1874 
1875         // This also deletes the contents at the last position of the array
1876         delete _allTokensIndex[tokenId];
1877         _allTokens.pop();
1878     }
1879 }
1880 
1881 // File: Cirkill.sol
1882 
1883 
1884 pragma solidity ^0.8.7;
1885 
1886 
1887 
1888 
1889 
1890 
1891 
1892 
1893 
1894 
1895 
1896 contract Cirkill is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1897     using SafeMath for uint256;
1898     using Counters for Counters.Counter;
1899 
1900     Counters.Counter private _tokenIdCounter;
1901     mapping(address => uint8) public allowlist;
1902 
1903     bool public preSaleEnabled = false;
1904     bool public publicSaleEnabled = false;
1905     uint256 public constant MAX_ELEMENTS = 9950;
1906     uint256 public constant TEAM_ELEMENTS = 50; //For giveaways
1907     uint256 public PRICE_FIRST_TIER = 0.03 ether;
1908     uint256 public constant FIRST_TIER_BEGIN = 2950; //UPDATE THIS to 2950
1909     uint256 public PRICE_SECOND_TIER = 0.03 ether;
1910     uint256 public constant SECOND_TIER_BEGIN = 6000;
1911     uint256 public constant MAX_PER_MINT = 20;
1912     bool public pauseGrowth = false;
1913     uint256 public growthInterval = 1 hours; //UPDATE THIS to hours
1914     uint256 pauseGrowthTimeStamp;
1915     address public constant firstAddress = 0x989CCA76e9B96Bf7B138d81F45DD795E7041F56F;
1916     address public constant secondAddress = 0x330DA6BcBDa450818484ED6314a5927E4D1896b4; 
1917     uint256 firstMintTimeStamp;
1918     address public constant signingAddress = 0xaAB57dedC05A3677dAC050b402F5ca52ea176156;
1919 
1920     bool public advancedFeaturesEnabled = false;
1921     uint256 public PRICE_INCREASE_SHIELD_PER_HOUR = 0.001 ether;
1922     uint256 public PRICE_BACKGROUND_COLOR = 0.01 ether;
1923 
1924     struct Circle {
1925         uint32 eatCooldownTime;
1926         uint32 eatenCooldownTime;
1927         uint32 growthRate; //per growthInterval
1928         uint32 color;
1929         uint32 eatCount;
1930         uint32 eatenCount;
1931         uint32 backgroundColor;
1932         uint256 size;
1933         uint256 readyToEatTime;
1934         uint256 readyToBeEatenTime;
1935         uint256 lastGrowthUpdateTime;
1936     }
1937 
1938     struct SvgCircleTrait {
1939         uint256 size;
1940         uint256 circleSize;
1941         uint32 color;
1942         uint32 tokenId;
1943     }
1944 
1945     using Strings for uint256;
1946 
1947     //mapping from tokenId to a struct containing the circle's traits
1948     mapping(uint256 => Circle) public circleTraits;
1949     mapping(uint256 => SvgCircleTrait[]) public SvgCircleTraits;
1950     
1951     uint private canvaSize=540;
1952 
1953     event CreateCircle(uint256 indexed count, address indexed wallet);
1954     event EatCircle(uint256 indexed predatorTokenId, uint256 indexed preyTokenId);
1955 
1956     constructor() ERC721("CIRKILL", "KILL") {}
1957 
1958     function pause() public onlyOwner {
1959         _pause();
1960     }
1961 
1962     function unpause() public onlyOwner {
1963         _unpause();
1964     }
1965 
1966     function getCanvaSize() public view returns (uint) {
1967         return canvaSize;
1968     }
1969 
1970     function updateCanvaSize(uint size) public onlyOwner {
1971         canvaSize = size;
1972     }
1973 
1974     function pausePreSale() public onlyOwner {
1975         preSaleEnabled = false;
1976     }
1977 
1978     function unpausePreSale() public onlyOwner {
1979         preSaleEnabled = true;
1980     }
1981 
1982     function pausePublicSale() public onlyOwner {
1983         publicSaleEnabled = false;
1984     }
1985 
1986     function unpausePublicSale() public onlyOwner {
1987         publicSaleEnabled = true;
1988     }
1989 
1990     function setFirstTierPrice(uint256 price) public onlyOwner {
1991         PRICE_FIRST_TIER = price;
1992     }
1993 
1994     function setSecondTierPrice(uint256 price) public onlyOwner {
1995         PRICE_SECOND_TIER = price;
1996     }
1997 
1998     function pauseSizeGrowth() public onlyOwner {
1999         pauseGrowth = true;
2000         pauseGrowthTimeStamp = block.timestamp;
2001     }
2002 
2003     function unPauseSizeGrowth() public onlyOwner {
2004         pauseGrowth = false;
2005     }
2006 
2007     function pauseAdvancedFeatures() public onlyOwner {
2008         advancedFeaturesEnabled = false;
2009     }
2010 
2011     function unpauseAdvancedFeatures() public onlyOwner {
2012         advancedFeaturesEnabled = true;
2013     }
2014 
2015     function setGrowthInterval(uint256 newGrowthInterval) public onlyOwner {
2016         growthInterval = newGrowthInterval;
2017     }
2018 
2019     function setAllowlist(address[] memory addresses) external onlyOwner{
2020         for (uint256 i = 0; i < addresses.length; i++) {
2021             allowlist[addresses[i]] = 3;
2022         }
2023     }
2024 
2025     modifier saleIsOpen {
2026         require(totalSupply() < MAX_ELEMENTS, "Sale ended");
2027         if (_msgSender() != owner()) {
2028             require(publicSaleEnabled, "Sale is paused");
2029         }
2030         _;
2031     }
2032 
2033     modifier preSaleIsOpen {
2034         require(totalSupply() < MAX_ELEMENTS, "Sale ended");
2035         if (_msgSender() != owner()) {
2036             require(preSaleEnabled, "Pre-Sale is paused");
2037         }
2038         _;
2039     }
2040 
2041     function devMint(uint256 count) external onlyOwner { //For Giveaways
2042         require(balanceOf(msg.sender) + count <= TEAM_ELEMENTS, "Max elements reached");
2043         for (uint256 i = 0; i < count; i++) {
2044             mintOneElement(msg.sender);
2045         }
2046     }
2047 
2048     function preSaleSafeMint(uint256 count, bytes32 hash, uint8 v, bytes32 r, bytes32 s) public payable preSaleIsOpen {
2049         require(verifyHash(hash, v, r, s) == signingAddress, "Invalid signature");
2050         uint256 total = totalSupply();
2051         require(count <= MAX_PER_MINT, "Exceeds max number of NFTs per mint");
2052         require(total + count <= MAX_ELEMENTS, "Max elements reached, reduce count");
2053         //require(allowlist[msg.sender] > 0, "Not eligible for allowlist mint");
2054 
2055         if(_tokenIdCounter.current() == 0) {
2056             firstMintTimeStamp = block.timestamp;
2057         }
2058 
2059         //Doesn't consider edge cases in the interest of keeping this logic simple
2060         //For cases where some elements are free and some are not, the expectation is to mint the free ones first and then mint the non-free ones
2061         if (total + count > FIRST_TIER_BEGIN) {
2062             require(msg.value >= PRICE_FIRST_TIER*count , "Price is too low");
2063         } else {
2064             uint256 addressTokenCount = balanceOf(msg.sender);
2065             require(addressTokenCount + count <= 3, "Max 3 in free mint");
2066         }
2067         for (uint256 i = 0; i < count; i++) {
2068             mintOneElement(msg.sender);
2069             //allowlist[msg.sender]--;
2070         }
2071     }
2072 
2073     function safeMint(uint256 count) public payable saleIsOpen {
2074         uint256 total = totalSupply();
2075         require(total + count <= MAX_ELEMENTS, "Max elements reached, reduce count and try again");
2076         require(count <= MAX_PER_MINT, "Exceeds max number of NFTs per mint");
2077 
2078         //Doesn't consider edge cases in the interest of keeping this logic simple
2079         if (total + count > FIRST_TIER_BEGIN) {
2080             require(msg.value >= PRICE_FIRST_TIER*count , "Price is too low");
2081         } else {
2082             uint256 addressTokenCount = balanceOf(msg.sender);
2083             require(addressTokenCount + count <= 3, "Max 3 in free mint");
2084         }
2085         for (uint256 i = 0; i < count; i++) {
2086             mintOneElement(msg.sender);
2087         }
2088         emit CreateCircle(count, msg.sender);
2089     }
2090 
2091     function mintOneElement(address to) private {
2092         uint256 tokenId = _tokenIdCounter.current();
2093         _tokenIdCounter.increment();
2094         generateCircle(tokenId);
2095         _safeMint(to, tokenId);
2096     }
2097         
2098     function generateCircle(uint256 tokenId) internal{
2099         uint256 randomNumber = _random(tokenId);
2100         uint256 size = 20 + randomNumber % 11;
2101         uint32 eatCooldownTime = (60 + uint32(randomNumber >> 4) % 60) * (1 minutes);
2102         uint32 eatenCooldownTime =  (60 + uint32(randomNumber >> 12) % 60) * (1 minutes);
2103         uint32 growthRate = 5;
2104         uint32 color = uint32 ((_random(block.timestamp)) >> (tokenId%20)*6) & 0xFFFFFF;
2105         Circle memory c = Circle(eatCooldownTime, eatenCooldownTime, growthRate, color, 0, 0, 16777215, size, block.timestamp, block.timestamp , uint(block.timestamp));
2106         circleTraits[tokenId] = c;
2107         SvgCircleTrait memory svgTrait = SvgCircleTrait(size, size, color, uint32(tokenId));
2108         SvgCircleTraits[tokenId].push(svgTrait);
2109         circleTraits[tokenId].size += ((block.timestamp - firstMintTimeStamp)/(growthInterval))*growthRate;
2110     }
2111 
2112     function eat(uint256 predatorTokenId, uint256 preyTokenId) public {
2113         require(!paused(), "Game is paused");
2114         require(ownerOf(predatorTokenId) == msg.sender, "You are not the owner");
2115         Circle storage predatorCircle = circleTraits[predatorTokenId];
2116         require(_isReadyToEat(predatorCircle), "You are not ready to eat");
2117         Circle storage preyCircle = circleTraits[preyTokenId];
2118         require(_isReadyToBeEaten(preyCircle), "Other circle is not ready to be eaten");
2119         predatorCircle.size = getCircleSize(predatorTokenId);
2120         preyCircle.size = getCircleSize(preyTokenId);
2121         predatorCircle.lastGrowthUpdateTime = block.timestamp;
2122         preyCircle.lastGrowthUpdateTime = block.timestamp;
2123         require((preyCircle.size*80)/100 > 10, "Can't eat this circle, size will be less than 10");
2124         require(predatorCircle.size > preyCircle.size, "Can't eat, circle is not smaller");
2125         uint256 size_to_change=(preyCircle.size*20)/100; //20% of the size of the prey circle
2126         preyCircle.size = preyCircle.size - size_to_change;
2127         predatorCircle.size = predatorCircle.size + size_to_change;
2128         SvgCircleTrait memory preySvgTrait = SvgCircleTrait(size_to_change, predatorCircle.size, preyCircle.color, uint32(preyTokenId));
2129         SvgCircleTraits[predatorTokenId].push(preySvgTrait);
2130         predatorCircle.eatCount++;
2131         preyCircle.eatenCount++;
2132         _triggerEatCooldown(predatorCircle);
2133         _triggerEatenCooldown(preyCircle);
2134         if (predatorCircle.size > canvaSize){
2135             
2136             canvaSize = ((predatorCircle.size/1080) + 1)*1080;
2137             
2138         }
2139         emit EatCircle(predatorTokenId, preyTokenId);
2140     }
2141 
2142     function transferSize(uint256 predatorTokenId, uint256 preyTokenId, uint256 size) public {
2143         require(!paused(), "Game is paused");
2144         require(ownerOf(predatorTokenId) == msg.sender, "You are not the owner");
2145         Circle storage predatorCircle = circleTraits[predatorTokenId];
2146         Circle storage preyCircle = circleTraits[preyTokenId];
2147         predatorCircle.size = getCircleSize(predatorTokenId);
2148         preyCircle.size = getCircleSize(preyTokenId);
2149         predatorCircle.lastGrowthUpdateTime = block.timestamp;
2150         preyCircle.lastGrowthUpdateTime = block.timestamp;
2151         require((predatorCircle.size - size) > 10, "Can't transfer, size will be less than 10");
2152         require(predatorCircle.size > preyCircle.size, "Can't transfer, circle is not smaller");
2153         preyCircle.size = preyCircle.size + size;
2154         predatorCircle.size = predatorCircle.size - size;
2155     }
2156 
2157     function updateBackgroundColor(uint256 tokenId, uint32 color) public payable {
2158         require(advancedFeaturesEnabled , "This is paused");
2159         require(ownerOf(tokenId) == msg.sender, "You are not the owner");
2160         require(msg.value >= PRICE_BACKGROUND_COLOR, "Price is too low");
2161         circleTraits[tokenId].backgroundColor = color;
2162     }
2163 
2164     function increaseShieldTime(uint256 tokenId, uint32 numHours) public payable {
2165         require(advancedFeaturesEnabled , "This is paused");
2166         require(ownerOf(tokenId) == msg.sender, "You are not the owner");
2167         require(msg.value >= PRICE_INCREASE_SHIELD_PER_HOUR*numHours, "Price is too low");
2168         uint addToTimestamp = block.timestamp;
2169         if (circleTraits[tokenId].readyToBeEatenTime > block.timestamp){
2170             addToTimestamp=circleTraits[tokenId].readyToBeEatenTime;
2171         }
2172         circleTraits[tokenId].readyToBeEatenTime = uint32(addToTimestamp + numHours*(1 hours));
2173     }
2174 
2175     function getCircleSize(uint256 tokenId) public view returns (uint256) {
2176         return circleTraits[tokenId].size + _getGrowthSize(circleTraits[tokenId]);
2177     }
2178 
2179     function getCircleSize(Circle memory circle) internal view returns (uint256) {
2180         return circle.size + _getGrowthSize(circle);
2181     }
2182 
2183     function _getGrowthSize(Circle memory circle) internal view returns (uint256) {
2184         if (pauseGrowth)
2185             if (pauseGrowthTimeStamp > circle.lastGrowthUpdateTime)
2186                 return circle.growthRate*((pauseGrowthTimeStamp - circle.lastGrowthUpdateTime)/growthInterval);
2187             else
2188                 return 0;
2189         else
2190             return circle.growthRate*((block.timestamp - circle.lastGrowthUpdateTime)/growthInterval);
2191     }
2192 
2193     function getCircleDetail(uint256 tokenId) public view returns (SvgCircleTrait[] memory) {
2194         return SvgCircleTraits[tokenId];
2195     }
2196 
2197     function getEatHistory(uint256 tokenId) public view returns (uint256[] memory) {
2198         SvgCircleTrait[] memory svgTrait = SvgCircleTraits[tokenId];
2199         uint len=svgTrait.length;
2200         uint256[] memory eatHistory = new uint256[] (len-1);
2201         uint j;
2202         for (j=1; j<len; j++){
2203             eatHistory[j-1] = svgTrait[j].tokenId;
2204         }
2205         return eatHistory;
2206     }
2207 
2208     function getHexColorString(uint256 value) internal pure returns (string memory) {
2209         bytes memory buffer = new bytes(7);
2210         bytes16 HEX_SYMBOLS = "0123456789abcdef";
2211         buffer[0] = "#";
2212         for (uint256 i = 6; i > 0; --i) {
2213             buffer[i] = HEX_SYMBOLS[value & 0xf];
2214             value >>= 4;
2215         }
2216         require(value == 0, "Strings: hex length insufficient");
2217         return string(buffer);
2218     }
2219 
2220     
2221     function createSvg(uint256 tokenId) internal view returns (bytes memory) {
2222         uint cirleCanvaSize = canvaSize;
2223         Circle memory circle = circleTraits[tokenId];
2224         SvgCircleTrait[] memory svgTrait = SvgCircleTraits[tokenId];
2225         uint j;
2226         uint len=svgTrait.length;
2227 
2228         uint circleSize = getCircleSize(circle);
2229 
2230         if (circleSize > cirleCanvaSize){
2231             cirleCanvaSize=circleSize;
2232         }
2233         string memory open= svgOpen(cirleCanvaSize, cirleCanvaSize);
2234 
2235         string memory circle_background = string(abi.encodePacked("style='background-color:",getHexColorString(circle.backgroundColor),"'>"));
2236         open=concatenate(open,circle_background);
2237 
2238         if (!_isReadyToBeEaten(circle)){
2239             uint shieldRadius = (circleSize*11/20);
2240             uint strokeWidth = 1 + (shieldRadius*5/100);
2241             uint strokeDash = strokeWidth*3;
2242             string memory shield = string(abi.encodePacked("<circle cx='50%' cy='50%' r='",
2243                                                 shieldRadius.toString(),
2244                                                 "' fill='none' stroke='red' stroke-width='",
2245                                                 strokeWidth.toString(),"' stroke-dasharray='",
2246                                                 strokeDash.toString(),"'></circle>"));
2247             open=concatenate(open,shield);
2248         }
2249         for (j=0; j<len; j++){
2250             uint color = svgTrait[len-j-1].color;
2251             string memory offset;
2252             string memory radius = (circleSize/2).toString();
2253             if (circleSize < 400){
2254                 offset = ((circleSize/2)-1).toString();
2255             }
2256             else{
2257                 offset = ((circleSize*99)/200).toString();
2258             }
2259             
2260             string memory circleSvgBegin = string(abi.encodePacked("<circle cx='50%' cy='50%' r='",
2261                                                 radius,
2262                                                 "' fill='",
2263                                                 getHexColorString(color),"'>"));
2264             if (_isReadyToEat(circle)){
2265                 string memory animateXML = string(abi.encodePacked("<animate attributeType='XML' attributeName='r' values='0;",radius,
2266                                                 "' dur='4s' begin='0.25s'/><animate attributeType='XML' attributeName='r' values='",
2267                                                 offset,";",radius,";",offset,"' dur='0.5s' begin='4.25s' repeatCount='indefinite'/>"));
2268                 circleSvgBegin = concatenate(circleSvgBegin,animateXML);
2269             }
2270             string memory circleSvgEnd = "</circle>";
2271             string memory circleSvg = concatenate(circleSvgBegin,circleSvgEnd);
2272             open = concatenate(open,circleSvg);
2273             uint256 circleWidth = (circleSize*svgTrait[len-j-1].size)/svgTrait[len-j-1].circleSize;
2274             circleSize -= circleWidth;
2275         }
2276         return abi.encodePacked(open,"</svg>");
2277     }
2278 
2279     function getSvg(uint256 tokenId) public view returns (string memory) {
2280         uint cirleCanvaSize = canvaSize;
2281         Circle memory circle = circleTraits[tokenId];
2282         SvgCircleTrait[] memory svgTrait = SvgCircleTraits[tokenId];
2283         uint j;
2284         uint len=svgTrait.length;
2285 
2286         uint circleSize = getCircleSize(circle);
2287 
2288         if (circleSize > cirleCanvaSize){
2289             cirleCanvaSize=circleSize;
2290         }
2291         string memory open= svgOpen(cirleCanvaSize, cirleCanvaSize);
2292 
2293         string memory circle_background = string(abi.encodePacked("style='background-color:",getHexColorString(circle.backgroundColor),"'>"));
2294         open=concatenate(open,circle_background);
2295 
2296         for (j=0; j<len; j++){
2297             uint color = svgTrait[len-j-1].color;
2298             string memory radius = (circleSize/2).toString();    
2299             string memory circleSvg = string(abi.encodePacked("<circle cx='50%' cy='50%' r='",
2300                                                 radius,
2301                                                 "' fill='",
2302                                                 getHexColorString(color),"'></circle>"));
2303             open = concatenate(open,circleSvg);
2304             uint256 circleWidth = (circleSize*svgTrait[len-j-1].size)/svgTrait[len-j-1].circleSize;
2305             circleSize -= circleWidth;
2306         }
2307         return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(abi.encodePacked(open,"</svg>"))));        
2308     }
2309 
2310     function svgOpen(uint256 width, uint256 height) private pure returns (string memory) {
2311         return string(abi.encodePacked("<svg viewBox='0 0 ", width.toString(), " ", height.toString(), "' xmlns='http://www.w3.org/2000/svg' version='1.1' "));
2312     }
2313 
2314     function _triggerEatCooldown(Circle storage circle) internal {
2315         circle.readyToEatTime = uint32(block.timestamp + circle.eatCooldownTime);
2316     }
2317 
2318     function _triggerEatenCooldown(Circle storage circle) internal {
2319         circle.readyToBeEatenTime = uint32(block.timestamp + circle.eatenCooldownTime);
2320     }
2321 
2322     function _isReadyToEat(Circle memory circle) internal view returns (bool) {
2323       return (circle.readyToEatTime <= block.timestamp);
2324     }
2325 
2326     function _isReadyToBeEaten(Circle memory circle) internal view returns (bool) {
2327       return (circle.readyToBeEatenTime <= block.timestamp);
2328     }
2329 
2330     function _attributesFromDetail(uint256 tokenId) private view returns (string memory) {
2331         Circle memory detail = circleTraits[tokenId];
2332         string memory initialTraits =  string(abi.encodePacked(
2333             'trait_type":"Size","value":', getCircleSize(detail).toString(),
2334             '},{"trait_type":"Color","value":"', getHexColorString(detail.color),
2335             '"},{"trait_type":"Background","value":"', getHexColorString(detail.backgroundColor),
2336             '"},{"trait_type":"Growth Rate","display_type": "boost_number","value":', uint(detail.growthRate).toString(),
2337             '},{"trait_type":"Circles Attacked", "display_type": "number", "value":', uint(detail.eatCount).toString(),
2338             '},{"trait_type":"Attacked by", "display_type": "number", "value":', uint(detail.eatenCount).toString()
2339         ));
2340         string memory additionalTraits = string(abi.encodePacked(
2341             '},{"trait_type":"Sleep Time","value":"', uint(detail.eatCooldownTime/(1 minutes)).toString(),
2342             ' minutes"},{"trait_type":"Shield Time","value":"', uint(detail.eatenCooldownTime/(1 minutes)).toString(),' minutes'
2343         ));
2344         string memory traits = concatenate(initialTraits, additionalTraits);
2345         return traits;
2346     }
2347 
2348     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
2349         internal
2350         whenNotPaused
2351         override(ERC721, ERC721Enumerable)
2352     {
2353         super._beforeTokenTransfer(from, to, tokenId);
2354     }
2355 
2356     // The following functions are overrides required by Solidity.
2357     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
2358         super._burn(tokenId);
2359     }
2360 
2361     function concatenate(string memory string1, string memory string2)internal pure returns(string memory){
2362         return string(abi.encodePacked(string1,string2));
2363     }
2364 
2365     function _baseURI() internal pure virtual override returns (string memory) {
2366         return "data:application/json;base64,";
2367     }
2368 
2369     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
2370         require(_exists(tokenId), "Nonexistent token");
2371 
2372         return _tokenUriForDetail(tokenId);
2373     }
2374 
2375     function _tokenUriForDetail(uint256 tokenId) private view returns (string memory) {
2376         return string(abi.encodePacked(
2377             _baseURI(),
2378             Base64.encode(abi.encodePacked(
2379                 '{"name":"',
2380                     "CIRKILL #",tokenId.toString(),
2381                 '","description":"',
2382                     "First ever 100% on-chain dynamic NFT game. NFTs that grow, attack, change in size and update visually. No API. No IPFS. Completely on chain.",
2383                 '","attributes":[{"',
2384                     _attributesFromDetail(tokenId),
2385                 '"}],"image":"',
2386                     "data:image/svg+xml;base64,", Base64.encode(createSvg(tokenId)),
2387                 '"}'
2388             ))
2389         ));
2390     }
2391 
2392     function supportsInterface(bytes4 interfaceId)
2393         public
2394         view
2395         override(ERC721, ERC721Enumerable)
2396         returns (bool)
2397     {
2398         return super.supportsInterface(interfaceId);
2399     }
2400 
2401     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
2402         uint256 tokenCount = balanceOf(_owner);
2403 
2404         uint256[] memory tokensId = new uint256[](tokenCount);
2405         for (uint256 i = 0; i < tokenCount; i++) {
2406             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2407         }
2408 
2409         return tokensId;
2410     }
2411 
2412     function withdrawAll() public payable onlyOwner {
2413         uint256 balance = address(this).balance;
2414         require(balance > 0);
2415         _widthdraw(firstAddress, balance.mul(25).div(100));
2416         _widthdraw(secondAddress, address(this).balance);
2417     }
2418 
2419     function _widthdraw(address _address, uint256 _amount) private {
2420         (bool success, ) = _address.call{value: _amount}("");
2421         require(success, "Transfer failed.");
2422     }
2423 
2424     function _random(uint256 seed) internal view returns (uint256) {
2425         uint rand = uint(keccak256(abi.encodePacked(block.difficulty,block.number,seed)));
2426         return rand;
2427     }
2428 
2429     function verifyHash(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public pure
2430                  returns (address signer) {
2431 
2432         bytes32 messageDigest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2433 
2434         return ecrecover(messageDigest, v, r, s);
2435     }
2436 
2437 }