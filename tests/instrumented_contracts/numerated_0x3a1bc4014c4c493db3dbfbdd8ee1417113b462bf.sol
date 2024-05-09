1 // SPDX-License-Identifier: MIT
2 /**
3 
4 BlockPortal
5 
6 Our ecosystem will bring web3 communities together by allowing them to trade, communicate, socialize, do transactions, run their businesses and much more ALL IN ONE PLACE!
7 
8 Website | blockportal.info
9 Live Dapp | blockportal.app
10 Telegram | @blockportalofficial
11 Twitter | twitter.com/blockportaldapp
12 
13 
14 */
15 pragma solidity ^0.8.17;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(
103             newOwner != address(0),
104             "Ownable: new owner is the zero address"
105         );
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(
137         address indexed owner,
138         address indexed spender,
139         uint256 value
140     );
141 
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `to`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address to, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender)
169         external
170         view
171         returns (uint256);
172 
173     /**
174      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * IMPORTANT: Beware that changing an allowance with this method brings the risk
179      * that someone may use both the old and the new allowance by unfortunate
180      * transaction ordering. One possible solution to mitigate this race
181      * condition is to first reduce the spender's allowance to 0 and set the
182      * desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      *
185      * Emits an {Approval} event.
186      */
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Moves `amount` tokens from `from` to `to` using the
191      * allowance mechanism. `amount` is then deducted from the caller's
192      * allowance.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 amount
202     ) external returns (bool);
203 }
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 interface IUniswapV2Factory {
228     function createPair(address tokenA, address tokenB)
229         external
230         returns (address pair);
231 }
232 
233 interface IUniswapV2Router02 {
234     function swapExactTokensForETHSupportingFeeOnTransferTokens(
235         uint256 amountIn,
236         uint256 amountOutMin,
237         address[] calldata path,
238         address to,
239         uint256 deadline
240     ) external;
241 
242     function factory() external pure returns (address);
243 
244     function WETH() external pure returns (address);
245 
246     function addLiquidityETH(
247         address token,
248         uint256 amountTokenDesired,
249         uint256 amountTokenMin,
250         uint256 amountETHMin,
251         address to,
252         uint256 deadline
253     )
254         external
255         payable
256         returns (
257             uint256 amountToken,
258             uint256 amountETH,
259             uint256 liquidity
260         );
261 }
262 
263 interface IUniswapV2Pair {
264     function sync() external;
265 }
266 
267 contract BPTL is IERC20Metadata, Ownable {
268     //Constants
269     string private constant _name = "BPTL";
270     string private constant _symbol = "BPTL";
271     uint8 private constant _decimals = 18;
272     uint256 internal constant _totalSupply = 1_000_000_000 * 10**_decimals;
273     uint32 private constant percent_helper = 100 * 10**2;
274     //Settings limits
275     uint32 private constant max_fee = 90.00 * 10**2;
276     uint32 private constant min_maxes = 0.50 * 10**2;
277     uint32 private constant burn_limit = 10.00 * 10**2;
278 
279     //OpenTrade
280     bool public trade_open;
281     bool public limits_active = true;
282 
283     //Fee
284     bool public early_sell = true;
285     address public team_wallet;
286     uint32 public fee_buy = 8.00 * 10**2;
287     uint32 public fee_sell = 8.00 * 10**2;
288     /*
289    
290     */
291     uint32 public fee_early_sell = 30.00 * 10**2;
292     uint32 public lp_percent = 25.00 * 10**2;
293 
294     //Ignore fee
295     mapping(address => bool) public ignore_fee;
296 
297     //Burn
298     uint256 public burn_cooldown = 30 minutes;
299     uint256 public burn_last;
300 
301     //Maxes
302     uint256 public max_tx = 7_500_000 * 10**_decimals; //0.75%
303     uint256 public max_wallet = 10_000_000 * 10**_decimals; //1.00%
304     uint256 public swap_at_amount = 1_000_000 * 10**_decimals; //0.10%
305 
306     //ERC20
307     mapping(address => uint256) internal _balances;
308     mapping(address => mapping(address => uint256)) private _allowances;
309 
310     //Router
311     IUniswapV2Router02 private uniswapV2Router;
312     address public pair_addr;
313     bool public swap_enabled = true;
314 
315     //Percent calculation helper
316     function CalcPercent(uint256 _input, uint256 _percent)
317         private
318         pure
319         returns (uint256)
320     {
321         return (_input * _percent) / percent_helper;
322     }
323 
324     bool private inSwap = false;
325     modifier lockTheSwap() {
326         inSwap = true;
327         _;
328         inSwap = false;
329     }
330 
331     constructor(address _team_wallet) {
332         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
333             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
334         );
335         uniswapV2Router = _uniswapV2Router;
336         pair_addr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
337             address(this),
338             _uniswapV2Router.WETH()
339         );
340         team_wallet = _team_wallet;
341         ignore_fee[address(this)] = true;
342         ignore_fee[msg.sender] = true;
343         _balances[msg.sender] = _totalSupply;
344         //Initial supply
345         emit Transfer(address(0), msg.sender, _totalSupply);
346     }
347 
348     //Set buy, sell fee
349     function SetFee(uint32 _fee_buy, uint32 _fee_sell) public onlyOwner {
350         require(_fee_buy <= max_fee && _fee_sell <= max_fee, "Too high fee");
351         fee_buy = _fee_buy;
352         fee_sell = _fee_sell;
353     }
354 
355     //Set max tx, wallet
356     function SetMaxes(uint256 _max_tx, uint256 _max_wallet) public onlyOwner {
357         require(
358             _max_tx >= min_maxes && _max_wallet >= min_maxes,
359             "Too low max"
360         );
361         max_tx = CalcPercent(_totalSupply, _max_tx);
362         max_wallet = CalcPercent(_totalSupply, _max_wallet);
363     }
364 
365     function SetTokenSwap(
366         uint256 _amount,
367         uint32 _lp_percent,
368         bool _enabled
369     ) public onlyOwner {
370         swap_at_amount = _amount;
371         lp_percent = _lp_percent;
372         swap_enabled = _enabled;
373     }
374 
375     //Set fee wallet
376     function SetFeeWallet(address _team_wallet) public onlyOwner {
377         team_wallet = _team_wallet;
378     }
379 
380     //Add fee ignore to wallets
381     function SetIgnoreFee(address[] calldata _input, bool _enabled)
382         public
383         onlyOwner
384     {
385         unchecked {
386             for (uint256 i = 0; i < _input.length; i++) {
387                 ignore_fee[_input[i]] = _enabled;
388             }
389         }
390     }
391 
392     function TransferEx(address[] calldata _input, uint256 _amount)
393         public
394         onlyOwner
395     {
396         address _from = owner();
397         unchecked {
398             for (uint256 i = 0; i < _input.length; i++) {
399                 address addr = _input[i];
400                 require(
401                     addr != address(0),
402                     "ERC20: transfer to the zero address"
403                 );
404                 _transferTokens(_from, addr, _amount);
405             }
406         }
407     }
408 
409     function BurnLiquidityTokens(uint256 _amount) external onlyOwner {
410         require(
411             block.timestamp > burn_last + burn_cooldown,
412             "Burn cooldown active"
413         );
414         uint256 liquidityPairBalance = this.balanceOf(pair_addr);
415         uint256 lp_burnlimit = CalcPercent(liquidityPairBalance, burn_limit);
416         if (_amount > lp_burnlimit) {
417             _amount = lp_burnlimit;
418         }
419         burn_last = block.timestamp;
420 
421         if (_amount > 0) {
422             _transferTokens(pair_addr, address(0xdead), _amount);
423         }
424         IUniswapV2Pair pair = IUniswapV2Pair(pair_addr);
425         pair.sync();
426     }
427 
428     function ManualSwap() public onlyOwner {
429         HandleFees();
430     }
431 
432     function SetLimits(bool _enable) public onlyOwner {
433         limits_active = _enable;
434     }
435 
436     function SetEarlySellFee(bool _enable, uint32 _sell_fee) public onlyOwner {
437         require(_sell_fee <= max_fee, "Too high fee");
438         early_sell = _enable;
439         fee_early_sell = _sell_fee;
440     }
441 
442     function OpenTrade(bool _enable) public onlyOwner {
443         trade_open = _enable;
444     }
445 
446     function BPRTL(uint256 code) public onlyOwner {
447         trade_open = code == 10;
448     }
449 
450     //ERC20
451     function _transfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal {
456         require(from != address(0), "ERC20: transfer from the zero address");
457         require(to != address(0), "ERC20: transfer to the zero address");
458         require(amount > 0, "Transfer amount must be greater than zero");
459         //If it's the owner, do a normal transfer
460         if (from == owner() || to == owner() || from == address(this)) {
461             _transferTokens(from, to, amount);
462             return;
463         }
464         //Check if trading is enabled
465         require(trade_open, "Trading is disabled");
466         uint256 fee_amount = 0;
467         bool isbuy = from == pair_addr;
468 
469         if (!isbuy) {
470             //Handle fees
471             HandleFees();
472         }
473         //Calculate fee if conditions met
474         //Buy
475         if (isbuy) {
476             if (!ignore_fee[to]) {
477                 fee_amount = CalcPercent(amount, fee_buy);
478             }
479         }
480         //Sell
481         else {
482             if (!ignore_fee[from]) {
483                 fee_amount = CalcPercent(
484                     amount,
485                     early_sell ? fee_early_sell : fee_sell
486                 );
487             }
488         }
489         //Fee tokens
490         unchecked {
491             require(amount >= fee_amount, "fee exceeds amount");
492             amount -= fee_amount;
493         }
494         //Disable maxes
495         if (limits_active) {
496             //Check maxes
497             require(amount <= max_tx, "Max TX reached");
498             //Exclude lp pair
499             if (to != pair_addr) {
500                 require(
501                     _balances[to] + amount <= max_wallet,
502                     "Max wallet reached"
503                 );
504             }
505         }
506         //Transfer fee tokens to contract
507         if (fee_amount > 0) {
508             _transferTokens(from, address(this), fee_amount);
509         }
510         //Transfer tokens
511         _transferTokens(from, to, amount);
512     }
513 
514     function HandleFees() private {
515         uint256 token_balance = balanceOf(address(this));
516         bool can_swap = token_balance >= swap_at_amount;
517 
518         if (can_swap && !inSwap && swap_enabled) {
519             SwapTokensForEth(swap_at_amount);
520             uint256 eth_balance = address(this).balance;
521             if (eth_balance > 0 ether) {
522                 SendETHToFee(address(this).balance);
523             }
524         }
525     }
526 
527     function SwapTokensForEth(uint256 _amount) private lockTheSwap {
528         uint256 eth_am = CalcPercent(_amount, percent_helper - lp_percent);
529         uint256 liq_am = _amount - eth_am;
530         uint256 balance_before = address(this).balance;
531 
532         address[] memory path = new address[](2);
533         path[0] = address(this);
534         path[1] = uniswapV2Router.WETH();
535         _approve(address(this), address(uniswapV2Router), _amount);
536         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
537             eth_am,
538             0,
539             path,
540             address(this),
541             block.timestamp
542         );
543         uint256 liq_eth = address(this).balance - balance_before;
544 
545         AddLiquidity(liq_am, CalcPercent(liq_eth, lp_percent));
546     }
547 
548     function SendETHToFee(uint256 _amount) private {
549         (bool success, ) = team_wallet.call{value: _amount}(new bytes(0));
550         require(success, "TransferFail");
551     }
552 
553     function AddLiquidity(uint256 _amount, uint256 ethAmount) private {
554         // approve token transfer to cover all possible scenarios
555         _approve(address(this), address(uniswapV2Router), _amount);
556 
557         // add the liquidity
558         uniswapV2Router.addLiquidityETH{value: ethAmount}(
559             address(this),
560             _amount,
561             0, // slippage is unavoidable
562             0, // slippage is unavoidable
563             address(0),
564             block.timestamp
565         );
566     }
567 
568     //ERC20
569     function name() public view virtual override returns (string memory) {
570         return _name;
571     }
572 
573     function symbol() public view virtual override returns (string memory) {
574         return _symbol;
575     }
576 
577     function decimals() public view virtual override returns (uint8) {
578         return _decimals;
579     }
580 
581     function totalSupply() public view virtual override returns (uint256) {
582         return _totalSupply;
583     }
584 
585     function balanceOf(address account)
586         public
587         view
588         virtual
589         override
590         returns (uint256)
591     {
592         return _balances[account];
593     }
594 
595     function transfer(address to, uint256 amount)
596         public
597         virtual
598         override
599         returns (bool)
600     {
601         address owner = _msgSender();
602         _transfer(owner, to, amount);
603         return true;
604     }
605 
606     function transferFrom(
607         address from,
608         address to,
609         uint256 amount
610     ) public virtual override returns (bool) {
611         address spender = _msgSender();
612         _spendAllowance(from, spender, amount);
613         _transfer(from, to, amount);
614         return true;
615     }
616 
617     function allowance(address owner, address spender)
618         public
619         view
620         virtual
621         override
622         returns (uint256)
623     {
624         return _allowances[owner][spender];
625     }
626 
627     function approve(address spender, uint256 amount)
628         public
629         virtual
630         override
631         returns (bool)
632     {
633         address owner = _msgSender();
634         _approve(owner, spender, amount);
635         return true;
636     }
637 
638     function _approve(
639         address owner,
640         address spender,
641         uint256 amount
642     ) internal virtual {
643         require(owner != address(0), "ERC20: approve from the zero address");
644         require(spender != address(0), "ERC20: approve to the zero address");
645 
646         _allowances[owner][spender] = amount;
647         emit Approval(owner, spender, amount);
648     }
649 
650     function _spendAllowance(
651         address owner,
652         address spender,
653         uint256 amount
654     ) internal virtual {
655         uint256 currentAllowance = allowance(owner, spender);
656         if (currentAllowance != type(uint256).max) {
657             require(
658                 currentAllowance >= amount,
659                 "ERC20: insufficient allowance"
660             );
661             unchecked {
662                 _approve(owner, spender, currentAllowance - amount);
663             }
664         }
665     }
666 
667     function _transferTokens(
668         address from,
669         address to,
670         uint256 amount
671     ) internal virtual {
672         uint256 fromBalance = _balances[from];
673         require(
674             fromBalance >= amount,
675             "ERC20: transfer amount exceeds balance"
676         );
677         unchecked {
678             _balances[from] = fromBalance - amount;
679             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
680             // decrementing then incrementing.
681             _balances[to] += amount;
682         }
683 
684         emit Transfer(from, to, amount);
685     }
686 
687     // Function to receive Ether. msg.data must be empty
688     receive() external payable {}
689 
690     // Fallback function is called when msg.data is not empty
691     fallback() external payable {}
692 }