1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.12;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         _checkOwner();
33         _;
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if the sender is not the owner.
45      */
46     function _checkOwner() internal view virtual {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48     }
49 
50     /**
51      * @dev Leaves the contract without owner. It will not be possible to call
52      * `onlyOwner` functions. Can only be called by the current owner.
53      *
54      * NOTE: Renouncing ownership will leave the contract without an owner,
55      * thereby disabling any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Internal function without access restriction.
73      */
74     function _transferOwnership(address newOwner) internal virtual {
75         address oldOwner = _owner;
76         _owner = newOwner;
77         emit OwnershipTransferred(oldOwner, newOwner);
78     }
79 }
80 
81 interface IERC20 {
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `to`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address to, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `from` to `to` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address from, address to, uint256 amount) external returns (bool);
165 }
166 
167 contract ERC20 is Context, IERC20 {
168     mapping(address => uint256) private _balances;
169 
170     mapping(address => mapping(address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * All two of these values are immutable: they can only be set once during
181      * construction.
182      */
183     constructor(string memory name_, string memory symbol_) {
184         _name = name_;
185         _symbol = symbol_;
186     }
187 
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() public view virtual override returns (string memory) {
192         return _name;
193     }
194 
195     /**
196      * @dev Returns the symbol of the token, usually a shorter version of the
197      * name.
198      */
199     function symbol() public view virtual override returns (string memory) {
200         return _symbol;
201     }
202 
203     /**
204      * @dev Returns the number of decimals used to get its user representation.
205      * For example, if `decimals` equals `2`, a balance of `505` tokens should
206      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
207      *
208      * Tokens usually opt for a value of 18, imitating the relationship between
209      * Ether and Wei. This is the default value returned by this function, unless
210      * it's overridden.
211      *
212      * NOTE: This information is only used for _display_ purposes: it in
213      * no way affects any of the arithmetic of the contract, including
214      * {IERC20-balanceOf} and {IERC20-transfer}.
215      */
216     function decimals() public view virtual override returns (uint8) {
217         return 18;
218     }
219 
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view virtual override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See {IERC20-balanceOf}.
229      */
230     function balanceOf(address account) public view virtual override returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See {IERC20-transfer}.
236      *
237      * Requirements:
238      *
239      * - `to` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address to, uint256 amount) public virtual override returns (bool) {
243         address owner = _msgSender();
244         _transfer(owner, to, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-allowance}.
250      */
251     function allowance(address owner, address spender) public view virtual override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     /**
256      * @dev See {IERC20-approve}.
257      *
258      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
259      * `transferFrom`. This is semantically equivalent to an infinite approval.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         address owner = _msgSender();
267         _approve(owner, spender, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-transferFrom}.
273      *
274      * Emits an {Approval} event indicating the updated allowance. This is not
275      * required by the EIP. See the note at the beginning of {ERC20}.
276      *
277      * NOTE: Does not update the allowance if the current allowance
278      * is the maximum `uint256`.
279      *
280      * Requirements:
281      *
282      * - `from` and `to` cannot be the zero address.
283      * - `from` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``from``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
288         address spender = _msgSender();
289         _spendAllowance(from, spender, amount);
290         _transfer(from, to, amount);
291         return true;
292     }
293 
294     /**
295      * @dev Atomically increases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
307         address owner = _msgSender();
308         _approve(owner, spender, allowance(owner, spender) + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         address owner = _msgSender();
328         uint256 currentAllowance = allowance(owner, spender);
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330         unchecked {
331             _approve(owner, spender, currentAllowance - subtractedValue);
332         }
333 
334         return true;
335     }
336 
337     /**
338      * @dev Moves `amount` of tokens from `from` to `to`.
339      *
340      * This internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `from` cannot be the zero address.
348      * - `to` cannot be the zero address.
349      * - `from` must have a balance of at least `amount`.
350      */
351     function _transfer(address from, address to, uint256 amount) internal virtual {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354 
355         _beforeTokenTransfer(from, to, amount);
356 
357         uint256 fromBalance = _balances[from];
358         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
359         unchecked {
360             _balances[from] = fromBalance - amount;
361             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
362             // decrementing then incrementing.
363             _balances[to] += amount;
364         }
365 
366         emit Transfer(from, to, amount);
367 
368         _afterTokenTransfer(from, to, amount);
369     }
370 
371     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
372      * the total supply.
373      *
374      * Emits a {Transfer} event with `from` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      */
380     function _mint(address account, uint256 amount) internal virtual {
381         require(account != address(0), "ERC20: mint to the zero address");
382 
383         _beforeTokenTransfer(address(0), account, amount);
384 
385         _totalSupply += amount;
386         unchecked {
387             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
388             _balances[account] += amount;
389         }
390         emit Transfer(address(0), account, amount);
391 
392         _afterTokenTransfer(address(0), account, amount);
393     }
394 
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: burn from the zero address");
408 
409         _beforeTokenTransfer(account, address(0), amount);
410 
411         uint256 accountBalance = _balances[account];
412         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
413         unchecked {
414             _balances[account] = accountBalance - amount;
415             // Overflow not possible: amount <= accountBalance <= totalSupply.
416             _totalSupply -= amount;
417         }
418 
419         emit Transfer(account, address(0), amount);
420 
421         _afterTokenTransfer(account, address(0), amount);
422     }
423 
424     /**
425      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
426      *
427      * This internal function is equivalent to `approve`, and can be used to
428      * e.g. set automatic allowances for certain subsystems, etc.
429      *
430      * Emits an {Approval} event.
431      *
432      * Requirements:
433      *
434      * - `owner` cannot be the zero address.
435      * - `spender` cannot be the zero address.
436      */
437     function _approve(address owner, address spender, uint256 amount) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440 
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444 
445     /**
446      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
447      *
448      * Does not update the allowance amount in case of infinite allowance.
449      * Revert if not enough allowance is available.
450      *
451      * Might emit an {Approval} event.
452      */
453     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
454         uint256 currentAllowance = allowance(owner, spender);
455         if (currentAllowance != type(uint256).max) {
456             require(currentAllowance >= amount, "ERC20: insufficient allowance");
457             unchecked {
458                 _approve(owner, spender, currentAllowance - amount);
459             }
460         }
461     }
462 
463     /**
464      * @dev Hook that is called before any transfer of tokens. This includes
465      * minting and burning.
466      *
467      * Calling conditions:
468      *
469      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
470      * will be transferred to `to`.
471      * - when `from` is zero, `amount` tokens will be minted for `to`.
472      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
473      * - `from` and `to` are never both zero.
474      *
475      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
476      */
477     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
494 }
495 
496 interface IUniswapV2Router01 {
497     function factory() external pure returns (address);
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint amountADesired,
504         uint amountBDesired,
505         uint amountAMin,
506         uint amountBMin,
507         address to,
508         uint deadline
509     ) external returns (uint amountA, uint amountB, uint liquidity);
510     function addLiquidityETH(
511         address token,
512         uint amountTokenDesired,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
518     function removeLiquidity(
519         address tokenA,
520         address tokenB,
521         uint liquidity,
522         uint amountAMin,
523         uint amountBMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountA, uint amountB);
527     function removeLiquidityETH(
528         address token,
529         uint liquidity,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external returns (uint amountToken, uint amountETH);
535     function removeLiquidityWithPermit(
536         address tokenA,
537         address tokenB,
538         uint liquidity,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline,
543         bool approveMax, uint8 v, bytes32 r, bytes32 s
544     ) external returns (uint amountA, uint amountB);
545     function removeLiquidityETHWithPermit(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline,
552         bool approveMax, uint8 v, bytes32 r, bytes32 s
553     ) external returns (uint amountToken, uint amountETH);
554     function swapExactTokensForTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external returns (uint[] memory amounts);
561     function swapTokensForExactTokens(
562         uint amountOut,
563         uint amountInMax,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external returns (uint[] memory amounts);
568     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
569         external
570         payable
571         returns (uint[] memory amounts);
572     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
573         external
574         returns (uint[] memory amounts);
575     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
576         external
577         returns (uint[] memory amounts);
578     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
579         external
580         payable
581         returns (uint[] memory amounts);
582 
583     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
584     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
585     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
586     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
587     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
588 }
589 
590 
591 interface IUniswapV2Router02 is IUniswapV2Router01 {
592     function removeLiquidityETHSupportingFeeOnTransferTokens(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountETH);
600     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountETH);
609 
610     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external;
617     function swapExactETHForTokensSupportingFeeOnTransferTokens(
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external payable;
623     function swapExactTokensForETHSupportingFeeOnTransferTokens(
624         uint amountIn,
625         uint amountOutMin,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external;
630 }
631 
632 contract DexBot is Ownable, ERC20 {
633 
634     address public constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
635 
636     IUniswapV2Router02 public immutable uniswapV2Router;
637 
638     bool swapping;
639     bool public exchangeable;
640     bool public transferable;
641     bool public maxLimited;
642     bool public botLimited;
643     address public team;
644     address public rewardPool;
645     address public burnAddress;
646     address public exToken;
647     uint256 public buyFeeRate;
648     uint256 public sellFeeRate;
649     uint256 public totalFeeAmount;
650     uint256 public swapAmount;
651     uint256 public swapShare;
652     uint256 public burnShare;
653     uint256 public teamShare;
654     uint256 public burnLimit;
655     uint256 public maxHoldingAmount;
656     mapping (address => mapping(address => uint256)) public balanceFromPool;
657     mapping (address => bool) public uniswapPool;
658     mapping (address => bool) public blacklist;
659     mapping (address => bool) public dutyFree;
660     mapping (address => uint256) public lastTradingBlock;
661 
662     event Exchanged(address indexed owner, uint256 indexed amount);
663     event SwapAmountSet(address indexed owner, uint256 indexed amount);
664     event TeamSet(address indexed owner, address indexed account);
665     event BurnAddressSet(address indexed owner, address indexed account);
666     event ShareSet(address indexed owner, uint256 swapShare, uint256 burnShare, uint256 teamShare);
667     event RewardPoolSet(address indexed owner, address indexed account);
668     event LimitSet(address indexed owner, bool indexed limited, uint256 indexed amount);
669     event PoolSet(address indexed owner, address indexed account, bool indexed value);
670     event DutyFreeSet(address indexed owner, address indexed account, bool indexed value);
671     event FeeRateSet(address indexed owner, uint256 indexed buyFeeRate, uint256 indexed sellFeeRate);
672     event BurnLimitSet(address indexed owner, uint256 burnLimit);
673     event BlacklistSet(address indexed owner, address[] accounts);
674     event BlacklistRemoved(address indexed owner, address[] accounts);
675 
676     constructor(address _token, uint256 _totalSupply) ERC20("DexBot", "DEXBOT") {
677         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
678        
679         exchangeable = true;
680         maxLimited = false;
681         botLimited = true;
682         swapping = false;
683 
684         swapAmount = (_totalSupply * 25) / 10000; 
685         maxHoldingAmount = _totalSupply;
686 
687         swapShare = 0.2 ether;
688         burnShare = 0.4 ether;
689         teamShare = 0.4 ether;
690 
691         burnLimit = _totalSupply / 10;
692 
693         buyFeeRate = 0.05 ether;
694         sellFeeRate = 0.05 ether;
695         
696         exToken = _token;
697         team = msg.sender;
698         burnAddress = msg.sender;
699 
700         dutyFree[msg.sender] = true;
701         dutyFree[address(this)] = true;
702 
703         _mint(msg.sender, _totalSupply);
704     }
705 
706     fallback() external payable {}
707 
708     receive() external payable {}
709 
710     function exchange(uint256 amount) external {
711         require(exchangeable, "non exchangeable");
712 
713         IERC20(exToken).transferFrom(msg.sender, DEAD_ADDRESS, amount);
714         IERC20(address(this)).transfer(msg.sender, amount);
715 
716         emit Exchanged(msg.sender, amount);
717     }
718 
719     function setExchangeable() external onlyOwner {
720         exchangeable = !exchangeable;
721     }
722 
723     function setTransferable() external onlyOwner {
724         transferable = !transferable;
725     }
726 
727     function withdrawToken(address token, address to) external onlyOwner {
728         require(token != address(0), "token address cannot be zero address");
729         uint256 balance = IERC20(token).balanceOf(address(this));
730         IERC20(token).transfer(to, balance);
731     }
732 
733     function withdrawEth(address to) external onlyOwner {
734         (bool success, ) = to.call{value: address(this).balance}(new bytes(0));
735         require(success, "eth transfer failed");
736     }
737 
738     function setMaxLimit(bool _limited, uint256 _amount) external onlyOwner {
739         maxLimited = _limited;
740         maxHoldingAmount = _amount;
741         emit LimitSet(msg.sender, maxLimited, maxHoldingAmount);
742     }
743 
744     function setBotLimited() external onlyOwner {
745         botLimited = !botLimited;
746     }
747 
748     function setPool(address account) external onlyOwner {
749         uniswapPool[account] = !uniswapPool[account];
750         emit PoolSet(msg.sender, account, uniswapPool[account]);
751     }
752 
753     function setTeam(address account) external onlyOwner {
754         dutyFree[team] = false;
755 
756         team = account;
757         dutyFree[team] = true;
758 
759         emit TeamSet(msg.sender, team);
760     }
761 
762     function setRewardPool(address account) external onlyOwner {
763         rewardPool = account;
764         emit RewardPoolSet(msg.sender, rewardPool);
765     }
766 
767     function setBurnAddress(address account) external onlyOwner {
768         burnAddress = account;
769         emit BurnAddressSet(msg.sender, burnAddress);
770     }
771 
772     function setDutyFree(address account) public onlyOwner {
773         dutyFree[account] = !dutyFree[account];
774         emit DutyFreeSet(msg.sender, account, dutyFree[account]);
775     }
776 
777     function setFeeRate(uint256 _buyFeeRate, uint256 _sellFeeRate) external onlyOwner {
778         buyFeeRate = _buyFeeRate;
779         sellFeeRate = _sellFeeRate;
780         emit FeeRateSet(msg.sender, _buyFeeRate, _sellFeeRate);
781     }
782 
783     function setBurnLimit(uint256 _burnLimit) external onlyOwner {
784         burnLimit = _burnLimit;
785         emit BurnLimitSet(msg.sender, _burnLimit);
786     }
787 
788     function setSwapAmount(uint256 _swapAmount) external onlyOwner {
789         swapAmount = _swapAmount;
790         emit SwapAmountSet(msg.sender, _swapAmount);
791     }
792 
793     function setShare(uint256 _swapShare, uint256 _burnShare, uint256 _teamShare) external onlyOwner {
794         uint256 totalShare = _swapShare+_burnShare+_teamShare;
795         require(totalShare == 1 ether, "forbid");
796         swapShare = _swapShare;
797         burnShare = _burnShare;
798         teamShare = _teamShare;
799         emit ShareSet(msg.sender, swapShare, burnShare, teamShare);
800     }
801 
802     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
803         require(!blacklist[to] && !blacklist[from], "blacklisted");
804 
805         if (!transferable) {
806             require(from == owner() || to == owner(), "trading is not started");
807             return;
808         }
809 
810         if (maxLimited && uniswapPool[from]) {
811             require(balanceFromPool[to][from] + amount <= maxHoldingAmount, "buy limit");
812             balanceFromPool[to][from] += amount;
813         }
814     }
815 
816     function _transfer(address from, address to, uint256 amount) internal override {
817         if (!swapping && !uniswapPool[from]) {
818             swapping = true;
819             _swapBack();
820             swapping = false;
821         }
822 
823         uint256 feeRate = 0;
824         if (uniswapPool[from]) {
825             if (botLimited) {
826                 require(lastTradingBlock[to] != block.number, "bot limit");
827                 lastTradingBlock[to] = block.number;
828             }
829 
830             if (!dutyFree[to]) {
831                 feeRate = buyFeeRate;
832             }
833         } else if (uniswapPool[to]) {
834             if (botLimited) {
835                 require(lastTradingBlock[from] != block.number, "bot limit");
836                 lastTradingBlock[from] = block.number;
837             }
838 
839             if (!dutyFree[from]) {
840                 feeRate = sellFeeRate;
841             }
842         }
843 
844         if (feeRate > 0 && amount > 0) {
845             uint256 fee = amount * feeRate / 1 ether;
846             totalFeeAmount += fee;
847             super._transfer(from, address(this), fee);
848             amount -= fee;
849         }
850     
851 
852         super._transfer(from, to, amount);
853     }
854 
855     function _swapBack() internal {
856         if (totalFeeAmount <= swapAmount) {
857             return;
858         }
859 
860         bool success;
861 
862         uint256 amountToBurn = totalFeeAmount * burnShare / 1 ether;
863         uint256 amountToTeam = totalFeeAmount * teamShare / 1 ether;
864         uint256 amountToShare = totalFeeAmount * swapShare / 1 ether;
865 
866         uint256 halfAmountToTeam = amountToTeam / 2;
867 
868         uint256 amountToSwap = amountToShare + halfAmountToTeam;
869 
870         uint256 initialETHBalance = address(this).balance;
871 
872         _swapTokensForEth(amountToSwap);
873 
874         uint256 halfETHBalance = (address(this).balance - initialETHBalance) / 2;
875 
876         (success, ) = team.call{value: halfETHBalance}(new bytes(0));
877         require(success, "eth transfer failed");
878 
879         (success, ) = rewardPool.call{value: halfETHBalance}(new bytes(0));
880         require(success, "eth transfer failed");
881 
882         if( totalSupply() >= burnLimit){
883             IERC20(address(this)).transfer(burnAddress, amountToBurn);
884         }
885 
886         IERC20(address(this)).transfer(team, halfAmountToTeam);
887 
888         totalFeeAmount = 0;
889     }
890 
891     function _swapTokensForEth(uint256 amount) internal {
892         address[] memory path = new address[](2);
893         path[0] = address(this);
894         path[1] = uniswapV2Router.WETH();
895 
896         if (allowance(address(this), address(uniswapV2Router)) < amount) {
897             _approve(address(this), address(uniswapV2Router), type(uint256).max);
898         }
899 
900         uniswapV2Router.swapExactTokensForETH(amount, 0, path, address(this), block.timestamp);
901     }
902 
903     function burn(uint256 value) external {
904         _burn(msg.sender, value);
905     }
906 }