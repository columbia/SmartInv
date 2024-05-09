1 /**
2  * 
3  * ShibaSteak🐕🥩
4  * Telegram: https://t.me/shibasteak
5  * Twitter: https://twitter.com/shibasteak
6  * 
7  * TOKENOMICS:
8  * 1,000,000,000,000 token supply
9  * FIRST TWO MINUTES: 3,000,000,000 max buy / 60-second buy cooldown (these limitations are lifted automatically two minutes post-launch)
10  * 15-second cooldown to sell after a buy, in order to limit bot behavior. NO OTHER COOLDOWNS, NO COOLDOWNS BETWEEN SELLS
11  * 
12  * SELLING IS DISABLED FOR THE FIRST 60 SECONDS TO BLACKLIST BOTS (AUTOMATICALLY ENABLED AFTER 60 SECS)
13  * 
14  * Maximum Wallet Token Percentage
15  * - For the first 15 minutes. there is a 2% token wallet limit (2,000,000,000)
16  * - After 15 minutes, the % wallet limit is lifted
17  * 
18  * 10% total tax on buy
19  * Fee on sells is dynamic, relative to price impact, minimum of 10% fee and maximum of 40% fee, with NO SELL LIMIT.
20  * No team tokens, no presale
21  * 
22  * SPDX-License-Identifier: UNLICENSED 
23  * 
24 */
25 pragma solidity ^0.8.4;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if(a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92     address private _previousOwner;
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor () {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(_owner == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 
115 }  
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 }
139 
140 contract SHIBASTEAK is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     mapping (address => uint256) private _rOwned;
143     mapping (address => uint256) private _tOwned;
144     mapping (address => mapping (address => uint256)) private _allowances;
145     mapping (address => bool) private _isExcludedFromFee;
146     mapping (address => bool) private bots;
147     mapping (address => User) private cooldown;
148     uint256 private constant MAX = ~uint256(0);
149     uint256 private constant _tTotal = 1e12 * 10**9;
150     uint256 private _rTotal = (MAX - (MAX % _tTotal));
151     uint256 private _tFeeTotal;
152     string private constant _name = unicode"Shiba Steak | t.me/shibasteak";
153     string private constant _symbol = unicode"STEAK🐕🥩";
154     uint8 private constant _decimals = 9;
155     uint256 private _taxFee = 6;
156     uint256 private _teamFee = 4;
157     uint256 private _feeRate = 5;
158     uint256 private _feeMultiplier = 1000;
159     uint256 private _launchTime;
160     uint256 private _previousTaxFee = _taxFee;
161     uint256 private _previousteamFee = _teamFee;
162     uint256 private _maxBuyAmount;
163     address payable private _FeeAddress;
164     address payable private _marketingWalletAddress;
165     address payable private _marketingFixedWalletAddress;
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private _cooldownEnabled = true;
170     bool private inSwap = false;
171     bool private _useImpactFeeSetter = true;
172     uint256 private buyLimitEnd;
173     uint256 private sellLimitEnd;
174     uint256 private walletLimitDuration;
175     struct User {
176         uint256 buy;
177         uint256 sell;
178         bool exists;
179     }
180 
181     event MaxBuyAmountUpdated(uint _maxBuyAmount);
182     event CooldownEnabledUpdated(bool _cooldown);
183     event FeeMultiplierUpdated(uint _multiplier);
184     event FeeRateUpdated(uint _rate);
185 
186     modifier lockTheSwap {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191     constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable marketingFixedWalletAddress) {
192         _FeeAddress = FeeAddress;
193         _marketingWalletAddress = marketingWalletAddress;
194         _marketingFixedWalletAddress = marketingFixedWalletAddress;
195         _rOwned[_msgSender()] = _rTotal;
196         _isExcludedFromFee[owner()] = true;
197         _isExcludedFromFee[address(this)] = true;
198         _isExcludedFromFee[FeeAddress] = true;
199         _isExcludedFromFee[marketingWalletAddress] = true;
200         _isExcludedFromFee[marketingFixedWalletAddress] = true;
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return tokenFromReflection(_rOwned[account]);
222     }
223 
224     function transfer(address recipient, uint256 amount) public override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(address owner, address spender) public view override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount) public override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
239         _transfer(sender, recipient, amount);
240         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
241         return true;
242     }
243 
244     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
245         require(rAmount <= _rTotal, "Amount must be less than total reflections");
246         uint256 currentRate =  _getRate();
247         return rAmount.div(currentRate);
248     }
249 
250     function removeAllFee() private {
251         if(_taxFee == 0 && _teamFee == 0) return;
252         _previousTaxFee = _taxFee;
253         _previousteamFee = _teamFee;
254         _taxFee = 0;
255         _teamFee = 0;
256     }
257     
258     function restoreAllFee() private {
259         _taxFee = _previousTaxFee;
260         _teamFee = _previousteamFee;
261     }
262 
263     function setFee(uint256 impactFee) private {
264         uint256 _impactFee = 10;
265         if(impactFee < 10) {
266             _impactFee = 10;
267         } else if(impactFee > 40) {
268             _impactFee = 40;
269         } else {
270             _impactFee = impactFee;
271         }
272         if(_impactFee.mod(2) != 0) {
273             _impactFee++;
274         }
275         _taxFee = (_impactFee.mul(6)).div(10);
276         _teamFee = (_impactFee.mul(4)).div(10);
277     }
278 
279     function _approve(address owner, address spender, uint256 amount) private {
280         require(owner != address(0), "ERC20: approve from the zero address");
281         require(spender != address(0), "ERC20: approve to the zero address");
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     function _transfer(address from, address to, uint256 amount) private {
287         require(from != address(0), "ERC20: transfer from the zero address");
288         require(to != address(0), "ERC20: transfer to the zero address");
289         require(amount > 0, "Transfer amount must be greater than zero");
290 
291         if(from != owner() && to != owner()) {
292             if(_cooldownEnabled) {
293                 if(!cooldown[msg.sender].exists) {
294                     cooldown[msg.sender] = User(0,0,true);
295                 }
296             }
297 
298             // buy
299             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
300                 require(tradingOpen, "Trading not yet enabled.");
301                 _taxFee = 6;
302                 _teamFee = 4;
303                 if(_cooldownEnabled) {
304                     if(buyLimitEnd > block.timestamp) {
305                         require(amount <= _maxBuyAmount);
306                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
307                         cooldown[to].buy = block.timestamp + (60 seconds);
308                     }
309 
310                     if (walletLimitDuration > block.timestamp) {
311                         uint walletBalance = balanceOf(address(to));
312                         require(amount.add(walletBalance) <= _tTotal.mul(2).div(100));
313                     }
314                     
315                 }
316                 if(_cooldownEnabled) {
317                     cooldown[to].sell = block.timestamp + (15 seconds);
318                 }
319             }
320             uint256 contractTokenBalance = balanceOf(address(this));
321 
322             // sell
323             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
324                 require(!bots[from] && !bots[to]);
325                 if(_cooldownEnabled) {
326                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
327                     require(sellLimitEnd < block.timestamp, "Selling is not yet allowed.");
328                 }
329 
330                 if(_useImpactFeeSetter) {
331                     uint256 feeBasis = amount.mul(_feeMultiplier);
332                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
333                     setFee(feeBasis);
334                 }
335 
336                 if(contractTokenBalance > 0) {
337                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
338                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
339                     }
340                     swapTokensForEth(contractTokenBalance);
341                 }
342                 uint256 contractETHBalance = address(this).balance;
343                 if(contractETHBalance > 0) {
344                     sendETHToFee(address(this).balance);
345                 }
346             }
347         }
348         bool takeFee = true;
349 
350         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
351             takeFee = false;
352         }
353         
354         _tokenTransfer(from,to,amount,takeFee);
355     }
356 
357     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
358         address[] memory path = new address[](2);
359         path[0] = address(this);
360         path[1] = uniswapV2Router.WETH();
361         _approve(address(this), address(uniswapV2Router), tokenAmount);
362         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             tokenAmount,
364             0,
365             path,
366             address(this),
367             block.timestamp
368         );
369     }
370         
371     function sendETHToFee(uint256 amount) private {
372         _FeeAddress.transfer(amount.div(2));
373         _marketingWalletAddress.transfer(amount.div(2).div(2));
374         _marketingFixedWalletAddress.transfer(amount.div(2).div(2));
375     }
376     
377     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
378         if(!takeFee)
379             removeAllFee();
380         _transferStandard(sender, recipient, amount);
381         if(!takeFee)
382             restoreAllFee();
383     }
384 
385     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
386         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
387         _rOwned[sender] = _rOwned[sender].sub(rAmount);
388         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
389 
390         _takeTeam(tTeam);
391         _reflectFee(rFee, tFee);
392         emit Transfer(sender, recipient, tTransferAmount);
393     }
394 
395     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
396         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
397         uint256 currentRate =  _getRate();
398         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
399         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
400     }
401 
402     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
403         uint256 tFee = tAmount.mul(taxFee).div(100);
404         uint256 tTeam = tAmount.mul(TeamFee).div(100);
405         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
406         return (tTransferAmount, tFee, tTeam);
407     }
408 
409     function _getRate() private view returns(uint256) {
410         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
411         return rSupply.div(tSupply);
412     }
413 
414     function _getCurrentSupply() private view returns(uint256, uint256) {
415         uint256 rSupply = _rTotal;
416         uint256 tSupply = _tTotal;
417         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
418         return (rSupply, tSupply);
419     }
420 
421     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
422         uint256 rAmount = tAmount.mul(currentRate);
423         uint256 rFee = tFee.mul(currentRate);
424         uint256 rTeam = tTeam.mul(currentRate);
425         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
426         return (rAmount, rTransferAmount, rFee);
427     }
428 
429     function _takeTeam(uint256 tTeam) private {
430         uint256 currentRate =  _getRate();
431         uint256 rTeam = tTeam.mul(currentRate);
432 
433         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
434     }
435 
436     function _reflectFee(uint256 rFee, uint256 tFee) private {
437         _rTotal = _rTotal.sub(rFee);
438         _tFeeTotal = _tFeeTotal.add(tFee);
439     }
440 
441     receive() external payable {}
442     
443     function addLiquidity() external onlyOwner() {
444         require(!tradingOpen,"trading is already open");
445         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
446         uniswapV2Router = _uniswapV2Router;
447         _approve(address(this), address(uniswapV2Router), _tTotal);
448         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
449         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
450         _maxBuyAmount = 3000000000 * 10**9;
451         _launchTime = block.timestamp;
452         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
453     }
454 
455     function openTrading() public onlyOwner {
456         tradingOpen = true;
457         buyLimitEnd = block.timestamp + (120 seconds);
458         // Sells are turned off for the first 60 seconds to blacklist bots
459         sellLimitEnd = block.timestamp + (60 seconds);
460         walletLimitDuration = block.timestamp + (15 minutes);
461     }
462     
463     function setBots(address[] memory bots_) public onlyOwner {
464         for (uint i = 0; i < bots_.length; i++) {
465             bots[bots_[i]] = true;
466         }
467     }
468     
469     function delBot(address notbot) public onlyOwner {
470         bots[notbot] = false;
471     }
472     
473     function isBot(address ad) public view returns (bool) {
474         return bots[ad];
475     }
476 
477     function manualswap() external {
478         require(_msgSender() == _FeeAddress);
479         uint256 contractBalance = balanceOf(address(this));
480         swapTokensForEth(contractBalance);
481     }
482     
483     function manualsend() external {
484         require(_msgSender() == _FeeAddress);
485         uint256 contractETHBalance = address(this).balance;
486         sendETHToFee(contractETHBalance);
487     }
488 
489     // fallback in case contract is not releasing tokens fast enough
490     function setFeeRate(uint256 rate) external {
491         require(_msgSender() == _FeeAddress);
492         require(rate < 51, "Rate can't exceed 50%");
493         _feeRate = rate;
494         emit FeeRateUpdated(_feeRate);
495     }
496 
497     function setCooldownEnabled(bool onoff) external onlyOwner() {
498         _cooldownEnabled = onoff;
499         emit CooldownEnabledUpdated(_cooldownEnabled);
500     }
501 
502     function thisBalance() public view returns (uint) {
503         return balanceOf(address(this));
504     }
505 
506     function cooldownEnabled() public view returns (bool) {
507         return _cooldownEnabled;
508     }
509 
510     function timeToBuy(address buyer) public view returns (uint) {
511         return block.timestamp - cooldown[buyer].buy;
512     }
513 
514     function timeToSell(address buyer) public view returns (uint) {
515         return block.timestamp - cooldown[buyer].sell;
516     }
517 
518     function amountInPool() public view returns (uint) {
519         return balanceOf(uniswapV2Pair);
520     }
521 }