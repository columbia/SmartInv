1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-19
3 */
4 
5 /* 
6 SPDX-License-Identifier: UNLICENSED 
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
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract TWOSUBI is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => User) private cooldown;
131     uint256 private constant MAX = ~uint256(0);
132     uint256 private constant _tTotal = 1e12 * 10**9;
133     uint256 private _rTotal = (MAX - (MAX % _tTotal));
134     uint256 private _tFeeTotal;
135     string private constant _name = unicode"TWOSUBI" ;
136     string private constant _symbol = unicode"TWOSUBI";
137     uint8 private constant _decimals = 9;
138     uint256 private _taxFee = 6;
139     uint256 private _teamFee = 4;
140     uint256 private _feeRate = 5;
141     uint256 private _feeMultiplier = 1000;
142     uint256 private _launchTime;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     uint256 private _maxBuyAmount;
146     address payable private _FeeAddress;
147     address payable private _marketingWalletAddress;
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private _cooldownEnabled = true;
152     bool private inSwap = false;
153     bool private _useImpactFeeSetter = true;
154     uint256 private buyLimitEnd;
155     struct User {
156         uint256 buy;
157         uint256 sell;
158         bool exists;
159     }
160 
161     event MaxBuyAmountUpdated(uint _maxBuyAmount);
162     event CooldownEnabledUpdated(bool _cooldown);
163     event FeeMultiplierUpdated(uint _multiplier);
164     event FeeRateUpdated(uint _rate);
165 
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
172         _FeeAddress = FeeAddress;
173         _marketingWalletAddress = marketingWalletAddress;
174         _rOwned[_msgSender()] = _rTotal;
175         _isExcludedFromFee[owner()] = true;
176         _isExcludedFromFee[address(this)] = true;
177         _isExcludedFromFee[FeeAddress] = true;
178         _isExcludedFromFee[marketingWalletAddress] = true;
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public pure override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return tokenFromReflection(_rOwned[account]);
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
223         require(rAmount <= _rTotal, "Amount must be less than total reflections");
224         uint256 currentRate =  _getRate();
225         return rAmount.div(currentRate);
226     }
227 
228     function removeAllFee() private {
229         if(_taxFee == 0 && _teamFee == 0) return;
230         _previousTaxFee = _taxFee;
231         _previousteamFee = _teamFee;
232         _taxFee = 0;
233         _teamFee = 0;
234     }
235     
236     function restoreAllFee() private {
237         _taxFee = _previousTaxFee;
238         _teamFee = _previousteamFee;
239     }
240 
241     function setFee(uint256 impactFee) private {
242         uint256 _impactFee = 10;
243         if(impactFee < 10) {
244             _impactFee = 10;
245         } else if(impactFee > 40) {
246             _impactFee = 40;
247         } else {
248             _impactFee = impactFee;
249         }
250         if(_impactFee.mod(2) != 0) {
251             _impactFee++;
252         }
253         _taxFee = (_impactFee.mul(1)).div(10);
254         _teamFee = (_impactFee.mul(9)).div(10);
255     }
256 
257     function _approve(address owner, address spender, uint256 amount) private {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 
264     function _transfer(address from, address to, uint256 amount) private {
265         require(from != address(0), "ERC20: transfer from the zero address");
266         require(to != address(0), "ERC20: transfer to the zero address");
267         require(amount > 0, "Transfer amount must be greater than zero");
268 
269         if(from != owner() && to != owner()) {
270             if(_cooldownEnabled) {
271                 if(!cooldown[msg.sender].exists) {
272                     cooldown[msg.sender] = User(0,0,true);
273                 }
274             }
275 
276             // buy
277             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
278                 require(tradingOpen, "Trading not yet enabled.");
279                 _taxFee = 1;
280                 _teamFee = 9;
281                 if(_cooldownEnabled) {
282                     if(buyLimitEnd > block.timestamp) {
283                         require(amount <= _maxBuyAmount);
284                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
285                         cooldown[to].buy = block.timestamp + (30 seconds);
286                     }
287                 }
288                 if(_cooldownEnabled) {
289                     cooldown[to].sell = block.timestamp + (15 seconds);
290                 }
291             }
292             uint256 contractTokenBalance = balanceOf(address(this));
293 
294             // sell
295             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
296 
297                 if(_cooldownEnabled) {
298                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
299                 }
300 
301                 if(_useImpactFeeSetter) {
302                     uint256 feeBasis = amount.mul(_feeMultiplier);
303                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
304                     setFee(feeBasis);
305                 }
306 
307                 if(contractTokenBalance > 0) {
308                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
309                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
310                     }
311                     swapTokensForEth(contractTokenBalance);
312                 }
313                 uint256 contractETHBalance = address(this).balance;
314                 if(contractETHBalance > 0) {
315                     sendETHToFee(address(this).balance);
316                 }
317             }
318         }
319         bool takeFee = true;
320 
321         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
322             takeFee = false;
323         }
324         
325         _tokenTransfer(from,to,amount,takeFee);
326     }
327 
328     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
329         address[] memory path = new address[](2);
330         path[0] = address(this);
331         path[1] = uniswapV2Router.WETH();
332         _approve(address(this), address(uniswapV2Router), tokenAmount);
333         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
334             tokenAmount,
335             0,
336             path,
337             address(this),
338             block.timestamp
339         );
340     }
341         
342     function sendETHToFee(uint256 amount) private {
343         _FeeAddress.transfer(amount.div(2));
344         _marketingWalletAddress.transfer(amount.div(2));
345     }
346     
347     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
348         if(!takeFee)
349             removeAllFee();
350         _transferStandard(sender, recipient, amount);
351         if(!takeFee)
352             restoreAllFee();
353     }
354 
355     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
356         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
357         _rOwned[sender] = _rOwned[sender].sub(rAmount);
358         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
359 
360         _takeTeam(tTeam);
361         _reflectFee(rFee, tFee);
362         emit Transfer(sender, recipient, tTransferAmount);
363     }
364 
365     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
366         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
367         uint256 currentRate =  _getRate();
368         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
369         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
370     }
371 
372     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
373         uint256 tFee = tAmount.mul(taxFee).div(100);
374         uint256 tTeam = tAmount.mul(TeamFee).div(100);
375         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
376         return (tTransferAmount, tFee, tTeam);
377     }
378 
379     function _getRate() private view returns(uint256) {
380         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
381         return rSupply.div(tSupply);
382     }
383 
384     function _getCurrentSupply() private view returns(uint256, uint256) {
385         uint256 rSupply = _rTotal;
386         uint256 tSupply = _tTotal;
387         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
388         return (rSupply, tSupply);
389     }
390 
391     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
392         uint256 rAmount = tAmount.mul(currentRate);
393         uint256 rFee = tFee.mul(currentRate);
394         uint256 rTeam = tTeam.mul(currentRate);
395         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
396         return (rAmount, rTransferAmount, rFee);
397     }
398 
399     function _takeTeam(uint256 tTeam) private {
400         uint256 currentRate =  _getRate();
401         uint256 rTeam = tTeam.mul(currentRate);
402 
403         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
404     }
405 
406     function _reflectFee(uint256 rFee, uint256 tFee) private {
407         _rTotal = _rTotal.sub(rFee);
408         _tFeeTotal = _tFeeTotal.add(tFee);
409     }
410 
411     receive() external payable {}
412     
413     function addLiquidity() external onlyOwner() {
414         require(!tradingOpen,"trading is already open");
415         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
416         uniswapV2Router = _uniswapV2Router;
417         _approve(address(this), address(uniswapV2Router), _tTotal);
418         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
419         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
420         _maxBuyAmount = 10000000000 * 10**9;
421         _launchTime = block.timestamp;
422         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
423     }
424 
425     function openTrading() public onlyOwner {
426         tradingOpen = true;
427         buyLimitEnd = block.timestamp + (240 seconds);
428     }
429 
430     function manualswap() external {
431         require(_msgSender() == _FeeAddress);
432         uint256 contractBalance = balanceOf(address(this));
433         swapTokensForEth(contractBalance);
434     }
435     
436     function manualsend() external {
437         require(_msgSender() == _FeeAddress);
438         uint256 contractETHBalance = address(this).balance;
439         sendETHToFee(contractETHBalance);
440     }
441 
442     // fallback in case contract is not releasing tokens fast enough
443     function setFeeRate(uint256 rate) external {
444         require(_msgSender() == _FeeAddress);
445         require(rate < 51, "Rate can't exceed 50%");
446         _feeRate = rate;
447         emit FeeRateUpdated(_feeRate);
448     }
449 
450     function setCooldownEnabled(bool onoff) external onlyOwner() {
451         _cooldownEnabled = onoff;
452         emit CooldownEnabledUpdated(_cooldownEnabled);
453     }
454 
455     function thisBalance() public view returns (uint) {
456         return balanceOf(address(this));
457     }
458 
459     function cooldownEnabled() public view returns (bool) {
460         return _cooldownEnabled;
461     }
462 
463     function timeToBuy(address buyer) public view returns (uint) {
464         return block.timestamp - cooldown[buyer].buy;
465     }
466 
467     function timeToSell(address buyer) public view returns (uint) {
468         return block.timestamp - cooldown[buyer].sell;
469     }
470 
471     function amountInPool() public view returns (uint) {
472         return balanceOf(uniswapV2Pair);
473     }
474 }