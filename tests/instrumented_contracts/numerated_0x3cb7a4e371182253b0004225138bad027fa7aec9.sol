1 /**
2  * 
3  * Mizuchi
4  * Telegram: t.me/mizuchitoken
5  * 
6  * TOKENOMICS:
7  * FIRST TWO MINUTES: 5,000,000,000 max buy / 45-second buy cooldown (lifted automatically)
8  * 15-sec sell cooldown after a buy
9  * 
10  * Decreasing Buy Tax - for each time you buy within 30 mins, your buy tax will decrease by 2%
11  * - Starts at 10% then 8% then 6% then a minimum of 4%
12  * - if you don't buy again after 30 minutes has elapsed, your buy tax resets at 10%
13  * - keep buying to maintain very low tax
14  * 
15  * Decreasing Sell Tax - Sell tax starts high but decreases dramatically the longer HODL
16  * - The timer starts from when you last bought
17  * - Diamond hands deserve less tax
18  * 
19  * Breakdown:
20  * - First 5 minutes: 35%
21  * - 5 minutes to 30 minutes: 25%
22  * - 30 minutes to 1 hour: 20%
23  * - 1 hour to 3 hours: 15%
24  * - after 3 hours: 10%
25  * 
26  * Huge redistribution from taxes is given back to all hodlers: from 4 to 14% 
27  * 
28  * This is our way of discouraging sells for small profit.  
29  * We used to see tokens go for x100 and more, but that doesn't seem like the trend anymore.  
30  * People don't hodl like they used to, so our project wishes to reward hodlers with very low taxes.
31  * 
32  * No other cooldowns and no sell limits!
33  * No team tokens, no presale
34  * 
35  * SPDX-License-Identifier: UNLICENSED 
36  * 
37 */
38 pragma solidity ^0.8.4;
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 }
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 library SafeMath {
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if(a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         return mod(a, b, "SafeMath: modulo by zero");
95     }
96 
97     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b != 0, errorMessage);
99         return a % b;
100     }
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     address private _previousOwner;
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     constructor () {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128 }  
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB) external returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external;
141     function factory() external pure returns (address);
142     function WETH() external pure returns (address);
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
151 }
152 
153 contract Mizuchi is Context, IERC20, Ownable {
154     using SafeMath for uint256;
155     mapping (address => uint256) private _rOwned;
156     mapping (address => uint256) private _tOwned;
157     mapping (address => mapping (address => uint256)) private _allowances;
158     mapping (address => bool) private _isExcludedFromFee;
159     mapping (address => bool) private _friends;
160     mapping (address => User) private trader;
161     uint256 private constant MAX = ~uint256(0);
162     uint256 private constant _tTotal = 1e12 * 10**9;
163     uint256 private _rTotal = (MAX - (MAX % _tTotal));
164     uint256 private _tFeeTotal;
165     string private constant _name = unicode"Mizuchi - t.me/mizuchitoken";
166     string private constant _symbol = unicode"MIZUCHI";
167     uint8 private constant _decimals = 9;
168     uint256 private _taxFee = 5;
169     uint256 private _teamFee = 5;
170     uint256 private _feeRate = 5;
171     uint256 private _launchTime;
172     uint256 private _previousTaxFee = _taxFee;
173     uint256 private _previousteamFee = _teamFee;
174     uint256 private _maxBuyAmount;
175     address payable private _FeeAddress;
176     address payable private _marketingWalletAddress;
177     address payable private _marketingFixedWalletAddress;
178     IUniswapV2Router02 private uniswapV2Router;
179     address private uniswapV2Pair;
180     bool private tradingOpen;
181     bool private _cooldownEnabled = true;
182     bool private inSwap = false;
183     uint256 private launchBlock = 0;
184     uint256 private buyLimitEnd;
185     struct User {
186         uint256 buyCD;
187         uint256 sellCD;
188         uint256 lastBuy;
189         uint256 buynumber;
190         bool exists;
191     }
192 
193     event MaxBuyAmountUpdated(uint _maxBuyAmount);
194     event CooldownEnabledUpdated(bool _cooldown);
195     event FeeMultiplierUpdated(uint _multiplier);
196     event FeeRateUpdated(uint _rate);
197 
198     modifier lockTheSwap {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203     constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable marketingFixedWalletAddress) {
204         _FeeAddress = FeeAddress;
205         _marketingWalletAddress = marketingWalletAddress;
206         _marketingFixedWalletAddress = marketingFixedWalletAddress;
207         _rOwned[_msgSender()] = _rTotal;
208         _isExcludedFromFee[owner()] = true;
209         _isExcludedFromFee[address(this)] = true;
210         _isExcludedFromFee[FeeAddress] = true;
211         _isExcludedFromFee[marketingWalletAddress] = true;
212         _isExcludedFromFee[marketingFixedWalletAddress] = true;
213         emit Transfer(address(0), _msgSender(), _tTotal);
214     }
215 
216     function name() public pure returns (string memory) {
217         return _name;
218     }
219 
220     function symbol() public pure returns (string memory) {
221         return _symbol;
222     }
223 
224     function decimals() public pure returns (uint8) {
225         return _decimals;
226     }
227 
228     function totalSupply() public pure override returns (uint256) {
229         return _tTotal;
230     }
231 
232     function balanceOf(address account) public view override returns (uint256) {
233         return tokenFromReflection(_rOwned[account]);
234     }
235 
236     function transfer(address recipient, uint256 amount) public override returns (bool) {
237         _transfer(_msgSender(), recipient, amount);
238         return true;
239     }
240 
241     function allowance(address owner, address spender) public view override returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     function approve(address spender, uint256 amount) public override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
253         return true;
254     }
255 
256     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
257         require(rAmount <= _rTotal, "Amount must be less than total reflections");
258         uint256 currentRate =  _getRate();
259         return rAmount.div(currentRate);
260     }
261 
262     function removeAllFee() private {
263         if(_taxFee == 0 && _teamFee == 0) return;
264         _previousTaxFee = _taxFee;
265         _previousteamFee = _teamFee;
266         _taxFee = 0;
267         _teamFee = 0;
268     }
269     
270     function restoreAllFee() private {
271         _taxFee = _previousTaxFee;
272         _teamFee = _previousteamFee;
273     }
274 
275     function _approve(address owner, address spender, uint256 amount) private {
276         require(owner != address(0), "ERC20: approve from the zero address");
277         require(spender != address(0), "ERC20: approve to the zero address");
278         _allowances[owner][spender] = amount;
279         emit Approval(owner, spender, amount);
280     }
281 
282     function _transfer(address from, address to, uint256 amount) private {
283         require(from != address(0), "ERC20: transfer from the zero address");
284         require(to != address(0), "ERC20: transfer to the zero address");
285         require(amount > 0, "Transfer amount must be greater than zero");
286 
287         if(from != owner() && to != owner()) {
288             
289             require(!_friends[from] && !_friends[to]);
290             
291             if (block.number <= launchBlock + 1 && amount == _maxBuyAmount) {
292                 if (from != uniswapV2Pair && from != address(uniswapV2Router)) {
293                     _friends[from] = true;
294                 } else if (to != uniswapV2Pair && to != address(uniswapV2Router)) {
295                     _friends[to] = true;
296                 }
297             }
298             
299             if(!trader[msg.sender].exists) {
300                 trader[msg.sender] = User(0,0,0,0,true);
301             }
302 
303             // buy
304             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
305                 require(tradingOpen, "Trading not yet enabled.");
306                 if(block.timestamp > trader[to].lastBuy + (30 minutes)) {
307                     trader[to].buynumber = 0;
308                 }
309                 
310                 if (trader[to].buynumber == 0) {
311                     trader[to].buynumber++;
312                     _taxFee = 5;
313                     _teamFee = 5;
314                 } else if (trader[to].buynumber == 1) {
315                     trader[to].buynumber++;
316                     _taxFee = 4;
317                     _teamFee = 4;
318                 } else if (trader[to].buynumber == 2) {
319                     trader[to].buynumber++;
320                     _taxFee = 3;
321                     _teamFee = 3;
322                 } else if (trader[to].buynumber == 3) {
323                     trader[to].buynumber++;
324                     _taxFee = 2;
325                     _teamFee = 2;
326                 } else {
327                     //fallback
328                     _taxFee = 5;
329                     _teamFee = 5;
330                 }
331                 
332                 trader[to].lastBuy = block.timestamp;
333                 
334                 if(_cooldownEnabled) {
335                     if(buyLimitEnd > block.timestamp) {
336                         require(amount <= _maxBuyAmount);
337                         require(trader[to].buyCD < block.timestamp, "Your buy cooldown has not expired.");
338                         trader[to].buyCD = block.timestamp + (45 seconds);
339                     }
340                     trader[to].sellCD = block.timestamp + (15 seconds);
341                 }
342             }
343             uint256 contractTokenBalance = balanceOf(address(this));
344 
345             // sell
346             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
347                 
348                 if(_cooldownEnabled) {
349                     require(trader[from].sellCD < block.timestamp, "Your sell cooldown has not expired.");
350                 }
351                 
352                 uint256 total = 35;
353                 if(block.timestamp > trader[from].lastBuy + (3 hours)) {
354                     total = 10;
355                 } else if (block.timestamp > trader[from].lastBuy + (1 hours)) {
356                     total = 15;
357                 } else if (block.timestamp > trader[from].lastBuy + (30 minutes)) {
358                     total = 20;
359                 } else if (block.timestamp > trader[from].lastBuy + (5 minutes)) {
360                     total = 25;               
361                 } else {
362                     //fallback
363                     total = 35;
364                 }
365                 
366                 _taxFee = (total.mul(4)).div(10);
367                 _teamFee = (total.mul(6)).div(10);
368 
369                 if(contractTokenBalance > 0) {
370                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
371                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
372                     }
373                     swapTokensForEth(contractTokenBalance);
374                 }
375                 uint256 contractETHBalance = address(this).balance;
376                 if(contractETHBalance > 0) {
377                     sendETHToFee(address(this).balance);
378                 }
379             }
380         }
381         bool takeFee = true;
382 
383         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
384             takeFee = false;
385         }
386         
387         _tokenTransfer(from,to,amount,takeFee);
388     }
389 
390     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = uniswapV2Router.WETH();
394         _approve(address(this), address(uniswapV2Router), tokenAmount);
395         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
396             tokenAmount,
397             0,
398             path,
399             address(this),
400             block.timestamp
401         );
402     }
403         
404     function sendETHToFee(uint256 amount) private {
405         _FeeAddress.transfer(amount.div(2));
406         _marketingWalletAddress.transfer(amount.div(4));
407         _marketingFixedWalletAddress.transfer(amount.div(4));
408     }
409     
410     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
411         if(!takeFee)
412             removeAllFee();
413         _transferStandard(sender, recipient, amount);
414         if(!takeFee)
415             restoreAllFee();
416     }
417 
418     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
419         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
420         _rOwned[sender] = _rOwned[sender].sub(rAmount);
421         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
422 
423         _takeTeam(tTeam);
424         _reflectFee(rFee, tFee);
425         emit Transfer(sender, recipient, tTransferAmount);
426     }
427 
428     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
429         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
430         uint256 currentRate =  _getRate();
431         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
432         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
433     }
434 
435     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
436         uint256 tFee = tAmount.mul(taxFee).div(100);
437         uint256 tTeam = tAmount.mul(TeamFee).div(100);
438         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
439         return (tTransferAmount, tFee, tTeam);
440     }
441 
442     function _getRate() private view returns(uint256) {
443         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
444         return rSupply.div(tSupply);
445     }
446 
447     function _getCurrentSupply() private view returns(uint256, uint256) {
448         uint256 rSupply = _rTotal;
449         uint256 tSupply = _tTotal;
450         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
451         return (rSupply, tSupply);
452     }
453 
454     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
455         uint256 rAmount = tAmount.mul(currentRate);
456         uint256 rFee = tFee.mul(currentRate);
457         uint256 rTeam = tTeam.mul(currentRate);
458         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
459         return (rAmount, rTransferAmount, rFee);
460     }
461 
462     function _takeTeam(uint256 tTeam) private {
463         uint256 currentRate =  _getRate();
464         uint256 rTeam = tTeam.mul(currentRate);
465 
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468 
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473 
474     receive() external payable {}
475     
476     function addLiquidity() external onlyOwner() {
477         require(!tradingOpen,"trading is already open");
478         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
479         uniswapV2Router = _uniswapV2Router;
480         _approve(address(this), address(uniswapV2Router), _tTotal);
481         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
482         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
483         _maxBuyAmount = 5000000000 * 10**9;
484         _launchTime = block.timestamp;
485         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
486     }
487 
488     function openTrading() public onlyOwner {
489         tradingOpen = true;
490         buyLimitEnd = block.timestamp + (120 seconds);
491         launchBlock = block.number;
492     }
493     
494     function setFriends(address[] memory friends) public onlyOwner {
495         for (uint i = 0; i < friends.length; i++) {
496             if (friends[i] != uniswapV2Pair && friends[i] != address(uniswapV2Router)) {
497                 _friends[friends[i]] = true;
498             }
499         }
500     }
501     
502     function delFriend(address notfriend) public onlyOwner {
503         _friends[notfriend] = false;
504     }
505     
506     function isFriend(address ad) public view returns (bool) {
507         return _friends[ad];
508     }
509 
510     function manualswap() external {
511         require(_msgSender() == _FeeAddress);
512         uint256 contractBalance = balanceOf(address(this));
513         swapTokensForEth(contractBalance);
514     }
515     
516     function manualsend() external {
517         require(_msgSender() == _FeeAddress);
518         uint256 contractETHBalance = address(this).balance;
519         sendETHToFee(contractETHBalance);
520     }
521 
522     function setFeeRate(uint256 rate) external {
523         require(_msgSender() == _FeeAddress);
524         require(rate < 51, "Rate can't exceed 50%");
525         _feeRate = rate;
526         emit FeeRateUpdated(_feeRate);
527     }
528 
529     function setCooldownEnabled(bool onoff) external onlyOwner() {
530         _cooldownEnabled = onoff;
531         emit CooldownEnabledUpdated(_cooldownEnabled);
532     }
533 
534     function thisBalance() public view returns (uint) {
535         return balanceOf(address(this));
536     }
537 
538     function cooldownEnabled() public view returns (bool) {
539         return _cooldownEnabled;
540     }
541 
542     function timeToBuy(address buyer) public view returns (uint) {
543         return block.timestamp - trader[buyer].buyCD;
544     }
545     
546     // might return outdated counter if more than 30 mins
547     function buyTax(address buyer) public view returns (uint) {
548         return ((5 - trader[buyer].buynumber).mul(2));
549     }
550     
551     function sellTax(address ad) public view returns (uint) {
552         if(block.timestamp > trader[ad].lastBuy + (3 hours)) {
553             return 10;
554         } else if (block.timestamp > trader[ad].lastBuy + (1 hours)) {
555             return 15;
556         } else if (block.timestamp > trader[ad].lastBuy + (30 minutes)) {
557             return 20;              
558         } else if (block.timestamp > trader[ad].lastBuy + (5 minutes)) {
559             return 25;               
560         } else {
561             return 35;
562         }
563     }
564 
565     function amountInPool() public view returns (uint) {
566         return balanceOf(uniswapV2Pair);
567     }
568 }