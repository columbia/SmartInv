1 //SPDX-License-Identifier: Unlicense
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 pragma solidity >=0.6.2;
29 
30 interface IUniswapV2Router01 {
31     function factory() external pure returns (address);
32     function WETH() external pure returns (address);
33 
34     function addLiquidity(
35         address tokenA,
36         address tokenB,
37         uint amountADesired,
38         uint amountBDesired,
39         uint amountAMin,
40         uint amountBMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountA, uint amountB, uint liquidity);
44     function addLiquidityETH(
45         address token,
46         uint amountTokenDesired,
47         uint amountTokenMin,
48         uint amountETHMin,
49         address to,
50         uint deadline
51     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
52     function removeLiquidity(
53         address tokenA,
54         address tokenB,
55         uint liquidity,
56         uint amountAMin,
57         uint amountBMin,
58         address to,
59         uint deadline
60     ) external returns (uint amountA, uint amountB);
61     function removeLiquidityETH(
62         address token,
63         uint liquidity,
64         uint amountTokenMin,
65         uint amountETHMin,
66         address to,
67         uint deadline
68     ) external returns (uint amountToken, uint amountETH);
69     function removeLiquidityWithPermit(
70         address tokenA,
71         address tokenB,
72         uint liquidity,
73         uint amountAMin,
74         uint amountBMin,
75         address to,
76         uint deadline,
77         bool approveMax, uint8 v, bytes32 r, bytes32 s
78     ) external returns (uint amountA, uint amountB);
79     function removeLiquidityETHWithPermit(
80         address token,
81         uint liquidity,
82         uint amountTokenMin,
83         uint amountETHMin,
84         address to,
85         uint deadline,
86         bool approveMax, uint8 v, bytes32 r, bytes32 s
87     ) external returns (uint amountToken, uint amountETH);
88     function swapExactTokensForTokens(
89         uint amountIn,
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external returns (uint[] memory amounts);
95     function swapTokensForExactTokens(
96         uint amountOut,
97         uint amountInMax,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external returns (uint[] memory amounts);
102     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
103         external
104         payable
105         returns (uint[] memory amounts);
106     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
107         external
108         returns (uint[] memory amounts);
109     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
110         external
111         returns (uint[] memory amounts);
112     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
113         external
114         payable
115         returns (uint[] memory amounts);
116 
117     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
118     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
119     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
120     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
121     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
122 }
123 
124 
125 pragma solidity >=0.6.2;
126 
127 interface IUniswapV2Router02 is IUniswapV2Router01 {
128     function removeLiquidityETHSupportingFeeOnTransferTokens(
129         address token,
130         uint liquidity,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external returns (uint amountETH);
136     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountETH);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153     function swapExactETHForTokensSupportingFeeOnTransferTokens(
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external payable;
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166 }
167 
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Interface of the ERC20 standard as defined in the EIP.
173  */
174 interface IERC20 {
175     /**
176      * @dev Returns the amount of tokens in existence.
177      */
178     function totalSupply() external view returns (uint256);
179 
180     /**
181      * @dev Returns the amount of tokens owned by `account`.
182      */
183     function balanceOf(address account) external view returns (uint256);
184 
185     /**
186      * @dev Moves `amount` tokens from the caller's account to `to`.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transfer(address to, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Returns the remaining number of tokens that `spender` will be
196      * allowed to spend on behalf of `owner` through {transferFrom}. This is
197      * zero by default.
198      *
199      * This value changes when {approve} or {transferFrom} are called.
200      */
201     function allowance(address owner, address spender) external view returns (uint256);
202 
203     /**
204      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * IMPORTANT: Beware that changing an allowance with this method brings the risk
209      * that someone may use both the old and the new allowance by unfortunate
210      * transaction ordering. One possible solution to mitigate this race
211      * condition is to first reduce the spender's allowance to 0 and set the
212      * desired value afterwards:
213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address spender, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Moves `amount` tokens from `from` to `to` using the
221      * allowance mechanism. `amount` is then deducted from the caller's
222      * allowance.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(
229         address from,
230         address to,
231         uint256 amount
232     ) external returns (bool);
233 
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 
249 
250 pragma solidity ^0.8.0;
251 interface IStakable {
252 	function stakedBalanceOf(address account) external view returns (uint256);
253     function getStake(address account) external view returns (uint256, uint256, uint256);
254     function stake(address account, uint256 amount, uint256 unstakeTime, bool isPlayer, uint256 adjustedStake) external;
255     function unstake(address account, uint256 unstakeAmount, bool isPlayer, uint256 adjustedStake) external;
256     function sync(address account, uint256 adjustedStake) external;
257     function toggleStaking() external;
258     event Stake(address indexed staker, uint256 amount, uint256 stakeTime, uint256 stakeExpire);
259     event Unstake(address indexed staker, uint256 amount, uint256 stakeAmountRemaining);
260     event Adjust(address indexed staker, uint256 oldStake, uint256 newStake);
261     event ToggleStaking(bool enabled);
262 }
263 
264 
265 pragma solidity ^0.8.0;
266 
267 
268 interface IBattleFish is IERC20, IStakable {
269 	event ChangeBuyTax(uint256 prevTax, uint256 newTax);
270     event ChangeSellTax(uint256 prevTax, uint256 newTax);
271     event ChangeRewards(uint256 prevRew, uint256 newRew);
272     event SetStakingContract(address stakingCon);
273     event SetPool(address isNowPool);
274     event FailsafeTokenSwap(uint256 amount);
275     event FailsafeETHTransfer(uint256 amount);
276     event FreezeMint(uint256 mintLockTime);
277     event ThawMint(uint256 mintLockTime);
278 
279     function freezeMint(uint256 timestamp) external;
280     function thawMint() external;
281     function mint(uint256 amount, address recipient) external;
282     function setStakingContract(address addr) external;
283     function getStakingContract() external view returns (address);
284     function setBuyTax(uint8 newTax) external;
285     function setSellTax(uint8 newTax) external;
286     function setRewards(uint8 newRewards) external;
287     function setPool(address addr) external;
288     function isPool(address addr) external view returns (bool);
289     function failsafeTokenSwap(uint256 amount) external;
290     function failsafeETHtransfer() external;
291 }
292 
293 pragma solidity ^0.8.0;
294 
295 contract BattleFish is IBattleFish, Context {
296     /**
297      * =====================
298      * =====================
299      * =====           =====
300      * ===== Variables =====
301      * =====           =====
302      * =====================
303      * =====================
304      */
305     
306     // Fair Launch
307     bool private _trading; // Trading stage, used for fair launch
308     uint256 private _timeWalletQuantityLimit = 2000000000;
309     uint256 private _timeTxCountLimit = 2000000000;
310     uint256 private _gasLimit;
311     mapping (address => bool) private _oneTx;
312     mapping (address => uint256) private _buyCounter;
313 
314     // States
315     bool private _swapping;
316     bool public stakingEnabled = false;
317     bool public mintLocked = true;
318     uint public mintLockTime = 1651438800;
319 
320     // Mappings
321     mapping (address => bool) private _isPool;
322     mapping (address => uint256) private _balances;
323     mapping (address => uint256) private _stakedBalances;
324     mapping (address => uint256) private _stakeExpireTime;
325     mapping (address => uint256) private _stakeBeginTime;
326     mapping (address => mapping (address => uint256)) private _allowances;
327 
328     // ERC20
329     uint256 private _totalSupply = 10 * 10**6 * 10**9; 
330     string private constant _name = "Battle.Fish";
331     string private constant _symbol = "$BATTLE";
332     uint8 private constant _decimals = 9;
333 
334     // Tax and staking
335     uint8 private _buyTax = 10;
336     uint8 private _sellTax = 10;
337     uint8 private _stakingRewards = 20;
338 
339     // Addresses
340     address immutable private _lp;
341     address payable immutable private _vault;
342     address payable immutable private _multiSig;
343     address payable private _stakingContract;
344     address private constant _uniRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
345     IUniswapV2Router02 private UniV2Router;
346 
347     constructor(address vault, address multiSig) {
348         require(vault != address(0) && multiSig != address(0), "$BATTLE: cannot assign privilege to zero address");
349         _lp = multiSig;
350         _balances[multiSig] = _totalSupply;
351         UniV2Router = IUniswapV2Router02(_uniRouter);
352         _vault = payable(vault);
353         _multiSig = payable(multiSig);
354     }
355 
356     modifier onlyMultiSig {
357         require (_msgSender() == _multiSig, "$BATTLE: unauthorized");
358         _;
359     }
360 
361     modifier lockSwap {
362         _swapping = true;
363         _;
364         _swapping = false;
365     }
366 
367     /**
368      * =====================
369      * =====================
370      * =====           =====
371      * =====   ERC20   =====
372      * =====           =====
373      * =====================
374      * =====================
375      */
376     function name() external pure returns (string memory) {
377         return _name;
378     }
379 
380     function symbol() external pure returns (string memory) {
381         return _symbol;
382     }
383 
384     function decimals() external pure returns (uint8) {
385         return _decimals;
386     }
387 
388     function totalSupply() external view override returns (uint256) {
389         return _totalSupply;
390     }
391 
392     function balanceOf(address account) public view override returns (uint256) {
393         return _balances[account];
394     }
395 
396     function transfer(address recipient, uint256 amount) external override returns (bool) {
397         _transfer(_msgSender(), recipient, amount);
398         return true;
399     }
400 
401     function allowance(address owner, address spender) external view override returns (uint256) {
402         return _allowances[owner][spender];
403     }
404 
405     function approve(address spender, uint256 amount) external override returns (bool) {
406         _approve(_msgSender(), spender, amount);
407         return true;
408     }
409 
410     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
411         require (_allowances[sender][_msgSender()] >= amount, "ERC20: transfer amount exceeds allowance");
412         _transfer(sender, recipient, amount);
413         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
414         return true;
415     }
416 
417     function _approve(address owner, address spender, uint256 amount) private {
418         require(owner != address(0), "ERC20: approve from the zero address");
419         require(spender != address(0), "ERC20: approve to the zero address");
420 
421         _allowances[owner][spender] = amount;
422         emit Approval(owner, spender, amount);
423     }
424 
425     function _transfer(address sender, address recipient, uint256 amount) private {
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428         require(_balances[sender] >= amount, "ERC20: transfer exceeds balance");
429         require(amount > 0, "$BATTLE: cannot transfer zero");
430         require(!(_isPool[sender] && _isPool[recipient]), "$BATTLE: cannot transfer pool to pool");
431 
432         if (!_trading) {
433             require(sender == _lp, "$BATTLE: trading disabled");
434         }
435         
436         unchecked {
437             _balances[sender] -= amount;
438         }
439 
440         uint256 taxedAmount = amount;
441         uint256 tax = 0;
442     
443         if (_isPool[sender] == true && recipient != _lp && recipient != _uniRouter) {
444             tax = amount * _buyTax / 100;
445             taxedAmount = amount - tax;
446             _balances[address(this)] += tax;
447             if (block.timestamp < _timeTxCountLimit) {
448                 require(tx.gasprice <= _gasLimit || sender == _lp, "$BATTLE: excessive gas");
449                 require(!_oneTx[tx.origin], "$BATTLE: transaction count limit");
450                 _buyCounter[tx.origin] += taxedAmount;
451                 _oneTx[tx.origin] = true;
452             }
453             if (block.timestamp < _timeWalletQuantityLimit) {
454                 require((_balances[recipient] + taxedAmount) <= 50000000000000, "$BATTLE: exceeds wallet limit");
455             }
456         }
457         if (_isPool[recipient] == true && sender != _lp && sender != _uniRouter){ 
458             tax = amount * _sellTax / 100;
459             taxedAmount = amount - tax;
460             _balances[address(this)] += tax;
461 
462             if (_balances[address(this)] > 100 * 10**9 && !_swapping) {
463                 uint256 _swapAmount = _balances[address(this)];
464                 if (_swapAmount > amount * 40 / 100) _swapAmount = amount * 40 / 100;
465                 _tokensToETH(_swapAmount);
466             }
467         }
468     
469         _balances[recipient] += taxedAmount;
470 
471         emit Transfer(sender, recipient, amount);
472     }
473 
474     /**
475      * =====================
476      * =====================
477      * =====           =====
478      * =====  Staking  =====
479      * =====           =====
480      * =====================
481      * =====================
482      */
483     function stakedBalanceOf(address account) external view override returns (uint256) {
484         return _stakedBalances[account];    
485     }
486 
487     function getStake(address account) external view override returns (uint256, uint256, uint256) {
488         if (stakingEnabled && _stakedBalances[account] > 0)
489             return (_stakedBalances[account], _stakeBeginTime[account], _stakeExpireTime[account]);
490         else return (0,0,0);
491     }
492 
493     function stake(address account, uint256 amount, uint256 unstakeTime, bool isPlayer, uint256 adjustedStake) external override {
494         require (_msgSender() == _stakingContract, "$BATTLE: must stake through staking contract");
495         require (account != address(0), "$BATTLE: cannot stake zero address");
496         require (stakingEnabled, "$BATTLE: staking currently not enabled"); 
497 
498         if (isPlayer)
499         { 
500             if (_stakedBalances[account] != adjustedStake){
501                 emit Adjust(account, _stakedBalances[account], adjustedStake);
502                 _stakedBalances[account] = adjustedStake;
503             }
504         }
505 
506         require (unstakeTime > (block.timestamp + 86100),"$BATTLE: minimum stake time 23 hours 55 min"); 
507         require (unstakeTime >= _stakeExpireTime[account], "$BATTLE: new stake time cannot be shorter");
508         require (_balances[account] >= amount, "$BATTLE: stake exceeds available balance");
509         if (_stakedBalances[account] == 0) require (amount > 0, "$BATTLE: cannot stake 0 tokens");
510 
511         _balances[account] = _balances[account] - amount;
512         _balances[_stakingContract] = _balances[_stakingContract] + amount;
513         _stakedBalances[account] = _stakedBalances[account] + amount;
514 
515         _stakeExpireTime[account] = unstakeTime;
516         _stakeBeginTime[account] = block.timestamp;
517 
518         emit Stake(account, amount, block.timestamp, unstakeTime);
519     }
520 
521     function unstake(address account, uint256 unstakeAmount, bool isPlayer, uint256 adjustedStake) external override {
522         require (_msgSender() == _stakingContract, "$BATTLE: must unstake through staking contract");
523         require (account != address(0), "$BATTLE: cannot unstake zero address");
524         require(unstakeAmount > 0, "$BATTLE: cannot unstake zero tokens");
525 
526         if (isPlayer)
527         { 
528             if (_stakedBalances[account] != adjustedStake){
529                 emit Adjust(account, _stakedBalances[account], adjustedStake);
530                 _stakedBalances[account] = adjustedStake;
531             }
532         }
533 
534         require(unstakeAmount <= _stakedBalances[account], "$BATTLE: unstake exceeds staked balance");
535         
536         _stakedBalances[account] = _stakedBalances[account] - unstakeAmount;
537         _balances[account] = _balances[account] + unstakeAmount;
538         _balances[_stakingContract] = _balances[_stakingContract] - unstakeAmount;
539         
540         emit Unstake(account, unstakeAmount, _stakedBalances[account]);
541     }
542 
543     function sync(address account, uint256 adjustedStake) external override {
544         require (_msgSender() == _stakingContract, "$BATTLE: unauthorized");
545         require (account != address(0), "$BATTLE: cannot sync zero address");
546         emit Adjust(account, _stakedBalances[account], adjustedStake);
547         _stakedBalances[account] = adjustedStake;
548     }
549 
550     function toggleStaking() external override onlyMultiSig {
551         require (_stakingContract != address(0), "$BATTLE: staking contract not set");
552         if (stakingEnabled == true) stakingEnabled = false;
553         else stakingEnabled = true;
554         emit ToggleStaking(stakingEnabled);
555     }
556 
557     function setStakingContract(address addr) external override onlyMultiSig {
558         require(addr != address(0), "$BATTLE: cannot be zero address");
559         _stakingContract = payable(addr);
560         emit SetStakingContract(addr);
561     }
562 
563     function getStakingContract() external view override returns (address) {
564         return _stakingContract;
565     }
566 
567     /**
568      * =====================
569      * =====================
570      * =====           =====
571      * =====  Minting  =====
572      * =====           =====
573      * =====================
574      * =====================
575      */
576     function freezeMint(uint256 timestamp) external override onlyMultiSig {
577         require (timestamp > mintLockTime, "$BATTLE: cannot reduce lock time");
578         mintLocked = true;
579         mintLockTime = timestamp;
580 
581         emit FreezeMint(mintLockTime);
582     }
583 
584     function thawMint() external override onlyMultiSig {
585         require (block.timestamp >= mintLockTime, "$BATTLE: still frozen");
586         mintLocked = false;
587         mintLockTime = block.timestamp + 86400;
588 
589         emit ThawMint(mintLockTime);
590     } 
591 
592     function mint(uint256 amount, address recipient) external override onlyMultiSig {
593         require (block.timestamp > mintLockTime && mintLocked == false, "$BATTLE: still frozen");
594         _totalSupply = _totalSupply + amount;
595         _balances[recipient] = _balances[recipient] + amount;
596 
597         emit Transfer(address(0), recipient, amount);
598     }
599     
600     /**
601      * =====================
602      * =====================
603      * =====           =====
604      * =====    Tax    =====
605      * =====           =====
606      * =====================
607      * =====================
608      */
609     function setBuyTax(uint8 newTax) external override onlyMultiSig {
610         require (newTax <= 10, "$BATTLE: tax cannot exceed 10%");
611         emit ChangeBuyTax(_buyTax, newTax);
612         _buyTax = newTax;
613     }
614 
615     function setSellTax(uint8 newTax) external override onlyMultiSig {
616         require (newTax <= 10, "$BATTLE: tax cannot exceed 10%");
617         emit ChangeSellTax(_sellTax, newTax);
618         _sellTax = newTax;
619     }
620 
621     function setRewards(uint8 newRewards) external override onlyMultiSig {
622         require (newRewards >= 20, "$BATTLE: rewards minimum 20%");
623         require (newRewards <= 100, "$BATTLE: rewards maximum 100%");
624         emit ChangeRewards(_stakingRewards, newRewards);
625         _stakingRewards = newRewards;
626     }
627 
628     function setPool(address addr) external override onlyMultiSig {
629         require(addr != address(0), "$BATTLE: zero address cannot be pool");
630         _isPool[addr] = true;
631         emit SetPool(addr);
632     }
633     
634     function isPool(address addr) external view override returns (bool){
635         return _isPool[addr];
636     }
637 
638      /**
639      * =====================
640      * =====================
641      * =====           =====
642      * =====  Utility  =====
643      * =====           =====
644      * =====================
645      * =====================
646      */
647     function _transferETH(uint256 amount, address payable _to) private {
648         (bool sent,) = _to.call{value: amount}("");
649         require(sent, "Failed to send Ether");
650     }
651 
652     function _tokensToETH(uint256 amount) private lockSwap {
653         address[] memory path = new address[](2);
654         path[0] = address(this);
655         path[1] = UniV2Router.WETH();
656 
657         _approve(address(this), _uniRouter, amount);
658         UniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp);
659 
660         if (address(this).balance > 0) 
661         {
662             if (stakingEnabled) {
663                 uint stakingShare = address(this).balance * _stakingRewards / 100;
664                 _transferETH(stakingShare, _stakingContract);
665             }
666             _transferETH(address(this).balance, _vault);
667         }
668     }
669     
670     function failsafeTokenSwap(uint256 amount) external override onlyMultiSig {
671         _tokensToETH(amount);
672         emit FailsafeTokenSwap(amount);
673     }
674 
675     function failsafeETHtransfer() external override onlyMultiSig {
676         emit FailsafeETHTransfer(address(this).balance);
677         (bool sent,) = _msgSender().call{value: address(this).balance}("");
678         require(sent, "Failed to send Ether");
679     }
680 
681     function timeToBattle(uint256 gasLimit) external onlyMultiSig {
682         require(!_trading, "$BATTLE: trading already enabled");
683         _trading = true;
684         _timeWalletQuantityLimit = block.timestamp + 30 minutes;
685         _timeTxCountLimit = block.timestamp + 5 minutes;
686         _gasLimit = gasLimit;
687     }
688 
689     receive() external payable {}
690 
691     fallback() external payable {}
692 }