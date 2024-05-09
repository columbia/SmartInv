1 // File: contracts\math\ABDKMath.sol
2 
3 /*
4  * ABDK Math 64.64 Smart Contract Library.  Copyright ┬⌐ 2019 by ABDK Consulting.
5  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
6  */
7 pragma solidity ^0.6.0;
8 
9 /**
10  * Smart contract library of mathematical functions operating with signed
11  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
12  * basically a simple fraction whose numerator is signed 128-bit integer and
13  * denominator is 2^64.  As long as denominator is always the same, there is no
14  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
15  * represented by int128 type holding only the numerator.
16  */
17 library ABDKMath64x64 {
18   /**
19    * Minimum value signed 64.64-bit fixed point number may have.
20    */
21   int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
22 
23   /**
24    * Maximum value signed 64.64-bit fixed point number may have.
25    */
26   int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28   /**
29    * Calculate x + y.  Revert on overflow.
30    *
31    * @param x signed 64.64-bit fixed point number
32    * @param y signed 64.64-bit fixed point number
33    * @return signed 64.64-bit fixed point number
34    */
35   function add (int128 x, int128 y) internal pure returns (int128) {
36     int256 result = int256(x) + y;
37     require (result >= MIN_64x64 && result <= MAX_64x64);
38     return int128 (result);
39   }
40 
41   /**
42    * Calculate x * y rounding down, where x is signed 64.64 fixed point number
43    * and y is unsigned 256-bit integer number.  Revert on overflow.
44    *
45    * @param x signed 64.64 fixed point number
46    * @param y unsigned 256-bit integer number
47    * @return unsigned 256-bit integer number
48    */
49   function mulu (int128 x, uint256 y) internal pure returns (uint256) {
50     if (y == 0) return 0;
51 
52     require (x >= 0);
53 
54     uint256 lo = (uint256 (x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
55     uint256 hi = uint256 (x) * (y >> 128);
56 
57     require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
58     hi <<= 64;
59 
60     require (hi <=
61       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
62     return hi + lo;
63   }
64 
65   /**
66    * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
67    * and y is unsigned 256-bit integer number.  Revert on overflow.
68    *
69    * @param x signed 64.64-bit fixed point number
70    * @param y uint256 value
71    * @return signed 64.64-bit fixed point number
72    */
73   function pow (int128 x, uint256 y) internal pure returns (int128) {
74     uint256 absoluteResult;
75     bool negativeResult = false;
76     if (x >= 0) {
77       absoluteResult = powu (uint256 (x) << 63, y);
78     } else {
79       // We rely on overflow behavior here
80       absoluteResult = powu (uint256 (uint128 (-x)) << 63, y);
81       negativeResult = y & 1 > 0;
82     }
83 
84     absoluteResult >>= 63;
85 
86     if (negativeResult) {
87       require (absoluteResult <= 0x80000000000000000000000000000000);
88       return -int128 (absoluteResult); // We rely on overflow behavior here
89     } else {
90       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
91       return int128 (absoluteResult); // We rely on overflow behavior here
92     }
93   }
94 
95   /**
96    * Calculate x^y assuming 0^0 is 1, where x is unsigned 129.127 fixed point
97    * number and y is unsigned 256-bit integer number.  Revert on overflow.
98    *
99    * @param x unsigned 129.127-bit fixed point number
100    * @param y uint256 value
101    * @return unsigned 129.127-bit fixed point number
102    */
103   function powu (uint256 x, uint256 y) private pure returns (uint256) {
104     if (y == 0) return 0x80000000000000000000000000000000;
105     else if (x == 0) return 0;
106     else {
107       int256 msb = 0;
108       uint256 xc = x;
109       if (xc >= 0x100000000000000000000000000000000) { xc >>= 128; msb += 128; }
110       if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
111       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
112       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
113       if (xc >= 0x100) { xc >>= 8; msb += 8; }
114       if (xc >= 0x10) { xc >>= 4; msb += 4; }
115       if (xc >= 0x4) { xc >>= 2; msb += 2; }
116       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
117 
118       int256 xe = msb - 127;
119       if (xe > 0) x >>= xe;
120       else x <<= -xe;
121 
122       uint256 result = 0x80000000000000000000000000000000;
123       int256 re = 0;
124 
125       while (y > 0) {
126         if (y & 1 > 0) {
127           result = result * x;
128           y -= 1;
129           re += xe;
130           if (result >=
131             0x8000000000000000000000000000000000000000000000000000000000000000) {
132             result >>= 128;
133             re += 1;
134           } else result >>= 127;
135           if (re < -127) return 0; // Underflow
136           require (re < 128); // Overflow
137         } else {
138           x = x * x;
139           y >>= 1;
140           xe <<= 1;
141           if (x >=
142             0x8000000000000000000000000000000000000000000000000000000000000000) {
143             x >>= 128;
144             xe += 1;
145           } else x >>= 127;
146           if (xe < -127) return 0; // Underflow
147           require (xe < 128); // Overflow
148         }
149       }
150 
151       if (re > 0) result <<= re;
152       else if (re < 0) result >>= -re;
153 
154       return result;
155     }
156   }
157 }
158 
159 // File: node_modules\openzeppelin-solidity\contracts\GSN\Context.sol
160 
161 // SPDX-License-Identifier: MIT
162 
163 pragma solidity ^0.6.0;
164 
165 /*
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with GSN meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
187 
188 // SPDX-License-Identifier: MIT
189 
190 pragma solidity ^0.6.0;
191 
192 /**
193  * @dev Interface of the ERC20 standard as defined in the EIP.
194  */
195 interface IERC20 {
196     /**
197      * @dev Returns the amount of tokens in existence.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns the amount of tokens owned by `account`.
203      */
204     function balanceOf(address account) external view returns (uint256);
205 
206     /**
207      * @dev Moves `amount` tokens from the caller's account to `recipient`.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transfer(address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Returns the remaining number of tokens that `spender` will be
217      * allowed to spend on behalf of `owner` through {transferFrom}. This is
218      * zero by default.
219      *
220      * This value changes when {approve} or {transferFrom} are called.
221      */
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `sender` to `recipient` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
267 
268 // SPDX-License-Identifier: MIT
269 
270 pragma solidity ^0.6.0;
271 
272 /**
273  * @dev Wrappers over Solidity's arithmetic operations with added overflow
274  * checks.
275  *
276  * Arithmetic operations in Solidity wrap on overflow. This can easily result
277  * in bugs, because programmers usually assume that an overflow raises an
278  * error, which is the standard behavior in high level programming languages.
279  * `SafeMath` restores this intuition by reverting the transaction when an
280  * operation overflows.
281  *
282  * Using this library instead of the unchecked operations eliminates an entire
283  * class of bugs, so it's recommended to use it always.
284  */
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      *
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         return sub(a, b, "SafeMath: subtraction overflow");
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         uint256 c = a - b;
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers. Reverts on
360      * division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * Reverts when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return mod(a, b, "SafeMath: modulo by zero");
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * Reverts with custom message when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b != 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
429 
430 // SPDX-License-Identifier: MIT
431 
432 pragma solidity ^0.6.2;
433 
434 /**
435  * @dev Collection of functions related to the address type
436  */
437 library Address {
438     /**
439      * @dev Returns true if `account` is a contract.
440      *
441      * [IMPORTANT]
442      * ====
443      * It is unsafe to assume that an address for which this function returns
444      * false is an externally-owned account (EOA) and not a contract.
445      *
446      * Among others, `isContract` will return false for the following
447      * types of addresses:
448      *
449      *  - an externally-owned account
450      *  - a contract in construction
451      *  - an address where a contract will be created
452      *  - an address where a contract lived, but was destroyed
453      * ====
454      */
455     function isContract(address account) internal view returns (bool) {
456         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
457         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
458         // for accounts without code, i.e. `keccak256('')`
459         bytes32 codehash;
460         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
461         // solhint-disable-next-line no-inline-assembly
462         assembly { codehash := extcodehash(account) }
463         return (codehash != accountHash && codehash != 0x0);
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(address(this).balance >= amount, "Address: insufficient balance");
484 
485         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
486         (bool success, ) = recipient.call{ value: amount }("");
487         require(success, "Address: unable to send value, recipient may have reverted");
488     }
489 
490     /**
491      * @dev Performs a Solidity function call using a low level `call`. A
492      * plain`call` is an unsafe replacement for a function call: use this
493      * function instead.
494      *
495      * If `target` reverts with a revert reason, it is bubbled up by this
496      * function (like regular Solidity function calls).
497      *
498      * Returns the raw returned data. To convert to the expected return value,
499      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
500      *
501      * Requirements:
502      *
503      * - `target` must be a contract.
504      * - calling `target` with `data` must not revert.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
509       return functionCall(target, data, "Address: low-level call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
514      * `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
519         return _functionCallWithValue(target, data, 0, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but also transferring `value` wei to `target`.
525      *
526      * Requirements:
527      *
528      * - the calling contract must have an ETH balance of at least `value`.
529      * - the called Solidity function must be `payable`.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
539      * with `errorMessage` as a fallback revert reason when `target` reverts.
540      *
541      * _Available since v3.1._
542      */
543     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         return _functionCallWithValue(target, data, value, errorMessage);
546     }
547 
548     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
549         require(isContract(target), "Address: call to non-contract");
550 
551         // solhint-disable-next-line avoid-low-level-calls
552         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
553         if (success) {
554             return returndata;
555         } else {
556             // Look for revert reason and bubble it up if present
557             if (returndata.length > 0) {
558                 // The easiest way to bubble the revert reason is using memory via assembly
559 
560                 // solhint-disable-next-line no-inline-assembly
561                 assembly {
562                     let returndata_size := mload(returndata)
563                     revert(add(32, returndata), returndata_size)
564                 }
565             } else {
566                 revert(errorMessage);
567             }
568         }
569     }
570 }
571 
572 // File: contracts\FLOW.sol
573 
574 pragma solidity ^0.6.2;
575 
576 
577 
578 
579 
580 
581 contract FLOW is Context, IERC20 {
582     using SafeMath for uint256;
583     using ABDKMath64x64 for int128;
584     using Address for address;
585 
586     mapping (address => uint256) private _partsOwned;
587     mapping (address => mapping (address => uint256)) private _allowances;
588 
589     uint256 private constant INITIAL_SUPPLY = 10 * 10**6 * 10**9;
590     uint256 private constant MAX_UINT = ~uint256(0);
591     uint256 private constant TOTAL_PARTS = MAX_UINT - (MAX_UINT % INITIAL_SUPPLY);
592 
593     uint256 private constant CYCLE_SECONDS = 86400;
594     uint256 private constant FINAL_CYCLE = 3711;
595 
596     struct Era {
597         uint256 startCycle;
598         uint256 endCycle;
599         int128 cycleInflation;
600         uint256 finalSupply;
601     }
602 
603     Era[11] private _eras;
604     uint256 private _startTime;
605 
606     string private _name;
607     string private _symbol;
608     uint8 private _decimals;
609 
610     constructor () public {
611         _name = 'Flow Protocol';
612         _symbol = 'FLOW';
613         _decimals = 9;
614 
615         _partsOwned[_msgSender()] = TOTAL_PARTS;
616         _initEras();
617         _startTime = now;
618     }
619 
620     function _initEras() private {
621         _eras[0] = Era(1, 60, 184467440737095516, 18166966985640902);
622         _eras[1] = Era(61, 425, 92233720368547758, 112174713264391144);
623         _eras[2] = Era(426, 790, 46116860184273879, 279057783081840914);
624         _eras[3] = Era(791, 1155, 23058430092136939, 440268139544969912);
625         _eras[4] = Era(1156, 1520, 11529215046068469, 553044069474490613);
626         _eras[5] = Era(1521, 1885, 5764607523034234, 619853011328525904);
627         _eras[6] = Era(1886, 2250, 2882303761517117, 656228575376038043);
628         _eras[7] = Era(2251, 2615, 1441151880758558, 675209948612919169);
629         _eras[8] = Era(2616, 2980, 720575940379279, 684905732173838476);
630         _eras[9] = Era(2981, 3345, 360287970189639, 689805758238227141);
631         _eras[10] = Era(3346, 3710, 180143985094819, 692268913795056564);
632     }
633 
634     function name() public view returns (string memory) {
635         return _name;
636     }
637 
638     function symbol() public view returns (string memory) {
639         return _symbol;
640     }
641 
642     function decimals() public view returns (uint8) {
643         return _decimals;
644     }
645 
646     function startTime() external view returns(uint256) {
647         return _startTime;
648     }
649 
650     function sendAirdrop(address[] calldata recipients, uint256 airdropAmt) external {
651         for (uint256 i = 0; i < recipients.length; i++) {
652             transfer(recipients[i], airdropAmt);
653         }
654     }
655 
656     function totalSupply() public view override returns (uint256) {
657         return _getSupply(INITIAL_SUPPLY, getCurrentCycle());
658     }
659 
660     function balanceOf(address account) public view override returns (uint256) {
661         return _partsOwned[account].div(_getRate(TOTAL_PARTS, totalSupply()));
662     }
663 
664     function transfer(address recipient, uint256 amount) public override returns (bool) {
665         _transfer(_msgSender(), recipient, amount);
666         return true;
667     }
668 
669     function allowance(address owner, address spender) public view override returns (uint256) {
670         return _allowances[owner][spender];
671     }
672 
673     function approve(address spender, uint256 amount) public override returns (bool) {
674         _approve(_msgSender(), spender, amount);
675         return true;
676     }
677 
678     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
679         _transfer(sender, recipient, amount);
680         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
681         return true;
682     }
683 
684     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
685         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
686         return true;
687     }
688 
689     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
690         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
691         return true;
692     }
693 
694     function getCurrentCycle() public view returns (uint256) {
695         return _getCycle(_startTime, now);
696     }
697 
698     function _approve(address owner, address spender, uint256 amount) private {
699         require(owner != address(0), "ERC20: approve from the zero address");
700         require(spender != address(0), "ERC20: approve to the zero address");
701 
702         _allowances[owner][spender] = amount;
703         emit Approval(owner, spender, amount);
704     }
705 
706     function _transfer(address sender, address recipient, uint256 amount) private {
707         require(sender != address(0), "ERC20: transfer from the zero address");
708         require(recipient != address(0), "ERC20: transfer to the zero address");
709 
710         uint256 currentRate = _getRate(TOTAL_PARTS, totalSupply());
711         uint256 partsToTransfer = amount.mul(currentRate);
712         _partsOwned[sender] = _partsOwned[sender].sub(partsToTransfer);
713         _partsOwned[recipient] = _partsOwned[recipient].add(partsToTransfer);
714         emit Transfer(sender, recipient, amount);
715     }
716 
717     function _getCycle(uint256 startTime, uint256 currentTime) private pure returns(uint256) {
718         uint256 secondsElapsed = _getElapsedSeconds(startTime, currentTime);
719         uint256 cycle = (secondsElapsed - (secondsElapsed % CYCLE_SECONDS)) / CYCLE_SECONDS + 1;
720         if (cycle >= FINAL_CYCLE) return FINAL_CYCLE;
721         return cycle;
722     }
723 
724     function _getElapsedSeconds(uint256 startTime, uint256 currentTime) private pure returns(uint256) {
725         return currentTime.sub(startTime);
726     }
727 
728     function _getSupply(uint256 initialSupply, uint256 currentCycle) private view returns(uint256) {
729         uint256 currentSupply = initialSupply;
730         for (uint256 i = 0; i < _eras.length; i++) {
731             Era memory era = _eras[i];
732             if (currentCycle > era.endCycle) {
733                 currentSupply = era.finalSupply;
734             } else {
735                 currentSupply = _compound(currentSupply, era.cycleInflation, currentCycle.sub(era.startCycle));
736                 break;
737             }
738         }
739         return currentSupply;
740     }
741 
742     function _compound(uint256 principle, int128 rate, uint256 periods) private pure returns(uint256){
743         uint256 result = ABDKMath64x64.mulu(
744                             ABDKMath64x64.pow (
745                                 ABDKMath64x64.add (
746                                 0x10000000000000000,
747                                 rate),
748                                 periods), principle);
749         return result;
750     }
751 
752     function _getRate(uint256 totalParts, uint256 supply) private pure returns(uint256) {
753         return totalParts.div(supply);
754     }
755 }