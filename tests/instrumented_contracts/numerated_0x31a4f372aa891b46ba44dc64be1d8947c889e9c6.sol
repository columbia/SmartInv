1 // $SHOCO - ShibaChocolate
2 // Telegram: https://t.me/ShibaChocolate
3 // Fair Launch, no Dev Tokens. 100% LP.
4 // Snipers will be nuked.
5 
6 // LP Lock immediately on launch.
7 // Ownership will be renounced 30 minutes after launch.
8 
9 // Slippage Recommended: 9-12%
10 // No supply limit: 60s cooldown between transfers.
11 
12 /**
13  *                   ▄              ▄
14  *                  ▌▒█           ▄▀▒▌
15  *                  ▌▒▒█        ▄▀▒▒▒▐
16  *                 ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
17  *               ▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
18  *             ▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
19  *            ▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌
20  *            ▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
21  *           ▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌
22  *           ▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌
23  *          ▌▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐
24  *          ▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
25  *          ▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐
26  *           ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌
27  *           ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐
28  *            ▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌
29  *              ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
30  *                ▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
31  *                   ▒▒▒▒▒▒▒▒▒▒▀▀
32 */
33 
34 // SPDX-License-Identifier: Unlicensed
35 pragma solidity ^0.6.12;
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 interface IERC20 {
49     /**
50     * @dev Returns the amount of tokens in existence.
51     */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55     * @dev Returns the amount of tokens owned by `account`.
56     */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60     * @dev Moves `amount` tokens from the caller's account to `recipient`.
61     *
62     * Returns a boolean value indicating whether the operation succeeded.
63     *
64     * Emits a {Transfer} event.
65     */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69     * @dev Returns the remaining number of tokens that `spender` will be
70     * allowed to spend on behalf of `owner` through {transferFrom}. This is
71     * zero by default.
72     *
73     * This value changes when {approve} or {transferFrom} are called.
74     */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79     *
80     * Returns a boolean value indicating whether the operation succeeded.
81     *
82     * IMPORTANT: Beware that changing an allowance with this method brings the risk
83     * that someone may use both the old and the new allowance by unfortunate
84     * transaction ordering. One possible solution to mitigate this race
85     * condition is to first reduce the spender's allowance to 0 and set the
86     * desired value afterwards:
87     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88     *
89     * Emits an {Approval} event.
90     */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94     * @dev Moves `amount` tokens from `sender` to `recipient` using the
95     * allowance mechanism. `amount` is then deducted from the caller's
96     * allowance.
97     *
98     * Returns a boolean value indicating whether the operation succeeded.
99     *
100     * Emits a {Transfer} event.
101     */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105     * @dev Emitted when `value` tokens are moved from one account (`from`) to
106     * another (`to`).
107     *
108     * Note that `value` may be zero.
109     */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114     * a call to {approve}. `value` is the new allowance.
115     */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 library SafeMath {
120     /**
121     * @dev Returns the addition of two unsigned integers, reverting on
122     * overflow.
123     *
124     * Counterpart to Solidity's `+` operator.
125     *
126     * Requirements:
127     *
128     * - Addition cannot overflow.
129     */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138     * @dev Returns the subtraction of two unsigned integers, reverting on
139     * overflow (when the result is negative).
140     *
141     * Counterpart to Solidity's `-` operator.
142     *
143     * Requirements:
144     *
145     * - Subtraction cannot overflow.
146     */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153     * overflow (when the result is negative).
154     *
155     * Counterpart to Solidity's `-` operator.
156     *
157     * Requirements:
158     *
159     * - Subtraction cannot overflow.
160     */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169     * @dev Returns the multiplication of two unsigned integers, reverting on
170     * overflow.
171     *
172     * Counterpart to Solidity's `*` operator.
173     *
174     * Requirements:
175     *
176     * - Multiplication cannot overflow.
177     */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193     * @dev Returns the integer division of two unsigned integers. Reverts on
194     * division by zero. The result is rounded towards zero.
195     *
196     * Counterpart to Solidity's `/` operator. Note: this function uses a
197     * `revert` opcode (which leaves remaining gas untouched) while Solidity
198     * uses an invalid opcode to revert (consuming all remaining gas).
199     *
200     * Requirements:
201     *
202     * - The divisor cannot be zero.
203     */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210     * division by zero. The result is rounded towards zero.
211     *
212     * Counterpart to Solidity's `/` operator. Note: this function uses a
213     * `revert` opcode (which leaves remaining gas untouched) while Solidity
214     * uses an invalid opcode to revert (consuming all remaining gas).
215     *
216     * Requirements:
217     *
218     * - The divisor cannot be zero.
219     */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230     * Reverts when dividing by zero.
231     *
232     * Counterpart to Solidity's `%` operator. This function uses a `revert`
233     * opcode (which leaves remaining gas untouched) while Solidity uses an
234     * invalid opcode to revert (consuming all remaining gas).
235     *
236     * Requirements:
237     *
238     * - The divisor cannot be zero.
239     */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246     * Reverts with custom message when dividing by zero.
247     *
248     * Counterpart to Solidity's `%` operator. This function uses a `revert`
249     * opcode (which leaves remaining gas untouched) while Solidity uses an
250     * invalid opcode to revert (consuming all remaining gas).
251     *
252     * Requirements:
253     *
254     * - The divisor cannot be zero.
255     */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 library Address {
263     /**
264     * @dev Returns true if `account` is a contract.
265     *
266     * [IMPORTANT]
267     * ====
268     * It is unsafe to assume that an address for which this function returns
269     * false is an externally-owned account (EOA) and not a contract.
270     *
271     * Among others, `isContract` will return false for the following
272     * types of addresses:
273     *
274     *  - an externally-owned account
275     *  - a contract in construction
276     *  - an address where a contract will be created
277     *  - an address where a contract lived, but was destroyed
278     * ====
279     */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293     * `recipient`, forwarding all available gas and reverting on errors.
294     *
295     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296     * of certain opcodes, possibly making contracts go over the 2300 gas limit
297     * imposed by `transfer`, making them unable to receive funds via
298     * `transfer`. {sendValue} removes this limitation.
299     *
300     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301     *
302     * IMPORTANT: because control is transferred to `recipient`, care must be
303     * taken to not create reentrancy vulnerabilities. Consider using
304     * {ReentrancyGuard} or the
305     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306     */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316     * @dev Performs a Solidity function call using a low level `call`. A
317     * plain`call` is an unsafe replacement for a function call: use this
318     * function instead.
319     *
320     * If `target` reverts with a revert reason, it is bubbled up by this
321     * function (like regular Solidity function calls).
322     *
323     * Returns the raw returned data. To convert to the expected return value,
324     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325     *
326     * Requirements:
327     *
328     * - `target` must be a contract.
329     * - calling `target` with `data` must not revert.
330     *
331     * _Available since v3.1._
332     */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339     * `errorMessage` as a fallback revert reason when `target` reverts.
340     *
341     * _Available since v3.1._
342     */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349     * but also transferring `value` wei to `target`.
350     *
351     * Requirements:
352     *
353     * - the calling contract must have an ETH balance of at least `value`.
354     * - the called Solidity function must be `payable`.
355     *
356     * _Available since v3.1._
357     */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364     * with `errorMessage` as a fallback revert reason when `target` reverts.
365     *
366     * _Available since v3.1._
367     */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 contract Ownable is Context {
398     address private _owner;
399     address private _previousOwner;
400     uint256 private _lockTime;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405     * @dev Initializes the contract setting the deployer as the initial owner.
406     */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414     * @dev Returns the address of the current owner.
415     */
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     /**
421     * @dev Throws if called by any account other than the owner.
422     */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428     /**
429     * @dev Leaves the contract without owner. It will not be possible to call
430     * `onlyOwner` functions anymore. Can only be called by the current owner.
431     *
432     * NOTE: Renouncing ownership will leave the contract without an owner,
433     * thereby removing any functionality that is only available to the owner.
434     */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441     * @dev Transfers ownership of the contract to a new account (`newOwner`).
442     * Can only be called by the current owner.
443     */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 
450     function geUnlockTime() public view returns (uint256) {
451         return _lockTime;
452     }
453 
454     //Locks the contract for owner for the amount of time provided
455     function lock(uint256 time) public virtual onlyOwner {
456         _previousOwner = _owner;
457         _owner = address(0);
458         _lockTime = now + time;
459         emit OwnershipTransferred(_owner, address(0));
460     }
461 
462     //Unlocks the contract for owner when _lockTime is exceeds
463     function unlock() public virtual {
464         require(_previousOwner == msg.sender, "You don't have permission to unlock");
465         require(now > _lockTime , "Contract is locked until 7 days");
466         emit OwnershipTransferred(_owner, _previousOwner);
467         _owner = _previousOwner;
468     }
469 }
470 
471 interface IUniswapV2Factory {
472     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
473 
474     function feeTo() external view returns (address);
475     function feeToSetter() external view returns (address);
476 
477     function getPair(address tokenA, address tokenB) external view returns (address pair);
478     function allPairs(uint) external view returns (address pair);
479     function allPairsLength() external view returns (uint);
480 
481     function createPair(address tokenA, address tokenB) external returns (address pair);
482 
483     function setFeeTo(address) external;
484     function setFeeToSetter(address) external;
485 }
486 
487 interface IUniswapV2Pair {
488     event Approval(address indexed owner, address indexed spender, uint value);
489     event Transfer(address indexed from, address indexed to, uint value);
490 
491     function name() external pure returns (string memory);
492     function symbol() external pure returns (string memory);
493     function decimals() external pure returns (uint8);
494     function totalSupply() external view returns (uint);
495     function balanceOf(address owner) external view returns (uint);
496     function allowance(address owner, address spender) external view returns (uint);
497 
498     function approve(address spender, uint value) external returns (bool);
499     function transfer(address to, uint value) external returns (bool);
500     function transferFrom(address from, address to, uint value) external returns (bool);
501 
502     function DOMAIN_SEPARATOR() external view returns (bytes32);
503     function PERMIT_TYPEHASH() external pure returns (bytes32);
504     function nonces(address owner) external view returns (uint);
505 
506     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
507 
508     event Mint(address indexed sender, uint amount0, uint amount1);
509     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
510     event Swap(
511         address indexed sender,
512         uint amount0In,
513         uint amount1In,
514         uint amount0Out,
515         uint amount1Out,
516         address indexed to
517     );
518     event Sync(uint112 reserve0, uint112 reserve1);
519 
520     function MINIMUM_LIQUIDITY() external pure returns (uint);
521     function factory() external view returns (address);
522     function token0() external view returns (address);
523     function token1() external view returns (address);
524     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
525     function price0CumulativeLast() external view returns (uint);
526     function price1CumulativeLast() external view returns (uint);
527     function kLast() external view returns (uint);
528 
529     function mint(address to) external returns (uint liquidity);
530     function burn(address to) external returns (uint amount0, uint amount1);
531     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
532     function skim(address to) external;
533     function sync() external;
534 
535     function initialize(address, address) external;
536 }
537 
538 interface IUniswapV2Router01 {
539     function factory() external pure returns (address);
540     function WETH() external pure returns (address);
541 
542     function addLiquidity(
543         address tokenA,
544         address tokenB,
545         uint amountADesired,
546         uint amountBDesired,
547         uint amountAMin,
548         uint amountBMin,
549         address to,
550         uint deadline
551     ) external returns (uint amountA, uint amountB, uint liquidity);
552     function addLiquidityETH(
553         address token,
554         uint amountTokenDesired,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline
559     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
560     function removeLiquidity(
561         address tokenA,
562         address tokenB,
563         uint liquidity,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB);
569     function removeLiquidityETH(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountToken, uint amountETH);
577     function removeLiquidityWithPermit(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountA, uint amountB);
587     function removeLiquidityETHWithPermit(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountToken, uint amountETH);
596     function swapExactTokensForTokens(
597         uint amountIn,
598         uint amountOutMin,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external returns (uint[] memory amounts);
603     function swapTokensForExactTokens(
604         uint amountOut,
605         uint amountInMax,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
611     external
612     payable
613     returns (uint[] memory amounts);
614     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
615     external
616     returns (uint[] memory amounts);
617     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
618     external
619     returns (uint[] memory amounts);
620     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
621     external
622     payable
623     returns (uint[] memory amounts);
624 
625     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
626     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
627     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
628     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
629     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
630 }
631 
632 interface IUniswapV2Router02 is IUniswapV2Router01 {
633     function removeLiquidityETHSupportingFeeOnTransferTokens(
634         address token,
635         uint liquidity,
636         uint amountTokenMin,
637         uint amountETHMin,
638         address to,
639         uint deadline
640     ) external returns (uint amountETH);
641     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline,
648         bool approveMax, uint8 v, bytes32 r, bytes32 s
649     ) external returns (uint amountETH);
650 
651     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
652         uint amountIn,
653         uint amountOutMin,
654         address[] calldata path,
655         address to,
656         uint deadline
657     ) external;
658     function swapExactETHForTokensSupportingFeeOnTransferTokens(
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external payable;
664     function swapExactTokensForETHSupportingFeeOnTransferTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external;
671 }
672 
673 // Contract implementation
674 contract Shoco is Context, IERC20, Ownable {
675     using SafeMath for uint256;
676     using Address for address;
677 
678     mapping (address => uint256) private _rOwned;
679     mapping (address => uint256) private _tOwned;
680     mapping (address => uint256) private _lastTx;
681     mapping (address => uint256) private _cooldownTradeAttempts;
682     mapping (address => mapping (address => uint256)) private _allowances;
683 
684     mapping (address => bool) private _isExcludedFromFee;
685 
686     mapping (address => bool) private _isExcluded;
687     address[] private _excluded;
688     mapping (address => bool) private _isSniper;
689     address[] private _confirmedSnipers;
690 
691     uint256 private constant MAX = ~uint256(0);
692     uint256 private _tTotal = 1000000000000000000000000;
693     uint256 private _rTotal = (MAX - (MAX % _tTotal));
694     uint256 private _tFeeTotal;
695 
696     string private _name = 'Shiba Chocolate | t.me/ShibaChocolate';
697     string private _symbol = 'SHOCO \xF0\x9F\x8D\xAB';
698     uint8 private _decimals = 9;
699 
700     uint256 private _taxFee = 1;
701     uint256 private _teamDev = 0;
702     uint256 private _previousTaxFee = _taxFee;
703     uint256 private _previousTeamDev = _teamDev;
704 
705     address payable private _teamDevAddress;
706 
707     IUniswapV2Router02 public immutable uniswapV2Router;
708     address public immutable uniswapV2Pair;
709 
710     bool inSwap = false;
711     bool public swapEnabled = true;
712     bool public tradingOpen = false; //once switched on, can never be switched off.
713     bool public cooldownEnabled = true; //cooldown time on transactions
714     bool public uniswapOnly = true; //prevents users from tx'ing to other wallets to avoid cooldowns
715 
716     uint256 public _maxTxAmount = 1000000000000000000000000;
717     uint256 private _numOfTokensToExchangeForTeamDev = 5000000000000000000;
718     bool _txLimitsEnabled = true;
719 
720     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
721     event SwapEnabledUpdated(bool enabled);
722 
723     modifier lockTheSwap {
724         inSwap = true;
725         _;
726         inSwap = false;
727     }
728 
729     constructor () public {
730         _rOwned[_msgSender()] = _rTotal;
731 
732         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
733         // Create a uniswap pair for this new token
734         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
735         .createPair(address(this), _uniswapV2Router.WETH());
736 
737         // set the rest of the contract variables
738         uniswapV2Router = _uniswapV2Router;
739         // Exclude owner and this contract from fee
740         _isExcludedFromFee[owner()] = true;
741         _isExcludedFromFee[address(this)] = true;
742 
743         // List of publicly available front-runner & sniper bots
744         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
745         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
746 
747         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
748         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
749 
750         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
751         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
752 
753         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
754         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
755 
756         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
757         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
758 
759         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
760         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
761 
762         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
763         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
764 
765         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
766         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
767 
768         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
769         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
770 
771         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
772         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
773 
774         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
775         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
776 
777         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
778         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
779 
780         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
781         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
782 
783         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
784         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
785 
786         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
787         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
788 
789         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
790         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
791 
792         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
793         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
794 
795         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
796         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
797 
798         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
799         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
800 
801         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
802         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
803 
804         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
805         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
806 
807         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
808         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
809 
810         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
811         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
812 
813         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
814         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
815 
816         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
817         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
818 
819         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
820         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
821 
822         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
823         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
824 
825         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
826         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
827 
828         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
829         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
830 
831         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
832         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
833 
834         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
835         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
836 
837         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
838         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
839 
840         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
841         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
842 
843         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
844         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
845 
846         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
847         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
848 
849         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
850         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
851 
852         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
853         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
854 
855         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
856         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
857 
858         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
859         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
860 
861         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
862         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
863 
864         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
865         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
866 
867         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
868         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
869 
870         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
871         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
872 
873         _teamDev = 8;
874         _teamDevAddress = payable(0x71099527F4c5B626b3D7915B1C3E893863587551);
875 
876         emit Transfer(address(0), _msgSender(), _tTotal);
877     }
878 
879     function openTrading() external onlyOwner() {
880         swapEnabled = true;
881         cooldownEnabled = true;
882         tradingOpen = true;
883     }
884 
885     function name() public view returns (string memory) {
886         return _name;
887     }
888 
889     function symbol() public view returns (string memory) {
890         return _symbol;
891     }
892 
893     function decimals() public view returns (uint8) {
894         return _decimals;
895     }
896 
897     function totalSupply() public view override returns (uint256) {
898         return _tTotal;
899     }
900 
901     function balanceOf(address account) public view override returns (uint256) {
902         if (_isExcluded[account]) return _tOwned[account];
903         return tokenFromReflection(_rOwned[account]);
904     }
905 
906     function transfer(address recipient, uint256 amount) public override returns (bool) {
907         _transfer(_msgSender(), recipient, amount);
908         return true;
909     }
910 
911     function allowance(address owner, address spender) public view override returns (uint256) {
912         return _allowances[owner][spender];
913     }
914 
915     function approve(address spender, uint256 amount) public override returns (bool) {
916         _approve(_msgSender(), spender, amount);
917         return true;
918     }
919 
920     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
921         _transfer(sender, recipient, amount);
922         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
923         return true;
924     }
925 
926     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
927         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
928         return true;
929     }
930 
931     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
932         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
933         return true;
934     }
935 
936     function isExcluded(address account) public view returns (bool) {
937         return _isExcluded[account];
938     }
939 
940     function isBlackListed(address account) public view returns (bool) {
941         return _isSniper[account];
942     }
943 
944     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
945         _isExcludedFromFee[account] = excluded;
946     }
947 
948     function totalFees() public view returns (uint256) {
949         return _tFeeTotal;
950     }
951 
952     function deliver(uint256 tAmount) public {
953         address sender = _msgSender();
954         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
955         (uint256 rAmount,,,,,) = _getValues(tAmount);
956         _rOwned[sender] = _rOwned[sender].sub(rAmount);
957         _rTotal = _rTotal.sub(rAmount);
958         _tFeeTotal = _tFeeTotal.add(tAmount);
959     }
960 
961     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
962         require(tAmount <= _tTotal, "Amount must be less than supply");
963         if (!deductTransferFee) {
964             (uint256 rAmount,,,,,) = _getValues(tAmount);
965             return rAmount;
966         } else {
967             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
968             return rTransferAmount;
969         }
970     }
971 
972     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
973         require(rAmount <= _rTotal, "Amount must be less than total reflections");
974         uint256 currentRate =  _getRate();
975         return rAmount.div(currentRate);
976     }
977 
978     function excludeAccount(address account) external onlyOwner() {
979         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
980         require(!_isExcluded[account], "Account is already excluded");
981         if(_rOwned[account] > 0) {
982             _tOwned[account] = tokenFromReflection(_rOwned[account]);
983         }
984         _isExcluded[account] = true;
985         _excluded.push(account);
986     }
987 
988     function includeAccount(address account) external onlyOwner() {
989         require(_isExcluded[account], "Account is already excluded");
990         for (uint256 i = 0; i < _excluded.length; i++) {
991             if (_excluded[i] == account) {
992                 _excluded[i] = _excluded[_excluded.length - 1];
993                 _tOwned[account] = 0;
994                 _isExcluded[account] = false;
995                 _excluded.pop();
996                 break;
997             }
998         }
999     }
1000 
1001     function RemoveSniper(address account) external onlyOwner() {
1002         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1003         require(!_isSniper[account], "Account is already blacklisted");
1004         _isSniper[account] = true;
1005         _confirmedSnipers.push(account);
1006     }
1007 
1008     function amnestySniper(address account) external onlyOwner() {
1009         require(_isSniper[account], "Account is not blacklisted");
1010         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1011             if (_confirmedSnipers[i] == account) {
1012                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1013                 _isSniper[account] = false;
1014                 _confirmedSnipers.pop();
1015                 break;
1016             }
1017         }
1018     }
1019 
1020     function removeAllFee() private {
1021         if(_taxFee == 0 && _teamDev == 0) return;
1022 
1023         _previousTaxFee = _taxFee;
1024         _previousTeamDev = _teamDev;
1025 
1026         _taxFee = 0;
1027         _teamDev = 0;
1028     }
1029 
1030     function restoreAllFee() private {
1031         _taxFee = _previousTaxFee;
1032         _teamDev = _previousTeamDev;
1033     }
1034 
1035     function isExcludedFromFee(address account) public view returns(bool) {
1036         return _isExcludedFromFee[account];
1037     }
1038 
1039     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1040         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1041             10**2
1042         );
1043     }
1044 
1045     function _approve(address owner, address spender, uint256 amount) private {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     function _transfer(address sender, address recipient, uint256 amount) private {
1054         require(sender != address(0), "ERC20: transfer from the zero address");
1055         require(recipient != address(0), "ERC20: transfer to the zero address");
1056         require(amount > 0, "Transfer amount must be greater than zero");
1057         require(!_isSniper[recipient], "You have no power here!");
1058         require(!_isSniper[msg.sender], "You have no power here!");
1059 
1060         if(sender != owner() && recipient != owner()) {
1061 
1062             if (!tradingOpen) {
1063                 if (!(sender == address(this) || recipient == address(this)
1064                 || sender == address(owner()) || recipient == address(owner()))) {
1065                     require(tradingOpen, "Trading is not enabled");
1066                 }
1067             }
1068 
1069             if (cooldownEnabled) {
1070                 if (block.timestamp > _lastTx[sender]) {
1071                     _lastTx[sender] = block.timestamp + 60 seconds;
1072                 } else {
1073                     require(!cooldownEnabled, "You're on cooldown! 60s between trades!");
1074                 }
1075             }
1076 
1077             if (uniswapOnly) {
1078                 if (
1079                     sender != address(this) &&
1080                     recipient != address(this) &&
1081                     sender != address(uniswapV2Router) &&
1082                     recipient != address(uniswapV2Router)
1083                 ) {
1084                     require(
1085                         _msgSender() == address(uniswapV2Router) ||
1086                         _msgSender() == uniswapV2Pair,
1087                         "ERR: Uniswap only"
1088                     );
1089                 }
1090             }
1091         }
1092 
1093         // is the token balance of this contract address over the min number of
1094         // tokens that we need to initiate a swap?
1095         // also, don't get caught in a circular charity event.
1096         // also, don't swap if sender is uniswap pair.
1097         uint256 contractTokenBalance = balanceOf(address(this));
1098 
1099         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
1100         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1101             // We need to swap the current tokens to ETH and send to the charity wallet
1102             swapTokensForEth(contractTokenBalance);
1103 
1104             uint256 contractETHBalance = address(this).balance;
1105             if(contractETHBalance > 0) {
1106                 sendETHToTeamDev(address(this).balance);
1107             }
1108         }
1109 
1110         //indicates if fee should be deducted from transfer
1111         bool takeFee = true;
1112 
1113         //if any account belongs to _isExcludedFromFee account then remove the fee
1114         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1115             takeFee = false;
1116         }
1117 
1118         //transfer amount, it will take tax and fee
1119 
1120         _tokenTransfer(sender,recipient,amount,takeFee);
1121     }
1122 
1123     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1124         // generate the uniswap pair path of token -> weth
1125         address[] memory path = new address[](2);
1126         path[0] = address(this);
1127         path[1] = uniswapV2Router.WETH();
1128 
1129         _approve(address(this), address(uniswapV2Router), tokenAmount);
1130 
1131         // make the swap
1132         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1133             tokenAmount,
1134             0, // accept any amount of ETH
1135             path,
1136             address(this),
1137             block.timestamp
1138         );
1139     }
1140 
1141     function sendETHToTeamDev(uint256 amount) private {
1142         _teamDevAddress.transfer(amount.div(2));
1143     }
1144 
1145     // We are exposing these functions to be able to manual swap and send
1146     // in case the token is highly valued and 5M becomes too much
1147     function manualSwap() external onlyOwner() {
1148         uint256 contractBalance = balanceOf(address(this));
1149         swapTokensForEth(contractBalance);
1150     }
1151 
1152     function manualSend() external onlyOwner() {
1153         uint256 contractETHBalance = address(this).balance;
1154         sendETHToTeamDev(contractETHBalance);
1155     }
1156 
1157     function setSwapEnabled(bool enabled) external onlyOwner(){
1158         swapEnabled = enabled;
1159     }
1160 
1161     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1162         if(!takeFee)
1163             removeAllFee();
1164 
1165         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1166             _transferFromExcluded(sender, recipient, amount);
1167         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1168             _transferToExcluded(sender, recipient, amount);
1169         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1170             _transferStandard(sender, recipient, amount);
1171         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1172             _transferBothExcluded(sender, recipient, amount);
1173         } else {
1174             _transferStandard(sender, recipient, amount);
1175         }
1176 
1177         if(!takeFee)
1178             restoreAllFee();
1179     }
1180 
1181     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1182         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1185         _takeCharity(tCharity);
1186         _reflectFee(rFee, tFee);
1187         emit Transfer(sender, recipient, tTransferAmount);
1188     }
1189 
1190     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1191         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1192         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1193         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1194         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1195         _takeCharity(tCharity);
1196         _reflectFee(rFee, tFee);
1197         emit Transfer(sender, recipient, tTransferAmount);
1198     }
1199 
1200     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1201         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1202         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1205         _takeCharity(tCharity);
1206         _reflectFee(rFee, tFee);
1207         emit Transfer(sender, recipient, tTransferAmount);
1208     }
1209 
1210     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1211         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1212         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1213         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1214         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1216         _takeCharity(tCharity);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221     function _takeCharity(uint256 tCharity) private {
1222         uint256 currentRate =  _getRate();
1223         uint256 rCharity = tCharity.mul(currentRate);
1224         _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1225         if(_isExcluded[address(this)])
1226             _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1227     }
1228 
1229     function _reflectFee(uint256 rFee, uint256 tFee) private {
1230         _rTotal = _rTotal.sub(rFee);
1231         _tFeeTotal = _tFeeTotal.add(tFee);
1232     }
1233 
1234     //to recieve ETH from uniswapV2Router when swaping
1235     receive() external payable {}
1236 
1237     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1238         (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _teamDev);
1239         uint256 currentRate =  _getRate();
1240         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1241         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1242     }
1243 
1244     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1245         uint256 tFee = tAmount.mul(taxFee).div(100);
1246         uint256 tCharity = tAmount.mul(charityFee).div(100);
1247         uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1248         return (tTransferAmount, tFee, tCharity);
1249     }
1250 
1251     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1252         uint256 rAmount = tAmount.mul(currentRate);
1253         uint256 rFee = tFee.mul(currentRate);
1254         uint256 rTransferAmount = rAmount.sub(rFee);
1255         return (rAmount, rTransferAmount, rFee);
1256     }
1257 
1258     function _getRate() private view returns(uint256) {
1259         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1260         return rSupply.div(tSupply);
1261     }
1262 
1263     function _getCurrentSupply() private view returns(uint256, uint256) {
1264         uint256 rSupply = _rTotal;
1265         uint256 tSupply = _tTotal;
1266         for (uint256 i = 0; i < _excluded.length; i++) {
1267             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1268             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1269             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1270         }
1271         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1272         return (rSupply, tSupply);
1273     }
1274 
1275     function _getTaxFee() private view returns(uint256) {
1276         return _taxFee;
1277     }
1278 
1279     function _getMaxTxAmount() private view returns(uint256) {
1280         return _maxTxAmount;
1281     }
1282 
1283     function _getETHBalance() public view returns(uint256 balance) {
1284         return address(this).balance;
1285     }
1286 
1287     function _removeTxLimit() external onlyOwner() {
1288         _maxTxAmount = 1000000000000000000000000;
1289     }
1290 
1291     // Yes, there are here if I fucked up on the logic and need to disable them.
1292     function _removeDestLimit() external onlyOwner() {
1293         uniswapOnly = false;
1294     }
1295 
1296     function _disableCooldown() external onlyOwner() {
1297         cooldownEnabled = false;
1298     }
1299 
1300     function _enableCooldown() external onlyOwner() {
1301         cooldownEnabled = true;
1302     }
1303 
1304     function _setExtWallet(address payable teamDevAddress) external onlyOwner() {
1305         _teamDevAddress = teamDevAddress;
1306     }
1307 }