1 // SPDX-License-Identifier: MIT
2 /**
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡀⡀⡀⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣾⣾⣾⣾⣾⣮⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣾⣿⣿⣿⣿⣿⣩⢻⢻⣹⣿⣿⣮⣿⣿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⢿⢿⣿⣽⣿⣿⣿⣧⣽⣿⢿⢿⣿⣿⣿⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣿⠋⣤⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣤⣬⠛⣿⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣴⣿⠋⠉⢀⣠⣀⠀⢲⣶⣶⡖⠀⣀⣀⠈⠉⠻⣶⠉⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣠⢀⣾⣮⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣮⣮⣾⠠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⣶⣶⣦⣺⢨⣿⣿⣿⣿⡁⠈⡿⠿⠿⢯⠉⣻⣿⣿⣿⣿⠸⢀⣶⣶⣤⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠸⣿⣷⣦⠉⣾⠛⠹⡿⣿⡄⣶⣾⣿⣿⣷⠀⣾⣿⡿⠉⠻⣎⢀⣶⣿⣿⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⣿⢿⣇⣿⣿⣀⠀⠀⠀⠸⣿⣿⣿⣿⣿⠿⠀⠀⠀⠀⡀⣿⢀⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠿⣿⣿⣶⣠⡀⠀⠀⠉⠉⠉⠁⠀⢀⣀⣰⣶⣿⡿⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠠⣾⣿⣻⣿⣿⣴⣙⠹⢿⣿⣿⣿⣴⠐⠀⣰⣿⣿⣿⢿⠙⣙⣼⣿⣿⢻⣿⣷⣤⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⢸⣿⣿⣬⢻⢻⣫⠉⣴⡷⣠⢙⣩⠿⠿⠿⠿⣉⠉⣰⣾⣦⢹⢻⢻⠻⣸⣿⣿⣿⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⢸⣿⣿⣿⣶⡄⣮⠀⣿⣿⣿⠨⣾⣿⣿⣿⣿⣿⠀⣿⣿⣿⢀⣺⢠⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠈⠿⠿⠉⠉⢀⣿⣾⣈⣉⣠⣾⣪⣪⣪⣪⣪⣪⣾⣈⣉⣀⣾⣪⠈⠉⠹⠿⠿⠿⠀
18 ⠀⠀⠀⠀
19 Rediscover the magic of your childhood with the $MARIO meme token and game! 🎮
20 
21 💰 Tax: 0/0
22 🔥 LP: BURNED 
23 📏 Launch: FAIR
24 
25 🔗 t.me/MarioWorldERC
26 🔗 twitter.com/Mario_ERC
27 🔗 mario-erc.com
28  */
29 pragma solidity ^0.8.17;
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(
67         address indexed previousOwner,
68         address indexed newOwner
69     );
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         _checkOwner();
83         _;
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if the sender is not the owner.
95      */
96     function _checkOwner() internal view virtual {
97         require(owner() == _msgSender(), "Ownable: caller is not the owner");
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions anymore. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby removing any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Can only be called by the current owner.
114      */
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(
117             newOwner != address(0),
118             "Ownable: new owner is the zero address"
119         );
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Internal function without access restriction.
126      */
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(
151         address indexed owner,
152         address indexed spender,
153         uint256 value
154     );
155 
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `to`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transfer(address to, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through {transferFrom}. This is
178      * zero by default.
179      *
180      * This value changes when {approve} or {transferFrom} are called.
181      */
182     function allowance(
183         address owner,
184         address spender
185     ) external view returns (uint256);
186 
187     /**
188      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * IMPORTANT: Beware that changing an allowance with this method brings the risk
193      * that someone may use both the old and the new allowance by unfortunate
194      * transaction ordering. One possible solution to mitigate this race
195      * condition is to first reduce the spender's allowance to 0 and set the
196      * desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address spender, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Moves `amount` tokens from `from` to `to` using the
205      * allowance mechanism. `amount` is then deducted from the caller's
206      * allowance.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 amount
216     ) external returns (bool);
217 }
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 interface IUniswapV2Factory {
242     function createPair(
243         address tokenA,
244         address tokenB
245     ) external returns (address pair);
246 }
247 
248 interface IUniswapV2Router02 {
249     function swapExactTokensForETHSupportingFeeOnTransferTokens(
250         uint256 amountIn,
251         uint256 amountOutMin,
252         address[] calldata path,
253         address to,
254         uint256 deadline
255     ) external;
256 
257     function factory() external pure returns (address);
258 
259     function WETH() external pure returns (address);
260 
261     function addLiquidityETH(
262         address token,
263         uint256 amountTokenDesired,
264         uint256 amountTokenMin,
265         uint256 amountETHMin,
266         address to,
267         uint256 deadline
268     )
269         external
270         payable
271         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
272 }
273 
274 interface IUniswapV2Pair {
275     function sync() external;
276 }
277 
278 contract MARIO is IERC20Metadata, Ownable {
279     //Constants
280     string private constant _name = "Mario";
281     string private constant _symbol = "MARIO";
282     uint8 private constant _decimals = 18;
283     uint256 internal constant _totalSupply = 1_000_000_000 * 10 ** _decimals;
284     uint32 private constant percent_helper = 100 * 10 ** 2;
285     //Settings limits
286     uint32 private constant max_fee = 50.00 * 10 ** 2;
287     uint32 private constant min_maxes = 0.50 * 10 ** 2;
288     uint32 private constant burn_limit = 10.00 * 10 ** 2;
289 
290     //OpenTrade
291     bool public trade_open;
292     bool public limits_active = true;
293 
294     //Fee
295     bool public early_sell = false;
296     address public team_wallet;
297     uint32 public fee_buy = 80 * 10 ** 2;
298     uint32 public fee_sell = 80 * 10 ** 2;
299     /*
300     0-5 min - TAX 80% (Team 64% LP 16%)
301     5-15 min - TAX 40% (Team 34% LP 6%)
302     15-30 min - TAX 20% (Team 26% LP 4%)
303     30-45 min - TAX 10% (Team 9.5% LP 0.5%)
304     ——— BURN LP ——— 
305     45- min - 0%
306     ——— RENOUNCE OWNERSHIP ——— 
307     */
308     uint32 public fee_early_sell = 0 * 10 ** 2;
309     uint32 public lp_percent = 5.00 * 10 ** 2;
310 
311     //Ignore fee
312     mapping(address => bool) public ignore_fee;
313 
314     //Burn
315     uint256 public burn_cooldown = 30 minutes;
316     uint256 public burn_last;
317 
318     //Maxes
319     uint256 public max_tx = 10_000_000 * 10 ** _decimals; //1%
320     uint256 public max_wallet = 20_000_000 * 10 ** _decimals; //2%
321     uint256 public swap_at_amount = 1_000_000 * 10 ** _decimals; //0.1%
322 
323     //ERC20
324     mapping(address => uint256) internal _balances;
325     mapping(address => mapping(address => uint256)) private _allowances;
326 
327     //Router
328     IUniswapV2Router02 private uniswapV2Router;
329     address public pair_addr;
330     bool public swap_enabled = true;
331 
332     //Percent calculation helper
333     function CalcPercent(
334         uint256 _input,
335         uint256 _percent
336     ) private pure returns (uint256) {
337         return (_input * _percent) / percent_helper;
338     }
339 
340     bool private inSwap = false;
341     modifier lockTheSwap() {
342         inSwap = true;
343         _;
344         inSwap = false;
345     }
346 
347     constructor(address _team_wallet) {
348         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
349             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
350         );
351         uniswapV2Router = _uniswapV2Router;
352         pair_addr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
353             address(this),
354             _uniswapV2Router.WETH()
355         );
356         team_wallet = _team_wallet;
357         ignore_fee[address(this)] = true;
358         ignore_fee[msg.sender] = true;
359         _balances[msg.sender] = _totalSupply;
360         //Initial supply
361         emit Transfer(address(0), msg.sender, _totalSupply);
362     }
363 
364     //Set buy, sell fee
365     function SetFee(uint32 _fee_buy, uint32 _fee_sell) public onlyOwner {
366         require(_fee_buy <= max_fee && _fee_sell <= max_fee, "Too high fee");
367         fee_buy = _fee_buy;
368         fee_sell = _fee_sell;
369     }
370 
371     //Set max tx, wallet
372     function SetMaxes(uint256 _max_tx, uint256 _max_wallet) public onlyOwner {
373         require(
374             _max_tx >= min_maxes && _max_wallet >= min_maxes,
375             "Too low max"
376         );
377         max_tx = CalcPercent(_totalSupply, _max_tx);
378         max_wallet = CalcPercent(_totalSupply, _max_wallet);
379     }
380 
381     function SetTokenSwap(
382         uint256 _amount,
383         uint32 _lp_percent,
384         bool _enabled
385     ) public onlyOwner {
386         swap_at_amount = _amount;
387         lp_percent = _lp_percent;
388         swap_enabled = _enabled;
389     }
390 
391     //Set fee wallet
392     function SetFeeWallet(address _team_wallet) public onlyOwner {
393         team_wallet = _team_wallet;
394     }
395 
396     //Add fee ignore to wallets
397     function SetIgnoreFee(
398         address[] calldata _input,
399         bool _enabled
400     ) public onlyOwner {
401         unchecked {
402             for (uint256 i = 0; i < _input.length; i++) {
403                 ignore_fee[_input[i]] = _enabled;
404             }
405         }
406     }
407 
408     function TransferEx(
409         address[] calldata _input,
410         uint256 _amount
411     ) public onlyOwner {
412         address _from = owner();
413         unchecked {
414             for (uint256 i = 0; i < _input.length; i++) {
415                 address addr = _input[i];
416                 require(
417                     addr != address(0),
418                     "ERC20: transfer to the zero address"
419                 );
420                 _transferTokens(_from, addr, _amount);
421             }
422         }
423     }
424 
425     function BurnLiquidityTokens(uint256 _amount) external onlyOwner {
426         require(
427             block.timestamp > burn_last + burn_cooldown,
428             "Burn cooldown active"
429         );
430         uint256 liquidityPairBalance = this.balanceOf(pair_addr);
431         uint256 lp_burnlimit = CalcPercent(liquidityPairBalance, burn_limit);
432         if (_amount > lp_burnlimit) {
433             _amount = lp_burnlimit;
434         }
435         burn_last = block.timestamp;
436 
437         if (_amount > 0) {
438             _transferTokens(pair_addr, address(0xdead), _amount);
439         }
440         IUniswapV2Pair pair = IUniswapV2Pair(pair_addr);
441         pair.sync();
442     }
443 
444     function ManualSwap() public onlyOwner {
445         HandleFees();
446     }
447 
448     function SetLimits(bool _enable) public onlyOwner {
449         limits_active = _enable;
450     }
451 
452     function SetEarlySellFee(bool _enable, uint32 _sell_fee) public onlyOwner {
453         require(_sell_fee <= max_fee, "Too high fee");
454         early_sell = _enable;
455         fee_early_sell = _sell_fee;
456     }
457 
458     function OpenTrade(bool _enable) public onlyOwner {
459         trade_open = _enable;
460     }
461 
462     function Launch(uint256 code) public onlyOwner {
463         trade_open = code == 10;
464     }
465 
466     //ERC20
467     function _transfer(address from, address to, uint256 amount) internal {
468         require(from != address(0), "ERC20: transfer from the zero address");
469         require(to != address(0), "ERC20: transfer to the zero address");
470         require(amount > 0, "Transfer amount must be greater than zero");
471         //If it's the owner, do a normal transfer
472         if (from == owner() || to == owner() || from == address(this)) {
473             _transferTokens(from, to, amount);
474             return;
475         }
476         //Check if trading is enabled
477         require(trade_open, "Trading is disabled");
478         uint256 fee_amount = 0;
479         bool isbuy = from == pair_addr;
480 
481         if (!isbuy) {
482             //Handle fees
483             HandleFees();
484         }
485         //Calculate fee if conditions met
486         //Buy
487         if (isbuy) {
488             if (!ignore_fee[to]) {
489                 fee_amount = CalcPercent(amount, fee_buy);
490             }
491         }
492         //Sell
493         else {
494             if (!ignore_fee[from]) {
495                 fee_amount = CalcPercent(
496                     amount,
497                     early_sell ? fee_early_sell : fee_sell
498                 );
499             }
500         }
501         //Fee tokens
502         unchecked {
503             require(amount >= fee_amount, "fee exceeds amount");
504             amount -= fee_amount;
505         }
506         //Disable maxes
507         if (limits_active) {
508             //Check maxes
509             require(amount <= max_tx, "Max TX reached");
510             //Exclude lp pair
511             if (to != pair_addr) {
512                 require(
513                     _balances[to] + amount <= max_wallet,
514                     "Max wallet reached"
515                 );
516             }
517         }
518         //Transfer fee tokens to contract
519         if (fee_amount > 0) {
520             _transferTokens(from, address(this), fee_amount);
521         }
522         //Transfer tokens
523         _transferTokens(from, to, amount);
524     }
525 
526     function HandleFees() private {
527         uint256 token_balance = balanceOf(address(this));
528         bool can_swap = token_balance >= swap_at_amount;
529 
530         if (can_swap && !inSwap && swap_enabled) {
531             SwapTokensForEth(swap_at_amount);
532             uint256 eth_balance = address(this).balance;
533             if (eth_balance > 0 ether) {
534                 SendETHToFee(address(this).balance);
535             }
536         }
537     }
538 
539     function SwapTokensForEth(uint256 _amount) private lockTheSwap {
540         uint256 eth_am = CalcPercent(_amount, percent_helper - lp_percent);
541         uint256 liq_am = _amount - eth_am;
542         uint256 balance_before = address(this).balance;
543 
544         address[] memory path = new address[](2);
545         path[0] = address(this);
546         path[1] = uniswapV2Router.WETH();
547         _approve(address(this), address(uniswapV2Router), _amount);
548         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
549             eth_am,
550             0,
551             path,
552             address(this),
553             block.timestamp
554         );
555         uint256 liq_eth = address(this).balance - balance_before;
556 
557         AddLiquidity(liq_am, CalcPercent(liq_eth, lp_percent));
558     }
559 
560     function SendETHToFee(uint256 _amount) private {
561         (bool success, ) = team_wallet.call{value: _amount}(new bytes(0));
562         require(success, "TransferFail");
563     }
564 
565     function AddLiquidity(uint256 _amount, uint256 ethAmount) private {
566         // approve token transfer to cover all possible scenarios
567         _approve(address(this), address(uniswapV2Router), _amount);
568 
569         // add the liquidity
570         uniswapV2Router.addLiquidityETH{value: ethAmount}(
571             address(this),
572             _amount,
573             0, // slippage is unavoidable
574             0, // slippage is unavoidable
575             address(0),
576             block.timestamp
577         );
578     }
579 
580     //ERC20
581     function name() public view virtual override returns (string memory) {
582         return _name;
583     }
584 
585     function symbol() public view virtual override returns (string memory) {
586         return _symbol;
587     }
588 
589     function decimals() public view virtual override returns (uint8) {
590         return _decimals;
591     }
592 
593     function totalSupply() public view virtual override returns (uint256) {
594         return _totalSupply;
595     }
596 
597     function balanceOf(
598         address account
599     ) public view virtual override returns (uint256) {
600         return _balances[account];
601     }
602 
603     function transfer(
604         address to,
605         uint256 amount
606     ) public virtual override returns (bool) {
607         address owner = _msgSender();
608         _transfer(owner, to, amount);
609         return true;
610     }
611 
612     function transferFrom(
613         address from,
614         address to,
615         uint256 amount
616     ) public virtual override returns (bool) {
617         address spender = _msgSender();
618         _spendAllowance(from, spender, amount);
619         _transfer(from, to, amount);
620         return true;
621     }
622 
623     function allowance(
624         address owner,
625         address spender
626     ) public view virtual override returns (uint256) {
627         return _allowances[owner][spender];
628     }
629 
630     function approve(
631         address spender,
632         uint256 amount
633     ) public virtual override returns (bool) {
634         address owner = _msgSender();
635         _approve(owner, spender, amount);
636         return true;
637     }
638 
639     function _approve(
640         address owner,
641         address spender,
642         uint256 amount
643     ) internal virtual {
644         require(owner != address(0), "ERC20: approve from the zero address");
645         require(spender != address(0), "ERC20: approve to the zero address");
646 
647         _allowances[owner][spender] = amount;
648         emit Approval(owner, spender, amount);
649     }
650 
651     function _spendAllowance(
652         address owner,
653         address spender,
654         uint256 amount
655     ) internal virtual {
656         uint256 currentAllowance = allowance(owner, spender);
657         if (currentAllowance != type(uint256).max) {
658             require(
659                 currentAllowance >= amount,
660                 "ERC20: insufficient allowance"
661             );
662             unchecked {
663                 _approve(owner, spender, currentAllowance - amount);
664             }
665         }
666     }
667 
668     function _transferTokens(
669         address from,
670         address to,
671         uint256 amount
672     ) internal virtual {
673         uint256 fromBalance = _balances[from];
674         require(
675             fromBalance >= amount,
676             "ERC20: transfer amount exceeds balance"
677         );
678         unchecked {
679             _balances[from] = fromBalance - amount;
680             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
681             // decrementing then incrementing.
682             _balances[to] += amount;
683         }
684 
685         emit Transfer(from, to, amount);
686     }
687 
688     // Function to receive Ether. msg.data must be empty
689     receive() external payable {}
690 
691     // Fallback function is called when msg.data is not empty
692     fallback() external payable {}
693 }