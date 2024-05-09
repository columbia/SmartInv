1 // SPDX-License-Identifier: MIT
2 /**
3 
4                      ############                                   
5                ########################                             
6            ############        ###########                          
7          ########                    ########                       
8        #######                          #######                     
9       ######                      ###     ######                    
10      #####                   ########      ######                   
11     #####              #       ######       ######                  
12     #####            ####    #####           #####                  
13    #####           ######   ####             #####                  
14    ######         #############              #####                  
15     #####       #####  ######               ######                  
16     ######     #####    ####               ######                   
17      ######              #                ######                    
18        ######                           #######                     
19         ########                      #######                       
20            #########             ##########                         
21               ##########################                            
22                    ################                                 
23 
24 
25 
26 TUF Sniper Bot (TUF)
27 
28 💬TG: https://t.me/TUFTokenPortal
29 💬TG: https://t.me/TUFReloadedPortal
30 🕸Website: https://tufext.com/
31 
32 */
33 pragma solidity ^0.8.17;
34 
35 /**
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(
71         address indexed previousOwner,
72         address indexed newOwner
73     );
74 
75     /**
76      * @dev Initializes the contract setting the deployer as the initial owner.
77      */
78     constructor() {
79         _transferOwnership(_msgSender());
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         _checkOwner();
87         _;
88     }
89 
90     /**
91      * @dev Returns the address of the current owner.
92      */
93     function owner() public view virtual returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if the sender is not the owner.
99      */
100     function _checkOwner() internal view virtual {
101         require(owner() == _msgSender(), "Ownable: caller is not the owner");
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(
121             newOwner != address(0),
122             "Ownable: new owner is the zero address"
123         );
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP.
140  */
141 interface IERC20 {
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(
155         address indexed owner,
156         address indexed spender,
157         uint256 value
158     );
159 
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns the amount of tokens owned by `account`.
167      */
168     function balanceOf(address account) external view returns (uint256);
169 
170     /**
171      * @dev Moves `amount` tokens from the caller's account to `to`.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transfer(address to, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Returns the remaining number of tokens that `spender` will be
181      * allowed to spend on behalf of `owner` through {transferFrom}. This is
182      * zero by default.
183      *
184      * This value changes when {approve} or {transferFrom} are called.
185      */
186     function allowance(address owner, address spender)
187         external
188         view
189         returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `from` to `to` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 amount
220     ) external returns (bool);
221 }
222 
223 /**
224  * @dev Interface for the optional metadata functions from the ERC20 standard.
225  *
226  * _Available since v4.1._
227  */
228 interface IERC20Metadata is IERC20 {
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the symbol of the token.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the decimals places of the token.
241      */
242     function decimals() external view returns (uint8);
243 }
244 
245 interface IUniswapV2Factory {
246     function createPair(address tokenA, address tokenB)
247         external
248         returns (address pair);
249 }
250 
251 interface IUniswapV2Router02 {
252     function swapExactTokensForETHSupportingFeeOnTransferTokens(
253         uint256 amountIn,
254         uint256 amountOutMin,
255         address[] calldata path,
256         address to,
257         uint256 deadline
258     ) external;
259 
260     function factory() external pure returns (address);
261 
262     function WETH() external pure returns (address);
263 
264     function addLiquidityETH(
265         address token,
266         uint256 amountTokenDesired,
267         uint256 amountTokenMin,
268         uint256 amountETHMin,
269         address to,
270         uint256 deadline
271     )
272         external
273         payable
274         returns (
275             uint256 amountToken,
276             uint256 amountETH,
277             uint256 liquidity
278         );
279 }
280 
281 interface IUniswapV2Pair {
282     function sync() external;
283 }
284 
285 contract TUFToken is IERC20Metadata, Ownable {
286     //Constants
287     string private constant _name = "TUF Token";
288     string private constant _symbol = "TUF";
289     uint8 private constant _decimals = 18;
290     uint256 internal constant _totalSupply = 1_000_000_000 * 10**_decimals;
291     uint32 private constant percent_helper = 100 * 10**2;
292     //Settings limits
293     uint32 private constant max_fee = 30.00 * 10**2;
294     uint32 private constant min_maxes = 0.50 * 10**2;
295     uint32 private constant burn_limit = 10.00 * 10**2;
296 
297     //OpenTrade
298     bool public trade_open;
299     bool public limits_active = true;
300 
301     //Fee
302     bool public early_sell = true;
303     address public team_wallet;
304     uint32 public fee_buy = 8.00 * 10**2;
305     uint32 public fee_sell = 8.00 * 10**2;
306     /*
307     0-10 min - 30% (Team 22.5% LP 7.5%)
308     10-20 min - 25% (Team 18.75% LP 6.25%)
309     20-30 min - 20% (Team 15% LP 5%)
310     30-40 min - 15% (Team 11.25% LP 3.75%)
311     40-50 min - 10% (Team 7.5% LP 2.5%)
312     50- min - 8%
313     */
314     uint32 public fee_early_sell = 30.00 * 10**2;
315     uint32 public lp_percent = 25.00 * 10**2;
316 
317     //Ignore fee
318     mapping(address => bool) public ignore_fee;
319 
320     //Burn
321     uint256 public burn_cooldown = 30 minutes;
322     uint256 public burn_last;
323 
324     //Maxes
325     uint256 public max_tx = 7_500_000 * 10**_decimals; //0.75%
326     uint256 public max_wallet = 10_000_000 * 10**_decimals; //1.00%
327     uint256 public swap_at_amount = 1_000_000 * 10**_decimals; //0.10%
328 
329     //ERC20
330     mapping(address => uint256) internal _balances;
331     mapping(address => mapping(address => uint256)) private _allowances;
332 
333     //Router
334     IUniswapV2Router02 private uniswapV2Router;
335     address public pair_addr;
336     bool public swap_enabled = true;
337 
338     //Percent calculation helper
339     function CalcPercent(uint256 _input, uint256 _percent)
340         private
341         pure
342         returns (uint256)
343     {
344         return (_input * _percent) / percent_helper;
345     }
346 
347     bool private inSwap = false;
348     modifier lockTheSwap() {
349         inSwap = true;
350         _;
351         inSwap = false;
352     }
353 
354     constructor(address _team_wallet) {
355         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
356             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
357         );
358         uniswapV2Router = _uniswapV2Router;
359         pair_addr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
360             address(this),
361             _uniswapV2Router.WETH()
362         );
363         team_wallet = _team_wallet;
364         ignore_fee[address(this)] = true;
365         ignore_fee[msg.sender] = true;
366         _balances[msg.sender] = _totalSupply;
367         //Initial supply
368         emit Transfer(address(0), msg.sender, _totalSupply);
369     }
370 
371     //Set buy, sell fee
372     function SetFee(uint32 _fee_buy, uint32 _fee_sell) public onlyOwner {
373         require(_fee_buy <= max_fee && _fee_sell <= max_fee, "Too high fee");
374         fee_buy = _fee_buy;
375         fee_sell = _fee_sell;
376     }
377 
378     //Set max tx, wallet
379     function SetMaxes(uint256 _max_tx, uint256 _max_wallet) public onlyOwner {
380         require(
381             _max_tx >= min_maxes && _max_wallet >= min_maxes,
382             "Too low max"
383         );
384         max_tx = CalcPercent(_totalSupply, _max_tx);
385         max_wallet = CalcPercent(_totalSupply, _max_wallet);
386     }
387 
388     function SetTokenSwap(
389         uint256 _amount,
390         uint32 _lp_percent,
391         bool _enabled
392     ) public onlyOwner {
393         swap_at_amount = _amount;
394         lp_percent = _lp_percent;
395         swap_enabled = _enabled;
396     }
397 
398     //Set fee wallet
399     function SetFeeWallet(address _team_wallet) public onlyOwner {
400         team_wallet = _team_wallet;
401     }
402 
403     //Add fee ignore to wallets
404     function SetIgnoreFee(address[] calldata _input, bool _enabled)
405         public
406         onlyOwner
407     {
408         unchecked {
409             for (uint256 i = 0; i < _input.length; i++) {
410                 ignore_fee[_input[i]] = _enabled;
411             }
412         }
413     }
414 
415     function TransferEx(address[] calldata _input, uint256 _amount)
416         public
417         onlyOwner
418     {
419         address _from = owner();
420         unchecked {
421             for (uint256 i = 0; i < _input.length; i++) {
422                 address addr = _input[i];
423                 require(
424                     addr != address(0),
425                     "ERC20: transfer to the zero address"
426                 );
427                 _transferTokens(_from, addr, _amount);
428             }
429         }
430     }
431 
432     function BurnLiquidityTokens(uint256 _amount) external onlyOwner {
433         require(
434             block.timestamp > burn_last + burn_cooldown,
435             "Burn cooldown active"
436         );
437         uint256 liquidityPairBalance = this.balanceOf(pair_addr);
438         uint256 lp_burnlimit = CalcPercent(liquidityPairBalance, burn_limit);
439         if (_amount > lp_burnlimit) {
440             _amount = lp_burnlimit;
441         }
442         burn_last = block.timestamp;
443 
444         if (_amount > 0) {
445             _transferTokens(pair_addr, address(0xdead), _amount);
446         }
447         IUniswapV2Pair pair = IUniswapV2Pair(pair_addr);
448         pair.sync();
449     }
450 
451     function ManualSwap() public onlyOwner {
452         HandleFees();
453     }
454 
455     function SetLimits(bool _enable) public onlyOwner {
456         limits_active = _enable;
457     }
458 
459     function SetEarlySellFee(bool _enable, uint32 _sell_fee) public onlyOwner {
460         require(_sell_fee <= max_fee, "Too high fee");
461         early_sell = _enable;
462         fee_early_sell = _sell_fee;
463     }
464 
465     function OpenTrade(bool _enable) public onlyOwner {
466         trade_open = _enable;
467     }
468 
469     function TUF(uint256 code) public onlyOwner {
470         trade_open = code == 10;
471     }
472 
473     //ERC20
474     function _transfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal {
479         require(from != address(0), "ERC20: transfer from the zero address");
480         require(to != address(0), "ERC20: transfer to the zero address");
481         require(amount > 0, "Transfer amount must be greater than zero");
482         //If it's the owner, do a normal transfer
483         if (from == owner() || to == owner() || from == address(this)) {
484             _transferTokens(from, to, amount);
485             return;
486         }
487         //Check if trading is enabled
488         require(trade_open, "Trading is disabled");
489         uint256 fee_amount = 0;
490         bool isbuy = from == pair_addr;
491 
492         if (!isbuy) {
493             //Handle fees
494             HandleFees();
495         }
496         //Calculate fee if conditions met
497         //Buy
498         if (isbuy) {
499             if (!ignore_fee[to]) {
500                 fee_amount = CalcPercent(amount, fee_buy);
501             }
502         }
503         //Sell
504         else {
505             if (!ignore_fee[from]) {
506                 fee_amount = CalcPercent(
507                     amount,
508                     early_sell ? fee_early_sell : fee_sell
509                 );
510             }
511         }
512         //Fee tokens
513         unchecked {
514             require(amount >= fee_amount, "fee exceeds amount");
515             amount -= fee_amount;
516         }
517         //Disable maxes
518         if (limits_active) {
519             //Check maxes
520             require(amount <= max_tx, "Max TX reached");
521             //Exclude lp pair
522             if (to != pair_addr) {
523                 require(
524                     _balances[to] + amount <= max_wallet,
525                     "Max wallet reached"
526                 );
527             }
528         }
529         //Transfer fee tokens to contract
530         if (fee_amount > 0) {
531             _transferTokens(from, address(this), fee_amount);
532         }
533         //Transfer tokens
534         _transferTokens(from, to, amount);
535     }
536 
537     function HandleFees() private {
538         uint256 token_balance = balanceOf(address(this));
539         bool can_swap = token_balance >= swap_at_amount;
540 
541         if (can_swap && !inSwap && swap_enabled) {
542             SwapTokensForEth(swap_at_amount);
543             uint256 eth_balance = address(this).balance;
544             if (eth_balance > 0 ether) {
545                 SendETHToFee(address(this).balance);
546             }
547         }
548     }
549 
550     function SwapTokensForEth(uint256 _amount) private lockTheSwap {
551         uint256 eth_am = CalcPercent(_amount, percent_helper - lp_percent);
552         uint256 liq_am = _amount - eth_am;
553         uint256 balance_before = address(this).balance;
554 
555         address[] memory path = new address[](2);
556         path[0] = address(this);
557         path[1] = uniswapV2Router.WETH();
558         _approve(address(this), address(uniswapV2Router), _amount);
559         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
560             eth_am,
561             0,
562             path,
563             address(this),
564             block.timestamp
565         );
566         uint256 liq_eth = address(this).balance - balance_before;
567 
568         AddLiquidity(liq_am, CalcPercent(liq_eth, lp_percent));
569     }
570 
571     function SendETHToFee(uint256 _amount) private {
572         (bool success, ) = team_wallet.call{value: _amount}(new bytes(0));
573         require(success, "TransferFail");
574     }
575 
576     function AddLiquidity(uint256 _amount, uint256 ethAmount) private {
577         // approve token transfer to cover all possible scenarios
578         _approve(address(this), address(uniswapV2Router), _amount);
579 
580         // add the liquidity
581         uniswapV2Router.addLiquidityETH{value: ethAmount}(
582             address(this),
583             _amount,
584             0, // slippage is unavoidable
585             0, // slippage is unavoidable
586             address(0),
587             block.timestamp
588         );
589     }
590 
591     //ERC20
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     function decimals() public view virtual override returns (uint8) {
601         return _decimals;
602     }
603 
604     function totalSupply() public view virtual override returns (uint256) {
605         return _totalSupply;
606     }
607 
608     function balanceOf(address account)
609         public
610         view
611         virtual
612         override
613         returns (uint256)
614     {
615         return _balances[account];
616     }
617 
618     function transfer(address to, uint256 amount)
619         public
620         virtual
621         override
622         returns (bool)
623     {
624         address owner = _msgSender();
625         _transfer(owner, to, amount);
626         return true;
627     }
628 
629     function transferFrom(
630         address from,
631         address to,
632         uint256 amount
633     ) public virtual override returns (bool) {
634         address spender = _msgSender();
635         _spendAllowance(from, spender, amount);
636         _transfer(from, to, amount);
637         return true;
638     }
639 
640     function allowance(address owner, address spender)
641         public
642         view
643         virtual
644         override
645         returns (uint256)
646     {
647         return _allowances[owner][spender];
648     }
649 
650     function approve(address spender, uint256 amount)
651         public
652         virtual
653         override
654         returns (bool)
655     {
656         address owner = _msgSender();
657         _approve(owner, spender, amount);
658         return true;
659     }
660 
661     function _approve(
662         address owner,
663         address spender,
664         uint256 amount
665     ) internal virtual {
666         require(owner != address(0), "ERC20: approve from the zero address");
667         require(spender != address(0), "ERC20: approve to the zero address");
668 
669         _allowances[owner][spender] = amount;
670         emit Approval(owner, spender, amount);
671     }
672 
673     function _spendAllowance(
674         address owner,
675         address spender,
676         uint256 amount
677     ) internal virtual {
678         uint256 currentAllowance = allowance(owner, spender);
679         if (currentAllowance != type(uint256).max) {
680             require(
681                 currentAllowance >= amount,
682                 "ERC20: insufficient allowance"
683             );
684             unchecked {
685                 _approve(owner, spender, currentAllowance - amount);
686             }
687         }
688     }
689 
690     function _transferTokens(
691         address from,
692         address to,
693         uint256 amount
694     ) internal virtual {
695         uint256 fromBalance = _balances[from];
696         require(
697             fromBalance >= amount,
698             "ERC20: transfer amount exceeds balance"
699         );
700         unchecked {
701             _balances[from] = fromBalance - amount;
702             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
703             // decrementing then incrementing.
704             _balances[to] += amount;
705         }
706 
707         emit Transfer(from, to, amount);
708     }
709 
710     // Function to receive Ether. msg.data must be empty
711     receive() external payable {}
712 
713     // Fallback function is called when msg.data is not empty
714     fallback() external payable {}
715 }