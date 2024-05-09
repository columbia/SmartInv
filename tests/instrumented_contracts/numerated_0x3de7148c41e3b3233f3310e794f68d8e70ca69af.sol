1 /**
2             __.                                              
3         .-".'                      .--.            _..._    
4       .' .'                     .'    \       .-""  __ ""-. 
5      /  /                     .'       : --..:__.-""  ""-. \
6     :  :                     /         ;.d$$    sbp_.-""-:_:
7     ;  :                    : ._       :P .-.   ,"TP        
8     :   \                    \  T--...-; : d$b  :d$b        
9      \   `.                   \  `..'    ; $ $  ;$ $        
10       `.   "-.                 ).        : T$P  :T$P        
11         \..---^..             /           `-'    `._`._     
12        .'        "-.       .-"                     T$$$b    
13       /             "-._.-"               ._        '^' ;   
14      :                                    \.`.         /    
15      ;                                -.   \`."-._.-'-'     
16     :                                 .'\   \ \ \ \         
17     ;  ;                             /:  \   \ \ . ;        
18    :   :                            ,  ;  `.  `.;  :        
19    ;    \        ;                     ;    "-._:  ;        
20   :      `.      :                     :         \/         
21   ;       /"-.    ;                    :                    
22  :       /    "-. :                  : ;                    
23  :     .'        T-;                 ; ;        
24  ;    :          ; ;                /  :        
25  ;    ;          : :              .'    ;       
26 :    :            ;:         _..-"\     :       
27 :     \           : ;       /      \     ;      
28 ;    . '.         '-;      /        ;    :      
29 ;  \  ; :           :     :         :    '-.      
30 '.._L.:-'           :     ;    bug   ;    . `. 
31                      ;    :          :  \  ; :  
32                      :    '-..       '.._L.:-'  
33                       ;     , `.                
34                       :   \  ; :                
35                       '..__L.:-'
36 
37  * https://t.me/ShibaLink
38  * shibalink.com
39  * Renounced + Liquidity Locked in 30 minutes after launch
40  * Snipers will be blacklisted
41 
42 */
43 
44 // SPDX-License-Identifier: Unlicensed
45 pragma solidity ^0.6.12;
46 
47     abstract contract Context {
48         function _msgSender() internal view virtual returns (address payable) {
49             return msg.sender;
50         }
51 
52         function _msgData() internal view virtual returns (bytes memory) {
53             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
54             return msg.data;
55         }
56     }
57 
58     interface IERC20 {
59         /**
60         * @dev Returns the amount of tokens in existence.
61         */
62         function totalSupply() external view returns (uint256);
63 
64         /**
65         * @dev Returns the amount of tokens owned by `account`.
66         */
67         function balanceOf(address account) external view returns (uint256);
68 
69         /**
70         * @dev Moves `amount` tokens from the caller's account to `recipient`.
71         *
72         * Returns a boolean value indicating whether the operation succeeded.
73         *
74         * Emits a {Transfer} event.
75         */
76         function transfer(address recipient, uint256 amount) external returns (bool);
77 
78         /**
79         * @dev Returns the remaining number of tokens that `spender` will be
80         * allowed to spend on behalf of `owner` through {transferFrom}. This is
81         * zero by default.
82         *
83         * This value changes when {approve} or {transferFrom} are called.
84         */
85         function allowance(address owner, address spender) external view returns (uint256);
86 
87         /**
88         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89         *
90         * Returns a boolean value indicating whether the operation succeeded.
91         *
92         * IMPORTANT: Beware that changing an allowance with this method brings the risk
93         * that someone may use both the old and the new allowance by unfortunate
94         * transaction ordering. One possible solution to mitigate this race
95         * condition is to first reduce the spender's allowance to 0 and set the
96         * desired value afterwards:
97         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98         *
99         * Emits an {Approval} event.
100         */
101         function approve(address spender, uint256 amount) external returns (bool);
102 
103         /**
104         * @dev Moves `amount` tokens from `sender` to `recipient` using the
105         * allowance mechanism. `amount` is then deducted from the caller's
106         * allowance.
107         *
108         * Returns a boolean value indicating whether the operation succeeded.
109         *
110         * Emits a {Transfer} event.
111         */
112         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114         /**
115         * @dev Emitted when `value` tokens are moved from one account (`from`) to
116         * another (`to`).
117         *
118         * Note that `value` may be zero.
119         */
120         event Transfer(address indexed from, address indexed to, uint256 value);
121 
122         /**
123         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124         * a call to {approve}. `value` is the new allowance.
125         */
126         event Approval(address indexed owner, address indexed spender, uint256 value);
127     }
128 
129     library SafeMath {
130         /**
131         * @dev Returns the addition of two unsigned integers, reverting on
132         * overflow.
133         *
134         * Counterpart to Solidity's `+` operator.
135         *
136         * Requirements:
137         *
138         * - Addition cannot overflow.
139         */
140         function add(uint256 a, uint256 b) internal pure returns (uint256) {
141             uint256 c = a + b;
142             require(c >= a, "SafeMath: addition overflow");
143 
144             return c;
145         }
146 
147         /**
148         * @dev Returns the subtraction of two unsigned integers, reverting on
149         * overflow (when the result is negative).
150         *
151         * Counterpart to Solidity's `-` operator.
152         *
153         * Requirements:
154         *
155         * - Subtraction cannot overflow.
156         */
157         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158             return sub(a, b, "SafeMath: subtraction overflow");
159         }
160 
161         /**
162         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163         * overflow (when the result is negative).
164         *
165         * Counterpart to Solidity's `-` operator.
166         *
167         * Requirements:
168         *
169         * - Subtraction cannot overflow.
170         */
171         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172             require(b <= a, errorMessage);
173             uint256 c = a - b;
174 
175             return c;
176         }
177 
178         /**
179         * @dev Returns the multiplication of two unsigned integers, reverting on
180         * overflow.
181         *
182         * Counterpart to Solidity's `*` operator.
183         *
184         * Requirements:
185         *
186         * - Multiplication cannot overflow.
187         */
188         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190             // benefit is lost if 'b' is also tested.
191             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192             if (a == 0) {
193                 return 0;
194             }
195 
196             uint256 c = a * b;
197             require(c / a == b, "SafeMath: multiplication overflow");
198 
199             return c;
200         }
201 
202         /**
203         * @dev Returns the integer division of two unsigned integers. Reverts on
204         * division by zero. The result is rounded towards zero.
205         *
206         * Counterpart to Solidity's `/` operator. Note: this function uses a
207         * `revert` opcode (which leaves remaining gas untouched) while Solidity
208         * uses an invalid opcode to revert (consuming all remaining gas).
209         *
210         * Requirements:
211         *
212         * - The divisor cannot be zero.
213         */
214         function div(uint256 a, uint256 b) internal pure returns (uint256) {
215             return div(a, b, "SafeMath: division by zero");
216         }
217 
218         /**
219         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220         * division by zero. The result is rounded towards zero.
221         *
222         * Counterpart to Solidity's `/` operator. Note: this function uses a
223         * `revert` opcode (which leaves remaining gas untouched) while Solidity
224         * uses an invalid opcode to revert (consuming all remaining gas).
225         *
226         * Requirements:
227         *
228         * - The divisor cannot be zero.
229         */
230         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231             require(b > 0, errorMessage);
232             uint256 c = a / b;
233             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235             return c;
236         }
237 
238         /**
239         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240         * Reverts when dividing by zero.
241         *
242         * Counterpart to Solidity's `%` operator. This function uses a `revert`
243         * opcode (which leaves remaining gas untouched) while Solidity uses an
244         * invalid opcode to revert (consuming all remaining gas).
245         *
246         * Requirements:
247         *
248         * - The divisor cannot be zero.
249         */
250         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251             return mod(a, b, "SafeMath: modulo by zero");
252         }
253 
254         /**
255         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256         * Reverts with custom message when dividing by zero.
257         *
258         * Counterpart to Solidity's `%` operator. This function uses a `revert`
259         * opcode (which leaves remaining gas untouched) while Solidity uses an
260         * invalid opcode to revert (consuming all remaining gas).
261         *
262         * Requirements:
263         *
264         * - The divisor cannot be zero.
265         */
266         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267             require(b != 0, errorMessage);
268             return a % b;
269         }
270     }
271 
272     library Address {
273         /**
274         * @dev Returns true if `account` is a contract.
275         *
276         * [IMPORTANT]
277         * ====
278         * It is unsafe to assume that an address for which this function returns
279         * false is an externally-owned account (EOA) and not a contract.
280         *
281         * Among others, `isContract` will return false for the following
282         * types of addresses:
283         *
284         *  - an externally-owned account
285         *  - a contract in construction
286         *  - an address where a contract will be created
287         *  - an address where a contract lived, but was destroyed
288         * ====
289         */
290         function isContract(address account) internal view returns (bool) {
291             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293             // for accounts without code, i.e. `keccak256('')`
294             bytes32 codehash;
295             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296             // solhint-disable-next-line no-inline-assembly
297             assembly { codehash := extcodehash(account) }
298             return (codehash != accountHash && codehash != 0x0);
299         }
300 
301         /**
302         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303         * `recipient`, forwarding all available gas and reverting on errors.
304         *
305         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306         * of certain opcodes, possibly making contracts go over the 2300 gas limit
307         * imposed by `transfer`, making them unable to receive funds via
308         * `transfer`. {sendValue} removes this limitation.
309         *
310         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311         *
312         * IMPORTANT: because control is transferred to `recipient`, care must be
313         * taken to not create reentrancy vulnerabilities. Consider using
314         * {ReentrancyGuard} or the
315         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316         */
317         function sendValue(address payable recipient, uint256 amount) internal {
318             require(address(this).balance >= amount, "Address: insufficient balance");
319 
320             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321             (bool success, ) = recipient.call{ value: amount }("");
322             require(success, "Address: unable to send value, recipient may have reverted");
323         }
324 
325         /**
326         * @dev Performs a Solidity function call using a low level `call`. A
327         * plain`call` is an unsafe replacement for a function call: use this
328         * function instead.
329         *
330         * If `target` reverts with a revert reason, it is bubbled up by this
331         * function (like regular Solidity function calls).
332         *
333         * Returns the raw returned data. To convert to the expected return value,
334         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335         *
336         * Requirements:
337         *
338         * - `target` must be a contract.
339         * - calling `target` with `data` must not revert.
340         *
341         * _Available since v3.1._
342         */
343         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345         }
346 
347         /**
348         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349         * `errorMessage` as a fallback revert reason when `target` reverts.
350         *
351         * _Available since v3.1._
352         */
353         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354             return _functionCallWithValue(target, data, 0, errorMessage);
355         }
356 
357         /**
358         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359         * but also transferring `value` wei to `target`.
360         *
361         * Requirements:
362         *
363         * - the calling contract must have an ETH balance of at least `value`.
364         * - the called Solidity function must be `payable`.
365         *
366         * _Available since v3.1._
367         */
368         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370         }
371 
372         /**
373         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374         * with `errorMessage` as a fallback revert reason when `target` reverts.
375         *
376         * _Available since v3.1._
377         */
378         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379             require(address(this).balance >= value, "Address: insufficient balance for call");
380             return _functionCallWithValue(target, data, value, errorMessage);
381         }
382 
383         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384             require(isContract(target), "Address: call to non-contract");
385 
386             // solhint-disable-next-line avoid-low-level-calls
387             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388             if (success) {
389                 return returndata;
390             } else {
391                 // Look for revert reason and bubble it up if present
392                 if (returndata.length > 0) {
393                     // The easiest way to bubble the revert reason is using memory via assembly
394 
395                     // solhint-disable-next-line no-inline-assembly
396                     assembly {
397                         let returndata_size := mload(returndata)
398                         revert(add(32, returndata), returndata_size)
399                     }
400                 } else {
401                     revert(errorMessage);
402                 }
403             }
404         }
405     }
406 
407     contract Ownable is Context {
408         address private _owner;
409         address private _previousOwner;
410         uint256 private _lockTime;
411 
412         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414         /**
415         * @dev Initializes the contract setting the deployer as the initial owner.
416         */
417         constructor () internal {
418             address msgSender = _msgSender();
419             _owner = msgSender;
420             emit OwnershipTransferred(address(0), msgSender);
421         }
422 
423         /**
424         * @dev Returns the address of the current owner.
425         */
426         function owner() public view returns (address) {
427             return _owner;
428         }
429 
430         /**
431         * @dev Throws if called by any account other than the owner.
432         */
433         modifier onlyOwner() {
434             require(_owner == _msgSender(), "Ownable: caller is not the owner");
435             _;
436         }
437 
438         /**
439         * @dev Leaves the contract without owner. It will not be possible to call
440         * `onlyOwner` functions anymore. Can only be called by the current owner.
441         *
442         * NOTE: Renouncing ownership will leave the contract without an owner,
443         * thereby removing any functionality that is only available to the owner.
444         */
445         function renounceOwnership() public virtual onlyOwner {
446             emit OwnershipTransferred(_owner, address(0));
447             _owner = address(0);
448         }
449 
450         /**
451         * @dev Transfers ownership of the contract to a new account (`newOwner`).
452         * Can only be called by the current owner.
453         */
454         function transferOwnership(address newOwner) public virtual onlyOwner {
455             require(newOwner != address(0), "Ownable: new owner is the zero address");
456             emit OwnershipTransferred(_owner, newOwner);
457             _owner = newOwner;
458         }
459 
460         function geUnlockTime() public view returns (uint256) {
461             return _lockTime;
462         }
463 
464         //Locks the contract for owner for the amount of time provided
465         function lock(uint256 time) public virtual onlyOwner {
466             _previousOwner = _owner;
467             _owner = address(0);
468             _lockTime = now + time;
469             emit OwnershipTransferred(_owner, address(0));
470         }
471         
472         //Unlocks the contract for owner when _lockTime is exceeds
473         function unlock() public virtual {
474             require(_previousOwner == msg.sender, "You don't have permission to unlock");
475             require(now > _lockTime , "Contract is locked until 7 days");
476             emit OwnershipTransferred(_owner, _previousOwner);
477             _owner = _previousOwner;
478         }
479     }  
480 
481     interface IUniswapV2Factory {
482         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
483 
484         function feeTo() external view returns (address);
485         function feeToSetter() external view returns (address);
486 
487         function getPair(address tokenA, address tokenB) external view returns (address pair);
488         function allPairs(uint) external view returns (address pair);
489         function allPairsLength() external view returns (uint);
490 
491         function createPair(address tokenA, address tokenB) external returns (address pair);
492 
493         function setFeeTo(address) external;
494         function setFeeToSetter(address) external;
495     } 
496 
497     interface IUniswapV2Pair {
498         event Approval(address indexed owner, address indexed spender, uint value);
499         event Transfer(address indexed from, address indexed to, uint value);
500 
501         function name() external pure returns (string memory);
502         function symbol() external pure returns (string memory);
503         function decimals() external pure returns (uint8);
504         function totalSupply() external view returns (uint);
505         function balanceOf(address owner) external view returns (uint);
506         function allowance(address owner, address spender) external view returns (uint);
507 
508         function approve(address spender, uint value) external returns (bool);
509         function transfer(address to, uint value) external returns (bool);
510         function transferFrom(address from, address to, uint value) external returns (bool);
511 
512         function DOMAIN_SEPARATOR() external view returns (bytes32);
513         function PERMIT_TYPEHASH() external pure returns (bytes32);
514         function nonces(address owner) external view returns (uint);
515 
516         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518         event Mint(address indexed sender, uint amount0, uint amount1);
519         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520         event Swap(
521             address indexed sender,
522             uint amount0In,
523             uint amount1In,
524             uint amount0Out,
525             uint amount1Out,
526             address indexed to
527         );
528         event Sync(uint112 reserve0, uint112 reserve1);
529 
530         function MINIMUM_LIQUIDITY() external pure returns (uint);
531         function factory() external view returns (address);
532         function token0() external view returns (address);
533         function token1() external view returns (address);
534         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535         function price0CumulativeLast() external view returns (uint);
536         function price1CumulativeLast() external view returns (uint);
537         function kLast() external view returns (uint);
538 
539         function mint(address to) external returns (uint liquidity);
540         function burn(address to) external returns (uint amount0, uint amount1);
541         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542         function skim(address to) external;
543         function sync() external;
544 
545         function initialize(address, address) external;
546     }
547 
548     interface IUniswapV2Router01 {
549         function factory() external pure returns (address);
550         function WETH() external pure returns (address);
551 
552         function addLiquidity(
553             address tokenA,
554             address tokenB,
555             uint amountADesired,
556             uint amountBDesired,
557             uint amountAMin,
558             uint amountBMin,
559             address to,
560             uint deadline
561         ) external returns (uint amountA, uint amountB, uint liquidity);
562         function addLiquidityETH(
563             address token,
564             uint amountTokenDesired,
565             uint amountTokenMin,
566             uint amountETHMin,
567             address to,
568             uint deadline
569         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
570         function removeLiquidity(
571             address tokenA,
572             address tokenB,
573             uint liquidity,
574             uint amountAMin,
575             uint amountBMin,
576             address to,
577             uint deadline
578         ) external returns (uint amountA, uint amountB);
579         function removeLiquidityETH(
580             address token,
581             uint liquidity,
582             uint amountTokenMin,
583             uint amountETHMin,
584             address to,
585             uint deadline
586         ) external returns (uint amountToken, uint amountETH);
587         function removeLiquidityWithPermit(
588             address tokenA,
589             address tokenB,
590             uint liquidity,
591             uint amountAMin,
592             uint amountBMin,
593             address to,
594             uint deadline,
595             bool approveMax, uint8 v, bytes32 r, bytes32 s
596         ) external returns (uint amountA, uint amountB);
597         function removeLiquidityETHWithPermit(
598             address token,
599             uint liquidity,
600             uint amountTokenMin,
601             uint amountETHMin,
602             address to,
603             uint deadline,
604             bool approveMax, uint8 v, bytes32 r, bytes32 s
605         ) external returns (uint amountToken, uint amountETH);
606         function swapExactTokensForTokens(
607             uint amountIn,
608             uint amountOutMin,
609             address[] calldata path,
610             address to,
611             uint deadline
612         ) external returns (uint[] memory amounts);
613         function swapTokensForExactTokens(
614             uint amountOut,
615             uint amountInMax,
616             address[] calldata path,
617             address to,
618             uint deadline
619         ) external returns (uint[] memory amounts);
620         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
621             external
622             payable
623             returns (uint[] memory amounts);
624         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
625             external
626             returns (uint[] memory amounts);
627         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628             external
629             returns (uint[] memory amounts);
630         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
631             external
632             payable
633             returns (uint[] memory amounts);
634 
635         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
636         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
637         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
638         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
640     }
641 
642     interface IUniswapV2Router02 is IUniswapV2Router01 {
643         function removeLiquidityETHSupportingFeeOnTransferTokens(
644             address token,
645             uint liquidity,
646             uint amountTokenMin,
647             uint amountETHMin,
648             address to,
649             uint deadline
650         ) external returns (uint amountETH);
651         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652             address token,
653             uint liquidity,
654             uint amountTokenMin,
655             uint amountETHMin,
656             address to,
657             uint deadline,
658             bool approveMax, uint8 v, bytes32 r, bytes32 s
659         ) external returns (uint amountETH);
660 
661         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662             uint amountIn,
663             uint amountOutMin,
664             address[] calldata path,
665             address to,
666             uint deadline
667         ) external;
668         function swapExactETHForTokensSupportingFeeOnTransferTokens(
669             uint amountOutMin,
670             address[] calldata path,
671             address to,
672             uint deadline
673         ) external payable;
674         function swapExactTokensForETHSupportingFeeOnTransferTokens(
675             uint amountIn,
676             uint amountOutMin,
677             address[] calldata path,
678             address to,
679             uint deadline
680         ) external;
681     }
682 
683     // Contract implementation
684     contract SLINK is Context, IERC20, Ownable {
685         using SafeMath for uint256;
686         using Address for address;
687 
688         mapping (address => uint256) private _rOwned;
689         mapping (address => uint256) private _tOwned;
690         mapping (address => mapping (address => uint256)) private _allowances;
691 
692         mapping (address => bool) private _isExcludedFromFee;
693 
694         mapping (address => bool) private _isExcluded;
695         address[] private _excluded;
696     
697         uint256 private constant MAX = ~uint256(0);
698         uint256 private _tTotal = 1000000000000 * 10**9;
699         uint256 private _rTotal = (MAX - (MAX % _tTotal));
700         uint256 private _tFeeTotal;
701 
702         string private _name = 'ShibaLink';
703         string private _symbol = 'SLINK';
704         uint8 private _decimals = 9;
705         
706         // Tax and team fees will start at 0 so we don't have a big impact when deploying to Uniswap
707         // Team wallet address is null but the method to set the address is exposed
708         uint256 private _taxFee = 4; 
709         uint256 private _teamFee = 8;
710         uint256 private _previousTaxFee = _taxFee;
711         uint256 private _previousTeamFee = _teamFee;
712 
713         address payable public _teamWalletAddress;
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
735         constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
736             _teamWalletAddress = teamWalletAddress;
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
955             _teamWalletAddress.transfer(amount.div(2));
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
1111         function _setTeamWallet(address payable teamWalletAddress) external onlyOwner() {
1112             _teamWalletAddress = teamWalletAddress;
1113         }
1114         
1115         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1116             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1117             _maxTxAmount = maxTxAmount;
1118         }
1119     }