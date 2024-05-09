1 /**
2 
3 The Tale of Francois Le Champagne (Murder Penguin)
4 Learn about me at https://the-tale-of-francois.gitbook.io/the-tale-of-francois/  
5 
6 Penguinomics:
7 > 1,000,000,000,000 Total Supply to the Huddle
8 > 7.5% of Circulating Supply to Presalers (75% burned at launch)
9 Tribute burn --> 75% of Starting Supply Destroyed at the outset (inflation bug solution)
10 > This tribute burn represents the penguin population decimated in the onslaught 
11 > Presalers are Polar Bear Politicians
12 > Sellers are their reinforcements
13 > Polar Bears are singlehandedly ruining the arctic and the blockchain
14 > Melting Glacier Huddle Contract:
15 > 3% returned to the Huddle
16 > 2% offered to building the penguin arsenal
17 
18 > I seek to fortify my army. Will you enlist, or will you let my village face slaughter? 
19 
20 > Each new token rewarded to the Huddle represents the accumulation of artillery and weaponry to defend our village against the Polar Bears. 
21 > This anti-polar bear weaponry is spread amongst the penguin community as a show of gratitude, unity, trust, and of course, espionage. 
22 
23 > I am not the dev. I am Murder Penguin. 
24 
25 > My mission is to eradicate all polar bears on this planet, ensuring I redeem the lives lost in the unncessesary slaying of my Huddle. 
26 > Ongoing counter-intelligence and confidentiality concerns dictate that all communications and mission updates will be given through the blockchain
27   to ensure absolute mission secrecy.
28 
29 > As I disembowel teh malicious Polar Bears in the Arctic Circle, the responsibility is on you to spread my message. 
30 
31 > Here's what you can do for me...
32 
33 > Make art about the Arctic Conflict. Art brings exposure. Make stickers. Same thing. Support me on Twitter and Telegram. 
34 > Make T-Shirts. Tell your friends. Enlist your boss. Demand your family contributes to the cause. 
35 > Visit the Arctic with your heaviest artillery. 
36 
37 > Murder Penguin deals in blood, gunpowder, and bullets --> not in the Huddle's community discussions.
38 
39 > I cannot tell you what happens next. The ice will set you free. 
40 
41 
42 
43 Website: https://www.murderpenguin.com
44 
45 Telegram: https://t.me/murderpenguin
46 
47 Twitter: https://www.twitter.com/murdapenguin
48 
49 Gitbook: https://the-tale-of-francois.gitbook.io/the-tale-of-francois/ 
50 
51 */
52 
53 // SPDX-License-Identifier: Unlicensed
54 pragma solidity ^0.6.12;
55 
56     abstract contract Context {
57         function _msgSender() internal view virtual returns (address payable) {
58             return msg.sender;
59         }
60 
61         function _msgData() internal view virtual returns (bytes memory) {
62             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
63             return msg.data;
64         }
65     }
66 
67     interface IERC20 {
68         /**
69         * @dev Returns the amount of tokens in existence.
70         */
71         function totalSupply() external view returns (uint256);
72 
73         /**
74         * @dev Returns the amount of tokens owned by `account`.
75         */
76         function balanceOf(address account) external view returns (uint256);
77 
78         /**
79         * @dev Moves `amount` tokens from the caller's account to `recipient`.
80         *
81         * Returns a boolean value indicating whether the operation succeeded.
82         *
83         * Emits a {Transfer} event.
84         */
85         function transfer(address recipient, uint256 amount) external returns (bool);
86 
87         /**
88         * @dev Returns the remaining number of tokens that `spender` will be
89         * allowed to spend on behalf of `owner` through {transferFrom}. This is
90         * zero by default.
91         *
92         * This value changes when {approve} or {transferFrom} are called.
93         */
94         function allowance(address owner, address spender) external view returns (uint256);
95 
96         /**
97         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
98         *
99         * Returns a boolean value indicating whether the operation succeeded.
100         *
101         * IMPORTANT: Beware that changing an allowance with this method brings the risk
102         * that someone may use both the old and the new allowance by unfortunate
103         * transaction ordering. One possible solution to mitigate this race
104         * condition is to first reduce the spender's allowance to 0 and set the
105         * desired value afterwards:
106         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107         *
108         * Emits an {Approval} event.
109         */
110         function approve(address spender, uint256 amount) external returns (bool);
111 
112         /**
113         * @dev Moves `amount` tokens from `sender` to `recipient` using the
114         * allowance mechanism. `amount` is then deducted from the caller's
115         * allowance.
116         *
117         * Returns a boolean value indicating whether the operation succeeded.
118         *
119         * Emits a {Transfer} event.
120         */
121         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
122 
123         /**
124         * @dev Emitted when `value` tokens are moved from one account (`from`) to
125         * another (`to`).
126         *
127         * Note that `value` may be zero.
128         */
129         event Transfer(address indexed from, address indexed to, uint256 value);
130 
131         /**
132         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133         * a call to {approve}. `value` is the new allowance.
134         */
135         event Approval(address indexed owner, address indexed spender, uint256 value);
136     }
137 
138     library SafeMath {
139         /**
140         * @dev Returns the addition of two unsigned integers, reverting on
141         * overflow.
142         *
143         * Counterpart to Solidity's `+` operator.
144         *
145         * Requirements:
146         *
147         * - Addition cannot overflow.
148         */
149         function add(uint256 a, uint256 b) internal pure returns (uint256) {
150             uint256 c = a + b;
151             require(c >= a, "SafeMath: addition overflow");
152 
153             return c;
154         }
155 
156         /**
157         * @dev Returns the subtraction of two unsigned integers, reverting on
158         * overflow (when the result is negative).
159         *
160         * Counterpart to Solidity's `-` operator.
161         *
162         * Requirements:
163         *
164         * - Subtraction cannot overflow.
165         */
166         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167             return sub(a, b, "SafeMath: subtraction overflow");
168         }
169 
170         /**
171         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172         * overflow (when the result is negative).
173         *
174         * Counterpart to Solidity's `-` operator.
175         *
176         * Requirements:
177         *
178         * - Subtraction cannot overflow.
179         */
180         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181             require(b <= a, errorMessage);
182             uint256 c = a - b;
183 
184             return c;
185         }
186 
187         /**
188         * @dev Returns the multiplication of two unsigned integers, reverting on
189         * overflow.
190         *
191         * Counterpart to Solidity's `*` operator.
192         *
193         * Requirements:
194         *
195         * - Multiplication cannot overflow.
196         */
197         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199             // benefit is lost if 'b' is also tested.
200             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201             if (a == 0) {
202                 return 0;
203             }
204 
205             uint256 c = a * b;
206             require(c / a == b, "SafeMath: multiplication overflow");
207 
208             return c;
209         }
210 
211         /**
212         * @dev Returns the integer division of two unsigned integers. Reverts on
213         * division by zero. The result is rounded towards zero.
214         *
215         * Counterpart to Solidity's `/` operator. Note: this function uses a
216         * `revert` opcode (which leaves remaining gas untouched) while Solidity
217         * uses an invalid opcode to revert (consuming all remaining gas).
218         *
219         * Requirements:
220         *
221         * - The divisor cannot be zero.
222         */
223         function div(uint256 a, uint256 b) internal pure returns (uint256) {
224             return div(a, b, "SafeMath: division by zero");
225         }
226 
227         /**
228         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229         * division by zero. The result is rounded towards zero.
230         *
231         * Counterpart to Solidity's `/` operator. Note: this function uses a
232         * `revert` opcode (which leaves remaining gas untouched) while Solidity
233         * uses an invalid opcode to revert (consuming all remaining gas).
234         *
235         * Requirements:
236         *
237         * - The divisor cannot be zero.
238         */
239         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240             require(b > 0, errorMessage);
241             uint256 c = a / b;
242             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244             return c;
245         }
246 
247         /**
248         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249         * Reverts when dividing by zero.
250         *
251         * Counterpart to Solidity's `%` operator. This function uses a `revert`
252         * opcode (which leaves remaining gas untouched) while Solidity uses an
253         * invalid opcode to revert (consuming all remaining gas).
254         *
255         * Requirements:
256         *
257         * - The divisor cannot be zero.
258         */
259         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260             return mod(a, b, "SafeMath: modulo by zero");
261         }
262 
263         /**
264         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265         * Reverts with custom message when dividing by zero.
266         *
267         * Counterpart to Solidity's `%` operator. This function uses a `revert`
268         * opcode (which leaves remaining gas untouched) while Solidity uses an
269         * invalid opcode to revert (consuming all remaining gas).
270         *
271         * Requirements:
272         *
273         * - The divisor cannot be zero.
274         */
275         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276             require(b != 0, errorMessage);
277             return a % b;
278         }
279     }
280 
281     library Address {
282         /**
283         * @dev Returns true if `account` is a contract.
284         *
285         * [IMPORTANT]
286         * ====
287         * It is unsafe to assume that an address for which this function returns
288         * false is an externally-owned account (EOA) and not a contract.
289         *
290         * Among others, `isContract` will return false for the following
291         * types of addresses:
292         *
293         *  - an externally-owned account
294         *  - a contract in construction
295         *  - an address where a contract will be created
296         *  - an address where a contract lived, but was destroyed
297         * ====
298         */
299         function isContract(address account) internal view returns (bool) {
300             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302             // for accounts without code, i.e. `keccak256('')`
303             bytes32 codehash;
304             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305             // solhint-disable-next-line no-inline-assembly
306             assembly { codehash := extcodehash(account) }
307             return (codehash != accountHash && codehash != 0x0);
308         }
309 
310         /**
311         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312         * `recipient`, forwarding all available gas and reverting on errors.
313         *
314         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315         * of certain opcodes, possibly making contracts go over the 2300 gas limit
316         * imposed by `transfer`, making them unable to receive funds via
317         * `transfer`. {sendValue} removes this limitation.
318         *
319         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320         *
321         * IMPORTANT: because control is transferred to `recipient`, care must be
322         * taken to not create reentrancy vulnerabilities. Consider using
323         * {ReentrancyGuard} or the
324         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325         */
326         function sendValue(address payable recipient, uint256 amount) internal {
327             require(address(this).balance >= amount, "Address: insufficient balance");
328 
329             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330             (bool success, ) = recipient.call{ value: amount }("");
331             require(success, "Address: unable to send value, recipient may have reverted");
332         }
333 
334         /**
335         * @dev Performs a Solidity function call using a low level `call`. A
336         * plain`call` is an unsafe replacement for a function call: use this
337         * function instead.
338         *
339         * If `target` reverts with a revert reason, it is bubbled up by this
340         * function (like regular Solidity function calls).
341         *
342         * Returns the raw returned data. To convert to the expected return value,
343         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344         *
345         * Requirements:
346         *
347         * - `target` must be a contract.
348         * - calling `target` with `data` must not revert.
349         *
350         * _Available since v3.1._
351         */
352         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354         }
355 
356         /**
357         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358         * `errorMessage` as a fallback revert reason when `target` reverts.
359         *
360         * _Available since v3.1._
361         */
362         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363             return _functionCallWithValue(target, data, 0, errorMessage);
364         }
365 
366         /**
367         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368         * but also transferring `value` wei to `target`.
369         *
370         * Requirements:
371         *
372         * - the calling contract must have an ETH balance of at least `value`.
373         * - the called Solidity function must be `payable`.
374         *
375         * _Available since v3.1._
376         */
377         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379         }
380 
381         /**
382         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383         * with `errorMessage` as a fallback revert reason when `target` reverts.
384         *
385         * _Available since v3.1._
386         */
387         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388             require(address(this).balance >= value, "Address: insufficient balance for call");
389             return _functionCallWithValue(target, data, value, errorMessage);
390         }
391 
392         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393             require(isContract(target), "Address: call to non-contract");
394 
395             // solhint-disable-next-line avoid-low-level-calls
396             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397             if (success) {
398                 return returndata;
399             } else {
400                 // Look for revert reason and bubble it up if present
401                 if (returndata.length > 0) {
402                     // The easiest way to bubble the revert reason is using memory via assembly
403 
404                     // solhint-disable-next-line no-inline-assembly
405                     assembly {
406                         let returndata_size := mload(returndata)
407                         revert(add(32, returndata), returndata_size)
408                     }
409                 } else {
410                     revert(errorMessage);
411                 }
412             }
413         }
414     }
415 
416     contract Ownable is Context {
417         address private _owner;
418         address private _previousOwner;
419         uint256 private _lockTime;
420 
421         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423         /**
424         * @dev Initializes the contract setting the deployer as the initial owner.
425         */
426         constructor () internal {
427             address msgSender = _msgSender();
428             _owner = msgSender;
429             emit OwnershipTransferred(address(0), msgSender);
430         }
431 
432         /**
433         * @dev Returns the address of the current owner.
434         */
435         function owner() public view returns (address) {
436             return _owner;
437         }
438 
439         /**
440         * @dev Throws if called by any account other than the owner.
441         */
442         modifier onlyOwner() {
443             require(_owner == _msgSender(), "Ownable: caller is not the owner");
444             _;
445         }
446 
447         /**
448         * @dev Leaves the contract without owner. It will not be possible to call
449         * `onlyOwner` functions anymore. Can only be called by the current owner.
450         *
451         * NOTE: Renouncing ownership will leave the contract without an owner,
452         * thereby removing any functionality that is only available to the owner.
453         */
454         function renounceOwnership() public virtual onlyOwner {
455             emit OwnershipTransferred(_owner, address(0));
456             _owner = address(0);
457         }
458 
459         /**
460         * @dev Transfers ownership of the contract to a new account (`newOwner`).
461         * Can only be called by the current owner.
462         */
463         function transferOwnership(address newOwner) public virtual onlyOwner {
464             require(newOwner != address(0), "Ownable: new owner is the zero address");
465             emit OwnershipTransferred(_owner, newOwner);
466             _owner = newOwner;
467         }
468 
469         function geUnlockTime() public view returns (uint256) {
470             return _lockTime;
471         }
472 
473         //Locks the contract for owner for the amount of time provided
474         function lock(uint256 time) public virtual onlyOwner {
475             _previousOwner = _owner;
476             _owner = address(0);
477             _lockTime = now + time;
478             emit OwnershipTransferred(_owner, address(0));
479         }
480 
481         //Unlocks the contract for owner when _lockTime is exceeds
482         function unlock() public virtual {
483             require(_previousOwner == msg.sender, "You don't have permission to unlock");
484             require(now > _lockTime , "Contract is locked until 7 days");
485             emit OwnershipTransferred(_owner, _previousOwner);
486             _owner = _previousOwner;
487         }
488     }
489 
490     interface IUniswapV2Factory {
491         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
492 
493         function feeTo() external view returns (address);
494         function feeToSetter() external view returns (address);
495 
496         function getPair(address tokenA, address tokenB) external view returns (address pair);
497         function allPairs(uint) external view returns (address pair);
498         function allPairsLength() external view returns (uint);
499 
500         function createPair(address tokenA, address tokenB) external returns (address pair);
501 
502         function setFeeTo(address) external;
503         function setFeeToSetter(address) external;
504     }
505 
506     interface IUniswapV2Pair {
507         event Approval(address indexed owner, address indexed spender, uint value);
508         event Transfer(address indexed from, address indexed to, uint value);
509 
510         function name() external pure returns (string memory);
511         function symbol() external pure returns (string memory);
512         function decimals() external pure returns (uint8);
513         function totalSupply() external view returns (uint);
514         function balanceOf(address owner) external view returns (uint);
515         function allowance(address owner, address spender) external view returns (uint);
516 
517         function approve(address spender, uint value) external returns (bool);
518         function transfer(address to, uint value) external returns (bool);
519         function transferFrom(address from, address to, uint value) external returns (bool);
520 
521         function DOMAIN_SEPARATOR() external view returns (bytes32);
522         function PERMIT_TYPEHASH() external pure returns (bytes32);
523         function nonces(address owner) external view returns (uint);
524 
525         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
526 
527         event Mint(address indexed sender, uint amount0, uint amount1);
528         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
529         event Swap(
530             address indexed sender,
531             uint amount0In,
532             uint amount1In,
533             uint amount0Out,
534             uint amount1Out,
535             address indexed to
536         );
537         event Sync(uint112 reserve0, uint112 reserve1);
538 
539         function MINIMUM_LIQUIDITY() external pure returns (uint);
540         function factory() external view returns (address);
541         function token0() external view returns (address);
542         function token1() external view returns (address);
543         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
544         function price0CumulativeLast() external view returns (uint);
545         function price1CumulativeLast() external view returns (uint);
546         function kLast() external view returns (uint);
547 
548         function mint(address to) external returns (uint liquidity);
549         function burn(address to) external returns (uint amount0, uint amount1);
550         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
551         function skim(address to) external;
552         function sync() external;
553 
554         function initialize(address, address) external;
555     }
556 
557     interface IUniswapV2Router01 {
558         function factory() external pure returns (address);
559         function WETH() external pure returns (address);
560 
561         function addLiquidity(
562             address tokenA,
563             address tokenB,
564             uint amountADesired,
565             uint amountBDesired,
566             uint amountAMin,
567             uint amountBMin,
568             address to,
569             uint deadline
570         ) external returns (uint amountA, uint amountB, uint liquidity);
571         function addLiquidityETH(
572             address token,
573             uint amountTokenDesired,
574             uint amountTokenMin,
575             uint amountETHMin,
576             address to,
577             uint deadline
578         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
579         function removeLiquidity(
580             address tokenA,
581             address tokenB,
582             uint liquidity,
583             uint amountAMin,
584             uint amountBMin,
585             address to,
586             uint deadline
587         ) external returns (uint amountA, uint amountB);
588         function removeLiquidityETH(
589             address token,
590             uint liquidity,
591             uint amountTokenMin,
592             uint amountETHMin,
593             address to,
594             uint deadline
595         ) external returns (uint amountToken, uint amountETH);
596         function removeLiquidityWithPermit(
597             address tokenA,
598             address tokenB,
599             uint liquidity,
600             uint amountAMin,
601             uint amountBMin,
602             address to,
603             uint deadline,
604             bool approveMax, uint8 v, bytes32 r, bytes32 s
605         ) external returns (uint amountA, uint amountB);
606         function removeLiquidityETHWithPermit(
607             address token,
608             uint liquidity,
609             uint amountTokenMin,
610             uint amountETHMin,
611             address to,
612             uint deadline,
613             bool approveMax, uint8 v, bytes32 r, bytes32 s
614         ) external returns (uint amountToken, uint amountETH);
615         function swapExactTokensForTokens(
616             uint amountIn,
617             uint amountOutMin,
618             address[] calldata path,
619             address to,
620             uint deadline
621         ) external returns (uint[] memory amounts);
622         function swapTokensForExactTokens(
623             uint amountOut,
624             uint amountInMax,
625             address[] calldata path,
626             address to,
627             uint deadline
628         ) external returns (uint[] memory amounts);
629         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
630             external
631             payable
632             returns (uint[] memory amounts);
633         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
634             external
635             returns (uint[] memory amounts);
636         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
637             external
638             returns (uint[] memory amounts);
639         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
640             external
641             payable
642             returns (uint[] memory amounts);
643 
644         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
645         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
646         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
647         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
648         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
649     }
650 
651     interface IUniswapV2Router02 is IUniswapV2Router01 {
652         function removeLiquidityETHSupportingFeeOnTransferTokens(
653             address token,
654             uint liquidity,
655             uint amountTokenMin,
656             uint amountETHMin,
657             address to,
658             uint deadline
659         ) external returns (uint amountETH);
660         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
661             address token,
662             uint liquidity,
663             uint amountTokenMin,
664             uint amountETHMin,
665             address to,
666             uint deadline,
667             bool approveMax, uint8 v, bytes32 r, bytes32 s
668         ) external returns (uint amountETH);
669 
670         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
671             uint amountIn,
672             uint amountOutMin,
673             address[] calldata path,
674             address to,
675             uint deadline
676         ) external;
677         function swapExactETHForTokensSupportingFeeOnTransferTokens(
678             uint amountOutMin,
679             address[] calldata path,
680             address to,
681             uint deadline
682         ) external payable;
683         function swapExactTokensForETHSupportingFeeOnTransferTokens(
684             uint amountIn,
685             uint amountOutMin,
686             address[] calldata path,
687             address to,
688             uint deadline
689         ) external;
690     }
691 
692     // Contract implementation
693     contract MurderPenguin is Context, IERC20, Ownable {
694         using SafeMath for uint256;
695         using Address for address;
696 
697         mapping (address => uint256) private _rOwned;
698         mapping (address => uint256) private _tOwned;
699         mapping (address => mapping (address => uint256)) private _allowances;
700 
701         mapping (address => bool) private _isExcludedFromFee;
702         mapping (address => bool) private _isExcludedFromMax;
703         mapping (address => bool) private _isBlacklisted;
704 
705         mapping (address => bool) private _isExcluded;
706         address[] private _excluded;
707 
708         uint256 private constant MAX = ~uint256(0);
709         uint256 private _tTotal = 1000000000000 * 10**9;
710         uint256 private _rTotal = (MAX - (MAX % _tTotal));
711         uint256 private _tFeeTotal;
712 
713         string private _name = 'Murder Penguin';
714         string private _symbol = 'MPG';
715         uint8 private _decimals = 9;
716 
717         uint256 private _taxFee = 3;
718         uint256 private _teamFee = 2;
719         uint256 private _previousTaxFee = _taxFee;
720         uint256 private _previousTeamFee = _teamFee;
721 
722         address payable public _MurderPenguinArsenal;
723 
724         IUniswapV2Router02 public immutable uniswapV2Router;
725         address public uniswapV2Pair;
726 
727         bool inSwap = false;
728         bool public swapEnabled = true;
729 
730         uint256 private _maxTxAmount = 10000000000e9;
731         // We will set a minimum amount of tokens to be swaped => 5M
732         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
733 
734         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
735         event SwapEnabledUpdated(bool enabled);
736 
737         modifier lockTheSwap {
738             inSwap = true;
739             _;
740             inSwap = false;
741         }
742 
743         constructor (address payable MurderPenguinArsenal) public {
744             _MurderPenguinArsenal = MurderPenguinArsenal;
745             _rOwned[_msgSender()] = _rTotal;
746 
747             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
748             // Create a uniswap pair for this new token
749             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
750                 .createPair(address(this), _uniswapV2Router.WETH());
751 
752             // set the rest of the contract variables
753             uniswapV2Router = _uniswapV2Router;
754 
755             // Exclude owner and this contract from fee
756             _isExcludedFromFee[owner()] = true;
757             _isExcludedFromFee[address(this)] = true;
758             _isExcludedFromMax[owner()] = true;
759             _isExcludedFromMax[address(this)] = true;
760             _isExcludedFromMax[uniswapV2Pair] = true;
761             _isExcluded[uniswapV2Pair] = true;
762 
763             emit Transfer(address(0), _msgSender(), _tTotal);
764         }
765 
766         function name() public view returns (string memory) {
767             return _name;
768         }
769 
770         function symbol() public view returns (string memory) {
771             return _symbol;
772         }
773 
774         function decimals() public view returns (uint8) {
775             return _decimals;
776         }
777 
778         function totalSupply() public view override returns (uint256) {
779             return _tTotal;
780         }
781 
782         function balanceOf(address account) public view override returns (uint256) {
783             if (_isExcluded[account]) return _tOwned[account];
784             return tokenFromReflection(_rOwned[account]);
785         }
786 
787         function transfer(address recipient, uint256 amount) public override returns (bool) {
788             _transfer(_msgSender(), recipient, amount);
789             return true;
790         }
791 
792         function allowance(address owner, address spender) public view override returns (uint256) {
793             return _allowances[owner][spender];
794         }
795 
796         function approve(address spender, uint256 amount) public override returns (bool) {
797             _approve(_msgSender(), spender, amount);
798             return true;
799         }
800 
801         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802             _transfer(sender, recipient, amount);
803             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
804             return true;
805         }
806 
807         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809             return true;
810         }
811 
812         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
814             return true;
815         }
816 
817         function isExcluded(address account) public view returns (bool) {
818             return _isExcluded[account];
819         }
820 
821         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
822             _isExcludedFromFee[account] = excluded;
823         }
824 
825         function setExcludeFromMax(address account, bool excluded) external onlyOwner() {
826             _isExcludedFromMax[account] = excluded;
827         }
828 
829         function setBlacklist(address account, bool blacklisted) external onlyOwner() {
830             _isBlacklisted[account] = blacklisted;
831         }
832 
833         function totalFees() public view returns (uint256) {
834             return _tFeeTotal;
835         }
836 
837         function deliver(uint256 tAmount) public {
838             address sender = _msgSender();
839             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
840             (uint256 rAmount,,,,,) = _getValues(tAmount);
841             _rOwned[sender] = _rOwned[sender].sub(rAmount);
842             _rTotal = _rTotal.sub(rAmount);
843             _tFeeTotal = _tFeeTotal.add(tAmount);
844         }
845 
846         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
847             require(tAmount <= _tTotal, "Amount must be less than supply");
848             if (!deductTransferFee) {
849                 (uint256 rAmount,,,,,) = _getValues(tAmount);
850                 return rAmount;
851             } else {
852                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
853                 return rTransferAmount;
854             }
855         }
856 
857         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
858             require(rAmount <= _rTotal, "Amount must be less than total reflections");
859             uint256 currentRate =  _getRate();
860             return rAmount.div(currentRate);
861         }
862 
863         function excludeAccount(address account) external onlyOwner() {
864             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
865             require(!_isExcluded[account], "Account is already excluded");
866             if(_rOwned[account] > 0) {
867                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
868             }
869             _isExcluded[account] = true;
870             _excluded.push(account);
871         }
872 
873         function includeAccount(address account) external onlyOwner() {
874             require(_isExcluded[account], "Account is already excluded");
875             for (uint256 i = 0; i < _excluded.length; i++) {
876                 if (_excluded[i] == account) {
877                     _excluded[i] = _excluded[_excluded.length - 1];
878                     _tOwned[account] = 0;
879                     _isExcluded[account] = false;
880                     _excluded.pop();
881                     break;
882                 }
883             }
884         }
885 
886         function removeAllFee() private {
887             if(_taxFee == 0 && _teamFee == 0) return;
888 
889             _previousTaxFee = _taxFee;
890             _previousTeamFee = _teamFee;
891 
892             _taxFee = 0;
893             _teamFee = 0;
894         }
895 
896         function restoreAllFee() private {
897             _taxFee = _previousTaxFee;
898             _teamFee = _previousTeamFee;
899         }
900 
901         function isExcludedFromFee(address account) public view returns(bool) {
902             return _isExcludedFromFee[account];
903         }
904 
905         function isExcludedFromMax(address account) public view returns(bool) {
906             return _isExcludedFromMax[account];
907         }
908     
909         function isBlacklisted(address account) public view returns(bool) {
910             return _isBlacklisted[account];
911         }
912 
913         function _approve(address owner, address spender, uint256 amount) private {
914             require(owner != address(0), "ERC20: approve from the zero address");
915             require(spender != address(0), "ERC20: approve to the zero address");
916 
917             _allowances[owner][spender] = amount;
918             emit Approval(owner, spender, amount);
919         }
920 
921         function _transfer(address sender, address recipient, uint256 amount) private {
922             require(sender != address(0), "ERC20: transfer from the zero address");
923             require(recipient != address(0), "ERC20: transfer to the zero address");
924             require(amount > 0, "Transfer amount must be greater than zero");
925             require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "User blacklisted");
926 
927             if(!_isExcludedFromMax[sender] && !_isExcludedFromMax[recipient])
928                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
929 
930             // is the token balance of this contract address over the min number of
931             // tokens that we need to initiate a swap?
932             // also, don't get caught in a circular team event.
933             // also, don't swap if sender is uniswap pair.
934             uint256 contractTokenBalance = balanceOf(address(this));
935 
936             if(contractTokenBalance >= _maxTxAmount)
937             {
938                 contractTokenBalance = _maxTxAmount;
939             }
940 
941             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
942             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
943                 // We need to swap the current tokens to ETH and send to the team wallet
944                 swapTokensForEth(contractTokenBalance);
945 
946                 uint256 contractETHBalance = address(this).balance;
947                 if(contractETHBalance > 0) {
948                     sendETHToTeam(address(this).balance);
949                 }
950             }
951 
952             //indicates if fee should be deducted from transfer
953             bool takeFee = true;
954 
955             //if any account belongs to _isExcludedFromFee account then remove the fee
956             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
957                 takeFee = false;
958             }
959 
960             //transfer amount, it will take tax and team fee
961             _tokenTransfer(sender,recipient,amount,takeFee);
962         }
963 
964         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
965             // generate the uniswap pair path of token -> weth
966             address[] memory path = new address[](2);
967             path[0] = address(this);
968             path[1] = uniswapV2Router.WETH();
969 
970             _approve(address(this), address(uniswapV2Router), tokenAmount);
971 
972             // make the swap
973             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
974                 tokenAmount,
975                 0, // accept any amount of ETH
976                 path,
977                 address(this),
978                 block.timestamp
979             );
980         }
981 
982         function sendETHToTeam(uint256 amount) private {
983             _MurderPenguinArsenal.transfer(amount);
984         }
985 
986         // We are exposing these functions to be able to manual swap and send
987         // in case the token is highly valued and 5M becomes too much
988         function manualSwap() external onlyOwner() {
989             uint256 contractBalance = balanceOf(address(this));
990             swapTokensForEth(contractBalance);
991         }
992 
993         function manualSend() external onlyOwner() {
994             uint256 contractETHBalance = address(this).balance;
995             sendETHToTeam(contractETHBalance);
996         }
997 
998         function setSwapEnabled(bool enabled) external onlyOwner(){
999             swapEnabled = enabled;
1000         }
1001 
1002         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1003             if(!takeFee)
1004                 removeAllFee();
1005 
1006             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1007                 _transferFromExcluded(sender, recipient, amount);
1008             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1009                 _transferToExcluded(sender, recipient, amount);
1010             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1011                 _transferStandard(sender, recipient, amount);
1012             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1013                 _transferBothExcluded(sender, recipient, amount);
1014             } else {
1015                 _transferStandard(sender, recipient, amount);
1016             }
1017 
1018             if(!takeFee)
1019                 restoreAllFee();
1020         }
1021 
1022         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1023             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1024             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1025             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1026             _takeTeam(tTeam);
1027             _reflectFee(rFee, tFee);
1028             emit Transfer(sender, recipient, tTransferAmount);
1029         }
1030 
1031         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1032             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1033             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1034             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1035             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1036             _takeTeam(tTeam);
1037             _reflectFee(rFee, tFee);
1038             emit Transfer(sender, recipient, tTransferAmount);
1039         }
1040 
1041         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1042             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1043             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1044             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1045             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1046             _takeTeam(tTeam);
1047             _reflectFee(rFee, tFee);
1048             emit Transfer(sender, recipient, tTransferAmount);
1049         }
1050 
1051         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1052             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1053             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1054             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1055             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1056             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1057             _takeTeam(tTeam);
1058             _reflectFee(rFee, tFee);
1059             emit Transfer(sender, recipient, tTransferAmount);
1060         }
1061 
1062         function _takeTeam(uint256 tTeam) private {
1063             uint256 currentRate =  _getRate();
1064             uint256 rTeam = tTeam.mul(currentRate);
1065             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1066             if(_isExcluded[address(this)])
1067                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1068         }
1069 
1070         function _reflectFee(uint256 rFee, uint256 tFee) private {
1071             _rTotal = _rTotal.sub(rFee);
1072             _tFeeTotal = _tFeeTotal.add(tFee);
1073         }
1074 
1075          //to recieve ETH from uniswapV2Router when swaping
1076         receive() external payable {}
1077 
1078         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1079             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1080             uint256 currentRate =  _getRate();
1081             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1082             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1083         }
1084 
1085         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1086             uint256 tFee = tAmount.mul(taxFee).div(100);
1087             uint256 tTeam = tAmount.mul(teamFee).div(100);
1088             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1089             return (tTransferAmount, tFee, tTeam);
1090         }
1091 
1092         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1093             uint256 rAmount = tAmount.mul(currentRate);
1094             uint256 rFee = tFee.mul(currentRate);
1095             uint256 rTransferAmount = rAmount.sub(rFee);
1096             return (rAmount, rTransferAmount, rFee);
1097         }
1098 
1099         function _getRate() private view returns(uint256) {
1100             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1101             return rSupply.div(tSupply);
1102         }
1103 
1104         function _getCurrentSupply() private view returns(uint256, uint256) {
1105             uint256 rSupply = _rTotal;
1106             uint256 tSupply = _tTotal;
1107             for (uint256 i = 0; i < _excluded.length; i++) {
1108                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1109                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1110                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1111             }
1112             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1113             return (rSupply, tSupply);
1114         }
1115 
1116         function _getTaxFee() private view returns(uint256) {
1117             return _taxFee;
1118         }
1119 
1120         function _getMaxTxAmount() private view returns(uint256) {
1121             return _maxTxAmount;
1122         }
1123 
1124         function _getETHBalance() public view returns(uint256 balance) {
1125             return address(this).balance;
1126         }
1127 
1128         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1129             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1130             _taxFee = taxFee;
1131         }
1132 
1133         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1134             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1135             _teamFee = teamFee;
1136         }
1137 
1138         function _setMurderPenguinArsenal(address payable MurderPenguinArsenal) external onlyOwner() {
1139             _MurderPenguinArsenal = MurderPenguinArsenal;
1140         }
1141 
1142         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1143             _maxTxAmount = maxTxAmount;
1144         }
1145     }