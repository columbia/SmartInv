1 /**
2  * 
3  * Shiba Babes
4  * 
5  * SPDX-License-Identifier: UNLICENSED 
6  * 
7 */
8 pragma solidity ^0.8.4;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if(a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         return mod(a, b, "SafeMath: modulo by zero");
65     }
66 
67     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b != 0, errorMessage);
69         return a % b;
70     }
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }  
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract SHIBABABES is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _rOwned;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => User) private cooldown;
131     uint256 private constant MAX = ~uint256(0);
132     uint256 private constant _tTotal = 1e12 * 10**9;
133     uint256 private _rTotal = (MAX - (MAX % _tTotal));
134     uint256 private _tFeeTotal;
135     string private constant _name = unicode"Shiba Babes";
136     string private constant _symbol = unicode"SHIBABES";
137     uint8 private constant _decimals = 9;
138     uint256 private _taxFee = 2;
139     uint256 private _teamFee = 8;
140     uint256 private _feeRate = 6;
141     uint256 private _feeMultiplier = 1000;
142     uint256 private _launchTime;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     uint256 private _maxBuyAmount;
146     address payable private _FeeAddress;
147     address payable private _marketingWalletAddress;
148     address payable private _marketingFixedWalletAddress;
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private _cooldownEnabled = true;
153     bool private inSwap = false;
154     bool private _useImpactFeeSetter = true;
155     uint256 private buyLimitEnd;
156     uint256 private walletLimitDuration;
157     struct User {
158         uint256 buy;
159         uint256 sell;
160         uint256 sellCD;
161         bool exists;
162     }
163 
164     event MaxBuyAmountUpdated(uint _maxBuyAmount);
165     event CooldownEnabledUpdated(bool _cooldown);
166     event FeeMultiplierUpdated(uint _multiplier);
167     event FeeRateUpdated(uint _rate);
168 
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174     constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable marketingFixedWalletAddress) {
175         _FeeAddress = FeeAddress;
176         _marketingWalletAddress = marketingWalletAddress;
177         _marketingFixedWalletAddress = marketingFixedWalletAddress;
178         _rOwned[_msgSender()] = _rTotal;
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[FeeAddress] = true;
182         _isExcludedFromFee[marketingWalletAddress] = true;
183         _isExcludedFromFee[marketingFixedWalletAddress] = true;
184         emit Transfer(address(0), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return tokenFromReflection(_rOwned[account]);
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
228         require(rAmount <= _rTotal, "Amount must be less than total reflections");
229         uint256 currentRate =  _getRate();
230         return rAmount.div(currentRate);
231     }
232 
233     function removeAllFee() private {
234         if(_taxFee == 0 && _teamFee == 0) return;
235         _previousTaxFee = _taxFee;
236         _previousteamFee = _teamFee;
237         _taxFee = 0;
238         _teamFee = 0;
239     }
240     
241     function restoreAllFee() private {
242         _taxFee = _previousTaxFee;
243         _teamFee = _previousteamFee;
244     }
245 
246     function setFee(uint256 impactFee) private {
247         uint256 _impactFee = 12;
248         if(impactFee < 12) {
249             _impactFee = 12;
250         } else if(impactFee > 35) {
251             _impactFee = 35;
252         } else {
253             _impactFee = impactFee;
254         }
255         if(_impactFee.mod(2) != 0) {
256             _impactFee++;
257         }
258         _taxFee = (_impactFee.mul(2)).div(10);
259         _teamFee = (_impactFee.mul(8)).div(10);
260     }
261 
262     function _approve(address owner, address spender, uint256 amount) private {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     function _transfer(address from, address to, uint256 amount) private {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         require(amount > 0, "Transfer amount must be greater than zero");
273 
274         if(from != owner() && to != owner()) {
275             if(_cooldownEnabled) {
276                 if(!cooldown[msg.sender].exists) {
277                     cooldown[msg.sender] = User(0,0,0,true);
278                 }
279             }
280 
281             // buy
282             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
283                 require(tradingOpen, "Trading not yet enabled.");
284                 _taxFee = 2;
285                 _teamFee = 8;
286                 if(_cooldownEnabled) {
287                     if(buyLimitEnd > block.timestamp) {
288                         require(amount <= _maxBuyAmount);
289                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
290                         cooldown[to].buy = block.timestamp + (45 seconds);
291                     }
292 
293                     if (walletLimitDuration > block.timestamp) {
294                         uint walletBalance = balanceOf(address(to));
295                         require(amount.add(walletBalance) <= _tTotal.mul(2).div(100));
296                     }
297                     
298                 }
299                 if(_cooldownEnabled) {
300                     if (cooldown[to].sellCD == 0) {
301                         cooldown[to].sellCD++;
302                     } else {
303                         cooldown[to].sellCD = block.timestamp + (15 seconds);
304                     }
305                 }
306             }
307             uint256 contractTokenBalance = balanceOf(address(this));
308 
309             // sell
310             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
311                 require(!bots[from] && !bots[to]);
312                 if(_cooldownEnabled) {
313                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
314                 }
315 
316                 if(_useImpactFeeSetter) {
317                     uint256 feeBasis = amount.mul(_feeMultiplier);
318                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
319                     setFee(feeBasis);
320                 }
321 
322                 if(contractTokenBalance > 0) {
323                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
324                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
325                     }
326                     swapTokensForEth(contractTokenBalance);
327                 }
328                 uint256 contractETHBalance = address(this).balance;
329                 if(contractETHBalance > 0) {
330                     sendETHToFee(address(this).balance);
331                 }
332             }
333         }
334         bool takeFee = true;
335 
336         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
337             takeFee = false;
338         }
339         
340         _tokenTransfer(from,to,amount,takeFee);
341     }
342 
343     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
344         address[] memory path = new address[](2);
345         path[0] = address(this);
346         path[1] = uniswapV2Router.WETH();
347         _approve(address(this), address(uniswapV2Router), tokenAmount);
348         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
349             tokenAmount,
350             0,
351             path,
352             address(this),
353             block.timestamp
354         );
355     }
356         
357     function sendETHToFee(uint256 amount) private {
358         _FeeAddress.transfer(amount.div(2));
359         _marketingWalletAddress.transfer(amount.div(4));
360         _marketingFixedWalletAddress.transfer(amount.div(4));
361     }
362     
363     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
364         if(!takeFee)
365             removeAllFee();
366         _transferStandard(sender, recipient, amount);
367         if(!takeFee)
368             restoreAllFee();
369     }
370 
371     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
373         _rOwned[sender] = _rOwned[sender].sub(rAmount);
374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
375 
376         _takeTeam(tTeam);
377         _reflectFee(rFee, tFee);
378         emit Transfer(sender, recipient, tTransferAmount);
379     }
380 
381     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
382         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
383         uint256 currentRate =  _getRate();
384         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
385         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
386     }
387 
388     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
389         uint256 tFee = tAmount.mul(taxFee).div(100);
390         uint256 tTeam = tAmount.mul(TeamFee).div(100);
391         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
392         return (tTransferAmount, tFee, tTeam);
393     }
394 
395     function _getRate() private view returns(uint256) {
396         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
397         return rSupply.div(tSupply);
398     }
399 
400     function _getCurrentSupply() private view returns(uint256, uint256) {
401         uint256 rSupply = _rTotal;
402         uint256 tSupply = _tTotal;
403         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
404         return (rSupply, tSupply);
405     }
406 
407     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
408         uint256 rAmount = tAmount.mul(currentRate);
409         uint256 rFee = tFee.mul(currentRate);
410         uint256 rTeam = tTeam.mul(currentRate);
411         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
412         return (rAmount, rTransferAmount, rFee);
413     }
414 
415     function _takeTeam(uint256 tTeam) private {
416         uint256 currentRate =  _getRate();
417         uint256 rTeam = tTeam.mul(currentRate);
418 
419         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
420     }
421 
422     function _reflectFee(uint256 rFee, uint256 tFee) private {
423         _rTotal = _rTotal.sub(rFee);
424         _tFeeTotal = _tFeeTotal.add(tFee);
425     }
426 
427     receive() external payable {}
428     
429     function addLiquidity() external onlyOwner() {
430         require(!tradingOpen,"trading is already open");
431         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
432         uniswapV2Router = _uniswapV2Router;
433         _approve(address(this), address(uniswapV2Router), _tTotal);
434         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
435         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
436         _maxBuyAmount = 5000000000 * 10**9;
437         _launchTime = block.timestamp;
438         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
439     }
440 
441     function openTrading() public onlyOwner {
442         tradingOpen = true;
443         buyLimitEnd = block.timestamp + (15 seconds);
444         walletLimitDuration = block.timestamp + (1 hours);
445     }
446     
447     function setBots(address[] memory bots_) public onlyOwner {
448         for (uint i = 0; i < bots_.length; i++) {
449             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
450                 bots[bots_[i]] = true;
451             }
452         }
453     }
454     
455     function delBot(address notbot) public onlyOwner {
456         bots[notbot] = false;
457     }
458     
459     function isBot(address ad) public view returns (bool) {
460         return bots[ad];
461     }
462 
463     function manualswap() external {
464         require(_msgSender() == _FeeAddress);
465         uint256 contractBalance = balanceOf(address(this));
466         swapTokensForEth(contractBalance);
467     }
468     
469     function manualsend() external {
470         require(_msgSender() == _FeeAddress);
471         uint256 contractETHBalance = address(this).balance;
472         sendETHToFee(contractETHBalance);
473     }
474 
475     function setFeeRate(uint256 rate) external {
476         require(_msgSender() == _FeeAddress);
477         require(rate < 51, "Rate can't exceed 50%");
478         _feeRate = rate;
479         emit FeeRateUpdated(_feeRate);
480     }
481 
482     function setCooldownEnabled(bool onoff) external onlyOwner() {
483         _cooldownEnabled = onoff;
484         emit CooldownEnabledUpdated(_cooldownEnabled);
485     }
486 
487     function thisBalance() public view returns (uint) {
488         return balanceOf(address(this));
489     }
490 
491     function cooldownEnabled() public view returns (bool) {
492         return _cooldownEnabled;
493     }
494 
495     function timeToBuy(address buyer) public view returns (uint) {
496         return block.timestamp - cooldown[buyer].buy;
497     }
498 
499     function timeToSell(address buyer) public view returns (uint) {
500         return block.timestamp - cooldown[buyer].sell;
501     }
502 
503     function amountInPool() public view returns (uint) {
504         return balanceOf(uniswapV2Pair);
505     }
506 }