1 //"SPDX-License-Identifier: UNLICENSED"
2 
3 pragma solidity ^0.6.6;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 interface IERC20 {
149   /**
150    * @dev Returns the amount of tokens in existence.
151    */
152   function totalSupply() external view returns (uint256);
153 
154   /**
155    * @dev Returns the amount of tokens owned by `account`.
156    */
157   function balanceOf(address account) external view returns (uint256);
158 
159   /**
160    * @dev Moves `amount` tokens from the caller's account to `recipient`.
161    *
162    * Returns a boolean value indicating whether the operation succeeded.
163    *
164    * Emits a {Transfer} event.
165    */
166   function transfer(address recipient, uint256 amount) external returns (bool);
167 
168   /**
169    * @dev Returns the remaining number of tokens that `spender` will be
170    * allowed to spend on behalf of `owner` through {transferFrom}. This is
171    * zero by default.
172    *
173    * This value changes when {approve} or {transferFrom} are called.
174    */
175   function allowance(address owner, address spender)
176     external
177     view
178     returns (uint256);
179 
180   /**
181    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182    *
183    * Returns a boolean value indicating whether the operation succeeded.
184    *
185    * IMPORTANT: Beware that changing an allowance with this method brings the risk
186    * that someone may use both the old and the new allowance by unfortunate
187    * transaction ordering. One possible solution to mitigate this race
188    * condition is to first reduce the spender's allowance to 0 and set the
189    * desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    *
192    * Emits an {Approval} event.
193    */
194   function approve(address spender, uint256 amount) external returns (bool);
195 
196   /**
197    * @dev Moves `amount` tokens from `sender` to `recipient` using the
198    * allowance mechanism. `amount` is then deducted from the caller's
199    * allowance.
200    *
201    * Returns a boolean value indicating whether the operation succeeded.
202    *
203    * Emits a {Transfer} event.
204    */
205   function transferFrom(
206     address sender,
207     address recipient,
208     uint256 amount
209   ) external returns (bool);
210 
211   /**
212    * @dev Emitted when `value` tokens are moved from one account (`from`) to
213    * another (`to`).
214    *
215    * Note that `value` may be zero.
216    */
217   event Transfer(address indexed from, address indexed to, uint256 value);
218 
219   /**
220    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221    * a call to {approve}. `value` is the new allowance.
222    */
223   event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 interface IUniswapV2Factory {
227     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
228 
229     function feeTo() external view returns (address);
230     function feeToSetter() external view returns (address);
231 
232     function getPair(address tokenA, address tokenB) external view returns (address pair);
233     function allPairs(uint) external view returns (address pair);
234     function allPairsLength() external view returns (uint);
235 
236     function createPair(address tokenA, address tokenB) external returns (address pair);
237 
238     function setFeeTo(address) external;
239     function setFeeToSetter(address) external;
240 }
241 
242 interface UniswapV2Router{
243     
244     function addLiquidity(
245       address tokenA,
246       address tokenB,
247       uint amountADesired,
248       uint amountBDesired,
249       uint amountAMin,
250       uint amountBMin,
251       address to,
252       uint deadline
253     ) external returns (uint amountA, uint amountB, uint liquidity);
254     
255     function addLiquidityETH(
256       address token,
257       uint amountTokenDesired,
258       uint amountTokenMin,
259       uint amountETHMin,
260       address to,
261       uint deadline
262     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
263      
264     function removeLiquidityETH(
265         address token,
266         uint liquidity,
267         uint amountTokenMin,
268         uint amountETHMin,
269         address to,
270         uint deadline
271     ) external returns (uint amountToken, uint amountETH);
272     
273     function removeLiquidity(
274         address tokenA,
275         address tokenB,
276         uint liquidity,
277         uint amountAMin,
278         uint amountBMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountA, uint amountB);
282     
283     function swapExactTokensForTokens(
284         uint amountIn,
285         uint amountOutMin,
286         address[] calldata path,
287         address to,
288         uint deadline
289     ) external returns (uint[] memory amounts);
290     
291     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
292 
293 }
294 
295 library UniswapV2Library {
296     using SafeMath for uint;
297 
298     // returns sorted token addresses, used to handle return values from pairs sorted in this order
299     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
300         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
301         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
302         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
303     }
304 
305     // calculates the CREATE2 address for a pair without making any external calls
306     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
307         (address token0, address token1) = sortTokens(tokenA, tokenB);
308         pair = address(uint(keccak256(abi.encodePacked(
309                 hex'ff',
310                 factory,
311                 keccak256(abi.encodePacked(token0, token1)),
312                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
313             ))));
314     }
315 
316     // fetches and sorts the reserves for a pair
317     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
318         (address token0,) = sortTokens(tokenA, tokenB);
319         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
320         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
321     }
322 
323     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
324     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
325         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
326         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
327         amountB = amountA.mul(reserveB) / reserveA;
328     }
329 
330     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
331     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
332         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
333         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
334         uint amountInWithFee = amountIn.mul(997);
335         uint numerator = amountInWithFee.mul(reserveOut);
336         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
337         amountOut = numerator / denominator;
338     }
339 
340     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
341     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
342         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
343         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
344         uint numerator = reserveIn.mul(amountOut).mul(1000);
345         uint denominator = reserveOut.sub(amountOut).mul(997);
346         amountIn = (numerator / denominator).add(1);
347     }
348 
349     // performs chained getAmountOut calculations on any number of pairs
350     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
351         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
352         amounts = new uint[](path.length);
353         amounts[0] = amountIn;
354         for (uint i; i < path.length - 1; i++) {
355             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
356             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
357         }
358     }
359 
360     // performs chained getAmountIn calculations on any number of pairs
361     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
362         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
363         amounts = new uint[](path.length);
364         amounts[amounts.length - 1] = amountOut;
365         for (uint i = path.length - 1; i > 0; i--) {
366             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
367             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
368         }
369     }
370 }
371 
372 interface IUniswapV2Pair {
373     event Approval(address indexed owner, address indexed spender, uint value);
374     event Transfer(address indexed from, address indexed to, uint value);
375 
376     function name() external pure returns (string memory);
377     function symbol() external pure returns (string memory);
378     function decimals() external pure returns (uint8);
379     function totalSupply() external view returns (uint);
380     function balanceOf(address owner) external view returns (uint);
381     function allowance(address owner, address spender) external view returns (uint);
382 
383     function approve(address spender, uint value) external returns (bool);
384     function transfer(address to, uint value) external returns (bool);
385     function transferFrom(address from, address to, uint value) external returns (bool);
386 
387     function DOMAIN_SEPARATOR() external view returns (bytes32);
388     function PERMIT_TYPEHASH() external pure returns (bytes32);
389     function nonces(address owner) external view returns (uint);
390 
391     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
392 
393     event Mint(address indexed sender, uint amount0, uint amount1);
394     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
395     event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
396     event Sync(uint112 reserve0, uint112 reserve1);
397 
398     function MINIMUM_LIQUIDITY() external pure returns (uint);
399     function factory() external view returns (address);
400     function token0() external view returns (address);
401     function token1() external view returns (address);
402     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
403     function price0CumulativeLast() external view returns (uint);
404     function price1CumulativeLast() external view returns (uint);
405     function kLast() external view returns (uint);
406 
407     function mint(address to) external returns (uint liquidity);
408     function burn(address to) external returns (uint amount0, uint amount1);
409     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
410     function skim(address to) external;
411     function sync() external;
412 
413     function initialize(address, address) external;
414 }
415 
416 contract Owned {
417     
418     //address of contract owner
419     address public owner;
420 
421     //event for transfer of ownership
422     event OwnershipTransferred(address indexed _from, address indexed _to);
423 
424     /**
425      * @dev Initializes the contract setting the _owner as the initial owner.
426      */
427     constructor(address _owner) public {
428         owner = _owner;
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner {
435         require(msg.sender == owner, 'only owner allowed');
436         _;
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`_newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address _newOwner) external onlyOwner {
444         owner = _newOwner;
445         emit OwnershipTransferred(owner, _newOwner);
446     }
447 }
448 
449 interface Multiplier {
450     function updateLockupPeriod(address _user, uint _lockup) external returns(bool);
451     function getMultiplierCeiling() external pure returns (uint);
452     function balance(address user) external view returns (uint);
453     function approvedContract(address _user) external view returns(address);
454     function lockupPeriod(address user) external view returns (uint);
455 }
456 
457 /* 
458  * @dev PoolStakes contract for locking up liquidity to earn bonus rewards.
459  */
460 contract PoolStake is Owned {
461     //instantiate SafeMath library
462     using SafeMath for uint;
463     
464     IERC20 internal weth;                       //represents weth.
465     IERC20 internal token;                      //represents the project's token which should have a weth pair on uniswap
466     IERC20 internal lpToken;                    //lpToken for liquidity provisioning
467     
468     address internal uToken;                    //utility token
469     address internal wallet;                    //company wallet
470     uint internal scalar = 10**36;              //unit for scaling
471     uint internal cap;                          //ETH limit that can be provided
472     
473     Multiplier internal multiplier;                         //Interface of Multiplier contract
474     UniswapV2Router internal uniswapRouter;                 //Interface of Uniswap V2 router
475     IUniswapV2Factory internal iUniswapV2Factory;           //Interface of uniswap V2 factore
476     
477     //user struct
478     struct User {
479         uint start;                 //starting period
480         uint release;               //release period
481         uint tokenBonus;            //user token bonus
482         uint wethBonus;             //user weth bonus
483         uint tokenWithdrawn;        //amount of token bonus withdrawn
484         uint wethWithdrawn;         //amount of weth bonus withdrawn
485         uint liquidity;             //user liquidity gotten from uniswap
486         bool migrated;              //if migrated to uniswap V3
487     }
488     
489     //address to User mapping
490     mapping(address => User) internal _users;
491     
492     uint32 internal constant _012_HOURS_IN_SECONDS = 43200;
493     
494     //term periods
495     uint32 internal period1;
496     uint32 internal period2;
497     uint32 internal period3;
498     uint32 internal period4;
499     
500     //return percentages for ETH and token                          1000 = 1% 
501     uint internal period1RPWeth; 
502     uint internal period2RPWeth;
503     uint internal period3RPWeth;
504     uint internal period4RPWeth;
505     uint internal period1RPToken; 
506     uint internal period2RPToken;
507     uint internal period3RPToken;
508     uint internal period4RPToken;
509     
510     //available bonuses rto be claimed
511     uint internal _pendingBonusesWeth;
512     uint internal _pendingBonusesToken;
513     
514     //migration contract for Uniswap V3
515     address public migrationContract;
516     
517     //events
518     event BonusAdded(address indexed sender, uint ethAmount, uint tokenAmount);
519     event BonusRemoved(address indexed sender, uint amount);
520     event CapUpdated(address indexed sender, uint amount);
521     event LPWithdrawn(address indexed sender, uint amount);
522     event LiquidityAdded(address indexed sender, uint liquidity, uint amountETH, uint amountToken);
523     event LiquidityWithdrawn(address indexed sender, uint liquidity, uint amountETH, uint amountToken);
524     event UserTokenBonusWithdrawn(address indexed sender, uint amount, uint fee);
525     event UserETHBonusWithdrawn(address indexed sender, uint amount, uint fee);
526     event VersionMigrated(address indexed sender, uint256 time, address to);
527     event LiquidityMigrated(address indexed sender, uint amount, address to);
528     
529     /* 
530      * @dev initiates a new PoolStake.
531      * ------------------------------------------------------
532      * @param _token    --> token offered for staking liquidity.
533      * @param _Owner    --> address for the initial contract owner.
534      */ 
535     constructor(address _token, address _Owner) public Owned(_Owner) {
536             
537         require(_token != address(0), "can not deploy a zero address");
538         token = IERC20(_token);
539         weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 
540         
541         iUniswapV2Factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
542         address _lpToken = iUniswapV2Factory.getPair(address(token), address(weth));
543         require(_lpToken != address(0), "Pair must be created on uniswap first");
544         lpToken = IERC20(_lpToken);
545         
546         uToken = 0x9Ed8e7C9604790F7Ec589F99b94361d8AAB64E5E;
547         wallet = 0xa7A4d919202DFA2f4E44FFAc422d21095bF9770a;
548         multiplier = Multiplier(0xbc962d7be33d8AfB4a547936D8CE6b9a1034E9EE);
549         uniswapRouter = UniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);        
550     }
551     
552     /* 
553      * @dev change the return percentage for locking up liquidity for ETH and Token (only Owner).
554      * ------------------------------------------------------------------------------------
555      * @param _period1RPETH - _period4RPToken --> the new return percentages.
556      * ----------------------------------------------
557      * returns whether successfully changed or not.
558      */ 
559     function changeReturnPercentages(
560         uint _period1RPETH, uint _period2RPETH, uint _period3RPETH, uint _period4RPETH, 
561         uint _period1RPToken, uint _period2RPToken, uint _period3RPToken, uint _period4RPToken
562     ) external onlyOwner returns(bool) {
563         
564         period1RPWeth = _period1RPETH;
565         period2RPWeth = _period2RPETH;
566         period3RPWeth = _period3RPETH;
567         period4RPWeth = _period4RPETH;
568         
569         period1RPToken = _period1RPToken;
570         period2RPToken = _period2RPToken;
571         period3RPToken = _period3RPToken;
572         period4RPToken = _period4RPToken;
573         
574         return true;
575     }
576     
577     /* 
578      * @dev change the lockup periods (only Owner).
579      * ------------------------------------------------------------------------------------
580      * @param _firstTerm - _fourthTerm --> the new term periods.
581      * ----------------------------------------------
582      * returns whether successfully changed or not.
583      */ 
584     function changeTermPeriods(
585         uint32 _firstTerm, uint32 _secondTerm, 
586         uint32 _thirdTerm, uint32 _fourthTerm
587     ) external onlyOwner returns(bool) {
588         
589         period1 = _firstTerm;
590         period2 = _secondTerm;
591         period3 = _thirdTerm;
592         period4 = _fourthTerm;
593         
594         return true;
595     }
596     
597     /* 
598      * @dev change the maximum ETH that a user can enter with (only Owner).
599      * ------------------------------------------------------------------------------------
600      * @param _cap      --> the new cap value.
601      * ----------------------------------------------
602      * returns whether successfully changed or not.
603      */ 
604     function changeCap(uint _cap) external onlyOwner returns(bool) {
605         
606         cap = _cap;
607         
608         emit CapUpdated(msg.sender, _cap);
609         return true;
610     }
611     
612     /* 
613      * @dev makes migration possible for uniswap V3 (only Owner).
614      * ----------------------------------------------------------
615      * @param _unistakeMigrationContract      --> the migration contract address.
616      * -------------------------------------------------------------------------
617      * returns whether successfully migrated or not.
618      */ 
619     function allowMigration(address _unistakeMigrationContract) external onlyOwner returns (bool) {
620         
621         require(_unistakeMigrationContract != address(0x0), "cannot migrate to a null address");
622         migrationContract = _unistakeMigrationContract;
623         
624         emit VersionMigrated(msg.sender, now, migrationContract);
625         return true;
626     }
627     
628     /* 
629      * @dev initiates migration for a user (only when migration is allowed).
630      * -------------------------------------------------------------------
631      * @param _unistakeMigrationContract      --> the migration contract address.
632      * -------------------------------------------------------------------------
633      * returns whether successfully migrated or not.
634      */ 
635     function startMigration(address _unistakeMigrationContract) external returns (bool) {
636         
637         require(_unistakeMigrationContract != address(0x0), "cannot migrate to a null address");
638         require(migrationContract == _unistakeMigrationContract, "must confirm endpoint");
639         require(!getUserMigration(msg.sender), "must not be migrated already");
640         
641         _users[msg.sender].migrated = true;
642         
643         uint256 liquidity = _users[msg.sender].liquidity;
644         lpToken.transfer(migrationContract, liquidity);
645         
646         emit LiquidityMigrated(msg.sender, liquidity, migrationContract);
647         return true;
648     }
649     
650     /* 
651      * @dev add more staking bonuses to the pool.
652      * ----------------------------------------
653      * @param              --> input value along with call to add ETH
654      * @param _tokenAmount --> the amount of token to be added.
655      * --------------------------------------------------------
656      * returns whether successfully added or not.
657      */ 
658     function addBonus(uint _tokenAmount) external payable returns(bool) {
659         
660         if (_tokenAmount > 0)
661         require(token.transferFrom(msg.sender, address(this), _tokenAmount), "must approve smart contract");
662         
663         BonusAdded(msg.sender, msg.value, _tokenAmount);
664         return true;
665     }
666     
667     /* 
668      * @dev remove staking bonuses to the pool. (only owner)
669      * must have enough asset to be removed
670      * ----------------------------------------
671      * @param _amountETH   --> eth amount to be removed
672      * @param _amountToken --> token amount to be removed.
673      * --------------------------------------------------------
674      * returns whether successfully added or not.
675      */ 
676     function removeETHAndTokenBouses(uint _amountETH, uint _amountToken) external onlyOwner returns (bool success) {
677        
678         require(_amountETH > 0 || _amountToken > 0, "amount must be larger than zero");
679     
680         if (_amountETH > 0) {
681             require(_checkForSufficientStakingBonusesForETH(_amountETH), 'cannot withdraw above current ETH bonus balance');
682             msg.sender.transfer(_amountETH);
683             emit BonusRemoved(msg.sender, _amountETH);
684         }
685         
686         if (_amountToken > 0) {
687             require(_checkForSufficientStakingBonusesForToken(_amountToken), 'cannot withdraw above current token bonus balance');
688             require(token.transfer(msg.sender, _amountToken), "error: token transfer failed");
689             emit BonusRemoved(msg.sender, _amountToken);
690         }
691         
692         return true;
693     }
694     
695     /* 
696      * @dev add unwrapped liquidity to staking pool.
697      * --------------------------------------------
698      * @param             --> must input ETH value along with call
699      * @param _term       --> the lockup term.
700      * @param _multiplier --> whether multiplier should be used or not
701      *                        1 means you want to use the multiplier. !1 means no multiplier
702      * --------------------------------------------------------------
703      * returns whether successfully added or not.
704      */
705     function addLiquidity(uint _term, uint _multiplier) external payable returns(bool) {
706         
707         require(!getUserMigration(msg.sender), "must not be migrated already");
708         require(now >= _users[msg.sender].release, "cannot override current term");
709         require(_isValidTerm(_term), "must select a valid term");
710         require(msg.value > 0, "must send ETH along with transaction");
711         if (cap != 0) require(msg.value <= cap, "cannot provide more than the cap");
712         
713         uint rate = _proportion(msg.value, address(weth), address(token));
714         require(token.transferFrom(msg.sender, address(this), rate), "must approve smart contract");
715         
716         (uint ETH_bonus, uint token_bonus) = getUserBonusPending(msg.sender);
717         require(ETH_bonus == 0 && token_bonus == 0, "must first withdraw available bonus");
718         
719         uint oneTenthOfRate = (rate.mul(10)).div(100);
720         token.approve(address(uniswapRouter), rate);
721 
722         (uint amountToken, uint amountETH, uint liquidity) = 
723         uniswapRouter.addLiquidityETH{value: msg.value}(
724             address(token), 
725             rate.add(oneTenthOfRate), 
726             0, 
727             0, 
728             address(this), 
729             now.add(_012_HOURS_IN_SECONDS));
730         
731         _users[msg.sender].start = now;
732         _users[msg.sender].release = now.add(_term);
733         
734         uint previousLiquidity = _users[msg.sender].liquidity; 
735         _users[msg.sender].liquidity = previousLiquidity.add(liquidity);  
736         
737         uint wethRP = _calculateReturnPercentage(weth, _term);
738         uint tokenRP = _calculateReturnPercentage(token, _term);
739                
740         (uint provided_ETH, uint provided_token) = getUserLiquidity(msg.sender);
741         
742         if (_multiplier == 1) {
743             
744             _withMultiplier(
745                 _term, provided_ETH, provided_token, wethRP,  tokenRP);
746             
747         } else {
748             
749             _withoutMultiplier(provided_ETH, provided_token, wethRP, tokenRP);
750         }
751         
752         emit LiquidityAdded(msg.sender, liquidity, amountETH, amountToken);
753         return true;
754     }
755     
756     /* 
757      * @dev uses the Multiplier contract for double rewarding
758      * ------------------------------------------------------
759      * @param _term       --> the lockup term.
760      * @param amountETH   --> ETH amount provided in liquidity
761      * @param amountToken --> token amount provided in liquidity
762      * @param wethRP      --> return percentge for ETH based on term period
763      * @param tokenRP     --> return percentge for token based on term period
764      * --------------------------------------------------------------------
765      */
766     function _withMultiplier(
767         uint _term, uint amountETH, uint amountToken, uint wethRP, uint tokenRP
768     ) internal {
769         
770         require(multiplier.balance(msg.sender) > 0, "No Multiplier balance to use");
771         if (_term > multiplier.lockupPeriod(msg.sender)) multiplier.updateLockupPeriod(msg.sender, _term);
772         
773         uint multipliedETH = _proportion(multiplier.balance(msg.sender), uToken, address(weth));
774         uint multipliedToken = _proportion(multipliedETH, address(weth), address(token));
775         uint addedBonusWeth;
776         uint addedBonusToken;
777         
778         if (_offersBonus(weth) && _offersBonus(token)) {
779                     
780             if (multipliedETH > amountETH) {
781                 multipliedETH = (_calculateBonus((amountETH.mul(multiplier.getMultiplierCeiling())), wethRP));
782                 addedBonusWeth = multipliedETH;
783             } else {
784                 addedBonusWeth = (_calculateBonus((amountETH.add(multipliedETH)), wethRP));
785             }
786                     
787             if (multipliedToken > amountToken) {
788                 multipliedToken = (_calculateBonus((amountToken.mul(multiplier.getMultiplierCeiling())), tokenRP));
789                 addedBonusToken = multipliedToken;
790             } else {
791                 addedBonusToken = (_calculateBonus((amountToken.add(multipliedToken)), tokenRP));
792             }
793                 
794             require(_checkForSufficientStakingBonusesForETH(addedBonusWeth)
795             && _checkForSufficientStakingBonusesForToken(addedBonusToken),
796             "must be sufficient staking bonuses available in pool");
797                             
798             _users[msg.sender].wethBonus = _users[msg.sender].wethBonus.add(addedBonusWeth);
799             _users[msg.sender].tokenBonus = _users[msg.sender].tokenBonus.add(addedBonusToken);
800             _pendingBonusesWeth = _pendingBonusesWeth.add(addedBonusWeth);
801             _pendingBonusesToken = _pendingBonusesToken.add(addedBonusToken);
802                     
803         } else if (_offersBonus(weth) && !_offersBonus(token)) {
804                     
805             if (multipliedETH > amountETH) {
806                 multipliedETH = (_calculateBonus((amountETH.mul(multiplier.getMultiplierCeiling())), wethRP));
807                 addedBonusWeth = multipliedETH;
808             } else {
809                 addedBonusWeth = (_calculateBonus((amountETH.add(multipliedETH)), wethRP));
810             }
811                     
812             require(_checkForSufficientStakingBonusesForETH(addedBonusWeth), 
813             "must be sufficient staking bonuses available in pool");
814                     
815             _users[msg.sender].wethBonus = _users[msg.sender].wethBonus.add(addedBonusWeth);
816             _pendingBonusesWeth = _pendingBonusesWeth.add(addedBonusWeth);
817                     
818         } else if (!_offersBonus(weth) && _offersBonus(token)) {
819         
820             if (multipliedToken > amountToken) {
821                 multipliedToken = (_calculateBonus((amountToken.mul(multiplier.getMultiplierCeiling())), tokenRP));
822                 addedBonusToken = multipliedToken;
823             } else {
824                 addedBonusToken = (_calculateBonus((amountToken.add(multipliedToken)), tokenRP));
825             }
826                     
827             require(_checkForSufficientStakingBonusesForToken(addedBonusToken),
828             "must be sufficient staking bonuses available in pool");
829                     
830             _users[msg.sender].tokenBonus = _users[msg.sender].tokenBonus.add(addedBonusToken);
831             _pendingBonusesToken = _pendingBonusesToken.add(addedBonusToken);
832         }
833     }
834     
835     /* 
836      * @dev distributes bonus without considering Multiplier
837      * ------------------------------------------------------
838      * @param amountETH   --> ETH amount provided in liquidity
839      * @param amountToken --> token amount provided in liquidity
840      * @param wethRP      --> return percentge for ETH based on term period
841      * @param tokenRP     --> return percentge for token based on term period
842      * --------------------------------------------------------------------
843      */
844     function _withoutMultiplier(
845         uint amountETH, uint amountToken, uint wethRP, uint tokenRP
846     ) internal {
847             
848         uint addedBonusWeth;
849         uint addedBonusToken;
850         
851         if (_offersBonus(weth) && _offersBonus(token)) {
852             
853             addedBonusWeth = _calculateBonus(amountETH, wethRP);
854             addedBonusToken = _calculateBonus(amountToken, tokenRP);
855                 
856             require(_checkForSufficientStakingBonusesForETH(addedBonusWeth)
857             && _checkForSufficientStakingBonusesForToken(addedBonusToken),
858             "must be sufficient staking bonuses available in pool");
859                         
860             _users[msg.sender].wethBonus = _users[msg.sender].wethBonus.add(addedBonusWeth);
861             _users[msg.sender].tokenBonus = _users[msg.sender].tokenBonus.add(addedBonusToken);
862             _pendingBonusesWeth = _pendingBonusesWeth.add(addedBonusWeth);
863             _pendingBonusesToken = _pendingBonusesToken.add(addedBonusToken);
864                 
865         } else if (_offersBonus(weth) && !_offersBonus(token)) {
866                 
867             addedBonusWeth = _calculateBonus(amountETH, wethRP);
868                 
869             require(_checkForSufficientStakingBonusesForETH(addedBonusWeth), 
870             "must be sufficient staking bonuses available in pool");
871                 
872             _users[msg.sender].wethBonus = _users[msg.sender].wethBonus.add(addedBonusWeth);
873             _pendingBonusesWeth = _pendingBonusesWeth.add(addedBonusWeth);
874                 
875         } else if (!_offersBonus(weth) && _offersBonus(token)) {
876                 
877             addedBonusToken = _calculateBonus(amountToken, tokenRP);
878                 
879             require(_checkForSufficientStakingBonusesForToken(addedBonusToken),
880             "must be sufficient staking bonuses available in pool");
881                 
882             _users[msg.sender].tokenBonus = _users[msg.sender].tokenBonus.add(addedBonusToken);
883             _pendingBonusesToken = _pendingBonusesToken.add(addedBonusToken);
884         }
885         
886     }
887     
888     /* 
889      * @dev relocks liquidity already provided
890      * --------------------------------------------
891      * @param _term       --> the lockup term.
892      * @param _multiplier --> whether multiplier should be used or not
893      *                        1 means you want to use the multiplier. !1 means no multiplier
894      * --------------------------------------------------------------
895      * returns whether successfully relocked or not.
896      */
897     function relockLiquidity(uint _term, uint _multiplier) external returns(bool) {
898         
899         require(!getUserMigration(msg.sender), "must not be migrated already");
900         require(_users[msg.sender].liquidity > 0, "do not have any liquidity to lock");
901         require(now >= _users[msg.sender].release, "cannot override current term");
902         require(_isValidTerm(_term), "must select a valid term");
903         
904         (uint ETH_bonus, uint token_bonus) = getUserBonusPending(msg.sender);
905         require (ETH_bonus == 0 && token_bonus == 0, 'must withdraw available bonuses first');
906         
907         (uint provided_ETH, uint provided_token) = getUserLiquidity(msg.sender);
908         if (cap != 0) require(provided_ETH <= cap, "cannot provide more than the cap");
909         
910         uint wethRP = _calculateReturnPercentage(weth, _term);
911         uint tokenRP = _calculateReturnPercentage(token, _term);
912         
913         _users[msg.sender].start = now;
914         _users[msg.sender].release = now.add(_term);
915         
916         if (_multiplier == 1) _withMultiplier(_term, provided_ETH, provided_token, wethRP,  tokenRP);
917         else _withoutMultiplier(provided_ETH, provided_token, wethRP, tokenRP); 
918         
919         return true;
920     }
921     
922     /* 
923      * @dev withdraw unwrapped liquidity by user if released.
924      * -------------------------------------------------------
925      * @param _lpAmount --> takes the amount of user's lp token to be withdrawn.
926      * -------------------------------------------------------------------------
927      * returns whether successfully withdrawn or not.
928      */
929     function withdrawLiquidity(uint _lpAmount) external returns(bool) {
930         require(!getUserMigration(msg.sender), "must not be migrated already");
931         
932         uint liquidity = _users[msg.sender].liquidity;
933         require(_lpAmount > 0 && _lpAmount <= liquidity, "do not have any liquidity");
934         require(now >= _users[msg.sender].release, "cannot override current term");
935         
936         _users[msg.sender].liquidity = liquidity.sub(_lpAmount); 
937         
938         lpToken.approve(address(uniswapRouter), _lpAmount);                                         
939         
940         (uint amountToken, uint amountETH) = 
941             uniswapRouter.removeLiquidityETH(
942                 address(token),
943                 _lpAmount,
944                 1,
945                 1,
946                 msg.sender,
947                 now.add(_012_HOURS_IN_SECONDS));
948         
949         emit LiquidityWithdrawn(msg.sender, _lpAmount, amountETH, amountToken);
950         return true;
951     }
952     
953     /* 
954      * @dev withdraw LP token by user if released.
955      * -------------------------------------------------------
956      * returns whether successfully withdrawn or not.
957      */
958     function withdrawUserLP() external returns(bool) {
959         
960         uint liquidity = _users[msg.sender].liquidity;
961         require(liquidity > 0, "do not have any liquidity");
962         require(now >= _users[msg.sender].release, "cannot override current term");
963         
964         _users[msg.sender].liquidity = 0; 
965         
966         lpToken.transfer(msg.sender, liquidity);                                         
967         
968         emit LPWithdrawn(msg.sender, liquidity);
969         return true;
970     }
971     
972     /* 
973      * @dev withdraw staking bonuses earned from locking up liquidity. 
974      * --------------------------------------------------------------
975      * returns whether successfully withdrawn or not.
976      */  
977     function withdrawUserBonus() public returns(bool) {
978         
979         (uint ETH_bonus, uint token_bonus) = getUserBonusAvailable(msg.sender);
980         require(ETH_bonus > 0 || token_bonus > 0, "you do not have any bonus available");
981         
982         uint releasedToken = _calculateTokenReleasedAmount(msg.sender);
983         uint releasedETH = _calculateETHReleasedAmount(msg.sender);
984         
985         if (releasedToken > 0 && releasedETH > 0) {
986             
987             _withdrawUserTokenBonus(msg.sender, releasedToken);
988             _withdrawUserETHBonus(msg.sender, releasedETH);
989             
990         } else if (releasedETH > 0 && releasedToken == 0) 
991             _withdrawUserETHBonus(msg.sender, releasedETH);
992         
993         else if (releasedETH == 0 && releasedToken > 0)
994             _withdrawUserTokenBonus(msg.sender, releasedToken);
995         
996         if (_users[msg.sender].release <= now) {
997             
998             _users[msg.sender].wethWithdrawn = 0;
999             _users[msg.sender].tokenWithdrawn = 0;
1000             _users[msg.sender].wethBonus = 0;
1001             _users[msg.sender].tokenBonus = 0;
1002         }
1003         return true;
1004     }
1005     
1006     /* 
1007      * @dev withdraw ETH bonus earned from locking up liquidity
1008      * --------------------------------------------------------------
1009      * @param _user          --> address of the user making withdrawal
1010      * @param releasedAmount --> released ETH to be withdrawn
1011      * ------------------------------------------------------------------
1012      * returns whether successfully withdrawn or not.
1013      */
1014     function _withdrawUserETHBonus(address payable _user, uint releasedAmount) internal returns(bool) {
1015      
1016         _users[_user].wethWithdrawn = _users[_user].wethWithdrawn.add(releasedAmount);
1017         _pendingBonusesWeth = _pendingBonusesWeth.sub(releasedAmount);
1018         
1019         (uint fee, uint feeInETH) = _calculateETHFee(releasedAmount);
1020         
1021         require(IERC20(uToken).transferFrom(_user, wallet, fee), "must approve fee");
1022         _user.transfer(releasedAmount);
1023     
1024         emit UserETHBonusWithdrawn(_user, releasedAmount, feeInETH);
1025         return true;
1026     }
1027     
1028     /* 
1029      * @dev withdraw token bonus earned from locking up liquidity
1030      * --------------------------------------------------------------
1031      * @param _user          --> address of the user making withdrawal
1032      * @param releasedAmount --> released token to be withdrawn
1033      * ------------------------------------------------------------------
1034      * returns whether successfully withdrawn or not.
1035      */
1036     function _withdrawUserTokenBonus(address _user, uint releasedAmount) internal returns(bool) {
1037         
1038         _users[_user].tokenWithdrawn = _users[_user].tokenWithdrawn.add(releasedAmount);
1039         _pendingBonusesToken = _pendingBonusesToken.sub(releasedAmount);
1040         
1041         (uint fee, uint feeInToken) = _calculateTokenFee(releasedAmount);
1042         
1043         require(IERC20(uToken).transferFrom(_user, wallet, fee), "must approve fee");
1044         token.transfer(_user, releasedAmount);
1045     
1046         emit UserTokenBonusWithdrawn(_user, releasedAmount, feeInToken);
1047         return true;
1048     }
1049     
1050     /* 
1051      * @dev gets an asset's amount in proportion of a pair asset
1052      * ---------------------------------------------------------
1053      * param _amount --> the amount of first asset
1054      * param _tokenA --> the address of the first asset
1055      * param _tokenB --> the address of the second asset
1056      * -------------------------------------------------
1057      * returns the propotion of the _tokenB
1058      */ 
1059     function _proportion(uint _amount, address _tokenA, address _tokenB) internal view returns(uint tokenBAmount) {
1060         
1061         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(address(iUniswapV2Factory), _tokenA, _tokenB);
1062         
1063         return UniswapV2Library.quote(_amount, reserveA, reserveB);
1064     }
1065     
1066     /* 
1067      * @dev gets the released Token value
1068      * --------------------------------
1069      * param _user --> the address of the user
1070      * ------------------------------------------------------
1071      * returns the released amount in Token
1072      */ 
1073     function _calculateTokenReleasedAmount(address _user) internal view returns(uint) {
1074 
1075         uint release = _users[_user].release;
1076         uint start = _users[_user].start;
1077         uint taken = _users[_user].tokenWithdrawn;
1078         uint tokenBonus = _users[_user].tokenBonus;
1079         uint releasedPct;
1080         
1081         if (now >= release) releasedPct = 100;
1082         else releasedPct = ((now.sub(start)).mul(100000)).div((release.sub(start)).mul(1000));
1083         
1084         uint released = (((tokenBonus).mul(releasedPct)).div(100));
1085         return released.sub(taken);
1086     }
1087     
1088     /* 
1089      * @dev gets the released ETH value
1090      * --------------------------------
1091      * param _user --> the address of the user
1092      * ------------------------------------------------------
1093      * returns the released amount in ETH
1094      */ 
1095     function _calculateETHReleasedAmount(address _user) internal view returns(uint) {
1096         
1097         uint release = _users[_user].release;
1098         uint start = _users[_user].start;
1099         uint taken = _users[_user].wethWithdrawn;
1100         uint wethBonus = _users[_user].wethBonus;
1101         uint releasedPct;
1102         
1103         if (now >= release) releasedPct = 100;
1104         else releasedPct = ((now.sub(start)).mul(10000)).div((release.sub(start)).mul(100));
1105         
1106         uint released = (((wethBonus).mul(releasedPct)).div(100));
1107         return released.sub(taken);
1108     }
1109     
1110     /* 
1111      * @dev get the required fee for the released token bonus in the utility token
1112      * -------------------------------------------------------------------------------
1113      * param _user --> the address of the user
1114      * ----------------------------------------------------------
1115      * returns the fee amount in the utility token and Token
1116      */ 
1117     function _calculateTokenFee(uint _amount) internal view returns(uint uTokenFee, uint tokenFee) {
1118         
1119         uint fee = (_amount.mul(10)).div(100);
1120         uint feeInETH = _proportion(fee, address(token), address(weth));
1121         uint feeInUtoken = _proportion(feeInETH, address(weth), address(uToken));  
1122         
1123         return (feeInUtoken, fee);
1124     
1125     }
1126     
1127     /* 
1128      * @dev get the required fee for the released ETH bonus in the utility token
1129      * -------------------------------------------------------------------------------
1130      * param _user --> the address of the user
1131      * ----------------------------------------------------------
1132      * returns the fee amount in the utility token and ETH
1133      */ 
1134     function _calculateETHFee(uint _amount) internal view returns(uint uTokenFee, uint ethFee) {
1135         
1136         uint fee = (_amount.mul(10)).div(100);
1137         uint feeInUtoken = _proportion(fee, address(weth), address(uToken));  
1138         
1139         return (feeInUtoken, fee);
1140     }
1141     
1142     /* 
1143      * @dev get the required fee for the released ETH bonus   
1144      * -------------------------------------------------------------------------------
1145      * param _user --> the address of the user
1146      * ----------------------------------------------------------
1147      * returns the fee amount.
1148      */ 
1149     function calculateETHBonusFee(address _user) external view returns(uint ETH_Fee) {
1150         
1151         uint wethReleased = _calculateETHReleasedAmount(_user);
1152         
1153         if (wethReleased > 0) {
1154             
1155             (uint feeForWethInUtoken,) = _calculateETHFee(wethReleased);
1156 
1157             return feeForWethInUtoken;
1158             
1159         } else {
1160             
1161             return 0;
1162         }
1163             
1164     }
1165     
1166     /* 
1167      * @dev get the required fee for the released token bonus   
1168      * -------------------------------------------------------------------------------
1169      * param _user --> the address of the user
1170      * ----------------------------------------------------------
1171      * returns the fee amount.
1172      */ 
1173     function calculateTokenBonusFee(address _user) external view returns(uint token_Fee) {
1174         
1175         uint tokenReleased = _calculateTokenReleasedAmount(_user);
1176         
1177         if (tokenReleased > 0) {
1178             
1179             (uint feeForTokenInUtoken,) = _calculateTokenFee(tokenReleased);
1180             
1181             return feeForTokenInUtoken;
1182             
1183         } else {
1184             
1185             return 0;
1186         }
1187     }
1188     
1189     /* 
1190      * @dev get the bonus based on the return percentage for a particular locking term.   
1191      * -------------------------------------------------------------------------------
1192      * param _amount           --> the amount to calculate bonus from.
1193      * param _returnPercentage --> the returnPercentage of the term.
1194      * ----------------------------------------------------------
1195      * returns the bonus amount.
1196      */ 
1197     function _calculateBonus(uint _amount, uint _returnPercentage) internal pure returns(uint) {
1198         
1199         return ((_amount.mul(_returnPercentage)).div(100000)) / 2;                                  //  1% = 1000
1200     }
1201     
1202     /* 
1203      * @dev get the correct return percentage based on locked term.   
1204      * -----------------------------------------------------------
1205      * @param _token --> associated asset.
1206      * @param _term --> the locking term.
1207      * ----------------------------------------------------------
1208      * returns the return percentage.
1209      */   
1210     function _calculateReturnPercentage(IERC20 _token, uint _term) internal view returns(uint) {
1211         
1212         if (_token == weth) {
1213             if (_term == period1) { 
1214                 return period1RPWeth;
1215             } else if (_term == period2) { 
1216                 return period2RPWeth;
1217             } else if (_term == period3) { 
1218                 return period3RPWeth;
1219             } else if (_term == period4) { 
1220                 return period4RPWeth;
1221             } else {
1222                 return 0;
1223             }
1224         } else if (_token == token) {
1225             if (_term == period1) { 
1226                 return period1RPToken;
1227             } else if (_term == period2) { 
1228                 return period2RPToken;
1229             } else if (_term == period3) { 
1230                 return period3RPToken;
1231             } else if (_term == period4) { 
1232                 return period4RPToken;
1233             } else {
1234                 return 0;
1235             }
1236         }
1237             
1238     }
1239     
1240     /* 
1241      * @dev check whether the input locking term is one of the supported terms.  
1242      * ----------------------------------------------------------------------
1243      * @param _term --> the locking term.
1244      * -------------------------------
1245      * returns whether true or not.
1246      */   
1247     function _isValidTerm(uint _term) internal view returns(bool) {
1248         
1249         if (_term == period1
1250             || _term == period2
1251             || _term == period3
1252             || _term == period4) 
1253         {
1254             return true;
1255         } else {
1256             return false;
1257         }
1258     }
1259     
1260     /* 
1261      * @dev get the amount ETH and Token liquidity provided by the user.   
1262      * ------------------------------------------------------------------
1263      * @param _user --> the address of the user.
1264      * ---------------------------------------
1265      * returns the amount of ETH and Token liquidity provided.
1266      */   
1267     function getUserLiquidity(address _user) public view returns(uint provided_ETH, uint provided_token) {
1268         
1269         uint total = lpToken.totalSupply();
1270         uint ratio = ((_users[_user].liquidity).mul(scalar)).div(total);
1271         uint tokenHeld = token.balanceOf(address(lpToken));
1272         uint wethHeld = weth.balanceOf(address(lpToken));
1273         
1274         return ((ratio.mul(wethHeld)).div(scalar), (ratio.mul(tokenHeld)).div(scalar));
1275     }
1276     
1277     /* 
1278      * @dev check whether the inputted user address has been migrated.  
1279      * ----------------------------------------------------------------------
1280      * @param _user --> ddress of the user
1281      * ---------------------------------------
1282      * returns whether true or not.
1283      */  
1284     function getUserMigration(address _user) public view returns (bool) {
1285         return _users[_user].migrated;
1286     }
1287     
1288     /* 
1289      * @dev check whether the inputted user token has currently offers bonus  
1290      * ----------------------------------------------------------------------
1291      * @param _token --> associated token
1292      * ---------------------------------------
1293      * returns whether true or not.
1294      */  
1295     function _offersBonus(IERC20 _token) internal view returns (bool) {
1296         
1297         uint wethRPTotal = period1RPWeth.add(period2RPWeth).add(period3RPWeth).add(period4RPWeth);
1298         uint tokenRPTotal = period1RPToken.add(period2RPToken).add(period3RPToken).add(period4RPToken);
1299         
1300         if (_token == weth) {
1301             if (wethRPTotal > 0) {
1302                 return true;
1303             } else {
1304                 return false;
1305             }
1306             
1307         } else if (_token == token) {
1308             if (tokenRPTotal > 0) {
1309                 return true;
1310             } else {
1311                 return false;
1312             }
1313             
1314         }
1315     }
1316     
1317     /* 
1318      * @dev check whether the pool has sufficient amount of bonuses available for new deposits/stakes.   
1319      * ----------------------------------------------------------------------------------------------
1320      * @param amount --> the _amount to be evaluated against.
1321      * ---------------------------------------------------
1322      * returns whether true or not.
1323      */ 
1324     function _checkForSufficientStakingBonusesForETH(uint _amount) internal view returns(bool) {
1325         
1326         if ((address(this).balance).sub(_pendingBonusesWeth) >= _amount) {
1327             return true;
1328         } else {
1329             return false;
1330         }
1331     }
1332     
1333     /* 
1334      * @dev check whether the pool has sufficient amount of bonuses available for new deposits/stakes.   
1335      * ----------------------------------------------------------------------------------------------
1336      * @param amount --> the _amount to be evaluated against.
1337      * ---------------------------------------------------
1338      * returns whether true or not.
1339      */ 
1340     function _checkForSufficientStakingBonusesForToken(uint _amount) internal view returns(bool) {
1341        
1342         if ((token.balanceOf(address(this)).sub(_pendingBonusesToken)) >= _amount) {
1343             
1344             return true;
1345             
1346         } else {
1347             
1348             return false;
1349         }
1350     }
1351     
1352     /* 
1353      * @dev get the timestamp of when the user balance will be released from locked term. 
1354      * ---------------------------------------------------------------------------------
1355      * @param _user --> the address of the user.
1356      * ---------------------------------------
1357      * returns the timestamp for the release.
1358      */     
1359     function getUserRelease(address _user) external view returns(uint release_time) {
1360         
1361         uint release = _users[_user].release;
1362         if (release > now) {
1363             
1364             return (release.sub(now));
1365        
1366         } else {
1367             
1368             return 0;
1369         }
1370         
1371     }
1372     
1373     /* 
1374      * @dev get the amount of bonuses rewarded from staking to a user.   
1375      * --------------------------------------------------------------
1376      * @param _user --> the address of the user.
1377      * ---------------------------------------
1378      * returns the amount of staking bonuses.
1379      */  
1380     function getUserBonusPending(address _user) public view returns(uint ETH_bonus, uint token_bonus) {
1381         
1382         uint takenWeth = _users[_user].wethWithdrawn;
1383         uint takenToken = _users[_user].tokenWithdrawn;
1384         
1385         return (_users[_user].wethBonus.sub(takenWeth), _users[_user].tokenBonus.sub(takenToken));
1386     }
1387     
1388     /* 
1389      * @dev get the amount of released bonuses rewarded from staking to a user.   
1390      * --------------------------------------------------------------
1391      * @param _user --> the address of the user.
1392      * ---------------------------------------
1393      * returns the amount of released staking bonuses.
1394      */  
1395     function getUserBonusAvailable(address _user) public view returns(uint ETH_Released, uint token_Released) {
1396         
1397         uint ETHValue = _calculateETHReleasedAmount(_user);
1398         uint tokenValue = _calculateTokenReleasedAmount(_user);
1399         
1400         return (ETHValue, tokenValue);
1401     }   
1402     
1403     /* 
1404      * @dev get the amount of liquidity pool tokens staked/locked by user.   
1405      * ------------------------------------------------------------------
1406      * @param _user --> the address of the user.
1407      * ---------------------------------------
1408      * returns the amount of locked liquidity.
1409      */   
1410     function getUserLPTokens(address _user) external view returns(uint user_LP) {
1411 
1412         return _users[_user].liquidity;
1413     }
1414     
1415     /* 
1416      * @dev get the lp token address for the pair.  
1417      * -----------------------------------------------------------
1418      * returns the lp address for eth/token pair.
1419      */ 
1420     function getLPAddress() external view returns(address) {
1421         return address(lpToken);
1422     }
1423     
1424     /* 
1425      * @dev get the amount of staking bonuses available in the pool.  
1426      * -----------------------------------------------------------
1427      * returns the amount of staking bounses available for ETH and Token.
1428      */ 
1429     function getAvailableBonus() external view returns(uint available_ETH, uint available_token) {
1430         
1431         available_ETH = (address(this).balance).sub(_pendingBonusesWeth);
1432         available_token = (token.balanceOf(address(this))).sub(_pendingBonusesToken);
1433         
1434         return (available_ETH, available_token);
1435     }
1436     
1437     /* 
1438      * @dev get the maximum amount of ETH allowed for provisioning.  
1439      * -----------------------------------------------------------
1440      * returns the amaximum ETH allowed
1441      */ 
1442     function getCap() external view returns(uint maxETH) {
1443         
1444         return cap;
1445     }
1446     
1447     /* 
1448      * @dev checks the term period and return percentages 
1449      * --------------------------------------------------
1450      * returns term period and return percentages 
1451      */
1452     function getTermPeriodAndReturnPercentages() external view returns(
1453         uint Term_Period_1, uint Term_Period_2, uint Term_Period_3, uint Term_Period_4,
1454         uint Period_1_Return_Percentage_Token, uint Period_2_Return_Percentage_Token,
1455         uint Period_3_Return_Percentage_Token, uint Period_4_Return_Percentage_Token,
1456         uint Period_1_Return_Percentage_ETH, uint Period_2_Return_Percentage_ETH,
1457         uint Period_3_Return_Percentage_ETH, uint Period_4_Return_Percentage_ETH
1458     ) {
1459         
1460         return (
1461             period1, period2, period3, period4, period1RPToken, period2RPToken, period3RPToken, 
1462             period4RPToken,period1RPWeth, period2RPWeth, period3RPWeth, period4RPWeth);
1463     }
1464     
1465 }