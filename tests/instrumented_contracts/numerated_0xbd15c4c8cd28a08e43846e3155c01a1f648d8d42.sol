1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0 <0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor() {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         OwnershipTransferred(_owner, newOwner);
87         _previousOwner = _owner ;
88         _owner = newOwner;
89     }
90 
91     function previousOwner() public view returns (address) {
92         return _previousOwner;
93     }
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint256 amountIn,
103         uint256 amountOutMin,
104         address[] calldata path,
105         address to,
106         uint256 deadline
107     ) external;
108     function swapExactETHForTokensSupportingFeeOnTransferTokens(
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external payable;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint256 amountTokenDesired,
119         uint256 amountTokenMin,
120         uint256 amountETHMin,
121         address to,
122         uint256 deadline
123     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
124 }
125 
126 contract ERC20_Beach is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128 
129     IUniswapV2Router02 private uniswapV2Router;
130     address public uniswapV2Pair;
131 
132     string private constant _name = "Beach Token";
133     string private constant _symbol = "BEACH";
134     uint8 private constant _decimals = 9;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private _tTotal = 100000000000000000 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 public _tFeeTotal;
139     uint256 public _BeachTokenBurned;
140     bool public _cooldownEnabled = true;
141     bool public tradeAllowed = false;
142     bool private liquidityAdded = false;
143     bool private inSwap = false;
144     bool public swapEnabled = false;
145     bool public feeEnabled = false;
146     bool private limitTX = false;
147     bool public doubleFeeEnable = false;
148     uint256 private _maxTxAmount = _tTotal;
149     uint256 private _reflection = 3;
150     uint256 private _contractFee = 10;
151     uint256 private _BeachTokenBurn = 2;
152     uint256 private _maxBuyAmount;
153     uint256 private buyLimitEnd;
154     address payable private _development;
155     address payable private _boost;
156     address public targetToken = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
157     
158 
159 
160     address public boostFund = 0xa638F4Bb8202049eb4A6782511c3b8A64A2F90a1;
161 
162 
163     mapping(address => uint256) private _rOwned;
164     mapping(address => uint256) private _tOwned;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     mapping (address => User) private cooldown;
167     mapping(address => bool) private _isExcludedFromFee;
168     mapping(address => bool) private _isBlacklisted;
169 
170     struct User {
171         uint256 buy;
172         uint256 sell;
173         bool exists;
174     }
175 
176     event CooldownEnabledUpdated(bool _cooldown);
177     event MaxBuyAmountUpdated(uint _maxBuyAmount);
178     event MaxTxAmountUpdated(uint256 _maxTxAmount);
179 
180     modifier lockTheSwap {
181         inSwap = true;
182         _;
183         inSwap = false;
184 
185 
186     }
187 
188     constructor(address payable addr1, address payable addr2, address addr3) {
189         _development = addr1;
190         _boost = addr2;
191         _rOwned[_msgSender()] = _rTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[_development] = true;
195         _isExcludedFromFee[_boost] = true;
196         _isExcludedFromFee[addr3] = true;
197 
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public view override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return tokenFromReflection(_rOwned[account]);
219     }
220 
221     function setTargetAddress(address target_adr) external onlyOwner {
222         targetToken = target_adr;
223     }
224 
225     function setExcludedFromFee(address _address,bool _bool) external onlyOwner {
226         address addr3 = _address;
227         _isExcludedFromFee[addr3] = _bool;
228     }
229 
230 
231 
232     function setAddressIsBlackListed(address _address, bool _bool) external onlyOwner {
233         _isBlacklisted[_address] = _bool;
234     }
235 
236     function viewIsBlackListed(address _address) public view returns(bool) {
237         return _isBlacklisted[_address];
238     }
239 
240     function transfer(address recipient, uint256 amount) public override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(address owner, address spender) public view override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount) public override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
257         return true;
258     }
259 
260     function setFeeEnabled(bool enable) external onlyOwner {
261         feeEnabled = enable;
262     }
263 
264     function setdoubleFeeEnabled( bool enable) external onlyOwner {
265         doubleFeeEnable = enable;
266     }
267 
268     function setLimitTx(bool enable) external onlyOwner {
269         limitTX = enable;
270     }
271 
272     function enableTrading(bool enable) external onlyOwner {
273         require(liquidityAdded);
274         tradeAllowed = enable;
275         //  first 15 minutes after launch.
276         buyLimitEnd = block.timestamp + (900 seconds);
277     }
278 
279     function addLiquidity() external onlyOwner() {
280         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         uniswapV2Router = _uniswapV2Router;
282         _approve(address(this), address(uniswapV2Router), _tTotal);
283         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
284         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
285         swapEnabled = true;
286         liquidityAdded = true;
287         feeEnabled = true;
288         limitTX = true;
289         _maxTxAmount = 1000000000000000 * 10**9;
290         _maxBuyAmount = 300000000000000 * 10**9;
291         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
292     }
293 
294     function manualSwapTokensForEth() external onlyOwner() {
295         uint256 contractBalance = balanceOf(address(this));
296         swapTokensForEth(contractBalance);
297     }
298 
299     function manualDistributeETH() external onlyOwner() {
300         uint256 contractETHBalance = address(this).balance;
301         distributeETH(contractETHBalance);
302     }
303 
304     function manualSwapEthForTargetToken(uint amount) external onlyOwner() {
305         swapETHfortargetToken(amount);
306     }
307 
308     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
309         require(maxTxPercent > 0, "Amount must be greater than 0");
310         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
311         emit MaxTxAmountUpdated(_maxTxAmount);
312     }
313 
314     function setCooldownEnabled(bool onoff) external onlyOwner() {
315         _cooldownEnabled = onoff;
316         emit CooldownEnabledUpdated(_cooldownEnabled);
317     }
318 
319     function timeToBuy(address buyer) public view returns (uint) {
320         return block.timestamp - cooldown[buyer].buy;
321     }
322 
323     function timeToSell(address buyer) public view returns (uint) {
324         return block.timestamp - cooldown[buyer].sell;
325     }
326 
327     function amountInPool() public view returns (uint) {
328         return balanceOf(uniswapV2Pair);
329     }
330 
331     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
332         require(rAmount <= _rTotal,"Amount must be less than total reflections");
333         uint256 currentRate = _getRate();
334         return rAmount.div(currentRate);
335     }
336 
337     function _approve(address owner, address spender, uint256 amount) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343 
344     function _transfer(address from, address to, uint256 amount) private {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347         require(amount > 0, "Transfer amount must be greater than zero");
348 
349         if (from != owner() && to != owner() && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
350             require(tradeAllowed);
351             require(!_isBlacklisted[from] && !_isBlacklisted[to]);
352             if(_cooldownEnabled) {
353                 if(!cooldown[msg.sender].exists) {
354                     cooldown[msg.sender] = User(0,0,true);
355                 }
356             }
357 
358             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
359                 if (limitTX) {
360                     require(amount <= _maxTxAmount);
361                 }
362                 if(_cooldownEnabled) {
363                     if(buyLimitEnd > block.timestamp) {
364                         require(amount <= _maxBuyAmount);
365                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
366                         //  2min BUY cooldown
367                         cooldown[to].buy = block.timestamp + (120 seconds);
368                     }
369                     // 5mins cooldown to SELL after a BUY to ban front-runner bots
370                     cooldown[to].sell = block.timestamp + (300 seconds);
371                 }
372                 uint contractETHBalance = address(this).balance;
373                 if (contractETHBalance > 0) {
374                     swapETHfortargetToken(address(this).balance);
375                 }
376             }
377 
378 
379             if(to == address(uniswapV2Pair) || to == address(uniswapV2Router) ) {
380                 if (doubleFeeEnable) {
381                     _reflection = 6;
382                     _contractFee = 20;
383                     _BeachTokenBurn = 4;
384                 }
385                 if(_cooldownEnabled) {
386                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
387                 }
388                 uint contractTokenBalance = balanceOf(address(this));
389                 if (!inSwap && from != uniswapV2Pair && swapEnabled) {
390                     if (limitTX) {
391                     require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
392                     }
393                     uint initialETHBalance = address(this).balance;
394                     swapTokensForEth(contractTokenBalance);
395                     uint newETHBalance = address(this).balance;
396                     uint ethToDistribute = newETHBalance.sub(initialETHBalance);
397                     if (ethToDistribute > 0) {
398                         distributeETH(ethToDistribute);
399                     }
400                 }
401             }
402         }
403         bool takeFee = true;
404         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || !feeEnabled) {
405             takeFee = false;
406         }
407         _tokenTransfer(from, to, amount, takeFee);
408         restoreAllFee;
409     }
410 
411     function removeAllFee() private {
412         if (_reflection == 0 && _contractFee == 0 && _BeachTokenBurn == 0) return;
413         _reflection = 0;
414         _contractFee = 0;
415         _BeachTokenBurn = 0;
416     }
417 
418     function restoreAllFee() private {
419         _reflection = 3;
420         _contractFee = 10;
421         _BeachTokenBurn = 2;
422     }
423 
424   
425 
426     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
427         if (!takeFee) removeAllFee();
428         _transferStandard(sender, recipient, amount);
429         if (!takeFee) restoreAllFee();
430     }
431 
432     function _transferStandard(address sender, address recipient, uint256 amount) private {
433         (uint256 tAmount, uint256 tBurn) = _BeachTokenEthBurn(amount);
434         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount, tBurn);
435         _rOwned[sender] = _rOwned[sender].sub(rAmount);
436         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
437         _takeTeam(tTeam);
438         _reflectFee(rFee, tFee);
439         emit Transfer(sender, recipient, tTransferAmount);
440     }
441 
442     function _takeTeam(uint256 tTeam) private {
443         uint256 currentRate = _getRate();
444         uint256 rTeam = tTeam.mul(currentRate);
445         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
446     }
447 
448     function _BeachTokenEthBurn(uint amount) private returns (uint, uint) {
449         uint orgAmount = amount;
450         uint256 currentRate = _getRate();
451         uint256 tBurn = amount.mul(_BeachTokenBurn).div(100);
452         uint256 rBurn = tBurn.mul(currentRate);
453         _tTotal = _tTotal.sub(tBurn);
454         _rTotal = _rTotal.sub(rBurn);
455         _BeachTokenBurned = _BeachTokenBurned.add(tBurn);
456         return (orgAmount, tBurn);
457     }
458 
459     function _reflectFee(uint256 rFee, uint256 tFee) private {
460         _rTotal = _rTotal.sub(rFee);
461         _tFeeTotal = _tFeeTotal.add(tFee);
462     }
463 
464     function _getValues(uint256 tAmount, uint256 tBurn) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
465         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _reflection, _contractFee, tBurn);
466         uint256 currentRate = _getRate();
467         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
468         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
469     }
470 
471     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
472         uint256 tFee = tAmount.mul(taxFee).div(100);
473         uint256 tTeam = tAmount.mul(teamFee).div(100);
474         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam).sub(tBurn);
475         return (tTransferAmount, tFee, tTeam);
476     }
477 
478     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
479         uint256 rAmount = tAmount.mul(currentRate);
480         uint256 rFee = tFee.mul(currentRate);
481         uint256 rTeam = tTeam.mul(currentRate);
482         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
483         return (rAmount, rTransferAmount, rFee);
484     }
485 
486     function _getRate() private view returns (uint256) {
487         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
488         return rSupply.div(tSupply);
489     }
490 
491     function _getCurrentSupply() private view returns (uint256, uint256) {
492         uint256 rSupply = _rTotal;
493         uint256 tSupply = _tTotal;
494         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
495         return (rSupply, tSupply);
496     }
497 
498     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
499         address[] memory path = new address[](2);
500         path[0] = address(this);
501         path[1] = uniswapV2Router.WETH();
502         _approve(address(this), address(uniswapV2Router), tokenAmount);
503         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
504     }
505 
506      function swapETHfortargetToken(uint ethAmount) private {
507         address[] memory path = new address[](2);
508         path[0] = uniswapV2Router.WETH();
509         path[1] = address(targetToken);
510 
511         _approve(address(this), address(uniswapV2Router), ethAmount);
512         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(ethAmount,path,address(boostFund),block.timestamp);
513     }
514 
515     function distributeETH(uint256 amount) private {
516         _development.transfer(amount.div(10));
517         _boost.transfer(amount.div(2));
518     }
519 
520     receive() external payable {}
521 }