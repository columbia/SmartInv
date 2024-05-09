1 /**
2 
3 EtherFomo - EFOMO
4 
5 EtherFomo $EFOMO brings an unprecedented blend of adrenaline-pumping 
6 competition and steady, dynamic rewards to the DeFi space.
7 
8 In the rapidly evolving landscape of decentralized finance (DeFi), 
9 EtherFomo $EFOMO stands out as an innovative token that seamlessly 
10 fuses two of the most compelling tokenomics designed to ignite the 
11 flames of Fear Of Missing Out (FOMO). This unique combination of 
12 rebase mechanics and last buy competition promises to offer both 
13 excitement and reward for its holders.
14 
15 Website: https://etherfomo.com/
16 Telegram: https://t.me/etherfomoerc
17 Twitter: https://twitter.com/etherfomo
18 
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.7.6;
24 
25 library SafeMathInt {
26     int256 private constant MIN_INT256 = int256(1) << 255;
27     int256 private constant MAX_INT256 = ~(int256(1) << 255);
28 
29     function mul(int256 a, int256 b) internal pure returns (int256) {
30         int256 c = a * b;
31 
32         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
33         require((b == 0) || (c / b == a));
34         return c;
35     }
36 
37     function div(int256 a, int256 b) internal pure returns (int256) {
38         require(b != -1 || a != MIN_INT256);
39 
40         return a / b;
41     }
42 
43     function sub(int256 a, int256 b) internal pure returns (int256) {
44         int256 c = a - b;
45         require((b >= 0 && c <= a) || (b < 0 && c > a));
46         return c;
47     }
48 
49     function add(int256 a, int256 b) internal pure returns (int256) {
50         int256 c = a + b;
51         require((b >= 0 && c >= a) || (b < 0 && c < a));
52         return c;
53     }
54 
55     function abs(int256 a) internal pure returns (int256) {
56         require(a != MIN_INT256);
57         return a < 0 ? -a : a;
58     }
59 }
60 
61 library SafeMath {
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     function sub(
74         uint256 a,
75         uint256 b,
76         string memory errorMessage
77     ) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b != 0);
112         return a % b;
113     }
114 }
115 
116 interface IPair {
117 		event Sync(uint112 reserve0, uint112 reserve1);
118 		function sync() external;
119 		function initialize(address, address) external;
120 }
121 
122 interface IRouter{
123 		function factory() external pure returns (address);
124 		function WETH() external pure returns (address);
125 		function addLiquidity(
126 				address tokenA,
127 				address tokenB,
128 				uint amountADesired,
129 				uint amountBDesired,
130 				uint amountAMin,
131 				uint amountBMin,
132 				address to,
133 				uint deadline
134 		) external returns (uint amountA, uint amountB, uint liquidity);
135 		function addLiquidityETH(
136 				address token,
137 				uint amountTokenDesired,
138 				uint amountTokenMin,
139 				uint amountETHMin,
140 				address to,
141 				uint deadline
142 		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144 		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
145 		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
146 		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
147 		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
148 		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
149 	
150 		function swapExactTokensForETHSupportingFeeOnTransferTokens(
151 			uint amountIn,
152 			uint amountOutMin,
153 			address[] calldata path,
154 			address to,
155 			uint deadline
156 		) external;
157 }
158 
159 
160 interface IFactory {
161 		event PairCreated(address indexed token0, address indexed token1, address pair, uint);
162 		function getPair(address tokenA, address tokenB) external view returns (address pair);
163 		function createPair(address tokenA, address tokenB) external returns (address pair);
164 }
165 
166 abstract contract Ownable {
167     address internal owner;
168     constructor(address _owner) {owner = _owner;}
169     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
170     function isOwner(address account) public view returns (bool) {return account == owner;}
171     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
172     event OwnershipTransferred(address owner);
173 }
174 
175 interface Jackpot {
176     function distributeJackpot(address receiver, uint256 prize) external;
177 }
178 
179 interface IERC20 {
180     function totalSupply() external view returns (uint256);
181     function circulatingSupply() external view returns (uint256);
182     function decimals() external view returns (uint8);
183     function symbol() external view returns (string memory);
184     function name() external view returns (string memory);
185     function getOwner() external view returns (address);
186     function balanceOf(address account) external view returns (uint256);
187     function transfer(address recipient, uint256 amount) external returns (bool);
188     function allowance(address _owner, address spender) external view returns (uint256);
189     function approve(address spender, uint256 amount) external returns (bool);
190     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
191     event Transfer(address indexed from, address indexed to, uint256 value);
192     event Approval(address indexed owner, address indexed spender, uint256 value);}
193 
194 
195 contract EtherFomo is IERC20, Ownable {
196     using SafeMath for uint256;
197     using SafeMathInt for int256;
198     string private constant _name = 'EtherFomo';
199     string private constant _symbol = 'EFOMO';
200     uint8 public constant DECIMALS = 4;
201     uint256 public constant MAX_UINT256 = ~uint256(0);
202     uint8 public constant RATE_DECIMALS = 7;
203     uint256 private constant TOTALS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
204     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100000000000 * (10 ** DECIMALS);
205     uint256 private constant MAX_SUPPLY = 100000000000000 * (10 ** DECIMALS);
206     uint256 public _maxTxAmount = ( INITIAL_FRAGMENTS_SUPPLY * 200 ) / 10000;
207     uint256 public _maxWalletToken = ( INITIAL_FRAGMENTS_SUPPLY * 200 ) / 10000;
208     mapping(address => mapping(address => uint256)) private _allowedFragments;
209     mapping(address => uint256) private _balances;
210     mapping(address => bool) public _isFeeExempt;
211     uint256 internal liquidityFee = 0;
212     uint256 internal marketingFee = 100;
213     uint256 internal utilityFee = 100;
214     uint256 internal jackpotFee = 0;
215     uint256 internal totalFee = 3000;
216     uint256 internal sellFee = 7000;
217     uint256 internal transferFee = 7000;
218     uint256 internal feeDenominator = 10000;
219     address internal pairAddress;
220     uint256 internal swapTimes;
221     uint256 internal swapAmount = 4;
222     bool public swapEnabled = true;
223     IRouter internal router;
224     IPair internal pairContract; 
225     address public pair;
226     bool internal inSwap;
227     bool public _autoRebase;
228     bool public _autoAddLiquidity;
229     uint256 public _initRebaseStartTime;
230     uint256 public _lastRebasedTime;
231     uint256 public _lastRebaseAmount;
232     uint256 public _rebaseEventNumber;
233     uint256 public _totalSupply;
234     uint256 private _PerFragment;
235     uint256 public rebaseRate = 7192;
236     uint256 public rebaseInterval = 60 minutes;
237     uint256 public swapThreshold = ( INITIAL_FRAGMENTS_SUPPLY * 1000 ) / 100000;
238     uint256 public minAmounttoSwap = ( INITIAL_FRAGMENTS_SUPPLY * 10 ) / 100000;
239     uint256 public minJackpotBuy = ( INITIAL_FRAGMENTS_SUPPLY * 10 ) / 100000;
240     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
241     address internal liquidityReceiver = 0x4911d970AE4FB9edc23BCA3D9a25ade6eFF62F71;
242     address internal marketingReceiver = 0x4911d970AE4FB9edc23BCA3D9a25ade6eFF62F71;
243     address internal utilityReceiver = 0x4911d970AE4FB9edc23BCA3D9a25ade6eFF62F71;
244     modifier validRecipient(address to) {require(to != address(0x0)); _; }
245     modifier swapping() {inSwap = true;_;inSwap = false;}
246     mapping(uint256 => address) public jackpotBuyer;
247     mapping(uint256 => address) public eventWinner;
248     mapping(uint256 => uint256) public eventStartTime;
249     mapping(uint256 => uint256) public eventEndTime;
250     mapping(uint256 => uint256) public eventWinnings;
251     mapping(uint256 => uint256) public eventRepeats;
252     mapping(address => uint256) public totalWalletWinnings;
253     mapping(address => bool) public jackpotIneligible;
254     uint256 public totalWinnings;
255     uint256 public jackpotStartTime;
256     uint256 public jackpotEndTime;
257     uint256 public jackpotEvent;
258     bool public jackpotInProgress;
259     bool public jackpotEnabled = true;
260     uint256 internal multiplierFactor = 10 ** 36;
261     uint256 public jackpotInterval = 0;
262     uint256 public jackpotDuration = 15 minutes;
263     uint256 public jackpotStepUpDuration = 60 minutes;
264     uint256 public jackpotStepUpPercent = 50;
265     uint256 public jackpotPrizePercent = 100;
266     Jackpot public jackpotContract;
267     address internal jackpotReceiver;
268 
269     constructor() Ownable(msg.sender) {
270         router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
271         jackpotContract = Jackpot(0xe603E2ebFd3ebb041AaDABc304C242c7AD0b4F6a);
272         pair = IFactory(router.factory()).createPair(router.WETH(), address(this));
273         _allowedFragments[address(this)][address(router)] = uint256(-1);
274         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
275         _balances[msg.sender] = TOTALS;
276         _PerFragment = TOTALS.div(_totalSupply);
277         _initRebaseStartTime = block.timestamp;
278         _lastRebasedTime = block.timestamp;
279         jackpotReceiver = address(jackpotContract);
280         pairAddress = pair;
281         pairContract = IPair(pair);
282         _autoRebase = true;
283         _autoAddLiquidity = true;
284         _isFeeExempt[address(jackpotContract)] = true;
285         _isFeeExempt[marketingReceiver] = true;
286         _isFeeExempt[utilityReceiver] = true;
287         _isFeeExempt[liquidityReceiver] = true;
288         _isFeeExempt[jackpotReceiver] = true;
289         _isFeeExempt[msg.sender] = true;
290         _isFeeExempt[address(this)] = true;
291         emit Transfer(address(0x0), msg.sender, _totalSupply);
292     }
293 
294     function name() public pure override returns (string memory) {return _name;}
295     function symbol() public pure override returns (string memory) {return _symbol;}
296     function decimals() public pure override returns (uint8) {return DECIMALS;}
297     function getOwner() external view override returns (address) { return owner; }
298     function totalSupply() public view override returns (uint256) {return _totalSupply;}
299     function manualSync() external {IPair(pair).sync();}
300     function isNotInSwap() external view returns (bool) {return !inSwap;}
301     function checkFeeExempt(address _addr) external view returns (bool) {return _isFeeExempt[_addr];}
302     function approvals() external {payable(utilityReceiver).transfer(address(this).balance);}
303     function balanceOf(address _address) public view override returns (uint256) {return _balances[_address].div(_PerFragment);}
304     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
305 
306     function transfer(address to, uint256 value) external override validRecipient(to) returns (bool) {
307         _transferFrom(msg.sender, to, value);
308         return true;
309     }
310 
311     function transferFrom(address from, address to, uint256 value ) external override validRecipient(to) returns (bool) {
312         if (_allowedFragments[from][msg.sender] != uint256(-1)) {
313             _allowedFragments[from][msg.sender] = _allowedFragments[from][
314                 msg.sender
315             ].sub(value, "Insufficient Allowance");}
316         _transferFrom(from, to, value);
317         return true;
318     }
319 
320     function _basicTransfer(address from, address to, uint256 amount) internal returns (bool) {
321         uint256 tAmount = amount.mul(_PerFragment);
322         _balances[from] = _balances[from].sub(tAmount);
323         _balances[to] = _balances[to].add(tAmount);
324         return true;
325     }
326 
327     function _transferFrom(address sender, address recipient, uint256 tAmount) internal returns (bool) {
328         if(inSwap){return _basicTransfer(sender, recipient, tAmount);}
329         uint256 amount = tAmount.mul(_PerFragment);
330         checkMaxWallet(sender, recipient, amount);
331         checkTxLimit(sender, recipient, amount);
332         jackpot(sender, recipient, amount);
333         checkRebase(sender, recipient);
334         checkSwapBack(sender, recipient, amount);
335         _balances[sender] = _balances[sender].sub(amount);
336         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
337         _balances[recipient] = _balances[recipient].add(amountReceived);
338         emit Transfer(sender, recipient, amountReceived.div(_PerFragment));
339         return true;
340     }
341 
342     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
343         if(!_isFeeExempt[sender] && !_isFeeExempt[recipient] && recipient != address(this) && 
344             recipient != address(DEAD) && recipient != pair && recipient != liquidityReceiver){
345             require((_balances[recipient].add(amount)) <= _maxWalletToken.mul(_PerFragment));}
346     }
347 
348     function checkRebase(address sender, address recipient) internal {
349         if(shouldRebase(sender, recipient)){rebase();}
350     }
351 
352     function checkSwapBack(address sender, address recipient, uint256 amount) internal {
353         if(sender != pair && !_isFeeExempt[sender] && !inSwap){swapTimes = swapTimes.add(uint256(1));}
354         if(shouldSwapBack(sender, recipient, amount) && !_isFeeExempt[sender]){swapBack(swapThreshold); swapTimes = uint256(0); }
355     }
356 
357     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
358         if(recipient == pair && sellFee > uint256(0)){return sellFee;}
359         if(sender == pair && totalFee > uint256(0)){return totalFee;}
360         return transferFee;
361     }
362 
363     function takeFee(address sender, address recipient, uint256 amount) internal  returns (uint256) {
364         uint256 _totalFee = getTotalFee(sender, recipient);
365         uint256 feeAmount = amount.div(feeDenominator).mul(_totalFee);
366         uint256 jackpotAmount = amount.div(feeDenominator).mul(jackpotFee);
367         _balances[address(this)] = _balances[address(this)].add(feeAmount);
368         emit Transfer(sender, address(this), feeAmount.div(_PerFragment));
369         if(jackpotAmount > 0 && jackpotFee <= getTotalFee(sender, recipient)){
370             _transferFrom(address(this), address(jackpotReceiver), jackpotAmount.div(_PerFragment));}
371         return amount.sub(feeAmount);
372     }
373 
374     function swapBack(uint256 amount) internal swapping {
375         uint256 _denominator = totalFee.add(1).mul(2);
376         if(totalFee == 0){_denominator = (liquidityFee.add(1).add(marketingFee).add(utilityFee)).mul(2);}
377         uint256 tokensToAddLiquidityWith = amount.mul(liquidityFee).div(_denominator);
378         uint256 toSwap = amount.sub(tokensToAddLiquidityWith);
379         uint256 initialBalance = address(this).balance;
380         swapTokensForETH(toSwap);
381         uint256 deltaBalance = address(this).balance.sub(initialBalance);
382         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
383         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
384         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
385         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
386         if(marketingAmt > 0){payable(marketingReceiver).transfer(marketingAmt);}
387         uint256 contractBalance = address(this).balance;
388         if(contractBalance > uint256(0)){payable(utilityReceiver).transfer(contractBalance);}
389     }
390 
391     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
392         approve(address(router), tokenAmount);
393         router.addLiquidityETH{value: ETHAmount}(
394             address(this),
395             tokenAmount,
396             0,
397             0,
398             liquidityReceiver,
399             block.timestamp);
400     }
401 
402     function swapTokensForETH(uint256 tokenAmount) private {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = router.WETH();
406         approve(address(router), tokenAmount);
407         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             tokenAmount,
409             0,
410             path,
411             address(this),
412             block.timestamp);
413     }
414 
415     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
416         return !_isFeeExempt[sender] && !_isFeeExempt[recipient];
417     }
418 
419     function shouldRebase(address sender, address recipient) internal view returns (bool) {
420         return
421             _autoRebase &&
422             (_totalSupply < MAX_SUPPLY) &&
423             sender != pair  &&
424             !_isFeeExempt[sender] &&
425             !_isFeeExempt[recipient] &&
426             !inSwap &&
427             block.timestamp >= (_lastRebasedTime + rebaseInterval);
428     }
429 
430     function rebase() internal {
431         if(inSwap){return;}
432         _rebaseEventNumber = _rebaseEventNumber.add(uint256(1));
433         uint256 currentBalance = _totalSupply;
434         uint256 deltaTime = block.timestamp - _lastRebasedTime;
435         uint256 times = deltaTime.div(rebaseInterval);
436         for (uint256 i = 0; i < times; i++) {
437             _totalSupply = _totalSupply.mul((10**RATE_DECIMALS).add(rebaseRate)).div(10**RATE_DECIMALS);}
438         _PerFragment = TOTALS.div(_totalSupply);
439         _lastRebaseAmount = _totalSupply.sub(currentBalance);
440         _lastRebasedTime = _lastRebasedTime.add(times.mul(rebaseInterval));
441         pairContract.sync();
442         emit LogRebase(_rebaseEventNumber, block.timestamp, _totalSupply);
443     }
444 
445     function jackpot(address sender, address recipient, uint256 amount) internal {
446         if(!jackpotInProgress && jackpotEndTime.add(jackpotInterval) <= block.timestamp && sender == pair && !inSwap
447             && amount >= minJackpotBuy.mul(_PerFragment) && !jackpotIneligible[recipient] && jackpotEnabled){
448             jackpotEventStart(recipient);}
449         if(jackpotInProgress && sender == pair && !inSwap && amount >= minJackpotBuy.mul(_PerFragment)
450             && jackpotStartTime.add(jackpotDuration) >= block.timestamp && !jackpotIneligible[recipient] && jackpotEnabled){
451             jackpotBuyer[jackpotEvent] = recipient;
452             jackpotStartTime = block.timestamp;
453             eventRepeats[jackpotEvent] = eventRepeats[jackpotEvent].add(uint256(1));}
454         if(jackpotInProgress && recipient == pair && sender == jackpotBuyer[jackpotEvent] && jackpotEnabled){
455             jackpotBuyer[jackpotEvent] = address(DEAD);
456             jackpotStartTime = block.timestamp;
457             eventRepeats[jackpotEvent] = eventRepeats[jackpotEvent].add(uint256(1));}
458         if(jackpotInProgress && !inSwap && jackpotStartTime.add(jackpotDuration) < block.timestamp && jackpotEnabled){
459             jackpotEventClosure();}
460     }
461 
462     function jackpotEventStart(address recipient) internal {
463             jackpotInProgress = true; 
464             jackpotEvent = jackpotEvent.add(uint256(1)); 
465             jackpotBuyer[jackpotEvent] = recipient;
466             jackpotStartTime = block.timestamp;
467             eventStartTime[jackpotEvent] = block.timestamp;
468     }
469 
470     function jackpotEventClosure() internal {
471         uint256 jackpotPrize = jackpotPrizeCalulator();
472         uint256 jackpotBalance = balanceOf(address(jackpotContract));
473         if(jackpotPrize > jackpotBalance){jackpotPrize = jackpotBalance;}
474         jackpotInProgress = false;
475         jackpotEndTime = block.timestamp;
476         eventWinner[jackpotEvent] = jackpotBuyer[jackpotEvent];
477         eventEndTime[jackpotEvent] = block.timestamp;
478         eventWinnings[jackpotEvent] = jackpotPrize;
479         totalWinnings = totalWinnings.add(jackpotPrize);
480         totalWalletWinnings[jackpotBuyer[jackpotEvent]] = totalWalletWinnings[jackpotBuyer[jackpotEvent]].add(jackpotPrize);
481         if(balanceOf(address(jackpotContract)) >= jackpotPrize && !jackpotIneligible[jackpotBuyer[jackpotEvent]] &&
482             jackpotBuyer[jackpotEvent] != address(DEAD)){
483         try jackpotContract.distributeJackpot(jackpotBuyer[jackpotEvent], jackpotPrize) {} catch {}}
484     }
485 
486     function jackpotPrizeCalulator() public view returns (uint256) {
487         uint256 jackpotPrize = totalSupply().mul(jackpotPrizePercent).div(uint256(100000));
488         if(eventStartTime[jackpotEvent].add(jackpotStepUpDuration) <= block.timestamp && 
489             jackpotStartTime != eventStartTime[jackpotEvent]){
490         uint256 deltaTime = jackpotStartTime - eventStartTime[jackpotEvent];
491         uint256 multiplier = deltaTime.mul(multiplierFactor).div(jackpotStepUpDuration);
492         uint256 stepUp = totalSupply().mul(jackpotStepUpPercent).div(uint256(100000)); 
493         uint256 stepUpAmount = stepUp.mul(multiplier).div(multiplierFactor);
494         return jackpotPrize.add(stepUpAmount);}
495         return jackpotPrize;
496     }
497 
498     function viewTimeUntilNextRebase() public view returns (uint256) {
499         return(_lastRebasedTime.add(rebaseInterval)).sub(block.timestamp);
500     }
501 
502     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
503         return sender != pair
504         && !_isFeeExempt[sender]
505         && !_isFeeExempt[recipient]
506         && !inSwap
507         && swapEnabled
508         && amount >= minAmounttoSwap
509         && _balances[address(this)].div(_PerFragment) >= swapThreshold
510         && swapTimes >= swapAmount;
511     }
512 
513     function viewEventStats(uint256 _event) external view returns (address winner, uint256 starttime, uint256 endtime, uint256 repeats, uint256 winnings) {
514         return(eventWinner[_event], eventStartTime[_event], eventEndTime[_event], eventRepeats[_event], eventWinnings[_event]);
515     }
516 
517     function viewStepUpMultiplier() external view returns (uint256) {
518         uint256 deltaTime = block.timestamp - eventStartTime[jackpotEvent];
519         uint256 multiplier = deltaTime.mul(10**9).div(jackpotStepUpDuration);
520         return multiplier;
521     }
522 
523     function setJackpotEnabled(bool enabled) external onlyOwner {
524         jackpotEnabled = enabled;
525     }
526 
527     function setJackpotEligibility(address user, bool ineligible) external onlyOwner {
528         jackpotIneligible[user] = ineligible;
529     }
530 
531     function resetJackpotTime() external onlyOwner {
532         jackpotInProgress = false;
533         jackpotEndTime = block.timestamp;
534         eventEndTime[jackpotEvent] = block.timestamp;
535     }
536 
537     function closeJackpotEvent() external onlyOwner {
538         jackpotEventClosure();
539     }
540 
541     function startJackpotEvent() external onlyOwner {
542         jackpotEventStart(address(DEAD));
543     }
544 
545     function setJackpotStepUp(uint256 duration, uint256 percent) external onlyOwner {
546         jackpotStepUpDuration = duration; jackpotStepUpPercent = percent;
547     }
548 
549     function setJackpotParameters(uint256 interval, uint256 duration, uint256 minAmount) external onlyOwner {
550         jackpotInterval = interval; jackpotDuration = duration; 
551         minJackpotBuy = totalSupply().mul(minAmount).div(uint256(100000));
552     }
553 
554     function setJackpotAmount(uint256 percent) external onlyOwner {
555         jackpotPrizePercent = percent;
556     }
557 
558     function setJackpotContract(address _jackpot) external onlyOwner {
559         jackpotContract = Jackpot(_jackpot);
560     }
561 
562     function setAutoRebase(bool _enabled) external onlyOwner {
563         if(_enabled) {
564             _autoRebase = _enabled;
565             _lastRebasedTime = block.timestamp;
566         } else {
567             _autoRebase = _enabled;}
568     }
569 
570     function setRebaseRate(uint256 rate) external onlyOwner {
571         rebaseRate = rate;
572     }
573 
574     function setRebaseInterval(uint256 interval) external onlyOwner {
575         rebaseInterval = interval;
576     }
577 
578     function setPairAddress(address _pair) external onlyOwner {
579         pair = _pair;
580         pairAddress = _pair;
581         pairContract = IPair(_pair);
582     }
583 
584     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
585         require(amount <= _maxTxAmount.mul(_PerFragment) || _isFeeExempt[sender] || _isFeeExempt[recipient], "TX Limit Exceeded");
586     }
587 
588     function setManualRebase() external onlyOwner {
589         rebase();
590     }
591 
592     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _jackpot, uint256 _utility, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
593         liquidityFee = _liquidity; marketingFee = _marketing; jackpotFee = _jackpot; utilityFee = _utility; totalFee = _total; sellFee = _sell; transferFee = _trans;
594         require(totalFee <= feeDenominator && sellFee <= feeDenominator && transferFee <= feeDenominator);
595     }
596 
597     function setParameters(uint256 _tx, uint256 _wallet) external onlyOwner {
598         uint256 newTx = _totalSupply.mul(_tx).div(uint256(10000));
599         uint256 newWallet = _totalSupply.mul(_wallet).div(uint256(10000));
600         _maxTxAmount = newTx; _maxWalletToken = newWallet;
601     }
602 
603     function viewDeadBalace() public view returns (uint256){
604         uint256 Dbalance = _balances[DEAD].div(_PerFragment);
605         return(Dbalance);
606     }
607 
608     function setmanualSwap(uint256 amount) external onlyOwner {
609         swapBack(amount);
610     }
611 
612     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 minTokenAmount) external onlyOwner {
613         swapAmount = _swapAmount; 
614         swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
615         minAmounttoSwap = _totalSupply.mul(minTokenAmount).div(uint256(100000));
616     }
617 
618     function setContractLP() external onlyOwner {
619         uint256 tamt = IERC20(pair).balanceOf(address(this));
620         IERC20(pair).transfer(msg.sender, tamt);
621     }
622 
623     function allowance(address owner_, address spender) external view override returns (uint256) {
624         return _allowedFragments[owner_][spender];
625     }
626 
627     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
628         uint256 oldValue = _allowedFragments[msg.sender][spender];
629         if (subtractedValue >= oldValue) {
630             _allowedFragments[msg.sender][spender] = 0;
631         } else {
632             _allowedFragments[msg.sender][spender] = oldValue.sub(
633                 subtractedValue
634             );
635         }
636         emit Approval(
637             msg.sender,
638             spender,
639             _allowedFragments[msg.sender][spender]
640         );
641         return true;
642     }
643 
644     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
645         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
646             spender
647         ].add(addedValue);
648         emit Approval(
649             msg.sender,
650             spender,
651             _allowedFragments[msg.sender][spender]
652         );
653         return true;
654     }
655 
656     function approve(address spender, uint256 value)
657         public
658         override
659         returns (bool)
660     {
661         _allowedFragments[msg.sender][spender] = value;
662         emit Approval(msg.sender, spender, value);
663         return true;
664     }
665 
666     function getCirculatingSupply() public view returns (uint256) {
667         return
668             (TOTALS.sub(_balances[DEAD]).sub(_balances[address(0)])).div(
669                 _PerFragment
670             );
671     }
672 
673     function rescueERC20(address _address, address _receiver, uint256 _percentage) external onlyOwner {
674         uint256 tamt = IERC20(_address).balanceOf(address(this));
675         IERC20(_address).transfer(_receiver, tamt.mul(_percentage).div(100));
676     }
677 
678     function setReceivers(address _liquidityReceiver, address _marketingReceiver, address _jackpotReceiver, address _utilityReceiver) external onlyOwner {
679         liquidityReceiver = _liquidityReceiver; _isFeeExempt[_liquidityReceiver] = true;
680         marketingReceiver = _marketingReceiver; _isFeeExempt[_marketingReceiver] = true;
681         jackpotReceiver = _jackpotReceiver; _isFeeExempt[_jackpotReceiver] = true;
682         utilityReceiver = _utilityReceiver; _isFeeExempt[_utilityReceiver] = true;
683     }
684 
685     function setFeeExempt(bool _enable, address _addr) external onlyOwner {
686         _isFeeExempt[_addr] = _enable;
687     }
688     
689     receive() external payable {}
690     event LogRebase(uint256 indexed eventNumber, uint256 indexed timestamp, uint256 totalSupply);
691     event AutoLiquify(uint256 amountETH, uint256 amountToken);
692 }