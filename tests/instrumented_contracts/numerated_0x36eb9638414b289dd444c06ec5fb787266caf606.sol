1 /*
2 
3 This contract is brought to you by Tokerr Factory
4 Join us at https://t.me/tokrethchannel
5 */
6 
7 pragma solidity ^0.8.16;
8 
9 //SPDX-License-Identifier: MIT
10 
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 }
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Auth {
67     address internal owner;
68     mapping (address => bool) internal authorizations;
69 
70     constructor(address _owner) {
71         owner = _owner;
72         authorizations[_owner] = true;
73     }
74 
75     modifier onlyOwner() {
76         require(isOwner(msg.sender), "!OWNER"); _;
77     }
78 
79     modifier authorized() {
80         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
81     }
82 
83     function authorize(address adr) public onlyOwner {
84         authorizations[adr] = true;
85     }
86 
87     function unauthorize(address adr) public onlyOwner {
88         authorizations[adr] = false;
89     }
90 
91     function isOwner(address account) public view returns (bool) {
92         return account == owner;
93     }
94 
95     function isAuthorized(address adr) public view returns (bool) {
96         return authorizations[adr];
97     }
98 
99     function transferOwnership(address payable adr) public onlyOwner {
100         owner = adr;
101         authorizations[adr] = true;
102         emit OwnershipTransferred(adr);
103     }
104 
105     function renounceOwnership() public onlyOwner() {
106         owner = address(0);
107         emit OwnershipTransferred(address(0));
108     }
109 
110     event OwnershipTransferred(address owner);
111 }
112 
113 interface IDEXFactory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IDEXRouter {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120 
121     function addLiquidity(
122         address tokenA,
123         address tokenB,
124         uint amountADesired,
125         uint amountBDesired,
126         uint amountAMin,
127         uint amountBMin,
128         address to,
129         uint deadline
130     ) external returns (uint amountA, uint amountB, uint liquidity);
131 
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 
149     function swapExactETHForTokensSupportingFeeOnTransferTokens(
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external payable;
155 
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 }
164 
165 interface BotRekt{
166     function isBot(uint256 time, address recipient) external returns (bool, address);
167 }
168 
169 contract StandardTokerrContract is IERC20, Auth {
170     using SafeMath for uint256;
171 
172     address DEAD = 0x000000000000000000000000000000000000dEaD;
173     address ZERO = 0x0000000000000000000000000000000000000000;
174 
175     BotRekt KillBot;
176     
177     string _name;
178     string _symbol;
179     uint8 constant _decimals = 9;
180     
181     uint256 _totalSupply; 
182     
183     uint256 public _maxTxAmount;
184     uint256 public _maxWalletToken;
185 
186     mapping (address => uint256) _balances;
187     mapping (address => mapping (address => uint256)) _allowances;
188 
189     mapping (address => bool) lpProvider;
190     address creator;
191 
192     mapping (address => bool) isFeeExempt;
193     mapping (address => bool) isTxLimitExempt;
194 
195     uint256 launchTime;
196     
197 
198     //fees are set with a 10x multiplier to allow for 2.5 etc. Denominator of 1000
199     uint256 marketingBuyFee;
200     uint256 liquidityBuyFee;
201     uint256 devBuyFee;
202     uint256 public totalBuyFee = marketingBuyFee.add(liquidityBuyFee).add(devBuyFee);
203 
204     uint256 marketingSellFee;
205     uint256 liquiditySellFee;
206     uint256 devSellFee;
207     uint256 public totalSellFee = marketingSellFee.add(liquiditySellFee).add(devSellFee);
208 
209     uint256 marketingFee = marketingBuyFee.add(marketingSellFee);
210     uint256 liquidityFee = liquidityBuyFee.add(liquiditySellFee);
211     uint256 devFee = devBuyFee.add(devSellFee);
212 
213     uint256 totalFee = liquidityFee.add(marketingFee).add(devFee);
214 
215     address public liquidityWallet;
216     address public marketingWallet;
217     address public devWallet;
218 
219     address tokerrWallet = 0x6A28250C87751D052128cf83dF417Be683D012A8;
220 
221     uint256 transferCount = 1;
222 
223     string telegram;
224     string website;
225 
226     //one time trade lock
227     bool lockTilStart = true;
228     bool lockUsed = false;
229 
230     //contract cant be tricked into spam selling exploit
231     uint256 cooldownSeconds = 1;
232     uint256 lastSellTime;
233 
234     event LockTilStartUpdated(bool enabled);
235 
236     bool limits = true;
237 
238     IDEXRouter public router;
239     address public pair;
240 
241     bool public swapEnabled = true;
242     uint256 public swapThreshold;
243     uint256 swapRatio = 40;
244 
245     bool inSwap;
246     modifier swapping() { inSwap = true; _; inSwap = false; }
247 
248     event TradeStarted(bool trading);
249 
250 
251     constructor (uint[] memory numbers, address[] memory addresses, string[] memory names, 
252                 address antiBot, address builder) Auth(msg.sender) {
253         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
254         pair = IDEXFactory(router.factory()).createPair(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
255 
256         transferOwnership(payable(builder));
257         authorizations[builder] = true;
258         authorizations[addresses[0]] = true;
259         lpProvider[builder] = true;
260         creator = addresses[0];
261 
262         KillBot = BotRekt(antiBot);
263 
264         _name = names[0];
265         _symbol = names[1];
266         telegram = names[2];
267         website = names[3];
268         _totalSupply = numbers[1] * (10 ** _decimals);
269 
270         _allowances[address(this)][address(router)] = _totalSupply;
271 
272         isFeeExempt[builder] = true;
273         isTxLimitExempt[builder] = true;
274         isFeeExempt[addresses[0]] = true;
275         isTxLimitExempt[addresses[0]] = true;
276 
277         swapThreshold = _totalSupply.mul(10).div(100000);
278 
279         marketingWallet = addresses[1];
280         devWallet = addresses[2];
281         liquidityWallet = DEAD;
282 
283 
284         marketingBuyFee = numbers[2];
285         liquidityBuyFee = numbers[4];
286         devBuyFee = numbers[6];
287 
288         totalBuyFee = marketingBuyFee.add(liquidityBuyFee).add(devBuyFee).add(5);
289         require(totalBuyFee <= 105, "Buy tax too high!"); //10% buy tax
290 
291         marketingSellFee = numbers[3];
292         liquiditySellFee = numbers[5];
293         devSellFee = numbers[7];
294         
295 
296         totalSellFee = marketingSellFee.add(liquiditySellFee).add(devSellFee).add(5);
297         require(totalSellFee <= 105, "Sell tax too high!"); //10% sell tax
298 
299         marketingFee = marketingBuyFee.add(marketingSellFee);
300         liquidityFee = liquidityBuyFee.add(liquiditySellFee);
301         devFee = devBuyFee.add(devSellFee);
302 
303         totalFee = liquidityFee.add(marketingFee).add(devFee).add(10);
304 
305         _maxTxAmount = ( _totalSupply * numbers[10] ) / 1000;
306         require(numbers[10] >= 5,"Max txn too low!"); //0.5% max txn
307         require(numbers[10] <= 30,"Max txn too high!"); //5% max txn
308         _maxWalletToken = ( _totalSupply * numbers[11] ) / 1000;
309         require(numbers[11] >= 5,"Max wallet too low!"); //0.5% max wallet
310         require(numbers[11] <= 30,"Max wallet too high!"); //5% max wallet
311 
312         approve(address(router), _totalSupply);
313         approve(address(pair), _totalSupply);
314         require(95 <= numbers[13] && numbers[13] <= 100, "Too low LP %");
315 
316         require(block.timestamp + 1 days - 1 hours <= numbers[14], "Must lock longer than X");
317         require(numbers[14] < 9999999999, "Avoid potential timestamp overflow");
318 
319         uint256 lpDiv;
320 
321         //calculate desired dev bag, compare to max wallet
322         uint256 devCheck = (100 - numbers[13]) * 10;
323         if (devCheck > numbers[11]){
324             lpDiv = (1000 - numbers[11]) / 10;
325         }
326         else{
327             lpDiv = numbers[13];
328         }
329     
330 
331         uint256 liquidityAmount = ( _totalSupply * lpDiv ) / 100;
332         _balances[builder] = liquidityAmount;
333         _balances[addresses[0]] = _totalSupply.sub(liquidityAmount);
334         emit Transfer(address(0), builder, liquidityAmount);
335         emit Transfer(address(0), addresses[0], _totalSupply.sub(liquidityAmount));
336     }
337 
338     receive() external payable { }
339 
340     function totalSupply() external view override returns (uint256) { return _totalSupply; }
341     function decimals() external pure override returns (uint8) { return _decimals; }
342     function symbol() external view override returns (string memory) { return _symbol; }
343     function name() external view override returns (string memory) { return _name; }
344     function getOwner() external view override returns (address) { return owner; }
345     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
346     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
347     function getPair() external view returns (address){return pair;}
348 
349     function aboutMe() external view returns (string memory,string memory){
350         return (telegram,website);
351     }
352 
353     function updateAboutMe(string memory _telegram,string memory _website) external authorized{
354         telegram = _telegram;
355         website = _website;
356     }
357 
358     function approve(address spender, uint256 amount) public override returns (bool) {
359         _allowances[msg.sender][spender] = amount;
360         emit Approval(msg.sender, spender, amount);
361         return true;
362     }
363 
364     function approveMax(address spender) external returns (bool) {
365         return approve(spender, _totalSupply);
366     }
367     
368     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
369         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
370         _balances[recipient] = _balances[recipient].add(amount);
371         emit Transfer(sender, recipient, amount);
372         return true;
373     }
374 
375     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, 
376                     uint256 _devFee) external authorized{
377         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 100);
378         marketingBuyFee = _marketingFee;
379         liquidityBuyFee = _liquidityFee;
380         devBuyFee = _devFee;
381 
382         marketingFee = marketingSellFee.add(_marketingFee);
383         liquidityFee = liquiditySellFee.add(_liquidityFee);
384         devFee = devSellFee.add(_devFee);
385 
386         totalBuyFee = _marketingFee.add(_liquidityFee).add(_devFee).add(5);
387         totalFee = liquidityFee.add(marketingFee).add(devFee).add(10);
388     }
389     
390     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, 
391                     uint256 _devFee) external authorized{
392         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 100);
393         marketingSellFee = _marketingFee;
394         liquiditySellFee = _liquidityFee;
395         devSellFee = _devFee;
396 
397         marketingFee = marketingBuyFee.add(_marketingFee);
398         liquidityFee = liquidityBuyFee.add(_liquidityFee);
399         devFee = devBuyFee.add(_devFee);
400 
401         totalSellFee = _marketingFee.add(_liquidityFee).add(_devFee).add(5);
402         totalFee = liquidityFee.add(marketingFee).add(devFee).add(10);
403     }
404 
405     function setWallets(address _marketingWallet, address _devWallet) external authorized {
406         marketingWallet = _marketingWallet;
407         devWallet = _devWallet;
408     }
409 
410     function setMaxWallet(uint256 percent) external authorized {
411         require(percent >= 5); //0.5% of supply, no lower
412         require(percent <= 30); //3% of supply, no higher
413         _maxWalletToken = ( _totalSupply * percent ) / 1000;
414     }
415 
416     function setTxLimit(uint256 percent) external authorized {
417         require(percent >= 5); //0.5% of supply, no lower
418         require(percent <= 30); //3% of supply, no higher
419         _maxTxAmount = ( _totalSupply * percent ) / 1000;
420     }
421 
422     function getAddress() external view returns (address){
423         return address(this);
424     }
425 
426     
427     function clearStuckBalance(uint256 amountPercentage) external  {
428         uint256 amountETH = address(this).balance;
429         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
430     }
431 
432     function checkLimits(address sender,address recipient, uint256 amount) internal view {
433         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
434             && recipient != address(DEAD) && recipient != pair && recipient != marketingWallet && recipient != liquidityWallet){
435                 uint256 heldTokens = balanceOf(recipient);
436                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
437             }
438 
439         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
440     }
441 
442     function getTradingEnabledStatus() external view returns  (bool){
443         //lock is used @ trade open
444         return lockUsed;
445     }
446 
447     function startTrading() external onlyOwner {
448         require(lockUsed == false);
449         lockTilStart = false;
450         launchTime = block.timestamp;
451         lockUsed = true;
452         lpProvider[creator] = true;
453 
454         emit LockTilStartUpdated(lockTilStart);
455         emit TradeStarted(true);
456     }
457 
458     //cant call this til half an hour after launch to prevent prepump
459     function liftMax() external authorized {
460         require(block.timestamp >= launchTime + 1800);
461         limits = false;
462     }
463     
464     function shouldTakeFee(address sender) internal view returns (bool) {
465         return !isFeeExempt[sender];
466     }
467 
468     function checkTxLimit(address sender, uint256 amount) internal view {
469         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
470     }
471 
472     function setTokenSwapSettings(bool _enabled, uint256 _threshold, uint256 _ratio) external authorized {
473         require(_ratio > 0, "Ratio too low");
474         require(_threshold > 0 && _threshold <= _totalSupply.div(10).div(10**9), "Threshold too low/high");
475         swapEnabled = _enabled;
476         swapThreshold = _threshold * (10 ** _decimals);
477         swapRatio = _ratio;
478 
479     }
480     
481     function shouldTokenSwap(uint256 amount, address recipient) internal view returns (bool) {
482 
483         bool timeToSell = lastSellTime.add(cooldownSeconds) < block.timestamp;
484 
485         return recipient == pair
486         && timeToSell
487         && !inSwap
488         && swapEnabled
489         && _balances[address(this)] >= swapThreshold
490         && _balances[address(this)] >= amount.mul(swapRatio).div(100);
491     }
492 
493     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
494 
495         uint256 _totalFee;
496 
497         _totalFee = (recipient == pair) ? totalSellFee : totalBuyFee;
498 
499         uint256 feeAmount = amount.mul(_totalFee).div(1000);
500 
501         _balances[address(this)] = _balances[address(this)].add(feeAmount);
502 
503         emit Transfer(sender, address(this), feeAmount);
504 
505         return amount.sub(feeAmount);
506     }
507 
508     function tokenSwap(uint256 _amount) internal swapping {
509 
510         uint256 amount = _amount.mul(swapRatio).div(100);
511         //0.5% buy and sell, both sets of taxes added together in swap
512         uint256 tokerr = 10;
513 
514         (amount > swapThreshold) ? amount : amount = swapThreshold;
515 
516         uint256 amountToLiquify = (liquidityFee > 0) ? amount.mul(liquidityFee).div(totalFee).div(2) : 0;
517 
518         uint256 amountToSwap = amount.sub(amountToLiquify);
519 
520         address[] memory path = new address[](2);
521         path[0] = address(this);
522         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
523 
524         uint256 balanceBefore = address(this).balance;
525 
526         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
527             amountToSwap,
528             0,
529             path,
530             address(this),
531             block.timestamp
532         );
533 
534         bool tmpSuccess;
535 
536         uint256 amountETH = address(this).balance.sub(balanceBefore);
537         uint256 totalETHFee = (liquidityFee > 0) ? totalFee.sub(liquidityFee.div(2)) : totalFee;
538         
539 
540         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
541         if (devFee > 0){
542             uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
543             
544             (tmpSuccess,) = payable(devWallet).call{value: amountETHDev, gas: 100000}("");
545             tmpSuccess = false;
546         }
547 
548         if(amountToLiquify > 0){
549             router.addLiquidityETH{value: amountETHLiquidity}(
550                 address(this),
551                 amountToLiquify,
552                 0,
553                 0,
554                 liquidityWallet,
555                 block.timestamp
556             );
557             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
558         }
559         //after other fees are allocated, tokerrFee is calculated and taken before marketing
560         uint256 tokerrFee = amountETH.mul(tokerr).div(totalETHFee);
561         (tmpSuccess,) = payable(tokerrWallet).call{value: tokerrFee, gas: 100000}("");
562         tmpSuccess = false;
563 
564         uint256 amountETHMarketing = address(this).balance;
565         if(amountETHMarketing > 0){
566             (tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 100000}("");
567             tmpSuccess = false;
568         }
569 
570         lastSellTime = block.timestamp;
571     }
572 
573     function transfer(address recipient, uint256 amount) external override returns (bool) {
574         if (owner == msg.sender){
575             return _basicTransfer(msg.sender, recipient, amount);
576         }
577         else {
578             return _transferFrom(msg.sender, recipient, amount);
579         }
580     }
581 
582     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585         if(_allowances[sender][msg.sender] != _totalSupply){
586             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
587         }
588 
589         return _transferFrom(sender, recipient, amount);
590     }
591 
592     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
593 
594         require(sender != address(0), "ERC20: transfer from the zero address");
595         require(recipient != address(0), "ERC20: transfer to the zero address");
596 
597         if(!lpProvider[sender] && !lpProvider[recipient]){
598             require(lockTilStart != true,"Trading not open yet");
599         }
600 
601 
602         if (authorizations[sender] || authorizations[recipient]){
603             return _basicTransfer(sender, recipient, amount);
604         }
605 
606         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
607 
608         if(!authorizations[sender] && !authorizations[recipient]){
609             require(lockTilStart != true,"Trading not open yet");
610         }
611         
612         if (sender == pair && recipient != address(this)){
613 
614             KillBot.isBot(launchTime, recipient);
615         }
616         
617         if (limits){
618             checkLimits(sender, recipient, amount);
619         }
620 
621         if(shouldTokenSwap(amount, recipient)){ tokenSwap(amount); }
622         
623         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
624         uint256 amountReceived = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
625 
626 
627         
628 
629         _balances[recipient] = _balances[recipient].add(amountReceived);
630         
631         if ((sender == pair || recipient == pair) && recipient != address(this)){
632             transferCount += 1;
633         }
634         
635         
636         emit Transfer(sender, recipient, amountReceived);
637         return true;
638     }
639     event AutoLiquify(uint256 amountETH, uint256 amountCoin);
640 }