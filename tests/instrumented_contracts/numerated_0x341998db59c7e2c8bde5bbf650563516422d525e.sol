1 /**
2  * 
3  * $DINJA - DOGE NINJA SAMURAI
4  *
5  * 
6  * 
7  * 💻 Website: https://dinjatoken.com/
8  * 💬 Telegram: http://t.me/dinjatoken
9  * 🐦 Twitter: https://twitter.com/DinjaToken
10  *
11  *
12  * ██████╗░██╗███╗░░██╗░░░░░██╗░█████╗░
13  * ██╔══██╗██║████╗░██║░░░░░██║██╔══██╗
14  * ██║░░██║██║██╔██╗██║░░░░░██║███████║
15  * ██║░░██║██║██║╚████║██╗░░██║██╔══██║
16  * ██████╔╝██║██║░╚███║╚█████╔╝██║░░██║
17  * ╚═════╝░╚═╝╚═╝░░╚══╝░╚════╝░╚═╝░░╚═╝
18  * 
19  *          ▄              ▄    
20  *         ▌▒█           ▄▀▒▌   
21  *         ▌▒▒█        ▄▀▒▒▒▐   
22  *        ▐▄█▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐   
23  *      ▄▄▀▒▒▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐   
24  *    ▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌   
25  *   ▐▒▒▒▄▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄▒▌  
26  *   ▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐  
27  *  ▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌ 
28  *  ▌░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌ 
29  * ▌▒▒▒▄██▄▒▒▒▒▒▒▒▒░░░░░░░░▒▒▒▐ 
30  * ▐▒▒▐▄█▄█▌▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
31  * ▐▒▒▐▀▐▀▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▐ 
32  *  ▌▒▒▀▄▄▄▄▄▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▒▌ 
33  *  ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒▒▄▒▒▐  
34  *   ▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒▄▒▒▒▒▌  
35  *     ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀   
36  *       ▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀     
37  *          ▀▀▀▀▀▀▀▀▀▀▀▀        
38  *
39  * 
40  * Tokenomics:
41  * 
42  * Normal Buy Tax = 10% 
43  * Normal Sell Tax = 10%
44  * Early snipers/movers advantage will be limited.
45  * Anti-dump Tokenomics where sell tax will be proportional to price impact
46  * 
47  * 10% of all taxes collected will be redistributed to reward the holders
48  *
49  * Max Tx at the start - 0.5% of the supply, Max Wallet 1.5% 
50  * Tax will keep reducing by 1% every 400 transactions to make it more affordable 
51  * and long-term growth of the project 
52  * 
53  * 
54  * SPDX-License-Identifier: UNLICENSED 
55  * 
56 */
57 
58 pragma solidity ^0.8.4;
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 }
65 
66 interface IERC20 {
67     function totalSupply() external view returns (uint256);
68     function balanceOf(address account) external view returns (uint256);
69     function transfer(address recipient, uint256 amount) external returns (bool);
70     function allowance(address owner, address spender) external view returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if(a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b > 0, errorMessage);
109         uint256 c = a / b;
110         return c;
111     }
112 
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b != 0, errorMessage);
119         return a % b;
120     }
121 }
122 
123 contract Ownable is Context {
124     address private _owner;
125     address private _previousOwner;
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     constructor () {
129         address msgSender = _msgSender();
130         _owner = msgSender;
131         emit OwnershipTransferred(address(0), msgSender);
132     }
133 
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     modifier onlyOwner() {
139         require(_owner == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     function renounceOwnership() public virtual onlyOwner {
144         emit OwnershipTransferred(_owner, address(0));
145         _owner = address(0);
146     }
147 
148 }  
149 
150 interface IUniswapV2Factory {
151     function createPair(address tokenA, address tokenB) external returns (address pair);
152 }
153 
154 interface IUniswapV2Router02 {
155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external;
162     function factory() external pure returns (address);
163     function WETH() external pure returns (address);
164     function addLiquidityETH(
165         address token,
166         uint amountTokenDesired,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline
171     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
172 }
173 
174 contract DINJA is Context, IERC20, Ownable {
175     using SafeMath for uint256;
176     mapping (address => uint256) private _rOwned;
177     mapping (address => uint256) private _tOwned;
178     mapping (address => mapping (address => uint256)) private _allowances;
179     mapping (address => bool) private _isExcludedFromFee;
180     mapping (address => bool) private _bots;
181     mapping (address => User) private trader;
182     uint256 private constant MAX = ~uint256(0);
183     uint256 private constant _tTotal = 1000000000000 * 10**9;
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186     string private constant _name = unicode"DOGE NINJA SAMURAI";
187     string private constant _symbol = unicode"DINJA";
188     uint8 private constant _decimals = 9;
189     uint256 private _taxFee = 1;
190     uint256 private _teamFee = 6;
191     uint256 private _launchTime;
192     uint256 private _previousTaxFee = _taxFee;
193     uint256 private _previousteamFee = _teamFee;
194     // uint256 private _maxBuyAmount;
195     address payable private _FeeAddress;
196     address payable private _marketingWalletAddress;
197     IUniswapV2Router02 private uniswapV2Router;
198     address private uniswapV2Pair;
199     bool private tradingOpen = false;
200     // bool private _cooldownEnabled = true;
201     bool private _communityMode = false;
202     bool private inSwap = false;
203     uint256 private _launchBlock = 0;
204     // uint256 private buyLimitEnd;
205     uint256 private _snipersTaxed = 0;
206     uint256 private _transactionCount = 0;
207     uint256 private _impactMultiplier = 1000;
208     bool public swapAndLiquifyEnabled = true;
209     uint256 private discountTaxFee = 0;
210 
211     //Keep it 0.5% of the supply
212     uint256 public _maxTxAmount = 1000000000000 * 10**9;
213     //1.5% of the supply
214     uint256 public _maxWallet = 15000000000 * 10**9;
215 
216     uint256 public numTokensSellToAddToLiquidity = 2000000000 * 10**9;
217 
218 
219     struct User {
220         uint256 buyCD;
221         bool exists;
222     }
223 
224     // event MaxBuyAmountUpdated(uint _maxBuyAmount);
225     event CooldownEnabledUpdated(bool _cooldown);
226     event FeeMultiplierUpdated(uint _multiplier);
227     event FeeRateUpdated(uint _rate);
228 
229     event SwapAndLiquifyEnabledUpdated(bool enabled);
230     event SwapAndLiquify(
231         uint256 tokensSwapped,
232         uint256 ethReceived,
233         uint256 tokensIntoLiqudity
234     );
235 
236     modifier lockTheSwap {
237         inSwap = true;
238         _;
239         inSwap = false;
240     }
241     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
242         _FeeAddress = FeeAddress;
243         _marketingWalletAddress = marketingWalletAddress;
244         _rOwned[_msgSender()] = _rTotal;
245         _isExcludedFromFee[owner()] = true;
246         _isExcludedFromFee[address(this)] = true;
247         _isExcludedFromFee[FeeAddress] = true;
248         _isExcludedFromFee[marketingWalletAddress] = true;
249         emit Transfer(address(0), _msgSender(), _tTotal);
250     }
251 
252     function name() public pure returns (string memory) {
253         return _name;
254     }
255 
256     function symbol() public pure returns (string memory) {
257         return _symbol;
258     }
259 
260     function decimals() public pure returns (uint8) {
261         return _decimals;
262     }
263 
264     function totalSupply() public pure override returns (uint256) {
265         return _tTotal;
266     }
267 
268     function snipersTaxed() public view returns (uint256) {
269         return _snipersTaxed;
270     }
271 
272     function taxDiscount() public view returns (uint256) {
273         return discountTaxFee;
274     }
275 
276     function transactionCount() public view returns (uint256) {
277         return _transactionCount;
278     }
279 
280     function balanceOf(address account) public view override returns (uint256) {
281         return tokenFromReflection(_rOwned[account]);
282     }
283 
284     function transfer(address recipient, uint256 amount) public override returns (bool) {
285         _transfer(_msgSender(), recipient, amount);
286         return true;
287     }
288 
289     function allowance(address owner, address spender) public view override returns (uint256) {
290         return _allowances[owner][spender];
291     }
292 
293     function approve(address spender, uint256 amount) public override returns (bool) {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297 
298     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
299         _transfer(sender, recipient, amount);
300         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
301         return true;
302     }
303 
304     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
305         require(rAmount <= _rTotal, "Amount must be less than total reflections");
306         uint256 currentRate =  _getRate();
307         return rAmount.div(currentRate);
308     }
309 
310     function removeAllFee() private {
311         if(_taxFee == 0 && _teamFee == 0) return;
312         _previousTaxFee = _taxFee;
313         _previousteamFee = _teamFee;
314         _taxFee = 0;
315         _teamFee = 0;
316     }
317     
318     function restoreAllFee() private {
319         _taxFee = _previousTaxFee;
320         _teamFee = _previousteamFee;
321     }
322 
323     function _approve(address owner, address spender, uint256 amount) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329     
330     function _transfer(address from, address to, uint256 amount) private {
331         require(from != address(0), "ERC20: transfer from the zero address");
332         require(to != address(0), "ERC20: transfer to the zero address");
333         require(amount > 0, "Transfer amount must be greater than zero");
334         if(from != owner() && to != owner()) {
335             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
336             require(!_bots[from] && !_bots[to]);
337             
338             if(!trader[msg.sender].exists) {
339                 trader[msg.sender] = User(0,true);
340             }
341             uint256 totalFee = 10;
342             // buy
343             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
344                 require(tradingOpen, "Trading not yet enabled.");
345                 require(amount + balanceOf(to) <= _maxWallet, "Cannot exceed max wallet");
346 
347                 if(block.number < _launchBlock + 2) {
348                     totalFee = 80;
349                     _snipersTaxed++;
350                 } else if(block.timestamp > _launchTime + (2 minutes)) {
351                     totalFee = 10;
352                 } else if (block.timestamp > _launchTime + (45 seconds)) {
353                     totalFee = 20;
354                 } else {
355                     totalFee = 40;
356                 }
357                 totalFee = totalFee - discountTaxFee;
358                 _taxFee = (totalFee).div(10);
359                 _teamFee = (totalFee.mul(9)).div(10);
360                 
361             }
362             uint256 contractTokenBalance = balanceOf(address(this));
363 
364             // sell
365             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
366 
367                 //price impact based sell tax
368                 uint256 amountImpactMultiplier = amount.mul(_impactMultiplier);
369                 uint256 priceImpact = amountImpactMultiplier.div(balanceOf(uniswapV2Pair).add(amount));
370                 
371                 if (priceImpact <= 10) {
372                     totalFee = 10;
373                 } else if (priceImpact >= 40) {
374                     totalFee = 40;
375                 } else if (priceImpact.mod(2) != 0) {
376                     totalFee = ++priceImpact;
377                 } else {
378                     totalFee = priceImpact;
379                 }
380                 
381                 totalFee = totalFee - discountTaxFee;
382 
383                 _taxFee = (totalFee).div(10);
384                 _teamFee = (totalFee.mul(9)).div(10);
385 
386                 //To limit big dumps by the contract before the sells
387                 if(contractTokenBalance >= _maxTxAmount) {
388                     contractTokenBalance = _maxTxAmount;
389                 }
390 
391                 // bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
392                 if (contractTokenBalance >= numTokensSellToAddToLiquidity) {
393                     swapTokensForEth(numTokensSellToAddToLiquidity);
394                 }
395 
396                 uint256 contractETHBalance = address(this).balance;
397                 if(contractETHBalance > 0) {
398                     sendETHToFee(address(this).balance);
399                 }
400             }
401         }
402         bool takeFee = true;
403 
404         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _communityMode){
405             takeFee = false;
406         }
407         
408         _tokenTransfer(from,to,amount,takeFee);
409     }
410 
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424         
425     function sendETHToFee(uint256 amount) private {
426         _marketingWalletAddress.transfer(amount);
427     }
428     
429     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
430         if(!takeFee)
431             removeAllFee();
432         _transferStandard(sender, recipient, amount);
433         if(!takeFee)
434             restoreAllFee();
435         _transactionCount++;
436         if (_transactionCount.mod(400) == 0) {
437             if (discountTaxFee < 8) {
438                 discountTaxFee++;
439             }
440         }
441     }
442 
443     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
444         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
445         _rOwned[sender] = _rOwned[sender].sub(rAmount);
446         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
447 
448         _takeTeam(tTeam);
449         _reflectFee(rFee, tFee);
450         emit Transfer(sender, recipient, tTransferAmount);
451     }
452 
453     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
454         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
455         uint256 currentRate =  _getRate();
456         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
457         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
458     }
459 
460     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
461         uint256 tFee = tAmount.mul(taxFee).div(100);
462         uint256 tTeam = tAmount.mul(TeamFee).div(100);
463         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
464         return (tTransferAmount, tFee, tTeam);
465     }
466 
467     function _getRate() private view returns(uint256) {
468         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
469         return rSupply.div(tSupply);
470     }
471 
472     function _getCurrentSupply() private view returns(uint256, uint256) {
473         uint256 rSupply = _rTotal;
474         uint256 tSupply = _tTotal;
475         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
476         return (rSupply, tSupply);
477     }
478 
479     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
480         uint256 rAmount = tAmount.mul(currentRate);
481         uint256 rFee = tFee.mul(currentRate);
482         uint256 rTeam = tTeam.mul(currentRate);
483         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
484         return (rAmount, rTransferAmount, rFee);
485     }
486 
487     function _takeTeam(uint256 tTeam) private {
488         uint256 currentRate =  _getRate();
489         uint256 rTeam = tTeam.mul(currentRate);
490 
491         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
492     }
493 
494     function _reflectFee(uint256 rFee, uint256 tFee) private {
495         _rTotal = _rTotal.sub(rFee);
496         _tFeeTotal = _tFeeTotal.add(tFee);
497     }
498 
499     receive() external payable {}
500     
501     function openTrading() external onlyOwner() {
502         require(!tradingOpen,"trading is already open");
503         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
504         uniswapV2Router = _uniswapV2Router;
505         _approve(address(this), address(uniswapV2Router), _tTotal);
506         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
507         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
508         _maxTxAmount = 5000000001 * 10**9;
509         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
510         tradingOpen = true;
511         _launchTime = block.timestamp;
512         _launchBlock = block.number;
513     }
514 
515     function setMarketingWallet (address payable marketingWalletAddress) external {
516         require(_msgSender() == _FeeAddress);
517         _isExcludedFromFee[_marketingWalletAddress] = false;
518         _marketingWalletAddress = marketingWalletAddress;
519         _isExcludedFromFee[marketingWalletAddress] = true;
520     }
521 
522     function removeTransactionLimits() external onlyOwner() {
523         //Meaning no max limits on transaction, guardrail of maxWallet will come into picture
524         _maxTxAmount = 1000000000000 * 10**9;
525     }
526 
527     function increaseMaxWallet() external onlyOwner() {
528         //Max wallet increased to 2% of the supply if at all it is ever required
529         _maxWallet = 20000000000 * 10**9;
530     }
531 
532     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
533         require(SwapThresholdAmount > 1000000000, "Swap Threshold Amount cannot be less than 1 Billion");
534         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
535     }
536     
537     function claimTokens () public onlyOwner {
538         payable(_marketingWalletAddress).transfer(address(this).balance);
539     }
540     
541     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
542         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
543     }
544     
545     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
546         walletaddress.transfer(address(this).balance);
547     }
548 
549     function excludeFromFee (address payable ad) external {
550         require(_msgSender() == _FeeAddress);
551         _isExcludedFromFee[ad] = true;
552     }
553     
554     function includeToFee (address payable ad) external {
555         require(_msgSender() == _FeeAddress);
556         _isExcludedFromFee[ad] = false;
557     }
558     
559     function setBots(address[] memory bots_) public onlyOwner {
560         //Cannot set bots after 20 minutes of launch time making users fund SAFU
561         if (block.timestamp < _launchTime + (20 minutes)) {
562             for (uint i = 0; i < bots_.length; i++) {
563                 if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
564                     _bots[bots_[i]] = true;
565                 }
566             }
567         }
568     }
569     
570     function delBot(address notbot) public onlyOwner {
571         _bots[notbot] = false;
572     }
573     
574     function isBot(address ad) public view returns (bool) {
575         return _bots[ad];
576     }
577     
578     function thisBalance() public view returns (uint) {
579         return balanceOf(address(this));
580     }
581 
582     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
583         // approve token transfer to cover all possible scenarios
584         _approve(address(this), address(uniswapV2Router), tokenAmount);
585 
586         // add the liquidity
587         uniswapV2Router.addLiquidityETH{value: ethAmount}(
588             address(this),
589             tokenAmount,
590             0, // slippage is unavoidable
591             0, // slippage is unavoidable
592             owner(),
593             block.timestamp
594         );
595     }
596 
597     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
598         swapAndLiquifyEnabled = _enabled;
599         emit SwapAndLiquifyEnabledUpdated(_enabled);
600     }
601 
602     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
603         // split the contract balance into halves
604         // add the marketing wallet
605         uint256 half = contractTokenBalance.div(2);
606         uint256 otherHalf = contractTokenBalance.sub(half);
607 
608         // capture the contract's current ETH balance.
609         // this is so that we can capture exactly the amount of ETH that the
610         // swap creates, and not make the liquidity event include any ETH that
611         // has been manually sent to the contract
612         uint256 initialBalance = address(this).balance;
613 
614         // swap tokens for ETH
615         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
616 
617         // how much ETH did we just swap into?
618         uint256 newBalance = address(this).balance.sub(initialBalance);
619         //90
620         uint256 marketingshare = newBalance.mul(80).div(100);
621         payable(_marketingWalletAddress).transfer(marketingshare);
622         newBalance -= marketingshare;
623         // add liquidity to uniswap
624         addLiquidity(otherHalf, newBalance);
625         
626         emit SwapAndLiquify(half, newBalance, otherHalf);
627     }
628 
629     function timeToBuy(address buyer) public view returns (uint) {
630         return block.timestamp - trader[buyer].buyCD;
631     }
632     
633     function amountInPool() public view returns (uint) {
634         return balanceOf(uniswapV2Pair);
635     }
636 }