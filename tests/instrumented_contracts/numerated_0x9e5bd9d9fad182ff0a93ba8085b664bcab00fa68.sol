1 /**
2  * 
3  * 
4  * 
5  * SPDX-License-Identifier: UNLICENSED 
6  * 
7 */
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if(a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     address private _previousOwner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }  
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract DINGER is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _rOwned;
128     mapping (address => uint256) private _tOwned;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private _bots;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1e12 * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     
137     string private constant _name = unicode"Dinger Token";
138     string private constant _symbol = unicode"DINGER";
139     
140     uint8 private constant _decimals = 9;
141     uint256 private _taxFee = 1;
142     uint256 private _teamFee = 7;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     address payable private _FeeAddress;
146     address payable private _marketingWalletAddress;
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen = false;
150     bool private _noTaxMode = false;
151     bool private inSwap = false;
152     uint256 private walletLimitDuration;
153     struct User {
154         uint256 buyCD;
155         bool exists;
156     }
157 
158     event MaxBuyAmountUpdated(uint _maxBuyAmount);
159     event CooldownEnabledUpdated(bool _cooldown);
160     event FeeMultiplierUpdated(uint _multiplier);
161     event FeeRateUpdated(uint _rate);
162 
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168         constructor (address payable FeeAddress, address payable marketingWalletAddress) {
169         _FeeAddress = FeeAddress;
170         _marketingWalletAddress = marketingWalletAddress;
171         _rOwned[_msgSender()] = _rTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[FeeAddress] = true;
175         _isExcludedFromFee[marketingWalletAddress] = true;
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return tokenFromReflection(_rOwned[account]);
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
216         return true;
217     }
218 
219     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
220         require(rAmount <= _rTotal, "Amount must be less than total reflections");
221         uint256 currentRate =  _getRate();
222         return rAmount.div(currentRate);
223     }
224 
225     function removeAllFee() private {
226         if(_taxFee == 0 && _teamFee == 0) return;
227         _previousTaxFee = _taxFee;
228         _previousteamFee = _teamFee;
229         _taxFee = 0;
230         _teamFee = 0;
231     }
232     
233     function restoreAllFee() private {
234         _taxFee = _previousTaxFee;
235         _teamFee = _previousteamFee;
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) private {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244     
245     function _transfer(address from, address to, uint256 amount) private {
246         require(from != address(0), "ERC20: transfer from the zero address");
247         require(to != address(0), "ERC20: transfer to the zero address");
248         require(amount > 0, "Transfer amount must be greater than zero");
249 
250         if(from != owner() && to != owner()) {
251             
252             require(!_bots[from] && !_bots[to]);
253             
254             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
255                 require(tradingOpen, "Trading not yet enabled.");
256                 
257                 if (walletLimitDuration > block.timestamp) {
258                     uint walletBalance = balanceOf(address(to));
259                     require(amount.add(walletBalance) <= _tTotal.mul(2).div(100));
260                 }
261             }
262             uint256 contractTokenBalance = balanceOf(address(this));
263 
264             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
265                 if(contractTokenBalance > 0) {
266                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(5).div(100)) {
267                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(5).div(100);
268                     }
269                     swapTokensForEth(contractTokenBalance);
270                 }
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277         bool takeFee = true;
278 
279         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _noTaxMode){
280             takeFee = false;
281         }
282         
283         _tokenTransfer(from,to,amount,takeFee);
284     }
285 
286     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = uniswapV2Router.WETH();
290         _approve(address(this), address(uniswapV2Router), tokenAmount);
291         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp
297         );
298     }
299         
300     function sendETHToFee(uint256 amount) private {
301         _FeeAddress.transfer(amount.div(2));
302         _marketingWalletAddress.transfer(amount.div(2));
303     }
304     
305     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
306         if(!takeFee)
307             removeAllFee();
308         _transferStandard(sender, recipient, amount);
309         if(!takeFee)
310             restoreAllFee();
311     }
312 
313     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
314         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
315         _rOwned[sender] = _rOwned[sender].sub(rAmount);
316         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
317 
318         _takeTeam(tTeam);
319         _reflectFee(rFee, tFee);
320         emit Transfer(sender, recipient, tTransferAmount);
321     }
322 
323     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
324         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
325         uint256 currentRate =  _getRate();
326         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
327         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
328     }
329 
330     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
331         uint256 tFee = tAmount.mul(taxFee).div(100);
332         uint256 tTeam = tAmount.mul(TeamFee).div(100);
333         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
334         return (tTransferAmount, tFee, tTeam);
335     }
336 
337     function _getRate() private view returns(uint256) {
338         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
339         return rSupply.div(tSupply);
340     }
341 
342     function _getCurrentSupply() private view returns(uint256, uint256) {
343         uint256 rSupply = _rTotal;
344         uint256 tSupply = _tTotal;
345         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
346         return (rSupply, tSupply);
347     }
348 
349     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
350         uint256 rAmount = tAmount.mul(currentRate);
351         uint256 rFee = tFee.mul(currentRate);
352         uint256 rTeam = tTeam.mul(currentRate);
353         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
354         return (rAmount, rTransferAmount, rFee);
355     }
356 
357     function _takeTeam(uint256 tTeam) private {
358         uint256 currentRate =  _getRate();
359         uint256 rTeam = tTeam.mul(currentRate);
360 
361         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
362     }
363 
364     function _reflectFee(uint256 rFee, uint256 tFee) private {
365         _rTotal = _rTotal.sub(rFee);
366         _tFeeTotal = _tFeeTotal.add(tFee);
367     }
368 
369     receive() external payable {}
370     
371     function openTrading() external onlyOwner() {
372         require(!tradingOpen,"trading is already open");
373         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
374         uniswapV2Router = _uniswapV2Router;
375         _approve(address(this), address(uniswapV2Router), _tTotal);
376         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
377         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
378         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
379         tradingOpen = true;
380         walletLimitDuration = block.timestamp + (60 minutes);
381     }
382     
383     function setMarketingWallet (address payable marketingWalletAddress) external {
384         require(_msgSender() == _FeeAddress);
385         _isExcludedFromFee[_marketingWalletAddress] = false;
386         _marketingWalletAddress = marketingWalletAddress;
387         _isExcludedFromFee[marketingWalletAddress] = true;
388     }
389 
390     function excludeFromFee (address payable ad) external {
391         require(_msgSender() == _FeeAddress);
392         _isExcludedFromFee[ad] = true;
393     }
394     
395     function includeToFee (address payable ad) external {
396         require(_msgSender() == _FeeAddress);
397         _isExcludedFromFee[ad] = false;
398     }
399     
400     function setNoTaxMode(bool onoff) external {
401         require(_msgSender() == _FeeAddress);
402         _noTaxMode = onoff;
403     }
404     
405     function setTeamFee(uint256 team) external {
406         require(_msgSender() == _FeeAddress);
407         require(team <= 7);
408         _teamFee = team;
409     }
410         
411     function setTaxFee(uint256 tax) external {
412         require(_msgSender() == _FeeAddress);
413         require(tax <= 1);
414         _taxFee = tax;
415     }
416     
417     function setBots(address[] memory bots_) public onlyOwner {
418         for (uint i = 0; i < bots_.length; i++) {
419             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
420                 _bots[bots_[i]] = true;
421             }
422         }
423     }
424     
425     function delBot(address notbot) public onlyOwner {
426         _bots[notbot] = false;
427     }
428     
429     function isBot(address ad) public view returns (bool) {
430         return _bots[ad];
431     }
432     
433     function manualswap() external {
434         require(_msgSender() == _FeeAddress);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438     
439     function manualsend() external {
440         require(_msgSender() == _FeeAddress);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444 
445     function thisBalance() public view returns (uint) {
446         return balanceOf(address(this));
447     }
448 
449     function amountInPool() public view returns (uint) {
450         return balanceOf(uniswapV2Pair);
451     }
452 }