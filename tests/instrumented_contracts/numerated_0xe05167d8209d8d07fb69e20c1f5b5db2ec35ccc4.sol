1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-19
7 */
8 
9 /* 
10 SPDX-License-Identifier: UNLICENSED 
11 */
12 pragma solidity ^0.8.4;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if(a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70 
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }  
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract EverTrend is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _rOwned;
131     mapping (address => uint256) private _tOwned;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => User) private cooldown;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private constant _tTotal = 1e12 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139     string private constant _name = unicode"EverTrend" ;
140     string private constant _symbol = unicode"TREND";
141     uint8 private constant _decimals = 9;
142     uint256 private _taxFee = 6;
143     uint256 private _teamFee = 4;
144     uint256 private _feeRate = 5;
145     uint256 private _feeMultiplier = 1000;
146     uint256 private _launchTime;
147     uint256 private _previousTaxFee = _taxFee;
148     uint256 private _previousteamFee = _teamFee;
149     uint256 private _maxBuyAmount;
150     address payable private _FeeAddress;
151     address payable private _marketingWalletAddress;
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private _cooldownEnabled = true;
156     bool private inSwap = false;
157     bool private _useImpactFeeSetter = true;
158     uint256 private buyLimitEnd;
159     struct User {
160         uint256 buy;
161         uint256 sell;
162         bool exists;
163     }
164 
165     event MaxBuyAmountUpdated(uint _maxBuyAmount);
166     event CooldownEnabledUpdated(bool _cooldown);
167     event FeeMultiplierUpdated(uint _multiplier);
168     event FeeRateUpdated(uint _rate);
169 
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
176         _FeeAddress = FeeAddress;
177         _marketingWalletAddress = marketingWalletAddress;
178         _rOwned[_msgSender()] = _rTotal;
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[FeeAddress] = true;
182         _isExcludedFromFee[marketingWalletAddress] = true;
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return tokenFromReflection(_rOwned[account]);
204     }
205 
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public override returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
223         return true;
224     }
225 
226     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
227         require(rAmount <= _rTotal, "Amount must be less than total reflections");
228         uint256 currentRate =  _getRate();
229         return rAmount.div(currentRate);
230     }
231 
232     function removeAllFee() private {
233         if(_taxFee == 0 && _teamFee == 0) return;
234         _previousTaxFee = _taxFee;
235         _previousteamFee = _teamFee;
236         _taxFee = 0;
237         _teamFee = 0;
238     }
239     
240     function restoreAllFee() private {
241         _taxFee = _previousTaxFee;
242         _teamFee = _previousteamFee;
243     }
244 
245     function setFee(uint256 impactFee) private {
246         uint256 _impactFee = 10;
247         if(impactFee < 10) {
248             _impactFee = 10;
249         } else if(impactFee > 40) {
250             _impactFee = 40;
251         } else {
252             _impactFee = impactFee;
253         }
254         if(_impactFee.mod(2) != 0) {
255             _impactFee++;
256         }
257         _taxFee = (_impactFee.mul(1)).div(10);
258         _teamFee = (_impactFee.mul(9)).div(10);
259     }
260 
261     function _approve(address owner, address spender, uint256 amount) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function _transfer(address from, address to, uint256 amount) private {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272 
273         if(from != owner() && to != owner()) {
274             if(_cooldownEnabled) {
275                 if(!cooldown[msg.sender].exists) {
276                     cooldown[msg.sender] = User(0,0,true);
277                 }
278             }
279 
280             // buy
281             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
282                 require(tradingOpen, "Trading not yet enabled.");
283                 _taxFee = 1;
284                 _teamFee = 9;
285                 if(_cooldownEnabled) {
286                     if(buyLimitEnd > block.timestamp) {
287                         require(amount <= _maxBuyAmount);
288                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
289                         cooldown[to].buy = block.timestamp + (30 seconds);
290                     }
291                 }
292                 if(_cooldownEnabled) {
293                     cooldown[to].sell = block.timestamp + (15 seconds);
294                 }
295             }
296             uint256 contractTokenBalance = balanceOf(address(this));
297 
298             // sell
299             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
300 
301                 if(_cooldownEnabled) {
302                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
303                 }
304 
305                 if(_useImpactFeeSetter) {
306                     uint256 feeBasis = amount.mul(_feeMultiplier);
307                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
308                     setFee(feeBasis);
309                 }
310 
311                 if(contractTokenBalance > 0) {
312                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
313                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
314                     }
315                     swapTokensForEth(contractTokenBalance);
316                 }
317                 uint256 contractETHBalance = address(this).balance;
318                 if(contractETHBalance > 0) {
319                     sendETHToFee(address(this).balance);
320                 }
321             }
322         }
323         bool takeFee = true;
324 
325         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
326             takeFee = false;
327         }
328         
329         _tokenTransfer(from,to,amount,takeFee);
330     }
331 
332     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
333         address[] memory path = new address[](2);
334         path[0] = address(this);
335         path[1] = uniswapV2Router.WETH();
336         _approve(address(this), address(uniswapV2Router), tokenAmount);
337         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
338             tokenAmount,
339             0,
340             path,
341             address(this),
342             block.timestamp
343         );
344     }
345         
346     function sendETHToFee(uint256 amount) private {
347         _FeeAddress.transfer(amount.div(2));
348         _marketingWalletAddress.transfer(amount.div(2));
349     }
350     
351     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
352         if(!takeFee)
353             removeAllFee();
354         _transferStandard(sender, recipient, amount);
355         if(!takeFee)
356             restoreAllFee();
357     }
358 
359     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
360         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
361         _rOwned[sender] = _rOwned[sender].sub(rAmount);
362         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
363 
364         _takeTeam(tTeam);
365         _reflectFee(rFee, tFee);
366         emit Transfer(sender, recipient, tTransferAmount);
367     }
368 
369     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
370         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
371         uint256 currentRate =  _getRate();
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
373         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
374     }
375 
376     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
377         uint256 tFee = tAmount.mul(taxFee).div(100);
378         uint256 tTeam = tAmount.mul(TeamFee).div(100);
379         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
380         return (tTransferAmount, tFee, tTeam);
381     }
382 
383     function _getRate() private view returns(uint256) {
384         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
385         return rSupply.div(tSupply);
386     }
387 
388     function _getCurrentSupply() private view returns(uint256, uint256) {
389         uint256 rSupply = _rTotal;
390         uint256 tSupply = _tTotal;
391         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
392         return (rSupply, tSupply);
393     }
394 
395     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
396         uint256 rAmount = tAmount.mul(currentRate);
397         uint256 rFee = tFee.mul(currentRate);
398         uint256 rTeam = tTeam.mul(currentRate);
399         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
400         return (rAmount, rTransferAmount, rFee);
401     }
402 
403     function _takeTeam(uint256 tTeam) private {
404         uint256 currentRate =  _getRate();
405         uint256 rTeam = tTeam.mul(currentRate);
406 
407         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
408     }
409 
410     function _reflectFee(uint256 rFee, uint256 tFee) private {
411         _rTotal = _rTotal.sub(rFee);
412         _tFeeTotal = _tFeeTotal.add(tFee);
413     }
414 
415     receive() external payable {}
416     
417     function addLiquidity() external onlyOwner() {
418         require(!tradingOpen,"trading is already open");
419         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
420         uniswapV2Router = _uniswapV2Router;
421         _approve(address(this), address(uniswapV2Router), _tTotal);
422         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
423         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
424         _maxBuyAmount = 10000000000 * 10**9;
425         _launchTime = block.timestamp;
426         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
427     }
428 
429     function openTrading() public onlyOwner {
430         tradingOpen = true;
431         buyLimitEnd = block.timestamp + (240 seconds);
432     }
433 
434     function manualswap() external {
435         require(_msgSender() == _FeeAddress);
436         uint256 contractBalance = balanceOf(address(this));
437         swapTokensForEth(contractBalance);
438     }
439     
440     function manualsend() external {
441         require(_msgSender() == _FeeAddress);
442         uint256 contractETHBalance = address(this).balance;
443         sendETHToFee(contractETHBalance);
444     }
445 
446     // fallback in case contract is not releasing tokens fast enough
447     function setFeeRate(uint256 rate) external {
448         require(_msgSender() == _FeeAddress);
449         require(rate < 51, "Rate can't exceed 50%");
450         _feeRate = rate;
451         emit FeeRateUpdated(_feeRate);
452     }
453 
454     function setCooldownEnabled(bool onoff) external onlyOwner() {
455         _cooldownEnabled = onoff;
456         emit CooldownEnabledUpdated(_cooldownEnabled);
457     }
458 
459     function thisBalance() public view returns (uint) {
460         return balanceOf(address(this));
461     }
462 
463     function cooldownEnabled() public view returns (bool) {
464         return _cooldownEnabled;
465     }
466 
467     function timeToBuy(address buyer) public view returns (uint) {
468         return block.timestamp - cooldown[buyer].buy;
469     }
470 
471     function timeToSell(address buyer) public view returns (uint) {
472         return block.timestamp - cooldown[buyer].sell;
473     }
474 
475     function amountInPool() public view returns (uint) {
476         return balanceOf(uniswapV2Pair);
477     }
478 }