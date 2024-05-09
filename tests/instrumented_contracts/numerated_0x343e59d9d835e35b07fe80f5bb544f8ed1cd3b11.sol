1 /**
2        $$$$$                                                                                        
3        $:::$                                                                                        
4    $$$$$:::$$$$$$ MMMMMMMM               MMMMMMMM                    MMMMMMMM               MMMMMMMM
5  $$::::::::::::::$M:::::::M             M:::::::M                    M:::::::M             M:::::::M
6 $:::::$$$$$$$::::$M::::::::M           M::::::::M                    M::::::::M           M::::::::M
7 $::::$       $$$$$M:::::::::M         M:::::::::M                    M:::::::::M         M:::::::::M
8 $::::$            M::::::::::M       M::::::::::M    eeeeeeeeeeee    M::::::::::M       M::::::::::M
9 $::::$            M:::::::::::M     M:::::::::::M  ee::::::::::::ee  M:::::::::::M     M:::::::::::M
10 $:::::$$$$$$$$$   M:::::::M::::M   M::::M:::::::M e::::::eeeee:::::eeM:::::::M::::M   M::::M:::::::M
11  $$::::::::::::$$ M::::::M M::::M M::::M M::::::Me::::::e     e:::::eM::::::M M::::M M::::M M::::::M
12    $$$$$$$$$:::::$M::::::M  M::::M::::M  M::::::Me:::::::eeeee::::::eM::::::M  M::::M::::M  M::::::M
13             $::::$M::::::M   M:::::::M   M::::::Me:::::::::::::::::e M::::::M   M:::::::M   M::::::M
14             $::::$M::::::M    M:::::M    M::::::Me::::::eeeeeeeeeee  M::::::M    M:::::M    M::::::M
15 $$$$$       $::::$M::::::M     MMMMM     M::::::Me:::::::e           M::::::M     MMMMM     M::::::M
16 $::::$$$$$$$:::::$M::::::M               M::::::Me::::::::e          M::::::M               M::::::M
17 $::::::::::::::$$ M::::::M               M::::::M e::::::::eeeeeeee  M::::::M               M::::::M
18  $$$$$$:::$$$$$   M::::::M               M::::::M  ee:::::::::::::e  M::::::M               M::::::M
19       $:::$       MMMMMMMM               MMMMMMMM    eeeeeeeeeeeeee  MMMMMMMM               MMMMMMMM
20       $$$$$                                                                                         
21                                                                                                                                                                           
22                                                                                                    */
23 
24 /**
25 Magic Ethereum Money": $MeM
26 -You buy on Ethereum, we use taxed assets to execute daily buy-backs and
27 make investments to secure the longevity of our buy-and-burn method.
28 
29 Tokenomics:
30 10% of each buy goes to existing holders.
31 10% of each sell goes into $MeM treasury.
32 
33 Website:
34 https://magfi.io/
35 
36 Telegram:
37 https://t.me/+SulXyBQdT9Q3OWJh
38 
39 Twitter:
40 https://twitter.com/MeM_Ethereum
41 
42 Medium:
43 https://magicethmoney.medium.com/
44 */
45 
46 // SPDX-License-Identifier: Unlicensed
47 pragma solidity ^0.6.12;
48 
49     abstract contract Context {
50         function _msgSender() internal view virtual returns (address payable) {
51             return msg.sender;
52         }
53 
54         function _msgData() internal view virtual returns (bytes memory) {
55             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
56             return msg.data;
57         }
58     }
59 
60     interface IERC20 {
61         /**
62         * @dev Returns the amount of tokens in existence.
63         */
64         function totalSupply() external view returns (uint256);
65 
66         /**
67         * @dev Returns the amount of tokens owned by `account`.
68         */
69         function balanceOf(address account) external view returns (uint256);
70 
71         /**
72         * @dev Moves `amount` tokens from the caller's account to `recipient`.
73         *
74         * Returns a boolean value indicating whether the operation succeeded.
75         *
76         * Emits a {Transfer} event.
77         */
78         function transfer(address recipient, uint256 amount) external returns (bool);
79 
80         /**
81         * @dev Returns the remaining number of tokens that `spender` will be
82         * allowed to spend on behalf of `owner` through {transferFrom}. This is
83         * zero by default.
84         *
85         * This value changes when {approve} or {transferFrom} are called.
86         */
87         function allowance(address owner, address spender) external view returns (uint256);
88 
89         /**
90         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91         *
92         * Returns a boolean value indicating whether the operation succeeded.
93         *
94         * IMPORTANT: Beware that changing an allowance with this method brings the risk
95         * that someone may use both the old and the new allowance by unfortunate
96         * transaction ordering. One possible solution to mitigate this race
97         * condition is to first reduce the spender's allowance to 0 and set the
98         * desired value afterwards:
99         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100         *
101         * Emits an {Approval} event.
102         */
103         function approve(address spender, uint256 amount) external returns (bool);
104 
105         /**
106         * @dev Moves `amount` tokens from `sender` to `recipient` using the
107         * allowance mechanism. `amount` is then deducted from the caller's
108         * allowance.
109         *
110         * Returns a boolean value indicating whether the operation succeeded.
111         *
112         * Emits a {Transfer} event.
113         */
114         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
115 
116         /**
117         * @dev Emitted when `value` tokens are moved from one account (`from`) to
118         * another (`to`).
119         *
120         * Note that `value` may be zero.
121         */
122         event Transfer(address indexed from, address indexed to, uint256 value);
123 
124         /**
125         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126         * a call to {approve}. `value` is the new allowance.
127         */
128         event Approval(address indexed owner, address indexed spender, uint256 value);
129     }
130 
131     library SafeMath {
132         /**
133         * @dev Returns the addition of two unsigned integers, reverting on
134         * overflow.
135         *
136         * Counterpart to Solidity's `+` operator.
137         *
138         * Requirements:
139         *
140         * - Addition cannot overflow.
141         */
142         function add(uint256 a, uint256 b) internal pure returns (uint256) {
143             uint256 c = a + b;
144             require(c >= a, "SafeMath: addition overflow");
145 
146             return c;
147         }
148 
149         /**
150         * @dev Returns the subtraction of two unsigned integers, reverting on
151         * overflow (when the result is negative).
152         *
153         * Counterpart to Solidity's `-` operator.
154         *
155         * Requirements:
156         *
157         * - Subtraction cannot overflow.
158         */
159         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160             return sub(a, b, "SafeMath: subtraction overflow");
161         }
162 
163         /**
164         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165         * overflow (when the result is negative).
166         *
167         * Counterpart to Solidity's `-` operator.
168         *
169         * Requirements:
170         *
171         * - Subtraction cannot overflow.
172         */
173         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174             require(b <= a, errorMessage);
175             uint256 c = a - b;
176 
177             return c;
178         }
179 
180         /**
181         * @dev Returns the multiplication of two unsigned integers, reverting on
182         * overflow.
183         *
184         * Counterpart to Solidity's `*` operator.
185         *
186         * Requirements:
187         *
188         * - Multiplication cannot overflow.
189         */
190         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192             // benefit is lost if 'b' is also tested.
193             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194             if (a == 0) {
195                 return 0;
196             }
197 
198             uint256 c = a * b;
199             require(c / a == b, "SafeMath: multiplication overflow");
200 
201             return c;
202         }
203 
204         /**
205         * @dev Returns the integer division of two unsigned integers. Reverts on
206         * division by zero. The result is rounded towards zero.
207         *
208         * Counterpart to Solidity's `/` operator. Note: this function uses a
209         * `revert` opcode (which leaves remaining gas untouched) while Solidity
210         * uses an invalid opcode to revert (consuming all remaining gas).
211         *
212         * Requirements:
213         *
214         * - The divisor cannot be zero.
215         */
216         function div(uint256 a, uint256 b) internal pure returns (uint256) {
217             return div(a, b, "SafeMath: division by zero");
218         }
219 
220         /**
221         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222         * division by zero. The result is rounded towards zero.
223         *
224         * Counterpart to Solidity's `/` operator. Note: this function uses a
225         * `revert` opcode (which leaves remaining gas untouched) while Solidity
226         * uses an invalid opcode to revert (consuming all remaining gas).
227         *
228         * Requirements:
229         *
230         * - The divisor cannot be zero.
231         */
232         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233             require(b > 0, errorMessage);
234             uint256 c = a / b;
235             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237             return c;
238         }
239 
240         /**
241         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242         * Reverts when dividing by zero.
243         *
244         * Counterpart to Solidity's `%` operator. This function uses a `revert`
245         * opcode (which leaves remaining gas untouched) while Solidity uses an
246         * invalid opcode to revert (consuming all remaining gas).
247         *
248         * Requirements:
249         *
250         * - The divisor cannot be zero.
251         */
252         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253             return mod(a, b, "SafeMath: modulo by zero");
254         }
255 
256         /**
257         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258         * Reverts with custom message when dividing by zero.
259         *
260         * Counterpart to Solidity's `%` operator. This function uses a `revert`
261         * opcode (which leaves remaining gas untouched) while Solidity uses an
262         * invalid opcode to revert (consuming all remaining gas).
263         *
264         * Requirements:
265         *
266         * - The divisor cannot be zero.
267         */
268         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269             require(b != 0, errorMessage);
270             return a % b;
271         }
272     }
273 
274     library Address {
275         /**
276         * @dev Returns true if `account` is a contract.
277         *
278         * [IMPORTANT]
279         * ====
280         * It is unsafe to assume that an address for which this function returns
281         * false is an externally-owned account (EOA) and not a contract.
282         *
283         * Among others, `isContract` will return false for the following
284         * types of addresses:
285         *
286         *  - an externally-owned account
287         *  - a contract in construction
288         *  - an address where a contract will be created
289         *  - an address where a contract lived, but was destroyed
290         * ====
291         */
292         function isContract(address account) internal view returns (bool) {
293             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295             // for accounts without code, i.e. `keccak256('')`
296             bytes32 codehash;
297             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298             // solhint-disable-next-line no-inline-assembly
299             assembly { codehash := extcodehash(account) }
300             return (codehash != accountHash && codehash != 0x0);
301         }
302 
303         /**
304         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305         * `recipient`, forwarding all available gas and reverting on errors.
306         *
307         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308         * of certain opcodes, possibly making contracts go over the 2300 gas limit
309         * imposed by `transfer`, making them unable to receive funds via
310         * `transfer`. {sendValue} removes this limitation.
311         *
312         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313         *
314         * IMPORTANT: because control is transferred to `recipient`, care must be
315         * taken to not create reentrancy vulnerabilities. Consider using
316         * {ReentrancyGuard} or the
317         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318         */
319         function sendValue(address payable recipient, uint256 amount) internal {
320             require(address(this).balance >= amount, "Address: insufficient balance");
321 
322             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323             (bool success, ) = recipient.call{ value: amount }("");
324             require(success, "Address: unable to send value, recipient may have reverted");
325         }
326 
327         /**
328         * @dev Performs a Solidity function call using a low level `call`. A
329         * plain`call` is an unsafe replacement for a function call: use this
330         * function instead.
331         *
332         * If `target` reverts with a revert reason, it is bubbled up by this
333         * function (like regular Solidity function calls).
334         *
335         * Returns the raw returned data. To convert to the expected return value,
336         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337         *
338         * Requirements:
339         *
340         * - `target` must be a contract.
341         * - calling `target` with `data` must not revert.
342         *
343         * _Available since v3.1._
344         */
345         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347         }
348 
349         /**
350         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351         * `errorMessage` as a fallback revert reason when `target` reverts.
352         *
353         * _Available since v3.1._
354         */
355         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356             return _functionCallWithValue(target, data, 0, errorMessage);
357         }
358 
359         /**
360         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361         * but also transferring `value` wei to `target`.
362         *
363         * Requirements:
364         *
365         * - the calling contract must have an ETH balance of at least `value`.
366         * - the called Solidity function must be `payable`.
367         *
368         * _Available since v3.1._
369         */
370         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372         }
373 
374         /**
375         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376         * with `errorMessage` as a fallback revert reason when `target` reverts.
377         *
378         * _Available since v3.1._
379         */
380         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381             require(address(this).balance >= value, "Address: insufficient balance for call");
382             return _functionCallWithValue(target, data, value, errorMessage);
383         }
384 
385         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386             require(isContract(target), "Address: call to non-contract");
387 
388             // solhint-disable-next-line avoid-low-level-calls
389             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390             if (success) {
391                 return returndata;
392             } else {
393                 // Look for revert reason and bubble it up if present
394                 if (returndata.length > 0) {
395                     // The easiest way to bubble the revert reason is using memory via assembly
396 
397                     // solhint-disable-next-line no-inline-assembly
398                     assembly {
399                         let returndata_size := mload(returndata)
400                         revert(add(32, returndata), returndata_size)
401                     }
402                 } else {
403                     revert(errorMessage);
404                 }
405             }
406         }
407     }
408 
409     contract Ownable is Context {
410         address private _owner;
411         address private _previousOwner;
412         uint256 private _lockTime;
413 
414         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416         /**
417         * @dev Initializes the contract setting the deployer as the initial owner.
418         */
419         constructor () internal {
420             address msgSender = _msgSender();
421             _owner = msgSender;
422             emit OwnershipTransferred(address(0), msgSender);
423         }
424 
425         /**
426         * @dev Returns the address of the current owner.
427         */
428         function owner() public view returns (address) {
429             return _owner;
430         }
431 
432         /**
433         * @dev Throws if called by any account other than the owner.
434         */
435         modifier onlyOwner() {
436             require(_owner == _msgSender(), "Ownable: caller is not the owner");
437             _;
438         }
439 
440         /**
441         * @dev Leaves the contract without owner. It will not be possible to call
442         * `onlyOwner` functions anymore. Can only be called by the current owner.
443         *
444         * NOTE: Renouncing ownership will leave the contract without an owner,
445         * thereby removing any functionality that is only available to the owner.
446         */
447         function renounceOwnership() public virtual onlyOwner {
448             emit OwnershipTransferred(_owner, address(0));
449             _owner = address(0);
450         }
451 
452         /**
453         * @dev Transfers ownership of the contract to a new account (`newOwner`).
454         * Can only be called by the current owner.
455         */
456         function transferOwnership(address newOwner) public virtual onlyOwner {
457             require(newOwner != address(0), "Ownable: new owner is the zero address");
458             emit OwnershipTransferred(_owner, newOwner);
459             _owner = newOwner;
460         }
461 
462         function geUnlockTime() public view returns (uint256) {
463             return _lockTime;
464         }
465 
466         //Locks the contract for owner for the amount of time provided
467         function lock(uint256 time) public virtual onlyOwner {
468             _previousOwner = _owner;
469             _owner = address(0);
470             _lockTime = now + time;
471             emit OwnershipTransferred(_owner, address(0));
472         }
473 
474         //Unlocks the contract for owner when _lockTime is exceeds
475         function unlock() public virtual {
476             require(_previousOwner == msg.sender, "You don't have permission to unlock");
477             require(now > _lockTime , "Contract is locked until 7 days");
478             emit OwnershipTransferred(_owner, _previousOwner);
479             _owner = _previousOwner;
480         }
481     }
482 
483     interface IUniswapV2Factory {
484         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
485 
486         function feeTo() external view returns (address);
487         function feeToSetter() external view returns (address);
488 
489         function getPair(address tokenA, address tokenB) external view returns (address pair);
490         function allPairs(uint) external view returns (address pair);
491         function allPairsLength() external view returns (uint);
492 
493         function createPair(address tokenA, address tokenB) external returns (address pair);
494 
495         function setFeeTo(address) external;
496         function setFeeToSetter(address) external;
497     }
498 
499     interface IUniswapV2Pair {
500         event Approval(address indexed owner, address indexed spender, uint value);
501         event Transfer(address indexed from, address indexed to, uint value);
502 
503         function name() external pure returns (string memory);
504         function symbol() external pure returns (string memory);
505         function decimals() external pure returns (uint8);
506         function totalSupply() external view returns (uint);
507         function balanceOf(address owner) external view returns (uint);
508         function allowance(address owner, address spender) external view returns (uint);
509 
510         function approve(address spender, uint value) external returns (bool);
511         function transfer(address to, uint value) external returns (bool);
512         function transferFrom(address from, address to, uint value) external returns (bool);
513 
514         function DOMAIN_SEPARATOR() external view returns (bytes32);
515         function PERMIT_TYPEHASH() external pure returns (bytes32);
516         function nonces(address owner) external view returns (uint);
517 
518         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
519 
520         event Mint(address indexed sender, uint amount0, uint amount1);
521         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
522         event Swap(
523             address indexed sender,
524             uint amount0In,
525             uint amount1In,
526             uint amount0Out,
527             uint amount1Out,
528             address indexed to
529         );
530         event Sync(uint112 reserve0, uint112 reserve1);
531 
532         function MINIMUM_LIQUIDITY() external pure returns (uint);
533         function factory() external view returns (address);
534         function token0() external view returns (address);
535         function token1() external view returns (address);
536         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
537         function price0CumulativeLast() external view returns (uint);
538         function price1CumulativeLast() external view returns (uint);
539         function kLast() external view returns (uint);
540 
541         function mint(address to) external returns (uint liquidity);
542         function burn(address to) external returns (uint amount0, uint amount1);
543         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
544         function skim(address to) external;
545         function sync() external;
546 
547         function initialize(address, address) external;
548     }
549 
550     interface IUniswapV2Router01 {
551         function factory() external pure returns (address);
552         function WETH() external pure returns (address);
553 
554         function addLiquidity(
555             address tokenA,
556             address tokenB,
557             uint amountADesired,
558             uint amountBDesired,
559             uint amountAMin,
560             uint amountBMin,
561             address to,
562             uint deadline
563         ) external returns (uint amountA, uint amountB, uint liquidity);
564         function addLiquidityETH(
565             address token,
566             uint amountTokenDesired,
567             uint amountTokenMin,
568             uint amountETHMin,
569             address to,
570             uint deadline
571         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572         function removeLiquidity(
573             address tokenA,
574             address tokenB,
575             uint liquidity,
576             uint amountAMin,
577             uint amountBMin,
578             address to,
579             uint deadline
580         ) external returns (uint amountA, uint amountB);
581         function removeLiquidityETH(
582             address token,
583             uint liquidity,
584             uint amountTokenMin,
585             uint amountETHMin,
586             address to,
587             uint deadline
588         ) external returns (uint amountToken, uint amountETH);
589         function removeLiquidityWithPermit(
590             address tokenA,
591             address tokenB,
592             uint liquidity,
593             uint amountAMin,
594             uint amountBMin,
595             address to,
596             uint deadline,
597             bool approveMax, uint8 v, bytes32 r, bytes32 s
598         ) external returns (uint amountA, uint amountB);
599         function removeLiquidityETHWithPermit(
600             address token,
601             uint liquidity,
602             uint amountTokenMin,
603             uint amountETHMin,
604             address to,
605             uint deadline,
606             bool approveMax, uint8 v, bytes32 r, bytes32 s
607         ) external returns (uint amountToken, uint amountETH);
608         function swapExactTokensForTokens(
609             uint amountIn,
610             uint amountOutMin,
611             address[] calldata path,
612             address to,
613             uint deadline
614         ) external returns (uint[] memory amounts);
615         function swapTokensForExactTokens(
616             uint amountOut,
617             uint amountInMax,
618             address[] calldata path,
619             address to,
620             uint deadline
621         ) external returns (uint[] memory amounts);
622         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623             external
624             payable
625             returns (uint[] memory amounts);
626         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627             external
628             returns (uint[] memory amounts);
629         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630             external
631             returns (uint[] memory amounts);
632         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633             external
634             payable
635             returns (uint[] memory amounts);
636 
637         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642     }
643 
644     interface IUniswapV2Router02 is IUniswapV2Router01 {
645         function removeLiquidityETHSupportingFeeOnTransferTokens(
646             address token,
647             uint liquidity,
648             uint amountTokenMin,
649             uint amountETHMin,
650             address to,
651             uint deadline
652         ) external returns (uint amountETH);
653         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
654             address token,
655             uint liquidity,
656             uint amountTokenMin,
657             uint amountETHMin,
658             address to,
659             uint deadline,
660             bool approveMax, uint8 v, bytes32 r, bytes32 s
661         ) external returns (uint amountETH);
662 
663         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
664             uint amountIn,
665             uint amountOutMin,
666             address[] calldata path,
667             address to,
668             uint deadline
669         ) external;
670         function swapExactETHForTokensSupportingFeeOnTransferTokens(
671             uint amountOutMin,
672             address[] calldata path,
673             address to,
674             uint deadline
675         ) external payable;
676         function swapExactTokensForETHSupportingFeeOnTransferTokens(
677             uint amountIn,
678             uint amountOutMin,
679             address[] calldata path,
680             address to,
681             uint deadline
682         ) external;
683     }
684 
685     // Contract implementation
686     contract MagicEthereumMoney is Context, IERC20, Ownable {
687         using SafeMath for uint256;
688         using Address for address;
689 
690         mapping (address => uint256) private _rOwned;
691         mapping (address => uint256) private _tOwned;
692         mapping (address => mapping (address => uint256)) private _allowances;
693 
694         mapping (address => bool) private _isExcludedFromFee;
695 
696         mapping (address => bool) private _isExcluded;
697         address[] private _excluded;
698 
699         uint256 private constant MAX = ~uint256(0);
700         uint256 private _tTotal = 1000000000000 * 10**9;
701         uint256 private _rTotal = (MAX - (MAX % _tTotal));
702         uint256 private _tFeeTotal;
703 
704         string private _name = 'MagicEthereumMoney';
705         string private _symbol = 'MeM';
706         uint8 private _decimals = 9;
707 
708         uint256 private _taxFee = 10;
709         uint256 private _teamFee = 10;
710         uint256 private _previousTaxFee = _taxFee;
711         uint256 private _previousTeamFee = _teamFee;
712 
713         address payable public _MeMWalletAddress;
714         address payable public _marketingWalletAddress;
715 
716         IUniswapV2Router02 public immutable uniswapV2Router;
717         address public immutable uniswapV2Pair;
718 
719         bool inSwap = false;
720         bool public swapEnabled = true;
721 
722         uint256 private _maxTxAmount = 100000000000000e9;
723         // We will set a minimum amount of tokens to be swaped => 5M
724         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
725 
726         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
727         event SwapEnabledUpdated(bool enabled);
728 
729         modifier lockTheSwap {
730             inSwap = true;
731             _;
732             inSwap = false;
733         }
734 
735         constructor (address payable MeMWalletAddress, address payable marketingWalletAddress) public {
736             _MeMWalletAddress = MeMWalletAddress;
737             _marketingWalletAddress = marketingWalletAddress;
738             _rOwned[_msgSender()] = _rTotal;
739 
740             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
741             // Create a uniswap pair for this new token
742             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
743                 .createPair(address(this), _uniswapV2Router.WETH());
744 
745             // set the rest of the contract variables
746             uniswapV2Router = _uniswapV2Router;
747 
748             // Exclude owner and this contract from fee
749             _isExcludedFromFee[owner()] = true;
750             _isExcludedFromFee[address(this)] = true;
751 
752             emit Transfer(address(0), _msgSender(), _tTotal);
753         }
754 
755         function name() public view returns (string memory) {
756             return _name;
757         }
758 
759         function symbol() public view returns (string memory) {
760             return _symbol;
761         }
762 
763         function decimals() public view returns (uint8) {
764             return _decimals;
765         }
766 
767         function totalSupply() public view override returns (uint256) {
768             return _tTotal;
769         }
770 
771         function balanceOf(address account) public view override returns (uint256) {
772             if (_isExcluded[account]) return _tOwned[account];
773             return tokenFromReflection(_rOwned[account]);
774         }
775 
776         function transfer(address recipient, uint256 amount) public override returns (bool) {
777             _transfer(_msgSender(), recipient, amount);
778             return true;
779         }
780 
781         function allowance(address owner, address spender) public view override returns (uint256) {
782             return _allowances[owner][spender];
783         }
784 
785         function approve(address spender, uint256 amount) public override returns (bool) {
786             _approve(_msgSender(), spender, amount);
787             return true;
788         }
789 
790         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
791             _transfer(sender, recipient, amount);
792             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
793             return true;
794         }
795 
796         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798             return true;
799         }
800 
801         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
802             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
803             return true;
804         }
805 
806         function isExcluded(address account) public view returns (bool) {
807             return _isExcluded[account];
808         }
809 
810         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
811             _isExcludedFromFee[account] = excluded;
812         }
813 
814         function totalFees() public view returns (uint256) {
815             return _tFeeTotal;
816         }
817 
818         function deliver(uint256 tAmount) public {
819             address sender = _msgSender();
820             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
821             (uint256 rAmount,,,,,) = _getValues(tAmount);
822             _rOwned[sender] = _rOwned[sender].sub(rAmount);
823             _rTotal = _rTotal.sub(rAmount);
824             _tFeeTotal = _tFeeTotal.add(tAmount);
825         }
826 
827         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
828             require(tAmount <= _tTotal, "Amount must be less than supply");
829             if (!deductTransferFee) {
830                 (uint256 rAmount,,,,,) = _getValues(tAmount);
831                 return rAmount;
832             } else {
833                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
834                 return rTransferAmount;
835             }
836         }
837 
838         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
839             require(rAmount <= _rTotal, "Amount must be less than total reflections");
840             uint256 currentRate =  _getRate();
841             return rAmount.div(currentRate);
842         }
843 
844         function excludeAccount(address account) external onlyOwner() {
845             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
846             require(!_isExcluded[account], "Account is already excluded");
847             if(_rOwned[account] > 0) {
848                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
849             }
850             _isExcluded[account] = true;
851             _excluded.push(account);
852         }
853 
854         function includeAccount(address account) external onlyOwner() {
855             require(_isExcluded[account], "Account is already excluded");
856             for (uint256 i = 0; i < _excluded.length; i++) {
857                 if (_excluded[i] == account) {
858                     _excluded[i] = _excluded[_excluded.length - 1];
859                     _tOwned[account] = 0;
860                     _isExcluded[account] = false;
861                     _excluded.pop();
862                     break;
863                 }
864             }
865         }
866 
867         function removeAllFee() private {
868             if(_taxFee == 0 && _teamFee == 0) return;
869 
870             _previousTaxFee = _taxFee;
871             _previousTeamFee = _teamFee;
872 
873             _taxFee = 0;
874             _teamFee = 0;
875         }
876 
877         function restoreAllFee() private {
878             _taxFee = _previousTaxFee;
879             _teamFee = _previousTeamFee;
880         }
881 
882         function isExcludedFromFee(address account) public view returns(bool) {
883             return _isExcludedFromFee[account];
884         }
885 
886         function _approve(address owner, address spender, uint256 amount) private {
887             require(owner != address(0), "ERC20: approve from the zero address");
888             require(spender != address(0), "ERC20: approve to the zero address");
889 
890             _allowances[owner][spender] = amount;
891             emit Approval(owner, spender, amount);
892         }
893 
894         function _transfer(address sender, address recipient, uint256 amount) private {
895             require(sender != address(0), "ERC20: transfer from the zero address");
896             require(recipient != address(0), "ERC20: transfer to the zero address");
897             require(amount > 0, "Transfer amount must be greater than zero");
898 
899             if(sender != owner() && recipient != owner())
900                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
901 
902             // is the token balance of this contract address over the min number of
903             // tokens that we need to initiate a swap?
904             // also, don't get caught in a circular team event.
905             // also, don't swap if sender is uniswap pair.
906             uint256 contractTokenBalance = balanceOf(address(this));
907 
908             if(contractTokenBalance >= _maxTxAmount)
909             {
910                 contractTokenBalance = _maxTxAmount;
911             }
912 
913             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
914             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
915                 // We need to swap the current tokens to ETH and send to the team wallet
916                 swapTokensForEth(contractTokenBalance);
917 
918                 uint256 contractETHBalance = address(this).balance;
919                 if(contractETHBalance > 0) {
920                     sendETHToTeam(address(this).balance);
921                 }
922             }
923 
924             //indicates if fee should be deducted from transfer
925             bool takeFee = true;
926 
927             //if any account belongs to _isExcludedFromFee account then remove the fee
928             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
929                 takeFee = false;
930             }
931 
932             //transfer amount, it will take tax and team fee
933             _tokenTransfer(sender,recipient,amount,takeFee);
934         }
935 
936         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
937             // generate the uniswap pair path of token -> weth
938             address[] memory path = new address[](2);
939             path[0] = address(this);
940             path[1] = uniswapV2Router.WETH();
941 
942             _approve(address(this), address(uniswapV2Router), tokenAmount);
943 
944             // make the swap
945             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
946                 tokenAmount,
947                 0, // accept any amount of ETH
948                 path,
949                 address(this),
950                 block.timestamp
951             );
952         }
953 
954         function sendETHToTeam(uint256 amount) private {
955             _MeMWalletAddress.transfer(amount.div(2));
956             _marketingWalletAddress.transfer(amount.div(2));
957         }
958 
959         // We are exposing these functions to be able to manual swap and send
960         // in case the token is highly valued and 5M becomes too much
961         function manualSwap() external onlyOwner() {
962             uint256 contractBalance = balanceOf(address(this));
963             swapTokensForEth(contractBalance);
964         }
965 
966         function manualSend() external onlyOwner() {
967             uint256 contractETHBalance = address(this).balance;
968             sendETHToTeam(contractETHBalance);
969         }
970 
971         function setSwapEnabled(bool enabled) external onlyOwner(){
972             swapEnabled = enabled;
973         }
974 
975         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
976             if(!takeFee)
977                 removeAllFee();
978 
979             if (_isExcluded[sender] && !_isExcluded[recipient]) {
980                 _transferFromExcluded(sender, recipient, amount);
981             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
982                 _transferToExcluded(sender, recipient, amount);
983             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
984                 _transferStandard(sender, recipient, amount);
985             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
986                 _transferBothExcluded(sender, recipient, amount);
987             } else {
988                 _transferStandard(sender, recipient, amount);
989             }
990 
991             if(!takeFee)
992                 restoreAllFee();
993         }
994 
995         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
996             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
997             _rOwned[sender] = _rOwned[sender].sub(rAmount);
998             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
999             _takeTeam(tTeam);
1000             _reflectFee(rFee, tFee);
1001             emit Transfer(sender, recipient, tTransferAmount);
1002         }
1003 
1004         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1005             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1006             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1007             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1008             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1009             _takeTeam(tTeam);
1010             _reflectFee(rFee, tFee);
1011             emit Transfer(sender, recipient, tTransferAmount);
1012         }
1013 
1014         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1015             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1016             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1017             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1018             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1019             _takeTeam(tTeam);
1020             _reflectFee(rFee, tFee);
1021             emit Transfer(sender, recipient, tTransferAmount);
1022         }
1023 
1024         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1025             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1026             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1027             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1028             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1029             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1030             _takeTeam(tTeam);
1031             _reflectFee(rFee, tFee);
1032             emit Transfer(sender, recipient, tTransferAmount);
1033         }
1034 
1035         function _takeTeam(uint256 tTeam) private {
1036             uint256 currentRate =  _getRate();
1037             uint256 rTeam = tTeam.mul(currentRate);
1038             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1039             if(_isExcluded[address(this)])
1040                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1041         }
1042 
1043         function _reflectFee(uint256 rFee, uint256 tFee) private {
1044             _rTotal = _rTotal.sub(rFee);
1045             _tFeeTotal = _tFeeTotal.add(tFee);
1046         }
1047 
1048          //to recieve ETH from uniswapV2Router when swaping
1049         receive() external payable {}
1050 
1051         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1052             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1053             uint256 currentRate =  _getRate();
1054             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1055             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1056         }
1057 
1058         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1059             uint256 tFee = tAmount.mul(taxFee).div(100);
1060             uint256 tTeam = tAmount.mul(teamFee).div(100);
1061             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1062             return (tTransferAmount, tFee, tTeam);
1063         }
1064 
1065         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1066             uint256 rAmount = tAmount.mul(currentRate);
1067             uint256 rFee = tFee.mul(currentRate);
1068             uint256 rTransferAmount = rAmount.sub(rFee);
1069             return (rAmount, rTransferAmount, rFee);
1070         }
1071 
1072         function _getRate() private view returns(uint256) {
1073             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1074             return rSupply.div(tSupply);
1075         }
1076 
1077         function _getCurrentSupply() private view returns(uint256, uint256) {
1078             uint256 rSupply = _rTotal;
1079             uint256 tSupply = _tTotal;
1080             for (uint256 i = 0; i < _excluded.length; i++) {
1081                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1082                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1083                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1084             }
1085             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1086             return (rSupply, tSupply);
1087         }
1088 
1089         function _getTaxFee() private view returns(uint256) {
1090             return _taxFee;
1091         }
1092 
1093         function _getMaxTxAmount() private view returns(uint256) {
1094             return _maxTxAmount;
1095         }
1096 
1097         function _getETHBalance() public view returns(uint256 balance) {
1098             return address(this).balance;
1099         }
1100 
1101         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1102             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1103             _taxFee = taxFee;
1104         }
1105 
1106         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1107             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1108             _teamFee = teamFee;
1109         }
1110 
1111         function _setMeMWallet(address payable MeMWalletAddress) external onlyOwner() {
1112             _MeMWalletAddress = MeMWalletAddress;
1113         }
1114 
1115         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1116             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1117             _maxTxAmount = maxTxAmount;
1118         }
1119     }