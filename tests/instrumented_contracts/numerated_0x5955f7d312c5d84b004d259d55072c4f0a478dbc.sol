1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IFactory {
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 
29     function getPair(address tokenA, address tokenB) external view returns (address pair);
30 }
31 
32 interface IRouter {
33     function factory() external pure returns (address);
34 
35     function WETH() external pure returns (address);
36 
37     function addLiquidityETH(
38         address token,
39         uint256 amountTokenDesired,
40         uint256 amountTokenMin,
41         uint256 amountETHMin,
42         address to,
43         uint256 deadline
44     )
45         external
46         payable
47         returns (
48             uint256 amountToken,
49             uint256 amountETH,
50             uint256 liquidity
51         );
52 
53     function swapExactETHForTokensSupportingFeeOnTransferTokens(
54         uint256 amountOutMin,
55         address[] calldata path,
56         address to,
57         uint256 deadline
58     ) external payable;
59 
60     function swapExactTokensForETHSupportingFeeOnTransferTokens(
61         uint256 amountIn,
62         uint256 amountOutMin,
63         address[] calldata path,
64         address to,
65         uint256 deadline
66     ) external;
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     function name() external view returns (string memory);
71 
72     function symbol() external view returns (string memory);
73 
74     function decimals() external view returns (uint8);
75 }
76 
77 library Address {
78 	function isContract(address account) internal view returns (bool) {
79 		uint256 size;
80 		assembly {
81 			size := extcodesize(account)
82 		}
83 		return size > 0;
84 	}
85 
86 	function sendValue(address payable recipient, uint256 amount) internal {
87 		require(
88 			address(this).balance >= amount,
89 			"Address: insufficient balance"
90 		);
91 
92 		(bool success, ) = recipient.call{value: amount}("");
93 		require(
94 			success,
95 			"Address: unable to send value, recipient may have reverted"
96 		);
97 	}
98 
99 	function functionCall(address target, bytes memory data)
100 	internal
101 	returns (bytes memory)
102 	{
103 		return functionCall(target, data, "Address: low-level call failed");
104 	}
105 
106 	function functionCall(
107 		address target,
108 		bytes memory data,
109 		string memory errorMessage
110 	) internal returns (bytes memory) {
111 		return functionCallWithValue(target, data, 0, errorMessage);
112 	}
113 
114 	function functionCallWithValue(
115 		address target,
116 		bytes memory data,
117 		uint256 value
118 	) internal returns (bytes memory) {
119 		return
120 		functionCallWithValue(
121 			target,
122 			data,
123 			value,
124 			"Address: low-level call with value failed"
125 		);
126 	}
127 
128 	function functionCallWithValue(
129 		address target,
130 		bytes memory data,
131 		uint256 value,
132 		string memory errorMessage
133 	) internal returns (bytes memory) {
134 		require(
135 			address(this).balance >= value,
136 			"Address: insufficient balance for call"
137 		);
138 		require(isContract(target), "Address: call to non-contract");
139 
140 		(bool success, bytes memory returndata) = target.call{value: value}(
141 		data
142 		);
143 		return _verifyCallResult(success, returndata, errorMessage);
144 	}
145 
146 	function functionStaticCall(address target, bytes memory data)
147 	internal
148 	view
149 	returns (bytes memory)
150 	{
151 		return
152 		functionStaticCall(
153 			target,
154 			data,
155 			"Address: low-level static call failed"
156 		);
157 	}
158 
159 	function functionStaticCall(
160 		address target,
161 		bytes memory data,
162 		string memory errorMessage
163 	) internal view returns (bytes memory) {
164 		require(isContract(target), "Address: static call to non-contract");
165 
166 		(bool success, bytes memory returndata) = target.staticcall(data);
167 		return _verifyCallResult(success, returndata, errorMessage);
168 	}
169 
170 	function functionDelegateCall(address target, bytes memory data)
171 	internal
172 	returns (bytes memory)
173 	{
174 		return
175 		functionDelegateCall(
176 			target,
177 			data,
178 			"Address: low-level delegate call failed"
179 		);
180 	}
181 
182 	function functionDelegateCall(
183 		address target,
184 		bytes memory data,
185 		string memory errorMessage
186 	) internal returns (bytes memory) {
187 		require(isContract(target), "Address: delegate call to non-contract");
188 
189 		(bool success, bytes memory returndata) = target.delegatecall(data);
190 		return _verifyCallResult(success, returndata, errorMessage);
191 	}
192 
193 	function _verifyCallResult(
194 		bool success,
195 		bytes memory returndata,
196 		string memory errorMessage
197 	) private pure returns (bytes memory) {
198 		if (success) {
199 			return returndata;
200 		} else {
201 			if (returndata.length > 0) {
202 				assembly {
203 					let returndata_size := mload(returndata)
204 					revert(add(32, returndata), returndata_size)
205 				}
206 			} else {
207 				revert(errorMessage);
208 			}
209 		}
210 	}
211 }
212 
213 abstract contract Context {
214     function _msgSender() internal view virtual returns (address) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view virtual returns (bytes calldata) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 contract Ownable is Context {
225     address private _owner;
226 
227     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229     constructor() {
230         address msgSender = _msgSender();
231         _owner = msgSender;
232         emit OwnershipTransferred(address(0), msgSender);
233     }
234 
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     modifier onlyOwner() {
240         require(_owner == _msgSender(), "Ownable: caller is not the owner");
241         _;
242     }
243 
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279    function decimals() public view virtual override returns (uint8) {
280         return 18;
281     }
282 
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     function balanceOf(address account) public view virtual override returns (uint256) {
288         return _balances[account];
289     }
290 
291     function transfer(address to, uint256 amount) public virtual override returns (bool) {
292         address owner = _msgSender();
293         _transfer(owner, to, amount);
294         return true;
295     }
296 
297     function allowance(address owner, address spender) public view virtual override returns (uint256) {
298         return _allowances[owner][spender];
299     }
300 
301     function approve(address spender, uint256 amount) public virtual override returns (bool) {
302         address owner = _msgSender();
303         _approve(owner, spender, amount);
304         return true;
305     }
306 
307 
308     function transferFrom(
309         address from,
310         address to,
311         uint256 amount
312     ) public virtual override returns (bool) {
313         address spender = _msgSender();
314         _spendAllowance(from, spender, amount);
315         _transfer(from, to, amount);
316         return true;
317     }
318 
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         uint256 currentAllowance = allowance(owner, spender);
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         unchecked {
330             _approve(owner, spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     function _transfer(
337         address from,
338         address to,
339         uint256 amount
340     ) internal virtual {
341         require(from != address(0), "ERC20: transfer from the zero address");
342         require(to != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(from, to, amount);
345 
346         uint256 fromBalance = _balances[from];
347         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
348         unchecked {
349             _balances[from] = fromBalance - amount;
350             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
351             // decrementing then incrementing.
352             _balances[to] += amount;
353         }
354 
355         emit Transfer(from, to, amount);
356 
357         _afterTokenTransfer(from, to, amount);
358     }
359 
360     function _mint(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _beforeTokenTransfer(address(0), account, amount);
364 
365         _totalSupply += amount;
366         unchecked {
367             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
368             _balances[account] += amount;
369         }
370         emit Transfer(address(0), account, amount);
371 
372         _afterTokenTransfer(address(0), account, amount);
373     }
374 
375     function _burn(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: burn from the zero address");
377 
378         _beforeTokenTransfer(account, address(0), amount);
379 
380         uint256 accountBalance = _balances[account];
381         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
382         unchecked {
383             _balances[account] = accountBalance - amount;
384             // Overflow not possible: amount <= accountBalance <= totalSupply.
385             _totalSupply -= amount;
386         }
387 
388         emit Transfer(account, address(0), amount);
389 
390         _afterTokenTransfer(account, address(0), amount);
391     }
392 
393     function _approve(
394         address owner,
395         address spender,
396         uint256 amount
397     ) internal virtual {
398         require(owner != address(0), "ERC20: approve from the zero address");
399         require(spender != address(0), "ERC20: approve to the zero address");
400 
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     function _spendAllowance(
406         address owner,
407         address spender,
408         uint256 amount
409     ) internal virtual {
410         uint256 currentAllowance = allowance(owner, spender);
411         if (currentAllowance != type(uint256).max) {
412             require(currentAllowance >= amount, "ERC20: insufficient allowance");
413             unchecked {
414                 _approve(owner, spender, currentAllowance - amount);
415             }
416         }
417     }
418 
419     function _beforeTokenTransfer(
420         address from,
421         address to,
422         uint256 amount
423     ) internal virtual {}
424 
425     function _afterTokenTransfer(
426         address from,
427         address to,
428         uint256 amount
429     ) internal virtual {}
430 }
431 
432 contract BaltoToken is Ownable, ERC20 {
433     using Address for address;
434 
435     IRouter public uniswapV2Router;
436     address public immutable uniswapV2Pair;
437 
438     string private constant _name = "Balto Token";
439     string private constant _symbol = "BALTO";
440 
441     bool public isTradingEnabled;
442 
443     uint256 public initialSupply = 220000000 * (10**18);
444 
445     // max buy and sell tx is 2.25% of initialSupply
446     uint256 public maxTxAmount = initialSupply * 225 / 10000;
447 
448     // max wallet is 1% of initialSupply
449     uint256 public maxWalletAmount = initialSupply * 100 / 10000;
450 
451     bool private _swapping;
452     uint256 public minimumTokensBeforeSwap = initialSupply * 25 / 100000;
453 
454     address public liquidityWallet;
455     address public operationsWallet;
456     address public buyBackWallet;
457     address public charityWallet;
458     address public otherWallet;
459 
460     struct CustomTaxPeriod {
461         bytes23 periodName;
462         uint8 blocksInPeriod;
463         uint256 timeInPeriod;
464         uint8 liquidityFeeOnBuy;
465         uint8 liquidityFeeOnSell;
466         uint8 operationsFeeOnBuy;
467         uint8 operationsFeeOnSell;
468         uint8 buyBackFeeOnBuy;
469         uint8 buyBackFeeOnSell;
470         uint8 charityFeeOnBuy;
471         uint8 charityFeeOnSell;
472         uint8 otherFeeOnBuy;
473         uint8 otherFeeOnSell;
474     }
475 
476     // Base taxes
477     CustomTaxPeriod private _base = CustomTaxPeriod("base", 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2);
478 
479     bool private _isLaunched;
480     uint256 private _launchStartTimestamp;
481     uint256 private _launchBlockNumber;
482 
483     mapping (address => bool) private _isBlocked;
484     mapping(address => bool) private _isAllowedToTradeWhenDisabled;
485     mapping(address => bool) private _feeOnSelectedWalletTransfers;
486     mapping(address => bool) private _isExcludedFromFee;
487     mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
488     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
489     mapping(address => bool) public automatedMarketMakerPairs;
490 
491     uint8 private _liquidityFee;
492     uint8 private _operationsFee;
493     uint8 private _buyBackFee;
494     uint8 private _charityFee;
495     uint8 private _otherFee;
496     uint8 private _totalFee;
497 
498     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
499     event BlockedAccountChange(address indexed holder, bool indexed status);
500     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
501     event WalletChange(string indexed indentifier,address indexed newWallet,address indexed oldWallet);
502     event FeeChange(string indexed identifier,uint8 liquidityFee,uint8 operationsFee,uint8 buyBackFee,uint8 charityFee,uint8 otherFee);
503     event CustomTaxPeriodChange(uint256 indexed newValue,uint256 indexed oldValue,string indexed taxType,bytes23 period);
504     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
505     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
506     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
507     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
508     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
509     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
510     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
511     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
512     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
513     event ClaimETHOverflow(uint256 amount);
514     event FeesApplied(uint8 liquidityFee,uint8 operationsFee,uint8 buyBackFee,uint8 charityFee,uint8 otherFee,uint8 totalFee);
515 
516     constructor() ERC20(_name, _symbol) {
517         liquidityWallet = owner();
518         operationsWallet = owner();
519         buyBackWallet = owner();
520         otherWallet = owner();
521 
522         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
523         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this),_uniswapV2Router.WETH());
524         uniswapV2Router = _uniswapV2Router;
525         uniswapV2Pair = _uniswapV2Pair;
526         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
527 
528         _isExcludedFromFee[owner()] = true;
529         _isExcludedFromFee[address(this)] = true;
530 
531         _isAllowedToTradeWhenDisabled[owner()] = true;
532         _isAllowedToTradeWhenDisabled[address(this)] = true;
533 
534         _isExcludedFromMaxTransactionLimit[address(this)] = true;
535 
536         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
537         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
538         _isExcludedFromMaxWalletLimit[address(this)] = true;
539         _isExcludedFromMaxWalletLimit[owner()] = true;
540 
541         _mint(owner(), initialSupply);
542     }
543 
544     receive() external payable {}
545 
546     // Setters
547     function activateTrading() external onlyOwner {
548         isTradingEnabled = true;
549         if(_launchBlockNumber == 0) {
550             _launchBlockNumber = block.number;
551             _launchStartTimestamp = block.timestamp;
552             _isLaunched = true;
553         }
554     }
555     function deactivateTrading() external onlyOwner {
556         isTradingEnabled = false;
557     }
558     function _setAutomatedMarketMakerPair(address pair, bool value) private {
559         require(automatedMarketMakerPairs[pair] != value,"Balto: Automated market maker pair is already set to that value");
560         automatedMarketMakerPairs[pair] = value;
561         emit AutomatedMarketMakerPairChange(pair, value);
562     }
563     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
564         _isAllowedToTradeWhenDisabled[account] = allowed;
565         emit AllowedWhenTradingDisabledChange(account, allowed);
566     }
567     function blockAccount(address account) external onlyOwner {
568         require(!_isBlocked[account], "Balto: Account is already blocked");
569         if (_isLaunched) {
570             require((block.timestamp - _launchStartTimestamp) < 172800, "Balto: Time to block accounts has expired");
571         }
572         _isBlocked[account] = true;
573         emit BlockedAccountChange(account, true);
574     }
575     function unblockAccount(address account) external onlyOwner {
576         require(_isBlocked[account], "Balto: Account is not blcoked");
577         _isBlocked[account] = false;
578         emit BlockedAccountChange(account, false);
579     }
580     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
581         require(_feeOnSelectedWalletTransfers[account] != value,"Balto: The selected wallet is already set to the value ");
582         _feeOnSelectedWalletTransfers[account] = value;
583         emit FeeOnSelectedWalletTransfersChange(account, value);
584     }
585     function excludeFromFees(address account, bool excluded) external onlyOwner {
586         require(_isExcludedFromFee[account] != excluded,"Balto: Account is already the value of 'excluded'");
587         _isExcludedFromFee[account] = excluded;
588         emit ExcludeFromFeesChange(account, excluded);
589     }
590     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
591         require(_isExcludedFromMaxTransactionLimit[account] != excluded,"Balto: Account is already the value of 'excluded'");
592         _isExcludedFromMaxTransactionLimit[account] = excluded;
593         emit ExcludeFromMaxTransferChange(account, excluded);
594     }
595     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
596         require(_isExcludedFromMaxWalletLimit[account] != excluded,"Balto: Account is already the value of 'excluded'");
597         _isExcludedFromMaxWalletLimit[account] = excluded;
598         emit ExcludeFromMaxWalletChange(account, excluded);
599     }
600     function setWallets(
601         address newLiquidityWallet,address newOperationsWallet,address newBuyBackWallet,address newCharityWallet,address newOtherWallet
602     ) external onlyOwner {
603         if (liquidityWallet != newLiquidityWallet) {
604             require(newLiquidityWallet != address(0), "Balto: The liquidityWallet cannot be 0");
605             emit WalletChange("liquidityWallet", newLiquidityWallet, liquidityWallet);
606             liquidityWallet = newLiquidityWallet;
607         }
608         if (operationsWallet != newOperationsWallet) {
609             require(newOperationsWallet != address(0), "Balto: The operationsWallet cannot be 0");
610             emit WalletChange("operationsWallet", newOperationsWallet, operationsWallet);
611             operationsWallet = newOperationsWallet;
612         }
613         if (buyBackWallet != newBuyBackWallet) {
614             require(newBuyBackWallet != address(0), "Balto: The buyBackWallet cannot be 0");
615             emit WalletChange("buyBackWallet", newBuyBackWallet, buyBackWallet);
616             buyBackWallet = newBuyBackWallet;
617         }
618         if (charityWallet != newCharityWallet) {
619             require(newCharityWallet != address(0), "Balto: The charityWallet cannot be 0");
620             emit WalletChange("charityWallet", newCharityWallet, charityWallet);
621             charityWallet = newCharityWallet;
622         }
623         if (otherWallet != newOtherWallet) {
624             require(newOtherWallet != address(0), "Balto: The otherWallet cannot be 0");
625             emit WalletChange("otherWallet", newOtherWallet, otherWallet);
626             otherWallet = newOtherWallet;
627         }
628     }
629     // Base fees
630     function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy,uint8 _operationsFeeOnBuy,uint8 _buyBackFeeOnBuy,uint8 _charityFeeOnBuy,uint8 _otherFeeOnBuy) external onlyOwner {
631         _setCustomBuyTaxPeriod(_base,_liquidityFeeOnBuy,_operationsFeeOnBuy,_buyBackFeeOnBuy,_charityFeeOnBuy,_otherFeeOnBuy);
632         emit FeeChange("baseFees-Buy",_liquidityFeeOnBuy,_operationsFeeOnBuy,_buyBackFeeOnBuy,_charityFeeOnBuy,_otherFeeOnBuy);
633     }
634     function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell,uint8 _buyBackFeeOnSell,uint8 _charityFeeOnSell,uint8 _otherFeeOnSell) external onlyOwner {
635         _setCustomSellTaxPeriod(_base,_liquidityFeeOnSell,_operationsFeeOnSell,_buyBackFeeOnSell,_charityFeeOnSell,_otherFeeOnSell);
636         emit FeeChange("baseFees-Sell",_liquidityFeeOnSell,_operationsFeeOnSell,_buyBackFeeOnSell,_charityFeeOnSell,_otherFeeOnSell);
637     }
638     function setUniswapRouter(address newAddress) external onlyOwner {
639         require(newAddress != address(uniswapV2Router),"Balto: The router already has that address");
640         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
641         uniswapV2Router = IRouter(newAddress);
642     }
643     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
644         require(newValue != maxTxAmount, "Balto: Cannot update maxTxAmount to same value");
645         emit MaxTransactionAmountChange(newValue, maxTxAmount);
646         maxTxAmount = newValue;
647     }
648     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
649         require(newValue != maxWalletAmount,"Balto: Cannot update maxWalletAmount to same value");
650         emit MaxWalletAmountChange(newValue, maxWalletAmount);
651         maxWalletAmount = newValue;
652     }
653     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
654         require(newValue != minimumTokensBeforeSwap,"Balto: Cannot update minimumTokensBeforeSwap to same value");
655         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
656         minimumTokensBeforeSwap = newValue;
657     }
658     function claimETHOverflow(uint256 amount) external onlyOwner {
659         require(amount <= address(this).balance, "Balto: Cannot send more than contract balance");
660         (bool success, ) = address(owner()).call{ value: amount }("");
661         if (success) {
662             emit ClaimETHOverflow(amount);
663         }
664     }
665 
666     // Getters
667     function getBaseBuyFees() external view returns (uint8,uint8,uint8,uint8,uint8) {
668         return (_base.liquidityFeeOnBuy,_base.operationsFeeOnBuy,_base.buyBackFeeOnBuy,_base.charityFeeOnBuy,_base.otherFeeOnBuy);
669     }
670     function getBaseSellFees() external view returns (uint8,uint8,uint8,uint8,uint8) {
671         return (_base.liquidityFeeOnSell,_base.operationsFeeOnSell,_base.buyBackFeeOnSell,_base.charityFeeOnSell,_base.otherFeeOnSell);
672     }
673     // Main
674     function _transfer(
675         address from,
676         address to,
677         uint256 amount
678     ) internal override {
679         require(from != address(0), "ERC20: transfer from the zero address");
680         require(to != address(0), "ERC20: transfer to the zero address");
681 
682         if (amount == 0) {
683             super._transfer(from, to, 0);
684             return;
685         }
686 
687         if (!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
688             require(isTradingEnabled, "Balto: Trading is currently disabled.");
689             require(!_isBlocked[to], "Balto: Account is blocked");
690             require(!_isBlocked[from], "Balto: Account is blocked");
691             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
692                 require(amount <= maxTxAmount, "Balto: Buy amount exceeds the maxTxBuyAmount.");
693             }
694             if (!_isExcludedFromMaxWalletLimit[to]) {
695                 require((balanceOf(to) + amount) <= maxWalletAmount, "Balto: Expected wallet amount exceeds the maxWalletAmount.");
696             }
697         }
698 
699         _adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
700         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
701 
702         if (
703             isTradingEnabled &&
704             canSwap &&
705             !_swapping &&
706             _totalFee > 0 &&
707             automatedMarketMakerPairs[to]
708         ) {
709             _swapping = true;
710             _swapAndLiquify();
711             _swapping = false;
712         }
713 
714         bool takeFee = !_swapping && isTradingEnabled;
715 
716         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
717             takeFee = false;
718         }
719         if (takeFee && _totalFee > 0) {
720             uint256 fee = (amount * _totalFee) / 100;
721             amount = amount - fee;
722             super._transfer(from, address(this), fee);
723         }
724         super._transfer(from, to, amount);
725     }
726 
727     function _adjustTaxes(bool isBuyFromLp,bool isSelltoLp,address from,address to) private {
728         _liquidityFee = 0;
729         _operationsFee = 0;
730         _buyBackFee = 0;
731         _charityFee = 0;
732         _otherFee = 0;
733 
734         if (isBuyFromLp) {
735             if (_isLaunched && block.number - _launchBlockNumber <= 5) {
736                 _liquidityFee = 100;
737             } else {
738                 _liquidityFee = _base.liquidityFeeOnBuy;
739                 _operationsFee = _base.operationsFeeOnBuy;
740                 _buyBackFee = _base.buyBackFeeOnBuy;
741                 _charityFee = _base.charityFeeOnBuy;
742                 _otherFee = _base.otherFeeOnBuy;
743             }
744         }
745         if (isSelltoLp) {
746             _liquidityFee = _base.liquidityFeeOnSell;
747             _operationsFee = _base.operationsFeeOnSell;
748             _buyBackFee = _base.buyBackFeeOnSell;
749             _charityFee = _base.charityFeeOnSell;
750             _otherFee = _base.otherFeeOnSell;
751         }
752         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
753             _liquidityFee = _base.liquidityFeeOnBuy;
754             _operationsFee = _base.operationsFeeOnBuy;
755             _buyBackFee = _base.buyBackFeeOnBuy;
756             _charityFee = _base.charityFeeOnBuy;
757             _otherFee = _base.otherFeeOnBuy;
758         }
759         _totalFee = _liquidityFee + _operationsFee + _buyBackFee + _charityFee + _otherFee;
760         emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _charityFee, _otherFee, _totalFee);
761     }
762 
763     function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell,uint8 _buyBackFeeOnSell,uint8 _charityFeeOnSell,uint8 _otherFeeOnSell) private {
764         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
765             emit CustomTaxPeriodChange(_liquidityFeeOnSell,map.liquidityFeeOnSell,"liquidityFeeOnSell",map.periodName);
766             map.liquidityFeeOnSell = _liquidityFeeOnSell;
767         }
768         if (map.operationsFeeOnSell != _operationsFeeOnSell) {
769             emit CustomTaxPeriodChange(_operationsFeeOnSell,map.operationsFeeOnSell,"operationsFeeOnSell",map.periodName);
770             map.operationsFeeOnSell = _operationsFeeOnSell;
771         }
772         if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
773             emit CustomTaxPeriodChange(_buyBackFeeOnSell,map.buyBackFeeOnSell,"buyBackFeeOnSell",map.periodName);
774             map.buyBackFeeOnSell = _buyBackFeeOnSell;
775         }
776         if (map.charityFeeOnSell != _charityFeeOnSell) {
777             emit CustomTaxPeriodChange(_charityFeeOnSell,map.charityFeeOnSell,"charityFeeOnSell",map.periodName);
778             map.charityFeeOnSell = _charityFeeOnSell;
779         }
780         if (map.otherFeeOnSell != _otherFeeOnSell) {
781             emit CustomTaxPeriodChange(_otherFeeOnSell,map.otherFeeOnSell,"otherFeeOnSell",map.periodName);
782             map.otherFeeOnSell = _otherFeeOnSell;
783         }
784     }
785     function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,uint8 _liquidityFeeOnBuy,uint8 _operationsFeeOnBuy,uint8 _buyBackFeeOnBuy,uint8 _charityFeeOnBuy,uint8 _otherFeeOnBuy) private {
786         if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
787             emit CustomTaxPeriodChange(_liquidityFeeOnBuy,map.liquidityFeeOnBuy,"liquidityFeeOnBuy",map.periodName);
788             map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
789         }
790         if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
791             emit CustomTaxPeriodChange(_operationsFeeOnBuy,map.operationsFeeOnBuy,"operationsFeeOnBuy",map.periodName);
792             map.operationsFeeOnBuy = _operationsFeeOnBuy;
793         }
794         if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
795             emit CustomTaxPeriodChange(_buyBackFeeOnBuy,map.buyBackFeeOnBuy,"buyBackFeeOnBuy",map.periodName);
796             map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
797         }
798         if (map.charityFeeOnBuy != _charityFeeOnBuy) {
799             emit CustomTaxPeriodChange(_charityFeeOnBuy,map.charityFeeOnBuy,"charityFeeOnBuy",map.periodName);
800             map.charityFeeOnBuy = _charityFeeOnBuy;
801         }
802         if (map.otherFeeOnBuy != _otherFeeOnBuy) {
803             emit CustomTaxPeriodChange(_otherFeeOnBuy,map.otherFeeOnBuy,"otherFeeOnBuy",map.periodName);
804             map.otherFeeOnBuy = _otherFeeOnBuy;
805         }
806     }
807 
808     function _swapAndLiquify() private {
809         uint256 contractBalance = balanceOf(address(this));
810         uint256 initialETHBalance = address(this).balance;
811 
812         uint256 amountToLiquify = (contractBalance * _liquidityFee) / _totalFee / 2;
813         uint256 amountToSwap = contractBalance - amountToLiquify;
814 
815         _swapTokensForETH(amountToSwap);
816 
817         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
818         uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
819         uint256 amountETHLiquidity = (ETHBalanceAfterSwap * _liquidityFee) / totalETHFee / 2;
820         uint256 amountETHOperations = (ETHBalanceAfterSwap * _operationsFee) / totalETHFee;
821         uint256 amountETHBuyBack = (ETHBalanceAfterSwap * _buyBackFee) / totalETHFee;
822         uint256 amountETHCharity = (ETHBalanceAfterSwap * _charityFee) / totalETHFee;
823         uint256 amountETHOther = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHBuyBack + amountETHOperations + amountETHCharity);
824 
825         Address.sendValue(payable(operationsWallet),amountETHOperations);
826         Address.sendValue(payable(buyBackWallet),amountETHBuyBack);
827         Address.sendValue(payable(charityWallet),amountETHCharity);
828         Address.sendValue(payable(otherWallet),amountETHOther);
829 
830         if (amountToLiquify > 0) {
831             _addLiquidity(amountToLiquify, amountETHLiquidity);
832             emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
833         }
834     }
835 
836     function _swapTokensForETH(uint256 tokenAmount) private {
837         address[] memory path = new address[](2);
838         path[0] = address(this);
839         path[1] = uniswapV2Router.WETH();
840         _approve(address(this), address(uniswapV2Router), tokenAmount);
841         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
842             tokenAmount,
843             1, // accept any amount of ETH
844             path,
845             address(this),
846             block.timestamp
847         );
848     }
849 
850     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
851         _approve(address(this), address(uniswapV2Router), tokenAmount);
852         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
853             address(this),
854             tokenAmount,
855             1, // slippage is unavoidable
856             1, // slippage is unavoidable
857             liquidityWallet,
858             block.timestamp
859         );
860     }
861 }