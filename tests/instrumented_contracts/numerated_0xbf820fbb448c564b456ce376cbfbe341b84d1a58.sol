1 /*
2 
3 ███╗   ██╗ █████╗ ████████╗██╗   ██╗██████╗ ███████╗    ██████╗  ██████╗ ██╗   ██╗    ██╗███╗   ██╗██╗   ██╗
4 ████╗  ██║██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔════╝    ██╔══██╗██╔═══██╗╚██╗ ██╔╝    ██║████╗  ██║██║   ██║
5 ██╔██╗ ██║███████║   ██║   ██║   ██║██████╔╝█████╗      ██████╔╝██║   ██║ ╚████╔╝     ██║██╔██╗ ██║██║   ██║
6 ██║╚██╗██║██╔══██║   ██║   ██║   ██║██╔══██╗██╔══╝      ██╔══██╗██║   ██║  ╚██╔╝      ██║██║╚██╗██║██║   ██║
7 ██║ ╚████║██║  ██║   ██║   ╚██████╔╝██║  ██║███████╗    ██████╔╝╚██████╔╝   ██║       ██║██║ ╚████║╚██████╔╝
8 ╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═════╝  ╚═════╝    ╚═╝       ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
9 
10 Total Supply: 100,000,000,000,000 WOOINU
11 
12 Total fee: 7%
13 ├ Reflected to holders: 3% of every transfer
14 ├ Added to liquidity: 2% of every transfer
15 ├ Marketing fee: 1% of every transfer
16 └ Burned: 1% of every transfer
17 
18 */
19 
20 //SPDX-License-Identifier: UNLICENSED
21 pragma solidity ^0.6.12;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     /**
36     * @dev Returns the amount of tokens in existence.
37     */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41     * @dev Returns the amount of tokens owned by `account`.
42     */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46     * @dev Moves `amount` tokens from the caller's account to `recipient`.
47     *
48     * Returns a boolean value indicating whether the operation succeeded.
49     *
50     * Emits a {Transfer} event.
51     */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55     * @dev Returns the remaining number of tokens that `spender` will be
56     * allowed to spend on behalf of `owner` through {transferFrom}. This is
57     * zero by default.
58     *
59     * This value changes when {approve} or {transferFrom} are called.
60     */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65     *
66     * Returns a boolean value indicating whether the operation succeeded.
67     *
68     * IMPORTANT: Beware that changing an allowance with this method brings the risk
69     * that someone may use both the old and the new allowance by unfortunate
70     * transaction ordering. One possible solution to mitigate this race
71     * condition is to first reduce the spender's allowance to 0 and set the
72     * desired value afterwards:
73     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74     *
75     * Emits an {Approval} event.
76     */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80     * @dev Moves `amount` tokens from `sender` to `recipient` using the
81     * allowance mechanism. `amount` is then deducted from the caller's
82     * allowance.
83     *
84     * Returns a boolean value indicating whether the operation succeeded.
85     *
86     * Emits a {Transfer} event.
87     */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91     * @dev Emitted when `value` tokens are moved from one account (`from`) to
92     * another (`to`).
93     *
94     * Note that `value` may be zero.
95     */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100     * a call to {approve}. `value` is the new allowance.
101     */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 library SafeMath {
106     /**
107     * @dev Returns the addition of two unsigned integers, reverting on
108     * overflow.
109     *
110     * Counterpart to Solidity's `+` operator.
111     *
112     * Requirements:
113     *
114     * - Addition cannot overflow.
115     */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124     * @dev Returns the subtraction of two unsigned integers, reverting on
125     * overflow (when the result is negative).
126     *
127     * Counterpart to Solidity's `-` operator.
128     *
129     * Requirements:
130     *
131     * - Subtraction cannot overflow.
132     */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139     * overflow (when the result is negative).
140     *
141     * Counterpart to Solidity's `-` operator.
142     *
143     * Requirements:
144     *
145     * - Subtraction cannot overflow.
146     */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155     * @dev Returns the multiplication of two unsigned integers, reverting on
156     * overflow.
157     *
158     * Counterpart to Solidity's `*` operator.
159     *
160     * Requirements:
161     *
162     * - Multiplication cannot overflow.
163     */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179     * @dev Returns the integer division of two unsigned integers. Reverts on
180     * division by zero. The result is rounded towards zero.
181     *
182     * Counterpart to Solidity's `/` operator. Note: this function uses a
183     * `revert` opcode (which leaves remaining gas untouched) while Solidity
184     * uses an invalid opcode to revert (consuming all remaining gas).
185     *
186     * Requirements:
187     *
188     * - The divisor cannot be zero.
189     */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196     * division by zero. The result is rounded towards zero.
197     *
198     * Counterpart to Solidity's `/` operator. Note: this function uses a
199     * `revert` opcode (which leaves remaining gas untouched) while Solidity
200     * uses an invalid opcode to revert (consuming all remaining gas).
201     *
202     * Requirements:
203     *
204     * - The divisor cannot be zero.
205     */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216     * Reverts when dividing by zero.
217     *
218     * Counterpart to Solidity's `%` operator. This function uses a `revert`
219     * opcode (which leaves remaining gas untouched) while Solidity uses an
220     * invalid opcode to revert (consuming all remaining gas).
221     *
222     * Requirements:
223     *
224     * - The divisor cannot be zero.
225     */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232     * Reverts with custom message when dividing by zero.
233     *
234     * Counterpart to Solidity's `%` operator. This function uses a `revert`
235     * opcode (which leaves remaining gas untouched) while Solidity uses an
236     * invalid opcode to revert (consuming all remaining gas).
237     *
238     * Requirements:
239     *
240     * - The divisor cannot be zero.
241     */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 library Address {
249     /**
250     * @dev Returns true if `account` is a contract.
251     *
252     * [IMPORTANT]
253     * ====
254     * It is unsafe to assume that an address for which this function returns
255     * false is an externally-owned account (EOA) and not a contract.
256     *
257     * Among others, `isContract` will return false for the following
258     * types of addresses:
259     *
260     *  - an externally-owned account
261     *  - a contract in construction
262     *  - an address where a contract will be created
263     *  - an address where a contract lived, but was destroyed
264     * ====
265     */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279     * `recipient`, forwarding all available gas and reverting on errors.
280     *
281     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282     * of certain opcodes, possibly making contracts go over the 2300 gas limit
283     * imposed by `transfer`, making them unable to receive funds via
284     * `transfer`. {sendValue} removes this limitation.
285     *
286     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287     *
288     * IMPORTANT: because control is transferred to `recipient`, care must be
289     * taken to not create reentrancy vulnerabilities. Consider using
290     * {ReentrancyGuard} or the
291     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292     */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302     * @dev Performs a Solidity function call using a low level `call`. A
303     * plain`call` is an unsafe replacement for a function call: use this
304     * function instead.
305     *
306     * If `target` reverts with a revert reason, it is bubbled up by this
307     * function (like regular Solidity function calls).
308     *
309     * Returns the raw returned data. To convert to the expected return value,
310     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311     *
312     * Requirements:
313     *
314     * - `target` must be a contract.
315     * - calling `target` with `data` must not revert.
316     *
317     * _Available since v3.1._
318     */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325     * `errorMessage` as a fallback revert reason when `target` reverts.
326     *
327     * _Available since v3.1._
328     */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335     * but also transferring `value` wei to `target`.
336     *
337     * Requirements:
338     *
339     * - the calling contract must have an ETH balance of at least `value`.
340     * - the called Solidity function must be `payable`.
341     *
342     * _Available since v3.1._
343     */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350     * with `errorMessage` as a fallback revert reason when `target` reverts.
351     *
352     * _Available since v3.1._
353     */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 contract Ownable is Context {
384     address private _owner;
385     address private _previousOwner;
386     uint256 private _lockTime;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391     * @dev Initializes the contract setting the deployer as the initial owner.
392     */
393     constructor () internal {
394         address msgSender = _msgSender();
395         _owner = msgSender;
396         emit OwnershipTransferred(address(0), msgSender);
397     }
398 
399     /**
400     * @dev Returns the address of the current owner.
401     */
402     function owner() public view returns (address) {
403         return _owner;
404     }
405 
406     /**
407     * @dev Throws if called by any account other than the owner.
408     */
409     modifier onlyOwner() {
410         require(_owner == _msgSender(), "Ownable: caller is not the owner");
411         _;
412     }
413 
414     /**
415     * @dev Leaves the contract without owner. It will not be possible to call
416     * `onlyOwner` functions anymore. Can only be called by the current owner.
417     *
418     * NOTE: Renouncing ownership will leave the contract without an owner,
419     * thereby removing any functionality that is only available to the owner.
420     */
421     function renounceOwnership() public virtual onlyOwner {
422         emit OwnershipTransferred(_owner, address(0));
423         _owner = address(0);
424     }
425 
426     /**
427     * @dev Transfers ownership of the contract to a new account (`newOwner`).
428     * Can only be called by the current owner.
429     */
430     function transferOwnership(address newOwner) public virtual onlyOwner {
431         require(newOwner != address(0), "Ownable: new owner is the zero address");
432         emit OwnershipTransferred(_owner, newOwner);
433         _owner = newOwner;
434     }
435     
436 }
437 
438 interface IUniswapV2Factory {
439     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
440 
441     function feeTo() external view returns (address);
442     function feeToSetter() external view returns (address);
443 
444     function getPair(address tokenA, address tokenB) external view returns (address pair);
445     function allPairs(uint) external view returns (address pair);
446     function allPairsLength() external view returns (uint);
447 
448     function createPair(address tokenA, address tokenB) external returns (address pair);
449 
450     function setFeeTo(address) external;
451     function setFeeToSetter(address) external;
452 }
453 
454 interface IUniswapV2Pair {
455     event Approval(address indexed owner, address indexed spender, uint value);
456     event Transfer(address indexed from, address indexed to, uint value);
457 
458     function name() external pure returns (string memory);
459     function symbol() external pure returns (string memory);
460     function decimals() external pure returns (uint8);
461     function totalSupply() external view returns (uint);
462     function balanceOf(address owner) external view returns (uint);
463     function allowance(address owner, address spender) external view returns (uint);
464 
465     function approve(address spender, uint value) external returns (bool);
466     function transfer(address to, uint value) external returns (bool);
467     function transferFrom(address from, address to, uint value) external returns (bool);
468 
469     function DOMAIN_SEPARATOR() external view returns (bytes32);
470     function PERMIT_TYPEHASH() external pure returns (bytes32);
471     function nonces(address owner) external view returns (uint);
472 
473     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
474 
475     event Mint(address indexed sender, uint amount0, uint amount1);
476     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
477     event Swap(
478         address indexed sender,
479         uint amount0In,
480         uint amount1In,
481         uint amount0Out,
482         uint amount1Out,
483         address indexed to
484     );
485     event Sync(uint112 reserve0, uint112 reserve1);
486 
487     function MINIMUM_LIQUIDITY() external pure returns (uint);
488     function factory() external view returns (address);
489     function token0() external view returns (address);
490     function token1() external view returns (address);
491     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
492     function price0CumulativeLast() external view returns (uint);
493     function price1CumulativeLast() external view returns (uint);
494     function kLast() external view returns (uint);
495 
496     function mint(address to) external returns (uint liquidity);
497     function burn(address to) external returns (uint amount0, uint amount1);
498     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
499     function skim(address to) external;
500     function sync() external;
501 
502     function initialize(address, address) external;
503 }
504 
505 interface IUniswapV2Router01 {
506     function factory() external pure returns (address);
507     function WETH() external pure returns (address);
508 
509     function addLiquidity(
510         address tokenA,
511         address tokenB,
512         uint amountADesired,
513         uint amountBDesired,
514         uint amountAMin,
515         uint amountBMin,
516         address to,
517         uint deadline
518     ) external returns (uint amountA, uint amountB, uint liquidity);
519     function addLiquidityETH(
520         address token,
521         uint amountTokenDesired,
522         uint amountTokenMin,
523         uint amountETHMin,
524         address to,
525         uint deadline
526     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
527     function removeLiquidity(
528         address tokenA,
529         address tokenB,
530         uint liquidity,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline
535     ) external returns (uint amountA, uint amountB);
536     function removeLiquidityETH(
537         address token,
538         uint liquidity,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountToken, uint amountETH);
544     function removeLiquidityWithPermit(
545         address tokenA,
546         address tokenB,
547         uint liquidity,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline,
552         bool approveMax, uint8 v, bytes32 r, bytes32 s
553     ) external returns (uint amountA, uint amountB);
554     function removeLiquidityETHWithPermit(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline,
561         bool approveMax, uint8 v, bytes32 r, bytes32 s
562     ) external returns (uint amountToken, uint amountETH);
563     function swapExactTokensForTokens(
564         uint amountIn,
565         uint amountOutMin,
566         address[] calldata path,
567         address to,
568         uint deadline
569     ) external returns (uint[] memory amounts);
570     function swapTokensForExactTokens(
571         uint amountOut,
572         uint amountInMax,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external returns (uint[] memory amounts);
577     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
578     external
579     payable
580     returns (uint[] memory amounts);
581     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
582     external
583     returns (uint[] memory amounts);
584     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
585     external
586     returns (uint[] memory amounts);
587     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
588     external
589     payable
590     returns (uint[] memory amounts);
591 
592     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
593     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
594     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
595     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
596     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
597 }
598 
599 interface IUniswapV2Router02 is IUniswapV2Router01 {
600     function removeLiquidityETHSupportingFeeOnTransferTokens(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline
607     ) external returns (uint amountETH);
608     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline,
615         bool approveMax, uint8 v, bytes32 r, bytes32 s
616     ) external returns (uint amountETH);
617 
618     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
619         uint amountIn,
620         uint amountOutMin,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external;
625     function swapExactETHForTokensSupportingFeeOnTransferTokens(
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external payable;
631     function swapExactTokensForETHSupportingFeeOnTransferTokens(
632         uint amountIn,
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external;
638 }
639 
640 // Contract implementation
641 contract wooInu is Context, IERC20, Ownable {
642     using SafeMath for uint256;
643     using Address for address;
644 
645     mapping (address => uint256) private _rOwned;
646     mapping (address => uint256) private _tOwned;
647     mapping (address => mapping (address => uint256)) private _allowances;
648 
649     mapping (address => bool) private _isExcludedFromFee;
650 
651     mapping (address => bool) private _isExcluded; // excluded from reward
652     address[] private _excluded;
653     mapping (address => bool) private _isBlackListedBot;
654     address[] private _blackListedBots;
655 
656     uint256 private constant MAX = ~uint256(0);
657 
658     uint256 private _tTotal = 100_000_000_000_000_000 * 10**9;
659     uint256 private _rTotal = (MAX - (MAX % _tTotal));
660     uint256 private _tFeeTotal;
661 
662     string private _name = 'Nature Boy Inu';
663     string private _symbol = 'WOOINU';
664     uint8 private _decimals = 9;
665 
666     uint256 private _taxFee = 4; // 4% reflection fee for every holder (incl. burn address)
667     uint256 private _marketingFee = 1; // 1% marketing
668     uint256 private _liquidityFee = 2; // 2% into liquidity
669 
670     uint256 private _previousTaxFee = _taxFee;
671     uint256 private _previousMarketingFee = _marketingFee;
672     uint256 private _previousLiquidityFee = _liquidityFee;
673 
674     address payable private _marketingWalletAddress = payable(0x887E8c08376Fcc57bAD00af3906Bb3b8e3f5578a);
675 
676     IUniswapV2Router02 public immutable uniswapV2Router;
677     address public immutable uniswapV2Pair;
678 
679     bool inSwapAndLiquify = false;
680     bool public swapAndLiquifyEnabled = true;
681 
682     // We will set a minimum amount of tokens to be swapped
683     uint256 private _numTokensSellToAddToLiquidity = 1000000000000 * 10**9;
684 
685     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
686     event SwapAndLiquifyEnabledUpdated(bool enabled);
687     event SwapAndLiquify(
688         uint256 tokensSwapped,
689         uint256 ethReceived,
690         uint256 tokensIntoLiqudity
691     );
692 
693     modifier lockTheSwap {
694         inSwapAndLiquify = true;
695         _;
696         inSwapAndLiquify = false;
697     }
698 
699     constructor () public {
700         _rOwned[_msgSender()] = _rTotal;
701 
702         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
703         // Create a uniswap pair for this new token
704         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
705         .createPair(address(this), _uniswapV2Router.WETH());
706 
707         // set the rest of the contract variables
708         uniswapV2Router = _uniswapV2Router;
709 
710         // Exclude owner and this contract from fee
711         _isExcludedFromFee[owner()] = true;
712         _isExcludedFromFee[address(this)] = true;
713         _isExcludedFromFee[_marketingWalletAddress] = true;
714 
715         // BLACKLIST
716         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
717         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
718 
719         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
720         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
721 
722         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
723         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
724 
725         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
726         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
727 
728         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
729         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
730 
731         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
732         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
733 
734         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
735         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
736 
737         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
738         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
739 
740         emit Transfer(address(0), _msgSender(), _tTotal);
741     }
742 
743     function name() public view returns (string memory) {
744         return _name;
745     }
746 
747     function symbol() public view returns (string memory) {
748         return _symbol;
749     }
750 
751     function decimals() public view returns (uint8) {
752         return _decimals;
753     }
754 
755     function totalSupply() public view override returns (uint256) {
756         return _tTotal;
757     }
758 
759     function balanceOf(address account) public view override returns (uint256) {
760         if (_isExcluded[account]) return _tOwned[account];
761         return tokenFromReflection(_rOwned[account]);
762     }
763 
764     function transfer(address recipient, uint256 amount) public override returns (bool) {
765         _transfer(_msgSender(), recipient, amount);
766         return true;
767     }
768 
769     function allowance(address owner, address spender) public view override returns (uint256) {
770         return _allowances[owner][spender];
771     }
772 
773     function approve(address spender, uint256 amount) public override returns (bool) {
774         _approve(_msgSender(), spender, amount);
775         return true;
776     }
777 
778     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
781         return true;
782     }
783 
784     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
785         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
786         return true;
787     }
788 
789     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
790         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
791         return true;
792     }
793 
794     function isExcludedFromReward(address account) public view returns (bool) {
795         return _isExcluded[account];
796     }
797 
798     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
799         _isExcludedFromFee[account] = excluded;
800     }
801 
802     function totalFees() public view returns (uint256) {
803         return _tFeeTotal;
804     }
805 
806     function deliver(uint256 tAmount) public {
807         address sender = _msgSender();
808         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
809         (uint256 rAmount,,,,,) = _getValues(tAmount);
810         _rOwned[sender] = _rOwned[sender].sub(rAmount);
811         _rTotal = _rTotal.sub(rAmount);
812         _tFeeTotal = _tFeeTotal.add(tAmount);
813     }
814 
815     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
816         require(tAmount <= _tTotal, "Amount must be less than supply");
817         if (!deductTransferFee) {
818             (uint256 rAmount,,,,,) = _getValues(tAmount);
819             return rAmount;
820         } else {
821             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
822             return rTransferAmount;
823         }
824     }
825 
826     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
827         require(rAmount <= _rTotal, "Amount must be less than total reflections");
828         uint256 currentRate =  _getRate();
829         return rAmount.div(currentRate);
830     }
831 
832     function excludeFromReward(address account) external onlyOwner() {
833         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
834         require(!_isExcluded[account], "Account is already excluded");
835         if(_rOwned[account] > 0) {
836             _tOwned[account] = tokenFromReflection(_rOwned[account]);
837         }
838         _isExcluded[account] = true;
839         _excluded.push(account);
840     }
841 
842     function includeInReward(address account) external onlyOwner() {
843         require(_isExcluded[account], "Account is already excluded");
844         for (uint256 i = 0; i < _excluded.length; i++) {
845             if (_excluded[i] == account) {
846                 _excluded[i] = _excluded[_excluded.length - 1];
847                 _tOwned[account] = 0;
848                 _isExcluded[account] = false;
849                 _excluded.pop();
850                 break;
851             }
852         }
853     }
854 
855     function addBotToBlackList(address account) external onlyOwner() {
856         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
857         require(!_isBlackListedBot[account], "Account is already blacklisted");
858         _isBlackListedBot[account] = true;
859         _blackListedBots.push(account);
860     }
861 
862     function removeBotFromBlackList(address account) external onlyOwner() {
863         require(_isBlackListedBot[account], "Account is not blacklisted");
864         for (uint256 i = 0; i < _blackListedBots.length; i++) {
865             if (_blackListedBots[i] == account) {
866                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
867                 _isBlackListedBot[account] = false;
868                 _blackListedBots.pop();
869                 break;
870             }
871         }
872     }
873 
874     function removeAllFee() private {
875         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
876 
877         _previousTaxFee = _taxFee;
878         _previousMarketingFee = _marketingFee;
879         _previousLiquidityFee = _liquidityFee;
880 
881         _taxFee = 0;
882         _marketingFee = 0;
883         _liquidityFee = 0;
884     }
885 
886     function restoreAllFee() private {
887         _taxFee = _previousTaxFee;
888         _marketingFee = _previousMarketingFee;
889         _liquidityFee = _previousLiquidityFee;
890     }
891 
892     function isExcludedFromFee(address account) public view returns(bool) {
893         return _isExcludedFromFee[account];
894     }
895 
896     function _approve(address owner, address spender, uint256 amount) private {
897         require(owner != address(0), "ERC20: approve from the zero address");
898         require(spender != address(0), "ERC20: approve to the zero address");
899 
900         _allowances[owner][spender] = amount;
901         emit Approval(owner, spender, amount);
902     }
903 
904     function _transfer(address sender, address recipient, uint256 amount) private {
905         require(sender != address(0), "ERC20: transfer from the zero address");
906         require(recipient != address(0), "ERC20: transfer to the zero address");
907         require(amount > 0, "Transfer amount must be greater than zero");
908         require(!_isBlackListedBot[sender], "You have no power here!");
909         require(!_isBlackListedBot[recipient], "You have no power here!");
910         require(!_isBlackListedBot[tx.origin], "You have no power here!");
911 
912         // is the token balance of this contract address over the min number of
913         // tokens that we need to initiate a swap + liquidity lock?
914         // also, don't get caught in a circular liquidity event.
915         // also, don't swap & liquify if sender is uniswap pair.
916         uint256 contractTokenBalance = balanceOf(address(this));
917 
918         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
919         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
920             contractTokenBalance = _numTokensSellToAddToLiquidity;
921             //add liquidity
922             swapAndLiquify(contractTokenBalance);
923         }
924 
925         //indicates if fee should be deducted from transfer
926         bool takeFee = true;
927 
928         //if any account belongs to _isExcludedFromFee account then remove the fee
929         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
930             takeFee = false;
931         }
932 
933         //transfer amount, it will take tax and charity fee
934         _tokenTransfer(sender, recipient, amount, takeFee);
935     }
936 
937     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
938         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
939         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
940 
941         // split the contract balance into halves
942         uint256 half = toLiquify.div(2);
943         uint256 otherHalf = toLiquify.sub(half);
944 
945         // capture the contract's current ETH balance.
946         // this is so that we can capture exactly the amount of ETH that the
947         // swap creates, and not make the liquidity event include any ETH that
948         // has been manually sent to the contract
949         uint256 initialBalance = address(this).balance;
950 
951         // swap tokens for ETH
952         uint256 toSwapForEth = half.add(toMarketing);
953         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
954 
955         // how much ETH did we just swap into?
956         uint256 fromSwap = address(this).balance.sub(initialBalance);
957         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
958 
959         // add liquidity to uniswap
960         addLiquidity(otherHalf, newBalance);
961 
962         emit SwapAndLiquify(half, newBalance, otherHalf);
963 
964         sendETHToMarketing(fromSwap.sub(newBalance));
965     }
966 
967     function swapTokensForEth(uint256 tokenAmount) private {
968         // generate the uniswap pair path of token -> weth
969         address[] memory path = new address[](2);
970         path[0] = address(this);
971         path[1] = uniswapV2Router.WETH();
972 
973         _approve(address(this), address(uniswapV2Router), tokenAmount);
974 
975         // make the swap
976         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
977             tokenAmount,
978             0, // accept any amount of ETH
979             path,
980             address(this),
981             block.timestamp
982         );
983     }
984 
985     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
986         // approve token transfer to cover all possible scenarios
987         _approve(address(this), address(uniswapV2Router), tokenAmount);
988 
989         // add the liquidity
990         uniswapV2Router.addLiquidityETH{value: ethAmount}(
991             address(this),
992             tokenAmount,
993             0, // slippage is unavoidable
994             0, // slippage is unavoidable
995             owner(),
996             block.timestamp
997         );
998     }
999 
1000     function sendETHToMarketing(uint256 amount) private {
1001         _marketingWalletAddress.transfer(amount);
1002     }
1003 
1004     // We are exposing these functions to be able to manual swap and send
1005     // in case the token is highly valued and 5M becomes too much
1006     function manualSwap() external onlyOwner() {
1007         uint256 contractBalance = balanceOf(address(this));
1008         swapTokensForEth(contractBalance);
1009     }
1010 
1011     function manualSend() public onlyOwner() {
1012         uint256 contractETHBalance = address(this).balance;
1013         sendETHToMarketing(contractETHBalance);
1014     }
1015 
1016     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1017         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1018     }
1019 
1020     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1021         if(!takeFee)
1022             removeAllFee();
1023 
1024         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1025             _transferFromExcluded(sender, recipient, amount);
1026         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1027             _transferToExcluded(sender, recipient, amount);
1028         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1029             _transferStandard(sender, recipient, amount);
1030         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1031             _transferBothExcluded(sender, recipient, amount);
1032         } else {
1033             _transferStandard(sender, recipient, amount);
1034         }
1035 
1036         if(!takeFee)
1037             restoreAllFee();
1038     }
1039 
1040     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1041         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1042         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1043         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1044         _takeMarketingLiquidity(tMarketingLiquidity);
1045         _reflectFee(rFee, tFee);
1046         emit Transfer(sender, recipient, tTransferAmount);
1047     }
1048 
1049     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1050         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1051         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1052         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1053         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1054         _takeMarketingLiquidity(tMarketingLiquidity);
1055         _reflectFee(rFee, tFee);
1056         emit Transfer(sender, recipient, tTransferAmount);
1057     }
1058 
1059     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1060         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1061         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1062         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1063         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1064         _takeMarketingLiquidity(tMarketingLiquidity);
1065         _reflectFee(rFee, tFee);
1066         emit Transfer(sender, recipient, tTransferAmount);
1067     }
1068 
1069     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1070         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1071         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1072         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1073         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1074         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1075         _takeMarketingLiquidity(tMarketingLiquidity);
1076         _reflectFee(rFee, tFee);
1077         emit Transfer(sender, recipient, tTransferAmount);
1078     }
1079 
1080     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1081         uint256 currentRate = _getRate();
1082         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1083         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1084         if(_isExcluded[address(this)])
1085             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1086     }
1087 
1088     function _reflectFee(uint256 rFee, uint256 tFee) private {
1089         _rTotal = _rTotal.sub(rFee);
1090         _tFeeTotal = _tFeeTotal.add(tFee);
1091     }
1092 
1093     //to recieve ETH from uniswapV2Router when swapping
1094     receive() external payable {}
1095 
1096     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1097         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1098         uint256 currentRate = _getRate();
1099         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1100         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1101     }
1102 
1103     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1104         uint256 tFee = tAmount.mul(taxFee).div(100);
1105         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1106         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1107         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1108     }
1109 
1110     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1111         uint256 rAmount = tAmount.mul(currentRate);
1112         uint256 rFee = tFee.mul(currentRate);
1113         uint256 rTransferAmount = rAmount.sub(rFee);
1114         return (rAmount, rTransferAmount, rFee);
1115     }
1116 
1117     function _getRate() private view returns(uint256) {
1118         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1119         return rSupply.div(tSupply);
1120     }
1121 
1122     function _getCurrentSupply() private view returns(uint256, uint256) {
1123         uint256 rSupply = _rTotal;
1124         uint256 tSupply = _tTotal;
1125         for (uint256 i = 0; i < _excluded.length; i++) {
1126             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1127             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1128             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1129         }
1130         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1131         return (rSupply, tSupply);
1132     }
1133 
1134     function _getTaxFee() private view returns(uint256) {
1135         return _taxFee;
1136     }
1137 
1138     function _getETHBalance() public view returns(uint256 balance) {
1139         return address(this).balance;
1140     }
1141 
1142     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1143         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1144         _taxFee = taxFee;
1145     }
1146 
1147     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1148         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1149         _marketingFee = marketingFee;
1150     }
1151 
1152     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1153         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1154         _liquidityFee = liquidityFee;
1155     }
1156 
1157     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1158         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1159         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1160     }
1161 
1162     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1163         _approve(address(this), owner(), tokenAmount);
1164         _transfer(address(this), owner(), tokenAmount);
1165     }
1166 }