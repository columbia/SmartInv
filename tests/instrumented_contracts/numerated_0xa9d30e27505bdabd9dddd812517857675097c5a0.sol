1 /**
2  * 🐙 Takoyaki Token 🐙
3  * Telegram: https://t.me/takoyakitoken
4  * 
5  * TOKENOMICS:
6  * 1,000,000,000,000 token supply
7  * 15-second cooldown to sell after a buy, in order to limit bot behavior.
8  * 0.6% buy limit / 45-second buy cooldown on launch, automatically lifted after 2 minutes
9  * No buy or sell token limits
10  * 10% total tax on buy
11  * DYNAMIC FEE ON SELLS, relative to price impact, minimum of 10% fee and maximum of 40% fee, with NO SELL LIMIT.
12  * After your first sell, 20 minute cooldown between your succeeding sells
13  * No team tokens, no presale
14  * 
15  * SPDX-License-Identifier: UNLICENSED 
16  * 
17 */
18 pragma solidity ^0.8.4;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if(a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b != 0, errorMessage);
79         return a % b;
80     }
81 }
82 
83 contract Ownable is Context {
84     address private _owner;
85     address private _previousOwner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108 }  
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 }
132 
133 contract TAKOYAKI is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135     mapping (address => uint256) private _rOwned;
136     mapping (address => uint256) private _tOwned;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping (address => User) private cooldown;
140     uint256 private constant MAX = ~uint256(0);
141     uint256 private constant _tTotal = 1e12 * 10**9;
142     uint256 private _rTotal = (MAX - (MAX % _tTotal));
143     uint256 private _tFeeTotal;
144     string private constant _name = unicode"Takoyaki | t.me/takoyakitoken";
145     string private constant _symbol = unicode"TAKOYAKI🐙";
146     uint8 private constant _decimals = 9;
147     uint256 private _taxFee = 6;
148     uint256 private _teamFee = 4;
149     uint256 private _feeRate = 5;
150     uint256 private _feeMultiplier = 1000;
151     uint256 private _launchTime;
152     uint256 private _previousTaxFee = _taxFee;
153     uint256 private _previousteamFee = _teamFee;
154     uint256 private _maxBuyAmount;
155     address payable private _FeeAddress;
156     address payable private _marketingWalletAddress;
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private _cooldownEnabled = true;
161     bool private inSwap = false;
162     bool private _useImpactFeeSetter = true;
163     uint256 private buyLimitEnd;
164     struct User {
165         uint256 buy;
166         uint256 sell;
167         uint256 rapid;
168         bool exists;
169     }
170 
171     event MaxBuyAmountUpdated(uint _maxBuyAmount);
172     event CooldownEnabledUpdated(bool _cooldown);
173     event FeeMultiplierUpdated(uint _multiplier);
174     event FeeRateUpdated(uint _rate);
175 
176     modifier lockTheSwap {
177         inSwap = true;
178         _;
179         inSwap = false;
180     }
181     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
182         _FeeAddress = FeeAddress;
183         _marketingWalletAddress = marketingWalletAddress;
184         _rOwned[_msgSender()] = _rTotal;
185         _isExcludedFromFee[owner()] = true;
186         _isExcludedFromFee[address(this)] = true;
187         _isExcludedFromFee[FeeAddress] = true;
188         _isExcludedFromFee[marketingWalletAddress] = true;
189         emit Transfer(address(0), _msgSender(), _tTotal);
190     }
191 
192     function name() public pure returns (string memory) {
193         return _name;
194     }
195 
196     function symbol() public pure returns (string memory) {
197         return _symbol;
198     }
199 
200     function decimals() public pure returns (uint8) {
201         return _decimals;
202     }
203 
204     function totalSupply() public pure override returns (uint256) {
205         return _tTotal;
206     }
207 
208     function balanceOf(address account) public view override returns (uint256) {
209         return tokenFromReflection(_rOwned[account]);
210     }
211 
212     function transfer(address recipient, uint256 amount) public override returns (bool) {
213         _transfer(_msgSender(), recipient, amount);
214         return true;
215     }
216 
217     function allowance(address owner, address spender) public view override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
227         _transfer(sender, recipient, amount);
228         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
229         return true;
230     }
231 
232     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
233         require(rAmount <= _rTotal, "Amount must be less than total reflections");
234         uint256 currentRate =  _getRate();
235         return rAmount.div(currentRate);
236     }
237 
238     function removeAllFee() private {
239         if(_taxFee == 0 && _teamFee == 0) return;
240         _previousTaxFee = _taxFee;
241         _previousteamFee = _teamFee;
242         _taxFee = 0;
243         _teamFee = 0;
244     }
245     
246     function restoreAllFee() private {
247         _taxFee = _previousTaxFee;
248         _teamFee = _previousteamFee;
249     }
250 
251     function setFee(uint256 impactFee) private {
252         uint256 _impactFee = 10;
253         if(impactFee < 10) {
254             _impactFee = 10;
255         } else if(impactFee > 40) {
256             _impactFee = 40;
257         } else {
258             _impactFee = impactFee;
259         }
260         if(_impactFee.mod(2) != 0) {
261             _impactFee++;
262         }
263         _taxFee = (_impactFee.mul(6)).div(10);
264         _teamFee = (_impactFee.mul(4)).div(10);
265     }
266 
267     function _approve(address owner, address spender, uint256 amount) private {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function _transfer(address from, address to, uint256 amount) private {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         require(amount > 0, "Transfer amount must be greater than zero");
278 
279         if(from != owner() && to != owner()) {
280             if(_cooldownEnabled) {
281                 if(!cooldown[msg.sender].exists) {
282                     cooldown[msg.sender] = User(0,0,0,true);
283                 }
284             }
285 
286             // buy
287             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
288                 require(tradingOpen, "Trading not yet enabled.");
289                 _taxFee = 6;
290                 _teamFee = 4;
291                 if(_cooldownEnabled) {
292                     if(buyLimitEnd > block.timestamp) {
293                         require(amount <= _maxBuyAmount);
294                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
295                         cooldown[to].buy = block.timestamp + (45 seconds);
296                     }
297                 }
298                 if(_cooldownEnabled) {
299                     cooldown[to].sell = block.timestamp + (15 seconds);
300                 }
301             }
302             uint256 contractTokenBalance = balanceOf(address(this));
303 
304             // sell
305             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
306 
307                 if(_cooldownEnabled) {
308                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
309                     require(cooldown[from].rapid < block.timestamp, "Your sell cooldown has not expired");
310                 }
311 
312                 if(_useImpactFeeSetter) {
313                     uint256 feeBasis = amount.mul(_feeMultiplier);
314                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
315                     setFee(feeBasis);
316                 }
317 
318                 if(contractTokenBalance > 0) {
319                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
320                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
321                     }
322                     cooldown[from].rapid = block.timestamp + (20 minutes);
323                     swapTokensForEth(contractTokenBalance);
324                 }
325                 uint256 contractETHBalance = address(this).balance;
326                 if(contractETHBalance > 0) {
327                     sendETHToFee(address(this).balance);
328                 }
329             }
330         }
331         bool takeFee = true;
332 
333         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
334             takeFee = false;
335         }
336         
337         _tokenTransfer(from,to,amount,takeFee);
338     }
339 
340     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
341         address[] memory path = new address[](2);
342         path[0] = address(this);
343         path[1] = uniswapV2Router.WETH();
344         _approve(address(this), address(uniswapV2Router), tokenAmount);
345         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
346             tokenAmount,
347             0,
348             path,
349             address(this),
350             block.timestamp
351         );
352     }
353         
354     function sendETHToFee(uint256 amount) private {
355         _FeeAddress.transfer(amount.div(2));
356         _marketingWalletAddress.transfer(amount.div(2));
357     }
358     
359     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
360         if(!takeFee)
361             removeAllFee();
362         _transferStandard(sender, recipient, amount);
363         if(!takeFee)
364             restoreAllFee();
365     }
366 
367     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
368         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
369         _rOwned[sender] = _rOwned[sender].sub(rAmount);
370         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
371 
372         _takeTeam(tTeam);
373         _reflectFee(rFee, tFee);
374         emit Transfer(sender, recipient, tTransferAmount);
375     }
376 
377     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
378         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
379         uint256 currentRate =  _getRate();
380         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
381         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
382     }
383 
384     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
385         uint256 tFee = tAmount.mul(taxFee).div(100);
386         uint256 tTeam = tAmount.mul(TeamFee).div(100);
387         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
388         return (tTransferAmount, tFee, tTeam);
389     }
390 
391     function _getRate() private view returns(uint256) {
392         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
393         return rSupply.div(tSupply);
394     }
395 
396     function _getCurrentSupply() private view returns(uint256, uint256) {
397         uint256 rSupply = _rTotal;
398         uint256 tSupply = _tTotal;
399         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
400         return (rSupply, tSupply);
401     }
402 
403     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
404         uint256 rAmount = tAmount.mul(currentRate);
405         uint256 rFee = tFee.mul(currentRate);
406         uint256 rTeam = tTeam.mul(currentRate);
407         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
408         return (rAmount, rTransferAmount, rFee);
409     }
410 
411     function _takeTeam(uint256 tTeam) private {
412         uint256 currentRate =  _getRate();
413         uint256 rTeam = tTeam.mul(currentRate);
414 
415         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
416     }
417 
418     function _reflectFee(uint256 rFee, uint256 tFee) private {
419         _rTotal = _rTotal.sub(rFee);
420         _tFeeTotal = _tFeeTotal.add(tFee);
421     }
422 
423     receive() external payable {}
424     
425     function addLiquidity() external onlyOwner() {
426         require(!tradingOpen,"trading is already open");
427         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
428         uniswapV2Router = _uniswapV2Router;
429         _approve(address(this), address(uniswapV2Router), _tTotal);
430         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
431         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
432         _maxBuyAmount = 6000000000 * 10**9;
433         _launchTime = block.timestamp;
434         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
435     }
436 
437     function openTrading() public onlyOwner {
438         tradingOpen = true;
439         buyLimitEnd = block.timestamp + (120 seconds);
440     }
441 
442     function manualswap() external {
443         require(_msgSender() == _FeeAddress);
444         uint256 contractBalance = balanceOf(address(this));
445         swapTokensForEth(contractBalance);
446     }
447     
448     function manualsend() external {
449         require(_msgSender() == _FeeAddress);
450         uint256 contractETHBalance = address(this).balance;
451         sendETHToFee(contractETHBalance);
452     }
453 
454     // fallback in case contract is not releasing tokens fast enough
455     function setFeeRate(uint256 rate) external {
456         require(_msgSender() == _FeeAddress);
457         require(rate < 51, "Rate can't exceed 50%");
458         _feeRate = rate;
459         emit FeeRateUpdated(_feeRate);
460     }
461 
462     function setCooldownEnabled(bool onoff) external onlyOwner() {
463         _cooldownEnabled = onoff;
464         emit CooldownEnabledUpdated(_cooldownEnabled);
465     }
466 
467     function thisBalance() public view returns (uint) {
468         return balanceOf(address(this));
469     }
470 
471     function cooldownEnabled() public view returns (bool) {
472         return _cooldownEnabled;
473     }
474 
475     function timeToBuy(address buyer) public view returns (uint) {
476         return block.timestamp - cooldown[buyer].buy;
477     }
478 
479     function timeToSell(address buyer) public view returns (uint) {
480         return block.timestamp - cooldown[buyer].sell;
481     }
482 
483     function amountInPool() public view returns (uint) {
484         return balanceOf(uniswapV2Pair);
485     }
486 }