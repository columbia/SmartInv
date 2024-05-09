1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 
5 interface IFactory {
6 	function createPair(address tokenA, address tokenB)
7 	external
8 	returns (address pair);
9 
10 	function getPair(address tokenA, address tokenB)
11 	external
12 	view
13 	returns (address pair);
14 }
15 
16 interface IRouter {
17 	function factory() external pure returns (address);
18 
19 	function WETH() external pure returns (address);
20 
21 	function addLiquidityETH(
22 		address token,
23 		uint256 amountTokenDesired,
24 		uint256 amountTokenMin,
25 		uint256 amountETHMin,
26 		address to,
27 		uint256 deadline
28 	)
29 	external
30 	payable
31 	returns (
32 		uint256 amountToken,
33 		uint256 amountETH,
34 		uint256 liquidity
35 	);
36 
37 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
38 		uint256 amountOutMin,
39 		address[] calldata path,
40 		address to,
41 		uint256 deadline
42 	) external payable;
43 
44 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
45 		uint256 amountIn,
46 		uint256 amountOutMin,
47 		address[] calldata path,
48 		address to,
49 		uint256 deadline
50 	) external;
51 
52     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
53 }
54 
55 interface IERC20 {
56 	function totalSupply() external view returns (uint256);
57 	function balanceOf(address account) external view returns (uint256);
58 	function transfer(address recipient, uint256 amount) external returns (bool);
59 	function allowance(address owner, address spender) external view returns (uint256);
60 	function approve(address spender, uint256 amount) external returns (bool);
61 
62 	function transferFrom(
63 		address sender,
64 		address recipient,
65 		uint256 amount
66 	) external returns (bool);
67 
68 	event Transfer(address indexed from, address indexed to, uint256 value);
69 	event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73 	function name() external view returns (string memory);
74 	function symbol() external view returns (string memory);
75 	function decimals() external view returns (uint8);
76 }
77 
78 library SafeMath {
79 
80 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
81 		uint256 c = a + b;
82 		require(c >= a, "SafeMath: addition overflow");
83 
84 		return c;
85 	}
86 
87 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88 		return sub(a, b, "SafeMath: subtraction overflow");
89 	}
90 
91 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92 		require(b <= a, errorMessage);
93 		uint256 c = a - b;
94 
95 		return c;
96 	}
97 
98 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100 		// benefit is lost if 'b' is also tested.
101 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102 		if (a == 0) {
103 			return 0;
104 		}
105 
106 		uint256 c = a * b;
107 		require(c / a == b, "SafeMath: multiplication overflow");
108 
109 		return c;
110 	}
111 
112 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
113 		return div(a, b, "SafeMath: division by zero");
114 	}
115 
116 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117 		require(b > 0, errorMessage);
118 		uint256 c = a / b;
119 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121 		return c;
122 	}
123 
124 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125 		return mod(a, b, "SafeMath: modulo by zero");
126 	}
127 
128 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129 		require(b != 0, errorMessage);
130 		return a % b;
131 	}
132 }
133 
134 abstract contract Context {
135 	function _msgSender() internal view virtual returns (address) {
136 		return msg.sender;
137 	}
138 
139 	function _msgData() internal view virtual returns (bytes calldata) {
140 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
141 		return msg.data;
142 	}
143 }
144 
145 contract Ownable is Context {
146 	address private _owner;
147 
148 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150 	constructor () {
151 		address msgSender = _msgSender();
152 		_owner = msgSender;
153 		emit OwnershipTransferred(address(0), msgSender);
154 	}
155 
156 	function owner() public view returns (address) {
157 		return _owner;
158 	}
159 
160 	modifier onlyOwner() {
161 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
162 		_;
163 	}
164 
165 	function renounceOwnership() public virtual onlyOwner {
166 		emit OwnershipTransferred(_owner, address(0));
167 		_owner = address(0);
168 	}
169 
170 	function transferOwnership(address newOwner) public virtual onlyOwner {
171 		require(newOwner != address(0), "Ownable: new owner is the zero address");
172 		emit OwnershipTransferred(_owner, newOwner);
173 		_owner = newOwner;
174 	}
175 }
176 
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178 	using SafeMath for uint256;
179 
180 	mapping(address => uint256) private _balances;
181 	mapping(address => mapping(address => uint256)) private _allowances;
182 
183 	uint256 private _totalSupply;
184 	string private _name;
185 	string private _symbol;
186 
187 	constructor(string memory name_, string memory symbol_) {
188 		_name = name_;
189 		_symbol = symbol_;
190 	}
191 
192 	function name() public view virtual override returns (string memory) {
193 		return _name;
194 	}
195 
196 	function symbol() public view virtual override returns (string memory) {
197 		return _symbol;
198 	}
199 
200 	function decimals() public view virtual override returns (uint8) {
201 		return 18;
202 	}
203 
204 	function totalSupply() public view virtual override returns (uint256) {
205 		return _totalSupply;
206 	}
207 
208 	function balanceOf(address account) public view virtual override returns (uint256) {
209 		return _balances[account];
210 	}
211 
212 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
213 		_transfer(_msgSender(), recipient, amount);
214 		return true;
215 	}
216 
217 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
218 		return _allowances[owner][spender];
219 	}
220 
221 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
222 		_approve(_msgSender(), spender, amount);
223 		return true;
224 	}
225 
226 	function transferFrom(
227 		address sender,
228 		address recipient,
229 		uint256 amount
230 	) public virtual override returns (bool) {
231 		_transfer(sender, recipient, amount);
232 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
233 		return true;
234 	}
235 
236 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
237 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
238 		return true;
239 	}
240 
241 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
242 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
243 		return true;
244 	}
245 
246 	function _transfer(
247 		address sender,
248 		address recipient,
249 		uint256 amount
250 	) internal virtual {
251 		require(sender != address(0), "ERC20: transfer from the zero address");
252 		require(recipient != address(0), "ERC20: transfer to the zero address");
253 		_beforeTokenTransfer(sender, recipient, amount);
254 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
255 		_balances[recipient] = _balances[recipient].add(amount);
256 		emit Transfer(sender, recipient, amount);
257 	}
258 
259 	function _mint(address account, uint256 amount) internal virtual {
260 		require(account != address(0), "ERC20: mint to the zero address");
261 		_beforeTokenTransfer(address(0), account, amount);
262 		_totalSupply = _totalSupply.add(amount);
263 		_balances[account] = _balances[account].add(amount);
264 		emit Transfer(address(0), account, amount);
265 	}
266 
267 	function _burn(address account, uint256 amount) internal virtual {
268 		require(account != address(0), "ERC20: burn from the zero address");
269 		_beforeTokenTransfer(account, address(0), amount);
270 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
271 		_totalSupply = _totalSupply.sub(amount);
272 		emit Transfer(account, address(0), amount);
273 	}
274 
275 	function _approve(
276 		address owner,
277 		address spender,
278 		uint256 amount
279 	) internal virtual {
280 		require(owner != address(0), "ERC20: approve from the zero address");
281 		require(spender != address(0), "ERC20: approve to the zero address");
282 		_allowances[owner][spender] = amount;
283 		emit Approval(owner, spender, amount);
284 	}
285 
286 	function _beforeTokenTransfer(
287 		address from,
288 		address to,
289 		uint256 amount
290 	) internal virtual {}
291 }
292 
293 contract SlakeToken is ERC20, Ownable {
294     IRouter public uniswapV2Router;
295     address public immutable uniswapV2Pair;
296 
297     string private constant _name = "Slake";
298     string private constant _symbol = "SLAKE";
299     uint8 private constant _decimals = 18;
300 
301     bool public isTradingEnabled;
302 
303     // initialSupply
304     uint256 constant initialSupply = 500000000 * (10**18);
305 
306     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
307 
308     // max wallet is 2.0% of initialSupply
309     uint256 public maxWalletAmount = initialSupply * 200 / 10000;
310     // max buy and sell tx is 1.0 % of initialSupply
311     uint256 public maxTxAmount = initialSupply * 100 / 10000;
312 
313     bool private _swapping;
314     uint256 public minimumTokensBeforeSwap = initialSupply * 25 / 100000;
315 
316     address public liquidityWallet;
317     address public operationsWallet;
318     address public buyBackWallet;
319 
320     struct CustomTaxPeriod {
321         bytes23 periodName;
322         uint8 blocksInPeriod;
323         uint256 timeInPeriod;
324         uint8 liquidityFeeOnBuy;
325         uint8 liquidityFeeOnSell;
326         uint8 operationsFeeOnBuy;
327         uint8 operationsFeeOnSell;
328         uint8 buyBackFeeOnBuy;
329         uint8 buyBackFeeOnSell;
330     }
331 
332     // Launch taxes
333     bool private _isLaunched;
334     uint256 private _launchStartTimestamp;
335     uint256 private _launchBlockNumber;
336 
337     // Base taxes
338     CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,1,1,7,7,2,2);
339     CustomTaxPeriod private _launch = CustomTaxPeriod('base',0,0,1,2,7,7,2,3);
340 
341     mapping (address => bool) private _isExcludedFromFee;
342     mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
343     mapping (address => bool) private _isExcludedFromMaxWalletLimit;
344     mapping (address => bool) private _isAllowedToTradeWhenDisabled;
345     mapping (address => bool) private _feeOnSelectedWalletTransfers;
346     mapping (address => bool) public automatedMarketMakerPairs;
347 
348     uint8 private _liquidityFee;
349     uint8 private _operationsFee;
350     uint8 private _buyBackFee;
351     uint8 private _totalFee;
352 
353     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
354     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
355     event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
356     event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee);
357     event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
358     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
359     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
360     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
361     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
362     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
363     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
364     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
365     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
366     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
367     event ClaimETHOverflow(uint256 amount);
368     event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint256 totalFee);
369 
370     constructor() ERC20(_name, _symbol) {
371         liquidityWallet = owner();
372         operationsWallet = owner();
373         buyBackWallet = owner();
374 
375         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
376         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
377         uniswapV2Router = _uniswapV2Router;
378         uniswapV2Pair = _uniswapV2Pair;
379         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
380 
381         _isExcludedFromFee[owner()] = true;
382         _isExcludedFromFee[address(this)] = true;
383 
384         _isAllowedToTradeWhenDisabled[owner()] = true;
385 
386         _isExcludedFromMaxTransactionLimit[address(this)] = true;
387 
388         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
389         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
390         _isExcludedFromMaxWalletLimit[address(this)] = true;
391         _isExcludedFromMaxWalletLimit[owner()] = true;
392 
393         _mint(owner(), initialSupply);
394     }
395 
396     receive() external payable {}
397 
398     // Setters
399     function activateTrading() external onlyOwner {
400         isTradingEnabled = true;
401         if(_launchBlockNumber == 0) {
402             _launchBlockNumber = block.number;
403             _launchStartTimestamp = block.timestamp;
404             _isLaunched = true;
405         }
406     }
407     function deactivateTrading() external onlyOwner {
408         isTradingEnabled = false;
409     }
410     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
411 		_isAllowedToTradeWhenDisabled[account] = allowed;
412 		emit AllowedWhenTradingDisabledChange(account, allowed);
413 	}
414     function _setAutomatedMarketMakerPair(address pair, bool value) private {
415         require(automatedMarketMakerPairs[pair] != value, "SLAKE: Automated market maker pair is already set to that value");
416         automatedMarketMakerPairs[pair] = value;
417         emit AutomatedMarketMakerPairChange(pair, value);
418     }
419     function excludeFromFees(address account, bool excluded) external onlyOwner {
420         require(_isExcludedFromFee[account] != excluded, "SLAKE: Account is already the value of 'excluded'");
421         _isExcludedFromFee[account] = excluded;
422         emit ExcludeFromFeesChange(account, excluded);
423     }
424     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
425         require(_isExcludedFromMaxTransactionLimit[account] != excluded, "SLAKE: Account is already the value of 'excluded'");
426         _isExcludedFromMaxTransactionLimit[account] = excluded;
427         emit ExcludeFromMaxTransferChange(account, excluded);
428     }
429     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
430         require(_isExcludedFromMaxWalletLimit[account] != excluded, "SLAKE: Account is already the value of 'excluded'");
431         _isExcludedFromMaxWalletLimit[account] = excluded;
432         emit ExcludeFromMaxWalletChange(account, excluded);
433     }
434     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
435 		require(_feeOnSelectedWalletTransfers[account] != value, "SLAKE: The selected wallet is already set to the value ");
436 		_feeOnSelectedWalletTransfers[account] = value;
437 		emit FeeOnSelectedWalletTransfersChange(account, value);
438 	}
439     function setWallets(address newLiquidityWallet, address newOperationsWallet, address newBuyBackWallet) external onlyOwner {
440         if(liquidityWallet != newLiquidityWallet) {
441             require(newLiquidityWallet != address(0), "SLAKE: The liquidityWallet cannot be 0");
442             emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
443             liquidityWallet = newLiquidityWallet;
444         }
445         if(operationsWallet != newOperationsWallet) {
446             require(newOperationsWallet != address(0), "SLAKE: The operationsWallet cannot be 0");
447             emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
448             operationsWallet = newOperationsWallet;
449         }
450         if(buyBackWallet != newBuyBackWallet) {
451             require(newBuyBackWallet != address(0), "SLAKE: The buyBackWallet cannot be 0");
452             emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
453             buyBackWallet = newBuyBackWallet;
454         }
455     }
456     // Base fees
457     function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _buyBackFeeOnBuy) external onlyOwner {
458         _setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy);
459         emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy);
460     }
461     function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell , uint8 _buyBackFeeOnSell) external onlyOwner {
462         _setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell);
463         emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell);
464     }
465     function setUniswapRouter(address newAddress) external onlyOwner {
466         require(newAddress != address(uniswapV2Router), "SLAKE: The router already has that address");
467         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
468         uniswapV2Router = IRouter(newAddress);
469     }
470     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
471         require(newValue != maxTxAmount, "SLAKE: Cannot update maxTxAmount to same value");
472         emit MaxTransactionAmountChange(newValue, maxTxAmount);
473         maxTxAmount = newValue;
474     }
475     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
476         require(newValue != maxWalletAmount, "SLAKE: Cannot update maxWalletAmount to same value");
477         emit MaxWalletAmountChange(newValue, maxWalletAmount);
478         maxWalletAmount = newValue;
479     }
480     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
481         require(newValue != minimumTokensBeforeSwap, "SLAKE: Cannot update minimumTokensBeforeSwap to same value");
482         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
483         minimumTokensBeforeSwap = newValue;
484     }
485     function claimETHOverflow() external onlyOwner {
486         uint256 amount = address(this).balance;
487         (bool success,) = address(owner()).call{value : amount}("");
488         if (success){
489             emit ClaimETHOverflow(amount);
490         }
491     }
492 
493     // Getters
494     function getBaseBuyFees() external view returns (uint8, uint8, uint8) {
495         return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.buyBackFeeOnBuy);
496     }
497     function getBaseSellFees() external view returns (uint8, uint8, uint8) {
498         return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.buyBackFeeOnSell);
499     }
500 
501     // Main
502     function _transfer(
503         address from,
504         address to,
505         uint256 amount
506         ) internal override {
507         require(from != address(0), "ERC20: transfer from the zero address");
508         require(to != address(0), "ERC20: transfer to the zero address");
509 
510         if(amount == 0) {
511             super._transfer(from, to, 0);
512             return;
513         }
514 
515         bool isBuyFromLp = automatedMarketMakerPairs[from];
516         bool isSelltoLp = automatedMarketMakerPairs[to];
517 
518         if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
519             require(isTradingEnabled, "SLAKE: Trading is currently disabled.");
520             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
521                 require(amount <= maxTxAmount, "SLAKE: Buy amount exceeds the maxTxBuyAmount.");
522             }
523             if (!_isExcludedFromMaxWalletLimit[to]) {
524                 require((balanceOf(to) + amount) <= maxWalletAmount, "SLAKE: Expected wallet amount exceeds the maxWalletAmount.");
525             }
526         }
527 
528         _adjustTaxes(isBuyFromLp, isSelltoLp, from , to);
529         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
530 
531         if (
532             isTradingEnabled &&
533             canSwap &&
534             !_swapping &&
535             _totalFee > 0 &&
536             automatedMarketMakerPairs[to]
537         ) {
538             _swapping = true;
539             _swapAndLiquify();
540             _swapping = false;
541         }
542 
543         bool takeFee = !_swapping && isTradingEnabled;
544 
545         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
546             takeFee = false;
547         }
548 
549         if (takeFee && _totalFee > 0) {
550             uint256 fee = amount * _totalFee / 100;
551             amount = amount - fee;
552             super._transfer(from, address(this), fee);
553         }
554 
555         super._transfer(from, to, amount);
556     }
557     function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
558         _liquidityFee = 0;
559         _operationsFee = 0;
560         _buyBackFee = 0;
561 
562         if (isBuyFromLp) {
563             _liquidityFee = _base.liquidityFeeOnBuy;
564             _operationsFee = _base.operationsFeeOnBuy;
565             _buyBackFee = _base.buyBackFeeOnBuy;
566 
567         }
568         if (isSelltoLp) {
569 			if ((block.timestamp - _launchStartTimestamp) <= 86400*30) {
570 				_liquidityFee = _launch.liquidityFeeOnSell;
571 				_operationsFee = _launch.operationsFeeOnSell;
572 				_buyBackFee = _launch.buyBackFeeOnSell;
573 			}
574 			else {
575 				_liquidityFee = _base.liquidityFeeOnSell;
576 				_operationsFee = _base.operationsFeeOnSell;
577 				_buyBackFee = _base.buyBackFeeOnSell;
578 			}
579         }
580         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
581 			_liquidityFee = _base.liquidityFeeOnSell;
582             _operationsFee = _base.operationsFeeOnSell;
583             _buyBackFee = _base.buyBackFeeOnSell;
584 		}
585         _totalFee = _liquidityFee + _operationsFee + _buyBackFee;
586         emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _totalFee);
587     }
588     function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
589         uint8 _liquidityFeeOnSell,
590         uint8 _operationsFeeOnSell,
591         uint8 _buyBackFeeOnSell
592         ) private {
593         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
594             emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
595             map.liquidityFeeOnSell = _liquidityFeeOnSell;
596         }
597         if (map.operationsFeeOnSell != _operationsFeeOnSell) {
598             emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
599             map.operationsFeeOnSell = _operationsFeeOnSell;
600         }
601         if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
602             emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
603             map.buyBackFeeOnSell = _buyBackFeeOnSell;
604         }
605     }
606     function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
607         uint8 _liquidityFeeOnBuy,
608         uint8 _operationsFeeOnBuy,
609         uint8 _buyBackFeeOnBuy
610         ) private {
611         if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
612             emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
613             map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
614         }
615         if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
616             emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
617             map.operationsFeeOnBuy = _operationsFeeOnBuy;
618         }
619         if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
620             emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
621             map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
622         }
623     }
624     function _swapAndLiquify() private {
625         uint256 contractBalance = balanceOf(address(this));
626         uint256 initialETHBalance = address(this).balance;
627         uint8 _totalFeePrior = _totalFee;
628 
629         uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFeePrior / 2;
630         uint256 amountToSwap = contractBalance - amountToLiquify;
631 
632         _swapTokensForETH(amountToSwap);
633 
634         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
635         uint256 totalETHFee = _totalFeePrior - (_liquidityFee / 2);
636         uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
637         uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
638         uint256 amountETHBuyBack = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHOperations);
639 
640         payable(buyBackWallet).transfer(amountETHBuyBack);
641 
642         _swapETHForCustomToken(amountETHOperations, USDC, operationsWallet);
643 
644         if (amountToLiquify > 0) {
645             _addLiquidity(amountToLiquify, amountETHLiquidity);
646             emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
647         }
648 
649         _totalFee = _totalFeePrior;
650     }
651     function _swapETHForCustomToken(uint256 ethAmount, address token, address wallet) private {
652         address[] memory path = new address[](2);
653 		path[0] = uniswapV2Router.WETH();
654 		path[1] = token;
655 		uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : ethAmount}(
656 			0, // accept any amount of ETH
657 			path,
658 			wallet,
659 			block.timestamp
660 		);
661     }
662     function _swapTokensForETH(uint256 tokenAmount) private {
663         address[] memory path = new address[](2);
664         path[0] = address(this);
665         path[1] = uniswapV2Router.WETH();
666         _approve(address(this), address(uniswapV2Router), tokenAmount);
667         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
668             tokenAmount,
669             0, // accept any amount of ETH
670             path,
671             address(this),
672             block.timestamp
673         );
674     }
675     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
676         _approve(address(this), address(uniswapV2Router), tokenAmount);
677         uniswapV2Router.addLiquidityETH{value: ethAmount}(
678             address(this),
679             tokenAmount,
680             0, // slippage is unavoidable
681             0, // slippage is unavoidable
682             liquidityWallet,
683             block.timestamp
684         );
685     }
686 }