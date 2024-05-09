1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.15;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `to`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address to, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `from` to `to` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address from,
70         address to,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 abstract contract Ownable is Context {
107     address private _owner;
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     /**
112      * @dev Initializes the contract setting the deployer as the initial owner.
113      */
114     constructor() {
115         _transferOwnership(_msgSender());
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
130         _;
131     }
132 
133     /**
134      * @dev Leaves the contract without owner. It will not be possible to call
135      * `onlyOwner` functions anymore. Can only be called by the current owner.
136      *
137      * NOTE: Renouncing ownership will leave the contract without an owner,
138      * thereby removing any functionality that is only available to the owner.
139      */
140     function renounceOwnership() public virtual onlyOwner {
141         _transferOwnership(address(0));
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         _transferOwnership(newOwner);
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Internal function without access restriction.
156      */
157     function _transferOwnership(address newOwner) internal virtual {
158         address oldOwner = _owner;
159         _owner = newOwner;
160         emit OwnershipTransferred(oldOwner, newOwner);
161     }
162 }
163 
164 interface IUniswapV2Factory {
165     function createPair(address tokenA, address tokenB) external returns (address pair);
166 }
167 
168 interface IUniswapV2Pair {
169     function sync() external;
170 }
171 
172 interface IUniswapV2Router01 {
173     function factory() external pure returns (address);
174 }
175 
176 interface IUniswapV2Router02 is IUniswapV2Router01 {
177     function removeLiquidityETHSupportingFeeOnTransferTokens(
178         address token,
179         uint256 liquidity,
180         uint256 amountTokenMin,
181         uint256 amountETHMin,
182         address to,
183         uint256 deadline
184     ) external returns (uint256 amountETH);
185 
186     function swapExactTokensForETHSupportingFeeOnTransferTokens(
187         uint256 amountIn,
188         uint256 amountOutMin,
189         address[] calldata path,
190         address to,
191         uint256 deadline
192     ) external;
193 
194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
195         uint256 amountIn,
196         uint256 amountOutMin,
197         address[] calldata path,
198         address to,
199         uint256 deadline
200     ) external;
201 
202     function swapExactETHForTokensSupportingFeeOnTransferTokens(
203         uint256 amountOutMin,
204         address[] calldata path,
205         address to,
206         uint256 deadline
207     ) external payable;
208 }
209 
210 abstract contract RibeToken
211 {
212     function buyFeePercentage() external view virtual returns(uint);
213     function onBuyFeeCollected(address tokenAddress, uint amount) external virtual;
214     function sellFeePercentage() external view virtual returns(uint);
215     function onSellFeeCollected(address tokenAddress, uint amount) external virtual;
216 }
217 
218 
219 contract Skoll is Context, IERC20, IERC20Metadata, Ownable, RibeToken {
220     // Openzeppelin variables
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     // My variables
231 
232     bool private inSwap;
233     uint256 internal _treasuryFeeCollected;
234     uint256 internal _nftHoldersFeeCollected;
235     uint256 internal _deployerFeeCollected;
236 
237     uint256 public minTokensBeforeSwap;
238     
239     address public treasury_wallet;
240     address public nft_holders_wallet;
241     address public deployer_wallet;
242 
243     address public usdcAddress;
244     address public hatiAddress;
245 
246     IUniswapV2Router02 public router;
247     address public uniswapPair;
248     address public ribeswapPair;
249 
250     uint public _feeDecimal = 2;
251     // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
252     uint[] public _treasuryFee;
253     uint[] public _nftHoldersFee;
254     uint[] public _deployerFee;
255 
256     bool public swapEnabled = true;
257     bool public isFeeActive = false;
258 
259     mapping(address => bool) public isTaxless;
260 
261     event Swap(uint swaped, uint sentToTreasury, uint sentToNFTHolders, uint sentToDeployer);
262     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
263 
264     // Ribe Compatibility variables
265     uint public treasuryUSDAmount;
266     uint public minTreasuryUSDCBeforeSwap;
267     uint public ribeBuyFeePercentage = 400;
268     uint public ribeSellFeePercentage = 400;
269     uint public ribeTreasuryPercentage = 5000;
270     uint public ribeNFTHoldersPercentage = 2500;
271     uint public ribeDeployerPercentage = 2500;
272 
273     bool public isLaunched = false;
274 
275     // Anti bots
276     mapping(address => uint256) public _blockNumberByAddress;
277     bool public antiBotsActive = false;
278     mapping(address => bool) public isContractExempt;
279     uint public blockCooldownAmount;
280     // End anti bots
281 
282     // Openzeppelin functions
283 
284     /**
285      * @dev Sets the values for {name} and {symbol}.
286      *
287      * The default value of {decimals} is 18. To select a different value for
288      * {decimals} you should overload it.
289      *
290      * All two of these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor() {
294         // Editable
295         string memory e_name = "SKOLL";
296         string memory e_symbol = "SKOLL";
297         treasury_wallet = 0x21D585b52B802C5fcA579f68b359F77EE6Fc342d;
298         nft_holders_wallet = 0xa414518f7cBdAA6D1C2F4A06E1Aebff5209B6806;
299         deployer_wallet = 0xf0Bc35eFCc611eb89181cC73EB712650FCdC9087;
300         uint e_totalSupply = 333_333_333_333_333 ether;
301         blockCooldownAmount = 5;
302         minTokensBeforeSwap = (_totalSupply * 100) / 10000; // Autoswap on Uni 1% of Skoll Supply
303         minTreasuryUSDCBeforeSwap = 2_000_000_000;           // Autoswap on Ribe 2000 USDC by default
304         // End editable
305 
306         usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
307         hatiAddress = 0x251457b7c5d85251Ca1aB384361c821330bE2520;
308  
309         _name = e_name;
310         _symbol = e_symbol;
311 
312         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), usdcAddress);
314         ribeswapPair = IUniswapV2Factory(0x5ACcFe50F9D5A9F3cdAB8864943250b1074146b1).createPair(address(this), usdcAddress);
315         router = _uniswapV2Router;
316 
317         _treasuryFee.push(100);
318         _treasuryFee.push(100);
319         _treasuryFee.push(0);
320 
321         _nftHoldersFee.push(100);
322         _nftHoldersFee.push(100);
323         _nftHoldersFee.push(0);
324 
325         _deployerFee.push(100);
326         _deployerFee.push(100);
327         _deployerFee.push(0);
328 
329         isTaxless[msg.sender] = true;
330         isTaxless[address(this)] = true;
331         isTaxless[treasury_wallet] = true;
332         isTaxless[nft_holders_wallet] = true;
333         isTaxless[deployer_wallet] = true;
334         isTaxless[address(0)] = true;
335 
336         isContractExempt[address(this)] = true;
337 
338         _mint(msg.sender, e_totalSupply);
339     }
340 
341     /**
342      * @dev Returns the name of the token.
343      */
344     function name() public view virtual override returns (string memory) {
345         return _name;
346     }
347 
348     /**
349      * @dev Returns the symbol of the token, usually a shorter version of the
350      * name.
351      */
352     function symbol() public view virtual override returns (string memory) {
353         return _symbol;
354     }
355 
356     /**
357      * @dev Returns the number of decimals used to get its user representation.
358      * For example, if `decimals` equals `2`, a balance of `505` tokens should
359      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
360      *
361      * Tokens usually opt for a value of 18, imitating the relationship between
362      * Ether and Wei. This is the value {ERC20} uses, unless this function is
363      * overridden;
364      *
365      * NOTE: This information is only used for _display_ purposes: it in
366      * no way affects any of the arithmetic of the contract, including
367      * {IERC20-balanceOf} and {IERC20-transfer}.
368      */
369     function decimals() public view virtual override returns (uint8) {
370         return 18;
371     }
372 
373     /**
374      * @dev See {IERC20-totalSupply}.
375      */
376     function totalSupply() public view virtual override returns (uint256) {
377         return _totalSupply;
378     }
379 
380     /**
381      * @dev See {IERC20-balanceOf}.
382      */
383     function balanceOf(address account) public view virtual override returns (uint256) {
384         return _balances[account];
385     }
386 
387     /**
388      * @dev See {IERC20-transfer}.
389      *
390      * Requirements:
391      *
392      * - `to` cannot be the zero address.
393      * - the caller must have a balance of at least `amount`.
394      */
395     function transfer(address to, uint256 amount) public virtual override returns (bool) {
396         address owner = _msgSender();
397         _transfer(owner, to, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-allowance}.
403      */
404     function allowance(address owner, address spender) public view virtual override returns (uint256) {
405         return _allowances[owner][spender];
406     }
407 
408     /**
409      * @dev See {IERC20-approve}.
410      *
411      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
412      * `transferFrom`. This is semantically equivalent to an infinite approval.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function approve(address spender, uint256 amount) public virtual override returns (bool) {
419         address owner = _msgSender();
420         _approve(owner, spender, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-transferFrom}.
426      *
427      * Emits an {Approval} event indicating the updated allowance. This is not
428      * required by the EIP. See the note at the beginning of {ERC20}.
429      *
430      * NOTE: Does not update the allowance if the current allowance
431      * is the maximum `uint256`.
432      *
433      * Requirements:
434      *
435      * - `from` and `to` cannot be the zero address.
436      * - `from` must have a balance of at least `amount`.
437      * - the caller must have allowance for ``from``'s tokens of at least
438      * `amount`.
439      */
440     function transferFrom(
441         address from,
442         address to,
443         uint256 amount
444     ) public virtual override returns (bool) {
445         address spender = _msgSender();
446         _spendAllowance(from, spender, amount);
447         _transfer(from, to, amount);
448         return true;
449     }
450 
451     /**
452      * @dev Atomically increases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
464         address owner = _msgSender();
465         _approve(owner, spender, _allowances[owner][spender] + addedValue);
466         return true;
467     }
468 
469     /**
470      * @dev Atomically decreases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      * - `spender` must have allowance for the caller of at least
481      * `subtractedValue`.
482      */
483     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
484         address owner = _msgSender();
485         uint256 currentAllowance = _allowances[owner][spender];
486         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
487         unchecked {
488             _approve(owner, spender, currentAllowance - subtractedValue);
489         }
490 
491         return true;
492     }
493 
494     /**
495      * @dev Moves `amount` of tokens from `sender` to `recipient`.
496      *
497      * This internal function is equivalent to {transfer}, and can be used to
498      * e.g. implement automatic token fees, slashing mechanisms, etc.
499      *
500      * Emits a {Transfer} event.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `from` must have a balance of at least `amount`.
507      */
508     function _transfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {
513         require(from != address(0), "ERC20: transfer from the zero address");
514         require(to != address(0), "ERC20: transfer to the zero address");
515 
516         _beforeTokenTransfer(from, to, amount);
517 
518         // My implementation
519         require(isLaunched || from == owner() || (to!=uniswapPair && to!=ribeswapPair), "Please wait to add liquidity!");
520 
521         if(from!=ribeswapPair && to!=ribeswapPair)
522         {
523             // Anti bots
524             if(antiBotsActive)
525             {
526                 if(!isContractExempt[from] && !isContractExempt[to])
527                 {
528                     address human = ensureOneHuman(from, to);
529                     ensureMaxTxFrequency(human);
530                     _blockNumberByAddress[human] = block.number;
531                 }
532             }
533             // End anti bots
534 
535             if (swapEnabled && !inSwap && from != uniswapPair) {
536                 swap();
537             }
538 
539             uint256 feesCollected;
540             if (isFeeActive && !isTaxless[from] && !isTaxless[to] && !inSwap) {
541                 bool sell = to == uniswapPair;
542                 bool p2p = from != uniswapPair && to != uniswapPair;
543                 feesCollected = calculateFee(p2p ? 2 : sell ? 1 : 0, amount);
544             }
545 
546             amount -= feesCollected;
547             _balances[from] -= feesCollected;
548             _balances[address(this)] += feesCollected;
549         }
550         // End my implementation
551 
552         uint256 fromBalance = _balances[from];
553         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
554         unchecked {
555             _balances[from] = fromBalance - amount;
556         }
557         _balances[to] += amount;
558 
559         emit Transfer(from, to, amount);
560 
561         _afterTokenTransfer(from, to, amount);
562     }
563 
564     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
565      * the total supply.
566      *
567      * Emits a {Transfer} event with `from` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      */
573     function _mint(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: mint to the zero address");
575 
576         _beforeTokenTransfer(address(0), account, amount);
577 
578         _totalSupply += amount;
579         _balances[account] += amount;
580         emit Transfer(address(0), account, amount);
581 
582         _afterTokenTransfer(address(0), account, amount);
583     }
584 
585     /**
586      * @dev Destroys `amount` tokens from `account`, reducing the
587      * total supply.
588      *
589      * Emits a {Transfer} event with `to` set to the zero address.
590      *
591      * Requirements:
592      *
593      * - `account` cannot be the zero address.
594      * - `account` must have at least `amount` tokens.
595      */
596     function _burn(address account, uint256 amount) internal virtual {
597         require(account != address(0), "ERC20: burn from the zero address");
598 
599         _beforeTokenTransfer(account, address(0), amount);
600 
601         uint256 accountBalance = _balances[account];
602         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
603         unchecked {
604             _balances[account] = accountBalance - amount;
605         }
606         _totalSupply -= amount;
607 
608         emit Transfer(account, address(0), amount);
609 
610         _afterTokenTransfer(account, address(0), amount);
611     }
612 
613     /**
614      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
615      *
616      * This internal function is equivalent to `approve`, and can be used to
617      * e.g. set automatic allowances for certain subsystems, etc.
618      *
619      * Emits an {Approval} event.
620      *
621      * Requirements:
622      *
623      * - `owner` cannot be the zero address.
624      * - `spender` cannot be the zero address.
625      */
626     function _approve(
627         address owner,
628         address spender,
629         uint256 amount
630     ) internal virtual {
631         require(owner != address(0), "ERC20: approve from the zero address");
632         require(spender != address(0), "ERC20: approve to the zero address");
633 
634         _allowances[owner][spender] = amount;
635         emit Approval(owner, spender, amount);
636     }
637 
638     /**
639      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
640      *
641      * Does not update the allowance amount in case of infinite allowance.
642      * Revert if not enough allowance is available.
643      *
644      * Might emit an {Approval} event.
645      */
646     function _spendAllowance(
647         address owner,
648         address spender,
649         uint256 amount
650     ) internal virtual {
651         uint256 currentAllowance = allowance(owner, spender);
652         if (currentAllowance != type(uint256).max) {
653             require(currentAllowance >= amount, "ERC20: insufficient allowance");
654             unchecked {
655                 _approve(owner, spender, currentAllowance - amount);
656             }
657         }
658     }
659 
660     /**
661      * @dev Hook that is called before any transfer of tokens. This includes
662      * minting and burning.
663      *
664      * Calling conditions:
665      *
666      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
667      * will be transferred to `to`.
668      * - when `from` is zero, `amount` tokens will be minted for `to`.
669      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
670      * - `from` and `to` are never both zero.
671      *
672      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
673      */
674     function _beforeTokenTransfer(
675         address from,
676         address to,
677         uint256 amount
678     ) internal virtual {}
679 
680     /**
681      * @dev Hook that is called after any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * has been transferred to `to`.
688      * - when `from` is zero, `amount` tokens have been minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _afterTokenTransfer(
695         address from,
696         address to,
697         uint256 amount
698     ) internal virtual {}
699 
700     // My functions
701 
702     modifier lockTheSwap() {
703         inSwap = true;
704         _;
705         inSwap = false;
706     }
707 
708     function sendViaCall(address payable _to, uint amount) private {
709         (bool sent, bytes memory data) = _to.call{value: amount}("");
710         data;
711         require(sent, "Failed to send Ether");
712     }
713 
714     function swap() private lockTheSwap {
715         // How much are we swaping?
716         uint totalCollected = _treasuryFeeCollected + _nftHoldersFeeCollected + _deployerFeeCollected;
717 
718         if(minTokensBeforeSwap > totalCollected) return;
719 
720         // Let's swap for USDC now
721         address[] memory sellPath = new address[](2);
722         sellPath[0] = address(this);
723         sellPath[1] = usdcAddress;
724 
725         address[] memory sellPathHati = new address[](3);
726         sellPathHati[0] = address(this);
727         sellPathHati[1] = usdcAddress;
728         sellPathHati[2] = hatiAddress;    
729 
730         _approve(address(this), address(router), totalCollected);
731         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
732             _treasuryFeeCollected,
733             0,
734             sellPathHati,
735             treasury_wallet,
736             block.timestamp
737         );
738         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
739             _nftHoldersFeeCollected,
740             0,
741             sellPath,
742             nft_holders_wallet,
743             block.timestamp
744         );
745         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
746             _deployerFeeCollected,
747             0,
748             sellPath,
749             deployer_wallet,
750             block.timestamp
751         );
752         
753         _treasuryFeeCollected = 0;
754         _nftHoldersFeeCollected = 0;
755         _deployerFeeCollected = 0;
756 
757         emit Swap(totalCollected, _treasuryFeeCollected, _nftHoldersFeeCollected, _deployerFeeCollected);
758     }
759 
760     function calculateFee(uint256 feeIndex, uint256 amount) internal returns(uint256) {
761         uint256 treasuryFee = (amount * _treasuryFee[feeIndex]) / (10**(_feeDecimal + 2));
762         uint256 nftHoldersFee = (amount * _nftHoldersFee[feeIndex]) / (10**(_feeDecimal + 2));
763         uint256 deployerFee = (amount * _deployerFee[feeIndex]) / (10**(_feeDecimal + 2));
764         
765         _treasuryFeeCollected += treasuryFee;
766         _nftHoldersFeeCollected += nftHoldersFee;
767         _deployerFeeCollected += deployerFee;
768         return treasuryFee + nftHoldersFee + deployerFee;
769     }
770 
771     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
772         minTokensBeforeSwap = amount;
773     }
774 
775     function setTreasuryWallet(address wallet)  external onlyOwner {
776         treasury_wallet = wallet;
777     }
778 
779     function setNFTHoldersWallet(address wallet)  external onlyOwner {
780         nft_holders_wallet = wallet;
781     }
782 
783     function setDeployerWallet(address wallet)  external onlyOwner {
784         deployer_wallet = wallet;
785     }
786 
787     function setTreasuryFees(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
788         _treasuryFee[0] = buy;
789         _treasuryFee[1] = sell;
790         _treasuryFee[2] = p2p;
791     }
792 
793     function setNFTHoldersFees(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
794         _nftHoldersFee[0] = buy;
795         _nftHoldersFee[1] = sell;
796         _nftHoldersFee[2] = p2p;
797     }
798 
799     function setDeployerFees(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
800         _deployerFee[0] = buy;
801         _deployerFee[1] = sell;
802         _deployerFee[2] = p2p;
803     }
804 
805     function setSwapEnabled(bool enabled) external onlyOwner {
806         swapEnabled = enabled;
807     }
808 
809     function setFeeActive(bool value) external onlyOwner {
810         isFeeActive = value;
811     }
812 
813     function setTaxless(address account, bool value) external onlyOwner {
814         isTaxless[account] = value;
815     }
816 
817     // Anti bots
818     function isContract(address account) internal view returns (bool) {
819         uint256 size;
820         assembly {
821             size := extcodesize(account)
822         }
823         return size > 0;
824     }
825 
826     function ensureOneHuman(address _to, address _from) internal virtual returns (address) {
827         require(!isContract(_to) || !isContract(_from), "No bots allowed!");
828         if (isContract(_to)) return _from;
829         else return _to;
830     }
831 
832     function ensureMaxTxFrequency(address addr) internal virtual {
833         bool isAllowed = _blockNumberByAddress[addr] == 0 ||
834             ((_blockNumberByAddress[addr] + blockCooldownAmount) < (block.number + 1));
835         require(isAllowed, "Max tx frequency exceeded!");
836     }
837 
838     function setAntiBotsActive(bool value) external onlyOwner {
839         antiBotsActive = value;
840     }
841 
842     function setBlockCooldown(uint value) external onlyOwner {
843         blockCooldownAmount = value;
844     }
845 
846     function setContractExempt(address account, bool value) external onlyOwner {
847         isContractExempt[account] = value;
848     }
849     // End anti bots
850 
851     // Ribe Functions
852 
853     function baseTokenOwnerWithdraw(address destination, address token, uint amount) public onlyOwner {
854         IERC20(token).transfer(destination, amount);
855     }
856 
857     function calculateRibeFee(uint256 amount, uint256 feePercentage, uint256 feeDecimal) internal pure returns(uint256) {
858         return (amount * feePercentage) / (10**(feeDecimal + 2));
859     }
860 
861     function buyFeePercentage() external view override returns(uint)
862     {
863         return ribeBuyFeePercentage;
864     }
865 
866     function sellFeePercentage() external view override returns(uint)
867     {
868         return ribeSellFeePercentage;
869     }
870 
871     function setMinTreasuryUSDCBeforeSwap(uint amount) public onlyOwner
872     {
873         minTreasuryUSDCBeforeSwap = amount;
874     }
875 
876     function setRibeBuyFeePercentage(uint amount) public onlyOwner
877     {
878         ribeBuyFeePercentage = amount;
879     }
880 
881     function setRibeSellFeePercentage(uint amount) public onlyOwner
882     {
883         ribeSellFeePercentage = amount;
884     }
885 
886     function setRibeTreasuryPercentage(uint amount) public onlyOwner
887     {
888         ribeTreasuryPercentage = amount;
889     }
890 
891 
892     function setRibeNFTHoldersPercentage(uint amount) public onlyOwner
893     {
894         ribeNFTHoldersPercentage = amount;
895     }
896 
897 
898     function setRibeDeployerPercentage(uint amount) public onlyOwner
899     {
900         ribeDeployerPercentage = amount;
901     }
902 
903     function launch() public onlyOwner
904     {
905         isLaunched = true;
906     }
907 
908     function swapTreasuryUSDForRibe() public
909     {
910         address[] memory sellPath = new address[](2);
911         sellPath[0] = usdcAddress;
912         sellPath[1] = hatiAddress;
913 
914         IERC20(usdcAddress).approve(address(router), treasuryUSDAmount);
915         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
916             treasuryUSDAmount,
917             0,
918             sellPath,
919             treasury_wallet,
920             block.timestamp
921         );
922         treasuryUSDAmount = 0;
923     }
924 
925     function processRibeFees(address tokenAddress, uint amount) internal
926     {
927         if(tokenAddress == usdcAddress)
928         {
929             treasuryUSDAmount += calculateRibeFee(amount, ribeTreasuryPercentage, 2);
930             uint nft_holders_amount = calculateRibeFee(amount, ribeNFTHoldersPercentage, 2);
931             uint deployer_amount = calculateRibeFee(amount, ribeDeployerPercentage, 2);
932 
933             if(treasuryUSDAmount > minTreasuryUSDCBeforeSwap)
934             {
935                 swapTreasuryUSDForRibe();
936             }
937             if(nft_holders_amount > 0)
938                 IERC20(tokenAddress).transfer(nft_holders_wallet, nft_holders_amount);
939             if(deployer_amount > 0)
940                 IERC20(tokenAddress).transfer(deployer_wallet, deployer_amount);
941         }else
942         {
943             IERC20(tokenAddress).transfer(owner(), amount);
944         }
945     }
946 
947     function onBuyFeeCollected(address tokenAddress, uint amount) external override
948     {
949         processRibeFees(tokenAddress, amount);
950     }
951 
952     function onSellFeeCollected(address tokenAddress, uint amount) external override
953     {
954         processRibeFees(tokenAddress, amount);
955     }
956 
957     fallback() external payable {}
958     receive() external payable {}
959 }