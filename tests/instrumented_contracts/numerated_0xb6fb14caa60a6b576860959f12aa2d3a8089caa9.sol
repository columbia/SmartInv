1 // SPDX-License-Identifier: LGPL-3.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6 
7  * NNNNNNNNNNRNNNNNNNNN@RNNRNNRNNNNRNNNNNRNNNRNNRNNNNNNNNN@RNNNNNNNNNNRNNNNNNNNNRNNRNNNNNNNNN@NNNRNNNNNNNRNNNNNRNNNRNNN
8  * NNNNNEC\*~~^*(uHNNNNNNNNNHCl\\lsuENNNGi\*\i2RNNN@NNNNNHSs(!!!\iu5QRNNNNQ5SS5HNNNRS\~::^(2Ru(!!!!*luHNRNN5i\!^^*l2RNN
9  * RNNNl```    ````sNNNNNNNS'``  ````uN2``` ```'5NNNNRu!'````   `````!CRE~``````~GR^```` ```i```    ``'HNNi```    ``uRN
10  * RNN2``       ```!RRNNN@N~`       `*N*       `,GNN5~```             `^l       `iC``    ``lH'``    ```2NN:       `!QNN
11  * NNN\``        ``5RNNRNNH``       `(N\`      ``*R2`````             ``*`      `s~``  ```sNNE~`    ```\RE`     ``*NNNN
12  * NRN~``       ``(RRRNNNN2``       `sNs```    ``'Q,``       `'~```````'E,``     ~``` ```(RNRRQl```  ```,``  ````iNRRNR
13  * RRR~``     ```(RRRRRRRNC``       `SRE```    ```C```     ``~QNR2*'`,(ERi``           ``SRRRRRNE^```        ``~5NNRRRR
14  * RRN^``     ```RNNRNNNNNC``       `ENN,`     ```i`       ``sRNNNNNHNNNNE'`           ```,*CQNNNNs```       `*RNNNRRRN
15  * RRNl``     ``'QNH2s*~!u2``       `5NR'``    ``,2```     ``!NNN2^'``!GN@s`             `````*GNNNl``       !NNNNNRNRN
16  * RRN5``      ```'```````s``       `~i*```    ``*Q'``      ``!(:```  `'GNQ`      ``````    ```^@NN2`       `iNNNRRRNNN
17  * RRNN!`                `(^`                  `'GNC``                ``(NNi      ``^l'`    ``~GNNR~``       'ENNRRNNRN
18  * RNN@G`                `CE:```             ```2NNNi````             ``uNNQ,``     `'Sl:``'*2NNNNs```       `^@NRRNNRN
19  * N@@N@C```      ``````'lNNRs:``````   `````'\ENNNN@E\``````   ``````^SNN@NS``  ````,G@@NR@@@@@@@C```````````\@N@NNNNN
20  * NNNN@@5(~'`````,~*luGRN@N@@NGC(!~,```,~*iSR@@NNN@NN@Q2i\^:''',~*l2H@NNNN@NS,```:\uN@NNNNNNN@@NN@Gi*^:,:~(sGNNN@N@@NN
21  * RRRRNNRRNNNRRNNNRNNRRNNRRNNNRRRRRNNNNNRNNRRRRRRRRRRRNNRRNNNNNNNRRRRRRRRRRRNRQQRNRRRRRRRNNRRNNRRNNNRRRRRRRRRRRNNRRRNN
22  * RNNNNNNNRRNRHEEEEEEHQNNNNNNNNRNRHEEEHQRNNNRRRRRRRRRNNNRQEEHQRNNNNRRRRRRNNRRRRNRQRRNRRRRNNNRNNRRNNNNNRQQQQRNNNRRRRRNN
23  * NNRG\:````````````````,*uRNHi!:````````'~!sSRNNGs\!^:,```````'^lSRNNRRNNR2i!,``````:*sGRNNRNNNRGi!:'```````,~\uHRNNN
24  * NNN:``                ```iH,`             ``~Hi``               `^ERRRQs,```         ``~sRNNN5~``            ``'2NNN
25  * NNN:``                ```l!``             ```s``                ``'GNG'`````          ```:ENu```             ```'5RN
26  * RRNC``  ``````        ``:S'``       ````````*C``       ```````    `lQ,`                  `,E,`            ``````'GNN
27  * RNNNS^,,~*iss,`    ````(Q5``        `SHGul(2Nl``       ``C@R5,     ((`     ``````````    ``\~```       ``~^^^~^(GNNN
28  * RNNNNNNNNNQ2^``    `'lGNRS``         ``` ``'5\``        `GNNN*    `C:`     ``*sS52(``    ``:G~``       `:~::~*CQNNNN
29  * NNRRRNNR2!````` ``~2RRNNNG``        ````` `'S\``        `*ES(`  ``*R:`     `5@NNNNNG`    ``:RR2l!:'`` `````````'SNNN
30  * RRNNRRs,````    `uESCssuHQ'``      `:isl!~^sN\``        ````````'sRR\`     'RNNRRRNR'`   ``\R2(!^!\\\``        `,ENR
31  * RRNN5:```       ````  ```C!``       !GG2i(lSN(``          `  ``,GRNNE'``   `lRNNNNNC``  ``'G!```   ````         `2NR
32  * RRNu`````       ````   ``'2``       ````````GC``     ``,```  ```!5NNN2```  ``:(Cus*`  ```'S2```                `,QRR
33  * NNN,``                   `H\```          ```(5``     ``lS'`     ``*QNRG!````````````````^ENQ^```             ``'GNNR
34  * NNN!`````````````````````^RR*``````````````'SR!````````2Ni```````'(QRNNRS!`````  ````'\5RNRRQs:``````  ``````'(HNNNR
35  * NNNNE2Csil((\\\\\\(lisuSHRRRNECl(*^!!!\(iuGRNNQC\\\(sSQNNN5iliC2GRNNRRNNNNR5C(\\\(iuHNNNNNRRRNNQSCl*!!!!!*lC5QRNNNNR
36  * NNNNNNNNNNNRNNNNNNNNNNNNNNRRNNNNNNNNNNNNNNNNNNNNRNNNNN@NNNNNNNNNNNNNRRNNNNNNNNNNNNNNNNNNNNRNNNNNNNNNNNNNNNNNNNNNNNNR
37 
38 * A PureBase Studio Collection
39  */
40 
41 /**
42  * @title Counters
43  * @author Matt Condon (@shrugs)
44  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
45  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
46  *
47  * Include with `using Counters for Counters.Counter;`
48  */
49 library Counters {
50     struct Counter {
51         // This variable should never be directly accessed by users of the library: interactions must be restricted to
52         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
53         // this feature: see https://github.com/ethereum/solidity/issues/4637
54         uint256 _value; // default: 0
55     }
56 
57     function current(Counter storage counter) internal view returns (uint256) {
58         return counter._value;
59     }
60 
61     function increment(Counter storage counter) internal {
62         unchecked {
63             counter._value += 1;
64         }
65     }
66 
67     function decrement(Counter storage counter) internal {
68         uint256 value = counter._value;
69         require(value > 0, "Counter: decrement overflow");
70         unchecked {
71             counter._value = value - 1;
72         }
73     }
74 
75     function reset(Counter storage counter) internal {
76         counter._value = 0;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
81 
82 
83 
84 pragma solidity ^0.8.0;
85 
86 // CAUTION
87 // This version of SafeMath should only be used with Solidity 0.8 or later,
88 // because it relies on the compiler's built in overflow checks.
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations.
92  *
93  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
94  * now has built in overflow checking.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             uint256 c = a + b;
105             if (c < a) return (false, 0);
106             return (true, c);
107         }
108     }
109 
110     /**
111      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             if (b > a) return (false, 0);
118             return (true, a - b);
119         }
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         unchecked {
129             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130             // benefit is lost if 'b' is also tested.
131             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132             if (a == 0) return (true, 0);
133             uint256 c = a * b;
134             if (c / a != b) return (false, 0);
135             return (true, c);
136         }
137     }
138 
139     /**
140      * @dev Returns the division of two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a / b);
148         }
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             if (b == 0) return (false, 0);
159             return (true, a % b);
160         }
161     }
162 
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a + b;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a * b;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator.
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a / b;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b <= a, errorMessage);
255             return a - b;
256         }
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a % b;
305         }
306     }
307 }
308 // File: @openzeppelin/contracts/utils/Context.sol
309 
310 
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 abstract contract Context {
325     function _msgSender() internal view virtual returns (address) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes calldata) {
330         return msg.data;
331     }
332 }
333 
334 
335 // File: @openzeppelin/contracts/access/Ownable.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _setOwner(_msgSender());
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _setOwner(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _setOwner(newOwner);
399     }
400 
401     function _setOwner(address newOwner) private {
402         address oldOwner = _owner;
403         _owner = newOwner;
404         emit OwnershipTransferred(oldOwner, newOwner);
405     }
406 }
407 
408 // File: @openzeppelin/contracts/security/Pausable.sol
409 
410 
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Contract module which allows children to implement an emergency stop
417  * mechanism that can be triggered by an authorized account.
418  *
419  * This module is used through inheritance. It will make available the
420  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
421  * the functions of your contract. Note that they will not be pausable by
422  * simply including this module, only once the modifiers are put in place.
423  */
424 abstract contract Pausable is Context {
425     /**
426      * @dev Emitted when the pause is triggered by `account`.
427      */
428     event Paused(address account);
429 
430     /**
431      * @dev Emitted when the pause is lifted by `account`.
432      */
433     event Unpaused(address account);
434 
435     bool private _paused;
436 
437     /**
438      * @dev Initializes the contract in unpaused state.
439      */
440     constructor() {
441         _paused = false;
442     }
443 
444     /**
445      * @dev Returns true if the contract is paused, and false otherwise.
446      */
447     function paused() public view virtual returns (bool) {
448         return _paused;
449     }
450 
451     /**
452      * @dev Modifier to make a function callable only when the contract is not paused.
453      *
454      * Requirements:
455      *
456      * - The contract must not be paused.
457      */
458     modifier whenNotPaused() {
459         require(!paused(), "Pausable: paused");
460         _;
461     }
462 
463     /**
464      * @dev Modifier to make a function callable only when the contract is paused.
465      *
466      * Requirements:
467      *
468      * - The contract must be paused.
469      */
470     modifier whenPaused() {
471         require(paused(), "Pausable: not paused");
472         _;
473     }
474 
475     /**
476      * @dev Triggers stopped state.
477      *
478      * Requirements:
479      *
480      * - The contract must not be paused.
481      */
482     function _pause() internal virtual whenNotPaused {
483         _paused = true;
484         emit Paused(_msgSender());
485     }
486 
487     /**
488      * @dev Returns to normal state.
489      *
490      * Requirements:
491      *
492      * - The contract must be paused.
493      */
494     function _unpause() internal virtual whenPaused {
495         _paused = false;
496         emit Unpaused(_msgSender());
497     }
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
501 
502 
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC165 standard, as defined in the
508  * https://eips.ethereum.org/EIPS/eip-165[EIP].
509  *
510  * Implementers can declare support of contract interfaces, which can then be
511  * queried by others ({ERC165Checker}).
512  *
513  * For an implementation, see {ERC165}.
514  */
515 interface IERC165 {
516     /**
517      * @dev Returns true if this contract implements the interface defined by
518      * `interfaceId`. See the corresponding
519      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
520      * to learn more about how these ids are created.
521      *
522      * This function call must use less than 30 000 gas.
523      */
524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/utils/Strings.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev String operations.
565  */
566 library Strings {
567     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
571      */
572     function toString(uint256 value) internal pure returns (string memory) {
573         // Inspired by OraclizeAPI's implementation - MIT licence
574         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
575 
576         if (value == 0) {
577             return "0";
578         }
579         uint256 temp = value;
580         uint256 digits;
581         while (temp != 0) {
582             digits++;
583             temp /= 10;
584         }
585         bytes memory buffer = new bytes(digits);
586         while (value != 0) {
587             digits -= 1;
588             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
589             value /= 10;
590         }
591         return string(buffer);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
596      */
597     function toHexString(uint256 value) internal pure returns (string memory) {
598         if (value == 0) {
599             return "0x00";
600         }
601         uint256 temp = value;
602         uint256 length = 0;
603         while (temp != 0) {
604             length++;
605             temp >>= 8;
606         }
607         return toHexString(value, length);
608     }
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
612      */
613     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
614         bytes memory buffer = new bytes(2 * length + 2);
615         buffer[0] = "0";
616         buffer[1] = "x";
617         for (uint256 i = 2 * length + 1; i > 1; --i) {
618             buffer[i] = _HEX_SYMBOLS[value & 0xf];
619             value >>= 4;
620         }
621         require(value == 0, "Strings: hex length insufficient");
622         return string(buffer);
623     }
624 }
625 
626 
627 
628 // File: @openzeppelin/contracts/utils/Address.sol
629 
630 
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Collection of functions related to the address type
636  */
637 library Address {
638     /**
639      * @dev Returns true if `account` is a contract.
640      *
641      * [IMPORTANT]
642      * ====
643      * It is unsafe to assume that an address for which this function returns
644      * false is an externally-owned account (EOA) and not a contract.
645      *
646      * Among others, `isContract` will return false for the following
647      * types of addresses:
648      *
649      *  - an externally-owned account
650      *  - a contract in construction
651      *  - an address where a contract will be created
652      *  - an address where a contract lived, but was destroyed
653      * ====
654      */
655     function isContract(address account) internal view returns (bool) {
656         // This method relies on extcodesize, which returns 0 for contracts in
657         // construction, since the code is only stored at the end of the
658         // constructor execution.
659 
660         uint256 size;
661         assembly {
662             size := extcodesize(account)
663         }
664         return size > 0;
665     }
666 
667     /**
668      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
669      * `recipient`, forwarding all available gas and reverting on errors.
670      *
671      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
672      * of certain opcodes, possibly making contracts go over the 2300 gas limit
673      * imposed by `transfer`, making them unable to receive funds via
674      * `transfer`. {sendValue} removes this limitation.
675      *
676      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
677      *
678      * IMPORTANT: because control is transferred to `recipient`, care must be
679      * taken to not create reentrancy vulnerabilities. Consider using
680      * {ReentrancyGuard} or the
681      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
682      */
683     function sendValue(address payable recipient, uint256 amount) internal {
684         require(address(this).balance >= amount, "Address: insufficient balance");
685 
686         (bool success, ) = recipient.call{value: amount}("");
687         require(success, "Address: unable to send value, recipient may have reverted");
688     }
689 
690     /**
691      * @dev Performs a Solidity function call using a low level `call`. A
692      * plain `call` is an unsafe replacement for a function call: use this
693      * function instead.
694      *
695      * If `target` reverts with a revert reason, it is bubbled up by this
696      * function (like regular Solidity function calls).
697      *
698      * Returns the raw returned data. To convert to the expected return value,
699      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
700      *
701      * Requirements:
702      *
703      * - `target` must be a contract.
704      * - calling `target` with `data` must not revert.
705      *
706      * _Available since v3.1._
707      */
708     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
709         return functionCall(target, data, "Address: low-level call failed");
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
714      * `errorMessage` as a fallback revert reason when `target` reverts.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(
719         address target,
720         bytes memory data,
721         string memory errorMessage
722     ) internal returns (bytes memory) {
723         return functionCallWithValue(target, data, 0, errorMessage);
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
728      * but also transferring `value` wei to `target`.
729      *
730      * Requirements:
731      *
732      * - the calling contract must have an ETH balance of at least `value`.
733      * - the called Solidity function must be `payable`.
734      *
735      * _Available since v3.1._
736      */
737     function functionCallWithValue(
738         address target,
739         bytes memory data,
740         uint256 value
741     ) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
747      * with `errorMessage` as a fallback revert reason when `target` reverts.
748      *
749      * _Available since v3.1._
750      */
751     function functionCallWithValue(
752         address target,
753         bytes memory data,
754         uint256 value,
755         string memory errorMessage
756     ) internal returns (bytes memory) {
757         require(address(this).balance >= value, "Address: insufficient balance for call");
758         require(isContract(target), "Address: call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.call{value: value}(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
766      * but performing a static call.
767      *
768      * _Available since v3.3._
769      */
770     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
771         return functionStaticCall(target, data, "Address: low-level static call failed");
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
776      * but performing a static call.
777      *
778      * _Available since v3.3._
779      */
780     function functionStaticCall(
781         address target,
782         bytes memory data,
783         string memory errorMessage
784     ) internal view returns (bytes memory) {
785         require(isContract(target), "Address: static call to non-contract");
786 
787         (bool success, bytes memory returndata) = target.staticcall(data);
788         return verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but performing a delegate call.
794      *
795      * _Available since v3.4._
796      */
797     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
798         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
803      * but performing a delegate call.
804      *
805      * _Available since v3.4._
806      */
807     function functionDelegateCall(
808         address target,
809         bytes memory data,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         require(isContract(target), "Address: delegate call to non-contract");
813 
814         (bool success, bytes memory returndata) = target.delegatecall(data);
815         return verifyCallResult(success, returndata, errorMessage);
816     }
817 
818     /**
819      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
820      * revert reason using the provided one.
821      *
822      * _Available since v4.3._
823      */
824     function verifyCallResult(
825         bool success,
826         bytes memory returndata,
827         string memory errorMessage
828     ) internal pure returns (bytes memory) {
829         if (success) {
830             return returndata;
831         } else {
832             // Look for revert reason and bubble it up if present
833             if (returndata.length > 0) {
834                 // The easiest way to bubble the revert reason is using memory via assembly
835 
836                 assembly {
837                     let returndata_size := mload(returndata)
838                     revert(add(32, returndata), returndata_size)
839                 }
840             } else {
841                 revert(errorMessage);
842             }
843         }
844     }
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
848 
849 
850 
851 pragma solidity ^0.8.0;
852 
853 
854 /**
855  * @dev Required interface of an ERC721 compliant contract.
856  */
857 interface IERC721 is IERC165 {
858     /**
859      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
860      */
861     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
862 
863     /**
864      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
865      */
866     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
867 
868     /**
869      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
870      */
871     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
872 
873     /**
874      * @dev Returns the number of tokens in ``owner``'s account.
875      */
876     function balanceOf(address owner) external view returns (uint256 balance);
877 
878     /**
879      * @dev Returns the owner of the `tokenId` token.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      */
885     function ownerOf(uint256 tokenId) external view returns (address owner);
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) external;
906 
907     /**
908      * @dev Transfers `tokenId` token from `from` to `to`.
909      *
910      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
918      *
919      * Emits a {Transfer} event.
920      */
921     function transferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) external;
926 
927     /**
928      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
929      * The approval is cleared when the token is transferred.
930      *
931      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
932      *
933      * Requirements:
934      *
935      * - The caller must own the token or be an approved operator.
936      * - `tokenId` must exist.
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address to, uint256 tokenId) external;
941 
942     /**
943      * @dev Returns the account approved for `tokenId` token.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must exist.
948      */
949     function getApproved(uint256 tokenId) external view returns (address operator);
950 
951     /**
952      * @dev Approve or remove `operator` as an operator for the caller.
953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
954      *
955      * Requirements:
956      *
957      * - The `operator` cannot be the caller.
958      *
959      * Emits an {ApprovalForAll} event.
960      */
961     function setApprovalForAll(address operator, bool _approved) external;
962 
963     /**
964      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
965      *
966      * See {setApprovalForAll}
967      */
968     function isApprovedForAll(address owner, address operator) external view returns (bool);
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes calldata data
988     ) external;
989 }
990 
991 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
992 
993 
994 
995 pragma solidity ^0.8.0;
996 
997 
998 /**
999  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1000  * @dev See https://eips.ethereum.org/EIPS/eip-721
1001  */
1002 interface IERC721Metadata is IERC721 {
1003     /**
1004      * @dev Returns the token collection name.
1005      */
1006     function name() external view returns (string memory);
1007 
1008     /**
1009      * @dev Returns the token collection symbol.
1010      */
1011     function symbol() external view returns (string memory);
1012 
1013     /**
1014      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1015      */
1016     function tokenURI(uint256 tokenId) external view returns (string memory);
1017 }
1018 
1019 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1020 
1021 
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 /**
1026  * @title ERC721 token receiver interface
1027  * @dev Interface for any contract that wants to support safeTransfers
1028  * from ERC721 asset contracts.
1029  */
1030 interface IERC721Receiver {
1031     /**
1032      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1033      * by `operator` from `from`, this function is called.
1034      *
1035      * It must return its Solidity selector to confirm the token transfer.
1036      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1037      *
1038      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1039      */
1040     function onERC721Received(
1041         address operator,
1042         address from,
1043         uint256 tokenId,
1044         bytes calldata data
1045     ) external returns (bytes4);
1046 }
1047 
1048 
1049 
1050 
1051 
1052 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1053 
1054 
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 /**
1066  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1067  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1068  * {ERC721Enumerable}.
1069  */
1070 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1071     using Address for address;
1072     using Strings for uint256;
1073 
1074     // Token name
1075     string private _name;
1076 
1077     // Token symbol
1078     string private _symbol;
1079 
1080     // Mapping from token ID to owner address
1081     mapping(uint256 => address) private _owners;
1082 
1083     // Mapping owner address to token count
1084     mapping(address => uint256) private _balances;
1085 
1086     // Mapping from token ID to approved address
1087     mapping(uint256 => address) private _tokenApprovals;
1088 
1089     // Mapping from owner to operator approvals
1090     mapping(address => mapping(address => bool)) private _operatorApprovals;
1091 
1092     /**
1093      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1094      */
1095     constructor(string memory name_, string memory symbol_) {
1096         _name = name_;
1097         _symbol = symbol_;
1098     }
1099 
1100     /**
1101      * @dev See {IERC165-supportsInterface}.
1102      */
1103     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1104         return
1105             interfaceId == type(IERC721).interfaceId ||
1106             interfaceId == type(IERC721Metadata).interfaceId ||
1107             super.supportsInterface(interfaceId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-balanceOf}.
1112      */
1113     function balanceOf(address owner) public view virtual override returns (uint256) {
1114         require(owner != address(0), "ERC721: balance query for the zero address");
1115         return _balances[owner];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-ownerOf}.
1120      */
1121     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1122         address owner = _owners[tokenId];
1123         require(owner != address(0), "ERC721: owner query for nonexistent token");
1124         return owner;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-name}.
1129      */
1130     function name() public view virtual override returns (string memory) {
1131         return _name;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-symbol}.
1136      */
1137     function symbol() public view virtual override returns (string memory) {
1138         return _symbol;
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Metadata-tokenURI}.
1143      */
1144     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1145         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1146 
1147         string memory baseURI = _baseURI();
1148         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1149     }
1150 
1151     /**
1152      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1153      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1154      * by default, can be overriden in child contracts.
1155      */
1156     function _baseURI() internal view virtual returns (string memory) {
1157         return "";
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-approve}.
1162      */
1163     function approve(address to, uint256 tokenId) public virtual override {
1164         address owner = ERC721.ownerOf(tokenId);
1165         require(to != owner, "ERC721: approval to current owner");
1166 
1167         require(
1168             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1169             "ERC721: approve caller is not owner nor approved for all"
1170         );
1171 
1172         _approve(to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-getApproved}.
1177      */
1178     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1179         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1180 
1181         return _tokenApprovals[tokenId];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-setApprovalForAll}.
1186      */
1187     function setApprovalForAll(address operator, bool approved) public virtual override {
1188         require(operator != _msgSender(), "ERC721: approve to caller");
1189 
1190         _operatorApprovals[_msgSender()][operator] = approved;
1191         emit ApprovalForAll(_msgSender(), operator, approved);
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-isApprovedForAll}.
1196      */
1197     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1198         return _operatorApprovals[owner][operator];
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-transferFrom}.
1203      */
1204     function transferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) public virtual override {
1209         //solhint-disable-next-line max-line-length
1210         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1211 
1212         _transfer(from, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-safeTransferFrom}.
1217      */
1218     function safeTransferFrom(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) public virtual override {
1223         safeTransferFrom(from, to, tokenId, "");
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-safeTransferFrom}.
1228      */
1229     function safeTransferFrom(
1230         address from,
1231         address to,
1232         uint256 tokenId,
1233         bytes memory _data
1234     ) public virtual override {
1235         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1236         _safeTransfer(from, to, tokenId, _data);
1237     }
1238 
1239     /**
1240      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1241      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1242      *
1243      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1244      *
1245      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1246      * implement alternative mechanisms to perform token transfer, such as signature-based.
1247      *
1248      * Requirements:
1249      *
1250      * - `from` cannot be the zero address.
1251      * - `to` cannot be the zero address.
1252      * - `tokenId` token must exist and be owned by `from`.
1253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _safeTransfer(
1258         address from,
1259         address to,
1260         uint256 tokenId,
1261         bytes memory _data
1262     ) internal virtual {
1263         _transfer(from, to, tokenId);
1264         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1265     }
1266 
1267     /**
1268      * @dev Returns whether `tokenId` exists.
1269      *
1270      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1271      *
1272      * Tokens start existing when they are minted (`_mint`),
1273      * and stop existing when they are burned (`_burn`).
1274      */
1275     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1276         return _owners[tokenId] != address(0);
1277     }
1278 
1279     /**
1280      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must exist.
1285      */
1286     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1287         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1288         address owner = ERC721.ownerOf(tokenId);
1289         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1290     }
1291 
1292     /**
1293      * @dev Safely mints `tokenId` and transfers it to `to`.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must not exist.
1298      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _safeMint(address to, uint256 tokenId) internal virtual {
1303         _safeMint(to, tokenId, "");
1304     }
1305 
1306     /**
1307      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1308      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1309      */
1310     function _safeMint(
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) internal virtual {
1315         _mint(to, tokenId);
1316         require(
1317             _checkOnERC721Received(address(0), to, tokenId, _data),
1318             "ERC721: transfer to non ERC721Receiver implementer"
1319         );
1320     }
1321 
1322     /**
1323      * @dev Mints `tokenId` and transfers it to `to`.
1324      *
1325      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1326      *
1327      * Requirements:
1328      *
1329      * - `tokenId` must not exist.
1330      * - `to` cannot be the zero address.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _mint(address to, uint256 tokenId) internal virtual {
1335         require(to != address(0), "ERC721: mint to the zero address");
1336         require(!_exists(tokenId), "ERC721: token already minted");
1337 
1338         _beforeTokenTransfer(address(0), to, tokenId);
1339 
1340         _balances[to] += 1;
1341         _owners[tokenId] = to;
1342 
1343         emit Transfer(address(0), to, tokenId);
1344     }
1345 
1346     /**
1347      * @dev Destroys `tokenId`.
1348      * The approval is cleared when the token is burned.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _burn(uint256 tokenId) internal virtual {
1357         address owner = ERC721.ownerOf(tokenId);
1358 
1359         _beforeTokenTransfer(owner, address(0), tokenId);
1360 
1361         // Clear approvals
1362         _approve(address(0), tokenId);
1363 
1364         _balances[owner] -= 1;
1365         delete _owners[tokenId];
1366 
1367         emit Transfer(owner, address(0), tokenId);
1368     }
1369 
1370     /**
1371      * @dev Transfers `tokenId` from `from` to `to`.
1372      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1373      *
1374      * Requirements:
1375      *
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must be owned by `from`.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _transfer(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) internal virtual {
1386         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1387         require(to != address(0), "ERC721: transfer to the zero address");
1388 
1389         _beforeTokenTransfer(from, to, tokenId);
1390 
1391         // Clear approvals from the previous owner
1392         _approve(address(0), tokenId);
1393 
1394         _balances[from] -= 1;
1395         _balances[to] += 1;
1396         _owners[tokenId] = to;
1397 
1398         emit Transfer(from, to, tokenId);
1399     }
1400 
1401     /**
1402      * @dev Approve `to` to operate on `tokenId`
1403      *
1404      * Emits a {Approval} event.
1405      */
1406     function _approve(address to, uint256 tokenId) internal virtual {
1407         _tokenApprovals[tokenId] = to;
1408         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1409     }
1410 
1411     /**
1412      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1413      * The call is not executed if the target address is not a contract.
1414      *
1415      * @param from address representing the previous owner of the given token ID
1416      * @param to target address that will receive the tokens
1417      * @param tokenId uint256 ID of the token to be transferred
1418      * @param _data bytes optional data to send along with the call
1419      * @return bool whether the call correctly returned the expected magic value
1420      */
1421     function _checkOnERC721Received(
1422         address from,
1423         address to,
1424         uint256 tokenId,
1425         bytes memory _data
1426     ) private returns (bool) {
1427         if (to.isContract()) {
1428             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1429                 return retval == IERC721Receiver.onERC721Received.selector;
1430             } catch (bytes memory reason) {
1431                 if (reason.length == 0) {
1432                     revert("ERC721: transfer to non ERC721Receiver implementer");
1433                 } else {
1434                     assembly {
1435                         revert(add(32, reason), mload(reason))
1436                     }
1437                 }
1438             }
1439         } else {
1440             return true;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Hook that is called before any token transfer. This includes minting
1446      * and burning.
1447      *
1448      * Calling conditions:
1449      *
1450      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1451      * transferred to `to`.
1452      * - When `from` is zero, `tokenId` will be minted for `to`.
1453      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1454      * - `from` and `to` are never both zero.
1455      *
1456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1457      */
1458     function _beforeTokenTransfer(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) internal virtual {}
1463 }
1464 
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 contract LuckyZerosNFT is ERC721, Ownable, Pausable {
1469     using SafeMath for uint256;
1470     using Counters for Counters.Counter;
1471     Counters.Counter private tokenTRACK;
1472     address public proxyRegistryAddress;
1473     mapping(address => bool) public projectProxy;
1474     uint256 private _PRICE = 0.06 ether;
1475     uint256 private  _MAXLucky = 20;
1476     uint256 private  _MAXPresaleLucky = 10;
1477     mapping(address => uint256) private _tokensMintedByAddress;
1478     uint256 public constant MAXSUPPLY = 8888;
1479     uint256 private _MAXPRESALESUPPLY = 6000;
1480     bool public minting;
1481     bool public presaleminting;
1482     string private _baseTokenURI = 'https://nft.luckyzeros.io/';
1483     string public provenance;
1484     constructor() ERC721("Lucky Zeros NFT", "LUCKYZEROS") {
1485         pause(true);
1486     }
1487     function flipMint() public onlyOwner {
1488         minting = !minting;
1489     }
1490     function flipPresaleMint() public onlyOwner {
1491         presaleminting = !presaleminting;
1492     }
1493     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1494         proxyRegistryAddress = _proxyRegistryAddress;
1495     }
1496     function mintReserves(uint _qty) public onlyOwner {
1497         for(uint i; i < _qty; i++){
1498 	        tokenTRACK.increment();
1499             _safeMint(msg.sender, tokenTRACK.current());
1500         }
1501     }
1502     function flipProxyState(address proxyAddress) public onlyOwner {
1503         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1504     }
1505     function mintNFTS(uint256 _qty) public payable {
1506         require(minting, "Mint closed");
1507         require(_qty <= _MAXLucky, "More than allowed per transaction");
1508         require(_tokensMintedByAddress[_msgSender()] + _qty < _MAXLucky + _MAXPresaleLucky + 1, "More than allowed per wallet"); 
1509         require(getItemPrice().mul(_qty) == msg.value, "Not enough ETH");
1510         require(tokenTRACK.current().add(_qty) < MAXSUPPLY + 1, "More than max supply");
1511         _tokensMintedByAddress[_msgSender()] += _qty;
1512         for (uint256 i; i < _qty; i++) {
1513             tokenTRACK.increment();
1514             _safeMint(msg.sender, tokenTRACK.current());
1515         }
1516 	}
1517     function presaleMint(uint256 _qty) public payable {
1518         require(presaleminting, "Pre-Sale Mint closed");
1519         require(_qty <= _MAXPresaleLucky, "More than allowed per transaction");
1520         require(_tokensMintedByAddress[_msgSender()] + _qty < _MAXPresaleLucky + 1, "More than allowed per wallet"); 
1521         require(getItemPrice().mul(_qty) == msg.value, "Not enough ETH");
1522         require(tokenTRACK.current().add(_qty) < _MAXPRESALESUPPLY + 1, "More than max supply");
1523         _tokensMintedByAddress[_msgSender()] += _qty;
1524         for (uint256 i; i < _qty; i++) {
1525             tokenTRACK.increment();
1526             _safeMint(msg.sender, tokenTRACK.current());
1527         }
1528     }
1529     function getItemPrice() public view returns (uint256) {
1530         return _PRICE;
1531     }
1532     function setItemPrice(uint256 _price) public onlyOwner {
1533         _PRICE = _price;
1534     }
1535     function getNumPerMint() public view returns (uint256) {
1536         return _MAXLucky;
1537     }
1538     function setNumPerMint(uint256 _max) public onlyOwner {
1539         _MAXLucky = _max;
1540     }
1541     function setPreSaleLimit(uint256 _presalelimit) public onlyOwner {
1542         _MAXPRESALESUPPLY = _presalelimit;
1543     }
1544     function _totalSupply() internal view returns (uint256) {
1545         return tokenTRACK.current();
1546     }
1547     function totalMinted() public view returns (uint256) {
1548         return _totalSupply();
1549     }
1550     function pause(bool val) public onlyOwner {
1551         if (val == true) {
1552             _pause();
1553             return;
1554         }
1555         _unpause();
1556     }
1557     function _baseURI() internal view virtual override returns (string memory) {
1558         return _baseTokenURI;
1559     }
1560     function setBaseURI(string memory baseURI) public onlyOwner {
1561         _baseTokenURI = baseURI;
1562     }
1563     function setProvenance(string memory hash) public onlyOwner {
1564         provenance = hash;
1565     }
1566     function withdraw() public payable onlyOwner {
1567         uint256 balance = address(this).balance;
1568         require(balance > 0);
1569         _withdraw(msg.sender, balance);
1570     }
1571     function _withdraw(address _address, uint256 _amount) private {
1572         (bool success, ) = _address.call{value: _amount}("");
1573         require(success, "Transfer failed.");
1574     }
1575     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1576         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1577         if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1578         return super.isApprovedForAll(_owner, operator);
1579     }
1580 }
1581 contract OwnableDelegateProxy { }
1582 contract OpenSeaProxyRegistry {
1583     mapping(address => OwnableDelegateProxy) public proxies;
1584 }