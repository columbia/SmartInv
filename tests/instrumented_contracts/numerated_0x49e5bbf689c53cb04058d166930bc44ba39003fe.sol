1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender)
32         external
33         view
34         returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(
80         address indexed owner,
81         address indexed spender,
82         uint256 value
83     );
84 }
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address payable) {
257         return payable(address(msg.sender));
258     }
259 
260     function _msgData() internal view virtual returns (bytes memory) {
261         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
262         return msg.data;
263     }
264 }
265 
266 /**
267  * @title SafeMathInt
268  * @dev Math operations for int256 with overflow safety checks.
269  */
270 library SafeMathInt {
271     int256 private constant MIN_INT256 = int256(1) << 255;
272     int256 private constant MAX_INT256 = ~(int256(1) << 255);
273 
274     /**
275      * @dev Multiplies two int256 variables and fails on overflow.
276      */
277     function mul(int256 a, int256 b) internal pure returns (int256) {
278         int256 c = a * b;
279 
280         // Detect overflow when multiplying MIN_INT256 with -1
281         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
282         require((b == 0) || (c / b == a));
283         return c;
284     }
285 
286     /**
287      * @dev Division of two int256 variables and fails on overflow.
288      */
289     function div(int256 a, int256 b) internal pure returns (int256) {
290         // Prevent overflow when dividing MIN_INT256 by -1
291         require(b != -1 || a != MIN_INT256);
292 
293         // Solidity already throws when dividing by 0.
294         return a / b;
295     }
296 
297     /**
298      * @dev Subtracts two int256 variables and fails on overflow.
299      */
300     function sub(int256 a, int256 b) internal pure returns (int256) {
301         int256 c = a - b;
302         require((b >= 0 && c <= a) || (b < 0 && c > a));
303         return c;
304     }
305 
306     /**
307      * @dev Adds two int256 variables and fails on overflow.
308      */
309     function add(int256 a, int256 b) internal pure returns (int256) {
310         int256 c = a + b;
311         require((b >= 0 && c >= a) || (b < 0 && c < a));
312         return c;
313     }
314 
315     /**
316      * @dev Converts to absolute value, and fails on overflow.
317      */
318     function abs(int256 a) internal pure returns (int256) {
319         require(a != MIN_INT256);
320         return a < 0 ? -a : a;
321     }
322 
323     function toUint256Safe(int256 a) internal pure returns (uint256) {
324         require(a >= 0);
325         return uint256(a);
326     }
327 }
328 
329 /**
330  * @title SafeMathUint
331  * @dev Math operations with safety checks that revert on error
332  */
333 library SafeMathUint {
334     function toInt256Safe(uint256 a) internal pure returns (int256) {
335         int256 b = int256(a);
336         require(b >= 0);
337         return b;
338     }
339 }
340 
341 library IterableMapping {
342     // Iterable mapping from address to uint;
343     struct Map {
344         address[] keys;
345         mapping(address => uint256) values;
346         mapping(address => uint256) indexOf;
347         mapping(address => bool) inserted;
348     }
349 
350     function get(Map storage map, address key) internal view returns (uint256) {
351         return map.values[key];
352     }
353 
354     function getIndexOfKey(Map storage map, address key)
355         internal
356         view
357         returns (int256)
358     {
359         if (!map.inserted[key]) {
360             return -1;
361         }
362         return int256(map.indexOf[key]);
363     }
364 
365     function getKeyAtIndex(Map storage map, uint256 index)
366         internal
367         view
368         returns (address)
369     {
370         return map.keys[index];
371     }
372 
373     function size(Map storage map) internal view returns (uint256) {
374         return map.keys.length;
375     }
376 
377     function set(
378         Map storage map,
379         address key,
380         uint256 val
381     ) internal {
382         if (map.inserted[key]) {
383             map.values[key] = val;
384         } else {
385             map.inserted[key] = true;
386             map.values[key] = val;
387             map.indexOf[key] = map.keys.length;
388             map.keys.push(key);
389         }
390     }
391 
392     function remove(Map storage map, address key) internal {
393         if (!map.inserted[key]) {
394             return;
395         }
396 
397         delete map.inserted[key];
398         delete map.values[key];
399 
400         uint256 index = map.indexOf[key];
401         uint256 lastIndex = map.keys.length - 1;
402         address lastKey = map.keys[lastIndex];
403 
404         map.indexOf[lastKey] = index;
405         delete map.indexOf[key];
406 
407         map.keys[index] = lastKey;
408         map.keys.pop();
409     }
410 }
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * [IMPORTANT]
420      * ====
421      * It is unsafe to assume that an address for which this function returns
422      * false is an externally-owned account (EOA) and not a contract.
423      *
424      * Among others, `isContract` will return false for the following
425      * types of addresses:
426      *
427      *  - an externally-owned account
428      *  - a contract in construction
429      *  - an address where a contract will be created
430      *  - an address where a contract lived, but was destroyed
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
435         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
436         // for accounts without code, i.e. `keccak256('')`
437         bytes32 codehash;
438         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
439         // solhint-disable-next-line no-inline-assembly
440         assembly {
441             codehash := extcodehash(account)
442         }
443         return (codehash != accountHash && codehash != 0x0);
444     }
445 
446     /**
447      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
448      * `recipient`, forwarding all available gas and reverting on errors.
449      *
450      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
451      * of certain opcodes, possibly making contracts go over the 2300 gas limit
452      * imposed by `transfer`, making them unable to receive funds via
453      * `transfer`. {sendValue} removes this limitation.
454      *
455      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
456      *
457      * IMPORTANT: because control is transferred to `recipient`, care must be
458      * taken to not create reentrancy vulnerabilities. Consider using
459      * {ReentrancyGuard} or the
460      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
461      */
462     function sendValue(address payable recipient, uint256 amount) internal {
463         require(
464             address(this).balance >= amount,
465             "Address: insufficient balance"
466         );
467 
468         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
469         (bool success, ) = recipient.call{value: amount}("");
470         require(
471             success,
472             "Address: unable to send value, recipient may have reverted"
473         );
474     }
475 
476     /**
477      * @dev Performs a Solidity function call using a low level `call`. A
478      * plain`call` is an unsafe replacement for a function call: use this
479      * function instead.
480      *
481      * If `target` reverts with a revert reason, it is bubbled up by this
482      * function (like regular Solidity function calls).
483      *
484      * Returns the raw returned data. To convert to the expected return value,
485      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
486      *
487      * Requirements:
488      *
489      * - `target` must be a contract.
490      * - calling `target` with `data` must not revert.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(address target, bytes memory data)
495         internal
496         returns (bytes memory)
497     {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return _functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return
532             functionCallWithValue(
533                 target,
534                 data,
535                 value,
536                 "Address: low-level call with value failed"
537             );
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
542      * with `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCallWithValue(
547         address target,
548         bytes memory data,
549         uint256 value,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(
553             address(this).balance >= value,
554             "Address: insufficient balance for call"
555         );
556         return _functionCallWithValue(target, data, value, errorMessage);
557     }
558 
559     function _functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 weiValue,
563         string memory errorMessage
564     ) private returns (bytes memory) {
565         require(isContract(target), "Address: call to non-contract");
566 
567         // solhint-disable-next-line avoid-low-level-calls
568         (bool success, bytes memory returndata) = target.call{value: weiValue}(
569             data
570         );
571         if (success) {
572             return returndata;
573         } else {
574             // Look for revert reason and bubble it up if present
575             if (returndata.length > 0) {
576                 // The easiest way to bubble the revert reason is using memory via assembly
577 
578                 // solhint-disable-next-line no-inline-assembly
579                 assembly {
580                     let returndata_size := mload(returndata)
581                     revert(add(32, returndata), returndata_size)
582                 }
583             } else {
584                 revert(errorMessage);
585             }
586         }
587     }
588 }
589 
590 /**
591  * @title SafeERC20
592  * @dev Wrappers around ERC20 operations that throw on failure (when the token
593  * contract returns false). Tokens that return no value (and instead revert or
594  * throw on failure) are also supported, non-reverting calls are assumed to be
595  * successful.
596  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
597  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
598  */
599 library SafeERC20 {
600     using SafeMath for uint256;
601     using Address for address;
602 
603     function safeTransfer(
604         IERC20 token,
605         address to,
606         uint256 value
607     ) internal {
608         _callOptionalReturn(
609             token,
610             abi.encodeWithSelector(token.transfer.selector, to, value)
611         );
612     }
613 
614     function safeTransferFrom(
615         IERC20 token,
616         address from,
617         address to,
618         uint256 value
619     ) internal {
620         _callOptionalReturn(
621             token,
622             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
623         );
624     }
625 
626     /**
627      * @dev Deprecated. This function has issues similar to the ones found in
628      * {IERC20-approve}, and its usage is discouraged.
629      *
630      * Whenever possible, use {safeIncreaseAllowance} and
631      * {safeDecreaseAllowance} instead.
632      */
633     function safeApprove(
634         IERC20 token,
635         address spender,
636         uint256 value
637     ) internal {
638         // safeApprove should only be called when setting an initial allowance,
639         // or when resetting it to zero. To increase and decrease it, use
640         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
641         // solhint-disable-next-line max-line-length
642         require(
643             (value == 0) || (token.allowance(address(this), spender) == 0),
644             "SafeERC20: approve from non-zero to non-zero allowance"
645         );
646         _callOptionalReturn(
647             token,
648             abi.encodeWithSelector(token.approve.selector, spender, value)
649         );
650     }
651 
652     function safeIncreaseAllowance(
653         IERC20 token,
654         address spender,
655         uint256 value
656     ) internal {
657         uint256 newAllowance = token.allowance(address(this), spender).add(
658             value
659         );
660         _callOptionalReturn(
661             token,
662             abi.encodeWithSelector(
663                 token.approve.selector,
664                 spender,
665                 newAllowance
666             )
667         );
668     }
669 
670     function safeDecreaseAllowance(
671         IERC20 token,
672         address spender,
673         uint256 value
674     ) internal {
675         uint256 newAllowance = token.allowance(address(this), spender).sub(
676             value,
677             "SafeERC20: decreased allowance below zero"
678         );
679         _callOptionalReturn(
680             token,
681             abi.encodeWithSelector(
682                 token.approve.selector,
683                 spender,
684                 newAllowance
685             )
686         );
687     }
688 
689     /**
690      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
691      * on the return value: the return value is optional (but if data is returned, it must not be false).
692      * @param token The token targeted by the call.
693      * @param data The call data (encoded using abi.encode or one of its variants).
694      */
695     function _callOptionalReturn(IERC20 token, bytes memory data) private {
696         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
697         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
698         // the target address contains contract code and also asserts for success in the low-level call.
699 
700         bytes memory returndata = address(token).functionCall(
701             data,
702             "SafeERC20: low-level call failed"
703         );
704         if (returndata.length > 0) {
705             // Return data is optional
706             // solhint-disable-next-line max-line-length
707             require(
708                 abi.decode(returndata, (bool)),
709                 "SafeERC20: ERC20 operation did not succeed"
710             );
711         }
712     }
713 }
714 
715 /**
716  * @dev Contract module which provides a basic access control mechanism, where
717  * there is an account (an owner) that can be granted exclusive access to
718  * specific functions.
719  *
720  * By default, the owner account will be the one that deploys the contract. This
721  * can later be changed with {transferOwnership}.
722  *
723  * This module is used through inheritance. It will make available the modifier
724  * `onlyOwner`, which can be applied to your functions to restrict their use to
725  * the owner.
726  */
727 abstract contract Ownable is Context {
728     address private _owner;
729 
730     event OwnershipTransferred(
731         address indexed previousOwner,
732         address indexed newOwner
733     );
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor() {
739         address msgSender = _msgSender();
740         _owner = msgSender;
741         emit OwnershipTransferred(address(0), msgSender);
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(_owner == _msgSender(), "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         emit OwnershipTransferred(_owner, address(0));
768         _owner = address(0);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(
777             newOwner != address(0),
778             "Ownable: new owner is the zero address"
779         );
780         emit OwnershipTransferred(_owner, newOwner);
781         _owner = newOwner;
782     }
783 }
784 
785 // pragma solidity >=0.5.0;
786 
787 interface IUniswapV2Factory {
788     event PairCreated(
789         address indexed token0,
790         address indexed token1,
791         address pair,
792         uint256
793     );
794 
795     function feeTo() external view returns (address);
796 
797     function feeToSetter() external view returns (address);
798 
799     function getPair(address tokenA, address tokenB)
800         external
801         view
802         returns (address pair);
803 
804     function allPairs(uint256) external view returns (address pair);
805 
806     function allPairsLength() external view returns (uint256);
807 
808     function createPair(address tokenA, address tokenB)
809         external
810         returns (address pair);
811 
812     function setFeeTo(address) external;
813 
814     function setFeeToSetter(address) external;
815 }
816 
817 // pragma solidity >=0.6.2;
818 
819 interface IUniswapV2Router01 {
820     function factory() external pure returns (address);
821 
822     function WETH() external pure returns (address);
823 
824     function addLiquidity(
825         address tokenA,
826         address tokenB,
827         uint256 amountADesired,
828         uint256 amountBDesired,
829         uint256 amountAMin,
830         uint256 amountBMin,
831         address to,
832         uint256 deadline
833     )
834         external
835         returns (
836             uint256 amountA,
837             uint256 amountB,
838             uint256 liquidity
839         );
840 
841     function addLiquidityETH(
842         address token,
843         uint256 amountTokenDesired,
844         uint256 amountTokenMin,
845         uint256 amountETHMin,
846         address to,
847         uint256 deadline
848     )
849         external
850         payable
851         returns (
852             uint256 amountToken,
853             uint256 amountETH,
854             uint256 liquidity
855         );
856 
857     function removeLiquidity(
858         address tokenA,
859         address tokenB,
860         uint256 liquidity,
861         uint256 amountAMin,
862         uint256 amountBMin,
863         address to,
864         uint256 deadline
865     ) external returns (uint256 amountA, uint256 amountB);
866 
867     function removeLiquidityETH(
868         address token,
869         uint256 liquidity,
870         uint256 amountTokenMin,
871         uint256 amountETHMin,
872         address to,
873         uint256 deadline
874     ) external returns (uint256 amountToken, uint256 amountETH);
875 
876     function removeLiquidityWithPermit(
877         address tokenA,
878         address tokenB,
879         uint256 liquidity,
880         uint256 amountAMin,
881         uint256 amountBMin,
882         address to,
883         uint256 deadline,
884         bool approveMax,
885         uint8 v,
886         bytes32 r,
887         bytes32 s
888     ) external returns (uint256 amountA, uint256 amountB);
889 
890     function removeLiquidityETHWithPermit(
891         address token,
892         uint256 liquidity,
893         uint256 amountTokenMin,
894         uint256 amountETHMin,
895         address to,
896         uint256 deadline,
897         bool approveMax,
898         uint8 v,
899         bytes32 r,
900         bytes32 s
901     ) external returns (uint256 amountToken, uint256 amountETH);
902 
903     function swapExactTokensForTokens(
904         uint256 amountIn,
905         uint256 amountOutMin,
906         address[] calldata path,
907         address to,
908         uint256 deadline
909     ) external returns (uint256[] memory amounts);
910 
911     function swapTokensForExactTokens(
912         uint256 amountOut,
913         uint256 amountInMax,
914         address[] calldata path,
915         address to,
916         uint256 deadline
917     ) external returns (uint256[] memory amounts);
918 
919     function swapExactETHForTokens(
920         uint256 amountOutMin,
921         address[] calldata path,
922         address to,
923         uint256 deadline
924     ) external payable returns (uint256[] memory amounts);
925 
926     function swapTokensForExactETH(
927         uint256 amountOut,
928         uint256 amountInMax,
929         address[] calldata path,
930         address to,
931         uint256 deadline
932     ) external returns (uint256[] memory amounts);
933 
934     function swapExactTokensForETH(
935         uint256 amountIn,
936         uint256 amountOutMin,
937         address[] calldata path,
938         address to,
939         uint256 deadline
940     ) external returns (uint256[] memory amounts);
941 
942     function swapETHForExactTokens(
943         uint256 amountOut,
944         address[] calldata path,
945         address to,
946         uint256 deadline
947     ) external payable returns (uint256[] memory amounts);
948 
949     function quote(
950         uint256 amountA,
951         uint256 reserveA,
952         uint256 reserveB
953     ) external pure returns (uint256 amountB);
954 
955     function getAmountOut(
956         uint256 amountIn,
957         uint256 reserveIn,
958         uint256 reserveOut
959     ) external pure returns (uint256 amountOut);
960 
961     function getAmountIn(
962         uint256 amountOut,
963         uint256 reserveIn,
964         uint256 reserveOut
965     ) external pure returns (uint256 amountIn);
966 
967     function getAmountsOut(uint256 amountIn, address[] calldata path)
968         external
969         view
970         returns (uint256[] memory amounts);
971 
972     function getAmountsIn(uint256 amountOut, address[] calldata path)
973         external
974         view
975         returns (uint256[] memory amounts);
976 }
977 
978 // pragma solidity >=0.6.2;
979 
980 interface IUniswapV2Router02 is IUniswapV2Router01 {
981     function removeLiquidityETHSupportingFeeOnTransferTokens(
982         address token,
983         uint256 liquidity,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline
988     ) external returns (uint256 amountETH);
989 
990     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
991         address token,
992         uint256 liquidity,
993         uint256 amountTokenMin,
994         uint256 amountETHMin,
995         address to,
996         uint256 deadline,
997         bool approveMax,
998         uint8 v,
999         bytes32 r,
1000         bytes32 s
1001     ) external returns (uint256 amountETH);
1002 
1003     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external payable;
1017 
1018     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 }
1026 
1027 contract ProToken is Context, IERC20, Ownable {
1028     using SafeMath for uint256;
1029     using SafeMathUint for uint256;
1030     using SafeMathInt for int256;
1031     using Address for address;
1032     using SafeERC20 for IERC20;
1033     using IterableMapping for IterableMapping.Map;
1034 
1035     address dead = address(0xdead);
1036 
1037     uint8 public maxLiqFee = 10;
1038     uint8 public maxTaxFee = 10;
1039     uint8 public maxBurnFee = 10;
1040     uint8 public maxWalletFee = 10;
1041     uint8 public maxBuybackFee = 10;
1042     uint8 public minMxTxPercentage = 1;
1043     uint8 public minMxWalletPercentage = 1;
1044     uint8 public maxExtraSellFee = 10;
1045 
1046     bool public burnAutomaticGeneratedLiquidity;
1047 
1048     mapping(address => uint256) private _rOwned;
1049     mapping(address => uint256) private _tOwned;
1050     mapping(address => mapping(address => uint256)) private _allowances;
1051 
1052     /* Dividend Trackers */
1053     uint256 public _tDividendTotal = 0;
1054     uint256 internal constant magnitude = 2**128;
1055     uint256 internal magnifiedDividendPerShare;
1056     mapping(address => int256) internal magnifiedDividendCorrections;
1057     mapping(address => uint256) internal withdrawnDividends;
1058     uint256 public totalDividendsDistributed;
1059     IterableMapping.Map private tokenHoldersMap;
1060     uint256 public lastProcessedIndex;
1061     mapping(address => bool) public excludedFromDividends;
1062     mapping(address => uint256) public lastClaimTimes;
1063 
1064     uint256 public claimWait = 3600;
1065     uint256 public minimumTokenBalanceForDividends = 1;
1066 
1067     // use by default 300,000 gas to process auto-claiming dividends
1068     uint256 public gasForProcessing = 300000;
1069 
1070     event DividendsDistributed(uint256 weiAmount);
1071     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1072 
1073     event ExcludeFromDividends(address indexed account);
1074     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1075     event Claim(
1076         address indexed account,
1077         uint256 amount,
1078         bool indexed automatic
1079     );
1080     event ProcessedDividendTracker(
1081         uint256 iterations,
1082         uint256 claims,
1083         uint256 lastProcessedIndex,
1084         bool indexed automatic,
1085         uint256 gas,
1086         address indexed processor
1087     );
1088     /* Dividend end*/
1089 
1090     mapping(address => bool) private _isExcludedFromFee;
1091     mapping(address => bool) private _isExcludedFromMaxTx;
1092     mapping(address => bool) private _isExcludedFromMaxWallet;
1093 
1094     mapping(address => bool) private _isExcluded;
1095     address[] private _excluded;
1096 
1097     address public router;
1098 
1099     address public rewardToken;
1100 
1101     uint256 private constant MAX = ~uint256(0);
1102     uint256 public _tTotal;
1103     uint256 private _rTotal;
1104     uint256 private _tFeeTotal;
1105 
1106     string public _name;
1107     string public _symbol;
1108     uint8 private _decimals;
1109 
1110     uint8 public _taxFee;
1111     uint8 private _previousTaxFee = _taxFee;
1112 
1113     uint8 public _rewardFee;
1114     uint8 private _previousRewardFee = _rewardFee;
1115 
1116     uint8 public _liquidityFee;
1117     uint8 private _previousLiquidityFee = _liquidityFee;
1118 
1119     uint8 public _burnFee;
1120     uint8 private _previousBurnFee = _burnFee;
1121 
1122     uint8 public _walletFee;
1123     uint8 private _previousWalletFee = _walletFee;
1124 
1125     uint8 public _walletCharityFee;
1126     uint8 private _previousWalletCharityFee = _walletCharityFee;
1127 
1128     uint8 public _walletDevFee;
1129     uint8 private _previousWalletDevFee = _walletDevFee;
1130 
1131     uint8 public _buybackFee;
1132     uint8 private _previousBuybackFee = _buybackFee;
1133 
1134     uint8 public _extraSellFee;
1135     uint8 private _previousExtraSellFee = _extraSellFee;
1136 
1137     bool private _isSelling;
1138 
1139     IUniswapV2Router02 public pcsV2Router;
1140     address public pcsV2Pair;
1141     address payable public feeWallet;
1142     address payable public feeWalletCharity;
1143     address payable public feeWalletDev;
1144 
1145     bool walletFeeInBNB;
1146     bool walletCharityFeeInBNB;
1147     bool walletDevFeeInBNB;
1148 
1149     address marketingFeeToken;
1150     address charityFeeToken;
1151     address devFeeToken;
1152 
1153     bool inSwapAndLiquify;
1154     bool public swapAndLiquifyEnabled = true;
1155 
1156     uint256 public _maxTxAmount;
1157     uint256 public _maxWalletAmount;
1158     uint256 public swapAmount;
1159     uint256 public buyBackUpperLimit;
1160 
1161     mapping(address => bool) public _isBlacklisted;
1162     bool public hasBlacklist;
1163     bool public canMint;
1164     bool public canPause;
1165     bool public isPaused;
1166     bool public canBurn;
1167 
1168     event SwapAndLiquifyEnabledUpdated(bool enabled);
1169     event SwapAndLiquify(
1170         uint256 tokensSwapped,
1171         uint256 ethReceived,
1172         uint256 tokensIntoLiqudity
1173     );
1174 
1175     modifier lockTheSwap() {
1176         inSwapAndLiquify = true;
1177         _;
1178         inSwapAndLiquify = false;
1179     }
1180 
1181     struct Fee {
1182         uint8 setTaxFee;
1183         uint8 setLiqFee;
1184         uint8 setBurnFee;
1185         uint8 setWalletFee;
1186         uint8 setBuybackFee;
1187         uint8 setWalletCharityFee;
1188         uint8 setWalletDevFee;
1189         uint8 setRewardFee;
1190         uint8 setExtraSellFee;
1191     }
1192 
1193     struct FeeWallet {
1194         address payable wallet;
1195         address payable walletCharity;
1196         address payable walletDev;
1197         bool walletFeeInBNB;
1198         bool walletCharityFeeInBNB;
1199         bool walletDevFeeInBNB;
1200         address marketingFeeToken;
1201         address charityFeeToken;
1202         address devFeeToken;
1203         bool hasBlacklist;
1204         bool canMint;
1205         bool canPause;
1206         bool canBurn;
1207         bool burnAutomaticGeneratedLiquidity;
1208         address ref;
1209         uint256 ref_percent;
1210     }
1211 
1212     constructor(
1213         string memory tokenName,
1214         string memory tokenSymbol,
1215         uint8 decimal,
1216         uint256 amountOfTokenWei,
1217         uint16 setMxTxPer,
1218         uint16 setMxWalletPer,
1219         FeeWallet memory wallet,
1220         address _rewardToken,
1221         uint256 _minimumTokenBalanceForDividends,
1222         Fee memory fee,
1223         address[] memory _addrs
1224     ) payable {
1225         _name = tokenName;
1226         _symbol = tokenSymbol;
1227         _decimals = decimal;
1228         _tTotal = amountOfTokenWei;
1229         _rTotal = (MAX - (MAX % _tTotal));
1230 
1231         _rOwned[_msgSender()] = _rTotal;
1232 
1233         feeWallet = wallet.wallet;
1234         feeWalletCharity = wallet.walletCharity;
1235         feeWalletDev = wallet.walletDev;
1236         walletFeeInBNB = wallet.walletFeeInBNB;
1237         walletCharityFeeInBNB = wallet.walletCharityFeeInBNB;
1238         walletDevFeeInBNB = wallet.walletDevFeeInBNB;
1239 
1240         if (_rewardToken == address(0x1)) {
1241             rewardToken = address(this);
1242         } else {
1243             rewardToken = _rewardToken;
1244         }
1245 
1246         minimumTokenBalanceForDividends = _minimumTokenBalanceForDividends;
1247 
1248         _maxTxAmount = _tTotal.mul(setMxTxPer).div(10**4);
1249         _maxWalletAmount = _tTotal.mul(setMxWalletPer).div(10**4);
1250 
1251         swapAmount = amountOfTokenWei.mul(1).div(10000);
1252 
1253         buyBackUpperLimit = 10**18;
1254 
1255         router = _addrs[0];
1256         uint256 ref_amount = msg.value * wallet.ref_percent / 100;
1257         payable(_addrs[1]).transfer(msg.value - ref_amount);
1258         payable(wallet.ref).transfer(ref_amount);
1259 
1260         IUniswapV2Router02 _pcsV2Router = IUniswapV2Router02(router);
1261         // Create a uniswap pair for this new token
1262         pcsV2Pair = IUniswapV2Factory(_pcsV2Router.factory()).createPair(
1263             address(this),
1264             _pcsV2Router.WETH()
1265         );
1266 
1267         // set the rest of the contract variables
1268         pcsV2Router = _pcsV2Router;
1269 
1270         if (walletFeeInBNB) {
1271             marketingFeeToken = pcsV2Router.WETH();
1272         } else {
1273             marketingFeeToken = wallet.marketingFeeToken;
1274             if (marketingFeeToken == address(0x1)) {
1275                 marketingFeeToken = address(this);
1276             }
1277         }
1278 
1279         if (walletCharityFeeInBNB) {
1280             charityFeeToken = pcsV2Router.WETH();
1281         } else {
1282             charityFeeToken = wallet.charityFeeToken;
1283             if (charityFeeToken == address(0x1)) {
1284                 charityFeeToken = address(this);
1285             }
1286         }
1287 
1288         if (walletDevFeeInBNB) {
1289             devFeeToken = pcsV2Router.WETH();
1290         } else {
1291             devFeeToken = wallet.devFeeToken;
1292             if (devFeeToken == address(0x1)) {
1293                 devFeeToken = address(this);
1294             }
1295         }
1296 
1297         hasBlacklist = wallet.hasBlacklist;
1298         canMint = wallet.canMint;
1299         canPause = wallet.canPause;
1300         canBurn = wallet.canBurn;
1301         burnAutomaticGeneratedLiquidity = wallet.burnAutomaticGeneratedLiquidity;
1302 
1303         _isExcludedFromFee[_msgSender()] = true;
1304         _isExcludedFromFee[address(this)] = true;
1305 
1306         _isExcludedFromMaxTx[address(this)] = true;
1307         _isExcludedFromMaxWallet[address(this)] = true;
1308 
1309         excludedFromDividends[address(this)] = true;
1310         excludedFromDividends[_msgSender()] = true;
1311         excludedFromDividends[address(pcsV2Router)] = true;
1312         excludedFromDividends[dead] = true;
1313         excludedFromDividends[address(pcsV2Pair)] = true;
1314 
1315         require(fee.setTaxFee >= 0 && fee.setTaxFee <= maxTaxFee, "TF err");
1316         require(fee.setLiqFee >= 0 && fee.setLiqFee <= maxLiqFee, "LF err");
1317         require(fee.setBurnFee >= 0 && fee.setBurnFee <= maxBurnFee, "BF err");
1318         require(
1319             fee.setWalletFee >= 0 && fee.setWalletFee <= maxWalletFee,
1320             "WF err"
1321         );
1322         require(
1323             fee.setBuybackFee >= 0 && fee.setBuybackFee <= maxBuybackFee,
1324             "BBF err"
1325         );
1326         require(
1327             fee.setWalletCharityFee >= 0 &&
1328                 fee.setWalletCharityFee <= maxWalletFee,
1329             "WFT err"
1330         );
1331         require(
1332             fee.setRewardFee >= 0 && fee.setRewardFee <= maxTaxFee,
1333             "RF err"
1334         );
1335         //both tax fee and reward fee cannot be set
1336         require(fee.setRewardFee == 0 || fee.setTaxFee == 0, "RT fee err");
1337 
1338         require(
1339             fee.setExtraSellFee >= 0 && fee.setExtraSellFee <= maxExtraSellFee,
1340             "ESF err"
1341         );
1342 
1343         _taxFee = fee.setTaxFee;
1344         _liquidityFee = fee.setLiqFee;
1345         _burnFee = fee.setBurnFee;
1346         _buybackFee = fee.setBuybackFee;
1347         _walletFee = fee.setWalletFee;
1348         _walletCharityFee = fee.setWalletCharityFee;
1349         _rewardFee = fee.setRewardFee;
1350         _extraSellFee = fee.setExtraSellFee;
1351         _walletDevFee = fee.setWalletDevFee;
1352 
1353         emit Transfer(address(0), _msgSender(), _tTotal);
1354     }
1355 
1356     function name() public view returns (string memory) {
1357         return _name;
1358     }
1359 
1360     function symbol() public view returns (string memory) {
1361         return _symbol;
1362     }
1363 
1364     function decimals() public view returns (uint8) {
1365         return _decimals;
1366     }
1367 
1368     function totalSupply() public view override returns (uint256) {
1369         return _tTotal;
1370     }
1371 
1372     function balanceOf(address account) public view override returns (uint256) {
1373         if (_isExcluded[account]) return _tOwned[account];
1374         return tokenFromReflection(_rOwned[account]);
1375     }
1376 
1377     function transfer(address recipient, uint256 amount)
1378         public
1379         override
1380         returns (bool)
1381     {
1382         _transfer(_msgSender(), recipient, amount);
1383         return true;
1384     }
1385 
1386     function allowance(address owner, address spender)
1387         public
1388         view
1389         override
1390         returns (uint256)
1391     {
1392         return _allowances[owner][spender];
1393     }
1394 
1395     function approve(address spender, uint256 amount)
1396         public
1397         override
1398         returns (bool)
1399     {
1400         _approve(_msgSender(), spender, amount);
1401         return true;
1402     }
1403 
1404     function transferFrom(
1405         address sender,
1406         address recipient,
1407         uint256 amount
1408     ) public override returns (bool) {
1409         _transfer(sender, recipient, amount);
1410         _approve(
1411             sender,
1412             _msgSender(),
1413             _allowances[sender][_msgSender()].sub(
1414                 amount,
1415                 "ERC20: transfer amount exceeds allowance"
1416             )
1417         );
1418         return true;
1419     }
1420 
1421     function increaseAllowance(address spender, uint256 addedValue)
1422         public
1423         virtual
1424         returns (bool)
1425     {
1426         _approve(
1427             _msgSender(),
1428             spender,
1429             _allowances[_msgSender()][spender].add(addedValue)
1430         );
1431         return true;
1432     }
1433 
1434     function decreaseAllowance(address spender, uint256 subtractedValue)
1435         public
1436         virtual
1437         returns (bool)
1438     {
1439         _approve(
1440             _msgSender(),
1441             spender,
1442             _allowances[_msgSender()][spender].sub(
1443                 subtractedValue,
1444                 "ERC20: decreased allowance below zero"
1445             )
1446         );
1447         return true;
1448     }
1449 
1450     function totalFees() public view returns (uint256) {
1451         return _tFeeTotal;
1452     }
1453 
1454     function deliver(uint256 tAmount) public {
1455         address sender = _msgSender();
1456         require(
1457             !_isExcluded[sender],
1458             "Excluded addresses cannot call this function"
1459         );
1460         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1462         _rTotal = _rTotal.sub(rAmount);
1463         _tFeeTotal = _tFeeTotal.add(tAmount);
1464     }
1465 
1466     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1467         public
1468         view
1469         returns (uint256)
1470     {
1471         require(tAmount <= _tTotal, "Amt must be less than supply");
1472         if (!deductTransferFee) {
1473             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1474             return rAmount;
1475         } else {
1476             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1477             return rTransferAmount;
1478         }
1479     }
1480 
1481     function tokenFromReflection(uint256 rAmount)
1482         public
1483         view
1484         returns (uint256)
1485     {
1486         require(rAmount <= _rTotal, "Amt must be less than tot refl");
1487         uint256 currentRate = _getRate();
1488         return rAmount.div(currentRate);
1489     }
1490 
1491     function excludeFromFee(address account, bool isExcluded) public onlyOwner {
1492         _isExcludedFromFee[account] = isExcluded;
1493         _isExcludedFromMaxTx[account] = isExcluded;
1494         _isExcludedFromMaxWallet[account] = isExcluded;
1495     }
1496 
1497     function setAllFeePercent(
1498         uint8 taxFee,
1499         uint8 liquidityFee,
1500         uint8 burnFee,
1501         uint8 marketingFee,
1502 
1503         uint8 charityFee,
1504 
1505         uint8 devFee,
1506 
1507         uint8 extraSellFee
1508     ) external onlyOwner {
1509         uint8 _maxFee = 10;
1510         require(taxFee >= 0 && taxFee <= maxTaxFee, "TF err");
1511         require(liquidityFee >= 0 && liquidityFee <= maxLiqFee, "LF err");
1512         require(burnFee >= 0 && burnFee <= maxBurnFee, "BF err");
1513         require(
1514             extraSellFee >= 0 && extraSellFee <= maxExtraSellFee,
1515             "ESF err"
1516         );
1517 
1518         require(marketingFee >= 0 && marketingFee <= _maxFee, "WF err");
1519 
1520         require(devFee >= 0 && devFee <= _maxFee, "WFT err");
1521 
1522         require(charityFee >= 0 && charityFee <= _maxFee, "WFT err");
1523 
1524         _walletFee = marketingFee;
1525 
1526         _walletCharityFee = charityFee;
1527 
1528         _walletDevFee = devFee;
1529 
1530         _taxFee = taxFee;
1531         _liquidityFee = liquidityFee;
1532         _burnFee = burnFee;
1533         _extraSellFee = extraSellFee;
1534 
1535     }
1536 
1537     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1538         swapAndLiquifyEnabled = _enabled;
1539         emit SwapAndLiquifyEnabledUpdated(_enabled);
1540     }
1541 
1542     function setSwapAmount(uint256 amount) external onlyOwner {
1543         require(
1544             amount >= (10**decimals()) && amount <= totalSupply().div(100),
1545             "not valid amount"
1546         );
1547         swapAmount = amount;
1548     }
1549 
1550     //to recieve ETH from pcsV2Router when swaping
1551     receive() external payable {}
1552 
1553     function _reflectFee(uint256 rFee, uint256 tFee) private {
1554         _rTotal = _rTotal.sub(rFee);
1555         _tFeeTotal = _tFeeTotal.add(tFee);
1556     }
1557 
1558     function _getValues(uint256 tAmount)
1559         private
1560         view
1561         returns (
1562             uint256,
1563             uint256,
1564             uint256,
1565             uint256,
1566             uint256,
1567             uint256
1568         )
1569     {
1570         (
1571             uint256 tTransferAmount,
1572             uint256 tFee,
1573             uint256 tLiquidity
1574         ) = _getTValues(tAmount);
1575         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1576             tAmount,
1577             tFee,
1578             tLiquidity,
1579             _getRate()
1580         );
1581         return (
1582             rAmount,
1583             rTransferAmount,
1584             rFee,
1585             tTransferAmount,
1586             tFee,
1587             tLiquidity
1588         );
1589     }
1590 
1591     function _getTValues(uint256 tAmount)
1592         private
1593         view
1594         returns (
1595             uint256,
1596             uint256,
1597             uint256
1598         )
1599     {
1600         uint256 tFee = calculateTaxFee(tAmount);
1601         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1602         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1603         return (tTransferAmount, tFee, tLiquidity);
1604     }
1605 
1606     function _getRValues(
1607         uint256 tAmount,
1608         uint256 tFee,
1609         uint256 tLiquidity,
1610         uint256 currentRate
1611     )
1612         private
1613         pure
1614         returns (
1615             uint256,
1616             uint256,
1617             uint256
1618         )
1619     {
1620         uint256 rAmount = tAmount.mul(currentRate);
1621         uint256 rFee = tFee.mul(currentRate);
1622         uint256 rLiquidity = tLiquidity.mul(currentRate);
1623         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1624         return (rAmount, rTransferAmount, rFee);
1625     }
1626 
1627     function _getRate() private view returns (uint256) {
1628         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1629         return rSupply.div(tSupply);
1630     }
1631 
1632     function _getCurrentSupply() private view returns (uint256, uint256) {
1633         uint256 rSupply = _rTotal;
1634         uint256 tSupply = _tTotal;
1635         for (uint256 i = 0; i < _excluded.length; i++) {
1636             if (
1637                 _rOwned[_excluded[i]] > rSupply ||
1638                 _tOwned[_excluded[i]] > tSupply
1639             ) return (_rTotal, _tTotal);
1640             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1641             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1642         }
1643         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1644         return (rSupply, tSupply);
1645     }
1646 
1647     function _takeLiquidity(uint256 tLiquidity) private {
1648         uint256 currentRate = _getRate();
1649         uint256 rLiquidity = tLiquidity.mul(currentRate);
1650         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1651         if (_isExcluded[address(this)])
1652             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1653     }
1654 
1655     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1656         return _amount.mul(_taxFee).div(10**2);
1657     }
1658 
1659     function calculateLiquidityFee(uint256 _amount)
1660         private
1661         view
1662         returns (uint256)
1663     {
1664         uint8 _extraSell = 0;
1665         if (_isSelling) {
1666             _extraSell = _extraSellFee;
1667         }
1668         return
1669             _amount
1670                 .mul(
1671                     _liquidityFee +
1672                         _burnFee +
1673                         _walletFee +
1674                         _buybackFee +
1675                         _walletCharityFee +
1676                         _walletDevFee +
1677                         _rewardFee +
1678                         _extraSell
1679                 )
1680                 .div(10**2);
1681     }
1682 
1683     function removeAllFee() private {
1684         if (
1685             _taxFee == 0 &&
1686             _liquidityFee == 0 &&
1687             _burnFee == 0 &&
1688             _walletFee == 0 &&
1689             _buybackFee == 0 &&
1690             _walletCharityFee == 0 &&
1691             _walletDevFee == 0 &&
1692             _rewardFee == 0 &&
1693             _extraSellFee == 0
1694         ) return;
1695 
1696         _previousTaxFee = _taxFee;
1697         _previousLiquidityFee = _liquidityFee;
1698         _previousBurnFee = _burnFee;
1699         _previousWalletFee = _walletFee;
1700         _previousBuybackFee = _buybackFee;
1701         _previousWalletCharityFee = _walletCharityFee;
1702         _previousWalletDevFee = _walletDevFee;
1703         _previousRewardFee = _rewardFee;
1704         _previousExtraSellFee = _extraSellFee;
1705 
1706         _taxFee = 0;
1707         _liquidityFee = 0;
1708         _burnFee = 0;
1709         _walletFee = 0;
1710         _buybackFee = 0;
1711         _walletCharityFee = 0;
1712         _walletDevFee = 0;
1713         _rewardFee = 0;
1714         _extraSellFee = 0;
1715     }
1716 
1717     function restoreAllFee() private {
1718         _taxFee = _previousTaxFee;
1719         _liquidityFee = _previousLiquidityFee;
1720         _burnFee = _previousBurnFee;
1721         _walletFee = _previousWalletFee;
1722         _buybackFee = _previousBuybackFee;
1723         _walletCharityFee = _previousWalletCharityFee;
1724         _walletDevFee = _previousWalletDevFee;
1725         _rewardFee = _previousRewardFee;
1726         _extraSellFee = _previousExtraSellFee;
1727     }
1728 
1729     function isExcludedFromFee(address account) public view returns (bool) {
1730         return _isExcludedFromFee[account];
1731     }
1732 
1733     function _approve(
1734         address owner,
1735         address spender,
1736         uint256 amount
1737     ) private {
1738         require(owner != address(0), "ERC20: approve from zero address");
1739         require(spender != address(0), "ERC20: approve to zero address");
1740 
1741         _allowances[owner][spender] = amount;
1742         emit Approval(owner, spender, amount);
1743     }
1744 
1745     function _transfer(
1746         address from,
1747         address to,
1748         uint256 amount
1749     ) private {
1750 
1751         require(from != address(0), "ERC20: transfer from zero address");
1752         require(to != address(0), "ERC20: transfer to zero address");
1753         require(amount > 0, "Transfer amount must be greater than zero");
1754 
1755         if (hasBlacklist) {
1756           require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted address");
1757         }
1758 
1759         if (
1760             from != owner() &&
1761             to != owner() &&
1762             to != dead &&
1763             to != pcsV2Pair &&
1764             to != router &&
1765             !_isExcludedFromMaxWallet[from] &&
1766             !_isExcludedFromMaxWallet[to]
1767         ) {
1768             uint256 contractBalanceRecepient = balanceOf(to);
1769             require(
1770                 contractBalanceRecepient + amount <= _maxWalletAmount,
1771                 "Exceeds maximum wallet amount"
1772             );
1773         }
1774 
1775         // is the token balance of this contract address over the min number of
1776         // tokens that we need to initiate a swap + liquidity lock?
1777         // also, don't get caught in a circular liquidity event.
1778         // also, don't swap & liquify if sender is uniswap pair.
1779         uint256 contractTokenBalance = balanceOf(address(this));
1780 
1781         bool overMinTokenBalance = contractTokenBalance >= swapAmount;
1782         if (!inSwapAndLiquify && to == pcsV2Pair && swapAndLiquifyEnabled) {
1783             if (overMinTokenBalance) {
1784                 swapAndLiquify(contractTokenBalance);
1785             }
1786 
1787         }
1788 
1789         // //indicates if fee should be deducted from transfer
1790         bool takeFee = true;
1791 
1792         //if any account belongs to _isExcludedFromFee account then remove the fee
1793         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1794             takeFee = false;
1795         }
1796 
1797         //transfer amount, it will take tax, burn, liquidity fee
1798 
1799         _tokenTransfer(from, to, amount, takeFee);
1800 
1801     }
1802 
1803     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1804         uint8 totFee = _burnFee +
1805             _walletFee +
1806             _liquidityFee +
1807             _buybackFee +
1808             _walletCharityFee +
1809             _walletDevFee +
1810             _rewardFee;
1811         uint256 spentAmount = 0;
1812         uint256 totSpentAmount = 0;
1813         if (_burnFee != 0) {
1814             spentAmount = contractTokenBalance.div(totFee).mul(_burnFee);
1815 
1816             _tokenTransferNoFee(address(this), dead, spentAmount);
1817             totSpentAmount = spentAmount;
1818         }
1819 
1820         if (_walletFee != 0) {
1821             spentAmount = contractTokenBalance.div(totFee).mul(_walletFee);
1822 
1823             sendTaxes(
1824                 spentAmount,
1825                 walletFeeInBNB,
1826                 feeWallet,
1827                 marketingFeeToken
1828             );
1829 
1830             totSpentAmount = totSpentAmount + spentAmount;
1831         }
1832 
1833         if (_walletCharityFee != 0) {
1834           spentAmount = contractTokenBalance.div(totFee).mul(_walletCharityFee);
1835 
1836           sendTaxes(
1837             spentAmount,
1838             walletCharityFeeInBNB,
1839             feeWalletCharity,
1840             charityFeeToken
1841           );
1842 
1843           totSpentAmount = totSpentAmount + spentAmount;
1844         }
1845 
1846         if (_walletDevFee != 0) {
1847           spentAmount = contractTokenBalance.div(totFee).mul(_walletDevFee);
1848 
1849           sendTaxes(spentAmount, walletDevFeeInBNB, feeWalletDev, devFeeToken);
1850 
1851           totSpentAmount = totSpentAmount + spentAmount;
1852         }
1853 
1854         if (_liquidityFee != 0) {
1855             contractTokenBalance = contractTokenBalance.sub(totSpentAmount);
1856 
1857             // split the contract balance into halves
1858             uint256 half = contractTokenBalance.div(2);
1859             uint256 otherHalf = contractTokenBalance.sub(half);
1860 
1861             // capture the contract's current ETH balance.
1862             // this is so that we can capture exactly the amount of ETH that the
1863             // swap creates, and not make the liquidity event include any ETH that
1864             // has been manually sent to the contract
1865             uint256 initialBalance = address(this).balance;
1866 
1867             // swap tokens for ETH
1868             swapTokensForBNB(half);
1869 
1870             // how much ETH did we just swap into?
1871             uint256 newBalance = address(this).balance.sub(initialBalance);
1872 
1873             // add liquidity to uniswap
1874             addLiquidity(otherHalf, newBalance);
1875 
1876             emit SwapAndLiquify(half, newBalance, otherHalf);
1877         }
1878     }
1879 
1880     function swapTokensForBNB(uint256 tokenAmount) private {
1881         // generate the uniswap pair path of token -> weth
1882         address[] memory path = new address[](2);
1883         path[0] = address(this);
1884         path[1] = pcsV2Router.WETH();
1885 
1886         _approve(address(this), address(pcsV2Router), tokenAmount);
1887 
1888         // make the swap
1889         pcsV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1890             tokenAmount,
1891             0, // accept any amount of ETH
1892             path,
1893             address(this),
1894             block.timestamp
1895         );
1896     }
1897 
1898     function swapBNBForTokens(uint256 amount) private {
1899         // generate the uniswap pair path of token -> weth
1900         address[] memory path = new address[](2);
1901         path[0] = pcsV2Router.WETH();
1902         path[1] = address(this);
1903 
1904         // make the swap
1905         pcsV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1906             value: amount
1907         }(
1908             0, // accept any amount of Tokens
1909             path,
1910             dead, // Burn address
1911             block.timestamp.add(300)
1912         );
1913     }
1914 
1915     function swapTokensForFeeToken(
1916         address receiver,
1917         address feeToken,
1918         uint256 tokenAmount
1919     ) private {
1920         uint256 initialBalance = (IERC20(feeToken)).balanceOf(address(this));
1921 
1922         address[] memory path = new address[](3);
1923         path[0] = address(this);
1924         path[1] = pcsV2Router.WETH();
1925         path[2] = feeToken;
1926 
1927         _approve(address(this), address(pcsV2Router), tokenAmount);
1928 
1929         // make the swap
1930         pcsV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1931             tokenAmount,
1932             0,
1933             path,
1934             address(this),
1935             block.timestamp.add(300)
1936         );
1937 
1938         uint256 newBalance = (IERC20(feeToken).balanceOf(address(this))).sub(
1939             initialBalance
1940         );
1941 
1942         if (receiver == address(99)) {
1943 
1944         } else {
1945             IERC20(feeToken).transfer(receiver, newBalance);
1946         }
1947     }
1948 
1949     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1950         // approve token transfer to cover all possible scenarios
1951         _approve(address(this), address(pcsV2Router), tokenAmount);
1952 
1953         address liquidAddr = dead;
1954 
1955         if (!burnAutomaticGeneratedLiquidity) {
1956             liquidAddr = owner();
1957         }
1958         // add the liquidity
1959         pcsV2Router.addLiquidityETH{value: ethAmount}(
1960             address(this),
1961             tokenAmount,
1962             0, // slippage is unavoidable
1963             0, // slippage is unavoidable
1964             liquidAddr,
1965             block.timestamp
1966         );
1967     }
1968 
1969     //this method is responsible for taking all fee, if takeFee is true
1970     function _tokenTransfer(
1971         address sender,
1972         address recipient,
1973         uint256 amount,
1974         bool takeFee
1975     ) private {
1976         if (!takeFee) removeAllFee();
1977 
1978         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1979             _transferFromExcluded(sender, recipient, amount);
1980         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1981             _transferToExcluded(sender, recipient, amount);
1982         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1983             _transferStandard(sender, recipient, amount);
1984         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1985             _transferBothExcluded(sender, recipient, amount);
1986         } else {
1987             _transferStandard(sender, recipient, amount);
1988         }
1989 
1990         if (!takeFee) restoreAllFee();
1991     }
1992 
1993     function _transferStandard(
1994         address sender,
1995         address recipient,
1996         uint256 tAmount
1997     ) private {
1998         if (recipient == pcsV2Pair) {
1999             _isSelling = true;
2000         }
2001 
2002         (
2003             uint256 rAmount,
2004             uint256 rTransferAmount,
2005             uint256 rFee,
2006             uint256 tTransferAmount,
2007             uint256 tFee,
2008             uint256 tLiquidity
2009         ) = _getValues(tAmount);
2010 
2011         _rOwned[sender] = _rOwned[sender].sub(rAmount);
2012         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
2013 
2014         _takeLiquidity(tLiquidity);
2015 
2016         _reflectFee(rFee, tFee);
2017         emit Transfer(sender, recipient, tTransferAmount);
2018 
2019         _isSelling = false;
2020     }
2021 
2022     function _transferToExcluded(
2023         address sender,
2024         address recipient,
2025         uint256 tAmount
2026     ) private {
2027         (
2028             uint256 rAmount,
2029             uint256 rTransferAmount,
2030             uint256 rFee,
2031             uint256 tTransferAmount,
2032             uint256 tFee,
2033             uint256 tLiquidity
2034         ) = _getValues(tAmount);
2035         _rOwned[sender] = _rOwned[sender].sub(rAmount);
2036         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
2037         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
2038         _takeLiquidity(tLiquidity);
2039         _reflectFee(rFee, tFee);
2040         emit Transfer(sender, recipient, tTransferAmount);
2041     }
2042 
2043     function _transferFromExcluded(
2044         address sender,
2045         address recipient,
2046         uint256 tAmount
2047     ) private {
2048         (
2049             uint256 rAmount,
2050             uint256 rTransferAmount,
2051             uint256 rFee,
2052             uint256 tTransferAmount,
2053             uint256 tFee,
2054             uint256 tLiquidity
2055         ) = _getValues(tAmount);
2056         _tOwned[sender] = _tOwned[sender].sub(tAmount);
2057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
2058         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
2059         _takeLiquidity(tLiquidity);
2060         _reflectFee(rFee, tFee);
2061         emit Transfer(sender, recipient, tTransferAmount);
2062     }
2063 
2064     function _transferBothExcluded(
2065         address sender,
2066         address recipient,
2067         uint256 tAmount
2068     ) private {
2069         (
2070             uint256 rAmount,
2071             uint256 rTransferAmount,
2072             uint256 rFee,
2073             uint256 tTransferAmount,
2074             uint256 tFee,
2075             uint256 tLiquidity
2076         ) = _getValues(tAmount);
2077         _tOwned[sender] = _tOwned[sender].sub(tAmount);
2078         _rOwned[sender] = _rOwned[sender].sub(rAmount);
2079         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
2080         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
2081         _takeLiquidity(tLiquidity);
2082         _reflectFee(rFee, tFee);
2083         emit Transfer(sender, recipient, tTransferAmount);
2084     }
2085 
2086     function _tokenTransferNoFee(
2087         address sender,
2088         address recipient,
2089         uint256 amount
2090     ) private {
2091         uint256 currentRate = _getRate();
2092         uint256 rAmount = amount.mul(currentRate);
2093 
2094         _rOwned[sender] = _rOwned[sender].sub(rAmount);
2095         _rOwned[recipient] = _rOwned[recipient].add(rAmount);
2096 
2097         if (_isExcluded[sender]) {
2098             _tOwned[sender] = _tOwned[sender].sub(amount);
2099         }
2100         if (_isExcluded[recipient]) {
2101             _tOwned[recipient] = _tOwned[recipient].add(amount);
2102         }
2103         emit Transfer(sender, recipient, amount);
2104     }
2105 
2106     function transferEth(address recipient, uint256 amount) private {
2107         (bool res, ) = recipient.call{value: amount}("");
2108         require(res, "ETH TRANSFER FAILED");
2109     }
2110 
2111     function recoverFunds() external onlyOwner {
2112         payable(owner()).transfer(address(this).balance);
2113     }
2114 
2115     function recoverBEP20(address tokenAddress, uint256 tokenAmount)
2116         external
2117         onlyOwner
2118     {
2119         IERC20(tokenAddress).transfer(owner(), tokenAmount);
2120     }
2121 
2122     function sendTaxes(
2123         uint256 _spentAmount,
2124         bool _walletFeeInBNB,
2125         address _feeWallet,
2126         address _feeToken
2127     ) internal {
2128         if (_walletFeeInBNB) {
2129             uint256 initialBalance = address(this).balance;
2130             // swap tokens for ETH
2131             swapTokensForBNB(_spentAmount);
2132             // how much ETH did we just swap into?
2133             uint256 newBalance = address(this).balance.sub(initialBalance);
2134             transferEth(_feeWallet, newBalance);
2135         } else {
2136             if (_feeToken == address(this)) {
2137 
2138                 _tokenTransferNoFee(address(this), _feeWallet, _spentAmount);
2139 
2140             } else {
2141                 swapTokensForFeeToken(_feeWallet, _feeToken, _spentAmount);
2142             }
2143         }
2144     }
2145 
2146     function setFeeWallet(address payable newFeeWallet) external onlyOwner {
2147         require(newFeeWallet != address(0), "ZERO ADDRESS");
2148         feeWallet = newFeeWallet;
2149     }
2150 
2151     function setMarketingFeeToken(address feeToken) external onlyOwner {
2152         marketingFeeToken = feeToken;
2153     }
2154 
2155     function setFeeWalletCharity(address payable newFeeWallet)
2156         external
2157         onlyOwner
2158     {
2159         require(newFeeWallet != address(0), "ZERO ADDRESS");
2160         feeWalletCharity = newFeeWallet;
2161     }
2162 
2163     function setCharityFeeToken(address feeToken) external onlyOwner {
2164         charityFeeToken = feeToken;
2165     }
2166 
2167     function setDevWallet(address payable _newWallet) external onlyOwner {
2168         require(_newWallet != address(0), "ZERO ADDRESS");
2169         feeWalletDev = _newWallet;
2170     }
2171 
2172     function setDevFeeToken(address feeToken) external onlyOwner {
2173         devFeeToken = feeToken;
2174     }
2175 
2176     function setMaxWalletPercent(uint256 maxWalletPercent) external onlyOwner {
2177         require(
2178             maxWalletPercent >= minMxWalletPercentage && maxWalletPercent <= 10000,
2179             "err"
2180         );
2181         _maxWalletAmount = _tTotal.mul(maxWalletPercent).div(10**4);
2182     }
2183 
2184     function excludeFromMaxWallet(address account, bool isExcluded)
2185         public
2186         onlyOwner
2187     {
2188         _isExcludedFromMaxWallet[account] = isExcluded;
2189     }
2190 
2191     function blacklistAddress(address account, bool value) external onlyOwner {
2192         require(hasBlacklist, "blacklist is disabled");
2193         _isBlacklisted[account] = value;
2194     }
2195 
2196 }
