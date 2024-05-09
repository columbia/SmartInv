1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.15;
3 
4 abstract contract Context {
5   function _msgSender() internal view virtual returns (address) {
6     return msg.sender;
7   }
8 
9   function _msgData() internal view virtual returns (bytes calldata) {
10     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11     return msg.data;
12   }
13 }
14 
15 interface IERC20 {
16   /**
17    * @dev Returns the amount of tokens in existence.
18    */
19   function totalSupply() external view returns (uint256);
20 
21   /**
22    * @dev Returns the amount of tokens owned by `account`.
23    */
24   function balanceOf(address account) external view returns (uint256);
25 
26   /**
27    * @dev Moves `amount` tokens from the caller's account to `recipient`.
28    *
29    * Returns a boolean value indicating whether the operation succeeded.
30    *
31    * Emits a {Transfer} event.
32    */
33   function transfer(address recipient, uint256 amount) external returns (bool);
34 
35   /**
36    * @dev Returns the remaining number of tokens that `spender` will be
37    * allowed to spend on behalf of `owner` through {transferFrom}. This is
38    * zero by default.
39    *
40    * This value changes when {approve} or {transferFrom} are called.
41    */
42   function allowance(
43     address owner,
44     address spender
45   ) external view returns (uint256);
46 
47   /**
48    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49    *
50    * Returns a boolean value indicating whether the operation succeeded.
51    *
52    * IMPORTANT: Beware that changing an allowance with this method brings the risk
53    * that someone may use both the old and the new allowance by unfortunate
54    * transaction ordering. One possible solution to mitigate this race
55    * condition is to first reduce the spender's allowance to 0 and set the
56    * desired value afterwards:
57    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58    *
59    * Emits an {Approval} event.
60    */
61   function approve(address spender, uint256 amount) external returns (bool);
62 
63   /**
64    * @dev Moves `amount` tokens from `sender` to `recipient` using the
65    * allowance mechanism. `amount` is then deducted from the caller's
66    * allowance.
67    *
68    * Returns a boolean value indicating whether the operation succeeded.
69    *
70    * Emits a {Transfer} event.
71    */
72   function transferFrom(
73     address sender,
74     address recipient,
75     uint256 amount
76   ) external returns (bool);
77 
78   /**
79    * @dev Emitted when `value` tokens are moved from one account (`from`) to
80    * another (`to`).
81    *
82    * Note that `value` may be zero.
83    */
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 
86   /**
87    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88    * a call to {approve}. `value` is the new allowance.
89    */
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 interface IERC20Metadata is IERC20 {
94   /**
95    * @dev Returns the name of the token.
96    */
97   function name() external view returns (string memory);
98 
99   /**
100    * @dev Returns the symbol of the token.
101    */
102   function symbol() external view returns (string memory);
103 
104   /**
105    * @dev Returns the decimals places of the token.
106    */
107   function decimals() external view returns (uint8);
108 }
109 
110 contract ERC20 is Context, IERC20, IERC20Metadata {
111   mapping(address => uint256) private _balances;
112 
113   mapping(address => mapping(address => uint256)) private _allowances;
114 
115   uint256 private _totalSupply;
116 
117   string private _name;
118   string private _symbol;
119 
120   constructor(string memory name_, string memory symbol_) {
121     _name = name_;
122     _symbol = symbol_;
123   }
124 
125   function name() public view virtual override returns (string memory) {
126     return _name;
127   }
128 
129   function symbol() public view virtual override returns (string memory) {
130     return _symbol;
131   }
132 
133   function decimals() public view virtual override returns (uint8) {
134     return 18;
135   }
136 
137   function totalSupply() public view virtual override returns (uint256) {
138     return _totalSupply;
139   }
140 
141   function balanceOf(
142     address account
143   ) public view virtual override returns (uint256) {
144     return _balances[account];
145   }
146 
147   function transfer(
148     address recipient,
149     uint256 amount
150   ) public virtual override returns (bool) {
151     _transfer(_msgSender(), recipient, amount);
152     return true;
153   }
154 
155   function allowance(
156     address owner,
157     address spender
158   ) public view virtual override returns (uint256) {
159     return _allowances[owner][spender];
160   }
161 
162   function approve(
163     address spender,
164     uint256 amount
165   ) public virtual override returns (bool) {
166     _approve(_msgSender(), spender, amount);
167     return true;
168   }
169 
170   function transferFrom(
171     address sender,
172     address recipient,
173     uint256 amount
174   ) public virtual override returns (bool) {
175     _transfer(sender, recipient, amount);
176 
177     uint256 currentAllowance = _allowances[sender][_msgSender()];
178     require(
179       currentAllowance >= amount,
180       "ERC20: transfer amount exceeds allowance"
181     );
182     unchecked {
183       _approve(sender, _msgSender(), currentAllowance - amount);
184     }
185 
186     return true;
187   }
188 
189   function increaseAllowance(
190     address spender,
191     uint256 addedValue
192   ) public virtual returns (bool) {
193     _approve(
194       _msgSender(),
195       spender,
196       _allowances[_msgSender()][spender] + addedValue
197     );
198     return true;
199   }
200 
201   function decreaseAllowance(
202     address spender,
203     uint256 subtractedValue
204   ) public virtual returns (bool) {
205     uint256 currentAllowance = _allowances[_msgSender()][spender];
206     require(
207       currentAllowance >= subtractedValue,
208       "ERC20: decreased allowance below zero"
209     );
210     unchecked {
211       _approve(_msgSender(), spender, currentAllowance - subtractedValue);
212     }
213 
214     return true;
215   }
216 
217   function _transfer(
218     address sender,
219     address recipient,
220     uint256 amount
221   ) internal virtual {
222     require(sender != address(0), "ERC20: transfer from the zero address");
223     require(recipient != address(0), "ERC20: transfer to the zero address");
224 
225     uint256 senderBalance = _balances[sender];
226     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
227     unchecked {
228       _balances[sender] = senderBalance - amount;
229     }
230     _balances[recipient] += amount;
231 
232     emit Transfer(sender, recipient, amount);
233   }
234 
235   function _createInitialSupply(
236     address account,
237     uint256 amount
238   ) internal virtual {
239     require(account != address(0), "ERC20: mint to the zero address");
240 
241     _totalSupply += amount;
242     _balances[account] += amount;
243     emit Transfer(address(0), account, amount);
244   }
245 
246   function _burn(address account, uint256 amount) internal virtual {
247     require(account != address(0), "ERC20: burn from the zero address");
248     uint256 accountBalance = _balances[account];
249     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
250     unchecked {
251       _balances[account] = accountBalance - amount;
252       // Overflow not possible: amount <= accountBalance <= totalSupply.
253       _totalSupply -= amount;
254     }
255 
256     emit Transfer(account, address(0), amount);
257   }
258 
259   function _approve(
260     address owner,
261     address spender,
262     uint256 amount
263   ) internal virtual {
264     require(owner != address(0), "ERC20: approve from the zero address");
265     require(spender != address(0), "ERC20: approve to the zero address");
266 
267     _allowances[owner][spender] = amount;
268     emit Approval(owner, spender, amount);
269   }
270 }
271 
272 contract Ownable is Context {
273   address private _owner;
274 
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280   constructor() {
281     address msgSender = _msgSender();
282     _owner = msgSender;
283     emit OwnershipTransferred(address(0), msgSender);
284   }
285 
286   function owner() public view returns (address) {
287     return _owner;
288   }
289 
290   modifier onlyOwner() {
291     require(_owner == _msgSender(), "Ownable: caller is not the owner");
292     _;
293   }
294 
295   function renounceOwnership() external virtual onlyOwner {
296     emit OwnershipTransferred(_owner, address(0));
297     _owner = address(0);
298   }
299 
300   function transferOwnership(address newOwner) public virtual onlyOwner {
301     require(newOwner != address(0), "Ownable: new owner is the zero address");
302     emit OwnershipTransferred(_owner, newOwner);
303     _owner = newOwner;
304   }
305 }
306 
307 interface IDexRouter {
308   function factory() external pure returns (address);
309 
310   function WETH() external pure returns (address);
311 
312   function swapExactTokensForETHSupportingFeeOnTransferTokens(
313     uint amountIn,
314     uint amountOutMin,
315     address[] calldata path,
316     address to,
317     uint deadline
318   ) external;
319 
320   function swapExactETHForTokensSupportingFeeOnTransferTokens(
321     uint amountOutMin,
322     address[] calldata path,
323     address to,
324     uint deadline
325   ) external payable;
326 }
327 
328 interface IDexFactory {
329   function createPair(
330     address tokenA,
331     address tokenB
332   ) external returns (address pair);
333 }
334 
335 contract NewMoney is ERC20, Ownable {
336   uint256 public maxBuyAmount;
337   uint256 public maxSellAmount;
338   uint256 public maxWalletAmount;
339 
340   IDexRouter public dexRouter;
341   address public lpPair;
342 
343   bool private swapping;
344   uint256 public swapTokensAtAmount;
345 
346   address taxAddress;
347 
348   bool public limitsInEffect = true;
349   bool private antiBot = false;
350 
351   uint256 private transferCount = 0;
352   // Anti-sandwithc-bot mappings and variables
353   mapping(address => uint256) private _holderLastBuyBlock; // to hold last Buy temporarily
354   mapping(address => uint256) private _transferCountMap;
355   bool public transferDelayEnabled = true;
356 
357   uint256 private buyFee;
358   uint256 private sellFee;
359 
360   /******************/
361 
362   // exlcude from fees and max transaction amount
363   mapping(address => bool) private _isExcludedFromFees;
364   mapping(address => bool) public _isExcludedMaxTransactionAmount;
365 
366   // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
367   // could be subject to a maximum transfer amount
368   mapping(address => bool) public automatedMarketMakerPairs;
369 
370   event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
371 
372   event ExcludeFromFees(address indexed account, bool isExcluded);
373 
374   constructor() ERC20("New Money", "MONEY") {
375     address newOwner = msg.sender; // can leave alone if owner is deployer.
376 
377     IDexRouter _dexRouter = IDexRouter(
378       0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
379     );
380     dexRouter = _dexRouter;
381 
382     // create pair
383     lpPair = IDexFactory(_dexRouter.factory()).createPair(
384       address(this),
385       _dexRouter.WETH()
386     );
387     _excludeFromMaxTransaction(address(lpPair), true);
388     _excludeFromMaxTransaction(address(dexRouter), true);
389     _setAutomatedMarketMakerPair(address(lpPair), true);
390 
391     uint256 totalSupply = 1 * 1e8 * 1e18;
392 
393     maxBuyAmount = (totalSupply * 1) / 100;
394     maxSellAmount = (totalSupply * 1) / 100;
395     maxWalletAmount = (totalSupply * 1) / 100;
396     swapTokensAtAmount = (totalSupply * 1) / 100;
397 
398     buyFee = 30;
399     sellFee = 30;
400 
401     _excludeFromMaxTransaction(newOwner, true);
402     _excludeFromMaxTransaction(address(this), true);
403     _excludeFromMaxTransaction(address(0xdead), true);
404 
405     excludeFromFees(newOwner, true);
406     excludeFromFees(address(this), true);
407     excludeFromFees(address(0xdead), true);
408 
409     taxAddress = address(0x710F313171f0A7d0e7aA191322F153a20DeaC2F9);
410 
411     _createInitialSupply(newOwner, totalSupply);
412     transferOwnership(newOwner);
413   }
414 
415   receive() external payable {}
416 
417   // remove limits after token is stable
418   function removeLimits() external onlyOwner {
419     limitsInEffect = false;
420     buyFee = 1;
421     sellFee = 1;
422   }
423 
424   function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
425     _isExcludedMaxTransactionAmount[updAds] = isExcluded;
426   }
427 
428   function excludeFromMaxTransaction(
429     address updAds,
430     bool isEx
431   ) external onlyOwner {
432     if (!isEx) {
433       require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
434     }
435     _isExcludedMaxTransactionAmount[updAds] = isEx;
436   }
437 
438   function setAutomatedMarketMakerPair(
439     address pair,
440     bool value
441   ) external onlyOwner {
442     require(
443       pair != lpPair,
444       "The pair cannot be removed from automatedMarketMakerPairs"
445     );
446 
447     _setAutomatedMarketMakerPair(pair, value);
448     emit SetAutomatedMarketMakerPair(pair, value);
449   }
450 
451   function _setAutomatedMarketMakerPair(address pair, bool value) private {
452     automatedMarketMakerPairs[pair] = value;
453 
454     _excludeFromMaxTransaction(pair, value);
455 
456     emit SetAutomatedMarketMakerPair(pair, value);
457   }
458 
459   function excludeFromFees(address account, bool excluded) public onlyOwner {
460     _isExcludedFromFees[account] = excluded;
461     emit ExcludeFromFees(account, excluded);
462   }
463 
464   function updateAntiBot(bool flag) public onlyOwner {
465     antiBot = flag;
466   }
467 
468   function _transfer(
469     address from,
470     address to,
471     uint256 amount
472   ) internal override {
473     require(from != address(0), "ERC20: transfer from the zero address");
474     require(to != address(0), "ERC20: transfer to the zero address");
475     require(amount > 0, "amount must be greater than 0");
476 
477     // anti sandwich bot
478     if (antiBot) {
479       if (
480         !automatedMarketMakerPairs[to] &&
481         to != address(this) &&
482         to != address(dexRouter) &&
483         _holderLastBuyBlock[to] != block.number
484       ) {
485         _holderLastBuyBlock[to] = block.number;
486         _transferCountMap[to] = transferCount;
487       }
488       if (_holderLastBuyBlock[from] == block.number) {
489         require(
490           _transferCountMap[from] + 1 == transferCount,
491           "_transfer:: Anti sandwich bot enabled. Please try again later."
492         );
493       }
494     }
495 
496     if (limitsInEffect) {
497       if (
498         from != owner() &&
499         to != owner() &&
500         to != address(0) &&
501         to != address(0xdead) &&
502         !_isExcludedFromFees[from] &&
503         !_isExcludedFromFees[to]
504       ) {
505         //when buy
506         if (
507           automatedMarketMakerPairs[from] &&
508           !_isExcludedMaxTransactionAmount[to]
509         ) {
510           require(
511             amount <= maxBuyAmount,
512             "Buy transfer amount exceeds the max buy."
513           );
514           require(
515             amount + balanceOf(to) <= maxWalletAmount,
516             "Cannot Exceed max wallet"
517           );
518         }
519         //when sell
520         else if (
521           automatedMarketMakerPairs[to] &&
522           !_isExcludedMaxTransactionAmount[from]
523         ) {
524           if (amount > maxSellAmount) {
525             amount = maxSellAmount;
526           }
527         } else if (!_isExcludedMaxTransactionAmount[to]) {
528           require(
529             amount + balanceOf(to) <= maxWalletAmount,
530             "Cannot Exceed max tokens per wallet"
531           );
532         }
533       }
534     }
535 
536     uint256 contractTokenBalance = balanceOf(address(this));
537 
538     bool canSwap = contractTokenBalance >= swapTokensAtAmount;
539 
540     if (
541       canSwap &&
542       !swapping &&
543       !automatedMarketMakerPairs[from] &&
544       !_isExcludedFromFees[from] &&
545       !_isExcludedFromFees[to]
546     ) {
547       swapping = true;
548       swapBack();
549       swapping = false;
550     }
551 
552     // only take fees on buys/sells, do not take on wallet transfers
553     if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
554       uint256 fees = 0;
555       // on sell
556       if (automatedMarketMakerPairs[to] && sellFee > 0) {
557         fees = (amount * sellFee) / 100;
558       }
559       // on buy
560       else if (automatedMarketMakerPairs[from] && buyFee > 0) {
561         fees = (amount * buyFee) / 100;
562       }
563       if (fees > 0) {
564         super._transfer(from, address(this), fees);
565       }
566       amount -= fees;
567     }
568 
569     super._transfer(from, to, amount);
570     transferCount += 1;
571   }
572 
573   function swapTokensForEth(uint256 tokenAmount) private {
574     // generate the uniswap pair path of token -> weth
575     address[] memory path = new address[](2);
576     path[0] = address(this);
577     path[1] = dexRouter.WETH();
578 
579     _approve(address(this), address(dexRouter), tokenAmount);
580 
581     // make the swap
582     dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
583       tokenAmount,
584       0, // accept any amount of ETH
585       path,
586       taxAddress,
587       block.timestamp
588     );
589   }
590 
591   function swapBack() private {
592     uint256 contractBalance = balanceOf(address(this));
593     if (contractBalance == 0) {
594       return;
595     }
596 
597     if (contractBalance > swapTokensAtAmount * 6) {
598       contractBalance = swapTokensAtAmount * 6;
599     }
600 
601     bool success;
602 
603     swapTokensForEth(contractBalance);
604 
605     uint256 ethBalance = address(this).balance;
606 
607     if (ethBalance > 0) {
608       (success, ) = address(taxAddress).call{value: ethBalance}("");
609     }
610   }
611 }