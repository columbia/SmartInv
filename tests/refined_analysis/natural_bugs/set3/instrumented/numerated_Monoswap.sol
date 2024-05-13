1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 import "./openzeppelin/contracts/token/ERC1155/ERC1155.sol";
5 import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
6 import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "./openzeppelin/contracts/math/SafeMath.sol";
8 import "./openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
9 import "./openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
10 // import "hardhat/consolse.sol";
11 import "./libraries/IMonoXPool.sol";
12 import "./libraries/IWETH.sol";
13 import "./libraries/MonoXLibrary.sol";
14 
15 interface IvUSD is IERC20 {
16   function mint (address account, uint256 amount) external;
17 
18   function burn (address account, uint256 amount) external;
19 }
20 
21 
22 /**
23  * The Monoswap is ERC1155 contract does this and that...
24  */
25 contract Monoswap is Initializable, OwnableUpgradeable {
26   using SafeMath for uint256;
27   using SafeERC20 for IERC20;
28   using SafeERC20 for IvUSD;
29 
30   IvUSD vUSD;
31   address WETH;
32   address feeTo;
33   uint16 fees; // over 1e5, 300 means 0.3%
34   uint16 devFee; // over 1e5, 50 means 0.05%
35 
36   uint256 constant MINIMUM_LIQUIDITY=100;
37   
38 
39   struct PoolInfo {
40     uint256 pid;
41     uint256 lastPoolValue;
42     address token;
43     PoolStatus status;
44     uint112 vusdDebt;
45     uint112 vusdCredit;
46     uint112 tokenBalance;
47     uint112 price; // over 1e18
48   }
49 
50   enum TxType {
51     SELL,
52     BUY
53   }
54 
55   enum PoolStatus {
56     UNLISTED,
57     LISTED,
58     OFFICIAL,
59     SYNTHETIC,
60     PAUSED
61   }
62   
63   mapping (address => PoolInfo) public pools;
64   // tokenStatus is for token lock/transfer. exempt means no need to verify post tx
65   mapping (address => uint8) private tokenStatus; //0=unlocked, 1=locked, 2=exempt
66 
67   // token poool status is to track if the pool has already been created for the token
68   mapping (address => uint8) public tokenPoolStatus; //0=undefined, 1=exists
69   
70   // negative vUSD balance allowed for each token
71   mapping (address => uint) public tokenInsurance;
72 
73   uint256 public poolSize;
74 
75   uint private unlocked;
76   modifier lock() {
77     require(unlocked == 1, 'MonoX:LOCKED');
78     unlocked = 0;
79     _;
80     unlocked = 1;
81   }
82 
83   modifier lockToken(address _token) { 
84     uint8 originalState = tokenStatus[_token];
85     require(originalState!=1, 'MonoX:POOL_LOCKED');
86     if(originalState==0) {
87       tokenStatus[_token] = 1;
88     }
89     _;
90     if(originalState==0) {
91       tokenStatus[_token] = 0;
92     }
93   }
94 
95   modifier ensure(uint deadline) {
96     require(deadline >= block.timestamp, 'MonoX:EXPIRED');
97     _;
98   }  
99 
100   modifier onlySyntheticPool(address _token){
101     require(pools[_token].status==PoolStatus.SYNTHETIC,"MonoX:NOT_SYNT");
102     _;
103   }
104 
105   modifier onlyPriceAdjuster(){
106     require(priceAdjusterRole[msg.sender]==true,"MonoX:BAD_ROLE");
107     _;
108   }
109 
110   event AddLiquidity(address indexed provider, 
111     uint indexed pid,
112     address indexed token,
113     uint liquidityAmount,
114     uint vusdAmount, uint tokenAmount);
115 
116   event RemoveLiquidity(address indexed provider, 
117     uint indexed pid,
118     address indexed token,
119     uint liquidityAmount,
120     uint vusdAmount, uint tokenAmount);
121 
122   event Swap(
123     address indexed user,
124     address indexed tokenIn,
125     address indexed tokenOut,
126     uint amountIn,
127     uint amountOut
128   );
129 
130   // event PriceAdjusterChanged(
131   //   address indexed priceAdjuster,
132   //   bool added
133   // );
134 
135   event PoolBalanced(
136     address _token,
137     uint vusdIn
138   );
139 
140   event SyntheticPoolPriceChanged(
141     address _token,
142     uint112 price
143   );
144 
145   event PoolStatusChanged(
146     address _token,
147     PoolStatus oldStatus,
148     PoolStatus newStatus
149   );
150 
151   IMonoXPool public monoXPool;
152   
153   // mapping (token address => block number of the last trade)
154   mapping (address => uint) public lastTradedBlock; 
155 
156   uint256 constant MINIMUM_POOL_VALUE = 10000 * 1e18;
157   mapping (address=>bool) public priceAdjusterRole;
158 
159   // ------------
160   uint public poolSizeMinLimit;
161 
162   function initialize(IMonoXPool _monoXPool, IvUSD _vusd) public initializer {
163     OwnableUpgradeable.__Ownable_init();
164     monoXPool = _monoXPool;
165     vUSD = _vusd;
166     WETH = _monoXPool.getWETHAddr();
167 
168     fees = 300;
169     devFee = 50;
170     poolSize = 0;
171     unlocked = 1;
172   }
173 
174   // receive() external payable {
175   //   assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
176   // }
177 
178   function setFeeTo (address _feeTo) onlyOwner external {
179     feeTo = _feeTo;
180   }
181   
182   function setFees (uint16 _fees) onlyOwner external {
183     require(_fees<1e3);
184     fees = _fees;
185   }
186 
187   function setDevFee (uint16 _devFee) onlyOwner external {
188     require(_devFee<1e3);
189     devFee = _devFee;
190   }
191 
192   function setPoolSizeMinLimit(uint _poolSizeMinLimit) onlyOwner external {
193     poolSizeMinLimit = _poolSizeMinLimit;
194   }
195 
196   function setTokenInsurance (address _token, uint _insurance) onlyOwner external {
197     tokenInsurance[_token] = _insurance;
198   }
199 
200   // when safu, setting token status to 2 can achieve significant gas savings 
201   function setTokenStatus (address _token, uint8 _status) onlyOwner external {
202     tokenStatus[_token] = _status;
203   } 
204   
205 
206   // update status of a pool. onlyOwner.
207   function updatePoolStatus(address _token, PoolStatus _status) external onlyOwner {    
208 
209     PoolStatus poolStatus = pools[_token].status;
210     if(poolStatus==PoolStatus.PAUSED){
211       require(block.number > lastTradedBlock[_token].add(6000), "MonoX:TOO_EARLY");
212     }
213     else{
214       // okay to pause an official pool, wait 6k blocks and then convert it to synthetic
215       require(_status!=PoolStatus.SYNTHETIC,"MonoX:NO_SYNT");
216     }
217       
218     emit PoolStatusChanged(_token, poolStatus,_status);
219     pools[_token].status = _status;
220 
221     // unlisting a token allows creating a new pool of the same token. 
222     // should move it to PAUSED if the goal is to blacklist the token forever
223     if(_status==PoolStatus.UNLISTED) {
224       tokenPoolStatus[_token] = 0;
225     }
226   }
227   
228   /**
229     @dev update pools price if there were no active trading for the last 6000 blocks
230     @notice Only owner callable, new price can neither be 0 nor be equal to old one
231     @param _token pool identifider (token address)
232     @param _newPrice new price in wei (uint112)
233    */
234   function updatePoolPrice(address _token, uint112 _newPrice) external onlyOwner {
235     require(_newPrice > 0, 'MonoX:0_PRICE');
236     require(tokenPoolStatus[_token] != 0, "MonoX:NO_POOL");
237 
238     require(block.number > lastTradedBlock[_token].add(6000), "MonoX:TOO_EARLY");
239     pools[_token].price = _newPrice;
240     lastTradedBlock[_token] = block.number;
241   }
242 
243   function updatePriceAdjuster(address account, bool _status) external onlyOwner{
244     priceAdjusterRole[account]=_status;
245     //emit PriceAdjusterChanged(account,_status);
246   }
247 
248   function setPoolPrice(address _token, uint112 price) external onlyPriceAdjuster onlySyntheticPool(_token){
249     pools[_token].price=price;
250     emit SyntheticPoolPriceChanged(_token,price);
251   }
252 
253   function rebalancePool(address _token,uint256 vusdIn) external lockToken(_token) onlyOwner{
254       // PoolInfo memory pool = pools[_token];
255       uint poolPrice = pools[_token].price;
256       require(vusdIn <= pools[_token].vusdDebt,"MonoX:NO_CREDIT");
257       require(pools[_token].tokenBalance * poolPrice >= vusdIn,"MonoX:INSUF_TOKEN_VAL");
258       // uint rebalancedAmount = vusdIn.mul(1e18).div(pool.price);
259       monoXPool.safeTransferERC20Token(_token, msg.sender, vusdIn.mul(1e18).div(poolPrice));
260       _syncPoolInfo(_token, vusdIn, 0);
261       emit PoolBalanced(_token, vusdIn);
262   }
263 
264   // creates a pool
265   function _createPool (address _token, uint112 _price, PoolStatus _status) lock internal returns(uint256 _pid)  {
266     require(tokenPoolStatus[_token]==0, "MonoX:POOL_EXISTS");
267     require (_token != address(vUSD), "MonoX:NO_vUSD");
268     _pid = poolSize;
269     pools[_token] = PoolInfo({
270       token: _token,
271       pid: _pid,
272       vusdCredit: 0,
273       vusdDebt: 0,
274       tokenBalance: 0,
275       lastPoolValue: 0,
276       status: _status,
277       price: _price
278     });
279 
280     poolSize = _pid.add(1);
281     tokenPoolStatus[_token]=1;
282 
283     // initialze pool's lasttradingblocknumber as the block number on which the pool is created
284     lastTradedBlock[_token] = block.number;
285   }
286 
287   // creates a pool with special status
288   function addSpecialToken (address _token, uint112 _price, PoolStatus _status) onlyOwner external returns(uint256 _pid)  {
289     _pid = _createPool(_token, _price, _status);
290   }
291 
292   // internal func to pay contract owner
293   function _mintFee (uint256 pid, uint256 lastPoolValue, uint256 newPoolValue) internal {
294     
295     // uint256 _totalSupply = monoXPool.totalSupplyOf(pid);
296     if(newPoolValue>lastPoolValue && lastPoolValue>0) {
297       // safe ops, since newPoolValue>lastPoolValue
298       uint256 deltaPoolValue = newPoolValue - lastPoolValue; 
299       // safe ops, since newPoolValue = deltaPoolValue + lastPoolValue > deltaPoolValue
300       uint256 devLiquidity = monoXPool.totalSupplyOf(pid).mul(deltaPoolValue).mul(devFee).div(newPoolValue-deltaPoolValue)/1e5;
301       monoXPool.mint(feeTo, pid, devLiquidity);
302     }
303     
304   }
305 
306   // util func to get some basic pool info
307   function getPool (address _token) view public returns (uint256 poolValue, 
308     uint256 tokenBalanceVusdValue, uint256 vusdCredit, uint256 vusdDebt) {
309     // PoolInfo memory pool = pools[_token];
310     vusdCredit = pools[_token].vusdCredit;
311     vusdDebt = pools[_token].vusdDebt;
312     tokenBalanceVusdValue = uint(pools[_token].price).mul(pools[_token].tokenBalance)/1e18;
313 
314     poolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
315   }
316 
317   // trustless listing pool creation. always creates unofficial pool
318   function listNewToken (address _token, uint112 _price, 
319     uint256 vusdAmount, 
320     uint256 tokenAmount,
321     address to) external returns(uint _pid, uint256 liquidity) {
322     _pid = _createPool(_token, _price, PoolStatus.LISTED);
323     liquidity = _addLiquidityPair(_token, vusdAmount, tokenAmount, msg.sender, to);
324   }
325 
326   // add liquidity pair to a pool. allows adding vusd.
327   function addLiquidityPair (address _token, 
328     uint256 vusdAmount, 
329     uint256 tokenAmount,
330     address to) external returns(uint256 liquidity) {
331     liquidity = _addLiquidityPair(_token, vusdAmount, tokenAmount, msg.sender, to);
332   }
333 
334     // add liquidity pair to a pool. allows adding vusd.
335   function _addLiquidityPair (address _token, 
336     uint256 vusdAmount, 
337     uint256 tokenAmount,
338     address from,
339     address to) internal lockToken(_token) returns(uint256 liquidity) {
340     require (tokenAmount>0, "MonoX:BAD_AMOUNT");
341 
342     require(tokenPoolStatus[_token]==1, "MonoX:NO_POOL");
343 
344     // (uint256 poolValue, , ,) = getPool(_token);
345     PoolInfo memory pool = pools[_token];
346 
347     uint256 poolValue = uint(pool.price).mul(pool.tokenBalance)/1e18;
348     poolValue = poolValue.add(pool.vusdCredit).sub(pool.vusdDebt);
349 
350     IMonoXPool monoXPoolLocal = monoXPool;
351     
352     _mintFee(pool.pid, pool.lastPoolValue, poolValue);
353 
354     tokenAmount = transferAndCheck(from,address(monoXPoolLocal),_token,tokenAmount);
355 
356     if(vusdAmount>0){
357       vUSD.safeTransferFrom(msg.sender, address(monoXPoolLocal), vusdAmount);
358       vUSD.burn(address(monoXPool), vusdAmount);
359     }
360 
361     // this is to avoid stack too deep
362     {
363       uint256 _totalSupply = monoXPoolLocal.totalSupplyOf(pool.pid);
364       uint256 liquidityVusdValue = vusdAmount.add(tokenAmount.mul(pool.price)/1e18);
365 
366       if(_totalSupply==0){
367         liquidity = liquidityVusdValue.sub(MINIMUM_LIQUIDITY);
368         // sorry, oz doesn't allow minting to address(0)
369         monoXPoolLocal.mint(feeTo, pool.pid, MINIMUM_LIQUIDITY); 
370       }else{
371         liquidity = _totalSupply.mul(liquidityVusdValue).div(poolValue);
372       }
373     }
374 
375     monoXPoolLocal.mint(to, pool.pid, liquidity);
376     _syncPoolInfo(_token, vusdAmount, 0);
377 
378     emit AddLiquidity(to, 
379     pool.pid,
380     _token,
381     liquidity, 
382     vusdAmount, tokenAmount);
383   }
384   
385   // add one-sided liquidity to a pool. no vusd
386   function addLiquidity (address _token, uint256 _amount, address to) external returns(uint256 liquidity)  {
387     liquidity = _addLiquidityPair(_token, 0, _amount, msg.sender, to);
388   }  
389 
390   // add one-sided ETH liquidity to a pool. no vusd
391   function addLiquidityETH (address to) external payable returns(uint256 liquidity)  {
392     MonoXLibrary.safeTransferETH(address(monoXPool), msg.value);
393     monoXPool.depositWETH(msg.value);
394     liquidity = _addLiquidityPair(WETH, 0, msg.value, address(this), to);
395   }  
396 
397   // updates pool vusd balance, token balance and last pool value.
398   // this function requires others to do the input validation
399   function _syncPoolInfo (address _token, uint256 vusdIn, uint256 vusdOut) internal returns(uint256 poolValue, 
400     uint256 tokenBalanceVusdValue, uint256 vusdCredit, uint256 vusdDebt) {
401     // PoolInfo memory pool = pools[_token];
402     uint256 tokenPoolPrice = pools[_token].price;
403     (vusdCredit, vusdDebt) = _updateVusdBalance(_token, vusdIn, vusdOut);
404 
405     uint256 tokenReserve = IERC20(_token).balanceOf(address(monoXPool));
406     tokenBalanceVusdValue = tokenPoolPrice.mul(tokenReserve)/1e18;
407 
408     require(tokenReserve <= uint112(-1));
409     pools[_token].tokenBalance = uint112(tokenReserve);
410     // poolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
411     pools[_token].lastPoolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
412   }
413   
414   // view func for removing liquidity
415   function _removeLiquidity (address _token, uint256 liquidity,
416     address to) view public returns(
417     uint256 poolValue, uint256 liquidityIn, uint256 vusdOut, uint256 tokenOut) {
418     
419     require (liquidity>0, "MonoX:BAD_AMOUNT");
420     uint256 tokenBalanceVusdValue;
421     uint256 vusdCredit;
422     uint256 vusdDebt;
423     PoolInfo memory pool = pools[_token];
424     (poolValue, tokenBalanceVusdValue, vusdCredit, vusdDebt) = getPool(_token);
425     uint256 _totalSupply = monoXPool.totalSupplyOf(pool.pid);
426 
427     liquidityIn = monoXPool.balanceOf(to, pool.pid)>liquidity?liquidity:monoXPool.balanceOf(to, pool.pid);
428     uint256 tokenReserve = IERC20(_token).balanceOf(address(monoXPool));
429     
430     if(tokenReserve < pool.tokenBalance){
431       tokenBalanceVusdValue = tokenReserve.mul(pool.price)/1e18;
432     }
433 
434     if(vusdDebt>0){
435       tokenReserve = (tokenBalanceVusdValue.sub(vusdDebt)).mul(1e18).div(pool.price);
436     }
437 
438     // if vusdCredit==0, vusdOut will be 0 as well
439     vusdOut = liquidityIn.mul(vusdCredit).div(_totalSupply);
440 
441     tokenOut = liquidityIn.mul(tokenReserve).div(_totalSupply);
442 
443   }
444   
445   // actually removes liquidity
446   function removeLiquidity (address _token, uint256 liquidity, address to, 
447     uint256 minVusdOut, 
448     uint256 minTokenOut) external returns(uint256 vusdOut, uint256 tokenOut)  {
449     (vusdOut, tokenOut) = _removeLiquidityHelper (_token, liquidity, to, minVusdOut, minTokenOut, false);
450   }
451 
452   // actually removes liquidity
453   function _removeLiquidityHelper (address _token, uint256 liquidity, address to, 
454     uint256 minVusdOut, 
455     uint256 minTokenOut,
456     bool isETH) lockToken(_token) internal returns(uint256 vusdOut, uint256 tokenOut)  {
457     require (tokenPoolStatus[_token]==1, "MonoX:NO_TOKEN");
458     PoolInfo memory pool = pools[_token];
459     uint256 poolValue;
460     uint256 liquidityIn;
461     (poolValue, liquidityIn, vusdOut, tokenOut) = _removeLiquidity(_token, liquidity, to);
462     _mintFee(pool.pid, pool.lastPoolValue, poolValue);
463     require (vusdOut>=minVusdOut, "MonoX:INSUFF_vUSD");
464     require (tokenOut>=minTokenOut, "MonoX:INSUFF_TOKEN");
465 
466     if (vusdOut>0){
467       vUSD.mint(to, vusdOut);
468     }
469     if (!isETH) {
470       monoXPool.safeTransferERC20Token(_token, to, tokenOut);
471     } else {
472       monoXPool.withdrawWETH(tokenOut);
473       monoXPool.safeTransferETH(to, tokenOut);
474     }
475 
476     monoXPool.burn(to, pool.pid, liquidityIn);
477 
478     _syncPoolInfo(_token, 0, vusdOut);
479 
480     emit RemoveLiquidity(to, 
481       pool.pid,
482       _token,
483       liquidityIn, 
484       vusdOut, tokenOut);
485   }
486 
487   // actually removes ETH liquidity
488   function removeLiquidityETH (uint256 liquidity, address to, 
489     uint256 minVusdOut, 
490     uint256 minTokenOut) external returns(uint256 vusdOut, uint256 tokenOut)  {
491 
492     (vusdOut, tokenOut) = _removeLiquidityHelper (WETH, liquidity, to, minVusdOut, minTokenOut, true);
493   }
494 
495   // util func to compute new price
496   function _getNewPrice (uint256 originalPrice, uint256 reserve, 
497     uint256 delta, TxType txType) pure internal returns(uint256 price) {
498     if(txType==TxType.SELL) {
499       // no risk of being div by 0
500       price = originalPrice.mul(reserve)/(reserve.add(delta));
501     }else{ // BUY
502       price = originalPrice.mul(reserve).div(reserve.sub(delta));
503     }
504   }
505 
506   // util func to compute new price
507   function _getAvgPrice (uint256 originalPrice, uint256 newPrice) pure internal returns(uint256 price) {
508     price = originalPrice.add(newPrice.mul(4))/5;
509   }
510 
511   // standard swap interface implementing uniswap router V2
512   
513   function swapExactETHForToken(
514     address tokenOut,
515     uint amountOutMin,
516     address to,
517     uint deadline
518   ) external virtual payable ensure(deadline) returns (uint amountOut) {
519     uint amountIn = msg.value;
520     MonoXLibrary.safeTransferETH(address(monoXPool), amountIn);
521     monoXPool.depositWETH(amountIn);
522     amountOut = swapIn(WETH, tokenOut, address(this), to, amountIn);
523     require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
524   }
525   
526   function swapExactTokenForETH(
527     address tokenIn,
528     uint amountIn,
529     uint amountOutMin,
530     address to,
531     uint deadline
532   ) external virtual ensure(deadline) returns (uint amountOut) {
533     IMonoXPool monoXPoolLocal = monoXPool;
534     amountOut = swapIn(tokenIn, WETH, msg.sender, address(monoXPoolLocal), amountIn);
535     require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
536     monoXPoolLocal.withdrawWETH(amountOut);
537     monoXPoolLocal.safeTransferETH(to, amountOut);
538   }
539 
540   function swapETHForExactToken(
541     address tokenOut,
542     uint amountInMax,
543     uint amountOut,
544     address to,
545     uint deadline
546   ) external virtual payable ensure(deadline) returns (uint amountIn) {
547     uint amountSentIn = msg.value;
548     ( , , amountIn, ) = getAmountIn(WETH, tokenOut, amountOut);
549     MonoXLibrary.safeTransferETH(address(monoXPool), amountIn);
550     monoXPool.depositWETH(amountIn);
551     amountIn = swapOut(WETH, tokenOut, address(this), to, amountOut);
552     require(amountIn <= amountSentIn, 'MonoX:BAD_INPUT');
553     require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
554     if (amountSentIn > amountIn) {
555       MonoXLibrary.safeTransferETH(msg.sender, amountSentIn.sub(amountIn));
556     }
557   }
558 
559   function swapTokenForExactETH(
560     address tokenIn,
561     uint amountInMax,
562     uint amountOut,
563     address to,
564     uint deadline
565   ) external virtual ensure(deadline) returns (uint amountIn) {
566     IMonoXPool monoXPoolLocal = monoXPool;
567     amountIn = swapOut(tokenIn, WETH, msg.sender, address(monoXPoolLocal), amountOut);
568     require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
569     monoXPoolLocal.withdrawWETH(amountOut);
570     monoXPoolLocal.safeTransferETH(to, amountOut);
571   }
572 
573   function swapExactTokenForToken(
574     address tokenIn,
575     address tokenOut,
576     uint amountIn,
577     uint amountOutMin,
578     address to,
579     uint deadline
580   ) external virtual ensure(deadline) returns (uint amountOut) {
581     amountOut = swapIn(tokenIn, tokenOut, msg.sender, to, amountIn);
582     require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
583   }
584 
585   function swapTokenForExactToken(
586     address tokenIn,
587     address tokenOut,
588     uint amountInMax,
589     uint amountOut,
590     address to,
591     uint deadline
592   ) external virtual ensure(deadline) returns (uint amountIn) {
593     amountIn = swapOut(tokenIn, tokenOut, msg.sender, to, amountOut);
594     require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
595   }
596 
597   // util func to manipulate vusd balance
598   function _updateVusdBalance (address _token, 
599     uint _vusdIn, uint _vusdOut) internal returns (uint _vusdCredit, uint _vusdDebt) {
600     if(_vusdIn>_vusdOut){
601       _vusdIn = _vusdIn - _vusdOut;
602       _vusdOut = 0;
603     }else{
604       _vusdOut = _vusdOut - _vusdIn;
605       _vusdIn = 0;
606     }
607 
608     // PoolInfo memory _pool = pools[_token];
609     uint _poolVusdCredit = pools[_token].vusdCredit;
610     uint _poolVusdDebt = pools[_token].vusdDebt;
611     PoolStatus _poolStatus = pools[_token].status;
612     
613     if(_vusdOut>0){
614       (_vusdCredit, _vusdDebt) = MonoXLibrary.vusdBalanceSub(
615         _poolVusdCredit, _poolVusdDebt, _vusdOut);
616       require(_vusdCredit <= uint112(-1) && _vusdDebt <= uint112(-1));
617       pools[_token].vusdCredit = uint112(_vusdCredit);
618       pools[_token].vusdDebt = uint112(_vusdDebt);
619     }
620 
621     if(_vusdIn>0){
622       (_vusdCredit, _vusdDebt) = MonoXLibrary.vusdBalanceAdd(
623         _poolVusdCredit, _poolVusdDebt, _vusdIn);
624       require(_vusdCredit <= uint112(-1) && _vusdDebt <= uint112(-1));
625       pools[_token].vusdCredit = uint112(_vusdCredit);
626       pools[_token].vusdDebt = uint112(_vusdDebt);
627     }
628 
629     if(_poolStatus == PoolStatus.LISTED){
630 
631       require (_vusdDebt<=tokenInsurance[_token], "MonoX:INSUFF_vUSD");
632     }
633   }
634   
635   // updates pool token balance and price.
636   function _updateTokenInfo (address _token, uint256 _price,
637       uint256 _vusdIn, uint256 _vusdOut, uint256 _ETHDebt) internal {
638     uint256 _balance = IERC20(_token).balanceOf(address(monoXPool));
639     _balance = _balance.sub(_ETHDebt);
640     require(pools[_token].status!=PoolStatus.PAUSED,"MonoX:PAUSED");
641     require(_price <= uint112(-1) && _balance <= uint112(-1));
642     (uint initialPoolValue, , ,) = getPool(_token);
643     pools[_token].tokenBalance = uint112(_balance);
644     pools[_token].price = uint112(_price);
645 
646     // record last trade's block number in mapping: lastTradedBlock
647     lastTradedBlock[_token] = block.number;
648 
649     _updateVusdBalance(_token, _vusdIn, _vusdOut);
650 
651     (uint poolValue, , ,) = getPool(_token);
652 
653     require(initialPoolValue <= poolValue || poolValue >= poolSizeMinLimit,
654       "MonoX:MIN_POOL_SIZE");
655     
656     
657   }
658 
659   function directSwapAllowed(uint tokenInPoolPrice,uint tokenOutPoolPrice, 
660                               uint tokenInPoolTokenBalance, uint tokenOutPoolTokenBalance, PoolStatus status, bool getsAmountOut) internal pure returns(bool){
661       uint tokenInValue  = tokenInPoolTokenBalance.mul(tokenInPoolPrice).div(1e18);
662       uint tokenOutValue = tokenOutPoolTokenBalance.mul(tokenOutPoolPrice).div(1e18);
663       bool priceExists   = getsAmountOut?tokenInPoolPrice>0:tokenOutPoolPrice>0;
664       
665       // only if it's official pool with similar size
666       return priceExists&&status==PoolStatus.OFFICIAL&&tokenInValue>0&&tokenOutValue>0&&
667         ((tokenInValue/tokenOutValue)+(tokenOutValue/tokenInValue)==1);
668         
669   }
670 
671   // view func to compute amount required for tokenIn to get fixed amount of tokenOut
672   function getAmountIn(address tokenIn, address tokenOut, 
673     uint256 amountOut) public view returns (uint256 tokenInPrice, uint256 tokenOutPrice, 
674     uint256 amountIn, uint256 tradeVusdValue) {
675     require(amountOut > 0, 'MonoX:INSUFF_INPUT');
676     
677     uint256 amountOutWithFee = amountOut.mul(1e5).div(1e5 - fees);
678     address vusdAddress = address(vUSD);
679     uint tokenOutPoolPrice = pools[tokenOut].price;
680     uint tokenOutPoolTokenBalance = pools[tokenOut].tokenBalance;
681     if(tokenOut==vusdAddress){
682       tradeVusdValue = amountOutWithFee;
683       tokenOutPrice = 1e18;
684     }else{
685       require (tokenPoolStatus[tokenOut]==1, "MonoX:NO_POOL");
686       // PoolInfo memory tokenOutPool = pools[tokenOut];
687       PoolStatus tokenOutPoolStatus = pools[tokenOut].status;
688       
689       require (tokenOutPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
690       tokenOutPrice = _getNewPrice(tokenOutPoolPrice, tokenOutPoolTokenBalance, 
691         amountOutWithFee, TxType.BUY);
692 
693       tradeVusdValue = _getAvgPrice(tokenOutPoolPrice, tokenOutPrice).mul(amountOutWithFee)/1e18;
694     }
695 
696     if(tokenIn==vusdAddress){
697       amountIn = tradeVusdValue;
698       tokenInPrice = 1e18;
699     }else{
700       require (tokenPoolStatus[tokenIn]==1, "MonoX:NO_POOL");
701       // PoolInfo memory tokenInPool = pools[tokenIn];
702       PoolStatus tokenInPoolStatus = pools[tokenIn].status;
703       uint tokenInPoolPrice = pools[tokenIn].price;
704       uint tokenInPoolTokenBalance = pools[tokenIn].tokenBalance;
705       require (tokenInPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
706 
707       amountIn = tradeVusdValue.add(tokenInPoolTokenBalance.mul(tokenInPoolPrice).div(1e18));
708       amountIn = tradeVusdValue.mul(tokenInPoolTokenBalance).div(amountIn);
709 
710 
711       bool allowDirectSwap=directSwapAllowed(tokenInPoolPrice,tokenOutPoolPrice,tokenInPoolTokenBalance,tokenOutPoolTokenBalance,tokenInPoolStatus,false);
712 
713       // assuming p1*p2 = k, equivalent to uniswap's x * y = k
714       uint directSwapTokenInPrice = allowDirectSwap?tokenOutPoolPrice.mul(tokenInPoolPrice).div(tokenOutPrice):1;
715 
716       tokenInPrice = _getNewPrice(tokenInPoolPrice, tokenInPoolTokenBalance, 
717         amountIn, TxType.SELL);
718 
719       tokenInPrice = directSwapTokenInPrice > tokenInPrice?directSwapTokenInPrice:tokenInPrice;
720 
721       amountIn = tradeVusdValue.mul(1e18).div(_getAvgPrice(tokenInPoolPrice, tokenInPrice));
722     }
723   }
724 
725   // view func to compute amount required for tokenOut to get fixed amount of tokenIn
726   function getAmountOut(address tokenIn, address tokenOut, 
727     uint256 amountIn) public view returns (uint256 tokenInPrice, uint256 tokenOutPrice, 
728     uint256 amountOut, uint256 tradeVusdValue) {
729     require(amountIn > 0, 'MonoX:INSUFF_INPUT');
730     
731     uint256 amountInWithFee = amountIn.mul(1e5-fees)/1e5;
732     address vusdAddress = address(vUSD);
733     uint tokenInPoolPrice = pools[tokenIn].price;
734     uint tokenInPoolTokenBalance = pools[tokenIn].tokenBalance;
735 
736     if(tokenIn==vusdAddress){
737       tradeVusdValue = amountInWithFee;
738       tokenInPrice = 1e18;
739     }else{
740       require (tokenPoolStatus[tokenIn]==1, "MonoX:NO_POOL");
741       // PoolInfo memory tokenInPool = pools[tokenIn];
742       PoolStatus tokenInPoolStatus = pools[tokenIn].status;
743       
744       require (tokenInPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
745       
746       tokenInPrice = _getNewPrice(tokenInPoolPrice, tokenInPoolTokenBalance, 
747         amountInWithFee, TxType.SELL);
748       tradeVusdValue = _getAvgPrice(tokenInPoolPrice, tokenInPrice).mul(amountInWithFee)/1e18;
749     }
750 
751     if(tokenOut==vusdAddress){
752       amountOut = tradeVusdValue;
753       tokenOutPrice = 1e18;
754     }else{
755       require (tokenPoolStatus[tokenOut]==1, "MonoX:NO_POOL");
756       // PoolInfo memory tokenOutPool = pools[tokenOut];
757       PoolStatus tokenOutPoolStatus = pools[tokenOut].status;
758       uint tokenOutPoolPrice = pools[tokenOut].price;
759       uint tokenOutPoolTokenBalance = pools[tokenOut].tokenBalance;
760 
761       require (tokenOutPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
762       
763       amountOut = tradeVusdValue.add(tokenOutPoolTokenBalance.mul(tokenOutPoolPrice).div(1e18));
764       amountOut = tradeVusdValue.mul(tokenOutPoolTokenBalance).div(amountOut);
765 
766       bool allowDirectSwap=directSwapAllowed(tokenInPoolPrice,tokenOutPoolPrice,tokenInPoolTokenBalance,tokenOutPoolTokenBalance,tokenOutPoolStatus,true);
767 
768       // assuming p1*p2 = k, equivalent to uniswap's x * y = k
769       uint directSwapTokenOutPrice = allowDirectSwap?tokenInPoolPrice.mul(tokenOutPoolPrice).div(tokenInPrice):uint(-1);
770 
771       // prevent the attack where user can use a small pool to update price in a much larger pool
772       tokenOutPrice = _getNewPrice(tokenOutPoolPrice, tokenOutPoolTokenBalance, 
773         amountOut, TxType.BUY);
774       tokenOutPrice = directSwapTokenOutPrice < tokenOutPrice?directSwapTokenOutPrice:tokenOutPrice;
775 
776       amountOut = tradeVusdValue.mul(1e18).div(_getAvgPrice(tokenOutPoolPrice, tokenOutPrice));
777     }
778   }
779 
780 
781   // swap from tokenIn to tokenOut with fixed tokenIn amount.
782   function swapIn (address tokenIn, address tokenOut, address from, address to,
783       uint256 amountIn) internal lockToken(tokenIn) returns(uint256 amountOut)  {
784 
785     address monoXPoolLocal = address(monoXPool);
786 
787     amountIn = transferAndCheck(from,monoXPoolLocal,tokenIn,amountIn); 
788     
789     // uint256 halfFeesInTokenIn = amountIn.mul(fees)/2e5;
790 
791     uint256 tokenInPrice;
792     uint256 tokenOutPrice;
793     uint256 tradeVusdValue;
794     
795     (tokenInPrice, tokenOutPrice, amountOut, tradeVusdValue) = getAmountOut(tokenIn, tokenOut, amountIn);
796 
797     uint256 oneSideFeesInVusd = tokenInPrice.mul(amountIn.mul(fees)/2e5)/1e18;
798 
799     // trading in
800     if(tokenIn==address(vUSD)){
801       vUSD.burn(monoXPoolLocal, amountIn);
802       // all fees go to the other side
803       oneSideFeesInVusd = oneSideFeesInVusd.mul(2);
804     }else{
805       _updateTokenInfo(tokenIn, tokenInPrice, 0, tradeVusdValue.add(oneSideFeesInVusd), 0);
806     }
807 
808     // trading out
809     if(tokenOut==address(vUSD)){
810       vUSD.mint(to, amountOut);
811     }else{
812       if (to != monoXPoolLocal) {
813         IMonoXPool(monoXPoolLocal).safeTransferERC20Token(tokenOut, to, amountOut);
814       }
815       _updateTokenInfo(tokenOut, tokenOutPrice, tradeVusdValue.add(oneSideFeesInVusd), 0, 
816         to == monoXPoolLocal ? amountOut : 0);
817     }
818 
819     emit Swap(to, tokenIn, tokenOut, amountIn, amountOut);
820     
821   }
822 
823   
824   // swap from tokenIn to tokenOut with fixed tokenOut amount.
825   function swapOut (address tokenIn, address tokenOut, address from, address to, 
826       uint256 amountOut) internal lockToken(tokenIn) returns(uint256 amountIn)  {
827     uint256 tokenInPrice;
828     uint256 tokenOutPrice;
829     uint256 tradeVusdValue;
830     (tokenInPrice, tokenOutPrice, amountIn, tradeVusdValue) = getAmountIn(tokenIn, tokenOut, amountOut);
831     
832     address monoXPoolLocal = address(monoXPool);
833 
834     amountIn = transferAndCheck(from,monoXPoolLocal,tokenIn,amountIn);
835 
836     // uint256 halfFeesInTokenIn = amountIn.mul(fees)/2e5;
837 
838     uint256 oneSideFeesInVusd = tokenInPrice.mul(amountIn.mul(fees)/2e5)/1e18;
839 
840     // trading in
841     if(tokenIn==address(vUSD)){
842       vUSD.burn(monoXPoolLocal, amountIn);
843       // all fees go to buy side
844       oneSideFeesInVusd = oneSideFeesInVusd.mul(2);
845     }else {
846       _updateTokenInfo(tokenIn, tokenInPrice, 0, tradeVusdValue.add(oneSideFeesInVusd), 0);
847     }
848 
849     // trading out
850     if(tokenOut==address(vUSD)){
851       vUSD.mint(to, amountOut);
852       // all fees go to sell side
853       _updateVusdBalance(tokenIn, oneSideFeesInVusd, 0);
854     }else{
855       if (to != monoXPoolLocal) {
856         IMonoXPool(monoXPoolLocal).safeTransferERC20Token(tokenOut, to, amountOut);
857       }
858       _updateTokenInfo(tokenOut, tokenOutPrice, tradeVusdValue.add(oneSideFeesInVusd), 0, 
859         to == monoXPoolLocal ? amountOut:0 );
860     }
861 
862     emit Swap(to, tokenIn, tokenOut, amountIn, amountOut);
863 
864   }
865 
866   // function balanceOf(address account, uint256 id) public view returns (uint256) {
867   //   return monoXPool.balanceOf(account, id);
868   // }
869 
870   // function getConfig() public view returns (address _vUSD, address _feeTo, uint16 _fees, uint16 _devFee) {
871   //   _vUSD = address(vUSD);
872   //   _feeTo = feeTo;
873   //   _fees = fees;
874   //   _devFee = devFee;
875   // }
876 
877   function transferAndCheck(address from,address to,address _token,uint amount) internal returns (uint256){
878     if(from == address(this)){
879       return amount; // if it's ETH
880     }
881 
882     // if it's not ETH
883     if(tokenStatus[_token]==2){
884       IERC20(_token).safeTransferFrom(from, to, amount);
885       return amount;
886     }else{
887       uint256 balanceIn0 = IERC20(_token).balanceOf(to);
888       IERC20(_token).safeTransferFrom(from, to, amount);
889       uint256 balanceIn1 = IERC20(_token).balanceOf(to);
890       return balanceIn1.sub(balanceIn0);
891     }   
892 
893   }
894 }