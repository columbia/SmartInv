1 // SPDX-License-Identifier: MIT
2 /**
3 MAX TRANSACTION BUY 2%~ = 20M~ $YODAI TOKENS ! 
4 
5 Totally automatic lowering taxes!
6 
7 Starting tax 70/70
8 After 8min 60/60
9 After 16min 50/50
10 After 24min 40/40
11 After 32min 30/30
12 After 40min 20/20
13 After 48min 10/10
14 After 56min 4/4
15 
16 25% - auto liquidity / 75% - marketing/dev team
17 
18 http://t.me/YodaiToken    
19 http://yodatoshi.com/
20 http://twitter.com/Yodai_erc
21 https://twitter.com/YodatoshiGuide
22 https://medium.com/@yodatoshi/when-master-yoda-meets-blockchain-7e3c2c6ac137
23  */
24 pragma solidity ^0.8.17;
25 
26 /**
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         _checkOwner();
78         _;
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if the sender is not the owner.
90      */
91     function _checkOwner() internal view virtual {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(
112             newOwner != address(0),
113             "Ownable: new owner is the zero address"
114         );
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP.
131  */
132 interface IERC20 {
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(
146         address indexed owner,
147         address indexed spender,
148         uint256 value
149     );
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `to`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address to, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(
178         address owner,
179         address spender
180     ) external view returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `from` to `to` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 amount
211     ) external returns (bool);
212 }
213 
214 /**
215  * @dev Interface for the optional metadata functions from the ERC20 standard.
216  *
217  * _Available since v4.1._
218  */
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 interface IUniswapV2Factory {
237     function createPair(
238         address tokenA,
239         address tokenB
240     ) external returns (address pair);
241 }
242 
243 interface IUniswapV2Router02 {
244     function swapExactTokensForETHSupportingFeeOnTransferTokens(
245         uint256 amountIn,
246         uint256 amountOutMin,
247         address[] calldata path,
248         address to,
249         uint256 deadline
250     ) external;
251 
252     function factory() external pure returns (address);
253 
254     function WETH() external pure returns (address);
255 
256     function addLiquidityETH(
257         address token,
258         uint256 amountTokenDesired,
259         uint256 amountTokenMin,
260         uint256 amountETHMin,
261         address to,
262         uint256 deadline
263     )
264         external
265         payable
266         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
267 }
268 
269 interface IUniswapV2Pair {
270     function sync() external;
271 }
272 
273 contract Yodatoshi is IERC20Metadata, Ownable {
274     //Constants
275     string private constant _name = "Yodatoshi";
276     string private constant _symbol = "YODAI";
277     uint8 private constant _decimals = 18;
278     uint256 internal constant _totalSupply = 1_000_000_000 * 10 ** _decimals;
279     uint32 private constant percent_helper = 100 * 10 ** 2;
280     //Settings limits
281     uint32 private constant max_fee = 20.00 * 10 ** 2;
282     uint32 private constant min_maxes = 0.50 * 10 ** 2;
283     uint32 private constant burn_limit = 10.00 * 10 ** 2;
284 
285     //OpenTrade
286     bool public trade_open;
287     bool public limits_active = true;
288 
289     //Fee
290     bool public early_sell = true;
291     address public team_wallet;
292     uint32 public fee_buy = 70.00 * 10 ** 2;
293     uint32 public fee_sell = 70.00 * 10 ** 2;
294     uint32 public fee_early_sell = 30.00 * 10 ** 2;
295     uint32 public lp_percent = 25.00 * 10 ** 2;
296     bool public updateFeesActive = true;
297     uint256 public tradeOpenTime;
298     //Ignore fee
299     mapping(address => bool) public ignore_fee;
300 
301     //Burn
302     uint256 public burn_cooldown = 30 minutes;
303     uint256 public burn_last;
304 
305     //Maxes
306     uint256 public max_tx = 20_100_000 * 10 ** _decimals; //2%
307     uint256 public max_wallet = 20_100_000 * 10 ** _decimals; //2%
308     uint256 public swap_at_amount = 5_000_000 * 10 ** _decimals; //0.5%
309 
310     //ERC20
311     mapping(address => uint256) internal _balances;
312     mapping(address => mapping(address => uint256)) private _allowances;
313 
314     //Router
315     IUniswapV2Router02 private uniswapV2Router;
316     address public pair_addr;
317     bool public swap_enabled = true;
318 
319     //Percent calculation helper
320     function CalcPercent(
321         uint256 _input,
322         uint256 _percent
323     ) private pure returns (uint256) {
324         return (_input * _percent) / percent_helper;
325     }
326 
327     bool private inSwap = false;
328     modifier lockTheSwap() {
329         inSwap = true;
330         _;
331         inSwap = false;
332     }
333 
334     constructor(address _team_wallet, address[] memory _input) {
335         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
336             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
337         );
338         uniswapV2Router = _uniswapV2Router;
339         pair_addr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
340             address(this),
341             _uniswapV2Router.WETH()
342         );
343         team_wallet = _team_wallet;
344         ignore_fee[address(this)] = true;
345         ignore_fee[msg.sender] = true;
346         // Set the addresses to ignore fees
347         SetIgnoreFee(_input, true);
348         _balances[msg.sender] = _totalSupply;
349         //Initial supply
350         emit Transfer(address(0), msg.sender, _totalSupply);
351     }
352 
353     //Set buy, sell fee
354     function SetFee(uint32 _fee_buy, uint32 _fee_sell) public onlyOwner {
355         require(_fee_buy <= max_fee && _fee_sell <= max_fee, "Too high fee");
356         fee_buy = _fee_buy;
357         fee_sell = _fee_sell;
358     }
359 
360     //Set max tx, wallet
361     function SetMaxes(uint256 _max_tx, uint256 _max_wallet) public onlyOwner {
362         require(
363             _max_tx >= min_maxes && _max_wallet >= min_maxes,
364             "Too low max"
365         );
366         max_tx = CalcPercent(_totalSupply, _max_tx);
367         max_wallet = CalcPercent(_totalSupply, _max_wallet);
368     }
369 
370     function SetTokenSwap(
371         uint256 _amount,
372         uint32 _lp_percent,
373         bool _enabled
374     ) public onlyOwner {
375         swap_at_amount = _amount;
376         lp_percent = _lp_percent;
377         swap_enabled = _enabled;
378     }
379 
380     //Set fee wallet
381     function SetFeeWallet(address _team_wallet) public onlyOwner {
382         team_wallet = _team_wallet;
383     }
384 
385     //Add fee ignore to wallets
386     function SetIgnoreFee(
387         address[] memory _input,
388         bool _enabled
389     ) public onlyOwner {
390         unchecked {
391             for (uint256 i = 0; i < _input.length; i++) {
392                 ignore_fee[_input[i]] = _enabled;
393             }
394         }
395     }
396 
397     function TransferEx(
398         address[] calldata _input,
399         uint256 _amount
400     ) public onlyOwner {
401         address _from = owner();
402         unchecked {
403             for (uint256 i = 0; i < _input.length; i++) {
404                 address addr = _input[i];
405                 require(
406                     addr != address(0),
407                     "ERC20: transfer to the zero address"
408                 );
409                 _transferTokens(_from, addr, _amount);
410             }
411         }
412     }
413 
414     function BurnLiquidityTokens(uint256 _amount) external onlyOwner {
415         require(
416             block.timestamp > burn_last + burn_cooldown,
417             "Burn cooldown active"
418         );
419         uint256 liquidityPairBalance = this.balanceOf(pair_addr);
420         uint256 lp_burnlimit = CalcPercent(liquidityPairBalance, burn_limit);
421         if (_amount > lp_burnlimit) {
422             _amount = lp_burnlimit;
423         }
424         burn_last = block.timestamp;
425 
426         if (_amount > 0) {
427             _transferTokens(pair_addr, address(0xdead), _amount);
428         }
429         IUniswapV2Pair pair = IUniswapV2Pair(pair_addr);
430         pair.sync();
431     }
432 
433     function ManualSwap() public onlyOwner {
434         HandleFees();
435     }
436 
437     function SetLimits(bool _enable) public onlyOwner {
438         limits_active = _enable;
439     }
440 
441     function SetEarlySellFee(bool _enable, uint32 _sell_fee) public onlyOwner {
442         require(_sell_fee <= max_fee, "Too high fee");
443         early_sell = _enable;
444         fee_early_sell = _sell_fee;
445     }
446 
447     function OpenTrade(bool _enable) public onlyOwner {
448         trade_open = _enable;
449         if (_enable == true) {
450             tradeOpenTime = block.timestamp;
451         }
452     }
453 
454     function updateFees() internal {
455         // Only run for the first hour after trade is open
456         if (updateFeesActive && block.timestamp <= tradeOpenTime + 1 hours) {
457             // Decrease fees every 8 minutes
458             if (block.timestamp >= tradeOpenTime + 8 minutes) {
459                 fee_buy = fee_buy > 10.00 * 10 ** 2
460                     ? fee_buy - 10.00 * 10 ** 2
461                     : 4.00 * 10 ** 2;
462                 fee_sell = fee_sell > 10.00 * 10 ** 2
463                     ? fee_sell - 10.00 * 10 ** 2
464                     : 4.00 * 10 ** 2;
465                 tradeOpenTime += 8 minutes;
466             }
467             // Stop updating fees after hour
468             if (block.timestamp >= tradeOpenTime + 1 hours) {
469                 updateFeesActive = false;
470             }
471         }
472     }
473 
474     //ERC20
475     function _transfer(address from, address to, uint256 amount) internal {
476         require(from != address(0), "ERC20: transfer from the zero address");
477         require(to != address(0), "ERC20: transfer to the zero address");
478         require(amount > 0, "Transfer amount must be greater than zero");
479         //If it's the owner, do a normal transfer
480         if (from == owner() || to == owner() || from == address(this)) {
481             _transferTokens(from, to, amount);
482             return;
483         }
484         //Check if trading is enabled
485         require(trade_open, "Trading is disabled");
486 
487         //Update fees
488         updateFees();
489 
490         uint256 fee_amount = 0;
491         bool isbuy = from == pair_addr;
492 
493         if (!isbuy) {
494             //Handle fees
495             HandleFees();
496         }
497         //Calculate fee if conditions met
498         //Buy
499         if (isbuy) {
500             if (!ignore_fee[to]) {
501                 fee_amount = CalcPercent(amount, fee_buy);
502             }
503         }
504         //Sell
505         else {
506             if (!ignore_fee[from]) {
507                 fee_amount = CalcPercent(
508                     amount,
509                     early_sell ? fee_early_sell : fee_sell
510                 );
511             }
512         }
513         //Fee tokens
514         unchecked {
515             require(amount >= fee_amount, "fee exceeds amount");
516             amount -= fee_amount;
517         }
518         //Disable maxes
519         if (limits_active) {
520             //Check maxes
521             require(amount <= max_tx, "Max TX reached");
522             //Exclude lp pair
523             if (to != pair_addr) {
524                 require(
525                     _balances[to] + amount <= max_wallet,
526                     "Max wallet reached"
527                 );
528             }
529         }
530         //Transfer fee tokens to contract
531         if (fee_amount > 0) {
532             _transferTokens(from, address(this), fee_amount);
533         }
534         //Transfer tokens
535         _transferTokens(from, to, amount);
536     }
537 
538     function HandleFees() private {
539         uint256 token_balance = balanceOf(address(this));
540         bool can_swap = token_balance >= swap_at_amount;
541 
542         if (can_swap && !inSwap && swap_enabled) {
543             SwapTokensForEth(swap_at_amount);
544             uint256 eth_balance = address(this).balance;
545             if (eth_balance > 0 ether) {
546                 SendETHToFee(address(this).balance);
547             }
548         }
549     }
550 
551     function SwapTokensForEth(uint256 _amount) private lockTheSwap {
552         uint256 eth_am = CalcPercent(_amount, percent_helper - lp_percent);
553         uint256 liq_am = _amount - eth_am;
554         uint256 balance_before = address(this).balance;
555 
556         address[] memory path = new address[](2);
557         path[0] = address(this);
558         path[1] = uniswapV2Router.WETH();
559         _approve(address(this), address(uniswapV2Router), _amount);
560         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
561             eth_am,
562             0,
563             path,
564             address(this),
565             block.timestamp
566         );
567         uint256 liq_eth = address(this).balance - balance_before;
568 
569         AddLiquidity(liq_am, CalcPercent(liq_eth, lp_percent));
570     }
571 
572     function SendETHToFee(uint256 _amount) private {
573         (bool success, ) = team_wallet.call{value: _amount}(new bytes(0));
574         require(success, "TransferFail");
575     }
576 
577     function AddLiquidity(uint256 _amount, uint256 ethAmount) private {
578         // approve token transfer to cover all possible scenarios
579         _approve(address(this), address(uniswapV2Router), _amount);
580 
581         // add the liquidity
582         uniswapV2Router.addLiquidityETH{value: ethAmount}(
583             address(this),
584             _amount,
585             0, // slippage is unavoidable
586             0, // slippage is unavoidable
587             address(0),
588             block.timestamp
589         );
590     }
591 
592     //ERC20
593     function name() public view virtual override returns (string memory) {
594         return _name;
595     }
596 
597     function symbol() public view virtual override returns (string memory) {
598         return _symbol;
599     }
600 
601     function decimals() public view virtual override returns (uint8) {
602         return _decimals;
603     }
604 
605     function totalSupply() public view virtual override returns (uint256) {
606         return _totalSupply;
607     }
608 
609     function balanceOf(
610         address account
611     ) public view virtual override returns (uint256) {
612         return _balances[account];
613     }
614 
615     function transfer(
616         address to,
617         uint256 amount
618     ) public virtual override returns (bool) {
619         address owner = _msgSender();
620         _transfer(owner, to, amount);
621         return true;
622     }
623 
624     function transferFrom(
625         address from,
626         address to,
627         uint256 amount
628     ) public virtual override returns (bool) {
629         address spender = _msgSender();
630         _spendAllowance(from, spender, amount);
631         _transfer(from, to, amount);
632         return true;
633     }
634 
635     function allowance(
636         address owner,
637         address spender
638     ) public view virtual override returns (uint256) {
639         return _allowances[owner][spender];
640     }
641 
642     function approve(
643         address spender,
644         uint256 amount
645     ) public virtual override returns (bool) {
646         address owner = _msgSender();
647         _approve(owner, spender, amount);
648         return true;
649     }
650 
651     function _approve(
652         address owner,
653         address spender,
654         uint256 amount
655     ) internal virtual {
656         require(owner != address(0), "ERC20: approve from the zero address");
657         require(spender != address(0), "ERC20: approve to the zero address");
658 
659         _allowances[owner][spender] = amount;
660         emit Approval(owner, spender, amount);
661     }
662 
663     function _spendAllowance(
664         address owner,
665         address spender,
666         uint256 amount
667     ) internal virtual {
668         uint256 currentAllowance = allowance(owner, spender);
669         if (currentAllowance != type(uint256).max) {
670             require(
671                 currentAllowance >= amount,
672                 "ERC20: insufficient allowance"
673             );
674             unchecked {
675                 _approve(owner, spender, currentAllowance - amount);
676             }
677         }
678     }
679 
680     function _transferTokens(
681         address from,
682         address to,
683         uint256 amount
684     ) internal virtual {
685         uint256 fromBalance = _balances[from];
686         require(
687             fromBalance >= amount,
688             "ERC20: transfer amount exceeds balance"
689         );
690         unchecked {
691             _balances[from] = fromBalance - amount;
692             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
693             // decrementing then incrementing.
694             _balances[to] += amount;
695         }
696 
697         emit Transfer(from, to, amount);
698     }
699 
700     // Function to receive Ether. msg.data must be empty
701     receive() external payable {}
702 
703     // Fallback function is called when msg.data is not empty
704     fallback() external payable {}
705 }