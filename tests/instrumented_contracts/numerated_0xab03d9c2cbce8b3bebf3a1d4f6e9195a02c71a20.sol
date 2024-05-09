1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-28
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.15;
8 
9 abstract contract Context {
10   function _msgSender() internal view virtual returns (address) {
11     return msg.sender;
12   }
13 
14   function _msgData() internal view virtual returns (bytes calldata) {
15     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16     return msg.data;
17   }
18 }
19 
20 interface IERC20 {
21   /**
22    * @dev Returns the amount of tokens in existence.
23    */
24   function totalSupply() external view returns (uint256);
25 
26   /**
27    * @dev Returns the amount of tokens owned by `account`.
28    */
29   function balanceOf(address account) external view returns (uint256);
30 
31   /**
32    * @dev Moves `amount` tokens from the caller's account to `recipient`.
33    *
34    * Returns a boolean value indicating whether the operation succeeded.
35    *
36    * Emits a {Transfer} event.
37    */
38   function transfer(address recipient, uint256 amount) external returns (bool);
39 
40   /**
41    * @dev Returns the remaining number of tokens that `spender` will be
42    * allowed to spend on behalf of `owner` through {transferFrom}. This is
43    * zero by default.
44    *
45    * This value changes when {approve} or {transferFrom} are called.
46    */
47   function allowance(
48     address owner,
49     address spender
50   ) external view returns (uint256);
51 
52   /**
53    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54    *
55    * Returns a boolean value indicating whether the operation succeeded.
56    *
57    * IMPORTANT: Beware that changing an allowance with this method brings the risk
58    * that someone may use both the old and the new allowance by unfortunate
59    * transaction ordering. One possible solution to mitigate this race
60    * condition is to first reduce the spender's allowance to 0 and set the
61    * desired value afterwards:
62    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63    *
64    * Emits an {Approval} event.
65    */
66   function approve(address spender, uint256 amount) external returns (bool);
67 
68   /**
69    * @dev Moves `amount` tokens from `sender` to `recipient` using the
70    * allowance mechanism. `amount` is then deducted from the caller's
71    * allowance.
72    *
73    * Returns a boolean value indicating whether the operation succeeded.
74    *
75    * Emits a {Transfer} event.
76    */
77   function transferFrom(
78     address sender,
79     address recipient,
80     uint256 amount
81   ) external returns (bool);
82 
83   /**
84    * @dev Emitted when `value` tokens are moved from one account (`from`) to
85    * another (`to`).
86    *
87    * Note that `value` may be zero.
88    */
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 
91   /**
92    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93    * a call to {approve}. `value` is the new allowance.
94    */
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 interface IERC20Metadata is IERC20 {
99   /**
100    * @dev Returns the name of the token.
101    */
102   function name() external view returns (string memory);
103 
104   /**
105    * @dev Returns the symbol of the token.
106    */
107   function symbol() external view returns (string memory);
108 
109   /**
110    * @dev Returns the decimals places of the token.
111    */
112   function decimals() external view returns (uint8);
113 }
114 
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116   mapping(address => uint256) private _balances;
117 
118   mapping(address => mapping(address => uint256)) private _allowances;
119 
120   uint256 private _totalSupply;
121 
122   string private _name;
123   string private _symbol;
124 
125   constructor(string memory name_, string memory symbol_) {
126     _name = name_;
127     _symbol = symbol_;
128   }
129 
130   function name() public view virtual override returns (string memory) {
131     return _name;
132   }
133 
134   function symbol() public view virtual override returns (string memory) {
135     return _symbol;
136   }
137 
138   function decimals() public view virtual override returns (uint8) {
139     return 18;
140   }
141 
142   function totalSupply() public view virtual override returns (uint256) {
143     return _totalSupply;
144   }
145 
146   function balanceOf(
147     address account
148   ) public view virtual override returns (uint256) {
149     return _balances[account];
150   }
151 
152   function transfer(
153     address recipient,
154     uint256 amount
155   ) public virtual override returns (bool) {
156     _transfer(_msgSender(), recipient, amount);
157     return true;
158   }
159 
160   function allowance(
161     address owner,
162     address spender
163   ) public view virtual override returns (uint256) {
164     return _allowances[owner][spender];
165   }
166 
167   function approve(
168     address spender,
169     uint256 amount
170   ) public virtual override returns (bool) {
171     _approve(_msgSender(), spender, amount);
172     return true;
173   }
174 
175   function transferFrom(
176     address sender,
177     address recipient,
178     uint256 amount
179   ) public virtual override returns (bool) {
180     _transfer(sender, recipient, amount);
181 
182     uint256 currentAllowance = _allowances[sender][_msgSender()];
183     require(
184       currentAllowance >= amount,
185       "ERC20: transfer amount exceeds allowance"
186     );
187     unchecked {
188       _approve(sender, _msgSender(), currentAllowance - amount);
189     }
190 
191     return true;
192   }
193 
194   function increaseAllowance(
195     address spender,
196     uint256 addedValue
197   ) public virtual returns (bool) {
198     _approve(
199       _msgSender(),
200       spender,
201       _allowances[_msgSender()][spender] + addedValue
202     );
203     return true;
204   }
205 
206   function decreaseAllowance(
207     address spender,
208     uint256 subtractedValue
209   ) public virtual returns (bool) {
210     uint256 currentAllowance = _allowances[_msgSender()][spender];
211     require(
212       currentAllowance >= subtractedValue,
213       "ERC20: decreased allowance below zero"
214     );
215     unchecked {
216       _approve(_msgSender(), spender, currentAllowance - subtractedValue);
217     }
218 
219     return true;
220   }
221 
222   function _transfer(
223     address sender,
224     address recipient,
225     uint256 amount
226   ) internal virtual {
227     require(sender != address(0), "ERC20: transfer from the zero address");
228     require(recipient != address(0), "ERC20: transfer to the zero address");
229 
230     uint256 senderBalance = _balances[sender];
231     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
232     unchecked {
233       _balances[sender] = senderBalance - amount;
234     }
235     _balances[recipient] += amount;
236 
237     emit Transfer(sender, recipient, amount);
238   }
239 
240   function _createInitialSupply(
241     address account,
242     uint256 amount
243   ) internal virtual {
244     require(account != address(0), "ERC20: mint to the zero address");
245 
246     _totalSupply += amount;
247     _balances[account] += amount;
248     emit Transfer(address(0), account, amount);
249   }
250 
251   function _burn(address account, uint256 amount) internal virtual {
252     require(account != address(0), "ERC20: burn from the zero address");
253     uint256 accountBalance = _balances[account];
254     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
255     unchecked {
256       _balances[account] = accountBalance - amount;
257       // Overflow not possible: amount <= accountBalance <= totalSupply.
258       _totalSupply -= amount;
259     }
260 
261     emit Transfer(account, address(0), amount);
262   }
263 
264   function _approve(
265     address owner,
266     address spender,
267     uint256 amount
268   ) internal virtual {
269     require(owner != address(0), "ERC20: approve from the zero address");
270     require(spender != address(0), "ERC20: approve to the zero address");
271 
272     _allowances[owner][spender] = amount;
273     emit Approval(owner, spender, amount);
274   }
275 }
276 
277 contract Ownable is Context {
278   address private _owner;
279 
280   event OwnershipTransferred(
281     address indexed previousOwner,
282     address indexed newOwner
283   );
284 
285   constructor() {
286     address msgSender = _msgSender();
287     _owner = msgSender;
288     emit OwnershipTransferred(address(0), msgSender);
289   }
290 
291   function owner() public view returns (address) {
292     return _owner;
293   }
294 
295   modifier onlyOwner() {
296     require(_owner == _msgSender(), "Ownable: caller is not the owner");
297     _;
298   }
299 
300   function renounceOwnership() external virtual onlyOwner {
301     emit OwnershipTransferred(_owner, address(0));
302     _owner = address(0);
303   }
304 
305   function transferOwnership(address newOwner) public virtual onlyOwner {
306     require(newOwner != address(0), "Ownable: new owner is the zero address");
307     emit OwnershipTransferred(_owner, newOwner);
308     _owner = newOwner;
309   }
310 }
311 
312 interface IDexRouter {
313   function factory() external pure returns (address);
314 
315   function WETH() external pure returns (address);
316 
317   function swapExactTokensForETHSupportingFeeOnTransferTokens(
318     uint amountIn,
319     uint amountOutMin,
320     address[] calldata path,
321     address to,
322     uint deadline
323   ) external;
324 
325   function swapExactETHForTokensSupportingFeeOnTransferTokens(
326     uint amountOutMin,
327     address[] calldata path,
328     address to,
329     uint deadline
330   ) external payable;
331 }
332 
333 interface IDexFactory {
334   function createPair(
335     address tokenA,
336     address tokenB
337   ) external returns (address pair);
338 }
339 
340 contract hiK is ERC20, Ownable {
341   uint256 public maxBuyAmount;
342   uint256 public maxSellAmount;
343   uint256 public maxWalletAmount;
344 
345   IDexRouter public dexRouter;
346   address public lpPair;
347 
348   bool private swapping;
349   uint256 public swapTokensAtAmount;
350 
351   address taxAddress;
352 
353   bool public limitsInEffect = true;
354   bool private antiBot = true;
355 
356   uint256 private transferCount = 0;
357   // Anti-sandwithc-bot mappings and variables
358   mapping(address => uint256) private _holderLastBuyBlock; // to hold last Buy temporarily
359   mapping(address => uint256) private _transferCountMap;
360   bool public transferDelayEnabled = true;
361 
362   uint256 private buyFee;
363   uint256 private sellFee;
364 
365   /******************/
366 
367   // exlcude from fees and max transaction amount
368   mapping(address => bool) private _isExcludedFromFees;
369   mapping(address => bool) public _isExcludedMaxTransactionAmount;
370 
371   // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
372   // could be subject to a maximum transfer amount
373   mapping(address => bool) public automatedMarketMakerPairs;
374 
375   event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
376 
377   event ExcludeFromFees(address indexed account, bool isExcluded);
378 
379   constructor() ERC20("Hi King", "hiK") {
380     address newOwner = msg.sender; // can leave alone if owner is deployer.
381 
382     IDexRouter _dexRouter = IDexRouter(
383       0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
384     );
385     dexRouter = _dexRouter;
386 
387     // create pair
388     lpPair = IDexFactory(_dexRouter.factory()).createPair(
389       address(this),
390       _dexRouter.WETH()
391     );
392     _excludeFromMaxTransaction(address(lpPair), true);
393     _excludeFromMaxTransaction(address(dexRouter), true);
394     _setAutomatedMarketMakerPair(address(lpPair), true);
395 
396     uint256 totalSupply = 12 * 1e8 * 1e18;
397 
398     maxBuyAmount = (totalSupply * 1) / 100;
399     maxSellAmount = (totalSupply * 1) / 100;
400     maxWalletAmount = (totalSupply * 1) / 100;
401     swapTokensAtAmount = (totalSupply * 1) / 100;
402 
403     buyFee = 2;
404     sellFee = 2;
405 
406     _excludeFromMaxTransaction(newOwner, true);
407     _excludeFromMaxTransaction(address(this), true);
408     _excludeFromMaxTransaction(address(0xdead), true);
409 
410     excludeFromFees(newOwner, true);
411     excludeFromFees(address(this), true);
412     excludeFromFees(address(0xdead), true);
413 
414     taxAddress = address(0x9BcD4225A372B41292163693b636f69431a67D0E);
415 
416     _createInitialSupply(newOwner, totalSupply);
417     transferOwnership(newOwner);
418   }
419 
420   receive() external payable {}
421 
422   // remove limits after token is stable
423   function removeLimits() external onlyOwner {
424     limitsInEffect = false;
425     buyFee = 1;
426     sellFee = 1;
427   }
428 
429   function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
430     _isExcludedMaxTransactionAmount[updAds] = isExcluded;
431   }
432 
433   function excludeFromMaxTransaction(
434     address updAds,
435     bool isEx
436   ) external onlyOwner {
437     if (!isEx) {
438       require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
439     }
440     _isExcludedMaxTransactionAmount[updAds] = isEx;
441   }
442 
443   function setAutomatedMarketMakerPair(
444     address pair,
445     bool value
446   ) external onlyOwner {
447     require(
448       pair != lpPair,
449       "The pair cannot be removed from automatedMarketMakerPairs"
450     );
451 
452     _setAutomatedMarketMakerPair(pair, value);
453     emit SetAutomatedMarketMakerPair(pair, value);
454   }
455 
456   function _setAutomatedMarketMakerPair(address pair, bool value) private {
457     automatedMarketMakerPairs[pair] = value;
458 
459     _excludeFromMaxTransaction(pair, value);
460 
461     emit SetAutomatedMarketMakerPair(pair, value);
462   }
463 
464   function excludeFromFees(address account, bool excluded) public onlyOwner {
465     _isExcludedFromFees[account] = excluded;
466     emit ExcludeFromFees(account, excluded);
467   }
468 
469   function updateAntiBot(bool flag) public onlyOwner {
470     antiBot = flag;
471   }
472 
473   function _transfer(
474     address from,
475     address to,
476     uint256 amount
477   ) internal override {
478     require(from != address(0), "ERC20: transfer from the zero address");
479     require(to != address(0), "ERC20: transfer to the zero address");
480     require(amount > 0, "amount must be greater than 0");
481 
482     // anti sandwich bot
483     if (antiBot) {
484       if (
485         !automatedMarketMakerPairs[to] &&
486         to != address(this) &&
487         to != address(dexRouter) &&
488         _holderLastBuyBlock[to] != block.number
489       ) {
490         _holderLastBuyBlock[to] = block.number;
491         _transferCountMap[to] = transferCount;
492       }
493       if (_holderLastBuyBlock[from] == block.number) {
494         require(
495           _transferCountMap[from] + 1 == transferCount,
496           "_transfer:: Anti sandwich bot enabled. Please try again later."
497         );
498       }
499     }
500 
501     if (limitsInEffect) {
502       if (
503         from != owner() &&
504         to != owner() &&
505         to != address(0) &&
506         to != address(0xdead) &&
507         !_isExcludedFromFees[from] &&
508         !_isExcludedFromFees[to]
509       ) {
510         //when buy
511         if (
512           automatedMarketMakerPairs[from] &&
513           !_isExcludedMaxTransactionAmount[to]
514         ) {
515           require(
516             amount <= maxBuyAmount,
517             "Buy transfer amount exceeds the max buy."
518           );
519           require(
520             amount + balanceOf(to) <= maxWalletAmount,
521             "Cannot Exceed max wallet"
522           );
523         }
524         //when sell
525         else if (
526           automatedMarketMakerPairs[to] &&
527           !_isExcludedMaxTransactionAmount[from]
528         ) {
529           if (amount > maxSellAmount) {
530             amount = maxSellAmount;
531           }
532         } else if (!_isExcludedMaxTransactionAmount[to]) {
533           require(
534             amount + balanceOf(to) <= maxWalletAmount,
535             "Cannot Exceed max tokens per wallet"
536           );
537         }
538       }
539     }
540 
541     uint256 contractTokenBalance = balanceOf(address(this));
542 
543     bool canSwap = contractTokenBalance >= swapTokensAtAmount;
544 
545     if (
546       canSwap &&
547       !swapping &&
548       !automatedMarketMakerPairs[from] &&
549       !_isExcludedFromFees[from] &&
550       !_isExcludedFromFees[to]
551     ) {
552       swapping = true;
553       swapBack();
554       swapping = false;
555     }
556 
557     // only take fees on buys/sells, do not take on wallet transfers
558     if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
559       uint256 fees = 0;
560       // on sell
561       if (automatedMarketMakerPairs[to] && sellFee > 0) {
562         fees = (amount * sellFee) / 100;
563       }
564       // on buy
565       else if (automatedMarketMakerPairs[from] && buyFee > 0) {
566         fees = (amount * buyFee) / 100;
567       }
568       if (fees > 0) {
569         super._transfer(from, address(this), fees);
570       }
571       amount -= fees;
572     }
573 
574     super._transfer(from, to, amount);
575     transferCount += 1;
576   }
577 
578   function swapTokensForEth(uint256 tokenAmount) private {
579     // generate the uniswap pair path of token -> weth
580     address[] memory path = new address[](2);
581     path[0] = address(this);
582     path[1] = dexRouter.WETH();
583 
584     _approve(address(this), address(dexRouter), tokenAmount);
585 
586     // make the swap
587     dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
588       tokenAmount,
589       0, // accept any amount of ETH
590       path,
591       taxAddress,
592       block.timestamp
593     );
594   }
595 
596   function swapBack() private {
597     uint256 contractBalance = balanceOf(address(this));
598     if (contractBalance == 0) {
599       return;
600     }
601 
602     if (contractBalance > swapTokensAtAmount * 6) {
603       contractBalance = swapTokensAtAmount * 6;
604     }
605 
606     bool success;
607 
608     swapTokensForEth(contractBalance);
609 
610     uint256 ethBalance = address(this).balance;
611 
612     if (ethBalance > 0) {
613       (success, ) = address(taxAddress).call{value: ethBalance}("");
614     }
615   }
616 }