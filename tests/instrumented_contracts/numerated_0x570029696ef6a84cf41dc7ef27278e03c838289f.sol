1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-18
3 */
4 
5 /**
6  * .______   ____    ____ .______          ___      .___  ___.  __  .__   __.  __    __
7  * |   _  \  \   \  /   / |   _  \        /   \     |   \/   | |  | |  \ |  | |  |  |  |
8  * |  |_)  |  \   \/   /  |  |_)  |      /  ^  \    |  \  /  | |  | |   \|  | |  |  |  |
9  * |   ___/    \_    _/   |      /      /  /_\  \   |  |\/|  | |  | |  . `  | |  |  |  |
10  * |  |          |  |     |  |\  \----./  _____  \  |  |  |  | |  | |  |\   | |  `--'  |
11  * | _|          |__|     | _| `._____/__/     \__\ |__|  |__| |__| |__| \__|  \______/
12  * 
13  * Pyraminu
14  * https://t.me/Pyraminu
15  * pyraminu.com
16  *
17  * Pyraminu is a meme token with a twist!
18  * Pyraminu has no sale limitations, which benefits whales and minnows alike, and an innovative dynamic reflection tax rate which increases proportionate to the size of the sell.
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
29 */
30 
31 // SPDX-License-Identifier: UNLICENSED
32 pragma solidity ^0.8.4;
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if(a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         return c;
85     }
86 
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         return mod(a, b, "SafeMath: modulo by zero");
89     }
90 
91     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b != 0, errorMessage);
93         return a % b;
94     }
95 }
96 
97 contract Ownable is Context {
98     address private _owner;
99     address private _previousOwner;
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor () {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 }
147 
148 contract PYRAMINU is Context, IERC20, Ownable {
149     using SafeMath for uint256;
150     mapping (address => uint256) private _rOwned;
151     mapping (address => uint256) private _tOwned;
152     mapping (address => mapping (address => uint256)) private _allowances;
153     mapping (address => bool) private _isExcludedFromFee;
154     mapping (address => User) private cooldown;
155     uint256 private constant MAX = ~uint256(0);
156     uint256 private constant _tTotal = 1e12 * 10**9;
157     uint256 private _rTotal = (MAX - (MAX % _tTotal));
158     uint256 private _tFeeTotal;
159     string private constant _name = unicode"Pyraminu";
160     string private constant _symbol = unicode"PYRAMINU";
161     uint8 private constant _decimals = 9;
162     uint256 private _taxFee = 2;
163     uint256 private _teamFee = 8;
164     uint256 private _feeRate = 5;
165     uint256 private _feeMultiplier = 1000;
166     uint256 private _launchTime;
167     uint256 private _previousTaxFee = _taxFee;
168     uint256 private _previousteamFee = _teamFee;
169     uint256 private _maxBuyAmount;
170     address payable private _FeeAddress;
171     address payable private _marketingWalletAddress;
172     IUniswapV2Router02 private uniswapV2Router;
173     address private uniswapV2Pair;
174     bool private tradingOpen;
175     bool private _cooldownEnabled = true;
176     bool private inSwap = false;
177     bool private _useImpactFeeSetter = true;
178     uint256 private buyLimitEnd;
179     struct User {
180         uint256 buy;
181         uint256 sell;
182         bool exists;
183     }
184 
185     event MaxBuyAmountUpdated(uint _maxBuyAmount);
186     event CooldownEnabledUpdated(bool _cooldown);
187     event FeeMultiplierUpdated(uint _multiplier);
188     event FeeRateUpdated(uint _rate);
189 
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
196         _FeeAddress = FeeAddress;
197         _marketingWalletAddress = marketingWalletAddress;
198         _rOwned[_msgSender()] = _rTotal;
199         _isExcludedFromFee[owner()] = true;
200         _isExcludedFromFee[address(this)] = true;
201         _isExcludedFromFee[FeeAddress] = true;
202         _isExcludedFromFee[marketingWalletAddress] = true;
203         emit Transfer(address(0), _msgSender(), _tTotal);
204     }
205 
206     function name() public pure returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public pure returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public pure returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public pure override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return tokenFromReflection(_rOwned[account]);
224     }
225 
226     function transfer(address recipient, uint256 amount) public override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(address owner, address spender) public view override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     function approve(address spender, uint256 amount) public override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
241         _transfer(sender, recipient, amount);
242         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
247         require(rAmount <= _rTotal, "Amount must be less than total reflections");
248         uint256 currentRate =  _getRate();
249         return rAmount.div(currentRate);
250     }
251 
252     function removeAllFee() private {
253         if(_taxFee == 0 && _teamFee == 0) return;
254         _previousTaxFee = _taxFee;
255         _previousteamFee = _teamFee;
256         _taxFee = 0;
257         _teamFee = 0;
258     }
259 
260     function restoreAllFee() private {
261         _taxFee = _previousTaxFee;
262         _teamFee = _previousteamFee;
263     }
264 
265     function setFee(uint256 impactFee) private {
266         uint256 _impactFee = 10;
267         if(impactFee < 10) {
268             _impactFee = 10;
269         } else if(impactFee > 40) {
270             _impactFee = 40;
271         } else {
272             _impactFee = impactFee;
273         }
274         if(_impactFee.mod(2) != 0) {
275             _impactFee++;
276         }
277         _taxFee = (_impactFee.mul(2)).div(10);
278         _teamFee = (_impactFee.mul(8)).div(10);
279     }
280 
281     function _approve(address owner, address spender, uint256 amount) private {
282         require(owner != address(0), "ERC20: approve from the zero address");
283         require(spender != address(0), "ERC20: approve to the zero address");
284         _allowances[owner][spender] = amount;
285         emit Approval(owner, spender, amount);
286     }
287 
288     function _transfer(address from, address to, uint256 amount) private {
289         require(from != address(0), "ERC20: transfer from the zero address");
290         require(to != address(0), "ERC20: transfer to the zero address");
291         require(amount > 0, "Transfer amount must be greater than zero");
292 
293         if(from != owner() && to != owner()) {
294             if(_cooldownEnabled) {
295                 if(!cooldown[msg.sender].exists) {
296                     cooldown[msg.sender] = User(0,0,true);
297                 }
298             }
299 
300             // buy
301             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
302                 require(tradingOpen, "Trading not yet enabled.");
303                 _taxFee = 2;
304                 _teamFee = 8;
305                 if(_cooldownEnabled) {
306                     if(buyLimitEnd > block.timestamp) {
307                         require(amount <= _maxBuyAmount);
308                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
309                         cooldown[to].buy = block.timestamp + (45 seconds);
310                     }
311                 }
312                 if(_cooldownEnabled) {
313                     cooldown[to].sell = block.timestamp + (15 seconds);
314                 }
315             }
316             uint256 contractTokenBalance = balanceOf(address(this));
317 
318             // sell
319             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
320 
321                 if(_cooldownEnabled) {
322                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
323                 }
324 
325                 if(_useImpactFeeSetter) {
326                     uint256 feeBasis = amount.mul(_feeMultiplier);
327                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
328                     setFee(feeBasis);
329                 }
330 
331                 if(contractTokenBalance > 0) {
332                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
333                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
334                     }
335                     swapTokensForEth(contractTokenBalance);
336                 }
337                 uint256 contractETHBalance = address(this).balance;
338                 if(contractETHBalance > 0) {
339                     sendETHToFee(address(this).balance);
340                 }
341             }
342         }
343         bool takeFee = true;
344 
345         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
346             takeFee = false;
347         }
348 
349         _tokenTransfer(from,to,amount,takeFee);
350     }
351 
352     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
353         address[] memory path = new address[](2);
354         path[0] = address(this);
355         path[1] = uniswapV2Router.WETH();
356         _approve(address(this), address(uniswapV2Router), tokenAmount);
357         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
358             tokenAmount,
359             0,
360             path,
361             address(this),
362             block.timestamp
363         );
364     }
365 
366     function sendETHToFee(uint256 amount) private {
367         _FeeAddress.transfer(amount.div(2));
368         _marketingWalletAddress.transfer(amount.div(2));
369     }
370 
371     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
372         if(!takeFee)
373             removeAllFee();
374         _transferStandard(sender, recipient, amount);
375         if(!takeFee)
376             restoreAllFee();
377     }
378 
379     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
380         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
381         _rOwned[sender] = _rOwned[sender].sub(rAmount);
382         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
383 
384         _takeTeam(tTeam);
385         _reflectFee(rFee, tFee);
386         emit Transfer(sender, recipient, tTransferAmount);
387     }
388 
389     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
390         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
391         uint256 currentRate =  _getRate();
392         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
393         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
394     }
395 
396     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
397         uint256 tFee = tAmount.mul(taxFee).div(100);
398         uint256 tTeam = tAmount.mul(TeamFee).div(100);
399         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
400         return (tTransferAmount, tFee, tTeam);
401     }
402 
403     function _getRate() private view returns(uint256) {
404         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
405         return rSupply.div(tSupply);
406     }
407 
408     function _getCurrentSupply() private view returns(uint256, uint256) {
409         uint256 rSupply = _rTotal;
410         uint256 tSupply = _tTotal;
411         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
412         return (rSupply, tSupply);
413     }
414 
415     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
416         uint256 rAmount = tAmount.mul(currentRate);
417         uint256 rFee = tFee.mul(currentRate);
418         uint256 rTeam = tTeam.mul(currentRate);
419         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
420         return (rAmount, rTransferAmount, rFee);
421     }
422 
423     function _takeTeam(uint256 tTeam) private {
424         uint256 currentRate =  _getRate();
425         uint256 rTeam = tTeam.mul(currentRate);
426 
427         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
428     }
429 
430     function _reflectFee(uint256 rFee, uint256 tFee) private {
431         _rTotal = _rTotal.sub(rFee);
432         _tFeeTotal = _tFeeTotal.add(tFee);
433     }
434 
435     receive() external payable {}
436 
437     function addLiquidity() external onlyOwner() {
438         require(!tradingOpen,"trading is already open");
439         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
440         uniswapV2Router = _uniswapV2Router;
441         _approve(address(this), address(uniswapV2Router), _tTotal);
442         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
443         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
444         _maxBuyAmount = 3000000000 * 10**9;
445         _launchTime = block.timestamp;
446         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
447     }
448 
449     function openTrading() public onlyOwner {
450         tradingOpen = true;
451         buyLimitEnd = block.timestamp + (120 seconds);
452     }
453 
454     function manualswap() external {
455         require(_msgSender() == _FeeAddress);
456         uint256 contractBalance = balanceOf(address(this));
457         swapTokensForEth(contractBalance);
458     }
459 
460     function manualsend() external {
461         require(_msgSender() == _FeeAddress);
462         uint256 contractETHBalance = address(this).balance;
463         sendETHToFee(contractETHBalance);
464     }
465 
466     // fallback in case contract is not releasing tokens fast enough
467     function setFeeRate(uint256 rate) external {
468         require(_msgSender() == _FeeAddress);
469         require(rate < 51, "Rate can't exceed 50%");
470         _feeRate = rate;
471         emit FeeRateUpdated(_feeRate);
472     }
473 
474     function setCooldownEnabled(bool onoff) external onlyOwner() {
475         _cooldownEnabled = onoff;
476         emit CooldownEnabledUpdated(_cooldownEnabled);
477     }
478 
479     function thisBalance() public view returns (uint) {
480         return balanceOf(address(this));
481     }
482 
483     function cooldownEnabled() public view returns (bool) {
484         return _cooldownEnabled;
485     }
486 
487     function timeToBuy(address buyer) public view returns (uint) {
488         return block.timestamp - cooldown[buyer].buy;
489     }
490 
491     function timeToSell(address buyer) public view returns (uint) {
492         return block.timestamp - cooldown[buyer].sell;
493     }
494 
495     function amountInPool() public view returns (uint) {
496         return balanceOf(uniswapV2Pair);
497     }
498 }