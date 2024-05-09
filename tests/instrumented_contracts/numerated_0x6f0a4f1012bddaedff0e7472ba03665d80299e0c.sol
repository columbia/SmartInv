1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-20
3 */
4 
5 // File: @openzeppelin/contracts/math/SafeMath.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot overflow.
60      *
61      * _Available since v2.4.0._
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      *
119      * _Available since v2.4.0._
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      *
156      * _Available since v2.4.0._
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
165 
166 pragma solidity ^0.5.0;
167 
168 /**
169  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
170  * the optional functions; to access them see {ERC20Detailed}.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 pragma solidity ^0.5.5;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following 
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Converts an `address` into `address payable`. Note that this is
281      * simply a type cast: the actual underlying value is not changed.
282      *
283      * _Available since v2.4.0._
284      */
285     function toPayable(address account) internal pure returns (address payable) {
286         return address(uint160(account));
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      *
305      * _Available since v2.4.0._
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-call-value
311         (bool success, ) = recipient.call.value(amount)("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
317 
318 pragma solidity ^0.5.0;
319 
320 
321 
322 
323 /**
324  * @title SafeERC20
325  * @dev Wrappers around ERC20 operations that throw on failure (when the token
326  * contract returns false). Tokens that return no value (and instead revert or
327  * throw on failure) are also supported, non-reverting calls are assumed to be
328  * successful.
329  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
330  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
331  */
332 library SafeERC20 {
333     using SafeMath for uint256;
334     using Address for address;
335 
336     function safeTransfer(IERC20 token, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
338     }
339 
340     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
341         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
342     }
343 
344     function safeApprove(IERC20 token, address spender, uint256 value) internal {
345         // safeApprove should only be called when setting an initial allowance,
346         // or when resetting it to zero. To increase and decrease it, use
347         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
348         // solhint-disable-next-line max-line-length
349         require((value == 0) || (token.allowance(address(this), spender) == 0),
350             "SafeERC20: approve from non-zero to non-zero allowance"
351         );
352         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
353     }
354 
355     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
356         uint256 newAllowance = token.allowance(address(this), spender).add(value);
357         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
358     }
359 
360     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
361         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
362         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
363     }
364 
365     /**
366      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
367      * on the return value: the return value is optional (but if data is returned, it must not be false).
368      * @param token The token targeted by the call.
369      * @param data The call data (encoded using abi.encode or one of its variants).
370      */
371     function callOptionalReturn(IERC20 token, bytes memory data) private {
372         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
373         // we're implementing it ourselves.
374 
375         // A Solidity high level call has three parts:
376         //  1. The target address is checked to verify it contains contract code
377         //  2. The call itself is made, and success asserted
378         //  3. The return value is decoded, which in turn checks the size of the returned data.
379         // solhint-disable-next-line max-line-length
380         require(address(token).isContract(), "SafeERC20: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = address(token).call(data);
384         require(success, "SafeERC20: low-level call failed");
385 
386         if (returndata.length > 0) { // Return data is optional
387             // solhint-disable-next-line max-line-length
388             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
389         }
390     }
391 }
392 
393 // File: contracts/IAUSC.sol
394 
395 pragma solidity 0.5.16;
396 
397 interface IAUSC {
398   function rebase(uint256 epoch, uint256 supplyDelta, bool positive) external;
399   function mint(address to, uint256 amount) external;
400 }
401 
402 // File: contracts/IPoolEscrow.sol
403 
404 pragma solidity 0.5.16;
405 
406 interface IPoolEscrow {
407   function notifySecondaryTokens(uint256 number) external;
408 }
409 
410 // File: contracts/BasicRebaser.sol
411 
412 pragma solidity 0.5.16;
413 
414 
415 
416 
417 
418 
419 interface IUniswapV2Pair {
420   function sync() external;
421 }
422 
423 contract BasicRebaser {
424 
425   using SafeMath for uint256;
426   using SafeERC20 for IERC20;
427 
428   event Updated(uint256 xau, uint256 ausc);
429   event NoUpdateXAU();
430   event NoUpdateAUSC();
431   event NoSecondaryMint();
432   event NoRebaseNeeded();
433   event StillCold();
434   event NotInitialized();
435 
436   uint256 public constant BASE = 1e18;
437   uint256 public constant WINDOW_SIZE = 24;
438 
439   address public ausc;
440   uint256[] public pricesXAU = new uint256[](WINDOW_SIZE);
441   uint256[] public pricesAUSC = new uint256[](WINDOW_SIZE);
442   uint256 public pendingXAUPrice = 0;
443   uint256 public pendingAUSCPrice = 0;
444   bool public noPending = true;
445   uint256 public averageXAU;
446   uint256 public averageAUSC;
447   uint256 public lastUpdate;
448   uint256 public frequency = 1 hours;
449   uint256 public counter = 0;
450   uint256 public epoch = 1;
451   address public secondaryPool;
452   address public governance;
453 
454   uint256 public nextRebase = 0; // Wednesday November 25, 2020 09:00:00 (am) in time zone Asia/Seoul (KST) 
455   uint256 public constant REBASE_DELAY = WINDOW_SIZE * 1 hours;
456   IUniswapV2Pair public constant UNIPAIR = IUniswapV2Pair(0x95a5543111343aB2A66a06bc663a1170AcF050b9);
457 
458   modifier onlyGov() {
459     require(msg.sender == governance, "only gov");
460     _;
461   }
462 
463   constructor (address token, address _secondaryPool) public {
464     ausc = token;
465     secondaryPool = _secondaryPool;
466     governance = msg.sender;
467   }
468 
469   function setNextRebase(uint256 next) external onlyGov {
470     require(nextRebase == 0, "Only one time activation");
471     nextRebase = next;
472   }
473 
474   function setGovernance(address account) external onlyGov {
475     governance = account;
476   }
477 
478   function setSecondaryPool(address pool) external onlyGov {
479     secondaryPool = pool;
480   }
481 
482   function checkRebase() external {
483     // ausc ensures that we do not have smart contracts rebasing
484     require (msg.sender == address(ausc), "only through ausc");
485     rebase();
486     recordPrice();
487   }
488 
489   function recordPrice() public {
490     if (msg.sender != tx.origin && msg.sender != address(ausc)) {
491       // smart contracts could manipulate data via flashloans,
492       // thus we forbid them from updating the price
493       return;
494     }
495 
496     if (block.timestamp < lastUpdate + frequency) {
497       // addition is running on timestamps, this will never overflow
498       // we leave at least the specified period between two updates
499       return;
500     }
501 
502     (bool successXAU, uint256 priceXAU) = getPriceXAU();
503     (bool successAUSC, uint256 priceAUSC) = getPriceAUSC();
504     if (!successAUSC) {
505       // price of AUSC was not returned properly
506       emit NoUpdateAUSC();
507       return;
508     }
509     if (!successXAU) {
510       // price of XAU was not returned properly
511       emit NoUpdateXAU();
512       return;
513     }
514     lastUpdate = block.timestamp;
515 
516     if (noPending) {
517       // we start recording with 1 hour delay
518       pendingXAUPrice = priceXAU;
519       pendingAUSCPrice = priceAUSC;
520       noPending = false;
521     } else if (counter < WINDOW_SIZE) {
522       // still in the warming up phase
523       averageXAU = averageXAU.mul(counter).add(pendingXAUPrice).div(counter.add(1));
524       averageAUSC = averageAUSC.mul(counter).add(pendingAUSCPrice).div(counter.add(1));
525       pricesXAU[counter] = pendingXAUPrice;
526       pricesAUSC[counter] = pendingAUSCPrice;
527       pendingXAUPrice = priceXAU;
528       pendingAUSCPrice = priceAUSC;
529       counter++;
530     } else {
531       uint256 index = counter % WINDOW_SIZE;
532       averageXAU = averageXAU.mul(WINDOW_SIZE).sub(pricesXAU[index]).add(pendingXAUPrice).div(WINDOW_SIZE);
533       averageAUSC = averageAUSC.mul(WINDOW_SIZE).sub(pricesAUSC[index]).add(pendingAUSCPrice).div(WINDOW_SIZE);
534       pricesXAU[index] = pendingXAUPrice;
535       pricesAUSC[index] = pendingAUSCPrice;
536       pendingXAUPrice = priceXAU;
537       pendingAUSCPrice = priceAUSC;
538       counter++;
539     }
540     emit Updated(pendingXAUPrice, pendingAUSCPrice);
541   }
542 
543   function rebase() public {
544     // make public rebasing only after initialization
545     if (nextRebase == 0 && msg.sender != governance) {
546       emit NotInitialized();
547       return;
548     }
549     if (counter <= WINDOW_SIZE && msg.sender != governance) {
550       emit StillCold();
551       return;
552     }
553     // We want to rebase only at 12:00 UTC and 12 hours later
554     if (block.timestamp < nextRebase) {
555       return;
556     } else {
557       nextRebase = nextRebase + REBASE_DELAY;
558     }
559 
560     // only rebase if there is a 5% difference between the price of XAU and AUSC
561     uint256 highThreshold = averageXAU.mul(105).div(100);
562     uint256 lowThreshold = averageXAU.mul(95).div(100);
563 
564     if (averageAUSC > highThreshold) {
565       // AUSC is too expensive, this is a positive rebase increasing the supply
566       uint256 factor = BASE.sub(BASE.mul(averageAUSC.sub(averageXAU)).div(averageAUSC.mul(10)));
567       uint256 increase = BASE.sub(factor);
568       uint256 realAdjustment = increase.mul(BASE).div(factor);
569       uint256 currentSupply = IERC20(ausc).totalSupply();
570       uint256 desiredSupply = currentSupply.add(currentSupply.mul(realAdjustment).div(BASE));
571       
572       uint256 secondaryPoolBudget = desiredSupply.sub(currentSupply).mul(10).div(100);
573       desiredSupply = desiredSupply.sub(secondaryPoolBudget);
574 
575       // Cannot underflow as desiredSupply > currentSupply, the result is positive
576       // delta = (desiredSupply / currentSupply) * 100 - 100
577       uint256 delta = desiredSupply.mul(BASE).div(currentSupply).sub(BASE);
578       IAUSC(ausc).rebase(epoch, delta, true);
579 
580       if (secondaryPool != address(0)) {
581         // notify the pool escrow that tokens are available
582         IAUSC(ausc).mint(address(this), secondaryPoolBudget);
583         IERC20(ausc).safeApprove(secondaryPool, 0);
584         IERC20(ausc).safeApprove(secondaryPool, secondaryPoolBudget);
585         IPoolEscrow(secondaryPool).notifySecondaryTokens(secondaryPoolBudget);
586       } else {
587         emit NoSecondaryMint();
588       }
589       UNIPAIR.sync();
590       epoch++;
591     } else if (averageAUSC < lowThreshold) {
592       // AUSC is too cheap, this is a negative rebase decreasing the supply
593       uint256 factor = BASE.add(BASE.mul(averageXAU.sub(averageAUSC)).div(averageAUSC.mul(10)));
594       uint256 increase = factor.sub(BASE);
595       uint256 realAdjustment = increase.mul(BASE).div(factor);
596       uint256 currentSupply = IERC20(ausc).totalSupply();
597       uint256 desiredSupply = currentSupply.sub(currentSupply.mul(realAdjustment).div(BASE));
598 
599       // Cannot overflow as desiredSupply < currentSupply
600       // delta = 100 - (desiredSupply / currentSupply) * 100
601       uint256 delta = uint256(BASE).sub(desiredSupply.mul(BASE).div(currentSupply));
602       IAUSC(ausc).rebase(epoch, delta, false);
603       UNIPAIR.sync();
604       epoch++;
605     } else {
606       // else the price is within bounds
607       emit NoRebaseNeeded();
608     }
609   }
610 
611   /**
612   * Calculates how a rebase would look if it was triggered now.
613   */
614   function calculateRealTimeRebase() public view returns (uint256, uint256) {
615     // only rebase if there is a 5% difference between the price of XAU and AUSC
616     uint256 highThreshold = averageXAU.mul(105).div(100);
617     uint256 lowThreshold = averageXAU.mul(95).div(100);
618 
619     if (averageAUSC > highThreshold) {
620       // AUSC is too expensive, this is a positive rebase increasing the supply
621       uint256 factor = BASE.sub(BASE.mul(averageAUSC.sub(averageXAU)).div(averageAUSC.mul(10)));
622       uint256 increase = BASE.sub(factor);
623       uint256 realAdjustment = increase.mul(BASE).div(factor);
624       uint256 currentSupply = IERC20(ausc).totalSupply();
625       uint256 desiredSupply = currentSupply.add(currentSupply.mul(realAdjustment).div(BASE));
626 
627       uint256 secondaryPoolBudget = desiredSupply.sub(currentSupply).mul(10).div(100);
628       desiredSupply = desiredSupply.sub(secondaryPoolBudget);
629 
630       // Cannot underflow as desiredSupply > currentSupply, the result is positive
631       // delta = (desiredSupply / currentSupply) * 100 - 100
632       uint256 delta = desiredSupply.mul(BASE).div(currentSupply).sub(BASE);
633       return (delta, secondaryPool == address(0) ? 0 : secondaryPoolBudget);
634     } else if (averageAUSC < lowThreshold) {
635       // AUSC is too cheap, this is a negative rebase decreasing the supply
636       uint256 factor = BASE.add(BASE.mul(averageXAU.sub(averageAUSC)).div(averageAUSC.mul(10)));
637       uint256 increase = factor.sub(BASE);
638       uint256 realAdjustment = increase.mul(BASE).div(factor);
639       uint256 currentSupply = IERC20(ausc).totalSupply();
640       uint256 desiredSupply = currentSupply.sub(currentSupply.mul(realAdjustment).div(BASE));
641 
642       // Cannot overflow as desiredSupply < currentSupply
643       // delta = 100 - (desiredSupply / currentSupply) * 100
644       uint256 delta = uint256(BASE).sub(desiredSupply.mul(BASE).div(currentSupply));
645       return (delta, 0);
646     } else {
647       return (0,0);
648     }
649   }
650 
651   function getPriceXAU() public view returns (bool, uint256);
652   function getPriceAUSC() public view returns (bool, uint256);
653 }
654 
655 // File: @chainlink/contracts/src/v0.5/interfaces/AggregatorV3Interface.sol
656 
657 pragma solidity >=0.5.0;
658 
659 interface AggregatorV3Interface {
660 
661   function decimals() external view returns (uint8);
662   function description() external view returns (string memory);
663   function version() external view returns (uint256);
664 
665   // getRoundData and latestRoundData should both raise "No data present"
666   // if they do not have data to report, instead of returning unset values
667   // which could be misinterpreted as actual reported values.
668   function getRoundData(uint80 _roundId)
669     external
670     view
671     returns (
672       uint80 roundId,
673       int256 answer,
674       uint256 startedAt,
675       uint256 updatedAt,
676       uint80 answeredInRound
677     );
678   function latestRoundData()
679     external
680     view
681     returns (
682       uint80 roundId,
683       int256 answer,
684       uint256 startedAt,
685       uint256 updatedAt,
686       uint80 answeredInRound
687     );
688 
689 }
690 
691 // File: contracts/ChainlinkOracle.sol
692 
693 pragma solidity 0.5.16;
694 
695 
696 
697 contract ChainlinkOracle {
698 
699   using SafeMath for uint256;
700 
701   address public constant oracle = 0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6;
702   uint256 public constant ozToMg = 311035000;
703   uint256 public constant ozToMgPrecision = 1e4;
704 
705   constructor () public {
706   }
707 
708   function getPriceXAU() public view returns (bool, uint256) {
709     // answer has 8 decimals, it is the price of 1 oz of gold in USD
710     // if the round is not completed, updated at is 0
711     (,int256 answer,,uint256 updatedAt,) = AggregatorV3Interface(oracle).latestRoundData();
712     // add 10 decimals at the end
713     return (updatedAt != 0, uint256(answer).mul(ozToMgPrecision).div(ozToMg).mul(1e10));
714   }
715 }
716 
717 // File: contracts/UniswapOracle.sol
718 
719 pragma solidity 0.5.16;
720 
721 
722 
723 
724 contract IUniswapRouterV2 {
725   function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts);
726 }
727 
728 contract UniswapOracle {
729 
730   using SafeMath for uint256;
731 
732   address public constant oracle = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
733   address public constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
734   address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
735   address public ausc;
736   address[] public path;
737 
738   constructor (address token) public {
739     ausc = token;
740     path = [ausc, weth, usdc];
741   }
742 
743   function getPriceAUSC() public view returns (bool, uint256) {
744     // returns the price with 6 decimals, but we want 18
745     uint256[] memory amounts = IUniswapRouterV2(oracle).getAmountsOut(1e18, path);
746     return (ausc != address(0), amounts[2].mul(1e12));
747   }
748 }
749 
750 // File: contracts/Rebaser.sol
751 
752 pragma solidity 0.5.16;
753 
754 
755 
756 
757 contract Rebaser is BasicRebaser, UniswapOracle, ChainlinkOracle {
758 
759   constructor (address token, address _treasury)
760   BasicRebaser(token, _treasury)
761   UniswapOracle(token) public {
762   }
763 
764 }