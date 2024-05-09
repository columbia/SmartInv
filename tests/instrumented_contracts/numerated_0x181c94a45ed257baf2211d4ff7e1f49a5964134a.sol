1 /**
2  * 
3  * $METASHIB - META SHIB TOKEN
4  * TG: https://t.me/metashibtoken
5  * 
6  * 
7  * 💻 Website: https://metashib.space/
8  * 💬 Telegram: https://t.me/MetaShibToken
9  * 🐦 Twitter: https://twitter.com/MetaShibETH
10  * 
11  * 
12  * 
13  * ┏━┓┏━┳━━━┳━━━━┳━━━┳━━━┳┓╋┏┳━━┳━━┓
14  * ┃┃┗┛┃┃┏━━┫┏┓┏┓┃┏━┓┃┏━┓┃┃╋┃┣┫┣┫┏┓┃
15  * ┃┏┓┏┓┃┗━━╋┛┃┃┗┫┃╋┃┃┗━━┫┗━┛┃┃┃┃┗┛┗┓
16  * ┃┃┃┃┃┃┏━━┛╋┃┃╋┃┗━┛┣━━┓┃┏━┓┃┃┃┃┏━┓┃
17  * ┃┃┃┃┃┃┗━━┓╋┃┃╋┃┏━┓┃┗━┛┃┃╋┃┣┫┣┫┗━┛┃
18  * ┗┛┗┛┗┻━━━┛╋┗┛╋┗┛╋┗┻━━━┻┛╋┗┻━━┻━━━┛
19  * 
20  * Tokenomics:
21  * 
22  * Tax is only 10% but balances to reach a state of equilibrium
23  * 
24  * BLUE MODE - BUY tax is 2% for 5 minutes if one of following is met:
25  * - 5 consecutive sells
26  * - a single sell of 2% price impact 
27  * 
28  * RED MODE - SELL TAX increased to 20% for 5 minutes if one of following is met:
29  * - 5 consecutive buys
30  * - a single buy of 2% price impact 
31  * 
32  * Redistribution - 10% of all collected fees
33  * 
34  * Limiting Snipers/Early Movers Advantage 
35  * 
36  * SPDX-License-Identifier: UNLICENSED 
37  * 
38 */
39 
40 pragma solidity ^0.8.4;
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 library SafeMath {
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if(a == 0) {
78             return 0;
79         }
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b > 0, errorMessage);
91         uint256 c = a / b;
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107     address private _previousOwner;
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     constructor () {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 
130 }  
131 
132 interface IUniswapV2Factory {
133     function createPair(address tokenA, address tokenB) external returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144     function factory() external pure returns (address);
145     function WETH() external pure returns (address);
146     function addLiquidityETH(
147         address token,
148         uint amountTokenDesired,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
154 }
155 
156 contract MetaShib is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158     mapping (address => uint256) private _rOwned;
159     mapping (address => uint256) private _tOwned;
160     mapping (address => mapping (address => uint256)) private _allowances;
161     mapping (address => bool) private _isExcludedFromFee;
162     mapping (address => bool) private _bots;
163     mapping (address => User) private trader;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 1e12 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     string private constant _name = unicode"MetaShib Token";
169     string private constant _symbol = unicode"METASHIB";
170     uint8 private constant _decimals = 9;
171     uint256 private _taxFee = 1;
172     uint256 private _teamFee = 6;
173     uint256 private _launchTime;
174     uint256 private _previousTaxFee = _taxFee;
175     uint256 private _previousteamFee = _teamFee;
176     uint256 private _maxBuyAmount;
177     address payable private _FeeAddress;
178     address payable private _marketingWalletAddress;
179     IUniswapV2Router02 private uniswapV2Router;
180     address private uniswapV2Pair;
181     bool private tradingOpen = false;
182     bool private _cooldownEnabled = true;
183     bool private _communityMode = false;
184     bool private inSwap = false;
185     uint256 private launchBlock = 0;
186     uint256 private buyLimitEnd;
187     uint256 private redmode = 0;
188     uint256 private bluemode = 0;
189     uint256 private consecutiveBuyCounter = 0;
190     uint256 private consecutiveSellCounter = 0;
191     struct User {
192         uint256 buyCD;
193         bool exists;
194     }
195 
196     event MaxBuyAmountUpdated(uint _maxBuyAmount);
197     event CooldownEnabledUpdated(bool _cooldown);
198     event FeeMultiplierUpdated(uint _multiplier);
199     event FeeRateUpdated(uint _rate);
200 
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
207         _FeeAddress = FeeAddress;
208         _marketingWalletAddress = marketingWalletAddress;
209         _rOwned[_msgSender()] = _rTotal;
210         _isExcludedFromFee[owner()] = true;
211         _isExcludedFromFee[address(this)] = true;
212         _isExcludedFromFee[FeeAddress] = true;
213         _isExcludedFromFee[marketingWalletAddress] = true;
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public pure returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public pure returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public pure override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return tokenFromReflection(_rOwned[account]);
235     }
236 
237     function transfer(address recipient, uint256 amount) public override returns (bool) {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     function allowance(address owner, address spender) public view override returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     function approve(address spender, uint256 amount) public override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
254         return true;
255     }
256 
257     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
258         require(rAmount <= _rTotal, "Amount must be less than total reflections");
259         uint256 currentRate =  _getRate();
260         return rAmount.div(currentRate);
261     }
262 
263     function removeAllFee() private {
264         if(_taxFee == 0 && _teamFee == 0) return;
265         _previousTaxFee = _taxFee;
266         _previousteamFee = _teamFee;
267         _taxFee = 0;
268         _teamFee = 0;
269     }
270     
271     function restoreAllFee() private {
272         _taxFee = _previousTaxFee;
273         _teamFee = _previousteamFee;
274     }
275 
276     function _approve(address owner, address spender, uint256 amount) private {
277         require(owner != address(0), "ERC20: approve from the zero address");
278         require(spender != address(0), "ERC20: approve to the zero address");
279         _allowances[owner][spender] = amount;
280         emit Approval(owner, spender, amount);
281     }
282     
283     function _transfer(address from, address to, uint256 amount) private {
284         require(from != address(0), "ERC20: transfer from the zero address");
285         require(to != address(0), "ERC20: transfer to the zero address");
286         require(amount > 0, "Transfer amount must be greater than zero");
287 
288         if(from != owner() && to != owner()) {
289             
290             require(!_bots[from] && !_bots[to]);
291             
292             if(!trader[msg.sender].exists) {
293                 trader[msg.sender] = User(0,true);
294             }
295             uint256 totalFee = 2;
296             // buy
297             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
298                 require(tradingOpen, "Trading not yet enabled.");
299                 
300                 if(block.timestamp > _launchTime + (2 minutes)) {
301                     if (bluemode > block.timestamp) {
302                         totalFee = 2;
303                     } else {
304                         totalFee = 10;
305                     }
306                 } else if (block.timestamp > _launchTime + (1 minutes)) {
307                     totalFee = 20;
308                 } else {
309                     totalFee = 40;
310                 }
311                 
312                 _taxFee = (totalFee).div(10);
313                 _teamFee = (totalFee.mul(9)).div(10);
314                 
315                 if(_cooldownEnabled) {
316                     if(buyLimitEnd > block.timestamp) {
317                         require(amount <= _maxBuyAmount);
318                         require(trader[to].buyCD < block.timestamp, "Your buy cooldown has not expired.");
319                         trader[to].buyCD = block.timestamp + (45 seconds);
320                     }
321                 }
322                 
323                 if (amount >= balanceOf(uniswapV2Pair).mul(2).div(100)) {
324                     redmode = block.timestamp + (5 minutes);
325                 }
326                 
327                 if (consecutiveBuyCounter >= 5) {
328                     redmode = block.timestamp + (5 minutes);
329                     consecutiveBuyCounter = 0;
330                 } else {
331                     consecutiveBuyCounter++;
332                 }
333                 
334                 consecutiveSellCounter = 0;
335                 
336             }
337             uint256 contractTokenBalance = balanceOf(address(this));
338 
339             // sell
340             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
341                 
342                 if (redmode > block.timestamp) {
343                     totalFee = 20;
344                 } else {
345                     totalFee = 10;
346                 }
347                 
348                 _taxFee = (totalFee).div(10);
349                 _teamFee = (totalFee.mul(9)).div(10);
350 
351                 //To limit big dumps by the contract before the sells
352                 if(contractTokenBalance > 0) {
353                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(6).div(100)) {
354                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(6).div(100);
355                     }
356                     swapTokensForEth(contractTokenBalance);
357                 }
358                 uint256 contractETHBalance = address(this).balance;
359                 if(contractETHBalance > 0) {
360                     sendETHToFee(address(this).balance);
361                 }
362                 
363                 if (amount >= balanceOf(uniswapV2Pair).mul(2).div(100)) { 
364                     bluemode = block.timestamp + (5 minutes);
365                 }
366                 
367                 if (consecutiveSellCounter >= 5) {
368                     bluemode = block.timestamp + (5 minutes);
369                     consecutiveSellCounter = 0;
370                 } else {
371                     consecutiveSellCounter++;
372                 }
373                 
374                 consecutiveBuyCounter = 0;
375             }
376         }
377         bool takeFee = true;
378 
379         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _communityMode){
380             takeFee = false;
381         }
382         
383         _tokenTransfer(from,to,amount,takeFee);
384     }
385 
386     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
387         address[] memory path = new address[](2);
388         path[0] = address(this);
389         path[1] = uniswapV2Router.WETH();
390         _approve(address(this), address(uniswapV2Router), tokenAmount);
391         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             tokenAmount,
393             0,
394             path,
395             address(this),
396             block.timestamp
397         );
398     }
399         
400     function sendETHToFee(uint256 amount) private {
401         _FeeAddress.transfer(amount.div(2));
402         _marketingWalletAddress.transfer(amount.div(2));
403     }
404     
405     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
406         if(!takeFee)
407             removeAllFee();
408         _transferStandard(sender, recipient, amount);
409         if(!takeFee)
410             restoreAllFee();
411     }
412 
413     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
414         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
415         _rOwned[sender] = _rOwned[sender].sub(rAmount);
416         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
417 
418         _takeTeam(tTeam);
419         _reflectFee(rFee, tFee);
420         emit Transfer(sender, recipient, tTransferAmount);
421     }
422 
423     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
424         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
425         uint256 currentRate =  _getRate();
426         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
427         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
428     }
429 
430     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
431         uint256 tFee = tAmount.mul(taxFee).div(100);
432         uint256 tTeam = tAmount.mul(TeamFee).div(100);
433         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
434         return (tTransferAmount, tFee, tTeam);
435     }
436 
437     function _getRate() private view returns(uint256) {
438         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
439         return rSupply.div(tSupply);
440     }
441 
442     function _getCurrentSupply() private view returns(uint256, uint256) {
443         uint256 rSupply = _rTotal;
444         uint256 tSupply = _tTotal;
445         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
446         return (rSupply, tSupply);
447     }
448 
449     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
450         uint256 rAmount = tAmount.mul(currentRate);
451         uint256 rFee = tFee.mul(currentRate);
452         uint256 rTeam = tTeam.mul(currentRate);
453         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
454         return (rAmount, rTransferAmount, rFee);
455     }
456 
457     function _takeTeam(uint256 tTeam) private {
458         uint256 currentRate =  _getRate();
459         uint256 rTeam = tTeam.mul(currentRate);
460 
461         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
462     }
463 
464     function _reflectFee(uint256 rFee, uint256 tFee) private {
465         _rTotal = _rTotal.sub(rFee);
466         _tFeeTotal = _tFeeTotal.add(tFee);
467     }
468 
469     receive() external payable {}
470     
471     function openTrading() external onlyOwner() {
472         require(!tradingOpen,"trading is already open");
473         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
474         uniswapV2Router = _uniswapV2Router;
475         _approve(address(this), address(uniswapV2Router), _tTotal);
476         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
477         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
478         _maxBuyAmount = 5000000000 * 10**9;
479         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
480         tradingOpen = true;
481         buyLimitEnd = block.timestamp + (20 seconds);
482         _launchTime = block.timestamp;
483     }
484 
485     function setMarketingWallet (address payable marketingWalletAddress) external {
486         require(_msgSender() == _FeeAddress);
487         _isExcludedFromFee[_marketingWalletAddress] = false;
488         _marketingWalletAddress = marketingWalletAddress;
489         _isExcludedFromFee[marketingWalletAddress] = true;
490     }
491     
492     function excludeFromFee (address payable ad) external {
493         require(_msgSender() == _FeeAddress);
494         _isExcludedFromFee[ad] = true;
495     }
496     
497     function includeToFee (address payable ad) external {
498         require(_msgSender() == _FeeAddress);
499         _isExcludedFromFee[ad] = false;
500     }
501     
502     function setBots(address[] memory bots_) public onlyOwner {
503         for (uint i = 0; i < bots_.length; i++) {
504             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
505                 _bots[bots_[i]] = true;
506             }
507         }
508     }
509     
510     function delBot(address notbot) public onlyOwner {
511         _bots[notbot] = false;
512     }
513     
514     function isBot(address ad) public view returns (bool) {
515         return _bots[ad];
516     }
517     
518     function isRedMode() public view returns (bool) {
519         return (redmode > block.timestamp);
520     }
521     
522     function isBlueMode() public view returns (bool) {
523         return (bluemode > block.timestamp);
524     }
525 
526     function setCooldownEnabled(bool onoff) external onlyOwner() {
527         _cooldownEnabled = onoff;
528         emit CooldownEnabledUpdated(_cooldownEnabled);
529     }
530 
531     function thisBalance() public view returns (uint) {
532         return balanceOf(address(this));
533     }
534 
535     function cooldownEnabled() public view returns (bool) {
536         return _cooldownEnabled;
537     }
538 
539     function timeToBuy(address buyer) public view returns (uint) {
540         return block.timestamp - trader[buyer].buyCD;
541     }
542     
543     function amountInPool() public view returns (uint) {
544         return balanceOf(uniswapV2Pair);
545     }
546 }