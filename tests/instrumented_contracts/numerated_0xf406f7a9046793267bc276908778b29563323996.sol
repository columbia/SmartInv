1 pragma solidity 0.5.17;
2 
3 
4 /**
5  * Source: https://raw.githubusercontent.com/simple-restricted-token/reference-implementation/master/contracts/token/ERC1404/ERC1404.sol
6  * With ERC-20 APIs removed (will be implemented as a separate contract).
7  * And adding authorizeTransfer.
8  */
9 interface IWhitelist {
10   /**
11    * @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
12    * @param from Sending address
13    * @param to Receiving address
14    * @param value Amount of tokens being transferred
15    * @return Code by which to reference message for rejection reasoning
16    * @dev Overwrite with your custom transfer restriction logic
17    */
18   function detectTransferRestriction(
19     address from,
20     address to,
21     uint value
22   ) external view returns (uint8);
23 
24   /**
25    * @notice Returns a human-readable message for a given restriction code
26    * @param restrictionCode Identifier for looking up a message
27    * @return Text showing the restriction's reasoning
28    * @dev Overwrite with your custom message and restrictionCode handling
29    */
30   function messageForTransferRestriction(uint8 restrictionCode)
31     external
32     pure
33     returns (string memory);
34 
35   /**
36    * @notice Called by the DAT contract before a transfer occurs.
37    * @dev This call will revert when the transfer is not authorized.
38    * This is a mutable call to allow additional data to be recorded,
39    * such as when the user aquired their tokens.
40    */
41   function authorizeTransfer(
42     address _from,
43     address _to,
44     uint _value,
45     bool _isSell
46   ) external;
47 
48   function activateWallet(
49     address _wallet
50   ) external;
51 
52   function deactivateWallet(
53     address _wallet
54   ) external;
55 
56   function walletActivated(
57     address _wallet
58   ) external returns(bool);
59 }
60 
61 interface IERC20Detailed {
62   /**
63    * @dev Returns the number of decimals used to get its user representation.
64    * For example, if `decimals` equals `2`, a balance of `505` tokens should
65    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
66    *
67    * Tokens usually opt for a value of 18, imitating the relationship between
68    * Ether and Wei.
69    *
70    * NOTE: This information is only used for _display_ purposes: it in
71    * no way affects any of the arithmetic of the contract, including
72    * {IERC20-balanceOf} and {IERC20-transfer}.
73    */
74   function decimals() external view returns (uint8);
75 
76   function name() external view returns (string memory);
77 
78   function symbol() external view returns (string memory);
79 
80 }
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      * - Subtraction cannot overflow.
133      *
134      * _Available since v2.4.0._
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         // Solidity only automatically asserts when dividing by 0
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      *
229      * _Available since v2.4.0._
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 /**
238  * @title Reduces the size of terms before multiplication, to avoid an overflow, and then
239  * restores the proper size after division.
240  * @notice This effectively allows us to overflow values in the numerator and/or denominator
241  * of a fraction, so long as the end result does not overflow as well.
242  * @dev Results may be off by 1 + 0.000001% for 2x1 calls and 2 + 0.00001% for 2x2 calls.
243  * Do not use if your contract expects very small result values to be accurate.
244  */
245 library BigDiv {
246   using SafeMath for uint;
247 
248   /// @notice The max possible value
249   uint private constant MAX_UINT = 2**256 - 1;
250 
251   /// @notice When multiplying 2 terms <= this value the result won't overflow
252   uint private constant MAX_BEFORE_SQUARE = 2**128 - 1;
253 
254   /// @notice The max error target is off by 1 plus up to 0.000001% error
255   /// for bigDiv2x1 and that `* 2` for bigDiv2x2
256   uint private constant MAX_ERROR = 100000000;
257 
258   /// @notice A larger error threshold to use when multiple rounding errors may apply
259   uint private constant MAX_ERROR_BEFORE_DIV = MAX_ERROR * 2;
260 
261   /**
262    * @notice Returns the approx result of `a * b / d` so long as the result is <= MAX_UINT
263    * @param _numA the first numerator term
264    * @param _numB the second numerator term
265    * @param _den the denominator
266    * @return the approx result with up to off by 1 + MAX_ERROR, rounding down if needed
267    */
268   function bigDiv2x1(
269     uint _numA,
270     uint _numB,
271     uint _den
272   ) internal pure returns (uint) {
273     if (_numA == 0 || _numB == 0) {
274       // would div by 0 or underflow if we don't special case 0
275       return 0;
276     }
277 
278     uint value;
279 
280     if (MAX_UINT / _numA >= _numB) {
281       // a*b does not overflow, return exact math
282       value = _numA * _numB;
283       value /= _den;
284       return value;
285     }
286 
287     // Sort numerators
288     uint numMax = _numB;
289     uint numMin = _numA;
290     if (_numA > _numB) {
291       numMax = _numA;
292       numMin = _numB;
293     }
294 
295     value = numMax / _den;
296     if (value > MAX_ERROR) {
297       // _den is small enough to be MAX_ERROR or better w/o a factor
298       value = value.mul(numMin);
299       return value;
300     }
301 
302     // formula = ((a / f) * b) / (d / f)
303     // factor >= a / sqrt(MAX) * (b / sqrt(MAX))
304     uint factor = numMin - 1;
305     factor /= MAX_BEFORE_SQUARE;
306     factor += 1;
307     uint temp = numMax - 1;
308     temp /= MAX_BEFORE_SQUARE;
309     temp += 1;
310     if (MAX_UINT / factor >= temp) {
311       factor *= temp;
312       value = numMax / factor;
313       if (value > MAX_ERROR_BEFORE_DIV) {
314         value = value.mul(numMin);
315         temp = _den - 1;
316         temp /= factor;
317         temp = temp.add(1);
318         value /= temp;
319         return value;
320       }
321     }
322 
323     // formula: (a / (d / f)) * (b / f)
324     // factor: b / sqrt(MAX)
325     factor = numMin - 1;
326     factor /= MAX_BEFORE_SQUARE;
327     factor += 1;
328     value = numMin / factor;
329     temp = _den - 1;
330     temp /= factor;
331     temp += 1;
332     temp = numMax / temp;
333     value = value.mul(temp);
334     return value;
335   }
336 
337   /**
338    * @notice Returns the approx result of `a * b / d` so long as the result is <= MAX_UINT
339    * @param _numA the first numerator term
340    * @param _numB the second numerator term
341    * @param _den the denominator
342    * @return the approx result with up to off by 1 + MAX_ERROR, rounding down if needed
343    * @dev roundUp is implemented by first rounding down and then adding the max error to the result
344    */
345   function bigDiv2x1RoundUp(
346     uint _numA,
347     uint _numB,
348     uint _den
349   ) internal pure returns (uint) {
350     // first get the rounded down result
351     uint value = bigDiv2x1(_numA, _numB, _den);
352 
353     if (value == 0) {
354       // when the value rounds down to 0, assume up to an off by 1 error
355       return 1;
356     }
357 
358     // round down has a max error of MAX_ERROR, add that to the result
359     // for a round up error of <= MAX_ERROR
360     uint temp = value - 1;
361     temp /= MAX_ERROR;
362     temp += 1;
363     if (MAX_UINT - value < temp) {
364       // value + error would overflow, return MAX
365       return MAX_UINT;
366     }
367 
368     value += temp;
369 
370     return value;
371   }
372 
373   /**
374    * @notice Returns the approx result of `a * b / (c * d)` so long as the result is <= MAX_UINT
375    * @param _numA the first numerator term
376    * @param _numB the second numerator term
377    * @param _denA the first denominator term
378    * @param _denB the second denominator term
379    * @return the approx result with up to off by 2 + MAX_ERROR*10 error, rounding down if needed
380    * @dev this uses bigDiv2x1 and adds additional rounding error so the max error of this
381    * formula is larger
382    */
383   function bigDiv2x2(
384     uint _numA,
385     uint _numB,
386     uint _denA,
387     uint _denB
388   ) internal pure returns (uint) {
389     if (MAX_UINT / _denA >= _denB) {
390       // denA*denB does not overflow, use bigDiv2x1 instead
391       return bigDiv2x1(_numA, _numB, _denA * _denB);
392     }
393 
394     if (_numA == 0 || _numB == 0) {
395       // would div by 0 or underflow if we don't special case 0
396       return 0;
397     }
398 
399     // Sort denominators
400     uint denMax = _denB;
401     uint denMin = _denA;
402     if (_denA > _denB) {
403       denMax = _denA;
404       denMin = _denB;
405     }
406 
407     uint value;
408 
409     if (MAX_UINT / _numA >= _numB) {
410       // a*b does not overflow, use `a / d / c`
411       value = _numA * _numB;
412       value /= denMin;
413       value /= denMax;
414       return value;
415     }
416 
417     // `ab / cd` where both `ab` and `cd` would overflow
418 
419     // Sort numerators
420     uint numMax = _numB;
421     uint numMin = _numA;
422     if (_numA > _numB) {
423       numMax = _numA;
424       numMin = _numB;
425     }
426 
427     // formula = (a/d) * b / c
428     uint temp = numMax / denMin;
429     if (temp > MAX_ERROR_BEFORE_DIV) {
430       return bigDiv2x1(temp, numMin, denMax);
431     }
432 
433     // formula: ((a/f) * b) / d then either * f / c or / c * f
434     // factor >= a / sqrt(MAX) * (b / sqrt(MAX))
435     uint factor = numMin - 1;
436     factor /= MAX_BEFORE_SQUARE;
437     factor += 1;
438     temp = numMax - 1;
439     temp /= MAX_BEFORE_SQUARE;
440     temp += 1;
441     if (MAX_UINT / factor >= temp) {
442       factor *= temp;
443 
444       value = numMax / factor;
445       if (value > MAX_ERROR_BEFORE_DIV) {
446         value = value.mul(numMin);
447         value /= denMin;
448         if (value > 0 && MAX_UINT / value >= factor) {
449           value *= factor;
450           value /= denMax;
451           return value;
452         }
453       }
454     }
455 
456     // formula: (a/f) * b / ((c*d)/f)
457     // factor >= c / sqrt(MAX) * (d / sqrt(MAX))
458     factor = denMin;
459     factor /= MAX_BEFORE_SQUARE;
460     temp = denMax;
461     // + 1 here prevents overflow of factor*temp
462     temp /= MAX_BEFORE_SQUARE + 1;
463     factor *= temp;
464     return bigDiv2x1(numMax / factor, numMin, MAX_UINT);
465   }
466 }
467 
468 /**
469  * @title Calculates the square root of a given value.
470  * @dev Results may be off by 1.
471  */
472 library Sqrt {
473   /// @notice The max possible value
474   uint private constant MAX_UINT = 2**256 - 1;
475 
476   // Source: https://github.com/ethereum/dapp-bin/pull/50
477   function sqrt(uint x) internal pure returns (uint y) {
478     if (x == 0) {
479       return 0;
480     } else if (x <= 3) {
481       return 1;
482     } else if (x == MAX_UINT) {
483       // Without this we fail on x + 1 below
484       return 2**128 - 1;
485     }
486 
487     uint z = (x + 1) / 2;
488     y = x;
489     while (z < y) {
490       y = z;
491       z = (x / z + z) / 2;
492     }
493   }
494 }
495 
496 /**
497  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
498  * the optional functions; to access them see {ERC20Detailed}.
499  */
500 interface IERC20 {
501     /**
502      * @dev Returns the amount of tokens in existence.
503      */
504     function totalSupply() external view returns (uint256);
505 
506     /**
507      * @dev Returns the amount of tokens owned by `account`.
508      */
509     function balanceOf(address account) external view returns (uint256);
510 
511     /**
512      * @dev Moves `amount` tokens from the caller's account to `recipient`.
513      *
514      * Returns a boolean value indicating whether the operation succeeded.
515      *
516      * Emits a {Transfer} event.
517      */
518     function transfer(address recipient, uint256 amount) external returns (bool);
519 
520     /**
521      * @dev Returns the remaining number of tokens that `spender` will be
522      * allowed to spend on behalf of `owner` through {transferFrom}. This is
523      * zero by default.
524      *
525      * This value changes when {approve} or {transferFrom} are called.
526      */
527     function allowance(address owner, address spender) external view returns (uint256);
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
531      *
532      * Returns a boolean value indicating whether the operation succeeded.
533      *
534      * IMPORTANT: Beware that changing an allowance with this method brings the risk
535      * that someone may use both the old and the new allowance by unfortunate
536      * transaction ordering. One possible solution to mitigate this race
537      * condition is to first reduce the spender's allowance to 0 and set the
538      * desired value afterwards:
539      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
540      *
541      * Emits an {Approval} event.
542      */
543     function approve(address spender, uint256 amount) external returns (bool);
544 
545     /**
546      * @dev Moves `amount` tokens from `sender` to `recipient` using the
547      * allowance mechanism. `amount` is then deducted from the caller's
548      * allowance.
549      *
550      * Returns a boolean value indicating whether the operation succeeded.
551      *
552      * Emits a {Transfer} event.
553      */
554     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
555 
556     /**
557      * @dev Emitted when `value` tokens are moved from one account (`from`) to
558      * another (`to`).
559      *
560      * Note that `value` may be zero.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     /**
565      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
566      * a call to {approve}. `value` is the new allowance.
567      */
568     event Approval(address indexed owner, address indexed spender, uint256 value);
569 }
570 
571 /**
572  * @dev Collection of functions related to the address type
573  */
574 library Address {
575     /**
576      * @dev Returns true if `account` is a contract.
577      *
578      * [IMPORTANT]
579      * ====
580      * It is unsafe to assume that an address for which this function returns
581      * false is an externally-owned account (EOA) and not a contract.
582      *
583      * Among others, `isContract` will return false for the following 
584      * types of addresses:
585      *
586      *  - an externally-owned account
587      *  - a contract in construction
588      *  - an address where a contract will be created
589      *  - an address where a contract lived, but was destroyed
590      * ====
591      */
592     function isContract(address account) internal view returns (bool) {
593         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
594         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
595         // for accounts without code, i.e. `keccak256('')`
596         bytes32 codehash;
597         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
598         // solhint-disable-next-line no-inline-assembly
599         assembly { codehash := extcodehash(account) }
600         return (codehash != accountHash && codehash != 0x0);
601     }
602 
603     /**
604      * @dev Converts an `address` into `address payable`. Note that this is
605      * simply a type cast: the actual underlying value is not changed.
606      *
607      * _Available since v2.4.0._
608      */
609     function toPayable(address account) internal pure returns (address payable) {
610         return address(uint160(account));
611     }
612 
613     /**
614      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
615      * `recipient`, forwarding all available gas and reverting on errors.
616      *
617      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
618      * of certain opcodes, possibly making contracts go over the 2300 gas limit
619      * imposed by `transfer`, making them unable to receive funds via
620      * `transfer`. {sendValue} removes this limitation.
621      *
622      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
623      *
624      * IMPORTANT: because control is transferred to `recipient`, care must be
625      * taken to not create reentrancy vulnerabilities. Consider using
626      * {ReentrancyGuard} or the
627      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
628      *
629      * _Available since v2.4.0._
630      */
631     function sendValue(address payable recipient, uint256 amount) internal {
632         require(address(this).balance >= amount, "Address: insufficient balance");
633 
634         // solhint-disable-next-line avoid-call-value
635         (bool success, ) = recipient.call.value(amount)("");
636         require(success, "Address: unable to send value, recipient may have reverted");
637     }
638 }
639 
640 /**
641  * @title SafeERC20
642  * @dev Wrappers around ERC20 operations that throw on failure (when the token
643  * contract returns false). Tokens that return no value (and instead revert or
644  * throw on failure) are also supported, non-reverting calls are assumed to be
645  * successful.
646  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
647  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
648  */
649 library SafeERC20 {
650     using SafeMath for uint256;
651     using Address for address;
652 
653     function safeTransfer(IERC20 token, address to, uint256 value) internal {
654         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
655     }
656 
657     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
658         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
659     }
660 
661     function safeApprove(IERC20 token, address spender, uint256 value) internal {
662         // safeApprove should only be called when setting an initial allowance,
663         // or when resetting it to zero. To increase and decrease it, use
664         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
665         // solhint-disable-next-line max-line-length
666         require((value == 0) || (token.allowance(address(this), spender) == 0),
667             "SafeERC20: approve from non-zero to non-zero allowance"
668         );
669         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
670     }
671 
672     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
673         uint256 newAllowance = token.allowance(address(this), spender).add(value);
674         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
675     }
676 
677     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
678         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
679         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
680     }
681 
682     /**
683      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
684      * on the return value: the return value is optional (but if data is returned, it must not be false).
685      * @param token The token targeted by the call.
686      * @param data The call data (encoded using abi.encode or one of its variants).
687      */
688     function callOptionalReturn(IERC20 token, bytes memory data) private {
689         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
690         // we're implementing it ourselves.
691 
692         // A Solidity high level call has three parts:
693         //  1. The target address is checked to verify it contains contract code
694         //  2. The call itself is made, and success asserted
695         //  3. The return value is decoded, which in turn checks the size of the returned data.
696         // solhint-disable-next-line max-line-length
697         require(address(token).isContract(), "SafeERC20: call to non-contract");
698 
699         // solhint-disable-next-line avoid-low-level-calls
700         (bool success, bytes memory returndata) = address(token).call(data);
701         require(success, "SafeERC20: low-level call failed");
702 
703         if (returndata.length > 0) { // Return data is optional
704             // solhint-disable-next-line max-line-length
705             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
706         }
707     }
708 }
709 
710 /**
711  * @title Initializable
712  *
713  * @dev Helper contract to support initializer functions. To use it, replace
714  * the constructor with a function that has the `initializer` modifier.
715  * WARNING: Unlike constructors, initializer functions must be manually
716  * invoked. This applies both to deploying an Initializable contract, as well
717  * as extending an Initializable contract via inheritance.
718  * WARNING: When used with inheritance, manual care must be taken to not invoke
719  * a parent initializer twice, or ensure that all initializers are idempotent,
720  * because this is not dealt with automatically as with constructors.
721  */
722 contract Initializable {
723 
724   /**
725    * @dev Indicates that the contract has been initialized.
726    */
727   bool private initialized;
728 
729   /**
730    * @dev Indicates that the contract is in the process of being initialized.
731    */
732   bool private initializing;
733 
734   /**
735    * @dev Modifier to use in the initializer function of a contract.
736    */
737   modifier initializer() {
738     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
739 
740     bool isTopLevelCall = !initializing;
741     if (isTopLevelCall) {
742       initializing = true;
743       initialized = true;
744     }
745 
746     _;
747 
748     if (isTopLevelCall) {
749       initializing = false;
750     }
751   }
752 
753   /// @dev Returns true if and only if the function is running in the constructor
754   function isConstructor() private view returns (bool) {
755     // extcodesize checks the size of the code stored in an address, and
756     // address returns the current address. Since the code is still not
757     // deployed when running a constructor, any checks on its code size will
758     // yield zero, making it an effective way to detect if a contract is
759     // under construction or not.
760     address self = address(this);
761     uint256 cs;
762     assembly { cs := extcodesize(self) }
763     return cs == 0;
764   }
765 
766   // Reserved storage space to allow for layout changes in the future.
767   uint256[50] private ______gap;
768 }
769 
770 /*
771  * @dev Provides information about the current execution context, including the
772  * sender of the transaction and its data. While these are generally available
773  * via msg.sender and msg.data, they should not be accessed in such a direct
774  * manner, since when dealing with GSN meta-transactions the account sending and
775  * paying for execution may not be the actual sender (as far as an application
776  * is concerned).
777  *
778  * This contract is only required for intermediate, library-like contracts.
779  */
780 contract Context is Initializable {
781     // Empty internal constructor, to prevent people from mistakenly deploying
782     // an instance of this contract, which should be used via inheritance.
783     constructor () internal { }
784     // solhint-disable-previous-line no-empty-blocks
785 
786     function _msgSender() internal view returns (address payable) {
787         return msg.sender;
788     }
789 
790     function _msgData() internal view returns (bytes memory) {
791         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
792         return msg.data;
793     }
794 }
795 
796 /**
797  * @dev Implementation of the {IERC20} interface.
798  *
799  * This implementation is agnostic to the way tokens are created. This means
800  * that a supply mechanism has to be added in a derived contract using {_mint}.
801  * For a generic mechanism see {ERC20Mintable}.
802  *
803  * TIP: For a detailed writeup see our guide
804  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
805  * to implement supply mechanisms].
806  *
807  * We have followed general OpenZeppelin guidelines: functions revert instead
808  * of returning `false` on failure. This behavior is nonetheless conventional
809  * and does not conflict with the expectations of ERC20 applications.
810  *
811  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
812  * This allows applications to reconstruct the allowance for all accounts just
813  * by listening to said events. Other implementations of the EIP may not emit
814  * these events, as it isn't required by the specification.
815  *
816  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
817  * functions have been added to mitigate the well-known issues around setting
818  * allowances. See {IERC20-approve}.
819  */
820 contract ERC20 is Initializable, Context, IERC20 {
821     using SafeMath for uint256;
822 
823     mapping (address => uint256) private _balances;
824 
825     mapping (address => mapping (address => uint256)) private _allowances;
826 
827     uint256 private _totalSupply;
828 
829     /**
830      * @dev See {IERC20-totalSupply}.
831      */
832     function totalSupply() public view returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev See {IERC20-balanceOf}.
838      */
839     function balanceOf(address account) public view returns (uint256) {
840         return _balances[account];
841     }
842 
843     /**
844      * @dev See {IERC20-transfer}.
845      *
846      * Requirements:
847      *
848      * - `recipient` cannot be the zero address.
849      * - the caller must have a balance of at least `amount`.
850      */
851     function transfer(address recipient, uint256 amount) public returns (bool) {
852         _transfer(_msgSender(), recipient, amount);
853         return true;
854     }
855 
856     /**
857      * @dev See {IERC20-allowance}.
858      */
859     function allowance(address owner, address spender) public view returns (uint256) {
860         return _allowances[owner][spender];
861     }
862 
863     /**
864      * @dev See {IERC20-approve}.
865      *
866      * Requirements:
867      *
868      * - `spender` cannot be the zero address.
869      */
870     function approve(address spender, uint256 amount) public returns (bool) {
871         _approve(_msgSender(), spender, amount);
872         return true;
873     }
874 
875     /**
876      * @dev See {IERC20-transferFrom}.
877      *
878      * Emits an {Approval} event indicating the updated allowance. This is not
879      * required by the EIP. See the note at the beginning of {ERC20};
880      *
881      * Requirements:
882      * - `sender` and `recipient` cannot be the zero address.
883      * - `sender` must have a balance of at least `amount`.
884      * - the caller must have allowance for `sender`'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
888         _transfer(sender, recipient, amount);
889         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
890         return true;
891     }
892 
893     /**
894      * @dev Atomically increases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
907         return true;
908     }
909 
910     /**
911      * @dev Atomically decreases the allowance granted to `spender` by the caller.
912      *
913      * This is an alternative to {approve} that can be used as a mitigation for
914      * problems described in {IERC20-approve}.
915      *
916      * Emits an {Approval} event indicating the updated allowance.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      * - `spender` must have allowance for the caller of at least
922      * `subtractedValue`.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
925         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
926         return true;
927     }
928 
929     /**
930      * @dev Moves tokens `amount` from `sender` to `recipient`.
931      *
932      * This is internal function is equivalent to {transfer}, and can be used to
933      * e.g. implement automatic token fees, slashing mechanisms, etc.
934      *
935      * Emits a {Transfer} event.
936      *
937      * Requirements:
938      *
939      * - `sender` cannot be the zero address.
940      * - `recipient` cannot be the zero address.
941      * - `sender` must have a balance of at least `amount`.
942      */
943     function _transfer(address sender, address recipient, uint256 amount) internal {
944         require(sender != address(0), "ERC20: transfer from the zero address");
945         require(recipient != address(0), "ERC20: transfer to the zero address");
946 
947         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
948         _balances[recipient] = _balances[recipient].add(amount);
949         emit Transfer(sender, recipient, amount);
950     }
951 
952     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
953      * the total supply.
954      *
955      * Emits a {Transfer} event with `from` set to the zero address.
956      *
957      * Requirements
958      *
959      * - `to` cannot be the zero address.
960      */
961     function _mint(address account, uint256 amount) internal {
962         require(account != address(0), "ERC20: mint to the zero address");
963 
964         _totalSupply = _totalSupply.add(amount);
965         _balances[account] = _balances[account].add(amount);
966         emit Transfer(address(0), account, amount);
967     }
968 
969     /**
970      * @dev Destroys `amount` tokens from `account`, reducing the
971      * total supply.
972      *
973      * Emits a {Transfer} event with `to` set to the zero address.
974      *
975      * Requirements
976      *
977      * - `account` cannot be the zero address.
978      * - `account` must have at least `amount` tokens.
979      */
980     function _burn(address account, uint256 amount) internal {
981         require(account != address(0), "ERC20: burn from the zero address");
982 
983         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
984         _totalSupply = _totalSupply.sub(amount);
985         emit Transfer(account, address(0), amount);
986     }
987 
988     /**
989      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
990      *
991      * This is internal function is equivalent to `approve`, and can be used to
992      * e.g. set automatic allowances for certain subsystems, etc.
993      *
994      * Emits an {Approval} event.
995      *
996      * Requirements:
997      *
998      * - `owner` cannot be the zero address.
999      * - `spender` cannot be the zero address.
1000      */
1001     function _approve(address owner, address spender, uint256 amount) internal {
1002         require(owner != address(0), "ERC20: approve from the zero address");
1003         require(spender != address(0), "ERC20: approve to the zero address");
1004 
1005         _allowances[owner][spender] = amount;
1006         emit Approval(owner, spender, amount);
1007     }
1008 
1009     /**
1010      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1011      * from the caller's allowance.
1012      *
1013      * See {_burn} and {_approve}.
1014      */
1015     function _burnFrom(address account, uint256 amount) internal {
1016         _burn(account, amount);
1017         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1018     }
1019 
1020     uint256[50] private ______gap;
1021 }
1022 
1023 /**
1024  * @title Roles
1025  * @dev Library for managing addresses assigned to a Role.
1026  */
1027 library Roles {
1028     struct Role {
1029         mapping (address => bool) bearer;
1030     }
1031 
1032     /**
1033      * @dev Give an account access to this role.
1034      */
1035     function add(Role storage role, address account) internal {
1036         require(!has(role, account), "Roles: account already has role");
1037         role.bearer[account] = true;
1038     }
1039 
1040     /**
1041      * @dev Remove an account's access to this role.
1042      */
1043     function remove(Role storage role, address account) internal {
1044         require(has(role, account), "Roles: account does not have role");
1045         role.bearer[account] = false;
1046     }
1047 
1048     /**
1049      * @dev Check if an account has this role.
1050      * @return bool
1051      */
1052     function has(Role storage role, address account) internal view returns (bool) {
1053         require(account != address(0), "Roles: account is the zero address");
1054         return role.bearer[account];
1055     }
1056 }
1057 
1058 contract MinterRole is Initializable, Context {
1059     using Roles for Roles.Role;
1060 
1061     event MinterAdded(address indexed account);
1062     event MinterRemoved(address indexed account);
1063 
1064     Roles.Role private _minters;
1065 
1066     function initialize(address sender) public initializer {
1067         if (!isMinter(sender)) {
1068             _addMinter(sender);
1069         }
1070     }
1071 
1072     modifier onlyMinter() {
1073         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1074         _;
1075     }
1076 
1077     function isMinter(address account) public view returns (bool) {
1078         return _minters.has(account);
1079     }
1080 
1081     function addMinter(address account) public onlyMinter {
1082         _addMinter(account);
1083     }
1084 
1085     function renounceMinter() public {
1086         _removeMinter(_msgSender());
1087     }
1088 
1089     function _addMinter(address account) internal {
1090         _minters.add(account);
1091         emit MinterAdded(account);
1092     }
1093 
1094     function _removeMinter(address account) internal {
1095         _minters.remove(account);
1096         emit MinterRemoved(account);
1097     }
1098 
1099     uint256[50] private ______gap;
1100 }
1101 
1102 /**
1103  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1104  * which have permission to mint (create) new tokens as they see fit.
1105  *
1106  * At construction, the deployer of the contract is the only minter.
1107  */
1108 contract ERC20Mintable is Initializable, ERC20, MinterRole {
1109     function initialize(address sender) public initializer {
1110         MinterRole.initialize(sender);
1111     }
1112 
1113     /**
1114      * @dev See {ERC20-_mint}.
1115      *
1116      * Requirements:
1117      *
1118      * - the caller must have the {MinterRole}.
1119      */
1120     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1121         _mint(account, amount);
1122         return true;
1123     }
1124 
1125     uint256[50] private ______gap;
1126 }
1127 
1128 /**
1129  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
1130  */
1131 contract ERC20Capped is Initializable, ERC20Mintable {
1132     uint256 private _cap;
1133 
1134     /**
1135      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1136      * set once during construction.
1137      */
1138     function initialize(uint256 cap, address sender) public initializer {
1139         ERC20Mintable.initialize(sender);
1140 
1141         require(cap > 0, "ERC20Capped: cap is 0");
1142         _cap = cap;
1143     }
1144 
1145     /**
1146      * @dev Returns the cap on the token's total supply.
1147      */
1148     function cap() public view returns (uint256) {
1149         return _cap;
1150     }
1151 
1152     /**
1153      * @dev See {ERC20Mintable-mint}.
1154      *
1155      * Requirements:
1156      *
1157      * - `value` must not cause the total supply to go over the cap.
1158      */
1159     function _mint(address account, uint256 value) internal {
1160         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1161         super._mint(account, value);
1162     }
1163 
1164     uint256[50] private ______gap;
1165 }
1166 
1167 contract PauserRole is Initializable, Context {
1168     using Roles for Roles.Role;
1169 
1170     event PauserAdded(address indexed account);
1171     event PauserRemoved(address indexed account);
1172 
1173     Roles.Role private _pausers;
1174 
1175     function initialize(address sender) public initializer {
1176         if (!isPauser(sender)) {
1177             _addPauser(sender);
1178         }
1179     }
1180 
1181     modifier onlyPauser() {
1182         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1183         _;
1184     }
1185 
1186     function isPauser(address account) public view returns (bool) {
1187         return _pausers.has(account);
1188     }
1189 
1190     function addPauser(address account) public onlyPauser {
1191         _addPauser(account);
1192     }
1193 
1194     function renouncePauser() public {
1195         _removePauser(_msgSender());
1196     }
1197 
1198     function _addPauser(address account) internal {
1199         _pausers.add(account);
1200         emit PauserAdded(account);
1201     }
1202 
1203     function _removePauser(address account) internal {
1204         _pausers.remove(account);
1205         emit PauserRemoved(account);
1206     }
1207 
1208     uint256[50] private ______gap;
1209 }
1210 
1211 /**
1212  * @dev Contract module which allows children to implement an emergency stop
1213  * mechanism that can be triggered by an authorized account.
1214  *
1215  * This module is used through inheritance. It will make available the
1216  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1217  * the functions of your contract. Note that they will not be pausable by
1218  * simply including this module, only once the modifiers are put in place.
1219  */
1220 contract Pausable is Initializable, Context, PauserRole {
1221     /**
1222      * @dev Emitted when the pause is triggered by a pauser (`account`).
1223      */
1224     event Paused(address account);
1225 
1226     /**
1227      * @dev Emitted when the pause is lifted by a pauser (`account`).
1228      */
1229     event Unpaused(address account);
1230 
1231     bool private _paused;
1232 
1233     /**
1234      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1235      * to the deployer.
1236      */
1237     function initialize(address sender) public initializer {
1238         PauserRole.initialize(sender);
1239 
1240         _paused = false;
1241     }
1242 
1243     /**
1244      * @dev Returns true if the contract is paused, and false otherwise.
1245      */
1246     function paused() public view returns (bool) {
1247         return _paused;
1248     }
1249 
1250     /**
1251      * @dev Modifier to make a function callable only when the contract is not paused.
1252      */
1253     modifier whenNotPaused() {
1254         require(!_paused, "Pausable: paused");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Modifier to make a function callable only when the contract is paused.
1260      */
1261     modifier whenPaused() {
1262         require(_paused, "Pausable: not paused");
1263         _;
1264     }
1265 
1266     /**
1267      * @dev Called by a pauser to pause, triggers stopped state.
1268      */
1269     function pause() public onlyPauser whenNotPaused {
1270         _paused = true;
1271         emit Paused(_msgSender());
1272     }
1273 
1274     /**
1275      * @dev Called by a pauser to unpause, returns to normal state.
1276      */
1277     function unpause() public onlyPauser whenPaused {
1278         _paused = false;
1279         emit Unpaused(_msgSender());
1280     }
1281 
1282     uint256[50] private ______gap;
1283 }
1284 
1285 /**
1286  * @title Pausable token
1287  * @dev ERC20 with pausable transfers and allowances.
1288  *
1289  * Useful if you want to stop trades until the end of a crowdsale, or have
1290  * an emergency switch for freezing all token transfers in the event of a large
1291  * bug.
1292  */
1293 contract ERC20Pausable is Initializable, ERC20, Pausable {
1294     function initialize(address sender) public initializer {
1295         Pausable.initialize(sender);
1296     }
1297 
1298     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1299         return super.transfer(to, value);
1300     }
1301 
1302     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1303         return super.transferFrom(from, to, value);
1304     }
1305 
1306     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1307         return super.approve(spender, value);
1308     }
1309 
1310     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
1311         return super.increaseAllowance(spender, addedValue);
1312     }
1313 
1314     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
1315         return super.decreaseAllowance(spender, subtractedValue);
1316     }
1317 
1318     uint256[50] private ______gap;
1319 }
1320 
1321 /**
1322  * @title Continuous Offering abstract contract
1323  * @notice A shared base for various offerings from Fairmint.
1324  */
1325 contract ContinuousOffering is ERC20Pausable, ERC20Capped, IERC20Detailed
1326 {
1327   using SafeMath for uint;
1328   using Sqrt for uint;
1329   using SafeERC20 for IERC20;
1330 
1331   /**
1332    * Events
1333    */
1334 
1335   event Buy(
1336     address indexed _from,
1337     address indexed _to,
1338     uint _currencyValue,
1339     uint _fairValue
1340   );
1341   event Sell(
1342     address indexed _from,
1343     address indexed _to,
1344     uint _currencyValue,
1345     uint _fairValue
1346   );
1347   event Burn(
1348     address indexed _from,
1349     uint _fairValue
1350   );
1351   event StateChange(
1352     uint _previousState,
1353     uint _newState
1354   );
1355 
1356   /**
1357    * Constants
1358    */
1359 
1360   /// @notice The default state
1361   uint internal constant STATE_INIT = 0;
1362 
1363   /// @notice The state after initGoal has been reached
1364   uint internal constant STATE_RUN = 1;
1365 
1366   /// @notice The state after closed by the `beneficiary` account from STATE_RUN
1367   uint internal constant STATE_CLOSE = 2;
1368 
1369   /// @notice The state after closed by the `beneficiary` account from STATE_INIT
1370   uint internal constant STATE_CANCEL = 3;
1371 
1372   /// @notice When multiplying 2 terms, the max value is 2^128-1
1373   uint internal constant MAX_BEFORE_SQUARE = 2**128 - 1;
1374 
1375   /// @notice The denominator component for values specified in basis points.
1376   uint internal constant BASIS_POINTS_DEN = 10000;
1377 
1378   /// @notice The max `totalSupply() + burnedSupply`
1379   /// @dev This limit ensures that the DAT's formulas do not overflow (<MAX_BEFORE_SQUARE/2)
1380   uint internal constant MAX_SUPPLY = 10 ** 38;
1381 
1382   /**
1383    * Data specific to our token business logic
1384    */
1385 
1386   /// @notice The contract for transfer authorizations, if any.
1387   IWhitelist public whitelist;
1388 
1389   /// @notice The total number of burned FAIR tokens, excluding tokens burned from a `Sell` action in the DAT.
1390   uint public burnedSupply;
1391 
1392   /**
1393    * Data for DAT business logic
1394    */
1395 
1396   /// @dev unused slot which remains to ensure compatible upgrades
1397   bool private __autoBurn;
1398 
1399   /// @notice The address of the beneficiary organization which receives the investments.
1400   /// Points to the wallet of the organization.
1401   address payable public beneficiary;
1402 
1403   /// @notice The buy slope of the bonding curve.
1404   /// Does not affect the financial model, only the granularity of FAIR.
1405   /// @dev This is the numerator component of the fractional value.
1406   uint public buySlopeNum;
1407 
1408   /// @notice The buy slope of the bonding curve.
1409   /// Does not affect the financial model, only the granularity of FAIR.
1410   /// @dev This is the denominator component of the fractional value.
1411   uint public buySlopeDen;
1412 
1413   /// @notice The address from which the updatable variables can be updated
1414   address public control;
1415 
1416   /// @notice The address of the token used as reserve in the bonding curve
1417   /// (e.g. the DAI contract). Use ETH if 0.
1418   IERC20 public currency;
1419 
1420   /// @notice The address where fees are sent.
1421   address payable public feeCollector;
1422 
1423   /// @notice The percent fee collected each time new FAIR are issued expressed in basis points.
1424   uint public feeBasisPoints;
1425 
1426   /// @notice The initial fundraising goal (expressed in FAIR) to start the c-org.
1427   /// `0` means that there is no initial fundraising and the c-org immediately moves to run state.
1428   uint public initGoal;
1429 
1430   /// @notice A map with all investors in init state using address as a key and amount as value.
1431   /// @dev This structure's purpose is to make sure that only investors can withdraw their money if init_goal is not reached.
1432   mapping(address => uint) public initInvestors;
1433 
1434   /// @notice The initial number of FAIR created at initialization for the beneficiary.
1435   /// Technically however, this variable is not a constant as we must always have
1436   ///`init_reserve>=total_supply+burnt_supply` which means that `init_reserve` will be automatically
1437   /// decreased to equal `total_supply+burnt_supply` in case `init_reserve>total_supply+burnt_supply`
1438   /// after an investor sells his FAIRs.
1439   /// @dev Organizations may move these tokens into vesting contract(s)
1440   uint public initReserve;
1441 
1442   /// @notice The investment reserve of the c-org. Defines the percentage of the value invested that is
1443   /// automatically funneled and held into the buyback_reserve expressed in basis points.
1444   /// Internal since this is n/a to all derivative contracts.
1445   uint internal __investmentReserveBasisPoints;
1446 
1447   /// @dev unused slot which remains to ensure compatible upgrades
1448   uint private __openUntilAtLeast;
1449 
1450   /// @notice The minimum amount of `currency` investment accepted.
1451   uint public minInvestment;
1452 
1453   /// @dev The revenue commitment of the organization. Defines the percentage of the value paid through the contract
1454   /// that is automatically funneled and held into the buyback_reserve expressed in basis points.
1455   /// Internal since this is n/a to all derivative contracts.
1456   uint internal __revenueCommitmentBasisPoints;
1457 
1458   /// @notice The current state of the contract.
1459   /// @dev See the constants above for possible state values.
1460   uint public state;
1461 
1462   /// @dev If this value changes we need to reconstruct the DOMAIN_SEPARATOR
1463   string public constant version = "3";
1464   // --- EIP712 niceties ---
1465   // Original source: https://etherscan.io/address/0x6b175474e89094c44da98b954eedeac495271d0f#code
1466   mapping (address => uint) public nonces;
1467   bytes32 public DOMAIN_SEPARATOR;
1468   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1469   bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1470 
1471   // The success fee (expressed in currency) that will be earned by setupFeeRecipient as soon as initGoal
1472   // is reached. We must have setup_fee <= buy_slope*init_goal^(2)/2
1473   uint public setupFee;
1474 
1475   // The recipient of the setup_fee once init_goal is reached
1476   address payable public setupFeeRecipient;
1477 
1478   /// @notice The minimum time before which the c-org contract cannot be closed once the contract has
1479   /// reached the `run` state.
1480   /// @dev When updated, the new value of `minimum_duration` cannot be earlier than the previous value.
1481   uint public minDuration;
1482 
1483   /// @dev Initialized at `0` and updated when the contract switches from `init` state to `run` state
1484   /// or when the initial trial period ends.
1485   uint public __startedOn;
1486 
1487   /// @notice The max possible value
1488   uint internal constant MAX_UINT = 2**256 - 1;
1489 
1490   // keccak256("PermitBuy(address from,address to,uint256 currencyValue,uint256 minTokensBought,uint256 nonce,uint256 deadline)");
1491   bytes32 public constant PERMIT_BUY_TYPEHASH = 0xaf42a244b3020d6a2253d9f291b4d3e82240da42b22129a8113a58aa7a3ddb6a;
1492 
1493   // keccak256("PermitSell(address from,address to,uint256 quantityToSell,uint256 minCurrencyReturned,uint256 nonce,uint256 deadline)");
1494   bytes32 public constant PERMIT_SELL_TYPEHASH = 0x5dfdc7fb4c68a4c249de5e08597626b84fbbe7bfef4ed3500f58003e722cc548;
1495 
1496   modifier authorizeTransfer(
1497     address _from,
1498     address _to,
1499     uint _value,
1500     bool _isSell
1501   )
1502   {
1503     if(address(whitelist) != address(0))
1504     {
1505       //automatically activate wallet _from
1506       //does not activate if,
1507       //1. _from is zero address,
1508       //2. it is burn
1509       if(!whitelist.walletActivated(_from) && _from != address(0) && !(_to == address(0) && !_isSell)){
1510         whitelist.activateWallet(_from);
1511       }
1512       //automatically activate wallet _to
1513       //does not activate if,
1514       //1. _to is zero address,
1515       if(!whitelist.walletActivated(_to) && _to != address(0)){
1516         whitelist.activateWallet(_to);
1517       }
1518       // This is not set for the minting of initialReserve
1519       whitelist.authorizeTransfer(_from, _to, _value, _isSell);
1520     }
1521     _;
1522     if(address(whitelist) != address(0)){
1523       //automatically deactivates _from if _from's balance is zero
1524       if(balanceOf(_from) == 0 && _from != address(0) && !(_to==address(0) && !_isSell)){
1525         //deactivate wallets without balance
1526         whitelist.deactivateWallet(_from);
1527       }
1528     }
1529   }
1530 
1531   /**
1532    * Buyback reserve
1533    */
1534 
1535   /// @notice The total amount of currency value currently locked in the contract and available to sellers.
1536   function buybackReserve() public view returns (uint)
1537   {
1538     uint reserve = address(this).balance;
1539     if(address(currency) != address(0))
1540     {
1541       reserve = currency.balanceOf(address(this));
1542     }
1543 
1544     if(reserve > MAX_BEFORE_SQUARE)
1545     {
1546       /// Math: If the reserve becomes excessive, cap the value to prevent overflowing in other formulas
1547       return MAX_BEFORE_SQUARE;
1548     }
1549 
1550     return reserve;
1551   }
1552 
1553   /**
1554    * Functions required by the ERC-20 token standard
1555    */
1556 
1557   /// @dev Moves tokens from one account to another if authorized.
1558   function _transfer(
1559     address _from,
1560     address _to,
1561     uint _amount
1562   ) internal
1563     authorizeTransfer(_from, _to, _amount, false)
1564   {
1565     require(state != STATE_INIT || _from == beneficiary, "ONLY_BENEFICIARY_DURING_INIT");
1566     super._transfer(_from, _to, _amount);
1567   }
1568 
1569   /// @dev Removes tokens from the circulating supply.
1570   function _burn(
1571     address _from,
1572     uint _amount,
1573     bool _isSell
1574   ) internal
1575     authorizeTransfer(_from, address(0), _amount, _isSell)
1576   {
1577     super._burn(_from, _amount);
1578 
1579     if(!_isSell)
1580     {
1581       // This is a burn
1582       require(state == STATE_RUN, "INVALID_STATE");
1583       // SafeMath not required as we cap how high this value may get during mint
1584       burnedSupply += _amount;
1585       emit Burn(_from, _amount);
1586     }
1587   }
1588 
1589   /// @notice Called to mint tokens on `buy`.
1590   function _mint(
1591     address _to,
1592     uint _quantity
1593   ) internal
1594     authorizeTransfer(address(0), _to, _quantity, false)
1595   {
1596     super._mint(_to, _quantity);
1597 
1598     // Math: If this value got too large, the DAT may overflow on sell
1599     require(totalSupply().add(burnedSupply) <= MAX_SUPPLY, "EXCESSIVE_SUPPLY");
1600   }
1601 
1602   /**
1603    * Transaction Helpers
1604    */
1605 
1606   /// @notice Confirms the transfer of `_quantityToInvest` currency to the contract.
1607   function _collectInvestment(
1608     address payable _from,
1609     uint _quantityToInvest,
1610     uint _msgValue,
1611     bool _refundRemainder
1612   ) internal
1613   {
1614     if(address(currency) == address(0))
1615     {
1616       // currency is ETH
1617       if(_refundRemainder)
1618       {
1619         // Math: if _msgValue was not sufficient then revert
1620         uint refund = _msgValue.sub(_quantityToInvest);
1621         if(refund > 0)
1622         {
1623           Address.sendValue(msg.sender, refund);
1624         }
1625       }
1626       else
1627       {
1628         require(_quantityToInvest == _msgValue, "INCORRECT_MSG_VALUE");
1629       }
1630     }
1631     else
1632     {
1633       // currency is ERC20
1634       require(_msgValue == 0, "DO_NOT_SEND_ETH");
1635 
1636       currency.safeTransferFrom(_from, address(this), _quantityToInvest);
1637     }
1638   }
1639 
1640   /// @dev Send `_amount` currency from the contract to the `_to` account.
1641   function _transferCurrency(
1642     address payable _to,
1643     uint _amount
1644   ) internal
1645   {
1646     if(_amount > 0)
1647     {
1648       if(address(currency) == address(0))
1649       {
1650         Address.sendValue(_to, _amount);
1651       }
1652       else
1653       {
1654         currency.safeTransfer(_to, _amount);
1655       }
1656     }
1657   }
1658 
1659   /**
1660    * Config / Control
1661    */
1662 
1663   /// @notice Called once after deploy to set the initial configuration.
1664   /// None of the values provided here may change once initially set.
1665   /// @dev using the init pattern in order to support zos upgrades
1666   function _initialize(
1667     uint _initReserve,
1668     address _currencyAddress,
1669     uint _initGoal,
1670     uint _buySlopeNum,
1671     uint _buySlopeDen,
1672     uint _setupFee,
1673     address payable _setupFeeRecipient
1674   ) internal
1675   {
1676     // The ERC-20 implementation will confirm initialize is only run once
1677     ERC20Capped.initialize((5000000 * (10 ** 18)), msg.sender);
1678     // Also update the pausable setting
1679     _addPauser(msg.sender);
1680 
1681     require(_buySlopeNum > 0, "INVALID_SLOPE_NUM");
1682     require(_buySlopeDen > 0, "INVALID_SLOPE_DEN");
1683     require(_buySlopeNum < MAX_BEFORE_SQUARE, "EXCESSIVE_SLOPE_NUM");
1684     require(_buySlopeDen < MAX_BEFORE_SQUARE, "EXCESSIVE_SLOPE_DEN");
1685     buySlopeNum = _buySlopeNum;
1686     buySlopeDen = _buySlopeDen;
1687 
1688     // Setup Fee
1689     require(_setupFee == 0 || _setupFeeRecipient != address(0), "MISSING_SETUP_FEE_RECIPIENT");
1690     require(_setupFeeRecipient == address(0) || _setupFee != 0, "MISSING_SETUP_FEE");
1691     // setup_fee <= (n/d)*(g^2)/2
1692     uint initGoalInCurrency = _initGoal * _initGoal;
1693     initGoalInCurrency = initGoalInCurrency.mul(_buySlopeNum);
1694     initGoalInCurrency /= 2 * _buySlopeDen;
1695     require(_setupFee <= initGoalInCurrency, "EXCESSIVE_SETUP_FEE");
1696     setupFee = _setupFee;
1697     setupFeeRecipient = _setupFeeRecipient;
1698 
1699     // Set default values (which may be updated using `updateConfig`)
1700     uint decimals = 18;
1701     if(_currencyAddress != address(0))
1702     {
1703       decimals = IERC20Detailed(_currencyAddress).decimals();
1704     }
1705     minInvestment = 100 * (10 ** decimals);
1706     beneficiary = msg.sender;
1707     control = msg.sender;
1708     feeCollector = msg.sender;
1709 
1710     // Save currency
1711     currency = IERC20(_currencyAddress);
1712 
1713     // Mint the initial reserve
1714     if(_initReserve > 0)
1715     {
1716       initReserve = _initReserve;
1717       _mint(beneficiary, initReserve);
1718     }
1719 
1720     initializeDomainSeparator();
1721   }
1722 
1723   /// @notice Used to initialize the domain separator used in meta-transactions
1724   /// @dev This is separate from `initialize` to allow upgraded contracts to update the version
1725   /// There is no harm in calling this multiple times / no permissions required
1726   function initializeDomainSeparator() public
1727   {
1728     uint id;
1729     // solium-disable-next-line
1730     assembly
1731     {
1732       id := chainid()
1733     }
1734     DOMAIN_SEPARATOR = keccak256(
1735       abi.encode(
1736         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1737         keccak256(bytes(name())),
1738         keccak256(bytes(version)),
1739         id,
1740         address(this)
1741       )
1742     );
1743   }
1744 
1745   function _updateConfig(
1746     address _whitelistAddress,
1747     address payable _beneficiary,
1748     address _control,
1749     address payable _feeCollector,
1750     uint _feeBasisPoints,
1751     uint _minInvestment,
1752     uint _minDuration
1753   ) internal
1754   {
1755     // This require(also confirms that initialize has been called.
1756     require(msg.sender == control, "CONTROL_ONLY");
1757 
1758     // address(0) is okay
1759     whitelist = IWhitelist(_whitelistAddress);
1760 
1761     require(_control != address(0), "INVALID_ADDRESS");
1762     control = _control;
1763 
1764     require(_feeCollector != address(0), "INVALID_ADDRESS");
1765     feeCollector = _feeCollector;
1766 
1767     require(_feeBasisPoints <= BASIS_POINTS_DEN, "INVALID_FEE");
1768     feeBasisPoints = _feeBasisPoints;
1769 
1770     require(_minInvestment > 0, "INVALID_MIN_INVESTMENT");
1771     minInvestment = _minInvestment;
1772 
1773     require(_minDuration >= minDuration, "MIN_DURATION_MAY_NOT_BE_REDUCED");
1774     minDuration = _minDuration;
1775 
1776     if(beneficiary != _beneficiary)
1777     {
1778       require(_beneficiary != address(0), "INVALID_ADDRESS");
1779       uint tokens = balanceOf(beneficiary);
1780       initInvestors[_beneficiary] = initInvestors[_beneficiary].add(initInvestors[beneficiary]);
1781       initInvestors[beneficiary] = 0;
1782       if(tokens > 0)
1783       {
1784         _transfer(beneficiary, _beneficiary, tokens);
1785       }
1786       beneficiary = _beneficiary;
1787     }
1788   }
1789 
1790   /**
1791    * Functions for our business logic
1792    */
1793 
1794   /// @notice Burn the amount of tokens from the address msg.sender if authorized.
1795   /// @dev Note that this is not the same as a `sell` via the DAT.
1796   function burn(
1797     uint _amount
1798   ) public
1799   {
1800     _burn(msg.sender, _amount, false);
1801   }
1802 
1803   /// @notice Burn the amount of tokens from the given address if approved.
1804   function burnFrom(
1805     address _from,
1806     uint _amount
1807   ) public
1808   {
1809     _approve(_from, msg.sender, allowance(_from, msg.sender).sub(_amount, "ERC20: burn amount exceeds allowance"));
1810     _burn(_from, _amount, false);
1811   }
1812 
1813   // Buy
1814 
1815   /// @dev Distributes _value currency between the buybackReserve, beneficiary, and feeCollector.
1816   function _distributeInvestment(uint _value) internal;
1817 
1818   /// @notice Calculate how many FAIR tokens you would buy with the given amount of currency if `buy` was called now.
1819   /// @param _currencyValue How much currency to spend in order to buy FAIR.
1820   function estimateBuyValue(
1821     uint _currencyValue
1822   ) public view
1823     returns (uint)
1824   {
1825     if(_currencyValue < minInvestment)
1826     {
1827       return 0;
1828     }
1829 
1830     /// Calculate the tokenValue for this investment
1831     uint tokenValue;
1832     if(state == STATE_INIT)
1833     {
1834       uint currencyValue = _currencyValue;
1835       uint _totalSupply = totalSupply();
1836       // (buy_slope*init_goal)*(init_goal+init_reserve-total_supply)
1837       // n/d: buy_slope (MAX_BEFORE_SQUARE / MAX_BEFORE_SQUARE)
1838       // g: init_goal (MAX_BEFORE_SQUARE)
1839       // t: total_supply (MAX_BEFORE_SQUARE)
1840       // r: init_reserve (MAX_BEFORE_SQUARE)
1841       // source: ((n/d)*g)*(g+r-t)
1842       // impl: (g n (g + r - t))/(d)
1843       uint max = BigDiv.bigDiv2x1(
1844         initGoal * buySlopeNum,
1845         initGoal + initReserve - _totalSupply,
1846         buySlopeDen
1847       );
1848       if(currencyValue > max)
1849       {
1850         currencyValue = max;
1851       }
1852       // Math: worst case
1853       // MAX * MAX_BEFORE_SQUARE
1854       // / MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE
1855       tokenValue = BigDiv.bigDiv2x1(
1856         currencyValue,
1857         buySlopeDen,
1858         initGoal * buySlopeNum
1859       );
1860 
1861       if(currencyValue != _currencyValue)
1862       {
1863         currencyValue = _currencyValue - max;
1864         // ((2*next_amount/buy_slope)+init_goal^2)^(1/2)-init_goal
1865         // a: next_amount | currencyValue
1866         // n/d: buy_slope (MAX_BEFORE_SQUARE / MAX_BEFORE_SQUARE)
1867         // g: init_goal (MAX_BEFORE_SQUARE/2)
1868         // r: init_reserve (MAX_BEFORE_SQUARE/2)
1869         // sqrt(((2*a/(n/d))+g^2)-g
1870         // sqrt((2 d a + n g^2)/n) - g
1871 
1872         // currencyValue == 2 d a
1873         uint temp = 2 * buySlopeDen;
1874         currencyValue = temp.mul(currencyValue);
1875 
1876         // temp == g^2
1877         temp = initGoal;
1878         temp *= temp;
1879 
1880         // temp == n g^2
1881         temp = temp.mul(buySlopeNum);
1882 
1883         // temp == (2 d a) + n g^2
1884         temp = currencyValue.add(temp);
1885 
1886         // temp == (2 d a + n g^2)/n
1887         temp /= buySlopeNum;
1888 
1889         // temp == sqrt((2 d a + n g^2)/n)
1890         temp = temp.sqrt();
1891 
1892         // temp == sqrt((2 d a + n g^2)/n) - g
1893         temp -= initGoal;
1894 
1895         tokenValue = tokenValue.add(temp);
1896       }
1897     }
1898     else if(state == STATE_RUN)
1899     {
1900       // initReserve is reduced on sell as necessary to ensure that this line will not overflow
1901       uint supply = totalSupply() + burnedSupply - initReserve;
1902       // Math: worst case
1903       // MAX * 2 * MAX_BEFORE_SQUARE
1904       // / MAX_BEFORE_SQUARE
1905       tokenValue = BigDiv.bigDiv2x1(
1906         _currencyValue,
1907         2 * buySlopeDen,
1908         buySlopeNum
1909       );
1910 
1911       // Math: worst case MAX + (MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE)
1912       tokenValue = tokenValue.add(supply * supply);
1913       tokenValue = tokenValue.sqrt();
1914 
1915       // Math: small chance of underflow due to possible rounding in sqrt
1916       tokenValue = tokenValue.sub(supply);
1917     }
1918     else
1919     {
1920       // invalid state
1921       return 0;
1922     }
1923 
1924     return tokenValue;
1925   }
1926 
1927   function _buy(
1928     address payable _from,
1929     address _to,
1930     uint _currencyValue,
1931     uint _minTokensBought
1932   ) internal
1933   {
1934     require(_to != address(0), "INVALID_ADDRESS");
1935     require(_minTokensBought > 0, "MUST_BUY_AT_LEAST_1");
1936 
1937     // Calculate the tokenValue for this investment
1938     uint tokenValue = estimateBuyValue(_currencyValue);
1939     require(tokenValue >= _minTokensBought, "PRICE_SLIPPAGE");
1940 
1941     emit Buy(_from, _to, _currencyValue, tokenValue);
1942 
1943     _collectInvestment(_from, _currencyValue, msg.value, false);
1944 
1945     // Update state, initInvestors, and distribute the investment when appropriate
1946     if(state == STATE_INIT)
1947     {
1948       // Math worst case: MAX_BEFORE_SQUARE
1949       initInvestors[_to] += tokenValue;
1950       // Math worst case:
1951       // MAX_BEFORE_SQUARE + MAX_BEFORE_SQUARE
1952       if(totalSupply() + tokenValue - initReserve >= initGoal)
1953       {
1954         emit StateChange(state, STATE_RUN);
1955         state = STATE_RUN;
1956         if(__startedOn == 0) {
1957           __startedOn = block.timestamp;
1958         }
1959 
1960         // Math worst case:
1961         // MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE/2
1962         // / MAX_BEFORE_SQUARE
1963         uint beneficiaryContribution = BigDiv.bigDiv2x1(
1964           initInvestors[beneficiary],
1965           buySlopeNum * initGoal,
1966           buySlopeDen
1967         );
1968 
1969         if(setupFee > 0)
1970         {
1971           _transferCurrency(setupFeeRecipient, setupFee);
1972           if(beneficiaryContribution > setupFee)
1973           {
1974             beneficiaryContribution -= setupFee;
1975           }
1976           else
1977           {
1978             beneficiaryContribution = 0;
1979           }
1980         }
1981 
1982         _distributeInvestment(buybackReserve().sub(beneficiaryContribution));
1983       }
1984     }
1985     else // implied: if(state == STATE_RUN)
1986     {
1987       if(_to != beneficiary)
1988       {
1989         _distributeInvestment(_currencyValue);
1990       }
1991     }
1992 
1993     _mint(_to, tokenValue);
1994   }
1995 
1996   /// @notice Purchase FAIR tokens with the given amount of currency.
1997   /// @param _to The account to receive the FAIR tokens from this purchase.
1998   /// @param _currencyValue How much currency to spend in order to buy FAIR.
1999   /// @param _minTokensBought Buy at least this many FAIR tokens or the transaction reverts.
2000   /// @dev _minTokensBought is necessary as the price will change if some elses transaction mines after
2001   /// yours was submitted.
2002   function buy(
2003     address _to,
2004     uint _currencyValue,
2005     uint _minTokensBought
2006   ) public payable
2007   {
2008     _buy(msg.sender, _to, _currencyValue, _minTokensBought);
2009   }
2010 
2011   /// @notice Allow users to sign a message authorizing a buy
2012   function permitBuy(
2013     address payable _from,
2014     address _to,
2015     uint _currencyValue,
2016     uint _minTokensBought,
2017     uint _deadline,
2018     uint8 _v,
2019     bytes32 _r,
2020     bytes32 _s
2021   ) external
2022   {
2023     require(_deadline >= block.timestamp, "EXPIRED");
2024     bytes32 digest = keccak256(abi.encode(PERMIT_BUY_TYPEHASH, _from, _to, _currencyValue, _minTokensBought, nonces[_from]++, _deadline));
2025     digest = keccak256(
2026       abi.encodePacked(
2027         "\x19\x01",
2028         DOMAIN_SEPARATOR,
2029         digest
2030       )
2031     );
2032     address recoveredAddress = ecrecover(digest, _v, _r, _s);
2033     require(recoveredAddress != address(0) && recoveredAddress == _from, "INVALID_SIGNATURE");
2034     _buy(_from, _to, _currencyValue, _minTokensBought);
2035   }
2036 
2037   /// Sell
2038 
2039   function estimateSellValue(
2040     uint _quantityToSell
2041   ) public view
2042     returns(uint)
2043   {
2044     uint reserve = buybackReserve();
2045 
2046     // Calculate currencyValue for this sale
2047     uint currencyValue;
2048     if(state == STATE_RUN)
2049     {
2050       uint supply = totalSupply() + burnedSupply;
2051 
2052       // buyback_reserve = r
2053       // total_supply = t
2054       // burnt_supply = b
2055       // amount = a
2056       // source: (t+b)*a*(2*r)/((t+b)^2)-(((2*r)/((t+b)^2)*a^2)/2)+((2*r)/((t+b)^2)*a*b^2)/(2*(t))
2057       // imp: (a b^2 r)/(t (b + t)^2) + (2 a r)/(b + t) - (a^2 r)/(b + t)^2
2058 
2059       // Math: burnedSupply is capped in FAIR such that the square will never overflow
2060       // Math worst case:
2061       // MAX * MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE/2 * MAX_BEFORE_SQUARE/2
2062       // / MAX_BEFORE_SQUARE/2 * MAX_BEFORE_SQUARE/2 * MAX_BEFORE_SQUARE/2
2063       currencyValue = BigDiv.bigDiv2x2(
2064         _quantityToSell.mul(reserve),
2065         burnedSupply * burnedSupply,
2066         totalSupply(), supply * supply
2067       );
2068       // Math: worst case currencyValue is MAX_BEFORE_SQUARE (max reserve, 1 supply)
2069 
2070       // Math worst case:
2071       // MAX * 2 * MAX_BEFORE_SQUARE
2072       uint temp = _quantityToSell.mul(2 * reserve);
2073       temp /= supply;
2074       // Math: worst-case temp is MAX_BEFORE_SQUARE (max reserve, 1 supply)
2075 
2076       // Math: considering the worst-case for currencyValue and temp, this can never overflow
2077       currencyValue += temp;
2078 
2079       // Math: worst case
2080       // MAX * MAX * MAX_BEFORE_SQUARE
2081       // / MAX_BEFORE_SQUARE/2 * MAX_BEFORE_SQUARE/2
2082       temp = BigDiv.bigDiv2x1RoundUp(
2083         _quantityToSell.mul(_quantityToSell),
2084         reserve,
2085         supply * supply
2086       );
2087       if(currencyValue > temp)
2088       {
2089         currencyValue -= temp;
2090       }
2091       else
2092       {
2093         currencyValue = 0;
2094       }
2095     }
2096     else if(state == STATE_CLOSE)
2097     {
2098       // Math worst case
2099       // MAX * MAX_BEFORE_SQUARE
2100       currencyValue = _quantityToSell.mul(reserve);
2101       currencyValue /= totalSupply();
2102     }
2103     else
2104     {
2105       // STATE_INIT or STATE_CANCEL
2106       // Math worst case:
2107       // MAX * MAX_BEFORE_SQUARE
2108       currencyValue = _quantityToSell.mul(reserve);
2109       // Math: FAIR blocks initReserve from being burned unless we reach the RUN state which prevents an underflow
2110       currencyValue /= totalSupply() - initReserve;
2111     }
2112 
2113     return currencyValue;
2114   }
2115 
2116   function _sell(
2117     address _from,
2118     address payable _to,
2119     uint _quantityToSell,
2120     uint _minCurrencyReturned
2121   ) internal
2122   {
2123     require(_from != beneficiary || state >= STATE_CLOSE, "BENEFICIARY_ONLY_SELL_IN_CLOSE_OR_CANCEL");
2124     require(_minCurrencyReturned > 0, "MUST_SELL_AT_LEAST_1");
2125 
2126     uint currencyValue = estimateSellValue(_quantityToSell);
2127     require(currencyValue >= _minCurrencyReturned, "PRICE_SLIPPAGE");
2128 
2129     if(state == STATE_INIT || state == STATE_CANCEL)
2130     {
2131       initInvestors[_from] = initInvestors[_from].sub(_quantityToSell);
2132     }
2133 
2134     _burn(_from, _quantityToSell, true);
2135     uint supply = totalSupply() + burnedSupply;
2136     if(supply < initReserve)
2137     {
2138       initReserve = supply;
2139     }
2140 
2141     _transferCurrency(_to, currencyValue);
2142     emit Sell(_from, _to, currencyValue, _quantityToSell);
2143   }
2144 
2145   /// @notice Sell FAIR tokens for at least the given amount of currency.
2146   /// @param _to The account to receive the currency from this sale.
2147   /// @param _quantityToSell How many FAIR tokens to sell for currency value.
2148   /// @param _minCurrencyReturned Get at least this many currency tokens or the transaction reverts.
2149   /// @dev _minCurrencyReturned is necessary as the price will change if some elses transaction mines after
2150   /// yours was submitted.
2151   function sell(
2152     address payable _to,
2153     uint _quantityToSell,
2154     uint _minCurrencyReturned
2155   ) public
2156   {
2157     _sell(msg.sender, _to, _quantityToSell, _minCurrencyReturned);
2158   }
2159 
2160   /// @notice Allow users to sign a message authorizing a sell
2161   function permitSell(
2162     address _from,
2163     address payable _to,
2164     uint _quantityToSell,
2165     uint _minCurrencyReturned,
2166     uint _deadline,
2167     uint8 _v,
2168     bytes32 _r,
2169     bytes32 _s
2170   ) external
2171   {
2172     require(_deadline >= block.timestamp, "EXPIRED");
2173     bytes32 digest = keccak256(abi.encode(PERMIT_SELL_TYPEHASH, _from, _to, _quantityToSell, _minCurrencyReturned, nonces[_from]++, _deadline));
2174     digest = keccak256(
2175       abi.encodePacked(
2176         "\x19\x01",
2177         DOMAIN_SEPARATOR,
2178         digest
2179       )
2180     );
2181     address recoveredAddress = ecrecover(digest, _v, _r, _s);
2182     require(recoveredAddress != address(0) && recoveredAddress == _from, "INVALID_SIGNATURE");
2183     _sell(_from, _to, _quantityToSell, _minCurrencyReturned);
2184   }
2185 
2186   /// Close
2187 
2188   /// @notice Called by the beneficiary account to STATE_CLOSE or STATE_CANCEL the c-org,
2189   /// preventing any more tokens from being minted.
2190   /// @dev Requires an `exitFee` to be paid.  If the currency is ETH, include a little more than
2191   /// what appears to be required and any remainder will be returned to your account.  This is
2192   /// because another user may have a transaction mined which changes the exitFee required.
2193   /// For other `currency` types, the beneficiary account will be billed the exact amount required.
2194   function _close() internal
2195   {
2196     require(msg.sender == beneficiary, "BENEFICIARY_ONLY");
2197 
2198     if(state == STATE_INIT)
2199     {
2200       // Allow the org to cancel anytime if the initGoal was not reached.
2201       emit StateChange(state, STATE_CANCEL);
2202       state = STATE_CANCEL;
2203     }
2204     else if(state == STATE_RUN)
2205     {
2206       // Collect the exitFee and close the c-org.
2207       require(MAX_UINT - minDuration > __startedOn, "MAY_NOT_CLOSE");
2208       require(minDuration + __startedOn <= block.timestamp, "TOO_EARLY");
2209 
2210       emit StateChange(state, STATE_CLOSE);
2211       state = STATE_CLOSE;
2212     }
2213     else
2214     {
2215       revert("INVALID_STATE");
2216     }
2217   }
2218 
2219   // --- Approve by signature ---
2220   // EIP-2612
2221   // Original source: https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol
2222   function permit(
2223     address owner,
2224     address spender,
2225     uint value,
2226     uint deadline,
2227     uint8 v,
2228     bytes32 r,
2229     bytes32 s
2230   ) external
2231   {
2232     require(deadline >= block.timestamp, "EXPIRED");
2233     bytes32 digest = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
2234     digest = keccak256(
2235       abi.encodePacked(
2236         "\x19\x01",
2237         DOMAIN_SEPARATOR,
2238         digest
2239       )
2240     );
2241     address recoveredAddress = ecrecover(digest, v, r, s);
2242     require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNATURE");
2243     _approve(owner, spender, value);
2244   }
2245 
2246   /**
2247 * @dev Returns the name of the token.
2248 */
2249   function name() public view returns (string memory) {
2250     return "Vision Token";
2251   }
2252 
2253   /**
2254    * @dev Returns the symbol of the token, usually a shorter version of the
2255    * name.
2256    */
2257   function symbol() public view returns (string memory) {
2258     return "VISION";
2259   }
2260 
2261   /**
2262    * @dev Returns the number of decimals used to get its user representation.
2263    * For example, if `decimals` equals `2`, a balance of `505` tokens should
2264    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2265    *
2266    * Tokens usually opt for a value of 18, imitating the relationship between
2267    * Ether and Wei.
2268    *
2269    * NOTE: This information is only used for _display_ purposes: it in
2270    * no way affects any of the arithmetic of the contract, including
2271    * {IERC20-balanceOf} and {IERC20-transfer}.
2272    */
2273   function decimals() public view returns (uint8) {
2274     return 18;
2275   }
2276 
2277   uint256[50] private __gap;
2278 }
2279 
2280 /**
2281  * @title Decentralized Autonomous Trust
2282  * This contract is the reference implementation provided by Fairmint for a
2283  * Decentralized Autonomous Trust as described in the continuous
2284  * organization whitepaper (https://github.com/c-org/whitepaper) and
2285  * specified here: https://github.com/fairmint/c-org/wiki. Use at your own
2286  * risk. If you have question or if you're looking for a ready-to-use
2287  * solution using this contract, you might be interested in Fairmint's
2288  * offering. Do not hesitate to get in touch with us: https://fairmint.co
2289  */
2290 contract VisionToken is ContinuousOffering {
2291   event Close(uint _exitFee);
2292   event Pay(address indexed _from, uint _currencyValue);
2293   event UpdateConfig(
2294     address _whitelistAddress,
2295     address indexed _beneficiary,
2296     address indexed _control,
2297     address indexed _feeCollector,
2298     uint _revenueCommitmentBasisPoints,
2299     uint _feeBasisPoints,
2300     uint _minInvestment,
2301     uint _minDuration
2302   );
2303 
2304   /// @notice The revenue commitment of the organization. Defines the percentage of the value paid through the contract
2305   /// that is automatically funneled and held into the buyback_reserve expressed in basis points.
2306   /// Internal since this is n/a to all derivative contracts.
2307   function revenueCommitmentBasisPoints() public view returns (uint) {
2308     return __revenueCommitmentBasisPoints;
2309   }
2310 
2311   /// @notice The investment reserve of the c-org. Defines the percentage of the value invested that is
2312   /// automatically funneled and held into the buyback_reserve expressed in basis points.
2313   /// Internal since this is n/a to all derivative contracts.
2314   function investmentReserveBasisPoints() public view returns (uint) {
2315     return __investmentReserveBasisPoints;
2316   }
2317 
2318   /// @notice Initialized at `0` and updated when the contract switches from `init` state to `run` state
2319   /// with the current timestamp.
2320   function runStartedOn() public view returns (uint) {
2321     return __startedOn;
2322   }
2323 
2324   function initialize(
2325     uint _initReserve,
2326     address _currencyAddress,
2327     uint _initGoal,
2328     uint _buySlopeNum,
2329     uint _buySlopeDen,
2330     uint _investmentReserveBasisPoints,
2331     uint _setupFee,
2332     address payable _setupFeeRecipient
2333   ) public
2334   {
2335     // _initialize will enforce this is only called once
2336     super._initialize(
2337       _initReserve,
2338       _currencyAddress,
2339       _initGoal,
2340       _buySlopeNum,
2341       _buySlopeDen,
2342       _setupFee,
2343       _setupFeeRecipient
2344     );
2345 
2346     // Set initGoal, which in turn defines the initial state
2347     if(_initGoal == 0)
2348     {
2349       emit StateChange(state, STATE_RUN);
2350       state = STATE_RUN;
2351       __startedOn = block.timestamp;
2352     }
2353     else
2354     {
2355       // Math: If this value got too large, the DAT would overflow on sell
2356       require(_initGoal < MAX_SUPPLY, "EXCESSIVE_GOAL");
2357       initGoal = _initGoal;
2358     }
2359 
2360     // 100% or less
2361     require(_investmentReserveBasisPoints <= BASIS_POINTS_DEN, "INVALID_RESERVE");
2362     __investmentReserveBasisPoints = _investmentReserveBasisPoints;
2363   }
2364 
2365 
2366 
2367   /// Close
2368 
2369 
2370   function estimateExitFee(uint _msgValue) public view returns (uint) {
2371     uint exitFee;
2372 
2373     if (state == STATE_RUN) {
2374       uint reserve = buybackReserve();
2375       reserve = reserve.sub(_msgValue);
2376 
2377       // Source: t*(t+b)*(n/d)-r
2378       // Implementation: (b n t)/d + (n t^2)/d - r
2379 
2380       uint _totalSupply = totalSupply();
2381 
2382       // Math worst case:
2383       // MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE/2 * MAX_BEFORE_SQUARE
2384       exitFee = BigDiv.bigDiv2x1(
2385         _totalSupply,
2386         burnedSupply * buySlopeNum,
2387         buySlopeDen
2388       );
2389       // Math worst case:
2390       // MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE * MAX_BEFORE_SQUARE
2391       exitFee += BigDiv.bigDiv2x1(
2392         _totalSupply,
2393         buySlopeNum * _totalSupply,
2394         buySlopeDen
2395       );
2396       // Math: this if condition avoids a potential overflow
2397       if (exitFee <= reserve) {
2398         exitFee = 0;
2399       } else {
2400         exitFee -= reserve;
2401       }
2402     }
2403 
2404     return exitFee;
2405   }
2406 
2407   /// @notice Called by the beneficiary account to STATE_CLOSE or STATE_CANCEL the c-org,
2408   /// preventing any more tokens from being minted.
2409   /// @dev Requires an `exitFee` to be paid.  If the currency is ETH, include a little more than
2410   /// what appears to be required and any remainder will be returned to your account.  This is
2411   /// because another user may have a transaction mined which changes the exitFee required.
2412   /// For other `currency` types, the beneficiary account will be billed the exact amount required.
2413   function close() public payable {
2414     uint exitFee = 0;
2415 
2416     if (state == STATE_RUN) {
2417       exitFee = estimateExitFee(msg.value);
2418       _collectInvestment(msg.sender, exitFee, msg.value, true);
2419     }
2420 
2421     super._close();
2422     emit Close(exitFee);
2423   }
2424 
2425   /// Pay
2426 
2427   /// @dev Pay the organization on-chain.
2428   /// @param _currencyValue How much currency which was paid.
2429   function pay(uint _currencyValue) public payable {
2430     _collectInvestment(msg.sender, _currencyValue, msg.value, false);
2431     require(state == STATE_RUN, "INVALID_STATE");
2432     require(_currencyValue > 0, "MISSING_CURRENCY");
2433 
2434     // Send a portion of the funds to the beneficiary, the rest is added to the buybackReserve
2435     // Math: if _currencyValue is < (2^256 - 1) / 10000 this will not overflow
2436     uint reserve = _currencyValue.mul(__revenueCommitmentBasisPoints);
2437     reserve /= BASIS_POINTS_DEN;
2438 
2439     // Math: this will never underflow since revenueCommitmentBasisPoints is capped to BASIS_POINTS_DEN
2440     _transferCurrency(beneficiary, _currencyValue - reserve);
2441 
2442     emit Pay(msg.sender, _currencyValue);
2443   }
2444 
2445   /// @notice Pay the organization on-chain without minting any tokens.
2446   /// @dev This allows you to add funds directly to the buybackReserve.
2447   function() external payable {
2448     require(address(currency) == address(0), "ONLY_FOR_CURRENCY_ETH");
2449   }
2450 
2451   function updateConfig(
2452     address _whitelistAddress,
2453     address payable _beneficiary,
2454     address _control,
2455     address payable _feeCollector,
2456     uint _feeBasisPoints,
2457     uint _revenueCommitmentBasisPoints,
2458     uint _minInvestment,
2459     uint _minDuration
2460   ) public {
2461     _updateConfig(
2462       _whitelistAddress,
2463       _beneficiary,
2464       _control,
2465       _feeCollector,
2466       _feeBasisPoints,
2467       _minInvestment,
2468       _minDuration
2469     );
2470 
2471     require(
2472       _revenueCommitmentBasisPoints <= BASIS_POINTS_DEN,
2473       "INVALID_COMMITMENT"
2474     );
2475     require(
2476       _revenueCommitmentBasisPoints >= __revenueCommitmentBasisPoints,
2477       "COMMITMENT_MAY_NOT_BE_REDUCED"
2478     );
2479     __revenueCommitmentBasisPoints = _revenueCommitmentBasisPoints;
2480 
2481     emit UpdateConfig(
2482       _whitelistAddress,
2483       _beneficiary,
2484       _control,
2485       _feeCollector,
2486       _revenueCommitmentBasisPoints,
2487       _feeBasisPoints,
2488       _minInvestment,
2489       _minDuration
2490     );
2491   }
2492 
2493   /// @notice A temporary function to set `runStartedOn`, to be used by contracts which were
2494   /// already deployed before this feature was introduced.
2495   /// @dev This function will be removed once known users have called the function.
2496   function initializeRunStartedOn(
2497     uint _runStartedOn
2498   ) external
2499   {
2500     require(msg.sender == control, "CONTROL_ONLY");
2501     require(state == STATE_RUN, "ONLY_CALL_IN_RUN");
2502     require(__startedOn == 0, "ONLY_CALL_IF_NOT_AUTO_SET");
2503     require(_runStartedOn <= block.timestamp, "DATE_MUST_BE_IN_PAST");
2504 
2505     __startedOn = _runStartedOn;
2506   }
2507 
2508   /// @dev Distributes _value currency between the buybackReserve, beneficiary, and feeCollector.
2509   function _distributeInvestment(
2510     uint _value
2511   ) internal
2512   {
2513     // Rounding favors buybackReserve, then beneficiary, and feeCollector is last priority.
2514 
2515     // Math: if investment value is < (2^256 - 1) / 10000 this will never overflow.
2516     // Except maybe with a huge single investment, but they can try again with multiple smaller investments.
2517     uint reserve = __investmentReserveBasisPoints.mul(_value);
2518     reserve /= BASIS_POINTS_DEN;
2519     reserve = _value.sub(reserve);
2520     uint fee = reserve.mul(feeBasisPoints);
2521     fee /= BASIS_POINTS_DEN;
2522 
2523     // Math: since feeBasisPoints is <= BASIS_POINTS_DEN, this will never underflow.
2524     _transferCurrency(beneficiary, reserve - fee);
2525     _transferCurrency(feeCollector, fee);
2526   }
2527 }