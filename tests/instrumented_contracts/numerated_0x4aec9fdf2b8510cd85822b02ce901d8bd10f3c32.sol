1 /*
2                           ```````                                               
3                    ``.-:://////////::-.``                                       
4                 `-:/++oooooooooooooooo++/:-`                                    
5              `-:++ooooooooooooooooooooooooo+/-`                                 
6            `:/+ooooooooooo/:----:+ooooooooooo+/:`                               
7          `:++/++oooooooo/-.......--+oooooooo++/++:`                             
8         -/++/:o+oooooo+-............:ooooooo+o::o+/.                            
9        :+++o/-+oooooo+-..............:+oooooo+./oo++:                           
10       :++++++/-:+++++/````````````````/+++++:.:++++++:                          
11      :++++++++/-.-/++:````````````````/++/-.-/++++++++:                         
12     .++/:::/++++/.`-++````````````````++-`./++++/:::/++.                        
13     /++.-:.`-/++++``/+:``````````````:+/``/+++/-`.:-.++/                        
14    .+++/+++: .++/. .++/``          `./+/. ./++. :+++/+++`                       
15    -+++++++/` //`  :++-/s+-     `:+s:-++:  `//  /+++++++-                       
16    -+++++++/  :-   `/+/:/++`    .+//-/+/`   -:  /+++++++-                       
17    -+++++++:  ./.   `/++-          -++/`   ./.  :+++++++-                       
18    .++++++/-`` -/:   `-`            `-`   :/- ``-/++++++`                       
19     /++/-`   `..`.```                  ```.`..    `-/++/                        
20     .++.  ``.`  .                          .  ````  .++.                        
21      :/  -///-  .::/-`.://:.`  `.://:.`-/::.  -///-  /:                         
22      `/-``-:+/  `:/- `-.--:/-  :/---`-` -/:`  /+:-``-:                          
23       `:////++-     `: -++:+.  :+:+/.`/`     -++//:/:`                          
24         -/++++/:.`.-//  -:-.   `-:-. `+/-.`.-/++++/.                            
25          `:/++++///+++:`            ./+++///++++/:`                             
26            `:/+++++++++//----::---://+++++++++/:`                               
27              `-:/++++++++++++++++++++++++++/:-`                                 
28                 `-://++++++++++++++++++//:-`                                    
29                    ``.-:::////////:::-.``                                       
30                           ````````                                              
31 
32     ██╗  ██╗███████╗    ██╗    ██╗  ██╗███████╗███╗   ██╗
33     ██║ ██╔╝██║  ██╝   ████╗   ██║ ██╔╝██╔════╝████╗  ██║
34     █████╔╝ ███████╗  ██╔═██╗  █████╔╝ █████╗  ██╔██╗ ██║
35     ██╔═██╗ ██╔══██║ ████████╗ ██╔═██╗ ██╔══╝  ██║╚██╗██║
36     ██║  ██╗██║  ██║██║     ██╗██║  ██╗███████╗██║ ╚████║
37     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
38     
39 
40 KRAKEN by VP
41 
42 FIRST TWENTY MINUTES OF TRADING
43 buy/sell limit 1% total supply
44 
45 BUY FEES
46 7% -redistribution 
47 5% - lottery wallet
48 
49 SELL FEES (Dynamic - Resets after 24 hours from first sell)
50 2% price impact limit on all sells
51 
52 1st sell -
53 10% dev tax
54 20% whale wallet
55 1 hour cooldown period
56 
57 2nd sell - 
58 8% dev tax 
59 17% whale wallet tax
60 2 hour cooldown period
61 
62 3rd sell - 
63 10% dev tax 
64 20% whale wallet tax
65 3hour cooldown period
66 
67 4th sell - 
68 8% dev tax 
69 17% whale wallet tax
70 No more sells allowed until 24 hours after first sell
71 
72 The Kraken is a legendary sea monster of colossal proportions that originates from Nordic folklore. Striking fear into the
73 hearts of every sailor, the Kraken’s tentacles wield enough power to pull entire ships underwater, leaving the crew to either 
74 drown or to be its next meal. Rumor has it that the Kraken is guarding immense riches from its previous victims.
75 
76 Will investors suffer the same fate, or will they lay claim to what the beast has stolen?
77 
78 KRAKEN by VP ($KRAKN) is inspired by the popular “buyback wallet” trend. We dove into the communities of the different projects
79 that utilized this tokenomic and gathered up countless examples as to what investors all liked, disliked and ultimately wanted 
80 to see. The ultimate goal is to reward our community for holding to the end game with various incentives. Some of the mechanics 
81 include but are not limited to redistribution, lotteries, buy backs and dynamic sell limits.
82 
83 Smart contract developed by Alex Liddle
84 Reach on telegram: @Alex_Saint_Dev
85 
86 SPDX-License-Identifier: None
87 */
88 
89 
90 
91 pragma solidity ^0.8.4;
92 
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 }
98 
99 interface IERC20 {
100     function totalSupply() external view returns (uint256);
101     function balanceOf(address account) external view returns (uint256);
102     function transfer(address recipient, uint256 amount) external returns (bool);
103     function allowance(address owner, address spender) external view returns (uint256);
104     function approve(address spender, uint256 amount) external returns (bool);
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106     event Transfer(address indexed from, address indexed to, uint256 value);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 library SafeMath {
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114         return c;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b <= a, errorMessage);
123         uint256 c = a - b;
124         return c;
125     }
126 
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         if (a == 0) {
129             return 0;
130         }
131         uint256 c = a * b;
132         require(c / a == b, "SafeMath: multiplication overflow");
133         return c;
134     }
135 
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139 
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         return c;
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149     address private _previousOwner;
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     constructor() {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157 
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     modifier onlyOwner() {
163         require(_owner == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 }
172 
173 interface IUniswapV2Factory {
174     function createPair(address tokenA, address tokenB) external returns (address pair);
175 }
176 
177 interface IUniswapV2Router02 {
178     function swapExactTokensForETHSupportingFeeOnTransferTokens(
179         uint256 amountIn,
180         uint256 amountOutMin,
181         address[] calldata path,
182         address to,
183         uint256 deadline
184     ) external;
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187     function addLiquidityETH(
188         address token,
189         uint256 amountTokenDesired,
190         uint256 amountTokenMin,
191         uint256 amountETHMin,
192         address to,
193         uint256 deadline
194     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
195 }
196 
197 contract KRAKN is Context, IERC20, Ownable {
198     using SafeMath for uint256;
199     string private constant _name = "KRAKEN by VP";
200     string private constant _symbol = "KRAKN";
201     uint8 private constant _decimals = 9;
202     mapping(address => uint256) private _rOwned;
203     mapping(address => uint256) private _tOwned;
204     mapping(address => mapping(address => uint256)) private _allowances;
205     mapping(address => bool) private _isExcludedFromFee;
206     uint256 private constant MAX = ~uint256(0);
207     uint256 private constant _tTotal = 1000000000000 * 10**9;
208     uint256 private _rTotal = (MAX - (MAX % _tTotal));
209     uint256 private _tFeeTotal;
210     
211     uint256 public _whaleFee = 17;
212     uint256 private _previousWhaleFee = _whaleFee;
213     uint256 public _teamFee = 8;
214     uint256 private _previousTeamFee = _teamFee;
215     
216     uint256 public _teamPercent = 30;
217     uint256 public _whalePercent = 70;
218 
219     uint256 public _reflectionFee = 5;
220     uint256 private _previousReflectionFee = _reflectionFee;
221     uint256 public _lotteryFee = 5;
222     uint256 private _previousLotteryFee = _lotteryFee;
223     
224     uint256 public _priceImpact = 2;
225     
226     struct BuyBreakdown {
227         uint256 tTransferAmount;
228         uint256 tLottery;
229         uint256 tReflection;
230     }
231     
232     mapping(address => bool) private bots;
233     mapping(address => uint256) private buycooldown;
234     mapping(address => uint256) private sellcooldown;
235     mapping(address => uint256) private firstsell;
236     mapping(address => uint256) private sellnumber;
237     address payable private _teamAddress = payable(0x58BfDbb51A62584c023a6439155F5bDcB556660b);
238     address payable private _whaleAddress = payable(0x651CB3E19815Fe172Fd730D7a6d439598CCb0010);
239     address payable private _lotteryAddress = payable(0x75B63Dfb568F2CF52d984862ac56Af47C17dEE4A);
240     IUniswapV2Router02 private uniswapV2Router;
241     address private uniswapV2Pair;
242     bool private tradingOpen = false;
243     bool private liquidityAdded = false;
244     bool private inSwap = false;
245     bool private swapEnabled = false;
246     bool private cooldownEnabled = false;
247     bool private sellCooldownEnabled = false;
248     bool private sellOnly = false;
249     uint256 private _maxTxAmount;
250     event MaxTxAmountUpdated(uint256 _maxTxAmount);
251     event SellOnlyUpdated(bool sellOnly);
252     event PercentsUpdated(uint256 _teamPercent, uint256 _whalePercent);
253     event FeesUpdated(uint256 _whaleFee, uint256 _teamFee, uint256 _reflectionFee, uint256 _lotteryFee);
254     event PriceImpactUpdated(uint256 _priceImpact);
255     
256     modifier lockTheSwap {
257         inSwap = true;
258         _;
259         inSwap = false;
260     }
261     constructor() {
262         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
263         uniswapV2Router = _uniswapV2Router;
264         _approve(address(this), address(uniswapV2Router), _tTotal);
265         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
266         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
267 
268         swapEnabled = true;
269         cooldownEnabled = false;
270         sellCooldownEnabled = true;
271         liquidityAdded = true;
272         _maxTxAmount = _tTotal.div(100); // start off transaction limit at 1% of total supply
273 
274         _rOwned[_msgSender()] = _rTotal;
275         _isExcludedFromFee[owner()] = true;
276         _isExcludedFromFee[address(this)] = true;
277         _isExcludedFromFee[_teamAddress] = true;
278         _isExcludedFromFee[_whaleAddress] = true;
279         _isExcludedFromFee[_lotteryAddress] = true;
280         emit Transfer(address(0), _msgSender(), _tTotal);
281     }
282 
283     function name() public pure returns (string memory) {
284         return _name;
285     }
286 
287     function symbol() public pure returns (string memory) {
288         return _symbol;
289     }
290 
291     function decimals() public pure returns (uint8) {
292         return _decimals;
293     }
294 
295     function totalSupply() public pure override returns (uint256) {
296         return _tTotal;
297     }
298 
299     function balanceOf(address account) public view override returns (uint256) {
300         return tokenFromReflection(_rOwned[account]);
301     }
302 
303     function transfer(address recipient, uint256 amount) public override returns (bool) {
304         _transfer(_msgSender(), recipient, amount);
305         return true;
306     }
307 
308     function allowance(address owner, address spender) public view override returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     function approve(address spender, uint256 amount) public override returns (bool) {
313         _approve(_msgSender(), spender, amount);
314         return true;
315     }
316 
317     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
318         _transfer(sender, recipient, amount);
319         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
320         return true;
321     }
322 
323     function setCooldownEnabled(bool onoff) external onlyOwner() {
324         cooldownEnabled = onoff;
325     }
326     
327     function setSellCooldownEnabled(bool onoff) external onlyOwner() {
328         sellCooldownEnabled = onoff;
329     }
330 
331     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
332         require(rAmount <= _rTotal,"Amount must be less than total reflections");
333         uint256 currentRate = _getRate();
334         return rAmount.div(currentRate);
335     }
336     
337     function removeAllFee() private {
338         if (_whaleFee == 0 && _teamFee == 0) return;
339         _previousTeamFee = _teamFee;
340         _previousWhaleFee = _whaleFee;
341         _whaleFee = 0;
342         _teamFee = 0;
343     }
344 
345     function restoreAllFee() private {
346         _whaleFee = _previousWhaleFee;
347         _teamFee = _previousTeamFee;
348     }
349     
350     function setFee(uint256 multiplier) private {
351         
352         if (multiplier == 2 || multiplier == 4){
353             _whaleFee += 0;
354             _teamFee += 0;
355         }
356         if (multiplier == 1 || multiplier == 3){
357             _whaleFee += 4;
358             _teamFee += 1;
359         }
360     }
361 
362     function _approve(address owner, address spender, uint256 amount) private {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365         _allowances[owner][spender] = amount;
366         emit Approval(owner, spender, amount);
367     }
368 
369     function _transfer(address from, address to, uint256 amount) private {
370         require(from != address(0), "ERC20: transfer from the zero address");
371         require(to != address(0), "ERC20: transfer to the zero address");
372         require(amount > 0, "Transfer amount must be greater than zero");
373 
374         if (from != owner() && to != owner()) {
375             if (cooldownEnabled) { // only buys are allowed, if enabled
376                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
377                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Buys only");
378                 }
379             }
380             require(!bots[from] && !bots[to]);
381             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {//buys
382                 require(tradingOpen);
383                 require(!sellOnly, "Buys are disabled");
384                 require(amount <= _maxTxAmount);
385             }
386             uint256 contractTokenBalance = balanceOf(address(this));
387             if (!inSwap && from != uniswapV2Pair && swapEnabled && sellCooldownEnabled) { //sells, transfers (except for buys)
388                 require(amount <= balanceOf(uniswapV2Pair).mul(_priceImpact).div(100) && amount <= _maxTxAmount);
389                 require(sellcooldown[from] < block.timestamp);
390                 if(firstsell[from] + (1 days) < block.timestamp){
391                     sellnumber[from] = 0;
392                 }
393                 if (sellnumber[from] == 0) {
394                     sellnumber[from]++;
395                     firstsell[from] = block.timestamp;
396                     sellcooldown[from] = block.timestamp + (1 hours);
397                 }
398                 else if (sellnumber[from] == 1) {
399                     sellnumber[from]++;
400                     sellcooldown[from] = block.timestamp + (2 hours);
401                 }
402                 else if (sellnumber[from] == 2) {
403                     sellnumber[from]++;
404                     sellcooldown[from] = block.timestamp + (3 hours);
405                 }
406                 else if (sellnumber[from] == 3) {
407                     sellnumber[from]++;
408                     sellcooldown[from] = firstsell[from] + (1 days);
409                 }
410                 if (contractTokenBalance > 0) {
411                     swapTokensForEth(contractTokenBalance);
412                 }
413                 uint256 contractETHBalance = address(this).balance;
414                 if (contractETHBalance > 0) {
415                     sendETHToFee(address(this).balance);
416                 }
417                 if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
418                     setFee(sellnumber[from]);
419                 }
420             }
421         }
422         bool takeFee = true;
423 
424         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
425             takeFee = false;
426         }
427         
428         _tokenTransfer(from, to, amount, takeFee);
429         restoreAllFee();
430     }
431 
432     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
433         address[] memory path = new address[](2);
434         path[0] = address(this);
435         path[1] = uniswapV2Router.WETH();
436         _approve(address(this), address(uniswapV2Router), tokenAmount);
437         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
438     }
439 
440     function sendETHToFee(uint256 amount) private {
441         _teamAddress.transfer(amount.mul(_teamPercent).div(100));
442         _whaleAddress.transfer(amount.mul(_whalePercent).div(100));
443     }
444     
445     function openTrading() public onlyOwner {
446         require(liquidityAdded);
447         tradingOpen = true;
448     }
449     
450     function enableSellOnly() public onlyOwner {
451         sellOnly = true;
452         emit SellOnlyUpdated(sellOnly);
453     }
454     
455     function disableSellOnly() public onlyOwner {
456         sellOnly = false;
457         emit SellOnlyUpdated(sellOnly);
458     }
459 
460     function manualswap() external {
461         require(_msgSender() == _teamAddress);
462         uint256 contractBalance = balanceOf(address(this));
463         swapTokensForEth(contractBalance);
464     }
465 
466     function manualsend() external {
467         require(_msgSender() == _teamAddress);
468         uint256 contractETHBalance = address(this).balance;
469         sendETHToFee(contractETHBalance);
470     }
471 
472     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
473         if (!takeFee) removeAllFee();
474         if (sender == uniswapV2Pair){ //buy order, reflection, and lottery
475             _transferStandardBuy(sender, recipient, amount);
476         }
477         else {
478             _transferStandardSell(sender, recipient, amount); //take team and whale (no reflection, or lottery)
479         }
480         if (!takeFee) restoreAllFee();
481     }
482 
483     function _transferStandardBuy(address sender, address recipient, uint256 tAmount) private {
484         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 tTransferAmount, uint256 tLottery, uint256 tReflection) = _getValuesBuy(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeLottery(tLottery);
488         _reflectFee(rReflection, tReflection);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491     
492     function _takeLottery(uint256 tLottery) private {
493         uint256 currentRate = _getRate();
494         uint256 rLottery = tLottery.mul(currentRate);
495         _rOwned[_lotteryAddress] = _rOwned[_lotteryAddress].add(rLottery);
496         emit Transfer(address(this), _lotteryAddress, rLottery);
497     }
498 
499     function _reflectFee(uint256 rReflection, uint256 tReflection) private {
500         _rTotal = _rTotal.sub(rReflection);
501         _tFeeTotal = _tFeeTotal.add(tReflection);
502     }
503     
504     function _transferStandardSell(address sender, address recipient, uint256 tAmount) private {
505         (uint256 rAmount, uint256 rTransferAmount,, uint256 tTransferAmount, uint256 tTeam, uint256 tWhale) = _getValuesSell(tAmount);
506         _rOwned[sender] = _rOwned[sender].sub(rAmount);
507         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
508         _takeTeam(tTeam);
509         _takeWhale(tWhale);
510         emit Transfer(sender, recipient, tTransferAmount);
511     }
512 
513     function _takeTeam(uint256 tTeam) private {
514         uint256 currentRate = _getRate();
515         uint256 rTeam = tTeam.mul(currentRate);
516         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
517     }
518     
519     function _takeWhale(uint256 tWhale) private {
520         uint256 currentRate = _getRate();
521         uint256 rWhale = tWhale.mul(currentRate);
522         _rOwned[address(this)] = _rOwned[address(this)].add(rWhale);
523     }
524 
525     receive() external payable {}
526 
527     // Sell GetValues
528     function _getValuesSell(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
529         (uint256 tTransferAmount, uint256 tTeam, uint256 tWhale) = _getTValuesSell(tAmount, _teamFee, _whaleFee);
530         uint256 currentRate = _getRate();
531         (uint256 rAmount, uint256 rTransferAmount, uint256 rTeam) = _getRValuesSell(tAmount, tTeam, tWhale, currentRate);
532         return (rAmount, rTransferAmount, rTeam, tTransferAmount, tTeam, tWhale);
533     }
534 
535     function _getTValuesSell(uint256 tAmount, uint256 teamFee, uint256 whaleFee) private pure returns (uint256, uint256, uint256) {
536         uint256 tTeam = tAmount.mul(teamFee).div(100);
537         uint256 tWhale = tAmount.mul(whaleFee).div(100);
538         uint256 tTransferAmount = tAmount.sub(tTeam).sub(tWhale);
539         return (tTransferAmount, tTeam, tWhale);
540     }
541 
542     function _getRValuesSell(uint256 tAmount, uint256 tTeam, uint256 tWhale, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rWhale = tWhale.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rTeam).sub(rWhale);
547         return (rAmount, rTransferAmount, rTeam);
548     }
549 
550     // Buy GetValues
551     function _getValuesBuy(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
552         BuyBreakdown memory buyFees;
553         (buyFees.tTransferAmount, buyFees.tLottery, buyFees.tReflection) = _getTValuesBuy(tAmount, _lotteryFee, _reflectionFee);
554         uint256 currentRate = _getRate();
555         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection) = _getRValuesBuy(tAmount, buyFees.tLottery, buyFees.tReflection, currentRate);
556         return (rAmount, rTransferAmount, rReflection, buyFees.tTransferAmount, buyFees.tLottery, buyFees.tReflection);
557     }
558 
559     function _getTValuesBuy(uint256 tAmount, uint256 lotteryFee, uint256 reflectionFee) private pure returns (uint256, uint256, uint256) {
560         BuyBreakdown memory buyTFees;
561         
562         buyTFees.tLottery = tAmount.mul(lotteryFee).div(100);
563         buyTFees.tReflection = tAmount.mul(reflectionFee).div(100);
564         buyTFees.tTransferAmount = tAmount.sub(buyTFees.tLottery).sub(buyTFees.tReflection);
565         return (buyTFees.tTransferAmount, buyTFees.tLottery, buyTFees.tReflection);
566     }
567 
568     function _getRValuesBuy(uint256 tAmount, uint256 tLottery, uint256 tReflection, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
569         uint256 rAmount = tAmount.mul(currentRate);
570         uint256 rLottery = tLottery.mul(currentRate);
571         uint256 rReflection = tReflection.mul(currentRate);
572         uint256 rTransferAmount = rAmount.sub(rLottery).sub(rReflection);
573         return (rAmount, rTransferAmount, rReflection);
574     }
575     
576     function _getRate() private view returns (uint256) {
577         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
578         return rSupply.div(tSupply);
579     }
580 
581     function _getCurrentSupply() private view returns (uint256, uint256) {
582         uint256 rSupply = _rTotal;
583         uint256 tSupply = _tTotal;
584         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
585         return (rSupply, tSupply);
586     }
587     
588     function excludeFromFee(address account) public onlyOwner {
589         _isExcludedFromFee[account] = true;
590     }
591   
592     function includeInFee(address account) public onlyOwner {
593         _isExcludedFromFee[account] = false;
594     }
595 
596     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
597         require(maxTxPercent > 0, "Amount must be greater than 0");
598         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
599         emit MaxTxAmountUpdated(_maxTxAmount);
600     }
601     
602     function setPercents(uint256 teamPercent, uint256 whalePercent) external onlyOwner() {
603         require(teamPercent.add(whalePercent) == 100, "Sum of percents must equal 100");
604         _teamPercent = teamPercent;
605         _whalePercent = whalePercent;
606         emit PercentsUpdated(_teamPercent, _whalePercent);
607     }
608     
609     function setTaxes(uint256 whaleFee, uint256 teamFee, uint256 reflectionFee, uint256 lotteryFee) external onlyOwner() {
610         require(whaleFee.add(teamFee) < 50, "Sum of sell fees must be less than 50");
611         require(reflectionFee.add(lotteryFee) < 50, "Sum of buy fees must be less than 50");
612         _whaleFee = whaleFee;
613         _teamFee = teamFee;
614         _reflectionFee = reflectionFee;
615         _lotteryFee = lotteryFee;
616         emit FeesUpdated(_whaleFee, _teamFee, _reflectionFee, _lotteryFee);
617     }
618     
619     function setPriceImpact(uint256 priceImpact) external onlyOwner() {
620         require(priceImpact < 10, "max price impact must be less than 10");
621         _priceImpact = priceImpact;
622         emit PriceImpactUpdated(_priceImpact);
623     }
624 }