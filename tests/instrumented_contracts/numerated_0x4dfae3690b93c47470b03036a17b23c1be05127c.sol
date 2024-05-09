1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /**
7  *Submitted for verification at Etherscan.io on 2020-09-28
8 */
9 
10 
11 
12 /**
13  * @dev Implementation of the {IERC20} interface.
14  *
15  * This implementation is agnostic to the way tokens are created. This means
16  * that a supply mechanism has to be added in a derived contract using {_mint}.
17  * For a generic mechanism see {ERC20PresetMinterPauser}.
18  *
19  * TIP: For a detailed writeup see our guide
20  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
21  * to implement supply mechanisms].
22  *
23  * We have followed general OpenZeppelin guidelines: functions revert instead
24  * of returning `false` on failure. This behavior is nonetheless conventional
25  * and does not conflict with the expectations of ERC20 applications.
26  *
27  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
28  * This allows applications to reconstruct the allowance for all accounts just
29  * by listening to said events. Other implementations of the EIP may not emit
30  * these events, as it isn't required by the specification.
31  *
32  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
33  * functions have been added to mitigate the well-known issues around setting
34  * allowances. See {IERC20-approve}.
35  */
36 
37 
38 
39 
40 /*
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with GSN meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address payable) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes memory) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 
62 /**
63  * @dev Wrappers over Solidity's arithmetic operations with added overflow
64  * checks.
65  *
66  * Arithmetic operations in Solidity wrap on overflow. This can easily result
67  * in bugs, because programmers usually assume that an overflow raises an
68  * error, which is the standard behavior in high level programming languages.
69  * `SafeMath` restores this intuition by reverting the transaction when an
70  * operation overflows.
71  *
72  * Using this library instead of the unchecked operations eliminates an entire
73  * class of bugs, so it's recommended to use it always.
74  */
75 library SafeMath {
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89 
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
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      *
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         return div(a, b, "SafeMath: division by zero");
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b > 0, errorMessage);
178         uint256 c = a / b;
179         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
186      * Reverts when dividing by zero.
187      *
188      * Counterpart to Solidity's `%` operator. This function uses a `revert`
189      * opcode (which leaves remaining gas untouched) while Solidity uses an
190      * invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
197         return mod(a, b, "SafeMath: modulo by zero");
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts with custom message when dividing by zero.
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
213         require(b != 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 
219 
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP.
222  */
223 interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 
295 pragma solidity ^0.6.2;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 
436 
437 pragma solidity >=0.5.0;
438 
439 interface IUniswapV2Pair {
440     event Approval(address indexed owner, address indexed spender, uint value);
441     event Transfer(address indexed from, address indexed to, uint value);
442 
443     function name() external pure returns (string memory);
444     function symbol() external pure returns (string memory);
445     function decimals() external pure returns (uint8);
446     function totalSupply() external view returns (uint);
447     function balanceOf(address owner) external view returns (uint);
448     function allowance(address owner, address spender) external view returns (uint);
449 
450     function approve(address spender, uint value) external returns (bool);
451     function transfer(address to, uint value) external returns (bool);
452     function transferFrom(address from, address to, uint value) external returns (bool);
453 
454     function DOMAIN_SEPARATOR() external view returns (bytes32);
455     function PERMIT_TYPEHASH() external pure returns (bytes32);
456     function nonces(address owner) external view returns (uint);
457 
458     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
459 
460     event Mint(address indexed sender, uint amount0, uint amount1);
461     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
462     event Swap(
463         address indexed sender,
464         uint amount0In,
465         uint amount1In,
466         uint amount0Out,
467         uint amount1Out,
468         address indexed to
469     );
470     event Sync(uint112 reserve0, uint112 reserve1);
471 
472     function MINIMUM_LIQUIDITY() external pure returns (uint);
473     function factory() external view returns (address);
474     function token0() external view returns (address);
475     function token1() external view returns (address);
476     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
477     function price0CumulativeLast() external view returns (uint);
478     function price1CumulativeLast() external view returns (uint);
479     function kLast() external view returns (uint);
480 
481     function mint(address to) external returns (uint liquidity);
482     function burn(address to) external returns (uint amount0, uint amount1);
483     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
484     function skim(address to) external;
485     function sync() external;
486 
487     function initialize(address, address) external;
488 }
489 
490 
491 
492 
493 
494 
495 
496 
497 pragma solidity >=0.4.0;
498 
499 // computes square roots using the babylonian method
500 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
501 library Babylonian {
502     function sqrt(uint y) internal pure returns (uint z) {
503         if (y > 3) {
504             z = y;
505             uint x = y / 2 + 1;
506             while (x < z) {
507                 z = x;
508                 x = (y / x + x) / 2;
509             }
510         } else if (y != 0) {
511             z = 1;
512         }
513         // else z = 0
514     }
515 }
516 
517 
518 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
519 library FixedPoint {
520     // range: [0, 2**112 - 1]
521     // resolution: 1 / 2**112
522     struct uq112x112 {
523         uint224 _x;
524     }
525 
526     // range: [0, 2**144 - 1]
527     // resolution: 1 / 2**112
528     struct uq144x112 {
529         uint _x;
530     }
531 
532     uint8 private constant RESOLUTION = 112;
533     uint private constant Q112 = uint(1) << RESOLUTION;
534     uint private constant Q224 = Q112 << RESOLUTION;
535 
536     // encode a uint112 as a UQ112x112
537     function encode(uint112 x) internal pure returns (uq112x112 memory) {
538         return uq112x112(uint224(x) << RESOLUTION);
539     }
540 
541     // encodes a uint144 as a UQ144x112
542     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
543         return uq144x112(uint256(x) << RESOLUTION);
544     }
545 
546     // divide a UQ112x112 by a uint112, returning a UQ112x112
547     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
548         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
549         return uq112x112(self._x / uint224(x));
550     }
551 
552     // multiply a UQ112x112 by a uint, returning a UQ144x112
553     // reverts on overflow
554     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
555         uint z;
556         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
557         return uq144x112(z);
558     }
559 
560     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
561     // equivalent to encode(numerator).div(denominator)
562     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
563         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
564         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
565     }
566 
567     // decode a UQ112x112 into a uint112 by truncating after the radix point
568     function decode(uq112x112 memory self) internal pure returns (uint112) {
569         return uint112(self._x >> RESOLUTION);
570     }
571 
572     // decode a UQ144x112 into a uint144 by truncating after the radix point
573     function decode144(uq144x112 memory self) internal pure returns (uint144) {
574         return uint144(self._x >> RESOLUTION);
575     }
576 
577     // take the reciprocal of a UQ112x112
578     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
579         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
580         return uq112x112(uint224(Q224 / self._x));
581     }
582 
583     // square root of a UQ112x112
584     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
585         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
586     }
587 }
588 
589 pragma solidity >=0.5.0;
590 
591 
592 // library with helper methods for oracles that are concerned with computing average prices
593 library UniswapV2OracleLibrary {
594     using FixedPoint for *;
595 
596     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
597     function currentBlockTimestamp() internal view returns (uint32) {
598         return uint32(block.timestamp % 2 ** 32);
599     }
600 
601     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
602     function currentCumulativePrices(
603         address pair
604     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
605         blockTimestamp = currentBlockTimestamp();
606         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
607         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
608 
609         // if time has elapsed since the last update on the pair, mock the accumulated price values
610         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
611         if (blockTimestampLast != blockTimestamp) {
612             // subtraction overflow is desired
613             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
614             // addition overflow is desired
615             // counterfactual
616             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
617             // counterfactual
618             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
619         }
620     }
621 }
622 
623 pragma solidity >=0.5.0;
624 
625 interface IUniswapV2Factory {
626     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
627 
628     function feeTo() external view returns (address);
629     function feeToSetter() external view returns (address);
630 
631     function getPair(address tokenA, address tokenB) external view returns (address pair);
632     function allPairs(uint) external view returns (address pair);
633     function allPairsLength() external view returns (uint);
634 
635     function createPair(address tokenA, address tokenB) external returns (address pair);
636 
637     function setFeeTo(address) external;
638     function setFeeToSetter(address) external;
639 }
640 
641 pragma solidity >=0.5.0;
642 
643 
644 library UniswapV2Library {
645     using SafeMath for uint;
646 
647     // returns sorted token addresses, used to handle return values from pairs sorted in this order
648     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
649         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
650         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
651         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
652     }
653 
654     // calculates the CREATE2 address for a pair without making any external calls
655     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
656         (address token0, address token1) = sortTokens(tokenA, tokenB);
657         pair = address(uint(keccak256(abi.encodePacked(
658                 hex'ff',
659                 factory,
660                 keccak256(abi.encodePacked(token0, token1)),
661                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
662             ))));
663     }
664 
665     // fetches and sorts the reserves for a pair
666     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
667         (address token0,) = sortTokens(tokenA, tokenB);
668         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
669         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
670     }
671 
672     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
673     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
674         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
675         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
676         amountB = amountA.mul(reserveB) / reserveA;
677     }
678 
679     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
680     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
681         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
682         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
683         uint amountInWithFee = amountIn.mul(997);
684         uint numerator = amountInWithFee.mul(reserveOut);
685         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
686         amountOut = numerator / denominator;
687     }
688 
689     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
690     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
691         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
692         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
693         uint numerator = reserveIn.mul(amountOut).mul(1000);
694         uint denominator = reserveOut.sub(amountOut).mul(997);
695         amountIn = (numerator / denominator).add(1);
696     }
697 
698     // performs chained getAmountOut calculations on any number of pairs
699     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
700         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
701         amounts = new uint[](path.length);
702         amounts[0] = amountIn;
703         for (uint i; i < path.length - 1; i++) {
704             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
705             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
706         }
707     }
708 
709     // performs chained getAmountIn calculations on any number of pairs
710     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
711         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
712         amounts = new uint[](path.length);
713         amounts[amounts.length - 1] = amountOut;
714         for (uint i = path.length - 1; i > 0; i--) {
715             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
716             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
717         }
718     }
719 }
720 
721 pragma solidity =0.6.6;
722 
723 contract PEPE_ETH_Oracle {
724     using FixedPoint for *;
725 
726     uint public PERIOD = 10;
727 
728     IUniswapV2Pair public pair;
729     address public token0;
730     address public token1;
731     address public periodSetter;
732 
733     uint    public price0CumulativeLast;
734     uint    public price1CumulativeLast;
735     uint32  public blockTimestampLast;
736     FixedPoint.uq112x112 public price0Average;
737     FixedPoint.uq112x112 public price1Average;
738 
739     constructor(address _pair, address _token0, address _token1, uint256 _price0CumulativeLast, uint256 _price1CumulativeLast, uint32 _blockTimestampLast) public {
740         pair = IUniswapV2Pair(_pair);
741         token0 = _token0;
742         token1 = _token1;
743         price0CumulativeLast = _price0CumulativeLast; // fetch the current accumulated price value (1 / 0)
744         price1CumulativeLast = _price1CumulativeLast; // fetch the current accumulated price value (0 / 1)
745         periodSetter = msg.sender;
746         blockTimestampLast = _blockTimestampLast;
747     }
748     
749     modifier _onlyOwner() {
750         require(msg.sender == periodSetter);
751         _;
752     }
753     
754     function setPeriod(uint _amount) public _onlyOwner {
755         PERIOD = _amount;
756     }
757 
758     function update() external {
759         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
760             UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
761         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
762 
763         // ensure that at least one full period has passed since the last update
764         require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');
765 
766         // overflow is desired, casting never truncates
767         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
768         price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
769         price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));
770 
771         price0CumulativeLast = price0Cumulative;
772         price1CumulativeLast = price1Cumulative;
773         blockTimestampLast = blockTimestamp;
774     }
775 
776     // note this will always return 0 before update has been called successfully for the first time.
777     function consult(address token, uint amountIn) external view returns (uint amountOut) {
778         if (token == token0) {
779             amountOut = price0Average.mul(amountIn).decode144();
780         } else {
781             require(token == token1, 'ExampleOracleSimple: INVALID_TOKEN');
782             amountOut = price1Average.mul(amountIn).decode144();
783         }
784     }
785 }
786 
787 
788 
789 contract Pepe is Context, IERC20 {
790 
791     using SafeMath for uint256;
792     using Address for address;
793 
794     struct stakeTracker {
795         uint256 lastBlockChecked;
796         uint256 rewards;
797         uint256 wojakStaked;
798     }
799 
800     uint256 private _totalSupply;
801     string private _name;
802     string private _symbol;
803     uint8 private _decimals;
804 
805     address private _owner;
806     IERC20 public wojak;
807     PEPE_ETH_Oracle public oracle;
808     address payable public chad;
809     uint256 public tax;
810     uint256 public difficulty;
811 
812 
813     mapping(address => stakeTracker) private _stakedBalances;
814     mapping (address => uint256) private _balances;
815     mapping (address => mapping (address => uint256)) private _allowances;
816 
817     event Staked(address indexed user, uint256 amount, uint256 totalWojakStaked);
818     event Withdrawn(address indexed user, uint256 amount);
819     event Rewarded(address indexed user, uint256 amountClaimed, uint256 value, uint256 tax);
820     
821     constructor (address _wojakAddress) public {
822         _name = "Pepe";
823         _symbol = "PEPE";
824         _decimals = 18;
825         _owner = msg.sender;
826         chad = msg.sender;
827         difficulty = 300000;
828         tax = 25;
829         wojak = IERC20(_wojakAddress);
830         uint256 startingSupply = 5000 ether;
831         _mint(msg.sender, startingSupply);
832 
833     }
834 
835     modifier _onlyOwner() {
836         require(msg.sender == _owner);
837         _;
838     }
839 
840     modifier updateStakingReward(address account) {
841         _stakedBalances[account].rewards = myRewardsBalance(msg.sender);
842         _stakedBalances[account].lastBlockChecked = block.number;        
843         _;
844     }
845 
846     /**
847      * @dev Returns the name of the token.
848      */
849     function name() public view returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev Returns the symbol of the token, usually a shorter version of the
855      * name.
856      */
857     function symbol() public view returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev Returns the number of decimals used to get its user representation.
863      * For example, if `decimals` equals `2`, a balance of `505` tokens should
864      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
865      *
866      * Tokens usually opt for a value of 18, imitating the relationship between
867      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
868      * called.
869      *
870      * NOTE: This information is only used for _display_ purposes: it in
871      * no way affects any of the arithmetic of the contract, including
872      * {IERC20-balanceOf} and {IERC20-transfer}.
873      */
874     function decimals() public view returns (uint8) {
875         return _decimals;
876     }
877 
878     /**
879      * @dev See {IERC20-totalSupply}.
880      */
881     function totalSupply() public view override returns (uint256) {
882         return _totalSupply;
883     }
884 
885     /**
886      * @dev See {IERC20-balanceOf}.
887      */
888     function balanceOf(address account) public view override returns (uint256) {
889         return _balances[account];
890     }
891 
892     /**
893      * @dev See {IERC20-transfer}.
894      *
895      * Requirements:
896      *
897      * - `recipient` cannot be the zero address.
898      * - the caller must have a balance of at least `amount`.
899      */
900     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
901         _transfer(_msgSender(), recipient, amount);
902         return true;
903     }
904 
905     /**
906      * @dev See {IERC20-allowance}.
907      */
908     function allowance(address owner, address spender) public view virtual override returns (uint256) {
909         return _allowances[owner][spender];
910     }
911 
912     /**
913      * @dev See {IERC20-approve}.
914      *
915      * Requirements:
916      *
917      * - `spender` cannot be the zero address.
918      */
919     function approve(address spender, uint256 amount) public virtual override returns (bool) {
920         _approve(_msgSender(), spender, amount);
921         return true;
922     }
923 
924     /**
925      * @dev See {IERC20-transferFrom}.
926      *
927      * Emits an {Approval} event indicating the updated allowance. This is not
928      * required by the EIP. See the note at the beginning of {ERC20};
929      *
930      * Requirements:
931      * - `sender` and `recipient` cannot be the zero address.
932      * - `sender` must have a balance of at least `amount`.
933      * - the caller must have allowance for ``sender``'s tokens of at least
934      * `amount`.
935      */
936     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
937         _transfer(sender, recipient, amount);
938         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
939         return true;
940     }
941 
942     /**
943      * @dev Atomically increases the allowance granted to `spender` by the caller.
944      *
945      * This is an alternative to {approve} that can be used as a mitigation for
946      * problems described in {IERC20-approve}.
947      *
948      * Emits an {Approval} event indicating the updated allowance.
949      *
950      * Requirements:
951      *
952      * - `spender` cannot be the zero address.
953      */
954     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
955         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
956         return true;
957     }
958 
959     /**
960      * @dev Atomically decreases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      * - `spender` must have allowance for the caller of at least
971      * `subtractedValue`.
972      */
973     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
974         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
975         return true;
976     }
977 
978     /**
979      * @dev Moves tokens `amount` from `sender` to `recipient`.
980      *
981      * This is internal function is equivalent to {transfer}, and can be used to
982      * e.g. implement automatic token fees, slashing mechanisms, etc.
983      *
984      * Emits a {Transfer} event.
985      *
986      * Requirements:
987      *
988      * - `sender` cannot be the zero address.
989      * - `recipient` cannot be the zero address.
990      * - `sender` must have a balance of at least `amount`.
991      */
992     
993     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
994         require(sender != address(0), "ERC20: transfer from the zero address");
995         require(recipient != address(0), "ERC20: transfer to the zero address");
996 
997 
998         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
999         _balances[recipient] = _balances[recipient].add(amount);
1000         emit Transfer(sender, recipient, amount);
1001     }  
1002     
1003         function _mint(address account, uint256 amount) internal virtual {
1004         require(account != address(0), "ERC20: mint to the zero address");
1005 
1006 
1007         _totalSupply = _totalSupply.add(amount);
1008         _balances[account] = _balances[account].add(amount);
1009         emit Transfer(address(0), account, amount);
1010     }
1011     
1012     function burn(uint256 amount) public virtual {
1013         _burn(_msgSender(), amount);
1014     }
1015 
1016     /**
1017      * @dev Destroys `amount` tokens from `account`, reducing the
1018      * total supply.
1019      *
1020      * Emits a {Transfer} event with `to` set to the zero address.
1021      *
1022      * Requirements:
1023      *
1024      * - `account` cannot be the zero address.
1025      * - `account` must have at least `amount` tokens.
1026      */
1027     function _burn(address account, uint256 amount) internal virtual {
1028         require(account != address(0), "ERC20: burn from the zero address");
1029 
1030 
1031         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1032         _totalSupply = _totalSupply.sub(amount);
1033         emit Transfer(account, address(0), amount);
1034     }
1035 
1036 
1037 
1038     /**
1039      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1040      *
1041      * This is internal function is equivalent to `approve`, and can be used to
1042      * e.g. set automatic allowances for certain subsystems, etc.
1043      *
1044      * Emits an {Approval} event.
1045      *
1046      * Requirements:
1047      *
1048      * - `owner` cannot be the zero address.
1049      * - `spender` cannot be the zero address.
1050      */
1051     function _approve(address owner, address spender, uint256 amount) internal virtual {
1052         require(owner != address(0), "ERC20: approve from the zero address");
1053         require(spender != address(0), "ERC20: approve to the zero address");
1054 
1055         _allowances[owner][spender] = amount;
1056         emit Approval(owner, spender, amount);
1057     }
1058     
1059     function setChadAddress(address payable chadAddress) public _onlyOwner {
1060         chad = chadAddress;
1061     }
1062     
1063     function setOracleAddress(address _oracle) public _onlyOwner {
1064         oracle = PEPE_ETH_Oracle(_oracle);
1065     }
1066     
1067     function getBlockNum() public view returns (uint256) {
1068         return block.number;
1069     }
1070     
1071     function getLastBlockCheckedNum(address _account) public view returns (uint256) {
1072         return _stakedBalances[_account].lastBlockChecked;
1073     }
1074 
1075     function getAddressStakeAmount(address _account) public view returns (uint256) {
1076         return _stakedBalances[_account].wojakStaked;
1077     }
1078     
1079     function setDifficulty(uint256 _amount) public _onlyOwner {
1080         difficulty = _amount;
1081     }
1082 
1083     function setTax(uint256 _amount) public _onlyOwner {
1084         require(_amount >= 10 && _amount <= 30);
1085         tax = _amount;
1086     }
1087     
1088     function totalStaked() public view returns (uint256) {
1089         return wojak.balanceOf(address(this));
1090     }
1091 
1092     function myRewardsBalance(address account) public view returns (uint256) {
1093         if (block.number > _stakedBalances[account].lastBlockChecked) {
1094             uint256 rewardBlocks = block.number
1095                                         .sub(_stakedBalances[account].lastBlockChecked);
1096                                         
1097                                         
1098              
1099             if (_stakedBalances[account].wojakStaked > 0) {
1100                 return _stakedBalances[account].rewards
1101                                                 .add(
1102                                                 _stakedBalances[account].wojakStaked
1103                                                 .mul(rewardBlocks)
1104                                                 / difficulty);
1105             }                                                  
1106         }
1107 
1108     }
1109 
1110     function stake(uint256 amount) public updateStakingReward(msg.sender) {
1111         require(wojak.transferFrom(msg.sender, address(this), amount));
1112         _stakedBalances[msg.sender].wojakStaked = _stakedBalances[msg.sender].wojakStaked.add(amount);
1113         emit Staked(msg.sender, amount, totalStaked());
1114     }
1115 
1116     function withdraw(uint256 amount) public updateStakingReward(msg.sender) {
1117         require(_stakedBalances[msg.sender].wojakStaked >= amount);
1118         _stakedBalances[msg.sender].wojakStaked = _stakedBalances[msg.sender].wojakStaked.sub(amount);
1119         wojak.transfer(msg.sender, amount);
1120         emit Withdrawn(msg.sender, amount);
1121     }
1122     
1123    function getReward(uint256 amount) public payable updateStakingReward(msg.sender) {
1124        uint256 reward = _stakedBalances[msg.sender].rewards;
1125        require(reward >= amount, "Insufficient PEPE balance");
1126        _stakedBalances[msg.sender].rewards = reward.sub(amount);
1127        uint256 value = oracle.consult(address(this), amount);
1128        uint256 taxed = value.mul(tax).div(100);
1129        require(msg.value >= taxed, "Insufficient ethereum tax");
1130        _mint(msg.sender, amount);
1131        chad.transfer(taxed);
1132        uint256 overpaid = msg.value.sub(taxed);
1133        msg.sender.transfer(overpaid);
1134        emit Rewarded(msg.sender, amount, value, taxed);
1135    }
1136 
1137     
1138 }