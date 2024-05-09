1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IFactory {
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32 
33     function getPair(address tokenA, address tokenB) external view returns (address pair);
34 }
35 
36 interface IRouter {
37     function factory() external pure returns (address);
38 
39     function WETH() external pure returns (address);
40 
41     function addLiquidityETH(
42         address token,
43         uint256 amountTokenDesired,
44         uint256 amountTokenMin,
45         uint256 amountETHMin,
46         address to,
47         uint256 deadline
48     )
49         external
50         payable
51         returns (
52             uint256 amountToken,
53             uint256 amountETH,
54             uint256 liquidity
55         );
56 
57     function swapExactETHForTokensSupportingFeeOnTransferTokens(
58         uint256 amountOutMin,
59         address[] calldata path,
60         address to,
61         uint256 deadline
62     ) external payable;
63 
64     function swapExactTokensForETHSupportingFeeOnTransferTokens(
65         uint256 amountIn,
66         uint256 amountOutMin,
67         address[] calldata path,
68         address to,
69         uint256 deadline
70     ) external;
71 }
72 
73 interface IERC20Metadata is IERC20 {
74     function name() external view returns (string memory);
75 
76     function symbol() external view returns (string memory);
77 
78     function decimals() external view returns (uint8);
79 }
80 
81 library Address {
82 	function isContract(address account) internal view returns (bool) {
83 		uint256 size;
84 		assembly {
85 			size := extcodesize(account)
86 		}
87 		return size > 0;
88 	}
89 
90 	function sendValue(address payable recipient, uint256 amount) internal {
91 		require(
92 			address(this).balance >= amount,
93 			"Address: insufficient balance"
94 		);
95 
96 		(bool success, ) = recipient.call{value: amount}("");
97 		require(
98 			success,
99 			"Address: unable to send value, recipient may have reverted"
100 		);
101 	}
102 
103 	function functionCall(address target, bytes memory data)
104 	internal
105 	returns (bytes memory)
106 	{
107 		return functionCall(target, data, "Address: low-level call failed");
108 	}
109 
110 	function functionCall(
111 		address target,
112 		bytes memory data,
113 		string memory errorMessage
114 	) internal returns (bytes memory) {
115 		return functionCallWithValue(target, data, 0, errorMessage);
116 	}
117 
118 	function functionCallWithValue(
119 		address target,
120 		bytes memory data,
121 		uint256 value
122 	) internal returns (bytes memory) {
123 		return
124 		functionCallWithValue(
125 			target,
126 			data,
127 			value,
128 			"Address: low-level call with value failed"
129 		);
130 	}
131 
132 	function functionCallWithValue(
133 		address target,
134 		bytes memory data,
135 		uint256 value,
136 		string memory errorMessage
137 	) internal returns (bytes memory) {
138 		require(
139 			address(this).balance >= value,
140 			"Address: insufficient balance for call"
141 		);
142 		require(isContract(target), "Address: call to non-contract");
143 
144 		(bool success, bytes memory returndata) = target.call{value: value}(
145 		data
146 		);
147 		return _verifyCallResult(success, returndata, errorMessage);
148 	}
149 
150 	function functionStaticCall(address target, bytes memory data)
151 	internal
152 	view
153 	returns (bytes memory)
154 	{
155 		return
156 		functionStaticCall(
157 			target,
158 			data,
159 			"Address: low-level static call failed"
160 		);
161 	}
162 
163 	function functionStaticCall(
164 		address target,
165 		bytes memory data,
166 		string memory errorMessage
167 	) internal view returns (bytes memory) {
168 		require(isContract(target), "Address: static call to non-contract");
169 
170 		(bool success, bytes memory returndata) = target.staticcall(data);
171 		return _verifyCallResult(success, returndata, errorMessage);
172 	}
173 
174 	function functionDelegateCall(address target, bytes memory data)
175 	internal
176 	returns (bytes memory)
177 	{
178 		return
179 		functionDelegateCall(
180 			target,
181 			data,
182 			"Address: low-level delegate call failed"
183 		);
184 	}
185 
186 	function functionDelegateCall(
187 		address target,
188 		bytes memory data,
189 		string memory errorMessage
190 	) internal returns (bytes memory) {
191 		require(isContract(target), "Address: delegate call to non-contract");
192 
193 		(bool success, bytes memory returndata) = target.delegatecall(data);
194 		return _verifyCallResult(success, returndata, errorMessage);
195 	}
196 
197 	function _verifyCallResult(
198 		bool success,
199 		bytes memory returndata,
200 		string memory errorMessage
201 	) private pure returns (bytes memory) {
202 		if (success) {
203 			return returndata;
204 		} else {
205 			if (returndata.length > 0) {
206 				assembly {
207 					let returndata_size := mload(returndata)
208 					revert(add(32, returndata), returndata_size)
209 				}
210 			} else {
211 				revert(errorMessage);
212 			}
213 		}
214 	}
215 }
216 
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
224         return msg.data;
225     }
226 }
227 
228 contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     constructor() {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     function owner() public view returns (address) {
240         return _owner;
241     }
242 
243     modifier onlyOwner() {
244         require(_owner == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     function renounceOwnership() public virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 contract ERC20 is Context, IERC20, IERC20Metadata {
261     mapping(address => uint256) private _balances;
262 
263     mapping(address => mapping(address => uint256)) private _allowances;
264 
265     uint256 private _totalSupply;
266 
267     string private _name;
268     string private _symbol;
269 
270     constructor(string memory name_, string memory symbol_) {
271         _name = name_;
272         _symbol = symbol_;
273     }
274 
275     function name() public view virtual override returns (string memory) {
276         return _name;
277     }
278 
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283    function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286 
287     function totalSupply() public view virtual override returns (uint256) {
288         return _totalSupply;
289     }
290 
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294 
295     function transfer(address to, uint256 amount) public virtual override returns (bool) {
296         address owner = _msgSender();
297         _transfer(owner, to, amount);
298         return true;
299     }
300 
301     function allowance(address owner, address spender) public view virtual override returns (uint256) {
302         return _allowances[owner][spender];
303     }
304 
305     function approve(address spender, uint256 amount) public virtual override returns (bool) {
306         address owner = _msgSender();
307         _approve(owner, spender, amount);
308         return true;
309     }
310 
311 
312     function transferFrom(
313         address from,
314         address to,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         address spender = _msgSender();
318         _spendAllowance(from, spender, amount);
319         _transfer(from, to, amount);
320         return true;
321     }
322 
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         address owner = _msgSender();
325         _approve(owner, spender, allowance(owner, spender) + addedValue);
326         return true;
327     }
328 
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         address owner = _msgSender();
331         uint256 currentAllowance = allowance(owner, spender);
332         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
333         unchecked {
334             _approve(owner, spender, currentAllowance - subtractedValue);
335         }
336 
337         return true;
338     }
339 
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) internal virtual {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347 
348         _beforeTokenTransfer(from, to, amount);
349 
350         uint256 fromBalance = _balances[from];
351         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
352         unchecked {
353             _balances[from] = fromBalance - amount;
354             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
355             // decrementing then incrementing.
356             _balances[to] += amount;
357         }
358 
359         emit Transfer(from, to, amount);
360 
361         _afterTokenTransfer(from, to, amount);
362     }
363 
364     function _mint(address account, uint256 amount) internal virtual {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _beforeTokenTransfer(address(0), account, amount);
368 
369         _totalSupply += amount;
370         unchecked {
371             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
372             _balances[account] += amount;
373         }
374         emit Transfer(address(0), account, amount);
375 
376         _afterTokenTransfer(address(0), account, amount);
377     }
378 
379     function _burn(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _beforeTokenTransfer(account, address(0), amount);
383 
384         uint256 accountBalance = _balances[account];
385         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
386         unchecked {
387             _balances[account] = accountBalance - amount;
388             // Overflow not possible: amount <= accountBalance <= totalSupply.
389             _totalSupply -= amount;
390         }
391 
392         emit Transfer(account, address(0), amount);
393 
394         _afterTokenTransfer(account, address(0), amount);
395     }
396 
397     function _approve(
398         address owner,
399         address spender,
400         uint256 amount
401     ) internal virtual {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = amount;
406         emit Approval(owner, spender, amount);
407     }
408 
409     function _spendAllowance(
410         address owner,
411         address spender,
412         uint256 amount
413     ) internal virtual {
414         uint256 currentAllowance = allowance(owner, spender);
415         if (currentAllowance != type(uint256).max) {
416             require(currentAllowance >= amount, "ERC20: insufficient allowance");
417             unchecked {
418                 _approve(owner, spender, currentAllowance - amount);
419             }
420         }
421     }
422 
423     function _beforeTokenTransfer(
424         address from,
425         address to,
426         uint256 amount
427     ) internal virtual {}
428 
429     function _afterTokenTransfer(
430         address from,
431         address to,
432         uint256 amount
433     ) internal virtual {}
434 }
435 
436 contract deezWalnuts is Ownable, ERC20 {
437     using Address for address;
438 
439     IRouter public uniswapV2Router;
440     address public immutable uniswapV2Pair;
441 
442     string private constant _name = "Walnuts";
443     string private constant _symbol = "$WALNUTS";
444 
445     bool public isTradingEnabled;
446 
447     uint256 public initialSupply = 420000000 * (10**18);
448 
449     // max buy and sell tx is 100% of initialSupply
450     uint256 public maxTxAmount = initialSupply;
451 
452     // max wallet is 1% of initialSupply
453     uint256 public maxWalletAmount = initialSupply * 100 / 10000;
454 
455     bool private _swapping;
456     uint256 public minimumTokensBeforeSwap = initialSupply * 1 / 100000;
457 
458     address public liquidity1Wallet;
459     address public liquidity2Wallet;
460     address public operationsWallet;
461 
462     struct CustomTaxPeriod {
463         bytes23 periodName;
464         uint8 liquidity1FeeOnBuy;
465         uint8 liquidity1FeeOnSell;
466         uint8 liquidity2FeeOnBuy;
467         uint8 liquidity2FeeOnSell;
468         uint8 operationsFeeOnBuy;
469         uint8 operationsFeeOnSell;
470     }
471 
472     // Base taxes
473     CustomTaxPeriod private _base = CustomTaxPeriod("base", 0, 0, 0, 0, 0, 0);
474 
475     bool private _isLaunched;
476     bool public _launchTokensClaimed;
477     uint256 private _launchStartTimestamp;
478     uint256 private _launchBlockNumber;
479     uint256 public launchTokens;
480 
481     mapping (address => bool) private _isBlocked;
482     mapping(address => bool) private _isAllowedToTradeWhenDisabled;
483     mapping(address => bool) private _feeOnSelectedWalletTransfers;
484     mapping(address => bool) private _isExcludedFromFee;
485     mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
486     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
487     mapping(address => bool) public automatedMarketMakerPairs;
488 
489     uint8 private _liquidity1Fee;
490     uint8 private _liquidity2Fee;
491     uint8 private _operationsFee;
492     uint8 private _totalFee;
493 
494     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
495     event BlockedAccountChange(address indexed holder, bool indexed status);
496     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
497     event WalletChange(string indexed indentifier,address indexed newWallet,address indexed oldWallet);
498     event FeeChange(string indexed identifier,uint8 liquidity1Fee,uint8 liquidity2Fee,uint8 operationsFee);
499     event CustomTaxPeriodChange(uint256 indexed newValue,uint256 indexed oldValue,string indexed taxType,bytes23 period);
500     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
501     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
502     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
503     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
504     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
505     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
506     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
507     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
508     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
509     event ClaimOverflow(address token, uint256 amount);
510     event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
511     event FeesApplied(uint8 liquidity1Fee,uint8 liquidity2Fee,uint8 operationsFee,uint8 totalFee);
512 
513     constructor() ERC20(_name, _symbol) {
514         liquidity1Wallet = owner();
515         liquidity2Wallet = owner();
516         operationsWallet = owner();
517 
518         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
519         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this),_uniswapV2Router.WETH());
520         uniswapV2Router = _uniswapV2Router;
521         uniswapV2Pair = _uniswapV2Pair;
522         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
523 
524         _isExcludedFromFee[owner()] = true;
525         _isExcludedFromFee[address(this)] = true;
526 
527         _isAllowedToTradeWhenDisabled[owner()] = true;
528         _isAllowedToTradeWhenDisabled[address(this)] = true;
529 
530         _isExcludedFromMaxTransactionLimit[address(this)] = true;
531 
532         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
533         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
534         _isExcludedFromMaxWalletLimit[address(this)] = true;
535         _isExcludedFromMaxWalletLimit[owner()] = true;
536 
537         _mint(owner(), initialSupply);
538     }
539 
540     receive() external payable {}
541 
542     function activateTrading() external onlyOwner {
543         isTradingEnabled = true;
544         if(_launchBlockNumber == 0) {
545             _launchBlockNumber = block.number;
546             _launchStartTimestamp = block.timestamp;
547             _isLaunched = true;
548         }
549         emit TradingStatusChange(true, false);
550     }
551     function deactivateTrading() external onlyOwner {
552         isTradingEnabled = false;
553         emit TradingStatusChange(false, true);
554     }
555     function _setAutomatedMarketMakerPair(address pair, bool value) private {
556         require(automatedMarketMakerPairs[pair] != value,"Funicular: Automated market maker pair is already set to that value");
557         automatedMarketMakerPairs[pair] = value;
558         emit AutomatedMarketMakerPairChange(pair, value);
559     }
560     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
561         _isAllowedToTradeWhenDisabled[account] = allowed;
562         emit AllowedWhenTradingDisabledChange(account, allowed);
563     }
564     function blockAccount(address account) external onlyOwner {
565         require(!_isBlocked[account], "Funicular: Account is already blocked");
566         if (_isLaunched) {
567             require((block.timestamp - _launchStartTimestamp) < 172800, "Funicular: Time to block accounts has expired");
568         }
569         _isBlocked[account] = true;
570         emit BlockedAccountChange(account, true);
571     }
572     function unblockAccount(address account) external onlyOwner {
573         require(_isBlocked[account], "Funicular: Account is not blcoked");
574         _isBlocked[account] = false;
575         emit BlockedAccountChange(account, false);
576     }
577     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
578         require(_feeOnSelectedWalletTransfers[account] != value,"Funicular: The selected wallet is already set to the value ");
579         _feeOnSelectedWalletTransfers[account] = value;
580         emit FeeOnSelectedWalletTransfersChange(account, value);
581     }
582     function excludeFromFees(address account, bool excluded) external onlyOwner {
583         require(_isExcludedFromFee[account] != excluded,"Funicular: Account is already the value of 'excluded'");
584         _isExcludedFromFee[account] = excluded;
585         emit ExcludeFromFeesChange(account, excluded);
586     }
587     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
588         require(_isExcludedFromMaxTransactionLimit[account] != excluded,"Funicular: Account is already the value of 'excluded'");
589         _isExcludedFromMaxTransactionLimit[account] = excluded;
590         emit ExcludeFromMaxTransferChange(account, excluded);
591     }
592     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
593         require(_isExcludedFromMaxWalletLimit[account] != excluded,"Funicular: Account is already the value of 'excluded'");
594         _isExcludedFromMaxWalletLimit[account] = excluded;
595         emit ExcludeFromMaxWalletChange(account, excluded);
596     }
597     function setWallets(address newLiquidity1Wallet,address newLiquidity2Wallet,address newOperationsWallet) external onlyOwner {
598         if (liquidity1Wallet != newLiquidity1Wallet) {
599             require(newLiquidity1Wallet != address(0), "Funicular: The liquidity1Wallet cannot be 0");
600             emit WalletChange("liquidity1Wallet", newLiquidity1Wallet, liquidity1Wallet);
601             liquidity1Wallet = newLiquidity1Wallet;
602         }
603         if (liquidity2Wallet != newLiquidity2Wallet) {
604             require(newLiquidity2Wallet != address(0), "Funicular: The liquidity2Wallet cannot be 0");
605             emit WalletChange("liquidity2Wallet", newLiquidity2Wallet, liquidity2Wallet);
606             liquidity2Wallet = newLiquidity2Wallet;
607         }
608         if (operationsWallet != newOperationsWallet) {
609             require(newOperationsWallet != address(0), "Funicular: The operationsWallet cannot be 0");
610             emit WalletChange("operationsWallet", newOperationsWallet, operationsWallet);
611             operationsWallet = newOperationsWallet;
612         }
613     }
614     // Base fees
615     function setBaseFeesOnBuy(uint8 _liquidity1FeeOnBuy,uint8 _liquidity2FeeOnBuy,uint8 _operationsFeeOnBuy) external onlyOwner {
616         _setCustomBuyTaxPeriod(_base,_liquidity1FeeOnBuy,_liquidity2FeeOnBuy,_operationsFeeOnBuy);
617         emit FeeChange("baseFees-Buy",_liquidity1FeeOnBuy,_liquidity2FeeOnBuy,_operationsFeeOnBuy);
618     }
619     function setBaseFeesOnSell(uint8 _liquidity1FeeOnSell,uint8 _liquidity2FeeOnSell,uint8 _operationsFeeOnSell) external onlyOwner {
620         _setCustomSellTaxPeriod(_base,_liquidity1FeeOnSell,_liquidity2FeeOnSell,_operationsFeeOnSell);
621         emit FeeChange("baseFees-Sell",_liquidity1FeeOnSell,_liquidity2FeeOnSell,_operationsFeeOnSell);
622     }
623     function setUniswapRouter(address newAddress) external onlyOwner {
624         require(newAddress != address(uniswapV2Router),"Funicular: The router already has that address");
625         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
626         uniswapV2Router = IRouter(newAddress);
627     }
628     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
629         require(newValue != maxTxAmount, "Funicular: Cannot update maxTxAmount to same value");
630         emit MaxTransactionAmountChange(newValue, maxTxAmount);
631         maxTxAmount = newValue;
632     }
633     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
634         require(newValue != maxWalletAmount,"Funicular: Cannot update maxWalletAmount to same value");
635         emit MaxWalletAmountChange(newValue, maxWalletAmount);
636         maxWalletAmount = newValue;
637     }
638     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
639         require(newValue != minimumTokensBeforeSwap,"Funicular: Cannot update minimumTokensBeforeSwap to same value");
640         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
641         minimumTokensBeforeSwap = newValue;
642     }
643     function claimLaunchTokens() external onlyOwner {
644 		require(_launchStartTimestamp > 0, "Funicular: Launch must have occurred");
645 		require(!_launchTokensClaimed, "Funicular: Launch tokens have already been claimed");
646 		require(block.number - _launchBlockNumber > 5, "Funicular: Only claim launch tokens after launch");
647 		uint256 tokenBalance = balanceOf(address(this));
648 		_launchTokensClaimed = true;
649 		require(launchTokens <= tokenBalance, "Funicular: A swap and liquify has already occurred");
650 		uint256 amount = launchTokens;
651 		launchTokens = 0;
652         (bool success) = IERC20(address(this)).transfer(owner(), amount);
653         if (success){
654             emit ClaimOverflow(address(this), amount);
655         }
656     }
657     function claimETHOverflow(uint256 amount) external onlyOwner {
658         require(amount <= address(this).balance, "Funicular: Cannot send more than contract balance");
659         (bool success, ) = address(owner()).call{ value: amount }("");
660         if (success) {
661             emit ClaimOverflow(uniswapV2Router.WETH(), amount);
662         }
663     }
664 
665     // Getters
666     function getBaseBuyFees() external view returns (uint8,uint8,uint8) {
667         return (_base.liquidity1FeeOnBuy,_base.liquidity2FeeOnBuy,_base.operationsFeeOnBuy);
668     }
669     function getBaseSellFees() external view returns (uint8,uint8,uint8) {
670         return (_base.liquidity1FeeOnSell,_base.liquidity2FeeOnSell,_base.operationsFeeOnSell);
671     }
672     // Main
673     function _transfer(
674         address from,
675         address to,
676         uint256 amount
677     ) internal override {
678         require(from != address(0), "ERC20: transfer from the zero address");
679         require(to != address(0), "ERC20: transfer to the zero address");
680 
681         if (amount == 0) {
682             super._transfer(from, to, 0);
683             return;
684         }
685 
686         if (!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
687             require(isTradingEnabled, "Funicular: Trading is currently disabled.");
688             require(!_isBlocked[to], "Funicular: Account is blocked");
689             require(!_isBlocked[from], "Funicular: Account is blocked");
690             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
691                 require(amount <= maxTxAmount, "Funicular: Buy amount exceeds the maxTxBuyAmount.");
692             }
693             if (!_isExcludedFromMaxWalletLimit[to]) {
694                 require((balanceOf(to) + amount) <= maxWalletAmount, "Funicular: Expected wallet amount exceeds the maxWalletAmount.");
695             }
696         }
697 
698         _adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
699         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
700 
701         if (
702             isTradingEnabled &&
703             canSwap &&
704             !_swapping &&
705             _totalFee > 0 &&
706             automatedMarketMakerPairs[to]
707         ) {
708             _swapping = true;
709             _swapAndLiquify();
710             _swapping = false;
711         }
712 
713         bool takeFee = !_swapping && isTradingEnabled;
714 
715         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
716             takeFee = false;
717         }
718         if (takeFee && _totalFee > 0) {
719             uint256 fee = (amount * _totalFee) / 100;
720             amount = amount - fee;
721             if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
722                 launchTokens += fee;
723             }
724             super._transfer(from, address(this), fee);
725         }
726         super._transfer(from, to, amount);
727     }
728 
729     function _adjustTaxes(bool isBuyFromLp,bool isSelltoLp,address from,address to) private {
730         _liquidity1Fee = 0;
731         _liquidity2Fee = 0;
732         _operationsFee = 0;
733 
734         if (isBuyFromLp) {
735             if (_isLaunched && block.timestamp - _launchBlockNumber <= 5) {
736                 _liquidity1Fee = 100;
737             } else {
738                 _liquidity1Fee = _base.liquidity1FeeOnBuy;
739                 _liquidity2Fee = _base.liquidity2FeeOnBuy;
740                 _operationsFee = _base.operationsFeeOnBuy;
741             }
742         }
743         if (isSelltoLp) {
744             _liquidity1Fee = _base.liquidity1FeeOnSell;
745             _liquidity2Fee = _base.liquidity2FeeOnSell;
746             _operationsFee = _base.operationsFeeOnSell;
747         }
748         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
749             _liquidity1Fee = _base.liquidity1FeeOnBuy;
750             _liquidity2Fee = _base.liquidity2FeeOnBuy;
751             _operationsFee = _base.operationsFeeOnBuy;
752         }
753         _totalFee = _liquidity1Fee + _liquidity2Fee + _operationsFee;
754         emit FeesApplied(_liquidity1Fee, _liquidity2Fee, _operationsFee, _totalFee);
755     }
756 
757     function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidity1FeeOnSell,uint8 _liquidity2FeeOnSell,uint8 _operationsFeeOnSell) private {
758         if (map.liquidity1FeeOnSell != _liquidity1FeeOnSell) {
759             emit CustomTaxPeriodChange(_liquidity1FeeOnSell,map.liquidity1FeeOnSell,"liquidity1FeeOnSell",map.periodName);
760             map.liquidity1FeeOnSell = _liquidity1FeeOnSell;
761         }
762         if (map.liquidity2FeeOnSell != _liquidity2FeeOnSell) {
763             emit CustomTaxPeriodChange(_liquidity2FeeOnSell,map.liquidity2FeeOnSell,"liquidity2FeeOnSell",map.periodName);
764             map.liquidity2FeeOnSell = _liquidity2FeeOnSell;
765         }
766         if (map.operationsFeeOnSell != _operationsFeeOnSell) {
767             emit CustomTaxPeriodChange(_operationsFeeOnSell,map.operationsFeeOnSell,"operationsFeeOnSell",map.periodName);
768             map.operationsFeeOnSell = _operationsFeeOnSell;
769         }
770     }
771     function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidity1FeeOnBuy,uint8 _liquidity2FeeOnBuy,uint8 _operationsFeeOnBuy) private {
772         if (map.liquidity1FeeOnBuy != _liquidity1FeeOnBuy) {
773             emit CustomTaxPeriodChange(_liquidity1FeeOnBuy,map.liquidity1FeeOnBuy,"liquidity1FeeOnBuy",map.periodName);
774             map.liquidity1FeeOnBuy = _liquidity1FeeOnBuy;
775         }
776         if (map.liquidity2FeeOnBuy != _liquidity2FeeOnBuy) {
777             emit CustomTaxPeriodChange(_liquidity2FeeOnBuy,map.liquidity2FeeOnBuy,"liquidity2FeeOnBuy",map.periodName);
778             map.liquidity2FeeOnBuy = _liquidity2FeeOnBuy;
779         }
780         if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
781             emit CustomTaxPeriodChange(_operationsFeeOnBuy,map.operationsFeeOnBuy,"operationsFeeOnBuy",map.periodName);
782             map.operationsFeeOnBuy = _operationsFeeOnBuy;
783         }
784     }
785 
786     function _swapAndLiquify() private {
787         uint256 contractBalance = balanceOf(address(this));
788         uint256 initialETHBalance = address(this).balance;
789 
790         uint256 amountToLiquify = (contractBalance * _liquidity1Fee) / _totalFee / 2;
791         uint256 amountToSwap = contractBalance - amountToLiquify;
792 
793         _swapTokensForETH(amountToSwap);
794 
795         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
796         uint256 totalETHFee = _totalFee - (_liquidity1Fee / 2);
797         uint256 amountETHLiquidity1 = (ETHBalanceAfterSwap * _liquidity1Fee) / totalETHFee / 2;
798         uint256 amountETHLiquidity2 = (ETHBalanceAfterSwap * _liquidity2Fee) / totalETHFee;
799         uint256 amountETHOperations = ETHBalanceAfterSwap - (amountETHLiquidity1  + amountETHLiquidity2);
800 
801         Address.sendValue(payable(operationsWallet),amountETHOperations);
802         Address.sendValue(payable(liquidity2Wallet),amountETHLiquidity2);
803 
804         if (amountToLiquify > 0) {
805             _addLiquidity(amountToLiquify, amountETHLiquidity1);
806             emit SwapAndLiquify(amountToSwap, amountETHLiquidity1, amountToLiquify);
807         }
808     }
809 
810     function _swapTokensForETH(uint256 tokenAmount) private {
811         address[] memory path = new address[](2);
812         path[0] = address(this);
813         path[1] = uniswapV2Router.WETH();
814         _approve(address(this), address(uniswapV2Router), tokenAmount);
815         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
816             tokenAmount,
817             1, // accept any amount of ETH
818             path,
819             address(this),
820             block.timestamp
821         );
822     }
823 
824     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
825         _approve(address(this), address(uniswapV2Router), tokenAmount);
826         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
827             address(this),
828             tokenAmount,
829             1, // slippage is unavoidable
830             1, // slippage is unavoidable
831             liquidity1Wallet,
832             block.timestamp
833         );
834     }
835 }