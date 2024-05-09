1 pragma solidity 0.5.16;
2 
3 // INTERFACE
4 interface IERC20Mintable {
5     function transfer(address _to, uint256 _value) external returns (bool);
6 
7     function transferFrom(
8         address _from,
9         address _to,
10         uint256 _value
11     ) external returns (bool);
12 
13     function mint(address _to, uint256 _value) external returns (bool);
14 
15     function balanceOf(address _account) external view returns (uint256);
16 
17     function totalSupply() external view returns (uint256);
18 }
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
22  * the optional functions; to access them see {ERC20Detailed}.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // LIB
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      *
153      * _Available since v2.4.0._
154      */
155     function sub(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      *
215      * _Available since v2.4.0._
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         // Solidity only automatically asserts when dividing by 0
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      *
256      * _Available since v2.4.0._
257      */
258     function mod(
259         uint256 a,
260         uint256 b,
261         string memory errorMessage
262     ) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             codehash := extcodehash(account)
298         }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Converts an `address` into `address payable`. Note that this is
304      * simply a type cast: the actual underlying value is not changed.
305      *
306      * _Available since v2.4.0._
307      */
308     function toPayable(address account) internal pure returns (address payable) {
309         return address(uint160(account));
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      *
328      * _Available since v2.4.0._
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-call-value
334         (bool success, ) = recipient.call.value(amount)("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 }
338 
339 /**
340  * @title SafeERC20
341  * @dev Wrappers around ERC20 operations that throw on failure (when the token
342  * contract returns false). Tokens that return no value (and instead revert or
343  * throw on failure) are also supported, non-reverting calls are assumed to be
344  * successful.
345  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
346  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
347  */
348 library SafeERC20 {
349     using SafeMath for uint256;
350     using Address for address;
351 
352     function safeTransfer(
353         IERC20 token,
354         address to,
355         uint256 value
356     ) internal {
357         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
358     }
359 
360     function safeTransferFrom(
361         IERC20 token,
362         address from,
363         address to,
364         uint256 value
365     ) internal {
366         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
367     }
368 
369     function safeApprove(
370         IERC20 token,
371         address spender,
372         uint256 value
373     ) internal {
374         // safeApprove should only be called when setting an initial allowance,
375         // or when resetting it to zero. To increase and decrease it, use
376         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
377         // solhint-disable-next-line max-line-length
378         require(
379             (value == 0) || (token.allowance(address(this), spender) == 0),
380             "SafeERC20: approve from non-zero to non-zero allowance"
381         );
382         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
383     }
384 
385     function safeIncreaseAllowance(
386         IERC20 token,
387         address spender,
388         uint256 value
389     ) internal {
390         uint256 newAllowance = token.allowance(address(this), spender).add(value);
391         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
392     }
393 
394     function safeDecreaseAllowance(
395         IERC20 token,
396         address spender,
397         uint256 value
398     ) internal {
399         uint256 newAllowance = token.allowance(address(this), spender).sub(
400             value,
401             "SafeERC20: decreased allowance below zero"
402         );
403         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
404     }
405 
406     /**
407      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
408      * on the return value: the return value is optional (but if data is returned, it must not be false).
409      * @param token The token targeted by the call.
410      * @param data The call data (encoded using abi.encode or one of its variants).
411      */
412     function callOptionalReturn(IERC20 token, bytes memory data) private {
413         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
414         // we're implementing it ourselves.
415 
416         // A Solidity high level call has three parts:
417         //  1. The target address is checked to verify it contains contract code
418         //  2. The call itself is made, and success asserted
419         //  3. The return value is decoded, which in turn checks the size of the returned data.
420         // solhint-disable-next-line max-line-length
421         require(address(token).isContract(), "SafeERC20: call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = address(token).call(data);
425         require(success, "SafeERC20: low-level call failed");
426 
427         if (returndata.length > 0) {
428             // Return data is optional
429             // solhint-disable-next-line max-line-length
430             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
431         }
432     }
433 }
434 
435 /**
436  * Smart contract library of mathematical functions operating with signed
437  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
438  * basically a simple fraction whose numerator is signed 128-bit integer and
439  * denominator is 2^64.  As long as denominator is always the same, there is no
440  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
441  * represented by int128 type holding only the numerator.
442  */
443 library ABDKMath64x64 {
444     /*
445      * Minimum value signed 64.64-bit fixed point number may have.
446      */
447     int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
448 
449     /*
450      * Maximum value signed 64.64-bit fixed point number may have.
451      */
452     int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
453 
454     /**
455      * Convert signed 256-bit integer number into signed 64.64-bit fixed point
456      * number.  Revert on overflow.
457      *
458      * @param x signed 256-bit integer number
459      * @return signed 64.64-bit fixed point number
460      */
461     function fromInt(int256 x) internal pure returns (int128) {
462         require(x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
463         return int128(x << 64);
464     }
465 
466     /**
467      * Convert signed 64.64 fixed point number into signed 64-bit integer number
468      * rounding down.
469      *
470      * @param x signed 64.64-bit fixed point number
471      * @return signed 64-bit integer number
472      */
473     function toInt(int128 x) internal pure returns (int64) {
474         return int64(x >> 64);
475     }
476 
477     /**
478      * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
479      * number.  Revert on overflow.
480      *
481      * @param x unsigned 256-bit integer number
482      * @return signed 64.64-bit fixed point number
483      */
484     function fromUInt(uint256 x) internal pure returns (int128) {
485         require(x <= 0x7FFFFFFFFFFFFFFF);
486         return int128(x << 64);
487     }
488 
489     /**
490      * Convert signed 64.64 fixed point number into unsigned 64-bit integer
491      * number rounding down.  Revert on underflow.
492      *
493      * @param x signed 64.64-bit fixed point number
494      * @return unsigned 64-bit integer number
495      */
496     function toUInt(int128 x) internal pure returns (uint64) {
497         require(x >= 0);
498         return uint64(x >> 64);
499     }
500 
501     /**
502      * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
503      * number rounding down.  Revert on overflow.
504      *
505      * @param x signed 128.128-bin fixed point number
506      * @return signed 64.64-bit fixed point number
507      */
508     function from128x128(int256 x) internal pure returns (int128) {
509         int256 result = x >> 64;
510         require(result >= MIN_64x64 && result <= MAX_64x64);
511         return int128(result);
512     }
513 
514     /**
515      * Convert signed 64.64 fixed point number into signed 128.128 fixed point
516      * number.
517      *
518      * @param x signed 64.64-bit fixed point number
519      * @return signed 128.128 fixed point number
520      */
521     function to128x128(int128 x) internal pure returns (int256) {
522         return int256(x) << 64;
523     }
524 
525     /**
526      * Calculate x + y.  Revert on overflow.
527      *
528      * @param x signed 64.64-bit fixed point number
529      * @param y signed 64.64-bit fixed point number
530      * @return signed 64.64-bit fixed point number
531      */
532     function add(int128 x, int128 y) internal pure returns (int128) {
533         int256 result = int256(x) + y;
534         require(result >= MIN_64x64 && result <= MAX_64x64);
535         return int128(result);
536     }
537 
538     /**
539      * Calculate x - y.  Revert on overflow.
540      *
541      * @param x signed 64.64-bit fixed point number
542      * @param y signed 64.64-bit fixed point number
543      * @return signed 64.64-bit fixed point number
544      */
545     function sub(int128 x, int128 y) internal pure returns (int128) {
546         int256 result = int256(x) - y;
547         require(result >= MIN_64x64 && result <= MAX_64x64);
548         return int128(result);
549     }
550 
551     /**
552      * Calculate x * y rounding down.  Revert on overflow.
553      *
554      * @param x signed 64.64-bit fixed point number
555      * @param y signed 64.64-bit fixed point number
556      * @return signed 64.64-bit fixed point number
557      */
558     function mul(int128 x, int128 y) internal pure returns (int128) {
559         int256 result = (int256(x) * y) >> 64;
560         require(result >= MIN_64x64 && result <= MAX_64x64);
561         return int128(result);
562     }
563 
564     /**
565      * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
566      * number and y is signed 256-bit integer number.  Revert on overflow.
567      *
568      * @param x signed 64.64 fixed point number
569      * @param y signed 256-bit integer number
570      * @return signed 256-bit integer number
571      */
572     function muli(int128 x, int256 y) internal pure returns (int256) {
573         if (x == MIN_64x64) {
574             require(
575                 y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
576                     y <= 0x1000000000000000000000000000000000000000000000000
577             );
578             return -y << 63;
579         } else {
580             bool negativeResult = false;
581             if (x < 0) {
582                 x = -x;
583                 negativeResult = true;
584             }
585             if (y < 0) {
586                 y = -y; // We rely on overflow behavior here
587                 negativeResult = !negativeResult;
588             }
589             uint256 absoluteResult = mulu(x, uint256(y));
590             if (negativeResult) {
591                 require(absoluteResult <= 0x8000000000000000000000000000000000000000000000000000000000000000);
592                 return -int256(absoluteResult); // We rely on overflow behavior here
593             } else {
594                 require(absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
595                 return int256(absoluteResult);
596             }
597         }
598     }
599 
600     /**
601      * Calculate x * y rounding down, where x is signed 64.64 fixed point number
602      * and y is unsigned 256-bit integer number.  Revert on overflow.
603      *
604      * @param x signed 64.64 fixed point number
605      * @param y unsigned 256-bit integer number
606      * @return unsigned 256-bit integer number
607      */
608     function mulu(int128 x, uint256 y) internal pure returns (uint256) {
609         if (y == 0) return 0;
610 
611         require(x >= 0);
612 
613         uint256 lo = (uint256(x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
614         uint256 hi = uint256(x) * (y >> 128);
615 
616         require(hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
617         hi <<= 64;
618 
619         require(hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
620         return hi + lo;
621     }
622 
623     /**
624      * Calculate x / y rounding towards zero.  Revert on overflow or when y is
625      * zero.
626      *
627      * @param x signed 64.64-bit fixed point number
628      * @param y signed 64.64-bit fixed point number
629      * @return signed 64.64-bit fixed point number
630      */
631     function div(int128 x, int128 y) internal pure returns (int128) {
632         require(y != 0);
633         int256 result = (int256(x) << 64) / y;
634         require(result >= MIN_64x64 && result <= MAX_64x64);
635         return int128(result);
636     }
637 
638     /**
639      * Calculate x / y rounding towards zero, where x and y are signed 256-bit
640      * integer numbers.  Revert on overflow or when y is zero.
641      *
642      * @param x signed 256-bit integer number
643      * @param y signed 256-bit integer number
644      * @return signed 64.64-bit fixed point number
645      */
646     function divi(int256 x, int256 y) internal pure returns (int128) {
647         require(y != 0);
648 
649         bool negativeResult = false;
650         if (x < 0) {
651             x = -x; // We rely on overflow behavior here
652             negativeResult = true;
653         }
654         if (y < 0) {
655             y = -y; // We rely on overflow behavior here
656             negativeResult = !negativeResult;
657         }
658         uint128 absoluteResult = divuu(uint256(x), uint256(y));
659         if (negativeResult) {
660             require(absoluteResult <= 0x80000000000000000000000000000000);
661             return -int128(absoluteResult); // We rely on overflow behavior here
662         } else {
663             require(absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
664             return int128(absoluteResult); // We rely on overflow behavior here
665         }
666     }
667 
668     /**
669      * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
670      * integer numbers.  Revert on overflow or when y is zero.
671      *
672      * @param x unsigned 256-bit integer number
673      * @param y unsigned 256-bit integer number
674      * @return signed 64.64-bit fixed point number
675      */
676     function divu(uint256 x, uint256 y) internal pure returns (int128) {
677         require(y != 0);
678         uint128 result = divuu(x, y);
679         require(result <= uint128(MAX_64x64));
680         return int128(result);
681     }
682 
683     /**
684      * Calculate -x.  Revert on overflow.
685      *
686      * @param x signed 64.64-bit fixed point number
687      * @return signed 64.64-bit fixed point number
688      */
689     function neg(int128 x) internal pure returns (int128) {
690         require(x != MIN_64x64);
691         return -x;
692     }
693 
694     /**
695      * Calculate |x|.  Revert on overflow.
696      *
697      * @param x signed 64.64-bit fixed point number
698      * @return signed 64.64-bit fixed point number
699      */
700     function abs(int128 x) internal pure returns (int128) {
701         require(x != MIN_64x64);
702         return x < 0 ? -x : x;
703     }
704 
705     /**
706      * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
707      * zero.
708      *
709      * @param x signed 64.64-bit fixed point number
710      * @return signed 64.64-bit fixed point number
711      */
712     function inv(int128 x) internal pure returns (int128) {
713         require(x != 0);
714         int256 result = int256(0x100000000000000000000000000000000) / x;
715         require(result >= MIN_64x64 && result <= MAX_64x64);
716         return int128(result);
717     }
718 
719     /**
720      * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
721      *
722      * @param x signed 64.64-bit fixed point number
723      * @param y signed 64.64-bit fixed point number
724      * @return signed 64.64-bit fixed point number
725      */
726     function avg(int128 x, int128 y) internal pure returns (int128) {
727         return int128((int256(x) + int256(y)) >> 1);
728     }
729 
730     /**
731      * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
732      * Revert on overflow or in case x * y is negative.
733      *
734      * @param x signed 64.64-bit fixed point number
735      * @param y signed 64.64-bit fixed point number
736      * @return signed 64.64-bit fixed point number
737      */
738     function gavg(int128 x, int128 y) internal pure returns (int128) {
739         int256 m = int256(x) * int256(y);
740         require(m >= 0);
741         require(m < 0x4000000000000000000000000000000000000000000000000000000000000000);
742         return int128(sqrtu(uint256(m)));
743     }
744 
745     /**
746      * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
747      * and y is unsigned 256-bit integer number.  Revert on overflow.
748      *
749      * @param x signed 64.64-bit fixed point number
750      * @param y uint256 value
751      * @return signed 64.64-bit fixed point number
752      */
753     function pow(int128 x, uint256 y) internal pure returns (int128) {
754         bool negative = x < 0 && y & 1 == 1;
755 
756         uint256 absX = uint128(x < 0 ? -x : x);
757         uint256 absResult;
758         absResult = 0x100000000000000000000000000000000;
759 
760         if (absX <= 0x10000000000000000) {
761             absX <<= 63;
762             while (y != 0) {
763                 if (y & 0x1 != 0) {
764                     absResult = (absResult * absX) >> 127;
765                 }
766                 absX = (absX * absX) >> 127;
767 
768                 if (y & 0x2 != 0) {
769                     absResult = (absResult * absX) >> 127;
770                 }
771                 absX = (absX * absX) >> 127;
772 
773                 if (y & 0x4 != 0) {
774                     absResult = (absResult * absX) >> 127;
775                 }
776                 absX = (absX * absX) >> 127;
777 
778                 if (y & 0x8 != 0) {
779                     absResult = (absResult * absX) >> 127;
780                 }
781                 absX = (absX * absX) >> 127;
782 
783                 y >>= 4;
784             }
785 
786             absResult >>= 64;
787         } else {
788             uint256 absXShift = 63;
789             if (absX < 0x1000000000000000000000000) {
790                 absX <<= 32;
791                 absXShift -= 32;
792             }
793             if (absX < 0x10000000000000000000000000000) {
794                 absX <<= 16;
795                 absXShift -= 16;
796             }
797             if (absX < 0x1000000000000000000000000000000) {
798                 absX <<= 8;
799                 absXShift -= 8;
800             }
801             if (absX < 0x10000000000000000000000000000000) {
802                 absX <<= 4;
803                 absXShift -= 4;
804             }
805             if (absX < 0x40000000000000000000000000000000) {
806                 absX <<= 2;
807                 absXShift -= 2;
808             }
809             if (absX < 0x80000000000000000000000000000000) {
810                 absX <<= 1;
811                 absXShift -= 1;
812             }
813 
814             uint256 resultShift = 0;
815             while (y != 0) {
816                 require(absXShift < 64);
817 
818                 if (y & 0x1 != 0) {
819                     absResult = (absResult * absX) >> 127;
820                     resultShift += absXShift;
821                     if (absResult > 0x100000000000000000000000000000000) {
822                         absResult >>= 1;
823                         resultShift += 1;
824                     }
825                 }
826                 absX = (absX * absX) >> 127;
827                 absXShift <<= 1;
828                 if (absX >= 0x100000000000000000000000000000000) {
829                     absX >>= 1;
830                     absXShift += 1;
831                 }
832 
833                 y >>= 1;
834             }
835 
836             require(resultShift < 64);
837             absResult >>= 64 - resultShift;
838         }
839         int256 result = negative ? -int256(absResult) : int256(absResult);
840         require(result >= MIN_64x64 && result <= MAX_64x64);
841         return int128(result);
842     }
843 
844     /**
845      * Calculate sqrt (x) rounding down.  Revert if x < 0.
846      *
847      * @param x signed 64.64-bit fixed point number
848      * @return signed 64.64-bit fixed point number
849      */
850     function sqrt(int128 x) internal pure returns (int128) {
851         require(x >= 0);
852         return int128(sqrtu(uint256(x) << 64));
853     }
854 
855     /**
856      * Calculate binary logarithm of x.  Revert if x <= 0.
857      *
858      * @param x signed 64.64-bit fixed point number
859      * @return signed 64.64-bit fixed point number
860      */
861     function log_2(int128 x) internal pure returns (int128) {
862         require(x > 0);
863 
864         int256 msb = 0;
865         int256 xc = x;
866         if (xc >= 0x10000000000000000) {
867             xc >>= 64;
868             msb += 64;
869         }
870         if (xc >= 0x100000000) {
871             xc >>= 32;
872             msb += 32;
873         }
874         if (xc >= 0x10000) {
875             xc >>= 16;
876             msb += 16;
877         }
878         if (xc >= 0x100) {
879             xc >>= 8;
880             msb += 8;
881         }
882         if (xc >= 0x10) {
883             xc >>= 4;
884             msb += 4;
885         }
886         if (xc >= 0x4) {
887             xc >>= 2;
888             msb += 2;
889         }
890         if (xc >= 0x2) msb += 1; // No need to shift xc anymore
891 
892         int256 result = (msb - 64) << 64;
893         uint256 ux = uint256(x) << uint256(127 - msb);
894         for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
895             ux *= ux;
896             uint256 b = ux >> 255;
897             ux >>= 127 + b;
898             result += bit * int256(b);
899         }
900 
901         return int128(result);
902     }
903 
904     /**
905      * Calculate natural logarithm of x.  Revert if x <= 0.
906      *
907      * @param x signed 64.64-bit fixed point number
908      * @return signed 64.64-bit fixed point number
909      */
910     function ln(int128 x) internal pure returns (int128) {
911         require(x > 0);
912 
913         return int128((uint256(log_2(x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF) >> 128);
914     }
915 
916     /**
917      * Calculate binary exponent of x.  Revert on overflow.
918      *
919      * @param x signed 64.64-bit fixed point number
920      * @return signed 64.64-bit fixed point number
921      */
922     function exp_2(int128 x) internal pure returns (int128) {
923         require(x < 0x400000000000000000); // Overflow
924 
925         if (x < -0x400000000000000000) return 0; // Underflow
926 
927         uint256 result = 0x80000000000000000000000000000000;
928 
929         if (x & 0x8000000000000000 > 0) result = (result * 0x16A09E667F3BCC908B2FB1366EA957D3E) >> 128;
930         if (x & 0x4000000000000000 > 0) result = (result * 0x1306FE0A31B7152DE8D5A46305C85EDEC) >> 128;
931         if (x & 0x2000000000000000 > 0) result = (result * 0x1172B83C7D517ADCDF7C8C50EB14A791F) >> 128;
932         if (x & 0x1000000000000000 > 0) result = (result * 0x10B5586CF9890F6298B92B71842A98363) >> 128;
933         if (x & 0x800000000000000 > 0) result = (result * 0x1059B0D31585743AE7C548EB68CA417FD) >> 128;
934         if (x & 0x400000000000000 > 0) result = (result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8) >> 128;
935         if (x & 0x200000000000000 > 0) result = (result * 0x10163DA9FB33356D84A66AE336DCDFA3F) >> 128;
936         if (x & 0x100000000000000 > 0) result = (result * 0x100B1AFA5ABCBED6129AB13EC11DC9543) >> 128;
937         if (x & 0x80000000000000 > 0) result = (result * 0x10058C86DA1C09EA1FF19D294CF2F679B) >> 128;
938         if (x & 0x40000000000000 > 0) result = (result * 0x1002C605E2E8CEC506D21BFC89A23A00F) >> 128;
939         if (x & 0x20000000000000 > 0) result = (result * 0x100162F3904051FA128BCA9C55C31E5DF) >> 128;
940         if (x & 0x10000000000000 > 0) result = (result * 0x1000B175EFFDC76BA38E31671CA939725) >> 128;
941         if (x & 0x8000000000000 > 0) result = (result * 0x100058BA01FB9F96D6CACD4B180917C3D) >> 128;
942         if (x & 0x4000000000000 > 0) result = (result * 0x10002C5CC37DA9491D0985C348C68E7B3) >> 128;
943         if (x & 0x2000000000000 > 0) result = (result * 0x1000162E525EE054754457D5995292026) >> 128;
944         if (x & 0x1000000000000 > 0) result = (result * 0x10000B17255775C040618BF4A4ADE83FC) >> 128;
945         if (x & 0x800000000000 > 0) result = (result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB) >> 128;
946         if (x & 0x400000000000 > 0) result = (result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9) >> 128;
947         if (x & 0x200000000000 > 0) result = (result * 0x10000162E43F4F831060E02D839A9D16D) >> 128;
948         if (x & 0x100000000000 > 0) result = (result * 0x100000B1721BCFC99D9F890EA06911763) >> 128;
949         if (x & 0x80000000000 > 0) result = (result * 0x10000058B90CF1E6D97F9CA14DBCC1628) >> 128;
950         if (x & 0x40000000000 > 0) result = (result * 0x1000002C5C863B73F016468F6BAC5CA2B) >> 128;
951         if (x & 0x20000000000 > 0) result = (result * 0x100000162E430E5A18F6119E3C02282A5) >> 128;
952         if (x & 0x10000000000 > 0) result = (result * 0x1000000B1721835514B86E6D96EFD1BFE) >> 128;
953         if (x & 0x8000000000 > 0) result = (result * 0x100000058B90C0B48C6BE5DF846C5B2EF) >> 128;
954         if (x & 0x4000000000 > 0) result = (result * 0x10000002C5C8601CC6B9E94213C72737A) >> 128;
955         if (x & 0x2000000000 > 0) result = (result * 0x1000000162E42FFF037DF38AA2B219F06) >> 128;
956         if (x & 0x1000000000 > 0) result = (result * 0x10000000B17217FBA9C739AA5819F44F9) >> 128;
957         if (x & 0x800000000 > 0) result = (result * 0x1000000058B90BFCDEE5ACD3C1CEDC823) >> 128;
958         if (x & 0x400000000 > 0) result = (result * 0x100000002C5C85FE31F35A6A30DA1BE50) >> 128;
959         if (x & 0x200000000 > 0) result = (result * 0x10000000162E42FF0999CE3541B9FFFCF) >> 128;
960         if (x & 0x100000000 > 0) result = (result * 0x100000000B17217F80F4EF5AADDA45554) >> 128;
961         if (x & 0x80000000 > 0) result = (result * 0x10000000058B90BFBF8479BD5A81B51AD) >> 128;
962         if (x & 0x40000000 > 0) result = (result * 0x1000000002C5C85FDF84BD62AE30A74CC) >> 128;
963         if (x & 0x20000000 > 0) result = (result * 0x100000000162E42FEFB2FED257559BDAA) >> 128;
964         if (x & 0x10000000 > 0) result = (result * 0x1000000000B17217F7D5A7716BBA4A9AE) >> 128;
965         if (x & 0x8000000 > 0) result = (result * 0x100000000058B90BFBE9DDBAC5E109CCE) >> 128;
966         if (x & 0x4000000 > 0) result = (result * 0x10000000002C5C85FDF4B15DE6F17EB0D) >> 128;
967         if (x & 0x2000000 > 0) result = (result * 0x1000000000162E42FEFA494F1478FDE05) >> 128;
968         if (x & 0x1000000 > 0) result = (result * 0x10000000000B17217F7D20CF927C8E94C) >> 128;
969         if (x & 0x800000 > 0) result = (result * 0x1000000000058B90BFBE8F71CB4E4B33D) >> 128;
970         if (x & 0x400000 > 0) result = (result * 0x100000000002C5C85FDF477B662B26945) >> 128;
971         if (x & 0x200000 > 0) result = (result * 0x10000000000162E42FEFA3AE53369388C) >> 128;
972         if (x & 0x100000 > 0) result = (result * 0x100000000000B17217F7D1D351A389D40) >> 128;
973         if (x & 0x80000 > 0) result = (result * 0x10000000000058B90BFBE8E8B2D3D4EDE) >> 128;
974         if (x & 0x40000 > 0) result = (result * 0x1000000000002C5C85FDF4741BEA6E77E) >> 128;
975         if (x & 0x20000 > 0) result = (result * 0x100000000000162E42FEFA39FE95583C2) >> 128;
976         if (x & 0x10000 > 0) result = (result * 0x1000000000000B17217F7D1CFB72B45E1) >> 128;
977         if (x & 0x8000 > 0) result = (result * 0x100000000000058B90BFBE8E7CC35C3F0) >> 128;
978         if (x & 0x4000 > 0) result = (result * 0x10000000000002C5C85FDF473E242EA38) >> 128;
979         if (x & 0x2000 > 0) result = (result * 0x1000000000000162E42FEFA39F02B772C) >> 128;
980         if (x & 0x1000 > 0) result = (result * 0x10000000000000B17217F7D1CF7D83C1A) >> 128;
981         if (x & 0x800 > 0) result = (result * 0x1000000000000058B90BFBE8E7BDCBE2E) >> 128;
982         if (x & 0x400 > 0) result = (result * 0x100000000000002C5C85FDF473DEA871F) >> 128;
983         if (x & 0x200 > 0) result = (result * 0x10000000000000162E42FEFA39EF44D91) >> 128;
984         if (x & 0x100 > 0) result = (result * 0x100000000000000B17217F7D1CF79E949) >> 128;
985         if (x & 0x80 > 0) result = (result * 0x10000000000000058B90BFBE8E7BCE544) >> 128;
986         if (x & 0x40 > 0) result = (result * 0x1000000000000002C5C85FDF473DE6ECA) >> 128;
987         if (x & 0x20 > 0) result = (result * 0x100000000000000162E42FEFA39EF366F) >> 128;
988         if (x & 0x10 > 0) result = (result * 0x1000000000000000B17217F7D1CF79AFA) >> 128;
989         if (x & 0x8 > 0) result = (result * 0x100000000000000058B90BFBE8E7BCD6D) >> 128;
990         if (x & 0x4 > 0) result = (result * 0x10000000000000002C5C85FDF473DE6B2) >> 128;
991         if (x & 0x2 > 0) result = (result * 0x1000000000000000162E42FEFA39EF358) >> 128;
992         if (x & 0x1 > 0) result = (result * 0x10000000000000000B17217F7D1CF79AB) >> 128;
993 
994         result >>= uint256(63 - (x >> 64));
995         require(result <= uint256(MAX_64x64));
996 
997         return int128(result);
998     }
999 
1000     /**
1001      * Calculate natural exponent of x.  Revert on overflow.
1002      *
1003      * @param x signed 64.64-bit fixed point number
1004      * @return signed 64.64-bit fixed point number
1005      */
1006     function exp(int128 x) internal pure returns (int128) {
1007         require(x < 0x400000000000000000); // Overflow
1008 
1009         if (x < -0x400000000000000000) return 0; // Underflow
1010 
1011         return exp_2(int128((int256(x) * 0x171547652B82FE1777D0FFDA0D23A7D12) >> 128));
1012     }
1013 
1014     /**
1015      * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
1016      * integer numbers.  Revert on overflow or when y is zero.
1017      *
1018      * @param x unsigned 256-bit integer number
1019      * @param y unsigned 256-bit integer number
1020      * @return unsigned 64.64-bit fixed point number
1021      */
1022     function divuu(uint256 x, uint256 y) private pure returns (uint128) {
1023         require(y != 0);
1024 
1025         uint256 result;
1026 
1027         if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) result = (x << 64) / y;
1028         else {
1029             uint256 msb = 192;
1030             uint256 xc = x >> 192;
1031             if (xc >= 0x100000000) {
1032                 xc >>= 32;
1033                 msb += 32;
1034             }
1035             if (xc >= 0x10000) {
1036                 xc >>= 16;
1037                 msb += 16;
1038             }
1039             if (xc >= 0x100) {
1040                 xc >>= 8;
1041                 msb += 8;
1042             }
1043             if (xc >= 0x10) {
1044                 xc >>= 4;
1045                 msb += 4;
1046             }
1047             if (xc >= 0x4) {
1048                 xc >>= 2;
1049                 msb += 2;
1050             }
1051             if (xc >= 0x2) msb += 1; // No need to shift xc anymore
1052 
1053             result = (x << (255 - msb)) / (((y - 1) >> (msb - 191)) + 1);
1054             require(result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1055 
1056             uint256 hi = result * (y >> 128);
1057             uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1058 
1059             uint256 xh = x >> 192;
1060             uint256 xl = x << 64;
1061 
1062             if (xl < lo) xh -= 1;
1063             xl -= lo; // We rely on overflow behavior here
1064             lo = hi << 128;
1065             if (xl < lo) xh -= 1;
1066             xl -= lo; // We rely on overflow behavior here
1067 
1068             assert(xh == hi >> 128);
1069 
1070             result += xl / y;
1071         }
1072 
1073         require(result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1074         return uint128(result);
1075     }
1076 
1077     /**
1078      * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
1079      * number.
1080      *
1081      * @param x unsigned 256-bit integer number
1082      * @return unsigned 128-bit integer number
1083      */
1084     function sqrtu(uint256 x) private pure returns (uint128) {
1085         if (x == 0) return 0;
1086         else {
1087             uint256 xx = x;
1088             uint256 r = 1;
1089             if (xx >= 0x100000000000000000000000000000000) {
1090                 xx >>= 128;
1091                 r <<= 64;
1092             }
1093             if (xx >= 0x10000000000000000) {
1094                 xx >>= 64;
1095                 r <<= 32;
1096             }
1097             if (xx >= 0x100000000) {
1098                 xx >>= 32;
1099                 r <<= 16;
1100             }
1101             if (xx >= 0x10000) {
1102                 xx >>= 16;
1103                 r <<= 8;
1104             }
1105             if (xx >= 0x100) {
1106                 xx >>= 8;
1107                 r <<= 4;
1108             }
1109             if (xx >= 0x10) {
1110                 xx >>= 4;
1111                 r <<= 2;
1112             }
1113             if (xx >= 0x8) {
1114                 r <<= 1;
1115             }
1116             r = (r + x / r) >> 1;
1117             r = (r + x / r) >> 1;
1118             r = (r + x / r) >> 1;
1119             r = (r + x / r) >> 1;
1120             r = (r + x / r) >> 1;
1121             r = (r + x / r) >> 1;
1122             r = (r + x / r) >> 1; // Seven iterations should be enough
1123             uint256 r1 = x / r;
1124             return uint128(r < r1 ? r : r1);
1125         }
1126     }
1127 }
1128 
1129 /**
1130  * Smart contract library of mathematical functions operating with IEEE 754
1131  * quadruple-precision binary floating-point numbers (quadruple precision
1132  * numbers).  As long as quadruple precision numbers are 16-bytes long, they are
1133  * represented by bytes16 type.
1134  */
1135 library ABDKMathQuad {
1136     /*
1137      * 0.
1138      */
1139     bytes16 private constant POSITIVE_ZERO = 0x00000000000000000000000000000000;
1140 
1141     /*
1142      * -0.
1143      */
1144     bytes16 private constant NEGATIVE_ZERO = 0x80000000000000000000000000000000;
1145 
1146     /*
1147      * +Infinity.
1148      */
1149     bytes16 private constant POSITIVE_INFINITY = 0x7FFF0000000000000000000000000000;
1150 
1151     /*
1152      * -Infinity.
1153      */
1154     bytes16 private constant NEGATIVE_INFINITY = 0xFFFF0000000000000000000000000000;
1155 
1156     /*
1157      * Canonical NaN value.
1158      */
1159     bytes16 private constant NaN = 0x7FFF8000000000000000000000000000;
1160 
1161     /**
1162      * Convert signed 256-bit integer number into quadruple precision number.
1163      *
1164      * @param x signed 256-bit integer number
1165      * @return quadruple precision number
1166      */
1167     function fromInt(int256 x) internal pure returns (bytes16) {
1168         if (x == 0) return bytes16(0);
1169         else {
1170             // We rely on overflow behavior here
1171             uint256 result = uint256(x > 0 ? x : -x);
1172 
1173             uint256 msb = msb(result);
1174             if (msb < 112) result <<= 112 - msb;
1175             else if (msb > 112) result >>= msb - 112;
1176 
1177             result = (result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | ((16383 + msb) << 112);
1178             if (x < 0) result |= 0x80000000000000000000000000000000;
1179 
1180             return bytes16(uint128(result));
1181         }
1182     }
1183 
1184     /**
1185      * Convert quadruple precision number into signed 256-bit integer number
1186      * rounding towards zero.  Revert on overflow.
1187      *
1188      * @param x quadruple precision number
1189      * @return signed 256-bit integer number
1190      */
1191     function toInt(bytes16 x) internal pure returns (int256) {
1192         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1193 
1194         require(exponent <= 16638); // Overflow
1195         if (exponent < 16383) return 0; // Underflow
1196 
1197         uint256 result = (uint256(uint128(x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | 0x10000000000000000000000000000;
1198 
1199         if (exponent < 16495) result >>= 16495 - exponent;
1200         else if (exponent > 16495) result <<= exponent - 16495;
1201 
1202         if (uint128(x) >= 0x80000000000000000000000000000000) {
1203             // Negative
1204             require(result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
1205             return -int256(result); // We rely on overflow behavior here
1206         } else {
1207             require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1208             return int256(result);
1209         }
1210     }
1211 
1212     /**
1213      * Convert unsigned 256-bit integer number into quadruple precision number.
1214      *
1215      * @param x unsigned 256-bit integer number
1216      * @return quadruple precision number
1217      */
1218     function fromUInt(uint256 x) internal pure returns (bytes16) {
1219         if (x == 0) return bytes16(0);
1220         else {
1221             uint256 result = x;
1222 
1223             uint256 msb = msb(result);
1224             if (msb < 112) result <<= 112 - msb;
1225             else if (msb > 112) result >>= msb - 112;
1226 
1227             result = (result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | ((16383 + msb) << 112);
1228 
1229             return bytes16(uint128(result));
1230         }
1231     }
1232 
1233     /**
1234      * Convert quadruple precision number into unsigned 256-bit integer number
1235      * rounding towards zero.  Revert on underflow.  Note, that negative floating
1236      * point numbers in range (-1.0 .. 0.0) may be converted to unsigned integer
1237      * without error, because they are rounded to zero.
1238      *
1239      * @param x quadruple precision number
1240      * @return unsigned 256-bit integer number
1241      */
1242     function toUInt(bytes16 x) internal pure returns (uint256) {
1243         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1244 
1245         if (exponent < 16383) return 0; // Underflow
1246 
1247         require(uint128(x) < 0x80000000000000000000000000000000); // Negative
1248 
1249         require(exponent <= 16638); // Overflow
1250         uint256 result = (uint256(uint128(x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | 0x10000000000000000000000000000;
1251 
1252         if (exponent < 16495) result >>= 16495 - exponent;
1253         else if (exponent > 16495) result <<= exponent - 16495;
1254 
1255         return result;
1256     }
1257 
1258     /**
1259      * Convert signed 128.128 bit fixed point number into quadruple precision
1260      * number.
1261      *
1262      * @param x signed 128.128 bit fixed point number
1263      * @return quadruple precision number
1264      */
1265     function from128x128(int256 x) internal pure returns (bytes16) {
1266         if (x == 0) return bytes16(0);
1267         else {
1268             // We rely on overflow behavior here
1269             uint256 result = uint256(x > 0 ? x : -x);
1270 
1271             uint256 msb = msb(result);
1272             if (msb < 112) result <<= 112 - msb;
1273             else if (msb > 112) result >>= msb - 112;
1274 
1275             result = (result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | ((16255 + msb) << 112);
1276             if (x < 0) result |= 0x80000000000000000000000000000000;
1277 
1278             return bytes16(uint128(result));
1279         }
1280     }
1281 
1282     /**
1283      * Convert quadruple precision number into signed 128.128 bit fixed point
1284      * number.  Revert on overflow.
1285      *
1286      * @param x quadruple precision number
1287      * @return signed 128.128 bit fixed point number
1288      */
1289     function to128x128(bytes16 x) internal pure returns (int256) {
1290         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1291 
1292         require(exponent <= 16510); // Overflow
1293         if (exponent < 16255) return 0; // Underflow
1294 
1295         uint256 result = (uint256(uint128(x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | 0x10000000000000000000000000000;
1296 
1297         if (exponent < 16367) result >>= 16367 - exponent;
1298         else if (exponent > 16367) result <<= exponent - 16367;
1299 
1300         if (uint128(x) >= 0x80000000000000000000000000000000) {
1301             // Negative
1302             require(result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
1303             return -int256(result); // We rely on overflow behavior here
1304         } else {
1305             require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1306             return int256(result);
1307         }
1308     }
1309 
1310     /**
1311      * Convert signed 64.64 bit fixed point number into quadruple precision
1312      * number.
1313      *
1314      * @param x signed 64.64 bit fixed point number
1315      * @return quadruple precision number
1316      */
1317     function from64x64(int128 x) internal pure returns (bytes16) {
1318         if (x == 0) return bytes16(0);
1319         else {
1320             // We rely on overflow behavior here
1321             uint256 result = uint128(x > 0 ? x : -x);
1322 
1323             uint256 msb = msb(result);
1324             if (msb < 112) result <<= 112 - msb;
1325             else if (msb > 112) result >>= msb - 112;
1326 
1327             result = (result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | ((16319 + msb) << 112);
1328             if (x < 0) result |= 0x80000000000000000000000000000000;
1329 
1330             return bytes16(uint128(result));
1331         }
1332     }
1333 
1334     /**
1335      * Convert quadruple precision number into signed 64.64 bit fixed point
1336      * number.  Revert on overflow.
1337      *
1338      * @param x quadruple precision number
1339      * @return signed 64.64 bit fixed point number
1340      */
1341     function to64x64(bytes16 x) internal pure returns (int128) {
1342         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1343 
1344         require(exponent <= 16446); // Overflow
1345         if (exponent < 16319) return 0; // Underflow
1346 
1347         uint256 result = (uint256(uint128(x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | 0x10000000000000000000000000000;
1348 
1349         if (exponent < 16431) result >>= 16431 - exponent;
1350         else if (exponent > 16431) result <<= exponent - 16431;
1351 
1352         if (uint128(x) >= 0x80000000000000000000000000000000) {
1353             // Negative
1354             require(result <= 0x80000000000000000000000000000000);
1355             return -int128(result); // We rely on overflow behavior here
1356         } else {
1357             require(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1358             return int128(result);
1359         }
1360     }
1361 
1362     /**
1363      * Convert octuple precision number into quadruple precision number.
1364      *
1365      * @param x octuple precision number
1366      * @return quadruple precision number
1367      */
1368     function fromOctuple(bytes32 x) internal pure returns (bytes16) {
1369         bool negative = x & 0x8000000000000000000000000000000000000000000000000000000000000000 > 0;
1370 
1371         uint256 exponent = (uint256(x) >> 236) & 0x7FFFF;
1372         uint256 significand = uint256(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1373 
1374         if (exponent == 0x7FFFF) {
1375             if (significand > 0) return NaN;
1376             else return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
1377         }
1378 
1379         if (exponent > 278526) return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
1380         else if (exponent < 245649) return negative ? NEGATIVE_ZERO : POSITIVE_ZERO;
1381         else if (exponent < 245761) {
1382             significand =
1383                 (significand | 0x100000000000000000000000000000000000000000000000000000000000) >>
1384                 (245885 - exponent);
1385             exponent = 0;
1386         } else {
1387             significand >>= 124;
1388             exponent -= 245760;
1389         }
1390 
1391         uint128 result = uint128(significand | (exponent << 112));
1392         if (negative) result |= 0x80000000000000000000000000000000;
1393 
1394         return bytes16(result);
1395     }
1396 
1397     /**
1398      * Convert quadruple precision number into octuple precision number.
1399      *
1400      * @param x quadruple precision number
1401      * @return octuple precision number
1402      */
1403     function toOctuple(bytes16 x) internal pure returns (bytes32) {
1404         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1405 
1406         uint256 result = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1407 
1408         if (exponent == 0x7FFF)
1409             exponent = 0x7FFFF; // Infinity or NaN
1410         else if (exponent == 0) {
1411             if (result > 0) {
1412                 uint256 msb = msb(result);
1413                 result = (result << (236 - msb)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1414                 exponent = 245649 + msb;
1415             }
1416         } else {
1417             result <<= 124;
1418             exponent += 245760;
1419         }
1420 
1421         result |= exponent << 236;
1422         if (uint128(x) >= 0x80000000000000000000000000000000)
1423             result |= 0x8000000000000000000000000000000000000000000000000000000000000000;
1424 
1425         return bytes32(result);
1426     }
1427 
1428     /**
1429      * Convert double precision number into quadruple precision number.
1430      *
1431      * @param x double precision number
1432      * @return quadruple precision number
1433      */
1434     function fromDouble(bytes8 x) internal pure returns (bytes16) {
1435         uint256 exponent = (uint64(x) >> 52) & 0x7FF;
1436 
1437         uint256 result = uint64(x) & 0xFFFFFFFFFFFFF;
1438 
1439         if (exponent == 0x7FF)
1440             exponent = 0x7FFF; // Infinity or NaN
1441         else if (exponent == 0) {
1442             if (result > 0) {
1443                 uint256 msb = msb(result);
1444                 result = (result << (112 - msb)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1445                 exponent = 15309 + msb;
1446             }
1447         } else {
1448             result <<= 60;
1449             exponent += 15360;
1450         }
1451 
1452         result |= exponent << 112;
1453         if (x & 0x8000000000000000 > 0) result |= 0x80000000000000000000000000000000;
1454 
1455         return bytes16(uint128(result));
1456     }
1457 
1458     /**
1459      * Convert quadruple precision number into double precision number.
1460      *
1461      * @param x quadruple precision number
1462      * @return double precision number
1463      */
1464     function toDouble(bytes16 x) internal pure returns (bytes8) {
1465         bool negative = uint128(x) >= 0x80000000000000000000000000000000;
1466 
1467         uint256 exponent = (uint128(x) >> 112) & 0x7FFF;
1468         uint256 significand = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1469 
1470         if (exponent == 0x7FFF) {
1471             if (significand > 0) return 0x7FF8000000000000;
1472             // NaN
1473             else
1474                 return
1475                     negative
1476                         ? bytes8(0xFFF0000000000000) // -Infinity
1477                         : bytes8(0x7FF0000000000000); // Infinity
1478         }
1479 
1480         if (exponent > 17406)
1481             return
1482                 negative
1483                     ? bytes8(0xFFF0000000000000) // -Infinity
1484                     : bytes8(0x7FF0000000000000);
1485         // Infinity
1486         else if (exponent < 15309)
1487             return
1488                 negative
1489                     ? bytes8(0x8000000000000000) // -0
1490                     : bytes8(0x0000000000000000);
1491         // 0
1492         else if (exponent < 15361) {
1493             significand = (significand | 0x10000000000000000000000000000) >> (15421 - exponent);
1494             exponent = 0;
1495         } else {
1496             significand >>= 60;
1497             exponent -= 15360;
1498         }
1499 
1500         uint64 result = uint64(significand | (exponent << 52));
1501         if (negative) result |= 0x8000000000000000;
1502 
1503         return bytes8(result);
1504     }
1505 
1506     /**
1507      * Test whether given quadruple precision number is NaN.
1508      *
1509      * @param x quadruple precision number
1510      * @return true if x is NaN, false otherwise
1511      */
1512     function isNaN(bytes16 x) internal pure returns (bool) {
1513         return uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF > 0x7FFF0000000000000000000000000000;
1514     }
1515 
1516     /**
1517      * Test whether given quadruple precision number is positive or negative
1518      * infinity.
1519      *
1520      * @param x quadruple precision number
1521      * @return true if x is positive or negative infinity, false otherwise
1522      */
1523     function isInfinity(bytes16 x) internal pure returns (bool) {
1524         return uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0x7FFF0000000000000000000000000000;
1525     }
1526 
1527     /**
1528      * Calculate sign of x, i.e. -1 if x is negative, 0 if x if zero, and 1 if x
1529      * is positive.  Note that sign (-0) is zero.  Revert if x is NaN.
1530      *
1531      * @param x quadruple precision number
1532      * @return sign of x
1533      */
1534     function sign(bytes16 x) internal pure returns (int8) {
1535         uint128 absoluteX = uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1536 
1537         require(absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN
1538 
1539         if (absoluteX == 0) return 0;
1540         else if (uint128(x) >= 0x80000000000000000000000000000000) return -1;
1541         else return 1;
1542     }
1543 
1544     /**
1545      * Calculate sign (x - y).  Revert if either argument is NaN, or both
1546      * arguments are infinities of the same sign.
1547      *
1548      * @param x quadruple precision number
1549      * @param y quadruple precision number
1550      * @return sign (x - y)
1551      */
1552     function cmp(bytes16 x, bytes16 y) internal pure returns (int8) {
1553         uint128 absoluteX = uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1554 
1555         require(absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN
1556 
1557         uint128 absoluteY = uint128(y) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1558 
1559         require(absoluteY <= 0x7FFF0000000000000000000000000000); // Not NaN
1560 
1561         // Not infinities of the same sign
1562         require(x != y || absoluteX < 0x7FFF0000000000000000000000000000);
1563 
1564         if (x == y) return 0;
1565         else {
1566             bool negativeX = uint128(x) >= 0x80000000000000000000000000000000;
1567             bool negativeY = uint128(y) >= 0x80000000000000000000000000000000;
1568 
1569             if (negativeX) {
1570                 if (negativeY) return absoluteX > absoluteY ? -1 : int8(1);
1571                 else return -1;
1572             } else {
1573                 if (negativeY) return 1;
1574                 else return absoluteX > absoluteY ? int8(1) : -1;
1575             }
1576         }
1577     }
1578 
1579     /**
1580      * Test whether x equals y.  NaN, infinity, and -infinity are not equal to
1581      * anything.
1582      *
1583      * @param x quadruple precision number
1584      * @param y quadruple precision number
1585      * @return true if x equals to y, false otherwise
1586      */
1587     function eq(bytes16 x, bytes16 y) internal pure returns (bool) {
1588         if (x == y) {
1589             return uint128(x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF < 0x7FFF0000000000000000000000000000;
1590         } else return false;
1591     }
1592 
1593     /**
1594      * Calculate x + y.  Special values behave in the following way:
1595      *
1596      * NaN + x = NaN for any x.
1597      * Infinity + x = Infinity for any finite x.
1598      * -Infinity + x = -Infinity for any finite x.
1599      * Infinity + Infinity = Infinity.
1600      * -Infinity + -Infinity = -Infinity.
1601      * Infinity + -Infinity = -Infinity + Infinity = NaN.
1602      *
1603      * @param x quadruple precision number
1604      * @param y quadruple precision number
1605      * @return quadruple precision number
1606      */
1607     function add(bytes16 x, bytes16 y) internal pure returns (bytes16) {
1608         uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
1609         uint256 yExponent = (uint128(y) >> 112) & 0x7FFF;
1610 
1611         if (xExponent == 0x7FFF) {
1612             if (yExponent == 0x7FFF) {
1613                 if (x == y) return x;
1614                 else return NaN;
1615             } else return x;
1616         } else if (yExponent == 0x7FFF) return y;
1617         else {
1618             bool xSign = uint128(x) >= 0x80000000000000000000000000000000;
1619             uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1620             if (xExponent == 0) xExponent = 1;
1621             else xSignifier |= 0x10000000000000000000000000000;
1622 
1623             bool ySign = uint128(y) >= 0x80000000000000000000000000000000;
1624             uint256 ySignifier = uint128(y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1625             if (yExponent == 0) yExponent = 1;
1626             else ySignifier |= 0x10000000000000000000000000000;
1627 
1628             if (xSignifier == 0) return y == NEGATIVE_ZERO ? POSITIVE_ZERO : y;
1629             else if (ySignifier == 0) return x == NEGATIVE_ZERO ? POSITIVE_ZERO : x;
1630             else {
1631                 int256 delta = int256(xExponent) - int256(yExponent);
1632 
1633                 if (xSign == ySign) {
1634                     if (delta > 112) return x;
1635                     else if (delta > 0) ySignifier >>= uint256(delta);
1636                     else if (delta < -112) return y;
1637                     else if (delta < 0) {
1638                         xSignifier >>= uint256(-delta);
1639                         xExponent = yExponent;
1640                     }
1641 
1642                     xSignifier += ySignifier;
1643 
1644                     if (xSignifier >= 0x20000000000000000000000000000) {
1645                         xSignifier >>= 1;
1646                         xExponent += 1;
1647                     }
1648 
1649                     if (xExponent == 0x7FFF) return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
1650                     else {
1651                         if (xSignifier < 0x10000000000000000000000000000) xExponent = 0;
1652                         else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1653 
1654                         return
1655                             bytes16(
1656                                 uint128(
1657                                     (xSign ? 0x80000000000000000000000000000000 : 0) | (xExponent << 112) | xSignifier
1658                                 )
1659                             );
1660                     }
1661                 } else {
1662                     if (delta > 0) {
1663                         xSignifier <<= 1;
1664                         xExponent -= 1;
1665                     } else if (delta < 0) {
1666                         ySignifier <<= 1;
1667                         xExponent = yExponent - 1;
1668                     }
1669 
1670                     if (delta > 112) ySignifier = 1;
1671                     else if (delta > 1) ySignifier = ((ySignifier - 1) >> uint256(delta - 1)) + 1;
1672                     else if (delta < -112) xSignifier = 1;
1673                     else if (delta < -1) xSignifier = ((xSignifier - 1) >> uint256(-delta - 1)) + 1;
1674 
1675                     if (xSignifier >= ySignifier) xSignifier -= ySignifier;
1676                     else {
1677                         xSignifier = ySignifier - xSignifier;
1678                         xSign = ySign;
1679                     }
1680 
1681                     if (xSignifier == 0) return POSITIVE_ZERO;
1682 
1683                     uint256 msb = msb(xSignifier);
1684 
1685                     if (msb == 113) {
1686                         xSignifier = (xSignifier >> 1) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1687                         xExponent += 1;
1688                     } else if (msb < 112) {
1689                         uint256 shift = 112 - msb;
1690                         if (xExponent > shift) {
1691                             xSignifier = (xSignifier << shift) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1692                             xExponent -= shift;
1693                         } else {
1694                             xSignifier <<= xExponent - 1;
1695                             xExponent = 0;
1696                         }
1697                     } else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1698 
1699                     if (xExponent == 0x7FFF) return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
1700                     else
1701                         return
1702                             bytes16(
1703                                 uint128(
1704                                     (xSign ? 0x80000000000000000000000000000000 : 0) | (xExponent << 112) | xSignifier
1705                                 )
1706                             );
1707                 }
1708             }
1709         }
1710     }
1711 
1712     /**
1713      * Calculate x - y.  Special values behave in the following way:
1714      *
1715      * NaN - x = NaN for any x.
1716      * Infinity - x = Infinity for any finite x.
1717      * -Infinity - x = -Infinity for any finite x.
1718      * Infinity - -Infinity = Infinity.
1719      * -Infinity - Infinity = -Infinity.
1720      * Infinity - Infinity = -Infinity - -Infinity = NaN.
1721      *
1722      * @param x quadruple precision number
1723      * @param y quadruple precision number
1724      * @return quadruple precision number
1725      */
1726     function sub(bytes16 x, bytes16 y) internal pure returns (bytes16) {
1727         return add(x, y ^ 0x80000000000000000000000000000000);
1728     }
1729 
1730     /**
1731      * Calculate x * y.  Special values behave in the following way:
1732      *
1733      * NaN * x = NaN for any x.
1734      * Infinity * x = Infinity for any finite positive x.
1735      * Infinity * x = -Infinity for any finite negative x.
1736      * -Infinity * x = -Infinity for any finite positive x.
1737      * -Infinity * x = Infinity for any finite negative x.
1738      * Infinity * 0 = NaN.
1739      * -Infinity * 0 = NaN.
1740      * Infinity * Infinity = Infinity.
1741      * Infinity * -Infinity = -Infinity.
1742      * -Infinity * Infinity = -Infinity.
1743      * -Infinity * -Infinity = Infinity.
1744      *
1745      * @param x quadruple precision number
1746      * @param y quadruple precision number
1747      * @return quadruple precision number
1748      */
1749     function mul(bytes16 x, bytes16 y) internal pure returns (bytes16) {
1750         uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
1751         uint256 yExponent = (uint128(y) >> 112) & 0x7FFF;
1752 
1753         if (xExponent == 0x7FFF) {
1754             if (yExponent == 0x7FFF) {
1755                 if (x == y) return x ^ (y & 0x80000000000000000000000000000000);
1756                 else if (x ^ y == 0x80000000000000000000000000000000) return x | y;
1757                 else return NaN;
1758             } else {
1759                 if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
1760                 else return x ^ (y & 0x80000000000000000000000000000000);
1761             }
1762         } else if (yExponent == 0x7FFF) {
1763             if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
1764             else return y ^ (x & 0x80000000000000000000000000000000);
1765         } else {
1766             uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1767             if (xExponent == 0) xExponent = 1;
1768             else xSignifier |= 0x10000000000000000000000000000;
1769 
1770             uint256 ySignifier = uint128(y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1771             if (yExponent == 0) yExponent = 1;
1772             else ySignifier |= 0x10000000000000000000000000000;
1773 
1774             xSignifier *= ySignifier;
1775             if (xSignifier == 0)
1776                 return (x ^ y) & 0x80000000000000000000000000000000 > 0 ? NEGATIVE_ZERO : POSITIVE_ZERO;
1777 
1778             xExponent += yExponent;
1779 
1780             uint256 msb = xSignifier >= 0x200000000000000000000000000000000000000000000000000000000
1781                 ? 225
1782                 : xSignifier >= 0x100000000000000000000000000000000000000000000000000000000
1783                 ? 224
1784                 : msb(xSignifier);
1785 
1786             if (xExponent + msb < 16496) {
1787                 // Underflow
1788                 xExponent = 0;
1789                 xSignifier = 0;
1790             } else if (xExponent + msb < 16608) {
1791                 // Subnormal
1792                 if (xExponent < 16496) xSignifier >>= 16496 - xExponent;
1793                 else if (xExponent > 16496) xSignifier <<= xExponent - 16496;
1794                 xExponent = 0;
1795             } else if (xExponent + msb > 49373) {
1796                 xExponent = 0x7FFF;
1797                 xSignifier = 0;
1798             } else {
1799                 if (msb > 112) xSignifier >>= msb - 112;
1800                 else if (msb < 112) xSignifier <<= 112 - msb;
1801 
1802                 xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1803 
1804                 xExponent = xExponent + msb - 16607;
1805             }
1806 
1807             return
1808                 bytes16(
1809                     uint128(uint128((x ^ y) & 0x80000000000000000000000000000000) | (xExponent << 112) | xSignifier)
1810                 );
1811         }
1812     }
1813 
1814     /**
1815      * Calculate x / y.  Special values behave in the following way:
1816      *
1817      * NaN / x = NaN for any x.
1818      * x / NaN = NaN for any x.
1819      * Infinity / x = Infinity for any finite non-negative x.
1820      * Infinity / x = -Infinity for any finite negative x including -0.
1821      * -Infinity / x = -Infinity for any finite non-negative x.
1822      * -Infinity / x = Infinity for any finite negative x including -0.
1823      * x / Infinity = 0 for any finite non-negative x.
1824      * x / -Infinity = -0 for any finite non-negative x.
1825      * x / Infinity = -0 for any finite non-negative x including -0.
1826      * x / -Infinity = 0 for any finite non-negative x including -0.
1827      *
1828      * Infinity / Infinity = NaN.
1829      * Infinity / -Infinity = -NaN.
1830      * -Infinity / Infinity = -NaN.
1831      * -Infinity / -Infinity = NaN.
1832      *
1833      * Division by zero behaves in the following way:
1834      *
1835      * x / 0 = Infinity for any finite positive x.
1836      * x / -0 = -Infinity for any finite positive x.
1837      * x / 0 = -Infinity for any finite negative x.
1838      * x / -0 = Infinity for any finite negative x.
1839      * 0 / 0 = NaN.
1840      * 0 / -0 = NaN.
1841      * -0 / 0 = NaN.
1842      * -0 / -0 = NaN.
1843      *
1844      * @param x quadruple precision number
1845      * @param y quadruple precision number
1846      * @return quadruple precision number
1847      */
1848     function div(bytes16 x, bytes16 y) internal pure returns (bytes16) {
1849         uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
1850         uint256 yExponent = (uint128(y) >> 112) & 0x7FFF;
1851 
1852         if (xExponent == 0x7FFF) {
1853             if (yExponent == 0x7FFF) return NaN;
1854             else return x ^ (y & 0x80000000000000000000000000000000);
1855         } else if (yExponent == 0x7FFF) {
1856             if (y & 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF != 0) return NaN;
1857             else return POSITIVE_ZERO | ((x ^ y) & 0x80000000000000000000000000000000);
1858         } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {
1859             if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
1860             else return POSITIVE_INFINITY | ((x ^ y) & 0x80000000000000000000000000000000);
1861         } else {
1862             uint256 ySignifier = uint128(y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1863             if (yExponent == 0) yExponent = 1;
1864             else ySignifier |= 0x10000000000000000000000000000;
1865 
1866             uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1867             if (xExponent == 0) {
1868                 if (xSignifier != 0) {
1869                     uint256 shift = 226 - msb(xSignifier);
1870 
1871                     xSignifier <<= shift;
1872 
1873                     xExponent = 1;
1874                     yExponent += shift - 114;
1875                 }
1876             } else {
1877                 xSignifier = (xSignifier | 0x10000000000000000000000000000) << 114;
1878             }
1879 
1880             xSignifier = xSignifier / ySignifier;
1881             if (xSignifier == 0)
1882                 return (x ^ y) & 0x80000000000000000000000000000000 > 0 ? NEGATIVE_ZERO : POSITIVE_ZERO;
1883 
1884             assert(xSignifier >= 0x1000000000000000000000000000);
1885 
1886             uint256 msb = xSignifier >= 0x80000000000000000000000000000
1887                 ? msb(xSignifier)
1888                 : xSignifier >= 0x40000000000000000000000000000
1889                 ? 114
1890                 : xSignifier >= 0x20000000000000000000000000000
1891                 ? 113
1892                 : 112;
1893 
1894             if (xExponent + msb > yExponent + 16497) {
1895                 // Overflow
1896                 xExponent = 0x7FFF;
1897                 xSignifier = 0;
1898             } else if (xExponent + msb + 16380 < yExponent) {
1899                 // Underflow
1900                 xExponent = 0;
1901                 xSignifier = 0;
1902             } else if (xExponent + msb + 16268 < yExponent) {
1903                 // Subnormal
1904                 if (xExponent + 16380 > yExponent) xSignifier <<= xExponent + 16380 - yExponent;
1905                 else if (xExponent + 16380 < yExponent) xSignifier >>= yExponent - xExponent - 16380;
1906 
1907                 xExponent = 0;
1908             } else {
1909                 // Normal
1910                 if (msb > 112) xSignifier >>= msb - 112;
1911 
1912                 xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1913 
1914                 xExponent = xExponent + msb + 16269 - yExponent;
1915             }
1916 
1917             return
1918                 bytes16(
1919                     uint128(uint128((x ^ y) & 0x80000000000000000000000000000000) | (xExponent << 112) | xSignifier)
1920                 );
1921         }
1922     }
1923 
1924     /**
1925      * Calculate -x.
1926      *
1927      * @param x quadruple precision number
1928      * @return quadruple precision number
1929      */
1930     function neg(bytes16 x) internal pure returns (bytes16) {
1931         return x ^ 0x80000000000000000000000000000000;
1932     }
1933 
1934     /**
1935      * Calculate |x|.
1936      *
1937      * @param x quadruple precision number
1938      * @return quadruple precision number
1939      */
1940     function abs(bytes16 x) internal pure returns (bytes16) {
1941         return x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1942     }
1943 
1944     /**
1945      * Calculate square root of x.  Return NaN on negative x excluding -0.
1946      *
1947      * @param x quadruple precision number
1948      * @return quadruple precision number
1949      */
1950     function sqrt(bytes16 x) internal pure returns (bytes16) {
1951         if (uint128(x) > 0x80000000000000000000000000000000) return NaN;
1952         else {
1953             uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
1954             if (xExponent == 0x7FFF) return x;
1955             else {
1956                 uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1957                 if (xExponent == 0) xExponent = 1;
1958                 else xSignifier |= 0x10000000000000000000000000000;
1959 
1960                 if (xSignifier == 0) return POSITIVE_ZERO;
1961 
1962                 bool oddExponent = xExponent & 0x1 == 0;
1963                 xExponent = (xExponent + 16383) >> 1;
1964 
1965                 if (oddExponent) {
1966                     if (xSignifier >= 0x10000000000000000000000000000) xSignifier <<= 113;
1967                     else {
1968                         uint256 msb = msb(xSignifier);
1969                         uint256 shift = (226 - msb) & 0xFE;
1970                         xSignifier <<= shift;
1971                         xExponent -= (shift - 112) >> 1;
1972                     }
1973                 } else {
1974                     if (xSignifier >= 0x10000000000000000000000000000) xSignifier <<= 112;
1975                     else {
1976                         uint256 msb = msb(xSignifier);
1977                         uint256 shift = (225 - msb) & 0xFE;
1978                         xSignifier <<= shift;
1979                         xExponent -= (shift - 112) >> 1;
1980                     }
1981                 }
1982 
1983                 uint256 r = 0x10000000000000000000000000000;
1984                 r = (r + xSignifier / r) >> 1;
1985                 r = (r + xSignifier / r) >> 1;
1986                 r = (r + xSignifier / r) >> 1;
1987                 r = (r + xSignifier / r) >> 1;
1988                 r = (r + xSignifier / r) >> 1;
1989                 r = (r + xSignifier / r) >> 1;
1990                 r = (r + xSignifier / r) >> 1; // Seven iterations should be enough
1991                 uint256 r1 = xSignifier / r;
1992                 if (r1 < r) r = r1;
1993 
1994                 return bytes16(uint128((xExponent << 112) | (r & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF)));
1995             }
1996         }
1997     }
1998 
1999     /**
2000      * Calculate binary logarithm of x.  Return NaN on negative x excluding -0.
2001      *
2002      * @param x quadruple precision number
2003      * @return quadruple precision number
2004      */
2005     function log_2(bytes16 x) internal pure returns (bytes16) {
2006         if (uint128(x) > 0x80000000000000000000000000000000) return NaN;
2007         else if (x == 0x3FFF0000000000000000000000000000) return POSITIVE_ZERO;
2008         else {
2009             uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
2010             if (xExponent == 0x7FFF) return x;
2011             else {
2012                 uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
2013                 if (xExponent == 0) xExponent = 1;
2014                 else xSignifier |= 0x10000000000000000000000000000;
2015 
2016                 if (xSignifier == 0) return NEGATIVE_INFINITY;
2017 
2018                 bool resultNegative;
2019                 uint256 resultExponent = 16495;
2020                 uint256 resultSignifier;
2021 
2022                 if (xExponent >= 0x3FFF) {
2023                     resultNegative = false;
2024                     resultSignifier = xExponent - 0x3FFF;
2025                     xSignifier <<= 15;
2026                 } else {
2027                     resultNegative = true;
2028                     if (xSignifier >= 0x10000000000000000000000000000) {
2029                         resultSignifier = 0x3FFE - xExponent;
2030                         xSignifier <<= 15;
2031                     } else {
2032                         uint256 msb = msb(xSignifier);
2033                         resultSignifier = 16493 - msb;
2034                         xSignifier <<= 127 - msb;
2035                     }
2036                 }
2037 
2038                 if (xSignifier == 0x80000000000000000000000000000000) {
2039                     if (resultNegative) resultSignifier += 1;
2040                     uint256 shift = 112 - msb(resultSignifier);
2041                     resultSignifier <<= shift;
2042                     resultExponent -= shift;
2043                 } else {
2044                     uint256 bb = resultNegative ? 1 : 0;
2045                     while (resultSignifier < 0x10000000000000000000000000000) {
2046                         resultSignifier <<= 1;
2047                         resultExponent -= 1;
2048 
2049                         xSignifier *= xSignifier;
2050                         uint256 b = xSignifier >> 255;
2051                         resultSignifier += b ^ bb;
2052                         xSignifier >>= 127 + b;
2053                     }
2054                 }
2055 
2056                 return
2057                     bytes16(
2058                         uint128(
2059                             (resultNegative ? 0x80000000000000000000000000000000 : 0) |
2060                                 (resultExponent << 112) |
2061                                 (resultSignifier & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2062                         )
2063                     );
2064             }
2065         }
2066     }
2067 
2068     /**
2069      * Calculate natural logarithm of x.  Return NaN on negative x excluding -0.
2070      *
2071      * @param x quadruple precision number
2072      * @return quadruple precision number
2073      */
2074     function ln(bytes16 x) internal pure returns (bytes16) {
2075         return mul(log_2(x), 0x3FFE62E42FEFA39EF35793C7673007E5);
2076     }
2077 
2078     /**
2079      * Calculate 2^x.
2080      *
2081      * @param x quadruple precision number
2082      * @return quadruple precision number
2083      */
2084     function pow_2(bytes16 x) internal pure returns (bytes16) {
2085         bool xNegative = uint128(x) > 0x80000000000000000000000000000000;
2086         uint256 xExponent = (uint128(x) >> 112) & 0x7FFF;
2087         uint256 xSignifier = uint128(x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
2088 
2089         if (xExponent == 0x7FFF && xSignifier != 0) return NaN;
2090         else if (xExponent > 16397) return xNegative ? POSITIVE_ZERO : POSITIVE_INFINITY;
2091         else if (xExponent < 16255) return 0x3FFF0000000000000000000000000000;
2092         else {
2093             if (xExponent == 0) xExponent = 1;
2094             else xSignifier |= 0x10000000000000000000000000000;
2095 
2096             if (xExponent > 16367) xSignifier <<= xExponent - 16367;
2097             else if (xExponent < 16367) xSignifier >>= 16367 - xExponent;
2098 
2099             if (xNegative && xSignifier > 0x406E00000000000000000000000000000000) return POSITIVE_ZERO;
2100 
2101             if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) return POSITIVE_INFINITY;
2102 
2103             uint256 resultExponent = xSignifier >> 128;
2104             xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
2105             if (xNegative && xSignifier != 0) {
2106                 xSignifier = ~xSignifier;
2107                 resultExponent += 1;
2108             }
2109 
2110             uint256 resultSignifier = 0x80000000000000000000000000000000;
2111             if (xSignifier & 0x80000000000000000000000000000000 > 0)
2112                 resultSignifier = (resultSignifier * 0x16A09E667F3BCC908B2FB1366EA957D3E) >> 128;
2113             if (xSignifier & 0x40000000000000000000000000000000 > 0)
2114                 resultSignifier = (resultSignifier * 0x1306FE0A31B7152DE8D5A46305C85EDEC) >> 128;
2115             if (xSignifier & 0x20000000000000000000000000000000 > 0)
2116                 resultSignifier = (resultSignifier * 0x1172B83C7D517ADCDF7C8C50EB14A791F) >> 128;
2117             if (xSignifier & 0x10000000000000000000000000000000 > 0)
2118                 resultSignifier = (resultSignifier * 0x10B5586CF9890F6298B92B71842A98363) >> 128;
2119             if (xSignifier & 0x8000000000000000000000000000000 > 0)
2120                 resultSignifier = (resultSignifier * 0x1059B0D31585743AE7C548EB68CA417FD) >> 128;
2121             if (xSignifier & 0x4000000000000000000000000000000 > 0)
2122                 resultSignifier = (resultSignifier * 0x102C9A3E778060EE6F7CACA4F7A29BDE8) >> 128;
2123             if (xSignifier & 0x2000000000000000000000000000000 > 0)
2124                 resultSignifier = (resultSignifier * 0x10163DA9FB33356D84A66AE336DCDFA3F) >> 128;
2125             if (xSignifier & 0x1000000000000000000000000000000 > 0)
2126                 resultSignifier = (resultSignifier * 0x100B1AFA5ABCBED6129AB13EC11DC9543) >> 128;
2127             if (xSignifier & 0x800000000000000000000000000000 > 0)
2128                 resultSignifier = (resultSignifier * 0x10058C86DA1C09EA1FF19D294CF2F679B) >> 128;
2129             if (xSignifier & 0x400000000000000000000000000000 > 0)
2130                 resultSignifier = (resultSignifier * 0x1002C605E2E8CEC506D21BFC89A23A00F) >> 128;
2131             if (xSignifier & 0x200000000000000000000000000000 > 0)
2132                 resultSignifier = (resultSignifier * 0x100162F3904051FA128BCA9C55C31E5DF) >> 128;
2133             if (xSignifier & 0x100000000000000000000000000000 > 0)
2134                 resultSignifier = (resultSignifier * 0x1000B175EFFDC76BA38E31671CA939725) >> 128;
2135             if (xSignifier & 0x80000000000000000000000000000 > 0)
2136                 resultSignifier = (resultSignifier * 0x100058BA01FB9F96D6CACD4B180917C3D) >> 128;
2137             if (xSignifier & 0x40000000000000000000000000000 > 0)
2138                 resultSignifier = (resultSignifier * 0x10002C5CC37DA9491D0985C348C68E7B3) >> 128;
2139             if (xSignifier & 0x20000000000000000000000000000 > 0)
2140                 resultSignifier = (resultSignifier * 0x1000162E525EE054754457D5995292026) >> 128;
2141             if (xSignifier & 0x10000000000000000000000000000 > 0)
2142                 resultSignifier = (resultSignifier * 0x10000B17255775C040618BF4A4ADE83FC) >> 128;
2143             if (xSignifier & 0x8000000000000000000000000000 > 0)
2144                 resultSignifier = (resultSignifier * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB) >> 128;
2145             if (xSignifier & 0x4000000000000000000000000000 > 0)
2146                 resultSignifier = (resultSignifier * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9) >> 128;
2147             if (xSignifier & 0x2000000000000000000000000000 > 0)
2148                 resultSignifier = (resultSignifier * 0x10000162E43F4F831060E02D839A9D16D) >> 128;
2149             if (xSignifier & 0x1000000000000000000000000000 > 0)
2150                 resultSignifier = (resultSignifier * 0x100000B1721BCFC99D9F890EA06911763) >> 128;
2151             if (xSignifier & 0x800000000000000000000000000 > 0)
2152                 resultSignifier = (resultSignifier * 0x10000058B90CF1E6D97F9CA14DBCC1628) >> 128;
2153             if (xSignifier & 0x400000000000000000000000000 > 0)
2154                 resultSignifier = (resultSignifier * 0x1000002C5C863B73F016468F6BAC5CA2B) >> 128;
2155             if (xSignifier & 0x200000000000000000000000000 > 0)
2156                 resultSignifier = (resultSignifier * 0x100000162E430E5A18F6119E3C02282A5) >> 128;
2157             if (xSignifier & 0x100000000000000000000000000 > 0)
2158                 resultSignifier = (resultSignifier * 0x1000000B1721835514B86E6D96EFD1BFE) >> 128;
2159             if (xSignifier & 0x80000000000000000000000000 > 0)
2160                 resultSignifier = (resultSignifier * 0x100000058B90C0B48C6BE5DF846C5B2EF) >> 128;
2161             if (xSignifier & 0x40000000000000000000000000 > 0)
2162                 resultSignifier = (resultSignifier * 0x10000002C5C8601CC6B9E94213C72737A) >> 128;
2163             if (xSignifier & 0x20000000000000000000000000 > 0)
2164                 resultSignifier = (resultSignifier * 0x1000000162E42FFF037DF38AA2B219F06) >> 128;
2165             if (xSignifier & 0x10000000000000000000000000 > 0)
2166                 resultSignifier = (resultSignifier * 0x10000000B17217FBA9C739AA5819F44F9) >> 128;
2167             if (xSignifier & 0x8000000000000000000000000 > 0)
2168                 resultSignifier = (resultSignifier * 0x1000000058B90BFCDEE5ACD3C1CEDC823) >> 128;
2169             if (xSignifier & 0x4000000000000000000000000 > 0)
2170                 resultSignifier = (resultSignifier * 0x100000002C5C85FE31F35A6A30DA1BE50) >> 128;
2171             if (xSignifier & 0x2000000000000000000000000 > 0)
2172                 resultSignifier = (resultSignifier * 0x10000000162E42FF0999CE3541B9FFFCF) >> 128;
2173             if (xSignifier & 0x1000000000000000000000000 > 0)
2174                 resultSignifier = (resultSignifier * 0x100000000B17217F80F4EF5AADDA45554) >> 128;
2175             if (xSignifier & 0x800000000000000000000000 > 0)
2176                 resultSignifier = (resultSignifier * 0x10000000058B90BFBF8479BD5A81B51AD) >> 128;
2177             if (xSignifier & 0x400000000000000000000000 > 0)
2178                 resultSignifier = (resultSignifier * 0x1000000002C5C85FDF84BD62AE30A74CC) >> 128;
2179             if (xSignifier & 0x200000000000000000000000 > 0)
2180                 resultSignifier = (resultSignifier * 0x100000000162E42FEFB2FED257559BDAA) >> 128;
2181             if (xSignifier & 0x100000000000000000000000 > 0)
2182                 resultSignifier = (resultSignifier * 0x1000000000B17217F7D5A7716BBA4A9AE) >> 128;
2183             if (xSignifier & 0x80000000000000000000000 > 0)
2184                 resultSignifier = (resultSignifier * 0x100000000058B90BFBE9DDBAC5E109CCE) >> 128;
2185             if (xSignifier & 0x40000000000000000000000 > 0)
2186                 resultSignifier = (resultSignifier * 0x10000000002C5C85FDF4B15DE6F17EB0D) >> 128;
2187             if (xSignifier & 0x20000000000000000000000 > 0)
2188                 resultSignifier = (resultSignifier * 0x1000000000162E42FEFA494F1478FDE05) >> 128;
2189             if (xSignifier & 0x10000000000000000000000 > 0)
2190                 resultSignifier = (resultSignifier * 0x10000000000B17217F7D20CF927C8E94C) >> 128;
2191             if (xSignifier & 0x8000000000000000000000 > 0)
2192                 resultSignifier = (resultSignifier * 0x1000000000058B90BFBE8F71CB4E4B33D) >> 128;
2193             if (xSignifier & 0x4000000000000000000000 > 0)
2194                 resultSignifier = (resultSignifier * 0x100000000002C5C85FDF477B662B26945) >> 128;
2195             if (xSignifier & 0x2000000000000000000000 > 0)
2196                 resultSignifier = (resultSignifier * 0x10000000000162E42FEFA3AE53369388C) >> 128;
2197             if (xSignifier & 0x1000000000000000000000 > 0)
2198                 resultSignifier = (resultSignifier * 0x100000000000B17217F7D1D351A389D40) >> 128;
2199             if (xSignifier & 0x800000000000000000000 > 0)
2200                 resultSignifier = (resultSignifier * 0x10000000000058B90BFBE8E8B2D3D4EDE) >> 128;
2201             if (xSignifier & 0x400000000000000000000 > 0)
2202                 resultSignifier = (resultSignifier * 0x1000000000002C5C85FDF4741BEA6E77E) >> 128;
2203             if (xSignifier & 0x200000000000000000000 > 0)
2204                 resultSignifier = (resultSignifier * 0x100000000000162E42FEFA39FE95583C2) >> 128;
2205             if (xSignifier & 0x100000000000000000000 > 0)
2206                 resultSignifier = (resultSignifier * 0x1000000000000B17217F7D1CFB72B45E1) >> 128;
2207             if (xSignifier & 0x80000000000000000000 > 0)
2208                 resultSignifier = (resultSignifier * 0x100000000000058B90BFBE8E7CC35C3F0) >> 128;
2209             if (xSignifier & 0x40000000000000000000 > 0)
2210                 resultSignifier = (resultSignifier * 0x10000000000002C5C85FDF473E242EA38) >> 128;
2211             if (xSignifier & 0x20000000000000000000 > 0)
2212                 resultSignifier = (resultSignifier * 0x1000000000000162E42FEFA39F02B772C) >> 128;
2213             if (xSignifier & 0x10000000000000000000 > 0)
2214                 resultSignifier = (resultSignifier * 0x10000000000000B17217F7D1CF7D83C1A) >> 128;
2215             if (xSignifier & 0x8000000000000000000 > 0)
2216                 resultSignifier = (resultSignifier * 0x1000000000000058B90BFBE8E7BDCBE2E) >> 128;
2217             if (xSignifier & 0x4000000000000000000 > 0)
2218                 resultSignifier = (resultSignifier * 0x100000000000002C5C85FDF473DEA871F) >> 128;
2219             if (xSignifier & 0x2000000000000000000 > 0)
2220                 resultSignifier = (resultSignifier * 0x10000000000000162E42FEFA39EF44D91) >> 128;
2221             if (xSignifier & 0x1000000000000000000 > 0)
2222                 resultSignifier = (resultSignifier * 0x100000000000000B17217F7D1CF79E949) >> 128;
2223             if (xSignifier & 0x800000000000000000 > 0)
2224                 resultSignifier = (resultSignifier * 0x10000000000000058B90BFBE8E7BCE544) >> 128;
2225             if (xSignifier & 0x400000000000000000 > 0)
2226                 resultSignifier = (resultSignifier * 0x1000000000000002C5C85FDF473DE6ECA) >> 128;
2227             if (xSignifier & 0x200000000000000000 > 0)
2228                 resultSignifier = (resultSignifier * 0x100000000000000162E42FEFA39EF366F) >> 128;
2229             if (xSignifier & 0x100000000000000000 > 0)
2230                 resultSignifier = (resultSignifier * 0x1000000000000000B17217F7D1CF79AFA) >> 128;
2231             if (xSignifier & 0x80000000000000000 > 0)
2232                 resultSignifier = (resultSignifier * 0x100000000000000058B90BFBE8E7BCD6D) >> 128;
2233             if (xSignifier & 0x40000000000000000 > 0)
2234                 resultSignifier = (resultSignifier * 0x10000000000000002C5C85FDF473DE6B2) >> 128;
2235             if (xSignifier & 0x20000000000000000 > 0)
2236                 resultSignifier = (resultSignifier * 0x1000000000000000162E42FEFA39EF358) >> 128;
2237             if (xSignifier & 0x10000000000000000 > 0)
2238                 resultSignifier = (resultSignifier * 0x10000000000000000B17217F7D1CF79AB) >> 128;
2239             if (xSignifier & 0x8000000000000000 > 0)
2240                 resultSignifier = (resultSignifier * 0x1000000000000000058B90BFBE8E7BCD5) >> 128;
2241             if (xSignifier & 0x4000000000000000 > 0)
2242                 resultSignifier = (resultSignifier * 0x100000000000000002C5C85FDF473DE6A) >> 128;
2243             if (xSignifier & 0x2000000000000000 > 0)
2244                 resultSignifier = (resultSignifier * 0x10000000000000000162E42FEFA39EF34) >> 128;
2245             if (xSignifier & 0x1000000000000000 > 0)
2246                 resultSignifier = (resultSignifier * 0x100000000000000000B17217F7D1CF799) >> 128;
2247             if (xSignifier & 0x800000000000000 > 0)
2248                 resultSignifier = (resultSignifier * 0x10000000000000000058B90BFBE8E7BCC) >> 128;
2249             if (xSignifier & 0x400000000000000 > 0)
2250                 resultSignifier = (resultSignifier * 0x1000000000000000002C5C85FDF473DE5) >> 128;
2251             if (xSignifier & 0x200000000000000 > 0)
2252                 resultSignifier = (resultSignifier * 0x100000000000000000162E42FEFA39EF2) >> 128;
2253             if (xSignifier & 0x100000000000000 > 0)
2254                 resultSignifier = (resultSignifier * 0x1000000000000000000B17217F7D1CF78) >> 128;
2255             if (xSignifier & 0x80000000000000 > 0)
2256                 resultSignifier = (resultSignifier * 0x100000000000000000058B90BFBE8E7BB) >> 128;
2257             if (xSignifier & 0x40000000000000 > 0)
2258                 resultSignifier = (resultSignifier * 0x10000000000000000002C5C85FDF473DD) >> 128;
2259             if (xSignifier & 0x20000000000000 > 0)
2260                 resultSignifier = (resultSignifier * 0x1000000000000000000162E42FEFA39EE) >> 128;
2261             if (xSignifier & 0x10000000000000 > 0)
2262                 resultSignifier = (resultSignifier * 0x10000000000000000000B17217F7D1CF6) >> 128;
2263             if (xSignifier & 0x8000000000000 > 0)
2264                 resultSignifier = (resultSignifier * 0x1000000000000000000058B90BFBE8E7A) >> 128;
2265             if (xSignifier & 0x4000000000000 > 0)
2266                 resultSignifier = (resultSignifier * 0x100000000000000000002C5C85FDF473C) >> 128;
2267             if (xSignifier & 0x2000000000000 > 0)
2268                 resultSignifier = (resultSignifier * 0x10000000000000000000162E42FEFA39D) >> 128;
2269             if (xSignifier & 0x1000000000000 > 0)
2270                 resultSignifier = (resultSignifier * 0x100000000000000000000B17217F7D1CE) >> 128;
2271             if (xSignifier & 0x800000000000 > 0)
2272                 resultSignifier = (resultSignifier * 0x10000000000000000000058B90BFBE8E6) >> 128;
2273             if (xSignifier & 0x400000000000 > 0)
2274                 resultSignifier = (resultSignifier * 0x1000000000000000000002C5C85FDF472) >> 128;
2275             if (xSignifier & 0x200000000000 > 0)
2276                 resultSignifier = (resultSignifier * 0x100000000000000000000162E42FEFA38) >> 128;
2277             if (xSignifier & 0x100000000000 > 0)
2278                 resultSignifier = (resultSignifier * 0x1000000000000000000000B17217F7D1B) >> 128;
2279             if (xSignifier & 0x80000000000 > 0)
2280                 resultSignifier = (resultSignifier * 0x100000000000000000000058B90BFBE8D) >> 128;
2281             if (xSignifier & 0x40000000000 > 0)
2282                 resultSignifier = (resultSignifier * 0x10000000000000000000002C5C85FDF46) >> 128;
2283             if (xSignifier & 0x20000000000 > 0)
2284                 resultSignifier = (resultSignifier * 0x1000000000000000000000162E42FEFA2) >> 128;
2285             if (xSignifier & 0x10000000000 > 0)
2286                 resultSignifier = (resultSignifier * 0x10000000000000000000000B17217F7D0) >> 128;
2287             if (xSignifier & 0x8000000000 > 0)
2288                 resultSignifier = (resultSignifier * 0x1000000000000000000000058B90BFBE7) >> 128;
2289             if (xSignifier & 0x4000000000 > 0)
2290                 resultSignifier = (resultSignifier * 0x100000000000000000000002C5C85FDF3) >> 128;
2291             if (xSignifier & 0x2000000000 > 0)
2292                 resultSignifier = (resultSignifier * 0x10000000000000000000000162E42FEF9) >> 128;
2293             if (xSignifier & 0x1000000000 > 0)
2294                 resultSignifier = (resultSignifier * 0x100000000000000000000000B17217F7C) >> 128;
2295             if (xSignifier & 0x800000000 > 0)
2296                 resultSignifier = (resultSignifier * 0x10000000000000000000000058B90BFBD) >> 128;
2297             if (xSignifier & 0x400000000 > 0)
2298                 resultSignifier = (resultSignifier * 0x1000000000000000000000002C5C85FDE) >> 128;
2299             if (xSignifier & 0x200000000 > 0)
2300                 resultSignifier = (resultSignifier * 0x100000000000000000000000162E42FEE) >> 128;
2301             if (xSignifier & 0x100000000 > 0)
2302                 resultSignifier = (resultSignifier * 0x1000000000000000000000000B17217F6) >> 128;
2303             if (xSignifier & 0x80000000 > 0)
2304                 resultSignifier = (resultSignifier * 0x100000000000000000000000058B90BFA) >> 128;
2305             if (xSignifier & 0x40000000 > 0)
2306                 resultSignifier = (resultSignifier * 0x10000000000000000000000002C5C85FC) >> 128;
2307             if (xSignifier & 0x20000000 > 0)
2308                 resultSignifier = (resultSignifier * 0x1000000000000000000000000162E42FD) >> 128;
2309             if (xSignifier & 0x10000000 > 0)
2310                 resultSignifier = (resultSignifier * 0x10000000000000000000000000B17217E) >> 128;
2311             if (xSignifier & 0x8000000 > 0)
2312                 resultSignifier = (resultSignifier * 0x1000000000000000000000000058B90BE) >> 128;
2313             if (xSignifier & 0x4000000 > 0)
2314                 resultSignifier = (resultSignifier * 0x100000000000000000000000002C5C85E) >> 128;
2315             if (xSignifier & 0x2000000 > 0)
2316                 resultSignifier = (resultSignifier * 0x10000000000000000000000000162E42E) >> 128;
2317             if (xSignifier & 0x1000000 > 0)
2318                 resultSignifier = (resultSignifier * 0x100000000000000000000000000B17216) >> 128;
2319             if (xSignifier & 0x800000 > 0)
2320                 resultSignifier = (resultSignifier * 0x10000000000000000000000000058B90A) >> 128;
2321             if (xSignifier & 0x400000 > 0)
2322                 resultSignifier = (resultSignifier * 0x1000000000000000000000000002C5C84) >> 128;
2323             if (xSignifier & 0x200000 > 0)
2324                 resultSignifier = (resultSignifier * 0x100000000000000000000000000162E41) >> 128;
2325             if (xSignifier & 0x100000 > 0)
2326                 resultSignifier = (resultSignifier * 0x1000000000000000000000000000B1720) >> 128;
2327             if (xSignifier & 0x80000 > 0)
2328                 resultSignifier = (resultSignifier * 0x100000000000000000000000000058B8F) >> 128;
2329             if (xSignifier & 0x40000 > 0)
2330                 resultSignifier = (resultSignifier * 0x10000000000000000000000000002C5C7) >> 128;
2331             if (xSignifier & 0x20000 > 0)
2332                 resultSignifier = (resultSignifier * 0x1000000000000000000000000000162E3) >> 128;
2333             if (xSignifier & 0x10000 > 0)
2334                 resultSignifier = (resultSignifier * 0x10000000000000000000000000000B171) >> 128;
2335             if (xSignifier & 0x8000 > 0)
2336                 resultSignifier = (resultSignifier * 0x1000000000000000000000000000058B8) >> 128;
2337             if (xSignifier & 0x4000 > 0)
2338                 resultSignifier = (resultSignifier * 0x100000000000000000000000000002C5B) >> 128;
2339             if (xSignifier & 0x2000 > 0)
2340                 resultSignifier = (resultSignifier * 0x10000000000000000000000000000162D) >> 128;
2341             if (xSignifier & 0x1000 > 0)
2342                 resultSignifier = (resultSignifier * 0x100000000000000000000000000000B16) >> 128;
2343             if (xSignifier & 0x800 > 0)
2344                 resultSignifier = (resultSignifier * 0x10000000000000000000000000000058A) >> 128;
2345             if (xSignifier & 0x400 > 0)
2346                 resultSignifier = (resultSignifier * 0x1000000000000000000000000000002C4) >> 128;
2347             if (xSignifier & 0x200 > 0)
2348                 resultSignifier = (resultSignifier * 0x100000000000000000000000000000161) >> 128;
2349             if (xSignifier & 0x100 > 0)
2350                 resultSignifier = (resultSignifier * 0x1000000000000000000000000000000B0) >> 128;
2351             if (xSignifier & 0x80 > 0) resultSignifier = (resultSignifier * 0x100000000000000000000000000000057) >> 128;
2352             if (xSignifier & 0x40 > 0) resultSignifier = (resultSignifier * 0x10000000000000000000000000000002B) >> 128;
2353             if (xSignifier & 0x20 > 0) resultSignifier = (resultSignifier * 0x100000000000000000000000000000015) >> 128;
2354             if (xSignifier & 0x10 > 0) resultSignifier = (resultSignifier * 0x10000000000000000000000000000000A) >> 128;
2355             if (xSignifier & 0x8 > 0) resultSignifier = (resultSignifier * 0x100000000000000000000000000000004) >> 128;
2356             if (xSignifier & 0x4 > 0) resultSignifier = (resultSignifier * 0x100000000000000000000000000000001) >> 128;
2357 
2358             if (!xNegative) {
2359                 resultSignifier = (resultSignifier >> 15) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
2360                 resultExponent += 0x3FFF;
2361             } else if (resultExponent <= 0x3FFE) {
2362                 resultSignifier = (resultSignifier >> 15) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
2363                 resultExponent = 0x3FFF - resultExponent;
2364             } else {
2365                 resultSignifier = resultSignifier >> (resultExponent - 16367);
2366                 resultExponent = 0;
2367             }
2368 
2369             return bytes16(uint128((resultExponent << 112) | resultSignifier));
2370         }
2371     }
2372 
2373     /**
2374      * Calculate e^x.
2375      *
2376      * @param x quadruple precision number
2377      * @return quadruple precision number
2378      */
2379     function exp(bytes16 x) internal pure returns (bytes16) {
2380         return pow_2(mul(x, 0x3FFF71547652B82FE1777D0FFDA0D23A));
2381     }
2382 
2383     /**
2384      * Get index of the most significant non-zero bit in binary representation of
2385      * x.  Reverts if x is zero.
2386      *
2387      * @return index of the most significant non-zero bit in binary representation
2388      *         of x
2389      */
2390     function msb(uint256 x) private pure returns (uint256) {
2391         require(x > 0);
2392 
2393         uint256 result = 0;
2394 
2395         if (x >= 0x100000000000000000000000000000000) {
2396             x >>= 128;
2397             result += 128;
2398         }
2399         if (x >= 0x10000000000000000) {
2400             x >>= 64;
2401             result += 64;
2402         }
2403         if (x >= 0x100000000) {
2404             x >>= 32;
2405             result += 32;
2406         }
2407         if (x >= 0x10000) {
2408             x >>= 16;
2409             result += 16;
2410         }
2411         if (x >= 0x100) {
2412             x >>= 8;
2413             result += 8;
2414         }
2415         if (x >= 0x10) {
2416             x >>= 4;
2417             result += 4;
2418         }
2419         if (x >= 0x4) {
2420             x >>= 2;
2421             result += 2;
2422         }
2423         if (x >= 0x2) result += 1; // No need to shift x anymore
2424 
2425         return result;
2426     }
2427 }
2428 
2429 
2430 // CONTRACTS
2431 
2432 /**
2433  * @title Initializable
2434  *
2435  * @dev Helper contract to support initializer functions. To use it, replace
2436  * the constructor with a function that has the `initializer` modifier.
2437  * WARNING: Unlike constructors, initializer functions must be manually
2438  * invoked. This applies both to deploying an Initializable contract, as well
2439  * as extending an Initializable contract via inheritance.
2440  * WARNING: When used with inheritance, manual care must be taken to not invoke
2441  * a parent initializer twice, or ensure that all initializers are idempotent,
2442  * because this is not dealt with automatically as with constructors.
2443  */
2444 contract Initializable {
2445     /**
2446      * @dev Indicates that the contract has been initialized.
2447      */
2448     bool private initialized;
2449 
2450     /**
2451      * @dev Indicates that the contract is in the process of being initialized.
2452      */
2453     bool private initializing;
2454 
2455     /**
2456      * @dev Modifier to use in the initializer function of a contract.
2457      */
2458     modifier initializer() {
2459         require(
2460             initializing || isConstructor() || !initialized,
2461             "Contract instance has already been initialized"
2462         );
2463 
2464         bool isTopLevelCall = !initializing;
2465         if (isTopLevelCall) {
2466             initializing = true;
2467             initialized = true;
2468         }
2469 
2470         _;
2471 
2472         if (isTopLevelCall) {
2473             initializing = false;
2474         }
2475     }
2476 
2477     /// @dev Returns true if and only if the function is running in the constructor
2478     function isConstructor() private view returns (bool) {
2479         // extcodesize checks the size of the code stored in an address, and
2480         // address returns the current address. Since the code is still not
2481         // deployed when running a constructor, any checks on its code size will
2482         // yield zero, making it an effective way to detect if a contract is
2483         // under construction or not.
2484         address self = address(this);
2485         uint256 cs;
2486         assembly {
2487             cs := extcodesize(self)
2488         }
2489         return cs == 0;
2490     }
2491 
2492     // Reserved storage space to allow for layout changes in the future.
2493     uint256[50] private ______gap;
2494 }
2495 
2496 contract Sacrifice {
2497     constructor(address payable _recipient) public payable {
2498         selfdestruct(_recipient);
2499     }
2500 }
2501 
2502 /**
2503  * @dev Contract module that helps prevent reentrant calls to a function.
2504  *
2505  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2506  * available, which can be applied to functions to make sure there are no nested
2507  * (reentrant) calls to them.
2508  *
2509  * Note that because there is a single `nonReentrant` guard, functions marked as
2510  * `nonReentrant` may not call one another. This can be worked around by making
2511  * those functions `private`, and then adding `external` `nonReentrant` entry
2512  * points to them.
2513  */
2514 contract ReentrancyGuard is Initializable {
2515     // counter to allow mutex lock with only one SSTORE operation
2516     uint256 private _guardCounter;
2517 
2518     function initialize() public initializer {
2519         // The counter starts at one to prevent changing it from zero to a non-zero
2520         // value, which is a more expensive operation.
2521         _guardCounter = 1;
2522     }
2523 
2524     /**
2525      * @dev Prevents a contract from calling itself, directly or indirectly.
2526      * Calling a `nonReentrant` function from another `nonReentrant`
2527      * function is not supported. It is possible to prevent this from happening
2528      * by making the `nonReentrant` function external, and make it call a
2529      * `private` function that does the actual work.
2530      */
2531     modifier nonReentrant() {
2532         _guardCounter += 1;
2533         uint256 localCounter = _guardCounter;
2534         _;
2535         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
2536     }
2537 
2538     uint256[50] private ______gap;
2539 }
2540 
2541 
2542 // ----------------------------------------------------------------------------
2543 // ERC Token Standard #20 Interface
2544 // ----------------------------------------------------------------------------
2545 contract ERC20Interface {
2546     function totalSupply() public view returns (uint256);
2547 
2548     function balanceOf(address tokenOwner) public view returns (uint256 balance);
2549 
2550     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
2551 
2552     function transfer(address to, uint256 tokens) public returns (bool success);
2553 
2554     function approve(address spender, uint256 tokens) public returns (bool success);
2555 
2556     function transferFrom(
2557         address from,
2558         address to,
2559         uint256 tokens
2560     ) public returns (bool success);
2561 
2562     event Transfer(address indexed from, address indexed to, uint256 tokens);
2563     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
2564 }
2565 
2566 // ----------------------------------------------------------------------------
2567 // Safe Math Library
2568 // ----------------------------------------------------------------------------
2569 
2570 contract SafeMathERC20 {
2571     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
2572         c = a + b;
2573         require(c >= a);
2574     }
2575 
2576     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
2577         require(b <= a);
2578         c = a - b;
2579     }
2580 
2581     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
2582         c = a * b;
2583         require(a == 0 || c / a == b);
2584     }
2585 
2586     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
2587         require(b > 0);
2588         c = a / b;
2589     }
2590 }
2591 
2592 
2593 /*
2594  * @dev Provides information about the current execution context, including the
2595  * sender of the transaction and its data. While these are generally available
2596  * via msg.sender and msg.data, they should not be accessed in such a direct
2597  * manner, since when dealing with GSN meta-transactions the account sending and
2598  * paying for execution may not be the actual sender (as far as an application
2599  * is concerned).
2600  *
2601  * This contract is only required for intermediate, library-like contracts.
2602  */
2603 contract Context is Initializable {
2604     // Empty internal constructor, to prevent people from mistakenly deploying
2605     // an instance of this contract, which should be used via inheritance.
2606     constructor() internal {}
2607 
2608     // solhint-disable-previous-line no-empty-blocks
2609 
2610     function _msgSender() internal view returns (address payable) {
2611         return msg.sender;
2612     }
2613 
2614     function _msgData() internal view returns (bytes memory) {
2615         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
2616         return msg.data;
2617     }
2618 }
2619 
2620 
2621 /*
2622  * @dev Provides information about the current execution context, including the
2623  * sender of the transaction and its data. While these are generally available
2624  * via msg.sender and msg.data, they should not be accessed in such a direct
2625  * manner, since when dealing with GSN meta-transactions the account sending and
2626  * paying for execution may not be the actual sender (as far as an application
2627  * is concerned).
2628  *
2629  * This contract is only required for intermediate, library-like contracts.
2630  */
2631 
2632 
2633 /**
2634  * @dev Contract module which provides a basic access control mechanism, where
2635  * there is an account (an owner) that can be granted exclusive access to
2636  * specific functions.
2637  *
2638  * This module is used through inheritance. It will make available the modifier
2639  * `onlyOwner`, which can be applied to your functions to restrict their use to
2640  * the owner.
2641  */
2642 contract Ownable is Initializable, Context {
2643     address private _owner;
2644 
2645     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2646 
2647     /**
2648      * @dev Initializes the contract setting the deployer as the initial owner.
2649      */
2650     function initialize(address sender) public initializer {
2651         _owner = sender;
2652         emit OwnershipTransferred(address(0), _owner);
2653     }
2654 
2655     /**
2656      * @dev Returns the address of the current owner.
2657      */
2658     function owner() public view returns (address) {
2659         return _owner;
2660     }
2661 
2662     /**
2663      * @dev Throws if called by any account other than the owner.
2664      */
2665     modifier onlyOwner() {
2666         require(isOwner(), "Ownable: caller is not the owner");
2667         _;
2668     }
2669 
2670     /**
2671      * @dev Returns true if the caller is the current owner.
2672      */
2673     function isOwner() public view returns (bool) {
2674         return _msgSender() == _owner;
2675     }
2676 
2677     /**
2678      * @dev Leaves the contract without owner. It will not be possible to call
2679      * `onlyOwner` functions anymore. Can only be called by the current owner.
2680      *
2681      * > Note: Renouncing ownership will leave the contract without an owner,
2682      * thereby removing any functionality that is only available to the owner.
2683      */
2684     function renounceOwnership() public onlyOwner {
2685         emit OwnershipTransferred(_owner, address(0));
2686         _owner = address(0);
2687     }
2688 
2689     /**
2690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2691      * Can only be called by the current owner.
2692      */
2693     function transferOwnership(address newOwner) public onlyOwner {
2694         _transferOwnership(newOwner);
2695     }
2696 
2697     /**
2698      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2699      */
2700     function _transferOwnership(address newOwner) internal {
2701         require(newOwner != address(0), "Ownable: new owner is the zero address");
2702         emit OwnershipTransferred(_owner, newOwner);
2703         _owner = newOwner;
2704     }
2705 
2706     uint256[50] private ______gap;
2707 }
2708 
2709 contract StakingV2 is Ownable, ReentrancyGuard {
2710     using Address for address;
2711     using SafeMath for uint256;
2712     using SafeERC20 for IERC20;
2713 
2714     // EVENTS
2715 
2716     /**
2717      * @dev Emitted when a user deposits tokens.
2718      * @param sender User address.
2719      * @param id User's unique deposit ID.
2720      * @param amount The amount of deposited tokens.
2721      * @param currentBalance Current user balance.
2722      * @param timestamp Operation date
2723      */
2724     event Deposited(
2725         address indexed sender,
2726         uint256 indexed id,
2727         uint256 amount,
2728         uint256 currentBalance,
2729         uint256 timestamp
2730     );
2731 
2732     /**
2733      * @dev Emitted when a user withdraws tokens.
2734      * @param sender User address.
2735      * @param id User's unique deposit ID.
2736      * @param totalWithdrawalAmount The total amount of withdrawn tokens.
2737      * @param currentBalance Balance before withdrawal
2738      * @param timestamp Operation date
2739      */
2740     event WithdrawnAll(
2741         address indexed sender,
2742         uint256 indexed id,
2743         uint256 totalWithdrawalAmount,
2744         uint256 currentBalance,
2745         uint256 timestamp
2746     );
2747 
2748     /**
2749      * @dev Emitted when a user extends lockup.
2750      * @param sender User address.
2751      * @param id User's unique deposit ID.
2752      * @param currentBalance Balance before lockup extension
2753      * @param finalBalance Final balance
2754      * @param timestamp The instant when the lockup is extended.
2755      */
2756     event ExtendedLockup(
2757         address indexed sender,
2758         uint256 indexed id,
2759         uint256 currentBalance,
2760         uint256 finalBalance,
2761         uint256 timestamp
2762     );
2763 
2764     /**
2765      * @dev Emitted when a new Liquidity Provider address value is set.
2766      * @param value A new address value.
2767      * @param sender The owner address at the moment of address changing.
2768      */
2769     event LiquidityProviderAddressSet(address value, address sender);
2770 
2771     struct AddressParam {
2772         address oldValue;
2773         address newValue;
2774         uint256 timestamp;
2775     }
2776 
2777     // The deposit user balaces
2778     mapping(address => mapping(uint256 => uint256)) public balances;
2779     // The dates of users deposits/withdraws/extendLockups
2780     mapping(address => mapping(uint256 => uint256)) public depositDates;
2781 
2782     // Variable that prevents _deposit method from being called 2 times TODO CHECK
2783     bool private locked;
2784 
2785     // Variable to pause all operations
2786     bool private contractPaused = false;
2787 
2788     bool private pausedDepositsAndLockupExtensions = false;
2789 
2790     // STAKE token
2791     IERC20Mintable public token;
2792     // Reward Token
2793     IERC20Mintable public tokenReward;
2794 
2795     // The address for the Liquidity Providers
2796     AddressParam public liquidityProviderAddressParam;
2797 
2798     uint256 private constant DAY = 1 days;
2799     uint256 private constant MONTH = 30 days;
2800     uint256 private constant YEAR = 365 days;
2801 
2802     // The period after which the new value of the parameter is set
2803     uint256 public constant PARAM_UPDATE_DELAY = 7 days;
2804 
2805     // MODIFIERS
2806 
2807     /*
2808      *      1   |     2    |     3    |     4    |     5
2809      * 0 Months | 3 Months | 6 Months | 9 Months | 12 Months
2810      */
2811     modifier validDepositId(uint256 _depositId) {
2812         require(_depositId >= 1 && _depositId <= 5, "Invalid depositId");
2813         _;
2814     }
2815 
2816     // Impossible to withdrawAll if you have never deposited.
2817     modifier balanceExists(uint256 _depositId) {
2818         require(balances[msg.sender][_depositId] > 0, "Your deposit is zero");
2819         _;
2820     }
2821 
2822     modifier isNotLocked() {
2823         require(locked == false, "Locked, try again later");
2824         _;
2825     }
2826 
2827     modifier isNotPaused() {
2828         require(contractPaused == false, "Paused");
2829         _;
2830     }
2831 
2832     modifier isNotPausedOperations() {
2833         require(contractPaused == false, "Paused");
2834         _;
2835     }
2836 
2837     modifier isNotPausedDepositAndLockupExtensions() {
2838         require(pausedDepositsAndLockupExtensions == false, "Paused Deposits and Extensions");
2839         _;
2840     }
2841 
2842     /**
2843      * @dev Pause Deposits, Withdraw, Lockup Extension
2844      */
2845     function pauseContract(bool value) public onlyOwner {
2846         contractPaused = value;
2847     }
2848 
2849     /**
2850      * @dev Pause Deposits and Lockup Extension
2851      */
2852     function pauseDepositAndLockupExtensions(bool value) public onlyOwner {
2853         pausedDepositsAndLockupExtensions = value;
2854     }
2855 
2856     /**
2857      * @dev Initializes the contract. _tokenAddress _tokenReward will have the same address
2858      * @param _owner The owner of the contract.
2859      * @param _tokenAddress The address of the STAKE token contract.
2860      * @param _tokenReward The address of token rewards.
2861      * @param _liquidityProviderAddress The address for the Liquidity Providers reward.
2862      */
2863     function initializeStaking(
2864         address _owner,
2865         address _tokenAddress,
2866         address _tokenReward,
2867         address _liquidityProviderAddress
2868     ) external initializer {
2869         require(_owner != address(0), "Zero address");
2870         require(_tokenAddress.isContract(), "Not a contract address");
2871         Ownable.initialize(msg.sender);
2872         ReentrancyGuard.initialize();
2873         token = IERC20Mintable(_tokenAddress);
2874         tokenReward = IERC20Mintable(_tokenReward);
2875         setLiquidityProviderAddress(_liquidityProviderAddress);
2876         Ownable.transferOwnership(_owner);
2877     }
2878 
2879     /**
2880      * @dev Sets the address for the Liquidity Providers reward.
2881      * Can only be called by owner.
2882      * @param _address The new address.
2883      */
2884     function setLiquidityProviderAddress(address _address) public onlyOwner {
2885         require(_address != address(0), "Zero address");
2886         require(_address != address(this), "Wrong address");
2887         AddressParam memory param = liquidityProviderAddressParam;
2888         if (param.timestamp == 0) {
2889             param.oldValue = _address;
2890         } else if (_paramUpdateDelayElapsed(param.timestamp)) {
2891             param.oldValue = param.newValue;
2892         }
2893         param.newValue = _address;
2894         param.timestamp = _now();
2895         liquidityProviderAddressParam = param;
2896         emit LiquidityProviderAddressSet(_address, msg.sender);
2897     }
2898 
2899     /**
2900      * @return Returns true if param update delay elapsed.
2901      */
2902     function _paramUpdateDelayElapsed(uint256 _paramTimestamp) internal view returns (bool) {
2903         return _now() > _paramTimestamp.add(PARAM_UPDATE_DELAY);
2904     }
2905 
2906     /**
2907      * @dev This method is used to deposit tokens to the deposit opened before.
2908      * It calls the internal "_deposit" method and transfers tokens from sender to contract.
2909      * Sender must approve tokens first.
2910      *
2911      * Instead this, user can use the simple "transferFrom" method of OVR token contract to make a deposit.
2912      *
2913      * @param _depositId User's unique deposit ID.
2914      * @param _amount The amount to deposit.
2915      */
2916     function deposit(uint256 _depositId, uint256 _amount)
2917         public
2918         validDepositId(_depositId)
2919         isNotLocked
2920         isNotPaused
2921         isNotPausedDepositAndLockupExtensions
2922     {
2923         require(_amount > 0, "Amount should be more than 0");
2924 
2925         _deposit(msg.sender, _depositId, _amount);
2926 
2927         _setLocked(true);
2928         require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
2929         _setLocked(false);
2930     }
2931 
2932     /**
2933      * @param _sender The address of the sender.
2934      * @param _depositId User's deposit ID.
2935      * @param _amount The amount to deposit.
2936      */
2937     function _deposit(
2938         address _sender,
2939         uint256 _depositId,
2940         uint256 _amount
2941     ) internal nonReentrant {
2942         uint256 currentBalance = getCurrentBalance(_depositId, _sender);
2943         uint256 finalBalance = calcRewards(_sender, _depositId);
2944         uint256 timestamp = _now();
2945 
2946         balances[_sender][_depositId] = _amount.add(finalBalance);
2947         depositDates[_sender][_depositId] = _now();
2948         emit Deposited(_sender, _depositId, _amount, currentBalance, timestamp);
2949     }
2950 
2951     /**
2952      * @dev This method is used to withdraw rewards and balance.
2953      * It calls the internal "_withdrawAll" method.
2954      * @param _depositId User's unique deposit ID
2955      */
2956     function withdrawAll(uint256 _depositId) external balanceExists(_depositId) validDepositId(_depositId) isNotPaused {
2957         require(isLockupPeriodExpired(_depositId), "Too early, Lockup period");
2958         _withdrawAll(msg.sender, _depositId);
2959     }
2960 
2961     function _withdrawAll(address _sender, uint256 _depositId)
2962         internal
2963         balanceExists(_depositId)
2964         validDepositId(_depositId)
2965         nonReentrant
2966     {
2967         uint256 currentBalance = getCurrentBalance(_depositId, _sender);
2968         uint256 finalBalance = calcRewards(_sender, _depositId);
2969 
2970         require(finalBalance > 0, "Nothing to withdraw");
2971         balances[_sender][_depositId] = 0;
2972 
2973         _setLocked(true);
2974         require(tokenReward.transfer(_sender, finalBalance), "Liquidity pool transfer failed");
2975         _setLocked(false);
2976 
2977         emit WithdrawnAll(_sender, _depositId, finalBalance, currentBalance, _now());
2978     }
2979 
2980     /**
2981      * This method is used to extend lockup. It is available if your lockup period is expired and if depositId != 1
2982      * It calls the internal "_extendLockup" method.
2983      * @param _depositId User's unique deposit ID
2984      */
2985     function extendLockup(uint256 _depositId)
2986         external
2987         balanceExists(_depositId)
2988         validDepositId(_depositId)
2989         isNotPaused
2990         isNotPausedDepositAndLockupExtensions
2991     {
2992         require(_depositId != 1, "No lockup is set up");
2993         _extendLockup(msg.sender, _depositId);
2994     }
2995 
2996     function _extendLockup(address _sender, uint256 _depositId) internal nonReentrant {
2997         uint256 timestamp = _now();
2998         uint256 currentBalance = getCurrentBalance(_depositId, _sender);
2999         uint256 finalBalance = calcRewards(_sender, _depositId);
3000 
3001         balances[_sender][_depositId] = finalBalance;
3002         depositDates[_sender][_depositId] = timestamp;
3003         emit ExtendedLockup(_sender, _depositId, currentBalance, finalBalance, timestamp);
3004     }
3005 
3006     function isLockupPeriodExpired(uint256 _depositId) public view validDepositId(_depositId) returns (bool) {
3007         uint256 lockPeriod;
3008 
3009         if (_depositId == 1) {
3010             lockPeriod = 0;
3011         } else if (_depositId == 2) {
3012             lockPeriod = MONTH * 3; // 3 months
3013         } else if (_depositId == 3) {
3014             lockPeriod = MONTH * 6; // 6 months
3015         } else if (_depositId == 4) {
3016             lockPeriod = MONTH * 9; // 9 months
3017         } else if (_depositId == 5) {
3018             lockPeriod = MONTH * 12; // 12 months
3019         }
3020 
3021         if (_now() > depositDates[msg.sender][_depositId].add(lockPeriod)) {
3022             return true;
3023         } else {
3024             return false;
3025         }
3026     }
3027 
3028     function pow(int128 _x, uint256 _n) public pure returns (int128 r) {
3029         r = ABDKMath64x64.fromUInt(1);
3030         while (_n > 0) {
3031             if (_n % 2 == 1) {
3032                 r = ABDKMath64x64.mul(r, _x);
3033                 _n -= 1;
3034             } else {
3035                 _x = ABDKMath64x64.mul(_x, _x);
3036                 _n /= 2;
3037             }
3038         }
3039     }
3040 
3041     /**
3042      * This method is calcuate final compouded capital.
3043      * @param _principal User's balance
3044      * @param _ratio Interest rate
3045      * @param _n Periods is timestamp
3046      * @return finalBalance The final compounded capital
3047      *
3048      * A = C ( 1 + rate )^t
3049      */
3050     function compound(
3051         uint256 _principal,
3052         uint256 _ratio,
3053         uint256 _n
3054     ) public view returns (uint256) {
3055         uint256 daysCount = _n.div(DAY);
3056 
3057         return
3058             ABDKMath64x64.mulu(
3059                 pow(ABDKMath64x64.add(ABDKMath64x64.fromUInt(1), ABDKMath64x64.divu(_ratio, 10**18)), daysCount),
3060                 _principal
3061             );
3062     }
3063 
3064     /**
3065      * This moethod is used to calculate final compounded balance and is based on deposit duration and deposit id.
3066      * Each deposit mode is characterized by the lockup period and interest rate.
3067      * At the expiration of the lockup period the final compounded capital
3068      * will use minimum interest rate.
3069      *
3070      * This function can be called at any time to get the current total reward.
3071      * @param _sender Sender Address.
3072      * @param _depositId The depositId
3073      * @return finalBalance The final compounded capital
3074      */
3075     function calcRewards(address _sender, uint256 _depositId) public view validDepositId(_depositId) returns (uint256) {
3076         uint256 timePassed = _now().sub(depositDates[_sender][_depositId]);
3077         uint256 currentBalance = getCurrentBalance(_depositId, _sender);
3078         uint256 finalBalance;
3079 
3080         uint256 ratio;
3081         uint256 lockPeriod;
3082 
3083         if (_depositId == 1) {
3084             ratio = 100000000000000; // APY 3.7% InterestRate = 0.01
3085             lockPeriod = 0;
3086         } else if (_depositId == 2) {
3087             ratio = 300000000000000; // APY 11.6% InterestRate = 0.03
3088             lockPeriod = MONTH * 3; // 3 months
3089         } else if (_depositId == 3) {
3090             ratio = 400000000000000; // APY 15.7% InterestRate = 0.04
3091             lockPeriod = MONTH * 6; // 6 months
3092         } else if (_depositId == 4) {
3093             ratio = 600000000000000; // APY 25.5% InterestRate = 0.06
3094             lockPeriod = MONTH * 9; // 9 months
3095         } else if (_depositId == 5) {
3096             ratio = 800000000000000; // APY 33.9% InterestRate = 0.08
3097             lockPeriod = YEAR; // 12 months
3098         }
3099 
3100         // You can't have earnings without balance
3101         if (currentBalance == 0) {
3102             return finalBalance = 0;
3103         }
3104 
3105         // No lockup
3106         if (_depositId == 1) {
3107             finalBalance = compound(currentBalance, ratio, timePassed);
3108             return finalBalance;
3109         }
3110 
3111         // If you have an uncovered period from lockup, you still get rewards at the minimum rate
3112         if (timePassed > lockPeriod) {
3113             uint256 rewardsWithLockup = compound(currentBalance, ratio, lockPeriod).sub(currentBalance);
3114             finalBalance = compound(rewardsWithLockup.add(currentBalance), 100000000000000, timePassed.sub(lockPeriod));
3115 
3116 
3117             return finalBalance;
3118         }
3119 
3120         finalBalance = compound(currentBalance, ratio, timePassed);
3121         return finalBalance;
3122     }
3123 
3124     function getCurrentBalance(uint256 _depositId, address _address) public view returns (uint256 addressBalance) {
3125         addressBalance = balances[_address][_depositId];
3126     }
3127 
3128     /**
3129      * @return Returns current liquidity providers reward address.
3130      */
3131     function liquidityProviderAddress() public view returns (address) {
3132         AddressParam memory param = liquidityProviderAddressParam;
3133         return param.newValue;
3134     }
3135 
3136     /**
3137      * @dev Sets lock to prevent reentrance.
3138      */
3139     function _setLocked(bool _locked) internal {
3140         locked = _locked;
3141     }
3142 
3143     function senderCurrentBalance() public view returns (uint256) {
3144         return msg.sender.balance;
3145     }
3146 
3147     /**
3148      * @return Returns current timestamp.
3149      */
3150     function _now() internal view returns (uint256) {
3151         // Note that the timestamp can have a 900-second error:
3152         // https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md
3153         // return now; // solium-disable-line security/no-block-members
3154         return block.timestamp;
3155     }
3156 }