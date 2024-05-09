1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-18
3 */
4 
5 /**
6  * .______     ______     ___       __  ___  _______
7  * |   _  \   /      |   /   \     |  |/  / |   ____|
8  * |  |_)  | |  ,----'  /  ^  \    |  '  /  |  |__
9  * |   _  <  |  |      /  /_\  \   |    <   |   __|
10  * |  |_)  | |  `----./  _____  \  |  .  \  |  |____
11  * |______/   \______/__/     \__\ |__|\__\ |_______|
12 
13  * Birthday Cake Inu
14  * https://t.me/BirthdayCakeInu
15  * birthdayinu.com
16  *
17  * BCAKE is a meme token with a twist!
18  * BCAKE has no sale limitations, which benefits whales and minnows alike, and an innovative dynamic reflection tax rate which increases proportionate to the size of the sell.
19  *
20  * TOKENOMICS:
21  * 1,000,000,000,000 token supply
22  * FIRST TWO MINUTES: 3,000,000,000 max buy / 45-second buy cooldown (these limitations are lifted automatically two minutes post-launch)
23  * 15-second cooldown to sell after a buy, in order to limit bot behavior. NO OTHER COOLDOWNS, NO COOLDOWNS BETWEEN SELLS
24  * No buy or sell token limits. Whales are welcome!
25  * 10% total tax on buy
26  * Fee on sells is dynamic, relative to price impact, minimum of 10% fee and maximum of 40% fee, with NO SELL LIMIT.
27  * No team tokens, no presale
28  * A unique approach to resolving the huge dumps after long pumps that have plagued every NotInu fork
29  *
30  *
31 */
32 
33 // SPDX-License-Identifier: UNLICENSED
34 pragma solidity ^0.8.4;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if(a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         return c;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return mod(a, b, "SafeMath: modulo by zero");
91     }
92 
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b != 0, errorMessage);
95         return a % b;
96     }
97 }
98 
99 contract Ownable is Context {
100     address private _owner;
101     address private _previousOwner;
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     constructor () {
105         address msgSender = _msgSender();
106         _owner = msgSender;
107         emit OwnershipTransferred(address(0), msgSender);
108     }
109 
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     function renounceOwnership() public virtual onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124 }
125 
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB) external returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 }
149 
150 contract BCAKE is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152     mapping (address => uint256) private _rOwned;
153     mapping (address => uint256) private _tOwned;
154     mapping (address => mapping (address => uint256)) private _allowances;
155     mapping (address => bool) private _isExcludedFromFee;
156     mapping (address => User) private cooldown;
157     uint256 private constant MAX = ~uint256(0);
158     uint256 private constant _tTotal = 1e12 * 10**9;
159     uint256 private _rTotal = (MAX - (MAX % _tTotal));
160     uint256 private _tFeeTotal;
161     string private constant _name = unicode"Rapidly Reusable Rockets";
162     string private constant _symbol = unicode"RRR";
163     uint8 private constant _decimals = 9;
164     uint256 private _taxFee = 6;
165     uint256 private _teamFee = 4;
166     uint256 private _feeRate = 5;
167     uint256 private _feeMultiplier = 1000;
168     uint256 private _launchTime;
169     uint256 private _previousTaxFee = _taxFee;
170     uint256 private _previousteamFee = _teamFee;
171     uint256 private _maxBuyAmount;
172     address payable private _FeeAddress;
173     address payable private _marketingWalletAddress;
174     IUniswapV2Router02 private uniswapV2Router;
175     address private uniswapV2Pair;
176     bool private tradingOpen;
177     bool private _cooldownEnabled = true;
178     bool private inSwap = false;
179     bool private _useImpactFeeSetter = true;
180     uint256 private buyLimitEnd;
181     struct User {
182         uint256 buy;
183         uint256 sell;
184         bool exists;
185     }
186 
187     event MaxBuyAmountUpdated(uint _maxBuyAmount);
188     event CooldownEnabledUpdated(bool _cooldown);
189     event FeeMultiplierUpdated(uint _multiplier);
190     event FeeRateUpdated(uint _rate);
191 
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
198         _FeeAddress = FeeAddress;
199         _marketingWalletAddress = marketingWalletAddress;
200         _rOwned[_msgSender()] = _rTotal;
201         _isExcludedFromFee[owner()] = true;
202         _isExcludedFromFee[address(this)] = true;
203         _isExcludedFromFee[FeeAddress] = true;
204         _isExcludedFromFee[marketingWalletAddress] = true;
205         emit Transfer(address(0), _msgSender(), _tTotal);
206     }
207 
208     function name() public pure returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return tokenFromReflection(_rOwned[account]);
226     }
227 
228     function transfer(address recipient, uint256 amount) public override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender) public view override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount) public override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
245         return true;
246     }
247 
248     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
249         require(rAmount <= _rTotal, "Amount must be less than total reflections");
250         uint256 currentRate =  _getRate();
251         return rAmount.div(currentRate);
252     }
253 
254     function removeAllFee() private {
255         if(_taxFee == 0 && _teamFee == 0) return;
256         _previousTaxFee = _taxFee;
257         _previousteamFee = _teamFee;
258         _taxFee = 0;
259         _teamFee = 0;
260     }
261 
262     function restoreAllFee() private {
263         _taxFee = _previousTaxFee;
264         _teamFee = _previousteamFee;
265     }
266 
267     function setFee(uint256 impactFee) private {
268         uint256 _impactFee = 10;
269         if(impactFee < 10) {
270             _impactFee = 10;
271         } else if(impactFee > 40) {
272             _impactFee = 40;
273         } else {
274             _impactFee = impactFee;
275         }
276         if(_impactFee.mod(2) != 0) {
277             _impactFee++;
278         }
279         _taxFee = (_impactFee.mul(6)).div(10);
280         _teamFee = (_impactFee.mul(4)).div(10);
281     }
282 
283     function _approve(address owner, address spender, uint256 amount) private {
284         require(owner != address(0), "ERC20: approve from the zero address");
285         require(spender != address(0), "ERC20: approve to the zero address");
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 
290     function _transfer(address from, address to, uint256 amount) private {
291         require(from != address(0), "ERC20: transfer from the zero address");
292         require(to != address(0), "ERC20: transfer to the zero address");
293         require(amount > 0, "Transfer amount must be greater than zero");
294 
295         if(from != owner() && to != owner()) {
296             if(_cooldownEnabled) {
297                 if(!cooldown[msg.sender].exists) {
298                     cooldown[msg.sender] = User(0,0,true);
299                 }
300             }
301 
302             // buy
303             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
304                 require(tradingOpen, "Trading not yet enabled.");
305                 _taxFee = 6;
306                 _teamFee = 4;
307                 if(_cooldownEnabled) {
308                     if(buyLimitEnd > block.timestamp) {
309                         require(amount <= _maxBuyAmount);
310                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
311                         cooldown[to].buy = block.timestamp + (45 seconds);
312                     }
313                 }
314                 if(_cooldownEnabled) {
315                     cooldown[to].sell = block.timestamp + (15 seconds);
316                 }
317             }
318             uint256 contractTokenBalance = balanceOf(address(this));
319 
320             // sell
321             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
322 
323                 if(_cooldownEnabled) {
324                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
325                 }
326 
327                 if(_useImpactFeeSetter) {
328                     uint256 feeBasis = amount.mul(_feeMultiplier);
329                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
330                     setFee(feeBasis);
331                 }
332 
333                 if(contractTokenBalance > 0) {
334                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
335                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
336                     }
337                     swapTokensForEth(contractTokenBalance);
338                 }
339                 uint256 contractETHBalance = address(this).balance;
340                 if(contractETHBalance > 0) {
341                     sendETHToFee(address(this).balance);
342                 }
343             }
344         }
345         bool takeFee = true;
346 
347         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
348             takeFee = false;
349         }
350 
351         _tokenTransfer(from,to,amount,takeFee);
352     }
353 
354     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
355         address[] memory path = new address[](2);
356         path[0] = address(this);
357         path[1] = uniswapV2Router.WETH();
358         _approve(address(this), address(uniswapV2Router), tokenAmount);
359         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
360             tokenAmount,
361             0,
362             path,
363             address(this),
364             block.timestamp
365         );
366     }
367 
368     function sendETHToFee(uint256 amount) private {
369         _FeeAddress.transfer(amount.div(2));
370         _marketingWalletAddress.transfer(amount.div(2));
371     }
372 
373     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
374         if(!takeFee)
375             removeAllFee();
376         _transferStandard(sender, recipient, amount);
377         if(!takeFee)
378             restoreAllFee();
379     }
380 
381     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
382         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
383         _rOwned[sender] = _rOwned[sender].sub(rAmount);
384         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
385 
386         _takeTeam(tTeam);
387         _reflectFee(rFee, tFee);
388         emit Transfer(sender, recipient, tTransferAmount);
389     }
390 
391     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
392         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
393         uint256 currentRate =  _getRate();
394         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
395         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
396     }
397 
398     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
399         uint256 tFee = tAmount.mul(taxFee).div(100);
400         uint256 tTeam = tAmount.mul(TeamFee).div(100);
401         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
402         return (tTransferAmount, tFee, tTeam);
403     }
404 
405     function _getRate() private view returns(uint256) {
406         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
407         return rSupply.div(tSupply);
408     }
409 
410     function _getCurrentSupply() private view returns(uint256, uint256) {
411         uint256 rSupply = _rTotal;
412         uint256 tSupply = _tTotal;
413         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
414         return (rSupply, tSupply);
415     }
416 
417     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
418         uint256 rAmount = tAmount.mul(currentRate);
419         uint256 rFee = tFee.mul(currentRate);
420         uint256 rTeam = tTeam.mul(currentRate);
421         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
422         return (rAmount, rTransferAmount, rFee);
423     }
424 
425     function _takeTeam(uint256 tTeam) private {
426         uint256 currentRate =  _getRate();
427         uint256 rTeam = tTeam.mul(currentRate);
428 
429         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
430     }
431 
432     function _reflectFee(uint256 rFee, uint256 tFee) private {
433         _rTotal = _rTotal.sub(rFee);
434         _tFeeTotal = _tFeeTotal.add(tFee);
435     }
436 
437     receive() external payable {}
438 
439     function addLiquidity() external onlyOwner() {
440         require(!tradingOpen,"trading is already open");
441         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
442         uniswapV2Router = _uniswapV2Router;
443         _approve(address(this), address(uniswapV2Router), _tTotal);
444         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
445         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
446         _maxBuyAmount = 3000000000 * 10**9;
447         _launchTime = block.timestamp;
448         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
449     }
450 
451     function openTrading() public onlyOwner {
452         tradingOpen = true;
453         buyLimitEnd = block.timestamp + (120 seconds);
454     }
455 
456     function manualswap() external {
457         require(_msgSender() == _FeeAddress);
458         uint256 contractBalance = balanceOf(address(this));
459         swapTokensForEth(contractBalance);
460     }
461 
462     function manualsend() external {
463         require(_msgSender() == _FeeAddress);
464         uint256 contractETHBalance = address(this).balance;
465         sendETHToFee(contractETHBalance);
466     }
467 
468     // fallback in case contract is not releasing tokens fast enough
469     function setFeeRate(uint256 rate) external {
470         require(_msgSender() == _FeeAddress);
471         require(rate < 51, "Rate can't exceed 50%");
472         _feeRate = rate;
473         emit FeeRateUpdated(_feeRate);
474     }
475 
476     function setCooldownEnabled(bool onoff) external onlyOwner() {
477         _cooldownEnabled = onoff;
478         emit CooldownEnabledUpdated(_cooldownEnabled);
479     }
480 
481     function thisBalance() public view returns (uint) {
482         return balanceOf(address(this));
483     }
484 
485     function cooldownEnabled() public view returns (bool) {
486         return _cooldownEnabled;
487     }
488 
489     function timeToBuy(address buyer) public view returns (uint) {
490         return block.timestamp - cooldown[buyer].buy;
491     }
492 
493     function timeToSell(address buyer) public view returns (uint) {
494         return block.timestamp - cooldown[buyer].sell;
495     }
496 
497     function amountInPool() public view returns (uint) {
498         return balanceOf(uniswapV2Pair);
499     }
500 }