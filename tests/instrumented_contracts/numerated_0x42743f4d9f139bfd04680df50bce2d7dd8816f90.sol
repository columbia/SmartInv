1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Address.sol
219 
220 
221 
222 pragma solidity >=0.6.2 <0.8.0;
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize, which returns 0 for contracts in
247         // construction, since the code is only stored at the end of the
248         // constructor execution.
249 
250         uint256 size;
251         // solhint-disable-next-line no-inline-assembly
252         assembly { size := extcodesize(account) }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
276         (bool success, ) = recipient.call{ value: amount }("");
277         require(success, "Address: unable to send value, recipient may have reverted");
278     }
279 
280     /**
281      * @dev Performs a Solidity function call using a low level `call`. A
282      * plain`call` is an unsafe replacement for a function call: use this
283      * function instead.
284      *
285      * If `target` reverts with a revert reason, it is bubbled up by this
286      * function (like regular Solidity function calls).
287      *
288      * Returns the raw returned data. To convert to the expected return value,
289      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
290      *
291      * Requirements:
292      *
293      * - `target` must be a contract.
294      * - calling `target` with `data` must not revert.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
299       return functionCall(target, data, "Address: low-level call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
304      * `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
329      * with `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
334         require(address(this).balance >= value, "Address: insufficient balance for call");
335         require(isContract(target), "Address: call to non-contract");
336 
337         // solhint-disable-next-line avoid-low-level-calls
338         (bool success, bytes memory returndata) = target.call{ value: value }(data);
339         return _verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
349         return functionStaticCall(target, data, "Address: low-level static call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
359         require(isContract(target), "Address: static call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return _verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return _verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
411 
412 
413 
414 pragma solidity >=0.6.0 <0.8.0;
415 
416 /**
417  * @dev Interface of the ERC20 standard as defined in the EIP.
418  */
419 interface IERC20 {
420     /**
421      * @dev Returns the amount of tokens in existence.
422      */
423     function totalSupply() external view returns (uint256);
424 
425     /**
426      * @dev Returns the amount of tokens owned by `account`.
427      */
428     function balanceOf(address account) external view returns (uint256);
429 
430     /**
431      * @dev Moves `amount` tokens from the caller's account to `recipient`.
432      *
433      * Returns a boolean value indicating whether the operation succeeded.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transfer(address recipient, uint256 amount) external returns (bool);
438 
439     /**
440      * @dev Returns the remaining number of tokens that `spender` will be
441      * allowed to spend on behalf of `owner` through {transferFrom}. This is
442      * zero by default.
443      *
444      * This value changes when {approve} or {transferFrom} are called.
445      */
446     function allowance(address owner, address spender) external view returns (uint256);
447 
448     /**
449      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * IMPORTANT: Beware that changing an allowance with this method brings the risk
454      * that someone may use both the old and the new allowance by unfortunate
455      * transaction ordering. One possible solution to mitigate this race
456      * condition is to first reduce the spender's allowance to 0 and set the
457      * desired value afterwards:
458      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
459      *
460      * Emits an {Approval} event.
461      */
462     function approve(address spender, uint256 amount) external returns (bool);
463 
464     /**
465      * @dev Moves `amount` tokens from `sender` to `recipient` using the
466      * allowance mechanism. `amount` is then deducted from the caller's
467      * allowance.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
474 
475     /**
476      * @dev Emitted when `value` tokens are moved from one account (`from`) to
477      * another (`to`).
478      *
479      * Note that `value` may be zero.
480      */
481     event Transfer(address indexed from, address indexed to, uint256 value);
482 
483     /**
484      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
485      * a call to {approve}. `value` is the new allowance.
486      */
487     event Approval(address indexed owner, address indexed spender, uint256 value);
488 }
489 
490 // File: @bancor/token-governance/contracts/IClaimable.sol
491 
492 
493 pragma solidity 0.6.12;
494 
495 /// @title Claimable contract interface
496 interface IClaimable {
497     function owner() external view returns (address);
498 
499     function transferOwnership(address newOwner) external;
500 
501     function acceptOwnership() external;
502 }
503 
504 // File: @bancor/token-governance/contracts/IMintableToken.sol
505 
506 
507 pragma solidity 0.6.12;
508 
509 
510 
511 /// @title Mintable Token interface
512 interface IMintableToken is IERC20, IClaimable {
513     function issue(address to, uint256 amount) external;
514 
515     function destroy(address from, uint256 amount) external;
516 }
517 
518 // File: @bancor/token-governance/contracts/ITokenGovernance.sol
519 
520 
521 pragma solidity 0.6.12;
522 
523 
524 /// @title The interface for mintable/burnable token governance.
525 interface ITokenGovernance {
526     // The address of the mintable ERC20 token.
527     function token() external view returns (IMintableToken);
528 
529     /// @dev Mints new tokens.
530     ///
531     /// @param to Account to receive the new amount.
532     /// @param amount Amount to increase the supply by.
533     ///
534     function mint(address to, uint256 amount) external;
535 
536     /// @dev Burns tokens from the caller.
537     ///
538     /// @param amount Amount to decrease the supply by.
539     ///
540     function burn(uint256 amount) external;
541 }
542 
543 // File: solidity/contracts/utility/interfaces/ICheckpointStore.sol
544 
545 
546 pragma solidity 0.6.12;
547 
548 /**
549  * @dev Checkpoint store contract interface
550  */
551 interface ICheckpointStore {
552     function addCheckpoint(address _address) external;
553 
554     function addPastCheckpoint(address _address, uint256 _time) external;
555 
556     function addPastCheckpoints(address[] calldata _addresses, uint256[] calldata _times) external;
557 
558     function checkpoint(address _address) external view returns (uint256);
559 }
560 
561 // File: solidity/contracts/utility/MathEx.sol
562 
563 
564 pragma solidity 0.6.12;
565 
566 /**
567  * @dev This library provides a set of complex math operations.
568  */
569 library MathEx {
570     uint256 private constant MAX_EXP_BIT_LEN = 4;
571     uint256 private constant MAX_EXP = 2**MAX_EXP_BIT_LEN - 1;
572     uint256 private constant MAX_UINT128 = 2**128 - 1;
573 
574     /**
575      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
576      *
577      * @param _num a positive integer
578      *
579      * @return the largest integer smaller than or equal to the square root of the positive integer
580      */
581     function floorSqrt(uint256 _num) internal pure returns (uint256) {
582         uint256 x = _num / 2 + 1;
583         uint256 y = (x + _num / x) / 2;
584         while (x > y) {
585             x = y;
586             y = (x + _num / x) / 2;
587         }
588         return x;
589     }
590 
591     /**
592      * @dev returns the smallest integer larger than or equal to the square root of a positive integer
593      *
594      * @param _num a positive integer
595      *
596      * @return the smallest integer larger than or equal to the square root of the positive integer
597      */
598     function ceilSqrt(uint256 _num) internal pure returns (uint256) {
599         uint256 x = floorSqrt(_num);
600         return x * x == _num ? x : x + 1;
601     }
602 
603     /**
604      * @dev computes a powered ratio
605      *
606      * @param _n   ratio numerator
607      * @param _d   ratio denominator
608      * @param _exp ratio exponent
609      *
610      * @return powered ratio's numerator and denominator
611      */
612     function poweredRatio(
613         uint256 _n,
614         uint256 _d,
615         uint256 _exp
616     ) internal pure returns (uint256, uint256) {
617         require(_exp <= MAX_EXP, "ERR_EXP_TOO_LARGE");
618 
619         uint256[MAX_EXP_BIT_LEN] memory ns;
620         uint256[MAX_EXP_BIT_LEN] memory ds;
621 
622         (ns[0], ds[0]) = reducedRatio(_n, _d, MAX_UINT128);
623         for (uint256 i = 0; (_exp >> i) > 1; i++) {
624             (ns[i + 1], ds[i + 1]) = reducedRatio(ns[i] ** 2, ds[i] ** 2, MAX_UINT128);
625         }
626 
627         uint256 n = 1;
628         uint256 d = 1;
629 
630         for (uint256 i = 0; (_exp >> i) > 0; i++) {
631             if (((_exp >> i) & 1) > 0) {
632                 (n, d) = reducedRatio(n * ns[i], d * ds[i], MAX_UINT128);
633             }
634         }
635 
636         return (n, d);
637     }
638 
639     /**
640      * @dev computes a reduced-scalar ratio
641      *
642      * @param _n   ratio numerator
643      * @param _d   ratio denominator
644      * @param _max maximum desired scalar
645      *
646      * @return ratio's numerator and denominator
647      */
648     function reducedRatio(
649         uint256 _n,
650         uint256 _d,
651         uint256 _max
652     ) internal pure returns (uint256, uint256) {
653         (uint256 n, uint256 d) = (_n, _d);
654         if (n > _max || d > _max) {
655             (n, d) = normalizedRatio(n, d, _max);
656         }
657         if (n != d) {
658             return (n, d);
659         }
660         return (1, 1);
661     }
662 
663     /**
664      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
665      */
666     function normalizedRatio(
667         uint256 _a,
668         uint256 _b,
669         uint256 _scale
670     ) internal pure returns (uint256, uint256) {
671         if (_a <= _b) {
672             return accurateRatio(_a, _b, _scale);
673         }
674         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
675         return (x, y);
676     }
677 
678     /**
679      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a <= b".
680      */
681     function accurateRatio(
682         uint256 _a,
683         uint256 _b,
684         uint256 _scale
685     ) internal pure returns (uint256, uint256) {
686         uint256 maxVal = uint256(-1) / _scale;
687         if (_a > maxVal) {
688             uint256 c = _a / (maxVal + 1) + 1;
689             _a /= c; // we can now safely compute `_a * _scale`
690             _b /= c;
691         }
692         if (_a != _b) {
693             uint256 n = _a * _scale;
694             uint256 d = _a + _b; // can overflow
695             if (d >= _a) {
696                 // no overflow in `_a + _b`
697                 uint256 x = roundDiv(n, d); // we can now safely compute `_scale - x`
698                 uint256 y = _scale - x;
699                 return (x, y);
700             }
701             if (n < _b - (_b - _a) / 2) {
702                 return (0, _scale); // `_a * _scale < (_a + _b) / 2 < MAX_UINT256 < _a + _b`
703             }
704             return (1, _scale - 1); // `(_a + _b) / 2 < _a * _scale < MAX_UINT256 < _a + _b`
705         }
706         return (_scale / 2, _scale / 2); // allow reduction to `(1, 1)` in the calling function
707     }
708 
709     /**
710      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
711      */
712     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
713         return _n / _d + (_n % _d) / (_d - _d / 2);
714     }
715 
716     /**
717      * @dev returns the average number of decimal digits in a given list of positive integers
718      *
719      * @param _values  list of positive integers
720      *
721      * @return the average number of decimal digits in the given list of positive integers
722      */
723     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
724         uint256 numOfDigits = 0;
725         uint256 length = _values.length;
726         for (uint256 i = 0; i < length; i++) {
727             numOfDigits += decimalLength(_values[i]);
728         }
729         return uint256(10)**(roundDivUnsafe(numOfDigits, length) - 1);
730     }
731 
732     /**
733      * @dev returns the number of decimal digits in a given positive integer
734      *
735      * @param _x   positive integer
736      *
737      * @return the number of decimal digits in the given positive integer
738      */
739     function decimalLength(uint256 _x) internal pure returns (uint256) {
740         uint256 y = 0;
741         for (uint256 x = _x; x > 0; x /= 10) {
742             y++;
743         }
744         return y;
745     }
746 
747     /**
748      * @dev returns the nearest integer to a given quotient
749      * the computation is overflow-safe assuming that the input is sufficiently small
750      *
751      * @param _n   quotient numerator
752      * @param _d   quotient denominator
753      *
754      * @return the nearest integer to the given quotient
755      */
756     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
757         return (_n + _d / 2) / _d;
758     }
759 
760     /**
761      * @dev returns the larger of two values
762      *
763      * @param _val1 the first value
764      * @param _val2 the second value
765      */
766     function max(uint256 _val1, uint256 _val2) internal pure returns (uint256) {
767         return _val1 > _val2 ? _val1 : _val2;
768     }
769 }
770 
771 // File: solidity/contracts/utility/ReentrancyGuard.sol
772 
773 
774 pragma solidity 0.6.12;
775 
776 /**
777  * @dev This contract provides protection against calling a function
778  * (directly or indirectly) from within itself.
779  */
780 contract ReentrancyGuard {
781     uint256 private constant UNLOCKED = 1;
782     uint256 private constant LOCKED = 2;
783 
784     // LOCKED while protected code is being executed, UNLOCKED otherwise
785     uint256 private state = UNLOCKED;
786 
787     /**
788      * @dev ensures instantiation only by sub-contracts
789      */
790     constructor() internal {}
791 
792     // protects a function against reentrancy attacks
793     modifier protected() {
794         _protected();
795         state = LOCKED;
796         _;
797         state = UNLOCKED;
798     }
799 
800     // error message binary size optimization
801     function _protected() internal view {
802         require(state == UNLOCKED, "ERR_REENTRANCY");
803     }
804 }
805 
806 // File: solidity/contracts/utility/Types.sol
807 
808 
809 pragma solidity 0.6.12;
810 
811 /**
812  * @dev This contract provides types which can be used by various contracts.
813  */
814 
815 struct Fraction {
816     uint256 n; // numerator
817     uint256 d; // denominator
818 }
819 
820 // File: solidity/contracts/utility/Time.sol
821 
822 
823 pragma solidity 0.6.12;
824 
825 /*
826     Time implementing contract
827 */
828 contract Time {
829     /**
830      * @dev returns the current time
831      */
832     function time() internal view virtual returns (uint256) {
833         return block.timestamp;
834     }
835 }
836 
837 // File: solidity/contracts/utility/Utils.sol
838 
839 
840 pragma solidity 0.6.12;
841 
842 
843 /**
844  * @dev Utilities & Common Modifiers
845  */
846 contract Utils {
847     uint32 internal constant PPM_RESOLUTION = 1000000;
848 
849     // verifies that a value is greater than zero
850     modifier greaterThanZero(uint256 _value) {
851         _greaterThanZero(_value);
852         _;
853     }
854 
855     // error message binary size optimization
856     function _greaterThanZero(uint256 _value) internal pure {
857         require(_value > 0, "ERR_ZERO_VALUE");
858     }
859 
860     // validates an address - currently only checks that it isn't null
861     modifier validAddress(address _address) {
862         _validAddress(_address);
863         _;
864     }
865 
866     // error message binary size optimization
867     function _validAddress(address _address) internal pure {
868         require(_address != address(0), "ERR_INVALID_ADDRESS");
869     }
870 
871     // ensures that the portion is valid
872     modifier validPortion(uint32 _portion) {
873         _validPortion(_portion);
874         _;
875     }
876 
877     // error message binary size optimization
878     function _validPortion(uint32 _portion) internal pure {
879         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
880     }
881 
882     // validates an external address - currently only checks that it isn't null or this
883     modifier validExternalAddress(address _address) {
884         _validExternalAddress(_address);
885         _;
886     }
887 
888     // error message binary size optimization
889     function _validExternalAddress(address _address) internal view {
890         require(_address != address(0) && _address != address(this), "ERR_INVALID_EXTERNAL_ADDRESS");
891     }
892 
893     // ensures that the fee is valid
894     modifier validFee(uint32 fee) {
895         _validFee(fee);
896         _;
897     }
898 
899     // error message binary size optimization
900     function _validFee(uint32 fee) internal pure {
901         require(fee <= PPM_RESOLUTION, "ERR_INVALID_FEE");
902     }
903 }
904 
905 // File: solidity/contracts/utility/interfaces/IOwned.sol
906 
907 
908 pragma solidity 0.6.12;
909 
910 /*
911     Owned contract interface
912 */
913 interface IOwned {
914     // this function isn't since the compiler emits automatically generated getter functions as external
915     function owner() external view returns (address);
916 
917     function transferOwnership(address _newOwner) external;
918 
919     function acceptOwnership() external;
920 }
921 
922 // File: solidity/contracts/utility/Owned.sol
923 
924 
925 pragma solidity 0.6.12;
926 
927 
928 /**
929  * @dev This contract provides support and utilities for contract ownership.
930  */
931 contract Owned is IOwned {
932     address public override owner;
933     address public newOwner;
934 
935     /**
936      * @dev triggered when the owner is updated
937      *
938      * @param _prevOwner previous owner
939      * @param _newOwner  new owner
940      */
941     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
942 
943     /**
944      * @dev initializes a new Owned instance
945      */
946     constructor() public {
947         owner = msg.sender;
948     }
949 
950     // allows execution by the owner only
951     modifier ownerOnly {
952         _ownerOnly();
953         _;
954     }
955 
956     // error message binary size optimization
957     function _ownerOnly() internal view {
958         require(msg.sender == owner, "ERR_ACCESS_DENIED");
959     }
960 
961     /**
962      * @dev allows transferring the contract ownership
963      * the new owner still needs to accept the transfer
964      * can only be called by the contract owner
965      *
966      * @param _newOwner    new contract owner
967      */
968     function transferOwnership(address _newOwner) public override ownerOnly {
969         require(_newOwner != owner, "ERR_SAME_OWNER");
970         newOwner = _newOwner;
971     }
972 
973     /**
974      * @dev used by a new owner to accept an ownership transfer
975      */
976     function acceptOwnership() public override {
977         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
978         emit OwnerUpdate(owner, newOwner);
979         owner = newOwner;
980         newOwner = address(0);
981     }
982 }
983 
984 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
985 
986 
987 pragma solidity 0.6.12;
988 
989 
990 /*
991     Converter Anchor interface
992 */
993 interface IConverterAnchor is IOwned {
994 
995 }
996 
997 // File: solidity/contracts/token/interfaces/IDSToken.sol
998 
999 
1000 pragma solidity 0.6.12;
1001 
1002 
1003 
1004 
1005 /*
1006     DSToken interface
1007 */
1008 interface IDSToken is IConverterAnchor, IERC20 {
1009     function issue(address _to, uint256 _amount) external;
1010 
1011     function destroy(address _from, uint256 _amount) external;
1012 }
1013 
1014 // File: solidity/contracts/token/interfaces/IReserveToken.sol
1015 
1016 
1017 pragma solidity 0.6.12;
1018 
1019 /**
1020  * @dev This contract is used to represent reserve tokens, which are tokens that can either be regular ERC20 tokens or
1021  * native ETH (represented by the NATIVE_TOKEN_ADDRESS address)
1022  *
1023  * Please note that this interface is intentionally doesn't inherit from IERC20, so that it'd be possible to effectively
1024  * override its balanceOf() function in the ReserveToken library
1025  */
1026 interface IReserveToken {
1027 
1028 }
1029 
1030 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1031 
1032 
1033 
1034 pragma solidity >=0.6.0 <0.8.0;
1035 
1036 
1037 
1038 
1039 /**
1040  * @title SafeERC20
1041  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1042  * contract returns false). Tokens that return no value (and instead revert or
1043  * throw on failure) are also supported, non-reverting calls are assumed to be
1044  * successful.
1045  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1046  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1047  */
1048 library SafeERC20 {
1049     using SafeMath for uint256;
1050     using Address for address;
1051 
1052     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1053         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1054     }
1055 
1056     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1057         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1058     }
1059 
1060     /**
1061      * @dev Deprecated. This function has issues similar to the ones found in
1062      * {IERC20-approve}, and its usage is discouraged.
1063      *
1064      * Whenever possible, use {safeIncreaseAllowance} and
1065      * {safeDecreaseAllowance} instead.
1066      */
1067     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1068         // safeApprove should only be called when setting an initial allowance,
1069         // or when resetting it to zero. To increase and decrease it, use
1070         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1071         // solhint-disable-next-line max-line-length
1072         require((value == 0) || (token.allowance(address(this), spender) == 0),
1073             "SafeERC20: approve from non-zero to non-zero allowance"
1074         );
1075         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1076     }
1077 
1078     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1079         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1080         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1081     }
1082 
1083     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1084         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1085         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1086     }
1087 
1088     /**
1089      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1090      * on the return value: the return value is optional (but if data is returned, it must not be false).
1091      * @param token The token targeted by the call.
1092      * @param data The call data (encoded using abi.encode or one of its variants).
1093      */
1094     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1095         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1096         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1097         // the target address contains contract code and also asserts for success in the low-level call.
1098 
1099         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1100         if (returndata.length > 0) { // Return data is optional
1101             // solhint-disable-next-line max-line-length
1102             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1103         }
1104     }
1105 }
1106 
1107 // File: solidity/contracts/token/SafeERC20Ex.sol
1108 
1109 
1110 pragma solidity 0.6.12;
1111 
1112 
1113 /**
1114  * @dev Extends the SafeERC20 library with additional operations
1115  */
1116 library SafeERC20Ex {
1117     using SafeERC20 for IERC20;
1118 
1119     /**
1120      * @dev ensures that the spender has sufficient allowance
1121      *
1122      * @param token the address of the token to ensure
1123      * @param spender the address allowed to spend
1124      * @param amount the allowed amount to spend
1125      */
1126     function ensureApprove(
1127         IERC20 token,
1128         address spender,
1129         uint256 amount
1130     ) internal {
1131         if (amount == 0) {
1132             return;
1133         }
1134 
1135         uint256 allowance = token.allowance(address(this), spender);
1136         if (allowance >= amount) {
1137             return;
1138         }
1139 
1140         if (allowance > 0) {
1141             token.safeApprove(spender, 0);
1142         }
1143         token.safeApprove(spender, amount);
1144     }
1145 }
1146 
1147 // File: solidity/contracts/token/ReserveToken.sol
1148 
1149 
1150 pragma solidity 0.6.12;
1151 
1152 
1153 
1154 
1155 /**
1156  * @dev This library implements ERC20 and SafeERC20 utilities for reserve tokens, which can be either ERC20 tokens or ETH
1157  */
1158 library ReserveToken {
1159     using SafeERC20 for IERC20;
1160     using SafeERC20Ex for IERC20;
1161 
1162     // the address that represents an ETH reserve
1163     IReserveToken public constant NATIVE_TOKEN_ADDRESS = IReserveToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1164 
1165     /**
1166      * @dev returns whether the provided token represents an ERC20 or ETH reserve
1167      *
1168      * @param reserveToken the address of the reserve token
1169      *
1170      * @return whether the provided token represents an ERC20 or ETH reserve
1171      */
1172     function isNativeToken(IReserveToken reserveToken) internal pure returns (bool) {
1173         return reserveToken == NATIVE_TOKEN_ADDRESS;
1174     }
1175 
1176     /**
1177      * @dev returns the balance of the reserve token
1178      *
1179      * @param reserveToken the address of the reserve token
1180      * @param account the address of the account to check
1181      *
1182      * @return the balance of the reserve token
1183      */
1184     function balanceOf(IReserveToken reserveToken, address account) internal view returns (uint256) {
1185         if (isNativeToken(reserveToken)) {
1186             return account.balance;
1187         }
1188 
1189         return toIERC20(reserveToken).balanceOf(account);
1190     }
1191 
1192     /**
1193      * @dev transfers a specific amount of the reserve token
1194      *
1195      * @param reserveToken the address of the reserve token
1196      * @param to the destination address to transfer the amount to
1197      * @param amount the amount to transfer
1198      */
1199     function safeTransfer(
1200         IReserveToken reserveToken,
1201         address to,
1202         uint256 amount
1203     ) internal {
1204         if (amount == 0) {
1205             return;
1206         }
1207 
1208         if (isNativeToken(reserveToken)) {
1209             payable(to).transfer(amount);
1210         } else {
1211             toIERC20(reserveToken).safeTransfer(to, amount);
1212         }
1213     }
1214 
1215     /**
1216      * @dev transfers a specific amount of the reserve token from a specific holder using the allowance mechanism
1217      * this function ignores a reserve token which represents an ETH reserve
1218      *
1219      * @param reserveToken the address of the reserve token
1220      * @param from the source address to transfer the amount from
1221      * @param to the destination address to transfer the amount to
1222      * @param amount the amount to transfer
1223      */
1224     function safeTransferFrom(
1225         IReserveToken reserveToken,
1226         address from,
1227         address to,
1228         uint256 amount
1229     ) internal {
1230         if (amount == 0 || isNativeToken(reserveToken)) {
1231             return;
1232         }
1233 
1234         toIERC20(reserveToken).safeTransferFrom(from, to, amount);
1235     }
1236 
1237     /**
1238      * @dev ensures that the spender has sufficient allowance
1239      * this function ignores a reserve token which represents an ETH reserve
1240      *
1241      * @param reserveToken the address of the reserve token
1242      * @param spender the address allowed to spend
1243      * @param amount the allowed amount to spend
1244      */
1245     function ensureApprove(
1246         IReserveToken reserveToken,
1247         address spender,
1248         uint256 amount
1249     ) internal {
1250         if (isNativeToken(reserveToken)) {
1251             return;
1252         }
1253 
1254         toIERC20(reserveToken).ensureApprove(spender, amount);
1255     }
1256 
1257     /**
1258      * @dev utility function that converts an IReserveToken to an IERC20
1259      *
1260      * @param reserveToken the address of the reserve token
1261      *
1262      * @return an IERC20
1263      */
1264     function toIERC20(IReserveToken reserveToken) private pure returns (IERC20) {
1265         return IERC20(address(reserveToken));
1266     }
1267 }
1268 
1269 // File: solidity/contracts/converter/interfaces/IConverter.sol
1270 
1271 
1272 pragma solidity 0.6.12;
1273 
1274 
1275 
1276 
1277 
1278 /*
1279     Converter interface
1280 */
1281 interface IConverter is IOwned {
1282     function converterType() external pure returns (uint16);
1283 
1284     function anchor() external view returns (IConverterAnchor);
1285 
1286     function isActive() external view returns (bool);
1287 
1288     function targetAmountAndFee(
1289         IReserveToken _sourceToken,
1290         IReserveToken _targetToken,
1291         uint256 _amount
1292     ) external view returns (uint256, uint256);
1293 
1294     function convert(
1295         IReserveToken _sourceToken,
1296         IReserveToken _targetToken,
1297         uint256 _amount,
1298         address _trader,
1299         address payable _beneficiary
1300     ) external payable returns (uint256);
1301 
1302     function conversionFee() external view returns (uint32);
1303 
1304     function maxConversionFee() external view returns (uint32);
1305 
1306     function reserveBalance(IReserveToken _reserveToken) external view returns (uint256);
1307 
1308     receive() external payable;
1309 
1310     function transferAnchorOwnership(address _newOwner) external;
1311 
1312     function acceptAnchorOwnership() external;
1313 
1314     function setConversionFee(uint32 _conversionFee) external;
1315 
1316     function addReserve(IReserveToken _token, uint32 _weight) external;
1317 
1318     function transferReservesOnUpgrade(address _newConverter) external;
1319 
1320     function onUpgradeComplete() external;
1321 
1322     // deprecated, backward compatibility
1323     function token() external view returns (IConverterAnchor);
1324 
1325     function transferTokenOwnership(address _newOwner) external;
1326 
1327     function acceptTokenOwnership() external;
1328 
1329     function connectors(IReserveToken _address)
1330         external
1331         view
1332         returns (
1333             uint256,
1334             uint32,
1335             bool,
1336             bool,
1337             bool
1338         );
1339 
1340     function getConnectorBalance(IReserveToken _connectorToken) external view returns (uint256);
1341 
1342     function connectorTokens(uint256 _index) external view returns (IReserveToken);
1343 
1344     function connectorTokenCount() external view returns (uint16);
1345 
1346     /**
1347      * @dev triggered when the converter is activated
1348      *
1349      * @param _type        converter type
1350      * @param _anchor      converter anchor
1351      * @param _activated   true if the converter was activated, false if it was deactivated
1352      */
1353     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
1354 
1355     /**
1356      * @dev triggered when a conversion between two tokens occurs
1357      *
1358      * @param _fromToken       source reserve token
1359      * @param _toToken         target reserve token
1360      * @param _trader          wallet that initiated the trade
1361      * @param _amount          input amount in units of the source token
1362      * @param _return          output amount minus conversion fee in units of the target token
1363      * @param _conversionFee   conversion fee in units of the target token
1364      */
1365     event Conversion(
1366         IReserveToken indexed _fromToken,
1367         IReserveToken indexed _toToken,
1368         address indexed _trader,
1369         uint256 _amount,
1370         uint256 _return,
1371         int256 _conversionFee
1372     );
1373 
1374     /**
1375      * @dev triggered when the rate between two tokens in the converter changes
1376      * note that the event might be dispatched for rate updates between any two tokens in the converter
1377      *
1378      * @param  _token1 address of the first token
1379      * @param  _token2 address of the second token
1380      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
1381      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
1382      */
1383     event TokenRateUpdate(address indexed _token1, address indexed _token2, uint256 _rateN, uint256 _rateD);
1384 
1385     /**
1386      * @dev triggered when the conversion fee is updated
1387      *
1388      * @param  _prevFee    previous fee percentage, represented in ppm
1389      * @param  _newFee     new fee percentage, represented in ppm
1390      */
1391     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
1392 }
1393 
1394 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
1395 
1396 
1397 pragma solidity 0.6.12;
1398 
1399 
1400 
1401 interface IConverterRegistry {
1402     function getAnchorCount() external view returns (uint256);
1403 
1404     function getAnchors() external view returns (address[] memory);
1405 
1406     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
1407 
1408     function isAnchor(address _value) external view returns (bool);
1409 
1410     function getLiquidityPoolCount() external view returns (uint256);
1411 
1412     function getLiquidityPools() external view returns (address[] memory);
1413 
1414     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
1415 
1416     function isLiquidityPool(address _value) external view returns (bool);
1417 
1418     function getConvertibleTokenCount() external view returns (uint256);
1419 
1420     function getConvertibleTokens() external view returns (address[] memory);
1421 
1422     function getConvertibleToken(uint256 _index) external view returns (IReserveToken);
1423 
1424     function isConvertibleToken(address _value) external view returns (bool);
1425 
1426     function getConvertibleTokenAnchorCount(IReserveToken _convertibleToken) external view returns (uint256);
1427 
1428     function getConvertibleTokenAnchors(IReserveToken _convertibleToken) external view returns (address[] memory);
1429 
1430     function getConvertibleTokenAnchor(IReserveToken _convertibleToken, uint256 _index)
1431         external
1432         view
1433         returns (IConverterAnchor);
1434 
1435     function isConvertibleTokenAnchor(IReserveToken _convertibleToken, address _value) external view returns (bool);
1436 
1437     function getLiquidityPoolByConfig(
1438         uint16 _type,
1439         IReserveToken[] memory _reserveTokens,
1440         uint32[] memory _reserveWeights
1441     ) external view returns (IConverterAnchor);
1442 }
1443 
1444 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStore.sol
1445 
1446 
1447 pragma solidity 0.6.12;
1448 
1449 
1450 
1451 
1452 
1453 /*
1454     Liquidity Protection Store interface
1455 */
1456 interface ILiquidityProtectionStore is IOwned {
1457     function withdrawTokens(
1458         IReserveToken _token,
1459         address _to,
1460         uint256 _amount
1461     ) external;
1462 
1463     function protectedLiquidity(uint256 _id)
1464         external
1465         view
1466         returns (
1467             address,
1468             IDSToken,
1469             IReserveToken,
1470             uint256,
1471             uint256,
1472             uint256,
1473             uint256,
1474             uint256
1475         );
1476 
1477     function addProtectedLiquidity(
1478         address _provider,
1479         IDSToken _poolToken,
1480         IReserveToken _reserveToken,
1481         uint256 _poolAmount,
1482         uint256 _reserveAmount,
1483         uint256 _reserveRateN,
1484         uint256 _reserveRateD,
1485         uint256 _timestamp
1486     ) external returns (uint256);
1487 
1488     function updateProtectedLiquidityAmounts(
1489         uint256 _id,
1490         uint256 _poolNewAmount,
1491         uint256 _reserveNewAmount
1492     ) external;
1493 
1494     function removeProtectedLiquidity(uint256 _id) external;
1495 
1496     function lockedBalance(address _provider, uint256 _index) external view returns (uint256, uint256);
1497 
1498     function lockedBalanceRange(
1499         address _provider,
1500         uint256 _startIndex,
1501         uint256 _endIndex
1502     ) external view returns (uint256[] memory, uint256[] memory);
1503 
1504     function addLockedBalance(
1505         address _provider,
1506         uint256 _reserveAmount,
1507         uint256 _expirationTime
1508     ) external returns (uint256);
1509 
1510     function removeLockedBalance(address _provider, uint256 _index) external;
1511 
1512     function systemBalance(IReserveToken _poolToken) external view returns (uint256);
1513 
1514     function incSystemBalance(IReserveToken _poolToken, uint256 _poolAmount) external;
1515 
1516     function decSystemBalance(IReserveToken _poolToken, uint256 _poolAmount) external;
1517 }
1518 
1519 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStats.sol
1520 
1521 
1522 pragma solidity 0.6.12;
1523 
1524 
1525 
1526 
1527 /*
1528     Liquidity Protection Stats interface
1529 */
1530 interface ILiquidityProtectionStats {
1531     function increaseTotalAmounts(
1532         address provider,
1533         IDSToken poolToken,
1534         IReserveToken reserveToken,
1535         uint256 poolAmount,
1536         uint256 reserveAmount
1537     ) external;
1538 
1539     function decreaseTotalAmounts(
1540         address provider,
1541         IDSToken poolToken,
1542         IReserveToken reserveToken,
1543         uint256 poolAmount,
1544         uint256 reserveAmount
1545     ) external;
1546 
1547     function addProviderPool(address provider, IDSToken poolToken) external returns (bool);
1548 
1549     function removeProviderPool(address provider, IDSToken poolToken) external returns (bool);
1550 
1551     function totalPoolAmount(IDSToken poolToken) external view returns (uint256);
1552 
1553     function totalReserveAmount(IDSToken poolToken, IReserveToken reserveToken) external view returns (uint256);
1554 
1555     function totalProviderAmount(
1556         address provider,
1557         IDSToken poolToken,
1558         IReserveToken reserveToken
1559     ) external view returns (uint256);
1560 
1561     function providerPools(address provider) external view returns (IDSToken[] memory);
1562 }
1563 
1564 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionEventsSubscriber.sol
1565 
1566 
1567 pragma solidity 0.6.12;
1568 
1569 
1570 
1571 /**
1572  * @dev Liquidity protection events subscriber interface
1573  */
1574 interface ILiquidityProtectionEventsSubscriber {
1575     function onAddingLiquidity(
1576         address provider,
1577         IConverterAnchor poolAnchor,
1578         IReserveToken reserveToken,
1579         uint256 poolAmount,
1580         uint256 reserveAmount
1581     ) external;
1582 
1583     function onRemovingLiquidity(
1584         uint256 id,
1585         address provider,
1586         IConverterAnchor poolAnchor,
1587         IReserveToken reserveToken,
1588         uint256 poolAmount,
1589         uint256 reserveAmount
1590     ) external;
1591 }
1592 
1593 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSettings.sol
1594 
1595 
1596 pragma solidity 0.6.12;
1597 
1598 
1599 
1600 
1601 /*
1602     Liquidity Protection Store Settings interface
1603 */
1604 interface ILiquidityProtectionSettings {
1605     function isPoolWhitelisted(IConverterAnchor poolAnchor) external view returns (bool);
1606 
1607     function poolWhitelist() external view returns (address[] memory);
1608 
1609     function subscribers() external view returns (address[] memory);
1610 
1611     function isPoolSupported(IConverterAnchor poolAnchor) external view returns (bool);
1612 
1613     function minNetworkTokenLiquidityForMinting() external view returns (uint256);
1614 
1615     function defaultNetworkTokenMintingLimit() external view returns (uint256);
1616 
1617     function networkTokenMintingLimits(IConverterAnchor poolAnchor) external view returns (uint256);
1618 
1619     function addLiquidityDisabled(IConverterAnchor poolAnchor, IReserveToken reserveToken) external view returns (bool);
1620 
1621     function minProtectionDelay() external view returns (uint256);
1622 
1623     function maxProtectionDelay() external view returns (uint256);
1624 
1625     function minNetworkCompensation() external view returns (uint256);
1626 
1627     function lockDuration() external view returns (uint256);
1628 
1629     function averageRateMaxDeviation() external view returns (uint32);
1630 }
1631 
1632 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSystemStore.sol
1633 
1634 
1635 pragma solidity 0.6.12;
1636 
1637 
1638 
1639 /*
1640     Liquidity Protection System Store interface
1641 */
1642 interface ILiquidityProtectionSystemStore {
1643     function systemBalance(IERC20 poolToken) external view returns (uint256);
1644 
1645     function incSystemBalance(IERC20 poolToken, uint256 poolAmount) external;
1646 
1647     function decSystemBalance(IERC20 poolToken, uint256 poolAmount) external;
1648 
1649     function networkTokensMinted(IConverterAnchor poolAnchor) external view returns (uint256);
1650 
1651     function incNetworkTokensMinted(IConverterAnchor poolAnchor, uint256 amount) external;
1652 
1653     function decNetworkTokensMinted(IConverterAnchor poolAnchor, uint256 amount) external;
1654 }
1655 
1656 // File: solidity/contracts/utility/interfaces/ITokenHolder.sol
1657 
1658 
1659 pragma solidity 0.6.12;
1660 
1661 
1662 
1663 /*
1664     Token Holder interface
1665 */
1666 interface ITokenHolder is IOwned {
1667     receive() external payable;
1668 
1669     function withdrawTokens(
1670         IReserveToken reserveToken,
1671         address payable to,
1672         uint256 amount
1673     ) external;
1674 
1675     function withdrawTokensMultiple(
1676         IReserveToken[] calldata reserveTokens,
1677         address payable to,
1678         uint256[] calldata amounts
1679     ) external;
1680 }
1681 
1682 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtection.sol
1683 
1684 
1685 pragma solidity 0.6.12;
1686 
1687 
1688 
1689 
1690 
1691 
1692 
1693 
1694 /*
1695     Liquidity Protection interface
1696 */
1697 interface ILiquidityProtection {
1698     function store() external view returns (ILiquidityProtectionStore);
1699 
1700     function stats() external view returns (ILiquidityProtectionStats);
1701 
1702     function settings() external view returns (ILiquidityProtectionSettings);
1703 
1704     function systemStore() external view returns (ILiquidityProtectionSystemStore);
1705 
1706     function wallet() external view returns (ITokenHolder);
1707 
1708     function addLiquidityFor(
1709         address owner,
1710         IConverterAnchor poolAnchor,
1711         IReserveToken reserveToken,
1712         uint256 amount
1713     ) external payable returns (uint256);
1714 
1715     function addLiquidity(
1716         IConverterAnchor poolAnchor,
1717         IReserveToken reserveToken,
1718         uint256 amount
1719     ) external payable returns (uint256);
1720 
1721     function removeLiquidity(uint256 id, uint32 portion) external;
1722 }
1723 
1724 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
1725 
1726 
1727 pragma solidity 0.6.12;
1728 
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 
1744 
1745 interface ILiquidityPoolConverter is IConverter {
1746     function addLiquidity(
1747         IReserveToken[] memory reserveTokens,
1748         uint256[] memory reserveAmounts,
1749         uint256 _minReturn
1750     ) external payable;
1751 
1752     function removeLiquidity(
1753         uint256 amount,
1754         IReserveToken[] memory reserveTokens,
1755         uint256[] memory _reserveMinReturnAmounts
1756     ) external;
1757 
1758     function recentAverageRate(IReserveToken reserveToken) external view returns (uint256, uint256);
1759 }
1760 
1761 /**
1762  * @dev This contract implements the liquidity protection mechanism.
1763  */
1764 contract LiquidityProtection is ILiquidityProtection, Utils, Owned, ReentrancyGuard, Time {
1765     using SafeMath for uint256;
1766     using ReserveToken for IReserveToken;
1767     using SafeERC20 for IERC20;
1768     using SafeERC20 for IDSToken;
1769     using SafeERC20Ex for IERC20;
1770     using MathEx for *;
1771 
1772     struct Position {
1773         address provider; // liquidity provider
1774         IDSToken poolToken; // pool token address
1775         IReserveToken reserveToken; // reserve token address
1776         uint256 poolAmount; // pool token amount
1777         uint256 reserveAmount; // reserve token amount
1778         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1779         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1780         uint256 timestamp; // timestamp
1781     }
1782 
1783     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1784     struct PackedRates {
1785         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1786         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1787         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1788         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1789         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1790         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1791     }
1792 
1793     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1794     uint256 internal constant MAX_UINT256 = uint256(-1);
1795     uint8 private constant FUNC_SELECTOR_LENGTH = 4;
1796 
1797     ILiquidityProtectionSettings private immutable _settings;
1798     ILiquidityProtectionStore private immutable _store;
1799     ILiquidityProtectionStats private immutable _stats;
1800     ILiquidityProtectionSystemStore private immutable _systemStore;
1801     ITokenHolder private immutable _wallet;
1802     IERC20 private immutable _networkToken;
1803     ITokenGovernance private immutable _networkTokenGovernance;
1804     IERC20 private immutable _govToken;
1805     ITokenGovernance private immutable _govTokenGovernance;
1806     ICheckpointStore private immutable _lastRemoveCheckpointStore;
1807 
1808     /**
1809      * @dev initializes a new LiquidityProtection contract
1810      *
1811      * @param settings liquidity protection settings
1812      * @param store liquidity protection store
1813      * @param stats liquidity protection stats
1814      * @param systemStore liquidity protection system store
1815      * @param wallet liquidity protection wallet
1816      * @param networkTokenGovernance network token governance
1817      * @param govTokenGovernance governance token governance
1818      * @param lastRemoveCheckpointStore last liquidity removal/unprotection checkpoints store
1819      */
1820     constructor(
1821         ILiquidityProtectionSettings settings,
1822         ILiquidityProtectionStore store,
1823         ILiquidityProtectionStats stats,
1824         ILiquidityProtectionSystemStore systemStore,
1825         ITokenHolder wallet,
1826         ITokenGovernance networkTokenGovernance,
1827         ITokenGovernance govTokenGovernance,
1828         ICheckpointStore lastRemoveCheckpointStore
1829     )
1830         public
1831         validAddress(address(settings))
1832         validAddress(address(store))
1833         validAddress(address(stats))
1834         validAddress(address(systemStore))
1835         validAddress(address(wallet))
1836         validAddress(address(lastRemoveCheckpointStore))
1837     {
1838         _settings = settings;
1839         _store = store;
1840         _stats = stats;
1841         _systemStore = systemStore;
1842         _wallet = wallet;
1843         _networkTokenGovernance = networkTokenGovernance;
1844         _govTokenGovernance = govTokenGovernance;
1845         _lastRemoveCheckpointStore = lastRemoveCheckpointStore;
1846 
1847         _networkToken = networkTokenGovernance.token();
1848         _govToken = govTokenGovernance.token();
1849     }
1850 
1851     // ensures that the pool is supported and whitelisted
1852     modifier poolSupportedAndWhitelisted(IConverterAnchor poolAnchor) {
1853         _poolSupported(poolAnchor);
1854         _poolWhitelisted(poolAnchor);
1855 
1856         _;
1857     }
1858 
1859     // ensures that add liquidity is enabled
1860     modifier addLiquidityEnabled(IConverterAnchor poolAnchor, IReserveToken reserveToken) {
1861         _addLiquidityEnabled(poolAnchor, reserveToken);
1862 
1863         _;
1864     }
1865 
1866     // error message binary size optimization
1867     function _poolSupported(IConverterAnchor poolAnchor) internal view {
1868         require(_settings.isPoolSupported(poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1869     }
1870 
1871     // error message binary size optimization
1872     function _poolWhitelisted(IConverterAnchor poolAnchor) internal view {
1873         require(_settings.isPoolWhitelisted(poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1874     }
1875 
1876     // error message binary size optimization
1877     function _addLiquidityEnabled(IConverterAnchor poolAnchor, IReserveToken reserveToken) internal view {
1878         require(!_settings.addLiquidityDisabled(poolAnchor, reserveToken), "ERR_ADD_LIQUIDITY_DISABLED");
1879     }
1880 
1881     // error message binary size optimization
1882     function verifyEthAmount(uint256 value) internal view {
1883         require(msg.value == value, "ERR_ETH_AMOUNT_MISMATCH");
1884     }
1885 
1886     /**
1887      * @dev returns the LP store
1888      *
1889      * @return the LP store
1890      */
1891     function store() external view override returns (ILiquidityProtectionStore) {
1892         return _store;
1893     }
1894 
1895     /**
1896      * @dev returns the LP stats
1897      *
1898      * @return the LP stats
1899      */
1900     function stats() external view override returns (ILiquidityProtectionStats) {
1901         return _stats;
1902     }
1903 
1904     /**
1905      * @dev returns the LP settings
1906      *
1907      * @return the LP settings
1908      */
1909     function settings() external view override returns (ILiquidityProtectionSettings) {
1910         return _settings;
1911     }
1912 
1913     /**
1914      * @dev returns the LP system store
1915      *
1916      * @return the LP system store
1917      */
1918     function systemStore() external view override returns (ILiquidityProtectionSystemStore) {
1919         return _systemStore;
1920     }
1921 
1922     /**
1923      * @dev returns the LP wallet
1924      *
1925      * @return the LP wallet
1926      */
1927     function wallet() external view override returns (ITokenHolder) {
1928         return _wallet;
1929     }
1930 
1931     /**
1932      * @dev accept ETH
1933      */
1934     receive() external payable {}
1935 
1936     /**
1937      * @dev transfers the ownership of the store
1938      * can only be called by the contract owner
1939      *
1940      * @param newOwner the new owner of the store
1941      */
1942     function transferStoreOwnership(address newOwner) external ownerOnly {
1943         _store.transferOwnership(newOwner);
1944     }
1945 
1946     /**
1947      * @dev accepts the ownership of the store
1948      * can only be called by the contract owner
1949      */
1950     function acceptStoreOwnership() external ownerOnly {
1951         _store.acceptOwnership();
1952     }
1953 
1954     /**
1955      * @dev transfers the ownership of the wallet
1956      * can only be called by the contract owner
1957      *
1958      * @param newOwner the new owner of the wallet
1959      */
1960     function transferWalletOwnership(address newOwner) external ownerOnly {
1961         _wallet.transferOwnership(newOwner);
1962     }
1963 
1964     /**
1965      * @dev accepts the ownership of the wallet
1966      * can only be called by the contract owner
1967      */
1968     function acceptWalletOwnership() external ownerOnly {
1969         _wallet.acceptOwnership();
1970     }
1971 
1972     /**
1973      * @dev adds protected liquidity to a pool for a specific recipient
1974      * also mints new governance tokens for the caller if the caller adds network tokens
1975      *
1976      * @param owner position owner
1977      * @param poolAnchor anchor of the pool
1978      * @param reserveToken reserve token to add to the pool
1979      * @param amount amount of tokens to add to the pool
1980      *
1981      * @return new position id
1982      */
1983     function addLiquidityFor(
1984         address owner,
1985         IConverterAnchor poolAnchor,
1986         IReserveToken reserveToken,
1987         uint256 amount
1988     )
1989         external
1990         payable
1991         override
1992         protected
1993         validAddress(owner)
1994         poolSupportedAndWhitelisted(poolAnchor)
1995         addLiquidityEnabled(poolAnchor, reserveToken)
1996         greaterThanZero(amount)
1997         returns (uint256)
1998     {
1999         return addLiquidity(owner, poolAnchor, reserveToken, amount);
2000     }
2001 
2002     /**
2003      * @dev adds protected liquidity to a pool
2004      * also mints new governance tokens for the caller if the caller adds network tokens
2005      *
2006      * @param poolAnchor anchor of the pool
2007      * @param reserveToken reserve token to add to the pool
2008      * @param amount amount of tokens to add to the pool
2009      *
2010      * @return new position id
2011      */
2012     function addLiquidity(
2013         IConverterAnchor poolAnchor,
2014         IReserveToken reserveToken,
2015         uint256 amount
2016     )
2017         external
2018         payable
2019         override
2020         protected
2021         poolSupportedAndWhitelisted(poolAnchor)
2022         addLiquidityEnabled(poolAnchor, reserveToken)
2023         greaterThanZero(amount)
2024         returns (uint256)
2025     {
2026         return addLiquidity(msg.sender, poolAnchor, reserveToken, amount);
2027     }
2028 
2029     /**
2030      * @dev adds protected liquidity to a pool for a specific recipient
2031      * also mints new governance tokens for the caller if the caller adds network tokens
2032      *
2033      * @param owner position owner
2034      * @param poolAnchor anchor of the pool
2035      * @param reserveToken reserve token to add to the pool
2036      * @param amount amount of tokens to add to the pool
2037      *
2038      * @return new position id
2039      */
2040     function addLiquidity(
2041         address owner,
2042         IConverterAnchor poolAnchor,
2043         IReserveToken reserveToken,
2044         uint256 amount
2045     ) private returns (uint256) {
2046         if (isNetworkToken(reserveToken)) {
2047             verifyEthAmount(0);
2048             return addNetworkTokenLiquidity(owner, poolAnchor, amount);
2049         }
2050 
2051         // verify that ETH was passed with the call if needed
2052         verifyEthAmount(reserveToken.isNativeToken() ? amount : 0);
2053         return addBaseTokenLiquidity(owner, poolAnchor, reserveToken, amount);
2054     }
2055 
2056     /**
2057      * @dev adds network token liquidity to a pool
2058      * also mints new governance tokens for the caller
2059      *
2060      * @param owner position owner
2061      * @param poolAnchor anchor of the pool
2062      * @param amount amount of tokens to add to the pool
2063      *
2064      * @return new position id
2065      */
2066     function addNetworkTokenLiquidity(
2067         address owner,
2068         IConverterAnchor poolAnchor,
2069         uint256 amount
2070     ) internal returns (uint256) {
2071         IDSToken poolToken = IDSToken(address(poolAnchor));
2072         IReserveToken networkToken = IReserveToken(address(_networkToken));
2073 
2074         // get the rate between the pool token and the reserve
2075         Fraction memory poolRate = poolTokenRate(poolToken, networkToken);
2076 
2077         // calculate the amount of pool tokens based on the amount of reserve tokens
2078         uint256 poolTokenAmount = amount.mul(poolRate.d).div(poolRate.n);
2079 
2080         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
2081         _systemStore.decSystemBalance(poolToken, poolTokenAmount);
2082 
2083         // add the position for the recipient
2084         uint256 id = addPosition(owner, poolToken, networkToken, poolTokenAmount, amount, time());
2085 
2086         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
2087         // token holders can burn their tokens
2088         _networkToken.safeTransferFrom(msg.sender, address(this), amount);
2089         burnNetworkTokens(poolAnchor, amount);
2090 
2091         // mint governance tokens to the recipient
2092         _govTokenGovernance.mint(owner, amount);
2093 
2094         return id;
2095     }
2096 
2097     /**
2098      * @dev adds base token liquidity to a pool
2099      *
2100      * @param owner position owner
2101      * @param poolAnchor anchor of the pool
2102      * @param baseToken the base reserve token of the pool
2103      * @param amount amount of tokens to add to the pool
2104      *
2105      * @return new position id
2106      */
2107     function addBaseTokenLiquidity(
2108         address owner,
2109         IConverterAnchor poolAnchor,
2110         IReserveToken baseToken,
2111         uint256 amount
2112     ) internal returns (uint256) {
2113         IDSToken poolToken = IDSToken(address(poolAnchor));
2114         IReserveToken networkToken = IReserveToken(address(_networkToken));
2115 
2116         // get the reserve balances
2117         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolAnchor)));
2118         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
2119             converterReserveBalances(converter, baseToken, networkToken);
2120 
2121         require(reserveBalanceNetwork >= _settings.minNetworkTokenLiquidityForMinting(), "ERR_NOT_ENOUGH_LIQUIDITY");
2122 
2123         // calculate and mint the required amount of network tokens for adding liquidity
2124         uint256 newNetworkLiquidityAmount = amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
2125 
2126         // verify network token minting limit
2127         uint256 mintingLimit = _settings.networkTokenMintingLimits(poolAnchor);
2128         if (mintingLimit == 0) {
2129             mintingLimit = _settings.defaultNetworkTokenMintingLimit();
2130         }
2131 
2132         uint256 newNetworkTokensMinted = _systemStore.networkTokensMinted(poolAnchor).add(newNetworkLiquidityAmount);
2133         require(newNetworkTokensMinted <= mintingLimit, "ERR_MAX_AMOUNT_REACHED");
2134 
2135         // issue new network tokens to the system
2136         mintNetworkTokens(address(this), poolAnchor, newNetworkLiquidityAmount);
2137 
2138         // transfer the base tokens from the caller and approve the converter
2139         networkToken.ensureApprove(address(converter), newNetworkLiquidityAmount);
2140 
2141         if (!baseToken.isNativeToken()) {
2142             baseToken.safeTransferFrom(msg.sender, address(this), amount);
2143             baseToken.ensureApprove(address(converter), amount);
2144         }
2145 
2146         // add the liquidity to the converter
2147         addLiquidity(converter, baseToken, networkToken, amount, newNetworkLiquidityAmount, msg.value);
2148 
2149         // transfer the new pool tokens to the wallet
2150         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
2151         poolToken.safeTransfer(address(_wallet), poolTokenAmount);
2152 
2153         // the system splits the pool tokens with the caller
2154         // increase the system's pool token balance and add the position for the caller
2155         _systemStore.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
2156 
2157         return addPosition(owner, poolToken, baseToken, poolTokenAmount / 2, amount, time());
2158     }
2159 
2160     /**
2161      * @dev returns the single-side staking limits of a given pool
2162      *
2163      * @param poolAnchor anchor of the pool
2164      *
2165      * @return maximum amount of base tokens that can be single-side staked in the pool
2166      * @return maximum amount of network tokens that can be single-side staked in the pool
2167      */
2168     function poolAvailableSpace(IConverterAnchor poolAnchor)
2169         external
2170         view
2171         poolSupportedAndWhitelisted(poolAnchor)
2172         returns (uint256, uint256)
2173     {
2174         return (baseTokenAvailableSpace(poolAnchor), networkTokenAvailableSpace(poolAnchor));
2175     }
2176 
2177     /**
2178      * @dev returns the base-token staking limits of a given pool
2179      *
2180      * @param poolAnchor anchor of the pool
2181      *
2182      * @return maximum amount of base tokens that can be single-side staked in the pool
2183      */
2184     function baseTokenAvailableSpace(IConverterAnchor poolAnchor) internal view returns (uint256) {
2185         // get the pool converter
2186         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolAnchor)));
2187 
2188         // get the base token
2189         IReserveToken networkToken = IReserveToken(address(_networkToken));
2190         IReserveToken baseToken = converterOtherReserve(converter, networkToken);
2191 
2192         // get the reserve balances
2193         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
2194             converterReserveBalances(converter, baseToken, networkToken);
2195 
2196         // get the network token minting limit
2197         uint256 mintingLimit = _settings.networkTokenMintingLimits(poolAnchor);
2198         if (mintingLimit == 0) {
2199             mintingLimit = _settings.defaultNetworkTokenMintingLimit();
2200         }
2201 
2202         // get the amount of network tokens already minted for the pool
2203         uint256 networkTokensMinted = _systemStore.networkTokensMinted(poolAnchor);
2204 
2205         // get the amount of network tokens which can minted for the pool
2206         uint256 networkTokensCanBeMinted = MathEx.max(mintingLimit, networkTokensMinted) - networkTokensMinted;
2207 
2208         // return the maximum amount of base token liquidity that can be single-sided staked in the pool
2209         return networkTokensCanBeMinted.mul(reserveBalanceBase).div(reserveBalanceNetwork);
2210     }
2211 
2212     /**
2213      * @dev returns the network-token staking limits of a given pool
2214      *
2215      * @param poolAnchor anchor of the pool
2216      *
2217      * @return maximum amount of network tokens that can be single-side staked in the pool
2218      */
2219     function networkTokenAvailableSpace(IConverterAnchor poolAnchor) internal view returns (uint256) {
2220         // get the pool token
2221         IDSToken poolToken = IDSToken(address(poolAnchor));
2222         IReserveToken networkToken = IReserveToken(address(_networkToken));
2223 
2224         // get the pool token rate
2225         Fraction memory poolRate = poolTokenRate(poolToken, networkToken);
2226 
2227         // return the maximum amount of network token liquidity that can be single-sided staked in the pool
2228         return _systemStore.systemBalance(poolToken).mul(poolRate.n).add(poolRate.n).sub(1).div(poolRate.d);
2229     }
2230 
2231     /**
2232      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
2233      * it's also possible to provide the remove liquidity time to get an estimation
2234      * for the return at that given point
2235      *
2236      * @param id position id
2237      * @param portion portion of liquidity to remove, in PPM
2238      * @param removeTimestamp time at which the liquidity is removed
2239      *
2240      * @return expected return amount in the reserve token
2241      * @return actual return amount in the reserve token
2242      * @return compensation in the network token
2243      */
2244     function removeLiquidityReturn(
2245         uint256 id,
2246         uint32 portion,
2247         uint256 removeTimestamp
2248     )
2249         external
2250         view
2251         validPortion(portion)
2252         returns (
2253             uint256,
2254             uint256,
2255             uint256
2256         )
2257     {
2258         Position memory pos = position(id);
2259 
2260         // verify input
2261         require(pos.provider != address(0), "ERR_INVALID_ID");
2262         require(removeTimestamp >= pos.timestamp, "ERR_INVALID_TIMESTAMP");
2263 
2264         // calculate the portion of the liquidity to remove
2265         if (portion != PPM_RESOLUTION) {
2266             pos.poolAmount = pos.poolAmount.mul(portion) / PPM_RESOLUTION;
2267             pos.reserveAmount = pos.reserveAmount.mul(portion) / PPM_RESOLUTION;
2268         }
2269 
2270         // get the various rates between the reserves upon adding liquidity and now
2271         PackedRates memory packedRates = packRates(pos.poolToken, pos.reserveToken, pos.reserveRateN, pos.reserveRateD);
2272 
2273         uint256 targetAmount =
2274             removeLiquidityTargetAmount(
2275                 pos.poolToken,
2276                 pos.reserveToken,
2277                 pos.poolAmount,
2278                 pos.reserveAmount,
2279                 packedRates,
2280                 pos.timestamp,
2281                 removeTimestamp
2282             );
2283 
2284         // for network token, the return amount is identical to the target amount
2285         if (isNetworkToken(pos.reserveToken)) {
2286             return (targetAmount, targetAmount, 0);
2287         }
2288 
2289         // handle base token return
2290 
2291         // calculate the amount of pool tokens required for liquidation
2292         // note that the amount is doubled since it's not possible to liquidate one reserve only
2293         Fraction memory poolRate = poolTokenRate(pos.poolToken, pos.reserveToken);
2294         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
2295 
2296         // limit the amount of pool tokens by the amount the system/caller holds
2297         uint256 availableBalance = _systemStore.systemBalance(pos.poolToken).add(pos.poolAmount);
2298         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
2299 
2300         // calculate the base token amount received by liquidating the pool tokens
2301         // note that the amount is divided by 2 since the pool amount represents both reserves
2302         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
2303         uint256 networkAmount = networkCompensation(targetAmount, baseAmount, packedRates);
2304 
2305         return (targetAmount, baseAmount, networkAmount);
2306     }
2307 
2308     /**
2309      * @dev removes protected liquidity from a pool
2310      * also burns governance tokens from the caller if the caller removes network tokens
2311      *
2312      * @param id position id
2313      * @param portion portion of liquidity to remove, in PPM
2314      */
2315     function removeLiquidity(uint256 id, uint32 portion) external override protected validPortion(portion) {
2316         removeLiquidity(msg.sender, id, portion);
2317     }
2318 
2319     /**
2320      * @dev removes a position from a pool
2321      * also burns governance tokens from the caller if the caller removes network tokens
2322      *
2323      * @param provider liquidity provider
2324      * @param id position id
2325      * @param portion portion of liquidity to remove, in PPM
2326      */
2327     function removeLiquidity(
2328         address payable provider,
2329         uint256 id,
2330         uint32 portion
2331     ) internal {
2332         // remove the position from the store and update the stats and the last removal checkpoint
2333         Position memory removedPos = removePosition(provider, id, portion);
2334 
2335         // add the pool tokens to the system
2336         _systemStore.incSystemBalance(removedPos.poolToken, removedPos.poolAmount);
2337 
2338         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
2339         // tokens to the contract itself, since only token holders can burn their tokens
2340         if (isNetworkToken(removedPos.reserveToken)) {
2341             _govToken.safeTransferFrom(provider, address(this), removedPos.reserveAmount);
2342             _govTokenGovernance.burn(removedPos.reserveAmount);
2343         }
2344 
2345         // get the various rates between the reserves upon adding liquidity and now
2346         PackedRates memory packedRates =
2347             packRates(removedPos.poolToken, removedPos.reserveToken, removedPos.reserveRateN, removedPos.reserveRateD);
2348 
2349         // verify rate deviation as early as possible in order to reduce gas-cost for failing transactions
2350         verifyRateDeviation(
2351             packedRates.removeSpotRateN,
2352             packedRates.removeSpotRateD,
2353             packedRates.removeAverageRateN,
2354             packedRates.removeAverageRateD
2355         );
2356 
2357         // get the target token amount
2358         uint256 targetAmount =
2359             removeLiquidityTargetAmount(
2360                 removedPos.poolToken,
2361                 removedPos.reserveToken,
2362                 removedPos.poolAmount,
2363                 removedPos.reserveAmount,
2364                 packedRates,
2365                 removedPos.timestamp,
2366                 time()
2367             );
2368 
2369         // remove network token liquidity
2370         if (isNetworkToken(removedPos.reserveToken)) {
2371             // mint network tokens for the caller and lock them
2372             mintNetworkTokens(address(_wallet), removedPos.poolToken, targetAmount);
2373             lockTokens(provider, targetAmount);
2374 
2375             return;
2376         }
2377 
2378         // remove base token liquidity
2379 
2380         // calculate the amount of pool tokens required for liquidation
2381         // note that the amount is doubled since it's not possible to liquidate one reserve only
2382         Fraction memory poolRate = poolTokenRate(removedPos.poolToken, removedPos.reserveToken);
2383         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
2384 
2385         // limit the amount of pool tokens by the amount the system holds
2386         uint256 systemBalance = _systemStore.systemBalance(removedPos.poolToken);
2387         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
2388 
2389         // withdraw the pool tokens from the wallet
2390         IReserveToken poolToken = IReserveToken(address(removedPos.poolToken));
2391         _systemStore.decSystemBalance(removedPos.poolToken, poolAmount);
2392         _wallet.withdrawTokens(poolToken, address(this), poolAmount);
2393 
2394         // remove liquidity
2395         removeLiquidity(
2396             removedPos.poolToken,
2397             poolAmount,
2398             removedPos.reserveToken,
2399             IReserveToken(address(_networkToken))
2400         );
2401 
2402         // transfer the base tokens to the caller
2403         uint256 baseBalance = removedPos.reserveToken.balanceOf(address(this));
2404         removedPos.reserveToken.safeTransfer(provider, baseBalance);
2405 
2406         // compensate the caller with network tokens if still needed
2407         uint256 delta = networkCompensation(targetAmount, baseBalance, packedRates);
2408         if (delta > 0) {
2409             // check if there's enough network token balance, otherwise mint more
2410             uint256 networkBalance = _networkToken.balanceOf(address(this));
2411             if (networkBalance < delta) {
2412                 _networkTokenGovernance.mint(address(this), delta - networkBalance);
2413             }
2414 
2415             // lock network tokens for the caller
2416             _networkToken.safeTransfer(address(_wallet), delta);
2417             lockTokens(provider, delta);
2418         }
2419 
2420         // if the contract still holds network tokens, burn them
2421         uint256 networkBalance = _networkToken.balanceOf(address(this));
2422         if (networkBalance > 0) {
2423             burnNetworkTokens(removedPos.poolToken, networkBalance);
2424         }
2425     }
2426 
2427     /**
2428      * @dev returns the amount the provider will receive for removing liquidity
2429      * it's also possible to provide the remove liquidity rate & time to get an estimation
2430      * for the return at that given point
2431      *
2432      * @param poolToken pool token
2433      * @param reserveToken reserve token
2434      * @param poolAmount pool token amount when the liquidity was added
2435      * @param reserveAmount reserve token amount that was added
2436      * @param packedRates see `struct PackedRates`
2437      * @param addTimestamp time at which the liquidity was added
2438      * @param removeTimestamp time at which the liquidity is removed
2439      *
2440      * @return amount received for removing liquidity
2441      */
2442     function removeLiquidityTargetAmount(
2443         IDSToken poolToken,
2444         IReserveToken reserveToken,
2445         uint256 poolAmount,
2446         uint256 reserveAmount,
2447         PackedRates memory packedRates,
2448         uint256 addTimestamp,
2449         uint256 removeTimestamp
2450     ) internal view returns (uint256) {
2451         // get the rate between the pool token and the reserve token
2452         Fraction memory poolRate = poolTokenRate(poolToken, reserveToken);
2453 
2454         // get the rate between the reserves upon adding liquidity and now
2455         Fraction memory addSpotRate = Fraction({ n: packedRates.addSpotRateN, d: packedRates.addSpotRateD });
2456         Fraction memory removeSpotRate = Fraction({ n: packedRates.removeSpotRateN, d: packedRates.removeSpotRateD });
2457         Fraction memory removeAverageRate =
2458             Fraction({ n: packedRates.removeAverageRateN, d: packedRates.removeAverageRateD });
2459 
2460         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
2461         uint256 total = protectedAmountPlusFee(poolAmount, poolRate, addSpotRate, removeSpotRate);
2462 
2463         // calculate the impermanent loss
2464         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
2465 
2466         // calculate the protection level
2467         Fraction memory level = protectionLevel(addTimestamp, removeTimestamp);
2468 
2469         // calculate the compensation amount
2470         return compensationAmount(reserveAmount, MathEx.max(reserveAmount, total), loss, level);
2471     }
2472 
2473     /**
2474      * @dev transfers a position to a new provider
2475      *
2476      * @param id position id
2477      * @param newProvider the new provider
2478      *
2479      * @return new position id
2480      */
2481     function transferPosition(uint256 id, address newProvider)
2482         external
2483         protected
2484         validAddress(newProvider)
2485         returns (uint256)
2486     {
2487         return transferPosition(msg.sender, id, newProvider);
2488     }
2489 
2490     /**
2491      * @dev transfers a position to a new provider and optionally notifies another contract
2492      *
2493      * @param id position id
2494      * @param newProvider the new provider
2495      * @param target the contract to notify
2496      * @param data the data to call the contract with
2497      *
2498      * @return new position id
2499      */
2500     function transferPositionAndCall(
2501         uint256 id,
2502         address newProvider,
2503         address target,
2504         bytes memory data
2505     ) external protected validAddress(newProvider) validAddress(target) returns (uint256) {
2506         // make sure that we're not trying to call into the zero address or a fallback function
2507         require(data.length >= FUNC_SELECTOR_LENGTH, "ERR_INVALID_CALL_DATA");
2508 
2509         uint256 newId = transferPosition(msg.sender, id, newProvider);
2510 
2511         Address.functionCall(target, data, "ERR_CALL_FAILED");
2512 
2513         return newId;
2514     }
2515 
2516     /**
2517      * @dev transfers a position to a new provider
2518      *
2519      * @param provider the existing provider
2520      * @param id position id
2521      * @param newProvider the new provider
2522      *
2523      * @return new position id
2524      */
2525     function transferPosition(
2526         address provider,
2527         uint256 id,
2528         address newProvider
2529     ) internal returns (uint256) {
2530         // remove the position from the store and update the stats and the last removal checkpoint
2531         Position memory removedPos = removePosition(provider, id, PPM_RESOLUTION);
2532 
2533         // add the position to the store, update the stats, and return the new id
2534         return
2535             addPosition(
2536                 newProvider,
2537                 removedPos.poolToken,
2538                 removedPos.reserveToken,
2539                 removedPos.poolAmount,
2540                 removedPos.reserveAmount,
2541                 removedPos.timestamp
2542             );
2543     }
2544 
2545     /**
2546      * @dev allows the caller to claim network token balance that is no longer locked
2547      * note that the function can revert if the range is too large
2548      *
2549      * @param startIndex start index in the caller's list of locked balances
2550      * @param endIndex end index in the caller's list of locked balances (exclusive)
2551      */
2552     function claimBalance(uint256 startIndex, uint256 endIndex) external protected {
2553         // get the locked balances from the store
2554         (uint256[] memory amounts, uint256[] memory expirationTimes) =
2555             _store.lockedBalanceRange(msg.sender, startIndex, endIndex);
2556 
2557         uint256 totalAmount = 0;
2558         uint256 length = amounts.length;
2559         assert(length == expirationTimes.length);
2560 
2561         // reverse iteration since we're removing from the list
2562         for (uint256 i = length; i > 0; i--) {
2563             uint256 index = i - 1;
2564             if (expirationTimes[index] > time()) {
2565                 continue;
2566             }
2567 
2568             // remove the locked balance item
2569             _store.removeLockedBalance(msg.sender, startIndex + index);
2570             totalAmount = totalAmount.add(amounts[index]);
2571         }
2572 
2573         if (totalAmount > 0) {
2574             // transfer the tokens to the caller in a single call
2575             _wallet.withdrawTokens(IReserveToken(address(_networkToken)), msg.sender, totalAmount);
2576         }
2577     }
2578 
2579     /**
2580      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
2581      * the function assumes full protection is in effect
2582      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
2583      *
2584      * @param poolToken pool token
2585      * @param reserveToken reserve token
2586      * @param reserveAmount reserve token amount that was added
2587      * @param poolRateN rate of 1 pool token in reserve token units when the liquidity was added (numerator)
2588      * @param poolRateD rate of 1 pool token in reserve token units when the liquidity was added (denominator)
2589      * @param reserveRateN rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
2590      * @param reserveRateD rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
2591      *
2592      * @return ROI in PPM
2593      */
2594     function poolROI(
2595         IDSToken poolToken,
2596         IReserveToken reserveToken,
2597         uint256 reserveAmount,
2598         uint256 poolRateN,
2599         uint256 poolRateD,
2600         uint256 reserveRateN,
2601         uint256 reserveRateD
2602     ) external view returns (uint256) {
2603         // calculate the amount of pool tokens based on the amount of reserve tokens
2604         uint256 poolAmount = reserveAmount.mul(poolRateD).div(poolRateN);
2605 
2606         // get the various rates between the reserves upon adding liquidity and now
2607         PackedRates memory packedRates = packRates(poolToken, reserveToken, reserveRateN, reserveRateD);
2608 
2609         // get the current return
2610         uint256 protectedReturn =
2611             removeLiquidityTargetAmount(
2612                 poolToken,
2613                 reserveToken,
2614                 poolAmount,
2615                 reserveAmount,
2616                 packedRates,
2617                 time().sub(_settings.maxProtectionDelay()),
2618                 time()
2619             );
2620 
2621         // calculate the ROI as the ratio between the current fully protected return and the initial amount
2622         return protectedReturn.mul(PPM_RESOLUTION).div(reserveAmount);
2623     }
2624 
2625     /**
2626      * @dev adds the position to the store and updates the stats
2627      *
2628      * @param provider the provider
2629      * @param poolToken pool token
2630      * @param reserveToken reserve token
2631      * @param poolAmount amount of pool tokens to protect
2632      * @param reserveAmount amount of reserve tokens to protect
2633      * @param timestamp the timestamp of the position
2634      *
2635      * @return new position id
2636      */
2637     function addPosition(
2638         address provider,
2639         IDSToken poolToken,
2640         IReserveToken reserveToken,
2641         uint256 poolAmount,
2642         uint256 reserveAmount,
2643         uint256 timestamp
2644     ) internal returns (uint256) {
2645         // verify rate deviation as early as possible in order to reduce gas-cost for failing transactions
2646         (Fraction memory spotRate, Fraction memory averageRate) = reserveTokenRates(poolToken, reserveToken);
2647         verifyRateDeviation(spotRate.n, spotRate.d, averageRate.n, averageRate.d);
2648 
2649         notifyEventSubscribersOnAddingLiquidity(provider, poolToken, reserveToken, poolAmount, reserveAmount);
2650 
2651         _stats.increaseTotalAmounts(provider, poolToken, reserveToken, poolAmount, reserveAmount);
2652         _stats.addProviderPool(provider, poolToken);
2653 
2654         return
2655             _store.addProtectedLiquidity(
2656                 provider,
2657                 poolToken,
2658                 reserveToken,
2659                 poolAmount,
2660                 reserveAmount,
2661                 spotRate.n,
2662                 spotRate.d,
2663                 timestamp
2664             );
2665     }
2666 
2667     /**
2668      * @dev removes the position from the store and updates the stats and the last removal checkpoint
2669      *
2670      * @param provider the provider
2671      * @param id position id
2672      * @param portion portion of the position to remove, in PPM
2673      *
2674      * @return a Position struct representing the removed liquidity
2675      */
2676     function removePosition(
2677         address provider,
2678         uint256 id,
2679         uint32 portion
2680     ) private returns (Position memory) {
2681         Position memory pos = providerPosition(id, provider);
2682 
2683         // verify that the pool is whitelisted
2684         _poolWhitelisted(pos.poolToken);
2685 
2686         // verify that the position is not removed on the same block in which it was added
2687         require(pos.timestamp < time(), "ERR_TOO_EARLY");
2688 
2689         if (portion == PPM_RESOLUTION) {
2690             notifyEventSubscribersOnRemovingLiquidity(
2691                 id,
2692                 pos.provider,
2693                 pos.poolToken,
2694                 pos.reserveToken,
2695                 pos.poolAmount,
2696                 pos.reserveAmount
2697             );
2698 
2699             // remove the position from the provider
2700             _store.removeProtectedLiquidity(id);
2701         } else {
2702             // remove a portion of the position from the provider
2703             uint256 fullPoolAmount = pos.poolAmount;
2704             uint256 fullReserveAmount = pos.reserveAmount;
2705             pos.poolAmount = pos.poolAmount.mul(portion) / PPM_RESOLUTION;
2706             pos.reserveAmount = pos.reserveAmount.mul(portion) / PPM_RESOLUTION;
2707 
2708             notifyEventSubscribersOnRemovingLiquidity(
2709                 id,
2710                 pos.provider,
2711                 pos.poolToken,
2712                 pos.reserveToken,
2713                 pos.poolAmount,
2714                 pos.reserveAmount
2715             );
2716 
2717             _store.updateProtectedLiquidityAmounts(
2718                 id,
2719                 fullPoolAmount - pos.poolAmount,
2720                 fullReserveAmount - pos.reserveAmount
2721             );
2722         }
2723 
2724         // update the statistics
2725         _stats.decreaseTotalAmounts(pos.provider, pos.poolToken, pos.reserveToken, pos.poolAmount, pos.reserveAmount);
2726 
2727         // update last liquidity removal checkpoint
2728         _lastRemoveCheckpointStore.addCheckpoint(provider);
2729 
2730         return pos;
2731     }
2732 
2733     /**
2734      * @dev locks network tokens for the provider and emits the tokens locked event
2735      *
2736      * @param provider tokens provider
2737      * @param amount amount of network tokens
2738      */
2739     function lockTokens(address provider, uint256 amount) internal {
2740         uint256 expirationTime = time().add(_settings.lockDuration());
2741         _store.addLockedBalance(provider, amount, expirationTime);
2742     }
2743 
2744     /**
2745      * @dev returns the rate of 1 pool token in reserve token units
2746      *
2747      * @param poolToken pool token
2748      * @param reserveToken reserve token
2749      */
2750     function poolTokenRate(IDSToken poolToken, IReserveToken reserveToken)
2751         internal
2752         view
2753         virtual
2754         returns (Fraction memory)
2755     {
2756         // get the pool token supply
2757         uint256 poolTokenSupply = poolToken.totalSupply();
2758 
2759         // get the reserve balance
2760         IConverter converter = IConverter(payable(ownedBy(poolToken)));
2761         uint256 reserveBalance = converter.getConnectorBalance(reserveToken);
2762 
2763         // for standard pools, 50% of the pool supply value equals the value of each reserve
2764         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
2765     }
2766 
2767     /**
2768      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
2769      *
2770      * @param poolToken pool token
2771      * @param reserveToken reserve token
2772      *
2773      * @return spot rate
2774      * @return average rate
2775      */
2776     function reserveTokenRates(IDSToken poolToken, IReserveToken reserveToken)
2777         internal
2778         view
2779         returns (Fraction memory, Fraction memory)
2780     {
2781         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolToken)));
2782         IReserveToken otherReserve = converterOtherReserve(converter, reserveToken);
2783 
2784         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, reserveToken);
2785         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(reserveToken);
2786 
2787         return (Fraction({ n: spotRateN, d: spotRateD }), Fraction({ n: averageRateN, d: averageRateD }));
2788     }
2789 
2790     /**
2791      * @dev returns the various rates between the reserves
2792      *
2793      * @param poolToken pool token
2794      * @param reserveToken reserve token
2795      * @param addSpotRateN add spot rate numerator
2796      * @param addSpotRateD add spot rate denominator
2797      *
2798      * @return see `struct PackedRates`
2799      */
2800     function packRates(
2801         IDSToken poolToken,
2802         IReserveToken reserveToken,
2803         uint256 addSpotRateN,
2804         uint256 addSpotRateD
2805     ) internal view returns (PackedRates memory) {
2806         (Fraction memory removeSpotRate, Fraction memory removeAverageRate) =
2807             reserveTokenRates(poolToken, reserveToken);
2808 
2809         assert(
2810             addSpotRateN <= MAX_UINT128 &&
2811                 addSpotRateD <= MAX_UINT128 &&
2812                 removeSpotRate.n <= MAX_UINT128 &&
2813                 removeSpotRate.d <= MAX_UINT128 &&
2814                 removeAverageRate.n <= MAX_UINT128 &&
2815                 removeAverageRate.d <= MAX_UINT128
2816         );
2817 
2818         return
2819             PackedRates({
2820                 addSpotRateN: uint128(addSpotRateN),
2821                 addSpotRateD: uint128(addSpotRateD),
2822                 removeSpotRateN: uint128(removeSpotRate.n),
2823                 removeSpotRateD: uint128(removeSpotRate.d),
2824                 removeAverageRateN: uint128(removeAverageRate.n),
2825                 removeAverageRateD: uint128(removeAverageRate.d)
2826             });
2827     }
2828 
2829     /**
2830      * @dev verifies that the deviation of the average rate from the spot rate is within the permitted range
2831      * for example, if the maximum permitted deviation is 5%, then verify `95/100 <= average/spot <= 100/95`
2832      *
2833      * @param spotRateN spot rate numerator
2834      * @param spotRateD spot rate denominator
2835      * @param averageRateN average rate numerator
2836      * @param averageRateD average rate denominator
2837      */
2838     function verifyRateDeviation(
2839         uint256 spotRateN,
2840         uint256 spotRateD,
2841         uint256 averageRateN,
2842         uint256 averageRateD
2843     ) internal view {
2844         uint256 ppmDelta = PPM_RESOLUTION - _settings.averageRateMaxDeviation();
2845         uint256 min = spotRateN.mul(averageRateD).mul(ppmDelta).mul(ppmDelta);
2846         uint256 mid = spotRateD.mul(averageRateN).mul(ppmDelta).mul(PPM_RESOLUTION);
2847         uint256 max = spotRateN.mul(averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2848         require(min <= mid && mid <= max, "ERR_INVALID_RATE");
2849     }
2850 
2851     /**
2852      * @dev utility to add liquidity to a converter
2853      *
2854      * @param converter converter
2855      * @param reserveToken1 reserve token 1
2856      * @param reserveToken2 reserve token 2
2857      * @param reserveAmount1 reserve amount 1
2858      * @param reserveAmount2 reserve amount 2
2859      * @param value ETH amount to add
2860      */
2861     function addLiquidity(
2862         ILiquidityPoolConverter converter,
2863         IReserveToken reserveToken1,
2864         IReserveToken reserveToken2,
2865         uint256 reserveAmount1,
2866         uint256 reserveAmount2,
2867         uint256 value
2868     ) internal {
2869         IReserveToken[] memory reserveTokens = new IReserveToken[](2);
2870         uint256[] memory amounts = new uint256[](2);
2871         reserveTokens[0] = reserveToken1;
2872         reserveTokens[1] = reserveToken2;
2873         amounts[0] = reserveAmount1;
2874         amounts[1] = reserveAmount2;
2875         converter.addLiquidity{ value: value }(reserveTokens, amounts, 1);
2876     }
2877 
2878     /**
2879      * @dev utility to remove liquidity from a converter
2880      *
2881      * @param poolToken pool token of the converter
2882      * @param poolAmount amount of pool tokens to remove
2883      * @param reserveToken1 reserve token 1
2884      * @param reserveToken2 reserve token 2
2885      */
2886     function removeLiquidity(
2887         IDSToken poolToken,
2888         uint256 poolAmount,
2889         IReserveToken reserveToken1,
2890         IReserveToken reserveToken2
2891     ) internal {
2892         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolToken)));
2893 
2894         IReserveToken[] memory reserveTokens = new IReserveToken[](2);
2895         uint256[] memory minReturns = new uint256[](2);
2896         reserveTokens[0] = reserveToken1;
2897         reserveTokens[1] = reserveToken2;
2898         minReturns[0] = 1;
2899         minReturns[1] = 1;
2900         converter.removeLiquidity(poolAmount, reserveTokens, minReturns);
2901     }
2902 
2903     /**
2904      * @dev returns a position from the store
2905      *
2906      * @param id position id
2907      *
2908      * @return a position
2909      */
2910     function position(uint256 id) internal view returns (Position memory) {
2911         Position memory pos;
2912         (
2913             pos.provider,
2914             pos.poolToken,
2915             pos.reserveToken,
2916             pos.poolAmount,
2917             pos.reserveAmount,
2918             pos.reserveRateN,
2919             pos.reserveRateD,
2920             pos.timestamp
2921         ) = _store.protectedLiquidity(id);
2922 
2923         return pos;
2924     }
2925 
2926     /**
2927      * @dev returns a position from the store
2928      *
2929      * @param id position id
2930      * @param provider authorized provider
2931      *
2932      * @return a position
2933      */
2934     function providerPosition(uint256 id, address provider) internal view returns (Position memory) {
2935         Position memory pos = position(id);
2936         require(pos.provider == provider, "ERR_ACCESS_DENIED");
2937 
2938         return pos;
2939     }
2940 
2941     /**
2942      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2943      *
2944      * @param poolAmount pool token amount when the liquidity was added
2945      * @param poolRate rate of 1 pool token in the related reserve token units
2946      * @param addRate rate of 1 reserve token in the other reserve token units when the liquidity was added
2947      * @param removeRate rate of 1 reserve token in the other reserve token units when the liquidity is removed
2948      *
2949      * @return protected amount of reserve tokens plus accumulated fee = sqrt(removeRate / addRate) * poolRate * poolAmount
2950      */
2951     function protectedAmountPlusFee(
2952         uint256 poolAmount,
2953         Fraction memory poolRate,
2954         Fraction memory addRate,
2955         Fraction memory removeRate
2956     ) internal pure returns (uint256) {
2957         uint256 n = MathEx.ceilSqrt(addRate.d.mul(removeRate.n)).mul(poolRate.n);
2958         uint256 d = MathEx.floorSqrt(addRate.n.mul(removeRate.d)).mul(poolRate.d);
2959 
2960         uint256 x = n * poolAmount;
2961         if (x / n == poolAmount) {
2962             return x / d;
2963         }
2964 
2965         (uint256 hi, uint256 lo) = n > poolAmount ? (n, poolAmount) : (poolAmount, n);
2966         (uint256 p, uint256 q) = MathEx.reducedRatio(hi, d, MAX_UINT256 / lo);
2967         uint256 min = (hi / d).mul(lo);
2968 
2969         if (q > 0) {
2970             return MathEx.max(min, (p * lo) / q);
2971         }
2972         return min;
2973     }
2974 
2975     /**
2976      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
2977      *
2978      * @param prevRate previous rate between the reserves
2979      * @param newRate new rate between the reserves
2980      *
2981      * @return impermanent loss (as a ratio)
2982      */
2983     function impLoss(Fraction memory prevRate, Fraction memory newRate) internal pure returns (Fraction memory) {
2984         uint256 ratioN = newRate.n.mul(prevRate.d);
2985         uint256 ratioD = newRate.d.mul(prevRate.n);
2986 
2987         uint256 prod = ratioN * ratioD;
2988         uint256 root =
2989             prod / ratioN == ratioD ? MathEx.floorSqrt(prod) : MathEx.floorSqrt(ratioN) * MathEx.floorSqrt(ratioD);
2990         uint256 sum = ratioN.add(ratioD);
2991 
2992         // the arithmetic below is safe because `x + y >= sqrt(x * y) * 2`
2993         if (sum % 2 == 0) {
2994             sum /= 2;
2995             return Fraction({ n: sum - root, d: sum });
2996         }
2997         return Fraction({ n: sum - root * 2, d: sum });
2998     }
2999 
3000     /**
3001      * @dev returns the protection level based on the timestamp and protection delays
3002      *
3003      * @param addTimestamp time at which the liquidity was added
3004      * @param removeTimestamp time at which the liquidity is removed
3005      *
3006      * @return protection level (as a ratio)
3007      */
3008     function protectionLevel(uint256 addTimestamp, uint256 removeTimestamp) internal view returns (Fraction memory) {
3009         uint256 timeElapsed = removeTimestamp.sub(addTimestamp);
3010         uint256 minProtectionDelay = _settings.minProtectionDelay();
3011         uint256 maxProtectionDelay = _settings.maxProtectionDelay();
3012         if (timeElapsed < minProtectionDelay) {
3013             return Fraction({ n: 0, d: 1 });
3014         }
3015 
3016         if (timeElapsed >= maxProtectionDelay) {
3017             return Fraction({ n: 1, d: 1 });
3018         }
3019 
3020         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
3021     }
3022 
3023     /**
3024      * @dev returns the compensation amount based on the impermanent loss and the protection level
3025      *
3026      * @param amount protected amount in units of the reserve token
3027      * @param total amount plus fee in units of the reserve token
3028      * @param loss protection level (as a ratio between 0 and 1)
3029      * @param level impermanent loss (as a ratio between 0 and 1)
3030      *
3031      * @return compensation amount
3032      */
3033     function compensationAmount(
3034         uint256 amount,
3035         uint256 total,
3036         Fraction memory loss,
3037         Fraction memory level
3038     ) internal pure returns (uint256) {
3039         uint256 levelN = level.n.mul(amount);
3040         uint256 levelD = level.d;
3041         uint256 maxVal = MathEx.max(MathEx.max(levelN, levelD), total);
3042         (uint256 lossN, uint256 lossD) = MathEx.reducedRatio(loss.n, loss.d, MAX_UINT256 / maxVal);
3043         return total.mul(lossD.sub(lossN)).div(lossD).add(lossN.mul(levelN).div(lossD.mul(levelD)));
3044     }
3045 
3046     function networkCompensation(
3047         uint256 targetAmount,
3048         uint256 baseAmount,
3049         PackedRates memory packedRates
3050     ) internal view returns (uint256) {
3051         if (targetAmount <= baseAmount) {
3052             return 0;
3053         }
3054 
3055         // calculate the delta in network tokens
3056         uint256 delta =
3057             (targetAmount - baseAmount).mul(packedRates.removeAverageRateN).div(packedRates.removeAverageRateD);
3058 
3059         // the delta might be very small due to precision loss
3060         // in which case no compensation will take place (gas optimization)
3061         if (delta >= _settings.minNetworkCompensation()) {
3062             return delta;
3063         }
3064 
3065         return 0;
3066     }
3067 
3068     // utility to mint network tokens
3069     function mintNetworkTokens(
3070         address owner,
3071         IConverterAnchor poolAnchor,
3072         uint256 amount
3073     ) private {
3074         _systemStore.incNetworkTokensMinted(poolAnchor, amount);
3075         _networkTokenGovernance.mint(owner, amount);
3076     }
3077 
3078     // utility to burn network tokens
3079     function burnNetworkTokens(IConverterAnchor poolAnchor, uint256 amount) private {
3080         _systemStore.decNetworkTokensMinted(poolAnchor, amount);
3081         _networkTokenGovernance.burn(amount);
3082     }
3083 
3084     /**
3085      * @dev notify event subscribers on adding liquidity
3086      *
3087      * @param provider liquidity provider
3088      * @param poolToken pool token
3089      * @param reserveToken reserve token
3090      * @param poolAmount amount of pool tokens to protect
3091      * @param reserveAmount amount of reserve tokens to protect
3092      */
3093     function notifyEventSubscribersOnAddingLiquidity(
3094         address provider,
3095         IDSToken poolToken,
3096         IReserveToken reserveToken,
3097         uint256 poolAmount,
3098         uint256 reserveAmount
3099     ) private {
3100         address[] memory subscribers = _settings.subscribers();
3101         uint256 length = subscribers.length;
3102         for (uint256 i = 0; i < length; i++) {
3103             ILiquidityProtectionEventsSubscriber(subscribers[i]).onAddingLiquidity(
3104                 provider,
3105                 poolToken,
3106                 reserveToken,
3107                 poolAmount,
3108                 reserveAmount
3109             );
3110         }
3111     }
3112 
3113     /**
3114      * @dev notify event subscribers on removing liquidity
3115      *
3116      * @param id position id
3117      * @param provider liquidity provider
3118      * @param poolToken pool token
3119      * @param reserveToken reserve token
3120      * @param poolAmount amount of pool tokens to protect
3121      * @param reserveAmount amount of reserve tokens to protect
3122      */
3123     function notifyEventSubscribersOnRemovingLiquidity(
3124         uint256 id,
3125         address provider,
3126         IDSToken poolToken,
3127         IReserveToken reserveToken,
3128         uint256 poolAmount,
3129         uint256 reserveAmount
3130     ) private {
3131         address[] memory subscribers = _settings.subscribers();
3132         uint256 length = subscribers.length;
3133         for (uint256 i = 0; i < length; i++) {
3134             ILiquidityProtectionEventsSubscriber(subscribers[i]).onRemovingLiquidity(
3135                 id,
3136                 provider,
3137                 poolToken,
3138                 reserveToken,
3139                 poolAmount,
3140                 reserveAmount
3141             );
3142         }
3143     }
3144 
3145     // utility to get the reserve balances
3146     function converterReserveBalances(
3147         IConverter converter,
3148         IReserveToken reserveToken1,
3149         IReserveToken reserveToken2
3150     ) private view returns (uint256, uint256) {
3151         return (converter.getConnectorBalance(reserveToken1), converter.getConnectorBalance(reserveToken2));
3152     }
3153 
3154     // utility to get the other reserve
3155     function converterOtherReserve(IConverter converter, IReserveToken thisReserve)
3156         private
3157         view
3158         returns (IReserveToken)
3159     {
3160         IReserveToken otherReserve = converter.connectorTokens(0);
3161         return otherReserve != thisReserve ? otherReserve : converter.connectorTokens(1);
3162     }
3163 
3164     // utility to get the owner
3165     function ownedBy(IOwned owned) private view returns (address) {
3166         return owned.owner();
3167     }
3168 
3169     /**
3170      * @dev returns whether the provided reserve token is the network token
3171      *
3172      * @return whether the provided reserve token is the network token
3173      */
3174     function isNetworkToken(IReserveToken reserveToken) private view returns (bool) {
3175         return address(reserveToken) == address(_networkToken);
3176     }
3177 }
