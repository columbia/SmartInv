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
1564 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProvisionEventsSubscriber.sol
1565 
1566 
1567 pragma solidity 0.6.12;
1568 
1569 
1570 
1571 /**
1572  * @dev Liquidity provision events subscriber interface
1573  */
1574 interface ILiquidityProvisionEventsSubscriber {
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
1656 // File: solidity/contracts/liquidity-protection/interfaces/ITransferPositionCallback.sol
1657 
1658 
1659 pragma solidity 0.6.12;
1660 
1661 /**
1662  * @dev Transfer position event callback interface
1663  */
1664 interface ITransferPositionCallback {
1665     function onTransferPosition(
1666         uint256 newId,
1667         address provider,
1668         bytes calldata data
1669     ) external;
1670 }
1671 
1672 // File: solidity/contracts/utility/interfaces/ITokenHolder.sol
1673 
1674 
1675 pragma solidity 0.6.12;
1676 
1677 
1678 
1679 /*
1680     Token Holder interface
1681 */
1682 interface ITokenHolder is IOwned {
1683     receive() external payable;
1684 
1685     function withdrawTokens(
1686         IReserveToken reserveToken,
1687         address payable to,
1688         uint256 amount
1689     ) external;
1690 
1691     function withdrawTokensMultiple(
1692         IReserveToken[] calldata reserveTokens,
1693         address payable to,
1694         uint256[] calldata amounts
1695     ) external;
1696 }
1697 
1698 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtection.sol
1699 
1700 
1701 pragma solidity 0.6.12;
1702 
1703 
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 /*
1712     Liquidity Protection interface
1713 */
1714 interface ILiquidityProtection {
1715     function store() external view returns (ILiquidityProtectionStore);
1716 
1717     function stats() external view returns (ILiquidityProtectionStats);
1718 
1719     function settings() external view returns (ILiquidityProtectionSettings);
1720 
1721     function systemStore() external view returns (ILiquidityProtectionSystemStore);
1722 
1723     function wallet() external view returns (ITokenHolder);
1724 
1725     function addLiquidityFor(
1726         address owner,
1727         IConverterAnchor poolAnchor,
1728         IReserveToken reserveToken,
1729         uint256 amount
1730     ) external payable returns (uint256);
1731 
1732     function addLiquidity(
1733         IConverterAnchor poolAnchor,
1734         IReserveToken reserveToken,
1735         uint256 amount
1736     ) external payable returns (uint256);
1737 
1738     function removeLiquidity(uint256 id, uint32 portion) external;
1739 
1740     function transferPosition(uint256 id, address newProvider) external returns (uint256);
1741 
1742     function transferPositionAndNotify(
1743         uint256 id,
1744         address newProvider,
1745         ITransferPositionCallback callback,
1746         bytes calldata data
1747     ) external returns (uint256);
1748 }
1749 
1750 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
1751 
1752 
1753 pragma solidity 0.6.12;
1754 
1755 
1756 
1757 
1758 
1759 
1760 
1761 
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 interface ILiquidityPoolConverter is IConverter {
1772     function addLiquidity(
1773         IReserveToken[] memory reserveTokens,
1774         uint256[] memory reserveAmounts,
1775         uint256 _minReturn
1776     ) external payable;
1777 
1778     function removeLiquidity(
1779         uint256 amount,
1780         IReserveToken[] memory reserveTokens,
1781         uint256[] memory _reserveMinReturnAmounts
1782     ) external;
1783 
1784     function recentAverageRate(IReserveToken reserveToken) external view returns (uint256, uint256);
1785 }
1786 
1787 /**
1788  * @dev This contract implements the liquidity protection mechanism.
1789  */
1790 contract LiquidityProtection is ILiquidityProtection, Utils, Owned, ReentrancyGuard, Time {
1791     using SafeMath for uint256;
1792     using ReserveToken for IReserveToken;
1793     using SafeERC20 for IERC20;
1794     using SafeERC20 for IDSToken;
1795     using SafeERC20Ex for IERC20;
1796     using MathEx for *;
1797 
1798     struct Position {
1799         address provider; // liquidity provider
1800         IDSToken poolToken; // pool token address
1801         IReserveToken reserveToken; // reserve token address
1802         uint256 poolAmount; // pool token amount
1803         uint256 reserveAmount; // reserve token amount
1804         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1805         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1806         uint256 timestamp; // timestamp
1807     }
1808 
1809     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1810     struct PackedRates {
1811         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1812         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1813         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1814         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1815         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1816         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1817     }
1818 
1819     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1820     uint256 internal constant MAX_UINT256 = uint256(-1);
1821 
1822     ILiquidityProtectionSettings private immutable _settings;
1823     ILiquidityProtectionStore private immutable _store;
1824     ILiquidityProtectionStats private immutable _stats;
1825     ILiquidityProtectionSystemStore private immutable _systemStore;
1826     ITokenHolder private immutable _wallet;
1827     IERC20 private immutable _networkToken;
1828     ITokenGovernance private immutable _networkTokenGovernance;
1829     IERC20 private immutable _govToken;
1830     ITokenGovernance private immutable _govTokenGovernance;
1831     ICheckpointStore private immutable _lastRemoveCheckpointStore;
1832 
1833     /**
1834      * @dev initializes a new LiquidityProtection contract
1835      *
1836      * @param settings liquidity protection settings
1837      * @param store liquidity protection store
1838      * @param stats liquidity protection stats
1839      * @param systemStore liquidity protection system store
1840      * @param wallet liquidity protection wallet
1841      * @param networkTokenGovernance network token governance
1842      * @param govTokenGovernance governance token governance
1843      * @param lastRemoveCheckpointStore last liquidity removal/unprotection checkpoints store
1844      */
1845     constructor(
1846         ILiquidityProtectionSettings settings,
1847         ILiquidityProtectionStore store,
1848         ILiquidityProtectionStats stats,
1849         ILiquidityProtectionSystemStore systemStore,
1850         ITokenHolder wallet,
1851         ITokenGovernance networkTokenGovernance,
1852         ITokenGovernance govTokenGovernance,
1853         ICheckpointStore lastRemoveCheckpointStore
1854     )
1855         public
1856         validAddress(address(settings))
1857         validAddress(address(store))
1858         validAddress(address(stats))
1859         validAddress(address(systemStore))
1860         validAddress(address(wallet))
1861         validAddress(address(lastRemoveCheckpointStore))
1862     {
1863         _settings = settings;
1864         _store = store;
1865         _stats = stats;
1866         _systemStore = systemStore;
1867         _wallet = wallet;
1868         _networkTokenGovernance = networkTokenGovernance;
1869         _govTokenGovernance = govTokenGovernance;
1870         _lastRemoveCheckpointStore = lastRemoveCheckpointStore;
1871 
1872         _networkToken = networkTokenGovernance.token();
1873         _govToken = govTokenGovernance.token();
1874     }
1875 
1876     // ensures that the pool is supported and whitelisted
1877     modifier poolSupportedAndWhitelisted(IConverterAnchor poolAnchor) {
1878         _poolSupported(poolAnchor);
1879         _poolWhitelisted(poolAnchor);
1880 
1881         _;
1882     }
1883 
1884     // ensures that add liquidity is enabled
1885     modifier addLiquidityEnabled(IConverterAnchor poolAnchor, IReserveToken reserveToken) {
1886         _addLiquidityEnabled(poolAnchor, reserveToken);
1887 
1888         _;
1889     }
1890 
1891     // error message binary size optimization
1892     function _poolSupported(IConverterAnchor poolAnchor) internal view {
1893         require(_settings.isPoolSupported(poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1894     }
1895 
1896     // error message binary size optimization
1897     function _poolWhitelisted(IConverterAnchor poolAnchor) internal view {
1898         require(_settings.isPoolWhitelisted(poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1899     }
1900 
1901     // error message binary size optimization
1902     function _addLiquidityEnabled(IConverterAnchor poolAnchor, IReserveToken reserveToken) internal view {
1903         require(!_settings.addLiquidityDisabled(poolAnchor, reserveToken), "ERR_ADD_LIQUIDITY_DISABLED");
1904     }
1905 
1906     // error message binary size optimization
1907     function verifyEthAmount(uint256 value) internal view {
1908         require(msg.value == value, "ERR_ETH_AMOUNT_MISMATCH");
1909     }
1910 
1911     /**
1912      * @dev returns the LP store
1913      *
1914      * @return the LP store
1915      */
1916     function store() external view override returns (ILiquidityProtectionStore) {
1917         return _store;
1918     }
1919 
1920     /**
1921      * @dev returns the LP stats
1922      *
1923      * @return the LP stats
1924      */
1925     function stats() external view override returns (ILiquidityProtectionStats) {
1926         return _stats;
1927     }
1928 
1929     /**
1930      * @dev returns the LP settings
1931      *
1932      * @return the LP settings
1933      */
1934     function settings() external view override returns (ILiquidityProtectionSettings) {
1935         return _settings;
1936     }
1937 
1938     /**
1939      * @dev returns the LP system store
1940      *
1941      * @return the LP system store
1942      */
1943     function systemStore() external view override returns (ILiquidityProtectionSystemStore) {
1944         return _systemStore;
1945     }
1946 
1947     /**
1948      * @dev returns the LP wallet
1949      *
1950      * @return the LP wallet
1951      */
1952     function wallet() external view override returns (ITokenHolder) {
1953         return _wallet;
1954     }
1955 
1956     /**
1957      * @dev accept ETH
1958      */
1959     receive() external payable {}
1960 
1961     /**
1962      * @dev transfers the ownership of the store
1963      * can only be called by the contract owner
1964      *
1965      * @param newOwner the new owner of the store
1966      */
1967     function transferStoreOwnership(address newOwner) external ownerOnly {
1968         _store.transferOwnership(newOwner);
1969     }
1970 
1971     /**
1972      * @dev accepts the ownership of the store
1973      * can only be called by the contract owner
1974      */
1975     function acceptStoreOwnership() external ownerOnly {
1976         _store.acceptOwnership();
1977     }
1978 
1979     /**
1980      * @dev transfers the ownership of the wallet
1981      * can only be called by the contract owner
1982      *
1983      * @param newOwner the new owner of the wallet
1984      */
1985     function transferWalletOwnership(address newOwner) external ownerOnly {
1986         _wallet.transferOwnership(newOwner);
1987     }
1988 
1989     /**
1990      * @dev accepts the ownership of the wallet
1991      * can only be called by the contract owner
1992      */
1993     function acceptWalletOwnership() external ownerOnly {
1994         _wallet.acceptOwnership();
1995     }
1996 
1997     /**
1998      * @dev adds protected liquidity to a pool for a specific recipient
1999      * also mints new governance tokens for the caller if the caller adds network tokens
2000      *
2001      * @param owner position owner
2002      * @param poolAnchor anchor of the pool
2003      * @param reserveToken reserve token to add to the pool
2004      * @param amount amount of tokens to add to the pool
2005      *
2006      * @return new position id
2007      */
2008     function addLiquidityFor(
2009         address owner,
2010         IConverterAnchor poolAnchor,
2011         IReserveToken reserveToken,
2012         uint256 amount
2013     )
2014         external
2015         payable
2016         override
2017         protected
2018         validAddress(owner)
2019         poolSupportedAndWhitelisted(poolAnchor)
2020         addLiquidityEnabled(poolAnchor, reserveToken)
2021         greaterThanZero(amount)
2022         returns (uint256)
2023     {
2024         return addLiquidity(owner, poolAnchor, reserveToken, amount);
2025     }
2026 
2027     /**
2028      * @dev adds protected liquidity to a pool
2029      * also mints new governance tokens for the caller if the caller adds network tokens
2030      *
2031      * @param poolAnchor anchor of the pool
2032      * @param reserveToken reserve token to add to the pool
2033      * @param amount amount of tokens to add to the pool
2034      *
2035      * @return new position id
2036      */
2037     function addLiquidity(
2038         IConverterAnchor poolAnchor,
2039         IReserveToken reserveToken,
2040         uint256 amount
2041     )
2042         external
2043         payable
2044         override
2045         protected
2046         poolSupportedAndWhitelisted(poolAnchor)
2047         addLiquidityEnabled(poolAnchor, reserveToken)
2048         greaterThanZero(amount)
2049         returns (uint256)
2050     {
2051         return addLiquidity(msg.sender, poolAnchor, reserveToken, amount);
2052     }
2053 
2054     /**
2055      * @dev adds protected liquidity to a pool for a specific recipient
2056      * also mints new governance tokens for the caller if the caller adds network tokens
2057      *
2058      * @param owner position owner
2059      * @param poolAnchor anchor of the pool
2060      * @param reserveToken reserve token to add to the pool
2061      * @param amount amount of tokens to add to the pool
2062      *
2063      * @return new position id
2064      */
2065     function addLiquidity(
2066         address owner,
2067         IConverterAnchor poolAnchor,
2068         IReserveToken reserveToken,
2069         uint256 amount
2070     ) private returns (uint256) {
2071         if (isNetworkToken(reserveToken)) {
2072             verifyEthAmount(0);
2073             return addNetworkTokenLiquidity(owner, poolAnchor, amount);
2074         }
2075 
2076         // verify that ETH was passed with the call if needed
2077         verifyEthAmount(reserveToken.isNativeToken() ? amount : 0);
2078         return addBaseTokenLiquidity(owner, poolAnchor, reserveToken, amount);
2079     }
2080 
2081     /**
2082      * @dev adds network token liquidity to a pool
2083      * also mints new governance tokens for the caller
2084      *
2085      * @param owner position owner
2086      * @param poolAnchor anchor of the pool
2087      * @param amount amount of tokens to add to the pool
2088      *
2089      * @return new position id
2090      */
2091     function addNetworkTokenLiquidity(
2092         address owner,
2093         IConverterAnchor poolAnchor,
2094         uint256 amount
2095     ) internal returns (uint256) {
2096         IDSToken poolToken = IDSToken(address(poolAnchor));
2097         IReserveToken networkToken = IReserveToken(address(_networkToken));
2098 
2099         // get the rate between the pool token and the reserve
2100         Fraction memory poolRate = poolTokenRate(poolToken, networkToken);
2101 
2102         // calculate the amount of pool tokens based on the amount of reserve tokens
2103         uint256 poolTokenAmount = amount.mul(poolRate.d).div(poolRate.n);
2104 
2105         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
2106         _systemStore.decSystemBalance(poolToken, poolTokenAmount);
2107 
2108         // add the position for the recipient
2109         uint256 id = addPosition(owner, poolToken, networkToken, poolTokenAmount, amount, time());
2110 
2111         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
2112         // token holders can burn their tokens
2113         _networkToken.safeTransferFrom(msg.sender, address(this), amount);
2114         burnNetworkTokens(poolAnchor, amount);
2115 
2116         // mint governance tokens to the recipient
2117         _govTokenGovernance.mint(owner, amount);
2118 
2119         return id;
2120     }
2121 
2122     /**
2123      * @dev adds base token liquidity to a pool
2124      *
2125      * @param owner position owner
2126      * @param poolAnchor anchor of the pool
2127      * @param baseToken the base reserve token of the pool
2128      * @param amount amount of tokens to add to the pool
2129      *
2130      * @return new position id
2131      */
2132     function addBaseTokenLiquidity(
2133         address owner,
2134         IConverterAnchor poolAnchor,
2135         IReserveToken baseToken,
2136         uint256 amount
2137     ) internal returns (uint256) {
2138         IDSToken poolToken = IDSToken(address(poolAnchor));
2139         IReserveToken networkToken = IReserveToken(address(_networkToken));
2140 
2141         // get the reserve balances
2142         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolAnchor)));
2143         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
2144             converterReserveBalances(converter, baseToken, networkToken);
2145 
2146         require(reserveBalanceNetwork >= _settings.minNetworkTokenLiquidityForMinting(), "ERR_NOT_ENOUGH_LIQUIDITY");
2147 
2148         // calculate and mint the required amount of network tokens for adding liquidity
2149         uint256 newNetworkLiquidityAmount = amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
2150 
2151         // verify network token minting limit
2152         uint256 mintingLimit = _settings.networkTokenMintingLimits(poolAnchor);
2153         if (mintingLimit == 0) {
2154             mintingLimit = _settings.defaultNetworkTokenMintingLimit();
2155         }
2156 
2157         uint256 newNetworkTokensMinted = _systemStore.networkTokensMinted(poolAnchor).add(newNetworkLiquidityAmount);
2158         require(newNetworkTokensMinted <= mintingLimit, "ERR_MAX_AMOUNT_REACHED");
2159 
2160         // issue new network tokens to the system
2161         mintNetworkTokens(address(this), poolAnchor, newNetworkLiquidityAmount);
2162 
2163         // transfer the base tokens from the caller and approve the converter
2164         networkToken.ensureApprove(address(converter), newNetworkLiquidityAmount);
2165 
2166         if (!baseToken.isNativeToken()) {
2167             baseToken.safeTransferFrom(msg.sender, address(this), amount);
2168             baseToken.ensureApprove(address(converter), amount);
2169         }
2170 
2171         // add the liquidity to the converter
2172         addLiquidity(converter, baseToken, networkToken, amount, newNetworkLiquidityAmount, msg.value);
2173 
2174         // transfer the new pool tokens to the wallet
2175         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
2176         poolToken.safeTransfer(address(_wallet), poolTokenAmount);
2177 
2178         // the system splits the pool tokens with the caller
2179         // increase the system's pool token balance and add the position for the caller
2180         _systemStore.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
2181 
2182         return addPosition(owner, poolToken, baseToken, poolTokenAmount / 2, amount, time());
2183     }
2184 
2185     /**
2186      * @dev returns the single-side staking limits of a given pool
2187      *
2188      * @param poolAnchor anchor of the pool
2189      *
2190      * @return maximum amount of base tokens that can be single-side staked in the pool
2191      * @return maximum amount of network tokens that can be single-side staked in the pool
2192      */
2193     function poolAvailableSpace(IConverterAnchor poolAnchor)
2194         external
2195         view
2196         poolSupportedAndWhitelisted(poolAnchor)
2197         returns (uint256, uint256)
2198     {
2199         return (baseTokenAvailableSpace(poolAnchor), networkTokenAvailableSpace(poolAnchor));
2200     }
2201 
2202     /**
2203      * @dev returns the base-token staking limits of a given pool
2204      *
2205      * @param poolAnchor anchor of the pool
2206      *
2207      * @return maximum amount of base tokens that can be single-side staked in the pool
2208      */
2209     function baseTokenAvailableSpace(IConverterAnchor poolAnchor) internal view returns (uint256) {
2210         // get the pool converter
2211         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolAnchor)));
2212 
2213         // get the base token
2214         IReserveToken networkToken = IReserveToken(address(_networkToken));
2215         IReserveToken baseToken = converterOtherReserve(converter, networkToken);
2216 
2217         // get the reserve balances
2218         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
2219             converterReserveBalances(converter, baseToken, networkToken);
2220 
2221         // get the network token minting limit
2222         uint256 mintingLimit = _settings.networkTokenMintingLimits(poolAnchor);
2223         if (mintingLimit == 0) {
2224             mintingLimit = _settings.defaultNetworkTokenMintingLimit();
2225         }
2226 
2227         // get the amount of network tokens already minted for the pool
2228         uint256 networkTokensMinted = _systemStore.networkTokensMinted(poolAnchor);
2229 
2230         // get the amount of network tokens which can minted for the pool
2231         uint256 networkTokensCanBeMinted = MathEx.max(mintingLimit, networkTokensMinted) - networkTokensMinted;
2232 
2233         // return the maximum amount of base token liquidity that can be single-sided staked in the pool
2234         return networkTokensCanBeMinted.mul(reserveBalanceBase).div(reserveBalanceNetwork);
2235     }
2236 
2237     /**
2238      * @dev returns the network-token staking limits of a given pool
2239      *
2240      * @param poolAnchor anchor of the pool
2241      *
2242      * @return maximum amount of network tokens that can be single-side staked in the pool
2243      */
2244     function networkTokenAvailableSpace(IConverterAnchor poolAnchor) internal view returns (uint256) {
2245         // get the pool token
2246         IDSToken poolToken = IDSToken(address(poolAnchor));
2247         IReserveToken networkToken = IReserveToken(address(_networkToken));
2248 
2249         // get the pool token rate
2250         Fraction memory poolRate = poolTokenRate(poolToken, networkToken);
2251 
2252         // return the maximum amount of network token liquidity that can be single-sided staked in the pool
2253         return _systemStore.systemBalance(poolToken).mul(poolRate.n).add(poolRate.n).sub(1).div(poolRate.d);
2254     }
2255 
2256     /**
2257      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
2258      * it's also possible to provide the remove liquidity time to get an estimation
2259      * for the return at that given point
2260      *
2261      * @param id position id
2262      * @param portion portion of liquidity to remove, in PPM
2263      * @param removeTimestamp time at which the liquidity is removed
2264      *
2265      * @return expected return amount in the reserve token
2266      * @return actual return amount in the reserve token
2267      * @return compensation in the network token
2268      */
2269     function removeLiquidityReturn(
2270         uint256 id,
2271         uint32 portion,
2272         uint256 removeTimestamp
2273     )
2274         external
2275         view
2276         validPortion(portion)
2277         returns (
2278             uint256,
2279             uint256,
2280             uint256
2281         )
2282     {
2283         Position memory pos = position(id);
2284 
2285         // verify input
2286         require(pos.provider != address(0), "ERR_INVALID_ID");
2287         require(removeTimestamp >= pos.timestamp, "ERR_INVALID_TIMESTAMP");
2288 
2289         // calculate the portion of the liquidity to remove
2290         if (portion != PPM_RESOLUTION) {
2291             pos.poolAmount = pos.poolAmount.mul(portion) / PPM_RESOLUTION;
2292             pos.reserveAmount = pos.reserveAmount.mul(portion) / PPM_RESOLUTION;
2293         }
2294 
2295         // get the various rates between the reserves upon adding liquidity and now
2296         PackedRates memory packedRates = packRates(pos.poolToken, pos.reserveToken, pos.reserveRateN, pos.reserveRateD);
2297 
2298         uint256 targetAmount =
2299             removeLiquidityTargetAmount(
2300                 pos.poolToken,
2301                 pos.reserveToken,
2302                 pos.poolAmount,
2303                 pos.reserveAmount,
2304                 packedRates,
2305                 pos.timestamp,
2306                 removeTimestamp
2307             );
2308 
2309         // for network token, the return amount is identical to the target amount
2310         if (isNetworkToken(pos.reserveToken)) {
2311             return (targetAmount, targetAmount, 0);
2312         }
2313 
2314         // handle base token return
2315 
2316         // calculate the amount of pool tokens required for liquidation
2317         // note that the amount is doubled since it's not possible to liquidate one reserve only
2318         Fraction memory poolRate = poolTokenRate(pos.poolToken, pos.reserveToken);
2319         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
2320 
2321         // limit the amount of pool tokens by the amount the system/caller holds
2322         uint256 availableBalance = _systemStore.systemBalance(pos.poolToken).add(pos.poolAmount);
2323         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
2324 
2325         // calculate the base token amount received by liquidating the pool tokens
2326         // note that the amount is divided by 2 since the pool amount represents both reserves
2327         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
2328         uint256 networkAmount = networkCompensation(targetAmount, baseAmount, packedRates);
2329 
2330         return (targetAmount, baseAmount, networkAmount);
2331     }
2332 
2333     /**
2334      * @dev removes protected liquidity from a pool
2335      * also burns governance tokens from the caller if the caller removes network tokens
2336      *
2337      * @param id position id
2338      * @param portion portion of liquidity to remove, in PPM
2339      */
2340     function removeLiquidity(uint256 id, uint32 portion) external override protected validPortion(portion) {
2341         removeLiquidity(msg.sender, id, portion);
2342     }
2343 
2344     /**
2345      * @dev removes a position from a pool
2346      * also burns governance tokens from the caller if the caller removes network tokens
2347      *
2348      * @param provider liquidity provider
2349      * @param id position id
2350      * @param portion portion of liquidity to remove, in PPM
2351      */
2352     function removeLiquidity(
2353         address payable provider,
2354         uint256 id,
2355         uint32 portion
2356     ) internal {
2357         // remove the position from the store and update the stats and the last removal checkpoint
2358         Position memory removedPos = removePosition(provider, id, portion);
2359 
2360         // add the pool tokens to the system
2361         _systemStore.incSystemBalance(removedPos.poolToken, removedPos.poolAmount);
2362 
2363         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
2364         // tokens to the contract itself, since only token holders can burn their tokens
2365         if (isNetworkToken(removedPos.reserveToken)) {
2366             _govToken.safeTransferFrom(provider, address(this), removedPos.reserveAmount);
2367             _govTokenGovernance.burn(removedPos.reserveAmount);
2368         }
2369 
2370         // get the various rates between the reserves upon adding liquidity and now
2371         PackedRates memory packedRates =
2372             packRates(removedPos.poolToken, removedPos.reserveToken, removedPos.reserveRateN, removedPos.reserveRateD);
2373 
2374         // verify rate deviation as early as possible in order to reduce gas-cost for failing transactions
2375         verifyRateDeviation(
2376             packedRates.removeSpotRateN,
2377             packedRates.removeSpotRateD,
2378             packedRates.removeAverageRateN,
2379             packedRates.removeAverageRateD
2380         );
2381 
2382         // get the target token amount
2383         uint256 targetAmount =
2384             removeLiquidityTargetAmount(
2385                 removedPos.poolToken,
2386                 removedPos.reserveToken,
2387                 removedPos.poolAmount,
2388                 removedPos.reserveAmount,
2389                 packedRates,
2390                 removedPos.timestamp,
2391                 time()
2392             );
2393 
2394         // remove network token liquidity
2395         if (isNetworkToken(removedPos.reserveToken)) {
2396             // mint network tokens for the caller and lock them
2397             mintNetworkTokens(address(_wallet), removedPos.poolToken, targetAmount);
2398             lockTokens(provider, targetAmount);
2399 
2400             return;
2401         }
2402 
2403         // remove base token liquidity
2404 
2405         // calculate the amount of pool tokens required for liquidation
2406         // note that the amount is doubled since it's not possible to liquidate one reserve only
2407         Fraction memory poolRate = poolTokenRate(removedPos.poolToken, removedPos.reserveToken);
2408         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
2409 
2410         // limit the amount of pool tokens by the amount the system holds
2411         uint256 systemBalance = _systemStore.systemBalance(removedPos.poolToken);
2412         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
2413 
2414         // withdraw the pool tokens from the wallet
2415         IReserveToken poolToken = IReserveToken(address(removedPos.poolToken));
2416         _systemStore.decSystemBalance(removedPos.poolToken, poolAmount);
2417         _wallet.withdrawTokens(poolToken, address(this), poolAmount);
2418 
2419         // remove liquidity
2420         removeLiquidity(
2421             removedPos.poolToken,
2422             poolAmount,
2423             removedPos.reserveToken,
2424             IReserveToken(address(_networkToken))
2425         );
2426 
2427         // transfer the base tokens to the caller
2428         uint256 baseBalance = removedPos.reserveToken.balanceOf(address(this));
2429         removedPos.reserveToken.safeTransfer(provider, baseBalance);
2430 
2431         // compensate the caller with network tokens if still needed
2432         uint256 delta = networkCompensation(targetAmount, baseBalance, packedRates);
2433         if (delta > 0) {
2434             // check if there's enough network token balance, otherwise mint more
2435             uint256 networkBalance = _networkToken.balanceOf(address(this));
2436             if (networkBalance < delta) {
2437                 _networkTokenGovernance.mint(address(this), delta - networkBalance);
2438             }
2439 
2440             // lock network tokens for the caller
2441             _networkToken.safeTransfer(address(_wallet), delta);
2442             lockTokens(provider, delta);
2443         }
2444 
2445         // if the contract still holds network tokens, burn them
2446         uint256 networkBalance = _networkToken.balanceOf(address(this));
2447         if (networkBalance > 0) {
2448             burnNetworkTokens(removedPos.poolToken, networkBalance);
2449         }
2450     }
2451 
2452     /**
2453      * @dev returns the amount the provider will receive for removing liquidity
2454      * it's also possible to provide the remove liquidity rate & time to get an estimation
2455      * for the return at that given point
2456      *
2457      * @param poolToken pool token
2458      * @param reserveToken reserve token
2459      * @param poolAmount pool token amount when the liquidity was added
2460      * @param reserveAmount reserve token amount that was added
2461      * @param packedRates see `struct PackedRates`
2462      * @param addTimestamp time at which the liquidity was added
2463      * @param removeTimestamp time at which the liquidity is removed
2464      *
2465      * @return amount received for removing liquidity
2466      */
2467     function removeLiquidityTargetAmount(
2468         IDSToken poolToken,
2469         IReserveToken reserveToken,
2470         uint256 poolAmount,
2471         uint256 reserveAmount,
2472         PackedRates memory packedRates,
2473         uint256 addTimestamp,
2474         uint256 removeTimestamp
2475     ) internal view returns (uint256) {
2476         // get the rate between the pool token and the reserve token
2477         Fraction memory poolRate = poolTokenRate(poolToken, reserveToken);
2478 
2479         // get the rate between the reserves upon adding liquidity and now
2480         Fraction memory addSpotRate = Fraction({ n: packedRates.addSpotRateN, d: packedRates.addSpotRateD });
2481         Fraction memory removeSpotRate = Fraction({ n: packedRates.removeSpotRateN, d: packedRates.removeSpotRateD });
2482         Fraction memory removeAverageRate =
2483             Fraction({ n: packedRates.removeAverageRateN, d: packedRates.removeAverageRateD });
2484 
2485         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
2486         uint256 total = protectedAmountPlusFee(poolAmount, poolRate, addSpotRate, removeSpotRate);
2487 
2488         // calculate the impermanent loss
2489         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
2490 
2491         // calculate the protection level
2492         Fraction memory level = protectionLevel(addTimestamp, removeTimestamp);
2493 
2494         // calculate the compensation amount
2495         return compensationAmount(reserveAmount, MathEx.max(reserveAmount, total), loss, level);
2496     }
2497 
2498     /**
2499      * @dev transfers a position to a new provider
2500      *
2501      * @param id position id
2502      * @param newProvider the new provider
2503      *
2504      * @return new position id
2505      */
2506     function transferPosition(uint256 id, address newProvider)
2507         external
2508         override
2509         protected
2510         validAddress(newProvider)
2511         returns (uint256)
2512     {
2513         return transferPosition(msg.sender, id, newProvider);
2514     }
2515 
2516     /**
2517      * @dev transfers a position to a new provider and optionally notifies another contract
2518      *
2519      * @param id position id
2520      * @param newProvider the new provider
2521      * @param callback the callback contract to notify
2522      * @param data custom data provided to the callback
2523      *
2524      * @return new position id
2525      */
2526     function transferPositionAndNotify(
2527         uint256 id,
2528         address newProvider,
2529         ITransferPositionCallback callback,
2530         bytes calldata data
2531     ) external override protected validAddress(newProvider) validAddress(address(callback)) returns (uint256) {
2532         uint256 newId = transferPosition(msg.sender, id, newProvider);
2533 
2534         callback.onTransferPosition(newId, msg.sender, data);
2535 
2536         return newId;
2537     }
2538 
2539     /**
2540      * @dev transfers a position to a new provider
2541      *
2542      * @param provider the existing provider
2543      * @param id position id
2544      * @param newProvider the new provider
2545      *
2546      * @return new position id
2547      */
2548     function transferPosition(
2549         address provider,
2550         uint256 id,
2551         address newProvider
2552     ) internal returns (uint256) {
2553         // remove the position from the store and update the stats and the last removal checkpoint
2554         Position memory removedPos = removePosition(provider, id, PPM_RESOLUTION);
2555 
2556         // add the position to the store, update the stats, and return the new id
2557         return
2558             addPosition(
2559                 newProvider,
2560                 removedPos.poolToken,
2561                 removedPos.reserveToken,
2562                 removedPos.poolAmount,
2563                 removedPos.reserveAmount,
2564                 removedPos.timestamp
2565             );
2566     }
2567 
2568     /**
2569      * @dev allows the caller to claim network token balance that is no longer locked
2570      * note that the function can revert if the range is too large
2571      *
2572      * @param startIndex start index in the caller's list of locked balances
2573      * @param endIndex end index in the caller's list of locked balances (exclusive)
2574      */
2575     function claimBalance(uint256 startIndex, uint256 endIndex) external protected {
2576         // get the locked balances from the store
2577         (uint256[] memory amounts, uint256[] memory expirationTimes) =
2578             _store.lockedBalanceRange(msg.sender, startIndex, endIndex);
2579 
2580         uint256 totalAmount = 0;
2581         uint256 length = amounts.length;
2582         assert(length == expirationTimes.length);
2583 
2584         // reverse iteration since we're removing from the list
2585         for (uint256 i = length; i > 0; i--) {
2586             uint256 index = i - 1;
2587             if (expirationTimes[index] > time()) {
2588                 continue;
2589             }
2590 
2591             // remove the locked balance item
2592             _store.removeLockedBalance(msg.sender, startIndex + index);
2593             totalAmount = totalAmount.add(amounts[index]);
2594         }
2595 
2596         if (totalAmount > 0) {
2597             // transfer the tokens to the caller in a single call
2598             _wallet.withdrawTokens(IReserveToken(address(_networkToken)), msg.sender, totalAmount);
2599         }
2600     }
2601 
2602     /**
2603      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
2604      * the function assumes full protection is in effect
2605      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
2606      *
2607      * @param poolToken pool token
2608      * @param reserveToken reserve token
2609      * @param reserveAmount reserve token amount that was added
2610      * @param poolRateN rate of 1 pool token in reserve token units when the liquidity was added (numerator)
2611      * @param poolRateD rate of 1 pool token in reserve token units when the liquidity was added (denominator)
2612      * @param reserveRateN rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
2613      * @param reserveRateD rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
2614      *
2615      * @return ROI in PPM
2616      */
2617     function poolROI(
2618         IDSToken poolToken,
2619         IReserveToken reserveToken,
2620         uint256 reserveAmount,
2621         uint256 poolRateN,
2622         uint256 poolRateD,
2623         uint256 reserveRateN,
2624         uint256 reserveRateD
2625     ) external view returns (uint256) {
2626         // calculate the amount of pool tokens based on the amount of reserve tokens
2627         uint256 poolAmount = reserveAmount.mul(poolRateD).div(poolRateN);
2628 
2629         // get the various rates between the reserves upon adding liquidity and now
2630         PackedRates memory packedRates = packRates(poolToken, reserveToken, reserveRateN, reserveRateD);
2631 
2632         // get the current return
2633         uint256 protectedReturn =
2634             removeLiquidityTargetAmount(
2635                 poolToken,
2636                 reserveToken,
2637                 poolAmount,
2638                 reserveAmount,
2639                 packedRates,
2640                 time().sub(_settings.maxProtectionDelay()),
2641                 time()
2642             );
2643 
2644         // calculate the ROI as the ratio between the current fully protected return and the initial amount
2645         return protectedReturn.mul(PPM_RESOLUTION).div(reserveAmount);
2646     }
2647 
2648     /**
2649      * @dev adds the position to the store and updates the stats
2650      *
2651      * @param provider the provider
2652      * @param poolToken pool token
2653      * @param reserveToken reserve token
2654      * @param poolAmount amount of pool tokens to protect
2655      * @param reserveAmount amount of reserve tokens to protect
2656      * @param timestamp the timestamp of the position
2657      *
2658      * @return new position id
2659      */
2660     function addPosition(
2661         address provider,
2662         IDSToken poolToken,
2663         IReserveToken reserveToken,
2664         uint256 poolAmount,
2665         uint256 reserveAmount,
2666         uint256 timestamp
2667     ) internal returns (uint256) {
2668         // verify rate deviation as early as possible in order to reduce gas-cost for failing transactions
2669         (Fraction memory spotRate, Fraction memory averageRate) = reserveTokenRates(poolToken, reserveToken);
2670         verifyRateDeviation(spotRate.n, spotRate.d, averageRate.n, averageRate.d);
2671 
2672         notifyEventSubscribersOnAddingLiquidity(provider, poolToken, reserveToken, poolAmount, reserveAmount);
2673 
2674         _stats.increaseTotalAmounts(provider, poolToken, reserveToken, poolAmount, reserveAmount);
2675         _stats.addProviderPool(provider, poolToken);
2676 
2677         return
2678             _store.addProtectedLiquidity(
2679                 provider,
2680                 poolToken,
2681                 reserveToken,
2682                 poolAmount,
2683                 reserveAmount,
2684                 spotRate.n,
2685                 spotRate.d,
2686                 timestamp
2687             );
2688     }
2689 
2690     /**
2691      * @dev removes the position from the store and updates the stats and the last removal checkpoint
2692      *
2693      * @param provider the provider
2694      * @param id position id
2695      * @param portion portion of the position to remove, in PPM
2696      *
2697      * @return a Position struct representing the removed liquidity
2698      */
2699     function removePosition(
2700         address provider,
2701         uint256 id,
2702         uint32 portion
2703     ) private returns (Position memory) {
2704         Position memory pos = providerPosition(id, provider);
2705 
2706         // verify that the pool is whitelisted
2707         _poolWhitelisted(pos.poolToken);
2708 
2709         // verify that the position is not removed on the same block in which it was added
2710         require(pos.timestamp < time(), "ERR_TOO_EARLY");
2711 
2712         if (portion == PPM_RESOLUTION) {
2713             notifyEventSubscribersOnRemovingLiquidity(
2714                 id,
2715                 pos.provider,
2716                 pos.poolToken,
2717                 pos.reserveToken,
2718                 pos.poolAmount,
2719                 pos.reserveAmount
2720             );
2721 
2722             // remove the position from the provider
2723             _store.removeProtectedLiquidity(id);
2724         } else {
2725             // remove a portion of the position from the provider
2726             uint256 fullPoolAmount = pos.poolAmount;
2727             uint256 fullReserveAmount = pos.reserveAmount;
2728             pos.poolAmount = pos.poolAmount.mul(portion) / PPM_RESOLUTION;
2729             pos.reserveAmount = pos.reserveAmount.mul(portion) / PPM_RESOLUTION;
2730 
2731             notifyEventSubscribersOnRemovingLiquidity(
2732                 id,
2733                 pos.provider,
2734                 pos.poolToken,
2735                 pos.reserveToken,
2736                 pos.poolAmount,
2737                 pos.reserveAmount
2738             );
2739 
2740             _store.updateProtectedLiquidityAmounts(
2741                 id,
2742                 fullPoolAmount - pos.poolAmount,
2743                 fullReserveAmount - pos.reserveAmount
2744             );
2745         }
2746 
2747         // update the statistics
2748         _stats.decreaseTotalAmounts(pos.provider, pos.poolToken, pos.reserveToken, pos.poolAmount, pos.reserveAmount);
2749 
2750         // update last liquidity removal checkpoint
2751         _lastRemoveCheckpointStore.addCheckpoint(provider);
2752 
2753         return pos;
2754     }
2755 
2756     /**
2757      * @dev locks network tokens for the provider and emits the tokens locked event
2758      *
2759      * @param provider tokens provider
2760      * @param amount amount of network tokens
2761      */
2762     function lockTokens(address provider, uint256 amount) internal {
2763         uint256 expirationTime = time().add(_settings.lockDuration());
2764         _store.addLockedBalance(provider, amount, expirationTime);
2765     }
2766 
2767     /**
2768      * @dev returns the rate of 1 pool token in reserve token units
2769      *
2770      * @param poolToken pool token
2771      * @param reserveToken reserve token
2772      */
2773     function poolTokenRate(IDSToken poolToken, IReserveToken reserveToken)
2774         internal
2775         view
2776         virtual
2777         returns (Fraction memory)
2778     {
2779         // get the pool token supply
2780         uint256 poolTokenSupply = poolToken.totalSupply();
2781 
2782         // get the reserve balance
2783         IConverter converter = IConverter(payable(ownedBy(poolToken)));
2784         uint256 reserveBalance = converter.getConnectorBalance(reserveToken);
2785 
2786         // for standard pools, 50% of the pool supply value equals the value of each reserve
2787         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
2788     }
2789 
2790     /**
2791      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
2792      *
2793      * @param poolToken pool token
2794      * @param reserveToken reserve token
2795      *
2796      * @return spot rate
2797      * @return average rate
2798      */
2799     function reserveTokenRates(IDSToken poolToken, IReserveToken reserveToken)
2800         internal
2801         view
2802         returns (Fraction memory, Fraction memory)
2803     {
2804         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolToken)));
2805         IReserveToken otherReserve = converterOtherReserve(converter, reserveToken);
2806 
2807         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, reserveToken);
2808         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(reserveToken);
2809 
2810         return (Fraction({ n: spotRateN, d: spotRateD }), Fraction({ n: averageRateN, d: averageRateD }));
2811     }
2812 
2813     /**
2814      * @dev returns the various rates between the reserves
2815      *
2816      * @param poolToken pool token
2817      * @param reserveToken reserve token
2818      * @param addSpotRateN add spot rate numerator
2819      * @param addSpotRateD add spot rate denominator
2820      *
2821      * @return see `struct PackedRates`
2822      */
2823     function packRates(
2824         IDSToken poolToken,
2825         IReserveToken reserveToken,
2826         uint256 addSpotRateN,
2827         uint256 addSpotRateD
2828     ) internal view returns (PackedRates memory) {
2829         (Fraction memory removeSpotRate, Fraction memory removeAverageRate) =
2830             reserveTokenRates(poolToken, reserveToken);
2831 
2832         assert(
2833             addSpotRateN <= MAX_UINT128 &&
2834                 addSpotRateD <= MAX_UINT128 &&
2835                 removeSpotRate.n <= MAX_UINT128 &&
2836                 removeSpotRate.d <= MAX_UINT128 &&
2837                 removeAverageRate.n <= MAX_UINT128 &&
2838                 removeAverageRate.d <= MAX_UINT128
2839         );
2840 
2841         return
2842             PackedRates({
2843                 addSpotRateN: uint128(addSpotRateN),
2844                 addSpotRateD: uint128(addSpotRateD),
2845                 removeSpotRateN: uint128(removeSpotRate.n),
2846                 removeSpotRateD: uint128(removeSpotRate.d),
2847                 removeAverageRateN: uint128(removeAverageRate.n),
2848                 removeAverageRateD: uint128(removeAverageRate.d)
2849             });
2850     }
2851 
2852     /**
2853      * @dev verifies that the deviation of the average rate from the spot rate is within the permitted range
2854      * for example, if the maximum permitted deviation is 5%, then verify `95/100 <= average/spot <= 100/95`
2855      *
2856      * @param spotRateN spot rate numerator
2857      * @param spotRateD spot rate denominator
2858      * @param averageRateN average rate numerator
2859      * @param averageRateD average rate denominator
2860      */
2861     function verifyRateDeviation(
2862         uint256 spotRateN,
2863         uint256 spotRateD,
2864         uint256 averageRateN,
2865         uint256 averageRateD
2866     ) internal view {
2867         uint256 ppmDelta = PPM_RESOLUTION - _settings.averageRateMaxDeviation();
2868         uint256 min = spotRateN.mul(averageRateD).mul(ppmDelta).mul(ppmDelta);
2869         uint256 mid = spotRateD.mul(averageRateN).mul(ppmDelta).mul(PPM_RESOLUTION);
2870         uint256 max = spotRateN.mul(averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2871         require(min <= mid && mid <= max, "ERR_INVALID_RATE");
2872     }
2873 
2874     /**
2875      * @dev utility to add liquidity to a converter
2876      *
2877      * @param converter converter
2878      * @param reserveToken1 reserve token 1
2879      * @param reserveToken2 reserve token 2
2880      * @param reserveAmount1 reserve amount 1
2881      * @param reserveAmount2 reserve amount 2
2882      * @param value ETH amount to add
2883      */
2884     function addLiquidity(
2885         ILiquidityPoolConverter converter,
2886         IReserveToken reserveToken1,
2887         IReserveToken reserveToken2,
2888         uint256 reserveAmount1,
2889         uint256 reserveAmount2,
2890         uint256 value
2891     ) internal {
2892         IReserveToken[] memory reserveTokens = new IReserveToken[](2);
2893         uint256[] memory amounts = new uint256[](2);
2894         reserveTokens[0] = reserveToken1;
2895         reserveTokens[1] = reserveToken2;
2896         amounts[0] = reserveAmount1;
2897         amounts[1] = reserveAmount2;
2898         converter.addLiquidity{ value: value }(reserveTokens, amounts, 1);
2899     }
2900 
2901     /**
2902      * @dev utility to remove liquidity from a converter
2903      *
2904      * @param poolToken pool token of the converter
2905      * @param poolAmount amount of pool tokens to remove
2906      * @param reserveToken1 reserve token 1
2907      * @param reserveToken2 reserve token 2
2908      */
2909     function removeLiquidity(
2910         IDSToken poolToken,
2911         uint256 poolAmount,
2912         IReserveToken reserveToken1,
2913         IReserveToken reserveToken2
2914     ) internal {
2915         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(poolToken)));
2916 
2917         IReserveToken[] memory reserveTokens = new IReserveToken[](2);
2918         uint256[] memory minReturns = new uint256[](2);
2919         reserveTokens[0] = reserveToken1;
2920         reserveTokens[1] = reserveToken2;
2921         minReturns[0] = 1;
2922         minReturns[1] = 1;
2923         converter.removeLiquidity(poolAmount, reserveTokens, minReturns);
2924     }
2925 
2926     /**
2927      * @dev returns a position from the store
2928      *
2929      * @param id position id
2930      *
2931      * @return a position
2932      */
2933     function position(uint256 id) internal view returns (Position memory) {
2934         Position memory pos;
2935         (
2936             pos.provider,
2937             pos.poolToken,
2938             pos.reserveToken,
2939             pos.poolAmount,
2940             pos.reserveAmount,
2941             pos.reserveRateN,
2942             pos.reserveRateD,
2943             pos.timestamp
2944         ) = _store.protectedLiquidity(id);
2945 
2946         return pos;
2947     }
2948 
2949     /**
2950      * @dev returns a position from the store
2951      *
2952      * @param id position id
2953      * @param provider authorized provider
2954      *
2955      * @return a position
2956      */
2957     function providerPosition(uint256 id, address provider) internal view returns (Position memory) {
2958         Position memory pos = position(id);
2959         require(pos.provider == provider, "ERR_ACCESS_DENIED");
2960 
2961         return pos;
2962     }
2963 
2964     /**
2965      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2966      *
2967      * @param poolAmount pool token amount when the liquidity was added
2968      * @param poolRate rate of 1 pool token in the related reserve token units
2969      * @param addRate rate of 1 reserve token in the other reserve token units when the liquidity was added
2970      * @param removeRate rate of 1 reserve token in the other reserve token units when the liquidity is removed
2971      *
2972      * @return protected amount of reserve tokens plus accumulated fee = sqrt(removeRate / addRate) * poolRate * poolAmount
2973      */
2974     function protectedAmountPlusFee(
2975         uint256 poolAmount,
2976         Fraction memory poolRate,
2977         Fraction memory addRate,
2978         Fraction memory removeRate
2979     ) internal pure returns (uint256) {
2980         uint256 n = MathEx.ceilSqrt(addRate.d.mul(removeRate.n)).mul(poolRate.n);
2981         uint256 d = MathEx.floorSqrt(addRate.n.mul(removeRate.d)).mul(poolRate.d);
2982 
2983         uint256 x = n * poolAmount;
2984         if (x / n == poolAmount) {
2985             return x / d;
2986         }
2987 
2988         (uint256 hi, uint256 lo) = n > poolAmount ? (n, poolAmount) : (poolAmount, n);
2989         (uint256 p, uint256 q) = MathEx.reducedRatio(hi, d, MAX_UINT256 / lo);
2990         uint256 min = (hi / d).mul(lo);
2991 
2992         if (q > 0) {
2993             return MathEx.max(min, (p * lo) / q);
2994         }
2995         return min;
2996     }
2997 
2998     /**
2999      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
3000      *
3001      * @param prevRate previous rate between the reserves
3002      * @param newRate new rate between the reserves
3003      *
3004      * @return impermanent loss (as a ratio)
3005      */
3006     function impLoss(Fraction memory prevRate, Fraction memory newRate) internal pure returns (Fraction memory) {
3007         uint256 ratioN = newRate.n.mul(prevRate.d);
3008         uint256 ratioD = newRate.d.mul(prevRate.n);
3009 
3010         uint256 prod = ratioN * ratioD;
3011         uint256 root =
3012             prod / ratioN == ratioD ? MathEx.floorSqrt(prod) : MathEx.floorSqrt(ratioN) * MathEx.floorSqrt(ratioD);
3013         uint256 sum = ratioN.add(ratioD);
3014 
3015         // the arithmetic below is safe because `x + y >= sqrt(x * y) * 2`
3016         if (sum % 2 == 0) {
3017             sum /= 2;
3018             return Fraction({ n: sum - root, d: sum });
3019         }
3020         return Fraction({ n: sum - root * 2, d: sum });
3021     }
3022 
3023     /**
3024      * @dev returns the protection level based on the timestamp and protection delays
3025      *
3026      * @param addTimestamp time at which the liquidity was added
3027      * @param removeTimestamp time at which the liquidity is removed
3028      *
3029      * @return protection level (as a ratio)
3030      */
3031     function protectionLevel(uint256 addTimestamp, uint256 removeTimestamp) internal view returns (Fraction memory) {
3032         uint256 timeElapsed = removeTimestamp.sub(addTimestamp);
3033         uint256 minProtectionDelay = _settings.minProtectionDelay();
3034         uint256 maxProtectionDelay = _settings.maxProtectionDelay();
3035         if (timeElapsed < minProtectionDelay) {
3036             return Fraction({ n: 0, d: 1 });
3037         }
3038 
3039         if (timeElapsed >= maxProtectionDelay) {
3040             return Fraction({ n: 1, d: 1 });
3041         }
3042 
3043         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
3044     }
3045 
3046     /**
3047      * @dev returns the compensation amount based on the impermanent loss and the protection level
3048      *
3049      * @param amount protected amount in units of the reserve token
3050      * @param total amount plus fee in units of the reserve token
3051      * @param loss protection level (as a ratio between 0 and 1)
3052      * @param level impermanent loss (as a ratio between 0 and 1)
3053      *
3054      * @return compensation amount
3055      */
3056     function compensationAmount(
3057         uint256 amount,
3058         uint256 total,
3059         Fraction memory loss,
3060         Fraction memory level
3061     ) internal pure returns (uint256) {
3062         uint256 levelN = level.n.mul(amount);
3063         uint256 levelD = level.d;
3064         uint256 maxVal = MathEx.max(MathEx.max(levelN, levelD), total);
3065         (uint256 lossN, uint256 lossD) = MathEx.reducedRatio(loss.n, loss.d, MAX_UINT256 / maxVal);
3066         return total.mul(lossD.sub(lossN)).div(lossD).add(lossN.mul(levelN).div(lossD.mul(levelD)));
3067     }
3068 
3069     function networkCompensation(
3070         uint256 targetAmount,
3071         uint256 baseAmount,
3072         PackedRates memory packedRates
3073     ) internal view returns (uint256) {
3074         if (targetAmount <= baseAmount) {
3075             return 0;
3076         }
3077 
3078         // calculate the delta in network tokens
3079         uint256 delta =
3080             (targetAmount - baseAmount).mul(packedRates.removeAverageRateN).div(packedRates.removeAverageRateD);
3081 
3082         // the delta might be very small due to precision loss
3083         // in which case no compensation will take place (gas optimization)
3084         if (delta >= _settings.minNetworkCompensation()) {
3085             return delta;
3086         }
3087 
3088         return 0;
3089     }
3090 
3091     // utility to mint network tokens
3092     function mintNetworkTokens(
3093         address owner,
3094         IConverterAnchor poolAnchor,
3095         uint256 amount
3096     ) private {
3097         _systemStore.incNetworkTokensMinted(poolAnchor, amount);
3098         _networkTokenGovernance.mint(owner, amount);
3099     }
3100 
3101     // utility to burn network tokens
3102     function burnNetworkTokens(IConverterAnchor poolAnchor, uint256 amount) private {
3103         _systemStore.decNetworkTokensMinted(poolAnchor, amount);
3104         _networkTokenGovernance.burn(amount);
3105     }
3106 
3107     /**
3108      * @dev notify event subscribers on adding liquidity
3109      *
3110      * @param provider liquidity provider
3111      * @param poolToken pool token
3112      * @param reserveToken reserve token
3113      * @param poolAmount amount of pool tokens to protect
3114      * @param reserveAmount amount of reserve tokens to protect
3115      */
3116     function notifyEventSubscribersOnAddingLiquidity(
3117         address provider,
3118         IDSToken poolToken,
3119         IReserveToken reserveToken,
3120         uint256 poolAmount,
3121         uint256 reserveAmount
3122     ) private {
3123         address[] memory subscribers = _settings.subscribers();
3124         uint256 length = subscribers.length;
3125         for (uint256 i = 0; i < length; i++) {
3126             ILiquidityProvisionEventsSubscriber(subscribers[i]).onAddingLiquidity(
3127                 provider,
3128                 poolToken,
3129                 reserveToken,
3130                 poolAmount,
3131                 reserveAmount
3132             );
3133         }
3134     }
3135 
3136     /**
3137      * @dev notify event subscribers on removing liquidity
3138      *
3139      * @param id position id
3140      * @param provider liquidity provider
3141      * @param poolToken pool token
3142      * @param reserveToken reserve token
3143      * @param poolAmount amount of pool tokens to protect
3144      * @param reserveAmount amount of reserve tokens to protect
3145      */
3146     function notifyEventSubscribersOnRemovingLiquidity(
3147         uint256 id,
3148         address provider,
3149         IDSToken poolToken,
3150         IReserveToken reserveToken,
3151         uint256 poolAmount,
3152         uint256 reserveAmount
3153     ) private {
3154         address[] memory subscribers = _settings.subscribers();
3155         uint256 length = subscribers.length;
3156         for (uint256 i = 0; i < length; i++) {
3157             ILiquidityProvisionEventsSubscriber(subscribers[i]).onRemovingLiquidity(
3158                 id,
3159                 provider,
3160                 poolToken,
3161                 reserveToken,
3162                 poolAmount,
3163                 reserveAmount
3164             );
3165         }
3166     }
3167 
3168     // utility to get the reserve balances
3169     function converterReserveBalances(
3170         IConverter converter,
3171         IReserveToken reserveToken1,
3172         IReserveToken reserveToken2
3173     ) private view returns (uint256, uint256) {
3174         return (converter.getConnectorBalance(reserveToken1), converter.getConnectorBalance(reserveToken2));
3175     }
3176 
3177     // utility to get the other reserve
3178     function converterOtherReserve(IConverter converter, IReserveToken thisReserve)
3179         private
3180         view
3181         returns (IReserveToken)
3182     {
3183         IReserveToken otherReserve = converter.connectorTokens(0);
3184         return otherReserve != thisReserve ? otherReserve : converter.connectorTokens(1);
3185     }
3186 
3187     // utility to get the owner
3188     function ownedBy(IOwned owned) private view returns (address) {
3189         return owned.owner();
3190     }
3191 
3192     /**
3193      * @dev returns whether the provided reserve token is the network token
3194      *
3195      * @return whether the provided reserve token is the network token
3196      */
3197     function isNetworkToken(IReserveToken reserveToken) private view returns (bool) {
3198         return address(reserveToken) == address(_networkToken);
3199     }
3200 }
