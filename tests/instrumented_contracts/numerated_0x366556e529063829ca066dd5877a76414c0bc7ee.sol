1 /**
2 
3 Welcome to CHELLA!
4 
5  */
6 
7 // SPDX-License-Identifier: MIT
8 
9 
10 pragma solidity ^0.8.9;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50 
51      */
52     function transferFrom(
53         address sender,
54         address recipient,
55         uint256 amount
56     ) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @dev Interface for the optional metadata functions from the ERC20 standard.
75  *
76  * _Available since v4.1._
77  */
78 interface IERC20Metadata is IERC20 {
79     /**
80      * @dev Returns the name of the token.
81      */
82     function name() external view returns (string memory);
83 
84     /**
85      * @dev Returns the symbol of the token.
86      */
87     function symbol() external view returns (string memory);
88 
89     /**
90      * @dev Returns the decimals places of the token.
91      */
92     function decimals() external view returns (uint8);
93 }
94 
95 /*
96 
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 /**
109 
110  */
111 contract ERC20 is Context, IERC20, IERC20Metadata {
112     mapping(address => uint256) private _balances;
113 
114     mapping(address => mapping(address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120 
121     /**
122 
123      */
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @dev Returns the symbol of the token, usually a shorter version of the
138      * name.
139      */
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145 
146      */
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     /**
152      * @dev See {IERC20-totalSupply}.
153      */
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157 
158     /**
159      * @dev See {IERC20-balanceOf}.
160      */
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164 
165     /**
166      * @dev See {IERC20-transfer}.
167      *
168      * Requirements:
169      *
170      * - `recipient` cannot be the zero address.
171      * - the caller must have a balance of at least `amount`.
172      */
173     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
174         _transfer(_msgSender(), recipient, amount);
175         return true;
176     }
177 
178     /**
179      * @dev See {IERC20-allowance}.
180      */
181     function allowance(address owner, address spender) public view virtual override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     /**
186      * @dev See {IERC20-approve}.
187      *
188      * Requirements:
189      *
190      * - `spender` cannot be the zero address.
191      */
192     function approve(address spender, uint256 amount) public virtual override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     /**
198      * @dev See {IERC20-transferFrom}.
199      *
200      * Emits an {Approval} event indicating the updated allowance. This is not
201      * required by the EIP. See the note at the beginning of {ERC20}.
202      *
203      * Requirements:
204      *
205      * - `sender` and `recipient` cannot be the zero address.
206      * - `sender` must have a balance of at least `amount`.
207      * - the caller must have allowance for ``sender``'s tokens of at least
208      * `amount`.
209      */
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) public virtual override returns (bool) {
215         _transfer(sender, recipient, amount);
216 
217         uint256 currentAllowance = _allowances[sender][_msgSender()];
218         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
219         unchecked {
220             _approve(sender, _msgSender(), currentAllowance - amount);
221         }
222 
223         return true;
224     }
225 
226     /**
227     
228      */
229     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
230         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
231         return true;
232     }
233 
234     /**
235    
236      */
237     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
238         uint256 currentAllowance = _allowances[_msgSender()][spender];
239         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
240         unchecked {
241             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
242         }
243 
244         return true;
245     }
246 
247     /**
248      
249      */
250     function _transfer(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) internal virtual {
255         require(sender != address(0), "ERC20: transfer from the zero address");
256         require(recipient != address(0), "ERC20: transfer to the zero address");
257 
258         _beforeTokenTransfer(sender, recipient, amount);
259 
260         uint256 senderBalance = _balances[sender];
261         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
262         unchecked {
263             _balances[sender] = senderBalance - amount;
264         }
265         _balances[recipient] += amount;
266 
267         emit Transfer(sender, recipient, amount);
268 
269         _afterTokenTransfer(sender, recipient, amount);
270     }
271 
272     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
273      * the total supply.
274      *
275      * Emits a {Transfer} event with `from` set to the zero address.
276      *
277      * Requirements:
278      *
279      * - `account` cannot be the zero address.
280      */
281     function _mint(address account, uint256 amount) internal virtual {
282         require(account != address(0), "ERC20: mint to the zero address");
283 
284         _beforeTokenTransfer(address(0), account, amount);
285 
286         _totalSupply += amount;
287         _balances[account] += amount;
288         emit Transfer(address(0), account, amount);
289 
290         _afterTokenTransfer(address(0), account, amount);
291     }
292 
293     /**
294      * @dev Destroys `amount` tokens from `account`, reducing the
295      * total supply.
296      *
297      * Emits a {Transfer} event with `to` set to the zero address.
298      *
299      * Requirements:
300      *
301      * - `account` cannot be the zero address.
302      * - `account` must have at least `amount` tokens.
303      */
304     function _burn(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: burn from the zero address");
306 
307         _beforeTokenTransfer(account, address(0), amount);
308 
309         uint256 accountBalance = _balances[account];
310         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
311         unchecked {
312             _balances[account] = accountBalance - amount;
313         }
314         _totalSupply -= amount;
315 
316         emit Transfer(account, address(0), amount);
317 
318         _afterTokenTransfer(account, address(0), amount);
319     }
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
323      *
324      * This internal function is equivalent to `approve`, and can be used to
325      * e.g. set automatic allowances for certain subsystems, etc.
326      *
327      * Emits an {Approval} event.
328      *
329      * Requirements:
330      *
331      * - `owner` cannot be the zero address.
332      * - `spender` cannot be the zero address.
333      */
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) internal virtual {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341 
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     /**
347      * @dev Hook that is called before any transfer of tokens. This includes
348      * minting and burning.
349      *
350      * Calling conditions:
351      *
352      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
353      * will be transferred to `to`.
354      * - when `from` is zero, `amount` tokens will be minted for `to`.
355      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
356      * - `from` and `to` are never both zero.
357      *
358      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
359      */
360     function _beforeTokenTransfer(
361         address from,
362         address to,
363         uint256 amount
364     ) internal virtual {}
365 
366     /**
367      * @dev Hook that is called after any transfer of tokens. This includes
368      * minting and burning.
369      *
370      * Calling conditions:
371      *
372      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
373      * has been transferred to `to`.
374      * - when `from` is zero, `amount` tokens have been minted for `to`.
375      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
376      * - `from` and `to` are never both zero.
377      *
378      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
379      */
380     function _afterTokenTransfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {}
385 }
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 abstract contract Ownable is Context {
400     address private _owner;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor() {
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view virtual returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(owner() == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         _setOwner(address(0));
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         _setOwner(newOwner);
443     }
444 
445     function _setOwner(address newOwner) internal {
446         address oldOwner = _owner;
447         _owner = newOwner;
448         emit OwnershipTransferred(oldOwner, newOwner);
449     }
450 }
451 
452 /**
453 
454  */
455 abstract contract Pausable is Context {
456     /**
457      * @dev Emitted when the pause is triggered by `account`.
458      */
459     event Paused(address account);
460 
461     /**
462      * @dev Emitted when the pause is lifted by `account`.
463      */
464     event Unpaused(address account);
465 
466     bool private _paused;
467 
468     /**
469      * @dev Initializes the contract in unpaused state.
470      */
471     constructor() {
472         _paused = false;
473     }
474 
475     /**
476      * @dev Returns true if the contract is paused, and false otherwise.
477      */
478     function paused() public view virtual returns (bool) {
479         return _paused;
480     }
481 
482     /**
483      * @dev Modifier to make a function callable only when the contract is not paused.
484      *
485      * Requirements:
486      *
487      * - The contract must not be paused.
488      */
489     modifier whenNotPaused() {
490         require(!paused(), "Pausable: paused");
491         _;
492     }
493 
494     /**
495      * @dev Modifier to make a function callable only when the contract is paused.
496      *
497      * Requirements:
498      *
499      * - The contract must be paused.
500      */
501     modifier whenPaused() {
502         require(paused(), "Pausable: not paused");
503         _;
504     }
505 
506     /**
507      * @dev Triggers stopped state.
508      *
509      * Requirements:
510      *
511      * - The contract must not be paused.
512      */
513     function _pause() internal virtual whenNotPaused {
514         _paused = true;
515         emit Paused(_msgSender());
516     }
517 
518     /**
519      * @dev Returns to normal state.
520      *
521      * Requirements:
522      *
523      * - The contract must be paused.
524      */
525     function _unpause() internal virtual whenPaused {
526         _paused = false;
527         emit Unpaused(_msgSender());
528     }
529 }
530 
531 interface IUniswapV2Pair {
532     event Approval(address indexed owner, address indexed spender, uint value);
533     event Transfer(address indexed from, address indexed to, uint value);
534 
535     function name() external pure returns (string memory);
536     function symbol() external pure returns (string memory);
537     function decimals() external pure returns (uint8);
538     function totalSupply() external view returns (uint);
539     function balanceOf(address owner) external view returns (uint);
540     function allowance(address owner, address spender) external view returns (uint);
541 
542     function approve(address spender, uint value) external returns (bool);
543     function transfer(address to, uint value) external returns (bool);
544     function transferFrom(address from, address to, uint value) external returns (bool);
545 
546     function DOMAIN_SEPARATOR() external view returns (bytes32);
547     function PERMIT_TYPEHASH() external pure returns (bytes32);
548     function nonces(address owner) external view returns (uint);
549 
550     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
551 
552     event Mint(address indexed sender, uint amount0, uint amount1);
553     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
554     event Swap(
555         address indexed sender,
556         uint amount0In,
557         uint amount1In,
558         uint amount0Out,
559         uint amount1Out,
560         address indexed to
561     );
562     event Sync(uint112 reserve0, uint112 reserve1);
563 
564     function MINIMUM_LIQUIDITY() external pure returns (uint);
565     function factory() external view returns (address);
566     function token0() external view returns (address);
567     function token1() external view returns (address);
568     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
569     function price0CumulativeLast() external view returns (uint);
570     function price1CumulativeLast() external view returns (uint);
571     function kLast() external view returns (uint);
572 
573     function mint(address to) external returns (uint liquidity);
574     function burn(address to) external returns (uint amount0, uint amount1);
575     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
576     function skim(address to) external;
577     function sync() external;
578 
579     function initialize(address, address) external;
580 }
581 
582 interface IUniswapV2Factory {
583     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
584 
585     function feeTo() external view returns (address);
586     function feeToSetter() external view returns (address);
587 
588     function getPair(address tokenA, address tokenB) external view returns (address pair);
589     function allPairs(uint) external view returns (address pair);
590     function allPairsLength() external view returns (uint);
591 
592     function createPair(address tokenA, address tokenB) external returns (address pair);
593 
594     function setFeeTo(address) external;
595     function setFeeToSetter(address) external;
596 }
597 
598 interface IUniswapV2Router01 {
599     function factory() external pure returns (address);
600     function WETH() external pure returns (address);
601 
602     function addLiquidity(
603         address tokenA,
604         address tokenB,
605         uint amountADesired,
606         uint amountBDesired,
607         uint amountAMin,
608         uint amountBMin,
609         address to,
610         uint deadline
611     ) external returns (uint amountA, uint amountB, uint liquidity);
612     function addLiquidityETH(
613         address token,
614         uint amountTokenDesired,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline
619     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
620     function removeLiquidity(
621         address tokenA,
622         address tokenB,
623         uint liquidity,
624         uint amountAMin,
625         uint amountBMin,
626         address to,
627         uint deadline
628     ) external returns (uint amountA, uint amountB);
629     function removeLiquidityETH(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline
636     ) external returns (uint amountToken, uint amountETH);
637     function removeLiquidityWithPermit(
638         address tokenA,
639         address tokenB,
640         uint liquidity,
641         uint amountAMin,
642         uint amountBMin,
643         address to,
644         uint deadline,
645         bool approveMax, uint8 v, bytes32 r, bytes32 s
646     ) external returns (uint amountA, uint amountB);
647     function removeLiquidityETHWithPermit(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline,
654         bool approveMax, uint8 v, bytes32 r, bytes32 s
655     ) external returns (uint amountToken, uint amountETH);
656     function swapExactTokensForTokens(
657         uint amountIn,
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external returns (uint[] memory amounts);
663     function swapTokensForExactTokens(
664         uint amountOut,
665         uint amountInMax,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external returns (uint[] memory amounts);
670     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
671         external
672         payable
673         returns (uint[] memory amounts);
674     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
675         external
676         returns (uint[] memory amounts);
677     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
678         external
679         returns (uint[] memory amounts);
680     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
681         external
682         payable
683         returns (uint[] memory amounts);
684 
685     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
686     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
687     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
688     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
689     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
690 }
691 
692 interface IUniswapV2Router02 is IUniswapV2Router01 {
693     function removeLiquidityETHSupportingFeeOnTransferTokens(
694         address token,
695         uint liquidity,
696         uint amountTokenMin,
697         uint amountETHMin,
698         address to,
699         uint deadline
700     ) external returns (uint amountETH);
701     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
702         address token,
703         uint liquidity,
704         uint amountTokenMin,
705         uint amountETHMin,
706         address to,
707         uint deadline,
708         bool approveMax, uint8 v, bytes32 r, bytes32 s
709     ) external returns (uint amountETH);
710 
711     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
712         uint amountIn,
713         uint amountOutMin,
714         address[] calldata path,
715         address to,
716         uint deadline
717     ) external;
718     function swapExactETHForTokensSupportingFeeOnTransferTokens(
719         uint amountOutMin,
720         address[] calldata path,
721         address to,
722         uint deadline
723     ) external payable;
724     function swapExactTokensForETHSupportingFeeOnTransferTokens(
725         uint amountIn,
726         uint amountOutMin,
727         address[] calldata path,
728         address to,
729         uint deadline
730     ) external;
731 }
732 
733 contract CHELLA is ERC20, Ownable, Pausable {
734 
735     // variables
736     
737     uint256 private initialSupply;
738    
739     uint256 private denominator = 100;
740 
741     uint256 private swapThreshold = 0.000005 ether; // 
742     
743     uint256 private devTaxBuy;
744     uint256 private liquidityTaxBuy;
745    
746     
747     uint256 private devTaxSell;
748     uint256 private liquidityTaxSell;
749     uint256 public maxWallet;
750     
751     address private devTaxWallet;
752     address private liquidityTaxWallet;
753     
754     
755     // Mappings
756     
757     mapping (address => bool) private blacklist;
758     mapping (address => bool) private excludeList;
759    
760     
761     mapping (string => uint256) private buyTaxes;
762     mapping (string => uint256) private sellTaxes;
763     mapping (string => address) private taxWallets;
764     
765     bool public taxStatus = true;
766     
767     IUniswapV2Router02 private uniswapV2Router02;
768     IUniswapV2Factory private uniswapV2Factory;
769     IUniswapV2Pair private uniswapV2Pair;
770     
771     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
772     {
773         initialSupply =_supply * (10**18);
774         maxWallet = initialSupply * 2 / 100; //
775         _setOwner(msg.sender);
776         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
777         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
778         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
779         taxWallets["liquidity"] = address(0);
780         setBuyTax(8,2); //dev tax, liquidity tax
781         setSellTax(18,2); //dev tax, liquidity tax
782         setTaxWallets(0x3CEE6693a0E2dd4380B2b9B8DE17238C8BC07546); // 
783         exclude(msg.sender);
784         exclude(address(this));
785         exclude(devTaxWallet);
786         _mint(msg.sender, initialSupply);
787     }
788     
789     
790     uint256 private devTokens;
791     uint256 private liquidityTokens;
792     
793     
794     /**
795      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
796      */
797     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
798         address[] memory sellPath = new address[](2);
799         sellPath[0] = address(this);
800         sellPath[1] = uniswapV2Router02.WETH();
801         
802         if(!isExcluded(from) && !isExcluded(to)) {
803             uint256 tax;
804             uint256 baseUnit = amount / denominator;
805             if(from == address(uniswapV2Pair)) {
806                 tax += baseUnit * buyTaxes["dev"];
807                 tax += baseUnit * buyTaxes["liquidity"];
808                
809                 
810                 if(tax > 0) {
811                     _transfer(from, address(this), tax);   
812                 }
813                 
814                 
815                 devTokens += baseUnit * buyTaxes["dev"];
816                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
817 
818             } else if(to == address(uniswapV2Pair)) {
819                 
820                 tax += baseUnit * sellTaxes["dev"];
821                 tax += baseUnit * sellTaxes["liquidity"];
822                 
823                 
824                 if(tax > 0) {
825                     _transfer(from, address(this), tax);   
826                 }
827                 
828                
829                 devTokens += baseUnit * sellTaxes["dev"];
830                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
831                 
832                 
833                 uint256 taxSum =  devTokens + liquidityTokens;
834                 
835                 if(taxSum == 0) return amount;
836                 
837                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
838                 
839                 if(ethValue >= swapThreshold) {
840                     uint256 startBalance = address(this).balance;
841 
842                     uint256 toSell = devTokens + liquidityTokens / 2 ;
843                     
844                     _approve(address(this), address(uniswapV2Router02), toSell);
845             
846                     uniswapV2Router02.swapExactTokensForETH(
847                         toSell,
848                         0,
849                         sellPath,
850                         address(this),
851                         block.timestamp
852                     );
853                     
854                     uint256 ethGained = address(this).balance - startBalance;
855                     
856                     uint256 liquidityToken = liquidityTokens / 2;
857                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
858                     
859                     
860                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
861                    
862                     
863                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
864                     
865                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
866                         address(this),
867                         liquidityToken,
868                         0,
869                         0,
870                         taxWallets["liquidity"],
871                         block.timestamp
872                     );
873                     
874                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
875                     
876                     if(remainingTokens > 0) {
877                         _transfer(address(this), taxWallets["dev"], remainingTokens);
878                     }
879                     
880                     
881                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
882                    require(success, "transfer to  dev wallet failed");
883                     
884                     
885                     if(ethGained - ( devETH + liquidityETH) > 0) {
886                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
887                         require(success1, "transfer to  dev wallet failed");
888                     }
889 
890                     
891                     
892                     
893                     devTokens = 0;
894                     liquidityTokens = 0;
895                     
896                 }
897                 
898             }
899             
900             amount -= tax;
901             if (to != address(uniswapV2Pair)){
902                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
903             }
904            
905         }
906         
907         return amount;
908     }
909     
910     function _transfer(
911         address sender,
912         address recipient,
913         uint256 amount
914     ) internal override virtual {
915         require(!paused(), "ERC20: token transfer while paused");
916         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
917         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
918         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
919         
920         if(taxStatus) {
921             amount = handleTax(sender, recipient, amount);   
922         }
923 
924         super._transfer(sender, recipient, amount);
925     }
926     
927     /**
928      * @dev Triggers the tax handling functionality
929      */
930     function triggerTax() public onlyOwner {
931         handleTax(address(0), address(uniswapV2Pair), 0);
932     }
933     
934     /**
935      * @dev Pauses transfers on the token.
936      */
937     function pause() public onlyOwner {
938         require(!paused(), "ERC20: Contract is already paused");
939         _pause();
940     }
941 
942     /**
943      * @dev Unpauses transfers on the token.
944      */
945     function unpause() public onlyOwner {
946         require(paused(), "ERC20: Contract is not paused");
947         _unpause();
948     }
949 
950      /**
951      * @dev set max wallet limit per address.
952      */
953 
954     function setMaxWallet (uint256 amount) external onlyOwner {
955         require (amount > 10000, "NO rug pull");
956         maxWallet = amount * 10**18;
957     }
958     
959     /**
960      * @dev Burns tokens from caller address.
961      */
962     function burn(uint256 amount) public onlyOwner {
963         _burn(msg.sender, amount);
964     }
965     
966     /**
967      * @dev Blacklists the specified account (Disables transfers to and from the account).
968      */
969     function enableBlacklist(address account) public onlyOwner {
970         require(!blacklist[account], "ERC20: Account is already blacklisted");
971         blacklist[account] = true;
972     }
973     
974     /**
975      * @dev Remove the specified account from the blacklist.
976      */
977     function disableBlacklist(address account) public onlyOwner {
978         require(blacklist[account], "ERC20: Account is not blacklisted");
979         blacklist[account] = false;
980     }
981     
982     /**
983      * @dev Excludes the specified account from tax.
984      */
985     function exclude(address account) public onlyOwner {
986         require(!isExcluded(account), "ERC20: Account is already excluded");
987         excludeList[account] = true;
988     }
989     
990     /**
991      * @dev Re-enables tax on the specified account.
992      */
993     function removeExclude(address account) public onlyOwner {
994         require(isExcluded(account), "ERC20: Account is not excluded");
995         excludeList[account] = false;
996     }
997     
998     /**
999      * @dev Sets tax for buys.
1000      */
1001     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
1002         buyTaxes["dev"] = dev;
1003         buyTaxes["liquidity"] = liquidity;
1004        
1005     }
1006     
1007     /**
1008      * @dev Sets tax for sells.
1009      */
1010     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
1011 
1012         sellTaxes["dev"] = dev;
1013         sellTaxes["liquidity"] = liquidity;
1014         
1015     }
1016     
1017     /**
1018      * @dev Sets wallets for taxes.
1019      */
1020     function setTaxWallets(address dev) public onlyOwner {
1021         taxWallets["dev"] = dev;
1022         
1023     }
1024 
1025     function claimStuckTokens(address _token) external onlyOwner {
1026  
1027         if (_token == address(0x0)) {
1028             payable(owner()).transfer(address(this).balance);
1029             return;
1030         }
1031         IERC20 erc20token = IERC20(_token);
1032         uint256 balance = erc20token.balanceOf(address(this));
1033         erc20token.transfer(owner(), balance);
1034     }
1035     
1036     /**
1037      * @dev Enables tax globally.
1038      */
1039     function enableTax() public onlyOwner {
1040         require(!taxStatus, "ERC20: Tax is already enabled");
1041         taxStatus = true;
1042     }
1043     
1044     /**
1045      * @dev Disables tax globally.
1046      */
1047     function disableTax() public onlyOwner {
1048         require(taxStatus, "ERC20: Tax is already disabled");
1049         taxStatus = false;
1050     }
1051     
1052     /**
1053      * @dev Returns true if the account is blacklisted, and false otherwise.
1054      */
1055     function isBlacklisted(address account) public view returns (bool) {
1056         return blacklist[account];
1057     }
1058     
1059     /**
1060      * @dev Returns true if the account is excluded, and false otherwise.
1061      */
1062     function isExcluded(address account) public view returns (bool) {
1063         return excludeList[account];
1064     }
1065     
1066     receive() external payable {}
1067 }