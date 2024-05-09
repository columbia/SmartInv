1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6 	
7 	function totalSupply() external view returns (uint256);
8 	function balanceOf(address account) external view returns (uint256);
9 	function transfer(address recipient, uint256 amount) external returns (bool);
10 	function allowance(address owner, address spender) external view returns (uint256);
11 	function approve(address spender, uint256 amount) external returns (bool);
12 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 	
14 	event Transfer(address indexed from, address indexed to, uint256 value);
15 	event Approval(address indexed owner, address indexed spender, uint256 value);
16 
17 	event TransferDetails(address indexed from, address indexed to, uint256 total_Amount, uint256 reflected_amount, uint256 total_TransferAmount, uint256 reflected_TransferAmount);
18 }
19 
20 abstract contract Context {
21 	function _msgSender() internal view virtual returns (address) {
22 		return msg.sender;
23 	}
24 
25 	function _msgData() internal view virtual returns (bytes calldata) {
26 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27 		return msg.data;
28 	}
29 }
30 
31 library Address {
32 	
33 	function isContract(address account) internal view returns (bool) {
34 		uint256 size;
35 		assembly { size := extcodesize(account) }
36 		return size > 0;
37 	}
38 
39 	function sendValue(address payable recipient, uint256 amount) internal {
40 		require(address(this).balance >= amount, "Address: insufficient balance");
41 		(bool success, ) = recipient.call{ value: amount }("");
42 		require(success, "Address: unable to send value, recipient may have reverted");
43 	}
44 	
45 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
46 	  return functionCall(target, data, "Address: low-level call failed");
47 	}
48 	
49 	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
50 		return functionCallWithValue(target, data, 0, errorMessage);
51 	}
52 	
53 	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
54 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
55 	}
56 	
57 	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
58 		require(address(this).balance >= value, "Address: insufficient balance for call");
59 		require(isContract(target), "Address: call to non-contract");
60 		(bool success, bytes memory returndata) = target.call{ value: value }(data);
61 		return _verifyCallResult(success, returndata, errorMessage);
62 	}
63 	
64 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
65 		return functionStaticCall(target, data, "Address: low-level static call failed");
66 	}
67 	
68 	function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
69 		require(isContract(target), "Address: static call to non-contract");
70 		(bool success, bytes memory returndata) = target.staticcall(data);
71 		return _verifyCallResult(success, returndata, errorMessage);
72 	}
73 
74 
75 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
76 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
77 	}
78 	
79 	function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
80 		require(isContract(target), "Address: delegate call to non-contract");
81 		(bool success, bytes memory returndata) = target.delegatecall(data);
82 		return _verifyCallResult(success, returndata, errorMessage);
83 	}
84 
85 	function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
86 		if (success) {
87 		    return returndata;
88 		} else {
89 		    if (returndata.length > 0) {
90 		         assembly {
91 		            let returndata_size := mload(returndata)
92 		            revert(add(32, returndata), returndata_size)
93 		        }
94 		    } else {
95 		        revert(errorMessage);
96 		    }
97 		}
98 	}
99 }
100 
101 
102 
103 abstract contract Ownable is Context {
104 	address private _owner;
105 
106 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 	constructor () {
108 		_owner = _msgSender();
109 		emit OwnershipTransferred(address(0), _owner);
110 	}
111 	
112 	function owner() public view virtual returns (address) {
113 		return _owner;
114 	}
115 	
116 	modifier onlyOwner() {
117 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
118 		_;
119 	}
120 
121 	function transferOwnership(address newOwner) public virtual onlyOwner {
122 		require(newOwner != address(0), "Ownable: new owner is the zero address");
123 		emit OwnershipTransferred(_owner, newOwner);
124 		_owner = newOwner;
125 	}
126 }
127 
128 interface IUniswapV2Factory {
129 	function createPair(address tokenA, address tokenB) external returns (address pair);
130 }
131 
132 interface IUniswapV2Router01 {
133 	function factory() external pure returns (address);
134 	function WETH() external pure returns (address);
135 	function addLiquidityETH(
136 		address token,
137 		uint amountTokenDesired,
138 		uint amountTokenMin,
139 		uint amountETHMin,
140 		address to,
141 		uint deadline
142 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 }
144 
145 interface IUniswapV2Router02 is IUniswapV2Router01 {
146 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
147 		uint amountIn,
148 		uint amountOutMin,
149 		address[] calldata path,
150 		address to,
151 		uint deadline
152 	) external;
153 }
154 
155 
156 contract SUPERCATS is Context, IERC20, Ownable {
157 	using Address for address;
158 
159 	mapping (address => uint256) public _balance_reflected;
160 	mapping (address => uint256) public _balance_total;
161 	mapping (address => mapping (address => uint256)) private _allowances;
162 	
163 	mapping (address => bool) public _isExcluded;
164 	
165 	bool public blacklistMode = true;
166 	mapping (address => bool) public isBlacklisted;
167 
168 	bool public tradingOpen = false;
169 	bool public TOBITNA = true;
170 	
171 	uint256 private constant MAX = ~uint256(0);
172 
173 	uint8 public constant decimals = 8;
174 	uint256 public constant totalSupply = 10 * 10**12 * 10**decimals;
175 
176 	uint256 private _supply_reflected   = (MAX - (MAX % totalSupply));
177 
178 	string public constant name = "SUPERCATS";
179 	string public constant symbol = "S-CATS";
180 
181 	uint256 public _fee_treasury_convert_limit = totalSupply / 2000;
182 	uint256 public _fee_marketing_convert_limit = totalSupply / 5000;
183 
184 	uint256 public _fee_treasury_min_bal = 0;
185 	uint256 public _fee_marketing_min_bal = 0;
186 	
187 	uint256 public _fee_reflection = 1;
188 	uint256 private _fee_reflection_old = _fee_reflection;
189 	uint256 public _contractReflectionStored = 0;
190 	
191 	uint256 public _fee_marketing = 3;
192 	uint256 private _fee_marketing_old = _fee_marketing;
193 	address payable public _wallet_marketing;
194 
195 	uint256 public _fee_treasury = 2;
196 	uint256 private _fee_treasury_old = _fee_treasury;
197 	address payable public _wallet_treasury;
198 
199 	uint256 public _fee_liquidity = 1;
200 	uint256 private _fee_liquidity_old = _fee_liquidity;
201 
202 	uint256 public _fee_denominator = 100;
203 
204 	IUniswapV2Router02 public immutable uniswapV2Router;
205 	address public immutable uniswapV2Pair;
206 	bool inSwapAndLiquify;
207 	bool public swapAndLiquifyEnabled = true;
208 
209 	uint256 public _maxWalletToken = totalSupply / 50;
210 	uint256 public _maxTxAmount =  totalSupply / 50;
211 
212 	mapping (address => bool) public isFeeExempt;
213 	mapping (address => bool) public isTxLimitExempt;
214 	mapping (address => bool) public isWalletLimitExempt;
215 	address[] public _excluded;
216 
217 	uint256 public swapThreshold =  ( totalSupply * 2 ) / 1000;
218 
219 	uint256 public sellMultiplier = 100;
220 	uint256 public buyMultiplier = 300;
221 	uint256 public transferMultiplier = 300;
222 
223 	event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
224 	event SwapAndLiquify(
225 		uint256 tokensSwapped,
226 		uint256 ethReceived,
227 		uint256 tokensIntoLiqudity
228 	);
229 
230 	address constant deadAddress = 0x000000000000000000000000000000000000dEaD;
231 	
232 	modifier lockTheSwap {
233 		inSwapAndLiquify = true;
234 		_;
235 		inSwapAndLiquify = false;
236 	}
237 	
238 	constructor () {
239 		_balance_reflected[owner()] = _supply_reflected;
240 
241 		_wallet_marketing = payable(0x3d93d7f603Fef51d0939031469Fc54dA7380831E);
242 		_wallet_treasury = payable(0x59Ba20fe2CD31ADc55be13A72B93bFD0235E2bAf);
243 		
244 		IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
245 		uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
246 		uniswapV2Router = _uniswapV2Router;
247 
248 		isFeeExempt[msg.sender] = true;
249 		isFeeExempt[address(this)] = true;
250 		isFeeExempt[deadAddress] = true;
251 
252 		isTxLimitExempt[msg.sender] = true;
253 		isTxLimitExempt[deadAddress] = true;
254 		isTxLimitExempt[_wallet_marketing] = true;
255 		isTxLimitExempt[_wallet_treasury] = true;
256 
257 		isWalletLimitExempt[msg.sender] = true;
258 		isWalletLimitExempt[address(this)] = true;
259 		isWalletLimitExempt[deadAddress] = true;
260 		isWalletLimitExempt[_wallet_marketing] = true;
261 		isWalletLimitExempt[_wallet_treasury] = true;
262 		
263 		emit Transfer(address(0), owner(), totalSupply);
264 	}
265 
266 	function balanceOf(address account) public view override returns (uint256) {
267 		if (_isExcluded[account]) return _balance_total[account];
268 		return tokenFromReflection(_balance_reflected[account]);
269 	}
270 
271 	function transfer(address recipient, uint256 amount) public override returns (bool) {
272 		_transfer(_msgSender(), recipient, amount);
273 		return true;
274 	}
275 
276 	function allowance(address owner, address spender) public view override returns (uint256) {
277 		return _allowances[owner][spender];
278 	}
279 
280 	function approve(address spender, uint256 amount) public override returns (bool) {
281 		_approve(_msgSender(), spender, amount);
282 		return true;
283 	}
284 
285 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
286 		_transfer(sender, recipient, amount);
287 		require (_allowances[sender][_msgSender()] >= amount,"ERC20: transfer amount exceeds allowance");
288 		_approve(sender, _msgSender(), (_allowances[sender][_msgSender()]-amount));
289 		return true;
290 	}
291 
292 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
293 		_approve(_msgSender(), spender, (_allowances[_msgSender()][spender] + addedValue));
294 		return true;
295 	}
296 
297 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
298 		require (_allowances[_msgSender()][spender] >= subtractedValue,"ERC20: decreased allowance below zero");
299 		_approve(_msgSender(), spender, (_allowances[_msgSender()][spender] - subtractedValue));
300 		return true;
301 	}
302 
303 	function ___tokenInfo () public view returns(
304 		uint256 MaxTxAmount,
305 		uint256 MaxWalletToken,
306 		uint256 TotalSupply,
307 		uint256 Reflected_Supply,
308 		uint256 Reflection_Rate,
309 		bool TradingOpen
310 		) {
311 		return (_maxTxAmount, _maxWalletToken, totalSupply, _supply_reflected, _getRate(), tradingOpen );
312 	}
313 
314 	function ___feesInfo () public view returns(
315 		uint256 SwapThreshold,
316 		uint256 contractTokenBalance,
317 		uint256 Reflection_tokens_stored
318 		) {
319 		return (swapThreshold, balanceOf(address(this)), _contractReflectionStored);
320 	}
321 
322 	function ___wallets () public view returns(
323 		uint256 Reflection_Fees,
324 		uint256 Liquidity_Fee,
325 		uint256 Treasury_Fee,
326 		uint256 Treasury_Fee_Convert_Limit,
327 		uint256 Treasury_Fee_Minimum_Balance,
328 		uint256 Marketing_Fee,
329 		uint256 Marketing_Fee_Convert_Limit,
330 		uint256 Marketing_Fee_Minimum_Balance
331 	) {
332 		return ( _fee_reflection, _fee_liquidity,
333 			_fee_treasury,_fee_treasury_convert_limit,_fee_treasury_min_bal,
334 			_fee_marketing,_fee_marketing_convert_limit, _fee_marketing_min_bal);
335 	}
336 
337 	function changeWallets(address _newMarketing, address _newTreasury) external onlyOwner {
338 		_wallet_marketing = payable(_newMarketing);
339 		_wallet_treasury = payable(_newTreasury);
340 	}
341 
342 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
343 		require(rAmount <= _supply_reflected, "Amount must be less than total reflections");
344 		uint256 currentRate =  _getRate();
345 		return (rAmount / currentRate);
346 	}
347 
348 	function excludeFromReward(address account) external onlyOwner {
349 		require(!_isExcluded[account], "Account is already excluded");
350 		if(_balance_reflected[account] > 0) {
351 			_balance_total[account] = tokenFromReflection(_balance_reflected[account]);
352 		}
353 		_isExcluded[account] = true;
354 		_excluded.push(account);
355 	}
356 
357 	function includeInReward(address account) external onlyOwner {
358 		require(_isExcluded[account], "Account is already included");
359 		for (uint256 i = 0; i < _excluded.length; i++) {
360 			if (_excluded[i] == account) {
361 				_excluded[i] = _excluded[_excluded.length - 1];
362 				_balance_total[account] = 0;
363 				_isExcluded[account] = false;
364 				_excluded.pop();
365 				break;
366 			}
367 		}
368 	}
369 
370 	function tradingStatus(bool _status, bool _ab) external onlyOwner {
371 		tradingOpen = _status;
372 		TOBITNA = _ab;
373 	}
374 
375 	function setMaxTxPercent_base1000(uint256 maxTxPercentBase1000) external onlyOwner {
376 		_maxTxAmount = (totalSupply * maxTxPercentBase1000 ) / 1000;
377 	}
378 
379 	 function setMaxWalletPercent_base1000(uint256 maxWallPercentBase1000) external onlyOwner {
380 		_maxWalletToken = (totalSupply * maxWallPercentBase1000 ) / 1000;
381 	}
382 	
383 	function setSwapSettings(bool _status, uint256 _threshold) external onlyOwner {
384 		swapAndLiquifyEnabled = _status;
385 		swapThreshold = _threshold;
386 	}
387 
388 	function enable_blacklist(bool _status) external onlyOwner {
389 		blacklistMode = _status;
390 	}
391 
392 	function manage_blacklist(address[] calldata addresses, bool status) external onlyOwner {
393 		for (uint256 i; i < addresses.length; ++i) {
394 			isBlacklisted[addresses[i]] = status;
395 		}
396 	}
397 
398 	function manage_excludeFromFee(address[] calldata addresses, bool status) external onlyOwner {
399 		for (uint256 i; i < addresses.length; ++i) {
400 			isFeeExempt[addresses[i]] = status;
401 		}
402 	}
403 
404 	function manage_TxLimitExempt(address[] calldata addresses, bool status) external onlyOwner {
405 		require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
406 		for (uint256 i=0; i < addresses.length; ++i) {
407 			isTxLimitExempt[addresses[i]] = status;
408 		}
409 	}
410 
411 	function manage_WalletLimitExempt(address[] calldata addresses, bool status) external onlyOwner {
412 		require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
413 		for (uint256 i=0; i < addresses.length; ++i) {
414 			isWalletLimitExempt[addresses[i]] = status;
415 		}
416 	}
417 	
418 
419 /* Airdrop Begins */
420 	
421 	function multitransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
422 
423 		uint256 sccc = 0;
424 		uint256 reflectRate = _getRate();
425 		require(addresses.length == tokens.length,"Mismatch between Address and token count");
426 
427 
428 		for(uint i=0; i < addresses.length; i++){
429 			sccc = sccc + tokens[i];
430 		}
431 		require(balanceOf(msg.sender) >= sccc, "Not enough tokens to airdrop");
432 
433 		_balance_reflected[from] = _balance_reflected[from] - sccc * reflectRate ;
434 
435 		if (_isExcluded[from]){
436 			_balance_total[from] = _balance_total[from] - sccc;
437 		}
438 
439 		for(uint i=0; i < addresses.length; i++) {
440 		
441 		if (_isExcluded[addresses[i]]){
442 			_balance_total[addresses[i]] = _balance_total[addresses[i]] + tokens[i]; 
443 		}
444 		_balance_reflected[addresses[i]] = _balance_reflected[addresses[i]] + tokens[i] * reflectRate;
445 
446 		emit Transfer(from,addresses[i],tokens[i]);
447 	}
448 
449 }
450 
451 	function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
452 		uint256 amountToClear = amountPercentage * address(this).balance / 100;
453 		payable(msg.sender).transfer(amountToClear);
454 	}
455 
456 	function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
457 
458 		if(tokens == 0){
459 			tokens = IERC20(tokenAddress).balanceOf(address(this));
460 		}
461 		return IERC20(tokenAddress).transfer(msg.sender, tokens);
462 	}
463 
464 	//core
465 	function _getRate() private view returns(uint256) {
466 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
467 		return rSupply / tSupply;
468 	}
469 
470 	function _getCurrentSupply() private view returns(uint256, uint256) {
471 		uint256 rSupply = _supply_reflected;
472 		uint256 tSupply = totalSupply;
473 		for (uint256 i = 0; i < _excluded.length; i++) {
474 			if (_balance_reflected[_excluded[i]] > rSupply || _balance_total[_excluded[i]] > tSupply) return (_supply_reflected, totalSupply);
475 			rSupply = rSupply - _balance_reflected[_excluded[i]];
476 			tSupply = tSupply - _balance_total[_excluded[i]];
477 		}
478 		if (rSupply < (_supply_reflected/totalSupply)) return (_supply_reflected, totalSupply);
479 		return (rSupply, tSupply);
480 	}
481 
482 
483 	function _getValues(uint256 tAmount, address recipient, address sender) private view returns (
484 		uint256 rAmount, uint256 rTransferAmount, uint256 rReflection,
485 		uint256 tTransferAmount, uint256 tMarketing, uint256 tLiquidity, uint256 tTreasury, uint256 tReflection) {
486 
487 		uint256 multiplier = transferMultiplier;
488 
489 		if(recipient == uniswapV2Pair) {
490 			multiplier = sellMultiplier;
491 		} else if(sender == uniswapV2Pair) {
492 			multiplier = buyMultiplier;
493 		}
494 
495 		tMarketing = ( tAmount * _fee_marketing ) * multiplier / (_fee_denominator * 100);
496 		tLiquidity = ( tAmount * _fee_liquidity ) * multiplier / (_fee_denominator * 100);
497 		tTreasury = ( tAmount * _fee_treasury  ) * multiplier / (_fee_denominator * 100);
498 		tReflection = ( tAmount * _fee_reflection ) * multiplier  / (_fee_denominator * 100);
499 
500 		tTransferAmount = tAmount - ( tMarketing + tLiquidity + tTreasury + tReflection);
501 		rReflection = tReflection * _getRate();
502 		rAmount = tAmount * _getRate();
503 		rTransferAmount = tTransferAmount * _getRate();
504 	}
505 
506 
507 	function _fees_to_eth_process( address payable wallet, uint256 tokensToConvert) private lockTheSwap {
508 
509 		uint256 rTokensToConvert = tokensToConvert * _getRate();
510 		_balance_reflected[wallet] = _balance_reflected[wallet] - rTokensToConvert;
511 		
512 		if (_isExcluded[wallet]){
513 			_balance_total[wallet] = _balance_total[wallet] - tokensToConvert;
514 		}
515 
516 		_balance_reflected[address(this)] = _balance_reflected[address(this)] + rTokensToConvert;
517 
518 		emit Transfer(wallet, address(this), tokensToConvert);
519 
520 		swapTokensForEthAndSend(tokensToConvert,wallet);
521 
522 	}
523 
524 	function _fees_to_eth(uint256 tokensToConvert, address payable feeWallet, uint256 minBalanceToKeep) private {
525 
526 		if(tokensToConvert == 0){
527 			return;
528 		}
529 
530 		if(tokensToConvert > _maxTxAmount){
531 			tokensToConvert = _maxTxAmount;
532 		}
533 
534 		if((tokensToConvert+minBalanceToKeep)  <= balanceOf(feeWallet)){
535 			_fees_to_eth_process(feeWallet,tokensToConvert);
536 		}
537 	}
538 
539 	function _takeFee(uint256 feeAmount, address receiverWallet) private {
540 		uint256 reflectedReeAmount = feeAmount * _getRate();
541 		_balance_reflected[receiverWallet] = _balance_reflected[receiverWallet] + reflectedReeAmount;
542 
543 		if(_isExcluded[receiverWallet]){
544 			_balance_total[receiverWallet] = _balance_total[receiverWallet] + feeAmount;
545 		}
546 		if(feeAmount > 0){
547 			emit Transfer(msg.sender, receiverWallet, feeAmount);
548 		}
549 	}
550 
551 	function _setAllFees(uint256 marketingFee, uint256 liquidityFees, uint256 treasuryFee, uint256 reflectionFees) private {
552 		_fee_marketing = marketingFee;
553 		_fee_liquidity = liquidityFees;
554 		_fee_treasury = treasuryFee;
555 		_fee_reflection = reflectionFees;
556 	}
557 
558 	function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
559 		sellMultiplier = _sell;
560 		buyMultiplier = _buy;
561 		transferMultiplier = _trans;
562 	}
563 
564 	function set_All_Fees_Triggers(uint256 marketing_fee_convert_limit, uint256 treasury_fee_convert_limit) external onlyOwner {
565 		_fee_marketing_convert_limit = marketing_fee_convert_limit;
566 		_fee_treasury_convert_limit = treasury_fee_convert_limit;
567 	}
568 
569 	function set_All_Fees_Minimum_Balance(uint256 marketing_fee_minimum_balance, uint256 treasury_fee_minimum_balance) external onlyOwner {
570 		_fee_treasury_min_bal = treasury_fee_minimum_balance;
571 		_fee_marketing_min_bal = marketing_fee_minimum_balance;
572 	}
573 
574 	function set_All_Fees(uint256 Treasury_Fee, uint256 Liquidity_Fees, uint256 Reflection_Fees, uint256 Marketing_Fee) external onlyOwner {
575 		uint256 total_fees =  Marketing_Fee + Liquidity_Fees +  Treasury_Fee + Reflection_Fees;
576 		require(total_fees < 31, "Max fee allowed is 30%");
577 		_setAllFees( Marketing_Fee, Liquidity_Fees, Treasury_Fee, Reflection_Fees);
578 	}
579 
580 	function removeAllFee() private {
581 		_fee_marketing_old = _fee_marketing;
582 		_fee_liquidity_old = _fee_liquidity;
583 		_fee_treasury_old = _fee_treasury;
584 		_fee_reflection_old = _fee_reflection;
585 
586 		_setAllFees(0,0,0,0);
587 	}
588 	
589 	function restoreAllFee() private {
590 		_setAllFees(_fee_marketing_old, _fee_liquidity_old, _fee_treasury_old, _fee_reflection_old);
591 	}
592 
593 
594 	function swapAndLiquify(uint256 tokensToSwap) private lockTheSwap {
595 		
596 		uint256 tokensHalf = tokensToSwap / 2;
597 		uint256 contractETHBalance = address(this).balance;
598 
599 		swapTokensForEth(tokensHalf);
600 		uint256 ethSwapped = address(this).balance - contractETHBalance;
601 		addLiquidity(tokensHalf,ethSwapped);
602 
603 		emit SwapAndLiquify(tokensToSwap, tokensHalf, ethSwapped);
604 
605 	}
606 
607 	function swapTokensForEth(uint256 tokenAmount) private {
608 		address[] memory path = new address[](2);
609 		path[0] = address(this);
610 		path[1] = uniswapV2Router.WETH();
611 		_approve(address(this), address(uniswapV2Router), tokenAmount);
612 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
613 			tokenAmount,
614 			0,
615 			path,
616 			address(this),
617 			block.timestamp
618 		);
619 	}
620 
621 	function swapTokensForEthAndSend(uint256 tokenAmount, address payable receiverWallet) private {
622 		address[] memory path = new address[](2);
623 		path[0] = address(this);
624 		path[1] = uniswapV2Router.WETH();
625 		_approve(address(this), address(uniswapV2Router), tokenAmount);
626 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
627 			tokenAmount,
628 			0,
629 			path,
630 			receiverWallet,
631 			block.timestamp
632 		);
633 	}
634 
635 	function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
636 		_approve(address(this), address(uniswapV2Router), tokenAmount);
637 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
638 			address(this),
639 			tokenAmount,
640 			0,
641 			0,
642 			owner(),
643 			block.timestamp
644 		);
645 	}
646 
647 
648 	function _approve(address owner, address spender, uint256 amount) private {
649 		require(owner != address(0), "ERC20: approve from the zero address");
650 		require(spender != address(0), "ERC20: approve to the zero address");
651 
652 		_allowances[owner][spender] = amount;
653 		emit Approval(owner, spender, amount);
654 	}
655 
656 	function _transfer(address from, address to, uint256 amount) private {
657 
658 		if(from != owner() && to != owner()){
659 			require(tradingOpen,"Trading not open yet");
660 
661 			if(TOBITNA && from == uniswapV2Pair){
662 				isBlacklisted[to] = true;
663 			}
664 		}
665 
666 		if(blacklistMode && !TOBITNA){
667 			require(!isBlacklisted[from],"Blacklisted");
668 		}
669 		
670 		require((amount <= _maxTxAmount) || isTxLimitExempt[from] || isTxLimitExempt[to], "Max TX Limit Exceeded");
671 
672 		if (!isWalletLimitExempt[from] && !isWalletLimitExempt[to] && to != uniswapV2Pair) {
673 		    require((balanceOf(to) + amount) <= _maxWalletToken,"max wallet limit reached");
674 		}
675 
676 
677 		// extra bracket to supress stack too deep error
678 		{
679 		    uint256 contractTokenBalance = balanceOf(address(this));
680 		
681 		    if(contractTokenBalance >= _maxTxAmount) {
682 		        contractTokenBalance = _maxTxAmount - 1;
683 		    }
684 		
685 		    bool overMinTokenBalance = contractTokenBalance >= swapThreshold;
686 		    if (overMinTokenBalance &&
687 		        !inSwapAndLiquify &&
688 		        from != uniswapV2Pair &&
689 		        swapAndLiquifyEnabled
690 		    ) {
691 		        contractTokenBalance = swapThreshold;
692 		        swapAndLiquify(contractTokenBalance);
693 		    }
694 
695 		    // Convert fees to eth
696 		    if(!inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled){
697 		        _fees_to_eth(_fee_treasury_convert_limit,_wallet_treasury, _fee_treasury_min_bal);
698 		        _fees_to_eth(_fee_marketing_convert_limit,_wallet_marketing, _fee_marketing_min_bal);
699 		    }
700 		
701 		}
702 		
703 		bool takeFee = true;
704 		if(isFeeExempt[from] || isFeeExempt[to]){
705 		    takeFee = false;
706 		    removeAllFee();
707 		}
708 		
709 		(uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 tTransferAmount, uint256 tMarketing, uint256 tLiquidity, uint256 tTreasury,  uint256 tReflection) = _getValues(amount, to, from);
710 
711 		_transferStandard(from, to, amount, rAmount, tTransferAmount, rTransferAmount);
712 
713 		_supply_reflected = _supply_reflected - rReflection;
714 		_contractReflectionStored = _contractReflectionStored + tReflection;
715 
716 		if(!takeFee){
717 		    restoreAllFee();
718 		} else{
719 		    _takeFee(tMarketing,_wallet_marketing);
720 		    _takeFee(tLiquidity,address(this));
721 		    _takeFee(tTreasury,_wallet_treasury);
722 		}
723 
724 	}
725 
726 	function _transferStandard(address from, address to, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
727 		_balance_reflected[from]    = _balance_reflected[from]  - rAmount;
728 
729 		if (_isExcluded[from]){
730 		    _balance_total[from]    = _balance_total[from]      - tAmount;
731 		}
732 
733 		if (_isExcluded[to]){
734 		    _balance_total[to]      = _balance_total[to]        + tTransferAmount;
735 		}
736 		_balance_reflected[to]      = _balance_reflected[to]    + rTransferAmount;
737 
738 		if(tTransferAmount > 0){
739 			emit Transfer(from, to, tTransferAmount);	
740 		}
741 	}
742 
743 	receive() external payable {}
744 }